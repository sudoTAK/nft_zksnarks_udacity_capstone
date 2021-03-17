// Test if an ERC721 token can be minted for contract - SolnSquareVerifier
const SolnSquareVerifier = artifacts.require("SolnSquareVerifier");
const Verifier = artifacts.require("Verifier");
const { proof, inputs } = require("../../zokrates/code/square/proof");

contract("TestSolnSquareVerifier", (accounts) => {
  const account_one = accounts[0];
  const account_two = accounts[1];

  describe("SolnSquareVerifier", function () {
    beforeEach(async function () {
      let verifierContract = await Verifier.new({ from: account_one });
      this.contract = await SolnSquareVerifier.new(verifierContract.address, { from: account_one });
    });

    // Test if a new solution can be added for contract - SolnSquareVerifier
    it("can add new solution for contract - SolnSquareVerifier", async function () {
      let tx = await this.contract.addSolution(account_one, 110, proof.a, proof.b, proof.c, inputs);
      let eventLogged = tx.logs[0].event;
      assert.equal(eventLogged, "SolutionAdded", "should evmit SolutionAdded Event");
    });

    // Test if an ERC721 token can be minted for contract - SolnSquareVerifier
    it("can mint ERC721 token for contract - SolnSquareVerifier", async function () {
      try {
        await this.contract.addSolution(account_one, 110, proof.a, proof.b, proof.c, inputs);
        let tx = await this.contract.mintNFT(account_one, 110);
        // console.log(JSON.stringify(tx, null, 2))
        let eventLogged = tx.logs[0].event;
        assert.equal(eventLogged, "Transfer", "should emit Transfer Event");
      } catch (e) {
        console.log(e);
      }
    });
  });
});
