--Extracted\mus1c_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

function ScriptPostLoad()
    UnblockPlanningGraphArcs("Connection74")
    DisableBarriers("1")
    cp1 = CommandPost:New({ name = "cp1" })
    cp2 = CommandPost:New({ name = "cp2" })
    cp4 = CommandPost:New({ name = "cp4" })
    cp5 = CommandPost:New({ name = "cp5" })
    cp6 = CommandPost:New({ name = "cp6" })
    conquest = ObjectiveConquest:New({ teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true })
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:Start()
    PlayAnimRise()
    DisableBarriers("BALCONEY")
    DisableBarriers("bALCONEY2")
    DisableBarriers("hallway_f")
    DisableBarriers("hackdoor")
    DisableBarriers("outside")
    OnObjectRespawnName(PlayAnimRise,"DingDong")
    OnObjectKillName(PlayAnimDrop,"DingDong")
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
        SetPSPModelMemory(3158977)
        SetPSPClipper(1)
else
        SetPS2ModelMemory(3600000)
end
    ReadDataFile("ingame.lvl")
    SetTeamAggressiveness(1,0.94999998807907)
    SetTeamAggressiveness(2,0.94999998807907)
    AISnipeSuitabilityDist(30)
    ReadDataFile("sound\\mus.lvl;mus1cw")
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_rifleman","rep_inf_ep3_rocketeer","rep_inf_ep3_engineer","rep_inf_ep3_jettrooper","rep_inf_ep3_sniper","rep_inf_ep3_officer","rep_hero_obiwan")
    ReadDataFile("SIDE\\cis.lvl","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_engineer","cis_inf_sniper","cis_hero_darthmaul","CIS_inf_officer","cis_inf_droideka")
    SetAttackingTeam(1)
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            REP =             { team = 1, units = 10, reinforcements = 75, 
              soldier =               { "rep_inf_ep3_rifleman" }, 
              assault =               { "rep_inf_ep3_rocketeer" }, 
              engineer =               { "rep_inf_ep3_engineer" }, 
              sniper =               { "rep_inf_ep3_sniper" }, 
              officer =               { "rep_inf_ep3_officer" }, 
              special =               { "rep_inf_ep3_jettrooper" }
             }
           })
        SetupTeams({ 
            CIS =             { team = 2, units = 10, reinforcements = 75, 
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
            REP =             { team = 1, units = 25, reinforcements = 250, 
              soldier =               { "rep_inf_ep3_rifleman" }, 
              assault =               { "rep_inf_ep3_rocketeer" }, 
              engineer =               { "rep_inf_ep3_engineer" }, 
              sniper =               { "rep_inf_ep3_sniper" }, 
              officer =               { "rep_inf_ep3_officer" }, 
              special =               { "rep_inf_ep3_jettrooper" }
             }
           })
        SetupTeams({ 
            CIS =             { team = 2, units = 25, reinforcements = 250, 
              soldier =               { "CIS_inf_rifleman" }, 
              assault =               { "CIS_inf_rocketeer" }, 
              engineer =               { "CIS_inf_engineer" }, 
              sniper =               { "CIS_inf_sniper" }, 
              officer =               { "CIS_inf_officer" }, 
              special =               { "cis_inf_droideka" }
             }
           })
end
    SetHeroClass(1,"rep_hero_obiwan")
    SetHeroClass(2,"cis_hero_darthmaul")
    ClearWalkers()
    AddWalkerType(0,4)
    SetMemoryPoolSize("Aimer",15)
    SetMemoryPoolSize("AmmoCounter",220)
    SetMemoryPoolSize("BaseHint",200)
    SetMemoryPoolSize("EnergyBar",220)
    SetMemoryPoolSize("EntityCloth",20)
    SetMemoryPoolSize("EntitySoundStream",2)
    SetMemoryPoolSize("EntitySoundStatic",128)
    SetMemoryPoolSize("FlagItem",2)
    SetMemoryPoolSize("MountedTurret",3)
    SetMemoryPoolSize("Obstacle",309)
    SetMemoryPoolSize("TreeGridStack",200)
    SetMemoryPoolSize("Weapon",220)
    SetSpawnDelay(10,0.25)
    ReadDataFile("mus\\mus1.lvl","MUS1_CONQUEST")
    SetDenseEnvironment("false")
    SetMaxFlyHeight(90)
    SetMaxPlayerFlyHeight(90)
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetAmbientMusic(1,1,"rep_mus_amb_start",0,1)
    SetAmbientMusic(1,0.80000001192093,"rep_mus_amb_middle",1,1)
    SetAmbientMusic(1,0.20000000298023,"rep_mus_amb_end",2,1)
    SetAmbientMusic(2,1,"cis_mus_amb_start",0,1)
    SetAmbientMusic(2,0.80000001192093,"cis_mus_amb_middle",1,1)
    SetAmbientMusic(2,0.20000000298023,"cis_mus_amb_end",2,1)
    SetVictoryMusic(1,"rep_mus_amb_victory")
    SetDefeatMusic(1,"rep_mus_amb_defeat")
    SetVictoryMusic(2,"cis_mus_amb_victory")
    SetDefeatMusic(2,"cis_mus_amb_defeat")
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

