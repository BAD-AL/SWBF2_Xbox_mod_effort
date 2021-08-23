--Extracted\geo1c_hunt.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("setup_teams")
REP = 1
CIS = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    hunt = ObjectiveTDM:New({ teamATT = 1, teamDEF = 2, pointsPerKillATT = 1, pointsPerKillDEF = 2, textATT = "level.geo1.objectives.hunt_att", textDEF = "level.geo1.objectives.hunt_def", multiplayerRules = true })
    hunt:Start()
    AddDeathRegion("deathregion")
    AddDeathRegion("deathregion2")
    AddDeathRegion("deathregion3")
    AddDeathRegion("deathregion4")
    AddDeathRegion("deathregion5")
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(5.4000000953674 * 1024 * 1024)
else
        SetPS2ModelMemory(4100000)
end
    ReadDataFile("ingame.lvl")
    SetTeamAggressiveness(CIS,1)
    SetTeamAggressiveness(REP,1)
    ReadDataFile("sound\\geo.lvl;geo1cw")
    ReadDataFile("SIDE\\rep.lvl","rep_fly_assault_dome","rep_fly_gunship_dome","rep_fly_jedifighter_dome","rep_inf_ep2_sniper","rep_walk_atte")
    ReadDataFile("SIDE\\geo.lvl","gen_inf_geonosian")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_geoturret")
    ClearWalkers()
    SetMemoryPoolSize("EntityWalker",-1)
    AddWalkerType(0,3)
    AddWalkerType(2,2)
    AddWalkerType(3,2)
    SetMemoryPoolSize("Aimer",70)
    SetMemoryPoolSize("BaseHint",200)
    SetMemoryPoolSize("CommandWalker",1)
    SetMemoryPoolSize("EntityFlyer",4)
    SetMemoryPoolSize("EntityHover",12)
    SetMemoryPoolSize("EntityLight",50)
    SetMemoryPoolSize("MountedTurret",12)
    SetMemoryPoolSize("Music",36)
    SetMemoryPoolSize("Obstacle",338)
    SetMemoryPoolSize("PathNode",100)
    SetSpawnDelay(10,0.25)
    SetupTeams({ 
        rep =         { team = REP, units = 8, reinforcements = -1, 
          sniper =           { "rep_inf_ep2_sniper", 8 }
         }, 
        cis =         { team = CIS, units = 25, reinforcements = -1, 
          soldier =           { "geo_inf_geonosian", 25 }
         }
       })
    SetTeamName(2,"Geonosians")
    SetTeamAsEnemy(ATT,3)
    SetTeamAsFriend(DEF,3)
    ReadDataFile("GEO\\geo1.lvl","geo1_hunt")
    SetDenseEnvironment("false")
    SetMinFlyHeight(-65)
    SetMaxFlyHeight(50)
    SetMaxPlayerFlyHeight(50)
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetBleedingVoiceOver(REP,REP,"rep_off_com_report_us_overwhelmed",1)
    SetBleedingVoiceOver(REP,CIS,"rep_off_com_report_enemy_losing",1)
    SetBleedingVoiceOver(CIS,REP,"cis_off_com_report_enemy_losing",1)
    SetBleedingVoiceOver(CIS,CIS,"cis_off_com_report_us_overwhelmed",1)
    SetLowReinforcementsVoiceOver(REP,REP,"rep_off_defeat_im",0.10000000149012,1)
    SetLowReinforcementsVoiceOver(REP,CIS,"rep_off_victory_im",0.10000000149012,1)
    SetLowReinforcementsVoiceOver(CIS,CIS,"cis_off_defeat_im",0.10000000149012,1)
    SetLowReinforcementsVoiceOver(CIS,REP,"cis_off_victory_im",0.10000000149012,1)
    SetOutOfBoundsVoiceOver(1,"repleaving")
    SetOutOfBoundsVoiceOver(2,"cisleaving")
    SetAmbientMusic(REP,1,"rep_GEO_amb_start",0,1)
    SetAmbientMusic(REP,0.99000000953674,"rep_GEO_amb_middle",1,1)
    SetAmbientMusic(REP,0.10000000149012,"rep_GEO_amb_end",2,1)
    SetAmbientMusic(CIS,1,"cis_GEO_amb_start",0,1)
    SetAmbientMusic(CIS,0.99000000953674,"cis_GEO_amb_middle",1,1)
    SetAmbientMusic(CIS,0.10000000149012,"cis_GEO_amb_end",2,1)
    SetVictoryMusic(REP,"rep_geo_amb_victory")
    SetDefeatMusic(REP,"rep_geo_amb_defeat")
    SetVictoryMusic(CIS,"cis_geo_amb_victory")
    SetDefeatMusic(CIS,"cis_geo_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(ATT)
    AddCameraShot(0.99609100818634,0.085528001189232,-0.022004999220371,0.0018889999482781,-6.9426980018616,-59.197200775146,26.136919021606)
    AddCameraShot(0.90677797794342,0.081874996423721,-0.41190600395203,0.03719199821353,26.37396812439,-59.937873840332,122.55358123779)
    AddCameraShot(0.99421900510788,0.074373997747898,0.077228002250195,-0.0057769999839365,90.939567565918,-49.2939453125,-69.571136474609)
end

function OnStart(OnStartParam0)
    AddAIGoal(ATT,"Deathmatch",1000)
    AddAIGoal(DEF,"Deathmatch",1000)
end

