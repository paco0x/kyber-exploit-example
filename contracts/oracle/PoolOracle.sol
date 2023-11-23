// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import {IERC20Upgradeable} from '@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol';
import {SafeERC20Upgradeable} from '@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol';

import {Initializable} from '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';
import {UUPSUpgradeable} from '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';
import {OwnableUpgradeable} from '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';

import {IPoolOracle} from './../interfaces/oracle/IPoolOracle.sol';
import {IPoolStorage} from './../interfaces/pool/IPoolStorage.sol';
import {Oracle} from './../libraries/Oracle.sol';

/// @title KyberSwap v2 Pool Oracle
contract PoolOracle is
  IPoolOracle,
  Initializable,
  UUPSUpgradeable,
  OwnableUpgradeable
{
  using SafeERC20Upgradeable for IERC20Upgradeable;
  using Oracle for Oracle.Observation[65535];

  struct ObservationData {
    bool initialized;
    // the most-recently updated index of the observations array
    uint16 index;
    // the current maximum number of observations that are being stored
    uint16 cardinality;
    // the next maximum number of observations to store, triggered in observations.write
    uint16 cardinalityNext;
  }

  mapping(address => Oracle.Observation[65535]) internal poolOracle;
  mapping(address => ObservationData) internal poolObservation;

  function initialize() public initializer {
    __Ownable_init();
  }

  function _authorizeUpgrade(address) internal override onlyOwner {}

  /// @notice Owner's function to rescue any funds stuck in the contract.
  function rescueFund(address token, uint256 amount) external onlyOwner {
    if (token == address(0)) {
      (bool success, ) = payable(owner()).call{value: amount}('');
      require(success, "failed to collect native");
    } else {
      IERC20Upgradeable(token).safeTransfer(owner(), amount);
    }
    emit OwnerWithdrew(owner(), token, amount);
  }

  /// @inheritdoc IPoolOracle
  function initializeOracle(uint32 time)
    external override
    returns (uint16 cardinality, uint16 cardinalityNext)
  {
    (cardinality, cardinalityNext) = poolOracle[msg.sender].initialize(time);
    poolObservation[msg.sender] = ObservationData({
      initialized: true,
      index: 0,
      cardinality: cardinality,
      cardinalityNext: cardinalityNext
    });
  }

  /// @inheritdoc IPoolOracle
  function write(
    uint32 blockTimestamp,
    int24 tick,
    uint128 liquidity
  )
    external override
    returns (uint16 indexUpdated, uint16 cardinalityUpdated)
  {
    return writeNewEntry(
      poolObservation[msg.sender].index,
      blockTimestamp,
      tick,
      liquidity,
      poolObservation[msg.sender].cardinality,
      poolObservation[msg.sender].cardinalityNext
    );
  }

  /// @inheritdoc IPoolOracle
  function increaseObservationCardinalityNext(
    address pool,
    uint16 observationCardinalityNext
  )
    external
    override
  {
    uint16 observationCardinalityNextOld = poolObservation[pool].cardinalityNext;
    uint16 observationCardinalityNextNew = poolOracle[pool].grow(
      observationCardinalityNextOld,
      observationCardinalityNext
    );
    poolObservation[pool].cardinalityNext = observationCardinalityNextNew;
    if (observationCardinalityNextOld != observationCardinalityNextNew)
      emit IncreaseObservationCardinalityNext(
        pool,
        observationCardinalityNextOld,
        observationCardinalityNextNew
      );
  }

  /// @inheritdoc IPoolOracle
  function writeNewEntry(
    uint16 index,
    uint32 blockTimestamp,
    int24 tick,
    uint128 liquidity,
    uint16 cardinality,
    uint16 cardinalityNext
  )
    public override
    returns (uint16 indexUpdated, uint16 cardinalityUpdated)
  {
    liquidity; // unused for now
    address pool = msg.sender;
    (indexUpdated, cardinalityUpdated) = poolOracle[pool].write(
      index,
      blockTimestamp,
      tick,
      cardinality,
      cardinalityNext
    );
    poolObservation[pool].index = indexUpdated;
    poolObservation[pool].cardinality = cardinalityUpdated;
  }

  /// @inheritdoc IPoolOracle
  function observeFromPool(
    address pool,
    uint32[] memory secondsAgos
  )
    external view override
    returns (int56[] memory tickCumulatives)
  {
    (, int24 tick, ,) = IPoolStorage(pool).getPoolState();
    return poolOracle[pool].observe(
      _blockTimestamp(),
      secondsAgos,
      tick,
      poolObservation[pool].index,
      poolObservation[pool].cardinality
    );
  }

  /// @inheritdoc IPoolOracle
  function observeSingleFromPool(
    address pool,
    uint32 secondsAgo
  )
    external view override
    returns (int56 tickCumulative)
  {
    (, int24 tick, ,) = IPoolStorage(pool).getPoolState();
    return poolOracle[pool].observeSingle(
      _blockTimestamp(),
      secondsAgo,
      tick,
      poolObservation[pool].index,
      poolObservation[pool].cardinality
    );
  }

  /// @inheritdoc IPoolOracle
  function getPoolObservation(address pool)
    external view override
    returns (bool initialized, uint16 index, uint16 cardinality, uint16 cardinalityNext)
  {
    (initialized, index, cardinality, cardinalityNext) = (
      poolObservation[pool].initialized,
      poolObservation[pool].index,
      poolObservation[pool].cardinality,
      poolObservation[pool].cardinalityNext
    );
  }

  /// @inheritdoc IPoolOracle
  function getObservationAt(address pool, uint256 index)
    external view override
    returns (
      uint32 blockTimestamp,
      int56 tickCumulative,
      bool initialized
    )
  {
    Oracle.Observation memory obsData = poolOracle[pool][index];
    (blockTimestamp, tickCumulative, initialized) = (
      obsData.blockTimestamp,
      obsData.tickCumulative,
      obsData.initialized
    );
  }

  /// @dev For overriding in tests
  function _blockTimestamp() internal view virtual returns (uint32) {
    return uint32(block.timestamp);
  }
}
