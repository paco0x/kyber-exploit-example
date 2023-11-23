// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import '../libraries/LiqDeltaMath.sol';

contract MockLiqDeltaMath {
  function applyLiquidityDelta(
    uint128 liquidity,
    uint128 liquidityDelta,
    bool isAddLiquidity
  ) external pure returns (uint256) {
    return LiqDeltaMath.applyLiquidityDelta(liquidity, liquidityDelta, isAddLiquidity);
  }
}
