pragma solidity =0.5.16;

import "./FuzzHandlers.sol";
import "../mocks/IToken.sol";
import "../../lib/forge-std/src/console.sol";
import "../../lib/forge-std/src/console2.sol";

contract FuzzUnit is FuzzHandlers {
    function check_fee_inits() public {
        console.log("Fee To", uniswapV2Factory.feeTo());
        console.log("Fee To Setter", uniswapV2Factory.feeToSetter());
    }
}