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

--if( ScriptCB_IsFileExist("debug\\menu_debug.lvl")) then 
--    ReadDataFile("debug\\menu_debug.lvl")
--    ScriptCB_DoFile("menu_debug")
--end 

--------------------------------------------------------------------------
dumpToString = function(obj, count)
	--print("dump:" .. tostring(obj))
	if type(obj) == 'table' then
		if( count == nil ) then count = 0 end 

		local retVal =  string.rep('  ', count) .. '{ '
		for k,v in pairs(obj) do
			--print(string.format("dump: k = %s v = %s ", tostring(k), tostring(v)))
			retVal =  retVal ..  tostring(k) .. ':' .. dumpToString(v, count+1) .. ', '
		end
		return retVal .. ' },'
	elseif type(obj) == 'string' then 
		return '"' ..  tostring(obj) .. '"'
	else 
		return tostring(obj) 
	end
end
print("BOM addme----")

if(printMissionList == nil ) then 
	printMissionList = function()
		local limit = table.getn(sp_missionselect_listbox_contents)
		for i=1,limit,1 do 
			printf("mission_list[%d]=%s",i,dumpToString(sp_missionselect_listbox_contents[i]))
		end 
	end 
end 

--print("mission_list before:")
--printMissionList()

--print(" dofile('exec.lua')" )
--dofile("exec.lua")
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

addModString("mapname.name.BOM", "Realm of Chaos")
addModString("mapname.description.BOM", "The Realm of Chaos\n" ..
	"Location Unknown, the Realm of Chaos is a place where firepower has no limit and the battle has been taken to a new level of Insanity; " ..
	"WARNING: EXTREME FIREPOWER!"
)
addModString("common.era.k1", "Clone War Chaos")
addModString("common.era.k2", "Galactic Chaos")

-- Add the new Eras ------------------------------------------------------------------
table.insert( gMapEras,  {
	key = "era_k1", 
	showstr = "common.era.k1", 
	subst = "k1", -- should match what comes after the underscore of the 'key'
	Team1Name = "common.sides.rep.name", -- Team 1 name 
	Team2Name = "common.sides.cis.name", -- Team 2 name 
	icon1 = "kaos_icon", 
	icon2 = "kaos_icon",
})

table.insert( gMapEras, {
	key = "era_k2", 
	showstr = "common.era.k2", 
	subst = "k2", -- should match what comes after the underscore of the 'key'
	Team1Name = "common.sides.all.name", -- Team 1 name 
	Team2Name = "common.sides.imp.name", -- Team 2 name 
	icon1 = "kaos_icon", 
	icon2 = "kaos_icon",
})

------------------------------------------------------------------------------------
--[[
gMapModes --> 'mode_list' (on PC)

	missions: 
	kamino: kam1k1_con
	Add the era for kamino 
]]

--insert the new gamemodes or maps here for pre-existing maps:
-- sp_missionselect_listbox_contents
--AddNewGameModes(sp_missionselect_listbox_contents, "kam1%s_%s", {era_k1 = 1, mode_con_k1 = 1, era_k2 = 1, mode_con_k2 = 1, })
--AddNewGameModes(sp_missionselect_listbox_contents, "bes2%s_%s", {era_k1 = 1, mode_con_k1 = 1, era_k2 = 1, mode_con_k2 = 1, })
AddNewGameModes(sp_missionselect_listbox_contents, "bes2%s_%s", {era_k2 = 1, mode_con_k2 = 1, })
AddNewGameModes(sp_missionselect_listbox_contents, "geo1%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(sp_missionselect_listbox_contents, "dea1%s_%s", {era_k1 = 1, era_k2 = 1, mode_con_k1 = 1, mode_1flag_k2 = 1, })
AddNewGameModes(sp_missionselect_listbox_contents, "dea1%s_%s", { era_k2 = 1, mode_1flag_k2 = 1, })
--AddNewGameModes(sp_missionselect_listbox_contents, "end1%s_%s", {era_k2 = 1, mode_con_k2 = 1 })
--AddNewGameModes(sp_missionselect_listbox_contents, "dag1%s_%s", {era_k1 = 1, mode_con_k1 = 1 }) 
AddNewGameModes(sp_missionselect_listbox_contents, "hot1%s_%s", {era_k2 = 1, mode_con_k2 = 1 })
--AddNewGameModes(sp_missionselect_listbox_contents, "kas2%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(sp_missionselect_listbox_contents, "mus1%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(sp_missionselect_listbox_contents, "nab2%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(sp_missionselect_listbox_contents, "pol1%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(sp_missionselect_listbox_contents, "tat2%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(sp_missionselect_listbox_contents, "tat3%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(sp_missionselect_listbox_contents, "uta1%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(sp_missionselect_listbox_contents, "yav1%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(sp_missionselect_listbox_contents, "rhn1%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(sp_missionselect_listbox_contents, "rhn2%s_%s", {era_k2 = 1, mode_con_k2 = 1 })

--mp_missionselect_listbox_contents
AddNewGameModes(mp_missionselect_listbox_contents, "kam1%s_%s", {era_k1 = 1, mode_con_k1 = 1, era_k2 = 1, mode_con_k2 = 1, })
--AddNewGameModes(mp_missionselect_listbox_contents, "bes2%s_%s", {era_k1 = 1, mode_con_k1 = 1, era_k2 = 1, mode_con_k2 = 1, })
AddNewGameModes(mp_missionselect_listbox_contents, "bes2%s_%s", {era_k2 = 1, mode_con_k2 = 1, })
AddNewGameModes(mp_missionselect_listbox_contents, "geo1%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(mp_missionselect_listbox_contents, "dea1%s_%s", {era_k1 = 1, era_k2 = 1, mode_con_k1 = 1, mode_1flag_k2 = 1, })
AddNewGameModes(mp_missionselect_listbox_contents, "dea1%s_%s", { era_k2 = 1, mode_1flag_k2 = 1, })
--AddNewGameModes(mp_missionselect_listbox_contents, "end1%s_%s", {era_k2 = 1, mode_con_k2 = 1 })
--AddNewGameModes(mp_missionselect_listbox_contents, "dag1%s_%s", {era_k1 = 1, mode_con_k1 = 1 }) 
AddNewGameModes(mp_missionselect_listbox_contents, "hot1%s_%s", {era_k2 = 1, mode_con_k2 = 1 })
--AddNewGameModes(mp_missionselect_listbox_contents, "kas2%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(mp_missionselect_listbox_contents, "mus1%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(mp_missionselect_listbox_contents, "nab2%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(mp_missionselect_listbox_contents, "pol1%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(mp_missionselect_listbox_contents, "tat2%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(mp_missionselect_listbox_contents, "tat3%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(mp_missionselect_listbox_contents, "uta1%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(mp_missionselect_listbox_contents, "yav1%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(mp_missionselect_listbox_contents, "rhn1%s_%s", {era_k1 = 1, mode_con_k1 = 1 })
--AddNewGameModes(mp_missionselect_listbox_contents, "rhn2%s_%s", {era_k2 = 1, mode_con_k2 = 1 })

--insert totally new maps here:
local sp_n = table.getn(sp_missionselect_listbox_contents)
sp_missionselect_listbox_contents[sp_n+1] = { isModLevel = 1, mapluafile = "BOM%s_%s",
	--era_g = 1, era_c = 1, mode_con_g = 1, mode_con_c  = 1, 
	era_k1 = 1, mode_con_k1 = 1, era_k2 = 1, mode_con_k2 = 1,
}
local mp_n = table.getn(mp_missionselect_listbox_contents)
mp_missionselect_listbox_contents[mp_n+1] = sp_missionselect_listbox_contents[sp_n+1]
--table.insert(sp_missionselect_listbox_contents, newEntry)
--table.insert(mp_missionselect_listbox_contents, newEntry)

-- associate this mission name with the current downloadable content directory
-- (this tells the engine which maps are downloaded, so you need to include all new mission lua's here)
-- first arg: mapluafile from above
-- second arg: mission script name
-- third arg: level memory modifier.  the arg to LuaScript.cpp: DEFAULT_MODEL_MEMORY_PLUS(x)
--AddDownloadableContent("BOM","BOMg_con",   1) -- realm of chaos (gcw) - 
--AddDownloadableContent("BOM","BOMc_con",   1) -- ROC (cw) 
AddDownloadableContent("BOM","bomk1_con",  1) -- ROC (cw) 
AddDownloadableContent("BOM","bomk2_con",  1) -- realm of chaos (gcw) - 
AddDownloadableContent("BOM","bes2k2_con", 1) -- Bespin (gcw) - 
--AddDownloadableContent("BOM","bes2k1_con", 1) -- Bespin (cw) 
--AddDownloadableContent("BOM","kam1k1_con", 1) -- kamino chaos clones +
--AddDownloadableContent("BOM","kam1k2_con", 1) -- kamino chaos gcw +
AddDownloadableContent("BOM","geo1k1_con", 1) -- geonosis  chaos clones -  
----AddDownloadableContent("BOM","geo1k2_con", 1) -- geonosis  chaos gcw 
--AddDownloadableContent("BOM","dea1k1_con", 1) -- death star chaos clones + 
AddDownloadableContent("BOM","dea1k2_1flag", 1)-- death star chaos gcw 1flag  
--AddDownloadableContent("BOM","end1k2_con", 1) -- endor chaos gcw            + 
--AddDownloadableContent("BOM","dag1k1_con", 1) -- Dagobah chaos clones 

AddDownloadableContent("BOM","hot1k2_con", 1) -- Hoth  chaos gcw            + 

--AddDownloadableContent("BOM","kas2k1_con", 1) -- Wookie World  chaos clones +
--AddDownloadableContent("BOM","mus1k1_con", 1) -- Mustifar  chaos clones     + 
--AddDownloadableContent("BOM","nab2k1_con", 1) -- naboo chaos clones         + 
--AddDownloadableContent("BOM","pol1k1_con", 1) -- polis masa clones          + 
--AddDownloadableContent("BOM","tat2k1_con", 1) -- Mos Eisley clones          + 

--AddDownloadableContent("BOM","tat3k1_con", 1) -- Jaba Palace clones         + 18
--AddDownloadableContent("BOM","uta1k1_con", 1) -- uta1  clones               +
--AddDownloadableContent("BOM","rhn1k1_con", 1) -- rhn1 clones                + 20

--AddDownloadableContent("BOM","rhn2k2_con", 1) -- rhn2 gcw                   + 
--AddDownloadableContent("BOM","yav1k1_con", 1) -- yav1  clones               +

--print("mission_list after:")
--printMissionList()

-- all done
newEntry = nil

-- TODO: 
-- add strings: 
--   weapons.rep.weap.rep_weap_inf_shell="Flashy Blast Grenade"
--   weapons.rep.weap.rep_weap_inf_shockshell="Super Shock Grenade"
--   weapons.tat.weap.tat_weap_inf_bowcaster="Ionization Blaster"
--   weapons.tat.weap.tat_weap_inf_jawa_launcher="Jawa Launcher"
--   weapons.tat.weap.tat_weap_inf_boeing_bomb="The Boeing Bomb (Warning: No Escape)"
--   kit fisto  [0x73c0fab1="Kit Fisto"]
--   ventress   [0x305f4b6e="Asajj Ventress"]
--   improve Icons 
--   imp_weap_inf_boeing_bom
--   all_weap_inf_boeing_bomb



