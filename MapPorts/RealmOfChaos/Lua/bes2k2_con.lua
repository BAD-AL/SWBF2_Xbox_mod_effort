-- bes2k2_con.lua 
-- dervived from  bes2g_con (Decompiled with SWBF2CodeHelper)
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

function ScriptPostLoad()
    EnableSPHeroRules()
    cp1 = CommandPost:New({ name = "CP1" })
    cp2 = CommandPost:New({ name = "CP2" })
    cp3 = CommandPost:New({ name = "CP3" })
    cp4 = CommandPost:New({ name = "CP4" })
    cp5 = CommandPost:New({ name = "CP5" })
    cp6 = CommandPost:New({ name = "CP7" })
    conquest = ObjectiveConquest:New({ 
        teamATT = ATT, 
        teamDEF = DEF, 
        textATT = "game.modes.con", 
        textDEF = "game.modes.con2",
        multiplayerRules = true }
    )

    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:Start()

    -- #################### Chaos Boba Fett ###########################
    SetClassProperty("imp_hero_bobafett", "WeaponAmmo1", "7")  -- the ammo goes fast, don't give too much because it'll make him way OP   
    SetClassProperty("imp_hero_bobafett", "WeaponAmmo2", "75") -- get him upto chaos levels of ammo 
    SetClassProperty("imp_hero_bobafett", "WeaponAmmo3", "75") -- get him upto chaos levels of ammo 
    SetClassProperty("imp_hero_bobafett", "WeaponAmmo4", "75") -- get him upto chaos levels of ammo 

        -- get him upto chaos levels of Jet pack --
    SetClassProperty("imp_hero_bobafett", "ControlSpeed", "jet    1.50 1.25 1.25")
    SetClassProperty("imp_hero_bobafett", "JetJump", "21.0" )               --The initial jump-push given when enabling the jet
    SetClassProperty("imp_hero_bobafett", "JetPush", "80.0" )               --The constant push given while the jet is enabled (20 is gravity)
    SetClassProperty("imp_hero_bobafett", "JetAcceleration", "200.0" )      --Acceleration while hovering.
    SetClassProperty("imp_hero_bobafett", "JetFuelRechargeRate", "0.99")    --Additional fuel per second (fuel is 0 to 1)
    SetClassProperty("imp_hero_bobafett", "JetFuelCost", "0.01")            --Cost per second when hovering (only used for jet-hovers)(fuel is 0 to 1)
    SetClassProperty("imp_hero_bobafett", "JetFuelInitialCost", "0.01")     --initial cost when jet jumping(fuel is 0 to 1)
    SetClassProperty("imp_hero_bobafett", "JetFuelMinBorder", "0.1")        --minimum fuel to perform a jet jump(fuel is 0 to 1)

end

function ScriptInit()
    SetPS2ModelMemory(2097152 + 65536 * 18)
    
    ReadDataFile("ingame.lvl")
    
    SetMemoryPoolSize("ClothData",20)
    SetMemoryPoolSize("Combo",30)
    SetMemoryPoolSize("Combo::State",500)
    SetMemoryPoolSize("Combo::Transition",500)
    SetMemoryPoolSize("Combo::Condition",500)
    SetMemoryPoolSize("Combo::Attack",400)
    SetMemoryPoolSize("Combo::DamageSample",4000)
    SetMemoryPoolSize("Combo::Deflect",88)
    
    SetTeamAggressiveness(1,0.94999998807907)
    SetTeamAggressiveness(2,0.94999998807907)
    
    SetMaxFlyHeight(200)
    SetMaxPlayerFlyHeight(200)
    
    ReadDataFile("sound\\dea.lvl;dea1gcw")
    --ReadDataFile("sound\\kam.lvl;kam1gcw")
    
    --ReadDataFile("DC:SIDE\\rep.lvl", "rep_inf_ep3_sniper_felucia")
    local assetLocation = "addon\\002\\"
    ReadDataFile("DC:SIDE\\all.lvl",
                    "all_inf_rifleman",
                    "all_inf_rocketeer",
                    "all_inf_engineer",
                    "all_inf_sniper",
                    --"all_inf_officer",
                    "all_inf_wookiee",
                    "all_hero_hansolo_tat"
    )
    
    ReadDataFile("DC:SIDE\\imp.lvl",
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_inf_engineer",
                    "imp_inf_sniper",
                    --"imp_inf_officer",
                    "imp_inf_dark_trooper",
                    "imp_hero_bobafett" 
    )
    
    
    SetupTeams({ 
        imp = { 
            team = 1, 
            units = 20, 
            reinforcements = 150, 
            soldier =  { "imp_inf_rifleman", 9, 25 }, 
            assault =  { "imp_inf_rocketeer", 1, 4 }, 
            engineer = { "imp_inf_engineer", 1, 4 }, 
            sniper =   { "imp_inf_sniper", 1, 4 }, 
            officer =  { "imp_hero_bobafett", 1, 1 }, 
            special =  { "imp_inf_dark_trooper", 1, 4 }
         }, 
        all = { 
            team = 2, 
            units = 20, 
            reinforcements = 150, 
            soldier =  { "all_inf_rifleman", 9, 25 }, 
            assault =  { "all_inf_rocketeer", 1, 4 }, 
            engineer = { "all_inf_engineer", 1, 4 }, 
            sniper =   { "all_inf_sniper", 1, 4 }, 
            officer =  { "all_hero_hansolo_tat", 1, 1 }, 
            special =  { "all_inf_wookiee", 1, 4 }
         }
       })
    
   ReadDataFile("SIDE\\tur.lvl","tur_bldg_laser","tur_bldg_tower")
    
    --SetHeroClass(2,"all_hero_luke_jedi")
    --SetHeroClass(1,"imp_hero_darthvader")
    
    ClearWalkers()
    SetMemoryPoolSize("MountedTurret",10)
    SetMemoryPoolSize("Obstacle",514)
    SetMemoryPoolSize("SoundSpaceRegion",38)
    SetSpawnDelay(10,0.25)
    
    ScriptCB_SetDCMap("BES2")
    ReadDataFile("dc:BES\\bes2.lvl","bespin2_Conquest")

    SetDenseEnvironment("true")
    
    AddDeathRegion("DeathRegion")
    AddDeathRegion("DeathRegion2")
    
    voiceSlow = OpenAudioStream("sound\\global.lvl","all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl","imp_unit_vo_slow",voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl","global_vo_slow",voiceSlow)
    voiceQuick = OpenAudioStream("sound\\global.lvl","all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl","imp_unit_vo_quick",voiceQuick)
    
    OpenAudioStream("sound\\global.lvl","gcw_music")
    OpenAudioStream("sound\\dea.lvl","dea1")
    OpenAudioStream("sound\\dea.lvl","dea1")
    
    SetBleedingVoiceOver(2,2,"all_off_com_report_us_overwhelmed",1)
    SetBleedingVoiceOver(2,1,"all_off_com_report_enemy_losing",1)
    SetBleedingVoiceOver(1,2,"imp_off_com_report_enemy_losing",1)
    SetBleedingVoiceOver(1,1,"imp_off_com_report_us_overwhelmed",1)
    
    SetLowReinforcementsVoiceOver(2,2,"all_off_defeat_im",0.10000000149012,1)
    SetLowReinforcementsVoiceOver(2,1,"all_off_victory_im",0.10000000149012,1)
    SetLowReinforcementsVoiceOver(1,1,"imp_off_defeat_im",0.10000000149012,1)
    SetLowReinforcementsVoiceOver(1,2,"imp_off_victory_im",0.10000000149012,1)
    
    SetOutOfBoundsVoiceOver(1,"allleaving")
    SetOutOfBoundsVoiceOver(2,"impleaving")
    
    -- [[
    SetAmbientMusic(2,1,"all_dea_amb_start",0,1)
    SetAmbientMusic(2,0.80000001192093,"all_dea_amb_middle",1,1)
    SetAmbientMusic(2,0.20000000298023,"all_dea_amb_end",2,1)
    SetAmbientMusic(1,1,"imp_dea_amb_start",0,1)
    SetAmbientMusic(1,0.80000001192093,"imp_dea_amb_middle",1,1)
    SetAmbientMusic(1,0.20000000298023,"imp_dea_amb_end",2,1)
    
    SetVictoryMusic(2,"all_dea_amb_victory")
    SetDefeatMusic(2,"all_dea_amb_defeat")
    SetVictoryMusic(1,"imp_dea_amb_victory")
    SetDefeatMusic(1,"imp_dea_amb_defeat")
    -- ]]

    --[[
    -- i'm using the kam sound for bobafett's blaster 
    SetAmbientMusic(ALL, 1.0, "all_kam_amb_start",  0,1)
    SetAmbientMusic(ALL, 0.8, "all_kam_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.2, "all_kam_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_kam_amb_start",  0,1)
    SetAmbientMusic(IMP, 0.8, "imp_kam_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.2, "imp_kam_amb_end",    2,1)

    SetVictoryMusic(ALL, "all_kam_amb_victory")
    SetDefeatMusic (ALL, "all_kam_amb_defeat")
    SetVictoryMusic(IMP, "imp_kam_amb_victory")
    SetDefeatMusic (IMP, "imp_kam_amb_defeat")
    ---------------------------------------------------]]

    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")

    AddCameraShot(0.87934798002243,-0.14204600453377,0.4486840069294,0.072477996349335,-38.413761138916,30.986400604248,195.87962341309)
    AddCameraShot(0.75514298677444,0.032623998820782,0.65413701534271,-0.028260000050068,-80.924102783203,-32.534858703613,59.805065155029)
    AddCameraShot(0.59651398658752,-0.068856000900269,-0.79437202215195,-0.091695003211498,-139.20362854004,-28.934867858887,56.316780090332)
    AddCameraShot(0.073601998388767,-0.011602000333369,-0.98505997657776,-0.15527200698853,-118.28823852539,-28.934867858887,125.93835449219)
    AddCameraShot(0.90268701314926,0.0012740000383928,0.43029499053955,-0.00060700002359226,-90.957382202148,-47.834819793701,180.83178710938)
    AddCameraShot(-0.4188149869442,-0.024035999551415,-0.9062619805336,0.052011001855135,-162.06648254395,-47.23482131958,80.504837036133)
    AddCameraShot(0.98835700750351,0.062969997525215,0.13822799921036,-0.0088069997727871,-173.7740020752,-55.334800720215,142.56781005859)
    AddCameraShot(-0.10055399686098,0.0081599997356534,-0.99163901805878,-0.080476000905037,-246.95443725586,-31.334861755371,153.43881225586)
    AddCameraShot(0.71716398000717,-0.018075000494719,0.69644898176193,0.017552999779582,-216.82719421387,-31.334861755371,186.86364746094)
    AddCameraShot(0.84485000371933,-0.049701999872923,0.53176999092102,0.031284000724554,-247.18145751953,-45.734825134277,29.732486724854)
    AddCameraShot(0.45488101243973,0.028302000835538,-0.88838398456573,0.055273000150919,-291.63665771484,-48.734817504883,21.009202957153)
    AddCameraShot(0.81832200288773,-0.026149999350309,-0.57387399673462,-0.0183390006423,-193.43464660645,-58.634792327881,-12.443043708801)
    AddCameraShot(0.4711090028286,0.0046910000964999,-0.88201802968979,0.0087829995900393,-192.2516784668,-61.334785461426,-32.647247314453)
end
