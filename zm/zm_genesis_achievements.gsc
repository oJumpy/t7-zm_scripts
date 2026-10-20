#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace genesis_achievements;

/*
	Name: __init__sytem__
	Namespace: genesis_achievements
	Checksum: 0xCDC602C
	Offset: 0x408
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_achievements", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: genesis_achievements
	Checksum: 0x2B170A28
	Offset: 0x448
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level thread function_c190d113();
	level thread function_902aff55();
	callback::on_connect(&on_player_connect);
	zm_spawner::register_zombie_death_event_callback(&function_71e89ea4);
}

/*
	Name: on_player_connect
	Namespace: genesis_achievements
	Checksum: 0xAA3B6528
	Offset: 0x4C8
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self thread function_4d2d1f7a();
	self thread function_553e6274();
	self thread function_7d947aff();
	self thread achievement_wardrobe_change();
	self thread function_e3cc5d03();
	self thread function_c77b5630();
}

/*
	Name: function_c190d113
	Namespace: genesis_achievements
	Checksum: 0xE4C8D894
	Offset: 0x568
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_c190d113()
{
	level waittill("hash_91a3107");
	Array::run_all(level.players, &GiveAchievement, "ZM_GENESIS_EE");
}

/*
	Name: function_902aff55
	Namespace: genesis_achievements
	Checksum: 0xF5A7834A
	Offset: 0x5B8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_902aff55()
{
	level waittill("hash_154abf47");
	Array::run_all(level.players, &GiveAchievement, "ZM_GENESIS_SUPER_EE");
}

/*
	Name: function_4d2d1f7a
	Namespace: genesis_achievements
	Checksum: 0xE99642F0
	Offset: 0x608
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_4d2d1f7a()
{
	level waittill("apotho_pack_freed");
	self GiveAchievement("ZM_GENESIS_PACKECTOMY");
}

/*
	Name: function_553e6274
	Namespace: genesis_achievements
	Checksum: 0x24026630
	Offset: 0x640
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function function_553e6274()
{
	level endon("end_game");
	self endon("disconnect");
	self.var_71148446 = [];
	self.var_71148446[0] = "mechz";
	self.var_71148446[1] = "zombie";
	self.var_71148446[2] = "parasite";
	self.var_71148446[3] = "spider";
	self.var_71148446[4] = "margwa";
	self.var_71148446[5] = "keeper";
	self.var_71148446[6] = "apothicon_fury";
	self thread function_3c82f182();
}

/*
	Name: function_3c82f182
	Namespace: genesis_achievements
	Checksum: 0xE19CA272
	Offset: 0x728
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_3c82f182()
{
	while(self.var_71148446.size > 0)
	{
		self waittill("hash_af442f7c");
	}
	self GiveAchievement("ZM_GENESIS_KEEPER_ASSIST");
}

/*
	Name: function_817b1327
	Namespace: genesis_achievements
	Checksum: 0xAB1D6EE6
	Offset: 0x778
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function function_817b1327()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("hash_720f4d71");
	var_ef6b3d38 = 0;
	while(1)
	{
		level waittill("beam_killed_zombie", e_attacker);
		if(e_attacker === self)
		{
			var_ef6b3d38++;
		}
		if(var_ef6b3d38 >= 40)
		{
			self GiveAchievement("ZM_GENESIS_DEATH_RAY");
			return;
		}
	}
}

/*
	Name: function_7d947aff
	Namespace: genesis_achievements
	Checksum: 0x8BC85C99
	Offset: 0x820
	Size: 0x119
	Parameters: 0
	Flags: None
*/
function function_7d947aff()
{
	level endon("end_game");
	self endon("disconnect");
	self.a_e_islands = [];
	self.a_e_islands[self.a_e_islands.size] = "start_island";
	self.a_e_islands[self.a_e_islands.size] = "prison_island";
	self.a_e_islands[self.a_e_islands.size] = "asylum_island";
	self.a_e_islands[self.a_e_islands.size] = "temple_island";
	self.a_e_islands[self.a_e_islands.size] = "prototype_island";
	self thread function_935679b0();
	while(self.a_e_islands.size > 0)
	{
		self waittill("changed_island");
	}
	self GiveAchievement("ZM_GENESIS_GRAND_TOUR");
	self.a_e_islands = undefined;
	self notify("hash_2bec714");
}

/*
	Name: function_935679b0
	Namespace: genesis_achievements
	Checksum: 0x90A1A7DA
	Offset: 0x948
	Size: 0xE7
	Parameters: 0
	Flags: None
*/
function function_935679b0()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("hash_2bec714");
	while(!isdefined(self.island_name))
	{
		util::wait_network_frame();
	}
	var_e274e0c3 = self.island_name;
	self thread function_f17c9ba1();
	while(1)
	{
		if(isdefined(self.island_name) && var_e274e0c3 != self.island_name)
		{
			self thread function_f17c9ba1();
			var_e274e0c3 = self.island_name;
			self notify("changed_island");
		}
		wait(RandomFloatRange(0.5, 1));
	}
}

/*
	Name: function_f17c9ba1
	Namespace: genesis_achievements
	Checksum: 0xFA92A53B
	Offset: 0xA38
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function function_f17c9ba1()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("hash_2bec714");
	str_island_name = self.island_name;
	if(isdefined(str_island_name) && IsInArray(self.a_e_islands, str_island_name))
	{
		ArrayRemoveValue(self.a_e_islands, str_island_name);
	}
	else
	{
		return;
	}
	self waittill("changed_island");
	wait(120);
	if(isdefined(self.a_e_islands))
	{
		Array::add(self.a_e_islands, str_island_name, 0);
	}
}

/*
	Name: achievement_wardrobe_change
	Namespace: genesis_achievements
	Checksum: 0xD9D6A0D0
	Offset: 0xB10
	Size: 0xA1
	Parameters: 0
	Flags: None
*/
function achievement_wardrobe_change()
{
	level endon("end_game");
	self endon("disconnect");
	a_str_wearable = [];
	while(1)
	{
		self waittill("changed_wearable", var_475b0a4e);
		Array::add(a_str_wearable, var_475b0a4e, 0);
		if(a_str_wearable.size >= 3)
		{
			self GiveAchievement("ZM_GENESIS_WARDROBE_CHANGE");
			return;
		}
	}
}

/*
	Name: function_e3cc5d03
	Namespace: genesis_achievements
	Checksum: 0xFE340414
	Offset: 0xBC0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_e3cc5d03()
{
	self waittill("hash_86cee34e");
	self GiveAchievement("ZM_GENESIS_WONDERFUL");
}

/*
	Name: function_c77b5630
	Namespace: genesis_achievements
	Checksum: 0xAAB4016D
	Offset: 0xBF8
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function function_c77b5630()
{
	level flagsys::wait_till("start_zombie_round_logic");
	level flag::wait_till_all(Array("power_on1", "power_on2", "power_on3", "power_on4"));
	if(level.round_number <= 6)
	{
		self GiveAchievement("ZM_GENESIS_CONTROLLED_CHAOS");
	}
}

/*
	Name: function_71e89ea4
	Namespace: genesis_achievements
	Checksum: 0xA5F33961
	Offset: 0xCA0
	Size: 0x157
	Parameters: 1
	Flags: None
*/
function function_71e89ea4(e_attacker)
{
	if(isdefined(self.damageWeapon) && zm_weapons::is_wonder_weapon(self.damageWeapon))
	{
		if(IsSubStr(self.damageWeapon.name, "thundergun"))
		{
			if(!isdefined(e_attacker.var_2831078e))
			{
				e_attacker.var_2831078e = 0;
			}
			e_attacker.var_2831078e++;
		}
		else if(IsSubStr(self.damageWeapon.name, "idgun"))
		{
			if(!isdefined(e_attacker.var_29bc01fd))
			{
				e_attacker.var_29bc01fd = 0;
			}
			e_attacker.var_29bc01fd++;
		}
		if(isdefined(e_attacker.var_29bc01fd) && e_attacker.var_29bc01fd >= 10 && (isdefined(e_attacker.var_2831078e) && e_attacker.var_2831078e >= 10))
		{
			e_attacker notify("hash_86cee34e");
		}
	}
}

