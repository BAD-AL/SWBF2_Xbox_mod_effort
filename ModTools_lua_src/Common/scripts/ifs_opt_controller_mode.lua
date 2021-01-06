--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Top page for the options pages hierarchy

ifs_opt_controlmode_vbutton_layout = {
	ySpacing  = 5,
	width = 350,
	font = gMenuButtonFont,
	buttonlist = { 
		{ tag = "soldier", string = "ifs.Controls.Soldier.title", },
		{ tag = "vehicle", string = "ifs.Controls.Vehicle.title", },
		{ tag = "flyer", string = "ifs.Controls.Flyer.title", },
		{ tag = "jedi", string = "ifs.Controls.Jedi.title", },
		{ tag = "turret", string = "ifs.Controls.Turret.title", },
	},
	title = "ifs.controls.controlmodes",
--	rotY = 40,
}

ifs_opt_contmode = NewIFShellScreen {
	nologo     = 1,
	bAcceptIsSelect = 1,
	enterSound = "",
	exitSound  = "",
	bDimBackdrop = 1,

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = gDefaultButtonScreenRelativeY, -- top
	},

	Input_Accept = function(this) 
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		ifelm_shellscreen_fnPlaySound(this.acceptSound)       
		
		local controlstring = "ifs_opt_controller"
		if (gPlatformStr == "PC") then
			controlstring = "ifs_opt_pccontrols"
			ScriptCB_PushScreen( controlstring )
		elseif (this.CurButton == "soldier") then
			ScriptCB_SetControlMode(0)
			ScriptCB_PushScreen( controlstring )
		elseif (this.CurButton == "vehicle") then
			ScriptCB_SetControlMode(1)
			ScriptCB_PushScreen( controlstring )
		elseif (this.CurButton == "flyer") then
			ScriptCB_SetControlMode(2)
			ScriptCB_PushScreen( controlstring )
		elseif (this.CurButton == "jedi") then
			ScriptCB_SetControlMode(3)
			ScriptCB_PushScreen( controlstring )
		elseif (this.CurButton == "turret") then
			ScriptCB_SetControlMode(4)
			ScriptCB_PushScreen( controlstring )
		end
	end,
	
}

if(ScriptCB_GetShellActive() and (gPlatformStr ~= "PC")) then
	ifs_opt_controlmode_vbutton_layout.bLeftJustifyButtons = 1
end

ifs_opt_contmode.CurButton = AddVerticalButtons(ifs_opt_contmode.buttons,ifs_opt_controlmode_vbutton_layout)
AddIFScreen(ifs_opt_contmode,"ifs_opt_contmode")
ifs_opt_contmode = DoPostDelete(ifs_opt_contmode)
