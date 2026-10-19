pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title AgentRegistry
/// @notice Lightweight registry mapping agent addresses to owners or metadata
contract AgentRegistry is Ownable {
    mapping(address => address) public ownerOf;

    event Registered(address indexed agent, address indexed owner);

    /// @notice Register an agent to an owner (permission model depends on deployment)
    /// @dev This reference implementation allows anyone to call; production should gate or verify
    function register(address agent, address owner) external {
        ownerOf[agent] = owner;
        emit Registered(agent, owner);
    }

    function resolveOwner(address agent) external view returns (address) {
        return ownerOf[agent];
    }
}
