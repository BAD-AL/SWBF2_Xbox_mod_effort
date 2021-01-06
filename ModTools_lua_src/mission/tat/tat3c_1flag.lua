--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams")
---------------------------------------------------------------------------
-- FUNCTION:	ScriptInit
-- PURPOSE:	This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:		The name, 'ScriptInit' is a chosen convention, and each
--			mission script must contain a version of this function, as
--			it is called from C to start the mission.
---------------------------------------------------------------------------
function ScriptPostLoad()
	--This is the actual objective setup
	ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
							textATT = "game.modes.1flag", textDEF = "game.modes.1flag2",
							captureLimit = 5, flag = "1flag_flag", flagIcon = "flag_icon", 
							flagIconScale = 3.0, homeRegion = "1flag_capture2",
							captureRegionATT = "1flag_capture1", captureRegionDEF = "1flag_capture2",
							capRegionWorldATT = "1flag_effect2", capRegionWorldDEF = "1flag_effect1",
							capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
							capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0, multiplayerRules = true, hideCPs = true}
	SoundEvent_SetupTeams( 1, 'rep', 2, 'cis' )
	ctf:Start()
--	KillObject("carbonite")
	EnableSPHeroRules()
end

function ScriptInit()
    StealArtistHeap(720*1024)   -- steal from art heap
    
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(4086000)
    ReadDataFile("ingame.lvl")

	--	Empire Attacking (attacker is always #1)
	local REP = 1
	local CIS = 2
	--	These variables do not change
	local ATT = 1
	local DEF = 2

	SetTeamAggressiveness(CIS, 0.95)
	SetTeamAggressiveness(REP, 0.95)

    local weaponCnt = 200
    SetMemoryPoolSize("Aimer", 15)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 110)
    SetMemoryPoolSize("Combo::Condition", 100)
    SetMemoryPoolSize("Combo::State", 160)
    SetMemoryPoolSize("Combo::Transition", 100) -- should be a bit bigger than #Combo::State
	SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityFlyer", 6) -- to account for rocket upgrade
	SetMemoryPoolSize("EntityLight", 132)
	SetMemoryPoolSize("EntitySoundStatic", 3)
	SetMemoryPoolSize("EntitySoundStream", 2)
	SetMemoryPoolSize("FlagItem", 1)
	SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 40)
	SetMemoryPoolSize("MountedTurret", 0)
	SetMemoryPoolSize("Navigator", 35)
	SetMemoryPoolSize("Obstacle", 202)
	SetMemoryPoolSize("PathNode", 128)
	SetMemoryPoolSize("PathFollower", 35)
	SetMemoryPoolSize("RedOmniLight", 140)
	SetMemoryPoolSize("SoundSpaceRegion", 80)
	SetMemoryPoolSize("TreeGridStack", 100)
	SetMemoryPoolSize("UnitAgent", 35)
	SetMemoryPoolSize("UnitController", 35)
	SetMemoryPoolSize("Weapon", weaponCnt)

	--ReadDataFile("dc:sound\\tat.lvl")
	ReadDataFile("sound\\tat.lvl;tat3cw")
	ReadDataFile("SIDE\\rep.lvl",
		"rep_inf_ep3_rifleman",
		"rep_inf_ep3_rocketeer",
		"rep_inf_ep3_engineer",
		"rep_inf_ep3_sniper",
		"rep_inf_ep3_officer",
		"rep_inf_ep3_jettrooper",
		"rep_hero_aalya")


	ReadDataFile("SIDE\\cis.lvl",
		"cis_inf_rifleman",
		"cis_inf_rocketeer",
		"cis_inf_engineer",
		"cis_inf_sniper",
		"cis_inf_officer",
		"cis_inf_droideka",
		"cis_hero_darthmaul")


	---[[ Gamorrean Guards
	ReadDataFile("SIDE\\gam.lvl",
		"gam_inf_gamorreanguard")
	SetTeamName(3, "locals")
	AddUnitClass(3, "gam_inf_gamorreanguard",3)
	SetUnitCount(3, 3)
	SetTeamAsEnemy(3, ATT)
	SetTeamAsEnemy(3, DEF) 
	SetTeamAsEnemy(ATT, 3)
	SetTeamAsEnemy(DEF, 3)
	AddAIGoal(3,"Deathmatch",100)
	--]]
	
	SetupTeams{

		rep = {
			team = REP,
			units = 30,
			reinforcements = -1,
			soldier	= { "rep_inf_ep3_rifleman",7, 25},
			assault	= { "rep_inf_ep3_rocketeer",1,4},
			engineer = { "rep_inf_ep3_engineer",1,4},
			sniper	= { "rep_inf_ep3_sniper",1,4},
			officer	= { "rep_inf_ep3_officer",1,4},
			special	= { "rep_inf_ep3_jettrooper",1,4},
			
		},
		cis = {
			team = CIS,
			units = 30,
			reinforcements = -1,
			soldier	= { "cis_inf_rifleman",7, 25},
			assault	= { "cis_inf_rocketeer",1,4},
			engineer = { "cis_inf_engineer",1,4},
			sniper	= { "cis_inf_sniper",1,4},
			officer	= { "cis_inf_officer",1,4},
			special	= { "cis_inf_droideka",1,4},
		}
	}

	SetHeroClass(REP, "rep_hero_aalya")
	SetHeroClass(CIS, "cis_hero_darthmaul")

	SetSpawnDelay(10.0, 0.25)

--[[
	teamATT = ConquestTeam:New{team = ATT}
	teamATT:AddBleedThreshold(11, 0.75)
	teamATT:AddBleedThreshold(10, 1.5)
	teamATT:AddBleedThreshold(1, 3.0)
	teamATT:Init()
	
	teamDEF = ConquestTeam:New{team = DEF}
	teamDEF:AddBleedThreshold(11, 0.75)
	teamDEF:AddBleedThreshold(10, 1.5)
	teamDEF:AddBleedThreshold(1, 3.0)
	teamDEF:Init()
--]]

	--	Level Stats
	ClearWalkers()
	AddWalkerType(0, 3) -- Droidekas
	AddWalkerType(1, 0)
	AddWalkerType(2, 0)

	SetSpawnDelay(10.0, 0.25)
	ReadDataFile("TAT\\tat3.lvl", "tat3_1flag")
	SetDenseEnvironment("true")
	--AddDeathRegion("Sarlac01")
	SetMaxFlyHeight(90)
	SetMaxPlayerFlyHeight(90)
    AISnipeSuitabilityDist(30)


	--	Sound Stats
	
	voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
	AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
	AudioStreamAppendSegments("sound\\global.lvl", "gam_unit_vo_slow", voiceSlow)
	AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
	
	voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
	AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)	
	
	OpenAudioStream("sound\\global.lvl",	"cw_music")
	OpenAudioStream("sound\\tat.lvl",	"tat3")
	OpenAudioStream("sound\\tat.lvl",	"tat3")
	-- OpenAudioStream("sound\\global.lvl",	"global_vo_quick")
	-- OpenAudioStream("sound\\global.lvl",	"global_vo_slow")
	OpenAudioStream("sound\\tat.lvl",	"tat3_emt")


	SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
	SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",	1)
	SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",	1)
	SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

	SetLowReinforcementsVoiceOver(REP, REP, "rep_off_defeat_im", .1, 1)
	SetLowReinforcementsVoiceOver(REP, CIS, "rep_off_victory_im", .1, 1)
	SetLowReinforcementsVoiceOver(CIS, CIS, "cis_off_defeat_im", .1, 1)
	SetLowReinforcementsVoiceOver(CIS, REP, "cis_off_victory_im", .1, 1)

	SetOutOfBoundsVoiceOver(1, "repleaving")
	SetOutOfBoundsVoiceOver(2, "cisleaving")

	SetAmbientMusic(REP, 1.0, "rep_tat_amb_start",	0,1)
	SetAmbientMusic(REP, 0.9, "rep_tat_amb_middle", 1,1)
	SetAmbientMusic(REP, 0.1, "rep_tat_amb_end",	2,1)
	SetAmbientMusic(CIS, 1.0, "cis_tat_amb_start",	0,1)
	SetAmbientMusic(CIS, 0.9, "cis_tat_amb_middle", 1,1)
	SetAmbientMusic(CIS, 0.1, "cis_tat_amb_end",	2,1)

	SetVictoryMusic(REP, "rep_tat_amb_victory")
	SetDefeatMusic (REP, "rep_tat_amb_defeat")
	SetVictoryMusic(CIS, "cis_tat_amb_victory")
	SetDefeatMusic (CIS, "cis_tat_amb_defeat")



	SetSoundEffect("ScopeDisplayZoomIn",	"binocularzoomin")
	SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
	--SetSoundEffect("WeaponUnableSelect",	"com_weap_inf_weaponchange_null")
	--SetSoundEffect("WeaponModeUnableSelect",	"com_weap_inf_modechange_null")
	SetSoundEffect("SpawnDisplayUnitChange",		"shell_select_unit")
	SetSoundEffect("SpawnDisplayUnitAccept",		"shell_menu_enter")
	SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
	SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
	SetSoundEffect("SpawnDisplayBack",			"shell_menu_exit")


	--	Camera Stats
	--Tat 3 - Jabbas' Palace
	AddCameraShot(0.685601, -0.253606, -0.639994, -0.236735, -65.939224, -0.176558, 127.400444)
	AddCameraShot(0.786944, 0.050288, -0.613719, 0.039218, -80.626396, 1.175180, 133.205551)
	AddCameraShot(0.997982, 0.061865, -0.014249, 0.000883, -65.227898, 1.322798, 123.976990)
	AddCameraShot(-0.367869, -0.027819, -0.926815, 0.070087, -19.548307, -5.736280, 163.360519)
	AddCameraShot(0.773980, -0.100127, -0.620077, -0.080217, -61.123989, -0.629283, 176.066025)
	AddCameraShot(0.978189, 0.012077, 0.207350, -0.002560, -88.388947, 5.674968, 153.745255)
	AddCameraShot(-0.144606, -0.010301, -0.986935, 0.070304, -106.872772, 2.066469, 102.783096)
	AddCameraShot(0.926756, -0.228578, -0.289446, -0.071390, -60.819584, -2.117482, 96.400620)
	AddCameraShot(0.873080, 0.134285, 0.463274, -0.071254, -52.071609, -8.430746, 67.122437)
	AddCameraShot(0.773398, -0.022789, -0.633236, -0.018659, -32.738083, -7.379394, 81.508003)
	AddCameraShot(0.090190, 0.005601, -0.993994, 0.061733, -15.379695, -9.939115, 72.110054)
	AddCameraShot(0.971737, -0.118739, -0.202524, -0.024747, -16.591295, -1.371236, 147.933029)
	AddCameraShot(0.894918, 0.098682, -0.432560, 0.047698, -20.577391, -10.683214, 128.752563)

end

