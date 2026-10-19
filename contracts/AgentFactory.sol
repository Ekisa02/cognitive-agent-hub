pragma solidity ^0.8.18;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./AgentImplementation.sol";

/// @title AgentFactory
/// @notice Factory that clones a canonical AgentImplementation for users
contract AgentFactory is Ownable {
    using Clones for address;

    /// @notice Address of the canonical implementation
    address public implementation;

    event AgentCreated(address indexed agent, address indexed owner, string name);
    event ImplementationUpdated(address indexed oldImpl, address indexed newImpl);

    constructor(address _implementation) {
        implementation = _implementation;
    }

    /// @notice Set new canonical implementation (admin)
    function setImplementation(address impl) external onlyOwner {
        address old = implementation;
        implementation = impl;
        emit ImplementationUpdated(old, impl);
    }

    /// @notice Create a new agent clone and initialize it to msg.sender
    function createAgent(string calldata name) external returns (address) {
        address clone = implementation.clone();
        // Initialize clone: sets owner and name
        AgentImplementation(clone).initialize(msg.sender, name);
        emit AgentCreated(clone, msg.sender, name);
        return clone;
    }
}
