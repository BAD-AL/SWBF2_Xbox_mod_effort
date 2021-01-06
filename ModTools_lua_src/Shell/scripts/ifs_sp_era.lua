--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

--function ifs_sp_era_fnDidDifficulty()
--	ScriptCB_SetIFScreen("ifs_sp_briefing")
--end

ifs_campaigns_vbutton_layout = {
--	yTop = -70,
	xWidth = 350,
	width = 350,
	xSpacing = 10,
	ySpacing = 5,
	font = gMenuButtonFont,
	buttonlist = { 
		{ tag = "c1", string = "ifs.sp.campaign1.title", },
		{ tag = "c2", string = "ifs.sp.campaign2.title", },
	},
	title = "ifs.sp.pick_campaign",
	--rotY = 35,
}

ifs_sp_era = NewIFShellScreen {
	bAcceptIsSelect = 1,
	movieIntro      = nil,
	movieBackground = nil,
    
--	title = NewIFText {
--		string = "ifs.sp.pick_era",
--		font = "gamefont_large",
--		textw = 460,
--		ScreenRelativeX = 0.5, -- center
--		ScreenRelativeY = 0.5, -- top
--	},

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = gDefaultButtonScreenRelativeY, -- center
	},

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function

		if(bFwd and ScriptCB_IsCampaignStateSaved()) then
			ifs_movietrans_PushScreen(ifs_sp_briefing)
		end

		if(bFwd) then
			this.CurButton = ShowHideVerticalButtons(this.buttons,ifs_campaigns_vbutton_layout)
		end
		SetCurButton(this.CurButton)
	end,

	Input_Accept = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		ifelm_shellscreen_fnPlaySound(this.acceptSound)
		ifs_sp_briefing.era = this.CurButton
		if( bFwd ) then
			ScriptCB_PushScreen("ifs_sp_briefing")
		else
			ifs_movietrans_PushScreen(ifs_sp_briefing)
		end
	end,
}


ifs_sp_era.CurButton = AddVerticalButtons(ifs_sp_era.buttons,ifs_campaigns_vbutton_layout)
AddIFScreen(ifs_sp_era,"ifs_sp_era")