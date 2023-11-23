// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import {ERC20, ERC20Burnable} from '@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol';

contract MockWeth is ERC20Burnable {
  constructor() ERC20('Weth token', 'WETH') {}

  function deposit() external payable {
    _mint(msg.sender, msg.value);
  }

  function withdraw(uint256 amount) external {
    _burn(msg.sender, amount);
    (bool success, ) = msg.sender.call{value: amount}('');
    require(success);
  }
}
