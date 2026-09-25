#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#namespace namespace_cfbe948b;

/*
	Name: init
	Namespace: namespace_cfbe948b
	Checksum: 0xAAB992C7
	Offset: 0x388
	Size: 0x1E3
	Parameters: 0
	Flags: None
*/
function init()
{
	RegisterClientField("zbarrier", "magicbox_initial_fx", 1, 1, "int");
	RegisterClientField("zbarrier", "magicbox_amb_sound", 1, 1, "int");
	RegisterClientField("zbarrier", "magicbox_open_fx", 1, 2, "int");
	level._effect["box_light_marker"] = "zombie/fx_weapon_box_marker_zod_zmb";
	level._effect["box_light_flare"] = "zombie/fx_weapon_box_marker_fl_zod_zmb";
	level._effect["poltergeist"] = "tools/fx_null";
	level.chest_joker_model = "p7_zm_zod_magic_box_tentacle_teddy";
	level.chest_joker_custom_movement = &custom_joker_movement;
	level.custom_magic_box_timer_til_despawn = &custom_magic_box_timer_til_despawn;
	level.custom_magic_box_do_weapon_rise = &custom_magic_box_do_weapon_rise;
	level.custom_magic_box_weapon_wait = &custom_magic_box_weapon_wait;
	level.custom_pandora_show_func = &custom_pandora_show_func;
	level.custom_treasure_chest_glowfx = &custom_magic_box_fx;
	level.custom_firesale_box_leave = 1;
	level.custom_magicbox_float_height = 40;
	level.magic_box_zbarrier_state_func = &set_magic_box_zbarrier_state;
	level thread handle_fire_sale();
	level thread function_cb604665();
}

/*
	Name: custom_joker_movement
	Namespace: namespace_cfbe948b
	Checksum: 0x8BCAF695
	Offset: 0x578
	Size: 0x21D
	Parameters: 0
	Flags: None
*/
function custom_joker_movement()
{
	v_origin = self.weapon_model.origin - VectorScale((0, 0, 1), 5);
	self.weapon_model delete();
	m_lock = spawn("script_model", v_origin);
	m_lock SetModel(level.chest_joker_model);
	m_lock.angles = self.angles + VectorScale((0, 1, 0), 180);
	m_lock playsound("zmb_hellbox_bear");
	wait(0.5);
	level notify("weapon_fly_away_start");
	wait(1);
	m_lock RotateYaw(3000, 4.5, 4.5);
	wait(3);
	v_angles = AnglesToForward(self.angles - VectorScale((1, 1, 0), 90));
	m_lock moveto(m_lock.origin + 35 * v_angles, 1.5, 1);
	m_lock waittill("movedone");
	m_lock moveto(m_lock.origin + -100 * v_angles, 0.5, 0.5);
	m_lock waittill("movedone");
	m_lock delete();
	self notify("box_moving");
	level notify("weapon_fly_away_end");
}

/*
	Name: custom_magic_box_timer_til_despawn
	Namespace: namespace_cfbe948b
	Checksum: 0xF04AD887
	Offset: 0x7A0
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function custom_magic_box_timer_til_despawn(magic_box)
{
	self endon("kill_weapon_movement");
	putBackTime = 12;
	v_float = anglesToUp(self.angles) * level.custom_magicbox_float_height;
	self moveto(self.origin - v_float * 0.4, putBackTime, putBackTime * 0.5);
	wait(putBackTime);
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: custom_magic_box_fx
	Namespace: namespace_cfbe948b
	Checksum: 0x99EC1590
	Offset: 0x860
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function custom_magic_box_fx()
{
}

/*
	Name: function_49998a6e
	Namespace: namespace_cfbe948b
	Checksum: 0xDEFABCEE
	Offset: 0x870
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function function_49998a6e()
{
	self endon("death");
	self.pandora_light = util::spawn_model("tag_origin", self.zbarrier.origin, VectorScale((-1, 0, -1), 90));
	if(!(isdefined(level._box_initialized) && level._box_initialized))
	{
		level flag::wait_till("start_zombie_round_logic");
		level._box_initialized = 1;
	}
	wait(1);
	if(isdefined(self.pandora_light))
	{
		PlayFXOnTag(level._effect["box_light_marker"], self.pandora_light, "tag_origin");
	}
}

/*
	Name: custom_pandora_show_func
	Namespace: namespace_cfbe948b
	Checksum: 0x28A88F8D
	Offset: 0x950
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function custom_pandora_show_func()
{
	if(!isdefined(self.pandora_light))
	{
		if(!isdefined(level.pandora_fx_func))
		{
			level.pandora_fx_func = &function_49998a6e;
		}
		self thread [[level.pandora_fx_func]]();
	}
	playFX(level._effect["box_light_flare"], self.pandora_light.origin);
}

/*
	Name: custom_magic_box_weapon_wait
	Namespace: namespace_cfbe948b
	Checksum: 0xAE86640A
	Offset: 0x9D8
	Size: 0xB
	Parameters: 0
	Flags: None
*/
function custom_magic_box_weapon_wait()
{
	wait(0.5);
}

/*
	Name: set_magic_box_zbarrier_state
	Namespace: namespace_cfbe948b
	Checksum: 0xDEA8FC07
	Offset: 0x9F0
	Size: 0x2BD
	Parameters: 1
	Flags: None
*/
function set_magic_box_zbarrier_state(State)
{
	for(i = 0; i < self GetNumZBarrierPieces(); i++)
	{
		self HideZBarrierPiece(i);
	}
	self notify("zbarrier_state_change");
	switch(State)
	{
		case "away":
		{
			self ShowZBarrierPiece(0);
			self.State = "away";
			self.owner.is_locked = 0;
			break;
		}
		case "arriving":
		{
			self ShowZBarrierPiece(1);
			self thread magic_box_arrives();
			self.State = "arriving";
			break;
		}
		case "initial":
		{
			self ShowZBarrierPiece(1);
			self thread magic_box_initial();
			self thread zm_unitrigger::register_static_unitrigger(self.owner.unitrigger_stub, &zm_magicbox::magicbox_unitrigger_think);
			self.State = "close";
			break;
		}
		case "open":
		{
			self ShowZBarrierPiece(2);
			self thread magic_box_opens();
			self.State = "open";
			break;
		}
		case "close":
		{
			self ShowZBarrierPiece(2);
			self thread magic_box_closes();
			self.State = "close";
			break;
		}
		case "leaving":
		{
			self ShowZBarrierPiece(1);
			self thread magic_box_leaves();
			self.State = "leaving";
			self.owner.is_locked = 0;
			break;
		}
		case default:
		{
			if(isdefined(level.custom_magicbox_state_handler))
			{
				self [[level.custom_magicbox_state_handler]](State);
			}
			break;
		}
	}
}

/*
	Name: magic_box_initial
	Namespace: namespace_cfbe948b
	Checksum: 0x8A3BD00B
	Offset: 0xCB8
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function magic_box_initial()
{
	level flag::wait_till("all_players_spawned");
	level flag::wait_till("zones_initialized");
	self SetZBarrierPieceState(1, "open");
	self clientfield::set("magicbox_amb_sound", 1);
	self clientfield::set("magicbox_open_fx", 3);
}

/*
	Name: magic_box_arrives
	Namespace: namespace_cfbe948b
	Checksum: 0x54C4425F
	Offset: 0xD68
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function magic_box_arrives()
{
	self SetZBarrierPieceState(1, "opening");
	while(self GetZBarrierPieceState(1) == "opening")
	{
		wait(0.05);
	}
	self notify("arrived");
	self.State = "close";
	self clientfield::set("magicbox_amb_sound", 1);
}

/*
	Name: magic_box_leaves
	Namespace: namespace_cfbe948b
	Checksum: 0x9BE0226
	Offset: 0xE08
	Size: 0x107
	Parameters: 0
	Flags: None
*/
function magic_box_leaves()
{
	self clientfield::set("magicbox_open_fx", 0);
	self SetZBarrierPieceState(1, "closing");
	self playsound("zmb_hellbox_rise");
	while(self GetZBarrierPieceState(1) == "closing")
	{
		wait(0.1);
	}
	self notify("left");
	self clientfield::set("magicbox_open_fx", 2);
	self clientfield::set("magicbox_amb_sound", 0);
	if(!(isdefined(level.dig_magic_box_moved) && level.dig_magic_box_moved))
	{
		level.dig_magic_box_moved = 1;
	}
}

/*
	Name: magic_box_opens
	Namespace: namespace_cfbe948b
	Checksum: 0x8B755A64
	Offset: 0xF18
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function magic_box_opens()
{
	self clientfield::set("magicbox_open_fx", 1);
	self SetZBarrierPieceState(2, "opening");
	self playsound("zmb_hellbox_open");
	while(self GetZBarrierPieceState(2) == "opening")
	{
		wait(0.1);
	}
	self notify("opened");
	self thread magic_box_open_idle();
}

/*
	Name: magic_box_open_idle
	Namespace: namespace_cfbe948b
	Checksum: 0x12FF0C22
	Offset: 0xFD8
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function magic_box_open_idle()
{
	self endon("stop_open_idle");
	self HideZBarrierPiece(2);
	self ShowZBarrierPiece(5);
	while(1)
	{
		self SetZBarrierPieceState(5, "opening");
		while(self GetZBarrierPieceState(5) != "open")
		{
			wait(0.05);
		}
	}
}

/*
	Name: magic_box_closes
	Namespace: namespace_cfbe948b
	Checksum: 0x487BE1E4
	Offset: 0x1078
	Size: 0xE1
	Parameters: 0
	Flags: None
*/
function magic_box_closes()
{
	self notify("stop_open_idle");
	self HideZBarrierPiece(5);
	self ShowZBarrierPiece(2);
	self SetZBarrierPieceState(2, "closing");
	self playsound("zmb_hellbox_close");
	self clientfield::set("magicbox_open_fx", 0);
	while(self GetZBarrierPieceState(2) == "closing")
	{
		wait(0.1);
	}
	self notify("closed");
}

/*
	Name: custom_magic_box_do_weapon_rise
	Namespace: namespace_cfbe948b
	Checksum: 0x987F720
	Offset: 0x1168
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function custom_magic_box_do_weapon_rise()
{
	self endon("box_hacked_respin");
	wait(0.5);
	self SetZBarrierPieceState(3, "closed");
	self SetZBarrierPieceState(4, "closed");
	util::wait_network_frame();
	self ZBarrierPieceUseBoxRiseLogic(3);
	self ZBarrierPieceUseBoxRiseLogic(4);
	self ShowZBarrierPiece(3);
	self ShowZBarrierPiece(4);
	self SetZBarrierPieceState(3, "opening");
	self SetZBarrierPieceState(4, "opening");
	while(self GetZBarrierPieceState(3) != "open")
	{
		wait(0.5);
	}
	self HideZBarrierPiece(3);
	self HideZBarrierPiece(4);
}

/*
	Name: handle_fire_sale
	Namespace: namespace_cfbe948b
	Checksum: 0x9FCA92F8
	Offset: 0x12E0
	Size: 0x189
	Parameters: 0
	Flags: None
*/
function handle_fire_sale()
{
	while(1)
	{
		var_7c8b59c1 = level util::waittill_any_return("fire_sale_off", "fire_sale_on");
		for(i = 0; i < level.chests.size; i++)
		{
			if(level.chest_index != i && isdefined(level.chests[i].was_temp))
			{
				if(var_7c8b59c1 == "fire_sale_on")
				{
					level.chests[i].zbarrier clientfield::set("magicbox_amb_sound", 1);
					level.chests[i].zbarrier clientfield::set("magicbox_open_fx", 3);
					continue;
				}
				level.chests[i].zbarrier clientfield::set("magicbox_amb_sound", 0);
				level.chests[i].zbarrier clientfield::set("magicbox_open_fx", 2);
			}
		}
	}
}

/*
	Name: function_cb604665
	Namespace: namespace_cfbe948b
	Checksum: 0x925F6A23
	Offset: 0x1478
	Size: 0x14D
	Parameters: 0
	Flags: None
*/
function function_cb604665()
{
	level endon("end_game");
	level notify("mb_hostmigration");
	level endon("mb_hostmigration");
	while(1)
	{
		level waittill("host_migration_end");
		if(!isdefined(level.chests))
		{
			continue;
		}
		foreach(Chest in level.chests)
		{
			if(!(isdefined(Chest.hidden) && Chest.hidden))
			{
				if(isdefined(Chest) && isdefined(Chest.pandora_light))
				{
					PlayFXOnTag(level._effect["box_light_marker"], Chest.pandora_light, "tag_origin");
				}
			}
			util::wait_network_frame();
		}
	}
}

