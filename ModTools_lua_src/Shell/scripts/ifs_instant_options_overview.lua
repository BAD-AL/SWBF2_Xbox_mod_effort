--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_ioo_OptionButton_layout = {
	xWidth = 305,
	width = 305,
	font = gMenuButtonFont,
   title = "ifs.instantoptions.title",
   buttonlist = {
      { tag = "global", string = "ifs.instantoptions.buttons.global" },
      { tag = "host", string = "ifs.instantoptions.buttons.host" },
      { tag = "hero", string = "ifs.instantoptions.buttons.hero" },
      { tag = "conquest", string = "ifs.instantoptions.buttons.conquest" },
      { tag = "ctf", string = "ifs.instantoptions.buttons.ctf" },
      { tag = "hunt", string = "ifs.instantoptions.buttons.hunt" },
      { tag = "assault", string = "ifs.instantoptions.buttons.assault" },
   },
}


ifs_instant_options_overview = NewIFShellScreen {
	bAcceptIsSelect = 1,
   movieBackground = "shell_sub_left",

   buttons = NewIFContainer {
      ScreenRelativeX = 0.5, -- center
      ScreenRelativeY = gDefaultButtonScreenRelativeY,
   },

   Enter = function(this, bFwd)
	      gIFShellScreenTemplate_fnEnter(this, bFwd) -- call base class
				this.buttons.host.hidden = not ifs_missionselect.bForMP
				this.CurButton = ShowHideVerticalButtons(this.buttons, ifs_ioo_OptionButton_layout)
	      SetCurButton(this.CurButton)
	   end,

   Input_Accept = function(this)
		     --set options based on this.CurOption
		     ifs_instant_options_SetOptionGroup(this.CurButton)
		     ifelm_shellscreen_fnPlaySound(this.acceptSound)
		     ifs_movietrans_PushScreen(ifs_instant_options)
		  end,

   Input_Back = function(this)
		   ScriptCB_PopScreen()
		end,

}

function ifs_instant_options_overview_fnBuildScreen(this)
   this.CurButton = AddVerticalButtons(this.buttons, ifs_ioo_OptionButton_layout)
end

ifs_instant_options_overview_fnBuildScreen(ifs_instant_options_overview)
ifs_instant_options_overview_fnBuildScreen = nil -- dump out of memory to save

AddIFScreen(ifs_instant_options_overview,"ifs_instant_options_overview")