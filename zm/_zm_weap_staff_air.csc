#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weap_staff_common;

#namespace namespace_589e3c80;

/*
	Name: __init__sytem__
	Namespace: namespace_589e3c80
	Checksum: 0xEFBEA1
	Offset: 0x228
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_staff_air", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_589e3c80
	Checksum: 0x53E9C14D
	Offset: 0x268
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["whirlwind"] = "dlc5/zmb_weapon/fx_staff_air_impact_ug_miss";
	clientfield::register("scriptmover", "whirlwind_play_fx", 21000, 1, "int", &function_c6b66912, 0, 0);
	clientfield::register("actor", "air_staff_launch", 21000, 1, "int", &function_5640a6aa, 0, 0);
	clientfield::register("allplayers", "air_staff_source", 21000, 1, "int", &function_869adfb, 0, 0);
	level.var_1e7d95e0 = (0, 0, 0);
	level.var_654c7116 = [];
	namespace_c9806b9::function_4be5e665(GetWeapon("staff_air_upgraded"), "dlc5/zmb_weapon/fx_staff_charge_air_lv1");
}

/*
	Name: function_869adfb
	Namespace: namespace_589e3c80
	Checksum: 0x2A8C6E2E
	Offset: 0x3B0
	Size: 0x4B
	Parameters: 7
	Flags: None
*/
function function_869adfb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level.var_1e7d95e0 = self.origin;
}

/*
	Name: ragdoll_impact_watch
	Namespace: namespace_589e3c80
	Checksum: 0x472E06EE
	Offset: 0x408
	Size: 0x20D
	Parameters: 1
	Flags: None
*/
function ragdoll_impact_watch(localClientNum)
{
	self endon("entityshutdown");
	wait(0.1);
	waitTime = 0.016;
	gibSpeed = 500;
	prevOrigin = self.origin;
	WaitRealTime(waitTime);
	prevVel = self.origin - prevOrigin;
	prevSpeed = length(prevVel);
	prevOrigin = self.origin;
	WaitRealTime(waitTime);
	firstloop = 1;
	while(1)
	{
		vel = self.origin - prevOrigin;
		speed = length(vel);
		if(speed < prevSpeed * 0.5 && prevSpeed > gibSpeed * waitTime)
		{
			if(isdefined(level._effect["zombie_guts_explosion"]) && util::is_mature())
			{
				where = self GetTagOrigin("J_SpineLower");
				playFX(localClientNum, level._effect["zombie_guts_explosion"], where);
			}
			break;
		}
		if(prevSpeed < gibSpeed * waitTime && !firstloop)
		{
			break;
		}
		prevOrigin = self.origin;
		prevVel = vel;
		prevSpeed = speed;
		firstloop = 0;
		WaitRealTime(waitTime);
	}
}

/*
	Name: function_5640a6aa
	Namespace: namespace_589e3c80
	Checksum: 0x5DD287AD
	Offset: 0x620
	Size: 0x203
	Parameters: 7
	Flags: None
*/
function function_5640a6aa(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	v_source = level.var_1e7d95e0;
	var_8178243a = RandomFloatRange(0.05, 0.35);
	var_bf0620ca = level.var_654c7116[localClientNum];
	if(isdefined(var_bf0620ca))
	{
		dist_sq = DistanceSquared(var_bf0620ca, self.origin);
		if(dist_sq < 22500)
		{
			var_5321b51d = (RandomFloatRange(-1000, 1000), RandomFloatRange(-1000, 1000), 0);
			v_source = var_bf0620ca + var_5321b51d;
		}
	}
	dir = self.origin - v_source;
	dir = VectorNormalize(dir);
	v_force = length(dir) * 300;
	launch = (dir[0], dir[1], var_8178243a);
	launch = VectorScale(launch, v_force);
	self LaunchRagdoll(launch);
	self thread ragdoll_impact_watch(localClientNum);
}

/*
	Name: function_c6b66912
	Namespace: namespace_589e3c80
	Checksum: 0xC2DE390E
	Offset: 0x830
	Size: 0x1ED
	Parameters: 7
	Flags: None
*/
function function_c6b66912(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self endon("entityshutdown");
	if(newVal)
	{
		self.is_active = 1;
		original_pos = self.origin;
		level.var_654c7116[localClientNum] = self.origin;
		level.var_c6b66912 = PlayFXOnTag(localClientNum, level._effect["whirlwind"], self, "tag_origin");
		if(!isdefined(self.sndent))
		{
			self.sndent = spawn(0, self.origin, "script_origin");
			self.sndent.n_id = self.sndent PlayLoopSound("wpn_airstaff_tornado", 1);
			self.sndent thread function_3a4d4e97();
		}
	}
	else if(isdefined(level.var_c6b66912))
	{
		self.is_active = 0;
		level.var_654c7116[localClientNum] = undefined;
		stopfx(localClientNum, level.var_c6b66912);
	}
	if(isdefined(self.sndent))
	{
		self.sndent StopLoopSound(self.sndent.n_id, 1.5);
		self.sndent delete();
		self.sndent = undefined;
	}
}

/*
	Name: function_3a4d4e97
	Namespace: namespace_589e3c80
	Checksum: 0x76CA7CFE
	Offset: 0xA28
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_3a4d4e97()
{
	self endon("entityshutdown");
	level waittill("demo_jump");
	self delete();
}

