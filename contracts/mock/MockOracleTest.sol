// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;
pragma abicoder v2;

import '../libraries/Oracle.sol';

contract MockOracleTest {
  using Oracle for Oracle.Observation[65535];

  Oracle.Observation[65535] public observations;

  uint32 public time;
  int24 public tick;
  uint16 public index;
  uint16 public cardinality;
  uint16 public cardinalityNext;

  struct InitializeParams {
    uint32 time;
    int24 tick;
  }

  function initialize(InitializeParams calldata params) external {
    require(cardinality == 0, 'already initialized');
    time = params.time;
    tick = params.tick;
    (cardinality, cardinalityNext) = observations.initialize(params.time);
  }

  function advanceTime(uint32 by) public {
    unchecked { time += by; }
  }

  struct UpdateParams {
    uint32 advanceTimeBy;
    int24 tick;
  }

  // write an observation, then change tick
  function update(UpdateParams calldata params) external {
    advanceTime(params.advanceTimeBy);
    (index, cardinality) = observations.write(index, time, tick, cardinality, cardinalityNext);
    tick = params.tick;
  }

  function batchUpdate(UpdateParams[] calldata params) external {
    // sload everything
    int24 _tick = tick;
    uint16 _index = index;
    uint16 _cardinality = cardinality;
    uint16 _cardinalityNext = cardinalityNext;
    uint32 _time = time;

    for (uint256 i = 0; i < params.length; i++) {
      _time += params[i].advanceTimeBy;
      (_index, _cardinality) = observations.write(
        _index,
        _time,
        _tick,
        _cardinality,
        _cardinalityNext
      );
      _tick = params[i].tick;
    }

    // sstore everything
    tick = _tick;
    index = _index;
    cardinality = _cardinality;
    time = _time;
  }

  function grow(uint16 _cardinalityNext) external {
    cardinalityNext = observations.grow(cardinalityNext, _cardinalityNext);
  }

  function observe(uint32[] calldata secondsAgos)
    external
    view
    returns (int56[] memory tickCumulatives)
  {
    return observations.observe(time, secondsAgos, tick, index, cardinality);
  }

  function getGasCostOfObserve(uint32[] calldata secondsAgos) external view returns (uint256) {
    (uint32 _time, int24 _tick, uint16 _index) = (time, tick, index);
    uint256 gasBefore = gasleft();
    observations.observe(_time, secondsAgos, _tick, _index, cardinality);
    return gasBefore - gasleft();
  }
}
