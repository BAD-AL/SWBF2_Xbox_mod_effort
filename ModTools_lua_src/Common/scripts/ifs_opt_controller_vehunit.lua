--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Ps2 controller setup for Vehicle/Unit mode


-- Check  LuaCallbacks.cpp all the links of buttons described below to the corresponding enum is done in that file
--      Search for the      

gNumButtonFunctionsPerMode = 	20
gSquadCommandButtonFunction0 = 	99
gAnalogButtonFunction0 = 		17

gButtonNames = {		-- in the same as as the listing in ifs_opt_controller_common.lua
	"ifs.controls.buttons.ltrig2",		-- 1
	"ifs.controls.buttons.ltrig1",		-- 2
	"ifs.controls.buttons.dpadu",		-- 3
	"ifs.controls.buttons.dpadl",		-- 4
	"ifs.controls.buttons.dpadd",		-- 5
	"ifs.controls.buttons.dpadr",		-- 6
	"ifs.controls.buttons.lang",		-- 7
	"ifs.controls.buttons.bsel",		-- 8
	"ifs.controls.buttons.bstr",		-- 9
	"ifs.controls.buttons.rang",		-- 10
	"ifs.controls.buttons.bsqr",		-- 11
	"ifs.controls.buttons.bcrs",		-- 12
	"ifs.controls.buttons.bcir",		-- 13
	"ifs.controls.buttons.btri",		-- 14
	"ifs.controls.buttons.rtrig1",		-- 15
	"ifs.controls.buttons.rtrig2",		-- 16
	"ifs.controls.buttons.yflip",		-- 17 -- not used
	"ifs.controls.buttons.l3",			-- 18
	"ifs.controls.buttons.r3",			-- 19
	"ifs.controls.buttons.lookslidey",	-- 20
	"ifs.controls.buttons.reset",		-- 21 -- not used
	"ifs.controls.buttons.lookslidex"	-- 22
}

gButtonFunctionStrings = {
	-- GLOBAL_FUNCTION_LABEL (index implies Function_ID)
	--INFANTRY LINGO	(add gNumButtonFunctionsPerMode*0)
	"ifs.controls.General.Sprint",				-- 1
	"ifs.controls.General.Crouch",				-- 2
	"ifs.controls.General.Jump",				-- 3 
	"ifs.controls.General.Primary",				-- 4
	"ifs.controls.General.Secondary",			-- 5
	"ifs.controls.General.PrimaryNext",			-- 6
	"ifs.controls.General.SecondaryNext",		-- 7
	"ifs.controls.General.Enter",				-- 8
	"ifs.controls.General.Zoom",				-- 9
	"ifs.controls.General.Reload",				-- 10

	"ifs.controls.General.SquadCommands",       -- 11
	"ifs.controls.General.SquadUp",				-- 12 [accept]
	"ifs.controls.General.SquadDown",			-- 13 [decline]
	"ifs.controls.General.SquadLeft",			-- 14 [Now target tracking]
	"ifs.controls.General.SquadRight",			-- 15
	"ifs.controls.General.FirstThirdPerson",	-- 16
	--Axis stuff
	"ifs.controls.General.Move_Strafe",			-- 17
	"ifs.controls.General.Move_Turn",			-- 18
	"ifs.controls.General.FreeLook",			-- 19
	"ifs.controls.General.Look_Strafe",			-- 20
	
	--VEHICLE LINGO --Same controls, just different names (just add gNumButtonFunctionsPerMode*1)
	"ifs.controls.General.Boost",				-- 1
	"ifs.controls.General.None",				-- 2	--Vehicles: No Crouch
	"ifs.controls.General.Jump", 				-- 3	----Vehicles: Jump -> TakeOff/Land (for Gunship)
	"ifs.controls.General.Primary",				-- 4	
	"ifs.controls.General.Secondary",			-- 5
	"ifs.controls.General.NextPosition",		-- 6
	"ifs.controls.General.None",				-- 7
	"ifs.controls.General.Exit",				-- 8
	"ifs.controls.General.Zoom",				-- 9
	"ifs.controls.General.None",				-- 10	--Vehicles: No Reload

	"ifs.controls.General.SquadCommands",       -- 11
	"ifs.controls.General.SquadUp",				-- 12
	"ifs.controls.General.SquadDown",			-- 13
	"ifs.controls.General.SquadLeft",			-- 14
	"ifs.controls.General.SquadRight",			-- 15
	"ifs.controls.General.FirstThirdPerson",	-- 16
	--Axis stuff
	"ifs.controls.General.Throttle_Strafe",		-- 17
	"ifs.controls.General.Throttle_Turn",		-- 18
	"ifs.controls.General.Pitch_Turn",			-- 19
	"ifs.controls.General.Pitch_Strafe",		-- 20

	--FLYER LINGO --Same controls, just different names (just add gNumButtonFunctionsPerMode*2)
	"ifs.controls.General.Boost",				-- 1	--Flyers: Sprint -> Boost
	"ifs.controls.General.Trick",				-- 2	--Flyers: Crouch -> Trick
	"ifs.controls.General.Land_Takeoff",		-- 3	--Flyers: Jump -> TakeOff/Land
	"ifs.controls.General.Primary",				-- 4	
	"ifs.controls.General.Secondary",			-- 5
	"ifs.controls.General.NextPosition",		-- 6
	"ifs.controls.General.None",				-- 7	--Flyers have no NextSecondary
	"ifs.controls.General.Exit",				-- 8
	"ifs.controls.General.Zoom",				-- 9
	"ifs.controls.General.None",				-- 10	--Flyers: No Reload

	"ifs.controls.General.SquadCommands",    	-- 11
	"ifs.controls.General.SquadUp",				-- 12
	"ifs.controls.General.SquadDown",			-- 13
	"ifs.controls.General.SquadLeft",			-- 14
	"ifs.controls.General.SquadRight",			-- 15
	"ifs.controls.General.FirstThirdPerson",	-- 16
	--Axis stuff, has no strafe
	"ifs.controls.General.Throttle_Roll",		-- 17
	"ifs.controls.General.Throttle_Turn",		-- 18
	"ifs.controls.General.Pitch_Turn",			-- 19
	"ifs.controls.General.Pitch_Roll",			-- 20


	--JEDI LINGO	(add gNumButtonFunctionsPerMode*0)
	"ifs.controls.General.Sprint",				-- 1
	"ifs.controls.General.Crouch",				-- 2
	"ifs.controls.General.Jump",				-- 3 
	"ifs.controls.jedi.lightsaber",				-- 4
	"ifs.controls.jedi.block",			-- 5
	"ifs.controls.General.PrimaryNext",			-- 6
	"ifs.controls.jedi.switchforce",		-- 7
	"ifs.controls.General.Enter",				-- 8
	"ifs.controls.General.Zoom",				-- 9
	"ifs.controls.jedi.forcepower",				-- 10

	"ifs.controls.General.SquadCommands",       -- 11
	"ifs.controls.General.SquadUp",				-- 12
	"ifs.controls.General.SquadDown",			-- 13
	"ifs.controls.General.SquadLeft",			-- 14 [Now target tracking]
	"ifs.controls.General.SquadRight",			-- 15
	"ifs.controls.General.FirstThirdPerson",	-- 16
	--Axis stuff
	"ifs.controls.General.Move_Strafe",			-- 17
	"ifs.controls.General.Move_Turn",			-- 18
	"ifs.controls.General.FreeLook",			-- 19
	"ifs.controls.General.Look_Strafe",			-- 20

	
	--TURRET LINGO --Same controls, just different names (just add gNumButtonFunctionsPerMode*1)
	"ifs.controls.General.None",				-- 1	--Turrets: No Sprint
	"ifs.controls.General.None",				-- 2	--Turrets: No Crouch
	"ifs.controls.General.Land_Takeoff", 		-- 3	--Turrets: Jump -> TakeOff/Land (for Gunship)
	"ifs.controls.General.Primary",				-- 4	
	"ifs.controls.General.Secondary",			-- 5
	"ifs.controls.General.None",				-- 6	--Turrets: No NextPosition
	"ifs.controls.General.None",				-- 7
	"ifs.controls.General.Exit",				-- 8
	"ifs.controls.General.Zoom",				-- 9
	"ifs.controls.General.NextPosition",		-- 10	--Turrets: No Reload

	"ifs.controls.General.SquadCommands",		-- 11	--Turrets: No SquadCommands
	"ifs.controls.General.SquadUp",				-- 12	--accept
	"ifs.controls.General.SquadDown",			-- 13	--decline
	"ifs.controls.General.SquadLeft",			-- 14
	"ifs.controls.General.SquadRight",			-- 15
	"ifs.controls.General.FirstThirdPerson",	-- 16
	--Axis stuff
	"ifs.controls.General.Zoom_Level",			-- 17
	"ifs.controls.General.Move_Turn",			-- 18
	"ifs.controls.General.FreeLook",			-- 19
	"ifs.controls.General.Look_Strafe",			-- 20

}

--renaming things so that they actually convey some meaning..functype_t? wtf is that?
contents_functype_infantry_button = {
	{ showidx = 0, },
	{ showidx = 1, }, --showstr = "ifs.controls.General.Sprint", },
	{ showidx = 2, }, --showstr = "ifs.controls.General.Crouch", },
	{ showidx = 3, }, --showstr = "ifs.controls.General.Jump", },
	{ showidx = 4, }, --showstr = "ifs.controls.General.Primary", },
	{ showidx = 5, }, --showstr = "ifs.controls.General.Secondary", },
	{ showidx = 6, }, --showstr = "ifs.controls.General.PrimaryNext", },
	{ showidx = 7, }, --showstr = "ifs.controls.General.SecondaryNext", },
	{ showidx = 8, }, --showstr = "ifs.controls.General.Action", },
	{ showidx = 9, }, --showstr = "ifs.controls.General.Zoom", },
	{ showidx = 10, }, --showstr = "ifs.controls.General.Reload", },
	{ showidx = 11, }, --showstr = "ifs.controls.General.SquadCommands", },
	{ showidx = 14, }, --showstr = "ifs.controls.General.SquadLeft", }, -> Target Tracking
	--{ showidx = 16, }, --showstr = "ifs.controls.General.FirstThirdPerson", },
}	
--Eventually may prove unneccesary if people decide to do things with the xtra buttons
contents_functype_vehicle_button = {
	{ showidx = 0, },
	{ showidx = 1, }, --showstr = "ifs.controls.General.Boost", }, --currently no sprinting
	--{ showidx = 2, }, --showstr = "ifs.controls.General.None", }, --currently no crouching
	{ showidx = 3, }, --showstr = "ifs.controls.General.Land_Takeoff", },
	{ showidx = 4, }, --showstr = "ifs.controls.General.Primary", },
	{ showidx = 5, }, --showstr = "ifs.controls.General.Secondary", },
	{ showidx = 6, }, --showstr = "ifs.controls.General.PrimaryNext", },
	--{ showidx = 7, }, --showstr = "ifs.controls.General.None", },	--currently no SecondaryNext
	{ showidx = 8, }, --showstr = "ifs.controls.General.Action", },
	{ showidx = 9, }, --showstr = "ifs.controls.General.Zoom", },
	--{ showidx = 10, }, --showstr = "ifs.controls.General.Reload", },
	{ showidx = 11, }, --showstr = "ifs.controls.General.SquadCommands", },
	{ showidx = 14, }, --showstr = "ifs.controls.General.SquadLeft", }, -> Target Tracking
	--{ showidx = 16, }, --showstr = "ifs.controls.General.FirstThirdPerson", },
}	
--PS2 version
contents_functype_vehicle_buttonPS2 = {
	{ showidx = 0, },
	{ showidx = 1, }, --showstr = "ifs.controls.General.Boost", }, --currently no sprinting
	--{ showidx = 2, }, --showstr = "ifs.controls.General.None", }, --currently no crouching
	{ showidx = 3, }, --showstr = "ifs.controls.General.Land_Takeoff", },
	{ showidx = 4, }, --showstr = "ifs.controls.General.Primary", },
	{ showidx = 5, }, --showstr = "ifs.controls.General.Secondary", },
	{ showidx = 6, }, --showstr = "ifs.controls.General.PrimaryNext", },
	--{ showidx = 7, }, --showstr = "ifs.controls.General.None", },	--currently no SecondaryNext
	{ showidx = 8, }, --showstr = "ifs.controls.General.Action", },
	{ showidx = 9, }, --showstr = "ifs.controls.General.Zoom", },
	--{ showidx = 10, }, --showstr = "ifs.controls.General.Reload", },
	{ showidx = 11, }, --showstr = "ifs.controls.General.SquadCommands", },
	{ showidx = 14, }, --showstr = "ifs.controls.General.SquadLeft", }, -> Target Tracking
	--{ showidx = 16, }, --showstr = "ifs.controls.General.FirstThirdPerson", },
}	

--Eventually may prove unneccesary if people decide to do things with the xtra buttons
contents_functype_flyer_button = {
	{ showidx = 0, },
	{ showidx = 1, }, --showstr = "ifs.controls.General.Boost", },
	{ showidx = 2, }, --showstr = "ifs.controls.General.Trick", },
	{ showidx = 3, }, --showstr = "ifs.controls.General.Land_Takeoff", },
	{ showidx = 4, }, --showstr = "ifs.controls.General.Primary", },
	{ showidx = 5, }, --showstr = "ifs.controls.General.Secondary", },
	{ showidx = 6, }, --showstr = "ifs.controls.General.PrimaryNext", },
	--{ showidx = 7, }, --showstr = "ifs.controls.General.None", },	--currently no SecondaryNext
	{ showidx = 8, }, --showstr = "ifs.controls.General.Action", },
	{ showidx = 9, }, --showstr = "ifs.controls.General.Zoom", },
	--{ showidx = 10, }, --showstr = "ifs.controls.General.Reload", },
	{ showidx = 11, }, --showstr = "ifs.controls.General.SquadCommands", },
	{ showidx = 14, }, -- showstr = "ifs.controls.General.SquadLeft", }, -- currently target tracking
	--{ showidx = 16, }, --showstr = "ifs.controls.General.FirstThirdPerson", },
}	
contents_functype_flyer_buttonPS2 = {
	{ showidx = 0, },
	{ showidx = 1, }, --showstr = "ifs.controls.General.Boost", },
	{ showidx = 2, }, --showstr = "ifs.controls.General.Trick", },
	{ showidx = 3, }, --showstr = "ifs.controls.General.Land_Takeoff", },
	{ showidx = 4, }, --showstr = "ifs.controls.General.Primary", },
	{ showidx = 5, }, --showstr = "ifs.controls.General.Secondary", },
	{ showidx = 6, }, --showstr = "ifs.controls.General.PrimaryNext", },
	--{ showidx = 7, }, --showstr = "ifs.controls.General.None", },	--currently no SecondaryNext
	{ showidx = 8, }, --showstr = "ifs.controls.General.Action", },
	{ showidx = 9, }, --showstr = "ifs.controls.General.Zoom", },
	--{ showidx = 10, }, --showstr = "ifs.controls.General.Reload", },
	{ showidx = 11, }, --showstr = "ifs.controls.General.SquadCommands", },
	{ showidx = 14, }, -- showstr = "ifs.controls.General.SquadLeft", }, -- currently target tracking
	--{ showidx = 16, }, --showstr = "ifs.controls.General.FirstThirdPerson", },
}	

contents_functype_jedi_button = {
	{ showidx = 0, },
	{ showidx = 1, }, --showstr = "ifs.controls.General.Sprint", },
	{ showidx = 2, }, --showstr = "ifs.controls.General.Crouch", },
	{ showidx = 3, }, --showstr = "ifs.controls.General.Jump", },
	{ showidx = 4, }, --showstr = "ifs.controls.General.Primary", },
	{ showidx = 5, }, --showstr = "ifs.controls.General.Secondary", },
	{ showidx = 6, }, --showstr = "ifs.controls.General.PrimaryNext", },
	{ showidx = 7, }, --showstr = "ifs.controls.General.SecondaryNext", },
	{ showidx = 8, }, --showstr = "ifs.controls.General.Action", },
	{ showidx = 9, }, --showstr = "ifs.controls.General.Zoom", },
	{ showidx = 10, }, --showstr = "ifs.controls.General.Reload", },
	{ showidx = 11, }, --showstr = "ifs.controls.General.SquadCommands", },
	{ showidx = 14, }, --showstr = "ifs.controls.General.SquadLeft", }, -> Target Tracking
	--{ showidx = 16, }, --showstr = "ifs.controls.General.FirstThirdPerson", },
}	

contents_functype_turret_button = {
	{ showidx = 0, },
	--{ showidx = 1, }, --showstr = "ifs.controls.General.None", }, --currently no sprinting
	--{ showidx = 2, }, --showstr = "ifs.controls.General.None", }, --currently no crouching
	--{ showidx = 3, }, --showstr = "ifs.controls.General.Land_Takeoff", },
	{ showidx = 4, }, --showstr = "ifs.controls.General.Primary", },
	--{ showidx = 5, }, --showstr = "ifs.controls.General.Secondary", },
	{ showidx = 6, }, --showstr = "ifs.controls.General.PrimaryNext", },
	--{ showidx = 7, }, --showstr = "ifs.controls.General.None", },	--currently no SecondaryNext
	{ showidx = 8, }, --showstr = "ifs.controls.General.Action", },
	{ showidx = 9, }, --showstr = "ifs.controls.General.Zoom", },
	--{ showidx = 10, }, --showstr = "ifs.controls.General.Reload", },
	{ showidx = 11, }, --showstr = "ifs.controls.General.SquadCommands", },
	--{ showidx = 16, }, --showstr = "ifs.controls.General.FirstThirdPerson", },
}	

contents_functype_infantry_stick = {	
	{ showidx = gAnalogButtonFunction0+0, }, --showstr = "ifs.controls.General.Move_Strafe", },
	{ showidx = gAnalogButtonFunction0+1, }, --showstr = "ifs.controls.General.Move_Turn", },
	{ showidx = gAnalogButtonFunction0+2, }, --showstr = "iifs.controls.General.FreeLook, },
	{ showidx = gAnalogButtonFunction0+3, }, --showstr = "iifs.controls.General.Look_Strafe, },
}

contents_functype_vehicle_stick = {
	{ showidx = gAnalogButtonFunction0+0, }, --showstr = "ifs.controls.General.Throttle_Strafe", },
	{ showidx = gAnalogButtonFunction0+1, }, --showstr = "ifs.controls.General.Throttle_Turn", },
	{ showidx = gAnalogButtonFunction0+2, }, --showstr = "iifs.controls.General.Pitch_Turn, },
	{ showidx = gAnalogButtonFunction0+3, }, --showstr = "iifs.controls.General.Pitch_Strafe, },
}

contents_functype_flyer_stick = {
	{ showidx = gAnalogButtonFunction0+0, }, --showstr = "ifs.controls.General.Throttle_Roll", },
	{ showidx = gAnalogButtonFunction0+1, }, --showstr = "ifs.controls.General.Throttle_Turn", },
	{ showidx = gAnalogButtonFunction0+2, }, --showstr = "iifs.controls.General.Pitch_Turn", },
	{ showidx = gAnalogButtonFunction0+3, }, --showstr = "iifs.controls.General.Pitch_Roll", },
}

contents_functype_jedi_stick = {	
	{ showidx = gAnalogButtonFunction0+0, }, --showstr = "ifs.controls.General.Move_Strafe", },
	{ showidx = gAnalogButtonFunction0+1, }, --showstr = "ifs.controls.General.Move_Turn", },
	{ showidx = gAnalogButtonFunction0+2, }, --showstr = "iifs.controls.General.FreeLook, },
	{ showidx = gAnalogButtonFunction0+3, }, --showstr = "iifs.controls.General.Look_Strafe, },
}

contents_functype_turret_stick = {	
	{ showidx = gAnalogButtonFunction0+0, }, --showstr = "ifs.controls.General.Move_Strafe", },
--	{ showidx = gAnalogButtonFunction0+1, }, --showstr = "ifs.controls.General.Move_Turn", },
	{ showidx = gAnalogButtonFunction0+2, }, --showstr = "iifs.controls.General.FreeLook, },
--	{ showidx = gAnalogButtonFunction0+3, }, --showstr = "iifs.controls.General.Look_Strafe, },
}

-- *******************************
-- UTILITY FUNCTIONS FOR THIS MENU
-- *******************************

-- Shows/hides all lines on this screen. ShowTable is an optional
-- parameter, shown even if the rest aren't.
function ifs_opt_controller_SetLineVisibility(this,vis,ShowTable)
	local k,v
	for k,v in Platform_btn_map do
		local UseVis = vis
		--if((k == 3) or (k == 5) or (k == 6)) then
		--if((k == 4) or (k == 6)) then					-- disable l and r dpad lines
		--	UseVis = nil
		--end

		if(v.type == 99) then
--			IFObj_fnSetVis(this.lines[k],nil)
		elseif (v.type ~= 5) then
			IFObj_fnSetVis(this.lines[k],UseVis)
			--				this.lines[k]
		end
	end
	
	IFObj_fnSetVis(this.flipStatus, vis)
	IFObj_fnSetVis(this.SensitivityTextX, vis)
	IFObj_fnSetVis(this.SensitivityTextY, vis)

	-- Dim controller a bit when items aren't visible
	local ContAlpha = 1.0
	if(not vis) then
		ContAlpha = 0.6
	end
	IFObj_fnSetAlpha(this.controller,ContAlpha)

	if((ShowTable) and (not vis)) then
		IFObj_fnSetVis(ShowTable,1)
	end
end

-- Helper function. Moves the cursor to the right location
function ifs_opt_controller_fnMoveCursor(this)
	local CurItem = Platform_btn_map[this.cont_element_idx]

	-- Constant, extra width per box
	local kBOX_EXTRA_WIDTH = 6
	local BoxW
	local BoxH

	local fLeft, fTop, fRight, fBot
	local CurText, BoxCenterY, BoxCenterX

	if(this.lines[this.cont_element_idx]) then
		CurText = this.lines[this.cont_element_idx].label
		-- BoxCenterY, BoxH are calc'd below
	elseif (CurItem.name == "yflip") then
		CurText = this.flipStatus
		local fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(CurText)
		BoxH = fBot - fTop + 12
		local fudgefactor = 1
		if ( BoxH < 32 ) then fudgefactor = 19 end
		BoxCenterY = this.flipStatus.Y + (BoxH + fudgefactor) * 0.5 --13
	elseif (CurItem.name == "lookslidex") then
		CurText = this.SensitivityTextX
		local fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(CurText)
		BoxH = fBot - fTop + 10
		local fudgefactor = 1
		if ( BoxH < 32 ) then fudgefactor = 19 end
		BoxCenterY = this.SensitivityTextX.Y + (BoxH + fudgefactor) * 0.5 --13
	elseif (CurItem.name == "lookslidey") then
		CurText = this.SensitivityTextY
		local fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(CurText)
		BoxH = fBot - fTop + 10
		local fudgefactor = 1
		if ( BoxH < 32 ) then fudgefactor = 19 end
		BoxCenterY = this.SensitivityTextY.Y + (BoxH + fudgefactor) * 0.5 --13
 	elseif (CurItem.name == "reset") then
 		BoxCenterY = this.CurPresetText.Y + 12
 		CurText = this.CurPresetText
 		BoxH = 32
	end

	fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(CurText)
	--	print("Disp fLeft, fTop, fRight, fBot = ",fLeft, fTop, fRight, fBot)
	BoxW = fRight - fLeft + kBOX_EXTRA_WIDTH + kBOX_EXTRA_WIDTH

	if(this.lines[this.cont_element_idx]) then
		BoxCenterY = CurItem.ly1 + 34
		BoxH = fBot - fTop + 14
		--local fNameLeft, fNameTop, fNameRight, fNameBot = 
		--	IFText_fnGetDisplayRect(this.lines[this.cont_element_idx].label)
		--BoxW = BoxW + (fNameRight - fNameLeft) + 5
	end

	this.cursor.width = BoxW 
	this.cursor.w = BoxW
	this.cursor.height = BoxH
	this.cursor.h = BoxH

	-- bottom center items are at lx1 == 0
	if(CurItem.lx1 == 0) then
		IFObj_fnSetPos(this.cursor,CurItem.lx1, BoxCenterY)
	--elseif (CurItem.lx1 < CurItem.lx2) then
		-- right side of screen
		--IFObj_fnSetPos(this.cursor, CurItem.lx1 - (this.cursor.width * 0.5) + kBOX_EXTRA_WIDTH, BoxCenterY)
	else
		-- Left side of screen
		IFObj_fnSetPos(this.cursor, CurItem.lx1 + (this.cursor.width * 0.5) - kBOX_EXTRA_WIDTH, BoxCenterY)
	end
	
	-- the 'change' button at the bottom of the screen should go away 
	-- if we're on one of the options that doesn't use the button to switch.
	if ( this.Helptext_Accept ) then
		if ( CurItem.name == "yflip" or CurItem.name == "lookslidex" 
				or CurItem.name == "lookslidey" or CurItem.name == "reset" ) then
			IFObj_fnSetVis(this.Helptext_Accept, nil)
		else
			IFObj_fnSetVis(this.Helptext_Accept, 1)
		end
	end
end

-- items selected by the cursor turn a different color.
function ifs_opt_controller_fnSetSelectedColor(this, buttonIdx, bSelected)
	local strObj = nil
	if ( this.lines[buttonIdx] ) then
		strObj = this.lines[buttonIdx]
	elseif ( Platform_btn_map[buttonIdx].name == "yflip" ) then
		strObj = this.flipStatus
	elseif ( Platform_btn_map[buttonIdx].name == "reset" ) then
		strObj = this.CurPresetText
	elseif ( Platform_btn_map[buttonIdx].name == "lookslidex") then
		strObj = this.SensitivityTextX
	elseif ( Platform_btn_map[buttonIdx].name == "lookslidey") then
		strObj = this.SensitivityTextY
	end
	if ( strObj ) then
		if ( bSelected == 0 ) then
			IFObj_fnSetColor(strObj, 255, 255, 255)
		else
			IFObj_fnSetColor(strObj, gSelectedTextColor[1], gSelectedTextColor[2], gSelectedTextColor[3])
		end
	end
end

-- Helper function for navigation - moves off the current button and
-- onto the next. Handles cursor, etc.
function ifs_opt_controller_fnSetNextButton(this,Next)
	IFObj_fnSetAlpha(this.buttons[this.CurButton],0.0)
	ifs_opt_controller_fnSetSelectedColor(this, this.CurButton, 0)
	this.CurButton = Next
	IFObj_fnSetAlpha(this.buttons[this.CurButton],1.0)
	ifs_opt_controller_fnSetSelectedColor(this, this.CurButton, 1)
	this.cont_element_idx = this.CurButton
	ifs_opt_controller_fnMoveCursor(this)
end

-- Callback for when the "really reset to defaults?" popup is over.
-- If bResult is true, user wanted to do that.
function ifs_opt_controller_fnResetPopupDone(bResult)
	local this = ifs_opt_controller
	AnimationMgr_AddAnimation(this.controller, {fTotalTime = 0.3, fStartAlpha = 0.4, fEndAlpha = 1,})
	if(bResult) then
		ScriptCB_ResetControlsToDefault()
	end

	local this = ifs_opt_controller
	-- Always refresh all buttons, turn everything back on.
	ifs_opt_controller_SetLineVisibility(this,1)
	ifs_opt_controller_GetAllEntries(this)
	Popup_YesNo.fnDone = nil
end

-- Callback for when the "really reset to other preset?" popup is over.
-- If bResult is true, user wanted to do that.
function ifs_opt_controller_fnPresetChangedPopupDone(bResult)
	local this = ifs_opt_controller
	AnimationMgr_AddAnimation(this.controller, {fTotalTime = 0.3, fStartAlpha = 0.4, fEndAlpha = 1,})
	if(bResult) then
		-- this should already be true
		this.cont_menu_state = 2
		this.bApplyPresetSettingsNow = true
		ifs_opt_controller_ApplyPresetSettings(this)
	else
		this.cont_menu_state = 0
		this.bApplyPresetSettingsNow = false
	end

	local this = ifs_opt_controller
	-- Always refresh all buttons, turn everything back on.
	ifs_opt_controller_SetLineVisibility(this,1)
	ifs_opt_controller_GetAllEntries(this)
	Popup_YesNo.fnDone = nil
end


-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_controller_listbox_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { 
		x = layout.x - 0.5 * layout.width, 
		y=layout.y - 0.5 * layout.height + 1,
	}
	Temp.FunctionStr = NewIFText{ 
		x = 10, y = 0, 
		valign = "vcenter", halign = "left", 
		font = "gamefont_tiny",
		textw = layout.width - 32, texth = layout.height,
		nocreatebackground = 1,
		inert_all = 1,
	}
	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ifs_controller_listbox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
	if(Data) then
		if(Data.showidx == 0) then
			IFText_fnSetString(Dest.FunctionStr,"ifs.controls.General.none")
		else
			local ShowIdx = Data.showidx
			if(ShowIdx > 0) then
				ShowIdx = ShowIdx + gNumButtonFunctionsPerMode * ifs_opt_controller.iControlMode
			end
			IFText_fnSetString(Dest.FunctionStr,gButtonFunctionStrings[ShowIdx])
		end

		IFObj_fnSetColor(Dest.FunctionStr, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.FunctionStr, fAlpha)
		IFObj_fnSetVis(Dest.FunctionStr,1)
	else
		-- Blank the data
		IFText_fnSetString(Dest.FunctionStr,"")
		IFObj_fnSetVis(Dest.FunctionStr,nil)
	end
end

ifs_controller_listbox_layout = {
	showcount = 5, -- math.max of the visible ones above
	yHeight = 35,
	ySpacing  = 0,
	width = 180,
	x = 0,
	slider = 1,
	CreateFn = ifs_controller_listbox_CreateItem,
	PopulateFn = ifs_controller_listbox_PopulateItem,
	nocreatebackground = 1,
}

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_controller_preset_listbox_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { 
		x = layout.x - 0.5 * layout.width, 
		y=layout.y - 0.5 * layout.height + 1,
	}
	Temp.ItemText = NewIFText{ 
		x = 10, y = 0, 
		valign = "vcenter", halign = "left", 
		font = "gamefont_tiny",
		textw = layout.width - 42, texth = layout.height,
		nocreatebackground = 1,
		inert_all = 1,
	}
	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ifs_controller_preset_listbox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
	if(Data) then
		IFText_fnSetString(Dest.ItemText,Data.title)
		IFObj_fnSetColor(Dest.ItemText, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.ItemText, fAlpha)
	else
		-- Blank the data
		IFText_fnSetString(Dest.ItemText,"")
	end
	IFObj_fnSetVis(Dest.ItemText,Data) -- show/hide, depending on whether data is present
end

ifs_controller_preset_listbox_layout = {
	showcount = 5, -- math.max of the visible ones above
	yHeight = 40,
	ySpacing  = 0,
	width = 250,
	x = 0,
	slider = 1,
	CreateFn = ifs_controller_preset_listbox_CreateItem,
	PopulateFn = ifs_controller_preset_listbox_PopulateItem,
	nocreatebackground = 1,
}

function ifs_opt_controller_CreateElements(this)

	if(1) then
		local w
		local h
		w,h,v,widescreen = ScriptCB_GetScreenInfo()
		this.Background = NewIFImage 
		{
 			ZPos = 254, 
 			x = 0,
 			y = 0,
 			alpha = 1,
 			UseSafezone = 0,
 			localpos_l = 0, localpos_t = 0,
 			localpos_r = w*widescreen, localpos_b =  h,
			texture = "opaque_black",
			ColorR = 0, ColorG = 0, ColorB = 0, -- black
		}
	end

	local k,v
	for k,v in Platform_btn_map do
	
		if(v.type ~= 99) then

			-- add one element to ifs_opt_controller.buttons
			this.buttons[k]   = NewIFImage { texture = v.hiTex, inert_all = 1, }
			this.buttons[k].x = v.x
			this.buttons[k].y = v.y
			IFImage_fnSetTexturePos(this.buttons[k],0,0,v.w,v.h)
			IFObj_fnSetAlpha(this.buttons[k],0.0)

			-- don't create it for the special case y-flip item
			if( v.type ~= 5 ) then
				--this.lines[k] = NewSegmentLine( v.lx1,v.ly1,v.lx2,v.ly2,"")
				XPos = v.lx1
				local w,h = ScriptCB_GetSafeScreenInfo()
				local xAdjust = XPos
				if ( XPos < 0 ) then
					xAdjust = w * 0.5 + XPos
				end
				TextW = math.max(50, (w * 0.5) - xAdjust + 10)
				this.lines[k] = NewIFContainer {
					--ScreenRelativeX = 0.5, -- centre
					ScreenRelativeY = 0.5, -- centre
				}
				--this.lines[k].buttonname = NewIFText{
				--	ScreenRelativeX = 0.5,
				--	ScreenRelativeY = 0.5,
				--	font = "gamefont_tiny",
				--	valign = "vcenter",
				--	halign = "left",
				--	string = gButtonNames[k],
				--	x= v.lx1,
				--	y= v.ly1,
				--	ColorR = 255, ColorG = 255, ColorB = 255,
				--	textw = TextW, -- - 5,
				--	texth = 60,
				--	nocreatebackground = 1,
				--	startdelay = math.random() * 0.5,
				--	leading = -3
				--}
				this.lines[k].label = NewIFText{
					--ScreenRelativeX = 0.5,
					ScreenRelativeY = 0.5,
					font = "gamefont_tiny",
					valign = "vcenter",
					halign = "left",
					string = gButtonNames[k],
					x= v.lx1, -- + IFText_fnGetExtent(this.lines[k].buttonname),
					y= v.ly1,
					ColorR = 255, ColorG = 255, ColorB = 255,
					textw = TextW, -- - 5,
					texth = 60,
					nocreatebackground = 1,
					startdelay = math.random() * 0.5,
					leading = -3
				}
			end
		end

	end
	this.CurButton = 1
--	IFObj_fnSetAlpha(this.buttons[this.CurButton],1.0)

	-- Ask game for screen size, fill in values
	local r,b,v,widescreen = ScriptCB_GetScreenInfo()
	--this.bgTexture.localpos_r = r*widescreen
	--this.bgTexture.localpos_b = b
	--this.bgTexture.uvs_b = v

	ListManager_fnInitList(this.listbox,ifs_controller_listbox_layout)
	ListManager_fnInitList(this.presetlistbox,ifs_controller_preset_listbox_layout)

	--if(gPlatformStr == "XBox") then
		this.flipStatus.y = -40
		this.SensitivityTextX.y = -110
		this.SensitivityTextY.y = -75
	--end
	if (gPlatformStr == "PS2") then
		this.flipStatus.x = -225
		this.SensitivityTextX.x = -225
		this.SensitivityTextY.x = -225
	end

	local w,h = ScriptCB_GetSafeScreenInfo()
	this.ResetText.y = (h * -0.5) + 30 -- put at top of screen, below title
	this.ResetText.x = (w * -0.5) + 10 -- put at left of screen, below title
	this.CurPresetText.y = (h * -0.5) + 70 -- put at top of screen, below title
	this.CurPresetText.x = 10 -- put at left of screen, below title

	if(this.Helptext_Accept) then
		IFText_fnSetString(this.Helptext_Accept.helpstr,"common.change")
	end

	-- .y will be zapped after creation. Cache for later
	this.flipStatus.Y = this.flipStatus.y
	this.SensitivityTextX.Y = this.SensitivityTextX.y
	this.SensitivityTextY.Y = this.SensitivityTextY.y
	this.ResetText.Y = this.ResetText.y
	this.CurPresetText.Y = this.CurPresetText.y

	if(ScriptCB_GetShellActive()) then
		--this.bgTexture = nil
	end
end

-- bVis is true if the presets listbox should be visible or not.
function ifs_opt_controller_ShowPresetListbox(this, bVis)
	IFObj_fnSetVis(this.presetlistbox, bVis)
	IFObj_fnSetVis(this.CurPresetText, not bVis)
	IFObj_fnSetVis(this.cursor, not bVis)
	IFObj_fnSetVis(this.flipStatus, not bVis)
	IFObj_fnSetVis(this.SensitivityTextX, (not bVis)) -- and (this.iControlMode == 0))
	IFObj_fnSetVis(this.SensitivityTextY, not bVis)
	ifs_opt_controller_SetLineVisibility(this, not bVis)
end

 -- Update positioning, info of elements
function ifs_opt_controller_SetPresetText(this)

	-- Reposition items based on the width of the "Choose Preset" text entry
	-- [Localization changes that] Do this the first time we enter.
	if(not this.bMovedItems) then

		local w,h = ScriptCB_GetSafeScreenInfo()
		local TitleW = IFText_fnGetExtent(this.ResetText)

		-- HACK - GetExtent seems to return 0 the first time thru. We need
		-- to keep calling it until things stabilize.
		this.bMovedItems = (TitleW > 2)

		this.CurPresetText.X = (w * -0.5) + 10
		this.CurPresetText.Y = (h * -0.5) + 50
		IFObj_fnSetPos(this.CurPresetText, this.CurPresetText.X, this.CurPresetText.Y)
		Platform_btn_map[21].lx1 = this.CurPresetText.X 
		Platform_btn_map[21].lx2 = this.CurPresetText.X 

		IFObj_fnSetPos(this.presetlistbox, 
									 this.CurPresetText.X + (ifs_controller_preset_listbox_layout.width + 35) * 0.5,
									 this.CurPresetText.Y + ( ifs_controller_preset_listbox_layout.showcount * (ifs_controller_preset_listbox_layout.yHeight + ifs_controller_preset_listbox_layout.ySpacing) + 30) * 0.5)									 
		ifs_opt_controller_fnMoveCursor(this)
	end

	-- If the cached index of preset isn't present, then determine it
	if(not this.iPresetIdx) then
		-- Select which set of preset to use
		if (this.iControlMode == 0) then
			gControllerPresets = gControllerPresets0
		elseif (this.iControlMode == 1) then
			gControllerPresets = gControllerPresets1
		elseif (this.iControlMode == 2) then
			gControllerPresets = gControllerPresets2
		elseif (this.iControlMode == 3) then
			gControllerPresets = gControllerPresets3
		else
			gControllerPresets = gControllerPresets4
		end

--		print("gControllerPresets = ", gControllerPresets)
		this.iNumPreset = table.getn(gControllerPresets)

		this.iPresetIdx = -1 -- not found
		this.bPresetIsCustom = nil

		-- Try and find current mapping in the set of preset. If not found,
		-- call it 'custom'. 
		local i,j
		local k,v
		for i = 1,this.iNumPreset do
			local CheckMap = gControllerPresets[i].btndefs
			if(CheckMap) then
				j = 1
				local bMatch = true -- ScriptCB_GetYAxisFlip() == gControllerPresets[i].yFlip  -- flip no longer needs to match

				for k,v in Platform_btn_map do
					if((v.type ~= 5) and (v.type ~= 99)) then 
						-- Get the Global functionID assigned to this button
						local iCurFunc = ScriptCB_GetFunctionIdForButtonId(k,this.iControlMode)

						if(v.name == "lang") then
							--get(stick,mode)
							iCurFunc = gAnalogButtonFunction0 + ScriptCB_GetFunctionIdForAnalogId(0, this.iControlMode)
						elseif (v.name == "rang") then
							iCurFunc = gAnalogButtonFunction0 + ScriptCB_GetFunctionIdForAnalogId(1, this.iControlMode)
						end

						bMatch = bMatch and (CheckMap[j][2] == iCurFunc)
						j = j + 1 -- move on in parallel array
					end -- v.type ~= 5. 
				end -- k,v loop

				if(bMatch) then
					-- All buttons & flip matched. Set it as the current
					this.iPresetIdx = i
					this.bPresetIsCustom = nil
				end

			end -- CheckMap exists
		end -- i loop over #preset

		-- If we didn't find a match above, then set it to custom (last entry)
		if(this.iPresetIdx < 0) then
			this.iPresetIdx = this.iNumPreset
			this.bPresetIsCustom = 1
		end

	end

	IFText_fnSetString(this.CurPresetText, gControllerPresets[this.iPresetIdx].title)
	-- Also, fill the contents of this listbox, but hide it
	ListManager_fnFillContents(this.presetlistbox,gControllerPresets,ifs_controller_preset_listbox_layout)
	IFObj_fnSetVis(this.presetlistbox, nil)
end

ifs_opt_controller = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil, -- played before the screen is displayed
	movieBackground = nil, -- played while the screen is displayed
	enterSound      = "",
	exitSound       = "",

	title = NewIFText {
--		string = "ifs.controls.Ps2controllervehunittitle",
		font = "gamefont_medium",
		textw = 460,
		y = 0,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0, -- top
		--inert = 1,
		nocreatebackground = 1,
	},

	ResetText = NewIFText {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.5,
		ZPos = 100,
		string = "ifs.controls.preset",
		font = "gamefont_medium",
		halign = "left",
		textw = 380,
		texth = 40,
		x = 10,
		ColorR = 255, ColorB = 255, ColorG = 255,
		nocreatebackground = 1,
	},

	CurPresetText = NewIFText {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.5,
		ZPos = 100,
		string = "ifs.controls.preset",
		font = "gamefont_medium",
		halign = "left",
		textw = 380,
		ColorR = 255, ColorB = 255, ColorG = 255,
		nocreatebackground = 1,
	},

	cursor = NewButtonWindow {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.5,
		width = 120, w = 120,
		height = 42, h = 42,
		ZPos = 181, -- Behind the text items
	},

	controller = NewIFImage {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.5, 
		texture = "controller",
		localpos_l = -24, -- -128,
		localpos_t = -214, -- -128,
		localpos_r = 232, -- 128,
		localpos_b = 42, -- 128,
		ZPos = 200, -- behind most things
		inert_all = 1,
		--inert = 1,
	},

	flipStatus = NewIFText {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.5,
		ZPos = 100,
		string = "",
		font = "gamefont_small",
 		valign = "vcenter",
		halign = "left",
		textw = 220, --380,
		texth = 40,
		x = -270,
		y = 175 - 54,
		ColorR = 255, ColorB = 255, ColorG = 255,
		nocreatebackground = 1,
	},

 	SensitivityTextX = NewIFText {
 		ScreenRelativeX = 0.5,
 		ScreenRelativeY = 0.5,
 		ZPos = 100,
-- 		string = "ifs.controls.looksensitivityX",
 		font = "gamefont_small",
 		valign = "vcenter",
		halign = "left",
 		textw = 220, --380,
 		texth = 40,
 		x = -270,
 		y = 125 - 65,
		ColorR = 255, ColorB = 255, ColorG = 255,
		nocreatebackground = 1,
 	},

 	SensitivityTextY = NewIFText {
 		ScreenRelativeX = 0.5,
 		ScreenRelativeY = 0.5,
 		ZPos = 100,
-- 		string = "ifs.controls.looksensitivityY",
 		font = "gamefont_small",
 		valign = "vcenter",
		halign = "left",
 		textw = 220, --380,
 		texth = 40,
 		x = -270,
 		y = 125 - 0,
		ColorR = 255, ColorB = 255, ColorG = 255,
		nocreatebackground = 1,
 	},

	--bgTexture = NewIFImage { 
	--	ZPos = 250,
	--	ScreenRelativeX = 0,
	--	ScreenRelativeY = 0,
	--	UseSafezone = 0,
	--	texture = "opaque_black", 
	--	localpos_l = 0,
	--	localpos_t = 0,
	--	-- Size, UVs aren't fully specified here, but in NewIFShellScreen()
--
--		inert = 1, -- delete from lua memory once created.
--		inert_all = 1,
--	},
	
	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- centre
		ScreenRelativeY = 0.5, -- centre
	},

	lines = NewIFContainer {
		ScreenRelativeX = 0.5, -- centre
		ScreenRelativeY = 0.5, -- centre
	},

	listbox = NewButtonWindow { ZPos = 200, x=0, y = 40,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- middle of screen
		width = ifs_controller_listbox_layout.width + 35,
		height = ifs_controller_listbox_layout.showcount * (ifs_controller_listbox_layout.yHeight + ifs_controller_listbox_layout.ySpacing) + 20
	},

	presetlistbox = NewButtonWindow { ZPos = 200, x=0, y = 40,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- middle of screen
		width = ifs_controller_preset_listbox_layout.width + 35,
		height = ifs_controller_preset_listbox_layout.showcount * (ifs_controller_preset_listbox_layout.yHeight + ifs_controller_preset_listbox_layout.ySpacing) + 30
	},

	cont_menu_state = 0,
	cont_element_idx = 1,
	CurButton=1,
		
	Enter = function(this)
		gIFShellScreenTemplate_fnEnter(this, bFwd)
		this.iControlMode = ScriptCB_GetControlMode()

		-- Always start on preset now - NM 3/7/05
		this.cont_element_idx=21 -- L2. Start in top-left
		this.CurButton = 21

		-- change the cursor texture
		gButtonWindow_fnSetTexture(this.cursor, "listbox_cursor")

-- 		if(gPlatformStr == "XBox") then
-- 			-- idx1 is XBox white button. Start in top-left
-- 			ifs_opt_controller_fnSetNextButton(this,2)	
-- 		else
-- 			this.cont_element_idx=1 -- L2. Start in top-left
-- 			this.CurButton = 1
-- 		end
		
		ifs_opt_controller_SetPresetText(this) -- Update info
		
		if(nil) then --gNoControllerChanges) then
			this.CurButton = 17 -- y-flip
			this.cont_element_idx = 17
			IFObj_fnSetVis(this.ResetText,nil)
			IFObj_fnSetVis(this.CurPresetText,nil)
			IFObj_fnSetVis(this.buttons[1], nil)
		end

		this.cont_menu_state=0
		
		IFObj_fnSetAlpha(this.buttons[this.CurButton],1.0)
		ifs_opt_controller_GetAllEntries(this)
		ifs_opt_controller_SetLineVisibility(this,1)
		IFObj_fnSetVis(this.listbox,nil)
		if( this.iControlMode == 0 ) then
			IFText_fnSetString(this.title,"ifs.Controls.Soldier.title")
		elseif( this.iControlMode == 1 ) then
			IFText_fnSetString(this.title,"ifs.Controls.Vehicle.title")
		elseif( this.iControlMode == 2 ) then
			IFText_fnSetString(this.title,"ifs.Controls.Flyer.title")
		elseif (this.iControlMode == 3 ) then
			IFText_fnSetString(this.title,"ifs.Controls.Jedi.title")
		elseif (this.iControlMode == 4 ) then
			IFText_fnSetString(this.title,"ifs.Controls.Turret.title")
		end

		-- -- Sensitivity is present only on infantry controls
		-- scratch that.  sensitivity is now present at all times.
		IFObj_fnSetVis(this.SensitivityTextX, true) --(this.iControlMode == 0))
		IFObj_fnSetVis(this.SensitivityTextY, true)
	
		ifs_opt_controller_fnMoveCursor(this)	
		ifs_opt_controller_fnSetSelectedColor(this, this.CurButton, 1)

		AnimationMgr_AddAnimation(this.Helptext_Back, {fStartAlpha = 0, fEndAlpha = 1,})
		AnimationMgr_AddAnimation(this.controller, {fStartAlpha = 0, fEndAlpha = 1,})
		AnimationMgr_AddAnimation(this.flipStatus, {fStartAlpha = 0, fEndAlpha = 1,})
		AnimationMgr_AddAnimation(this.ResetText, {fStartAlpha = 0, fEndAlpha = 1,})
		AnimationMgr_AddAnimation(this.CurPresetText, {fStartAlpha = 0, fEndAlpha = 1,})
		AnimationMgr_AddAnimation(this.buttons, {fStartAlpha = 0, fEndAlpha = 1,})
		AnimationMgr_AddAnimation(this.lines, {fStartAlpha = 0, fEndAlpha = 1,})

		-- make sure the alpha comes back on if someone was button mashing
		-- the screens. (bug #4875)
		IFObj_fnSetAlpha(this.controller, 255)
		IFObj_fnSetAlpha(this.ResetText, 255)
		IFObj_fnSetAlpha(this.flipStatus, 255)
		IFObj_fnSetAlpha(this.CurPresetText, 255)

	end,

	Exit = function(this)
		IFObj_fnSetAlpha(this.buttons[this.CurButton],0.0)
		ifs_opt_controller_fnSetSelectedColor(this, this.CurButton, 0)
		this.iPresetIdx = nil -- clear this out so we force-rebuild it.
	end,

	Input_Accept = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		ifelm_shellscreen_fnPlaySound(this.acceptSound)
--Bring a Menu up
		if(this.cont_menu_state == 0) then
			-- *
			-- Go from controller button selection to input option selection
			-- *

			local cont_menu_type = Platform_btn_map[this.cont_element_idx].type
			
			
			local CurFunc = Platform_btn_map[this.cont_element_idx].func
			local Button = Platform_btn_map[this.cont_element_idx]

			-- Special-case the bottom "buttons"
			if(cont_menu_type == 5) then
				--if(Button.name == "yflip") then
					-- Negate this
				--	ScriptCB_SetYAxisFlip(1 - ScriptCB_GetYAxisFlip())
				if (Button.name == "reset") then

					ifs_opt_controller_SetLineVisibility(this,nil)
					this.cont_menu_state = 2
					ifs_opt_controller_ShowPresetListbox(this, 1)

					-- Ask them first
 					--Popup_YesNo.CurButton = "no" -- default
 					--Popup_YesNo.fnDone = ifs_opt_controller_fnResetPopupDone
 					--IFText_fnSetString(Popup_YesNo.title,"ifs.controls.askreset")
 					--AnimationMgr_AddAnimation(this.controller, {fTotalTime = 0.3, fStartAlpha = 1, fEndAlpha = 0.4,})
 					--Popup_YesNo:fnActivate(1)
				end -- checking button name

				-- Always refresh all buttons
				ifs_opt_controller_GetAllEntries(this)
				ifs_opt_controller_fnMoveCursor(this)
				return
			end

			if(Platform_btn_map[this.cont_element_idx].name == "lang") then
				CurFunc = 16 + ScriptCB_GetFunctionIdForAnalogId(0, this.iControlMode)
			elseif (Platform_btn_map[this.cont_element_idx].name == "rang") then
				CurFunc = 16 + ScriptCB_GetFunctionIdForAnalogId(1, this.iControlMode)
			end

			if(cont_menu_type == 1) then
				if( this.iControlMode == 0 ) then --infantry mode, pass the infantry box
					ifs_controller_listbox_contents = contents_functype_infantry_button
				elseif (this.iControlMode == 1) then
					if(gPlatformStr == "PS2") then
						ifs_controller_listbox_contents = contents_functype_vehicle_buttonPS2
					else
						ifs_controller_listbox_contents = contents_functype_vehicle_button
					end
				elseif (this.iControlMode == 2) then
					if(gPlatformStr == "PS2") then
						ifs_controller_listbox_contents = contents_functype_flyer_buttonPS2
					else
						ifs_controller_listbox_contents = contents_functype_flyer_button
					end
				elseif (this.iControlMode == 3) then
					ifs_controller_listbox_contents = contents_functype_jedi_button
				else
					ifs_controller_listbox_contents = contents_functype_turret_button
				end
			elseif (cont_menu_type == 3) then	
				if( this.iControlMode == 0 ) then --infantry mode, pass the infantry box
					ifs_controller_listbox_contents = contents_functype_infantry_stick
				elseif (this.iControlMode == 1) then
					ifs_controller_listbox_contents = contents_functype_vehicle_stick
				elseif (this.iControlMode == 2) then
					ifs_controller_listbox_contents = contents_functype_flyer_stick
				elseif (this.iControlMode == 3) then
					ifs_controller_listbox_contents = contents_functype_jedi_stick
				else
					ifs_controller_listbox_contents = contents_functype_turret_stick
				end
			else
--				print("Unknown type!")
			end

			local i
			local aListIndex = -1 --this is lua, start indices at 1!!!
			for i = 1,table.getn(ifs_controller_listbox_contents) do
				if(ifs_controller_listbox_contents[i].showidx == CurFunc) then
					aListIndex = i
				end
			end

			if(aListIndex < 0) then
--				print("Uhoh, couldn't find CurFunc ",CurFunc," in listbox list, idx =",this.cont_element_idx)
				aListIndex = 1 -- safety value
			end

			-- Auto-center the listbox on this.
			ifs_controller_listbox_layout.SelectedIdx = aListIndex
			ifs_controller_listbox_layout.CursorIdx = aListIndex
			local FirstIdx = math.max(aListIndex - (math.floor(ifs_controller_listbox_layout.showcount * 0.5)),1)
			ifs_controller_listbox_layout.FirstShownIdx = FirstIdx

			ListManager_fnFillContents(this.listbox,ifs_controller_listbox_contents,ifs_controller_listbox_layout)
		
			--Next round deal with the menu 
			this.cont_menu_state=1
			this.cont_element_idx = this.CurButton
			ifs_opt_controller_SetLineVisibility(this,nil,this.lines[this.CurButton])
			this.CurButton = 1
		
			--The position of the window depends on which side of the controller we are on
			-- move the y to just below the controller display
			if(Button.lx1 < 0) then
				--Left side
				IFObj_fnSetPos(this.listbox,120,85)
			else
				--Right side
				IFObj_fnSetPos(this.listbox,-120,85)
			end

			IFObj_fnSetVis(this.listbox,1)
--			IFButton_fnSelect(this.cur_popup_functype[this.CurButton],1)
------------The Menu is Up, They've made a choice
		elseif (this.cont_menu_state == 1) then
			-- *
			-- Select input option and return to controller button selection
			-- *
			-- Unselect menu position, make menu disappear
			IFObj_fnSetVis(this.listbox,nil)
			this.cur_popup_functype = nil -- clear it out.

			local Selection = ifs_controller_listbox_contents[ifs_controller_listbox_layout.SelectedIdx]
			local ButtonIdx = Selection.showidx
--			print("ButtonIdx = ",ButtonIdx)
			
			-- Set the internal function_id representation for this choice
			ifs_opt_controller_SetEntry(this, this.cont_element_idx, ButtonIdx)

			-- Go back to the button selection			
			this.cont_menu_state=0
			this.CurButton = this.cont_element_idx
			IFObj_fnSetAlpha(this.buttons[this.CurButton],1.0)
			ifs_opt_controller_SetLineVisibility(this,1)
			ifs_opt_controller_fnMoveCursor(this)
		elseif (this.cont_menu_state == 2) then
			-- Accept current preset
			if ( not this.bApplyPresetSettingsNow ) then
				local idx = ifs_controller_preset_listbox_layout.SelectedIdx
				local wasCustom = (this.iPresetIdx == this.iNumPreset)
				local isCustom = (idx == this.iNumPreset)

				-- has user selected a preset other than custom?  check to see if 
				-- current preset was on custom.  if not, make sure the player knows 
				-- that he's about to lose his custom config
				if ( not wasCustom or isCustom ) then
					-- nothing to worry about.  move along.
				else -- (not isCustom)
					this.bApplyPresetSettingsNow = false
 					Popup_YesNo.CurButton = "no" -- default
 					Popup_YesNo.fnDone = ifs_opt_controller_fnPresetChangedPopupDone
 					AnimationMgr_AddAnimation(this.controller, {fTotalTime = 0.3, fStartAlpha = 1, fEndAlpha = 0.4,})
 					Popup_YesNo:fnActivate(1)
					gPopup_fnSetTitleStr(Popup_YesNo,"ifs.controls.askresetconfig")

 					-- not so attractive to see all the text below the box, but i think
 					-- it helps the player to remember what their current settings are.
 					-- get rid of the preset box
					ifs_opt_controller_ShowPresetListbox(this, nil)
					-- get rid of all the other text
					ifs_opt_controller_SetLineVisibility(this, nil)
					--ifs_opt_controller_GetAllEntries(this)
					--ifs_opt_controller_fnMoveCursor(this)
					--this.bApplyPresetSettingsNow = false

 					return
 				end
 			end
			ifs_opt_controller_ApplyPresetSettings(this)
		end
	end,

	Input_Back = function(this)
		if(this.cont_menu_state == 0) then
			if (gPlatformStr == "PC") and ScriptCB_GetShellActive() then
				-- rethink interface state, but don't leave
				this:Exit(false)
				this:Enter(true)
			else
				ifelm_shellscreen_fnPlaySound("shell_menu_exit")
				ScriptCB_PopScreen()
			end
		else
			IFObj_fnSetVis(this.listbox,nil)
			-- Go back to the button selection			
			this.cont_menu_state=0
			this.CurButton = this.cont_element_idx
			IFObj_fnSetAlpha(this.buttons[this.CurButton],1.0)
			ifs_opt_controller_SetLineVisibility(this,1)
			ifelm_shellscreen_fnPlaySound(this.cancelSound)
			ifs_opt_controller_ShowPresetListbox(this, nil)

		end
	end,

	Input_GeneralUp = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputUp(this)) then
			return
		end

		if(this.cont_menu_state == 2) then
			ListManager_fnNavUp(this.presetlistbox,gControllerPresets,ifs_controller_preset_listbox_layout)
		end

		if(gNoControllerChanges) then
			return
		end

		-- allow the user to change to a custom template without having to select it first
		--
		-- -- All other work for this case is done.
		--if(not this.bPresetIsCustom) then
		--	return
		--end

		if(this.cont_menu_state == 1) then
			ListManager_fnNavUp(this.listbox,ifs_controller_listbox_contents,ifs_controller_listbox_layout)
		elseif ((this.cont_menu_state == 0) and (Platform_btn_map[this.CurButton].conU ~= 0)) then
			ifelm_shellscreen_fnPlaySound(this.selectSound)
			
			-- these discriminatory practices against the number 20 must stop!
			--if (( this.iControlMode > 0) and ( Platform_btn_map[this.CurButton].conU == 20 ) ) then
			--	ifs_opt_controller_fnSetNextButton(this,Platform_btn_map[20].conU)	
			--else 
				ifs_opt_controller_fnSetNextButton(this,Platform_btn_map[this.CurButton].conU)	
			--end
		end
	end,

	Input_LTrigger = function(this)
		if((this.cont_menu_state == 1) and (not gNoControllerChanges)) then
			ListManager_fnPageUp(this.listbox,ifs_controller_listbox_contents,ifs_controller_listbox_layout)
		elseif (this.cont_menu_state == 2) then
			ListManager_fnPageUp(this.presetlistbox,gControllerPresets,ifs_controller_preset_listbox_layout)
		end
	end,
	
	Input_GeneralDown = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputDown(this)) then
			return
		end

		if(this.cont_menu_state == 2) then
			print("Preset down")
			ListManager_fnNavDown(this.presetlistbox,gControllerPresets,ifs_controller_preset_listbox_layout)
		end

		if(gNoControllerChanges) then
			return
		end

		-- allow the user to change to a custom template without having to select it first
		--
		-- -- All other work for this case is done.
		--if(not this.bPresetIsCustom) then
		--	return
		--end

		if(this.cont_menu_state == 1) then
			ListManager_fnNavDown(this.listbox,ifs_controller_listbox_contents,ifs_controller_listbox_layout)
		elseif ((this.cont_menu_state == 0) and (Platform_btn_map[this.CurButton].conD ~= 0)) then
			ifelm_shellscreen_fnPlaySound(this.selectSound)
			--if( ( this.iControlMode > 0) and ( Platform_btn_map[this.CurButton].conD == 20  ) ) then
			--	ifs_opt_controller_fnSetNextButton(this,Platform_btn_map[20].conD)	
			--else
				ifs_opt_controller_fnSetNextButton(this,Platform_btn_map[this.CurButton].conD)	
			--end
			
		end
	end,

	Input_RTrigger = function(this)
		if((this.cont_menu_state == 1) and (not gNoControllerChanges)) then
			ListManager_fnPageDown(this.listbox,ifs_controller_listbox_contents,ifs_controller_listbox_layout)
		elseif (this.cont_menu_state == 2) then
			ListManager_fnPageDown(this.presetlistbox,gControllerPresets,ifs_controller_preset_listbox_layout)
		end
	end,

	Input_GeneralLeft = function(this)
		if(gNoControllerChanges) then -- or (not this.bPresetIsCustom)) then  -- presets allow change of sensitivity now
			return
		end

		if((this.cont_menu_state == 0) and (Platform_btn_map[this.CurButton].conL ~= 0)) then
			
			ifs_opt_controller_fnSetNextButton(this,Platform_btn_map[this.CurButton].conL)	
			
			ifelm_shellscreen_fnPlaySound(this.selectSound)
		else
			if((this.cont_menu_state == 0) and (Platform_btn_map[this.CurButton].name == "lookslidex")) then
				ifelm_shellscreen_fnPlaySound(this.selectSound)
				if(this.iControllerScaleX > 1) then
					this.iControllerScaleX = this.iControllerScaleX - 1
				else
					this.iControllerScaleX = 10
				end
				ScriptCB_SetControlScale(0, this.iControllerScaleX)
				ifs_opt_controller_UpdateSensitivity(this, "x")
			elseif((this.cont_menu_state == 0) and (Platform_btn_map[this.CurButton].name == "lookslidey")) then
				ifelm_shellscreen_fnPlaySound(this.selectSound)
				if(this.iControllerScaleY > 1) then
					this.iControllerScaleY = this.iControllerScaleY - 1
				else
					this.iControllerScaleY = 10
				end
				ScriptCB_SetControlScale(1, this.iControllerScaleY)
				ifs_opt_controller_UpdateSensitivity(this, "y")
			elseif((this.cont_menu_state == 0) and (Platform_btn_map[this.CurButton].name == "yflip")) then
				ifelm_shellscreen_fnPlaySound(this.selectSound)
				if(ScriptCB_GetYAxisFlip() == 1) then
					ScriptCB_SetYAxisFlip(0)
					IFText_fnSetString(this.flipStatus,"ifs.controls.General.FlipYAxisOff")
				else
					ScriptCB_SetYAxisFlip(1)
					IFText_fnSetString(this.flipStatus, "ifs.controls.General.FlipYAxisOn")
				end
			end
		end
	 end,

	Input_GeneralRight = function(this)
		if(gNoControllerChanges) then -- or (not this.bPresetIsCustom)) then  -- presets allow change of sensitivity now
			return
		end

		if((this.cont_menu_state == 0) and (Platform_btn_map[this.CurButton].conR ~= 0)) then
			
			ifs_opt_controller_fnSetNextButton(this,Platform_btn_map[this.CurButton].conR)	
			
			ifelm_shellscreen_fnPlaySound(this.selectSound)
		else
			if((this.cont_menu_state == 0) and Platform_btn_map[this.CurButton].name == "lookslidex") then
				ifelm_shellscreen_fnPlaySound(this.selectSound)
				if(this.iControllerScaleX < 10) then
					this.iControllerScaleX = this.iControllerScaleX + 1
				else
					this.iControllerScaleX = 1
				end
				ScriptCB_SetControlScale(0, this.iControllerScaleX)
				ifs_opt_controller_UpdateSensitivity(this, "x")
			elseif((this.cont_menu_state == 0) and Platform_btn_map[this.CurButton].name == "lookslidey") then
				ifelm_shellscreen_fnPlaySound(this.selectSound)
				if(this.iControllerScaleY < 10) then
					this.iControllerScaleY = this.iControllerScaleY + 1
				else
					this.iControllerScaleY = 1
				end
				ScriptCB_SetControlScale(1, this.iControllerScaleY)
				ifs_opt_controller_UpdateSensitivity(this, "y")
			elseif((this.cont_menu_state == 0) and Platform_btn_map[this.CurButton].name == "yflip") then
				ifelm_shellscreen_fnPlaySound(this.selectSound)
				if(ScriptCB_GetYAxisFlip() == 0) then
					ScriptCB_SetYAxisFlip(1)
					IFText_fnSetString(this.flipStatus,"ifs.controls.General.FlipYAxisOn")
				else
					ScriptCB_SetYAxisFlip(0)
					IFText_fnSetString(this.flipStatus, "ifs.controls.General.FlipYAxisOff")
				end
			end
		end
	 end,

	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt) -- call default

		-- HACK - GetExtent seems to return 0 the first time thru. We need
		-- to keep calling it until things stabilize.
		if(not this.bMovedItems) then
			ifs_opt_controller_SetPresetText(this) -- Update info
		end

		-- Bounce cursor only if moving it around.
		if(this.cont_menu_state == 0) then
			gButton_CurSizeAdd = gButton_CurSizeAdd + fDt * gButton_CurDir
			if(gButton_CurSizeAdd > 1) then
				gButton_CurSizeAdd = 1
				gButton_CurDir = -math.abs(gButton_CurDir)
			elseif (gButton_CurSizeAdd < 0.3) then
				gButton_CurSizeAdd = 0.3
				gButton_CurDir = math.abs(gButton_CurDir)
			end
			gButtonWindow_fnSetSize(this.cursor,this.cursor.w + 10 * gButton_CurSizeAdd, this.cursor.h + 5 * gButton_CurSizeAdd)
		end
	end,

	-- Debug code-- pressing L2 will dump out the bindings, suitable for
	-- pasting into the preset list
	Input_LTrigger2 = function(this)
		if(not gFinalBuild) then
			local k,v
			print("		btndefs = {")
			-- Get all the current bindings, print them out
			for k,v in Platform_btn_map do
				if((v.type ~= 5) and (v.type ~= 99)) then 
					-- Get the Global functionID assigned to this button
					local iCurFunc = ScriptCB_GetFunctionIdForButtonId(k,this.iControlMode)

					if(v.name == "lang") then
						--get(stick,mode)
						iCurFunc = gAnalogButtonFunction0 + ScriptCB_GetFunctionIdForAnalogId(0, this.iControlMode)
					elseif (v.name == "rang") then
						
						iCurFunc = gAnalogButtonFunction0 + ScriptCB_GetFunctionIdForAnalogId(1, this.iControlMode)
					end

					print("			{ " .. k .. " , " .. iCurFunc .. " },")
				end
			end -- for k,v in Platform_btn_map do
			print("		},")
		end -- not gFinal
	end,
}


-- *******************************
-- UTILITY FUNCTIONS FOR THIS MENU
-- *******************************

function ifs_opt_controller_ApplyPresetSettings(this)
	this.iPresetIdx = ifs_controller_preset_listbox_layout.SelectedIdx
	this.bPresetIsCustom = (this.iPresetIdx == this.iNumPreset)

	-- Go thru and apply settings now
	if(not this.bPresetIsCustom) then
		local Mappings = gControllerPresets[this.iPresetIdx].btndefs

		local i,j,k,v
		j = 1
		for k,v in Platform_btn_map do
			if((v.type ~= 5) and (v.type ~= 99)) then 
				if ( v.name ~= "bsel" and v.name ~= "bstr" ) then
					-- Get the Global functionID assigned to this button
					ScriptCB_SetFunctionIdForButtonId(k, Mappings[j][2], this.iControlMode)

					if(v.name == "lang") then
						ScriptCB_SetFunctionIdForAnalogId(0, this.iControlMode, Mappings[j][2] - gAnalogButtonFunction0)
					elseif (v.name == "rang") then
						ScriptCB_SetFunctionIdForAnalogId(1, this.iControlMode, Mappings[j][2] - gAnalogButtonFunction0)
					end

					bMatch = bMatch and (CheckMap[j][2] == iCurFunc)
				end
				j = j + 1 -- move on in parallel array
			end -- type ~= 5
		end -- k,v loop over Platform_btn_map

		ScriptCB_SetYAxisFlip(gControllerPresets[this.iPresetIdx].yFlip)
	end

	ifs_opt_controller_SetPresetText(this)
	ifs_opt_controller_ShowPresetListbox(this, nil)
	this.cont_menu_state=0
	this.CurButton = this.cont_element_idx
	IFObj_fnSetAlpha(this.buttons[this.CurButton],1.0)
	ifs_opt_controller_GetAllEntries(this)
	ifs_opt_controller_fnMoveCursor(this)
	this.bApplyPresetSettingsNow = false
end

function ifs_opt_controller_UpdateSensitivity(this, axis)
	if ( axis == "x" ) then
		this.iControllerScaleX = ScriptCB_GetControlScale(0)
		local ScaleUStr = ScriptCB_usprintf("ifs.controls.looksensitivityX",
											ScriptCB_tounicode(string.format("%d",this.iControllerScaleX)))
		IFText_fnSetUString(this.SensitivityTextX,ScaleUStr)
	elseif ( axis == "y" ) then
		this.iControllerScaleY = ScriptCB_GetControlScale(1)
		local ScaleUStr = ScriptCB_usprintf("ifs.controls.looksensitivityY",
											ScriptCB_tounicode(string.format("%d",this.iControllerScaleY)))
		IFText_fnSetUString(this.SensitivityTextY,ScaleUStr)
	end
end

function ifs_opt_controller_GetAllEntries(this)
	local k,v
	-- Updates stored label ID's and onscreen values based on internal values
	for k,v in Platform_btn_map do
		-- Make sure we're dealing with a normal button (not the special case y-flip)
		if((v.type ~= 5) and (v.type ~= 99)) then 
			-- Get the Global functionID assigned to this button
			v.func = ScriptCB_GetFunctionIdForButtonId(k,this.iControlMode)
			-- Set the internal string to match the functionID

			local ShowIdx = v.func
			--"ifs.controls.General.SquadRight",			-- 14
			--Hack for the squad controls
			-- unhacked for squad controls!!!
			--if ( (ShowIdx > gSquadCommandButtonFunction0) and (ShowIdx <= gSquadCommandButtonFunction0+4) ) then
			--	ShowIdx = gSquadCommandButtonFunction0
			--end

			if(v.name == "lang") then
				--get(stick,mode)
				-- the get function will return -1 if the stick is mapped to NONE.
				-- in that case, we need it to print out NONE properly.
				local funcIdx = ScriptCB_GetFunctionIdForAnalogId(0, this.iControlMode)
				if ( funcIdx < 0 ) then
					ShowIdx = funcIdx
				else
					ShowIdx = gAnalogButtonFunction0 + funcIdx + gNumButtonFunctionsPerMode * this.iControlMode
				end
			elseif (v.name == "rang") then
				local funcIdx = ScriptCB_GetFunctionIdForAnalogId(1, this.iControlMode)
				if ( funcIdx < 0 ) then
					ShowIdx = funcIdx
				else
					ShowIdx = gAnalogButtonFunction0 + funcIdx + gNumButtonFunctionsPerMode * this.iControlMode
				end
			else
				if(ShowIdx > 0) then
					ShowIdx = ShowIdx + gNumButtonFunctionsPerMode * this.iControlMode
				end
			end
			
			if(ShowIdx > 0) then
				local buttonstr = 
					ScriptCB_usprintf(gButtonNames[k], ScriptCB_getlocalizestr(gButtonFunctionStrings[ShowIdx]))
				IFText_fnSetUString(this.lines[k].label, buttonstr)
			else
				local buttonstr = ScriptCB_usprintf(gButtonNames[k], ScriptCB_getlocalizestr("ifs.controls.General.none"))
				IFText_fnSetUString(this.lines[k].label, buttonstr)
			end
			IFObj_fnSetPos(this.lines[k].label, v.lx1, v.ly1)
			--			end
		end
		-- change the color on the disabled fields
		if (v.name == "dpadl" or v.name == "dpadr" or v.name == "bsel" or v.name == "bstr") then
			IFObj_fnSetColor(this.lines[k].label, 140, 140, 140)
		end
	end

	-- Hack, set text for Start/Back directly
	local buttonstr = ScriptCB_usprintf(gButtonNames[8], ScriptCB_getlocalizestr("ifs.controls.General.Map"))
	IFText_fnSetUString(this.lines[8].label, buttonstr)
	buttonstr = ScriptCB_usprintf(gButtonNames[9], ScriptCB_getlocalizestr("ifs.controls.General.Pause"))
	IFText_fnSetUString(this.lines[9].label, buttonstr)
	
	-- Updates visual status of y-axis flip
	if(ScriptCB_GetYAxisFlip() == 1) then
		IFText_fnSetString(this.flipStatus,"ifs.controls.General.FlipYAxisOn")
	else
		IFText_fnSetString(this.flipStatus,"ifs.controls.General.FlipYAxisOff")	
	end

	ifs_opt_controller_UpdateSensitivity(this, "x")
	ifs_opt_controller_UpdateSensitivity(this, "y")
end

function ifs_opt_controller_SetEntry(this, buttonIdx, menuIdx)
	-- Sets internal function id based on buttonIndex, the menuIndex selected 
	-- and the type of menu (implied by buttonIndex)
	
	-- if there is another button already set to this function, make that
	-- button's function 'none'.
	local k,v
	for k,v in Platform_btn_map do
		if (v.type == 3) then
			local stickIdx = 0
			if (Platform_btn_map[k].name == "rang") then
				stickIdx = 1
			end
			if (ScriptCB_GetFunctionIdForAnalogId(stickIdx, this.iControlMode) + gAnalogButtonFunction0 == menuIdx and k ~= menuIdx ) then
				ScriptCB_SetFunctionIdForAnalogId(stickIdx, this.iControlMode, -1)
			end
			--print ("menuidx:", menuIdx, "k:", k, "analogID:", ScriptCB_GetFunctionIdForAnalogId(k, this.iControlMode))
		elseif (v.type == 1) then
			if (ScriptCB_GetFunctionIdForButtonId(k, this.iControlMode) == menuIdx and k ~= menuIdx) then
				ScriptCB_SetFunctionIdForButtonId(k, 0, this.iControlMode)
			end
		end
	end
	
	local type = Platform_btn_map[buttonIdx].type
	if(type == 3) then 
		--analog stick
		--set(stick,mode,function)
		if(Platform_btn_map[buttonIdx].name == "lang") then
			ScriptCB_SetFunctionIdForAnalogId(0, this.iControlMode, menuIdx - gAnalogButtonFunction0);
		else
			ScriptCB_SetFunctionIdForAnalogId(1, this.iControlMode, menuIdx - gAnalogButtonFunction0);
		end
	else
		--some type of digital button
--		print("JV- SettingFunctionForButton: buttonIdx, Type, menuIdx=", buttonIdx,type,menuIdx)
		ScriptCB_SetFunctionIdForButtonId(buttonIdx, menuIdx, this.iControlMode)
	end
	
	-- Also update the onscreen text based on this change
	ifs_opt_controller_GetAllEntries(this)
	this.iPresetIdx = nil -- clear this out so we force-rebuild it.
	ifs_opt_controller_SetPresetText(this)
end


-- *****************
--       DATA
-- *****************

vbutton_layout_functype_a_vehunit = {
	FlatButtons = 1,
	yTop = -30,
	yHeight = 16,
	ySpacing  = 2,
	width = 150,
	font = "gamefont_small",
	buttonlist = { 
		{ tag = 1, string = "ifs.controls.General.Move_Strafe", },
		{ tag = 2, string = "ifs.controls.General.Move_Turn", },
		{ tag = 3, string = "ifs.controls.General.FreeLook", },
	},
	nocreatebackground = 1,
}
 
-- *********************
-- INITIALIZATION SCRIPT
-- *********************
-- Call the creator when we parse this file for first time.
ifs_opt_controller_CreateElements(ifs_opt_controller)
ifs_opt_controller_CreateElements = nil

ifs_opt_controller.bg = nil -- wipe out the annoying (white) background
AddIFScreen(ifs_opt_controller,"ifs_opt_controller")
ifs_opt_controller = DoPostDelete(ifs_opt_controller)

-- PrintIFObjContainer(ifs_opt_controller,0, "ifs_opt_controller")