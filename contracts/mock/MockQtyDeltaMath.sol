// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import '../libraries/QtyDeltaMath.sol';

contract MockQtyDeltaMath {
  function calcRequiredQty0(
    uint160 lowerSqrtP,
    uint160 upperSqrtP,
    uint128 liquidity,
    bool isAdd
  ) external pure returns (int256) {
    return QtyDeltaMath.calcRequiredQty0(lowerSqrtP, upperSqrtP, liquidity, isAdd);
  }

  function calcRequiredQty1(
    uint160 lowerSqrtP,
    uint160 upperSqrtP,
    uint128 liquidity,
    bool isAdd
  ) external pure returns (int256) {
    return QtyDeltaMath.calcRequiredQty1(lowerSqrtP, upperSqrtP, liquidity, isAdd);
  }

  function getQtyFromBurnRTokens(uint160 sqrtP, uint256 lfDelta)
    external
    pure
    returns (uint256 qty0, uint256 qty1)
  {
    qty0 = QtyDeltaMath.getQty0FromBurnRTokens(sqrtP, lfDelta);
    qty1 = QtyDeltaMath.getQty1FromBurnRTokens(sqrtP, lfDelta);
  }
}
