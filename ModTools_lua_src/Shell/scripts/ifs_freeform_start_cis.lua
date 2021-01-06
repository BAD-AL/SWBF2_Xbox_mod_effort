-- start CIS campaign
function ifs_freeform_start_cis(this)

	-- save scenario type
	this.scenario = "cis"
	
	-- assigned teams
	local REP = 1
	local CIS = 2
	
	-- CW init
	ifs_freeform_init_cw(this, REP, CIS)

	-- set to versus play
	ifs_freeform_controllers(this, { [0] = CIS, [1] = CIS, [2] = CIS, [3] = CIS })
	
	-- CIS start
	this.Start = function(this)
		-- perform common start
		ifs_freeform_start_common(this)

		-- set team for each planet
		this.planetTeam = {
			["cor"] = REP,
			["dag"] = REP,
			["fel"] = REP,
			["geo"] = CIS,
			["kam"] = REP,
			["kas"] = REP,
			["mus"] = CIS,
			["myg"] = REP,
			["nab"] = REP,
			["pol"] = REP,
			["tat"] = REP,
			["uta"] = CIS,
			["yav"] = REP,
   		}
		
		
		-- create starting fleets for each team
		this.planetFleet = {}
		for team, start in pairs(this.planetStart) do
			local planet = start[math.random(table.getn(start))]
			this.planetFleet[planet] = team
		end
	end
end
