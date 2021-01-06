--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- the in game stat screen.  this doesn't do anything, its just a drop in replacement
-- for the old stats that will bail immediately.

ifs_stats = NewIFShellScreen {
	nologo = 1,
	bNohelptext = 1,	
	
	movieIntro      = nil, -- played before the screen is displayed
	movieBackground = nil, -- played while the screen is displayed

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd)
		-- bail right away
		ScriptCB_QuitFromStats()
	end,

	Input_GeneralUp = function(this)
	end,
	Input_GeneralDown = function(this)
	end,
	Input_GeneralLeft = function(this)
	end,
	Input_GeneralRight = function(this)
	end,
	Input_LTrigger = function(this)
	end,
	Input_RTrigger = function(this)
	end,
}

AddIFScreen(ifs_stats,"ifs_stats")
