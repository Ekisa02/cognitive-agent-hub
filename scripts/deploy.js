const hre = require("hardhat");

async function main() {
  const [deployer, alice] = await hre.ethers.getSigners();
  console.log("Deploying with:", deployer.address);

  const AgentImpl = await hre.ethers.getContractFactory("AgentImplementation");
  const impl = await AgentImpl.deploy();
  await impl.deployed();
  console.log("AgentImplementation deployed:", impl.address);

  const Factory = await hre.ethers.getContractFactory("AgentFactory");
  const factory = await Factory.deploy(impl.address);
  await factory.deployed();
  console.log("AgentFactory deployed:", factory.address);

  // Deploy a sample plugin
  const Plugin = await hre.ethers.getContractFactory("ExamplePlugin");
  const plugin = await Plugin.deploy();
  await plugin.deployed();
  console.log("ExamplePlugin deployed:", plugin.address);

  // Create an agent for alice (owner)
  const name = "alice-agent";
  const tx = await factory.connect(alice).createAgent(name);
  const receipt = await tx.wait();
  const event = receipt.events.find(e => e.event === "AgentCreated");
  const agentAddress = event.args.agent;
  console.log("Agent clone created for alice:", agentAddress);

  // Toggle plugin by alice
  const agentAsAlice = await hre.ethers.getContractAt("AgentImplementation", agentAddress, alice);
  await agentAsAlice.togglePlugin(plugin.address, true);
  console.log("Plugin enabled for agent by alice");

  // Demonstrate call (callStatic to read without sending a transaction)
  const data = hre.ethers.utils.toUtf8Bytes("hello world");
  const out = await agentAsAlice.callStatic.execute(plugin.address, data);
  console.log("Plugin execution returned:", hre.ethers.utils.toUtf8String(out));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
