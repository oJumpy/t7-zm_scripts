#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace AiSquads;

/*
	Name: __init__sytem__
	Namespace: AiSquads
	Checksum: 0x912F91FC
	Offset: 0x190
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ai_squads", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: AiSquads
	Checksum: 0x67AAFBBE
	Offset: 0x1D0
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._squads = [];
	actorSpawnerArray = GetActorSpawnerTeamArray("axis");
	Array::run_all(actorSpawnerArray, &spawner::add_spawn_function, &SquadMemberThink);
}

#namespace SQUAD;

/*
	Name: function_9b385ca5
	Namespace: SQUAD
	Checksum: 0x4FA8A6EA
	Offset: 0x248
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
	self.squadLeader = 0;
	self.squadMembers = [];
	self.squadBreadCrumb = [];
}

/*
	Name: addSquadBreadCrumbs
	Namespace: SQUAD
	Checksum: 0x765756E1
	Offset: 0x278
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function addSquadBreadCrumbs(ai)
{
	/#
		Assert(self.squadLeader == ai);
	#/
	if(Distance2DSquared(self.squadBreadCrumb, ai.origin) >= 9216)
	{
		/#
			RecordCircle(ai.origin, 4, (0, 0, 1), "Dev Block strings are not supported", ai);
		#/
		self.squadBreadCrumb = ai.origin;
	}
}

/*
	Name: getSquadBreadCrumb
	Namespace: SQUAD
	Checksum: 0x6B4D95D4
	Offset: 0x338
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function getSquadBreadCrumb()
{
	return self.squadBreadCrumb;
}

/*
	Name: GetLeader
	Namespace: SQUAD
	Checksum: 0xDC71063C
	Offset: 0x350
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function GetLeader()
{
	return self.squadLeader;
}

/*
	Name: GetMembers
	Namespace: SQUAD
	Checksum: 0xFA8C37B4
	Offset: 0x368
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function GetMembers()
{
	return self.squadMembers;
}

/*
	Name: AddAIToSquad
	Namespace: SQUAD
	Checksum: 0x4437EDA6
	Offset: 0x380
	Size: 0x81
	Parameters: 1
	Flags: None
*/
function AddAIToSquad(ai)
{
	if(!IsInArray(self.squadMembers, ai))
	{
		if(ai.archetype == "robot")
		{
			ai ai::set_behavior_attribute("move_mode", "squadmember");
		}
		self.squadMembers[self.squadMembers.size] = ai;
	}
}

/*
	Name: RemoveAIFromSqaud
	Namespace: SQUAD
	Checksum: 0x96AA4CC2
	Offset: 0x410
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function RemoveAIFromSqaud(ai)
{
	if(IsInArray(self.squadMembers, ai))
	{
		ArrayRemoveValue(self.squadMembers, ai, 0);
		if(self.squadLeader === ai)
		{
			self.squadLeader = undefined;
		}
	}
}

/*
	Name: think
	Namespace: SQUAD
	Checksum: 0xE3F2F60C
	Offset: 0x480
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function think()
{
	if(IsInt(self.squadLeader) && self.squadLeader == 0 || !isdefined(self.squadLeader))
	{
		if(self.squadMembers.size > 0)
		{
			self.squadLeader = self.squadMembers[0];
			self.squadBreadCrumb = self.squadLeader.origin;
		}
		else
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: function_5fba2032
	Namespace: SQUAD
	Checksum: 0x99EC1590
	Offset: 0x510
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

#namespace AiSquads;

/*
	Name: SQUAD
	Namespace: AiSquads
	Checksum: 0x9F08AEC8
	Offset: 0x520
	Size: 0x1D5
	Parameters: 0
	Flags: 6
*/
function private autoexec SQUAD()
{
	classes.SQUAD[0] = spawnstruct();
	classes.SQUAD[0].__vtable[1606033458] = &SQUAD::function_5fba2032;
	classes.SQUAD[0].__vtable[1077602763] = &SQUAD::think;
	classes.SQUAD[0].__vtable[-956678077] = &SQUAD::RemoveAIFromSqaud;
	classes.SQUAD[0].__vtable[2131588255] = &SQUAD::AddAIToSquad;
	classes.SQUAD[0].__vtable[16176468] = &SQUAD::GetMembers;
	classes.SQUAD[0].__vtable[-667235832] = &SQUAD::GetLeader;
	classes.SQUAD[0].__vtable[-407785572] = &SQUAD::getSquadBreadCrumb;
	classes.SQUAD[0].__vtable[-997895106] = &SQUAD::addSquadBreadCrumbs;
	classes.SQUAD[0].__vtable[-1690805083] = &SQUAD::function_9b385ca5;
}

/*
	Name: CreateSquad
	Namespace: AiSquads
	Checksum: 0xC47ACE35
	Offset: 0x700
	Size: 0x37
	Parameters: 1
	Flags: Private
*/
function private CreateSquad(squadName)
{
	function_9b385ca5();
	level._squads[squadName] = SQUAD;
	return level._squads[squadName];
}

/*
	Name: RemoveSquad
	Namespace: AiSquads
	Checksum: 0xB71A0BEE
	Offset: 0x740
	Size: 0x37
	Parameters: 1
	Flags: Private
*/
function private RemoveSquad(squadName)
{
	if(isdefined(level._squads) && isdefined(level._squads[squadName]))
	{
		level._squads[squadName] = undefined;
	}
}

/*
	Name: GetSquad
	Namespace: AiSquads
	Checksum: 0x19402E25
	Offset: 0x780
	Size: 0x17
	Parameters: 1
	Flags: Private
*/
function private GetSquad(squadName)
{
	return level._squads[squadName];
}

/*
	Name: ThinkSquad
	Namespace: AiSquads
	Checksum: 0xFC4FD04C
	Offset: 0x7A0
	Size: 0x5B
	Parameters: 1
	Flags: Private
*/
function private ThinkSquad(squadName)
{
	while(1)
	{
		if(think())
		{
			wait(0.5);
		}
		else
		{
			RemoveSquad(squadName);
			break;
		}
	}
}

/*
	Name: SquadMemberDeath
	Namespace: AiSquads
	Checksum: 0x7D4AAC42
	Offset: 0x808
	Size: 0x53
	Parameters: 0
	Flags: Private
*/
function private SquadMemberDeath()
{
	self waittill("death");
	if(isdefined(self.squadName) && isdefined(level._squads[self.squadName]))
	{
		RemoveAIFromSqaud(level._squads[self.squadName]);
	}
}

/*
	Name: SquadMemberThink
	Namespace: AiSquads
	Checksum: 0x75D41FE9
	Offset: 0x868
	Size: 0x415
	Parameters: 0
	Flags: Private
*/
function private SquadMemberThink()
{
	self endon("death");
	if(!isdefined(self.script_aisquadname))
	{
		return;
	}
	wait(0.5);
	self.squadName = self.script_aisquadname;
	if(isdefined(self.squadName))
	{
		if(!isdefined(level._squads[self.squadName]))
		{
			SQUAD = CreateSquad(self.squadName);
			newSquadCreated = 1;
		}
		else
		{
			SQUAD = GetSquad(self.squadName);
		}
		AddAIToSquad(SQUAD);
		self thread SquadMemberDeath();
		if(isdefined(newSquadCreated) && newSquadCreated)
		{
			level thread ThinkSquad(self.squadName);
		}
		while(1)
		{
			squadLeader = GetLeader();
			if(isdefined(squadLeader) && (!IsInt(squadLeader) && squadLeader == 0))
			{
				if(squadLeader == self)
				{
					/#
						recordEntText(self.squadName + "Dev Block strings are not supported", self, (0, 1, 0), "Dev Block strings are not supported");
					#/
					/#
						recordEntText(self.squadName + "Dev Block strings are not supported", self, (0, 1, 0), "Dev Block strings are not supported");
					#/
					/#
						RecordCircle(self.origin, 300, (1, 0.5, 0), "Dev Block strings are not supported", self);
					#/
					if(isdefined(self.enemy))
					{
						self SetGoal(self.enemy);
					}
					addSquadBreadCrumbs(SQUAD);
				}
				else
				{
					recordLine(self.origin, squadLeader.origin, (0, 1, 0), "Dev Block strings are not supported", self);
					/#
						recordEntText(self.squadName + "Dev Block strings are not supported", self, (0, 1, 0), "Dev Block strings are not supported");
					#/
					followPosition = getSquadBreadCrumb();
					followDistSq = Distance2DSquared(self.goalpos, followPosition);
					if(isdefined(squadLeader.enemy))
					{
						if(!isdefined(self.enemy) || (isdefined(self.enemy) && self.enemy != squadLeader.enemy))
						{
							self SetEntityTarget(squadLeader.enemy, 1);
						}
					}
					if(isdefined(self.goalpos) && followDistSq >= 256)
					{
						if(followDistSq >= 22500)
						{
							self ai::set_behavior_attribute("sprint", 1);
						}
						else
						{
							self ai::set_behavior_attribute("sprint", 0);
						}
						self SetGoal(followPosition, 1);
					}
				}
				/#
				#/
			}
			wait(1);
		}
	}
}

/*
	Name: isFollowingSquadLeader
	Namespace: AiSquads
	Checksum: 0x86AE2925
	Offset: 0xC88
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function isFollowingSquadLeader(ai)
{
	if(ai ai::get_behavior_attribute("move_mode") != "squadmember")
	{
		return 0;
	}
	squadMember = isSquadMember(ai);
	currentSquadLeader = getSquadLeader(ai);
	isAISquadLeader = isdefined(currentSquadLeader) && currentSquadLeader == ai;
	if(squadMember && !isAISquadLeader)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isSquadMember
	Namespace: AiSquads
	Checksum: 0xC03C3F11
	Offset: 0xD50
	Size: 0x75
	Parameters: 1
	Flags: None
*/
function isSquadMember(ai)
{
	if(isdefined(ai.squadName))
	{
		SQUAD = GetSquad(ai.squadName);
		if(isdefined(SQUAD))
		{
			return IsInArray(GetMembers(), SQUAD);
		}
	}
	return 0;
}

/*
	Name: isSquadLeader
	Namespace: AiSquads
	Checksum: 0xF0293A3F
	Offset: 0xDD0
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function isSquadLeader(ai)
{
	if(isdefined(ai.squadName))
	{
		SQUAD = GetSquad(ai.squadName);
		if(isdefined(SQUAD))
		{
			squadLeader = GetLeader();
			return isdefined(squadLeader) && squadLeader == ai;
		}
	}
	return 0;
}

/*
	Name: getSquadLeader
	Namespace: AiSquads
	Checksum: 0x166F1A3
	Offset: 0xE60
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function getSquadLeader(ai)
{
	if(isdefined(ai.squadName))
	{
		SQUAD = GetSquad(ai.squadName);
		if(isdefined(SQUAD))
		{
			return GetLeader();
		}
	}
	return undefined;
}

