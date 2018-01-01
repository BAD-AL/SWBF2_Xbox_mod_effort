Small example of how to create a custom .lvl file with code that we would like to execute.

The important files are:
	custom.req     -- needs to reference the files that will go into the .lvl file
	custom1.lua    -- code to add
	custom2.lua    -- another code file to add
	munge.bat      -- Builds the .lvl file, places it in the current directory.

In game script you'll need to add code like:
ReadDataFile("custom.lvl")
ScriptCB_DoFile("custom2")    
FunctionCallDefinedInCustom2()  -- This line is not necessary, but possible if the function is defined in 'custom2.lua'
                                -- You could just put the code you want to execute in the 'custom2.lua' file and it'll run.
