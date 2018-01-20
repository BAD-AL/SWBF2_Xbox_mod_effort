-- This file is called from missionlist.lua like:
--      ReadDataFile("custom.lvl")
--      ScriptCB_DoFile("custom1")

-- load in the levels that were DLC on the Original XBOX
--[[ Here is all the files the DLC Installer installed. 
	...$c\4c41001a00000003\ContentImage.xbx
	...$c\4c41001a00000003\contentmeta.xbx
	...$c\4c41001a00000003\manifest
	...$c\4c41001a00000003\_LVL_XBOX\addme.script
	...$c\4c41001a00000003\_LVL_XBOX\core.lvl
	...$c\4c41001a00000003\_LVL_XBOX\mission.lvl
	...$c\4c41001a00000003\_LVL_XBOX\KAS\kas2.lvl
	...$c\4c41001a00000004\ContentImage.xbx
	...$c\4c41001a00000004\contentmeta.xbx
	...$c\4c41001a00000004\manifest
	...$c\4c41001a00000004\_LVL_XBOX\addme.script
	...$c\4c41001a00000004\_LVL_XBOX\core.lvl
	...$c\4c41001a00000004\_LVL_XBOX\mission.lvl
	...$c\4c41001a00000004\_LVL_XBOX\BES\bes2.lvl
	...$c\4c41001a00000004\_LVL_XBOX\COR\cor1.lvl
	...$c\4c41001a00000004\_LVL_XBOX\MYG\myg1.lvl
	...$c\4c41001a00000004\_LVL_XBOX\NAB\nab2.lvl
	...$c\4c41001a00000004\_LVL_XBOX\RHN\Rhn1.lvl
	...$c\4c41001a00000004\_LVL_XBOX\RHN\Rhn2.lvl
	...$c\4c41001a00000004\_LVL_XBOX\SIDE\dlc.lvl
	...$c\4c41001a00000004\_LVL_XBOX\SOUND\hero.lvl
	...$c\4c41001a00000004\_LVL_XBOX\YAV\yav2.lvl
	...$u\contentmeta.xbx
	...$u\default.xbe
	...$u\downloader.xbe
	...$u\manifest
	...$u\data\_lvl_xbox\common.lvl
	...$u\data\_lvl_xbox\core.lvl
	...$u\data\_lvl_xbox\ingame.lvl
	...$u\data\_lvl_xbox\shell.lvl
	
	The 'default.xbe' should go to the 'StarWarsBattlefront2' directory (rename the previous one 'default.xbe.old').
	for common.lvl, core.lvl & shell.lvl, we'll only use the newest one.
	The 'addme.script' files will be thrown out, we'll have to write the code that adds in the levels.
	the other stuff goes in the respective folders at "StarWarsBattlefront2/Data/_LVL_XBOX/".
]]--

--  Example:
--   directory : "ABC"
--   levelFile : "ABC.lvl"
--   gcw : 1 or 0  (Galatic civil war era)
--   cw  : 1 or 0  (Clone wars era)
--   gcw_conquest : 1 or 0 
--   cw_conquest  : 1 or 0
--   gcw_2flag : 1 or 0 
--   cw_2flag  : 1 or 0 
--   gcw_1flag : 1 or 0 
--   cw_1flag  : 1 or 0 
--   hero_assult : 1 or 0 
function AddContent( directory, levelFile, gcw, cw, gcw_conquest, cw_conquest, gcw_2flag, cw_2flag, gcw_1flag, cw_1flag, hero_assult)
	local prefix = string.gsub(levelFile, ".lvl", "")
	local item = { mapluafile = directory .. "%s_%s", era_g = gcw, era_c = cw, mode_con_g = gcw_conquest, 
	               mode_con_c  = cw_conquest, mode_ctf_g = gcw_2flag, mode_ctf_c  = cw_2flag, mode_1flag_g = gcw_1flag, 
				   mode_1flag_c  = cw_1flag, mode_eli_g = hero_assult,}
	-- add the item to the single player and multi player list boxes
	local sp_sz = table.getn(sp_missionselect_listbox_contents)
	local mp_sz = table.getn(mp_missionselect_listbox_contents)
	sp_missionselect_listbox_contents[sp_sz+1] = item
	mp_missionselect_listbox_contents[mp_sz+1] = item

end

function LoadOrigDLCLevels()
	-- redefine the tables here 
	sp_missionselect_listbox_contents = {
		-- In the below list, the first '%s' will be replaced by the era,
		-- and the second will be replaced by the multiplayer variant name
		-- (the part after "mode_")
	--    { mapluafile = "TEST1%s",   era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1,},
	    { mapluafile = "bes2%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1,  mode_ctf_c = 1, mode_ctf_g = 1, mode_eli_g = 1, },
		{ mapluafile = "cor1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1,  mode_eli_g = 1, },
		{ mapluafile = "dag1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1,},
		{ mapluafile = "dea1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_1flag_c = 1, mode_1flag_g = 1, },
		{ mapluafile = "end1%s_%s", era_g = 1,                            mode_con_g = 1, mode_hunt_g = 1, mode_1flag_g = 1, },
		{ mapluafile = "fel1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_1flag_c = 1, mode_1flag_g = 1,},
		{ mapluafile = "geo1%s_%s",            era_c = 1, mode_con_c = 1, mode_ctf_c = 1, mode_hunt_c = 1, mode_xl_c = 1},
		{ mapluafile = "hot1%s_%s", era_g = 1,            mode_con_g = 1, mode_1flag_g = 1, mode_hunt_g = 1, mode_xl_g = 1},
		{ mapluafile = "kam1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_1flag_c = 1, mode_1flag_g = 1,},
		{ mapluafile = "kas2%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_hunt_c = 1,  mode_ctf_c = 1, mode_ctf_g = 1, mode_eli_g = 1,},
		{ mapluafile = "mus1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1,},
		{ mapluafile = "myg1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1, mode_eli_g = 1,},
		{ mapluafile = "nab2%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1,  mode_hunt_c = 1, mode_eli_g = 1,},
		{ mapluafile = "pol1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1,},
	    { mapluafile = "rhn1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_1flag_c = 1, mode_1flag_g = 1, mode_hunt_c = 1, mode_eli_g = 1,},
	    { mapluafile = "rhn2%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1, mode_1flag_c = 1, mode_1flag_g = 1,  mode_eli_g = 1,},
		{ mapluafile = "spa1%s_%s", era_g = 1,            mode_assault_g = 1, mode_1flag_g = 1,},
	--    { mapluafile = "spa2%s_%s",            era_c = 1, mode_con_c = 1, mode_con_g = 1, },
		{ mapluafile = "spa3%s_%s",            era_c = 1, mode_assault_c = 1, mode_1flag_c = 1,},
		--{ mapluafile = "spa4%s_%s", era_g = 1,            mode_con_c = 1, mode_con_g = 1, },
		{ mapluafile = "spa6%s_%s",            era_c = 1, mode_assault_c = 1, mode_1flag_c = 1, },
		{ mapluafile = "spa7%s_%s",            era_c = 1, mode_assault_c = 1, mode_1flag_c = 1, },
		{ mapluafile = "spa8%s_%s", era_g = 1,            mode_assault_g = 1, mode_1flag_g = 1,},
		{ mapluafile = "spa9%s_%s", era_g = 1,            mode_assault_g = 1, mode_1flag_g = 1,},
		{ mapluafile = "tan1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_1flag_c = 1, mode_1flag_g = 1,},
		{ mapluafile = "tat2%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1, mode_hunt_g = 1, mode_eli_g = 1,},
		{ mapluafile = "tat3%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_1flag_c = 1, mode_1flag_g = 1,},
		{ mapluafile = "uta1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_1flag_c = 1, mode_1flag_g = 1,},
		{ mapluafile = "yav1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_1flag_c = 1, mode_1flag_g = 1,},
		{ mapluafile = "yav2%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1, mode_1flag_c = 1, mode_1flag_g = 1,  mode_eli_g = 1,},
		--{ mapluafile = "kor1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, },
		--{ mapluafile = "sal1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, },
		--{ mapluafile = "spa3%s_%s", era_g = 1,            mode_con_c = 1, mode_con_g = 1, },
		--{ mapluafile = "spa4%s_%s", era_g = 1,            mode_con_c = 1, mode_con_g = 1, },
	}
	mp_missionselect_listbox_contents = sp_missionselect_listbox_contents
	--ReadDataFile("dlc_kas_core.lvl")  
	--ReadDataFile("dlc_bes_core.lvl")  -- doesn't seem to be necessary, strings show up ok without this loaded
	--ReadDataFile("dlc_kas_mission.lvl")  -- Hero Assult mission for Kashyyyk defined in here
	--ReadDataFile("dlc_bes_mission.lvl")  -- Expansion pack missions defined in here
	--[[ReadDataFile("dlc_bes_mission.lvl", "bes2g_con","bes2c_con","bes2g_ctf","bes2c_ctf","bes2g_eli",
	                                    "cor1g_eli","myg1g_eli","nab2g_eli",
										"rhn1g_con","rhn1c_con","rhn1c_1flag","rhn1g_1flag","rhn1g_hunt","rhn1g_eli",
										"rhn2g_con","rhn2c_con","rhn2g_ctf","rhn2c_ctf","rhn2c_1flag","rhn2g_1flag","rhn2g_eli",
										"yav2g_con","yav2c_con","yav2g_ctf","yav2c_ctf","yav2c_1flag","yav2g_1flag","yav2g_eli")
	--]]									
end

function DbgMsg() 
    local a = ""
    if OldReadDataFile then  a = "game.objectives.complete"  end
    ShowMessageText(a, 1)
end

LoadOrigDLCLevels()
