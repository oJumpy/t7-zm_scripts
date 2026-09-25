#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_zod_quest;
#using scripts\zm\zm_zod_util;
#using scripts\zm\zm_zod_vo;

#namespace zm_zod_craftables;

/*
	Name: randomize_craftable_spawns
	Namespace: zm_zod_craftables
	Checksum: 0x99EC1590
	Offset: 0xB48
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function randomize_craftable_spawns()
{
}

/*
	Name: include_craftables
	Namespace: zm_zod_craftables
	Checksum: 0x1F7879F7
	Offset: 0xB58
	Size: 0x12EB
	Parameters: 0
	Flags: None
*/
function include_craftables()
{
	level.craftable_piece_swap_allowed = 0;
	var_2a7833c8 = getnumexpectedplayers() == 1;
	var_16b36a95 = 1;
	craftable_name = "police_box";
	var_c157a58b = zm_craftables::generate_zombie_craftable_piece(craftable_name, "fuse_01", 32, 64, 0, undefined, &function_27ef9857, undefined, &function_6c41d7f2, undefined, undefined, undefined, "police_box" + "_" + "fuse_01", 1, undefined, undefined, &"ZM_ZOD_POLICE_BOX_PICKUP_FUSE", 4);
	var_4f503650 = zm_craftables::generate_zombie_craftable_piece(craftable_name, "fuse_02", 32, 64, 0, undefined, &function_27ef9857, undefined, &function_6c41d7f2, undefined, undefined, undefined, "police_box" + "_" + "fuse_02", 1, undefined, undefined, &"ZM_ZOD_POLICE_BOX_PICKUP_FUSE", 4);
	var_7552b0b9 = zm_craftables::generate_zombie_craftable_piece(craftable_name, "fuse_03", 32, 64, 0, undefined, &function_27ef9857, undefined, &function_6c41d7f2, undefined, undefined, undefined, "police_box" + "_" + "fuse_03", 1, undefined, undefined, &"ZM_ZOD_POLICE_BOX_PICKUP_FUSE", 4);
	if(var_2a7833c8)
	{
		var_c157a58b.is_shared = 1;
		var_4f503650.is_shared = 1;
		var_7552b0b9.is_shared = 1;
		var_c157a58b.client_field_state = undefined;
		var_4f503650.client_field_state = undefined;
		var_7552b0b9.client_field_state = undefined;
	}
	var_ab257b31 = spawnstruct();
	var_ab257b31.name = craftable_name;
	var_ab257b31 zm_craftables::add_craftable_piece(var_c157a58b, "j_fuse_01");
	var_ab257b31 zm_craftables::add_craftable_piece(var_4f503650, "j_fuse_02");
	var_ab257b31 zm_craftables::add_craftable_piece(var_7552b0b9, "j_fuse_03");
	var_ab257b31.triggerThink = &function_141a8c6e;
	var_ab257b31.no_challenge_stat = 1;
	level flag::init("fuse_01" + "_found");
	level flag::init("fuse_02" + "_found");
	level flag::init("fuse_03" + "_found");
	level flag::init("police_box_fuse_place");
	zm_craftables::include_zombie_craftable(var_ab257b31);
	craftable_name = "idgun";
	var_23fa21ad = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_heart", 32, 64, 0, undefined, &function_d5cdb383, undefined, undefined, undefined, undefined, undefined, "idgun" + "_" + "part_heart", 1, undefined, undefined, &"ZM_ZOD_IDGUN_PART_HEART", 2);
	var_def64f56 = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_skeleton", 32, 64, 0, undefined, &function_d5cdb383, undefined, undefined, undefined, undefined, undefined, "idgun" + "_" + "part_skeleton", 1, undefined, undefined, &"ZM_ZOD_IDGUN_PART_SKELETON", 2);
	var_7d85245c = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_xenomatter", 32, 64, 0, undefined, &function_d5cdb383, undefined, undefined, undefined, undefined, undefined, "idgun" + "_" + "part_xenomatter", 1, undefined, undefined, &"ZM_ZOD_IDGUN_PART_XENOMATTER", 2);
	var_23fa21ad.client_field_state = undefined;
	var_def64f56.client_field_state = undefined;
	var_7d85245c.client_field_state = undefined;
	idgun = spawnstruct();
	idgun.name = craftable_name;
	idgun zm_craftables::add_craftable_piece(var_23fa21ad);
	idgun zm_craftables::add_craftable_piece(var_def64f56);
	idgun zm_craftables::add_craftable_piece(var_7d85245c);
	idgun.onBuyWeapon = &function_57f30dec;
	idgun.triggerThink = &function_7a49123b;
	zm_craftables::include_zombie_craftable(idgun);
	level flag::init("part_heart" + "_found");
	level flag::init("part_skeleton" + "_found");
	level flag::init("part_xenomatter" + "_found");
	craftable_name = "second_idgun";
	var_62ffc1ec = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_heart", 32, 64, 0, undefined, &function_d5cdb383, undefined, undefined, undefined, undefined, undefined, "second_idgun" + "_" + "part_heart", 1, undefined, undefined, &"ZM_ZOD_IDGUN_PART_HEART", 3);
	var_50a8320d = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_skeleton", 32, 64, 0, undefined, &function_d5cdb383, undefined, undefined, undefined, undefined, undefined, "second_idgun" + "_" + "part_skeleton", 1, undefined, undefined, &"ZM_ZOD_IDGUN_PART_SKELETON", 3);
	var_fa9ad3bb = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_xenomatter", 32, 64, 0, undefined, &function_d5cdb383, undefined, undefined, undefined, undefined, undefined, "second_idgun" + "_" + "part_xenomatter", 1, undefined, undefined, &"ZM_ZOD_IDGUN_PART_XENOMATTER", 3);
	var_62ffc1ec.client_field_state = undefined;
	var_50a8320d.client_field_state = undefined;
	var_fa9ad3bb.client_field_state = undefined;
	var_4220199f = spawnstruct();
	var_4220199f.name = craftable_name;
	var_4220199f zm_craftables::add_craftable_piece(var_62ffc1ec);
	var_4220199f zm_craftables::add_craftable_piece(var_50a8320d);
	var_4220199f zm_craftables::add_craftable_piece(var_fa9ad3bb);
	var_4220199f.triggerThink = &function_ee72d458;
	zm_craftables::include_zombie_craftable(var_4220199f);
	level flag::init("part_heart" + "_found");
	level flag::init("part_skeleton" + "_found");
	level flag::init("part_xenomatter" + "_found");
	craftable_name = "ritual_boxer";
	var_82bbd61f = zm_craftables::generate_zombie_craftable_piece(craftable_name, "memento_boxer", 32, 64, 0, undefined, &function_145636eb, undefined, &function_eaf7ab24, undefined, undefined, undefined, 1, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_BOXER", 0);
	if(var_16b36a95)
	{
		var_82bbd61f.is_shared = 1;
		var_82bbd61f.client_field_state = undefined;
	}
	var_364b172f = spawnstruct();
	var_364b172f.name = craftable_name;
	var_364b172f zm_craftables::add_craftable_piece(var_82bbd61f);
	var_364b172f.triggerThink = &function_22d06508;
	var_364b172f.no_challenge_stat = 1;
	zm_craftables::include_zombie_craftable(var_364b172f);
	level flag::init("memento_boxer" + "_found");
	craftable_name = "ritual_detective";
	var_4d0fe4ac = zm_craftables::generate_zombie_craftable_piece(craftable_name, "memento_detective", 32, 64, 0, undefined, &function_145636eb, undefined, &function_eaf7ab24, undefined, undefined, undefined, 2, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_DETECTIVE", 0);
	if(var_16b36a95)
	{
		var_4d0fe4ac.is_shared = 1;
		var_4d0fe4ac.client_field_state = undefined;
	}
	var_75566ac0 = spawnstruct();
	var_75566ac0.name = craftable_name;
	var_75566ac0 zm_craftables::add_craftable_piece(var_4d0fe4ac);
	var_75566ac0.triggerThink = &function_8d3b0a6b;
	var_75566ac0.no_challenge_stat = 1;
	zm_craftables::include_zombie_craftable(var_75566ac0);
	level flag::init("memento_detective" + "_found");
	craftable_name = "ritual_femme";
	var_9676733f = zm_craftables::generate_zombie_craftable_piece(craftable_name, "memento_femme", 32, 64, 0, undefined, &function_145636eb, undefined, &function_eaf7ab24, undefined, undefined, undefined, 3, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_FEMME", 0);
	if(var_16b36a95)
	{
		var_9676733f.is_shared = 1;
		var_9676733f.client_field_state = undefined;
	}
	var_d9c7dc8f = spawnstruct();
	var_d9c7dc8f.name = craftable_name;
	var_d9c7dc8f zm_craftables::add_craftable_piece(var_9676733f);
	var_d9c7dc8f.triggerThink = &function_5c92a428;
	var_d9c7dc8f.no_challenge_stat = 1;
	zm_craftables::include_zombie_craftable(var_d9c7dc8f);
	level flag::init("memento_femme" + "_found");
	craftable_name = "ritual_magician";
	var_7330e760 = zm_craftables::generate_zombie_craftable_piece(craftable_name, "memento_magician", 32, 64, 0, undefined, &function_145636eb, undefined, &function_eaf7ab24, undefined, undefined, undefined, 4, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_MAGICIAN", 0);
	if(var_16b36a95)
	{
		var_7330e760.is_shared = 1;
		var_7330e760.client_field_state = undefined;
	}
	var_3d961ca4 = spawnstruct();
	var_3d961ca4.name = craftable_name;
	var_3d961ca4 zm_craftables::add_craftable_piece(var_7330e760);
	var_3d961ca4.triggerThink = &function_a7cee407;
	var_3d961ca4.no_challenge_stat = 1;
	zm_craftables::include_zombie_craftable(var_3d961ca4);
	level flag::init("memento_magician" + "_found");
	craftable_name = "ritual_pap";
	var_74e95d7d = zm_craftables::generate_zombie_craftable_piece(craftable_name, "relic_boxer", 32, 64, 0, undefined, &function_145636eb, undefined, &function_eaf7ab24, undefined, undefined, undefined, 1, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_RELIC", 1);
	var_b31fe12 = zm_craftables::generate_zombie_craftable_piece(craftable_name, "relic_detective", 32, 64, 0, undefined, &function_145636eb, undefined, &function_eaf7ab24, undefined, undefined, undefined, 2, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_RELIC", 1);
	var_fc4796bd = zm_craftables::generate_zombie_craftable_piece(craftable_name, "relic_femme", 32, 64, 0, undefined, &function_145636eb, undefined, &function_eaf7ab24, undefined, undefined, undefined, 3, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_RELIC", 1);
	var_5c02f4ae = zm_craftables::generate_zombie_craftable_piece(craftable_name, "relic_magician", 32, 64, 0, undefined, &function_145636eb, undefined, &function_eaf7ab24, undefined, undefined, undefined, 4, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_RELIC", 1);
	if(var_16b36a95)
	{
		var_74e95d7d.is_shared = 1;
		var_b31fe12.is_shared = 1;
		var_fc4796bd.is_shared = 1;
		var_5c02f4ae.is_shared = 1;
		var_74e95d7d.client_field_state = undefined;
		var_b31fe12.client_field_state = undefined;
		var_fc4796bd.client_field_state = undefined;
		var_5c02f4ae.client_field_state = undefined;
	}
	var_18d1ed5a = spawnstruct();
	var_18d1ed5a.name = craftable_name;
	var_18d1ed5a zm_craftables::add_craftable_piece(var_74e95d7d);
	var_18d1ed5a zm_craftables::add_craftable_piece(var_b31fe12);
	var_18d1ed5a zm_craftables::add_craftable_piece(var_fc4796bd);
	var_18d1ed5a zm_craftables::add_craftable_piece(var_5c02f4ae);
	var_18d1ed5a.triggerThink = &function_215ab729;
	var_18d1ed5a.no_challenge_stat = 1;
	zm_craftables::include_zombie_craftable(var_18d1ed5a);
	level flag::init("relic_boxer" + "_found");
	level flag::init("relic_detective" + "_found");
	level flag::init("relic_femme" + "_found");
	level flag::init("relic_magician" + "_found");
}

/*
	Name: init_craftables
	Namespace: zm_zod_craftables
	Checksum: 0x7E82C3F1
	Offset: 0x1E50
	Size: 0x32B
	Parameters: 0
	Flags: None
*/
function init_craftables()
{
	level.custom_craftable_validation = &function_a7fe5efc;
	register_clientfields();
	zm_craftables::add_zombie_craftable("police_box", &"ZM_ZOD_POLICE_BOX_PLACE_FUSE", &"ZM_ZOD_POLICE_BOX_PLACE_FUSE", &"ZM_ZOD_POLICE_BOX_POWER_ON", &function_c6c55eb6);
	zm_craftables::add_zombie_craftable("idgun", &"ZM_ZOD_CRAFT_IDGUN", "", &"ZM_ZOD_PICKUP_IDGUN", &function_8564e4f9, 1);
	zm_craftables::make_zombie_craftable_open("idgun", "", VectorScale((0, -1, 0), 90), (0, 0, 0));
	zm_craftables::add_zombie_craftable("second_idgun", &"ZM_ZOD_CRAFT_IDGUN", "", &"ZM_ZOD_PICKUP_IDGUN", &function_d80876ac, 1);
	zm_craftables::make_zombie_craftable_open("second_idgun", "", VectorScale((0, -1, 0), 90), (0, 0, 0));
	zm_craftables::add_zombie_craftable("ritual_boxer", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_BOXER", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_BOXER", &"ZM_ZOD_QUEST_RITUAL_INITIATE", &function_469080d7);
	zm_craftables::add_zombie_craftable("ritual_detective", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_DETECTIVE", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_DETECTIVE", &"ZM_ZOD_QUEST_RITUAL_INITIATE", &function_469080d7);
	zm_craftables::add_zombie_craftable("ritual_femme", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_FEMME", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_FEMME", &"ZM_ZOD_QUEST_RITUAL_INITIATE", &function_469080d7);
	zm_craftables::add_zombie_craftable("ritual_magician", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_MAGICIAN", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_MAGICIAN", &"ZM_ZOD_QUEST_RITUAL_INITIATE", &function_469080d7);
	zm_craftables::add_zombie_craftable("ritual_pap", &"ZM_ZOD_QUEST_RITUAL_PLACE_RELIC", &"ZM_ZOD_QUEST_RITUAL_PLACE_RELIC", &"ZM_ZOD_QUEST_RITUAL_INITIATE", &function_469080d7);
	zm_craftables::set_build_time("police_box", 0);
	zm_craftables::set_build_time("ritual_boxer", 0);
	zm_craftables::set_build_time("ritual_detective", 0);
	zm_craftables::set_build_time("ritual_femme", 0);
	zm_craftables::set_build_time("ritual_magician", 0);
	zm_craftables::set_build_time("ritual_pap", 0);
}

/*
	Name: register_clientfields
	Namespace: zm_zod_craftables
	Checksum: 0x643FD861
	Offset: 0x2188
	Size: 0x623
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	var_a0199abd = 1;
	RegisterClientField("world", "police_box" + "_" + "fuse_01", 1, var_a0199abd, "int", undefined, 0);
	RegisterClientField("world", "police_box" + "_" + "fuse_02", 1, var_a0199abd, "int", undefined, 0);
	RegisterClientField("world", "police_box" + "_" + "fuse_03", 1, var_a0199abd, "int", undefined, 0);
	RegisterClientField("world", "idgun" + "_" + "part_heart", 1, var_a0199abd, "int", undefined, 0);
	RegisterClientField("world", "idgun" + "_" + "part_skeleton", 1, var_a0199abd, "int", undefined, 0);
	RegisterClientField("world", "idgun" + "_" + "part_xenomatter", 1, var_a0199abd, "int", undefined, 0);
	RegisterClientField("world", "second_idgun" + "_" + "part_heart", 1, var_a0199abd, "int", undefined, 0);
	RegisterClientField("world", "second_idgun" + "_" + "part_skeleton", 1, var_a0199abd, "int", undefined, 0);
	RegisterClientField("world", "second_idgun" + "_" + "part_xenomatter", 1, var_a0199abd, "int", undefined, 0);
	foreach(character_name in level.var_6f8e5f09)
	{
		RegisterClientField("world", "holder_of_" + character_name, 1, 3, "int", undefined, 0);
	}
	foreach(character_name in level.var_6f8e5f09)
	{
		RegisterClientField("world", "quest_state_" + character_name, 1, 3, "int", undefined, 0);
	}
	clientfield::register("toplayer", "ZM_ZOD_UI_FUSE_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_FUSE_PLACED", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_FUSE_CRAFTED", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_IDGUN_HEART_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_IDGUN_TENTACLE_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_IDGUN_XENOMATTER_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_IDGUN_CRAFTED", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_MEMENTO_BOXER_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_MEMENTO_DETECTIVE_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_MEMENTO_FEMME_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_MEMENTO_MAGICIAN_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_GATEWORM_PICKUP", 1, 1, "int");
}

/*
	Name: craftable_add_glow_fx
	Namespace: zm_zod_craftables
	Checksum: 0xFBB6AF44
	Offset: 0x27B8
	Size: 0x11F
	Parameters: 0
	Flags: None
*/
function craftable_add_glow_fx()
{
	level flag::wait_till("start_zombie_round_logic");
	foreach(s_craftable in level.zombie_include_craftables)
	{
		foreach(s_piece in s_craftable.a_piecestubs)
		{
			s_piece craftable_waittill_spawned();
		}
	}
}

/*
	Name: craftable_waittill_spawned
	Namespace: zm_zod_craftables
	Checksum: 0xD4F99449
	Offset: 0x28E0
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function craftable_waittill_spawned()
{
	while(!isdefined(self.pieceSpawn))
	{
		util::wait_network_frame();
	}
}

/*
	Name: onDrop_Common
	Namespace: zm_zod_craftables
	Checksum: 0x9D8CD50C
	Offset: 0x2910
	Size: 0x15
	Parameters: 1
	Flags: None
*/
function onDrop_Common(player)
{
	self.piece_owner = undefined;
}

/*
	Name: onPickup_Common
	Namespace: zm_zod_craftables
	Checksum: 0x7EB1CD68
	Offset: 0x2930
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function onPickup_Common(player)
{
	player thread function_9708cb71(self.pieceName);
	self.piece_owner = player;
}

/*
	Name: ondisconnect_common
	Namespace: zm_zod_craftables
	Checksum: 0x97777BD
	Offset: 0x2970
	Size: 0x253
	Parameters: 1
	Flags: None
*/
function ondisconnect_common(player)
{
	level endon("crafted_" + self.pieceName);
	level endon("dropped_" + self.pieceName);
	player waittill("disconnect");
	if(self.is_shared)
	{
		return;
	}
	var_c0262163 = level clientfield::get("quest_state_" + function_836451f4(self.pieceName));
	if(function_5d5371da(self.pieceName) && var_c0262163 < 3)
	{
		level clientfield::set("quest_state_" + function_836451f4(self.pieceName), 0);
		self.model clientfield::set("set_fade_material", 1);
		self.model clientfield::set("item_glow_fx", 3);
		level clientfield::set("holder_of_" + function_836451f4(self.pieceName), 0);
	}
	else if(function_f47faf9a(self.pieceName) && !level flag::get("ritual_pap_complete"))
	{
		level clientfield::set("quest_state_" + function_836451f4(self.pieceName), 3);
		self.model SetVisibleToAll();
		self.model clientfield::set("item_glow_fx", 2);
		level clientfield::set("holder_of_" + function_836451f4(self.pieceName), 0);
	}
}

/*
	Name: function_27ef9857
	Namespace: zm_zod_craftables
	Checksum: 0xAC1B939B
	Offset: 0x2BD0
	Size: 0x111
	Parameters: 1
	Flags: None
*/
function function_27ef9857(player)
{
	level flag::set(self.pieceName + "_found");
	player thread function_9708cb71(self.pieceName);
	foreach(e_player in level.players)
	{
		e_player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.player_crafted_fusebox", "zmInventory.widget_fuses", 0);
		e_player thread namespace_8e578893::show_infotext_for_duration("ZM_ZOD_UI_FUSE_PICKUP", 3.5);
	}
}

/*
	Name: function_6c41d7f2
	Namespace: zm_zod_craftables
	Checksum: 0xF8CFC1C0
	Offset: 0x2CF0
	Size: 0x119
	Parameters: 1
	Flags: None
*/
function function_6c41d7f2(player)
{
	var_6f73bd35 = GetEnt("police_box", "targetname");
	if(isdefined(var_6f73bd35))
	{
		var_6f73bd35 playsound("zmb_zod_fuse_place");
	}
	foreach(e_player in level.players)
	{
		e_player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.player_crafted_fusebox", "zmInventory.widget_fuses", 0);
		e_player thread namespace_8e578893::show_infotext_for_duration("ZM_ZOD_UI_FUSE_PLACED", 3.5);
	}
}

/*
	Name: function_1fb591f6
	Namespace: zm_zod_craftables
	Checksum: 0x50AE9A8A
	Offset: 0x2E18
	Size: 0x1FB
	Parameters: 1
	Flags: None
*/
function function_1fb591f6(player)
{
	/#
		println("Dev Block strings are not supported");
	#/
	level notify("dropped_" + self.pieceName);
	self droponmover(player);
	self.piece_owner = undefined;
	if(function_5d5371da(self.pieceName))
	{
		level.var_bb596164--;
		level clientfield::set("quest_state_" + function_836451f4(self.pieceName), 0);
		self.model clientfield::set("set_fade_material", 1);
		self.model clientfield::set("item_glow_fx", 3);
	}
	else if(function_f47faf9a(self.pieceName))
	{
		level.var_5e457a7c--;
		level clientfield::set("quest_state_" + function_836451f4(self.pieceName), 3);
		self.model clientfield::set("item_glow_fx", 2);
	}
	self.model.origin = player.origin;
	self.model SetVisibleToAll();
	level clientfield::set("holder_of_" + function_836451f4(self.pieceName), 0);
}

/*
	Name: function_145636eb
	Namespace: zm_zod_craftables
	Checksum: 0xF138CF8C
	Offset: 0x3020
	Size: 0x473
	Parameters: 1
	Flags: None
*/
function function_145636eb(player)
{
	/#
		println("Dev Block strings are not supported");
	#/
	if(!isdefined(level.var_bb596164))
	{
		level.var_bb596164 = 0;
		level.var_5e457a7c = 0;
		level.var_e879bcb = 1;
	}
	if(!(isdefined(self.var_34db6ce0) && self.var_34db6ce0))
	{
		self.var_34db6ce0 = 1;
		self.start_origin = self.model.origin;
		self.start_angles = self.model.angles;
	}
	self pickupfrommover();
	self.piece_owner = player;
	level flag::set(self.pieceName + "_found");
	if(function_5d5371da(self.pieceName))
	{
		level.var_bb596164++;
		level clientfield::set("quest_state_" + function_836451f4(self.pieceName), 1);
		player thread namespace_b8707f8e::function_32c9e1d9(self.pieceName);
	}
	else if(function_f47faf9a(self.pieceName))
	{
		level.var_5e457a7c++;
		level clientfield::set("quest_state_" + function_836451f4(self.pieceName), 4);
		str_name = function_836451f4(self.pieceName);
		level clientfield::set("ritual_state_" + str_name, 4);
		level thread exploder::stop_exploder("ritual_light_" + str_name + "_fin");
		player thread namespace_b8707f8e::function_2e3f1a98();
	}
	switch(self.pieceName)
	{
		case "memento_boxer":
		{
			str_infotext = "ZM_ZOD_UI_MEMENTO_BOXER_PICKUP";
			break;
		}
		case "memento_detective":
		{
			str_infotext = "ZM_ZOD_UI_MEMENTO_DETECTIVE_PICKUP";
			break;
		}
		case "memento_femme":
		{
			str_infotext = "ZM_ZOD_UI_MEMENTO_FEMME_PICKUP";
			break;
		}
		case "memento_magician":
		{
			str_infotext = "ZM_ZOD_UI_MEMENTO_MAGICIAN_PICKUP";
			break;
		}
		case "relic_boxer":
		case "relic_detective":
		case "relic_femme":
		case "relic_magician":
		{
			str_infotext = "ZM_ZOD_UI_GATEWORM_PICKUP";
			break;
		}
	}
	var_e85b4e8 = 0;
	switch(player.characterindex)
	{
		case 0:
		{
			var_e85b4e8 = 1;
			break;
		}
		case 1:
		{
			var_e85b4e8 = 2;
			break;
		}
		case 2:
		{
			var_e85b4e8 = 3;
			break;
		}
		case 3:
		{
			var_e85b4e8 = 4;
			break;
		}
	}
	level clientfield::set("holder_of_" + function_836451f4(self.pieceName), var_e85b4e8);
	if(level.var_e879bcb == level.var_bb596164)
	{
		level thread zm_audio::sndMusicSystem_PlayState("piece_" + level.var_e879bcb);
		level.var_e879bcb++;
	}
	player thread function_9708cb71(self.pieceName);
	player thread zm_craftables::player_show_craftable_parts_ui(undefined, "zmInventory.widget_quest_items", 0);
	player thread namespace_8e578893::show_infotext_for_duration(str_infotext, 3.5);
	self thread ondisconnect_common(player);
}

/*
	Name: function_d5cdb383
	Namespace: zm_zod_craftables
	Checksum: 0xB8F441F2
	Offset: 0x34A0
	Size: 0x179
	Parameters: 1
	Flags: None
*/
function function_d5cdb383(player)
{
	level flag::set(self.pieceName + "_found");
	level notify("hash_14edc619");
	player thread function_9708cb71(self.pieceName);
	switch(self.pieceName)
	{
		case "part_heart":
		{
			str_part = "ZM_ZOD_UI_IDGUN_HEART_PICKUP";
			break;
		}
		case "part_skeleton":
		{
			str_part = "ZM_ZOD_UI_IDGUN_TENTACLE_PICKUP";
			break;
		}
		case "part_xenomatter":
		{
			str_part = "ZM_ZOD_UI_IDGUN_XENOMATTER_PICKUP";
			break;
		}
	}
	foreach(e_player in level.players)
	{
		e_player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.player_crafted_idgun", "zmInventory.widget_idgun_parts", 0);
		e_player thread namespace_8e578893::show_infotext_for_duration(str_part, 3.5);
	}
}

/*
	Name: function_9708cb71
	Namespace: zm_zod_craftables
	Checksum: 0x80DE0767
	Offset: 0x3628
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function function_9708cb71(pieceName)
{
	var_983a0e9b = "zmb_zod_craftable_pickup";
	switch(pieceName)
	{
		case "memento_boxer":
		case "memento_detective":
		case "memento_femme":
		case "memento_magician":
		{
			var_983a0e9b = "zmb_zod_memento_pickup";
			break;
		}
		case "relic_boxer":
		case "relic_detective":
		case "relic_femme":
		case "relic_magician":
		{
			var_983a0e9b = "zmb_zod_ritual_worm_pickup";
			break;
		}
		case "part_heart":
		case "part_heart":
		case "part_skeleton":
		case "part_skeleton":
		case "part_xenomatter":
		case "part_xenomatter":
		{
			var_983a0e9b = "zmb_zod_idgunpiece_pickup";
			break;
		}
		case "fuse_01":
		case "fuse_02":
		case "fuse_03":
		{
			var_983a0e9b = "zmb_zod_fuse_pickup";
			break;
		}
		case default:
		{
			var_983a0e9b = "zmb_zod_craftable_pickup";
			break;
		}
	}
	self playsound(var_983a0e9b);
}

/*
	Name: function_c6c55eb6
	Namespace: zm_zod_craftables
	Checksum: 0xC8D7D462
	Offset: 0x3760
	Size: 0xED
	Parameters: 1
	Flags: None
*/
function function_c6c55eb6(e_player)
{
	level notify("hash_5b9acfd8");
	foreach(e_player in level.players)
	{
		if(zm_utility::is_player_valid(e_player))
		{
			e_player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.player_crafted_fusebox", "zmInventory.widget_fuses", 1);
			e_player thread namespace_8e578893::show_infotext_for_duration("ZM_ZOD_UI_FUSE_CRAFTED", 3.5);
		}
	}
	return 1;
}

/*
	Name: function_eaf7ab24
	Namespace: zm_zod_craftables
	Checksum: 0x7FC7A923
	Offset: 0x3858
	Size: 0x13B
	Parameters: 1
	Flags: None
*/
function function_eaf7ab24(player)
{
	if(function_5d5371da(self.pieceName))
	{
		level clientfield::set("quest_state_" + function_836451f4(self.pieceName), 2);
		player namespace_b8707f8e::function_c41d3e2e(self.pieceName);
	}
	else
	{
		level clientfield::set("quest_state_" + function_836451f4(self.pieceName), 5);
		var_2e58527b = GetEnt("quest_ritual_relic_placed_" + function_836451f4(self.pieceName), "targetname");
		var_2e58527b show();
	}
	level clientfield::set("holder_of_" + function_836451f4(self.pieceName), 0);
}

/*
	Name: function_469080d7
	Namespace: zm_zod_craftables
	Checksum: 0x8B0F08D9
	Offset: 0x39A0
	Size: 0xDF
	Parameters: 1
	Flags: None
*/
function function_469080d7(player)
{
	if(self.equipname != "ritual_pap")
	{
		str_character_name = function_836451f4(self.equipname);
		function_f8bb3971(str_character_name);
		start();
	}
	else
	{
		level flag::set("ritual_pap_ready");
		level clientfield::set("ritual_state_pap", 1);
		start();
	}
	return 1;
}

/*
	Name: function_f8bb3971
	Namespace: zm_zod_craftables
	Checksum: 0xE92FB643
	Offset: 0x3A88
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function function_f8bb3971(name)
{
	level flag::set("ritual_" + name + "_ready");
	level clientfield::set("ritual_state_" + name, 1);
	level clientfield::set("quest_state_" + name, 2);
}

/*
	Name: function_8564e4f9
	Namespace: zm_zod_craftables
	Checksum: 0xBF0435A4
	Offset: 0x3B18
	Size: 0x1D7
	Parameters: 1
	Flags: None
*/
function function_8564e4f9(player)
{
	if(!(isdefined(self.var_5449dda7) && self.var_5449dda7))
	{
		self.var_5449dda7 = 1;
		players = level.players;
		foreach(e_player in players)
		{
			if(zm_utility::is_player_valid(e_player))
			{
				e_player thread namespace_8e578893::show_infotext_for_duration("ZM_ZOD_UI_IDGUN_CRAFTED", 3.5);
				e_player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.player_crafted_idgun", "zmInventory.widget_idgun_parts", 1);
			}
		}
		self.model.origin = self.origin;
		self.model.angles = self.angles + VectorScale((0, -1, 0), 90);
		self.model SetModel("wpn_t7_zmb_zod_idg_world");
		self.var_356fbd8b = level.idgun[0].var_356fbd8b;
		self.weaponName = GetWeapon(level.idgun[self.var_356fbd8b].var_e4be281f);
	}
	return 1;
}

/*
	Name: function_57f30dec
	Namespace: zm_zod_craftables
	Checksum: 0xE7BD476A
	Offset: 0x3CF8
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function function_57f30dec(player)
{
	level.idgun[self.stub.var_356fbd8b].owner = player;
	level clientfield::set("add_idgun_to_box", level.idgun[self.stub.var_356fbd8b].var_e787e99a);
	level.zombie_weapons[self.stub.weaponName].is_in_box = 1;
	player namespace_b8707f8e::function_aca1bc0c(self.stub.var_356fbd8b);
}

/*
	Name: function_d80876ac
	Namespace: zm_zod_craftables
	Checksum: 0xA2E588AF
	Offset: 0x3DC8
	Size: 0x12F
	Parameters: 1
	Flags: None
*/
function function_d80876ac(player)
{
	players = level.players;
	foreach(e_player in players)
	{
		if(zm_utility::is_player_valid(e_player))
		{
			e_player thread namespace_8e578893::show_infotext_for_duration("ZM_ZOD_UI_IDGUN_CRAFTED", 3.5);
			e_player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.player_crafted_idgun", "zmInventory.widget_idgun_parts", 1);
		}
	}
	function_a0e4fb00(self.origin, self.origin, level.idgun[1].var_356fbd8b);
	return 1;
}

/*
	Name: function_a0e4fb00
	Namespace: zm_zod_craftables
	Checksum: 0xBD189B4D
	Offset: 0x3F00
	Size: 0x1AB
	Parameters: 3
	Flags: None
*/
function function_a0e4fb00(v_origin, v_angles, var_356fbd8b)
{
	width = 128;
	height = 128;
	length = 128;
	unitrigger_stub = spawnstruct();
	unitrigger_stub.origin = v_origin;
	unitrigger_stub.angles = v_angles;
	unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	unitrigger_stub.script_width = width;
	unitrigger_stub.script_height = height;
	unitrigger_stub.script_length = length;
	unitrigger_stub.require_look_at = 0;
	unitrigger_stub.var_356fbd8b = var_356fbd8b;
	unitrigger_stub.var_193180cc = spawn("script_model", v_origin);
	unitrigger_stub.var_193180cc SetModel("wpn_t7_zmb_zod_idg_world");
	unitrigger_stub.prompt_and_visibility_func = &function_e983d2a0;
	zm_unitrigger::register_static_unitrigger(unitrigger_stub, &function_bae02fd4);
}

/*
	Name: function_e983d2a0
	Namespace: zm_zod_craftables
	Checksum: 0x8ADA4811
	Offset: 0x40B8
	Size: 0x99
	Parameters: 1
	Flags: None
*/
function function_e983d2a0(player)
{
	var_356fbd8b = self.stub.var_356fbd8b;
	self setHintString(&"ZM_ZOD_PICKUP_IDGUN");
	b_is_invis = isdefined(player.beastmode) && player.beastmode;
	self SetInvisibleToPlayer(player, b_is_invis);
	return !b_is_invis;
}

/*
	Name: function_bae02fd4
	Namespace: zm_zod_craftables
	Checksum: 0xBEF0210B
	Offset: 0x4160
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function function_bae02fd4()
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
		level thread function_3071ed77(self.stub, player);
		break;
	}
}

/*
	Name: function_3071ed77
	Namespace: zm_zod_craftables
	Checksum: 0x575A1ADB
	Offset: 0x4210
	Size: 0x103
	Parameters: 2
	Flags: None
*/
function function_3071ed77(trig_stub, player)
{
	level.idgun[trig_stub.var_356fbd8b].owner = player;
	trig_stub.var_193180cc SetInvisibleToAll();
	var_566556d8 = GetWeapon(level.idgun[trig_stub.var_356fbd8b].var_e4be281f);
	player zm_weapons::weapon_give(var_566556d8, 0, 0);
	player SwitchToWeapon(var_566556d8);
	player namespace_b8707f8e::function_aca1bc0c(trig_stub.var_356fbd8b);
	zm_unitrigger::unregister_unitrigger(trig_stub);
}

/*
	Name: init_craftable_choke
	Namespace: zm_zod_craftables
	Checksum: 0x4752E9F9
	Offset: 0x4320
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function init_craftable_choke()
{
	level.craftables_spawned_this_frame = 0;
	while(1)
	{
		util::wait_network_frame();
		level.craftables_spawned_this_frame = 0;
	}
}

/*
	Name: craftable_wait_your_turn
	Namespace: zm_zod_craftables
	Checksum: 0x4322F490
	Offset: 0x4368
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function craftable_wait_your_turn()
{
	if(!isdefined(level.craftables_spawned_this_frame))
	{
		level thread init_craftable_choke();
	}
	while(level.craftables_spawned_this_frame >= 2)
	{
		util::wait_network_frame();
	}
	level.craftables_spawned_this_frame++;
}

/*
	Name: function_a7fe5efc
	Namespace: zm_zod_craftables
	Checksum: 0x6A596135
	Offset: 0x43C8
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function function_a7fe5efc(player)
{
	if(isdefined(player.beastmode) && player.beastmode)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_141a8c6e
	Namespace: zm_zod_craftables
	Checksum: 0xED6D56EC
	Offset: 0x4410
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_141a8c6e()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("police_box_usetrigger", "police_box", "police_box", "", 1, 0);
}

/*
	Name: function_22d06508
	Namespace: zm_zod_craftables
	Checksum: 0xD6929ED7
	Offset: 0x4468
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_22d06508()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("quest_ritual_usetrigger_boxer", "ritual_boxer", "ritual_boxer", "", 1, 0);
}

/*
	Name: function_8d3b0a6b
	Namespace: zm_zod_craftables
	Checksum: 0x23A1DFEB
	Offset: 0x44C0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_8d3b0a6b()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("quest_ritual_usetrigger_detective", "ritual_detective", "ritual_detective", "", 1, 0);
}

/*
	Name: function_5c92a428
	Namespace: zm_zod_craftables
	Checksum: 0xFECAD039
	Offset: 0x4518
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_5c92a428()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("quest_ritual_usetrigger_femme", "ritual_femme", "ritual_femme", "", 1, 0);
}

/*
	Name: function_a7cee407
	Namespace: zm_zod_craftables
	Checksum: 0x8B32E041
	Offset: 0x4570
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_a7cee407()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("quest_ritual_usetrigger_magician", "ritual_magician", "ritual_magician", "", 1, 0);
}

/*
	Name: function_215ab729
	Namespace: zm_zod_craftables
	Checksum: 0x2EBED938
	Offset: 0x45C8
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_215ab729()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("quest_ritual_usetrigger_pap", "ritual_pap", "ritual_pap", "", 1, 0);
}

/*
	Name: function_7a49123b
	Namespace: zm_zod_craftables
	Checksum: 0xDCEB045
	Offset: 0x4620
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_7a49123b()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("idgun_zm_craftable_trigger", "idgun", "idgun", &"ZM_ZOD_PICKUP_IDGUN", 1, 2);
}

/*
	Name: function_ee72d458
	Namespace: zm_zod_craftables
	Checksum: 0x38ABF079
	Offset: 0x4678
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_ee72d458()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("second_idgun_zm_craftable_trigger", "second_idgun", "second_idgun", "", 1, 0);
}

/*
	Name: function_836451f4
	Namespace: zm_zod_craftables
	Checksum: 0x397D315D
	Offset: 0x46D0
	Size: 0xD9
	Parameters: 1
	Flags: None
*/
function function_836451f4(name)
{
	var_a0d1067b = Array("boxer", "detective", "femme", "magician");
	foreach(character_name in var_a0d1067b)
	{
		if(IsSubStr(name, character_name))
		{
			return character_name;
		}
	}
}

/*
	Name: function_5d5371da
	Namespace: zm_zod_craftables
	Checksum: 0xB7194709
	Offset: 0x47B8
	Size: 0x6D
	Parameters: 1
	Flags: None
*/
function function_5d5371da(name)
{
	var_3e023e17 = Array("memento_boxer", "memento_detective", "memento_femme", "memento_magician");
	if(IsInArray(var_3e023e17, name))
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_f47faf9a
	Namespace: zm_zod_craftables
	Checksum: 0x2199FBA1
	Offset: 0x4830
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function function_f47faf9a(name)
{
	if(name == "relic_boxer" || name == "relic_detective" || name == "relic_femme" || name == "relic_magician")
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

/*
	Name: droponmover
	Namespace: zm_zod_craftables
	Checksum: 0xEC3C1F8D
	Offset: 0x4898
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function droponmover(player)
{
}

/*
	Name: pickupfrommover
	Namespace: zm_zod_craftables
	Checksum: 0x99EC1590
	Offset: 0x48B0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function pickupfrommover()
{
}

