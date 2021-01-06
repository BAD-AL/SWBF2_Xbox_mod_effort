function ifs_freeform_start_custom(this, prefs)

	-- save scenario type
	this.scenario = "custom"
	
	-- custom init
	ifs_freeform_init_custom(this, prefs)
	
	-- set to versus play
	ifs_freeform_controllers(this, { [0] = 1, [1] = 2, [2] = 1, [3] = 2 })

	this.Start = function(this)
		-- perform common start
		ifs_freeform_start_common(this)

		-- apply layout
		if prefs.bRandomLayout then
			-- assign forced planets
			this.planetTeam = {}
			for team, start in pairs(this.planetStart) do
				for _, planet in ipairs(start) do
					this.planetTeam[planet] = team
				end
			end
		
			-- get remaining planets
			local planetList = {}
			for planet, _ in pairs(this.planetDestination) do
				if string.len(planet) == 3 and not this.planetTeam[planet] then
					table.insert(planetList, planet)
				end
			end
			
			-- permute the list
			local n = table.getn(planetList)
			for i=1,100 do
				local p1 = math.random(n)
				local p2 = math.random(n)
				local t = planetList[p1]
				planetList[p1] = planetList[p2]
				planetList[p2] = t
			end
			
			-- assign planet teams
			for i=1,n do
				this.planetTeam[planetList[i]] = math.ceil(i * 2 / n)
			end
		elseif prefs.iEra == 1 then
			-- set team for each planet
			this.planetTeam = {
				["cor"] = 1,
				["dag"] = 1,
				["fel"] = 2,
				["geo"] = 2,
				["kam"] = 1,
				["kas"] = 1,
				["mus"] = 2,
				["myg"] = 2,
				["nab"] = 1,
				["pol"] = 1,
				["tat"] = 1,
				["uta"] = 2,
				["yav"] = 2,
   			}
		elseif prefs.iEra == 2 then
	   		-- set team for each planet
   			this.planetTeam = {
				["cor"] = 2,
				["dag"] = 1,
				["end"] = 2,
				["fel"] = 1,
				["hot"] = 1,
				["kas"] = 1,
				["mus"] = 2,
				["myg"] = 2,
				["nab"] = 1,
				["pol"] = 1,
				["tat"] = 2,
				["uta"] = 2,
				["yav"] = 1,
			}
		end
		
		-- create starting fleets for each team
		this.planetFleet = {}
--		for team, start in pairs(this.planetStart) do
--			local planet = start[math.random(table.getn(start))]
--			this.planetFleet[planet] = team
--		end
	end
end