pragma solidity ^0.8.17;


import "./BaseCrowdSale.sol";

contract TimetCappedCrowdSale is BaseCrowdSale {
	using SafeMath for uint256;

	uint256 public fundingCap;

	constructor(
		uint256 _startTime,
		uint256 _endTime,
		uint256 _cap,
		IToken _token,
		address payable _wallet
	) BaseCrowdSale(_startTime, _endTime, _token, _wallet) {
		require(_cap > 0, "TimetCappedCrowdSale: cap is 0");
		fundingCap = _cap;
	}

	// Modifier to check if the cap has been reached
	modifier hasCap() {
		require(weiRaised < fundingCap, "TimetCappedCrowdSale: cap reached");
	_;

	//Modifier to check if the sale is open
	modifier isSaleOpen() {
		require(block.timestamp >= startTime && block.timestamp <= endTime, "TimetCappedCrowdSale: sale is not open");

	// Override buyTokens function to add the cap check
	function buyTokens(address beneficiary) public payable {
		isSaleOpen();
		hasCap();
		super.buyTokens(beneficiary);
		weiRaised = weiRaised.add(msg.value);
	}	

	
		I

	o
