#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_raps;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_spiders;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_keeper_skull;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_island_craftables;
#using scripts\zm\zm_island_power;
#using scripts\zm\zm_island_spider_ee_quest;
#using scripts\zm\zm_island_util;
#using scripts\zm\zm_island_vo;

#namespace namespace_eaae7728;

/*
	Name: main
	Namespace: namespace_eaae7728
	Checksum: 0x9FF1F78D
	Offset: 0x12E8
	Size: 0x223
	Parameters: 0
	Flags: None
*/
function main()
{
	level flag::init("ww_upgrade_spawned_from_plant");
	level flag::init("players_lost_ww");
	var_b89c97ce = GetEnt("mdl_underwater_secretroom_rockwall", "targetname");
	var_b89c97ce clientfield::set("do_fade_material", 1);
	callback::on_spawned(&function_598781a4);
	foreach(player in level.players)
	{
		player thread function_598781a4();
	}
	struct::get("wonder_weapon_loc") thread function_11571878();
	struct::get("ww_up_pos") thread function_cc882a46();
	level thread function_c3efae8e();
	level thread function_6590511d();
	level thread function_7def4961();
	level flag::wait_till("ww_obtained");
	level thread function_e2b90d40();
	level thread function_b7685b2e();
}

/*
	Name: function_30d4f164
	Namespace: namespace_eaae7728
	Checksum: 0x6005D32D
	Offset: 0x1518
	Size: 0x3FB
	Parameters: 0
	Flags: None
*/
function function_30d4f164()
{
	function_3f3f162c();
	level flag::init("pool_filled");
	level flag::init("ww_obtained");
	level flag::init("ww1_found");
	level flag::init("ww2_found");
	level flag::init("ww3_venom_extractor_used");
	level flag::init("ww3_found");
	level flag::init("wwup1_found");
	level flag::init("wwup2_found");
	level flag::init("wwup3_found");
	level flag::init("wwup_wait");
	level flag::init("wwup_ready");
	level flag::init("wwup1_placed");
	level flag::init("wwup2_placed");
	level flag::init("wwup3_placed");
	level.var_622692a9 = 0;
	level.var_97c56c3c = GetEnt("wonder_weapon_display", "targetname");
	level.var_97c56c3c HidePart("tag_liquid");
	level.var_7cb81d3c = GetEnt("wonder_weapon_up_display", "targetname");
	level thread scene::add_scene_func("p7_fxanim_zm_island_cage_trap_tp_door_open_bundle", &function_c9d8bea4, "init");
	level thread scene::add_scene_func("p7_fxanim_zm_island_cage_trap_low_down_bundle", &hatch_open, "play");
	level thread scene::add_scene_func("p7_fxanim_zm_island_cage_trap_low_up_bundle", &function_10877763, "play");
	level thread scene::add_scene_func("p7_fxanim_zm_island_cage_trap_hatch_open_bundle", &function_4ee53d8b, "init");
	level thread scene::init("p7_fxanim_zm_island_cage_trap_tp_door_open_bundle");
	level thread scene::init("p7_fxanim_zm_island_cage_trap_hatch_open_bundle");
	var_db6efb17 = GetEnt("venom_extractor", "targetname");
	var_db6efb17 thread scene::init("p7_fxanim_zm_island_venom_extractor_bundle", var_db6efb17);
	var_db6efb17 SetIgnorePauseWorld(1);
	level thread function_961485f0();
	function_c5cd1083();
	/#
		function_982c97e5();
	#/
}

/*
	Name: function_3f3f162c
	Namespace: namespace_eaae7728
	Checksum: 0x70D3FCAF
	Offset: 0x1920
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function function_3f3f162c()
{
	clientfield::register("scriptmover", "play_underwater_plant_fx", 9000, 1, "int");
	clientfield::register("actor", "play_carrier_fx", 9000, 1, "int");
	clientfield::register("scriptmover", "play_vial_fx", 9000, 1, "int");
	clientfield::register("world", "add_ww_to_box", 9000, 4, "int");
	clientfield::register("scriptmover", "spider_bait", 9000, 1, "int");
}

/*
	Name: function_11571878
	Namespace: namespace_eaae7728
	Checksum: 0x7818F179
	Offset: 0x1A20
	Size: 0x527
	Parameters: 0
	Flags: None
*/
function function_11571878()
{
	self.trigger = namespace_8aed53c9::function_d095318(self.origin, 50, 1, &function_5f3935a);
	var_85b2b1ab = GetEnt("ww_station", "targetname");
	v_pos = var_85b2b1ab GetTagOrigin("mirg_cent_gun_tag_jnt");
	v_ang = var_85b2b1ab GetTagAngles("mirg_cent_gun_tag_jnt");
	var_85b2b1ab scene::init("p7_fxanim_zm_island_mirg_centrifuge_table_gun_up_bundle", var_85b2b1ab);
	var_218752f9 = GetEnt("ww_station_funnel", "targetname");
	var_218752f9 HidePart("j_glow_green");
	var_218752f9 HidePart("j_glow_purple");
	var_218752f9 HidePart("j_glow_red");
	level.var_97c56c3c moveto(v_pos, 0.05);
	level.var_97c56c3c waittill("movedone");
	level.var_97c56c3c.angles = v_ang;
	level.var_97c56c3c LinkTo(var_85b2b1ab, "mirg_cent_gun_tag_jnt");
	while(1)
	{
		self.trigger waittill("trigger", player);
		if(zm_utility::is_player_valid(player))
		{
			if(level flag::get("ww1_found") && !level flag::get("wwup1_placed"))
			{
				level flag::set("wwup1_placed");
				var_218752f9 ShowPart("j_glow_red");
				level.var_622692a9--;
			}
			if(level flag::get("ww2_found") && !level flag::get("wwup2_placed"))
			{
				level flag::set("wwup2_placed");
				var_218752f9 ShowPart("j_glow_green");
				level.var_622692a9--;
			}
			if(level flag::get("ww3_found") && !level flag::get("wwup3_placed"))
			{
				level flag::set("wwup3_placed");
				var_218752f9 ShowPart("j_glow_purple");
				level.var_622692a9--;
			}
			if(level flag::get("ww1_found") && level flag::get("ww2_found") && level flag::get("ww3_found"))
			{
				zm_unitrigger::unregister_unitrigger(self.trigger);
				self.trigger = undefined;
				level thread namespace_f333593c::function_3bf2d62a("kn4_ammo", 0, 1, 0);
				var_85b2b1ab scene::Play("p7_fxanim_zm_island_mirg_centrifuge_table_gun_up_bundle", var_85b2b1ab);
				var_85b2b1ab scene::Play("p7_fxanim_zm_island_mirg_centrifuge_table_turn_on_bundle", var_85b2b1ab);
				level.var_97c56c3c ShowPart("tag_liquid");
				var_85b2b1ab scene::Play("p7_fxanim_zm_island_mirg_centrifuge_table_gun_down_bundle", var_85b2b1ab);
				self thread function_255b7efb();
				break;
			}
			else if(zm_utility::is_player_valid(player))
			{
				player notify("hash_f48612e4");
			}
		}
	}
}

/*
	Name: function_5f3935a
	Namespace: namespace_eaae7728
	Checksum: 0xD125D1E2
	Offset: 0x1F50
	Size: 0x9B
	Parameters: 1
	Flags: Private
*/
function private function_5f3935a(e_player)
{
	if(level flag::get("ww1_found") && level flag::get("ww2_found") && level flag::get("ww3_found"))
	{
		return &"ZM_ISLAND_WONDERWEAPON_AMMO";
	}
	else if(level.var_622692a9)
	{
		return &"ZM_ISLAND_WONDERWEAPON_STATION";
	}
	else
	{
		return &"ZOMBIE_BUILD_PIECE_MORE";
	}
}

/*
	Name: function_255b7efb
	Namespace: namespace_eaae7728
	Checksum: 0x5BD0FF8F
	Offset: 0x1FF8
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function function_255b7efb()
{
	self.trigger = namespace_8aed53c9::function_d095318(self.origin, 50, 1, &function_d23a4109);
	while(1)
	{
		self.trigger waittill("trigger", player);
		if(player zm_hero_weapon::is_hero_weapon_in_use())
		{
			continue;
		}
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
		if(player bgb::is_enabled("zm_bgb_disorderly_combat"))
		{
			continue;
		}
		zm_unitrigger::unregister_unitrigger(self.trigger);
		self.trigger = undefined;
		level thread function_9279976b(player);
		break;
	}
}

/*
	Name: function_d23a4109
	Namespace: namespace_eaae7728
	Checksum: 0xFF991FDF
	Offset: 0x2140
	Size: 0x63
	Parameters: 1
	Flags: Private
*/
function private function_d23a4109(e_player)
{
	if(e_player bgb::is_enabled("zm_bgb_disorderly_combat"))
	{
		return "";
	}
	if(!e_player zm_hero_weapon::is_hero_weapon_in_use())
	{
		return &"ZM_ISLAND_WONDERWEAPON_PICKUP";
	}
	else
	{
		return "";
	}
}

/*
	Name: function_2578c564
	Namespace: namespace_eaae7728
	Checksum: 0xC44496CC
	Offset: 0x21B0
	Size: 0x137
	Parameters: 1
	Flags: None
*/
function function_2578c564(str_flag)
{
	self endon("death");
	while(1)
	{
		self.trigger waittill("trigger", player);
		if(zm_utility::is_player_valid(player))
		{
			level.var_622692a9++;
			player notify("hash_f33f0d2a");
			zm_unitrigger::unregister_unitrigger(self.trigger);
			level flag::set(str_flag);
			if(str_flag == "ww3_found")
			{
				var_db6efb17 = GetEnt("venom_extractor", "targetname");
				wait(0.5);
				var_db6efb17 thread function_3c6e89ad();
			}
			self.trigger = undefined;
			level thread function_ce9a171c(str_flag);
			self delete();
		}
	}
}

/*
	Name: function_3c6e89ad
	Namespace: namespace_eaae7728
	Checksum: 0x6A22CD5F
	Offset: 0x22F0
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_3c6e89ad()
{
	self scene::Play("p7_fxanim_zm_island_venom_extractor_end_bundle", self);
	self SetModel("p7_fxanim_zm_island_venom_extractor_red_mod");
	self scene::init("p7_fxanim_zm_island_venom_extractor_red_bundle", self);
}

/*
	Name: function_9279976b
	Namespace: namespace_eaae7728
	Checksum: 0x7839ADD0
	Offset: 0x2360
	Size: 0x1AB
	Parameters: 1
	Flags: None
*/
function function_9279976b(player)
{
	if(player function_f11b379d())
	{
		var_dc7ddcde = player GetCurrentWeapon();
		player TakeWeapon(var_dc7ddcde);
	}
	level.var_97c56c3c Unlink();
	level.var_97c56c3c Hide();
	player GiveWeapon(level.var_5e75629a);
	player giveMaxAmmo(level.var_5e75629a);
	player SwitchToWeapon(level.var_5e75629a);
	player notify("hash_f717c7f5");
	level clientfield::set("add_ww_to_box", 1);
	player.var_3599826c = 1;
	level.zombie_weapons[level.var_5e75629a].is_in_box = 1;
	level.CustomRandomWeaponWeights = &function_659c2324;
	level.var_2cb8e184 = 0;
	player thread function_9dd4723a();
	level flag::set("ww_obtained");
}

/*
	Name: function_9dd4723a
	Namespace: namespace_eaae7728
	Checksum: 0x53FA1CA3
	Offset: 0x2518
	Size: 0x71
	Parameters: 0
	Flags: None
*/
function function_9dd4723a()
{
	while(1)
	{
		self util::waittill_any("bled_out", "weapon_change", "disconnect");
		if(function_52193f1e() == 0)
		{
			level flag::set("players_lost_ww");
			return;
		}
	}
}

/*
	Name: function_659c2324
	Namespace: namespace_eaae7728
	Checksum: 0x17E00E36
	Offset: 0x2598
	Size: 0x1F7
	Parameters: 1
	Flags: None
*/
function function_659c2324(a_keys)
{
	var_b45fbf8c = zm_pap_util::get_triggers();
	if(level flag::get("players_lost_ww"))
	{
		level.var_2cb8e184++;
		switch(level.var_2cb8e184)
		{
			case 1:
			{
				n_chance = 10;
				break;
			}
			case 2:
			{
				n_chance = 10;
				break;
			}
			case 3:
			{
				n_chance = 30;
				break;
			}
			case 4:
			{
				n_chance = 60;
				break;
			}
			case default:
			{
				n_chance = 10;
				break;
			}
		}
		if(RandomInt(100) <= n_chance && zm_magicbox::treasure_chest_CanPlayerReceiveWeapon(self, level.var_5e75629a, var_b45fbf8c) && !self HasWeapon(level.var_a4052592))
		{
			ArrayInsert(a_keys, level.var_5e75629a, 0);
			self thread function_97d5f905();
		}
		else
		{
			ArrayRemoveValue(a_keys, level.var_5e75629a);
		}
	}
	else if(self HasWeapon(level.var_5e75629a) || self HasWeapon(level.var_a4052592))
	{
		ArrayRemoveValue(a_keys, level.var_5e75629a);
	}
	return a_keys;
}

/*
	Name: function_97d5f905
	Namespace: namespace_eaae7728
	Checksum: 0x5D7FCEBC
	Offset: 0x2798
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function function_97d5f905()
{
	self endon("disconnect");
	self endon("bled_out");
	var_1f4c3936 = undefined;
	foreach(var_c3763c58 in level.chests)
	{
		if(var_c3763c58.chest_user === self)
		{
			var_1f4c3936 = var_c3763c58;
			break;
		}
	}
	if(!isdefined(var_1f4c3936))
	{
		return;
	}
	self util::waittill_any_ents(self, "user_grabbed_weapon", var_1f4c3936, "chest_accessed", self, "disconnect", self, "bled_out");
	if(function_52193f1e() == 1)
	{
		level flag::clear("players_lost_ww");
		level.var_2cb8e184 = 0;
		self thread function_9dd4723a();
	}
}

/*
	Name: function_52193f1e
	Namespace: namespace_eaae7728
	Checksum: 0xD3D52A8A
	Offset: 0x2900
	Size: 0xCD
	Parameters: 0
	Flags: None
*/
function function_52193f1e()
{
	n_count = 0;
	foreach(player in level.players)
	{
		if(player HasWeapon(level.var_5e75629a) || player HasWeapon(level.var_a4052592))
		{
			n_count++;
		}
	}
	return n_count;
}

/*
	Name: function_f11b379d
	Namespace: namespace_eaae7728
	Checksum: 0x85F38C19
	Offset: 0x29D8
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function function_f11b379d()
{
	a_weapons = self GetWeaponsListPrimaries();
	if(!self hasPerk("specialty_additionalprimaryweapon") && a_weapons.size > 1)
	{
		return 1;
	}
	else if(self hasPerk("specialty_additionalprimaryweapon") && a_weapons.size > 2)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

/*
	Name: function_6590511d
	Namespace: namespace_eaae7728
	Checksum: 0x275B652B
	Offset: 0x2A80
	Size: 0x17D
	Parameters: 0
	Flags: None
*/
function function_6590511d()
{
	level flag::wait_till("power_on");
	level waittill("start_of_round");
	wait(randomIntRange(5, 8));
	while(1)
	{
		var_5103f616 = function_1c683357();
		if(isalive(var_5103f616))
		{
			while(isalive(var_5103f616) && var_5103f616.completed_emerging_into_playable_area !== 1)
			{
				util::wait_network_frame();
			}
			if(isalive(var_5103f616) && zm_utility::check_point_in_playable_area(var_5103f616.origin))
			{
				var_5103f616 clientfield::set("play_carrier_fx", 1);
				var_5103f616.var_5017aabf = 1;
				var_5103f616.no_powerups = 1;
				var_1a0512ba = var_5103f616 function_f5d430d7();
				if(var_1a0512ba)
				{
					break;
				}
			}
		}
		wait(1);
	}
}

/*
	Name: function_1c683357
	Namespace: namespace_eaae7728
	Checksum: 0x1156211A
	Offset: 0x2C08
	Size: 0x2B1
	Parameters: 0
	Flags: None
*/
function function_1c683357()
{
	a_ai_zombies = GetAITeamArray(level.zombie_team);
	var_2513c269 = [];
	foreach(ai_zombie in a_ai_zombies)
	{
		str_zone = ai_zombie zm_utility::get_current_zone();
		if(zm_zonemgr::any_player_in_zone("zone_meteor_site") || zm_zonemgr::any_player_in_zone("zone_meteor_site_2") || zm_zonemgr::any_player_in_zone("zone_swamp_lab_underneath") || zm_zonemgr::any_player_in_zone("zone_swamp_lab_underneath_2") || zm_zonemgr::any_player_in_zone("zone_swamp_lab"))
		{
			if(str_zone === "zone_meteor_site" || str_zone === "zone_meteor_site_2" || str_zone === "zone_swamp_lab_underneath" || str_zone === "zone_swamp_lab_underneath_2")
			{
				if(!isdefined(ai_zombie.completed_emerging_into_playable_area) && (!isdefined(ai_zombie.var_3940f450) && ai_zombie.var_3940f450) && (!isdefined(ai_zombie.var_61f7b3a0) && ai_zombie.var_61f7b3a0) && ai_zombie.archetype === "zombie")
				{
					Array::add(var_2513c269, ai_zombie);
				}
			}
		}
	}
	var_5103f616 = Array::random(var_2513c269);
	if(isdefined(var_5103f616) && !namespace_8aed53c9::function_8c6350db(var_5103f616 GetCentroid(), 0.5, 1, var_5103f616))
	{
		var_5103f616 SetModel("c_zom_dlc2_jpn_zombies3a");
		return var_5103f616;
	}
}

/*
	Name: function_f5d430d7
	Namespace: namespace_eaae7728
	Checksum: 0x9055639E
	Offset: 0x2EC8
	Size: 0x1A5
	Parameters: 0
	Flags: None
*/
function function_f5d430d7()
{
	str_notify = self util::waittill_any_return("enemy_cleaned_up", "death");
	if(str_notify == "enemy_cleaned_up")
	{
		return 0;
	}
	else
	{
		var_71e3d70a = util::spawn_model("p7_cai_plant_sample_vial_01", self.origin + VectorScale((0, 0, 1), 16));
		var_71e3d70a notsolid();
		var_71e3d70a clientfield::set("play_vial_fx", 1);
		var_71e3d70a PlayLoopSound("zmb_vial_loop");
		var_71e3d70a.trigger = namespace_8aed53c9::function_d095318(var_71e3d70a.origin, 50, 1, &function_9bd3096f);
		var_71e3d70a thread function_2578c564("ww1_found");
		var_71e3d70a thread function_d7b19999();
		var_83e3a776 = level util::waittill_any_return("ww1_found", "ww1_timed_out");
		if(var_83e3a776 == "ww1_found")
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
}

/*
	Name: function_d7b19999
	Namespace: namespace_eaae7728
	Checksum: 0x59F837AD
	Offset: 0x3078
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_d7b19999()
{
	self endon("death");
	wait(20);
	self function_2fe542aa();
	level notify("hash_53c9a941");
	zm_unitrigger::unregister_unitrigger(self.trigger);
	self delete();
}

/*
	Name: function_2fe542aa
	Namespace: namespace_eaae7728
	Checksum: 0x9C81D89A
	Offset: 0x30F0
	Size: 0xAD
	Parameters: 0
	Flags: None
*/
function function_2fe542aa()
{
	self endon("death");
	for(i = 0; i < 40; i++)
	{
		if(i % 2)
		{
			self ghost();
		}
		else
		{
			self show();
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
}

/*
	Name: function_9bd3096f
	Namespace: namespace_eaae7728
	Checksum: 0x3E1AF6D
	Offset: 0x31A8
	Size: 0x3D
	Parameters: 1
	Flags: Private
*/
function private function_9bd3096f(player)
{
	if(level flag::get("ww_obtained"))
	{
		return "";
	}
	return &"ZOMBIE_BUILD_PIECE_GRAB";
}

/*
	Name: function_c3efae8e
	Namespace: namespace_eaae7728
	Checksum: 0x73CC06D1
	Offset: 0x31F0
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function function_c3efae8e()
{
	var_a2365998 = struct::get("ww_part_underwater", "script_noteworthy");
	var_71e3d70a = util::spawn_model("p7_zm_isl_foliage_plant_underwater_01_red", var_a2365998.origin);
	var_71e3d70a clientfield::set("play_vial_fx", 1);
	var_71e3d70a PlayLoopSound("zmb_vial_loop");
	var_71e3d70a.trigger = namespace_8aed53c9::function_d095318(var_71e3d70a.origin, 50, 1, &function_9bd3096f);
	var_71e3d70a thread function_2578c564("ww2_found");
}

/*
	Name: function_7def4961
	Namespace: namespace_eaae7728
	Checksum: 0x8DB34606
	Offset: 0x32F8
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function function_7def4961()
{
	level.var_1dbad94a = 0;
	level.var_90e478e7 = 0;
	level.var_67359403 = 0;
	level.var_48762d0c = 0;
	level thread scene::add_scene_func("p7_fxanim_zm_island_cage_trap_spid_tp_open_bundle", &function_2020490f, "init");
	level thread scene::init("p7_fxanim_zm_island_cage_trap_spid_tp_open_bundle");
	level thread scene::add_scene_func("p7_fxanim_zm_island_cage_trap_spid_hatch_open_bundle", &function_385c3ebb, "init");
	level thread scene::init("p7_fxanim_zm_island_cage_trap_spid_hatch_open_bundle");
	var_30c2448 = struct::get("vial_pos");
	var_f78dfee = struct::get("spider_cage_control");
	var_f78dfee thread function_9faff60c();
	while(!level.var_1dbad94a)
	{
		wait(0.1);
	}
	level thread function_ebbb27ae();
}

/*
	Name: function_2020490f
	Namespace: namespace_eaae7728
	Checksum: 0x8B1C5605
	Offset: 0x3468
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function function_2020490f(a_ents)
{
	level.var_1a139831 = a_ents["fxanim_cage_trap_spid"];
	level.var_1a139831.var_272ec8a1 = 0;
	level.var_1a139831.var_935a64f = GetEnt("clip_cage_jungle", "targetname");
	level.var_1a139831.var_935a64f LinkTo(level.var_1a139831);
	level.var_1a139831 SetIgnorePauseWorld(1);
	var_ccefca71 = GetEnt("spider_bait", "targetname");
	var_ccefca71 LinkTo(level.var_1a139831);
}

/*
	Name: function_385c3ebb
	Namespace: namespace_eaae7728
	Checksum: 0x6EB19ABB
	Offset: 0x3568
	Size: 0x1F
	Parameters: 1
	Flags: None
*/
function function_385c3ebb(a_ents)
{
	level.var_17e2756d = a_ents["cage_trap_spid_hatch"];
}

/*
	Name: function_9faff60c
	Namespace: namespace_eaae7728
	Checksum: 0xFDDBEA2D
	Offset: 0x3590
	Size: 0x54F
	Parameters: 0
	Flags: None
*/
function function_9faff60c()
{
	self.trigger = namespace_8aed53c9::function_d095318(self.origin, 16, 1, &function_a50aa078);
	var_a78de5fc = GetEnt("cage_entity", "targetname");
	var_c120c3f6 = GetEnt("clip_jungle_door", "targetname");
	while(1)
	{
		self.trigger waittill("trigger");
		if(!level.var_1dbad94a && !level flag::get("power_on"))
		{
			continue;
		}
		if(level.var_1a139831.var_272ec8a1)
		{
			continue;
		}
		if(!level.var_90e478e7)
		{
			if(isdefined(level.var_1deeff56) && level.var_1deeff56)
			{
				level thread function_429e7f8a(1);
				str_scene = "p7_fxanim_zm_island_cage_trap_spid_low_down_bundle";
				n_height = -344;
				level.var_3ef945d6 = 1;
				if(isdefined(level.var_18ddef1f) && level.var_18ddef1f)
				{
					level.var_f5ad590f = 1;
				}
			}
			else
			{
				str_scene = "p7_fxanim_zm_island_cage_trap_spid_down_bundle";
				n_height = -246;
			}
			b_state = 1;
			var_1cdfa0f4 = &"ZM_ISLAND_CAGE_RAISE";
			level thread namespace_f333593c::function_3bf2d62a("lower_cage", 1, 0, 0);
			level thread function_baa845f4();
		}
		else if(isdefined(level.var_1deeff56) && level.var_1deeff56)
		{
			level thread function_429e7f8a(0);
			str_scene = "p7_fxanim_zm_island_cage_trap_spid_low_up_bundle";
			n_height = 344;
			level.var_3ef945d6 = undefined;
		}
		else
		{
			str_scene = "p7_fxanim_zm_island_cage_trap_spid_up_bundle";
			n_height = 246;
		}
		b_state = 0;
		var_1cdfa0f4 = &"ZM_ISLAND_CAGE_LOWER";
		level thread namespace_f333593c::function_3bf2d62a("raise_cage", 1, 0, 0);
		level.var_48762d0c = 1;
		if(!b_state)
		{
			level.var_1a139831 StopLoopSound(1);
			level.var_1a139831 clientfield::set("spider_bait", 0);
		}
		level.var_1a139831 scene::Play(str_scene, level.var_1a139831);
		level.var_90e478e7 = b_state;
		level.var_48762d0c = 0;
		if(b_state)
		{
			if(!level flag::get("ww3_venom_extractor_used"))
			{
				level.var_1a139831 clientfield::set("spider_bait", 1);
			}
			level.var_1a139831.var_935a64f disconnectpaths();
			if(!(isdefined(level.var_1deeff56) && level.var_1deeff56))
			{
				level.var_1a139831 scene::Play("p7_fxanim_zm_island_cage_trap_spid_down_open_bundle", level.var_1a139831);
				var_c120c3f6 MoveZ(-100, 0.05);
				var_c120c3f6 waittill("movedone");
				var_c120c3f6 solid();
				var_c120c3f6 disconnectpaths();
			}
		}
		else
		{
			level.var_1a139831.var_935a64f connectpaths();
			var_c120c3f6 MoveZ(100, 0.05);
			var_c120c3f6 waittill("movedone");
			var_c120c3f6 connectpaths();
		}
		if(isdefined(level.var_90e478e7) && level.var_90e478e7 && (isdefined(level.var_1deeff56) && level.var_1deeff56))
		{
			namespace_1aa6bd0c::function_69f5a9c5(var_1cdfa0f4);
		}
		if(!isdefined(level.var_90e478e7) && level.var_90e478e7 && (isdefined(level.var_1deeff56) && level.var_1deeff56))
		{
			namespace_1aa6bd0c::function_c9e92f7b();
		}
	}
}

/*
	Name: function_429e7f8a
	Namespace: namespace_eaae7728
	Checksum: 0x841CD70D
	Offset: 0x3AE8
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function function_429e7f8a(b_state)
{
	if(b_state)
	{
		wait(1.5);
	}
	level.var_17e2756d scene::Play("p7_fxanim_zm_island_cage_trap_spid_hatch_open_bundle", level.var_17e2756d);
	wait(4);
	level.var_17e2756d scene::Play("p7_fxanim_zm_island_cage_trap_spid_hatch_close_bundle", level.var_17e2756d);
}

/*
	Name: function_a50aa078
	Namespace: namespace_eaae7728
	Checksum: 0x5CA3BD2E
	Offset: 0x3B68
	Size: 0xD3
	Parameters: 1
	Flags: Private
*/
function private function_a50aa078(player)
{
	if(level.var_1a139831.var_272ec8a1)
	{
		return "";
	}
	if(isdefined(level.var_f5ad590f) && level.var_f5ad590f)
	{
		return "";
	}
	if(!level.var_1dbad94a && !level flag::get("power_on"))
	{
		return &"ZOMBIE_NEED_POWER";
	}
	else if(!level.var_90e478e7 && !level.var_48762d0c)
	{
		return &"ZM_ISLAND_CAGE_LOWER";
	}
	else if(level.var_90e478e7 && !level.var_48762d0c)
	{
		return &"ZM_ISLAND_CAGE_RAISE";
	}
	else
	{
		return "";
	}
}

/*
	Name: function_ebbb27ae
	Namespace: namespace_eaae7728
	Checksum: 0x299D043F
	Offset: 0x3C48
	Size: 0x55F
	Parameters: 0
	Flags: None
*/
function function_ebbb27ae()
{
	level endon("hash_d8d0f829");
	var_60532813 = GetEnt("trigger_trap", "targetname");
	var_799520c1 = struct::get("trap_pos");
	while(1)
	{
		var_60532813 waittill("trigger", ai_zombie);
		if(!ai_zombie.var_3940f450)
		{
			continue;
		}
		if(level.var_67359403)
		{
			continue;
		}
		if(!level.var_90e478e7)
		{
			continue;
		}
		if(isdefined(level.var_3ef945d6) && level.var_3ef945d6)
		{
			continue;
		}
		if(!any_player_is_touching(GetEnt("trigger_cage_proximity", "targetname")))
		{
			continue;
		}
		if(level flag::get("ww3_venom_extractor_used") && (!isdefined(ai_zombie.var_f7522faa) && ai_zombie.var_f7522faa))
		{
			continue;
		}
		if(isalive(ai_zombie))
		{
			if(isdefined(ai_zombie.var_f7522faa) && ai_zombie.var_f7522faa)
			{
				var_60532813 thread namespace_1aa6bd0c::function_aa515242(ai_zombie);
			}
			else
			{
				ai_zombie thread function_cea70075();
			}
			ai_zombie.ignore_round_spawn_failsafe = 1;
			ai_zombie.var_41ff1b25 = 1;
			ai_zombie.allowdeath = 0;
			ai_zombie DisableAimAssist();
			ai_zombie.e_mover = util::spawn_model("tag_origin", ai_zombie.origin, ai_zombie.angles);
			ai_zombie.e_mover.targetname = "tag_align";
			ai_zombie LinkTo(ai_zombie.e_mover);
			ai_zombie.e_mover moveto(var_799520c1.origin, 1);
			ai_zombie.e_mover waittill("movedone");
			ai_zombie.e_mover LinkTo(level.var_1a139831);
			ai_zombie.e_mover thread scene::Play("zm_dlc2_spider_trapped_in_cage_loop", ai_zombie);
			level.var_67359403 = 1;
			level.var_1a139831 scene::Play("p7_fxanim_zm_island_cage_trap_spid_down_close_bundle", level.var_1a139831);
			var_c120c3f6 = GetEnt("clip_jungle_door", "targetname");
			var_c120c3f6 notsolid();
			var_c120c3f6 connectpaths();
			while(level.var_90e478e7)
			{
				wait(0.1);
			}
			if(isalive(ai_zombie) && (!isdefined(ai_zombie.var_f7522faa) && ai_zombie.var_f7522faa))
			{
				level.zm_override_ai_aftermath_powerup_drop = &function_cc8fe309;
				level.var_1a139831.var_272ec8a1 = 1;
				var_db6efb17 = GetEnt("venom_extractor", "targetname");
				var_db6efb17 thread scene::Play("p7_fxanim_zm_island_venom_extractor_bundle", var_db6efb17);
				level waittill("hash_e48828c5");
				ai_zombie.allowdeath = 1;
				ai_zombie DoDamage(ai_zombie.health, ai_zombie.origin);
				var_ccefca71 = GetEnt("spider_bait", "targetname");
				var_ccefca71 delete();
				level.var_1a139831 clientfield::set("spider_bait", 0);
				level.var_1a139831.var_272ec8a1 = 0;
				level flag::set("ww3_venom_extractor_used");
			}
		}
	}
}

/*
	Name: function_cc8fe309
	Namespace: namespace_eaae7728
	Checksum: 0xB9E7E88
	Offset: 0x41B0
	Size: 0x151
	Parameters: 2
	Flags: None
*/
function function_cc8fe309(var_c79d3f71, var_18130313)
{
	if(isdefined(var_c79d3f71.var_41ff1b25) && var_c79d3f71.var_41ff1b25)
	{
		level._powerup_timeout_custom_time = &namespace_1aa6bd0c::function_3321a018;
		e_linkto = util::spawn_model("tag_origin", level.var_1a139831.origin, level.var_1a139831.angles);
		e_linkto LinkTo(level.var_1a139831);
		var_93eb638b = zm_powerups::specific_powerup_drop("full_ammo", var_18130313 + VectorScale((0, 0, -1), 16));
		var_93eb638b LinkTo(e_linkto);
		level._powerup_timeout_custom_time = undefined;
	}
	else
	{
		var_93eb638b = zm_powerups::specific_powerup_drop("full_ammo", var_18130313 + VectorScale((0, 0, -1), 16));
	}
	level.zm_override_ai_aftermath_powerup_drop = undefined;
}

/*
	Name: function_23d17338
	Namespace: namespace_eaae7728
	Checksum: 0x56797A6D
	Offset: 0x4310
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function function_23d17338(var_7afe5e99)
{
	if(!isdefined(var_7afe5e99))
	{
		var_7afe5e99 = 1;
	}
	var_a2176993 = GetEnt("jungle_lab_ee_control_panel_elf", "targetname");
	if(var_7afe5e99)
	{
		var_a2176993 SetModel("p7_zm_isl_control_panel_cage");
	}
	else
	{
		var_a2176993 SetModel("p7_zm_isl_control_panel_cage_off");
	}
}

/*
	Name: function_cea70075
	Namespace: namespace_eaae7728
	Checksum: 0xC75EF6D4
	Offset: 0x43B0
	Size: 0xDF
	Parameters: 0
	Flags: None
*/
function function_cea70075()
{
	self util::waittill_notify_or_timeout("death", 90);
	if(isalive(self) && !level.var_1a139831.var_272ec8a1)
	{
		self util::stop_magic_bullet_shield();
		self DoDamage(self.health, self.origin);
	}
	if(!level.var_90e478e7 && !level flag::get("ww3_found"))
	{
		level thread function_4a13e10b();
	}
	level.var_67359403 = 0;
}

/*
	Name: function_4a13e10b
	Namespace: namespace_eaae7728
	Checksum: 0xFE35170D
	Offset: 0x4498
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function function_4a13e10b()
{
	level flag::set("pool_filled");
	var_bbcd41a3 = struct::get("vial_pos").origin;
	var_71e3d70a = util::spawn_model("tag_origin", var_bbcd41a3);
	var_71e3d70a PlayLoopSound("zmb_vial_loop");
	var_71e3d70a.trigger = namespace_8aed53c9::function_d095318(var_71e3d70a.origin, 50, 1, &function_9bd3096f);
	var_71e3d70a thread function_2578c564("ww3_found");
	level thread namespace_f333593c::function_3bf2d62a("spider_venom", 1, 0, 0);
}

/*
	Name: any_player_is_touching
	Namespace: namespace_eaae7728
	Checksum: 0x788BEA15
	Offset: 0x45B8
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function any_player_is_touching(ent)
{
	foreach(player in level.players)
	{
		if(isalive(player) && player istouching(ent))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: function_baa845f4
	Namespace: namespace_eaae7728
	Checksum: 0x4FFED459
	Offset: 0x4680
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function function_baa845f4()
{
	n_radius = 24;
	n_height = 100;
	v_pos = (-1236, 368, -115);
	wait(0.5);
	t_kill = spawn("trigger_radius", v_pos, 0, n_radius, n_height);
	t_kill thread function_1228bd27();
	wait(0.5);
	t_kill delete();
}

/*
	Name: function_1228bd27
	Namespace: namespace_eaae7728
	Checksum: 0x1359E518
	Offset: 0x4740
	Size: 0x1A7
	Parameters: 0
	Flags: None
*/
function function_1228bd27()
{
	self endon("death");
	var_8e4b278 = undefined;
	v_org = (-1135, 367, -115);
	e_linkto = GetEnt("cage_linkto", "targetname");
	while(1)
	{
		foreach(player in level.activePlayers)
		{
			if(player istouching(self))
			{
				while(!isdefined(var_8e4b278))
				{
					var_8e4b278 = GetClosestPointOnNavMesh(v_org, 48);
					wait(0.05);
				}
				player SetOrigin(var_8e4b278);
				player PlayRumbleOnEntity("damage_heavy");
				player DoDamage(player.health, player.origin);
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_c5cd1083
	Namespace: namespace_eaae7728
	Checksum: 0x27ED3FD4
	Offset: 0x48F0
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_c5cd1083()
{
	level.var_9fce15de = GetEnt("trigger_inside_cage", "targetname");
	level.var_9fce15de SetInvisibleToAll();
	level.var_2ba557f2 = GetEnt("clip_swamp_hatch", "targetname");
}

/*
	Name: function_cc882a46
	Namespace: namespace_eaae7728
	Checksum: 0x5152E65E
	Offset: 0x4968
	Size: 0x4BF
	Parameters: 0
	Flags: None
*/
function function_cc882a46()
{
	var_85b2b1ab = GetEnt("wwup_station", "targetname");
	var_85b2b1ab scene::init("p7_fxanim_zm_island_mirg_centrifuge_table_gun_up_bundle", var_85b2b1ab);
	var_218752f9 = GetEnt("wwup_station_funnel", "targetname");
	var_218752f9 HidePart("j_glow_green");
	var_218752f9 HidePart("j_glow_purple");
	var_218752f9 HidePart("j_glow_red");
	level flag::wait_till("ww_obtained");
	self.trigger = namespace_8aed53c9::function_d095318(self.origin, 50, 1, &function_5521d6b5);
	while(1)
	{
		self.trigger waittill("trigger", player);
		if(level flag::get("wwup1_found"))
		{
			var_218752f9 ShowPart("j_glow_red");
		}
		if(level flag::get("wwup2_found"))
		{
			var_218752f9 ShowPart("j_glow_purple");
		}
		if(level flag::get("wwup3_found"))
		{
			var_218752f9 ShowPart("j_glow_green");
		}
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
		if(!player HasWeapon(level.var_5e75629a))
		{
			continue;
		}
		if(player GetCurrentWeapon() != level.var_5e75629a)
		{
			continue;
		}
		if(player zm_hero_weapon::is_hero_weapon_in_use())
		{
			continue;
		}
		if(level flag::get("wwup1_found") && level flag::get("wwup2_found") && level flag::get("wwup3_found"))
		{
			level flag::set("wwup_wait");
			player TakeWeapon(level.var_5e75629a);
			var_85b2b1ab Attach(level.var_97c56c3c.model, "mirg_cent_gun_tag_jnt");
			var_85b2b1ab scene::Play("p7_fxanim_zm_island_mirg_centrifuge_table_gun_up_bundle", var_85b2b1ab);
			var_85b2b1ab scene::Play("p7_fxanim_zm_island_mirg_centrifuge_table_turn_on_bundle", var_85b2b1ab);
			var_85b2b1ab Detach(level.var_97c56c3c.model, "mirg_cent_gun_tag_jnt");
			var_85b2b1ab Attach(level.var_7cb81d3c.model, "mirg_cent_gun_tag_jnt");
			var_85b2b1ab scene::Play("p7_fxanim_zm_island_mirg_centrifuge_table_gun_down_bundle", var_85b2b1ab);
			level flag::set("wwup_ready");
			self.trigger thread function_9f93c407(player);
			level flag::wait_till_clear("wwup_wait");
		}
	}
}

/*
	Name: function_5521d6b5
	Namespace: namespace_eaae7728
	Checksum: 0xF2EA3058
	Offset: 0x4E30
	Size: 0xE3
	Parameters: 1
	Flags: Private
*/
function private function_5521d6b5(player)
{
	if(level flag::get("wwup_ready") && !player zm_hero_weapon::is_hero_weapon_in_use())
	{
		return &"ZM_ISLAND_WONDERWEAPON_UP_PICKUP";
	}
	if(level flag::get("wwup1_found") && level flag::get("wwup2_found") && level flag::get("wwup3_found") && player GetCurrentWeapon() == level.var_5e75629a)
	{
		return &"ZM_ISLAND_WONDERWEAPON_AMMO";
	}
	else
	{
		return "";
	}
}

/*
	Name: function_9f93c407
	Namespace: namespace_eaae7728
	Checksum: 0x30D99C1D
	Offset: 0x4F20
	Size: 0x24F
	Parameters: 1
	Flags: None
*/
function function_9f93c407(player)
{
	player endon("hash_b874720a");
	while(1)
	{
		self waittill("trigger", e_who);
		if(e_who == player && !e_who zm_hero_weapon::is_hero_weapon_in_use())
		{
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
			level flag::clear("wwup_wait");
			level flag::clear("wwup_ready");
			if(player HasWeapon(level.var_5e75629a))
			{
				player TakeWeapon(level.var_5e75629a);
			}
			else if(player function_f11b379d())
			{
				var_dc7ddcde = player GetCurrentWeapon();
				player TakeWeapon(var_dc7ddcde);
			}
			player GiveWeapon(level.var_a4052592);
			player giveMaxAmmo(level.var_a4052592);
			player SwitchToWeapon(level.var_a4052592);
			var_85b2b1ab = GetEnt("wwup_station", "targetname");
			var_85b2b1ab Detach(level.var_7cb81d3c.model, "mirg_cent_gun_tag_jnt");
			player notify("hash_b874720a");
		}
	}
}

/*
	Name: function_598781a4
	Namespace: namespace_eaae7728
	Checksum: 0xEBA6EF59
	Offset: 0x5178
	Size: 0x139
	Parameters: 0
	Flags: None
*/
function function_598781a4()
{
	self endon("disconnect");
	level endon("hash_5d5bf177");
	level flag::wait_till("trilogy_released");
	var_537f25a1 = GetEnt("ww_upgrade_cave_blocker", "targetname");
	self namespace_8aed53c9::function_7448e472(var_537f25a1);
	var_537f25a1 delete();
	var_b89c97ce = GetEnt("mdl_underwater_secretroom_rockwall", "targetname");
	if(isdefined(var_b89c97ce))
	{
		playsoundatposition("zmb_wpn_skullgun_discover", var_b89c97ce.origin);
		var_b89c97ce thread function_d5faaef8();
	}
	callback::remove_on_spawned(&function_598781a4);
	level notify("hash_5d5bf177");
}

/*
	Name: function_d5faaef8
	Namespace: namespace_eaae7728
	Checksum: 0xE3F8A8A2
	Offset: 0x52C0
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_d5faaef8()
{
	if(!(isdefined(self.var_7a022fa0) && self.var_7a022fa0))
	{
		self.var_7a022fa0 = 1;
		self clientfield::set("do_fade_material", 0);
		exploder::exploder("fxexp_508");
		wait(1);
		self delete();
	}
}

/*
	Name: function_c9d8bea4
	Namespace: namespace_eaae7728
	Checksum: 0xD3BFA599
	Offset: 0x5340
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function function_c9d8bea4(a_ents)
{
	level.var_f353ae68 = a_ents["fxanim_cage_trap"];
	level.var_f353ae68.var_ab85a1cc = 0;
	level.var_f353ae68.is_moving = 0;
	level.var_f353ae68.var_e3ad0f90 = 0;
	level.var_f353ae68.var_243fddfd = 0;
	level.var_f353ae68 SetIgnorePauseWorld(1);
}

/*
	Name: function_4ee53d8b
	Namespace: namespace_eaae7728
	Checksum: 0x276E1AE0
	Offset: 0x53D8
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_4ee53d8b(a_ents)
{
	level.var_5be6626d = a_ents["cage_trap_hatch"];
	level.var_5be6626d SetIgnorePauseWorld(1);
}

/*
	Name: hatch_open
	Namespace: namespace_eaae7728
	Checksum: 0xEDACB5BD
	Offset: 0x5420
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function hatch_open(a_ents)
{
	level thread function_e3f30b83(1);
	level waittill("open_hatch");
	hatch_clip(0);
	level.var_5be6626d thread scene::Play("p7_fxanim_zm_island_cage_trap_hatch_open_bundle", level.var_5be6626d);
	wait(3);
	level.var_5be6626d thread scene::Play("p7_fxanim_zm_island_cage_trap_hatch_close_bundle", level.var_5be6626d);
	hatch_clip(1);
}

/*
	Name: function_10877763
	Namespace: namespace_eaae7728
	Checksum: 0x7E630A67
	Offset: 0x54E0
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function function_10877763(a_ents)
{
	level waittill("hash_40a91595");
	hatch_clip(0);
	level.var_5be6626d thread scene::Play("p7_fxanim_zm_island_cage_trap_hatch_open_bundle", level.var_5be6626d);
	wait(3);
	level.var_5be6626d thread scene::Play("p7_fxanim_zm_island_cage_trap_hatch_close_bundle", level.var_5be6626d);
	hatch_clip(1);
}

/*
	Name: hatch_clip
	Namespace: namespace_eaae7728
	Checksum: 0x457A6203
	Offset: 0x5588
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function hatch_clip(var_46b6a64a)
{
	if(var_46b6a64a)
	{
		n_dist = 100;
	}
	else
	{
		n_dist = -100;
	}
	level.var_2ba557f2 MoveZ(n_dist, 0.05);
	level.var_2ba557f2 waittill("movedone");
	if(var_46b6a64a)
	{
		level.var_2ba557f2 connectpaths();
	}
	else
	{
		level.var_2ba557f2 disconnectpaths();
	}
}

/*
	Name: function_1dc42fdf
	Namespace: namespace_eaae7728
	Checksum: 0xCA921888
	Offset: 0x5640
	Size: 0x10B
	Parameters: 1
	Flags: None
*/
function function_1dc42fdf(var_7afe5e99)
{
	if(!isdefined(var_7afe5e99))
	{
		var_7afe5e99 = 1;
	}
	var_a2176993 = GetEnt("swamp_lab_ee_control_panel_elf", "targetname");
	if(var_7afe5e99)
	{
		var_a2176993 SetModel("p7_zm_isl_control_panel_cage");
		if(level.var_f353ae68.var_e3ad0f90)
		{
			level.var_e48a6587 setHintString(&"ZM_ISLAND_CAGE_RAISE");
		}
		else
		{
			level.var_e48a6587 setHintString(&"ZM_ISLAND_CAGE_LOWER");
		}
	}
	else
	{
		var_a2176993 SetModel("p7_zm_isl_control_panel_cage_off");
		level.var_e48a6587 setHintString(&"ZOMBIE_NEED_POWER");
	}
}

/*
	Name: function_961485f0
	Namespace: namespace_eaae7728
	Checksum: 0x8CD414A0
	Offset: 0x5758
	Size: 0x40F
	Parameters: 0
	Flags: None
*/
function function_961485f0()
{
	level.var_e48a6587 = GetEnt("trigger_swamp_cage", "targetname");
	level.var_e48a6587 setcursorhint("HINT_NOICON");
	level.var_e48a6587 setHintString(&"ZOMBIE_NEED_POWER");
	level.var_e48a6587.is_charged = 0;
	level.var_2e16e689 = 0;
	var_964b337d = GetEnt("clip_cage_control", "targetname");
	var_964b337d thread function_e2cd4141();
	level.var_326fd87 = GetEnt("linkto_swamp_cage_door", "targetname");
	level.var_326fd87.is_open = 0;
	var_adad709 = GetEnt("swamp_lab_ee_gate_door", "targetname");
	var_adad709 LinkTo(level.var_326fd87);
	level.var_ac769486 = GetEnt("clip_swamp_cage_door", "targetname");
	var_9620cdae = GetEnt("clip_cage_swamp", "targetname");
	var_ac769486 = GetEnt("clip_cage_swamp_door", "targetname");
	while(!isdefined(level.var_f353ae68))
	{
		wait(0.5);
	}
	var_9620cdae LinkTo(level.var_f353ae68);
	var_ac769486 LinkTo(level.var_f353ae68);
	level thread function_871dbb3a();
	while(!level.var_2e16e689)
	{
		wait(0.1);
	}
	level.var_e48a6587 setHintString(&"ZM_ISLAND_CAGE_LOWER");
	while(1)
	{
		while(level.var_f353ae68.is_moving)
		{
			util::wait_network_frame();
		}
		level.var_e48a6587 waittill("trigger", player);
		level notify("hash_9d1c8527");
		if(level.var_f353ae68.is_moving)
		{
			continue;
		}
		if(!level.var_2e16e689 && !level flag::get("power_on"))
		{
			continue;
		}
		while(isdefined(var_964b337d.var_3c8bdb5a) && var_964b337d.var_3c8bdb5a)
		{
			wait(0.05);
		}
		if(!level.var_f353ae68.var_e3ad0f90)
		{
			function_3cd05ecf("down");
			level thread function_1d3366a8();
			level thread namespace_f333593c::function_3bf2d62a("lower_cage", 0, 0, 1);
		}
		else
		{
			function_3cd05ecf("up");
			level thread namespace_f333593c::function_3bf2d62a("raise_cage", 0, 0, 1);
		}
	}
}

/*
	Name: function_1d3366a8
	Namespace: namespace_eaae7728
	Checksum: 0x4FD136B4
	Offset: 0x5B70
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_1d3366a8()
{
	level endon("hash_9d1c8527");
	wait(60);
	if(level.var_f353ae68.var_e3ad0f90 && !level.var_f353ae68.is_moving)
	{
		function_3cd05ecf("up");
	}
}

/*
	Name: function_871dbb3a
	Namespace: namespace_eaae7728
	Checksum: 0x3BF1C5AE
	Offset: 0x5BD0
	Size: 0x1FB
	Parameters: 0
	Flags: None
*/
function function_871dbb3a()
{
	level flag::wait_till("power_on");
	level.var_9fce15de SetVisibleToAll();
	while(1)
	{
		level.var_9fce15de waittill("trigger", player);
		if(level.var_f353ae68.is_moving)
		{
			continue;
		}
		if(!level.var_f353ae68.var_ab85a1cc)
		{
			level.var_f353ae68.var_ab85a1cc = 1;
			level.var_9fce15de SetInvisibleToAll();
			if(level flag::get("solo_game"))
			{
				function_d452a2ca(player);
				wait(1);
				function_3cd05ecf("down");
				level thread namespace_f333593c::function_3bf2d62a("lower_cage", 0, 0, 1);
				wait(5);
				function_3cd05ecf("up");
				level thread namespace_f333593c::function_3bf2d62a("raise_cage", 0, 0, 1);
				player Unlink();
			}
			while(player istouching(level.var_9fce15de))
			{
				wait(0.1);
			}
			level.var_9fce15de SetVisibleToAll();
			level.var_f353ae68.var_ab85a1cc = 0;
		}
	}
}

/*
	Name: function_d452a2ca
	Namespace: namespace_eaae7728
	Checksum: 0x2A82EFD6
	Offset: 0x5DD8
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function function_d452a2ca(player)
{
	e_linkto = GetEnt("cage_linkto", "targetname");
	e_linkto LinkTo(level.var_f353ae68);
	player SetOrigin(e_linkto.origin);
	util::wait_network_frame();
	player playerLinkTo(e_linkto);
}

/*
	Name: function_e2cd4141
	Namespace: namespace_eaae7728
	Checksum: 0xEC17AE4E
	Offset: 0x5E80
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function function_e2cd4141()
{
	self waittill("charged");
	level.var_e48a6587.is_charged = 1;
	if(!level.var_f353ae68.var_e3ad0f90 && !level.var_326fd87.is_open)
	{
		self.var_3c8bdb5a = 1;
		level.var_326fd87 function_953bec10("open");
		self.var_3c8bdb5a = 0;
	}
}

/*
	Name: function_953bec10
	Namespace: namespace_eaae7728
	Checksum: 0xE6294A61
	Offset: 0x5F10
	Size: 0x193
	Parameters: 1
	Flags: None
*/
function function_953bec10(str_state)
{
	var_ac769486 = GetEnt("clip_cage_swamp_door", "targetname");
	if(str_state == "close")
	{
		n_rotate = -45;
		level.var_ac769486 solid();
		var_ac769486 solid();
	}
	else
	{
		n_rotate = 45;
	}
	self RotateYaw(n_rotate, 2);
	self playsound("evt_spider_gate_move");
	self waittill("rotatedone");
	if(str_state == "close")
	{
		self.is_open = 0;
		level.var_f353ae68 scene::Play("p7_fxanim_zm_island_cage_trap_tp_door_close_bundle", level.var_f353ae68);
	}
	else
	{
		self.is_open = 1;
		level.var_ac769486 notsolid();
		var_ac769486 notsolid();
		level.var_f353ae68 scene::Play("p7_fxanim_zm_island_cage_trap_tp_door_open_bundle", level.var_f353ae68);
	}
}

/*
	Name: function_3cd05ecf
	Namespace: namespace_eaae7728
	Checksum: 0xFC7F169D
	Offset: 0x60B0
	Size: 0x4D9
	Parameters: 1
	Flags: None
*/
function function_3cd05ecf(str_direction)
{
	level thread function_46d3d1b0(1);
	level.var_f353ae68.is_moving = 1;
	if(!level flag::get("solo_game"))
	{
		for(i = 0; i < level.players.size; i++)
		{
			if(level.players[i] istouching(level.var_9fce15de))
			{
				level.players[i].var_90f735f8 = 1;
				function_d452a2ca(level.players[i]);
				wait(0.25);
				break;
			}
		}
	}
	level.var_e48a6587 setHintString("");
	if(str_direction == "down")
	{
		level.var_f353ae68.var_e3ad0f90 = 1;
		if(level.var_326fd87.is_open)
		{
			level.var_326fd87 function_953bec10("close");
		}
		if(level.var_e48a6587.is_charged)
		{
			level.var_f353ae68 scene::Play("p7_fxanim_zm_island_cage_trap_low_down_bundle", level.var_f353ae68);
			level.var_f353ae68.var_243fddfd = 1;
		}
		else
		{
			hatch_clip(0);
			level thread function_e3f30b83(0);
			level.var_f353ae68 scene::Play("p7_fxanim_zm_island_cage_trap_mid_down_bundle", level.var_f353ae68);
		}
		wait(0.5);
		level.var_e48a6587 setHintString(&"ZM_ISLAND_CAGE_RAISE");
	}
	else
	{
		t_kill = spawn("trigger_radius", (2591, 765, -475), 0, 20, 40);
		t_kill thread function_6a47d3d7();
		level.var_f353ae68.var_e3ad0f90 = 0;
		if(level.var_e48a6587.is_charged && level.var_f353ae68.var_243fddfd)
		{
			level.var_f353ae68 scene::Play("p7_fxanim_zm_island_cage_trap_low_up_bundle", level.var_f353ae68);
			level.var_f353ae68.var_243fddfd = 0;
		}
		else
		{
			hatch_clip(1);
			level.var_f353ae68 scene::Play("p7_fxanim_zm_island_cage_trap_mid_up_bundle", level.var_f353ae68);
		}
		if(!level.var_326fd87.is_open && level.var_e48a6587.is_charged)
		{
			level.var_326fd87 function_953bec10("open");
		}
		wait(0.5);
		level.var_e48a6587 setHintString(&"ZM_ISLAND_CAGE_LOWER");
		t_kill delete();
	}
	level.var_f353ae68.is_moving = 0;
	if(!level.var_f353ae68.var_e3ad0f90)
	{
		level thread function_46d3d1b0(0);
		foreach(player in level.players)
		{
			if(isdefined(player.var_90f735f8) && player.var_90f735f8)
			{
				player.var_90f735f8 = 0;
				player Unlink();
			}
		}
	}
}

/*
	Name: function_46d3d1b0
	Namespace: namespace_eaae7728
	Checksum: 0x493D0179
	Offset: 0x6598
	Size: 0x159
	Parameters: 1
	Flags: None
*/
function function_46d3d1b0(var_9330a364)
{
	if(var_9330a364)
	{
		foreach(player in level.players)
		{
			if(player istouching(level.var_9fce15de))
			{
				player.var_b0329be9 = 1;
			}
		}
		break;
	}
	foreach(player in level.players)
	{
		if(isdefined(player.var_b0329be9) && player.var_b0329be9)
		{
			player.var_b0329be9 = 0;
		}
	}
}

/*
	Name: function_e3f30b83
	Namespace: namespace_eaae7728
	Checksum: 0xBA0801E5
	Offset: 0x6700
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function function_e3f30b83(var_d5d05f50)
{
	n_radius = 25;
	n_height = 100;
	v_pos = (2591, 765, -687);
	if(var_d5d05f50)
	{
		wait(2);
	}
	else
	{
		wait(1.5);
	}
	t_kill = spawn("trigger_radius", v_pos, 0, n_radius, n_height);
	t_kill thread function_6a47d3d7();
	wait(0.5);
	t_kill delete();
}

/*
	Name: function_6a47d3d7
	Namespace: namespace_eaae7728
	Checksum: 0xB11F6CD3
	Offset: 0x67D8
	Size: 0x1F7
	Parameters: 0
	Flags: None
*/
function function_6a47d3d7()
{
	self endon("death");
	var_8e4b278 = undefined;
	v_org = (2671, 851, -687);
	e_linkto = GetEnt("cage_linkto", "targetname");
	while(1)
	{
		foreach(player in level.activePlayers)
		{
			if(player istouching(self) && !player islinkedto(e_linkto))
			{
				while(!isdefined(var_8e4b278))
				{
					var_8e4b278 = GetClosestPointOnNavMesh(v_org, 48);
					wait(0.05);
				}
				if(isdefined(player))
				{
					player SetOrigin(var_8e4b278);
					player PlayRumbleOnEntity("damage_heavy");
					player DoDamage(player.health, player.origin);
					player playlocalsound(level.zmb_laugh_alias);
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_bc717528
	Namespace: namespace_eaae7728
	Checksum: 0x63C6619D
	Offset: 0x69D8
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_bc717528()
{
	self.var_1da52e7e = namespace_8aed53c9::function_d095318(self GetTagOrigin("Tag_tooth_RI"), 50, 1, &function_2f27cb1);
	self thread function_72c5554a("wwup2_found");
}

/*
	Name: function_72c5554a
	Namespace: namespace_eaae7728
	Checksum: 0x88BBDE9B
	Offset: 0x6A50
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function function_72c5554a(str_flag)
{
	while(1)
	{
		self.var_1da52e7e waittill("trigger", player);
		if(zm_utility::is_player_valid(player))
		{
			player notify("hash_f33f0d2a");
			zm_unitrigger::unregister_unitrigger(self);
			level flag::set(str_flag);
			self.var_1da52e7e = undefined;
			self HidePart("Tag_tooth_RI");
			level thread function_ce9a171c(str_flag);
			break;
		}
	}
}

/*
	Name: function_2f27cb1
	Namespace: namespace_eaae7728
	Checksum: 0x554A3654
	Offset: 0x6B30
	Size: 0x11
	Parameters: 1
	Flags: Private
*/
function private function_2f27cb1(player)
{
	return "";
}

/*
	Name: function_b7685b2e
	Namespace: namespace_eaae7728
	Checksum: 0xE0C304BD
	Offset: 0x6B50
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function function_b7685b2e()
{
	var_f96ad154 = struct::get("ee_planting_spot", "script_noteworthy");
	var_4b9ce062 = util::spawn_model("tag_origin", var_f96ad154.origin);
	level flag::wait_till("ww_upgrade_spawned_from_plant");
	util::wait_network_frame();
	var_4b9ce062.trigger = namespace_8aed53c9::function_d095318(var_4b9ce062.origin, 50, 1, &function_9bd3096f);
	var_4b9ce062 thread function_2578c564("wwup3_found");
}

/*
	Name: function_e2b90d40
	Namespace: namespace_eaae7728
	Checksum: 0xD10DCCA1
	Offset: 0x6C40
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function function_e2b90d40()
{
	var_2c2cf2e6 = struct::get("wweapon_up_part_wwup1");
	var_babd6f9c = util::spawn_model("p7_zm_bgb_vial", var_2c2cf2e6.origin, var_2c2cf2e6.angles);
	var_babd6f9c.trigger = namespace_8aed53c9::function_d095318(var_babd6f9c.origin, 100, 1, &function_9bd3096f);
	var_babd6f9c thread function_2578c564("wwup1_found");
}

/*
	Name: function_ce9a171c
	Namespace: namespace_eaae7728
	Checksum: 0x8DBA6D1F
	Offset: 0x6D10
	Size: 0x2B5
	Parameters: 1
	Flags: None
*/
function function_ce9a171c(str_flag)
{
	a_players = [];
	if(self == level)
	{
		a_players = level.players;
	}
	else if(isPlayer(self))
	{
		a_players = Array(self);
	}
	else
	{
		return;
	}
	switch(str_flag)
	{
		case "ww1_found":
		{
			foreach(player in a_players)
			{
				player clientfield::set_to_player("wonderweapon_part_wwi", 1);
				player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.wonderweapon_part_wwi", "zmInventory.widget_wonderweapon_parts", 0);
			}
			break;
		}
		case "ww2_found":
		{
			foreach(player in a_players)
			{
				player clientfield::set_to_player("wonderweapon_part_wwii", 1);
				player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.wonderweapon_part_wwii", "zmInventory.widget_wonderweapon_parts", 0);
			}
			break;
		}
		case "ww3_found":
		{
			foreach(player in a_players)
			{
				player clientfield::set_to_player("wonderweapon_part_wwiii", 1);
				player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.wonderweapon_part_wwiii", "zmInventory.widget_wonderweapon_parts", 0);
			}
			break;
		}
	}
}

/*
	Name: function_982c97e5
	Namespace: namespace_eaae7728
	Checksum: 0x796117BD
	Offset: 0x6FD0
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function function_982c97e5()
{
	/#
		zm_devgui::function_4acecab5(&function_efbc0e1);
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
	Name: function_efbc0e1
	Namespace: namespace_eaae7728
	Checksum: 0x9E79C1CE
	Offset: 0x70E0
	Size: 0x42D
	Parameters: 1
	Flags: None
*/
function function_efbc0e1(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				level.var_622692a9++;
				level thread function_ce9a171c("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				level.var_622692a9++;
				level thread function_ce9a171c("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				level.var_622692a9++;
				level thread function_ce9a171c("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				level.var_622692a9 = 3;
				level thread function_ce9a171c("Dev Block strings are not supported");
				level thread function_ce9a171c("Dev Block strings are not supported");
				level thread function_ce9a171c("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				level thread function_ce9a171c("Dev Block strings are not supported");
				level thread function_ce9a171c("Dev Block strings are not supported");
				level thread function_ce9a171c("Dev Block strings are not supported");
				level thread function_9279976b(level.players[0]);
				return 1;
			}
		}
		return 0;
	#/
}

