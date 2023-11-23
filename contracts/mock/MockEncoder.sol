// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import {Router} from '../periphery/Router.sol';

contract MockEncoder {
  function encodeSwapCallbackData(
    address tokenIn,
    uint24 fee,
    address tokenOut
  ) external view returns (bytes memory) {
    return
      abi.encode(
        Router.SwapCallbackData({
          path: abi.encodePacked(tokenIn, fee, tokenOut),
          source: msg.sender
        })
      );
  }
}
