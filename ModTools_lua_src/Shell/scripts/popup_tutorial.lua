--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- General handler for a "Tutorial" dialog

local w,h = ScriptCB_GetSafeScreenInfo()

if gPlatformStr == "PC" then
	TutorialButton_layout = {
 		yTop = 0,
		width = 300,
		xWidth = w / 8,
		font = gPopupButtonFont,
		allTitles = true,
		itemStyle = true,
		buttonlist = { 
			{ tag = "back", string = "common.back", },
			{ tag = "ok", string = "common.ok", },
			{ tag = "next", string = "common.next", },
		},
	--	nocreatebackground = 1,
	}
else
	TutorialButton_layout = OkButton_layout
end

Popup_Tutorial = NewPopup {
	ScreenRelativeX = 0.5, -- centered onscreen
	ScreenRelativeY = 0.35,
	height = h * .4,
	width = w,
	ZPos = 1, -- Error popup (i.e. controller missing) needs to be at ZPos 0; this must be behind it - NM 8/21/05
	ButtonHeightHint = 50,
	Texture = "opaque_rect",

	title = NewIFText {
		font = gPopupTextFont,
--		textw = 220,
--		texth = 120,
		y2 = -80,
		flashy=0,
	},

	buttons = NewIFContainer {
		y = h * .4 - 20,
	},

	SetPage = function(this, page)
		-- set the text page
		this.textPage = page
		
		-- update title
		gPopup_fnSetTitleStr(this, this.textList[this.textPage])
		
		-- set button visibility
		IFObj_fnSetVis(this.buttons.back, this.textPage > 1)
		IFObj_fnSetVis(this.buttons.next, this.textPage < table.getn(this.textList))
	end,
	
	fnActivate = function (this,vis)
		this:fnDefaultActivate(vis)
		if(vis) then
			ShowHideHorizontalButtons(this.buttons,TutorialButton_layout)

			this:SetPage(1)
			
			-- 1 button, it's selected, hilighted, etc
			this.CurButton = "ok"
			IFButton_fnSelect(this.buttons[this.CurButton],1)
			gCurHiliteButton = this.buttons[this.CurButton]
		end
	end,
	
	Input_Accept = function(this, iJoystick)
		if gPlatformStr == "PC" then
			if this.CurButton == "ok" then
				-- fall through
			elseif this.CurButton == "back" then
				this:Input_GeneralLeft(iJoystick)
				return
			elseif this.CurButton == "next" then
				this:Input_GeneralRight(iJoystick)
				return
			else
				return
			end
		end

		-- Default: hide this.
		this:fnActivate(nil)

		-- Call callback if applicable, w/ result (nil = no, other = yes)
		ifelm_shellscreen_fnPlaySound("shell_menu_accept")
		if(this.fnDone) then
			this.fnDone()
		end
	end,

	Input_Back = gPopup_Tutorial_fnInput_Accept,
	
	Input_GeneralLeft = function(this, iJoystick)
		if this.textPage > 1 then
			ScriptCB_SndPlaySound("shell_select_change")
			this:SetPage(this.textPage - 1)
		end
	end,
	
	Input_GeneralRight = function(this, iJoystick)
		if this.textPage < table.getn(this.textList) then
			ScriptCB_SndPlaySound("shell_select_change")
			this:SetPage(this.textPage + 1)
		end
	end,
}

AddHorizontalButtons(Popup_Tutorial.buttons,TutorialButton_layout)
Popup_Tutorial.buttons.x2 = Popup_Tutorial.buttons.x
Popup_Tutorial.buttons.TagOfFirst = "ok"

gButtonWindow_fnSetTexture(Popup_Tutorial,"opaque_rect")
CreatePopupInC(Popup_Tutorial,"Popup_Tutorial")
Popup_Tutorial = DoPostDelete(Popup_Tutorial)
