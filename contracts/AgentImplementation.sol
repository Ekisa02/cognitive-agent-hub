pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IAgent.sol";
import "./IPlugin.sol";

/// @title AgentImplementation
/// @notice Canonical agent implementation used for cloning. Holds owner and plugin whitelist.
contract AgentImplementation is IAgent, Ownable {
    /// @notice Human-readable agent name
    string public agentName;

    /// @notice Whitelisted plugins allowed to be executed by this agent
    mapping(address => bool) public allowedPlugins;

    /// @notice Initialization guard for clones
    bool public initialized;

    event PluginToggled(address indexed plugin, bool allowed);
    event Executed(address indexed plugin, bytes data, bytes result);

    /// @notice Initialize a freshly-cloned agent
    /// @param _owner Owner address
    /// @param _name Human name for the agent
    function initialize(address _owner, string calldata _name) external override {
        require(!initialized, "Agent: already initialized");
        initialized = true;
        agentName = _name;
        // transfer ownership of the clone to the real owner
        _transferOwnership(_owner);
    }

    /// @notice Toggle plugin permission
    /// @dev Only owner can toggle
    function togglePlugin(address plugin, bool allow) external onlyOwner {
        allowedPlugins[plugin] = allow;
        emit PluginToggled(plugin, allow);
    }

    /// @notice Execute an allowed plugin with provided input
    /// @param plugin Plugin contract address
    /// @param data Arbitrary input bytes
    /// @return result The bytes returned by plugin.run
    function execute(address plugin, bytes calldata data) external override returns (bytes memory result) {
        require(allowedPlugins[plugin], "Agent: plugin not allowed");
        // Call plugin.run; plugin author determines behavior
        IPlugin p = IPlugin(plugin);
        result = p.run(address(this), data);
        emit Executed(plugin, data, result);
    }
}
