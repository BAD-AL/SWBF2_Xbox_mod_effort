--Extracted\myg1c_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")
REP = 1
CIS = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    DisableBarriers("dropship")
    DisableBarriers("shield_03")
    DisableBarriers("shield_02")
    DisableBarriers("shield_01")
    DisableBarriers("ctf")
    DisableBarriers("ctf1")
    DisableBarriers("ctf2")
    DisableBarriers("ctf3")
    EnableSPHeroRules()
    cp1 = CommandPost:New({ name = "CP1_CON" })
    cp2 = CommandPost:New({ name = "CP2_CON" })
    cp4 = CommandPost:New({ name = "CP4_CON" })
    cp5 = CommandPost:New({ name = "CP5_CON" })
    cp7 = CommandPost:New({ name = "CP7_CON" })
    conquest = ObjectiveConquest:New({ teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true })
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp7)
    conquest:Start()
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(4477761)
        SetPSPClipper(0)
else
        SetPS2ModelMemory(4100000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\myg.lvl;myg1cw")
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_rifleman","rep_inf_ep3_rocketeer","rep_inf_ep3_engineer","rep_inf_ep3_jettrooper","rep_inf_ep3_sniper","rep_inf_ep3_officer","rep_fly_gunship_dome","rep_hover_fightertank","rep_hero_kiyadimundi")
    ReadDataFile("SIDE\\cis.lvl","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_engineer","cis_inf_sniper","cis_hover_aat","cis_fly_gunship_dome","cis_inf_officer","cis_inf_droideka","cis_hero_grievous")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_recoilless_lg")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            rep =             { team = REP, units = 10, reinforcements = 75, 
              soldier =               { "rep_inf_ep3_rifleman" }, 
              assault =               { "rep_inf_ep3_rocketeer" }, 
              engineer =               { "rep_inf_ep3_engineer" }, 
              sniper =               { "rep_inf_ep3_sniper" }, 
              officer =               { "rep_inf_ep3_officer" }, 
              special =               { "rep_inf_ep3_jettrooper", 1, 4 }
             }, 
            cis =             { team = CIS, units = 10, reinforcements = 75, 
              soldier =               { "cis_inf_rifleman" }, 
              assault =               { "cis_inf_rocketeer" }, 
              engineer =               { "cis_inf_engineer" }, 
              sniper =               { "cis_inf_sniper" }, 
              officer =               { "cis_inf_officer" }, 
              special =               { "cis_inf_droideka", 1, 4 }
             }
           })
else
        SetupTeams({ 
            rep =             { team = REP, units = 25, reinforcements = 200, 
              soldier =               { "rep_inf_ep3_rifleman" }, 
              assault =               { "rep_inf_ep3_rocketeer" }, 
              engineer =               { "rep_inf_ep3_engineer" }, 
              sniper =               { "rep_inf_ep3_sniper" }, 
              officer =               { "rep_inf_ep3_officer" }, 
              special =               { "rep_inf_ep3_jettrooper", 1, 4 }
             }, 
            cis =             { team = CIS, units = 25, reinforcements = 200, 
              soldier =               { "cis_inf_rifleman" }, 
              assault =               { "cis_inf_rocketeer" }, 
              engineer =               { "cis_inf_engineer" }, 
              sniper =               { "cis_inf_sniper" }, 
              officer =               { "cis_inf_officer" }, 
              special =               { "cis_inf_droideka", 1, 4 }
             }
           })
end
    SetHeroClass(REP,"rep_hero_kiyadimundi")
    SetHeroClass(CIS,"cis_hero_grievous")
    ClearWalkers()
    AddWalkerType(0,4)
    AddWalkerType(2,0)
    SetMemoryPoolSize("Aimer",60)
    SetMemoryPoolSize("AmmoCounter",230)
    SetMemoryPoolSize("BaseHint",250)
    SetMemoryPoolSize("EnergyBar",230)
    SetMemoryPoolSize("EntityCloth",19)
    SetMemoryPoolSize("EntityHover",7)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("EntitySoundStream",1)
    SetMemoryPoolSize("EntitySoundStatic",0)
    SetMemoryPoolSize("MountedTurret",16)
    SetMemoryPoolSize("Navigator",50)
    SetMemoryPoolSize("Obstacle",500)
    SetMemoryPoolSize("PathNode",256)
    SetMemoryPoolSize("TreeGridStack",275)
    SetMemoryPoolSize("UnitAgent",50)
    SetMemoryPoolSize("UnitController",50)
    SetMemoryPoolSize("Weapon",230)
    SetSpawnDelay(10,0.25)
    ReadDataFile("myg\\myg1.lvl","myg1_conquest")
    SetDenseEnvironment("false")
    AddDeathRegion("deathregion")
    SetMaxFlyHeight(20)
    SetMaxPlayerFlyHeight(20)
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetAmbientMusic(REP,1,"rep_myg_amb_start",0,1)
    SetAmbientMusic(REP,0.80000001192093,"rep_myg_amb_middle",1,1)
    SetAmbientMusic(REP,0.20000000298023,"rep_myg_amb_end",2,1)
    SetAmbientMusic(CIS,1,"cis_myg_amb_start",0,1)
    SetAmbientMusic(CIS,0.80000001192093,"cis_myg_amb_middle",1,1)
    SetAmbientMusic(CIS,0.20000000298023,"cis_myg_amb_end",2,1)
    SetVictoryMusic(REP,"rep_myg_amb_victory")
    SetDefeatMusic(REP,"rep_myg_amb_defeat")
    SetVictoryMusic(CIS,"cis_myg_amb_victory")
    SetDefeatMusic(CIS,"cis_myg_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    AddCameraShot(0.94799000024796,-0.029190000146627,0.31680798530579,0.0097549995407462,-88.997039794922,14.15385055542,-17.227827072144)
    AddCameraShot(0.96342700719833,-0.26038599014282,-0.061110001057386,-0.016516000032425,-118.96892547607,39.055625915527,124.03238677979)
    AddCameraShot(0.73388397693634,-0.18114300072193,0.63560098409653,0.15688399970531,67.597633361816,39.055625915527,55.312774658203)
    AddCameraShot(0.0083149997517467,9.9999999747524e-007,-0.99996501207352,7.4000003223773e-005,-64.894348144531,5.541570186615,201.71109008789)
end

