#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_bouncingbetty;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_octobomb;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_genesis_apothican;
#using scripts\zm\zm_genesis_ee_quest;
#using scripts\zm\zm_genesis_portals;
#using scripts\zm\zm_genesis_sound;
#using scripts\zm\zm_genesis_util;

#namespace zm_genesis_minor_ee;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_minor_ee
	Checksum: 0xA11127F7
	Offset: 0x8B0
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_minor_ee", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_minor_ee
	Checksum: 0x2C47C832
	Offset: 0x8F8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level flag::init("old_school_activated");
	level.func_override_wallbuy_prompt = &function_bc56f047;
}

/*
	Name: __main__
	Namespace: zm_genesis_minor_ee
	Checksum: 0x35A8E12C
	Offset: 0x940
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function __main__()
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			level thread function_1d13619e();
		}
	#/
	level waittill("start_zombie_round_logic");
	if(GetDvarInt("splitscreen_playerCount") > 2)
	{
		return;
	}
	level thread lil_arnie_upgrade();
	level thread function_be8c2f38();
	level thread function_5af98f35();
	level thread function_45bc2e15();
	level thread function_92b4b156();
}

/*
	Name: function_45bc2e15
	Namespace: zm_genesis_minor_ee
	Checksum: 0xF9EA010F
	Offset: 0xA30
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_45bc2e15()
{
	level flag::init("writing_on_the_wall_complete");
}

/*
	Name: function_92b4b156
	Namespace: zm_genesis_minor_ee
	Checksum: 0x23A27E30
	Offset: 0xA60
	Size: 0x7C3
	Parameters: 0
	Flags: None
*/
function function_92b4b156()
{
	level flag::wait_till("writing_on_the_wall_complete");
	s_weap_pos = struct::get("weapon_swapper_model", "targetname");
	s_weap_pos.angles = VectorScale((0, 1, 0), 90);
	s_fx_pos = struct::get("weapon_swapper_fx", "targetname");
	v_fx_pos = s_fx_pos.origin;
	var_c59a59e1 = 0;
	var_3bb6997f = undefined;
	var_81f963f4 = spawn("trigger_radius_use", s_weap_pos.origin, 0, 100, 100);
	var_81f963f4 setHintString("");
	var_81f963f4 setcursorhint("HINT_NOICON");
	var_81f963f4 TriggerIgnoreTeam();
	var_81f963f4 UseTriggerRequireLookAt();
	exploder::exploder("fxexp_114 ");
	while(1)
	{
		switch(var_c59a59e1)
		{
			case 0:
			{
				var_81f963f4 waittill("trigger", trigPlayer);
				if(isPlayer(trigPlayer) && !trigPlayer laststand::player_is_in_laststand() && !trigPlayer.IS_DRINKING > 0)
				{
					var_3bb6997f = trigPlayer GetCurrentWeapon();
					if(!trigPlayer HasWeapon(var_3bb6997f))
					{
						continue;
					}
					b_valid_weapon = trigPlayer function_a5a542a(var_3bb6997f, var_c59a59e1);
					if(!b_valid_weapon)
					{
						continue;
					}
					/#
						IPrintLnBold("Dev Block strings are not supported");
					#/
					var_f17eaf0 = trigPlayer GetWeaponAmmoStock(var_3bb6997f);
					var_5b3694f6 = trigPlayer GetWeaponAmmoClip(var_3bb6997f);
					var_be26f631 = trigPlayer GetWeaponAmmoClip(var_3bb6997f.dualWieldWeapon);
					var_c02edaaf = trigPlayer GetBuildKitWeaponOptions(var_3bb6997f);
					n_acvi = trigPlayer GetBuildKitAttachmentCosmeticVariantIndexes(var_3bb6997f);
					trigPlayer TakeWeapon(var_3bb6997f);
					trigPlayer zm_weapons::switch_back_primary_weapon(undefined);
					var_c59a59e1 = 1;
					var_81f963f4 setHintString("");
					if(isdefined(trigPlayer.var_fb11234e) && trigPlayer.var_fb11234e == zm_weapons::get_base_weapon(var_3bb6997f))
					{
						var_3bb6997f = trigPlayer.var_fb11234e;
					}
					level.var_3bb6997f = var_3bb6997f;
					e_model = zm_utility::spawn_buildkit_weapon_model(trigPlayer, var_3bb6997f, undefined, s_weap_pos.origin, s_weap_pos.angles);
					if(var_3bb6997f.isDualWield)
					{
						var_1166f70b = var_3bb6997f;
						if(isdefined(var_3bb6997f.dualWieldWeapon) && var_3bb6997f.dualWieldWeapon != level.weaponNone)
						{
							var_1166f70b = var_3bb6997f.dualWieldWeapon;
						}
						var_624e83a3 = zm_utility::spawn_buildkit_weapon_model(trigPlayer, var_1166f70b, undefined, s_weap_pos.origin - VectorScale((1, 1, 1), 3), s_weap_pos.angles);
					}
				}
				break;
			}
			case 1:
			{
				e_model RotateRoll(360, 1);
				if(isdefined(var_624e83a3))
				{
					var_624e83a3 RotateRoll(360, 1);
				}
				wait(1);
				var_c59a59e1 = 2;
				var_81f963f4 setHintString("");
				break;
			}
			case 2:
			{
				var_81f963f4 waittill("trigger", trigPlayer);
				if(isPlayer(trigPlayer) && !trigPlayer laststand::player_is_in_laststand() && !trigPlayer.IS_DRINKING > 0)
				{
					b_valid_weapon = trigPlayer function_a5a542a(var_3bb6997f, var_c59a59e1);
					if(!b_valid_weapon)
					{
						continue;
					}
					/#
						IPrintLnBold("Dev Block strings are not supported");
					#/
					weapon_limit = zm_utility::get_player_weapon_limit(trigPlayer);
					trigPlayer zm_weapons::weapon_give(var_3bb6997f);
					trigPlayer SetWeaponAmmoStock(var_3bb6997f, var_f17eaf0);
					trigPlayer SetWeaponAmmoClip(var_3bb6997f, var_5b3694f6);
					trigPlayer SetWeaponAmmoClip(var_3bb6997f.dualWieldWeapon, var_be26f631);
					level.var_3bb6997f = undefined;
					var_c59a59e1 = 3;
					var_81f963f4 setHintString("");
					e_model delete();
					if(isdefined(var_624e83a3))
					{
						var_624e83a3 delete();
					}
				}
				break;
			}
			case 3:
			{
				wait(1);
				var_c59a59e1 = 0;
				var_81f963f4 setHintString("");
				break;
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_a5a542a
	Namespace: zm_genesis_minor_ee
	Checksum: 0x22C6A9F2
	Offset: 0x1230
	Size: 0x11D
	Parameters: 2
	Flags: None
*/
function function_a5a542a(var_3bb6997f, var_c59a59e1)
{
	if(self bgb::is_enabled("zm_bgb_disorderly_combat"))
	{
		return 0;
	}
	if(zm_utility::is_hero_weapon(var_3bb6997f))
	{
		return 0;
	}
	if(zm_equipment::is_equipment(var_3bb6997f))
	{
		return 0;
	}
	if(zm_utility::is_placeable_mine(var_3bb6997f))
	{
		return 0;
	}
	if(self zm_utility::has_powerup_weapon())
	{
		return 0;
	}
	var_26e1938e = self GetWeaponsListPrimaries();
	if(var_c59a59e1 == 0 && var_26e1938e.size < 2)
	{
		return 0;
	}
	if(var_c59a59e1 == 2 && self zm_weapons::has_weapon_or_upgrade(var_3bb6997f))
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_5af98f35
	Namespace: zm_genesis_minor_ee
	Checksum: 0xA01B2E30
	Offset: 0x1358
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_5af98f35()
{
	var_38d3be2e = GetEnt("smg_thompson_wallbuy_chalk", "targetname");
	var_38d3be2e Hide();
	level chalk_pickup();
	level thread function_ff9395ca();
}

/*
	Name: function_e1963311
	Namespace: zm_genesis_minor_ee
	Checksum: 0x2D353F26
	Offset: 0x13D8
	Size: 0xC9
	Parameters: 0
	Flags: None
*/
function function_e1963311()
{
	/#
		mdl_chalk = GetEnt("Dev Block strings are not supported", "Dev Block strings are not supported");
		if(!isdefined(mdl_chalk))
		{
			return;
		}
		mdl_chalk delete();
		iprintln("Dev Block strings are not supported");
		e_who = GetPlayers()[0];
		e_who.b_has_chalk = 1;
		level.var_6d7c54f9 = "Dev Block strings are not supported";
		level notify("hash_94556ac9");
	#/
}

/*
	Name: chalk_pickup
	Namespace: zm_genesis_minor_ee
	Checksum: 0xCCF2985E
	Offset: 0x14B0
	Size: 0x13D
	Parameters: 0
	Flags: None
*/
function chalk_pickup()
{
	level endon("hash_94556ac9");
	s_chalk_pickup = struct::get("chalk_pickup", "targetname");
	s_chalk_pickup zm_unitrigger::create_unitrigger(undefined, 128);
	s_chalk_pickup waittill("trigger_activated", e_who);
	e_who playsound("zmb_minor_writing_chalk_pickup");
	mdl_chalk = GetEnt("chalk_model", "targetname");
	mdl_chalk ghost();
	/#
		iprintln("Dev Block strings are not supported");
	#/
	e_who.b_has_chalk = 1;
	e_who thread function_7367d2c6();
	if(!isdefined(level.var_6d7c54f9))
	{
		level.var_6d7c54f9 = "tag_origin";
	}
	level notify("hash_94556ac9");
}

/*
	Name: function_7367d2c6
	Namespace: zm_genesis_minor_ee
	Checksum: 0xC51594BD
	Offset: 0x15F8
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_7367d2c6()
{
	level endon("writing_on_the_wall_complete");
	self waittill("disconnect");
	mdl_chalk = GetEnt("chalk_model", "targetname");
	mdl_chalk show();
	level thread chalk_pickup();
}

/*
	Name: function_ff9395ca
	Namespace: zm_genesis_minor_ee
	Checksum: 0x50106055
	Offset: 0x1678
	Size: 0x111
	Parameters: 0
	Flags: None
*/
function function_ff9395ca()
{
	level.a_mdl_writing = [];
	a_s_writing_triggers = struct::get_array("writing_trigger", "targetname");
	foreach(s_writing_trigger in a_s_writing_triggers)
	{
		mdl_writing = GetEnt(s_writing_trigger.target, "targetname");
		Array::add(level.a_mdl_writing, mdl_writing);
		s_writing_trigger thread function_a8fc7a77();
	}
}

/*
	Name: function_a8fc7a77
	Namespace: zm_genesis_minor_ee
	Checksum: 0x9BAE78F8
	Offset: 0x1798
	Size: 0x14F
	Parameters: 0
	Flags: None
*/
function function_a8fc7a77()
{
	level endon("writing_on_the_wall_complete");
	self zm_unitrigger::create_unitrigger(undefined, 128);
	mdl_writing = GetEnt(self.target, "targetname");
	while(1)
	{
		self waittill("trigger_activated", e_player);
		if(isdefined(e_player.b_has_chalk) && e_player.b_has_chalk)
		{
			var_5d3ba118 = level.var_6d7c54f9;
			if(level.var_6d7c54f9 == "tag_origin")
			{
				e_player playsound("zmb_minor_writing_erase");
			}
			else
			{
				e_player playsound("zmb_minor_writing_write");
			}
			level.var_6d7c54f9 = mdl_writing.model;
			mdl_writing SetModel(var_5d3ba118);
			level thread function_d0f8a867();
		}
	}
}

/*
	Name: function_d0f8a867
	Namespace: zm_genesis_minor_ee
	Checksum: 0xC1F232A2
	Offset: 0x18F0
	Size: 0x243
	Parameters: 0
	Flags: None
*/
function function_d0f8a867()
{
	b_complete = 1;
	foreach(mdl_writing in level.a_mdl_writing)
	{
		switch(mdl_writing.targetname)
		{
			case "verruckt_writing":
			{
				if(mdl_writing.model != "p7_zm_gen_writing_ver_wishing")
				{
					b_complete = 0;
				}
				break;
			}
			case "ndu_writing_1":
			{
				if(mdl_writing.model != "p7_zm_gen_writing_nac_salvation")
				{
					b_complete = 0;
				}
				break;
			}
			case "ndu_writing_2":
			{
				if(mdl_writing.model != "p7_zm_gen_writing_nac_ascend")
				{
					b_complete = 0;
				}
				break;
			}
			case "undercroft_writing":
			{
				if(mdl_writing.model != "tag_origin")
				{
					b_complete = 0;
				}
				break;
			}
			case "prison_writing":
			{
				if(mdl_writing.model != "p7_zm_gen_writing_mob_soul_alone")
				{
					b_complete = 0;
				}
				break;
			}
			case "theatre_writing":
			{
				if(mdl_writing.model != "p7_zm_gen_writing_kin_scrawl_know")
				{
					b_complete = 0;
				}
				break;
			}
		}
	}
	if(b_complete)
	{
		playsoundatposition("zmb_minor_complete", (0, 0, 0));
		level flag::set("writing_on_the_wall_complete");
		var_38d3be2e = GetEnt("smg_thompson_wallbuy_chalk", "targetname");
		var_38d3be2e show();
	}
}

/*
	Name: function_bc56f047
	Namespace: zm_genesis_minor_ee
	Checksum: 0xB3DEC32
	Offset: 0x1B40
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function function_bc56f047(e_player)
{
	if(self.weapon.name == "smg_thompson")
	{
		if(level flag::get("writing_on_the_wall_complete"))
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
	Name: lil_arnie_upgrade
	Namespace: zm_genesis_minor_ee
	Checksum: 0x855B2FD
	Offset: 0x1C10
	Size: 0x207
	Parameters: 0
	Flags: None
*/
function lil_arnie_upgrade()
{
	level.var_f11300cd = 0;
	level flag::init("lil_arnie_prereq_done");
	level flag::init("lil_arnie_done");
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			level.var_f11300cd = 99;
		}
	#/
	zm_spawner::register_zombie_death_event_callback(&function_4a0f0038);
	level flag::wait_till("lil_arnie_prereq_done");
	zm_spawner::deregister_zombie_death_event_callback(&function_4a0f0038);
	level.check_b_valid_poi = &zm_genesis_ee_quest::function_5516baeb;
	level flag::wait_till("lil_arnie_done");
	foreach(player in level.activePlayers)
	{
		if(player HasWeapon(level.w_octobomb))
		{
			player _zm_weap_octobomb::player_give_octobomb("octobomb_upgraded");
		}
	}
	level.zombie_weapons[level.w_octobomb].is_in_box = 0;
	level.zombie_weapons[level.w_octobomb_upgraded].is_in_box = 1;
}

/*
	Name: function_4a0f0038
	Namespace: zm_genesis_minor_ee
	Checksum: 0x2EBF350C
	Offset: 0x1E20
	Size: 0x75
	Parameters: 3
	Flags: None
*/
function function_4a0f0038(e_attacker, str_means_of_death, weapon)
{
	if(self.damageWeapon === level.w_octobomb)
	{
		level.var_f11300cd++;
		if(level.var_f11300cd >= 100)
		{
			level flag::set("lil_arnie_prereq_done");
		}
	}
}

/*
	Name: function_131a352c
	Namespace: zm_genesis_minor_ee
	Checksum: 0x6FEE95CB
	Offset: 0x1EA0
	Size: 0x1A9
	Parameters: 1
	Flags: None
*/
function function_131a352c(b_valid_poi)
{
	s_target = struct::get("lil_arnie_upgrade", "targetname");
	if(DistanceSquared(self.origin, s_target.origin) < 7225)
	{
		self.origin = s_target.origin;
		self.angles = self.angles + VectorScale((1, 0, 1), 90);
		self.clone_model ghost();
		self.anim_model = util::spawn_model(level.mdl_octobomb, self.origin, (0, 0, 0));
		self.anim_model LinkTo(self.clone_model);
		self.anim_model clientfield::set("octobomb_fx", 3);
		wait(0.05);
		self.anim_model clientfield::set("octobomb_fx", 1);
		self thread _zm_weap_octobomb::animate_octobomb(0);
		wait(2);
		self.anim_model thread function_bf3603f7();
		return 0;
	}
	else
	{
		return b_valid_poi;
	}
}

/*
	Name: function_bf3603f7
	Namespace: zm_genesis_minor_ee
	Checksum: 0x9E6A6B9D
	Offset: 0x2058
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_bf3603f7()
{
	wait(1);
	self zm_utility::self_delete();
	level flag::set("lil_arnie_done");
}

/*
	Name: function_be8c2f38
	Namespace: zm_genesis_minor_ee
	Checksum: 0x4B7270AF
	Offset: 0x20A0
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function function_be8c2f38()
{
	level.var_aa421b74 = [];
	level.var_557b53fd = [];
	level.var_557b53fd[1] = 25;
	level.var_557b53fd[2] = 15;
	level.var_557b53fd[3] = 12;
	level.var_557b53fd[4] = 2;
	level.var_8091d507 = 0;
	a_s_switches = struct::get_array("old_school_switch");
	Array::thread_all(a_s_switches, &function_6e14903b);
	while(level.var_8091d507 < a_s_switches.size)
	{
		wait(0.05);
	}
	level thread function_77da8ee0();
}

/*
	Name: function_6e14903b
	Namespace: zm_genesis_minor_ee
	Checksum: 0x4A3B90CF
	Offset: 0x21A0
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function function_6e14903b()
{
	level endon("old_school_activated");
	level.var_c592ecc1 = 0;
	s_unitrigger = self zm_unitrigger::create_unitrigger(&"", 64, &function_b2869a31);
	s_unitrigger.require_look_at = 1;
	s_unitrigger.b_enabled = 1;
	Array::add(level.var_aa421b74, s_unitrigger);
	while(1)
	{
		self waittill("trigger_activated", e_player);
		if(s_unitrigger.b_enabled == 1)
		{
			playsoundatposition("zmb_minor_skool_button", s_unitrigger.origin);
			if(level.var_c592ecc1 == 0)
			{
				level thread function_2d1b88ec();
				level.var_c592ecc1 = 1;
			}
			s_unitrigger.b_enabled = 0;
			level.var_8091d507++;
		}
	}
}

/*
	Name: function_b2869a31
	Namespace: zm_genesis_minor_ee
	Checksum: 0x6579764F
	Offset: 0x22F0
	Size: 0x12D
	Parameters: 1
	Flags: None
*/
function function_b2869a31(e_player)
{
	if(self.stub.b_enabled)
	{
		foreach(e_player in level.players)
		{
			self SetVisibleToPlayer(e_player);
		}
		return 1;
	}
	else
	{
		foreach(e_player in level.players)
		{
			self SetInvisibleToPlayer(e_player);
		}
		return 0;
	}
}

/*
	Name: function_2d1b88ec
	Namespace: zm_genesis_minor_ee
	Checksum: 0x815C4915
	Offset: 0x2428
	Size: 0xD1
	Parameters: 0
	Flags: None
*/
function function_2d1b88ec()
{
	level endon("hash_b442f53");
	level endon("old_school_activated");
	wait(level.var_557b53fd[level.players.size]);
	level.var_c592ecc1 = 0;
	level.var_8091d507 = 0;
	foreach(s_unitrigger in level.var_aa421b74)
	{
		s_unitrigger.b_enabled = 1;
	}
	level notify("hash_b442f53");
}

/*
	Name: function_77da8ee0
	Namespace: zm_genesis_minor_ee
	Checksum: 0xB1EFB21
	Offset: 0x2508
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function function_77da8ee0()
{
	level flag::set("old_school_activated");
	playsoundatposition("zmb_minor_skool_complete", (0, 0, 0));
	foreach(s_unitrigger in level.var_aa421b74)
	{
		s_unitrigger.b_enabled = 0;
	}
	level thread zm_genesis_sound::function_b18c11d8();
}

/*
	Name: function_a1f4f500
	Namespace: zm_genesis_minor_ee
	Checksum: 0xCDFCE9A0
	Offset: 0x25F0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_a1f4f500()
{
	level._bouncingBettyWatchForTrigger = &function_82df6cd4;
	level thread function_f227a0ab();
}

/*
	Name: function_f227a0ab
	Namespace: zm_genesis_minor_ee
	Checksum: 0x99EC1590
	Offset: 0x2630
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_f227a0ab()
{
}

/*
	Name: function_c1ccaae0
	Namespace: zm_genesis_minor_ee
	Checksum: 0xA19B757A
	Offset: 0x2640
	Size: 0x193
	Parameters: 0
	Flags: None
*/
function function_c1ccaae0()
{
	mdl_asteroid = GetEnt("gateworm_asteroid", "targetname");
	mdl_egg = util::spawn_model("gateworm", mdl_asteroid.origin);
	mdl_asteroid delete();
	var_2b641c49 = struct::get("egg_destination", "targetname");
	mdl_egg moveto(var_2b641c49.origin, 3);
	mdl_egg waittill("movedone");
	var_6d268157 = var_2b641c49 zm_unitrigger::create_unitrigger(undefined, 64);
	while(1)
	{
		var_2b641c49 waittill("trigger_activated", e_who);
		if(!e_who flag::get("holding_egg"))
		{
			break;
		}
	}
	e_who.var_7f70ccd5 = 1;
	zm_unitrigger::unregister_unitrigger(var_6d268157);
	mdl_egg delete();
	level thread activate_pot();
}

/*
	Name: activate_pot
	Namespace: zm_genesis_minor_ee
	Checksum: 0xC15CB84B
	Offset: 0x27E0
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function activate_pot()
{
	var_9c1e0e1a = struct::get("pot_trigger", "targetname");
	var_a0069a05 = var_9c1e0e1a zm_unitrigger::create_unitrigger(undefined, 64);
	while(1)
	{
		var_9c1e0e1a waittill("trigger_activated", e_who);
		if(isdefined(e_who.var_7f70ccd5) && e_who.var_7f70ccd5)
		{
			break;
		}
	}
	var_ed0817e0 = struct::get("egg_pot_location", "targetname");
	mdl_egg = util::spawn_model("gateworm", var_ed0817e0.origin);
	level waittill("start_of_round");
	level waittill("start_of_round");
	level waittill("start_of_round");
	while(1)
	{
		var_9c1e0e1a waittill("trigger_activated", e_who);
		if(isdefined(e_who.var_7f70ccd5) && e_who.var_7f70ccd5)
		{
			break;
		}
	}
	zm_unitrigger::unregister_unitrigger(var_a0069a05);
	level thread activate_ovary();
}

/*
	Name: activate_ovary
	Namespace: zm_genesis_minor_ee
	Checksum: 0x99EC1590
	Offset: 0x2988
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function activate_ovary()
{
}

/*
	Name: function_82df6cd4
	Namespace: zm_genesis_minor_ee
	Checksum: 0x7C5BB7A2
	Offset: 0x2998
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function function_82df6cd4(watcher)
{
	self endon("death");
	self endon("hacked");
	self endon("kill_target_detection");
	e_trigger = GetEnt("gateworm_meteor_trigger", "targetname");
	while(1)
	{
		if(self istouching(e_trigger))
		{
			break;
		}
		wait(0.05);
	}
	level thread function_c1ccaae0();
}

/*
	Name: function_1d13619e
	Namespace: zm_genesis_minor_ee
	Checksum: 0x6ADDE37A
	Offset: 0x2A48
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function function_1d13619e()
{
	/#
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_6cd2074);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_7c5650a5);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_c3100cb0);
		level thread zm_genesis_util::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_e1963311);
	#/
}

/*
	Name: function_7c5650a5
	Namespace: zm_genesis_minor_ee
	Checksum: 0x11782362
	Offset: 0x2B40
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_7c5650a5(n_val)
{
	/#
		level flag::set("Dev Block strings are not supported");
	#/
}

/*
	Name: function_6cd2074
	Namespace: zm_genesis_minor_ee
	Checksum: 0xF6CE8395
	Offset: 0x2B78
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function function_6cd2074(n_val)
{
	/#
		level thread function_77da8ee0();
	#/
}

/*
	Name: function_c3100cb0
	Namespace: zm_genesis_minor_ee
	Checksum: 0x696291AE
	Offset: 0x2BA8
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_c3100cb0(n_val)
{
	/#
		level flag::set("Dev Block strings are not supported");
	#/
}

