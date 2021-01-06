
function ifs_dvdorgame_fnSetHilight(this)
	local TextOnAlpha = 1.0
	local TextOffAlpha = 0.5

	if(this.CurButton == "game") then
		IFObj_fnSetAlpha(this.text1,TextOffAlpha)
		IFObj_fnSetAlpha(this.text2,TextOnAlpha)
		IFObj_fnSetVis(this.bar1,nil)
		IFObj_fnSetVis(this.bar2,1)
	else
		IFObj_fnSetAlpha(this.text1,TextOnAlpha)
		IFObj_fnSetAlpha(this.text2,TextOffAlpha)
		IFObj_fnSetVis(this.bar1,1)
		IFObj_fnSetVis(this.bar2,nil)
	end

	this:Update(0) -- force a button highlight update

--	print("CurButton = ", this.CurButton)
end

ifs_dvdorgame = NewIFShellScreen {
	nologo = 1,
	bg_texture = "DVDBoot",
	bNohelptext = 1,

	bar1 = NewIFImage { 
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 210 / 480,
		UseSafezone = 0,
		ZPos = 250, -- behind most (except text)

		texture = "DVDBoot_Bar1", 
		localpos_l = 0,
		localpos_t = 0,
		localpos_r = 640,
		localpos_b = 240,
	},

	text1 = NewIFImage { 
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 210/480,
		UseSafezone = 0,
		ZPos = 240, -- in front of bars

		texture = "DVDBoot_Text1",
		localpos_l = 0,
		localpos_t = 0,
		localpos_r = 640,
		localpos_b = 240,
	},

	bar2 = NewIFImage { 
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 210/480,
		UseSafezone = 0,
		ZPos = 250,  -- behind most (except text)

		texture = "DVDBoot_Bar2", 
		localpos_l = 0,
		localpos_t = 0,
		localpos_r = 640,
		localpos_b = 240,
	},

	text2 = NewIFImage { 
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 210/480,
		UseSafezone = 0,
		ZPos = 240, -- in front of bars

		texture = "DVDBoot_Text2",
		localpos_l = 0,
		localpos_t = 0,
		localpos_r = 640,
		localpos_b = 240,
	},

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd)
		
		-- this test to see if the game is starting for the first time if so
		-- then skip the dvd or game screen and move on to the legal screen
		if(bFwd and (not ScriptCB_ShouldShowLegal())) then
			ScriptCB_SetIFScreen("ifs_legal")
		end

		-- If we need to show the ad screens, do so.
		if(bFwd and ScriptCB_ShouldShowDemoPostscreen()) then
			ifs_movietrans_PushScreen(ifs_postdemo)
		end

		this.CurButton = "dvd"
		ifs_dvdorgame_fnSetHilight(this)
		ScriptCB_ReadAllControllers(1,1,1)
	
	end,

	Input_Accept = function(this) 
		if(this.CurButton == "game") then
			ScriptCB_UnbindController(-1) -- all controllers
			ScriptCB_ReadAllControllers(nil)
			ifs_movietrans_PushScreen(ifs_legal)
		elseif (this.CurButton == "dvd") then
			ScriptCB_XB_LaunchDVDContent()
		end
	end,

	Input_GeneralUp = function(this)
		if(this.CurButton == "game") then
			this.CurButton = "dvd"
		else
			this.CurButton = "game"
		end
		ScriptCB_SndPlaySound("shell_select_change")
		ifs_dvdorgame_fnSetHilight(this)
	end,

	Input_GeneralDown = function(this)
		if(this.CurButton == "game") then
			this.CurButton = "dvd"
		else
			this.CurButton = "game"
		end
		ScriptCB_SndPlaySound("shell_select_change")
		ifs_dvdorgame_fnSetHilight(this)
	end,

	Input_GeneralLeft = function(this)
	end,
	Input_GeneralRight = function(this)
	end,

	Input_Back = function(this) 
	end,

	Update = function(this, fDt)
		-- Call base class functionality
		gIFShellScreenTemplate_fnUpdate(this, fDt)

 		gButton_CurSizeAdd = gButton_CurSizeAdd + fDt * gButton_CurDir * 0.333333
		if(gButton_CurSizeAdd > 1) then
 			gButton_CurSizeAdd = 1
			gButton_CurDir = -math.abs(gButton_CurDir)
		elseif (gButton_CurSizeAdd < 0.5) then
 			gButton_CurSizeAdd = 0.5
			gButton_CurDir = math.abs(gButton_CurDir)
		end

		if(this.CurButton == "game") then
			IFObj_fnSetAlpha(this.bar2,gButton_CurSizeAdd)
		else
			IFObj_fnSetAlpha(this.bar1,gButton_CurSizeAdd)
		end
	end,
}


function ifs_dvdorgame_fnBuildScreen(this)
	-- Ask game for screen size, fill in values
	local w, h, v, widescreen
	w,h,v,widescreen=ScriptCB_GetScreenInfo()

	this.bar1.localpos_l =-w*0.5
--	this.bar1.localpos_t =-h*0.5
	this.bar1.localpos_r = w*0.5 
--	this.bar1.localpos_b = h*0.5
	this.bar1.uvs_b = v

	this.bar2.localpos_l =-w*0.5
--	this.bar2.localpos_t =-h*0.5
	this.bar2.localpos_r = w*0.5 
--	this.bar2.localpos_b = h*0.5
	this.bar2.uvs_b = v

	this.text1.localpos_l =-w*0.5
--	this.text1.localpos_t =-h*0.5
	this.text1.localpos_r = w*0.5 
--	this.text1.localpos_b = h*0.5
	this.text1.uvs_b = v

	this.text2.localpos_l =-w*0.5
--	this.text2.localpos_t =-h*0.5
	this.text2.localpos_r = w*0.5 
--	this.text2.localpos_b = h*0.5
	this.text2.uvs_b = v

end

ifs_dvdorgame_fnBuildScreen(ifs_dvdorgame) -- programatic chunks
ifs_dvdorgame_fnBuildScreen = nil

AddIFScreen(ifs_dvdorgame,"ifs_dvdorgame")