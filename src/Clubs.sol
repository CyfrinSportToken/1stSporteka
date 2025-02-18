// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "./SportekaToken.sol";

contract Club is ERC20 {
    constructor(
        string memory name,
        string memory symbol,
       
        uint256 amount
    ) ERC20(name, symbol) {
        _mint(msg.sender, amount);
    }
}

contract ClubsFactory is Ownable {
    uint256 constant maxClubTokens = 10 ** 27;
    mapping(string => address) public clubs;
    mapping(string => uint256) public prices;
  
    SportekaToken sportekaToken;

    constructor(
        address initialOwner,
        address _sportekaToken
    ) Ownable(initialOwner) {
        sportekaToken = SportekaToken(_sportekaToken);
    }

    function addClub(
        string memory name,
        string memory symbol,
        uint256 stadiumsize,
        uint256 seatPrice 
      
    ) public onlyOwner {
        
        require(clubs[name] == address(0), "Club exists");
        clubs[name] = address(new Club(name, symbol,maxClubTokens));
        prices[name] = uint256(stadiumsize*seatPrice);
        
        
        
    }

    function buyClubToken(
        string memory clubName,
        uint256 amountOfToken
    ) public {
        require(clubs[clubName] != address(0), "Club not exist");
        uint256 price = prices[clubName];
        sportekaToken.transferFrom(
            msg.sender,
            address(this),
            price * amountOfToken
        );
        Club(clubs[clubName]).transfer(msg.sender, amountOfToken);
    }

    function sellClubToken(
        string memory clubName,
        uint256 amountOfToken
    ) public {
        require(clubs[clubName] != address(0), "Club not exist");
        uint256 price = prices[clubName];
        Club(clubs[clubName]).transferFrom(
            msg.sender,
            address(this),
            amountOfToken
        );
        sportekaToken.transfer(msg.sender, amountOfToken / price);
    }
}
