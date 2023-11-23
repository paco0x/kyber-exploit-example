// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import '../libraries/FullMath.sol';

contract MockFullMath {
  function mulDivFloor(
    uint256 a,
    uint256 b,
    uint256 denominator
  ) external pure returns (uint256) {
    return FullMath.mulDivFloor(a, b, denominator);
  }

  function mulDivCeiling(
    uint256 a,
    uint256 b,
    uint256 denominator
  ) external pure returns (uint256) {
    return FullMath.mulDivCeiling(a, b, denominator);
  }
}
