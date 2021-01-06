--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- General tab managing code for PC options interface screens.
-- Provides support code for all of the screens, and handles switching
-- between tabs (screens).

-- Tabs are implemented as a lightweight layer added to screens, with
-- elements added to all of them. Events in the tabs are handled by
-- this file, and when another tab is selected, it swaps screens in
-- the background.

function ifelem_tabmanager_DoCreateTabs( aLayout )
	local w,aw,h,ah
	w,h = ScriptCB_GetSafeScreenInfo()
	aw,ah = ScriptCB_GetScreenInfo()
	if( not aLayout ) then
		return nil
	end
	
	mTabs = NewIFContainer { --container for all the backgrounds
		ScreenRelativeX = 0.0,
		ScreenRelativeY = 0.0,
		ZPos = 60,
		UseSafezone = 0, 
	}

	local tabheight = 18
	if(ah ~= 600) then
		tabheight = tabheight * (ah / 600)
	end

	local i
	local NUM_TABS = table.getn(aLayout)
	local xWidth = 800 / NUM_TABS
	local deltaXPos = math.floor(xWidth) - 5
	
	local xPos = 10		--deltaXPos / 2 --(xWidth * 0.65) + 30
	local yPos = 15

-- Loadspam commented out NM 9/8/05. Re-enable locally if you need it
--	print( "w=", w, "aw=", aw, "NUM_TABS=", NUM_TABS, "xWidth=", xWidth, "xPos=", xPos )
	for i=1, NUM_TABS do
		local TagName = aLayout[i].tag
		local width = deltaXPos
		--xPos = deltaXPos + i * deltaXPos
 		if( aLayout[i].width ) then
			width = aLayout[i].width
		end 	
		
		if((aw ~= 800)) then
			local scaleX = (aw / 800)
			width = width * scaleX
		end
		
		xPos = xPos + (width/2) -- carryover from last time, if our xPos isn't set...
		
		local manualXPos = false
		if( aLayout[i].xPos ) then
			xPos = aLayout[i].xPos
			manualXPos = true
		end 		
		local manualYPos = false
 		if( aLayout[i].yPos ) then
			yPos = aLayout[i].yPos
			manualYPos = true
		end 	
		
		-- attempt at screen-relative everything - GAW, the things that people request...
		if((aw ~= 800) or (ah ~= 600)) then
			local scaleX = (aw / 800)
			local scaleY = (ah / 600)
			
			if(manualXPos) then
				xPos = xPos * scaleX
			end
			--if(manualYPos) then
			--	yPos = yPos * scaleY
			--end
		end
		
		local hotspotX = width / 2 - 4 -- yay for magic numbers!
		local hotspotY = 6 -- yay again!
 		if( aLayout[i].hotspot_x ) then
			hotspotX = aLayout[i].hotspot_x
		end 		
 		if( aLayout[i].hotspot_y ) then
			hotspotY = aLayout[i].hotspot_y
		end 		

		local hotspotW = width
		local hotspotH = tabheight
 		if( aLayout[i].hotspot_width ) then
			hotspotW = aLayout[i].hotspot_width
		end 		
 		if( aLayout[i].hotspot_height ) then
			hotspotH = aLayout[i].hotspot_height
		end

-- Loadspam commented out NM 9/8/05. Re-enable locally if you need it
--		print( "xPos", i, " = ", xPos, aLayout[i].tag )
		mTabs[TagName] = NewClickableIFButton {
			tag = TagName,
			font = aLayout.font or "gamefont_medium",
 			ZPos = 50,
 			x = xPos,
 			y = yPos,
			btnw = width,
			btnh = tabheight,
			string = aLayout[i].string,
			bg_width = width - 20,
			bStyleTabbed = 1,
			halign = "hcenter", 
			hotspot_x = hotspotX,
			hotspot_y = hotspotY,
			hotspot_width = width,
			hotspot_height = hotspotH,
			--bHidden = 1,
		}
		--mTabs[TagName].label.string = aLayout[i].string
		--mTabs[TagName].label.bgleft = "BF2_radiobutton_on"
		--mTabs[TagName].label.bgright = ""
		--mTabs[TagName].label.bgmid = "border_dropdown"
		--RoundIFButtonLabel_fnSetString(mTabs[TagName], aLayout[i].string)
--		IFObj_fnSetVis( mTabs[TagName], nil )
		xPos = xPos + (width/2)
	end
	
	return mTabs
end


-- Creates options tabs on the specified screen. This must be called
-- before AddIFScreen() is called. TODO: pass in layout, so this is
-- more general
function ifelem_tabmanager_Create(this, aLayout, aLayout1, aLayout2, aLayout3)
	this._Tabs = ifelem_tabmanager_DoCreateTabs( aLayout )
	if( aLayout1 ) then
		this._Tabs1 = ifelem_tabmanager_DoCreateTabs( aLayout1 )
	end
	if( aLayout2 ) then
		this._Tabs2 = ifelem_tabmanager_DoCreateTabs( aLayout2 )
	end
	if( aLayout3 ) then
		this._Tabs3 = ifelem_tabmanager_DoCreateTabs( aLayout3 )
	end
end


function ifelem_tabmanager_SelectTabGroup(this, bGroup, bGroup1, bGroup2, bGroup3 )
	IFObj_fnSetVis(this._Tabs, bGroup)
	if( this._Tabs1 ) then
		IFObj_fnSetVis(this._Tabs1, bGroup1)
	end
	if( this._Tabs2 ) then
		IFObj_fnSetVis(this._Tabs2, bGroup2)
	end
	if( this._Tabs3 ) then
		IFObj_fnSetVis(this._Tabs3, bGroup3)
	end
end


-- Sets the specified tab as selected. The rest of the tabs are
-- dimmed. The parameter in 'BrightTag' should be the tag parameter of
-- the selected one. TODO: pass in layout, so this is more general
function ifelem_tabmanager_SetSelected(this, aLayout, BrightTag, useTab2 )
	local i
	local NUM_TABS = table.getn(aLayout)
	
	local Tabs = this._Tabs
		
	if( useTab2 == 1 ) then
		Tabs = this._Tabs1
	elseif( useTab2 == 2 ) then
		Tabs = this._Tabs2
	elseif( useTab2 == 3 ) then
		Tabs = this._Tabs3
	end

	for i=1, NUM_TABS do
		local TagName = aLayout[i].tag
		local Alpha = 1 --0.6 -- no longer do we change the alpha of the tabs at all, ever
		local color_r = 150 --200
		local color_g = 150 --200
		local color_b = 150 --200
		
		-- please note that since the "highlighted" textures are darker, these are backwards -
		-- you use "highlighted" if you are unselected, and normal otherwise
		local texRight = "headerbuttonright_highlighted"
		local texMid = "headerbuttonmid_highlighted"
		local texLeft = "headerbuttonleft_highlighted"
		
		if(TagName == BrightTag) then
			--Alpha = 1
			color_r = 230
			color_g = 230
			color_b = 230
			texRight = "headerbuttonright"
			texMid = "headerbuttonmid"
			texLeft = "headerbuttonleft"
		end

		ScriptCB_IFFlashyText_SetBackground(Tabs[TagName].label.cp, texLeft, texMid, texRight)

		IFObj_fnSetAlpha(Tabs[TagName],Alpha)
		IFObj_fnSetAlpha(Tabs[TagName].label,Alpha)
		
		--IFObj_fnSetColor(Tabs[TagName], color_r, color_g, color_b)
		-- no longer do we change the color of the text at all, ever
		IFObj_fnSetColor(Tabs[TagName].label, color_r, color_g, color_b)
		
		Tabs[TagName].bSelected = (TagName == BrightTag)
		
		-- prevent the button from ending up falsely selected since we switched screens
		IFButton_fnSelect(Tabs[TagName], false, false)
	end
end


-- To be called from a screen's Input_Accept. If the user has
-- clicked on a tab, it handles the switching to that screen.
--
-- Note: returns true(1) if the user did click on a tab, nil
-- otherwise. This allows the calling screen to exit immediately from
-- their Input_Accept handler.
--
-- Also, if bDelayedSwitch is true, then this code doesn't force a
-- switch, but instead, returns the name of the screen to switch
-- to. This is non-nil, allowing screens to do their own processing.
-- This is so the options screens can force a save before going to the
-- next screen.
--
function ifelem_tabmanager_HandleInputAccept(this, aLayout, useTab, bDelayedSwitch)
	local bHit = nil
	local i
	local NUM_TABS = table.getn(aLayout)

	local Tabs = this._Tabs
	if(useTab == 1) then
		Tabs = this._Tabs1
	elseif(useTab == 2) then
		Tabs = this._Tabs2
	elseif(useTab == 3) then
		Tabs = this._Tabs3
	end

--	print("CurButton = ", gCurScreenTable.CurButton)

	for i=1, NUM_TABS do
		local TagName = aLayout[i].tag
		if(TagName == gCurScreenTable.CurButton) then
			if(not Tabs[TagName].bSelected) then
				-- callback is used when you just need to do something, without going to
				-- another screen at the end
				if(aLayout[i].callback) then
					aLayout[i].callback(this, aLayout[i].screen)
					return -1 -- callback handled this
				else
					-- callback2 is used when you just need to do something before going
					-- to that screen
					if(aLayout[i].callback2) then
						aLayout[i].callback2(this, aLayout[i].screen)
					end

					ifelm_shellscreen_fnPlaySound(this.acceptSound)
					if(bDelayedSwitch) then
						return aLayout[i].screen
					else
						ScriptCB_SetIFScreen(aLayout[i].screen)
					end
				end
			end -- Current tab matched, isn't currently selected
			return aLayout[i].screen
		end -- tab 
	end -- loop over tabs

	return nil -- didn't hit any tab buttons.
end

-- Sets the specified tab as unactived
function ifelem_tabmanager_SetDimmed(this, aLayout, DimmedTag, DimmedFlag, useTab )
	local i
	local NUM_TABS = table.getn(aLayout)
	
	local Tabs = this._Tabs
	if(useTab == 1) then
		Tabs = this._Tabs1
	elseif(useTab == 2) then
		Tabs = this._Tabs2
	elseif(useTab == 3) then
		Tabs = this._Tabs3
	end

	for i=1, NUM_TABS do
		local TagName = aLayout[i].tag
		if(TagName == DimmedTag) then
			Tabs[TagName].bDimmed = DimmedFlag
			local Alpha = 1
			if( DimmedFlag == 1 ) then
				Alpha = 0.2
			end
			IFObj_fnSetAlpha(Tabs[TagName],Alpha)			
			IFObj_fnSetAlpha(Tabs[TagName].label,Alpha)			
		end		
	end
end

-- Sets the specified tab as unactived
function ifelem_tabmanager_SetVisable(this, aLayout, VisTag, VisFlag, useTab )
	local i
	local NUM_TABS = table.getn(aLayout)
	
	local Tabs = this._Tabs
	if(useTab == 1) then
		Tabs = this._Tabs1
	elseif(useTab == 2) then
		Tabs = this._Tabs2
	elseif(useTab == 3) then
		Tabs = this._Tabs3
	end

	for i=1, NUM_TABS do
		local TagName = aLayout[i].tag
		if(TagName == VisTag) then
			IFObj_fnSetVis(Tabs[TagName],VisFlag)
		end		
	end
end

-- Sets the specified tab as unactived
function ifelem_tabmanager_SetPos(this, aLayout, Tag, useTab, x, y )
	local i
	local NUM_TABS = table.getn(aLayout)
	
	local Tabs = this._Tabs
	if(useTab == 1) then
		Tabs = this._Tabs1
	elseif(useTab == 2) then
		Tabs = this._Tabs2
	elseif(useTab == 3) then
		Tabs = this._Tabs3
	end

	for i=1, NUM_TABS do
		local TagName = aLayout[i].tag
		if(TagName == Tag) then
			local x_pos = x or Tabs[TagName].x
			local y_pos = y or Tabs[TagName].y			
			IFObj_fnSetPos( Tabs[TagName], x_pos, y_pos )
		end		
	end
end

local MAX_RADIO_BUTTON_GROUPS = 50

---- radio button stuff	below, mostly copied from above	:^)	----

local RadioButtonTextureOn = "BF2_radiobutton_on"
local RadioButtonTextureOff = "BF2_radiobutton_off"

-- are we mouseover any of them?
function ifelem_GetRadioButtonMouseOverTag(this)

	if(this.radiobuttons ==	nil) then --well obviously we didn't hit one
		return nil
	end
			
	for	row=1, MAX_RADIO_BUTTON_GROUPS do
		if((this.radiobuttons[row] ~= nil) and (this.radiobuttons[row].bInitialized ~= nil)) then -- it exists
			local tag = ifelem_CheckRadioButtonRowMouseOver(this.radiobuttons[row])
			if(tag) then
				return tag
			end
		end
	end
	
	for key, group in pairs(this.radiobuttons) do
		if ( type(group) == "table" ) then
			if(group.bInitialized == true) then
				local tag = ifelem_CheckRadioButtonRowMouseOver(group)
				if(tag) then
					return tag, group
				end
			end
		end
	end

	return nil -- didn't hit any radio buttons
end

function ifelem_CheckRadioButtonRowMouseOver(this)
	if((not gCurScreenTable) or (not gCurScreenTable.CurButton)) then
		return nil
	end
	
	local NUM_TABS = table.getn(this)

	for	i=1, NUM_TABS do
		local TagName = this[i].radiobutton.tag
		if(TagName == gCurScreenTable.CurButton) then
			return TagName
		end
	end
	return nil
end


-- calls callbacks associated with radio buttons
function ifelem_HandleRadioButtonInputAccept(this)

	if(this.radiobuttons ==	nil) then --well obviously we didn't hit one
		return nil
	end
			
	for	row=1, MAX_RADIO_BUTTON_GROUPS do
		if((this.radiobuttons[row] ~= nil) and (this.radiobuttons[row].bInitialized ~= nil)) then -- it exists
			if(ifelem_CheckRadioButtonRowInputAccept(this.radiobuttons[row])) then
				ifelm_shellscreen_fnPlaySound(this.acceptSound)
				return -1  -- handled
			end
		end
	end
	
	for key, group in pairs(this.radiobuttons) do
		if ( type(group) == "table" ) then
			if(group.bInitialized == true) then
				if(ifelem_CheckRadioButtonRowInputAccept(group)) then
					ifelm_shellscreen_fnPlaySound(this.acceptSound)
					return -1  -- handled
				end
			end
		end
	end

	return nil -- didn't hit any radio buttons
end

function ifelem_CheckRadioButtonRowInputAccept(this)
	if((not gCurScreenTable) or (not gCurScreenTable.CurButton)) then
		return nil
	end
	
	local NUM_TABS = table.getn(this)

	for	i=1, NUM_TABS do
		local TagName = this[i].radiobutton.tag
		if(TagName == gCurScreenTable.CurButton) then
			ifelem_SelectRadioButton(this, i)
			return true
		end
	end
	return nil
end

-- gives back the number of the button that is selected, or 0 if none
function ifelem_GetSelectedRadioButton(this)
	-- quick search (TM)
	local NUM_TABS = table.getn(this)

	for	i=1, NUM_TABS do
		local btn = this[i].radiobutton
		if(btn.bSelected) then
			return i
		end		
	end
	return 0
end

-- callback may return non-nil to indicate that we really should select a different button!
function ifelem_SelectRadioButton(this, btnNum, bSkipCallback)
	-- if already selected, do nothing
	if(this[btnNum].radiobutton.bSelected) then
		return
	end 
	
	-- it's time to do work

	local selectThisOne = btnNum

	-- the callback
	if((bSkipCallback == nil) and (this.callback)) then
		local retVal = this.callback(this, btnNum)
		if(retVal ~= nil) then -- the callback can return a button to be selected
			selectThisOne = retVal
		end
	end

	
	-- now change the art
	local NUM_TABS = table.getn(this)

	for	i=1, NUM_TABS do
		local btn = this[i].radiobutton
		
		if(i == selectThisOne) then
			btn.bSelected = true
			IFImage_fnSetTexture(btn,RadioButtonTextureOn)
		else
			btn.bSelected = nil
			IFImage_fnSetTexture(btn,RadioButtonTextureOff)
		end
	end
end

-- doesn't really have to be globally unique, but doesn't hurt anything
local uniqueRadioButtonTagID = 1

function ifelem_CreateRadioButtonGroup(	aLayout, screenX, screenY )
			local w,aw,h,ah
			w,h	= ScriptCB_GetSafeScreenInfo()
			aw,ah =	ScriptCB_GetScreenInfo()
			if(	(not aLayout) or (not aLayout.strings)) then
				return nil
			end
			
			local myFont = aLayout.font or "gamefont_tiny"
			local spacing = aLayout.spacing or 150
			
			mTabs =	NewIFContainer { --container for all the buttons
						x =	screenX	or 0,
						y =	screenY	or 0,
						--ScreenRelativeX	= 0.0,
						--ScreenRelativeY	= 0.0,
						ZPos = 0,
						--UseSafezone	= 0, 
			}

			local i
			local NUM_TABS = table.getn(aLayout.strings) 

			--print( "w=", w, "aw=", aw, "NUM_TABS=", NUM_TABS,	"xWidth=", xWidth, "xPos=",	xPos )
			local xPos = 0
			for	i=1, NUM_TABS do
				
				local useTexture = RadioButtonTextureOn
				local selected = true
				
				if(i > 1) then
					useTexture = RadioButtonTextureOff
					selected = nil		
				end
				
				local myTag = "radio"..uniqueRadioButtonTagID
				uniqueRadioButtonTagID = uniqueRadioButtonTagID + 1
								
				local buttonSize = 14
				
				mTabs[i] = { --NewIFContainer {	--container	for	all	the	buttons
						
				radiobutton	= NewIFImage {
						ZPos = 0, 
						x =	xPos, y = 0,
						texture	= useTexture,
						localpos_l = 0, localpos_t = -buttonSize*0.5,
						localpos_r = buttonSize, localpos_b	= buttonSize*0.5,
						AutoHotspot	= 1, tag = myTag,
						bIsFlashObj	= 1, flash_alpha = 1.0,
						bSelected = selected
					},
				radiotext =	NewIFText {	
						x =	xPos + buttonSize + 5,
						y =	-buttonSize + 2,
						halign = "left", valign	= "vcenter",
						font = myFont, 
						textw =	spacing - buttonSize - 5, 
						nocreatebackground=1,	
						string = aLayout.strings[i],
						--tag	= "text",
					},
				}
				xPos = xPos + spacing + buttonSize + 5
			end

			mTabs.callback = aLayout.callback
			mTabs.bInitialized = true
			return mTabs
end

-- Creates a new group of radio	buttons	on the specified screen
-- returns the group which can be passed to other radio button functions
function ifelem_AddRadioButtonGroup(this, screenX, screenY,	aLayout, title)

	if(not aLayout) then
		return nil
	end

	if(this.radiobuttons ==	nil) then -- set them up
		this.radiobuttons =	NewIFContainer
		{
			--ScreenRelativeX	= 0.0,
			--ScreenRelativeY	= 0.0,
			--ZPos = 0,
			--UseSafezone	= 0, 
		}
		for	num=1, MAX_RADIO_BUTTON_GROUPS do
			this.radiobuttons[num] = {} -- just so it actually exists or	else Lua complains below when we index it
		end
	end
	
	if ( title ) then
		if(not this.radiobuttons[title] or this.radiobuttons[title].bInitialized == nil) then
			this.radiobuttons[title] = ifelem_CreateRadioButtonGroup(aLayout, screenX, screenY)
			return this.radiobuttons[title]
		end
	else
		for	i=1, MAX_RADIO_BUTTON_GROUPS do
			if(this.radiobuttons[i].bInitialized == nil) then
				this.radiobuttons[i] = ifelem_CreateRadioButtonGroup(aLayout, screenX, screenY)
				return this.radiobuttons[i]
			end
		end
	end
	
	-- should never get here
	return nil
end
