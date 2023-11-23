// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import {Linkedlist} from '../libraries/Linkedlist.sol';
import {TickMath as T} from '../libraries/TickMath.sol';

contract MockSimplePoolStorage {
  using Linkedlist for mapping(int24 => Linkedlist.Data);

  int24 public immutable tickDistance;
  mapping(int24 => Linkedlist.Data) public initializedTicks;

  constructor(int24 _tickDistance) {
    tickDistance = _tickDistance;
    initializedTicks.init(T.MIN_TICK, T.MAX_TICK);
  }

  // should be sorted uptick. first tick should be higher than MAX_TICK.previous
  function insertTicks(int24[] calldata ticks) external {
    // get MAX_TICK.previous
    Linkedlist.Data memory data = initializedTicks[T.MAX_TICK];
    initializedTicks.insert(ticks[0], data.previous, T.MAX_TICK);
    for (uint256 i = 1; i < ticks.length; i++) {
      initializedTicks.insert(ticks[i], ticks[i - 1], T.MAX_TICK);
    }
  }
}
