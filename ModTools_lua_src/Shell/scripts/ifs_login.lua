--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_login_listbox_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { 
		x = layout.x - 0.5 * layout.width, y=layout.y - 10
	}

	if(gPlatformStr == "XBox") then
		Temp.NumberStr = NewIFText{ 
			x = 10, y = 2, halign = "left", font = "gamefont_tiny",
			textw = ifs_login_listbox_layout.fNumberWidth, 
			nocreatebackground = 1, startdelay=math.random()*0.5, 
		}

		Temp.NameStr = NewIFText{ 
			x = 20 + ifs_login_listbox_layout.fNumberWidth, y = 0,
			halign = "left", font = ifs_login_listbox_layout.Font, textw = 220, 
			nocreatebackground = 1, startdelay=math.random()*0.5, 
		}
	else
		Temp.NameStr = NewIFText{ 
			x = 10, y = 0, halign = "left", font = ifs_login_listbox_layout.Font, textw = 220, 
			nocreatebackground = 1, startdelay=math.random()*0.5, 
		}
	end
	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ifs_login_listbox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
	if(Data) then
		-- Show this entry
		IFText_fnSetUString(Dest.NameStr,Data.showstr)

		if(gPlatformStr == "XBox") then
			IFText_fnSetString(Dest.NumberStr, string.format("%d", Data.iFileNum))
			IFObj_fnSetColor(Dest.NumberStr, iColorR, iColorG, iColorB)
			IFObj_fnSetAlpha(Dest.NumberStr, fAlpha)
		end

		IFObj_fnSetColor(Dest.NameStr, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.NameStr, fAlpha)
	else
		-- Blank this entry
		IFText_fnSetString(Dest.NameStr,"")
		if(gPlatformStr == "XBox") then
			IFText_fnSetString(Dest.NumberStr,"")
		end
	end

	IFObj_fnSetVis(Dest.NameStr, Data)
end


ifs_login_listbox_contents = {
}

ifs_login_listbox_layout = {
	showcount = 5,
	yHeight = 34,
	ySpacing  = 0,
	width = 260,
--	x = 0,
	slider = 1,
	CreateFn = ifs_login_listbox_CreateItem,
	PopulateFn = ifs_login_listbox_PopulateItem,
	Font = gListboxItemFont,
	fNumberWidth = 40, -- width, in pixels, for the XBox's file #
}


-- Sets the hilight on the listbox, create button given a hilight
function ifs_login_SetHilight(this,aListIndex)
	if(gNoNewProfiles or aListIndex) then
		-- Deactivate 'create' button, if applicable.
		if(gCurHiliteButton) then
			IFButton_fnSelect(gCurHiliteButton,nil) -- Deactivate old button
			gCurHiliteButton = nil
			this.CurButton = nil
		end
	else
		-- Not in listindex. Focus is on the create buttons
		this.CurButton = "new"
		gCurHiliteButton = this.buttons[this.CurButton]
		IFButton_fnSelect(gCurHiliteButton,1) -- Activate button
	end

	IFObj_fnSetVis(this.Helptext_Delete,aListIndex and (not gNoNewProfiles))
	IFObj_fnSetVis(this.Helptext_Accept,1)

	ifs_login_listbox_layout.SelectedIdx = aListIndex
	ifs_login_listbox_layout.CursorIdx = aListIndex
	ListManager_fnFillContents(this.listbox,ifs_login_listbox_contents,ifs_login_listbox_layout)

end

function ifs_login_fnNotUniqueOk()
	-- Re-enable parts of vkeyboard we disabled
--	IFObj_fnSetVis(ifs_vkeyboard.title,1)
	IFObj_fnSetVis(ifs_vkeyboard.deletegroup,1)
	IFObj_fnSetVis(ifs_vkeyboard.modegroup,1)
--	IFObj_fnSetVis(ifs_vkeyboard.Helptext_Accept,1)
--	IFObj_fnSetVis(ifs_vkeyboard.startgroup,1)
	IFObj_fnSetVis(ifs_vkeyboard.buttons,1)
end

function ifs_login_fnListFullOk()
	local this = ifs_login
	ifs_login_fnSetPieceVis(this, 1)
end

-- Callback function from VK - returns 2 values, whether the current
-- string is allowed to be entered, and a localize database key string
-- as to why it's not acceptable.
function ifs_login_fnIsAcceptable()
	return (string.len(ifs_vkeyboard.CurString) > 2),"ifs.vkeyboard.tooshort"
end

function ifs_login_fnDifficultyDone()
	-- we finished good, so don't logout
	ifs_difficulty.LogoutOnCancel = nil
	-- reenter ifs_login, but go right to SaveAndExit
	ifs_login.SaveAndExit = 1
	ScriptCB_PopScreen() -- back to ifs_vkeyboard.lua
	ScriptCB_PopScreen() -- back to this screen, ifs_login
end

-- Callback function when the virtual keyboard is done
function ifs_login_fnKeyboardDone()
	if(string.len(ifs_vkeyboard.CurString) > 2) then
		-- We need to remove any trailing spaces from the profile name
		-- as that makes the name virtually indistinguishable in the
		-- browser. NM 4/6/05
		local CurString = ifs_vkeyboard.WorkString
		local LastByte
		repeat
			local l = string.len(CurString)
			LastByte = string.byte(string.sub(CurString,-1))
			if(LastByte == 32) then
				CurString = string.sub(CurString, 1, l - 1)
--				print("Truncating last char...")
			end
		until (LastByte ~= 32)

		local UCurString = ScriptCB_tounicode(CurString)

		if(ScriptCB_IsUniqueLoginName(UCurString)) then
			ScriptCB_AddProfile(UCurString)
			ifs_difficulty.fnDone = ifs_login_fnDifficultyDone
			ifs_difficulty.LogoutOnCancel = 1
			ifs_movietrans_PushScreen(ifs_difficulty)
		else
			-- Hide chunks of vkeyboard
			--				IFObj_fnSetVis(ifs_vkeyboard.title,nil)
			IFObj_fnSetVis(ifs_vkeyboard.deletegroup,nil)
			IFObj_fnSetVis(ifs_vkeyboard.modegroup,nil)
			--				IFObj_fnSetVis(ifs_vkeyboard.Helptext_Accept,nil)
			--				IFObj_fnSetVis(ifs_vkeyboard.startgroup,nil)
			IFObj_fnSetVis(ifs_vkeyboard.buttons,nil)

			Popup_Ok.fnDone = ifs_login_fnNotUniqueOk
			Popup_Ok:fnActivate(1)
			gPopup_fnSetTitleStr(Popup_Ok, "ifs.Profile.dupname")
		end
	end
end

-- Helper function: turns pieces on/off as requested
function ifs_login_fnSetPieceVis(this,bNormalVis)
	IFObj_fnSetVis(this.listbox,bNormalVis)
--	print("Buttons on = ",bNormalVis , (not gNoNewProfiles), bNormalVis and (not gNoNewProfiles))
	IFObj_fnSetVis(this.buttons,bNormalVis and (not gNoNewProfiles))

	IFObj_fnSetVis(this.Helptext_Delete,bNormalVis and (not gNoNewProfiles))
	IFObj_fnSetVis(this.Helptext_Accept,bNormalVis)
	IFObj_fnSetVis(this.Helptext_Back,bNormalVis and (gPlatformStr ~= "XBox"))

	if(bNormalVis) then
		ifs_login_fnRegetListbox(this)
-- 		if(this.ListFull) then
-- --			print("Hiding buttons as listbox is full")
-- 			IFObj_fnSetVis(this.buttons,nil)
--		end
	end

end

function ifs_login_fnRegetListbox(this)
	-- Reset listbox, show it. [Remember, Lua starts at 1!]
	local MaxCount = ScriptCB_GetLoginList("ifs_login_listbox_contents")
	local ListCount = table.getn(ifs_login_listbox_contents)

	this.ListFull = (ListCount >= MaxCount)

	ifs_login_listbox_layout.FirstShownIdx = 1 -- top
	if(ListCount > 0) then
		-- Auto-select first item
		ifs_login_SetHilight(this,1)
	else
		-- Auto-select 'create' button
		ifs_login_SetHilight(this,nil)
	end
	ListManager_fnFillContents(this.listbox,ifs_login_listbox_contents,ifs_login_listbox_layout)
end

----------------------------------------------------------------------------------------
-- load the profile list.  this is just the preop, since that refreshes the file list.
----------------------------------------------------------------------------------------

function ifs_login_StartLoadFileList()
--	print("ifs_login_StartLoadFileList")
	
	-- don't complain about no controller during this time
--	ScriptCB_SetIgnoreControllerRemoval(1)
	
	ifs_saveop.doOp = "LoadFileList"
	ifs_saveop.OnSuccess = ifs_login_LoadFileListSuccess
	ifs_saveop.OnCancel = ifs_login_LoadFileListCancel
	ifs_login.bNoInputs = 1
	ifs_movietrans_PushScreen(ifs_saveop);
	
end

function ifs_login_LoadFileListSuccess()
	-- good, continue
--	print("ifs_login_LoadFileListSuccess")

	-- reset complaining
--	ScriptCB_SetIgnoreControllerRemoval(nil)

	-- when we pop ifs_saveop and return to ifs_login, we'll either want to do nothing (don't load
	-- this list again), or if we're coming from NTGUI we want to skip forward.
	if(ScriptCB_SkipToNTGUI()) then
		ifs_login.SkipToNTGUI = 1
	else
		ifs_login.EnterDoNothing = 1
	end
	
	-- pop ifs_saveop, reenter ifs_login
	ScriptCB_PopScreen()
	
end

function ifs_login_LoadFileListCancel()
	-- ok, continue
--	print("ifs_login_LoadFileListCancel")

	-- reset complaining
--	ScriptCB_SetIgnoreControllerRemoval(nil)
	
	-- pop ifs_saveop, reenter ifs_login
	ifs_login.EnterDoNothing = 1
	ScriptCB_PopScreen()

end

----------------------------------------------------------------------------------------
-- load two profiles
----------------------------------------------------------------------------------------

function ifs_login_StartLoadProfile(profile1,profile2)
--	print("ifs_login_StartLoadProfile")

	ifs_saveop.doOp = "LoadProfile"
	ifs_saveop.OnSuccess = ifs_login_LoadProfileSuccess
	ifs_saveop.OnCancel = ifs_login_LoadProfileCancel
	ifs_saveop.profile1 = nil
	ifs_saveop.profile2 = nil
	ifs_saveop.profile3 = nil
	ifs_saveop.profile4 = nil
	local iPrimaryController = ScriptCB_GetPrimaryController()
	if (iPrimaryController == 0) then
		ifs_saveop.profile1 = profile1
	elseif (iPrimaryController == 1) then
		ifs_saveop.profile2 = profile1
	elseif (iPrimaryController == 2) then
		ifs_saveop.profile3 = profile1
	elseif (iPrimaryController == 3) then
		ifs_saveop.profile4 = profile1
	end
	ifs_login.bNoInputs = 1
	ifs_movietrans_PushScreen(ifs_saveop)
end

function ifs_login_LoadProfileSuccess()
--	print("ifs_login_LoadProfileSuccess")	
	-- pop ifs_saveop, reenter ifs_login but then save and exit
	ifs_login.SaveAndExit = 1
	ScriptCB_PopScreen()
end

function ifs_login_LoadProfileCancel()
--	print("ifs_login_LoadProfileCancel")	
	-- pop ifs_saveop, reenter ifs_login and idle
	ifs_login.EnterDoNothing = 1
	ScriptCB_PopScreen()
end

----------------------------------------------------------------------------------------
-- delete a profile
----------------------------------------------------------------------------------------

function ifs_login_fnDeletePopupDone(bResult)
	local this = ifs_login
	if(bResult) then
--		print("ifs_login_fnDeletePopupDone(true)")
		-- User does want to delete
		local Selection = ifs_login_listbox_contents[ifs_login_listbox_layout.SelectedIdx]
		
		ifs_saveop.doOp = "DeleteProfile"
		ifs_saveop.OnSuccess = ifs_login_DeleteProfileSuccess
		ifs_saveop.OnCancel = ifs_login_DeleteProfileCancel
		ifs_saveop.profile1 = Selection.showstr
		ifs_saveop.saveName = Selection.showstr
		ifs_login.bNoInputs = 1
		ifs_movietrans_PushScreen(ifs_saveop)
		
	else
--		print("ifs_login_fnDeletePopupDone(false)")
		-- User hit no. Back to normal screen
		ifs_login_fnSetPieceVis(this, 1)
	end
end

function ifs_login_DeleteProfileSuccess()
--	print("ifs_login_DeleteProfileSuccess")
	Popup_LoadSave2:fnActivate(nil)	
	-- pop ifs_saveop, reenter ifs_login
	ScriptCB_PopScreen()
end

function ifs_login_DeleteProfileCancel()
--	print("ifs_login_DeleteProfileCancel")
	Popup_LoadSave2:fnActivate(nil)	
	-- pop ifs_saveop, reenter ifs_login
	ScriptCB_PopScreen()
end


----------------------------------------------------------------------------------------
-- when we're done with this screen, save any dirty profiles and push to ifs_main.
-- save profile 1
----------------------------------------------------------------------------------------

function ifs_login_SaveAndExit()
--	print("ifs_login_SaveAndExit")
	local this = ifs_login
	
	ifs_saveop.doOp = "SaveProfile"
	ifs_saveop.OnSuccess = ifs_login_SaveProfile1Success
	ifs_saveop.OnCancel = ifs_login_SaveProfile1Cancel
	ifs_saveop.saveName = ScriptCB_GetProfileName(1)
	ifs_saveop.saveProfileNum = 1
	ifs_login.bNoInputs = 1
	ifs_movietrans_PushScreen(ifs_saveop)	

	-- we need this, otherwise we call ifs_login.Enter(nil) twice.  why?  i dunno.  because lua is ghetto.
	this.EnterDoNothing = 1
end

function ifs_login_SaveProfile1Success()
--	print("ifs_login_SaveProfile1Success")
	-- exit once we reenter
	ifs_login.GotoSaveProfile2 = 1	
	ScriptCB_PopScreen()
end

function ifs_login_SaveProfile1Cancel()
--	print("ifs_login_SaveProfile1Cancel")
	-- exit once we reenter
	ifs_login.GotoSaveProfile2 = 1	
	ScriptCB_PopScreen()
end

----------------------------------------------------------------------------------------
-- save profile 2
----------------------------------------------------------------------------------------

function ifs_login_SaveAndExit2()
--	print("ifs_login_SaveAndExit2")
	local this = ifs_login
	
	ifs_saveop.doOp = "SaveProfile"
	ifs_saveop.OnSuccess = ifs_login_SaveProfile2Success
	ifs_saveop.OnCancel = ifs_login_SaveProfile2Cancel
	ifs_saveop.saveName = ScriptCB_GetProfileName(2)
	ifs_saveop.saveProfileNum = 2
	ifs_login.bNoInputs = 1
	ifs_movietrans_PushScreen(ifs_saveop)

	-- we need this, otherwise we call ifs_login.Enter(nil) twice.  why?  i dunno.  because lua is ghetto.
	this.EnterDoNothing = 1
end

function ifs_login_SaveProfile2Success()
--	print("ifs_login_SaveProfile2Success")
	-- exit once we reenter
	ifs_login.GotoSaveProfile3 = 1
	ScriptCB_PopScreen()
end

function ifs_login_SaveProfile2Cancel()
--	print("ifs_login_SaveProfile2Cancel")
	-- exit once we reenter
	ifs_login.GotoSaveProfile3 = 1
	ScriptCB_PopScreen()
end

function ifs_login_SaveAndExit3()
--	print("ifs_login_SaveAndExit3")
	local this = ifs_login
	
	ifs_saveop.doOp = "SaveProfile"
	ifs_saveop.OnSuccess = ifs_login_SaveProfile3Success
	ifs_saveop.OnCancel = ifs_login_SaveProfile3Cancel
	ifs_saveop.saveName = ScriptCB_GetProfileName(3)
	ifs_saveop.saveProfileNum = 3
	ifs_login.bNoInputs = 1
	ifs_movietrans_PushScreen(ifs_saveop)

	-- we need this, otherwise we call ifs_login.Enter(nil) twice.  why?  i dunno.  because lua is ghetto.
	this.EnterDoNothing = 1
end

function ifs_login_SaveProfile3Success()
--	print("ifs_login_SaveProfile2Success")
	-- exit once we reenter
	ifs_login.GotoSaveProfile4 = 1
	ScriptCB_PopScreen()
end

function ifs_login_SaveProfile3Cancel()
--	print("ifs_login_SaveProfile2Cancel")
	-- exit once we reenter
	ifs_login.GotoSaveProfile4 = 1
	ScriptCB_PopScreen()
end

function ifs_login_SaveAndExit4()
--	print("ifs_login_SaveAndExit3")
	local this = ifs_login
	
	ifs_saveop.doOp = "SaveProfile"
	ifs_saveop.OnSuccess = ifs_login_SaveProfile4Success
	ifs_saveop.OnCancel = ifs_login_SaveProfile4Cancel
	ifs_saveop.saveName = ScriptCB_GetProfileName(4)
	ifs_saveop.saveProfileNum = 4
	ifs_login.bNoInputs = 1
	ifs_movietrans_PushScreen(ifs_saveop)

	-- we need this, otherwise we call ifs_login.Enter(nil) twice.  why?  i dunno.  because lua is ghetto.
	this.EnterDoNothing = 1
end

function ifs_login_SaveProfile4Success()
--	print("ifs_login_SaveProfile2Success")
	-- exit once we reenter
	ifs_login.EnterThenExit = 1	
	ScriptCB_PopScreen()
end

function ifs_login_SaveProfile4Cancel()
--	print("ifs_login_SaveProfile2Cancel")
	-- exit once we reenter
	ifs_login.EnterThenExit = 1	
	ScriptCB_PopScreen()
end



----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

-- this is called when the login process is done
-- takes the place of what used to be _PushScreen("ifs_main")
function ifs_login_Done()
--	print("ifs_login_Done")

	-- Added NM 1/24/05 - archive current profile. Delete the function
	-- test after about a week.
	if(ScriptCB_SetProfileAsDefault) then
		ScriptCB_SetProfileAsDefault()
	end
	-- we should have an exit callback set
	if(ifs_login.fnDone) then
		ifs_login.fnDone()
	else
		-- error
		print("ERROR login exit function (ifs_login.fnDone) not set")
	end
end

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

ifs_login = NewIFShellScreen {
	bAcceptIsSelect = 1,

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
		y = 80,
	},

	movieIntro      = nil,
    movieBackground = "shell_main", -- WAS "ifs_start",
    enterSound      = "",
    exitSound       = "",

	Helptext_Delete = NewHelptext {
		ScreenRelativeX = 1.0, -- right side of screen
		ScreenRelativeY = 1.0, -- bot
		y = -40,
		buttonicon = "btnmisc",
		string = "ifs.profile.delete",
		bRightJustify = 1,
	},

	Enter = function(this, bFwd)
--		print("ifs_login.Enter(",bFwd,")")

		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function

		gHelptext_fnMoveIcon(this.Helptext_Delete)

		-- Fix for 11032 - clear input lockout on [re]entry
		ifs_login.bNoInputs = nil

		-- are we in the middle of saving
		if(this.GotoSaveProfile2) then
--			print("ifs_login.GotoSaveProfile2")
			this.GotoSaveProfile2 = nil
			ifs_login_SaveAndExit2()
			return
		end

		if(this.GotoSaveProfile3) then
--			print("ifs_login.GotoSaveProfile3")
			this.GotoSaveProfile3 = nil
			ifs_login_SaveAndExit3()
			return
		end

		if(this.GotoSaveProfile4) then
--			print("ifs_login.GotoSaveProfile4")
			this.GotoSaveProfile4 = nil
			ifs_login_SaveAndExit4()
			return
		end

		------------------------------
		-- handle element visibility
		
		-- Default: hide items on entry
		ifs_login_fnSetPieceVis(this, nil)
		gIFShellScreenTemplate_fnEnter(this, bFwd)

		local ListboxHeight = this.listbox.height * 0.5
		IFObj_fnSetPos(this.buttons,this.listbox.width * -0.5 + 16, -(ListboxHeight + 30))
		AnimationMgr_AddAnimation(this.Helptext_Delete, {fStartAlpha = 0, fEndAlpha = 1,})
		
		-- just to be safe, in case we back out of vkbd without getting there,
		-- don't want to leave this set.
		ifs_difficulty.LogoutOnCancel = nil
		
		-- done vis formatting stuff
		------------------------------
		
		-- should we jump forward (this is the result of SaveAndExit)
		if(this.EnterThenExit) then
--			print("ifs_login.Enter: EnterThenExit")
			this.EnterThenExit = nil
			ifs_login_Done()
			return
		end
		
		-- should we jump right to saveandexit?
		if(this.SaveAndExit) then
--			print("ifs_login.Enter: SaveAndExit")
			this.SaveAndExit = nil
			ifs_login_SaveAndExit()
			return
		end

		-- if we've just loaded the profile list, and we're jumping forward from NTGUI,
		-- try to load the profile that was specified on the return command line.  if this
		-- fails (they switched mem cards) then we'll just stay here anyway.
		if(this.SkipToNTGUI) then
			this.SkipToNTGUI = nil
			-- try to load the specified profile
--			print("NTGUI auto load profile: ",ScriptCB_ununicode(ScriptCB_GetSkipToNTGUIProfileName()))
			ifs_login_StartLoadProfile(ScriptCB_GetSkipToNTGUIProfileName(),nil)
			return
		end	
		
		-- returning from loadfilelist?
		if(this.EnterDoNothing) then
--			print("ifs_login.EnterDoNothing, return")
			this.EnterDoNothing = nil
			-- show this screen
			ifs_login_fnSetPieceVis(this, 1)
			return
		end
		

		-- if we got here its because we've come from another screen, either forwards or
		-- backwards.  all internal looping (load/save/delete) should be handled by now.
		------------------------------
		-- is the player logged in?
		
		local CurPlayerIdx = ScriptCB_IsPlayerLoggedIn()
		if(CurPlayerIdx) then
--			print("ifs_login.Enter already logged in.  go to SaveAndExit.")
			-- make sure that we always log out before coming backwards
			if(not bFwd) then
--				print("ERROR: didn't log out before backing into ifs_login")
				assert(false)
			end
			
			-- if we're in the historical or metagame, we don't want to save here since
			-- we'll save when we get into the main screen.
			-- also don't save for netgame
--			if(ScriptCB_IsMetagameStateSaved() or ScriptCB_IsCampaignStateSaved() or ScriptCB_InNetGame()) then
			-- Note: BF2 bug 8972 says we MUST prompt for save after training. So,
			-- that test was pulled - NM 8/7/05

			if(ScriptCB_GetInTrainingMission()) then
				ScriptCB_SetSPProgress(1,1) -- note this is complete, forcing profile to be dirty
			end

			if(ScriptCB_IsCampaignStateSaved()  or ScriptCB_InNetGame()) then -- or ScriptCB_GetInTrainingMission()
				ifs_login_Done()
				return
			end
			
			-- save it
			ifs_login_SaveAndExit()
			return
		end
		
		
		-------------------------------
		-- load the profile list

		ifs_login_StartLoadFileList()

		if(gPlatformStr == "XBox") then
			ifs_XLive_fnUpdateSilentLoginBox(this)
		end

		IFObj_fnSetVis(this.LoginInfoWindow, (gPlatformStr == "XBox"))
		if((gDemoBuild) and (not gDemoHasMP)) then
			IFObj_fnSetVis(this.LoginInfoWindow, nil)
		end

		-- done enter
		---------------
	end,

 	Exit = function(this, bFwd)
		if(not bFwd) then
			--ScriptCB_Logout()
			--this.Everloaded = nil
			
			-- if we're going backwards from here, and the skiptontgui flag is set,
			-- its possible that while in NTGUI they switched mem cards, so the profile
			-- isn't there anymore, so the autoload failed, and the skip stopped here.  now
			-- they want to back out from here without completing the skip, so we need to
			-- clear the skip flag.
			ScriptCB_ResetSkipToNTGUI()
						
		end
	end,

	-- Override for the general back function, as we want to do nothing
	-- when this happens on this screen.
	Input_Back = function(this)
		-- Fix for 11032 - if we're headed to another screen already,
		-- ignore inputs - NM 8/20/05
		if(ifs_login.bNoInputs) then
			return
		end

		if(gPlatformStr ~= "XBox") then
			ScriptCB_PopScreen()
		end
	end,

	Input_GeneralUp = function(this)
		-- Fix for 11032 - if we're headed to another screen already,
		-- ignore inputs - NM 8/20/05
		if(ifs_login.bNoInputs) then
			return
		end

		if(gCurHiliteButton) then
			-- On button. See if we need to go to the list.
			local ListCount = table.getn(ifs_login_listbox_contents)
			if(ListCount > 0) then
				-- scroll to the bottom
				ifs_login_listbox_layout.FirstShownIdx = math.max(ListCount + 1 - ifs_login_listbox_layout.showcount,1)
				ifs_login_SetHilight(this,ListCount)
                ifelm_shellscreen_fnPlaySound(this.selectSound)
			end
		else
			-- In listbox.
			if((not gNoNewProfiles) and (ifs_login_listbox_layout.SelectedIdx < 2)) then
				-- Move off listbox to button
				ifs_login_SetHilight(this,nil)
                ifelm_shellscreen_fnPlaySound(this.selectSound)
			else
				-- In middle of list. Nav in it
				ListManager_fnNavUp(this.listbox,ifs_login_listbox_contents,ifs_login_listbox_layout)
			end
		end
	end,

	Input_LTrigger = function(this)
		if(not gCurHiliteButton) then
			ListManager_fnPageUp(this.listbox,ifs_login_listbox_contents,ifs_login_listbox_layout)
		end
	end,

	Input_GeneralDown = function(this)
		-- Fix for 11032 - if we're headed to another screen already,
		-- ignore inputs - NM 8/20/05
		if(ifs_login.bNoInputs) then
			return
		end

		local ListCount = table.getn(ifs_login_listbox_contents)
		if(gCurHiliteButton) then
			-- On button. See if we need to go to the list.
			if(ListCount > 0) then
				-- scroll to the bottom
				ifs_login_listbox_layout.FirstShownIdx = 1
				-- Move off button to listbox, first entry
				ifs_login_SetHilight(this,1)
                ifelm_shellscreen_fnPlaySound(this.selectSound)
			end
		else
			-- In listbox.
			if((not gNoNewProfiles) and (ifs_login_listbox_layout.SelectedIdx >= ListCount)) then
				-- Move off bottom of listbox to button
				ifs_login_SetHilight(this,nil)
                ifelm_shellscreen_fnPlaySound(this.selectSound)
			else
				-- In middle of list. Nav.
				ListManager_fnNavDown(this.listbox,ifs_login_listbox_contents,ifs_login_listbox_layout)
			end
		end
	end,

	Input_RTrigger = function(this)
		if(not gCurHiliteButton) then
			ListManager_fnPageDown(this.listbox,ifs_login_listbox_contents,ifs_login_listbox_layout)
		end
	end,

	-- Not possible on this screen
	Input_GeneralLeft = function(this)
  end,
	Input_GeneralRight = function(this)
  end,

	Input_Accept = function(this)

		-- Fix for 11032 - if we're headed to another screen already,
		-- ignore inputs - NM 8/20/05
		if(ifs_login.bNoInputs) then
			return
		end
		if(this.CurButton == "new") then
			if(this.ListFull) then
				ifs_login_fnSetPieceVis(this, nil)
				Popup_Ok_Large.fnDone = ifs_login_fnListFullOk
				Popup_Ok_Large:fnActivate(1)
				gPopup_fnSetTitleStr(Popup_Ok_Large, "ifs.Profile.listfull")
				return
			end


			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			ifs_vkeyboard.CurString = ScriptCB_GetUniqueLoginName() or "" -- clear
			-- Need to clamp math.max (visible) length of a string, as the user can enter
			-- two really long names, have one kill the other, and that'll overlap
			-- names onscreen, etc.
			local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
			vkeyboard_specs.MaxWidth = (w * 0.32)

			if(gPlatformStr == "PS2") then
				vkeyboard_specs.MaxLen = 10 -- 12 was too long. Dropped to 10 for BF2 bug 5982 NM 7/30/05
			else
				vkeyboard_specs.MaxLen = 14
			end
			vkeyboard_specs.fnDone = ifs_login_fnKeyboardDone
			vkeyboard_specs.fnIsOk = ifs_login_fnIsAcceptable
			IFText_fnSetString(ifs_vkeyboard.title,"ifs.vkeyboard.title_login")
			ifs_movietrans_PushScreen(ifs_vkeyboard)
			
		else
			--we hit accept on a profile in the listbox
            ifelm_shellscreen_fnPlaySound(this.acceptSound)
			-- jump to the load screen
			local Selection = ifs_login_listbox_contents[ifs_login_listbox_layout.SelectedIdx]
			ifs_login_StartLoadProfile(Selection.showstr,nil)
		end
	end,

	Input_Misc = function(this)
		-- Fix for 11032 - if we're headed to another screen already,
		-- ignore inputs - NM 8/20/05
		if(ifs_login.bNoInputs) then
			return
		end

		-- Can only delete when on listbox
		if((not this.CurButton) and (not gNoNewProfiles)) then
            ifelm_shellscreen_fnPlaySound(this.acceptSound)
			Popup_YesNo.CurButton = "no" -- default
			Popup_YesNo.fnDone = ifs_login_fnDeletePopupDone
			ifs_login_fnSetPieceVis(this, nil)
			Popup_YesNo:fnActivate(1)
			gPopup_fnSetTitleStr(Popup_YesNo, "ifs.Profile.confirm_delete")
		end
	end,

	fSilentLoginTimer = 0,
	Update = function(this,fDt)
		-- Call base class functionality
		gIFShellScreenTemplate_fnUpdate(this, fDt)

		if(gPlatformStr == "XBox") then
			this.fSilentLoginTimer = this.fSilentLoginTimer - fDt
			if(this.fSilentLoginTimer < 0) then
				ifs_XLive_fnUpdateSilentLoginBox(this)
			end
		end
	end,
}

ifslogin_vbutton_layout = {
	yTop = 180,
	yHeight = 50,
	ySpacing  = 5,
	width = 260,
	font = gMenuButtonFont,
	buttonlist = { 
		{ tag = "new", string = "ifs.profile.create", },
	},
}

function ifs_login_fnBuildScreen(this)
	if(gPlatformStr == "XBox") then
		ifs_login_listbox_layout.width = ifs_login_listbox_layout.width + ifs_login_listbox_layout.fNumberWidth -- more space due to the numbers added
	end

	ifslogin_vbutton_layout.width = ifs_login_listbox_layout.width

	this.CurButton = AddVerticalButtons(this.buttons,ifslogin_vbutton_layout)

	ifs_login_listbox_layout.yHeight = ScriptCB_GetFontHeight(ifs_login_listbox_layout.Font) + gButtonHeightPad
	local ListboxHeight = ifs_login_listbox_layout.showcount * (ifs_login_listbox_layout.yHeight + ifs_login_listbox_layout.ySpacing) + 30
	this.listbox = NewButtonWindow { ZPos = 100, x=0, y = -40,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- middle of screen
		width = ifs_login_listbox_layout.width + 35,
		height = ListboxHeight,
--		rotY = 20,
--		rotX = -10,
		titleText = "ifs.profile.title"
	}

	if(gPlatformStr == "XBox") then
		ifs_login_listbox_layout.fXCursorOffset = ifs_login_listbox_layout.fNumberWidth
	end

	ListManager_fnInitList(this.listbox,ifs_login_listbox_layout)


	this.buttons.y = ListboxHeight * 0.5 + gButtonGutter

	local InfoWindowW = 280
	local InfoWindowH = 75

	this.LoginInfoWindow = NewIFContainer {
		ScreenRelativeY = 1.0, -- bottom
		ScreenRelativeX = 0.5, -- center
		x = 0,
		y = (InfoWindowH * -0.5) - 30,
		width = InfoWindowW,
		height = InfoWindowH,
		ZPos = 200,
	}

	this.LoginInfoWindow.ShowText = NewIFText {
		font = "gamefont_medium",
		textw = InfoWindowW - 20,
		texth = InfoWindowH - 20,
		nocreatebackground = 1,		
		startdelay = math.random() * 0.5,
		valign = "vcenter",
	}

	if((gDemoBuild) and (not gDemoHasMP)) then
		IFObj_fnSetVis(this.LoginInfoWindow, nil)
	end

end

ifs_login_fnBuildScreen(ifs_login)
ifs_login_fnBuildScreen = nil

AddIFScreen(ifs_login,"ifs_login")