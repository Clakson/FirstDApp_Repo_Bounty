# Functionalities added: why and how they work.

## Quest start and end time - Time is important for control purposes.

First we add a start time and end time when a quest is created using the Unix timestamp format, now when players try to join a Quest, the contract will check if the time is within limits (we use the OPCODE `timestamp` to get the current Unix timestamp), the end time is also checked when the **submitQuest** function is called.

# Quest review functionality - Quest reviewing is essential as a functionality, it allows for players to be rewarded for correctly completing a Quest.

We start with adding a new enum named **questReward** so our options are established within the smart contract, a mapping is also added to handle each player Quest review status, finally, a new function **reviewSubmission** will control everything related to this feature.
This function's parameters are **questId** which correspond to the Quest reviewed, **questReward_** for an admin to select which status a submission will receive and **playerAddress** that is the reviewed player's address, finally we check that the Quest exist by performing a call to the **questExists** function.
As for the require statements they will check that the function caller is indeed an admin, that **questReward_**'s value is between 1-3 and that the reviewed player has already submitted their Quest. To wrap things up, we use if/if-else statements to check which option did the admin input and the player's Quest reward status will change accordingly.