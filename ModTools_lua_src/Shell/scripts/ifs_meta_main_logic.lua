--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

--------------------------------------------------------------------
--
--  IFS_META_MAIN_LOGIC.LUA
--  This file controls the main flow of the metagame.
--
--------------------------------------------------------------------

-- timeout setting
gTimeOutMax = 30.9

--
--  gMetagameCurrentPage is a value, 1 .. 4, which says which page is being displayed
--   1 = War Status, 2 = Pick Planet, 3 = Attacker bonus, 4 = Defend Bonus
gMetagameCurrentPage = 1

--  gAttackPlanetSelect is the planet that the attacker currently has selected.
--  	The attacker can change gAttackPlanetSelect with input directions (left, right, up, down)
--
--  gAttackPlanetVote is set to gAttackPlanetSelect when the attacker presses <accept>
--
--  gAttackPlanet is set to gAttackPlanetVote on local games or the host sets it
--    (by counting votes) on multiplayer games.
--
gAttackPlanetSelect = "yavin"

--  gBonusPlanetSelect is the planet that the attacker currently has selected (when applying a factional bonus).
--  	The attacker can change gBonusPlanetSelect with input directions (left, right, up, down)
--
--  gBonusPlanetVote is set to gBonusPlanetSelect when the attacker presses <accept>
--
--  gBonusPlanet is set to gBonusPlanetVote on local games or the host sets it
--    (by counting votes) on multiplayer games.
--
gBonusPlanetSelect = "yavin"

--
--  gTopBonusIdx and gBotBonusIdx are the currently
--  selected bonuses.  Players change these values with Input
--  directions (left, right)
--
--  gBonus1Vote (gBonus2Vote) is player 1's (player 2's)
--  bonus vote.  This is set when player 1 (player 2)
--  presses <accept>
gTopBonusIdx = 1
gBotBonusIdx = 1
metagame_vote_state.gBonus1Vote = nil
metagame_vote_state.gBonus2Vote = nil


-- Jumps forward one turn, updates the display, etc
function ifs_meta_main_fnAdvanceTurn(this,bWon)
	print(" ** ifs_meta_main_fnAdvanceTurn() bWon = ",bWon)
	metagame_state_fnAdvanceTurn(metagame_state,bWon)


	if(metagame_util_fnCheckWinner()) then
		-- Early Exit!
		metagame_state.CurTime = 0
		metagame_state.NextDisplayTime = 0
		return
	end

	-- Move pick to top planet of opponent
	metagame_state_fnSelectBestPlanet(metagame_state)
	metagame_state:fnResetTurnClock()
	metagame_display_fnUpdatePlanetInfo(this)
end



-- Selects a new bonus map. fDir is -1 (left) or 1 (right). Returns the
-- new index of what's selected.
function ifs_meta_main_fnNextBonus(dest,fDir,BonusList,InIdx)
	if(dest.ItemC.bAnimActive) then
		return InIdx
	end

	local Count = table.getn(BonusList)
	if(Count < 2) then
		return InIdx -- nothing further to do
	elseif (Count < 3) then
		if((InIdx > 1) and (fDir < 0)) then
			return InIdx
		elseif ((InIdx < 2) and (fDir > 0)) then
			return InIdx
		end
	end

    ifelm_shellscreen_fnPlaySound("shell_select_change")

	InIdx = InIdx - fDir
	if (InIdx < 1) then
		InIdx = Count
	elseif (InIdx > Count) then
		InIdx = 1
	end

	-- Update textures now.
	metagame_display_fnShowBonuses(dest,BonusList,InIdx)

	local fLargeSize = dest.fLargeSize
	local fSmallSize = dest.fSmallSize

	metagame_display_fnAnimateItems(dest,fDir,fSmallSize,fLargeSize,0,Count)

	-- Always fade in names as well.
	local fAnimTime = 0.3
	AnimationMgr_AddAnimation(dest.PlanetName,
			{ fTotalTime = 2 * fAnimTime,
				fStartAlpha = 0,
				fEndAlpha = 1,
			})
	AnimationMgr_AddAnimation(dest.BonusName,
			{ fTotalTime = 2 * fAnimTime,
				fStartAlpha = 0,
				fEndAlpha = 1,
			})
	return InIdx
end

-- Helper function, sets the current page to the specified
-- one. Animates items, etc.
function ifs_meta_main_fnSetPage(this,iNewPage)
	local iLastPage = gMetagameCurrentPage

	gMetagameCurrentPage = iNewPage
	this.pageTime = 0.0

	-- Now, modify metagame_state, and ifs_meta_main variables ...
	if (gMetagameCurrentPage == 1) then
		metagame_state_fnDetermineAttackable(metagame_state)
		
		--print( "++++gBonusPlanetSelect = ", gBonusPlanetSelect )
		local selPlanet
		if(metagame_state.applyingbonus) then
			--print( "++++metagame_state.pickteam", metagame_state.pickteam )
			local CurTeam = metagame_state[string.format("team%d",metagame_state.pickteam)]
			-- if current attacker is AI player, need to choose a BonusPlanet for it
			if( CurTeam.aicontrol ) then
				--print( "++++current attacker is AI player" )
				selPlanet = nil
				for Idx = 1,table.getn(gMetaAttackableList) do
					local planet_name = gMetaAttackableList[Idx].planet
					--print( "++++gMetaAttackableList[Idx].planet", planet_name )
					if( metagame_state_fnCouldPickSelected( metagame_state, metagame_state.planets[planet_name] ) ) then
						selPlanet = gMetaAttackableList[Idx].planet
					end
				end
				if( selPlanet ) then
					gBonusPlanetSelect = selPlanet
				else
					selPlanet = gBonusPlanetSelect
				end
				--print( "++++gBonusPlanetSelect=", gBonusPlanetSelect, selPlanet )
			else			
				selPlanet = gBonusPlanetSelect
			end
			-- if metagame_state.bonusplanet is nil then it's come from a saved game
			if( not metagame_state.bonusplanet ) then
				local Planet
				for k,v in metagame_state.planets do
					if( ( not v.destroyed ) and ( v.faction_planet == 1 ) ) then
						-- secret bases
						--print( "+v = ", v )
						if( ( v.owner1 == metagame_state.pickteam ) and ( v.owner2 == metagame_state.pickteam ) ) then
							--print( "+Planet = ", Planet )
							Planet = v
						end
					end
				end		
				print( "Planet = ", Planet )
				if( Planet ) then
					metagame_state.bonusplanet = Planet
					metagame_state.bonusplanet:fnBonusActivated()
				end				
			end			
		else
			selPlanet = gAttackPlanetSelect
		end

		for Idx = 1,table.getn(gMetaAttackableList) do
			if( selPlanet == gMetaAttackableList[Idx].planet ) then
				this.iMapSelectIdx = Idx
			end
		end
		
		if(not this.iMapSelectIdx) then
			this.iMapSelectIdx = 1
		end

		if( this.iMapSelectIdx > table.getn(gMetaAttackableList) ) then
			this.iMapSelectIdx = 1
		end
		
		IFObj_fnSetVis(this.AttackItems.ModelC, 1)
		IFObj_fnSetVis(this.AttackItems.PlanetName, 1)
		IFObj_fnSetVis(this.AttackItems, 1)
		--IFObj_fnSetVis(this.AttackBonusName, 1)
		--IFObj_fnSetVis(this.AttackBonusText, 1)
		
		if(not this.iMapSelectIdx) then
			if(table.getn(gMetaAttackableList)>0) then
				gBonusPlanetSelect = gMetaAttackableList[1].planet
				gAttackPlanetSelect = gMetaAttackableList[1].planet
				--print( "++++gBonusPlanetSelect=",gBonusPlanetSelect )
				this.iMapSelectIdx = 1
			end
		end

		metagame_display_fnSetMapPreviews(this)
	elseif (gMetagameCurrentPage == 2) then
		-- Going to attack planet stage. Redo selections if were just on
		-- war status page (but not if we back up to the page)

		for Idx = 1,table.getn(gMetaAttackableList) do
			if( metagame_host_state.gAttackPlanet == gMetaAttackableList[Idx].planet ) then
				this.iMapSelectIdx = Idx
			end
		end
		metagame_display_fnSetMapPreviews(this)

		-- Store choice asap
		--  Note: metagame_state.pickplanet will have to be read in from Host on network games
		metagame_state.pickplanet = metagame_host_state.gAttackPlanet

--		if(iLastPage == 1) then
--			metagame_state_fnDetermineAttackable(metagame_state)
--			this.iMapSelectIdx = table.getn(gMetaAttackableList)
--
--			for Idx = 1,table.getn(gMetaAttackableList) do
--				if( metagame_state.pickplanet == gMetaAttackableList[Idx].planet ) then
--					this.iMapSelectIdx = Idx
--				end
--			end
--		end


		-- Reset clock to 15 seconds if it's been too long
		metagame_state.CurTime = math.max(metagame_state.CurTime,gTimeOutMax)
		metagame_state.NextDisplayTime = metagame_state.TimePerTurn + 1  -- force an update ASAP

	elseif ((gMetagameCurrentPage == 3) or ((gMetagameCurrentPage == 4))) then

		local MapName = gMetaAttackableList[this.iMapSelectIdx].mapluafile
		local CurTeam = metagame_state[string.format("team%d",metagame_state.pickteam)]
		MapName = MapName .. strupper(CurTeam.char)
		metagame_state.TrueMapName = MapName
		print("TrueMapName = ", MapName)
		local FightMapName = metagame_util_fnGetValidMapName(MapName)
		metagame_state.NextMapName = FightMapName -- store for later
		print("metagame_state.NextMapName = ", metagame_state.NextMapName)

		gMetaTopBonusList = metagame_state_fnDetermineBonus(metagame_state,1)
		gTopBonusIdx = math.random(table.getn(gMetaTopBonusList))

		gMetaBotBonusList = metagame_state_fnDetermineBonus(metagame_state,2)
		gBotBonusIdx = math.random(table.getn(gMetaBotBonusList))

		-- Reset clock to 15 seconds if it's been too long
		if( (gMetagameCurrentPage == 3) and (table.getn(gMetaTopBonusList) == 1) ) then
			metagame_state.CurTime = math.max(metagame_state.CurTime,gTimeOutMax)
		elseif( (gMetagameCurrentPage == 4) and (table.getn(gMetaBotBonusList) == 1) ) then
			metagame_state.CurTime = math.max(metagame_state.CurTime,gTimeOutMax)
		else
			metagame_state.CurTime = math.max(metagame_state.CurTime,gTimeOutMax)
		end
		metagame_state.NextDisplayTime = metagame_state.TimePerTurn + 1  -- force an update ASAP
	else
		print("Illegal page! gMetagameCurrentPage = ",gMetagameCurrentPage)
	end

	-- Notify ifs_meta_main_display module that the page has changed
	--	this call will do any visual changes, trigger animations, and trigger sounds ...
	metagame_display_fnPageChanged(this)

end

-- Helper function: use planet's name to find the bonus index in bonus list
function ifs_meta_main_PlanetName_To_Index( PlanetName, BounsList )
	if( BounsList ) then
		for k,v in BounsList do
			if( PlanetName == v.name ) then
				--print( "ifs_meta_main_PlanetName_To_Index:return:", k, v.name )
				return k
			end
		end
	end
	--print( "ifs_meta_main_PlanetName_To_Index:return:nil" )
	return nil
end

-- Helper function: user hit accept during gameplay phase
function ifs_meta_main_gameplay_Bonus_Accept(this)
	assert(metagame_state.applyingbonus)

	-- bStayInBonus will be true if the bonus couldn't be selected for this
	-- planet, or there's more work to be done (e.g. jedi rebellion which
	-- changes 2 maps)
	local bStayInBonus = nil

	if( metagame_state.bonusplanet ) then
		metagame_state.pickplanet = metagame_host_state.gBonusPlanet
		if( metagame_state.bonusplanet:fnApplyBonus() ) then
			bStayInBonus = 1
		end		
	end
	
	if(bStayInBonus) then
	else
		metagame_state.applyingbonus = nil
		metagame_state.bonusplanet = nil
		-- reset charge meter
		if( metagame_state.pickteam == 1 ) then
			metagame_state.charge_meter_team1 = 0
		elseif( metagame_state.pickteam == 2 ) then
			metagame_state.charge_meter_team2 = 0
		end		
	end

	-- Update all onscreen
	metagame_state_UpdateBlockade(metagame_state)
	metagame_state_fnSortPlanets(metagame_state)
	metagame_display_fnUpdateGalaxyPlanets(this)
	metagame_display_fnUpdatePlanetInfo(this)
	metagame_display_fnHiliteCurrentButton(this)
end

-- plays end of battle voice over
function ifs_meta_main_SetBattleOverVO(this, battleResult)
    local attackTeam      = metagame_state_fnGetAttackTeam()
    local attackTeamIndex = metagame_state_fnGetAttackTeamIndex()
    local defendTeam      = metagame_state_fnGetDefendTeam()
    local defendTeamIndex = metagame_state_fnGetDefendTeamIndex()
    local planet          = metagame_state.planets[metagame_state.pickplanet]
    local missionIndexStr

    -- determine which mission has just finished
    if( (planet.owner1 ~= metagame_state.pickteam) or 
		(planet.faction_planet == 1) ) then
        missionIndexStr = "1"
    else
        missionIndexStr = "2"
    end

    -- winning first then attack team
    print( "attackTeam", attackTeam )
    print( "attackTeamIndex", attackTeamIndex )
    print( "battleResult", battleResult )
    print( "defendTeam", defendTeam )
    print( "defendTeamIndex", defendTeamIndex )
    print( "battleResult", battleResult )
    print( "metagame_state.teamsAreBackwards", metagame_state.teamsAreBackwards )
    
    -- battleResult: -1 : not valide
    -- battleResult: 1 : attacker win
    -- battleResult: 2 : defender win
	if(metagame_state.teamsAreBackwards) then
		battleResult = 3 - battleResult
	end
    
    metagame_state.streamBattleOverName = nil
    if( (battleResult == 1) and not attackTeam.aicontrol) then
		-- attacker win
        metagame_state.streamBattleOverName = attackTeam.shortname .. "_" .. "won_" .. planet.MapName .. missionIndexStr

    elseif( (battleResult == 2) and not defendTeam.aicontrol ) then		
        metagame_state.streamBattleOverName = defendTeam.shortname .. "_" .. "won_" .. planet.MapName .. missionIndexStr

    elseif( (battleResult == 2) and not attackTeam.aicontrol ) then
        metagame_state.streamBattleOverName = attackTeam.shortname .. "_" .. "lost_" .. planet.MapName .. missionIndexStr

    elseif( (battleResult == 1) and not defendTeam.aicontrol ) then
        metagame_state.streamBattleOverName = defendTeam.shortname .. "_" .. "lost_" .. planet.MapName .. missionIndexStr
    end
	
	print("+++SetBattleOverVO " .. metagame_state.streamBattleOverName)
	
end


-- plays end of battle voice over
function ifs_meta_main_PlayBattleOverVO(this, battleResult)

    -- if there was a human player
    if (metagame_state.streamBattleOverName) then
        print("PlayBattleOverVO " .. metagame_state.streamBattleOverName)
        ScriptCB_ShellPlayDelayedStream(metagame_state.streamBattleOverName, 0, 0)
    end
    
end



-- Helper function: battle is over, with a success flag in
-- 'Won'. Adjust things, move on as appropriate
function ifs_meta_main_BattleOver(this, bWon)
	-- Flag it so we can't attack the same one twice in a row
-- 	local CurTeam = metagame_state[string.format("team%d",metagame_state.pickteam)]
-- 	CurTeam.lastattack = metagame_state.pickplanet

	ifs_meta_main.NoPromptSave = nil

	if (bWon) then
		-- Flip owner.
		metagame_state_fnTakeoverCurrent(metagame_state,metagame_state.pickteam)
    end

	-- Update UI
	metagame_state_UpdateBlockade(metagame_state)

	gMetagameCurrentPage = 1
	ifs_meta_main_fnSetPage(this,1)

	ifs_meta_main_fnAdvanceTurn(this,bWon)
	metagame_display_fnUpdateGalaxyPlanets(this)
	metagame_display_fnUpdatePlanetInfo(this)
	metagame_display_fnUpdateChargeMeterByResult(this, bWon)
end

-- Helper function. Given a team and selection, does the logic for
-- them Most of the choices are ingame bonuses, which just get passed
-- on to the game to handle. A few are metagame-only.
function ifs_meta_bonus_fnSetChoice(fTeam,PlanetStr)
	print("ifs_meta_bonus_fnSetChoice(",fTeam,PlanetStr)
	local CurTeam         = metagame_state[string.format("team%d",fTeam)]
	local CurTeamName     = CurTeam.shortname -- 'all' 'cis' 'imp' or 'reb'

	if(PlanetStr ~= "none") then
		local Planet = metagame_state.planets[PlanetStr]
		Planet.activatedthisturn = 1 -- flag this
		print("Activated ",Planet.LocalizeName)

		if(fTeam == metagame_state.pickteam) then
			if( metagame_state.teamsAreBackwards ) then
				ScriptCB_MetagameSetBonus(2,Planet.BonusType) -- attacker
			else			
				ScriptCB_MetagameSetBonus(1,Planet.BonusType) -- attacker
			end
		else
			if( metagame_state.teamsAreBackwards ) then
				ScriptCB_MetagameSetBonus(1,Planet.BonusType) -- defender
			else
				ScriptCB_MetagameSetBonus(2,Planet.BonusType) -- defender
			end
		end
	end -- bonus not "none"
end


----------------------------------------------------------------------------------------
-- save the metagame info
----------------------------------------------------------------------------------------

function ifs_meta_main_StartSaveMetagame()
	print("ifs_meta_main_StartSaveMetagame")
	
	-- give all the metagame state vars to C so they can be saved
	ScriptCB_SaveMetagameState()

	-- push to ifs_meta_load to do the saving list
	ifs_meta_load.Mode = "Save"
	ifs_meta_load.ExitFunc = ifs_meta_main_ExitSaveMetagame
	
	-- make all the dialogs use this controller
	ifs_saveop.saveProfileNum = ScriptCB_GetQuitPlayer()
	
    ifs_movietrans_PushScreen(ifs_meta_load)

end

function ifs_meta_main_ExitSaveMetagame()
	print("ifs_meta_main_ExitSaveMetagame")

	-- unload the state we saved
	ScriptCB_DeleteSavedMetagameState() -- note it's no longer valid	
	
	-- don't save when we reenter ifs_meta_main
	ifs_meta_main.NoPromptSave = 1
	
	-- done with this
	ifs_saveop.saveProfileNum = nil
	ScriptCB_SetQuitPlayer(1)
	
end

---------------------------------------------------------
--  ifs_meta_main_fnUpdateHost
--
--  This function gathers the votes from all the clients
--  in the game (or times out) and sets the following values:
--
--  gAttackPlanet
--  gBonusPlanet
--  gBonus1
--  gBonus2
--
--  The above values are broadcasted to all clients, triggering
--  any page changes if necessary ...
--
function ifs_meta_main_fnUpdateHost()
--
--  Reimplement per above instructions, rather than
--    blindly setting values like the local game
--
	if(gMetagameCurrentPage==1) then
		local NumNormalPlanets = metagame_table.getnumPlanets()
		if(metagame_state.CurTime < 0.01) then
			metagame_state.CurTime = math.max(metagame_state.CurTime,gTimeOutMax)
			local mostVotes=0
			local numTiedPlanets=1

			for k,v in metagame_state.planets do
				local i = v.pickorder

				local planetVotes
				if(metagame_state.applyingbonus) then
					planetVotes = v.SecretBaseVotes
				else
					planetVotes = v.AttackVotes
				end
				-- Ignore the factional planets shunted off the normal list
				if(i <= NumNormalPlanets) then
					if (planetVotes>mostVotes) then
						mostVotes = planetVotes
						numTiedPlanets = 1
					elseif(planetVotes==mostVotes) then
						numTiedPlanets = numTiedPlanets + 1
					end
				end
			end

			local rndPlanet=math.random(numTiedPlanets)
			local cnt=1
			for k,v in metagame_state.planets do
				local i = v.pickorder
				local planetVotes
				if(metagame_state.applyingbonus) then
					planetVotes = v.SecretBaseVotes
				else
					planetVotes = v.AttackVotes
				end

				-- Ignore the factional planets shunted off the normal list
				if(i <= NumNormalPlanets) then
					if(planetVotes==mostVotes) then
						if(cnt==rndPlanet) then
							if(metagame_state.applyingbonus) then
								metagame_host_state.gBonusPlanet = k
							else
								metagame_host_state.gAttackPlanet = k
							end
						end
						cnt = cnt + 1
					end
				end
			end
			
			-- War status or bonusplanet screen
			if(metagame_state.applyingbonus) then
--				if(metagame_vote_state.gBonusPlanetVote) then
--					metagame_host_state.gBonusPlanet = metagame_vote_state.gBonusPlanetVote
--				end
				metagame_state_fnDetermineAttackable(metagame_state)
				-- another 20 seconds for attack planet selection
				metagame_state.CurTime = math.max(metagame_state.CurTime,gTimeOutMax)
				metagame_state.NextDisplayTime = metagame_state.TimePerTurn + 1  -- force an update ASAP				
			else
--				if(metagame_vote_state.gAttackPlanetVote) then
--					metagame_host_state.gAttackPlanet = metagame_vote_state.gAttackPlanetVote
--				end
			end	
		end
	elseif((gMetagameCurrentPage==3) or (gMetagameCurrentPage==4)) then	
		if(metagame_state.CurTime < 0.01) then
			metagame_state.CurTime = math.max(metagame_state.CurTime,gTimeOutMax)
			local NumNormalPlanets = metagame_table.getnumPlanets()
			local mostVotes1 = 0
			local numTiedPlanets1 = 1
			local mostVotes2 = 0
			local numTiedPlanets2 = 1

			local pickingBonus
			if(gMetagameCurrentPage==3) then
				pickingBonus = metagame_state.pickteam
			else
				pickingBonus = 3-metagame_state.pickteam
			end
			
			for k,v in metagame_state.planets do
				local i = v.pickorder

				-- Ignore the factional planets shunted off the normal list
				if( i <= NumNormalPlanets ) then
					if(pickingBonus==1) then
						if( v.Bonus1Votes > mostVotes1 ) then
							mostVotes1 = v.Bonus1Votes
							numTiedPlanets1 = 1
						elseif( v.Bonus1Votes == mostVotes1 ) then
							numTiedPlanets1 = numTiedPlanets1 + 1
						end
					else
						if( v.Bonus2Votes > mostVotes2 ) then
							mostVotes2 = v.Bonus2Votes
							numTiedPlanets2 = 1
						elseif( v.Bonus2Votes == mostVotes2 ) then
							numTiedPlanets2 = numTiedPlanets2 + 1
						end			
					end
				end
			end

			local rndPlanet1 = math.random(numTiedPlanets1)
			local rndPlanet2 = math.random(numTiedPlanets2)
			local cnt1 = 1
			local cnt2 = 1
			for k,v in metagame_state.planets do
				local i = v.pickorder
				-- Ignore the factional planets shunted off the normal list
				if(i <= NumNormalPlanets) then
					if(pickingBonus==1) then
						if( v.Bonus1Votes == mostVotes1 ) then
							if( cnt1 == rndPlanet1 ) then
								if( not metagame_host_state.gBonus1 ) then
									metagame_host_state.gBonus1 = ifs_meta_main_PlanetName_To_Index( k, gMetaTopBonusList )
								end
							end
							cnt1 = cnt1 + 1
						end
					else
						if( v.Bonus2Votes == mostVotes2 ) then
							if( cnt2 == rndPlanet2 ) then
								if( not metagame_host_state.gBonus2 ) then
									metagame_host_state.gBonus2 = ifs_meta_main_PlanetName_To_Index( k, gMetaBotBonusList )
								end						
							end
							cnt2 = cnt2 + 1
						end					
					end
				end
			end

--			if( ( table.getn(gMetaTopBonusList) == 1 ) and (gMetaTopBonusList[1].name == "none") ) then
			if(pickingBonus==1) then
				if( not metagame_host_state.gBonus1 ) then
					metagame_host_state.gBonus1 = 1
				end
			else
--			end
--			if( ( table.getn(gMetaBotBonusList) == 1 ) and (gMetaBotBonusList[1].name == "none") ) then
				if( not metagame_host_state.gBonus2 ) then
					metagame_host_state.gBonus2 = 1
				end			
--			end
			end
		
			--if((metagame_vote_state.gBonus1Vote) and (not metagame_host_state.gBonus1)) then
			--	metagame_host_state.gBonus1 = ifs_meta_main_PlanetName_To_Index( metagame_vote_state.gBonus1Vote, gMetaTopBonusList )
			--end
			--if((metagame_vote_state.gBonus2Vote) and (not metagame_host_state.gBonus2)) then
			--	metagame_host_state.gBonus2 = ifs_meta_main_PlanetName_To_Index( metagame_vote_state.gBonus2Vote, gMetaBotBonusList )
			--end
		end
	end

end

--------------------------------------------------------------
--                 MAIN UPDATE FUNCTION
--------------------------------------------------------------
function ifs_meta_main_fnUpdate(this, fDt)

	local wasApplyingBonus = metagame_state.applyingbonus
	
	this.pageTime = this.pageTime + fDt
	
	-- no mulitplayer game for galactic conquest now
	if( nil and ScriptCB_InNetSession()) then

		if(ScriptCB_GetAmHost()) then
			ifs_meta_main_fnUpdateHost()
		end
		--------------------------------------
		--	Update C++ network code
		--
		--    Host needs to send state and trigger variables:
		--    	metagame_state
		--    	gAttackPlanet
		--    	gBonusPlanet
		--    	gBonus1
		--    	gBonus2
		--
		--    Client needs to send votes:
		--    	gAttackPlanetVote
		--    	gBonusPlanetVote
		--    	gBonus1Vote
		--    	gBonus2Vote
		--
		local bEnterPage=nil
		if(not metagame_state.pickteam) then
			-- waiting for 1st message from host ...
			bEnterPage = 1
		end
		ScriptCB_UpdateMPMetagame()
	
		if((metagame_state.applyingbonus) and (not metagame_state.bonusplanet)) then
			local Planet
			for k,v in metagame_state.planets do
				if( ( not v.destroyed ) and ( v.faction_planet == 1 ) ) then
					if( ( v.owner1 == metagame_state.pickteam ) and ( v.owner2 == metagame_state.pickteam ) ) then
						Planet = v
					end
				end
			end
			if( Planet ) then		
				metagame_state.bonusplanet = Planet
				metagame_state.bonusplanet:fnBonusActivated()
			end
		end

		if(bEnterPage) then
			if((metagame_state.pickteam==1) or (metagame_state.pickteam==2)) then
				gMetagameCurrentPage = 1
				ifs_meta_main_fnSetPage(this,1) -- update screen
				this.Player1Choice = nil
				this.Player2Choice = nil
				metagame_state_fnSelectBestPlanet(metagame_state)
				metagame_display_fnUpdatePlanetInfo(this)
				metagame_display_fnUpdateChargeMeter(this)
			else
				return
			end
		end
		
		if( ( gMetagameCurrentPage == 1 ) or ( gMetagameCurrentPage == 2 ) ) then
			metagame_display_fnUpdateGalaxyPlanets(this)
			metagame_display_fnUpdateMainTitle(this)
		elseif( ( gMetagameCurrentPage == 3 ) or ( gMetagameCurrentPage == 4 ) ) then
			metagame_display_fnUpdateGalaxyPlanetsRingForBonus( this )
			metagame_display_fnSetBonusAttackMap( this )
		end

		-- display timer for multiplayer metagame		
		IFObj_fnSetVis(this.CurTimeLabel, 1)
		
		-- display player list		
		--ScriptCB_GetLobbyPlayerlist()
		--for i = 1, table.getn(ifs_meta_main_listbox_contents) do
		--	print( "+i =", i, "Player =", ifs_meta_main_listbox_contents[i].namestr )
		--end
	else
		--------------------------------------
		--  Not a network game, so look at "vote" variables
		--  and set variables that trigger a page change:
		--  (gAttackPlanet, gBonusPlanet, gBonus1, gBonus2)
		--
		if(gMetagameCurrentPage==1) then
			if( metagame_state.applyingbonus ) then
				-- applyingbonus
				if(metagame_vote_state.gBonusPlanetVote) then
					--print("+++++++++metagame_vote_state.gBonusPlanetVote", metagame_vote_state.gBonusPlanetVote)
					metagame_host_state.gBonusPlanet = metagame_vote_state.gBonusPlanetVote
				end
			else
				-- attacking
				if(metagame_vote_state.gAttackPlanetVote) then
					metagame_host_state.gAttackPlanet = metagame_vote_state.gAttackPlanetVote
				end
			end
			-- refresh title ( apply bonus / attack planet)
			metagame_display_fnUpdateMainTitle( this )			
		elseif((gMetagameCurrentPage==3) or (gMetagameCurrentPage==4)) then
			if((metagame_vote_state.gBonus1Vote) and (not metagame_host_state.gBonus1)) then
				metagame_host_state.gBonus1 = ifs_meta_main_PlanetName_To_Index( metagame_vote_state.gBonus1Vote, gMetaTopBonusList )
			end
			if((metagame_vote_state.gBonus2Vote) and (not metagame_host_state.gBonus2)) then
				metagame_host_state.gBonus2 = ifs_meta_main_PlanetName_To_Index( metagame_vote_state.gBonus2Vote, gMetaBotBonusList )
			end
			metagame_display_fnUpdateGalaxyPlanetsRingForBonus( this )
			metagame_display_fnSetBonusAttackMap( this )
		end
		
		-- no timer for singleplayer metagame		
		IFObj_fnSetVis(this.CurTimeLabel, nil)
	end

	--------------------------------------
	--  Set page according to variables ...
	--
	if(gMetagameCurrentPage==1) then
		if ( wasApplyingBonus ) then
			metagame_state.applyingbonus = wasApplyingBonus
			if(metagame_host_state.gBonusPlanet) then
                ifelm_shellscreen_fnPlaySound("shell_menu_accept")
				ifs_meta_main_gameplay_Bonus_Accept(this)
				ifs_meta_main_fnSetPage(this,1) -- update screen
			end
		elseif(metagame_host_state.gAttackPlanet) then
            ifelm_shellscreen_fnPlaySound("shell_menu_accept")
			ifs_meta_main_fnSetPage(this,2)
		end
--		IFObj_fnSetVis(this.AttackBonusName, nil)
		IFObj_fnSetVis(this.AttackBonusText, nil)
	elseif(gMetagameCurrentPage==2) then
		if(not metagame_host_state.gAttackPlanet) then
            ifelm_shellscreen_fnPlaySound("shell_menu_accept")
			ifs_meta_main_fnSetPage(this, 1)
		elseif(not this.AttackItems.ModelC.bAnimActive) then
			ifs_meta_main_fnSetPage(this,3)
		end
--		IFObj_fnSetVis(this.AttackBonusName, nil)
		IFObj_fnSetVis(this.AttackBonusText, nil)		
	elseif((gMetagameCurrentPage==3) or (gMetagameCurrentPage==4))then
		if(not metagame_host_state.gAttackPlanet) then
            ifelm_shellscreen_fnPlaySound("shell_menu_accept")
			ifs_meta_main_fnSetPage(this, 1)
		elseif((metagame_host_state.gBonus1) and (not this.Player1Choice)) then
			this.Player1Choice = metagame_host_state.gBonus1
			ifs_meta_bonus_fnSetChoice(1,gMetaTopBonusList[this.Player1Choice].name)
			metagame_display_fnHiliteCurrentButton(this)
			if(gMetagameCurrentPage==3) then
                ifelm_shellscreen_fnPlaySound("shell_menu_accept")
				ifs_meta_main_fnSetPage(this,4)
			end
		elseif((metagame_host_state.gBonus2) and (not this.Player2Choice)) then
			this.Player2Choice = metagame_host_state.gBonus2
			ifs_meta_bonus_fnSetChoice(2,gMetaBotBonusList[this.Player2Choice].name)
			metagame_display_fnHiliteCurrentButton(this)
			if(gMetagameCurrentPage==3) then
                ifelm_shellscreen_fnPlaySound("shell_menu_accept")
				ifs_meta_main_fnSetPage(this,4)
			end
		end

	if( gMetaTopBonusList ) then
		if( ( table.getn(gMetaTopBonusList) == 1 ) and (gMetaTopBonusList[1].name == "none") ) then
--			IFObj_fnSetVis( this.TopBonus.ItemC, 1 )
--			IFObj_fnSetVis( this.TopBonus.PlanetName, 1 )
			IFObj_fnSetVis( this.TopBonus.ItemC, nil )
			IFObj_fnSetVis( this.TopBonus.PlanetName, nil )
			IFObj_fnSetVis( this.TopBonus.BonusName, nil )
		else
			IFObj_fnSetVis( this.TopBonus.ItemC, nil )
			IFObj_fnSetVis( this.TopBonus.PlanetName, nil )
			IFObj_fnSetVis( this.TopBonus.BonusName, nil )
		end
	end
	if( gMetaBotBonusList ) then
		if( ( table.getn(gMetaBotBonusList) == 1 ) and (gMetaBotBonusList[1].name == "none") ) then
--			IFObj_fnSetVis( this.BotBonus.ItemC, 1 )
--			IFObj_fnSetVis( this.BotBonus.PlanetName, 1 )
			IFObj_fnSetVis( this.BotBonus.ItemC, nil )
			IFObj_fnSetVis( this.BotBonus.PlanetName, nil )
			IFObj_fnSetVis( this.BotBonus.BonusName, nil )
		else
			IFObj_fnSetVis( this.BotBonus.ItemC, nil )
			IFObj_fnSetVis( this.BotBonus.PlanetName, nil )
			IFObj_fnSetVis( this.BotBonus.BonusName, nil )
		end
	end	
		
	end
	--------------------------------------
	--	Update metagame systems ...
	--
	gIFShellScreenTemplate_fnUpdate(this, fDt)
	metagame_util_OnUpdate(this,fDt)
	metagame_ai_fnUpdate(metagame_state,fDt)

	--print( "1++++gMetagameCurrentPage=", gMetagameCurrentPage )
	--print( "1++++this.Player1Choice=", this.Player1Choice )
	--print( "1++++this.Player2Choice=", this.Player2Choice )
	
	--------------------------------------
	--	Launch battle if bonuses
	--    have been chosen ...
	--
	if((gMetagameCurrentPage == 4) and (this.Player1Choice) and (this.Player2Choice)) then
        --ifs_movietrans_PushScreen(ifs_meta_battle)
        -- go to battle directly
        ifs_meta_battle_fnOnEnter( this )
	end

	--------------------------------------------------------
	--	Timer ran out, force accept ...
	--------------------------------------------------------
	if(not ScriptCB_InNetSession()) then
		-- no timer for single player
		--if(metagame_state.CurTime < 0.01) then
		--	this:Input_Accept(0,metagame_state.team1.aicontrol)
		--	this:Input_Accept(1,metagame_state.team2.aicontrol)
		--end
	end

	--------------------------------------------------------
	--	If there's only 1 bonus to select, then select it ...
	--------------------------------------------------------

--	if(this.pageTime>3.0) then
--		if(gMetagameCurrentPage==3) then
--			if((metagame_state.pickteam==1) and(table.getn(gMetaTopBonusList)==1)) then
--				metagame_vote_state.gBonus1Vote = gMetaTopBonusList[gTopBonusIdx].name
--			elseif((metagame_state.pickteam==2) and(table.getn(gMetaBotBonusList)==1)) then
--				metagame_vote_state.gBonus2Vote = gMetaBotBonusList[gBotBonusIdx].name
--			end
--			
--		elseif(gMetagameCurrentPage==4) then
--			if((metagame_state.pickteam==1) and(table.getn(gMetaBotBonusList)==1)) then
--				metagame_vote_state.gBonus2Vote = gMetaBotBonusList[gBotBonusIdx].name
--			elseif((metagame_state.pickteam==2) and(table.getn(gMetaTopBonusList)==1)) then
--				metagame_vote_state.gBonus1Vote = gMetaTopBonusList[gTopBonusIdx].name
--			end
--		end
--	end


	-- update info box
	metagame_display_fnUpdateInfoBox( this )
	
	-- update alpha of hexagon cursor
	metagame_display_fnUpdateHexCursor( this )
end

--------------------------------------------------------------
--------------------------------------------------------------
Popup_DedicatedServer = NewPopup {
	ScreenRelativeX = 0.5, -- centered onscreen
	ScreenRelativeY = 0.5,
	height = 180,
	width = 400,
	ZPos = 50,

	title = NewIFText {
		font = "gamefont_large",
		textw = 220,
		texth = 120,
		y = -80,
	},

	buttons = NewIFContainer {
		y = 40,
	},

	fnSetMode = gPopup_Ok_fnSetMode,
	fnActivate = gPopup_Ok_fnActivate,
	Input_Accept = nil,
	Input_Back = nil,
}

DSOkButton_layout = {
	yTop = 15,
	yHeight = 45,
	ySpacing  = 5,
	width = 100,
	font = "gamefont_medium",
	buttonlist = { 
		{ tag = "ok", string = "common.ok", },
	},
}

AddVerticalButtons(Popup_DedicatedServer.buttons,DSOkButton_layout)

CreatePopupInC(Popup_DedicatedServer,"Popup_DedicatedServer")

--------------------------------------------------------------
--------------------------------------------------------------
--------------------------------------------------------------
--                 MAIN ENTER FUNCTION
--------------------------------------------------------------
function ifs_meta_main_fnEnter(this, bFwd)

	ScriptCB_SetSunlight( this )
	ifs_meta_main.NoPromptSave = 1
	
    -- need to set this here since its nil in
    -- ifs_meta_main for some reason? maybe file loading order?
	--this.fnMetagameSaveDone = ifs_meta_main_fnMetagameSaveDone
	--if( metagame_state.gamefinished == 1 ) then
	--	metagame_state.gamefinished = nil
	--	metagame_state.pickteam = 3 - metagame_state.pickteam
	--	Metagame_Popup_GameWinner:fnActivate(1)
	--end	

	--print(" + bFwd =", bFwd)
	--print(" + ifs_mp_gameopts.bDedicated =", ifs_mp_gameopts.bDedicated)
	if( bFwd ) then
		metagame_vote_state.gBonusPlanetVote = nil
		metagame_host_state.gBonusPlanet = nil
		metagame_vote_state.gAttackPlanetVote = nil
		metagame_host_state.gAttackPlanet = nil
		metagame_vote_state.gBonus1Vote = nil
		metagame_host_state.gBonus1 = nil
		metagame_vote_state.gBonus2Vote = nil
		metagame_host_state.gBonus2 = nil
		--if( ScriptCB_InNetGame() ) then
		--	--print(" + InNetGame")
		--	if (ScriptCB_NetWasHost()) then
		--		--print(" + NetWasHost")
		--		if (ScriptCB_NetWasDedicated()) then
		--			IFText_fnSetString(Popup_DedicatedServer.ti tle,"ifs.meta.popups.dedicated")
		--			Popup_DedicatedServer:fnActivate(1)
		--		end
		--	end
		--elseif(ifs_mp_gameopts.bDedicated) then
		--	IFText_fnSetString(Popup_DedicatedServer.ti tle,"ifs.meta.popups.dedicated")
		--	Popup_DedicatedServer:fnActivate(1)
		--end
	else
		--if( ifs_mp_gameopts.bDedicated ) then
		--	IFText_fnSetString(Popup_DedicatedServer.ti tle,"ifs.meta.popups.dedicated")
		--	Popup_DedicatedServer:fnActivate(1)
		--end		
	end

	this.pageTime = 0.0
	-- IFObj_fnSetVis(this.InfoBox, nil)
--	IFObj_fnSetVis(this.InfoBox.CurTeam, nil)
--	IFObj_fnSetVis(this.InfoBox.MainText, nil)

	print("+++metagame_state.gamefinished", metagame_state.gamefinished )
	
	-------------------------------
	-- Returning from a battle ...
	--
	if(bFwd and ScriptCB_IsMetagameStateSaved()) then
		-- Reload state on entry if needed.
		ScriptCB_LoadMetagameState()
		ScriptCB_DeleteSavedMetagameState() -- note it's no longer valid
		for k,v in metagame_state.planets do
			v.SecretBaseVotes = 0
			v.AttackVotes = 0
			v.Bonus1Votes = 0
			v.Bonus2Votes = 0
		end

		-- Read results from last game, update state.
		local BattleResult = ScriptCB_GetLastBattleVictory()
		print(" ** BattleResult= ",BattleResult,"pickteam = ",metagame_state.pickteam)
		if((BattleResult > 0) and (not ifs_meta_load.justLoaded)) then
			-- Team 1 is the attacker in all cases. See whether the
			-- attacker won.
			ifs_meta_main_SetBattleOverVO( this, BattleResult )
			if(metagame_state.teamsAreBackwards) then
				ifs_meta_main_BattleOver(this, BattleResult == 2)
			else
				ifs_meta_main_BattleOver(this, BattleResult == 1)
			end
		end
		
		-- ask the user if they want to save their progress
		if(this.NoPromptSave) then
			--don't try to save if its a new game or if we just loaded a game
			--this.NoPromptSave = nil
		else
			-- save game only if not finished
			if(metagame_state.gamefinished == 1) then
				-- game finished
			else
				-- game not finished
                --ifelm_shellscreen_fnPlaySound("shell_menu_enter")
				ifs_meta_main_StartSaveMetagame()
			end
		end
	end

	-------------------------------
	-- Initialization ...
	--
	print("AIControl = ",metagame_state.team1.aicontrol,metagame_state.team2.aicontrol)
	ScriptCB_ReadAllControllers(1,1) -- read all, but can't bind more (fix for 8189, NM 8/7/04)

	-- metagame has only single/split screen mode now
	--if((not ScriptCB_InNetSession()) or (ScriptCB_GetAmHost())) then
		gMetagameCurrentPage = 1
		ifs_meta_main_fnSetPage(this,1) -- update screen
		this.Player1Choice = nil
		this.Player2Choice = nil
		metagame_state_fnSelectBestPlanet(metagame_state)
		metagame_display_fnUpdatePlanetInfo(this)
	--else
	--	metagame_state.pickteam = nil
	--end

	IFObj_fnSetVis(this.AttackItems, 1)
--	IFObj_fnSetVis(this.AttackBonusName, 1)
	IFObj_fnSetVis(this.AttackBonusText, 1)
	
	local k,v
	local dest = this.galaxy
	local NumNormalPlanets = metagame_table.getnumPlanets()

	for k,v in metagame_state.planets do
		local i = v.pickorder

		-- Ignore the factional planets shunted off the normal list
		if(i <= NumNormalPlanets) then
			if(v.faction_planet) then
				IFObj_fnSetVis(dest[i].charge_meter,1)
			end
		end -- planet is in normal list
	end -- loop over all planets

	ScriptCB_SetMetagameTeams()
end
