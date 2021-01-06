--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


ifs_difficulty = NewIFShellScreen {
	nologo = 1,
--	bg_texture = "iface_bgmeta_space",
	movieIntro      = nil,
	movieBackground = nil,
	bAcceptIsSelect = 1,


--	bg2 = NewIFImage { 
--		ScreenRelativeX = 0,
--		ScreenRelativeY = 0,
--		UseSafezone = 0,
--		ZPos = 255, -- behind all.
--		texture = "iface_bgmeta_space", 
--		localpos_l = 0,
--		localpos_t = 0,
--		-- Size, UVs aren't fully specified here, but in NewIFShellScreen()
--		inert = 1, -- Delete this out of lua once created (we'll never touch it again)
--	},

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = gDefaultButtonScreenRelativeY, -- center
	},

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function

		-- Resize buttons to be minimal width
		this.CurButton = ShowHideVerticalButtons(this.buttons,ifs_difficulty_vbutton_layout)
		this.CurButton = string.format("%d",ScriptCB_GetDifficulty())
		SetCurButton(this.CurButton)

		--IFObj_fnSetVis(this.bg2,not gCurMovie)
	end,
	
	Exit = function(this, bFwd)
		-- hack
		-- if we're backing out of here in the initial profile creation screen, we've already
		-- created a profile and logged in with it, but we need to destroy it since we're canceling.
		if((not bFwd) and this.LogoutOnCancel) then
			print("ifs_difficulty.Exit LogoutOnCancel")
			ScriptCB_Logout()
		end
		this.LogoutOnCancel = nil
	end,

	Input_Accept = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		if(this.CurButton) then
			ScriptCB_SetDifficulty(this.CurButton, true)
			this.fnDone()
		end
	end,
}

ifs_difficulty_vbutton_layout = {
	xWidth = 460, -- German has a HUGE title  - NM 6/25/04
	width = 460,
	--xSpacing = 10,
	ySpacing = 5,
	font = gMenuButtonFont,
	buttonlist = { 
--		{ tag = "1", string = "ifs.difficulty.easy", },
		{ tag = "2", string = "ifs.difficulty.medium", },
		{ tag = "3", string = "ifs.difficulty.hard", },
	},
	title = "ifs.difficulty.title",
}

function ifs_difficulty_fnBuildScreen(this)
	this.CurButton = AddVerticalButtons(this.buttons,ifs_difficulty_vbutton_layout)
	--local r
	--local b
	--local v
	--r,b,v=ScriptCB_GetScreenInfo()
	--this.bg2.localpos_r = r
	--this.bg2.localpos_b = b
	--this.bg2.uvs_b = v
end

ifs_difficulty_fnBuildScreen(ifs_difficulty)
ifs_difficulty_fnBuildScreen = nil

AddIFScreen(ifs_difficulty,"ifs_difficulty")