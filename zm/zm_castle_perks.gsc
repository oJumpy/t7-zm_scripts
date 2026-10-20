#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace namespace_912a86f7;

/*
	Name: init
	Namespace: namespace_912a86f7
	Checksum: 0xC2BE8130
	Offset: 0x450
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("world", "perk_light_doubletap", 5000, 1, "int");
	clientfield::register("world", "perk_light_juggernaut", 5000, 1, "int");
	clientfield::register("world", "perk_light_mule_kick", 5000, 1, "int");
	clientfield::register("world", "perk_light_quick_revive", 5000, 1, "int");
	clientfield::register("world", "perk_light_speed_cola", 5000, 1, "int");
	clientfield::register("world", "perk_light_staminup", 5000, 1, "int");
	clientfield::register("world", "perk_light_widows_wine", 5000, 1, "int");
	thread function_9a03e439();
	thread function_b5c4c30e();
}

/*
	Name: function_9a03e439
	Namespace: namespace_912a86f7
	Checksum: 0x2898FD17
	Offset: 0x5D0
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function function_9a03e439()
{
	level.initial_quick_revive_power_off = 1;
	level flag::wait_till("all_players_spawned");
	level flag::wait_till("zones_initialized");
	thread perk_light_quick_revive_on();
	thread perk_light_widows_wine_on();
	thread perk_light_mule_kick_on();
	thread perk_light_staminup_on();
	thread perk_light_speed_cola_on();
	thread perk_light_juggernaut_on();
	thread perk_light_doubletap_on();
}

/*
	Name: function_b5c4c30e
	Namespace: namespace_912a86f7
	Checksum: 0x380EE4DA
	Offset: 0x698
	Size: 0x71
	Parameters: 0
	Flags: None
*/
function function_b5c4c30e()
{
	wait(1);
	level flag::wait_till("start_zombie_round_logic");
	wait(1);
	if(!level flag::get("solo_game"))
	{
		level flag::wait_till("power_on");
	}
	level notify("revive_on");
}

/*
	Name: perk_light_quick_revive_on
	Namespace: namespace_912a86f7
	Checksum: 0x83A9FDD1
	Offset: 0x718
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function perk_light_quick_revive_on()
{
	level waittill("revive_on");
	exploder::exploder("lgt_vending_quick_revive_castle");
	clientfield::set("perk_light_quick_revive", 1);
	level flag::wait_till("solo_revive");
	exploder::exploder_stop("lgt_vending_quick_revive_castle");
	clientfield::set("perk_light_quick_revive", 0);
}

/*
	Name: perk_light_widows_wine_on
	Namespace: namespace_912a86f7
	Checksum: 0x788F0AE5
	Offset: 0x7C0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function perk_light_widows_wine_on()
{
	level waittill("widows_wine_on");
	clientfield::set("perk_light_widows_wine", 1);
}

/*
	Name: perk_light_mule_kick_on
	Namespace: namespace_912a86f7
	Checksum: 0x80708ECB
	Offset: 0x7F8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function perk_light_mule_kick_on()
{
	level waittill("additionalprimaryweapon_on");
	clientfield::set("perk_light_mule_kick", 1);
}

/*
	Name: perk_light_staminup_on
	Namespace: namespace_912a86f7
	Checksum: 0x1847F248
	Offset: 0x830
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function perk_light_staminup_on()
{
	level waittill("marathon_on");
	level clientfield::set("perk_light_staminup", 1);
}

/*
	Name: perk_light_speed_cola_on
	Namespace: namespace_912a86f7
	Checksum: 0x51E79376
	Offset: 0x870
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function perk_light_speed_cola_on()
{
	level waittill("sleight_on");
	level clientfield::set("perk_light_speed_cola", 1);
}

/*
	Name: perk_light_juggernaut_on
	Namespace: namespace_912a86f7
	Checksum: 0x5510F6A1
	Offset: 0x8B0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function perk_light_juggernaut_on()
{
	level waittill("juggernog_on");
	level clientfield::set("perk_light_juggernaut", 1);
}

/*
	Name: perk_light_doubletap_on
	Namespace: namespace_912a86f7
	Checksum: 0x789FC7FB
	Offset: 0x8F0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function perk_light_doubletap_on()
{
	level waittill("doubletap_on");
	level clientfield::set("perk_light_doubletap", 1);
}

