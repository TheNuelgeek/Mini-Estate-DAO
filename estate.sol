// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
// buyer should be able to see howmany houses he bought
// estate manger should be able to see howmany houses sold and the buyers
contract Building{

    uint id = 1;
    uint housePrice = 10 ether;

    struct Estate{
        // address HouseOwners;
        uint256 numOfownedHouses;
        mapping(address => uint[]) ownersToHousesOwned;
        BuyerView b;
    }

    struct BuyerView {
        uint estateID;
        uint numOfHousesBought;
        address buyer;
        uint[] housesID;
    }

    mapping (uint=>Estate) estateID;
    address estateOwner;
    address[] private buyers;
    mapping(address => bool)  hasBought;

    constructor(){
        estateOwner = msg.sender; 
    }

    modifier onlyOwner{
        require(msg.sender == estateOwner, "you do not have access to this estate");
        _;
    }

    function buyHouse( address buyer)public  payable returns(string memory message){
        //require(msg.sender == buyer,"sorry bro");
        require(msg.value == housePrice, "price is 10 Ether");
        Estate storage e = estateID[id];
        e.numOfownedHouses += 1;
        e.ownersToHousesOwned[buyer].push(e.numOfownedHouses);
        if (!hasBought[buyer]){
            buyers.push(buyer);
        }
        hasBought[buyer] = true;
        message = "!You've succefully bought a House";
    }

    function seeHousesBought()public onlyOwner view returns(BuyerView[] memory) {
        
        Estate storage _estate = estateID[id];
        BuyerView[] memory _buyerViews = new BuyerView[](buyers.length);

        for (uint i=0; i < buyers.length; i++){
            address _buyer = buyers[i];
            uint[] memory _boughtHouses = _estate.ownersToHousesOwned[_buyer];
            // struct BuyerView {
            //     uint estateID;
            //     uint numOfHousesBought;
            //     address buyer;
            //     uint[] housesID;
            // }
            BuyerView memory _buyerView =  BuyerView({
                estateID: id,
                numOfHousesBought: _boughtHouses.length,
                buyer: _buyer,
                housesID: _boughtHouses
            });
            _buyerViews[i] = _buyerView;
        }

        return _buyerViews;

    }

    function buyerChecknumOfHouseBought(address buyerAddr) external view returns(uint[]memory num){
        Estate storage _estate = estateID[id];
        require(hasBought[buyerAddr],"you didn't buy an house");
        num = _estate.ownersToHousesOwned[buyerAddr];
    }

}