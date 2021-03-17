pragma solidity ^0.5.0;

import "./ERC721Mintable.sol";

import "./Verifier.sol";

// TODO define a contract call to the zokrates generated solidity contract <Verifier> or <renamedVerifier>
contract SqareVerifier is Verifier {

}

// TODO define another contract named SolnSquareVerifier that inherits from your ERC721Mintable class
contract SolnSquareVerifier is DigiHouseToken {
	// TODO define a solutions struct that can hold an index & an address
	struct Solution {
		uint256 index;
		address addr;
		bool isSolved;
		bool isUsed;
	}

	// TODO define an array of the above struct
	mapping(uint256 => Solution) solutionMapping;

	// TODO define a mapping to store unique solutions submitted
	mapping(bytes32 => bool) uniqueSolution;

	// TODO Create an event to emit when a solution is added
	event SolutionAdded(address solutioner, uint256 index);

	// TODO Create a function to add the solutions to the array and emit the event
	function addSolution(
		address addr,
		uint256 index,
		uint256[2] memory a,
		uint256[2][2] memory b,
		uint256[2] memory c,
		uint256[2] memory input
	) public {
		require(sqareVerifier.verifyTx(a, b, c, input), "Invalid solution");
		bytes32 inputHash = keccak256(abi.encodePacked(a, b, c, input));
		require(uniqueSolution[inputHash] == false, "Solution already exists.");
		uniqueSolution[inputHash] = true;
		solutionMapping[index] = Solution(index, addr, true, false);
		emit SolutionAdded(addr, index);
	}

	// TODO Create a function to mint new NFT only after the solution has been verified
	//  - make sure the solution is unique (has not been used before)
	//  - make sure you handle metadata as well as tokenSuplly
	function mintNFT(address to, uint256 tokenId) public returns (bool) {
		require(solutionMapping[tokenId].isSolved, "Solution is not verified");
		require(solutionMapping[tokenId].isUsed == false, "Solution has been used before to mint token");
		require(solutionMapping[tokenId].addr == to, "Verifier address is not same as minter");

		bool temp = super.mint(to, tokenId);
		solutionMapping[tokenId].isUsed = true;
		return temp;
	}

	SqareVerifier sqareVerifier;

	constructor(address verifierContractAddress) public {
		sqareVerifier = SqareVerifier(verifierContractAddress);
	}
}
