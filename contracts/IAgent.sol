pragma solidity ^0.8.18;

/// @title IAgent
/// @notice Minimal agent interface used by factory/registry and callers
interface IAgent {
    function initialize(address owner, string calldata name) external;
    function execute(address plugin, bytes calldata data) external returns (bytes memory);
    function owner() external view returns (address);
}
