pragma solidity =0.5.16;

import "./FuzzHandlers.sol";

contract FuzzClamped is FuzzHandlers {
    function clamped_uniswapV2Pair_mint(address to) public asCurrentSender swapB4After {
        (uint112 reserve0, uint112 reserve1,) = uniswapV2Pair.getReserves();
        emit ClammpedMint(uint256(ghost_b4_reserve0) * ghost_b4_reserve1);
        require(IToken(uniswapV2Pair.token0()).balanceOf(address(uniswapV2Pair)) > reserve0);
        require(IToken(uniswapV2Pair.token1()).balanceOf(address(uniswapV2Pair)) > reserve1);
        uniswapV2Pair_mint(to);
        (reserve0, reserve1,) = uniswapV2Pair.getReserves();
        emit ClammpedMint(uint256(reserve0) * reserve1);
        assert(uint256(ghost_b4_reserve0) * ghost_b4_reserve1 < uint256(reserve0) * reserve1);
    }
}
