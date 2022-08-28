pragma solidity ^0.8.0;

contract voting{
    address private owner;
    address[] private voterList;
    uint private maxVoters = 500; //An arbitrary number to limit voter in an electrorate
    uint startTime;
    mapping (string => uint) private votes;
    mapping (address => uint)private voterStatus;

     
    modifier onlyOwner(address _address){
        require(_address==owner,"You are not authorized :(");
        _;
    }
    modifier onlyAfter(){
        require(block.timestamp-startTime >= 21600, "Election time not over yet");//election result to be available only 6 hours ofninitiation
        _;
    }
    modifier validVoter(address _address){
        require(voterStatus[_address]==1,"You are not a valid voter!!");
        require(voterStatus[_address]!=2, "You have already voted :)");
        _;
    }
    modifier validVote(uint _vote){
        require(_vote<=3,"Invalid vote, please try again :(");
        _;
    }
    modifier votersLimit(address[] memory _address){
        require(_address.length <= maxVoters,"No. of voters is more than the maximum limit");
        _;
    }
    constructor(){
        owner = msg.sender;
    }
    event setvoters(address electionOfficer, address[] voters);
    event castvote(address voter, uint _vote);

    function setVoters(address[] memory _address)public votersLimit(_address) onlyOwner(msg.sender){
        voterList = _address;
        startTime = block.timestamp;
        for(uint i=0; i<voterList.length;i++){
            voterStatus[voterList[i]]=1;
        }
        emit setvoters(msg.sender,voterList);
    }
    function castVote(uint vote) public validVoter(msg.sender) validVote(vote){
        voterStatus[msg.sender] = 2;
        if(vote==0){
            votes["A"]++;
        }
        else if(vote==1){
            votes["B"]++;    
        }
        else if(vote==2){
            votes["C"]++;
        }
        else
            votes["nota"]++;
        //It is assumed that there are only 3 contestents
        emit castvote(msg.sender,vote);
    }

    function checkWinner() public onlyAfter returns(string[] memory, uint[] memory){
        string[] memory candidates = new string[](4);
        uint[] memory votesGot = new uint[](4);

        candidates[0] = "A";
        votesGot[0] = votes["A"];
        candidates[1] = "B";
        votesGot[1] = votes["B"];
        candidates[2] = "C";
        votesGot[2] = votes["C"];
        candidates[3] = "nota";
        votesGot[3] = votes["nota"];

        return(candidates, votesGot);
    }

}