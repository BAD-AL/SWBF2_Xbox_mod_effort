Get SPTest to work with the new Game from steam (also may need to have the registry key mentioned in 
 thread: https://www.swbfgamers.com/index.php?topic=14406.0 ).


SPText.exe crashes for a few reasons with the 2020 Steam Game.
1. It is incompatible with the new 'binkw32.dll'.
2. There are a few new functions and a new table defined in the latest exe 
   (which are referenced in the new .lvls).

For the new functions & table, I modified 'shell_interface' and 'game_interface' to define them.

The incompatibility with 'binkw32.lvl' forced me to create another folder alongside 'GameData' 
 which I called 'Debug'.

In the Debug folder I have SPTest.exe and the 2004 version of 'binkw32.lvl' in there; 
 and copied 'eax.dll' & 'unicows.dll' from 'GameData' there too.

Then I make directory links to Addon and Gamedata.

You just have to place the 'Debug' folder next to your 'Gamedata' folder and run the 'setup_Sptest.bat' file.

Solution Posted to SWBFGamers downloads too.

