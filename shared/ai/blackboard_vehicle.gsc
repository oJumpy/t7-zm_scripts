#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\shared;

#namespace blackboard;

/*
	Name: RegisterVehicleBlackBoardAttributes
	Namespace: blackboard
	Checksum: 0x50764AF7
	Offset: 0x108
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function RegisterVehicleBlackBoardAttributes()
{
	/#
		Assert(isVehicle(self), "Dev Block strings are not supported");
	#/
	RegisterBlackBoardAttribute(self, "_speed", undefined, &BB_GetSpeed);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	RegisterBlackBoardAttribute(self, "_enemy_yaw", undefined, &BB_VehGetEnemyYaw);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
}

/*
	Name: BB_GetSpeed
	Namespace: blackboard
	Checksum: 0xC5014C38
	Offset: 0x208
	Size: 0x39
	Parameters: 0
	Flags: None
*/
function BB_GetSpeed()
{
	velocity = self GetVelocity();
	return length(velocity);
}

/*
	Name: BB_VehGetEnemyYaw
	Namespace: blackboard
	Checksum: 0x6ADACB43
	Offset: 0x250
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function BB_VehGetEnemyYaw()
{
	enemy = self.enemy;
	if(!isdefined(enemy))
	{
		return 0;
	}
	toEnemyYaw = VehGetPredictedYawToEnemy(self, 0.2);
	return toEnemyYaw;
}

/*
	Name: VehGetPredictedYawToEnemy
	Namespace: blackboard
	Checksum: 0x935ED51A
	Offset: 0x2B0
	Size: 0x18F
	Parameters: 2
	Flags: None
*/
function VehGetPredictedYawToEnemy(entity, lookAheadTime)
{
	if(isdefined(entity.predictedYawToEnemy) && isdefined(entity.predictedYawToEnemyTime) && entity.predictedYawToEnemyTime == GetTime())
	{
		return entity.predictedYawToEnemy;
	}
	selfPredictedPos = entity.origin;
	moveAngle = entity.angles[1] + entity getMotionAngle();
	selfPredictedPos = selfPredictedPos + (cos(moveAngle), sin(moveAngle), 0) * 200 * lookAheadTime;
	yaw = VectorToAngles(entity.enemy.origin - selfPredictedPos)[1] - entity.angles[1];
	yaw = AbsAngleClamp360(yaw);
	entity.predictedYawToEnemy = yaw;
	entity.predictedYawToEnemyTime = GetTime();
	return yaw;
}

