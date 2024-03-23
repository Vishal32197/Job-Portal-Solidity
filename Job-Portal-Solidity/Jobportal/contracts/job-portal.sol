// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract JobPortal {

    struct Applicant {
        string name;
        string skills;
        uint rating;
    }
    
    struct Job {
        string title;
        string description;
        address filledBy; 
    }
    
    mapping(address => Applicant) public applicants;
    
    mapping(uint => Job) public jobs;
    uint public jobIdCounter;
    
    modifier onlyAdmin {
        require(msg.sender == adminAddress, "Only admin can call this function");
        _;
    }
    
    address public adminAddress;
    
    constructor() {
        adminAddress = msg.sender;
    }
    
    function addApplicant(address _applicant, string memory _name, string memory _skills) public onlyAdmin {
        applicants[_applicant] = Applicant(_name, _skills, 0);
    }
    
    function getApplicantDetails(address _applicant) public view returns (string memory, string memory, uint) {
        Applicant storage applicant = applicants[_applicant];
        return (applicant.name, applicant.skills, applicant.rating);
    }
    
    function addJob(string memory _title, string memory _description) public onlyAdmin {
        jobIdCounter++;
        jobs[jobIdCounter] = Job(_title, _description, address(0));
    }

    function getJobDetails(uint _jobId) public view returns (string memory, string memory, address) {
        Job storage job = jobs[_jobId];
        return (job.title, job.description, job.filledBy);
    }
    
  function applyForJob(uint _jobId) public {
    require(jobs[_jobId].filledBy == address(0), "Job already filled");
    jobs[_jobId].filledBy = msg.sender;
}
    
    function provideRating(address _applicant, uint _rating) public onlyAdmin {
        require(_rating >= 0 && _rating <= 5, "Rating must be between 0 and 5");
        applicants[_applicant].rating = _rating;
    }
    
    function getApplicantRating(address _applicant) public view returns (uint) {
        return applicants[_applicant].rating;
    }

}
