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
	clientfield::register("scriptmover", "whirlwind_play_fx", 21000, 1, "int", &whirlwind_fx, 0, 0);
	clientfield::register("actor", "air_staff_launch", 21000, 1, "int", &function_5640a6aa, 0, 0);
	clientfield::register("allplayers", "air_staff_source", 21000, 1, "int", &set_air_staff_source, 0, 0);
	level.launch_source = (0, 0, 0);
	level.whirlwind_pos = [];
	namespace_c9806b9::function_4be5e665(GetWeapon("staff_air_upgraded"), "dlc5/zmb_weapon/fx_staff_charge_air_lv1");
}

/*
	Name: set_air_staff_source
	Namespace: namespace_589e3c80
	Checksum: 0x2A8C6E2E
	Offset: 0x3B0
	Size: 0x4B
	Parameters: 7
	Flags: None
*/
function set_air_staff_source(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level.launch_source = self.origin;
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
	v_source = level.launch_source;
	n_verticality = RandomFloatRange(0.05, 0.35);
	v_whirlwind = level.whirlwind_pos[localClientNum];
	if(isdefined(v_whirlwind))
	{
		dist_sq = DistanceSquared(v_whirlwind, self.origin);
		if(dist_sq < 22500)
		{
			v_random_offset = (RandomFloatRange(-1000, 1000), RandomFloatRange(-1000, 1000), 0);
			v_source = v_whirlwind + v_random_offset;
		}
	}
	dir = self.origin - v_source;
	dir = VectorNormalize(dir);
	v_force = length(dir) * 300;
	launch = (dir[0], dir[1], n_verticality);
	launch = VectorScale(launch, v_force);
	self LaunchRagdoll(launch);
	self thread ragdoll_impact_watch(localClientNum);
}

/*
	Name: whirlwind_fx
	Namespace: namespace_589e3c80
	Checksum: 0xC2DE390E
	Offset: 0x830
	Size: 0x1ED
	Parameters: 7
	Flags: None
*/
function whirlwind_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self endon("entityshutdown");
	if(newVal)
	{
		self.is_active = 1;
		original_pos = self.origin;
		level.whirlwind_pos[localClientNum] = self.origin;
		level.whirlwind_fx = PlayFXOnTag(localClientNum, level._effect["whirlwind"], self, "tag_origin");
		if(!isdefined(self.sndent))
		{
			self.sndent = spawn(0, self.origin, "script_origin");
			self.sndent.n_id = self.sndent PlayLoopSound("wpn_airstaff_tornado", 1);
			self.sndent thread snddemojumpmonitor();
		}
	}
	else if(isdefined(level.whirlwind_fx))
	{
		self.is_active = 0;
		level.whirlwind_pos[localClientNum] = undefined;
		stopfx(localClientNum, level.whirlwind_fx);
	}
	if(isdefined(self.sndent))
	{
		self.sndent StopLoopSound(self.sndent.n_id, 1.5);
		self.sndent delete();
		self.sndent = undefined;
	}
}

/*
	Name: snddemojumpmonitor
	Namespace: namespace_589e3c80
	Checksum: 0x76CA7CFE
	Offset: 0xA28
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function snddemojumpmonitor()
{
	self endon("entityshutdown");
	level waittill("demo_jump");
	self delete();
}

