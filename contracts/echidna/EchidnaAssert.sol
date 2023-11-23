// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

contract EchidnaAssert {
  event AssertionFailed();

  function isTrue(bool b) internal {
    if (!b) {
      emit AssertionFailed();
    }
  }
}
