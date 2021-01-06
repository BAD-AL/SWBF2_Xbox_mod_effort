--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

     --  Empire Attacking (attacker is always #1)
     ALL = 1
     IMP = 2
     --  These variables do not change
     ATT = 1
     DEF = 2

 ---------------------------------------------------------------------------
 -- FUNCTION:    ScriptInit
 -- PURPOSE:     This function is only run once
 -- INPUT:
 -- OUTPUT:
 -- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
 --              mission script must contain a version of this function, as
 --              it is called from C to start the mission.
 ---------------------------------------------------------------------------
function ScriptPostLoad()

    AddDeathRegion("turbinedeath")

    KillObject("blastdoor")
    DisableBarriers("barracks")
    DisableBarriers("liea")
    -- Turbine Stuff -- 
    BlockPlanningGraphArcs("turbine")
    OnObjectKillName(destturbine, "turbineconsole")
    OnObjectRespawnName(returbine, "turbineconsole")

    SetMapNorthAngle(180)
    
    cp4 = CommandPost:New{name = "CP4CON"}
    cp5 = CommandPost:New{name = "CP5CON"}
    cp6 = CommandPost:New{name = "CP6CON"}
    cp7 = CommandPost:New{name = "CP7CON"}
    
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
    
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:AddCommandPost(cp7)
    
    conquest:Start()
    
    EnableSPHeroRules()    

    --Setup Timer-- 

    timeConsole = CreateTimer("timeConsole")

    SetTimerValue(timeConsole, 0.3)

    StartTimer(timeConsole)
    OnTimerElapse(
        function(timer)
            SetProperty("turbineconsole", "CurHealth", GetObjectHealth("turbineconsole") + 1)
            DestroyTimer(timer)
        end,
    timeConsole
    )

end

function destturbine()
    UnblockPlanningGraphArcs("turbine")
    PauseAnimation("Turbine Animation")
    RemoveRegion("turbinedeath")
--    SetProperty("woodr", "CurHealth", 15)
end

function returbine()
    BlockPlanningGraphArcs("turbine")
    PlayAnimation("Turbine Animation")
    AddDeathRegion("turbinedeath")
--    SetProperty("woodr", "CurHealth", 15)
end
 
 function ScriptInit()
     -- Designers, these two lines *MUST* be first!
     StealArtistHeap(1280*1024)
     SetPS2ModelMemory(4700000)
     ReadDataFile("ingame.lvl")
     SetWorldExtents(1064.5)
     
     ReadDataFile("sound\\tan.lvl;tan1gcw")

     --SetMaxFlyHeight(43)
     --SetMaxPlayerFlyHeight (43)
    AISnipeSuitabilityDist(30)

     ReadDataFile("SIDE\\all.lvl",
                    "all_inf_rifleman_fleet",
                    "all_inf_rocketeer_fleet",
                    "all_inf_sniper_fleet",
                    "all_inf_engineer_fleet",
                    "all_inf_officer",
                    "all_hero_leia",
                    "all_inf_wookiee")
                    
     ReadDataFile("SIDE\\imp.lvl",
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_inf_officer",
                    "imp_inf_sniper",
                    "imp_inf_engineer",
                    "imp_inf_dark_trooper",
                    "imp_hero_darthvader")
                    
    SetupTeams{

        all={
            team = ALL,
            units = 32,
            reinforcements = 150,
            soldier  = {"all_inf_rifleman_fleet",7, 25},
            assault  = {"all_inf_rocketeer_fleet",1, 4},
            engineer = {"all_inf_engineer_fleet",1, 4},
            sniper   = {"all_inf_sniper_fleet",1, 4},
            officer  = {"all_inf_officer",1, 4},
            special  = {"all_inf_wookiee",1, 4},
            
            
        },
        
        imp={
            team = IMP,
            units = 32,
            reinforcements = 150,
            soldier  = {"imp_inf_rifleman",7, 25},
            assault  = {"imp_inf_rocketeer",1, 4},
            engineer = {"imp_inf_engineer",1, 4},
            sniper   = {"imp_inf_sniper",1, 4},
            officer  = {"imp_inf_officer",1, 4},
            special  = {"imp_inf_dark_trooper",1, 4},
        }
    }


-- Hero Setup -- 

         SetHeroClass(IMP, "imp_hero_darthvader")
         SetHeroClass(ALL, "all_hero_leia")

     --  Level Stats
     ClearWalkers()
     --    AddWalkerType(0, 0) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(1, 3) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
     --    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
     SetMemoryPoolSize("EntityCloth", 27)
     SetMemoryPoolSize("Obstacle", 220)
     SetMemoryPoolSize("EntityFlyer", 6)
     SetMemoryPoolSize("Weapon", 260)
     SetMemoryPoolSize("SoundspaceRegion", 15)


     SetSpawnDelay(10.0, 0.25)
     ReadDataFile("tan\\tan1.lvl", "tan1_conquest")
     SetDenseEnvironment("false")
     --AddDeathRegion("deathregion")
     --SetStayInTurrets(1)


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
     OpenAudioStream("sound\\tan.lvl",  "tan1")
     OpenAudioStream("sound\\tan.lvl",  "tan1")
     -- OpenAudioStream("sound\\tan.lvl",  "tan1_emt")

     SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
     SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
     SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
     SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

     SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
     SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
     SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
     SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

     SetOutOfBoundsVoiceOver(1, "allleaving")
     SetOutOfBoundsVoiceOver(2, "impleaving")

     SetAmbientMusic(ALL, 1.0, "all_tan_amb_start",  0,1)
     SetAmbientMusic(ALL, 0.8, "all_tan_amb_middle", 1,1)
     SetAmbientMusic(ALL, 0.2,"all_tan_amb_end",    2,1)
     SetAmbientMusic(IMP, 1.0, "imp_tan_amb_start",  0,1)
     SetAmbientMusic(IMP, 0.8, "imp_tan_amb_middle", 1,1)
     SetAmbientMusic(IMP, 0.2,"imp_tan_amb_end",    2,1)

     SetVictoryMusic(ALL, "all_tan_amb_victory")
     SetDefeatMusic (ALL, "all_tan_amb_defeat")
     SetVictoryMusic(IMP, "imp_tan_amb_victory")
     SetDefeatMusic (IMP, "imp_tan_amb_defeat")

     SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
     SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
     --  SetSoundEffect("BirdScatter",         "birdsFlySeq1")
     SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
     SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
     SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
     SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
     SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


     SetAttackingTeam(ATT)


    AddCameraShot(0.233199, -0.019441, -0.968874, -0.080771, -240.755920, 11.457644, 105.944176);
    AddCameraShot(-0.395561, 0.079428, -0.897092, -0.180135, -264.022278, 6.745873, 122.715752);
    AddCameraShot(0.546703, -0.041547, -0.833891, -0.063371, -309.709900, 5.168304, 145.334381);
    
 end

