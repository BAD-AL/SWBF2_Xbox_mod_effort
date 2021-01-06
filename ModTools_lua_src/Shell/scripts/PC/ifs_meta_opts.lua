--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

--common.sides.all.name	"Rebels"	hoth
--common.sides.imp.name	"Empire"	endor
--common.sides.rep.name	"Republic"	kamino
--common.sides.cis.name	"CIS"		geonosis

ifs_meta_opts_listbox_contents = 
{

			     --																		BES   KAS   NAB   RV    TAT   YAV
	{ showstr = "ifs.meta.configs.1", era = "classic", mapname = "gc_cfg1", config = {{2,2},{2,2},{2,2},{2,2},{2,2},{1,1}}, default = 1, side1 = "common.sides.all.name", side2 = nil, enable = 1 },
	{ showstr = "ifs.meta.configs.2", era = "classic", mapname = "gc_cfg2", config = {{2,2},{1,1},{1,1},{1,1},{1,1},{1,1}}, default = 2, side1 = "common.sides.imp.name", side2 = nil, enable = 1 },
	{ showstr = "ifs.meta.configs.3", era = "new", mapname = "gc_cfg3",		config = {{2,2},{1,1},{2,2},{2,2},{2,2},{2,2}}, default = 1, side1 = "common.sides.rep.name", side2 = nil, enable = 1 },
	{ showstr = "ifs.meta.configs.4", era = "new", mapname = "gc_cfg4",		config = {{1,1},{1,1},{1,1},{2,2},{1,1},{1,1}}, default = 2, side1 = "common.sides.cis.name", side2 = nil, enable = 1 },
--Important note, disable these when u get a chance
	{ showstr = "ifs.meta.configs.5", era = "classic", mapname = "gc_cfg5", config = {{1,2},{2,2},{2,2},{1,1},{1,2},{1,1}}, default = 1, side1 = "common.sides.all.name", side2 = "common.sides.imp.name", enable = 1 },
	{ showstr = "ifs.meta.configs.6", era = "classic", mapname = "gc_cfg6", config = {{1,1},{2,2},{1,2},{1,2},{2,2},{1,1}}, default = 1, side1 = "common.sides.all.name", side2 = "common.sides.imp.name", enable = 1 },
	{ showstr = "ifs.meta.configs.7", era = "new", mapname = "gc_cfg7",		config = {{2,2},{1,2},{1,2},{2,2},{1,1},{1,1}}, default = 1, side1 = "common.sides.rep.name", side2 = "common.sides.cis.name", enable = 1 },
	{ showstr = "ifs.meta.configs.8", era = "new", mapname = "gc_cfg8",		config = {{1,1},{1,1},{2,2},{2,2},{1,2},{1,2}}, default = 1, side1 = "common.sides.rep.name", side2 = "common.sides.cis.name", enable = 1 },
	

	--this could cause problems, i want it on PC only, naw not doing it this wya
	--{ showstr = "ifs.meta.load.load", era = "", mapname = "",		config = {{1,1},{1,1},{2,2},{2,2},{1,2},{1,2}}, default = 1, side1 = "", side2 = "", enable = 1 },		
	
	
}

ifs_meta_opts_listbox_contents_split = 
{			     --																		BES   KAS   NAB   RV    TAT   YAV
	{ showstr = "ifs.meta.configs.5", era = "classic", mapname = "gc_cfg5", config = {{1,2},{2,2},{2,2},{1,1},{1,2},{1,1}}, default = 1, side1 = "common.sides.all.name", side2 = "common.sides.imp.name", enable = 1 },
	{ showstr = "ifs.meta.configs.6", era = "classic", mapname = "gc_cfg6", config = {{1,1},{2,2},{1,2},{1,2},{2,2},{1,1}}, default = 1, side1 = "common.sides.all.name", side2 = "common.sides.imp.name", enable = 1 },
	{ showstr = "ifs.meta.configs.7", era = "new", mapname = "gc_cfg7",		config = {{2,2},{1,2},{1,2},{2,2},{1,1},{1,1}}, default = 1, side1 = "common.sides.rep.name", side2 = "common.sides.cis.name", enable = 1 },
	{ showstr = "ifs.meta.configs.8", era = "new", mapname = "gc_cfg8",		config = {{1,1},{1,1},{2,2},{2,2},{1,2},{1,2}}, default = 1, side1 = "common.sides.rep.name", side2 = "common.sides.cis.name", enable = 1 },
}



ifs_meta_opts_hbutton1_layout = {
	yTop = 200,
--	xLeft = -150, -- auto-calc'd now
	xWidth = 200,
	xSpacing = 0,
	yHeight = 50,
	ySpacing  = 5,
	font = "gamefont_medium",
	nocreatebackground = 1,
	ZPos = 80,
	buttonlist = {
		{ tag = "a", string = "common.sides.all.name", },
		{ tag = "i", string = "common.sides.imp.name"},
	},
}

ifs_meta_opts_hbutton2_layout = {
	yTop = 200,
--	xLeft = -150, -- auto-calc'd now
	xWidth = 200,
	xSpacing = 0,
	yHeight = 50,
	ySpacing  = 5,
	ZPos = 80,
	font = "gamefont_medium",
	nocreatebackground = 1,

	buttonlist = {
		{ tag = "r", string = "common.sides.rep.name"},
		{ tag = "c", string = "common.sides.cis.name", },
	},
}


--Helper functions originally from ifs_meta_top

function ifs_meta_opts_fnMakeIcons(this)
	local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
	--this.buttonWindow.width
	local IconWidth =  this.MapDetail.box.width* 0.45
	
	ifs_meta_top_hbutton1_layout.xWidth = IconWidth / 2
	ifs_meta_top_hbutton2_layout.xWidth = IconWidth / 2

	local XPos = IconWidth * -0.7  --  (w * -0.5) + (IconWidth * 0.5) + IconWidth -- center on this item

	for i = 1,table.getn(ifs_meta_top_IconNames) do
		if(i==1 or i==3) then
			IconWidth = w / table.getn(ifs_meta_top_IconNames) / 2
			XPos = IconWidth * -0.7
		end

		local NameStr = ifs_meta_top_IconNames[i]
		this.MapDetail[NameStr] = NewIFImage {
			y = w*.1, x = XPos,
			localpos_l = -64, localpos_r = 64,
			localpos_t = -128, localpos_b = 100,
--			inertUVs = 1,
			texture = NameStr,
			ZPos = 120, -- a bit behind the text
			--rotX = ifs_meta_top.button_rot_x,
			--rotY = ifs_meta_top.button_rot_y,
			tag = NameStr,
			bHotspot = 1,
			fHotspotX = -50,
			fHotspotY = -120,
			fHotspotW = 100,
			fHotspotH = 220,
		}

		XPos = XPos + IconWidth * 1.6
	end -- loop over i
	
	-- Also, add buttons
	this.CurButton = AddHorizontalButtons(this.MapDetail,ifs_meta_opts_hbutton1_layout)
	AddHorizontalButtons(this.MapDetail,ifs_meta_opts_hbutton2_layout)	
	
	--this.buttons.rotX = ifs_meta_top.button_rot_x
	--this.buttons.rotY = ifs_meta_top.button_rot_y
	
	
	
end

--another top original
function ifs_meta_opts_fnHilightSide(this, Selection)
	local Selected	
	local side
	local eraNew 
	if(Selection) then
		print("Era = ", Selection.era )
		eraNew = (Selection.era == "new")
		if(not this.Side) then
			this.Side = Selection.default
			print("No side, using default")
		end
		
	end

	if(eraNew) then
		if( this.Side == 1 ) then		
			
			this.CurButton = "r"
		else
			this.CurButton = "c"
		end
		metagame_state_fnSetEra(metagame_state,"cw")
	else
		if( this.Side == 1 ) then			
				this.CurButton = "a"
		else
			this.CurButton = "i"
		end
		metagame_state_fnSetEra(metagame_state,"gcw")
	end
	
	print("Side= " , this.CurButton)
	side = this.CurButton
	
	Selected = "side_" .. side
	for i = 1,table.getn(ifs_meta_top_IconNames) do
		local NameStr = ifs_meta_top_IconNames[i]
		local NewAlpha = 0.5
		if(NameStr == Selected) then
			NewAlpha = 1.0
		end
		
		--ifelm_shellscreen_fnPlaySound("shell_select_change")
		IFObj_fnSetAlpha(this.MapDetail[NameStr],NewAlpha)
	end
end
------------
-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_meta_opts_ListboxL_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { 
		x = layout.x - 0.5 * layout.width, y= layout.y
	}

	local HAlign = "left"

	Temp.map = NewIFText{
		x = 10,
		y = layout.height * -0.5 + 2,
		halign = HAlign, valign = "vcenter",
		font = "gamefont_tiny", 
		textw = layout.width - 20, texth = layout.height,
		startdelay=math.random()*0.5, nocreatebackground=1, 
	}
	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ifs_meta_opts_ListboxL_PopulateItem(Dest,Data)
	if(Data) then
		-- Show the data
		IFText_fnSetString(Dest.map,Data.showstr)
		if(Data.enable) then
			IFObj_fnSetColor(Dest.map,255,255,255)
		else
			IFObj_fnSetColor(Dest.map,128,128,128)
		end
	end

	IFObj_fnSetVis(Dest.map,Data)
end


ifs_meta_opts_name_listboxL_layout = {
	showcount = 9,
	enablecount = 8,
	font = "gamefont_tiny",
--	yTop = -130 + 13, -- auto-calc'd now
	yHeight = 26,
	ySpacing  = 0,
--	width = 260,
	x = 0,
--	slider = 1,
	CreateFn = ifs_meta_opts_ListboxL_CreateItem,
	PopulateFn = ifs_meta_opts_ListboxL_PopulateItem,
	no_mouse_move_select = 1,	
}

ifs_meta_opts = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = "temp_shell", -- WAS "ifs_meta",
	ZPos = 140,

	bNohelptext_backPC = 1,
	mouse_over_image = nil,

--	title = NewIFText {
--		string = "ifs.meta.main.selconfig",
--		font = "gamefont_medium",
--		textw = 460, -- center on screen. Fixme: do real centering!
--		ScreenRelativeX = 0.5, -- center
--		ScreenRelativeY = 0, -- top
--		y = 10,
--		inert = 1, -- delete out of Lua mem when pushed to C
--	},
	
	mEra = "classic",

	Enter = function(this, bFwd)
		this.mEra = "classic"
		
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call base class
		
		if( not ScriptCB_IsSplitscreen() ) then
			-- only to single player
			-- enable all maps after win a battle
			ifs_meta_opts_listbox_contents[5].enable = nil
			ifs_meta_opts_listbox_contents[6].enable = nil
			ifs_meta_opts_listbox_contents[7].enable = nil
			ifs_meta_opts_listbox_contents[8].enable = nil
			ifs_meta_opts_name_listboxL_layout.enablecount = 4			
			if( ScriptCB_IsMetaAllMapsOn() ) then
				ifs_meta_opts_listbox_contents[5].enable = 1
				ifs_meta_opts_listbox_contents[6].enable = 1
				ifs_meta_opts_listbox_contents[7].enable = 1
				ifs_meta_opts_listbox_contents[8].enable = 1
				ifs_meta_opts_name_listboxL_layout.enablecount = 8
			end
		end

		if(bFwd) then
			-- Reset listboxL, show it. [Remember, Lua starts at 1!]
			ifs_meta_opts_name_listboxL_layout.FirstShownIdx = 1
			ifs_meta_opts_name_listboxL_layout.SelectedIdx = 1
			ifs_meta_opts_name_listboxL_layout.CursorIdx = 1
			local Selection
			if( ScriptCB_IsSplitscreen() == 1) then
				ListManager_fnFillContents(this.listboxL,ifs_meta_opts_listbox_contents_split,ifs_meta_opts_name_listboxL_layout)
				Selection = ifs_meta_opts_listbox_contents_split[ifs_meta_opts_name_listboxL_layout.SelectedIdx]
			else
				ListManager_fnFillContents(this.listboxL,ifs_meta_opts_listbox_contents,ifs_meta_opts_name_listboxL_layout)
				Selection = ifs_meta_opts_listbox_contents[ifs_meta_opts_name_listboxL_layout.SelectedIdx]
			end
			
			IFImage_fnSetTexture(this.ShowTexture,Selection.mapname)
			ifs_meta_opts_fnMapDetail( this, Selection )
		else
			-- ScriptCB_PopScreen()
		end

	end,
	
	Input_GeneralLeft = function(this)
		--select the left hand side if they are not on one of the horizontal buttons
		if( this.CurButton == "back" or this.CurButton == "launch" or this.CurButton == "load" ) then
			--follow defaults
		else
			print("Input - Left")
			--Select the First Side
			Selection = ifs_meta_opts_listbox_contents[ifs_meta_opts_name_listboxL_layout.SelectedIdx]	
			if(Selection) then
				if (not Selection.side2) then
				--if the default is the right handside, and side2 is selectable, switch to side one
				else
					this.Side = 1
				end
				
				ifs_meta_opts_fnHilightSide(this,Selection)	
			end
		end
		
	end,

	Input_GeneralRight = function(this)
		if( this.CurButton == "back" or this.CurButton == "launch" or this.CurButton == "load" ) then
			--follow defaults
		else
			print("Input - Right")
			--Select the Second side, if there is one
			Selection = ifs_meta_opts_listbox_contents[ifs_meta_opts_name_listboxL_layout.SelectedIdx]	
			if(Selection) then
				if (not Selection.side2) then
			
				else
				--if the default is the leftside, and side2 is selectable, switch to side 2
					this.Side = 2
				end
				ifs_meta_opts_fnHilightSide(this,Selection)	
			end
		end
	
	end,

	Input_GeneralUp = function(this)
		-- If base class handled this work, then we're done
		--if(gShellScreen_fnDefaultInputUp(this)) then
		--	return
		--end

		local Selection
		this.Side= nil
		if( ScriptCB_IsSplitscreen() == 1) then
			ListManager_fnNavUp(this.listboxL,ifs_meta_opts_listbox_contents_split,ifs_meta_opts_name_listboxL_layout)
			Selection = ifs_meta_opts_listbox_contents_split[ifs_meta_opts_name_listboxL_layout.SelectedIdx]
		else
			ListManager_fnNavUp(this.listboxL,ifs_meta_opts_listbox_contents,ifs_meta_opts_name_listboxL_layout)
			Selection = ifs_meta_opts_listbox_contents[ifs_meta_opts_name_listboxL_layout.SelectedIdx]		
		end
		IFImage_fnSetTexture(this.ShowTexture,Selection.mapname)
		ifs_meta_opts_fnMapDetail( this, Selection )
	end,

	Input_GeneralDown = function(this)
		-- If base class handled this work, then we're done
		--if(gShellScreen_fnDefaultInputDown(this)) then
		--	return
		--end

		local Selection
		this.Side= nil
		if( ScriptCB_IsSplitscreen() == 1) then
			ListManager_fnNavDown(this.listboxL,ifs_meta_opts_listbox_contents_split,ifs_meta_opts_name_listboxL_layout)
			Selection = ifs_meta_opts_listbox_contents_split[ifs_meta_opts_name_listboxL_layout.SelectedIdx]
		else
			ListManager_fnNavDown(this.listboxL,ifs_meta_opts_listbox_contents,ifs_meta_opts_name_listboxL_layout)
			Selection = ifs_meta_opts_listbox_contents[ifs_meta_opts_name_listboxL_layout.SelectedIdx]		
		end
		IFImage_fnSetTexture(this.ShowTexture,Selection.mapname)
		ifs_meta_opts_fnMapDetail( this, Selection )
	end,

	Input_Accept = function(this)
		-- If base class handled this work, then we're done
		--if(gShellScreen_fnDefaultInputAccept(this)) then
		--	return
		--end

		if(this.CurButton == "back") then
			this:Input_Back(1)
		elseif (this.CurButton == "load") then
			ifs_meta_load.Mode = "Load"
            ifs_movietrans_PushScreen(ifs_meta_load)		
		elseif (this.CurButton == "launch") then 
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			
			metagame_state_fnInit(metagame_state)
			
			Selection = ifs_meta_opts_listbox_contents[ifs_meta_opts_name_listboxL_layout.SelectedIdx]
			this.mEra = Selection.era
			this.mStartConfig = Selection.config
			local eraNew = (this.mEra == "new")
			if(eraNew) then
				metagame_state_fnSetEra(metagame_state,"cw")
				ifs_meta_top_fnSetNew(metagame_state.team1,metagame_state.team2)
			else
				metagame_state_fnSetEra(metagame_state,"gcw")
				ifs_meta_top_fnSetClassic(metagame_state.team1,metagame_state.team2)
			end
			
			metagame_state_fnDistributePlanets(metagame_state)
			
			if(this.Side == 1 ) then
				metagame_state_local.mJoystickTeams[1] = 1
			elseif (this.Side == 2) then
				metagame_state_local.mJoystickTeams[1] = 2
			end
			metagame_state_local.mJoystickTeams[2] = 3-metagame_state_local.mJoystickTeams[1]
			metagame_state.pickteam = 3 - metagame_state_local.mJoystickTeams[1] -- will be put back to 1 when turn advances		
			metagame_state_local.mIsSplitscreen = ScriptCB_IsSplitscreen()

		
			if(metagame_state_local.mJoystickTeams[1]==1) then
				metagame_state.team2.aicontrol = 1
			elseif(metagame_state_local.mJoystickTeams[1]==2) then
				metagame_state.team1.aicontrol = 1
			end
		
			metagame_state_local.mIsSplitscreen = nil
			metagame_state.numhumans = 1
		
			
			
				
				
				
	
			-- Skip turn 0, as we've picked the planets
			metagame_state_fnAdvanceTurn(metagame_state)
			metagame_state_fnSelectBestPlanet(metagame_state)

			
			--ifs_meta_opts_fnEnterSinglePlayer( this )
			ScriptCB_SetIFScreen("ifs_meta_main")
			--ifs_meta_opts_fnAcceptSinglePlayer( this )
			
		elseif ( gMouseListBox ~= nil) then
			ScriptCB_SndPlaySound("shell_select_change")
			if( gMouseListBox.Layout.CursorIdx > ifs_meta_opts_name_listboxL_layout.enablecount ) then
				gMouseListBox.Layout.CursorIdx = gMouseListBox.Layout.SelectedIdx
			else
				gMouseListBox.Layout.SelectedIdx = gMouseListBox.Layout.CursorIdx				
			end
			ListManager_fnFillContents(gMouseListBox,gMouseListBox.Contents,gMouseListBox.Layout)
			
			local Selection
			this.Side= nil
			Selection = ifs_meta_opts_listbox_contents[ifs_meta_opts_name_listboxL_layout.SelectedIdx]		
			IFImage_fnSetTexture(this.ShowTexture,Selection.mapname)
			ifs_meta_opts_fnMapDetail( this, Selection )
		
		else
			print("+++++mouse click")
			if( mouse_over_image ) then
				if(( mouse_over_image.tag == "side_a") or (mouse_over_image.tag == "side_r") ) then
					this.Side = 1
				else
					this.Side = 2
				end
				print( "+++++side = ", this.Side )
				local Selection = ifs_meta_opts_listbox_contents[ifs_meta_opts_name_listboxL_layout.SelectedIdx]	
				if(Selection) then
					ifs_meta_opts_fnHilightSide(this,Selection)
				end
			end

		end
		
	end,

	Input_Back = function(this)
		ScriptCB_PopScreen(  ) 
	end,
	
	UpdateUIMouseOver = function(this, model)
		print( "+++mouse is over", model.tag )
		mouse_over_image = model
	end,
}

function ifs_meta_opts_fnBuildScreen(this)
	local w,h,wFactor = ScriptCB_GetSafeScreenInfo() -- of the usable screen

	local box_width, box_height, box_y, img_x, img_y
	local map_l, map_r, map_t, map_b
	local listbox_x, listbox_y
	if(gPlatformStr == "PS2") then
		box_width = w * 0.45
		box_height = h * 0.7
		box_y = 10
		box_x = 10
		img_x = w * 0.8
		img_y = h * 0.46
		map_l = -100
		map_r = 102
		map_t = -90
		map_b = 81
		attackmap_x = -170
		listbox_x = w * 0.31
		listbox_y = h * 0.52
		listbox_w = w * 0.56
		listbox_h = h * 0.65
	elseif(gPlatformStr == "XBox") then
		w = w * wFactor
		if( wFactor ~= 1 ) then
			box_width = w * 0.4
			box_height = h * 0.7	
			box_y = 10	
			box_x = 0
			img_x = w * 0.8
			img_y = h * 0.49
			map_l = -105
			map_r = 162
			map_t = -90
			map_b = 81
			attackmap_x = -170
			listbox_x = w * 0.34
			listbox_y = h * 0.52
			listbox_w = w * 0.56
			listbox_h = h * 0.65
		else		 
			box_width = w * 0.45
			box_height = h * 0.7	
			box_y = 10	
			box_x = 0
			img_x = w * 0.82
			img_y = h * 0.49
			map_l = -105
			map_r = 125
			map_t = -90
			map_b = 81
			attackmap_x = -170
			listbox_x = w * 0.31
			listbox_y = h * 0.52
			listbox_w = w * 0.56
			listbox_h = h * 0.65
		end
	elseif(gPlatformStr == "PC") then
		box_width = w * 0.45
		box_height = h * 0.8
		box_y = 0	
		box_x = 0
		img_x = w * 0.8
		img_y = h * 0.35
		map_l = -155
		map_r = 160
		map_t = -98
		map_b = 91
		attackmap_x = -170
		listbox_x = w * 0.31
		listbox_y = h * 0.52
		listbox_w = w * 0.56
		listbox_h = h * 0.65
	end

	ifs_meta_opts_name_listboxL_layout.width = (w * 0.60) - 35

	local ListHeightL = ifs_meta_opts_name_listboxL_layout.showcount * (ifs_meta_opts_name_listboxL_layout.yHeight + ifs_meta_opts_name_listboxL_layout.ySpacing)

	--local listBoxX = ifs_meta_opts_name_listboxL_layout.width * 0.5 + 18
	local localListBoxW = ifs_meta_opts_name_listboxL_layout.width +20
	this.listboxL = NewButtonWindow { 
		ZPos = 120,
		font = "gamefont_tiny",
		x = listbox_x, 
		y = listbox_y,
		ScreenRelativeX = 0.0, -- left edge of screen
		ScreenRelativeY = 0.0, -- middle, vertically
		--width = localListBoxW,
		--height = ListHeightL,
		width = listbox_w,
		height = ListHeightL,		
		rotY = 35,
		titleText = "ifs.meta.main.selconfig"

	}
	ListManager_fnInitList(this.listboxL,ifs_meta_opts_name_listboxL_layout)

	-- Keep this much of the texture (some wasted space on bottom)
	local MapPreviewKeep = 0.8
	map_b = map_t + ((map_b - map_t) * MapPreviewKeep)

	this.ShowTexture = NewIFImage { 
		ScreenRelativeX = 0,
		ScreenRelativeY = 0,
		UseSafezone = 0,

		ZPos = 120,
		texture = "gc_cfg1", 
		x = img_x, 
		y = img_y,
		localpos_l = map_l, localpos_r = map_r,
		localpos_t = map_t, localpos_b = map_b,
		uvs_b = MapPreviewKeep, -- slice off bottom 20% of texture
		alpha = 0.5,
		rotY = -35,
		-- Size, UVs aren't fully specified here, but in NewIFShellScreen()
	}

	this.MapDetail = NewIFContainer {
		ScreenRelativeX = 0.75, -- center filled in later based on screensize
		ScreenRelativeY = 0.50,	
		rotY = -35,
		ZPos = 120,
	
		box = NewButtonWindow {
			titleText = "ifs.meta.Configs.detail",
			font = "gamefont_tiny",
			--x = attackmap_x,
			--y = attackmap_y,
			x = box_x,
			y = box_y,
			width = box_width,
			height = box_height,
			ZPos = 160,
		},

		text1 = NewIFText {
			string = "ifs.meta.Configs.1",
			font = "gamefont_tiny",
			textw = box_width - 16,
			texth = 200,
--			x = 0, -- commented out == auto-determine it from textw
			y = 10,
			ZPos = 120,
			nocreatebackground = 1,
		},
	}

	this.MapDetail.text1.x = this.MapDetail.text1.x + 10
		
--	local imageW = w - ifs_meta_opts_name_listboxL_layout.width - 70
--	this.previewImage = NewIFImage {
--			y = 0, x = listBoxX + localListBoxW ,
--			localpos_l = -imageW*0.5, localpos_r = imageW*0.5,
--			localpos_t = -imageW*0.1, localpos_b = imageW*0.1,
--			inertUVs = 1,
--			texture = "gc_cfg1",
--			ZPos = 130, -- a bit behind the text
--		}

	this.buttons = NewIFContainer {
		ScreenRelativeX = 0.0, -- center
		ScreenRelativeY = 0.0, -- top
		
		--	ScreenRelativeX = 0.4,
		--	ScreenRelativeY = 0.5,
		--	y = 20,	
	}
	this.buttons.back = NewClickableIFButton 
	{ 
		x = 0 + ( w*.2 )/2,
		y = h, 
		btnw = w*.2, 
		btnh = ScriptCB_GetFontHeight("gamefont_large"),
		--font = "gamefont_tiny", 
		bg_width = w*.25,
		nocreatebackground = 1,
	}
	this.buttons.back.label.bHotspot = 1
	this.buttons.back.label.fHotspotW = this.buttons.back.btnw
	this.buttons.back.label.fHotspotH = this.buttons.back.btnh
	this.buttons.back.tag = "back"
	RoundIFButtonLabel_fnSetString(this.buttons.back ,"common.back")
	
	this.buttons.launch = NewClickableIFButton 
	{ 
		x = w - ( w*.2 )/2,
		y = h, 
		btnw = w*.2, 
		btnh = ScriptCB_GetFontHeight("gamefont_large"),
		--font = "gamefont_large", 
		bg_width = w*.25,
		nocreatebackground = 1,
	}
	this.buttons.launch.label.bHotspot = 1
	this.buttons.launch.label.fHotspotW = this.buttons.launch.btnw
	this.buttons.launch.label.fHotspotH = this.buttons.launch.btnh
	this.buttons.launch.tag = "launch"
	RoundIFButtonLabel_fnSetString(this.buttons.launch ,"ifs.onlinelobby.launch")

	this.buttons.load = NewClickableIFButton { 
		x = w/2, --( w*.1 ),
		y = h, 
		btnw = w*.25, 
		btnh = ScriptCB_GetFontHeight("gamefont_large"),
		--font = "gamefont_large", 
		bg_width = w*.25,
		nocreatebackground = 1,
	}
	this.buttons.load.label.bHotspot = 1
	this.buttons.load.label.fHotspotW = this.buttons.load.btnw
	this.buttons.load.label.fHotspotH = this.buttons.load.btnh
	this.buttons.load.tag = "load"
	RoundIFButtonLabel_fnSetString(this.buttons.load ,"ifs.meta.load.load")
	
	----------Stuff that was originally in ifs_meta_top.lua
	button_rot_x = -25
	button_rot_y = -30
end


function ifs_meta_opts_fnAcceptSinglePlayer(this)
		local Selection 
		Selection = ifs_meta_opts_listbox_contents[ifs_meta_opts_name_listboxL_layout.SelectedIdx]					
		metagame_state_local.mJoystickTeams[1] = Selection.default
		metagame_state_local.mJoystickTeams[2] = 3-metagame_state_local.mJoystickTeams[1]

		metagame_state.pickteam = 3 - metagame_state_local.mJoystickTeams[1] -- will be put back to 1 when turn advances		
		metagame_state_local.mIsSplitscreen = ScriptCB_IsSplitscreen()

		if(not metagame_state_local.mIsSplitscreen) then
			if(metagame_state_local.mJoystickTeams[1]==1) then
				metagame_state.team2.aicontrol = 1
			elseif(metagame_state_local.mJoystickTeams[1]==2) then
				metagame_state.team1.aicontrol = 1
			end
		end
	
		-- Skip turn 0, as we've picked the planets
		metagame_state_fnAdvanceTurn(metagame_state)
		metagame_state_fnSelectBestPlanet(metagame_state)

		ScriptCB_SetIFScreen("ifs_meta_main")
end

function ifs_meta_opts_fnEnterSinglePlayer(this)

		local Selection
	
			Selection = ifs_meta_opts_listbox_contents[ifs_meta_opts_name_listboxL_layout.SelectedIdx]

		-- set era
		if( Selection.era == "new" ) then		
			-- clone war
			metagame_state_fnSetEra(metagame_state,"cw")
		else
			-- galactic civil war
			metagame_state_fnSetEra(metagame_state,"gcw")
		end		

		if(1) then		
			-- Do all initial creations
			metagame_state_fnInit(metagame_state)

			if(ScriptCB_IsMetagameStateSaved()) then
				-- Reload state once we've cleaned it out.
				ScriptCB_LoadMetagameState()
				if (metagame_state_local.mIsSplitscreen) then
					ScriptCB_SetSplitscreen(1)
				end							
			else
				if(Selection.era == "new") then
					metagame_state_fnSetEra(metagame_state,"cw")
					ifs_meta_top_fnSetNew(metagame_state.team1,metagame_state.team2)
				else
					metagame_state_fnSetEra(metagame_state,"gcw")
					ifs_meta_top_fnSetClassic(metagame_state.team1,metagame_state.team2)
				end
			--	metagame_state_local.mJoystickTeams[1] = 0
			--	metagame_state_local.mJoystickTeams[2] = 0
			--	metagame_state.pickteam = 2 -- will be put back to 1 when turn advances
				metagame_state_fnDistributePlanets(metagame_state)				
			end
		end
end

function ifs_meta_opts_fnMapDetail(this, Selection)
	local era
	if( Selection.era == "classic" ) then
		era = ScriptCB_getlocalizestr("common.era.gcw")
	else
		era = ScriptCB_getlocalizestr("common.era.cw")			
	end
	if( Selection.side1 ) then
		this.side1 = ScriptCB_getlocalizestr(Selection.side1)
	else
		this.side1 = ""
	end
	if( Selection.side2 ) then
		this.side2 = ScriptCB_getlocalizestr(Selection.side2)
	else
		this.side2 = ""
	end		
	local ShowUStr = ScriptCB_usprintf("ifs.meta.Configs.text", era, this.side1, this.side2 )
	if(gPlatformStr == "PC") then
		IFText_fnSetUString( this.MapDetail.text1, "" )
	else
		IFText_fnSetUString( this.MapDetail.text1, ShowUStr )
	end
	
	local eraNew = ( Selection.era == "new")
	IFObj_fnSetVis(this.MapDetail.side_a,not eraNew)
	IFObj_fnSetVis(this.MapDetail.side_i,not eraNew)
	IFObj_fnSetVis(this.MapDetail.side_c,eraNew)
	IFObj_fnSetVis(this.MapDetail.side_r,eraNew)
	IFObj_fnSetVis(this.MapDetail.a,not eraNew)
	IFObj_fnSetVis(this.MapDetail.i,not eraNew)
	IFObj_fnSetVis(this.MapDetail.c,eraNew)
	IFObj_fnSetVis(this.MapDetail.r,eraNew)
	---Hide certain stuff if you can't select sides
	if (not Selection.side2)  then
		if( Selection.default == 1 ) then	
			IFObj_fnSetVis(this.MapDetail.c, nil )
			IFObj_fnSetVis(this.MapDetail.side_c,nil)
			
			IFObj_fnSetVis(this.MapDetail.i, nil )
			IFObj_fnSetVis(this.MapDetail.side_i,nil )
			
			
		
		else
			IFObj_fnSetVis(this.MapDetail.a, nil )
			IFObj_fnSetVis(this.MapDetail.side_a,nil)
			
			IFObj_fnSetVis(this.MapDetail.r, nil )
			IFObj_fnSetVis(this.MapDetail.side_r,nil )
		
		end
	end
		
	ifs_meta_opts_fnHilightSide(this, Selection)
	
	ifs_meta_opts_fnSetButtonPos( this )
end

function ifs_meta_opts_fnSetButtonPos( this )
	if( ifs_meta_opts_name_listboxL_layout.SelectedIdx <= 4 ) then
		local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
		IFObj_fnSetPos( this.MapDetail.side_a, 10, 80 )
		IFObj_fnSetPos( this.MapDetail.side_r, 10, 80 )
		IFObj_fnSetPos( this.MapDetail.side_i, 10, 80 )
		IFObj_fnSetPos( this.MapDetail.side_c, 10, 80 )
		
		IFObj_fnSetPos( this.MapDetail.a, 10, 195 )
		IFObj_fnSetPos( this.MapDetail.r, 10, 195 )
		IFObj_fnSetPos( this.MapDetail.i, 10, 195 )
		IFObj_fnSetPos( this.MapDetail.c, 10, 195 )		
	else
		IFObj_fnSetPos( this.MapDetail.side_a, -60, 80 )
		IFObj_fnSetPos( this.MapDetail.side_r, -60, 80 )
		IFObj_fnSetPos( this.MapDetail.side_i, 70, 80 )
		IFObj_fnSetPos( this.MapDetail.side_c, 70, 80 )
		
		IFObj_fnSetPos( this.MapDetail.a, -60, 195 )
		IFObj_fnSetPos( this.MapDetail.r, -60, 195 )
		IFObj_fnSetPos( this.MapDetail.i, 70, 195 )
		IFObj_fnSetPos( this.MapDetail.c, 70, 195 )
	end
end

ifs_meta_opts_fnBuildScreen(ifs_meta_opts)
ifs_meta_opts_fnMakeIcons(ifs_meta_opts)
ifs_meta_opts_fnBuildScreen = nil

AddIFScreen(ifs_meta_opts,"ifs_meta_opts")
