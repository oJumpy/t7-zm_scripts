#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\system_shared;

#namespace footsteps;

/*
	Name: __init__sytem__
	Namespace: footsteps
	Checksum: 0x1B3A7C62
	Offset: 0x170
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("footsteps", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: footsteps
	Checksum: 0x2356D33
	Offset: 0x1B0
	Size: 0x19D
	Parameters: 0
	Flags: None
*/
function __init__()
{
	surfaceArray = getSurfaceStrings();
	movementArray = [];
	movementArray[movementArray.size] = "step_run";
	movementArray[movementArray.size] = "land";
	level.playerFootSounds = [];
	for(movementArrayIndex = 0; movementArrayIndex < movementArray.size; movementArrayIndex++)
	{
		movementType = movementArray[movementArrayIndex];
		for(surfaceArrayIndex = 0; surfaceArrayIndex < surfaceArray.size; surfaceArrayIndex++)
		{
			surfaceType = surfaceArray[surfaceArrayIndex];
			for(index = 0; index < 4; index++)
			{
				if(index < 2)
				{
					firstperson = 0;
				}
				else
				{
					firstperson = 1;
				}
				if(index % 2 == 0)
				{
					isLouder = 0;
				}
				else
				{
					isLouder = 1;
				}
				snd = buildAndCacheSoundAlias(movementType, surfaceType, firstperson, isLouder);
			}
		}
	}
}

/*
	Name: checkSurfaceTypeIsCorrect
	Namespace: footsteps
	Checksum: 0xE57EE82
	Offset: 0x358
	Size: 0x113
	Parameters: 2
	Flags: None
*/
function checkSurfaceTypeIsCorrect(moveType, surfaceType)
{
	/#
		if(!isdefined(level.playerFootSounds[moveType][surfaceType]))
		{
			println("Dev Block strings are not supported" + surfaceType + "Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			arraykeys = getArrayKeys(level.playerFootSounds[moveType]);
			for(i = 0; i < arraykeys.size; i++)
			{
				println(arraykeys[i]);
			}
			println("Dev Block strings are not supported");
		}
	#/
}

/*
	Name: playerJump
	Namespace: footsteps
	Checksum: 0x41C9C4E9
	Offset: 0x478
	Size: 0xCB
	Parameters: 6
	Flags: None
*/
function playerJump(client_num, player, surfaceType, firstperson, quiet, isLouder)
{
	if(isdefined(player.audioMaterialOverride))
	{
		surfaceType = player.audioMaterialOverride;
		/#
			checkSurfaceTypeIsCorrect("Dev Block strings are not supported", surfaceType);
		#/
	}
	sound_alias = level.playerFootSounds["step_run"][surfaceType][firstperson][isLouder];
	player playsound(client_num, sound_alias);
}

/*
	Name: playerLand
	Namespace: footsteps
	Checksum: 0x804095FA
	Offset: 0x550
	Size: 0x1D3
	Parameters: 7
	Flags: None
*/
function playerLand(client_num, player, surfaceType, firstperson, quiet, damagePlayer, isLouder)
{
	if(isdefined(player.audioMaterialOverride))
	{
		surfaceType = player.audioMaterialOverride;
		/#
			checkSurfaceTypeIsCorrect("Dev Block strings are not supported", surfaceType);
		#/
	}
	sound_alias = level.playerFootSounds["land"][surfaceType][firstperson][isLouder];
	player playsound(client_num, sound_alias);
	if(isdefined(player.step_sound) && !quiet && player.step_sound != "none")
	{
		volume = audio::get_vol_from_speed(player);
		player playsound(client_num, player.step_sound, player.origin, volume);
	}
	if(damagePlayer)
	{
		if(isdefined(level.playerFallDamageSound))
		{
			player [[level.playerFallDamageSound]](client_num, firstperson);
		}
		else
		{
			sound_alias = "fly_land_damage_npc";
			if(firstperson)
			{
				sound_alias = "fly_land_damage_plr";
				player playsound(client_num, sound_alias);
			}
		}
	}
}

/*
	Name: playerFoliage
	Namespace: footsteps
	Checksum: 0xE83C03C1
	Offset: 0x730
	Size: 0x9B
	Parameters: 4
	Flags: None
*/
function playerFoliage(client_num, player, firstperson, quiet)
{
	sound_alias = "fly_movement_foliage_npc";
	if(firstperson)
	{
		sound_alias = "fly_movement_foliage_plr";
	}
	volume = audio::get_vol_from_speed(player);
	player playsound(client_num, sound_alias, player.origin, volume);
}

/*
	Name: buildAndCacheSoundAlias
	Namespace: footsteps
	Checksum: 0x19E5897
	Offset: 0x7D8
	Size: 0x233
	Parameters: 4
	Flags: None
*/
function buildAndCacheSoundAlias(movementType, surfaceType, firstperson, isLouder)
{
	sound_alias = "fly_" + movementType;
	if(firstperson)
	{
		sound_alias = sound_alias + "_plr_";
	}
	else
	{
		sound_alias = sound_alias + "_npc_";
	}
	sound_alias = sound_alias + surfaceType;
	if(!isdefined(level.playerFootSounds))
	{
		level.playerFootSounds = [];
	}
	if(!isdefined(level.playerFootSounds[movementType]))
	{
		level.playerFootSounds[movementType] = [];
	}
	if(!isdefined(level.playerFootSounds[movementType][surfaceType]))
	{
		level.playerFootSounds[movementType][surfaceType] = [];
	}
	if(!isdefined(level.playerFootSounds[movementType][surfaceType][firstperson]))
	{
		level.playerFootSounds[movementType][surfaceType][firstperson] = [];
	}
	/#
		Assert(IsArray(level.playerFootSounds));
	#/
	/#
		Assert(IsArray(level.playerFootSounds[movementType]));
	#/
	/#
		Assert(IsArray(level.playerFootSounds[movementType][surfaceType]));
	#/
	/#
		Assert(IsArray(level.playerFootSounds[movementType][surfaceType][firstperson]));
	#/
	level.playerFootSounds[movementType][surfaceType][firstperson][isLouder] = sound_alias;
	return sound_alias;
}

/*
	Name: do_foot_effect
	Namespace: footsteps
	Checksum: 0x681FD8A3
	Offset: 0xA18
	Size: 0x157
	Parameters: 4
	Flags: None
*/
function do_foot_effect(client_num, ground_type, foot_pos, on_fire)
{
	if(!isdefined(level._optionalStepEffects))
	{
		return;
	}
	if(on_fire)
	{
		ground_type = "fire";
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported"))
		{
			print3d(foot_pos, ground_type, (0.5, 0.5, 0.8), 1, 3, 30);
		}
	#/
	for(i = 0; i < level._optionalStepEffects.size; i++)
	{
		if(level._optionalStepEffects[i] == ground_type)
		{
			effect = "fly_step_" + ground_type;
			if(isdefined(level._effect[effect]))
			{
				playFX(client_num, level._effect[effect], foot_pos, foot_pos + VectorScale((0, 0, 1), 100));
				return;
			}
		}
	}
}

/*
	Name: missing_ai_footstep_callback
	Namespace: footsteps
	Checksum: 0x2E5C63DC
	Offset: 0xB78
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function missing_ai_footstep_callback()
{
	/#
		type = self.archetype;
		if(!isdefined(type))
		{
			type = "Dev Block strings are not supported";
		}
		println("Dev Block strings are not supported" + type + "Dev Block strings are not supported" + self._aitype + "Dev Block strings are not supported");
	#/
}

/*
	Name: playaifootstep
	Namespace: footsteps
	Checksum: 0xCED7A97A
	Offset: 0xBF0
	Size: 0xE1
	Parameters: 5
	Flags: None
*/
function playaifootstep(client_num, pos, surface, Notetrack, bone)
{
	if(!isdefined(self.archetype))
	{
		/#
			println("Dev Block strings are not supported");
		#/
		FootstepDoEverything();
		return;
	}
	if(!isdefined(level._footstepCBFuncs) || !isdefined(level._footstepCBFuncs[self.archetype]))
	{
		self missing_ai_footstep_callback();
		FootstepDoEverything();
		return;
	}
	[[level._footstepCBFuncs[self.archetype]]](client_num, pos, surface, Notetrack, bone);
}

