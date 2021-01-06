--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_freeform_ai = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1,
	
	-- tuning parameters
	autoaccept = true,
	showvalues = false,
	turncount = 5,
--	portscore = 40,
	fleetscore = 15,
	enemyvaluescale = 0.5,
	threatscale = 0.5,
	aggression = 1.0,
	
	-- display time
	displayTime = 0,
	
	-- initialize
	Init = function(this)
		-- create planet value and weight scale tables
		this.planetValue = {}
		this.defenseValue = {}
		this.weightScale = {}
		for planet, _ in pairs(ifs_freeform_main.planetDestination) do
			this.planetValue[planet] = 0
			this.defenseValue[planet] = { [false] = 0, [true] = 0 }
			this.weightScale[planet] = this.SpreadWeightFromPlanet(planet, 1)
		end
	end,
	
	-- calculate weights for each planet
	CalculateWeights = function(this, myteam)
		-- clear out planet weights
		for planet, _ in pairs(ifs_freeform_main.planetDestination) do
			this.planetValue[planet] = 0
			this.defenseValue[planet] = { [false] = 0, [true] = 0 }
		end
		
		-- for each planet...
		for planet, team in pairs(ifs_freeform_main.planetTeam) do
			local weight = 0
			local defense = false
			
			-- if the planet is not neutral...
			if team > 0 then
				-- use defense value if mine
				defense = team == myteam
				
				-- get odds of planet victory
				-- (should calculate based on purchases)
				local planetwin = 0.5
				
				-- get planet value
				local value = ifs_freeform_main.planetValue[planet]
				
				-- win gets:
				-- planet victory value
				-- intrinsic value of the planet
				-- scaled value of any port
				local winvalue = value.victory + value.turn * this.turncount
--				if ifs_freeform_main.planetPort[planet] then
--					winvalue = winvalue + this.portscore * this.enemyvaluescale
--				end
				
				-- lose gets:
				-- planet defeat value
				-- negative value of my fleet
				local losevalue = value.defeat - this.fleetscore
				
				-- calculate conditional value
				weight = planetwin * winvalue + (1 - planetwin) * losevalue
			end
			
			-- if the planet has a fleet...
			fleet = ifs_freeform_main.planetFleet[planet]
			if fleet then
				-- use defense value if mine
				defense = fleet == myteam

				-- get odds of fleet victory
				-- (should calculate based on purchases)
				local fleetwin = 0.5
				
				-- get space value
				local value = ifs_freeform_main.spaceValue
				
				-- win gets:
				-- space victory value
				-- scaled value of enemy fleet
				-- underlying planet value
				local winvalue = value.victory + this.fleetscore * this.enemyvaluescale + weight
				
				-- lose gets:
				-- space defeat value
				-- negative value of my fleet
				local losevalue = value.defeat - this.fleetscore
				
				-- calculate conditional value
				weight = fleetwin * winvalue + (1 - fleetwin) * losevalue
			end

			-- scale weight by battle recency
			for i, p in ipairs(ifs_freeform_main.recentPlanets) do
				if p == planet then
					weight = weight * math.pow(2, i-4)		-- 1/8, 1/4, 1/2
					break
				end
			end
			
			-- if the planet is worth anything...
			if weight > 0 then
				-- spread weight around
				for p, scale in pairs(this.weightScale[planet]) do
					this.defenseValue[p][defense] = this.defenseValue[p][defense] + weight * scale
				end
			end
		end
		
		-- for each fleet...
		local fleetThreat = { }
		for planet, fleet in pairs(ifs_freeform_main.planetFleet) do
			-- use defense value if mine
			local defense = fleet == myteam
			
			-- calculate threat value
			-- (use the offensive value the fleet sees at that location)
			local threat = this.threatscale * this.defenseValue[planet][not defense]
			
			-- save fleet threat
			fleetThreat[planet] = { defense, threat }
		end
		
		-- for each fleet threat...
		for planet, values in pairs(fleetThreat) do
			local defense = values[1]
			local threat = values[2]
			
			-- spread weight around
			for p, scale in pairs(this.weightScale[planet]) do
				this.defenseValue[p][defense] = this.defenseValue[p][defense] + threat * scale
			end
		end
		
		-- create combined value
		for planet, value in pairs(this.defenseValue) do
			this.planetValue[planet] = value[false] * this.aggression + value[true] * (1-this.aggression)
		end
	end,

	-- spread weight out from the specified planet	
	SpreadWeightFromPlanet = function(startplanet, startweight)
		local closed = {}
		local queue = {}
		table.insert(queue, { startplanet, startweight })

		repeat
			local next = table.remove(queue, 1)
			local planet = next[1]
			local weight = next[2]
			if not closed[planet] or weight > closed[planet] then
				closed[planet] = weight
				weight = weight / 2
				for _, destination in ipairs(ifs_freeform_main.planetDestination[planet]) do
					if not closed[destination] or weight > closed[destination] then
						table.insert(queue, { destination, weight })
					end
				end
			end
		until table.getn(queue) == 0
		
		return closed
	end,
	
	-- draw AI weights for all planets
	DrawPlanetWeights = function(this, selected)
		local reference = this.planetValue[selected]
		-- draw planet weights
		for planet, team in pairs(ifs_freeform_main.planetTeam) do
			local matrix = ifs_freeform_main.planetMatrix[planet][0]
			local value = this.planetValue[planet]
			Print3D(matrix, math.ceil(value).."|"..math.ceil(value-reference))
		end
	end,

	-- purchase unit	
	PurchaseUnit = function(this, team, unit)
		print ("purchase unit:", unit)
		ifs_purchase_unit_owned[team][unit] = true
		ifs_freeform_main:SpendResources(team, ifs_purchase_unit_cost[unit])
	end,
	
	-- purchase tech
	PurchaseTech = function(this, team, index)
		print ("purchase tech:", ifs_purchase_tech_table[index].name)
		-- get whether the tech is owned
		local owned = ifs_purchase_tech_cards[team][index]
		if not owned then
			print ("owned")
			ifs_purchase_tech_cards[team][index] = true
		else
			for slot, using in ipairs(ifs_purchase_tech_using[team]) do
				if using == 0 then
					print ("using", slot)
					ifs_purchase_tech_using[team][slot] = index
					break
				end
			end
		end
		ifs_freeform_main:SpendResources(team, ifs_purchase_tech_table[index].cost[owned])
	end,
	
	-- determine which item to buy
	CalculatePurchaseItem = function(this, fDt)
		-- default to calculate build fleet
		this.displayTime = -1
		this.Update = this.CalculateBuildFleet

		-- get my team
		local myteam = ifs_freeform_main.playerTeam

		-- selection table
		local totalWeight = 0
		local itemWeight = {}
		
		local funds = ifs_freeform_main.teamResources[myteam]
		print("funds:", funds)
		
		print("purchase unit/tech?")
		
		-- count value of opponent's units
		local enemy_units = 100		-- bias
		for unit, owned in pairs(ifs_purchase_unit_owned[3-myteam]) do
			if owned then
				print ("opponent unit", unit, ifs_purchase_unit_cost[unit])
				enemy_units = enemy_units + ifs_purchase_unit_cost[unit]
			end
		end
		print ("unit scale", enemy_units)
		
		-- for each potential unit...
		for _, unit in ipairs(ifs_purchase_unit_types) do
			-- if not already owned...
			if not ifs_purchase_unit_owned[myteam][unit] and ifs_purchase_unit_cost[unit] <= funds then
				-- add to the list
				local weight = enemy_units / ifs_purchase_unit_cost[unit]
				local unit = unit		--fix closure
				print ("unit weight", unit, weight)
				itemWeight[function() this:PurchaseUnit(myteam, unit) end] = weight
				totalWeight = totalWeight + weight
			end
		end
		
		-- check if using slots are free
		local using_free = false
		for slot, using in ipairs(ifs_purchase_tech_using[myteam]) do
			if using == 0 then
				using_free = true
				break
			end
		end
	
		-- if there are free slots...
		if using_free then
			-- count value of opponent's tech
			local enemy_tech = 40		-- bias
			for _, using in pairs(ifs_purchase_tech_using[3-myteam]) do
				if using > 0 then
					local tech = ifs_purchase_tech_table[using]
					print ("opponent tech", tech.name, tech.cost[true])
					enemy_tech = enemy_tech + tech.cost[true]
				end
			end
			print ("tech scale", enemy_tech)
					
			-- for each potential tech...
			local totalWeight = 0
			local techWeight = {}
			for index, tech in ipairs(ifs_purchase_tech_table) do
				-- get whether the tech is owned
				local owned = ifs_purchase_tech_cards[myteam][index]
				
				if tech.cost[owned] <= funds then
					-- add to the list
					local weight = enemy_tech / tech.cost[owned]
					local index = index		-- fix closure
					print ("tech weight", tech.name, weight)
					itemWeight[function() this:PurchaseTech(myteam, index) end] = weight
					totalWeight = totalWeight + weight
				end
			end
		end
		
		-- pick an item
		local randomWeight = math.random() * totalWeight
		print ("scaled weight:", totalWeight, randomWeight)
		for item, weight in pairs(itemWeight) do
			randomWeight = randomWeight - weight
			if randomWeight <= 0 then
				item()
				break
			end
		end
		
		-- perform visible update
		this:Update(fDt)
	end,
	
	-- determine if and where to build a port
--	CalculateBuildPort = function(this, fDt)
--		-- default to calculate build fleet
--		this.displayTime = -1
--		this.Update = this.CalculateBuildFleet
--		
--		-- get my team
--		local myteam = ifs_freeform_main.playerTeam
--		
--		-- update port cost
--		ifs_freeform_fleet:UpdatePortCost()
--		
--		-- if there is enough resources to build a port...	
--		local funds = ifs_freeform_main.teamResources[myteam]
--		local cost = ifs_freeform_fleet.portCost
--		print("funds:", funds, "port cost:", cost)
--		if cost and funds >= cost then
--			print("purchase port?")
--			
--			-- create baseline value for my non-port planets
--			local portWeight = {}
--			for planet, team in pairs(ifs_freeform_main.planetTeam) do
--				if team == myteam and not ifs_freeform_main.planetPort[planet] then
--					portWeight[planet] = 1
--				end
--			end
--			
--			-- for each port in the galaxy...
--			for planet, port in pairs(ifs_freeform_main.planetPort) do
--				-- decrease weight for friendly ports, increase for enemy ports
--				local weight = port == myteam and -1 or 1
--				-- spread weight around
--				for p, scale in pairs(this.weightScale[planet]) do
--					if portWeight[p] then
--						portWeight[p] = portWeight[p] + weight * scale
--					end
--				end
--			end
--			
--			-- for each potential location...
--			local totalWeight = 0
--			for planet, weight in pairs(portWeight) do
--				-- scale by planet value
--				portWeight[planet] = portWeight[planet] * this.planetValue[planet]
--				print ("planet weight", planet, weight, portWeight[planet])
--				totalWeight = totalWeight + portWeight[planet]
--			end
--			print ("total weight:", totalWeight)
--			
--			-- pick a location
--			local scaledWeight = totalWeight + (cost - ifs_freeform_port_cost[0]) * cost / funds
--			local randomWeight = math.random() * scaledWeight
--			print ("scaled weight:", scaledWeight, randomWeight)
--			for planet, weight in pairs(portWeight) do
--				randomWeight = randomWeight - weight
--				if randomWeight <= 0 then
--					print ("purchase port:", planet)
--					ifs_freeform_main:SelectPlanet(nil, planet)
--					this.displayTime = 2.0
--					this.Update = this.UpdateBuildPort
--					break
--				end
--			end
--		end
--		
--		-- perform visible update
--		this:Update(fDt)
--	end,
	
--	-- update build port
--	UpdateBuildPort = function(this, fDt)
--		-- get my team
--		local myteam = ifs_freeform_main.playerTeam
--		
--		-- get the selected planet
--		local selected = ifs_freeform_main.planetSelected
--		
--		-- if the display time elapses...
--		this.displayTime = this.displayTime - fDt
--		if this.displayTime <= 0 then
--			-- if there is a port...
--			if ifs_freeform_main.planetPort[selected] then
--				-- go to calculate build fleet
--				this.Update = this.CalculateBuildFleet
--			else
--				-- build the port and show it
--				ifs_freeform_fleet:BuildPort(myteam, selected)
--				this.displayTime = 1.0
--			end
--		end
--		
--		if not ifs_freeform_main.planetPort[selected] then
--			ifs_freeform_main:DrawPortIcon(selected, myteam, true, true)
--		end
--		
--		-- for each starting planet...
--		for planet1, destinations in pairs(ifs_freeform_main.planetDestination) do
--			-- for each potential destination...
--			for _, planet2 in ipairs(destinations) do
--				if planet1 < planet2 then
--					-- draw a white link
--					DrawBeamBetween(
--						ifs_freeform_main.planetMatrix[planet1][0],
--						ifs_freeform_main.planetMatrix[planet2][0],
--						"lane_selected", 1.0, 255, 255, 255, 32
--						)
--				end
--			end
--		end
--		
--		-- call common update
--		this:UpdateCommon(fDt)
--	end,
	
	-- determine if and where to build a fleet
	CalculateBuildFleet = function(this, fDt)
		-- default to calculate move fleet
		this.displayTime = -1
		this.Update = this.CalculateMoveFleet
		
		-- get my team
		local myteam = ifs_freeform_main.playerTeam
		
		-- update fleet cost
		ifs_freeform_fleet:UpdateFleetCost()
		
		-- if there is enough resources to build a fleet...	
		local funds = ifs_freeform_main.teamResources[myteam]
		local cost = ifs_freeform_fleet.fleetCost
		print("funds:", funds, "fleet cost:", cost)
		if cost and funds >= cost then
			print("purchase fleet?")
			
			-- create baseline value for my non-fleet planets
			local fleetWeight = {}
			for planet, team in pairs(ifs_freeform_main.planetTeam) do
				if team == myteam and not ifs_freeform_main.planetFleet[planet] then
					fleetWeight[planet] = 1
				end
			end
			
			-- for each fleet in the galaxy...
			for planet, fleet in pairs(ifs_freeform_main.planetFleet) do
				-- decrease weight for friendly fleets, increase for enemy fleets
				local weight = fleet == myteam and -1 or 1
				-- spread weight around
				for p, scale in pairs(this.weightScale[planet]) do
					if fleetWeight[p] then
						fleetWeight[p] = fleetWeight[p] + weight * scale
					end
				end
			end
			
			-- for each potential location...
			local totalWeight = 0
			for planet, weight in pairs(fleetWeight) do
				-- scale by planet value
				fleetWeight[planet] = math.pow(2, 0.2 * this.planetValue[planet] + 2 * fleetWeight[planet])
				print ("planet weight", planet, weight, fleetWeight[planet])
				totalWeight = totalWeight + fleetWeight[planet]
			end
			print ("total weight:", totalWeight)
			
			-- pick a location
			local scaledWeight = cost == 0 and totalWeight or totalWeight * funds / (funds - cost * 0.75)	--+ (cost - ifs_freeform_fleet_cost[0]) * cost / funds
			local randomWeight = math.random() * scaledWeight
			print ("scaled weight:", scaledWeight, randomWeight)
			for planet, weight in pairs(fleetWeight) do
				randomWeight = randomWeight - weight
				if randomWeight <= 0 then
					print ("purchase fleet:", planet)
					
					-- go to update build port
					ifs_freeform_main:SelectPlanet(nil, planet)
					this.displayTime = 2.0
					this.Update = this.UpdateBuildFleet
					break
				end
			end
		end
		
		-- perform visible update
		this:Update(fDt)
	end,
	
	-- update build fleet
	UpdateBuildFleet = function(this, fDt)
		-- get my team
		local myteam = ifs_freeform_main.playerTeam
		
		-- get the selected planet
		local selected = ifs_freeform_main.planetSelected
		
		-- if the display time elapses...
		this.displayTime = this.displayTime - fDt
		if this.displayTime <= 0 then
			-- if there is a fleet...
			if ifs_freeform_main.planetFleet[selected] then
				-- go to calculate move fleet
				this.Update = this.CalculateMoveFleet
			else
				-- build the fleet and show it
				ifs_freeform_fleet:BuildFleet(myteam, selected)
				this.displayTime = 1.0
			end
		end
		
		if not ifs_freeform_main.planetFleet[selected] then
			ifs_freeform_main:DrawFleetIcon(selected, myteam, true, true)
		end
		
		-- for each starting planet...
		for planet1, destinations in pairs(ifs_freeform_main.planetDestination) do
			-- for each potential destination...
			for _, planet2 in ipairs(destinations) do
				if planet1 < planet2 then
					-- draw a white link
					DrawBeamBetween(
						ifs_freeform_main.planetMatrix[planet1][0],
						ifs_freeform_main.planetMatrix[planet2][0],
						"lane_selected", 1.0, 255, 255, 255, 32
						)
				end
			end
		end
		
		-- call common update
		this:UpdateCommon(fDt)
	end,
	
	-- pick a fleet movement
	CalculateMoveFleet = function(this, fDt)
		-- default to done
		this.displayTime = -1
		this.Update = this.UpdateDone
		
		-- get my team
		local myteam = ifs_freeform_main.playerTeam
		
		-- get weighted move values
		local moveWeight = {}
		local totalWeight = 0
		for planet, team in pairs(ifs_freeform_main.planetFleet) do
			if team == myteam then
				local reference = this.planetValue[planet]
				for _, destination in ipairs(ifs_freeform_main.planetDestination[planet]) do
					if ifs_freeform_main.planetFleet[destination] ~= myteam then
						local weight = math.pow(2, 0.2 * (this.planetValue[destination] - reference))
						moveWeight[{planet, destination}] = weight
						print(planet, destination, weight)
						totalWeight = totalWeight + weight
					end
				end
			end
		end
		
		-- get a random move
		local randomWeight = math.random() * totalWeight
		
		-- for each possible move...
		for move, weight in pairs(moveWeight) do
			-- deduct the move's weight
			randomWeight = randomWeight - weight
			
			-- if this move is the selected one...
			if randomWeight <= 0 then
				-- get the start and next planets
				local start = move[1]
				local next = move[2]
				
				-- select the start planet
				ifs_freeform_main:SelectPlanet(nil, start)
				
				-- aim towards the next planet
				ifs_freeform_main.planetNext = next
				
				-- go to update move fleet
				this.displayTime = 2.0
				this.Update = this.UpdateMoveFleet
				break
			end
		end
		
		-- perform visible updtae
		this:Update(fDt)
	end,
	
	UpdateMoveFleet = function(this, fDt)
		-- get the start and next planet
		local start = ifs_freeform_main.planetSelected
		local next = ifs_freeform_main.planetNext
		
		-- for each starting planet...
		local playerTeam = ifs_freeform_main.playerTeam
		local enemyTeam = 3 - playerTeam
		for planet1, destinations in pairs(ifs_freeform_main.planetDestination) do
			-- for each potential destination...
			for _, planet2 in ipairs(destinations) do
				if planet1 < planet2 then
--					-- get the link team
--					local planet1Team = ifs_freeform_main.planetFleet[planet1] or ifs_freeform_main.planetTeam[planet1]
--					local planet2Team = ifs_freeform_main.planetFleet[planet2] or ifs_freeform_main.planetTeam[planet2]
--					local linkTeam
--					if planet1Team == planet2Team then
--						linkTeam = planet1Team
--					elseif planet1Team == enemyTeam or planet2Team == enemyTeam then
--						linkTeam = enemyTeam
--					else
--						linkTeam = 0
--					end
					-- color the lane based on the link team
--					local r,g,b = ifs_freeform_main:GetTeamColor(linkTeam)
					local a = 200
					local shift = 0
					local repetitions = 1
					if planet1 ~= start and planet2 ~= start then
						a = 32
					elseif next ~= start and (planet1 == next or planet2 == next) then
						a = 255
						if planet1 == next then
							shift = 2 * ScriptCB_GetMissionTime()
						else
							shift = -2 * ScriptCB_GetMissionTime()
						end
						repetitions = 8
					end
					DrawBeamBetween(
						ifs_freeform_main.planetMatrix[planet1][0],
						ifs_freeform_main.planetMatrix[planet2][0],
						"lane_selected", 1.0, 255, 255, 255, a, shift, repetitions
						)
				end
			end
		end
		
		this.displayTime = this.displayTime - fDt
		if this.displayTime <= 0 then
			if start ~= next then
				-- move the fleet
				ifs_freeform_main:MoveFleet(playerTeam, start, next)
				ifs_freeform_main:SelectPlanet(nil, next)

				-- show the result			
				if this.autoaccept then
					this.displayTime = 1.0
				else
					this.displayTime = 1e38
				end
			else
				-- if the destination planet is an enemy, or there is a fleet battle...
				if ifs_freeform_main.planetTeam[next] == enemyTeam or
					ifs_freeform_main.planetFleet[next] == 0 then
				
					-- jump to the battle screen
					ScriptCB_PushScreen("ifs_freeform_battle")
				else
					-- jump to the summary page
					ScriptCB_PushScreen("ifs_freeform_summary")
				end
			end
		else
			if start ~= next then
				ifs_freeform_main:DrawFleetIcon(next, playerTeam, true, true)
			end
		end
		
		-- call common update
		this:UpdateCommon(fDt)
	end,
	
	UpdateDone = function(this, fDt)
		-- go to the summary page
		ScriptCB_PushScreen("ifs_freeform_summary")
	end,
	
	-- play an AI turn
	Enter = function(this, bFwd)
		-- get the ai team
		local myteam = ifs_freeform_main.playerTeam
		print("AI turn", ifs_freeform_main.turnNumber)

		-- calculate planet weights
		this:CalculateWeights(myteam)
	
		-- start with purchase item update
		this.Update = this.CalculatePurchaseItem
		
		-- set the camera zoom
		ifs_freeform_main:SetZoom(1)
	end,
	
	Exit = function(this, bFwd)
	end,
	
	Input_Accept = function(this, joystick)
		this.displayTime = 0.0
	end,

	Input_Back = function(this, joystick)
	end,
	
	UpdateCommon = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt) -- call base class
	
		-- get my team
		local myteam = ifs_freeform_main.playerTeam
		
		-- update zoom values
		ifs_freeform_main:UpdateZoom()
		
		-- draw planet icons
		ifs_freeform_main:DrawPlanetIcons()
		
		-- draw port icons
		ifs_freeform_main:DrawPortIcons(myteam)
		
		-- draw fleet icons
		ifs_freeform_main:DrawFleetIcons(ifs_freeform_main.planetSelected, myteam)
		
		-- draw planet weights (debug)
		if this.showvalues then
			this:DrawPlanetWeights(ifs_freeform_main.planetSelected)
		end
	end,
}

AddIFScreen(ifs_freeform_ai,"ifs_freeform_ai")
