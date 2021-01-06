--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Generalized mission select screen. Done to unify the varions
-- screens 

-- Well, until someone decided to fork things for the PC. - NM 11/3/04


-- Internal set of pages:
-- this.iPage == 0   -> 2-column mode (this.bOnLeft is a flag for listbox, this.bOnButtons)
-- this.iPage == 1   -> Pick era buttons
-- 
-- Flow goes 0 -> 1 -> 2 -> 0 for maps w/ 4 luas, or 0 -> 2 -> 0 for
-- maps w/ only 1 lua

-- The built-up list of maps is put in gPickedMaplist, which has
-- entries in the following form:
--
-- gPickedMapList = {
--   { Map = "nab1c", Side = 1, SideChar = "r" },
--   { ... }
-- }

local USING_NEW_PC_SHELL = 1

function ifs_missionselect_fnUsingNewShell( this )
	if( USING_NEW_PC_SHELL ) then
		-- hide option list box		
		IFObj_fnSetVis( this.InfoboxOptions, nil )
		IFObj_fnSetVis( this.OptionListbox, nil )
	end
end

-- Pull in list of missions.
--ScriptCB_DoFile("missionlist")

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function MissionSelectListboxL_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { 
		x = layout.x - 0.5 * layout.width, 
		y = layout.y,
	}

	local HAlign = "left"
	local XPos = 5
	local WidthAdj = -5

	Temp.map = NewIFText { 
		x = XPos,
		y = layout.height * -0.5 + 2,
		halign = HAlign, valign = "vcenter",
		font = "gamefont_tiny", 
		textw = layout.width + WidthAdj, texth = layout.height,
		startdelay=math.random()*0.5, nocreatebackground=1, 
	}

	return Temp
end

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function MissionSelectListboxR_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { 
		x = layout.x - 0.5 * layout.width, 
		y = layout.y,
	}

	local HAlign = "left"
	local XPos = 5
	local WidthAdj = -5

	Temp.map = NewIFText { 
		x = XPos,
		y = layout.height * -0.5 + 2,
		halign = HAlign, valign = "vcenter",
		font = "gamefont_tiny", 
		textw = layout.width + WidthAdj, texth = layout.height,
		startdelay=math.random()*0.5, 
		nocreatebackground=1, 
	}
	
	-- the icon
	local iconSize = layout.height * 0.65
	Temp.icon1 = NewIFImage {
 		ZPos = 0, 
 		x = layout.width - iconSize * 1.3, 
 		y = -4,
 		localpos_l = 0, localpos_t = 0,
 		localpos_r = iconSize, localpos_b = iconSize,
		texture = "imp_icon",
	}
	Temp.icon2 = NewIFImage {
 		ZPos = 0, 
 		x = layout.width - iconSize * 2.5,
 		y = -4,
 		localpos_l = 0, localpos_t = 0,
 		localpos_r = iconSize, localpos_b = iconSize,
		texture = "imp_icon",
	}

	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function MissionSelectListboxL_PopulateItem(Dest,Data)
	if(Data) then
		-- Show the data
		local DisplayUStr,iSource = missionlist_GetLocalizedMapName(Data.mapluafile)
		IFText_fnSetUString(Dest.map,DisplayUStr)
	end

	IFObj_fnSetVis(Dest.map,Data)

end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function MissionSelectListboxR_PopulateItem(Dest,Data)
	if(Data) then
		local DisplayUStr,iSource = missionlist_GetLocalizedMapName(Data.Map)
		IFText_fnSetUString(Dest.map,DisplayUStr)

		-- set the icon texture
		if (Data.SideChar == "g") then
			IFImage_fnSetTexture(Dest.icon1,"imp_icon")
			IFImage_fnSetTexture(Dest.icon2,"all_icon")
			IFObj_fnSetVis(Dest.icon1,1)
			IFObj_fnSetVis(Dest.icon2,1)
		elseif (Data.SideChar == "c") then
			IFImage_fnSetTexture(Dest.icon1,"rep_icon")
			IFImage_fnSetTexture(Dest.icon2,"cis_icon")
			IFObj_fnSetVis(Dest.icon1,1)
			IFObj_fnSetVis(Dest.icon2,1)
		else
			IFObj_fnSetVis(Dest.icon1,nil)
			IFObj_fnSetVis(Dest.icon2,nil)
		end		
	end

	-- Turn on/off depending on whether data's there or not
	IFObj_fnSetVis(Dest,Data)
end

missionselect_name_listboxL_layout = {
	showcount = 10,
--	yTop = -130 + 13, -- auto-calc'd now
	yHeight = 23,
	ySpacing  = 0,
--	width = 260,
	x = 0,
	slider = 1,
	CreateFn = MissionSelectListboxL_CreateItem,
	PopulateFn = MissionSelectListboxL_PopulateItem,
}

missionselect_name_listboxR_layout = {
	showcount = 7,
--	yTop = -130 + 13, -- auto-calc'd now
	yHeight = 26,
	ySpacing  = 0,
--	width = 260,
	x = 0,
	slider = 1,
	CreateFn = MissionSelectListboxR_CreateItem,
	PopulateFn = MissionSelectListboxR_PopulateItem,
}

function ifs_missionselect_fnShowHideListboxes(this,bShowThem)
	local A1,A2
	local fAnimTime = 0.3

	if(bShowThem) then
		A1 = 0
		A2 = 1
		this.AddDelContainer.add.bHidden = 1
		this.AddDelContainer.del.bHidden = 1
	else
		A1 = 1
		A2 = 0
		this.AddDelContainer.add.bHidden = nil
		this.AddDelContainer.del.bHidden = nil
	end

	AnimationMgr_AddAnimation(this.AddDelContainer, { fStartAlpha = A1, fEndAlpha = A2,})
	--AnimationMgr_AddAnimation(this.listboxL, { fStartAlpha = A1, fEndAlpha = A2,})
	--AnimationMgr_AddAnimation(this.listboxR, { fStartAlpha = A1, fEndAlpha = A2,})
end

function ifs_missionselect_fnFullPopupDone()
	local this = ifs_missionselect
	ifs_missionselect_fnShowHideListboxes(this,1)
end


-- Flips map order
function ifs_missionselect_fnToggleOrder(this)
	this.bRandomOrder = not this.bRandomOrder
	if(this.bRandomOrder) then
		RoundIFButtonLabel_fnSetString(this.OrderButton,"ifs.missionselect.random")
	else
		RoundIFButtonLabel_fnSetString(this.OrderButton,"ifs.missionselect.inorder")
	end
end

-- Sets up the map preview based on the current selection
function ifs_missionselect_fnSetMapPreview(this)
	local movieName = nil
	local movieFile = nil
	local num = missionselect_name_listboxL_layout.SelectedIdx or 1

	local Selection = missionselect_listbox_contents[num]
	print("num, Selection =", num, Selection)
	movieName, movieFile = missionlist_fnGetMovieName(Selection)
	
	if (movieName) then
		--ifelem_shellscreen_fnStartMovie(movieName.."fly", nil, this.movieX,this.movieY,this.movieW,this.movieH)
		this.movieName = movieName
		this.movieTime = 0.5
		this.movieFile = movieFile
	else
		ifelem_shellscreen_fnStopMovie()		
	end
	IFObj_fnSetVis(this.Map,nil)
end

-- Helper function, manages the state of the 'Delete' button
function ifs_missionselect_fnUpdateDelButton(this)
	local bShouldBeOn = (this.iPage == 0) and (not this.bOnLeft) and (not this.bOnButtons) and (table.getn(gPickedMapList) > 0)
	
	bShouldBeOn = nil
end

-- Sets the current button to the specified table (which can be nil)
function ifs_missionselect_fnSetCurButton(this,tNewButton,ButtonStr)
--	print("ifs_missionselect_fnSetCurButton(..,", tNewButton,ButtonStr)
	-- Always deselect old button if set
	if(gCurHiliteButton) then
		IFButton_fnSelect(gCurHiliteButton,nil)
	end

	if(tNewButton) then
		this.CurButton = ButtonStr
		this.bOnButtons = 1
		gCurHiliteButton = tNewButton
		IFButton_fnSelect(gCurHiliteButton,1)
		missionselect_name_listboxR_layout.CursorIdx = nil
		missionselect_name_listboxL_layout.CursorIdx = nil
		--ListManager_fnFillContents(this.listboxR,gPickedMapList,missionselect_name_listboxR_layout)
		--ListManager_fnFillContents(this.listboxL,missionselect_listbox_contents,missionselect_name_listboxL_layout)
	else
		this.bOnButtons = nil
		gCurHiliteButton = nil
	end

--	print("fnSetCurButton, New=",tNewButton," Cur=",this.CurButton)
end

-- Sets up the screen for the specified page
function ifs_missionselect_fnSetPage(this,iNewPage)
	-- Early exit if changing to same page
	if(this.iPage == iNewPage) then
		return
	end
	local iLastPage = this.iPage

	-- Page 2 isn't allowed anymore - NM 4/5/04
	assert(iNewPage ~= 2)

	-- Turn off items as appropriate when leaving a page
	if(iLastPage == 0) then
		-- Listboxes will always be off on the other pages
		--AnimationMgr_AddAnimation(this.listboxL, { fStartAlpha = 1, fEndAlpha = 0.0,})
		--AnimationMgr_AddAnimation(this.listboxR, { fStartAlpha = 1, fEndAlpha = 0.5,})
		--this.listboxL.bHidden = 1
		--this.listboxR.bHidden = 1
		this.OrderButton.bHidden = 1
		--this.LaunchButton.bHidden = 1
		AnimationMgr_AddAnimation(this.Map, { fStartAlpha = 1, fEndAlpha = 0.5,})
		AnimationMgr_AddAnimation(this.OrderButton, { fStartAlpha = 1, fEndAlpha = 0,})
		--AnimationMgr_AddAnimation(this.LaunchButton, { fStartAlpha = 1, fEndAlpha = 0,})

		this.AddDelContainer.add.bHidden = 1
		this.AddDelContainer.del.bHidden = 1
		AnimationMgr_AddAnimation(this.AddDelContainer, { fStartAlpha = 1, fEndAlpha = 0.0,})

		-- Also, update title
--		AnimationMgr_AddAnimation(this.titleL, { fStartAlpha = 1, fEndAlpha = 0,})
--		AnimationMgr_AddAnimation(this.titleR, { fStartAlpha = 1, fEndAlpha = 0,})
	elseif (iLastPage == 1) then
		-- Fade off buttons if they won't be on anymore
		if(iNewPage == 0) then
			AnimationMgr_AddAnimation(this.buttons, { fStartAlpha = 1, fEndAlpha = 0,})
			this.buttons.bHidden = 1
		end
	elseif (iLastPage == 2) then
		-- Fade off buttons if they won't be on anymore
		if(iNewPage == 0) then
			AnimationMgr_AddAnimation(this.buttons, { fStartAlpha = 1, fEndAlpha = 0,})
			this.buttons.bHidden = 1
		end
	end

	-- Set the new page
	this.iPage = iNewPage

	-- Turn off items as appropriate when leaving a page
	if(iNewPage == 0) then
		-- Listboxes will always be on for this page
		--AnimationMgr_AddAnimation(this.listboxL, { fStartAlpha = 0, fEndAlpha = 1,})
		--AnimationMgr_AddAnimation(this.listboxR, { fStartAlpha = 0.5, fEndAlpha = 1,})
		--this.listboxL.bHidden = nil
		--this.listboxR.bHidden = nil
		AnimationMgr_AddAnimation(this.Map, { fStartAlpha = 0, fEndAlpha = 1,})
		AnimationMgr_AddAnimation(this.OrderButton, { fStartAlpha = 0, fEndAlpha = 1,})
		--AnimationMgr_AddAnimation(this.LaunchButton, { fStartAlpha = 0, fEndAlpha = 1,})
		-- Also, update title
--		AnimationMgr_AddAnimation(this.titleL, { fStartAlpha = 0, fEndAlpha = 1,})
--		AnimationMgr_AddAnimation(this.titleR, { fStartAlpha = 0, fEndAlpha = 1,})
		this.OrderButton.bHidden = nil
		--this.LaunchButton.bHidden = nil

		this.AddDelContainer.add.bHidden = nil
		this.AddDelContainer.del.bHidden = nil
		AnimationMgr_AddAnimation(this.AddDelContainer, { fStartAlpha = 0.0, fEndAlpha = 1,})

		this.bOnButtons = nil
		this.AttackerChar = nil
	elseif (iNewPage == 1) then
		-- Turn on buttons if they weren't on before
		if(iLastPage == 0) then
			AnimationMgr_AddAnimation(this.buttons, { fStartAlpha = 0, fEndAlpha = 1,})
			this.buttons.bHidden = nil
			-- also set the title bar of the era buttons to the mission name
			-- it probably ain't gonna fit for other languages
			if(gLangStr == "english") then
				local MapNameUStr = missionlist_GetLocalizedMapName(missionselect_listbox_contents[missionselect_name_listboxL_layout.SelectedIdx].mapluafile)
				IFText_fnSetUString(this.buttons._titlebar_,MapNameUStr)
			end
		end
		--this.listboxL.bHidden = 1
		--this.listboxR.bHidden = 1
		this.OrderButton.bHidden = 1
		--this.LaunchButton.bHidden = 1

		SetCurButton("c")

	elseif (iNewPage == 2) then
		-- Turn on buttons if they weren't on before
		if(iLastPage == 0) then
			AnimationMgr_AddAnimation(this.buttons, { fStartAlpha = 0, fEndAlpha = 1,})
			this.buttons.bHidden = nil
		end
		--this.listboxL.bHidden = 1
		--this.listboxR.bHidden = 1
		this.OrderButton.bHidden = 1
		--this.LaunchButton.bHidden = 1
	end

	ifs_missionselect_fnUpdateDelButton(this)
end

-- Adds the currently selected map to the maplist.
function ifs_missionselect_fnAddMap(this)
	local Selection = missionselect_listbox_contents[missionselect_name_listboxL_layout.SelectedIdx]

	local Team1Name
	local Team2Name

	-- Turn era into side character
	if(this.CurButton == "c") then
		this.SideChar = "c"
		Team1Name = "common.sides.rep.name"
		Team2Name = "common.sides.cis.name"
	else
		this.SideChar = "g"
		Team1Name = "common.sides.all.name"
		Team2Name = "common.sides.imp.name"
	end

	ifs_missionselect_fnSetMapAndTeam(this,Selection,Team1Name,Team2Name)
	this.Team1Name = ScriptCB_getlocalizestr(Team1Name)
	this.Team2Name = ScriptCB_getlocalizestr(Team2Name)

	ifs_missionselect_fnSetPage(this,0)
end

-- Utility function - based on the .hidden flag in buttons (already
-- created), shows/hides buttons. Adjusts spacing too. Returns tag of
-- first selectable button.
function ifs_missionselect_fnShowHideItems(dest,layout)
	local xWidth = layout.xWidth or 40
	local xSpacing = layout.xSpacing or 10
	local height = layout.height or 40
	local Font = layout.font or "gamefont_small"
	local yTop = layout.yTop or 0

	local i
	local Count = table.getn(layout.buttonlist)
	local TagOfFirst = nil

	-- Figure out how many are actually visible
	local ShowCount = 0
	for i = 1,Count do
		local label = layout.buttonlist[i].tag
		if(not dest[label].hidden) then
			ShowCount = ShowCount + 1
		end
	end

	local xLeft = ((ShowCount - 1) * (xWidth + xSpacing)) * -0.5

	for i = 1,Count do
		local label = layout.buttonlist[i].tag
		local label2 = layout.buttonlist[i].tag .. "_image"
		IFObj_fnSetVis(dest[label], not dest[label].hidden)
		IFObj_fnSetVis(dest[label2], not dest[label].hidden)

		dest[label].bHidden = dest[label].hidden
		dest[label2].bHidden = dest[label].hidden

		if(not dest[label].hidden) then
			-- not hidden. Show it
			TagOfFirst = TagOfFirst or label -- note which was the first

			IFObj_fnSetVis(dest[label], 1)
			IFObj_fnSetPos(dest[label], xLeft, yTop + 20)
			IFObj_fnSetVis(dest[label2], 1)
			IFObj_fnSetPos(dest[label2], xLeft, 0)

		 xLeft = xLeft + xWidth + xSpacing
		end -- showing this one
	end

	return ShowCount,TagOfFirst
end

-- Tthe side selection is implicit in the selection here, except for
-- the maps that only have one side, and you have to go back around
-- and handle them as special cases. 
function ifs_missionselect_fnSetMapAndTeam(this,Selection,Team1Str,Team2Str)
	local SelectedMap = string.format(Selection.mapluafile, this.SideChar, "con")
	local Side = 1 -- 1 or 2

	local Idx = table.getn(gPickedMapList) + 1
	gPickedMapList[Idx] = {
		Map = SelectedMap,
		dnldable = Selection.dnldable,
		Side = Side,
		SideChar = this.SideChar,
		Team1 = Team1Str,
		Team2 = Team2Str,
	}

	missionselect_name_listboxR_layout.FirstShownIdx = missionselect_name_listboxR_layout.FirstShownIdx or 1
	missionselect_name_listboxR_layout.SelectedIdx = missionselect_name_listboxR_layout.SelectedIdx or 1
	missionselect_name_listboxR_layout.CursorIdx = nil

	--ListManager_fnFillContents(this.listboxR,gPickedMapList,missionselect_name_listboxR_layout)
	-- Hack - refresh the left column next to get the cursor back.
	--ListManager_fnFillContents(this.listboxL,missionselect_listbox_contents,missionselect_name_listboxL_layout)
end

function ifs_missionselect_fnFlipLeftRight(this)
	ifelm_shellscreen_fnPlaySound(this.selectSound)
	this.bOnLeft = not this.bOnLeft

	if(this.bOnLeft) then
		missionselect_name_listboxR_layout.CursorIdx = nil
		--ListManager_fnFillContents(this.listboxR,gPickedMapList,missionselect_name_listboxR_layout)
		missionselect_name_listboxL_layout.CursorIdx = missionselect_name_listboxL_layout.SelectedIdx
		--ListManager_fnFillContents(this.listboxL,missionselect_listbox_contents,missionselect_name_listboxL_layout)
	else
		-- On the right side
		missionselect_name_listboxL_layout.CursorIdx = nil
		--ListManager_fnFillContents(this.listboxL,missionselect_listbox_contents,missionselect_name_listboxL_layout)
		missionselect_name_listboxR_layout.CursorIdx = missionselect_name_listboxR_layout.SelectedIdx
		--ListManager_fnFillContents(this.listboxR,gPickedMapList,missionselect_name_listboxR_layout)
	end
--	ifs_missionselect_fnSetMapPreview(this)
	ifs_missionselect_fnUpdateDelButton(this)
end

-- Helper function - returns a bool as to whether the selection has
-- multiple sides, and also the char of the last (only?) side noticed.
function ifs_missionselect_fnGetSides(Selection)
	local bMultipleSides
	local LastSideChar = nil
	
	if(Selection.era_g) then
		bMultipleSides = (LastSideChar ~= nil)
		LastSideChar = "g"
	end
	if(Selection.era_c) then
		bMultipleSides = (LastSideChar ~= nil)
		LastSideChar = "c"
	end

	return bMultipleSides,LastSideChar
end

function ifs_missionselect_fnLaunch(this)
	if(table.getn(gPickedMapList) > 0) then
		this.SelectedMap = 1
		ScriptCB_SetMissionNames(gPickedMapList,this.bRandomOrder)
		this.fnDone()
	else
		ifelm_shellscreen_fnPlaySound(this.errorSound)
	end
end

-- pass the name of the downloadable content movie file to open it, or nil to open
-- the normal DVD flythrough movie file.
function ifs_missionselect_ChangeMovieFile(movieFile)
--	print("ifs_missionselect_ChangeMovieFile(",movieFile,")")
	local this = ifs_missionselect
	
	-- don't change anything if its the same file
	if(movieFile == this.lastMovieFile) then
		return
	end
	-- remember this for next time
	this.lastMovieFile = movieFile
	
	-- close the last one
	ScriptCB_CloseMovie()
	
	-- set the DC directory, so we can find the correct movie file
	ScriptCB_SetDCMap(movieFile)
	
	-- open the new one
	local dcPrefix = "dc:"
	local pal = ""
	if(not movieFile) then
		dcPrefix = ""
		movieFile = "fly"
	end
	if (ScriptCB_IsPAL() == 1) then
		pal = "pal"
	end	
	-- downloadable pal looks like:     "dc:movies\\RHN3pal.mvs"
	-- downloadable content looks like: "dc:movies\\RHN3.mvs"
	-- normal pal looks like this:      "movies\\flypal.mvs"
	-- normal looks like this:          "movies\\fly.mvs"	
	ScriptCB_OpenMovie(dcPrefix .. "movies\\" .. movieFile .. pal .. ".mvs", "")
	
end

ifs_missionselect = NewIFShellScreen {
	nologo = 1,
	bg_texture = "iface_bgmeta_space",
	movieBackground = nil,
	bNohelptext_backPC = 1,
	
--	-- background image.  we need to make our own since we want to hide it when the movie is visible
--	backImg = NewIFImage { 
--		ScreenRelativeX = 0,
--		ScreenRelativeY = 0,
--		UseSafezone = 0,
--		ZPos = 254, -- behind all. except the movie.
--		texture = "his_brief_BG", 
--		localpos_l = 0,
--		localpos_t = 0,
--		inert = 1, -- Delete this out of lua once created (we'll never touch it again)
--	},

	fnDone = nil, -- Callback function to do something when the user is done
	-- Sub-mode for full/era switch is on.
	EraMode = nil,
	
	Enter = function(this, bFwd)
	
		-- hide cheat bit
		IFObj_fnSetVis( this.cheatOutput, nil )
		
		-- tabs	
		if(gPlatformStr == "PC") then
			
			-- clear multiplayer flag
			if( ifs_main ) then
				ifs_main.option_mp = nil
			end
			
			-- dim host option button
			ifs_missionselect_pcMulti_fnShowHostOptionButton(this, true)
			--if( this.option_buttons and this.option_buttons.host_btn ) then
			--	this.option_buttons.host_btn.bDimmed = 1
			--	IFObj_fnSetAlpha(this.option_buttons.host_btn,0.2)
			--	IFObj_fnSetAlpha(this.option_buttons.host_btn.label,0.2)
			--end
			
			-- using new shell
			ifs_missionselect_fnUsingNewShell( this )
			
			-- set pc profile & title version text
			UpdatePCTitleText(this)
			
			ifelem_tabmanager_SetSelected(this, gPCMainTabsLayout, "_tab_single")
			ifelem_tabmanager_SetSelected(this, gPCSinglePlayerTabsLayout, "_tab_instant", 1)
			ifelem_tabmanager_SetSelected(this, gPCMultiPlayerSettingsTabsLayout, "_opt_playlist", 2)

			-- single player settings
			ifs_sp.bForSplitScreen = nil
			ScriptCB_SetSplitscreen( nil )
			ScriptCB_CancelLogin()
			ScriptCB_CloseNetShell(1)
			ScriptCB_SetInNetGame( nil )

			if(bFwd) then
				ifs_missionselect.fnDone = ifs_instant_fnSelectDone
				ifs_missionselect.fnCancel = ifs_instant_fnSelectCancel
				ifs_missionselect.bForMP = nil
				ScriptCB_SetGameRules("instantaction")
			end
		end

		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call base class

		-- stop the current movie
		ifelem_shellscreen_fnStopMovie()
				
		if(this.bForMP == 1) then
--			print("Moving stuff down for multiplayer PC")
			
			-- Sets the position. Pass nil for either arg to use current value instead
			--IFObj_fnSetPos(this.listboxL,this.listboxL.x,200,this.listboxL.z)
			--IFObj_fnSetPos(this.listboxR,this.listboxR.x,200,this.listboxR.z)
		end		

		-- init double click
		this.bDoubleClicked = nil

		-- Determine how many missions can be queued.
		this.iMaxMissions = ScriptCB_GetMaxMissionQueue()

		-- Added chunk for error handling...
		if(not bFwd) then
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
			if(ErrorLevel >= 6) then -- session or login error, must keep going further
				ScriptCB_PopScreen()
			end
		end

		if(bFwd) then
			missionlist_ExpandMaplist(this.bForMP) -- TODO: filter era/mode here
			--gPickedMapList = {}
			this.movieTime = 0.5

			--RoundIFButtonLabel_fnSetString(this.LaunchButton,"ifs.onlinelobby.launch")
--			gIFShellScreenTemplate_fnMoveClickableButton(this.LaunchButton,this.LaunchButton.label,0)
	
			this.iPage = 2
			ifs_missionselect_fnSetPage(this,0) -- default internal mode.
			this.buttons.fStartAlpha = 0
			this.buttons.fEndAlpha = 0
			IFObj_fnSetAlpha(this.buttons,0)
			ifs_missionselect_fnToggleOrder(this)
			ifs_missionselect_fnToggleOrder(this)

			--IFObj_fnSetAlpha(this.Helptext_Delete,0.25)
			IFButton_fnSelect(this.OrderButton,nil)
			--IFButton_fnSelect(this.LaunchButton,nil)

			this.SelectedMap = nil -- clear this
			--gPickedMapList = {} -- clear this also.
			missionselect_name_listboxR_layout.FirstShownIdx = 1
			missionselect_name_listboxR_layout.SelectedIdx = 1
			missionselect_name_listboxR_layout.CursorIdx = nil
			--ListManager_fnFillContents(this.listboxR,gPickedMapList,missionselect_name_listboxR_layout)

			-- Reset listboxL, show it. [Remember, Lua starts at 1!]
			missionselect_name_listboxL_layout.FirstShownIdx = 1
			missionselect_name_listboxL_layout.SelectedIdx = 1
			missionselect_name_listboxL_layout.CursorIdx = 1
			--ListManager_fnFillContents(this.listboxL,missionselect_listbox_contents,missionselect_name_listboxL_layout)

			ifs_missionselect_fnSetMapPreview(this)

			ifs_missionselect_fnSetCurButton(this,nil)

			-- Determine how many missions can be queued.
			this.iMaxMissions = ScriptCB_GetMaxMissionQueue()

			-- map listbox
			ifs_mspc_MapList_layout.CursorIdx = ifs_mspc_MapList_layout.SelectedIdx
			ListManager_fnFillContents(this.MapListbox,missionselect_listbox_contents,ifs_mspc_MapList_layout)
			ListManager_fnSetFocus(this.MapListbox)
			ifs_missionselect_pcMulti_fnUpdateLists( this )
			
			-- refresh playlist
			if( table.getn(gPickedMapList) == 0 ) then
				ifs_mspc_PlayList_layout.SelectedIdx = nil
				ifs_mspc_PlayList_layout.CursorIdx = nil
			end
			ListManager_fnFillContents(this.PlayListbox,gPickedMapList,ifs_mspc_PlayList_layout)			

			-- Hack - if just 1 map, fake a button press thru to second part
			if(table.getn(missionselect_listbox_contents) == 1) then
				this:Input_Accept()
			end
		else
			ScriptCB_PopScreen()
		end
		
		-- hide some old stuff
		IFObj_fnSetVis( this.AddDelContainer, nil )
		--IFObj_fnSetVis( this.listboxR, nil )
		--IFObj_fnSetVis( this.listboxL, nil )
		IFObj_fnSetVis( this.OrderButton, nil )
		
		-- init Mode and Era checkbox
		-- ifs_missionselect_pcMulti_fnInitModeEra( this )		
	end,

	Exit = function(this, bFwd)
		if(not bFwd) then
			ifs_missionselect_fnSetPage(this,0) -- default internal mode.
			this.SelectedMap = nil -- clear this
		end
		-- stop the current movie
		ifelem_shellscreen_fnStopMovie()
	end,
	
	Update = function(this, fDt)
		-- Call base class functionality
		gIFShellScreenTemplate_fnUpdate(this, fDt)
		
		--time to change movies?
		this.movieTime = this.movieTime - fDt
		if( this.movieName and this.movieTime<=0 ) then
			print("play movie", this.movieName, " ", this.movieX, ",", this.movieY, " ", this.movieW, "x", this.movieH);
			ifs_missionselect_ChangeMovieFile(this.movieFile)
    		ifelem_shellscreen_fnStartMovie(this.movieName.."fly", 1, nil, nil, this.movieX,this.movieY,this.movieW,this.movieH)
		    this.movieName = nil;
		end
		
		-- animate the left/right arrows?
		IFObj_UpdateBlinkyAnim(this.AddDelContainer.add,
													 IFObj_fnTestHotSpot(this.AddDelContainer.add),0.4,1,0.4,0.2)
		IFObj_UpdateBlinkyAnim(this.AddDelContainer.del,
													 IFObj_fnTestHotSpot(this.AddDelContainer.del),0.4,1,0.4,0.2)
													 
		-- update listboxes if there are any changes
		ifs_missionselect_pcMulti_fnUpdateLists( this )

		-- press shift/ctrl key
		ifs_missionselect_pcMulti_fnUpdateKeyboard( this )		
	end,
	

	Input_Accept = function(this)
   		-- If the tab manager handled this event, then we're done
		if( (gPlatformStr == "PC") and 
			( ifelem_tabmanager_HandleInputAccept(this, gPCMainTabsLayout) or
			  ifelem_tabmanager_HandleInputAccept(this, gPCSinglePlayerTabsLayout, 1) ) or
			  ifelem_tabmanager_HandleInputAccept(this, gPCMultiPlayerSettingsTabsLayout, 2) ) then
				return
			end

	
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this, 1 )) then
			return
		end
		
		-- if click on map list
		ifs_missionselect_pcMulti_fnClickMapList( this )

		if(gMouseListBox) then
			--if( gMouseListBox == this.ModeListbox ) then
			if( gMouseListBox == this.MapListbox ) then
				--this.bClicked = 1
				if( ( gMouseListBox.Layout.SelectedIdx == gMouseListBox.Layout.CursorIdx ) and 
					( this.lastDoubleClickTime ) and 
					( ScriptCB_GetMissionTime()<this.lastDoubleClickTime+0.4 ) ) then
					-- double clicked
					this.iLastClickTime = nil
					this.bDoubleClicked = 1
				else
					-- single clicked
					this.iLastClickTime = ScriptCB_GetMissionTime()
					gMouseListBox.Layout.SelectedIdx = gMouseListBox.Layout.CursorIdx
				end				
			end
		
			--ScriptCB_SndPlaySound("shell_select_change")
			if( gMouseListBox.Layout.SelectedIdx == gMouseListBox.Layout.CursorIdx and this.lastDoubleClickTime and ScriptCB_GetMissionTime()<this.lastDoubleClickTime+0.4) then
--				print("doing shortcut")
				this.lastDoubleClickTime = nil
				--if( gMouseListBox == this.listboxL ) then
				--	this.CurButton = "_add"
				--else
				--	this.CurButton = "_del"
				--end
			else
				this.lastDoubleClickTime = ScriptCB_GetMissionTime()
				gMouseListBox.Layout.SelectedIdx = gMouseListBox.Layout.CursorIdx
				ListManager_fnFillContents(gMouseListBox,gMouseListBox.Contents,gMouseListBox.Layout)
				
				--start to play the movie
				ifs_missionselect_fnSetMapPreview(this)
				
				return 1 -- note we did all the work
			end
		end

		ifs_missionselect_pcMulti_fnClickCheckButtons( this )
		ifs_missionselect_pcMulti_fnClickMapButtons( this )

		-- input accept for option buttons
		ifs_missionselect_pcMulti_fnClickOptionButtons( this )

		if(this.CurButton == "_del") then
			local Count = table.getn(gPickedMapList)
			if(Count > 0) then
				local i
				local j = 1
				local NewList = {}
				for i=1,Count do
					if(i ~= missionselect_name_listboxR_layout.SelectedIdx) then
						NewList[j] = gPickedMapList[i]
						j = j + 1
					end
				end

				gPickedMapList = NewList
				--ListManager_fnAutoscroll(this.listboxR,gPickedMapList,missionselect_name_listboxR_layout)
				--ListManager_fnFillContents(this.listboxR,gPickedMapList,missionselect_name_listboxR_layout)
			end
		end -- "_del" special processing
		
	

		local Selection = missionselect_listbox_contents[missionselect_name_listboxL_layout.SelectedIdx]
		local bPC = (gPlatformStr == "PC")
		if(this.iPage == 0) then -- first sub-part

			if(this.CurButton == "Order") then
				ifs_missionselect_fnToggleOrder(this)
				ifelm_shellscreen_fnPlaySound(this.acceptSound)
			elseif (this.CurButton == "Launch") then
				ifelm_shellscreen_fnPlaySound(this.acceptSound)
				ifs_missionselect_fnLaunch(this)
			elseif (((not bPC) and (this.bOnLeft)) or (bPC and (this.CurButton == "_add"))) then
				ifelm_shellscreen_fnPlaySound(this.acceptSound)

--				print("List full check:",table.getn(gPickedMapList) , this.iMaxMissions)
				if(table.getn(gPickedMapList) < this.iMaxMissions) then
					local bMultipleSides
					local LastSideChar
					bMultipleSides,LastSideChar = ifs_missionselect_fnGetSides(Selection)

					if(bMultipleSides) then
						ifs_missionselect_fnSetPage(this,1)
					else
						-- Only 1 side. Add it directly.
						local EntryButton = this.CurButton
						this.AttackerChar = LastSideChar
						this.CurButton = LastSideChar
						ifs_missionselect_fnAddMap(this)
						this.CurButton = EntryButton
					end
				else
					-- Mission list is full. Notify the user
					ifs_missionselect_fnShowHideListboxes(this,nil)
					Popup_Ok.fnDone = ifs_missionselect_fnFullPopupDone
					Popup_Ok:fnActivate(1)
					gPopup_fnSetTitleStr(Popup_Ok, "ifs.missionselect.listfull")
				end

			else
				-- must be on right listbox
				if this.CurButton then
				   -- don't play sound unless you're on a button
				   ifelm_shellscreen_fnPlaySound(this.acceptSound)
				end
				this.bOnButtons = 1
				missionselect_name_listboxR_layout.CursorIdx = nil
				--ListManager_fnFillContents(this.listboxR,gPickedMapList,missionselect_name_listboxR_layout)
			end -- on right
		elseif (this.iPage == 1) then -- Second sub-part
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			this.AttackerChar = this.CurButton -- store for later

			-- Side select is ingame now - NM 4/5/04
			ifs_missionselect_fnAddMap(this)
--			ifs_missionselect_fnSetPage(this,2)
		elseif (this.iPage == 2) then -- Second sub-part
			ifelm_shellscreen_fnPlaySound(this.acceptSound)

			ifs_missionselect_fnAddMap(this)

--			this.fnDone()
		end -- done with sub-parts
--		print("Input_Accept Bot, CurButton = ", this.CurButton)
	end, -- end of Input_Accept

	Input_KeyDown = function(this, iKey)
		if(gCurEditbox) then
			if(gCurEditbox == this.cheatBox) then
				if((iKey == 10) or (iKey == 13)) then -- handle Enter differently
					local str = IFEditbox_fnGetString(gCurEditbox)
					local retVal = nil
					
					-- special case - campaign list
					if(str == "456123") then
						retVal = "cheats.levels_on"
						ifelm_shellscreen_fnPlaySound(this.acceptSound)
						if(ifs_sp_campaign) then
							ifs_sp_campaign.showCampaignList = true
						end
					else
						retVal = ScriptCB_MrMrsEval(str)
					end
					
					for t=1,200 do
						IFEditbox_fnAddChar(gCurEditbox, 8)	-- backspace
					end
					if(retVal ~= nil) then
						IFText_fnSetString(this.cheatOutput, retVal)
						IFObj_fnSetVis( this.cheatOutput, 1 )
					else
						IFObj_fnSetVis( this.cheatOutput, nil )
					end
				else
					IFEditbox_fnAddChar(gCurEditbox, iKey)
					IFObj_fnSetVis( this.cheatOutput, nil )
				end
			end -- if cheatBox
		end -- if gCurEditBox
	end, --end of Input_KeyDown

	Input_Back = function(this)
		-- Hack - if just 1 map, then can't go back to the listboxL
		if(table.getn(missionselect_listbox_contents) == 1) then
			this.EraMode = nil
		end

		if(this.iPage == 0) then -- first sub-part
			ScriptCB_PopScreen()
			if(this.fnCancel) then
				this.fnCancel()
			else
				ScriptCB_PopScreen() -- default: just go back 2 screens.
			end
		elseif (this.iPage == 1) then
			ifelm_shellscreen_fnPlaySound(this.exitSound)
			ifs_missionselect_fnSetPage(this,0)
		end
	end,

	Input_GeneralUp = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputUp(this)) then
			return
		end

		if(this.iPage == 0) then -- First sub-part
			if(this.bOnLeft) then
				-- In listbox
			else
				-- on the right
				if(this.bOnButtons) then
					ifelm_shellscreen_fnPlaySound(this.selectSound)
					if(this.CurButton == "Order") then
						missionselect_name_listboxR_layout.SelectedIdx = math.min(missionselect_name_listboxR_layout.FirstShownIdx + missionselect_name_listboxR_layout.showcount - 1, table.getn(gPickedMapList))
						if(missionselect_name_listboxR_layout.SelectedIdx < 1) then
							missionselect_name_listboxR_layout.SelectedIdx = 1
						end
						missionselect_name_listboxR_layout.CursorIdx = missionselect_name_listboxR_layout.SelectedIdx
						--ListManager_fnFillContents(this.listboxR,gPickedMapList,missionselect_name_listboxR_layout)
					else
					end

				else
					-- Not on buttons
					if(missionselect_name_listboxR_layout.SelectedIdx == 1) then
						missionselect_name_listboxR_layout.CursorIdx = nil
						--ListManager_fnFillContents(this.listboxR,gPickedMapList,missionselect_name_listboxR_layout)
						ifelm_shellscreen_fnPlaySound(this.selectSound)
					else
						-- on right
					end
				end
			end
--			ifs_missionselect_fnSetMapPreview(this)
		elseif (this.iPage == 1) then
			gDefault_Input_GeneralUp(this)
		end -- page == 0
		ifs_missionselect_fnUpdateDelButton(this)
	end,

	Input_GeneralDown = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputDown(this)) then
			return
		end

		if(this.iPage == 0) then -- First sub-part
			if(this.bOnLeft) then
			else
				-- on the right
				if(this.bOnButtons) then
					ifelm_shellscreen_fnPlaySound(this.selectSound)
					if(this.CurButton == "Order") then
					else
						missionselect_name_listboxR_layout.SelectedIdx = missionselect_name_listboxR_layout.FirstShownIdx
						
						missionselect_name_listboxR_layout.CursorIdx = missionselect_name_listboxR_layout.SelectedIdx
						--ListManager_fnFillContents(this.listboxR,gPickedMapList,missionselect_name_listboxR_layout)
					end
				else
					-- Not on buttons
					if(missionselect_name_listboxR_layout.SelectedIdx >= table.getn(gPickedMapList)) then
						missionselect_name_listboxR_layout.CursorIdx = nil
						--ListManager_fnFillContents(this.listboxR,gPickedMapList,missionselect_name_listboxR_layout)
						ifelm_shellscreen_fnPlaySound(this.selectSound)
					else
					end
				end -- not on buttons
			end
--			ifs_missionselect_fnSetMapPreview(this)
		elseif (this.iPage == 1) then
			gDefault_Input_GeneralDown(this)
		end
		ifs_missionselect_fnUpdateDelButton(this)
	end,

	Input_LTrigger = function(this)
		if(this.iPage == 0) then -- First sub-part
			--if(this.bOnLeft) then
			--	ListManager_fnPageUp(this.listboxL,missionselect_listbox_contents,missionselect_name_listboxL_layout)
			--else
			--	ListManager_fnPageUp(this.listboxR,gPickedMapList,missionselect_name_listboxR_layout)
			--end
--			ifs_missionselect_fnSetMapPreview(this)
		end
	end,

	Input_RTrigger = function(this)
		if(this.iPage == 0) then -- First sub-part
			--if(this.bOnLeft) then
			--	ListManager_fnPageDown(this.listboxL,missionselect_listbox_contents,missionselect_name_listboxL_layout)
			--else
			--	ListManager_fnPageDown(this.listboxR,gPickedMapList,missionselect_name_listboxR_layout)
			--end
--			ifs_missionselect_fnSetMapPreview(this)
		end
	end,

	Input_GeneralLeft = function(this)
		if(this.iPage == 0) then
			ifs_missionselect_fnFlipLeftRight(this)
		end
	end,

	Input_GeneralRight = function(this)
		if(this.iPage == 0) then
			ifs_missionselect_fnFlipLeftRight(this)
		end
	end,

	RepaintListbox = function(this)
	end,
	UpdateButtons = function(this) 
	end,
	UpdateUI = function(this)
	end,
	fnClearButtonHilight = function(this)
	end,
}

gPickedMapList = {}

function ifs_missionselect_fnBuildScreen(this)
	gPickedMapList = {}

	-- add pc profile & title version text
	AddPCTitleText( this )

	if(USING_NEW_PC_SHELL) then
		new_shell_offset_x = 240		
	end

	local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen

	missionselect_name_listboxL_layout.width = (w * 0.48) - 35
	missionselect_name_listboxR_layout.width = (w * 0.48) - 35

	local ListEntryHeightL = (missionselect_name_listboxL_layout.yHeight + missionselect_name_listboxL_layout.ySpacing)
	local ListEntryHeightR = (missionselect_name_listboxR_layout.yHeight + missionselect_name_listboxR_layout.ySpacing)

	missionselect_name_listboxL_layout.showcount = math.min(16,math.max(4, math.floor((h - 160) / ListEntryHeightL)))
	missionselect_name_listboxR_layout.showcount = missionselect_name_listboxL_layout.showcount - 2

	local ListHeightR = missionselect_name_listboxR_layout.showcount * ListEntryHeightR + 30
	local ListHeightL = missionselect_name_listboxL_layout.showcount * ListEntryHeightL + 30

--	this.listboxL = NewButtonWindow { 
--		ZPos = 200, 
--		x = missionselect_name_listboxL_layout.width * 0.5 + 30 - w*0.5, y = 0,
--		ScreenRelativeX = 0.5, -- center of screen
--		ScreenRelativeY = 0.5, -- middle, vertically
--		width = missionselect_name_listboxL_layout.width + 35,
--		height = ListHeightL,
--		rotY = 35,
--		titleText = "ifs.missionselect.available"
--	}

--	this.listboxR = NewButtonWindow { 
--		ZPos = 200, 
--		x = -(missionselect_name_listboxR_layout.width * 0.5+30) + w*0.5, 
--		y = - ( ListHeightL - ListHeightR)/2,
--		ScreenRelativeX = 0.5, -- center of screen
--		ScreenRelativeY = 0.5, -- middle, vertically
--		width = missionselect_name_listboxR_layout.width + 35,
--		height = ListHeightR,
--		rotY = -35,
--		titleText = "ifs.missionselect.selected"
--	}
	
	this.buttons = NewIFContainer {
		ScreenRelativeX = 0.25,
		ScreenRelativeY = 0.5,
	}

	local MapRadius = 50
	
	-- this isn't actually shown anymore...
	this.Map = NewIFMapPreview {
		ScreenRelativeX = 0.0,
		ScreenRelativeY = 0.0,
		x = w * 0.5, y = 35 + ListHeightR + MapRadius,
		width = MapRadius,
	}
	
	this.OrderButton = NewClickableIFButton {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.5,
		--rotY = this.listboxR.rotY,
		--x = this.listboxR.x + 23,
		--y = this.listboxR.height / 2 + 11,
		--btnw = this.listboxR.width,
		btnh = ScriptCB_GetFontHeight("gamefont_small"),
		font = "gamefont_small", 
		tag = "Order",
		string = "ifs.missionselect.inorder",
	}

--	this.LaunchButton = NewRoundIFButton {
--		ScreenRelativeX = 0.5,
--		ScreenRelativeY = 1.0,
--		rotY = -35,
--		y = (ListHeightR * 0.5) -( ListHeightL - ListHeightR)/2 + (MapRadius * 1.5) + 10,
--		y = -15,
--		btnw = w * 0.44, btnh = MapRadius, font = "gamefont_medium",
--		nocreatebackground = 1,
--	}
--	this.LaunchButton.label.halign = "hcenter"
--	this.LaunchButton.label.valign = "vcenter"
--	this.LaunchButton.label.ColorR = 255
--	this.LaunchButton.label.ColorG = 255
--	this.LaunchButton.label.ColorB = 0--255
--	this.LaunchButton.font = nil
--	this.LaunchButton.label.bHotspot = 1
--	this.LaunchButton.label.fHotspotW = this.LaunchButton.btnw
--	this.LaunchButton.label.fHotspotH = this.LaunchButton.btnh
--	this.LaunchButton.tag = "Launch"
	
	
	--size the background
	local wScreen,hScreen,vScreen,widescreen = ScriptCB_GetScreenInfo()
-- 	this.backImg.localpos_r = wScreen*widescreen
-- 	this.backImg.localpos_b = hScreen
-- 	this.backImg.uvs_b = vScreen
	-- calc the position of the movie preview window
	this.movieW = 510.0
	this.movieH = 400.0
	this.movieX = wScreen - 600.0
	this.movieY = hScreen - this.movieH + 100.0 

	-- Also, add buttons
	--this.CurButton = AddVerticalButtons(this.buttons,ifs_era_vbutton_layout)
	
--	ListManager_fnInitList(this.listboxL,missionselect_name_listboxL_layout)
--	ListManager_fnInitList(this.listboxR,missionselect_name_listboxR_layout)

	local AddDelButtonW = 40
	local AddDelButtonYSpace = 5
	local AddDelButtonH = 20

	this.AddDelContainer =	NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- bottom
		y = 0, -- just above bottom
		x = 0 + new_shell_offset_x,

		--add the left/right arrows
		add = NewIFImage 
		{
			y = -(AddDelButtonH + AddDelButtonYSpace),
			x = 1,
			btnw = AddDelButtonW, 
			btnh = AddDelButtonH,
			tag = "_add",
			localpos_l = -AddDelButtonW/2, localpos_t = -AddDelButtonH/2,
			localpos_r =  AddDelButtonW/2, localpos_b =  AddDelButtonH/2,
			texture = "small_arrow",
		},
		del = NewIFImage 
		{
			y = (AddDelButtonH + AddDelButtonYSpace),
			x = 0,
			btnw = AddDelButtonW, 
			btnh = AddDelButtonH,
			tag = "_del",
			localpos_l =  AddDelButtonW/2, localpos_t = -AddDelButtonH/2,
			localpos_r = -AddDelButtonW/2, localpos_b =  AddDelButtonH/2,
			texture = "small_arrow",
		},
	} -- end of button container

	this.AddDelContainer.add.bHotspot = 1
	this.AddDelContainer.add.fHotspotW = AddDelButtonW
	this.AddDelContainer.add.fHotspotH = AddDelButtonH + 8
	this.AddDelContainer.add.fHotspotX = -AddDelButtonW/2
	this.AddDelContainer.add.fHotspotY = -AddDelButtonH/2 - 4
	this.AddDelContainer.del.bHotspot = 1
	this.AddDelContainer.del.fHotspotW = AddDelButtonW
	this.AddDelContainer.del.fHotspotH = AddDelButtonH + 8
	this.AddDelContainer.del.fHotspotX = -AddDelButtonW/2
	this.AddDelContainer.del.fHotspotY = -AddDelButtonH/2 - 4
	
	---------------------------------------------------
	this.iColumn = 0
	this.iMap = 0
	this.bEra_CloneWar = 1
	this.bEra_Galactic = 1
	
	this.iLastClickTime = nil
	this.bDoubleClicked = nil
	
	-- Now, do the boxes above and below the columns
	local ColumnWidthL = 145
	local ColumnWidthC = 200	
	local ColumnWidthR = 200
	local TopBoxHeight = 30 -- enough for two lines of text
	local infobox_offset_x = -38
	local infobox_offset_y = 50 + 5
	
	local ListHeightC = 170
	
	local ColumnWidthOption = 245
	local ColumnHightOption = 210
	this.InfoboxOptions = NewIFContainer { 
		ScreenRelativeX = 0, -- left side of screen
		ScreenRelativeY = 0, -- top
		x = 510 + new_shell_offset_x,
		y = infobox_offset_y, -- top-justify against left box

		bg = NewIFImage {
			ZPos = 240, 
			localpos_l = 4,
			localpos_r = ColumnWidthOption - 2,
			localpos_b = TopBoxHeight,
			texture = "white_rect",
			ColorR = 128,
			ColorG = 128,
			ColorB = 128,
		},

		Text1 = NewIFText { 
			x = 10,
			y = 5,
			halign = "left", valign = "vcenter",
			font = "gamefont_small", 
			textw = ColumnWidthR, texth = TopBoxHeight,
			startdelay=math.random()*0.5, nocreatebackground=1, 
			ColorR = 0,
			ColorG = 0,
			ColorB = 0,
			string = "ifs.mp.create.options",
		},
	}
	
	this.OptionListbox = NewButtonWindow { 
		ZPos = 200, 
		ScreenRelativeX = 0, -- left side of screen
		ScreenRelativeY = 0, -- top
		x = 123 + this.InfoboxOptions.x + new_shell_offset_x,
		y = 130 + this.InfoboxOptions.y + 5,
		width = ColumnWidthOption - 6,
		height = ColumnHightOption,
	}		

--	this.InfoboxHostOptions = NewIFContainer { 
--		ScreenRelativeX = 0, -- left side of screen
--		ScreenRelativeY = 0, -- top
--		x = 510,
--		y = 298, -- top-justify against left box
--
--		bg = NewIFImage {
--			ZPos = 240, 
--			localpos_l = 4,
--			localpos_r = ColumnWidthOption - 2,
--			localpos_b = TopBoxHeight,
--			texture = "white_rect",
--			ColorR = 128,
--			ColorG = 128,
--			ColorB = 128,
--		},
--
--		Text1 = NewIFText { 
--			x = 10,
--			y = 5,
--			halign = "left", valign = "vcenter",
--			font = "gamefont_small", 
--			textw = ColumnWidthR, texth = TopBoxHeight,
--			startdelay=math.random()*0.5, nocreatebackground=1, 
--			ColorR = 0,
--			ColorG = 0,
--			ColorB = 0,
--			string = "ifs.mp.create.host_opt",
--		},
--	}
--	
--	this.HostOptionListbox = NewButtonWindow { 
--		ZPos = 200, 
--		ScreenRelativeX = 0, -- left side of screen
--		ScreenRelativeY = 0, -- top
--		x = 123 + this.InfoboxHostOptions.x,
--		y = 130 + this.InfoboxHostOptions.y + 5,
--		width = ColumnWidthOption - 6,
--		height = ColumnHightOption,
--	}		
	
	local era_text_offset_x = 26
	local era_text_offset_y = 15

	local era_check_offset_x = 7
	local era_check_offset_y = 22

	local listbox_l_offset_y = 240
	local listbox_l_offset_x = 28
	local listbox_c_offset_x = listbox_l_offset_x + ColumnWidthL
	local listbox_r_offset_x = listbox_l_offset_x + ColumnWidthL + ColumnWidthC
		
	ifs_mspc_MapList_layout.width = ColumnWidthL - 24
	ifs_mspc_ModeList_layout.width = ColumnWidthC
	ifs_mspc_PlayList_layout.width = ColumnWidthR - 24
	
--	-- Create our listboxes
--	ListManager_fnInitList(this.MapListbox,ifs_mspc_MapList_layout)
--	ListManager_fnInitList(this.ModeListbox,ifs_mspc_ModeList_layout)
--	ListManager_fnInitList(this.PlayListbox,ifs_mspc_PlayList_layout)
--	print( "finish playlist" )
	
	-- move button position
	local launch_button_y = 15
--	this.Helptext_Back.y = launch_button_y
	--this.LaunchButton.y = launch_button_y

	if(gPlatformStr == "PC") then
		-- Add tabs to screen
		ifelem_tabmanager_Create(this, gPCMainTabsLayout, gPCSinglePlayerTabsLayout, gPCMultiPlayerSettingsTabsLayout)
	end	
	
	-- add option buttons
	ifs_missionselect_pcMulti_fnAddOptionButtons( this, false )
	
	-- add infobox
	ifs_missionselect_pcMulti_fnAddInfoBox( this )
	
	-- add listboxes
	ifs_missionselect_pcMulti_fnAddListboxes( this )
	
	-- add era boxes
	ifs_missionselect_pcMulti_fnAddEraBoxes(this)
	
	-- add map buttons
	ifs_missionselect_pcMulti_fnAddMapButtons(this)
	
	-- add mode boxes
	ifs_missionselect_pcMulti_fnAddModeBoxes( this )	
	
	-- cheat bits
	local cheatBoxY = 400
	local cheatBoxX = 30
	local cheatBoxW = 121
	local cheatBoxH = 77

	this.cheatOutput = NewIFText { 
			x = cheatBoxX-28,
			y = cheatBoxY+40,
			halign = "left", valign = "vcenter",
			font = "gamefont_small", 
			textw = 120, texth = 90,
			font = "gamefont_tiny",
			nocreatebackground=1, 
			string = "",
	}
	
	this.cheatBox = NewEditbox {
			ScreenRelativeX = 0, 
			ScreenRelativeY = 0, 
			y = cheatBoxY,
			x = cheatBoxX,

			width = cheatBoxW,
			height = cheatBoxH,
			font = "gamefont_tiny",
			--		string = "Player 1",
			MaxLen = nil,
			MaxChars = 60,
			bKeepsFocus = nil,
			bSilentAndInvisible = 1,
			bClearOnHilightChange = 1,
			noChangeSound = 1,
			bIsTheCheatBox = 1,
	}
end

ifs_missionselect_fnBuildScreen(ifs_missionselect)
ifs_missionselect_fnBuildScreen = nil -- dump out of memory to save

AddIFScreen(ifs_missionselect,"ifs_missionselect")