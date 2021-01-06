
--[[
	Functions I like to use when debugging on colsole 
]]

-- easily make 'printf' 
--Example: 
-- printf("Hello, my name is %s and I am %d years old", name, age )
if( printf == nil ) then 
	function printf(...)
		print(string.format( unpack(arg) ))
	end 
end 

-- handy to print out an object/table 
if( dumpToString == nil ) then 
	function dumpToString(obj, count)
		--print("dump:" .. tostring(obj))
		if type(obj) == 'table' then
			local retVal =  string.rep('  ', count) .. '{ '
			for k,v in pairs(obj) do
				retVal =  retVal ..  tostring(k) .. ':' .. dumpToString(v, count+1) .. ', '
			end
			return retVal .. ' },'
		elseif type(obj) == 'string' then 
			return '"' ..  tostring(obj) .. '"'
		else 
			return tostring(obj) 
		end
	end
end 


-- here I redefine 'print' so that all the print statements go to a debug string table and 
-- we can then view the debug strings in the credits. 
if( oldPrint == nil ) then 
	oldPrint = print

	function ResetDebugLog()
		debugLog = { "Debug log:" }
	end 
	
	ResetDebugLog() -- create our debug log for print stuff to go to 

	print = function (...)
		if( table.getn(arg) > 0 ) then 
			local count = table.getn(debugLog)
			debugLog[count+1] = arg[1]
		end
		oldPrint(unpack(arg))
	end 
end 

-- function to set the debug strings on the credits 
if ( SetDebugStuffOnCredits == nil ) then 
	function SetDebugStuffOnCredits( listOfStrings )
		local numberOfStrings = table.getn(listOfStrings)
		local numCredits = table.getn(CreditLines)
		local debugStringIndex = 1
		local creditIndex = 1
		
		--print("SetDebugStuffOnCredits numCredits:" .. numCredits .. " numberOfStrings: " .. numberOfStrings )
			
		while ( debugStringIndex <= numberOfStrings and creditIndex <= numCredits ) do 
			if( CreditLines[creditIndex]["str"] ~= nil ) then 
				CreditLines[creditIndex]["str"] = listOfStrings[debugStringIndex]
				debugStringIndex = debugStringIndex +1
			end 
			creditIndex = creditIndex + 1
		end 
	end 
end 


-- as the name implies 
function PrintGlobalStringsContaining(keyword )
	-- logic to gather the data / debug strings 
	print("Global variables that have '" .. keyword ..  "' in them: " )
	local location = nil 
	local lowercase_key = ""
	keyword = string.lower( keyword )
	for k,v in pairs(_G) do
		lowercase_key = string.lower(k)
		location = string.find(lowercase_key, keyword) 
		if (location ~= nil  ) then 
			print( k ) -- we've redefined 'print' to add to our debug strings 
		end
	end 
end 

-- overwrite the function that is called when the user presses the 'credits' button to first set the 
--ifs_movietrans_PushScreen(ifs_credits)
if( old_ifs_movietrans_PushScreen == nil ) then 
	old_ifs_movietrans_PushScreen = ifs_movietrans_PushScreen
	ifs_movietrans_PushScreen = function(...)
		if( arg[1] == ifs_credits) then 
			---------- do optional stuff here to populate the debug log -------------------
			--ResetDebugLog()
			--PrintGlobalStringsContaining("download")
			--ListConsoleCommands()
			--print("io: " .. dumpToString(io, 0))
			--print("os: ".. dumpToString(os, 0))
			--print("file: ".. dumpToString(file, 0))
			--print("debug: ".. dumpToString(debug, 0))
			--local used, thresh = gcinfo()
			--print("used mem: ".. used .. " gc threshold: " .. thresh)

			SetDebugStuffOnCredits( debugLog )
		end 
		old_ifs_movietrans_PushScreen(unpack(arg))
	end 
end 


--[[
when executing a script from a SWBFII file (.script or .lvl)
We need to do this:    
ReadDataFile("name_of_file_with_ext")
ScriptCB_DoFile("script_to_execute")
]]