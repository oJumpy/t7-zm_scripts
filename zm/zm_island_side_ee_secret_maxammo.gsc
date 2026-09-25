#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_island_util;

#namespace namespace_5a453011;

/*
	Name: __init__sytem__
	Namespace: namespace_5a453011
	Checksum: 0x8EC3DDD7
	Offset: 0x430
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_side_ee_secret_maxammo", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_5a453011
	Checksum: 0x763F90C3
	Offset: 0x470
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.var_e9cb2217 = spawnstruct();
	level.var_e9cb2217.var_e8009655 = GetEnt("side_ee_secret_maxammo_wall", "targetname");
	level.var_e9cb2217.var_66253114 = GetEnt("side_ee_secret_maxammo_decal", "targetname");
	level.var_e9cb2217.var_935a64f = GetEnt("side_ee_secret_maxammo_clip", "targetname");
	level.var_e9cb2217.var_fc7e1b7a = struct::get("s_secret_ammo_pos", "targetname");
	level.var_e9cb2217.var_2559c370 = GetEnt("easter_egg_hidden_max_ammo_appear", "targetname");
	level.var_e9cb2217.var_2559c370 Hide();
	callback::on_spawned(&on_player_spawned);
	callback::on_connect(&function_8feafce2);
}

/*
	Name: main
	Namespace: namespace_5a453011
	Checksum: 0xBE1D8FA5
	Offset: 0x5E8
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function main()
{
	level.var_e9cb2217.var_e8009655 clientfield::set("do_fade_material", 1);
	level.var_e9cb2217.var_66253114 clientfield::set("do_fade_material", 0.5);
	/#
		level thread function_35b46d1a();
	#/
}

/*
	Name: on_player_spawned
	Namespace: namespace_5a453011
	Checksum: 0x12185FEE
	Offset: 0x670
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self thread function_1c4fc4a7(level.var_e9cb2217.var_e8009655);
}

/*
	Name: function_8feafce2
	Namespace: namespace_5a453011
	Checksum: 0x99EC1590
	Offset: 0x6A8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_8feafce2()
{
}

/*
	Name: function_1c4fc4a7
	Namespace: namespace_5a453011
	Checksum: 0xC03C180A
	Offset: 0x6B8
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function function_1c4fc4a7(var_3929e8a2)
{
	self endon("disconnect");
	self endon("death");
	self endon("hash_49419595");
	if(isdefined(var_3929e8a2))
	{
		self namespace_8aed53c9::function_7448e472(var_3929e8a2);
		if(!isdefined(var_3929e8a2) || var_3929e8a2.var_f0b65c0a !== self)
		{
			self notify("hash_49419595");
		}
		else
		{
			function_8ae0d6df();
			callback::remove_on_spawned(&on_player_spawned);
		}
	}
}

/*
	Name: function_8ae0d6df
	Namespace: namespace_5a453011
	Checksum: 0xEA5BA053
	Offset: 0x780
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function function_8ae0d6df()
{
	exploder::exploder("fxexp_507");
	var_7ddcf23 = level.var_e9cb2217.var_fc7e1b7a;
	var_b1f3f7cd = var_7ddcf23.origin;
	zm_powerups::specific_powerup_drop("full_ammo", var_b1f3f7cd);
	level.var_e9cb2217.var_2559c370 show();
	level.var_e9cb2217.var_66253114 clientfield::set("do_fade_material", 0);
	wait(0.25);
	level.var_e9cb2217.var_e8009655 clientfield::set("do_fade_material", 0);
	wait(0.25);
	level.var_e9cb2217.var_66253114 delete();
	level.var_e9cb2217.var_e8009655 delete();
	if(isdefined(level.var_e9cb2217.var_935a64f))
	{
		level.var_e9cb2217.var_935a64f delete();
	}
}

/*
	Name: function_35b46d1a
	Namespace: namespace_5a453011
	Checksum: 0x89AC6280
	Offset: 0x8F8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_35b46d1a()
{
	/#
		zm_devgui::function_4acecab5(&function_41601624);
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_41601624
	Namespace: namespace_5a453011
	Checksum: 0xE807F219
	Offset: 0x948
	Size: 0x45
	Parameters: 1
	Flags: None
*/
function function_41601624(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				function_8ae0d6df();
				return 1;
			}
		}
		return 0;
	#/
}

