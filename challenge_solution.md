- What's the event and it used for?

> Events are used to cheaply store and retrieve blockchain data. Events also makes it possible to notify users or dapps that something has happened in a smart contract.

- What parts does the log record have to store?

> A log record stores the address of contract, topics and data

- Where are the variables of different types stored?

> I don't understand this question

- What are Call and DelegateCall?

> A call allows a smart contract to call the function of another contract. A delegateCall allows a smart contract to call the function of another contract but the code executes in the context of the calling contract. If contract A `Calls` another contract B, any get or set operation will be executed on the storage of B and msg.sender (in contract B) will be contract A. But if a contract A `DelegateCall` contract B, any get or set operation will be executed on contract A's storage and msg.sender will be the account that initiates the call to contract A.

- What’s the relationship between them?

> Both allows smart contracts to interact with one another. While Call allows a contract to use both the storage and logic of another contract, DelegateCall allows the calling contract to use only the logic of the called contract.

- What’s the Reentrancy attack/recursive call and how to avoid it?

> A Reentrancy attack occurs when an attacker is able to call the function of a smart contract and bypass the security checks of that function while that same function is being executed. This type of attach usually occur while the attacked contract calls an external contract. 

> A Reentrancy attack can be avoided by using a structuring the logic of a contract properly (e.g by update storage before making external calls), using a reentance guard (e.g is implemented by openzeppelin) and if possible proper restrict calling and called accounts to trusted accounts.

- What’s the relationship and difference between Bytes and String? What are they used
for respectively? When to use Bytes instead of String and String instead of Bytes?

> Data stored as bytes are usually cheaper to work with while data stored as strings can be easily decoded by a frontend application. Call data are also passed to smart contracts as bytes and not strings.

- What do you know about Solidity Bitwise Operations? When should we use them?
> I haven't had the need to bitwise operations in Solidity but I 

## Practical Test: 1

> solution is in practical_test_1.sol

## Practical Test: 2

- solution is in practical_test_2.sol
- Token address: https://goerli.etherscan.io/token/0x2Eaf18DfB31861fe290ed25A035bC52c369C87BF


## Mini Audit
- Find them

> Bid function: is prone to attack. An attacker could bid with an account that rejects ether transfer by `_lastBidder.transfer(_lastBid);`. This will prevent other users from bidding. An effecting way to prevent this is to store each bid in a map and allow previous bidders to withdraw their bids buy calling a function.

> withdrawSale function: does not prevent the owner of the contract from stealing user's bid. The owner of the contract can withdraw the last bid before the bidding ends. A check (`require(now > _timeLimit, "BID_NOT_OVER");`) can be used to ensure that the seller can only withdraw funds after bidding has ended.
