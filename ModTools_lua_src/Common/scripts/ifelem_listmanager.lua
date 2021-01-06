--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- List manager for Lua. Handles the overall setup of them, with
-- functions for managing them.


-- Creates the entry items for a list (cursor, etc) to destination
-- container, 'Dest'. 
--
-- Layout has the following items in it:
--  .showcount : math.max # of items to show at once
--  .scrollby : [OPTIONAL] how much the list scrolls at once
--  .yTop : y-coord of top item
--  .yHeight : y-height of each item
--  .ySpacing : gutter between items
--  .width : width of each item
--  .x : x-coord of each entry
--  .slider : bool, if non-nil, adds in a vertical slider at right
--  .CreateFn -- see below
--
-- CreateFn is called for each item, with a table specifying
-- .x,.y,.width,.height for that item. It is to return a fully-built
-- item, but with blank contents (e.g. empty strings, etc)
--
function ListManager_fnInitList(Dest,Layout)
	local i
	local yHeight = Layout.yHeight
	local ySpacing = Layout.ySpacing

	-- Store type for later
	Dest.type = "listbox"

	-- Auto-calculate this as needed
	if(not Layout.yTop) then
		Layout.yTop = ((Layout.showcount * (yHeight + ySpacing)) * -0.5) + (yHeight * 0.5)
	end
	local yTop = Layout.yTop

	-- Consoles have no sliders, but they have icons at top/bottom of box instead
	if(gPlatformStr ~= "PC") then
		if(Layout.slider) then
			Layout.slider = nil -- clear out slider flag
			-- Reclaim width previously allocated to sliders
			--if(Layout.width) then
			--	Layout.width = Layout.width + 30
			--end
		end

		Dest.TopMoreIconL = NewIFImage { 
			x=0, y = yTop - (yHeight * 0.5) - 6, 
			ZPos = 160,
			localpos_l = -32, localpos_r = 2,
			localpos_t = -8,
			localpos_b = 8,
			texture = "listbox_topbot_more",
			inert_all = 1,
			ZPos = 32,
		}
		Dest.TopMoreIconR = NewIFImage { 
			x=0, y = yTop - (yHeight * 0.5) - 6, 
			ZPos = 160,
			localpos_l = 32, localpos_r = -1,
			localpos_t = -8,
			localpos_b = 8,
			texture = "listbox_topbot_more",
			inert_all = 1,
			ZPos = 32,
		}

		local TotalHeight = Layout.showcount * (yHeight + ySpacing)
		local yOffset = Layout.fBottomArrowYOffset or 0
		Dest.BotMoreIconL = NewIFImage { 
			x=0, y = yTop + TotalHeight + yOffset, 
			ZPos = 160,
			localpos_l = -32, localpos_r = 2,
			localpos_t = 8,
			localpos_b = -8,
			texture = "listbox_topbot_more",
			inert_all = 1,
			ZPos = 32,
		}
		Dest.BotMoreIconR = NewIFImage { 
			x=0, y = yTop + TotalHeight + yOffset, 
			ZPos = 160,
			localpos_l = 32, localpos_r = -1,
			localpos_t = 8,
			localpos_b = -8,
			texture = "listbox_topbot_more",
			inert_all = 1,
			ZPos = 32,
		}
	end

	local width = Layout.width or 100
	local XPos = Layout.x or 0
	if(Layout.slider) then
		-- reserve space for the slider
		XPos = XPos - gListboxSliderWidth * 0.5
	end

	Layout.FirstShownIdx = Layout.FirstShownIdx or 1
	Layout.SelectedIdx = Layout.SelectedIdx or 1
	Layout.CursorIdx = Layout.SelectedIdx
	Layout.scrollby = Layout.scrollby or math.max(1,math.floor(Layout.showcount * 0.5))

	-- Make cursor
	local CursorW = width
	local CursorX = XPos
	if(Layout.fXCursorOffset) then
		CursorW = CursorW - (Layout.fXCursorOffset * 0.5) - 26
		CursorX = CursorX + (Layout.fXCursorOffset - 18)
	end
	Dest.cursor = NewButtonWindow { 
		ZPos = 100, 
		x2=CursorX, y = yTop, 
		width = CursorW, w = CursorW, height = yHeight + 10, h = yHeight + 10 
	}
	gButtonWindow_fnSetTexture(Dest.cursor,"listbox_cursor")

	if(gPlatformStr == "PC") then
		Dest.hilight = NewButtonWindow { 
			ZPos = 100, 
			x2=XPos, y = yTop, 
			width = width, w = width, height = yHeight + 10, h = yHeight + 10 
		}
		gButtonWindow_fnSetTexture(Dest.hilight,"listbox_hilight")

		if(Layout.slider) then
			Layout.slider_top = yTop - yHeight * 0.5
			Layout.slider_bot = Layout.slider_top + Layout.showcount * (yHeight + ySpacing)
			Dest.sliderbg = NewIFImage { 
				x = XPos + width * 0.5,
				y = 0,
				ZPos = 110,
				localpos_l = 0,
				localpos_r = gListboxSliderWidth,
				localpos_t = Layout.slider_top,
				localpos_b = Layout.slider_bot,
				texture = "bf2_buttons_scroll_box",
				inert_all = 1,
			}

			Dest.sliderbg.bHotspot = 1
			Dest.sliderbg.fHotspotX = 0
			Dest.sliderbg.fHotspotW = gListboxSliderWidth
			Dest.sliderbg.fHotspotY = Layout.slider_top
			Dest.sliderbg.fHotspotH = Layout.slider_bot - Layout.slider_top

			Dest.sliderfg = NewIFImage {
				x = XPos + width * 0.5,
				y = 0,
				ZPos = 109,
				localpos_l = 0,
				localpos_r = gListboxSliderWidth,
				localpos_t = Layout.slider_top,
				localpos_b = Layout.slider_bot,
				texture = "bf2_buttons_scroll_tab",
				inert_all = 1,
			}
		end
	end -- Side sliders exist only on PC

	-- Make all the items
	for i = 1,Layout.showcount do
		Dest[i] = Layout.CreateFn { 
			x=XPos, y=yTop, width = width, height = yHeight, iIdx = i, listboxlayout = Layout
		}

		if(gPlatformStr == "PC") then
			Dest[i].bHotspot = 1
			Dest[i].fHotspotX = 0
			Dest[i].fHotspotW = width
			Dest[i].fHotspotY = -0.5 * yHeight
			Dest[i].fHotspotH = yHeight
		end

		yTop = yTop + yHeight + ySpacing
	end

end

-- Scrolls the list to ensure the Layout.SelectedIdx is onscreen
function ListManager_fnAutoscroll(Dest, Source, Layout, bNoRedraw)
	local bMovedIt

	if(Layout.SelectedIdx) then
		Layout.FirstShownIdx = Layout.FirstShownIdx or 1
		if(Layout.FirstShownIdx > Layout.SelectedIdx) then
			Layout.FirstShownIdx = Layout.SelectedIdx
			bMovedIt = 1
		end

		local Count = table.getn(Source)
		if((Count > 0) and (Layout.SelectedIdx > Count)) then
			Layout.SelectedIdx = Count
			Layout.CursorIdx = Count
			bMovedIt = 1
		end
		
		if((Layout.FirstShownIdx + Layout.showcount) <= Layout.SelectedIdx) then
			Layout.FirstShownIdx = math.max(Layout.SelectedIdx + 1 - Layout.showcount,1)
			bMovedIt = 1
		end
	end

	if((gPlatformStr ~= "PC") and (Layout.CursorIdx)) then -- cursor moves if it was present
		Layout.CursorIdx = Layout.SelectedIdx
	end

	if(not bNoRedraw) then
		ListManager_fnFillContents(Dest,Source,Layout)
	end

	-- Always track cursor changes
	ListManager_fnMoveCursor(Dest,Layout)
end

-- Scrollbar has been clicked on. Move things
function ListManager_fnScrollbarClick(this)
	if((not this.fHitX) or (not this.fHitY)) then
--		print("Uhoh, ScrollbarClick, but no idea where they clicked")
		return
	end

	local n = table.getn(this.Contents)
	local ClickPos

	-- If we click outside of the slider, then just do a pageup/down
	-- Otherwise, we need to drag it. this.fHitY is a % into the slider,
	-- not a pixel position.
	if(this.fSliderYBot < this.fHitY) then
		ListManager_fnPageDown(this,this.Contents,this.Layout)
		return
	end

	if(this.fSliderYTop > this.fHitY) then
		ListManager_fnPageUp(this,this.Contents,this.Layout)
		return
	end

	-- Must be on the slider to get here. Check to see if these are still valid
-- 	if((not this.fDragStartX) or (not this.fDragStartY)) then
-- 		return
-- 	end

	-- Now, try and center the listbox around the click position
	ClickPos = math.floor(this.fHitY * n + 1) - math.floor(this.Layout.showcount * 0.5)
	ClickPos = math.min(n, ClickPos)
	ClickPos = math.max(1, ClickPos)
	this.Layout.FirstShownIdx = ClickPos

	local EntrySelected = this.Layout.SelectedIdx
	this.Layout.SelectedIdx = math.max(EntrySelected, this.Layout.FirstShownIdx)
	this.Layout.SelectedIdx = math.min(this.Layout.SelectedIdx, this.Layout.FirstShownIdx + this.Layout.showcount - 1)
	ListManager_fnFillContents(this,this.Contents,this.Layout)
	ListManager_fnMoveCursor(this,this.Layout)
end

-- Adds items from the 'Source' table to container 'Dest' with the
-- specified Layout, and the callback 'AdderFn' to fill in a
-- specified item.
--
-- Layout should be the same Layout passed to ListManager_fnInitListExtras.
-- Extra parameters to use are:
--   .FirstShownIdx = offset of first item to show
--   .CursorIdx = absolute posn of cursor within list, nil if cursor hidden
--   .SelectedIdx = absolute posn of which item is selected, nil if no possible entries
--   .PopulateFn = (see below)
--
-- PopulateFn is called with the item (container, single item) created
-- by CreateFn, and a Layout, WHICH MAY BE NIL, or Source[i]. If nil
-- is passed, it wants the item reset to blank.

function ListManager_fnFillContents(Dest,Source,Layout)
	Source = Source or Dest.Contents
	Layout = Layout or Dest.Layout

	-- Note how many items are in the list, total. (This may change,
	-- recalc every time.
	local i
	local SourceCount = table.getn(Source)
	ListManager_fnAutoscroll(Dest,Source,Layout,1) -- move if needed

	local FirstShownIdx = Layout.FirstShownIdx or 1

	Dest.Contents = Source
	Dest.Layout = Layout

	local NumToAdd = Layout.showcount
	if(NumToAdd > SourceCount) then
		NumToAdd = SourceCount
	end

	if((FirstShownIdx + NumToAdd) > SourceCount) then
		FirstShownIdx = SourceCount - NumToAdd + 1
		Layout.FirstShownIdx = FirstShownIdx
	end

	local i
	for i = 1,Layout.showcount do
		local DrawIdx = FirstShownIdx + i - 1
		if(DrawIdx > SourceCount) then
			-- Simple case first: off end of list. Tell populator to make it blank
			Layout.PopulateFn(Dest[i],nil)
		else
			local bSelected = DrawIdx == Layout.SelectedIdx
			if(bSelected) then
				Layout.PopulateFn(Dest[i],Source[DrawIdx], bSelected, gSelectedTextColor[1], gSelectedTextColor[2], gSelectedTextColor[3], gSelectedTextAlpha)
			else
				Layout.PopulateFn(Dest[i],Source[DrawIdx], bSelected, gUnselectedTextColor[1], gUnselectedTextColor[2], gUnselectedTextColor[3], gUnselectedTextAlpha)
			end
		end
	end

	-- Make cursor follow items
	ListManager_fnMoveCursor(Dest,Layout)

	-- If there's a slider, then recalc it. MacOS got it wrong, proportional
	-- scrollbars are the way to go
	if(Dest.sliderfg) then
		local SliderHeight = Layout.slider_bot - Layout.slider_top

		-- Handle case when SourceCount < Layout.showcount 
		local ShownMax = Layout.showcount
		if(ShownMax > SourceCount) then
			ShownMax = SourceCount
		end

		local NewTop = Layout.slider_top + SliderHeight * ((FirstShownIdx - 1) / SourceCount)
		local NewBot = Layout.slider_top + SliderHeight * ((FirstShownIdx - 1 + ShownMax) / SourceCount)
		NewBot = math.max(NewBot, NewTop + 6) -- clamp to a minimum size (for PC mp sessionlist)
		Dest.fSliderYTop = (NewTop - Layout.slider_top) / SliderHeight
		Dest.fSliderYBot = (NewBot - Layout.slider_top) / SliderHeight

		IFImage_fnSetTexturePos(Dest.sliderfg,0,NewTop,gListboxSliderWidth,NewBot)
	end

	-- And, on consoles, do top/bottom sliders instead
	if(Dest.TopMoreIconL) then
		IFObj_fnSetVis(Dest.TopMoreIconL, FirstShownIdx > 1)
		IFObj_fnSetVis(Dest.TopMoreIconR, FirstShownIdx > 1)
		IFObj_fnSetVis(Dest.BotMoreIconL, (FirstShownIdx + NumToAdd - 1) < SourceCount )
		IFObj_fnSetVis(Dest.BotMoreIconR, (FirstShownIdx + NumToAdd - 1) < SourceCount )
	end

	if(Layout.CursorIdx) then
 	  gCurListboxLayout = Layout
	end

end

-- Redraws the cursor based on the current position (nil == off)
function ListManager_fnMoveCursor(Dest,Layout)

	local NormalCursorIdx = Layout.CursorIdx

	-- Only on PC does Cursor vary from Selected. Show alternate cursor if
	-- appropriate.
	if(gPlatformStr == "PC") then

		NormalCursorIdx = Layout.SelectedIdx

		local bShowHilight = nil
		local hilight_offset_y = Layout.hilight_offset_y or 0
		if((Layout.CursorIdx) and (Layout.CursorIdx ~= Layout.SelectedIdx)) then
			local CursorOffset = (Layout.CursorIdx - Layout.FirstShownIdx)
			if((CursorOffset >= 0) and (CursorOffset < Layout.showcount)) then
				bShowHilight = 1
				local NewY = Layout.yTop + CursorOffset * (Layout.yHeight + Layout.ySpacing) + hilight_offset_y
				IFObj_fnSetPos(Dest.hilight,Dest.hilight.x2, NewY + 4)
			end
		end

		IFObj_fnSetVis(Dest.hilight,bShowHilight)
	end

	if(NormalCursorIdx) then
		local CursorOffset = (NormalCursorIdx - Layout.FirstShownIdx) 
		local NewY = Layout.yTop + CursorOffset * (Layout.yHeight + Layout.ySpacing)

		IFObj_fnSetVis(Dest.cursor,1)
		IFObj_fnSetPos(Dest.cursor,Dest.cursor.x2, NewY + 4)
		if(Layout.bInstance2) then
			gCurHiliteListbox2 = Dest -- note which is active
		else
			gCurHiliteListbox = Dest -- note which is active
		end
	else
		IFObj_fnSetVis(Dest.cursor,nil)
		if(Layout.bInstance2) then
			gCurHiliteListbox2 = nil
		else
			gCurHiliteListbox = nil -- nothing is active
		end
	end
end

gListbox_CurSizeAdd = 1
gListbox_CurDir = 1

-- Time has elapsed on the current listbox. Animate its cursor
function ListManager_fnHilight(this,fDt)
	local ButtonSpeed = 1
--	local ButtonDir = this.ButtonSpeed or 20
--	local ButtonAddScale = this.ButtonAddScale or 1
	local ButtonMaxScale = 1.0
	local ButtonMinScale = 0.5

	if(this.cursor) then
		gListbox_CurSizeAdd = gListbox_CurSizeAdd + fDt * gListbox_CurDir
		if(gListbox_CurSizeAdd > ButtonMaxScale) then
			gListbox_CurSizeAdd = ButtonMaxScale
			gListbox_CurDir = -ButtonSpeed
		elseif (gListbox_CurSizeAdd < ButtonMinScale) then
			gListbox_CurSizeAdd = ButtonMinScale
			gListbox_CurDir = ButtonSpeed
		end
		IFObj_fnSetAlpha(this.cursor,gListbox_CurSizeAdd)
	end
end

-- Goes up on the listbox, if possible. May retrigger a redraw of items
-- if the list scrolled, which is why it needs to know things
function ListManager_fnNavUp(Dest,Source,Layout)
	Source = Source or Dest.Contents
	Layout = Layout or Dest.Layout
	local SourceCount = Layout.enablecount or table.getn(Source)
	if(SourceCount < 1) then
		return
	end

	ListManager_fnAutoscroll(Dest, Source, Layout, 1) -- move cursor

	if(Layout.SelectedIdx > 1) then
		ifelm_shellscreen_fnPlaySound("shell_select_change")
		Layout.SelectedIdx = Layout.SelectedIdx - 1

		-- move internal position, redrawing if necessary
		ListManager_fnAutoscroll(Dest,Source,Layout)
	end
end

-- Goes up on the listbox, if possible. May retrigger a redraw of items
-- if the list scrolled, which is why it needs to know things
function ListManager_fnNavDown(Dest,Source,Layout)
	Source = Source or Dest.Contents
	Layout = Layout or Dest.Layout

	local SourceCount = Layout.enablecount or table.getn(Source)
	if(SourceCount < 1) then
		return
	end

	ListManager_fnAutoscroll(Dest, Source, Layout, 1) -- move cursor, no redraw

	if(Layout.SelectedIdx < SourceCount) then
		ifelm_shellscreen_fnPlaySound("shell_select_change")
		Layout.SelectedIdx = Layout.SelectedIdx + 1

		-- move internal position, redrawing if necessary
		ListManager_fnAutoscroll(Dest, Source, Layout)
	end
end

-- Goes up on the listbox, if possible. May retrigger a redraw of items
-- if the list scrolled, which is why it needs to know things
function ListManager_fnPageUp(Dest,Source,Layout, bAlwaysScroll)
	Source = Source or Dest.Contents
	Layout = Layout or Dest.Layout
	local SourceCount = Layout.enablecount or table.getn(Source)
	if(SourceCount < 1) then
		return
	end

	ListManager_fnAutoscroll(Dest, Source, Layout, 1) -- move cursor, no redraw

	if(Layout.SelectedIdx > 1) then
		ifelm_shellscreen_fnPlaySound("shell_select_change")

		local RelativePos = Layout.SelectedIdx - Layout.FirstShownIdx + 1

		-- Go to top of current page if in the middle of the current
		-- page, or up one whole page if at the top of the current
		if((RelativePos < 2) or (bAlwaysScroll)) then
			Layout.SelectedIdx = math.max(1,Layout.SelectedIdx - Layout.showcount)
		else
			Layout.SelectedIdx = math.max(1,Layout.SelectedIdx - RelativePos + 1)
		end

		-- move internal position, redrawing if necessary
		ListManager_fnAutoscroll(Dest,Source,Layout)
	end
end

-- Goes up on the listbox, if possible. May retrigger a redraw of items
-- if the list scrolled, which is why it needs to know things
function ListManager_fnPageDown(Dest, Source, Layout, bAlwaysScroll)
	Source = Source or Dest.Contents
	Layout = Layout or Dest.Layout

	local SourceCount = Layout.enablecount or table.getn(Source)
	if(SourceCount < 1) then
		return
	end

	ListManager_fnAutoscroll(Dest, Source, Layout, 1) -- move cursor, no redraw

	local SourceCount = Layout.enablecount or table.getn(Source)
	if(Layout.SelectedIdx < SourceCount) then
		ifelm_shellscreen_fnPlaySound("shell_select_change")

		local RelativePos = Layout.SelectedIdx - Layout.FirstShownIdx + 1

		-- Go to bottom of current page if in the middle of the current
		-- page, or down one whole page if at the bottom of the current
		if((RelativePos >= Layout.showcount) or (bAlwaysScroll)) then
			Layout.SelectedIdx = math.min(SourceCount,Layout.SelectedIdx + Layout.showcount)
		else
			Layout.SelectedIdx = math.min(SourceCount,Layout.SelectedIdx + (Layout.showcount - RelativePos))
		end

		-- move internal position, redraw if necessary
		ListManager_fnAutoscroll(Dest,Source,Layout)
	end
end

function ListManager_fnScrollUp(Dest,Source,Layout)
	Source = Source or Dest.Contents
	Layout = Layout or Dest.Layout
	if(Layout.FirstShownIdx > 1) then
		ifelm_shellscreen_fnPlaySound("shell_select_change")
		Layout.FirstShownIdx = Layout.FirstShownIdx - 1
		if(Layout.SelectedIdx and (Layout.SelectedIdx >= Layout.FirstShownIdx + Layout.showcount)) then
			Layout.SelectedIdx = Layout.SelectedIdx - 1
		end
	end
end

function ListManager_fnScrollDown(Dest,Source,Layout)
	Source = Source or Dest.Contents
	Layout = Layout or Dest.Layout
	local SourceCount = Layout.enablecount or table.getn(Source)
	if(Layout.FirstShownIdx <= SourceCount-Layout.showcount) then
		ifelm_shellscreen_fnPlaySound("shell_select_change")
		Layout.FirstShownIdx = Layout.FirstShownIdx + 1
		if(Layout.SelectedIdx and (Layout.SelectedIdx < Layout.FirstShownIdx)) then
			Layout.SelectedIdx = Layout.SelectedIdx + 1
		end
	end
end

-- Sets the listbox with 'focus'
function ListManager_fnSetFocus(Dest)
	gListManager_FocusListbox = Dest
end

-- Returns the listbox with 'focus'
function ListManager_fnGetFocus()
	return gListManager_FocusListbox
end