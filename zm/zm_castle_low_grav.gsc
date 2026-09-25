#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_castle_zombie;

#namespace namespace_8e89abe3;

/*
	Name: __init__sytem__
	Namespace: namespace_8e89abe3
	Checksum: 0x77231B43
	Offset: 0xBA0
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_castle_low_grav", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_8e89abe3
	Checksum: 0x59A673A3
	Offset: 0xBE8
	Size: 0x16D
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "low_grav_powerup_triggered", 5000, 1, "counter");
	clientfield::register("toplayer", "player_screen_fx", 5000, 1, "int");
	clientfield::register("toplayer", "player_postfx", 5000, 1, "int");
	clientfield::register("scriptmover", "undercroft_emissives", 5000, 1, "int");
	clientfield::register("scriptmover", "undercroft_wall_panel_shutdown", 5000, 1, "counter");
	clientfield::register("scriptmover", "zombie_wall_dust", 5000, 1, "counter");
	clientfield::register("scriptmover", "floor_panel_emissives_glow", 5000, 1, "int");
	level._effect["low_grav_player_jump"] = "dlc1/castle/fx_plyr_115_liquid_trail";
}

/*
	Name: __main__
	Namespace: namespace_8e89abe3
	Checksum: 0x926FE976
	Offset: 0xD60
	Size: 0x1D3
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level flag::init("low_grav_countdown");
	level flag::init("low_grav_on");
	level.var_a75d7260 = GetEnt("trig_low_gravity_zone", "targetname");
	level.func_override_wallbuy_prompt = &function_efa3deb8;
	/#
		level thread function_ab786717();
	#/
	level flag::wait_till("start_zombie_round_logic");
	level flag::init("pressure_pads_activated");
	level flag::init("undercroft_powerup_available");
	level flag::init("grav_off_for_ee");
	var_4603701d = GetEntArray("undercroft_floater_scene", "targetname");
	level thread function_8b18e3ce();
	level function_3fa7f11a();
	level thread function_554db684();
	level thread function_644bd455();
	level thread function_2cb9125b();
	level thread function_8a1f0208();
}

/*
	Name: function_3fa7f11a
	Namespace: namespace_8e89abe3
	Checksum: 0x3A9F449D
	Offset: 0xF40
	Size: 0x243
	Parameters: 0
	Flags: None
*/
function function_3fa7f11a()
{
	level endon("hash_854ff4f5");
	var_15ed352b = GetEntArray("grav_pad_trigger", "targetname");
	level.var_d19d5236 = 0;
	level.var_cddeb078 = [];
	foreach(var_3b9a12e0 in var_15ed352b)
	{
		var_3b9a12e0 thread function_e49e9c09();
		var_8ecbce0a = GetEnt(var_3b9a12e0.target, "targetname");
		var_4f15c74f = GetEnt(var_8ecbce0a.target, "targetname");
		Array::add(level.var_cddeb078, var_4f15c74f);
	}
	while(level.var_d19d5236 < var_15ed352b.size)
	{
		wait(0.05);
	}
	foreach(var_3b9a12e0 in var_15ed352b)
	{
		var_544a882 = GetEnt(var_3b9a12e0.target, "targetname");
	}
	level thread function_ed0d48ca();
	level flag::set("pressure_pads_activated");
}

/*
	Name: function_ed0d48ca
	Namespace: namespace_8e89abe3
	Checksum: 0x5EA78B1B
	Offset: 0x1190
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_ed0d48ca()
{
	wait(5);
	exploder::exploder_stop("lgt_grav_pad_n");
	exploder::exploder_stop("lgt_grav_pad_s");
	exploder::exploder_stop("lgt_grav_pad_e");
	exploder::exploder_stop("lgt_grav_pad_w");
}

/*
	Name: function_e49e9c09
	Namespace: namespace_8e89abe3
	Checksum: 0x51B22
	Offset: 0x1208
	Size: 0x2F7
	Parameters: 0
	Flags: None
*/
function function_e49e9c09()
{
	var_8ecbce0a = GetEnt(self.target, "targetname");
	var_8ecbce0a EnableLinkTo();
	var_4f15c74f = GetEnt(var_8ecbce0a.target, "targetname");
	var_4f15c74f EnableLinkTo();
	var_4f15c74f LinkTo(var_8ecbce0a);
	var_2e8e2853 = var_8ecbce0a.origin - VectorScale((0, 0, 1), 2);
	var_93f2a402 = var_8ecbce0a.origin;
	while(1)
	{
		self waittill("trigger", e_who);
		var_8ecbce0a moveto(var_2e8e2853, 0.5);
		playsoundatposition("evt_stone_plate_down", var_8ecbce0a.origin);
		var_8ecbce0a waittill("movedone");
		var_4f15c74f clientfield::set("undercroft_emissives", 1);
		n_start_time = GetTime();
		n_end_time = n_start_time + 3000;
		while(e_who istouching(self))
		{
			n_time = GetTime();
			if(n_time >= n_end_time)
			{
				level.var_d19d5236++;
				exploder::exploder("lgt_" + self.script_string);
				playsoundatposition("evt_stone_plate_up", var_8ecbce0a.origin);
				e_who PlayRumbleOnEntity("zm_castle_low_grav_panel_rumble");
				return;
			}
			wait(0.05);
		}
		var_8ecbce0a moveto(var_93f2a402, 0.5);
		playsoundatposition("evt_stone_plate_down", var_8ecbce0a.origin);
		var_4f15c74f clientfield::set("undercroft_emissives", 0);
		var_4f15c74f clientfield::increment("undercroft_wall_panel_shutdown");
	}
}

/*
	Name: function_554db684
	Namespace: namespace_8e89abe3
	Checksum: 0xA78BCF0B
	Offset: 0x1508
	Size: 0x11B
	Parameters: 0
	Flags: None
*/
function function_554db684()
{
	SetDvar("wallrun_enabled", 1);
	SetDvar("doublejump_enabled", 1);
	SetDvar("playerEnergy_enabled", 1);
	SetDvar("bg_lowGravity", 300);
	SetDvar("wallRun_maxTimeMs_zm", 10000);
	SetDvar("playerEnergy_maxReserve_zm", 200);
	SetDvar("wallRun_peakTest_zm", 0);
	level.var_a75d7260 = GetEnt("trig_low_gravity_zone", "targetname");
	level thread function_fceff7eb();
}

/*
	Name: function_fceff7eb
	Namespace: namespace_8e89abe3
	Checksum: 0x3A60BA2
	Offset: 0x1630
	Size: 0x1AD
	Parameters: 1
	Flags: None
*/
function function_fceff7eb(n_duration)
{
	if(!isdefined(n_duration))
	{
		n_duration = 50;
	}
	/#
		level endon("hash_9c3be857");
	#/
	level thread function_767bba0();
	while(1)
	{
		level flag::set("low_grav_on");
		level thread function_2f712e07();
		exploder::exploder("lgt_low_gravity_on");
		if(!(isdefined(level.var_513683a6) && level.var_513683a6))
		{
			exploder::exploder("fxexp_117");
		}
		level clientfield::set("snd_low_gravity_state", 1);
		level clientfield::set("sndUEB", 1);
		wait(n_duration - 10);
		level function_e1998cb5();
		level flag::clear("low_grav_on");
		exploder::stop_exploder("lgt_low_gravity_on");
		level clientfield::set("snd_low_gravity_state", 0);
		level flag::wait_till_clear("grav_off_for_ee");
		wait(60);
	}
}

/*
	Name: function_e1998cb5
	Namespace: namespace_8e89abe3
	Checksum: 0x2FEE2F8E
	Offset: 0x17E8
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function function_e1998cb5()
{
	level clientfield::set("snd_low_gravity_state", 2);
	level flag::set("low_grav_countdown");
	exploder::exploder("lgt_low_gravity_flash");
	wait(7);
	exploder::stop_exploder("lgt_low_gravity_flash");
	exploder::stop_exploder("fxexp_117");
	exploder::exploder("lgt_low_gravity_flash_fast");
	level clientfield::set("sndUEB", 0);
	wait(3);
	exploder::stop_exploder("lgt_low_gravity_flash_fast");
	level flag::clear("low_grav_countdown");
}

/*
	Name: function_3ccd9604
	Namespace: namespace_8e89abe3
	Checksum: 0x9AF2F114
	Offset: 0x1900
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function function_3ccd9604()
{
	self endon("death");
	while(1)
	{
		if(self istouching(level.var_a75d7260) && level flag::get("low_grav_on") && self.LOW_GRAVITY == 0)
		{
			self namespace_e9d5a0ce::function_104ff02c("low");
			self.LOW_GRAVITY = 1;
		}
		else if(!self istouching(level.var_a75d7260) || !level flag::get("low_grav_on"))
		{
			self namespace_e9d5a0ce::function_104ff02c("normal");
			self.LOW_GRAVITY = 0;
		}
		wait(0.5);
	}
}

/*
	Name: function_f4766f6
	Namespace: namespace_8e89abe3
	Checksum: 0x85FEB71A
	Offset: 0x1A18
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function function_f4766f6()
{
	self endon("death");
	while(1)
	{
		if(self istouching(level.var_a75d7260) && level flag::get("low_grav_on") && (!isdefined(self.LOW_GRAVITY) && self.LOW_GRAVITY))
		{
			self ai::set_behavior_attribute("gravity", "low");
			self.LOW_GRAVITY = 1;
		}
		else if(!self istouching(level.var_a75d7260) || !level flag::get("low_grav_on"))
		{
			self ai::set_behavior_attribute("gravity", "normal");
			self.LOW_GRAVITY = 0;
		}
		wait(0.5);
	}
}

/*
	Name: function_c3f6aa22
	Namespace: namespace_8e89abe3
	Checksum: 0x25E3C7D6
	Offset: 0x1B48
	Size: 0x2B3
	Parameters: 0
	Flags: None
*/
function function_c3f6aa22()
{
	self endon("death");
	self endon("disconnect");
	level flag::wait_till("low_grav_on");
	self.var_7dd18a0 = 0;
	while(1)
	{
		while(self istouching(level.var_a75d7260))
		{
			while(level flag::get("low_grav_on") && self istouching(level.var_a75d7260))
			{
				if(self.var_7dd18a0 == 0)
				{
					self function_f0051f1b(1);
					self function_7c34e9c7(1);
					self setPerk("specialty_lowgravity");
					self.var_7dd18a0 = 1;
					self clientfield::set_to_player("player_screen_fx", 1);
					self thread function_573a448e();
					self clientfield::set_to_player("player_postfx", 1);
					self thread function_e997f73a();
					/#
						if(GetDvarInt("Dev Block strings are not supported") > 0)
						{
							SetDvar("Dev Block strings are not supported", GetDvarInt("Dev Block strings are not supported"));
						}
					#/
				}
				wait(0.1);
			}
			if(self.var_7dd18a0 == 1)
			{
				self function_7c34e9c7(0);
				self function_f0051f1b(0);
				self unsetPerk("specialty_lowgravity");
				self clientfield::set_to_player("player_screen_fx", 0);
				self clientfield::set_to_player("player_postfx", 0);
				self notify("hash_eb16fe00");
				self.var_7dd18a0 = 0;
			}
			wait(0.1);
		}
		wait(0.1);
	}
}

/*
	Name: function_e997f73a
	Namespace: namespace_8e89abe3
	Checksum: 0x4D40ADD7
	Offset: 0x1E08
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function function_e997f73a()
{
	self endon("death");
	self endon("disconnect");
	self endon("hash_eb16fe00");
	while(1)
	{
		if(self IsOnGround() || self IsWallRunning())
		{
			self setdoublejumpenergy(200);
		}
		wait(0.05);
	}
}

/*
	Name: function_573a448e
	Namespace: namespace_8e89abe3
	Checksum: 0x4AFFB723
	Offset: 0x1E90
	Size: 0x16F
	Parameters: 0
	Flags: None
*/
function function_573a448e()
{
	self endon("death");
	self endon("disconnect");
	while(self.var_7dd18a0 == 1)
	{
		self waittill("hash_83e193a3");
		var_5ed20759 = spawn("script_model", self.origin);
		var_5ed20759 SetModel("tag_origin");
		var_5ed20759 EnableLinkTo();
		var_5ed20759 LinkTo(self, "j_spineupper");
		PlayFXOnTag(level._effect["low_grav_player_jump"], var_5ed20759, "tag_origin");
		while(!self IsOnGround() || self IsWallRunning() && level flag::get("low_grav_on"))
		{
			wait(0.5);
		}
		var_5ed20759 delete();
		wait(0.5);
	}
}

/*
	Name: function_767bba0
	Namespace: namespace_8e89abe3
	Checksum: 0x3E802C8C
	Offset: 0x2008
	Size: 0x47F
	Parameters: 0
	Flags: None
*/
function function_767bba0()
{
	/#
		level endon("hash_9c3be857");
	#/
	var_470f053a = struct::get_array("wall_buy_trigger", "targetname");
	var_6ad23999 = GetEntArray("lowgrav_glow", "targetname");
	var_8ff7104f = GetEntArray("pyramid", "targetname");
	var_6ad23999 = ArrayCombine(var_8ff7104f, var_6ad23999, 0, 0);
	while(1)
	{
		level flag::wait_till("low_grav_on");
		var_89ba571 = [];
		foreach(var_7b3fce7b in var_470f053a)
		{
			if(!(isdefined(var_7b3fce7b.activated) && var_7b3fce7b.activated))
			{
				var_b8ac84e8 = GetEnt(var_7b3fce7b.target, "targetname");
				Array::add(var_89ba571, var_b8ac84e8);
			}
		}
		if(level flag::get("undercroft_powerup_available"))
		{
			Array::add(var_89ba571, level.var_6f0e5d4c);
		}
		Array::thread_all(var_89ba571, &clientfield::set, "undercroft_emissives", 1);
		Array::thread_all(var_6ad23999, &clientfield::set, "undercroft_emissives", 1);
		Array::thread_all(level.var_cddeb078, &clientfield::set, "floor_panel_emissives_glow", 1);
		level flag::wait_till("low_grav_countdown");
		wait(10);
		var_89ba571 = [];
		foreach(var_7b3fce7b in var_470f053a)
		{
			if(!(isdefined(var_7b3fce7b.activated) && var_7b3fce7b.activated))
			{
				var_b8ac84e8 = GetEnt(var_7b3fce7b.target, "targetname");
				Array::add(var_89ba571, var_b8ac84e8);
			}
		}
		if(level flag::get("undercroft_powerup_available"))
		{
			Array::add(var_89ba571, level.var_6f0e5d4c);
		}
		Array::thread_all(var_6ad23999, &clientfield::set, "undercroft_emissives", 0);
		Array::thread_all(var_89ba571, &clientfield::set, "undercroft_emissives", 0);
		Array::thread_all(level.var_cddeb078, &clientfield::set, "floor_panel_emissives_glow", 0);
		level flag::wait_till_clear("low_grav_on");
	}
}

/*
	Name: function_2f712e07
	Namespace: namespace_8e89abe3
	Checksum: 0x4D70BBE8
	Offset: 0x2490
	Size: 0x201
	Parameters: 0
	Flags: None
*/
function function_2f712e07()
{
	var_4603701d = GetEntArray("undercroft_floater_model", "targetname");
	if(GetDvarInt("splitscreen_playerCount") > 2)
	{
		Array::run_all(var_4603701d, &delete);
		return;
	}
	Array::thread_all(var_4603701d, &function_5f2da053);
	level flag::wait_till("low_grav_countdown");
	var_3bebe64c = var_4603701d.size;
	var_d1d3b1 = 5;
	var_29be1256 = 5;
	var_2916f722 = Int(var_3bebe64c / var_29be1256);
	var_398a5cc1 = var_d1d3b1 / var_29be1256;
	var_4603701d = Array::randomize(var_4603701d);
	while(var_4603701d.size > 0)
	{
		for(i = 0; i < var_2916f722; i++)
		{
			var_4603701d[i] notify("hash_2f498788");
			var_4603701d = Array::remove_index(var_4603701d, i);
			if(var_4603701d.size <= 1)
			{
				break;
			}
			n_rand_wait = RandomFloatRange(0, 0.5);
			wait(n_rand_wait);
		}
		wait(var_398a5cc1);
	}
}

/*
	Name: function_5f2da053
	Namespace: namespace_8e89abe3
	Checksum: 0xC0D5B972
	Offset: 0x26A0
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function function_5f2da053()
{
	wait(RandomFloatRange(0, 1));
	switch(self.model)
	{
		case "p7_fxanim_zm_castle_undercroft_floaters_books_mod":
		{
			str_scene_name = "p7_fxanim_zm_castle_undercroft_floaters_books_bundle";
			break;
		}
		case "p7_fxanim_zm_castle_undercroft_floaters_candles_mod":
		{
			str_scene_name = "p7_fxanim_zm_castle_undercroft_floaters_candles_bundle";
			break;
		}
		case "p7_fxanim_zm_castle_undercroft_floaters_rocks_mod":
		{
			str_scene_name = "p7_fxanim_zm_castle_undercroft_floaters_rocks_bundle";
			break;
		}
		case "p7_fxanim_zm_castle_undercroft_floaters_skull_mod":
		{
			str_scene_name = "p7_fxanim_zm_castle_undercroft_floaters_skull_bundle";
			break;
		}
		case "p7_fxanim_zm_castle_undercroft_floaters_toolbox_mod":
		{
			str_scene_name = "p7_fxanim_zm_castle_undercroft_floaters_toolbox_bundle";
			break;
		}
		case "p7_fxanim_zm_castle_undercroft_floaters_urn_mod":
		{
			str_scene_name = "p7_fxanim_zm_castle_undercroft_floaters_urn_bundle";
			break;
		}
	}
	self PlayLoopSound("zmb_low_grav_item_loop");
	self scene::Play(str_scene_name + "_up", self);
	self thread scene::Play(str_scene_name + "_idle", self);
	self waittill("hash_2f498788");
	self thread scene::Play(str_scene_name + "_down", self);
	self StopLoopSound();
}

/*
	Name: function_8b18e3ce
	Namespace: namespace_8e89abe3
	Checksum: 0x157637A5
	Offset: 0x2818
	Size: 0x303
	Parameters: 0
	Flags: None
*/
function function_8b18e3ce()
{
	level endon("hash_6580ea04");
	function_7f2caa5(2, "pistol_burst");
	if(level.round_number != 2)
	{
		return;
	}
	function_7f2caa5(4, "ar_marksman");
	function_7f2caa5(5, "pistol_burst");
	var_d99e0864 = GetEnt("zm_fam", "targetname");
	if(!isdefined(var_d99e0864))
	{
		return;
	}
	var_feb1d46b = struct::get("s_zm_fam_loc", "targetname");
	if(!isdefined(var_feb1d46b))
	{
		return;
	}
	e_floor = GetEnt("zm_fam_floor", "targetname");
	if(!isdefined(e_floor))
	{
		return;
	}
	level thread function_f67d5866();
	level.players[0] util::waittill_player_looking_at(var_feb1d46b.origin + VectorScale((0, 0, 1), 50), 90);
	level notify("hash_d64d78d6");
	var_d99e0864.origin = var_feb1d46b.origin + VectorScale((0, 0, 1), 64);
	e_floor.origin = var_feb1d46b.origin;
	e_floor EnableLinkTo();
	var_5ed20759 = spawn("script_model", var_feb1d46b.origin);
	var_5ed20759 SetModel("p7_zm_zod_stage_heart_frame");
	e_floor LinkTo(var_5ed20759);
	for(i = 0; i < 500; i++)
	{
		var_5ed20759 RotateTo(var_5ed20759.angles + VectorScale((0, 1, 0), 180), 3);
		var_5ed20759 waittill("rotatedone");
	}
	var_d99e0864 delete();
	var_5ed20759 delete();
	e_floor delete();
}

/*
	Name: function_f67d5866
	Namespace: namespace_8e89abe3
	Checksum: 0xF34F77C4
	Offset: 0x2B28
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function function_f67d5866()
{
	level endon("hash_d64d78d6");
	wait(5);
	level notify("hash_6580ea04");
}

/*
	Name: function_7f2caa5
	Namespace: namespace_8e89abe3
	Checksum: 0x9AC0E36F
	Offset: 0x2B58
	Size: 0x199
	Parameters: 2
	Flags: None
*/
function function_7f2caa5(n_num, var_42133686)
{
	level waittill("weapon_bought", player, weapon);
	if(weapon.name != var_42133686)
	{
		level notify("hash_6580ea04");
		return;
	}
	foreach(barrier in level.exterior_goals)
	{
		if(IsSubStr(barrier.script_string, "start_set"))
		{
			var_c5f3d26a = 0;
			for(x = 0; x < barrier.zbarrier GetNumZBarrierPieces(); x++)
			{
				if(barrier.zbarrier GetZBarrierPieceState(x) == "closed")
				{
					var_c5f3d26a++;
				}
			}
			if(var_c5f3d26a != n_num)
			{
				level notify("hash_6580ea04");
				return;
			}
		}
	}
}

/*
	Name: function_644bd455
	Namespace: namespace_8e89abe3
	Checksum: 0xD9C13D75
	Offset: 0x2D00
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_644bd455()
{
	a_traps = struct::get_array("low_grav_trap", "targetname");
	Array::thread_all(a_traps, &function_d09bda12);
}

/*
	Name: function_d09bda12
	Namespace: namespace_8e89abe3
	Checksum: 0x8FD43386
	Offset: 0x2D60
	Size: 0x21F
	Parameters: 0
	Flags: None
*/
function function_d09bda12()
{
	var_60532813 = GetEnt(self.script_noteworthy, "targetname");
	self.var_cafd3848 = 1;
	var_c5728235 = GetEnt(self.script_string, "targetname");
	var_6b2a60d = GetEnt(self.target, "targetname");
	var_c5728235 EnableLinkTo();
	var_c5728235 LinkTo(var_6b2a60d);
	var_c5728235 thread trigger_damage();
	while(1)
	{
		var_60532813 waittill("trigger", e_player);
		n_distance = Distance2D(e_player.origin, self.origin);
		if(e_player.var_b94b5f2f == 1 && self.var_cafd3848 == 1 && n_distance > 500 && n_distance < 1000 && e_player IsWallRunning() && !level.dog_intermission)
		{
			e_player thread function_d04113df(3);
			n_rand = RandomFloatRange(0, 1);
			if(n_rand < 0.33)
			{
				self thread function_30b0d4ab(8);
				self thread function_e7a4bc31(e_player);
			}
		}
	}
}

/*
	Name: function_e7a4bc31
	Namespace: namespace_8e89abe3
	Checksum: 0xCF7B07E8
	Offset: 0x2F88
	Size: 0x40B
	Parameters: 1
	Flags: None
*/
function function_e7a4bc31(e_player)
{
	var_6b2a60d = GetEnt(self.target, "targetname");
	var_6b2a60d.original_location = var_6b2a60d.origin;
	var_477663ed = AnglesToForward(self.origin) * 25 + self.origin;
	var_6b2a60d moveto(var_477663ed, 1);
	var_286c5204 = struct::get(var_6b2a60d.target, "targetname");
	var_bb7b50d = zombie_utility::spawn_zombie(level.zombie_spawners[0], "wall_trap_zombie", var_286c5204, 1);
	var_bb7b50d.health = 5;
	var_bb7b50d thread function_f7d8fe24(var_6b2a60d);
	var_5ed20759 = spawn("script_model", var_286c5204.origin);
	var_5ed20759 SetModel("tag_origin");
	var_5ed20759.angles = var_286c5204.angles;
	util::wait_network_frame();
	var_5ed20759 clientfield::increment("zombie_wall_dust");
	if(self.script_int == 1)
	{
		var_5ed20759 playsound("zmb_zombie_wall_spawn");
		var_5ed20759 scene::Play("cin_zm_castle_wall_zombie_right_intro", var_bb7b50d);
		var_5ed20759 scene::Play("cin_zm_castle_wall_zombie_right_main", var_bb7b50d);
		var_6b2a60d moveto(var_6b2a60d.original_location, 1);
		if(isalive(var_bb7b50d))
		{
			var_5ed20759 scene::Play("cin_zm_castle_wall_zombie_right_outro", var_bb7b50d);
			var_bb7b50d notify("hash_6815f745");
			var_bb7b50d delete();
			var_6b2a60d.origin = var_6b2a60d.original_location;
		}
	}
	else
	{
		var_5ed20759 playsound("zmb_zombie_wall_spawn");
		var_5ed20759 scene::Play("cin_zm_castle_wall_zombie_left_intro", var_bb7b50d);
		var_5ed20759 scene::Play("cin_zm_castle_wall_zombie_left_main", var_bb7b50d);
		var_6b2a60d moveto(var_6b2a60d.original_location, 1);
		if(isalive(var_bb7b50d))
		{
			var_5ed20759 scene::Play("cin_zm_castle_wall_zombie_left_outro", var_bb7b50d);
			var_bb7b50d notify("hash_6815f745");
			var_bb7b50d delete();
			var_6b2a60d.origin = var_6b2a60d.original_location;
		}
		var_5ed20759 delete();
	}
}

/*
	Name: function_d04113df
	Namespace: namespace_8e89abe3
	Checksum: 0x716B7BFD
	Offset: 0x33A0
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function function_d04113df(n_wait_time)
{
	self notify("new_timer");
	self endon("new_timer");
	self endon("death");
	self endon("disconnect");
	self.var_b94b5f2f = 0;
	wait(n_wait_time);
	self.var_b94b5f2f = 1;
}

/*
	Name: function_30b0d4ab
	Namespace: namespace_8e89abe3
	Checksum: 0x19149DA5
	Offset: 0x3408
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_30b0d4ab(n_wait_time)
{
	self notify("new_timer");
	self endon("new_timer");
	self.var_cafd3848 = 0;
	wait(n_wait_time);
	self.var_cafd3848 = 1;
}

/*
	Name: trigger_damage
	Namespace: namespace_8e89abe3
	Checksum: 0x23A93E23
	Offset: 0x3458
	Size: 0xCF
	Parameters: 0
	Flags: None
*/
function trigger_damage()
{
	while(1)
	{
		self waittill("trigger", e_who);
		if(isPlayer(e_who) && (!isdefined(e_who.var_c54a399c) && e_who.var_c54a399c))
		{
			e_who DoDamage(25, e_who.origin, undefined, undefined, "none", "MOD_MELEE");
			e_who.var_c54a399c = 1;
			e_who thread function_266e5562();
		}
		wait(0.05);
	}
}

/*
	Name: function_266e5562
	Namespace: namespace_8e89abe3
	Checksum: 0xDE5884A7
	Offset: 0x3530
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function function_266e5562()
{
	self endon("death");
	self endon("disconnect");
	wait(0.5);
	self.var_c54a399c = 0;
}

/*
	Name: function_f7d8fe24
	Namespace: namespace_8e89abe3
	Checksum: 0x6261AFBA
	Offset: 0x3568
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function function_f7d8fe24(var_6b2a60d)
{
	self endon("hash_6815f745");
	self.no_powerups = 1;
	self waittill("death");
	var_6b2a60d.origin = var_6b2a60d.original_location;
	level.zombie_total++;
	GibServerUtils::Annihilate(self);
}

/*
	Name: function_2cb9125b
	Namespace: namespace_8e89abe3
	Checksum: 0x6CCDC9D9
	Offset: 0x35E0
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function function_2cb9125b()
{
	var_9369bf6c = struct::get("powerup_button", "targetname");
	s_unitrigger_stub = spawnstruct();
	s_unitrigger_stub.origin = var_9369bf6c.origin;
	s_unitrigger_stub.angles = var_9369bf6c.angles;
	s_unitrigger_stub.script_unitrigger_type = "unitrigger_box";
	s_unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_unitrigger_stub.require_look_at = 0;
	s_unitrigger_stub.script_length = 32;
	s_unitrigger_stub.script_width = 64;
	s_unitrigger_stub.script_height = 64;
	s_unitrigger_stub.var_bf3837fa = var_9369bf6c;
	level flag::set("undercroft_powerup_available");
	level.var_57c06a96 = 1;
	s_unitrigger_stub.prompt_and_visibility_func = &function_94073af5;
	level.var_6f0e5d4c = GetEnt(var_9369bf6c.target, "targetname");
	thread zm_unitrigger::register_static_unitrigger(s_unitrigger_stub, &function_81be0b2f);
}

/*
	Name: function_94073af5
	Namespace: namespace_8e89abe3
	Checksum: 0x84492584
	Offset: 0x3788
	Size: 0x2D
	Parameters: 1
	Flags: None
*/
function function_94073af5(player)
{
	if(level.round_number >= level.var_57c06a96)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

/*
	Name: function_81be0b2f
	Namespace: namespace_8e89abe3
	Checksum: 0x2C5B346B
	Offset: 0x37C0
	Size: 0x1CB
	Parameters: 0
	Flags: None
*/
function function_81be0b2f()
{
	e_player = self.parent_player;
	if(e_player IsWallRunning() && level flag::get("undercroft_powerup_available"))
	{
		level flag::clear("undercroft_powerup_available");
		var_7c68b1e = GetEnt(self.stub.var_bf3837fa.target, "targetname");
		var_17ff3d6f = VectorNormalize(AnglesToForward(self.stub.var_bf3837fa.angles)) * 0;
		var_e16f14a2 = var_17ff3d6f + var_7c68b1e.origin;
		var_7c68b1e.old_origin = var_7c68b1e.origin;
		var_7c68b1e moveto(var_e16f14a2, 0.5);
		var_7c68b1e clientfield::increment("low_grav_powerup_triggered");
		e_player PlayRumbleOnEntity("zm_castle_low_grav_panel_rumble");
		level.var_6f0e5d4c clientfield::increment("undercroft_wall_panel_shutdown");
		self thread function_34091daf(var_7c68b1e);
	}
}

/*
	Name: function_34091daf
	Namespace: namespace_8e89abe3
	Checksum: 0xEFE7059E
	Offset: 0x3998
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function function_34091daf(var_7c68b1e)
{
	var_c21c2ac2 = struct::get("low_grav_powerup_spawn", "targetname");
	powerup = zm_powerups::specific_powerup_drop("minigun", var_c21c2ac2.origin);
	level thread function_42dee8e(var_7c68b1e, powerup, self.stub);
	level thread powerup_timer(var_7c68b1e, powerup, self.stub);
}

/*
	Name: function_42dee8e
	Namespace: namespace_8e89abe3
	Checksum: 0x2B99500
	Offset: 0x3A58
	Size: 0x83
	Parameters: 3
	Flags: None
*/
function function_42dee8e(var_7c68b1e, powerup, unitrigger_stub)
{
	level endon("hash_558a2606");
	powerup waittill("powerup_grabbed");
	level.var_57c06a96 = level.round_number + randomIntRange(3, 5);
	level thread function_34029460(var_7c68b1e, unitrigger_stub);
}

/*
	Name: function_34029460
	Namespace: namespace_8e89abe3
	Checksum: 0x1CBD848C
	Offset: 0x3AE8
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function function_34029460(var_7c68b1e, unitrigger_stub)
{
	while(1)
	{
		level waittill("start_of_round");
		if(level.round_number >= level.var_57c06a96)
		{
			var_7c68b1e moveto(var_7c68b1e.old_origin, 0.5);
			level flag::set("undercroft_powerup_available");
			break;
		}
	}
}

/*
	Name: powerup_timer
	Namespace: namespace_8e89abe3
	Checksum: 0x6F8195C8
	Offset: 0x3B80
	Size: 0xA3
	Parameters: 3
	Flags: None
*/
function powerup_timer(var_7c68b1e, powerup, unitrigger_stub)
{
	powerup endon("powerup_grabbed");
	wait(10);
	level notify("hash_558a2606");
	powerup zm_powerups::powerup_delete();
	wait(50);
	var_7c68b1e moveto(var_7c68b1e.old_origin, 0.5);
	level flag::set("undercroft_powerup_available");
}

/*
	Name: function_8a1f0208
	Namespace: namespace_8e89abe3
	Checksum: 0xED2A5865
	Offset: 0x3C30
	Size: 0x85
	Parameters: 0
	Flags: None
*/
function function_8a1f0208()
{
	level.var_aed784b3 = 0;
	var_15ed352b = struct::get_array("wall_buy_trigger", "targetname");
	for(i = 0; i < var_15ed352b.size; i++)
	{
		var_15ed352b[i] thread function_20c76956();
	}
}

/*
	Name: function_20c76956
	Namespace: namespace_8e89abe3
	Checksum: 0xD27EC534
	Offset: 0x3CC0
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function function_20c76956()
{
	s_unitrigger_stub = spawnstruct();
	s_unitrigger_stub.origin = self.origin;
	s_unitrigger_stub.angles = self.angles;
	s_unitrigger_stub.script_unitrigger_type = "unitrigger_box";
	s_unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_unitrigger_stub.require_look_at = 0;
	s_unitrigger_stub.script_length = 32;
	s_unitrigger_stub.script_width = 64;
	s_unitrigger_stub.script_height = 64;
	s_unitrigger_stub.var_bf3837fa = self;
	s_unitrigger_stub.var_bf3837fa.activated = 0;
	thread zm_unitrigger::register_static_unitrigger(s_unitrigger_stub, &function_147f328);
}

/*
	Name: function_147f328
	Namespace: namespace_8e89abe3
	Checksum: 0xA4501EB
	Offset: 0x3DD0
	Size: 0x1B3
	Parameters: 1
	Flags: None
*/
function function_147f328(var_607fccfa)
{
	e_player = self.parent_player;
	if(e_player IsWallRunning() && self.stub.var_bf3837fa.activated == 0)
	{
		self.stub.var_bf3837fa.activated = 1;
		var_544a882 = GetEnt(self.stub.var_bf3837fa.target, "targetname");
		playsoundatposition("evt_stone_plate_down", var_544a882.origin);
		e_player PlayRumbleOnEntity("zm_castle_low_grav_panel_rumble");
		level.var_aed784b3++;
		var_1b02ae62 = struct::get_array("wall_buy_trigger", "targetname");
		if(level.var_aed784b3 >= var_1b02ae62.size)
		{
			var_cd1d0af1 = GetEnt("brm_door", "targetname");
			var_cd1d0af1 MoveZ(-20, 2, 0, 1.5);
		}
		var_544a882 clientfield::increment("undercroft_wall_panel_shutdown");
	}
}

/*
	Name: function_efa3deb8
	Namespace: namespace_8e89abe3
	Checksum: 0xEF298C9A
	Offset: 0x3F90
	Size: 0xEB
	Parameters: 1
	Flags: None
*/
function function_efa3deb8(e_player)
{
	if(self.weapon.name == "lmg_light")
	{
		var_15ed352b = struct::get_array("wall_buy_trigger", "targetname");
		if(level.var_aed784b3 >= var_15ed352b.size)
		{
			return 1;
		}
		else
		{
			self.stub.hint_string = "";
			self setHintString("");
			self.stub.cursor_hint = "HINT_NOICON";
			self setcursorhint("HINT_NOICON");
			return 0;
		}
	}
	return 1;
}

/*
	Name: function_2449723c
	Namespace: namespace_8e89abe3
	Checksum: 0xF1FDBA37
	Offset: 0x4088
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function function_2449723c()
{
	/#
		if(isdefined(self.var_8665ab89))
		{
			if(self.var_8665ab89 == GetTime())
			{
				return 1;
			}
		}
		self.var_8665ab89 = GetTime();
		return 0;
	#/
}

/*
	Name: function_ab786717
	Namespace: namespace_8e89abe3
	Checksum: 0xABEF71B8
	Offset: 0x40C8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_ab786717()
{
	/#
		level flagsys::wait_till("Dev Block strings are not supported");
		wait(1);
		zm_devgui::function_4acecab5(&function_e41a2453);
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_e41a2453
	Namespace: namespace_8e89abe3
	Checksum: 0x5C1DBFBC
	Offset: 0x4138
	Size: 0x75
	Parameters: 1
	Flags: None
*/
function function_e41a2453(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				if(level function_2449723c())
				{
					return 1;
				}
				level notify("hash_9c3be857");
				level thread function_fceff7eb(9999);
				return 1;
			}
		}
		return 0;
	#/
}

