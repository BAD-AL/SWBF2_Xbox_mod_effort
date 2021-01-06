--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Shell screen for the instant side. Picks the side, then launches.

ifs_instant_side = NewIFShellScreen {
	bNohelptext = 1, -- No buttons possible on this screen
	movieIntro      = nil,
	movieBackground = nil,

-- 	launching = NewIFText {
-- 		string = "common.launching",
-- 		font = "gamefont_large",
-- 		textw = 460,
-- 		ScreenRelativeX = 0.5, -- center
-- 		ScreenRelativeY = 0.5, -- center
-- 	},

-- 	Update = function(this, fDt)
-- 		gIFShellScreenTemplate_fnUpdate(this, fDt) -- do default behavior

-- 		if(this.delay) then
-- 			this.delay = this.delay - fDt -- update delay
-- 			if (this.delay < 0) then

-- 			end
-- 		end -- this.delay exists
-- 	end,
	
	Enter = function(this,bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- do default behavior
		if(bFwd) then
			-- No fade, just launch this thing
			ifelem_shellscreen_fnStopMovie()
			ScriptCB_SetTeamNames(ifs_missionselect.Team1Name,ifs_missionselect.Team2Name)
			-- Assume that the missionselect screen pushed in entries
			ScriptCB_EnterMission()
		end
		
		assert(ifs_missionselect.SelectedMap)
	end,

	-- Ignore inputs; we're going to launch no matter what they press.

	Input_Accept = function(this)
	end,
	Input_Back = function(this)
	end,
	Input_GeneralUp = function(this)
	end,
	Input_GeneralDown = function(this)
	end,
	Input_GeneralLeft = function(this)
	end,
	Input_GeneralRight = function(this)
	end,
}

AddIFScreen(ifs_instant_side,"ifs_instant_side")