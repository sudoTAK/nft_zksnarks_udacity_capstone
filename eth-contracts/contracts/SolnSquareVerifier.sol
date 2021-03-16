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
		address solutioner;
	}

	// TODO define an array of the above struct
	Solution[] solutionArr;

	// TODO define a mapping to store unique solutions submitted
	mapping(bytes32 => bool) submittedSolution;

	// TODO Create an event to emit when a solution is added
	event SolutionAdded(address solutioner);

	// TODO Create a function to add the solutions to the array and emit the event
	function _addSolution(uint256 index, address solAddress) private {
		solutionArr.push(Solution(index, solAddress));
		emit SolutionAdded(solAddress);
	}

	// TODO Create a function to mint new NFT only after the solution has been verified
	//  - make sure the solution is unique (has not been used before)
	//  - make sure you handle metadata as well as tokenSuplly
	function mintNFT(
		address solutionerAddress,
		uint256 index,
		uint256[2] memory a,
		uint256[2][2] memory b,
		uint256[2] memory c,
		uint256[2] memory input
	) public returns (bool) {
		require(sqareVerifier.verifyTx(a, b, c, input), "Invalid solution");
		bytes32 inputHash = keccak256(abi.encodePacked(a, b, c, input));
		require(submittedSolution[inputHash] == false, "Solution already exists.");
		submittedSolution[inputHash] = true;
		_addSolution(index, solutionerAddress);
		return mint(solutionerAddress, index);
	}

	SqareVerifier sqareVerifier;

	constructor(address verifierContractAddress) public {
		sqareVerifier = SqareVerifier(verifierContractAddress);
	}
}
