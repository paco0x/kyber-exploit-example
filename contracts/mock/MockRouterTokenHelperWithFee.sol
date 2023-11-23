// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import '../periphery/base/RouterTokenHelperWithFee.sol';

contract MockRouterTokenHelperWithFee is RouterTokenHelperWithFee {
  constructor(address _factory, address _WETH) RouterTokenHelperWithFee(_factory, _WETH) {}
}
