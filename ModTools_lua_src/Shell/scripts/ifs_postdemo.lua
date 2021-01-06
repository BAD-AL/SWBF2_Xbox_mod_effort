--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


-- Screens to show, with time per screen
gPostdemoScreenList = {
	{ texture = "postdemo1", time = 6, bSkippable = 1,},
	{ texture = "postdemo2", time = 6, bSkippable = 1,},
	{ texture = "postdemo3", time = 6, bSkippable = 1,},
	{ texture = "postdemo4", time = 6, bSkippable = 1,},
}


ifs_postdemo = NewIFShellScreen {
	-- # of seconds before we go into demomode. XBox TCR C1-6 says
	-- this must be no larger than 120 seconds
	Timer = 0, -- how long the current page has before it's advanced
	OnPage = 0, -- start before first page
	nologo = 1,
	bNohelptext = 1,
	movieIntro      = nil,
	movieBackground = nil,

	ShowTexture = NewIFImage { 
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.5,
		UseSafezone = 0,

		texture = "opaque_black", 
		-- Size, UVs aren't fully specified here, but in NewIFShellScreen()
	},

	ShowTexture2 = NewIFImage { 
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.5,
		UseSafezone = 0,

		ZPos = 120, -- a bit in front of the other texture

		texture = "opaque_black", 
		-- Size, UVs aren't fully specified here, but in NewIFShellScreen()
	},

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd)
--		ifelem_shellscreen_fnStopMovie() -- Ensure it's off
		ScriptCB_ReadAllControllers(1,1,1) -- auto-bind all, never complain about missing
	end,

	Update = function(this, fDt)
		-- Call base class functionality
		gIFShellScreenTemplate_fnUpdate(this, fDt)

		this.Timer = this.Timer - fDt
		if(this.Timer < 0) then
			this.OnPage = this.OnPage + 1

			-- Advance to next screen
			if(this.OnPage > table.getn(gPostdemoScreenList)) then
				if(gXBox_DVDDemo) then
					-- Back to the DVD-or-game screen
					ScriptCB_PopScreen()
				else
					ScriptCB_QuitToWindows()
				end
			else
				if(this.OnPage > 1) then
					IFImage_fnSetTexture(this.ShowTexture, gPostdemoScreenList[this.OnPage - 1].texture)
				end

				IFImage_fnSetTexture(this.ShowTexture2, gPostdemoScreenList[this.OnPage].texture)
				AnimationMgr_AddAnimation(this.ShowTexture , { fTotalTime = 0.25, fStartAlpha = 1, fEndAlpha = 0,})
				AnimationMgr_AddAnimation(this.ShowTexture2, { fTotalTime = 0.4, fStartAlpha = 0, fEndAlpha = 1,})

				this.Timer = gPostdemoScreenList[this.OnPage].time
			end
		end
	end,

	-- Start actually works on this screen
	Input_Start = function(this)
	end,

	-- Overrides for most input handlers, as we want to do nothing
	-- when this happens on this screen.
	Input_Accept = function(this)
		if(this.OnPage <= table.getn(gPostdemoScreenList)) then
			if(gPostdemoScreenList[this.OnPage].bSkippable) then
				this.Timer = 0 -- Time out this screen
			end -- could skip
		end
	end,
	Input_Back = function(this)
--		this.Timer = 0
  end,
	Input_GeneralLeft = function(this)
	end,
	Input_GeneralRight = function(this)
	end,
	Input_GeneralUp = function(this)
	end,
	Input_GeneralDown = function(this)
	end,
}

function ifs_postdemo_fnBuildScreen(this)
	-- Ask game for screen size, fill in values
	local w, h, v, widescreen
	w,h,v,widescreen=ScriptCB_GetScreenInfo()
	this.ShowTexture.localpos_l =-w*0.5
	this.ShowTexture.localpos_t =-h*0.5
	this.ShowTexture.localpos_r = w*0.5 
	this.ShowTexture.localpos_b = h*0.5
	this.ShowTexture.uvs_b = v
	this.ShowTexture2.localpos_l =-w*0.5
	this.ShowTexture2.localpos_t =-h*0.5
	this.ShowTexture2.localpos_r = w*0.5 
	this.ShowTexture2.localpos_b = h*0.5
	this.ShowTexture2.uvs_b = v
end

ifs_postdemo_fnBuildScreen(ifs_postdemo) -- programatic chunks
ifs_postdemo_fnBuildScreen = nil
AddIFScreen(ifs_postdemo,"ifs_postdemo")
