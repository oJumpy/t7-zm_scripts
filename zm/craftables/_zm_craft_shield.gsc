#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_powerup_shield_charge;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_riotshield;
#using scripts\zm\craftables\_zm_craftables;

#namespace zm_craft_shield;

/*
	Name: __init__sytem__
	Namespace: zm_craft_shield
	Checksum: 0xBCDFEAD9
	Offset: 0x438
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_craft_shield", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_craft_shield
	Checksum: 0x99EC1590
	Offset: 0x480
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

/*
	Name: init
	Namespace: zm_craft_shield
	Checksum: 0xD1DE82A4
	Offset: 0x490
	Size: 0x47B
	Parameters: 6
	Flags: None
*/
function init(shield_equipment, shield_weapon, shield_model, str_to_craft, str_taken, str_grab)
{
	if(!isdefined(str_to_craft))
	{
		str_to_craft = &"ZOMBIE_CRAFT_RIOT";
	}
	if(!isdefined(str_taken))
	{
		str_taken = &"ZOMBIE_BOUGHT_RIOT";
	}
	if(!isdefined(str_grab))
	{
		str_grab = &"ZOMBIE_GRAB_RIOTSHIELD";
	}
	level.craftable_shield_equipment = shield_equipment;
	level.craftable_shield_weapon = shield_weapon;
	level.craftable_shield_model = shield_model;
	level.craftable_shield_grab = str_grab;
	level.riotshield_supports_deploy = 0;
	riotShield_dolly = zm_craftables::generate_zombie_craftable_piece(level.craftable_shield_equipment, "dolly", 32, 64, 0, undefined, &on_pickup_common, &on_drop_common, undefined, undefined, undefined, undefined, "piece_riotshield_dolly", 1, "build_zs");
	riotShield_door = zm_craftables::generate_zombie_craftable_piece(level.craftable_shield_equipment, "door", 48, 15, 25, undefined, &on_pickup_common, &on_drop_common, undefined, undefined, undefined, undefined, "piece_riotshield_door", 1, "build_zs");
	riotShield_clamp = zm_craftables::generate_zombie_craftable_piece(level.craftable_shield_equipment, "clamp", 48, 15, 25, undefined, &on_pickup_common, &on_drop_common, undefined, undefined, undefined, undefined, "piece_riotshield_clamp", 1, "build_zs");
	RegisterClientField("world", "piece_riotshield_dolly", 1, 1, "int", undefined, 0);
	RegisterClientField("world", "piece_riotshield_door", 1, 1, "int", undefined, 0);
	RegisterClientField("world", "piece_riotshield_clamp", 1, 1, "int", undefined, 0);
	clientfield::register("toplayer", "ZMUI_SHIELD_PART_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZMUI_SHIELD_CRAFTED", 1, 1, "int");
	riotshield = spawnstruct();
	riotshield.name = level.craftable_shield_equipment;
	riotshield.weaponName = level.craftable_shield_weapon;
	riotshield zm_craftables::add_craftable_piece(riotShield_dolly);
	riotshield zm_craftables::add_craftable_piece(riotShield_door);
	riotshield zm_craftables::add_craftable_piece(riotShield_clamp);
	riotshield.onBuyWeapon = &on_buy_weapon_riotshield;
	riotshield.triggerThink = &riotshield_craftable;
	zm_craftables::include_zombie_craftable(riotshield);
	zm_craftables::add_zombie_craftable(level.craftable_shield_equipment, str_to_craft, "ERROR", str_taken, &on_fully_crafted, 1);
	zm_craftables::add_zombie_craftable_vox_category(level.craftable_shield_equipment, "build_zs");
	zm_craftables::make_zombie_craftable_open(level.craftable_shield_equipment, level.craftable_shield_model, VectorScale((0, -1, 0), 90), VectorScale((0, 0, 1), 26));
}

/*
	Name: __main__
	Namespace: zm_craft_shield
	Checksum: 0xF6E2A1B7
	Offset: 0x918
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function __main__()
{
	/#
		function_f3127c4f();
	#/
}

/*
	Name: riotshield_craftable
	Namespace: zm_craft_shield
	Checksum: 0x36DDED58
	Offset: 0x940
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function riotshield_craftable()
{
	zm_craftables::craftable_trigger_think("riotshield_zm_craftable_trigger", level.craftable_shield_equipment, level.craftable_shield_weapon, level.craftable_shield_grab, 1, 1);
}

/*
	Name: show_infotext_for_duration
	Namespace: zm_craft_shield
	Checksum: 0xAD949706
	Offset: 0x988
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function show_infotext_for_duration(str_infotext, n_duration)
{
	self clientfield::set_to_player(str_infotext, 1);
	wait(n_duration);
	self clientfield::set_to_player(str_infotext, 0);
}

/*
	Name: on_pickup_common
	Namespace: zm_craft_shield
	Checksum: 0xB9CAAEF0
	Offset: 0x9E8
	Size: 0x147
	Parameters: 1
	Flags: None
*/
function on_pickup_common(player)
{
	/#
		println("Dev Block strings are not supported");
	#/
	player playsound("zmb_craftable_pickup");
	if(isdefined(level.craft_shield_piece_pickup_vo_override))
	{
		player thread [[level.craft_shield_piece_pickup_vo_override]]();
	}
	foreach(e_player in level.players)
	{
		e_player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.player_crafted_shield", "zmInventory.widget_shield_parts", 0);
		e_player thread show_infotext_for_duration("ZMUI_SHIELD_PART_PICKUP", 3.5);
	}
	self pickup_from_mover();
	self.piece_owner = player;
}

/*
	Name: on_drop_common
	Namespace: zm_craft_shield
	Checksum: 0x557AB9C5
	Offset: 0xB38
	Size: 0x4D
	Parameters: 1
	Flags: None
*/
function on_drop_common(player)
{
	/#
		println("Dev Block strings are not supported");
	#/
	self drop_on_mover(player);
	self.piece_owner = undefined;
}

/*
	Name: pickup_from_mover
	Namespace: zm_craft_shield
	Checksum: 0xE41D3E73
	Offset: 0xB90
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function pickup_from_mover()
{
	if(isdefined(level.craft_shield_pickup_override))
	{
		[[level.craft_shield_pickup_override]]();
	}
}

/*
	Name: on_fully_crafted
	Namespace: zm_craft_shield
	Checksum: 0x6B2C9E53
	Offset: 0xBB8
	Size: 0xED
	Parameters: 0
	Flags: None
*/
function on_fully_crafted()
{
	players = level.players;
	foreach(e_player in players)
	{
		if(zm_utility::is_player_valid(e_player))
		{
			e_player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.player_crafted_shield", "zmInventory.widget_shield_parts", 1);
			e_player thread show_infotext_for_duration("ZMUI_SHIELD_CRAFTED", 3.5);
		}
	}
	return 1;
}

/*
	Name: drop_on_mover
	Namespace: zm_craft_shield
	Checksum: 0x67DA6688
	Offset: 0xCB0
	Size: 0x27
	Parameters: 1
	Flags: None
*/
function drop_on_mover(player)
{
	if(isdefined(level.craft_shield_drop_override))
	{
		[[level.craft_shield_drop_override]]();
	}
}

/*
	Name: on_buy_weapon_riotshield
	Namespace: zm_craft_shield
	Checksum: 0xAA9DCEBC
	Offset: 0xCE0
	Size: 0x95
	Parameters: 1
	Flags: None
*/
function on_buy_weapon_riotshield(player)
{
	if(isdefined(player.player_shield_reset_health))
	{
		player [[player.player_shield_reset_health]]();
	}
	if(isdefined(player.player_shield_reset_location))
	{
		player [[player.player_shield_reset_location]]();
	}
	player playsound("zmb_craftable_buy_shield");
	level notify("shield_built", player);
}

/*
	Name: function_f3127c4f
	Namespace: zm_craft_shield
	Checksum: 0x4C2E5071
	Offset: 0xD80
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function function_f3127c4f()
{
	/#
		level flagsys::wait_till("Dev Block strings are not supported");
		wait(1);
		zm_devgui::function_4acecab5(&function_b6937313);
		SetDvar("Dev Block strings are not supported", 0);
		AddDebugCommand("Dev Block strings are not supported" + level.craftable_shield_equipment + "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported" + level.craftable_shield_equipment + "Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported" + level.craftable_shield_equipment + "Dev Block strings are not supported");
	#/
}

/*
	Name: function_b6937313
	Namespace: zm_craft_shield
	Checksum: 0x40B6BD33
	Offset: 0xE80
	Size: 0x1CF
	Parameters: 1
	Flags: None
*/
function function_b6937313(cmd)
{
	/#
		players = GetPlayers();
		retval = 0;
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				Array::thread_all(players, &function_2b0b208f);
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(players.size >= 1)
				{
					players[0] thread function_2b0b208f();
				}
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(players.size >= 2)
				{
					players[1] thread function_2b0b208f();
				}
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(players.size >= 3)
				{
					players[2] thread function_2b0b208f();
				}
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(players.size >= 4)
				{
					players[3] thread function_2b0b208f();
				}
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				Array::thread_all(level.players, &function_70d7908d);
				retval = 1;
				break;
			}
		}
		return retval;
	#/
}

/*
	Name: function_2449723c
	Namespace: zm_craft_shield
	Checksum: 0xF5AE50B3
	Offset: 0x1058
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function function_2449723c()
{
	/#
		if(isdefined(self.var_9dc82bca))
		{
			if(self.var_9dc82bca == GetTime())
			{
				return 1;
			}
		}
		self.var_9dc82bca = GetTime();
		return 0;
	#/
}

/*
	Name: function_2b0b208f
	Namespace: zm_craft_shield
	Checksum: 0x5CFF49E3
	Offset: 0x1098
	Size: 0x197
	Parameters: 0
	Flags: None
*/
function function_2b0b208f()
{
	/#
		if(self function_2449723c())
		{
			return;
		}
		self notify("hash_2b0b208f");
		self endon("hash_2b0b208f");
		self.var_74469a7a = !isdefined(self.var_74469a7a) && self.var_74469a7a;
		if(self.var_74469a7a)
		{
		}
		else
		{
		}
		println("Dev Block strings are not supported" + "Dev Block strings are not supported");
		if(self.var_74469a7a)
		{
		}
		else
		{
		}
		IPrintLnBold("Dev Block strings are not supported" + "Dev Block strings are not supported");
		if(self.var_74469a7a)
		{
			while(isdefined(self))
			{
				damageMax = level.weaponRiotshield.weaponstarthitpoints;
				if(isdefined(self.weaponRiotshield))
				{
					damageMax = self.weaponRiotshield.weaponstarthitpoints;
				}
				shieldHealth = damageMax;
				shieldHealth = self DamageRiotShield(0);
				self DamageRiotShield(shieldHealth - damageMax);
				wait(0.05);
			}
		}
	#/
}

/*
	Name: function_70d7908d
	Namespace: zm_craft_shield
	Checksum: 0xEF6668B6
	Offset: 0x1238
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_70d7908d()
{
	/#
		if(self function_2449723c())
		{
			return;
		}
		if(isdefined(self.hasRiotShield) && self.hasRiotShield)
		{
			self zm_equipment::change_ammo(self.weaponRiotshield, 1);
		}
	#/
}

