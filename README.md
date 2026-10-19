# Cognitive Agent Hub

Cognitive Agent Hub is a modular AI agent framework implemented in Solidity using Hardhat and OpenZeppelin. The repository demonstrates patterns for creating lightweight agent instances (clones), composing plugin modules, and registering agents for discoverability. It is designed as a developer-focused reference implementation for secure, testable on-chain AI agent plumbing.

## Architecture (high-level)

- AgentImplementation (contract): The canonical agent implementation that holds owner, allowed plugin list and exposes an execute API.
- AgentFactory (contract): Uses OpenZeppelin Clones to create gas-efficient agent instances (minimal proxies) and initialize them.
- AgentRegistry (contract): Simple registry to map agent addresses to owners or metadata, enabling discovery.
- Plugin modules (contracts): Small, purpose-specific plugin contracts that implement a uniform IPlugin interface; agents call plugins to execute tasks.

Flow:
1. Deploy a canonical AgentImplementation.
2. Deploy AgentFactory pointing to the implementation.
3. Users create new agent clones via AgentFactory; clones are initialized with the user as owner.
4. Owners toggle allowed plugin modules on their agent and call execute(plugin, data).
5. Plugins implement IPlugin.run(agentAddress, data) and return encoded results.

Design goals:
- Modularity: Agents delegate specialized behaviors to plugins.
- Gas efficiency: Use Clones pattern for agent instances.
- Security: Owner-controlled plugin whitelist and event emission for auditability.
- Testability: Comprehensive test suite using Hardhat and Mocha/Chai.

## Repository layout

- contracts/: Solidity contracts (core, interfaces, plugins)
- scripts/: deployment and demo scripts
- test/: unit tests
- docs/: architecture and security notes
- hardhat.config.js: Hardhat configuration
- package.json: Node dependencies and scripts

## Getting started

Prerequisites:
- Node.js 18+ (or compatible LTS)
- npm
- git

Installation:

1. Clone repo

   git clone <repo-url>
   cd cognitive-agent-hub

2. Install dependencies

   npm install

3. Compile contracts

   npx hardhat compile

4. Run tests (local)

   npx hardhat test

5. Local development node

   npx hardhat node

6. Deploy to local node

   npx hardhat run --network localhost scripts/deploy.js

## Example usage (quick)

- Create an agent with the factory (owner is the caller).
- Deploy a plugin implementation.
- Agent owner toggles plugin to allowed.
- Agent owner calls execute(plugin, data) to run plugin logic.

See test/agent.test.js and scripts/deploy.js for concrete examples.

## Security & auditing notes

- Owner-only actions are enforced via OpenZeppelin Ownable.
- Plugins are externally deployed contracts; ensure plugins are carefully auditable before whitelisting.
- This reference is not production-ready; additional measures such as meta-transaction guards, gas limits, reentrancy protection on plugin calls (if needed), and more granular capability control should be considered per use-case.

## Contributing

Contributions are welcome. Please follow standard GitHub PR workflows and include tests for new features.

## License

MIT
