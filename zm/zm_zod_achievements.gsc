#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_zod_util;

#namespace zod_achievements;

/*
	Name: __init__sytem__
	Namespace: zod_achievements
	Checksum: 0xED352723
	Offset: 0x3E8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_achievements", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zod_achievements
	Checksum: 0x1F1FE2E7
	Offset: 0x428
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level thread achievement_complete_all_rituals();
	callback::on_connect(&on_player_connect);
}

/*
	Name: on_player_connect
	Namespace: zod_achievements
	Checksum: 0xA33C22A7
	Offset: 0x470
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self thread achievement_spot_the_shadowman();
	self thread achievement_purchase_and_chew();
	self thread achievement_zombie_store_kills();
	self thread function_b9e36150();
	self thread achievement_civil_protector();
	self thread achievement_widows_wine_kill();
	self thread achievement_margwa_kill();
	self thread achievement_parasite_train_kills();
}

/*
	Name: achievement_help_the_others
	Namespace: zod_achievements
	Checksum: 0x11FFE48B
	Offset: 0x540
	Size: 0x95
	Parameters: 0
	Flags: None
*/
function achievement_help_the_others()
{
	level endon("end_game");
	level flag::wait_till("ritual_pap_complete");
	a_players = GetPlayers();
	for(i = 0; i < a_players.size; i++)
	{
		a_players[i] GiveAchievement("ZM_HELP_OTHERS");
	}
}

/*
	Name: achievement_complete_all_rituals
	Namespace: zod_achievements
	Checksum: 0xC537034A
	Offset: 0x5E0
	Size: 0xCD
	Parameters: 0
	Flags: None
*/
function achievement_complete_all_rituals()
{
	level endon("end_game");
	a_str_ritual_flags = Array("ritual_boxer_complete", "ritual_detective_complete", "ritual_femme_complete", "ritual_magician_complete");
	level flag::wait_till_all(a_str_ritual_flags);
	a_players = GetPlayers();
	for(i = 0; i < a_players.size; i++)
	{
		a_players[i] GiveAchievement("ZM_COMPLETE_RITUALS");
	}
}

/*
	Name: achievement_spot_the_shadowman
	Namespace: zod_achievements
	Checksum: 0xF0876C1B
	Offset: 0x6B8
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function achievement_spot_the_shadowman()
{
	level endon("end_game");
	self endon("disconnect");
	for(var_66f8342 = 0; var_66f8342 < 5; var_66f8342++)
	{
		self waittill("shadowman_spotted");
	}
	self GiveAchievement("ZM_SPOT_SHADOWMAN");
}

/*
	Name: achievement_purchase_and_chew
	Namespace: zod_achievements
	Checksum: 0xE1A8AEBC
	Offset: 0x730
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function achievement_purchase_and_chew()
{
	level endon("end_game");
	self endon("disconnect");
	var_a49e2257 = [];
	while(var_a49e2257.size < 5)
	{
		self waittill("hash_994d5e9e");
		str_name = self.bgb;
		found = 0;
		for(i = 0; i < var_a49e2257.size; i++)
		{
			if(var_a49e2257[i] == str_name)
			{
				found = 1;
				break;
			}
		}
		if(!found)
		{
			Array::add(var_a49e2257, str_name);
		}
	}
	self GiveAchievement("ZM_GOBBLE_GUM");
}

/*
	Name: achievement_zombie_store_kills
	Namespace: zod_achievements
	Checksum: 0xF78CB1F9
	Offset: 0x838
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function achievement_zombie_store_kills()
{
	level endon("end_game");
	self endon("disconnect");
	var_fce7f186 = 0;
	while(var_fce7f186 < 10)
	{
		self waittill("zombie_death_params", var_7ef6d493, var_c3f7e0ed);
		if(isdefined(var_7ef6d493) && IsString(var_7ef6d493) && var_7ef6d493 == "zod_store")
		{
			if(!var_c3f7e0ed)
			{
				var_fce7f186++;
			}
		}
	}
	self GiveAchievement("ZM_STORE_KILL");
}

/*
	Name: function_b9e36150
	Namespace: zod_achievements
	Checksum: 0xB62628CB
	Offset: 0x900
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_b9e36150()
{
	level endon("end_game");
	self endon("disconnect");
	while(1)
	{
		self waittill("hash_4438d786", var_c2faf069);
		if(var_c2faf069 >= 10)
		{
			break;
		}
	}
	self GiveAchievement("ZM_ROCKET_SHIELD_KILL");
}

/*
	Name: achievement_civil_protector
	Namespace: zod_achievements
	Checksum: 0x7568DCD
	Offset: 0x978
	Size: 0x18B
	Parameters: 0
	Flags: None
*/
function achievement_civil_protector()
{
	level endon("end_game");
	self endon("disconnect");
	var_edf7e9c1 = 0;
	b_junction = 0;
	b_canal = 0;
	b_theater = 0;
	b_slums = 0;
	while(var_edf7e9c1 < 4)
	{
		self waittill("hash_b7f8e77c");
		str_district = level.zones[self.zone_name].district;
		if(!b_junction && str_district == "junction")
		{
			b_junction = 1;
			var_edf7e9c1++;
		}
		else if(!b_canal && str_district == "canal")
		{
			b_canal = 1;
			var_edf7e9c1++;
		}
		else if(!b_theater && str_district == "theater")
		{
			b_theater = 1;
			var_edf7e9c1++;
		}
		else if(!b_slums && str_district == "slums")
		{
			b_slums = 1;
			var_edf7e9c1++;
		}
	}
	self GiveAchievement("ZM_CIVIL_PROTECTOR");
}

/*
	Name: achievement_widows_wine_kill
	Namespace: zod_achievements
	Checksum: 0x607ACDC4
	Offset: 0xB10
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function achievement_widows_wine_kill()
{
	level endon("end_game");
	self endon("disconnect");
	var_fce7f186 = 0;
	while(var_fce7f186 < 10)
	{
		self waittill("widows_wine_kill", var_190c9827);
		if(isdefined(var_190c9827) && var_190c9827 == self)
		{
			var_fce7f186++;
		}
	}
	self GiveAchievement("ZM_WINE_GRENADE_KILL");
}

/*
	Name: achievement_margwa_kill
	Namespace: zod_achievements
	Checksum: 0x8B9FF6C1
	Offset: 0xBA8
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function achievement_margwa_kill()
{
	level endon("end_game");
	self endon("disconnect");
	var_b8ac8cce = 0;
	while(1)
	{
		self waittill("margwa_kill");
		if(var_b8ac8cce == 0)
		{
			var_a07758ed = level.round_number;
		}
		else if(var_a07758ed != level.round_number)
		{
			var_a07758ed = level.round_number;
			var_b8ac8cce = 0;
		}
		var_b8ac8cce++;
		if(var_b8ac8cce == 2)
		{
			break;
		}
	}
	self GiveAchievement("ZM_MARGWA_KILL");
}

/*
	Name: achievement_parasite_train_kills
	Namespace: zod_achievements
	Checksum: 0xE08CE765
	Offset: 0xC78
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function achievement_parasite_train_kills()
{
	level endon("end_game");
	self endon("disconnect");
	for(var_fce7f186 = 0; var_fce7f186 < 5; var_fce7f186++)
	{
		self waittill("wasp_train_kill");
	}
	self GiveAchievement("ZM_PARASITE_KILL");
}

