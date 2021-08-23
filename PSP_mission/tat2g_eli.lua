--Extracted\tat2g_eli.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveTDM")

function ScriptPostLoad()
    EnableSPHeroRules()
    TDM = ObjectiveTDM:New({ teamATT = 1, teamDEF = 2, multiplayerScoreLimit = 100, textATT = "game.modes.tdm", textDEF = "game.modes.tdm2", multiplayerRules = true, isCelebrityDeathmatch = true })
    TDM:Start()
    AddAIGoal(1,"Deathmatch",100)
    AddAIGoal(2,"Deathmatch",100)
end

function ScriptInit()
    StealArtistHeap(1536 * 1024)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(3044433)
        SetPSPClipper(1)
else
        SetPS2ModelMemory(2097152 + 65536 * 8)
end
    SetMemoryPoolSize("ClothData",20)
    SetMemoryPoolSize("Combo",30)
    SetMemoryPoolSize("Combo::State",500)
    SetMemoryPoolSize("Combo::Transition",500)
    SetMemoryPoolSize("Combo::Condition",500)
    SetMemoryPoolSize("Combo::Attack",400)
    SetMemoryPoolSize("Combo::DamageSample",4000)
    SetMemoryPoolSize("Combo::Deflect",80)
    ReadDataFile("ingame.lvl")
    ALL = 1
    IMP = 2
    ATT = 1
    DEF = 2
    SetMaxFlyHeight(40)
    ReadDataFile("sound\\tat.lvl;tat2gcw")
    ReadDataFile("SIDE\\all.lvl","all_hero_luke_jedi","all_hero_hansolo_tat","all_hero_leia","all_hero_chewbacca")
    ReadDataFile("SIDE\\imp.lvl","imp_hero_darthvader","imp_hero_emperor","imp_hero_bobafett")
    ReadDataFile("SIDE\\rep.lvl","rep_hero_yoda","rep_hero_macewindu","rep_hero_anakin","rep_hero_aalya","rep_hero_kiyadimundi","rep_hero_obiwan")
    ReadDataFile("SIDE\\cis.lvl","cis_hero_grievous","cis_hero_darthmaul","cis_hero_countdooku","cis_hero_jangofett")
    SetupTeams({ 
        hero =         { team = ALL, units = 12, reinforcements = -1, 
          soldier =           { "all_hero_hansolo_tat", 1, 2 }, 
          assault =           { "all_hero_chewbacca", 1, 2 }, 
          engineer =           { "all_hero_luke_jedi", 1, 2 }, 
          sniper =           { "rep_hero_obiwan", 1, 2 }, 
          officer =           { "rep_hero_yoda", 1, 2 }, 
          special =           { "rep_hero_macewindu", 1, 2 }
         }
       })
    AddUnitClass(ALL,"all_hero_leia",1,2)
    AddUnitClass(ALL,"rep_hero_aalya",1,2)
    AddUnitClass(ALL,"rep_hero_kiyadimundi",1,2)
    SetupTeams({ 
        villain =         { team = IMP, units = 12, reinforcements = -1, 
          soldier =           { "imp_hero_bobafett", 1, 2 }, 
          assault =           { "imp_hero_darthvader", 1, 2 }, 
          engineer =           { "cis_hero_darthmaul", 1, 2 }, 
          sniper =           { "cis_hero_jangofett", 1, 2 }, 
          officer =           { "cis_hero_grievous", 1, 2 }, 
          special =           { "imp_hero_emperor", 1, 2 }
         }
       })
    AddUnitClass(IMP,"rep_hero_anakin",1,2)
    AddUnitClass(IMP,"cis_hero_countdooku",1,2)
    ClearWalkers()
    AddWalkerType(0,0)
    AddWalkerType(1,0)
    AddWalkerType(2,0)
    AddWalkerType(3,0)
    SetMemoryPoolSize("Aimer",1)
    SetMemoryPoolSize("AmmoCounter",96)
    SetMemoryPoolSize("BaseHint",320)
    SetMemoryPoolSize("ConnectivityGraphFollower",23)
    SetMemoryPoolSize("EnergyBar",96)
    SetMemoryPoolSize("EntityCloth",40)
    SetMemoryPoolSize("EntityDroid",0)
    SetMemoryPoolSize("EntityFlyer",5)
    SetMemoryPoolSize("EntityPortableTurret",0)
    SetMemoryPoolSize("EntitySoundStream",2)
    SetMemoryPoolSize("EntitySoundStatic",45)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix",105)
    SetMemoryPoolSize("MountedTurret",0)
    SetMemoryPoolSize("Navigator",23)
    SetMemoryPoolSize("Obstacle",667)
    SetMemoryPoolSize("PathFollower",23)
    SetMemoryPoolSize("PathNode",128)
    SetMemoryPoolSize("ShieldEffect",0)
    SetMemoryPoolSize("TreeGridStack",290)
    SetMemoryPoolSize("UnitAgent",23)
    SetMemoryPoolSize("UnitController",23)
    SetMemoryPoolSize("Weapon",96)
    SetSpawnDelay(10,0.25)
    ReadDataFile("TAT\\tat2.lvl","tat2_tdm")
    SetDenseEnvironment("false")
    ScriptCB_EnableHeroMusic(0)
    ScriptCB_EnableHeroVO(0)
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(ALL,1,"gen_amb_celebDeathmatch",0,1)
    SetAmbientMusic(IMP,1,"gen_amb_celebDeathmatch",0,1)
    SetVictoryMusic(ALL,"all_tat_amb_victory")
    SetDefeatMusic(ALL,"all_tat_amb_defeat")
    SetVictoryMusic(IMP,"imp_tat_amb_victory")
    SetDefeatMusic(IMP,"imp_tat_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(ATT)
    AddCameraShot(0.97433799505234,-0.22217999398708,0.035172000527382,0.0080199996009469,-82.664649963379,23.668300628662,43.955680847168)
    AddCameraShot(0.39019700884819,-0.089729003608227,-0.89304000139236,-0.2053620070219,23.563562393188,12.914884567261,-101.46556091309)
    AddCameraShot(0.16975900530815,0.0022249999456108,-0.98539799451828,0.012915999628603,126.97280883789,4.0396280288696,-22.020612716675)
    AddCameraShot(0.67745298147202,-0.041535001248121,0.73301601409912,0.044941999018192,97.517807006836,4.0396280288696,36.853477478027)
    AddCameraShot(0.86602902412415,-0.15650600194931,0.46729901432991,0.084449000656605,7.6856398582458,7.1306881904602,-10.895234107971)
end

