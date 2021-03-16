var ERC721MintableComplete = artifacts.require("DigiHouseToken");

contract("TestERC721Mintable", (accounts) => {
  const account_one = accounts[0];
  const account_two = accounts[1];

  describe("match erc721 spec", function () {
    beforeEach(async function () {
      this.contract = await ERC721MintableComplete.new({ from: account_one });

      // TODO: mint multiple tokens
      await this.contract.mint(account_one, 1);
      await this.contract.mint(account_one, 2);
      await this.contract.mint(account_one, 3);
      await this.contract.mint(account_two, 4);
      await this.contract.mint(account_two, 5);
    });

    it("should return total supply", async function () {
      let totalSupply = await this.contract.totalSupply();
      assert.equal(totalSupply, 5, "wrong total supply count");
    });

    it("should get token balance", async function () {
      let tokenBalance = await this.contract.balanceOf(account_one);
      assert.equal(tokenBalance, 3, "wrong token balance");
    });

    // token uri should be complete i.e: https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/1
    it("should return token uri", async function () {
      let tokenURI = await this.contract.tokenURI(1);
      assert.equal(tokenURI, "https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/1", "wrong token uri");
    });

    it("should transfer token from one owner to another", async function () {
      await this.contract.transferFrom(account_one, account_two, 3);
      // validate token transfer
      let balance = await this.contract.balanceOf(account_two);
      assert.equal(balance, 3, "wrong token balance");
    });
  });

  describe("have ownership properties", function () {
    beforeEach(async function () {
      this.contract = await ERC721MintableComplete.new({ from: account_one });
    });

    it("should fail when minting when address is not contract owner", async function () {
      let failed = false;
      try {
        await this.contract.mint(account_one, 1, { from: account_two });
      } catch (e) {
        failed = true;
      }
      assert.equal(failed, true, "should not mint token from other than contract owoner account");
    });

    it("should return contract owner", async function () {
      let owner = await this.contract.getOwner.call();
      assert.equal(owner, account_one, "Contract owner is wrong");
    });
  });
});
