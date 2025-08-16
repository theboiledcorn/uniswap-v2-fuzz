pragma solidity =0.5.16;

import "../../contracts/UniswapV2Factory.sol";
import "../../contracts/UniswapV2Pair.sol";
import {Vm, IHevm} from "./Hevm.sol";
import {MockToken} from "../mocks/MockToken.sol";

contract FuzzSetup {
    UniswapV2Factory uniswapV2Factory;
    UniswapV2Pair uniswapV2Pair;

    MockToken tokenA;
    MockToken tokenB;

    IHevm vm = Vm.vm();

    address feeSetter;
    address currentSender;

    constructor () public {
        uniswapV2Factory = new UniswapV2Factory(
            address(this)
        );

        uniswapV2Factory.setFeeToSetter(address(this));
        uniswapV2Factory.setFeeTo(feeSetter);

        tokenA = new MockToken("TokenA", "TKNa", 18);
        tokenB = new MockToken("TokenB", "TKNb", 18);

        uniswapV2Pair = UniswapV2Pair(uniswapV2Factory.createPair(address(tokenA), address(tokenB)));

    }

    event Log(string);

    function t(bool b, string memory reason) internal {
        if (!b) {
            emit Log(reason);
            assert(false);
        }
    }

    modifier asCurrentSender {
        currentSender = msg.sender;
        vm.prank(address(currentSender));
        _;
    }
}