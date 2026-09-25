#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_ai_quadrotor;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_tomb_amb;
#using scripts\zm\zm_tomb_main_quest;
#using scripts\zm\zm_tomb_utility;
#using scripts\zm\zm_tomb_vo;

#namespace zm_tomb_craftables;

/*
	Name: randomize_craftable_spawns
	Namespace: zm_tomb_craftables
	Checksum: 0x6863187A
	Offset: 0x1308
	Size: 0x1A5
	Parameters: 0
	Flags: None
*/
function randomize_craftable_spawns()
{
	a_randomized_craftables = Array("gramophone_vinyl_ice", "gramophone_vinyl_air", "gramophone_vinyl_elec", "gramophone_vinyl_fire", "gramophone_vinyl_master", "gramophone_vinyl_player");
	foreach(str_craftable in a_randomized_craftables)
	{
		s_original_pos = struct::get(str_craftable, "targetname");
		a_alt_locations = struct::get_array(str_craftable + "_alt", "targetname");
		n_loc_index = randomIntRange(0, a_alt_locations.size + 1);
		if(n_loc_index == a_alt_locations.size)
		{
			continue;
			continue;
		}
		s_original_pos.origin = a_alt_locations[n_loc_index].origin;
		s_original_pos.angles = a_alt_locations[n_loc_index].angles;
	}
}

/*
	Name: init_craftables
	Namespace: zm_tomb_craftables
	Checksum: 0x471F27CE
	Offset: 0x14B8
	Size: 0x49F
	Parameters: 0
	Flags: None
*/
function init_craftables()
{
	level flag::init("quadrotor_cooling_down");
	level.craftable_piece_count = 4;
	level flag::init("any_crystal_picked_up");
	level flag::init("staff_air_zm_enabled");
	level flag::init("staff_fire_zm_enabled");
	level flag::init("staff_lightning_zm_enabled");
	level flag::init("staff_water_zm_enabled");
	level flag::init("staff_air_picked_up");
	level flag::init("staff_fire_picked_up");
	level flag::init("staff_lightning_picked_up");
	level flag::init("staff_water_picked_up");
	zm_craftables::add_zombie_craftable("equip_dieseldrone", &"ZM_TOMB_CRQ", &"ZM_TOMB_CRQ", &"ZM_TOMB_TQ", &onfullycrafted_quadrotor, 1);
	zm_craftables::add_zombie_craftable_vox_category("equip_dieseldrone", "build_dd");
	zm_craftables::make_zombie_craftable_open("equip_dieseldrone", "veh_t7_dlc_zm_quadrotor", (0, 0, 0), (0, -4, 10));
	zm_craftables::add_zombie_craftable("elemental_staff_fire", &"ZM_TOMB_CRF", &"ZM_TOMB_INS", &"ZM_TOMB_BOF", &staff_fire_fullycrafted, 1);
	zm_craftables::add_zombie_craftable_vox_category("elemental_staff_fire", "fire_staff");
	zm_craftables::add_zombie_craftable("elemental_staff_air", &"ZM_TOMB_CRA", &"ZM_TOMB_INS", &"ZM_TOMB_BOA", &staff_air_fullycrafted, 1);
	zm_craftables::add_zombie_craftable_vox_category("elemental_staff_air", "air_staff");
	zm_craftables::add_zombie_craftable("elemental_staff_lightning", &"ZM_TOMB_CRL", &"ZM_TOMB_INS", &"ZM_TOMB_BOL", &staff_lightning_fullycrafted, 1);
	zm_craftables::add_zombie_craftable_vox_category("elemental_staff_lightning", "light_staff");
	zm_craftables::add_zombie_craftable("elemental_staff_water", &"ZM_TOMB_CRW", &"ZM_TOMB_INS", &"ZM_TOMB_BOW", &staff_water_fullycrafted, 1);
	zm_craftables::add_zombie_craftable_vox_category("elemental_staff_water", "ice_staff");
	zm_craftables::add_zombie_craftable("gramophone", &"ZM_TOMB_CRAFT_GRAMOPHONE", &"ZM_TOMB_CRAFT_GRAMOPHONE", &"ZM_TOMB_BOUGHT_GRAMOPHONE", undefined, 0);
	zm_craftables::add_zombie_craftable_vox_category("gramophone", "gramophone");
	level.zombie_craftable_persistent_weapon = &tomb_check_crafted_weapon_persistence;
	level.custom_craftable_validation = &tomb_custom_craftable_validation;
	level.zombie_custom_equipment_setup = &setup_quadrotor_purchase;
	level thread hide_staff_model();
	level.quadrotor_status = spawnstruct();
	level.quadrotor_status.crafted = 0;
	level.quadrotor_status.picked_up = 0;
	level.num_staffpieces_picked_up = [];
	level.var_b79a2c38 = [];
	level.n_staffs_crafted = 0;
}

/*
	Name: add_craftable_cheat
	Namespace: zm_tomb_craftables
	Checksum: 0xC1681EEF
	Offset: 0x1960
	Size: 0x391
	Parameters: 1
	Flags: None
*/
function add_craftable_cheat(craftable)
{
	/#
		if(!isdefined(level.cheat_craftables))
		{
			level.cheat_craftables = [];
		}
		foreach(s_piece in craftable.a_piecestubs)
		{
			id_string = undefined;
			client_field_val = undefined;
			if(isdefined(s_piece.client_field_id))
			{
				id_string = s_piece.client_field_id;
				client_field_val = id_string;
			}
			else if(isdefined(s_piece.client_field_state))
			{
				id_string = "Dev Block strings are not supported";
				client_field_val = s_piece.client_field_state;
			}
			else
			{
				continue;
			}
			tokens = StrTok(id_string, "Dev Block strings are not supported");
			display_string = "Dev Block strings are not supported";
			foreach(token in tokens)
			{
				if(token != "Dev Block strings are not supported" && token != "Dev Block strings are not supported" && token != "Dev Block strings are not supported")
				{
					display_string = display_string + "Dev Block strings are not supported" + token;
				}
			}
			level.cheat_craftables["Dev Block strings are not supported" + client_field_val] = s_piece;
			AddDebugCommand("Dev Block strings are not supported" + craftable.name + "Dev Block strings are not supported" + display_string + "Dev Block strings are not supported" + client_field_val + "Dev Block strings are not supported");
			s_piece.waste = "Dev Block strings are not supported";
		}
		wait(0.05);
		level flag::wait_till("Dev Block strings are not supported");
		wait(0.05);
		foreach(s_piece in craftable.a_piecestubs)
		{
			s_piece craftable_waittill_spawned();
			s_piece.pieceSpawn.model thread zm_tomb_utility::puzzle_debug_position("Dev Block strings are not supported", VectorScale((0, 1, 0), 255), undefined, "Dev Block strings are not supported");
		}
	#/
}

/*
	Name: autocraft_staffs
	Namespace: zm_tomb_craftables
	Checksum: 0x810FA213
	Offset: 0x1D00
	Size: 0x2C5
	Parameters: 0
	Flags: None
*/
function autocraft_staffs()
{
	SetDvar("autocraft_staffs", "off");
	/#
		AddDebugCommand("Dev Block strings are not supported");
	#/
	while(GetDvarString("autocraft_staffs") != "on")
	{
		util::wait_network_frame();
	}
	level flag::wait_till("start_zombie_round_logic");
	keys = getArrayKeys(level.cheat_craftables);
	a_players = GetPlayers();
	foreach(key in keys)
	{
		if(IsSubStr(key, "staff") || IsSubStr(key, "record"))
		{
			s_piece = level.cheat_craftables[key];
			if(isdefined(s_piece.pieceSpawn))
			{
				a_players[0] zm_craftables::player_take_piece(s_piece.pieceSpawn);
			}
		}
	}
	for(i = 1; i <= 4; i++)
	{
		level notify("player_teleported", a_players[0], i);
		util::wait_network_frame();
		piece_spawn = level.cheat_craftables["" + i].pieceSpawn;
		if(isdefined(piece_spawn))
		{
			if(isdefined(a_players[i - 1]))
			{
				a_players[i - 1] zm_craftables::player_take_piece(piece_spawn);
				util::wait_network_frame();
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: run_craftables_devgui
	Namespace: zm_tomb_craftables
	Checksum: 0x2DD7E159
	Offset: 0x1FD0
	Size: 0x10F
	Parameters: 0
	Flags: None
*/
function run_craftables_devgui()
{
	/#
		level thread autocraft_staffs();
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		while(1)
		{
			craftable_id = GetDvarString("Dev Block strings are not supported");
			if(craftable_id != "Dev Block strings are not supported")
			{
				piece_spawn = level.cheat_craftables[craftable_id].pieceSpawn;
				if(isdefined(piece_spawn))
				{
					players = GetPlayers();
					players[0] zm_craftables::player_take_piece(piece_spawn);
				}
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			wait(0.05);
		}
	#/
}

/*
	Name: include_craftables
	Namespace: zm_tomb_craftables
	Checksum: 0xC5597F56
	Offset: 0x20E8
	Size: 0x13AB
	Parameters: 0
	Flags: None
*/
function include_craftables()
{
	craftable_name = "equip_dieseldrone";
	quadrotor_body = zm_craftables::generate_zombie_craftable_piece(craftable_name, "body", 32, 64, 0, undefined, &onPickup_Common, &onDrop_Common, undefined, undefined, undefined, undefined, "piece_quadrotor_zm_body", 1, "build_dd", 0);
	quadrotor_brain = zm_craftables::generate_zombie_craftable_piece(craftable_name, "brain", 32, 64, 0, undefined, &onPickup_Common, &onDrop_Common, undefined, undefined, undefined, undefined, "piece_quadrotor_zm_brain", 1, "build_dd_brain", 0);
	quadrotor_engine = zm_craftables::generate_zombie_craftable_piece(craftable_name, "engine", 32, 64, 0, undefined, &onPickup_Common, &onDrop_Common, undefined, undefined, undefined, undefined, "piece_quadrotor_zm_engine", 1, "build_dd", 0);
	quadrotor_body thread watch_part_pickup("piece_quadrotor_zm_body", 1, "zmInventory.show_maxis_drone_parts_widget");
	quadrotor_brain thread watch_part_pickup("piece_quadrotor_zm_brain", 1, "zmInventory.show_maxis_drone_parts_widget");
	quadrotor_engine thread watch_part_pickup("piece_quadrotor_zm_engine", 1, "zmInventory.show_maxis_drone_parts_widget");
	quadrotor = spawnstruct();
	quadrotor.name = craftable_name;
	quadrotor zm_craftables::add_craftable_piece(quadrotor_body);
	quadrotor zm_craftables::add_craftable_piece(quadrotor_brain);
	quadrotor zm_craftables::add_craftable_piece(quadrotor_engine);
	quadrotor.triggerThink = &quadrotorcraftable;
	zm_craftables::include_zombie_craftable(quadrotor);
	level thread add_craftable_cheat(quadrotor);
	craftable_name = "gramophone";
	vinyl_pickup_player = vinyl_add_pickup(craftable_name, "vinyl_player", "p7_spl_gramophone", "piece_record_zm_player", undefined, "gramophone", "zmInventory.show_musical_parts_widget");
	vinyl_pickup_master = vinyl_add_pickup(craftable_name, "vinyl_master", "p7_zm_ori_record_vinyl_master", "piece_record_zm_vinyl_master", undefined, "record", "zmInventory.show_musical_parts_widget");
	vinyl_pickup_air = vinyl_add_pickup(craftable_name, "vinyl_air", "p7_zm_ori_record_vinyl_wind", "piece_record_zm_vinyl_air", "air_staff.quest_state", "record", "zmInventory.air_staff.visible");
	vinyl_pickup_ice = vinyl_add_pickup(craftable_name, "vinyl_ice", "p7_zm_ori_record_vinyl_ice", "piece_record_zm_vinyl_water", "water_staff.quest_state", "record", "zmInventory.water_staff.visible");
	vinyl_pickup_fire = vinyl_add_pickup(craftable_name, "vinyl_fire", "p7_zm_ori_record_vinyl_fire", "piece_record_zm_vinyl_fire", "fire_staff.quest_state", "record", "zmInventory.fire_staff.visible");
	vinyl_pickup_elec = vinyl_add_pickup(craftable_name, "vinyl_elec", "p7_zm_ori_record_vinyl_lightning", "piece_record_zm_vinyl_lightning", "lightning_staff.quest_state", "record", "zmInventory.lightning_staff.visible");
	vinyl_pickup_player.sam_line = "gramophone_found";
	vinyl_pickup_master.sam_line = "master_found";
	vinyl_pickup_air.sam_line = "first_record_found";
	vinyl_pickup_ice.sam_line = "first_record_found";
	vinyl_pickup_fire.sam_line = "first_record_found";
	vinyl_pickup_elec.sam_line = "first_record_found";
	level thread zm_tomb_vo::watch_one_shot_samantha_line("vox_sam_1st_record_found_0", "first_record_found");
	level thread zm_tomb_vo::watch_one_shot_samantha_line("vox_sam_gramophone_found_0", "gramophone_found");
	level thread zm_tomb_vo::watch_one_shot_samantha_line("vox_sam_master_found_0", "master_found");
	gramophone = spawnstruct();
	gramophone.name = craftable_name;
	gramophone zm_craftables::add_craftable_piece(vinyl_pickup_player);
	gramophone zm_craftables::add_craftable_piece(vinyl_pickup_master);
	gramophone zm_craftables::add_craftable_piece(vinyl_pickup_air);
	gramophone zm_craftables::add_craftable_piece(vinyl_pickup_ice);
	gramophone zm_craftables::add_craftable_piece(vinyl_pickup_fire);
	gramophone zm_craftables::add_craftable_piece(vinyl_pickup_elec);
	gramophone.triggerThink = &gramophonecraftable;
	zm_craftables::include_zombie_craftable(gramophone);
	level thread add_craftable_cheat(gramophone);
	craftable_name = "elemental_staff_air";
	staff_air_gem = zm_craftables::generate_zombie_craftable_piece(craftable_name, "gem", 48, 64, 0, undefined, &onpickup_aircrystal, &ondrop_aircrystal, undefined, undefined, undefined, undefined, 2, 0, "crystal", 1);
	staff_air_upper_staff = zm_craftables::generate_zombie_craftable_piece(craftable_name, "upper_staff", 32, 64, 0, undefined, &function_f35af043, &onDrop_Common, undefined, undefined, undefined, undefined, "air_staff.piece_zm_ustaff", 1, "staff_part");
	staff_air_middle_staff = zm_craftables::generate_zombie_craftable_piece(craftable_name, "middle_staff", 32, 64, 0, undefined, &function_f35af043, &onDrop_Common, undefined, undefined, undefined, undefined, "air_staff.piece_zm_mstaff", 1, "staff_part");
	staff_air_lower_staff = zm_craftables::generate_zombie_craftable_piece(craftable_name, "lower_staff", 32, 64, 0, undefined, &function_f35af043, &onDrop_Common, undefined, undefined, undefined, undefined, "air_staff.piece_zm_lstaff", 1, "staff_part");
	staff = spawnstruct();
	staff.name = craftable_name;
	staff zm_craftables::add_craftable_piece(staff_air_gem);
	staff zm_craftables::add_craftable_piece(staff_air_upper_staff);
	staff zm_craftables::add_craftable_piece(staff_air_middle_staff);
	staff zm_craftables::add_craftable_piece(staff_air_lower_staff);
	staff.triggerThink = &staffcraftable_air;
	staff.custom_craftablestub_update_prompt = &tomb_staff_update_prompt;
	zm_craftables::include_zombie_craftable(staff);
	level thread add_craftable_cheat(staff);
	count_staff_piece_pickup(Array(staff_air_upper_staff, staff_air_middle_staff, staff_air_lower_staff));
	craftable_name = "elemental_staff_fire";
	staff_fire_gem = zm_craftables::generate_zombie_craftable_piece(craftable_name, "gem", 48, 64, 0, undefined, &onpickup_firecrystal, &ondrop_firecrystal, undefined, undefined, undefined, undefined, 1, 0, "crystal", 1);
	staff_fire_upper_staff = zm_craftables::generate_zombie_craftable_piece(craftable_name, "upper_staff", 32, 64, 0, undefined, &function_4d932a71, &onDrop_Common, undefined, undefined, undefined, undefined, "fire_staff.piece_zm_ustaff", 1, "staff_part");
	staff_fire_middle_staff = zm_craftables::generate_zombie_craftable_piece(craftable_name, "middle_staff", 32, 64, 0, undefined, &function_4d932a71, &onDrop_Common, undefined, undefined, undefined, undefined, "fire_staff.piece_zm_mstaff", 1, "staff_part");
	staff_fire_lower_staff = zm_craftables::generate_zombie_craftable_piece(craftable_name, "lower_staff", 64, 128, 0, undefined, &function_4d932a71, &onDrop_Common, undefined, undefined, undefined, undefined, "fire_staff.piece_zm_lstaff", 1, "staff_part");
	level thread zm_tomb_main_quest::staff_mechz_drop_pieces(staff_fire_lower_staff);
	level thread zm_tomb_main_quest::staff_biplane_drop_pieces(Array(staff_fire_middle_staff));
	level thread zm_tomb_main_quest::staff_unlock_with_zone_capture(staff_fire_upper_staff);
	staff = spawnstruct();
	staff.name = craftable_name;
	staff zm_craftables::add_craftable_piece(staff_fire_gem);
	staff zm_craftables::add_craftable_piece(staff_fire_upper_staff);
	staff zm_craftables::add_craftable_piece(staff_fire_middle_staff);
	staff zm_craftables::add_craftable_piece(staff_fire_lower_staff);
	staff.triggerThink = &staffcraftable_fire;
	staff.custom_craftablestub_update_prompt = &tomb_staff_update_prompt;
	zm_craftables::include_zombie_craftable(staff);
	level thread add_craftable_cheat(staff);
	count_staff_piece_pickup(Array(staff_fire_upper_staff, staff_fire_middle_staff, staff_fire_lower_staff));
	craftable_name = "elemental_staff_lightning";
	staff_lightning_gem = zm_craftables::generate_zombie_craftable_piece(craftable_name, "gem", 48, 64, 0, undefined, &onpickup_lightningcrystal, &ondrop_lightningcrystal, undefined, undefined, undefined, undefined, 3, 0, "crystal", 1);
	staff_lightning_upper_staff = zm_craftables::generate_zombie_craftable_piece(craftable_name, "upper_staff", 32, 64, 0, undefined, &function_47c3d969, &onDrop_Common, undefined, undefined, undefined, undefined, "lightning_staff.piece_zm_ustaff", 1, "staff_part");
	staff_lightning_middle_staff = zm_craftables::generate_zombie_craftable_piece(craftable_name, "middle_staff", 32, 64, 0, undefined, &function_47c3d969, &onDrop_Common, undefined, undefined, undefined, undefined, "lightning_staff.piece_zm_mstaff", 1, "staff_part");
	staff_lightning_lower_staff = zm_craftables::generate_zombie_craftable_piece(craftable_name, "lower_staff", 32, 64, 0, undefined, &function_47c3d969, &onDrop_Common, undefined, undefined, undefined, undefined, "lightning_staff.piece_zm_lstaff", 1, "staff_part");
	staff = spawnstruct();
	staff.name = craftable_name;
	staff zm_craftables::add_craftable_piece(staff_lightning_gem);
	staff zm_craftables::add_craftable_piece(staff_lightning_upper_staff);
	staff zm_craftables::add_craftable_piece(staff_lightning_middle_staff);
	staff zm_craftables::add_craftable_piece(staff_lightning_lower_staff);
	staff.triggerThink = &staffcraftable_lightning;
	staff.custom_craftablestub_update_prompt = &tomb_staff_update_prompt;
	zm_craftables::include_zombie_craftable(staff);
	level thread add_craftable_cheat(staff);
	count_staff_piece_pickup(Array(staff_lightning_upper_staff, staff_lightning_middle_staff, staff_lightning_lower_staff));
	craftable_name = "elemental_staff_water";
	staff_water_gem = zm_craftables::generate_zombie_craftable_piece(craftable_name, "gem", 48, 64, 0, undefined, &onpickup_watercrystal, &ondrop_watercrystal, undefined, undefined, undefined, undefined, 4, 0, "crystal", 1);
	staff_water_upper_staff = zm_craftables::generate_zombie_craftable_piece(craftable_name, "upper_staff", 32, 64, 0, undefined, &function_6c091d36, &onDrop_Common, undefined, undefined, undefined, undefined, "water_staff.piece_zm_ustaff", 1, "staff_part");
	staff_water_middle_staff = zm_craftables::generate_zombie_craftable_piece(craftable_name, "middle_staff", 32, 64, 0, undefined, &function_6c091d36, &onDrop_Common, undefined, undefined, undefined, undefined, "water_staff.piece_zm_mstaff", 1, "staff_part");
	staff_water_lower_staff = zm_craftables::generate_zombie_craftable_piece(craftable_name, "lower_staff", 32, 64, 0, undefined, &function_6c091d36, &onDrop_Common, undefined, undefined, undefined, undefined, "water_staff.piece_zm_lstaff", 1, "staff_part");
	a_ice_staff_parts = Array(staff_water_lower_staff, staff_water_middle_staff, staff_water_upper_staff);
	level thread zm_tomb_main_quest::staff_ice_dig_pieces(a_ice_staff_parts);
	staff = spawnstruct();
	staff.name = craftable_name;
	staff zm_craftables::add_craftable_piece(staff_water_gem);
	staff zm_craftables::add_craftable_piece(staff_water_upper_staff);
	staff zm_craftables::add_craftable_piece(staff_water_middle_staff);
	staff zm_craftables::add_craftable_piece(staff_water_lower_staff);
	staff.triggerThink = &staffcraftable_water;
	staff.custom_craftablestub_update_prompt = &tomb_staff_update_prompt;
	zm_craftables::include_zombie_craftable(staff);
	level thread add_craftable_cheat(staff);
	count_staff_piece_pickup(Array(staff_water_upper_staff, staff_water_middle_staff, staff_water_lower_staff));
	staff_fire_gem thread watch_part_pickup("fire_staff.quest_state", 2);
	staff_air_gem thread watch_part_pickup("air_staff.quest_state", 2);
	staff_lightning_gem thread watch_part_pickup("lightning_staff.quest_state", 2);
	staff_water_gem thread watch_part_pickup("water_staff.quest_state", 2);
	staff_fire_gem thread zm_tomb_main_quest::staff_crystal_wait_for_teleport(1);
	staff_air_gem thread zm_tomb_main_quest::staff_crystal_wait_for_teleport(2);
	staff_lightning_gem thread zm_tomb_main_quest::staff_crystal_wait_for_teleport(3);
	staff_water_gem thread zm_tomb_main_quest::staff_crystal_wait_for_teleport(4);
	level thread craftable_add_glow_fx();
}

/*
	Name: register_clientfields
	Namespace: zm_tomb_craftables
	Checksum: 0x8A9261B9
	Offset: 0x34A0
	Size: 0x963
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	bits = 1;
	clientfield::register("world", "piece_quadrotor_zm_body", 21000, bits, "int");
	clientfield::register("world", "piece_quadrotor_zm_brain", 21000, bits, "int");
	clientfield::register("world", "piece_quadrotor_zm_engine", 21000, bits, "int");
	clientfield::register("world", "air_staff.piece_zm_gem", 21000, bits, "int");
	clientfield::register("world", "air_staff.piece_zm_ustaff", 21000, bits, "int");
	clientfield::register("world", "air_staff.piece_zm_mstaff", 21000, bits, "int");
	clientfield::register("world", "air_staff.piece_zm_lstaff", 21000, bits, "int");
	clientfield::register("clientuimodel", "zmInventory.air_staff.visible", 21000, bits, "int");
	clientfield::register("world", "fire_staff.piece_zm_gem", 21000, bits, "int");
	clientfield::register("world", "fire_staff.piece_zm_ustaff", 21000, bits, "int");
	clientfield::register("world", "fire_staff.piece_zm_mstaff", 21000, bits, "int");
	clientfield::register("world", "fire_staff.piece_zm_lstaff", 21000, bits, "int");
	clientfield::register("clientuimodel", "zmInventory.fire_staff.visible", 21000, bits, "int");
	clientfield::register("world", "lightning_staff.piece_zm_gem", 21000, bits, "int");
	clientfield::register("world", "lightning_staff.piece_zm_ustaff", 21000, bits, "int");
	clientfield::register("world", "lightning_staff.piece_zm_mstaff", 21000, bits, "int");
	clientfield::register("world", "lightning_staff.piece_zm_lstaff", 21000, bits, "int");
	clientfield::register("clientuimodel", "zmInventory.lightning_staff.visible", 21000, bits, "int");
	clientfield::register("world", "water_staff.piece_zm_gem", 21000, bits, "int");
	clientfield::register("world", "water_staff.piece_zm_ustaff", 21000, bits, "int");
	clientfield::register("world", "water_staff.piece_zm_mstaff", 21000, bits, "int");
	clientfield::register("world", "water_staff.piece_zm_lstaff", 21000, bits, "int");
	clientfield::register("clientuimodel", "zmInventory.water_staff.visible", 21000, bits, "int");
	clientfield::register("world", "piece_record_zm_player", 21000, bits, "int");
	clientfield::register("world", "piece_record_zm_vinyl_master", 21000, bits, "int");
	clientfield::register("world", "piece_record_zm_vinyl_air", 21000, bits, "int");
	clientfield::register("world", "piece_record_zm_vinyl_water", 21000, bits, "int");
	clientfield::register("world", "piece_record_zm_vinyl_fire", 21000, bits, "int");
	clientfield::register("world", "piece_record_zm_vinyl_lightning", 21000, bits, "int");
	clientfield::register("scriptmover", "element_glow_fx", 21000, 4, "int");
	clientfield::register("scriptmover", "bryce_cake", 21000, 2, "int");
	clientfield::register("scriptmover", "switch_spark", 21000, 1, "int");
	clientfield::register("scriptmover", "plane_fx", 21000, 1, "int");
	bits = GetMinBitCountForNum(5);
	clientfield::register("world", "air_staff.holder", 21000, bits, "int");
	clientfield::register("world", "fire_staff.holder", 21000, bits, "int");
	clientfield::register("world", "lightning_staff.holder", 21000, bits, "int");
	clientfield::register("world", "water_staff.holder", 21000, bits, "int");
	bits = GetMinBitCountForNum(5);
	clientfield::register("world", "fire_staff.quest_state", 21000, bits, "int");
	clientfield::register("world", "air_staff.quest_state", 21000, bits, "int");
	clientfield::register("world", "lightning_staff.quest_state", 21000, bits, "int");
	clientfield::register("world", "water_staff.quest_state", 21000, bits, "int");
	clientfield::register("toplayer", "sndMudSlow", 21000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.show_maxis_drone_parts_widget", 21000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.current_gem", 21000, GetMinBitCountForNum(5), "int");
	clientfield::register("clientuimodel", "zmInventory.show_musical_parts_widget", 21000, 1, "int");
	clientfield::register("clientuimodel", "hudItems.showDpadRight_Drone", 21000, 1, "int");
	clientfield::register("clientuimodel", "hudItems.showDpadLeft_Staff", 21000, 1, "int");
	clientfield::register("clientuimodel", "hudItems.dpadLeftAmmo", 21000, 2, "int");
}

/*
	Name: craftable_add_glow_fx
	Namespace: zm_tomb_craftables
	Checksum: 0x8F68EF57
	Offset: 0x3E10
	Size: 0x2FF
	Parameters: 0
	Flags: None
*/
function craftable_add_glow_fx()
{
	level flagsys::wait_till("load_main_complete");
	level flag::wait_till("start_zombie_round_logic");
	foreach(s_craftable in level.zombie_include_craftables)
	{
		if(!IsSubStr(s_craftable.name, "elemental_staff"))
		{
			break;
		}
		n_elem = 0;
		if(IsSubStr(s_craftable.name, "fire"))
		{
			n_elem = 1;
		}
		else if(IsSubStr(s_craftable.name, "air"))
		{
			n_elem = 2;
		}
		else if(IsSubStr(s_craftable.name, "lightning"))
		{
			n_elem = 3;
		}
		else if(IsSubStr(s_craftable.name, "water"))
		{
			n_elem = 4;
		}
		else
		{
			IPrintLnBold("Dev Block strings are not supported" + s_craftable.name);
			return;
		}
		/#
		#/
		foreach(s_piece in s_craftable.a_piecestubs)
		{
			if(s_piece.pieceName == "gem")
			{
				continue;
			}
			s_piece craftable_waittill_spawned();
			do_glow_now = n_elem == 3 || n_elem == 2;
			s_piece.pieceSpawn.model thread craftable_model_attach_glow(n_elem, do_glow_now);
		}
	}
}

/*
	Name: craftable_model_attach_glow
	Namespace: zm_tomb_craftables
	Checksum: 0x178DC82C
	Offset: 0x4118
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function craftable_model_attach_glow(n_elem, do_glow_now)
{
	self endon("death");
	if(!do_glow_now)
	{
		self waittill("staff_piece_glow");
	}
	self clientfield::set("element_glow_fx", n_elem);
}

/*
	Name: tomb_staff_update_prompt
	Namespace: zm_tomb_craftables
	Checksum: 0x8BDED710
	Offset: 0x4178
	Size: 0x15D
	Parameters: 3
	Flags: None
*/
function tomb_staff_update_prompt(player, b_set_hint_string_now, trigger)
{
	str_flag = self.weaponName.name + "_picked_up";
	if(level flag::get(str_flag))
	{
		return 0;
	}
	if(isdefined(self.crafted) && self.crafted)
	{
		return 1;
	}
	self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";
	if(isdefined(player))
	{
		if(!isdefined(player.current_craftable_pieces) || player.current_craftable_pieces.size < 1)
		{
			return 0;
		}
		if(!self.craftableSpawn zm_craftables::craftable_has_piece(player.current_craftable_pieces[0]))
		{
			self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";
			return 0;
		}
	}
	if(level.staff_part_count[self.craftableSpawn.craftable_name] == 0)
	{
		self.hint_string = level.zombie_craftableStubs[self.equipname].str_to_craft;
		return 1;
	}
	else
	{
		return 0;
	}
}

/*
	Name: init_craftable_choke
	Namespace: zm_tomb_craftables
	Checksum: 0xE9B1B6A3
	Offset: 0x42E0
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
	Namespace: zm_tomb_craftables
	Checksum: 0xB2C122B
	Offset: 0x4328
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
	Name: quadrotorcraftable
	Namespace: zm_tomb_craftables
	Checksum: 0x48A6173F
	Offset: 0x4388
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function quadrotorcraftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("quadrotor_zm_craftable_trigger", "equip_dieseldrone", "equip_dieseldrone", &"ZM_TOMB_TQ", 1, 1);
}

/*
	Name: staffcraftable_air
	Namespace: zm_tomb_craftables
	Checksum: 0x1C31D231
	Offset: 0x43E0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function staffcraftable_air()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("staff_air_craftable_trigger", "elemental_staff_air", "staff_air", &"ZM_TOMB_PUAS", 1, 1);
}

/*
	Name: staffcraftable_fire
	Namespace: zm_tomb_craftables
	Checksum: 0x1D8610BD
	Offset: 0x4438
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function staffcraftable_fire()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("staff_fire_craftable_trigger", "elemental_staff_fire", "staff_fire", &"ZM_TOMB_PUFS", 1, 1);
}

/*
	Name: staffcraftable_lightning
	Namespace: zm_tomb_craftables
	Checksum: 0xDCC289DE
	Offset: 0x4490
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function staffcraftable_lightning()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("staff_lightning_craftable_trigger", "elemental_staff_lightning", "staff_lightning", &"ZM_TOMB_PULS", 1, 1);
}

/*
	Name: staffcraftable_water
	Namespace: zm_tomb_craftables
	Checksum: 0x247F7B66
	Offset: 0x44E8
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function staffcraftable_water()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("staff_water_craftable_trigger", "elemental_staff_water", "staff_water", &"ZM_TOMB_PUIS", 1, 1);
}

/*
	Name: gramophonecraftable
	Namespace: zm_tomb_craftables
	Checksum: 0xD07735EF
	Offset: 0x4540
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function gramophonecraftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("gramophone_craftable_trigger", "gramophone", "gramophone", &"ZOMBIE_GRAB_GRAMOPHONE", 1, 1);
}

/*
	Name: tankcraftableupdateprompt
	Namespace: zm_tomb_craftables
	Checksum: 0xC1256E2B
	Offset: 0x4598
	Size: 0x9B
	Parameters: 3
	Flags: None
*/
function tankcraftableupdateprompt(player, setHintStringNow, buildableTrigger)
{
	if(level.vh_tank GetSpeedMPH() > 0)
	{
		if(isdefined(self))
		{
			self.hint_string = "";
			if(isdefined(setHintStringNow) && setHintStringNow && isdefined(buildableTrigger))
			{
				buildableTrigger setHintString(self.hint_string);
			}
		}
		return 0;
	}
	return 1;
}

/*
	Name: onDrop_Common
	Namespace: zm_tomb_craftables
	Checksum: 0x7B71D7C0
	Offset: 0x4640
	Size: 0x15
	Parameters: 1
	Flags: None
*/
function onDrop_Common(player)
{
	self.piece_owner = undefined;
}

/*
	Name: ondrop_crystal
	Namespace: zm_tomb_craftables
	Checksum: 0x2233D270
	Offset: 0x4660
	Size: 0x10F
	Parameters: 1
	Flags: None
*/
function ondrop_crystal(player)
{
	onDrop_Common(player);
	s_piece = self.pieceStub;
	s_piece.pieceSpawn.canMove = 1;
	zm_unitrigger::reregister_unitrigger_as_dynamic(s_piece.pieceSpawn.unitrigger);
	s_original_pos = struct::get(self.craftablename + "_" + self.pieceName);
	s_piece.pieceSpawn.model.origin = s_original_pos.origin;
	s_piece.pieceSpawn.model.angles = s_original_pos.angles;
}

/*
	Name: ondrop_firecrystal
	Namespace: zm_tomb_craftables
	Checksum: 0xD730F0F6
	Offset: 0x4778
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function ondrop_firecrystal(player)
{
	level clientfield::set("fire_staff.piece_zm_gem", 0);
	level clientfield::set("fire_staff.quest_state", 1);
	level clientfield::set("piece_record_zm_vinyl_fire", 0);
	player clear_player_crystal(1, "fire_staff.holder");
	ondrop_crystal(player);
}

/*
	Name: ondrop_aircrystal
	Namespace: zm_tomb_craftables
	Checksum: 0xBF32898C
	Offset: 0x4828
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function ondrop_aircrystal(player)
{
	level clientfield::set("air_staff.piece_zm_gem", 0);
	level clientfield::set("air_staff.quest_state", 1);
	level clientfield::set("piece_record_zm_vinyl_air", 0);
	player clear_player_crystal(2, "air_staff.holder");
	ondrop_crystal(player);
}

/*
	Name: ondrop_lightningcrystal
	Namespace: zm_tomb_craftables
	Checksum: 0x21EE29ED
	Offset: 0x48D8
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function ondrop_lightningcrystal(player)
{
	level clientfield::set("lightning_staff.piece_zm_gem", 0);
	level clientfield::set("lightning_staff.quest_state", 1);
	level clientfield::set("piece_record_zm_vinyl_lightning", 0);
	player clear_player_crystal(3, "lightning_staff.holder");
	ondrop_crystal(player);
}

/*
	Name: ondrop_watercrystal
	Namespace: zm_tomb_craftables
	Checksum: 0xCA92F55
	Offset: 0x4988
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function ondrop_watercrystal(player)
{
	level clientfield::set("water_staff.piece_zm_gem", 0);
	level clientfield::set("water_staff.quest_state", 1);
	level clientfield::set("piece_record_zm_vinyl_water", 0);
	player clear_player_crystal(4, "water_staff.holder");
	ondrop_crystal(player);
}

/*
	Name: clear_player_crystal
	Namespace: zm_tomb_craftables
	Checksum: 0x9976FCD6
	Offset: 0x4A38
	Size: 0x67
	Parameters: 2
	Flags: None
*/
function clear_player_crystal(n_element, var_94f38c49)
{
	if(n_element == self.crystal_id)
	{
		level clientfield::set(var_94f38c49, 0);
		self clientfield::set_player_uimodel("zmInventory.current_gem", 0);
		self.crystal_id = 0;
	}
}

/*
	Name: piece_pickup_conversation
	Namespace: zm_tomb_craftables
	Checksum: 0x7D9D49CF
	Offset: 0x4AA8
	Size: 0xE9
	Parameters: 1
	Flags: None
*/
function piece_pickup_conversation(player)
{
	wait(1);
	while(isdefined(player.isSpeaking) && player.isSpeaking)
	{
		util::wait_network_frame();
	}
	if(isdefined(self.pieceStub.vo_line_notify))
	{
		level notify("quest_progressed", player, 0);
		level notify(self.pieceStub.vo_line_notify, player);
	}
	else if(isdefined(self.pieceStub.sam_line))
	{
		level notify("quest_progressed", player, 0);
		level notify(self.pieceStub.sam_line, player);
	}
	else
	{
		level notify("quest_progressed", player, 1);
	}
}

/*
	Name: onPickup_Common
	Namespace: zm_tomb_craftables
	Checksum: 0x6EAF8823
	Offset: 0x4BA0
	Size: 0xD5
	Parameters: 1
	Flags: None
*/
function onPickup_Common(player)
{
	player playsound("zmb_craftable_pickup");
	self.piece_owner = player;
	self thread piece_pickup_conversation(player);
	/#
		foreach(spawn in self.spawns)
		{
			spawn notify("stop_debug_position");
		}
	#/
}

/*
	Name: staff_pickup_vo
	Namespace: zm_tomb_craftables
	Checksum: 0x774B5F58
	Offset: 0x4C80
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function staff_pickup_vo()
{
	if(!level flag::get("samantha_intro_done"))
	{
		return;
	}
	if(!(isdefined(level.sam_staff_line_played) && level.sam_staff_line_played))
	{
		level.sam_staff_line_played = 1;
		wait(1);
		zm_tomb_vo::set_players_dontspeak(1);
		zm_tomb_vo::samanthasay("vox_sam_1st_staff_found_1_0", self, 1);
		zm_tomb_vo::samanthasay("vox_sam_1st_staff_found_2_0", self);
		zm_tomb_vo::set_players_dontspeak(0);
		self zm_audio::create_and_play_dialog("staff", "first_piece");
	}
}

/*
	Name: function_4d932a71
	Namespace: zm_tomb_craftables
	Checksum: 0x663EB4ED
	Offset: 0x4D70
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_4d932a71(player)
{
	onpickup_staffpiece(player, "fire");
}

/*
	Name: function_f35af043
	Namespace: zm_tomb_craftables
	Checksum: 0xD59FC7CB
	Offset: 0x4DA8
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_f35af043(player)
{
	onpickup_staffpiece(player, "air");
}

/*
	Name: function_47c3d969
	Namespace: zm_tomb_craftables
	Checksum: 0x74964FEE
	Offset: 0x4DE0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_47c3d969(player)
{
	onpickup_staffpiece(player, "lightning");
}

/*
	Name: function_6c091d36
	Namespace: zm_tomb_craftables
	Checksum: 0xC8E9A3F6
	Offset: 0x4E18
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_6c091d36(player)
{
	onpickup_staffpiece(player, "water");
}

/*
	Name: onpickup_staffpiece
	Namespace: zm_tomb_craftables
	Checksum: 0xEBF24F6D
	Offset: 0x4E50
	Size: 0x153
	Parameters: 2
	Flags: None
*/
function onpickup_staffpiece(player, elementname)
{
	onPickup_Common(player);
	if(!isdefined(level.num_staffpieces_picked_up[self.craftablename]))
	{
		level.num_staffpieces_picked_up[self.craftablename] = 0;
	}
	level.num_staffpieces_picked_up[self.craftablename]++;
	if(level.num_staffpieces_picked_up[self.craftablename] == 3)
	{
		level notify(self.craftablename + "_all_pieces_found");
	}
	foreach(e_player in level.players)
	{
		e_player thread zm_craftables::player_show_craftable_parts_ui(undefined, "zmInventory." + elementname + "_staff.visible", 0);
	}
	player thread staff_pickup_vo();
}

/*
	Name: onpickup_crystal
	Namespace: zm_tomb_craftables
	Checksum: 0xEDE50013
	Offset: 0x4FB0
	Size: 0x1CB
	Parameters: 3
	Flags: None
*/
function onpickup_crystal(player, elementname, elementenum)
{
	onPickup_Common(player);
	level clientfield::set(elementname + "_staff.piece_zm_gem", 1);
	level clientfield::set(elementname + "_staff.holder", player.characterindex + 1);
	if(level flag::get("any_crystal_picked_up"))
	{
		self.pieceStub.vox_id = undefined;
	}
	foreach(e_player in level.players)
	{
		e_player thread zm_craftables::player_show_craftable_parts_ui(undefined, "zmInventory." + elementname + "_staff.visible", 0);
	}
	player thread zm_craftables::player_show_craftable_parts_ui(undefined, "zmInventory.show_musical_parts_widget", 0);
	level flag::set("any_crystal_picked_up");
	player clientfield::set_player_uimodel("zmInventory.current_gem", player.crystal_id);
}

/*
	Name: onpickup_firecrystal
	Namespace: zm_tomb_craftables
	Checksum: 0xE88811AA
	Offset: 0x5188
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function onpickup_firecrystal(player)
{
	level clientfield::set("fire_staff.quest_state", 2);
	player.crystal_id = 1;
	onpickup_crystal(player, "fire", 1);
}

/*
	Name: onpickup_aircrystal
	Namespace: zm_tomb_craftables
	Checksum: 0x26BBC2ED
	Offset: 0x51F8
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function onpickup_aircrystal(player)
{
	level clientfield::set("air_staff.quest_state", 2);
	player.crystal_id = 2;
	onpickup_crystal(player, "air", 2);
}

/*
	Name: onpickup_lightningcrystal
	Namespace: zm_tomb_craftables
	Checksum: 0x641E52A6
	Offset: 0x5268
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function onpickup_lightningcrystal(player)
{
	level clientfield::set("lightning_staff.quest_state", 2);
	player.crystal_id = 3;
	onpickup_crystal(player, "lightning", 3);
}

/*
	Name: onpickup_watercrystal
	Namespace: zm_tomb_craftables
	Checksum: 0xD36E5CA6
	Offset: 0x52D8
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function onpickup_watercrystal(player)
{
	level clientfield::set("water_staff.quest_state", 2);
	player.crystal_id = 4;
	onpickup_crystal(player, "water", 4);
}

/*
	Name: vinyl_add_pickup
	Namespace: zm_tomb_craftables
	Checksum: 0xF8D180C8
	Offset: 0x5348
	Size: 0xDF
	Parameters: 7
	Flags: None
*/
function vinyl_add_pickup(str_craftable_name, str_piece_name, str_model_name, str_bit_clientfield, str_quest_clientfield, str_vox_id, var_e46422e8)
{
	b_one_time_vo = 1;
	craftable = zm_craftables::generate_zombie_craftable_piece(str_craftable_name, str_piece_name, 32, 64, 0, undefined, &onPickup_Common, &onDrop_Common, undefined, undefined, undefined, undefined, str_bit_clientfield, 1, str_vox_id, b_one_time_vo, undefined, 0);
	craftable thread watch_part_pickup(str_quest_clientfield, 1, var_e46422e8);
	return craftable;
}

/*
	Name: watch_part_pickup
	Namespace: zm_tomb_craftables
	Checksum: 0x81978821
	Offset: 0x5430
	Size: 0x139
	Parameters: 3
	Flags: None
*/
function watch_part_pickup(str_quest_clientfield, n_clientfield_val, var_e46422e8)
{
	self craftable_waittill_spawned();
	self.pieceSpawn waittill("pickup");
	level notify(self.craftablename + "_" + self.pieceName + "_picked_up");
	if(isdefined(str_quest_clientfield) && isdefined(n_clientfield_val))
	{
		level clientfield::set(str_quest_clientfield, n_clientfield_val);
	}
	if(isdefined(var_e46422e8))
	{
		foreach(e_player in level.players)
		{
			e_player thread zm_craftables::player_show_craftable_parts_ui(undefined, var_e46422e8, 0);
		}
	}
}

/*
	Name: count_staff_piece_pickup
	Namespace: zm_tomb_craftables
	Checksum: 0x26B5FF8F
	Offset: 0x5578
	Size: 0x109
	Parameters: 1
	Flags: None
*/
function count_staff_piece_pickup(a_staff_pieces)
{
	if(!isdefined(level.staff_part_count))
	{
		level.staff_part_count = [];
	}
	str_name = a_staff_pieces[0].craftablename;
	level.staff_part_count[str_name] = a_staff_pieces.size;
	foreach(piece in a_staff_pieces)
	{
		/#
			Assert(piece.craftablename == str_name);
		#/
		piece thread watch_staff_pickup();
	}
}

/*
	Name: craftable_waittill_spawned
	Namespace: zm_tomb_craftables
	Checksum: 0xDE284E20
	Offset: 0x5690
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
	Name: watch_staff_pickup
	Namespace: zm_tomb_craftables
	Checksum: 0xB9FDF290
	Offset: 0x56C0
	Size: 0x41
	Parameters: 0
	Flags: None
*/
function watch_staff_pickup()
{
	self craftable_waittill_spawned();
	self.pieceSpawn waittill("pickup");
	level.staff_part_count[self.craftablename]--;
}

/*
	Name: onfullycrafted_quadrotor
	Namespace: zm_tomb_craftables
	Checksum: 0x5B866DFA
	Offset: 0x5710
	Size: 0x10D
	Parameters: 1
	Flags: None
*/
function onfullycrafted_quadrotor(player)
{
	level.quadrotor_status.crafted = 1;
	zm_craftables::set_hide_model_if_unavailable("equip_dieseldrone", 1);
	self.custom_craftablestub_update_prompt = &function_52fbdde1;
	pickup_trig = level.quadrotor_status.pickup_trig;
	level.quadrotor_status.str_zone = zm_zonemgr::get_zone_from_position(pickup_trig.origin, 1);
	pickup_trig.model SetModel("veh_t7_dlc_zm_quadrotor");
	pickup_trig.model SetScale(0.7);
	level notify("quest_progressed", player, 1);
	return 1;
}

/*
	Name: function_52fbdde1
	Namespace: zm_tomb_craftables
	Checksum: 0x1CBB14B
	Offset: 0x5828
	Size: 0x16F
	Parameters: 1
	Flags: None
*/
function function_52fbdde1(player)
{
	var_703e6a13 = GetWeapon("equip_dieseldrone");
	if(player HasWeapon(var_703e6a13))
	{
		self.hint_string = &"ZOMBIE_BUILD_PIECE_HAVE_ONE";
		return 0;
	}
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i] HasWeapon(var_703e6a13))
		{
			self.hint_string = &"DLC5_QUADROTOR_UNAVAILABLE";
			return 0;
		}
	}
	quadrotors = GetEntArray("quadrotor_ai", "targetname");
	if(quadrotors.size >= 1)
	{
		self.hint_string = &"DLC5_QUADROTOR_UNAVAILABLE";
		return 0;
	}
	if(level flag::get("quadrotor_cooling_down"))
	{
		self.hint_string = &"DLC5_QUADROTOR_COOLDOWN";
		return 0;
	}
	return 1;
}

/*
	Name: staff_fullycrafted
	Namespace: zm_tomb_craftables
	Checksum: 0xDD3E0DB3
	Offset: 0x59A0
	Size: 0x387
	Parameters: 2
	Flags: None
*/
function staff_fullycrafted(modelName, elementenum)
{
	player = zm_utility::get_closest_player(self.origin);
	staff_model = GetEnt(modelName, "targetname");
	staff_info = get_staff_info_from_element_index(elementenum);
	staff_model UseWeaponModel(staff_info.w_weapon);
	staff_model showallparts();
	switch(staff_info.craftable_name)
	{
		case "elemental_staff_air":
		{
			staff_model.angles = VectorScale((0, 1, 0), 130);
			break;
		}
		case "elemental_staff_fire":
		{
			staff_model.angles = VectorScale((0, 1, 0), 50);
			break;
		}
		case "elemental_staff_lightning":
		{
			staff_model.angles = VectorScale((0, 1, 0), 90);
			break;
		}
		case "elemental_staff_water":
		{
			staff_model.angles = (0, 0, 0);
			break;
		}
	}
	level notify("quest_progressed", player, 0);
	if(!isdefined(staff_model.inused))
	{
		staff_model.origin = staff_model.origin - VectorScale((0, 0, 1), 30);
		player clear_player_crystal(elementenum, staff_info.element + "_staff.holder");
		staff_model show();
		staff_model.inused = 1;
		level.n_staffs_crafted++;
		if(level.n_staffs_crafted == 4)
		{
			level flag::set("ee_all_staffs_crafted");
		}
		foreach(e_player in level.players)
		{
			e_player thread zm_craftables::player_show_craftable_parts_ui(undefined, "zmInventory." + staff_info.element + "_staff.visible", 1);
		}
	}
	else if(!isdefined(staff_info.charger) || (!isdefined(staff_info.charger.is_charged) && staff_info.charger.is_charged))
	{
		str_fieldname = staff_info.element + "_staff.quest_state";
		level clientfield::set(str_fieldname, 3);
	}
	return 1;
}

/*
	Name: staff_fire_fullycrafted
	Namespace: zm_tomb_craftables
	Checksum: 0xFC3A34D8
	Offset: 0x5D30
	Size: 0x41
	Parameters: 0
	Flags: None
*/
function staff_fire_fullycrafted()
{
	level thread sndplaystaffstingeronce("fire");
	return staff_fullycrafted("craftable_staff_fire_zm", 1);
}

/*
	Name: staff_air_fullycrafted
	Namespace: zm_tomb_craftables
	Checksum: 0xF0F1CDDC
	Offset: 0x5D80
	Size: 0x41
	Parameters: 0
	Flags: None
*/
function staff_air_fullycrafted()
{
	level thread sndplaystaffstingeronce("air");
	return staff_fullycrafted("craftable_staff_air_zm", 2);
}

/*
	Name: staff_lightning_fullycrafted
	Namespace: zm_tomb_craftables
	Checksum: 0xEDA55FCF
	Offset: 0x5DD0
	Size: 0x41
	Parameters: 0
	Flags: None
*/
function staff_lightning_fullycrafted()
{
	level thread sndplaystaffstingeronce("lightning");
	return staff_fullycrafted("craftable_staff_lightning_zm", 3);
}

/*
	Name: staff_water_fullycrafted
	Namespace: zm_tomb_craftables
	Checksum: 0x9E586018
	Offset: 0x5E20
	Size: 0x41
	Parameters: 0
	Flags: None
*/
function staff_water_fullycrafted()
{
	level thread sndplaystaffstingeronce("ice");
	return staff_fullycrafted("craftable_staff_water_zm", 4);
}

/*
	Name: sndplaystaffstingeronce
	Namespace: zm_tomb_craftables
	Checksum: 0x11062620
	Offset: 0x5E70
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function sndplaystaffstingeronce(type)
{
	if(!isdefined(level.sndstaffbuilt))
	{
		level.sndstaffbuilt = [];
	}
	if(!IsInArray(level.sndstaffbuilt, type))
	{
		level.sndstaffbuilt[level.sndstaffbuilt.size] = type;
		level thread zm_tomb_amb::sndplaystinger("staff_" + type);
	}
}

/*
	Name: quadrotor_watcher
	Namespace: zm_tomb_craftables
	Checksum: 0xEF33309D
	Offset: 0x5EF8
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function quadrotor_watcher(player)
{
	quadrotor_set_unavailable();
	player thread quadrotor_return_condition_watcher();
	player thread quadrotor_control_thread();
	level waittill("drone_available");
	level.maxis_quadrotor = undefined;
	if(level flag::get("ee_quadrotor_disabled"))
	{
		level flag::wait_till_clear("ee_quadrotor_disabled");
	}
	quadrotor_set_available();
}

/*
	Name: quadrotor_return_condition_watcher
	Namespace: zm_tomb_craftables
	Checksum: 0x5456C10
	Offset: 0x5FB0
	Size: 0x75
	Parameters: 0
	Flags: None
*/
function quadrotor_return_condition_watcher()
{
	self notify("quadrotor_return_condition_watcher");
	self endon("quadrotor_return_condition_watcher");
	self endon("new_placeable_mine");
	self util::waittill_any("bled_out", "disconnect");
	if(isdefined(level.maxis_quadrotor))
	{
		level notify("drone_should_return");
	}
	else
	{
		level notify("drone_available");
	}
}

/*
	Name: quadrotor_control_thread
	Namespace: zm_tomb_craftables
	Checksum: 0x74C80716
	Offset: 0x6030
	Size: 0x233
	Parameters: 0
	Flags: None
*/
function quadrotor_control_thread()
{
	self notify("quadrotor_control_thread");
	self endon("quadrotor_control_thread");
	self endon("bled_out");
	self endon("disconnect");
	self endon("new_placeable_mine");
	while(1)
	{
		var_703e6a13 = GetWeapon("equip_dieseldrone");
		if(self ActionSlotFourButtonPressed() && self HasWeapon(var_703e6a13))
		{
			self util::waittill_any_timeout(1, "weapon_change_complete");
			self playsound("veh_qrdrone_takeoff");
			self zm_weapons::switch_back_primary_weapon();
			self util::waittill_any_timeout(1, "weapon_change_complete");
			self zm_weapons::weapon_take(var_703e6a13);
			self SetActionSlot(4, "");
			str_vehicle = "heli_quadrotor_zm";
			if(level flag::get("ee_maxis_drone_retrieved"))
			{
				str_vehicle = "heli_quadrotor_upgraded_zm";
			}
			QR = SpawnVehicle(str_vehicle, self.origin + VectorScale((0, 0, 1), 96), self.angles, "quadrotor_ai");
			level thread quadrotor_death_watcher(QR);
			QR thread quadrotor_instance_watcher(self);
			QR thread zm_tomb_vo::function_a808bc8e();
			return;
		}
		wait(0.05);
	}
}

/*
	Name: quadrotor_debug_send_home
	Namespace: zm_tomb_craftables
	Checksum: 0x28DCD8DE
	Offset: 0x6270
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function quadrotor_debug_send_home(player_owner)
{
	self endon("drone_should_return");
	level endon("drone_available");
	while(1)
	{
		if(player_owner ActionSlotFourButtonPressed())
		{
			self quadrotor_fly_back_to_table();
		}
		wait(0.05);
	}
}

/*
	Name: quadrotor_instance_watcher
	Namespace: zm_tomb_craftables
	Checksum: 0x27E4C3C6
	Offset: 0x62E0
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function quadrotor_instance_watcher(player_owner)
{
	self endon("death");
	self.player_owner = player_owner;
	self.health = 200;
	level.maxis_quadrotor = self;
	self MakeVehicleUnusable();
	self thread namespace_3a47cb81::follow_ent(player_owner);
	self thread quadrotor_timer();
	self thread function_e8aad972(player_owner);
	level waittill("drone_should_return");
	self quadrotor_fly_back_to_table();
}

/*
	Name: quadrotor_death_watcher
	Namespace: zm_tomb_craftables
	Checksum: 0x564934B
	Offset: 0x63A8
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function quadrotor_death_watcher(quadrotor)
{
	level endon("drone_available");
	quadrotor waittill("death");
	level notify("drone_available");
}

/*
	Name: quadrotor_fly_back_to_table
	Namespace: zm_tomb_craftables
	Checksum: 0x7CDF2090
	Offset: 0x63E8
	Size: 0x161
	Parameters: 0
	Flags: None
*/
function quadrotor_fly_back_to_table()
{
	self endon("death");
	level endon("drone_available");
	if(isdefined(self))
	{
		/#
			iprintln("Dev Block strings are not supported");
		#/
		self.returning_home = 1;
		self thread quadrotor_fly_back_to_table_timeout();
		self util::waittill_any("attempting_return", "return_timeout");
	}
	if(isdefined(self))
	{
		self util::waittill_any("near_goal", "force_goal", "reached_end_node", "return_timeout");
	}
	if(isdefined(self))
	{
		playFX(level._effect["tesla_elec_kill"], self.origin);
		self playsound("zmb_qrdrone_leave");
		self delete();
		/#
			iprintln("Dev Block strings are not supported");
		#/
	}
	level notify("drone_available");
}

/*
	Name: report_notify
	Namespace: zm_tomb_craftables
	Checksum: 0x5EDFD75F
	Offset: 0x6558
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function report_notify(str_notify)
{
	self waittill(str_notify);
	iprintln(str_notify);
}

/*
	Name: quadrotor_fly_back_to_table_timeout
	Namespace: zm_tomb_craftables
	Checksum: 0x8589FD7A
	Offset: 0x6590
	Size: 0x69
	Parameters: 0
	Flags: None
*/
function quadrotor_fly_back_to_table_timeout()
{
	self endon("death");
	level endon("drone_available");
	wait(30);
	if(isdefined(self))
	{
		self delete();
		/#
			iprintln("Dev Block strings are not supported");
		#/
	}
	self notify("return_timeout");
}

/*
	Name: quadrotor_timer
	Namespace: zm_tomb_craftables
	Checksum: 0x1F21AEE2
	Offset: 0x6608
	Size: 0xA1
	Parameters: 0
	Flags: None
*/
function quadrotor_timer()
{
	self endon("death");
	level endon("drone_available");
	wait(80);
	vox_line = "vox_maxi_drone_cool_down_" + randomIntRange(0, 2);
	self thread zm_tomb_vo::MaxisSay(vox_line, self);
	wait(10);
	vox_line = "vox_maxi_drone_cool_down_2";
	self thread zm_tomb_vo::MaxisSay(vox_line, self);
	level notify("drone_should_return");
}

/*
	Name: quadrotor_set_available
	Namespace: zm_tomb_craftables
	Checksum: 0x82E47FEE
	Offset: 0x66B8
	Size: 0x2F3
	Parameters: 0
	Flags: None
*/
function quadrotor_set_available()
{
	/#
		iprintln("Dev Block strings are not supported");
	#/
	playFX(level._effect["tesla_elec_kill"], level.quadrotor_status.pickup_trig.model.origin);
	level.quadrotor_status.pickup_trig.model playsound("zmb_qrdrone_leave");
	level.quadrotor_status.picked_up = 0;
	level.quadrotor_status.pickup_trig.model show();
	level flag::set("quadrotor_cooling_down");
	str_zone = level.quadrotor_status.str_zone;
	switch(str_zone)
	{
		case "zone_nml_9":
		{
			clientfield::set("cooldown_steam", 1);
			break;
		}
		case "zone_bunker_5a":
		{
			clientfield::set("cooldown_steam", 2);
			break;
		}
		case "zone_village_1":
		{
			clientfield::set("cooldown_steam", 3);
			break;
		}
	}
	vox_line = "vox_maxi_drone_cool_down_3";
	thread zm_tomb_vo::MaxisSay(vox_line, level.quadrotor_status.pickup_trig.model);
	wait(60);
	level flag::clear("quadrotor_cooling_down");
	clientfield::set("cooldown_steam", 0);
	foreach(t_pickup in level.quadrotor_status.pickup_trig.playertrigger)
	{
		t_pickup TriggerEnable(1);
	}
	vox_line = "vox_maxi_drone_cool_down_4";
	zm_tomb_vo::MaxisSay(vox_line, level.quadrotor_status.pickup_trig.model);
}

/*
	Name: quadrotor_set_unavailable
	Namespace: zm_tomb_craftables
	Checksum: 0xDE18118
	Offset: 0x69B8
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function quadrotor_set_unavailable()
{
	level.quadrotor_status.picked_up = 1;
	foreach(t_pickup in level.quadrotor_status.pickup_trig.playertrigger)
	{
		t_pickup TriggerEnable(0);
	}
	level.quadrotor_status.pickup_trig.model ghost();
}

/*
	Name: function_e8aad972
	Namespace: zm_tomb_craftables
	Checksum: 0x4CB3B618
	Offset: 0x6AA0
	Size: 0xB7
	Parameters: 1
	Flags: None
*/
function function_e8aad972(var_7ee6d8e6)
{
	self endon("death");
	level endon("drone_available");
	while(1)
	{
		var_7ee6d8e6 util::waittill_any("teleport_finished", "gr_eject_sequence_complete");
		self clientfield::increment("teleport_arrival_departure_fx");
		self.origin = var_7ee6d8e6.origin + VectorScale((0, 0, 1), 100);
		self clientfield::increment("teleport_arrival_departure_fx");
	}
}

/*
	Name: sqcommoncraftable
	Namespace: zm_tomb_craftables
	Checksum: 0xD1056BD5
	Offset: 0x6B60
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function sqcommoncraftable()
{
	level.sq_craftable = zm_craftables::craftable_trigger_think("sq_common_craftable_trigger", "sq_common", "sq_common", "", 1, 0);
}

/*
	Name: droponmover
	Namespace: zm_tomb_craftables
	Checksum: 0xC135297D
	Offset: 0x6BB0
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function droponmover(player)
{
}

/*
	Name: pickupfrommover
	Namespace: zm_tomb_craftables
	Checksum: 0x99EC1590
	Offset: 0x6BC8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function pickupfrommover()
{
}

/*
	Name: setup_quadrotor_purchase
	Namespace: zm_tomb_craftables
	Checksum: 0x9D0A5661
	Offset: 0x6BD8
	Size: 0x213
	Parameters: 1
	Flags: None
*/
function setup_quadrotor_purchase(player)
{
	var_703e6a13 = GetWeapon("equip_dieseldrone");
	if(self.stub.equipname == "equip_dieseldrone")
	{
		if(players_has_weapon(var_703e6a13))
		{
			return 1;
		}
		quadrotor = GetEntArray("quadrotor_ai", "targetname");
		if(quadrotor.size >= 1)
		{
			return 1;
		}
		quadrotor_set_unavailable();
		player zm_weapons::weapon_give(var_703e6a13);
		player SetWeaponAmmoClip(var_703e6a13, 1);
		player playsoundtoplayer("zmb_buildable_pickup_complete", player);
		if(isdefined(self.stub.craftableStub.use_actionslot))
		{
			player SetActionSlot(self.stub.craftableStub.use_actionslot, "weapon", var_703e6a13);
		}
		else
		{
			player SetActionSlot(4, "weapon", var_703e6a13);
		}
		player clientfield::set_player_uimodel("hudItems.showDpadRight_Drone", 1);
		player notify("equip_dieseldrone_zm_given");
		level thread quadrotor_watcher(player);
		player thread zm_audio::create_and_play_dialog("general", "build_dd_plc");
		return 1;
	}
	return 0;
}

/*
	Name: players_has_weapon
	Namespace: zm_tomb_craftables
	Checksum: 0xD47DE52D
	Offset: 0x6DF8
	Size: 0xBF
	Parameters: 1
	Flags: None
*/
function players_has_weapon(weaponName)
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i] HasWeapon(weaponName))
		{
			return 1;
		}
	}
	quadrotors = GetEntArray("quadrotor_ai", "targetname");
	if(quadrotors.size >= 1)
	{
		return 1;
	}
	return 0;
}

/*
	Name: tomb_custom_craftable_validation
	Namespace: zm_tomb_craftables
	Checksum: 0xEFB36241
	Offset: 0x6EC0
	Size: 0x27D
	Parameters: 1
	Flags: None
*/
function tomb_custom_craftable_validation(player)
{
	if(self.stub.equipname == "equip_dieseldrone")
	{
		level.quadrotor_status.pickup_trig = self.stub;
		if(level.quadrotor_status.crafted)
		{
			var_703e6a13 = GetWeapon("equip_dieseldrone");
			return !players_has_weapon(var_703e6a13) && !level flag::get("quadrotor_cooling_down");
		}
	}
	if(!IsSubStr(self.stub.weaponName.name, "staff"))
	{
		return 1;
	}
	str_craftable = self.stub.equipname;
	if(!(isdefined(level.craftables_crafted[str_craftable]) && level.craftables_crafted[str_craftable]))
	{
		return 1;
	}
	if(!player zm_tomb_main_quest::can_pickup_staff())
	{
		return 0;
	}
	s_elemental_staff = get_staff_info_from_weapon_name(self.stub.weaponName, 0);
	str_weapon_check = s_elemental_staff.weapname;
	a_weapons = player GetWeaponsListPrimaries();
	foreach(weapon in a_weapons)
	{
		if(IsSubStr(weapon.name, "staff") && weapon.name != str_weapon_check)
		{
			player TakeWeapon(weapon);
		}
	}
	return 1;
}

/*
	Name: tomb_check_crafted_weapon_persistence
	Namespace: zm_tomb_craftables
	Checksum: 0xA94C1858
	Offset: 0x7148
	Size: 0x44B
	Parameters: 1
	Flags: None
*/
function tomb_check_crafted_weapon_persistence(player)
{
	if(self.stub.equipname == "equip_dieseldrone")
	{
		if(level.quadrotor_status.crafted)
		{
			return 0;
		}
	}
	else if(self.stub.weaponName == level.a_elemental_staffs["staff_air"].w_weapon || self.stub.weaponName == level.a_elemental_staffs["staff_fire"].w_weapon || self.stub.weaponName == level.a_elemental_staffs["staff_lightning"].w_weapon || self.stub.weaponName == level.a_elemental_staffs["staff_water"].w_weapon)
	{
		if(self is_unclaimed_staff_weapon(self.stub.weaponName) && (!isdefined(level.var_b79a2c38[self.stub.equipname]) && level.var_b79a2c38[self.stub.equipname]))
		{
			level thread function_fcebb932(self.stub.equipname);
			s_elemental_staff = get_staff_info_from_weapon_name(self.stub.weaponName, 0);
			player zm_weapons::weapon_give(s_elemental_staff.w_weapon, 0, 0);
			if(isdefined(s_elemental_staff.prev_ammo_stock) && isdefined(s_elemental_staff.prev_ammo_clip))
			{
				player SetWeaponAmmoStock(s_elemental_staff.w_weapon, s_elemental_staff.prev_ammo_stock);
				player SetWeaponAmmoClip(s_elemental_staff.w_weapon, s_elemental_staff.prev_ammo_clip);
			}
			if(isdefined(level.zombie_craftableStubs[self.stub.equipname].str_taken))
			{
				self.stub.hint_string = level.zombie_craftableStubs[self.stub.equipname].str_taken;
			}
			else
			{
				self.stub.hint_string = "";
			}
			self setHintString(self.stub.hint_string);
			player zm_craftables::track_craftables_pickedup(self.stub.craftableSpawn);
			str_name = "craftable_" + self.stub.weaponName.name + "_zm";
			model = GetEnt(str_name, "targetname");
			model ghost();
			self.stub thread track_crafted_staff_trigger();
			self.stub thread track_staff_weapon_respawn(player);
			set_player_staff(self.stub.weaponName, player);
		}
		else
		{
			self.stub.hint_string = "";
			self setHintString(self.stub.hint_string);
		}
		return 1;
	}
	return 0;
}

/*
	Name: function_fcebb932
	Namespace: zm_tomb_craftables
	Checksum: 0xF750E0DB
	Offset: 0x75A0
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function function_fcebb932(str_equipname)
{
	level.var_b79a2c38[str_equipname] = 1;
	wait(0.2);
	level.var_b79a2c38[str_equipname] = 0;
}

/*
	Name: is_unclaimed_staff_weapon
	Namespace: zm_tomb_craftables
	Checksum: 0xEAFEF3F9
	Offset: 0x75E8
	Size: 0x143
	Parameters: 1
	Flags: None
*/
function is_unclaimed_staff_weapon(var_382bb75)
{
	if(!zm_equipment::is_limited(var_382bb75))
	{
		return 1;
		break;
	}
	s_elemental_staff = get_staff_info_from_weapon_name(var_382bb75, 0);
	str_weapon_check = s_elemental_staff.weapname;
	players = GetPlayers();
	foreach(player in players)
	{
		if(isdefined(player) && player.sessionstate == "playing" && player zm_weapons::has_weapon_or_upgrade(var_382bb75))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: get_staff_info_from_weapon_name
	Namespace: zm_tomb_craftables
	Checksum: 0x72C9A67B
	Offset: 0x7738
	Size: 0x129
	Parameters: 2
	Flags: None
*/
function get_staff_info_from_weapon_name(w_weapon, b_base_info_only)
{
	if(!isdefined(b_base_info_only))
	{
		b_base_info_only = 1;
	}
	str_name = w_weapon.name;
	foreach(s_staff in level.a_elemental_staffs)
	{
		if(s_staff.weapname == str_name || s_staff.upgrade.weapname == str_name)
		{
			if(s_staff.charger.is_charged && !b_base_info_only)
			{
				return s_staff.upgrade;
				continue;
			}
			return s_staff;
		}
	}
	return undefined;
}

/*
	Name: get_staff_info_from_element_index
	Namespace: zm_tomb_craftables
	Checksum: 0x7B042FDF
	Offset: 0x7870
	Size: 0x99
	Parameters: 1
	Flags: None
*/
function get_staff_info_from_element_index(n_index)
{
	foreach(s_staff in level.a_elemental_staffs)
	{
		if(s_staff.enum == n_index)
		{
			return s_staff;
		}
	}
	return undefined;
}

/*
	Name: track_crafted_staff_trigger
	Namespace: zm_tomb_craftables
	Checksum: 0xA4BB3EE0
	Offset: 0x7918
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function track_crafted_staff_trigger()
{
	s_elemental_staff = get_staff_info_from_weapon_name(self.weaponName, 1);
	if(!isdefined(self.base_weaponname))
	{
		self.base_weaponname = s_elemental_staff.weapname;
	}
	level flag::wait_till_clear(self.base_weaponname + "_zm_enabled");
	level flag::set(self.base_weaponname + "_picked_up");
	level flag::wait_till(self.base_weaponname + "_zm_enabled");
	level flag::clear(self.base_weaponname + "_picked_up");
}

/*
	Name: track_staff_weapon_respawn
	Namespace: zm_tomb_craftables
	Checksum: 0x6331944F
	Offset: 0x7A18
	Size: 0x79B
	Parameters: 1
	Flags: None
*/
function track_staff_weapon_respawn(player)
{
	self notify("kill_track_staff_weapon_respawn");
	self endon("kill_track_staff_weapon_respawn");
	s_elemental_staff = undefined;
	if(IsSubStr(self.targetname, "prop_"))
	{
		s_elemental_staff = get_staff_info_from_weapon_name(self.w_weapon, 1);
	}
	else
	{
		s_elemental_staff = get_staff_info_from_weapon_name(self.weaponName, 1);
	}
	s_upgraded_staff = s_elemental_staff.upgrade;
	if(!isdefined(self.base_weaponname))
	{
		self.base_weaponname = s_elemental_staff.weapname;
	}
	level flag::clear(self.base_weaponname + "_zm_enabled");
	has_weapon = 0;
	while(isalive(player))
	{
		if(isdefined(s_elemental_staff.charger.is_inserted) && s_elemental_staff.charger.is_inserted || (isdefined(s_upgraded_staff.charger.is_inserted) && s_upgraded_staff.charger.is_inserted) || (isdefined(s_upgraded_staff.ee_in_use) && s_upgraded_staff.ee_in_use))
		{
			has_weapon = 1;
			break;
		}
		weapons = player GetWeaponsListPrimaries();
		foreach(weapon in weapons)
		{
			n_melee_element = 0;
			if(weapon.name == self.base_weaponname)
			{
				s_elemental_staff.prev_ammo_stock = player GetWeaponAmmoStock(weapon);
				s_elemental_staff.prev_ammo_clip = player GetWeaponAmmoClip(weapon);
				has_weapon = 1;
			}
			else if(weapon.name == s_upgraded_staff.weapname)
			{
				s_upgraded_staff.prev_ammo_stock = player GetWeaponAmmoStock(weapon);
				s_upgraded_staff.prev_ammo_clip = player GetWeaponAmmoClip(weapon);
				has_weapon = 1;
				n_melee_element = s_upgraded_staff.enum;
			}
			if(player HasWeapon(level.var_2b2f83e5))
			{
				s_upgraded_staff.revive_ammo_stock = player GetWeaponAmmoStock(level.var_2b2f83e5);
				s_upgraded_staff.revive_ammo_clip = player GetWeaponAmmoClip(level.var_2b2f83e5);
			}
			if(has_weapon && (!isdefined(player.one_inch_punch_flag_has_been_init) && player.one_inch_punch_flag_has_been_init) && n_melee_element != 0 && !player hasPerk("specialty_widowswine"))
			{
				cur_weapon = player GetCurrentWeapon();
				if(cur_weapon != weapon && (isdefined(player.use_staff_melee) && player.use_staff_melee))
				{
					player zm_tomb_utility::update_staff_accessories(0);
					continue;
				}
				if(cur_weapon == weapon && (!isdefined(player.use_staff_melee) && player.use_staff_melee))
				{
					player zm_tomb_utility::update_staff_accessories(n_melee_element);
				}
			}
		}
		if(!has_weapon && !player laststand::player_is_in_laststand())
		{
			break;
		}
		wait(0.5);
		has_weapon = 0;
	}
	b_staff_in_use = 0;
	a_players = GetPlayers();
	foreach(check_player in a_players)
	{
		if(check_player.sessionstate == "playing")
		{
			weapons = check_player GetWeaponsListPrimaries();
			foreach(weapon in weapons)
			{
				if(weapon.name == self.base_weaponname || weapon.name == s_upgraded_staff.weapname)
				{
					b_staff_in_use = 1;
				}
			}
		}
	}
	if(!b_staff_in_use)
	{
		str_name = "craftable_" + self.base_weaponname + "_zm";
		model = GetEnt(str_name, "targetname");
		model show();
		level flag::set(self.base_weaponname + "_zm_enabled");
	}
	if(IsWeapon(self.weaponName))
	{
		clear_player_staff(self.weaponName, player);
	}
	else
	{
		clear_player_staff(self.w_weapon, player);
	}
}

/*
	Name: set_player_staff
	Namespace: zm_tomb_craftables
	Checksum: 0xF911DB0B
	Offset: 0x81C0
	Size: 0x12B
	Parameters: 2
	Flags: None
*/
function set_player_staff(var_5ec0aa73, e_player)
{
	s_staff = get_staff_info_from_weapon_name(var_5ec0aa73);
	s_staff.e_owner = e_player;
	n_player = e_player GetEntityNumber() + 1;
	e_player.staff_enum = s_staff.enum;
	level clientfield::set(s_staff.element + "_staff.holder", e_player.characterindex + 1);
	e_player zm_tomb_utility::update_staff_accessories(s_staff.enum);
	/#
		IPrintLnBold("Dev Block strings are not supported" + n_player + "Dev Block strings are not supported" + s_staff.enum);
	#/
}

/*
	Name: clear_player_staff_by_player_number
	Namespace: zm_tomb_craftables
	Checksum: 0x1B9C190A
	Offset: 0x82F8
	Size: 0xE1
	Parameters: 1
	Flags: None
*/
function clear_player_staff_by_player_number(var_d95a0cf3)
{
	foreach(s_staff in level.a_elemental_staffs)
	{
		if(level clientfield::get(s_staff.element + "_staff.holder") == var_d95a0cf3)
		{
			level clientfield::set(s_staff.element + "_staff.holder", 0);
		}
	}
}

/*
	Name: clear_player_staff
	Namespace: zm_tomb_craftables
	Checksum: 0x4C29DE8
	Offset: 0x83E8
	Size: 0x199
	Parameters: 2
	Flags: None
*/
function clear_player_staff(var_382bb75, e_owner)
{
	s_staff = get_staff_info_from_weapon_name(var_382bb75);
	if(isdefined(e_owner) && isdefined(s_staff.e_owner) && e_owner != s_staff.e_owner)
	{
		return;
	}
	if(!isdefined(e_owner))
	{
		e_owner = s_staff.e_owner;
	}
	if(isdefined(e_owner))
	{
		if(level clientfield::get(s_staff.element + "_staff.holder") == e_owner.characterindex + 1)
		{
			n_player = e_owner GetEntityNumber() + 1;
			e_owner.staff_enum = 0;
			level clientfield::set(s_staff.element + "_staff.holder", 0);
			e_owner zm_tomb_utility::update_staff_accessories(0);
		}
	}
	/#
		IPrintLnBold("Dev Block strings are not supported" + s_staff.enum);
	#/
	s_staff.e_owner = undefined;
}

/*
	Name: hide_staff_model
	Namespace: zm_tomb_craftables
	Checksum: 0x27C53E80
	Offset: 0x8590
	Size: 0xB1
	Parameters: 0
	Flags: None
*/
function hide_staff_model()
{
	staffs = GetEntArray("craftable_staff_model", "script_noteworthy");
	foreach(stave in staffs)
	{
		stave ghost();
	}
}

