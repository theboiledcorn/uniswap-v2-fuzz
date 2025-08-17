pragma solidity =0.5.16;

import '../../contracts/UniswapV2Factory.sol';
import '../../contracts/UniswapV2Pair.sol';
import {Vm, IHevm} from './Hevm.sol';
import {MockToken} from '../mocks/MockToken.sol';

contract FuzzSetup {
    UniswapV2Factory uniswapV2Factory;
    UniswapV2Pair uniswapV2Pair;
    Counter counter;

    MockToken tokenA;
    MockToken tokenB;

    IHevm vm = Vm.vm();

    address feeSetter;
    address currentSender;

    event PairCreated(address pair);

    constructor() public {
        vm.prank(msg.sender);
        counter = new Counter();
        uniswapV2Factory = new UniswapV2Factory(msg.sender);

        // // @todo: fee setter is not working, needs to be to get coverage for the burn function
        // uniswapV2Factory.setFeeToSetter(address(this));
        vm.prank(msg.sender);
        uniswapV2Factory.setFeeTo(msg.sender);

        tokenA = new MockToken('TokenA', 'TKNa', 18);
        tokenB = new MockToken('TokenB', 'TKNb', 18);

        vm.prank(msg.sender);
        uniswapV2Pair = UniswapV2Pair(uniswapV2Factory.createPair(address(tokenA), address(tokenB)));
    }

    event Log(string);

    function t(bool b, string memory reason) internal {
        if (!b) {
            emit Log(reason);
            assert(false);
        }
    }

    function between(uint256 value, uint256 low, uint256 high) internal pure returns (uint256) {
        if (value < low || value > high) {
            uint256 range = high - low + 1;
            uint256 clamped = (value - low) % (range);
            if (clamped < 0) clamped += range;
            uint256 ans = low + clamped;
            return ans;
        }
        return value;
    }

    modifier asCurrentSender() {
        currentSender = counter.incrementCounter();
        emit PairCreated(address(uniswapV2Pair));
        vm.startPrank(currentSender);
        _;
        vm.stopPrank();
        currentSender = address(0);
    }
}

contract Counter {
    uint counter;

    function incrementCounter() external returns (address) {
        counter++;
        return address(msg.sender);
    }
}
