pragma solidity ^0.8.18;

/// @title IPlugin
/// @notice Minimal plugin interface for agent-executable modules
interface IPlugin {
    /// @notice Execute plugin logic in the context of the given agent address
    /// @param agent The agent contract address calling the plugin
    /// @param data Arbitrary encoded input
    /// @return result Encoded result bytes
    function run(address agent, bytes calldata data) external returns (bytes memory result);
}
