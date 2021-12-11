--Extracted\myg1g_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")
ALL = 1
IMP = 2
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
        SetPSPModelMemory(4527169)
        SetPSPClipper(0)
else
        SetPS2ModelMemory(3760000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\myg.lvl;myg1gcw")
    SetMaxFlyHeight(20)
    SetMaxPlayerFlyHeight(20)
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman","all_inf_rocketeer","all_inf_sniper","all_inf_engineer","all_inf_officer","all_hero_luke_jedi","all_inf_wookiee","all_hover_combatspeeder")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_officer","imp_inf_sniper","imp_inf_engineer","imp_inf_dark_trooper","imp_hero_bobafett","imp_hover_fightertank","imp_walk_atst")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_recoilless_lg")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            all =             { team = ALL, units = 10, reinforcements = 75, 
              soldier =               { "all_inf_rifleman" }, 
              assault =               { "all_inf_rocketeer" }, 
              engineer =               { "all_inf_engineer" }, 
              sniper =               { "all_inf_sniper" }, 
              officer =               { "all_inf_officer" }, 
              special =               { "all_inf_wookiee" }
             }, 
            imp =             { team = IMP, units = 10, reinforcements = 75, 
              soldier =               { "imp_inf_rifleman" }, 
              assault =               { "imp_inf_rocketeer" }, 
              engineer =               { "imp_inf_engineer" }, 
              sniper =               { "imp_inf_sniper" }, 
              officer =               { "imp_inf_officer" }, 
              special =               { "imp_inf_dark_trooper", 2, 5 }
             }
           })
else
        SetupTeams({ 
            all =             { team = ALL, units = 25, reinforcements = 200, 
              soldier =               { "all_inf_rifleman" }, 
              assault =               { "all_inf_rocketeer" }, 
              engineer =               { "all_inf_engineer" }, 
              sniper =               { "all_inf_sniper" }, 
              officer =               { "all_inf_officer" }, 
              special =               { "all_inf_wookiee" }
             }, 
            imp =             { team = IMP, units = 25, reinforcements = 200, 
              soldier =               { "imp_inf_rifleman" }, 
              assault =               { "imp_inf_rocketeer" }, 
              engineer =               { "imp_inf_engineer" }, 
              sniper =               { "imp_inf_sniper" }, 
              officer =               { "imp_inf_officer" }, 
              special =               { "imp_inf_dark_trooper", 2, 5 }
             }
           })
end
    SetHeroClass(IMP,"imp_hero_bobafett")
    SetHeroClass(ALL,"all_hero_luke_jedi")
    ClearWalkers()
    AddWalkerType(1,0)
    SetMemoryPoolSize("Aimer",80)
    SetMemoryPoolSize("EntityCloth",37)
    SetMemoryPoolSize("EntityHover",7)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("EntityLight",36)
    SetMemoryPoolSize("MountedTurret",14)
    SetMemoryPoolSize("Obstacle",500)
    SetMemoryPoolSize("PathNode",512)
    SetMemoryPoolSize("TreeGridStack",300)
    SetMemoryPoolSize("Weapon",260)
    SetSpawnDelay(10,0.25)
    ReadDataFile("myg\\myg1.lvl","myg1_conquest")
    SetDenseEnvironment("false")
    AddDeathRegion("deathregion")
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(ALL,1,"all_myg_amb_start",0,1)
    SetAmbientMusic(ALL,0.80000001192093,"all_myg_amb_middle",1,1)
    SetAmbientMusic(ALL,0.20000000298023,"all_myg_amb_end",2,1)
    SetAmbientMusic(IMP,1,"imp_myg_amb_start",0,1)
    SetAmbientMusic(IMP,0.80000001192093,"imp_myg_amb_middle",1,1)
    SetAmbientMusic(IMP,0.20000000298023,"imp_myg_amb_end",2,1)
    SetVictoryMusic(ALL,"all_myg_amb_victory")
    SetDefeatMusic(ALL,"all_myg_amb_defeat")
    SetVictoryMusic(IMP,"imp_myg_amb_victory")
    SetDefeatMusic(IMP,"imp_myg_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(ATT)
    AddCameraShot(0.94799000024796,-0.029190000146627,0.31680798530579,0.0097549995407462,-88.997039794922,14.15385055542,-17.227827072144)
    AddCameraShot(0.96342700719833,-0.26038599014282,-0.061110001057386,-0.016516000032425,-118.96892547607,39.055625915527,124.03238677979)
    AddCameraShot(0.73388397693634,-0.18114300072193,0.63560098409653,0.15688399970531,67.597633361816,39.055625915527,55.312774658203)
    AddCameraShot(0.0083149997517467,9.9999999747524e-007,-0.99996501207352,7.4000003223773e-005,-64.894348144531,5.541570186615,201.71109008789)
end

