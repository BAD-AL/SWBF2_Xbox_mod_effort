--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Metagame "battle about to start"  screen
-- 



-- Helper function: this screen has been entered. Do any work necessary
function ifs_meta_battle_fnOnEnter(this,bFwd)

	local team1Maps=0
	local team2Maps=0
	for k,v in metagame_state.planets do
		local NumNormalPlanets = metagame_table.getnumPlanets()
		local i = v.pickorder
		-- Ignore the factional planets shunted off the normal list
		if(i <= NumNormalPlanets) then
			if(not v.destroyed) then
				if(v.owner1 == 1) then
					team1Maps = team1Maps + 1
				elseif(v.owner1 == 2) then
					team2Maps = team2Maps + 1
				end
				if(v.owner2 == 1) then
					team1Maps = team1Maps + 1
				elseif(v.owner2 == 2) then
					team2Maps = team2Maps + 1
				end
			end
		end
	end
	
--	if(metagame_state.pickteam==1) then
--		ScriptCB_SetAIDifficulty(team1Maps, team2Maps)
--	else
--		ScriptCB_SetAIDifficulty(team2Maps, team1Maps)
--	end
	
	-- Normal battle timing
	this.ResultsTime = 8.0 -- Delay before the results box opens (should be less than TotalOpenTime)
	this.TotalOpenTime = 8.0 -- Total time this screen is open
	this.CurTime = 0 -- elapsed time on this screen

	local LocalizedMapName = missionlist_GetLocalizedMapName(metagame_state.TrueMapName)
	local BattleAtStr = ScriptCB_usprintf("ifs.meta.battle.battlefor",LocalizedMapName)

	-- Show active planetary bonuses
	local k,v
	local LeftPlanet = nil
	local RightPlanet = nil
	for k,v in metagame_state.planets do
		if((not v.destroyed) and (v.activatedthisturn)) then
			if(v.owner2 < 1.5) then
				LeftPlanet = v
			else
				RightPlanet = v
			end
		end
	end

	if(((metagame_state_local.mJoystickTeams[1]==1) or (metagame_state_local.mJoystickTeams[1]==2)) and
	    ((metagame_state_local.mJoystickTeams[2]==1) or (metagame_state_local.mJoystickTeams[2]==2))) then
	    -- Play Attack / Defend VO ------------------------------------------------
	    local attackTeam      = metagame_state_fnGetAttackTeam(this)
	    local attackTeamIndex = metagame_state_fnGetAttackTeamIndex(this)
	    local defendTeam      = metagame_state_fnGetDefendTeam(this)
	    local localTeam1      = metagame_state[string.format("team%d", metagame_state_local.mJoystickTeams[1])]
	    local localTeam2      = metagame_state[string.format("team%d", metagame_state_local.mJoystickTeams[2])]

	    -- is a local player the attacker ? 
	    if ((not localTeam1.aicontrol and metagame_state_local.mJoystickTeams[1] == attackTeamIndex) or
        	(not localTeam2.aicontrol and metagame_state_local.mJoystickTeams[2] == attackTeamIndex)) then
	        streamName = attackTeam.shortname .. "_" .. TargetPlanet.MapName .. "_attack"
	    else
        	-- local player must be defender
	        streamName = defendTeam.shortname .. "_" .. TargetPlanet.MapName .. "_defend"
	    end
    
	    --print("*******************Playing battle VO", streamName)
        ScriptCB_ShellPlayDelayedStream(streamName, 0, 0)
	    -- End Play Attack / Defend VO ---------------------------------------------
	end
    

	if(LeftPlanet) then
--		IFText_fnSetString(this.LeftColumn.Title,LeftPlanet.ShortBonusText)
--		IFMapPreview_fnSetTexture(this.CenterItems.BonusL,"bonus_" .. LeftPlanet.MapName)
--		print("TextureL = ","bonus_" .. LeftPlanet.MapName)
	else
--		IFText_fnSetString(this.LeftColumn.Title,"ifs.meta.bonus.none")
--		IFMapPreview_fnSetTexture(this.CenterItems.BonusL,"bonus_none")
--		print("TextureL = ","bonus_none")
	end

	if(RightPlanet) then
--		IFText_fnSetString(this.RightColumn.Title,RightPlanet.ShortBonusText)
--		IFMapPreview_fnSetTexture(this.CenterItems.BonusR,"bonus_" .. RightPlanet.MapName)
--		print("TextureR = ","bonus_" .. RightPlanet.MapName)
	else
--		IFText_fnSetString(this.RightColumn.Title,"ifs.meta.bonus.none")
--		IFMapPreview_fnSetTexture(this.CenterItems.BonusR,"bonus_none")
--		print("TextureR = ","bonus_none")
	end

	ScriptCB_SaveMetagameState() -- Note current state of everything
	ScriptCB_SetMetagameRulesOn(1) -- for ingame

	if(metagame_state.pickteam==1) then
		ScriptCB_SetAIDifficulty(team1Maps, team2Maps)
	else
		ScriptCB_SetAIDifficulty(team2Maps, team1Maps)
	end	
	
	-- go into the battle directly
	if (1) then -- AudioStreamComplete(gVoiceOverStream)) then 
		-- metagame has only single/split screen mode now
		--if((not ScriptCB_InNetSession()) or (ScriptCB_GetAmHost())) then
			ScriptCB_SetMissionNames(metagame_state.NextMapName,nil) -- launch mission, no randomizing
			ScriptCB_EnterMission()
		--end
		ScriptCB_SetMetagameTeams();
	end	
end

-- Helper function: time has elapsed. Do whatever it needs to.
function ifs_meta_battle_fnOnUpdate(this,fDt)
	-- Call base class update
	gIFShellScreenTemplate_fnUpdate(this, fDt)

	if(ScriptCB_InNetSession()) then
		ScriptCB_UpdateMPMetagame()
	end

	this.CurTime = this.CurTime + fDt
	if(this.CurTime > this.ResultsTime) then
		if (1) then -- AudioStreamComplete(gVoiceOverStream)) then 
			if((not ScriptCB_InNetSession()) or (ScriptCB_GetAmHost())) then
				ScriptCB_SetMissionNames(metagame_state.NextMapName,nil) -- launch mission, no randomizing
				ScriptCB_EnterMission()
			end
			ScriptCB_SetMetagameTeams();
		end
	end
end

-- Helper function, builds up the screen
function ifs_meta_battle_fnBuildScreen(this)
	local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen

-- 	ifs_meta_battle_fnAddPlanet(ifs_meta_battle.LeftPlanet)
-- 	ifs_meta_battle_fnAddPlanet(ifs_meta_battle.RightPlanet,1)

	this.Title.TitleBar = NewIFTitleBarLarge {
--  		ScreenRelativeX = 0.50,
--  		ScreenRelativeY = 0,
		width = w * 0.65,
		font = "gamefont_medium",
	}

	-- Gotta position these based on screen width.
	this.Title.SealL = NewIFImage {
		ZPos = 120,
		x = w * -0.5 + 40, y = 8,
		localpos_t = -32, localpos_l = -32,
		localpos_b =  32, localpos_r =  32,
	}
	this.Title.SealR = NewIFImage {
		ZPos = 120,
		x = w * 0.5 - 40, y = 8,
		localpos_t = -32, localpos_l = -32,
		localpos_b =  32, localpos_r =  32,
	}

	-- Build these also (textw can't be changed easily after creation)
	this.Team1Name = NewIFText {
		ScreenRelativeX = 0.25,
		ScreenRelativeY = 0.19,
		font = "gamefont_medium",
		ColorR = 255, ColorG = 255, ColorB = 255,
		textw = w * 0.4,
	}
	this.Team2Name = NewIFText {
		ScreenRelativeX = 0.75,
		ScreenRelativeY = 0.19,
		font = "gamefont_medium",
		ColorR = 255, ColorG = 255, ColorB = 255,
		textw = w * 0.4,
	}


	this.LeftColumn.Title = NewIFText {
		ZPos = 120,
		y = 30,
		font = "gamefont_medium",
		ColorR = 255, ColorG = 255, ColorB = 255,
		textw = w * 0.4,
	}
	this.LeftColumn.Title.x = this.LeftColumn.Title.x - 40


	this.RightColumn.Title = NewIFText {
		ZPos = 120,
		y = 30,
		font = "gamefont_medium",
		ColorR = 255, ColorG = 255, ColorB = 255,
		textw = w * 0.4,
	}
	this.RightColumn.Title.x = this.RightColumn.Title.x + 40

	local fMapSize = w * 0.20 -- Radius size of map preview

	this.CenterItems.Map = NewIFMapPreview {
--		x = 0, y = -SmallSize,
		width = fMapSize,
	}

	local fBonusSize = w * 0.1 -- Radius size of map preview
	this.CenterItems.BonusL = NewIFMapPreview {
		x = -(fMapSize + 96) , y = -(fBonusSize+32),
		width = fBonusSize,
	}
	this.CenterItems.ArrowL = NewIFImage {
		x = -(fMapSize + 32) , y = -(fBonusSize - 16),
		texture = "warstatus_arrow",
		uvs_l = 1, uvs_r = 0,
		uvs_t = 1, uvs_b = 0,
		localpos_l = -32, localpos_t = -32,
		localpos_b =  32, localpos_r =  32,
		inert = 1, -- delete from Lua memory after creating
	}

	this.CenterItems.BonusR = NewIFMapPreview {
		x = (fMapSize + 96) , y = -(fBonusSize+32),
		width = fBonusSize,
	}
	this.CenterItems.ArrowR = NewIFImage {
		x =  (fMapSize + 32) , y = -(fBonusSize - 16),
		texture = "warstatus_arrow",
		uvs_t = 1, uvs_b = 0,
		localpos_l = -32, localpos_t = -32,
		localpos_b =  32, localpos_r =  32,
		inert = 1, -- delete from Lua memory after creating
	}

end

ifs_meta_battle = NewIFShellScreen {
	nologo = 1,
--	bg_texture = "metagame_pic_BG", -- "prebattlebg",
	bNohelptext = 1,
    movieIntro      = nil,
    movieBackground = nil,

	Title = NewIFContainer {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.08,
	},

	vsStr = NewIFText {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.19,
		y = -5,
		font = "gamefont_large",
		string = "ifs.meta.battle.vsstr",
		ColorR = 255, ColorG = 255, ColorB = 255,
		inert = 1,
	},

	LeftColumn = NewIFContainer {
		ScreenRelativeX = 0.25,
		ScreenRelativeY = 0.5,
	},
	RightColumn = NewIFContainer {
		ScreenRelativeX = 0.75,
		ScreenRelativeY = 0.5,
	},

	CenterItems = NewIFContainer {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.6,
	},


	Enter = function(this,bFwd)
		ifs_meta_battle_fnOnEnter(this,bFwd)
	end,
	Update = function(this,fDt)
		 ifs_meta_battle_fnOnUpdate(this,fDt)
	end,

	-- Ignore standard input. This is a load screen!
	Input_Accept = function(this)
								 end,
	Input_Back = function(this)
							 end,

	-- No U/D/L/R functionality possible on this screen (gotta have stubs
	-- here, or the base class will override)
	Input_GeneralUp = function(this)
	end,
	Input_GeneralDown = function(this)
	end,
	Input_GeneralLeft = function(this)
											end,
	Input_GeneralRight = function(this)
											end,
}

ifs_meta_battle_fnBuildScreen(ifs_meta_battle)
ifs_meta_battle_fnBuildScreen = nil

AddIFScreen(ifs_meta_battle,"ifs_meta_battle")
