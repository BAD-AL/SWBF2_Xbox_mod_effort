--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_result_fleet_won_sound = "mtg_%s_fleet_won_us"
ifs_result_fleet_lost_sound = "mtg_%s_fleet_lost_us"
ifs_result_fleet_defend_sound = "mtg_%s_fleet_defended_us"
ifs_result_planet_won_sound = "mtg_%s_planet_won_%s_us"
ifs_result_planet_lost_sound = "mtg_%s_planet_lost_%s_us"
ifs_result_planet_defend_sound = "mtg_%s_planet_defended_%s_us"

ifs_freeform_result = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1,

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function

		ifs_freeform_main:SetZoom(2)
		MoveCameraToEntity(ifs_freeform_main.planetSelected .. "_camera")
		SnapMapCamera()

		
		IFObj_fnSetVis(this.info, false)
		
		IFText_fnSetString(this.title.text, "ifs.freeform.battleresult")
		
--		--display appropriate caption	
--		--if it's a space battle over a planet
--		if ifs_freeform_main.planetFleet[ifs_freeform_main.planetSelected] == 0 then
--			IFText_fnSetUString(this.title.text,
--				ScriptCB_usprintf("ifs.freeform.resultstring",
--					ScriptCB_getlocalizestr("planetname." .. ifs_freeform_main.planetSelected),
--					ScriptCB_getlocalizestr("ifs.freeform.spacebattleresult")
--				)
--			)		
--		--if it's a planet or deep-space battle				
--		else
--			IFText_fnSetUString(this.title.text,
--				ScriptCB_usprintf("ifs.freeform.resultstring",
--					ScriptCB_getlocalizestr("planetname." .. ifs_freeform_main.planetSelected),
--					ScriptCB_getlocalizestr("ifs.freeform.battleresult")
--				)
--			)
--		end	
		
		ifs_freeform_SetButtonVis(this, "back", nil)
		ifs_freeform_SetButtonVis(this, "misc", nil)
		ifs_freeform_SetButtonName(this, "accept", "ifs.freeform.done")
		ifs_freeform_SetButtonVis(this, "help", nil)
		

		IFObj_fnSetVis(this.player, nil)

		if bFwd then
			-- if the active team won...
			if ifs_freeform_main.playerTeam == ifs_freeform_main.winnerTeam then
				-- if the battle was a fleet battle...
				if ifs_freeform_main.fleetBattle then
					-- play appropriate VO
					if ifs_freeform_main.joystick then
						ifs_freeform_main:PlayVoice(string.format(ifs_result_fleet_won_sound, ifs_freeform_main.playerSide))
					else
						ifs_freeform_main:PlayVoice(string.format(ifs_result_fleet_lost_sound, ifs_freeform_main.otherSide))
					end
				else
					-- play appropriate VO
					if ifs_freeform_main.joystick then
						ifs_freeform_main:PlayVoice(string.format(ifs_result_planet_won_sound, ifs_freeform_main.playerSide, ifs_freeform_main.planetSelected))
					else
						ifs_freeform_main:PlayVoice(string.format(ifs_result_planet_lost_sound, ifs_freeform_main.otherSide, ifs_freeform_main.planetSelected))
					end			
				end
			else
				-- play appropriate VO
				if ifs_freeform_main.joystick then
					ifs_freeform_main:PlayVoice(string.format(ifs_result_fleet_lost_sound, ifs_freeform_main.playerSide))
				elseif ifs_freeform_main.fleetBattle then
					ifs_freeform_main:PlayVoice(string.format(ifs_result_fleet_defend_sound, ifs_freeform_main.otherSide))
				else
					ifs_freeform_main:PlayVoice(string.format(ifs_result_planet_defend_sound, ifs_freeform_main.otherSide, ifs_freeform_main.planetSelected))
				end
			end
		end
		
		-- update player results
		this:UpdateResult(this.player_result, ifs_freeform_main.playerTeam, ifs_freeform_main.joystick)
		this:UpdateResult(this.enemy_result, 3 - ifs_freeform_main.playerTeam, ifs_freeform_main.joystick_other)
		
		-- if in soak mode...
		if ifs_freeform_main.soakMode then
			-- start a display timer
			this.displayTimer = 5
		end
		
		-- prompt for save if necessary
		ifs_freeform_main:PromptSave()
	end,
	
	UpdateResult = function(this, container, team, joystick)
		-- update player name
		if joystick then
			IFText_fnSetUString(container.name, ScriptCB_GetProfileName(joystick+1))
		else
			IFText_fnSetString(container.name, ifs_freeform_main.teamName[team])
		end
		IFObj_fnSetColor(container.name, ifs_freeform_main:GetTeamColor(team))
		
		-- update battle resources
		local battleResources = ifs_freeform_main.battleResources[team]
		IFObj_fnSetVis(container.battle, true)
		if ifs_freeform_main.winnerTeam == team then
			IFText_fnSetString(container.battle.description, "ifs.freeform.result.victory")
		else
			IFText_fnSetString(container.battle.description, "ifs.freeform.result.defeat")
		end
		IFText_fnSetUString(container.battle.resources,
			ScriptCB_usprintf("ifs.freeform.result.creditadd", ScriptCB_tounicode(battleResources))
		)
		
		-- update planet resources
		local planetResources = ifs_freeform_main.planetResources[team]
		if planetResources > 0 then
			IFObj_fnSetVis(container.planet, true)
				
			-- calculate planet ownership
			local owned = 0
			for planet, pteam in pairs(ifs_freeform_main.planetTeam) do
				if pteam > 0 then
					if pteam == team then
						owned = owned + 1
					end
				end
			end
			
			IFText_fnSetUString(container.planet.description,
				ScriptCB_usprintf("ifs.freeform.result.planets", ScriptCB_tounicode(owned))
			)
			IFText_fnSetUString(container.planet.resources,
				ScriptCB_usprintf("ifs.freeform.result.creditadd", ScriptCB_tounicode(planetResources))
			)
		else
			IFObj_fnSetVis(container.planet, false)
		end

		-- update total resources		
		IFText_fnSetString(container.total.description, "ifs.freeform.result.total")
		IFText_fnSetUString(container.total.resources,
			ScriptCB_usprintf("ifs.freeform.result.creditequal", ScriptCB_tounicode(battleResources + planetResources))
		)
	end,

	Exit = function(this, bFwd)
	end,

	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt) -- call base class

		-- update zoom values
		ifs_freeform_main:UpdateZoom()
		
		-- auto-accept after the display timer elapses
		if this.displayTimer then
			this.displayTimer = this.displayTimer - fDt
			if this.displayTimer < 0 then
				this.displayTimer = nil
				if(gPlatformStr == "PC") then
					this.CurButton = "_accept"
				end
				this:Input_Accept(nil)
			end
		end
	end,
	
	Input_KeyDown = function(this, iKey)
		if iKey == 10 or iKey == 13 then
			-- enter -> accept
			this.CurButton = "_accept"
			this:Input_Accept(-1)
		end
	end,
	
	Input_Accept = function(this, joystick)
		if(gPlatformStr == "PC") then
			--print( "this.CurButton = ", this.CurButton )
			if( this.CurButton == "_accept" ) then
				-- purchase the item
			else
				return
			end
		end
		
 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
 		
		-- if the player just won a fleet battle over an enemy planet...
		if ifs_freeform_main.planetFleet[ifs_freeform_main.planetNext] == ifs_freeform_main.playerTeam and ifs_freeform_main.planetTeam[ifs_freeform_main.planetNext] == 3 - ifs_freeform_main.playerTeam then
			-- go to the battle screen again
			ScriptCB_PopScreen()
			ScriptCB_PushScreen("ifs_freeform_battle")
		else
			-- go to the summary screen
			ScriptCB_PushScreen("ifs_freeform_summary")
		end		
	end, -- Input_Accept
	
	Input_Misc = function(this, joystick)
	end,

	Input_Back = function(this, joystick)
		-- no going back from here...
	end,

	Input_Start = function(this, joystick)
		-- open pause menu
		ScriptCB_PushScreen("ifs_freeform_menu")
	end,
}

do
	local this = ifs_freeform_result
	
	local w,h = ScriptCB_GetSafeScreenInfo()

	local side_w = w * 0.6
	local side_h = h * 0.2
	local desc_w = side_w * 0.5
	local res_w = side_w * 0.5
	
	-- call shell colors for "white"
	local r, g, b = unpack(gUnselectedTextColor)
	
	--call shell colors for "yellow"	
	local r1, g1, b1 = ifs_freeform_main:GetCreditsColor(true)
	
	this.player_result = NewButtonWindow {
		ScreenRelativeX = 0.5,	--middle	
		ScreenRelativeY = 0.0,	--top
		width = side_w,
		height = side_h,
--		x = side_w * 0.5,
		y = w * .25,
		
		name = NewIFText {
			x = -side_w * 0.5,
			y = side_h * -0.5 + 5,
			font = "gamefont_medium",
			ColorR = 189, ColorG = 208, ColorB = 242,
			alpha = gTitleTextAlpha,
			textw = side_w,
			halign = "hcenter",
			valign = "top",
			nocreatebackground = 1
		},
		
		battle = NewIFContainer {
			x = -side_w * 0.5,
			y = side_h * -0.5 + 25,
			
			description = NewIFText {
				x = 15,
				font = "gamefont_small",
				ColorR = r, ColorG = g, ColorB = b,
				textw = desc_w,
				halign = "left",
				valign = "top",
				nocreatebackground = 1,
			},
			
			resources = NewIFText {
				x = side_w - res_w - 15,
				font = "gamefont_small",
				ColorR = r1, ColorG = g1, ColorB = b1,
				textw = res_w,
				halign = "right",
				valign = "top",
				nocreatebackground = 1,
			},
		},
		
		planet = NewIFContainer {
			x = -side_w * 0.5,
			y = side_h * -0.5 + 40,
			
			description = NewIFText {
				x = 15,
				font = "gamefont_small",
				ColorR = r, ColorG = g, ColorB = b,
				textw = desc_w,
				halign = "left",
				valign = "top",
				nocreatebackground = 1,
			},
			
			resources = NewIFText {
				x = side_w - res_w - 15,
				font = "gamefont_small",
				ColorR = r1, ColorG = g1, ColorB = b1,
				textw = res_w,
				halign = "right",
				valign = "top",
				nocreatebackground = 1,
			},
		},
		
		total = NewIFContainer {
			x = -side_w * 0.5,
			y = side_h * -0.5 + 55,
			
			description = NewIFText {
				x = 15,
				font = "gamefont_small",
				ColorR = r, ColorG = g, ColorB = b,
				textw = desc_w,
				halign = "left",
				valign = "top",
				nocreatebackground = 1,
			},
			
			resources = NewIFText {
				x = side_w - res_w - 15,
				font = "gamefont_small",
				ColorR = r1, ColorG = g1, ColorB = b1,
				textw = res_w,
				halign = "right",
				valign = "top",
				nocreatebackground = 1,
			},
		}
	}
	
	this.enemy_result = NewButtonWindow {
		ScreenRelativeX = 0.5,	--middle	
		ScreenRelativeY = 1.0,	--bottom
		width = side_w,
		height = side_h,
		y = -w * .25,

		name = NewIFText {
			x = -side_w * 0.5,
			y = side_h * -0.5 + 5,
			font = "gamefont_medium",
			alpha = gTitleTextAlpha,
			textw = side_w,
			halign = "hcenter",
			valign = "top",
			nocreatebackground = 1
		},
		
		battle = NewIFContainer {
			x = -side_w * 0.5,
			y = side_h * -0.5 + 25,
			
			description = NewIFText {
				x = 15,
				font = "gamefont_small",
				ColorR = r, ColorG = g, ColorB = b,
				textw = desc_w,
				halign = "left",
				valign = "top",
				nocreatebackground = 1,
			},
			
			resources = NewIFText {
				x = side_w - res_w - 15,
				font = "gamefont_small",
				ColorR = r1, ColorG = g1, ColorB = b1,
				textw = res_w,
				halign = "right",
				valign = "top",
				nocreatebackground = 1,
			},
		},
		
		planet = NewIFContainer {
			x = -side_w * 0.5,
			y = side_h * -0.5 + 40,
			
			description = NewIFText {
				x = 15,
				font = "gamefont_small",
				ColorR = r, ColorG = g, ColorB = b,
				textw = desc_w,
				halign = "left",
				valign = "top",
				nocreatebackground = 1,
			},
			
			resources = NewIFText {
				x = side_w - res_w - 15,
				font = "gamefont_small",
				ColorR = r1, ColorG = g1, ColorB = b1,
				textw = res_w,
				halign = "right",
				valign = "top",
				nocreatebackground = 1,
			},
		},
		
		total = NewIFContainer {
			x = -side_w * 0.5,
			y = side_h * -0.5 + 55,
			
			description = NewIFText {
				x = 15,
				font = "gamefont_small",
				ColorR = r, ColorG = g, ColorB = b,
				textw = desc_w,
				halign = "left",
				valign = "top",
				nocreatebackground = 1,
			},
			
			resources = NewIFText {
				x = side_w - res_w - 15,
				font = "gamefont_small",
				ColorR = r1, ColorG = g1, ColorB = b1,
				textw = res_w,
				halign = "right",
				valign = "top",
				nocreatebackground = 1,
			},
		}
	}	
end

ifs_freeform_AddCommonElements(ifs_freeform_result)
AddIFScreen(ifs_freeform_result,"ifs_freeform_result")