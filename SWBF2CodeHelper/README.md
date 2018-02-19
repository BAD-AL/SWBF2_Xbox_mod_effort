This program attempts to decompile Luac compiled lua files (version 5.0.2).
It currently needs luac.exe to generate the luac 'listing' (luac.exe -l compiledLuafile).
I find it easier to see what's going on working with this listing syntax than the raw bytes of the compiled lua file.
If you would like to dive into this program, the first thing that would be useful would be to first play around with
the luac program; compileing lua files and taking a look at what the listing looks like.
The next step is to read through 'ANoFrillsIntroToLua5VMInstructions.pdf'. 
If you're still interested in going further, then crack open the SWBF2CodeHelper.sln.
The most interesting file is 'LuaCodeHelper3.cs'. The '3' just means that it's the 3rd time I re-wrote this class.

As of this writing, the program is not yet in a releasable state. I've still not done the work for decompiling loops and
'TEST' operations. But it is in a state where it has helped me recover rather simple lua files (like most of the mission files
from SWBF2 in mission.lvl).

