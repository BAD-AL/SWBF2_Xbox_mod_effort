
function Form_ClampValue(value, min, max)
--	print("value = ", value, " min = ", min, " max = ", max)
	return math.max(min, math.min(max, value))
end

-- Helper function. Given a layout (x,y,width, height), returns a fully-built item
function Form_ListBox_CreateItem(layout)
    -- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { x = layout.x - 0.5 * layout.width, y=layout.y - ScriptCB_GetFontHeight(layout.listboxlayout.font) * 0.5}
	Temp.label = NewIFText{ x = 10, y = 0, halign = layout.listboxlayout.halign, font = layout.listboxlayout.font, textw = layout.width, flashy=0}
	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function Form_ListBox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)

	if(Data) then
		if(type(Data) == "table") then		
			IFText_fnSetUString(Dest.label,Data.label)
		elseif (Data) then
			IFText_fnSetString(Dest.label,Data)
		else
			IFText_fnSetString(Dest.label,"")
		end

		if(type(Data) == "string") then		

		elseif(Data.bUnselectable) then
			IFObj_fnSetColor(Dest.label, 255, 0, 0)
		else
			IFObj_fnSetColor(Dest.label, iColorR, iColorG, iColorB)
		end
		IFObj_fnSetAlpha(Dest.label, fAlpha)
	else
		-- Blank the data
		IFText_fnSetString(Dest.label,"")
	end
	IFObj_fnSetVis(Dest.label,Data)
end

function Form_UpdateElement(form, elementTag)

	if(form.elements[elementTag].control == "dropdown") then
		if(form.dropdowns[elementTag].expanded) then
			IFObj_fnSetVis(form.dropdowns[elementTag].listbox,1)	-- show the listbox
			ListManager_fnFillContents(form.dropdowns[elementTag].listbox,form.elements[elementTag].values,form.dropdowns[elementTag].listbox.Layout)
		else
			IFObj_fnSetVis(form.dropdowns[elementTag].listbox,nil)	-- hide the listbox
		end
	elseif (form.elements[elementTag].control == "radio") then
		form.radiobuttons[elementTag].hidden = form.elements[elementTag].hidden
	elseif (form.elements[elementTag].control == "slider") then
		form.sliders[elementTag].hidden = form.elements[elementTag].hidden
	end

	form.buttons[elementTag].hidden = form.elements[elementTag].hidden
	form.text[elementTag].hidden = form.elements[elementTag].hidden
end

function Form_UpdateAllElements(form)
	local key, value
	for key,value in pairs(form.elements) do
		if(type(value) == "table") then
			Form_UpdateElement(form, key)
		end
	end
end

function Form_ShowHideElements(form)
	local key, value
	for key,value in pairs(form.elements) do
		if(type(value) ~= "table") then

		else
			form.buttons[key].hidden = form.elements[key].hidden 
			form.text[key].hidden = form.elements[key].hidden
		end
	end

	ShowHideVerticalText(form.text, form.layout)
	ShowHideVerticalButtons(form.buttons, form.layout)

	-- Hide the fake-buttons for things like sliders.
	-- This is done in a separate pass as ShowHideVerticalButtons needs to
	-- have the visible flag set to true to keep the spacing of the buttons
	-- and their labels correct.
	for key,value in pairs(form.elements) do
		if(type(value) ~= "table") then
		elseif( form.buttons[key].hidden ) then
			if(form.elements[key].control == "slider") then
				IFObj_fnSetVis(form.sliders[key], nil)
				IFObj_fnSetVis(form.buttons[key], nil)
			elseif( form.elements[key].control == "dropdown" ) then
				IFObj_fnSetVis(form.dropdowns[key].button, nil)
				IFObj_fnSetVis(form.dropdowns[key].listbox, nil)
				IFObj_fnSetVis(form.buttons[key], nil)
			elseif( form.elements[key].control == "radio" ) then
				IFObj_fnSetVis(form.radiobuttons[key], nil)
			end
		else
			if(form.elements[key].control == "slider") then
				IFObj_fnSetVis(form.sliders[key], 1)
				IFObj_fnSetVis(form.buttons[key], 1)
				IFObj_fnSetPos(form.sliders[key], nil, form.buttons[key].y, nil)
			elseif( form.elements[key].control == "dropdown") then
				IFObj_fnSetVis(form.dropdowns[key].button, 1)
				IFObj_fnSetPos(form.dropdowns[key].button, nil, form.buttons[key].y, nil)
				IFObj_fnSetPos(form.dropdowns[key].listbox, nil, form.buttons[key].y + form.dropdowns[key].listbox.height/2 + 5, nil)
			elseif( form.elements[key].control == "radio" ) then
				IFObj_fnSetVis(form.radiobuttons[key], 1)
				IFObj_fnSetPos(form.radiobuttons[key], nil, form.buttons[key].y, nil)
			end
		end
		
	end

end

function Form_SetValues(form)
	local key, value

	for key,value in pairs(form.elements) do
		if(type(value) ~= "table") then

		elseif (form.elements[key].control == "slider") then
			form.elements[key].selValue = Form_ClampValue(form.elements[key].selValue, form.elements[key].minValue, form.elements[key].maxValue)
			form.sliders[key].thumbposn = ((form.elements[key].selValue - form.elements[key].minValue) / (form.elements[key].maxValue-form.elements[key].minValue))
			HSlider_MoveThumb(form.sliders[key])
			local mult = form.elements[key].sliderMultiplier or 100
			if(form.elements[key].sliderString) then
				RoundIFButtonLabel_fnSetUString(form.buttons[key], string.format(form.elements[key].sliderString, form.elements[key].selValue * mult))
			else
				RoundIFButtonLabel_fnSetUString(form.buttons[key], ScriptCB_tounicode(string.format("%d", form.elements[key].selValue * mult)))
			end
		elseif( form.elements[key].control == "dropdown" ) then
			form.elements[key].selValue = Form_ClampValue(form.elements[key].selValue, 1, table.getn(form.elements[key].values)	)
			local value = form.elements[key].values[form.elements[key].selValue]
			if( type(value) == "table" ) then
				value = value.label or ""
				RoundIFButtonLabel_fnSetUString(form.dropdowns[key].button, value)
			else
				RoundIFButtonLabel_fnSetString(form.dropdowns[key].button, value or "")
			end
		elseif( form.elements[key].control == "radio" ) then
			form.elements[key].selValue = Form_ClampValue(form.elements[key].selValue, 1, table.getn(form.elements[key].values) )
			ifelem_SelectRadioButton(form.radiobuttons[key], form.elements[key].selValue, true)
		else
			if(form.elements[key].selValue) then
				form.elements[key].selValue = Form_ClampValue(form.elements[key].selValue, 1, table.getn(form.elements[key].values)	)
				RoundIFButtonLabel_fnSetString(form.buttons[key], form.elements[key].values[form.elements[key].selValue])
			else
				print("Uhoh. form.elements[", key, "] is nil. Punting.")
			end
		end
	end
end

function Form_Update(form, fDt)
	local key, value
	for key,value in pairs(form.elements) do
		if((type(value) == "table") and (form.elements[key].control == "slider")) then
			HSlider_fnSetAlpha(form.sliders[key],0.5) -- dim unselected one
		end
	end

	if(gMouseOverHorz) then
		HSlider_fnSetAlpha(gMouseOverHorz,1.0) -- brite selected one
	end

	--    if(form.elements[gCurScreenTable.CurButton].control and form.elements[gCurScreenTable.CurButton].control == "slider") then
	--        HSlider_fnSetAlpha(this.sliders[this.CurButton],1.0) -- brite selected one
	--    end
end

function Form_Enter(this, bFwd)
	Form_UpdateAllElements(this)
end

function Form_Exit(this)

end

function Form_InputBack(this)

end

function Form_GeneralRight(this)

end

function Form_GeneralLeft(this)

end

function Form_GeneralUp(this)

end

function Form_GeneralDown(this)

end

-- Helper function - closes any open dropboxes. Called from outside
-- when switching away from this screen, etc. Doing so fixes #13353 -
-- NM 9/19/05
function Form_CloseDropboxes(this)
--	print("In Form_CloseDropboxes. gMouseListBox = ", gMouseListBox)
	local key, element
	for key,element in pairs(this.elements) do
		if(type(element) == "userdata") then

		elseif (element.control == "dropdown") then
			if(this.dropdowns[key].expanded) then
				IFObj_fnSetVis(this.dropdowns[key].listbox,nil)  -- hide the listbox
				this.dropdowns[key].expanded = false
				return true
			end
		end
	end
end

function Form_InputAccept(this)

	if(gMouseListBox) then

		-- find the dropdown box that corresponds to the list box
		local element = nil
		local key, value
		for key,value in pairs(this.dropdowns) do
			if(type(value) == "table") then
				if(value.listbox.tag == gMouseListBox.tag) then
					element = this.elements[value.tag]
				end
			end
		end

		if(not element) then
			return false
		end

		gMouseListBox.Layout.SelectedIdx = gMouseListBox.Layout.CursorIdx
		ListManager_fnFillContents(gMouseListBox,gMouseListBox.Contents,gMouseListBox.Layout)
		
		IFObj_fnSetVis(gMouseListBox,nil)	-- hide the listbox
		this.dropdowns[element.tag].expanded = false
		element.selValue = gMouseListBox.Layout.SelectedIdx
		Form_SetValues(this)
		
		if(element.fnChanged) then
			element.fnChanged(this, element)
		end
		
		return true
	end

	if((gMouseOverHorz) and (gMouseOverHorz.fHitX)) then
		local element = this.elements[gMouseOverHorz.tag]
		if(not element) then
			return false
		end

		-- Convert slider percentage into 0..10 scale used on this screen
		local NewVal = gMouseOverHorz.fHitX
		element.selValue = element.minValue + NewVal * (element.maxValue - element.minValue)
		element.selValue = Form_ClampValue(element.selValue, element.minValue, element.maxValue)
		if(element.fnChanged) then
			element.fnChanged(this, element)
		end

		Form_SetValues(this)
		return true
	end
	
	-- loop through all the elements and update
	local key, element
	for key,element in pairs(this.elements) do
		if(type(element) == "userdata") then

		elseif (element.control == "dropdown") then
			if(this.dropdowns[key].expanded) then
				IFObj_fnSetVis(this.dropdowns[key].listbox,nil)  -- hide the listbox
				this.dropdowns[key].expanded = false
				return true
			end
		end
	end

	if ( ifelem_HandleRadioButtonInputAccept(this) ) then
		return true
	end

	-- operate on the current button
	local CurButton = gCurScreenTable.CurButton
	if(CurButton) then
		-- See if button name has the "button_" prefix (for dropboxes),
		-- and slice that off if so.
		local CurButtonPrefix = string.sub(CurButton, 1, 7)
		if(CurButtonPrefix == "button_") then
			local ButtonNameLen = string.len(CurButton)
			CurButton = string.sub(CurButton, -(ButtonNameLen - 7))
--			print("Sliced buttonname to ", CurButton)
		end
	end
	
	local curElement = this.elements[CurButton]

	if(not curElement) then
		return false
	end

	if(curElement.control == "dropdown") then
		ScriptCB_SndPlaySound("shell_menu_ok")
--		print("dropdown expanded: ", this.dropdowns[curElement.tag].expanded)
		if(not this.dropdowns[curElement.tag].expanded) then
			this.dropdowns[curElement.tag].expanded = true    -- go into listbox mode
			IFObj_fnSetVis(this.dropdowns[curElement.tag].listbox,1)   -- show the listbox
			this.dropdowns[curElement.tag].listbox.Layout.SelectedIdx = this.elements[curElement.tag].selValue
			this.dropdowns[curElement.tag].listbox.Layout.CursorIdx = this.elements[curElement.tag].selValue
			this.dropdowns[curElement.tag].listbox.Layout.FirstShownIdx = this.elements[curElement.tag].selValue
			ListManager_fnFillContents(this.dropdowns[curElement.tag].listbox,this.elements[curElement.tag].values,this.dropdowns[curElement.tag].listbox.Layout)
		else
			this.dropdowns[curElement.tag].expanded = nil    -- go into listbox mode
			IFObj_fnSetVis(this.dropdowns[curElement.tag].listbox,nil)   -- hide the listbox
		end
	elseif (curElement.control == "button") then
		-- cycle through the button values
		if(curElement.selValue) then
			curElement.selValue = curElement.selValue + 1
			if(curElement.selValue > table.getn(curElement.values)) then
				curElement.selValue = 1
			end
		else
			print("Uhoh. curElement.selValue is nil. punting")
		end
				
		if(curElement.fnChanged) then
			curElement.fnChanged(this, curElement)
		end		
	else
		return false
	end

	Form_SetValues(this)
	return true
end

-- attempt to figure out which element we're mouseover
function Form_GetMouseOverTag(this)

	if(gMouseListBox) then

		-- find the dropdown box that corresponds to the list box
		local element = nil
		local key, value
		for key,value in pairs(this.dropdowns) do
			if(type(value) == "table") then
				if(value.listbox.tag == gMouseListBox.tag) then
					element = this.elements[value.tag]
				end
			end
		end

		if(not element) then
			return nil
		end
		return element.tag
	end

	if((gMouseOverHorz) and (gMouseOverHorz.fHitX)) then
		local element = this.elements[gMouseOverHorz.tag]
		if(not element) then
			return nil
		end

		return element.tag
	end
	
	-- radio buttons need one too
	local radioTag, radioGroup = ifelem_GetRadioButtonMouseOverTag(this)
	if ( radioTag ) then
		return radioGroup.tag
	end

	-- operate on the current button
	local CurButton = gCurScreenTable.CurButton
	if(CurButton) then
		-- See if button name has the "button_" prefix (for dropboxes),
		-- and slice that off if so.
		local CurButtonPrefix = string.sub(CurButton, 1, 7)
		if(CurButtonPrefix == "button_") then
			local ButtonNameLen = string.len(CurButton)
			CurButton = string.sub(CurButton, -(ButtonNameLen - 7))
--			print("Sliced buttonname to ", CurButton)
		end
	end
	
	local curElement = this.elements[CurButton]

	if(not curElement) then
		return nil
	end
	
	return curElement.tag
end
-- end mouseover bit

function Form_CreateVertical(container, layout)
	layout.buttonlist = {}
	layout.width = layout.width / 2
	layout.LeftJustify = 1    --buttons
	layout.RightJustifyT = 1  --text

	local form = NewIFContainer {
		x = 0,
		y = 0,
	}

	form.text = NewIFContainer {
		x = -layout.width * 1.3 - layout.xSpacing * 0.5,
		y = 0,
	}

	form.buttons = NewIFContainer {
		x = layout.width - 20,
		y = 0,
	}
	
	form.radiobuttons = NewIFContainer {
		x = -layout.width * 0.3 - layout.xSpacing * 0.5,
		y = 0,
	}

	form.sliders = NewIFContainer {
		x = -layout.width * 0.3 + layout.xSpacing * 0.5,
		y = 0,
	}
	
	form.dropdowns = NewIFContainer {
		x = -layout.width * 0.3 + layout.xSpacing * 0.5,
		y = 0,
		ZPos = 90, -- in front of regular buttons, sliders
	}

	form.elements = {}
	form.layout = layout

	local numElements = table.getn(layout.elements)
	local i
	for i = 1,numElements do
		local tag = layout.elements[i].tag
		layout.buttonlist[i] = {
			tag = tag,
			title = layout.elements[i].title,
			string = "",
			noCreateHotspot = true,
		}
				
		-- create the element
		form.elements[tag] = {}
		form.elements[tag].tag = tag
		form.elements[tag].hidden = layout.elements[i].hidden
		form.elements[tag].title = layout.elements[i].title
		form.elements[tag].control = layout.elements[i].control or "button"
		form.elements[tag].minValue = layout.elements[i].minValue
		form.elements[tag].maxValue = layout.elements[i].maxValue
		form.elements[tag].selValue = layout.elements[i].selValue or 1
		form.elements[tag].fnChanged = layout.elements[i].fnChanged
		form.elements[tag].sliderMultiplier = layout.elements[i].sliderMultiplier -- for sliders
		form.elements[tag].sliderString = layout.elements[i].sliderString -- for sliders
		
		if(layout.elements[i].values) then
			-- copy all values
			form.elements[tag].values = {}
			local j
			for j = 1,table.getn(layout.elements[i].values) do
				form.elements[tag].values[j] = layout.elements[i].values[j]
			end
		else
			form.elements[tag].values = nil
		end
	end

	AddVerticalText(form.text,layout)
	layout.width = layout.width * 0.25	-- ghetto cheating to make button hotspots not stretch across the screen
	form.curButton = AddVerticalButtons(form.buttons, layout);
	layout.width = layout.width * 4

	local i
	for i = 1,numElements do
		local elementWidth = layout.width or 300
		elementWidth = layout.elements[i].width or elementWidth

		if(layout.elements[i].control == "slider") then
			local Tag = layout.elements[i].tag
--			IFObj_fnSetVis(form.buttons[Tag], nil) -- hide empty button, so that slider hotspot works

			form.sliders[layout.elements[i].tag] = NewHSlider {
				x = elementWidth/2, y = form.buttons[layout.elements[i].tag].y,
				width = elementWidth, height = 24, thumbwidth = 10,
				texturebg = "slider_sound", texturefg = "slider_fg"
			}
			local Item = form.sliders[layout.elements[i].tag]
			Item.tag = Tag
		elseif (layout.elements[i].control == "radio") then
			local Tag = layout.elements[i].tag

			local Form_Radio_Layout = {
				spacing = elementWidth / table.getn(layout.elements[i].values),
				font = layout.font,
				strings = layout.elements[i].values,
				callback = layout.elements[i].fnChanged,
				x = elementWidth * 0.1,
				y = form.buttons[layout.elements[i].tag].y,
				--y = -2 * layout.yHeight,
			}
			ifelem_AddRadioButtonGroup(form, Form_Radio_Layout.x, Form_Radio_Layout.y, Form_Radio_Layout, layout.elements[i].tag)
			local Item = form.radiobuttons[layout.elements[i].tag]
			Item.tag = Tag

		elseif (layout.elements[i].control == "dropdown") then
			local Tag = layout.elements[i].tag
			local Form_ListBox_Layout = {
				showcount = 10,
				yHeight = ScriptCB_GetFontHeight(layout.font) + 8,
				ySpacing  = 0,
				width = elementWidth * 1.05,
				flashy = 0,
				CreateFn = Form_ListBox_CreateItem,
				PopulateFn = Form_ListBox_PopulateItem,
				font = layout.font,
				halign = "left",
				slider = 1,
				ZPos = 90,
			}
			
			local count = table.getn(layout.elements[i].values)
			if( count > 0 and count < Form_ListBox_Layout.showcount ) then
				Form_ListBox_Layout.showcount = count
				Form_ListBox_Layout.slider = nil
			end
			
			local dropdown = {}
			local listboxheight = Form_ListBox_Layout.showcount * (Form_ListBox_Layout.yHeight + Form_ListBox_Layout.ySpacing) + 30

			dropdown.listbox = NewButtonWindow {
				x=elementWidth * 0.5, y = form.buttons[layout.elements[i].tag].y + listboxheight/2 + 5,
				width = Form_ListBox_Layout.width,
				height = listboxheight,
				font = Form_ListBox_Layout.font,
				halign = Form_ListBox_Layout.halign,
				tag = "list_" .. layout.elements[i].tag,
				bg_texture = "border_dropdown",
			}
			-- button windows have a default z of 135
			-- put the button a little bit behind it.
			dropdown.button = NewPCDropDownButton {
				x = Form_ListBox_Layout.width/2, y = form.buttons[layout.elements[i].tag].y,
				btnw = Form_ListBox_Layout.width,
				btnh = 15,
				font = Form_ListBox_Layout.font,
				halign = Form_ListBox_Layout.halign,
				tag = "button_" .. layout.elements[i].tag,
				string = "",
			}
			Form_ListBox_Layout.width = elementWidth * 0.9
			ListManager_fnInitList(dropdown.listbox, Form_ListBox_Layout)
			dropdown.expanded = false
			dropdown.tag = layout.elements[i].tag
			local index = form.elements[layout.elements[i].tag].selValue;
			Form_ListBox_Layout.SelectedIdx = index
			Form_ListBox_Layout.CursorIdx = index
			Form_ListBox_Layout.FirstShownIdx = index
			ListManager_fnFillContents(dropdown.listbox,layout.elements[i].values or {},Form_ListBox_Layout)
			IFObj_fnSetVis(dropdown.listbox,nil)
			form.dropdowns[layout.elements[i].tag] = dropdown
		end
	end
	
	-- fix zordering on all the dropdowns.
	for key, dropdown in pairs(form.elements) do
		if(type(dropdown) == "table" and form.elements[key].control == "dropdown" ) then
			local i = form.buttons[key].y / 600 * 255
			IFObj_fnSetZPos(form.dropdowns[key], i)
		end
	end

	container.form = form
	Form_SetValues(container.form)

end
