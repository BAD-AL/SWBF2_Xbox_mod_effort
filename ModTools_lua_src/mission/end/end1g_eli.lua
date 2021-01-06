--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("setup_teams")

ALL = 1
IMP = 2
ATT = 1
DEF = 2
---------------------------------------------------------------------------
-- ScriptPostLoad
---------------------------------------------------------------------------
function ScriptPostLoad()
	TDM = ObjectiveTDM:New{teamATT = 1, teamDEF = 2, 
						multiplayerScoreLimit = 100,
						textATT = "game.modes.tdm",
						textDEF = "game.modes.tdm2", multiplayerRules = true, isCelebrityDeathmatch = true}
	TDM:Start()

    AddAIGoal(1, "Deathmatch", 100)
    AddAIGoal(2, "Deathmatch", 100)

	EnableSPHeroRules()
end

---------------------------------------------------------------------------
-- ScriptInit
---------------------------------------------------------------------------
function ScriptInit()
	StealArtistHeap(1150*1024)
	
	-- Designers, these two lines *MUST* be first.
	SetPS2ModelMemory(2460000)
	ReadDataFile("ingame.lvl")
	
	SetWorldExtents(1277.3)
	
	ReadDataFile("sound\\end.lvl;end1gcw")

	SetTeamAggressiveness(ALL, 1.0)
	SetTeamAggressiveness(IMP, 0.7)

	SetMaxFlyHeight(43)
	SetMaxPlayerFlyHeight(43)

	SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",30)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",500)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",500) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",500)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",400)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",4000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",88)     -- should be ~1x #combo
    
	ReadDataFile("SIDE\\all.lvl",
                "all_hero_luke_jedi",
                "all_hero_hansolo_tat",
                "all_hero_leia",
                "all_hero_chewbacca")
                    
    ReadDataFile("SIDE\\imp.lvl",
                "imp_hero_darthvader",
                "imp_hero_emperor",
                "imp_hero_bobafett")
                
    ReadDataFile("SIDE\\rep.lvl",
                "rep_hero_yoda",
                "rep_hero_macewindu",
                "rep_hero_anakin",
                "rep_hero_aalya",
                "rep_hero_kiyadimundi",
                "rep_hero_obiwan")
                
    ReadDataFile("SIDE\\cis.lvl",
                "cis_hero_grievous",
                "cis_hero_darthmaul",
                "cis_hero_countdooku",
                "cis_hero_jangofett")
					
	ReadDataFile("SIDE\\tur.lvl",
				"tur_bldg_laser")	

	ReadDataFile("SIDE\\ewk.lvl",
				"ewk_inf_basic")

	SetupTeams{
        hero = {
            team = ALL,
            units = 12,
                reinforcements = -1,
                soldier = { "all_hero_hansolo_tat",1,2},
                assault = { "all_hero_chewbacca",   1,2},
                engineer= { "all_hero_luke_jedi",   1,2},
                sniper  = { "rep_hero_obiwan",  1,2},
                officer = { "rep_hero_yoda",        1,2},
                special = { "rep_hero_macewindu",   1,2},           
        },
    }   

    AddUnitClass(ALL,"all_hero_leia",   1,2)
    AddUnitClass(ALL,"rep_hero_aalya",  1,2)
    AddUnitClass(ALL,"rep_hero_kiyadimundi",1,2)

    SetupTeams{
        villain = {
            team = IMP,
            units = 12,
            reinforcements = -1,
                soldier = { "imp_hero_bobafett",    1,2},
                assault = { "imp_hero_darthvader",1,2},
                engineer= { "cis_hero_darthmaul", 1,2},
                sniper  = { "cis_hero_jangofett", 1,2},
                officer = { "cis_hero_grievous",    1,2},
                special = { "imp_hero_emperor", 1,2},

        },
    }   
    AddUnitClass(IMP, "rep_hero_anakin",1,2)
    AddUnitClass(IMP, "cis_hero_countdooku",1,2)

	---[[	Ewoks
	SetTeamName(3, "locals")
	AddUnitClass(3, "ewk_inf_trooper", 3)
	AddUnitClass(3, "ewk_inf_repair", 3)
	SetUnitCount(3, 6)
	
	SetTeamAsFriend(3,ATT)
	SetTeamAsEnemy(3,DEF)
	SetTeamAsFriend(ATT, 3)
	SetTeamAsEnemy(DEF, 3)
	--]]
	
	--temp until you rescript this mission
	AddAIGoal(1,"Conquest",100);
	AddAIGoal(2,"Conquest",100);
	AddAIGoal(3,"Conquest",100);
	--temp until you rescript this mission

	--	Level Stats
	ClearWalkers()
	AddWalkerType(0, 0) -- droidekas(special case: 0 leg pairs)
	AddWalkerType(1, 3) -- ATSTs (1 leg pair)
	AddWalkerType(2, 0) -- spider walkers with 2 leg pairs each
	AddWalkerType(3, 0) -- attes with 3 leg pairs each
	
	local weaponCnt = 240
	SetMemoryPoolSize("ActiveRegion", 4)
	SetMemoryPoolSize("Aimer", 27)
	SetMemoryPoolSize("AmmoCounter", weaponCnt)
	SetMemoryPoolSize("BaseHint", 100)
	SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityFlyer", 9) -- 3xATST + rocket upgrade
	SetMemoryPoolSize("EntityHover", 9)
	SetMemoryPoolSize("EntityLight", 23)
	SetMemoryPoolSize("EntityMine", 8)
	SetMemoryPoolSize("EntitySoundStatic", 95)
	SetMemoryPoolSize("EntitySoundStream", 4)
	SetMemoryPoolSize("MountedTurret", 6)
	SetMemoryPoolSize("Navigator", 39)
	SetMemoryPoolSize("Obstacle", 745)
	SetMemoryPoolSize("PathFollower", 39)
	SetMemoryPoolSize("PathNode", 100)
	SetMemoryPoolSize("ShieldEffect", 0)
	SetMemoryPoolSize("SoundSpaceRegion", 6)
	SetMemoryPoolSize("TentacleSimulator", 14)
	SetMemoryPoolSize("TreeGridStack", 600)
	SetMemoryPoolSize("UnitAgent", 39)
	SetMemoryPoolSize("UnitController", 39)
	SetMemoryPoolSize("Weapon", weaponCnt)
	
	
	
	SetSpawnDelay(10.0, 0.25)
	ReadDataFile("end\\end1.lvl", "end1_conquest")
	SetDenseEnvironment("true")
	AddDeathRegion("deathregion")
	SetStayInTurrets(1)

	--	Sound
	voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
	AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
	AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
	
	voiceQuick = OpenAudioStream("sound\\global.lvl",	"all_unit_vo_quick")
	AudioStreamAppendSegments("sound\\global.lvl",	"imp_unit_vo_quick", voiceQuick)
	
	OpenAudioStream("sound\\global.lvl",	"gcw_music")
	-- OpenAudioStream("sound\\global.lvl",	"global_vo_quick")
	-- OpenAudioStream("sound\\global.lvl",	"global_vo_slow")
	OpenAudioStream("sound\\end.lvl",	"end1gcw")
	OpenAudioStream("sound\\end.lvl",	"end1gcw")
	OpenAudioStream("sound\\end.lvl",	"end1gcw_emt")

	SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
	SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",	1)
	SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",	1)
	SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

	SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
	SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
	SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
	SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

	SetOutOfBoundsVoiceOver(1, "allleaving")
	SetOutOfBoundsVoiceOver(2, "impleaving")

	SetAmbientMusic(ALL, 1.0, "all_end_amb_start",	0,1)
	SetAmbientMusic(ALL, 0.8, "all_end_amb_middle", 1,1)
	SetAmbientMusic(ALL, 0.2, "all_end_amb_end",	2,1)
	SetAmbientMusic(IMP, 1.0, "imp_end_amb_start",	0,1)
	SetAmbientMusic(IMP, 0.8, "imp_end_amb_middle", 1,1)
	SetAmbientMusic(IMP, 0.2, "imp_end_amb_end",	2,1)

	SetVictoryMusic(ALL, "all_end_amb_victory")
	SetDefeatMusic(ALL, "all_end_amb_defeat")
	SetVictoryMusic(IMP, "imp_end_amb_victory")
	SetDefeatMusic(IMP, "imp_end_amb_defeat")

	SetSoundEffect("ScopeDisplayZoomIn",	"binocularzoomin")
	SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
	--	SetSoundEffect("BirdScatter",		"birdsFlySeq1")
	SetSoundEffect("SpawnDisplayUnitChange",		"shell_select_unit")
	SetSoundEffect("SpawnDisplayUnitAccept",		"shell_menu_enter")
	SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
	SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
	SetSoundEffect("SpawnDisplayBack",			"shell_menu_exit")

	SetAttackingTeam(ATT)

	--Endor
	--Shield Bunker
	AddCameraShot(0.997654, 0.066982, 0.014139, -0.000949, 155.137131, 0.911505, -138.077072)
	--Village
	AddCameraShot(0.729761, 0.019262, 0.683194, -0.018033, -98.584869, 0.295284, 263.239288)
	--Village
	AddCameraShot(0.694277, 0.005100, 0.719671, -0.005287, -11.105947, -2.753207, 67.982201)
end
