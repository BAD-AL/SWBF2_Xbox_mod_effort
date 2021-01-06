--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- General handler for vote to boot

Popup_Vote_Buttons_layout = {
	yTop = 0,
	width = 450,
	font = gPopupButtonFont,
	buttonlist = { 
		{ tag = "player", string = "ifs.mp.vote.cheat", },
		{ tag = "reason", string = "ifs.mp.vote.teamkill", yAdd = 20,},
		{ tag = "yes", string = "ifs.mp.vote.accept", },
	--	{ tag = "ban", string = "ifs.mp.vote.ban", },
		{ tag = "no", string = "ifs.mp.vote.cancel", },
	},
--	nocreatebackground = 1,
}

Popup_Vote_Buttons_Reason_List = {
		{ string = "ifs.mp.vote.teamkill", },
		{ string = "ifs.mp.vote.lag", },
		{ string = "ifs.mp.vote.cheat", },
		{ string = "ifs.mp.vote.haras", },
		{ string = "ifs.mp.vote.inactivity", },
		{ string = "ifs.mp.vote.voice", },
}

function gPopup_Vote_fnUpdateButton( this )	
	-- set reason button
	local TempString = ScriptCB_usprintf( "ifs.mp.vote.display", ScriptCB_getlocalizestr(Popup_Vote_Buttons_Reason_List[this.reason].string) )		
	IFText_fnSetUString( Popup_Vote.buttons.reason.label, TempString )
	
	-- set player button
	print( "this.SelectedIdx =", this.SelectedIdx )
	if( this.SelectedIdx ) then
		if( ifs_mp_lobby_DoTestCanBoot( this.SelectedIdx, this.force_boot ) ) then		
			local Selection = ifs_mp_lobby_listbox_contents[this.SelectedIdx]
			if( Selection ) then
				IFText_fnSetUString( this.buttons.player.label, ScriptCB_usprintf( "ifs.mp.vote.display", ScriptCB_tounicode( Selection.namestr ) ) )
			end	
		else
			gPopup_Vote_fnActivate(this,nil)
			return		
		end
	end	
end

-- Does any work to activate this
function gPopup_Vote_fnActivate(this,vis)
	this:fnDefaultActivate(vis)
	if(vis) then
		local TagOfFirst, BtnWidth
		TagOfFirst, BtnWidth = ShowHideVerticalButtons(this.buttons, Popup_Vote_Buttons_layout)
		this.fMinWidth = BtnWidth + 20

		--if( (ScriptCB_InNetGame()) and (ScriptCB_GetAmHost()) ) then
		--	this.buttons.ban.hidden = nil
		--	IFObj_fnSetVis(this.buttons.ban, 1)
		--else
		--	this.buttons.ban.hidden = 1
		--	IFObj_fnSetVis(this.buttons.ban, nil)
		--end

		-- Default: "yes" is selected, if not already set
		this.CurButton = this.CurButton or "yes"

		-- A little extra work, but shouldn't be too bad: deselect all
		-- buttons on entry
		IFButton_fnSelect(this.buttons.no,nil)
		IFButton_fnSelect(this.buttons.yes,nil)

		-- Select right button.
		IFButton_fnSelect(this.buttons[this.CurButton],1)
		gCurHiliteButton = this.buttons[this.CurButton]
		
		-- set title string
		if( this.force_boot ) then
			gPopup_fnSetTitleStr(this, "ifs.mp.vote.title1")
		else
			gPopup_fnSetTitleStr(this, "ifs.mp.vote.title")
		end
		
		-- accept input from all controllers
		if (ifs_saveop and ifs_saveop.saveProfileNum) then
			this.iOnlyJoystick = ifs_saveop.saveProfileNum
		end
		if(this.iOnlyJoystick) then
			this.wasRead = ScriptCB_SetHotController(this.iOnlyJoystick)
		end
		
		-- update buttons
		gPopup_Vote_fnUpdateButton( this )
	else
		-- restore previous input state
		if(this.iOnlyJoystick) then
			ScriptCB_SetHotController(this.wasRead)
			this.wasRead = nil
			this.iOnlyJoystick = nil -- clean up after screen
		end
	end
end

-- Handle the user hitting accept (back uses defaults). Close this popup,
-- let things know who won
function gPopup_Vote_fnInput_Accept(this,iJoystick)
	-- only accept it if you actually hit a button
	-- Default: hide this.
	gPopup_Vote_fnActivate(this,nil)

	if(this.CurButton == "yes") then
		-- boot player
		local Selection = ifs_mp_lobby_listbox_contents[this.SelectedIdx]
		if(not Selection) then
			return
		end
		
		if( this.force_boot ) then
			ScriptCB_LobbyAction(Selection.indexstr, Selection.namestr, "forceboot")			
		else
			ScriptCB_LobbyAction(Selection.indexstr, Selection.namestr, this.reason - 1, "boot", iJoystick )
		end

		-- Call callback if applicable, w/ result (nil = no, other = yes)
		ifelm_shellscreen_fnPlaySound("shell_menu_accept")
		if(this.fnDone) then
			this.fnDone(this.CurButton == "yes")
		--else
		--    ifelm_shellscreen_fnPlaySound("shell_menu_cancel")
		end
	end
end

function gPopup_Vote_fnInput_GeneralLeft(this,iJoystick)
	gDefault_Input_GeneralLeft(this,iJoystick)
	if( this.CurButton == "player" ) then
		local NumEntries = table.getn(ifs_mp_lobby_listbox_contents)
		if( NumEntries < 1 ) then
			this.SelectedIdx = nil
		else
			if( this.SelectedIdx ) then
				local select_idx = this.SelectedIdx
				local NumTries = NumEntries + NumEntries + 2
				repeat
					select_idx = select_idx - 1
					if( select_idx < 1 ) then
						select_idx = NumEntries
					end
					NumTries = NumTries - 1

				until ((NumTries < 0) or ifs_mp_lobby_DoTestCanBoot(select_idx, this.force_boot))

				-- Fix for 8241 - if we couldn't find a player to select, they've all
				-- left the game. Close popup, and hope the user figures that out.
				if(NumTries < 0) then
					gPopup_Vote_fnActivate(this,nil)
					return
				end

				this.SelectedIdx = select_idx
			end
		end
	elseif ( this.CurButton == "reason" ) then
		this.reason = this.reason - 1
		if( this.reason < this.reason_min ) then
			this.reason = this.reason_max
		end	
	end
	gPopup_Vote_fnUpdateButton( this )
end

function gPopup_Vote_fnInput_GeneralRight(this,iJoystick)
	gDefault_Input_GeneralRight(this,iJoystick)
	if( this.CurButton == "player" ) then
		local NumEntries = table.getn(ifs_mp_lobby_listbox_contents)
		if( NumEntries < 1 ) then
			this.SelectedIdx = nil
		else
			if( this.SelectedIdx ) then
				local select_idx = this.SelectedIdx
				local NumTries = NumEntries + NumEntries + 2
				repeat
					select_idx = select_idx + 1				
					if( select_idx > NumEntries ) then
						select_idx = 1
					end
					NumTries = NumTries - 1

				until ((NumTries < 0) or ifs_mp_lobby_DoTestCanBoot(select_idx, this.force_boot))

				-- Fix for 8241 - if we couldn't find a player to select, they've all
				-- left the game. Close popup, and hope the user figures that out.
				if(NumTries < 0) then
					gPopup_Vote_fnActivate(this,nil)
					return
				end

				this.SelectedIdx = select_idx
			end
		end
	elseif ( this.CurButton == "reason" ) then
		this.reason = this.reason + 1
		if( this.reason > this.reason_max ) then
			this.reason = this.reason_min
		end	
	end
	gPopup_Vote_fnUpdateButton( this )
end


Popup_Vote = NewPopup {
	ScreenRelativeX = 0.5, -- centered onscreen
	ScreenRelativeY = 0.5,
	height = 180,
	width = 300,
	ZPos = 50,
	ButtonHeightHint = 160,

	-- the selection of the player list in ifs_mp_lobby
	SelectedIdx = nil,
	
	-- boot reason: 1:team killing, 2:lag, 3: cheating, 4:harrassment, 5:inactivity, 6:voice
	-- default: 1
	reason = 1,	
	reason_min = 1,
	reason_max = 6,
	
	-- is it force to boot
	force_boot = nil,
	
	title = NewIFText {
		string = "ifs.mp.vote.title",
		font = gPopupTextFont,
		textw = 260,
		texth = 120,
		y2 = -80,
		flashy = 0,
	},

	txt_for = NewIFText {
		string = "ifs.mp.vote.for",
		font = "gamefont_small",
		textw = 260,
		texth = 120,
		y = -35,
		flashy = 0,
	},

	buttons = NewIFContainer {
		y = -55,
	},

	fnSetMode = gPopup_Vote_fnSetMode,
	fnActivate = gPopup_Vote_fnActivate,
	Input_Accept = gPopup_Vote_fnInput_Accept,
	Input_GeneralRight = gPopup_Vote_fnInput_GeneralRight,
	Input_GeneralLeft = gPopup_Vote_fnInput_GeneralLeft,
	
	
	-- allowing this violates all kinds of load save tcrs, both on xbox and ps2.  mostly because
	-- it isn't "positive confirmation" of a destructive action.  if it is needed other places we
	-- should special case it with a flag or something
	-- Be more XBox-compliant
	Input_Back = function(this)
		this.CurButton = "no"
		gPopup_Vote_fnInput_Accept(this)
	end,
}

AddVerticalButtons(Popup_Vote.buttons,Popup_Vote_Buttons_layout)
Popup_Vote.buttons.x2 = Popup_Vote.buttons.x

CreatePopupInC(Popup_Vote,"Popup_Vote")
Popup_Vote = DoPostDelete(Popup_Vote)

