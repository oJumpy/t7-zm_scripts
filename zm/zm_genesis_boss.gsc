#using scripts\codescripts\struct;
#using scripts\shared\ai\margwa;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicles\_parasite;
#using scripts\zm\_zm_ai_margwa_no_idgun;
#using scripts\zm\_zm_ai_mechz;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_elemental_zombies;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_genesis_spiders;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_light_zombie;
#using scripts\zm\_zm_powerup_genesis_random_weapon;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_shadow_zombie;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_traps;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_gravityspikes;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_genesis_arena;
#using scripts\zm\zm_genesis_shadowman;
#using scripts\zm\zm_genesis_spiders;
#using scripts\zm\zm_genesis_util;
#using scripts\zm\zm_genesis_wasp;

#namespace zm_genesis_boss;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_boss
	Checksum: 0x292CB0DB
	Offset: 0x5D8
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_boss", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_boss
	Checksum: 0xAC8F5A80
	Offset: 0x620
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "boss_clone_fx", 15000, GetMinBitCountForNum(3), "int");
	clientfield::register("world", "sophia_state", 15000, GetMinBitCountForNum(4), "int");
	clientfield::register("world", "boss_beam_state", 15000, 1, "int");
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			level thread devgui_boss();
		}
	#/
}

/*
	Name: __main__
	Namespace: zm_genesis_boss
	Checksum: 0x79BF1C3F
	Offset: 0x718
	Size: 0xB
	Parameters: 0
	Flags: None
*/
function __main__()
{
	wait(0.1);
}

/*
	Name: devgui_boss
	Namespace: zm_genesis_boss
	Checksum: 0x80E6D00F
	Offset: 0x730
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function devgui_boss()
{
	/#
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 0, &function_92d90d50);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 2, &function_92d90d50);
	#/
}

/*
	Name: function_92d90d50
	Namespace: zm_genesis_boss
	Checksum: 0x68A5BA7
	Offset: 0x7B0
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function function_92d90d50(n_val)
{
	/#
		level thread clientfield::set("Dev Block strings are not supported", n_val);
	#/
}

