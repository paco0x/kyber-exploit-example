// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import '../periphery/base/Multicall.sol';

contract MockMulticall is Multicall {
  uint256 public paid;

  function revertWithInputError(string memory error) external pure {
    revert(error);
  }

  function revertNoReason() external pure {
    revert();
  }

  struct Tuple {
    uint256 a;
    uint256 b;
  }

  function outputTuple(uint256 a, uint256 b) external pure returns (Tuple memory tuple) {
    tuple = Tuple({a: b, b: a});
  }

  function pay() external payable {
    paid += msg.value;
  }

  function returnSender() external view returns (address) {
    return msg.sender;
  }
}
