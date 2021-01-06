--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


function HandleMouse_Text(this,MouseX,MouseY)
	--print("In HandleMouse_Text. Values=",MouseX,MouseY)
	return nil -- didn't hit it
end

function HandleMouse_Model(this,MouseX,MouseY)
	return nil -- didn't hit it
end

function HandleMouse_Button(this,MouseX,MouseY)
	--print("In HandleMouse_Btn. Values=",MouseX,MouseY)

	if((this.alpha == 0) or (this.hidden == 1) or (this.bDimmed)) then
		return nil
	end
	
	local bHit = IFObj_fnIsMouseOver(this.label, MouseX, MouseY)
	if(not bHit) then
		return nil
	end

	--	print("In HandleMouse_Btn. LTRB=",left,top,right,bottom, this.label.halign,this.label.valign, this.width, this.height, this.label.texth )
	SetCurButtonTable(this)
	if(gCurPopup) then
	else
		if(gCurScreenTable.UpdateButtons) then
			gCurScreenTable.UpdateButtons(gCurScreenTable)
		end
	end

	return 1 -- yes, did hit
end

function HandleMouse_ButtonWindow(this,MouseX,MouseY)
	--print("In HandleMouse_Btn. Values=",MouseX,MouseY)

	if( this.alpha == 0 or this.hidden == 1 ) then
		return nil
	end

	local bHit = IFObj_fnIsMouseOver(this, MouseX, MouseY)
	if(not bHit) then
		return nil
	end

	gMouseOverButtonWindow = this
	return 1 -- yes, did hit
end


function HandleMouse_Editbox(this,MouseX,MouseY)
  --	print("In HandleMouse_Editbox. Values=",MouseX,MouseY)
	if( this.alpha == 0 ) then
		return nil
	end

	local bHit = IFObj_fnIsMouseOver(this, MouseX, MouseY)
	if(not bHit) then
		return nil
	end

	gCurEditbox = this
	gCurEditbox.bMouseover = 1

	return 1 -- yes, did hit
end

function HandleMouse_Image(this,MouseX,MouseY)
  
	local bHit = IFObj_fnIsMouseOver(this, MouseX, MouseY)
	if(not bHit) then
		return nil
	end

--	print("Over Mouse_Image...")

	if(this.tag) then
		SetCurButton(this.tag)
		if(gCurScreenTable.UpdateButtons) then
			gCurScreenTable.UpdateButtons(gCurScreenTable)
		end
		if(gCurScreenTable.UpdateUI) then
			gCurScreenTable.UpdateUI(gCurScreenTable)
		end
		if(gCurScreenTable.UpdateUIMouseOver) then
			gCurScreenTable.UpdateUIMouseOver(gCurScreenTable, this)
		end		
	end

	gMouseOverImage = this

	return 1 -- yes, did hit
end

function HandleMouse_Listbox(this, MouseX, MouseY)
  if(not this.Contents) then
		return nil
	end

	local ItemCount = table.getn(this.Contents)
	if( ItemCount == 0) then
		return nil
	end

	if((this.alpha == 0) or (this.hidden == 1)) then
		return nil
	end

	if(this.sliderbg) then
		local bHitSlider,fHitX,fHitY = IFObj_fnIsMouseOver(this.sliderbg, MouseX, MouseY)
		if(bHitSlider) then
			this.fHitX = fHitX
			this.fHitY = fHitY
			gMouseListBoxSlider = this
			gbWantMousedownEvents = 1 -- want more mousedown (Input_Accept) events
--			print(" HitSlider", fHitX, fHitY)
			return 1 -- yes, did hit
		end
	end -- check for a collision w/ slider

	local i
	for i=1,this.Layout.showcount do
		local bHit = IFObj_fnIsMouseOver(this[i], MouseX, MouseY)
		if(bHit) then
			local NewIdx = this.Layout.FirstShownIdx + i - 1

			-- Also recurse into the items on this row, in case any are clickable
			HandleMouseRecurse(this[i], MouseX, MouseY)

			if((this.Layout.CursorIdx ~= NewIdx) and (NewIdx <= table.getn(this.Contents))) then
				if(not this.Layout and not this.Layout.noChangeSound) then
					ScriptCB_SndPlaySound("shell_select_change")
				end
				this.Layout.CursorIdx = NewIdx
				
				--print( "+++this.Layout.CursorIdx = ", this.Layout.CursorIdx )
				
				-- Repaint self
				ListManager_fnFillContents(this,this.Contents,this.Layout)
				if(gCurScreenTable.UpdateUI) then
					gCurScreenTable.UpdateUI(gCurScreenTable)
				end
				if(gCurScreenTable.fnClearButtonHilight) then
					gCurScreenTable.fnClearButtonHilight(gCurScreenTable)
				end
			elseif (NewIdx > table.getn(this.Contents)) then
				-- Moved off the list. Clear cursor if applicable
				if(this.Layout.CursorIdx) then
					this.Layout.CursorIdx = nil
					ListManager_fnFillContents(this,this.Contents,this.Layout)
				end
			end

			gMouseListBox = this

			return 1 -- yes, did hit
		end
	end
end


function HandleMouse_HSlider(this,MouseX,MouseY)
	local bHitSlider,fHitX,fHitY = IFObj_fnIsMouseOver(this.sliderbg, MouseX, MouseY)
	if(bHitSlider) then
		this.fHitX = fHitX
		this.fHitY = fHitY
		gMouseOverHorz = this
		gbWantMousedownEvents = 1 -- want more mousedown (Input_Accept) events
		return 1 -- yes, did hit
	end

	return nil -- nope, didn't hit
end

function ifutil_mouse_fnListSortCB(a, b)
	local Z1, Z2
	Z1 = a.z or 128
	Z2 = b.z or 128

	return Z1 < Z2
end

function HandleMouseRecurse(this,MouseX,MouseY)
	-- If this item has a screen pin, set x/y from there
	
	if( this.bHidden or not IFObj_fnGetVis(this) ) then
		return
	end
	
	-- Do specific leaf-node subtypes here.	
	if((this.type == "text") and 
		 HandleMouse_Text(this,MouseX,MouseY)) then
		return 1
	elseif ((this.type == "button") and
					HandleMouse_Button(this,MouseX,MouseY)) then
--		print("Over Button")
		return 1
	elseif (((this.type == "image") or (this.type == "maskimage")) and 
					HandleMouse_Image(this,MouseX,MouseY)) then
--		print("Over Image")
		return 1
	elseif ((this.type == "model") and
					HandleMouse_Model(this,MouseX,MouseY)) then
		return 1
	elseif (this.type == "listbox") then
		local bHit = HandleMouse_Listbox(this,MouseX,MouseY)
		return bHit
	elseif ((this.type == "hslider") and
					HandleMouse_HSlider(this,MouseX,MouseY)) then
--		print("Over HSlider")
		return 1
	elseif ((this.type == "editbox") and 
					HandleMouse_Editbox(this,MouseX,MouseY)) then
		return 1
	elseif ((this.type == "buttonwindow") and
					HandleMouse_ButtonWindow(this,MouseX,MouseY)) then
 		return 1
	end

	local bPopupOpen = ScriptCB_IsPopupOpen()

	-- Leaf case not handled above. Recurse down all subtables.
	local SortedList = {}
	local k,v
	local NumItems = 0
	for k,v in this do
		if(type(v) == "table") then
			if((bPopupOpen) and ((k == "EntryScreenTable") or (k == "_Tabs")  or (k == "calledFrom") or (k == "_Tabs1") or (k == "_Tabs2"))) then
--				print(" NO recurse! "..k)
			else
				local ZPos = v.ZPos or 128
				NumItems = NumItems + 1
				SortedList[NumItems] = { z = ZPos, t = v, }
			end
		end
	end -- loop over this

	table.sort(SortedList, ifutil_mouse_fnListSortCB) 
	
	local i,bHit
	for i = 1,NumItems do
		bHit = HandleMouseRecurse(SortedList[i].t, MouseX, MouseY)
		if(bHit) then
			return bHit
		end
	end

	-- Recursion into this didn't hit anything
	return nil
end

function gHandleMouse(this, MouseX,MouseY)
	local EntryOverSlider = gMouseOverSlider
	local EntryOverHorz = gMouseOverHorz
	local EntryButton = this.CurButton
	local EntryEditbox = gCurEditbox
	local EntryListBoxSlider = gMouseListBoxSlider
	local EntryImage = gMouseOverImage
	gbWantMousedownEvents = nil -- Don't want more mousedown (Input_Accept) events (child may reset this)

	if(EntryEditbox) then
		EntryEditbox.bMouseover = nil
	end

	-- Clear items 
	gMouseOverSlider = nil
	gMouseOverHorz = nil
	local EntryMouseListBox = gMouseListBox
	gMouseListBox = nil
	gMouseListBoxSlider = nil
	gCurEditbox = nil
	gMouseOverButtonWindow = nil
	gMouseOverImage = nil
	SetCurButton(nil)
	-- call the recursive workhorse function
	HandleMouseRecurse(this,MouseX,MouseY)

	-- If something changed, then play sfx.
	-- Todo - maybe make this a bit better?
	if (((not EntryOverSlider) and gMouseOverSlider) or
			((not EntryOverHorz) and gMouseOverHorz) or
				((not EntryEditbox) and gCurEditbox and (not gCurEditbox.noChangeSound)) or
				((not EntryListBoxSlider) and gMouseListBoxSlider) or
				((not EntryImage) and gMouseOverImage) or
				(EntryButton ~= this.CurButton)) then
		
		if (this.CurButton or gCurEditbox or gMouseOverImage or gMouseOverSlider or gMouseListBoxSlider or gMouseOverHorz) then
			if(not this.Layout or not this.Layout.noChangeSound) then
				ScriptCB_SndPlaySound("shell_select_change")
			end
		end
	end

	-- Focus-follows-mouse is the OneTrueWay(tm). [Don't like it? Here's a nickel,
	-- kid, buy yourself a better computer]
	--
	-- But, since whiners complain, be sloppy about edit boxes. They'll keep
	-- focus until you go to another
	if((EntryEditbox) and (EntryEditbox.bStickyFocus) and 
		 ((not EntryEditbox.alpha) or (EntryEditbox.alpha > 0))) then
		gMouseOverEditbox = gCurEditbox
		gCurEditbox = EntryEditbox
	elseif ((not gCurEditbox) and (EntryEditbox) and (EntryEditbox.bKeepsFocus) and 
		 ((not EntryEditbox.alpha) or (EntryEditbox.alpha > 0))) then
		gCurEditbox = EntryEditbox
	end

	if(gCurEditbox ~= EntryEditbox) then
		if(EntryEditbox) then
			IFEditbox_fnHilight(EntryEditbox, nil)
		end
		if(gCurEditbox) then
			IFEditbox_fnHilight(gCurEditbox, 1)
		end
	end

	-- If moved off this listbox this frame, then must clear cursor
	if((EntryMouseListBox) and (not gMouseListBox) and (EntryMouseListBox.Layout.CursorIdx)) then
		EntryMouseListBox.Layout.CursorIdx = nil
		ListManager_fnFillContents(EntryMouseListBox,EntryMouseListBox.Contents,EntryMouseListBox.Layout)
	end

end