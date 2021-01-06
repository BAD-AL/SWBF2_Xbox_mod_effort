--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("setup_teams")

---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------

function ScriptPostLoad()
	AddAIGoal(3, "Deathmatch", 100)
	AddAIGoal(1, "Deathmatch", 100)
    AddAIGoal(2, "Deathmatch", 100)
    TDM = ObjectiveTDM:New{teamATT = 1, teamDEF = 2, 
						multiplayerScoreLimit = 100,
						textATT = "game.modes.tdm",
						textDEF = "game.modes.tdm2", multiplayerRules = true,
						isUberMode = true,
						uberScoreLimit = 350,
						}
	TDM:Start()
    
    
    
    EnableSPHeroRules()
    
    AddDeathRegion("deathregion")
    AddDeathRegion("deathregion2")
    AddDeathRegion("deathregion3")
    AddDeathRegion("deathregion4")
    AddDeathRegion("deathregion5")
    
    KillObject("cp1")
    KillObject("cp2")
    KillObject("cp3")
    KillObject("cp4")
    KillObject("cp6")
    KillObject("cp7")
    KillObject("cp8")
    
 end
function ScriptInit()
    StealArtistHeap(800*1024)
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(3500000)
    SetUberMode(1);
    ReadDataFile("ingame.lvl")
    
    --  REP Attacking (attacker is always #1)
    local REP = 1
    local CIS = 2
    --  These variables do not change
    local ATT = 1
    local DEF = 2

    SetTeamAggressiveness(CIS, 1.0)
    SetTeamAggressiveness(REP, 1.0)

    SetMemoryPoolSize("Music", 40)

    ReadDataFile("sound\\geo.lvl;geo1cw")
    ReadDataFile("SIDE\\rep.lvl",
                             --"rep_bldg_forwardcenter",
                             "rep_fly_assault_dome",
                             --"rep_fly_gunship",
                             "rep_fly_gunship_dome",
                             "rep_fly_jedifighter_dome",
                             "rep_inf_ep2_rocketeer",
                             "rep_inf_ep2_rifleman",
                             "rep_inf_ep2_jettrooper",
                             "rep_inf_ep2_sniper",
                             "rep_inf_ep3_officer",
                             "rep_inf_ep2_engineer",
                             "rep_hero_macewindu",
                             "rep_walk_atte")
                             
    ReadDataFile("SIDE\\cis.lvl",
                             "cis_fly_droidfighter_dome",
                             --"cis_fly_geofighter",
                             "cis_inf_rifleman",
                             "cis_inf_rocketeer",
                             "cis_inf_sniper",
                             "cis_inf_officer",
                             "cis_inf_engineer",
                             "cis_hero_countdooku",
                             "cis_inf_droideka",
                             "cis_tread_hailfire",
                             --"cis_hover_stap",
                             "cis_walk_spider")
    ReadDataFile("SIDE\\geo.lvl",
                             "gen_inf_geonosian")
                             
	ReadDataFile("SIDE\\tur.lvl",
                             "tur_bldg_geoturret")

    --  Level Stats

    ClearWalkers()
    SetMemoryPoolSize("EntityWalker", -1)
    AddWalkerType(0, 3) -- 8 droidekas (special case: 0 leg pairs)
    AddWalkerType(2, 3) -- 2 spider walkers with 2 leg pairs each
    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    local weaponcnt = 240
    SetMemoryPoolSize("Aimer", 50)
    SetMemoryPoolSize("AmmoCounter", weaponcnt)
    SetMemoryPoolSize("BaseHint", 100)
    SetMemoryPoolSize("CommandWalker", 1)
    SetMemoryPoolSize("EnergyBar", weaponcnt)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntityHover", 9)
    SetMemoryPoolSize("EntityLight", 50)
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("MountedTurret", 10)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 450)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("PathNode", 100)
    SetMemoryPoolSize("TreeGridStack", 300)
    SetMemoryPoolSize("UnitAgent", 50)
    SetMemoryPoolSize("UnitController", 50)
    SetMemoryPoolSize("Weapon", weaponcnt)

    SetSpawnDelay(10.0, 0.25)

SetupTeams{
             
        rep = {
            team = REP,
            units = 80,
            reinforcements = 600,
            soldier  = { "rep_inf_ep2_rifleman",70, 110},
            assault  = { "rep_inf_ep2_rocketeer",10, 18},
            engineer = { "rep_inf_ep2_engineer",10, 18},
            sniper   = { "rep_inf_ep2_sniper",10, 18},
            officer = {"rep_inf_ep3_officer",10, 18},
            special = { "rep_inf_ep2_jettrooper",10, 18},
            
        },
        cis = {
            team = CIS,
            units = 80,
            reinforcements = 600,
            soldier  = { "cis_inf_rifleman",70, 110},
            assault  = { "cis_inf_rocketeer",10, 18},
            engineer = { "cis_inf_engineer",10, 18},
            sniper   = { "cis_inf_sniper",10, 18},
            officer = {"cis_inf_officer",10, 18},
            special = { "cis_inf_droideka",10, 18},
        }
     }
   
    SetHeroClass(REP, "rep_hero_macewindu")
    SetHeroClass(CIS, "cis_hero_countdooku")


    --  Attacker Stats
    
    --teamATT = ConquestTeam:New{team = ATT}
    --teamATT:AddBleedThreshold(21, 0.75)
    --teamATT:AddBleedThreshold(11, 2.25)
    --teamATT:AddBleedThreshold(1, 3.0)
    --teamATT:Init()
    SetTeamAsEnemy(ATT,3)
    SetTeamAsEnemy(3,ATT)

    --  Defender Stats
    
    --teamDEF = ConquestTeam:New{team = DEF}
    --teamDEF:AddBleedThreshold(21, 0.75)
    --teamDEF:AddBleedThreshold(11, 2.25)
    --teamDEF:AddBleedThreshold(1, 3.0)
    --teamDEF:Init()
    SetTeamAsFriend(DEF,3)

    --  Local Stats
    SetTeamName(3, "locals")
    SetUnitCount(3, 7)
    AddUnitClass(3, "geo_inf_geonosian", 7)    
    SetTeamAsFriend(3, DEF)
    --SetTeamName(4, "locals")
    --AddUnitClass(4, "rep_inf_jedimale",1)
    --AddUnitClass(4, "rep_inf_jedimaleb",1)
    --AddUnitClass(4, "rep_inf_jedimaley",1)
    --SetUnitCount(4, 3)
    --SetTeamAsFriend(4, ATT)

    ReadDataFile("GEO\\geo1.lvl", "geo1_xl")

    SetDenseEnvironment("false")
    SetMinFlyHeight(-65)
    SetMaxFlyHeight(50)
    SetMaxPlayerFlyHeight(50)



    --  Birdies
    --SetNumBirdTypes(1)
    --SetBirdType(0.0,10.0,"dragon")
    --SetBirdFlockMinHeight(90.0)

    --  Sound
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)   
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\geo.lvl",  "geo1cw")
    OpenAudioStream("sound\\geo.lvl",  "geo1cw")

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)
    
    SetLowReinforcementsVoiceOver(REP, REP, "rep_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(REP, CIS, "rep_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, CIS, "cis_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, REP, "cis_off_victory_im", .1, 1)    

    SetOutOfBoundsVoiceOver(1, "repleaving")
    SetOutOfBoundsVoiceOver(2, "cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_GEO_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_GEO_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2, "rep_GEO_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_GEO_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_GEO_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2, "cis_GEO_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_geo_amb_victory")
    SetDefeatMusic (REP, "rep_geo_amb_defeat")
    SetVictoryMusic(CIS, "cis_geo_amb_victory")
    SetDefeatMusic (CIS, "cis_geo_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


    --ActivateBonus(CIS, "SNEAK_ATTACK")
    --ActivateBonus(REP, "SNEAK_ATTACK")

    SetAttackingTeam(ATT)

    --Opening Satalite Shot
    --Geo
    --Mountain
    AddCameraShot(0.996091, 0.085528, -0.022005, 0.001889, -6.942698, -59.197201, 26.136919)
    --Wrecked Ship
    AddCameraShot(0.906778, 0.081875, -0.411906, 0.037192, 26.373968, -59.937874, 122.553581)
    --War Room  
    AddCameraShot(0.994219, 0.074374, 0.077228, -0.005777, 90.939568, -49.293945, -69.571136)
end

