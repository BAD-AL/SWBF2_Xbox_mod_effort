--Extracted\spa8g_1flag.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("spa8g_cmn")
myGameMode = "spa8_1flag"

function SetupUnits()
    ReadDataFile("SIDE\\all.lvl","all_inf_pilot","all_fly_xwing_sc","all_fly_ywing_sc","all_fly_awing","all_veh_remote_terminal")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_pilot","imp_fly_tiefighter_sc","imp_fly_tiebomber_sc","imp_fly_tieinterceptor","imp_veh_remote_terminal")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_spa_all_beam","tur_bldg_spa_all_chaingun","tur_bldg_spa_imp_beam","tur_bldg_spa_imp_chaingun","tur_bldg_chaingun_roof")
end
myTeamConfig = { 
  all =   { team = ALL, units = 16, reinforcements = -1, 
    pilot =     { "all_inf_pilot", 16 }
   }, 
  imp =   { team = IMP, units = 16, reinforcements = -1, 
    pilot =     { "imp_inf_pilot", 16 }
   }
 }

function myScriptInit()
    SetMemoryPoolSize("FlagItem",1)
end

function ScriptPostLoad()
    SetClassProperty("com_item_flag","DroppedColorize",1)
    ctf = ObjectiveOneFlagCTF:New({ teamATT = IMP, teamDEF = ALL, textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", flag = "cmn_flag", homeRegion = "home_1flag", captureRegionATT = "imp_cap_1flag", captureRegionDEF = "all_cap_1flag", capRegionDummyObjectATT = "1flag_imp_marker", capRegionDummyObjectDEF = "1flag_all_marker", multiplayerRules = true, hideCPs = true, AIGoalWeight = 0 })
    SoundEvent_SetupTeams(IMP,"imp",ALL,"all")
    ctf:Start()
    SetupTurrets()
    LockHangarWarsDoors(true)
    SetupFrigDeathAnims()
    AddAIGoal(IMP,"Deathmatch",100)
    AddAIGoal(ALL,"Deathmatch",100)
end

