# JournalMainQuestOnly
Simple tes3mp script that saves only main quest to world.json so guild and house progress can be done separately by each player.

It's a copy of [partial journal sharing](https://forum.openmw.org/viewtopic.php?f=45&t=5035&start=10) made into a script for 
0.7 alpha.

## Installation

1. Download the ```main.lua``` and put it in */server/scripts/custom/JournalMainQuestOnly*
2. Open ```config.lua``` (*/server/scripts/* directory) and change ```config.shareJournal``` to **false** in order for the script to work properly
3. Open ```customScripts.lua``` and add this code on separate line: ```require("custom/JournalMainQuestOnly/main")```


Thanks to David C. for the code.




