--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_freeform_sides = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1,

	SetPlayerReady = function(this, joystick, ready)
		this.controllerReady[joystick] = ready
		if ready == 1 then
			local r, g, b = ifs_freeform_main:GetTeamColor(this.controllerTeam[joystick])
			IFObj_fnSetColor(this.players[joystick], r, g, b)
		else
			IFObj_fnSetColor(this.players[joystick], 240, 240, 240)
		end
	end,
	
	SetPlayerTeam = function(this, joystick, team)
		this.controllerTeam[joystick] = team
		IFObj_fnSetPos(this.players[joystick], this.players.side_x[team], this.players.name_y[joystick])
	end,
		
	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		
		-- read all controllers
		this.wasRead = ScriptCB_ReadAllControllers(1)
		
		-- zoom all the way out
		ifs_freeform_main:SetZoom(0)
		
		-- set side titles
		IFText_fnSetString(this.team1.text, ifs_freeform_main.teamName[1])
		IFText_fnSetString(this.team2.text, ifs_freeform_main.teamName[2])
		
		-- set side icons
		IFImage_fnSetTexture(this.team1.icon, "seal_" .. ifs_freeform_main.teamCode[1])
		IFObj_fnSetColor(this.team1.icon, ifs_freeform_main:GetTeamColor(1))
		IFImage_fnSetTexture(this.team2.icon, "seal_" .. ifs_freeform_main.teamCode[2])
		IFObj_fnSetColor(this.team2.icon, ifs_freeform_main:GetTeamColor(2))
		
		-- for each controller...
		this.controllerTeam = {}
		this.controllerReady = {}
		local controllers = ScriptCB_GetMaxControllers()
		for controller = 0,controllers-1 do
			-- if the controller is bound...
			if ScriptCB_IsControllerBound(controller+1) then
				-- set as not ready
				this:SetPlayerReady(controller, 0)
				
				-- set team
				this:SetPlayerTeam(controller, ifs_freeform_main.controllerTeam[controller])
				
				-- show name
				IFText_fnSetUString(this.players[controller], ScriptCB_GetProfileName(controller+1))
				IFObj_fnSetVis(this.players[controller], 1)
			else
				-- hide name
				IFObj_fnSetVis(this.players[controller], nil)
			end
		end
	end,
	
	Exit = function(this, bFwd)
		-- save controller teams
		ifs_freeform_controllers(ifs_freeform_main, this.controllerTeam)

		-- use current team if continuing, or start controller if starting
		local activeTeam = ifs_freeform_main.curScreen
			and ifs_freeform_main.playerTeam
			or ifs_freeform_main.controllerTeam[ifs_freeform_main.startController]
		
		-- synchronize team values
		ifs_freeform_main:SetActiveTeam(activeTeam)
		ifs_freeform_main.planetNext = ifs_freeform_main.lastSelected[ifs_freeform_main.playerTeam]
		
		-- init team colors
		ifs_freeform_main:InitTeamColor()
		
		-- restore previous read all
		ScriptCB_ReadAllControllers(this.wasRead)
		this.wasRead = nil
	end,
	
	Input_Accept = function(this, joystick)
		-- set controller as ready
 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
		this:SetPlayerReady(joystick, 1)
		
		-- finished if anyone is not ready
		for _, ready in pairs(this.controllerReady) do
			if ready == 0 then
				return
			end
		end
		
		-- pop screen if everyone is ready
		if not this.displayTimer then
			this.displayTimer = 1.0
		end
	end,
	
	Input_Misc = function(this, joystick)
	end,
	
	Input_Back = function(this, joystick)
		-- set controller as not ready
 		ifelm_shellscreen_fnPlaySound(this.cancelSound)
		this:SetPlayerReady(joystick, 0)
		
		if this.displayTimer then
			this.displayTimer = nil
		end
	end,
	
	Input_GeneralLeft = function(this, joystick)
		-- switch to team 1
		if this.controllerReady[joystick]==0 then
	 		ifelm_shellscreen_fnPlaySound(this.selectSound)
			this:SetPlayerTeam(joystick, 1)
		end
	end,
	
	Input_GeneralRight = function(this, joystick)
		-- switch to team 2
		if this.controllerReady[joystick]==0 then
	 		ifelm_shellscreen_fnPlaySound(this.selectSound)
			this:SetPlayerTeam(joystick,2 )
		end
	end,
	
	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt) -- call base class
		
		if this.displayTimer then
			this.displayTimer = this.displayTimer - fDt
			if this.displayTimer < 0 then
				ScriptCB_PopScreen();
				ScriptCB_PushScreen("ifs_freeform_fleet")
			end
		end
	end,
}
	
	
do
	this = ifs_freeform_sides
	
	if gPlatformStr == "PS2" then
		this.bgModel = NewIFModel {
			ScreenRelativeX = 0.5,
			ScreenRelativeY = 0.5,
			ZPos = 255,
			model = "shell_cube",
			ColorR = 0, ColorG = 0, ColorB = 0,
			scale = 1.25,
			depth = 0.009,
			inert = 1,
		}
	else
		-- note this isn't the safe dimensions!
		local w,h,v,widescreen = ScriptCB_GetScreenInfo()

		this.bgImage = NewIFImage {
			ScreenRelativeX = 0,
			ScreenRelativeY = 0,
			UseSafezone = 0,
			ZPos = 255,
			texture = "blank_icon",
			ColorR = 0, ColorG = 0, ColorB = 0, alpha = 0.75,
			localpos_l = 0,
			localpos_t = 0,
			localpos_r = w*widescreen,
			localpos_b = h,
			inert = 1,
		}
	end
	
	local w,h = ScriptCB_GetSafeScreenInfo()
	
	this.title = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.0, -- top
		
		text = NewIFText {
			font = "gamefont_large",
			string = "ifs.freeform.picksides",
			textw = w,
			halign = "hcenter",
			valign = "top",
			nocreatebackground = 1
		}
	}
	
	side_w = w * 0.5
	
	this.team1 = NewIFContainer {
		ScreenRelativeX = 0.0, -- left
		ScreenRelativeY = 0.2, -- top
		
		text = NewIFText {
			font = "gamefont_large",
			textw = side_w,
			x = 0,
			
			halign = "hcenter",
			valign = "vcenter",
			nocreatebackground = 1
		},
		
		icon = NewIFImage { 
			ZPos = 200,
			alpha = 0.25,
			localpos_l = side_w * 0.5 - 32,
			localpos_t = -32,
			localpos_r = side_w * 0.5 + 32,
			localpos_b = 32,
			inert = 1,
		}
	}
	
	this.team2 = NewIFContainer {
		ScreenRelativeX = 1.0, -- right
		ScreenRelativeY = 0.2, -- top
		
		text = NewIFText {
			font = "gamefont_large",
			textw = side_w,
			x = -side_w,
			
			halign = "hcenter",
			valign = "vcenter",
			nocreatebackground = 1
		},
		
		icon = NewIFImage { 
			ZPos = 200,
			alpha = 0.25,
			localpos_l = -side_w * 0.5 - 32,
			localpos_t = -32,
			localpos_r = -side_w * 0.5 + 32,
			localpos_b = 32,
			inert = 1,
		}
	}
	
	name_h = h * 0.1
	
	this.players = NewIFContainer {
		ScreenRelativeX = 0.0,
		ScreenRelativeY = 0.35,
		side_x = { [1] = 0, [2] = side_w },
		name_y = { [0] = 0, [1] = name_h, [2] = name_h * 2, [3] = name_h * 3 },
		
		[0] = NewIFText {
			font = "gamefont_medium",
			textw = side_w,
			
			halign = "hcenter",
			valign = "vcenter",
			nocreatebackground = 1
		},
	
		[1] = NewIFText {
			font = "gamefont_medium",
			textw = side_w,
			
			halign = "hcenter",
			valign = "vcenter",
			nocreatebackground = 1
		},
	
		[2] = NewIFText {
			font = "gamefont_medium",
			textw = side_w,
			
			halign = "hcenter",
			valign = "top",
			nocreatebackground = 1
		},
	
		[3] = NewIFText {
			font = "gamefont_medium",
			textw = side_w,
			
			halign = "hcenter",
			valign = "top",
			nocreatebackground = 1
		},
	}
	
	local screen_w, screen_h = ScriptCB_GetScreenInfo()
	local bar_h = h * .1
	
	this.letterbox_top = NewIFContainer{
		ScreenRelativeX = 0.0, --left
		ScreenRelativeY = 0.0, --top
		texture = "blank_icon",
		ZPos = 200,
			
		image = NewIFImage {
			texture = "blank_icon",
			ColorR = 0, ColorG = 0, ColorB = 0, 
--			alpha = 1.0,
			ZPos = 200,	
			localpos_l = -screen_w,
			localpos_t = -screen_h,
			localpos_r = screen_w,
			localpos_b = bar_h,
			inert = 1,
		},	
	}
	
	this.letterbox_bottom = NewIFContainer{
		ScreenRelativeX = 0.0, --left
		ScreenRelativeY = 1.0, --bottom
		texture = "blank_icon",
		ZPos = 200,
			
		top = NewIFImage {
			texture = "blank_icon",
			ColorR = 0, ColorG = 0, ColorB = 0, 
			ZPos = 200,	
			localpos_l = -screen_w,
			localpos_t = -bar_h,
			localpos_r = screen_w,
			localpos_b = screen_h,
			inert = 1,
		},	
	}
	
	this.action = NewIFContainer{
	ScreenRelativeX = 0.0, -- left
	ScreenRelativeY = 1.0, -- bottom
	width = action_w,
	header = "Action",
	ZPos = 190,


		misc = NewHelptext {
			x = w,
			buttonicon = "btn_directional_pad_LR",
			string = "common.change",
			bRightJustify = 1,
			y = -34, 
		},
	
			
		accept = NewHelptext {
			x = w,
			buttonicon = "btna",
			string = "common.select",
			bRightJustify = 1,
			y = -15, 
		},
		
		back = NewHelptext {
			x = 0,
			buttonicon = "btnb",
			string = "ifs.freeform.fleet.deselect",
			bLeftJustify = 1,
			y = -15, 
		},
	}		
			
end

AddIFScreen(ifs_freeform_sides,"ifs_freeform_sides")
