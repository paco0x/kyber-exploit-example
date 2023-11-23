// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;

import {QtyDeltaMath} from '../libraries/QtyDeltaMath.sol';

import '../periphery/base/LiquidityHelper.sol';
import '../periphery/base/Multicall.sol';

contract MockLiquidityHelper is LiquidityHelper, Multicall {
  constructor(address _factory, address _WETH) LiquidityHelper(_factory, _WETH) {}

  function testUnlockPool(
    address token0,
    address token1,
    uint24 fee,
    uint160 initialSqrtP
  ) external payable returns (IPool pool) {
    pool = _getPool(token0, token1, fee);
    (token0, token1) = token0 < token1 ? (token0, token1) : (token1, token0);
    (uint256 qty0, uint256 qty1) = QtyDeltaMath.calcUnlockQtys(initialSqrtP);
    _transferTokens(token0, msg.sender, address(pool), qty0);
    _transferTokens(token1, msg.sender, address(pool), qty1);
    pool.unlockPool(initialSqrtP);
  }

  function testAddLiquidity(AddLiquidityParams memory params)
    external
    payable
    returns (
      uint128 liquidity,
      uint256 amount0,
      uint256 amount1,
      uint256 feeGrowthInsideLast,
      IPool pool
    )
  {
    return _addLiquidity(params);
  }

  function callbackData(
    address token0,
    address token1,
    uint24 fee
  ) external view returns (bytes memory) {
    return _callbackData(token0, token1, fee);
  }
}
