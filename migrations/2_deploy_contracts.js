var Stickers = artifacts.require("./Stickers.sol");
module.exports = function(deployer) {
  deployer.deploy(Stickers);
};
