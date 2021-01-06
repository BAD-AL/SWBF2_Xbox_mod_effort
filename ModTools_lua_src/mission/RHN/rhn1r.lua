--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("gametype_conquest")

---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------
function ScriptInit()
	-- Designers, these two lines *MUST* be first!
	SetPS2ModelMemory(2097152 + 65536 * 3)
	ReadDataFile("ingame.lvl")

	--  REP Attacking (attacker is always #1)
	local REP = 1;
	local CIS = 2;
	--  These variables do not change
	local ATT = 1;
	local DEF = 2;

	AddMissionObjective(REP, "orange", "level.rhenvar1.objectives.1")
	AddMissionObjective(REP, "red", "level.rhenvar1.objectives.2")
	--  AddMissionObjective(REP, "red", "level.rhenvar1.objectives.3")
	AddMissionObjective(CIS, "orange", "level.rhenvar1.objectives.1")
	--  AddMissionObjective(CIS, "red", "level.rhenvar1.objectives.2")
	AddMissionObjective(CIS, "red", "level.rhenvar1.objectives.3")

	ReadDataFile("sound\\rhn.lvl;rhn1cw")
	ReadDataFile("SIDE\\rep.lvl",
							 "rep_hover_fightertank",
							 "rep_inf_basic",
							 "rep_inf_macewindu",        
							 "rep_walk_atte",
							 "rep_inf_jet_trooper")
	ReadDataFile("SIDE\\cis.lvl",
							 "cis_inf_basic",
							 "cis_inf_countdooku",        
							 "cis_inf_droideka",
							 "cis_hover_aat")

	SetAttackingTeam(ATT)

	--  Republic Stats
	SetTeamName(REP, "Republic")
	SetTeamIcon(REP, "rep_icon")
	AddUnitClass(REP, "rep_inf_clone_trooper",11)
	AddUnitClass(REP, "rep_inf_arc_trooper",3)
	AddUnitClass(REP, "rep_inf_clone_pilot",4)
	AddUnitClass(REP, "rep_inf_clone_sharpshooter",4)
	AddUnitClass(REP, "rep_inf_jet_trooper",3)
	SetHeroClass(REP, "rep_inf_macewindu")

	--  CIS Stats
	SetTeamName(CIS, "CIS")
	SetTeamIcon(CIS, "cis_icon")
	AddUnitClass(CIS, "cis_inf_battledroid",11)
	AddUnitClass(CIS, "cis_inf_assault",3)
	AddUnitClass(CIS, "cis_inf_pilotdroid",4)
	AddUnitClass(CIS, "cis_inf_assassindroid",4)
	AddUnitClass(CIS, "cis_inf_droideka",3)
	SetHeroClass(CIS, "cis_inf_countdooku")

	--  Attacker Stats
	SetUnitCount(ATT, 25)
	SetReinforcementCount(ATT, 250)
	teamATT = ConquestTeam:New{team = ATT}
	teamATT:AddBleedThreshold(21, 0.75)
	teamATT:AddBleedThreshold(11, 2.25)
	teamATT:AddBleedThreshold(1, 3.0)
	teamATT:Init()

	--  Defender Stats
	SetUnitCount(DEF, 25)
	SetReinforcementCount(DEF, 250)
	teamDEF = ConquestTeam:New{team = DEF}
	teamDEF:AddBleedThreshold(21, 0.75)
	teamDEF:AddBleedThreshold(11, 2.25)
	teamDEF:AddBleedThreshold(1, 3.0)
	teamDEF:Init()

	--  Level Stats
	ClearWalkers()
	SetMemoryPoolSize ("EntityWalker",-1)
	AddWalkerType(0, 12) -- 12 droidekas
	AddWalkerType(1, 0) -- 0 atsts with 1 leg pairs each
	AddWalkerType(2, 0) -- 0 atats with 2 leg pairs each
	AddWalkerType(3, 1) -- 2 attes with 3 leg pairs each
	SetMemoryPoolSize("Commandwalker", 1)
	--  SetMemoryPoolSize("EntityFlyer", 5)
	SetMemoryPoolSize("EntityHover", 6)
	SetMemoryPoolSize("MountedTurret", 48)
	SetMemoryPoolSize("PowerupItem", 60)
	SetMemoryPoolSize("EntityMine", 40)
	SetMemoryPoolSize("Weapon", 280)
	ReadDataFile("RHN\\RHN1.lvl")
	SetSpawnDelay(10.0, 0.25)
	SetDenseEnvironment("false")
	--  AddDeathRegion("Death")

	--  AI
	SetAIVehicleNotifyRadius(80)
	SetMaxFlyHeight(30)
	SetMaxPlayerFlyHeight(30)   

	--  Sound
	OpenAudioStream("sound\\rhn.lvl",  "rhncw_music")
	OpenAudioStream("sound\\cw.lvl",  "cw_vo")
	OpenAudioStream("sound\\cw.lvl",  "cw_tac_vo")

	if(ScriptCB_GetPlatform() == "PS2") then
		OpenAudioStream("sound\\rhn.lvl",  "rhn1")
		OpenAudioStream("sound\\rhn.lvl",  "rhn1")
	else
		OpenAudioStream("sound\\rhn.lvl",  "rhn")
		OpenAudioStream("sound\\rhn.lvl",  "rhn")
	end

	SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
	SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
	SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
	SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

	--SetOutOfBoundsVoiceOver(2, "Repleaving")
	--SetOutOfBoundsVoiceOver(1, "Cisleaving")

	SetAmbientMusic(REP, 1.0, "rep_RHN_amb_start",  0,1)
	SetAmbientMusic(REP, 0.99, "rep_RHN_amb_middle", 1,1)
	SetAmbientMusic(REP, 0.1,"rep_RHN_amb_end",    2,1)
	SetAmbientMusic(CIS, 1.0, "cis_RHN_amb_start",  0,1)
	SetAmbientMusic(CIS, 0.99, "cis_RHN_amb_middle", 1,1)
	SetAmbientMusic(CIS, 0.1,"cis_RHN_amb_end",    2,1)
	SetVictoryMusic(REP, "rep_rhn_amb_victory")
	SetDefeatMusic (REP, "rep_rhn_amb_defeat")
	SetVictoryMusic(CIS, "cis_rhn_amb_victory")
	SetDefeatMusic (CIS, "cis_rhn_amb_defeat")

	SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
	SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
	--SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
	--SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
	SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
	SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
	SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
	SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
	SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

	SetPlanetaryBonusVoiceOver(CIS, CIS, 0, "CIS_bonus_CIS_medical")
	SetPlanetaryBonusVoiceOver(CIS, REP, 0, "CIS_bonus_REP_medical")
	SetPlanetaryBonusVoiceOver(CIS, CIS, 1, "")
	SetPlanetaryBonusVoiceOver(CIS, REP, 1, "")
	SetPlanetaryBonusVoiceOver(CIS, CIS, 2, "CIS_bonus_CIS_sensors")
	SetPlanetaryBonusVoiceOver(CIS, REP, 2, "CIS_bonus_REP_sensors")
	SetPlanetaryBonusVoiceOver(CIS, CIS, 3, "CIS_bonus_CIS_hero")
	SetPlanetaryBonusVoiceOver(CIS, REP, 3, "CIS_bonus_REP_hero")
	SetPlanetaryBonusVoiceOver(CIS, CIS, 4, "CIS_bonus_CIS_reserves")
	SetPlanetaryBonusVoiceOver(CIS, REP, 4, "CIS_bonus_REP_reserves")
	SetPlanetaryBonusVoiceOver(CIS, CIS, 5, "CIS_bonus_CIS_sabotage")--sabotage
	SetPlanetaryBonusVoiceOver(CIS, REP, 5, "CIS_bonus_REP_sabotage")
	SetPlanetaryBonusVoiceOver(CIS, CIS, 6, "")
	SetPlanetaryBonusVoiceOver(CIS, REP, 6, "")
	SetPlanetaryBonusVoiceOver(CIS, CIS, 7, "CIS_bonus_CIS_training")--advanced training
	SetPlanetaryBonusVoiceOver(CIS, REP, 7, "CIS_bonus_REP_training")--advanced training

	SetPlanetaryBonusVoiceOver(REP, REP, 0, "REP_bonus_REP_medical")
	SetPlanetaryBonusVoiceOver(REP, CIS, 0, "REP_bonus_CIS_medical")
	SetPlanetaryBonusVoiceOver(REP, REP, 1, "")
	SetPlanetaryBonusVoiceOver(REP, CIS, 1, "")
	SetPlanetaryBonusVoiceOver(REP, REP, 2, "REP_bonus_REP_sensors")
	SetPlanetaryBonusVoiceOver(REP, CIS, 2, "REP_bonus_CIS_sensors")
	SetPlanetaryBonusVoiceOver(REP, REP, 3, "REP_bonus_REP_hero")
	SetPlanetaryBonusVoiceOver(REP, CIS, 3, "REP_bonus_CIS_hero")
	SetPlanetaryBonusVoiceOver(REP, REP, 4, "REP_bonus_REP_reserves")
	SetPlanetaryBonusVoiceOver(REP, CIS, 4, "REP_bonus_CIS_reserves")
	SetPlanetaryBonusVoiceOver(REP, REP, 5, "REP_bonus_REP_sabotage")--sabotage
	SetPlanetaryBonusVoiceOver(REP, CIS, 5, "REP_bonus_CIS_sabotage")
	SetPlanetaryBonusVoiceOver(REP, REP, 6, "")
	SetPlanetaryBonusVoiceOver(REP, CIS, 6, "")
	SetPlanetaryBonusVoiceOver(REP, REP, 7, "REP_bonus_REP_training")--advanced training
	SetPlanetaryBonusVoiceOver(REP, CIS, 7, "REP_bonus_CIS_training")--advanced training

	--  Camera Stats
	--Rhen Var 1 Harbor
	--Ice Cave
	AddCameraShot(0.237977, 0.038345, -0.958155, 0.154386, -231.233429, 9.040294, 33.124115)
	--Building
	AddCameraShot(0.931093, 0.004173, -0.364754, 0.001635, -111.028969, 7.049152, 58.597565)
	--Overhead
	AddCameraShot(0.912982, -0.196456, -0.349585, -0.075224, -152.503891, 46.803139, 144.810410)


end
