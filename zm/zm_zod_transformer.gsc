#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_altbody_beast;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace namespace_ded850b0;

/*
	Name: __init__sytem__
	Namespace: namespace_ded850b0
	Checksum: 0xCFE6EE67
	Offset: 0x318
	Size: 0x2B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_transformer", undefined, &__main__, undefined);
}

/*
	Name: __main__
	Namespace: namespace_ded850b0
	Checksum: 0x896F7415
	Offset: 0x350
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function __main__()
{
	n_bits = GetMinBitCountForNum(16);
	clientfield::register("scriptmover", "transformer_light_switch", 1, n_bits, "int");
	level thread function_eec8fd1e();
}

/*
	Name: function_eec8fd1e
	Namespace: namespace_ded850b0
	Checksum: 0xB15D153A
	Offset: 0x3D0
	Size: 0x131
	Parameters: 0
	Flags: None
*/
function function_eec8fd1e()
{
	level flag::wait_till("all_players_spawned");
	level flag::wait_till("zones_initialized");
	var_38d937f = GetEntArray("use_elec_switch", "targetname");
	foreach(var_b46b59df in var_38d937f)
	{
		var_677edb82 = GetEnt(var_b46b59df.target, "targetname");
		var_677edb82 thread function_7734548b(var_b46b59df);
		wait(0.05);
	}
}

/*
	Name: function_7734548b
	Namespace: namespace_ded850b0
	Checksum: 0xD720BC3B
	Offset: 0x510
	Size: 0x14B
	Parameters: 1
	Flags: None
*/
function function_7734548b(var_b46b59df)
{
	/#
		Assert(isdefined(self.script_int), "Dev Block strings are not supported" + self.origin);
	#/
	n_power_index = self.script_int;
	self thread namespace_215602b6::function_c5c7aef3(var_b46b59df);
	self clientfield::set("bminteract", 2);
	level flag::wait_till("power_on" + n_power_index);
	self thread scene::Play("p7_fxanim_zm_zod_power_box_bundle", self);
	self clientfield::set("transformer_light_switch", n_power_index);
	self playsound("zmb_bm_interaction_machine_start");
	self PlayLoopSound("zmb_bm_interaction_machine_loop", 2);
	self clientfield::set("bminteract", 0);
}

