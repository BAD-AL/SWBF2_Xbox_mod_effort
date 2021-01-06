--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Hero Options

function ifs_mp_heroopts_fnSetupDefaults(this)
	-- Read all the params as a table now - NM 5/2/05
	this.Prefs = ScriptCB_GetNetHeroDefaults()
end

-- Sets the the text for the options.
function ifs_mp_heroopts_fnSetOptionText(this)
	
	--set the text	
	local NewStr = ""

	-- hero unlock
	if(this.Prefs.iHeroUnlock == 1) then
		RoundIFButtonLabel_fnSetString(this.buttons.herounlock,"ifs.mp.heroopts.herounlock1")
		this.buttons.herounlockval.hidden = 1
	elseif (this.Prefs.iHeroUnlock == 2) then
		RoundIFButtonLabel_fnSetString(this.buttons.herounlock,"ifs.mp.heroopts.herounlock2")
		NewStr = ScriptCB_usprintf("ifs.mp.heroopts.reinforcements",
															 ScriptCB_tounicode(string.format("%d",this.Prefs.iHeroUnlockVal)))
		this.buttons.herounlockval.hidden = nil
		RoundIFButtonLabel_fnSetUString(this.buttons.herounlockval,NewStr)
	elseif (this.Prefs.iHeroUnlock == 3) then
		RoundIFButtonLabel_fnSetString(this.buttons.herounlock,"ifs.mp.heroopts.herounlock3")
		NewStr = ScriptCB_usprintf("ifs.mp.heroopts.numpoints",
															 ScriptCB_tounicode(string.format("%d",this.Prefs.iHeroUnlockVal)))
		this.buttons.herounlockval.hidden = nil
		RoundIFButtonLabel_fnSetUString(this.buttons.herounlockval,NewStr)
	elseif (this.Prefs.iHeroUnlock == 4) then
		RoundIFButtonLabel_fnSetString(this.buttons.herounlock,"ifs.mp.heroopts.herounlock4")
		NewStr = ScriptCB_usprintf("ifs.mp.heroopts.numkills",
															 ScriptCB_tounicode(string.format("%d",this.Prefs.iHeroUnlockVal)))
		this.buttons.herounlockval.hidden = nil
		RoundIFButtonLabel_fnSetUString(this.buttons.herounlockval,NewStr)
	elseif (this.Prefs.iHeroUnlock == 5) then
		RoundIFButtonLabel_fnSetString(this.buttons.herounlock,"ifs.mp.heroopts.herounlock5")
		NewStr = ScriptCB_usprintf("ifs.mp.heroopts.numseconds",
															 ScriptCB_tounicode(string.format("%d",this.Prefs.iHeroUnlockVal)))
		this.buttons.herounlockval.hidden = nil
		RoundIFButtonLabel_fnSetUString(this.buttons.herounlockval,NewStr)
	elseif (this.Prefs.iHeroUnlock == 6) then
		RoundIFButtonLabel_fnSetString(this.buttons.herounlock,"ifs.mp.heroopts.herounlock6")
		NewStr = ScriptCB_usprintf("ifs.mp.heroopts.numcaptures",
															 ScriptCB_tounicode(string.format("%d",this.Prefs.iHeroUnlockVal)))
		this.buttons.herounlockval.hidden = nil
		RoundIFButtonLabel_fnSetUString(this.buttons.herounlockval,NewStr)
	end
	
	-- hero team
	if(this.Prefs.iHeroTeam == 1) then
		RoundIFButtonLabel_fnSetString(this.buttons.heroteam,"ifs.mp.heroopts.heroteam1")
	elseif (this.Prefs.iHeroTeam == 2) then
		RoundIFButtonLabel_fnSetString(this.buttons.heroteam,"ifs.mp.heroopts.heroteam2")
	elseif (this.Prefs.iHeroTeam == 3) then
		RoundIFButtonLabel_fnSetString(this.buttons.heroteam,"ifs.mp.heroopts.heroteam3")
	elseif (this.Prefs.iHeroTeam == 4) then
		RoundIFButtonLabel_fnSetString(this.buttons.heroteam,"ifs.mp.heroopts.heroteam4")
	end
	-- hero player
	if(this.Prefs.iHeroPlayer == 1) then
		RoundIFButtonLabel_fnSetString(this.buttons.heroplayer,"ifs.mp.heroopts.heroplayer1")
	elseif (this.Prefs.iHeroPlayer == 2) then
		RoundIFButtonLabel_fnSetString(this.buttons.heroplayer,"ifs.mp.heroopts.heroplayer2")
	elseif (this.Prefs.iHeroPlayer == 3) then
		RoundIFButtonLabel_fnSetString(this.buttons.heroplayer,"ifs.mp.heroopts.heroplayer3")
	elseif (this.Prefs.iHeroPlayer == 4) then
		RoundIFButtonLabel_fnSetString(this.buttons.heroplayer,"ifs.mp.heroopts.heroplayer4")
	elseif (this.Prefs.iHeroPlayer == 5) then
		RoundIFButtonLabel_fnSetString(this.buttons.heroplayer,"ifs.mp.heroopts.heroplayer5")
	elseif (this.Prefs.iHeroPlayer == 6) then
		RoundIFButtonLabel_fnSetString(this.buttons.heroplayer,"ifs.mp.heroopts.heroplayer6")
	elseif (this.Prefs.iHeroPlayer == 7) then
		RoundIFButtonLabel_fnSetString(this.buttons.heroplayer,"ifs.mp.heroopts.heroplayer7")
	elseif (this.Prefs.iHeroPlayer == 8) then
		RoundIFButtonLabel_fnSetString(this.buttons.heroplayer,"ifs.mp.heroopts.heroplayer8")
	end

	-- hero respawn
	if(this.Prefs.iHeroRespawn == 1) then
		RoundIFButtonLabel_fnSetString(this.buttons.herorespawn,"ifs.mp.heroopts.herorespawn1")
		this.buttons.herorespawnval.hidden = 1
	elseif (this.Prefs.iHeroRespawn == 2) then
		RoundIFButtonLabel_fnSetString(this.buttons.herorespawn,"ifs.mp.heroopts.herorespawn2")
		NewStr = ScriptCB_usprintf("ifs.mp.heroopts.respawntimer",
															 ScriptCB_tounicode(string.format("%d",this.Prefs.iHeroRespawnVal)))
		this.buttons.herorespawnval.hidden = nil
		RoundIFButtonLabel_fnSetUString(this.buttons.herorespawnval,NewStr)
	end
	ShowHideVerticalButtons(this.buttons,ifs_mp_heroopts_vbutton_layout)
end

-- Helper function, updates helptext
function ifs_mp_heroopts_fnUpdateHelptext(this)
	if(this.Helptext_Accept) then
		IFText_fnSetString(this.Helptext_Accept.helpstr,"ifs.onlinelobby.launch")
		gHelptext_fnMoveIcon(this.Helptext_Accept)
	end
end

ifs_mp_heroopts = NewIFShellScreen {
	nologo = 1,
	bg_texture = "iface_bgmeta_space",
	movieIntro      = nil,
	movieBackground = nil,
	bNohelptext_backPC = 1,
	bAcceptIsSelect = 1,

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = gDefaultButtonScreenRelativeY,
	},

	fnDone = nil, -- Callback function to do something when the user is done
	
	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call base class
		
		ifs_mp_heroopts_fnSetupDefaults(this)

		if(bFwd) then
			this.CurButton = ShowHideVerticalButtons(this.buttons,ifs_mp_heroopts_vbutton_layout)
			SetCurButton(this.CurButton)
			ifs_mp_heroopts_fnUpdateHelptext(this)
			ifs_mp_heroopts_fnSetOptionText(this)
		end
	end,

	Exit = function(this, bFwd)
					 if(gCurHiliteButton) then
						 IFButton_fnSelect(gCurHiliteButton,nil)
					 end
				 end,

	Input_Accept = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		ScriptCB_SndPlaySound("shell_menu_enter")

		if (gPlatformStr ~= "PC") then
			ScriptCB_SetNetHeroDefaults(this.Prefs)
			ifs_mp_gameopts.bAutoLaunch = 1
			ScriptCB_BeginLobby()
			ScriptCB_PopScreen()
		elseif (this.CurButton == "_ok") then
			ScriptCB_SetNetHeroDefaults(this.Prefs)
			ScriptCB_PopScreen()
		elseif (this.CurButton == "_back") then
			this:Input_Back(this)
		else
			this:Input_GeneralRight(1)
		end
	end, -- end of Input_Accept

	Update = function(this, fDt)
						 -- Call default base class's update function (make button bounce)
						 gIFShellScreenTemplate_fnUpdate(this,fDt)
					 end,

	Input_Misc = function(this)
								 this:Input_GeneralLeft(1)
							 end,

	Input_Back = function(this)
		if (gPlatformStr ~= "PC") then
			ScriptCB_PopScreen()
		else
			ScriptCB_SetIFScreen("ifs_mp_gameopts")
		end
	end,

	Input_GeneralUp = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputUp(this)) then
			return
		end

		gDefault_Input_GeneralUp(this)
		ifs_mp_heroopts_fnUpdateHelptext(this)
	end,

	Input_GeneralDown = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputDown(this)) then
			return
		end

		gDefault_Input_GeneralDown(this)
		ifs_mp_heroopts_fnUpdateHelptext(this)
	end,

	Input_LTrigger = function(this)
		if(this.CurButton == "herounlockval") then
			if(this.Prefs.iHeroUnlock ==1) then
			else
				this.Prefs.iHeroUnlockVal = math.max(1,this.Prefs.iHeroUnlockVal - 10)
			end
		elseif (this.CurButton == "herorespawnval") then
			if(this.Prefs.iHeroRespawn ==2) then
				this.Prefs.iHeroRespawnVal = math.max(0,this.Prefs.iHeroRespawnVal - 10)
			end
		end
		ifs_mp_heroopts_fnSetOptionText(this)
	end,

	Input_RTrigger = function(this)
		if(this.CurButton == "herounlockval") then
			if(this.Prefs.iHeroUnlock ==1) then
			elseif (this.Prefs.iHeroUnlock ==2) then
				this.Prefs.iHeroUnlockVal = math.min(99,this.Prefs.iHeroUnlockVal + 10)
			else
				this.Prefs.iHeroUnlockVal = math.min(500,this.Prefs.iHeroUnlockVal + 10)
			end
		elseif (this.CurButton == "herorespawnval") then
			if(this.Prefs.iHeroRespawn ==2) then
				this.Prefs.iHeroRespawnVal = math.min(500,this.Prefs.iHeroRespawnVal + 10)
			end
		end
		ifs_mp_heroopts_fnSetOptionText(this)
	end,

	Input_GeneralLeft = function(this)
		if(this.CurButton == "herounlock") then
			this.Prefs.iHeroUnlock = math.max(1,this.Prefs.iHeroUnlock - 1)
			if(this.Prefs.iHeroUnlock == 1) then
			elseif (this.Prefs.iHeroUnlock == 2) then
				this.Prefs.iHeroUnlockVal = math.max(1,this.Prefs.iHeroUnlockVal)
				this.Prefs.iHeroUnlockVal = math.min(99,this.Prefs.iHeroUnlockVal)
			else
				this.Prefs.iHeroUnlockVal = math.max(1,this.Prefs.iHeroUnlockVal)
				this.Prefs.iHeroUnlockVal = math.min(500,this.Prefs.iHeroUnlockVal)
			end
		elseif (this.CurButton == "herounlockval") then
			if(this.Prefs.iHeroUnlock ==1) then
			else
				this.Prefs.iHeroUnlockVal = math.max(1,this.Prefs.iHeroUnlockVal - 1)
			end
		elseif (this.CurButton == "heroplayer") then
			this.Prefs.iHeroPlayer = math.max(1,this.Prefs.iHeroPlayer - 1)
		elseif (this.CurButton == "heroteam") then
			this.Prefs.iHeroTeam = math.max(1,this.Prefs.iHeroTeam - 1)

			--
			-- if not both teams cycle, then don't allow Hero Slayer mode
			if(this.Prefs.iHeroTeam ~= 4) then
				this.Prefs.iHeroPlayer = math.min(7,this.Prefs.iHeroPlayer)
			end
		elseif (this.CurButton == "herorespawn") then
			this.Prefs.iHeroRespawn = math.max(1,this.Prefs.iHeroRespawn - 1)
			if(this.Prefs.iHeroRespawn == 2) then
				this.Prefs.iHeroRespawnVal = math.max(0,this.Prefs.iHeroRespawnVal)
				this.Prefs.iHeroRespawnVal = math.min(500,this.Prefs.iHeroRespawnVal)
			end
		elseif (this.CurButton == "herorespawnval") then
			if(this.Prefs.iHeroRespawn ==2) then
				this.Prefs.iHeroRespawnVal = math.max(0,this.Prefs.iHeroRespawnVal - 1)
			end
		end
		ifelm_shellscreen_fnPlaySound(this.selectSound)
		ifs_mp_heroopts_fnSetOptionText(this)
	end,

	Input_GeneralRight = function(this)
		if(this.CurButton == "herounlock") then
			this.Prefs.iHeroUnlock = math.min(6,this.Prefs.iHeroUnlock + 1)
			if(this.Prefs.iHeroUnlock == 1) then
				elseif (this.Prefs.iHeroUnlock == 2) then
				this.Prefs.iHeroUnlockVal = math.max(1,this.Prefs.iHeroUnlockVal)
				this.Prefs.iHeroUnlockVal = math.min(99,this.Prefs.iHeroUnlockVal)
			else
				this.Prefs.iHeroUnlockVal = math.max(1,this.Prefs.iHeroUnlockVal)
				this.Prefs.iHeroUnlockVal = math.min(500,this.Prefs.iHeroUnlockVal)
			end
		elseif (this.CurButton == "herounlockval") then
			if(this.Prefs.iHeroUnlock ==1) then
			elseif (this.Prefs.iHeroUnlock ==2) then
				this.Prefs.iHeroUnlockVal = math.min(99,this.Prefs.iHeroUnlockVal + 1)
			else
				this.Prefs.iHeroUnlockVal = math.min(500,this.Prefs.iHeroUnlockVal + 1)
			end
		elseif (this.CurButton == "heroplayer") then
			--
			-- only allow hero slayer mode when in both teams cycle
			if(this.Prefs.iHeroTeam == 4) then
				this.Prefs.iHeroPlayer = math.min(8,this.Prefs.iHeroPlayer + 1)
			else
				this.Prefs.iHeroPlayer = math.min(7,this.Prefs.iHeroPlayer + 1)
			end
		elseif (this.CurButton == "heroteam") then
			this.Prefs.iHeroTeam = math.min(4,this.Prefs.iHeroTeam + 1)
			--
			-- if not both teams cycle, then don't allow Hero Slayer mode
			if(this.Prefs.iHeroTeam ~= 4) then
				this.Prefs.iHeroPlayer = math.min(7,this.Prefs.iHeroPlayer)
			end
		elseif (this.CurButton == "herorespawn") then
			this.Prefs.iHeroRespawn = math.min(2,this.Prefs.iHeroRespawn + 1)
			if(this.Prefs.iHeroRespawn == 2) then
				this.Prefs.iHeroRespawnVal = math.max(0,this.Prefs.iHeroRespawnVal)
				this.Prefs.iHeroRespawnVal = math.min(500,this.Prefs.iHeroRespawnVal)
			end
		elseif (this.CurButton == "herorespawnval") then
			if(this.Prefs.iHeroRespawn ==2) then
				this.Prefs.iHeroRespawnVal = math.min(500,this.Prefs.iHeroRespawnVal + 1)
			end
		end
		ifelm_shellscreen_fnPlaySound(this.selectSound)
		ifs_mp_heroopts_fnSetOptionText(this)
	end,
}

ifs_mp_heroopts_vbutton_layout = {
	--	yTop = 40, -- auto-calc'd now to be centered vertically
	ySpacing  = 5,
	--	width = 350, 	-- Calculated below as a % of screen size
	font = gMenuButtonFont,
	buttonlist = { 
		{ tag = "herounlock", string2 = "" },
		{ tag = "herounlockval", string2 = "", },
		{ tag = "heroteam", string2 = "", },
		{ tag = "heroplayer", string2 = "", },
		{ tag = "herorespawn", string2 = "", },
		{ tag = "herorespawnval", string2 = "", },
	},
	title = "ifs.mp.heroopts.title",
	rotY = 40,
}

-- Helper function, builds this screen.
function ifs_mp_heroopts_fnBuildScreen(this)
	local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen

	if(gLangStr ~= "english") then
		ifs_mp_heroopts_vbutton_layout.font = "gamefont_small"
	end

	ifs_mp_heroopts_vbutton_layout.width = w * 0.85
	this.CurButton = AddVerticalButtons(this.buttons,ifs_mp_heroopts_vbutton_layout)
	
	if(gPlatformStr == "PC") then

		local BackButtonW = 100
		local BackButtonH = 25
		this.donebutton =	NewClickableIFButton
		{
			ScreenRelativeX = 1.0, -- right
			ScreenRelativeY = 1.0, -- bottom
			y = -15, -- just above bottom
			x = -BackButtonW,
			btnw = BackButtonW, 
			btnh = BackButtonH,
			font = "gamefont_medium", 
			bg_width = BackButtonW, 
			tag = "_ok",
			bg_xflipped = 1,
			nocreatebackground=1,			
		}
		RoundIFButtonLabel_fnSetString(this.donebutton,"common.accept")
		
		this.cancelbutton =	NewClickableIFButton
		{
			ScreenRelativeX = 0.0, -- right
			ScreenRelativeY = 1.0, -- bottom
			y = -15, -- just above bottom
			x = BackButtonW,
			btnw = BackButtonW, 
			btnh = BackButtonH,
			font = "gamefont_medium", 
			bg_width = BackButtonW, 
			
			tag = "_back",
			nocreatebackground=1,			
		}
		RoundIFButtonLabel_fnSetString(this.cancelbutton,"common.cancel")
	end
end


ifs_mp_heroopts_fnBuildScreen(ifs_mp_heroopts)
ifs_mp_heroopts_fnBuildScreen = nil -- clear out of memory to save space
AddIFScreen(ifs_mp_heroopts,"ifs_mp_heroopts")
