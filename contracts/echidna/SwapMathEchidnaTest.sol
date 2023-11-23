// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import '../libraries/SwapMath.sol';
import '../libraries/TickMath.sol';
import './EchidnaAssert.sol';

contract SwapMathEchidnaTest is EchidnaAssert {
  function checkCalcDeltaNextInvariants(
    uint128 liquidity,
    uint160 currentSqrtP,
    uint160 targetSqrtP,
    uint24 feeInFeeUnits,
    bool isExactInput
  ) external {
    checkInitCondition(liquidity, currentSqrtP, targetSqrtP, feeInFeeUnits);
    bool isToken0 = isExactInput ? (currentSqrtP > targetSqrtP) : (currentSqrtP < targetSqrtP);
    int256 reachAmount = SwapMath.calcReachAmount(
      liquidity,
      currentSqrtP,
      targetSqrtP,
      feeInFeeUnits,
      isExactInput,
      isToken0
    );
    if (isExactInput) {
      isTrue(reachAmount >= 0);
    } else {
      isTrue(reachAmount <= 0);
    }

    uint256 absDelta = isExactInput ? uint256(reachAmount) : uint256(-reachAmount);
    absDelta -= 1;

    uint256 fee = SwapMath.estimateIncrementalLiquidity(
      absDelta,
      liquidity,
      currentSqrtP,
      feeInFeeUnits,
      isExactInput,
      isToken0
    );
    uint256 nextSqrtP = SwapMath.calcFinalPrice(
      absDelta,
      liquidity,
      fee,
      currentSqrtP,
      isExactInput,
      isToken0
    );
    if (currentSqrtP > targetSqrtP) {
      isTrue(nextSqrtP >= targetSqrtP);
    } else {
      isTrue(nextSqrtP <= targetSqrtP);
    }
  }

  function checkComputeSwapStep(
    uint128 liquidity,
    int256 specifiedAmount,
    uint160 currentSqrtP,
    uint160 targetSqrtP,
    uint8 feeInFeeUnits
  ) external {
    checkInitCondition(liquidity, currentSqrtP, targetSqrtP, feeInFeeUnits);
    require(specifiedAmount != 0);
    bool isExactInput = specifiedAmount > 0;
    bool isToken0 = isExactInput ? (currentSqrtP > targetSqrtP) : (currentSqrtP < targetSqrtP);
    (int256 usedAmount, int256 returnedAmount, , uint160 nextSqrtP) = SwapMath.computeSwapStep(
      liquidity,
      currentSqrtP,
      targetSqrtP,
      feeInFeeUnits,
      specifiedAmount,
      isExactInput,
      isToken0
    );

    if (nextSqrtP != targetSqrtP) {
      isTrue(usedAmount == specifiedAmount);
    }

    // next price is between price and price target
    if (currentSqrtP <= targetSqrtP) {
      isTrue(nextSqrtP <= targetSqrtP);
      isTrue(currentSqrtP <= nextSqrtP);
    } else {
      isTrue(nextSqrtP >= targetSqrtP);
      isTrue(currentSqrtP >= nextSqrtP);
    }

    if (nextSqrtP != currentSqrtP) {
      if (isExactInput) {
        isTrue(usedAmount >= 0);
        isTrue(returnedAmount <= 0);
      } else {
        isTrue(usedAmount <= 0);
        isTrue(returnedAmount >= 0);
      }
    }
  }

  function checkInitCondition(
    uint128 liquidity,
    uint160 currentSqrtP,
    uint160 targetSqrtP,
    uint24 feeInFeeUnits
  ) internal pure {
    require(currentSqrtP >= TickMath.MIN_SQRT_RATIO && currentSqrtP <= TickMath.MAX_SQRT_RATIO);
    require(targetSqrtP >= TickMath.MIN_SQRT_RATIO && targetSqrtP <= TickMath.MAX_SQRT_RATIO);
    require(liquidity >= 100000);
    require(feeInFeeUnits != 0);
    require(currentSqrtP * 95 < targetSqrtP * 100 && targetSqrtP * 100 < currentSqrtP * 105);
  }
}
