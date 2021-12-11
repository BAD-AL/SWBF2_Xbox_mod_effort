--Extracted\mus1g_ctf.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("objectivectf")
ATT = 1
DEF = 2
IMP = ATT
ALL = DEF

function ScriptPostLoad()
    UnblockPlanningGraphArcs("Connection74")
    DisableBarriers("1")
    PlayAnimRise()
    DisableBarriers("BALCONEY")
    DisableBarriers("bALCONEY2")
    DisableBarriers("hallway_f")
    DisableBarriers("hackdoor")
    DisableBarriers("outside")
    OnObjectRespawnName(PlayAnimRise,"DingDong")
    OnObjectKillName(PlayAnimRise,"DingDong")
    SetProperty("FLAG1","GeometryName","com_icon_alliance_flag")
    SetProperty("FLAG1","CarriedGeometryName","com_icon_alliance_flag_carried")
    SetProperty("FLAG2","GeometryName","com_icon_imperial_flag")
    SetProperty("FLAG2","CarriedGeometryName","com_icon_imperial_flag_carried")
    SetClassProperty("com_item_flag","DroppedColorize",1)
    SoundEvent_SetupTeams(IMP,"imp",ALL,"all")
    ctf = ObjectiveCTF:New({ teamATT = ATT, teamDEF = DEF, captureLimit = 5, textATT = "level.Kamino1.objectives.ctf.get", textDEF = "level.Kamino1.objectives.ctf.get1", multiplayerRules = true })
    ctf:AddFlag({ name = "FLAG1", homeRegion = "FLAG1_HOME", captureRegion = "FLAG2_HOME", capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3, icon = "", mapIcon = "flag_icon", mapIconScale = 3 })
    ctf:AddFlag({ name = "FLAG2", homeRegion = "FLAG2_HOME", captureRegion = "FLAG1_HOME", capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3, icon = "", mapIcon = "flag_icon", mapIconScale = 3 })
    ctf:Start()
    EnableSPHeroRules()
end

function PlayAnimDrop()
    PauseAnimation("lava_bridge_raise")
    RewindAnimation("lava_bridge_drop")
    PlayAnimation("lava_bridge_drop")
    BlockPlanningGraphArcs("Connection82")
    BlockPlanningGraphArcs("Connection83")
    EnableBarriers("Bridge")
end

function PlayAnimRise()
    PauseAnimation("lava_bridge_drop")
    RewindAnimation("lava_bridge_raise")
    PlayAnimation("lava_bridge_raise")
    UnblockPlanningGraphArcs("Connection82")
    UnblockPlanningGraphArcs("Connection83")
    DisableBarriers("Bridge")
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(3033089)
        SetPSPClipper(1)
else
        SetPS2ModelMemory(3400000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\mus.lvl;mus1gcw")
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman","all_inf_rocketeer","all_inf_sniper","all_inf_engineer","all_inf_wookiee","all_inf_officer")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_engineer","imp_inf_sniper","imp_inf_dark_trooper","imp_inf_officer")
    ReadDataFile("SIDE\\rep.lvl","rep_hero_obiwan","rep_hero_anakin")
    ClearWalkers()
    SetMemoryPoolSize("EntityCloth",29)
    SetMemoryPoolSize("EntitySoundStatic",175)
    SetMemoryPoolSize("FlagItem",2)
    SetMemoryPoolSize("Obstacle",272)
    SetMemoryPoolSize("Weapon",260)
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            all =             { team = ALL, units = 10, reinforcements = -1, 
              soldier =               { "all_inf_rifleman" }, 
              assault =               { "all_inf_rocketeer" }, 
              engineer =               { "all_inf_engineer" }, 
              sniper =               { "all_inf_sniper" }, 
              officer =               { "all_inf_officer" }, 
              special =               { "all_inf_wookiee" }
             }
           })
        SetupTeams({ 
            imp =             { team = IMP, units = 10, reinforcements = -1, 
              soldier =               { "imp_inf_rifleman" }, 
              assault =               { "imp_inf_rocketeer" }, 
              engineer =               { "imp_inf_engineer" }, 
              sniper =               { "imp_inf_sniper" }, 
              officer =               { "imp_inf_officer" }, 
              special =               { "imp_inf_dark_trooper" }
             }
           })
else
        SetupTeams({ 
            all =             { team = ALL, units = 25, reinforcements = -1, 
              soldier =               { "all_inf_rifleman" }, 
              assault =               { "all_inf_rocketeer" }, 
              engineer =               { "all_inf_engineer" }, 
              sniper =               { "all_inf_sniper" }, 
              officer =               { "all_inf_officer" }, 
              special =               { "all_inf_wookiee" }
             }
           })
        SetupTeams({ 
            imp =             { team = IMP, units = 25, reinforcements = -1, 
              soldier =               { "imp_inf_rifleman" }, 
              assault =               { "imp_inf_rocketeer" }, 
              engineer =               { "imp_inf_engineer" }, 
              sniper =               { "imp_inf_sniper" }, 
              officer =               { "imp_inf_officer" }, 
              special =               { "imp_inf_dark_trooper" }
             }
           })
end
    SetHeroClass(ALL,"rep_hero_obiwan")
    SetHeroClass(IMP,"rep_hero_anakin")
    SetSpawnDelay(10,0.25)
    ReadDataFile("mus\\mus1.lvl","mus1_ctf")
    SetDenseEnvironment("false")
    SetMaxFlyHeight(90)
    SetMaxPlayerFlyHeight(90)
    AISnipeSuitabilityDist(30)
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(ALL,1,"all_mus_amb_start",0,1)
    SetAmbientMusic(IMP,1,"imp_mus_amb_start",0,1)
    SetVictoryMusic(ALL,"all_mus_amb_victory")
    SetDefeatMusic(ALL,"all_mus_amb_defeat")
    SetVictoryMusic(IMP,"imp_mus_amb_victory")
    SetDefeatMusic(IMP,"imp_mus_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(ATT)
    AddCameraShot(0.88102000951767,-0.13016700744629,0.44993698596954,0.066476002335548,-25.155872344971,72.485176086426,-0.20587199926376)
    AddCameraShot(0.97234797477722,0.09859299659729,0.210632994771,-0.02135800011456,168.82385253906,30.84568977356,105.86446380615)
    AddCameraShot(-0.37392520904541,0.044628001749516,-0.91788297891617,-0.10801199823618,-1.9118020534515,71.721115112305,20.474294662476)
    AddCameraShot(0.88499200344086,-0.12753500044346,-0.44092801213264,-0.063873000442982,-96.635223388672,72.084869384766,8.2408618927002)
    AddCameraShot(0.90820997953415,-0.10889399796724,0.40123000741005,0.048106998205185,35.347961425781,72.160430908203,90.556800842285)
    AddCameraShot(0.90333098173141,-0.018977999687195,-0.42843800783157,-0.0090009998530149,-29.64541053772,72.121482849121,-0.076788000762463)
    AddCameraShot(-0.4006649851799,0.076364003121853,-896894,-0.17094099521637,96.201210021973,79.913032531738,-58.604381561279)
end

