# Bet-with-smart-contracts
An attempt at creating a blockchain based betting platform using smart contracts with solidity.

**NOTE: The code is yet to be tested**

_I am still a beginner and am trying to learn blockchain technology. This is my first programming attempt with solidity._

The following is a solidity contract which creates a betting website by allowing the owner(Betting platform) to add candidates(on whom people bet on) and open the betting. Once betting is open, users get to place their bets on candidates of their choice. Once a candidate wins, the owner gets to enter the winner and then close the betting. The total value of bets against the winner is calculated, a part of it is kept by the owner as a fee, and the rest is divided among the winners.

### Probable improvements
- Add a function showing bets for vs against for each team.
- Allow for changing odds.

I do not plan to actually deploy this on the Ethereum blockchain.
