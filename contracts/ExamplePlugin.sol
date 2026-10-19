pragma solidity ^0.8.18;

import "./IPlugin.sol";

/// @title ExamplePlugin
/// @notice Simple plugin that echoes its input with a prefix for demonstration
contract ExamplePlugin is IPlugin {
    event Ran(address indexed agent, bytes data);

    function run(address agent, bytes calldata data) external pure returns (bytes memory) {
        // Simple deterministic behavior suitable for tests/demos
        return abi.encodePacked("echo:", data);
    }
}
