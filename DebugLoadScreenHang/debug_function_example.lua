-- Shows a different image as a load screen as an aid in debugging 
-- need to place the debug load screens in the main game's loadscreen folder 
-- numbers 1 - 20 are valid input; a red 'x' image shows on bad input 
function ShowDebugLoadScreen( num)
    local dbgLoadScreen = "load\\dbg\\common.x.lvl" -- used for bad user input 
    if(num > 0 and num < 21) then 
        dbgLoadScreen = string.format("load\\dbg\\common.%d.lvl", num)
    end 
    print("gonna show: " .. dbgLoadScreen)
    if( ScriptCB_IsFileExist(dbgLoadScreen)) then 
        ReadDataFile(dbgLoadScreen)
		ScriptCB_UpdateScreen() -- I'm not sure if this line really helps
		print("This slows down things for the screen to update " .. fib(31))
    end 
end 


-- calculates a fibonacci number; used to 'pause' script execution 
function fib( num )
	if( num < 2) then 
		return num 
	end 
	return fib(num -1) + fib(num - 2) 
end 