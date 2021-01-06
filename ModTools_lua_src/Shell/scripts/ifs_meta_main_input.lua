--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

----------------------------------------------------------
--  IFS_META_MAIN_INPUT.LUA
--  This file handles all input during the metagame.
--  Note: Some input behavior is not immediate.  This is becuase
--  during network games, we may want to wait for the Host to
--  update all the clients before the game progresses.
--


----------------------------------------------------------
-- Helper function: user hit start during gameplay phase
--  Debug behavior - allow user to win/lose a battle without
--  going in-game
--
--  May want to change for MP --> Pressing Start will bring up
--  the Lobby


function metagame_input_Start(this)
	
	-- clear the bonus setting for both team
	-- to prevent the problem of using this bonus in Instance Action games
	-- bonus name defined in MetagameCallbacks.cpp
	ScriptCB_MetagameSetBonus(1,"None")
	ScriptCB_MetagameSetBonus(2,"None")	

    -- temp: start button exits metagame
   	--ScriptCB_PopScreen("ifs_sp")
   	metagame_input_SaveAndExit()
   	

--	-- Hack? Turn off any AI if we start overriding battles.
--	metagame_state.team1.aicontrol = nil
--	metagame_state.team2.aicontrol = nil
--
--	if(gMetagameCurrentPage == 1) then
--		metagame_state.pickteam = 3 - metagame_state.pickteam
--		metagame_display_fnUpdateGalaxyPlanets(this)
--		metagame_display_fnUpdatePlanetInfo(this)
--		return
--	end
--
--	if(not metagame_state_fnCouldPickSelected(metagame_state)) then
--		print("Sorry, no can do :(")
--      ifelm_shellscreen_fnPlaySound("shell_menu_error")
--		return
--	end
--
--	-- If we're applying a bonus, must confirm it.
--	if(metagame_state.applyingbonus) then
--		print("Can't do in bonus phase!")
--      ifelm_shellscreen_fnPlaySound("shell_menu_error")
--		return
--	end
--
--	-- Popup not active? Make it, exit.
--	if(not Metagame_Popup_PickWinner:fnIsActive()) then
--		local Odds = metagame_util_fnEstimateWinOdds()
--		local r = math.random(100)
--
--		-- Shove in state, activate it.
--		IFText_fnSetString(Metagame_Popup_PickWinner.showodds,string.format("Odds: %d %%",Odds))
--		if(Odds > r) then
--			Metagame_Popup_PickWinner.CurButton = "yes"
--		else
--			Metagame_Popup_PickWinner.CurButton = "no"
--		end
--		Metagame_Popup_PickWinner:fnActivate(1)
--	end
end


----------------------------------------------------------------------------------------
-- before we exit the metagame, we should prompt a save for both profiles
----------------------------------------------------------------------------------------

function metagame_input_SaveAndExit()
	print("metagame_input_SaveAndExit")
		
	ifs_saveop.doOp = "SaveProfile"
	ifs_saveop.OnSuccess = metagame_input_SaveProfile1Success
	ifs_saveop.OnCancel = metagame_input_SaveProfile1Cancel
	local iProfileIdx = 1 + ScriptCB_GetPrimaryController()
	ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
	ifs_saveop.saveProfileNum = iProfileIdx
	ifs_movietrans_PushScreen(ifs_saveop)
end

function metagame_input_SaveProfile1Success()
	print("metagame_input_SaveProfile1Success")
	-- once we reenter, start the save for player 2
	ifs_meta_main.SaveProfile2OnEnter = 1
	-- pop ifs_saveop
	ScriptCB_PopScreen()
end

function metagame_input_SaveProfile1Cancel()
	print("metagame_input_SaveProfile1Cancel")
	-- once we reenter, start the save for player 2
	ifs_meta_main.SaveProfile2OnEnter = 1
	-- pop ifs_saveop
	ScriptCB_PopScreen()
end

-----------------------------------
-- save profile2
-----------------------------------

function metagame_input_SaveAndExit2()
	print("metagame_input_SaveAndExit2")
		
	ifs_saveop.doOp = "SaveProfile"
	ifs_saveop.OnSuccess = metagame_input_SaveProfile2Success
	ifs_saveop.OnCancel = metagame_input_SaveProfile2Cancel
	ifs_saveop.saveName = ScriptCB_GetProfileName(2)
	ifs_saveop.saveProfileNum = 2
	ifs_movietrans_PushScreen(ifs_saveop)
end

function metagame_input_SaveProfile2Success()
	print("metagame_input_SaveProfile2Success")
	
	-- pop ifs_saveop
	ScriptCB_PopScreen("ifs_sp")
end

function metagame_input_SaveProfile2Cancel()
	print("metagame_input_SaveProfile2Cancel")

	-- pop ifs_saveop
	ScriptCB_PopScreen("ifs_sp")
end

----------------------------------------------------------------------------------------
-- done save profile2
----------------------------------------------------------------------------------------



------------------------------------------------------------------------
--  !!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!
--  INPUT direction functions - functions that handle the left, right,
--  up, and down movements should only be changing the following variables:
--
--  gAttackPlanetSelect
--  gBonusPlanetSelect
--  gTopBonusIdx
--  gBotBonusIdx
--
--  Flow of the metagame has been moved to ifs_meta_main_logic to simplify
--  network games - input functions can still call metagame_display_????
--  functions to update the interface
--  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


-- Helper function: reads off the leftstick, adjusts the current
-- pickplanet. The Biases are minimum values (away from the center) so
-- that if the D-Pad is used, it still behaves as expected.
function metagame_input_Leftstick(this, iJoystick, XBias, YBias, bFromAI)
	local x,y = ScriptCB_ReadLeftstick()
	if(math.abs(x) < math.abs(XBias)) then
		x = XBias
	end

	if(math.abs(y) < math.abs(YBias)) then
		y = YBias
	end

	local selPlanet
	if(metagame_state.applyingbonus) then
		selPlanet = gBonusPlanetSelect
	else
		selPlanet = gAttackPlanetSelect
	end

	local NumPlanets = metagame_table.getnumPlanets()
	local Planet = metagame_state.planets[selPlanet]
	local CurX = metagame_state.PlanetPositions[Planet.pickorder].mapx
	local CurY = metagame_state.PlanetPositions[Planet.pickorder].mapy

	-- Guesstimate where the stick is leading, find best match to it
	local NewX = CurX + x * 120
	local NewY = CurY + (-y) * 120 -- y is flipped :(
	local BestMatch = selPlanet
	local BestScore = 999999
	local k,v

	local rndPick=math.random(table.getn(gMetaAttackableList))
	for k,v in metagame_state.planets do
		if((not v.destroyed) and (v.pickorder <= NumPlanets)) then
			local dx = metagame_state.PlanetPositions[v.pickorder].mapx - NewX
			local dy = metagame_state.PlanetPositions[v.pickorder].mapy - NewY
			local dx2 = metagame_state.PlanetPositions[v.pickorder].mapx - CurX
			local dy2 = metagame_state.PlanetPositions[v.pickorder].mapy - CurY

			if((150*x*dx2 - 150*y*dy2>0) or (bFromAI))then
				local Score = sqrt(dx * dx + dy * dy)
				--print( "+++0 ", k, "Score:", Score, "BestScore", BestScore )
				if((Score < BestScore) or (bFromAI))then
					for Idx = 1,table.getn(gMetaAttackableList) do
						if(bFromAI)then
							if(Idx==rndPick) then
								BestScore = Score
								BestMatch = k
								break
							end
						else
							if((k ~= selPlanet) and (( k == gMetaAttackableList[Idx].planet ) or ((bFromAI)and(Idx==rndPick)))) then
								BestScore = Score
								BestMatch = k
							end
						end
					end
				end
			end
		end -- not destroyed
	end
	
	--print( "+++1 select:", selPlanet, "BestMatch:", BestMatch )
	
	-- Update if changed
	if(selPlanet ~= BestMatch) then
	        if(bFromAI) then
		        ifelm_shellscreen_fnPlaySound("shell_select_change")
		end
		if(metagame_state.applyingbonus) then
            ifelm_shellscreen_fnPlaySound("shell_select_change")
		end
		selPlanet = BestMatch
		if(metagame_state.applyingbonus) then
			gBonusPlanetSelect = selPlanet
		else
			gAttackPlanetSelect = selPlanet
		end

		for Idx = 1,table.getn(gMetaAttackableList) do
			if( selPlanet == gMetaAttackableList[Idx].planet ) then
				this.iMapSelectIdx = Idx
			end
		end
		metagame_display_fnSetMapPreviews(this)
		metagame_display_fnUpdateGalaxyPlanets(this)
		metagame_display_fnUpdatePlanetInfo(this)
	end
	
	--print( "+++2 select:", selPlanet, "BestMatch:", BestMatch )
end

function metagame_input_BonusLeftstick(this, iJoystick, XBias, YBias, bFromAI)
	local x,y = ScriptCB_ReadLeftstick()
	if(math.abs(x) < math.abs(XBias)) then
		x = XBias
	end

	if(math.abs(y) < math.abs(YBias)) then
		y = YBias
	end

	local selPlanet
	selPlanet = gBonusPlanetSelect

	local m, n
	local TeamNumber = metagame_state_local.mJoystickTeams[iJoystick+1]
	local NumPlanets = metagame_table.getnumPlanets()
	local Planet = nil
	local planet_name = nil
	
	if( gMetagameCurrentPage == 3 ) then
		-- attacker's bonus
		if( metagame_state.pickteam == 1 ) then
			planet_name = gMetaTopBonusList[gTopBonusIdx].name
		else
			planet_name = gMetaBotBonusList[gBotBonusIdx].name
		end
	elseif( gMetagameCurrentPage == 4 ) then
		-- defender's bonus
		if( metagame_state.pickteam == 2 ) then
			planet_name = gMetaTopBonusList[gTopBonusIdx].name
		else
			planet_name = gMetaBotBonusList[gBotBonusIdx].name
		end
	end

	--print( "planet_name =", planet_name )
	
	if( (not planet_name) or (planet_name == "none") ) then
		return
	end
	
	for k,v in metagame_state.planets do
		local i = v.pickorder
		if(i <= NumPlanets) then
			if( k == planet_name ) then
				Planet = v
			end
		end
	end
	
	local CurX = metagame_state.PlanetPositions[Planet.pickorder].mapx
	local CurY = metagame_state.PlanetPositions[Planet.pickorder].mapy

	-- Guesstimate where the stick is leading, find best match to it
	local NewX = CurX + x * 120
	local NewY = CurY + (-y) * 120 -- y is flipped :(
	local BestMatch = planet_name
	local BestScore = 999999	
	local bonusId = nil

	if(bFromAI) then
		local numSelectable
		numSelectable = 0
		for k,v in metagame_state.planets do
			if((not v.destroyed) and (v.pickorder <= NumPlanets)) then
				if( (v.owner1 == v.owner2) and (TeamNumber == v.owner1) ) then				
					if(BestMatch~=k) then
						numSelectable = numSelectable +1
					end
				end
			end -- not destroyed
		end -- loop over planets

		if(numSelectable>1) then
			local rndPick = math.random(numSelectable)
			local cnt=1
			for k,v in metagame_state.planets do
				if((not v.destroyed) and (v.pickorder <= NumPlanets)) then
					if( (v.owner1 == v.owner2) and (TeamNumber == v.owner1) ) then				
						if(BestMatch~=k) then
							if(cnt==rndPick) then
								BestMatch=k
							end
							cnt=cnt+1
						end
					end
				end -- not destroyed
			end -- loop over planets
		end
	        if(BestMatch~=planet_name) then
		        ifelm_shellscreen_fnPlaySound("shell_select_change")
		end
	else
		for k,v in metagame_state.planets do
			if((not v.destroyed) and (v.pickorder <= NumPlanets)) then
				if( (v.owner1 == v.owner2) and (TeamNumber == v.owner1) ) then				
					local dx = metagame_state.PlanetPositions[v.pickorder].mapx - NewX
					local dy = metagame_state.PlanetPositions[v.pickorder].mapy - NewY
					local dx2 = metagame_state.PlanetPositions[v.pickorder].mapx - CurX
					local dy2 = metagame_state.PlanetPositions[v.pickorder].mapy - CurY

					if(150*x*dx2 - 150*y*dy2>0) then
						local Score = sqrt(dx * dx + dy * dy)
						if(Score < BestScore) then					
							BestScore = Score
							BestMatch = k
						end
					end
				end
			end -- not destroyed
		end -- loop over planets
	end

	-- Update if changed
	--if(selPlanet ~= BestMatch) then
	--	if(metagame_state.applyingbonus) then
    --      ifelm_shellscreen_fnPlaySound("shell_select_change")
	--	end
	--	selPlanet = BestMatch

	--	metagame_display_fnSetMapPreviews(this)
	--	metagame_display_fnUpdateGalaxyPlanets(this)
	--	metagame_display_fnUpdatePlanetInfo(this)
	--end

	if( gMetagameCurrentPage == 3 ) then
		-- attacker's bonus
		if( metagame_state.pickteam == 1 ) then
			-- attacker is top( team1 )
			bonusId = ifs_meta_main_PlanetName_To_Index( BestMatch, gMetaTopBonusList )
			if( bonusId ) then
				gTopBonusIdx = bonusId
				-- show bonuses
				metagame_display_fnShowBonuses(this.TopBonus,gMetaTopBonusList,gTopBonusIdx)			
				-- show bonus' planet
				--metagame_display_fnSetBonusAttackMap( this, BestMatch )
			end
		else
			-- attacker is bot( team2 )
			bonusId = ifs_meta_main_PlanetName_To_Index( BestMatch, gMetaBotBonusList )
			if( bonusId ) then
				gBotBonusIdx = bonusId
				-- show bonuses
				metagame_display_fnShowBonuses(this.BotBonus,gMetaBotBonusList,gBotBonusIdx)			
				-- show bonus' planet
				--metagame_display_fnSetBonusAttackMap( this, BestMatch )
			end		
		end
	elseif( gMetagameCurrentPage == 4 ) then
		-- defender's bonus
		if( metagame_state.pickteam == 1 ) then	
			-- defender is bot( team2)
			bonusId = ifs_meta_main_PlanetName_To_Index( BestMatch, gMetaBotBonusList )
			if( bonusId ) then
				gBotBonusIdx = bonusId
				-- show bonuses
				metagame_display_fnShowBonuses(this.BotBonus,gMetaBotBonusList,gBotBonusIdx)
				-- show bonus' planet
				--metagame_display_fnSetBonusAttackMap( this, BestMatch )
			end
		else
			-- defender is top( team1)
			bonusId = ifs_meta_main_PlanetName_To_Index( BestMatch, gMetaTopBonusList )
			if( bonusId ) then
				gTopBonusIdx = bonusId
				-- show bonuses
				metagame_display_fnShowBonuses(this.TopBonus,gMetaTopBonusList,gTopBonusIdx)			
				-- show bonus' planet
				--metagame_display_fnSetBonusAttackMap( this, BestMatch )
			end
		end		
	end

	print( "BestMatch Planet = ", BestMatch, "gTopBonusIdx = ", gTopBonusIdx )
		
	-- change the ring setting for planet's selection of bonus
	metagame_display_fnUpdateGalaxyPlanetsRingForBonus( this )
		
end

function metagame_input_GeneralLeft(this,iJoystick,bFromAI)
	--if( ScriptCB_InNetGame() ) then
	--	if( (ScriptCB_NetWasHost() and ScriptCB_NetWasDedicated()) or (bFromAI)) then
	--		return
	--	end
	--elseif( ifs_mp_gameopts.bDedicated ) then
	--	return					
	--end

	print("Input_Left ",iJoystick,bFromAI)

    print(metagame_state_local.mJoystickTeams[iJoystick+1])
    print(string.format("team%d",metagame_state_local.mJoystickTeams[iJoystick+1]))
    
    
	local CurTeam = metagame_state[string.format("team%d",metagame_state_local.mJoystickTeams[iJoystick+1])]
	if(CurTeam.aicontrol ~= bFromAI) then
		print("Ignoring inputs on joystick",iJoystick)
		if(not bFromAI) then
            ifelm_shellscreen_fnPlaySound("shell_menu_error")
		end
	else
--		local iPickJoystick = metagame_state.pickteam - 1 -- convert lua-numbers to c-numbers
	        if(not bFromAI) then
		        ifelm_shellscreen_fnPlaySound("shell_select_change")
		end
		if((gMetagameCurrentPage == 1) and (metagame_state_local.mJoystickTeams[iJoystick+1] == metagame_state.pickteam)) then
			metagame_input_Leftstick(this,iJoystick,-0.75,0, bFromAI)
		elseif (gMetagameCurrentPage == 3) then
			metagame_input_BonusLeftstick( this, iJoystick, -0.75, 0, bFromAI )
		elseif (gMetagameCurrentPage == 4) then
			metagame_input_BonusLeftstick( this, iJoystick, -0.75, 0, bFromAI )
		else
			print("Ignoring Input_GeneralLeft ",iJoystick,bFromAI)
		end
	end
end

function metagame_input_GeneralRight(this,iJoystick,bFromAI)
	--if( ScriptCB_InNetGame() ) then
	--	if( (ScriptCB_NetWasHost() and ScriptCB_NetWasDedicated()) or (bFromAI)) then
	--		return
	--	end
	--elseif( ifs_mp_gameopts.bDedicated ) then
	--	return
	--end

--	print("Input_Right ",iJoystick,bFromAI)
	local CurTeam = metagame_state[string.format("team%d",metagame_state_local.mJoystickTeams[iJoystick+1])]
	if(CurTeam.aicontrol ~= bFromAI) then
		print("Ignoring inputs on joystick",iJoystick)
		if(not bFromAI) then
            ifelm_shellscreen_fnPlaySound("shell_menu_error")
		end
	else
--		local iPickJoystick = metagame_state.pickteam - 1 -- convert lua-numbers to c-numbers
	        if(not bFromAI) then
		        ifelm_shellscreen_fnPlaySound("shell_select_change")
		end
		if((gMetagameCurrentPage == 1) and (metagame_state_local.mJoystickTeams[iJoystick+1] == metagame_state.pickteam)) then
			metagame_input_Leftstick(this,iJoystick,0.75,0, bFromAI)
		elseif (gMetagameCurrentPage == 3) then
			metagame_input_BonusLeftstick( this, iJoystick, 0.75, 0, bFromAI )
		elseif (gMetagameCurrentPage == 4) then
			metagame_input_BonusLeftstick( this, iJoystick, 0.75, 0, bFromAI )
		else
			print("Ignoring Input_GeneralRight ",iJoystick,bFromAI)
		end
	end
end

function metagame_input_GeneralUp(this,iJoystick,bFromAI)
	--if( ScriptCB_InNetGame() and ScriptCB_NetWasHost() and ScriptCB_NetWasDedicated()) then
	--	return
	--elseif( ifs_mp_gameopts.bDedicated ) then
	--	return
	--end

--	print("Input_Left ",iJoystick,bFromAI)
	local CurTeam = metagame_state[string.format("team%d",metagame_state_local.mJoystickTeams[iJoystick+1])]
	if(CurTeam.aicontrol ~= bFromAI) then
		print("Ignoring inputs on joystick",iJoystick)
		if(not bFromAI) then
            ifelm_shellscreen_fnPlaySound("shell_menu_error")
		end
	else
--		local iPickJoystick = metagame_state.pickteam - 1 -- convert lua-numbers to c-numbers
	        if(not bFromAI) then
		        ifelm_shellscreen_fnPlaySound("shell_select_change")
		end
		if((gMetagameCurrentPage == 1) and (metagame_state_local.mJoystickTeams[iJoystick+1] == metagame_state.pickteam)) then
			metagame_input_Leftstick(this,iJoystick,0,0.75, bFromAI)
		elseif( gMetagameCurrentPage == 3 ) then
			metagame_input_BonusLeftstick( this, iJoystick, 0, 0.75, bFromAI )
		elseif( gMetagameCurrentPage == 4 ) then
			metagame_input_BonusLeftstick( this, iJoystick, 0, 0.75, bFromAI )
		else
			print("Ignoring Input_GeneralUp ",iJoystick,bFromAI)
		end
	end
end

function metagame_input_GeneralDown(this,iJoystick,bFromAI)
	--if( ScriptCB_InNetGame() ) then
	--	if( (ScriptCB_NetWasHost() and ScriptCB_NetWasDedicated()) or (bFromAI)) then
	--		return
	--	end
	--elseif( ifs_mp_gameopts.bDedicated ) then
	--	return
	--end

--	print("Input_Right ",iJoystick,bFromAI)
	local CurTeam = metagame_state[string.format("team%d",metagame_state_local.mJoystickTeams[iJoystick+1])]
	if(CurTeam.aicontrol ~= bFromAI) then
		print("Ignoring inputs on joystick",iJoystick)
		if(not bFromAI) then
            ifelm_shellscreen_fnPlaySound("shell_menu_error")
		end
	else
--		local iPickJoystick = metagame_state.pickteam - 1 -- convert lua-numbers to c-numbers
	        if(not bFromAI) then
			ifelm_shellscreen_fnPlaySound("shell_select_change")
		end
		if((gMetagameCurrentPage == 1) and (metagame_state_local.mJoystickTeams[iJoystick+1] == metagame_state.pickteam)) then
			metagame_input_Leftstick(this,iJoystick,0,-0.75, bFromAI)
		elseif( gMetagameCurrentPage == 3 ) then
			metagame_input_BonusLeftstick( this, iJoystick, 0, -0.75, bFromAI )
		elseif( gMetagameCurrentPage == 4 ) then
			metagame_input_BonusLeftstick( this, iJoystick, 0, -0.75, bFromAI )
		else
			print("Ignoring Input_GeneralUp ",iJoystick,bFromAI)
		end
	end
end


---------------------------------------------------------
--  ACCEPT function - this function should only be changing
--  "vote" values:
--
--  gAttackPlanetVote
--  gBonusPlanetVote
--  gBonus1Vote
--  gBonus2Vote
--
--  Important!!! It is no longer checking whether the values
--  	are appropriate.  This needs to be reimplemented
--
--  The main Update function in ifs_meta_main_logic
--  will take it from there (network games have to
--  be treated differently)
--
function metagame_input_Accept(this,iJoystick,bFromAI)
	-- no multiplayer mode for galatic conquest
	--if( ScriptCB_InNetGame() ) then
	--	if( (ScriptCB_NetWasHost() and ScriptCB_NetWasDedicated()) or (bFromAI)) then
	--		return
	--	end
	--elseif( ifs_mp_gameopts.bDedicated ) then
	--	return
	--end

--	print("Input_Accept ",iJoystick,bFromAI)
	local CurTeam = metagame_state[string.format("team%d",metagame_state_local.mJoystickTeams[iJoystick+1])]
	if(CurTeam.aicontrol ~= bFromAI) then
		print("Ignoring inputs on joystick",iJoystick)
		if(not bFromAI) then
            ifelm_shellscreen_fnPlaySound("shell_menu_error")
		end
	else
        ifelm_shellscreen_fnPlaySound("shell_menu_accept")
		-- Allowed to send inputs
--		local iPickJoystick = metagame_state.pickteam - 1 -- convert lua-numbers to c-numbers
		if((gMetagameCurrentPage == 1) and (metagame_state_local.mJoystickTeams[iJoystick+1] == metagame_state.pickteam)) then
			-- War status or bonusplanet screen
			if(metagame_state.applyingbonus) then
				metagame_vote_state.gBonusPlanetVote = gBonusPlanetSelect
			else
				metagame_vote_state.gAttackPlanetVote = gAttackPlanetSelect
			end
--		elseif ((gMetagameCurrentPage == 2) and (iPickJoystick == iJoystick)) then
		elseif (gMetagameCurrentPage == 3) then
			-- Attacker bonus page. Validate that we can change state,
			-- then make the choice.

			if((metagame_state_local.mJoystickTeams[iJoystick+1] == 1) and (metagame_state.pickteam == 1)) then
				metagame_vote_state.gBonus1Vote = gMetaTopBonusList[gTopBonusIdx].name
			elseif ((metagame_state_local.mJoystickTeams[iJoystick+1] == 2) and (metagame_state.pickteam == 2)) then
				metagame_vote_state.gBonus2Vote = gMetaBotBonusList[gBotBonusIdx].name
			end
			
			--print( "metagame_vote_state.gBonus1Vote:B ", metagame_vote_state.gBonus1Vote )
			--print( "metagame_vote_state.gBonus2Vote:B ", metagame_vote_state.gBonus2Vote )
			--print( "metagame_host_state.gBonus1:B ", metagame_host_state.gBonus1 )
			--print( "metagame_host_state.gBonus2:B ", metagame_host_state.gBonus2 )
			
		elseif (gMetagameCurrentPage == 4) then
			-- Defender bonus (i.e. not the pick team)
			if((metagame_state_local.mJoystickTeams[iJoystick+1] == 1) and (metagame_state.pickteam == 2)) then
				metagame_vote_state.gBonus1Vote = gMetaTopBonusList[gTopBonusIdx].name
			elseif ((metagame_state_local.mJoystickTeams[iJoystick+1] == 2) and (metagame_state.pickteam == 1)) then
				metagame_vote_state.gBonus2Vote = gMetaBotBonusList[gBotBonusIdx].name
			end

			--print( "metagame_vote_state.gBonus1Vote:C ", metagame_vote_state.gBonus1Vote )
			--print( "metagame_vote_state.gBonus2Vote:C ", metagame_vote_state.gBonus2Vote )
			--print( "metagame_host_state.gBonus1:C ", metagame_host_state.gBonus1 )
			--print( "metagame_host_state.gBonus2:C ", metagame_host_state.gBonus2 )
			
		else
			-- invalid page!
			print("Ignoring Input_Accept ",iJoystick,bFromAI)
		end
		
        
	end
end


function metagame_input_Misc(this,iJoystick,bFromAI)
--
--  REIMPLEMENT WITH MP IN MIND
--
--	if(gMetagameCurrentPage == 1) then
--		gMetagameSetPage = 2
--	elseif (gMetagameCurrentPage == 2) then
--		gMetagameSetPage = 3
--	else
--		gMetagameSetPage = 1
--	end
end

function metagame_input_Back(this,iJoystick,bFromAI)
	if( 1 ) then
		return
	end
	
	if(ScriptCB_InNetSession()) then
--
--  FIXME
--
	else
		print("Input_Back ",iJoystick,bFromAI)
		local CurTeam = metagame_state[string.format("team%d",metagame_state.pickteam)]
		if((CurTeam.aicontrol) or (metagame_state.pickteam ~= (metagame_state_local.mJoystickTeams[iJoystick+1])))then
			print("Ignoring inputs on joystick",iJoystick)
			if(not bFromAI) then
                --ifelm_shellscreen_fnPlaySound("shell_menu_error")
				--temp: bail
				ScriptCB_PopScreen()			
			end
		else
            ifelm_shellscreen_fnPlaySound("shell_menu_exit")
			-- If we got this far, then it should proceed.
			if(gMetagameCurrentPage == 1) then
				-- ScriptCB_PopScreen()
			elseif(gMetagameCurrentPage == 4) then
				-- do not go back from page 4 to page 3
			else
				metagame_host_state.gAttackPlanet = nil
			end
		end
	end
	
end

function metagame_input_MouseOverModel(this, model)
	--if( ScriptCB_InNetGame() ) then
	--	if( (ScriptCB_NetWasHost() and ScriptCB_NetWasDedicated()) or (bFromAI)) then
	--		return
	--	end
	--elseif( ifs_mp_gameopts.bDedicated ) then
	--	return
	--end

	local k,v
	
	print("+++model = ", model)
	print("+++metagame_state_local.mJoystickTeams[1] = ", metagame_state_local.mJoystickTeams[1])
	print("+++metagame_state.pickteam = ", metagame_state.pickteam)
	
	if( not model ) then
		return
	end
	
	-- if this is on the page 1, check the mouse with each galaxy
	if( (metagame_state_local.mJoystickTeams[1] == metagame_state.pickteam) ) then
		if( gMetagameCurrentPage == 1 ) then
			for k,v in metagame_state.planets do
				if( v.pickorder == model.tag ) then
					for Idx = 1,table.getn(gMetaAttackableList) do
						if( k == gMetaAttackableList[Idx].planet ) then
							this.iMapSelectIdx = Idx
							if(metagame_state.applyingbonus) then
								gBonusPlanetSelect = k
							else
								gAttackPlanetSelect = k
							end
						end
					end
					metagame_display_fnSetMapPreviews(this)
					metagame_display_fnUpdateGalaxyPlanets(this)
					metagame_display_fnUpdatePlanetInfo(this)
					--print( "galaxy", metagame_state.pickplanet )
				end
			end
		elseif( gMetagameCurrentPage == 3 ) then
			local bonus_list = nil
			local bonusId = nil
			if( metagame_state.pickteam == 1 ) then
				bonus_list = gMetaTopBonusList
			else
				bonus_list = gMetaBotBonusList
			end
			for k,v in metagame_state.planets do
				if( v.pickorder == model.tag ) then
					for Idx = 1,table.getn(bonus_list) do
						print("+++ bonus_list[",Idx, "].name=", bonus_list[Idx].name)
						if( k == bonus_list[Idx].name ) then
							print( "++++ selected planet=", bonus_list[Idx].name )
							bonusId = ifs_meta_main_PlanetName_To_Index( bonus_list[Idx].name, bonus_list )
							print( "++++ planet =", bonusId )
						end
					end
				end
			end
			if( bonusId ) then
				if( metagame_state.pickteam == 1 ) then
					gTopBonusIdx = bonusId
					-- show bonuses
					metagame_display_fnShowBonuses(this.TopBonus,gMetaTopBonusList,gTopBonusIdx)
				else
					gBotBonusIdx = bonusId
					-- show bonuses
					metagame_display_fnShowBonuses(this.BotBonus,gMetaBotBonusList,gBotBonusIdx)							
				end
				-- change the ring setting for planet's selection of bonus
				metagame_display_fnUpdateGalaxyPlanetsRingForBonus( this )										
			end
		end
	elseif( (metagame_state_local.mJoystickTeams[1] ~= metagame_state.pickteam) ) then
		if( gMetagameCurrentPage == 4 ) then
			local bonus_list = nil
			local bonusId = nil
			if( metagame_state.pickteam == 1 ) then
				bonus_list = gMetaBotBonusList
			else
				bonus_list = gMetaTopBonusList
			end
			print("+++model.tag", model.tag)
			for k,v in metagame_state.planets do
				if( v.pickorder == model.tag ) then
					for Idx = 1,table.getn(bonus_list) do
						print("+++ bonus_list[",Idx, "].name=", bonus_list[Idx].name)
						if( k == bonus_list[Idx].name ) then
							print( "++++ selected planet=", bonus_list[Idx].name )
							bonusId = ifs_meta_main_PlanetName_To_Index( bonus_list[Idx].name, bonus_list )
							print( "++++ planet =", bonusId )
						end
					end
				end
			end
			if( bonusId ) then
				if( metagame_state.pickteam == 1 ) then
					gBotBonusIdx = bonusId
					-- show bonuses
					metagame_display_fnShowBonuses(this.BotBonus,gMetaBotBonusList,gBotBonusIdx)
				else
					gTopBonusIdx = bonusId
					-- show bonuses
					metagame_display_fnShowBonuses(this.TopBonus,gMetaTopBonusList,gTopBonusIdx)
				end
				-- change the ring setting for planet's selection of bonus
				metagame_display_fnUpdateGalaxyPlanetsRingForBonus( this )
			end
		end
	end
end

function metagame_input_PauseAccept( this,iJoystick,bFromAI )
	if(ifs_meta_main.CurButton == "resume") then
		ifs_meta_main.paused = nil
		IFObj_fnSetVis(ifs_meta_main.buttons, nil)
	elseif(ifs_meta_main.CurButton == "load") then
		ifs_meta_load.Mode = "Load"
        ifs_movietrans_PushScreen(ifs_meta_load)
	elseif(ifs_meta_main.CurButton == "quit") then
		metagame_input_Start(this)
	end
end
