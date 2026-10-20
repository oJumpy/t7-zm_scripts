#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
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
#using scripts\zm\_zm_zonemgr;

#namespace namespace_bb738c6;

/*
	Name: init
	Namespace: namespace_bb738c6
	Checksum: 0xD342191D
	Offset: 0x4F0
	Size: 0x1F3
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("world", "perk_light_speed_cola", 1, 2, "int");
	clientfield::register("world", "perk_light_juggernog", 1, 2, "int");
	clientfield::register("world", "perk_light_doubletap", 1, 2, "int");
	clientfield::register("world", "perk_light_quick_revive", 1, 1, "int");
	clientfield::register("world", "perk_light_widows_wine", 1, 1, "int");
	clientfield::register("world", "perk_light_mule_kick", 1, 1, "int");
	clientfield::register("world", "perk_light_staminup", 1, 1, "int");
	clientfield::register("scriptmover", "perk_bottle_speed_cola_fx", 1, 1, "int");
	clientfield::register("scriptmover", "perk_bottle_juggernog_fx", 1, 1, "int");
	clientfield::register("scriptmover", "perk_bottle_doubletap_fx", 1, 1, "int");
	thread function_9a03e439();
}

/*
	Name: function_9a03e439
	Namespace: namespace_bb738c6
	Checksum: 0xFAC6088E
	Offset: 0x6F0
	Size: 0x3F3
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
	var_58b16a23 = GetEntArray("random_perk_machine", "script_notify");
	a_s_random_perk_locs = struct::get_array("perk_random_machine_location", "targetname");
	foreach(var_5bca5a82 in var_58b16a23)
	{
		str_zone = zm_zonemgr::get_zone_from_position(var_5bca5a82.origin, 1);
		switch(str_zone)
		{
			case "zone_slums_high_B":
			{
				n_loc = 1;
				break;
			}
			case "zone_canal_high_B":
			{
				n_loc = 2;
				break;
			}
			case "zone_theater_high_A":
			{
				n_loc = 3;
				break;
			}
		}
		foreach(s_random_perk_loc in a_s_random_perk_locs)
		{
			if(zm_zonemgr::get_zone_from_position(s_random_perk_loc.origin, 1) == str_zone)
			{
				var_8de7611a = s_random_perk_loc;
				break;
			}
		}
		ArrayRemoveValue(a_s_random_perk_locs, var_8de7611a);
		var_575e35b2 = struct::get(var_8de7611a.target, "targetname");
		e_bottle = util::spawn_model("tag_origin", var_575e35b2.origin, (0, 0, 0));
		switch(var_5bca5a82.script_string)
		{
			case "speedcola_perk":
			{
				thread perk_light_speed_cola_on(n_loc);
				e_bottle thread clientfield::set("perk_bottle_speed_cola_fx", 1);
				break;
			}
			case "jugg_perk":
			{
				thread perk_light_juggernog_on(n_loc);
				e_bottle thread clientfield::set("perk_bottle_juggernog_fx", 1);
				break;
			}
			case "tap_perk":
			{
				thread perk_light_doubletap_on(n_loc);
				e_bottle thread clientfield::set("perk_bottle_doubletap_fx", 1);
				break;
			}
		}
	}
}

/*
	Name: perk_light_quick_revive_on
	Namespace: namespace_bb738c6
	Checksum: 0xE0FD8DCA
	Offset: 0xAF0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function perk_light_quick_revive_on()
{
	level waittill("revive_on");
	clientfield::set("perk_light_quick_revive", 1);
}

/*
	Name: perk_light_widows_wine_on
	Namespace: namespace_bb738c6
	Checksum: 0xB3FB7D4C
	Offset: 0xB28
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
	Namespace: namespace_bb738c6
	Checksum: 0xC7000354
	Offset: 0xB60
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
	Namespace: namespace_bb738c6
	Checksum: 0xBF64466
	Offset: 0xB98
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
	Namespace: namespace_bb738c6
	Checksum: 0x7B9B9062
	Offset: 0xBD8
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function perk_light_speed_cola_on(n_district)
{
	level waittill("sleight_on");
	level clientfield::set("perk_light_speed_cola", n_district);
}

/*
	Name: perk_light_juggernog_on
	Namespace: namespace_bb738c6
	Checksum: 0x75B15369
	Offset: 0xC20
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function perk_light_juggernog_on(n_district)
{
	level waittill("juggernog_on");
	level clientfield::set("perk_light_juggernog", n_district);
}

/*
	Name: perk_light_doubletap_on
	Namespace: namespace_bb738c6
	Checksum: 0xD8053F79
	Offset: 0xC68
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function perk_light_doubletap_on(n_district)
{
	level waittill("doubletap_on");
	level clientfield::set("perk_light_doubletap", n_district);
}

