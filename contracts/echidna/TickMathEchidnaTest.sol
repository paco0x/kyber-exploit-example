// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import '../libraries/TickMath.sol';
import './EchidnaAssert.sol';

contract TickMathEchidnaTest is EchidnaAssert {
  // uniqueness and increasing order
  function checkGetSqrtRatioAtTickInvariants(int24 tick) external {
    uint160 ratio = TickMath.getSqrtRatioAtTick(tick);
    isTrue(
      TickMath.getSqrtRatioAtTick(tick - 1) < ratio &&
        ratio < TickMath.getSqrtRatioAtTick(tick + 1)
    );
    isTrue(ratio >= TickMath.MIN_SQRT_RATIO);
    isTrue(ratio <= TickMath.MAX_SQRT_RATIO);
  }

  // the ratio is always between the returned tick and the returned tick+1
  function checkGetTickAtSqrtRatioInvariants(uint160 ratio) external {
    int24 tick = TickMath.getTickAtSqrtRatio(ratio);
    isTrue(
      ratio >= TickMath.getSqrtRatioAtTick(tick) && ratio < TickMath.getSqrtRatioAtTick(tick + 1)
    );
    isTrue(tick >= TickMath.MIN_TICK);
    isTrue(tick < TickMath.MAX_TICK);
  }
}
