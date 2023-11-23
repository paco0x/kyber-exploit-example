// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import '../periphery/libraries/LiquidityMath.sol';

contract MockLiquidityMath {
  function getLiquidityFromQty0(
    uint160 lowerSqrtP,
    uint160 upperSqrtP,
    uint256 qty0
  ) external pure returns (uint128) {
    return LiquidityMath.getLiquidityFromQty0(lowerSqrtP, upperSqrtP, qty0);
  }

  function getLiquidityFromQty1(
    uint160 lowerSqrtP,
    uint160 upperSqrtP,
    uint256 qty1
  ) external pure returns (uint128) {
    return LiquidityMath.getLiquidityFromQty1(lowerSqrtP, upperSqrtP, qty1);
  }

  function getLiquidityFromQties(
    uint160 currentSqrtP,
    uint160 lowerSqrtP,
    uint160 upperSqrtP,
    uint256 qty0,
    uint256 qty1
  ) external pure returns (uint128) {
    return LiquidityMath.getLiquidityFromQties(currentSqrtP, lowerSqrtP, upperSqrtP, qty0, qty1);
  }
}
