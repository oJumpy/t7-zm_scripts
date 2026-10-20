#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_dogs;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_random;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_widows_wine;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_trap_electric;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_tesla;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_sumpf_amb;
#using scripts\zm\zm_sumpf_ffotd;
#using scripts\zm\zm_sumpf_fx;

#namespace namespace_e722cafc;

/*
	Name: level_overrides
	Namespace: namespace_e722cafc
	Checksum: 0xF5C67DE7
	Offset: 0x628
	Size: 0x1B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec level_overrides()
{
	level.bgb_in_use = 1;
	level.aat_in_use = 1;
}

/*
	Name: main
	Namespace: namespace_e722cafc
	Checksum: 0xBBFEBB54
	Offset: 0x650
	Size: 0x243
	Parameters: 0
	Flags: None
*/
function main()
{
	level thread zm_sumpf_ffotd::main_start();
	level.default_game_mode = "zclassic";
	level.default_start_location = "default";
	level.use_water_risers = 1;
	zm_sumpf_fx::main();
	start_zombie_stuff();
	level thread zm_sumpf_amb::main();
	clientfield::register("world", "SUMPF_VISIONSET_DOGS", 21000, 1, "int", &function_166277c8, 0, 0);
	clientfield::register("actor", "zombie_flogger_trap", 21000, 1, "int", &function_f79e9b4f, 0, 0);
	clientfield::register("allplayers", "player_legs_hide", 21000, 1, "int", &player_legs_hide, 0, 0);
	load::main();
	util::waitforclient(0);
	_zm_weap_tesla::init();
	callback::on_localclient_connect(&function_794950d2);
	SetDvar("player_shallowWaterWadeScale", 0.5);
	SetDvar("player_waistWaterWadeScale", 0.5);
	level thread function_4e327cec();
	/#
		println("Dev Block strings are not supported");
	#/
	level thread zm_sumpf_ffotd::main_end();
}

/*
	Name: function_794950d2
	Namespace: namespace_e722cafc
	Checksum: 0xD8779FFE
	Offset: 0x8A0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_794950d2(localClientNum)
{
	SetSavedDvar("phys_buoyancy", 1);
}

/*
	Name: player_legs_hide
	Namespace: namespace_e722cafc
	Checksum: 0x37CE1928
	Offset: 0x8D8
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function player_legs_hide(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		self hideviewlegs();
	}
	else
	{
		self showviewlegs();
	}
}

/*
	Name: function_166277c8
	Namespace: namespace_e722cafc
	Checksum: 0x8F01FC6B
	Offset: 0x958
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_166277c8(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		SetWorldFogActiveBank(localClientNum, 2);
	}
	else
	{
		SetWorldFogActiveBank(localClientNum, 1);
	}
}

/*
	Name: function_f79e9b4f
	Namespace: namespace_e722cafc
	Checksum: 0x670A1BEF
	Offset: 0x9E0
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function function_f79e9b4f(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		PlayFXOnTag(localClientNum, level._effect["trap_log"], self, "tag_origin");
	}
}

/*
	Name: start_zombie_stuff
	Namespace: namespace_e722cafc
	Checksum: 0x1E44EDF2
	Offset: 0xA60
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function start_zombie_stuff()
{
	include_weapons();
	_zm_weap_cymbal_monkey::init();
}

/*
	Name: include_weapons
	Namespace: namespace_e722cafc
	Checksum: 0xE985534
	Offset: 0xA90
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function include_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_sumpf_weapons.csv", 1);
}

/*
	Name: function_4e327cec
	Namespace: namespace_e722cafc
	Checksum: 0x423429E1
	Offset: 0xAC0
	Size: 0xE9
	Parameters: 0
	Flags: None
*/
function function_4e327cec()
{
	stepTrigs = GetEntArray(0, "audio_step_trigger", "targetname");
	foreach(trig in stepTrigs)
	{
		if(isdefined(trig.script_label) && trig.script_label == "fly_water_wade")
		{
			trig thread function_938d448f();
		}
	}
}

/*
	Name: function_938d448f
	Namespace: namespace_e722cafc
	Checksum: 0xDB50EE1B
	Offset: 0xBB8
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function function_938d448f()
{
	while(1)
	{
		self waittill("trigger", who);
		if(who isPlayer())
		{
			if(!(isdefined(who.sndwading) && who.sndwading))
			{
				who.sndwading = 1;
				who thread function_387efde5(self);
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_387efde5
	Namespace: namespace_e722cafc
	Checksum: 0xC3E91A56
	Offset: 0xC58
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function function_387efde5(trigger)
{
	self endon("death");
	self endon("disconnect");
	while(self istouching(trigger))
	{
		if(self getspeed() > 5)
		{
			playsound(0, "fly_water_wade_plr", (0, 0, 0));
		}
		wait(RandomFloatRange(0.5, 1));
	}
	self.sndwading = 0;
}

