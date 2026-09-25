#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_moon_amb;
#using scripts\zm\zm_moon_sq;

#namespace zm_moon_sq_sc;

/*
	Name: init
	Namespace: zm_moon_sq_sc
	Checksum: 0x3CAF7F9D
	Offset: 0x4C0
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function init()
{
	level._active_tanks = [];
	level flag::init("sam_switch_thrown");
	zm_sidequests::declare_sidequest_stage("sq", "sc", &init_stage, &stage_logic, &exit_stage);
	zm_sidequests::declare_stage_asset("sq", "sc", "sq_knife_switch", &sq_sc_switch);
}

/*
	Name: init_2
	Namespace: zm_moon_sq_sc
	Checksum: 0x4F86963A
	Offset: 0x580
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function init_2()
{
	level flag::init("cvg_placed");
	zm_sidequests::declare_sidequest_stage("sq", "sc2", &init_stage_2, &stage_logic_2, &exit_stage_2);
}

/*
	Name: init_stage_2
	Namespace: zm_moon_sq_sc
	Checksum: 0xE2F72FD4
	Offset: 0x600
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function init_stage_2()
{
	level thread place_cvg();
}

/*
	Name: stage_logic_2
	Namespace: zm_moon_sq_sc
	Checksum: 0xF6BFC837
	Offset: 0x628
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function stage_logic_2()
{
	level flag::wait_till("second_tanks_drained");
	level flag::wait_till("soul_swap_done");
	wait(1);
	zm_sidequests::stage_completed("sq", "sc2");
}

/*
	Name: exit_stage_2
	Namespace: zm_moon_sq_sc
	Checksum: 0xD3065C11
	Offset: 0x6A0
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function exit_stage_2(success)
{
}

/*
	Name: init_stage
	Namespace: zm_moon_sq_sc
	Checksum: 0x99EC1590
	Offset: 0x6B8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function init_stage()
{
}

/*
	Name: wall_move
	Namespace: zm_moon_sq_sc
	Checksum: 0x646B5C65
	Offset: 0x6C8
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function wall_move()
{
	level clientfield::set("sam_end_rumble", 1);
	scene::Play("p7_fxanim_zmhd_moon_pyramid_bundle");
	level clientfield::set("sam_init", 1);
	wait(0.1);
	level notify("walls_down");
	level clientfield::set("sam_end_rumble", 0);
}

/*
	Name: stage_logic
	Namespace: zm_moon_sq_sc
	Checksum: 0x59AA432F
	Offset: 0x768
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function stage_logic()
{
	level flag::wait_till("first_tanks_drained");
	level thread wall_move();
	level thread zm_audio::sndMusicSystem_PlayState("samantha_reveal");
	level thread sam_reveal_richtofen_vox();
	level waittill("walls_down");
	wait(1);
	players = GetPlayers();
	Array::thread_all(players, &room_sweeper);
	zm_sidequests::stage_completed("sq", "sc");
}

/*
	Name: sam_reveal_richtofen_vox
	Namespace: zm_moon_sq_sc
	Checksum: 0xFFD46660
	Offset: 0x860
	Size: 0xB5
	Parameters: 0
	Flags: None
*/
function sam_reveal_richtofen_vox()
{
	wait(8);
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		index = zm_utility::get_player_index(players[i]);
		if(index == 3)
		{
			players[i] thread zm_audio::create_and_play_dialog("eggs", "quest4", 3);
		}
	}
}

/*
	Name: room_sweeper
	Namespace: zm_moon_sq_sc
	Checksum: 0xC6663C2
	Offset: 0x920
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function room_sweeper()
{
	while(!zombie_utility::is_player_valid(self) || (self useButtonPressed() && self zm_utility::in_revive_trigger()))
	{
		wait(1);
	}
	level thread zm_powerup_weapon_minigun::minigun_weapon_powerup(self, 90);
	level thread dempsey_gersh_vox();
	level notify("moon_sidequest_reveal_achieved");
}

/*
	Name: dempsey_gersh_vox
	Namespace: zm_moon_sq_sc
	Checksum: 0x8FBAB29
	Offset: 0x9C8
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function dempsey_gersh_vox()
{
	wait(5);
	player = zm_moon_sq::get_specific_player(0);
	if(isdefined(player))
	{
		player playsound("vox_plr_0_stupid_gersh");
	}
}

/*
	Name: exit_stage
	Namespace: zm_moon_sq_sc
	Checksum: 0x82CB718F
	Offset: 0xA20
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function exit_stage(success)
{
}

/*
	Name: sq_sc_switch
	Namespace: zm_moon_sq_sc
	Checksum: 0x719C2F6A
	Offset: 0xA38
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function sq_sc_switch()
{
	level flag::wait_till("first_tanks_charged");
	var_bf58ee19 = GetEnt("use_tank_switch", "targetname");
	var_bf58ee19 waittill("trigger");
	self playsound("zmb_switch_flip_no2d");
	self scene::Play("p7_fxanim_zmhd_power_switch_bundle", self);
	playFX(level._effect["switch_sparks"], struct::get("sq_knife_switch_fx", "targetname").origin);
	wait(1);
	level flag::set("sam_switch_thrown");
}

/*
	Name: do_soul_swap
	Namespace: zm_moon_sq_sc
	Checksum: 0xF8FCB0CA
	Offset: 0xB48
	Size: 0x99
	Parameters: 1
	Flags: None
*/
function do_soul_swap(who)
{
	zm_moon_amb::player_4_override();
	if(isdefined(who))
	{
		who clientfield::set_to_player("soul_swap", 1);
		who zm_moon_sq::give_perk_reward();
	}
	wait(2);
	if(isdefined(who))
	{
		who clientfield::set_to_player("soul_swap", 0);
	}
	level notify("moon_sidequest_swap_achieved");
}

/*
	Name: place_qualifier
	Namespace: zm_moon_sq_sc
	Checksum: 0xD49B392D
	Offset: 0xBF0
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function place_qualifier()
{
	ent_num = self.characterindex;
	if(isdefined(self.zm_random_char))
	{
		ent_num = self.zm_random_char;
	}
	if(ent_num == 2)
	{
		return 1;
	}
	return 0;
}

/*
	Name: richtofen_sam_vo
	Namespace: zm_moon_sq_sc
	Checksum: 0xB4BE765F
	Offset: 0xC40
	Size: 0x1E3
	Parameters: 0
	Flags: None
*/
function richtofen_sam_vo()
{
	level endon("ss_done");
	level.skit_vox_override = 1;
	players = GetPlayers();
	RICHTOFEN = undefined;
	for(i = 0; i < players.size; i++)
	{
		ent_num = players[i].characterindex;
		if(isdefined(players[i].zm_random_char))
		{
			ent_num = players[i].zm_random_char;
		}
		if(ent_num == 2)
		{
			RICHTOFEN = players[i];
			break;
		}
	}
	if(!isdefined(RICHTOFEN))
	{
		return;
	}
	RICHTOFEN PlaySoundWithNotify("vox_plr_2_quest_step6_7", "line_spoken");
	RICHTOFEN waittill("line_spoken");
	targ = struct::get("sq_sam", "targetname");
	targ = struct::get(targ.target, "targetname");
	sound::play_in_space("vox_plr_4_quest_step6_10", targ.origin);
	if(isdefined(RICHTOFEN))
	{
		RICHTOFEN PlaySoundWithNotify("vox_plr_2_quest_step6_8", "line_spoken");
		RICHTOFEN waittill("line_spoken");
	}
	level.skit_vox_override = 0;
}

/*
	Name: place_cvg
	Namespace: zm_moon_sq_sc
	Checksum: 0x14B0FAD5
	Offset: 0xE30
	Size: 0x19F
	Parameters: 0
	Flags: None
*/
function place_cvg()
{
	level flag::wait_till("second_tanks_charged");
	level thread richtofen_sam_vo();
	s = struct::get("sq_vg_final", "targetname");
	s thread zm_sidequests::fake_use("placed_cvg", &place_qualifier);
	s waittill("placed_cvg", who);
	level flag::set("cvg_placed");
	level clientfield::set("vril_generator", 4);
	who zm_sidequests::remove_sidequest_icon("sq", "cgenerator");
	level flag::wait_till("second_tanks_drained");
	level notify("ss_done");
	level thread do_soul_swap(who);
	level flag::set("soul_swap_done");
	level thread play_sam_then_response_line();
	level.skit_vox_override = 0;
}

/*
	Name: play_sam_then_response_line
	Namespace: zm_moon_sq_sc
	Checksum: 0x403833EB
	Offset: 0xFD8
	Size: 0x1E3
	Parameters: 0
	Flags: None
*/
function play_sam_then_response_line()
{
	wait(1);
	SAM = undefined;
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		ent_num = players[i].characterindex;
		if(isdefined(players[i].zm_random_char))
		{
			ent_num = players[i].zm_random_char;
		}
		if(ent_num == 2)
		{
			SAM = players[i];
			break;
		}
	}
	SAM PlaySoundWithNotify("vox_plr_4_quest_step6_12", "linedone");
	SAM waittill("linedone");
	if(!isdefined(SAM))
	{
		return;
	}
	players = GetPlayers();
	player = [];
	for(i = 0; i < players.size; i++)
	{
		if(players[i] != SAM)
		{
			player[player.size] = players[i];
		}
	}
	if(player.size <= 0)
	{
		return;
	}
	player[randomIntRange(0, player.size)] thread zm_audio::create_and_play_dialog("eggs", "quest6", 13);
}

