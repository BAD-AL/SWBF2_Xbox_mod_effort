--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_freeform_load_listbox_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { x = layout.x - 0.5 * layout.width, y=layout.y}

	local LineFont = ifs_freeform_load_listbox_layout.FontStr
	local FontHeight = ifs_freeform_load_listbox_layout.iFontHeight

	local IconHeight = FontHeight * 1.5
	local XLeft = 10

	if(gPlatformStr == "XBox") then
		Temp.NumberStr = NewIFText{ 
			x = 10, y = -8, halign = "left", font = "gamefont_tiny",
			textw = ifs_freeform_load_listbox_layout.fNumberWidth, 
			nocreatebackground = 1, startdelay=math.random()*0.5, 
		}
		XLeft = XLeft + ifs_freeform_load_listbox_layout.fNumberWidth
	end

	Temp.TypeIcon = NewIFImage {
		x = XLeft, y = YPos,
--		texture = "check", -- set below
		localpos_l = 10, localpos_t = IconHeight * -0.5,
		localpos_r = 10 + IconHeight, localpos_b = IconHeight * 0.5,
--		tag = "check",
	}

	Temp.NameStr = NewIFText {
		x = XLeft + IconHeight + 20, y = -FontHeight + 2, 
		halign = "left", textw = layout.width - 20,
		valign = "vcenter", texth = FontHeight,
		font = LineFont,
		nocreatebackground=1, startdelay=math.random()*0.5, 
--		string = "a",
	}
	Temp.DateStr = NewIFText { 
		x = XLeft + IconHeight + 20, y = 0, 
		halign = "left", textw = layout.width - 20,
		valign = "vcenter", texth = FontHeight,
		font = LineFont,
		nocreatebackground=1, startdelay=math.random()*0.5,
--		string = "b",
	}

	if(layout.iIdx == 1) then
		Temp.CreateAsNewStr = NewIFText {
			x = XLeft, y = FontHeight * -0.5, 
			halign = "hcenter", textw = layout.width - (XLeft - 10),
			valign = "top", texth = FontHeight,
			font = LineFont,
			nocreatebackground=1, startdelay=math.random()*0.5, 
			string = "ifs.meta.load.saveasnew",
		}
	end

	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ifs_freeform_load_listbox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
	if(Data) then

		-- HACK - no icon for "save as new"
		local SaveAsNewUStr = ScriptCB_getlocalizestr("ifs.meta.load.saveasnew")
		if(Data.namestr == SaveAsNewUStr) then
			Data.bIsCampaign = nil
			Data.bIsROTE = nil
			Data.bIsSaveAsNew = 1
			if(Dest.CreateAsNewStr) then
				IFObj_fnSetVis(Dest.CreateAsNewStr, 1)
				IFObj_fnSetColor(Dest.CreateAsNewStr, iColorR, iColorG, iColorB)
				IFObj_fnSetAlpha(Dest.CreateAsNewStr, fAlpha)
			end
			IFObj_fnSetVis(Dest.NameStr, nil)
			IFObj_fnSetVis(Dest.DateStr, nil)
			if(gPlatformStr == "XBox") then
				IFObj_fnSetVis(Dest.NumberStr, nil)
			end
		else
			Data.bIsSaveAsNew = nil
			if(Dest.CreateAsNewStr) then
				IFObj_fnSetVis(Dest.CreateAsNewStr, nil)
			end
			IFObj_fnSetVis(Dest.NameStr, 1)
			IFObj_fnSetVis(Dest.DateStr, 1)
			if(gPlatformStr == "XBox") then
				IFText_fnSetString(Dest.NumberStr, string.format("%d", Data.iFileNum))
				IFObj_fnSetColor(Dest.NumberStr, iColorR, iColorG, iColorB)
				IFObj_fnSetAlpha(Dest.NumberStr, fAlpha)
				IFObj_fnSetVis(Dest.NumberStr, 1)
			end
		end

		-- Show this entry
		if(Data.bIsCampaign) then
			IFImage_fnSetTexture(Dest.TypeIcon, "conquest_icon")
			IFObj_fnSetVis(Dest.TypeIcon, 1)
		elseif (Data.bIsROTE) then
			IFImage_fnSetTexture(Dest.TypeIcon, "rote_icon")
			IFObj_fnSetVis(Dest.TypeIcon, 1)
		else
			IFObj_fnSetVis(Dest.TypeIcon, nil)
		end

--		Data.namestr = ScriptCB_tounicode("WWWWWWWWW0WWWWWWWWW0WWWWWWWWW0WWWWWWWWW0WWWWWWWWW0WWWWWWWWW01234")
		-- Unicode stringlens are double normal ones. About 40 W's fill up the box
		-- [Fix for 13738, NM 9/19/05]
		local NameLen = string.len(Data.namestr)
		if(NameLen > 100) then
			IFText_fnSetFont(Dest.NameStr, "gamefont_super_tiny")
			IFText_fnSetScale(Dest.NameStr, 0.75, 1) -- extra-compress text
		elseif (NameLen > 80) then
			IFText_fnSetFont(Dest.NameStr, "gamefont_tiny")
		else
			IFText_fnSetFont(Dest.NameStr, ifs_campaign_load_listbox_layout.FontStr)
		end

		IFText_fnSetUString(Dest.NameStr,Data.namestr)
		if(Data.datestr) then
			IFText_fnSetUString(Dest.DateStr,Data.datestr)
		else
			IFText_fnSetString(Dest.DateStr,"")
		end

		IFObj_fnSetColor(Dest.NameStr, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.NameStr, fAlpha)
		IFObj_fnSetColor(Dest.DateStr, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.DateStr, fAlpha)

	else
		-- Blank this entry
		IFText_fnSetString(Dest.NameStr,"")
		IFText_fnSetString(Dest.DateStr,"")
	end

	IFObj_fnSetVis(Dest, Data)
end


ifs_freeform_load_listbox_contents = {
}

ifs_freeform_load_listbox_layout = {
	showcount = 6,
	yHeight = 34,
	ySpacing  = 0,
	width = 420,
	x = 0,
	slider = 1,
	CreateFn = ifs_freeform_load_listbox_CreateItem,
	PopulateFn = ifs_freeform_load_listbox_PopulateItem,
	fNumberWidth = 40, -- width, in pixels, for the XBox's file #
}

function ifs_freeform_load_SetVis(this,vis)
	this.bIsVisible = vis
	IFObj_fnSetVis(this.listbox,vis)
	if( this.Helptext_Accept ) then	
		IFObj_fnSetVis(this.Helptext_Accept,vis)
	end
	if( this.Helptext_Back ) then	
		IFObj_fnSetVis(this.Helptext_Back,vis)
	end	
	if( this.Helptext_Delete ) then
		IFObj_fnSetVis(this.Helptext_Delete,vis and ifs_freeform_load_fnGetShowDelete(this))
	end

--	print("ifs_freeform_load_SetVis(this,", vis, this.Mode)
	if(this.nameedit) then
		IFObj_fnSetVis(this.nameedit, vis and this.Mode=="Save")
		IFObj_fnSetVis(this.nametitle, vis and this.Mode=="Save")

		if(this.Mode=="Save") then
			gCurEditbox = this.nameedit
		else
			gCurEditbox = nil
		end
	end
end

function ifs_freeform_load_fnGetShowDelete(this)
	if(not this.bIsVisible) then
		return nil
	end
	
--	if(this.Mode ~= "Save") then
--		return nil
--	end

	if((not ifs_freeform_load_listbox_contents) or 
		 (table.getn(ifs_freeform_load_listbox_contents) < 1)) then
		return nil
	end

	-- Don't show delete while on the editbox on PC
	if(gCurEditbox and gCurEditbox.bKeepsFocus) then
		return nil
	end

	if(not ifs_freeform_load_listbox_layout.SelectedIdx) then
		return nil
	end

	local Selection = ifs_freeform_load_listbox_contents[ifs_freeform_load_listbox_layout.SelectedIdx]
	return not (Selection.bIsSaveAsNew)
end

function ifs_freeform_load_fnShortPopupOk()
	local this = ifs_freeform_load
	ifs_freeform_load_SetVis(this, 1)
end

function ifs_freeform_load_fnListFullOk()
	local this = ifs_freeform_load
	ifs_freeform_load_SetVis(this, 1)
end

function ifs_freeform_load_fnGetSavedGameList(this)
	-- get the saved game list from the game
	local savemode = (this.Mode == "Save")

	-- get the listbox contents, clear flag that it's a campaign map
	ifs_freeform_load_listbox_contents, this.iMaxSaves = ScriptCB_GetSavedMetagameList(savemode)

	-- how many are there
	local listCount = table.getn(ifs_freeform_load_listbox_contents)

	local i,j
	for i=1,listCount do
		ifs_freeform_load_listbox_contents[i].bIsCampaign = 1
		ifs_freeform_load_listbox_contents[i].bIsROTE = nil
	end

	-- if there are zero games
	if(listCount < 1) then
		this.bNoGames = 1

		-- hide the delete button
		if( this.Helptext_Delete ) then
			IFObj_fnSetVis(this.Helptext_Delete,nil)
		end
		-- show the "no games available" text
		IFObj_fnSetVis(this.nogames,1)
		-- hide the accept button
		if( this.Helptext_Accept ) then
			IFObj_fnSetVis(this.Helptext_Accept,nil)		
		end
	else
		this.bNoGames = nil
		-- show the accept button
		if( this.Helptext_Accept ) then
			IFObj_fnSetVis(this.Helptext_Accept,1)
		end
		
		-- find which one is the current game
		local curGame = 1
		local i
		for i = 1,table.getn(ifs_freeform_load_listbox_contents) do
			if(ifs_freeform_load_listbox_contents[i].isCurrent) then
				curGame = i
			end
		end
		
		-- cursor on the current (or first if no current)
		ifs_freeform_load_listbox_layout.FirstShownIdx = curGame
		ifs_freeform_load_listbox_layout.SelectedIdx = curGame
		ifs_freeform_load_listbox_layout.CursorIdx = curGame

		-- show delete?
		if( this.Helptext_Delete ) then
			IFObj_fnSetVis(this.Helptext_Delete, ifs_freeform_load_fnGetShowDelete(this))
		end
		
		-- hide the "no games available" text
		IFObj_fnSetVis(this.nogames,nil)
	end
	
	-- fill the listbox
	ListManager_fnFillContents(this.listbox,ifs_freeform_load_listbox_contents,ifs_freeform_load_listbox_layout)

end

----------------------------------------------------------------------------------------
-- load the profile list.  this is just the preop, since that refreshes the file list.
----------------------------------------------------------------------------------------

function ifs_freeform_load_StartLoadFileList()
	ifs_saveop.doOp = "LoadFileList"
	ifs_saveop.OnSuccess = ifs_freeform_load_LoadFileListSuccess
	ifs_saveop.OnCancel = ifs_freeform_load_LoadFileListCancel
	ifs_saveop.ForceSaveFailedMessage = (ifs_freeform_load.Mode == "Save")
	ScriptCB_PushScreen("ifs_saveop");
end

function ifs_freeform_load_LoadFileListSuccess()
	-- good, continue
	print("ifs_freeform_load_LoadFileListSuccess")
	
	-- don't reload when we get back to ifs_freeform_load.Enter	
	ifs_freeform_load.bFromLoadFileList = 1
	-- pop ifs_saveop, reenter ifs_freeform_load	
	ScriptCB_PopScreen()	
end

function ifs_freeform_load_LoadFileListCancel()
	-- ok, continue
	print("ifs_freeform_load_LoadFileListCancel")

	-- Fix for 9723 - if we cancel out of this (due to full memcard), then
	-- clear varb to kick us back to the shell immediately. Let the user
	-- get another chance at saving. NM 8/11/05
	ifs_campaign_menu.QuitRequested = nil
	ifs_freeform_menu.QuitRequested = nil

	-- skip forward to the file list screen anyway	
	-- don't reload when we get back to ifs_freeform_load.Enter	
	ifs_freeform_load.bFromLoadFileList = 1
	-- pop ifs_saveop, reenter ifs_freeform_load	
	ScriptCB_PopScreen()	

	if((ifs_freeform_load.Mode == "Save") and (not ifs_freeform_load.NoPromptSave)) then
		-- Stay here, ask again.
		ifs_freeform_load.bFromLoadFileList = nil
		ifs_freeform_load.bErrReenter = 1
	else
		-- Quit out if couldn't load. Fixes 7659 - NM 8/3/05
		ScriptCB_PopScreen()
	end
end

----------------------------------------------------------------------------------------
-- entry prompt for loading
----------------------------------------------------------------------------------------

function ifs_freeform_load_StartPromptLoad()
--	print("ifs_freeform_load_StartPromptLoad")
	local this = ifs_freeform_load

	-- hide this screen
	ifs_freeform_load_SetVis(this,nil)
	
	-- set the button text
	IFText_fnSetString(Popup_LoadSave2.buttons.A.label,ifs_saveop.PlatformBaseStr .. ".continue")
	IFText_fnSetString(Popup_LoadSave2.buttons.B.label,ifs_saveop.PlatformBaseStr .. ".cancel")
	IFText_fnSetString(Popup_LoadSave2.buttons.C.label," ")
	Popup_LoadSave2:fnActivate(1)
	-- set the button visiblity
	IFObj_fnSetVis(Popup_LoadSave2.buttons.A.label,1)	
	IFObj_fnSetVis(Popup_LoadSave2.buttons.B.label,1)	
	IFObj_fnSetVis(Popup_LoadSave2.buttons.C.label,nil)	
	-- set the load/save title text
	gPopup_fnSetTitleStr(Popup_LoadSave2, "ifs.meta.load.confirm_load")	
	Popup_LoadSave2_SelectButton(2)
	IFObj_fnSetVis(Popup_LoadSave2, not ScriptCB_IsErrorBoxOpen())
	Popup_LoadSave2_ResizeButtons()

	Popup_LoadSave2.fnAccept = ifs_freeform_load_LoadPromptAccept	
end

function ifs_freeform_load_LoadPromptAccept(fRet)
	local this = ifs_freeform_load

	Popup_LoadSave2.fnAccept = nil
	Popup_LoadSave2:fnActivate(nil)
	
	if(fRet < 1.5) then
--		print("ifs_freeform_load_SavePromptAccept(A - Continue)")
        ifelm_shellscreen_fnPlaySound(this.acceptSound)
		-- yes, save, so continue
		this.bPromptSave = nil
		
		-- reenter, but don't prompt again
		this.NoPromptSave = 1
		this:Enter(1)
	else
--		print("ifs_freeform_load_SavePromptAccept(B - Cancel)")
		-- no, don't save.  pop this screen and continue
        ifelm_shellscreen_fnPlaySound(this.cancelSound)
		-- call the exit func
		if(ifs_freeform_load.ExitFunc) then
--			print("ifs_freeform_load.ExitFunc()")
			ifs_freeform_load.ExitFunc()
			ifs_freeform_load.ExitFunc = nil
		end		
		--pop it
		ScriptCB_PopScreen()
	end	
end


----------------------------------------------------------------------------------------
-- load selected campaign
----------------------------------------------------------------------------------------

function ifs_freeform_load_StartLoadCampaign(name1)
--	print("ifs_freeform_load_StartLoadCampaign")
	ifs_saveop.doOp = "LoadCampaign"
	ifs_saveop.OnSuccess = ifs_freeform_load_LoadCampaignSuccess
	ifs_saveop.OnCancel = ifs_freeform_load_LoadCampaignCancel
	ifs_saveop.filename1 = name1
	ScriptCB_PushScreen("ifs_saveop")
end

function ifs_freeform_load_LoadCampaignSuccess()
	print("ifs_freeform_load_LoadCampaignSuccess")
	-- don't prompt a save when we get into the campaign, since we just loaded
	ifs_freeform_main.requestSave = nil
	ifs_freeform_load.bFromLoadDelete = 1
	-- restart the shell (HACK)
	if ifs_freeform_main.wasSplit then
		ScriptCB_SetSplitscreen(ifs_freeform_main.wasSplit)
	end
	ScriptCB_ClearMetagameState()
	ScriptCB_ClearMissionSetup()
	SetState("shell")
	-- 
--	if ScriptCB_IsScreenInStack("ifs_freeform_main") then
--		ScriptCB_PopScreen("ifs_freeform_main")
--	end
--	ScriptCB_PopScreen()
--	ScriptCB_PushScreen("ifs_freeform_main")
end

function ifs_freeform_load_LoadCampaignCancel()
	print("ifs_freeform_load_LoadCampaignCancel")
	-- error, should go back to the LoadFileList state	
	ifs_freeform_load.bFromLoadDelete = 1
	ifs_freeform_load.bFromDeleteCancel = 1
	-- bail from ifs_saveop
	ScriptCB_PopScreen()
end


----------------------------------------------------------------------------------------
-- load selected metagame
----------------------------------------------------------------------------------------

function ifs_freeform_load_StartLoadMetagame(name1)
	print("ifs_freeform_load_StartLoadMetagame")
	ifs_saveop.doOp = "LoadMetagame"
	ifs_saveop.OnSuccess = ifs_freeform_load_LoadMetagameSuccess
	ifs_saveop.OnCancel = ifs_freeform_load_LoadMetagameCancel
	ifs_saveop.filename1 = name1
	ScriptCB_PushScreen("ifs_saveop")
end

function ifs_freeform_load_LoadMetagameSuccess()
	print("ifs_freeform_load_LoadMetagameSuccess")
	-- don't prompt a save when we get into the metagame, since we just loaded
	ifs_freeform_main.requestSave = nil
	ifs_freeform_load.bFromLoadDelete = 1
	-- restart the shell (HACK)
	if ifs_freeform_main.wasSplit then
		ScriptCB_SetSplitscreen(ifs_freeform_main.wasSplit)
	end
	ScriptCB_ClearCampaignState()
	ScriptCB_ClearMissionSetup()
	SetState("shell")
	-- 
--	if ScriptCB_IsScreenInStack("ifs_freeform_main") then
--		ScriptCB_PopScreen("ifs_freeform_main")
--	end
--	ScriptCB_PopScreen()
--	ScriptCB_PushScreen("ifs_freeform_main")
end

function ifs_freeform_load_LoadMetagameCancel()
--	print("ifs_freeform_load_LoadMetagameCancel")
	-- error, should go back to the LoadFileList state	
	ifs_freeform_load.bFromLoadDelete = 1
	-- bail from ifs_saveop
	ScriptCB_PopScreen()
end

----------------------------------------------------------------------------------------
-- entry prompt for saving
----------------------------------------------------------------------------------------

function ifs_freeform_load_StartPromptSave()
--	print("ifs_freeform_load_StartPromptSave")
	local this = ifs_freeform_load

	-- hide this screen
	ifs_freeform_load_SetVis(this,nil)
	
	-- set the button text
	IFText_fnSetString(Popup_LoadSave2.buttons.A.label,ifs_saveop.PlatformBaseStr .. ".save")
	IFText_fnSetString(Popup_LoadSave2.buttons.B.label,ifs_saveop.PlatformBaseStr .. ".continuenosave")
	IFText_fnSetString(Popup_LoadSave2.buttons.C.label," ")
	Popup_LoadSave2:fnActivate(1)
	-- set the button visiblity
	IFObj_fnSetVis(Popup_LoadSave2.buttons.A.label,1)	
	IFObj_fnSetVis(Popup_LoadSave2.buttons.B.label,1)	
	IFObj_fnSetVis(Popup_LoadSave2.buttons.C.label,nil)	
	-- set the load/save title text
	gPopup_fnSetTitleStr(Popup_LoadSave2, "ifs.meta.load.confirm_save")	
	Popup_LoadSave2_SelectButton(1)
	IFObj_fnSetVis(Popup_LoadSave2, not ScriptCB_IsErrorBoxOpen())
	Popup_LoadSave2_ResizeButtons()

	Popup_LoadSave2.fnAccept = ifs_freeform_load_SavePromptAccept	
end

function ifs_freeform_load_SavePromptAccept(fRet)
	local this = ifs_freeform_load

	Popup_LoadSave2.fnAccept = nil
	Popup_LoadSave2:fnActivate(nil)
	
	if(fRet < 1.5) then
--		print("ifs_freeform_load_SavePromptAccept(A - Save)")
        ifelm_shellscreen_fnPlaySound(this.acceptSound)
		-- yes, save, so continue
		this.bPromptSave = nil
		
		-- reenter, but don't prompt again
		this.NoPromptSave = 1
		this:Enter(1)
	else
--		print("ifs_freeform_load_SavePromptAccept(B - Continue wihtout saving)")
		-- no, don't save.  pop this screen and continue
        ifelm_shellscreen_fnPlaySound(this.cancelSound)
		-- call the exit func
		if(ifs_freeform_load.ExitFunc) then
--			print("ifs_freeform_load.ExitFunc()")
			ifs_freeform_load.ExitFunc()
			ifs_freeform_load.ExitFunc = nil
		end		
		--pop it
		ScriptCB_PopScreen()
	end	
end

----------------------------------------------------------------------------------------
-- save the current metagame into the slot selected
----------------------------------------------------------------------------------------

function ifs_freeform_load_StartSaveMetagame(aOldFilename, aNewFilename)
--	print("ifs_freeform_load_StartSaveMetagame(",aFilename,")")
	
	-- save current state	
	ifs_freeform_main:SaveState()
	
	ifs_saveop.doOp = "SaveMetagame"
	ifs_saveop.OnSuccess = ifs_freeform_load_SaveMetagameSuccess
	ifs_saveop.OnCancel = ifs_freeform_load_SaveMetagameCancel
	ifs_saveop.filename1 = aOldFilename
	ifs_saveop.filename2 = aNewFilename
	-- we handled this part here
	ifs_saveop.NoPromptSave = 1
    ScriptCB_PushScreen("ifs_saveop")
end

function ifs_freeform_load_SaveMetagameSuccess()
--	print("ifs_freeform_load_SaveMetagameSuccess")
	-- pop ifs_saveop
	ifs_freeform_load.PopOnEnter = 1
	ScriptCB_PopScreen()
end

function ifs_freeform_load_SaveMetagameCancel()
--	print("ifs_freeform_load_SaveMetagameCancel")
	-- do nothing when we reenter ifs_freeform_load
	ifs_freeform_load.bFromSaveCancel = 1
	-- bail from ifs_saveop
	ScriptCB_PopScreen()
	-- don't pop to metagame, since we might want to try again
end

----------------------------------------------------------------------------------------
-- delete a metagame
----------------------------------------------------------------------------------------

function ifs_freeform_load_fnDeletePopupDone(bResult)
	local this = ifs_freeform_load
	
	if(bResult) then
--		print("ifs_freeform_load_fnDeletePopupDone(true)")
		ifs_freeform_load_SetVis(this, 1)

        ifelm_shellscreen_fnPlaySound(this.acceptSound)
		-- User does want to delete
		local Selection = ifs_freeform_load_listbox_contents[ifs_freeform_load_listbox_layout.SelectedIdx]
--		print("idx = ",ifs_freeform_load_listbox_layout.SelectedIdx)
		
		ifs_saveop.doOp = "DeleteMetagame"
		ifs_saveop.OnSuccess = ifs_freeform_load_DeleteMetagameSuccess
		ifs_saveop.OnCancel = ifs_freeform_load_DeleteMetagameCancel
		ifs_saveop.filename1 = Selection.filename
		ScriptCB_PushScreen("ifs_saveop")
		
	else
        ifelm_shellscreen_fnPlaySound(this.cancelSound)
--		print("ifs_freeform_load_fnDeletePopupDone(false)")
		-- User hit no. Back to normal screen
		ifs_freeform_load_SetVis(this, 1)
	end
end

function ifs_freeform_load_DeleteMetagameSuccess()
--	print("ifs_freeform_load_DeleteMetagameSuccess")
	ifs_freeform_load.bFromLoadDelete = 1
	ScriptCB_PopScreen()
end

function ifs_freeform_load_DeleteMetagameCancel()
--	print("ifs_freeform_load_DeleteMetagameCancel")
	ifs_freeform_load.bFromLoadDelete = 1
	ifs_freeform_load.bFromDeleteCancel = 1
	-- bail from ifs_saveop
	ScriptCB_PopScreen()
end

-- Callback function from VK - returns 2 values, whether the current
-- string is allowed to be entered, and a localize database key string
-- as to why it's not acceptable.
function ifs_freeform_fnIsAcceptable()
	return (string.len(ifs_vkeyboard.CurString) > 2),"ifs.vkeyboard.tooshort"
end

-- Callback function when the virtual keyboard is done
function ifs_freeform_fnKeyboardDone()
	local this = ifs_freeform_load

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

	this.bSaveOnEnter = 1
	this.NewFilenameUStr = ScriptCB_tounicode(CurString)
	ScriptCB_PopScreen()
end


----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

ifs_freeform_load = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,

	nogames = NewIFText {
		string = "ifs.meta.load.nogames",
		font = "gamefont_medium",
		textw = 460,
		y = 0,
		valign = "top",
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- top
		inert = 1,
		nocreatebackground=1,
	},

	Enter = function(this, bFwd)
--		print("ifs_freeform_load.Enter(",bFwd,")")
		gIFShellScreenTemplate_fnEnter(this, bFwd)

		ifs_freeform_load_SetVis(this,1) -- default, turn things on on entry

		-- Hide static background when we're not in GC/ROTE proper - NM 9/20/05
		IFObj_fnSetVis(this.bg, not
									 (ScriptCB_IsScreenInStack("ifs_campaign_main") or 
										ScriptCB_IsScreenInStack("ifs_freeform_main")))

		if( this.Helptext_Delete ) then
			IFObj_fnSetVis( this.Helptext_Delete, nil )
		end

		if(this.bSaveOnEnter) then
			this.bSaveOnEnter = nil
			ifs_freeform_load_StartSaveMetagame(this.LastFilenameUStr, this.NewFilenameUStr)
			return
		end

		if(bFwd) then
			ifs_saveop.bNoSilentFail = 1 --  Fixes 7659 - NM 8/3/05

			-- And, on the PC, clear out the last save name
			if(this.nameedit) then
				IFEditbox_fnSetString(this.nameedit, "")
				this.nameedit.bKeepsFocus = nil
			end
			
			-- save this because ifs_saveop clears it after exiting
			this.saveProfileNum = ifs_saveop.saveProfileNum
		end
		
		if(this.PopOnEnter) then
--			print("ifs_freeform_load.PopOnEnter")
			this.PopOnEnter = nil
			-- call the exit func
			if(ifs_freeform_load.ExitFunc) then
--				print("ifs_freeform_load.ExitFunc()")
				ifs_freeform_load.ExitFunc()
				ifs_freeform_load.ExitFunc = nil
			end
			-- pop ifs_freeform_load, return to metagame
			ScriptCB_PopScreen()
			return
		end
		
		--if you back into this screen (and its not from saveop), keep going
		if(not (bFwd or this.bErrReenter or this.bFromLoadFileList or this.bFromLoadDelete or this.bFromSaveCancel)) then
			ScriptCB_PopScreen()
			return
		end
		ifs_freeform_load.bErrReenter = nil -- always clear this

		-- right align the delete button
		if( this.Helptext_Delete ) and (gPlatformStr ~= "PC") then
			gHelptext_fnMoveIcon(this.Helptext_Delete)	
		end
		
		-- hide the no games text	
		IFObj_fnSetVis(this.nogames,nil)
		

		-- setup things according to the current mode		
		if(this.Mode == "Load") then
--			print("ifs_freeform_load.Enter Load")

			-- if this is the first time entering, prompt for "do you want to load yes/no?"
			if(not (this.NoPromptSave or this.SkipPromptSave or this.bFromLoadFileList or this.bFromLoadDelete or this.bFromSaveCancel or 
							(ScriptCB_IsScreenInStack("ifs_sp_gc_main") and not
							 ScriptCB_IsScreenInStack("ifs_freeform_main")))) then
				ifs_freeform_load_StartPromptLoad()
				return
			end
			this.NoPromptSave = nil
			
			-- set the orange title bar text
			gButtonWindow_fnSetText(this.listbox,"ifs.meta.load.load")
			-- set the accept button text
			if( this.Helptext_Accept ) then
				if (gPlatformStr ~= "PC") then
					IFText_fnSetString(this.Helptext_Accept.helpstr,"ifs.meta.load.btnload")
				else
					RoundIFButtonLabel_fnSetString(this.Helptext_Accept,"ifs.meta.load.btnload")
				end
			end
			
		elseif(this.Mode == "Save") then
--			print("ifs_freeform_load.Enter Save")
			
			-- if this is the first time entering, prompt for "do you want to save yes/no?"
			if(not (this.NoPromptSave or this.SkipPromptSave or this.bFromLoadFileList or this.bFromLoadDelete or this.bFromSaveCancel)) then
				ifs_freeform_load_StartPromptSave()
				return
			end
			this.NoPromptSave = nil
			
			-- set the orange title bar text
			gButtonWindow_fnSetText(this.listbox,"ifs.meta.load.save")
			-- set the accept button text
			if( this.Helptext_Accept ) then
				if (gPlatformStr ~= "PC") then
					IFText_fnSetString(this.Helptext_Accept.helpstr,"ifs.meta.load.btnsave")
				else
					RoundIFButtonLabel_fnSetString(this.Helptext_Accept,"ifs.meta.load.btnsave")
				end
			end
			
			
		else
			print("ifs_freeform_load.Mode not set (either Load or Save)")
			assert(ifs_freeform_load.Mode == "Load" or ifs_freeform_load.Mode == "Save")
		end


		if(bFwd or this.bFromDeleteCancel) then
			this.bFromDeleteCancel = nil
			-- load the list of saved games?
			if(not this.bFromLoadFileList) then
				ifs_freeform_load_StartLoadFileList()
			end
			this.bFromLoadFileList = nil
		else
			ifs_freeform_load_fnGetSavedGameList(ifs_freeform_load)		
		end
		
	end,

 	Exit = function(this, bFwd)
 		-- unhighlight the back button, if high-lit
 		if(this.Helptext_Back) then
 			IFButton_fnSelect(this.Helptext_Back, false, false)
 		end

 		ifs_freeform_load_listbox_contents = nil
 		this.bFromLoadFileList = nil
 		this.bFromLoadDelete = nil
 		this.bFromSaveCancel = nil

		if not bFwd then
			this.SkipPromptSave = nil
			this.saveProfileNum = nil
			ifs_saveop.bNoSilentFail = nil
			-- Fix for 9224 - clear mode - NM 8/9/05
			this.Mode = "<none>"
		end
	end,

	Input_GeneralUp = function(this,iJoystick)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputUp(this)) then
			return
		end

		if(not gCurEditbox) then
			ListManager_fnNavUp(this.listbox,ifs_freeform_load_listbox_contents,ifs_freeform_load_listbox_layout)
		end

		IFObj_fnSetVis(this.Helptext_Delete,ifs_freeform_load_fnGetShowDelete(this))
	end,

	Input_LTrigger = function(this,iJoystick)
		if(not gCurEditbox) then
			ListManager_fnPageUp(this.listbox,ifs_freeform_load_listbox_contents,ifs_freeform_load_listbox_layout)
		end

		-- if we're on the top item in save mode, disable the delete button
		IFObj_fnSetVis(this.Helptext_Delete,ifs_freeform_load_fnGetShowDelete(this))
	end,

	Input_GeneralDown = function(this,iJoystick)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputDown(this)) then
			return
		end

		if(not gCurEditbox) then
			ListManager_fnNavDown(this.listbox,ifs_freeform_load_listbox_contents,ifs_freeform_load_listbox_layout)
		end
			
		IFObj_fnSetVis(this.Helptext_Delete,ifs_freeform_load_fnGetShowDelete(this))

	end,

	Input_RTrigger = function(this,iJoystick)
		if(not gCurEditbox) then
			ListManager_fnPageDown(this.listbox,ifs_freeform_load_listbox_contents,ifs_freeform_load_listbox_layout)
		end
		IFObj_fnSetVis(this.Helptext_Delete,ifs_freeform_load_fnGetShowDelete(this))
	end,

	-- Not possible on this screen
	Input_GeneralLeft = function(this)
	end,
	Input_GeneralRight = function(this)
	end,

	fnPostError = function(this,bUserHitYes,ErrorLevel,ErrorMessage)
--									print("Do Nothing")
		if(ScriptCB_IsPopupOpen()) then
			IFObj_fnSetVis(Popup_LoadSave2,1)
		end
--		print("ifs_mp_main fnPostError(..,",bUserHitYes,ErrorLevel)
--		if(ErrorLevel >= 6) then
--			ScriptCB_PopScreen()
--		end
	end,

	fDoubleClickTimer = 0,
	Update = function(this, fDt)
		-- Always call base class
		gIFShellScreenTemplate_fnUpdate(this, fDt)
		this.fDoubleClickTimer = math.max(this.fDoubleClickTimer - fDt, 0.0)

		if(gPlatformStr == "PC") then

			if(this.Mode == "Load") then
				RoundIFButtonLabel_fnSetString(this.Helptext_Accept,"ifs.meta.load.btnload")
			else
				if(gCurEditbox and gCurEditbox.bKeepsFocus) then
					RoundIFButtonLabel_fnSetString(this.Helptext_Accept,"ifs.meta.load.btnsavenew")
					IFObj_fnSetVis(this.Helptext_Accept, this.bIsVisible)
					ifs_freeform_load_listbox_layout.CursorIdx = nil
					ifs_freeform_load_listbox_layout.SelectedIdx = nil
					ListManager_fnFillContents(this.listbox, ifs_freeform_load_listbox_contents, ifs_freeform_load_listbox_layout)
				else
					this.nameedit.bKeepsFocus = nil
					RoundIFButtonLabel_fnSetString(this.Helptext_Accept,"ifs.meta.load.btnsave")
					IFObj_fnSetVis(this.Helptext_Accept, this.bIsVisible and ifs_freeform_load_listbox_contents and 
												 table.getn(ifs_freeform_load_listbox_contents) > 0)
				end
			end

			IFObj_fnSetVis(this.Helptext_Delete,ifs_freeform_load_fnGetShowDelete(this))
		end
	end,

	Input_Accept = function(this,iJoystick)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this) and (iJoystick)) then
			if((gMouseListBox) and (gCurEditbox) and (not gCurEditbox.bMouseover)) then
				IFEditbox_fnHilight(gCurEditbox, nil)
				gCurEditbox = nil
			end
			return
		end
		
		-- Clear highlight on current listbox if present
		local EntryEditbox = gCurEditbox
		if((gCurEditbox) and (not gCurEditbox.bMouseover) and 
			(((string.len(IFEditbox_fnGetString(this.nameedit)) < 1) or this.CurButton or gMouseListBox))) then
			IFEditbox_fnHilight(gCurEditbox, nil)
			gCurEditbox = nil
		end
		if((gCurEditbox) and (gCurEditbox.bMouseover)) then
			gCurEditbox.bKeepsFocus = 1
		end
	
		if (gPlatformStr == "PC") then
			if((gMouseListBox) and (not this.CurButton)) then
				gMouseListBox.Layout.SelectedIdx = gMouseListBox.Layout.CursorIdx
				ListManager_fnFillContents(gMouseListBox,gMouseListBox.Contents,gMouseListBox.Layout)
				IFObj_fnSetVis(this.Helptext_Delete,ifs_freeform_load_fnGetShowDelete(this))
				if(this.fDoubleClickTimer < 0.001) then
					this.fDoubleClickTimer = 0.35
					return
				else
					this.CurButton = "accept" -- fake an accept on double-click
				end
			end
			
			if(this.CurButton == "_back") then
				this:Input_Back()
				return
			elseif(this.CurButton == "delete") then
--				print("+++this.CurButton = ", this.CurButton)
				ifs_freeform_load_DeleteGame(this,iJoystick)
				return
			elseif(this.CurButton == "accept") then
				-- fall through
			else
				return
			end
		end
		
		-- which mode are we in?
		if(this.Mode == "Load") then
			
			-- invalid last battle information
			ifs_freeform_main.requestSave = nil
			ifs_saveop.NoPromptSave = 1
			ScriptCB_SetLastBattleVictoryValid(nil)
			
			-- if no games, pop
			if( this.bNoGames ) then
				ScriptCB_PopScreen()
				return
			end
			if(table.getn(ifs_freeform_load_listbox_contents) > 0) then
				-- load the freeform game data from file
				local Selection = ifs_freeform_load_listbox_contents[ifs_freeform_load_listbox_layout.SelectedIdx]
				ifelm_shellscreen_fnPlaySound(this.acceptSound)
				if(Selection.bIsCampaign) then
					ifs_freeform_load_StartLoadMetagame(Selection.filename)
				else
					ifs_freeform_load_StartLoadCampaign(Selection.filename)
				end
			end
			
		elseif (this.Mode == "Save") then

			-- On PC, save as new if that's requested.
			if(EntryEditbox) then
				local CurString = IFEditbox_fnGetString(this.nameedit)
				local LastByte
				repeat
					local l = string.len(CurString)
					LastByte = string.byte(string.sub(CurString,-1))
					if(LastByte == 32) then
						CurString = string.sub(CurString, 1, l - 1)
						--				print("Truncating last char...")
					end
				until (LastByte ~= 32)

				if(string.len(CurString) < 1) then
					ifs_freeform_load_SetVis(this, nil)
					Popup_Ok.fnDone = ifs_freeform_load_fnShortPopupOk
					Popup_Ok:fnActivate(1)
					gPopup_fnSetTitleStr(Popup_Ok, "ifs.vkeyboard.tooshort")
				else
					this.LastFilenameUStr = nil
					this.NewFilenameUStr = ScriptCB_tounicode(CurString)
					ifs_freeform_load_StartSaveMetagame(this.LastFilenameUStr, this.NewFilenameUStr)
				end

				return
			end

			local Selection = ifs_freeform_load_listbox_contents[ifs_freeform_load_listbox_layout.SelectedIdx]

			if(Selection and (Selection.bIsSaveAsNew) and
				 (table.getn(ifs_freeform_load_listbox_contents) > this.iMaxSaves)) then
				ifs_freeform_load_SetVis(this, nil)
				Popup_Ok_Large.fnDone = ifs_freeform_load_fnListFullOk
				Popup_Ok_Large:fnActivate(1)
				gPopup_fnSetTitleStr(Popup_Ok_Large, "ifs.meta.load.listfull")
				return
			end

			-- which slot did we select, save into that
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			if(gPlatformStr == "PC") then
--				print("Starting save!")
				this.LastFilenameUStr = Selection.filename
				this.NewFilenameUStr = Selection.namestr
				ifs_freeform_load_StartSaveMetagame(Selection.filename, Selection.namestr)
			else

				if(not Selection.bIsSaveAsNew) then
					ifs_vkeyboard.CurString = Selection.namestr
					this.LastFilenameUStr = Selection.filename
				else
					this.LastFilenameUStr = nil
					ifs_vkeyboard.CurString = ScriptCB_GetCurrentProfileName()
				end 

				ifelm_shellscreen_fnPlaySound(this.acceptSound)
				-- Need to clamp math.max (visible) length of a string, as the user can enter
				-- two really long names, have one kill the other, and that'll overlap
				-- names onscreen, etc.
				local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
				vkeyboard_specs.MaxWidth = (w * 0.45)

				if(gPlatformStr == "PS2") then
					vkeyboard_specs.MaxLen = 10 -- 12 was too long. Dropped to 10 for BF2 bug 5982 NM 7/30/05
				else
					vkeyboard_specs.MaxLen = 28
				end
				vkeyboard_specs.fnDone = ifs_freeform_fnKeyboardDone
				vkeyboard_specs.fnIsOk = ifs_freeform_fnIsAcceptable
				IFText_fnSetString(ifs_vkeyboard.title,"ifs.vkeyboard.title_rote")
				ifs_movietrans_PushScreen(ifs_vkeyboard)
			end -- not PC
		else
			-- error bad mode
			assert(false);
		end
	end,
	
	Input_Back = function(this,iJoystick)
--		print("ifs_freeform_load.Input_Back()")

		-- clear all of these
 		this.bFromLoadFileList = nil
 		this.bFromLoadDelete = nil
 		this.bFromSaveCancel = nil		
		
		if(this.Mode == "Save" and not this.SkipPromptSave) then
			-- the back button shouldn't pop, just reenter to the "do you want to save yes/no" prompt
			this:Enter(1)
		else
			-- in load mode just pop
			ScriptCB_PopScreen()
		end
	end,

	-- delete a saved metagame
	Input_Misc = function(this,iJoystick)
		if(gPlatformStr ~= "PC") then
			ifs_freeform_load_DeleteGame(this,iJoystick) -- call helper function
		end
	end,
	
	Input_Start = function(this,iJoystick)
		if(gCurEditbox) then
			-- handle Escape or Tab
			IFEditbox_fnHilight(gCurEditbox, nil)
			gCurEditbox = nil
			ifs_freeform_load_fnGetSavedGameList(ifs_freeform_load)
		else
			this:Input_Back(iJoystick)
		end
	end,

	Input_KeyDown = function(this, iKey)
		-- ignore if not visible
		if not this.bIsVisible then return end
		
		if(gCurEditbox) then
			gCurEditbox.bKeepsFocus = 1

			-- is this key allowed?
			local badchars = { 47, 92, 58, 42, 63, 34, 60, 62, 124, }
							-- '/' '\' ':' '*' '?' '"' '<' '>' '|'
			local n = table.getn(badchars)
			for i=1,n do
				if(badchars[i] == iKey) then
					ScriptCB_SndPlaySound("shell_menu_error")
					return
				end
			end
			
			if((iKey == 10) or (iKey == 13)) then
				-- handle Enter different
				if this.Helptext_Accept and IFObj_fnGetVis(this.Helptext_Accept) then
					if(gCurEditbox) then
						gCurEditbox.bKeepsFocus = nil
					end
					this.CurButton = "accept"
					this:Input_Accept()
				end
			elseif(iKey == 9) then 
				-- handle Tab
				IFEditbox_fnHilight(gCurEditbox, nil)
				gCurEditbox = nil
				ifs_freeform_load_fnGetSavedGameList(ifs_freeform_load)		
				return
			else
				IFEditbox_fnAddChar(gCurEditbox, iKey)
			end
			local CurString = IFEditbox_fnGetString(this.nameedit)
			if(string.len(CurString) < 1) then
				gCurEditbox.bKeepsFocus = nil
			end
		else
			if((iKey == 10) or (iKey == 13)) then
				-- handle Enter different
				this.CurButton = "accept"
				this:Input_Accept()
			elseif(iKey == 8) then
				-- handle Backspace
				this.CurButton = "_back"
				this:Input_Accept()				
			elseif(iKey == 9) then
				-- handle Tab
				if(this.Mode=="Save") then
					gCurEditbox = this.nameedit
					gCurEditbox.bKeepsFocus = 1
					IFEditbox_fnHilight(gCurEditbox, 1)
				end
			elseif iKey == -211 then
				-- handle Delete
				if this.Helptext_Delete and IFObj_fnGetVis(this.Helptext_Delete) then
					this.CurButton = "delete"
					this:Input_Accept()
				end
			end
		end
	end,
}

function ifs_freeform_load_DeleteGame(this,iJoystick)
	-- no delete on load
	if((gPlatformStr == "PC") or (this.Mode == "Save")) then
		if(table.getn(ifs_freeform_load_listbox_contents) > 0) then
			-- make sure the selection has a filename (ie. its not "save as new")
			local Selection = ifs_freeform_load_listbox_contents[ifs_freeform_load_listbox_layout.SelectedIdx]
			if(Selection.filename) then
				ifelm_shellscreen_fnPlaySound("shell_menu_accept")
				Popup_YesNo.CurButton = "no" -- default
				Popup_YesNo.fnDone = ifs_freeform_load_fnDeletePopupDone
				ifs_freeform_load_SetVis(this,nil)
				Popup_YesNo:fnActivate(1)
				gPopup_fnSetTitleStr(Popup_YesNo, "ifs.meta.load.confirm_delete")
			end
		end
	end
end

function ifs_freeform_load_fnBuildScreen(this)
	local w,h = ScriptCB_GetSafeScreenInfo()

	-- Don't use all of the screen for the listbox
	local listWidth = w * 0.9
	local listHeight
	local listYPos
	if(gPlatformStr == "PC") then
		listHeight = h * 0.70
		listYPos = (h * -0.10) - 10
	else
		listHeight = h * 0.75
		listYPos = -10
	end

	ifs_freeform_load_listbox_layout.FontStr = "gamefont_small"
	ifs_freeform_load_listbox_layout.iFontHeight = ScriptCB_GetFontHeight(ifs_freeform_load_listbox_layout.FontStr)
	ifs_freeform_load_listbox_layout.yHeight = (2 * ifs_freeform_load_listbox_layout.iFontHeight) + 4

	local RowHeight = ifs_freeform_load_listbox_layout.yHeight + ifs_freeform_load_listbox_layout.ySpacing
	ifs_freeform_load_listbox_layout.showcount = math.floor(listHeight / RowHeight)

	this.listbox = NewButtonWindow { 
		ZPos = 200, 
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- middle of screen
		width = listWidth,
		y = listYPos,
		height = ifs_freeform_load_listbox_layout.showcount * RowHeight + 30,
		titleText = "ifs.meta.load.load"
	}
	ifs_freeform_load_listbox_layout.width = listWidth - 40
	ifs_freeform_load_listbox_layout.x = 0

	if(gPlatformStr == "XBox") then
		ifs_freeform_load_listbox_layout.fXCursorOffset = ifs_freeform_load_listbox_layout.fNumberWidth
	end

	ListManager_fnInitList(this.listbox,ifs_freeform_load_listbox_layout)
	
	if(gPlatformStr == "PC") then
		-- Background texture requested by Greg Johnson - NM 9/20/05
		ifelem_shellscreen_fnAddBackground(this, "single_player_campaign")

		local btnw = 150
		local btnh = 25
		local EditBoxW = listWidth

		this.nametitle = NewIFText {
			string = "ifs.meta.load.saveasnew",
			font = "gamefont_medium",
			textw = 460,
			valign = "top",
			halign = "left",
			ScreenRelativeX = 0.5, -- center
			ScreenRelativeY = 1.0,
			y = -120,
			x = EditBoxW * -0.5,
			nocreatebackground=1,
		}

		this.nameedit = NewEditbox {
			width = EditBoxW,
			height = 40,
			font = "gamefont_medium",
			--		string = "Player 1",
			MaxLen = EditBoxW - 50,
			MaxChars = 63,
			bKeepsFocus = 1,
			ScreenRelativeX = 0.5,
			ScreenRelativeY = 1.0,
			y = -80,
		}
		
		this.Helptext_Delete = NewPCIFButton 
		{
			ScreenRelativeX = 0.5,
			ScreenRelativeY = 1.0,
			x = 0,
			y = -15,
			
			btnw = btnw, 
			btnh = btnh,
			font = "gamefont_medium", 
			bg_width = btnw,
			--nocreatebackground=1,
			tag = "delete"
		}
		this.Helptext_Delete.label.halign = "hcenter"
		RoundIFButtonLabel_fnSetString(this.Helptext_Delete ,"ifs.profile.delete")

		this.Helptext_Accept = NewPCIFButton
		{
			ScreenRelativeX = 1.0,
			ScreenRelativeY = 1.0,
			x = -60,
			y = -15,

			btnw = btnw, 
			btnh = btnh,
			font = "gamefont_medium", 
			bg_width = btnw,
			--nocreatebackground=1,
			tag = "accept",
		}
		--this.Helptext_Accept.label.halign = "right"
		RoundIFButtonLabel_fnSetString(this.Helptext_Accept ,"common.accept")
	else
		this.Helptext_Delete = NewHelptext {
			ScreenRelativeX = 1.0, -- Left of center, but not in the normal 'back' position
			ScreenRelativeY = 1.0, -- bot
			y = -40,
			x = 0,
			buttonicon = "btnmisc",
			string = "ifs.profile.delete",
			bRightJustify = 1,
		}
	end -- PC buttons
	
end


ifs_freeform_load_fnBuildScreen(ifs_freeform_load)
ifs_freeform_load_fnBuildScreen = nil
AddIFScreen(ifs_freeform_load,"ifs_freeform_load")
