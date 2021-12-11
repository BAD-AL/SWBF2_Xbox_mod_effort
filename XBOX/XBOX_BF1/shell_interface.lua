-- XBOX BF1
-- shell_interface.lua     
-- generated from Phantom's program
--
-- verified (BAD_AL)

gPlatformStr = ScriptCB_GetPlatform()
gOnlineServiceStr = ScriptCB_GetOnlineService()

ScriptCB_DoFile("globals")
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
ScriptCB_DoFile("ifelem_mappreview")
ScriptCB_DoFile("ifelem_titlebar_large")
ScriptCB_DoFile("ifs_movietrans")
ScriptCB_DoFile("ifs_attract")
ScriptCB_DoFile("ifs_mp_lobby_quick")

if (gPlatformStr == "PC") then 
	ScriptCB_DoFile("ifutil_mouse")
	ScriptCB_DoFile("ifs_pckeyboard")
end

ScriptCB_DoFile("popups_common")

ScriptCB_DoFile("popup_ab")
ScriptCB_DoFile("popup_ok")
ScriptCB_DoFile("popup_yesno")
ScriptCB_DoFile("popup_loadsave")
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
ScriptCB_DoFile("ifs_mp")
ScriptCB_DoFile("ifs_mpgs_login")
ScriptCB_DoFile("ifs_mp_main")
ScriptCB_DoFile("ifs_mp_sessionlist")
ScriptCB_DoFile("ifs_mp_lobby")
ScriptCB_DoFile("ifs_mp_lobbyds")
ScriptCB_DoFile("ifs_mp_joinds")
ScriptCB_DoFile("ifs_mp_gameopts")
ScriptCB_DoFile("ifs_mp_maptype")

if (gPlatformStr == "PS2" ) then 
	ScriptCB_DoFile("ifs_mpps2_netconfig")
	ScriptCB_DoFile("ifs_mpps2_dnas")
	ScriptCB_DoFile("ifs_mpps2_eula")
	ScriptCB_DoFile("ifs_mpps2_patch")
end

ScriptCB_DoFile("ifs_mp_autonet")
ScriptCB_DoFile("popups_lobby")
ScriptCB_DoFile("popup_busy")
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
ScriptCB_DoFile("ifs_opt_top")
ScriptCB_DoFile("ifs_opt_general")
ScriptCB_DoFile("ifs_opt_sound")
ScriptCB_DoFile("ifs_opt_mp")
ScriptCB_DoFile("ifs_opt_controller_mode")
ScriptCB_DoFile("ifs_opt_controller_common")
ScriptCB_DoFile("ifs_opt_controller_vehunit")

if(gPlatformStr == "PC") then 
	--ScriptCB_DoFile("ifs_opt_pckeyboard")
	ScriptCB_DoFile("ifs_opt_pccontrols")
	ScriptCB_DoFile("ifs_opt_pcvideo")
end

ScriptCB_DoFile("ifs_unlockables")
ScriptCB_DoFile("ifs_tutorials")
ScriptCB_DoFile("ifs_credits")

if( gOnlineServiceStr ==  "XLive") then 
	ScriptCB_DoFile("ifs_mpxl_login")
	ScriptCB_DoFile("ifs_mpxl_silentlogin")
	ScriptCB_DoFile("ifs_mpxl_optimatch")
	ScriptCB_DoFile("ifs_mpxl_friends")
	ScriptCB_DoFile("ifs_mpxl_feedback")
	--ScriptCB_DoFile("ifs_mp_leaderboarddetails")
	ScriptCB_DoFile("ifs_mpxl_voicemail")
end

if (gDemoBuild) then
	ScriptCB_DoFile("ifs_legal_demo")
	ScriptCB_DoFile("ifs_start_demo")
	ScriptCB_DoFile("ifs_main_demo")
	ScriptCB_DoFile("ifs_difficulty_demo")
	ScriptCB_DoFile("ifs_mp_main_demo")
	ScriptCB_DoFile("ifs_postdemo")
	ScriptCB_DoFile("ifs_rules")
	ifs_movietrans_PushScreen(ifs_legal_demo)
else 
	ifs_movietrans_PushScreen(ifs_boot)
end 

ReadDataFile("sound\\shell.lvl")
gVoiceOverStream = OpenAudioStream("sound\\shell.lvl","shell_vo")
gMusicStream = OpenAudioStream("sound\\shell.lvl","shell_music")

--if( ScriptCB_IsPAL() == 1 ) then 
--	gMovieStream = "movies\\shellpal.mvs"
--else 
--	gMovieStream = "movies\\shell.mvs"
--end
gMovieStream = "movies\\shell.mvs"

gMovieTutorialPostFix = ""

ScriptCB_OpenMovie(gMovieStream,"")
ScriptCB_SetMovieAudioBus("shellmovies")

