-- ifs_freeform_init_common.lua - zerted patch 1.3
-- verified by cbadal
-- set up controller teams
ifs_freeform_controllers = function(this, teamList)
    print("ifs_freeform_init_common: ifs_freeform_controllers()")

    this.startController = nil
    this.controllerTeam = {}
    this.controllerPlayer = {}
    local controllers = ScriptCB_GetMaxControllers()
    local players = 0
    for controller = 0, controllers - 1 do
        if ScriptCB_IsControllerBound(controller + 1) then
            this.startController = this.startController or controller
            this.controllerTeam[controller] = teamList[controller]
            this.controllerPlayer[controller] = players
            players = players + 1
        end
    end

    -- select the representative controller for each team
    this.teamController = {}
    if this.soakMode then
        return
    end
    for controller, team in pairs(this.controllerTeam) do
        if this.teamController[team] then
            this.teamController[team] = math.min(this.teamController[team], controller)
        else
            this.teamController[team] = controller
        end
    end

    -- secondary controller takes charge
    local secondary = ScriptCB_GetSecondaryController()
    if secondary then
        this.teamController[this.controllerTeam[secondary]] = secondary
    end

    -- primary controller takes charge
    local primary = ScriptCB_GetPrimaryController()
    if primary then
        this.teamController[this.controllerTeam[primary]] = primary
        this.startController = primary
    end
end

-- common initialization
ifs_freeform_init_common = function(this)
    print("ifs_freeform_init_common: ifs_freeform_init_common()")

    -- per-planet camera offsets
    this.cameraOffset = {
        ["cor"] = {0, 1, 1},
        ["dag"] = {0, 1, 1},
        ["end"] = {0, 1, 1},
        ["fel"] = {0, 1, 1},
        ["geo"] = {0, 1, 1},
        ["hot"] = {0, 1, 1},
        ["kas"] = {0, 1, 1},
        ["kam"] = {0, 1, 1},
        ["mus"] = {0, 1, 1},
        ["myg"] = {0, 1, 1},
        ["nab"] = {0, 1, 1},
        ["neb"] = {0, 1, 1},
        ["pol"] = {0, 1, 1},
        ["tat"] = {0, 1, 1},
        ["uta"] = {0, 1, 1},
        ["yav"] = {0, 1, 1}
    }
end

-- common start
ifs_freeform_start_common = function(this)
    print("ifs_freeform_init_common: ifs_freeform_start_common()")

    -- initialize turn counter
    this.turnNumber = 1

    -- create team resources (high now for debug)
    this.teamResources = {
        [1] = 100,
        [2] = 100
    }

    -- create team items
    this.teamItems = {
        [1] = {soldier = true, pilot = true},
        [2] = {soldier = true, pilot = true}
    }

    -- no victory yet
    this.teamVictory = nil

    -- clear out any saved state
    ScriptCB_ClearMetagameState()
    ScriptCB_ClearCampaignState()
    ScriptCB_ClearMissionSetup()
    ScriptCB_SetLastBattleVictoryValid(nil)
end
