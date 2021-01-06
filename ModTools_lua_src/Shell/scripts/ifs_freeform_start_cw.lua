-- start balanced clone wars
function ifs_freeform_start_cw(this)

	-- save scenario type
	this.scenario = "cw"
	
	-- assigned teams
	local REP = 1
	local CIS = 2
	
	-- CW init
	ifs_freeform_init_cw(this, REP, CIS)

	-- set to versus play
	ifs_freeform_controllers(this, { [0] = REP, [1] = CIS, [2] = REP, [3] = CIS })

	-- balanced CW start
	this.Start = function(this)
		-- perform common start
		ifs_freeform_start_common(this)

		-- set team for each planet
		this.planetTeam = {
			["cor"] = REP,
			["dag"] = REP,
			["fel"] = CIS,
			["geo"] = CIS,
			["kam"] = REP,
			["kas"] = REP,
			["mus"] = CIS,
			["myg"] = CIS,
			["nab"] = REP,
			["pol"] = REP,
			["tat"] = REP,
			["uta"] = CIS,
			["yav"] = CIS,
   		}
		
--		-- create starting starports for each team
--		this.planetPort = {
--			["kam"] = REP,
--			["geo"] = CIS,
--		}
		
		-- create starting fleets for each team
		this.planetFleet = {
			["kam"] = REP,
			["geo"] = CIS,
		}
	end
end
