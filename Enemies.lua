--[[--------------------------------------------------------------------
    Copyright (C) 2012 Sidoine De Wispelaere.
    Copyright (C) 2012, 2013, 2014 Johnny C. Lam.
    See the file LICENSE.txt for copying permission.
    
    Module rewritten by Adrian Hamilton (LunaEclipse)
--]]--------------------------------------------------------------------

-- Gather information about ennemies

local OVALE, Ovale = ...;
local OvaleEnemies = Ovale:NewModule("OvaleEnemies", "AceEvent-3.0", "AceTimer-3.0");
Ovale.OvaleEnemies = OvaleEnemies;

--<private-static-properties>
local L = Ovale.L;
local OvaleDebug = Ovale.OvaleDebug;
local OvaleProfiler = Ovale.OvaleProfiler;

-- Forward declarations for module dependencies.
local OvaleState = nil;

-- Register for debugging messages.
OvaleDebug:RegisterDebugging(OvaleEnemies);
-- Register for profiling.
OvaleProfiler:RegisterProfiling(OvaleEnemies);

-- Player's GUID.
local playerGUID = nil;

-- targets[guid] = timestamp;
local targets = {};
-- myTargets[guid] = timestamp;
-- GUIDs used as keys for this table are a subset of the GUIDs used for targets.
local myTargets = {};
-- minions[guid] = timestamp;
-- GUIDs of units summoned by the player.
local minions = {};

-- Timer for reaper function to remove inactive enemies.
local reaperTimer = nil;
local REAP_INTERVAL = 3;
--</private-static-properties>

--<public-static-properties>
-- Total number of active enemies.
OvaleEnemies.activeEnemies = 0;
-- Total number of tagged enemies.
OvaleEnemies.taggedEnemies = 0;
-- Total number of player minions.
OvaleEnemies.playerMinions = 0;
--</public-static-properties>

--<private-static-methods>
local function abilityUsedEvent(combatEvent)
	local returnValue = false;
	
	if combatEvent == "SPELL_DAMAGE"
	   or combatEvent == "SPELL_MISSED" then
	   	returnValue = true;
	end
	
	return returnValue;	   	
end

local function autoAttackEvent(combatEvent)
	local returnValue = false;
	
	if combatEvent == "RANGE_DAMAGE"
	   or combatEvent == "RANGE_MISSED"
	   or combatEvent == "SWING_DAMAGE" 
	   or combatEvent == "SWING_MISSED" then
	   	returnValue = true;
	end
	
	return returnValue;	   	
end

local function damageOverTimeEvent(combatEvent)
	local returnValue = false;
	
	if combatEvent == "SPELL_AURA_APPLIED"
	   or combatEvent == "SPELL_AURA_REFRESH"
	   or combatEvent == "SPELL_PERIODIC_DAMAGE" 
	   or combatEvent == "SPELL_PERIODIC_MISSED" then
	   	returnValue = true;
	end
	
	return returnValue;	   	
end

local function deathEvent(combatEvent)
	local returnValue = false;
	
	if combatEvent == "UNIT_DIED" 
	    or combatEvent == "UNIT_DESTROYED" then
	   	returnValue = true;
	end
	
	return returnValue;	   	
end

local function playerSummonEvent(combatEvent, sourceIsPlayer)
	local returnValue = false;
	
	if combatEvent == "SPELL_SUMMON" 
	   and sourceIsPlayer then
	   	returnValue = true;
	end
	
	return returnValue;	   	
end

local function isValidEvent(combatEvent)
	local returnValue = false;

	if abilityUsedEvent(combatEvent) then 
		returnValue = true;
	end

	if damageOverTimeEvent(combatEvent) then 
		returnValue = true;
	end

--[[ 
	The following lines can be used to detect enemies on auto-attacks as well
	but doing so greatly reduces FPS, testing showed up to 15% reduction.
	
	Use with extreme caution.

	if autoAttackEvent(combatEvent) then 
		returnValue = true;
	end
]]--

	return returnValue;
end

local function bothUnitsExist(sourceGUID, destGUID)
	local returnValue = false;
	
	if (sourceGUID and sourceGUID ~= "")
	    and (destGUID and destGUID ~= "") then
		returnValue = true;
	end
	
	return returnValue;
end

local function isEnemy(targetFlags)
	local returnValue = false;
	
	if bit.band(targetFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0 then
		returnValue = true;
	end
	
	return returnValue;
end

local function isGroupMember(targetFlags)
	local returnValue = false;
	
	if (bit.band(targetFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0)
	    or (bit.band(targetFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY) ~= 0) 
	    or (bit.band(targetFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) ~= 0) then
		returnValue = true;
	end
	
	return returnValue;
end

local function isPlayer(targetFlags)
	local returnValue = false;
	
	if bit.band(targetFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0 then
		returnValue = true;
	end
	
	return returnValue;
end

local function validObject(targetFlags)
	local returnValue = false;
	
	if (bit.band(targetFlags, COMBATLOG_OBJECT_TYPE_PET) ~= 0)
	    or (bit.band(targetFlags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0) 
	    or (bit.band(targetFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0) then
		returnValue = true;
	end
	
	return returnValue;
end

local function wipeData()
	targets = {};
	OvaleEnemies.activeEnemies = 0;

	myTargets = {};
	OvaleEnemies.taggedEnemies = 0;

	minions = {};
	OvaleEnemies.playerMinions = 0;
end

local function getTargetInfo(targetFlags)
	local targetIsPlayer = isPlayer(targetFlags);
	local targetIsEnemy = isEnemy(targetFlags);
	local targetIsValid = validObject(targetFlags);
	local targetIsGroupMember = isGroupMember(targetFlags);

	return targetIsPlayer, targetIsGroupMember, targetIsEnemy, targetIsValid;
end
--</private-static-methods>

--<public-static-methods>
function OvaleEnemies:OnInitialize()
	-- Resolve module dependencies.
	OvaleState = Ovale.OvaleState;
end

function OvaleEnemies:OnEnable()
	playerGUID = Ovale.playerGUID;

	if not reaperTimer then
		reaperTimer = self:ScheduleRepeatingTimer("RemoveInactiveEnemies", REAP_INTERVAL);
	end
	
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	self:RegisterEvent("PLAYER_REGEN_DISABLED");
	
	OvaleState:RegisterState(self, self.statePrototype);
end

function OvaleEnemies:OnDisable()
	OvaleState:UnregisterState(self);
	
	if not reaperTimer then
		self:CancelTimer(reaperTimer);
		reaperTimer = nil;
	end
	
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	self:UnregisterEvent("PLAYER_REGEN_DISABLED");
end

function OvaleEnemies:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local _, combatEvent, _, sourceGUID, _, sourceFlags, _, destGUID, _, destFlags = ...;
	local currentTime = GetTime();

	local sourceIsPlayer, sourceIsGroupMember, sourceIsEnemy, sourceIsValid = getTargetInfo(sourceFlags);
	local destIsPlayer, destIsGroupMember, destIsEnemy, destIsValid = getTargetInfo(destFlags);
	
	if deathEvent(combatEvent) then
		self:RemoveEnemy(destGUID, true);
		self:RemoveMinion(destGUID, true);

		return;
	end

	if bothUnitsExist(sourceGUID, destGUID) then
		if sourceIsGroupMember or destIsGroupMember then
			if playerSummonEvent(combatEvent, sourceIsPlayer) then
				self:AddMinion(destGUID, currentTime);

				return;
			end

			if isValidEvent(combatEvent) then
				if sourceIsGroupMember and destIsValid and destIsEnemy then
					self:AddEnemy(destGUID, currentTime, sourceIsPlayer);

					return;
				end

				if destIsGroupMember and sourceIsValid and sourceIsEnemy then
					self:AddEnemy(sourceGUID, currentTime);

					return;
				end
			end
		end
	end
end

function OvaleEnemies:PLAYER_REGEN_DISABLED()
	-- Reset enemy tracking when combat starts.
	wipeData();
end

-- Remove enemies that have been inactive for at least REAP_INTERVAL seconds.
-- These enemies are not in combat with your group, out of range, or
-- incapacitated and shouldn't count toward the number of active enemies.
function OvaleEnemies:RemoveInactiveEnemies()
	self:StartProfiling("OvaleEnemies_RemoveInactiveEnemies");
	
	local currentTime = GetTime();

	for GUID, timeStamp in pairs(targets) do
		if currentTime - timeStamp > REAP_INTERVAL then
			self:RemoveEnemy(GUID);
		end
	end

	for GUID, timeStamp in pairs(minions) do
		if currentTime - timeStamp > REAP_INTERVAL then
			self:RemoveMinion(GUID);
		end
	end
	
	self:StopProfiling("OvaleEnemies_RemoveInactiveEnemies");
end


function OvaleEnemies:AddMinion(GUID, timeStamp)
	self:StartProfiling("OvaleEnemies_AddMinion");

	if not minions[GUID] then
		OvaleEnemies.playerMinions = OvaleEnemies.playerMinions + 1;
		minions[GUID] = timeStamp;

		self:DebugTimestamp("New player minion seen (%d total): %s", self.playerMinions, GUID);
	else
		minions[GUID] = timeStamp;
	end
	
	self:StopProfiling("OvaleEnemies_AddMinion");
end

function OvaleEnemies:RemoveMinion(GUID, deathEvent)
	self:StartProfiling("OvaleEnemies_RemoveMinion");

	local unitDied;

	if not deathEvent then
		unitDied = false;
	else
		unitDied = true;
	end

	if minions[GUID] ~= nil then
		local lastSeen = minions[GUID];

		OvaleEnemies.playerMinions = max(0, OvaleEnemies.playerMinions - 1);
		minions[GUID] = nil;

		if unitDied then
			self:DebugTimestamp("Player minion died (%d total): %s", self.playerMinions, GUID);
		else
			self:DebugTimestamp("Player minion removed (%d total): %s, last seen at %f", self.playerMinions, GUID, lastSeen);
		end
	end
	
	self:StopProfiling("OvaleEnemies_RemoveMinion");
end

function OvaleEnemies:AddEnemy(GUID, timeStamp, playerTarget)
	self:StartProfiling("OvaleEnemies_AddEnemy");

	if not targets[GUID] then
		OvaleEnemies.activeEnemies = OvaleEnemies.activeEnemies + 1;
		targets[GUID] = timeStamp;

		self:DebugTimestamp("New enemy seen (%d total): %s", self.activeEnemies, GUID);
		Ovale.refreshNeeded[playerGUID] = true;
	else
		targets[GUID] = timeStamp;
	end

	if playerTarget then
		if not myTargets[GUID] then
			OvaleEnemies.taggedEnemies = OvaleEnemies.taggedEnemies + 1;
			myTargets[GUID] = timeStamp;

			self:DebugTimestamp("New tagged enemy seen (%d total, %d tagged): %s", self.activeEnemies, self.taggedEnemies, GUID);
			Ovale.refreshNeeded[playerGUID] = true;
		else
			myTargets[GUID] = timeStamp;
		end
	end 
	
	self:StopProfiling("OvaleEnemies_AddEnemy");
end

function OvaleEnemies:RemoveEnemy(GUID, deathEvent)
	self:StartProfiling("OvaleEnemies_RemoveEnemy");

	local refreshNeeded = false;
	local unitDied;

	if not deathEvent then
		unitDied = false;
	else
		unitDied = true;
	end

	if targets[GUID] ~= nil then
		local lastSeen = targets[GUID];

		OvaleEnemies.activeEnemies = max(0, OvaleEnemies.activeEnemies - 1);
		targets[GUID] = nil;

		if unitDied then
			self:DebugTimestamp("Enemy died (%d total): %s", self.activeEnemies, GUID);
		else
			self:DebugTimestamp("Enemy removed (%d total): %s, last seen at %f", self.activeEnemies, GUID, lastSeen);
		end
		
		refreshNeeded = true;
	end

	if myTargets[GUID] ~= nil then
		local taggedLastSeen = myTargets[GUID];
	
		OvaleEnemies.taggedEnemies = max(0, OvaleEnemies.taggedEnemies - 1);
		myTargets[GUID] = nil;

		if unitDied then
			self:DebugTimestamp("Tagged enemy died (%d total, %d tagged): %s", self.activeEnemies, self.taggedEnemies, GUID);
		else
			self:DebugTimestamp("Tagged enemy removed( %d total, %d tagged): %s, last seen at %f", self.activeEnemies, self.taggedEnemies, GUID, taggedLastSeen);
		end
		
		refreshNeeded = true;
	end	

	if refreshNeeded then
		Ovale.refreshNeeded[playerGUID] = true;
		self:SendMessage("Ovale_InactiveUnit", GUID, unitDied);
	end
	
	self:StopProfiling("OvaleEnemies_RemoveEnemy");
end

function OvaleEnemies:DebugEnemies()
	for GUID, lastSeen in pairs(targets) do
		local taggedTarget = myTargets[GUID];
		
		if taggedTarget then
			self:Print("Tagged enemy %s last seen at %f", GUID, taggedTarget);
		else
			self:Print("Enemy %s last seen at %f", GUID, lastSeen);
		end
	end

	for GUID, lastSeen in pairs(minions) do
		self:Print("Player minion %s last seen at %f", GUID, lastSeen);
	end
	
	self:Print("Total enemies: %d", self.activeEnemies);
	self:Print("Total tagged enemies: %d", self.taggedEnemies);
	self:Print("Total player minions: %d", self.playerMinions);
end
--</public-static-methods>


--[[----------------------------------------------------------------------------
	State machine for simulator.
--]]----------------------------------------------------------------------------

--<public-static-properties>
OvaleEnemies.statePrototype = {};
--</public-static-properties>

--<private-static-properties>
local statePrototype = OvaleEnemies.statePrototype;
--</private-static-properties>

--<state-properties>
-- Total number of active enemies.
statePrototype.activeEnemies = nil;
-- Total number of tagged enemies.
statePrototype.taggedEnemies = nil;
-- Total number of player minions.
statePrototype.playerMinions = nil;

-- Requested number of enemies.
statePrototype.enemies = nil;
--</state-properties>

--<public-static-methods>
-- Initialize the state.
function OvaleEnemies:InitializeState(state)
	state.enemies = nil;
end

-- Reset the state to the current conditions.
function OvaleEnemies:ResetState(state)
	self:StartProfiling("OvaleEnemies_ResetState");

	state.activeEnemies = self.activeEnemies;
	state.taggedEnemies = self.taggedEnemies;
	state.playerMinions = self.playerMinions;

	self:StopProfiling("OvaleEnemies_ResetState");
end

-- Release state resources prior to removing from the simulator.
function OvaleEnemies:CleanState(state)
	state.activeEnemies = nil;
	state.taggedEnemies = nil;
	state.playerMinions = nil;
	state.enemies = nil;
end
--</public-static-methods>
