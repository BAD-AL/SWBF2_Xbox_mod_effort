--Extracted\myg1c_ctf.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveCTF")
REP = 1
CIS = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    SoundEvent_SetupTeams(CIS,"cis",REP,"rep")
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
    SetProperty("flag1","GeometryName","com_icon_republic_flag")
    SetProperty("flag1","CarriedGeometryName","com_icon_republic_flag_carried")
    SetProperty("flag2","GeometryName","com_icon_cis_flag")
    SetProperty("flag2","CarriedGeometryName","com_icon_cis_flag_carried")
    SetClassProperty("com_item_flag","DroppedColorize",1)
    ctf = ObjectiveCTF:New({ teamATT = ATT, teamDEF = DEF, captureLimit = 5, textATT = "game.modes.CTF", textDEF = "game.modes.CTF2", hideCPs = true, multiplayerRules = true })
    ctf:AddFlag({ name = "flag1", homeRegion = "flag1_home", captureRegion = "flag2_home", capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3, icon = "", mapIcon = "flag_icon", mapIconScale = 3 })
    ctf:AddFlag({ name = "flag2", homeRegion = "flag2_home", captureRegion = "flag1_home", capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3, icon = "", mapIcon = "flag_icon", mapIconScale = 3 })
    ctf:Start()
    EnableSPHeroRules()
end

function Init(numberStr)
    shieldName = "force_shield_" .. numberStr
    genName = "generator_" .. numberStr
    upAnim = "shield_up_" .. numberStr
    downAnim = "shield_down_" .. numberStr
    PlayShieldUp(shieldName,genName,upAnim,downAnim)
    BlockPlanningGraphArcs("shield_" .. numberStr)
    EnableBarriers("shield_" .. numberStr)
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
    StealArtistHeap(155000)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(4722241)
        SetPSPClipper(0)
else
        SetPS2ModelMemory(4100000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\myg.lvl;myg1cw")
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_rifleman","rep_inf_ep3_rocketeer","rep_inf_ep3_engineer","rep_inf_ep3_jettrooper","rep_inf_ep3_sniper","rep_inf_ep3_officer","rep_hover_fightertank","rep_fly_gunship_dome","rep_hover_barcspeeder","rep_hero_kiyadimundi")
    ReadDataFile("SIDE\\cis.lvl","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_engineer","cis_inf_sniper","cis_hover_aat","cis_inf_officer","cis_fly_gunship_dome","cis_inf_droideka","cis_hero_grievous")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_recoilless_lg")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            rep =             { team = REP, units = 10, reinforcements = -1, 
              soldier =               { "rep_inf_ep3_rifleman" }, 
              assault =               { "rep_inf_ep3_rocketeer" }, 
              engineer =               { "rep_inf_ep3_engineer" }, 
              sniper =               { "rep_inf_ep3_sniper" }, 
              officer =               { "rep_inf_ep3_officer" }, 
              special =               { "rep_inf_ep3_jettrooper", 1, 4 }
             }, 
            cis =             { team = CIS, units = 10, reinforcements = -1, 
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
            rep =             { team = REP, units = 25, reinforcements = -1, 
              soldier =               { "rep_inf_ep3_rifleman" }, 
              assault =               { "rep_inf_ep3_rocketeer" }, 
              engineer =               { "rep_inf_ep3_engineer" }, 
              sniper =               { "rep_inf_ep3_sniper" }, 
              officer =               { "rep_inf_ep3_officer" }, 
              special =               { "rep_inf_ep3_jettrooper", 1, 4 }
             }, 
            cis =             { team = CIS, units = 25, reinforcements = -1, 
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
    SetMemoryPoolSize("Aimer",65)
    SetMemoryPoolSize("AmmoCounter",165)
    SetMemoryPoolSize("BaseHint",250)
    SetMemoryPoolSize("EnergyBar",165)
    SetMemoryPoolSize("EntityCloth",17)
    SetMemoryPoolSize("EntityHover",8)
    SetMemoryPoolSize("EntitySoundStream",1)
    SetMemoryPoolSize("EntitySoundStatic",0)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("FlagItem",2)
    SetMemoryPoolSize("MountedTurret",13)
    SetMemoryPoolSize("Navigator",50)
    SetMemoryPoolSize("Obstacle",460)
    SetMemoryPoolSize("PathFollower",50)
    SetMemoryPoolSize("PathNode",128)
    SetMemoryPoolSize("TentacleSimulator",0)
    SetMemoryPoolSize("TreeGridStack",300)
    SetMemoryPoolSize("Weapon",165)
    SetSpawnDelay(10,0.25)
    ReadDataFile("myg\\myg1.lvl","myg1_ctf")
    SetDenseEnvironment("false")
    AddDeathRegion("deathregion")
    SetMaxFlyHeight(20)
    SetMaxPlayerFlyHeight(20)
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetAmbientMusic(REP,1,"rep_myg_amb_start",0,1)
    SetAmbientMusic(CIS,1,"cis_myg_amb_start",0,1)
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

