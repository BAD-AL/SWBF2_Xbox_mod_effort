--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Current [Lua-side] State of the metagame. Used by the lua interface
-- components, etc.

gMAX_PLAYERS_PER_TEAM = 8

-- Init function for the metagame_state -- called at the start of the
-- game. Resets everything to defaults
function metagame_state_fnInit(this)
	local i;
	this.team1.teamname = "Left team"
	this.team1.players.player1 = "Left Player 1"
	this.team1.lastattack = ""
	this.team1.aicontrol = nil

	this.team2.teamname = "Right team"
	this.team2.players.player1 = "Right Player 1"
	this.team2.lastattack = ""
	this.team2.aicontrol = nil

	this.numhumans = 2 -- # of humans in the game

	-- Zap rest of players
	for i=2,gMAX_PLAYERS_PER_TEAM do
		local name = string.format("player%d",i)
		this.team1.players[name] = nil
		this.team2.players[name] = nil
	end

	this.applyingbonus = nil
	this.bonusplanet = nil
	this.bSneakAttack = nil -- clear!
	this.totalplanets = 10 -- default
	this.teamsAreBackwards = nil

	this.CurTime = 0 -- in seconds
	this.bNeedsBonusScreen = nil
	this.NextDisplayTime = 0.25 -- How long until the ticker will change
	this.ShowedTurn0Intro = nil
	this.ShowedTurn1Intro = nil

	-- Constants (per game). Do need to save these.
	this.MaxTurn = 0 -- in turns, 0 = unlimited
	this.MaxTime = 0 -- in seconds, or 0 = unlimited
	this.era = 0
	this.pickteam = 1
	this.pickplanet = "yavin" -- what planet is selected during picking
	this.TimePerTurn = gTimeOutMax -- in seconds

	-- Loop over planets, reset their varbs to defaults
	local k,v
	for k,v in this.planets do
		v.owner1 = 0 -- owner of capital map
		v.owner2 = 0 -- owner of staging area map
		v.charge = 0
--		v.charge = v.chargemax
		v.destroyed = nil -- i.e. it's alive
		v.activatedthisturn = nil -- clear
		v.bBlockaded = nil -- nope, not blockaded
		v.AttackVotes = 0
		v.SecretBaseVotes = 0
		v.Bonus1Votes = 0
		v.Bonus2Votes = 0
	end

	-- charge meter count of two teams
	this.charge_meter_team1 = 0
	this.charge_meter_team2 = 0
	this.team1_charged = nil
	this.team2_charged = nil

--	this.mWonMaps0 = nil
--	this.mWonMaps1 = nil
--	this.mWonMaps2 = nil
--	this.mWonMaps3 = nil
	
	this:fnResetTurnClock()
end

-- Utility function: sets the era (by "destroying" the factional
-- planets not appropriate). Also sets ownership of the live factional
-- planets
function metagame_state_fnSetEra(this, era)
	local NumNormalPlanets = metagame_table.getnumPlanets()

	this.era = era -- note this also
	if(era == "cw") then
		this.planets.hoth.destroyed = 1
		this.planets.hoth.pickorder = NumNormalPlanets + 1 -- off the list
		this.planets.endor.destroyed = 1
		this.planets.endor.pickorder = NumNormalPlanets + 2 -- also off the list

		this.planets.kamino.destroyed = nil
		this.planets.geonosis.destroyed = nil
	elseif (era == "gcw") then
		this.planets.geonosis.destroyed = 1
		this.planets.geonosis.pickorder = NumNormalPlanets + 1 -- off the list
		this.planets.kamino.destroyed = 1
		this.planets.kamino.pickorder = NumNormalPlanets + 2 -- also off the list

		this.planets.hoth.destroyed = nil
		this.planets.endor.destroyed = nil
	else
		assert(nil)
	end
end

-- Utility function. Counts the # of planets owned by the specified
-- team [if team is nil, then it returns 2 counts, for team 1 and 2
-- respectively.]

function metagame_state_fnCountPlanets(this,team)
	local k,v

	if(team) then
		local Count = 0
		for k,v in this.planets do
			if(not v.destroyed) then
				if(v.owner1 == team) then
					Count = Count + 1
				end
				if((not v.faction_planet) and (v.owner2 == team)) then
					Count = Count + 1
				end
			end
		end
		return Count
	else
		-- Want counts for both sides at once
		local Count1,Count2 = 0,0
		for k,v in this.planets do
			if(not v.destroyed) then
				if(v.owner1 < 1.5) then
					Count1 = Count1 + 1
				else
					Count2 = Count2 + 1
				end

				if(not v.faction_planet) then
					if(v.owner2 < 1.5) then
						Count1 = Count1 + 1
					else
						Count2 = Count2 + 1
					end
				end
			end
		end
		return Count1,Count2
	end
end

-- Utility function. Returns true if the specified team (current if
-- omitted) is AI controlled.
function metagame_state_fnIsTeamAI(this, CheckTeam)
	-- Figure out which team this is for
	local ActiveTeam = this.pickteam
	-- Active bonus overrides this
	if(this.bonusplanet) then
		ActiveTeam = this.bonusplanet.owner2
	end

	ActiveTeam = CheckTeam or ActiveTeam

	if(ActiveTeam < 1.5) then
		return this.team1.aicontrol
	else
		return this.team2.aicontrol
	end
end

-- Returns true if the specified planets in p1, p2 are in backwards
-- order, nil otherwise. Sorting is first on capital map, then
-- staging.
function metagame_state_fnComparePlanets(p1,p2)
	-- Make our lives easier
	assert(not p1.faction_planet)
	assert(not p2.faction_planet)

	if(p1.owner2 ~= p2.owner2) then
		return (p1.owner2 > p2.owner2) -- swap if higher owner of capital map
	else
		-- owner2 the same. Compare staging maps
		return (p1.owner1 > p2.owner1) -- swap if higher owner of staging map
	end

end

-- Planet Sorter function. Sorts planets based on ownership, stores all
-- that in the planets.[].pickorder.
function metagame_state_fnSortPlanets(this)

	print("Sort Done. Planets look like this:")
	for k,v in this.planets do
		if(not v.destroyed) then
			if(v.faction_planet) then
				print(v.MapName,"owner1 = ",v.owner1,"sortorder=", v.pickorder)
			else
				print(v.MapName,"owner12 = ",v.owner1,v.owner2,"sortorder=",v.pickorder)
			end
		end
	end

end

-- Advance turn function. Given the metagame_state.pickplanet (aka
-- this.pickplanet within), does the work of advancing things one step
function metagame_state_fnAdvanceTurn(this,bWon)
	this.selectedcolumn = this.pickteam

	-- Switch teams only if the mission was lost
	if(not bWon) then
		this.pickteam = 3 - this.pickteam
	end

	this.bNeedsBonusScreen = 1 -- Will be handled later by flow.

	metagame_state.bSneakAttack = nil -- clear this

	local k,v
	for k,v in this.planets do
		if(not v.destroyed) then
			if(v.activatedthisturn) then
				v.charge = -1 -- will be 0 after increment below
				v.activatedthisturn = nil -- clear this, if present
			end

			-- Factional planets go up by just 1 charge per turn (just 1 owner)
			if(v.faction_planet) then
				v.charge = v.charge + 1
			else
				-- Neutral planets have 2 owners. If the same team owns both, charge
				-- goes up by 2. Else 1.
				if(math.abs(v.owner1 - v.owner2) < 0.1) then
					v.charge = v.charge + 2
				else
					v.charge = v.charge + 1
				end
			end

			-- Clamp charge to math.max
			v.charge = math.min(v.charge,v.chargemax)
		end -- not destroyed
	end -- loop over planets

	-- Resort
	metagame_state_fnSortPlanets(this)
end

-- Given the current metagame_state.pickteam, and the current planets,
-- returns a flag as to whether it could pick the current planet or
-- no, and a ustring to show in the helptext, and the selection icon to
-- show over the planet.
function metagame_state_fnCouldPickSelected(this,which)
	local PickPlanet
	if(metagame_state.applyingBonus) then
		PickPlanet = gBonusPlanetSelect
	else
		PickPlanet = gAttackPlanetSelect
	end
	local Cur = which or this.planets[PickPlanet]

	if(which) then
		local k,v
		for k,v in this.planets do
			if(which.LocalizeName == v.LocalizeName) then
				PickPlanet = k
			end
		end
	end

	local CurPlayerStr
	if(metagame_state.pickteam < 1.5) then
		CurPlayerStr = ScriptCB_getlocalizestr(metagame_state.team1.teamname)
	else
		CurPlayerStr = ScriptCB_getlocalizestr(metagame_state.team2.teamname)
	end

	-- In a bonus phase? Then use that as the determining factor.
	if(this.bonusplanet) then
		assert(this.bonusplanet.fnCouldApplyBonus)
		return this.bonusplanet.fnCouldApplyBonus(this,which)
	end

	local bCanPick,HelpStr

	-- Can never attack own planet
	if(Cur.faction_planet) then
		-- Faction planets have just 1 owner
		bCanPick = (this.pickteam ~= Cur.owner1)
	else
		-- Not faction. Check both owners
		bCanPick = ((this.pickteam ~= Cur.owner1) or (this.pickteam ~=Cur.owner2))
	end

	-- Extra-level of check even if the first passed
	if(bCanPick) then
		-- Can't attack the same planet twice in a row, unless it's the last
		-- one available
		local CurTeam = this[string.format("team%d",this.pickteam)]
		if(PickPlanet == CurTeam.lastattack) then
			local Count = metagame_state_fnCountPlanets(this,3-this.pickteam)
			bCanPick = (Count < 2)
		end
		if(not bCanPick) then
			HelpStr = ScriptCB_getlocalizestr("ifs.meta.main.attackedlastturn")
		end
	end

	-- Turn results all 3 results, show it.
	if(bCanPick) then
		HelpStr = ScriptCB_usprintf("ifs.meta.presstoattack",CurPlayerStr)
		return 1,HelpStr,"planet_select_yes"
	else
		-- If HelpStr was set above, keep it.
		HelpStr = HelpStr or ScriptCB_usprintf("ifs.meta.alreadyown",CurPlayerStr)
		return nil,HelpStr,"planet_select_no"
	end
end

-- Utility function: updates the blockaded planets (if present). This
-- should be called ownerships of any planet(s) changes.
function metagame_state_UpdateBlockade(this)
	-- Quick exit if neither team can start a blockade.
	if((not this.team1.bSetsBlockade) and (not this.team2.bSetsBlockade)) then
		return
	end

	-- Determine which team is blocked
	local iBlockedTeam = 1
	if(this.team1.bSetsBlockade) then
		iBlockedTeam = 2
	end

	-- Count how many maps are attackable
	local iAttackable = 0
	local k,v
	for k,v in this.planets do
		if((not v.destroyed) and (not v.bBlockaded)) then
			-- Map #1 goes first in all cases. Then #2, if it's not
			-- a factional planet
			if(iBlockedTeam ~= v.owner1) then
				iAttackable = iAttackable + 1
			elseif ((not v.faction_planet) and (iBlockedTeam ~= v.owner2)) then
				iAttackable = iAttackable + 1
			end
		end -- not destroyed
	end

-- blockades changed : planet still attackable if it's blockade
--	-- If we found no attackable planets, cancel all the blockades
--	if(iAttackable == 0) then
--		for k,v in this.planets do
--			v.bBlockaded = nil
--		end
--	end

end

-- Utility function: given the current state, select the best planet.
-- Returns nil if no targets exist.
function metagame_state_fnSelectBestPlanet(this)
	local k,v
	local MatchTeam

	-- If a bonus is active, that gets dibs
-- 	if(this.bonusplanet) then
-- 		MatchTeam = metagame_state.pickteam
-- 		if(this.bonusplanet.BonusIsFriendly) then
-- 			MatchTeam = this.bonusplanet.owner1
-- 		elseif (this.bonusplanet.BonusIsUnfriendly) then
-- 			MatchTeam = 3 - this.bonusplanet.owner1
-- 		end
-- 	else
		MatchTeam = this.pickteam
--	end

	local SortedPlanets = {}

	-- First pass: make a flatened array of items
	for k,v in this.planets do
		SortedPlanets[v.pickorder] = v
	end

	local i,Selection
	local NumPlanets = metagame_table.getnumPlanets()
	if(MatchTeam < 1.5) then
		for i = 1,NumPlanets do
			if(not Selection) then
				local bCouldPick = metagame_state_fnCouldPickSelected(this,SortedPlanets[i])
				if(bCouldPick) then
					Selection = i
				end
			end
		end
	else -- want team 2
		for i = NumPlanets,1,-1 do
			if(not Selection) then
				local bCouldPick = metagame_state_fnCouldPickSelected(this,SortedPlanets[i])
				if(bCouldPick) then
					Selection = i
				end
			end
		end
	end

--	print("Done selecting best, Selection =",Selection)

	for k,v in this.planets do
		if(v.pickorder == Selection) then
			if(metagame_state.applyingbonus) then
				gBonusPlanetSelect = k
			else
				gAttackPlanetSelect = k
			end
		end
	end

	return (Selection) -- Whether we found a target or not.
end

-- Utility function: changes ownership of planet's map(s), depending
-- on the attacking team, etc.
function metagame_state_fnTakeoverCurrent(this, iAttackTeam)
	local Cur = this.planets[this.pickplanet]

	print( "++++this.pickplanet = ", this.pickplanet )
	print( "++++Cur.faction_planet = ", Cur.faction_planet )
	print( "++++Cur.faction_planet = ", Cur.faction_planet )
	print( "++++Cur.owner1 = ", Cur.owner1 )
	print( "++++Cur.owner2 = ", Cur.owner2 )
	print( "++++iAttackTeam = ", iAttackTeam )
	
	if(Cur.faction_planet) then
		-- Once a faction planet is conquered, it's out of the loop permanently.
		assert(Cur.owner1 ~= iAttackTeam)
		Cur.destroyed = 1
	else
		-- Not a faction planet. Take over staging map first, then capital
		-- (unless it's a sneak attack)
		if(this.bSneakAttack) then
			assert(Cur.owner2 ~= iAttackTeam) -- otherwise, how did we attack?
			Cur.owner2 = iAttackTeam
			Cur.charge = -1 -- (will get incremented later to 0 during fnAdvanceTurn)
			this.bSneakAttack = nil -- Clear!
		else
			if(Cur.owner1 ~= iAttackTeam) then
				Cur.owner1 = iAttackTeam
			else
				if(Cur.owner2 ~= iAttackTeam) then -- otherwise, how did we attack?
					Cur.owner2 = iAttackTeam
					Cur.charge = -1 -- (will get incremented later to 0 during fnAdvanceTurn)
				end
			end
		end
	end

	metagame_state_fnSortPlanets(this)
end

-- Utility functions: for each planet that has a purely in-metagame
-- effect, there must be fnStartApplyBonus, fnCouldApplyBonus and
-- fnApplyBonus functions.

-- fnBonusActivated(this) -- only param is metagame_state (NOT the
-- named planet), returns nothing. Does any work necessary to start
-- things (or nothing, as the case may be)

-- fnCouldApplyBonus(this,which) -- takes params of metagame_state
-- (NOT the named planet), and which planet (table entry from
-- metagame_state.planets) is specified. If not specified, then
-- metagame_state.pickplanet is to be used instead. Like the normal
-- CouldPickSelected, returns 3 params: a bool as to whether this
-- bonus could be applied, a ustring to show in the helptext bar, and
-- a texture(or nil) to put around the planet

-- fnApplyBonus(this) -- takes param of metagame_state (NOT the named
-- planet), and tries to apply the bonus to the planet
-- metagame_state.pickplanet . Returns true if it wants to stay in
-- bonus mode, or nil if the bonus is all done.

-- ENDOR: Death Star -- allows destruction of planet with each use
function metagame_state_fnBonusActivated_endor(this)
end

-- See comments above this block of planet-specific bonuses
-- ENDOR: Death Star -- allows destruction of planet with each use
function metagame_state_fnCouldApplyBonus_endor(this, which)
	local Dest = which or this.planets[gBonusPlanetSelect]
	assert(gBonusPlanetSelect)
	local Me = this.planets.endor

	-- Can only pick planets that the enemy has at least a foothold on.
	print("MeOwner1 = ",Me.owner1,"Dest1 = ",Dest.owner1)
	local bCanPick = (Dest.owner1 ~= Me.owner1)
	if((not bCanPick) and (not Dest.faction_planet)) then
		print("Dest2 = ",Dest.owner2)
		bCanPick = (Dest.owner2 ~= Me.owner1)
	end

	-- Can never pick a factional planet (which better be Hoth)
	if(Dest.faction_planet) then
		bCanPick = nil
	end

	-- CurPlayerStr is whomever owns Endor (well, that better be the empire!)
	local CurPlayerStr,HelpStr
	if(Me.owner2 < 1.5) then
		CurPlayerStr = ScriptCB_getlocalizestr(this.team1.teamname)
	else
		CurPlayerStr = ScriptCB_getlocalizestr(this.team2.teamname)
	end

	print("CouldApplyBonus_endor to",Dest.MapName,bCanPick)
	if(bCanPick) then		
		--print( "metagame_state.pickplanet",metagame_state.pickplanet )
		HelpStr = ScriptCB_usprintf("ifs.meta.Bonus.endor_yes",CurPlayerStr)
		return bCanPick,HelpStr,"despayre_pick_ok"
	else
		HelpStr = ScriptCB_usprintf("ifs.meta.Bonus.endor_no",CurPlayerStr)
		return bCanPick,HelpStr,"planet_select_no"
	end
end

-- See comments above this block of planet-specific bonuses
-- ENDOR: Death Star -- allows destruction of planet with each use
function metagame_state_fnApplyBonus_endor()
	local this = metagame_state
	this.pickplanet = metagame_host_state.gBonusPlanet
	assert(this.pickplanet)

	local Idx = nil
	local selPlanet = nil
	local ret = nil
	for Idx = 1, table.getn(gMetaAttackableList) do
		selPlanet = this.planets[gMetaAttackableList[Idx].planet]
		print( "+++selPlanet = ", selPlanet )
		if( metagame_state_fnCouldApplyBonus_endor( this, selPlanet ) ) then
			ret = 1
		end			
	end
	if( not ret ) then
		-- there are no plant(s) can be apply bonus to
		-- quit from bonus mode
		print( "++++ret = ", ret )
		return nil -- bonus phase is over
	end

	if(not metagame_state_fnCouldApplyBonus_endor(this)) then
        ifelm_shellscreen_fnPlaySound("shell_menu_error")
		return 1 -- stay in bonus mode!
	end

	ifelm_shellscreen_fnPlaySound("shell_menu_accept")

	if(gPlatformStr ~= "PC") then
		ScriptCB_ShellPlayDelayedStream("imp_endor_activate_deathstar", 0, 0)
	end
	
	--print( "++this.pickplanet = ", this.pickplanet )
	--print( "++this.planets[this.pickplanet] = ", this.planets[this.pickplanet].name )
	local Dest = this.planets[this.pickplanet]
	Dest.destroyed = 1 -- Kablooie!

	-- Let the user see what happened.
    -- ifs_movietrans_PushScreen(ifs_meta_deathstar)
	
	-- play apply secret base bonus movie
	ifelem_shellscreen_fnStopMovie()
	ifs_meta_movie.winner = "common.sides.imp.name"
	ifs_meta_movie.isEnabled = 1
	ScriptCB_PushScreen("ifs_meta_movie")	

	return nil -- bonus phase is over
end

-- See comments above this block of planet-specific bonuses
function metagame_state_fnBonusActivated_geonosis(this)
end

-- See comments above this block of planet-specific bonuses
function metagame_state_fnCouldApplyBonus_geonosis(this, which)
	local Dest = which or metagame_state.planets[gBonusPlanetSelect]
	assert(gBonusPlanetSelect)
	local Me = this.planets.geonosis

	-- Can only pick planets that the enemy has at least a foothold on.
	print("MeOwner1 = ",Me.owner1,"Dest1 = ",Dest.owner1)
	local bCanPick = (Dest.owner1 ~= Me.owner1)
	if((not bCanPick) and (not Dest.faction_planet)) then
		print("Dest2 = ",Dest.owner2)
		bCanPick = (Dest.owner2 ~= Me.owner1)
	end

	-- Can never pick a factional planet (which better be Hoth)
	if(Dest.faction_planet) then
		bCanPick = nil
	end
	
	-- CurPlayerStr is whomever owns geonosis (well, that better be the empire!)
	local CurPlayerStr,HelpStr
	if(Me.owner2 < 1.5) then
		CurPlayerStr = ScriptCB_getlocalizestr(this.team1.teamname)
	else
		CurPlayerStr = ScriptCB_getlocalizestr(this.team2.teamname)
	end

	print("CouldApplyBonus_geonosis to",Dest.MapName,bCanPick)
	if(bCanPick) then
		HelpStr = ScriptCB_usprintf("ifs.meta.Bonus.endor_yes",CurPlayerStr)
		return bCanPick,HelpStr,"naboo_pick_ok"
	else
		HelpStr = ScriptCB_usprintf("ifs.meta.Bonus.endor_no",CurPlayerStr)
		return bCanPick,HelpStr,"planet_select_no"
	end
end

-- See comments above this block of planet-specific bonuses
function metagame_state_fnApplyBonus_geonosis(this)
	local this = metagame_state
	this.pickplanet = metagame_host_state.gBonusPlanet
	assert(this.pickplanet)

	local Idx = nil
	local selPlanet = nil
	local ret = nil
	for Idx = 1, table.getn(gMetaAttackableList) do
		selPlanet = this.planets[gMetaAttackableList[Idx].planet]
		print( "+++selPlanet = ", selPlanet )
		if( metagame_state_fnCouldApplyBonus_geonosis( this, selPlanet ) ) then
			ret = 1
		end			
	end
	if( not ret ) then
		-- there are no plant(s) can be apply bonus to
		-- quit from bonus mode
		print( "++++ret = ", ret )
		return nil -- bonus phase is over
	end

	if(not metagame_state_fnCouldApplyBonus_geonosis(this)) then
        ifelm_shellscreen_fnPlaySound("shell_menu_error")
		return 1 -- stay in bonus mode!
	end
	ifelm_shellscreen_fnPlaySound("shell_menu_accept")

	if(gPlatformStr ~= "PC") then
		ScriptCB_ShellPlayDelayedStream("cis_geonosis_activate_blockade", 0, 0)
	end
	
	--print( "++this.pickplanet = ", this.pickplanet )
	--print( "++this.planets[this.pickplanet] = ", this.planets[this.pickplanet].name )
	local Dest = this.planets[this.pickplanet]
	Dest.destroyed = 1 -- Kablooie!

	-- Let the user see what happened.
    -- ifs_movietrans_PushScreen(ifs_meta_deathstar)
	
	-- play apply secret base bonus movie
	ifelem_shellscreen_fnStopMovie()
	ifs_meta_movie.winner = "common.sides.cis.name"
	ifs_meta_movie.isEnabled = 1
	ScriptCB_PushScreen("ifs_meta_movie")	

	return nil -- bonus phase is over
end

-- See comments above this block of planet-specific bonuses
function metagame_state_fnBonusActivated_hoth(this)
end

-- See comments above this block of planet-specific bonuses
function metagame_state_fnCouldApplyBonus_hoth(this, which)
	local Dest = which or this.planets[gBonusPlanetSelect]
	assert(gBonusPlanetSelect)
	local Me = this.planets.hoth

	-- Can only pick planets that the enemy has at least a foothold on.
	print("MeOwner1 = ",Me.owner1,"Dest1 = ",Dest.owner1)
	local bCanPick = (Dest.owner1 ~= Me.owner1)
	if((not bCanPick) and (not Dest.faction_planet)) then
		print("Dest2 = ",Dest.owner2)
		bCanPick = (Dest.owner2 ~= Me.owner1)
	end

	-- Can never pick a factional planet (which better be Hoth)
	if(Dest.faction_planet) then
		bCanPick = nil
	end

	-- CurPlayerStr is whomever owns Hoth (well, that better be the rebels!)
	local CurPlayerStr,HelpStr
	if(Me.owner2 < 1.5) then
		CurPlayerStr = ScriptCB_getlocalizestr(this.team1.teamname)
	else
		CurPlayerStr = ScriptCB_getlocalizestr(this.team2.teamname)
	end

	print("CouldApplyBonus_hoth to",Dest.MapName,bCanPick)
	if(bCanPick) then
		HelpStr = ScriptCB_usprintf("ifs.meta.Bonus.endor_yes",CurPlayerStr)
		return bCanPick,HelpStr,"planet_pick_yes"
	else
		HelpStr = ScriptCB_usprintf("ifs.meta.Bonus.endor_no",CurPlayerStr)
		return bCanPick,HelpStr,"planet_select_no"
	end
end

-- See comments above this block of planet-specific bonuses
function metagame_state_fnApplyBonus_hoth(this)
	local this = metagame_state
	this.pickplanet = metagame_host_state.gBonusPlanet
	assert(this.pickplanet)

	local Idx = nil
	local selPlanet = nil
	local ret = nil
	for Idx = 1, table.getn(gMetaAttackableList) do
		selPlanet = this.planets[gMetaAttackableList[Idx].planet]
		print( "+++selPlanet = ", selPlanet )
		if( metagame_state_fnCouldApplyBonus_hoth( this, selPlanet ) ) then
			ret = 1
		end			
	end
	if( not ret ) then
		-- there are no plant(s) can be apply bonus to
		-- quit from bonus mode
		print( "++++ret = ", ret )
		return nil -- bonus phase is over
	end
	
	if(not metagame_state_fnCouldApplyBonus_hoth(this)) then
        ifelm_shellscreen_fnPlaySound("shell_menu_error")
		return 1 -- stay in bonus mode!
	end

	--print( "could apply hoth bonus to ", this.pickplanet )
	
	ifelm_shellscreen_fnPlaySound("shell_menu_accept")
	
	if(gPlatformStr ~= "PC") then
		ScriptCB_ShellPlayDelayedStream("all_hoth_activate_rebellion", 0, 0)
	end
						
	local Me = this.planets.hoth
	local Dest = this.planets[this.pickplanet]

	-- Owner gets our ownership
	Dest.owner1 = Me.owner1
	Dest.owner2 = Me.owner1
	
	--print( "Dest:", Dest, " owner1:", Dest.owner1, "owner2:", Dest.owner2 )

	-- play apply secret base bonus movie
	ifelem_shellscreen_fnStopMovie()
	ifs_meta_movie.winner = "common.sides.all.name"
	ifs_meta_movie.isEnabled = 1
	ScriptCB_PushScreen("ifs_meta_movie")	
	
	return nil -- bonus phase is over
end

-- See comments above this block of planet-specific bonuses
function metagame_state_fnBonusActivated_kamino(this)
end

-- See comments above this block of planet-specific bonuses
function metagame_state_fnCouldApplyBonus_kamino(this, which)
	local Dest = which or this.planets[gBonusPlanetSelect]
	assert(gBonusPlanetSelect)
	local Me = this.planets.kamino

	-- Can only pick planets that the enemy has at least a foothold on.
	print("MeOwner1 = ",Me.owner1,"Dest1 = ",Dest.owner1)
	local bCanPick = (Dest.owner1 ~= Me.owner1)
	if((not bCanPick) and (not Dest.faction_planet)) then
		print("Dest2 = ",Dest.owner2)
		bCanPick = (Dest.owner2 ~= Me.owner1)
	end

	-- Can never pick a factional planet (which better be Kamino)
	if(Dest.faction_planet) then
		bCanPick = nil
	end

	-- CurPlayerStr is whomever owns Kamino (well, that better be the rebels!)
	local CurPlayerStr,HelpStr
	if(Me.owner2 < 1.5) then
		CurPlayerStr = ScriptCB_getlocalizestr(this.team1.teamname)
	else
		CurPlayerStr = ScriptCB_getlocalizestr(this.team2.teamname)
	end

	print("CouldApplyBonus_kamino to",Dest.MapName,bCanPick)
	if(bCanPick) then
		HelpStr = ScriptCB_usprintf("ifs.meta.Bonus.endor_yes",CurPlayerStr)
		return bCanPick,HelpStr,"planet_pick_yes"
	else
		HelpStr = ScriptCB_usprintf("ifs.meta.Bonus.endor_no",CurPlayerStr)
		return bCanPick,HelpStr,"planet_select_no"
	end
end

-- See comments above this block of planet-specific bonuses
function metagame_state_fnApplyBonus_kamino(this, which)
	local this = metagame_state
	this.pickplanet = metagame_host_state.gBonusPlanet
	assert(this.pickplanet)

	local Idx = nil
	local selPlanet = nil
	local ret = nil
	for Idx = 1, table.getn(gMetaAttackableList) do
		selPlanet = this.planets[gMetaAttackableList[Idx].planet]
		print( "+++selPlanet = ", selPlanet )
		if( metagame_state_fnCouldApplyBonus_kamino( this, selPlanet ) ) then
			ret = 1
		end			
	end
	if( not ret ) then
		-- there are no plant(s) can be apply bonus to
		-- quit from bonus mode
		print( "++++ret = ", ret )
		return nil -- bonus phase is over
	end

	if(not metagame_state_fnCouldApplyBonus_kamino(this)) then
        ifelm_shellscreen_fnPlaySound("shell_menu_error")
		return 1 -- stay in bonus mode!
	end

	--print( "could apply kamino bonus to ", this.pickplanet )
	
	ifelm_shellscreen_fnPlaySound("shell_menu_accept")
	
	if(gPlatformStr ~= "PC") then
		ScriptCB_ShellPlayDelayedStream("rep_kamino_activate_insurgence", 0, 0)
	end
		
	local Me = this.planets.kamino
	local Dest = this.planets[this.pickplanet]

	-- Owner gets our ownership
	Dest.owner1 = Me.owner1
	Dest.owner2 = Me.owner1
	
	--print( "Dest:", Dest, " owner1:", Dest.owner1, "owner2:", Dest.owner2 )

	-- play apply secret base bonus movie
	ifelem_shellscreen_fnStopMovie()
	ifs_meta_movie.winner = "common.sides.rep.name"
	ifs_meta_movie.isEnabled = 1	
	ScriptCB_PushScreen("ifs_meta_movie")	
	
	return nil -- bonus phase is over
end

-- Randomizes the selections of the neutral planets.
function metagame_state_fnDistributePlanets(this)
	local i,k,v,NumNeutral
	local NeutralTable = {}

	NumNeutral = 0
	for k,v in this.planets do
		if(not v.faction_planet) then
			NumNeutral = NumNeutral + 1
			NeutralTable[NumNeutral] = v
		end
	end

--	print("Neutral Planet count: ",NumNeutral)

	-- Shuffle a table of indices
--	local ShuffleTable = {}
--	for i=1,NumNeutral do
--		ShuffleTable[i] = i
--	end
--	for i=0,(30*NumNeutral) do
--		local idx1,idx2,temp
--		idx1 = math.random(NumNeutral)
--		idx2 = math.random(NumNeutral)
--		temp = ShuffleTable[idx1]
--		ShuffleTable[idx1] = ShuffleTable[idx2]
--		ShuffleTable[idx2] = temp
--	end

		for i=1,NumNeutral do
			local pickorder = NeutralTable[i].pickorder
			if(ifs_meta_opts.mStartConfig) then
				NeutralTable[i].owner1 = ifs_meta_opts.mStartConfig[pickorder-1][1]
				NeutralTable[i].owner2 = ifs_meta_opts.mStartConfig[pickorder-1][2]
			else
				if(i <= (NumNeutral/2)) then
					NeutralTable[i].owner1 = 1
					NeutralTable[i].owner2 = 2
				else
					NeutralTable[i].owner1 = 2
					NeutralTable[i].owner2 = 1
				end
			end
		end


	
	-- Skip turn 0, as we've picked the planets
	metagame_state_fnAdvanceTurn(this)
	metagame_state_fnSelectBestPlanet(this)
end

-- Given a planet name and table (out of metagame_state.planets), and
-- an Idx (1 or 2), adds that map to the end of gMetaAttackableList
function metagame_state_fnAddAttackable(k,v,MapIdx)
	local Idx = table.getn(gMetaAttackableList) + 1
	local MapNameStr = "MapName" .. MapIdx
	local Mapluafile = v.MapName .. MapIdx

	gMetaAttackableList[Idx] = {
		planet = k, mapluafile = Mapluafile, texture = "map_" .. Mapluafile,
		Mesh = "planet_" .. v.MapName,
		OmegaY = v.RotateSpeed,
		PlanetLocName = v.LocalizeName .. "_wide",
		MapLocName = v[MapNameStr] .. "_wide",
		BonusName = v.ShortBonusText,
		BonusImage = "bonus_" .. v.MapName,
		BonusText = v.LongBonusText,
	}
end


-- Helper function: builds up a list of what maps are attackable by
-- the current team. Stuffs that in a global, gMetaAttackableList
function metagame_state_fnDetermineAttackable(this)

	gMetaAttackableList = {
	} -- reset list

-- metagame_state.pickteam

	local CurTeam = this[string.format("team%d",this.pickteam)]
	local k,v
	-- processing non-faction planets
	for k,v in this.planets do
		-- Blockaded planets are attack-able
		if((not v.destroyed) and (k ~= CurTeam.lastattack) and (not v.faction_planet)) then
			-- Map #1 goes first in all cases. Then #2, if it's not a factional planet
			if(this.pickteam ~= v.owner1) then
				--print( "++1++planet_name:", k )	
				metagame_state_fnAddAttackable(k,v,1)
			elseif( this.pickteam ~= v.owner2 ) then
				--print( "++2++planet_name:", k )
				metagame_state_fnAddAttackable(k,v,2)
			end
		end -- not destroyed
	end

	-- processing faction planets
	-- can not apply bonus to faction planet
	if( metagame_state.applyingbonus ) then
		if( table.getn(gMetaAttackableList) == 0 ) then
			metagame_state.applyingbonus = nil
			metagame_state.bonusplanet = nil
			-- reset charge meter
			--if( metagame_state.pickteam == 1 ) then
			--	metagame_state.charge_meter_team1 = 0
			--elseif( metagame_state.pickteam == 2 ) then
			--	metagame_state.charge_meter_team2 = 0
			--end
			ifs_meta_main_fnSetPage(ifs_meta_main, 1)
		end	
	else	
		for k,v in this.planets do
			-- Blockaded planets are attack-able
			if((not v.destroyed) and (k ~= CurTeam.lastattack) and (v.faction_planet)) then			
				if(this.pickteam ~= v.owner1) then								
					if( table.getn(gMetaAttackableList) == 0 ) then
						-- if this faction planet is the last one of enemy
						print( "++3++planet_name:", k )
						metagame_state_fnAddAttackable(k,v,1)
					--faction planet is the last one to be attacked
					--elseif( ( ( this.team1_charged == 1 ) and ( this.pickteam == 2 ) ) or
					--		( ( this.team2_charged == 1 ) and ( this.pickteam == 1 ) ) ) then
					--	-- if this faction has got 4 charge meter before
					--	print( "this.team1_charged:", this.team1_charged )					
					--	print( "this.team2_charged:", this.team2_charged )
					--	print( "this.pickteam:", this.pickteam )					
					--	print( "v.owner1:", v.owner1 )
					--	print( "++4++planet_name:", k )
					--	metagame_state_fnAddAttackable(k,v,1)
					end
				end
			end -- not destroyed
		end
	end

	for Idx = 1,table.getn(gMetaAttackableList) do
		print (Idx,gMetaAttackableList[Idx].mapluafile)
	end

end

-- Helper function. Determines which planets are eligible for the
-- specified team. Returns a table which has the entries, in the
-- following form:
--
-- { [{ name = "planetname", texture = "texture"}, ...] }
function metagame_state_fnDetermineBonus(this,iTeam)
	-- List of what's possible so far
	local FoundList = { }
	local TableCount = 0 -- # of items used

	local k,v
	for k,v in this.planets do
		if((not v.destroyed) and (v.charge == v.chargemax)) then
			if(v.faction_planet) then
-- 				if(iTeam == v.owner1) then
-- 					-- Qualifies. Add to list
-- 					local NewEntry = {
-- 						name = k, texture = "bonus_" .. v.MapName,
-- 						PlanetName = v.LocalizeName,
-- 						BonusName = v.ShortBonusText,
-- 					}
-- 					TableCount = TableCount + 1
-- 					FoundList[TableCount] = NewEntry
-- 				end -- eligible by owner, charge.
			else -- not a faction planet

				local bCouldPick = 1 -- true by default.
-- 				local PickedPlanet = metagame_state.planets[metagame_state.pickplanet]
-- 				if(k == "yavin") then
-- 					-- Yavin's sneak attack only makes sense when on offense, and
-- 					-- a non-factional planet has been picked, where you don't own the
-- 					-- capital map
-- 					bCouldPick = ((iTeam == metagame_state.pickteam) and
-- 												(not PickedPlanet.faction_planet) and
-- 													(PickedPlanet.owner2 ~= metagame_state.pickteam))
-- 				elseif (k == "kashyyyk") then
-- 					-- Kashyyk 'diversion' only makes sense when on defense
-- 					bCouldPick = (iTeam ~= metagame_state.pickteam)
-- 				end

				if(bCouldPick and (iTeam == v.owner1) and (iTeam == v.owner2) and (not v.bBlockaded)) then
					-- Qualifies. Add to list
					local NewEntry = {
						name = k, texture = "bonus_" .. v.MapName,
						PlanetName = v.LocalizeName,
						BonusName = v.ShortBonusText,
						BonusText = v.LongBonusText,
					}
					TableCount = TableCount + 1
					FoundList[TableCount] = NewEntry
				end -- eligible by owner, charge.
			end
		end -- not destroyed
	end -- loop over all planets

	-- Show "none" only if nothing else available
	if(TableCount < 1) then
		FoundList[1] = { name = "none", texture = "bonus_none",
				PlanetName = "common.none", BonusName = "common.none", }
		TableCount = 1
	end

	local i
	print("For iTeam = ",iTeam)
	for i=1,table.getn(FoundList) do
		print(i,FoundList[i].texture,FoundList[i].PlanetName)
	end

	return FoundList
end

-- get the attacking team
function metagame_state_fnGetAttackTeam(this)
    return metagame_state[string.format("team%d", metagame_state.pickteam)]
end

-- get attack team index
function metagame_state_fnGetAttackTeamIndex(this)
    return metagame_state.pickteam
end

-- get the defending team
function metagame_state_fnGetDefendTeam(this)
    return metagame_state[string.format("team%d", metagame_state_fnGetDefendTeamIndex(this))]
end

-- get defending team index
function metagame_state_fnGetDefendTeamIndex(this)
    local defendTeamIndex
    if (metagame_state.pickteam == 1) then
        defendTeamIndex = 2
    else
        defendTeamIndex = 1
    end
    return defendTeamIndex
end

-- get the team who is selecting in the current page
function metagame_state_fnGetCurrentTeam(this)
    if (gMetagameCurrentPage == 1) or (gMetagameCurrentPage == 3) then
        return metagame_state_fnGetAttackTeam(this)
    elseif (gMetagameCurrentPage == 2) or (gMetagameCurrentPage == 4) then
        return metagame_state_fnGetDefendTeam(this)
    end
end

metagame_state_local = {
	-- this data should not be overwritten by host's metagame state ...
	mIsSplitscreen = false,
	mJoystickTeams = {nil,nil,nil},
}

metagame_state = {

	-- All of these two should be saved
	team1 = {
		teamname = "Left team",
		lastattack = "", -- what planet they last attacked
		players = {
			player1 = "Left Player 1",
			-- [player2, player3, ...]
		},
	},
	team2 = {
		teamname = "Right team",
		lastattack = "", -- what planet they last attacked
		players = {
			player1 = "Left Player 1",
			-- [player2, player3, ...]
		},
	},
	CurTime = 0, -- in seconds
	-- Constants (per game). Do need to save these.
	MaxTurn = 0, -- in turns, 0 = unlimited
	MaxTime = 0, -- in seconds, or 0 = unlimited
	era = 0, -- 0 = classic, 1 = new [filled in after fnInit() by interface

	-- Items that don't need saving (unless we save in the middle of the
	-- setup)
	pickteam = 1, -- 1=left, 2=right. Who's currently picking
	-- pickplanet = "bespin", -- what planet is selected during picking

	-- Specific fields in these should be saved. Some items in here are
	-- constants, some change over the course of the game. For simplicity,
	-- everything is shown for the first planet; the rest have only the
	-- constants.
	planets = {
		bespin = {
			-- constants
			MapName = "BES", -- 3-char name for base map name
			LocalizeName = "planets.bespin.name",
--			fnGetBonusText = metagame_state_fnGetBonusText_bespin,
			chargemax = 1,
			ShortBonusText = "planets.bespin.shortbonus",
			LongBonusText = "planets.bespin.longbonus",
			MapName1 = "planets.bespin.mapname1", -- localization key to first map
			MapName2 = "planets.bespin.mapname2", -- localization key to second map
			RotateSpeed = 0.5,
			ModelScale = 0.183,
			BonusType = "Sabotage",

			-- variables (must be saved)
--			owner = 0, -- 0= unassigned, 1 = left, 2 = right
			charge = 1, -- charge level
			pickorder = 2, -- 1 = picked first, 2 = second, etc
		},

		kashyyyk = {
			MapName = "KAS", -- 3-char name for base map name
			LocalizeName = "planets.kashyyyk.name",
--			fnGetBonusText = metagame_state_fnGetBonusText_kashyyyk,
			chargemax = 1,
			ShortBonusText = "planets.kashyyyk.shortbonus",
			LongBonusText = "planets.kashyyyk.longbonus",
			MapName1 = "planets.kashyyyk.mapname1", -- localization key to first map
			MapName2 = "planets.kashyyyk.mapname2", -- localization key to second map
			RotateSpeed = 0.82,
			ModelScale = 0.185,
			BonusType = "Reinforcements",
			pickorder = 3, -- 1 = picked first, 2 = second, etc
		},

		naboo = {
			MapName = "NAB", -- 3-char name for base map name
			LocalizeName = "planets.naboo.name",
--			fnGetBonusText = metagame_state_fnGetBonusText_naboo,
			chargemax = 1,
			ShortBonusText = "planets.naboo.shortbonus",
			LongBonusText = "planets.naboo.longbonus",
			MapName1 = "planets.naboo.mapname1", -- localization key to first map
			MapName2 = "planets.naboo.mapname2", -- localization key to second map
			RotateSpeed = 0.80,
			ModelScale = 0.19,
			BonusType = "Regeneration",
			pickorder = 4, -- 1 = picked first, 2 = second, etc
		},

		rhenvar = {
			MapName = "RHN", -- 3-char name for base map name
			LocalizeName = "planets.rhenvar.name",
--			fnGetBonusText = metagame_state_fnGetBonusText_rhenvar,
			chargemax = 1,
			ShortBonusText = "planets.rhenvar.shortbonus",
			LongBonusText = "planets.rhenvar.longbonus",
			MapName1 = "planets.rhenvar.mapname1", -- localization key to first map
			MapName2 = "planets.rhenvar.mapname2", -- localization key to second map
			RotateSpeed = 0.73,
			ModelScale = 0.175,
			BonusType = "SensorJam", -- It's raspberry!
			pickorder = 5, -- 1 = picked first, 2 = second, etc
		},

		tatooine = {
			MapName = "TAT", -- 3-char name for base map name
			LocalizeName = "planets.tatooine.name",
--			fnGetBonusText = metagame_state_fnGetBonusText_tatooine,
			chargemax = 1,
			ShortBonusText = "planets.tatooine.shortbonus",
			LongBonusText = "planets.tatooine.longbonus",
			MapName1 = "planets.tatooine.mapname1", -- localization key to first map
			MapName2 = "planets.tatooine.mapname2", -- localization key to second map
			RotateSpeed = 0.7,
			ModelScale = 0.17,
			BonusType = "Hero",
			pickorder = 6, -- 1 = picked first, 2 = second, etc
		},

		yavin = {
			MapName = "YAV", -- 3-char name for base map name
			LocalizeName = "planets.yavin.name",
--			fnGetBonusText = metagame_state_fnGetBonusText_yavin,
			chargemax = 1,
			ShortBonusText = "planets.yavin.shortbonus",
			LongBonusText = "planets.yavin.longbonus",
			MapName1 = "planets.yavin.mapname1", -- localization key to first map
			MapName2 = "planets.yavin.mapname2", -- localization key to second map
			RotateSpeed = 0.62,
			ModelScale = 0.16,
			BonusType = "AdvancedTraining",
			pickorder = 7, -- 1 = picked first, 2 = second, etc
		},

		-- ---------------------------------------------------------------
		-- The 4 factional planets. Note that 2 of them will be marked "destroyed"
		-- at game start, when their era isn't appropriate. All of these should
		-- have BonusType = "None" (i.e. no ingame bonus), but must have the
		-- fnStartApplyBonus, fnCouldApplyBonusType and fnApplyBonusType
		-- specified instead.

		endor = {
			MapName = "END", -- 3-char name for base map name
			LocalizeName = "planets.endor.name",
			faction_planet = 1,
--			fnGetBonusText = metagame_state_fnGetBonusText_endor,
			chargemax = 1,
			ShortBonusText = "planets.endor.shortbonus",
			LongBonusText = "planets.endor.longbonus",
			MapName1 = "planets.endor.mapname1", -- localization key to first map
			MapName2 = "planets.endor.mapname2", -- localization key to second map
			RotateSpeed = 0.50,
			ModelScale = 0.15,
			BonusType = "None",

			-- In-shell metagame code for factional planet's bonuses
			fnBonusActivated = metagame_state_fnBonusActivated_endor,
			fnCouldApplyBonus = metagame_state_fnCouldApplyBonus_endor,
			fnApplyBonus = metagame_state_fnApplyBonus_endor,
		},

		geonosis = {
			MapName = "GEO", -- 3-char name for base map name
			LocalizeName = "planets.geonosis.name",
			faction_planet = 1,
--			fnGetBonusText = metagame_state_fnGetBonusText_geonosis,
			chargemax = 1,
			ShortBonusText = "planets.geonosis.shortbonus",
			LongBonusText = "planets.geonosis.longbonus",
			MapName1 = "planets.geonosis.mapname1", -- localization key to first map
			MapName2 = "planets.geonosis.mapname2", -- localization key to second map
			RotateSpeed = 0.92,
			ModelScale = 0.17,
			BonusType = "None",

			-- In-shell metagame code for factional planet's bonuses
			fnBonusActivated = metagame_state_fnBonusActivated_geonosis,
			fnCouldApplyBonus = metagame_state_fnCouldApplyBonus_geonosis,
			fnApplyBonus = metagame_state_fnApplyBonus_geonosis,
		},

		hoth = {
			MapName = "HOT", -- 3-char name for base map name
			LocalizeName = "planets.hoth.name",
			faction_planet = 1,
--			fnGetBonusText = metagame_state_fnGetBonusText_hoth,
			chargemax = 1,
			ShortBonusText = "planets.hoth.shortbonus",
			LongBonusText = "planets.hoth.longbonus",
			MapName1 = "planets.hoth.mapname1", -- localization key to first map
			MapName2 = "planets.hoth.mapname2", -- localization key to second map
			RotateSpeed = 0.68,
			ModelScale = 0.19,
			BonusType = "None",

			-- In-shell metagame code for factional planet's bonuses
			fnBonusActivated = metagame_state_fnBonusActivated_hoth,
			fnCouldApplyBonus = metagame_state_fnCouldApplyBonus_hoth,
			fnApplyBonus = metagame_state_fnApplyBonus_hoth,
		},

		kamino = {
			MapName = "KAM", -- 3-char name for base map name
			LocalizeName = "planets.kamino.name",
			faction_planet = 1,
--			fnGetBonusText = metagame_state_fnGetBonusText_kamino,
			chargemax = 1,
			ShortBonusText = "planets.kamino.shortbonus",
			LongBonusText = "planets.kamino.longbonus",
			MapName1 = "planets.kamino.mapname1", -- localization key to first map
			MapName2 = "planets.kamino.mapname2", -- localization key to second map
			RotateSpeed = 0.77,
			ModelScale = 0.16,
			BonusType = "None",

			-- In-shell metagame code for factional planet's bonuses
			fnBonusActivated = metagame_state_fnBonusActivated_kamino,
			fnCouldApplyBonus = metagame_state_fnCouldApplyBonus_kamino,
			fnApplyBonus = metagame_state_fnApplyBonus_kamino,
		},
	}, -- end of metagame_state.planets table

	-- Sorted table of planet positions, from left to right
	-- (i.e. increasing X). Should be 8 entries in here.
	-- If more are added, then metagame_state_fnSetEra() will
	-- probably need to be tweaked to move off the other planets
	-- (i.e. the factional planets for the wrong era set to positions
	-- #9,10)

	PlanetPositions = {
		{ mapx = -120, mapy =  80-0, depth = 0.16, name_y = 10 }, -- factional planet
		{ mapx = -100, mapy = -60-0, depth = 0.18, name_y = 5 },
		{ mapx = -40, mapy = 100-0, depth = 0.25, name_y = -8 },
		{ mapx =  -20, mapy = -15, depth = 0.22, name_y = -4 },
		{ mapx =  60, mapy = -40-0, depth = 0.20, name_y = 0 },
		{ mapx =  40, mapy = 80-0,  depth = 0.21, name_y = -2 },
		{ mapx =  110, mapy = 100-0,  depth = 0.20, name_y = 0 },		
		{ mapx =  150, mapy = -30-0, depth = 0.16, name_y = 10 },	-- factional planet
	},

--	fnCountPlanets = metagame_state_fnCountPlanets,

	-- Utility function. Resets the clock for this turn
	fnResetTurnClock = function(this)
		this.CurTime = this.TimePerTurn
		this.NextDisplayTime = this.TimePerTurn + 1 -- force a redraw asap
	end,
}

metagame_host_state = {

	gAttackPlanet = nil,
	gBonusPlanet = nil,
	gBonus1 = nil,
	gBonus2 = nil,

}

metagame_vote_state = 
{
	gAttackPlanetVote = "yavin",
	gBonusPlanetVote = "yavin",
	gBonus1Vote = nil,
	gBonus2Vote = nil,	
}
