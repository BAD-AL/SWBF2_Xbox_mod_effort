--Search through the missionlist to find a map that matches mapName,
--then insert the new flags into said entry.
--Use this when you know the map already exists, but this content patch is just
--[[adding new gamemodes (otherwise you should just add whole new entries to the missionlist)
function AddNewGameModes(missionList, mapName, newFlags)
	for i, mission in missionList do
		if mission.mapluafile == mapName then
			for flag, value in pairs(newFlags) do
				mission[flag] = value
			end
		end
	end
end
]] 

--------------------------------------------------------------------------
-- functionality to add strings 
if( modStringTable == nil ) then
	modStringTable = {} -- table to hold custom strings 
	
	-- function to add custom strings  
	function addModString(stringId, content)
		modStringTable[stringId] = ScriptCB_tounicode(content)
	end 

	if oldScriptCB_getlocalizestr == nil then 
		-- Overwrite 'ScriptCB_getlocalizestr()' to first check for the strings we added
		print("redefine: ScriptCB_getlocalizestr() ")

		oldScriptCB_getlocalizestr = ScriptCB_getlocalizestr
		ScriptCB_getlocalizestr = function (...)
			local stringId = " "
			if( table.getn(arg) > 0 ) then 
				stringId = arg[1]
			end
			if( modStringTable[stringId] ~= nil) then -- first check 'our' strings
				retVal = modStringTable[stringId]
			else 
				retVal = oldScriptCB_getlocalizestr( unpack(arg) )
			end 
			return retVal 
		end
	end 
end

-- Force 'IFText_fnSetString' to use strings from our 'modStringTable' too 
if ( oldIFText_fnSetString == nil )then 
    oldIFText_fnSetString = IFText_fnSetString
    IFText_fnSetString = function(...)
        if( table.getn(arg) > 1 and modStringTable[arg[2]] ~= nil ) then 
            arg[2] = modStringTable[arg[2]]
            IFText_fnSetUString(unpack(arg))
            return 
        end 
        oldIFText_fnSetString(unpack(arg))
    end 
end 

--addModString("mapname.name.cor1", "Fancy Coruscant")
addModString("mapname.name.XMS", "Christmas Town")
addModString("mapname.description.XMS", "Dann Boeing's Christmas in Jinglin' town(XBOX port) " .. 
			"Supports Up to 4 player split screen! But disconnect controllers 3 & 4 with only 1 or 2 players. " ..
			"No heros or cars with 3-4 players")
--insert totally new maps here:
local sp_n = 0
local mp_n = 0
sp_n = table.getn(sp_missionselect_listbox_contents)

sp_missionselect_listbox_contents[sp_n+1] = { isModLevel = 1, mapluafile = "XMS%s_%s", era_g = 1, era_c = 1, mode_con_g = 1, mode_con_c  = 1,  mode_hunt_c = 1,  mode_hunt_g = 1, }

mp_n = table.getn(mp_missionselect_listbox_contents)
mp_missionselect_listbox_contents[mp_n+1] = sp_missionselect_listbox_contents[sp_n+1]


-- associate this mission name with the current downloadable content directory
-- (this tells the engine which maps are downloaded, so you need to include all new mission lua's here)
-- first arg: mapluafile from above
-- second arg: mission script name
-- third arg: level memory modifier.  the arg to LuaScript.cpp: DEFAULT_MODEL_MEMORY_PLUS(x) 
print("XMS adding content ")
AddDownloadableContent("XMS","XMSg_con",4)
AddDownloadableContent("XMS","XMSc_con",4)
AddDownloadableContent("XMS","XMSc_hunt",4)
AddDownloadableContent("XMS","XMSg_hunt",4)
--AddDownloadableContent("XMS","XMSg_ctf",4)
--AddDownloadableContent("XMS","XMSc_ctf",4)
--AddDownloadableContent("XMS","XMSg_1flag",4)
--AddDownloadableContent("XMS","XMSc_1flag",4)


if(  ScriptCB_GetPlatform() == "PC" ) then 
-- Now load our core.lvl into the shell to add our localize keys
	ReadDataFile("..\\..\\addon\\XMS\\data\\_LVL_PC\\core.lvl")
end 

-- all done
newEntry = nil
n = nil
