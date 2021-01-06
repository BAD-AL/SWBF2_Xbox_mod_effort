--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_meta_load_listbox_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { x = layout.x - 0.5 * layout.width, y=layout.y - 10}

	local LineFont = "gamefont_medium"
	if(gLangStr ~= "english") then
		LineFont = "gamefont_tiny"
	end

	Temp.NameStr = NewIFText{
		x = 10, y = 0, halign = "left", font = LineFont,
		textw = layout.width - 30, nocreatebackground=1, startdelay=math.random()*0.5, 
	}
	Temp.DateStr = NewIFText{ 
		x = layout.width * 0.5, y = 0, halign = "left", font = LineFont, 
		textw = 220, nocreatebackground=1, startdelay=math.random()*0.5,
	}
	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ifs_meta_load_listbox_PopulateItem(Dest,Data)
	if(Data) then
		-- Show this entry
		IFText_fnSetUString(Dest.NameStr,Data.namestr)
		if(Data.datestr) then
			IFText_fnSetUString(Dest.DateStr,Data.datestr)
		else
			IFText_fnSetString(Dest.DateStr,"")
		end
		IFObj_fnSetVis(Dest.NameStr,1)
	else
		-- Blank this entry
		IFText_fnSetString(Dest.NameStr,"")
		IFText_fnSetString(Dest.DateStr,"")
		IFObj_fnSetVis(Dest.NameStr,nil)
	end
end


ifs_meta_load_listbox_contents = {
}

ifs_meta_load_listbox_layout = {
	showcount = 6,
	yHeight = 34,
	ySpacing  = 0,
	width = 560,
	x = 0,
	--slider = 1,
	CreateFn = ifs_meta_load_listbox_CreateItem,
	PopulateFn = ifs_meta_load_listbox_PopulateItem,
}

function ifs_meta_load_SetVis(this,vis)
	IFObj_fnSetVis(this.buttons,vis)
	IFObj_fnSetVis(this.listbox,vis)
	if( this.Helptext_Accept ) then	
		IFObj_fnSetVis(this.Helptext_Accept,vis)
	end
	if( this.Helptext_Back ) then	
		IFObj_fnSetVis(this.Helptext_Back,vis)
	end	
	if( this.Helptext_Delete ) then
		if(gPlatformStr ~= "PC") then
			IFObj_fnSetVis(this.Helptext_Delete,vis and this.Mode=="Save")
		else
			IFObj_fnSetVis(this.Helptext_Delete, nil)
		end
	end
end



function ifs_meta_load_fnGetSavedGameList(this)
	-- get the saved game list from the game
	local savemode = (this.Mode == "Save")
	
	if( ScriptCB_IsSplitscreen() == 1) then
		ScriptCB_GetSavedMetagameListSplitScreen("ifs_meta_load_listbox_contents",savemode)
	else
		ScriptCB_GetSavedMetagameList("ifs_meta_load_listbox_contents",savemode)
	end
	
	-- how many are there
	local listCount = table.getn(ifs_meta_load_listbox_contents)

	-- if there are zero games
	if(listCount < 1) then
		this.bNoGames = 1

		-- hide the delete button
		IFObj_fnSetVis(this.Helptext_Delete,nil)
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
		for i = 1,table.getn(ifs_meta_load_listbox_contents) do
			if(ifs_meta_load_listbox_contents[i].isCurrent) then
				curGame = i
			end
		end
		
		-- cursor on the current (or first if no current)
		ifs_meta_load_listbox_layout.FirstShownIdx = curGame
		ifs_meta_load_listbox_layout.SelectedIdx = curGame
		ifs_meta_load_listbox_layout.CursorIdx = curGame

		-- show delete?
		if(gPlatformStr ~= "PC") then
			IFObj_fnSetVis(this.Helptext_Delete, this.Mode=="Save" and ifs_meta_load_listbox_layout.CursorIdx>1)
		end
		
		-- hide the "no games available" text
		IFObj_fnSetVis(this.nogames,nil)
	end
	
	-- fill the listbox
	ListManager_fnFillContents(this.listbox,ifs_meta_load_listbox_contents,ifs_meta_load_listbox_layout)

end

----------------------------------------------------------------------------------------
-- load the profile list.  this is just the preop, since that refreshes the file list.
----------------------------------------------------------------------------------------

function ifs_meta_load_StartLoadFileList()
	ifs_saveop.doOp = "LoadFileList"
	ifs_saveop.OnSuccess = ifs_meta_load_LoadFileListSuccess
	ifs_saveop.OnCancel = ifs_meta_load_LoadFileListCancel
	ifs_saveop.ForceSaveFailedMessage = (ifs_meta_load.Mode == "Save")
	ifs_movietrans_PushScreen(ifs_saveop);
end

function ifs_meta_load_LoadFileListSuccess()
	-- good, continue
	print("ifs_meta_load_LoadFileListSuccess")
	
	-- don't reload when we get back to ifs_meta_load.Enter	
	ifs_meta_load.bFromLoadFileList = 1
	-- pop ifs_saveop, reenter ifs_meta_load	
	ScriptCB_PopScreen()	
end

function ifs_meta_load_LoadFileListCancel()
	-- ok, continue
	print("ifs_meta_load_LoadFileListCancel")
	
	-- skip forward to the file list screen anyway	
	-- don't reload when we get back to ifs_meta_load.Enter	
	ifs_meta_load.bFromLoadFileList = 1
	-- pop ifs_saveop, reenter ifs_meta_load	
	ScriptCB_PopScreen()	
	
end

----------------------------------------------------------------------------------------
-- load selected metagame
----------------------------------------------------------------------------------------

function ifs_meta_load_StartLoadMetagame(name1)
	print("ifs_meta_load_StartLoadMetagame")
	ifs_saveop.doOp = "LoadMetagame"
	ifs_saveop.OnSuccess = ifs_meta_load_LoadMetagameSuccess
	ifs_saveop.OnCancel = ifs_meta_load_LoadMetagameCancel
	ifs_saveop.metagame1 = name1
    ifs_movietrans_PushScreen(ifs_saveop)
end

function ifs_meta_load_LoadMetagameSuccess()
	print("ifs_meta_load_LoadMetagameSuccess")
	local this = ifs_meta_load
	
	-- don't prompt a save when we get into the metagame, since we just loaded
	ifs_meta_main.NoPromptSave = 1
	this.bFromLoadDelete = 1
	-- 
    ifs_movietrans_PushScreen(ifs_meta_top);
end

function ifs_meta_load_LoadMetagameCancel()
	print("ifs_meta_load_LoadMetagameCancel")
	local this = ifs_meta_load
	-- error, should go back to the LoadFileList state	
	
	this.bFromLoadDelete = 1
	-- bail from ifs_saveop
	ScriptCB_PopScreen()
end

----------------------------------------------------------------------------------------
-- entry prompt for saving
----------------------------------------------------------------------------------------

function ifs_meta_load_StartPromptSave()
	print("ifs_meta_load_StartPromptSave")
	local this = ifs_meta_load
	
	-- hide this screen
	ifs_meta_load_SetVis(this,nil)
	
	-- set the button text
	IFText_fnSetString(Popup_LoadSave2.buttons.A.label,ifs_saveop.PlatformBaseStr .. ".save")
	IFText_fnSetString(Popup_LoadSave2.buttons.B.label,ifs_saveop.PlatformBaseStr .. ".continuenosave")
	IFText_fnSetString(Popup_LoadSave2.buttons.C.label," ")
	-- set the button visiblity
	Popup_LoadSave2:fnActivate(1)
	-- set the load/save title text
	IFObj_fnSetVis(Popup_LoadSave2.buttons.A.label,1)	
	IFObj_fnSetVis(Popup_LoadSave2.buttons.B.label,1)	
	IFObj_fnSetVis(Popup_LoadSave2.buttons.C.label,nil)	
	Popup_LoadSave2_ResizeButtons()
	gPopup_fnSetTitleStr(Popup_LoadSave2, "ifs.meta.load.confirm_save")	
	Popup_LoadSave2_SelectButton(1)
	IFObj_fnSetVis(Popup_LoadSave2,1)

	Popup_LoadSave2.fnAccept = ifs_meta_load_SavePromptAccept	
end

function ifs_meta_load_SavePromptAccept(fRet)
	local this = ifs_meta_load

	-- show this screen
	ifs_meta_load_SetVis(this,1)
	
	Popup_LoadSave2.fnAccept = nil
	Popup_LoadSave2:fnActivate(nil)
	
	-- accept input from all
	if(ifs_saveop and ifs_saveop.saveProfileNum) then
		ScriptCB_ReadAllControllers(1)
	end

	if(fRet < 1.5) then
		print("ifs_meta_load_SavePromptAccept(A - Save)")
        ifelm_shellscreen_fnPlaySound(this.acceptSound)
		-- yes, save, so continue
		this.bPromptSave = nil
		
		-- reenter, but don't prompt again
		this.NoPromptSave = 1
		this.Enter(this,1)
	else
		print("ifs_meta_load_SavePromptAccept(B - Continue wihtout saving)")
		-- no, don't save.  pop this screen and continue
        ifelm_shellscreen_fnPlaySound(this.cancelSound)
		-- call the exit func
		if(ifs_meta_load.ExitFunc) then
			print("ifs_meta_load.ExitFunc()")
			ifs_meta_load.ExitFunc()
			ifs_meta_load.ExitFunc = nil
		end		
		--pop it
		ScriptCB_PopScreen()
	end	
end

----------------------------------------------------------------------------------------
-- save the current metagame into the slot selected
----------------------------------------------------------------------------------------

function ifs_meta_load_StartSaveMetagame(aFilename)
	print("ifs_meta_load_StartSaveMetagame(",aFilename,")")
	
	ifs_saveop.doOp = "SaveMetagame"
	ifs_saveop.OnSuccess = ifs_meta_load_SaveMetagameSuccess
	ifs_saveop.OnCancel = ifs_meta_load_SaveMetagameCancel
	ifs_saveop.metagame1 = aFilename
	-- we handled this part here
	ifs_saveop.NoPromptSave = 1
    ifs_movietrans_PushScreen(ifs_saveop)
end

function ifs_meta_load_SaveMetagameSuccess()
	print("ifs_meta_load_SaveMetagameSuccess")
	-- pop ifs_saveop
	ifs_meta_load.PopOnEnter = 1
	ScriptCB_PopScreen()
end

function ifs_meta_load_SaveMetagameCancel()
	print("ifs_meta_load_SaveMetagameCancel")
	-- do nothing when we reenter ifs_meta_load
	ifs_meta_load.bFromSaveCancel = 1
	-- bail from ifs_saveop
	ScriptCB_PopScreen()
	-- don't pop to metagame, since we might want to try again
end

----------------------------------------------------------------------------------------
-- delete a metagame
----------------------------------------------------------------------------------------

function ifs_meta_load_fnDeletePopupDone(bResult)
	local this = ifs_meta_load
	
	-- accept input from all
	if(ifs_saveop and ifs_saveop.saveProfileNum) then
		ScriptCB_ReadAllControllers(1)
	end
	
	if(bResult) then
		print("ifs_meta_load_fnDeletePopupDone(true)")
		ifs_meta_load_SetVis(this, 1)

        ifelm_shellscreen_fnPlaySound(this.acceptSound)
		-- User does want to delete
		local Selection = ifs_meta_load_listbox_contents[ifs_meta_load_listbox_layout.SelectedIdx]
		print("idx = ",ifs_meta_load_listbox_layout.SelectedIdx)
		
		ifs_saveop.doOp = "DeleteMetagame"
		ifs_saveop.OnSuccess = ifs_meta_load_DeleteMetagameSuccess
		ifs_saveop.OnCancel = ifs_meta_load_DeleteMetagameCancel
		ifs_saveop.metagame1 = Selection.filename
		ifs_movietrans_PushScreen(ifs_saveop)
		
	else
        ifelm_shellscreen_fnPlaySound(this.cancelSound)
		print("ifs_meta_load_fnDeletePopupDone(false)")
		-- User hit no. Back to normal screen
		ifs_meta_load_SetVis(this, 1)
	end
end

function ifs_meta_load_DeleteMetagameSuccess()
	print("ifs_meta_load_DeleteMetagameSuccess")
	local this = ifs_meta_load
	
	this.bFromLoadDelete = 1
	ScriptCB_PopScreen()
end

function ifs_meta_load_DeleteMetagameCancel()
	print("ifs_meta_load_DeleteMetagameCancel")
	local this = ifs_meta_load
	
	this.bFromLoadDelete = 1
	this.bFromDeleteCancel = 1
	-- bail from ifs_saveop
	ScriptCB_PopScreen()
end


----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

ifs_meta_load = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = "shell_sub_left", -- WAS "ifs_sp",

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
		rotY = 30,
	},


	buttons = NewIFContainer {
		ScreenRelativeX = 0, -- center
		ScreenRelativeY = 0, -- top
		-- y = 80,
	},


	Helptext_Delete = NewHelptext {
		ScreenRelativeX = 1.0, -- Left of center, but not in the normal 'back' position
		ScreenRelativeY = 1.0, -- bot
		y = -40,
		x = 0,
		buttonicon = "btnmisc",
		string = "ifs.profile.delete",
	},

	Enter = function(this, bFwd)
		print("ifs_meta_load.Enter(",bFwd,")")
		gIFShellScreenTemplate_fnEnter(this, bFwd)

		if(gPlatformStr == "PC") then			
			IFObj_fnSetVis( this.Helptext_Delete.icon, nil )
			IFObj_fnSetVis( this.Helptext_Delete, nil )
		end
		
		-- accept input from all
		ifs_saveop.saveProfileNum = ScriptCB_GetQuitPlayer()
		if(ifs_saveop and ifs_saveop.saveProfileNum) then
			ScriptCB_ReadAllControllers(1)
		end
		
		if(this.PopOnEnter) then
			print("ifs_meta_load.PopOnEnter")
			this.PopOnEnter = nil
			-- call the exit func
			if(ifs_meta_load.ExitFunc) then
				print("ifs_meta_load.ExitFunc()")
				ifs_meta_load.ExitFunc()
				ifs_meta_load.ExitFunc = nil
			end
			-- pop ifs_meta_load, return to metagame
			ScriptCB_PopScreen()
			return
		end
		
		--if you back into this screen (and its not from saveop), keep going
		if(not bFwd and (not this.bFromLoadFileList and not this.bFromLoadDelete and not this.bFromSaveCancel)) then
			ScriptCB_PopScreen()
			return
		end

		-- right align the delete button		
		gHelptext_fnMoveIcon(this.Helptext_Delete)	
		-- hide the no games text	
		IFObj_fnSetVis(this.nogames,nil)
		

		-- setup things according to the current mode		
		if(this.Mode == "Load") then
			print("ifs_meta_load.Enter Load")
			-- set the orange title bar text
			gButtonWindow_fnSetText(this.listbox,"ifs.meta.load.load")
			-- set the accept button text
			if( this.Helptext_Accept ) then
				IFText_fnSetString(this.Helptext_Accept.helpstr,"ifs.meta.load.btnload")
			end
			
		elseif(this.Mode == "Save") then
			print("ifs_meta_load.Enter Save")
			
			-- if this is the first time entering, prompt for "do you want to save yes/no?"
			if((not this.NoPromptSave) and (not this.bFromLoadFileList and not this.bFromLoadDelete and not this.bFromSaveCancel)) then
				ifs_meta_load_StartPromptSave()
				return
			end
			this.NoPromptSave = nil
			
			-- set the orange title bar text
			gButtonWindow_fnSetText(this.listbox,"ifs.meta.load.save")
			-- set the accept button text
			if( this.Helptext_Accept ) then
				IFText_fnSetString(this.Helptext_Accept.helpstr,"ifs.meta.load.btnsave")
			end
			
			
		else
			print("ifs_meta_load.Mode not set (either Load or Save)")
			assert(ifs_meta_load.Mode == "Load" or ifs_meta_load.Mode == "Save")
		end


		if(bFwd or this.bFromDeleteCancel) then
			this.bFromDeleteCancel = nil
			-- load the list of saved games?
			if(not this.bFromLoadFileList) then
				ifs_meta_load_StartLoadFileList()
			end
			this.bFromLoadFileList = nil
		else
			ifs_meta_load_fnGetSavedGameList(ifs_meta_load)		
		end
		
	end,

 	Exit = function(this, bFwd)
		-- no input for you
		if(ifs_saveop and ifs_saveop.saveProfileNum) then
			ScriptCB_ReadAllControllers(nil)
		end
 	
 		ifs_meta_load_listbox_contents = nil
 		this.bFromLoadFileList = nil
 		this.bFromLoadDelete = nil
 		this.bFromSaveCancel = nil
	end,

	Input_GeneralUp = function(this,iJoystick)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputUp(this)) then
			return
		end

		if(ifs_saveop.saveProfileNum and ifs_saveop.saveProfileNum~=iJoystick+1) then
			print("Input_GeneralUp on wrong joystick num.  got",iJoystick+1,"want",ifs_saveop.saveProfileNum)
		else
			if(gPlatformStr ~= "PC") then
				ListManager_fnNavUp(this.listbox,ifs_meta_load_listbox_contents,ifs_meta_load_listbox_layout)
				
				-- if we're on the top item in save mode, disable the delete button
				if(table.getn(ifs_meta_load_listbox_contents)>0) then
					IFObj_fnSetVis(this.Helptext_Delete, this.Mode=="Save" and ifs_meta_load_listbox_layout.CursorIdx>1)
				end
			end
		end
	end,

	Input_LTrigger = function(this,iJoystick)
		if(ifs_saveop.saveProfileNum and ifs_saveop.saveProfileNum~=iJoystick+1) then
			print("Input_LTrigger on wrong joystick num.  got",iJoystick+1,"want",ifs_saveop.saveProfileNum)
		else
			ListManager_fnPageUp(this.listbox,ifs_meta_load_listbox_contents,ifs_meta_load_listbox_layout)

			-- if we're on the top item in save mode, disable the delete button
			if(table.getn(ifs_meta_load_listbox_contents)>0) then
				IFObj_fnSetVis(this.Helptext_Delete, this.Mode=="Save" and ifs_meta_load_listbox_layout.CursorIdx>1)
			end
		end
	end,

	Input_GeneralDown = function(this,iJoystick)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputDown(this)) then
			return
		end

		if(ifs_saveop.saveProfileNum and ifs_saveop.saveProfileNum~=iJoystick+1) then
			print("Input_GeneralDown on wrong joystick num.  got",iJoystick+1,"want",ifs_saveop.saveProfileNum)
		else
			if(gPlatformStr ~= "PC") then
				ListManager_fnNavDown(this.listbox,ifs_meta_load_listbox_contents,ifs_meta_load_listbox_layout)
				
				-- if we're on the top item in save mode, disable the delete button
				if(table.getn(ifs_meta_load_listbox_contents)>0) then
					IFObj_fnSetVis(this.Helptext_Delete, this.Mode=="Save" and ifs_meta_load_listbox_layout.CursorIdx>1)
				end
			end
		end
	end,

	Input_RTrigger = function(this,iJoystick)
		if(ifs_saveop.saveProfileNum and ifs_saveop.saveProfileNum~=iJoystick+1) then
			print("Input_RTrigger on wrong joystick num.  got",iJoystick+1,"want",ifs_saveop.saveProfileNum)
		else
			ListManager_fnPageDown(this.listbox,ifs_meta_load_listbox_contents,ifs_meta_load_listbox_layout)

			-- if we're on the top item in save mode, disable the delete button
			if(table.getn(ifs_meta_load_listbox_contents)>0) then
				IFObj_fnSetVis(this.Helptext_Delete, this.Mode=="Save" and ifs_meta_load_listbox_layout.CursorIdx>1)
			end
		end
	end,

	-- Not possible on this screen
	Input_GeneralLeft = function(this)
	end,
	Input_GeneralRight = function(this)
	end,

	Input_Accept = function(this,iJoystick)
		-- If base class handled this work, then we're done
		--if(gShellScreen_fnDefaultInputAccept(this)) then
		--	return
		--end

		if(this.CurButton == "_back") then
			this:Input_Back()
			return
		elseif(this.CurButton == "delete") then
			print("+++this.CurButton = ", this.CurButton)
			ifs_meta_load_DeleteGame(this,iJoystick)
			return			
		end
		
		if(ifs_saveop.saveProfileNum and ifs_saveop.saveProfileNum~=iJoystick+1) then
			print("Input_Accept on wrong joystick num.  got",iJoystick+1,"want",ifs_saveop.saveProfileNum)
		elseif( gMouseListBox ) then
			gMouseListBox.Layout.SelectedIdx = gMouseListBox.Layout.CursorIdx
			ListManager_fnFillContents(gMouseListBox,gMouseListBox.Contents,gMouseListBox.Layout)
		else
			print("+++this.CurButton = ", this.CurButton)
			if( this.CurButton == "accept" ) then
				-- which mode are we in?
				if(this.Mode == "Load") then
					
					-- invalid last battle information
					ifs_meta_main.NoPromptSave = 1
					ifs_saveop.NoPromptSave = 1
					ScriptCB_SetLastBattleVictoryValid(nil)
					
					-- if no games, pop
					if( this.bNoGames ) then
						ScriptCB_PopScreen()
						return
					end
					if(table.getn(ifs_meta_load_listbox_contents) > 0) then
						-- load the meta game data from file
						local Selection = ifs_meta_load_listbox_contents[ifs_meta_load_listbox_layout.SelectedIdx]
						ifelm_shellscreen_fnPlaySound(this.acceptSound)
						ifs_meta_load_StartLoadMetagame(Selection.filename)
					end
					
				elseif(this.Mode == "Save") then
				
					-- which slot did we select, save into that
					local Selection = ifs_meta_load_listbox_contents[ifs_meta_load_listbox_layout.SelectedIdx]
					ifelm_shellscreen_fnPlaySound(this.acceptSound)
					if( Selection ) then
						ifs_meta_load_StartSaveMetagame(Selection.filename)
					end						
				else
					-- error bad mode
					assert(false);
				end
			end
		end
	end,
	
	Input_Back = function(this,iJoystick)
		if(ifs_saveop.saveProfileNum and iJoystick and ifs_saveop.saveProfileNum~=iJoystick+1) then
			print("Input_Back on wrong joystick num.  got",iJoystick+1,"want",ifs_saveop.saveProfileNum)
		else
			print("ifs_meta_load.Input_Back()")

			-- clear all of these
 			this.bFromLoadFileList = nil
 			this.bFromLoadDelete = nil
 			this.bFromSaveCancel = nil		
			
			if(this.Mode == "Save") then
				-- the back button shouldn't pop, just reenter to the "do you want to save yes/no" prompt
				this.Enter(this,1)
			else
				-- in load mode just pop
				ScriptCB_PopScreen()
			end
		end
	end,

	-- delete a saved metagame
	Input_Misc = function(this,iJoystick)
		if(ifs_saveop.saveProfileNum and ifs_saveop.saveProfileNum~=iJoystick+1) then
			print("Input_Misc on wrong joystick num.  got",iJoystick+1,"want",ifs_saveop.saveProfileNum)
		else
			ifs_meta_load_DeleteGame(this,iJoystick) -- call helper function
		end
	end,

}

function ifs_meta_load_DeleteGame(this,iJoystick)
	if(ifs_saveop.saveProfileNum and ifs_saveop.saveProfileNum~=iJoystick+1) then
		print("wrong joystick num.  got",iJoystick+1,"want",ifs_saveop.saveProfileNum)
	else

		-- no delete on load
		if((gPlatformStr == "PC") or (this.Mode == "Save")) then
			if(table.getn(ifs_meta_load_listbox_contents) > 0) then
				-- make sure the selection has a filename (ie. its not "save as new")
				local Selection = ifs_meta_load_listbox_contents[ifs_meta_load_listbox_layout.SelectedIdx]
				if(Selection.filename) then
					ifelm_shellscreen_fnPlaySound("shell_menu_accept")
					Popup_YesNo.CurButton = "no" -- default
					Popup_YesNo.fnDone = ifs_meta_load_fnDeletePopupDone
					ifs_meta_load_SetVis(this,nil)
					Popup_YesNo:fnActivate(1)
					gPopup_fnSetTitleStr(Popup_YesNo, "ifs.meta.load.confirm_delete")
				end
			end
		end
	end
end

function ifs_meta_load_fnBuildScreen(this)
	local w,h = ScriptCB_GetSafeScreenInfo()
	w = w * 1.15 -- wider than the screen, but rotation shrinks this.

	if(gPlatformStr ~= "PC") then
		h = h * 0.82
	end

	local listWidth = w * 0.9
	this.listbox = NewButtonWindow { 
		ZPos = 200, x=50, y = 52,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.4, -- middle of screen
		width = listWidth,
		height = ifs_meta_load_listbox_layout.showcount * (ifs_meta_load_listbox_layout.yHeight + ifs_meta_load_listbox_layout.ySpacing) + 30,
		rotY = 30,
		titleText = "ifs.meta.load.load"
	}
	ifs_meta_load_listbox_layout.width = listWidth - 40
	ifs_meta_load_listbox_layout.x = 0

	ListManager_fnInitList(this.listbox,ifs_meta_load_listbox_layout)
	
	if(gPlatformStr == "PC") then
		this.buttons.delete = NewClickableIFButton 
		{ 
			x = w * 0.45,
			y = h - 15,
			btnw = w*.1, 
			btnh = ScriptCB_GetFontHeight("gamefont_large"),
			--font = "gamefont_large", 
			bg_width = w*.1,
			nocreatebackground=1,
		}
		this.buttons.delete.label.bHotspot = 1
		this.buttons.delete.label.fHotspotW = this.buttons.delete.btnw
		this.buttons.delete.label.fHotspotH = this.buttons.delete.btnh
		this.buttons.delete.tag = "delete"
		RoundIFButtonLabel_fnSetString(this.buttons.delete ,"ifs.profile.delete")

		this.buttons.accept = NewClickableIFButton 
		{ 
			x = w * 0.85,
			y = h - 15,
			btnw = w*.2, 
			btnh = ScriptCB_GetFontHeight("gamefont_large"),
			--font = "gamefont_large", 
			bg_width = w*.1,
			nocreatebackground=1,
		}
		this.buttons.accept.label.bHotspot = 1
		this.buttons.accept.label.fHotspotW = this.buttons.accept.btnw
		this.buttons.accept.label.fHotspotH = this.buttons.accept.btnh
		this.buttons.accept.tag = "accept"
		RoundIFButtonLabel_fnSetString(this.buttons.accept ,"common.accept")
	end -- PC buttons
	
end


ifs_meta_load_fnBuildScreen(ifs_meta_load)
ifs_meta_load_fnBuildScreen = nil
AddIFScreen(ifs_meta_load,"ifs_meta_load")
