-- This Lua file has been modified from the default style addme to be used with 
-- the normal 'DLC' addon method and the 'Alternate addon' method [https://github.com/Gametoast/AltAddonSystem/tree/main/StarWarsBattlefrontII/addon]

--Search through the missionlist to find a map that matches mapName,
--then insert the new flags into said entry.
--Use this when you know the map already exists, but this content patch is just
--adding new gamemodes (otherwise you should just add whole new entries to the missionlist)
function AddNewGameModes(missionList, mapName, newFlags)
	for i, mission in missionList do
		if mission.mapluafile == mapName then
			for flag, value in pairs(newFlags) do
				mission[flag] = value
			end
		end
	end
end

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

addModString("mapname.name.AMA", "Amador Forest")
addModString("mapname.description.AMA", "YodaKid's beautiful Amador forest")

local newEntry = { isModLevel = 1, mapluafile = "AMA%s_%s", era_g = 1, era_c = 1, era_fl = 1, mode_con_g = 1, mode_con_c  = 1, mode_con_fl  = 1,}
table.insert(sp_missionselect_listbox_contents, newEntry)
table.insert(mp_missionselect_listbox_contents, newEntry)

-------------- Add the Flower Power era ---------------------------------------
table.insert( gMapEras,  {
	key = "era_fl", 
	showstr = "common.era.fl", 
	subst = "fl", -- should match what comes after the underscore of the 'key'
	Team1Name = "common.sides.rep.name", -- Team 1 name 
	Team2Name = "common.sides.cis.name", -- Team 2 name 
	icon1 = "flower_icon", 
	icon2 = "flower_icon",
})
addModString("common.era.fl", "Flower Power")
------------------------------------------------------------------------------

-- Do the stuff below if we are a 'DLC addon'
if( ScriptCB_IsFileExist("addon\\013\\mission.lvl") ~= 1 ) then
	-- associate this mission name with the current downloadable content directory
	-- (this tells the engine which maps are downloaded, so you need to include all new mission lua's here)
	-- first arg: mapluafile from above
	-- second arg: mission script name
	-- third arg: level memory modifier.  the arg to LuaScript.cpp: DEFAULT_MODEL_MEMORY_PLUS(x)

	AddDownloadableContent("AMA","AMAg_con",4)
	AddDownloadableContent("AMA","AMAc_con",4)
	AddDownloadableContent("AMA","AMAfl_con",4)

	if(ScriptCB_GetPlatform() == "PC") then 
		-- Now load our core.lvl into the shell to add our localize keys
		ReadDataFile("..\\..\\addon\\AMA\\data\\_LVL_PC\\core.lvl")
	end 
end 