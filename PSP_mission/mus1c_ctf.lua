--Extracted\mus1c_ctf.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("objectivectf")
ScriptCB_DoFile("setup_teams")
ATT = 1
DEF = 2
REP = ATT
CIS = DEF

function ScriptPostLoad()
    PlayAnimRise()
    UnblockPlanningGraphArcs("Connection74")
    DisableBarriers("1")
    DisableBarriers("BALCONEY")
    DisableBarriers("bALCONEY2")
    DisableBarriers("hallway_f")
    DisableBarriers("hackdoor")
    DisableBarriers("outside")
    OnObjectRespawnName(PlayAnimRise,"DingDong")
    OnObjectKillName(PlayAnimDrop,"DingDong")
    SetProperty("FLAG1","GeometryName","com_icon_republic_flag")
    SetProperty("FLAG1","CarriedGeometryName","com_icon_republic_flag_carried")
    SetProperty("FLAG2","GeometryName","com_icon_cis_flag")
    SetProperty("FLAG2","CarriedGeometryName","com_icon_cis_flag_carried")
    SetClassProperty("com_item_flag","DroppedColorize",1)
    SoundEvent_SetupTeams(REP,"rep",CIS,"cis")
    ctf = ObjectiveCTF:New({ teamATT = ATT, teamDEF = DEF, captureLimit = 5, textATT = "game.modes.ctf", textDEF = "game.modes.ctf2", multiplayerRules = true })
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
        SetPSPModelMemory(3113281)
        SetPSPClipper(1)
else
        SetPS2ModelMemory(3600000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\mus.lvl;mus1cw")
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_rifleman","rep_inf_ep3_rocketeer","rep_inf_ep3_engineer","rep_inf_ep3_jettrooper","rep_inf_ep3_sniper_felucia","rep_inf_ep3_officer","rep_hero_obiwan")
    ReadDataFile("SIDE\\cis.lvl","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_engineer","cis_inf_sniper","CIS_inf_officer","cis_hero_darthmaul","cis_inf_droideka")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            REP =             { team = REP, units = 10, reinforcements = -1, 
              soldier =               { "rep_inf_ep3_rifleman" }, 
              assault =               { "rep_inf_ep3_rocketeer" }, 
              engineer =               { "rep_inf_ep3_engineer" }, 
              sniper =               { "rep_inf_ep3_sniper_felucia" }, 
              officer =               { "rep_inf_ep3_officer" }, 
              special =               { "rep_inf_ep3_jettrooper" }
             }
           })
        SetupTeams({ 
            CIS =             { team = CIS, units = 10, reinforcements = -1, 
              soldier =               { "CIS_inf_rifleman" }, 
              assault =               { "CIS_inf_rocketeer" }, 
              engineer =               { "CIS_inf_engineer" }, 
              sniper =               { "CIS_inf_sniper" }, 
              officer =               { "CIS_inf_officer" }, 
              special =               { "cis_inf_droideka" }
             }
           })
else
        SetupTeams({ 
            REP =             { team = REP, units = 25, reinforcements = -1, 
              soldier =               { "rep_inf_ep3_rifleman" }, 
              assault =               { "rep_inf_ep3_rocketeer" }, 
              engineer =               { "rep_inf_ep3_engineer" }, 
              sniper =               { "rep_inf_ep3_sniper_felucia" }, 
              officer =               { "rep_inf_ep3_officer" }, 
              special =               { "rep_inf_ep3_jettrooper" }
             }
           })
        SetupTeams({ 
            CIS =             { team = CIS, units = 25, reinforcements = -1, 
              soldier =               { "CIS_inf_rifleman" }, 
              assault =               { "CIS_inf_rocketeer" }, 
              engineer =               { "CIS_inf_engineer" }, 
              sniper =               { "CIS_inf_sniper" }, 
              officer =               { "CIS_inf_officer" }, 
              special =               { "cis_inf_droideka" }
             }
           })
end
    SetHeroClass(REP,"rep_hero_obiwan")
    SetHeroClass(CIS,"cis_hero_darthmaul")
    ClearWalkers()
    SetMemoryPoolSize("Aimer",0)
    SetMemoryPoolSize("EntityCloth",19)
    SetMemoryPoolSize("EntitySoundStatic",175)
    SetMemoryPoolSize("MountedTurret",0)
    SetMemoryPoolSize("Obstacle",290)
    SetSpawnDelay(10,0.25)
    SetDenseEnvironment("false")
    SetMaxFlyHeight(90)
    SetMaxPlayerFlyHeight(90)
    AISnipeSuitabilityDist(30)
    SetMemoryPoolSize("FlagItem",2)
    ReadDataFile("mus\\mus1.lvl","MUS1_CTF")
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetAmbientMusic(REP,1,"rep_mus_amb_start",0,1)
    SetAmbientMusic(CIS,1,"cis_mus_amb_start",0,1)
    SetVictoryMusic(REP,"rep_mus_amb_victory")
    SetDefeatMusic(REP,"rep_mus_amb_defeat")
    SetVictoryMusic(CIS,"cis_mus_amb_victory")
    SetDefeatMusic(CIS,"cis_mus_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    AddCameraShot(0.88102000951767,-0.13016700744629,0.44993698596954,0.066476002335548,-25.155872344971,72.485176086426,-0.20587199926376)
    AddCameraShot(0.97234797477722,0.09859299659729,0.210632994771,-0.02135800011456,168.82385253906,30.84568977356,105.86446380615)
    AddCameraShot(-0.37392520904541,0.044628001749516,-0.91788297891617,-0.10801199823618,-1.9118020534515,71.721115112305,20.474294662476)
    AddCameraShot(0.88499200344086,-0.12753500044346,-0.44092801213264,-0.063873000442982,-96.635223388672,72.084869384766,8.2408618927002)
    AddCameraShot(0.90820997953415,-0.10889399796724,0.40123000741005,0.048106998205185,35.347961425781,72.160430908203,90.556800842285)
    AddCameraShot(0.90333098173141,-0.018977999687195,-0.42843800783157,-0.0090009998530149,-29.64541053772,72.121482849121,-0.076788000762463)
    AddCameraShot(-0.4006649851799,0.076364003121853,-896894,-0.17094099521637,96.201210021973,79.913032531738,-58.604381561279)
end

