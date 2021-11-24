// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./FluxPriceFeed.sol";
import "./access/SimpleReadAccessController.sol";

/**
 * @notice Wrapper of FluxPriceFeed which checks read access on Aggregator-interface methods
 */
contract AccessControlledFluxPriceFeed is FluxPriceFeed, SimpleReadAccessController {
    constructor(
        address _validator,
        uint8 _decimals,
        string memory _description
    ) FluxPriceFeed(_validator, _decimals, _description) SimpleReadAccessController(_validator) {}

    /*
     * Versioning
     */

    function typeAndVersion() external pure virtual override returns (string memory) {
        return "AccessControlledFluxPriceFeed 1.0.0";
    }

    /*
     * v2 Aggregator interface
     */

    /// @inheritdoc FluxPriceFeed
    function latestAnswer() public view override checkAccess returns (int256) {
        return super.latestAnswer();
    }

    /// @inheritdoc FluxPriceFeed
    function latestTimestamp() public view override checkAccess returns (uint256) {
        return super.latestTimestamp();
    }

    /// @inheritdoc FluxPriceFeed
    function latestRound() public view override checkAccess returns (uint256) {
        return super.latestRound();
    }

    /// @inheritdoc FluxPriceFeed
    function getAnswer(uint256 _roundId) public view override checkAccess returns (int256) {
        return super.getAnswer(_roundId);
    }

    /// @inheritdoc FluxPriceFeed
    function getTimestamp(uint256 _roundId) public view override checkAccess returns (uint256) {
        return super.getTimestamp(_roundId);
    }

    /*
     * v3 Aggregator interface
     */

    /// @inheritdoc FluxPriceFeed
    function description() public view override checkAccess returns (string memory) {
        return super.description();
    }

    /// @inheritdoc FluxPriceFeed
    function getRoundData(uint80 _roundId)
        public
        view
        override
        checkAccess
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return super.getRoundData(_roundId);
    }

    /// @inheritdoc FluxPriceFeed
    function latestRoundData()
        public
        view
        override
        checkAccess
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return super.latestRoundData();
    }
}
