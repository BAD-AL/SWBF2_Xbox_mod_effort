--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ConquestTeam = 
{
	team = 0,
	points = 0,
	count = 0,
	bleed = {},
	
	--
	-- Create a new conquest team
	--
	New = function(self, o)
		o = o or {}
		setmetatable(o, self)
		self.__index = self
		return o
	end,

	--
	-- Initialize the conquest team
	--
	Init = function(self)
		
		-- ai goals
		AddAIGoal(self.team,"Conquest",100)
	
		-- create the bleed timer
		self.bleedtimer = CreateTimer("bleed" .. self.team)
		SetTimerValue(self.bleedtimer, 4)
		OnTimerElapse(
			function (timer)
				if GetReinforcementCount(self.team) > 0 then
					AddReinforcements(self.team, -1)
				end
				SetTimerValue(timer, GetTimerValue(timer) + 4)
				StartTimer(timer)
			end,
			self.bleedtimer)
		
		-- create the lose timer
		self.losetimer = CreateTimer("instant" .. self.team)
		OnTimerElapse(
			function(timer)
				MissionDefeat(self.team)
			end,
			self.losetimer)
		
		-- command post spawn
		OnCommandPostRespawn(
			function (post)
				local team = GetCommandPostTeam(post)
				if team == self.team then
					self:UpdatePost(GetCommandPostBleedValue(post, team), 1)
				elseif team == 0 then
					self:UpdatePost(1, 0)
				end
			end
			)
		
		-- command post kill
		OnCommandPostKill(
			function (post)
				local team = GetCommandPostTeam(post)
				if team == self.team then
					self:UpdatePost(-GetCommandPostBleedValue(post, team), -1)
				elseif team == 0 then
					self:UpdatePost(-1, 0)
				end
			end
			)

		-- command post neutralize
		OnFinishNeutralize(
			function (post)
				local team = GetCommandPostTeam(post)
				if team == self.team then
					self:UpdatePost(1 - GetCommandPostBleedValue(post, team), -1)
				elseif team ~= 0 then
					self:UpdatePost(1, 0)
				end
			end
			)

		-- command post capture		
		OnFinishCapture(
			function (post)
				local team = GetCommandPostTeam(post)
				if team == self.team then
					self:UpdatePost(GetCommandPostBleedValue(post, team) - 1, 1)
				elseif team ~= 0 then
					self:UpdatePost(-1, 0)
				end
			end
			)
		
		-- teammate death
		OnCharacterDeathTeam(
			function (character, killer)
				if GetReinforcementCount(self.team) > 0 then
					AddReinforcements(self.team, -1)
				end
			end,
			self.team
			)
		
		-- ticket count change
		OnTicketCountChangeTeam(
			function (team, count)
				if count <= 0 then
					MissionDefeat(team)
				end
			end,
			self.team
			)
	end,

	--
	-- add a bleed threshold
	--
	AddBleedThreshold = function(self, threshold, rate)
		self.bleed[threshold] = rate
	end,
	
	--
	-- update command post points and count
	--
	UpdatePost = function(self, points, count)
		-- update the total points and count
		self.points = self.points + points;
		self.count = self.count + count;
		
		-- calculate the bleed rate
		local bleedrate = 0
		local minthresh = 2147483647
		for threshold, rate in pairs(self.bleed) do
			if self.points <= threshold and threshold <= minthresh then
				bleedrate = rate
				minthresh = threshold
			end
		end

		-- update the bleed rate
		SetBleedRate(self.team, bleedrate)
		SetTimerRate(self.bleedtimer, bleedrate)
		
		-- start or stop the bleed timer as necessary
		if bleedrate == 0 then
			StopTimer(self.bleedtimer)
		else
			StartTimer(self.bleedtimer)
		end
		
		-- if the enemy holds all command points...
		if self.points <= 0 then
			-- show the lose timer
			SetDefeatTimer(self.losetimer, self.team)
			
			-- start the lose timer
			StartTimer(self.losetimer)
		else
			-- stop the lose timer
			StopTimer(self.losetimer)
			
			-- if holding at least one commmand post ...
			if self.count > 0 then
				-- if adding the first one...
				if self.count == count then
					-- hide the lose timer
					SetDefeatTimer(nil, self.team)
				end
				
				-- reset the lose timer
				SetTimerValue(self.losetimer, 20)
			end
		end
	end
}
