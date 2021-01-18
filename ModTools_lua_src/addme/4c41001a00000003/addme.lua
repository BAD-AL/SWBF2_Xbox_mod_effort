-- Addme for the XBOX DLC that added Kashyyyk Assult
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

AddNewGameModes(sp_missionselect_listbox_contents, "kas2%s_%s", {era_g = 1,mode_eli_g = 1} )
AddNewGameModes(mp_missionselect_listbox_contents,  "kas2%s_%s", {era_g = 1, mode_eli_g = 1})

AddDownloadableContent("KAS2", "kas2g_eli", 4)

newEntry = nil 
n = nil 
