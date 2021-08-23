--Extracted\geo1c_ctf.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("setup_teams")
REP = 1
CIS = 2

function ScriptPostLoad()
    SetProperty("flag1","GeometryName","com_icon_republic_flag")
    SetProperty("flag1","CarriedGeometryName","com_icon_republic_flag_carried")
    SetProperty("flag2","GeometryName","com_icon_cis_flag")
    SetProperty("flag2","CarriedGeometryName","com_icon_cis_flag_carried")
    SetClassProperty("com_item_flag","DroppedColorize",1)
    ctf = ObjectiveCTF:New({ teamATT = REP, teamDEF = CIS, captureLimit = 5, textATT = "game.modes.ctf", textDEF = "game.modes.ctf2", hideCPs = true, multiplayerRules = true })
    ctf:AddFlag({ name = "flag1", homeRegion = "flag1_home", captureRegion = "flag2_home", capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3, icon = "", mapIcon = "flag_icon", mapIconScale = 3 })
    ctf:AddFlag({ name = "flag2", homeRegion = "flag2_home", captureRegion = "flag1_home", capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3, icon = "", mapIcon = "flag_icon", mapIconScale = 3 })
    SoundEvent_SetupTeams(REP,"rep",CIS,"cis")
    ctf:Start()
    EnableSPHeroRules()
    AddDeathRegion("deathregion")
    AddDeathRegion("deathregion2")
    AddDeathRegion("deathregion3")
    AddDeathRegion("deathregion4")
    AddDeathRegion("deathregion5")
end

function ScriptInit()
    StealArtistHeap(128 * 1024)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(5.4000000953674 * 1024 * 1024)
else
        SetPS2ModelMemory(3850000)
end
    ReadDataFile("ingame.lvl")
    SetTeamAggressiveness(CIS,1)
    SetTeamAggressiveness(REP,1)
    SetMemoryPoolSize("Music",36)
    ReadDataFile("sound\\geo.lvl;geo1cw")
    ReadDataFile("SIDE\\rep.lvl","rep_fly_assault_dome","rep_fly_gunship_dome","rep_fly_jedifighter_dome","rep_inf_ep2_rocketeer","rep_inf_ep3_officer","rep_inf_ep2_rifleman","rep_inf_ep2_jettrooper","rep_inf_ep2_engineer","rep_hero_macewindu","rep_hover_fightertank","rep_inf_ep2_sniper")
    ReadDataFile("SIDE\\cis.lvl","cis_fly_droidfighter_dome","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_sniper","cis_inf_engineer","cis_inf_officer","cis_hero_countdooku","cis_inf_droideka","cis_tread_hailfire","cis_walk_spider","cis_hover_stap")
    ReadDataFile("SIDE\\geo.lvl","gen_inf_geonosian")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_geoturret")
    ClearWalkers()
    AddWalkerType(0,3)
    AddWalkerType(2,2)
    SetMemoryPoolSize("Aimer",9)
    SetMemoryPoolSize("AmmoCounter",200)
    SetMemoryPoolSize("BaseHint",60)
    SetMemoryPoolSize("EnergyBar",200)
    SetMemoryPoolSize("EntityHover",5)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("EntityLight",50)
    SetMemoryPoolSize("EntitySoundStream",4)
    SetMemoryPoolSize("EntitySoundStatic",0)
    SetMemoryPoolSize("FlagItem",2)
    SetMemoryPoolSize("MountedTurret",4)
    SetMemoryPoolSize("Navigator",57)
    SetMemoryPoolSize("Obstacle",425)
    SetMemoryPoolSize("PathFollower",57)
    SetMemoryPoolSize("PathNode",100)
    SetMemoryPoolSize("PassengerSlot",0)
    SetMemoryPoolSize("TentacleSimulator",0)
    SetMemoryPoolSize("TreeGridStack",256)
    SetMemoryPoolSize("UnitAgent",57)
    SetMemoryPoolSize("UnitController",57)
    SetMemoryPoolSize("Weapon",200)
    SetSpawnDelay(10,0.25)
    SetupTeams({ 
        rep =         { team = REP, units = 25, reinforcements = 150, 
          soldier =           { "rep_inf_ep2_rifleman", 10, 16 }, 
          assault =           { "rep_inf_ep2_rocketeer", 2, 4 }, 
          engineer =           { "rep_inf_ep2_engineer", 1, 4 }, 
          sniper =           { "rep_inf_ep2_sniper", 1, 4 }, 
          officer =           { "rep_inf_ep3_officer", 1, 4 }, 
          special =           { "rep_inf_ep2_jettrooper", 1, 4 }
         }, 
        cis =         { team = CIS, units = 25, reinforcements = 150, 
          soldier =           { "cis_inf_rifleman", 10, 16 }, 
          assault =           { "cis_inf_rocketeer", 2, 4 }, 
          engineer =           { "cis_inf_engineer", 1, 4 }, 
          sniper =           { "cis_inf_sniper", 1, 4 }, 
          officer =           { "cis_inf_officer", 1, 4 }, 
          special =           { "cis_inf_droideka", 1, 4 }
         }
       })
    SetHeroClass(REP,"rep_hero_macewindu")
    SetHeroClass(CIS,"cis_hero_countdooku")
    SetTeamAsEnemy(REP,3)
    SetTeamAsFriend(CIS,3)
    SetTeamName(3,"locals")
    AddUnitClass(3,"geo_inf_geonosian",7)
    SetUnitCount(3,7)
    SetTeamAsFriend(3,CIS)
    ReadDataFile("GEO\\geo1.lvl","geo1_ctf")
    SetDenseEnvironment("false")
    SetMinFlyHeight(-65)
    SetMaxFlyHeight(50)
    SetMaxPlayerFlyHeight(50)
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetOutOfBoundsVoiceOver(1,"repleaving")
    SetOutOfBoundsVoiceOver(2,"cisleaving")
    SetAmbientMusic(REP,1,"rep_GEO_amb_start",0,1)
    SetAmbientMusic(REP,0.89999997615814,"rep_GEO_amb_middle",1,1)
    SetAmbientMusic(REP,0.10000000149012,"rep_GEO_amb_end",2,1)
    SetAmbientMusic(CIS,1,"cis_GEO_amb_start",0,1)
    SetAmbientMusic(CIS,0.89999997615814,"cis_GEO_amb_middle",1,1)
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
    SetAttackingTeam(REP)
    AddCameraShot(0.99609100818634,0.085528001189232,-0.022004999220371,0.0018889999482781,-6.9426980018616,-59.197200775146,26.136919021606)
    AddCameraShot(0.90677797794342,0.081874996423721,-0.41190600395203,0.03719199821353,26.37396812439,-59.937873840332,122.55358123779)
    AddCameraShot(0.99421900510788,0.074373997747898,0.077228002250195,-0.0057769999839365,90.939567565918,-49.2939453125,-69.571136474609)
end

