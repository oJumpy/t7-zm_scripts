#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\bots\bot_buttons;
#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapons;
#using scripts\shared\weapons_shared;

#namespace bot;

/*
	Name: Callback_BotEnteredUserEdge
	Namespace: bot
	Checksum: 0xC0FA4637
	Offset: 0x1E8
	Size: 0x2E3
	Parameters: 2
	Flags: None
*/
function Callback_BotEnteredUserEdge(startnode, endNode)
{
	zDelta = endNode.origin[2] - startnode.origin[2];
	xyDist = Distance2D(startnode.origin, endNode.origin);
	standingViewHeight = GetDvarFloat("player_standingViewHeight", 0);
	swimWaterHeight = standingViewHeight * GetDvarFloat("player_swimHeightRatio", 0);
	startWaterHeight = GetWaterHeight(startnode.origin);
	startInWater = startWaterHeight != 0 && startWaterHeight > startnode.origin[2] + swimWaterHeight;
	endWaterHeight = GetWaterHeight(endNode.origin);
	endInWater = endWaterHeight != 0 && endWaterHeight > endNode.origin[2] + swimWaterHeight;
	if(IsWallrunNode(endNode))
	{
		self thread wallrun_traversal(startnode, endNode);
	}
	else if(startInWater && !endInWater)
	{
		self thread leave_water_traversal(startnode, endNode);
	}
	else if(startInWater && endInWater)
	{
		self thread swim_traversal(startnode, endNode);
	}
	else if(zDelta >= 0)
	{
		self thread jump_up_traversal(startnode, endNode);
	}
	else if(zDelta < 0)
	{
		self thread jump_down_traversal(startnode, endNode);
	}
	else
	{
		self BotReleaseManualControl();
		/#
			println("Dev Block strings are not supported", self.name, "Dev Block strings are not supported");
		#/
	}
}

/*
	Name: traversing
	Namespace: bot
	Checksum: 0x68A36FC9
	Offset: 0x4D8
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function traversing()
{
	return !self IsOnGround() || self IsWallRunning() || self IsDoubleJumping() || self isMantling() || self IsSliding();
}

/*
	Name: leave_water_traversal
	Namespace: bot
	Checksum: 0x78D7D076
	Offset: 0x560
	Size: 0xCF
	Parameters: 2
	Flags: None
*/
function leave_water_traversal(startnode, endNode)
{
	self endon("death");
	self endon("traversal_end");
	level endon("game_ended");
	self thread watch_traversal_end();
	self BotSetMoveAngleFromPoint(endNode.origin);
	while(self IsPlayerUnderwater())
	{
		self press_swim_up();
		wait(0.05);
	}
	while(1)
	{
		self press_doublejump_button();
		wait(0.05);
	}
}

/*
	Name: swim_traversal
	Namespace: bot
	Checksum: 0x402F9FDF
	Offset: 0x638
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function swim_traversal(startnode, endNode)
{
	self endon("death");
	level endon("game_ended");
	self endon("traversal_end");
	self BotSetMoveAngleFromPoint(endNode.origin);
	wait(0.5);
	self traversal_end();
}

/*
	Name: jump_up_traversal
	Namespace: bot
	Checksum: 0x9934ED08
	Offset: 0x6C0
	Size: 0x2F3
	Parameters: 2
	Flags: None
*/
function jump_up_traversal(startnode, endNode)
{
	self endon("death");
	level endon("game_ended");
	self endon("traversal_end");
	self thread watch_traversal_end();
	ledgeTop = CheckNavMeshDirection(endNode.origin, self.origin - endNode.origin, 128, 1);
	height = ledgeTop[2] - self.origin[2];
	if(height <= 72)
	{
		self thread jump_to(ledgeTop);
		return;
	}
	/#
	#/
	dist = Distance2D(self.origin, ledgeTop);
	ledgeBottom = CheckNavMeshDirection(self.origin, ledgeTop - self.origin, dist + 15, 1);
	bottomDist = Distance2D(self.origin, ledgeBottom);
	if(bottomDist <= dist)
	{
		self thread jump_to(ledgeTop);
		return;
	}
	dist = dist - 15;
	height = height - 72;
	t = height / 80;
	speed2D = self bot_speed2D();
	speed = self GetPlayerSpeed();
	moveDist = t * speed2D;
	if(!moveDist || dist > moveDist)
	{
		self thread jump_to(ledgeTop);
		return;
	}
	self BotSetMoveMagnitude(dist / moveDist);
	wait(0.05);
	self thread jump_to(ledgeTop);
	wait(0.05);
	while(self.origin[2] + 72 < ledgeTop[2])
	{
		wait(0.05);
	}
	self BotSetMoveMagnitude(1);
}

/*
	Name: jump_down_traversal
	Namespace: bot
	Checksum: 0x83C67B84
	Offset: 0x9C0
	Size: 0x3F3
	Parameters: 2
	Flags: None
*/
function jump_down_traversal(startnode, endNode)
{
	self endon("death");
	self endon("traversal_end");
	level endon("game_ended");
	self thread watch_traversal_end();
	fwd = (endNode.origin[0] - startnode.origin[0], endNode.origin[1] - startnode.origin[1], 0);
	fwd = VectorNormalize(fwd) * 128;
	start = startnode.origin + VectorScale((0, 0, 1), 16);
	end = startnode.origin + fwd + VectorScale((0, 0, 1), 16);
	result = bullettrace(start, end, 0, self);
	if(result["surfacetype"] != "none")
	{
		self BotSetMoveAngleFromPoint(endNode.origin);
		wait(0.05);
		self tap_jump_button();
		return;
	}
	dist = Distance2D(startnode.origin, endNode.origin);
	height = startnode.origin[2] - endNode.origin[2];
	gravity = self GetPlayerGravity();
	t = sqrt(2 * height / gravity);
	speed2D = self bot_speed2D();
	if(t * speed2D < dist)
	{
		ledgeTop = CheckNavMeshDirection(startnode.origin, endNode.origin - startnode.origin, 128, 1);
		bottomDist = dist - Distance2D(startnode.origin, ledgeTop);
		ledgeBottom = CheckNavMeshDirection(endNode.origin, startnode.origin - endNode.origin, bottomDist, 1);
		meshDist = Distance2D(ledgeTop, ledgeBottom);
		if(meshDist > 30)
		{
			self thread jump_to(endNode.origin);
			return;
		}
	}
	self BotSetMoveAngleFromPoint(endNode.origin);
}

/*
	Name: wallrun_traversal
	Namespace: bot
	Checksum: 0xD9F82B86
	Offset: 0xDC0
	Size: 0x1CB
	Parameters: 3
	Flags: None
*/
function wallrun_traversal(startnode, endNode, vector)
{
	self endon("death");
	self endon("traversal_end");
	level endon("game_ended");
	self thread watch_traversal_end();
	wallnormal = GetNavMeshFaceNormal(endNode.origin, 30);
	wallnormal = VectorNormalize((wallnormal[0], wallnormal[1], 0));
	traversalDir = (startnode.origin[0] - endNode.origin[0], startnode.origin[1] - endNode.origin[1], 0);
	cross = VectorCross(wallnormal, traversalDir);
	runDir = VectorCross(wallnormal, cross);
	self BotSetLookAngles(runDir);
	self thread jump_to(endNode.origin, vector);
	self thread wait_wallrun_begin(startnode, endNode, wallnormal, runDir);
}

/*
	Name: wait_wallrun_begin
	Namespace: bot
	Checksum: 0x6FB6C82C
	Offset: 0xF98
	Size: 0x173
	Parameters: 4
	Flags: None
*/
function wait_wallrun_begin(startnode, endNode, wallnormal, runDir)
{
	self endon("death");
	self endon("traversal_end");
	level endon("game_ended");
	self waittill("wallrun_begin");
	self thread watch_traversal_end();
	self BotLookNone();
	self BotSetMoveAngle(runDir);
	self release_doublejump_button();
	index = self GetNodeIndexOnPath(startnode);
	index++;
	exitStartNode = self GetNextTraversalNodeOnPath(index);
	if(isdefined(exitStartNode))
	{
		exitEndNode = GetOtherNodeInNegotiationPair(exitStartNode);
		if(isdefined(exitEndNode))
		{
			self thread exit_wallrun(exitStartNode, exitEndNode, wallnormal, VectorNormalize(runDir));
		}
	}
}

/*
	Name: exit_wallrun
	Namespace: bot
	Checksum: 0xCE6E2CBD
	Offset: 0x1118
	Size: 0x3B1
	Parameters: 4
	Flags: None
*/
function exit_wallrun(startnode, endNode, wallnormal, runNormal)
{
	self endon("death");
	self endon("traversal_end");
	level endon("game_ended");
	self thread watch_traversal_end();
	gravity = self GetPlayerGravity();
	vUp = sqrt(80 * gravity);
	tPeak = vUp / gravity;
	hPeak = self.origin[2] + 40;
	fallDist = hPeak - endNode.origin[2];
	if(fallDist > 0)
	{
		tFall = sqrt(fallDist / 0.5 * gravity);
	}
	else
	{
		tFall = 0;
	}
	t = tPeak + tFall;
	exitDir = endNode.origin - startnode.origin;
	dNormal = VectorDot(exitDir, wallnormal);
	vNormal = dNormal / t;
	if(vNormal <= 200)
	{
		dot = sqrt(vNormal / 200);
		vForward = sqrt(40000 * dot * dot - vNormal * vNormal);
		continue;
	}
	vForward = 0;
	while(1)
	{
		wait(0.05);
		endDir = endNode.origin - self.origin;
		endDist = VectorDot(endDir, runNormal);
		vRun = self bot_speed2D();
		dForward = vRun + vForward * t;
		if(endDist <= dForward)
		{
			jumpAngle = wallnormal * vNormal + runNormal * vForward;
			if(IsWallrunNode(endNode))
			{
				self thread wallrun_traversal(startnode, endNode, jumpAngle);
			}
			else
			{
				self BotSetLookAnglesFromPoint(endNode.origin);
				self thread jump_to(endNode.origin, jumpAngle);
			}
			return;
		}
	}
}

/*
	Name: jump_to
	Namespace: bot
	Checksum: 0x803D52F2
	Offset: 0x14D8
	Size: 0x253
	Parameters: 2
	Flags: None
*/
function jump_to(target, vector)
{
	self endon("death");
	self endon("traversal_end");
	level endon("game_ended");
	if(isdefined(vector))
	{
		self BotSetMoveAngle(vector);
		moveDir = VectorNormalize((vector[0], vector[1], 0));
	}
	else
	{
		self BotSetMoveAngleFromPoint(target);
		targetDelta = target - self.origin;
		moveDir = VectorNormalize((targetDelta[0], targetDelta[1], 0));
	}
	velocity = self GetVelocity();
	velocityDir = VectorNormalize((velocity[0], velocity[1], 0));
	if(VectorDot(moveDir, velocityDir) < 0.94)
	{
		wait(0.05);
	}
	self tap_jump_button();
	wait(0.05);
	while(!self IsOnGround() && !self isMantling() && !self IsWallRunning() && !self bot_hit_target(target))
	{
		press_doublejump_button();
		if(!isdefined(vector))
		{
			self BotSetMoveAngleFromPoint(target);
		}
		wait(0.05);
	}
	release_doublejump_button();
}

/*
	Name: bot_update_move_angle
	Namespace: bot
	Checksum: 0x90AEB63A
	Offset: 0x1738
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function bot_update_move_angle(target)
{
	self endon("death");
	self endon("traversal_end");
	level endon("game_ended");
	while(!self isMantling())
	{
		self BotSetMoveAngleFromPoint(target);
		wait(0.05);
	}
}

/*
	Name: bot_hit_target
	Namespace: bot
	Checksum: 0x9DC7C993
	Offset: 0x17A8
	Size: 0x191
	Parameters: 1
	Flags: None
*/
function bot_hit_target(target)
{
	velocity = self GetVelocity();
	targetDir = target - self.origin;
	targetDir = (targetDir[0], targetDir[1], 0);
	if(self.origin[2] > target[2] && VectorDot(velocity, targetDir) <= 0)
	{
		return 1;
	}
	targetDist = length(targetDir);
	targetSpeed = length(velocity);
	if(targetSpeed == 0)
	{
		return 0;
	}
	t = targetDist / targetSpeed;
	gravity = self GetPlayerGravity();
	height = self.origin[2] + velocity[2] * t - gravity * t * t * 0.5;
	/#
	#/
	return height >= target[2] + 32;
}

/*
	Name: bot_speed2D
	Namespace: bot
	Checksum: 0x6D967E2D
	Offset: 0x1948
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function bot_speed2D()
{
	velocity = self GetVelocity();
	speed2D = Distance2D(velocity, (0, 0, 0));
	return speed2D;
}

/*
	Name: watch_traversal_end
	Namespace: bot
	Checksum: 0x177DD094
	Offset: 0x19A8
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function watch_traversal_end()
{
	self notify("watch_travesal_end");
	self endon("death");
	self endon("traversal_end");
	self endon("watch_travesal_end");
	level endon("game_ended");
	self thread wait_traversal_timeout();
	self thread watch_start_swimming();
	self waittill("acrobatics_end");
	self thread traversal_end();
}

/*
	Name: watch_start_swimming
	Namespace: bot
	Checksum: 0x4B194B02
	Offset: 0x1A40
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function watch_start_swimming()
{
	self endon("death");
	self endon("traversal_end");
	self endon("watch_travesal_end");
	level endon("game_ended");
	while(self IsPlayerSwimming())
	{
		wait(0.05);
	}
	wait(0.05);
	while(!self IsPlayerSwimming())
	{
		wait(0.05);
	}
	self thread traversal_end();
}

/*
	Name: wait_traversal_timeout
	Namespace: bot
	Checksum: 0xE44B6D65
	Offset: 0x1AE8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function wait_traversal_timeout()
{
	self endon("death");
	self endon("traversal_end");
	self endon("watch_travesal_end");
	level endon("game_ended");
	wait(8);
	self thread traversal_end();
	self BotRequestPath();
}

/*
	Name: traversal_end
	Namespace: bot
	Checksum: 0x2CD6AEF7
	Offset: 0x1B58
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function traversal_end()
{
	self notify("traversal_end");
	self release_doublejump_button();
	self BotLookForward();
	self BotSetMoveMagnitude(1);
	self BotReleaseManualControl();
}

