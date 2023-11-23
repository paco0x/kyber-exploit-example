// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import '../libraries/CodeDeployer.sol';

contract MockCodeDeployer {
  event CodeDeployed(address destination);
  address public destination;

  function deploy(bytes memory data) external {
    destination = CodeDeployer.deploy(data);
    emit CodeDeployed(destination);
  }
}
