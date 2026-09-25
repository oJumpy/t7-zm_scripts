#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace clientfaceanim;

/*
	Name: __init__sytem__
	Namespace: clientfaceanim
	Checksum: 0x80E118D8
	Offset: 0x328
	Size: 0x2B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("clientfaceanim_shared", undefined, &main, undefined);
}

/*
	Name: main
	Namespace: clientfaceanim
	Checksum: 0xA42D971C
	Offset: 0x360
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function main()
{
	callback::on_spawned(&on_player_spawned);
	level._clientFaceAnimOnPlayerSpawned = &on_player_spawned;
}

/*
	Name: on_player_spawned
	Namespace: clientfaceanim
	Checksum: 0xBBE2C022
	Offset: 0x3A8
	Size: 0x5B
	Parameters: 1
	Flags: Private
*/
function private on_player_spawned(localClientNum)
{
	FacialAnimationsInit(localClientNum);
	self callback::on_shutdown(&on_player_shutdown);
	self thread on_player_death(localClientNum);
}

/*
	Name: on_player_shutdown
	Namespace: clientfaceanim
	Checksum: 0x313D414B
	Offset: 0x410
	Size: 0xD7
	Parameters: 1
	Flags: Private
*/
function private on_player_shutdown(localClientNum)
{
	if(self isPlayer())
	{
		self notify("stopFacialThread");
		corpse = self GetPlayerCorpse();
		if(!isdefined(corpse))
		{
			return;
		}
		if(isdefined(corpse.facialDeathAnimStarted) && corpse.facialDeathAnimStarted)
		{
			return;
		}
		corpse util::waittill_dobj(localClientNum);
		if(isdefined(corpse))
		{
			corpse ApplyDeathAnim(localClientNum);
			corpse.facialDeathAnimStarted = 1;
		}
	}
}

/*
	Name: on_player_death
	Namespace: clientfaceanim
	Checksum: 0xF32C995
	Offset: 0x4F0
	Size: 0xE7
	Parameters: 1
	Flags: Private
*/
function private on_player_death(localClientNum)
{
	self endon("entityshutdown");
	self waittill("death");
	if(self isPlayer())
	{
		self notify("stopFacialThread");
		corpse = self GetPlayerCorpse();
		if(isdefined(corpse.facialDeathAnimStarted) && corpse.facialDeathAnimStarted)
		{
			return;
		}
		corpse util::waittill_dobj(localClientNum);
		if(isdefined(corpse))
		{
			corpse ApplyDeathAnim(localClientNum);
			corpse.facialDeathAnimStarted = 1;
		}
	}
}

/*
	Name: FacialAnimationsInit
	Namespace: clientfaceanim
	Checksum: 0xFA166F08
	Offset: 0x5E0
	Size: 0x53
	Parameters: 1
	Flags: Private
*/
function private FacialAnimationsInit(localClientNum)
{
	BuildAndValidateFacialAnimationList(localClientNum);
	if(self isPlayer())
	{
		self thread FacialAnimationThink(localClientNum);
	}
}

/*
	Name: BuildAndValidateFacialAnimationList
	Namespace: clientfaceanim
	Checksum: 0xC86E8F29
	Offset: 0x640
	Size: 0x2B9
	Parameters: 1
	Flags: None
*/
function BuildAndValidateFacialAnimationList(localClientNum)
{
	if(!isdefined(level.__clientFacialAnimationsList))
	{
		level.__clientFacialAnimationsList = [];
		level.__clientFacialAnimationsList["combat"] = Array("ai_face_male_generic_idle_1", "ai_face_male_generic_idle_2", "ai_face_male_generic_idle_3");
		level.__clientFacialAnimationsList["combat_shoot"] = Array("ai_face_male_aim_fire_1", "ai_face_male_aim_fire_2", "ai_face_male_aim_fire_3");
		level.__clientFacialAnimationsList["death"] = Array("ai_face_male_death_1", "ai_face_male_death_2", "ai_face_male_death_3");
		level.__clientFacialAnimationsList["melee"] = Array("ai_face_male_melee_1");
		level.__clientFacialAnimationsList["pain"] = Array("ai_face_male_pain_1");
		level.__clientFacialAnimationsList["swimming"] = Array("mp_face_male_swim_idle_1");
		level.__clientFacialAnimationsList["jumping"] = Array("mp_face_male_jump_idle_1");
		level.__clientFacialAnimationsList["sliding"] = Array("mp_face_male_slides_1");
		level.__clientFacialAnimationsList["sprinting"] = Array("mp_face_male_sprint_1");
		level.__clientFacialAnimationsList["wallrunning"] = Array("mp_face_male_wall_run_1");
		deathAnims = level.__clientFacialAnimationsList["death"];
		foreach(deathAnim in deathAnims)
		{
			/#
				Assert(!IsAnimLooping(localClientNum, deathAnim), "Dev Block strings are not supported" + deathAnim + "Dev Block strings are not supported");
			#/
		}
	}
}

/*
	Name: FacialAnimationThink_getWaitTime
	Namespace: clientfaceanim
	Checksum: 0x5CBB042C
	Offset: 0x908
	Size: 0x16F
	Parameters: 1
	Flags: Private
*/
function private FacialAnimationThink_getWaitTime(localClientNum)
{
	if(!isdefined(localClientNum))
	{
		return 1;
	}
	min_wait = 0.1;
	max_wait = 1;
	min_wait_distance_sq = 2500;
	max_wait_distance_sq = 640000;
	local_player = GetLocalPlayer(localClientNum);
	if(!isdefined(local_player))
	{
		return max_wait;
	}
	if(local_player == self && !IsThirdPerson(localClientNum))
	{
		return max_wait;
	}
	distanceSq = DistanceSquared(local_player.origin, self.origin);
	if(distanceSq > max_wait_distance_sq)
	{
		distance_factor = 1;
	}
	else if(distanceSq < min_wait_distance_sq)
	{
		distance_factor = 0;
	}
	else
	{
		distance_factor = distanceSq - min_wait_distance_sq / max_wait_distance_sq - min_wait_distance_sq;
	}
	return max_wait - min_wait * distance_factor + min_wait;
}

/*
	Name: FacialAnimationThink
	Namespace: clientfaceanim
	Checksum: 0xB6D6EF24
	Offset: 0xA80
	Size: 0xF1
	Parameters: 1
	Flags: Private
*/
function private FacialAnimationThink(localClientNum)
{
	self endon("entityshutdown");
	self notify("stopFacialThread");
	self endon("stopFacialThread");
	if(isdefined(self.__clientFacialAnimationsThinkStarted))
	{
		return;
	}
	self.__clientFacialAnimationsThinkStarted = 1;
	/#
		Assert(self isPlayer());
	#/
	self util::waittill_dobj(localClientNum);
	while(isdefined(self))
	{
		UpdateFacialAnimForPlayer(localClientNum, self);
		wait_time = self FacialAnimationThink_getWaitTime(localClientNum);
		if(!isdefined(wait_time))
		{
			wait_time = 1;
		}
		wait(wait_time);
	}
}

/*
	Name: UpdateFacialAnimForPlayer
	Namespace: clientfaceanim
	Checksum: 0x4E24A182
	Offset: 0xB80
	Size: 0x2A7
	Parameters: 2
	Flags: Private
*/
function private UpdateFacialAnimForPlayer(localClientNum, player)
{
	if(!isdefined(player))
	{
		return;
	}
	if(!isdefined(localClientNum))
	{
		return;
	}
	if(!isdefined(player._currentFaceState))
	{
		player._currentFaceState = "inactive";
	}
	currFaceState = player._currentFaceState;
	nextFaceState = player._currentFaceState;
	if(player IsInScritpedAnim())
	{
		ClearAllFacialAnims(localClientNum);
		player._currentFaceState = "inactive";
		return;
	}
	if(player IsPlayerDead())
	{
		nextFaceState = "death";
	}
	else if(player IsPlayerFiring())
	{
		nextFaceState = "combat_shoot";
	}
	else if(player IsPlayerSliding())
	{
		nextFaceState = "sliding";
	}
	else if(player isplayerwallrunning())
	{
		nextFaceState = "wallrunning";
	}
	else if(player IsPlayerSprinting())
	{
		nextFaceState = "sprinting";
	}
	else if(player IsPlayerJumping() || player IsPlayerDoubleJumping())
	{
		nextFaceState = "jumping";
	}
	else if(player IsPlayerSwimming())
	{
		nextFaceState = "swimming";
	}
	else
	{
		nextFaceState = "combat";
	}
	if(player._currentFaceState == "inactive" || currFaceState != nextFaceState)
	{
		/#
			Assert(isdefined(level.__clientFacialAnimationsList[nextFaceState]));
		#/
		ApplyNewFaceAnim(localClientNum, Array::random(level.__clientFacialAnimationsList[nextFaceState]));
		player._currentFaceState = nextFaceState;
	}
}

/*
	Name: ApplyNewFaceAnim
	Namespace: clientfaceanim
	Checksum: 0x962F22E9
	Offset: 0xE30
	Size: 0x7B
	Parameters: 2
	Flags: Private
*/
function private ApplyNewFaceAnim(localClientNum, animation)
{
	ClearAllFacialAnims(localClientNum);
	if(isdefined(animation))
	{
		self._currentFaceAnim = animation;
		self SetFlaggedAnimKnob("ai_secondary_facial_anim", animation, 1, 0.1, 1);
	}
}

/*
	Name: ApplyDeathAnim
	Namespace: clientfaceanim
	Checksum: 0x4E830B8D
	Offset: 0xEB8
	Size: 0xA3
	Parameters: 1
	Flags: Private
*/
function private ApplyDeathAnim(localClientNum)
{
	if(isdefined(self._currentFaceState) && self._currentFaceState == "death")
	{
		return;
	}
	if(isdefined(self) && isdefined(level.__clientFacialAnimationsList) && isdefined(level.__clientFacialAnimationsList["death"]))
	{
		self._currentFaceState = "death";
		ApplyNewFaceAnim(localClientNum, Array::random(level.__clientFacialAnimationsList["death"]));
	}
}

/*
	Name: ClearAllFacialAnims
	Namespace: clientfaceanim
	Checksum: 0x87D8F06A
	Offset: 0xF68
	Size: 0x65
	Parameters: 1
	Flags: Private
*/
function private ClearAllFacialAnims(localClientNum)
{
	if(isdefined(self._currentFaceAnim) && self hasdobj(localClientNum))
	{
		self ClearAnim(self._currentFaceAnim, 0.2);
	}
	self._currentFaceAnim = undefined;
}

