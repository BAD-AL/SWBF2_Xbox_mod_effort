--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("setup_teams")


--  REP Attacking (attacker is always #1)
REP = 1
CIS = 2

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

    SetProperty("flag1", "GeometryName", "com_icon_republic_flag")
    SetProperty("flag1", "CarriedGeometryName", "com_icon_republic_flag_carried")
    SetProperty("flag2", "GeometryName", "com_icon_cis_flag")
    SetProperty("flag2", "CarriedGeometryName", "com_icon_cis_flag_carried")

                --This makes sure the flag is colorized when it has been dropped on the ground
    SetClassProperty("com_item_flag", "DroppedColorize", 1)

    --This is all the actual ctf objective setup
    ctf = ObjectiveCTF:New{teamATT = REP, teamDEF = CIS, captureLimit = 5, textATT = "game.modes.ctf", textDEF = "game.modes.ctf2", hideCPs = true, multiplayerRules = true}
    ctf:AddFlag{name = "flag1", homeRegion = "flag1_home", captureRegion = "flag2_home",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    ctf:AddFlag{name = "flag2", homeRegion = "flag2_home", captureRegion = "flag1_home",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
	
	SoundEvent_SetupTeams( REP, 'rep', CIS, 'cis' )
    
	ctf:Start()
    EnableSPHeroRules()
    
    AddDeathRegion("deathregion")
	AddDeathRegion("deathregion2")
	AddDeathRegion("deathregion3")
	AddDeathRegion("deathregion4")
	AddDeathRegion("deathregion5")
	
 end
function ScriptInit()
	StealArtistHeap(800*1024)
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(3350000)
    ReadDataFile("ingame.lvl")
    
    --  These variables do not change
    local ATT = REP
    local DEF = CIS

    SetTeamAggressiveness(CIS, 1.0)
    SetTeamAggressiveness(REP, 1.0)

	SetMemoryPoolSize("Music", 36)

    ReadDataFile("sound\\geo.lvl;geo1cw")
    ReadDataFile("SIDE\\rep.lvl",
                             --"rep_bldg_forwardcenter",
                             "rep_fly_assault_dome",
                             --"rep_fly_gunship",
                             "rep_fly_gunship_dome",
                             "rep_fly_jedifighter_dome",
                             "rep_inf_ep2_rocketeer",
                             "rep_inf_ep3_officer",
                             "rep_inf_ep2_rifleman",
                             "rep_inf_ep2_jettrooper",
                             "rep_inf_ep2_engineer",
                             "rep_hero_macewindu",
                             --"rep_walk_atte",
                             "rep_hover_fightertank",
                             "rep_inf_ep2_sniper")
                             --"rep_hover_barcspeeder")
    ReadDataFile("SIDE\\cis.lvl",
                             "cis_fly_droidfighter_dome",
                             --"cis_fly_geofighter",
                             "cis_inf_rifleman",
                             "cis_inf_rocketeer",
                             "cis_inf_sniper",
                             "cis_inf_engineer",
                             "cis_inf_officer",
                             "cis_hero_countdooku",
                             "cis_inf_droideka",
                             "cis_tread_hailfire",
                             "cis_walk_spider",
                             "cis_hover_stap")
    ReadDataFile("SIDE\\geo.lvl",
                             "gen_inf_geonosian")
	
	ReadDataFile("SIDE\\tur.lvl",
                             "tur_bldg_geoturret")                             

    --  Level Stats

    ClearWalkers()
    AddWalkerType(0, 3) -- 8 droidekas (special case: 0 leg pairs)
    AddWalkerType(2, 2) -- 2 spider walkers with 2 leg pairs each
    --AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    local weaponCnt = 200
    SetMemoryPoolSize("Aimer", 55)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 100)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityHover", 5)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntityLight", 50)
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("EntitySoundStatic", 0)
    SetMemoryPoolSize("FlagItem", 2)
    SetMemoryPoolSize("MountedTurret", 10)
	SetMemoryPoolSize("Navigator", 57)
    SetMemoryPoolSize("Obstacle", 425)
    SetMemoryPoolSize("PathFollower", 57)
    SetMemoryPoolSize("PathNode", 100)
    SetMemoryPoolSize("PassengerSlot", 0)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 300)
    SetMemoryPoolSize("UnitAgent", 57)
    SetMemoryPoolSize("UnitController", 57)
    SetMemoryPoolSize("Weapon", weaponCnt)

    SetSpawnDelay(10.0, 0.25)

    SetupTeams{
             
        rep = {
            team = REP,
            units = 28,
            reinforcements = 150,
            soldier  = { "rep_inf_ep2_rifleman",10, 25},
            assault  = { "rep_inf_ep2_rocketeer",2, 4},
            engineer = { "rep_inf_ep2_engineer",1, 4},
            sniper   = { "rep_inf_ep2_sniper",1, 4},
            officer = {"rep_inf_ep3_officer",1, 4},
            special = { "rep_inf_ep2_jettrooper",1, 4},
            
        },
        cis = {
            team = CIS,
            units = 28,
            reinforcements = 150,
            soldier  = { "cis_inf_rifleman",10, 25},
            assault  = { "cis_inf_rocketeer",2, 4},
            engineer = { "cis_inf_engineer",1, 4},
            sniper   = { "cis_inf_sniper",1, 4},
            officer = {"cis_inf_officer",1, 4},
            special = { "cis_inf_droideka",1, 4},
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

    --  Defender Stats
    
    --teamDEF = ConquestTeam:New{team = DEF}
    --teamDEF:AddBleedThreshold(21, 0.75)
    --teamDEF:AddBleedThreshold(11, 2.25)
    --teamDEF:AddBleedThreshold(1, 3.0)
    --teamDEF:Init()
    SetTeamAsFriend(DEF,3)

    --  Local Stats
    SetTeamName(3, "locals")
    AddUnitClass(3, "geo_inf_geonosian", 7)
    SetUnitCount(3, 7)
    SetTeamAsFriend(3, DEF)
    --SetTeamName(4, "locals")
    --AddUnitClass(4, "rep_inf_jedimale",1)
    --AddUnitClass(4, "rep_inf_jedimaleb",1)
    --AddUnitClass(4, "rep_inf_jedimaley",1)
    --SetUnitCount(4, 3)
    --SetTeamAsFriend(4, ATT)

    ReadDataFile("GEO\\geo1.lvl", "geo1_ctf")

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

    -- SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    -- SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(1, "repleaving")
    SetOutOfBoundsVoiceOver(2, "cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_GEO_amb_start",  0,1)
    SetAmbientMusic(REP, 0.9, "rep_GEO_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.1,"rep_GEO_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_GEO_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.9, "cis_GEO_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.1,"cis_GEO_amb_end",    2,1)

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
    --AddCameraShot(0.994219, 0.074374, 0.077228, -0.005777, 90.939568, -49.293945, -69.571136)
end

