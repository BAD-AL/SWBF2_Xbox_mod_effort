function SetupTeams(sides)
    -- HACKish: load the turret .odf here (this is the easiest place to put it where it will
    --          be executed in every level
    --ReadDataFile("SIDE\\tur.lvl",                     --disabled for now until we settle on where exactly the .odf will end up
    --              "tur_bldg_defensegridturret")

    -- list of types
    local typeList = { "soldier", "pilot", "assault", "sniper", "marine", "engineer", "officer", "special" }

    -- items for each team code
    local teamItems = nil
    if ScriptCB_IsMissionSetupSaved() then
		local missionSetup = ScriptCB_LoadMissionSetup()
        teamItems = missionSetup.units
    end
    
    -- for each specified side...
    for name, side in pairs(sides) do
        local team = side.team

        -- set team properties
        local name = string.lower(name)
        SetTeamName(team, name)
        SetTeamIcon(team, name .. "_icon", "hud_reinforcement_icon", "flag_icon")
        SetUnitCount(team, side.units)
        SetReinforcementCount(team, side.reinforcements)

        -- add unit classes in type order
        for _, type in ipairs(typeList) do
            if side[type] and (not teamItems or not teamItems[name] or teamItems[name][type]) then
                AddUnitClass(team, side[type][1], side[type][2], side[type][3])
            end
        end

        -- add hero class if available
        if side[hero] then
            AddHeroClass(side[hero])
        end
    end
end
