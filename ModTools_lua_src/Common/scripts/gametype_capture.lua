--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

CaptureObjective = 
{
	-- external values
	team = 0,
	capture_limit = 10,
	neutral_flag_message = nil,
	enemy_flag_message = nil,
	friend_flag_message = nil,
	
	--
	-- Create a new capture objective
	--
	New = function(self, o)
		o = o or {}
		setmetatable(o, self)
		self.__index = self
		return o
	end,

	--
	-- Set capture limit
	--
	SetCaptureLimit = function(self, limit)
		self.capture_limit = limit
	end,
	
	--
	-- Add a flag home region
	--
	AddFlagHomeRegion = function(self, flag, region)
		local flag = GetObjectPtr(flag)
		local region = GetRegion(region)
		self.flag_home = self.flag_home or {}
		self.flag_home[flag] = region
		self.home_flag = self.home_flag or {}
		self.home_flag[region] = flag
	end,
	
	--
	-- Set the capture region
	--
	SetCaptureRegion = function(self, region)
		self.capture = GetRegion(region)
	end,
	
	--
	-- Set a flag icon
	--
	SetFlagIcon = function(self, flag, texture, scale)
		local flag = GetObjectPtr(flag)
		self.icon = self.icon or {}
		self.icon[flag] = { texture = texture, scale = scale }
	end,
	
	--
	-- Initialize the capture objective
	--
	Init = function(self)
	
		-- internal values
		self.flag_home = self.flag_home or {}
		self.home_flag = self.home_flag or {}
		self.flag_moved = self.flag_moved or {}
		self.carriers = self.carriers or {}
		self.icon = self.icon or {}
		
		-- set AI goal
		ClearAIGoals(self.team)
		AddAIGoal(self.team, "CTFOffense", 70, GetRegionName(self.capture))
		AddAIGoal(self.team, "CTFDefense", 30)
		
		-- show team points
		ShowTeamPoints(self.team, true)
		
		-- message generator
		local Message = function (flagteam, message)
			if flagteam == 0 then
				if self.neutral_flag_message then
					ShowMessageText(self.neutral_flag_message .. message, self.team)
				end
			else
				if flagteam ~= self.team then
					if self.enemy_flag_message then
						ShowMessageText(self.enemy_flag_message .. message, self.team)
					end
				end
				if self.friend_flag_message then
					ShowMessageText(self.friend_flag_message .. message, flagteam)
				end
			end
		end
		
		-- flag capture callback
		local Capture = function (flag, flagteam, carrier)
			print("player " .. carrier .. " captured " .. GetEntityName(flag))
			Message(flagteam, "captured")
			AddTeamPoints(self.team, 1)
			KillObject(flag)
			self.carriers[carrier] = nil
		end
		
		-- flag return callback
		local Return = function (flag, flagteam, carrier)
			print("player " .. carrier .. " returned " .. GetEntityName(flag))
			Message(flagteam, "returned")
			KillObject(flag)
			self.carriers[carrier] = nil
		end
		
		-- flag reset to starting position
		OnFlagReset(
			function (flag)
				-- set as not moved
				self.flag_moved[flag] = nil
				
				-- force enter-region event for anyone in the home region
				if self.flag_home[flag] then
					DeactivateRegion(self.flag_home[flag])
					ActivateRegion(self.flag_home[flag])
				end
				
				-- get the flag team
				local flagteam = GetObjectTeam(flag)
				
				-- if the flag has an icon...
				if self.icon[flag] then
					-- turn on the map marker
					MapAddEntityMarker(flag, self.icon[flag].texture, self.icon[flag].scale, self.team)
				end
			end
			)
				
		-- team member picked up flag
		OnFlagPickUpTeam(
			function (flag, carrier)
				-- get the flag team
				local flagteam = GetObjectTeam(flag)
				
				-- if the flag is a team flag...
				if flagteam == self.team then
					-- if the flag has no home region, 
					-- or the character is in the flag's home region...
					if not self.flag_home[flag] or IsCharacterInRegion(carrier, self.flag_home[flag]) then
						-- return the flag
						Return(flag, flagteam, carrier)
						return
					end
				else
					-- if the capture region does not have a moved flag,
					-- and the character is in the capture region...
					local capture = self.home_flag[self.capture]
					if not (capture and self.flag_moved[capture]) and IsCharacterInRegion(carrier, self.capture) then
						Capture(flag, flagteam, carrier)
						return
					end
				end
				
				-- set character as carrying the flag
				self.carriers[carrier] = flag
				
				-- mark the flag as moved
				self.flag_moved[flag] = carrier
				
				-- output a message
				print("player " .. carrier .. " picked up " .. GetEntityName(flag))
				Message(flagteam, "taken")
			end,
			self.team
			)
			
		-- enemy picked up flag
		OnFlagPickUpTeam(
			function (flag, carrier)
				-- get the flag team
				local flagteam = GetObjectTeam(flag)
				
				-- if the flag has an icon...
				if self.icon[flag] then
					-- turn off the map marker
					MapRemoveEntityMarker(flag, self.team)
				end
			end,
			3 - self.team
			)
			
		-- team member dropped flag
		OnFlagDropTeam(
			function (flag, carrier)
				-- get the flag team
				local flagteam = GetObjectTeam(flag)
				
				-- set character as not carrying the flag
				self.carriers[carrier] = nil
				
				-- output a message
				print("player " .. carrier .. " dropped " .. GetEntityName(flag))
				Message(flagteam, "dropped")
			end,
			self.team
			)

		-- enemy dropped flag
		OnFlagDropTeam(
			function (flag, carrier)
				-- get the flag team
				local flagteam = GetObjectTeam(flag)
				
				-- if the flag has an icon...
				if self.icon[flag] then
					-- turn on the map marker
					MapAddEntityMarker(flag, self.icon[flag].texture, self.icon[flag].scale, self.team)
				end
			end,
			3 - self.team
			)
			
		-- for each home region...
		for flag, region in pairs(self.flag_home) do
		
			-- associate the region with the flag
			SetProperty(flag, "HomeRegion", GetRegionName(region))
		
			-- activate the home region
			ActivateRegion(region)
		
			-- team member entered home region
			OnEnterRegionTeam(
				function (region, carrier)
					local flag = self.carriers[carrier]
					if flag then
						-- if the character is carrying a friendly flag,
						-- and the region is the flag's home region,
						local flagteam = GetObjectTeam(flag)
						if flagteam == self.team and self.flag_home[flag] == region then
							-- return the flag
							Return(flag, flagteam, carrier)
						end
					end
				end,
				region,
				self.team
				)
		end
    
		-- activate the capture region
		ActivateRegion(self.capture)
		
		-- team member entered capture region
		OnEnterRegionTeam(
			function (region, carrier)
				local flag = self.carriers[carrier]
				if flag then
					-- if the character is carrying a non-friendly flag...
					local flagteam = GetObjectTeam(flag)
					if flagteam ~= self.team then
						local capture = self.home_flag[self.capture]
						-- if the capture region does not have a moved flag...
						if not (capture and self.flag_moved[capture]) then
							-- capture the flag
							Capture(flag, flagteam, carrier)
						end
					end
				end
			end,
			self.capture,
			self.team
			)
			
		-- team points change
		OnTeamPointsChangeTeam(
			function (team, points)
				if points >= self.capture_limit then
					MissionVictory(team)
				end
			end,
			self.team
			)
			
		-- activate map markers
		for flag, icon in pairs(self.icon) do
			MapAddEntityMarker(flag, icon.texture, icon.scale, self.team)
		end
	end
}

CaptureFlagObjective = CaptureObjective:New{
	neutral_flag_message = "game.flag.neutral.",
	enemy_flag_message = "game.flag.enemy.",
	friend_flag_message = "game.flag.friend.",
}
