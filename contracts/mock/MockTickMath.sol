// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import '../libraries/TickMath.sol';

contract MockTickMath {
  function getSqrtRatioAtTick(int24 tick) external pure returns (uint160) {
    return TickMath.getSqrtRatioAtTick(tick);
  }

  function getMiddleSqrtRatioAtTick(int24 tick) external pure returns (uint160) {
    return (TickMath.getSqrtRatioAtTick(tick + 1) + TickMath.getSqrtRatioAtTick(tick)) / 2;
  }

  function getGasCostOfGetSqrtRatioAtTick(int24 tick) external view returns (uint256) {
    uint256 gasBefore = gasleft();
    TickMath.getSqrtRatioAtTick(tick);
    return gasBefore - gasleft();
  }

  function getTickAtSqrtRatio(uint160 sqrtP) external pure returns (int24) {
    return TickMath.getTickAtSqrtRatio(sqrtP);
  }

  function getGasCostOfGetTickAtSqrtRatio(uint160 sqrtP) external view returns (uint256) {
    uint256 gasBefore = gasleft();
    TickMath.getTickAtSqrtRatio(sqrtP);
    return gasBefore - gasleft();
  }

  function MIN_SQRT_RATIO() external pure returns (uint160) {
    return TickMath.MIN_SQRT_RATIO;
  }

  function MAX_SQRT_RATIO() external pure returns (uint160) {
    return TickMath.MAX_SQRT_RATIO;
  }
}
