-- start REP campaign
function ifs_freeform_start_rep(this)

	-- save scenario type
	this.scenario = "rep"
	
	-- assigned teams
	local REP = 1
	local CIS = 2
	
	-- CW init
	ifs_freeform_init_cw(this, REP, CIS)
	
	-- set to co-op play
	ifs_freeform_controllers(this, { [0] = REP, [1] = REP, [2] = REP, [3] = REP })

	-- REP start
	this.Start = function(this)
		-- perform common start
		ifs_freeform_start_common(this)

		-- set team for each planet
		this.planetTeam = {
			["cor"] = REP,
			["dag"] = CIS,
			["fel"] = CIS,
			["geo"] = CIS,
			["kam"] = REP,
			["kas"] = CIS,
			["mus"] = CIS,
			["myg"] = CIS,
			["nab"] = REP,
			["pol"] = CIS,
			["tat"] = CIS,
			["uta"] = CIS,
			["yav"] = CIS,
   		}
		
		
		-- create starting fleets for each team
		this.planetFleet = {}
		for team, start in pairs(this.planetStart) do
			local planet = start[math.random(table.getn(start))]
			this.planetFleet[planet] = team
		end
	end
end
