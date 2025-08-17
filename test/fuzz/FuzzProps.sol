pragma solidity =0.5.16;

import './FuzzClamped.sol';

contract FuzzProps is FuzzClamped {
    function prop_uniswapV2Pair_swap() public asCurrentSender {
        require(ghost_after_reserve1 != 0);
        assert(uint256(ghost_b4_reserve0) * ghost_b4_reserve1 < uint256(ghost_after_reserve0) * ghost_after_reserve1);
        operationType = OperationType.None;
    }
}
