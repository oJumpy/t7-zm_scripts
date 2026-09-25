#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_powerup_castle_tram_token;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_castle_vo;

#namespace namespace_30db0d4;

/*
	Name: __init__sytem__
	Namespace: namespace_30db0d4
	Checksum: 0x6664CB9E
	Offset: 0xA10
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_castle_tram", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_30db0d4
	Checksum: 0x343136BF
	Offset: 0xA58
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "tram_fuse_destroy", 1, 1, "counter");
	clientfield::register("scriptmover", "tram_fuse_fx", 1, 1, "counter");
	clientfield::register("scriptmover", "cleanup_dynents", 1, 1, "counter");
	clientfield::register("world", "snd_tram", 5000, 2, "int");
}

/*
	Name: __main__
	Namespace: namespace_30db0d4
	Checksum: 0x6A5C886E
	Offset: 0xB28
	Size: 0x20B
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level flag::init("tram_moving");
	level flag::init("tram_cooldown");
	level flag::init("tram_docked");
	level flag::init("player_tram_docked");
	level thread function_e16148c8();
	level thread function_3bda7a32();
	/#
		level thread function_57f998e3();
	#/
	level thread scene::Play("p7_fxanim_zm_castle_tram_motor_small_gears_bundle");
	scene::add_scene_func("p7_fxanim_zm_castle_tram_car_01_down_bundle", &function_310924ec, "init");
	scene::add_scene_func("p7_fxanim_zm_castle_tram_car_01_start_bundle", &function_3584e778, "play");
	scene::add_scene_func("p7_fxanim_zm_castle_tram_car_01_a_bundle", &function_3584e778, "play");
	scene::add_scene_func("p7_fxanim_zm_castle_tram_car_01_b_bundle", &function_3584e778, "play");
	scene::add_scene_func("p7_fxanim_zm_castle_tram_car_02_a_bundle", &function_3584e778, "play");
	scene::add_scene_func("p7_fxanim_zm_castle_tram_car_02_b_bundle", &function_3584e778, "play");
}

/*
	Name: function_e16148c8
	Namespace: namespace_30db0d4
	Checksum: 0x735A68E4
	Offset: 0xD40
	Size: 0x34F
	Parameters: 0
	Flags: None
*/
function function_e16148c8()
{
	s_spawn_pos = struct::get("tram_object_spawn_pos", "targetname");
	level waittill("start_zombie_round_logic");
	exploder::exploder("lgt_tram_car_02_down");
	level._powerup_timeout_override = &function_ccc738b1;
	intro_powerup = zm_powerups::specific_powerup_drop("castle_tram_token", struct::get("tram_token_spawn_pos").origin);
	level._powerup_timeout_override = undefined;
	level thread function_7b56c646();
	level thread function_97f09efd();
	while(1)
	{
		level waittill("hash_b2fa2cac", e_who);
		level flag::set("tram_moving");
		level thread function_4173be8d("tram_car_02", "tram_docked");
		level thread function_ccd0cc8e();
		level function_1ff56fb0("p7_fxanim_zm_castle_tram_car_02_a_bundle");
		level scene::Play("p7_fxanim_zm_castle_tram_car_02_a_bundle");
		level flag::set("tram_docked");
		level flag::clear("tram_moving");
		function_1d6e73d0(e_who, s_spawn_pos);
		while(isdefined(function_9d4a523c("docked_tram_car_interior")) && function_9d4a523c("docked_tram_car_interior"))
		{
			wait(0.1);
		}
		level flag::set("tram_moving");
		level flag::clear("tram_docked");
		playsoundatposition("vox_maxis_gondola_pa_departing_0", (400, 675, 40));
		level function_1ff56fb0("p7_fxanim_zm_castle_tram_car_02_b_bundle");
		level scene::Play("p7_fxanim_zm_castle_tram_car_02_b_bundle");
		level flag::set("tram_cooldown");
		level flag::clear("tram_moving");
		wait(8);
		level flag::clear("tram_cooldown");
	}
}

/*
	Name: function_9d4a523c
	Namespace: namespace_30db0d4
	Checksum: 0x56A3CB29
	Offset: 0x1098
	Size: 0x1A3
	Parameters: 1
	Flags: None
*/
function function_9d4a523c(var_24ee4867)
{
	var_9fa821d4 = GetEnt(var_24ee4867, "targetname");
	foreach(player in level.activePlayers)
	{
		if(zm_utility::is_player_valid(player, undefined, 1) && player istouching(var_9fa821d4))
		{
			return 1;
		}
	}
	a_zombies = GetAITeamArray(level.zombie_team);
	foreach(ai_zombie in a_zombies)
	{
		if(ai_zombie istouching(var_9fa821d4))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: function_4173be8d
	Namespace: namespace_30db0d4
	Checksum: 0x4E968964
	Offset: 0x1248
	Size: 0x183
	Parameters: 2
	Flags: None
*/
function function_4173be8d(var_d484b386, var_15872fa7)
{
	exploder::stop_exploder("lgt_" + var_d484b386 + "_down");
	while(level flag::get("tram_moving") || level flag::get(var_15872fa7))
	{
		exploder::exploder("lgt_" + var_d484b386 + "_up");
		wait(0.6);
		exploder::stop_exploder("lgt_" + var_d484b386 + "_up");
		wait(0.6);
	}
	exploder::exploder("lgt_" + var_d484b386 + "_down");
	if(var_d484b386 === "tram_car_02")
	{
		level flag::wait_till_clear("tram_cooldown");
		exploder::stop_exploder("lgt_" + var_d484b386 + "_down");
		exploder::exploder("lgt_" + var_d484b386 + "_up");
	}
}

/*
	Name: function_3bda7a32
	Namespace: namespace_30db0d4
	Checksum: 0x2D069808
	Offset: 0x13D8
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function function_3bda7a32()
{
	scene::add_scene_func("p7_fxanim_zm_castle_tram_car_01_start_bundle", &function_350d7037, "init");
	level.var_f31afb37 = 1;
	level waittill("start_zombie_round_logic");
	level thread function_3fb91800();
	level thread function_427ee40c();
}

/*
	Name: function_427ee40c
	Namespace: namespace_30db0d4
	Checksum: 0xC0A9E84A
	Offset: 0x1460
	Size: 0x42F
	Parameters: 0
	Flags: None
*/
function function_427ee40c()
{
	s_spawn_pos = struct::get("player_tram_object_spawn_pos", "targetname");
	exploder::exploder("lgt_tram_car_01_up");
	level flag::set("player_tram_docked");
	level thread scene::init("p7_fxanim_zm_castle_tram_car_01_start_bundle");
	level thread scene::init("p7_fxanim_zm_castle_tram_car_01_down_bundle");
	wait(12);
	level flag::set("tram_moving");
	level flag::clear("player_tram_docked");
	level.var_f31afb37 = undefined;
	level thread function_4173be8d("tram_car_01", "player_tram_docked");
	level scene::Play("p7_fxanim_zm_castle_tram_car_01_start_bundle");
	level flag::set("tram_cooldown");
	level flag::clear("tram_moving");
	wait(8);
	level flag::clear("tram_cooldown");
	exploder::stop_exploder("lgt_tram_car_02_down");
	exploder::exploder("lgt_tram_car_02_up");
	while(1)
	{
		level waittill("hash_95a2806", e_who);
		level flag::set("tram_moving");
		level thread function_4173be8d("tram_car_01", "player_tram_docked");
		level thread function_ccd0cc8e();
		level function_1ff56fb0("p7_fxanim_zm_castle_tram_car_01_a_bundle");
		level scene::Play("p7_fxanim_zm_castle_tram_car_01_a_bundle");
		level flag::set("player_tram_docked");
		level flag::clear("tram_moving");
		wait(0.5);
		var_f2c2f39 = 1;
		function_1d6e73d0(e_who, s_spawn_pos, var_f2c2f39);
		while(isdefined(function_9d4a523c("player_tram_car_interior")) && function_9d4a523c("player_tram_car_interior"))
		{
			wait(0.1);
		}
		level flag::set("tram_moving");
		level flag::clear("player_tram_docked");
		level function_1ff56fb0("p7_fxanim_zm_castle_tram_car_01_b_bundle");
		level scene::Play("p7_fxanim_zm_castle_tram_car_01_b_bundle");
		level flag::set("tram_cooldown");
		level flag::clear("tram_moving");
		wait(8);
		level flag::clear("tram_cooldown");
	}
}

/*
	Name: function_38a21d48
	Namespace: namespace_30db0d4
	Checksum: 0x22DA3496
	Offset: 0x1898
	Size: 0xE7
	Parameters: 0
	Flags: None
*/
function function_38a21d48()
{
	level endon("hash_73653c73");
	self SetCanDamage(1);
	self.health = 100000;
	while(1)
	{
		self waittill("damage", n_amount, e_attacker, v_direction, v_point, str_type);
		if(isPlayer(e_attacker) && (str_type == "MOD_GRENADE" || str_type == "MOD_GRENADE_SPLASH"))
		{
			e_attacker.var_a1ba5103 = 1;
			e_attacker.var_66e0478a = 0;
		}
	}
}

/*
	Name: function_350d7037
	Namespace: namespace_30db0d4
	Checksum: 0x4A146075
	Offset: 0x1988
	Size: 0x123
	Parameters: 1
	Flags: None
*/
function function_350d7037(a_ents)
{
	level.var_423f296e = GetEnt("ee_gondola_clip", "targetname");
	a_ents["tram_car_01"] thread function_38a21d48();
	var_fd0bd09e = GetEnt("castle_tram_2", "script_noteworthy");
	if(isdefined(var_fd0bd09e))
	{
		var_fd0bd09e LinkTo(a_ents["tram_car_01"], "probe_jnt", (0, 0, 0));
	}
	var_abcc129 = GetEnt("castle_tram", "script_noteworthy");
	if(isdefined(var_abcc129))
	{
		var_abcc129 LinkTo(a_ents["tram_car_02"], "probe_jnt", (0, 0, 0));
	}
}

/*
	Name: function_1ff56fb0
	Namespace: namespace_30db0d4
	Checksum: 0xEF7F40
	Offset: 0x1AB8
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_1ff56fb0(str_scene)
{
	s_scene = struct::get(str_scene, "scriptbundlename");
	if(isdefined(s_scene))
	{
		s_scene.scene_played = 0;
	}
}

/*
	Name: function_3584e778
	Namespace: namespace_30db0d4
	Checksum: 0x57F4F9AF
	Offset: 0x1B18
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function function_3584e778(a_ents)
{
	level clientfield::set("snd_tram", 1);
	a_ents["tram_car_01"] thread function_ce881a6();
	a_ents["tram_car_02"] thread function_ce881a6();
	a_ents["tram_car_01"] clientfield::increment("cleanup_dynents");
	a_ents["tram_car_02"] clientfield::increment("cleanup_dynents");
	level waittill(self.scriptbundlename + "_done");
	level notify("hash_a9fe9747");
	level clientfield::set("snd_tram", 2);
}

/*
	Name: function_7b56c646
	Namespace: namespace_30db0d4
	Checksum: 0x12938194
	Offset: 0x1C20
	Size: 0x41D
	Parameters: 0
	Flags: None
*/
function function_7b56c646()
{
	var_b86004b6 = GetEntArray("tram_clip", "targetname");
	var_5cbc86c9 = GetEntArray("tram_gates", "targetname");
	foreach(var_a7c049ac in var_5cbc86c9)
	{
		var_a7c049ac.start_pos = var_a7c049ac.origin;
		var_a6052bbf = struct::get(var_a7c049ac.target, "targetname");
		var_a7c049ac.open_pos = var_a6052bbf.origin;
	}
	while(1)
	{
		level flag::wait_till("tram_docked");
		foreach(e_clip in var_b86004b6)
		{
			e_clip notsolid();
			e_clip connectpaths();
		}
		foreach(var_a7c049ac in var_5cbc86c9)
		{
			var_a7c049ac moveto(var_a7c049ac.open_pos, 1.5);
			var_a7c049ac playsound("evt_tram_station_gate");
		}
		level flag::wait_till_clear("tram_docked");
		foreach(e_clip in var_b86004b6)
		{
			e_clip solid();
			e_clip disconnectpaths();
		}
		foreach(var_a7c049ac in var_5cbc86c9)
		{
			var_a7c049ac moveto(var_a7c049ac.start_pos, 0.5);
			var_a7c049ac playsound("evt_tram_station_gate");
		}
	}
}

/*
	Name: function_3fb91800
	Namespace: namespace_30db0d4
	Checksum: 0x430FE8C5
	Offset: 0x2048
	Size: 0x44D
	Parameters: 0
	Flags: None
*/
function function_3fb91800()
{
	var_b86004b6 = GetEntArray("player_tram_clip", "targetname");
	var_5cbc86c9 = GetEntArray("player_tram_gates", "targetname");
	foreach(var_a7c049ac in var_5cbc86c9)
	{
		var_a7c049ac.start_pos = var_a7c049ac.origin;
		var_a6052bbf = struct::get(var_a7c049ac.target, "targetname");
		var_a7c049ac.open_pos = var_a6052bbf.origin;
	}
	while(isdefined(level.var_f31afb37) && level.var_f31afb37)
	{
		util::wait_network_frame();
	}
	while(1)
	{
		level flag::wait_till("player_tram_docked");
		foreach(e_clip in var_b86004b6)
		{
			e_clip notsolid();
			e_clip connectpaths();
		}
		foreach(var_a7c049ac in var_5cbc86c9)
		{
			var_a7c049ac moveto(var_a7c049ac.open_pos, 1.5);
			var_a7c049ac playsound("evt_tram_station_gate");
		}
		level flag::wait_till_clear("player_tram_docked");
		foreach(e_clip in var_b86004b6)
		{
			e_clip solid();
			e_clip disconnectpaths();
		}
		foreach(var_a7c049ac in var_5cbc86c9)
		{
			var_a7c049ac moveto(var_a7c049ac.start_pos, 0.5);
			var_a7c049ac playsound("evt_tram_station_gate");
		}
	}
}

/*
	Name: function_1d6e73d0
	Namespace: namespace_30db0d4
	Checksum: 0x124C83D4
	Offset: 0x24A0
	Size: 0x513
	Parameters: 3
	Flags: None
*/
function function_1d6e73d0(e_player, s_spawn_pos, var_f2c2f39)
{
	var_8643fc8a = RandomInt(100);
	var_d54b1ec = [];
	/#
		if(GetDvarInt("Dev Block strings are not supported") == 1)
		{
			var_8643fc8a = 20;
		}
		else if(GetDvarInt("Dev Block strings are not supported") == 2)
		{
			var_8643fc8a = 5;
		}
	#/
	if(var_8643fc8a == 1 && level.round_number >= 5)
	{
		var_929a8e9b = 1;
	}
	else if(var_8643fc8a <= 20 && level.round_number >= 5)
	{
		Array::add(var_d54b1ec, "bonus_points_team");
		Array::add(var_d54b1ec, "fire_sale");
	}
	else
	{
		Array::add(var_d54b1ec, "double_points");
		Array::add(var_d54b1ec, "insta_kill");
		Array::add(var_d54b1ec, "full_ammo");
		if(level.round_number >= 5)
		{
			Array::add(var_d54b1ec, "nuke");
		}
		if(isdefined(e_player.hasRiotShield) && e_player.hasRiotShield && e_player getammocount(e_player.weaponRiotshield) !== e_player.weaponRiotshield.maxAmmo)
		{
			Array::add(var_d54b1ec, "shield_charge");
		}
	}
	var_a11baa62 = Array("fire_sale", "double_points", "insta_kill", "full_ammo", "nuke");
	if(isdefined(var_f2c2f39) && var_f2c2f39)
	{
		var_8b961b44 = function_b29057c7(e_player);
		var_bd4efc7d = s_spawn_pos function_b21df67c(e_player, var_8b961b44);
	}
	else if(isdefined(var_929a8e9b) && var_929a8e9b)
	{
		var_8b961b44 = GetWeapon("ray_gun");
		var_2fd9a02f = zm_pap_util::get_triggers();
		if(zm_magicbox::treasure_chest_CanPlayerReceiveWeapon(e_player, var_8b961b44, var_2fd9a02f))
		{
			var_bd4efc7d = s_spawn_pos function_b21df67c(e_player, var_8b961b44);
		}
		else
		{
			var_bd4efc7d = zm_powerups::specific_powerup_drop("full_ammo", s_spawn_pos.origin);
			var_bd4efc7d thread function_bb44b161("full_ammo", var_a11baa62);
		}
		var_929a8e9b = undefined;
	}
	else
	{
		str_type = Array::random(var_d54b1ec);
		var_bd4efc7d = zm_powerups::specific_powerup_drop(str_type, s_spawn_pos.origin);
		var_bd4efc7d thread function_bb44b161(str_type, var_a11baa62);
	}
	if(var_8643fc8a >= 97)
	{
		var_f1c9d472 = struct::get("tram_enemy_spawn_pos", "targetname");
		var_88af999e = zombie_utility::spawn_zombie(level.zombie_spawners[0], "tram_car_zombie", var_f1c9d472);
		playFX(level._effect["lightning_dog_spawn"], var_88af999e.origin);
	}
	var_bd4efc7d util::waittill_either("powerup_grabbed", "powerup_timedout");
}

/*
	Name: function_bb44b161
	Namespace: namespace_30db0d4
	Checksum: 0x9B3A493F
	Offset: 0x29C0
	Size: 0xFB
	Parameters: 2
	Flags: None
*/
function function_bb44b161(str_powerup, var_a11baa62)
{
	self endon("powerup_grabbed");
	var_ee91d5b = self.model;
	for(i = 0; i < 3; i++)
	{
		for(j = 0; j < var_a11baa62.size; j++)
		{
			s_powerup = level.zombie_powerups[var_a11baa62[j]];
			self SetModel(s_powerup.model_name);
			wait(0.12);
		}
	}
	self SetModel(var_ee91d5b);
}

/*
	Name: function_b29057c7
	Namespace: namespace_30db0d4
	Checksum: 0xAB93AE23
	Offset: 0x2AC8
	Size: 0xB7
	Parameters: 1
	Flags: None
*/
function function_b29057c7(player)
{
	var_fdd157a7 = [];
	Array::add(var_fdd157a7, GetWeapon("cymbal_monkey"));
	Array::add(var_fdd157a7, GetWeapon("shotgun_fullauto_upgraded"));
	Array::add(var_fdd157a7, GetWeapon("ar_damage_upgraded"));
	var_fdd157a7 = Array::randomize(var_fdd157a7);
	return var_fdd157a7[0];
}

/*
	Name: function_b21df67c
	Namespace: namespace_30db0d4
	Checksum: 0x120F079D
	Offset: 0x2B88
	Size: 0x187
	Parameters: 2
	Flags: None
*/
function function_b21df67c(e_player, var_8b961b44)
{
	v_spawnpt = self.origin + (0, 0, 40);
	v_spawnang = (0, 0, 0);
	v_angles = e_player getPlayerAngles();
	v_angles = (0, v_angles[1], 0) + VectorScale((0, 1, 0), 90) + v_spawnang;
	mdl_weapon = zm_utility::spawn_buildkit_weapon_model(e_player, var_8b961b44, undefined, v_spawnpt, v_angles);
	mdl_weapon.angles = v_angles;
	mdl_weapon thread timer_til_despawn(v_spawnpt);
	mdl_weapon endon("powerup_timedout");
	mdl_weapon.trigger = function_a40fee2f(v_spawnpt, 100);
	mdl_weapon.trigger.var_d2af076 = var_8b961b44;
	mdl_weapon.trigger.prompt_and_visibility_func = &function_3674f451;
	mdl_weapon thread function_cc0d2cc9(var_8b961b44);
	return mdl_weapon;
}

/*
	Name: function_cc0d2cc9
	Namespace: namespace_30db0d4
	Checksum: 0x3AD5DAB2
	Offset: 0x2D18
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function function_cc0d2cc9(var_8b961b44)
{
	self.trigger waittill("trigger", e_who);
	self notify("powerup_grabbed");
	e_who zm_weapons::weapon_give(var_8b961b44, 0, 0);
	if(isdefined(self.trigger))
	{
		zm_unitrigger::unregister_unitrigger(self.trigger);
		self.trigger = undefined;
	}
	if(isdefined(self))
	{
		playFX(level._effect["powerup_grabbed"], self.origin);
		self delete();
	}
}

/*
	Name: timer_til_despawn
	Namespace: namespace_30db0d4
	Checksum: 0xA0637AB3
	Offset: 0x2DF8
	Size: 0x143
	Parameters: 2
	Flags: None
*/
function timer_til_despawn(v_float, n_dist)
{
	self endon("powerup_grabbed");
	self endon("delete");
	n_start_time = GetTime();
	n_total_time = 0;
	self clientfield::set("powerup_fx", 1);
	while(12 > n_total_time)
	{
		self RotateYaw(360, 1);
		wait(1);
		n_total_time = GetTime() - n_start_time / 1000;
	}
	self notify("powerup_timedout");
	if(isdefined(self.trigger))
	{
		zm_unitrigger::unregister_unitrigger(self.trigger);
		self.trigger = undefined;
	}
	if(isdefined(self))
	{
		playFX(level._effect["powerup_grabbed"], self.origin);
		self delete();
	}
}

/*
	Name: function_3674f451
	Namespace: namespace_30db0d4
	Checksum: 0xBD1E59AD
	Offset: 0x2F48
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function function_3674f451(player)
{
	self setcursorhint("HINT_WEAPON", self.stub.var_d2af076);
	self setHintString(&"ZOMBIE_TRADE_WEAPON_FILL");
	return 1;
}

/*
	Name: function_97f09efd
	Namespace: namespace_30db0d4
	Checksum: 0x36FD365F
	Offset: 0x2FB0
	Size: 0x33F
	Parameters: 0
	Flags: None
*/
function function_97f09efd()
{
	e_lever = struct::get("tram_call_lever_2", "targetname");
	t_use = function_a40fee2f(e_lever.origin, 60);
	t_use.hint_string = &"ZM_CASTLE_TRAM_REQUIRES_TOKEN";
	t_use.var_5be78056 = 0;
	level thread function_8f0015e0();
	while(1)
	{
		t_use waittill("trigger", e_who);
		if(namespace_cb5bc243::function_ed4d87a3(e_who))
		{
			if(isdefined(e_who.var_a1ba5103) && e_who.var_a1ba5103)
			{
				e_who.var_66e0478a++;
			}
			level.var_f0adc88a ShowPart("j_fuse_main");
			e_who PlayRumbleOnEntity("zm_castle_interact_rumble");
			playsoundatposition("vox_maxis_gondola_pa_called_0", (400, 675, 40));
			var_8643fc8a = RandomInt(100);
			if(isdefined(e_who.var_a1ba5103) && e_who.var_a1ba5103 && e_who.var_66e0478a >= 5)
			{
				level notify("hash_95a2806", e_who);
				e_who.var_a1ba5103 = undefined;
				e_who.var_66e0478a = undefined;
			}
			else
			{
				level notify("hash_b2fa2cac", e_who);
			}
			util::wait_network_frame();
			level.var_f0adc88a clientfield::increment("tram_fuse_fx");
			level flag::wait_till_any(Array("tram_docked", "player_tram_docked"));
			level.var_f0adc88a clientfield::increment("tram_fuse_destroy");
			level.var_f0adc88a HidePart("j_fuse_main");
			level flag::wait_till("tram_cooldown");
			level flag::wait_till_clear("tram_cooldown");
		}
		else if(!isdefined(level.var_f6d3c9c0) || GetTime() - level.var_f6d3c9c0 > 12000)
		{
			level.var_f6d3c9c0 = GetTime();
			e_who thread namespace_97ddfc0d::function_b6633a79();
		}
	}
}

/*
	Name: function_8f0015e0
	Namespace: namespace_30db0d4
	Checksum: 0xB0049B40
	Offset: 0x32F8
	Size: 0x2E7
	Parameters: 0
	Flags: None
*/
function function_8f0015e0()
{
	level flag::wait_till("tram_moving");
	level.var_f0adc88a thread scene::Play("p7_fxanim_zm_castle_tram_car_01_down_bundle", level.var_f0adc88a);
	level.var_f0adc88a playsound("evt_tram_lever");
	while(1)
	{
		str_result = level util::waittill_any_return("token_tram_moving", "player_tram_moving");
		if(str_result === "token_tram_moving")
		{
			level function_1ff56fb0("p7_fxanim_zm_castle_tram_car_02_up_bundle");
			level.var_f0adc88a thread scene::Play("p7_fxanim_zm_castle_tram_car_02_up_bundle", level.var_f0adc88a);
			level.var_f0adc88a playsound("evt_tram_lever");
			level flag::wait_till("tram_docked");
			level flag::wait_till("tram_moving");
			level function_1ff56fb0("p7_fxanim_zm_castle_tram_car_02_down_bundle");
			level.var_f0adc88a thread scene::Play("p7_fxanim_zm_castle_tram_car_02_down_bundle", level.var_f0adc88a);
			level.var_f0adc88a playsound("evt_tram_lever");
		}
		else if(str_result === "player_tram_moving")
		{
			level function_1ff56fb0("p7_fxanim_zm_castle_tram_car_01_up_bundle");
			level.var_f0adc88a thread scene::Play("p7_fxanim_zm_castle_tram_car_01_up_bundle", level.var_f0adc88a);
			level.var_f0adc88a playsound("evt_tram_lever");
			level flag::wait_till("player_tram_docked");
			level flag::wait_till("tram_moving");
			level function_1ff56fb0("p7_fxanim_zm_castle_tram_car_01_down_bundle");
			level.var_f0adc88a thread scene::Play("p7_fxanim_zm_castle_tram_car_01_down_bundle", level.var_f0adc88a);
			level.var_f0adc88a playsound("evt_tram_lever");
		}
	}
}

/*
	Name: function_310924ec
	Namespace: namespace_30db0d4
	Checksum: 0x445E76F7
	Offset: 0x35E8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_310924ec(a_ents)
{
	level.var_f0adc88a = a_ents["gondola_console_controls"];
	level.var_f0adc88a HidePart("j_fuse_main");
}

/*
	Name: function_19b8e1e4
	Namespace: namespace_30db0d4
	Checksum: 0x118029F3
	Offset: 0x3638
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function function_19b8e1e4(str_message, param1)
{
	self.hint_string = str_message;
	zm_unitrigger::unregister_unitrigger(self);
	zm_unitrigger::register_static_unitrigger(self, &unitrigger_think);
}

/*
	Name: function_a40fee2f
	Namespace: namespace_30db0d4
	Checksum: 0xB015D737
	Offset: 0x3698
	Size: 0xBF
	Parameters: 2
	Flags: None
*/
function function_a40fee2f(origin, radius)
{
	trigger_stub = spawnstruct();
	trigger_stub.origin = origin;
	trigger_stub.radius = radius;
	trigger_stub.cursor_hint = "HINT_NOICON";
	trigger_stub.script_unitrigger_type = "unitrigger_radius_use";
	trigger_stub.prompt_and_visibility_func = &function_5ea427bf;
	zm_unitrigger::register_static_unitrigger(trigger_stub, &unitrigger_think);
	return trigger_stub;
}

/*
	Name: function_5ea427bf
	Namespace: namespace_30db0d4
	Checksum: 0xE44AC9B9
	Offset: 0x3760
	Size: 0x291
	Parameters: 1
	Flags: None
*/
function function_5ea427bf(player)
{
	str_msg = &"";
	if(isdefined(self.stub.var_5be78056) && self.stub.var_5be78056)
	{
		cursor_hint = "HINT_WEAPON";
		cursor_hint_weapon = self.stub.var_86ffaca4;
		self setcursorhint(cursor_hint, cursor_hint_weapon);
	}
	else if(level flag::get("tram_docked") || level flag::get("player_tram_docked"))
	{
		self.stub.hint_string = &"ZM_CASTLE_TRAM_DOCKED";
		self setHintString(self.stub.hint_string);
		return 0;
	}
	else if(level flag::get("tram_moving"))
	{
		self.stub.hint_string = &"ZM_CASTLE_TRAM_MOVING";
		self setHintString(self.stub.hint_string);
		return 0;
	}
	else if(level flag::get("tram_cooldown"))
	{
		self.stub.hint_string = &"ZM_CASTLE_TRAM_COOLDOWN";
		self setHintString(self.stub.hint_string);
		return 0;
	}
	else if(namespace_cb5bc243::function_83ef471e(player))
	{
		self.stub.hint_string = &"ZM_CASTLE_TRAM_CALL";
		self setHintString(self.stub.hint_string);
		return 1;
	}
	else
	{
		self.stub.hint_string = &"ZM_CASTLE_TRAM_REQUIRES_TOKEN";
		self setHintString(self.stub.hint_string);
		return 1;
	}
}

/*
	Name: unitrigger_think
	Namespace: namespace_30db0d4
	Checksum: 0x64AC4252
	Offset: 0x3A00
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function unitrigger_think()
{
	self endon("kill_trigger");
	self.stub thread function_c1947ff7();
	while(1)
	{
		self waittill("trigger", var_4161ad80);
		self.stub notify("trigger", var_4161ad80);
	}
}

/*
	Name: function_c1947ff7
	Namespace: namespace_30db0d4
	Checksum: 0xF7F2E08A
	Offset: 0x3A68
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function function_c1947ff7()
{
	self zm_unitrigger::run_visibility_function_for_all_triggers();
}

/*
	Name: function_ccc738b1
	Namespace: namespace_30db0d4
	Checksum: 0x99EC1590
	Offset: 0x3A90
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_ccc738b1()
{
}

/*
	Name: function_ce881a6
	Namespace: namespace_30db0d4
	Checksum: 0xE72EB04
	Offset: 0x3AA0
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function function_ce881a6()
{
	self.sndent = spawn("script_origin", self.origin);
	self.sndent LinkTo(self);
	self.sndent PlayLoopSound("evt_tram_track");
	level waittill("hash_a9fe9747");
	if(isdefined(self.sndent))
	{
		self.sndent StopLoopSound(2);
	}
	wait(1);
	if(isdefined(self.sndent))
	{
		self.sndent delete();
	}
}

/*
	Name: function_ccd0cc8e
	Namespace: namespace_30db0d4
	Checksum: 0x7D9A7F1C
	Offset: 0x3B78
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_ccd0cc8e()
{
	wait(5.4);
	playsoundatposition("vox_maxis_gondola_pa_arriving_0", (400, 675, 40));
}

/*
	Name: function_57f998e3
	Namespace: namespace_30db0d4
	Checksum: 0xDE0C8DEF
	Offset: 0x3BB8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_57f998e3()
{
	/#
		level waittill("start_zombie_round_logic");
		wait(1);
		zm_devgui::function_4acecab5(&function_72d0fbe3);
	#/
}

/*
	Name: function_72d0fbe3
	Namespace: namespace_30db0d4
	Checksum: 0xF9C64D44
	Offset: 0x3C00
	Size: 0xC5
	Parameters: 1
	Flags: None
*/
function function_72d0fbe3(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				foreach(e_player in level.activePlayers)
				{
					e_player.var_a1ba5103 = 1;
					e_player.var_66e0478a = 5;
				}
				break;
			}
		}
	#/
}

