#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

#namespace zombie_utility;

/*
	Name: zombieSpawnSetup
	Namespace: zombie_utility
	Checksum: 0x3391397
	Offset: 0x748
	Size: 0xCF
	Parameters: 0
	Flags: None
*/
function zombieSpawnSetup()
{
	self.zombie_move_speed = "walk";
	if(!isdefined(self.zombie_arms_position))
	{
		if(RandomInt(2) == 0)
		{
			self.zombie_arms_position = "up";
		}
		else
		{
			self.zombie_arms_position = "down";
		}
	}
	self.missingLegs = 0;
	self SetAvoidanceMask("avoid none");
	self PushActors(1);
	clientfield::set("zombie", 1);
	self.ignorepathenemyfightdist = 1;
}

/*
	Name: get_closest_valid_player
	Namespace: zombie_utility
	Checksum: 0x884FFF41
	Offset: 0x820
	Size: 0x2E5
	Parameters: 3
	Flags: None
*/
function get_closest_valid_player(origin, ignore_player, ignore_laststand_players)
{
	if(!isdefined(ignore_laststand_players))
	{
		ignore_laststand_players = 0;
	}
	PixBeginEvent("get_closest_valid_player");
	valid_player_found = 0;
	targets = GetPlayers();
	if(isdefined(level.closest_player_targets_override))
	{
		targets = [[level.closest_player_targets_override]]();
	}
	if(isdefined(ignore_player))
	{
		for(i = 0; i < ignore_player.size; i++)
		{
			ArrayRemoveValue(targets, ignore_player[i]);
		}
	}
	done = 1;
	while(targets.size && !done)
	{
		done = 1;
		for(i = 0; i < targets.size; i++)
		{
			target = targets[i];
			if(!is_player_valid(target, 1, ignore_laststand_players))
			{
				ArrayRemoveValue(targets, target);
				done = 0;
				break;
			}
		}
	}
	if(targets.size == 0)
	{
		PixEndEvent();
		return undefined;
	}
	if(isdefined(self.closest_player_override))
	{
		target = [[self.closest_player_override]](origin, targets);
	}
	else if(isdefined(level.closest_player_override))
	{
		target = [[level.closest_player_override]](origin, targets);
	}
	if(isdefined(target))
	{
		PixEndEvent();
		return target;
	}
	sortedPotentialTargets = ArraySortClosest(targets, self.origin);
	while(sortedPotentialTargets.size)
	{
		if(is_player_valid(sortedPotentialTargets[0], 1, ignore_laststand_players))
		{
			PixEndEvent();
			return sortedPotentialTargets[0];
		}
		ArrayRemoveValue(sortedPotentialTargets, sortedPotentialTargets[0]);
	}
	PixEndEvent();
	return undefined;
}

/*
	Name: is_player_valid
	Namespace: zombie_utility
	Checksum: 0xD3EA5F4
	Offset: 0xB10
	Size: 0x19F
	Parameters: 3
	Flags: None
*/
function is_player_valid(player, checkIgnoreMeFlag, ignore_laststand_players)
{
	if(!isdefined(player))
	{
		return 0;
	}
	if(!isalive(player))
	{
		return 0;
	}
	if(!isPlayer(player))
	{
		return 0;
	}
	if(isdefined(player.is_zombie) && player.is_zombie == 1)
	{
		return 0;
	}
	if(player.sessionstate == "spectator")
	{
		return 0;
	}
	if(player.sessionstate == "intermission")
	{
		return 0;
	}
	if(isdefined(player.intermission) && player.intermission)
	{
		return 0;
	}
	if(!(isdefined(ignore_laststand_players) && ignore_laststand_players))
	{
		if(player laststand::player_is_in_laststand())
		{
			return 0;
		}
	}
	if(player IsNoTarget())
	{
		return 0;
	}
	if(isdefined(checkIgnoreMeFlag) && checkIgnoreMeFlag && player.ignoreme)
	{
		return 0;
	}
	if(isdefined(level.is_player_valid_override))
	{
		return [[level.is_player_valid_override]](player);
	}
	return 1;
}

/*
	Name: append_missing_legs_suffix
	Namespace: zombie_utility
	Checksum: 0x4169AD05
	Offset: 0xCB8
	Size: 0x49
	Parameters: 1
	Flags: None
*/
function append_missing_legs_suffix(animstate)
{
	if(self.missingLegs && self HasAnimStateFromASD(animstate + "_crawl"))
	{
		return animstate + "_crawl";
	}
	return animstate;
}

/*
	Name: initAnimTree
	Namespace: zombie_utility
	Checksum: 0xA97FCBDD
	Offset: 0xD10
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function initAnimTree(animscript)
{
	if(animscript != "pain" && animscript != "death")
	{
		self.a.special = "none";
	}
	/#
		Assert(isdefined(animscript), "Dev Block strings are not supported");
	#/
	self.a.script = animscript;
}

/*
	Name: UpdateAnimPose
	Namespace: zombie_utility
	Checksum: 0x4F1FB2EF
	Offset: 0xD98
	Size: 0xA5
	Parameters: 0
	Flags: None
*/
function UpdateAnimPose()
{
	/#
		Assert(self.a.movement == "Dev Block strings are not supported" || self.a.movement == "Dev Block strings are not supported" || self.a.movement == "Dev Block strings are not supported", "Dev Block strings are not supported" + self.a.pose + "Dev Block strings are not supported" + self.a.movement);
	#/
	self.desired_anim_pose = undefined;
}

/*
	Name: Initialize
	Namespace: zombie_utility
	Checksum: 0x4DFD7A80
	Offset: 0xE48
	Size: 0x213
	Parameters: 1
	Flags: None
*/
function Initialize(animscript)
{
	if(isdefined(self.longDeathStarting))
	{
		if(animscript != "pain" && animscript != "death")
		{
			self DoDamage(self.health + 100, self.origin);
		}
		if(animscript != "pain")
		{
			self.longDeathStarting = undefined;
			self notify("kill_long_death");
		}
	}
	if(isdefined(self.a.mayOnlyDie) && animscript != "death")
	{
		self DoDamage(self.health + 100, self.origin);
	}
	if(isdefined(self.a.postScriptFunc))
	{
		scriptFunc = self.a.postScriptFunc;
		self.a.postScriptFunc = undefined;
		[[scriptFunc]](animscript);
	}
	if(animscript != "death")
	{
		self.a.nodeath = 0;
	}
	self.isHoldingGrenade = undefined;
	self.coverNode = undefined;
	self.changingCoverPos = 0;
	self.a.scriptStartTime = GetTime();
	self.a.atConcealmentNode = 0;
	if(isdefined(self.node) && (self.node.type == "Conceal Crouch" || self.node.type == "Conceal Stand"))
	{
		self.a.atConcealmentNode = 1;
	}
	initAnimTree(animscript);
	UpdateAnimPose();
}

/*
	Name: GetNodeYawToOrigin
	Namespace: zombie_utility
	Checksum: 0x40933A12
	Offset: 0x1068
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function GetNodeYawToOrigin(pos)
{
	if(isdefined(self.node))
	{
		yaw = self.node.angles[1] - GetYaw(pos);
	}
	else
	{
		yaw = self.angles[1] - GetYaw(pos);
	}
	yaw = AngleClamp180(yaw);
	return yaw;
}

/*
	Name: GetNodeYawToEnemy
	Namespace: zombie_utility
	Checksum: 0x46671FF6
	Offset: 0x1118
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function GetNodeYawToEnemy()
{
	pos = undefined;
	if(isValidEnemy(self.enemy))
	{
		pos = self.enemy.origin;
	}
	else if(isdefined(self.node))
	{
		FORWARD = AnglesToForward(self.node.angles);
	}
	else
	{
		FORWARD = AnglesToForward(self.angles);
	}
	FORWARD = VectorScale(FORWARD, 150);
	pos = self.origin + FORWARD;
	if(isdefined(self.node))
	{
		yaw = self.node.angles[1] - GetYaw(pos);
	}
	else
	{
		yaw = self.angles[1] - GetYaw(pos);
	}
	yaw = AngleClamp180(yaw);
	return yaw;
}

/*
	Name: GetCoverNodeYawToEnemy
	Namespace: zombie_utility
	Checksum: 0xBC46F941
	Offset: 0x1280
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function GetCoverNodeYawToEnemy()
{
	pos = undefined;
	if(isValidEnemy(self.enemy))
	{
		pos = self.enemy.origin;
	}
	else
	{
		FORWARD = AnglesToForward(self.coverNode.angles + self.animarray["angle_step_out"][self.a.cornerMode]);
		FORWARD = VectorScale(FORWARD, 150);
		pos = self.origin + FORWARD;
	}
	yaw = self.coverNode.angles[1] + self.animarray["angle_step_out"][self.a.cornerMode] - GetYaw(pos);
	yaw = AngleClamp180(yaw);
	return yaw;
}

/*
	Name: GetYawToSpot
	Namespace: zombie_utility
	Checksum: 0xBA0E7779
	Offset: 0x13D0
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function GetYawToSpot(spot)
{
	pos = spot;
	yaw = self.angles[1] - GetYaw(pos);
	yaw = AngleClamp180(yaw);
	return yaw;
}

/*
	Name: getYawToEnemy
	Namespace: zombie_utility
	Checksum: 0x39F9E1F6
	Offset: 0x1450
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function getYawToEnemy()
{
	pos = undefined;
	if(isValidEnemy(self.enemy))
	{
		pos = self.enemy.origin;
	}
	else
	{
		FORWARD = AnglesToForward(self.angles);
		FORWARD = VectorScale(FORWARD, 150);
		pos = self.origin + FORWARD;
	}
	yaw = self.angles[1] - GetYaw(pos);
	yaw = AngleClamp180(yaw);
	return yaw;
}

/*
	Name: GetYaw
	Namespace: zombie_utility
	Checksum: 0xD2926167
	Offset: 0x1540
	Size: 0x41
	Parameters: 1
	Flags: None
*/
function GetYaw(org)
{
	angles = VectorToAngles(org - self.origin);
	return angles[1];
}

/*
	Name: GetYaw2d
	Namespace: zombie_utility
	Checksum: 0x7EC814E7
	Offset: 0x1590
	Size: 0x69
	Parameters: 1
	Flags: None
*/
function GetYaw2d(org)
{
	angles = VectorToAngles((org[0], org[1], 0) - (self.origin[0], self.origin[1], 0));
	return angles[1];
}

/*
	Name: AbsYawToEnemy
	Namespace: zombie_utility
	Checksum: 0x91006C28
	Offset: 0x1608
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function AbsYawToEnemy()
{
	/#
		Assert(isValidEnemy(self.enemy));
	#/
	yaw = self.angles[1] - GetYaw(self.enemy.origin);
	yaw = AngleClamp180(yaw);
	if(yaw < 0)
	{
		yaw = -1 * yaw;
	}
	return yaw;
}

/*
	Name: AbsYawToEnemy2d
	Namespace: zombie_utility
	Checksum: 0x296B2BAD
	Offset: 0x16C0
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function AbsYawToEnemy2d()
{
	/#
		Assert(isValidEnemy(self.enemy));
	#/
	yaw = self.angles[1] - GetYaw2d(self.enemy.origin);
	yaw = AngleClamp180(yaw);
	if(yaw < 0)
	{
		yaw = -1 * yaw;
	}
	return yaw;
}

/*
	Name: AbsYawToOrigin
	Namespace: zombie_utility
	Checksum: 0x626B22A4
	Offset: 0x1778
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function AbsYawToOrigin(org)
{
	yaw = self.angles[1] - GetYaw(org);
	yaw = AngleClamp180(yaw);
	if(yaw < 0)
	{
		yaw = -1 * yaw;
	}
	return yaw;
}

/*
	Name: AbsYawToAngles
	Namespace: zombie_utility
	Checksum: 0x158B181E
	Offset: 0x17F8
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function AbsYawToAngles(angles)
{
	yaw = self.angles[1] - angles;
	yaw = AngleClamp180(yaw);
	if(yaw < 0)
	{
		yaw = -1 * yaw;
	}
	return yaw;
}

/*
	Name: GetYawFromOrigin
	Namespace: zombie_utility
	Checksum: 0x74DD03DB
	Offset: 0x1868
	Size: 0x49
	Parameters: 2
	Flags: None
*/
function GetYawFromOrigin(org, start)
{
	angles = VectorToAngles(org - start);
	return angles[1];
}

/*
	Name: GetYawToTag
	Namespace: zombie_utility
	Checksum: 0x553C0875
	Offset: 0x18C0
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function GetYawToTag(tag, org)
{
	yaw = self GetTagAngles(tag)[1] - GetYawFromOrigin(org, self GetTagOrigin(tag));
	yaw = AngleClamp180(yaw);
	return yaw;
}

/*
	Name: GetYawToOrigin
	Namespace: zombie_utility
	Checksum: 0xDEAA4F52
	Offset: 0x1958
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function GetYawToOrigin(org)
{
	yaw = self.angles[1] - GetYaw(org);
	yaw = AngleClamp180(yaw);
	return yaw;
}

/*
	Name: GetEyeYawToOrigin
	Namespace: zombie_utility
	Checksum: 0x273F7FDC
	Offset: 0x19C0
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function GetEyeYawToOrigin(org)
{
	yaw = self GetTagAngles("TAG_EYE")[1] - GetYaw(org);
	yaw = AngleClamp180(yaw);
	return yaw;
}

/*
	Name: GetCoverNodeYawToOrigin
	Namespace: zombie_utility
	Checksum: 0xB3C45013
	Offset: 0x1A40
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function GetCoverNodeYawToOrigin(org)
{
	yaw = self.coverNode.angles[1] + self.animarray["angle_step_out"][self.a.cornerMode] - GetYaw(org);
	yaw = AngleClamp180(yaw);
	return yaw;
}

/*
	Name: isStanceAllowedWrapper
	Namespace: zombie_utility
	Checksum: 0xF6AE4FB6
	Offset: 0x1AD8
	Size: 0x49
	Parameters: 1
	Flags: None
*/
function isStanceAllowedWrapper(stance)
{
	if(isdefined(self.coverNode))
	{
		return self.coverNode doesNodeAllowStance(stance);
	}
	return self IsStanceAllowed(stance);
}

/*
	Name: GetClaimedNode
	Namespace: zombie_utility
	Checksum: 0x767B0B2
	Offset: 0x1B30
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function GetClaimedNode()
{
	myNode = self.node;
	if(isdefined(myNode) && (self nearNode(myNode) || (isdefined(self.coverNode) && myNode == self.coverNode)))
	{
		return myNode;
	}
	return undefined;
}

/*
	Name: GetNodeType
	Namespace: zombie_utility
	Checksum: 0x5BE591D9
	Offset: 0x1BA0
	Size: 0x3D
	Parameters: 0
	Flags: None
*/
function GetNodeType()
{
	myNode = GetClaimedNode();
	if(isdefined(myNode))
	{
		return myNode.type;
	}
	return "none";
}

/*
	Name: GetNodeDirection
	Namespace: zombie_utility
	Checksum: 0x31AB9B92
	Offset: 0x1BE8
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function GetNodeDirection()
{
	myNode = GetClaimedNode();
	if(isdefined(myNode))
	{
		return myNode.angles[1];
	}
	return self.desiredAngle;
}

/*
	Name: GetNodeForward
	Namespace: zombie_utility
	Checksum: 0x4628D046
	Offset: 0x1C38
	Size: 0x61
	Parameters: 0
	Flags: None
*/
function GetNodeForward()
{
	myNode = GetClaimedNode();
	if(isdefined(myNode))
	{
		return AnglesToForward(myNode.angles);
	}
	return AnglesToForward(self.angles);
}

/*
	Name: GetNodeOrigin
	Namespace: zombie_utility
	Checksum: 0x90526271
	Offset: 0x1CA8
	Size: 0x3D
	Parameters: 0
	Flags: None
*/
function GetNodeOrigin()
{
	myNode = GetClaimedNode();
	if(isdefined(myNode))
	{
		return myNode.origin;
	}
	return self.origin;
}

/*
	Name: safemod
	Namespace: zombie_utility
	Checksum: 0x3AE2699
	Offset: 0x1CF0
	Size: 0x57
	Parameters: 2
	Flags: None
*/
function safemod(a, b)
{
	result = Int(a) % b;
	result = result + b;
	return result % b;
}

/*
	Name: AngleClamp
	Namespace: zombie_utility
	Checksum: 0xFB967858
	Offset: 0x1D50
	Size: 0x55
	Parameters: 1
	Flags: None
*/
function AngleClamp(angle)
{
	angleFrac = angle / 360;
	angle = angleFrac - floor(angleFrac) * 360;
	return angle;
}

/*
	Name: QuadrantAnimWeights
	Namespace: zombie_utility
	Checksum: 0x1B8B7754
	Offset: 0x1DB0
	Size: 0x265
	Parameters: 1
	Flags: None
*/
function QuadrantAnimWeights(yaw)
{
	forwardWeight = 90 - Abs(yaw) / 90;
	leftWeight = 90 - AbsAngleClamp180(Abs(yaw - 90)) / 90;
	result["front"] = 0;
	result["right"] = 0;
	result["back"] = 0;
	result["left"] = 0;
	if(isdefined(self.alwaysRunForward))
	{
		/#
			Assert(self.alwaysRunForward);
		#/
		result["front"] = 1;
		return result;
	}
	useLeans = GetDvarInt("ai_useLeanRunAnimations");
	if(forwardWeight > 0)
	{
		result["front"] = forwardWeight;
		if(leftWeight > 0)
		{
			result["left"] = leftWeight;
		}
		else
		{
			result["right"] = -1 * leftWeight;
		}
	}
	else if(useLeans)
	{
		result["back"] = -1 * forwardWeight;
		if(leftWeight > 0)
		{
			result["left"] = leftWeight;
		}
		else
		{
			result["right"] = -1 * leftWeight;
		}
	}
	else
	{
		backWeight = -1 * forwardWeight;
		if(leftWeight > backWeight)
		{
			result["left"] = 1;
		}
		else if(leftWeight < forwardWeight)
		{
			result["right"] = 1;
		}
		else
		{
			result["back"] = 1;
		}
	}
	return result;
}

/*
	Name: getQuadrant
	Namespace: zombie_utility
	Checksum: 0x2E9EEC92
	Offset: 0x2020
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function getQuadrant(angle)
{
	angle = AngleClamp(angle);
	if(angle < 45 || angle > 315)
	{
		quadrant = "front";
	}
	else if(angle < 135)
	{
		quadrant = "left";
	}
	else if(angle < 225)
	{
		quadrant = "back";
	}
	else
	{
		quadrant = "right";
	}
	return quadrant;
}

/*
	Name: IsInSet
	Namespace: zombie_utility
	Checksum: 0x78A05E0E
	Offset: 0x20D8
	Size: 0x5F
	Parameters: 2
	Flags: None
*/
function IsInSet(input, set)
{
	for(i = set.size - 1; i >= 0; i--)
	{
		if(input == set[i])
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: NotifyAfterTime
	Namespace: zombie_utility
	Checksum: 0xE063B167
	Offset: 0x2140
	Size: 0x3D
	Parameters: 3
	Flags: None
*/
function NotifyAfterTime(notifyString, killmestring, time)
{
	self endon("death");
	self endon(killmestring);
	wait(time);
	self notify(notifyString);
}

/*
	Name: drawStringTime
	Namespace: zombie_utility
	Checksum: 0x2756DD78
	Offset: 0x2188
	Size: 0x95
	Parameters: 4
	Flags: None
*/
function drawStringTime(msg, org, color, timer)
{
	/#
		maxTime = timer * 20;
		for(i = 0; i < maxTime; i++)
		{
			print3d(org, msg, color, 1, 1);
			wait(0.05);
		}
	#/
}

/*
	Name: showLastEnemySightPos
	Namespace: zombie_utility
	Checksum: 0x82B288BB
	Offset: 0x2228
	Size: 0xFF
	Parameters: 1
	Flags: None
*/
function showLastEnemySightPos(string)
{
	/#
		self notify("got known enemy2");
		self endon("got known enemy2");
		self endon("death");
		if(!isValidEnemy(self.enemy))
		{
			return;
		}
		if(self.enemy.team == "Dev Block strings are not supported")
		{
			color = (0.4, 0.7, 1);
			continue;
		}
		color = (1, 0.7, 0.4);
		while(1)
		{
			wait(0.05);
			if(!isdefined(self.lastEnemySightPos))
			{
				continue;
			}
			print3d(self.lastEnemySightPos, string, color, 1, 2.15);
		}
	#/
}

/*
	Name: debugTimeout
	Namespace: zombie_utility
	Checksum: 0xC4E4F278
	Offset: 0x2330
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function debugTimeout()
{
	wait(5);
	self notify("timeout");
}

/*
	Name: debugPosInternal
	Namespace: zombie_utility
	Checksum: 0xA52B3DA9
	Offset: 0x2350
	Size: 0x11F
	Parameters: 3
	Flags: None
*/
function debugPosInternal(org, string, SIZE)
{
	/#
		self endon("death");
		self notify("Dev Block strings are not supported" + org);
		self endon("Dev Block strings are not supported" + org);
		ent = spawnstruct();
		ent thread debugTimeout();
		ent endon("timeout");
		if(self.enemy.team == "Dev Block strings are not supported")
		{
			color = (0.4, 0.7, 1);
			continue;
		}
		color = (1, 0.7, 0.4);
		while(1)
		{
			wait(0.05);
			print3d(org, string, color, 1, SIZE);
		}
	#/
}

/*
	Name: debugPos
	Namespace: zombie_utility
	Checksum: 0xA32AA93E
	Offset: 0x2478
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function debugPos(org, string)
{
	thread debugPosInternal(org, string, 2.15);
}

/*
	Name: debugPosSize
	Namespace: zombie_utility
	Checksum: 0x96BBA678
	Offset: 0x24B8
	Size: 0x3B
	Parameters: 3
	Flags: None
*/
function debugPosSize(org, string, SIZE)
{
	thread debugPosInternal(org, string, SIZE);
}

/*
	Name: showDebugProc
	Namespace: zombie_utility
	Checksum: 0xDC4373FC
	Offset: 0x2500
	Size: 0x9F
	Parameters: 4
	Flags: None
*/
function showDebugProc(fromPoint, toPoint, color, printTime)
{
	/#
		self endon("death");
		timer = printTime * 20;
		for(i = 0; i < timer;  = 0)
		{
			wait(0.05);
			line(fromPoint, toPoint, color);
		}
	#/
}

/*
	Name: showDebugLine
	Namespace: zombie_utility
	Checksum: 0x6D667A80
	Offset: 0x25A8
	Size: 0x5B
	Parameters: 4
	Flags: None
*/
function showDebugLine(fromPoint, toPoint, color, printTime)
{
	self thread showDebugProc(fromPoint, toPoint + VectorScale((0, 0, -1), 5), color, printTime);
}

/*
	Name: getNodeOffset
	Namespace: zombie_utility
	Checksum: 0xCC6799FC
	Offset: 0x2610
	Size: 0x339
	Parameters: 1
	Flags: None
*/
function getNodeOffset(node)
{
	if(isdefined(node.offset))
	{
		return node.offset;
	}
	cover_left_crouch_offset = (-26, 0.4, 36);
	cover_left_stand_offset = (-32, 7, 63);
	cover_right_crouch_offset = (43.5, 11, 36);
	cover_right_stand_offset = (36, 8.3, 63);
	cover_crouch_offset = (3.5, -12.5, 45);
	cover_stand_offset = (-3.7, -22, 63);
	cornernode = 0;
	nodeOffset = (0, 0, 0);
	right = AnglesToRight(node.angles);
	FORWARD = AnglesToForward(node.angles);
	switch(node.type)
	{
		case "Cover Left":
		case "Cover Left Wide":
		{
			if(node isNodeDontStand() && !node isNodeDontCrouch())
			{
				nodeOffset = calculateNodeOffset(right, FORWARD, cover_left_crouch_offset);
			}
			else
			{
				nodeOffset = calculateNodeOffset(right, FORWARD, cover_left_stand_offset);
			}
			break;
		}
		case "Cover Right":
		case "Cover Right Wide":
		{
			if(node isNodeDontStand() && !node isNodeDontCrouch())
			{
				nodeOffset = calculateNodeOffset(right, FORWARD, cover_right_crouch_offset);
			}
			else
			{
				nodeOffset = calculateNodeOffset(right, FORWARD, cover_right_stand_offset);
			}
			break;
		}
		case "Conceal Stand":
		case "Cover Stand":
		case "Turret":
		{
			nodeOffset = calculateNodeOffset(right, FORWARD, cover_stand_offset);
			break;
		}
		case "Conceal Crouch":
		case "Cover Crouch":
		case "Cover Crouch Window":
		{
			nodeOffset = calculateNodeOffset(right, FORWARD, cover_crouch_offset);
			break;
		}
	}
	node.offset = nodeOffset;
	return node.offset;
}

/*
	Name: calculateNodeOffset
	Namespace: zombie_utility
	Checksum: 0x8935161
	Offset: 0x2958
	Size: 0x4D
	Parameters: 3
	Flags: None
*/
function calculateNodeOffset(right, FORWARD, baseoffset)
{
	return VectorScale(right, baseoffset[0]) + VectorScale(FORWARD, baseoffset[1]) + (0, 0, baseoffset[2]);
}

/*
	Name: checkPitchVisibility
	Namespace: zombie_utility
	Checksum: 0x44EFD1D8
	Offset: 0x29B0
	Size: 0xE5
	Parameters: 3
	Flags: None
*/
function checkPitchVisibility(fromPoint, toPoint, atNode)
{
	pitch = AngleClamp180(VectorToAngles(toPoint - fromPoint)[0]);
	if(Abs(pitch) > 45)
	{
		if(isdefined(atNode) && atNode.type != "Cover Crouch" && atNode.type != "Conceal Crouch")
		{
			return 0;
		}
		if(pitch > 45 || pitch < anim.coverCrouchLeanPitch - 45)
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: showLines
	Namespace: zombie_utility
	Checksum: 0x45D4391
	Offset: 0x2AA0
	Size: 0x77
	Parameters: 3
	Flags: None
*/
function showLines(start, end, end2)
{
	/#
		for(;;)
		{
			line(start, end, (1, 0, 0), 1);
			wait(0.05);
			line(start, end2, (0, 0, 1), 1);
			wait(0.05);
		}
	#/
}

/*
	Name: anim_array
	Namespace: zombie_utility
	Checksum: 0xA67F333A
	Offset: 0x2B20
	Size: 0x197
	Parameters: 2
	Flags: None
*/
function anim_array(animarray, animWeights)
{
	total_anims = animarray.size;
	idleanim = RandomInt(total_anims);
	/#
		Assert(total_anims);
	#/
	/#
		Assert(animarray.size == animWeights.size);
	#/
	if(total_anims == 1)
	{
		return animarray[0];
	}
	weights = 0;
	total_weight = 0;
	for(i = 0; i < total_anims; i++)
	{
		total_weight = total_weight + animWeights[i];
	}
	anim_play = RandomFloat(total_weight);
	current_weight = 0;
	for(i = 0; i < total_anims; i++)
	{
		current_weight = current_weight + animWeights[i];
		if(anim_play >= current_weight)
		{
			continue;
		}
		idleanim = i;
		break;
	}
	return animarray[idleanim];
}

/*
	Name: notForcedCover
	Namespace: zombie_utility
	Checksum: 0xCF57C382
	Offset: 0x2CC0
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function notForcedCover()
{
	return self.a.forced_cover == "none" || self.a.forced_cover == "Show";
}

/*
	Name: forcedCover
	Namespace: zombie_utility
	Checksum: 0x60BEF587
	Offset: 0x2D00
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function forcedCover(msg)
{
	return isdefined(self.a.forced_cover) && self.a.forced_cover == msg;
}

/*
	Name: print3dtime
	Namespace: zombie_utility
	Checksum: 0xD38243EC
	Offset: 0x2D40
	Size: 0xA5
	Parameters: 6
	Flags: None
*/
function print3dtime(timer, org, msg, color, alpha, scale)
{
	/#
		newTime = timer / 0.05;
		for(i = 0; i < newTime; i++)
		{
			print3d(org, msg, color, alpha, scale);
			wait(0.05);
		}
	#/
}

/*
	Name: print3drise
	Namespace: zombie_utility
	Checksum: 0x762FC8C1
	Offset: 0x2DF0
	Size: 0xD5
	Parameters: 5
	Flags: None
*/
function print3drise(org, msg, color, alpha, scale)
{
	/#
		newTime = 100;
		up = 0;
		org = org;
		for(i = 0; i < newTime; i++)
		{
			up = up + 0.5;
			print3d(org + (0, 0, up), msg, color, alpha, scale);
			wait(0.05);
		}
	#/
}

/*
	Name: crossproduct
	Namespace: zombie_utility
	Checksum: 0x7B09756
	Offset: 0x2ED0
	Size: 0x41
	Parameters: 2
	Flags: None
*/
function crossproduct(vec1, vec2)
{
	return vec1[0] * vec2[1] - vec1[1] * vec2[0] > 0;
}

/*
	Name: scriptChange
	Namespace: zombie_utility
	Checksum: 0xDB7EC4C7
	Offset: 0x2F20
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function scriptChange()
{
	self.a.current_script = "none";
	self notify(anim.scriptChange);
}

/*
	Name: delayedScriptChange
	Namespace: zombie_utility
	Checksum: 0xF526F987
	Offset: 0x2F58
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function delayedScriptChange()
{
	wait(0.05);
	scriptChange();
}

/*
	Name: sawEnemyMove
	Namespace: zombie_utility
	Checksum: 0x6CF78475
	Offset: 0x2F80
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function sawEnemyMove(timer)
{
	if(!isdefined(timer))
	{
		timer = 500;
	}
	return GetTime() - self.personalSightTime < timer;
}

/*
	Name: canThrowGrenade
	Namespace: zombie_utility
	Checksum: 0xF1397BF3
	Offset: 0x2FC0
	Size: 0x39
	Parameters: 0
	Flags: None
*/
function canThrowGrenade()
{
	if(!self.grenadeAmmo)
	{
		return 0;
	}
	if(self.script_forceGrenade)
	{
		return 1;
	}
	return isPlayer(self.enemy);
}

/*
	Name: random_weight
	Namespace: zombie_utility
	Checksum: 0x761AA871
	Offset: 0x3008
	Size: 0x10F
	Parameters: 1
	Flags: None
*/
function random_weight(Array)
{
	idleanim = RandomInt(Array.size);
	if(Array.size > 1)
	{
		anim_weight = 0;
		for(i = 0; i < Array.size; i++)
		{
			anim_weight = anim_weight + Array[i];
		}
		anim_play = RandomFloat(anim_weight);
		anim_weight = 0;
		for(i = 0; i < Array.size; i++)
		{
			anim_weight = anim_weight + Array[i];
			if(anim_play < anim_weight)
			{
				idleanim = i;
				break;
			}
		}
	}
	return idleanim;
}

/*
	Name: setFootstepEffect
	Namespace: zombie_utility
	Checksum: 0x9506E38D
	Offset: 0x3120
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function setFootstepEffect(name, FX)
{
	/#
		Assert(isdefined(name), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(FX), "Dev Block strings are not supported");
	#/
	if(!isdefined(anim.optionalStepEffects))
	{
		anim.optionalStepEffects = [];
	}
	anim.optionalStepEffects[anim.optionalStepEffects.size] = name;
	level._effect["step_" + name] = FX;
	anim.optionalStepEffectFunction = &zombie_shared::playFootStepEffect;
}

/*
	Name: persistentDebugLine
	Namespace: zombie_utility
	Checksum: 0x552355F3
	Offset: 0x3200
	Size: 0x77
	Parameters: 2
	Flags: None
*/
function persistentDebugLine(start, end)
{
	/#
		self endon("death");
		level notify("newdebugline");
		level endon("newdebugline");
		for(;;)
		{
			line(start, end, (0.3, 1, 0), 1);
			wait(0.05);
		}
	#/
}

/*
	Name: isNodeDontStand
	Namespace: zombie_utility
	Checksum: 0x143612E6
	Offset: 0x3280
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function isNodeDontStand()
{
	return self.SPAWNFLAGS & 4 == 4;
}

/*
	Name: isNodeDontCrouch
	Namespace: zombie_utility
	Checksum: 0x2C2E7FFA
	Offset: 0x32A0
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function isNodeDontCrouch()
{
	return self.SPAWNFLAGS & 8 == 8;
}

/*
	Name: doesNodeAllowStance
	Namespace: zombie_utility
	Checksum: 0x421E081F
	Offset: 0x32C0
	Size: 0x75
	Parameters: 1
	Flags: None
*/
function doesNodeAllowStance(stance)
{
	if(stance == "stand")
	{
		return !self isNodeDontStand();
	}
	else
	{
		Assert(stance == "Dev Block strings are not supported");
		return !self isNodeDontCrouch();
	}
	/#
	#/
}

/*
	Name: animarray
	Namespace: zombie_utility
	Checksum: 0x93E9D02A
	Offset: 0x3340
	Size: 0xB7
	Parameters: 1
	Flags: None
*/
function animarray(animName)
{
	/#
		Assert(isdefined(self.a.Array));
	#/
	/#
		if(!isdefined(self.a.Array[animName]))
		{
			dumpAnimArray();
			/#
				Assert(isdefined(self.a.Array[animName]), "Dev Block strings are not supported" + animName + "Dev Block strings are not supported");
			#/
		}
	#/
	return self.a.Array[animName];
}

/*
	Name: animArrayAnyExist
	Namespace: zombie_utility
	Checksum: 0x254F2535
	Offset: 0x3400
	Size: 0xBD
	Parameters: 1
	Flags: None
*/
function animArrayAnyExist(animName)
{
	/#
		Assert(isdefined(self.a.Array));
	#/
	/#
		if(!isdefined(self.a.Array[animName]))
		{
			dumpAnimArray();
			/#
				Assert(isdefined(self.a.Array[animName]), "Dev Block strings are not supported" + animName + "Dev Block strings are not supported");
			#/
		}
	#/
	return self.a.Array[animName].size > 0;
}

/*
	Name: animArrayPickRandom
	Namespace: zombie_utility
	Checksum: 0xA9064623
	Offset: 0x34C8
	Size: 0x14D
	Parameters: 1
	Flags: None
*/
function animArrayPickRandom(animName)
{
	/#
		Assert(isdefined(self.a.Array));
	#/
	/#
		if(!isdefined(self.a.Array[animName]))
		{
			dumpAnimArray();
			/#
				Assert(isdefined(self.a.Array[animName]), "Dev Block strings are not supported" + animName + "Dev Block strings are not supported");
			#/
		}
	#/
	/#
		Assert(self.a.Array[animName].size > 0);
	#/
	if(self.a.Array[animName].size > 1)
	{
		index = RandomInt(self.a.Array[animName].size);
	}
	else
	{
		index = 0;
	}
	return self.a.Array[animName][index];
}

/*
	Name: dumpAnimArray
	Namespace: zombie_utility
	Checksum: 0x8E04679C
	Offset: 0x3620
	Size: 0x14D
	Parameters: 0
	Flags: None
*/
function dumpAnimArray()
{
	/#
		println("Dev Block strings are not supported");
		keys = getArrayKeys(self.a.Array);
		for(i = 0; i < keys.size; i++)
		{
			if(IsArray(self.a.Array[keys[i]]))
			{
				println("Dev Block strings are not supported" + keys[i] + "Dev Block strings are not supported" + self.a.Array[keys[i]].size + "Dev Block strings are not supported");
				continue;
			}
			println("Dev Block strings are not supported" + keys[i] + "Dev Block strings are not supported", self.a.Array[keys[i]]);
		}
	#/
}

/*
	Name: getAnimEndPos
	Namespace: zombie_utility
	Checksum: 0xAF180F87
	Offset: 0x3778
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function getAnimEndPos(theanim)
{
	moveDelta = GetMoveDelta(theanim, 0, 1, self);
	return self LocalToWorldCoords(moveDelta);
}

/*
	Name: isValidEnemy
	Namespace: zombie_utility
	Checksum: 0x1E99411E
	Offset: 0x37D8
	Size: 0x1D
	Parameters: 1
	Flags: None
*/
function isValidEnemy(enemy)
{
	if(!isdefined(enemy))
	{
		return 0;
	}
	return 1;
}

/*
	Name: damageLocationIsAny
	Namespace: zombie_utility
	Checksum: 0xCA1CE13C
	Offset: 0x3800
	Size: 0x225
	Parameters: 12
	Flags: None
*/
function damageLocationIsAny(a, b, c, d, e, f, g, h, i, j, K, ovr)
{
	if(!isdefined(self.damagelocation))
	{
		return 0;
	}
	if(!isdefined(a))
	{
		return 0;
	}
	if(self.damagelocation == a)
	{
		return 1;
	}
	if(!isdefined(b))
	{
		return 0;
	}
	if(self.damagelocation == b)
	{
		return 1;
	}
	if(!isdefined(c))
	{
		return 0;
	}
	if(self.damagelocation == c)
	{
		return 1;
	}
	if(!isdefined(d))
	{
		return 0;
	}
	if(self.damagelocation == d)
	{
		return 1;
	}
	if(!isdefined(e))
	{
		return 0;
	}
	if(self.damagelocation == e)
	{
		return 1;
	}
	if(!isdefined(f))
	{
		return 0;
	}
	if(self.damagelocation == f)
	{
		return 1;
	}
	if(!isdefined(g))
	{
		return 0;
	}
	if(self.damagelocation == g)
	{
		return 1;
	}
	if(!isdefined(h))
	{
		return 0;
	}
	if(self.damagelocation == h)
	{
		return 1;
	}
	if(!isdefined(i))
	{
		return 0;
	}
	if(self.damagelocation == i)
	{
		return 1;
	}
	if(!isdefined(j))
	{
		return 0;
	}
	if(self.damagelocation == j)
	{
		return 1;
	}
	if(!isdefined(K))
	{
		return 0;
	}
	if(self.damagelocation == K)
	{
		return 1;
	}
	/#
		Assert(!isdefined(ovr));
	#/
	return 0;
}

/*
	Name: ragdollDeath
	Namespace: zombie_utility
	Checksum: 0x34A3AD80
	Offset: 0x3A30
	Size: 0xF7
	Parameters: 1
	Flags: None
*/
function ragdollDeath(moveAnim)
{
	self endon("killanimscript");
	lastOrg = self.origin;
	moveVec = (0, 0, 0);
	for(;;)
	{
		wait(0.05);
		force = Distance(self.origin, lastOrg);
		lastOrg = self.origin;
		if(self.health == 1)
		{
			self.a.nodeath = 1;
			self StartRagdoll();
			wait(0.05);
			PhysicsExplosionSphere(lastOrg, 600, 0, force * 0.1);
			self notify("killanimscript");
			return;
		}
	}
}

/*
	Name: isCQBWalking
	Namespace: zombie_utility
	Checksum: 0x8B67D632
	Offset: 0x3B30
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function isCQBWalking()
{
	return isdefined(self.cqbwalking) && self.cqbwalking;
}

/*
	Name: squared
	Namespace: zombie_utility
	Checksum: 0x4056DF3
	Offset: 0x3B50
	Size: 0x15
	Parameters: 1
	Flags: None
*/
function squared(value)
{
	return value * value;
}

/*
	Name: randomizeIdleSet
	Namespace: zombie_utility
	Checksum: 0x2CFC6F7C
	Offset: 0x3B70
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function randomizeIdleSet()
{
	self.a.idleSet = RandomInt(2);
}

/*
	Name: getRandomIntFromSeed
	Namespace: zombie_utility
	Checksum: 0x6A8584FD
	Offset: 0x3BA8
	Size: 0x65
	Parameters: 2
	Flags: None
*/
function getRandomIntFromSeed(intSeed, intMax)
{
	/#
		Assert(intMax > 0);
	#/
	index = intSeed % anim.randomIntTableSize;
	return anim.randomIntTable[index] % intMax;
}

/*
	Name: is_banzai
	Namespace: zombie_utility
	Checksum: 0x17A77267
	Offset: 0x3C18
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function is_banzai()
{
	return isdefined(self.Banzai) && self.Banzai;
}

/*
	Name: is_heavy_machine_gun
	Namespace: zombie_utility
	Checksum: 0xB9912D43
	Offset: 0x3C38
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function is_heavy_machine_gun()
{
	return isdefined(self.heavy_machine_gunner) && self.heavy_machine_gunner;
}

/*
	Name: is_zombie
	Namespace: zombie_utility
	Checksum: 0x9698D414
	Offset: 0x3C58
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function is_zombie()
{
	if(isdefined(self.is_zombie) && self.is_zombie)
	{
		return 1;
	}
	return 0;
}

/*
	Name: is_civilian
	Namespace: zombie_utility
	Checksum: 0xEE783B6F
	Offset: 0x3C88
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function is_civilian()
{
	if(isdefined(self.is_civilian) && self.is_civilian)
	{
		return 1;
	}
	return 0;
}

/*
	Name: is_skeleton
	Namespace: zombie_utility
	Checksum: 0x14ECE863
	Offset: 0x3CB8
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function is_skeleton(skeleton)
{
	if(skeleton == "base" && IsSubStr(get_skeleton(), "scaled"))
	{
		return 1;
	}
	return get_skeleton() == skeleton;
}

/*
	Name: get_skeleton
	Namespace: zombie_utility
	Checksum: 0xC4CC3F44
	Offset: 0x3D28
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function get_skeleton()
{
	if(isdefined(self.skeleton))
	{
		return self.skeleton;
	}
	else
	{
		return "base";
	}
}

/*
	Name: set_orient_mode
	Namespace: zombie_utility
	Checksum: 0xE1B5945
	Offset: 0x3D58
	Size: 0xF3
	Parameters: 2
	Flags: None
*/
function set_orient_mode(mode, val1)
{
	/#
		if(level.dog_debug_orient == self GetEntNum())
		{
			if(isdefined(val1))
			{
				println("Dev Block strings are not supported" + mode + "Dev Block strings are not supported" + val1 + "Dev Block strings are not supported" + GetTime());
			}
			else
			{
				println("Dev Block strings are not supported" + mode + "Dev Block strings are not supported" + GetTime());
			}
		}
	#/
	if(isdefined(val1))
	{
		self OrientMode(mode, val1);
	}
	else
	{
		self OrientMode(mode);
	}
}

/*
	Name: debug_anim_print
	Namespace: zombie_utility
	Checksum: 0x288A36A5
	Offset: 0x3E58
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function debug_anim_print(text)
{
	/#
		if(isdefined(level.dog_debug_anims) && level.dog_debug_anims)
		{
			println(text + "Dev Block strings are not supported" + GetTime());
		}
		if(isdefined(level.dog_debug_anims_ent) && level.dog_debug_anims_ent == self GetEntNum())
		{
			println(text + "Dev Block strings are not supported" + GetTime());
		}
	#/
}

/*
	Name: debug_turn_print
	Namespace: zombie_utility
	Checksum: 0xA4B466E9
	Offset: 0x3F00
	Size: 0x193
	Parameters: 2
	Flags: None
*/
function debug_turn_print(text, line)
{
	/#
		if(isdefined(level.dog_debug_turns) && level.dog_debug_turns == self GetEntNum())
		{
			duration = 200;
			currentYawColor = (1, 1, 1);
			lookaheadYawColor = (1, 0, 0);
			desiredYawColor = (1, 1, 0);
			currentYaw = AngleClamp180(self.angles[1]);
			desiredYaw = AngleClamp180(self.desiredAngle);
			lookaheaddir = self.lookaheaddir;
			lookaheadAngles = VectorToAngles(lookaheaddir);
			lookaheadYaw = AngleClamp180(lookaheadAngles[1]);
			println(text + "Dev Block strings are not supported" + GetTime() + "Dev Block strings are not supported" + currentYaw + "Dev Block strings are not supported" + lookaheadYaw + "Dev Block strings are not supported" + desiredYaw);
		}
	#/
}

/*
	Name: debug_allow_combat
	Namespace: zombie_utility
	Checksum: 0x5E9098AB
	Offset: 0x40A0
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function debug_allow_combat()
{
	/#
		return anim_get_dvar_int("Dev Block strings are not supported", "Dev Block strings are not supported");
	#/
	return 1;
}

/*
	Name: debug_allow_movement
	Namespace: zombie_utility
	Checksum: 0x1E00FA8F
	Offset: 0x40D8
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function debug_allow_movement()
{
	/#
		return anim_get_dvar_int("Dev Block strings are not supported", "Dev Block strings are not supported");
	#/
	return 1;
}

/*
	Name: set_zombie_var
	Namespace: zombie_utility
	Checksum: 0x5E3BE6F9
	Offset: 0x4110
	Size: 0x14D
	Parameters: 5
	Flags: None
*/
function set_zombie_var(zvar, value, is_float, column, is_team_based)
{
	if(!isdefined(is_float))
	{
		is_float = 0;
	}
	if(!isdefined(column))
	{
		column = 1;
	}
	if(!isdefined(is_team_based))
	{
		is_team_based = 0;
	}
	if(!isdefined(level.zombie_vars))
	{
		level.zombie_vars = [];
	}
	if(is_team_based)
	{
		foreach(team in level.teams)
		{
			if(!isdefined(level.zombie_vars[team]))
			{
				level.zombie_vars[team] = [];
			}
			level.zombie_vars[team][zvar] = value;
		}
	}
	else
	{
		level.zombie_vars[zvar] = value;
	}
	return value;
}

/*
	Name: spawn_zombie
	Namespace: zombie_utility
	Checksum: 0xDE68798F
	Offset: 0x4268
	Size: 0x371
	Parameters: 4
	Flags: None
*/
function spawn_zombie(spawner, target_name, spawn_point, round_number)
{
	if(!isdefined(spawner))
	{
		/#
			println("Dev Block strings are not supported");
		#/
		return undefined;
	}
	while(GetFreeActorCount() < 1)
	{
		wait(0.05);
	}
	spawner.script_moveoverride = 1;
	if(isdefined(spawner.script_forcespawn) && spawner.script_forcespawn)
	{
		if(SessionModeIsCampaignZombiesGame())
		{
			guy = spawner spawner::spawn(1);
		}
		else if(IsActorSpawner(spawner) && isdefined(level.overrideZombieSpawn))
		{
			guy = [[level.overrideZombieSpawn]]();
		}
		else
		{
			guy = spawner SpawnFromSpawner(0, 1);
		}
		if(!zombie_spawn_failed(guy))
		{
			guy.spawn_time = GetTime();
			if(isdefined(level.giveExtraZombies))
			{
				guy [[level.giveExtraZombies]]();
			}
			guy EnableAimAssist();
			if(isdefined(round_number))
			{
				guy._starting_round_number = round_number;
			}
			guy.team = level.zombie_team;
			if(IsActor(guy))
			{
				guy ClearEntityOwner();
			}
			level.zombieMeleePlayerCounter = 0;
			if(IsActor(guy))
			{
				guy ForceTeleport(spawner.origin);
			}
			guy show();
			spawner.count = 666;
			if(isdefined(target_name))
			{
				guy.targetname = target_name;
			}
			if(isdefined(spawn_point) && isdefined(level.move_spawn_func))
			{
				guy thread [[level.move_spawn_func]](spawn_point);
			}
			/#
				if(isdefined(spawner.zm_variant_type))
				{
					guy.variant_type = spawner.zm_variant_type;
				}
			#/
			return guy;
		}
		else
		{
			println("Dev Block strings are not supported", spawner.origin);
			return undefined;
		}
		/#
		#/
	}
	else
	{
		println("Dev Block strings are not supported", spawner.origin);
		return undefined;
	}
	/#
	#/
	return undefined;
}

/*
	Name: zombie_spawn_failed
	Namespace: zombie_utility
	Checksum: 0x53195F75
	Offset: 0x45E8
	Size: 0x4D
	Parameters: 1
	Flags: None
*/
function zombie_spawn_failed(spawn)
{
	if(isdefined(spawn) && isalive(spawn))
	{
		if(isalive(spawn))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: get_desired_origin
	Namespace: zombie_utility
	Checksum: 0x6A7F14C4
	Offset: 0x4640
	Size: 0xED
	Parameters: 0
	Flags: None
*/
function get_desired_origin()
{
	if(isdefined(self.target))
	{
		ent = GetEnt(self.target, "targetname");
		if(!isdefined(ent))
		{
			ent = struct::get(self.target, "targetname");
		}
		if(!isdefined(ent))
		{
			ent = GetNode(self.target, "targetname");
		}
		/#
			Assert(isdefined(ent), "Dev Block strings are not supported" + self.target + "Dev Block strings are not supported" + self.origin);
		#/
		return ent.origin;
	}
	return undefined;
}

/*
	Name: hide_pop
	Namespace: zombie_utility
	Checksum: 0x472329F3
	Offset: 0x4738
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function hide_pop()
{
	self endon("death");
	self ghost();
	wait(0.5);
	if(isdefined(self))
	{
		self show();
		util::wait_network_frame();
		if(isdefined(self))
		{
			self.create_eyes = 1;
		}
	}
}

/*
	Name: handle_rise_notetracks
	Namespace: zombie_utility
	Checksum: 0x5CFC9630
	Offset: 0x47B0
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function handle_rise_notetracks(note, spot)
{
	self thread finish_rise_notetracks(note, spot);
}

/*
	Name: finish_rise_notetracks
	Namespace: zombie_utility
	Checksum: 0xECC86D9B
	Offset: 0x47F0
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function finish_rise_notetracks(note, spot)
{
	if(note == "deathout" || note == "deathhigh")
	{
		self.zombie_rise_death_out = 1;
		self notify("zombie_rise_death_out");
		wait(2);
		spot notify("stop_zombie_rise_fx");
	}
}

/*
	Name: zombie_rise_death
	Namespace: zombie_utility
	Checksum: 0xBCF13E9
	Offset: 0x4860
	Size: 0xDB
	Parameters: 2
	Flags: None
*/
function zombie_rise_death(zombie, spot)
{
	zombie.zombie_rise_death_out = 0;
	zombie endon("rise_anim_finished");
	while(isdefined(zombie) && isdefined(zombie.health) && zombie.health > 1)
	{
		zombie waittill("damage", amount);
	}
	if(isdefined(spot))
	{
		spot notify("stop_zombie_rise_fx");
	}
	if(isdefined(zombie))
	{
		zombie.deathAnim = zombie get_rise_death_anim();
		zombie StopAnimScripted();
	}
}

/*
	Name: get_rise_death_anim
	Namespace: zombie_utility
	Checksum: 0xCB082283
	Offset: 0x4948
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function get_rise_death_anim()
{
	if(self.zombie_rise_death_out)
	{
		return "zm_rise_death_out";
	}
	self.noragdoll = 1;
	self.nodeathragdoll = 1;
	return "zm_rise_death_in";
}

/*
	Name: reset_attack_spot
	Namespace: zombie_utility
	Checksum: 0x2FAD8C84
	Offset: 0x4988
	Size: 0x5D
	Parameters: 0
	Flags: None
*/
function reset_attack_spot()
{
	if(isdefined(self.attacking_node))
	{
		node = self.attacking_node;
		index = self.attacking_spot_index;
		node.attack_spots_taken[index] = 0;
		self.attacking_node = undefined;
		self.attacking_spot_index = undefined;
	}
}

/*
	Name: zombie_gut_explosion
	Namespace: zombie_utility
	Checksum: 0x5995F8FB
	Offset: 0x49F0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function zombie_gut_explosion()
{
	self.guts_explosion = 1;
	GibServerUtils::Annihilate(self);
}

/*
	Name: delayed_zombie_eye_glow
	Namespace: zombie_utility
	Checksum: 0x49741C37
	Offset: 0x4A20
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function delayed_zombie_eye_glow()
{
	self endon("zombie_delete");
	self endon("death");
	if(isdefined(self.in_the_ground) && self.in_the_ground || (isdefined(self.in_the_ceiling) && self.in_the_ceiling))
	{
		while(!isdefined(self.create_eyes))
		{
			wait(0.1);
		}
	}
	else
	{
		wait(0.5);
	}
	self zombie_eye_glow();
}

/*
	Name: zombie_eye_glow
	Namespace: zombie_utility
	Checksum: 0xF1DC83D2
	Offset: 0x4AB0
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function zombie_eye_glow()
{
	if(!isdefined(self) || !IsActor(self))
	{
		return;
	}
	if(!isdefined(self.no_eye_glow) || !self.no_eye_glow)
	{
		self clientfield::set("zombie_has_eyes", 1);
	}
}

/*
	Name: zombie_eye_glow_stop
	Namespace: zombie_utility
	Checksum: 0x54EF903F
	Offset: 0x4B28
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function zombie_eye_glow_stop()
{
	if(!isdefined(self) || !IsActor(self))
	{
		return;
	}
	if(!isdefined(self.no_eye_glow) || !self.no_eye_glow)
	{
		self clientfield::set("zombie_has_eyes", 0);
	}
}

/*
	Name: round_spawn_failsafe_debug_draw
	Namespace: zombie_utility
	Checksum: 0x7A6832ED
	Offset: 0x4B98
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function round_spawn_failsafe_debug_draw()
{
	self endon("death");
	prevOrigin = self.origin;
	while(1)
	{
		if(isdefined(level.toggle_keyline_always) && level.toggle_keyline_always)
		{
			self clientfield::set("zombie_keyline_render", 1);
			wait(1);
			continue;
		}
		wait(4);
		if(isdefined(self.lastchunk_destroy_time))
		{
			if(GetTime() - self.lastchunk_destroy_time < 8000)
			{
				continue;
			}
		}
		if(DistanceSquared(self.origin, prevOrigin) < 576)
		{
			self clientfield::set("zombie_keyline_render", 1);
		}
		else
		{
			self clientfield::set("zombie_keyline_render", 0);
		}
		prevOrigin = self.origin;
	}
}

/*
	Name: round_spawn_failsafe
	Namespace: zombie_utility
	Checksum: 0x7BB333E6
	Offset: 0x4CB8
	Size: 0x2D7
	Parameters: 0
	Flags: None
*/
function round_spawn_failsafe()
{
	self endon("death");
	if(isdefined(level.debug_keyline_zombies) && level.debug_keyline_zombies)
	{
		self thread round_spawn_failsafe_debug_draw();
	}
	prevOrigin = self.origin;
	while(1)
	{
		if(!level.zombie_vars["zombie_use_failsafe"])
		{
			return;
		}
		if(isdefined(self.ignore_round_spawn_failsafe) && self.ignore_round_spawn_failsafe)
		{
			return;
		}
		if(!isdefined(level.failsafe_waittime))
		{
			level.failsafe_waittime = 30;
		}
		wait(level.failsafe_waittime);
		if(self.missingLegs)
		{
			wait(10);
		}
		if(isdefined(self.is_inert) && self.is_inert)
		{
			continue;
		}
		if(isdefined(self.lastchunk_destroy_time))
		{
			if(GetTime() - self.lastchunk_destroy_time < 8000)
			{
				continue;
			}
		}
		if(self.origin[2] < level.zombie_vars["below_world_check"])
		{
			if(isdefined(level.put_timed_out_zombies_back_in_queue) && level.put_timed_out_zombies_back_in_queue && !level flag::get("special_round") && (!isdefined(self.isscreecher) && self.isscreecher))
			{
				level.zombie_total++;
				level.zombie_total_subtract++;
			}
			self DoDamage(self.health + 100, (0, 0, 0));
			break;
		}
		if(DistanceSquared(self.origin, prevOrigin) < 576)
		{
			if(isdefined(level.move_failsafe_override))
			{
				self thread [[level.move_failsafe_override]](prevOrigin);
			}
			else if(isdefined(level.put_timed_out_zombies_back_in_queue) && level.put_timed_out_zombies_back_in_queue && !level flag::get("special_round"))
			{
				if(!self.ignoreall && (!isdefined(self.nuked) && self.nuked) && (!isdefined(self.marked_for_death) && self.marked_for_death) && (!isdefined(self.isscreecher) && self.isscreecher) && !self.missingLegs)
				{
					level.zombie_total++;
					level.zombie_total_subtract++;
				}
			}
			level.zombies_timeout_playspace++;
			self DoDamage(self.health + 100, (0, 0, 0));
			break;
		}
		prevOrigin = self.origin;
	}
}

/*
	Name: ai_calculate_health
	Namespace: zombie_utility
	Checksum: 0x27390E04
	Offset: 0x4F98
	Size: 0x105
	Parameters: 1
	Flags: None
*/
function ai_calculate_health(round_number)
{
	level.zombie_health = level.zombie_vars["zombie_health_start"];
	for(i = 2; i <= round_number; i++)
	{
		if(i >= 10)
		{
			old_health = level.zombie_health;
			level.zombie_health = level.zombie_health + Int(level.zombie_health * level.zombie_vars["zombie_health_increase_multiplier"]);
			if(level.zombie_health < old_health)
			{
				level.zombie_health = old_health;
				return;
			}
			continue;
		}
		level.zombie_health = Int(level.zombie_health + level.zombie_vars["zombie_health_increase"]);
	}
}

/*
	Name: default_max_zombie_func
	Namespace: zombie_utility
	Checksum: 0xD1ECA8DD
	Offset: 0x50A8
	Size: 0x17B
	Parameters: 2
	Flags: None
*/
function default_max_zombie_func(max_num, n_round)
{
	/#
		count = GetDvarInt("Dev Block strings are not supported", -1);
		if(count > -1)
		{
			return count;
		}
	#/
	max = max_num;
	if(n_round < 2)
	{
		max = Int(max_num * 0.25);
	}
	else if(n_round < 3)
	{
		max = Int(max_num * 0.3);
	}
	else if(n_round < 4)
	{
		max = Int(max_num * 0.5);
	}
	else if(n_round < 5)
	{
		max = Int(max_num * 0.7);
	}
	else if(n_round < 6)
	{
		max = Int(max_num * 0.9);
	}
	return max;
}

/*
	Name: zombie_speed_up
	Namespace: zombie_utility
	Checksum: 0xE5253599
	Offset: 0x5230
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function zombie_speed_up()
{
	if(level.round_number <= 3)
	{
		return;
	}
	level endon("intermission");
	level endon("end_of_round");
	level endon("restart_round");
	level endon("kill_round");
	while(level.zombie_total > 4)
	{
		wait(3);
	}
	for(a_ai_zombies = get_round_enemy_array(); a_ai_zombies.size > 0 || level.zombie_total > 0;  = get_round_enemy_array())
	{
		if(a_ai_zombies.size == 1)
		{
			ai_zombie = a_ai_zombies[0];
			if(isalive(ai_zombie))
			{
				if(isdefined(level.zombie_speed_up))
				{
					ai_zombie thread [[level.zombie_speed_up]]();
				}
				else if(!ai_zombie.zombie_move_speed === "sprint")
				{
					ai_zombie set_zombie_run_cycle("sprint");
					ai_zombie.zombie_move_speed_original = ai_zombie.zombie_move_speed;
				}
			}
		}
		wait(0.5);
	}
}

/*
	Name: get_current_zombie_count
	Namespace: zombie_utility
	Checksum: 0xB303DB9
	Offset: 0x53B8
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function get_current_zombie_count()
{
	enemies = get_round_enemy_array();
	return enemies.size;
}

/*
	Name: get_round_enemy_array
	Namespace: zombie_utility
	Checksum: 0xBE85FF5A
	Offset: 0x53E8
	Size: 0xFD
	Parameters: 0
	Flags: None
*/
function get_round_enemy_array()
{
	a_ai_enemies = [];
	a_ai_valid_enemies = [];
	a_ai_enemies = GetAITeamArray(level.zombie_team);
	for(i = 0; i < a_ai_enemies.size; i++)
	{
		if(isdefined(a_ai_enemies[i].ignore_enemy_count) && a_ai_enemies[i].ignore_enemy_count)
		{
			continue;
		}
		if(!isdefined(a_ai_valid_enemies))
		{
			a_ai_valid_enemies = [];
		}
		else if(!IsArray(a_ai_valid_enemies))
		{
			a_ai_valid_enemies = Array(a_ai_valid_enemies);
		}
		a_ai_valid_enemies[a_ai_valid_enemies.size] = a_ai_enemies[i];
	}
	return a_ai_valid_enemies;
}

/*
	Name: get_zombie_array
	Namespace: zombie_utility
	Checksum: 0x4DCC1C4D
	Offset: 0x54F0
	Size: 0xF5
	Parameters: 0
	Flags: None
*/
function get_zombie_array()
{
	enemies = [];
	valid_enemies = [];
	enemies = GetAISpeciesArray(level.zombie_team, "all");
	for(i = 0; i < enemies.size; i++)
	{
		if(enemies[i].archetype == "zombie")
		{
			if(!isdefined(valid_enemies))
			{
				valid_enemies = [];
			}
			else if(!IsArray(valid_enemies))
			{
				valid_enemies = Array(valid_enemies);
			}
			valid_enemies[valid_enemies.size] = enemies[i];
		}
	}
	return valid_enemies;
}

/*
	Name: set_zombie_run_cycle_override_value
	Namespace: zombie_utility
	Checksum: 0x9C8FF1F7
	Offset: 0x55F0
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function set_zombie_run_cycle_override_value(new_move_speed)
{
	set_zombie_run_cycle(new_move_speed);
	self.zombie_move_speed_override = new_move_speed;
}

/*
	Name: set_zombie_run_cycle_restore_from_override
	Namespace: zombie_utility
	Checksum: 0x7965EF61
	Offset: 0x5628
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function set_zombie_run_cycle_restore_from_override()
{
	str_restore_move_speed = self.zombie_move_speed_restore;
	self.zombie_move_speed_override = undefined;
	set_zombie_run_cycle(str_restore_move_speed);
}

/*
	Name: set_zombie_run_cycle
	Namespace: zombie_utility
	Checksum: 0xBE17265D
	Offset: 0x5670
	Size: 0x28B
	Parameters: 1
	Flags: None
*/
function set_zombie_run_cycle(new_move_speed)
{
	if(isdefined(self.zombie_move_speed_override))
	{
		self.zombie_move_speed_restore = new_move_speed;
		return;
	}
	self.zombie_move_speed_original = self.zombie_move_speed;
	if(isdefined(new_move_speed))
	{
		self.zombie_move_speed = new_move_speed;
	}
	else if(level.gamedifficulty == 0)
	{
		self set_run_speed_easy();
	}
	else
	{
		self set_run_speed();
	}
	if(isdefined(level.zm_variant_type_max))
	{
		/#
			if(0)
			{
				debug_variant_type = GetDvarInt("Dev Block strings are not supported", -1);
				if(debug_variant_type != -1)
				{
					if(debug_variant_type <= level.zm_variant_type_max[self.zombie_move_speed][self.zombie_arms_position])
					{
						self.variant_type = debug_variant_type;
					}
					else
					{
						self.variant_type = level.zm_variant_type_max[self.zombie_move_speed][self.zombie_arms_position] - 1;
					}
				}
				else
				{
					self.variant_type = RandomInt(level.zm_variant_type_max[self.zombie_move_speed][self.zombie_arms_position]);
				}
			}
		#/
		if(self.archetype === "zombie")
		{
			if(isdefined(self.zm_variant_type_max))
			{
				self.variant_type = RandomInt(self.zm_variant_type_max[self.zombie_move_speed][self.zombie_arms_position]);
			}
			else if(isdefined(level.zm_variant_type_max[self.zombie_move_speed]))
			{
				self.variant_type = RandomInt(level.zm_variant_type_max[self.zombie_move_speed][self.zombie_arms_position]);
			}
			else
			{
				errormsg("Dev Block strings are not supported" + self.zombie_move_speed);
				self.variant_type = 0;
			}
			/#
			#/
		}
	}
	self.needs_run_update = 1;
	self notify("needs_run_update");
	self.deathAnim = self append_missing_legs_suffix("zm_death");
}

/*
	Name: set_run_speed
	Namespace: zombie_utility
	Checksum: 0x9C29ACA9
	Offset: 0x5908
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function set_run_speed()
{
	if(isdefined(level.zombie_force_run))
	{
		self.zombie_move_speed = "run";
		level.zombie_force_run--;
		if(level.zombie_force_run <= 0)
		{
			level.zombie_force_run = undefined;
		}
		return;
	}
	rand = randomIntRange(level.zombie_move_speed, level.zombie_move_speed + 35);
	if(rand <= 35)
	{
		self.zombie_move_speed = "walk";
	}
	else if(rand <= 70)
	{
		self.zombie_move_speed = "run";
	}
	else
	{
		self.zombie_move_speed = "sprint";
	}
}

/*
	Name: set_run_speed_easy
	Namespace: zombie_utility
	Checksum: 0x65D99E22
	Offset: 0x59D8
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function set_run_speed_easy()
{
	rand = randomIntRange(level.zombie_move_speed, level.zombie_move_speed + 25);
	if(rand <= 35)
	{
		self.zombie_move_speed = "walk";
	}
	else
	{
		self.zombie_move_speed = "run";
	}
}

/*
	Name: setup_zombie_knockdown
	Namespace: zombie_utility
	Checksum: 0xE7FE41DE
	Offset: 0x5A50
	Size: 0x263
	Parameters: 1
	Flags: None
*/
function setup_zombie_knockdown(entity)
{
	self.KNOCKDOWN = 1;
	zombie_to_entity = entity.origin - self.origin;
	zombie_to_entity_2d = VectorNormalize((zombie_to_entity[0], zombie_to_entity[1], 0));
	zombie_forward = AnglesToForward(self.angles);
	zombie_forward_2d = VectorNormalize((zombie_forward[0], zombie_forward[1], 0));
	zombie_right = AnglesToRight(self.angles);
	zombie_right_2d = VectorNormalize((zombie_right[0], zombie_right[1], 0));
	dot = VectorDot(zombie_to_entity_2d, zombie_forward_2d);
	if(dot >= 0.5)
	{
		self.knockdown_direction = "front";
		self.getup_direction = "getup_back";
	}
	else if(dot < 0.5 && dot > -0.5)
	{
		dot = VectorDot(zombie_to_entity_2d, zombie_right_2d);
		if(dot > 0)
		{
			self.knockdown_direction = "right";
			if(math::cointoss())
			{
				self.getup_direction = "getup_back";
			}
			else
			{
				self.getup_direction = "getup_belly";
			}
		}
		else
		{
			self.knockdown_direction = "left";
			self.getup_direction = "getup_belly";
		}
	}
	else
	{
		self.knockdown_direction = "back";
		self.getup_direction = "getup_belly";
	}
}

/*
	Name: clear_all_corpses
	Namespace: zombie_utility
	Checksum: 0x9E9B23D4
	Offset: 0x5CC0
	Size: 0x75
	Parameters: 0
	Flags: None
*/
function clear_all_corpses()
{
	corpse_array = GetCorpseArray();
	for(i = 0; i < corpse_array.size; i++)
	{
		if(isdefined(corpse_array[i]))
		{
			corpse_array[i] delete();
		}
	}
}

/*
	Name: get_current_actor_count
	Namespace: zombie_utility
	Checksum: 0x51B706A6
	Offset: 0x5D40
	Size: 0x7D
	Parameters: 0
	Flags: None
*/
function get_current_actor_count()
{
	count = 0;
	actors = GetAISpeciesArray(level.zombie_team, "all");
	if(isdefined(actors))
	{
		count = count + actors.size;
	}
	count = count + get_current_corpse_count();
	return count;
}

/*
	Name: get_current_corpse_count
	Namespace: zombie_utility
	Checksum: 0x76A9AC16
	Offset: 0x5DC8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function get_current_corpse_count()
{
	corpse_array = GetCorpseArray();
	if(isdefined(corpse_array))
	{
		return corpse_array.size;
	}
	return 0;
}

/*
	Name: zombie_gib_on_damage
	Namespace: zombie_utility
	Checksum: 0xEFE1521D
	Offset: 0x5E08
	Size: 0x4F7
	Parameters: 0
	Flags: None
*/
function zombie_gib_on_damage()
{
	while(1)
	{
		self waittill("damage", amount, attacker, direction_vec, point, type, tagName, modelName, partName, weapon);
		if(!isdefined(self))
		{
			return;
		}
		if(!self zombie_should_gib(amount, attacker, type))
		{
			continue;
		}
		if(self head_should_gib(attacker, type, point) && type != "MOD_BURNED")
		{
			self zombie_head_gib(attacker, type);
			continue;
		}
		if(!isdefined(self.gibbed) && self.gibbed && isdefined(self.damagelocation))
		{
			if(self damageLocationIsAny("head", "helmet", "neck"))
			{
				continue;
			}
			self.stumble = undefined;
			switch(self.damagelocation)
			{
				case "torso_lower":
				case "torso_upper":
				{
					if(!GibServerUtils::IsGibbed(self, 32))
					{
						GibServerUtils::GibRightArm(self);
					}
					break;
				}
				case "right_arm_lower":
				case "right_arm_upper":
				case "right_hand":
				{
					if(!GibServerUtils::IsGibbed(self, 32))
					{
						GibServerUtils::GibRightArm(self);
					}
					break;
				}
				case "left_arm_lower":
				case "left_arm_upper":
				case "left_hand":
				{
					if(!GibServerUtils::IsGibbed(self, 16))
					{
						GibServerUtils::GibLeftArm(self);
					}
					break;
				}
				case "right_foot":
				case "right_leg_lower":
				case "right_leg_upper":
				{
					if(self.health <= 0)
					{
						GibServerUtils::GibRightLeg(self);
						if(RandomInt(100) > 75)
						{
							GibServerUtils::GibLeftLeg(self);
						}
						self.missingLegs = 1;
					}
					break;
				}
				case "left_foot":
				case "left_leg_lower":
				case "left_leg_upper":
				{
					if(self.health <= 0)
					{
						GibServerUtils::GibLeftLeg(self);
						if(RandomInt(100) > 75)
						{
							GibServerUtils::GibRightLeg(self);
						}
						self.missingLegs = 1;
					}
					break;
				}
				case default:
				{
					if(self.damagelocation == "none")
					{
						if(type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" || type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH")
						{
							self derive_damage_refs(point);
							break;
						}
					}
				}
			}
			if(isdefined(self.missingLegs) && self.missingLegs && self.health > 0)
			{
				self AllowedStances("crouch");
				self setPhysParams(15, 0, 24);
				self AllowPitchAngle(1);
				self SetPitchOrient();
				health = self.health;
				health = health * 0.1;
				if(isdefined(self.crawl_anim_override))
				{
					self [[self.crawl_anim_override]]();
				}
			}
			if(self.health > 0)
			{
				if(isdefined(level.gib_on_damage))
				{
					self thread [[level.gib_on_damage]]();
				}
			}
		}
	}
}

/*
	Name: add_zombie_gib_weapon_callback
	Namespace: zombie_utility
	Checksum: 0x886A0FCD
	Offset: 0x6308
	Size: 0x71
	Parameters: 3
	Flags: None
*/
function add_zombie_gib_weapon_callback(weapon_name, gib_callback, gib_head_callback)
{
	if(!isdefined(level.zombie_gib_weapons))
	{
		level.zombie_gib_weapons = [];
	}
	if(!isdefined(level.zombie_gib_head_weapons))
	{
		level.zombie_gib_head_weapons = [];
	}
	level.zombie_gib_weapons[weapon_name] = gib_callback;
	level.zombie_gib_head_weapons[weapon_name] = gib_head_callback;
}

/*
	Name: have_zombie_weapon_gib_callback
	Namespace: zombie_utility
	Checksum: 0xC5F38764
	Offset: 0x6388
	Size: 0x81
	Parameters: 1
	Flags: None
*/
function have_zombie_weapon_gib_callback(weapon)
{
	if(!isdefined(level.zombie_gib_weapons))
	{
		level.zombie_gib_weapons = [];
	}
	if(!isdefined(level.zombie_gib_head_weapons))
	{
		level.zombie_gib_head_weapons = [];
	}
	if(IsWeapon(weapon))
	{
		weapon = weapon.name;
	}
	if(isdefined(level.zombie_gib_weapons[weapon]))
	{
		return 1;
	}
	return 0;
}

/*
	Name: get_zombie_weapon_gib_callback
	Namespace: zombie_utility
	Checksum: 0x21D6478F
	Offset: 0x6418
	Size: 0x9F
	Parameters: 2
	Flags: None
*/
function get_zombie_weapon_gib_callback(weapon, damage_percent)
{
	if(!isdefined(level.zombie_gib_weapons))
	{
		level.zombie_gib_weapons = [];
	}
	if(!isdefined(level.zombie_gib_head_weapons))
	{
		level.zombie_gib_head_weapons = [];
	}
	if(IsWeapon(weapon))
	{
		weapon = weapon.name;
	}
	if(isdefined(level.zombie_gib_weapons[weapon]))
	{
		return self [[level.zombie_gib_weapons[weapon]]](damage_percent);
	}
	return 0;
}

/*
	Name: have_zombie_weapon_gib_head_callback
	Namespace: zombie_utility
	Checksum: 0xF3C78B59
	Offset: 0x64C0
	Size: 0x81
	Parameters: 1
	Flags: None
*/
function have_zombie_weapon_gib_head_callback(weapon)
{
	if(!isdefined(level.zombie_gib_weapons))
	{
		level.zombie_gib_weapons = [];
	}
	if(!isdefined(level.zombie_gib_head_weapons))
	{
		level.zombie_gib_head_weapons = [];
	}
	if(IsWeapon(weapon))
	{
		weapon = weapon.name;
	}
	if(isdefined(level.zombie_gib_head_weapons[weapon]))
	{
		return 1;
	}
	return 0;
}

/*
	Name: get_zombie_weapon_gib_head_callback
	Namespace: zombie_utility
	Checksum: 0x28C8E02F
	Offset: 0x6550
	Size: 0x9F
	Parameters: 2
	Flags: None
*/
function get_zombie_weapon_gib_head_callback(weapon, DAMAGE_LOCATION)
{
	if(!isdefined(level.zombie_gib_weapons))
	{
		level.zombie_gib_weapons = [];
	}
	if(!isdefined(level.zombie_gib_head_weapons))
	{
		level.zombie_gib_head_weapons = [];
	}
	if(IsWeapon(weapon))
	{
		weapon = weapon.name;
	}
	if(isdefined(level.zombie_gib_head_weapons[weapon]))
	{
		return self [[level.zombie_gib_head_weapons[weapon]]](DAMAGE_LOCATION);
	}
	return 0;
}

/*
	Name: zombie_should_gib
	Namespace: zombie_utility
	Checksum: 0x209C6AA4
	Offset: 0x65F8
	Size: 0x28B
	Parameters: 3
	Flags: None
*/
function zombie_should_gib(amount, attacker, type)
{
	if(!isdefined(type))
	{
		return 0;
	}
	if(isdefined(self.is_on_fire) && self.is_on_fire)
	{
		return 0;
	}
	if(isdefined(self.no_gib) && self.no_gib == 1)
	{
		return 0;
	}
	prev_health = amount + self.health;
	if(prev_health <= 0)
	{
		prev_health = 1;
	}
	damage_percent = amount / prev_health * 100;
	weapon = undefined;
	if(isdefined(attacker))
	{
		if(isPlayer(attacker) || (isdefined(attacker.can_gib_zombies) && attacker.can_gib_zombies))
		{
			if(isPlayer(attacker))
			{
				weapon = attacker GetCurrentWeapon();
			}
			else
			{
				weapon = attacker.weapon;
			}
			if(have_zombie_weapon_gib_callback(weapon))
			{
				if(self get_zombie_weapon_gib_callback(weapon, damage_percent))
				{
					return 1;
				}
				return 0;
			}
		}
	}
	switch(type)
	{
		case "MOD_BURNED":
		case "MOD_FALLING":
		case "MOD_SUICIDE":
		case "MOD_TELEFRAG":
		case "MOD_TRIGGER_HURT":
		case "MOD_UNKNOWN":
		{
			return 0;
		}
		case "MOD_MELEE":
		{
			return 0;
		}
	}
	if(type == "MOD_PISTOL_BULLET" || type == "MOD_RIFLE_BULLET")
	{
		if(!isdefined(attacker) || !isPlayer(attacker))
		{
			return 0;
		}
		if(weapon == level.weaponNone || (isdefined(level.start_weapon) && weapon == level.start_weapon) || weapon.isGasWeapon)
		{
			return 0;
		}
	}
	if(damage_percent < 10)
	{
		return 0;
	}
	return 1;
}

/*
	Name: head_should_gib
	Namespace: zombie_utility
	Checksum: 0x96052F9D
	Offset: 0x6890
	Size: 0x359
	Parameters: 3
	Flags: None
*/
function head_should_gib(attacker, type, point)
{
	if(isdefined(self.head_gibbed) && self.head_gibbed)
	{
		return 0;
	}
	if(!isdefined(attacker))
	{
		return 0;
	}
	if(!isPlayer(attacker))
	{
		if(!(isdefined(attacker.can_gib_zombies) && attacker.can_gib_zombies))
		{
			return 0;
		}
	}
	if(isPlayer(attacker))
	{
		weapon = attacker GetCurrentWeapon();
	}
	else
	{
		weapon = attacker.weapon;
	}
	if(have_zombie_weapon_gib_head_callback(weapon))
	{
		if(self get_zombie_weapon_gib_head_callback(weapon, self.damagelocation))
		{
			return 1;
		}
		return 0;
	}
	if(type != "MOD_RIFLE_BULLET" && type != "MOD_PISTOL_BULLET")
	{
		if(type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH")
		{
			if(Distance(point, self GetTagOrigin("j_head")) > 55)
			{
				return 0;
			}
			else
			{
				return 1;
			}
		}
		else if(type == "MOD_PROJECTILE")
		{
			if(Distance(point, self GetTagOrigin("j_head")) > 10)
			{
				return 0;
			}
			else
			{
				return 1;
			}
		}
		else if(weapon.weapClass != "spread")
		{
			return 0;
		}
	}
	if(!self damageLocationIsAny("head", "helmet", "neck"))
	{
		return 0;
	}
	if(type == "MOD_PISTOL_BULLET" && weapon.weapClass != "smg" && weapon.weapClass != "spread" || weapon == level.weaponNone || (isdefined(level.start_weapon) && weapon == level.start_weapon) || weapon.isGasWeapon)
	{
		return 0;
	}
	if(SessionModeIsCampaignGame() && (type == "MOD_PISTOL_BULLET" && weapon.weapClass != "smg"))
	{
		return 0;
	}
	low_health_percent = self.health / self.maxhealth * 100;
	if(low_health_percent > 10)
	{
		return 0;
	}
	return 1;
}

/*
	Name: zombie_hat_gib
	Namespace: zombie_utility
	Checksum: 0xB688B1B
	Offset: 0x6BF8
	Size: 0xF7
	Parameters: 2
	Flags: None
*/
function zombie_hat_gib(attacker, means_of_death)
{
	self endon("death");
	if(isdefined(self.hat_gibbed) && self.hat_gibbed)
	{
		return;
	}
	if(!isdefined(self.gibSpawn5) || !isdefined(self.gibSpawnTag5))
	{
		return;
	}
	self.hat_gibbed = 1;
	if(isdefined(self.hatModel))
	{
		self Detach(self.hatModel, "");
	}
	temp_array = [];
	temp_array[0] = level._ZOMBIE_GIB_PIECE_INDEX_HAT;
	self gib("normal", temp_array);
	if(isdefined(level.track_gibs))
	{
		level [[level.track_gibs]](self, temp_array);
	}
}

/*
	Name: head_gib_damage_over_time
	Namespace: zombie_utility
	Checksum: 0x40BF1520
	Offset: 0x6CF8
	Size: 0x177
	Parameters: 4
	Flags: None
*/
function head_gib_damage_over_time(dmg, delay, attacker, means_of_death)
{
	self endon("death");
	self endon("exploding");
	if(!isalive(self))
	{
		return;
	}
	if(!isPlayer(attacker))
	{
		attacker = self;
	}
	if(!isdefined(means_of_death))
	{
		means_of_death = "MOD_UNKNOWN";
	}
	dot_location = self.damagelocation;
	dot_weapon = self.damageWeapon;
	while(1)
	{
		if(isdefined(delay))
		{
			wait(delay);
		}
		if(isdefined(self))
		{
			if(isdefined(self.no_gib) && self.no_gib)
			{
				return;
			}
			if(isdefined(attacker))
			{
				self DoDamage(dmg, self GetTagOrigin("j_neck"), attacker, self, dot_location, means_of_death, 0, dot_weapon);
			}
			else
			{
				self DoDamage(dmg, self GetTagOrigin("j_neck"));
			}
		}
	}
}

/*
	Name: derive_damage_refs
	Namespace: zombie_utility
	Checksum: 0xA0DFB7A2
	Offset: 0x6E78
	Size: 0x35F
	Parameters: 1
	Flags: None
*/
function derive_damage_refs(point)
{
	if(!isdefined(level.gib_tags))
	{
		init_gib_tags();
	}
	closestTag = undefined;
	for(i = 0; i < level.gib_tags.size; i++)
	{
		if(!isdefined(closestTag))
		{
			closestTag = level.gib_tags[i];
			continue;
		}
		if(DistanceSquared(point, self GetTagOrigin(level.gib_tags[i])) < DistanceSquared(point, self GetTagOrigin(closestTag)))
		{
			closestTag = level.gib_tags[i];
		}
	}
	if(closestTag == "J_SpineLower" || closestTag == "J_SpineUpper" || closestTag == "J_Spine4")
	{
		GibServerUtils::GibRightArm(self);
	}
	else if(closestTag == "J_Shoulder_LE" || closestTag == "J_Elbow_LE" || closestTag == "J_Wrist_LE")
	{
		if(!GibServerUtils::IsGibbed(self, 16))
		{
			GibServerUtils::GibLeftArm(self);
		}
	}
	else if(closestTag == "J_Shoulder_RI" || closestTag == "J_Elbow_RI" || closestTag == "J_Wrist_RI")
	{
		if(!GibServerUtils::IsGibbed(self, 32))
		{
			GibServerUtils::GibRightArm(self);
		}
	}
	else if(closestTag == "J_Hip_LE" || closestTag == "J_Knee_LE" || closestTag == "J_Ankle_LE")
	{
		if(isdefined(self.noCrawler) && self.noCrawler)
		{
			return;
		}
		GibServerUtils::GibLeftLeg(self);
		if(RandomInt(100) > 75)
		{
			GibServerUtils::GibRightLeg(self);
		}
		self.missingLegs = 1;
	}
	else if(closestTag == "J_Hip_RI" || closestTag == "J_Knee_RI" || closestTag == "J_Ankle_RI")
	{
		if(isdefined(self.noCrawler) && self.noCrawler)
		{
			return;
		}
		GibServerUtils::GibRightLeg(self);
		if(RandomInt(100) > 75)
		{
			GibServerUtils::GibLeftLeg(self);
		}
		self.missingLegs = 1;
	}
}

/*
	Name: init_gib_tags
	Namespace: zombie_utility
	Checksum: 0x46A361C
	Offset: 0x71E0
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function init_gib_tags()
{
	tags = [];
	tags[tags.size] = "J_SpineLower";
	tags[tags.size] = "J_SpineUpper";
	tags[tags.size] = "J_Spine4";
	tags[tags.size] = "J_Shoulder_LE";
	tags[tags.size] = "J_Elbow_LE";
	tags[tags.size] = "J_Wrist_LE";
	tags[tags.size] = "J_Shoulder_RI";
	tags[tags.size] = "J_Elbow_RI";
	tags[tags.size] = "J_Wrist_RI";
	tags[tags.size] = "J_Hip_LE";
	tags[tags.size] = "J_Knee_LE";
	tags[tags.size] = "J_Ankle_LE";
	tags[tags.size] = "J_Hip_RI";
	tags[tags.size] = "J_Knee_RI";
	tags[tags.size] = "J_Ankle_RI";
	level.gib_tags = tags;
}

/*
	Name: getAnimDirection
	Namespace: zombie_utility
	Checksum: 0xCA700833
	Offset: 0x7338
	Size: 0x91
	Parameters: 1
	Flags: None
*/
function getAnimDirection(damageyaw)
{
	if(damageyaw > 135 || damageyaw <= -135)
	{
		return "front";
	}
	else if(damageyaw > 45 && damageyaw <= 135)
	{
		return "right";
	}
	else if(damageyaw > -45 && damageyaw <= 45)
	{
		return "back";
	}
	else
	{
		return "left";
	}
	return "front";
}

/*
	Name: anim_get_dvar_int
	Namespace: zombie_utility
	Checksum: 0xA954F8DB
	Offset: 0x73D8
	Size: 0x41
	Parameters: 2
	Flags: None
*/
function anim_get_dvar_int(dvar, def)
{
	return Int(anim_get_dvar(dvar, def));
}

/*
	Name: anim_get_dvar
	Namespace: zombie_utility
	Checksum: 0x49F6246F
	Offset: 0x7428
	Size: 0x71
	Parameters: 2
	Flags: None
*/
function anim_get_dvar(dvar, def)
{
	if(GetDvarString(dvar) != "")
	{
		return GetDvarFloat(dvar);
	}
	else
	{
		SetDvar(dvar, def);
		return def;
	}
}

/*
	Name: makeZombieCrawler
	Namespace: zombie_utility
	Checksum: 0xBF46BB28
	Offset: 0x74A8
	Size: 0x169
	Parameters: 1
	Flags: None
*/
function makeZombieCrawler(b_both_legs)
{
	if(isdefined(b_both_legs) && b_both_legs)
	{
		VAL = 100;
	}
	else
	{
		VAL = RandomInt(100);
	}
	if(VAL > 75)
	{
		GibServerUtils::GibRightLeg(self);
		GibServerUtils::GibLeftLeg(self);
	}
	else if(VAL > 37)
	{
		GibServerUtils::GibRightLeg(self);
	}
	else
	{
		GibServerUtils::GibLeftLeg(self);
	}
	self.missingLegs = 1;
	self AllowedStances("crouch");
	self setPhysParams(15, 0, 24);
	self AllowPitchAngle(1);
	self SetPitchOrient();
	health = self.health;
	health = health * 0.1;
}

/*
	Name: zombie_head_gib
	Namespace: zombie_utility
	Checksum: 0x4700581B
	Offset: 0x7620
	Size: 0xDB
	Parameters: 2
	Flags: None
*/
function zombie_head_gib(attacker, means_of_death)
{
	self endon("death");
	if(isdefined(self.head_gibbed) && self.head_gibbed)
	{
		return;
	}
	if(isdefined(self.no_gib) && self.no_gib)
	{
		return;
	}
	self.head_gibbed = 1;
	self zombie_eye_glow_stop();
	if(!(isdefined(self.disable_head_gib) && self.disable_head_gib))
	{
		GibServerUtils::GibHead(self);
	}
	self thread head_gib_damage_over_time(ceil(self.health * 0.2), 1, attacker, means_of_death);
}

/*
	Name: gib_random_parts
	Namespace: zombie_utility
	Checksum: 0xBE13EC82
	Offset: 0x7708
	Size: 0x193
	Parameters: 0
	Flags: None
*/
function gib_random_parts()
{
	if(isdefined(self.no_gib) && self.no_gib)
	{
		return;
	}
	VAL = RandomInt(100);
	if(VAL > 50)
	{
		self zombie_head_gib();
	}
	VAL = RandomInt(100);
	if(VAL > 50)
	{
		GibServerUtils::GibRightLeg(self);
	}
	VAL = RandomInt(100);
	if(VAL > 50)
	{
		GibServerUtils::GibLeftLeg(self);
	}
	VAL = RandomInt(100);
	if(VAL > 50)
	{
		if(!GibServerUtils::IsGibbed(self, 32))
		{
			GibServerUtils::GibRightArm(self);
		}
	}
	VAL = RandomInt(100);
	if(VAL > 50)
	{
		if(!GibServerUtils::IsGibbed(self, 16))
		{
			GibServerUtils::GibLeftArm(self);
		}
	}
}

/*
	Name: init_ignore_player_handler
	Namespace: zombie_utility
	Checksum: 0x415512D4
	Offset: 0x78A8
	Size: 0xF
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init_ignore_player_handler()
{
	level._IGNORE_PLAYER_HANDLER = [];
}

/*
	Name: register_ignore_player_handler
	Namespace: zombie_utility
	Checksum: 0x8B94AAE4
	Offset: 0x78C0
	Size: 0x8D
	Parameters: 2
	Flags: None
*/
function register_ignore_player_handler(archetype, ignore_player_func)
{
	/#
		Assert(isdefined(archetype), "Dev Block strings are not supported");
	#/
	/#
		Assert(!isdefined(level._IGNORE_PLAYER_HANDLER[archetype]), "Dev Block strings are not supported" + archetype + "Dev Block strings are not supported");
	#/
	level._IGNORE_PLAYER_HANDLER[archetype] = ignore_player_func;
}

/*
	Name: run_ignore_player_handler
	Namespace: zombie_utility
	Checksum: 0x9053EB8E
	Offset: 0x7958
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function run_ignore_player_handler()
{
	if(isdefined(level._IGNORE_PLAYER_HANDLER[self.archetype]))
	{
		self [[level._IGNORE_PLAYER_HANDLER[self.archetype]]]();
	}
}

/*
	Name: show_hit_marker
	Namespace: zombie_utility
	Checksum: 0x2CBF5B55
	Offset: 0x7998
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function show_hit_marker()
{
	if(isdefined(self) && isdefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback SetShader("damage_feedback", 24, 48);
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback fadeOverTime(1);
		self.hud_damagefeedback.alpha = 0;
	}
}

