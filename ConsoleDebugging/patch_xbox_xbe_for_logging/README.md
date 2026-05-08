# SWBF1 & SWBF2 XBOX Logging
It is now possible to enable logging (Star Wars Battlefront  1, Star Wars Battlefront 2) on the OG XBOX by 
patching the  `default.xbe` file.

The XBOX must be modded and the game must be installed on your HDD. 
The log is printed to
 *  `<Game folder>\BFront1.log` (BF1)
 *  `<Game folder>\BFront2.log` (BF2)

Example log from my Xbox: [BFront2.log](BFront2.log).

Claude and Gemini were utalized to study the xbe, write the documentation and the `Python 3` patch programs.

 ### Python Patch Script Usage
 #### Star Wars Battlefront  1
```Sh
# when SWBF1's 'default.xbe' is in the same folder
$ python3 patch_xbe_print_log_bf1.py 

# if you have named your .xbe file ' bf1.default.xbe'
$ python3 patch_xbe_print_log_bf1.py bf1.default.xbe

```
 #### Star Wars Battlefront  2
 ```Sh
# when SWBF2's 'default.xbe' is in the same folder
$ python3 patch_xbe_print_log_bf2.py 

# if you have named your .xbe file ' bf2.default.xbe'
$ python3 patch_xbe_print_log_bf1.py bf2default.xbe

```

### Notes
 * If you have the Title Update installed, you may need to remove the title update .xbe in order to get the debug log to work.

 * Strangely, the log file is referenced as 'D:\BFront2.log' by the game xbe. 'D' usually means the 'DVD' drive, but it looks like 'D' ends up meaning `where the game root lives`.
 * The functions `ScriptCB_CancelSessionList() (bf2); ScriptCB_DoFriendAction() (bf1)` were hijacked to enable the print logging. 

 * Not tested with XEMU, but you may need to install the game on XEMU's HDD to get the logging to work.

 * Does not seem to work on running on Modded XBOX 360 from a thumb drive.
