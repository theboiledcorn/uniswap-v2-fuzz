pragma solidity =0.5.16;

import "./FuzzSetup.sol";
import "../mocks/IToken.sol";

contract FuzzHandlers is FuzzSetup {
    enum OperationType {
        None,
        Swap
    }

    modifier swapB4After() {
        (ghost_b4_reserve0, ghost_b4_reserve1,) = uniswapV2Pair.getReserves();
        _;
        (ghost_after_reserve0, ghost_after_reserve1,) = uniswapV2Pair.getReserves();
    }

    uint112 ghost_b4_reserve0;
    uint112 ghost_b4_reserve1;
    uint112 ghost_after_reserve0;
    uint112 ghost_after_reserve1;
    OperationType public operationType;

    function uniswapV2Pair_approve(address spender, uint256 value) public asCurrentSender {
        uniswapV2Pair.approve(spender, value);
    }

    function uniswapV2Pair_burn(address to) public asCurrentSender {
        require(IToken(uniswapV2Pair.token0()).balanceOf(address(uniswapV2Pair)) > 0);
        require(IToken(uniswapV2Pair.token1()).balanceOf(address(uniswapV2Pair)) > 0);
        require(uniswapV2Pair.balanceOf(address(uniswapV2Pair)) > 0);
        require(to != address(0));
        uniswapV2Pair.burn(to);
    }

    function uniswapV2Pair_mint(address to) public asCurrentSender {
        uniswapV2Pair.mint(to);
    }

    event ClammpedMint(uint256 k);

    function uniswapV2Pair_permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public asCurrentSender {
        /**
         * @todo: for us to be able to get proper coverage on this function,
         * - we'll have to add a valid address in the `senderAddresses` in the medusa.json file
         * - using the private key of said valid address, generate signatures for it
         * - require that medusa use only this caller and one of the valid signatures when calling this method
         * - then can we get coverage of this part because of the constraints around cryptography and fuzzing tools
         */
        uniswapV2Pair.permit(owner, spender, value, deadline, v, r, s);
    }

    function uniswapV2Pair_skim(address to) public asCurrentSender {
        uniswapV2Pair.skim(to);
    }

    function uniswapV2Pair_swap(uint256 amount0Out, uint256 amount1Out, address to, bytes memory data)
        public
        asCurrentSender
    {
        (uint112 reserve0, uint112 reserve1,) = uniswapV2Pair.getReserves();
        address token0 = uniswapV2Pair.token0();
        address token1 = uniswapV2Pair.token1();
        uint256 balance0 = IERC20(token0).balanceOf(address(uniswapV2Pair));
        uint256 balance1 = IERC20(token1).balanceOf(address(uniswapV2Pair));
        require(balance0 > reserve0);
        require(balance1 > reserve1);
        uniswapV2Pair.swap(amount0Out, amount1Out, to, data);
        // (bool success, bytes memory data) = address(uniswapV2Pair).call(
        //     abi.encodeWithSignature('swap(uint256, uint256, address, bytes)', amount0Out, amount1Out, to, bytes(''))
        // );
        // t(!success, 'UniswapV2Pair: swap failed');
    }

    function clamped_uniswapV2Pair_swap(uint256 amount0Out, uint256 amount1Out, address to, bytes memory data)
        public
        asCurrentSender
        swapB4After
    {
        amount0Out = between(amount0Out, 1, 1_000_000 ether);
        amount1Out = between(amount1Out, 1, 1_000_000 ether);
        uniswapV2Pair_swap(amount0Out, amount1Out, to, data);
        (uint112 reserve0, uint112 reserve1,) = uniswapV2Pair.getReserves();
        assert(uint256(ghost_b4_reserve0) * ghost_b4_reserve1 == uint256(reserve0) * reserve1);
    }

    function uniswapV2Pair_setFeeToZeroAddress() public {
        vm.prank(address(0x10000));
        uniswapV2Factory.setFeeTo(address(0));
    }

    function uniswapV2Pair_setFeeTo(address feeTo) public {
        vm.prank(address(0x10000));
        uniswapV2Factory.setFeeTo(feeTo);
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

    function tokenA_mint(address account, uint256 _amount) public asCurrentSender {
        uint256 amount = between(_amount, 0, 1_000_000 ether);
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

    function tokenB_mint(address account, uint256 _amount) public asCurrentSender {
        uint256 amount = between(_amount, 0, 1_000_000 ether);
        tokenB.mint(account, amount);
    }

    function tokenB_transfer(address recipient, uint256 amount) public asCurrentSender {
        tokenB.transfer(recipient, amount);
    }

    function tokenB_transferFrom(address sender, address recipient, uint256 amount) public asCurrentSender {
        tokenB.transferFrom(sender, recipient, amount);
    }
}
