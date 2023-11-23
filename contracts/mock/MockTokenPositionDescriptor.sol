// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import '../interfaces/periphery/INonfungibleTokenPositionDescriptor.sol';

contract MockTokenPositionDescriptor is INonfungibleTokenPositionDescriptor {
  string private tokenUri;

  function setTokenUri(string memory _tokenUri) external {
    tokenUri = _tokenUri;
  }

  function tokenURI(IBasePositionManager, uint256) external view override returns (string memory) {
    return tokenUri;
  }
}
