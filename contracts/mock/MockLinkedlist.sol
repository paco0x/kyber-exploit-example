// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import '../libraries/Linkedlist.sol';

contract MockLinkedlist {
  using Linkedlist for mapping(int24 => Linkedlist.Data);

  mapping(int24 => Linkedlist.Data) public values;
  int24 public nearestRemovedValue;

  constructor(int24 minValue, int24 maxValue) {
    values.init(minValue, maxValue);
  }

  function insert(
    int24 newValue,
    int24 nearestLower,
    int24 nearestNext
  ) external {
    values.insert(newValue, nearestLower, nearestNext);
  }

  function remove(int24 value) external {
    nearestRemovedValue = values.remove(value);
  }

  function getData(int24 value) external view returns (int24 previous, int24 next) {
    (previous, next) = (values[value].previous, values[value].next);
  }
}
