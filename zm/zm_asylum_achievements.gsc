#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace namespace_fb6d42b3;

/*
	Name: __init__sytem__
	Namespace: namespace_fb6d42b3
	Checksum: 0xC1CFA716
	Offset: 0x248
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_theater_achievements", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_fb6d42b3
	Checksum: 0xD9694411
	Offset: 0x288
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.achievement_sound_func = &achievement_sound_func;
	level thread function_fa4b9452();
	zm_spawner::register_zombie_death_event_callback(&function_1abfde35);
	callback::on_connect(&onPlayerConnect);
}

/*
	Name: achievement_sound_func
	Namespace: namespace_fb6d42b3
	Checksum: 0x81AB4FB3
	Offset: 0x308
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function achievement_sound_func(achievement_name_lower)
{
	self endon("disconnect");
	if(!SessionModeIsOnlineGame())
	{
		return;
	}
	for(i = 0; i < self GetEntityNumber() + 1; i++)
	{
		util::wait_network_frame();
	}
	self thread zm_utility::do_player_general_vox("general", "achievement");
}

/*
	Name: onPlayerConnect
	Namespace: namespace_fb6d42b3
	Checksum: 0x6537573D
	Offset: 0x3C0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function onPlayerConnect()
{
	self thread function_a90f7ab8();
	self thread function_9c59bc3();
}

/*
	Name: function_fa4b9452
	Namespace: namespace_fb6d42b3
	Checksum: 0x14F87900
	Offset: 0x400
	Size: 0x89
	Parameters: 0
	Flags: None
*/
function function_fa4b9452()
{
	level endon("end_game");
	level waittill("start_of_round");
	while(level.round_number < 5 && !level flag::get("power_on"))
	{
		level function_64c5daf7();
	}
	if(level flag::get("power_on"))
	{
		/#
		#/
	}
}

/*
	Name: function_64c5daf7
	Namespace: namespace_fb6d42b3
	Checksum: 0x301F0A68
	Offset: 0x498
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function function_64c5daf7()
{
	level endon("end_game");
	level endon("power_on");
	level waittill("end_of_round");
}

/*
	Name: function_a90f7ab8
	Namespace: namespace_fb6d42b3
	Checksum: 0x424269C7
	Offset: 0x4C8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_a90f7ab8()
{
	level endon("end_game");
	self endon("disconnect");
	self.var_2418ad9a = 20;
	self waittill("hash_fadd25a2");
	/#
	#/
	self zm_utility::giveachievement_wrapper("ZM_ASYLUM_ACTED_ALONE", 0);
}

/*
	Name: function_9c59bc3
	Namespace: namespace_fb6d42b3
	Checksum: 0x81ABB22A
	Offset: 0x530
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_9c59bc3()
{
	level endon("end_game");
	self endon("disconnect");
	self.zapped_zombies = 0;
	self thread function_a366eb3e();
	self waittill("hash_c0226895");
	/#
	#/
}

/*
	Name: function_a366eb3e
	Namespace: namespace_fb6d42b3
	Checksum: 0xAD0FC81B
	Offset: 0x588
	Size: 0x55
	Parameters: 0
	Flags: None
*/
function function_a366eb3e()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("hash_c0226895");
	while(self.zapped_zombies < 50)
	{
		self waittill("zombie_zapped");
	}
	self notify("hash_c0226895");
}

/*
	Name: function_1abfde35
	Namespace: namespace_fb6d42b3
	Checksum: 0x38FF8FE9
	Offset: 0x5E8
	Size: 0x24B
	Parameters: 1
	Flags: None
*/
function function_1abfde35(e_attacker)
{
	if(isdefined(e_attacker) && isdefined(e_attacker.zapped_zombies) && e_attacker.zapped_zombies < 50 && isdefined(self.damageWeapon))
	{
		if(self.damageWeapon == level.weaponZMTeslaGun || self.damageWeapon == level.weaponZMTeslaGun)
		{
			e_attacker.zapped_zombies++;
		}
		if(e_attacker.zapped_zombies >= 50)
		{
			e_attacker notify("hash_c0226895");
		}
	}
	if(isdefined(e_attacker) && isdefined(e_attacker.var_2418ad9a) && e_attacker.var_2418ad9a > 0)
	{
		if(!isdefined(self.damagelocation))
		{
			return;
		}
		if(!(isdefined(zm_utility::is_headshot(self.damageWeapon, self.damagelocation, self.damageMod)) && zm_utility::is_headshot(self.damageWeapon, self.damagelocation, self.damageMod)))
		{
			return;
		}
		var_52df56de = GetEnt("area_courtyard", "targetname");
		if(!(isdefined(self istouching(var_52df56de)) && self istouching(var_52df56de)))
		{
			return;
		}
		str_zone = e_attacker zm_zonemgr::get_player_zone();
		var_1486ce13 = StrTok(str_zone, "_");
		if(var_1486ce13[1] != "upstairs")
		{
			return;
		}
		e_attacker.var_2418ad9a--;
		if(e_attacker.var_2418ad9a <= 0)
		{
			e_attacker notify("hash_fadd25a2");
		}
	}
}

