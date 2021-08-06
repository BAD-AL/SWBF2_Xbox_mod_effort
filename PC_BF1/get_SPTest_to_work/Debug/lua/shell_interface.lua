-- Update from Steam version (6/24/2020)
-- Master include for StarWars: Frontline ingame interface, lua
-- component. The game should be able to include this file and nothing
-- else.

-- Read in some globals for what platform, online service will be in use
gPlatformStr = ScriptCB_GetPlatform()
gOnlineServiceStr = ScriptCB_GetOnlineService()


-- avoid crashy-stuff in SPTest
if( ScriptCB_GetStringWidth == nil ) then 

	print("defining 'ScriptCB_GetStringWidth(font,str)'")

	ScriptCB_GetStringWidth = function(font, str_to_measure)
		-- always called with "gamefont_medium"
		-- give each character 8 pixels?
		local retVal = strlen(str_to_measure) * 8 
		return retVal 
	end 
	
	
	ScriptCB_GetCurrentAspect = function ()
		return 0.5625
	end 
	
	ScriptCB_GetTargetAspect = function()
		return 0.75
	end 
	
	ScriptCB_IsLastInputFromJoystick = function()
		return nil  
	end 
	
	 gCurScreenTable = {} 
end 



-- Josh's utility stuff
ScriptCB_DoFile("globals")

--
--
-- Load interface utility functions, elements (ifelem_*)
ScriptCB_DoFile("interface_util")
ScriptCB_DoFile("ifelem_button")
ScriptCB_DoFile("ifelem_roundbutton")
ScriptCB_DoFile("ifelem_flatbutton")
ScriptCB_DoFile("ifelem_buttonwindow")
ScriptCB_DoFile("ifelem_segline")
ScriptCB_DoFile("ifelem_popup")
ScriptCB_DoFile("ifelem_listmanager")
ScriptCB_DoFile("ifelem_AnimationMgr")
ScriptCB_DoFile("ifelem_shellscreen")
ScriptCB_DoFile("ifelem_titlebar")
ScriptCB_DoFile("ifelem_borderrect")
ScriptCB_DoFile("ifelem_hslider")
-- And utility functions for just the shell.
ScriptCB_DoFile("ifelem_mappreview")
ScriptCB_DoFile("ifelem_titlebar_large")
ScriptCB_DoFile("ifs_movietrans")
ScriptCB_DoFile("ifs_attract")
ScriptCB_DoFile("ifs_mp_lobby_quick")
-- Pull in list of missions.
ScriptCB_DoFile("missionlist")

if(gPlatformStr == "PC") then
	ScriptCB_DoFile("ifutil_mouse")
	ScriptCB_DoFile("ifelem_editbox")
	ScriptCB_DoFile("ifs_pckeyboard")	

	ScriptCB_DoFile("ifs_missionselect_pcMulti")	
	--ScriptCB_DoFile("ifs_missionselect_pcSingle")	
end
--
--

-- Load all the screens, which'll self-register themselves into C/C++

-- Utility stuff first.
ScriptCB_DoFile("popups_common")
ScriptCB_DoFile("popup_ab")
ScriptCB_DoFile("popup_ok")
ScriptCB_DoFile("popup_yesno")
ScriptCB_DoFile("popup_loadsave2")
ScriptCB_DoFile("error_popup")
ScriptCB_DoFile("popup_yesno_large")
ScriptCB_DoFile("popup_ok_large")

ScriptCB_DoFile("ifs_vkeyboard")

ScriptCB_DoFile("ifs_boot")
ScriptCB_DoFile("ifs_legal")
ScriptCB_DoFile("ifs_start")
ScriptCB_DoFile("ifs_login")
ScriptCB_DoFile("ifs_main")
ScriptCB_DoFile("ifs_saveop")

-- MP (shared) files
ScriptCB_DoFile("ifs_mp")
ScriptCB_DoFile("ifs_mp_main")
ScriptCB_DoFile("ifs_mp_sessionlist")
ScriptCB_DoFile("ifs_mp_lobby")
ScriptCB_DoFile("ifs_mp_lobbyds")
ScriptCB_DoFile("ifs_mp_joinds")
ScriptCB_DoFile("ifs_mp_gameopts")
ScriptCB_DoFile("ifs_mp_maptype")
if(gPlatformStr == "PS2") then
	ScriptCB_DoFile("ifs_mpps2_netconfig")
	ScriptCB_DoFile("ifs_mpps2_dnas")
	ScriptCB_DoFile("ifs_mpps2_eula")
	ScriptCB_DoFile("ifs_mpps2_patch")
end

--if(gPlatformStr == "PC") then
--	ScriptCB_DoFile("ifs_mpgs_pclogin")
--else
--	ScriptCB_DoFile("ifs_mpgs_login")
--end

ScriptCB_DoFile("ifs_mpgs_login")
ScriptCB_DoFile("ifs_mp_autonet")

ScriptCB_DoFile("popups_lobby")
ScriptCB_DoFile("popup_busy")

--ScriptCB_DoFile("ifs_split_main")
ScriptCB_DoFile("ifs_split_map")
ScriptCB_DoFile("ifs_split_profile")

ScriptCB_DoFile("ifs_sp")
ScriptCB_DoFile("ifs_difficulty")
ScriptCB_DoFile("ifs_sp_era")
ScriptCB_DoFile("ifs_sp_briefing")
ScriptCB_DoFile("ifs_sp_yoda")

ScriptCB_DoFile("ifs_instant_top")
ScriptCB_DoFile("ifs_instant_side")


ScriptCB_DoFile("ifs_missionselect")

-- Metagame screens
-- (metagame_* needs to be executed before ifs_meta_*)
ScriptCB_DoFile("metagame_state")
ScriptCB_DoFile("metagame_util")
ScriptCB_DoFile("metagame_ai")
ScriptCB_DoFile("ifs_meta_top")
ScriptCB_DoFile("ifs_meta_main")
ScriptCB_DoFile("ifs_meta_main_display")
ScriptCB_DoFile("ifs_meta_main_logic")
ScriptCB_DoFile("ifs_meta_main_input")
ScriptCB_DoFile("ifs_meta_battle")
ScriptCB_DoFile("ifs_meta_deathstar")
ScriptCB_DoFile("popups_meta_main")
ScriptCB_DoFile("ifs_meta_new_load")
ScriptCB_DoFile("ifs_meta_load")
ScriptCB_DoFile("ifs_meta_opts")
ScriptCB_DoFile("ifs_meta_configs")
ScriptCB_DoFile("ifs_meta_movie")
ScriptCB_DoFile("ifs_meta_tutorial")

-- Unused screens (wasn't in this week's metagame)
--ScriptCB_DoFile("ifs_meta_options")
--ScriptCB_DoFile("ifs_meta_info")
--ScriptCB_DoFile("ifs_meta_bonus")
--ScriptCB_DoFile("ifs_meta_intro")

-- Options screens
ScriptCB_DoFile("ifs_opt_top")
ScriptCB_DoFile("ifs_opt_general")
ScriptCB_DoFile("ifs_opt_sound")
ScriptCB_DoFile("ifs_opt_mp")
--ScriptCB_DoFile("ifs_opt_controller_mode")
ScriptCB_DoFile("ifs_opt_controller_common")
ScriptCB_DoFile("ifs_opt_controller_vehunit")
if(gPlatformStr == "PC") then
	--ScriptCB_DoFile("ifs_opt_pckeyboard")
	ScriptCB_DoFile("ifs_opt_pccontrols")
	ScriptCB_DoFile("ifs_opt_pcvideo")
end

-- unlockables
ScriptCB_DoFile("ifs_unlockables")
ScriptCB_DoFile("ifs_tutorials")
ScriptCB_DoFile("ifs_credits")


-- Pull in XBox-only pages (with mpxl in the name)
if(gOnlineServiceStr == "XLive") then
	ScriptCB_DoFile("ifs_mpxl_login")
	ScriptCB_DoFile("ifs_mpxl_silentlogin")
	ScriptCB_DoFile("ifs_mpxl_optimatch")
	ScriptCB_DoFile("ifs_mpxl_friends")
	ScriptCB_DoFile("ifs_mpxl_feedback")
	ScriptCB_DoFile("ifs_mpxl_voicemail")
	--ScriptCB_DoFile("ifs_mp_leaderboard")
	--ScriptCB_DoFile("ifs_mp_leaderboarddetails")
end

-- Set the first screen shown on entry
ifs_movietrans_PushScreen(ifs_boot)

-- read sound data
ReadDataFile("sound\\shell.lvl")

-- open voice over stream
gVoiceOverStream = OpenAudioStream("sound\\shell.lvl", "shell_vo")
-- open music stream
gMusicStream     = OpenAudioStream("sound\\shell.lvl", "shell_music")
-- open movie stream
gMovieStream = "movies\\shell.mvs"
gMovieTutorialPostFix = ""
ScriptCB_OpenMovie(gMovieStream, "")
ScriptCB_SetMovieAudioBus("shellmovies")
