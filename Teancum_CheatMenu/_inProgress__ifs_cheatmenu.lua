-- Decompiled with help from SWBF2CodeHelper
ifs_cheatmenu_vbutton_layout = {
    ySpacing = 5,
    width = 360,
    font = gMenuButtonFont,
    buttonlist = {
        {tag = "unlock_hero_and_units", string = "Unlock Heroes & Classes"},
        {tag = "jetpacks", string = "Add Jetpacks"},
        {tag = "reinforcements", string = "Add 50 reinforcements"},
        {tag = "victory", string = "Force Mission Victory"},
        {tag = "extra_vehicles", string = "Enable Hidden Vehicles"},
        {tag = "no_ai_vehicles", string = "No AI in Vehicles"},
        {tag = "classic_flyers", string = "Classic Starfighters"},
        {tag = "restore_hud", string = "Restore HUD"}
    },
    title = "Cheat Menu"
}
gConsoleCmdList = {}

--Orig Closure id: 00836390
function ifs_pausemenu_fnUpdateFlyersText(param0)
    if param0.buttons["classic_flyers"] then
        SetGroundFlyerMap(1)
    else
        RoundIFButtonLabel_fnSetString(1, "Advanced Starfighters")
        SetGroundFlyerMap(0)
        RoundIFButtonLabel_fnSetString(0, "Classic Starfighters")
    end
end
--
ifs_cheatmenu =
    NewIFShellScreen {
    nologo = 1,
    bAcceptIsSelect = 1,
    movieIntro = nil,
    bDimBackdrop = 1,
    buttons = NewIFContainer {ScreenRelativeX = 0.5, ScreenRelativeY = 0.40000000596046},
    Enter = function(EnterParam0, EnterParam1)
        gIFShellScreenTemplate_fnEnter(EnterParam0, EnterParam1)
        ScriptCB_GetShellActive()

        if ScriptCB_GetPausingViewport() == 0 then
            --end
            ERROR_PROCESSING_FUNCTION = true
        end
    end,
    Input_Accept = function(Input_AcceptParam0)
        gShellScreen_fnDefaultInputAccept()
        if ifelm_shellscreen_fnPlaySound.CurButton(Input_AcceptParam0) == "unlock_hero_and_units" then
            UnlockHeroForTeam(1)
            UnlockHeroForTeam(2)
            uf_changeClassProperties(all_classes)
        elseif {{name = "PointsToUnlock", value = "0"}} == "nearly_unstoppable" then
            uf_changeObjectProperty("AddHealth", 2000, "human")
            uf_changeClassProperties(all_classes)
        elseif
            {
                {name = "JetFuelRechargeRate", value = "2000"},
                {name = "EnergyRestore", value = "2000"},
                {name = "EnergyRestoreIdle", value = "2000"}
            } == "jetpacks"
         then
            uf_changeClassProperties(non_jetpack_classes)
        elseif
            {
                {name = "AnimatedAddon", value = "jetpack_cheat"},
                {name = "GeometryAddon", value = "neu_addon_phaze1_pack"},
                {name = "AddonAttachJoint", value = "bone_ribcage"},
                {name = "JetEffect", value = "com_sfx_jet_cht"},
                {name = "ControlSpeed"},
                {name = "JetJump", value = "8.0"},
                {name = "JetPush", value = "8.0"},
                {name = "JetAcceleration", value = "20.0"},
                {name = "JetType", value = "hover"},
                {name = "JetFuelRechangeRate", value = "1"},
                {name = "JetFuelCost", value = "0.0"},
                {name = "JetFuelInitialCost", value = "0.0"},
                {name = "JetFuelMinBorder", value = "0.0"},
                {name = "CollisionScale"},
                {name = "EngineSound", value = "rep_inf_Jetpack_engine_parameterized"},
                {name = "TurnOnSound", value = "rep_weap_jetpack_turnon"},
                {name = "TurnOffSound", value = "rep_weap_jetpack_turnoff"},
                {name = "TurnOffTime", value = "0.0"}
            } == "reinforcements"
         then
            AddReinforcements(1, 50)
        elseif AddReinforcements.CurButton(2, 50) == "victory" then
        elseif MissionVictory.CurButton({1, 2}) == "enhanced_weapons" then
            ActivateBonus(1, "team_bonus_advanced_blasters")
        elseif ActivateBonus.CurButton(2, "team_bonus_advanced_blasters") == "extra_vehicles" then
        elseif SetHistorical.CurButton(1) == "no_ai_vehicles" then
        elseif ForceAIOutOfVehicles.CurButton(1) == "classic_flyers" then
        elseif ifs_pausemenu_fnUpdateFlyersText.CurButton({bClassic = nil}) == "restore_hud" then
        end
    end,
    Input_Back = function(Input_BackParam0)
        ScriptCB_PopScreen()
    end
}

all_classes = {
    "all_inf_engineer",
    "all_inf_engineer_fleet",
    "all_inf_engineer_jungle",
    "all_inf_engineer_snow",
    "all_inf_fleet_soldier",
    "all_inf_marine",
    "all_inf_officer",
    "all_inf_officer_jungle",
    "all_inf_officer_snow",
    "all_inf_pilot",
    "all_inf_rifleman",
    "all_inf_rifleman_desert",
    "all_inf_rifleman_fleet",
    "all_inf_rifleman_jungle",
    "all_inf_rifleman_snow",
    "all_inf_rifleman_urban",
    "all_inf_rocketeer",
    "all_inf_rocketeer_fleet",
    "all_inf_rocketeer_jungle",
    "all_inf_rocketeer_snow",
    "all_inf_sniper",
    "all_inf_sniper_fleet",
    "all_inf_sniper_jungle",
    "all_inf_sniper_snow",
    "all_inf_wookiee",
    "all_inf_wookiee_snow",
    "all_hero_luke_jedi",
    "all_hero_luke_pilot",
    "all_hero_luke_storm",
    "all_hero_hansolo_storm",
    "all_hero_hansolo_tat",
    "all_hero_leia",
    "all_hero_chewbacca",
    "all_inf_specialops",
    "cis_inf_droideka",
    "cis_inf_engineer",
    "cis_inf_marine",
    "cis_inf_officer",
    "cis_inf_officer_hunt",
    "cis_inf_pilot",
    "cis_inf_rifleman",
    "cis_inf_rocketeer",
    "cis_inf_sniper",
    "cis_hero_countdooku",
    "cis_hero_darthmaul",
    "cis_hero_grievous",
    "cis_hero_jangofett",
    "cis_inf_commando",
    "imp_inf_dark_trooper",
    "imp_inf_dark_trooper_hunt",
    "imp_inf_darthvader",
    "imp_inf_engineer",
    "imp_inf_engineer_snow",
    "imp_inf_marine",
    "imp_inf_officer",
    "imp_inf_officer_gray",
    "imp_inf_officer_hunt",
    "imp_inf_officer_snow",
    "imp_inf_pilot",
    "imp_inf_pilot_atat",
    "imp_inf_pilot_atst",
    "imp_inf_pilot_tie",
    "imp_inf_rifleman",
    "imp_inf_rifleman_desert",
    "imp_inf_rifleman_snow",
    "imp_inf_rocketeer",
    "imp_inf_rocketeer_snow",
    "imp_inf_sniper",
    "imp_inf_sniper_snow",
    "imp_hero_emperor",
    "imp_hero_darthvader",
    "imp_hero_bobafett",
    "imp_inf_commando",
    "rep_inf_ep2_engineer",
    "rep_inf_ep2_jettrooper",
    "rep_inf_ep2_jettrooper_rifleman",
    "rep_inf_ep2_jettrooper_sniper",
    "rep_inf_ep2_jettrooper_training",
    "rep_inf_ep2_marine",
    "rep_inf_ep2_officer",
    "rep_inf_ep2_officer_training",
    "rep_inf_ep2_pilot",
    "rep_inf_ep2_rifleman",
    "rep_inf_ep2_rocketeer",
    "rep_inf_ep2_rocketeer_chaingun",
    "rep_inf_ep2_sniper",
    "rep_inf_ep3_engineer",
    "rep_inf_ep3_jettrooper",
    "rep_inf_ep3_marine",
    "rep_inf_ep3_officer",
    "rep_inf_ep3_pilot",
    "rep_inf_ep3_rifleman",
    "rep_inf_ep3_rifleman_space",
    "rep_inf_ep3_rocketeer",
    "rep_inf_ep3_sniper",
    "rep_inf_ep3_sniper_felucia",
    "rep_inf_ep3_space_pilot",
    "rep_hero_obiwan",
    "rep_hero_anakin",
    "rep_hero_cloakedanakin",
    "rep_hero_macewindu",
    "rep_hero_yoda",
    "rep_hero_aalya",
    "rep_hero_kiyadimundi",
    "rep_inf_commando",
    "rvs_inf_rbasic",
    "rvs_inf_rheavy",
    "rvs_inf_rmelee",
    "rvs_inf_rsupport",
    "rvs_inf_rstealth",
    "rvs_inf_radept",
    "rvs_inf_rofficer",
    "rvs_inf_rdroid",
    "rvs_inf_jedi",
    "rvs_inf_jedi_master",
    "kor_hero_atton",
    "kor_hero_bastila",
    "kor_hero_carth",
    "kor_hero_hk47",
    "kor_hero_jolee",
    "kor_hero_mandalore",
    "kor_hero_mission",
    "kor_hero_vandar",
    "rvs_inf_sbasic",
    "rvs_inf_sheavy",
    "rvs_inf_smelee",
    "rvs_inf_ssupport",
    "rvs_inf_sstealth",
    "rvs_inf_sadept",
    "rvs_inf_sofficer",
    "rvs_inf_sdroid",
    "rvs_inf_sith",
    "rvs_inf_sith_lord",
    "kor_hero_malak",
    "kor_hero_nihilus",
    "kor_hero_revan",
    "kor_hero_sion",
    "kor_hero_traya",
    "tat_inf_jawa",
    "tat_inf_tuskenhunter",
    "tat_inf_tuskenraider",
    "ewk_inf_scout",
    "ewk_inf_repair",
    "ewk_inf_trooper",
    "gam_inf_gamorreanguard",
    "gar_inf_defender",
    "gar_inf_naboo_queen",
    "gar_inf_soldier",
    "gar_inf_temple_soldier",
    "gar_inf_temple_vanguard",
    "gar_inf_vanguard",
    "gen_inf_geonosian",
    "geo_inf_acklay",
    "geo_inf_agro_geonosian",
    "gun_inf_soldier",
    "gun_inf_rider",
    "gun_inf_defender",
    "jed_knight_01",
    "jed_knight_02",
    "jed_knight_03",
    "jed_knight_04",
    "jed_master_01",
    "jed_master_02",
    "jed_master_03",
    "jed_runner",
    "jed_sith_01",
    "snw_inf_wampa",
    "wok_inf_mechanic",
    "wok_inf_rocketeer",
    "wok_inf_warrior"
}
--[[    "tat_inf_jawa",
    "tat_inf_tuskenhunter",
    "tat_inf_tuskenraider",
    "ewk_inf_scout",
    "ewk_inf_repair",
    "ewk_inf_trooper",
    "gam_inf_gamorreanguard",
    "gar_inf_defender",
    "gar_inf_naboo_queen",
    "gar_inf_soldier",
    "gar_inf_temple_soldier",
    "gar_inf_temple_vanguard",
    "gar_inf_vanguard",
    "gen_inf_geonosian",
    "geo_inf_acklay",
    "geo_inf_agro_geonosian",
    "gun_inf_soldier",
    "gun_inf_rider",
    "gun_inf_defender",
    "jed_knight_01",
    "jed_knight_02",
    "jed_knight_03"
}--]]
non_jetpack_classes = {
    "all_inf_engineer",
    "all_inf_engineer_fleet",
    "all_inf_engineer_jungle",
    "all_inf_engineer_snow",
    "all_inf_fleet_soldier",
    "all_inf_marine",
    "all_inf_officer",
    "all_inf_officer_jungle",
    "all_inf_officer_snow",
    "all_inf_pilot",
    "all_inf_rifleman",
    "all_inf_rifleman_desert",
    "all_inf_rifleman_fleet",
    "all_inf_rifleman_jungle",
    "all_inf_rifleman_snow",
    "all_inf_rifleman_urban",
    "all_inf_rocketeer",
    "all_inf_rocketeer_fleet",
    "all_inf_rocketeer_jungle",
    "all_inf_rocketeer_snow",
    "all_inf_sniper",
    "all_inf_sniper_fleet",
    "all_inf_sniper_jungle",
    "all_inf_sniper_snow",
    "all_inf_wookiee",
    "all_inf_wookiee_snow",
    "all_inf_specialops",
    "cis_inf_droideka",
    "cis_inf_engineer",
    "cis_inf_marine",
    "cis_inf_officer",
    "cis_inf_officer_hunt",
    "cis_inf_pilot",
    "cis_inf_rifleman",
    "cis_inf_rocketeer",
    "cis_inf_sniper",
    "cis_inf_commando",
    "imp_inf_engineer",
    "imp_inf_engineer_snow",
    "imp_inf_marine",
    "imp_inf_officer",
    "imp_inf_officer_gray",
    "imp_inf_officer_hunt",
    "imp_inf_officer_snow",
    "imp_inf_pilot",
    "imp_inf_pilot_atat",
    "imp_inf_pilot_atst",
    "imp_inf_pilot_tie",
    "imp_inf_rifleman",
    "imp_inf_rifleman_desert",
    "imp_inf_rifleman_snow",
    "imp_inf_rocketeer",
    "imp_inf_rocketeer_snow",
    "imp_inf_sniper",
    "imp_inf_sniper_snow",
    "imp_inf_commando",
    "rep_inf_ep2_engineer",
    "rep_inf_ep2_marine",
    "rep_inf_ep2_officer",
    "rep_inf_ep2_officer_training",
    "rep_inf_ep2_pilot",
    "rep_inf_ep2_rifleman",
    "rep_inf_ep2_rocketeer",
    "rep_inf_ep2_rocketeer_chaingun",
    "rep_inf_ep2_sniper",
    "rep_inf_ep3_engineer",
    "rep_inf_ep3_marine",
    "rep_inf_ep3_officer",
    "rep_inf_ep3_pilot",
    "rep_inf_ep3_rifleman",
    "rep_inf_ep3_rifleman_space",
    "rep_inf_ep3_rocketeer",
    "rep_inf_ep3_sniper",
    "rep_inf_ep3_sniper_felucia",
    "rep_inf_ep3_space_pilot",
    "rep_inf_commando",
    "rvs_inf_rbasic",
    "rvs_inf_rheavy",
    "rvs_inf_rmelee",
    "rvs_inf_rsupport",
    "rvs_inf_rstealth",
    "rvs_inf_rofficer",
    "rvs_inf_sbasic",
    "rvs_inf_sheavy",
    "rvs_inf_smelee",
    "rvs_inf_ssupport",
    "rvs_inf_sstealth",
    "rvs_inf_sofficer"
}
--[[,
    "rep_inf_ep2_engineer",
    "rep_inf_ep2_marine",
    "rep_inf_ep2_officer",
    "rep_inf_ep2_officer_training",
    "rep_inf_ep2_pilot",
    "rep_inf_ep2_rifleman",
    "rep_inf_ep2_rocketeer",
    "rep_inf_ep2_rocketeer_chaingun"
}--]]
function uf_changeClassProperties(uf_changeClassPropertiesParam0, uf_changeClassPropertiesParam1)
    table.getn(uf_changeClassPropertiesParam0)
    table.getn(uf_changeClassPropertiesParam1)
    if FindEntityClass() == FindEntityClass("Zerted hopes no one names a class like this") then
    end
    SetClassProperty("Zerted hopes no one names a class like this", nil)
end

function uf_applyFunctionOnTeamUnits(
    uf_applyFunctionOnTeamUnitsParam0,
    uf_applyFunctionOnTeamUnitsParam1,
    uf_applyFunctionOnTeamUnitsParam2,
    uf_applyFunctionOnTeamUnitsParam3,
    uf_applyFunctionOnTeamUnitsParam4)
    if uf_applyFunctionOnTeamUnitsParam0 == nil then
    end
    table.getn({1, 2})
    GetTeamMember()
    IsCharacterHuman(GetTeamMember())
    GetCharacterUnit(GetTeamMember())(
        GetTeamMember(),
        GetCharacterUnit(),
        uf_applyFunctionOnTeamUnitsParam1,
        uf_applyFunctionOnTeamUnitsParam2
    )
end

function uf_changeObjectProperty(
    uf_changeObjectPropertyParam0,
    uf_changeObjectPropertyParam1,
    uf_changeObjectPropertyParam2)
end

function ifs_cheatmenu_fnBuildScreen(ifs_cheatmenu_fnBuildScreenParam0)
    ScriptCB_GetSafeScreenInfo()
    ScriptCB_GetShellActive()
    if gPlatformStr == "PC" then
    end
end

ifs_cheatmenu_fnBuildScreen(ifs_cheatmenu)
ifs_cheatmenu_fnBuildScreen = nil
AddIFScreen(ifs_cheatmenu, "ifs_cheatmenu")
ifs_cheatmenu = DoPostDelete(ifs_cheatmenu)

--[[function Enter(EnterParam0, EnterParam1)
    gIFShellScreenTemplate_fnEnter(EnterParam0, EnterParam1)
    ScriptCB_GetShellActive()
    if ScriptCB_GetPausingViewport() == 0 then
    end
    ERROR_PROCESSING_FUNCTION = true
end

function Input_Accept(Input_AcceptParam0)
    gShellScreen_fnDefaultInputAccept()
    if ifelm_shellscreen_fnPlaySound.CurButton(Input_AcceptParam0) == "unlock_hero_and_units" then
        UnlockHeroForTeam(1)
        UnlockHeroForTeam(2)
        uf_changeClassProperties(all_classes)
    elseif {{name = "PointsToUnlock", value = "0"}} == "nearly_unstoppable" then
        uf_changeObjectProperty("AddHealth", 2000, "human")
        uf_changeClassProperties(all_classes)
    elseif
        {
            {name = "JetFuelRechargeRate", value = "2000"},
            {name = "EnergyRestore", value = "2000"},
            {name = "EnergyRestoreIdle", value = "2000"}
        } == "jetpacks"
     then
        uf_changeClassProperties(non_jetpack_classes)
    elseif
        {
            {name = "AnimatedAddon", value = "jetpack_cheat"},
            {name = "GeometryAddon", value = "neu_addon_phaze1_pack"},
            {name = "AddonAttachJoint", value = "bone_ribcage"},
            {name = "JetEffect", value = "com_sfx_jet_cht"},
            {name = "ControlSpeed"},
            {name = "JetJump", value = "8.0"},
            {name = "JetPush", value = "8.0"},
            {name = "JetAcceleration", value = "20.0"},
            {name = "JetType", value = "hover"},
            {name = "JetFuelRechangeRate", value = "1"},
            {name = "JetFuelCost", value = "0.0"},
            {name = "JetFuelInitialCost", value = "0.0"},
            {name = "JetFuelMinBorder", value = "0.0"},
            {name = "CollisionScale"},
            {name = "EngineSound", value = "rep_inf_Jetpack_engine_parameterized"},
            {name = "TurnOnSound", value = "rep_weap_jetpack_turnon"},
            {name = "TurnOffSound", value = "rep_weap_jetpack_turnoff"},
            {name = "TurnOffTime", value = "0.0"}
        } == "reinforcements"
     then
        AddReinforcements(1, 50)
    elseif AddReinforcements.CurButton(2, 50) == "victory" then
    elseif MissionVictory.CurButton({1, 2}) == "enhanced_weapons" then
        ActivateBonus(1, "team_bonus_advanced_blasters")
    elseif ActivateBonus.CurButton(2, "team_bonus_advanced_blasters") == "extra_vehicles" then
    elseif SetHistorical.CurButton(1) == "no_ai_vehicles" then
    elseif ForceAIOutOfVehicles.CurButton(1) == "classic_flyers" then
    elseif ifs_pausemenu_fnUpdateFlyersText.CurButton({bClassic = nil}) == "restore_hud" then
    end
end--]]
--[[function Input_Back(Input_BackParam0)
    ScriptCB_PopScreen()
end

function uf_applyFunctionOnTeamUnits(
    uf_applyFunctionOnTeamUnitsParam0,
    uf_applyFunctionOnTeamUnitsParam1,
    uf_applyFunctionOnTeamUnitsParam2,
    uf_applyFunctionOnTeamUnitsParam3)
    ERROR_PROCESSING_FUNCTION = true
end--]]
