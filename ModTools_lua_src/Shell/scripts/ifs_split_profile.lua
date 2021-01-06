--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Internal mode definitions for this screen, stored in this.Mode[i]
-- 
-- -1: "loading profile list" - everything hidden
-- 0: 'Press Start' mode
-- 1: In listbox at left (profile)
-- 2: Ready
-- ** UNUSED ** 3: On team(side) select buttons at right
-- 4: load profiles popup is active, so hide everything

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_split_profile_listbox_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { 
		x = layout.x - 0.5 * layout.width, 
		y = layout.y - 10,
	}
	Temp.NameStr = NewIFText{
		x = 10, y = 0, 
		halign = "left", font = "gamefont_medium", 
		textw = 220, nocreatebackground=1, 
		startdelay=math.random()*0.5, 
	}
	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ifs_split_profile_listbox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
	if(Data) then
		-- Blank the data
		IFText_fnSetUString(Dest.NameStr,Data.showstr)
		if(Data.bDim) then
			IFObj_fnSetColor(Dest.NameStr,128,128,128)
		else
			IFObj_fnSetColor(Dest.NameStr, iColorR, iColorG, iColorB)
			IFObj_fnSetAlpha(Dest.NameStr, fAlpha)
		end
	else
		-- Blank the data
		IFText_fnSetString(Dest.NameStr,"")
	end

	IFObj_fnSetVis(Dest.NameStr, Data)
end


ifs_split_profile_listbox_contents = {
}

-- Duplicated layout items, as the selected item in each listbox will
-- be placed in it.
ifs_split_profile_listbox_layout = {
	{
		showcount = 4,
		yHeight = 26, -- per item
		ySpacing = 0,
--		width = ifs_login_listbox_layout.width, -- set in fnBuildScreen
		slider = 1,
		CreateFn = ifs_split_profile_listbox_CreateItem,
		PopulateFn = ifs_split_profile_listbox_PopulateItem,
	},
	{
		showcount = 4,
		yHeight = 26, -- per item
		ySpacing = 0,
--		width = ifs_login_listbox_layout.width, -- set in fnBuildScreen
		slider = 1,
		bInstance2 = 1, -- Use alternate cursor hilight object
		CreateFn = ifs_split_profile_listbox_CreateItem,
		PopulateFn = ifs_split_profile_listbox_PopulateItem,
	},
	{
		showcount = 4,
		yHeight = 26, -- per item
		ySpacing = 0,
		slider = 1,
--		width = ifs_login_listbox_layout.width, -- set in fnBuildScreen
		bInstance3 = 1, -- Use alternate cursor hilight object
		CreateFn = ifs_split_profile_listbox_CreateItem,
		PopulateFn = ifs_split_profile_listbox_PopulateItem,
	},
	{
		showcount = 4,
		yHeight = 26, -- per item
		ySpacing = 0,
		slider = 1,
		bInstance4 = 1, -- Use alternate cursor hilight object
--		width = ifs_login_listbox_layout.width, -- set in fnBuildScreen
		CreateFn = ifs_split_profile_listbox_CreateItem,
		PopulateFn = ifs_split_profile_listbox_PopulateItem,
	}
} -- ifs_split_profile_listbox_layout

-- Helper function. For the given player idx, turns on/off the bDim
-- attribute in the ifs_split_profile_listbox_contents[] array.
function ifs_split_profile_fnCalcDim(this, aIdx)
	local j

	for j=1,table.getn(ifs_split_profile_listbox_contents) do
		ifs_split_profile_listbox_contents[j].bDim = nil
	end
	-- Now, dim out everything that's locked out
	for j=1,this.iMaxControllers do
		local selIdx = ifs_split_profile_listbox_layout[j].SelectedIdx
		if((j ~= aIdx) and (this.Mode[j] >= 2) and selIdx) then
--			print("For ",aIdx, "Dimming idx ", selIdx)
			ifs_split_profile_listbox_contents[selIdx].bDim = 1
		end
	end
end

-- Helper function: calculates if we could launch with the current setup.
-- Returns a bool.
function ifs_split_profile_fnOkToLaunch(this)
	local i
	local bAllReady = 1
	local iNumReady = 0
	for i=1,this.iMaxControllers do
		if(this.Mode[i] == 2) then
			iNumReady = iNumReady + 1
		end
		
		bAllReady = bAllReady and ((this.Mode[i] == 0) or (this.Mode[i] == 2))
	end
	
	if (ifs_main.CurButton == "mp") then
		-- multi player game
		-- it's ok if only one player
		bAllReady = bAllReady and (iNumReady >= 1)
	else
		-- single player game
		bAllReady = bAllReady and (iNumReady > 1) -- must have multiple ready to launch
	end
	
	return bAllReady, iNumReady
end


-- Helper function: turns pieces on/off, updates text, etc.
function ifs_split_profile_fnUpdateScreen(this)
	local i,j

-- 	if(this.iMaxControllers == 2) then
-- 		print("UpdateScreen. Mode[]s =", this.Mode[1], this.Mode[2]) 
-- 		print(" Selected =", ifs_split_profile_listbox_layout[1].SelectedIdx,
-- 					ifs_split_profile_listbox_layout[2].SelectedIdx) 
-- 	else
-- 		print("UpdateScreen. Mode[]s =", this.Mode[1], this.Mode[2], this.Mode[3], this.Mode[4])
-- 		print(" Selected =", ifs_split_profile_listbox_layout[1].SelectedIdx,
-- 					ifs_split_profile_listbox_layout[2].SelectedIdx,
-- 					ifs_split_profile_listbox_layout[3].SelectedIdx,
-- 					ifs_split_profile_listbox_layout[4].SelectedIdx) 
-- 	end

	if(ScriptCB_IsPopupOpen()) then
		-- Hide most of this screen
		for i=1,this.iMaxControllers do
			IFObj_fnSetVis(this.ProfileName[i], nil)
			IFObj_fnSetVis(this.Message[i], nil)
			IFObj_fnSetVis(this.Profile[i], nil)
			IFObj_fnSetVis(this.pressstart[i], nil)
			IFObj_fnSetVis(this.BackGroup[i], i == this.iMaxControllers)
			IFObj_fnSetVis(this.AcceptGroup[i], i == this.iMaxControllers)
		end
		IFObj_fnSetVis(this.horizline, nil)
		return
	end
	IFObj_fnSetVis(this.horizline, 1)

	local bAllReady = 1
	for i=1,this.iMaxControllers do
		bAllReady = bAllReady and (this.Mode[i] == 2) -- keep track of this

		-- 'Back' button is always hidden if loading things.
		if(this.Mode[1] == -1 or this.Mode[1] == 4) then
			IFObj_fnSetVis(this.BackGroup[i],nil)
		else
			IFObj_fnSetVis(this.BackGroup[i],this.Mode[i] >= 1)
		end

		IFObj_fnSetVis(this.ProfileName[i],this.Mode[i] >= 2)
		if(this.Mode[i] >= 2) then
			IFText_fnSetUString(this.ProfileName[i], ifs_split_profile_listbox_contents[ifs_split_profile_listbox_layout[i].SelectedIdx].showstr)
		end

		IFObj_fnSetVis(this.AcceptGroup[i],this.Mode[i] == 1)
		-- Turn 'Accept' text for primary player when all players are ready
		if((this.Mode[i] >= 2) and (i == this.iPrimaryPort) and ifs_split_profile_fnOkToLaunch(this)) then
			IFObj_fnSetVis(this.AcceptGroup[i],1)
		end

		-- Message text shows in modes 0(Press Start), 2(Ready). Change text as needed.
		IFObj_fnSetVis(this.Message[i],(this.Mode[i] == 0) or (this.Mode[i] == 2))
		if (this.Mode[i] == 0) then
			IFText_fnSetString(this.Message[i],"ifs.split.starttojoin")
		else
			IFText_fnSetString(this.Message[i],"ifs.split.ready")
		end

		-- But, if # of controllers is too low, override the message.
		if(not ScriptCB_IsControllerConnected(i)) then
			if(gPlatformStr == "PS2") then
				local PortUStr = ScriptCB_tounicode(string.format("%d",ScriptCB_GetUnusedControllerPort()))
				local ShowUStr = ScriptCB_usprintf("ifs.split.insertcontrollerport", PortUStr)
				IFText_fnSetUString(this.Message[i],ShowUStr)
			else
				IFText_fnSetString(this.Message[i],"ifs.split.needs2controllers")
			end
		end


		-- Profile box shows when in mode 1(Listbox)
		IFObj_fnSetVis(this.Profile[i],(this.Mode[i] == 1))

		-- Fill in listboxes as well
		if(this.Mode[i] == 1) then
			ifs_split_profile_fnCalcDim(this, i)

			ListManager_fnFillContents(this.Profile[i].listbox,ifs_split_profile_listbox_contents,ifs_split_profile_listbox_layout[i]) -- sets selected listbox item
		else
--			gCurHiliteListbox[i] = nil
		end

		if(i == this.iPrimaryPort) then
			IFObj_fnSetVis(this.pressstart[i], ifs_split_profile_fnOkToLaunch(this))
		else
			IFObj_fnSetVis(this.pressstart[i], nil) -- everyone else hides this
		end
	end


end

-- called when we're done loading the file list form the SaveDevice
function ifs_split_profile_fnLoadFileListDone(this)
	this.EverLoaded = 1
	--Popup_LoadSave:fnActivate(nil)
	ifs_split_profile_fnUpdateScreen(this, 1)
	-- reenter this screen
	this.Enter(this,1)
end

function ifs_split_profile_fnEnsureUniqueSelections(this)
	-- Reset listbox, show it. [Remember, Lua starts at 1!]
	local MaxCount = ScriptCB_GetLoginList("ifs_split_profile_listbox_contents", 1)
	local ListCount = table.getn(ifs_split_profile_listbox_contents)
	
	if(not ListCount) then
--		print("ERROR: not ListCount")
		assert(false)
	end
	
	-- Ensure everyone has a unique set of selected indices
	local i,j,bDone
	for i=1,this.iMaxControllers do
		ifs_split_profile_listbox_layout[i].FirstShownIdx = 1 -- top
		if(this.Mode[i] < 2) then
			ifs_split_profile_listbox_layout[i].SelectedIdx = math.max(1,ifs_split_profile_listbox_layout[i].SelectedIdx or 1)
		end
	end

 	if(ListCount < this.iMaxControllers) then
-- 		print("ERROR: ScriptCB_GetLoginList returned not enough profiles in splitscreen")
-- 		assert(false)
		ifs_split_profile_fnUpdateScreen(this)
		return
 	end


	repeat
		bDone = 1 -- assume so

		for i=1,this.iMaxControllers do
			for j=i+1,this.iMaxControllers do
				if(ifs_split_profile_listbox_layout[i].SelectedIdx == ifs_split_profile_listbox_layout[j].SelectedIdx) then

					local ChangeIdx = j
					-- If j is locked, but i isn't, then move i instead
					if(this.Mode[j] >= 2) then
						if(this.Mode[i] < 2) then
							ChangeIdx = i
						end
					end

					ifs_split_profile_listbox_layout[ChangeIdx].SelectedIdx = ifs_split_profile_listbox_layout[ChangeIdx].SelectedIdx + 1
					if(ifs_split_profile_listbox_layout[ChangeIdx].SelectedIdx > ListCount) then
						ifs_split_profile_listbox_layout[ChangeIdx].SelectedIdx = 1 -- wrap around
					end
					bDone = nil
				end
			end -- j loop
		end -- i loop

	until bDone

--	print(" Selected =", ifs_split_profile_listbox_layout[1].SelectedIdx,
--				ifs_split_profile_listbox_layout[2].SelectedIdx) 

	ifs_split_profile_fnUpdateScreen(this)
end

----------------------------------------------------------------------------------------
-- load the profile list.  this is just the preop, since that refreshes the file list.
----------------------------------------------------------------------------------------

function ifs_split_profile_StartLoadFileList()
	ifs_saveop.doOp = "LoadFileList"
	ifs_saveop.OnSuccess = ifs_split_profile_LoadFileListSuccess
	ifs_saveop.OnCancel = ifs_split_profile_LoadFileListCancel
	ifs_movietrans_PushScreen(ifs_saveop);
end

function ifs_split_profile_LoadFileListSuccess()
	-- good, continue
--	print("ifs_split_profile_LoadFileListSuccess")
	
	-- don't reload when we get back to ifs_split_load.Enter	
	ifs_split_profile.bFromLoadFileList = 1
	-- pop ifs_saveop, reenter ifs_split_profile	
	ScriptCB_PopScreen()	
end

function ifs_split_profile_LoadFileListCancel()
	-- ok, continue
--	print("ifs_split_profile_LoadFileListCancel")
	
	-- skip forward to the file list screen anyway	
	-- don't reload when we get back to ifs_split_load.Enter	
	ifs_split_profile.bFromLoadFileList = 1
	-- pop ifs_saveop, reenter ifs_split_profile	
	ScriptCB_PopScreen()	
	
end

----------------------------------------------------------------------------------------
-- load two profiles
----------------------------------------------------------------------------------------

function ifs_split_profile_StartLoadProfile(profile1,profile2,profile3,profile4)
--	print("ifs_split_profile_StartLoadProfile")
	
	-- if both profiles are nil, skip it
	if((not profile1) and (not profile2) and (not profile3) and (not profile4)) then
		ifs_split_profile_LoadProfileSuccess()
		return
	end
	
--	print("ifs_split_profile_StartLoadProfile SaveDevice")
	ifs_saveop.doOp = "LoadProfile"
	ifs_saveop.OnSuccess = ifs_split_profile_LoadProfileSuccess
	ifs_saveop.OnCancel = ifs_split_profile_LoadProfileCancel
	ifs_saveop.profile1 = profile1
	ifs_saveop.profile2 = profile2
	ifs_saveop.profile3 = profile3
	ifs_saveop.profile4 = profile4
	ifs_movietrans_PushScreen(ifs_saveop)
	
end

function ifs_split_profile_LoadProfileSuccess()
--	print("ifs_split_profile_LoadProfileSuccess")
	local this = ifs_split_profile
	-- ok
	
	if(gDemoBuild) then
		gPickedMapList = {} -- zap maplist
		local Idx = 1
		gPickedMapList[Idx] = {
			Map = "tan1g_ctf",
			dnldable = nil,
			mapluafile = "tan1g_c",
			Side = 1,
			SideChar = "g",
		}
		
		ScriptCB_SetCanSwitchSides(1)
		ScriptCB_SetMissionNames(gPickedMapList,this.bRandomOrder)
		ScriptCB_EnterMission()
	else
		ifs_missionselect.bForMP = nil
		-- keep the splitscreen background active
		if( ifs_main.CurButton == "mp" ) then
			-- multi player game
			if(gPlatformStr == "PS2") then
				ScriptCB_PushScreen("ifs_mp")
			elseif( gOnlineServiceStr == "XLive" ) then
				ifs_movietrans_PushScreen(ifs_mpxl_login)
			else			
				ScriptCB_PushScreen("ifs_mp_main")
			end
		else
			-- single player game

			-- don't want movie transitions to the single player screen
			gMovieDisabled = 1
			ScriptCB_PushScreen("ifs_sp")
		end
	end
end

function ifs_split_profile_LoadProfileCancel()
--	print("ifs_split_profile_LoadProfileCancel L405")
	local this = ifs_split_profile
	-- error, should go back to the LoadFileList state	
	this.bReturnToLoadFileList = 1
	
	local i
	for i=1,this.iMaxControllers do
--		print("Mode[",i,"] =", this.Mode[i])
		if((i ~= this.iPrimaryPort) and ((this.Mode[i] == 2) or (this.Mode[i] == 4))) then
--			print("Setting mode[",i,"] to ", 1)
			this.Mode[i] = 1 -- back to file list
		end
	end

	-- bail from ifs_saveop
	ScriptCB_PopScreen()
	
	ifs_split_profile_fnUpdateScreen(this, 1)
	--ifs_split_profile_fnEnsureUniqueSelections(this)
	
end

----------------------------------------------------------------------------------------
-- the ok from when you enter without enough profiles.
----------------------------------------------------------------------------------------
--function ifs_split_profile_NotEnoughProfilesOk()
--	-- pop it
--	ScriptCB_PopScreen()
--end


----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

function ifs_split_profile_fnLoginNotFound()
	local this = ifs_split_profile
	ScriptCB_PopScreen()
end


ifs_split_profile = NewIFShellScreen {
	nologo = 1,
	bNohelptext = 1, -- We do our own on this screen.
	movieIntro      = nil, -- WAS "ifs_split_profile_intro",
	movieBackground = "shell_sub_left", -- WAS "ifs_split_profile",

	fnLoadFileListDone = ifs_split_profile_fnLoadFileListDone,

	title = NewIFText {
		string = "", --ifs.profile.title",
		font = "gamefont_large",
		textw = 460,
		y = -5,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0, -- top
		inert = 1,
		nocreatebackground=1,		
	},

	Message = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
	},

	ProfileName = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
	},

	pressstart = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
	},

	BackGroup = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
	},

	AcceptGroup = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
	},

	Profile = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
	},

	Enter = function(this, bFwd)
--		print("ifs_split_profile.Enter(",bFwd,")")		
						
		gIFShellScreenTemplate_fnEnter(this, bFwd)

		this.Mode = this.Mode or {} -- create if not present.
		local i

		this.iPrimaryPort = ScriptCB_GetPrimaryController() + 1
--		print("line 472, this.iPrimaryPort = ", this.iPrimaryPort)

		-- Rearrange icon positions, as necessary
		for i=1,this.iMaxControllers do
			gHelptext_fnMoveIcon(this.AcceptGroup[i])
		end
		
		-- Added chunk for error handling...
		if(not bFwd) then
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
			if(ErrorLevel >= 6) then -- session or login error, must keep going further
				ScriptCB_PopScreen()
			end
		end

		-- if we've just loaded the file list, finish the enter
		if(this.bFromLoadFileList) then
--			print("ifs_split_profile.bFromLoadFileList")
			this.bFromLoadFileList = nil			

			-- Set state so that first person has hit start. Rest are waiting to do that.
			for i=1,this.iMaxControllers do
				if(i == this.iPrimaryPort) then
					this.Mode[this.iPrimaryPort] = 2
				else
					this.Mode[i] = 0
					ScriptCB_UnbindController(i)
				end
			end

			local MaxCount = ScriptCB_GetLoginList("ifs_split_profile_listbox_contents", 1)
			
			-- Primary player inherits currently logged in profile
--			print("line 502, this.iPrimaryPort = ", this.iPrimaryPort)
			ifs_split_profile_listbox_layout[this.iPrimaryPort].SelectedIdx = 1
			ifs_split_profile_listbox_layout[this.iPrimaryPort].CursorIdx = 1

			local LoginUStr = ScriptCB_GetCurrentProfileName()
			local NumProfiles = table.getn(ifs_split_profile_listbox_contents)
			local bProfileMatch

			-- Determine if any profiles exist on the memcard
			local bAnyOnCard
			for i=1,NumProfiles do
				if(ifs_split_profile_listbox_contents[i].memslot == 0) then
					bAnyOnCard = 1
				end
			end

--			print("bAnyOnCard = ", bAnyOnCard)
			for i=1,NumProfiles do
				if(ifs_split_profile_listbox_contents[i].showstr == LoginUStr) then

					-- Removed NM 6/30/05 - not bAnyOnCard would break if
					-- Memcard has "Player 1" (memslot 0), and "Player 2" is unsaved
					-- and in memory (memslot 1). Need to proceed if that's the case
					--						 (not bAnyOnCard and ifs_split_profile_listbox_contents[i].memslot == 1)) then

					if((ifs_split_profile_listbox_contents[i].memslot == 0) or
						 (ifs_split_profile_listbox_contents[i].memslot == 1)) then
						bProfileMatch = 1
					end
--					print("Profile match on ", i, ScriptCB_ununicode(ifs_split_profile_listbox_contents[i].showstr), ScriptCB_ununicode(LoginUStr), "memslot = ", ifs_split_profile_listbox_contents[i].memslot)
					ifs_split_profile_listbox_layout[this.iPrimaryPort].SelectedIdx = i
					ifs_split_profile_listbox_layout[this.iPrimaryPort].CursorIdx = i
				else
--					print(" Profile miss on ", i)
				end
			end

			if(not bProfileMatch) then
				Popup_Ok_Large.fnDone = ifs_split_profile_fnLoginNotFound
				local DisplayUStr = ScriptCB_usprintf("ifs.loadsave_ps2.save40", LoginUStr)
				Popup_Ok_Large:fnActivate(1)
				gPopup_fnSetTitleUStr(Popup_Ok_Large, DisplayUStr)

				-- Hide most of this screen
				for i=1,this.iMaxControllers do
					IFObj_fnSetVis(this.ProfileName[i], nil)
					IFObj_fnSetVis(this.Message[i], nil)
					IFObj_fnSetVis(this.Profile[i], nil)
					IFObj_fnSetVis(this.pressstart[i], nil)
				end
				return
			end

			-- fill in the listbox
			ifs_split_profile_fnEnsureUniqueSelections(this)
			
			-- otherwise start it
		elseif (bFwd or this.bReturnToLoadFileList) then
			this.bReturnToLoadFileList = nil
--			print("bFwd or bReturnToLoadFileList")
			ifs_split_profile_StartLoadFileList()
			return
		else
			-- Backing into this screen. If only 2 total controllers, then
			-- use binding on primary & secondary to determine. If >2, then
			-- only a subset might have been active. It's hard to
			-- reconstruct state exactly (especially if launched game), so
			-- reset to a sane state.

			if(this.iMaxControllers == 2) then
				this.Mode[this.iPrimaryPort] = 2
				if(ScriptCB_GetSecondaryController()) then
					this.Mode[3 - this.iPrimaryPort] = 2
				else
					this.Mode[3 - this.iPrimaryPort] = 0
				end
			else
--				if(not this.bKnowBindings) then
					for i=1,this.iMaxControllers do
						this.Mode[i] = 0
					end
					this.Mode[this.iPrimaryPort] = 2
--					local iSecondary = ScriptCB_GetSecondaryController() + 1
--					this.Mode[iSecondary] = 1
					-- Unbind everyone else
					for i=1,this.iMaxControllers do
						if(this.Mode[i] < 1) then
							ScriptCB_UnbindController(i) -- don't care about this controller anymore
						end
					end
--				end
			end

		end

		
		ifs_split_profile_fnUpdateScreen(this,1)
		ScriptCB_ReadAllControllers(1) -- note we need this mode on this screen
		this.bReturnToLoadFileList = nil -- clear
	end,

	Exit = function(this, bFwd)
		ScriptCB_ReadAllControllers(nil) -- turn off once we're done with this screen
		gMovieDisabled = nil
		if(not bFwd) then
			-- Going to main menu. Restore default profile. 
			ScriptCB_RestoreDefaultProfile()
		end
	end,

	-- Always force update first time thru
	fControllerCheckTimer = 0,
	fNumControllers = -1,
	Update = function(this, fDt)
		-- Call base class functionality
		gIFShellScreenTemplate_fnUpdate(this, fDt)

		this.fControllerCheckTimer = this.fControllerCheckTimer - fDt
		if(this.fControllerCheckTimer < 0) then
			this.fControllerCheckTimer = 0.3 -- reset timer
			local LastNumControllers = this.fNumControllers
			this.fNumControllers = ScriptCB_GetNumControllers()

			if(LastNumControllers ~= this.fNumControllers) then
				ifs_split_profile_fnUpdateScreen(this)
			end
		end
	end,

	Input_GeneralUp = function(this, iJoystick)
		iJoystick = iJoystick + 1 -- convert from C's 0-base to Lua's 1-base
		if(this.Mode[iJoystick] == 1) then
			ListManager_fnNavUp(this.Profile[iJoystick].listbox,ifs_split_profile_listbox_contents,ifs_split_profile_listbox_layout[iJoystick])
--			ifs_split_profile_fnEnsureUniqueSelections(this)
		end
	end,

	Input_GeneralDown = function(this, iJoystick)
		iJoystick = iJoystick + 1 -- convert from C's 0-base to Lua's 1-base
		if(this.Mode[iJoystick] == 1) then
			ListManager_fnNavDown(this.Profile[iJoystick].listbox,ifs_split_profile_listbox_contents,ifs_split_profile_listbox_layout[iJoystick])
--			ifs_split_profile_fnEnsureUniqueSelections(this)
		end
	end,

	-- Left/Right useless on this screen
	Input_GeneralLeft = function(this, iJoystick)
											end,

	Input_GeneralRight = function(this, iJoystick)
											 end,

	Input_Accept = function(this,iJoystick)
		iJoystick = iJoystick + 1 -- convert from C's 0-base to Lua's 1-base
--		print("ifs_split_profile.Input_Accept(",iJoystick,")")

		if(this.Mode[iJoystick] == 1) then
			-- See if this selection is dimmed. Reject if dimmed, accept if possible
			ifs_split_profile_fnCalcDim(this, iJoystick)
			local SelIdx = ifs_split_profile_listbox_layout[iJoystick].SelectedIdx
			if(ifs_split_profile_listbox_contents[SelIdx].bDim) then
				ifelm_shellscreen_fnPlaySound(this.errorSound)
			else
				ifelm_shellscreen_fnPlaySound(this.acceptSound)
				this.Mode[iJoystick] = 2
				ifs_split_profile_fnUpdateScreen(this)
			end
		elseif (this.Mode[iJoystick] == 2) then
			return this:Input_Start(iJoystick - 1) -- remember to unconvert from 1-base
		end
	end,

	Input_Back = function(this, iJoystick)
		iJoystick = iJoystick + 1 -- convert from C's 0-base to Lua's 1-base
--		print(" ifs_split, Input_Back has iJoystick ", iJoystick)

		-- Primary controller can never change their login name
		if(iJoystick == this.iPrimaryPort) then
			ScriptCB_UnbindController(-2) -- unbind all but primary
			ScriptCB_ReadAllControllers(nil) -- turn off once we're done with this screen
			ScriptCB_PopScreen()
			return
		end

		-- Do special handling if going back from mode 1
		if(this.Mode[iJoystick] == 1) then
			if(iJoystick ~= this.iPrimaryPort) then
				ScriptCB_UnbindController(iJoystick) -- don't care about this controller anymore
			end
		end -- special handling for current one in mode 1

		-- Always do this code
		if(this.Mode[iJoystick] > 1) then
			ifelm_shellscreen_fnPlaySound(this.exitSound)
		end
		this.Mode[iJoystick] = math.max(this.Mode[iJoystick] - 1,0)
		ifs_split_profile_fnUpdateScreen(this)
	end,

	Input_Start = function(this, iJoystick)
		iJoystick = iJoystick + 1 -- convert from C's 0-base to Lua's 1-base
--		print("ifs_split_profile.Input_Start(",iJoystick,")")

		-- Set flag that we know the bindings, exactly.
		this.bKnowBindings = 1

		-- If on listbox, all the logic to advance state is in
		-- Input_Accept instead.
		if(this.Mode[iJoystick] == 1) then
			return this:Input_Accept(iJoystick - 1) -- remember to unconvert from 1-base
		end

		if(this.Mode[iJoystick] < 2) then
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			this.Mode[iJoystick] = this.Mode[iJoystick] + 1
		end

		-- Check if everyone is ready
		local i

		local bAllReady, iNumReady = ifs_split_profile_fnOkToLaunch(this)
--		print("iNumReady = ", iNumReady)

		if((bAllReady) and (iJoystick == this.iPrimaryPort)) then

			-- Launch time!
			
			ScriptCB_SetSplitscreen(iNumReady)
			
--			print("load the two profiles")

			local i
			local Selections = {}
			local LoadNames = { nil, nil, nil, nil, } -- Names that exist on memcard
			local FakeNames = { nil, nil, nil, nil, } -- Names that aren't on memcard

			for i=1,this.iMaxControllers do
				Selections[i] = ifs_split_profile_listbox_contents[ifs_split_profile_listbox_layout[i].SelectedIdx]
				if(Selections[i].memslot > 0) then
--					print("Player "..i.." wants the profile in Active ",Selections[i].memslot,": ",ScriptCB_ununicode(Selections[i].showstr))
				else
--					print("Player "..i.." wants the profile on Memcard: ",ScriptCB_ununicode(Selections[i].showstr))
				end

				if(this.Mode[i] == 2) then
					if (Selections[i].memslot > 0) then
						FakeNames[i] = Selections[i].showstr
					else
						LoadNames[i] = Selections[i].showstr
					end
				end
			end

			if(gPlatformStr == "PS2") then
				--only first two players for PS2
				ScriptCB_MakeFakeProfiles(FakeNames[1], FakeNames[2])
			else			
				ScriptCB_MakeFakeProfiles(FakeNames[1], FakeNames[2], FakeNames[3], FakeNames[4])
			end
			ifs_split_profile_StartLoadProfile(LoadNames[1], LoadNames[2], LoadNames[3], LoadNames[4])
			
			-- hide everything on this screen
			for i=1,this.iMaxControllers do
				this.Mode[i] = 4
			end
		end -- all are ready

		ifs_split_profile_fnUpdateScreen(this)			
	end, -- function Input_Start

	fnLoadProfilesDone = ifs_split_profile_fnLoadProfilesDone,
}

-- Helper function: makes most of the screen, based on # of entries. 
function ifssplit_profile_fnBuildScreen(this)
	local iMaxControllers = 2

 	if(gPlatformStr == "XBox") then
 		iMaxControllers = 4
 	end

	this.iMaxControllers = iMaxControllers

	-- Ask game for screen size, use for values
	local r
	local b
	local v
	r,b,v=ScriptCB_GetSafeScreenInfo()

	local i
	for i=1,iMaxControllers do
		local PaneTL_X,PaneTL_Y -- Top-left X,Y of this pane, relative to WHOLE SCREEN
		local PaneW,PaneH -- Width, height of this pane
		local InsetL = 0
		local InsetR = 0

		-- Determine TL positions of everything
		if(iMaxControllers == 2) then
			PaneW = r
			PaneH = b * 0.5
			PaneTL_X = 0
			PaneTL_Y = (i-1) * PaneH
		else -- must be 4 controllers
			Inset = 5
			PaneW = r * 0.5
			PaneH = b * 0.5
			if ((i == 1) or (i == 3)) then
				PaneTL_X = 0
				InsetR = 5 -- move away from vertical dividing line
			else
				PaneTL_X = PaneW
				InsetL = 5 -- move away from vertical dividing line
			end

			if (i <= 2) then
				PaneTL_Y = 0
			else
				PaneTL_Y = PaneH
			end
		end

		-- All the internal groups are centered onscreen. Move TL position
		-- to be pinned to the right place
		PaneTL_X = PaneTL_X + r * -0.5
		PaneTL_Y = PaneTL_Y + b * -0.5

		this.ProfileName[i] = NewIFText {
			x = PaneTL_X + (PaneW * 0.5) + ((PaneW - 16) * -0.5), -- center within pane
			y = PaneTL_Y + (PaneH * 0.5) - 40 - 25, -- Above the message.
			string = "ifs.split.starttojoin",
			font = "gamefont_medium",
			halign = "hcenter",
			valign = "top",
			textw = PaneW - 16,
			texth = 120,
			--		y = -8,
			nocreatebackground=1,
		} -- this.Message[i]

		this.Message[i] = NewIFText {
			x = PaneTL_X + (PaneW * 0.5) + ((PaneW - 16) * -0.5), -- center within pane
			y = PaneTL_Y + (PaneH * 0.5) - 40, -- center within pane (must subtract half of texth)
			string = "ifs.split.starttojoin",
			font = "gamefont_medium",
			halign = "hcenter",
			valign = "top",
			textw = PaneW - 16,
			texth = 120,
			--		y = -8,
			nocreatebackground=1,
		} -- this.Message[i]

		this.pressstart[i] = NewIFText {
			x = PaneTL_X + (PaneW * 0.5) + ((PaneW - 16) * -0.5), -- center within pane
			y = PaneTL_Y + (PaneH * 0.5) - 40 + 25, -- bottom side of pane (must subtract half of texth)
			string = "ifs.split.starttolaunch",
			font = "gamefont_medium",
			textw = PaneW - 16,
			texth = 120,
			nocreatebackground=1,
		}

		this.BackGroup[i] = NewHelptext {
			x = PaneTL_X + InsetL, -- inset slightly
			y = PaneTL_Y + PaneH - 20, -- just off the bottom
			buttonicon = "btnb",
			string = "common.back",
		} -- this.BackGroup[i]

		this.AcceptGroup[i] = NewHelptext {
			x = PaneTL_X + PaneW - InsetR, -- inset slightly
			y = PaneTL_Y + PaneH - 20, -- just off the bottom
			buttonicon = "btna",
			string = "common.select",
			bRightJustify = 1,
		} -- this.AcceptGroup[i]

		ifs_split_profile_listbox_layout[i].width = math.min(PaneW * 0.8, ifs_login_listbox_layout.width)

		local ListHeightPer = (ifs_split_profile_listbox_layout[i].yHeight + ifs_split_profile_listbox_layout[i].ySpacing)
		local ListboxHeight = ifs_split_profile_listbox_layout[i].showcount * ListHeightPer + 30
		this.Profile[i] = NewIFContainer {
			listbox = NewButtonWindow { 
				ZPos = 200, 
				x = PaneTL_X + PaneW * 0.5,
				y = PaneTL_Y + PaneH * 0.5 - 10,

				width = ifs_split_profile_listbox_layout[i].width + 35,
				height = ListboxHeight,
			},
		} -- this.Profile[i]

		ListManager_fnInitList(this.Profile[i].listbox,ifs_split_profile_listbox_layout[i])
	end

	this.horizline = NewIFImage {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
		texture = "gray_rect", 
		alpha = 0.8,
		localpos_l = -(r * 0.5 + 200), localpos_t = -2, 
		localpos_r =  (r * 0.5 + 200), localpos_b =  2,
		inert = 1,
		ColorR = 192, ColorG = 192, ColorB = 255,		
	}
	
	if(	this.iMaxControllers > 2) then
		this.vertline = NewIFImage {
			ScreenRelativeX = 0.5, -- center
			ScreenRelativeY = 0.5, -- center
			texture = "gray_rect", 
			alpha = 0.8,
			localpos_t = -(b * 0.5 + 200), localpos_l = -2, 
			localpos_b =  (b * 0.5 + 200), localpos_r =  2,

			ColorR = 192, ColorG = 192, ColorB = 255,
			inert = 1,
		}
	end

end

-- Call function to create/resize/reposition items
ifssplit_profile_fnBuildScreen(ifs_split_profile)
ifssplit_profile_fnBuildScreen = nil -- clear that out of memory

AddIFScreen(ifs_split_profile,"ifs_split_profile")