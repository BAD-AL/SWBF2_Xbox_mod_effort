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

	--  Empire Attacking (attacker is always #1)
	local ALL = 2
	local IMP = 1
	--  These variables do not change
	local ATT = 1
	local DEF = 2


	AddMissionObjective(IMP, "orange", "level.rhenvar1.objectives.1")
	AddMissionObjective(IMP, "red", "level.rhenvar1.objectives.2")
	--  AddMissionObjective(IMP, "red", "level.rhenvar1.objectives.3")
	AddMissionObjective(ALL, "orange", "level.rhenvar1.objectives.1")
	--  AddMissionObjective(ALL, "red", "level.rhenvar1.objectives.2")
	AddMissionObjective(ALL, "red", "level.rhenvar1.objectives.3")

	ReadDataFile("sound\\rhn.lvl;rhn1gcw")

	ReadDataFile("SIDE\\all.lvl",
							 "all_hover_combatspeeder",
							 "all_inf_basicsnow",
							 "all_inf_lukeskywalkersnow",
							 "all_inf_smugglersnow")
	ReadDataFile("SIDE\\imp.lvl",
							 "imp_hover_fightertank",
							 "imp_inf_basicsnow",
							 "imp_inf_dark_troopersnow",
							 "imp_inf_darthvader",
							 "imp_walk_atat")

	--      Alliance Stats
	SetTeamName(ALL, "Alliance")
	SetTeamIcon(ALL, "all_icon")
	AddUnitClass(ALL, "all_inf_soldiersnow",11)
	AddUnitClass(ALL, "all_inf_vanguardsnow",3)
	AddUnitClass(ALL, "all_inf_pilot",4)
	AddUnitClass(ALL, "all_inf_marksmansnow",4)
	AddUnitClass(ALL, "all_inf_smugglersnow",3)
	SetHeroClass(ALL, "all_inf_lukeskywalkersnow")

	--      Imperial Stats
	SetTeamName(IMP, "Empire")
	SetTeamIcon(IMP, "imp_icon")
	AddUnitClass(IMP, "imp_inf_storm_troopersnow",11)
	AddUnitClass(IMP, "imp_inf_shock_troopersnow",3)
	AddUnitClass(IMP, "imp_inf_pilotatat",4)
	AddUnitClass(IMP, "imp_inf_scout_troopersnow",4)
	AddUnitClass(IMP, "imp_inf_dark_troopersnow",3)
	SetHeroClass(IMP, "imp_inf_darthvader")

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
	SetMemoryPoolSize("EntityWalker", -1)
	AddWalkerType(0, 0) -- 0 droidekas
	AddWalkerType(1, 0) -- 0 atsts with 1 leg pairs each
	AddWalkerType(2, 1) -- 2 atats with 2 leg pairs each
	SetMemoryPoolSize("CommandWalker", 1)
	--  SetMemoryPoolSize("EntityFlyer", 5)
	SetMemoryPoolSize("EntityHover", 6)
	SetMemoryPoolSize("MountedTurret", 48)
	SetMemoryPoolSize("PowerupItem", 60)
	SetMemoryPoolSize("EntityMine", 40)
	SetMemoryPoolSize("Weapon", 280)
	SetMemoryPoolSize("OrdnanceTowCable", 3)
	ReadDataFile("RHN\\RHN1.lvl")
	SetSpawnDelay(10.0, 0.25)
	SetDenseEnvironment("false")
	--  AddDeathRegion("Death")

	SetAIVehicleNotifyRadius(80)
	SetMaxFlyHeight(30)
	SetMaxPlayerFlyHeight(30)   

	--  Sound Stats
	OpenAudioStream("sound\\rhn.lvl",  "rhngcw_music")
	OpenAudioStream("sound\\gcw.lvl",  "gcw_vo")
	OpenAudioStream("sound\\gcw.lvl",  "gcw_tac_vo")

	if(ScriptCB_GetPlatform() == "PS2") then
		OpenAudioStream("sound\\rhn.lvl",  "rhn1")
		OpenAudioStream("sound\\rhn.lvl",  "rhn1")
	else
		OpenAudioStream("sound\\rhn.lvl",  "rhn")
		OpenAudioStream("sound\\rhn.lvl",  "rhn")
	end

	SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
	SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
	SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
	SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

	SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
	SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
	SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
	SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

	SetOutOfBoundsVoiceOver(2, "Allleaving")
	SetOutOfBoundsVoiceOver(1, "Impleaving")

	SetAmbientMusic(ALL, 1.0, "all_RHN_amb_start",  0,1)
	SetAmbientMusic(ALL, 0.99, "all_RHN_amb_middle", 1,1)
	SetAmbientMusic(ALL, 0.1,"all_RHN_amb_end",    2,1)
	SetAmbientMusic(IMP, 1.0, "imp_RHN_amb_start",  0,1)
	SetAmbientMusic(IMP, 0.99, "imp_RHN_amb_middle", 1,1)
	SetAmbientMusic(IMP, 0.1,"imp_RHN_amb_end",    2,1)
	SetVictoryMusic(ALL, "all_rhn_amb_victory")
	SetDefeatMusic (ALL, "all_rhn_amb_defeat")
	SetVictoryMusic(IMP, "imp_rhn_amb_victory")
	SetDefeatMusic (IMP, "imp_rhn_amb_defeat")

	SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
	SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
	--SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
	--SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
	SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
	SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
	SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
	SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
	SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

	SetPlanetaryBonusVoiceOver(IMP, IMP, 0, "imp_bonus_imp_medical")
	SetPlanetaryBonusVoiceOver(IMP, ALL, 0, "imp_bonus_all_medical")
	SetPlanetaryBonusVoiceOver(IMP, IMP, 1, "")
	SetPlanetaryBonusVoiceOver(IMP, ALL, 1, "")
	SetPlanetaryBonusVoiceOver(IMP, IMP, 2, "imp_bonus_imp_sensors")
	SetPlanetaryBonusVoiceOver(IMP, ALL, 2, "imp_bonus_all_sensors")
	SetPlanetaryBonusVoiceOver(IMP, IMP, 3, "imp_bonus_imp_hero")
	SetPlanetaryBonusVoiceOver(IMP, ALL, 3, "imp_bonus_all_hero")
	SetPlanetaryBonusVoiceOver(IMP, IMP, 4, "imp_bonus_imp_reserves")
	SetPlanetaryBonusVoiceOver(IMP, ALL, 4, "imp_bonus_all_reserves")
	SetPlanetaryBonusVoiceOver(IMP, IMP, 5, "imp_bonus_imp_sabotage")--sabotage
	SetPlanetaryBonusVoiceOver(IMP, ALL, 5, "imp_bonus_all_sabotage")
	SetPlanetaryBonusVoiceOver(IMP, IMP, 6, "")
	SetPlanetaryBonusVoiceOver(IMP, ALL, 6, "")
	SetPlanetaryBonusVoiceOver(IMP, IMP, 7, "imp_bonus_imp_training")--advanced training
	SetPlanetaryBonusVoiceOver(IMP, ALL, 7, "imp_bonus_all_training")--advanced training

	SetPlanetaryBonusVoiceOver(ALL, ALL, 0, "all_bonus_all_medical")
	SetPlanetaryBonusVoiceOver(ALL, IMP, 0, "all_bonus_imp_medical")
	SetPlanetaryBonusVoiceOver(ALL, ALL, 1, "")
	SetPlanetaryBonusVoiceOver(ALL, IMP, 1, "")
	SetPlanetaryBonusVoiceOver(ALL, ALL, 2, "all_bonus_all_sensors")
	SetPlanetaryBonusVoiceOver(ALL, IMP, 2, "all_bonus_imp_sensors")
	SetPlanetaryBonusVoiceOver(ALL, ALL, 3, "all_bonus_all_hero")
	SetPlanetaryBonusVoiceOver(ALL, IMP, 3, "all_bonus_imp_hero")
	SetPlanetaryBonusVoiceOver(ALL, ALL, 4, "all_bonus_all_reserves")
	SetPlanetaryBonusVoiceOver(ALL, IMP, 4, "all_bonus_imp_reserves")
	SetPlanetaryBonusVoiceOver(ALL, ALL, 5, "all_bonus_all_sabotage")--sabotage
	SetPlanetaryBonusVoiceOver(ALL, IMP, 5, "all_bonus_imp_sabotage")
	SetPlanetaryBonusVoiceOver(ALL, ALL, 6, "")
	SetPlanetaryBonusVoiceOver(ALL, IMP, 6, "")
	SetPlanetaryBonusVoiceOver(ALL, ALL, 7, "all_bonus_all_training")--advanced training
	SetPlanetaryBonusVoiceOver(ALL, IMP, 7, "all_bonus_imp_training")--advanced training

	SetAttackingTeam(ATT)

	--  Camera Stats
	--Rhen Var 1 Harbor
	--Ice Cave
	AddCameraShot(0.237977, 0.038345, -0.958155, 0.154386, -231.233429, 9.040294, 33.124115)
	--Building
	AddCameraShot(0.931093, 0.004173, -0.364754, 0.001635, -111.028969, 7.049152, 58.597565)
	--Overhead
	AddCameraShot(0.912982, -0.196456, -0.349585, -0.075224, -152.503891, 46.803139, 144.810410)


end
