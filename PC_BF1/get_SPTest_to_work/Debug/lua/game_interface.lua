-- Master include for StarWars: Frontline ingame interface, lua
-- component. The game should be able to include this file and nothing
-- else.


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



gPlatformStr = ScriptCB_GetPlatform()

-- Note: we don't call ScriptCB_GetOnlineService(), which returns what
-- the binary was compiled for (XLive vs GameSpy). We want the current
-- connection type, which is "LAN", "XLive" or "GameSpy"
gOnlineServiceStr = ScriptCB_GetConnectType()
--	gOnlineServiceStr = ScriptCB_GetOnlineService()


-- Load designer-specified globals
ScriptCB_DoFile("globals")

--
--
-- Load utility functions
ScriptCB_DoFile("interface_util")
ScriptCB_DoFile("ifelem_button")
ScriptCB_DoFile("ifelem_roundbutton")
ScriptCB_DoFile("ifelem_flatbutton")
ScriptCB_DoFile("ifelem_buttonwindow")
ScriptCB_DoFile("ifelem_segline")
ScriptCB_DoFile("ifelem_popup")
ScriptCB_DoFile("ifelem_listmanager")
ScriptCB_DoFile("ifelem_shellscreen")
ScriptCB_DoFile("ifelem_titlebar")
ScriptCB_DoFile("ifelem_borderrect")
ScriptCB_DoFile("ifelem_hslider")
ScriptCB_DoFile("ifelem_AnimationMgr")
ScriptCB_DoFile("ifs_movietrans_game")

--
--
-- Load screens. Will be activated by gamecode, not us.

ScriptCB_DoFile("ifs_opt_top")
ifs_opt_contmain = DoPostDelete(ifs_opt_contmain)

--ScriptCB_DoFile("ifs_opt_controller_mode")
--ifs_opt_contmode = DoPostDelete(ifs_opt_contmode)

ScriptCB_DoFile("ifs_opt_controller_common")
ScriptCB_DoFile("ifs_opt_controller_vehunit")

--ifs_opt_controller = DoPostDelete(ifs_opt_controller)

ScriptCB_DoFile("ifs_opt_general")
ifs_opt_general = DoPostDelete(ifs_opt_general)

ScriptCB_DoFile("ifs_opt_sound")
ifs_opt_sound = DoPostDelete(ifs_opt_sound)

ScriptCB_DoFile("ifs_opt_mp")
ifs_opt_mp = DoPostDelete(ifs_opt_mp)

ScriptCB_DoFile("ifs_saveop")
ifs_saveop = DoPostDelete(ifs_saveop)


if(gPlatformStr == "PC") then
	--ScriptCB_DoFile("ifs_opt_pckeyboard")
	ScriptCB_DoFile("ifs_opt_pccontrols")
	ScriptCB_DoFile("ifs_opt_pcvideo")
	ScriptCB_DoFile("ifutil_mouse")
	ScriptCB_DoFile("ifelem_editbox")
	ScriptCB_DoFile("ifs_pc_SpawnSelect")
end

ScriptCB_DoFile("ifs_charselect")
ScriptCB_DoFile("ifs_mapselect")
ScriptCB_DoFile("ifs_readyselect")


ScriptCB_DoFile("popups_common")
ScriptCB_DoFile("popup_ab")
ScriptCB_DoFile("popup_ok")
ScriptCB_DoFile("popup_busy")
ScriptCB_DoFile("popup_yesno")
ScriptCB_DoFile("error_popup")
ScriptCB_DoFile("popup_loadsave2")

ScriptCB_DoFile("ifs_pausemenu")
ifs_pausemenu = DoPostDelete(ifs_pausemenu)

ScriptCB_DoFile("ifs_teamstats")
ifs_teamstats = DoPostDelete(ifs_teamstats)


ScriptCB_DoFile("ifs_personalstats")
ifs_personalstats = DoPostDelete(ifs_personalstats)

ScriptCB_DoFile("ifs_awardstats")
ifs_awardstats = DoPostDelete(ifs_awardstats)

ScriptCB_DoFile("ifs_fakeconsole")
ifs_fakeconsole = DoPostDelete(ifs_fakeconsole)


ScriptCB_DoFile("ifs_mp_lobby")
ifs_mp_lobby = DoPostDelete(ifs_mp_lobby)

ScriptCB_DoFile("popups_lobby")

-- Pull in XBox-only pages (with mpxl in the name)
if(gPlatformStr == "XBox") then
	ScriptCB_DoFile("ifs_mpxl_friends")
	ifs_mpxl_friends = DoPostDelete(ifs_mpxl_friends)

	ScriptCB_DoFile("ifs_mpxl_feedback")
	ifs_mpxl_feedback = DoPostDelete(ifs_mpxl_feedback)

	ScriptCB_DoFile("ifs_mpxl_voicemail")
	ifs_mpxl_voicemail = DoPostDelete(ifs_mpxl_voicemail)
end

if(gPlatformStr ~= "PS2") then
	ScriptCB_DoFile("popup_yesno_large")
end