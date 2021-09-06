const myNFT = artifacts.require("myNFT");

module.exports = async function (deployer, network, accounts) {
	await deployer.deploy(myNFT);
};
