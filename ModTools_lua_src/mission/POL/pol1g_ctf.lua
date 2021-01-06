--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
CTF = ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("setup_teams") 

 ---------------------------------------------------------------------------
 -- FUNCTION:    ScriptInit
 -- PURPOSE:     This function is only run once
 -- INPUT:
 -- OUTPUT:
 -- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
 --              mission script must contain a version of this function, as
 --              it is called from C to start the mission.
 ---------------------------------------------------------------------------
 
 --PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()
        SetProperty ("com_item_vehicle_spawn", "SpawnCount",1)
        SetProperty ("com_item_vehicle_spawn1", "SpawnCount",1)
        SetProperty ("com_item_vehicle_spawn2", "SpawnCount",1)

        SoundEvent_SetupTeams( ALL, 'all', IMP, 'imp' )

        EnableSPHeroRules()
        DisableBarriers("Barrier300")
            DisableBarriers("Barrier337")
            DisableBarriers("Barrier338")
            DisableBarriers("Barrier339")
            DisableBarriers("Barrier340")
            DisableBarriers("Barrier341")
            DisableBarriers("Barrier336")
            DisableBarriers("Barrier313") 
            PlayAnimation("DoorOpen01")
            PlayAnimation("DoorOpen02")


--Capture the Flag for stand-alone multiplayer
                -- These set the flags geometry names.
                --GeometryName sets the geometry when hte flag is on the ground
                --CarriedGeometryName sets the geometry that appears over a player's head that is carrying the flag
        SetProperty("flag1", "GeometryName", "com_icon_alliance_flag")
        SetProperty("flag1", "CarriedGeometryName", "com_icon_alliance_flag_carried")
        SetProperty("flag2", "GeometryName", "com_icon_imperial_flag")
        SetProperty("flag2", "CarriedGeometryName", "com_icon_imperial_flag_carried")

                --This makes sure the flag is colorized when it has been dropped on the ground
        SetClassProperty("com_item_flag_carried", "DroppedColorize", 1)

    --This is all the actual ctf objective setup
    ctf = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.CTF", textDEF = "game.modes.CTF2", hideCPs = true, multiplayerRules = true}
    ctf:AddFlag{name = "flag1", homeRegion = "Team1FlagCapture", captureRegion = "Team2FlagCapture"}
    ctf:AddFlag{name = "flag2", homeRegion = "Team2FlagCapture", captureRegion = "Team1FlagCapture"}
    ctf:Start()
    
                
            
end

 function ScriptInit()
     -- Designers, these two lines *MUST* be first!
     StealArtistHeap(160*1024)

     SetPS2ModelMemory(4230000)
     ReadDataFile("ingame.lvl")

    SetMapNorthAngle(0)
    SetMaxFlyHeight(55)
    SetMaxPlayerFlyHeight (55)
    AISnipeSuitabilityDist(30)
    
     --  These variables do not change
    ATT = 1
    DEF = 2

--  Alliance Attacking (attacker is always #1)
    ALL = DEF
    IMP = ATT
     
     ReadDataFile("sound\\pol.lvl;pol1gcw")
     
     ReadDataFile("SIDE\\all.lvl",
                    "all_inf_rifleman_urban",
                    "all_inf_rocketeer",
                    "all_inf_sniper",
                    "all_inf_engineer",
                    "all_inf_officer",
                    "all_inf_wookiee",
                    "all_hero_leia",
                    "all_hover_combatspeeder")
                   
     ReadDataFile("SIDE\\imp.lvl",
                    "imp_hover_fightertank",
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_inf_engineer",
                    "imp_inf_sniper",
                    "imp_inf_officer",
                    "imp_inf_dark_trooper",
                    "imp_hero_emperor")
                
    ReadDataFile("SIDE\\tur.lvl", 
                "tur_bldg_laser")          
     

       -- set up teams
SetupTeams{
             
        imp = {
            team = IMP,
            units = 32,
            reinforcements = -1,
            soldier  = { "imp_inf_rifleman",9, 25},
            assault  = { "imp_inf_rocketeer",1, 4},
            engineer = { "imp_inf_engineer",1, 4},
            sniper   = { "imp_inf_sniper",1, 4},
            officer = {"imp_inf_officer",1, 4},
            special = { "imp_inf_dark_trooper",1, 4},
            
        },
        all = {
            team = ALL,
            units = 32,
            reinforcements = -1,
            soldier  = { "all_inf_rifleman_urban",9, 25},
            assault  = { "all_inf_rocketeer",1, 4},
            engineer = { "all_inf_engineer",1, 4},
            sniper   = { "all_inf_sniper",1, 4},
            officer = {"all_inf_officer",1, 4},
            special = { "all_inf_wookiee",1, 4},
        }
     }
    SetHeroClass(ALL, "all_hero_leia")
    
    SetHeroClass(IMP, "imp_hero_emperor")

--  Level Stats
     ClearWalkers()
     --    AddWalkerType(0, 0) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(1, 0) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
     --    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    local weaponCnt = 200
    SetMemoryPoolSize ("Aimer", 60)
    SetMemoryPoolSize ("AmmoCounter", weaponCnt)
    SetMemoryPoolSize ("BaseHint", 245)
    SetMemoryPoolSize ("EnergyBar", weaponCnt)
    SetMemoryPoolSize ("EntityCloth", 20)
    SetMemoryPoolSize ("EntityHover",5)
    SetMemoryPoolSize ("EntityLight",63)
    SetMemoryPoolSize ("EntitySoundStream", 25)
    SetMemoryPoolSize ("EntitySoundStatic", 9)
    SetMemoryPoolSize ("FlagItem", 2)
    SetMemoryPoolSize ("MountedTurret", 4)
    SetMemoryPoolSize ("Navigator", 50)
    SetMemoryPoolSize ("Obstacle", 400)
    SetMemoryPoolSize ("PathFollower", 50)
    SetMemoryPoolSize ("PathNode", 256)
    SetMemoryPoolSize ("ShieldEffect", 0)
    SetMemoryPoolSize ("SoundSpaceRegion", 34)
    SetMemoryPoolSize ("TreeGridStack", 200)
    SetMemoryPoolSize ("UnitAgent", 50)
    SetMemoryPoolSize ("UnitController", 50)
    SetMemoryPoolSize ("Weapon", weaponCnt)
    SetMemoryPoolSize("EntityFlyer", 4)   

    SetMemoryPoolSize ("Asteroid", 100)



     SetSpawnDelay(10.0, 0.25)
     ReadDataFile("pol\\pol1.lvl","pol1_CTF")
     SetDenseEnvironment("True")   
     AddDeathRegion("deathregion1")
     --SetStayInTurrets(1)



--asteroids start!
SetParticleLODBias(3000)
SetMaxCollisionDistance(1500)     
--    FillAsteroidPath("pathas01", 10, "pol1_prop_asteroid_01", 20, 1.0,0.0,0.0, -1.0,0.0,0.0);
--    FillAsteroidPath("pathas01", 20, "pol1_prop_asteroid_02", 40, 1.0,0.0,0.0, -1.0,0.0,0.0);
--    FillAsteroidPath("pathas02", 10, "pol1_prop_asteroid_01", 10, 1.0,0.0,0.0, -1.0,0.0,0.0);
--    FillAsteroidPath("pathas03", 10, "pol1_prop_asteroid_02", 20, 1.0,0.0,0.0, -1.0,0.0,0.0);
--    FillAsteroidPath("pathas04", 5, "pol1_prop_asteroid_02", 2, 1.0,0.0,0.0, -1.0,0.0,0.0);      

-- asteroids end!
    
     --  Movies
     --  SetVictoryMovie(ALL, "all_end_victory")
     --  SetDefeatMovie(ALL, "imp_end_victory")
     --  SetVictoryMovie(IMP, "imp_end_victory")
     --  SetDefeatMovie(IMP, "all_end_victory")

     --  Sound
     
    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)
     
     OpenAudioStream("sound\\global.lvl",  "gcw_music")
     -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
     -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
     OpenAudioStream("sound\\pol.lvl",  "pol1")
     OpenAudioStream("sound\\pol.lvl",  "pol1")
     -- OpenAudioStream("sound\\pol.lvl",  "pol1gcw_emt")

     -- SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
     -- SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
     -- SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
     -- SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

     -- SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
     -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
     -- SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
     -- SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

     SetOutOfBoundsVoiceOver(1, "impleaving")
     SetOutOfBoundsVoiceOver(2, "allleaving")

     SetAmbientMusic(ALL, 1.0, "all_pol_amb_start",  0,1)
     SetAmbientMusic(ALL, 0.9, "all_pol_amb_middle", 1,1)
     SetAmbientMusic(ALL, 0.1,"all_pol_amb_end",    2,1)
     SetAmbientMusic(IMP, 1.0, "imp_pol_amb_start",  0,1)
     SetAmbientMusic(IMP, 0.9, "imp_pol_amb_middle", 1,1)
     SetAmbientMusic(IMP, 0.1,"imp_pol_amb_end",    2,1)

     SetVictoryMusic(ALL, "all_pol_amb_victory")
     SetDefeatMusic (ALL, "all_pol_amb_defeat")
     SetVictoryMusic(IMP, "imp_pol_amb_victory")
     SetDefeatMusic (IMP, "imp_pol_amb_defeat")

     SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
     SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
     --  SetSoundEffect("BirdScatter",         "birdsFlySeq1")
     SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
     SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
     SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
     SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
     SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

     SetAttackingTeam(ATT)



    AddCameraShot(0.461189, -0.077838, -0.871555, -0.147098, 85.974007, 30.694353, -66.900795);
    AddCameraShot(0.994946, -0.100380, -0.002298, -0.000232, 109.076401, 27.636383, -10.235785);
    AddCameraShot(0.760383, 0.046402, 0.646612, -0.039459, 111.261696, 27.636383, 46.468048);
    AddCameraShot(-0.254949, 0.066384, -0.933546, -0.243078, 73.647552, 32.764030, 50.283028);
    AddCameraShot(-0.331901, 0.016248, -0.942046, -0.046116, 111.003563, 28.975283, 7.051458);
    AddCameraShot(0.295452, -0.038140, -0.946740, -0.122217, 19.856682, 36.399086, -9.890361);
    AddCameraShot(0.958050, -0.115837, -0.260254, -0.031467, -35.103737, 37.551651, 109.466576);
    AddCameraShot(-0.372488, 0.036892, -0.922789, -0.091394, -77.487892, 37.551651, 40.861832);
    AddCameraShot(0.717144, -0.084845, -0.686950, -0.081273, -106.047691, 36.238495, 60.770439);
    AddCameraShot(0.452958, -0.104748, -0.862592, -0.199478, -110.553474, 40.972584, 37.320778);
    AddCameraShot(-0.009244, 0.001619, -0.984956, -0.172550, -57.010258, 30.395561, 5.638251);
    AddCameraShot(0.426958, -0.040550, -0.899315, -0.085412, -87.005966, 30.395561, 19.625088);
    AddCameraShot(0.153632, -0.041448, -0.953179, -0.257156, -111.955055, 36.058708, -23.915501);
    AddCameraShot(0.272751, -0.002055, -0.962055, -0.007247, -117.452736, 17.298250, -58.572723);
    AddCameraShot(0.537097, -0.057966, -0.836668, -0.090297, -126.746666, 30.472836, -148.353333);
    AddCameraShot(-0.442188, 0.081142, -0.878575, -0.161220, -85.660973, 29.013374, -144.102219);
    AddCameraShot(-0.065409, 0.011040, -0.983883, -0.166056, -84.789032, 29.013374, -139.568787);
    AddCameraShot(0.430906, -0.034723, -0.898815, -0.072428, -98.038002, 47.662624, -128.643265);
    AddCameraShot(-0.401462, 0.047050, -0.908449, -0.106466, 77.586563, 47.662624, -147.517365);
    AddCameraShot(-0.269503, 0.031284, -0.956071, -0.110983, 111.260330, 16.927542, -114.045715);
    AddCameraShot(-0.338119, 0.041636, -0.933134, -0.114906, 134.970169, 26.441256, -82.282082);

end