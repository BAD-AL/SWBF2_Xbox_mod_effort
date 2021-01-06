--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- General tab managing code for PC options interface screens.
-- Provides support code for all of the screens, and handles switching
-- between tabs (screens).

-- Tabs are implemented as a lightweight layer added to screens, with
-- elements added to all of them. Events in the tabs are handled by
-- this file, and when another tab is selected, it swaps screens in
-- the background.

local opt_tab_ypos = 45
local opt_tab_width = 158.5

gPCOptionsTabsLayout = {
	{ tag = "_tab_general", string = "ifs.options.tabs.game", screen = "ifs_opt_general", yPos = opt_tab_ypos, xPos = 87, width = opt_tab_width},
	{ tag = "_tab_video", string = "ifs.options.tabs.video", screen = "ifs_opt_pcvideo", yPos = opt_tab_ypos, width = opt_tab_width},
	{ tag = "_tab_sound", string = "ifs.options.tabs.audio", screen = "ifs_opt_sound", yPos = opt_tab_ypos, width = opt_tab_width},
	{ tag = "_tab_controls", string = "ifs.options.tabs.controls", screen = "ifs_opt_pccontrols", yPos = opt_tab_ypos, width = opt_tab_width},
	{ tag = "_tab_mp", string = "ifs.options.tabs.online", screen = "ifs_opt_mp", yPos = opt_tab_ypos, width = opt_tab_width},
}

function fnPCMainTabs_Single( this )
	gPickedMapList = {}				-- clear map lists	
	ScriptCB_SetIFScreen("ifs_sp_campaign")
end

function fnPCMainTabs_Multi( this )
	gPickedMapList = {}				-- clear map lists
	if( ifs_main ) then
		ifs_main.option_mp = 1		-- set to multiplayer 
	end
	ScriptCB_SetGameRules("mp")
	if( ScriptCB_IsLoggedIn() ) then
		if(ScriptCB_GetAmHost()) then
			ScriptCB_SetIFScreen("ifs_missionselect_pcMulti")
		else
			ScriptCB_SetIFScreen("ifs_mp_sessionlist")
		end
	else
		ifs_mpgs_login.enable_autologin = 1
		ScriptCB_SetIFScreen("ifs_mpgs_login")
	end
end

function fnPCMainTabs_Profile( this)
	
	-- not dirty, backup
	print("profile not dirty, backing up")
--	ScriptCB_Logout()
	ifs_login.TabsEnter = nil
	
	ifs_login.EnterDoNothing = 1
	ifs_login.EnterThenExit = nil
	ifs_login.SaveAndExit = nil
end

function fnPCMainTabs_Minimize( this )
	print("call minimize window")
	ScriptCB_MinimizeWindow()
end

function ifs_PCTabfnQuitPopupDone(bResult)
	if(bResult) then
		ScriptCB_QuitToWindows()
	else
	
	end
end

function fnPCMainTabs_PopUpQuit( )
	-- popup quit
	Popup_YesNo.CurButton = "no" -- default
	Popup_YesNo.fnDone = ifs_PCTabfnQuitPopupDone
	Popup_YesNo:fnActivate(1)
	gPopup_fnSetTitleStr(Popup_YesNo, "ifs.main.askquit")
end

function ifs_PCMainTabsSaveDirtyAcceptQuit(fRet)
	Popup_LoadSave2.fnAccept = nil
	Popup_LoadSave2:fnActivate(nil)

	ifs_main.do_save = nil
	if(fRet < 1.5) then
--		print("ifs_main_SaveDirtyAccept(A - Save)")
		ifs_saveop.doOp = "SaveProfile"
		ifs_saveop.OnSuccess = ScriptCB_QuitToWindows
		--ifs_saveop.OnCancel = ifs_main_SaveProfileCancel
		local iProfileIdx = 1 + ScriptCB_GetPrimaryController()
		ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
		ifs_saveop.saveProfileNum = iProfileIdx
		ifs_saveop.NoPromptSave = 1
		ifs_movietrans_PushScreen(ifs_saveop)
	elseif(fRet < 2.5) then
--		print("ifs_main_SaveDirtyAccept(B - Exit without saving)")
		ScriptCB_QuitToWindows()
	else
	
	end	
end

function fnPCMainTabs_Quit( this )
	if(ScriptCB_IsCurProfileDirty(1)) then
		-- save profile?
		-- set the button text
		IFText_fnSetString(Popup_LoadSave2.buttons.A.label,ifs_saveop.PlatformBaseStr .. ".saveandexit")
		IFText_fnSetString(Popup_LoadSave2.buttons.B.label,ifs_saveop.PlatformBaseStr .. ".exitnosave")
		IFText_fnSetString(Popup_LoadSave2.buttons.C.label,ifs_saveop.PlatformBaseStr .. ".cancel")
		-- set the button visiblity
		Popup_LoadSave2:fnActivate(1)
		-- set the load/save title text
		gPopup_fnSetTitleStr(Popup_LoadSave2, ifs_saveop.PlatformBaseStr .. ".save24")
		IFObj_fnSetVis(Popup_LoadSave2.buttons.A.label,1)
		IFObj_fnSetVis(Popup_LoadSave2.buttons.B.label,1)
		IFObj_fnSetVis(Popup_LoadSave2.buttons.C.label,1)
		Popup_LoadSave2_SelectButton(1)
		IFObj_fnSetVis(Popup_LoadSave2,1)
		Popup_LoadSave2_ResizeButtons()
		Popup_LoadSave2.fnAccept = ifs_PCMainTabsSaveDirtyAcceptQuit
		return
	else
		fnPCMainTabs_PopUpQuit()
	end
end

local main_tab_width = 165
local main_tab_width_half = main_tab_width / 2
local main_tab_ypos = 23

-- Hotspots work, yay - Mike Z

gPCMainTabsLayout = {
	{ tag = "_tab_single",	string = "ifs.main.sp",			screen = "ifs_sp_campaign",		
	  xPos = 90,
	  width = main_tab_width,	yPos = main_tab_ypos, callback = fnPCMainTabs_Single,
	--hotspot_x = 62, hotspot_width = main_tab_width - 22,
	},
	{ tag = "_tab_multi",	string = "ifs.main.mp",			screen = "ifs_mpgs_login",		
	--xPos = 313,		
	  width = main_tab_width,	yPos = main_tab_ypos, callback = fnPCMainTabs_Multi, 
	--hotspot_x = 51, hotspot_width = main_tab_width - 16,
	},
	{ tag = "_tab_options", string = "ifs.mp.tabs.options",	screen = "ifs_opt_general",		
	--xPos = 510,
	  width = main_tab_width,	yPos = main_tab_ypos, 
	--hotspot_x = 33, hotspot_width = main_tab_width - 14,
	},
	{ tag = "_tab_profile", string = "ifs.main.profile",			screen = "ifs_login",			
	--xPos = 684,

		-- callback2 is used when you just need to do something before going
		-- to that screen - NM 9/13/05
	  width = main_tab_width,	yPos = main_tab_ypos, callback2 = fnPCMainTabs_Profile, 
	  --hotspot_x = 35, hotspot_width = main_tab_width - 16,
	},
	{ tag = "_tab_mini",	string = "-",					screen = "ifs_login",			
	xPos = 710,
		-- callback is used when you just need to do something, without going to
		-- another screen at the end
	  width = 60,	yPos = main_tab_ypos, callback = fnPCMainTabs_Minimize, 
	--hotspot_x = 40, hotspot_width = 40,
	},
	{ tag = "_tab_quit",	string = "X",					screen = "ifs_login",			
	xPos = 770,
		-- callback is used when you just need to do something, without going to
		-- another screen at the end
	  width = 60,	yPos = main_tab_ypos, callback = fnPCMainTabs_Quit, 
	  --hotspot_x = 40, hotspot_width = 40,
	},
}

-- same as above, but only has minimize/quit buttons - for Profile screen before you are logged in.
gPCMinimizeQuitTabsLayout = {
	{ tag = "_tab_mini",	string = "-",					screen = "ifs_login",			
	xPos = 710,
		-- callback is used when you just need to do something, without going to
		-- another screen at the end
	  width = 60,	yPos = main_tab_ypos, callback = fnPCMainTabs_Minimize, 
	--hotspot_x = 40, hotspot_width = 40,
	},
	{ tag = "_tab_quit",	string = "X",					screen = "ifs_login",			
	xPos = 770,
		-- callback is used when you just need to do something, without going to
		-- another screen at the end
	  width = 60,	yPos = main_tab_ypos, callback = fnPCMainTabs_Quit, 
	  --hotspot_x = 40, hotspot_width = 40,
	},
}

-- PC title: profile:blackfox		star wars battlefrontII V.1.5
function AddPCTitleText(this)
	local pos_y = -32
	local text_width = 600
	
	if(gPlatformStr == "PC") then
		this.PCTitleText_Profile = NewIFText {
			ScreenRelativeX = 0,
			ScreenRelativeY = 0,
			y = pos_y,
			x = -30,
			string = "ifs.mp.join.profile_name",
			halign = "left",
			nocreatebackground = 1,
			textw = text_width,
			font = "gamefont_tiny",
		}

		this.PCTitleText_Title = NewIFText {
			ScreenRelativeX = 1,
			ScreenRelativeY = 0,
			y = pos_y,
			x = -text_width + 30,
			string = "Star Wars Battlefront II V.1.0",
			halign = "right",
			nocreatebackground = 1,
			textw = text_width,
			font = "gamefont_tiny",
		}	
	end
end

function UpdatePCTitleText(this)
	if(gPlatformStr == "PC") then
		local ShowUStr
		if( ScriptCB_IsPlayerLoggedIn() ) then
			ShowUStr = ScriptCB_usprintf( "ifs.mp.join.profile_name", ScriptCB_GetCurrentProfileName() )
		else			
			ShowUStr = ScriptCB_usprintf( "ifs.mp.join.profile_name", ScriptCB_getlocalizestr("common.none") )
		end
		IFText_fnSetUString( this.PCTitleText_Profile, ShowUStr )
		
		ShowUStr = ScriptCB_GetCurrentPCTitleVersion()
		IFText_fnSetString( this.PCTitleText_Title, ShowUStr )	
	end
end

function HidePCTitleText(this)
	if(gPlatformStr == "PC") then
		IFObj_fnSetVis(this.PCTitleText_Profile,nil)

		IFObj_fnSetVis(this.PCTitleText_Title,nil)
	end
end


-- dimm tabs for PC Demo
function ifs_DimTabsPCDemo(this)
	if( gPCBetaBuild and gPlatformStr == "PC" ) then
		--print( "this._Tabs = ", this._Tabs )
		-- dimm main tab
		if( this._Tabs ) then
			ifelem_tabmanager_SetDimmed( this, gPCMainTabsLayout, "_tab_single", 1 )
		end
		
		--print( "this._Tabs1 = ", this._Tabs1 )
		--print( "this._Tabs1[_tab_join]= ", this._Tabs1["_tab_join"] )
		-- dimm main tab
		if( this._Tabs1 ) then
			if( this._Tabs1["_tab_join"] ) then
				-- multiplayer
				ifelem_tabmanager_SetDimmed( this, gPCMultiPlayerTabsLayout, "_tab_create", 1, 1 )
				ifelem_tabmanager_SetDimmed( this, gPCMultiPlayerTabsLayout, "_tab_friends", 1, 1 )
				ifelem_tabmanager_SetDimmed( this, gPCMultiPlayerTabsLayout, "_tab_leaderboard", 1, 1 )
			elseif( this._Tabs1["_tab_video"] ) then
				-- options
			end
		end
		
	end
end