pragma solidity =0.5.16;

import "./FuzzHandlers.sol";

contract FuzzProps is FuzzHandlers {
    function prop_pairInitialized() public view {
        assert(
            uniswapV2Pair.token0() != address(0) && uniswapV2Pair.token1() != address(0)
        );
    }

    function prop_factorySet() public view {
        assert(
            uniswapV2Factory.feeTo() != address(0)
        );
    }
}