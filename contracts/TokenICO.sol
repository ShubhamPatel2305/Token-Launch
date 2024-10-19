// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


/**
 * Functions marked external can only be called from outside the contract (i.e., by other contracts or externally through transactions).
 * view Declares that the function will not modify the state of the contract. It only reads the blockchain data.
 * memory specifies where the data will be stored. In Solidity, memory is a temporary storage location (used only during function execution).
 * 
 */
interface ERC20 {
    function transfer(address recepient, uint256 amount) external returns(bool);
    function balanceOf(address account) external view returns(uint256);
    function allowance(address owner, address spender) external view returns(uint256);
    function approve(address spender, uint256 amount) external view returns(bool);
    function transferFrom(address spender, address recepient, uint256 amount) external view returns(bool);
    //symbol
    function symbol() external view returns(string memory);
    //total supply
    function totalSupply() external view returns(uint256);
    //name
    function name() external view returns(string memory);
    
}

contract TokenLaunch{
    address public owner;
    address public tokenAddress;
    uint256 public tokenSalePrice;
    uint256 public soldTokens;

    /**
     * explain modifiers
     */
    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    function updateToken(address _tokenAddress)public onlyOwner{
        tokenAddress = _tokenAddress;
    }

    function updateTokenSalePrice(uint _tokenSalePrice)public onlyOwner{
        tokenSalePrice = _tokenSalePrice;
    }

    function multiply(uint256 x, uint256 y)internal pure returns(uint256 z){
        require(y == 0 || (z = x * y) / y == x, "Multiplication overflow");
    }

    function buyToken(uint256 _tokenAmount)public payable{
        require(msg.value== multiply(_tokenAmount,tokenSalePrice),"Insufficient Ether provided for token purchase");
        ERC20 token = ERC20(tokenAddress);
        require(token.balanceOf(address(this)) >= _tokenAmount, "Not enough token left for sale");

        require(token.transfer(msg.sender, _tokenAmount*1e18));
        payable(owner).transfer(msg.value);
        soldTokens += _tokenAmount;  
    }

    function getTokenDetails()public view returns(string memory name, string memory symbol, uint256 balance, uint256 supply, uint256 tokenPrice, address tokenAddr){
        return(
            ERC20(tokenAddress).name(),
            ERC20(tokenAddress).symbol(),
            ERC20(tokenAddress).balanceOf(address(this)),
            ERC20(tokenAddress).totalSupply(),
            tokenSalePrice,
            tokenAddress
        );
    }

    function transferToOwner(uint256 _amount)external payable{
        require(msg.value>=_amount,"Insufficient funds sent");
        (bool success,)=owner.call{value: _amount}("");
        require(success,"Transfer failed");
    }

    function transferEther(address payable _reciever, uint256 _amount)external payable{
        require(msg.value>=_amount,"Insufficient funds sent");
        (bool success,)=_reciever.call{value: _amount}("");
        require(success,"Transfer failed");
    }

    function withdrawAllTokens() public onlyOwner{
        ERC20 token = ERC20(tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        //if balance >0 do else error
        require(balance>0,"No tokens left to withdraw");
        require(token.transfer(owner,balance),"Transfer failed");

    }
}