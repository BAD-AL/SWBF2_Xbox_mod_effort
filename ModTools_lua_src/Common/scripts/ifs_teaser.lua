
ifs_teaser = NewIFShellScreen {
	MAX_SCREENS = 1, -- Dell, adjust this to the max # of screens

	fMIN_SCREEN_TIME = 6.0,
	fMAX_SCREEN_TIME = 30.0,

	fCurTime = 0, -- updated.
	nologo = 1,
	bNohelptext_back = 1,
	bFromStats = nil,

	ShowTexture = NewIFImage { 
		ZPos = 250,
		ScreenRelativeX = 0,
		ScreenRelativeY = 0,
		UseSafezone = 0,

		texture = "teaser1",
		localpos_l = 0,
		localpos_t = 0,
		-- Size, UVs aren't fully specified here, but in NewIFShellScreen()
	},

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd)

		this.fCurTime = 0
		IFObj_fnSetVis(this.Helptext_Accept,nil)
	end,

	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt) -- do default behavior

		this.fCurTime = this.fCurTime + fDt

 		if(this.fCurTime > this.fMIN_SCREEN_TIME) then
			IFObj_fnSetVis(this.Helptext_Accept, 1);
 		end

		if(this.fCurTime > this.fMAX_SCREEN_TIME) then
			ScriptCB_QuitFromStats()
--			this:Input_Accept() -- fake a button press
		end
	end,

	-- Overrides for most input handlers, as we want to do nothing
	-- when this happens on this screen.
	Input_Accept = function(this)
 		if(this.fCurTime > this.fMIN_SCREEN_TIME) then
			if(gPlatformStr == "XBox") then
	 			ScriptCB_QuitFromStats()
			else
				if (ScriptCB_GetShellActive()) then
					ScriptCB_QuitFromStats()
				else
					ScriptCB_QuitToShell()
				end
			end
		else
			print("Too soon! ",this.fCurTime , this.fMIN_SCREEN_TIME)
 		end
	end,

	Input_Back = function(this)
	end,

	-- Override default handlers, do nothing.
	Input_GeneralLeft = function(this)
	end,
	Input_GeneralRight = function(this)
	end,
	Input_GeneralUp = function(this)
	end,
	Input_GeneralDown = function(this)
	end,
}

function ifs_teaser_fnBuildScreen(this)
	-- Ask game for screen size, fill in values
	local r
	local b
	local v
	r,b,v=ScriptCB_GetScreenInfo()
	this.ShowTexture.localpos_r = r
	this.ShowTexture.localpos_b = b
	this.ShowTexture.uvs_b = v

	if (this.Helptext_Accept) then
		IFText_fnSetString(this.Helptext_Accept.helpstr,"ifs.stats.done")
	end
end

ifs_teaser_fnBuildScreen(ifs_teaser) -- programatic chunks
ifs_teaser_fnBuildScreen = nil
AddIFScreen(ifs_teaser,"ifs_teaser")