--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- A few bit of utility code for the metagame.

gMetagameGalaxySize = 400

-- Returns the # of planets active at once. MUST be the same as
-- the count in metagame_state.PlanetPositions
function metagame_GetNumPlanets()
	return table.getn(metagame_state.PlanetPositions)
end

-- Returns the reserved height for the team name buttons up top
function metagame_GetNameButtonHeight()
	return 30
end

-- Helper function: gets size of a planet preview icon. Returns
-- 2 values: the height per, and the ygutter between them (for the sides
function metagame_GetPlanetPreviewSize()
	local w,h = ScriptCB_GetSafeScreenInfo()
	local ygutter = 3
	if(h > 600) then
		ygutter = 10
	end

	h= h - metagame_GetNameButtonHeight() - 16 -- Account for top button's height, borders

	local heightper = (h / (metagame_GetNumPlanets() -1 )) - ygutter
	heightper = heightper * 0.8 -- a bit smaller
	if(heightper > 100) then
		heightper = 100
	end
	return heightper, ygutter
end

-- Given the current metagame_state.pickteam, and the current planets,
-- estimates odds (our of 100) of winning. Returns 50 if 50%, 55 if
-- 55%, etc
function metagame_util_fnEstimateWinOdds()
	local Odds = 50 -- default

	local k,v
	for k,v in metagame_state.planets do
		if((not v.destroyed) and (v.activatedthisturn)) then
			if(metagame_state.pickteam == v.owner1) then
				Odds = Odds + 15
			else
				Odds = Odds - 15
			end
		end -- this one is fully charged
	end -- loop over planets

	return Odds
end


-- Helper function: given a mapstr from metagame_util_fnGetMapName(),
-- returns a valid map name out of the missionselect_listbox_contents.
-- Matches attacker (last character), then planet, otherwise uses
-- first possibility
function metagame_util_fnGetValidMapName(MapStr)
	-- Upconvert to all caps to simplify things
	MapStr = strupper(MapStr)
	local MapWOTeamStr = string.sub(MapStr,1,4) -- left 4 characters of MapStr (e.g. "YAV1")
	local PlanetStr = string.sub(MapStr,1,3) -- just the planet name (e.g. "YAV")
	local TypeChar = string.sub(MapStr,4,4) -- '1' or '2'
	local SideChar = string.sub(MapStr,5,5) -- 'A' 'C' 'I' or 'R'
	local i
	local MapList = sp_missionselect_listbox_contents

	-- First pass: prefer an exact match
	for i = 1,table.getn(MapList) do
		if(MapWOTeamStr == strupper(MapList[i].mapluafile)) then
			if(SideChar == "A") then
				if(MapList[i].side_a) then
					metagame_state.teamsAreBackwards = nil
					return MapStr
				else
					metagame_state.teamsAreBackwards = 1
					return MapList[i].mapluafile .. "I"
				end
			end
			if(SideChar == "I") then
				if(MapList[i].side_i) then
					metagame_state.teamsAreBackwards = nil
					return MapStr
				else
					metagame_state.teamsAreBackwards = 1
					return MapList[i].mapluafile .. "A"
				end
			end
			if(SideChar == "C") then
				if(MapList[i].side_c) then
					metagame_state.teamsAreBackwards = nil
					return MapStr
				else
					metagame_state.teamsAreBackwards = 1
					return MapList[i].mapluafile .. "R"
				end
			end
			if(SideChar == "R") then
				if(MapList[i].side_r) then
					metagame_state.teamsAreBackwards = nil
					return MapStr
				else
					metagame_state.teamsAreBackwards = 1
					return MapList[i].mapluafile .. "C"
				end
			end
		end
	end

	-- Hack list by Giz - NM 12/9/03
-- 	if(TypeChar == "2") then
-- 		return "NAB2" .. SideChar
-- 	end

	if (PlanetStr == "KAS") then
		return "YAV1" .. SideChar
	elseif ((PlanetStr == "BES") or (PlanetStr == "RHN")) then
		return "TAT1" .. SideChar
	end

	-- Second pass: look for another map w/ same 1/2 versioning
	for i = 1,table.getn(MapList) do
		if(TypeChar == string.sub(MapList[i].mapluafile,4,4)) then
			return MapList[i].mapluafile .. SideChar -- right suffix
		end -- planet name is correct
	end

	-- Third pass: look for the other map on this planet
	for i = 1,table.getn(MapList) do
		if(PlanetStr == strupper(string.sub(MapList[i].mapluafile,1,3))) then
			return MapList[i].mapluafile .. SideChar -- right suffix
		end -- planet name is correct
	end

	-- Third pass: find any map that supports all 4 sides, use it.
	for i = 1,table.getn(MapList) do
		if((MapList[i].side_a) and (MapList[i].side_c)) then
			return string.sub(MapList[i].mapluafile,1,4) .. SideChar -- left 4 characters of MapStr
		end -- supports at least 2 sides (and therefore hopefully all)
	end

	return "yav1" .. SideChar -- emergency fallback
end




-- See if one team has won, if so pull up the winner box. Returns true
-- if so, nil if not.
function metagame_util_fnCheckWinner()
	local Team1Count,Team2Count = metagame_state_fnCountPlanets(metagame_state)

	if((Team1Count < 1) or (Team2Count < 1)) then
		--local k,v
		--for k,v in metagame_state.planets do
		--	v.owner1 = 0 -- reset, hide.
		--end

		if(Team2Count < 1) then
			IFText_fnSetString(Metagame_Popup_GameWinner.winnername,metagame_state.team1.teamname)
			ifs_meta_movie.winner = metagame_state.team1.teamname
			if( metagame_state.pickteam == 1 ) then
				-- metagame_state.mWonMaps0 = 1
				-- if not an AI player, enable all maps
				if( metagame_state.team1.aicontrol ~= 1 ) then
					if( not ScriptCB_IsMetaAllMapsOn() ) then
						ScriptCB_SetMetaAllMapsOn( 1 )
					end
				end
			end
		else
			IFText_fnSetString(Metagame_Popup_GameWinner.winnername,metagame_state.team2.teamname)
			ifs_meta_movie.winner = metagame_state.team2.teamname
			if( metagame_state.pickteam == 2 ) then
				-- metagame_state.mWonMaps0 = 1
				-- if not an AI player, enable all maps
				if( metagame_state.team2.aicontrol ~= 1 ) then
					if( not ScriptCB_IsMetaAllMapsOn() ) then
						ScriptCB_SetMetaAllMapsOn( 1 )
					end
				end
			end
		end
		metagame_state.gamefinished = 1
		
		print("+++movie is playing")
		ifelem_shellscreen_fnStopMovie()
		ifs_meta_movie.isEnabled = 1		
		ScriptCB_PushScreen("ifs_meta_movie")
		
		--Metagame_Popup_GameWinner:fnActivate(1)
		return 1
	end

	-- Still playing
	return nil
end

-- Helper function: Do all the changes per Dt.
function metagame_util_OnUpdate(this,fDt)
	-- Let AI think
--	metagame_ai:fnMakeNextMove(metagame_state,fDt)

	-- Spice up math.random # generator by constantly reading off it
	local r = math.random(100)

	-- If we just returned to this screen, and a battle needs to be processed, do so.
	if(this.battleover_on_update) then
		if(metagame_state.bonusplanet) then
			ifs_meta_main:fnApplyBonus(1)
		else
			this:fnBattleOver(ifs_meta_battle.winit)
		end
		this.battleover_on_update = nil -- clear flag.
	end

	-- Update time ticker
	--print( "+ ifs_mp_gameopts.bDedicated = ", ifs_mp_gameopts.bDedicated )
	if( ifs_mp_gameopts.bDedicated ) then
		local player_count = ScriptCB_GetLobbyPlayerCount()
		--print( "+ player_count = ", player_count )
		--print( "+ ifs_mp_gameopts.iStartCnt = ", ifs_mp_gameopts.iStartCnt )
		if( (player_count) >= (ifs_mp_gameopts.iStartCnt) ) then
			metagame_state.CurTime = metagame_state.CurTime - fDt
		end		
	else	
		metagame_state.CurTime = metagame_state.CurTime - fDt
	end
	
	if(metagame_state.CurTime < 0) then
		metagame_state.CurTime = 0
	end
	if(metagame_state.NextDisplayTime >= metagame_state.CurTime) then
		metagame_state.NextDisplayTime = metagame_state.CurTime - 0.15
		local NewStr = ScriptCB_FormatTimeString(metagame_state.CurTime)
		IFText_fnSetUString(this.CurTimeLabel,NewStr)
	end

	-- Update the bouncybuttons
	this.ButtonAddScale = this.ButtonAddScale + fDt * this.ButtonDir
	if(this.ButtonAddScale > 4) then
		this.ButtonAddScale = 4
		this.ButtonDir = -8
	elseif (this.ButtonAddScale < 0) then
		this.ButtonAddScale = 0
		this.ButtonDir = 8
	end
	this.ButtonAddScale2 = this.ButtonAddScale2 + fDt * this.ButtonDir2
	if(this.ButtonAddScale2 > 1) then
		this.ButtonAddScale2 = 1
		this.ButtonDir2 = -1
	elseif (this.ButtonAddScale2 < 0) then
		this.ButtonAddScale2 = 0
		this.ButtonDir2 = 1
	end

	metagame_display_BounceSelectionRing(this,fDt)

	local HilightAlpha = this.ButtonAddScale2
	if(metagame_state.CurTime > 58) then
		HilightAlpha = 1
	elseif (metagame_state.CurTime > 57) then
		local Diff = 1 - HilightAlpha
		HilightAlpha = HilightAlpha + Diff * (metagame_state.CurTime - 57)
	end

	IFObj_fnSetColor(this.CurTimeLabel,255,255,255 * HilightAlpha)
	if(this.PickTarget) then
		IFObj_fnSetAlpha(this.PickTarget,HilightAlpha)
	end
end




