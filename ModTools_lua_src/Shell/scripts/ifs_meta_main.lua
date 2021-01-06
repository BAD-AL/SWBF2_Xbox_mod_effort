--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

--------------------------------------------------------------------
--
-- Interface screen for the metagame.
-- THIS FILE CREATES THE IFS_META_MAIN SCREEN ... AND THAT'S ALL!
--
--------------------------------------------------------------------

rotate_y = 30
z_pos_base = 100

ifs_meta_main_vbutton_layout = {
--	yTop = -70,
	xWidth = 400,
	width = 400,
	xSpacing = 10,
	ySpacing = 5,
	font = gMenuButtonFont,
	buttonlist = { 
		{ tag = "resume", string = "common.resume", },
		{ tag = "load", string = "ifs.meta.load.load", },
		{ tag = "quit", string = "common.quit", },
	},
	title = "ifs.sp.meta",
	rotY = 35,
}

--------------------------------------------------------------------
-- OnEntry helper function: adds metagame_GetNumPlanets() planets to
-- the container 'params.dest', named 'planet1' .. 'planetn'.
-- fnMovePlanets will enable/disable these as necessary. CenterX,
-- Width are (0-based) chunks of size that determine what area of the
-- screen it can work in.
function ifs_meta_main_fnAddGalaxyPlanets(dest,CenterX,Width)
	local galaxy_w, galaxy_h, wFactor = ScriptCB_GetSafeScreenInfo() -- of the usable screen
	Width = Width * wFactor
	local MaxPlanets = metagame_GetNumPlanets()
	local heightper, ygutter = metagame_GetPlanetPreviewSize()
	heightper = heightper * 0.5 -- half-scale, to go from -heightper .. heightper
	local iconsize = heightper * 0.5
	local RingSize = heightper * 1.6
	local HalfWidth = Width * 0.5
	local RingHeight = HalfWidth
	local PlanetName_Y = 0
	local ChargeMeter_Y = 0
	if(gPlatformStr ~= "PS2") then
		RingHeight = HalfWidth * 0.9
		if( wFactor ~= 1 ) then
			RingHeight = HalfWidth * 0.7
		end
	end

	-- move to center of the screen	
	if( wFactor ~= 1 ) then
		dest.x = CenterX - 8 + 100 -- owner icons are right of planet
	else
		dest.x = CenterX - 8 -- owner icons are right of planet
	end
	
	if(gPlatformStr == "PC") then
		dest.y = RingHeight * 0.5 -- Set center
		PlanetName_Y = -15
		ChargeMeter_Y = 10
	else
		dest.y = RingHeight - 100 -- Set center
		PlanetName_Y = 0
		ChargeMeter_Y = 0
	end

	local NumPlanets = metagame_GetNumPlanets()
	local i

	-- Gotta calculate math.max-X to make this fit
	local MaxX = 0.1
	for i = 1,NumPlanets do
		if(MaxX < math.abs(metagame_state.PlanetPositions[i].mapx)) then
			MaxX = math.abs(metagame_state.PlanetPositions[i].mapx)
		end
	end

	for i = 1,NumPlanets do
		-- Scale in galaxy
		local XPos = (metagame_state.PlanetPositions[i].mapx / MaxX) * (Width *0.42)
		local YPos = (metagame_state.PlanetPositions[i].mapy / 150) * (gMetagameGalaxySize * 0.3)
		
		if(gPlatformStr == "PS2") then
			YPos = YPos + 10
		--elseif(gPlatformStr == "XBox") then		
		--elseif(gPlatformStr == "PC") then		
		end		
	
		-- Container for the whole thing so we can hide/enable it quickly
		dest[i] = NewIFContainer {
			x = XPos, y = YPos,
			ZPos = z_pos_base + 20,
			rotY = rotate_y,
		}

		dest[i].type = "galaxy"
		dest[i].tag = i

		-- Add the pieces to each container
		dest[i].icon = NewIFImage {
			ZPos = z_pos_base + 25, inertUVs = 1,
			localpos_l = -heightper, localpos_t = -heightper,
			localpos_b =  heightper, localpos_r =  heightper,
		}

		dest[i].model = NewIFModel {

			x = 1, -- fit better in background
			ZPos = z_pos_base + 20,
			scale = 0.18,
			model = "planet_x_icon",
			depth = metagame_state.PlanetPositions[i].depth,
			lighting = 1,
		}

		dest[i].hexagon = NewIFModel {
			x = 1, -- fit better in background
			ZPos = z_pos_base + 20,
			model = "planet_KAS_halo",
			depth = metagame_state.PlanetPositions[i].depth,
			--texture = "planetgraphic_halo"
		}

		dest[i].bonus = NewIFModel {
			x = 1, -- fit better in background
			ZPos = z_pos_base + 20,
			model = "planet_cursor",
			depth = metagame_state.PlanetPositions[i].depth,
			lighting = 1,
		}

		dest[i].cursor = NewIFModel {
			x = 1, -- fit better in background
			ZPos = z_pos_base + 20,
			model = "planet_cursor",
			depth = metagame_state.PlanetPositions[i].depth,
			alpha = 1.0,
			--texture = "planetgraphic_halo"
		}

		-- Add the pieces to each container
		dest[i].iconbg = NewIFImage {
			ZPos = z_pos_base + 28, inertUVs = 1,
			localpos_l = -heightper, localpos_t = -heightper,
			localpos_b =  heightper, localpos_r =  heightper,
		}

		-- Place ring in front of planet
		dest[i].ring = NewIFImage {
			ZPos = z_pos_base + 15, inertUVs = 1, texture = "hud_icon_flash",
			localpos_l = -RingSize, localpos_t = -RingSize,
			localpos_b =  RingSize, localpos_r =  RingSize,
		}

		-- Planet's name
		dest[i].label = NewIFText {
			y = heightper - (16/metagame_state.PlanetPositions[i].depth) + metagame_state.PlanetPositions[i].name_y + PlanetName_Y,
			font = "gamefont_tiny",
			ZPos = z_pos_base + 15,
			nocreatebackground = 1,
			--z = metagame_state.PlanetPositions[i].depth * 100,
		}

		-- number of Votes for this planet (multiplayer only)
		dest[i].numVotes = NewIFText {
			y = -14,
			font = "gamefont_small",
			ZPos = z_pos_base + 15,
			ColorR = 255, ColorG = 255, ColorB = 255,
			nocreatebackground = 1,
		}

		-- Planet's name (dropshadow'd)
		dest[i].label2 = NewIFText {
			ZPos = z_pos_base + 18,
			y = heightper + 2 -(16/metagame_state.PlanetPositions[i].depth) + metagame_state.PlanetPositions[i].name_y + PlanetName_Y,
			font = "gamefont_tiny",
			-- string = v.LocalizeName,
			ColorR = 0, ColorG = 0, ColorB = 0,
			nocreatebackground = 1,
			--z = metagame_state.PlanetPositions[i].depth * 100,
		}
		dest[i].label2.x = dest[i].label2.x + 1 -- make a slight dropshadow

		-- Add in owner icons for capital map.
		dest[i].owner1 = NewIFImage {
			ZPos = z_pos_base + 22, x = heightper, y =  -iconsize, -- inertUVs = 1,
			localpos_l =         0, localpos_t = -iconsize,
			localpos_r = heightper, localpos_b =  iconsize,
		}

		-- Faction planets have just 1 owner. Rest have 2.
		if((i ~= 1) and (i ~= NumPlanets)) then
			dest[i].owner2 = NewIFImage {
				ZPos = z_pos_base + 22, x = heightper, y = -iconsize + (heightper * 1.2), -- inertUVs = 1,
				localpos_l = 0,         localpos_t = -iconsize,
				localpos_r = heightper, localpos_b =  iconsize,
			}
		else
			if( i == 1 ) then
				pos_x = Width * -0.13
				pos_y = -20
			else
				pos_x = Width * 0.1
				pos_y = -30
			end			
			local j = 1
			local ChargeMeter = NewIFContainer { }
			for j = 1, 4 do
				newChargeMeterItem = NewIFImage {
					ZPos = z_pos_base + 22, 
					x = pos_x, 
					y = pos_y + (10+ChargeMeter_Y) * j, -- inertUVs = 1,
					localpos_l = 0,         localpos_t = -iconsize,
					localpos_r = heightper, localpos_b =  iconsize,
					--rotX = 0, rotY = 0, rotZ = 0,
				}
				ChargeMeter[j] = newChargeMeterItem
				IFImage_fnSetTexture(ChargeMeter[j], "oval_icon_empty")
				--IFObj_fnSetVis(ChargeMeter[j], nil)
				--IFObj_fnSetAlpha(ChargeMeter[j], 0.3)
			end
			--IFObj_fnSetVis(ChargeMeter, nil)
			dest[i].charge_meter = NewIFContainer { }			
			dest[i].charge_meter = ChargeMeter			
		end -- not a faction planet
	end -- loop over all planets
end

-- OnEntry helper function: adds items for the 'Attack planet'
-- mini-carousel. CenterX, Width are (0-based) chunks of size that
-- determine what area of the screen it can work in.
function ifs_meta_main_fnAddAttackItems(this,CenterX,Width)
	local w,h,wFactor = ScriptCB_GetSafeScreenInfo() -- of the usable screen

	local HalfWidth = Width * 0.5
	-- The half-size (around the center) of the large and small
	-- previews. These should sum to about 0.5 to make everything fit
	-- (over 0.5 means safezones will be exceeded)
	local LargeSize = Width * 0.55
	local SmallSize = Width * 0.08
	local LargeScale = 0.020
	local SmallScale = 0.03

	if(gPlatformStr == "XBox") then
		LargeSize = LargeSize * 0.8
		SmallSize = SmallSize * 0.9
		LargeScale = 0.055
		SmallScale = 0.035
	end

	-- Store for later
	this.fLargeSize = LargeSize
	this.fSmallSize = SmallSize
	this.fLargeScale = LargeScale
	this.fSmallScale = SmallScale

	this.AttackItems.x = CenterX + 170
	this.AttackItems.y = 170

	this.AttackItems.ZPos = z_pos_base + 10

	local modelc_x = 20
	local modelc_y = -SmallSize - 55
	local planetname_x = -35
	local planetname_y = h* -0.35
	local bonusname_x = CenterX - 135 + 40
	local bonusname_y = 170 + h* -0.35
	local attackmap_x = CenterX - 230
	local attackmap_y = bonusname_y - 20
	local attackmap_img_x = CenterX - 155
	local attackmap_img_y = bonusname_y + 60 + 0.5*h
	local img_l = -80
	local img_t = -70
	local img_b =  70
	local img_r =  125
		
	if(gPlatformStr == "PS2") then
		modelc_x = -15
		modelc_y = -SmallSize - 15
		planetname_x = -65
		planetname_y = h* -0.28
		bonusname_x = CenterX - 135 + 120
		bonusname_y = 194 + h* -0.35
		bonustext_x = w * -0.012 + 10
		bonustext_y = h * 0.2		
		attackmap_x = CenterX - 190
		attackmap_y = bonusname_y + 60
		attackmap_img_x = 125
		attackmap_img_y = 120
		planetname_font= "gamefont_tiny"
		img_l = -80
		img_t = -70
		img_b =  63
		img_r =  78
		infobox_x = -30 + 10
		infobox_y = -5
		infobox_w = 330
		infobox_h = 105
		bonus_txt_width = infobox_w - 10
	elseif(gPlatformStr == "XBox") then
		modelc_x = 20
		modelc_y = -SmallSize
		planetname_x = -30
		planetname_y = h* -0.25
		bonusname_x = CenterX - 135 + 115
		bonusname_y = 202 + h* -0.35	
		bonustext_x = w * 0.015
		bonustext_y = h * 0.22
		attackmap_x = CenterX - 230
		attackmap_y = bonusname_y + 60
		attackmap_img_x = 115
		attackmap_img_y = 125
		planetname_font= "gamefont_tiny"
		img_l = -80
		img_t = -70
		img_b =  70
		img_r =  125
		infobox_x = -20
		infobox_y = 0
		infobox_w = 400
		infobox_h = 100
		bonus_txt_width = infobox_w - 10
		if( wFactor ~= 1 ) then
			planetname_x = planetname_x + 100
			modelc_x = modelc_x + 100
			bonustext_x = bonustext_x + 75
		end
	elseif(gPlatformStr == "PC") then
		planetname_x = w * 0.08
		planetname_y = h * -0.15
		modelc_x = w * 0.15
		modelc_y = h * 0.0
		bonusname_x = w * 0.5
		bonusname_y = h * 0.15		
		bonustext_x = w * -0.43
		bonustext_y = h * 0.22
		attackmap_x = w * 0.1
		attackmap_y = h * 0.4
		attackmap_img_x = w * 0.18
		attackmap_img_y = h * 0.22
		img_l = -80
		img_t = -70
		img_b =  170
		img_r =  250
		infobox_x = w * -0.1
		infobox_y = h * 0.3
		infobox_w = w * 0.7
		infobox_h = h * 0.2
		bonus_txt_width = infobox_w - 20
	end
		
	this.AttackItems.ModelC = NewIFModel {
		x = modelc_x, y = modelc_y,				
		scale = LargeScale,
		lighting = 1,
	}

--	this.AttackItems.ItemC = NewIFMapPreview {
--		x = LargeSize * -0.75, y = LargeSize * -0.75 - SmallSize,
--		ZPos = 210,
--		width = LargeSize * 0.75,
--	}

	this.AttackItems.PlanetName = NewIFText {
		font = planetname_font,
		textw = 100,
		halign = "hcenter",
		x = planetname_x,
		y = planetname_y,
		nocreatebackground = 1,
--		rotY = 10,
--		rotX = 10,
--		rotZ = 2.5,
	}

	this.AttackItems.MapName = NewIFText {
		font = "gamefont_medium",
		textw = 460,
		y = h * -0.5, -- top of screen
		nocreatebackground = 1,
	}

	this.InfoBox = NewButtonWindow {
		font = "gamefont_tiny",
		ScreenRelativeX = 0.5, -- center filled in later based on screensize
		ScreenRelativeY = 0.5,
		x = infobox_x,
		y = infobox_y,
		ZPos = z_pos_base + 20,
		
		halign = "left",
		bgleft = "headerbuttonleft",
		bgmid = "headerbuttonmid",
		bgright = "headerbuttonright",
		ColorR = 255,
		ColorG = 255,
		ColorB = 255,
		textcolorr = 0,
		textcolorg = 0,
		textcolorb = 0,
		titleText = "common.none",

--		rotY = 10,
--		rotX = 10,
--		rotZ = 2.5,
		
		width = infobox_w,
		height = infobox_h,
	}
	
--	this.AttackBonusName = NewButtonWindow {
--		font = "gamefont_tiny",
--		textw = 300,
--		ScreenRelativeX = 0.135, -- center filled in later based on screensize
--		ScreenRelativeY = 0.68,
--		x = bonusname_x,
--		y = bonusname_y,
--		--nocreatebackground = 1,
--
--		halign = "left",
--		bgleft = "headerbuttonleft",
--		bgmid = "headerbuttonmid",
--		bgright = "headerbuttonright",
--		ColorR = 255,
--		ColorG = 255,
--		ColorB = 255,
--		textcolorr = 0,
--		textcolorg = 0,
--		textcolorb = 0,
--		titleText = "common.none",
--
--		rotY = 10,
--		rotX = 10,
--		rotZ = 2.5,
--		
--		width = 170,
--		height = 100,
--	}

	--this.AttackBonusImage = NewIFMapPreview {
	--	x = CenterX + 20,
	--	y = 320,
	--	width = 40,
	--}

	this.AttackBonusText = NewIFText {
		font = "gamefont_tiny",		
		ScreenRelativeX = 0.5, -- center filled in later based on screensize
		ScreenRelativeY = 0.5,
		textw = bonus_txt_width,
		texth = 100,
		x = bonustext_x,
		y = bonustext_y,
		ZPos = z_pos_base + 10,
		nocreatebackground = 1,
--		rotY = 10,
--		rotX = 10,
--		rotZ = 2.5,
	}
	
--	this.AttackMapName = NewIFText {
--		font = "gamefont_medium",
--		ScreenRelativeX = 0, -- center filled in later based on screensize
--		ScreenRelativeY = 0.5,
--		textw = 350,
--		texth = 40,
--		halign = "left",
--		x = attackmap_x,
--		y = attackmap_y,
--		ZPos = z_pos_base + 20,
--		nocreatebackground = 1,
--		rotY = 10,
--		rotX = 10,
--		rotZ = 2,
--		alpha = 0.2,
--	}

--  remove AttackMapImage
--	-- Add the pieces to each container
--	this.AttackMapImage = NewIFImage {
--		ScreenRelativeX = 0, -- center filled in later based on screensize
--		ScreenRelativeY = 0.5,
--		x = attackmap_img_x,
--		y = attackmap_img_y,
--		ZPos = z_pos_base + 255, inertUVs = 1,
--		width = 300,
--		texture = "map_yav2",
--		rotY = 10,
--		rotX = 10,
--		rotZ = 2,
--		localpos_l = img_l, localpos_t = img_t,
--		localpos_b = img_b, localpos_r = img_r,
--		alpha = 0.2,
--	}

end


-- OnEntry helper function: adds items for the 'Attack planet'
-- mini-carousel. CenterX, Width are (0-based) chunks of size that
-- determine what area of the screen it can work in.
function ifs_meta_main_fnAddBonusItems(dest,CenterX,Width,h)
	-- Scale screen height to gap between bonus stuff
	h = h * 0.45

	local HalfWidth = Width * 0.5
	-- The half-size (around the center) of the large and small
	-- previews. These should sum to about 0.5 to make everything fit
	-- (over 0.5 means safezones will be exceeded)

	if(gPlatformStr == "XBox") then
		Width = Width * 0.8 -- shink to fit screen better
	end

	local LargeSize = Width * 0.2
	local SmallSize = Width * 0.1

	-- Store for later
	dest.fLargeSize = LargeSize
	dest.fSmallSize = SmallSize

	dest.x = CenterX + 100
	dest.y = 250

	dest.ItemC = NewIFMapPreview {
		x = -20, y = 0,
		width = LargeSize,

		rotY = 10,
		rotX = 10,
		rotZ = 2.5,		
	}

	dest.ItemL = NewIFMapPreview {
		x = -(LargeSize + SmallSize), y = 0,
		width = SmallSize,
	}

	dest.ItemL2 = NewIFMapPreview {
		x = -(LargeSize + SmallSize), y = 0,
		width = SmallSize,
	}

	dest.ItemR = NewIFMapPreview {
		x = (LargeSize + SmallSize), y = 0,
		width = SmallSize,
	}

	dest.ItemR2 = NewIFMapPreview {
		x = (LargeSize + SmallSize), y = 0,
		width = SmallSize,
	}

	dest.PlanetName = NewIFText {
		ZPos = z_pos_base + 20,
		font = "gamefont_tiny",
		textw = 60,
		valign = "top",
		x = - 90,
		y = -(LargeSize + 40 + 5) + 5,
		width = 100,
		
		halign = "left",
		bgleft = "headerbuttonleft",
		bgmid = "headerbuttonmid",
		bgright = "headerbuttonright",
		ColorR = 255,
		ColorG = 255,
		ColorB = 255,
		textcolorr = 0,
		textcolorg = 0,
		textcolorb = 0,

		rotY = 10,
		rotX = 10,
		rotZ = 2.5,		
	}

	dest.BonusName = NewIFText {
		ZPos = z_pos_base + 20,
		font = "gamefont_medium",
		textw = 460,
		valign = "top",
		y = LargeSize,
	}
end

ifs_meta_main_listbox_contents = {
}

ifs_meta_main = NewIFShellScreen {
	--bg_texture = "gc_bg",
	nologo = 1,
	movieIntro      = nil,
	movieBackground = "shell_sub_left", -- WAS "ifs_meta_screen",
	music           = "shell_galacticconquest",
	
	paused			= nil,

	-- accept button and no back button
	-- bNohelptext = 1, -- we have our own
	bNohelptext_accept = nil,
	bNohelptext_back = 1,
	
	mouse_over_model = nil,

	-- customized back button
	-- button text: option
	button_Back = NewIFContainer {
		ScreenRelativeX = 0.0, -- left
		ScreenRelativeY = 1.0, -- bottom
		y = -10, -- just above bottom
		x = 10,

		icon = NewIFImage { 
			ZPos = z_pos_base + 00, -- behind most.

			texture = "btnb", 
			localpos_l = -10,
			localpos_t = -11,
			localpos_r =  10,
			localpos_b =  11,
			inert = 1, -- Delete this out of lua once created (we'll never touch it again)
		},

		helpstr = NewIFText {
			string = "common.mp.options",
			font = "gamefont_medium",
			textw = 460,
			x = 22,
			y = -15,
			halign = "left",
			inert = 1, -- Delete this out of lua once created (we'll never touch it again)
			nocreatebackground = 1,
		},
	},
	
	-- the save callback
	--fnMetagameSaveDone = ifs_meta_main_fnMetagameSaveDone,

	title = NewIFText {
		string = "ifs.meta.main.selattack",
		font = "gamefont_tiny",
		textw = 420, -- overridden to safe width in fnBuildScreen
		texth = 65,
		ScreenRelativeX = 0.55, -- center
		ScreenRelativeY = -0.05, -- top
		nocreatebackground = 1,
		rotY = 10,
		y = 15,
	},

	PageBars = NewIFContainer {
		ScreenRelativeX = 0,
		ScreenRelativeY = 0,
		y = 20,
	},


	-- Positions of some sub-items filled out in code later
	galaxy = NewIFContainer {
		ScreenRelativeX = 0.0, -- center filled in later based on screensize
		ScreenRelativeY = 0.0,
		ZPos = z_pos_base + 20,
	},

	AttackItems = NewIFContainer {
		ScreenRelativeX = 0, -- center filled in later based on screensize
		ScreenRelativeY = 0.5,
		ZPos = z_pos_base + 10,
	},

	TopBonus = NewIFContainer {
		ScreenRelativeX = 0, -- center filled in later based on screensize
		ScreenRelativeY = 0.23, -- a bit over the 0.25/0.75 to make space for bottom buttons
	},

	BotBonus = NewIFContainer {
		ScreenRelativeX = 0, -- center filled in later based on screensize
		ScreenRelativeY = 0.23, -- a bit over the 0.25/0.75 to make space for bottom buttons
	},

--	TopBonusLocked = NewIFTitleBar {
--		width = 250,
--		font = "gamefont_medium",
--		string = "ifs.meta.Bonus.locked",
--		ScreenRelativeX = 0, -- center filled in later based on screensize
--		ScreenRelativeY = 0.23, -- a bit over the 0.25/0.75 to make space for bottom buttons
--	},

--	BotBonusLocked = NewIFTitleBar {
--		width = 250,
--		font = "gamefont_medium",
--		string = "ifs.meta.Bonus.locked",
--		ScreenRelativeX = 0, -- center filled in later based on screensize
--		ScreenRelativeY = 0.78, -- a bit over the 0.25/0.75 to make space for bottom buttons
--	},

--	PickTargetBar = NewIFTitleBar {
--		ScreenRelativeX = 0.75,
--		ScreenRelativeY = 0,
--		y = 20, -- Make font fit in pre-baked bg
--		width = 280,
--		font = "gamefont_medium",
--	},

--	BonusNameBar = NewIFTitleBar {
--		ScreenRelativeX = 0.5,
--		ScreenRelativeY = 1.0,
--		y = -35,
--		width = 290,
--		font = "gamefont_small",
--	},

	buttons = NewIFContainer {
		ScreenRelativeX = 0.6, -- center
		ScreenRelativeY = gDefaultButtonScreenRelativeY, -- top
		y = 20, -- go slightly down from center
		ZPos = z_pos_base,
	},

	Input_GeneralLeft = function(this,iJoystick,bFromAI)
		if(	ifs_meta_main.paused ) then
		else
			metagame_input_GeneralLeft(this,iJoystick,bFromAI)
		end
	end,

	Input_GeneralRight = function(this,iJoystick,bFromAI)
		if(	ifs_meta_main.paused ) then
		else
			metagame_input_GeneralRight(this,iJoystick,bFromAI)
		end
	end,

	Input_GeneralUp = function(this,iJoystick,bFromAI)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputUp(this)) then
			return
		end

		if(	ifs_meta_main.paused ) then
			if( not bFromAI ) then
				gDefault_Input_GeneralUp(this)
			end
		else
			metagame_input_GeneralUp(this,iJoystick,bFromAI)
		end
	end,

	Input_GeneralDown = function(this,iJoystick,bFromAI)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputDown(this)) then
			return
		end

		if(	ifs_meta_main.paused ) then
			if( not bFromAI ) then
				gDefault_Input_GeneralDown(this)
			end
		else
			metagame_input_GeneralDown(this,iJoystick,bFromAI)
		end
	end,

	Input_Accept = function(this,iJoystick,bFromAI)
--		print( "this.CurButton =", this.CurButton )
		if(this.CurButton == "_back") then -- Make PC work better - NM 8/5/04
			this:Input_Back()
			return
		end

		if(	ifs_meta_main.paused ) then
			metagame_input_PauseAccept(this,iJoystick,bFromAI)
		else
			if(gPlatformStr ~= "PC") then
				metagame_input_Accept(this,iJoystick,bFromAI)
			else
				if( this.CurButton == "do_accept" ) then
					metagame_input_Accept(this,iJoystick,bFromAI)
				else
					ifelm_shellscreen_fnPlaySound("shell_select_change")
					metagame_input_MouseOverModel(this, mouse_over_model)
				end
			end
		end
	end,

	Input_Misc = function(this,iJoystick,bFromAI)
		metagame_input_Misc(this,iJoystick,bFromAI)
	end,

	Input_Back = function(this,iJoystick,bFromAI)
		if(	ifs_meta_main.paused ) then
			ifs_meta_main.paused = nil
			IFObj_fnSetVis(ifs_meta_main.buttons, nil)
		else
			ifs_meta_main.paused = 1
			IFObj_fnSetVis(ifs_meta_main.buttons, 1)
			ifs_meta_main.CurButton = "resume"
			gCurHiliteButton = this.buttons[this.CurButton]
		end
	end,

	Input_Start = function(this, iJoystick)
		-- Joystick 2 (the third) is never allowed. Fix for 8189 - NM 8/7/04
		if(iJoystick > 1) then
			return
		end

		-- Only allow joystick 1 (the second) in splitscren - NM 8/7/04
		if((iJoystick > 0) and (not ScriptCB_IsSplitscreen())) then
			return
		end

		if(	ifs_meta_main.paused ) then
			ifs_meta_main.paused = nil
			IFObj_fnSetVis(ifs_meta_main.buttons, nil)
			ifs_meta_main.CurButton = "resume"
			gCurHiliteButton = this.buttons[this.CurButton]
		else
			ifs_meta_main.paused = 1
			IFObj_fnSetVis(ifs_meta_main.buttons, 1)
			ifs_meta_main.CurButton = "resume"
			gCurHiliteButton = this.buttons[this.CurButton]
		end
		-- metagame_input_Start(this)
	end,

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd)

		-- if PC disable the option button
		if(gPlatformStr == "PC") then
			IFObj_fnSetVis(ifs_meta_main.button_Back, nil)
		else
			ifs_meta_main.buttons.load.hidden = 1
			this.CurButton = ShowHideVerticalButtons(ifs_meta_main.buttons,ifs_meta_main_vbutton_layout)
			SetCurButton(this.CurButton)
		end

		
		-- if we just returned from player1 save on exit, go to player2
		if(this.SaveProfile2OnEnter) then
			this.SaveProfile2OnEnter = nil
			metagame_input_SaveAndExit2()
			return
		end
    
		--IFObj_fnSetZPos(this.buttons,0)
		ifs_meta_main.paused = nil
		IFObj_fnSetVis(ifs_meta_main.buttons, nil)
        --ifelem_shellscreen_fnStopMovie()
		ifs_meta_main_fnEnter(this, bFwd)
	end,

	Exit = function(this, bFwd)
		ScriptCB_ReadAllControllers(nil) -- turn off once we're done with this screen
	end,

	Update = function(this, fDt)
		if( ifs_meta_main.paused ) then
			gIFShellScreenTemplate_fnUpdate(this, fDt)
		else
			ifs_meta_main.paused = nil
			IFObj_fnSetVis(ifs_meta_main.buttons, nil)
			if(gPlatformStr ~= "PC") then
				ifs_meta_main.CurButton = "resume"
			end
			-- ifs_meta_main.CurButton = nil
			
			ifs_meta_main_fnUpdate(this, fDt)
		end
	end,

	MouseOverModel = function( this, model )
		mouse_over_model = model
		--metagame_input_MouseOverModel(this, model)
	end,

	ButtonAddScale = 0,
	ButtonDir = 20, -- for the bouncy-buttons
	ButtonAddScale2 = 0,
	ButtonDir2 = 20, -- for the bouncy-buttons
}

-- Helper function creates parts of the screen
function ifs_meta_main_fnBuildScreen(this)
	local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
	local BarW = 0			-- get rid of StatusBar
	local RestW = (w - BarW)
	local UsableCenterX = BarW + (RestW * 0.5)

	this.title.textw = w
	this.title.x = w * -0.5

	ifs_meta_main_fnAddGalaxyPlanets(this.galaxy,UsableCenterX,RestW)
	ifs_meta_main_fnAddAttackItems(this,UsableCenterX,RestW)

	this.TopBonus.x = UsableCenterX - 100
	this.TopBonus.y = this.TopBonus.y + 70

	this.BotBonus.x = UsableCenterX - 100
	this.BotBonus.y = this.BotBonus.y + 70

--	this.TopBonusLocked.x = UsableCenterX - 30
--	this.TopBonusLocked.y = this.TopBonusLocked.y + 140
--	this.BotBonusLocked.x = UsableCenterX - 30
--	this.BotBonusLocked.y = this.BotBonusLocked.y + 70

	ifs_meta_main_fnAddBonusItems(this.TopBonus,UsableCenterX - 30,RestW*0.5,h*0.3)
	ifs_meta_main_fnAddBonusItems(this.BotBonus,UsableCenterX - 30,RestW*0.5,h*0.3)

--	TitleBarLabel_fnSetSize(this.TopBonusLocked.labels,this.TopBonusLocked.width,64)
--	TitleBarLabel_fnSetSize(this.BotBonusLocked.labels,this.BotBonusLocked.width,64)


--	this.InfoBox.CurTeam = NewIFText {
--		font = "gamefont_medium",
--		textw = this.InfoBox.width - 20,
--		y = -75,
--	}

--	this.InfoBox.MainText = NewIFText {
--		font = "gamefont_medium",
--		textw = this.InfoBox.width - 20,
--		y = -15,
--		texth = 120,
--	}

	this.CurTimeLabel = NewIFText {
		font = "gamefont_small",
		textw = 80,
		x = 0,
		y = h-18,
	}

	if(gPlatformStr == "PC") then
		local BackButtonW = 100
		local BackButtonH = 25
		this.donebutton =	NewIFContainer
		{
			ScreenRelativeX = 1.0, -- right
			ScreenRelativeY = 1.0, -- bottom
			y = -15, -- just above bottom
			x = -BackButtonW,
			btn = NewClickableIFButton 
			{ 
				btnw = BackButtonW, 
				btnh = BackButtonH,
				font = "gamefont_medium", 
				bg_width = BackButtonW, 
				tag = "do_accept",
				nocreatebackground=1,
			}, -- end of btn
		}
		
		this.donebutton.btn.label.bHotspot = 1
		this.donebutton.btn.label.fHotspotW = BackButtonW
		this.donebutton.btn.label.fHotspotH = BackButtonH
		RoundIFButtonLabel_fnSetString(this.donebutton.btn,"common.accept")
	end
end

ifs_meta_main_fnBuildScreen(ifs_meta_main)
ifs_meta_main_fnAddAttackItems = nil
ifs_meta_main_fnAddGalaxyPlanets = nil -- dump out of memory
ifs_meta_main_fnBuildScreen = nil
ifs_meta_main_fnAddBonusItems = nil


ifs_meta_main.CurButton = AddVerticalButtons(ifs_meta_main.buttons,ifs_meta_main_vbutton_layout)
if(gPlatformStr == "PC") then
	IFButton_fnSelect(ifs_meta_main.buttons.resume,nil) -- turn off first item
	ifs_meta_main.CurButton = nil
end
	
-- Push into C now
AddIFScreen(ifs_meta_main,"ifs_meta_main")