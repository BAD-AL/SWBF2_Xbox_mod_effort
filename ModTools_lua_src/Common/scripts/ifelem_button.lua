--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Code, data for a generic InterFace Button (IFButton).
--
-- This is fairly basic, will be extended by other classes
-- (e.g. RoundIFButton)
--
-- Broken off from interface_util.lua for better encapsulation

-- Override for setsize -- does so for self, calls it on kids (if present)
function IFButton_fnSetSize(this,w,h)
	this.width = w
	this.height = h
	
	if(this.label) then
		RoundIFButtonLabel_fnSetSize(this.label,w,h)
	end
	if(this.skin) then
		RoundIFButtonSkin_fnSetSize(this.skin,w,h)
	end
end -- function gIFButtonTemplate_fnSetSize

-- Override for setsize -- does so for self, calls it on kids (if present)
function IFButton_fnSelect(this,on,labelonly)
	local NewTexture

	if(on) then
		NewTexture = "btn_on_pieces"
	else
		NewTexture = "btn_off_pieces"
	end

	if((this.skin) and (not labelonly)) then
		RoundIFButtonSkin_fnSelect(this.skin,NewTexture,NewSkinAlpha)

		-- Always resize to last expected size (in case we made it bigger while selected)
		if(not on) then
			RoundIFButtonSkin_fnSetSize(this.skin,this.width,this.height)
		end
	end
	if(this.label) then
		RoundIFButtonLabel_fnSelect(this.label, on)
	end
end -- function gIFButtonTemplate_fnSelect

-- fnHilight for a IFButton -- updates its hilighted state based
-- on dt . 
function IFButton_fnHilight(this,on,dt)
	dt = dt or 0.03333333 -- default: 30fps if not specified

	-- Get width, height to pass to kids
	local w = this.width
	local h = this.height

	-- Pass to kids by default, if they (and those functions) exist
--	if((this.label) and (this.label.fnHilight)) then
--		this.label:fnHilight(on,dt,w,h)
--	end
	if(this.skin) then
		RoundIFButtonSkin_fnHilight(this.skin,on,dt,w,h)
	end

	if(this.label) then
		RoundIFButtonLabel_fnHilight(this.label,on,dt,w,h)
	end

end

-- Given a container, current button (string), and a direction string
-- to follow ("link_up" | "link_down" | "link_left" | "link_right),
-- tries to find the next button. If that's set, it deactivates the
-- old one, activates the new. Returns the string index of the new
-- button, or CurrentStr if links were invalid (or unavailable)
function FollowButtonLink(container,CurrentStr,DirStr)
	local EntrySelectedTable = nil
	local NewBtnStr = nil
	
	if(not CurrentStr) then
		NewBtnStr = container.TagOfFirst
		EntrySelectedTable  = container[container.TagOfFirst]
	else
		EntrySelectedTable  = container[CurrentStr]
		-- Button selected on entry
		
		-- Last button in the chain, used to skip thru hidden buttons
		local LastBtnTable = EntrySelectedTable
		local bKeepGoing

		repeat
			bKeepGoing = nil
			NewBtnStr = LastBtnTable[DirStr]
			if(NewBtnStr) then
				bKeepGoing = (NewBtnStr ~= CurrentStr) and 
					(container[NewBtnStr].hidden or container[NewBtnStr].bDimmed or (not IFObj_fnGetVis(container[NewBtnStr])))

				if(bKeepGoing) then
					LastBtnTable = container[NewBtnStr]
				end
	
			end
		until (not bKeepGoing)
	end

	if(NewBtnStr) then
		ScriptCB_SndPlaySound("shell_select_change")
		IFButton_fnSelect(EntrySelectedTable,nil) -- Deactivate old button
		IFButton_fnSelect(container[NewBtnStr],1) -- show new one.
		return NewBtnStr
	else
		return CurrentStr -- Go nowhere if link doesn't work.
	end
end

-- Utility function for Josh to call from C. The 'this' param is
-- optional, and if omitted, gCurScreenTable is assumed. If it is
-- present, this.Viewport must be set (0..MAX_CAMERA)
function SetCurButton(NameStr, this)
	this = this or gCurScreenTable

	--print("SetCurButton(",NameStr)
	iInstance = iInstance or 1
	-- But, if a popup is open, then it gets all bouncy stuff.
	if(gCurPopup) then
		iInstance = 1
	end

	local CurButtonTable
	if (this.Viewport == 3) then
		CurButtonTable = gCurHiliteButton4
	elseif (this.Viewport == 2) then
		CurButtonTable = gCurHiliteButton3
	elseif (this.Viewport == 1) then
		CurButtonTable = gCurHiliteButton2
	else
		CurButtonTable = gCurHiliteButton
	end

	if(CurButtonTable) then
		IFButton_fnSelect(CurButtonTable,nil) -- Deactivate old button
	end

	if(gCurPopup) then
		gCurPopup.CurButton = NameStr
		if((NameStr) and (gCurPopup.buttons)) then
			CurButtonTable = gCurPopup.buttons[NameStr]
		else
			CurButtonTable = nil
		end
--		assert(gCurPopup.CurButton)
	else
		this.CurButton = NameStr
		if((NameStr) and (this.buttons)) then
			CurButtonTable = this.buttons[NameStr]
		else
			CurButtonTable = nil
		--assert(gCurScreenTable.CurButton)
		end
	end

	if(CurButtonTable) then
		IFButton_fnSelect(CurButtonTable,1) -- show new one.
	end

	-- Possibly unnecessary, but make sure that these changes are stored
	-- in our globals
	if (this.Viewport == 3) then
		gCurHiliteButton4 = CurButtonTable
	elseif (this.Viewport == 2) then
		gCurHiliteButton3 = CurButtonTable
	elseif (this.Viewport == 1) then
		gCurHiliteButton2 = CurButtonTable
	else
		gCurHiliteButton = CurButtonTable
	end
end

-- Utility function for Josh to call from C.
function SetCurButtonTable(this)
	if(gCurHiliteButton) then
		IFButton_fnSelect(gCurHiliteButton,nil) -- Deactivate old button
	end

	if(this.tag) then
		if(gCurPopup) then
			gCurPopup.CurButton = this.tag
			assert(gCurPopup.CurButton)
		else
			gCurScreenTable.CurButton = this.tag
			assert(gCurScreenTable.CurButton)
		end
		--print("SetCurButtonTable(",this.tag)

	end
	gCurHiliteButton = this

	if(gCurHiliteButton) then
		IFButton_fnSelect(gCurHiliteButton,1) -- show new one.
	end
end

-- Current hilighted button. Used to bounce it. May be nil.
gCurHiliteButton = nill

-- -------------------------------------------------------------------
-- Utility functions


-- Adds a set of vertical buttons to the destination container,
-- 'dest'.  The layout is specified in the table 'layout', with the
-- actual buttons in 'layout.buttonlist'. Defaults are provided for
-- the layout table if not specified. Sets current button to first.
--
-- Members of layout may include:
--   yTop (float) : y-position of top element (auto-centered if omitted)
--   yHeight (float) : vertical height of each button
--   ySpace (float) : vertical spacing between elements
--   width (float) : width of each button
--   font (float) : font to be used each button
--   [to be added]
--   bLeftJustifyButtons : flag to move buttons to left side of screen in ShowHide. Container must be horizontally centered (ScreenRelativeX = 0.5)
function AddVerticalButtons(dest,layout)
	-- Fill in defaults for the layout table if needed
	local Font = layout.font or "gamefont_small"
	-- set layout yHeight if not specified
	layout.yHeight = layout.yHeight or ScriptCB_GetFontHeight(Font)
--	print("AddVertical, yHeight = ", layout.yHeight, " from ", Font)
	local yHeight = layout.yHeight
	local ySpacing = 0 -- layout.ySpacing or 0
	
	if(layout.UseYSpacing) then
		ySpacing = layout.ySpacing or 0
		layout.UseYSpacing = nil
	else
		layout.ySpacing = 0
	end

	if(not layout.HardWidthMax) then
		local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
		layout.HardWidthMax = w - 16
	end

	if(layout.bNoDefaultSizing) then
--		layout.bNoDefaultSizing = nil
	else
		layout.yHeight = ScriptCB_GetFontHeight(Font) + gButtonHeightPad
		yHeight = layout.yHeight
		ySpacing = gButtonGutter
	end
	layout.ySpacing = ySpacing	

	local width = layout.width or 100
	local bFlatButton = layout.FlatButtons
	local xStart = layout.xStart or 0

	local i
	local Count = table.getn(layout.buttonlist)
	local yTop = layout.yTop or ((Count * (yHeight + ySpacing)) * -0.5)

	-- Quick first pass: make sure tagnames are set for all of the items, fill in
	-- defaults if not. (Needed for linking)
	-- also calculate the max width of all buttons for the background
	local bgwidth = 0
	for i = 1,Count do
		layout.buttonlist[i].tag = layout.buttonlist[i].tag or string.format("vbutton%d",i)
		local w = layout.buttonlist[i].width or width
		bgwidth = math.max(bgwidth,w)
	end
	layout.maxbgwidth = bgwidth
	
	-- is there a title bar?
	if(layout.title) then	
		dest["_titlebar_"] = NewIFText { 
			y = yTop, 
			font = Font, 
			textw = width, texth = yHeight, 
			halign = "hcenter",
			valign = "top",
			string = layout.title,

			bgleft = "bf2_buttons_topleft",
			bgmid = "bf2_buttons_title_center",
			bgright = "bf2_buttons_topright",
			bg_width = width, 
			flashy = layout.flashy,
			startdelay = 0.0,
			bgoffsetx = 0,
			bgexpandx = 0,
			bgexpandy = gButtonHeightPad * 0.5, -- exe doubles this, grr
			ColorR = 255,
			ColorG = 255,
			ColorB = 255,
			textcolorr = gTitleTextColor[1],
			textcolorg = gTitleTextColor[2],
			textcolorb = gTitleTextColor[3],
			alpha = gTitleTextAlpha,
			bInertPos = 1,
		}
		if(layout.bNoDefaultSizing) then
			dest["_titlebar_"].bgexpandy = 0
		end


		dest["_titlebar_"].x = 0

		yTop = yTop + (yHeight + ySpacing) * 1.4	-- move on as an entry
	end

	-- Now do the real work
	for i = 1,Count do
		if(layout.buttonlist[i]) then
			local label = layout.buttonlist[i].tag

			local bTopItem = (i == 1)
			local bLastItem = (i == Count)
			local UseFont = Font
			if(layout.buttonlist[i].font) then
				UseFont = layout.buttonlist[i].font
				layout.buttonlist[i].yHeight = ScriptCB_GetFontHeight(UseFont)
			end

			dest[label] = NewRoundIFButton { 
				x = 0, -- button will move things
				y = yTop, 
				btnw = width, 
				btnh = yHeight,
				font = UseFont, 
				bg_flipped = nil, -- bLastItem,
				startdelay = i*flashySpeed, 
				bg_width = width, 
				flashy = layout.flashy,
				nocreatebackground = layout.nocreatebackground,
				rightjustifybackground = layout.RightJustify,
				bRightJustify = layout.bRightJustifyButton,
				--bInertPos = 1,
			}

			if(layout.LeftJustify) then
				dest[label].label.halign = "left"
				dest[label].label.x = 0
			else
				dest[label].label.x = 0
			end
			
			if(layout.buttonlist[i].noCreateHotspot) then
				dest[label].label.bHotspot = nil
			else
				dest[label].label.bHotspot = 1
				dest[label].label.fHotspotW = width + 16
				dest[label].label.fHotspotH = yHeight
			end
			
			dest[label].label.bgexpandx = 0
			if(not layout.bNoDefaultSizing) then
				dest[label].label.bgexpandy = gButtonHeightPad * 0.5 -- exe doubles this, grr
			end


			if(bTopItem) then
				dest[label].label.bgleft = "bf2_buttons_upleft"
				dest[label].label.bgmid = "bf2_buttons_items_center"
				dest[label].label.bgright = "bf2_buttons_upright"
			elseif(bLastItem) then
				dest[label].label.bgleft = "bf2_buttons_botleft"
				dest[label].label.bgmid = "bf2_buttons_items_center"
				dest[label].label.bgright = "bf2_buttons_botright"
			else
				dest[label].label.bgleft = "bf2_buttons_midleft"
				dest[label].label.bgmid = "bf2_buttons_items_center"
				dest[label].label.bgright = "bf2_buttons_midright"
			end

			dest[label].font = nil
			RoundIFButtonLabel_fnSetString(dest[label],layout.buttonlist[i].string)
			dest[label].tag = layout.buttonlist[i].tag

			-- Activate the top button, nothing else.
			IFButton_fnSelect(dest[label],i == 1)

			-- Set up relative links for up/down. Turned to full links later.
			if(i > 1) then
				dest[label].link_up = layout.buttonlist[i - 1].tag
			else
				dest[label].link_up = layout.buttonlist[Count].tag
			end
			if(i < Count) then
				dest[label].link_down = layout.buttonlist[i + 1].tag
			else
				dest[label].link_down = layout.buttonlist[1].tag
			end

			if(layout.buttonlist[i].hidden) then
				IFObj_fnSetVis(dest[label],nil)
			else
				yTop = yTop + yHeight + ySpacing
			end
		end
	end

	-- center the entire thing
	if(not layout.LeftJustify) then
		if(layout.bRightJustifyButton) then
			dest.x = -width
		else
			dest.x = width * -0.5
		end
	end

	if(layout.bLeftJustifyButtons) then
		dest.ScreenRelativeX = 0 -- left side of screen
		dest.x = 0
	end

	-- Returns the name of the first button, so caller can archive it
	-- (or toss it away, no big deal)
	dest.TagOfFirst = layout.buttonlist[1].tag
	return layout.buttonlist[1].tag
end

-- Utility function - based on the .hidden flag in buttons (already
-- created), shows/hides buttons. Adjusts spacing too. Returns tag of
-- first selectable button.
function ShowHideVerticalButtons(dest,layout, hideall)
	local yHeight = layout.yHeight or 40
	local ySpacing = 0 -- layout.ySpacing or 10
	local width = layout.width or 100

	ySpacing = layout.ySpacing or 0

--	print("Top of ShowHide, Height, Spacing = ", yHeight, ySpacing)

	local i,VisCount
	local Count = table.getn(layout.buttonlist)

	if(hideall) then 
		for i = 1,Count do
			local label = layout.buttonlist[i].tag
			if(hideall == 1) then
--				print("Hiding all")
				dest[label].hidden = 1
			else
--				print("UnHiding All")
				dest[label].hidden = nil
			end
		end
	end
	
	-- Calculate max item width so that we can auto-size the buttons
	local MaxItemWidth = 0
	local kBUTTON_WIDTH_PAD = gButtonWidthPad -- how much space we add for button borders

	VisCount = 0
	for i = 1,Count do
		local label = layout.buttonlist[i].tag
		if(not dest[label].hidden) then
			VisCount = VisCount + 1
			local fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(dest[label].label)
			local TextW = fRight - fLeft + kBUTTON_WIDTH_PAD
			MaxItemWidth = math.max(MaxItemWidth, TextW)
		end
	end
	local yTop
	if(layout.title) then	
		yTop = layout.yTop or (((VisCount + 1) * (yHeight + ySpacing)) * -0.5)
	else
		yTop = layout.yTop or ((VisCount * (yHeight + ySpacing)) * -0.5)
	end
	local xPos = 0
	local bgwidth = layout.maxbgwidth
--	print("In ShowHide, bgwidth =", bgwidth)

	-- is there a title bar?
	if(layout.title) then	
		local fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(dest["_titlebar_"])
		local TextW = fRight - fLeft + kBUTTON_WIDTH_PAD
		MaxItemWidth = math.max(MaxItemWidth, TextW)

		yTop = yTop - (yHeight * 0.5)

		IFObj_fnSetPos(dest["_titlebar_"], 0, yTop)
		yTop = yTop + 15 + yHeight -- (3 * ySpacing - 1) --* 0.4	-- move on as an entry [sorry for magic constant :( ]

		if(layout.HardWidthMax) then
			MaxItemWidth = math.min(MaxItemWidth, layout.HardWidthMax)
		end

		if( not (layout.flashy==0) ) then
			IFFlashyText_fnSetup(dest["_titlebar_"], 0, nil, MaxItemWidth, nil,0)
		end
	end

	if(layout.HardWidthMax) then
		MaxItemWidth = math.min(MaxItemWidth, layout.HardWidthMax)
	end

	-- Do the work of tweaking the items
	local TagOfFirst = nil
	local cnt = 1
	for i = 1,Count do
		local label = layout.buttonlist[i].tag
		if(dest[label].hidden) then
			IFObj_fnSetVis(dest[label], nil)
		else
			-- not hidden. Show it
			local bIsTopItem, bIsBotItem
			bIsTopItem = (cnt == 1) and (not layout.title) and (VisCount > 1) and (not layout.bAllSquareButtons)
			bIsBotItem = (cnt == VisCount) and ((VisCount > 1) or ((VisCount == 1) and layout.title)) and (not layout.bAllSquareButtons)

			-- Fill in items differentl if they're in top, mid, or bottom of list
			if(not (layout.flashy==0)) then
				-- resize the flashy text element
				IFFlashyText_fnSetup(dest[label].label, cnt*0.1, nil, MaxItemWidth, nil, 0)
				if (bIsTopItem) then
					ScriptCB_IFFlashyText_SetBackground(dest[label].label.cp,"bf2_buttons_upleft", "bf2_buttons_items_center", "bf2_buttons_upright")
				elseif (bIsBotItem) then
					ScriptCB_IFFlashyText_SetBackground(dest[label].label.cp,"bf2_buttons_botleft", "bf2_buttons_items_center", "bf2_buttons_botright")
				else
					ScriptCB_IFFlashyText_SetBackground(dest[label].label.cp,"bf2_buttons_midleft", "bf2_buttons_items_center", "bf2_buttons_midright")
				end
			end

			local UseHeight = layout.buttonlist[i].yHeight or yHeight
			if(layout.buttonlist[i].yAdd) then
				yTop = yTop + layout.buttonlist[i].yAdd
			end
			IFObj_fnSetVis(dest[label], 1)
--			print("ShowHide, setPos to ", xPos, yTop)
--			print("ShowHide, useHeight , ySpacing = ", UseHeight, ySpacing)
			IFObj_fnSetPos(dest[label], xPos, yTop)
			-- Move on AFTER calc'ing position. Doing this before will kill forms w/ sliders
			yTop = yTop + UseHeight + ySpacing

			cnt = cnt + 1

			-- If this item is to be shown dimmed, then do so.
			local fBGColor = 255
			if(dest[label].bDimmed) then
				fBGColor = 110
			else
				TagOfFirst = TagOfFirst or label -- Keep track of the first non-dimmed item
			end
			if((not layout.flashy) or (layout.flashy > 0)) then
				IFFlashyText_fnSetTextColor(dest[label].label, fBGColor, fBGColor, fBGColor)
			end
			
		end -- showing this one
	end

	if(layout.bLeftJustifyButtons) then
		local w,h = ScriptCB_GetSafeScreenInfo()
		XPos = (bgwidth - MaxItemWidth) * -0.5 + 20 -- (MaxItemWidth * 0.5)
		IFObj_fnSetPos(dest, XPos, 0)
	end

	return TagOfFirst, MaxItemWidth
end

-- Same as AddVerticalButtons, but a horizontal arrangement
function AddHorizontalButtons(dest,layout)
	-- Fill in defaults for the layout table if needed
	local xWidth = layout.xWidth or 40
	local xSpacing = layout.xSpacing or 10
	local height = layout.height or 40
	local Font = layout.font or "gamefont_small"
	local yTop = layout.yTop or 0
	local xLeft
	local i
	local zPos = layout.ZPos or 200
	local Count = table.getn(layout.buttonlist)

	if(layout.xLeft) then
		xLeft = layout.xLeft
	else
		xLeft = ((Count - 1) * (xWidth + xSpacing)) * -0.5
	end

	-- Quick first pass: make sure tagnames are set for all of the items, fill in
	-- defaults if not. (Needed for linking)
	for i = 1,Count do
		layout.buttonlist[i].tag = layout.buttonlist[i].tag or string.format("hbutton%d",i)
	end

	local bgLeft = nil
	local bgMid = nil
	local bgRight = nil
	if( layout.allTitles ) then
		if( layout.itemStyle ) then
			bgLeft = "bf2_buttons_midleft"
			bgMid = "bf2_buttons_items_center"
			bgRight = "bf2_buttons_midright"
		else
			bgLeft = "headerbuttonleft"
			bgMid= "headerbuttonmid"
			bgRight = "headerbuttonright"
		end
	end
	-- Now do the real work
	for i = 1,Count do
		local label = layout.buttonlist[i].tag
		
		dest[label] = NewRoundIFButton 
		{
			x = xLeft,
			y = yTop,
			btnw = xWidth,
			bg_width = xWidth - 10,
			btnh = height,
			font = Font,
			nocreatebackground = layout.nocreatebackground, 
			ZPos = zPos,  
		} --bInertPos = 1,}
		
		dest[label].label.bgleft = bgLeft
		dest[label].label.bgmid = bgMid
		dest[label].label.bgright = bgRight

		dest[label].label.bHotspot = 1
		dest[label].label.fHotspotW = dest[label].btnw
		dest[label].label.fHotspotH = dest[label].btnh
		--dest[label].label.fHotspotX = dest[label].x
		--dest[label].label.fHotspotY = dest[label].y
		if(not layout.allTitles ) then
			dest[label].label.flashy = nil
			dest[label].Flashy = nil
		end

		dest[label].font = nil
		RoundIFButtonLabel_fnSetString(dest[label],layout.buttonlist[i].string)
		dest[label].tag = layout.buttonlist[i].tag

		-- Activate the top button, nothing else.
		IFButton_fnSelect(dest[label],i == 1)

		-- Set up relative links for left/right. Turned to full links later.
		if(i > 1) then
			dest[label].link_left = layout.buttonlist[i - 1].tag
		else
			dest[label].link_left = layout.buttonlist[Count].tag
		end
		if(i < Count) then
			dest[label].link_right = layout.buttonlist[i + 1].tag
		else
			dest[label].link_right = layout.buttonlist[1].tag
		end

		xLeft = xLeft + xWidth + xSpacing
	end

	-- Returns the first button, so caller can archive it (or toss it
	-- away, no big deal)
	dest.TagOfFirst = layout.buttonlist[1].tag
	return layout.buttonlist[1].tag
end

-- Utility function - based on the .hidden flag in buttons (already
-- created), shows/hides buttons. Adjusts spacing too. Returns tag of
-- first selectable button.
function ShowHideHorizontalButtons(dest,layout)
--	print("dest=", dest, "layout =", layout)

	-- Fill in defaults for the layout table if needed
	local xWidth = layout.xWidth or 40
	local xSpacing = layout.xSpacing or 10
	local height = layout.height or 40
	local Font = layout.font or "gamefont_small"
	local yTop = layout.yTop or 0
	local xLeft
	local i
	local Count = table.getn(layout.buttonlist)

	VisCount = 0
	for i = 1,Count do
		local label = layout.buttonlist[i].tag
		if(not dest[label].hidden) then
			VisCount = VisCount + 1
		end
	end

	if(layout.xLeft) then
		xLeft = layout.xLeft
	else
		xLeft = ((VisCount - 1) * (xWidth + xSpacing)) * -0.5
	end

	for i = 1,Count do
		local label = layout.buttonlist[i].tag
		if(dest[label].hidden) then
			IFObj_fnSetVis(dest[label], nil)
		else
			-- not hidden. Show it
			TagOfFirst = TagOfFirst or label -- note which was the first

			IFObj_fnSetVis(dest[label], 1)
			IFObj_fnSetPos(dest[label], xLeft, yTop)
			xLeft = xLeft + xWidth + xSpacing
		end -- showing this one
	end

	return TagOfFirst
end



-- Adds a set of vertical text to the destination container, 'dest'.
-- The layout is specified in the table 'layout', with the actual text
-- in 'layout.buttonlist'. Defaults are provided for the layout table
-- if not specified. 
--
-- Members of layout may include:
--   yTop (float) : y-position of top element (auto-centered if omitted)
--   yHeight (float) : vertical height of each button
--   ySpace (float) : vertical spacing between elements
--   width (float) : width of each button
--   font (float) : font to be used each button
--   [to be added]
function AddVerticalText(dest,layout)
	-- Fill in defaults for the layout table if needed
	local yHeight = layout.yHeight or 40
	local ySpacing = layout.ySpacing or 10
	local width = layout.textwidth or layout.width or 100
	local Font = layout.font or "gamefont_small"
	local bFlatButton = layout.FlatButtons
	local xStart = layout.xStart or nil
	local bRightJustifyText = layout.bRightJustifyText

	local i
	local Count = table.getn(layout.buttonlist)
	local yTop = layout.yTop or ((Count * (yHeight + ySpacing)) * -0.5)

	-- calculate the math.max width of all buttons for the background
	local bgwidth = 0
	local maxbgwidth = 0
	for i = 1,Count do
		bgwidth = math.max(bgwidth, layout.buttonlist[i].width or width )
	end
	--save the start value for later (ShowHide...)
	layout.maxbgwidth = bgwidth
	--if count is odd, start it further out since the very last one will be shorter
	if( math.mod(Count,2) == 1 ) then
		bgwidth = bgwidth + yHeight + ySpacing
	end

	-- Now do the real work
	for i = 1,Count do
		local label = layout.buttonlist[i].tag

		local half = math.floor(Count/2)-1
		local flipped = i > half

		-- Right justify if requested
		local lhalign = "left"
		if(layout.RightJustifyT or bRightJustifyText) then
			lhalign = "right"
		end

		dest[label] = NewIFText 
		{ 
			y = yTop + yHeight * -0.5, 
			x = xStart,
			font = Font, 
			textw = width, texth = yHeight, 
			halign = lhalign, valign = "vcenter", 
			string = layout.buttonlist[i].title,
			bg_flipped = flipped, 
			startdelay = i*flashySpeed, 
			bg_width = bgwidth, 
			flashy = layout.flashy,
			nocreatebackground = layout.nocreatebackground,
			rightjustifybackground = layout.RightJustify,	
			bInertPos = 1,
		}

		if(bRightJustifyText) then
			dest[label].x = -width
			dest[label].x2 = -width
		end

		if(i < half) then
			bgwidth = bgwidth + yHeight + ySpacing
		elseif(i > half) then
			bgwidth = bgwidth - yHeight - ySpacing
		end
		maxbgwidth = math.max(maxbgwidth,bgwidth)

		
		if(layout.buttonlist[i].yAdd) then
			yTop = yTop + layout.buttonlist[i].yAdd
		end

		yTop = yTop + yHeight + ySpacing
	end

	-- Returns the first button, so caller can archive it (or toss it
	-- away, no big deal)
	return layout.buttonlist[1].tag
end


-- Like ShowHideVerticalButtons, this does the parallel work for the
-- text items. It reads the hidden flag out of items, and hides/ moves
-- them as necessary
function ShowHideVerticalText(dest,layout)
	-- Fill in defaults for the layout table if needed
	local yHeight = layout.yHeight or 40
	local ySpacing = layout.ySpacing or 10
	local width = layout.textwidth or layout.width or 100
	local Font = layout.font or "gamefont_small"
	local bFlatButton = layout.FlatButtons
	local xStart = layout.xStart or 0
	local bRightJustifyText = layout.bRightJustifyText

	local i,VisCount
	local Count = table.getn(layout.buttonlist)
	VisCount = 0
	for i = 1,Count do
		local label = layout.buttonlist[i].tag
		if(not dest[label].hidden) then
			VisCount = VisCount + 1
		end
	end
	local yTop = layout.yTop or ((VisCount * (yHeight + ySpacing)) * -0.5)

	-- math.max background width
	local bgwidth = layout.maxbgwidth


	-- Now do the real work
	local cnt = 1
	for i = 1,Count do
		local label = layout.buttonlist[i].tag
		if(dest[label].hidden) then
			IFObj_fnSetVis(dest[label], nil)
		else
			-- not hidden. Show it

			if(bRightJustifyText) then
				xStart = dest[label].x2
			end

			local UseHeight = layout.buttonlist[i].yHeight or yHeight
			if(layout.buttonlist[i].yAdd) then
				yTop = yTop + layout.buttonlist[i].yAdd
			end
			IFObj_fnSetVis(dest[label], 1)
			IFObj_fnSetPos(dest[label], xStart, yTop + yHeight * -0.5)
			-- Move on AFTER calc'ing position. Doing this before will kill forms w/ sliders
			yTop = yTop + UseHeight + ySpacing
			
			-- resize the flashy text element
			if( not (layout.flashy==0)) then
				local half = math.floor(VisCount/2)
				IFFlashyText_fnSetup(dest[label], cnt*0.2, cnt>half, bgwidth, nil, 0)
				if(cnt < half) then
				    bgwidth = bgwidth + yHeight + ySpacing
				elseif(cnt > half) then
					bgwidth = bgwidth - yHeight - ySpacing
				end
			end
			cnt = cnt + 1
			
		end
	end
end


-- Adds a set of vertical Options (text with a L/R arrow) to the
-- destination container, 'dest'.  The layout is specified in the
-- table 'layout', with the actual buttons in
-- 'layout.buttonlist'. Defaults are provided for the layout table if
-- not specified. Sets current button to first.
--
-- Members of layout may include:
--   yTop (float) : y-position of top element (auto-centered if omitted)
--   yHeight (float) : vertical height of each button
--   ySpace (float) : vertical spacing between elements
--   width (float) : width of each button
--   font (float) : font to be used each button
--   [to be added]
function AddVerticalOptions(dest,layout)
	-- Fill in defaults for the layout table if needed
	local yHeight = layout.yHeight or 40
	local ySpacing = layout.ySpacing or 10
	local width = layout.width or 100
	local HalfWidth = width * 0.5
	local Font = layout.font or "gamefont_small"

	local i
	local Count = table.getn(layout.buttonlist)
	local yTop = layout.yTop or ((VisCount * (yHeight + ySpacing)) * -0.5)

	-- Quick first pass: make sure tagnames are set for all of the items, fill in
	-- defaults if not. (Needed for linking)
	for i = 1,Count do
		layout.buttonlist[i].tag = layout.buttonlist[i].tag or string.format("hbutton%d",i)
	end

	-- Now do the real work
	for i = 1,Count do
		local label = layout.buttonlist[i].tag
		local yPos = yTop + (30) * -0.5

		dest[label] = NewRoundIFButton { y = yPos, btnw = width, btnh = yHeight, font = Font,} --bInertPos = 1}
		dest[label].font = nil
		dest[label].label.valign = "vcenter"
		if(layout.buttonlist[i].string) then
			RoundIFButtonLabel_fnSetString(dest[label],layout.buttonlist[i].string)
		end

		-- Activate the top button, nothing else.
		IFButton_fnSelect(dest[label],i == 1)

		-- Set up relative links for up/down. Turned to full links later.
		if(i > 1) then
			dest[label].link_up = layout.buttonlist[i - 1].tag
		else
			dest[label].link_up = layout.buttonlist[Count].tag
		end
		if(i < Count) then
			dest[label].link_down = layout.buttonlist[i + 1].tag
		else
			dest[label].link_down = layout.buttonlist[1].tag
		end

		yPos = yPos - 6 -- better align arrows w/ text

 		label = layout.buttonlist[i].tag .. "_l"
 		dest[label] = NewIFImage { y = yPos, x = -HalfWidth,
 			texture = "arrow_l", localpos_l = -8, localpos_r = 8, localpos_t = 0, localpos_b = 16,
			inertUVs= 1
		}

 		label = layout.buttonlist[i].tag .. "_r"
 		dest[label] = NewIFImage { y = yPos, x = HalfWidth,
 			texture = "arrow_r", localpos_l = -8, localpos_r = 8, localpos_t = 0, localpos_b = 16,
			inertUVs= 1
		}

		if(layout.buttonlist[i].yAdd) then
			yTop = yTop + layout.buttonlist[i].yAdd
		end

		yTop = yTop + yHeight + ySpacing
	end

	-- Returns the first button, so caller can archive it (or toss it
	-- away, no big deal)
	return layout.buttonlist[1].tag
end

function NewIFButton(Template)
	local temp = Template
	temp.type = temp.type or "button"
	temp = NewIFObj(temp)

	-- Now, do the extra work of the string.sub-items
--	temp.state = temp.state or "selected"
	local BtnW = Template.btnw or 160
	local BtnH = Template.btnh or 40
--	local Font = Template.font or gIFTextTemplate.font

	IFButton_fnSetSize(temp,BtnW,BtnH)

	return temp
end