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
	{ showstr = "ifs.meta.configs.5", era = "classic", mapname = "gc_cfg5", config = {{1,2},{2,2},{2,2},{1,1},{1,2},{1,1}}, default = 1, side1 = "common.sides.all.name", side2 = "common.sides.imp.name", enable = nil },
	{ showstr = "ifs.meta.configs.6", era = "classic", mapname = "gc_cfg6", config = {{1,1},{2,2},{1,2},{1,2},{2,2},{1,1}}, default = 1, side1 = "common.sides.all.name", side2 = "common.sides.imp.name", enable = nil },
	{ showstr = "ifs.meta.configs.7", era = "new", mapname = "gc_cfg7",		config = {{2,2},{1,2},{1,2},{2,2},{1,1},{1,1}}, default = 1, side1 = "common.sides.rep.name", side2 = "common.sides.cis.name", enable = nil },
	{ showstr = "ifs.meta.configs.8", era = "new", mapname = "gc_cfg8",		config = {{1,1},{1,1},{2,2},{2,2},{1,2},{1,2}}, default = 1, side1 = "common.sides.rep.name", side2 = "common.sides.cis.name", enable = nil },
}

ifs_meta_opts_listbox_contents_split = 
{			     --																		BES   KAS   NAB   RV    TAT   YAV
	{ showstr = "ifs.meta.configs.5", era = "classic", mapname = "gc_cfg5", config = {{1,2},{2,2},{2,2},{1,1},{1,2},{1,1}}, default = 1, side1 = "common.sides.all.name", side2 = "common.sides.imp.name", enable = 1 },
	{ showstr = "ifs.meta.configs.6", era = "classic", mapname = "gc_cfg6", config = {{1,1},{2,2},{1,2},{1,2},{2,2},{1,1}}, default = 1, side1 = "common.sides.all.name", side2 = "common.sides.imp.name", enable = 1 },
	{ showstr = "ifs.meta.configs.7", era = "new", mapname = "gc_cfg7",		config = {{2,2},{1,2},{1,2},{2,2},{1,1},{1,1}}, default = 1, side1 = "common.sides.rep.name", side2 = "common.sides.cis.name", enable = 1 },
	{ showstr = "ifs.meta.configs.8", era = "new", mapname = "gc_cfg8",		config = {{1,1},{1,1},{2,2},{2,2},{1,2},{1,2}}, default = 1, side1 = "common.sides.rep.name", side2 = "common.sides.cis.name", enable = 1 },
}

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
	enablecount = 4,
	font = "gamefont_tiny",
--	yTop = -130 + 13, -- auto-calc'd now
	yHeight = 26,
	ySpacing  = 0,
--	width = 260,
	x = 0,
--	slider = 1,
	CreateFn = ifs_meta_opts_ListboxL_CreateItem,
	PopulateFn = ifs_meta_opts_ListboxL_PopulateItem,
}

ifs_meta_opts = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = "shell_sub_left", -- WAS "ifs_meta",
	ZPos = 120,

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
			
--			ifs_missionselect_fnSetCurButton(this,nil)
		else
			-- ScriptCB_PopScreen()
		end
	end,
	
	Input_GeneralLeft = function(this)
	end,

	Input_GeneralRight = function(this)
	end,

	Input_GeneralUp = function(this)
		local Selection
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
		local Selection
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
		local Selection 
        ifelm_shellscreen_fnPlaySound(this.acceptSound)
		if( ScriptCB_IsSplitscreen() == 1) then
			Selection = ifs_meta_opts_listbox_contents_split[ifs_meta_opts_name_listboxL_layout.SelectedIdx]
		else
			Selection = ifs_meta_opts_listbox_contents[ifs_meta_opts_name_listboxL_layout.SelectedIdx]
		end
		this.mEra = Selection.era
		this.mStartConfig = Selection.config
		if( not ScriptCB_IsSplitscreen() ) then
			if(ifs_meta_opts_name_listboxL_layout.SelectedIdx <= 4 ) then
				-- don't need to select side
				-- go to ifs_meta_main directly
				ifs_meta_opts_fnEnterSinglePlayer( this )
				ifs_meta_opts_fnAcceptSinglePlayer( this )
			else
				ifs_movietrans_PushScreen(ifs_meta_top)
			end
		else
			ifs_movietrans_PushScreen(ifs_meta_top)
		end
	end,

	Input_Back = function(this)
		ScriptCB_PopScreen( "ifs_meta_new_load" ) -- default action
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
		box_height = h * 0.7
		box_y = 10	
		box_x = 0
		img_x = w * 0.8
		img_y = h * 0.45
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

	ifs_meta_opts_name_listboxL_layout.width = (w * 0.60) - 35
-- 	if(gPlatformStr == "PS2") then
-- 		ifs_meta_opts_name_listboxL_layout.showcount = 9
-- 	end

	if(gLangStr ~= "english") then
		ifs_meta_opts_name_listboxL_layout.showcount = 5
		ifs_meta_opts_name_listboxL_layout.yHeight = 45
		ifs_meta_opts_name_listboxL_layout.slider = 1
	end

	local ListHeightL = ifs_meta_opts_name_listboxL_layout.showcount * (ifs_meta_opts_name_listboxL_layout.yHeight + ifs_meta_opts_name_listboxL_layout.ySpacing) + 50

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
		height = listbox_h,		
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
			ZPos = 120,
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

	if((gLangStr ~= "english") and (gPlatformStr ~= "PC")) then
		this.listboxL.titleBarElement.font = "gamefont_tiny"
		this.MapDetail.box.titleBarElement.font = "gamefont_tiny"
	end
	
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
		if( ScriptCB_IsSplitscreen() == 1) then
			Selection = ifs_meta_opts_listbox_contents_split[ifs_meta_opts_name_listboxL_layout.SelectedIdx]
		else
			Selection = ifs_meta_opts_listbox_contents[ifs_meta_opts_name_listboxL_layout.SelectedIdx]
		end

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
				metagame_state_local.mJoystickTeams[1] = 0
				metagame_state_local.mJoystickTeams[2] = 0
				metagame_state.pickteam = 2 -- will be put back to 1 when turn advances
				metagame_state_fnDistributePlanets(metagame_state)				
			end
		end
end

function ifs_meta_opts_fnMapDetail(this, Selection)
	local era, side1, side2
	if( Selection.era == "classic" ) then
		era = ScriptCB_getlocalizestr("common.era.gcw")
	else
		era = ScriptCB_getlocalizestr("common.era.cw")			
	end
	if( Selection.side1 ) then
		side1 = ScriptCB_getlocalizestr(Selection.side1)
	else
		side1 = ""
	end
	if( Selection.side2 ) then
		side2 = ScriptCB_getlocalizestr(Selection.side2)
	else
		side2 = ""
	end		
	local ShowUStr = ScriptCB_usprintf("ifs.meta.Configs.text", era, side1, side2 )
	IFText_fnSetUString( this.MapDetail.text1, ShowUStr )
	-- Debug the centering...
--	IFText_fnSetString( this.MapDetail.text1, "1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1" )
end


ifs_meta_opts_fnBuildScreen(ifs_meta_opts)
ifs_meta_opts_fnBuildScreen = nil

AddIFScreen(ifs_meta_opts,"ifs_meta_opts")
