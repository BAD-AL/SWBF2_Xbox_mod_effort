--Extracted\tan1g_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")
ALL = 1
IMP = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    AddDeathRegion("turbinedeath")
    KillObject("blastdoor")
    DisableBarriers("barracks")
    DisableBarriers("liea")
    BlockPlanningGraphArcs("turbine")
    OnObjectKillName(destturbine,"turbineconsole")
    OnObjectRespawnName(returbine,"turbineconsole")
    SetMapNorthAngle(180)
    cp4 = CommandPost:New({ name = "CP4CON" })
    cp5 = CommandPost:New({ name = "CP5CON" })
    cp6 = CommandPost:New({ name = "CP6CON" })
    cp7 = CommandPost:New({ name = "CP7CON" })
    conquest = ObjectiveConquest:New({ teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true })
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:AddCommandPost(cp7)
    conquest:Start()
    EnableSPHeroRules()
end

function destturbine()
    UnblockPlanningGraphArcs("turbine")
    PauseAnimation("Turbine Animation")
    RemoveRegion("turbinedeath")
end

function returbine()
    BlockPlanningGraphArcs("turbine")
    PlayAnimation("Turbine Animation")
    AddDeathRegion("turbinedeath")
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(4351537)
        SetPSPClipper(1)
else
        SetPS2ModelMemory(4500000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\tan.lvl;tan1gcw")
    AISnipeSuitabilityDist(30)
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman_fleet","all_inf_rocketeer_fleet","all_inf_sniper_fleet","all_inf_engineer_fleet","all_inf_officer","all_hero_leia","all_inf_wookiee")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_officer","imp_inf_sniper","imp_inf_engineer","imp_inf_dark_trooper","imp_hero_darthvader")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            all =             { team = ALL, units = 10, reinforcements = 75, 
              soldier =               { "all_inf_rifleman_fleet" }, 
              assault =               { "all_inf_rocketeer_fleet" }, 
              engineer =               { "all_inf_engineer_fleet" }, 
              sniper =               { "all_inf_sniper_fleet" }, 
              officer =               { "all_inf_officer" }, 
              special =               { "all_inf_wookiee" }
             }, 
            imp =             { team = IMP, units = 10, reinforcements = 75, 
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
            all =             { team = ALL, units = 18, reinforcements = 150, 
              soldier =               { "all_inf_rifleman_fleet" }, 
              assault =               { "all_inf_rocketeer_fleet" }, 
              engineer =               { "all_inf_engineer_fleet" }, 
              sniper =               { "all_inf_sniper_fleet" }, 
              officer =               { "all_inf_officer" }, 
              special =               { "all_inf_wookiee" }
             }, 
            imp =             { team = IMP, units = 18, reinforcements = 150, 
              soldier =               { "imp_inf_rifleman" }, 
              assault =               { "imp_inf_rocketeer" }, 
              engineer =               { "imp_inf_engineer" }, 
              sniper =               { "imp_inf_sniper" }, 
              officer =               { "imp_inf_officer" }, 
              special =               { "imp_inf_dark_trooper" }
             }
           })
end
    SetHeroClass(IMP,"imp_hero_darthvader")
    SetHeroClass(ALL,"all_hero_leia")
    ClearWalkers()
    SetMemoryPoolSize("EntityCloth",27)
    SetMemoryPoolSize("Obstacle",220)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("Weapon",260)
    SetMemoryPoolSize("SoundspaceRegion",15)
    SetSpawnDelay(10,0.25)
    ReadDataFile("tan\\tan1.lvl","tan1_conquest")
    SetDenseEnvironment("false")
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(ALL,1,"all_tan_amb_start",0,1)
    SetAmbientMusic(ALL,0.80000001192093,"all_tan_amb_middle",1,1)
    SetAmbientMusic(ALL,0.80000001192093,"all_tan_amb_end",2,1)
    SetAmbientMusic(IMP,1,"imp_tan_amb_start",0,1)
    SetAmbientMusic(IMP,0.80000001192093,"imp_tan_amb_middle",1,1)
    SetAmbientMusic(IMP,0.20000000298023,"imp_tan_amb_end",2,1)
    SetVictoryMusic(ALL,"all_tan_amb_victory")
    SetDefeatMusic(ALL,"all_tan_amb_defeat")
    SetVictoryMusic(IMP,"imp_tan_amb_victory")
    SetDefeatMusic(IMP,"imp_tan_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(ATT)
    AddCameraShot(0.23319900035858,-0.019440999254584,-0.96887397766113,-0.080770999193192,-240.75592041016,11.457644462585,105.94417572021)
    AddCameraShot(-0.39556100964546,0.079428002238274,-0.89709198474884,-0.18013499677181,-264.02227783203,6.7458729743958,122.71575164795)
    AddCameraShot(0.54670298099518,-0.041547000408173,-0.83389097452164,-0.063371002674103,-309.70989990234,5.1683039665222,145.33438110352)
end

