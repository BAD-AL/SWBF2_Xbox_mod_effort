# SWBF2 XBOX Logging
It is now possible to enable logging (Star Wars Battlefront 2) on the OG XBOX by patching the Battlefront 2  `default.xbe` file ( size= 5,008 KB ).

This patch is for the US Retail game. The XBOX must be modded and the game must be installed on your HDD. 
The log is printed to `<Game folder>\BFront2.log` example log from my xbox is in this folder `BFront2.log`.

Claude and Gemini were utalized to study the xbe, write the documentation and the `Python 3` patch program.

To patch your .xbe: 
1.  Be sure that you have python 3 installed.
2. Place your `default.xbe` in the same folder
3. Execute the script : `$ python3 patch_xbe_print_log.py`

A `bf2.debug.xbe` file should be generated, place this file next to your game's `default.xbe` and execute it via the file system browser.
You could also rename it to `default.xbe` to make it your primary .xbe for BF2.


### Notes
 * If you have the Title Update installed, you may need to remove the title update in order to get the debug log to work.

 * Strangely, the log file is referenced as 'D:\BFront2.log' by the game xbe. 'D' usually means the 'DVD' drive, but it looks like 'D' ends up meaning `where the game root lives`.
 * The function `ScriptCB_GetSessionList()` was hijacked to enable the print logging. 

 * Not tested with XEMU, but you may need to install the game on XEMU's HDD to get the logging to work.

 * Does not seem to work on running on Modded XBOX 360 from a thumb drive.