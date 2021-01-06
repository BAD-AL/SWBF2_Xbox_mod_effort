--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

local ifs_freeform_battle_card_spacing = 6.0
local ifs_freeform_battle_card_x_offset = 0
local ifs_freeform_battle_card_y = 0
local ifs_freeform_battle_card_z = -25

ifs_battle_card_enter_sound = "mtg_%s_bonus_select_play"
ifs_battle_card_cannot_sound = "mtg_%s_bonus_cannot_play"
ifs_battle_card_play_us_sound = "mtg_%s_bonus_played_%s_us"
ifs_battle_card_play_them_sound = "mtg_%s_bonus_played_%s_them"

ifs_freeform_battle_card = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1,
	
	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
	
		this.PrevButton = nil
		
		local team = ifs_freeform_main.playerTeam

		ifs_freeform_SetButtonVis( this, "back", nil )
		ifs_freeform_SetButtonVis( this, "help", nil )
		ifs_freeform_SetButtonName( this, "misc", "ifs.freeform.skipbonus")
		ifs_freeform_SetButtonVis( this, "misc", ifs_freeform_main.joystick )
		ifs_freeform_SetButtonName( this, "accept", "ifs.freeform.pickbonus")
		ifs_freeform_SetButtonVis( this, "accept", ifs_freeform_main.joystick )
		
		IFText_fnSetString(this.title.text, "ifs.freeform.usecard")

		-- map usable cards into slots
		this.useActive = { }
		local count = 0
		local active = nil
		for i, using in ipairs(ifs_purchase_tech_using[team]) do
			local item = this.useItems[i]
			item.slot = i
			item.using = using
			if using > 0 then
				local tech = ifs_purchase_tech_table[using]
				
				item.weight = 0
				for _, hint in ipairs(tech.hints) do
					if string.find(ifs_freeform_main.launchMission, hint[1]) then
						item.weight = hint[2]
						print(tech.name, item.weight)
						break
					end
				end
				
				item.name = tech.name
				item.bonus = tech.bonus
				count = count + 1
				this.useActive[count] = item
				IFModel_fnSetMsh(item, tech.mesh)
				IFObj_fnSetVis(item, 1)
				
				if not active and item.weight > 0 then
					active = count
				end
			else
				IFObj_fnSetVis(item, nil)
			end
		end
	
		-- position the usable cards
		for i, item in pairs(this.useActive) do
			IFModel_fnSetTranslation(item, 
				ifs_freeform_battle_card_x_offset + (i - count * 0.5 - 0.5) * ifs_freeform_battle_card_spacing,
				ifs_freeform_battle_card_y, ifs_freeform_battle_card_z)
			IFObj_fnSetAlpha(item, item.weight > 0 and 0.5 or 0.125)
		end
		this.selected = nil

		-- if any cards are available...
		if count > 0 then
			-- if this is a player...
			if ifs_freeform_main.joystick then
				-- select the first available card
				this:SetSelected(active)
				ifs_freeform_SetButtonVis( this, "accept", this.selected )
				ifs_freeform_main:PlayVoice(string.format(ifs_battle_card_enter_sound, ifs_freeform_main.playerSide))
			else
				-- pick a card based on weight
				this.selected = nil
				local totalWeight = 2
				for i, item in ipairs(this.useActive) do
					totalWeight = totalWeight + item.weight
				end
				local randomWeight = math.random() * totalWeight
				print ("scaled weight:", totalWeight, randomWeight)
				for i, item in ipairs(this.useActive) do
					randomWeight = randomWeight - item.weight
					if randomWeight <= 0 then
						this:SetSelected(i)
						break
					end
				end
				
		 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
	 			this:AcceptBonus()
			end
		else
			-- auto-skip
			this:Next()
		end
		
		ifs_freeform_main:UpdatePlayerText(this.player)
		
		this:UpdateAction()
	end,

	Exit = function(this, bFwd)
	end,
	
	SetSelected = function(this, s)
		if this.selected ~= s then
 			ifelm_shellscreen_fnPlaySound(this.selectSound)
 			if this.selected then
				IFObj_fnSetAlpha(this.useActive[this.selected], 0.5)
			end
			this.selected = s
			if this.selected then
				IFObj_fnSetAlpha(this.useActive[this.selected], 1.0)
			end
			this:UpdateAction()
		end
	end,

	Next = function(this)
		if this.defending then
			-- switch to the attacker
			this.defending = nil
			ifs_freeform_main:SetActiveTeam(3 - ifs_freeform_main.playerTeam)
			
			-- restore split screen
			ScriptCB_SetSplitscreen(ifs_freeform_main.wasSplit)
			
			-- save state
			ifs_freeform_main:SaveState()

			-- save mission setup
			ifs_freeform_main:SaveMissionSetup()
			
			-- if in soak mode...
			if ifs_freeform_main.soakMode then
				-- enter the selected mission as a demo
				ScriptCB_LaunchDemo(ifs_freeform_main.launchMission)
			else
				-- enter the selected mission
				ScriptCB_EnterMission()
			end
		else
			-- switch to the defender
			this.defending = true
			ifs_freeform_main:SetActiveTeam(3 - ifs_freeform_main.playerTeam)
			
			-- re-enter as the defender
			ScriptCB_PushScreen("ifs_freeform_battle_card")
		end
	end,
	
	AcceptBonus = function(this)
		-- if there is a selected card...
		local item = this.useActive[this.selected]
		if item then
	 		
			-- activate the selected card
			ifs_freeform_main.activeBonus[ifs_freeform_main.playerTeam] = item.bonus
			ActivateBonus(ifs_freeform_main.playerTeam, "team_bonus_" .. item.bonus)
			ifs_freeform_main:PlayVoice(string.format(ifs_battle_card_play_us_sound, ifs_freeform_main.playerSide, item.bonus))
			
			-- expend the card
			ifs_purchase_tech_using[ifs_freeform_main.playerTeam][item.slot] = 0
			
			-- start a delay timer
			this.displayTimer = 3.0
		else
			-- start a short delay timer
			this.displayTimer = 0.5
		end
	end,
	
	HandleMouse = function(this, x, y)
		gIFShellScreenTemplate_fnHandleMouse(this, x, y)
		
		this.rollover = ifs_freeform_battle_card_GetMouseUseItem( this, x, y )
		if this.rollover and this.useItems[this.rollover].weight <= 0 then
			this.rollover = nil
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
		end
	end,
	
	
	Input_GeneralLeft = function(this, joystick)
		if not this.selected then
			return
		end
		if this.displayTimer then
			return
		end
		for s=this.selected-1,1,-1 do
			if this.useActive[s].weight > 0 then
				this:SetSelected(s)
				break
			end
		end
	end,
	
	Input_GeneralRight = function(this, joystick)
		if not this.selected then
			return
		end
		if this.displayTimer then
			return
		end
		for s=this.selected+1,table.getn(this.useActive),1 do
			if this.useActive[s].weight > 0 then
				this:SetSelected(s)
				break
			end
		end
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
				if this.rollover then
					this:SetSelected(this.rollover)
				end
				return
			end
		end
	
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		if not this.selected then
			return
		end
		
 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
 		
		if this.displayTimer then
			-- abort the delay
			this.displayTimer = 0.0
		else
	 		-- accept the selected bonus (if any)
			this:AcceptBonus()
		end
	end, -- Input_Accept

	Input_Back = function(this, joystick)
		-- can't go back
	end,

	Input_Misc = function(this, joystick)
		if(gPlatformStr ~= "PC") then
	 		ifelm_shellscreen_fnPlaySound(this.acceptSound)
	 		
			if this.displayTimer then
				-- abort the delay
				this.displayTimer = 0.0
			else
	 			-- no bonus selected
	 			this.selected = nil
				this:AcceptBonus()
			end
		end
	end,
	
	Input_Start = function(this, joystick)
		if this.displayTimer then
			return
		end
		-- open pause menu
		ScriptCB_PushScreen("ifs_freeform_menu")
	end,
	
	UpdateAction = function(this)
		local team = ifs_freeform_main.playerTeam
		local item = this.selected and this.useActive[this.selected]
		if item and item.using > 0 then
			IFObj_fnSetVis(this.info, true)
			IFObj_fnSetVis(this.info.caption, true)
			IFText_fnSetString(this.info.caption, string.format(ifs_purchase_tech_localize[true], item.name))
			IFObj_fnSetVis(this.info.text, true)
			IFText_fnSetString(this.info.text, string.format(ifs_purchase_tech_info_localize[true], item.name))
		else
			IFObj_fnSetVis(this.info, false)
			IFObj_fnSetVis(this.info.caption, false)
			IFObj_fnSetVis(this.info.text, false)
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
	local this = ifs_freeform_battle_card
	
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
	
	this.useItems = NewIFContainer {
		x = 0,
		y = 0,
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0,
		ZPos = 10,
	}

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

function ifs_freeform_battle_card_GetMouseUseItem( this, x, y )
	-- values measured from 800x600 screenshot
	local item_x = 341
	local item_y = 176
	local width =  120	
	local height = 132
	local offset_x = 130
	
	-- get item offset
	local count = table.getn(this.useActive)
	for i, item in pairs(this.useActive) do
		local new_item_x = item_x + (i - count * 0.5 - 0.5) * offset_x
		
		if( ( x >= ( new_item_x - width ) ) and ( x <= ( new_item_x + width ) ) and
			( y >= ( item_y - height ) ) and ( y <= ( item_y + height ) ) ) then
			return i
		end
	end
	
	-- mouse not on anyone
	return nil
end

ifs_freeform_AddCommonElements(ifs_freeform_battle_card)
AddIFScreen(ifs_freeform_battle_card,"ifs_freeform_battle_card")
