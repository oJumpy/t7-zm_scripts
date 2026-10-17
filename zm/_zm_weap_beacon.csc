#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace _zm_weap_beacon;

/*
	Name: init
	Namespace: _zm_weap_beacon
	Checksum: 0x6FCD52F9
	Offset: 0x358
	Size: 0x203
	Parameters: 0
	Flags: None
*/
function init()
{
	level.w_beacon = GetWeapon("beacon");
	level.beacon_model = "wpn_t7_zmb_hd_g_strike_world";
	level._effect["beacon_glow"] = "dlc5/tomb/fx_tomb_beacon_glow";
	level._effect["beacon_launch_fx"] = "dlc5/tomb/fx_tomb_beacon_launch";
	level._effect["beacon_shell_explosion"] = "dlc5/tomb/fx_tomb_beacon_exp";
	level._effect["beacon_shell_trail"] = "dlc5/tomb/fx_tomb_beacon_trail";
	clientfield::register("world", "play_launch_artillery_fx_robot_0", 21000, 1, "int", &play_artillery_fx, 0, 0);
	clientfield::register("world", "play_launch_artillery_fx_robot_1", 21000, 1, "int", &play_artillery_fx, 0, 0);
	clientfield::register("world", "play_launch_artillery_fx_robot_2", 21000, 1, "int", &play_artillery_fx, 0, 0);
	clientfield::register("scriptmover", "play_beacon_fx", 21000, 1, "int", &play_beacon_glow, 0, 0);
	clientfield::register("scriptmover", "play_artillery_barrage", 21000, 2, "int", &function_1e3322d1, 0, 0);
}

/*
	Name: play_artillery_fx
	Namespace: _zm_weap_beacon
	Checksum: 0x2310849F
	Offset: 0x568
	Size: 0x153
	Parameters: 7
	Flags: None
*/
function play_artillery_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(IsSubStr(fieldName, 0))
	{
		ai_robot = level.a_giant_robots[localClientNum][0];
	}
	else if(IsSubStr(fieldName, 1))
	{
		ai_robot = level.a_giant_robots[localClientNum][1];
	}
	else
	{
		ai_robot = level.a_giant_robots[localClientNum][2];
	}
	if(newVal == 1)
	{
		playFX(localClientNum, level._effect["beacon_launch_fx"], ai_robot GetTagOrigin("tag_rocketpod"));
		level thread sndfakelaunchaudio(ai_robot GetTagOrigin("tag_rocketpod"));
	}
}

/*
	Name: sndfakelaunchaudio
	Namespace: _zm_weap_beacon
	Checksum: 0xAC61E5EF
	Offset: 0x6C8
	Size: 0x7D
	Parameters: 1
	Flags: None
*/
function sndfakelaunchaudio(origin)
{
	playsound(0, "zmb_homingbeacon_missiile_alarm", origin);
	for(i = 0; i < 5; i++)
	{
		playsound(0, "zmb_homingbeacon_missile_fire", origin);
		wait(0.15);
	}
}

/*
	Name: play_beacon_glow
	Namespace: _zm_weap_beacon
	Checksum: 0x59668049
	Offset: 0x750
	Size: 0xAF
	Parameters: 7
	Flags: None
*/
function play_beacon_glow(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self endon("weapon_beacon_destroyed");
	while(isdefined(self))
	{
		playsound(0, "evt_beacon_beep", self.origin);
		PlayFXOnTag(localClientNum, level._effect["beacon_glow"], self, "origin_animate_jnt");
		wait(1.5);
	}
}

/*
	Name: function_1e3322d1
	Namespace: _zm_weap_beacon
	Checksum: 0x58BCE7C3
	Offset: 0x808
	Size: 0x2B9
	Parameters: 7
	Flags: None
*/
function function_1e3322d1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 0)
	{
		return;
	}
	if(newVal == 1)
	{
		if(!isdefined(self.a_v_land_offsets))
		{
			self.a_v_land_offsets = [];
		}
		if(!isdefined(self.a_v_land_offsets[localClientNum]))
		{
			self.a_v_land_offsets[localClientNum] = self build_weap_beacon_landing_offsets();
		}
		if(!isdefined(self.a_v_start_offsets))
		{
			self.a_v_start_offsets = [];
		}
		if(!isdefined(self.a_v_start_offsets[localClientNum]))
		{
			self.a_v_start_offsets[localClientNum] = self build_weap_beacon_start_offsets();
		}
	}
	if(newVal == 2)
	{
		if(!isdefined(self.a_v_land_offsets))
		{
			self.a_v_land_offsets = [];
		}
		if(!isdefined(self.a_v_land_offsets[localClientNum]))
		{
			self.a_v_land_offsets[localClientNum] = self build_weap_beacon_landing_offsets_ee();
		}
		if(!isdefined(self.a_v_start_offsets))
		{
			self.a_v_start_offsets = [];
		}
		if(!isdefined(self.a_v_start_offsets[localClientNum]))
		{
			self.a_v_start_offsets[localClientNum] = self build_weap_beacon_start_offsets_ee();
		}
	}
	if(!isdefined(self.num_rockets_fired))
	{
		self.num_rockets_fired = [];
	}
	if(!isdefined(self.num_rockets_fired[localClientNum]))
	{
		self.num_rockets_fired[localClientNum] = 0;
	}
	n_index = self.num_rockets_fired[localClientNum];
	v_start = self.origin + self.a_v_start_offsets[localClientNum][n_index];
	shell = spawn(localClientNum, v_start, "script_model");
	shell.angles = VectorScale((-1, 0, 0), 90);
	shell SetModel("tag_origin");
	shell thread shell_logic(self, n_index, v_start, localClientNum);
	self.num_rockets_fired[localClientNum]++;
}

/*
	Name: build_weap_beacon_landing_offsets
	Namespace: _zm_weap_beacon
	Checksum: 0x6319AC46
	Offset: 0xAD0
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function build_weap_beacon_landing_offsets()
{
	a_offsets = [];
	a_offsets[0] = (0, 0, 0);
	a_offsets[1] = VectorScale((-1, 1, 0), 72);
	a_offsets[2] = VectorScale((1, 1, 0), 72);
	a_offsets[3] = VectorScale((1, -1, 0), 72);
	a_offsets[4] = VectorScale((-1, -1, 0), 72);
	return a_offsets;
}

/*
	Name: build_weap_beacon_start_offsets
	Namespace: _zm_weap_beacon
	Checksum: 0x2D221072
	Offset: 0xB60
	Size: 0x95
	Parameters: 0
	Flags: None
*/
function build_weap_beacon_start_offsets()
{
	a_offsets = [];
	a_offsets[0] = VectorScale((0, 0, 1), 8500);
	a_offsets[1] = (-6500, 6500, 8500);
	a_offsets[2] = (6500, 6500, 8500);
	a_offsets[3] = (6500, -6500, 8500);
	a_offsets[4] = (-6500, -6500, 8500);
	return a_offsets;
}

/*
	Name: build_weap_beacon_landing_offsets_ee
	Namespace: _zm_weap_beacon
	Checksum: 0x9C82ACC5
	Offset: 0xC00
	Size: 0x177
	Parameters: 0
	Flags: None
*/
function build_weap_beacon_landing_offsets_ee()
{
	a_offsets = [];
	a_offsets[0] = (0, 0, 0);
	a_offsets[1] = VectorScale((-1, 1, 0), 72);
	a_offsets[2] = VectorScale((1, 1, 0), 72);
	a_offsets[3] = VectorScale((1, -1, 0), 72);
	a_offsets[4] = VectorScale((-1, -1, 0), 72);
	a_offsets[5] = VectorScale((-1, 1, 0), 72);
	a_offsets[6] = VectorScale((1, 1, 0), 72);
	a_offsets[7] = VectorScale((1, -1, 0), 72);
	a_offsets[8] = VectorScale((-1, -1, 0), 72);
	a_offsets[9] = VectorScale((-1, 1, 0), 72);
	a_offsets[10] = VectorScale((1, 1, 0), 72);
	a_offsets[11] = VectorScale((1, -1, 0), 72);
	a_offsets[12] = VectorScale((-1, -1, 0), 72);
	a_offsets[13] = VectorScale((-1, 1, 0), 72);
	a_offsets[14] = VectorScale((1, 1, 0), 72);
	return a_offsets;
}

/*
	Name: build_weap_beacon_start_offsets_ee
	Namespace: _zm_weap_beacon
	Checksum: 0xF9455FBB
	Offset: 0xD80
	Size: 0x199
	Parameters: 0
	Flags: None
*/
function build_weap_beacon_start_offsets_ee()
{
	a_offsets = [];
	a_offsets[0] = VectorScale((0, 0, 1), 8500);
	a_offsets[1] = (-6500, 6500, 8500);
	a_offsets[2] = (6500, 6500, 8500);
	a_offsets[3] = (6500, -6500, 8500);
	a_offsets[4] = (-6500, -6500, 8500);
	a_offsets[5] = (-6500, 6500, 8500);
	a_offsets[6] = (6500, 6500, 8500);
	a_offsets[7] = (6500, -6500, 8500);
	a_offsets[8] = (-6500, -6500, 8500);
	a_offsets[9] = (-6500, 6500, 8500);
	a_offsets[10] = (6500, 6500, 8500);
	a_offsets[11] = (6500, -6500, 8500);
	a_offsets[12] = (-6500, -6500, 8500);
	a_offsets[13] = (-6500, 6500, 8500);
	a_offsets[14] = (6500, 6500, 8500);
	return a_offsets;
}

/*
	Name: shell_logic
	Namespace: _zm_weap_beacon
	Checksum: 0xA062F7EA
	Offset: 0xF28
	Size: 0x1D3
	Parameters: 4
	Flags: None
*/
function shell_logic(model, index, v_start, localClientNum)
{
	v_land = model.origin + model.a_v_land_offsets[localClientNum][index];
	v_start_trace = v_start - VectorScale((0, 0, 1), 5000);
	trace = bullettrace(v_start_trace, v_land, 0, undefined);
	v_land = trace["position"];
	self moveto(v_land, 3);
	PlayFXOnTag(localClientNum, level._effect["beacon_shell_trail"], self, "tag_origin");
	self playsound(0, "zmb_homingbeacon_missile_boom");
	self thread sndplayincoming(v_land);
	self waittill("movedone");
	if(index == 1)
	{
		model notify("weapon_beacon_destroyed");
	}
	playFX(localClientNum, level._effect["beacon_shell_explosion"], self.origin);
	playsound(0, "wpn_rocket_explode", self.origin);
	self delete();
}

/*
	Name: sndplayincoming
	Namespace: _zm_weap_beacon
	Checksum: 0xC674DA7
	Offset: 0x1108
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function sndplayincoming(origin)
{
	wait(2);
	playsound(0, "zmb_homingbeacon_missile_incoming", origin);
}

