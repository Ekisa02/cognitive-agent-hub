const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("AI Agent Framework - Core Flow", function () {
  let deployer, alice;
  beforeEach(async function () {
    [deployer, alice] = await ethers.getSigners();

    const Impl = await ethers.getContractFactory("AgentImplementation", deployer);
    this.impl = await Impl.deploy();
    await this.impl.deployed();

    const Factory = await ethers.getContractFactory("AgentFactory", deployer);
    this.factory = await Factory.deploy(this.impl.address);
    await this.factory.deployed();
  });

  it("creates an agent clone, toggles plugin, executes plugin and registers agent", async function () {
    const name = "AliceAgent";

    // Create agent clone as alice
    const tx = await this.factory.connect(alice).createAgent(name);
    const receipt = await tx.wait();
    const evt = receipt.events.find((e) => e.event === "AgentCreated");
    const agentAddr = evt.args.agent;

    const agent = await ethers.getContractAt("AgentImplementation", agentAddr);
    expect(await agent.owner()).to.equal(alice.address);

    // Deploy plugin
    const Plugin = await ethers.getContractFactory("ExamplePlugin", deployer);
    const plugin = await Plugin.deploy();
    await plugin.deployed();

    // Toggle plugin from the agent owner
    const agentAsAlice = await ethers.getContractAt("AgentImplementation", agentAddr, alice);
    await agentAsAlice.togglePlugin(plugin.address, true);
    expect(await agent.allowedPlugins(plugin.address)).to.equal(true);

    // Execute plugin (callStatic to receive return bytes)
    const data = ethers.utils.toUtf8Bytes("hello");
    const out = await agentAsAlice.callStatic.execute(plugin.address, data);
    expect(ethers.utils.toUtf8String(out)).to.equal("echo:hello");

    // Registry test
    const Registry = await ethers.getContractFactory("AgentRegistry", deployer);
    const registry = await Registry.deploy();
    await registry.deployed();

    await registry.register(agentAddr, alice.address);
    expect(await registry.resolveOwner(agentAddr)).to.equal(alice.address);
  });
});
