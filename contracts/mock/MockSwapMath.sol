// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import '../libraries/SwapMath.sol';

contract MockSwapMath {
  function calcReachAmount(
    uint256 liquidity,
    uint160 currentSqrtP,
    uint160 nextSqrtP,
    uint24 feeInFeeUnits,
    bool isExactInput,
    bool isToken0
  ) external pure returns (int256 reachAmount) {
    reachAmount = SwapMath.calcReachAmount(
      liquidity,
      currentSqrtP,
      nextSqrtP,
      feeInFeeUnits,
      isExactInput,
      isToken0
    );
  }

  function calcFinalPrice(
    uint256 absDelta,
    uint256 liquidity,
    uint256 deltaL,
    uint160 currentSqrtP,
    bool isExactInput,
    bool isToken0
  ) external pure returns (uint256 nextSqrtP) {
    nextSqrtP = SwapMath.calcFinalPrice(
      absDelta,
      liquidity,
      deltaL,
      currentSqrtP,
      isExactInput,
      isToken0
    );
  }

  function estimateIncrementalLiquidity(
    uint256 absDelta,
    uint256 liquidity,
    uint160 currentSqrtP,
    uint24 feeInFeeUnits,
    bool isExactInput,
    bool isToken0
  ) external pure returns (uint256 deltaL) {
    deltaL = SwapMath.estimateIncrementalLiquidity(
      absDelta,
      liquidity,
      currentSqrtP,
      feeInFeeUnits,
      isExactInput,
      isToken0
    );
  }

  function calcIncrementalLiquidity(
    uint256 absDelta,
    uint256 liquidity,
    uint160 currentSqrtP,
    uint160 targetSqrtP,
    bool isExactInput,
    bool isToken0
  ) external pure returns (uint256 deltaL) {
    deltaL = SwapMath.calcIncrementalLiquidity(
      absDelta,
      liquidity,
      currentSqrtP,
      targetSqrtP,
      isExactInput,
      isToken0
    );
  }

  function calcReturnedAmount(
    uint256 liquidity,
    uint160 currentSqrtP,
    uint160 targetSqrtP,
    uint128 rLiquidity,
    bool isExactInput,
    bool isToken0
  ) external pure returns (int256 returnedAmount) {
    returnedAmount = SwapMath.calcReturnedAmount(
      liquidity,
      currentSqrtP,
      targetSqrtP,
      rLiquidity,
      isExactInput,
      isToken0
    );
  }

  function computeSwapStep(
    uint256 liquidity,
    uint160 currentSqrtP,
    uint160 targetSqrtP,
    uint256 feeInFeeUnits,
    int256 amountRemaining,
    bool isExactInput,
    bool isToken0
  )
    external
    view
    returns (
      int256 usedAmount,
      int256 returnedAmount,
      uint256 deltaL,
      uint160 nextSqrtP,
      uint256 gasCost
    )
  {
    uint256 start = gasleft();
    (usedAmount, returnedAmount, deltaL, nextSqrtP) = SwapMath.computeSwapStep(
      liquidity,
      currentSqrtP,
      targetSqrtP,
      feeInFeeUnits,
      amountRemaining,
      isExactInput,
      isToken0
    );
    gasCost = start - gasleft();
  }
}
