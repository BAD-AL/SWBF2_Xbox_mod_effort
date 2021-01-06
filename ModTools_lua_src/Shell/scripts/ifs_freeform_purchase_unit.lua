--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

local ifs_purchase_unit_anim_time = 0.5
local ifs_purchase_unit_rotate_time = 0.3

local front_depth = 0.004

local back_r = 2
local front_r = 3
local z_offset = 5.6

local spacing = .5

local ifs_purchase_animation_blend_time = .7

ifs_purchase_unit_types = { "soldier", "assault", "sniper", "engineer", "officer", "special", "pilot", "marine" }
-- ifs_purchase_unit_types = { "soldier", "special" }

ifs_purchase_unit_name = {
	soldier = "rifleman",
	pilot = "pilot",
	assault = "rocketeer",
	sniper = "sniper",
	marine = "marine",
	engineer = "engineer",
	officer = "officer",
	special = "special",
}

ifs_purchase_unit_cost = {
	soldier = 0,
	pilot = 0,
	assault = 100,
	sniper = 100,
	marine = 80,
	engineer = 100,
	officer = 180,
	special = 180,
}

rifle_anim_set = {
	animbanks = { "human_0" },
	--unselected = "human_rifle_crouch_idle_emote_full",
	unselected = { upper = "human_rifle_stand_idle_emote_full", lower = "human_rifle_stand_idle_emote_full" },
	select_start = "human_rifle_stand_idle_lookaround_full",
	select_loop = { upper = "human_rifle_stand_idle_emote_full", lower = "human_rifle_stand_idle_emote_full" },
}

bazooka_anim_set = {
	animbanks = { "human_0", "human_2" },
	--unselected = "human_bazooka_crouch_idle_emote",
	unselected = { upper = "human_bazooka_stand_idle_emote", lower = "human_rifle_stand_idle_emote_full" },
	select_start = "human_bazooka_stand_idle_lookaround",
	select_loop = { upper = "human_bazooka_stand_idle_emote", lower = "human_rifle_stand_idle_emote_full" },
}

marksperson_anim_set = {
	animbanks = { "marksperson", "human_0" },
	--unselected = "human_rifle_crouch_idle_emote_full",
	unselected = { upper = "human_rifle_stand_idle_emote_full", lower = "human_rifle_stand_idle_emote_full" },
	select_start = "human_rifle_stand_idle_lookaround_full",
	select_loop = { upper = "human_rifle_stand_idle_emote_full", lower = "human_rifle_stand_idle_emote_full" },
}

wookiee_anim_set = {
	animbanks = { "wookie", "human_0" },
	unselected = { upper = "human_rifle_stand_idle_emote_full", lower = "human_rifle_stand_idle_emote_full" },
	select_start = "human_rifle_stand_idle_lookaround_full",
	select_loop = { upper = "human_rifle_stand_idle_emote_full", lower = "human_rifle_stand_idle_emote_full" },
}
	
bdroid_rifle_anim_set = {
	animbanks = { "bdroid", "human_0" },
	unselected = "human_rifle_stand_idle_emote_full",
	select_start = "human_rifle_stand_idle_lookaround_full",
	select_loop = "human_rifle_stand_idle_emote_full",
}

bdroid_bazooka_anim_set = {
	animbanks = { "bdroid", "human_0", "human_2" },
	unselected = { upper = "human_bazooka_stand_idle_emote", lower = "human_rifle_stand_idle_emote_full" },
	select_start = "human_bazooka_stand_idle_lookaround",
	select_loop = { upper = "human_bazooka_stand_idle_emote", lower = "human_rifle_stand_idle_emote_full" },
}

sbdroid_anim_set = {
	animbanks = { "sbdroid", "human_0" },
	unselected = { upper = "sbdroid_rifle_stand_idle_emote", lower = "human_rifle_stand_idle_emote_full" },
	select_start = "sbdroid_rifle_standalert_idle_emote",
	select_loop = { upper = "sbdroid_rifle_stand_idle_emote", lower = "human_rifle_stand_idle_emote_full" },
}

magnaguard_anim_set = {
	animbanks = { "magnaguard", "human_0" },
	unselected = { upper = "human_rifle_stand_idle_emote_full", lower = "human_rifle_stand_idle_emote_full" },
	select_start = "human_rifle_stand_idle_lookaround_full",
	select_loop = { upper = "human_rifle_stand_idle_emote_full", lower = "human_rifle_stand_idle_emote_full" },
}

droideka_anim_set = {
	animbanks = { "cis_walk_droideka" },
	unselected = "fold",
	unselected_oneshot = 1,
	
	select_start = "unfold",
	select_loop = "idle",
}

-- sound formats
ifs_purchase_unit_entry_sound = "mtg_%s_unit_select"
--ifs_purchase_unit_name_sound = "mtg_%s_unit_name_%s"
ifs_purchase_unit_bought_sound = "mtg_%s_unit_bought_%s_us"
ifs_purchase_unit_broke_sound = "mtg_%s_unit_broke_us"

-- predefined teams for freeform
-- (campaign builds things up more gradually)
ifs_purchase_team_table = {
	all = {
		file = "side\\allshell.lvl",

		classes = {
			soldier = {
				name = "entity.all.inf_rifleman",
				info = "ifs.freeform.purchase.military.sides.all.soldier",
				sound = "mtg_all_unit_name_rifleman",
				body = "all_inf_soldier",
				weapon = "all_weap_inf_rifle",
				anim_set = rifle_anim_set
			},
			pilot =   {
				name = "entity.all.inf_pilot",
				info = "ifs.freeform.purchase.military.sides.all.pilot",
				sound = "mtg_all_unit_name_pilot",
				body = "all_inf_pilot",
				weapon = "all_weap_inf_pistol",
				anim_set = rifle_anim_set
			},
			assault = {
				name = "entity.all.inf_rocketeer",
				info = "ifs.freeform.purchase.military.sides.all.assault",
				sound = "mtg_all_unit_name_rocketeer",
				body = "all_inf_vanguard",
				weapon = "all_weap_inf_launcher",
				anim_set = bazooka_anim_set
			},
			sniper =  {
				name = "entity.all.inf_sniper",
				info = "ifs.freeform.purchase.military.sides.all.sniper",
				sound = "mtg_all_unit_name_sniper",
				body = "all_inf_marksperson",
				weapon = "all_weap_inf_sniperrifle",
				anim_set = marksperson_anim_set
			},
			marine = {
				name = "entity.all.inf_marine",
				info = "ifs.freeform.purchase.military.sides.all.marine",
				sound = "mtg_all_unit_name_marine",
				body = "all_inf_tantive4trooper",
				weapon = "all_weap_inf_rifle",
				anim_set = rifle_anim_set
			},
			engineer =   {
				name = "entity.all.inf_engineer",
				info = "ifs.freeform.purchase.military.sides.all.engineer",
				sound = "mtg_all_unit_name_engineer",
				body = "all_inf_engineer",
				weapon = "all_weap_inf_pistol",
				anim_set = rifle_anim_set
			},
			officer = {
				name = "entity.all.inf_officer",
				info = "ifs.freeform.purchase.military.sides.all.officer",
				sound = "mtg_all_unit_name_officer",
				body = "all_inf_bothanspy",
				weapon = "all_weap_inf_seeker",
				anim_set = rifle_anim_set
			},
			special = {
				name = "entity.all.inf_wookiee",
				info = "ifs.freeform.purchase.military.sides.all.special",
				sound = "mtg_all_unit_name_special",
				body = "all_inf_wookie",
				weapon = "all_weap_inf_bowcaster",
				anim_set = wookiee_anim_set
			},
		}
	},
				
	imp = {
		file = "side\\impshell.lvl",
		
		classes = {
			soldier = {
				name = "entity.imp.inf_rifleman",
				info = "ifs.freeform.purchase.military.sides.imp.soldier",
				sound = "mtg_imp_unit_name_rifleman",
				body = "imp_inf_stormtrooper",
				weapon = "imp_weap_inf_rifle",
				anim_set = rifle_anim_set
			},
			pilot =   {
				name = "entity.imp.inf_pilot",
				info = "ifs.freeform.purchase.military.sides.imp.pilot",
				sound = "mtg_imp_unit_name_pilot",
				body = "imp_inf_pilot",
				weapon = "imp_weap_inf_pistol",
				anim_set = rifle_anim_set
			},
			assault = {
				name = "entity.imp.inf_rocketeer",
				info = "ifs.freeform.purchase.military.sides.imp.assault",
				sound = "mtg_imp_unit_name_rocketeer",
				body = "imp_inf_shocktrooper",
				weapon = "imp_weap_inf_launcher",
				anim_set = bazooka_anim_set
			},
			sniper =  {
				name = "entity.imp.inf_sniper",
				info = "ifs.freeform.purchase.military.sides.imp.sniper",
				sound = "mtg_imp_unit_name_sniper",
				body = "imp_inf_scout",
				weapon = "imp_weap_inf_sniperrifle",
				anim_set = rifle_anim_set
			},
			marine = {
				name = "entity.imp.inf_marine",
				info = "ifs.freeform.purchase.military.sides.imp.marine",
				sound = "mtg_imp_unit_name_marine",
				body = "imp_inf_shocktrooper",
				weapon = "imp_weap_inf_rifle",
				anim_set = rifle_anim_set
			},
			engineer =   {
				name = "entity.imp.inf_engineer",
				info = "ifs.freeform.purchase.military.sides.imp.engineer",
				sound = "mtg_imp_unit_name_engineer",
				body = "imp_inf_gunner",
				weapon = "imp_weap_inf_rifle",
				anim_set = rifle_anim_set
			},
			officer = {
				name = "entity.imp.inf_officer",
				info = "ifs.freeform.purchase.military.sides.imp.officer",
				sound = "mtg_imp_unit_name_officer",
				body = "imp_inf_atatcommander",
				weapon = "com_weap_inf_torpedo",
				anim_set = rifle_anim_set
			},
			special = {
				name = "entity.imp.inf_dark_trooper",
				info = "ifs.freeform.purchase.military.sides.imp.special",
				sound = "mtg_imp_unit_name_special",
				body = "imp_inf_darktrooper",
				weapon = "imp_weap_inf_rifle",
				anim_set = rifle_anim_set
			},
		}
	},
				
	rep = {
		file = "side\\repshell.lvl",

		classes = {
			soldier = {
				name = "entity.rep.inf_ep3_rifleman",
				info = "ifs.freeform.purchase.military.sides.rep.soldier",
				sound = "mtg_rep_unit_name_rifleman",
				body = "rep_inf_ep3trooper",
				weapon = "rep_weap_inf_rifle",
				anim_set = rifle_anim_set
			},
			pilot =   {
				name = "entity.rep.inf_ep3_pilot",
				info = "ifs.freeform.purchase.military.sides.rep.pilot",
				sound = "mtg_rep_unit_name_pilot",
				body = "rep_inf_ep3spacepilot",
				weapon = "rep_weap_inf_pistol",
				anim_set = rifle_anim_set
			},
			assault = {
				name = "entity.rep.inf_ep3_rocketeer",
				info = "ifs.freeform.purchase.military.sides.rep.assault",
				sound = "mtg_rep_unit_name_rocketeer",
				body = "rep_inf_ep3heavytrooper",
				weapon = "rep_weap_inf_launcher",
				anim_set = bazooka_anim_set
			},
			sniper =  {
				name = "entity.rep.inf_ep3_sniper",
				info = "ifs.freeform.purchase.military.sides.rep.sniper",
				sound = "mtg_rep_unit_name_sniper",
				body = "rep_inf_ep3sniper",
				weapon = "rep_weap_inf_sniperrifle",
				anim_set = rifle_anim_set
			},
			marine = {
				name = "entity.rep.inf_ep3_marine",
				info = "ifs.freeform.purchase.military.sides.rep.marine",
				sound = "mtg_rep_unit_name_marine",
				body = "rep_inf_ep3trooper",
				weapon = "rep_weap_inf_rifle",
				anim_set = rifle_anim_set
			},
			engineer =   {
				name = "entity.rep.inf_ep3_engineer",
				info = "ifs.freeform.purchase.military.sides.rep.engineer",
				sound = "mtg_rep_unit_name_engineer",
				body = "rep_inf_ep3armoredpilot",
				weapon = "rep_weap_inf_rifle",
				anim_set = rifle_anim_set
			},
			officer = {
				name = "entity.rep.inf_ep3_officer",
				info = "ifs.freeform.purchase.military.sides.rep.officer",
				sound = "mtg_rep_unit_name_officer",
				body = "rep_inf_clonecommander",
				weapon = "rep_weap_inf_chaingun",
				anim_set = bazooka_anim_set
			},
			special = {
				name = "entity.rep.inf_ep3_jettrooper",
				info = "ifs.freeform.purchase.military.sides.rep.special",
				sound = "mtg_rep_unit_name_special",
				body = "rep_inf_ep3jettrooper",
				weapon = "com_weap_inf_torpedo",
				anim_set = rifle_anim_set
			},
		}
	},

	cis = {
		file = "side\\cisshell.lvl",

		classes = {
			soldier = {
				name = "entity.cis.inf_rifleman",
				info = "ifs.freeform.purchase.military.sides.cis.soldier",
				sound = "mtg_cis_unit_name_rifleman",
				body = "cis_inf_sbdroid",
				weapon = nil,
				anim_set = sbdroid_anim_set
			},
			pilot =   {
				name = "entity.cis.inf_pilot",
				info = "ifs.freeform.purchase.military.sides.cis.pilot",
				sound = "mtg_cis_unit_name_pilot",
				body = "cis_inf_bdroid",
				weapon = "cis_weap_inf_pistol",
				anim_set = bdroid_rifle_anim_set
			},
			assault = {
				name = "entity.cis.inf_rocketeer",
				info = "ifs.freeform.purchase.military.sides.cis.assault",
				sound = "mtg_cis_unit_name_rocketeer",
				body = "cis_inf_bdroid",
				weapon = "cis_weap_inf_launcher",
				anim_set = bdroid_bazooka_anim_set
			},
			sniper =  {
				name = "entity.cis.inf_sniper",
				info = "ifs.freeform.purchase.military.sides.cis.sniper",
				sound = "mtg_cis_unit_name_sniper",
				body = "cis_inf_bdroid",
				weapon = "cis_weap_inf_sniperrifle",
				anim_set = bdroid_rifle_anim_set
			},
			marine = {
				name = "entity.cis.inf_marine",
				info = "ifs.freeform.purchase.military.sides.cis.marine",
				sound = "mtg_cis_unit_name_marine",
				body = "cis_inf_bdroid",
				weapon = "cis_weap_inf_rifle",
				anim_set = bdroid_rifle_anim_set
			},
			engineer =   {
				name = "entity.cis.inf_engineer",
				info = "ifs.freeform.purchase.military.sides.cis.engineer",
				sound = "mtg_cis_unit_name_engineer",
				body = "cis_inf_bdroid",
				weapon = "cis_weap_inf_pistol",
				anim_set = bdroid_rifle_anim_set
			},
			officer = {
				name = "entity.cis.inf_officer",
				info = "ifs.freeform.purchase.military.sides.cis.officer",
				sound = "mtg_cis_unit_name_officer",
				body = "cis_inf_magnaguard",
				weapon = "com_weap_inf_torpedo",
				anim_set = magnaguard_anim_set
			},
			special = {
				name = "entity.cis.inf_droideka",
				info = "ifs.freeform.purchase.military.sides.cis.special",
				sound = "mtg_cis_unit_name_special",
				body = "cis_walk_droideka",
				weapon = nil,
				anim_set = droideka_anim_set
			},
		}
	}
}

-- active team table
ifs_purchase_unit_table = nil

-- owned units
ifs_purchase_unit_owned = {
	[1] = { soldier = true, pilot = true },
	[2] = { soldier = true, pilot = true }
}

ifs_freeform_purchase_unit = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,
	scale = 0.01,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1,
	lighting_save = nil,
	selected = 1,
	offset_a = spacing,
	carousel_interpolator = make_purchase_interpolator(spacing, spacing, 0),
	
	SetFreeformMode = function(this)
		this.main = ifs_freeform_main
		this.SetActiveSide = function(this)
			local side = this.main.playerSide
			ifs_purchase_unit_table = ifs_purchase_team_table[side].classes
		end
		this.miscScreen = "ifs_freeform_summary"
		this.menuScreen = "ifs_freeform_menu"
	end,
	
	SetCampaignMode = function(this)
		this.main = ifs_campaign_main
		ifs_purchase_unit_table = {}
		this.SetActiveSide = function(this) end
		this.miscScreen = nil
		this.menuScreen = "ifs_campaign_menu"
	end,
	
	UpdateAction = function(this, item)
	
			IFText_fnSetUString(this.info.caption, item.name)
			
			local r, g, b, a, accept_a
			local purchased = ifs_purchase_unit_owned[this.main.playerTeam][item.itemtype]
			if purchased then
				-- call shell colors for "white"
				r, g, b = unpack(gUnselectedTextColor)
				a = gUnselectedTextAlpha
				accept_a = 0.3
				IFText_fnSetString(this.info.subcaption, "ifs.freeform.purchase.military.recruited")
			else
				IFText_fnSetUString(this.info.subcaption,
					ScriptCB_usprintf("ifs.freeform.credits", ScriptCB_tounicode(ifs_purchase_unit_cost[item.itemtype]))
				)
				ifs_freeform_SetButtonVis(this, "accept", 1)
				local cost = ifs_purchase_unit_cost[item.itemtype]
				local enough = this.main:EnoughResources(nil, cost)
				r, g, b = this.main:GetCreditsColor(enough)
				a = gTitleTextAlpha
				accept_a = enough and 1.0 or 0.3
			end
			
			IFObj_fnSetColor(this.info.caption, r, g, b)
			IFObj_fnSetAlpha(this.info.caption, a)
			IFObj_fnSetColor(this.info.subcaption, r, g, b)
			IFObj_fnSetAlpha(this.info.subcaption, a)
			IFObj_fnSetAlpha(this.action.accept, accept_a)
		end,
		
	CanEnter = function(this)
		return next(ifs_purchase_unit_table) ~= nil
	end,
	
	Enter = function(this, bFwd)
			gIFShellScreenTemplate_fnEnter(this, bFwd)
			
			IFText_fnSetString(this.title.text, "ifs.freeform.navigation.units")
									
			--Update tabs
			if (gPlatformStr == "PC") then
				ifelem_tabmanager_SelectTabGroup(this, true)
				ifelem_tabmanager_SetSelected(this, ifs_freeform_tab_layout, "_tab_units")
				ifelem_tabmanager_SetDimmed(this, ifs_freeform_tab_layout, "_tab_bonus", not ifs_freeform_purchase_tech:CanEnter())
			else
				IFText_fnSetString(this.tableft.text, "ifs.freeform.navigation.bonus")
				IFObj_fnSetVis(this.tableft, ifs_freeform_purchase_tech:CanEnter())
				IFText_fnSetString(this.tabright.text, "ifs.freeform.navigation.move")
			end
			
			this.main:UpdatePlayerText(this.player)
			
			ifs_freeform_SetButtonName(this, "accept", "ifs.freeform.purchase.military.recruit")
			ifs_freeform_SetButtonName(this, "back", "common.back")
			ifs_freeform_SetButtonVis(this, "back", gPlatformStr ~= "PC")
			ifs_freeform_SetButtonVis(this, "misc", false)
			
			
			lighting_save = ScriptCB_GetIFaceLighting()
			ScriptCB_SetIFaceLighting(ifs_purchase_lighting)

			-- play entry voiceover
			this.main:PlayVoice(string.format(ifs_purchase_unit_entry_sound, this.main.playerSide))
			
			-- default to no selection
			if bFwd then
				this.selected = nil
			end
			
			-- for each purchase item...
			for i, item in ipairs(this.purchaseItems) do
				-- if the item is available
				if ifs_purchase_unit_table[item.itemtype] then
					-- fill in the item
					IFObj_fnSetVis(item, true)
					this:FinishEntity(i, item)
					this:Unselect(item)
					this:UpdateColor(item)
					-- select it if there is no selection
					if not this.selected then
					   this.selected = i
					   -- call SetSelected below, instead--cbb 07/27/05
-- 						this:Select(this.purchaseItems[this.selected])
					end
				else
					-- hide the item
					IFObj_fnSetVis(item, false)
				end
			end
			
			this:SetSelected(this.selected)
			
			-- clear mouse state
			this.lastDoubleClickTime = nil
			this.bDoubleClicked = nil
			this.iMouse_x = nil
			this.iMouse_y = nil
		end,

	Exit = function(this, bFwd)
			ScriptCB_SetIFaceLighting(lighting_save)
			
			-- skip if no items are available
			if not bFwd and not this.selected then
				ScriptCB_PopScreen()
			end
		end,

	Update = function(this, fDt)
			gIFShellScreenTemplate_fnUpdate(this, fDt)
			
			-- update zoom values
			this.main:UpdateZoom()
			
			this.carousel_interpolator:update(fDt)
			this.offset_a = this.carousel_interpolator:value()

			for _, item in ipairs(this.purchaseItems) do
				-- if the item is available
				if ifs_purchase_unit_table[item.itemtype] then
					-- update the item
					this:UpdateEntity(item, fDt)
				end
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
--		elseif iKey == 32 then
--			-- space -> next
--			this.CurButton = "_next"
--			this:Input_Accept(-1)
		elseif iKey == -59 then
			-- F1 -> help
			this.CurButton = "_help"
			this:Input_Accept(-1)
		elseif iKey == 9 then
			-- tab -> next tab
			ScriptCB_SetIFScreen("ifs_freeform_fleet")
		end
	end,
	
	Input_Accept = function(this, joystick)
			if(gPlatformStr == "PC") then
				if ifelem_tabmanager_HandleInputAccept(this, ifs_freeform_tab_layout) then
					return
				end
				print( "this.CurButton = ", this.CurButton )
				if( this.CurButton == "_accept" ) then
				
				elseif( this.CurButton == "_back" ) then
					-- handle in Input_Back
					this:Input_Back(joystick)
					return
				elseif( this.CurButton == "_help" ) then
					-- handle in Input_Misc2
					this:Input_Misc2(joystick)
					return
--				elseif( this.CurButton == "_next" ) then
--					if this.miscScreen then
--						-- go to the end
--						ScriptCB_SetIFScreen(this.miscScreen)
--					end
				else
					-- check double click
					if( this.lastDoubleClickTime and ScriptCB_GetMissionTime()<this.lastDoubleClickTime+0.4 ) then
						this.bDoubleClicked = 1
					else
						this.lastDoubleClickTime = ScriptCB_GetMissionTime()
					end
					local ScreenW,ScreenH = ScriptCB_GetScreenInfo()
					local box_l = ScreenW * 350 / 800
					local box_t = ScreenH * 150 / 600
					local box_r = ScreenW * 450 / 800
					local box_b = ScreenH * 420 / 600
					if( this.bDoubleClicked == 1 ) then
						this.bDoubleClicked = nil
						if( ( this.iMouse_x >= box_l ) and ( this.iMouse_x <= box_r ) and
							( this.iMouse_y >= box_t ) and ( this.iMouse_y <= box_b ) ) then
							-- if click on the unit
							print( "this DoubleClicked!" )
						else
							-- do nothing if not click on the unit
							return	
						end						
					else
						--print( "mouse x,y = ", this.iMouse_x, this.iMouse_y )
						-- move unit if single click
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
			
			-- If base class handled this work, then we're done
			if(gShellScreen_fnDefaultInputAccept(this)) then
				return
			end
			
			-- if enough resources to recruit...
			local item = this.purchaseItems[this.selected]
			local purchased = ifs_purchase_unit_owned[this.main.playerTeam][item.itemtype]
			local cost = ifs_purchase_unit_cost[item.itemtype]
			if purchased then
				-- already owned
		 		ifelm_shellscreen_fnPlaySound(this.cancelSound)
			elseif this.main:SpendResources(nil, cost) then
				-- purchase the item
		 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
				ifs_purchase_unit_owned[this.main.playerTeam][item.itemtype] = true
				this.main:UpdatePlayerText(this.player)
				this:UpdateAction(item)
				this:UpdateColor(item)
				this.main:PlayVoice(string.format(ifs_purchase_unit_bought_sound, this.main.playerSide, ifs_purchase_unit_name[item.itemtype]))
			else
				-- not enough resources
		 		ifelm_shellscreen_fnPlaySound(this.cancelSound)
				this.main:PlayVoice(string.format(ifs_purchase_unit_broke_sound, this.main.playerSide))
			end
		end,
	
	Input_Back = function(this, joystick)
			if(gPlatformStr ~= "PC") then
				-- go 'back' to Movement screen
		 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
				ScriptCB_PopScreen();
				--ScriptCB_PushScreen("ifs_freeform_fleet")
			end
		end,
		
	Input_Misc = function(this, joystick)
--			if(gPlatformStr ~= "PC") then
--				if this.miscScreen then
--					-- go to the end
--			 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
--					ScriptCB_SetIFScreen(this.miscScreen)
--				end
--			end
		end,
		
	Input_Misc2 = function(this, joystick)
		-- show the tutorial pop-up
		Popup_Tutorial.textList = {
			"ifs.freeform.tutorial.8",
			"ifs.freeform.tutorial.9",
			"ifs.freeform.tutorial.10"
			}
		Popup_Tutorial:fnActivate(1)
	end,
	
	Input_LTrigger = function(this, joystick)
		if(gPlatformStr == "PC") then
			return
		end
		if ifs_freeform_purchase_tech:CanEnter() then
			-- go to the Bonus Purchase Screen
	 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
			ScriptCB_SetIFScreen("ifs_freeform_purchase_tech")		
		end
	end,
	
	Input_RTrigger = function(this, joystick)
		if(gPlatformStr == "PC") then
			return
		end
		-- go to the Movement Screen
 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
		ScriptCB_PopScreen();
	end,
	
	Input_GeneralLeft = function(this, joystick)
			for s=this.selected-1,1,-1 do
				if ifs_purchase_unit_table[this.purchaseItems[s].itemtype] then
			 		ifelm_shellscreen_fnPlaySound(this.selectSound)
					this:SetSelected(s)
					break
				end
			end
		end,

	Input_GeneralRight = function(this, joystick)
			for s=this.selected+1,table.getn(this.purchaseItems),1 do
				if ifs_purchase_unit_table[this.purchaseItems[s].itemtype] then
			 		ifelm_shellscreen_fnPlaySound(this.selectSound)
					this:SetSelected(s)
					break
				end
			end
		end,

	Input_GeneralUp = function(this, joystick)
		end,

	Input_GeneralDown = function(this, joystick)
		end,

	HandleMouse = function(this, x, y)
		gIFShellScreenTemplate_fnHandleMouse(this, x, y)
		
		this.iMouse_x = x
		this.iMouse_y = y
	end,
	
	Input_Start = function(this, joystick)
			-- open pause menu
			ScriptCB_PushScreen(this.menuScreen)
		end,

	UpdateColor = function(this, entity)
			if ifs_purchase_unit_owned[this.main.playerTeam][entity.itemtype] then
				ScriptCB_IFObj_SetColor(entity.body.cp, ifs_purchase_bright_color, ifs_purchase_bright_color, ifs_purchase_bright_color)
				ScriptCB_IFObj_SetColor(entity.weapon.cp, ifs_purchase_bright_color, ifs_purchase_bright_color, ifs_purchase_bright_color)
			else
				ScriptCB_IFObj_SetColor(entity.body.cp, ifs_purchase_dark_color, ifs_purchase_dark_color, ifs_purchase_dark_color)
				ScriptCB_IFObj_SetColor(entity.weapon.cp, ifs_purchase_dark_color, ifs_purchase_dark_color, ifs_purchase_dark_color)
			end
		end,

	SetSelected = function(this, selected)
			 this:Unselect(this.purchaseItems[this.selected])
			 this.selected = selected
			 this:Select(this.purchaseItems[this.selected])

			 this.carousel_interpolator = make_purchase_interpolator(this.offset_a, selected * spacing, ifs_purchase_unit_rotate_time)
		      end,
	
	Select = function(this, entity)
			this:UpdateAction(entity)

			local class = ifs_purchase_unit_table[entity.itemtype]
			
--			this.main:PlayVoice(string.format(ifs_purchase_unit_name_sound, this.main.playerSide, ifs_purchase_unit_name[entity.itemtype]))
			
			IFText_fnSetUString(this.info.text, entity.info)

			ScriptCB_IFModel_SetAnimationLooping(entity.body.cp, 1)
			ScriptCB_IFModel_SetAnimation(entity.body.cp, class.anim_set.select_start, ifs_purchase_animation_blend_time)
			ScriptCB_IFModel_SetAnimationTime(entity.body.cp, 0)
			ScriptCB_IFModel_SetAnimationTime(entity.weapon.cp, 0)
			ScriptCB_IFModel_QueueAnimation(entity.body.cp, class.anim_set.select_loop)

			local start = entity.radius_interpolator:value()
			entity.radius_interpolator = make_purchase_interpolator(start, front_r, ifs_purchase_unit_anim_time)
		end,

	Unselect = function(this, entity)
			local class = ifs_purchase_unit_table[entity.itemtype]

			if ( class.anim_set.unselected_oneshot ) then
			   ScriptCB_IFModel_SetAnimationLooping(entity.body.cp, 0)
			end
			ScriptCB_IFModel_SetAnimation(entity.body.cp, class.anim_set.unselected, ifs_purchase_animation_blend_time)
			ScriptCB_IFModel_SetAnimationTime(entity.body.cp, 0)
			ScriptCB_IFModel_SetAnimationTime(entity.weapon.cp, 0)

			local start = entity.radius_interpolator:value()
			entity.radius_interpolator = make_purchase_interpolator(start, back_r, ifs_purchase_unit_anim_time)
		end,

	UpdateEntity = function(this, entity, dt)
			ScriptCB_IFModel_UpdateAnimation(entity.body.cp, dt)

			IFObj_fnSetZPos(entity.body, 200)

			local a = entity.original_a - this.offset_a
			local cos = math.cos(a)
			local sin = math.sin(a)

			entity.radius_interpolator:update(dt)

			local x = entity.radius_interpolator:value() * sin
			local y = -0.8
			local z = -z_offset + entity.radius_interpolator:value() * cos

			IFModel_fnSetTranslation(entity.body, x, y, z)

			local r = 0.5 * a
			local half_cos = math.cos(r)
			local half_sin = math.sin(r)

			local sqrt2 = math.sqrt(2) / 2

			IFModel_fnSetRotation(entity.body, half_cos, 0, half_sin, 0)
		end,

	FinishEntity = function(this, index, entity)
			local type = ifs_purchase_unit_types[index]
			local class = ifs_purchase_unit_table[type]
			IFModel_fnSetMsh(entity.body, class.body)
			IFModel_fnSetMsh(entity.weapon, class.weapon)
			entity.name = ScriptCB_getlocalizestr(class.name)
			entity.info = ScriptCB_getlocalizestr(class.info)
			IFModel_fnAttachModel( entity.body, entity.weapon, "hp_weapons" )
			ScriptCB_IFModel_SetAnimationBanks(entity.body.cp, unpack(class.anim_set.animbanks))

			if ( class.anim_set.unselected_oneshot ) then
			   ScriptCB_IFModel_SetAnimationLooping(entity.body.cp, 0)
			end
			ScriptCB_IFModel_SetAnimation(entity.body.cp, class.anim_set.unselected, 0)

			ScriptCB_IFModel_UpdateAnimation(entity.body.cp, 0)
			local animtime = math.random()
			ScriptCB_IFModel_SetAnimationTime(entity.body.cp, animtime)
			ScriptCB_IFModel_SetAnimationTime(entity.weapon.cp, animtime)

			entity.radius_interpolator = make_purchase_interpolator(back_r, back_r, 0)
			this:UpdateEntity(entity, 0)
		end,
}

function build_entity(itemtype, a)
	return NewIFContainer {
		original_a = a,
		itemtype = itemtype,

		weapon = NewIFModel {
			alpha = 255,
			lighting = 1,
		},

		body = NewIFModel {
			depth = front_depth,
			alpha = 255,
			lighting = 1,
		},
	}
end

function ifs_purchase_unit_build_screen()
	local this = ifs_freeform_purchase_unit
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
	
	local entries = table.getn(ifs_purchase_unit_types)
	local a = 0

	for i, item in ipairs(ifs_purchase_unit_types) do
		a = a + spacing
		this.purchaseItems[i] = build_entity(item, a)
	end

	ifs_freeform_AddCommonElements(this)
	ifs_freeform_AddTabElements(this)

	-- Fix for BF2 bug 11121 - move info box in front of models
	this.info.ZPos = 10
	this.info.text.ZPos = 9
	this.info.caption.ZPos = 9
	this.info.subcaption.ZPos = 9

	-- hide this.main while building screen
	local main = this.main
	this.main = nil
	AddIFScreen(this,"ifs_freeform_purchase_unit")
	this.main = main
end

function ifs_purchase_unit_load_data(...)
	for i, team in ipairs(arg) do
		local entry = ifs_purchase_team_table[team]
		ReadDataFile(entry.file)
	end
end
