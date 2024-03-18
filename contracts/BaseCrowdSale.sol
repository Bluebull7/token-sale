pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// Define an interface for the Token
interface IToken {
	function mint(address to, uint256 amount) external;
}

contract BaseCrowdsale is Ownable { //Inherit from Ownable for acess control
	using SafeMath for uint256;

	// State Variables
	uinnt256 public saleStartTime;
	uint256 public saleEndTime;
	Itoken public token;
	address payable public wallet;
	uint256 public rate; // How many token units a buyer gets per wei
	uint256 public weiRaised; // Amount of raised money in wei

	// Events
	event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

	// Constructor
	
	constructor (
		uint256 _startTime,
		uint256 _endTime,
		Itoken _token,
		address payable _wallet
	) {
		require(_startTime >= block.timestamp, "Start time is before current time");
		require(_endTime >= _startTime, "End time is before start time");
		require(_token != address(0), "Token is the zero address");
		require(_wallet != address(0), "Wallet is the zero address");

		saleStartTime = _startTime;
		saleEndTime = _endTime;
		token = _token;
		wallet = _wallet;
	}
	
	// Fall back function
	fallback() external payable {
		buyTokens(msg.sender);
	}

	// Token purchase function (Buy tokens)
	function buyTokens(address beneficiary) public payable {
		// Add basic checks (sale ongoing, beneficiary is not zero address, value is not zero)
		require(block.timestamp >= saleStartTime && block.timestamp <= saleEndTime, "Sale is not active");
		require(beneficiary != address(0), "Beneficiary is the zero address");
		require(msg.value != 0, "Value is 0");

	//Calculate the token amount based on contribution value
		uint256 weiAmount = msg.value;
		uint256 tokens = weiAmount.mul(rate);
	// Use token.mint() to mint tokens to the beneficiary
		token.mint(beneficiary, tokens);
	// Update the amount of wei weiRaised	
		weiRaised = weiRaised.add(weiAmount);
	// Emit the TokensPurchased Events
		emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
	// Forward the funds to the Wallet
		_forwardFunds();
	}

"""	function buyTokens(address _beneficiary) public payable {
		require(_beneficiary != address(0), "Beneficiary is the zero address");
		require(msg.value != 0, "Value is 0");

		uint256 weiAmount = msg.value;
		uint256 tokens = weiAmount.mul(rate);

		weiRaised = weiRaised.add(weiAmount);

		token.mint(_beneficiary, tokens);
		emit TokensPurchased(msg.sender, _beneficiary, weiAmount, tokens);

		_forwardFunds();
"""
	}

