#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;

#namespace blackboard;

/*
	Name: RegisterActorBlackBoardAttributes
	Namespace: blackboard
	Checksum: 0x4F82761F
	Offset: 0x398
	Size: 0x1DB
	Parameters: 0
	Flags: None
*/
function RegisterActorBlackBoardAttributes()
{
	RegisterBlackBoardAttribute(self, "_tactical_arrival_facing_yaw", undefined, &BB_GetTacticalArrivalFacingYaw);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	RegisterBlackBoardAttribute(self, "_human_locomotion_movement_type", undefined, &BB_GetLocomotionMovementType);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	RegisterBlackBoardAttribute(self, "_human_cover_flankability", undefined, &BB_GetCoverFlankability);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	RegisterBlackBoardAttribute(self, "_arrival_type", undefined, &BB_GetArrivalType);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	RegisterBlackBoardAttribute(self, "_human_locomotion_variation", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
}

/*
	Name: BB_GetArrivalType
	Namespace: blackboard
	Checksum: 0x79234B33
	Offset: 0x580
	Size: 0x35
	Parameters: 0
	Flags: Private
*/
function private BB_GetArrivalType()
{
	if(self ai::get_behavior_attribute("disablearrivals"))
	{
		return "dont_arrive_at_goal";
	}
	return "arrive_at_goal";
}

/*
	Name: BB_GetTacticalArrivalFacingYaw
	Namespace: blackboard
	Checksum: 0x8DE58AA4
	Offset: 0x5C0
	Size: 0x39
	Parameters: 0
	Flags: Private
*/
function private BB_GetTacticalArrivalFacingYaw()
{
	return AngleClamp180(self.angles[1] - self.node.angles[1]);
}

/*
	Name: BB_GetLocomotionMovementType
	Namespace: blackboard
	Checksum: 0x3714CB1B
	Offset: 0x608
	Size: 0x1B9
	Parameters: 0
	Flags: Private
*/
function private BB_GetLocomotionMovementType()
{
	if(!ai::GetAiAttribute(self, "disablesprint"))
	{
		if(ai::GetAiAttribute(self, "sprint"))
		{
			return "human_locomotion_movement_sprint";
		}
		if(!isdefined(self.nearbyFriendlyCheck))
		{
			self.nearbyFriendlyCheck = 0;
		}
		now = GetTime();
		if(now >= self.nearbyFriendlyCheck)
		{
			self.nearbyFriendlyCount = GetActorTeamCountRadius(self.origin, 120, self.team, "neutral");
			self.nearbyFriendlyCheck = now + 500;
		}
		if(self.nearbyFriendlyCount >= 3)
		{
			return "human_locomotion_movement_default";
		}
		if(isdefined(self.enemy) && isdefined(self.runAndGunDist))
		{
			if(DistanceSquared(self.origin, self lastKnownPos(self.enemy)) > self.runAndGunDist * self.runAndGunDist)
			{
				return "human_locomotion_movement_sprint";
			}
		}
		else if(isdefined(self.goalpos) && isdefined(self.runAndGunDist))
		{
			if(DistanceSquared(self.origin, self.goalpos) > self.runAndGunDist * self.runAndGunDist)
			{
				return "human_locomotion_movement_sprint";
			}
		}
	}
	return "human_locomotion_movement_default";
}

/*
	Name: BB_GetCoverFlankability
	Namespace: blackboard
	Checksum: 0xAFBB2988
	Offset: 0x7D0
	Size: 0x1CD
	Parameters: 0
	Flags: Private
*/
function private BB_GetCoverFlankability()
{
	if(self ASMIsTransitionRunning())
	{
		return "unflankable";
	}
	if(!isdefined(self.node))
	{
		return "unflankable";
	}
	coverMode = GetBlackBoardAttribute(self, "_cover_mode");
	if(isdefined(coverMode))
	{
		coverNode = self.node;
		if(coverMode == "cover_alert" || coverMode == "cover_mode_none")
		{
			return "flankable";
		}
		if(coverNode.type == "Cover Pillar")
		{
			return coverMode == "cover_blind";
		}
		else if(coverNode.type == "Cover Left" || coverNode.type == "Cover Right")
		{
			return coverMode == "cover_blind" || coverMode == "cover_over";
		}
		else if(coverNode.type == "Cover Stand" || coverNode.type == "Conceal Stand" || (coverNode.type == "Cover Crouch" || coverNode.type == "Cover Crouch Window" || coverNode.type == "Conceal Crouch"))
		{
			return "flankable";
		}
	}
	return "unflankable";
}

