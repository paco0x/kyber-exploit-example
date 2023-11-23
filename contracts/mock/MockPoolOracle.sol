// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import {Oracle} from './../libraries/Oracle.sol';
import {PoolOracle} from '../oracle/PoolOracle.sol';

contract MockPoolOracle is PoolOracle {
  using Oracle for Oracle.Observation[65535];

  uint32 private timestamp = uint32(block.timestamp);

  function forwardTime(uint32 _amount) external {
    timestamp += _amount;
  }

  function blockTimestamp() external view returns (uint32) {
    return timestamp;
  }

  function getObserveFromPool(
    address pool,
    uint32 timestamp,
    int24 tick,
    uint32[] memory secondsAgos
  )
    external view
    returns (int56[] memory tickCumulatives)
  {
    return poolOracle[pool].observe(
      timestamp,
      secondsAgos,
      tick,
      poolObservation[pool].index,
      poolObservation[pool].cardinality
    );
  }

  function getObserveSingleFromPool(
    address pool,
    uint32 timestamp,
    int24 tick,
    uint32 secondsAgo
  )
    external view
    returns (int56 tickCumulative)
  {
    return poolOracle[pool].observeSingle(
      timestamp,
      secondsAgo,
      tick,
      poolObservation[pool].index,
      poolObservation[pool].cardinality
    );
  }

  function _blockTimestamp() internal view override returns (uint32) {
    return timestamp;
  }
}
