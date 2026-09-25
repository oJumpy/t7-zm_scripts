#using scripts\codescripts\struct;
#using scripts\shared\_oob;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai_puppeteer_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_clone;

/*
	Name: __init__sytem__
	Namespace: _gadget_clone
	Checksum: 0xC858EE47
	Offset: 0x520
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_clone", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_clone
	Checksum: 0x11944B9A
	Offset: 0x560
	Size: 0x17F
	Parameters: 0
	Flags: None
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(42, &gadget_clone_on, &gadget_clone_off);
	ability_player::register_gadget_possession_callbacks(42, &gadget_clone_on_give, &gadget_clone_on_take);
	ability_player::register_gadget_flicker_callbacks(42, &gadget_clone_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(42, &gadget_clone_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(42, &gadget_clone_is_flickering);
	callback::on_connect(&gadget_clone_on_connect);
	clientfield::register("actor", "clone_activated", 1, 1, "int");
	clientfield::register("actor", "clone_damaged", 1, 1, "int");
	clientfield::register("allplayers", "clone_activated", 1, 1, "int");
	level._clone = [];
}

/*
	Name: gadget_clone_is_inuse
	Namespace: _gadget_clone
	Checksum: 0x350F0493
	Offset: 0x6E8
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function gadget_clone_is_inuse(slot)
{
	return self GadgetIsActive(slot);
}

/*
	Name: gadget_clone_is_flickering
	Namespace: _gadget_clone
	Checksum: 0x4DB29CF4
	Offset: 0x718
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function gadget_clone_is_flickering(slot)
{
	return self GadgetFlickering(slot);
}

/*
	Name: gadget_clone_on_flicker
	Namespace: _gadget_clone
	Checksum: 0x7C3EE49A
	Offset: 0x748
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_clone_on_flicker(slot, weapon)
{
}

/*
	Name: gadget_clone_on_give
	Namespace: _gadget_clone
	Checksum: 0x9644B0BC
	Offset: 0x768
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_clone_on_give(slot, weapon)
{
}

/*
	Name: gadget_clone_on_take
	Namespace: _gadget_clone
	Checksum: 0x6375FF4
	Offset: 0x788
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_clone_on_take(slot, weapon)
{
}

/*
	Name: gadget_clone_on_connect
	Namespace: _gadget_clone
	Checksum: 0x99EC1590
	Offset: 0x7A8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function gadget_clone_on_connect()
{
}

/*
	Name: killClones
	Namespace: _gadget_clone
	Checksum: 0xD3923544
	Offset: 0x7B8
	Size: 0xB1
	Parameters: 1
	Flags: None
*/
function killClones(player)
{
	if(isdefined(player._clone))
	{
		foreach(clone in player._clone)
		{
			if(isdefined(clone))
			{
				clone notify("clone_shutdown");
			}
		}
	}
}

/*
	Name: is_jumping
	Namespace: _gadget_clone
	Checksum: 0xAEFC1C0B
	Offset: 0x878
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function is_jumping()
{
	ground_ent = self GetGroundEnt();
	return !isdefined(ground_ent);
}

/*
	Name: CalculateSpawnOrigin
	Namespace: _gadget_clone
	Checksum: 0x850BC2A1
	Offset: 0x8B0
	Size: 0x457
	Parameters: 3
	Flags: None
*/
function CalculateSpawnOrigin(origin, angles, cloneDistance)
{
	player = self;
	startAngles = [];
	testangles = [];
	testangles[0] = (0, 0, 0);
	testangles[1] = VectorScale((0, -1, 0), 30);
	testangles[2] = VectorScale((0, 1, 0), 30);
	testangles[3] = VectorScale((0, -1, 0), 60);
	testangles[4] = VectorScale((0, 1, 0), 60);
	testangles[5] = VectorScale((0, 1, 0), 90);
	testangles[6] = VectorScale((0, -1, 0), 90);
	testangles[7] = VectorScale((0, 1, 0), 120);
	testangles[8] = VectorScale((0, -1, 0), 120);
	testangles[9] = VectorScale((0, 1, 0), 150);
	testangles[10] = VectorScale((0, -1, 0), 150);
	testangles[11] = VectorScale((0, 1, 0), 180);
	validSpawns = spawnstruct();
	validPositions = [];
	validAngles = [];
	zoffests = [];
	zoffests[0] = 5;
	zoffests[1] = 0;
	if(player is_jumping())
	{
		zoffests[2] = -5;
	}
	foreach(zoff in zoffests)
	{
		for(i = 0; i < testangles.size; i++)
		{
			startAngles[i] = (0, angles[1], 0);
			startPoint = origin + VectorScale(AnglesToForward(startAngles[i] + testangles[i]), cloneDistance);
			startPoint = startPoint + (0, 0, zoff);
			if(PlayerPositionValidIgnoreEnt(startPoint, self))
			{
				closestNavMeshPoint = GetClosestPointOnNavMesh(startPoint, 500);
				if(isdefined(closestNavMeshPoint))
				{
					startPoint = closestNavMeshPoint;
					trace = GroundTrace(startPoint + (0, 0, 24), startPoint - (0, 0, 24), 0, 0, 0);
					if(isdefined(trace["position"]))
					{
						startPoint = trace["position"];
					}
				}
				validPositions[validPositions.size] = startPoint;
				validAngles[validAngles.size] = startAngles[i] + testangles[i];
				if(validAngles.size == 3)
				{
					break;
				}
			}
		}
		if(validAngles.size == 3)
		{
			break;
		}
	}
	validSpawns.validPositions = validPositions;
	validSpawns.validAngles = validAngles;
	return validSpawns;
}

/*
	Name: insertClone
	Namespace: _gadget_clone
	Checksum: 0xF92E0437
	Offset: 0xD10
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function insertClone(clone)
{
	insertedClone = 0;
	for(i = 0; i < 20; i++)
	{
		if(!isdefined(level._clone[i]))
		{
			level._clone[i] = clone;
			insertedClone = 1;
			/#
				println("Dev Block strings are not supported" + i + "Dev Block strings are not supported" + level._clone.size);
			#/
			break;
		}
	}
	/#
		Assert(insertedClone);
	#/
}

/*
	Name: removeClone
	Namespace: _gadget_clone
	Checksum: 0x52288752
	Offset: 0xDE8
	Size: 0xC1
	Parameters: 1
	Flags: None
*/
function removeClone(clone)
{
	for(i = 0; i < 20; i++)
	{
		if(isdefined(level._clone[i]) && level._clone[i] == clone)
		{
			level._clone[i] = undefined;
			Array::remove_undefined(level._clone);
			/#
				println("Dev Block strings are not supported" + i + "Dev Block strings are not supported" + level._clone.size);
			#/
			break;
		}
	}
}

/*
	Name: removeOldestClone
	Namespace: _gadget_clone
	Checksum: 0x5E073C7B
	Offset: 0xEB8
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function removeOldestClone()
{
	/#
		Assert(level._clone.size == 20);
	#/
	oldestClone = undefined;
	for(i = 0; i < 20; i++)
	{
		if(!isdefined(oldestClone) && isdefined(level._clone[i]))
		{
			oldestClone = level._clone[i];
			oldestIndex = i;
			continue;
		}
		if(isdefined(level._clone[i]) && level._clone[i].spawntime < oldestClone.spawntime)
		{
			oldestClone = level._clone[i];
			oldestIndex = i;
		}
	}
	/#
		println("Dev Block strings are not supported" + i + "Dev Block strings are not supported" + level._clone.size);
	#/
	level._clone[oldestIndex] notify("clone_shutdown");
	level._clone[oldestIndex] = undefined;
	Array::remove_undefined(level._clone);
}

/*
	Name: spawnClones
	Namespace: _gadget_clone
	Checksum: 0x9458309D
	Offset: 0x1040
	Size: 0x493
	Parameters: 0
	Flags: None
*/
function spawnClones()
{
	self endon("death");
	self killClones(self);
	self._clone = [];
	velocity = self GetVelocity();
	velocity = velocity + (0, 0, velocity[2] * -1);
	velocity = VectorNormalize(velocity);
	origin = self.origin + velocity * 17 + VectorScale(AnglesToForward(self GetAngles()), 17);
	validSpawns = CalculateSpawnOrigin(origin, self GetAngles(), 60);
	if(validSpawns.validPositions.size < 3)
	{
		validExtendedSpawns = CalculateSpawnOrigin(origin, self GetAngles(), 180);
		for(index = 0; index < validExtendedSpawns.validPositions.size && validSpawns.validPositions.size < 3; index++)
		{
			validSpawns.validPositions[validSpawns.validPositions.size] = validExtendedSpawns.validPositions[index];
			validSpawns.validAngles[validSpawns.validAngles.size] = validExtendedSpawns.validAngles[index];
		}
	}
	for(i = 0; i < validSpawns.validPositions.size; i++)
	{
		travelDistance = Distance(validSpawns.validPositions[i], self.origin);
		validSpawns.spawnTimes[i] = travelDistance / 800;
		self thread _CloneOrbFx(validSpawns.validPositions[i], validSpawns.spawnTimes[i]);
	}
	for(i = 0; i < validSpawns.validPositions.size; i++)
	{
		if(level._clone.size < 20)
		{
		}
		else
		{
			removeOldestClone();
		}
		clone = SpawnActor("spawner_bo3_human_male_reaper_mp", validSpawns.validPositions[i], validSpawns.validAngles[i], "", 1);
		/#
			RecordCircle(validSpawns.validPositions[i], 2, (1, 0.5, 0), "Dev Block strings are not supported", clone);
		#/
		_ConfigureClone(clone, self, AnglesToForward(validSpawns.validAngles[i]), validSpawns.spawnTimes[i]);
		self._clone[self._clone.size] = clone;
		insertClone(clone);
		wait(0.05);
	}
	self notify("reveal_clone");
	if(self oob::IsOutOfBounds())
	{
		gadget_clone_off(self, undefined);
	}
}

/*
	Name: gadget_clone_on
	Namespace: _gadget_clone
	Checksum: 0x65DD9E24
	Offset: 0x14E0
	Size: 0xCB
	Parameters: 2
	Flags: None
*/
function gadget_clone_on(slot, weapon)
{
	self clientfield::set("clone_activated", 1);
	self flagsys::set("clone_activated");
	FX = playFX("player/fx_plyr_clone_reaper_appear", self.origin, AnglesToForward(self GetAngles()));
	FX.team = self.team;
	thread spawnClones();
}

/*
	Name: _UpdateClonePathing
	Namespace: _gadget_clone
	Checksum: 0x23ACF5C
	Offset: 0x15B8
	Size: 0x3A3
	Parameters: 0
	Flags: Private
*/
function private _UpdateClonePathing()
{
	self endon("death");
	while(1)
	{
		if(GetDvarInt("tu1_gadgetCloneSwimming", 1))
		{
			if(self.origin[2] + 36 <= GetWaterHeight(self.origin))
			{
				blackboard::SetBlackBoardAttribute(self, "_stance", "swim");
				self SetGoal(self.origin, 1);
				wait(0.5);
				continue;
			}
		}
		if(GetDvarInt("tu1_gadgetCloneCrouching", 1))
		{
			if(!isdefined(self.lastKnownPos))
			{
				self.lastKnownPos = self.origin;
				self.lastKnownPosTime = GetTime();
			}
			if(DistanceSquared(self.lastKnownPos, self.origin) < 24 * 24 && !self HasPath())
			{
				blackboard::SetBlackBoardAttribute(self, "_stance", "crouch");
				wait(0.5);
				continue;
			}
			if(self.lastKnownPosTime + 2000 <= GetTime())
			{
				self.lastKnownPos = self.origin;
				self.lastKnownPosTime = GetTime();
			}
		}
		Distance = 0;
		if(isdefined(self._clone_goal))
		{
			Distance = DistanceSquared(self._clone_goal, self.origin);
		}
		if(Distance < 14400 || !self HasPath())
		{
			FORWARD = AnglesToForward(self GetAngles());
			searchOrigin = self.origin + FORWARD * 750;
			self._goal_center_point = searchOrigin;
			queryResult = PositionQuery_Source_Navigation(self._goal_center_point, 500, 750, 750, 100, self);
			if(queryResult.data.size == 0)
			{
				queryResult = PositionQuery_Source_Navigation(self.origin, 500, 750, 750, 100, self);
			}
			if(queryResult.data.size > 0)
			{
				randIndex = randomIntRange(0, queryResult.data.size);
				self setgoalpos(queryResult.data[randIndex].origin, 1);
				self._clone_goal = queryResult.data[randIndex].origin;
				self._clone_goal_max_dist = 750;
			}
		}
		wait(0.5);
	}
}

/*
	Name: _CloneOrbFx
	Namespace: _gadget_clone
	Checksum: 0x148879C6
	Offset: 0x1968
	Size: 0x14B
	Parameters: 2
	Flags: None
*/
function _CloneOrbFx(endPos, travelTime)
{
	spawnPos = self GetTagOrigin("j_spine4");
	fxOrg = spawn("script_model", spawnPos);
	fxOrg SetModel("tag_origin");
	FX = PlayFXOnTag("player/fx_plyr_clone_reaper_orb", fxOrg, "tag_origin");
	FX.team = self.team;
	fxEndPos = endPos + (0, 0, 35);
	fxOrg moveto(fxEndPos, travelTime);
	self util::waittill_any_timeout(travelTime, "death", "disconnect");
	fxOrg delete();
}

/*
	Name: _CloneCopyPlayerLook
	Namespace: _gadget_clone
	Checksum: 0xBF1A8227
	Offset: 0x1AC0
	Size: 0x16B
	Parameters: 2
	Flags: Private
*/
function private _CloneCopyPlayerLook(clone, player)
{
	if(GetDvarInt("tu1_gadgetCloneCopyLook", 1))
	{
		if(isPlayer(player) && isai(clone))
		{
			bodyModel = player GetCharacterBodyModel();
			if(isdefined(bodyModel))
			{
				clone SetModel(bodyModel);
			}
			Headmodel = player GetCharacterHeadModel();
			if(isdefined(Headmodel))
			{
				if(isdefined(clone.head))
				{
					clone Detach(clone.head);
				}
				clone Attach(Headmodel);
			}
			helmetModel = player GetCharacterHelmetModel();
			if(isdefined(helmetModel))
			{
				clone Attach(helmetModel);
			}
		}
	}
}

/*
	Name: _ConfigureClone
	Namespace: _gadget_clone
	Checksum: 0x635AB461
	Offset: 0x1C38
	Size: 0x4AB
	Parameters: 4
	Flags: Private
*/
function private _ConfigureClone(clone, player, FORWARD, spawntime)
{
	clone.isaiclone = 1;
	clone.properName = "";
	clone.ignoreTriggerDamage = 1;
	clone.minWalkDistance = 125;
	clone.overrideActorDamage = &cloneDamageOverride;
	clone.spawntime = GetTime();
	clone setmaxhealth(Int(1.5 * level.playerMaxHealth));
	if(GetDvarInt("tu1_aiPathableMaterials", 0))
	{
		if(isdefined(clone.pathablematerial))
		{
			~clone.spawntime;
			clone.pathablematerial = clone.pathablematerial & 2;
		}
	}
	clone PushActors(1);
	clone PushPlayer(1);
	clone setContents(8192);
	clone SetAvoidanceMask("avoid none");
	clone ASMSetAnimationRate(RandomFloatRange(0.98, 1.02));
	clone setclone();
	clone _CloneCopyPlayerLook(clone, player);
	clone _CloneSelectWeapon(player);
	clone thread _CloneWatchDeath();
	clone thread _CloneWatchOwnerDisconnect(player);
	clone thread _CloneWatchShutdown();
	clone thread _CloneFakeFire();
	clone thread _CloneBreakGlass();
	clone._goal_center_point = FORWARD * 1000 + clone.origin;
	clone._goal_center_point = GetClosestPointOnNavMesh(clone._goal_center_point, 600);
	queryResult = undefined;
	if(isdefined(clone._goal_center_point) && clone FindPath(clone.origin, clone._goal_center_point, 1, 0))
	{
		queryResult = PositionQuery_Source_Navigation(clone._goal_center_point, 0, 450, 450, 100, clone);
	}
	else
	{
		queryResult = PositionQuery_Source_Navigation(clone.origin, 500, 750, 750, 50, clone);
	}
	if(queryResult.data.size > 0)
	{
		clone setgoalpos(queryResult.data[0].origin, 1);
		clone._clone_goal = queryResult.data[0].origin;
		clone._clone_goal_max_dist = 450;
	}
	else
	{
		clone._goal_center_point = clone.origin;
	}
	clone thread _UpdateClonePathing();
	clone ghost();
	clone thread _show(spawntime);
	_ConfigureCloneTeam(clone, player, 0);
}

/*
	Name: _PlayDematerialization
	Namespace: _gadget_clone
	Checksum: 0xE71F0388
	Offset: 0x20F0
	Size: 0x6B
	Parameters: 0
	Flags: Private
*/
function private _PlayDematerialization()
{
	if(isdefined(self))
	{
		FX = playFX("player/fx_plyr_clone_vanish", self.origin);
		FX.team = self.team;
		playsoundatposition("mpl_clone_holo_death", self.origin);
	}
}

/*
	Name: _CloneWatchDeath
	Namespace: _gadget_clone
	Checksum: 0x1F51BCF0
	Offset: 0x2168
	Size: 0x73
	Parameters: 0
	Flags: Private
*/
function private _CloneWatchDeath()
{
	self waittill("death");
	if(isdefined(self))
	{
		self StopLoopSound();
		self _PlayDematerialization();
		removeClone(self);
		self delete();
	}
}

/*
	Name: _ConfigureCloneTeam
	Namespace: _gadget_clone
	Checksum: 0x1B359BA2
	Offset: 0x21E8
	Size: 0xC3
	Parameters: 3
	Flags: Private
*/
function private _ConfigureCloneTeam(clone, player, isHacked)
{
	if(isHacked == 0)
	{
		clone.originalteam = player.team;
	}
	clone.ignoreall = 1;
	clone.owner = player;
	clone SetTeam(player.team);
	clone.team = player.team;
	clone SetEntityOwner(player);
}

/*
	Name: _show
	Namespace: _gadget_clone
	Checksum: 0x1157F09F
	Offset: 0x22B8
	Size: 0xDB
	Parameters: 1
	Flags: Private
*/
function private _show(spawntime)
{
	self endon("death");
	wait(spawntime);
	self show();
	self clientfield::set("clone_activated", 1);
	FX = playFX("player/fx_plyr_clone_reaper_appear", self.origin, AnglesToForward(self GetAngles()));
	FX.team = self.team;
	self PlayLoopSound("mpl_clone_gadget_loop_npc");
}

/*
	Name: gadget_clone_off
	Namespace: _gadget_clone
	Checksum: 0x7956C09E
	Offset: 0x23A0
	Size: 0xC7
	Parameters: 2
	Flags: None
*/
function gadget_clone_off(slot, weapon)
{
	self clientfield::set("clone_activated", 0);
	self flagsys::clear("clone_activated");
	self killClones(self);
	self _PlayDematerialization();
	if(isalive(self) && isdefined(level.playGadgetSuccess))
	{
		self [[level.playGadgetSuccess]](weapon, "cloneSuccessDelay");
	}
}

/*
	Name: _cloneDamaged
	Namespace: _gadget_clone
	Checksum: 0xA0D08FF8
	Offset: 0x2470
	Size: 0x5B
	Parameters: 0
	Flags: Private
*/
function private _cloneDamaged()
{
	self endon("death");
	self clientfield::set("clone_damaged", 1);
	util::wait_network_frame();
	self clientfield::set("clone_damaged", 0);
}

/*
	Name: ProcessCloneScoreEvent
	Namespace: _gadget_clone
	Checksum: 0x15E59182
	Offset: 0x24D8
	Size: 0xBB
	Parameters: 3
	Flags: None
*/
function ProcessCloneScoreEvent(clone, attacker, weapon)
{
	if(isdefined(attacker) && isPlayer(attacker))
	{
		if(!level.teambased || clone.team != attacker.pers["team"])
		{
			if(isdefined(clone.isaiclone) && clone.isaiclone)
			{
				scoreevents::processScoreEvent("killed_clone_enemy", attacker, clone, weapon);
			}
		}
	}
}

/*
	Name: cloneDamageOverride
	Namespace: _gadget_clone
	Checksum: 0x601756FE
	Offset: 0x25A0
	Size: 0x195
	Parameters: 15
	Flags: None
*/
function cloneDamageOverride(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, boneIndex, modelIndex, surfaceType, surfaceNormal)
{
	self thread _cloneDamaged();
	if(weapon.isEmp && sMeansOfDeath == "MOD_GRENADE_SPLASH")
	{
		ProcessCloneScoreEvent(self, eAttacker, weapon);
		self notify("clone_shutdown");
	}
	if(isdefined(level.weaponLightningGun) && weapon == level.weaponLightningGun)
	{
		ProcessCloneScoreEvent(self, eAttacker, weapon);
		self notify("clone_shutdown");
	}
	supplydrop = GetWeapon("supplydrop");
	if(isdefined(supplydrop) && supplydrop == weapon)
	{
		ProcessCloneScoreEvent(self, eAttacker, weapon);
		self notify("clone_shutdown");
	}
	return iDamage;
}

/*
	Name: _CloneWatchOwnerDisconnect
	Namespace: _gadget_clone
	Checksum: 0xEFE14373
	Offset: 0x2740
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function _CloneWatchOwnerDisconnect(player)
{
	clone = self;
	clone notify("WatchCloneOwnerDisconnect");
	clone endon("WatchCloneOwnerDisconnect");
	clone endon("clone_shutdown");
	player util::waittill_any("joined_team", "disconnect", "joined_spectators");
	if(isdefined(clone))
	{
		clone notify("clone_shutdown");
	}
}

/*
	Name: _CloneWatchShutdown
	Namespace: _gadget_clone
	Checksum: 0xA7D81966
	Offset: 0x27D8
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function _CloneWatchShutdown()
{
	clone = self;
	clone waittill("clone_shutdown");
	removeClone(clone);
	if(isdefined(clone))
	{
		if(!level.gameEnded)
		{
			clone kill();
		}
		else
		{
			clone StopLoopSound();
			self _PlayDematerialization();
			clone Hide();
		}
	}
}

/*
	Name: _CloneBreakGlass
	Namespace: _gadget_clone
	Checksum: 0x79B32EBE
	Offset: 0x2898
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function _CloneBreakGlass()
{
	clone = self;
	clone endon("clone_shutdown");
	clone endon("death");
	while(1)
	{
		clone util::break_glass();
		wait(0.25);
	}
}

/*
	Name: _CloneFakeFire
	Namespace: _gadget_clone
	Checksum: 0x2DA9D60E
	Offset: 0x28F8
	Size: 0x257
	Parameters: 0
	Flags: None
*/
function _CloneFakeFire()
{
	clone = self;
	clone endon("clone_shutdown");
	clone endon("death");
	while(1)
	{
		waitTime = RandomFloatRange(0.5, 3);
		wait(waitTime);
		shotsfired = randomIntRange(1, 4);
		if(isdefined(clone.fakeFireWeapon) && clone.fakeFireWeapon != level.weaponNone)
		{
			players = GetPlayers();
			foreach(player in players)
			{
				if(isdefined(player) && isalive(player) && player getteam() != clone.team)
				{
					if(DistanceSquared(player.origin, clone.origin) < 562500)
					{
						if(clone cansee(player))
						{
							clone FakeFire(clone.owner, clone.origin, clone.fakeFireWeapon, shotsfired);
							break;
						}
					}
				}
			}
		}
		wait(shotsfired / 2);
		clone SetFakeFire(0);
	}
}

/*
	Name: _CloneSelectWeapon
	Namespace: _gadget_clone
	Checksum: 0x14575A59
	Offset: 0x2B58
	Size: 0x19F
	Parameters: 1
	Flags: None
*/
function _CloneSelectWeapon(player)
{
	clone = self;
	items = _CloneBuildItemList(player);
	playerWeapon = player GetCurrentWeapon();
	ball = GetWeapon("ball");
	if(isdefined(playerWeapon) && isdefined(ball) && playerWeapon == ball)
	{
		weapon = ball;
	}
	else if(isdefined(playerWeapon.worldmodel) && _TestPlayerWeapon(playerWeapon, items["primary"]))
	{
		weapon = playerWeapon;
	}
	else if(isdefined(level.var_7ce7fbed))
	{
		weapon = [[level.var_7ce7fbed]](player);
	}
	else
	{
		weapon = undefined;
	}
	if(!isdefined(weapon))
	{
		weapon = _ChooseWeapon(player);
	}
	if(isdefined(weapon))
	{
		clone shared::placeWeaponOn(weapon, "right");
		clone.fakeFireWeapon = weapon;
	}
}

/*
	Name: _CloneBuildItemList
	Namespace: _gadget_clone
	Checksum: 0x9526AE3
	Offset: 0x2D00
	Size: 0x207
	Parameters: 1
	Flags: None
*/
function _CloneBuildItemList(player)
{
	PixBeginEvent("clone_build_item_list");
	items = [];
	for(i = 0; i < 256; i++)
	{
		row = TableLookupRowNum(level.statsTableID, 0, i);
		if(row > -1)
		{
			slot = TableLookupColumnForRow(level.statsTableID, row, 13);
			if(slot == "")
			{
				continue;
			}
			Number = Int(TableLookupColumnForRow(level.statsTableID, row, 0));
			if(player IsItemLocked(Number))
			{
				continue;
			}
			allocation = Int(TableLookupColumnForRow(level.statsTableID, row, 12));
			if(allocation < 0)
			{
				continue;
			}
			name = TableLookupColumnForRow(level.statsTableID, row, 3);
			if(!isdefined(items[slot]))
			{
				items[slot] = [];
			}
			items[slot][items[slot].size] = name;
		}
	}
	PixEndEvent();
	return items;
}

/*
	Name: _ChooseWeapon
	Namespace: _gadget_clone
	Checksum: 0xA01E260A
	Offset: 0x2F10
	Size: 0xA9
	Parameters: 1
	Flags: Private
*/
function private _ChooseWeapon(player)
{
	classNum = RandomInt(10);
	for(i = 0; i < 10; i++)
	{
		weapon = player GetLoadoutWeapon(i + classNum % 10, "primary");
		if(weapon != level.weaponNone)
		{
			break;
		}
	}
	return weapon;
}

/*
	Name: _TestPlayerWeapon
	Namespace: _gadget_clone
	Checksum: 0x1381EC34
	Offset: 0x2FC8
	Size: 0x9D
	Parameters: 2
	Flags: Private
*/
function private _TestPlayerWeapon(playerWeapon, items)
{
	if(!isdefined(items) || !items.size || !isdefined(playerWeapon))
	{
		return 0;
	}
	for(i = 0; i < items.size; i++)
	{
		displayName = items[i];
		if(playerWeapon.displayName == displayName)
		{
			return 1;
		}
	}
	return 0;
}

