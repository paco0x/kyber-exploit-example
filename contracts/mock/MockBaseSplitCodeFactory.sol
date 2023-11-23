// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import '../libraries/BaseSplitCodeFactory.sol';

contract MockFactoryCreatedContract {
  bytes32 private _id;

  constructor(bytes32 id) {
    require(id != 0, 'NON_ZERO_ID');
    _id = id;
  }

  function getId() external view returns (bytes32) {
    return _id;
  }
}

contract MockSplitCodeFactory is BaseSplitCodeFactory {
  event ContractCreated(address destination);
  address public destination;

  constructor() BaseSplitCodeFactory(type(MockFactoryCreatedContract).creationCode) {
    // solhint-disable-previous-line no-empty-blocks
  }

  function create(bytes32 id) external returns (address) {
    destination = _create(abi.encode(id), 0x0);
    emit ContractCreated(destination);

    return destination;
  }
}
