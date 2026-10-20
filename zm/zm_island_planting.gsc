#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\archetype_thrasher;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_attackables;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perk_random;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_powerup_island_seed;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_keeper_skull;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_island_main_ee_quest;
#using scripts\zm\zm_island_power;
#using scripts\zm\zm_island_skullweapon_quest;
#using scripts\zm\zm_island_takeo_fight;
#using scripts\zm\zm_island_util;
#using scripts\zm\zm_island_vo;

#namespace namespace_7550a904;

/*
	Name: main
	Namespace: namespace_7550a904
	Checksum: 0x3D1054A9
	Offset: 0x19E0
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function main()
{
	register_clientfields();
	level.bonus_points_powerup_override = &function_bb96e04a;
	level thread init_planting_spots();
	function_54af12e9();
	function_72298dfd();
	init_babysitter_plant();
	init_trap_plant();
	function_869faee7();
	function_1b391116();
	/#
		function_e851ad39();
	#/
}

/*
	Name: register_clientfields
	Namespace: namespace_7550a904
	Checksum: 0xD52190CC
	Offset: 0x1AA8
	Size: 0x213
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("scriptmover", "plant_growth_siege_anims", 9000, 2, "int");
	clientfield::register("scriptmover", "cache_plant_interact_fx", 9000, 1, "int");
	clientfield::register("scriptmover", "plant_hit_with_ww_fx", 9000, 1, "int");
	clientfield::register("scriptmover", "plant_watered_fx", 9000, 1, "int");
	clientfield::register("scriptmover", "planter_model_watered", 9000, 1, "int");
	clientfield::register("scriptmover", "babysitter_plant_fx", 9000, 1, "int");
	clientfield::register("scriptmover", "trap_plant_fx", 9000, 1, "int");
	clientfield::register("toplayer", "player_spawned_from_clone_plant", 9000, 1, "int");
	clientfield::register("toplayer", "player_cloned_fx", 9000, 1, "int");
	clientfield::register("scriptmover", "zombie_or_grenade_spawned_from_minor_cache_plant", 9000, 2, "int");
	clientfield::register("allplayers", "player_vomit_fx", 9000, 1, "int");
}

/*
	Name: function_bb96e04a
	Namespace: namespace_7550a904
	Checksum: 0xB8F0B392
	Offset: 0x1CC8
	Size: 0x7
	Parameters: 0
	Flags: None
*/
function function_bb96e04a()
{
	return 500;
}

/*
	Name: init_planting_spots
	Namespace: namespace_7550a904
	Checksum: 0x37E9701C
	Offset: 0x1CD8
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function init_planting_spots()
{
	a_s_planting_spots = struct::get_array("planting_spot", "targetname");
	foreach(s_planting_spot in a_s_planting_spots)
	{
		s_planting_spot function_fedc998b();
	}
	level.a_s_planting_spots = a_s_planting_spots;
}

/*
	Name: function_fedc998b
	Namespace: namespace_7550a904
	Checksum: 0x4E2CAA31
	Offset: 0x1DA0
	Size: 0x2AB
	Parameters: 1
	Flags: None
*/
function function_fedc998b(var_e7abf7d0)
{
	if(!isdefined(var_e7abf7d0))
	{
		var_e7abf7d0 = 0;
	}
	if(var_e7abf7d0 == 0)
	{
		self.model = util::spawn_model("p7_zm_isl_plant_planter", self.origin, self.angles);
	}
	s_plant_unitrigger = spawnstruct();
	s_plant_unitrigger.origin = self.origin + VectorScale((0, 0, 1), 8);
	s_plant_unitrigger.angles = self.angles;
	s_plant_unitrigger.s_parent = self;
	s_plant_unitrigger.script_unitrigger_type = "unitrigger_box_use";
	s_plant_unitrigger.cursor_hint = "HINT_NOICON";
	s_plant_unitrigger.require_look_at = 0;
	s_plant_unitrigger.script_width = 100;
	s_plant_unitrigger.script_length = 100;
	s_plant_unitrigger.script_height = 150;
	s_plant_unitrigger.prompt_and_visibility_func = &planting_spot_trigger_visibility;
	zm_unitrigger::register_static_unitrigger(s_plant_unitrigger, &planting_spot_unitrigger_think);
	self.s_plant_unitrigger = s_plant_unitrigger;
	self.b_seed_planted = 0;
	self.var_594609f9 = 0;
	self.var_e7abf7d0 = var_e7abf7d0;
	self.s_plant = spawnstruct();
	self.s_plant.model = util::spawn_model("tag_origin", self.origin, self.angles);
	self.s_plant.a_water = [];
	self.s_plant.var_49d71b32 = 0;
	self.s_plant.var_198c12a1 = 0;
	self.s_plant.var_8d8becb0 = 0;
	self.s_plant.var_5a41bc99 = 0;
	self.s_plant.b_watered = 0;
	self.s_plant flag::init("plant_interact_trigger_used");
	self thread planting_spot_think(undefined, self.var_e7abf7d0);
}

/*
	Name: planting_spot_trigger_visibility
	Namespace: namespace_7550a904
	Checksum: 0x12F40F01
	Offset: 0x2058
	Size: 0x2BF
	Parameters: 1
	Flags: None
*/
function planting_spot_trigger_visibility(e_player)
{
	if(e_player zm_utility::in_revive_trigger())
	{
		self setHintString(&"");
		return 0;
	}
	if(e_player.IS_DRINKING > 0)
	{
		self setHintString(&"");
		return 0;
	}
	if(!zm_utility::is_player_valid(e_player))
	{
		self setHintString(&"");
		return 0;
	}
	if(self.stub.s_parent.s_plant.var_198c12a1 == 1)
	{
		self setHintString(&"");
		return 0;
	}
	if(self.stub.s_parent.b_seed_planted == 0)
	{
		if(e_player clientfield::get_to_player("has_island_seed"))
		{
			self setHintString(&"ZM_ISLAND_PLANT_SEED");
			return 1;
		}
		else
		{
			self setHintString(&"");
			return 0;
		}
	}
	else if(self.stub.s_parent.var_594609f9 == 0 && self.stub.s_parent.s_plant.b_watered == 0 && self.stub.s_parent.s_plant.var_5a41bc99 == 0 && self.stub.s_parent.var_e7abf7d0 == 0)
	{
		if(isdefined(e_player.var_6fd3d65c) && e_player.var_6fd3d65c && e_player.var_bb2fd41c > 0)
		{
			self setHintString(&"ZM_ISLAND_WATER_PLANT");
			return 1;
		}
		else
		{
			self setHintString(&"");
			return 0;
		}
	}
	else
	{
		self setHintString(&"");
		return 0;
	}
}

/*
	Name: planting_spot_unitrigger_think
	Namespace: namespace_7550a904
	Checksum: 0x4505A040
	Offset: 0x2320
	Size: 0x1C7
	Parameters: 0
	Flags: None
*/
function planting_spot_unitrigger_think()
{
	while(1)
	{
		self waittill("trigger", e_who);
		if(e_who zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(e_who.IS_DRINKING > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(e_who))
		{
			continue;
		}
		if(self.stub.s_parent.b_seed_planted == 0)
		{
			if(e_who clientfield::get_to_player("has_island_seed"))
			{
				self.stub.s_parent notify("hash_fa482f7", e_who);
			}
		}
		else if(self.stub.s_parent.s_plant.b_watered == 0 && self.stub.s_parent.s_plant.var_5a41bc99 == 0 && self.stub.s_parent.var_e7abf7d0 == 0)
		{
			if(isdefined(e_who.var_6fd3d65c) && e_who.var_6fd3d65c && isdefined(e_who.var_bb2fd41c) && e_who.var_bb2fd41c > 0 && isdefined(e_who.var_c6cad973))
			{
				self.stub.s_parent notify("hash_8626f7f1", e_who);
			}
		}
	}
}

/*
	Name: planting_spot_think
	Namespace: namespace_7550a904
	Checksum: 0x1889DA28
	Offset: 0x24F0
	Size: 0x257
	Parameters: 3
	Flags: None
*/
function planting_spot_think(var_9636d237, var_f40460f5, var_895cb900)
{
	if(!isdefined(var_895cb900))
	{
		var_895cb900 = 0;
	}
	self endon("hash_378095a2");
	self endon("hash_7a0cef7b");
	while(1)
	{
		if(!isdefined(var_9636d237) && !var_895cb900)
		{
			self waittill("hash_fa482f7", e_who);
			if(!e_who clientfield::get_to_player("has_island_seed"))
			{
				continue;
			}
			self.var_561a9c48 = e_who;
			level thread zm_powerup_island_seed::function_58b6724f(e_who);
			e_who playsound("evt_island_seed_plant");
			e_who zm_island_vo::function_7f4cb4c("plant", "seed", 1);
		}
		else
		{
			self.var_561a9c48 = level.activePlayers[0];
		}
		self.b_seed_planted = 1;
		self.s_plant.var_198c12a1 = 1;
		self thread function_18d2ce8b();
		self thread function_447658c7(var_9636d237, var_f40460f5);
		self thread function_4357491f();
		self waittill("hash_98cf252f");
		if(isdefined(var_f40460f5) && var_f40460f5)
		{
			wait(2);
		}
		else if(!isdefined(var_9636d237))
		{
			level waittill("end_of_round");
		}
		self scene::Play("p7_fxanim_zm_island_plant_dead_bundle", self.s_plant.model);
		self.s_plant.model ghost();
		self.b_seed_planted = 0;
		self.var_561a9c48 = undefined;
		if(isdefined(var_9636d237))
		{
			var_9636d237 = undefined;
		}
	}
}

/*
	Name: function_18d2ce8b
	Namespace: namespace_7550a904
	Checksum: 0xE64543F7
	Offset: 0x2750
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function function_18d2ce8b()
{
	wait(1);
	self.s_plant.var_198c12a1 = 0;
}

/*
	Name: function_447658c7
	Namespace: namespace_7550a904
	Checksum: 0x4C21D68F
	Offset: 0x2778
	Size: 0x637
	Parameters: 2
	Flags: None
*/
function function_447658c7(var_9636d237, var_f40460f5)
{
	if(!isdefined(var_9636d237))
	{
		self thread function_ffa65395(var_f40460f5);
		self thread function_5026698c(var_f40460f5);
		self.s_plant.var_8d8becb0 = 0;
		self.s_plant.var_5a41bc99 = 0;
		for(n_round = 0; n_round < 3; n_round++)
		{
			switch(n_round)
			{
				case 0:
				{
					self.s_plant.model SetModel("p7_fxanim_zm_island_plant_seed_mod");
					self.s_plant.model show();
					self.s_plant.model notsolid();
					self scene::init("p7_fxanim_zm_island_plant_stage1_bundle", self.s_plant.model);
					self.s_plant.model playsound("evt_island_seed_grow_stage_1");
					break;
				}
				case 1:
				{
					self.s_plant.model clientfield::set("plant_growth_siege_anims", 1);
					self scene::Play("p7_fxanim_zm_island_plant_stage1_bundle", self.s_plant.model);
					self.s_plant.model playsound("evt_island_seed_grow_stage_2");
					break;
				}
				case 2:
				{
					self.s_plant.model solid();
					self.s_plant.model disconnectpaths();
					self.s_plant.model clientfield::set("plant_growth_siege_anims", 2);
					self scene::Play("p7_fxanim_zm_island_plant_stage2_bundle", self.s_plant.model);
					self.s_plant.model playsound("evt_island_seed_grow_stage_3");
					self thread function_4357491f();
					break;
				}
				case default:
				{
					break;
				}
			}
			if(isdefined(var_f40460f5) && var_f40460f5)
			{
				wait(2);
				self notify("hash_67f478bd");
				continue;
			}
			if(self.s_plant.var_5a41bc99 == 1)
			{
				util::wait_network_frame();
				continue;
				continue;
			}
			level waittill("end_of_round");
			if(isdefined(self.s_plant.var_8d8becb0) && self.s_plant.var_8d8becb0)
			{
				self.s_plant.var_8d8becb0 = 0;
				continue;
			}
			self notify("hash_70cb3a5f");
			self.s_plant.var_5a41bc99 = 1;
		}
	}
	else if(isdefined(var_f40460f5) && var_f40460f5)
	{
		self.s_plant.model clientfield::set("plant_hit_with_ww_fx", 0);
	}
	self.s_plant.model clientfield::set("plant_growth_siege_anims", 3);
	self thread scene::Play("p7_fxanim_zm_island_plant_stage3_bundle", self.s_plant.model);
	self.s_plant.model waittill("hash_116e737b");
	self.var_594609f9 = 1;
	self.s_plant.model clientfield::set("plant_hit_with_ww_fx", 0);
	self.s_plant.model clientfield::set("plant_watered_fx", 0);
	/#
		println("Dev Block strings are not supported");
	#/
	self function_26651461(self.s_plant.a_water, self.s_plant.var_49d71b32, var_9636d237, var_f40460f5);
	self.s_plant.model clientfield::set("cache_plant_interact_fx", 0);
	if(!isdefined(var_9636d237))
	{
		self.s_plant.model SetModel("p7_fxanim_zm_island_plant_dead_mod");
		self scene::init("p7_fxanim_zm_island_plant_dead_bundle", self.s_plant.model);
	}
	self.s_plant.model notsolid();
	self.s_plant.model connectpaths();
	self notify("hash_98cf252f");
	self.var_594609f9 = 0;
	self.s_plant.a_water = [];
}

/*
	Name: function_49a83594
	Namespace: namespace_7550a904
	Checksum: 0xD576862B
	Offset: 0x2DB8
	Size: 0x22B
	Parameters: 0
	Flags: None
*/
function function_49a83594()
{
	self endon("hash_98cf252f");
	var_793f092a = 5;
	var_2bbd3ff9 = 40;
	t_kill = spawn("trigger_radius", self.origin + VectorScale((0, 0, 1), 50), 0, var_793f092a, var_2bbd3ff9);
	self thread function_b88d99d(t_kill);
	while(1)
	{
		foreach(player in level.activePlayers)
		{
			if(player istouching(t_kill) && zm_utility::is_player_valid(player))
			{
				wait(2);
				if(player istouching(t_kill) && zm_utility::is_player_valid(player))
				{
					v_moveto = undefined;
					while(!isdefined(v_moveto))
					{
						v_moveto = GetClosestPointOnNavMesh(self.origin, 64);
						wait(0.05);
					}
					player playlocalsound(level.zmb_laugh_alias);
					player SetOrigin(v_moveto);
					player DoDamage(player.health, self.origin);
				}
			}
		}
		wait(2);
	}
}

/*
	Name: function_b88d99d
	Namespace: namespace_7550a904
	Checksum: 0xDB15FE35
	Offset: 0x2FF0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_b88d99d(t_kill)
{
	self waittill("hash_98cf252f");
	t_kill delete();
}

/*
	Name: function_4357491f
	Namespace: namespace_7550a904
	Checksum: 0x5AD4E8BA
	Offset: 0x3028
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_4357491f()
{
	mdl_clip = spawncollision("collision_player_cylinder_32x256", "collider", self.origin + VectorScale((0, 0, 1), 125), (0, 0, 0));
	self waittill("hash_98cf252f");
	mdl_clip delete();
}

/*
	Name: function_ffa65395
	Namespace: namespace_7550a904
	Checksum: 0x107FF683
	Offset: 0x30A8
	Size: 0x36D
	Parameters: 1
	Flags: None
*/
function function_ffa65395(var_f40460f5)
{
	self endon("hash_70cb3a5f");
	if(isdefined(var_f40460f5) && var_f40460f5)
	{
		return;
	}
	self.s_plant.a_water = [];
	self.s_plant.var_2a1e031c = [];
	wait(1);
	for(n_round = 0; n_round < 3; n_round++)
	{
		self.s_plant.b_watered = 0;
		self waittill("hash_8626f7f1", User);
		/#
			if(isdefined(User.playerNum))
			{
				println("Dev Block strings are not supported" + User.playerNum + "Dev Block strings are not supported" + User.var_c6cad973);
			}
		#/
		self.s_plant.b_watered = 1;
		User notify("update_challenge_1_3");
		User playsound("evt_island_seed_water");
		if(!isdefined(User.var_f6130406))
		{
			User.var_f6130406 = 1;
			User notify("player_watered_plant");
		}
		else
		{
			n_rand = randomIntRange(1, 101);
			if(n_rand <= 20)
			{
				User notify("player_watered_plant");
			}
		}
		self.s_plant.a_water[self.s_plant.a_water.size] = User.var_c6cad973;
		User thread namespace_f3e3de78::function_a84a1aec();
		Array::add(self.s_plant.var_2a1e031c, User, 1);
		if(n_round == 2)
		{
			if(self.s_plant.var_2a1e031c[0] === self.s_plant.var_2a1e031c[1] && self.s_plant.var_2a1e031c[1] === self.s_plant.var_2a1e031c[2])
			{
				User notify("update_challenge_1_1");
			}
		}
		self.s_plant.var_8d8becb0 = 1;
		self.s_plant.model clientfield::set("plant_watered_fx", 1);
		self.model clientfield::set("planter_model_watered", 1);
		level waittill("end_of_round");
		self.s_plant.model clientfield::set("plant_watered_fx", 0);
		self.model clientfield::set("planter_model_watered", 0);
	}
}

/*
	Name: function_5026698c
	Namespace: namespace_7550a904
	Checksum: 0xF037D983
	Offset: 0x3420
	Size: 0xFD
	Parameters: 1
	Flags: None
*/
function function_5026698c(var_f40460f5)
{
	self endon("hash_70cb3a5f");
	self.s_plant.var_49d71b32 = 0;
	for(n_round = 0; n_round < 3; n_round++)
	{
		self waittill("hash_8dfde2c8");
		self.s_plant.var_49d71b32++;
		self.s_plant.var_8d8becb0 = 1;
		self.s_plant.model clientfield::set("plant_hit_with_ww_fx", 1);
		if(isdefined(var_f40460f5) && var_f40460f5)
		{
			return;
		}
		else
		{
			level waittill("end_of_round");
		}
		self.s_plant.model clientfield::set("plant_hit_with_ww_fx", 0);
	}
}

/*
	Name: function_26651461
	Namespace: namespace_7550a904
	Checksum: 0xE3C31DC7
	Offset: 0x3528
	Size: 0x9B9
	Parameters: 4
	Flags: None
*/
function function_26651461(a_water, var_49d71b32, var_9636d237, var_f40460f5)
{
	a_plants = [];
	a_plants[0] = 0;
	a_plants[1] = 0;
	a_plants[2] = 0;
	a_plants[3] = 0;
	a_plants[4] = 0;
	a_plants[5] = 0;
	a_plants[6] = 0;
	a_plants[7] = 0;
	a_plants[8] = 0;
	a_plants[9] = 0;
	a_plants[10] = 0;
	var_1e67e37 = 0;
	var_34c1ce60 = 0;
	var_eaa9733b = 0;
	var_98b687fa = 0;
	if(self.script_noteworthy === "ee_planting_spot")
	{
		b_ee_planting_spot = 1;
	}
	else
	{
		b_ee_planting_spot = 0;
	}
	for(i = 0; i < a_water.size; i++)
	{
		if(a_water[i] == 4)
		{
			if(b_ee_planting_spot && !level flag::get("ww_upgrade_spawned_from_plant"))
			{
				continue;
				continue;
			}
			a_water[i] = randomIntRange(1, 4);
		}
	}
	foreach(n_water in a_water)
	{
		if(n_water == 1)
		{
			var_1e67e37++;
			continue;
		}
		if(n_water == 2)
		{
			var_34c1ce60++;
			continue;
		}
		if(n_water == 3)
		{
			var_eaa9733b++;
			continue;
		}
		if(n_water == 4)
		{
			var_98b687fa++;
		}
	}
	if(self.script_noteworthy === "ee_planting_spot")
	{
		self function_5726c670(var_98b687fa);
		return;
	}
	n_total = 0;
	if(level.var_50d5cc84 < 4)
	{
		if(var_49d71b32 == 3)
		{
			a_plants[10] = 20;
		}
		else
		{
			a_plants[10] = 5 * var_49d71b32;
		}
	}
	n_remainder = 100 - a_plants[10];
	n_total = n_total + a_plants[10];
	if(var_1e67e37 == 1 && var_34c1ce60 == 1 && var_eaa9733b == 1)
	{
		a_plants[8] = n_remainder / 2;
		a_plants[2] = n_remainder / 2 / 3;
		a_plants[4] = n_remainder / 2 / 3;
		a_plants[6] = n_remainder / 2 / 3;
		a_plants[0] = 0;
		a_plants[1] = 0;
	}
	else
	{
		a_plants[2] = n_remainder * var_1e67e37 / 3;
		a_plants[4] = n_remainder * var_eaa9733b / 3;
		a_plants[6] = n_remainder * var_34c1ce60 / 3;
		n_total = n_total + a_plants[2] + a_plants[4] + a_plants[6];
		if(a_water.size === 0 && var_49d71b32 === 0)
		{
			a_plants[0] = 100 - n_total;
			a_plants[1] = 0;
		}
		else
		{
			a_plants[0] = 0;
			a_plants[1] = 100 - n_total;
		}
	}
	a_plants[3] = a_plants[2] * var_49d71b32 / 3;
	a_plants[2] = Abs(a_plants[2] - a_plants[3]);
	a_plants[5] = a_plants[4] * var_49d71b32 / 3;
	a_plants[4] = Abs(a_plants[4] - a_plants[5]);
	a_plants[7] = a_plants[6] * var_49d71b32 / 3;
	a_plants[6] = Abs(a_plants[6] - a_plants[7]);
	a_plants[9] = a_plants[8] * var_49d71b32 / 3;
	a_plants[8] = Abs(a_plants[8] - a_plants[9]);
	if(isdefined(var_f40460f5) && var_f40460f5)
	{
		a_plants = [];
		if(var_49d71b32 > 0)
		{
			a_plants[5] = 100;
		}
		else
		{
			a_plants[4] = 100;
		}
	}
	a_possible = [];
	n_cumulative = 0;
	foreach(n_score in a_plants)
	{
		if(n_score > 0)
		{
			a_possible[Plant] = n_cumulative + n_score;
			n_cumulative = n_cumulative + n_score;
		}
	}
	n_random = RandomFloatRange(0, 100);
	foreach(n_score in a_possible)
	{
		if(n_random <= n_score)
		{
			break;
		}
	}
	if(isdefined(var_9636d237))
	{
		Plant = var_9636d237;
	}
	switch(Plant)
	{
		case 0:
		{
			self function_41663231();
			break;
		}
		case 1:
		{
			self function_41663231(1);
			break;
		}
		case 2:
		{
			self function_a6084535(0, var_98b687fa);
			break;
		}
		case 3:
		{
			self function_a6084535(1, var_98b687fa);
			break;
		}
		case 4:
		{
			self function_5d62716(0, var_f40460f5);
			break;
		}
		case 5:
		{
			self function_5d62716(1, var_f40460f5);
			break;
		}
		case 6:
		{
			self function_12c8548e();
			break;
		}
		case 7:
		{
			self function_12c8548e(1);
			break;
		}
		case 8:
		{
			self function_fd098f17();
			break;
		}
		case 9:
		{
			self function_fd098f17(1);
			break;
		}
		case 10:
		{
			self function_3e429652();
			break;
		}
		case default:
		{
			break;
		}
	}
}

/*
	Name: function_54af12e9
	Namespace: namespace_7550a904
	Checksum: 0xCE999EEF
	Offset: 0x3EF0
	Size: 0x2D3
	Parameters: 0
	Flags: None
*/
function function_54af12e9()
{
	level.var_3f5e92d = GetWeapon("pistol_standard");
	level.var_f3798849 = GetWeapon("sniper_fastbolt");
	level.var_c29d7558 = GetWeapon("launcher_standard");
	level.var_b00f35c1 = GetWeapon("ar_marksman");
	a_rewards = [];
	a_rewards["points"] = 10;
	a_rewards["pistol"] = 10;
	a_rewards["sniper"] = 10;
	a_rewards["launcher"] = 10;
	a_rewards["ar"] = 10;
	a_rewards["zombie"] = 25;
	a_rewards["grenade"] = 25;
	n_cumulative = 0;
	level.var_349b9c58 = [];
	foreach(n_chance in a_rewards)
	{
		level.var_349b9c58[str_reward] = n_chance + n_cumulative;
		n_cumulative = n_cumulative + n_chance;
	}
	var_ec35bcf6 = [];
	var_ec35bcf6["points"] = 35;
	var_ec35bcf6["pistol"] = 35;
	var_ec35bcf6["sniper"] = 10;
	var_ec35bcf6["launcher"] = 10;
	var_ec35bcf6["ar"] = 10;
	n_cumulative = 0;
	level.var_9d5349d = [];
	foreach(n_chance in var_ec35bcf6)
	{
		level.var_9d5349d[str_reward] = n_chance + n_cumulative;
		n_cumulative = n_cumulative + n_chance;
	}
}

/*
	Name: function_41663231
	Namespace: namespace_7550a904
	Checksum: 0xD1B1ABAD
	Offset: 0x41D0
	Size: 0x873
	Parameters: 1
	Flags: None
*/
function function_41663231(b_upgraded)
{
	if(!isdefined(b_upgraded))
	{
		b_upgraded = 0;
	}
	/#
		if(b_upgraded == 1)
		{
			println("Dev Block strings are not supported");
		}
		else
		{
			println("Dev Block strings are not supported");
		}
	#/
	if(isdefined(self.var_561a9c48))
	{
		self.var_561a9c48 notify("minor_cache_plant_spawned");
	}
	level notify("minor_cache_plant_spawned");
	self.s_plant.model StopAnimScripted();
	self.s_plant.model SetModel("p7_fxanim_zm_island_plant_cache_minor_mod");
	self.s_plant.model show();
	self.s_plant.model solid();
	self.s_plant.model disconnectpaths();
	self.s_plant.model clientfield::set("cache_plant_interact_fx", 1);
	self thread scene::init("p7_fxanim_zm_island_plant_cache_minor_bundle", self.s_plant.model);
	self.s_plant.model waittill("hash_1879b5e4");
	self thread function_a6ebbe13();
	self waittill("hash_ebe5cad7", e_who);
	/#
		println("Dev Block strings are not supported");
	#/
	zm_unitrigger::unregister_unitrigger(self.var_23c5e7a6);
	self.var_23c5e7a6 = undefined;
	self.s_plant.model clientfield::set("cache_plant_interact_fx", 0);
	self scene::Play("p7_fxanim_zm_island_plant_cache_minor_bundle", self.s_plant.model);
	if(b_upgraded == 1)
	{
		var_3d9ef8e9 = level.var_9d5349d;
	}
	else
	{
		var_3d9ef8e9 = level.var_349b9c58;
	}
	n_reward = RandomFloatRange(0, 100);
	foreach(n_chance in var_3d9ef8e9)
	{
		if(n_reward <= n_chance)
		{
			break;
		}
	}
	switch(str_reward)
	{
		case "points":
		{
			e_powerup = zm_powerups::specific_powerup_drop("bonus_points_player", self.origin + VectorScale((0, 0, 1), 8), undefined, undefined, 1);
			e_who notify("player_revealed_cache_plant_good");
			e_powerup util::waittill_any("powerup_grabbed", "death", "powerup_reset", "powerup_timedout");
			break;
		}
		case "pistol":
		{
			e_who notify("player_revealed_cache_plant_bad");
			self dig_up_weapon(e_who, level.var_3f5e92d);
			break;
		}
		case "sniper":
		{
			e_who notify("player_revealed_cache_plant_bad");
			self dig_up_weapon(e_who, level.var_f3798849);
			break;
		}
		case "launcher":
		{
			e_who notify("player_revealed_cache_plant_bad");
			self dig_up_weapon(e_who, level.var_c29d7558);
			break;
		}
		case "ar":
		{
			e_who notify("player_revealed_cache_plant_bad");
			self dig_up_weapon(e_who, level.var_b00f35c1);
			break;
		}
		case "zombie":
		{
			self.s_plant.model notsolid();
			self.s_plant.model connectpaths();
			wait(0.05);
			s_temp = spawnstruct();
			s_temp.origin = function_15c62ca8(self.origin, 20);
			if(!isdefined(s_temp.origin))
			{
				s_temp.origin = self.origin;
			}
			s_temp.script_noteworthy = "custom_spawner_entry quick_riser_location";
			s_temp.script_string = "find_flesh";
			zombie_utility::spawn_zombie(level.zombie_spawners[0], "aether_zombie", s_temp);
			util::wait_network_frame();
			s_temp struct::delete();
			self.s_plant.model clientfield::set("zombie_or_grenade_spawned_from_minor_cache_plant", 1);
			self.s_plant.model util::delay(3, undefined, &clientfield::set, "zombie_or_grenade_spawned_from_minor_cache_plant", 0);
			e_who notify("player_revealed_cache_plant_bad");
			break;
		}
		case "grenade":
		{
			self.s_plant.model notsolid();
			self.s_plant.model connectpaths();
			wait(0.05);
			v_spawnpt = self.origin;
			grenade = GetWeapon("frag_grenade");
			e_who MagicGrenadeType(grenade, v_spawnpt, VectorScale((0, 0, 1), 300), 3);
			self.s_plant.model clientfield::set("zombie_or_grenade_spawned_from_minor_cache_plant", 2);
			self.s_plant.model util::delay(3, undefined, &clientfield::set, "zombie_or_grenade_spawned_from_minor_cache_plant", 0);
			e_who notify("player_revealed_cache_plant_bad");
			break;
		}
		case default:
		{
			break;
		}
	}
	self.s_plant.model clientfield::set("plant_growth_siege_anims", 0);
	self scene::Play("p7_fxanim_zm_island_plant_cache_minor_death_bundle", self.s_plant.model);
}

/*
	Name: function_a6ebbe13
	Namespace: namespace_7550a904
	Checksum: 0x79A6EF4D
	Offset: 0x4A50
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function function_a6ebbe13()
{
	s_plant_unitrigger = spawnstruct();
	s_plant_unitrigger.origin = self.origin + VectorScale((0, 0, 1), 8);
	s_plant_unitrigger.angles = self.angles;
	s_plant_unitrigger.s_parent = self;
	s_plant_unitrigger.script_unitrigger_type = "unitrigger_box_use";
	s_plant_unitrigger.cursor_hint = "HINT_NOICON";
	s_plant_unitrigger.require_look_at = 1;
	s_plant_unitrigger.script_width = 100;
	s_plant_unitrigger.script_length = 100;
	s_plant_unitrigger.script_height = 150;
	s_plant_unitrigger.prompt_and_visibility_func = &function_be57d4be;
	zm_unitrigger::register_static_unitrigger(s_plant_unitrigger, &function_241f6a3e);
	self.var_23c5e7a6 = s_plant_unitrigger;
	self.s_plant flag::clear("plant_interact_trigger_used");
}

/*
	Name: function_be57d4be
	Namespace: namespace_7550a904
	Checksum: 0x4BA0E8B5
	Offset: 0x4BA8
	Size: 0x139
	Parameters: 1
	Flags: None
*/
function function_be57d4be(e_player)
{
	if(e_player zm_utility::in_revive_trigger())
	{
		self setHintString(&"");
		return 0;
	}
	if(e_player.IS_DRINKING > 0)
	{
		self setHintString(&"");
		return 0;
	}
	if(!zm_utility::is_player_valid(e_player))
	{
		self setHintString(&"");
		return 0;
	}
	if(self.stub.s_parent.s_plant flag::get("plant_interact_trigger_used"))
	{
		self setHintString(&"");
		return 0;
	}
	else
	{
		self setHintString(&"ZM_ISLAND_CACHE_PLANT");
		return 1;
	}
}

/*
	Name: function_241f6a3e
	Namespace: namespace_7550a904
	Checksum: 0x588C2482
	Offset: 0x4CF0
	Size: 0xD1
	Parameters: 0
	Flags: None
*/
function function_241f6a3e()
{
	while(1)
	{
		self waittill("trigger", e_who);
		if(e_who zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(e_who.IS_DRINKING > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(e_who))
		{
			continue;
		}
		self.stub.s_parent notify("hash_ebe5cad7", e_who);
		self.stub.s_parent.s_plant flag::set("plant_interact_trigger_used");
		return;
	}
}

/*
	Name: function_72298dfd
	Namespace: namespace_7550a904
	Checksum: 0xD1A9245D
	Offset: 0x4DD0
	Size: 0x513
	Parameters: 0
	Flags: None
*/
function function_72298dfd()
{
	level.var_df105f37 = 50;
	var_b2846cef = GetWeapon("smg_mp40");
	var_f27e0342 = GetWeapon("shotgun_semiauto");
	var_6b0419bd = GetWeapon("ar_damage");
	var_1a2b2be0 = GetWeapon("lmg_slowfire");
	var_8847e925 = GetWeapon("ar_garand");
	var_21057d5f = GetWeapon("smg_longrange");
	level.var_b39227d1 = Array(var_b2846cef, var_f27e0342, var_6b0419bd, var_1a2b2be0, var_8847e925, var_21057d5f);
	level.var_c88b32a2 = Array("full_ammo", "nuke", "insta_kill", "double_points", "fire_sale", "carpenter", "minigun");
	var_56b02536 = GetWeapon("pistol_shotgun_dw");
	var_722e06cb = GetWeapon("shotgun_fullauto");
	var_d6376f9e = GetWeapon("sniper_fastsemi");
	var_4fa7d135 = GetWeapon("ray_gun");
	var_c71381ba = GetWeapon("bowie_knife");
	var_b4550164 = GetWeapon("cymbal_monkey");
	level.var_8aee1d4 = Array(var_56b02536, var_722e06cb, var_d6376f9e, var_4fa7d135, var_c71381ba, var_b4550164);
	level.var_1a1ac6dd = Array("full_ammo", "nuke", "insta_kill", "double_points", "fire_sale", "minigun");
	a_rewards = [];
	var_c6f9cb70 = 100;
	a_rewards["points"] = var_c6f9cb70 / 3;
	a_rewards["weapon"] = var_c6f9cb70 / 3;
	a_rewards["powerup"] = var_c6f9cb70 / 3;
	n_cumulative = 0;
	level.var_170b1e5c = [];
	foreach(n_chance in a_rewards)
	{
		level.var_170b1e5c[str_reward] = n_chance + n_cumulative;
		n_cumulative = n_cumulative + n_chance;
	}
	level.var_e6d4b4ec = n_cumulative;
	var_ec35bcf6 = [];
	var_ec35bcf6["points"] = 30;
	var_ec35bcf6["weapon"] = 25;
	var_ec35bcf6["powerup"] = 25;
	var_ec35bcf6["perk_bottle"] = 20;
	n_cumulative = 0;
	level.var_ff3b49 = [];
	foreach(n_chance in var_ec35bcf6)
	{
		level.var_ff3b49[str_reward] = n_chance + n_cumulative;
		n_cumulative = n_cumulative + n_chance;
	}
	level.var_2afecb6f = n_cumulative;
}

/*
	Name: function_a6084535
	Namespace: namespace_7550a904
	Checksum: 0x139976D6
	Offset: 0x52F0
	Size: 0x833
	Parameters: 2
	Flags: None
*/
function function_a6084535(b_upgraded, var_98b687fa)
{
	if(!isdefined(b_upgraded))
	{
		b_upgraded = 0;
	}
	/#
		if(b_upgraded == 1)
		{
			println("Dev Block strings are not supported");
		}
		else
		{
			println("Dev Block strings are not supported");
		}
	#/
	if(isdefined(self.var_561a9c48))
	{
		self.var_561a9c48 notify("major_cache_plant_spawned");
	}
	level notify("major_cache_plant_spawned");
	self.s_plant.model StopAnimScripted();
	if(b_upgraded == 1)
	{
		self.s_plant.model SetModel("p7_fxanim_zm_island_plant_cache_major_glow_mod");
	}
	else
	{
		self.s_plant.model SetModel("p7_fxanim_zm_island_plant_cache_major_mod");
	}
	self.s_plant.model clientfield::set("cache_plant_interact_fx", 1);
	self.s_plant.model show();
	self.s_plant.model solid();
	self.s_plant.model disconnectpaths();
	self thread scene::init("p7_fxanim_zm_island_plant_cache_major_bundle", self.s_plant.model);
	self.s_plant.model waittill("hash_aa2731d8");
	self thread function_192bd777();
	self waittill("hash_983c15d3", e_who);
	/#
		println("Dev Block strings are not supported");
	#/
	zm_unitrigger::unregister_unitrigger(self.var_23c5e7a6);
	self.var_23c5e7a6 = undefined;
	self.s_plant.model clientfield::set("cache_plant_interact_fx", 0);
	self scene::Play("p7_fxanim_zm_island_plant_cache_major_bundle", self.s_plant.model);
	if(b_upgraded == 1)
	{
		var_3d9ef8e9 = level.var_ff3b49;
		var_582b5c62 = level.var_2afecb6f;
	}
	else
	{
		var_3d9ef8e9 = level.var_170b1e5c;
		var_582b5c62 = level.var_e6d4b4ec;
	}
	n_reward = RandomFloatRange(0, var_582b5c62);
	foreach(n_chance in var_3d9ef8e9)
	{
		if(n_reward <= n_chance)
		{
			break;
		}
	}
	if(b_upgraded == 1)
	{
		if(level flag::get("trilogy_released") && !level flag::get("aa_gun_ee_complete") && !level flag::get("player_has_aa_gun_ammo") && !level flag::get("aa_gun_ammo_loaded"))
		{
			n_chance = RandomFloatRange(0, 100);
			if(n_chance <= level.var_df105f37)
			{
				str_reward = "aa_gun_ammo";
			}
			else
			{
				level.var_df105f37 = level.var_df105f37 + 10;
			}
		}
	}
	switch(str_reward)
	{
		case "points":
		{
			e_powerup = zm_powerups::specific_powerup_drop("bonus_points_team", self.origin + VectorScale((0, 0, 1), 8), undefined, undefined, 1);
			e_powerup thread function_61d38f32();
			e_who notify("player_revealed_cache_plant_good");
			e_powerup util::waittill_any("powerup_grabbed", "death", "powerup_reset", "powerup_timedout");
			break;
		}
		case "weapon":
		{
			if(b_upgraded == 1)
			{
				e_who notify("player_revealed_cache_plant_good");
				self dig_up_weapon(e_who, Array::random(level.var_8aee1d4));
			}
			else
			{
				e_who notify("player_revealed_cache_plant_good");
				self dig_up_weapon(e_who, Array::random(level.var_b39227d1));
			}
			break;
		}
		case "powerup":
		{
			if(b_upgraded == 1)
			{
				str_powerup = Array::random(level.var_1a1ac6dd);
			}
			else
			{
				str_powerup = Array::random(level.var_c88b32a2);
			}
			e_powerup = zm_powerups::specific_powerup_drop(str_powerup, self.origin + VectorScale((0, 0, 1), 8), undefined, undefined, 1);
			e_powerup thread function_61d38f32();
			e_who notify("player_revealed_cache_plant_good");
			e_powerup util::waittill_any("powerup_grabbed", "death", "powerup_reset", "powerup_timedout");
			break;
		}
		case "perk_bottle":
		{
			e_powerup = zm_powerups::specific_powerup_drop("empty_perk", self.origin + VectorScale((0, 0, 1), 8), undefined, undefined, 1);
			e_powerup thread function_61d38f32();
			e_who notify("player_revealed_cache_plant_good");
			e_powerup util::waittill_any("powerup_grabbed", "death", "powerup_reset", "powerup_timedout");
			break;
		}
		case "aa_gun_ammo":
		{
			self main_quest::function_1f4e6abd();
			break;
		}
	}
	self.s_plant.model clientfield::set("plant_growth_siege_anims", 0);
	self scene::Play("p7_fxanim_zm_island_plant_cache_major_death_bundle", self.s_plant.model);
}

/*
	Name: function_192bd777
	Namespace: namespace_7550a904
	Checksum: 0xE41830B3
	Offset: 0x5B30
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function function_192bd777()
{
	s_plant_unitrigger = spawnstruct();
	s_plant_unitrigger.origin = self.origin + VectorScale((0, 0, 1), 8);
	s_plant_unitrigger.angles = self.angles;
	s_plant_unitrigger.s_parent = self;
	s_plant_unitrigger.script_unitrigger_type = "unitrigger_box_use";
	s_plant_unitrigger.cursor_hint = "HINT_NOICON";
	s_plant_unitrigger.require_look_at = 1;
	s_plant_unitrigger.script_width = 100;
	s_plant_unitrigger.script_length = 100;
	s_plant_unitrigger.script_height = 150;
	s_plant_unitrigger.prompt_and_visibility_func = &function_4fdc4f62;
	zm_unitrigger::register_static_unitrigger(s_plant_unitrigger, &function_a5e6439a);
	self.var_23c5e7a6 = s_plant_unitrigger;
	self.s_plant flag::clear("plant_interact_trigger_used");
}

/*
	Name: function_4fdc4f62
	Namespace: namespace_7550a904
	Checksum: 0x1042A1E9
	Offset: 0x5C88
	Size: 0x139
	Parameters: 1
	Flags: None
*/
function function_4fdc4f62(e_player)
{
	if(e_player zm_utility::in_revive_trigger())
	{
		self setHintString(&"");
		return 0;
	}
	if(e_player.IS_DRINKING > 0)
	{
		self setHintString(&"");
		return 0;
	}
	if(!zm_utility::is_player_valid(e_player))
	{
		self setHintString(&"");
		return 0;
	}
	if(self.stub.s_parent.s_plant flag::get("plant_interact_trigger_used"))
	{
		self setHintString(&"");
		return 0;
	}
	else
	{
		self setHintString(&"ZM_ISLAND_CACHE_PLANT");
		return 1;
	}
}

/*
	Name: function_a5e6439a
	Namespace: namespace_7550a904
	Checksum: 0xD3D9CB5
	Offset: 0x5DD0
	Size: 0xD1
	Parameters: 0
	Flags: None
*/
function function_a5e6439a()
{
	while(1)
	{
		self waittill("trigger", e_who);
		if(e_who zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(e_who.IS_DRINKING > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(e_who))
		{
			continue;
		}
		self.stub.s_parent notify("hash_983c15d3", e_who);
		self.stub.s_parent.s_plant flag::set("plant_interact_trigger_used");
		return;
	}
}

/*
	Name: init_babysitter_plant
	Namespace: namespace_7550a904
	Checksum: 0x80F4B8CD
	Offset: 0x5EB0
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function init_babysitter_plant()
{
	scene::add_scene_func("zm_dlc2_plant_babysitter_gib_zombie", &function_389c8477, "play");
	scene::add_scene_func("zm_dlc2_plant_babysitter_grab_zombie_crawler", &function_a4a048a1, "play");
	scene::add_scene_func("zm_dlc2_plant_babysitter_grab_spider", &function_6d8761e4, "play");
	scene::add_scene_func("zm_dlc2_plant_babysitter_outro", &function_7a4276be, "done");
}

/*
	Name: function_12c8548e
	Namespace: namespace_7550a904
	Checksum: 0xFDDAEBA1
	Offset: 0x5F80
	Size: 0x90B
	Parameters: 1
	Flags: None
*/
function function_12c8548e(b_upgraded)
{
	if(!isdefined(b_upgraded))
	{
		b_upgraded = 0;
	}
	/#
		if(b_upgraded == 1)
		{
			println("Dev Block strings are not supported");
		}
		else
		{
			println("Dev Block strings are not supported");
		}
	#/
	if(isdefined(self.var_561a9c48))
	{
		self.var_561a9c48 notify("babysitter_plant_spawned");
	}
	level notify("babysitter_plant_spawned");
	if(b_upgraded == 1)
	{
		self.s_plant.model SetModel("p7_zm_isl_plant_babysitter_glow");
	}
	else
	{
		self.s_plant.model SetModel("p7_zm_isl_plant_babysitter");
	}
	self.s_plant.model show();
	self.s_plant.model solid();
	self.s_plant.model disconnectpaths();
	self.model clientfield::set("babysitter_plant_fx", 1);
	self scene::init("zm_dlc2_plant_babysitter_intro", self.s_plant.model);
	self.s_plant.model waittill("hash_fca5370b");
	self.s_plant.trigger = spawn("trigger_radius", self.origin, 17, 150, 150);
	while(1)
	{
		self.s_plant.trigger waittill("trigger", e_who);
		if(isdefined(e_who.b_is_thrasher) && e_who.b_is_thrasher)
		{
			continue;
		}
		if(isPlayer(e_who))
		{
			continue;
		}
		if(!isdefined(e_who.b_is_spider) && e_who.b_is_spider && e_who.completed_emerging_into_playable_area !== 1)
		{
			continue;
		}
		var_b28a4a84 = 0;
		str_zone = self.s_plant.model zm_utility::get_current_zone();
		foreach(player in level.players)
		{
			str_player_zone = player zm_utility::get_current_zone();
			if(str_zone === str_player_zone)
			{
				var_b28a4a84 = 1;
				break;
			}
		}
		if(var_b28a4a84 == 0)
		{
			continue;
		}
		if(isalive(e_who))
		{
			if(isdefined(e_who.missingLegs) && e_who.missingLegs)
			{
				e_who thread function_160d5071(self, "ai_zm_dlc2_zombie_crawl_grabbed_by_babysitter");
			}
			else if(isdefined(e_who.b_is_spider) && e_who.b_is_spider)
			{
				e_who thread function_40428876(self, "ai_zm_dlc2_spider_grabbed_by_babysitter");
			}
			else
			{
				e_who thread function_8be57636(self);
				e_who thread function_160d5071(self, "ai_zm_dlc2_zombie_gibbed_by_babysitter");
			}
			e_who util::waittill_any("death", "zombie_reached_anim_spot");
			if(!isalive(e_who))
			{
				continue;
			}
			e_who.b_ignore_cleanup = 1;
			e_who.is_inert = 1;
			var_73dc61d6 = Array(self.s_plant.model, e_who);
			break;
		}
	}
	if(!isdefined(e_who.missingLegs) && e_who.missingLegs && (!isdefined(e_who.b_is_spider) && e_who.b_is_spider))
	{
		e_who.var_2ff6aa22 = 1;
		e_who thread util::delay(1, "death", &function_9a107da1);
		self scene::Play("zm_dlc2_plant_babysitter_gib_zombie", var_73dc61d6);
	}
	if(isdefined(e_who.b_is_spider) && e_who.b_is_spider)
	{
		self scene::Play("zm_dlc2_plant_babysitter_grab_spider", var_73dc61d6);
	}
	else
	{
		self scene::Play("zm_dlc2_plant_babysitter_grab_zombie_crawler", var_73dc61d6);
	}
	/#
		println("Dev Block strings are not supported");
	#/
	level thread zm_island_vo::function_1e767f71(self.s_plant.model, 600, "babysitter", "grab", 120, 0, -1);
	if(b_upgraded == 1)
	{
		e_who util::waittill_any_timeout(3600, "death");
	}
	else
	{
		e_who util::waittill_any_timeout(480, "death");
	}
	self.s_plant.model notify("hash_9ed7f404");
	if(isdefined(e_who) && isalive(e_who))
	{
		if(isdefined(e_who.b_is_spider) && e_who.b_is_spider)
		{
			self scene::Play("zm_dlc2_plant_babysitter_drop_spider", var_73dc61d6);
			e_who vehicle_ai::stop_scripted();
		}
		else
		{
			self scene::Play("zm_dlc2_plant_babysitter_drop_zombie_crawler", var_73dc61d6);
		}
		e_who.b_ignore_cleanup = 0;
		e_who.is_inert = 0;
	}
	wait(1);
	self.s_plant.model clientfield::set("plant_growth_siege_anims", 0);
	self thread scene::Play("zm_dlc2_plant_babysitter_outro", self.s_plant.model);
	self.s_plant.model waittill("hash_7a4276be");
	self.model clientfield::set("babysitter_plant_fx", 0);
	self.s_plant.trigger delete();
	wait(0.05);
	self.s_plant.model StopAnimScripted();
	wait(0.05);
}

/*
	Name: function_8be57636
	Namespace: namespace_7550a904
	Checksum: 0xF27B6F38
	Offset: 0x6898
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function function_8be57636(s_plant)
{
	self endon("death");
	self endon("zombie_reached_anim_spot");
	while(1)
	{
		if(isdefined(self.missingLegs) && self.missingLegs)
		{
			self notify("hash_e9a97726");
			self thread function_160d5071(s_plant, "ai_zm_dlc2_zombie_crawl_grabbed_by_babysitter");
			break;
		}
		wait(0.05);
	}
}

/*
	Name: function_389c8477
	Namespace: namespace_7550a904
	Checksum: 0x80D12D17
	Offset: 0x6920
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function function_389c8477(a_ents)
{
	level thread function_14ae573d(a_ents);
	ai_zombie = a_ents["zombie"];
	ai_zombie SetCanDamage(0);
	ai_zombie waittill("gibbed");
	ai_zombie zombie_utility::makeZombieCrawler(1);
}

/*
	Name: function_14ae573d
	Namespace: namespace_7550a904
	Checksum: 0x20E119D6
	Offset: 0x69A8
	Size: 0x3A9
	Parameters: 1
	Flags: None
*/
function function_14ae573d(a_ents)
{
	a_ents["babysitter"] waittill("gib_zombie");
	v_org = a_ents["babysitter"] GetTagOrigin("j_claw_1_anim");
	foreach(player in level.players)
	{
		if(!isalive(player))
		{
			continue;
		}
		n_dist = Distance2DSquared(player.origin, v_org);
		if(n_dist < 2304)
		{
			player DoDamage(50, player.origin);
			player PlayRumbleOnEntity("damage_light");
		}
	}
	a_enemy_ai = GetAITeamArray("axis");
	foreach(ai in a_enemy_ai)
	{
		if(!isalive(ai) || (isdefined(ai.var_2ff6aa22) && ai.var_2ff6aa22))
		{
			continue;
		}
		n_dist = Distance2DSquared(ai.origin, v_org);
		if(n_dist < 2304)
		{
			if(isdefined(ai.b_is_thrasher) && ai.b_is_thrasher)
			{
				n_damage = ai.maxhealth * 0.25;
				ai DoDamage(n_damage, ai.origin);
				continue;
			}
			if(isdefined(ai.b_is_spider) && ai.b_is_spider)
			{
				ai DoDamage(ai.health, ai.origin);
				continue;
			}
			if(isdefined(ai.missingLegs) && ai.missingLegs)
			{
				ai DoDamage(ai.health, ai.origin);
				continue;
			}
			ai zombie_utility::makeZombieCrawler();
		}
	}
}

/*
	Name: function_9a107da1
	Namespace: namespace_7550a904
	Checksum: 0xD47012BF
	Offset: 0x6D60
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function function_9a107da1()
{
	self.var_2ff6aa22 = 0;
}

/*
	Name: function_a4a048a1
	Namespace: namespace_7550a904
	Checksum: 0xEC86AF65
	Offset: 0x6D78
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function function_a4a048a1(a_ents)
{
	a_ents["zombie"] SetCanDamage(0);
	a_ents["zombie"] waittill("hash_58f0843e");
	a_ents["zombie"] SetCanDamage(1);
}

/*
	Name: function_6d8761e4
	Namespace: namespace_7550a904
	Checksum: 0x548E1AD2
	Offset: 0x6DF0
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function function_6d8761e4(a_ents)
{
	a_ents["spider"] SetCanDamage(0);
	a_ents["spider"] waittill("hash_dfabd1fb");
	a_ents["spider"] SetCanDamage(1);
}

/*
	Name: function_7a4276be
	Namespace: namespace_7550a904
	Checksum: 0xFB910075
	Offset: 0x6E68
	Size: 0x25
	Parameters: 1
	Flags: None
*/
function function_7a4276be(a_ents)
{
	a_ents["babysitter"] notify("hash_7a4276be");
}

/*
	Name: init_trap_plant
	Namespace: namespace_7550a904
	Checksum: 0x86132F6F
	Offset: 0x6E98
	Size: 0x333
	Parameters: 0
	Flags: None
*/
function init_trap_plant()
{
	scene::add_scene_func("zm_dlc2_plant_trap_outro", &function_2df6714, "done");
	scene::add_scene_func("zm_dlc2_plant_trap_attack_front", &function_9e124689, "play");
	scene::add_scene_func("zm_dlc2_plant_trap_attack_back", &function_9e124689, "play");
	scene::add_scene_func("zm_dlc2_plant_trap_attack_left", &function_9e124689, "play");
	scene::add_scene_func("zm_dlc2_plant_trap_attack_right", &function_9e124689, "play");
	scene::add_scene_func("zm_dlc2_plant_trap_attack_no_target_front", &function_9e124689, "play");
	scene::add_scene_func("zm_dlc2_plant_trap_attack_no_target_back", &function_9e124689, "play");
	scene::add_scene_func("zm_dlc2_plant_trap_attack_no_target_left", &function_9e124689, "play");
	scene::add_scene_func("zm_dlc2_plant_trap_attack_no_target_right", &function_9e124689, "play");
	scene::add_scene_func("zm_dlc2_plant_trap_attack_crawler_front", &function_9e124689, "play");
	scene::add_scene_func("zm_dlc2_plant_trap_attack_crawler_back", &function_9e124689, "play");
	scene::add_scene_func("zm_dlc2_plant_trap_attack_crawler_left", &function_9e124689, "play");
	scene::add_scene_func("zm_dlc2_plant_trap_attack_crawler_right", &function_9e124689, "play");
	scene::add_scene_func("zm_dlc2_plant_trap_attack_spider_front", &function_b1a9e247, "play");
	scene::add_scene_func("zm_dlc2_plant_trap_attack_spider_back", &function_b1a9e247, "play");
	scene::add_scene_func("zm_dlc2_plant_trap_attack_spider_left", &function_b1a9e247, "play");
	scene::add_scene_func("zm_dlc2_plant_trap_attack_spider_right", &function_b1a9e247, "play");
}

/*
	Name: function_5d62716
	Namespace: namespace_7550a904
	Checksum: 0x42AAD5EB
	Offset: 0x71D8
	Size: 0x41B
	Parameters: 2
	Flags: None
*/
function function_5d62716(b_upgraded, var_f40460f5)
{
	if(!isdefined(b_upgraded))
	{
		b_upgraded = 0;
	}
	/#
		if(b_upgraded == 1)
		{
			println("Dev Block strings are not supported");
		}
		else
		{
			println("Dev Block strings are not supported");
		}
	#/
	if(isdefined(self.var_561a9c48))
	{
		self.var_561a9c48 notify("trap_plant_spawned");
	}
	level notify("trap_plant_spawned");
	if(isdefined(var_f40460f5) && var_f40460f5)
	{
		level notify("hash_35728d0b");
	}
	if(!self.s_plant.model flag::exists("trap_plant_attacking"))
	{
		self.s_plant.model flag::init("trap_plant_attacking");
	}
	if(b_upgraded == 1)
	{
		self.s_plant.model SetModel("p7_zm_isl_plant_trap_glow");
	}
	else
	{
		self.s_plant.model SetModel("p7_zm_isl_plant_trap");
	}
	self.s_plant.model show();
	self.s_plant.model solid();
	self.s_plant.model disconnectpaths();
	self.model clientfield::set("trap_plant_fx", 1);
	self scene::init("zm_dlc2_plant_trap_intro", self.s_plant.model);
	self.s_plant.model waittill("hash_73ada233");
	level thread zm_island_vo::function_1e767f71(self.s_plant.model, 600, "trap", "plant_encounter", 60, 1, -1);
	self.s_plant.trigger = spawn("trigger_radius", self.origin, 0, 75, 150);
	self thread function_ff90a1ba(b_upgraded);
	self thread function_2870d1b8(var_f40460f5);
	self waittill("hash_4729ad2");
	self.model clientfield::set("trap_plant_fx", 0);
	self.s_plant.trigger delete();
	self.s_plant.model flag::wait_till_clear("trap_plant_attacking");
	self.s_plant.model clientfield::set("plant_growth_siege_anims", 0);
	self thread scene::Play("zm_dlc2_plant_trap_outro", self.s_plant.model);
	self.s_plant.model waittill("hash_2df6714");
	wait(0.05);
	self.s_plant.model StopAnimScripted();
	wait(0.05);
}

/*
	Name: function_ff90a1ba
	Namespace: namespace_7550a904
	Checksum: 0xD18BF0EF
	Offset: 0x7600
	Size: 0x1F9
	Parameters: 1
	Flags: None
*/
function function_ff90a1ba(b_upgraded)
{
	var_c746b61a = struct::get_array(self.target, "targetname");
	foreach(s_attackable in var_c746b61a)
	{
		if(b_upgraded == 1 && s_attackable.script_noteworthy === "attackable_upgraded")
		{
			break;
			continue;
		}
		if(s_attackable.script_noteworthy === "attackable")
		{
			break;
		}
	}
	s_attackable zm_attackables::activate();
	self.s_plant.s_attackable = s_attackable;
	s_attackable.b_deferred_deactivation = 1;
	self thread function_813b723b();
	self thread function_4bc7c145(b_upgraded);
	s_attackable waittill("attackable_deactivated");
	self notify("hash_4729ad2");
	self.s_plant.model notify("hash_9ed7f404");
	self.s_plant.model waittill("hash_cf8d499a");
	self.s_plant.s_attackable zm_attackables::deactivate();
	self.s_plant.s_attackable.b_deferred_deactivation = undefined;
	self.s_plant.s_attackable = undefined;
}

/*
	Name: function_813b723b
	Namespace: namespace_7550a904
	Checksum: 0x7D07D32D
	Offset: 0x7808
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function function_813b723b()
{
	self endon("hash_4729ad2");
	n_damage_amount = self.s_plant.s_attackable.health / 5;
	while(1)
	{
		level waittill("end_of_round");
		self.s_plant.s_attackable zm_attackables::do_damage(n_damage_amount);
	}
}

/*
	Name: function_4bc7c145
	Namespace: namespace_7550a904
	Checksum: 0x25BE3AB1
	Offset: 0x7888
	Size: 0x8F
	Parameters: 1
	Flags: None
*/
function function_4bc7c145(b_upgraded)
{
	if(b_upgraded)
	{
		var_922fc340 = 1280;
	}
	else
	{
		var_922fc340 = 1180;
	}
	if(level.round_number <= 30)
	{
		self.s_plant.s_attackable.health = var_922fc340 * level.round_number;
	}
	else
	{
		self.s_plant.s_attackable.health = var_922fc340 * 30;
	}
}

/*
	Name: function_2870d1b8
	Namespace: namespace_7550a904
	Checksum: 0xC65364E6
	Offset: 0x7920
	Size: 0x66F
	Parameters: 1
	Flags: None
*/
function function_2870d1b8(var_f40460f5)
{
	self endon("hash_4729ad2");
	if(!isdefined(self.var_b17878ae))
	{
		var_99098466 = [];
		var_70e1ee03 = GetStartOrigin(self.origin, self.angles, "ai_zm_dlc2_zombie_dth_plant_trap_front");
		var_99098466["front"] = var_70e1ee03;
		var_ce06045f = GetStartOrigin(self.origin, self.angles, "ai_zm_dlc2_zombie_dth_plant_trap_back");
		var_99098466["back"] = var_ce06045f;
		var_778b0569 = GetStartOrigin(self.origin, self.angles, "ai_zm_dlc2_zombie_dth_plant_trap_left");
		var_99098466["left"] = var_778b0569;
		var_9d6b7614 = GetStartOrigin(self.origin, self.angles, "ai_zm_dlc2_zombie_dth_plant_trap_right");
		var_99098466["right"] = var_9d6b7614;
		var_e7fb417b = [];
		foreach(v_pos in var_99098466)
		{
			if(IsPointOnNavMesh(v_pos))
			{
				var_e7fb417b[key] = v_pos;
			}
		}
		/#
			Assert(var_e7fb417b.size > 0);
		#/
		self.var_b17878ae = var_e7fb417b;
	}
	while(1)
	{
		var_f19144da = [];
		var_566f2991 = undefined;
		a_enemy_ai = GetAITeamArray("axis");
		foreach(ai in a_enemy_ai)
		{
			if(isalive(ai) && ai istouching(self.s_plant.trigger))
			{
				var_f19144da[var_f19144da.size] = ai;
			}
		}
		foreach(player in level.activePlayers)
		{
			if(isdefined(player) && player istouching(self.s_plant.trigger))
			{
				var_f19144da[var_f19144da.size] = player;
			}
		}
		if(var_f19144da.size == 0)
		{
			wait(0.1);
			continue;
		}
		n_dist_closest = undefined;
		var_d0aaf7a2 = undefined;
		var_121609e = undefined;
		foreach(v_pos in self.var_b17878ae)
		{
			e_target = ArrayGetClosest(v_pos, var_f19144da);
			n_dist = Distance2DSquared(v_pos, e_target.origin);
			if(!isdefined(n_dist_closest))
			{
				n_dist_closest = n_dist;
				var_d0aaf7a2 = e_target;
				var_121609e = key;
				continue;
			}
			if(n_dist < n_dist_closest)
			{
				n_dist_closest = n_dist;
				var_d0aaf7a2 = e_target;
				var_121609e = key;
			}
		}
		var_566f2991 = var_d0aaf7a2;
		if(isdefined(var_566f2991))
		{
			if(isPlayer(var_566f2991) || (isdefined(var_566f2991.b_is_thrasher) && var_566f2991.b_is_thrasher))
			{
				self function_fa3e7444(var_121609e);
			}
			else if(isdefined(var_566f2991.b_is_spider) && var_566f2991.b_is_spider)
			{
				var_2202a6b5 = self function_32c5773c(var_566f2991, var_121609e);
				if(var_2202a6b5 == 0)
				{
					wait(0.05);
					continue;
				}
			}
			else
			{
				var_2202a6b5 = self function_6b938a09(var_566f2991, var_121609e);
				if(var_2202a6b5 == 0)
				{
					wait(0.05);
					continue;
				}
			}
			wait(0.5);
		}
		else
		{
			wait(0.05);
		}
	}
}

/*
	Name: function_fa3e7444
	Namespace: namespace_7550a904
	Checksum: 0x98CDB12F
	Offset: 0x7F98
	Size: 0x12D
	Parameters: 1
	Flags: None
*/
function function_fa3e7444(var_121609e)
{
	switch(var_121609e)
	{
		case "front":
		{
			self thread scene::Play("zm_dlc2_plant_trap_attack_no_target_front", self.s_plant.model);
			break;
		}
		case "back":
		{
			self thread scene::Play("zm_dlc2_plant_trap_attack_no_target_back", self.s_plant.model);
			break;
		}
		case "left":
		{
			self thread scene::Play("zm_dlc2_plant_trap_attack_no_target_left", self.s_plant.model);
			break;
		}
		case "right":
		{
			self thread scene::Play("zm_dlc2_plant_trap_attack_no_target_right", self.s_plant.model);
			break;
		}
	}
	self thread function_7f34488a(var_121609e);
	self.s_plant.model waittill("hash_4ce89178");
}

/*
	Name: function_6b938a09
	Namespace: namespace_7550a904
	Checksum: 0x917ED995
	Offset: 0x80D0
	Size: 0x375
	Parameters: 2
	Flags: None
*/
function function_6b938a09(var_d0aaf7a2, var_121609e)
{
	var_73dc61d6 = Array(self.s_plant.model, var_d0aaf7a2);
	var_d0aaf7a2.var_7d79a6 = 1;
	var_d0aaf7a2 thread function_79faa463(self);
	var_d0aaf7a2 PushActors(0);
	b_crawler = 0;
	if(isdefined(var_d0aaf7a2.missingLegs) && var_d0aaf7a2.missingLegs)
	{
		b_crawler = 1;
	}
	b_attack = 1;
	switch(var_121609e)
	{
		case "front":
		{
			str_crawler_anim_name = "ai_zm_dlc2_zombie_crawl_dth_plant_trap_front";
			str_anim_name = "ai_zm_dlc2_zombie_dth_plant_trap_front";
			str_crawler_scene_name = "zm_dlc2_plant_trap_attack_crawler_front";
			str_scene_name = "zm_dlc2_plant_trap_attack_front";
			break;
		}
		case "back":
		{
			str_crawler_anim_name = "ai_zm_dlc2_zombie_crawl_dth_plant_trap_back";
			str_anim_name = "ai_zm_dlc2_zombie_dth_plant_trap_back";
			str_crawler_scene_name = "zm_dlc2_plant_trap_attack_crawler_back";
			str_scene_name = "zm_dlc2_plant_trap_attack_back";
			break;
		}
		case "left":
		{
			str_crawler_anim_name = "ai_zm_dlc2_zombie_crawl_dth_plant_trap_left";
			str_anim_name = "ai_zm_dlc2_zombie_dth_plant_trap_left";
			str_crawler_scene_name = "zm_dlc2_plant_trap_attack_crawler_left";
			str_scene_name = "zm_dlc2_plant_trap_attack_left";
			break;
		}
		case "right":
		{
			str_crawler_anim_name = "ai_zm_dlc2_zombie_crawl_dth_plant_trap_right";
			str_anim_name = "ai_zm_dlc2_zombie_dth_plant_trap_right";
			str_crawler_scene_name = "zm_dlc2_plant_trap_attack_crawler_right";
			str_scene_name = "zm_dlc2_plant_trap_attack_right";
			break;
		}
	}
	if(b_crawler == 1)
	{
		var_d0aaf7a2 thread function_160d5071(self, str_crawler_anim_name);
	}
	else
	{
		var_d0aaf7a2 thread function_374f973e(self, str_crawler_anim_name);
		var_d0aaf7a2 thread function_160d5071(self, str_anim_name);
	}
	var_d0aaf7a2 util::waittill_any("death", "zombie_reached_anim_spot");
	if(isalive(var_d0aaf7a2))
	{
		if(isdefined(var_d0aaf7a2.missingLegs) && var_d0aaf7a2.missingLegs)
		{
			self thread scene::Play(str_crawler_scene_name, var_73dc61d6);
			self thread function_7f34488a(var_121609e, 1);
		}
		else
		{
			self thread scene::Play(str_scene_name, var_73dc61d6);
			self thread function_7f34488a(var_121609e);
		}
	}
	else
	{
		b_attack = 0;
		return b_attack;
	}
	self.s_plant.model waittill("hash_4ce89178");
	return b_attack;
}

/*
	Name: function_79faa463
	Namespace: namespace_7550a904
	Checksum: 0x639EB625
	Offset: 0x8450
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function function_79faa463(s_plant)
{
	self endon("death");
	s_plant waittill("hash_4729ad2");
	if(isalive(self))
	{
		self.var_7d79a6 = 0;
	}
}

/*
	Name: function_374f973e
	Namespace: namespace_7550a904
	Checksum: 0x24F12CE9
	Offset: 0x84A0
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function function_374f973e(s_plant, str_crawler_anim_name)
{
	self endon("death");
	self endon("zombie_reached_anim_spot");
	s_plant endon("hash_4729ad2");
	while(1)
	{
		if(isdefined(self.missingLegs) && self.missingLegs)
		{
			self notify("hash_e9a97726");
			self thread function_160d5071(s_plant, str_crawler_anim_name);
			break;
		}
		wait(0.05);
	}
}

/*
	Name: function_32c5773c
	Namespace: namespace_7550a904
	Checksum: 0x73A6F9BC
	Offset: 0x8538
	Size: 0x1DD
	Parameters: 2
	Flags: None
*/
function function_32c5773c(var_d0aaf7a2, var_121609e)
{
	var_73dc61d6 = Array(self.s_plant.model, var_d0aaf7a2);
	var_d0aaf7a2.var_7d79a6 = 1;
	var_d0aaf7a2 thread function_79faa463(self);
	b_attack = 1;
	switch(var_121609e)
	{
		case "front":
		{
			str_anim_name = "ai_zm_dlc2_spider_dth_plant_trap_front";
			str_scene_name = "zm_dlc2_plant_trap_attack_spider_front";
			break;
		}
		case "back":
		{
			str_anim_name = "ai_zm_dlc2_spider_dth_plant_trap_back";
			str_scene_name = "zm_dlc2_plant_trap_attack_spider_back";
			break;
		}
		case "left":
		{
			str_anim_name = "ai_zm_dlc2_spider_dth_plant_trap_left";
			str_scene_name = "zm_dlc2_plant_trap_attack_spider_left";
			break;
		}
		case "right":
		{
			str_anim_name = "ai_zm_dlc2_spider_dth_plant_trap_right";
			str_scene_name = "zm_dlc2_plant_trap_attack_spider_right";
			break;
		}
	}
	var_d0aaf7a2 function_40428876(self, str_anim_name);
	if(isalive(var_d0aaf7a2))
	{
		self thread scene::Play(str_scene_name, var_73dc61d6);
		self thread function_7f34488a(var_121609e, 1);
	}
	else
	{
		b_attack = 0;
		return b_attack;
	}
	self.s_plant.model waittill("hash_4ce89178");
	return b_attack;
}

/*
	Name: function_9e124689
	Namespace: namespace_7550a904
	Checksum: 0x11794351
	Offset: 0x8720
	Size: 0x223
	Parameters: 1
	Flags: None
*/
function function_9e124689(a_ents)
{
	e_target = a_ents["zombie"];
	e_plant = a_ents["plant_trap"];
	e_plant flag::set("trap_plant_attacking");
	e_plant util::waittill_any("spawn_head", "plant_melee");
	if(isalive(e_target))
	{
		self thread function_e6f615b3(e_target);
		var_fdbb0645 = e_target.head + "_prop";
		GibServerUtils::GibHead(e_target);
		e_target DoDamage(e_target.health, e_target.origin);
		v_org = e_plant GetTagOrigin("tag_plant_grab");
		v_angles = e_plant GetTagAngles("tag_plant_grab");
		var_c40b12dc = util::spawn_model(var_fdbb0645, v_org, v_angles);
		var_c40b12dc LinkTo(e_plant, "tag_plant_grab");
		e_plant waittill("hash_af56254a");
		var_c40b12dc delete();
	}
	e_plant waittill("hash_350a84f");
	e_plant flag::clear("trap_plant_attacking");
	e_plant notify("hash_4ce89178");
}

/*
	Name: function_b1a9e247
	Namespace: namespace_7550a904
	Checksum: 0xF627844A
	Offset: 0x8950
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function function_b1a9e247(a_ents)
{
	e_target = a_ents["spider"];
	e_plant = a_ents["plant_trap"];
	e_plant flag::set("trap_plant_attacking");
	e_plant waittill("spawn_head");
	if(isalive(e_target))
	{
		self thread function_e6f615b3(e_target);
		e_target DoDamage(e_target.health, e_target.origin);
	}
	e_plant waittill("hash_350a84f");
	e_plant flag::clear("trap_plant_attacking");
	e_plant notify("hash_4ce89178");
}

/*
	Name: function_e6f615b3
	Namespace: namespace_7550a904
	Checksum: 0x4199E8EA
	Offset: 0x8A60
	Size: 0xB9
	Parameters: 1
	Flags: None
*/
function function_e6f615b3(e_target)
{
	level thread zm_island_vo::function_1e767f71(self.s_plant.model, 600, "trap", "plant_kill", 60, 0, 2);
	if(zm_utility::is_player_valid(self.var_561a9c48))
	{
		self.var_561a9c48 notify("hash_e6f615b3");
		self.var_561a9c48 notify("trap_plant_killed_" + e_target.archetype);
	}
	if(isdefined(self.var_e7abf7d0) && self.var_e7abf7d0)
	{
		level notify("hash_8c54f723");
	}
}

/*
	Name: function_7f34488a
	Namespace: namespace_7550a904
	Checksum: 0xAC28CBC0
	Offset: 0x8B28
	Size: 0x311
	Parameters: 2
	Flags: None
*/
function function_7f34488a(str_loc, var_23237415)
{
	if(!isdefined(var_23237415))
	{
		var_23237415 = 0;
	}
	self.s_plant.model util::waittill_any("spawn_head", "plant_melee");
	v_org = self.var_b17878ae[str_loc];
	foreach(player in level.players)
	{
		if(var_23237415 == 0)
		{
			str_stance = player GetStance();
			if(str_stance != "stand")
			{
				continue;
			}
		}
		n_dist = Distance2DSquared(player.origin, v_org);
		if(n_dist < 2304)
		{
			player DoDamage(50, player.origin);
			player PlayRumbleOnEntity("damage_light");
			player zm_island_vo::function_1881817("trap", "plant_attacked", 10, 3);
		}
	}
	a_enemy_ai = GetAITeamArray("axis");
	foreach(ai in a_enemy_ai)
	{
		if(isdefined(ai.b_is_thrasher) && ai.b_is_thrasher)
		{
			n_dist = Distance2DSquared(ai.origin, v_org);
			if(n_dist < 2304)
			{
				n_damage = ai.maxhealth * 0.25;
				ai DoDamage(n_damage, ai.origin);
			}
		}
	}
}

/*
	Name: function_2df6714
	Namespace: namespace_7550a904
	Checksum: 0x826C0F7B
	Offset: 0x8E48
	Size: 0x25
	Parameters: 1
	Flags: None
*/
function function_2df6714(a_ents)
{
	a_ents["plant_trap"] notify("hash_2df6714");
}

/*
	Name: function_869faee7
	Namespace: namespace_7550a904
	Checksum: 0x6C3E1AF3
	Offset: 0x8E78
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function function_869faee7()
{
	level.func_clone_plant_respawn = &func_clone_plant_respawn;
	level.check_end_solo_game_override = &check_end_solo_game_override;
	level.var_50d5cc84 = 0;
}

/*
	Name: function_3e429652
	Namespace: namespace_7550a904
	Checksum: 0xF12A8874
	Offset: 0x8EC0
	Size: 0x413
	Parameters: 0
	Flags: None
*/
function function_3e429652()
{
	/#
		println("Dev Block strings are not supported");
	#/
	level.var_50d5cc84++;
	if(isdefined(self.var_561a9c48))
	{
		self.var_561a9c48 notify("hash_aa62194d");
	}
	level notify("hash_aa62194d");
	self.s_plant.model SetModel("p7_fxanim_zm_island_plant_clone_grow_mod");
	self.s_plant.model show();
	self.s_plant.model solid();
	self.s_plant.model disconnectpaths();
	self thread scene::init("p7_fxanim_zm_island_plant_clone_grow1_bundle", self.s_plant.model);
	self.s_plant.model waittill("hash_83d08c0f");
	self thread function_b78c42da();
	self waittill("hash_f7fd4ace", e_player);
	zm_unitrigger::unregister_unitrigger(self.var_23c5e7a6);
	self.var_23c5e7a6 = undefined;
	level zm_utility::increment_no_end_game_check();
	e_player thread function_15142bc5(self);
	e_player zm_island_vo::function_7f4cb4c("clone", "imprint", 1);
	self thread scene::Play("p7_fxanim_zm_island_plant_clone_grow1_bundle", self.s_plant.model);
	str_notify = e_player util::waittill_any_return("player_clone_spawned", "clone_plant_overwritten", "disconnect");
	level zm_utility::decrement_no_end_game_check();
	if(isdefined(e_player) && str_notify == "player_clone_spawned")
	{
		self function_14d216b1(e_player);
	}
	self.s_plant.model clientfield::set("plant_growth_siege_anims", 0);
	self.s_plant.model SetModel("p7_fxanim_zm_island_plant_clone_pop_mod");
	self.s_plant.model notsolid();
	self scene::Play("p7_fxanim_zm_island_plant_clone_pop_bundle", self.s_plant.model);
	if(isdefined(e_player) && str_notify == "player_clone_spawned")
	{
		visionset_mgr::deactivate("visionset", "zm_isl_thrasher_stomach_visionset", e_player);
		e_player clientfield::set_to_player("player_spawned_from_clone_plant", 0);
		e_player clientfield::set_to_player("player_cloned_fx", 0);
		wait(3);
		if(isdefined(e_player))
		{
			e_player zm_utility::decrement_ignoreme();
			e_player.var_6e61a720 = undefined;
		}
	}
	wait(0.05);
	self.s_plant.model StopAnimScripted();
	wait(0.05);
}

/*
	Name: function_14d216b1
	Namespace: namespace_7550a904
	Checksum: 0x84D3171E
	Offset: 0x92E0
	Size: 0x26B
	Parameters: 1
	Flags: None
*/
function function_14d216b1(e_player)
{
	e_player endon("disconnect");
	e_player.var_6e61a720 = 1;
	e_player LUI::screen_fade_out(0.1);
	e_player zm_utility::increment_ignoreme();
	e_player clientfield::set_to_player("player_spawned_from_clone_plant", 1);
	e_player clientfield::set_to_player("player_cloned_fx", 1);
	visionset_mgr::activate("visionset", "zm_isl_thrasher_stomach_visionset", e_player, 2);
	e_player ghost();
	self thread scene::Play("p_zom_plant_exit_bundle", e_player);
	wait(0.1);
	self.s_plant.model HidePart("clone_body_jnt", "p7_fxanim_zm_island_plant_clone_grow_mod", 1);
	e_player show();
	e_player LUI::screen_fade_in(1);
	e_player util::waittill_any_timeout(5, "disconnect", "player_emerge_from_clone_plant");
	e_player thread function_cbb90d18();
	self.s_plant.model ShowPart("clone_body_jnt", "p7_fxanim_zm_island_plant_clone_grow_mod", 1);
	if(isdefined(e_player) && (isdefined(level.var_5258ba34) && level.var_5258ba34))
	{
		if(zm_utility::is_player_valid(e_player) && e_player zm_zonemgr::entity_in_active_zone())
		{
			e_player waittill("player_emerge_from_clone_plant_complete");
			e_player zm_island_takeo_fight::function_75275516();
		}
	}
}

/*
	Name: function_cbb90d18
	Namespace: namespace_7550a904
	Checksum: 0x2E740FF5
	Offset: 0x9558
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_cbb90d18()
{
	self endon("disconnect");
	self waittill("player_emerge_from_clone_plant_complete");
	self zm_island_vo::function_cf8fccfe(0);
	self zm_island_vo::function_7f4cb4c("clone", "cloned", 1);
}

/*
	Name: function_b78c42da
	Namespace: namespace_7550a904
	Checksum: 0xE967366C
	Offset: 0x95C0
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function function_b78c42da()
{
	s_plant_unitrigger = spawnstruct();
	s_plant_unitrigger.origin = self.origin + VectorScale((0, 0, 1), 8);
	s_plant_unitrigger.angles = self.angles;
	s_plant_unitrigger.s_parent = self;
	s_plant_unitrigger.script_unitrigger_type = "unitrigger_box_use";
	s_plant_unitrigger.cursor_hint = "HINT_NOICON";
	s_plant_unitrigger.require_look_at = 1;
	s_plant_unitrigger.script_width = 100;
	s_plant_unitrigger.script_length = 100;
	s_plant_unitrigger.script_height = 150;
	s_plant_unitrigger.prompt_and_visibility_func = &function_d4d40251;
	zm_unitrigger::register_static_unitrigger(s_plant_unitrigger, &function_7756fe45);
	self.var_23c5e7a6 = s_plant_unitrigger;
	self.s_plant flag::clear("plant_interact_trigger_used");
}

/*
	Name: function_d4d40251
	Namespace: namespace_7550a904
	Checksum: 0x608A5066
	Offset: 0x9718
	Size: 0x171
	Parameters: 1
	Flags: None
*/
function function_d4d40251(e_player)
{
	if(e_player zm_utility::in_revive_trigger())
	{
		self setHintString(&"");
		return 0;
	}
	if(e_player.IS_DRINKING > 0)
	{
		self setHintString(&"");
		return 0;
	}
	if(!zm_utility::is_player_valid(e_player))
	{
		self setHintString(&"");
		return 0;
	}
	if(!e_player zm_magicbox::can_buy_weapon())
	{
		self setHintString(&"");
		return 0;
	}
	if(self.stub.s_parent.s_plant flag::get("plant_interact_trigger_used"))
	{
		self setHintString(&"");
		return 0;
	}
	else
	{
		self setHintString(&"ZM_ISLAND_CLONE_PLANT");
		return 1;
	}
}

/*
	Name: function_7756fe45
	Namespace: namespace_7550a904
	Checksum: 0x2375BC9E
	Offset: 0x9898
	Size: 0xF1
	Parameters: 0
	Flags: None
*/
function function_7756fe45()
{
	while(1)
	{
		self waittill("trigger", e_who);
		if(e_who zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(e_who.IS_DRINKING > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(e_who))
		{
			continue;
		}
		if(!e_who zm_magicbox::can_buy_weapon())
		{
			continue;
		}
		self.stub.s_parent notify("hash_f7fd4ace", e_who);
		self.stub.s_parent.s_plant flag::set("plant_interact_trigger_used");
		return;
	}
}

/*
	Name: function_15142bc5
	Namespace: namespace_7550a904
	Checksum: 0x3790853D
	Offset: 0x9998
	Size: 0x57B
	Parameters: 1
	Flags: None
*/
function function_15142bc5(s_plant)
{
	self endon("disconnect");
	if(isdefined(self.s_clone_plant))
	{
		self notify("clone_plant_overwritten");
	}
	self.s_clone_plant = s_plant;
	self.var_5942b967 = spawnstruct();
	if(isdefined(self.perks_active))
	{
		self.var_5942b967.a_perks = [];
		foreach(perk in self.perks_active)
		{
			Array::add(self.var_5942b967.a_perks, perk, 0);
		}
	}
	else if(bgb::is_enabled("zm_bgb_disorderly_combat") && isdefined(self.var_fe555a38))
	{
		self.var_5942b967.w_current_weapon = self.var_fe555a38;
	}
	else
	{
		self.var_5942b967.w_current_weapon = self GetCurrentWeapon();
	}
	self.var_5942b967.AAT = self.AAT;
	self.var_5942b967.b_has_skull = 0;
	var_c5716cdc = self GetWeaponsList(1);
	self.var_5942b967.a_weapons = [];
	foreach(weapon in var_c5716cdc)
	{
		if(bgb::is_enabled("zm_bgb_disorderly_combat"))
		{
			if(self.var_8cee13f3 === weapon)
			{
				continue;
			}
		}
		w_alt = zm_weapons::get_nonalternate_weapon(weapon);
		if(weapon != w_alt)
		{
			continue;
		}
		if(weapon == level.var_c003f5b)
		{
			self.var_5942b967.b_has_skull = 1;
			self.var_5942b967.var_64d58722 = self GadgetPowerGet(0);
			continue;
		}
		n_index = self.var_5942b967.a_weapons.size;
		self.var_5942b967.a_weapons[n_index] = spawnstruct();
		self.var_5942b967.a_weapons[n_index].weapon = weapon;
		self.var_5942b967.a_weapons[n_index].clip_amt = self GetWeaponAmmoClip(weapon);
		self.var_5942b967.a_weapons[n_index].left_clip_amt = 0;
		var_bc62c240 = weapon.dualWieldWeapon;
		if(level.weaponNone != var_bc62c240)
		{
			self.var_5942b967.a_weapons[n_index].left_clip_amt = self GetWeaponAmmoClip(var_bc62c240);
		}
		self.var_5942b967.a_weapons[n_index].stock_amt = self GetWeaponAmmoStock(weapon);
	}
	self.var_5942b967.n_score = self.score;
	self.var_5942b967.bgb = self.bgb;
	self.var_5942b967.b_has_bucket = self clientfield::get_to_player("bucket_held");
	if(!self.var_5942b967.b_has_bucket)
	{
		self.var_5942b967.var_bb2fd41c = 0;
		self.var_5942b967.var_c6cad973 = 0;
	}
	else
	{
		self.var_5942b967.var_bb2fd41c = self.var_bb2fd41c;
		self.var_5942b967.var_c6cad973 = self.var_c6cad973;
	}
	self.var_5942b967.n_seed_count = zm_powerup_island_seed::function_735cfef2(self);
	self.var_5942b967.var_1493e376 = self.has_gasmask;
}

/*
	Name: func_clone_plant_respawn
	Namespace: namespace_7550a904
	Checksum: 0x54AAEC76
	Offset: 0x9F20
	Size: 0x861
	Parameters: 0
	Flags: None
*/
function func_clone_plant_respawn()
{
	self endon("disconnect");
	self thread zm_island_vo::function_cf8fccfe(1);
	if(isdefined(self.thrasherConsumed) && self.thrasherConsumed)
	{
		ThrasherServerUtils::thrasherReleasePlayer(self.thrasher, self);
	}
	self notify("stop_revive_trigger");
	wait(0.05);
	self SetOrigin(self.s_clone_plant.origin);
	self SetPlayerAngles(self.s_clone_plant.angles);
	self.s_clone_plant = undefined;
	self zm_laststand::auto_revive(self);
	wait(0.05);
	/#
		Assert(isdefined(self.var_5942b967));
	#/
	if(isdefined(self.var_5942b967.a_perks))
	{
		foreach(perk in self.var_5942b967.a_perks)
		{
			self zm_perks::give_perk(perk);
		}
	}
	/#
		Assert(isdefined(self.var_5942b967.a_weapons));
	#/
	/#
		Assert(isdefined(self.var_5942b967.w_current_weapon));
	#/
	var_c5716cdc = self GetWeaponsList(1);
	foreach(weapon in var_c5716cdc)
	{
		if(weapon == level.var_c003f5b)
		{
			self zm_weapons::weapon_take(weapon);
			self zm_hero_weapon::set_hero_weapon_state(level.var_c003f5b, 0);
			self thread zm_island_skullquest::function_29d2aa0e(0, undefined, 0);
			self notify("watch_hero_weapon_take");
			self notify("stop_watch_hero_power");
			self notify("watch_hero_weapon_give");
			self notify("watch_hero_weapon_change");
			self notify("watch_hero_power");
			self notify("stop_draining_hero_weapon");
			self zm_hero_weapon::on_player_spawned();
			continue;
		}
		self zm_weapons::weapon_take(weapon);
	}
	foreach(s_info in self.var_5942b967.a_weapons)
	{
		if(s_info.weapon.isRiotShield)
		{
			self.do_not_display_equipment_pickup_hint = 1;
			self thread function_da2cdc7f();
			self zm_equipment::give(s_info.weapon);
			if(isdefined(self.player_shield_reset_health))
			{
				self [[self.player_shield_reset_health]]();
			}
			continue;
		}
		weapon = self zm_weapons::give_build_kit_weapon(s_info.weapon.rootweapon);
		self SetWeaponAmmoClip(weapon, s_info.clip_amt);
		var_bc62c240 = weapon.dualWieldWeapon;
		if(level.weaponNone != var_bc62c240)
		{
			self SetWeaponAmmoClip(var_bc62c240, s_info.left_clip_amt);
		}
		self SetWeaponAmmoStock(weapon, s_info.stock_amt);
		a_keys = getArrayKeys(self.var_5942b967.AAT);
		if(IsInArray(a_keys, weapon))
		{
			self AAT::acquire(weapon, self.var_5942b967.AAT[weapon]);
		}
	}
	if(self.var_5942b967.b_has_skull == 1)
	{
		self thread function_a0e11c4();
	}
	self SwitchToWeapon(self.var_5942b967.w_current_weapon);
	/#
		Assert(isdefined(self.var_5942b967.n_score));
	#/
	self.score = self.var_5942b967.n_score;
	self.pers["score"] = self.score;
	__protected__setbgbunlocked(1);
	self bgb::function_d35f60a1(self.var_5942b967.bgb);
	__protected__setbgbunlocked(0);
	/#
		Assert(isdefined(self.var_5942b967.b_has_bucket));
	#/
	if(!self.var_5942b967.b_has_bucket && self clientfield::get_to_player("bucket_held"))
	{
		self notify("clone_plant_bucket_lost");
	}
	else
	{
		self.var_bb2fd41c = self.var_5942b967.var_bb2fd41c;
		self.var_c6cad973 = self.var_5942b967.var_c6cad973;
		self namespace_f3e3de78::function_ef097ea(self.var_c6cad973, self.var_bb2fd41c, self namespace_f3e3de78::function_89538fbb(), 1);
	}
	/#
		Assert(isdefined(self.var_5942b967.n_seed_count));
	#/
	self zm_powerup_island_seed::function_aeda54f6(self.var_5942b967.n_seed_count);
	/#
		Assert(isdefined(self.var_5942b967.var_1493e376));
	#/
	self.has_gasmask = self.var_5942b967.var_1493e376;
	if(!self.has_gasmask)
	{
		self notify("player_lost_gasmask");
	}
	else
	{
		self notify("player_has_gasmask");
	}
	self notify("player_clone_spawned");
	self notify("hash_6c52e305");
	self.var_5942b967 = undefined;
}

/*
	Name: function_da2cdc7f
	Namespace: namespace_7550a904
	Checksum: 0xE18E7C56
	Offset: 0xA790
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_da2cdc7f()
{
	self endon("disconnect");
	wait(1);
	self.do_not_display_equipment_pickup_hint = 0;
}

/*
	Name: function_a0e11c4
	Namespace: namespace_7550a904
	Checksum: 0x39F8AB85
	Offset: 0xA7C0
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function function_a0e11c4()
{
	self endon("disconnect");
	self zm_weapons::weapon_give(level.var_c003f5b, undefined, undefined, 1);
	self GadgetPowerSet(0, self.var_5942b967.var_64d58722);
	self SetWeaponAmmoClip(level.var_c003f5b, 0);
	power = self GadgetPowerGet(0);
	if(power < 100)
	{
		self zm_hero_weapon::set_hero_weapon_state(level.var_c003f5b, 1);
	}
	else
	{
		self zm_hero_weapon::set_hero_weapon_state(level.var_c003f5b, 2);
	}
	self thread zm_island_skullquest::function_29d2aa0e(3, undefined, 0);
	self thread zm_hero_weapon::watch_hero_weapon_take();
}

/*
	Name: check_end_solo_game_override
	Namespace: namespace_7550a904
	Checksum: 0x7333FB15
	Offset: 0xA8F8
	Size: 0x1D
	Parameters: 0
	Flags: None
*/
function check_end_solo_game_override()
{
	if(isdefined(self.s_clone_plant))
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

/*
	Name: function_1b391116
	Namespace: namespace_7550a904
	Checksum: 0xE4FE915E
	Offset: 0xA920
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_1b391116()
{
	level.var_5ef907c8 = GetWeapon("fruit_eat_success");
	level.var_8a542f3f = GetWeapon("fruit_eat_fail");
	level thread include_perks_in_random_rotation();
}

/*
	Name: include_perks_in_random_rotation
	Namespace: namespace_7550a904
	Checksum: 0x5D9AE887
	Offset: 0xA988
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function include_perks_in_random_rotation()
{
	zm_perk_random::include_perk_in_random_rotation("specialty_armorvest");
	zm_perk_random::include_perk_in_random_rotation("specialty_quickrevive");
	zm_perk_random::include_perk_in_random_rotation("specialty_fastreload");
	zm_perk_random::include_perk_in_random_rotation("specialty_doubletap2");
	zm_perk_random::include_perk_in_random_rotation("specialty_staminup");
	zm_perk_random::include_perk_in_random_rotation("specialty_additionalprimaryweapon");
	zm_perk_random::include_perk_in_random_rotation("specialty_deadshot");
	zm_perk_random::include_perk_in_random_rotation("specialty_electriccherry");
	zm_perk_random::include_perk_in_random_rotation("specialty_widowswine");
}

/*
	Name: function_fd098f17
	Namespace: namespace_7550a904
	Checksum: 0x7FD194B4
	Offset: 0xAA70
	Size: 0x3BB
	Parameters: 1
	Flags: None
*/
function function_fd098f17(b_upgraded)
{
	if(!isdefined(b_upgraded))
	{
		b_upgraded = 0;
	}
	/#
		if(b_upgraded == 1)
		{
			println("Dev Block strings are not supported");
		}
		else
		{
			println("Dev Block strings are not supported");
		}
	#/
	if(isdefined(self.var_561a9c48))
	{
		self.var_561a9c48 notify("fruit_plant_spawned");
	}
	level notify("fruit_plant_spawned");
	if(b_upgraded == 1)
	{
		var_d583f9d = "p7_fxanim_zm_island_plant_fruit_glow_mod";
	}
	else
	{
		var_d583f9d = "p7_fxanim_zm_island_plant_fruit_mod";
	}
	self.s_plant.model SetModel(var_d583f9d);
	self.s_plant.model show();
	self.s_plant.model solid();
	self.s_plant.model disconnectpaths();
	self thread scene::init("p7_fxanim_zm_island_plant_fruit_bundle", self.s_plant.model);
	self.s_plant.model waittill("hash_334ee3df");
	self thread function_bf89dc95();
	self waittill("hash_f224e16d", e_player);
	zm_unitrigger::unregister_unitrigger(self.var_23c5e7a6);
	self.var_23c5e7a6 = undefined;
	e_player notify("hash_3e1e1a8");
	if(b_upgraded == 1)
	{
		if(e_player zm_utility::can_player_purchase_perk())
		{
			level thread function_cccc72b3(e_player);
		}
		else
		{
			level thread function_cc0c1582(e_player);
		}
	}
	else
	{
		n_chance = RandomFloatRange(0, 100);
		if(n_chance <= 75)
		{
			if(e_player zm_utility::can_player_purchase_perk())
			{
				level thread function_cccc72b3(e_player);
			}
			else
			{
				level thread function_cc0c1582(e_player);
			}
		}
		else
		{
			level thread function_cc0c1582(e_player);
		}
	}
	self.s_plant.model clientfield::set("plant_growth_siege_anims", 0);
	self.s_plant.model HidePart("plant_fruit_stalk_egg_hide_jnt", var_d583f9d);
	self scene::Play("p7_fxanim_zm_island_plant_fruit_bundle", self.s_plant.model);
	self.s_plant.model ShowPart("plant_fruit_stalk_egg_hide_jnt", var_d583f9d);
}

/*
	Name: function_bf89dc95
	Namespace: namespace_7550a904
	Checksum: 0xBE1E2DAD
	Offset: 0xAE38
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function function_bf89dc95()
{
	s_plant_unitrigger = spawnstruct();
	s_plant_unitrigger.origin = self.origin + VectorScale((0, 0, 1), 8);
	s_plant_unitrigger.angles = self.angles;
	s_plant_unitrigger.s_parent = self;
	s_plant_unitrigger.script_unitrigger_type = "unitrigger_box_use";
	s_plant_unitrigger.cursor_hint = "HINT_NOICON";
	s_plant_unitrigger.require_look_at = 1;
	s_plant_unitrigger.script_width = 100;
	s_plant_unitrigger.script_length = 100;
	s_plant_unitrigger.script_height = 150;
	s_plant_unitrigger.prompt_and_visibility_func = &function_7187558;
	zm_unitrigger::register_static_unitrigger(s_plant_unitrigger, &function_c31605a8);
	self.var_23c5e7a6 = s_plant_unitrigger;
	self.s_plant flag::clear("plant_interact_trigger_used");
}

/*
	Name: function_7187558
	Namespace: namespace_7550a904
	Checksum: 0x3078B88
	Offset: 0xAF90
	Size: 0x139
	Parameters: 1
	Flags: None
*/
function function_7187558(e_player)
{
	if(e_player zm_utility::in_revive_trigger())
	{
		self setHintString(&"");
		return 0;
	}
	if(e_player.IS_DRINKING > 0)
	{
		self setHintString(&"");
		return 0;
	}
	if(!zm_utility::is_player_valid(e_player))
	{
		self setHintString(&"");
		return 0;
	}
	if(self.stub.s_parent.s_plant flag::get("plant_interact_trigger_used"))
	{
		self setHintString(&"");
		return 0;
	}
	else
	{
		self setHintString(&"ZM_ISLAND_FRUIT_PLANT");
		return 1;
	}
}

/*
	Name: function_c31605a8
	Namespace: namespace_7550a904
	Checksum: 0x6A0ECD42
	Offset: 0xB0D8
	Size: 0xD1
	Parameters: 0
	Flags: None
*/
function function_c31605a8()
{
	while(1)
	{
		self waittill("trigger", e_who);
		if(e_who zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(e_who.IS_DRINKING > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(e_who))
		{
			continue;
		}
		self.stub.s_parent notify("hash_f224e16d", e_who);
		self.stub.s_parent.s_plant flag::set("plant_interact_trigger_used");
		return;
	}
}

/*
	Name: function_cccc72b3
	Namespace: namespace_7550a904
	Checksum: 0x848D92F
	Offset: 0xB1B8
	Size: 0xCF
	Parameters: 1
	Flags: None
*/
function function_cccc72b3(e_player)
{
	e_player endon("disconnect");
	e_player function_3d33e23e(1);
	random_perk = zm_perk_random::get_weighted_random_perk(e_player);
	e_player thread zm_perks::wait_give_perk(random_perk);
	e_player notify("hash_7285e7d");
	/#
		println("Dev Block strings are not supported" + random_perk);
	#/
	e_player notify("player_ate_fruit_success");
	e_player notify("perk_purchased", random_perk);
}

/*
	Name: function_cc0c1582
	Namespace: namespace_7550a904
	Checksum: 0x5B204824
	Offset: 0xB290
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function function_cc0c1582(e_player)
{
	e_player endon("disconnect");
	/#
		println("Dev Block strings are not supported");
	#/
	e_player thread function_3d33e23e(0);
	e_player thread zm_island_vo::function_6fc10b64();
	e_player GiveAchievement("ZM_ISLAND_EAT_FRUIT");
}

/*
	Name: function_3d33e23e
	Namespace: namespace_7550a904
	Checksum: 0x69C98371
	Offset: 0xB320
	Size: 0xE5
	Parameters: 1
	Flags: None
*/
function function_3d33e23e(b_success)
{
	if(!isdefined(b_success))
	{
		b_success = 1;
	}
	self endon("disconnect");
	self thread function_afacd209();
	self.var_db9c1f55 = 0;
	self thread function_7a0f914c(b_success);
	self util::waittill_any("fake_death", "death", "player_downed", "weapon_change_complete", "player_cancel_fruit_eat");
	self function_37e9f650(b_success);
	var_7cf98153 = undefined;
	self.var_db9c1f55 = 0;
	self notify("hash_68922ea0");
}

/*
	Name: function_afacd209
	Namespace: namespace_7550a904
	Checksum: 0x14F0AEDB
	Offset: 0xB410
	Size: 0x59
	Parameters: 0
	Flags: None
*/
function function_afacd209()
{
	self endon("disconnect");
	self endon("hash_68922ea0");
	self waittill("player_eaten_by_thrasher");
	if(self.IS_DRINKING > 0)
	{
		self zm_utility::decrement_is_drinking();
	}
	self notify("hash_68922ea0");
}

/*
	Name: function_7a0f914c
	Namespace: namespace_7550a904
	Checksum: 0x438E861D
	Offset: 0xB478
	Size: 0x1C3
	Parameters: 1
	Flags: None
*/
function function_7a0f914c(b_success)
{
	self endon("disconnect");
	if(!self.IS_DRINKING > 0)
	{
		self zm_utility::increment_is_drinking();
	}
	w_original = self GetCurrentWeapon();
	w_fruit = function_d60b4013(b_success);
	if(w_original != level.weaponNone && (!isdefined(zm_utility::is_placeable_mine(w_original)) && zm_utility::is_placeable_mine(w_original)) && (!isdefined(zm_equipment::is_equipment(w_original)) && zm_equipment::is_equipment(w_original)) && (!isdefined(self zm_laststand::is_reviving_any()) && self zm_laststand::is_reviving_any()) && (!isdefined(self laststand::player_is_in_laststand()) && self laststand::player_is_in_laststand()))
	{
		self.original_weapon = w_original;
	}
	else
	{
		self notify("player_cancel_fruit_eat");
		return;
	}
	self.var_db9c1f55 = 1;
	self zm_utility::disable_player_move_states(1);
	self GiveWeapon(w_fruit);
	self SwitchToWeapon(w_fruit);
}

/*
	Name: function_37e9f650
	Namespace: namespace_7550a904
	Checksum: 0x49A6513C
	Offset: 0xB648
	Size: 0x1CB
	Parameters: 1
	Flags: None
*/
function function_37e9f650(b_success)
{
	self endon("disconnect");
	self zm_utility::enable_player_move_states();
	w_fruit = function_d60b4013(b_success);
	if(self laststand::player_is_in_laststand() || (isdefined(self.intermission) && self.intermission))
	{
		self TakeWeapon(w_fruit);
		return;
	}
	if(self.IS_DRINKING > 0)
	{
		self zm_utility::decrement_is_drinking();
	}
	a_primaries = self GetWeaponsListPrimaries();
	self TakeWeapon(w_fruit);
	if(self.IS_DRINKING > 0)
	{
		return;
	}
	else if(isdefined(self.original_weapon))
	{
		self SwitchToWeapon(self.original_weapon);
	}
	else if(isdefined(a_primaries) && a_primaries.size > 0)
	{
		self SwitchToWeapon(a_primaries[0]);
	}
	else if(self HasWeapon(level.laststandpistol))
	{
		self SwitchToWeapon(level.laststandpistol);
	}
	else
	{
		self zm_weapons::give_fallback_weapon();
	}
}

/*
	Name: function_d60b4013
	Namespace: namespace_7550a904
	Checksum: 0xA7C656D6
	Offset: 0xB820
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_d60b4013(b_success)
{
	if(b_success == 1)
	{
		w_fruit = level.var_5ef907c8;
	}
	else
	{
		w_fruit = level.var_8a542f3f;
	}
	return w_fruit;
}

/*
	Name: function_5726c670
	Namespace: namespace_7550a904
	Checksum: 0x1E5885FF
	Offset: 0xB870
	Size: 0x183
	Parameters: 1
	Flags: None
*/
function function_5726c670(var_98b687fa)
{
	if(level flag::get("ww_obtained") && !level flag::get("ww_upgrade_spawned_from_plant") && var_98b687fa == 3)
	{
		self.s_plant.model SetModel("p7_fxanim_zm_island_plant_underwater_teal_mod");
		self.s_plant.model show();
		self.s_plant.model solid();
		self.s_plant.model disconnectpaths();
		self scene::Play("p7_fxanim_zm_island_plant_underwater_bundle", self.s_plant.model);
		level flag::set("ww_upgrade_spawned_from_plant");
		level flag::wait_till("wwup3_found");
		self.s_plant.model clientfield::set("plant_growth_siege_anims", 0);
		return;
	}
	else
	{
		return;
	}
}

/*
	Name: dig_up_weapon
	Namespace: namespace_7550a904
	Checksum: 0x43B1911A
	Offset: 0xBA00
	Size: 0x2A7
	Parameters: 3
	Flags: None
*/
function dig_up_weapon(e_digger, wpn_to_spawn, var_c6fcdf22)
{
	if(!isdefined(var_c6fcdf22))
	{
		var_c6fcdf22 = undefined;
	}
	v_spawnpt = self.origin + (0, 0, 40);
	v_spawnang = (0, 0, 0);
	v_angles = e_digger getPlayerAngles();
	v_angles = (0, v_angles[1], 0) + VectorScale((0, 1, 0), 90) + v_spawnang;
	m_weapon = zm_utility::spawn_buildkit_weapon_model(e_digger, wpn_to_spawn, undefined, v_spawnpt, v_angles);
	m_weapon.angles = v_angles;
	m_weapon thread timer_til_despawn(v_spawnpt, 40 * -1);
	m_weapon endon("dig_up_weapon_timed_out");
	m_weapon.trigger = namespace_8aed53c9::spawn_trigger_radius(v_spawnpt, 100, 1);
	m_weapon.trigger.wpn = wpn_to_spawn;
	m_weapon.trigger.prompt_and_visibility_func = &weapon_trigger_update_prompt;
	m_weapon.trigger flag::init("weapon_grabbed_or_timed_out");
	m_weapon.trigger waittill("trigger", player);
	m_weapon notify("weapon_grabbed");
	player thread namespace_8aed53c9::swap_weapon(wpn_to_spawn);
	if(isdefined(m_weapon.trigger))
	{
		m_weapon.trigger flag::set("weapon_grabbed_or_timed_out");
		zm_unitrigger::unregister_unitrigger(m_weapon.trigger);
		m_weapon.trigger = undefined;
	}
	if(isdefined(m_weapon))
	{
		m_weapon delete();
	}
	if(player != e_digger)
	{
		e_digger notify("dig_up_weapon_shared");
	}
}

/*
	Name: timer_til_despawn
	Namespace: namespace_7550a904
	Checksum: 0xC25FB6A6
	Offset: 0xBCB0
	Size: 0x14B
	Parameters: 2
	Flags: None
*/
function timer_til_despawn(v_float, n_dist)
{
	self endon("weapon_grabbed");
	wait(15);
	for(i = 0; i < 40; i++)
	{
		if(i % 2)
		{
			self weapon_show(0);
		}
		else
		{
			self weapon_show(1);
		}
		if(i < 15)
		{
			wait(0.5);
			continue;
		}
		if(i < 25)
		{
			wait(0.25);
			continue;
		}
		wait(0.1);
	}
	self notify("dig_up_weapon_timed_out");
	if(isdefined(self.trigger))
	{
		self.trigger flag::set("weapon_grabbed_or_timed_out");
		zm_unitrigger::unregister_unitrigger(self.trigger);
		self.trigger = undefined;
	}
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: weapon_show
	Namespace: namespace_7550a904
	Checksum: 0x5736AB70
	Offset: 0xBE08
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function weapon_show(visible)
{
	if(!visible)
	{
		self ghost();
		if(isdefined(self.worldgundw))
		{
			self.worldgundw ghost();
		}
	}
	else
	{
		self show();
		if(isdefined(self.worldgundw))
		{
			self.worldgundw show();
		}
	}
}

/*
	Name: weapon_trigger_update_prompt
	Namespace: namespace_7550a904
	Checksum: 0x6D5B9CF8
	Offset: 0xBEA8
	Size: 0x12F
	Parameters: 1
	Flags: None
*/
function weapon_trigger_update_prompt(player)
{
	if(!zm_utility::is_player_valid(player) || player.IS_DRINKING > 0 || !player zm_magicbox::can_buy_weapon() || player bgb::is_enabled("zm_bgb_disorderly_combat"))
	{
		self setHintString(&"");
		return 0;
	}
	if(self.stub flag::get("weapon_grabbed_or_timed_out"))
	{
		self setHintString(&"");
		return 0;
	}
	self setcursorhint("HINT_WEAPON", self.stub.wpn);
	self setHintString(&"ZOMBIE_TRADE_WEAPON_FILL");
	return 1;
}

/*
	Name: function_15c62ca8
	Namespace: namespace_7550a904
	Checksum: 0xCF197FD0
	Offset: 0xBFE0
	Size: 0xA7
	Parameters: 2
	Flags: None
*/
function function_15c62ca8(v_pos, radius)
{
	v_origin = GetClosestPointOnNavMesh(v_pos, radius);
	if(!isdefined(v_origin))
	{
		e_player = zm_utility::get_closest_player(v_pos);
		v_origin = GetClosestPointOnNavMesh(e_player.origin, radius);
	}
	if(!isdefined(v_origin))
	{
		v_origin = v_pos;
	}
	return v_origin;
}

/*
	Name: function_688119e4
	Namespace: namespace_7550a904
	Checksum: 0x72C63C09
	Offset: 0xC090
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function function_688119e4()
{
	self endon("death");
	a_perks = self GetPerks();
	n_perks = a_perks.size;
	if(isdefined(self.player_perk_purchase_limit) && n_perks < self.player_perk_purchase_limit)
	{
		return 1;
	}
	else if(n_perks < level.perk_purchase_limit)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_61d38f32
	Namespace: namespace_7550a904
	Checksum: 0x21B0AD31
	Offset: 0xC120
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function function_61d38f32()
{
	self endon("powerup_timedout");
	self waittill("powerup_grabbed");
	if(zm_utility::is_player_valid(self.power_up_grab_player))
	{
		self.power_up_grab_player notify("hash_61bbe625");
	}
}

/*
	Name: function_160d5071
	Namespace: namespace_7550a904
	Checksum: 0xF6FF7D13
	Offset: 0xC170
	Size: 0x175
	Parameters: 2
	Flags: None
*/
function function_160d5071(s_plant, str_anim)
{
	self endon("death");
	self endon("hash_e9a97726");
	s_plant endon("hash_4729ad2");
	v_goal = GetStartOrigin(s_plant.origin, s_plant.angles, str_anim);
	v_goal = GetClosestPointOnNavMesh(v_goal);
	/#
		Assert(isdefined(v_goal), "Dev Block strings are not supported" + s_plant.origin + "Dev Block strings are not supported" + str_anim);
	#/
	self.v_zombie_custom_goal_pos = v_goal;
	self.n_zombie_custom_goal_radius = 8;
	self thread function_b0fddaee(s_plant);
	while(1)
	{
		n_delta = DistanceSquared(v_goal, self.origin);
		if(n_delta > 256)
		{
			wait(0.05);
		}
		else
		{
			break;
		}
	}
	self.v_zombie_custom_goal_pos = undefined;
	wait(0.05);
	self notify("zombie_reached_anim_spot");
}

/*
	Name: function_b0fddaee
	Namespace: namespace_7550a904
	Checksum: 0x4CEFE81B
	Offset: 0xC2F0
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function function_b0fddaee(s_plant)
{
	self endon("death");
	s_plant waittill("hash_4729ad2");
	if(isdefined(self.v_zombie_custom_goal_pos))
	{
		self.v_zombie_custom_goal_pos = undefined;
	}
}

/*
	Name: function_40428876
	Namespace: namespace_7550a904
	Checksum: 0xF9DCEDC
	Offset: 0xC338
	Size: 0x9D
	Parameters: 2
	Flags: None
*/
function function_40428876(s_plant, str_anim)
{
	self endon("death");
	v_goal = GetStartOrigin(s_plant.origin, s_plant.angles, str_anim);
	self vehicle_ai::start_scripted();
	self SetVehGoalPos(v_goal);
	self waittill("goal");
	self notify("zombie_reached_anim_spot");
}

/*
	Name: function_e851ad39
	Namespace: namespace_7550a904
	Checksum: 0x8449DE0A
	Offset: 0xC3E0
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function function_e851ad39()
{
	/#
		zm_devgui::add_custom_devgui_callback(&function_2dbcc8ad);
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_2dbcc8ad
	Namespace: namespace_7550a904
	Checksum: 0x45F2D7C9
	Offset: 0xC538
	Size: 0x181
	Parameters: 1
	Flags: None
*/
function function_2dbcc8ad(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			case "Dev Block strings are not supported":
			{
				level thread function_b529e6f4(cmd);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				foreach(var_a68e9e1 in level.a_s_planting_spots)
				{
					if(!(isdefined(var_a68e9e1.b_seed_planted) && var_a68e9e1.b_seed_planted))
					{
						var_a68e9e1.b_seed_planted = 1;
						var_a68e9e1 notify("hash_378095a2");
						var_a68e9e1 thread planting_spot_think(undefined, undefined, 1);
					}
				}
				return 1;
			}
		}
		return 0;
	#/
}

/*
	Name: function_b529e6f4
	Namespace: namespace_7550a904
	Checksum: 0x9B4E8C7D
	Offset: 0xC6C8
	Size: 0x44D
	Parameters: 1
	Flags: None
*/
function function_b529e6f4(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				var_a68e9e1 = level.players[0] function_c3cee22e();
				if(isdefined(var_a68e9e1))
				{
					var_a68e9e1 notify("hash_378095a2");
					var_a68e9e1 thread planting_spot_think(0);
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				var_a68e9e1 = level.players[0] function_c3cee22e();
				if(isdefined(var_a68e9e1))
				{
					var_a68e9e1 notify("hash_378095a2");
					var_a68e9e1 thread planting_spot_think(1);
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				var_a68e9e1 = level.players[0] function_c3cee22e();
				if(isdefined(var_a68e9e1))
				{
					var_a68e9e1 notify("hash_378095a2");
					var_a68e9e1 thread planting_spot_think(2);
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				var_a68e9e1 = level.players[0] function_c3cee22e();
				if(isdefined(var_a68e9e1))
				{
					var_a68e9e1 notify("hash_378095a2");
					var_a68e9e1 thread planting_spot_think(3);
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				var_a68e9e1 = level.players[0] function_c3cee22e();
				if(isdefined(var_a68e9e1))
				{
					var_a68e9e1 notify("hash_378095a2");
					var_a68e9e1 thread planting_spot_think(4);
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				var_a68e9e1 = level.players[0] function_c3cee22e();
				if(isdefined(var_a68e9e1))
				{
					var_a68e9e1 notify("hash_378095a2");
					var_a68e9e1 thread planting_spot_think(5);
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				var_a68e9e1 = level.players[0] function_c3cee22e();
				if(isdefined(var_a68e9e1))
				{
					var_a68e9e1 notify("hash_378095a2");
					var_a68e9e1 thread planting_spot_think(6);
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				var_a68e9e1 = level.players[0] function_c3cee22e();
				if(isdefined(var_a68e9e1))
				{
					var_a68e9e1 notify("hash_378095a2");
					var_a68e9e1 thread planting_spot_think(7);
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				var_a68e9e1 = level.players[0] function_c3cee22e();
				if(isdefined(var_a68e9e1))
				{
					var_a68e9e1 notify("hash_378095a2");
					var_a68e9e1 thread planting_spot_think(8);
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				var_a68e9e1 = level.players[0] function_c3cee22e();
				if(isdefined(var_a68e9e1))
				{
					var_a68e9e1 notify("hash_378095a2");
					var_a68e9e1 thread planting_spot_think(9);
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				var_a68e9e1 = level.players[0] function_c3cee22e();
				if(isdefined(var_a68e9e1))
				{
					var_a68e9e1 notify("hash_378095a2");
					var_a68e9e1 thread planting_spot_think(10);
				}
				break;
			}
		}
	#/
}

/*
	Name: function_c3cee22e
	Namespace: namespace_7550a904
	Checksum: 0x26AF77DC
	Offset: 0xCB20
	Size: 0xA5
	Parameters: 0
	Flags: None
*/
function function_c3cee22e()
{
	/#
		var_5eaa768a = level.a_s_planting_spots;
		n_index = zm_utility::get_closest_index(self.origin, var_5eaa768a);
		s_spot = var_5eaa768a[n_index];
		if(!(isdefined(s_spot.b_seed_planted) && s_spot.b_seed_planted))
		{
			s_spot.b_seed_planted = 1;
			return s_spot;
		}
		else
		{
			return undefined;
		}
	#/
}

