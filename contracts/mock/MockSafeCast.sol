// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import '../libraries/SafeCast.sol';

contract MockSafeCast {
  using SafeCast for *;

  function toUint32(uint256 y) external pure returns (uint32) {
    return y.toUint32();
  }

  function toInt128(uint128 y) external pure returns (int128) {
    return y.toInt128();
  }

  function toUint128(uint256 y) external pure returns (uint128) {
    return y.toUint128();
  }

  function revToUint128(int128 y) external pure returns (uint128) {
    return y.revToUint128();
  }

  function toUint160(uint256 y) external pure returns (uint160) {
    return y.toUint160();
  }

  function toInt256(uint256 y) external pure returns (int256) {
    return y.toInt256();
  }

  function revToInt256(uint256 y) external pure returns (int256) {
    return y.revToInt256();
  }

  function revToUint256(int256 y) external pure returns (uint256) {
    return y.revToUint256();
  }
}
