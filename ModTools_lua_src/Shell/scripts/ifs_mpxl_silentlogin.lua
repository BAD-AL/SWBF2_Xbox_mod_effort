--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


ifs_mpxl_silentlogin = NewIFShellScreen {
	-- # of seconds before we go into demomode. XBox TCR C1-6 says
	-- this must be no larger than 120 seconds. 
	Demomode_Delay_DEFAULT = 100,

	-- Current value for the delay. This is reset to Demomode_Delay_DEFAULT on
	-- screen entry, and when it hits zero, it launches
	Demomode_Delay = 1, -- Stub value, replaced in :Enter()

	movieIntro      = nil,
	movieBackground = nil,

	bNohelptext = 1, -- turn off the bottom buttons

 	title = NewIFText {
 		string = "ifs.mp.silentlogin.title",
 		font = "gamefont_large",
 		textw = 460,
		texth = 200,
 		ScreenRelativeX = 0.5, -- center
 		ScreenRelativeY = 0.5, -- top
 		startdelay = 0.1,
		valign = "vcenter",
		nocreatebackground = 1,
	},

 	time = NewIFText {
-- 		string = "ifs.mp.silentlogin.title",
 		font = "gamefont_small",
 		textw = 460,
		texth = 200,
 		ScreenRelativeX = 0.5, -- center
 		ScreenRelativeY = 0.5, -- top
		y = 60,
 		startdelay = 0.5,
		nocreatebackground = 1,
	},

	Enter = function(this, bFwd)
		-- Always call base class functionality
		gIFShellScreenTemplate_fnEnter(this, bFwd)
		
		IFObj_fnSetVis(this.title,1)
		IFObj_fnSetVis(this.time,1)

		if(bFwd) then
			local bProceeding
			bProceeding = ScriptCB_XL_StartSilentLogin()
--			print("SilentLogin, bProceeding = ", bProceeding)

			if(bProceeding) then
				this.fDisplayTime = 1.5 + ScriptCB_random()*1.0
				this.fTotalTime = 0
			else
				-- Jump out of screen ASAP
				IFObj_fnSetVis(this.title,nil)
				IFObj_fnSetVis(this.time,nil)
				this.OnDone()
			end

		else
			ScriptCB_PopScreen()
		end


	end,

	fTotalTime = 0,
	fDisplayTime = 0.5,
	TitleAlpha = 1.0,
	TitleDir = -1.0,
	fControllerCheck = -1, -- force an update asap
	iLastControllers = -1,

	Update = function(this, fDt)
		-- Call base class functionality
		gIFShellScreenTemplate_fnUpdate(this, fDt)

		this.fTotalTime = this.fTotalTime + fDt
		local TimeUStr = ScriptCB_usprintf("ifs.busytime",
																			 ScriptCB_tounicode(string.format("%d",this.fTotalTime)))
		IFText_fnSetUString(this.time,TimeUStr)

		if(this.fTotalTime >= this.fDisplayTime) then
			if(ScriptCB_XL_IsSilentLoginDone()) then
				--ifs_movietrans_PushScreen(ifs_main)
				this.OnDone()
			end
		end
	end,

	-- Overrides for most input handlers, as we want to do nothing
	-- when this happens on this screen.
	Input_Accept = function(this) 
	end,
	Input_Start = function(this) 
	end,
	Input_Back = function(this) 
	end,
	Input_GeneralLeft = function(this,bFromAI)
	end,
	Input_GeneralRight = function(this,bFromAI)
	end,
	Input_GeneralUp = function(this,bFromAI)
	end,
	Input_GeneralDown = function(this,bFromAI)
	end,
}

AddIFScreen(ifs_mpxl_silentlogin,"ifs_mpxl_silentlogin")