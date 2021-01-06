--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

local ifs_campaign_battle_card_spacing = 6.0
local ifs_campaign_battle_card_x_offset = 0
local ifs_campaign_battle_card_y = 0
local ifs_campaign_battle_card_z = -25

ifs_battle_card_enter_sound = "mtg_%s_bonus_select_play"
ifs_battle_card_cannot_sound = "mtg_%s_bonus_cannot_play"
ifs_battle_card_play_us_sound = "mtg_%s_bonus_played_%s_us"
ifs_battle_card_play_them_sound = "mtg_%s_bonus_played_%s_them"

ifs_campaign_battle_card = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1,
	
	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
	
		this.PrevButton = nil
		
		local team = ifs_campaign_main.playerTeam
		
		ifs_freeform_SetButtonVis( this, "back", nil )
		ifs_freeform_SetButtonName( this, "misc", "ifs.freeform.skipbonus")
		ifs_freeform_SetButtonVis( this, "misc", true )
		ifs_freeform_SetButtonName( this, "accept", "ifs.freeform.pickbonus")
		ifs_freeform_SetButtonVis( this, "accept", true )
		
		IFObj_fnSetVis(this.title, nil)
		IFText_fnSetUString(this.info.caption, 
			ScriptCB_usprintf("ifs.freeform.usecard",
				ScriptCB_getlocalizestr(ifs_campaign_main.teamName[team])
			)
		)

		-- map usable cards into slots
		this.useActive = { }
		local count = 0
		for i, using in ipairs(ifs_purchase_tech_using[team]) do
			local item = this.useItems[i]
			item.slot = i
			item.using = using
			if using > 0 then
				item.name = ifs_purchase_tech_table[using].name
				item.bonus = ifs_purchase_tech_table[using].bonus
				count = count + 1
				this.useActive[count] = item
				IFModel_fnSetMsh(item, ifs_purchase_tech_table[using].mesh)
				IFObj_fnSetVis(item, 1)
			else
				IFObj_fnSetVis(item, nil)
			end
		end
	
		-- position the usable cards
		for i, item in pairs(this.useActive) do
			IFModel_fnSetTranslation(item, 
				ifs_campaign_battle_card_x_offset + (i - count * 0.5) * ifs_campaign_battle_card_spacing,
				ifs_campaign_battle_card_y, ifs_campaign_battle_card_z)
			IFObj_fnSetAlpha(item, 0.5)
		end

		-- select the first available card
		if count > 0 then
			this.selected = 1
			
			IFObj_fnSetAlpha(this.useActive[this.selected], 1.0)
			
			ifs_campaign_main:PlayVoice(string.format(ifs_battle_card_enter_sound, ifs_campaign_main.playerSide))
		else
			-- auto-skip
			this:Next()
		end
		
		-- remove player group
		IFObj_fnSetVis(this.player, nil)
		
		this:UpdateAction()
	end,

	Exit = function(this, bFwd)
	end,

	Input_GeneralLeft = function(this, joystick)
		if this.useActive[this.selected - 1] then
	 		ifelm_shellscreen_fnPlaySound(this.selectSound)
			IFObj_fnSetAlpha(this.useActive[this.selected], 0.5)
			this.selected = this.selected - 1
			IFObj_fnSetAlpha(this.useActive[this.selected], 1.0)
			this:UpdateAction()
		end
	end,
	
	Input_GeneralRight = function(this, joystick)
		if this.useActive[this.selected + 1] then
	 		ifelm_shellscreen_fnPlaySound(this.selectSound)
			IFObj_fnSetAlpha(this.useActive[this.selected], 0.5)
			this.selected = this.selected + 1
			IFObj_fnSetAlpha(this.useActive[this.selected], 1.0)
			this:UpdateAction()
		end
	end,
	
	Next = function(this)
		-- go to the battle intro movie
		ScriptCB_PushScreen("ifs_campaign_battle_intro")
	end,
	
	Input_Accept = function(this, joystick)
		if(gPlatformStr == "PC") then
			--print( "this.CurButton = ", this.CurButton )
			if( this.CurButton == "_accept" ) then
				-- purchase the item
			elseif( this.CurButton == "_back" ) then
				-- handle in Input_Back
				return
			elseif( this.CurButton == "_next" ) then
				-- go to the next stage
				this:Next()
				return
			else
				return
			end
		end
	
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
 		
		-- if there is a selected card...
		local item = this.useActive[this.selected]
		if item then
	 		
			-- activate the selected card
			ActivateBonus(ifs_campaign_main.playerTeam, "team_bonus_" .. item.bonus)
			ifs_campaign_main:PlayVoice(string.format(ifs_battle_card_play_us_sound, ifs_campaign_main.playerTeam, item.bonus))
			
			-- expend the card
			ifs_purchase_tech_using[ifs_campaign_main.playerTeam][item.slot] = 0
			
			this.displayTimer = 3.0
		end
	end, -- Input_Accept

	Input_Back = function(this, joystick)
		-- can't go back
	end,

	Input_Misc = function(this, joystick)
		if(gPlatformStr ~= "PC") then
			-- go to the next stage
	 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
			this:Next()		
		end
	end,
	
	Input_Start = function(this, joystick)
		-- open pause menu
		ScriptCB_PushScreen("ifs_campaign_menu")
	end,
	
	UpdateAction = function(this)
		local team = ifs_campaign_main.playerTeam
		local item = this.useActive[this.selected]
		if item and item.using > 0 then
			IFText_fnSetString(this.info.text, string.format(ifs_purchase_tech_localize[true], item.name))
		else
			IFText_fnSetString(this.info.text, "")
		end
	end,
	
	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt) -- call base class
		
		-- wait for display timer
		if this.displayTimer then
			ifs_freeform_SetButtonVis( this, "misc", false )
			ifs_freeform_SetButtonVis( this, "accept", false )
			this.displayTimer = this.displayTimer - fDt
			if this.displayTimer < 0 then
				this.displayTimer = nil
				this:Next()		
			end
		end
	end,
}

do
	local this = ifs_campaign_battle_card
	
	local sqrt2 = math.sqrt(2) / 2

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
	
	this.useItems = {}
		
	for i, _ in ipairs(ifs_purchase_tech_using[1]) do
		this.useItems[i] = NewIFModel {
			depth = 0.010,
			lighting = 0,
			qs = sqrt2,
			qx = sqrt2,
			qy = 0,
			qz = 0,
			ColorR = 255,
			ColorG = 255,
			ColorB = 255,
		}
	end
end

ifs_freeform_AddCommonElements(ifs_campaign_battle_card)
AddIFScreen(ifs_campaign_battle_card,"ifs_campaign_battle_card")
