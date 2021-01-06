--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("Objective")

--NOTE: ObjectiveSpaceAssault is a special case objective that is designed for multiplayer only
ObjectiveSpaceAssault = Objective:New
{
	--external values that must be supplied when creating a new objective
	shipBitmapATT = nil,
	shipBitmapDEF = nil,
	shieldBitmapATT = nil,
	shieldBitmapDEF = nil,
	criticalSystemBitmapATT = nil,
	criticalSystemBitmapDEF = nil,
	
	systemsList = {},
}

function ObjectiveSpaceAssault:OnCriticalSystemDestroyed(name, pointValue)
	--designers, override me as necessary!
	print("TEST - critical system destroyd:", name, "pointValue:", pointValue)		--TODO: remove this line
end

-- name: the name of the object in the level (duh)
-- pointValue: how many points the object is worth when it's destroyed
-- hudPosX, hudPosY: texture coordinates for placing the hud health indicator for the critical system
--					 (should be in the range of 0.0 to 1.0)
function ObjectiveSpaceAssault:AddCriticalSystem(name, pointValue, hudPosX, hudPosY)
	if hudPosX and hudPosY then
		--add the critical system as normal
		SpaceAssaultAddCriticalSystem(name, pointValue, hudPosX, hudPosY)
	else
		--add the critical system, but tell C++ not to display a HUD marker
		SpaceAssaultAddCriticalSystem(name, pointValue, -1.0, -1.0, false) 
	end
	
	OnObjectKillName(
		function (objectPtr, killer)
			self:OnCriticalSystemDestroyed(name, pointValue)
			AddSpaceAssaultDestroyPoints(killer, GetEntityName(objectPtr))
			SetProperty(objectPtr, "MaxHealth", 99999999999.0)		--effectively makes the object un-repairable
			self:UpdateObjectiveMessage(name)
		end,
		name
		)
end


function ObjectiveSpaceAssault:Start()
	--=======================================
    -- Initialization logic
    --=======================================   
	assert(self.multiplayerRules == true, "ObjectiveSpaceAssault is intended for multiplayer gametypes only! (i.e. set multiplayerRules = true)")	
	self.showTeamPoints = true
	
	--initialize the base objective data
	Objective.Start(self)
	
	--notify C++ that we're running space assault now 
	--(so it can do team scoring with critical systems and whatnot)
	SpaceAssaultEnable(true)	
	SpaceAssaultSetupBitmaps(self.shipBitmapATT, self.shipBitmapDEF,
							 self.shieldBitmapATT, self.shieldBitmapDEF,
							 self.criticalSystemBitmapATT, self.criticalSystemBitmapDEF)
							 
	SetReinforcementCount(self.teamATT, -1)
	SetReinforcementCount(self.teamDEF, -1)

	
	--=======================================
    -- Event responses
    --=======================================	
	self.teamPointsChangeResponse = OnTeamPointsChange(
        function (team, points)
            if self.isComplete or self.spaceVOTimer then return end

			if points >= SpaceAssaultGetScoreLimit() then
				local loseTeam = GetOppositeTeam( team )

				BroadcastVoiceOver( self.systemsList[team]["winVO"], team )
				BroadcastVoiceOver( self.systemsList[loseTeam]["loseVO"], loseTeam )          

				self.spaceVOTimer = CreateTimer("spaceVOTimer")
				SetTimerValue(self.spaceVOTimer, 4.0)
				StartTimer(self.spaceVOTimer)
				self.victoryDelayTimerResponse = OnTimerElapse(
					function(timer)
						self:Complete(team)
						ReleaseTeamPointsChange(self.teamPointsChangeResponse)
					end,
					self.spaceVOTimer
				)
			end
        end
        ) 
		
		
	-- HACK!  wsh 20052307
	-- #1, this system shouldn't really know about game specific data
	-- #2, this assumes that the templates will not be needed any more (i.e. only one ObjectiveSpaceAssault running at a time)
	gSpaceAssaultSystems_template = nil
end

---------------------------------------------------------------------------
-- The code below is specific to BF2
-- Among its assumptions:
--  * there are five critical systems
--  * frigates

---------------------------------------------------------------------------
function ObjectiveSpaceAssault:SetupAllCriticalSystems( aSide, atSystems, aAttacking )
	local kInternSysValue = 18
	-- check the validity of aSide
	local tTemplate = gSpaceAssaultSystems_template[ aSide ]
	if not tTemplate then return end
	
	-- set up hud state indicator data
	local shipIcon = aSide .. "_icon_ass"
	local shieldIcon = shipIcon .. "_shield"
	local markerIcon = "spa_icon_critsys"
	if aAttacking then
		self.shipBitmapATT = shipIcon
		self.shieldBitmapATT = shieldIcon
		self.criticalSystemBitmapATT = markerIcon
	else
		self.shipBitmapDEF = shipIcon
		self.shieldBitmapDEF = shieldIcon
		self.criticalSystemBitmapDEF = markerIcon
	end
	
	-- add main objective
	-- (ugh, hack)
	local myTeam = 1
	if not aAttacking then myTeam = 2 end
	AddMissionObjective( myTeam, tTemplate.objTxt )
	ActivateObjective( tTemplate.objTxt )
	
	-- link up win / lose vo
	local voList = {}
	voList.winVO = tTemplate.winVO
	voList.loseVO = tTemplate.loseVO
	self.systemsList[ myTeam ] = voList
	
	-- set up internal systems
	-- (hacky--this needs to happen before we process normal systems)
	local internalSys = atSystems.internalSys
	if internalSys then
		for i, sys in pairs( internalSys ) do
			self:AddCriticalSystem( sys, kInternSysValue )
		end
	
		atSystems.internalSys = nil
	end

	-----------------------------
	-- process remaining systems
	-----------------------------
	-- need to specify an order
	local tOrder = { "engines", "lifesupport", "bridge", "comm", "sensors", "frigates" }
	
	for i, sysType in ipairs( tOrder ) do
		local obj = atSystems[ sysType ]
		
		if obj then
			-- this is a not a deep copy, though it should be
			local sysData = tTemplate[ sysType ]
			sysData.sysType = sysType
			
			local objName
			if type(obj) ~= "table" then
				objName = obj
				
				self:SetupOneCriticalSystem( objName, sysData )
			else
				-- objs is a table of names
				-- we will track all the objects as one marker
				objName = obj[1]
				
				sysData.maxItems = table.getn( obj )
				sysData.curItems = 0
				
				-- add each member to the internal list
				for i, name in pairs( obj ) do
					self:SetupOneCriticalSystem( name, sysData )
				end
			
				SpaceAssaultLinkCriticalSystems( obj )
			end
				
			-- add the objective text
			if ScriptCB_GetNumCameras() == 1 or sysData.bShowInSplitscreen then
				local defender = GetObjectTeam( objName )
				local attacker = GetOppositeTeam( defender )
				AddMissionObjective( attacker, sysData.objTxt )
				ActivateObjective( sysData.objTxt )
			end
		end
	end
	
	-- add fighter text at end
	AddMissionObjective( myTeam, tTemplate.fighterTxt )
	ActivateObjective( tTemplate.fighterTxt )

end


---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------
-- handle bookkeeping when adding a system
function ObjectiveSpaceAssault:SetupOneCriticalSystem( name, data )
	self.systemsList[ name ] = data
	self:AddCriticalSystem( name, data.pts, data.u, data.v )
	EnableBuildingLockOn( name, true )		
end

-- on destruction
-- clear objective text, update status messages
function ObjectiveSpaceAssault:UpdateObjectiveMessage( aName )
	local data = self.systemsList[ aName ]
	if not data then
		return
	end
	
	-- if this system is linked, update the count
	if data.maxItems then
		data.curItems = data.curItems + 1
		
		-- if we have not destroyed all linked objects, don't update the message
		if data.curItems < data.maxItems then
			return
		end
	end
	
	----------------------
	-- Send state change info to clients
	----------------------
	-- update the message
	CompleteObjective( data.objTxt )
	
	-- figure out teams
	local defTeam = GetObjectTeam( aName )
	local attTeam = GetOppositeTeam( defTeam )
	
	-- display status message
	ShowMessageText( "level.spa.hangar." .. data.sysType .. ".atk.down", attTeam )
	ShowMessageText( "level.spa.hangar." .. data.sysType .. ".def.down", defTeam )
	
	-- play VO cues
	BroadcastVoiceOver( data.attVO, attTeam )
	BroadcastVoiceOver( data.defVO, defTeam )
end	
	
-- somewhat hacky, as I can't use predefeind ATT and DEF here
function GetOppositeTeam( team )
	if team == 1 then
		return 2
	else
		return 1
	end
end

---------------------------------------------------------------------------

---------------------------------------------------------------------------
function ObjectiveSpaceAssault:OnComplete( aWinTeam )
	
end

---------------------------------------------------------------------------
-- gSpaceAssaultSystems_template
-- Common data for all the systems
-- Assumes only IMP v ALL and REP v CIS
-- I'm not happy with the way this is implemented, but it seems like the simplest.
-- Ideally, we send out an "engines destroyed" event, and each side interprets as needed
-- instead of encoding the vo's and objectives with the object.
---------------------------------------------------------------------------
gSpaceAssaultSystems_template = {
	imp = {
		objTxt		= "level.spa.objectives.imp.0",
		fighterTxt	= "level.spa.fighters.atk",
		winVO		= "IOSMP_obj_24",
		loseVO		= "IOSMP_obj_25",
		engines		= { 
			pts = 3, u = 0.5, v = 0.95,
			objTxt = "level.spa.objectives.imp.3", attVO = "IOSMP_obj_05", defVO = "AOSMP_obj_06",
		},
		lifesupport	= {
			pts = 18, u = 0.5, v = 0.11,
			objTxt = "level.spa.objectives.imp.2", attVO = "IOSMP_obj_08", defVO = "AOSMP_obj_09",
		},
		bridge		= {
			pts = 18, u = 0.5, v = 0.23,
			objTxt = "level.spa.objectives.imp.4", attVO = "IOSMP_obj_10", defVO = "AOSMP_obj_11",
		},
		comm		= {
			pts = 18, u = 0.5, v = 0.5,
			objTxt = "level.spa.objectives.imp.5", attVO = "IOSMP_obj_12", defVO = "AOSMP_obj_13",
		},
		sensors		= {
			pts = 18, u = 0.5, v = 0.85,
			objTxt = "level.spa.objectives.imp.6", attVO = "IOSMP_obj_14", defVO = "AOSMP_obj_15",
		},
		frigates	= {
			pts = 18,
			objTxt = "level.spa.objectives.imp.7", attVO = "IOSMP_obj_03", defVO = "AOSMP_obj_04",
			bShowInSplitscreen = true
		}
	},
	all = {
		objTxt		= "level.spa.objectives.all.0",
		fighterTxt	= "level.spa.fighters.def",
		winVO		= "AOSMP_obj_24",
		loseVO		= "AOSMP_obj_25",
		engines		= { 
			pts = 6, u = 0.5, v = 0.92,
			objTxt = "level.spa.objectives.all.3", defVO = "IOSMP_obj_06", attVO = "AOSMP_obj_05",
		},
		lifesupport	= {
			pts = 18, u = 0.5, v = 0.65,
			objTxt = "level.spa.objectives.all.2", defVO = "IOSMP_obj_09", attVO = "AOSMP_obj_08",
		},
		bridge		= {
			pts = 18, u = 0.5, v = 0.85,
			objTxt = "level.spa.objectives.all.4", defVO = "IOSMP_obj_11", attVO = "AOSMP_obj_10",
		},
		comm		= {
			pts = 18, u = 0.5, v = 0.75,
			objTxt = "level.spa.objectives.all.5", defVO = "IOSMP_obj_13", attVO = "AOSMP_obj_12",
		},
		sensors		= {
			pts = 18, u = 0.5, v = 0.32,
			objTxt = "level.spa.objectives.all.6", defVO = "IOSMP_obj_15", attVO = "AOSMP_obj_14",
		},
		frigates	= {
			pts = 18,
			objTxt = "level.spa.objectives.all.7", defVO = "IOSMP_obj_04", attVO = "AOSMP_obj_03",
			bShowInSplitscreen = true,
		}
	},
	
	rep = {
		objTxt		= "level.spa.objectives.rep.0",
		fighterTxt	= "level.spa.fighters.atk",
		winVO		= "ROSMP_obj_24",
		loseVO		= "ROSMP_obj_25",
		engines		= { 
			pts = 9, u = 0.5, v = 0.92,
			objTxt = "level.spa.objectives.rep.3", defVO = "COSMP_obj_06", attVO = "ROSMP_obj_05",
		},
		lifesupport	= {
			pts = 18, u = 0.5, v = 0.16,
			objTxt = "level.spa.objectives.rep.2", defVO = "COSMP_obj_09", attVO = "ROSMP_obj_08",
		},
		bridge		= {
			pts = 18, u = 0.5, v = 0.54,
			objTxt = "level.spa.objectives.rep.4", defVO = "COSMP_obj_11", attVO = "ROSMP_obj_10",
		},
		comm		= {
			pts = 18, u = 0.5, v = 0.40,
			objTxt = "level.spa.objectives.rep.5", defVO = "COSMP_obj_13", attVO = "ROSMP_obj_12",
		},
		sensors		= {
			pts = 18, u = 0.5, v = 0.78,
			objTxt = "level.spa.objectives.rep.6", defVO = "COSMP_obj_15", attVO = "ROSMP_obj_14",
		},
		frigates	= {
			pts = 18,
			objTxt = "level.spa.objectives.rep.7", defVO = "COSMP_obj_04", attVO = "ROSMP_obj_03",
			bShowInSplitscreen = true,
		}
	},	
	cis = {
		objTxt		= "level.spa.objectives.cis.0",
		fighterTxt	= "level.spa.fighters.def",
		winVO		= "COSMP_obj_24",
		loseVO		= "COSMP_obj_25",
		engines		= { 
			pts = 18, u = 0.5, v = 0.92,
			objTxt = "level.spa.objectives.cis.3", defVO = "ROSMP_obj_06", attVO = "COSMP_obj_05",
		},
		lifesupport	= {
			pts = 18, u = 0.5, v = 0.20,
			objTxt = "level.spa.objectives.cis.2", defVO = "ROSMP_obj_09", attVO = "COSMP_obj_08",
		},
		bridge		= {
			pts = 18, u = 0.5, v = 0.66,
			objTxt = "level.spa.objectives.cis.4", defVO = "ROSMP_obj_11", attVO = "COSMP_obj_10",
		},
		comm		= {
			pts = 18, u = 0.5, v = 0.52,
			objTxt = "level.spa.objectives.cis.5", defVO = "ROSMP_obj_13", attVO = "COSMP_obj_12",
		},
		sensors		= {
			pts = 18, u = 0.5, v = 0.78,
			objTxt = "level.spa.objectives.cis.6", defVO = "ROSMP_obj_15", attVO = "COSMP_obj_14",
		},
		frigates	= {
			pts = 18,
			objTxt = "level.spa.objectives.cis.7", defVO = "ROSMP_obj_04", attVO = "COSMP_obj_03",
			bShowInSplitscreen = true,
		}
	},		
}
