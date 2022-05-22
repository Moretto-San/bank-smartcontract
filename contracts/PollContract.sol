// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Poll {
    address public pollOwner;
    string public pollName;
    string[] private pollItens;
    int[] private pollItensVotes;
    address[] private voters;

    constructor() {
        pollOwner = msg.sender;
    }

    function setPoolName(string memory _name) external {
        require(
            msg.sender == pollOwner,
            "You must be the owner of the poll to insert poll itens"
        );
        pollName = _name;
    }

    function includePoolItem(string memory _item) external {
        require(
            msg.sender == pollOwner,
            "You must be the owner of the poll to insert poll itens"
        );

        require(
            !itemInThePoll(_item),
            "item already in the poll"
        );

        pollItens.push(_item);
        pollItensVotes.push(0);
    }

    function getPollItens() external view returns (string[] memory) {
        return pollItens;
    }

    function voteItem(string memory _item) public payable {
        require(
            !alreadyVoted(msg.sender),
            "address already voted"
        );

        require(
            itemInThePoll(_item),
            "item not in the poll"
        );

        for (uint i; i < pollItens.length; i++) {
            if(compareStrings(pollItens[i], _item))
                pollItensVotes[i]++;
        }

        voters.push(msg.sender);
    }

    function getPollItemVotes() external view returns (int[] memory) {
        return pollItensVotes;
    }

    function alreadyVoted(address _address)internal view returns (bool){
        for (uint i; i < voters.length; i++) {
            if (voters[i] == _address)
                return true;
        }
        return false;
    }

    function itemInThePoll(string memory _item)internal view returns (bool){
        if(pollItens.length>0)
            for (uint i; i < pollItens.length; i++) {
                if(compareStrings(pollItens[i], _item))
                    return true;
            }
        return false;
    }

    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
}