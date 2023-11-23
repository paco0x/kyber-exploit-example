// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import '../libraries/FullMath.sol';
import './EchidnaAssert.sol';

contract FullMathEchidnaTest is EchidnaAssert {
  function checkMulDivRounding(
    uint256 x,
    uint256 y,
    uint256 d
  ) external {
    require(d > 0);

    uint256 ceiled = FullMath.mulDivCeiling(x, y, d);
    uint256 floored = FullMath.mulDivFloor(x, y, d);

    if (mulmod(x, y, d) > 0) {
      isTrue(ceiled - floored == 1);
    } else {
      isTrue(ceiled == floored);
    }
  }

  function checkMulDiv(
    uint256 x,
    uint256 y,
    uint256 d
  ) external {
    require(d > 0);
    uint256 z = FullMath.mulDivFloor(x, y, d);
    if (x == 0 || y == 0) {
      isTrue(z == 0);
      return;
    }

    // recompute x and y via mulDivFloor of the result of floor(x*y/d), should always be less than original inputs by < d
    uint256 x2 = FullMath.mulDivFloor(z, d, y);
    uint256 y2 = FullMath.mulDivFloor(z, d, x);
    isTrue(x2 <= x);
    isTrue(y2 <= y);

    isTrue(x - x2 < d);
    isTrue(y - y2 < d);
  }

  function checkmulDivCeiling(
    uint256 x,
    uint256 y,
    uint256 d
  ) external {
    require(d > 0);
    uint256 z = FullMath.mulDivCeiling(x, y, d);
    if (x == 0 || y == 0) {
      isTrue(z == 0);
      return;
    }

    // recompute x and y via mulDivFloor of the result of floor(x*y/d), should always be less than original inputs by < d
    uint256 x2 = FullMath.mulDivFloor(z, d, y);
    uint256 y2 = FullMath.mulDivFloor(z, d, x);
    isTrue(x2 >= x);
    isTrue(y2 >= y);

    isTrue(x2 - x < d);
    isTrue(y2 - y < d);
  }
}
