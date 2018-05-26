pragma solidity ^0.4.18;
// We have to specify what version of compiler this code will compile with

contract Betting {
  /* mapping field below is equivalent to an associative array or hash.
  The key of the mapping is candidate name stored as type bytes32 and value is
  an unsigned integer to store the vote count
  */
  mapping (bytes32 => uint8) public betsReceived;
  /* The same logic applies to this mapping variable: it tracks which address
  has voted for which candidate (bytes32) throughout the voting */
  mapping (bytes32 => mapping (address => uint256)) public bets;
  /* This address specifies the owner of the contract in order to restrict access
  to certain contract functions*/
  address owner;
  /* Boolean to verify if voting is still active */
  bool votingActive = true;
  /* winner */
  bytes32 winner; 
  uint256 numCandidates;
  uint256 numvoters;

  /* Events can be emitted by functions in order to notify listener (off-chain)
  applications of the occurrence of a certain event */
  event Print(bytes32[] _name);

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /* Solidity doesn't let you pass in an array of strings in the constructor (yet).
  We will use an array of bytes32 instead to store the list of candidates
  */
  bytes32[] public candidateList;
  /* Adress array to store all addresses that have participated in the voting.*/
  address[] public voters;

  /* This is the constructor which will be called once when you
  deploy the contract to the blockchain. When we deploy the contract,
  we will pass an array of candidates who will be contesting in the election.
  In recent version of Solidity the constructor has been replaced by the
  contract name without function keyword: Voting(...) - equivalent to Java syntax.
  */
  constructor() public {
    owner = msg.sender;
    numCandidates = 0;
  }

  /* Getter function that returns candidate list. */
  function getCandidateList() public constant returns (bytes32[]) {
      return candidateList;
  }

  /* Getter function that returns contract owner address */
  function getOwner() public constant returns (address) {
      return owner;
  }

  /* Getter function that returns the number of candidates */
  function getCount() public constant returns (uint256) {
      return candidateList.length;
  }

  function getBalance() public constant returns (uint256) {
      return address(this).balance;
  }

  //Function that adds candidate to candidate list. Can only be called by owner.
  function addCandidate(bytes32 candidate) onlyOwner public returns (bool) {
      candidateList.push(candidate);
      numCandidates += 1;
      return true;
  }

  //Function that adds candidate to candidate list. Can only be called by owner.
  function addWinner(bytes32 selectedwinner) onlyOwner public returns (bool) {
      winner = selectedwinner;
      return true;
  }

  // This function returns the total votes a candidate has received so far.
  function totalVotesFor(bytes32 candidate) view public returns (uint8) {
    require(validCandidate(candidate));
    return betsReceived[candidate];
  }

  // This function increments the vote count for the specified candidate. This
  // is equivalent to casting a vote.
  function betOnCandidate(bytes32 candidate) public payable  {
    require(msg.value >= 1 ether);
    require(validCandidate(candidate));
    // require(bets[msg.sender] == 0x0);
    voters.push(msg.sender);
    bets[candidate][msg.sender] += msg.value;
    betsReceived[candidate] += 1;
  }

  // This function checks if the provided candidate is element of the candidate
  // list and returns a boolean.
  function validCandidate(bytes32 candidate) view public returns (bool) {
    for(uint i = 0; i < candidateList.length; i++) {
      if (candidateList[i] == candidate) {
        return true;
      }
    }
    return false;
  }
  
  function getWinner() public returns (uint256) {
    if (numCandidates == 0) return;
    return (uint(keccak256(block.blockhash(block.number - 1))) % numCandidates);
  }

  // Function to close voting and handle payout. Can only be called by the owner.
  function closeVoting() onlyOwner public returns (bytes32) {
      require(votingActive);
      uint winningVotes = 0;
      bytes32 winningCandidate = candidateList[getWinner()];
      /*for (uint p = 0; p < candidateList.length; p++) {
          if (betsReceived[candidateList[p]] > winningVotes) {
              winningVotes = betsReceived[candidateList[p]];
              winningCandidate = candidateList[p];
          }
      }*/
      uint256 remaining = (address(this).balance) * 4 / 5;
      address[] storage winners;
      for (uint x = 0; x < voters.length; x++) {
          if (bets[winningCandidate][voters[x]] > 0) {
              require(address(this).balance >= prize + 1);
              winners.push(voters[x]);
          }
      }
      
      uint256 prize = remaining * 1 / 5;
      for (uint x1 = 0; x1 < winners.length; x1++) {
              winners[x1].transfer(prize);
      }
      votingActive = false;
      return winningCandidate;
  }
}
