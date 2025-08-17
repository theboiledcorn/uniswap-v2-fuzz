pragma solidity =0.5.16;
import './FuzzHandlers.sol';
import '../mocks/IToken.sol';
import '../../lib/forge-std/src/console.sol';
import '../../lib/forge-std/src/console2.sol';

contract FuzzUnit is FuzzHandlers {
    // forge test --match-test test_clamped_uniswapV2Pair_swap_0 -vvv

    function test_clamped_uniswapV2Pair_swap_0() public {
        vm.roll(81393);
        vm.warp(904282);
        vm.prank(address(0x30000));
        tokenB_mint(
            address(uniswapV2Pair),
            840332354264620312024591792041412764035073137159274067034193793564409974178
        );

        vm.roll(81393);
        vm.warp(904282);
        vm.prank(address(0x50000));
        tokenA_mint(
            address(uniswapV2Pair),
            7125431825096381736919545066491022429681454693788543943179611835371250108262
        );

        vm.roll(81393);
        vm.warp(904282);
        vm.prank(address(0x40000));
        uniswapV2Pair_mint(address(0x30000));

        vm.roll(81393);
        vm.warp(904282);
        vm.prank(address(0x10000));
        tokenA_mint(
            0x67e604A6ca928f7C8E19AB6a134f0cd289a7488C,
            130478693621554802497951785898747820955496074381150335328219242208047542543
        );

        vm.roll(81393);
        vm.warp(904282);
        vm.prank(address(0x40000));
        clamped_uniswapV2Pair_swap(
            64183341559591861483491466659058081566550427156853019941246891473895346461,
            4355722254695625335667454140586691606333905625557513006305780791955305832250,
            0xb6a32bFd8E84d5445B5d35E867316Fa8baf1f6F6,
            bytes('')
        );
    }
}
