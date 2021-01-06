--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_purchase_tech_radius = 25
ifs_purchase_tech_radius_selected = ifs_purchase_tech_radius + 4
ifs_purchase_tech_select_anim_time = 0.6

ifs_purchase_tech_spacing = 0.25
ifs_purchase_tech_y = -2
ifs_purchase_tech_z = -55
ifs_purchase_tech_use_spacing = 5.75
ifs_purchase_tech_use_x = -2 * ifs_purchase_tech_use_spacing
ifs_purchase_tech_use_y = 4.5
ifs_purchase_tech_use_z = -35
ifs_purchase_tech_use_depth = 0.015
ifs_purchase_tech_cursor_z = ifs_purchase_tech_use_z + 0.1
ifs_purchase_tech_cursor_z_selected = ifs_purchase_tech_use_z + 1
ifs_purchase_tech_depth = 0.010
ifs_purchase_tech_rotate_time_short = 0.5
ifs_purchase_tech_rotate_time_long = 1.0
ifs_purchase_tech_spin_time = 0.5
ifs_purchase_tech_rotate = { [false] = -math.pi, [true] = 0 }

ifs_purchase_tech_empty = "gal_shell_empty"

-- freeform tech table
ifs_purchase_tech_table_freeform = {
--	{
--		mesh = "gal_shell_surveillance",
--		name = "surveillance",
--		cost = { [false] = 100, [true] = 20 },
--		bonus = "sensor_array",
--		hints = {}
--	},
	{
		mesh = "gal_shell_adrenaline",
		name = "adrenaline",
		cost = { [false] = 100, [true] = 20 },
		bonus = "energy_boost",
		hints = {
			-- great for CTF, okay for indoor maps, good otherwise
			{ "ctf$", 3 },
			{ "^dea", 1 },
			{ "^pol", 1 },
			{ "^spa", 1 },
			{ "^tan", 1 },
			{ ".*", 2 },
		}
	},
	{
		mesh = "gal_shell_supply_cache",
		name = "supply_cache",
		cost = { [false] = 100, [true] = 20 },
		bonus = "supplies",
		hints = {
			-- good on indoor levels, okay on other levels
			{ "^tan", 2 },
			{ "^pol", 2 },
			{ "^dea", 2 },
			{ "^kam", 2 },
			{ "^mus", 2 },
			{ "^nab", 2 },
			{ ".*", 1 }
		}
	},	
	{
		mesh = "gal_shell_reinforcements",
		name = "reinforcement",
		cost = { [false] = 100, [true] = 20 },
		bonus = "garrison",
		hints = {
			-- great for conquest, useless otherwise
			{ "con$", 3 },
			{ ".*", 0 },
		}
	},
	{
		mesh = "gal_shell_defense_grid",
		name = "defense_grid",
		cost = { [false] = 100, [true] = 40 },
		bonus = "autoturrets",
		hints = {
			-- great for conquest, good for indoor maps, okay otherwise
			{ "con$", 3 },
			{ "^dea", 2 },
			{ "^pol", 2 },
			{ "^spa", 2 },
			{ "^tan", 2 },
			{ ".*", 1 }
		}
	},
	{
		mesh = "gal_shell_bacta_refinery",
		name = "bacta_refinery",
		cost = { [false] = 100, [true] = 40 },
		bonus = "bacta_tanks",
		hints = {
			-- okay for space, great for conquest, good otherwise
			{ "^spa", 1 },
			{ "con$", 3 },
			{ ".*", 2 }
		}
	},
	{
		mesh = "gal_shell_advanced_armor",
		name = "advanced_armor",
		cost = { [false] = 100, [true] = 40 },
		bonus = "combat_shielding",
		hints = {
			-- good in space, great otherwise
			{ "^spa", 2 },
			{ ".*", 3 }
		}
	},
	{
		mesh = "gal_shell_espionage",
		name = "espionage",
		cost = { [false] = 100, [true] = 60 },
		bonus = "sabotage",
		hints = {
			-- great in space, good on levels with big vehicles, okay on levels with small vehicles, useless otherwise
			{ "^spa", 3 },
			{ "^geo", 2 },
			{ "^hot", 2 },
			{ "^kas", 2 },
			{ "^uta", 2 },
			{ "^fel", 1 },
			{ "^end", 1 },
			{ "^nab", 1 },
			{ "^yav", 1 },
			{ ".*", 0 }
		}
	},
	{
		mesh = "gal_shell_blaster_amplification",
		name = "blaster_amplification",
		cost = { [false] = 100, [true] = 60 },
		bonus = "advanced_blasters",
		hints = {
			-- good in space, great otherwise
			{ "^spa", 2 },
			{ ".*", 3 }
		}
	},
	{
		mesh = "gal_shell_leadership",
		name = "leadership",
		cost = { [false] = 100, [true] = 80 },
		bonus = "leader",
		hints = {
			-- useless in space, great in conquest, good otherwise
			{ "^spa", 0 },
			{ "con$", 3 },
			{ ".*", 2 }
		}
	},
}

-- campaign tech table
ifs_purchase_tech_table_campaign = {}

-- active tech table
ifs_purchase_tech_table = nil

-- purchased cards
-- (hack to remove unlocking)
ifs_purchase_tech_cards = {
	[1] = {
		true,
		true,
		true,
		true,
		true,
		true,
		true,
		true,
		true,
		true
	},
	[2] = {
		true,
		true,
		true,
		true,
		true,
		true,
		true,
		true,
		true,
		true
	}
}

-- using cards
ifs_purchase_tech_using = {
	[1] = { 0, 0, 0 },
	[2] = { 0, 0, 0 }
}

-- constants
ifs_purchase_tech_focus_cards = 1
ifs_purchase_tech_focus_using = 2

-- localization formats
ifs_purchase_tech_localize = {
	[false] = "ifs.freeform.purchase.tech.%s.technology",
	[true] = "ifs.freeform.purchase.tech.%s.enhancement",
}

ifs_purchase_tech_info_localize = {
	[false] = "ifs.freeform.purchase.tech.%s.techinfo",
	[true] = "ifs.freeform.purchase.tech.%s.enhanceinfo",
}

ifs_purchase_tech_accept = {
	[false] = "ifs.freeform.purchase.tech.research",
	[true] = "ifs.freeform.purchase.tech.apply",
}

-- sound formats
ifs_purchase_tech_entry_sound = "mtg_%s_tech_select_card"
--ifs_purchase_tech_name_sound = {
--	[false] = "mtg_%s_tech_name_%s",
--	[true] = "mtg_%s_bonus_name_%s"
--}
ifs_purchase_tech_bought_sound = {
	[false] = "mtg_%s_tech_bought_%s_us",
	[true] = "mtg_%s_bonus_bought_%s_us"
}
ifs_purchase_tech_broke_sound = {
	[false] = "mtg_%s_tech_broke_us",
	[true] = "mtg_%s_bonus_broke_us"
}

ifs_freeform_purchase_tech = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,
	scale = 0.01,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1,
	lighting_save = nil,
	selected = 1,
	offset_a = ifs_purchase_tech_spacing,
	carousel_interpolator = make_purchase_interpolator(ifs_purchase_tech_spacing, ifs_purchase_tech_spacing, 0),
	focus = ifs_purchase_tech_focus_cards,

	SetFreeformMode = function(this)
		this.main = ifs_freeform_main
		ifs_purchase_tech_table = ifs_purchase_tech_table_freeform
		this.miscScreen = "ifs_freeform_summary"
		this.menuScreen = "ifs_freeform_menu"
	end,
	
	SetCampaignMode = function(this)
		this.main = ifs_campaign_main
		ifs_purchase_tech_table = ifs_purchase_tech_table_campaign
		this.miscScreen = nil
		this.menuScreen = "ifs_campaign_menu"
	end,
	
	CanEnter = function(this)
		return next(ifs_purchase_tech_table) ~= nil
	end,
	
	Enter = function(this, bFwd)
			gIFShellScreenTemplate_fnEnter(this, bFwd)

			IFText_fnSetString(this.title.text, "ifs.freeform.navigation.bonus")
			
			--Update tabs
			if (gPlatformStr == "PC") then
				ifelem_tabmanager_SelectTabGroup(this, true)
				ifelem_tabmanager_SetSelected(this, ifs_freeform_tab_layout, "_tab_bonus")
				ifelem_tabmanager_SetDimmed(this, ifs_freeform_tab_layout, "_tab_units", not ifs_freeform_purchase_unit:CanEnter())
			else
				IFText_fnSetString(this.tableft.text, "ifs.freeform.navigation.move")
				IFText_fnSetString(this.tabright.text, "ifs.freeform.navigation.units")
				IFObj_fnSetVis(this.tabright, ifs_freeform_purchase_unit:CanEnter())
			end
			
			ifs_freeform_SetButtonName(this, "back", "common.back")
			ifs_freeform_SetButtonVis(this, "back", gPlatformStr ~= "PC")
			ifs_freeform_SetButtonVis(this, "misc", false)
			
			this.main:UpdatePlayerText(this.player)
			
			lighting_save = ScriptCB_GetIFaceLighting()
			ScriptCB_SetIFaceLighting(ifs_purchase_lighting)

			-- set up all the carousel items
			local team = this.main.playerTeam
			for i, item in ipairs(this.purchaseItems) do
				local owned = ifs_purchase_tech_cards[team][i]
				local rotate = ifs_purchase_tech_rotate[owned]
				local tech = ifs_purchase_tech_table[i]
				if tech then
					IFModel_fnSetMsh(item.card, tech.mesh)
					item.spin_interpolator = make_purchase_interpolator(rotate, rotate, 0)
				else
					IFModel_fnSetMsh(item.card, nil)
				end
			end
			
			-- set up all the using items
			for i, item in ipairs(this.useItems) do
				local using = ifs_purchase_tech_using[team][i]
				if using > 0 then
					IFModel_fnSetMsh(item.card, ifs_purchase_tech_table[using].mesh)
				else
					IFModel_fnSetMsh(item.card, ifs_purchase_tech_empty)
				end
			end
			
			-- play entry voiceover
			this.main:PlayVoice(string.format(ifs_purchase_tech_entry_sound, this.main.playerSide))
		
			-- select the first item
			this:SetSelected(1)
			this:FocusCarousel()
			
			-- clear mouse state
			this.lastDoubleClickTime = nil
			this.bDoubleClicked = nil
			this.iMouse_x = nil
			this.iMouse_y = nil
		end,

	Exit = function(this, bFwd)
			if ( this.focus == ifs_purchase_tech_focus_using ) then
				-- refund the unplaced card
				local cost = ifs_purchase_tech_table[this.useItems.cursor.index].cost[true]
				this.main:AddResources(nil, cost)
			end
			
			ScriptCB_SetIFaceLighting(lighting_save)
		end,

	Update = function(this, fDt)
			gIFShellScreenTemplate_fnUpdate(this, fDt)

			-- update zoom values
			this.main:UpdateZoom()
			
			this.carousel_interpolator:update(fDt)
			this.offset_a = this.carousel_interpolator:value()

			for i, item in ipairs(this.purchaseItems) do
				this:UpdateItem(i, item, fDt)
			end

			this:UpdateCursor(this.useItems.cursor, fDt)
		end,

	UpdateActionCarousel = function(this)
			local index = this.selected
			local team = this.main.playerTeam
			local owned = ifs_purchase_tech_cards[team][index]
			local name = ifs_purchase_tech_table[index].name
			local cost = ifs_purchase_tech_table[index].cost[owned]
			
--			this.main:PlayVoice(string.format(ifs_purchase_tech_name_sound[owned], this.main.playerSide, owned and bonus or name))
			
			IFText_fnSetString(this.info.caption, string.format(ifs_purchase_tech_localize[owned], name))
			IFText_fnSetString(this.info.text, string.format(ifs_purchase_tech_info_localize[owned], name))
			IFText_fnSetUString(this.info.subcaption, ScriptCB_usprintf("ifs.freeform.credits", ScriptCB_tounicode(cost)))
			local enough = this.main:EnoughResources(nil, cost)
			local accept_a = enough and 1.0 or 0.3
			local r, g, b = ifs_freeform_main:GetCreditsColor(enough)
			IFObj_fnSetAlpha(this.action.accept, accept_a)
			IFObj_fnSetAlpha(this.info.caption, gTitleTextAlpha)
			IFObj_fnSetAlpha(this.info.subcaption, gTitleTextAlpha)
			IFObj_fnSetColor(this.info.caption, r, g, b)
			IFObj_fnSetColor(this.info.subcaption, r, g, b)

			ifs_freeform_SetButtonName(this, "accept", ifs_purchase_tech_accept[owned] )
		end,
		
	UpdateActionUsing = function(this)
			local index = this.selected
			local team = this.main.playerTeam
			local name = ifs_purchase_tech_table[index].name
			
			IFText_fnSetString(this.info.caption, string.format(ifs_purchase_tech_localize[true], name))
			IFText_fnSetString(this.info.text, string.format(ifs_purchase_tech_info_localize[true], name))
			IFText_fnSetString(this.info.subcaption, "ifs.freeform.purchase.tech.apply")
			IFObj_fnSetAlpha(this.action.accept, 1.0)
			
			ifs_freeform_SetButtonName(this, "accept", ifs_purchase_tech_accept[true])
		end,
	
	UpdateItem = function(this, i, item, fDt)
			local a = item.original_a - this.offset_a
			local cos = math.cos(a)
			local sin = math.sin(a)

			item.radius_interpolator:update(fDt)

			local x = item.radius_interpolator:value() * sin
			local y = ifs_purchase_tech_y
			local z = ifs_purchase_tech_z + item.radius_interpolator:value() * cos

			IFObj_fnSetAlpha(item.card, cos > 0 and cos * cos * 0.825 + 0.125 or 0.125)
			
			IFModel_fnSetTranslation(item.card, x, y, z)

			item.spin_interpolator:update(fDt)
			
			local r = 0.5 * (a + item.spin_interpolator:value())
			local half_cos = math.cos(r)
			local half_sin = math.sin(r)

			local sqrt2 = math.sqrt(2) / 2

			-- cards are modeled facing vertically, so we need to rotate 90 degrees about x-axis
			local qs =  sqrt2 * half_cos
			local qx =  sqrt2 * half_cos
			local qy =  sqrt2 * half_sin
			local qz = -sqrt2 * half_sin

			IFModel_fnSetRotation(item.card, qs, qx, qy, qz)
			
		end,

	UpdateCursor = function(this, item, fDt)
			if ( this.focus == ifs_purchase_tech_focus_using ) then
				item.hilite:update(fDt)
				IFObj_fnSetAlpha(item.card, item.hilite:value())

				item.z_interpolator:update(fDt)
				IFModel_fnSetTranslation(item.card,
					item.position * ifs_purchase_tech_use_spacing + ifs_purchase_tech_use_x,
					ifs_purchase_tech_use_y,
					item.z_interpolator:value())
			else
				IFObj_fnSetAlpha(item.card, 0)
			end
		end,

	Input_KeyDown = function(this, iKey)
		if iKey == 8 then
			-- backspace -> back
			this.CurButton = "_back"
			this:Input_Accept(-1)
		elseif iKey == 10 or iKey == 13 then
			-- enter -> accept
			this.CurButton = "_accept"
			this:Input_Accept(-1)
		elseif iKey == 32 then
			-- space -> next
			this.CurButton = "_next"
			this:Input_Accept(-1)
		elseif iKey == -59 then
			-- F1 -> help
			this.CurButton = "_help"
			this:Input_Accept(-1)
		elseif iKey == 9 then
			-- tab -> next tab
			ScriptCB_SetIFScreen("ifs_freeform_purchase_unit")
		end
	end,
	
	Input_Accept = function(this, joystick)
			if(gPlatformStr == "PC") then
				if ifelem_tabmanager_HandleInputAccept(this, ifs_freeform_tab_layout) then
					return
				end
				print( "this.CurButton = ", this.CurButton )
				if( this.CurButton == "_accept" ) then
					-- purchase the item
  				elseif( this.CurButton == "_back" ) then
  					-- handle in Input_Back
  					this:Input_Back(joystick)
  					return
  				elseif( this.CurButton == "_help" ) then
  					-- handle in Input_Misc2
  					this:Input_Misc2(joystick)
  					return
				elseif( this.CurButton == "_next" ) then
					if this.miscScreen then
--						-- go to end
--						ScriptCB_SetIFScreen(this.miscScreen)
					end
				else
					-- check double click
					if( this.lastDoubleClickTime and ScriptCB_GetMissionTime()<this.lastDoubleClickTime+0.4 ) then
						this.bDoubleClicked = 1
					else
						this.lastDoubleClickTime = ScriptCB_GetMissionTime()
					end
					local ScreenW,ScreenH = ScriptCB_GetScreenInfo()
					local box_l = ScreenW * 343 / 800
					local box_t = ScreenH * 279 / 600
					local box_r = ScreenW * 457 / 800
					local box_b = ScreenH * 405 / 600
					if( this.bDoubleClicked == 1 ) then
						this.bDoubleClicked = nil
						if( ( this.iMouse_x >= box_l ) and ( this.iMouse_x <= box_r ) and
							( this.iMouse_y >= box_t ) and ( this.iMouse_y <= box_b ) ) then
							-- if click on the card
							print( "this DoubleClicked!" )
						else
							-- do nothing if not click on the unit
							return	
						end						
					else
						--print( "mouse x,y = ", this.iMouse_x, this.iMouse_y )
						-- move card if single click
						-- move card in focus mode
						if( this.focus == ifs_purchase_tech_focus_cards ) then
							if( ( this.iMouse_y >= box_t ) and ( this.iMouse_y <= box_b ) ) then
								if( this.iMouse_x < box_l ) then
									this:Input_GeneralLeft()
								elseif( this.iMouse_x > box_r ) then
									this:Input_GeneralRight()
								end
							end
							return
						end
					end
				end				
			end
			
			-- If base class handled this work, then we're done
			if(gShellScreen_fnDefaultInputAccept(this)) then
				return
			end
			
			local team = this.main.playerTeam

			-- if focused on cards			
			if ( this.focus == ifs_purchase_tech_focus_cards ) then
				local cur = this.purchaseItems[this.selected]
				local cur_rot = cur.spin_interpolator:value()

				local owned = ifs_purchase_tech_cards[team][this.selected]
				
				-- if enough resources...
				local tech = ifs_purchase_tech_table[this.selected]
				local cost = tech.cost[owned]
				if this.main:SpendResources(nil, cost) then
					this.main:UpdatePlayerText(this.player)
			 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
			 		this.main:PlayVoice(string.format(ifs_purchase_tech_bought_sound[owned], this.main.playerSide, owned and tech.bonus or tech.name))
					-- if the technology is not owned...
					if not owned then
						-- purchase the technology
						owned = true
						ifs_purchase_tech_cards[team][this.selected] = owned
						cur.spin_interpolator = make_purchase_interpolator(cur_rot, ifs_purchase_tech_rotate[owned], ifs_purchase_tech_spin_time)
						this:UpdateActionCarousel()
					else
						-- purchase the enhancement
						IFModel_fnSetMsh(this.useItems.cursor.card, tech.mesh)
						IFObj_fnSetColor(this.useItems.cursor.card, 255, 255, 255)

						this.useItems.cursor.index = this.selected
						
						-- find a free slot (if any)
						local slot = 1
						for i, using in ipairs(ifs_purchase_tech_using[team]) do
							if using == 0 then
								slot = i
								break
							end
						end
						this:SetCursor(slot)
						
						this:FocusUsing()
					end
				else
					-- not enough resources
			 		ifelm_shellscreen_fnPlaySound(this.cancelSound)
					this.main:PlayVoice(string.format(ifs_purchase_tech_broke_sound[owned], this.main.playerSide))
				end
			else
		 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
		 		local position = this.useItems.cursor.position
		 		local index = this.useItems.cursor.index
		 		
		 		-- if there is no card there...
		 		if ifs_purchase_tech_using[team][position] == 0 then
		 			-- place the card
		 			this:PlaceUsing(team, position, index)
				else
					-- pop up a yes/no request
					this:PromptReplace(team, position, index)
				end
			end

		end,
		
	PlaceUsing = function(this, team, position, index)
		ifs_purchase_tech_using[team][position] = index
		IFModel_fnSetMsh(this.useItems[position].card, ifs_purchase_tech_table[index].mesh)
		IFObj_fnSetColor(this.useItems[position].card, 255, 255, 255)
		this:FocusCarousel()
	end,
	
	PromptReplace = function(this, team, position, index)
	--	print("ifs_freeform_load_StartPromptSave")
		Popup_YesNo.CurButton = "no" -- default
		Popup_YesNo.fnDone = function(bResult)
			if(bResult) then
				-- replace existing card
				ifelm_shellscreen_fnPlaySound(this.acceptSound)
				this:PlaceUsing(team, position, index)
			else
				-- User hit no. Back to normal screen
				ifelm_shellscreen_fnPlaySound(this.cancelSound)
			end
			IFObj_fnSetVis(this.purchaseItems, true)
			IFObj_fnSetVis(this.useItems, true)
		end
		Popup_YesNo:fnActivate(1)
		gPopup_fnSetTitleStr(Popup_YesNo, "ifs.freeform.purchase.tech.replace")
		IFObj_fnSetVis(this.purchaseItems, false)
		IFObj_fnSetVis(this.useItems, false)
	end,

	Input_Back = function(this, joystick)
			if ( this.focus == ifs_purchase_tech_focus_using ) then
				-- refund the unplaced card
		 		ifelm_shellscreen_fnPlaySound(this.cancelSound)
				local cost = ifs_purchase_tech_table[this.useItems.cursor.index].cost[true]
				this.main:AddResources(nil, cost)
				this.main:UpdatePlayerText(this.player)
				this:UpdateActionCarousel()
				this:FocusCarousel()
			elseif(gPlatformStr ~= "PC") then
				-- go 'back' to the Movement screen
		 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
				ScriptCB_PopScreen();
				--ScriptCB_PushScreen("ifs_freeform_fleet")
			end
		end,

	Input_Misc = function(this, joystick)
			if(gPlatformStr == "PC") then
				-- treat as back
				this:Input_Back(joystick)
			end
--			if(gPlatformStr ~= "PC") then
--				if this.miscScreen then
--					-- go to the end
--					ScriptCB_SetIFScreen(this.miscScreen)
--				end
--			end
		end,
		
	Input_Misc2 = function(this, joystick)
		-- show the tutorial pop-up
		Popup_Tutorial.textList = {
			"ifs.freeform.tutorial.11",
			"ifs.freeform.tutorial.12",
			"ifs.freeform.tutorial.13"
			}
		Popup_Tutorial:fnActivate(1)
	end,
		
	Input_RTrigger = function(this, joystick)
		if(gPlatformStr == "PC") then
			return
		end
		if ifs_freeform_purchase_unit:CanEnter() then
			-- go to the Unit Purchase Screen
			ScriptCB_SetIFScreen("ifs_freeform_purchase_unit")
		end
	end,
	
	Input_LTrigger = function(this, joystick)
		if(gPlatformStr == "PC") then
			return
		end
		-- go to the Movement Screen
 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
		ScriptCB_PopScreen();
--		ScriptCB_PushScreen("ifs_freeform_fleet")
	end,

	Input_GeneralLeft = function(this, joystick)
			if ( this.focus == ifs_purchase_tech_focus_cards ) then
				if ( this.selected > 1 ) then
			 		ifelm_shellscreen_fnPlaySound(this.selectSound)
					this:SetSelected(this.selected - 1)
				end
			else
				if ( this.useItems.cursor.position > 1 ) then
			 		ifelm_shellscreen_fnPlaySound(this.selectSound)
					this:SetCursor(this.useItems.cursor.position - 1)
				end
			end
		end,

	Input_GeneralRight = function(this, joystick)
			if ( this.focus == ifs_purchase_tech_focus_cards ) then
				if ( this.selected < table.getn(ifs_purchase_tech_table) ) then
			 		ifelm_shellscreen_fnPlaySound(this.selectSound)
					this:SetSelected(this.selected + 1)
				end
			else
				if ( this.useItems.cursor.position < table.getn(this.useItems) ) then
			 		ifelm_shellscreen_fnPlaySound(this.selectSound)
					this:SetCursor(this.useItems.cursor.position + 1)
				end
			end
		end,

	HandleMouse = function(this, x, y)
			gIFShellScreenTemplate_fnHandleMouse(this, x, y)
			
			this.iMouse_x = x
			this.iMouse_y = y
			
			-- not focus mode
			if ( this.focus ~= ifs_purchase_tech_focus_cards ) then
				local index = ifs_purchase_tech_GetMouseUseItem( this, x, y )
				--print( "index = ", index )
				if( index ) then
					this:SetCursor( index )
				end
			end
	end,

	Input_Start = function(this, joystick)
			-- open pause menu
			ScriptCB_PushScreen(this.menuScreen)
		end,

	SetCursor = function(this, index)
			local cursor = this.useItems.cursor

			cursor.position = index
			IFModel_fnSetTranslation(cursor.card,
						index * ifs_purchase_tech_use_spacing + ifs_purchase_tech_use_x,
						ifs_purchase_tech_use_y,
						ifs_purchase_tech_cursor_z)
				
			this:UpdateActionUsing()
		end,

	FocusCarousel = function(this)
			this.focus = ifs_purchase_tech_focus_cards
			this.useItems.cursor.z_interpolator = 
				make_purchase_interpolator(
					ifs_purchase_tech_cursor_z,
					ifs_purchase_tech_cursor_z,
					0
				)

			this:Select()
			this:UpdateActionCarousel()
		end,

	FocusUsing = function(this)
			this.focus = ifs_purchase_tech_focus_using

			local cursor = this.useItems.cursor
			local start = cursor.z_interpolator:value()
			cursor.z_interpolator = 
				make_purchase_interpolator(
					start,
					ifs_purchase_tech_cursor_z_selected,
					ifs_purchase_tech_select_anim_time
				)

			this:Unselect()
			this:UpdateActionUsing()
		end,

	Build_Item = function(this, model, a, owned)
			local rotate = ifs_purchase_tech_rotate[owned]

			return NewIFContainer {
				radius_interpolator = make_purchase_interpolator(ifs_purchase_tech_radius, ifs_purchase_tech_radius, 0),

				original_a = a,
				spin_interpolator = make_purchase_interpolator(rotate, rotate, 0),

				card = NewIFModel {
					depth = ifs_purchase_tech_depth,
					alpha = 255,
					lighting = 1,
					model = model,
				},
			}
		end,

	Build_Use = function(this, x, using)
			local model = ifs_purchase_tech_empty
			local sqrt2 = math.sqrt(2) / 2

			if ( using > 0 ) then
				model = ifs_purchase_tech_table[using].mesh
			end

			return NewIFContainer {
				card = NewIFModel {
					x = x + ifs_purchase_tech_use_x,
					y = ifs_purchase_tech_use_y,
					z = ifs_purchase_tech_use_z,
					depth = ifs_purchase_tech_use_depth,
					model = model,
					lighting = 1,
					qs = sqrt2,
					qx = sqrt2,
					qy = 0,
					qz = 0,
					ColorR = 255,
					ColorG = 255,
					ColorB = 255,
				}
			}
		end,

	SetSelected = function(this, selected)
			this:Unselect()
			this.selected = selected
			this:Select()

			this.carousel_interpolator = make_purchase_interpolator(this.offset_a,
										selected * ifs_purchase_tech_spacing,
										ifs_purchase_tech_rotate_time_short)

			this:UpdateActionCarousel(selected)
		end,


	Unselect = function(this)
			local item = this.purchaseItems[this.selected]
			local start = item.radius_interpolator:value()
			item.radius_interpolator = make_purchase_interpolator(start,
											ifs_purchase_tech_radius,
											ifs_purchase_tech_select_anim_time)
		end,

	Select = function(this)
			local item = this.purchaseItems[this.selected]
			local start = item.radius_interpolator:value()
			item.radius_interpolator = make_purchase_interpolator(start,
									ifs_purchase_tech_radius_selected,
									ifs_purchase_tech_select_anim_time)
		end,
}

function ifs_purchase_tech_build_screen()
	local this = ifs_freeform_purchase_tech
	if this.purchaseItems then
		return
	end

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

	this.purchaseItems = NewIFContainer {
		x = 0,
		y = 0,
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.5,
		ZPos = 10,
		
	}
	
	for i, item in ipairs(ifs_purchase_tech_table_freeform) do
		this.purchaseItems[i] = this:Build_Item(nil, i * ifs_purchase_tech_spacing, false)
	end

	this.useItems = NewIFContainer {
		x = 0,
		y = 0,
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0,
		ZPos = 10,
	}

	for i, using in ipairs(ifs_purchase_tech_using[1]) do
		this.useItems[i] = this:Build_Use(i * ifs_purchase_tech_use_spacing, 0)
	end

	this.useItems.cursor = this:Build_Use(ifs_purchase_tech_use_spacing, 0)
	this.useItems.cursor.hilite = make_purchase_oscillator(0.65, 0.95, .5)
	this.useItems.cursor.z_interpolator = make_purchase_interpolator(ifs_purchase_tech_cursor_z, ifs_purchase_tech_cursor_z, 0)

	ifs_freeform_AddCommonElements(this)
	ifs_freeform_AddTabElements(this)
	
	-- temporarily hide main (HACK)
	local main = this.main
	this.main = nil
	AddIFScreen(this,"ifs_freeform_purchase_tech")
	this.main = main
end

function ifs_purchase_tech_load_data(...)
end

function ifs_purchase_tech_GetMouseUseItem( this, x, y )
	-- values measured from 800x600 screenshot
	local item_x = 271
	local item_y = 127
	local width =  83	
	local height = 91
	local offset_x = 88
	
	-- get item offset
	for i = 1, 3 do
		local new_item_x = item_x + (i - 1) * offset_x
		
		if( ( x >= ( new_item_x - width ) ) and ( x <= ( new_item_x + width ) ) and
			( y >= ( item_y - height ) ) and ( y <= ( item_y + height ) ) ) then
			return i
		end
	end
	
	-- mouse not on anyone
	return nil
end
