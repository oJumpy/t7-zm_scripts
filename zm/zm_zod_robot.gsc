#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\name_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_zod_train;
#using scripts\zm\zm_zod_vo;

#namespace namespace_2cce1885;

/*
	Name: __init__sytem__
	Namespace: namespace_2cce1885
	Checksum: 0xD19E6E35
	Offset: 0x6E8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_robot", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_2cce1885
	Checksum: 0x8E4FFC
	Offset: 0x728
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "robot_switch", 1, 1, "int");
	clientfield::register("world", "robot_lights", 1, 2, "int");
}

/*
	Name: init
	Namespace: namespace_2cce1885
	Checksum: 0xD397FBB1
	Offset: 0x798
	Size: 0x273
	Parameters: 0
	Flags: None
*/
function init()
{
	level flag::init("police_box_ready");
	level flag::init("police_box_in_use");
	level flag::init("police_box_hide");
	level.var_47ef623d = 2000;
	level flag::wait_till("initial_blackscreen_passed");
	zombie_utility::add_zombie_gib_weapon_callback("ar_standard_companion", &function_906dfe04, &function_9e3debe7);
	level.var_2b602c66 = GetEntArray("zombie_robot_spawner", "script_noteworthy");
	level.var_c1b7d765 = GetEntArray("zombie_robot_gold_spawner", "script_noteworthy");
	a_e_triggers = GetEntArray("robot_activate_trig", "targetname");
	level.var_1181e09b = Array("junction", "slums", "canal", "theater");
	foreach(var_d42f02cf in level.var_1181e09b)
	{
		function_d6bdaaa4(var_d42f02cf, &function_1ad591a3, &function_58485745);
	}
	level thread function_b80bbad2();
	level thread function_63fe1ddd();
	level thread function_cc935dda();
	/#
		level thread function_33a20979();
	#/
}

/*
	Name: function_63fe1ddd
	Namespace: namespace_2cce1885
	Checksum: 0xF6BCACA
	Offset: 0xA18
	Size: 0xCF
	Parameters: 0
	Flags: None
*/
function function_63fe1ddd()
{
	level endon("_zombie_game_over");
	level flag::wait_till("police_box_ready");
	while(1)
	{
		level clientfield::set("robot_lights", 1);
		level waittill("hash_421e5b59");
		level clientfield::set("robot_lights", 2);
		level waittill("hash_10a36fa2");
		level clientfield::set("robot_lights", 3);
		while(isdefined(level.var_f6c5842))
		{
			wait(0.05);
		}
	}
}

/*
	Name: function_b80bbad2
	Namespace: namespace_2cce1885
	Checksum: 0xFEA27E6A
	Offset: 0xAF0
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function function_b80bbad2()
{
	level waittill("hash_5b9acfd8");
	level flag::set("police_box_ready");
	var_6f73bd35 = GetEnt("police_box", "targetname");
	if(isdefined(var_6f73bd35))
	{
		var_6f73bd35 playsound("zmb_bm_interaction_machine_start");
	}
	e_player = zm_utility::get_closest_player(var_6f73bd35.origin);
	e_player namespace_b8707f8e::function_81ba60e2();
	var_6f73bd35 clientfield::set("robot_switch", 1);
}

/*
	Name: function_33a20979
	Namespace: namespace_2cce1885
	Checksum: 0xA319764B
	Offset: 0xBD8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_33a20979()
{
	/#
		level waittill("open_sesame");
		level flag::set("Dev Block strings are not supported");
	#/
}

/*
	Name: function_d6bdaaa4
	Namespace: namespace_2cce1885
	Checksum: 0x7D576DF
	Offset: 0xC18
	Size: 0x1EB
	Parameters: 3
	Flags: None
*/
function function_d6bdaaa4(var_d42f02cf, var_175bc9b5, var_5a170a81)
{
	width = 110;
	height = 90;
	length = 110;
	var_9ff0b626 = struct::get("robot_callbox_" + var_d42f02cf, "script_noteworthy");
	var_9ff0b626.unitrigger_stub = spawnstruct();
	var_9ff0b626.unitrigger_stub.origin = var_9ff0b626.origin;
	var_9ff0b626.unitrigger_stub.angles = var_9ff0b626.angles;
	var_9ff0b626.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	var_9ff0b626.unitrigger_stub.cursor_hint = "HINT_NOICON";
	var_9ff0b626.unitrigger_stub.script_width = width;
	var_9ff0b626.unitrigger_stub.script_height = height;
	var_9ff0b626.unitrigger_stub.script_length = length;
	var_9ff0b626.unitrigger_stub.require_look_at = 0;
	var_9ff0b626.unitrigger_stub.var_d42f02cf = var_d42f02cf;
	var_9ff0b626.unitrigger_stub.prompt_and_visibility_func = var_175bc9b5;
	zm_unitrigger::register_static_unitrigger(var_9ff0b626.unitrigger_stub, var_5a170a81);
}

/*
	Name: function_1ad591a3
	Namespace: namespace_2cce1885
	Checksum: 0x2F2DB86E
	Offset: 0xE10
	Size: 0x1C9
	Parameters: 1
	Flags: None
*/
function function_1ad591a3(player)
{
	b_is_invis = isdefined(player.beastmode) && player.beastmode || level flag::get("police_box_hide");
	self SetInvisibleToPlayer(player, b_is_invis);
	if(!level flag::get("police_box_ready"))
	{
		self setHintString(&"ZM_ZOD_ROBOT_NEEDS_POWER");
	}
	else if(isdefined(level.var_f6c5842))
	{
		switch(level.var_1ae05c2e)
		{
			case "junction":
			{
				var_554cba06 = &"ZM_ZOD_AREA_NAME_JUNCTION";
				break;
			}
			case "slums":
			{
				var_554cba06 = &"ZM_ZOD_AREA_NAME_SLUMS";
				break;
			}
			case "canal":
			{
				var_554cba06 = &"ZM_ZOD_AREA_NAME_CANAL";
				break;
			}
			case "theater":
			{
				var_554cba06 = &"ZM_ZOD_AREA_NAME_THEATER";
				break;
			}
		}
		self setHintString(&"ZM_ZOD_ROBOT_ONCALL_IN", var_554cba06);
	}
	else if(player.score < level.var_47ef623d)
	{
		self setHintString(&"ZM_ZOD_ROBOT_PAY_TOWARDS");
	}
	else
	{
		self setHintString(&"ZM_ZOD_ROBOT_SUMMON");
	}
	return !b_is_invis;
}

/*
	Name: function_58485745
	Namespace: namespace_2cce1885
	Checksum: 0x4F19BDDA
	Offset: 0xFE8
	Size: 0x2C7
	Parameters: 0
	Flags: None
*/
function function_58485745()
{
	while(1)
	{
		self waittill("trigger", player);
		if(player zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(player.IS_DRINKING > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(player))
		{
			continue;
		}
		if(isdefined(level.var_f6c5842))
		{
			continue;
		}
		if(level flag::get("police_box_ready") !== 1)
		{
			continue;
		}
		if(level flag::get("police_box_in_use"))
		{
			continue;
		}
		if(!player zm_score::can_player_purchase(level.var_47ef623d))
		{
			level.var_47ef623d = level.var_47ef623d - player.score;
			player zm_score::minus_to_player_score(player.score);
			self.stub zm_unitrigger::run_visibility_function_for_all_triggers();
			level thread function_cc935dda();
		}
		else
		{
			level flag::set("police_box_in_use");
			self setHintString("");
			player zm_score::minus_to_player_score(level.var_47ef623d);
			if(!player bgb::is_enabled("zm_bgb_shopping_free"))
			{
				level.var_47ef623d = 0;
				level thread function_cc935dda();
			}
			n_spawn_delay = 3;
			level thread function_99d41d5f(player, self.stub, n_spawn_delay);
			player notify("hash_b7f8e77c");
			level notify("hash_421e5b59");
			level thread function_f9a6039c(self, "activated");
			self playsound("evt_police_box_siren");
			wait(1.5);
			player zm_audio::create_and_play_dialog("robot", "activate");
		}
	}
}

/*
	Name: function_99d41d5f
	Namespace: namespace_2cce1885
	Checksum: 0x2DF3CEE5
	Offset: 0x12B8
	Size: 0x66B
	Parameters: 3
	Flags: None
*/
function function_99d41d5f(player, trig_stub, n_spawn_delay)
{
	var_7a54d4da = struct::get_array("robot_start_pos", "targetname");
	var_7a54d4da = Array::filter(var_7a54d4da, 0, &function_b16968ad, trig_stub.var_d42f02cf);
	var_b410e4d9 = var_7a54d4da[0];
	trace = bullettrace(var_b410e4d9.origin, var_b410e4d9.origin + VectorScale((0, 0, -1), 256), 0, var_b410e4d9);
	v_ground_position = trace["position"];
	var_36e9b69a = v_ground_position + VectorScale((0, 0, 1), 650);
	level thread function_70541dc1(v_ground_position);
	if(isdefined(n_spawn_delay))
	{
		wait(n_spawn_delay);
	}
	if(level flag::get("ee_complete"))
	{
		spawner = level.var_c1b7d765[0];
	}
	else
	{
		spawner = level.var_2b602c66[0];
	}
	level.var_f6c5842 = spawner SpawnFromSpawner("companion_spawner", 1);
	level.var_f6c5842.maxhealth = level.var_f6c5842.health;
	level.var_f6c5842.allow_zombie_to_target_ai = 0;
	level.var_f6c5842.on_train = 0;
	level.var_f6c5842.can_gib_zombies = 1;
	level.var_f6c5842 SetCanDamage(0);
	level.var_1ae05c2e = trig_stub.var_d42f02cf;
	trig_stub zm_unitrigger::run_visibility_function_for_all_triggers();
	level.var_f6c5842.var_af6a29a8 = 0;
	level.var_f6c5842 PlayLoopSound("fly_civil_protector_loop");
	level.var_bfd9ed83 = player;
	foreach(player in level.players)
	{
		player setPerk("specialty_pistoldeath");
	}
	if(isdefined(level.var_f6c5842))
	{
		level.var_f6c5842 ForceTeleport(var_36e9b69a);
		level.var_f6c5842 thread function_ab4d9ece(v_ground_position, player);
		level.var_f6c5842 scene::Play("cin_zod_robot_companion_entrance");
		level notify("hash_10a36fa2");
		level.var_f6c5842.var_173c72a4 = v_ground_position;
	}
	level thread function_f9a6039c(level.var_f6c5842, "active", 2);
	level.var_f6c5842 thread function_be60a9fd();
	level.var_f6c5842 thread function_677061ac();
	level flag::clear("police_box_in_use");
	function_490cbdf5();
	level.var_f6c5842.var_af6a29a8 = 1;
	while(level.var_f6c5842.var_a25cf4c9 == 1)
	{
		wait(0.05);
	}
	foreach(player in level.players)
	{
		player unsetPerk("specialty_pistoldeath");
	}
	level.var_f6c5842 SetCanDamage(1);
	if(isdefined(level.o_zod_train))
	{
		if(function_406e4ba9(level.o_zod_train))
		{
			level.var_f6c5842 LinkTo(function_8cf8e3a5());
		}
	}
	level.var_f6c5842 scene::Play("cin_zod_robot_companion_exit_death");
	level.var_f6c5842 = undefined;
	players = GetPlayers();
	if(players.size != 1 || !level flag::get("solo_game") || (!isdefined(players[0].waiting_to_revive) && players[0].waiting_to_revive))
	{
		level zm::checkForAllDead();
	}
	level.var_47ef623d = 2000;
	trig_stub zm_unitrigger::run_visibility_function_for_all_triggers();
	level thread function_cc935dda();
}

/*
	Name: function_490cbdf5
	Namespace: namespace_2cce1885
	Checksum: 0x53AB88BA
	Offset: 0x1930
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function function_490cbdf5()
{
	level endon("hash_223edfde");
	wait(120);
}

/*
	Name: function_ab4d9ece
	Namespace: namespace_2cce1885
	Checksum: 0x6967B721
	Offset: 0x1950
	Size: 0x175
	Parameters: 2
	Flags: None
*/
function function_ab4d9ece(var_21e230b7, e_player)
{
	level.var_f6c5842 thread function_32ce0dec();
	wait(0.5);
	Earthquake(0.55, 1.2, var_21e230b7, 1200);
	playFX(level._effect["robot_landing"], var_21e230b7);
	level thread function_fa1df614(var_21e230b7, undefined, 350);
	var_329d5820 = 5;
	for(i = 0; i < var_329d5820; i++)
	{
		foreach(player in level.players)
		{
			player PlayRumbleOnEntity("damage_heavy");
		}
		wait(0.1);
	}
}

/*
	Name: function_32ce0dec
	Namespace: namespace_2cce1885
	Checksum: 0x89C3793
	Offset: 0x1AD0
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function function_32ce0dec()
{
	var_8d888091 = spawn("script_model", self.origin);
	var_8d888091 SetModel("tag_origin");
	PlayFXOnTag(level._effect["robot_sky_trail"], var_8d888091, "tag_origin");
	var_8d888091 LinkTo(self);
	level waittill("hash_10a36fa2");
	var_8d888091 delete();
}

/*
	Name: function_70541dc1
	Namespace: namespace_2cce1885
	Checksum: 0xF29419BF
	Offset: 0x1B90
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function function_70541dc1(v_ground_position)
{
	var_b47822ca = spawn("script_model", v_ground_position);
	var_b47822ca SetModel("tag_origin");
	PlayFXOnTag(level._effect["robot_ground_spawn"], var_b47822ca, "tag_origin");
	level waittill("hash_10a36fa2");
	var_b47822ca delete();
}

/*
	Name: function_fa1df614
	Namespace: namespace_2cce1885
	Checksum: 0xDEFD340F
	Offset: 0x1C40
	Size: 0x2B9
	Parameters: 3
	Flags: None
*/
function function_fa1df614(v_origin, eAttacker, n_radius)
{
	team = "axis";
	if(isdefined(level.zombie_team))
	{
		team = level.zombie_team;
	}
	a_ai_zombies = Array::get_all_closest(v_origin, GetAITeamArray(team), undefined, undefined, n_radius);
	foreach(ai_zombie in a_ai_zombies)
	{
		if(isdefined(eAttacker))
		{
			ai_zombie DoDamage(ai_zombie.health + 10000, ai_zombie.origin, eAttacker);
		}
		else
		{
			ai_zombie DoDamage(ai_zombie.health + 10000, ai_zombie.origin);
		}
		n_radius_sqr = n_radius * n_radius;
		n_distance_sqr = DistanceSquared(ai_zombie.origin, v_origin);
		n_dist_mult = n_distance_sqr / n_radius_sqr;
		v_fling = ai_zombie.origin - v_origin;
		v_fling = v_fling + VectorScale((0, 0, 1), 15);
		v_fling = VectorNormalize(v_fling);
		n_size = 50 + 20 * n_dist_mult;
		v_fling = (v_fling[0], v_fling[1], Abs(v_fling[2]));
		v_fling = VectorScale(v_fling, n_size);
		ai_zombie StartRagdoll();
		ai_zombie LaunchRagdoll(v_fling);
	}
}

/*
	Name: function_b16968ad
	Namespace: namespace_2cce1885
	Checksum: 0xC9B003F5
	Offset: 0x1F08
	Size: 0x47
	Parameters: 2
	Flags: None
*/
function function_b16968ad(e_entity, var_d42f02cf)
{
	if(!isdefined(e_entity.script_string) || e_entity.script_string != var_d42f02cf)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_cc935dda
	Namespace: namespace_2cce1885
	Checksum: 0x80F9912B
	Offset: 0x1F58
	Size: 0xB1
	Parameters: 0
	Flags: None
*/
function function_cc935dda()
{
	var_43d4ba3a = GetEntArray("robot_readout_model", "targetname");
	foreach(var_f638c7bb in var_43d4ba3a)
	{
		var_f638c7bb function_fcc9dd();
	}
}

/*
	Name: function_fcc9dd
	Namespace: namespace_2cce1885
	Checksum: 0x15FF3F96
	Offset: 0x2018
	Size: 0xDD
	Parameters: 0
	Flags: None
*/
function function_fcc9dd()
{
	var_bfdb622 = function_e122ede6(level.var_47ef623d);
	for(i = 0; i < 4; i++)
	{
		for(j = 0; j < 10; j++)
		{
			self HidePart("J_" + i + "_" + j);
		}
		self ShowPart("J_" + i + "_" + var_bfdb622[i]);
	}
}

/*
	Name: function_e122ede6
	Namespace: namespace_2cce1885
	Checksum: 0x425271C4
	Offset: 0x2100
	Size: 0xB7
	Parameters: 1
	Flags: None
*/
function function_e122ede6(var_852832cf)
{
	var_c6f3ff8a = [];
	for(i = 0; i < 4; i++)
	{
		var_75e21c4d = pow(10, 3 - i);
		var_c6f3ff8a[i] = floor(var_852832cf / var_75e21c4d);
		var_852832cf = var_852832cf - var_c6f3ff8a[i] * var_75e21c4d;
	}
	return var_c6f3ff8a;
}

/*
	Name: function_9e3debe7
	Namespace: namespace_2cce1885
	Checksum: 0x29201CF4
	Offset: 0x21C0
	Size: 0x61
	Parameters: 1
	Flags: Private
*/
function private function_9e3debe7(DAMAGE_LOCATION)
{
	if(!isdefined(DAMAGE_LOCATION))
	{
		return 0;
	}
	switch(DAMAGE_LOCATION)
	{
		case "head":
		{
			return 1;
		}
		case "helmet":
		{
			return 1;
		}
		case "neck":
		{
			return 1;
		}
		case default:
		{
			return 0;
		}
	}
}

/*
	Name: function_906dfe04
	Namespace: namespace_2cce1885
	Checksum: 0x94F9E
	Offset: 0x2230
	Size: 0xF
	Parameters: 1
	Flags: Private
*/
function private function_906dfe04(damage_percent)
{
	return 1;
}

/*
	Name: function_f9a6039c
	Namespace: namespace_2cce1885
	Checksum: 0xA205695C
	Offset: 0x2248
	Size: 0x14B
	Parameters: 3
	Flags: None
*/
function function_f9a6039c(entity, suffix, delay)
{
	entity endon("death");
	entity endon("disconnect");
	alias = "vox_crbt_robot_" + suffix;
	num_variants = zm_spawner::get_number_variants(alias);
	if(num_variants <= 0)
	{
		return;
	}
	var_4dc11cc = randomIntRange(0, num_variants + 1);
	if(isdefined(delay))
	{
		wait(delay);
	}
	if(isdefined(entity) && (!isdefined(entity.is_speaking) && entity.is_speaking))
	{
		entity.is_speaking = 1;
		entity PlaySoundWithNotify(alias + "_" + var_4dc11cc, "sndDone");
		entity waittill("hash_b6f7c8d2");
		entity.is_speaking = 0;
	}
}

/*
	Name: function_be60a9fd
	Namespace: namespace_2cce1885
	Checksum: 0x95DCD2BC
	Offset: 0x23A0
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function function_be60a9fd()
{
	self endon("death");
	self endon("disconnect");
	while(1)
	{
		self waittill("killed", who);
		if(randomIntRange(0, 101) <= 30)
		{
			level thread function_f9a6039c(level.var_f6c5842, "kills");
		}
	}
}

/*
	Name: function_677061ac
	Namespace: namespace_2cce1885
	Checksum: 0x26415BA4
	Offset: 0x2430
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function function_677061ac()
{
	self endon("death");
	self endon("disconnect");
	while(1)
	{
		wait(randomIntRange(15, 25));
		level thread function_f9a6039c(level.var_f6c5842, "active");
	}
}

