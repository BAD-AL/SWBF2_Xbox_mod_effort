--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Popup screenlets for the metagame, in shell.
--
-- This file creates, handles them.




--
-- -------------------------------------------------------------------
--

-- Does any work to activate this
function gPopup_PickWinner_fnActivate(this,vis)
	this:fnDefaultActivate(vis)
	if(vis) then
		-- Hilight buttons appropriately.
		if(this.CurButton == "yes") then
			IFButton_fnSelect(this.buttons.yes,1)
			IFButton_fnSelect(this.buttons.no,nil)
			gCurHiliteButton = this.buttons.yes
		else
			IFButton_fnSelect(this.buttons.yes,nil)
			IFButton_fnSelect(this.buttons.no,1)
			gCurHiliteButton = this.buttons.no
		end
	end
end

-- Handle the user hitting accept (back uses defaults). Close this popup,
-- let things know who won
function gPopup_PickWinner_fnInput_Accept(this)
	this:fnActivate(nil)
	ifs_meta_main_BattleOver(ifs_meta_main,this.CurButton == "yes")
end

Metagame_Popup_PickWinner = NewPopup {
	ScreenRelativeX = 0.5, -- centered onscreen
	ScreenRelativeY = 0.5,
	height = 200,
	width = 180,
	ZPos = 50,

	title = NewIFText {
		string = "ifs.meta.popups.winbattle",
		font = "gamefont_medium",
		textw = 160,
		y = -80,
		inert = 1,
	},

	showodds = NewIFText {
		font = "gamefont_small",
		textw = 160,
		y = -52,
	},

	buttons = NewIFContainer {
	},

	fnActivate = gPopup_PickWinner_fnActivate,
	Input_Accept = gPopup_PickWinner_fnInput_Accept,
}

AddVerticalButtons(Metagame_Popup_PickWinner.buttons,Vertical_YesNoButtons_layout)
CreatePopupInC(Metagame_Popup_PickWinner,"Metagame_Popup_PickWinner")

--
-- -------------------------------------------------------------------
--

-- 'Planet activated' popup

-- Does any work to activate this
function gPopup_PlanetActivated_fnActivate(this,vis)
	this:fnDefaultActivate(vis)
	if(vis) then
		this.CurButton = "ok"
		gCurHiliteButton = this.buttons.ok
	end
end

-- Handle the user hitting accept (back uses defaults). Close this popup,
-- let things know who won
function gPopup_PlanetActivated_fnInput_Accept(this,bFromAI)
	local bOwnerIsAI = metagame_state:fnIsCurTeamAI(metagame_state.passivebonusplanet.owner)
	local AcceptIt = nil

	-- Where's my XOR, lua?
	if(bOwnerIsAI and bFromAI) then
		AcceptIt = 1
	elseif ((not bOwnerIsAI) and (not bFromAI)) then
		AcceptIt = 1
	end

	if(not AcceptIt) then
		print("AI owns this bonus. Can't cancel it")
		return
	else
		this:fnActivate(nil)
		ifs_meta_main:fnShowNextActivePlanet() -- if applicable
	end
end

function gPopup_PlanetActivated_fnUpdate(this, fDt)
	-- Dax doesn't want this to bounce when the AI is in charge of the planet
	local bOwnerIsAI = metagame_state:fnIsCurTeamAI(metagame_state.passivebonusplanet.owner)
	if(not bOwnerIsAI) then
		-- Call default
		gIFShellScreenTemplate_fnUpdate(this,fDt)
	end
end

Metagame_Popup_PlanetActivated = NewPopup {
	ScreenRelativeX = 0.5, -- centered onscreen
	ScreenRelativeY = 0.73,
	height = 105,
	width = 145,
	ZPos = 50,

	planetname = NewIFText {
		font = "gamefont_medium",
		textw = 160,
		y = -44,
	},

	nowactive = NewIFText {
		string = "ifs.meta.popups.isnow",
		font = "gamefont_small",
		textw = 160,
		y = -24,
		inert = 1,
	},

	buttons = NewIFContainer {
		y = 0,
	},

	Update = gPopup_PlanetActivated_fnUpdate,

	fnActivate = gPopup_PlanetActivated_fnActivate,
	Input_Accept = gPopup_PlanetActivated_fnInput_Accept,
}

AddVerticalButtons(Metagame_Popup_PlanetActivated.buttons,ActiveButton_layout)
CreatePopupInC(Metagame_Popup_PlanetActivated,"Metagame_Popup_PlanetActivated")

--
-- -------------------------------------------------------------------
--

-- 'A winner is you' popup

-- Does any work to activate this
function gPopup_GameWinner_fnActivate(this,vis)
	this:fnDefaultActivate(vis)
--	ifs_meta_main:fnActivateInfoWindow(not vis) -- hide info window
	if(vis) then
		this.CurButton = "ok"
		gCurHiliteButton = this.buttons.ok
	end
end

-- Handle the user hitting accept (back uses defaults). Close this popup,
-- let things know who won
function gPopup_GameWinner_fnInput_Accept(this)
	this:fnActivate(nil)
	-- Go back to top of metagame, no matter how far down we are.
	if( ScriptCB_InNetGame() ) then
		ScriptCB_PopScreen("ifs_mp")
	else
		ScriptCB_PopScreen("ifs_sp")
	end
end

Metagame_Popup_GameWinner = NewPopup {
	ScreenRelativeX = 0.5, -- centered onscreen
	ScreenRelativeY = 0.5,
	height = 140,
	width = 220,
	ZPos = 50,

	winnername = NewIFText {
		font = "gamefont_medium",
		textw = 160,
		y = -55,
	},

	haswon = NewIFText {
		string = "ifs.meta.popups.wonthegame",
		font = "gamefont_medium",
		textw = 200,
		y = -15,
		inert = 1,
	},

	buttons = NewIFContainer {
		y = 30,
	},

	fnActivate = gPopup_GameWinner_fnActivate,
	Input_Accept = gPopup_GameWinner_fnInput_Accept,
	Input_Back = gPopup_GameWinner_fnInput_Accept,
}

AddVerticalButtons(Metagame_Popup_GameWinner.buttons,OkButton_layout)
CreatePopupInC(Metagame_Popup_GameWinner,"Metagame_Popup_GameWinner")

--
-- -------------------------------------------------------------------
--

-- Does any work to activate this
function gPopup_ApplyBonus_fnActivate(this,vis)
	this:fnDefaultActivate(vis)
	if(vis) then
		-- Default: no is selected.
		this.CurButton = "no"
		IFButton_fnSelect(this.buttons.yes,nil)
		IFButton_fnSelect(this.buttons.no,1)
		gCurHiliteButton = this.buttons.no
	end
end

-- Handle the user hitting accept (back uses defaults). Close this popup,
-- let things know who won
function gPopup_ApplyBonus_fnInput_Accept(this)
	this:fnActivate(nil)

	if((metagame_state.bonusplanet == metagame_state.planets.despayre) and (this.CurButton == "yes")) then
        -- ifs_movietrans_PushScreen(ifs_meta_battle) -- jump to this screen, will return later
        -- go to battle directly
        ifs_meta_battle_fnOnEnter( this )        
	else
		ifs_meta_main:fnApplyBonus(this.CurButton == "yes")
	end
end

Metagame_Popup_ApplyBonus = NewPopup {
	ScreenRelativeX = 0.5, -- centered onscreen
	ScreenRelativeY = 0.73,
	height = 100,
	width = 200,
	ZPos = 50,

	title = NewIFText {
		string = "ifs.meta.popups.reallyapply",
		font = "gamefont_small",
		textw = 160,
		texth = 60,
		y = -30,
		inert = 1,
	},

	buttons = NewIFContainer {
		y = 14,
	},

	fnActivate = gPopup_ApplyBonus_fnActivate,
	Input_Accept = gPopup_ApplyBonus_fnInput_Accept,
}

AddVerticalButtons(Metagame_Popup_ApplyBonus.buttons, Vertical_YesNoButtons_layout)
CreatePopupInC(Metagame_Popup_ApplyBonus,"Metagame_Popup_ApplyBonus")



--
-- -------------------------------------------------------------------
--

-- 'No valid target' popup

-- Does any work to activate this
function gPopup_NoTarget_fnActivate(this,vis)
	ifs_meta_main:fnActivateInfoWindow(not vis)
	IFObj_fnSetColor(this.nowactive,255,255,0)
	this:fnDefaultActivate(vis)
	if(vis) then
		this.CurButton = "ok"
		gCurHiliteButton = this.buttons.ok
	end
end

-- Handle the user hitting accept (back uses defaults). Close this popup,
-- let main gameplay decide what to do next.
function gPopup_NoTarget_fnInput_Accept(this)
	this:fnActivate(nil)
	ScriptCB_PopScreen() -- back to the main page
	ifs_meta_main:fnPostNoTarget()
end

Metagame_Popup_NoTarget = NewPopup {
	ScreenRelativeX = 0.5, -- centered onscreen
	ScreenRelativeY = 0.4,
	height = 140,
	width = 170,
	ZPos = 50,

	nowactive = NewIFText {
		string = "ifs.meta.popups.notarget",
		font = "gamefont_medium",
		textw = 160,
		texth = 80,
		y = -60,
		inert = 1,
	},

	buttons = NewIFContainer {
	},

	fnActivate = gPopup_NoTarget_fnActivate,
	Input_Accept = gPopup_NoTarget_fnInput_Accept,
}

AddVerticalButtons(Metagame_Popup_NoTarget.buttons,OkButton_layout)
CreatePopupInC(Metagame_Popup_NoTarget,"Metagame_Popup_NoTarget")
