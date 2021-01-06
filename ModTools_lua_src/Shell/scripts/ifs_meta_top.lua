--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


ifs_meta_top_IconNames = { "side_a", "side_i", "side_r", "side_c" }

-- Helper functions, sets up various team constants for the sides.
-- The two teams passed in must be metagame_state.team1 and
-- metagame_state.team2, in the desired order.
function ifs_meta_top_fnSetClassic(RebelTeam,EmpireTeam)
	RebelTeam.teamname = "common.sides.all.name"
	RebelTeam.teamname2 = "common.sides.all.longname"
	RebelTeam.icon = "reb_own_icon"
	RebelTeam.char = "a"
	RebelTeam.shortname = "all"
	RebelTeam.ColorR = 57 -- Photoshop legal blue
	RebelTeam.ColorG = 83
	RebelTeam.ColorB = 164
	RebelTeam.bSetsBlockade = nil

	EmpireTeam.teamname = "common.sides.imp.name"
	EmpireTeam.teamname2 = "common.sides.imp.longname"
	EmpireTeam.icon = "imp_own_icon"
	EmpireTeam.char = "i"
	EmpireTeam.shortname = "imp"
	EmpireTeam.ColorR = 239 -- Photoshop legal red
	EmpireTeam.ColorG = 59
	EmpireTeam.ColorB = 42
	EmpireTeam.bSetsBlockade = nil

	local NumNormalPlanets = metagame_table.getnumPlanets()
	metagame_state.planets.hoth.pickorder = 1
	metagame_state.planets.hoth.owner1 = 1
	metagame_state.planets.hoth.owner2 = 1
	metagame_state.planets.endor.owner1 = 2
	metagame_state.planets.endor.owner2 = 2
	metagame_state.planets.endor.pickorder = NumNormalPlanets
end

-- Helper functions, sets up various team constants for the sides.
-- The two teams passed in must be metagame_state.team1 and
-- metagame_state.team2, in the desired order.
function ifs_meta_top_fnSetNew(RepTeam,CISTeam)
	RepTeam.teamname = "common.sides.rep.name"
	RepTeam.teamname2 = "common.sides.rep.longname"
	RepTeam.icon = "rep_own_icon"
	RepTeam.char = "r"
	RepTeam.shortname = "rep"
	RepTeam.ColorR = 57 -- Photoshop legal blue
	RepTeam.ColorG = 83
	RepTeam.ColorB = 164
	RepTeam.bSetsBlockade = nil

	CISTeam.teamname = "common.sides.cis.name"
	CISTeam.teamname2 = "common.sides.cis.longname"
	CISTeam.icon = "cis_own_icon"
	CISTeam.char = "c"
	CISTeam.shortname = "cis"
	CISTeam.ColorR = 239 -- Photoshop legal red
	CISTeam.ColorG = 59
	CISTeam.ColorB = 42
	CISTeam.bSetsBlockade = 1

	local NumNormalPlanets = metagame_table.getnumPlanets()
	metagame_state.planets.kamino.pickorder = 1
	metagame_state.planets.geonosis.pickorder = NumNormalPlanets
	metagame_state.planets.kamino.owner1 = 1
	metagame_state.planets.kamino.owner2 = 1
	metagame_state.planets.geonosis.owner1 = 2
	metagame_state.planets.geonosis.owner2 = 2
end

function ifs_meta_top_fnHilightSide(this)

	local Selected
	local Selected_s1
	local Selected_s2
	
	if( ScriptCB_IsSplitscreen( ) ) then
		--if( 1 ) then
		Selected_s1 = "side_" .. this.CurButton_s1
		Selected_s2 = "side_" .. this.CurButton_s2
	else
		Selected = "side_" .. this.CurButton
	end

	for i = 1,table.getn(ifs_meta_top_IconNames) do
		local NameStr = ifs_meta_top_IconNames[i]

		print( "+++NameStr", NameStr, " Selected_s1 = ", Selected_s1 )
		print( "+++NameStr", NameStr, " Selected_s2 = ", Selected_s2 )
		local NewAlpha = 0.5
		local NewAlpha2 = 0.5
		
		if( ScriptCB_IsSplitscreen( ) ) then
			--if( 1 ) then
			if(NameStr == Selected_s1) then
				NewAlpha = 1.0
			end
			if(NameStr == Selected_s2) then
				NewAlpha2 = 1.0
			end
			ifelm_shellscreen_fnPlaySound("shell_select_change")
			IFObj_fnSetAlpha(this.buttons_s1[NameStr],NewAlpha)			
			IFObj_fnSetAlpha(this.buttons_s2[NameStr],NewAlpha2)
		else
			if(NameStr == Selected) then
				NewAlpha = 1.0
			end
			ifelm_shellscreen_fnPlaySound("shell_select_change")
			IFObj_fnSetAlpha(this.buttons[NameStr],NewAlpha)
		end
	end

end

ifs_meta_top = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = "shell_sub_left", -- WAS "ifs_meta",

	button_rot_x = -25,
	button_rot_y = -30,

	--title = NewIFText {
	--	string = "ifs.meta.title",
	--	font = "gamefont_large",
	--	textw = 460,
	--	y = 0,
	--	valign = "top",
	--	ScreenRelativeX = 0.5, -- center
	--	ScreenRelativeY = 0, -- top
	--	inert = 1,
	--	nocreatebackground = 1,
	--},
	
	subtitle = NewIFText {
		string = "ifs.meta.top.subtitle",
		font = "gamefont_medium",
		textw = 460,
		ScreenRelativeX = 0.4, -- center
		ScreenRelativeY = 0, -- top
		inert = 1,
		nocreatebackground = 1,
	},

	subtitleSp = NewIFText {
		string = "ifs.meta.top.subtitle",
		font = "gamefont_medium",
		textw = 460,
		ScreenRelativeX = 0.48, -- center
		ScreenRelativeY = 0.07, -- top
		inert = 1,
		nocreatebackground = 1,
	},

	buttonWindow = NewButtonWindow { 
		ZPos = 200, 
		ScreenRelativeX = 0.4,
		ScreenRelativeY = 0.5,
		y = 20,
		width = 400,
		height = 320,
		titleText = "ifs.meta.title",
	},	

	buttonWindowSp = NewButtonWindow { 
		ZPos = 200, 
		ScreenRelativeX = 0.4,
		ScreenRelativeY = 0.5,
		y = 10,
		width = 400,
		height = 340,
		titleText = "ifs.meta.title",
	},	

	buttons = NewIFContainer {
		ScreenRelativeX = 0.4,
		ScreenRelativeY = 0.5,
		y = 20,		
	},

	buttons_s1 = NewIFContainer {
		ScreenRelativeX = 0.4,
		ScreenRelativeY = 0.5,
	},

	buttons_s2 = NewIFContainer {
		ScreenRelativeX = 0.4,
		ScreenRelativeY = 0.5,
	},

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd)

		player1_selected = nil		
		player2_selected = nil

		if(bFwd) then		
			-- Do all initial creations
			metagame_state_fnInit(metagame_state)

			if(ScriptCB_IsMetagameStateSaved()) then
				-- Reload state once we've cleaned it out.
				ScriptCB_LoadMetagameState()
				if (metagame_state_local.mIsSplitscreen) then
					ScriptCB_SetSplitscreen(1)
				end

				-- Set metagame rejoin info if it's host
				--if((ScriptCB_InNetGame()) and (ScriptCB_GetAmHost())) then
				--	ScriptCB_SetMetagameRulesOn( 1 )
				--	ScriptCB_BeginMPMetagame()
				--end
				
				ifs_movietrans_PushScreen(ifs_meta_main)
			else
				if(ifs_meta_opts.mEra == "new") then
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

				if(ifs_missionselect.bForMP) then
					if(ScriptCB_GetAmHost()) then
						if(ifs_mp_gameopts.bDedicated) then
							ScriptCB_BeginMPMetagame()
							ifs_movietrans_PushScreen(ifs_meta_main)
						end
					end
				end
				
			end
		end

		local eraNew = (ifs_meta_opts.mEra == "new")
		IFButton_fnSelect(gCurHiliteButton,nil)
		
		IFObj_fnSetVis(this.buttons.side_a,not eraNew)
		IFObj_fnSetVis(this.buttons.side_i,not eraNew)
		IFObj_fnSetVis(this.buttons.side_c,eraNew)
		IFObj_fnSetVis(this.buttons.side_r,eraNew)
		IFObj_fnSetVis(this.buttons.a,not eraNew)
		IFObj_fnSetVis(this.buttons.i,not eraNew)
		IFObj_fnSetVis(this.buttons.c,eraNew)
		IFObj_fnSetVis(this.buttons.r,eraNew)

		IFObj_fnSetVis(this.buttons_s1.side_a,not eraNew)
		IFObj_fnSetVis(this.buttons_s1.side_i,not eraNew)
		IFObj_fnSetVis(this.buttons_s1.side_c,eraNew)
		IFObj_fnSetVis(this.buttons_s1.side_r,eraNew)
		IFObj_fnSetVis(this.buttons_s1.a,not eraNew)
		IFObj_fnSetVis(this.buttons_s1.i,not eraNew)
		IFObj_fnSetVis(this.buttons_s1.c,eraNew)
		IFObj_fnSetVis(this.buttons_s1.r,eraNew)

		IFObj_fnSetVis(this.buttons_s2.side_a,not eraNew)
		IFObj_fnSetVis(this.buttons_s2.side_i,not eraNew)
		IFObj_fnSetVis(this.buttons_s2.side_c,eraNew)
		IFObj_fnSetVis(this.buttons_s2.side_r,eraNew)
		--IFObj_fnSetVis(this.buttons_s2.a,not eraNew)
		--IFObj_fnSetVis(this.buttons_s2.i,not eraNew)
		--IFObj_fnSetVis(this.buttons_s2.c,eraNew)
		--IFObj_fnSetVis(this.buttons_s2.r,eraNew)
		
		local Selection
		if( ScriptCB_IsSplitscreen() == 1) then
			Selection = ifs_meta_opts_listbox_contents_split[ifs_meta_opts_name_listboxL_layout.SelectedIdx]
		else
			Selection = ifs_meta_opts_listbox_contents[ifs_meta_opts_name_listboxL_layout.SelectedIdx]
		end

		if(eraNew) then
			if( Selection ) then
				if( Selection.default == 1 ) then			
					this.CurButton = "r"
				else
					this.CurButton = "c"
				end
			else
				this.CurButton = "r"
			end
			this.CurButton_s1 = "r"
			this.CurButton_s2 = "r"
			
			metagame_state_fnSetEra(metagame_state,"cw")
		else
			if( Selection ) then			
				if( Selection.default == 1 ) then			
					this.CurButton = "a"
				else
					this.CurButton = "i"
				end
			else
				this.CurButton = "a"
			end
			this.CurButton_s1 = "a"
			this.CurButton_s2 = "a"	
			
			metagame_state_fnSetEra(metagame_state,"gcw")
		end
		gCurHiliteButton = this.buttons[this.CurButton]
		IFButton_fnSelect(gCurHiliteButton,1)

		ifs_meta_top_fnHilightSide(this) -- always update hilight
		
		if( ScriptCB_IsSplitscreen( ) ) then
			--if( 1 ) then
			IFObj_fnSetVis(this.buttons.side_a,nil)
			IFObj_fnSetVis(this.buttons.side_i,nil)
			IFObj_fnSetVis(this.buttons.side_c,nil)
			IFObj_fnSetVis(this.buttons.side_r,nil)
			IFObj_fnSetVis(this.buttons.a,nil)
			IFObj_fnSetVis(this.buttons.i,nil)
			IFObj_fnSetVis(this.buttons.c,nil)
			IFObj_fnSetVis(this.buttons.r,nil)
			
			IFObj_fnSetVis( this.buttonWindow, nil )
			IFObj_fnSetVis( this.buttonWindowSp, gPlatformStr ~= "PC" )
			
			IFObj_fnSetVis( this.subtitle, nil )
			IFObj_fnSetVis( this.subtitleSp, gPlatformStr ~= "PC" )
		else
			IFObj_fnSetVis(this.buttons_s1.side_a,nil)
			IFObj_fnSetVis(this.buttons_s1.side_i,nil)
			IFObj_fnSetVis(this.buttons_s1.side_c,nil)
			IFObj_fnSetVis(this.buttons_s1.side_r,nil)
			IFObj_fnSetVis(this.buttons_s1.a,nil)
			IFObj_fnSetVis(this.buttons_s1.i,nil)
			IFObj_fnSetVis(this.buttons_s1.c,nil)
			IFObj_fnSetVis(this.buttons_s1.r,nil)

			IFObj_fnSetVis(this.buttons_s2.side_a,nil)
			IFObj_fnSetVis(this.buttons_s2.side_i,nil)
			IFObj_fnSetVis(this.buttons_s2.side_c,nil)
			IFObj_fnSetVis(this.buttons_s2.side_r,nil)
			
			IFObj_fnSetVis( this.buttonWindow, 1 )
			IFObj_fnSetVis( this.buttonWindowSp, nil )

			IFObj_fnSetVis( this.subtitle, 1 )
			IFObj_fnSetVis( this.subtitleSp, nil )
		end
		
		ScriptCB_ReadAllControllers(1) -- note we need this mode on this screen
	end,

	Exit = function(this, bFwd)
--		gIFShellScreenTemplate_fnExit(this)
		ScriptCB_ReadAllControllers(nil) -- turn off once we're done with this screen
	end,

	player1_selected = nil,	
	player2_selected = nil,
	
	Input_Accept = function(this, joystick)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		if(gPlatformStr ~= "PC") then
			if( ScriptCB_IsSplitscreen( ) ) then
				--if( 1 ) then
				if( joystick == 0 ) then
					--player 1
					player1_selected = 1			
					if(this.CurButton_s1 == "a") then
						metagame_state_local.mJoystickTeams[1] = 1
					elseif (this.CurButton_s1 == "i") then
						metagame_state_local.mJoystickTeams[1] = 2
					elseif (this.CurButton_s1 == "r") then
						metagame_state_local.mJoystickTeams[1] = 1
					else
						metagame_state_local.mJoystickTeams[1] = 2
					end
				else
					--player 2
					player2_selected = 1
					if(this.CurButton_s2 == "a") then
						metagame_state_local.mJoystickTeams[2] = 1
					elseif (this.CurButton_s2 == "i") then
						metagame_state_local.mJoystickTeams[2] = 2
					elseif (this.CurButton_s2 == "r") then
						metagame_state_local.mJoystickTeams[2] = 1
					else
						metagame_state_local.mJoystickTeams[2] = 2
					end			
				end
				if( (not player1_selected) or (not player2_selected) ) then
					return
				end
				if( metagame_state_local.mJoystickTeams[1] == metagame_state_local.mJoystickTeams[2] ) then
					if(metagame_state_local.mJoystickTeams[1]==1) then
						metagame_state.team2.aicontrol = 1
						-- joyStick for AI
						metagame_state_local.mJoystickTeams[3] = 2
						elseif(metagame_state_local.mJoystickTeams[1]==2) then
						metagame_state.team1.aicontrol = 1
						-- joyStick for AI
						metagame_state_local.mJoystickTeams[3] = 1
					end			
				end
			else			
				if(this.CurButton == "a") then
					metagame_state_local.mJoystickTeams[1] = 1
				elseif (this.CurButton == "i") then
					metagame_state_local.mJoystickTeams[1] = 2
				elseif (this.CurButton == "r") then
					metagame_state_local.mJoystickTeams[1] = 1
				else
					metagame_state_local.mJoystickTeams[1] = 2
				end
				metagame_state_local.mJoystickTeams[2] = 3-metagame_state_local.mJoystickTeams[1]
			end		

			metagame_state.pickteam = 3 - metagame_state_local.mJoystickTeams[1] -- will be put back to 1 when turn advances		
			metagame_state_local.mIsSplitscreen = ScriptCB_IsSplitscreen()

			if(not metagame_state_local.mIsSplitscreen) then
				if(metagame_state_local.mJoystickTeams[1]==1) then
					metagame_state.team2.aicontrol = 1
					elseif(metagame_state_local.mJoystickTeams[1]==2) then
					metagame_state.team1.aicontrol = 1
				end
			end

			if((ifs_missionselect.bForMP) and (ScriptCB_GetAmHost())) then
				ScriptCB_BeginMPMetagame()
			end

			--		metagame_state_fnDistributePlanets(metagame_state)
			
			-- Skip turn 0, as we've picked the planets
			metagame_state_fnAdvanceTurn(metagame_state)
			metagame_state_fnSelectBestPlanet(metagame_state)

			ScriptCB_SetIFScreen("ifs_meta_main")
		end -- not-PC
	end,

	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt) -- call base class
		local r = math.random(100) -- spice up the math.random # generator
	end,

	Input_GeneralLeft = function(this, joystick)
		-- IFButton_fnSelect(gCurHiliteButton,nil)
		
		print("+++ joystick = ", joystick)
		if( joystick == 0 ) then
			-- player1
			if (this.CurButton == "a") then
				this.CurButton = "i"
			elseif (this.CurButton == "i") then
				this.CurButton = "a"
			elseif(this.CurButton == "c") then
				this.CurButton = "r"
			else
				this.CurButton = "c"
			end
			if (this.CurButton_s1 == "a") then
				this.CurButton_s1 = "i"
			elseif (this.CurButton_s1 == "i") then
				this.CurButton_s1 = "a"
			elseif(this.CurButton_s1 == "c") then
				this.CurButton_s1 = "r"
			else
				this.CurButton_s1 = "c"
			end			
		else
			if (this.CurButton_s2 == "a") then
				this.CurButton_s2 = "i"
			elseif (this.CurButton_s2 == "i") then
				this.CurButton_s2 = "a"
			elseif(this.CurButton_s2 == "c") then
				this.CurButton_s2 = "r"
			else
				this.CurButton_s2 = "c"
			end		
		end

		print( "this.CurButton = ", this.CurButton )
		gCurHiliteButton = this.buttons[this.CurButton]
		
		IFButton_fnSelect(gCurHiliteButton,1)
		
		print( "+++this.CurButton_s1: ", this.CurButton_s1 )
		print( "+++this.CurButton_s2: ", this.CurButton_s2 )
		ifs_meta_top_fnHilightSide(this)
	end,

	Input_GeneralRight = function(this, joystick)
		this.Input_GeneralLeft(this, joystick)
		ifs_meta_top_fnHilightSide(this)
	end,

}

ifs_meta_top_hbutton1_layout = {
	yTop = 140,
--	xLeft = -150, -- auto-calc'd now
	xWidth = 200,
	xSpacing = 0,
	yHeight = 50,
	ySpacing  = 5,
	font = "gamefont_large",
	nocreatebackground = 1,

	buttonlist = {
		{ tag = "a", string = "common.sides.all.name", },
		{ tag = "i", string = "common.sides.imp.name"},
	},
}

ifs_meta_top_hbutton2_layout = {
	yTop = 140,
--	xLeft = -150, -- auto-calc'd now
	xWidth = 200,
	xSpacing = 0,
	yHeight = 50,
	ySpacing  = 5,
	font = "gamefont_large",
	nocreatebackground = 1,

	buttonlist = {
		{ tag = "r", string = "common.sides.rep.name"},
		{ tag = "c", string = "common.sides.cis.name", },
	},
}

-- layout for split screen
ifs_meta_top_hbutton_s1_layout = {
	yTop = 20,
--	xLeft = -150, -- auto-calc'd now
	xWidth = 200,
	xSpacing = 0,
	yHeight = 50,
	ySpacing  = 5,
	font = "gamefont_large",
	nocreatebackground = 1,

	buttonlist = {
		{ tag = "a", string = "common.sides.all.name", },
		{ tag = "i", string = "common.sides.imp.name"},
	},
}

ifs_meta_top_hbutton_s2_layout = {
	yTop = 20,
--	xLeft = -150, -- auto-calc'd now
	xWidth = 200,
	xSpacing = 0,
	yHeight = 50,
	ySpacing  = 5,
	font = "gamefont_large",
	nocreatebackground = 1,

	buttonlist = {
		{ tag = "r", string = "common.sides.rep.name"},
		{ tag = "c", string = "common.sides.cis.name", },
	},
}

function ifs_meta_top_fnMakeIcons(this)
	local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen

	local IconWidth = this.buttonWindow.width * 0.45

	if(gPlatformStr == "PC") then
		ifs_meta_top_hbutton1_layout.xWidth = IconWidth / 2
		ifs_meta_top_hbutton2_layout.xWidth = IconWidth / 2
	else
		ifs_meta_top_hbutton1_layout.xWidth = IconWidth
		ifs_meta_top_hbutton2_layout.xWidth = IconWidth
	end	

--	print(" ** ifs_meta_top IconWidth = ",IconWidth)

	local XPos = IconWidth * -0.5  --  (w * -0.5) + (IconWidth * 0.5) + IconWidth -- center on this item
--	print(" ** ifs_meta_top XPos = ",XPos)
	for i = 1,table.getn(ifs_meta_top_IconNames) do
		if(i==1 or i==3) then
			if(gPlatformStr == "PC") then
				IconWidth = w / table.getn(ifs_meta_top_IconNames) / 2
				XPos = IconWidth * -0.5
			else
				XPos = IconWidth * -0.5 --(w * -0.5) + (IconWidth * 0.5) + IconWidth
			end
		end

		local NameStr = ifs_meta_top_IconNames[i]

--		print("Meta_top NameStr =",NameStr,"XPos = ",XPos)

		this.buttons[NameStr] = NewIFImage {
			y = 0, x = XPos,
			localpos_l = -64, localpos_r = 64,
			localpos_t = -128, localpos_b = 128,
--			inertUVs = 1,
			texture = NameStr,
			ZPos = 130, -- a bit behind the text
		}

		XPos = XPos + IconWidth

	end -- loop over i
	
	if(gPlatformStr == "PS2") then
		this.subtitle.x = -195
		this.subtitle.y = 45		
	elseif (gPlatformStr == "XBox") then
		this.subtitle.x = -195
		this.subtitle.y = 45
		this.subtitleSp.x = -240
		this.subtitleSp.y = -5
	elseif (gPlatformStr == "PC") then
		this.subtitle.y = h * 0.34
	end

	-- Also, add buttons
	this.CurButton = AddHorizontalButtons(this.buttons,ifs_meta_top_hbutton1_layout)
	AddHorizontalButtons(this.buttons,ifs_meta_top_hbutton2_layout)	
	
	this.buttons.rotX = ifs_meta_top.button_rot_x
	this.buttons.rotY = ifs_meta_top.button_rot_y
	
	this.buttonWindow.rotX = ifs_meta_top.button_rot_x
	this.buttonWindow.rotY = ifs_meta_top.button_rot_y

	this.subtitle.rotX = ifs_meta_top.button_rot_x
	this.subtitle.rotY = ifs_meta_top.button_rot_y
	
	-- split screen setting upper
	for i = 1,table.getn(ifs_meta_top_IconNames) do
		if(i==1 or i==3) then
			XPos = IconWidth * -0.5 --  (w * -0.5) + (IconWidth * 0.5) + IconWidth
		end

		local NameStr = ifs_meta_top_IconNames[i]

--		print("Meta_top NameStr =",NameStr,"XPos = ",XPos)

		this.buttons_s1[NameStr] = NewIFImage {
			y = 0, x = XPos,
			localpos_l = -64, localpos_r = 64,
			localpos_t = -128, localpos_b = 2,
--			inertUVs = 1,
			texture = NameStr,
			ZPos = 130, -- a bit behind the text
		}

		XPos = XPos + IconWidth

	end -- loop over i

	AddHorizontalButtons(this.buttons_s1,ifs_meta_top_hbutton_s1_layout)
	AddHorizontalButtons(this.buttons_s1,ifs_meta_top_hbutton_s2_layout)

	-- split screen setting lower
	for i = 1,table.getn(ifs_meta_top_IconNames) do
		if(i==1 or i==3) then
			XPos = IconWidth * -0.5 -- (w * -0.5) + (IconWidth * 0.5) + IconWidth
		end

		local NameStr = ifs_meta_top_IconNames[i]

--		print("Meta_top NameStr =",NameStr,"XPos = ",XPos)

		this.buttons_s2[NameStr] = NewIFImage {
			y = 0, x = XPos,
			localpos_l = -64, localpos_r = 64,
			localpos_t = 40, localpos_b = 170,
--			inertUVs = 1,
			texture = NameStr,
			ZPos = 130, -- a bit behind the text
		}

		XPos = XPos + IconWidth

	end -- loop over i

	this.buttons_s1.rotX = ifs_meta_top.button_rot_x
	this.buttons_s1.rotY = ifs_meta_top.button_rot_y

	this.buttons_s2.rotX = ifs_meta_top.button_rot_x
	this.buttons_s2.rotY = ifs_meta_top.button_rot_y

	this.buttonWindowSp.rotX = ifs_meta_top.button_rot_x
	this.buttonWindowSp.rotY = ifs_meta_top.button_rot_y

	this.subtitleSp.rotX = ifs_meta_top.button_rot_x
	this.subtitleSp.rotY = ifs_meta_top.button_rot_y
		
end

-- Build the programatic parts of this screen
ifs_meta_top_fnMakeIcons(ifs_meta_top)
ifs_meta_top_fnMakeIcons = nil -- dump init-only functions out of memory
AddIFScreen(ifs_meta_top,"ifs_meta_top")
