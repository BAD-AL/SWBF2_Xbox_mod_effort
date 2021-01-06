--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


--This is the PC version of the charselect, which includes elements of the spawndisplay
-- all the if mode stuff has been removed, as there is no splitscreen for PC

-- Helper function. Builds the chunks for this screen programatically
-- (i.e. based on screensize). It makes and shoves things into the
-- 'this.Info' block, which is a container aligned to the right-middle
-- of the screen. Thus, within its space, x=0 is the right edge,
-- x=-100 is to its left. y=0 is the middle of the screen, y=-100 is
-- above that, y=100 is below.

function ifs_pc_SpawnSelect_fnBuildScreen(this, mode)

	-- Make a container that's aligned to the left-top of the screen
	-- to shove our stuff into
	this.Info = NewIFContainer {
		ScreenRelativeX = 0.0,
		ScreenRelativeY = 0.0,
		inert = 1, -- delete from Lua memory once pushed to C
	}

	this.BotInfo = NewIFContainer {
		ScreenRelativeX = 1.0,
		ScreenRelativeY = 1.0,
		inert = 1, -- delete from Lua memory once pushed to C
	}

	local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
	local MAX_CLASS_SLOTS = 10 -- must match MAX_CLASS_SLOTS in pcSpawnDisplay.h
	
	--make sure there's at least 7 slots, but not more than MAX_CLASS_SLOTS, depending on how many classes are available in the map
	local numSlots = math.min( math.max(7, GetTeamClassCount(1), GetTeamClassCount(2)), MAX_CLASS_SLOTS )
	
	local numClassesTeam1 = GetTeamClassCount(1)
	local numClassesTeam2 = Get
	
	local boxw, boxh, texth
	-- Scale a box based on screensize
	boxw = w * 0.35
	boxh = h * 0.03--could be too small
	local sideh =	h * 0.15
	local sidew =   w * 0.1    
	
	local okcancelw = w * 0.2
	local okcancelh = h * 0.03
	
	local unitcountw = w * 0.3
	local unitcounth = h * 0.2	
	
	local fontsize = "gamefont_tiny"
	local smallfontsize = "gamefont_tiny"
	local screenWidth, screenHeight = ScriptCB_GetScreenInfo()
	if screenHeight > 600 and screenHeight < 960 then
		fontsize = "gamefont_medium"
		smallfontsize = "gamefont_tiny"
	elseif screenHeight >= 960 then
		fontsize = "gamefont_large"
		smallfontsize = "gamefont_medium"
	end
	
	local SideXOffset = w * .1
	local SideYOffest = h * .17

	local buttonlabelheight = ScriptCB_GetFontHeight(fontsize) + 3				--magic number for a little padding
	local SlotYOffset = 15 + buttonlabelheight  --compensate for label height
	local SlotUnitNameOffsetX = w * .05 --will need the icon offset eventually
	local SlotTextOffsetX = SlotUnitNameOffsetX + 20

	local textheight = h/numSlots - boxh - buttonlabelheight

	local popupWidth  = w * .3
	local popupHeight = h * .15
	local leftsideRot = 35
--Make two buttons for the two sides, (a frame and an bitmap for each)
	--These are the frames
	
	Icon0PosX = w/2 -- - sidew/2
	Icon1PosX = w/2 -- + sidew/2
	
	this.Info.SideIcon0 = NewBorderRect 
	{
			ZPos = 190, -- behind most
			x = w/2, 
			y = SideYOffest,
			width = sidew*2,
			height = sideh,
			alpha = 0,	-- invisible hotspot, here we come.
	}
	this.Info.SideIcon1 = NewBorderRect 
	{
			ZPos = 190, -- behind most
			x = w/2, 
			y = SideYOffest,
			width = sidew * 2,
			height = sideh,
			alpha = 0,
	}
	
--The two models
	this.Info.SideModel0 = NewIFModel {
		x = 0.0, y = 0.0,
--		x = Icon0PosX, y = SideYOffest,
		scale = 1.0,
		OmegaY = -0.3,
		lighting = 1,
		ColorR = 76, ColorG = 180, ColorB = 255,
	}
	this.Info.SideModel1 = NewIFModel {
		x = 0.0, y = 0.0,
--		x = Icon1PosX, y = SideYOffest,
		scale = 1.0,
		OmegaY = -0.3,
		lighting = 1,
		ColorR = 76, ColorG = 180, ColorB = 255,
	}
	
	
--Make two buttons for the Accept & Cancel button
--And the text that goes in them
	local okYPos = h - 0.1*h
	this.Info.Ok = NewPCIFButton
	{
		x = w/2,
		y = okYPos,

		btnw = okcancelw, 
		btnh = okcancelh,
		font = "gamefont_large", 
		bg_width = okcancelw,
		string = "ifs.SpawnDisplay.Spawn",
	}

	--displays the unit count, and optionally some extra info as to why
	--a character cannot select a character class
	this.Info.UnitCount = NewIFText
	{
		x = w/2 - unitcountw/2,
		y = okYPos - unitcounth,
		font = fontsize,
		halign = "hcenter",
		valign = "bottom",
	
		textw = unitcountw, -- usable area for text
		texth = unitcounth,
		font = fontsize,
		style = "shadow",
		ColorR = 255, ColorG = 255, ColorB = 255, -- white
		flashy = 0,
	}
	

	local i
	for i = 0,MAX_CLASS_SLOTS do
	
		local tag = string.format("SlotWindow%d",i)

		this.Info[tag] = NewButtonWindow 
		{ 
			ZPos = 200, 
			x = SlotUnitNameOffsetX +  SlotUnitNameOffsetX * 2.5,
			y = SlotYOffset + i * ( boxh + textheight + buttonlabelheight + 2 ),
			--ScreenRelativeX = 0.0, -- center
			--ScreenRelativeY = 0.0, 
			width = boxw,
			height = textheight + boxh,
			titleText = "ifs.profile.list",
			font = fontsize,
			buttonHeightPad = 1,
			buttonGutter = 1,
			titleOffsetX = 5,
		}
		
		this.Info[tag].bHotspot = 1
		this.Info[tag].fHotspotX = -0.5 * (boxw)
		this.Info[tag].fHotspotY = -0.5 * (textheight + boxh) - buttonlabelheight
		this.Info[tag].fHotspotW = boxw
		this.Info[tag].fHotspotH = textheight + boxh + buttonlabelheight

		this.Info[tag].InfoText = NewIFText  --the equipment/weapon text
		{  
			width = boxw,
			
			halign = "hcenter",
			valign = "vcenter",
			textw = boxw - boxh, -- usable area for text
			texth = textheight,
			font = smallfontsize,
			string = "InfoText",
			ColorR = 255, ColorG = 255, ColorB = 255, -- white
			flashy = 0,
		}
	
		--how many lines of text to squeeze into the info box
		local numLines = 4
		if numSlots > 7 and screenHeight < 960 then
			numLines = 3
		end
		
		local textscale = textheight / (numLines * ScriptCB_GetFontHeight(smallfontsize))
		--if textscale < 1 then
			this.Info[tag].InfoText.HScale = textscale
			this.Info[tag].InfoText.VScale = textscale
		--end
	end
end

function ifs_pc_spawnselect_animateicons(activeSide)
	local this = ifs_pc_SpawnSelect
	
	this.activeSide = activeSide

	local w,h = ScriptCB_GetSafeScreenInfo()
	local SideYOffest = h * .17
	local Icon0PosX = w/2 -- - w*0.05
	local Icon1PosX = w/2 -- + w*0.05
	
	local resScale = w / 800
	
	if(activeSide < 0.5) then
		AnimationMgr_AddAnimation(this.Info.SideModel0,{ fTotalTime = 0.75,fStartAlpha = 0.0, fEndAlpha = 1,
									fStartX = Icon0PosX,fEndX = Icon0PosX,
									fStartY = SideYOffest,fEndY = SideYOffest,
									fStartW = 0.25*resScale,fStartH = 0.25*resScale,fEndW   = 0.5*resScale,fEndH   = 0.5*resScale,})
		AnimationMgr_AddAnimation(this.Info.SideModel1,{ fTotalTime = 0.75,fStartAlpha = 1, fEndAlpha = 0.0,
									fStartX = Icon1PosX,fEndX = Icon1PosX,
									fStartY = SideYOffest,fEndY = SideYOffest,
									fStartW = 0.5*resScale,fStartH = 0.5*resScale,fEndW   = 0.25*resScale,fEndH   = 0.25*resScale,})
	else
		AnimationMgr_AddAnimation(this.Info.SideModel0,{ fTotalTime = 0.75,fStartAlpha = 1, fEndAlpha = 0.0,
									fStartX = Icon0PosX,fEndX = Icon0PosX,
									fStartY = SideYOffest,fEndY = SideYOffest,
									fStartW = 0.5*resScale,fStartH = 0.5*resScale,fEndW   = 0.25*resScale,fEndH   = 0.25*resScale,})
		AnimationMgr_AddAnimation(this.Info.SideModel1,{ fTotalTime = 0.75,fStartAlpha = 0.0, fEndAlpha = 1,
									fStartX = Icon1PosX,fEndX = Icon1PosX,
									fStartY = SideYOffest,fEndY = SideYOffest,
									fStartW = 0.25*resScale,fStartH = 0.25*resScale,fEndW   = 0.5*resScale,fEndH   = 0.5*resScale,})
	end
	
	-- make them spin fast for a bit
	IFModel_fnSetOmegaY(this.Info.SideModel0,-10)
	IFModel_fnSetOmegaY(this.Info.SideModel1,-10)
	this.IconModelFastMode = 1
end

ifs_pc_SpawnSelect = NewIFShellScreen 
{
	nologo = 1,
	bNohelptext_accept = 1, -- we have our own
	bNohelptext_backPC = nil,
	bDimBackdrop = nil,



	-- Actual contents are created in ifs_charselect_fnBuildScreen
	-- Note: for now, the exe is handling all the inputs/events, so this
	-- screen has no Enter/Exit/Update/Input handlers. It does have an
	-- Input_Back handler to override the base class's default functionality
	-- (go to previous screen)
	
	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		
		AnimationMgr_ClearAnimations(this.Info.SideModel0)
		AnimationMgr_ClearAnimations(this.Info.SideModel1)
		ifs_pc_spawnselect_animateicons(this.activeSide or 0)	
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
	
	Update = function(this,fDt)
 		-- Call default base class's update function (make button bounce)
 		gIFShellScreenTemplate_fnUpdate(this,fDt)
 		-- if the models are done animating, slow down the rotations
 		if(this.IconModelFastMode and not this.Info.SideModel0.bAnimActive) then		
			IFModel_fnSetOmegaY(this.Info.SideModel0,-0.3)
			IFModel_fnSetOmegaY(this.Info.SideModel1,-0.3)
			this.IconModelFastMode = nil
		end		
	end,
	
}

--Call me from C++ to create the screen and cleanup afterwards
function ifs_pc_SpawnSelect_fnInit()
	ifs_pc_SpawnSelect_fnBuildScreen(ifs_pc_SpawnSelect, 0)
	AddIFScreen(ifs_pc_SpawnSelect,"ifs_pc_SpawnSelect")
	
	ifs_pc_SpawnSelect_fnBuildScreen = nil
	ifs_pc_SpawnSelect_fnInit = nil
end
	
