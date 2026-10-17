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
	shared_pieces = getnumexpectedplayers() == 1;
	shared_quest_pieces = 1;
	craftable_name = "police_box";
	police_box_fuse_1 = zm_craftables::generate_zombie_craftable_piece(craftable_name, "fuse_01", 32, 64, 0, undefined, &onpickup_police_box_fuse, undefined, &function_6c41d7f2, undefined, undefined, undefined, "police_box" + "_" + "fuse_01", 1, undefined, undefined, &"ZM_ZOD_POLICE_BOX_PICKUP_FUSE", 4);
	police_box_fuse_2 = zm_craftables::generate_zombie_craftable_piece(craftable_name, "fuse_02", 32, 64, 0, undefined, &onpickup_police_box_fuse, undefined, &function_6c41d7f2, undefined, undefined, undefined, "police_box" + "_" + "fuse_02", 1, undefined, undefined, &"ZM_ZOD_POLICE_BOX_PICKUP_FUSE", 4);
	police_box_fuse_3 = zm_craftables::generate_zombie_craftable_piece(craftable_name, "fuse_03", 32, 64, 0, undefined, &onpickup_police_box_fuse, undefined, &function_6c41d7f2, undefined, undefined, undefined, "police_box" + "_" + "fuse_03", 1, undefined, undefined, &"ZM_ZOD_POLICE_BOX_PICKUP_FUSE", 4);
	if(shared_pieces)
	{
		police_box_fuse_1.is_shared = 1;
		police_box_fuse_2.is_shared = 1;
		police_box_fuse_3.is_shared = 1;
		police_box_fuse_1.client_field_state = undefined;
		police_box_fuse_2.client_field_state = undefined;
		police_box_fuse_3.client_field_state = undefined;
	}
	var_ab257b31 = spawnstruct();
	var_ab257b31.name = craftable_name;
	var_ab257b31 zm_craftables::add_craftable_piece(police_box_fuse_1, "j_fuse_01");
	var_ab257b31 zm_craftables::add_craftable_piece(police_box_fuse_2, "j_fuse_02");
	var_ab257b31 zm_craftables::add_craftable_piece(police_box_fuse_3, "j_fuse_03");
	var_ab257b31.triggerThink = &police_box_craftable;
	var_ab257b31.no_challenge_stat = 1;
	level flag::init("fuse_01" + "_found");
	level flag::init("fuse_02" + "_found");
	level flag::init("fuse_03" + "_found");
	level flag::init("police_box_fuse_place");
	zm_craftables::include_zombie_craftable(var_ab257b31);
	craftable_name = "idgun";
	idgun_part_heart = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_heart", 32, 64, 0, undefined, &onpickup_idgun_piece, undefined, undefined, undefined, undefined, undefined, "idgun" + "_" + "part_heart", 1, undefined, undefined, &"ZM_ZOD_IDGUN_PART_HEART", 2);
	idgun_part_skeleton = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_skeleton", 32, 64, 0, undefined, &onpickup_idgun_piece, undefined, undefined, undefined, undefined, undefined, "idgun" + "_" + "part_skeleton", 1, undefined, undefined, &"ZM_ZOD_IDGUN_PART_SKELETON", 2);
	idgun_part_xenomatter = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_xenomatter", 32, 64, 0, undefined, &onpickup_idgun_piece, undefined, undefined, undefined, undefined, undefined, "idgun" + "_" + "part_xenomatter", 1, undefined, undefined, &"ZM_ZOD_IDGUN_PART_XENOMATTER", 2);
	idgun_part_heart.client_field_state = undefined;
	idgun_part_skeleton.client_field_state = undefined;
	idgun_part_xenomatter.client_field_state = undefined;
	idgun = spawnstruct();
	idgun.name = craftable_name;
	idgun zm_craftables::add_craftable_piece(idgun_part_heart);
	idgun zm_craftables::add_craftable_piece(idgun_part_skeleton);
	idgun zm_craftables::add_craftable_piece(idgun_part_xenomatter);
	idgun.onBuyWeapon = &on_buy_weapon_idgun;
	idgun.triggerThink = &idgun_craftable;
	zm_craftables::include_zombie_craftable(idgun);
	level flag::init("part_heart" + "_found");
	level flag::init("part_skeleton" + "_found");
	level flag::init("part_xenomatter" + "_found");
	craftable_name = "second_idgun";
	second_idgun_part_heart = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_heart", 32, 64, 0, undefined, &onpickup_idgun_piece, undefined, undefined, undefined, undefined, undefined, "second_idgun" + "_" + "part_heart", 1, undefined, undefined, &"ZM_ZOD_IDGUN_PART_HEART", 3);
	second_idgun_part_skeleton = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_skeleton", 32, 64, 0, undefined, &onpickup_idgun_piece, undefined, undefined, undefined, undefined, undefined, "second_idgun" + "_" + "part_skeleton", 1, undefined, undefined, &"ZM_ZOD_IDGUN_PART_SKELETON", 3);
	second_idgun_part_xenomatter = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_xenomatter", 32, 64, 0, undefined, &onpickup_idgun_piece, undefined, undefined, undefined, undefined, undefined, "second_idgun" + "_" + "part_xenomatter", 1, undefined, undefined, &"ZM_ZOD_IDGUN_PART_XENOMATTER", 3);
	second_idgun_part_heart.client_field_state = undefined;
	second_idgun_part_skeleton.client_field_state = undefined;
	second_idgun_part_xenomatter.client_field_state = undefined;
	var_4220199f = spawnstruct();
	var_4220199f.name = craftable_name;
	var_4220199f zm_craftables::add_craftable_piece(second_idgun_part_heart);
	var_4220199f zm_craftables::add_craftable_piece(second_idgun_part_skeleton);
	var_4220199f zm_craftables::add_craftable_piece(second_idgun_part_xenomatter);
	var_4220199f.triggerThink = &second_idgun_craftable;
	zm_craftables::include_zombie_craftable(var_4220199f);
	level flag::init("part_heart" + "_found");
	level flag::init("part_skeleton" + "_found");
	level flag::init("part_xenomatter" + "_found");
	craftable_name = "ritual_boxer";
	ritual_boxer_memento = zm_craftables::generate_zombie_craftable_piece(craftable_name, "memento_boxer", 32, 64, 0, undefined, &onpickup_ritual_piece, undefined, &oncrafted_ritual_piece, undefined, undefined, undefined, 1, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_BOXER", 0);
	if(shared_quest_pieces)
	{
		ritual_boxer_memento.is_shared = 1;
		ritual_boxer_memento.client_field_state = undefined;
	}
	var_364b172f = spawnstruct();
	var_364b172f.name = craftable_name;
	var_364b172f zm_craftables::add_craftable_piece(ritual_boxer_memento);
	var_364b172f.triggerThink = &ritual_boxer_craftable;
	var_364b172f.no_challenge_stat = 1;
	zm_craftables::include_zombie_craftable(var_364b172f);
	level flag::init("memento_boxer" + "_found");
	craftable_name = "ritual_detective";
	ritual_detective_memento = zm_craftables::generate_zombie_craftable_piece(craftable_name, "memento_detective", 32, 64, 0, undefined, &onpickup_ritual_piece, undefined, &oncrafted_ritual_piece, undefined, undefined, undefined, 2, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_DETECTIVE", 0);
	if(shared_quest_pieces)
	{
		ritual_detective_memento.is_shared = 1;
		ritual_detective_memento.client_field_state = undefined;
	}
	var_75566ac0 = spawnstruct();
	var_75566ac0.name = craftable_name;
	var_75566ac0 zm_craftables::add_craftable_piece(ritual_detective_memento);
	var_75566ac0.triggerThink = &ritual_detective_craftable;
	var_75566ac0.no_challenge_stat = 1;
	zm_craftables::include_zombie_craftable(var_75566ac0);
	level flag::init("memento_detective" + "_found");
	craftable_name = "ritual_femme";
	ritual_femme_memento = zm_craftables::generate_zombie_craftable_piece(craftable_name, "memento_femme", 32, 64, 0, undefined, &onpickup_ritual_piece, undefined, &oncrafted_ritual_piece, undefined, undefined, undefined, 3, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_FEMME", 0);
	if(shared_quest_pieces)
	{
		ritual_femme_memento.is_shared = 1;
		ritual_femme_memento.client_field_state = undefined;
	}
	var_d9c7dc8f = spawnstruct();
	var_d9c7dc8f.name = craftable_name;
	var_d9c7dc8f zm_craftables::add_craftable_piece(ritual_femme_memento);
	var_d9c7dc8f.triggerThink = &ritual_femme_craftable;
	var_d9c7dc8f.no_challenge_stat = 1;
	zm_craftables::include_zombie_craftable(var_d9c7dc8f);
	level flag::init("memento_femme" + "_found");
	craftable_name = "ritual_magician";
	ritual_magician_memento = zm_craftables::generate_zombie_craftable_piece(craftable_name, "memento_magician", 32, 64, 0, undefined, &onpickup_ritual_piece, undefined, &oncrafted_ritual_piece, undefined, undefined, undefined, 4, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_MAGICIAN", 0);
	if(shared_quest_pieces)
	{
		ritual_magician_memento.is_shared = 1;
		ritual_magician_memento.client_field_state = undefined;
	}
	var_3d961ca4 = spawnstruct();
	var_3d961ca4.name = craftable_name;
	var_3d961ca4 zm_craftables::add_craftable_piece(ritual_magician_memento);
	var_3d961ca4.triggerThink = &ritual_magician_craftable;
	var_3d961ca4.no_challenge_stat = 1;
	zm_craftables::include_zombie_craftable(var_3d961ca4);
	level flag::init("memento_magician" + "_found");
	craftable_name = "ritual_pap";
	var_74e95d7d = zm_craftables::generate_zombie_craftable_piece(craftable_name, "relic_boxer", 32, 64, 0, undefined, &onpickup_ritual_piece, undefined, &oncrafted_ritual_piece, undefined, undefined, undefined, 1, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_RELIC", 1);
	var_b31fe12 = zm_craftables::generate_zombie_craftable_piece(craftable_name, "relic_detective", 32, 64, 0, undefined, &onpickup_ritual_piece, undefined, &oncrafted_ritual_piece, undefined, undefined, undefined, 2, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_RELIC", 1);
	var_fc4796bd = zm_craftables::generate_zombie_craftable_piece(craftable_name, "relic_femme", 32, 64, 0, undefined, &onpickup_ritual_piece, undefined, &oncrafted_ritual_piece, undefined, undefined, undefined, 3, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_RELIC", 1);
	var_5c02f4ae = zm_craftables::generate_zombie_craftable_piece(craftable_name, "relic_magician", 32, 64, 0, undefined, &onpickup_ritual_piece, undefined, &oncrafted_ritual_piece, undefined, undefined, undefined, 4, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_RELIC", 1);
	if(shared_quest_pieces)
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
	var_18d1ed5a.triggerThink = &ritual_pap_craftable;
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
	level.custom_craftable_validation = &zod_player_can_craft;
	register_clientfields();
	zm_craftables::add_zombie_craftable("police_box", &"ZM_ZOD_POLICE_BOX_PLACE_FUSE", &"ZM_ZOD_POLICE_BOX_PLACE_FUSE", &"ZM_ZOD_POLICE_BOX_POWER_ON", &onfullycrafted_police_box);
	zm_craftables::add_zombie_craftable("idgun", &"ZM_ZOD_CRAFT_IDGUN", "", &"ZM_ZOD_PICKUP_IDGUN", &onfullycrafted_idgun, 1);
	zm_craftables::make_zombie_craftable_open("idgun", "", VectorScale((0, -1, 0), 90), (0, 0, 0));
	zm_craftables::add_zombie_craftable("second_idgun", &"ZM_ZOD_CRAFT_IDGUN", "", &"ZM_ZOD_PICKUP_IDGUN", &onfullycrafted_second_idgun, 1);
	zm_craftables::make_zombie_craftable_open("second_idgun", "", VectorScale((0, -1, 0), 90), (0, 0, 0));
	zm_craftables::add_zombie_craftable("ritual_boxer", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_BOXER", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_BOXER", &"ZM_ZOD_QUEST_RITUAL_INITIATE", &onfullycrafted_ritual);
	zm_craftables::add_zombie_craftable("ritual_detective", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_DETECTIVE", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_DETECTIVE", &"ZM_ZOD_QUEST_RITUAL_INITIATE", &onfullycrafted_ritual);
	zm_craftables::add_zombie_craftable("ritual_femme", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_FEMME", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_FEMME", &"ZM_ZOD_QUEST_RITUAL_INITIATE", &onfullycrafted_ritual);
	zm_craftables::add_zombie_craftable("ritual_magician", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_MAGICIAN", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_MAGICIAN", &"ZM_ZOD_QUEST_RITUAL_INITIATE", &onfullycrafted_ritual);
	zm_craftables::add_zombie_craftable("ritual_pap", &"ZM_ZOD_QUEST_RITUAL_PLACE_RELIC", &"ZM_ZOD_QUEST_RITUAL_PLACE_RELIC", &"ZM_ZOD_QUEST_RITUAL_INITIATE", &onfullycrafted_ritual);
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
	shared_bits = 1;
	RegisterClientField("world", "police_box" + "_" + "fuse_01", 1, shared_bits, "int", undefined, 0);
	RegisterClientField("world", "police_box" + "_" + "fuse_02", 1, shared_bits, "int", undefined, 0);
	RegisterClientField("world", "police_box" + "_" + "fuse_03", 1, shared_bits, "int", undefined, 0);
	RegisterClientField("world", "idgun" + "_" + "part_heart", 1, shared_bits, "int", undefined, 0);
	RegisterClientField("world", "idgun" + "_" + "part_skeleton", 1, shared_bits, "int", undefined, 0);
	RegisterClientField("world", "idgun" + "_" + "part_xenomatter", 1, shared_bits, "int", undefined, 0);
	RegisterClientField("world", "second_idgun" + "_" + "part_heart", 1, shared_bits, "int", undefined, 0);
	RegisterClientField("world", "second_idgun" + "_" + "part_skeleton", 1, shared_bits, "int", undefined, 0);
	RegisterClientField("world", "second_idgun" + "_" + "part_xenomatter", 1, shared_bits, "int", undefined, 0);
	foreach(character_name in level.zod_character_names)
	{
		RegisterClientField("world", "holder_of_" + character_name, 1, 3, "int", undefined, 0);
	}
	foreach(character_name in level.zod_character_names)
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
	var_c0262163 = level clientfield::get("quest_state_" + get_character_name_from_value(self.pieceName));
	if(is_piece_a_memento(self.pieceName) && var_c0262163 < 3)
	{
		level clientfield::set("quest_state_" + get_character_name_from_value(self.pieceName), 0);
		self.model clientfield::set("set_fade_material", 1);
		self.model clientfield::set("item_glow_fx", 3);
		level clientfield::set("holder_of_" + get_character_name_from_value(self.pieceName), 0);
	}
	else if(is_piece_a_relic(self.pieceName) && !level flag::get("ritual_pap_complete"))
	{
		level clientfield::set("quest_state_" + get_character_name_from_value(self.pieceName), 3);
		self.model SetVisibleToAll();
		self.model clientfield::set("item_glow_fx", 2);
		level clientfield::set("holder_of_" + get_character_name_from_value(self.pieceName), 0);
	}
}

/*
	Name: onpickup_police_box_fuse
	Namespace: zm_zod_craftables
	Checksum: 0xAC1B939B
	Offset: 0x2BD0
	Size: 0x111
	Parameters: 1
	Flags: None
*/
function onpickup_police_box_fuse(player)
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
	e_police_box = GetEnt("police_box", "targetname");
	if(isdefined(e_police_box))
	{
		e_police_box playsound("zmb_zod_fuse_place");
	}
	foreach(e_player in level.players)
	{
		e_player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.player_crafted_fusebox", "zmInventory.widget_fuses", 0);
		e_player thread namespace_8e578893::show_infotext_for_duration("ZM_ZOD_UI_FUSE_PLACED", 3.5);
	}
}

/*
	Name: ondrop_ritual_piece
	Namespace: zm_zod_craftables
	Checksum: 0x50AE9A8A
	Offset: 0x2E18
	Size: 0x1FB
	Parameters: 1
	Flags: None
*/
function ondrop_ritual_piece(player)
{
	/#
		println("Dev Block strings are not supported");
	#/
	level notify("dropped_" + self.pieceName);
	self droponmover(player);
	self.piece_owner = undefined;
	if(is_piece_a_memento(self.pieceName))
	{
		level.mementos_picked_up--;
		level clientfield::set("quest_state_" + get_character_name_from_value(self.pieceName), 0);
		self.model clientfield::set("set_fade_material", 1);
		self.model clientfield::set("item_glow_fx", 3);
	}
	else if(is_piece_a_relic(self.pieceName))
	{
		level.relics_picked_up--;
		level clientfield::set("quest_state_" + get_character_name_from_value(self.pieceName), 3);
		self.model clientfield::set("item_glow_fx", 2);
	}
	self.model.origin = player.origin;
	self.model SetVisibleToAll();
	level clientfield::set("holder_of_" + get_character_name_from_value(self.pieceName), 0);
}

/*
	Name: onpickup_ritual_piece
	Namespace: zm_zod_craftables
	Checksum: 0xF138CF8C
	Offset: 0x3020
	Size: 0x473
	Parameters: 1
	Flags: None
*/
function onpickup_ritual_piece(player)
{
	/#
		println("Dev Block strings are not supported");
	#/
	if(!isdefined(level.mementos_picked_up))
	{
		level.mementos_picked_up = 0;
		level.relics_picked_up = 0;
		level.sndritualmementos = 1;
	}
	if(!(isdefined(self.ever_picked) && self.ever_picked))
	{
		self.ever_picked = 1;
		self.start_origin = self.model.origin;
		self.start_angles = self.model.angles;
	}
	self pickupfrommover();
	self.piece_owner = player;
	level flag::set(self.pieceName + "_found");
	if(is_piece_a_memento(self.pieceName))
	{
		level.mementos_picked_up++;
		level clientfield::set("quest_state_" + get_character_name_from_value(self.pieceName), 1);
		player thread namespace_b8707f8e::function_32c9e1d9(self.pieceName);
	}
	else if(is_piece_a_relic(self.pieceName))
	{
		level.relics_picked_up++;
		level clientfield::set("quest_state_" + get_character_name_from_value(self.pieceName), 4);
		str_name = get_character_name_from_value(self.pieceName);
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
	level clientfield::set("holder_of_" + get_character_name_from_value(self.pieceName), var_e85b4e8);
	if(level.sndritualmementos == level.mementos_picked_up)
	{
		level thread zm_audio::sndMusicSystem_PlayState("piece_" + level.sndritualmementos);
		level.sndritualmementos++;
	}
	player thread function_9708cb71(self.pieceName);
	player thread zm_craftables::player_show_craftable_parts_ui(undefined, "zmInventory.widget_quest_items", 0);
	player thread namespace_8e578893::show_infotext_for_duration(str_infotext, 3.5);
	self thread ondisconnect_common(player);
}

/*
	Name: onpickup_idgun_piece
	Namespace: zm_zod_craftables
	Checksum: 0xB8F441F2
	Offset: 0x34A0
	Size: 0x179
	Parameters: 1
	Flags: None
*/
function onpickup_idgun_piece(player)
{
	level flag::set(self.pieceName + "_found");
	level notify("idgun_part_found");
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
	Name: onfullycrafted_police_box
	Namespace: zm_zod_craftables
	Checksum: 0xC8D7D462
	Offset: 0x3760
	Size: 0xED
	Parameters: 1
	Flags: None
*/
function onfullycrafted_police_box(e_player)
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
	Name: oncrafted_ritual_piece
	Namespace: zm_zod_craftables
	Checksum: 0x7FC7A923
	Offset: 0x3858
	Size: 0x13B
	Parameters: 1
	Flags: None
*/
function oncrafted_ritual_piece(player)
{
	if(is_piece_a_memento(self.pieceName))
	{
		level clientfield::set("quest_state_" + get_character_name_from_value(self.pieceName), 2);
		player namespace_b8707f8e::function_c41d3e2e(self.pieceName);
	}
	else
	{
		level clientfield::set("quest_state_" + get_character_name_from_value(self.pieceName), 5);
		quest_ritual_relic_placed = GetEnt("quest_ritual_relic_placed_" + get_character_name_from_value(self.pieceName), "targetname");
		quest_ritual_relic_placed show();
	}
	level clientfield::set("holder_of_" + get_character_name_from_value(self.pieceName), 0);
}

/*
	Name: onfullycrafted_ritual
	Namespace: zm_zod_craftables
	Checksum: 0x8B0F08D9
	Offset: 0x39A0
	Size: 0xDF
	Parameters: 1
	Flags: None
*/
function onfullycrafted_ritual(player)
{
	if(self.equipname != "ritual_pap")
	{
		str_character_name = get_character_name_from_value(self.equipname);
		onfullycrafted_ritual_internal(str_character_name);
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
	Name: onfullycrafted_ritual_internal
	Namespace: zm_zod_craftables
	Checksum: 0xE92FB643
	Offset: 0x3A88
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function onfullycrafted_ritual_internal(name)
{
	level flag::set("ritual_" + name + "_ready");
	level clientfield::set("ritual_state_" + name, 1);
	level clientfield::set("quest_state_" + name, 2);
}

/*
	Name: onfullycrafted_idgun
	Namespace: zm_zod_craftables
	Checksum: 0xBF0435A4
	Offset: 0x3B18
	Size: 0x1D7
	Parameters: 1
	Flags: None
*/
function onfullycrafted_idgun(player)
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
		self.n_gun_index = level.idgun[0].n_gun_index;
		self.weaponName = GetWeapon(level.idgun[self.n_gun_index].str_wpnname);
	}
	return 1;
}

/*
	Name: on_buy_weapon_idgun
	Namespace: zm_zod_craftables
	Checksum: 0xE7BD476A
	Offset: 0x3CF8
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function on_buy_weapon_idgun(player)
{
	level.idgun[self.stub.n_gun_index].owner = player;
	level clientfield::set("add_idgun_to_box", level.idgun[self.stub.n_gun_index].n_gun_id);
	level.zombie_weapons[self.stub.weaponName].is_in_box = 1;
	player namespace_b8707f8e::function_aca1bc0c(self.stub.n_gun_index);
}

/*
	Name: onfullycrafted_second_idgun
	Namespace: zm_zod_craftables
	Checksum: 0xA2E588AF
	Offset: 0x3DC8
	Size: 0x12F
	Parameters: 1
	Flags: None
*/
function onfullycrafted_second_idgun(player)
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
	function_a0e4fb00(self.origin, self.origin, level.idgun[1].n_gun_index);
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
function function_a0e4fb00(v_origin, v_angles, n_gun_index)
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
	unitrigger_stub.n_gun_index = n_gun_index;
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
	n_gun_index = self.stub.n_gun_index;
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
	level.idgun[trig_stub.n_gun_index].owner = player;
	trig_stub.var_193180cc SetInvisibleToAll();
	wpn_idgun = GetWeapon(level.idgun[trig_stub.n_gun_index].str_wpnname);
	player zm_weapons::weapon_give(wpn_idgun, 0, 0);
	player SwitchToWeapon(wpn_idgun);
	player namespace_b8707f8e::function_aca1bc0c(trig_stub.n_gun_index);
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
	Name: zod_player_can_craft
	Namespace: zm_zod_craftables
	Checksum: 0x6A596135
	Offset: 0x43C8
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function zod_player_can_craft(player)
{
	if(isdefined(player.beastmode) && player.beastmode)
	{
		return 0;
	}
	return 1;
}

/*
	Name: police_box_craftable
	Namespace: zm_zod_craftables
	Checksum: 0xED6D56EC
	Offset: 0x4410
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function police_box_craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("police_box_usetrigger", "police_box", "police_box", "", 1, 0);
}

/*
	Name: ritual_boxer_craftable
	Namespace: zm_zod_craftables
	Checksum: 0xD6929ED7
	Offset: 0x4468
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function ritual_boxer_craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("quest_ritual_usetrigger_boxer", "ritual_boxer", "ritual_boxer", "", 1, 0);
}

/*
	Name: ritual_detective_craftable
	Namespace: zm_zod_craftables
	Checksum: 0x23A1DFEB
	Offset: 0x44C0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function ritual_detective_craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("quest_ritual_usetrigger_detective", "ritual_detective", "ritual_detective", "", 1, 0);
}

/*
	Name: ritual_femme_craftable
	Namespace: zm_zod_craftables
	Checksum: 0xFECAD039
	Offset: 0x4518
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function ritual_femme_craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("quest_ritual_usetrigger_femme", "ritual_femme", "ritual_femme", "", 1, 0);
}

/*
	Name: ritual_magician_craftable
	Namespace: zm_zod_craftables
	Checksum: 0x8B32E041
	Offset: 0x4570
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function ritual_magician_craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("quest_ritual_usetrigger_magician", "ritual_magician", "ritual_magician", "", 1, 0);
}

/*
	Name: ritual_pap_craftable
	Namespace: zm_zod_craftables
	Checksum: 0x2EBED938
	Offset: 0x45C8
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function ritual_pap_craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("quest_ritual_usetrigger_pap", "ritual_pap", "ritual_pap", "", 1, 0);
}

/*
	Name: idgun_craftable
	Namespace: zm_zod_craftables
	Checksum: 0xDCEB045
	Offset: 0x4620
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function idgun_craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("idgun_zm_craftable_trigger", "idgun", "idgun", &"ZM_ZOD_PICKUP_IDGUN", 1, 2);
}

/*
	Name: second_idgun_craftable
	Namespace: zm_zod_craftables
	Checksum: 0x38ABF079
	Offset: 0x4678
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function second_idgun_craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("second_idgun_zm_craftable_trigger", "second_idgun", "second_idgun", "", 1, 0);
}

/*
	Name: get_character_name_from_value
	Namespace: zm_zod_craftables
	Checksum: 0x397D315D
	Offset: 0x46D0
	Size: 0xD9
	Parameters: 1
	Flags: None
*/
function get_character_name_from_value(name)
{
	a_character_names = Array("boxer", "detective", "femme", "magician");
	foreach(character_name in a_character_names)
	{
		if(IsSubStr(name, character_name))
		{
			return character_name;
		}
	}
}

/*
	Name: is_piece_a_memento
	Namespace: zm_zod_craftables
	Checksum: 0xB7194709
	Offset: 0x47B8
	Size: 0x6D
	Parameters: 1
	Flags: None
*/
function is_piece_a_memento(name)
{
	a_memento_names = Array("memento_boxer", "memento_detective", "memento_femme", "memento_magician");
	if(IsInArray(a_memento_names, name))
	{
		return 1;
	}
	return 0;
}

/*
	Name: is_piece_a_relic
	Namespace: zm_zod_craftables
	Checksum: 0x2199FBA1
	Offset: 0x4830
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function is_piece_a_relic(name)
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

