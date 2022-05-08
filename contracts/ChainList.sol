pragma solidity ^0.4.18;

import "./Ownable.sol";

contract ChainList is Ownable {
  // custom types
  struct Article {
    uint256 id;
    address seller;
    address buyer;
    string name;
    string description;
    uint256 price;
  }

  // state variables

  mapping (uint => Article) public articles;
  uint articleCounter;



  event LogSellArticle(
    uint indexed _id,
    address indexed _seller,
    string _name,
    uint256 _price
    );

  event LogBuyArticle(
    uint indexed _id,
    address indexed _seller,
    address indexed _buyer,
    string _name,
    uint256 _price
    );


    //deactivate the contract

    function kill() public onlyOwner {
      selfdestruct(owner);
    }

    // events

  //sell an article
  function sellArticle(string _name, string _description, uint256 _price) public {
    //a new article

    articleCounter ++;
    articles[articleCounter] = Article(
      articleCounter,
      msg.sender,
      0x0,
      _name,
      _description,
      _price
      );

    LogSellArticle(articleCounter, msg.sender, _name, _price);
  }

  // get number of articles in the contracts

  function getNumberOfArticles() public view returns (uint) {
    return articleCounter;
  }

  // fetch and return all article IDS for articles still for sale

  function getArticlesForSale() public view returns (uint[]){
    //prepare output array
    uint[] memory articleIds = new uint[](articleCounter);

    uint numberOfArticlesForSale = 0;

    // iterate oer the articlesRow

for(uint i = 1; i <= articleCounter; i++){
  // keep the id if the article is still for sale
  if(articles[i].buyer == 0x0) {
    articleIds[numberOfArticlesForSale] = articles[i].id;
    numberOfArticlesForSale++;
  }

}
//copy the articlesIDs array into a smaller for sale array
 uint[] memory forSale = new uint[](numberOfArticlesForSale);
 for(uint j = 0; j < numberOfArticlesForSale; j++){
   forSale[j] = articleIds[j];
 }
 return forSale;


  }



  // buy an articles

  function buyArticle(uint _id) payable public {
    // we check there is an article for scale
    require(articleCounter > 0);

    // we check that the article exists

    require(_id > 0 && _id <= articleCounter);

    // retrieve the article from the mapping

    Article storage article = articles[_id];

    // we check that the article is not Sold
    require (article.buyer == 0x0);

    // we dont allow seller to buy his own articles
    require(msg.sender != article.seller);

    // we check that the value sent corresponds to the proce of the article
    require(msg.value == article.price);

    // keep buyer's information
    article.buyer = msg.sender;

    // the buyer can pay the _seller
    article.seller.transfer(msg.value);

    // trigger the events
    LogBuyArticle(_id, article.seller, article.buyer, article.name, article.price);


  }

}
