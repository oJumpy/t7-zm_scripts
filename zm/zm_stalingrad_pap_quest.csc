#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\beam_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;

#namespace namespace_b57650e4;

/*
	Name: __init__sytem__
	Namespace: namespace_b57650e4
	Checksum: 0x3B47F26A
	Offset: 0x3B0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_pap", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_b57650e4
	Checksum: 0x2654E314
	Offset: 0x3F0
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("world", "lockdown_lights_west", 12000, 1, "int", &function_a7cac48a, 0, 0);
	clientfield::register("world", "lockdown_lights_north", 12000, 1, "int", &function_2a0966c, 0, 0);
	clientfield::register("world", "lockdown_lights_east", 12000, 1, "int", &function_5355114, 0, 0);
}

/*
	Name: function_a7cac48a
	Namespace: namespace_b57650e4
	Checksum: 0xFAE82931
	Offset: 0x4D8
	Size: 0x93
	Parameters: 7
	Flags: None
*/
function function_a7cac48a(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(level.var_ff3f0000))
	{
		level.var_ff3f0000 = struct::get_array("lockdown_lights_west");
	}
	level thread function_4ec66a83(localClientNum, newVal, level.var_ff3f0000);
}

/*
	Name: function_2a0966c
	Namespace: namespace_b57650e4
	Checksum: 0x1E28A8F4
	Offset: 0x578
	Size: 0x93
	Parameters: 7
	Flags: None
*/
function function_2a0966c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(level.var_80d95152))
	{
		level.var_80d95152 = struct::get_array("lockdown_lights_north");
	}
	level thread function_4ec66a83(localClientNum, newVal, level.var_80d95152);
}

/*
	Name: function_5355114
	Namespace: namespace_b57650e4
	Checksum: 0x6FE00291
	Offset: 0x618
	Size: 0x93
	Parameters: 7
	Flags: None
*/
function function_5355114(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(level.var_4f41d366))
	{
		level.var_4f41d366 = struct::get_array("lockdown_lights_east");
	}
	level thread function_4ec66a83(localClientNum, newVal, level.var_4f41d366);
}

/*
	Name: function_4ec66a83
	Namespace: namespace_b57650e4
	Checksum: 0x91A87783
	Offset: 0x6B8
	Size: 0x17F
	Parameters: 3
	Flags: None
*/
function function_4ec66a83(localClientNum, newVal, a_s_lights)
{
	if(newVal)
	{
		foreach(var_6bc801a1 in a_s_lights)
		{
			var_6bc801a1.fx_light = playFX(localClientNum, level._effect["pavlov_lockdown_light"], var_6bc801a1.origin);
		}
		break;
	}
	foreach(var_6bc801a1 in a_s_lights)
	{
		if(isdefined(var_6bc801a1.fx_light))
		{
			stopfx(localClientNum, var_6bc801a1.fx_light);
			var_6bc801a1.fx_light = undefined;
		}
	}
}

/*
	Name: function_7a72544b
	Namespace: namespace_b57650e4
	Checksum: 0x55E864DE
	Offset: 0x840
	Size: 0xDB
	Parameters: 7
	Flags: None
*/
function function_7a72544b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		ForceStreamXModel("p7_fxanim_zm_stal_pack_a_punch_base_mod");
		ForceStreamXModel("p7_fxanim_zm_stal_pack_a_punch_pod_mod");
		ForceStreamXModel("p7_fxanim_zm_stal_pack_a_punch_umbrella_mod");
	}
	else
	{
		StopForceStreamingXModel("p7_fxanim_zm_stal_pack_a_punch_base_mod");
		StopForceStreamingXModel("p7_fxanim_zm_stal_pack_a_punch_pod_mod");
		StopForceStreamingXModel("p7_fxanim_zm_stal_pack_a_punch_umbrella_mod");
	}
}

/*
	Name: function_5858bdaf
	Namespace: namespace_b57650e4
	Checksum: 0x84A61CCF
	Offset: 0x928
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function function_5858bdaf(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level.var_f6abb894[localClientNum] = self;
	self thread function_ca87037d(localClientNum);
}

/*
	Name: function_ca87037d
	Namespace: namespace_b57650e4
	Checksum: 0xB45E610F
	Offset: 0x998
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function function_ca87037d(localClientNum)
{
	self endon("entity_shutdown");
	while(isdefined(self))
	{
		self PlayRumbleOnEntity(localClientNum, "zm_stalingrad_drop_pod_ambient");
		wait(1.1);
	}
}

/*
	Name: function_c86c0cdd
	Namespace: namespace_b57650e4
	Checksum: 0x7F702726
	Offset: 0x9E8
	Size: 0x10B
	Parameters: 7
	Flags: None
*/
function function_c86c0cdd(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_f64bb476 = level.var_f6abb894[localClientNum];
	var_3929e8a2 = util::spawn_model(localClientNum, "tag_origin", var_f64bb476 GetTagOrigin("tag_fx"));
	var_e43465f2 = util::spawn_model(localClientNum, "tag_origin", self GetTagOrigin("j_spine4"), self GetTagAngles("j_spine4"));
	var_e43465f2 thread function_1d3ab9dd(var_3929e8a2);
}

/*
	Name: function_1d3ab9dd
	Namespace: namespace_b57650e4
	Checksum: 0x1469CCC5
	Offset: 0xB00
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function function_1d3ab9dd(var_3929e8a2)
{
	level beam::launch(self, "tag_origin", var_3929e8a2, "tag_origin", "electric_arc_zombie_to_drop_pod");
	var_3929e8a2 playsound(0, "zmb_pod_electrocute");
	wait(0.2);
	self playsound(0, "zmb_pod_electrocute_zmb");
	level beam::kill(self, "tag_origin", var_3929e8a2, "tag_origin", "electric_arc_zombie_to_drop_pod");
	var_3929e8a2 delete();
	self delete();
}

/*
	Name: function_5e369bd2
	Namespace: namespace_b57650e4
	Checksum: 0x2500BC66
	Offset: 0xBF0
	Size: 0x1CD
	Parameters: 7
	Flags: None
*/
function function_5e369bd2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_165d49f6 = level.var_f6abb894[localClientNum];
	switch(newVal)
	{
		case 1:
		{
			var_165d49f6.var_888bfca3 = PlayFXOnTag(localClientNum, level._effect["drop_pod_hp_light_green"], var_165d49f6, "tag_health_green");
			break;
		}
		case 2:
		{
			if(isdefined(var_165d49f6.var_888bfca3))
			{
				stopfx(localClientNum, var_165d49f6.var_888bfca3);
			}
			var_165d49f6.var_888bfca3 = PlayFXOnTag(localClientNum, level._effect["drop_pod_hp_light_yellow"], var_165d49f6, "tag_health_yellow");
			break;
		}
		case 3:
		{
			if(isdefined(var_165d49f6.var_888bfca3))
			{
				stopfx(localClientNum, var_165d49f6.var_888bfca3);
			}
			var_165d49f6.var_888bfca3 = PlayFXOnTag(localClientNum, level._effect["drop_pod_hp_light_red"], var_165d49f6, "tag_health_red");
			break;
		}
		case default:
		{
			break;
		}
	}
}

