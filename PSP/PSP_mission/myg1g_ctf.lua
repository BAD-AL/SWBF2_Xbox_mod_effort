--Extracted\myg1g_ctf.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveCTF")
ALL = 1
IMP = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    SoundEvent_SetupTeams(IMP,"imp",ALL,"all")
    DisableBarriers("corebar1")
    DisableBarriers("corebar2")
    DisableBarriers("corebar3")
    DisableBarriers("shield_01")
    DisableBarriers("shield_02")
    DisableBarriers("shield_03")
    DisableBarriers("corebar4")
    DisableBarriers("dropship")
    OnObjectRespawnName(Revived,"generator_01")
    OnObjectKillName(ShieldDied,"force_shield_01")
    OnObjectKillName(ShieldDied,"generator_01")
    OnObjectRespawnName(Revived,"generator_02")
    OnObjectKillName(ShieldDied,"force_shield_02")
    OnObjectKillName(ShieldDied,"generator_02")
    OnObjectRespawnName(Revived,"generator_03")
    OnObjectKillName(ShieldDied,"force_shield_03")
    OnObjectKillName(ShieldDied,"generator_03")
    SetProperty("flag1","GeometryName","com_icon_alliance_flag")
    SetProperty("flag1","CarriedGeometryName","com_icon_alliance_flag_carried")
    SetProperty("flag2","GeometryName","com_icon_imperial_flag")
    SetProperty("flag2","CarriedGeometryName","com_icon_imperial_flag_carried")
    SetClassProperty("com_item_flag","DroppedColorize",1)
    ctf = ObjectiveCTF:New({ teamATT = ATT, teamDEF = DEF, captureLimit = 5, textATT = "game.modes.CTF", textDEF = "game.modes.CTF2", hideCPs = true, multiplayerRules = true })
    ctf:AddFlag({ name = "flag1", homeRegion = "flag1_home", captureRegion = "flag2_home", capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3, icon = "", mapIcon = "flag_icon", mapIconScale = 3 })
    ctf:AddFlag({ name = "flag2", homeRegion = "flag2_home", captureRegion = "flag1_home", capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3, icon = "", mapIcon = "flag_icon", mapIconScale = 3 })
    ctf:Start()
    EnableSPHeroRules()
end

function Init(InitParam0)
    shieldName = "force_shield_" .. InitParam0
    genName = "generator_" .. InitParam0
    upAnim = "shield_up_" .. InitParam0
    downAnim = "shield_down_" .. InitParam0
    PlayShieldUp(shieldName,genName,upAnim,downAnim)
    BlockPlanningGraphArcs("shield_" .. InitParam0)
    EnableBarriers("shield_" .. InitParam0)
end


function ShieldDied(actor)
    fullName = GetEntityName(actor);
    numberStr = string.sub(fullName, -2, -1);
    
    shieldName = "force_shield_" .. numberStr;
    genName = "generator_" .. numberStr;
    upAnim = "shield_up_" .. numberStr;
    downAnim = "shield_down_" .. numberStr;
    
    PlayShieldDown(shieldName, genName, upAnim, downAnim);
    
    UnblockPlanningGraphArcs("shield_" .. numberStr);
    DisableBarriers("shield_" .. numberStr);

end

function Revived(actor)

    fullName = GetEntityName(actor);
    numberStr = string.sub(fullName, -2, -1);
    
    shieldName = "force_shield_" .. numberStr;
    genName = "generator_" .. numberStr;
    upAnim = "shield_up_" .. numberStr;
    downAnim = "shield_down_" .. numberStr;
    
    PlayShieldUp(shieldName, genName, upAnim, downAnim);
    BlockPlanningGraphArcs("shield_" .. numberStr);
    EnableBarriers("shield_" .. numberStr);
end

-- Drop Shield
function PlayShieldDown(shieldObj, genObj, upAnim, downAnim)
    RespawnObject(shieldObj);
    KillObject(genObj);
    PauseAnimation(upAnim);
    RewindAnimation(downAnim);
    PlayAnimation(downAnim);
  
end
-- Put Shield Backup
function PlayShieldUp(shieldObj, genObj, upAnim, downAnim)
    RespawnObject(shieldObj);
    RespawnObject(genObj);
    PauseAnimation(downAnim);
    RewindAnimation(upAnim);
    PlayAnimation(upAnim);
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(4701377)
        SetPSPClipper(0)
else
        SetPS2ModelMemory(4100000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\myg.lvl;myg1gcw")
    SetMaxFlyHeight(20)
    SetMaxPlayerFlyHeight(20)
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman","all_inf_rocketeer","all_inf_sniper","all_inf_engineer","all_inf_officer","all_hero_luke_jedi","all_inf_wookiee","all_hover_combatspeeder")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_officer","imp_inf_sniper","imp_inf_engineer","imp_inf_dark_trooper","imp_hero_bobafett","imp_hover_fightertank","imp_hover_speederbike","imp_walk_atst")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_recoilless_lg")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            all =             { team = ALL, units = 10, reinforcements = -1, 
              soldier =               { "all_inf_rifleman" }, 
              assault =               { "all_inf_rocketeer" }, 
              engineer =               { "all_inf_engineer" }, 
              sniper =               { "all_inf_sniper" }, 
              officer =               { "all_inf_officer" }, 
              special =               { "all_inf_wookiee" }
             }, 
            imp =             { team = IMP, units = 10, reinforcements = -1, 
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
            all =             { team = ALL, units = 25, reinforcements = -1, 
              soldier =               { "all_inf_rifleman" }, 
              assault =               { "all_inf_rocketeer" }, 
              engineer =               { "all_inf_engineer" }, 
              sniper =               { "all_inf_sniper" }, 
              officer =               { "all_inf_officer" }, 
              special =               { "all_inf_wookiee" }
             }, 
            imp =             { team = IMP, units = 25, reinforcements = -1, 
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
    SetMemoryPoolSize("EntityCloth",31)
    SetMemoryPoolSize("EntityHover",8)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("EntityLight",36)
    SetMemoryPoolSize("FlagItem",2)
    SetMemoryPoolSize("MountedTurret",14)
    SetMemoryPoolSize("Obstacle",440)
    SetMemoryPoolSize("PassengerSlot",0)
    SetMemoryPoolSize("PathNode",512)
    SetMemoryPoolSize("TreeGridStack",300)
    SetMemoryPoolSize("Weapon",260)
    SetSpawnDelay(10,0.25)
    ReadDataFile("myg\\myg1.lvl","myg1_ctf")
    SetDenseEnvironment("false")
    AddDeathRegion("deathregion")
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(ALL,1,"all_myg_amb_start",0,1)
    SetAmbientMusic(IMP,1,"imp_myg_amb_start",0,1)
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

