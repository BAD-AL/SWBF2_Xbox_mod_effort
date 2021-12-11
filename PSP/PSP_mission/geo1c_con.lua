--Extracted\geo1c_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams")

function ScriptPostLoad()
    AddAIGoal(3,"Deathmatch",100)
    cp1 = CommandPost:New({ name = "cp1" })
    cp2 = CommandPost:New({ name = "cp2" })
    cp3 = CommandPost:New({ name = "cp3" })
    cp4 = CommandPost:New({ name = "cp4" })
    cp6 = CommandPost:New({ name = "cp6" })
    cp7 = CommandPost:New({ name = "cp7" })
    cp8 = CommandPost:New({ name = "cp8" })
    conquest = ObjectiveConquest:New({ teamATT = ATT, teamDEF = DEF, text = "level.geo1.objectives.conquest", multiplayerRules = true })
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp6)
    conquest:AddCommandPost(cp7)
    conquest:AddCommandPost(cp8)
    conquest:Start()
    EnableSPHeroRules()
    AddDeathRegion("deathregion")
    AddDeathRegion("deathregion2")
    AddDeathRegion("deathregion3")
    AddDeathRegion("deathregion4")
    AddDeathRegion("deathregion5")
end

function ScriptInit()
    StealArtistHeap(256 * 1024)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(5.4000000953674 * 1024 * 1024)
else
        SetPS2ModelMemory(4100000)
end
    ReadDataFile("ingame.lvl")
    SetTeamAggressiveness(2,1)
    SetTeamAggressiveness(1,1)
    ReadDataFile("sound\\geo.lvl;geo1cw")
    ReadDataFile("SIDE\\rep.lvl","rep_fly_assault_dome","rep_fly_gunship_dome","rep_fly_jedifighter_dome","rep_inf_ep2_rocketeer","rep_inf_ep2_rifleman","rep_inf_ep2_jettrooper","rep_inf_ep2_sniper","rep_inf_ep3_officer","rep_inf_ep2_engineer","rep_hero_macewindu","rep_walk_atte")
    ReadDataFile("SIDE\\cis.lvl","cis_fly_droidfighter_dome","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_sniper","cis_inf_officer","cis_inf_engineer","cis_hero_countdooku","cis_inf_droideka","cis_tread_hailfire","cis_walk_spider")
    ReadDataFile("SIDE\\geo.lvl","gen_inf_geonosian")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_geoturret")
    ClearWalkers()
    SetMemoryPoolSize("EntityWalker",-1)
    AddWalkerType(0,3)
    AddWalkerType(2,3)
    AddWalkerType(3,0)
    SetMemoryPoolSize("Aimer",42)
    SetMemoryPoolSize("AmmoCounter",139)
    SetMemoryPoolSize("BaseHint",50)
    SetMemoryPoolSize("CommandWalker",1)
    SetMemoryPoolSize("EnergyBar",139)
    SetMemoryPoolSize("EntityHover",9)
    SetMemoryPoolSize("EntityLight",50)
    SetMemoryPoolSize("EntitySoundStream",4)
    SetMemoryPoolSize("MountedTurret",2)
    SetMemoryPoolSize("Music",40)
    SetMemoryPoolSize("Obstacle",340)
    SetMemoryPoolSize("PathFollower",32)
    SetMemoryPoolSize("PathNode",100)
    SetMemoryPoolSize("TreeGridStack",256)
    SetMemoryPoolSize("UnitAgent",32)
    SetMemoryPoolSize("UnitController",32)
    SetMemoryPoolSize("Weapon",139)
    SetMemoryPoolSize("EntityFlyer",6)
    SetSpawnDelay(10,0.25)
    SetupTeams({ 
        rep =         { team = 1, units = 25, reinforcements = 150, 
          soldier =           { "rep_inf_ep2_rifleman", 10, 16 }, 
          assault =           { "rep_inf_ep2_rocketeer", 1, 4 }, 
          engineer =           { "rep_inf_ep2_engineer", 1, 4 }, 
          sniper =           { "rep_inf_ep2_sniper", 1, 4 }, 
          officer =           { "rep_inf_ep3_officer", 1, 4 }, 
          special =           { "rep_inf_ep2_jettrooper", 1, 4 }
         }, 
        cis =         { team = 2, units = 25, reinforcements = 150, 
          soldier =           { "cis_inf_rifleman", 10, 16 }, 
          assault =           { "cis_inf_rocketeer", 1, 4 }, 
          engineer =           { "cis_inf_engineer", 1, 4 }, 
          sniper =           { "cis_inf_sniper", 1, 4 }, 
          officer =           { "cis_inf_officer", 1, 4 }, 
          special =           { "cis_inf_droideka", 1, 4 }
         }
       })
    SetHeroClass(1,"rep_hero_macewindu")
    SetHeroClass(2,"cis_hero_countdooku")
    SetTeamAsEnemy(1,3)
    SetTeamAsEnemy(3,1)
    SetTeamAsFriend(2,3)
    SetTeamName(3,"locals")
    SetUnitCount(3,7)
    AddUnitClass(3,"geo_inf_geonosian",7)
    SetTeamAsFriend(3,2)
    ReadDataFile("GEO\\geo1.lvl","geo1_conquest")
    SetDenseEnvironment("false")
    SetMinFlyHeight(-65)
    SetMaxFlyHeight(50)
    SetMaxPlayerFlyHeight(50)
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetBleedingVoiceOver(1,1,"rep_off_com_report_us_overwhelmed",1)
    SetBleedingVoiceOver(1,2,"rep_off_com_report_enemy_losing",1)
    SetBleedingVoiceOver(2,1,"cis_off_com_report_enemy_losing",1)
    SetBleedingVoiceOver(2,2,"cis_off_com_report_us_overwhelmed",1)
    SetLowReinforcementsVoiceOver(1,1,"rep_off_defeat_im",0.10000000149012,1)
    SetLowReinforcementsVoiceOver(1,2,"rep_off_victory_im",0.10000000149012,1)
    SetLowReinforcementsVoiceOver(2,2,"cis_off_defeat_im",0.10000000149012,1)
    SetLowReinforcementsVoiceOver(2,1,"cis_off_victory_im",0.10000000149012,1)
    SetOutOfBoundsVoiceOver(1,"repleaving")
    SetOutOfBoundsVoiceOver(2,"cisleaving")
    SetAmbientMusic(1,1,"rep_GEO_amb_start",0,1)
    SetAmbientMusic(1,0.99000000953674,"rep_GEO_amb_middle",1,1)
    SetAmbientMusic(1,0.10000000149012,"rep_GEO_amb_end",2,1)
    SetAmbientMusic(2,1,"cis_GEO_amb_start",0,1)
    SetAmbientMusic(2,0.99000000953674,"cis_GEO_amb_middle",1,1)
    SetAmbientMusic(2,0.10000000149012,"cis_GEO_amb_end",2,1)
    SetVictoryMusic(1,"rep_geo_amb_victory")
    SetDefeatMusic(1,"rep_geo_amb_defeat")
    SetVictoryMusic(2,"cis_geo_amb_victory")
    SetDefeatMusic(2,"cis_geo_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(1)
    AddCameraShot(0.99609100818634,0.085528001189232,-0.022004999220371,0.0018889999482781,-6.9426980018616,-59.197200775146,26.136919021606)
    AddCameraShot(0.90677797794342,0.081874996423721,-0.41190600395203,0.03719199821353,26.37396812439,-59.937873840332,122.55358123779)
    AddCameraShot(0.99421900510788,0.074373997747898,0.077228002250195,-0.0057769999839365,90.939567565918,-49.2939453125,-69.571136474609)
end

