Small example of how to create a custom .lvl file with code that we would like to execute.

The important files are:
	custom.req     -- needs to reference the files that will go into the .lvl file
	custom1.lua    -- code to add
	munge.bat      -- Builds the .lvl file, places it in the current directory.

In game script you'll need to add code like:
ReadDataFile("custom.lvl")
ScriptCB_DoFile("custom1")    
