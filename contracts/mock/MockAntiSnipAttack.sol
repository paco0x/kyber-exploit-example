// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import '../periphery/libraries/AntiSnipAttack.sol';

contract MockAntiSnipAttack {
  struct Fees {
    uint256 feesClaimable;
    uint256 feesBurnable;
  }
  AntiSnipAttack.Data public data;
  Fees public fees;

  function initialize(uint32 timestamp) external {
    data = AntiSnipAttack.initialize(timestamp);
  }

  function update(
    uint128 currentLiquidity,
    uint128 liquidityDelta,
    uint32 currentTime,
    bool isAddLiquidity,
    uint256 feesSinceLastAction,
    uint256 vestingPeriod
  ) external {
    (fees.feesClaimable, fees.feesBurnable) = AntiSnipAttack.update(
      data,
      currentLiquidity,
      liquidityDelta,
      currentTime,
      isAddLiquidity,
      feesSinceLastAction,
      vestingPeriod
    );
  }

  function snip(
    uint128 currentLiquidity,
    uint128 liquidityDelta,
    uint32 currentTime,
    uint256 feesSinceLastAction,
    uint256 vestingPeriod
  ) external {
    AntiSnipAttack.update(
      data,
      currentLiquidity,
      liquidityDelta,
      currentTime,
      true,
      feesSinceLastAction,
      vestingPeriod
    );
    (fees.feesClaimable, fees.feesBurnable) = AntiSnipAttack.update(
      data,
      currentLiquidity + liquidityDelta,
      liquidityDelta,
      currentTime,
      false,
      feesSinceLastAction,
      vestingPeriod
    );
  }

  function calcFeeProportions(
    uint256 currentFees,
    uint256 nextFees,
    uint256 currentClaimableBps,
    uint256 nextClaimableBps
  ) external pure returns (uint256 feesLockedNew, uint256 feesClaimable) {
    return
      AntiSnipAttack.calcFeeProportions(
        currentFees,
        nextFees,
        currentClaimableBps,
        nextClaimableBps
      );
  }
}
