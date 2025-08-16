pragma solidity =0.5.16;

import "./FuzzSetup.sol";
import "../mocks/IToken.sol";

contract FuzzHandlers is FuzzSetup {
    function uniswapV2Pair_approve(address spender, uint256 value) public asCurrentSender {
        uniswapV2Pair.approve(spender, value);
    }

    function uniswapV2Pair_burn(address to) public asCurrentSender {
        require(IToken(uniswapV2Pair.token0()).balanceOf(address(uniswapV2Pair)) > 0);
        require(IToken(uniswapV2Pair.token1()).balanceOf(address(uniswapV2Pair)) > 0);
        require(to != address(0));
        (bool success, bytes memory data) = address(uniswapV2Pair).call(
            abi.encodeWithSignature("burn(address)", to)
        );

        if (!success) {
            t(false, "uniswapV2Pair_burn failed");
            return;
        }

        (uint amount0, uint amount1) = abi.decode(data, (uint, uint));

        // If you actually want to store them:
        uint value0 = amount0;
        uint value1 = amount1;
    }

    function uniswapV2Pair_mint(address to) public asCurrentSender {
        uniswapV2Pair.mint(to);
    }

    function uniswapV2Pair_permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public asCurrentSender {
        uniswapV2Pair.permit(owner, spender, value, deadline, v, r, s);
    }

    function uniswapV2Pair_skim(address to) public asCurrentSender {
        uniswapV2Pair.skim(to);
    }

    function uniswapV2Pair_swap(uint256 amount0Out, uint256 amount1Out, address to, bytes memory data) public asCurrentSender {
        uniswapV2Pair.swap(amount0Out, amount1Out, to, data);
    }

    function uniswapV2Pair_sync() public asCurrentSender {
        uniswapV2Pair.sync();
    }

    function uniswapV2Pair_transfer(address to, uint256 value) public asCurrentSender {
        uniswapV2Pair.transfer(to, value);
    }

    function uniswapV2Pair_transferFrom(address from, address to, uint256 value) public asCurrentSender {
        uniswapV2Pair.transferFrom(from, to, value);
    }

    function tokenA_approve(address spender, uint256 amount) public asCurrentSender {
        tokenA.approve(spender, amount);
    }

    function tokenA_mint(address account, uint256 amount) public asCurrentSender {
        tokenA.mint(account, amount);
    }

    function tokenA_transfer(address recipient, uint256 amount) public asCurrentSender {
        tokenA.transfer(recipient, amount);
    }

    function tokenA_transferFrom(address sender, address recipient, uint256 amount) public asCurrentSender {
        tokenA.transferFrom(sender, recipient, amount);
    }

    function tokenB_approve(address spender, uint256 amount) public asCurrentSender {
        tokenB.approve(spender, amount);
    }

    function tokenB_mint(address account, uint256 amount) public asCurrentSender {
        tokenB.mint(account, amount);
    }

    function tokenB_transfer(address recipient, uint256 amount) public asCurrentSender {
        tokenB.transfer(recipient, amount);
    }

    function tokenB_transferFrom(address sender, address recipient, uint256 amount) public asCurrentSender {
        tokenB.transferFrom(sender, recipient, amount);
    }


}