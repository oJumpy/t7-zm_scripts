#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_moon_achievement;

/*
	Name: init
	Namespace: zm_moon_achievement
	Checksum: 0xA2D7D7CB
	Offset: 0x318
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function init()
{
	level thread achievement_moon_sidequest();
	level thread achievement_ground_control();
	callback::on_connect(&onPlayerConnect);
}

/*
	Name: onPlayerConnect
	Namespace: zm_moon_achievement
	Checksum: 0x493B2EA8
	Offset: 0x378
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function onPlayerConnect()
{
	self thread achievement_one_small_hack();
	self thread achievement_one_giant_leap();
	self thread achievement_perks_in_space();
	self thread achievement_fully_armed();
}

/*
	Name: achievement_set_interim_sidequest_stat_for_all_players
	Namespace: zm_moon_achievement
	Checksum: 0x358A2D20
	Offset: 0x3E8
	Size: 0xB5
	Parameters: 1
	Flags: None
*/
function achievement_set_interim_sidequest_stat_for_all_players(stat_name)
{
	if(level.systemLink)
	{
		return;
	}
	if(GetDvarInt("splitscreen_playerCount") == GetPlayers().size)
	{
		return;
	}
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] zm_stats::add_global_stat(stat_name, 1);
	}
}

/*
	Name: achievement_moon_sidequest
	Namespace: zm_moon_achievement
	Checksum: 0x6DA61B3D
	Offset: 0x4A8
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function achievement_moon_sidequest()
{
	level endon("end_game");
	level waittill("moon_sidequest_reveal_achieved");
	level achievement_set_interim_sidequest_stat_for_all_players("ZOMBIE_MOON_SIDEQUEST");
	level zm_utility::giveachievement_wrapper("DLC5_ZOM_CRYOGENIC_PARTY", 1);
	level waittill("moon_sidequest_swap_achieved");
	level waittill("moon_sidequest_big_bang_achieved");
	level thread zm::set_sidequest_completed("MOON");
	if(level.xenon)
	{
		level zm_utility::giveachievement_wrapper("DLC5_ZOM_BIG_BANG_THEORY", 1);
	}
}

/*
	Name: achievement_ground_control
	Namespace: zm_moon_achievement
	Checksum: 0xA10F1C60
	Offset: 0x570
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function achievement_ground_control()
{
	level endon("end_game");
	level flag::wait_till("teleporter_digger_hacked_before_breached");
	level flag::wait_till("hangar_digger_hacked_before_breached");
	level flag::wait_till("biodome_digger_hacked_before_breached");
	/#
	#/
	level zm_utility::giveachievement_wrapper("DLC5_ZOM_GROUND_CONTROL", 1);
}

/*
	Name: achievement_one_small_hack
	Namespace: zm_moon_achievement
	Checksum: 0x325F264D
	Offset: 0x610
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function achievement_one_small_hack()
{
	level endon("end_game");
	self endon("disconnect");
	self waittill("successful_hack");
	/#
	#/
}

/*
	Name: achievement_one_giant_leap
	Namespace: zm_moon_achievement
	Checksum: 0x3B2A44D8
	Offset: 0x648
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function achievement_one_giant_leap()
{
	level endon("end_game");
	self endon("disconnect");
	self waittill("one_giant_leap");
	/#
	#/
	if(!(isdefined(level.played_extra_song_a7x) && level.played_extra_song_a7x))
	{
		level thread zm_audio::sndMusicSystem_PlayState("nightmare");
		level.played_extra_song_a7x = 1;
	}
}

/*
	Name: achievement_perks_in_space
	Namespace: zm_moon_achievement
	Checksum: 0xD60CB6
	Offset: 0x6B8
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function achievement_perks_in_space()
{
	level endon("end_game");
	self endon("disconnect");
	self.perks_in_space_list = [];
	vending_triggers = GetEntArray("zombie_vending", "targetname");
	for(i = 0; i < vending_triggers.size; i++)
	{
		self.perks_in_space_purchased_list[vending_triggers[i].script_noteworthy + "_purchased"] = 0;
	}
	while(1)
	{
		self waittill("perk_bought", perk);
		self.perks_in_space_purchased_list[perk + "_purchased"] = 1;
		keys = getArrayKeys(self.perks_in_space_purchased_list);
		for(i = 0; i < keys.size; i++)
		{
			if(!self.perks_in_space_purchased_list[keys[i]])
			{
				break;
			}
		}
		if(i == self.perks_in_space_purchased_list.size)
		{
			/#
			#/
			return;
		}
	}
}

/*
	Name: achievement_fully_armed
	Namespace: zm_moon_achievement
	Checksum: 0x97B8F5C3
	Offset: 0x820
	Size: 0xF5
	Parameters: 0
	Flags: None
*/
function achievement_fully_armed()
{
	level endon("end_game");
	self endon("disconnect");
	while(1)
	{
		self waittill("pap_taken");
		if(!self hasPerk("specialty_additionalprimaryweapon"))
		{
			continue;
		}
		Primaries = self GetWeaponsListPrimaries();
		if(!isdefined(Primaries) || Primaries.size != 3)
		{
			continue;
		}
		for(i = 0; i < Primaries.size; i++)
		{
			if(!zm_weapons::is_weapon_upgraded(Primaries[i]))
			{
				break;
			}
		}
		if(i == Primaries.size)
		{
			/#
			#/
			return;
		}
	}
}

