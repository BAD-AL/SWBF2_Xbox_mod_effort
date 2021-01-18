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


--insert the new gamemodes or maps here for pre-existing maps:
AddNewGameModes(sp_missionselect_listbox_contents,
				"bes2%s_%s",
				{era_g = 1, mode_con_g = 1,era_c = 1, mode_con_c = 1,era_c = 1, mode_ctf_c = 1,era_g = 1, mode_ctf_g = 1,era_g = 1, mode_eli_g = 1})
				
AddNewGameModes(mp_missionselect_listbox_contents,
				"bes2%s_%s",
				{era_g = 1, mode_con_g = 1,era_c = 1, mode_con_c = 1,era_c = 1, mode_ctf_c = 1,era_g = 1, mode_ctf_g = 1,era_g = 1, mode_eli_g = 1})
				
AddNewGameModes(sp_missionselect_listbox_contents,
				"cor1%s_%s",
				{era_g = 1, mode_eli_g = 1})
				
AddNewGameModes(mp_missionselect_listbox_contents,
				"cor1%s_%s",
				{era_g = 1, mode_eli_g = 1})
				
AddNewGameModes(sp_missionselect_listbox_contents,
				"myg1%s_%s",
				{era_g = 1, mode_eli_g = 1})
				
AddNewGameModes(mp_missionselect_listbox_contents,
				"myg1%s_%s",
				{era_g = 1, mode_eli_g = 1})
				
AddNewGameModes(sp_missionselect_listbox_contents,
				"nab2%s_%s",
				{era_g = 1, mode_eli_g = 1})
				
AddNewGameModes(mp_missionselect_listbox_contents,
				"nab2%s_%s",
				{era_g = 1, mode_eli_g = 1})

AddNewGameModes(sp_missionselect_listbox_contents,
				"rhn1%s_%s",
				{era_g = 1, mode_con_g = 1, era_c = 1, mode_con_c = 1, mode_1flag_g = 1, mode_1flag_c = 1, era_g = 1, mode_hunt_g = 1,era_g = 1, mode_eli_g = 1})
				
AddNewGameModes(mp_missionselect_listbox_contents,
				"rhn1%s_%s",
				{era_g = 1, mode_con_g = 1, era_c = 1, mode_con_c = 1, mode_1flag_g = 1, mode_1flag_c = 1, era_g = 1, mode_hunt_g = 1,era_g = 1, mode_eli_g = 1})

AddNewGameModes(sp_missionselect_listbox_contents,
				"rhn2%s_%s",
				{era_g = 1, mode_con_g = 1, era_c = 1, mode_con_c = 1, mode_ctf_g = 1, mode_ctf_c = 1})
				
AddNewGameModes(mp_missionselect_listbox_contents,
				"rhn2%s_%s",
				{era_g = 1, mode_con_g = 1, era_c = 1, mode_con_c = 1, mode_ctf_g = 1, mode_ctf_c = 1})
				
AddNewGameModes(sp_missionselect_listbox_contents,
				"yav2%s_%s",
				{era_g = 1, mode_con_g = 1, era_c = 1, mode_con_c = 1, mode_eli_g = 1, mode_1flag_g = 1, mode_1flag_c = 1, mode_ctf_g = 1, mode_ctf_c = 1})
				
AddNewGameModes(mp_missionselect_listbox_contents,
				"yav2%s_%s",
				{era_g = 1, mode_con_g = 1, era_c = 1, mode_con_c = 1, mode_eli_g = 1, mode_1flag_g = 1, mode_1flag_c = 1, mode_ctf_g = 1, mode_ctf_c = 1})
				

--insert totally new maps here:
local sp_n = 0
local mp_n = 0
sp_n = table.getn(sp_missionselect_listbox_contents)
sp_missionselect_listbox_contents[sp_n+1] = { mapluafile = "bes2%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1, mode_eli_g = 1,}
mp_n = table.getn(mp_missionselect_listbox_contents)
mp_missionselect_listbox_contents[mp_n+1] = sp_missionselect_listbox_contents[sp_n+1]

sp_n = table.getn(sp_missionselect_listbox_contents)
sp_missionselect_listbox_contents[sp_n+1] = { mapluafile = "rhn1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_1flag_c = 1, mode_1flag_g = 1, era_g = 1, mode_hunt_g = 1, mode_eli_g = 1,}
mp_n = table.getn(mp_missionselect_listbox_contents)
mp_missionselect_listbox_contents[mp_n+1] = sp_missionselect_listbox_contents[sp_n+1]

sp_n = table.getn(sp_missionselect_listbox_contents)
sp_missionselect_listbox_contents[sp_n+1] = { mapluafile = "rhn2%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1, mode_eli_g = 1,}
mp_n = table.getn(mp_missionselect_listbox_contents)
mp_missionselect_listbox_contents[mp_n+1] = sp_missionselect_listbox_contents[sp_n+1]

sp_n = table.getn(sp_missionselect_listbox_contents)
sp_missionselect_listbox_contents[sp_n+1] = { mapluafile = "yav2%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_1flag_c = 1, mode_1flag_g = 1, mode_eli_g = 1, mode_ctf_c = 1, mode_ctf_g = 1,}
mp_n = table.getn(mp_missionselect_listbox_contents)
mp_missionselect_listbox_contents[mp_n+1] = sp_missionselect_listbox_contents[sp_n+1]

--sp_n = table.getn(sp_missionselect_listbox_contents)
--sp_missionselect_listbox_contents[sp_n+1] = { mapluafile = "rhn1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_1flag_c = 1, mode_1flag_g = 1,}
--mp_n = table.getn(mp_missionselect_listbox_contents)
--mp_missionselect_listbox_contents[mp_n+1] = sp_missionselect_listbox_contents[sp_n+1]
				

-- associate this mission name with the current downloadable content directory
-- (this tells the engine which maps are downloaded, so you need to include all new mission lua's here)
-- first arg: mapluafile from above
-- second arg: mission script name
-- third arg: level memory modifier.  the arg to LuaScript.cpp: DEFAULT_MODEL_MEMORY_PLUS(x)
AddDownloadableContent("BES2","bes2g_con",4)
AddDownloadableContent("BES2","bes2c_con",4)
AddDownloadableContent("BES2","bes2g_ctf",4)
AddDownloadableContent("BES2","bes2c_ctf",4)
AddDownloadableContent("BES2","bes2g_eli",4)
AddDownloadableContent("COR1","cor1g_eli",4)
AddDownloadableContent("MYG1","myg1g_eli",4)
AddDownloadableContent("NAB2","nab2g_eli",4)
AddDownloadableContent("NAB2","yav2g_con",4)
AddDownloadableContent("RHN1","rhn1g_con",4)
AddDownloadableContent("RHN1","rhn1c_con",4)
AddDownloadableContent("RHN1","rhn1c_1flag",4)
AddDownloadableContent("RHN1","rhn1g_1flag",4)
AddDownloadableContent("RHN1","rhn1g_hunt",4)
AddDownloadableContent("RHN1","rhn1g_eli",4)
AddDownloadableContent("RHN2","rhn2g_con",4)
AddDownloadableContent("RHN2","rhn2g_eli",4)
AddDownloadableContent("RHN2","rhn2c_con",4)
AddDownloadableContent("RHN2","rhn2g_ctf",4)
AddDownloadableContent("RHN2","rhn2c_ctf",4)
AddDownloadableContent("YAV2","yav2c_con",4)
AddDownloadableContent("YAV2","yav2g_1flag",4)
AddDownloadableContent("YAV2","yav2c_1flag",4)
AddDownloadableContent("YAV2","yav2g_ctf",4)
AddDownloadableContent("YAV2","yav2c_ctf",4)
AddDownloadableContent("YAV2","yav2g_eli",4)

-- all done
newEntry = nil
n = nil
