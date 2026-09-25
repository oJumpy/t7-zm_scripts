#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace burnplayer;

/*
	Name: __init__sytem__
	Namespace: burnplayer
	Checksum: 0x2C5A3FB8
	Offset: 0x5C8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("burnplayer", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: burnplayer
	Checksum: 0x2AACD918
	Offset: 0x608
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("allplayers", "burn", 1, 1, "int", &burning_callback, 0, 0);
	clientfield::register("playercorpse", "burned_effect", 1, 1, "int", &burning_corpse_callback, 0, 1);
	LoadEffects();
	callback::on_localplayer_spawned(&on_localplayer_spawned);
	callback::on_localclient_connect(&on_local_client_connect);
}

/*
	Name: LoadEffects
	Namespace: burnplayer
	Checksum: 0x823E30CC
	Offset: 0x6F8
	Size: 0x2A3
	Parameters: 0
	Flags: None
*/
function LoadEffects()
{
	level._effect["burn_j_elbow_le_loop"] = "fire/fx_fire_ai_human_arm_left_loop";
	level._effect["burn_j_elbow_ri_loop"] = "fire/fx_fire_ai_human_arm_right_loop";
	level._effect["burn_j_shoulder_le_loop"] = "fire/fx_fire_ai_human_arm_left_loop";
	level._effect["burn_j_shoulder_ri_loop"] = "fire/fx_fire_ai_human_arm_right_loop";
	level._effect["burn_j_spine4_loop"] = "fire/fx_fire_ai_human_torso_loop";
	level._effect["burn_j_hip_le_loop"] = "fire/fx_fire_ai_human_hip_left_loop";
	level._effect["burn_j_hip_ri_loop"] = "fire/fx_fire_ai_human_hip_right_loop";
	level._effect["burn_j_knee_le_loop"] = "fire/fx_fire_ai_human_leg_left_loop";
	level._effect["burn_j_knee_ri_loop"] = "fire/fx_fire_ai_human_leg_right_loop";
	level._effect["burn_j_head_loop"] = "fire/fx_fire_ai_human_head_loop";
	level._effect["burn_j_elbow_le_os"] = "fire/fx_fire_ai_human_arm_left_os";
	level._effect["burn_j_elbow_ri_os"] = "fire/fx_fire_ai_human_arm_right_os";
	level._effect["burn_j_shoulder_le_os"] = "fire/fx_fire_ai_human_arm_left_os";
	level._effect["burn_j_shoulder_ri_os"] = "fire/fx_fire_ai_human_arm_right_os";
	level._effect["burn_j_spine4_os"] = "fire/fx_fire_ai_human_torso_os";
	level._effect["burn_j_hip_le_os"] = "fire/fx_fire_ai_human_hip_left_os";
	level._effect["burn_j_hip_ri_os"] = "fire/fx_fire_ai_human_hip_right_os";
	level._effect["burn_j_knee_le_os"] = "fire/fx_fire_ai_human_leg_left_os";
	level._effect["burn_j_knee_ri_os"] = "fire/fx_fire_ai_human_leg_right_os";
	level._effect["burn_j_head_os"] = "fire/fx_fire_ai_human_head_os";
	level.burnTags = Array("j_elbow_le", "j_elbow_ri", "j_shoulder_le", "j_shoulder_ri", "j_spine4", "j_spinelower", "j_hip_le", "j_hip_ri", "j_head", "j_knee_le", "j_knee_ri");
}

/*
	Name: on_local_client_connect
	Namespace: burnplayer
	Checksum: 0x86C9B965
	Offset: 0x9A8
	Size: 0x19B
	Parameters: 1
	Flags: None
*/
function on_local_client_connect(localClientNum)
{
	RegisterRewindFX(localClientNum, level._effect["burn_j_elbow_le_loop"]);
	RegisterRewindFX(localClientNum, level._effect["burn_j_elbow_ri_loop"]);
	RegisterRewindFX(localClientNum, level._effect["burn_j_shoulder_le_loop"]);
	RegisterRewindFX(localClientNum, level._effect["burn_j_shoulder_ri_loop"]);
	RegisterRewindFX(localClientNum, level._effect["burn_j_spine4_loop"]);
	RegisterRewindFX(localClientNum, level._effect["burn_j_hip_le_loop"]);
	RegisterRewindFX(localClientNum, level._effect["burn_j_hip_ri_loop"]);
	RegisterRewindFX(localClientNum, level._effect["burn_j_knee_le_loop"]);
	RegisterRewindFX(localClientNum, level._effect["burn_j_knee_ri_loop"]);
	RegisterRewindFX(localClientNum, level._effect["burn_j_head_loop"]);
}

/*
	Name: on_localplayer_spawned
	Namespace: burnplayer
	Checksum: 0x176A723C
	Offset: 0xB50
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function on_localplayer_spawned(localClientNum)
{
}

/*
	Name: burning_callback
	Namespace: burnplayer
	Checksum: 0x116D6DD1
	Offset: 0xB68
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function burning_callback(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self burn_on(localClientNum);
	}
	else
	{
		self burn_off(localClientNum);
	}
}

/*
	Name: burning_corpse_callback
	Namespace: burnplayer
	Checksum: 0xD842ABAD
	Offset: 0xBF0
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function burning_corpse_callback(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self set_corpse_burning(localClientNum);
	}
	else
	{
		self burn_off(localClientNum);
	}
}

/*
	Name: set_corpse_burning
	Namespace: burnplayer
	Checksum: 0x7DD0ECEA
	Offset: 0xC78
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function set_corpse_burning(localClientNum)
{
	self thread _burnBody(localClientNum);
}

/*
	Name: burn_off
	Namespace: burnplayer
	Checksum: 0x7139D5A5
	Offset: 0xCA8
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function burn_off(localClientNum)
{
	self notify("burn_off");
	if(GetLocalPlayer(localClientNum) == self)
	{
		self postfx::exitPostfxBundle();
	}
}

/*
	Name: burn_on
	Namespace: burnplayer
	Checksum: 0xF0906393
	Offset: 0xD00
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function burn_on(localClientNum)
{
	if(GetLocalPlayer(localClientNum) != self || IsThirdPerson(localClientNum))
	{
		self thread _burnBody(localClientNum);
	}
	if(GetLocalPlayer(localClientNum) == self && !IsThirdPerson(localClientNum))
	{
		self thread burn_on_postfx();
	}
}

/*
	Name: burn_on_postfx
	Namespace: burnplayer
	Checksum: 0xEF32489E
	Offset: 0xDB8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function burn_on_postfx()
{
	self endon("entityshutdown");
	self endon("burn_off");
	self endon("death");
	self notify("burn_on_postfx");
	self endon("burn_on_postfx");
	self thread postfx::playPostfxBundle("pstfx_burn_loop");
}

/*
	Name: _burnTag
	Namespace: burnplayer
	Checksum: 0x4CA29FA9
	Offset: 0xE20
	Size: 0x9B
	Parameters: 3
	Flags: Private
*/
function private _burnTag(localClientNum, tag, postfix)
{
	if(isdefined(self) && self hasdobj(localClientNum))
	{
		fxName = "burn_" + tag + postfix;
		if(isdefined(level._effect[fxName]))
		{
			return PlayFXOnTag(localClientNum, level._effect[fxName], self, tag);
		}
	}
}

/*
	Name: _burnTagsOn
	Namespace: burnplayer
	Checksum: 0x4D43A99B
	Offset: 0xEC8
	Size: 0x12B
	Parameters: 2
	Flags: Private
*/
function private _burnTagsOn(localClientNum, tags)
{
	if(!isdefined(self))
	{
		return;
	}
	self endon("entityshutdown");
	self endon("burn_off");
	self notify("burn_tags_on");
	self endon("burn_tags_on");
	activeFx = [];
	for(i = 0; i < tags.size; i++)
	{
		activeFx[activeFx.size] = self _burnTag(localClientNum, tags[i], "_loop");
	}
	burnSound = self PlayLoopSound("chr_burn_loop_overlay", 0.5);
	self thread _burnTagsWatchEnd(localClientNum, activeFx, burnSound);
	self thread _burnTagsWatchClear(localClientNum, activeFx, burnSound);
}

/*
	Name: _burnBody
	Namespace: burnplayer
	Checksum: 0xDDE1AF08
	Offset: 0x1000
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private _burnBody(localClientNum)
{
	self endon("entityshutdown");
	self thread _burnTagsOn(localClientNum, level.burnTags);
}

/*
	Name: _burnTagsWatchEnd
	Namespace: burnplayer
	Checksum: 0xF6F2BF4C
	Offset: 0x1040
	Size: 0xF1
	Parameters: 3
	Flags: Private
*/
function private _burnTagsWatchEnd(localClientNum, fxArray, burnSound)
{
	self endon("entityshutdown");
	self waittill("burn_off");
	if(isdefined(burnSound))
	{
		self StopLoopSound(burnSound, 1);
	}
	if(isdefined(fxArray))
	{
		foreach(FX in fxArray)
		{
			stopfx(localClientNum, FX);
		}
	}
}

/*
	Name: _burnTagsWatchClear
	Namespace: burnplayer
	Checksum: 0xAC4DE82A
	Offset: 0x1140
	Size: 0xE9
	Parameters: 3
	Flags: Private
*/
function private _burnTagsWatchClear(localClientNum, fxArray, burnSound)
{
	self endon("burn_off");
	self waittill("entityshutdown");
	if(isdefined(burnSound))
	{
		stopSound(burnSound);
	}
	if(isdefined(fxArray))
	{
		foreach(FX in fxArray)
		{
			stopfx(localClientNum, FX);
		}
	}
}

