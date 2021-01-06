--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("setup_teams")

--  REP Attacking (attacker is always #1)
    REP = 1
    CIS = 2
    --  These variables do not change
    ATT = 1
    DEF = 2



function ScriptPostLoad()
   --force all the human players onto the attacking side
	
    
    hunt = ObjectiveTDM:New{teamATT = 1, teamDEF = 2,
            pointsPerKillATT = 1, pointsPerKillDEF = 2,
            textATT = "level.geo1.objectives.hunt_att", textDEF = "level.geo1.objectives.hunt_def", multiplayerRules = true}            

hunt:Start()


    
    hunt.OnStart = function(self)
    	AddAIGoal(ATT, "Deathmatch", 1000)
    	AddAIGoal(DEF, "Deathmatch", 1000)
    end
    
    AddDeathRegion("deathregion")
	AddDeathRegion("deathregion2")
	AddDeathRegion("deathregion3")
	AddDeathRegion("deathregion4")
	AddDeathRegion("deathregion5")
	
 end
 
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
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(4100000)
    ReadDataFile("ingame.lvl")
    
    SetMemoryPoolSize("Music", 36)

    SetTeamAggressiveness(CIS, 1.0)
    SetTeamAggressiveness(REP, 1.0)

   ReadDataFile("sound\\geo.lvl;geo1cw")
    ReadDataFile("SIDE\\rep.lvl",
                             --"rep_bldg_forwardcenter",
                             "rep_fly_assault_dome",
                             --"rep_fly_gunship",
                             "rep_fly_gunship_dome",
                             "rep_fly_jedifighter_dome",
                             "rep_inf_ep2_sniper",
                             "rep_walk_atte")
                             
    
    ReadDataFile("SIDE\\geo.lvl",
                             "gen_inf_geonosian")

	ReadDataFile("SIDE\\tur.lvl",
                             "tur_bldg_geoturret")                             

    --  Level Stats

    ClearWalkers()
    SetMemoryPoolSize("EntityWalker", -1)
    AddWalkerType(0, 3) -- 8 droidekas (special case: 0 leg pairs)
    AddWalkerType(2, 2) -- 2 spider walkers with 2 leg pairs each
    AddWalkerType(3, 2) -- 2 attes with 3 leg pairs each
    SetMemoryPoolSize("Aimer", 70)
    SetMemoryPoolSize("BaseHint", 200)
    SetMemoryPoolSize("CommandWalker", 1)
    SetMemoryPoolSize("EntityFlyer", 4)
    SetMemoryPoolSize("EntityHover", 12)
    SetMemoryPoolSize("EntityLight", 50)
    SetMemoryPoolSize("MountedTurret", 12)
    SetMemoryPoolSize("Obstacle", 338)
    SetMemoryPoolSize("PathNode", 100)

    SetSpawnDelay(10.0, 0.25)

    SetupTeams{
             
        rep = {
            team = REP,
            units = 32,
            reinforcements = -1,
            
            sniper   = { "rep_inf_ep2_sniper",8},
            
            
        },
        cis = {
            team = CIS,
            units = 32,
            reinforcements = -1,
            soldier  = { "geo_inf_geonosian",25},
            
        }
     }
   
	SetTeamName(2, "Geonosians")

    --  Attacker Stats
    --SetUnitCount(ATT, 32)
    --SetReinforcementCount(ATT, 250)
    --teamATT = ConquestTeam:New{team = ATT}
    --teamATT:AddBleedThreshold(21, 0.75)
    --teamATT:AddBleedThreshold(11, 2.25)
    --teamATT:AddBleedThreshold(1, 3.0)
    --teamATT:Init()
    SetTeamAsEnemy(ATT,3)

    --  Defender Stats
    --SetUnitCount(DEF, 25)
    --SetReinforcementCount(DEF, 250)
    --teamDEF = ConquestTeam:New{team = DEF}
    --teamDEF:AddBleedThreshold(21, 0.75)
    --teamDEF:AddBleedThreshold(11, 2.25)
    --teamDEF:AddBleedThreshold(1, 3.0)
    --teamDEF:Init()
    SetTeamAsFriend(DEF,3)

    --  Local Stats
    
    --SetTeamName(4, "locals")
    --AddUnitClass(4, "rep_inf_jedimale",1)
    --AddUnitClass(4, "rep_inf_jedimaleb",1)
    --AddUnitClass(4, "rep_inf_jedimaley",1)
    --SetUnitCount(4, 3)
    --SetTeamAsFriend(4, ATT)

    ReadDataFile("GEO\\geo1.lvl", "geo1_hunt")

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
    
    -- SetLowReinforcementsVoiceOver(REP, REP, "rep_off_defeat_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(REP, CIS, "rep_off_victory_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(CIS, CIS, "cis_off_defeat_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(CIS, REP, "cis_off_victory_im", .1, 1)    

    SetOutOfBoundsVoiceOver(1, "repleaving")
    SetOutOfBoundsVoiceOver(2, "cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_geo_amb_hunt",  0,1)
    -- SetAmbientMusic(REP, 0.99, "rep_GEO_amb_middle", 1,1)
    -- SetAmbientMusic(REP, 0.1,"rep_GEO_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_geo_amb_hunt",  0,1)
    -- SetAmbientMusic(CIS, 0.99, "cis_GEO_amb_middle", 1,1)
    -- SetAmbientMusic(CIS, 0.1,"cis_GEO_amb_end",    2,1)

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

