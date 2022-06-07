// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity >=0.8.0;

// ============ Internal Imports ============
import "../Outbox.sol";
import {IValidatorManager} from "../../interfaces/IValidatorManager.sol";
import {MerkleLib} from "../../libs/Merkle.sol";

contract TestOutbox is Outbox {
    constructor(uint32 _localDomain) Outbox(_localDomain) {} // solhint-disable-line no-empty-blocks

    /**
     * @notice Set the validator manager
     * @param _validatorManager Address of the validator manager
     */
    function testSetValidatorManager(address _validatorManager) external {
        validatorManager = IValidatorManager(_validatorManager);
    }

    function proof() external view returns (bytes32[32] memory) {
        bytes32[32] memory _zeroes = MerkleLib.zeroHashes();
        uint256 _index = tree.count - 1;
        bytes32[32] memory _proof;

        for (uint256 i = 0; i < 32; i++) {
            uint256 _ithBit = (_index >> i) & 0x01;
            if (_ithBit == 1) {
                _proof[i] = tree.branch[i];
            } else {
                _proof[i] = _zeroes[i];
            }
        }
        return _proof;
    }

    function branch() external view returns (bytes32[32] memory) {
        return tree.branch;
    }

    function branchRoot(MerkleLib.Proof calldata _proof)
        external
        pure
        returns (bytes32)
    {
        return MerkleLib.branchRoot(_proof);
    }

    function impliesDifferingLeaf(
        MerkleLib.Proof calldata _a,
        MerkleLib.Proof calldata _b
    ) external pure returns (bool) {
        return MerkleLib.impliesDifferingLeaf(_a, _b);
    }

    function testFail() external {
        fail();
    }
}
