// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import {IPool} from '../../interfaces/IPool.sol';
import {IMintCallback} from '../../interfaces/callback/IMintCallback.sol';
import {ISwapCallback} from '../../interfaces/callback/ISwapCallback.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';

import {QtyDeltaMath} from '../../libraries/QtyDeltaMath.sol';

contract MockCallbacks2 is IMintCallback {
  function mint(
    IPool pool,
    address recipient,
    int24 tickLower,
    int24 tickUpper,
    int24[2] calldata ticksPrevious,
    uint128 qty
  ) external {
    IERC20 token0 = pool.token0();
    IERC20 token1 = pool.token1();
    pool.mint(
      recipient,
      tickLower,
      tickUpper,
      ticksPrevious,
      qty,
      abi.encode(token0, token1, msg.sender)
    );
  }

  function unlockPool(IPool pool, uint160 sqrtP) external {
    IERC20 token0 = pool.token0();
    IERC20 token1 = pool.token1();
    (uint256 qty0, uint256 qty1) = QtyDeltaMath.calcUnlockQtys(sqrtP);
    token0.transferFrom(msg.sender, address(pool), qty0);
    token1.transferFrom(msg.sender, address(pool), qty1);
    pool.unlockPool(sqrtP);
  }

  function mintCallback(
    uint256 deltaQty0,
    uint256 deltaQty1,
    bytes calldata data
  ) external override {
    (IERC20 token0, IERC20 token1, address sender) = abi.decode(data, (IERC20, IERC20, address));
    if (deltaQty0 > 0) token0.transferFrom(sender, msg.sender, deltaQty0);
    if (deltaQty1 > 0) token1.transferFrom(sender, msg.sender, deltaQty1);
  }
}
