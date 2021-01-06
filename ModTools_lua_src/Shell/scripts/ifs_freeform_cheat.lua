--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Ingame pause cheat

ifsfreeformcheat_vbutton_layout = {
	ySpacing = 5,
	width = 260,
	font = gMenuButtonFont,
	buttonlist = { 
		{ tag = "nextturn", string = "Next Turn", },
		{ tag = "10credits", string = "+100 Credits", },
		{ tag = "100credits", string = "+1000 Credits", },
		{ tag = "1000credits", string = "+10000 Credits", },
		{ tag = "setplayerplanet", string = "Set as Player Planet", },
		{ tag = "addplayerfleet", string = "Add Player Fleet", },
		{ tag = "delplayerfleet", string = "Remove Player Fleet", },
		{ tag = "setenemyplanet", string = "Set as Enemy Planet", },
		{ tag = "addenemyfleet", string = "Add Enemy Fleet", },
		{ tag = "delenemyfleet", string = "Remove Enemy Fleet", },
	},
	title = "Cheat Menu",
}

-- Turns pieces on/off as requested
function ifs_freeform_cheat_fnSetPieceVis(this, bVis)
	IFObj_fnSetVis(this.buttons,bVis)
end

ifs_freeform_cheat = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil, -- played before the screen is displayed
	movieBackground = nil, -- played while the screen is displayed
	bFriendsIcon = 1,
	bAcceptIsSelect = 1,

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = gDefaultButtonScreenRelativeY, -- center
		--rotY = 25,
	},

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd)

		if(this.CurButton) then
			IFButton_fnSelect(this.buttons[this.CurButton],nil) -- Deactivate old button
		end

		-- Refresh which buttons are shown
		this.buttons.addplayerfleet.hidden = this.main ~= ifs_freeform_main
		this.buttons.delplayerfleet.hidden = this.main ~= ifs_freeform_main
		this.buttons.addenemyfleet.hidden = this.main ~= ifs_freeform_main
		this.buttons.delenemyfleet.hidden = this.main ~= ifs_freeform_main
		this.buttons.setplayerplanet.hidden = this.main ~= ifs_freeform_main
		this.buttons.setenemyplanet.hidden = this.main ~= ifs_freeform_main

		this.CurButton = ShowHideVerticalButtons(this.buttons,ifsfreeformcheat_vbutton_layout)

		if (bFwd) then
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
		end

		SetCurButton(this.CurButton)
	end,

	Input_Accept = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		ifelm_shellscreen_fnPlaySound(this.acceptSound)

		if (this.CurButton == "nextturn") then
			this.main:NextTurn()
		elseif (this.CurButton == "10credits") then
			this.main:AddResources(this.main.playerTeam, 10)
		elseif (this.CurButton == "100credits") then
			this.main:AddResources(this.main.playerTeam, 100)
		elseif (this.CurButton == "1000credits") then
			this.main:AddResources(this.main.playerTeam, 1000)
		elseif (this.CurButton == "setplayerplanet") then
			this.main.planetTeam[this.main.planetSelected] = this.main.playerTeam
		elseif (this.CurButton == "addplayerfleet") then
			this.main:CreateFleet(this.main.playerTeam, this.main.planetSelected)
		elseif (this.CurButton == "delplayerfleet") then
			this.main:DestroyFleet(this.main.playerTeam, this.main.planetSelected)
		elseif (this.CurButton == "setenemyplanet") then
			this.main.planetTeam[this.main.planetSelected] = 3 - this.main.playerTeam
		elseif (this.CurButton == "addenemyfleet") then
			this.main:CreateFleet(3 - this.main.playerTeam, this.main.planetSelected)
		elseif (this.CurButton == "delenemyfleet") then
			this.main:DestroyFleet(3 - this.main.playerTeam, this.main.planetSelected)
		end
	end,

	-- Override default behavior
	Input_Back = function(this)
		ifelm_shellscreen_fnPlaySound(this.exitSound)
		ScriptCB_PopScreen()
	end,
	
	Input_Start = function(this)
		this:Input_Back()
	end,
}


ifs_freeform_cheat.Viewport = 0
ifs_freeform_cheat.CurButton = AddVerticalButtons(ifs_freeform_cheat.buttons,ifsfreeformcheat_vbutton_layout)
AddIFScreen(ifs_freeform_cheat,"ifs_freeform_cheat", 1)

ifs_freeform_cheat = DoPostDelete(ifs_freeform_cheat)

