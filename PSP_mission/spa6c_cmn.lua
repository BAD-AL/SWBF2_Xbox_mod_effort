--Extracted\spa6c_cmn.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
REP = 1
CIS = 2
ATT = 1
DEF = 2

function SetupUnits()
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_pilot","rep_inf_ep3_marine","rep_fly_assault_dome","rep_fly_anakinstarfighter_sc","rep_fly_arc170fighter_sc","rep_veh_remote_terminal","rep_fly_gunship_sc","rep_fly_vwing")
    ReadDataFile("SIDE\\cis.lvl","cis_inf_pilot","cis_inf_marine","cis_fly_fedlander_dome","cis_fly_droidfighter_sc","cis_fly_droidgunship","cis_fly_greviousfighter","cis_fly_tridroidfighter")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_spa_cis_beam","tur_bldg_spa_cis_chaingun","tur_bldg_spa_rep_beam","tur_bldg_spa_rep_chaingun","tur_bldg_chaingun_roof")
end
myTeamConfig = { 
  rep =   { team = REP, units = 16, reinforcements = -1, 
    pilot =     { "rep_inf_ep3_pilot", 10 }, 
    marine =     { "rep_inf_ep3_marine", 6 }
   }, 
  cis =   { team = CIS, units = 16, reinforcements = -1, 
    pilot =     { "cis_inf_pilot", 10 }, 
    marine =     { "cis_inf_marine", 6 }
   }
 }

function LockHangarWarsDoors(LockHangarWarsDoorsParam0)
    true = ERROR_PROCESSING_FUNCTION
end

function SetupFrigateDeaths()
    OnObjectKillName(,"cis_frig1")
    OnObjectKillName(,"cis_frig2")
    OnObjectKillName(,"cis_frig3")
    OnObjectKillName(,"rep_frig1")
    OnObjectKillName(,"rep_frig2")
    OnObjectKillName(,"rep_frig3")
end
ScriptCB_DoFile("LinkedTurrets")

function SetupTurrets()
    turretLinkageCIS = LinkedTurrets:New({ team = CIS, mainframe = "cis_cap1_liquidgen", 
        turrets =         { "cis_cap1_tur1", "cis_cap1_tur2", "cis_cap1_tur3", "cis_cap1_tur4" }
       })
    turretLinkageCIS:Init()
    turretLinkageREP = LinkedTurrets:New({ team = REP, mainframe = "rep_cap2_liquidgen", 
        turrets =         { "rep_cap2_tur1", "rep_cap2_tur2", "rep_cap2_tur3", "rep_cap2_tur4", "rep_cap2_tur5" }
       })
    turretLinkageREP:Init()
end

function ScriptPreInit()
    SetWorldExtents(1300)
    ScriptPreInit = nil
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(5.4000000953674 * 1024 * 1024)
else
        SetPS2ModelMemory(4900000)
end
    ReadDataFile("ingame.lvl")
    SetMinFlyHeight(-480)
    SetMaxFlyHeight(1800)
    SetMinPlayerFlyHeight(-480)
    SetMaxPlayerFlyHeight(1800)
    SetAIVehicleNotifyRadius(100)
    ReadDataFile("sound\\spa.lvl;spa2cw")
    ScriptCB_SetDopplerFactor(0.40000000596046)
    ScaleSoundParameter("explosion","MaxDistance",15)
    ScaleSoundParameter("explosion","MuteDistance",15)
    SetupUnits()
    SetupTeams(myTeamConfig)
    ClearWalkers()
    SetMemoryPoolSize("Aimer",240)
    SetMemoryPoolSize("AmmoCounter",240)
    SetMemoryPoolSize("BaseHint",50)
    SetMemoryPoolSize("CommandFlyer",4)
    SetMemoryPoolSize("EnergyBar",240)
    SetMemoryPoolSize("EntityCloth",2)
    SetMemoryPoolSize("EntityFlyer",36)
    SetMemoryPoolSize("EntityLight",100)
    SetMemoryPoolSize("EntityDroid",0)
    SetMemoryPoolSize("EntityDefenseGridTurret",0)
    SetMemoryPoolSize("EntityRemoteTerminal",18)
    SetMemoryPoolSize("MountedTurret",64)
    SetMemoryPoolSize("Navigator",32)
    SetMemoryPoolSize("Obstacle",200)
    SetMemoryPoolSize("PathNode",128)
    SetMemoryPoolSize("UnitAgent",70)
    SetMemoryPoolSize("UnitController",70)
    SetMemoryPoolSize("TreeGridStack",175)
    SetMemoryPoolSize("Weapon",240)
    SetMemoryPoolSize("TentacleSimulator",0)
    SetMemoryPoolSize("Combo::DamageSample",0)
    SetSpawnDelay(10,0.25)
if myScriptInit == true then
        myScriptInit()
end
    myScriptInit = nil
    true = ERROR_PROCESSING_FUNCTION
end

function OnObjectKillName(OnObjectKillNameParam0)
    GetEntityName(OnObjectKillNameParam0)
    true = ERROR_PROCESSING_FUNCTION
end

function OnDisableMainframe(OnDisableMainframeParam0)
    ShowMessageText("level.spa.hangar.mainframe.atk.down",REP)
    ShowMessageText("level.spa.hangar.mainframe.def.down",CIS)
    BroadcastVoiceOver("ROSMP_obj_20",REP)
    BroadcastVoiceOver("COSMP_obj_21",CIS)
end

function OnEnableMainframe(OnEnableMainframeParam0)
    ShowMessageText("level.spa.hangar.mainframe.atk.up",REP)
    ShowMessageText("level.spa.hangar.mainframe.def.up",CIS)
    BroadcastVoiceOver("ROSMP_obj_22",REP)
    BroadcastVoiceOver("COSMP_obj_23",CIS)
end

function OnDisableMainframe(OnDisableMainframeParam0)
    ShowMessageText("level.spa.hangar.mainframe.atk.down",CIS)
    ShowMessageText("level.spa.hangar.mainframe.def.down",REP)
    BroadcastVoiceOver("ROSMP_obj_21",REP)
    BroadcastVoiceOver("COSMP_obj_20",CIS)
end

function OnEnableMainframe(OnEnableMainframeParam0)
    ShowMessageText("level.spa.hangar.mainframe.atk.up",CIS)
    ShowMessageText("level.spa.hangar.mainframe.def.up",REP)
    BroadcastVoiceOver("ROSMP_obj_23",REP)
    BroadcastVoiceOver("COSMP_obj_22",CIS)
end

