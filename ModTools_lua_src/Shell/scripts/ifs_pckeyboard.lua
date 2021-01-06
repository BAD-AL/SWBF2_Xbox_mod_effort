--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_keyboard_layout = {
--	yTop = -70,
	xWidth = 350,	
	width = 350,
	xSpacing = 10,
	yHeight = 50,
	ySpacing = 0,
	font = "gamefont_large",
	title = "Enter New Name",
	--flashy = 0,
	buttonlist = { 
		{ tag = "inputstr", string = "enter text here", },
	},
}

function ifs_kb_fnBuildScreen(this)
	local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen

	this.cancelButtonContainer = NewIFContainer {
		ScreenRelativeX = 0.0, -- left
		ScreenRelativeY = 1.0, -- bottom
		y = -20, -- go slightly down from center
		x = 20
	}

	this.cancelButtonContainer.TextCancel = NewRoundIFButton {
			y = 0, 
			btnw = w*.2, 
			btnh = h*.1,
			font = "gamefont_Large", 
			--bg_flipped = flipped, 
			startdelay = 1*0.1, 
			bg_width = w*.2, 
			tag = "Cancel",
			bInertPos = 1,
	}
	RoundIFButtonLabel_fnSetString(this.cancelButtonContainer.TextCancel, "common.cancel")
	this.cancelButtonContainer.TextCancel.label.bHotspot = 1
	this.cancelButtonContainer.TextCancel.label.fHotspotW = this.cancelButtonContainer.TextCancel.btnw
	this.cancelButtonContainer.TextCancel.label.fHotspotH = this.cancelButtonContainer.TextCancel.btnh

	this.okButtonContainer = NewIFContainer {
		ScreenRelativeX = 1.0, -- right
		ScreenRelativeY = 1.0, -- bottom
		y = -20, -- go slightly down from center
		x = -w*.2
	}

	this.okButtonContainer.TextOk = NewRoundIFButton  
	{	
			y = 0, 
			btnw = w*.2, 
			btnh = h*.1,
			font = "gamefont_Large", 
			--bg_flipped = flipped, 
			startdelay = 1*0.1, 
			bg_width = w*.2, 
			tag = "Ok",
			bInertPos = 1,
	}
	RoundIFButtonLabel_fnSetString(this.okButtonContainer.TextOk, "common.ok")
	this.okButtonContainer.TextOk.label.bHotspot = 1
	this.okButtonContainer.TextOk.label.fHotspotW = this.okButtonContainer.TextOk.btnw
	this.okButtonContainer.TextOk.label.fHotspotH = this.okButtonContainer.TextOk.btnh

	this.InputWindow = NewButtonWindow { ZPos = 200,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- middle of screen
		width = 300,
		height = 60,
	}
	
	this.InputWindow.InputText = NewIFText --
	{
		
		
			x = 300 * -0.5, 
			y = 60 * -0.5, 
			font ="gamefont_large", 
			halign = "hcenter",
			valign = "vcenter",
			--halign = "left",
			--valign = "top",
			textw = 300 , -- usable area for text
			texth = 60  ,
			ColorR = 255, ColorG = 255, ColorB = 255, -- white
			flashy = 0,
	}
	
	this.InputWindow.InputTextTitle = NewIFText --
	{
		
		
			x = 300 * -0.5 - 43, 
			y = 60 * -0.5 - 45, 
			font ="gamefont_large", 
			halign = "hcenter",
			valign = "vcenter",
			--halign = "left",
			--valign = "top",
			textw = 300 , -- usable area for text
			texth = 60  ,
			--ColorR = 255, ColorG = 255, ColorB = 255, -- white
			flashy = 1,
			string = "ifs.pckeyboard.entername"
	}
		


	--this.InputWindow.InputText = NewRoundIFButton
--	{	
--			y = 0, 
--			btnw = 300, 
--			btnh = 60,
--			font = "gamefont_large", 
--			--bg_flipped = flipped, 
--			--startdelay = 1*0.1, 
--			--bg_width = w*.2, 
--			tag = "InputStr",
--			bInertPos = 1,
--	}
	
end


ifs_kb = NewIFShellScreen {
	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- top
		y = 20, -- go slightly down from center
	},
	
	Input_GeneralLeft = function(this,bFromAI)
		if( gKeyInput == 0) then
			print("Input_Left")
			--SetCurButton( "Cancel")
			SetCurButtonTable(this.cancelButtonContainer.TextCancel)
		end
	end,
	Input_GeneralRight = function(this,bFromAI)
		if( gKeyInput == 0) then
			print("Input_Right")
			--SetCurButton( "Ok")
			SetCurButtonTable(this.okButtonContainer.TextOk)
		end
	end,
	Input_GeneralUp = function(this,bFromAI)
		if( gKeyInput == 0) then
			SetCurButton(nil)
			local newstring = ScriptCB_UnicodeStrCat( ifs_vkeyboard.CurString , ScriptCB_tounicode( "_" ) )
			--RoundIFButtonLabel_fnSetUString(this.InputWindow.InputText,newstring)
			IFText_fnSetUString(this.InputWindow.InputText,newstring)
			gKeyInput = 1
		end
	end,
	Input_GeneralDown = function(this,bFromAI)
	end,

	Update = function(this, fDt)
		if( gKeyInput == 1 ) then
			local beforestring = ifs_vkeyboard.CurString
			ifs_vkeyboard.CurString = ScriptCB_GetKeyInput( ifs_vkeyboard.CurString )
			if ( ifs_vkeyboard.CurString ~= beforestring ) then
				local newstring = ScriptCB_UnicodeStrCat( ifs_vkeyboard.CurString , ScriptCB_tounicode( "_" ) )
				--RoundIFButtonLabel_fnSetUString(this.InputWindow.InputText,newstring)
				IFText_fnSetUString(this.InputWindow.InputText,newstring)
			end
		else
			--RoundIFButtonLabel_fnSetUString(this.InputWindow.InputText,ifs_vkeyboard.CurString) 
			IFText_fnSetUString(this.InputWindow.InputText,ifs_vkeyboard.CurString)
		end 
			
		gIFShellScreenTemplate_fnUpdate(this, fDt) -- do default behavior
	end,

	Enter = function(this, bFwd)
		--the gEnterInput variable is used to determine whether the focus is on the inputstr box (slightly different then highlite)
		gKeyInput = 1
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		--ShowHideVerticalButtons(this.buttons,ifs_keyboard_layout)
		print("ifs_vkeyboard.CurString:",ifs_vkeyboard.CurString )
		--RoundIFButtonLabel_fnSetUString(this.InputWindow.InputText,ifs_vkeyboard.CurString )
		local newstring = ScriptCB_UnicodeStrCat( ifs_vkeyboard.CurString , ScriptCB_tounicode( "_" ) )
		IFText_fnSetUString(this.InputWindow.InputText,newstring)
		--print("<Enter>:ifs_kb.buttons[inputstr].string:",ifs_kb.buttons["inputstr"].label)
		this.CurButton = "inputstr"
		
		
	end,

	Input_Back = function(this)
		--overridden
	end,

	Input_Accept = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		if(this.CurButton == "Cancel") then
--			this.Input_Back(this)
			ScriptCB_PopScreen()
		elseif (this.CurButton == "Ok") then
			--print("PrintMSG 0")
			--print("<Accept>:ifs_kb.buttons[inputstr].string:",ifs_kb.buttons["inputstr"].string)
			--ifs_vkeyboard.CurString = 	ifs_kb.buttons["inputstr"].label
			--gKBString = ifs_kb.buttons["inputstr"].string
			
			ScriptCB_SndPlaySound("shell_menu_ok")
			
			--print("PrintMSG 1")
			print("ifs_vkeyboard.CurString",ifs_vkeyboard.CurString)
			if (gKeyInput == 1) then
				gKeyInput = 0
				IFText_fnSetUString(this.InputWindow.InputText,ifs_vkeyboard.CurString )
			end
			print(ifs_vkeyboard.CurString)
			local bCanAccept,ErrStr = vkeyboard_specs.fnIsOk()
			--print("PrintMSG 2")
			if (bCanAccept) then
				vkeyboard_specs.fnDone()
			else
				ifs_vkeyboard_fnSetPieceVis(this,nil)
				Popup_Ok.fnDone = ifs_vkeyboard_fnErrOk
				Popup_Ok:fnActivate(1)
				gPopup_fnSetTitleStr(Popup_Ok, ErrStr)
			end
			--print("PrintMSG 3")
		else --They aren't on either of those two buttons, toggle of key input
			if (gKeyInput == 1) then
				gKeyInput = 0
				IFText_fnSetUString(this.InputWindow.InputText,ifs_vkeyboard.CurString )
			else
				local newstring = ScriptCB_UnicodeStrCat( ifs_vkeyboard.CurString , ScriptCB_tounicode( "_" ) )
				--RoundIFButtonLabel_fnSetUString(this.InputWindow.InputText,newstring)
				IFText_fnSetUString(this.InputWindow.InputText,newstring)
				gKeyInput = 1
			end
			
			print("NewKeyInputVal=",gKeyInput)
		end
		
	end,
}

ifs_kb_fnBuildScreen(ifs_kb)
--ifs_kb.CurButton = AddVerticalButtons(ifs_kb.buttons,ifs_keyboard_layout)
AddIFScreen(ifs_kb,"ifs_kb")
ifs_kb_fnBuildScreen = nil