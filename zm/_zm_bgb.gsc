#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_bgb_machine;
#using scripts\zm\_zm_bgb_token;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\gametypes\_globallogic_score;

#namespace bgb;

/*
	Name: __init__sytem__
	Namespace: bgb
	Checksum: 0x213594A4
	Offset: 0x7C0
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("bgb", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: bgb
	Checksum: 0x37DC04E3
	Offset: 0x808
	Size: 0x1FB
	Parameters: 0
	Flags: Private
*/
function private __init__()
{
	callback::on_spawned(&on_player_spawned);
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	level.var_adfa48c4 = GetWeapon("zombie_bgb_grab");
	level.var_c92b3b33 = GetWeapon("zombie_bgb_use");
	level.bgb = [];
	clientfield::register("clientuimodel", "bgb_current", 1, 8, "int");
	clientfield::register("clientuimodel", "bgb_display", 1, 1, "int");
	clientfield::register("clientuimodel", "bgb_timer", 1, 8, "float");
	clientfield::register("clientuimodel", "bgb_activations_remaining", 1, 3, "int");
	clientfield::register("clientuimodel", "bgb_invalid_use", 1, 1, "counter");
	clientfield::register("clientuimodel", "bgb_one_shot_use", 1, 1, "counter");
	clientfield::register("toplayer", "bgb_blow_bubble", 1, 1, "counter");
	zm::register_vehicle_damage_callback(&vehicle_damage_override);
}

/*
	Name: __main__
	Namespace: bgb
	Checksum: 0x29F60E58
	Offset: 0xA10
	Size: 0x5D
	Parameters: 0
	Flags: Private
*/
function private __main__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	function_47aee2eb();
	/#
		level thread setup_devgui();
	#/
	level._effect["samantha_steal"] = "zombie/fx_monkey_lightning_zmb";
}

/*
	Name: on_player_spawned
	Namespace: bgb
	Checksum: 0x4420286E
	Offset: 0xA78
	Size: 0x5B
	Parameters: 0
	Flags: Private
*/
function private on_player_spawned()
{
	self.bgb = "none";
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	self function_52dbea8c();
	self thread function_e94a4b1b();
}

/*
	Name: function_52dbea8c
	Namespace: bgb
	Checksum: 0xFE8C66BC
	Offset: 0xAE0
	Size: 0x4F
	Parameters: 0
	Flags: Private
*/
function private function_52dbea8c()
{
	if(!(isdefined(self.var_c2d95bad) && self.var_c2d95bad))
	{
		self.var_c2d95bad = 1;
		self globallogic_score::initPersStat("bgb_tokens_gained_this_game", 0);
		self.var_f191a1fc = 0;
	}
}

/*
	Name: function_e94a4b1b
	Namespace: bgb
	Checksum: 0xA7559F80
	Offset: 0xB38
	Size: 0x1EB
	Parameters: 0
	Flags: Private
*/
function private function_e94a4b1b()
{
	if(isdefined(self.var_98ba48a2))
	{
		return;
	}
	self.var_98ba48a2 = self function_14fa98a9();
	self.var_8414308a = [];
	self.var_e610f362 = [];
	foreach(bgb in self.var_98ba48a2)
	{
		if(bgb == "weapon_null")
		{
			continue;
		}
		if(!(isdefined(level.bgb[bgb].var_e0715b48) && level.bgb[bgb].var_e0715b48))
		{
			continue;
		}
		self.var_e610f362[bgb] = spawnstruct();
		self.var_e610f362[bgb].var_e0b06b47 = self function_2ab74414(bgb);
		self.var_e610f362[bgb].var_b75c376 = 0;
	}
	self.var_85da8a33 = 0;
	self clientfield::set_to_player("zm_bgb_machine_round_buys", self.var_85da8a33);
	self function_959ccfd0();
	self thread function_94160e1d();
	self thread function_efd2e645();
}

/*
	Name: function_efd2e645
	Namespace: bgb
	Checksum: 0x9DFCA1C2
	Offset: 0xD30
	Size: 0x20B
	Parameters: 0
	Flags: Private
*/
function private function_efd2e645()
{
	self endon("disconnect");
	if(!level flag::exists("consumables_reported"))
	{
		level flag::init("consumables_reported");
	}
	self flag::init("finished_reporting_consumables");
	self waittill("report_bgb_consumption");
	self thread take();
	self function_e1f3d6d7();
	self zm_stats::set_global_stat("bgb_tokens_gained_this_game", self.var_f191a1fc);
	foreach(bgb in self.var_98ba48a2)
	{
		if(!isdefined(self.var_e610f362[bgb]) || !self.var_e610f362[bgb].var_b75c376)
		{
			continue;
		}
		level flag::set("consumables_reported");
		zm_utility::increment_zm_dash_counter("end_consumables_count", self.var_e610f362[bgb].var_b75c376);
		self function_99b36259(bgb, self.var_e610f362[bgb].var_b75c376);
	}
	self flag::set("finished_reporting_consumables");
}

/*
	Name: function_47aee2eb
	Namespace: bgb
	Checksum: 0x9290E1BB
	Offset: 0xF48
	Size: 0x2D5
	Parameters: 0
	Flags: Private
*/
function private function_47aee2eb()
{
	statsTableName = util::getStatsTableName();
	keys = getArrayKeys(level.bgb);
	for(i = 0; i < keys.size; i++)
	{
		level.bgb[keys[i]].var_e25ca181 = GetItemIndexFromRef(keys[i]);
		level.bgb[keys[i]].var_d277f374 = Int(tableLookup(statsTableName, 0, level.bgb[keys[i]].var_e25ca181, 16));
		if(0 == level.bgb[keys[i]].var_d277f374 || 4 == level.bgb[keys[i]].var_d277f374)
		{
			level.bgb[keys[i]].var_e0715b48 = 0;
		}
		else
		{
			level.bgb[keys[i]].var_e0715b48 = 1;
		}
		level.bgb[keys[i]].camo_index = Int(tableLookup(statsTableName, 0, level.bgb[keys[i]].var_e25ca181, 5));
		var_cf65a2c0 = tableLookup(statsTableName, 0, level.bgb[keys[i]].var_e25ca181, 15);
		if(IsSubStr(var_cf65a2c0, "dlc"))
		{
			level.bgb[keys[i]].var_b9af356d = Int(var_cf65a2c0[3]);
			continue;
		}
		level.bgb[keys[i]].var_b9af356d = 0;
	}
}

/*
	Name: function_94160e1d
	Namespace: bgb
	Checksum: 0xE1E0D6B1
	Offset: 0x1228
	Size: 0xD7
	Parameters: 0
	Flags: Private
*/
function private function_94160e1d()
{
	self endon("disconnect");
	while(1)
	{
		var_bc5cda7b = level util::waittill_any_return("between_round_over", "restart_round");
		if(isdefined(level.var_4824bb2d))
		{
			if(!(isdefined(self [[level.var_4824bb2d]]()) && self [[level.var_4824bb2d]]()))
			{
				continue;
			}
		}
		if(var_bc5cda7b === "restart_round")
		{
			level waittill("between_round_over");
		}
		else
		{
			self.var_85da8a33 = 0;
			self clientfield::set_to_player("zm_bgb_machine_round_buys", self.var_85da8a33);
		}
	}
}

/*
	Name: setup_devgui
	Namespace: bgb
	Checksum: 0x795C8A15
	Offset: 0x1308
	Size: 0x263
	Parameters: 0
	Flags: Private
*/
function private setup_devgui()
{
	/#
		waittillframeend;
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", -1);
		var_33b4e7c1 = "Dev Block strings are not supported";
		keys = getArrayKeys(level.bgb);
		foreach(key in keys)
		{
			AddDebugCommand(var_33b4e7c1 + key + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + key + "Dev Block strings are not supported");
		}
		AddDebugCommand(var_33b4e7c1 + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
		AddDebugCommand(var_33b4e7c1 + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
		for(i = 0; i < 4; i++)
		{
			playerNum = i + 1;
			AddDebugCommand(var_33b4e7c1 + "Dev Block strings are not supported" + playerNum + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + i + "Dev Block strings are not supported");
		}
		level thread function_70fe94ae();
	#/
}

/*
	Name: function_70fe94ae
	Namespace: bgb
	Checksum: 0x286D0311
	Offset: 0x1578
	Size: 0x7F
	Parameters: 0
	Flags: Private
*/
function private function_70fe94ae()
{
	/#
		for(;;)
		{
			var_fe9a7d67 = GetDvarString("Dev Block strings are not supported");
			if(var_fe9a7d67 != "Dev Block strings are not supported")
			{
				function_dea9a9da(var_fe9a7d67);
			}
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			wait(0.5);
		}
	#/
}

/*
	Name: function_dea9a9da
	Namespace: bgb
	Checksum: 0xAB92DEAA
	Offset: 0x1600
	Size: 0x11D
	Parameters: 1
	Flags: Private
*/
function private function_dea9a9da(var_a961d470)
{
	/#
		var_a7032a9 = GetDvarInt("Dev Block strings are not supported");
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			if(var_a7032a9 != -1 && var_a7032a9 != i)
			{
				continue;
			}
			if("Dev Block strings are not supported" == var_a961d470)
			{
				players[i] thread take();
				continue;
			}
			function_594d2bdf(1);
			players[i] thread function_b107a7f3(var_a961d470, 0);
			function_594d2bdf(0);
		}
	#/
}

/*
	Name: function_ef47b774
	Namespace: bgb
	Checksum: 0x852D87D8
	Offset: 0x1728
	Size: 0x143
	Parameters: 0
	Flags: Private
*/
function private function_ef47b774()
{
	/#
		self.var_94ee23e0 = newClientHudElem(self);
		self.var_94ee23e0.elemType = "Dev Block strings are not supported";
		self.var_94ee23e0.font = "Dev Block strings are not supported";
		self.var_94ee23e0.fontscale = 1.8;
		self.var_94ee23e0.horzAlign = "Dev Block strings are not supported";
		self.var_94ee23e0.vertAlign = "Dev Block strings are not supported";
		self.var_94ee23e0.alignX = "Dev Block strings are not supported";
		self.var_94ee23e0.alignY = "Dev Block strings are not supported";
		self.var_94ee23e0.x = 15;
		self.var_94ee23e0.y = 35;
		self.var_94ee23e0.sort = 2;
		self.var_94ee23e0.color = (1, 1, 1);
		self.var_94ee23e0.alpha = 1;
		self.var_94ee23e0.hidewheninmenu = 1;
	#/
}

/*
	Name: function_b33a98c7
	Namespace: bgb
	Checksum: 0xAF0B2D35
	Offset: 0x1878
	Size: 0x1EF
	Parameters: 2
	Flags: Private
*/
function private function_b33a98c7(name, var_2741876d)
{
	/#
		if(!isdefined(self.var_94ee23e0))
		{
			return;
		}
		if(isdefined(var_2741876d))
		{
			self clientfield::set_player_uimodel("Dev Block strings are not supported", 1);
		}
		else
		{
			self clientfield::set_player_uimodel("Dev Block strings are not supported", 0);
		}
		self notify("hash_ad571a66");
		self endon("hash_ad571a66");
		self endon("disconnect");
		self.var_94ee23e0 fadeOverTime(0.05);
		self.var_94ee23e0.alpha = 1;
		prefix = "Dev Block strings are not supported";
		var_fc8642f1 = name;
		if(IsSubStr(name, prefix))
		{
			var_fc8642f1 = GetSubStr(name, prefix.size);
		}
		if(isdefined(var_2741876d))
		{
			self.var_94ee23e0 setText("Dev Block strings are not supported" + var_fc8642f1 + "Dev Block strings are not supported" + var_2741876d + "Dev Block strings are not supported");
		}
		else
		{
			self.var_94ee23e0 setText("Dev Block strings are not supported" + var_fc8642f1);
		}
		wait(1);
		if("Dev Block strings are not supported" == name)
		{
			self.var_94ee23e0 fadeOverTime(1);
			self.var_94ee23e0.alpha = 0;
		}
	#/
}

/*
	Name: function_47db72b6
	Namespace: bgb
	Checksum: 0x5B63E5FA
	Offset: 0x1A70
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function function_47db72b6(bgb)
{
	/#
		PrintTopRightln(bgb + "Dev Block strings are not supported" + self.var_e610f362[bgb].var_e0b06b47, (1, 1, 1));
		PrintTopRightln(bgb + "Dev Block strings are not supported" + self.var_e610f362[bgb].var_b75c376, (1, 1, 1));
		var_e4140345 = self.var_e610f362[bgb].var_e0b06b47 - self.var_e610f362[bgb].var_b75c376;
		PrintTopRightln(bgb + "Dev Block strings are not supported" + var_e4140345, (1, 1, 1));
	#/
}

/*
	Name: function_c7783423
	Namespace: bgb
	Checksum: 0x147B9851
	Offset: 0x1B70
	Size: 0x65
	Parameters: 1
	Flags: Private
*/
function private function_c7783423(bgb)
{
	if(!isdefined(self.var_e610f362[bgb]) || (!isdefined(level.bgb[bgb].var_e0715b48) && level.bgb[bgb].var_e0715b48))
	{
		return 0;
	}
	else
	{
		return 1;
	}
}

/*
	Name: function_66a597c1
	Namespace: bgb
	Checksum: 0xA2DCCF17
	Offset: 0x1BE0
	Size: 0x153
	Parameters: 1
	Flags: None
*/
function function_66a597c1(bgb)
{
	if(!function_c7783423(bgb))
	{
		return;
	}
	if(isdefined(level.bgb[bgb].var_35e23ba2) && ![[level.bgb[bgb].var_35e23ba2]]())
	{
		return;
	}
	self.var_e610f362[bgb].var_b75c376++;
	self flag::set("used_consumable");
	zm_utility::increment_zm_dash_counter("consumables_used", 1);
	if(level flag::exists("first_consumables_used"))
	{
		level flag::set("first_consumables_used");
	}
	self LUINotifyEvent(&"zombie_bgb_used", 1, level.bgb[bgb].var_e25ca181);
	/#
		function_47db72b6(bgb);
	#/
}

/*
	Name: function_f59fbff
	Namespace: bgb
	Checksum: 0x22869CFC
	Offset: 0x1D40
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function function_f59fbff(bgb)
{
	if(!isdefined(self.var_e610f362[bgb]))
	{
		return 1;
	}
	var_3232aae6 = self.var_e610f362[bgb].var_e0b06b47;
	var_8e01583 = self.var_e610f362[bgb].var_b75c376;
	var_c6b3f8bc = var_3232aae6 - var_8e01583;
	return 0 < var_c6b3f8bc;
}

/*
	Name: function_c3e0b2ba
	Namespace: bgb
	Checksum: 0xD1A78E06
	Offset: 0x1DD8
	Size: 0xC3
	Parameters: 2
	Flags: Private
*/
function private function_c3e0b2ba(bgb, activating)
{
	if(!(isdefined(level.bgb[bgb].var_7ca0e2a7) && level.bgb[bgb].var_7ca0e2a7))
	{
		return;
	}
	var_b0106e56 = self EnableInvulnerability();
	self util::waittill_any_timeout(2, "bgb_bubble_blow_complete");
	if(isdefined(self) && (!isdefined(var_b0106e56) && var_b0106e56))
	{
		self DisableInvulnerability();
	}
}

/*
	Name: function_b107a7f3
	Namespace: bgb
	Checksum: 0x5B4FDEA6
	Offset: 0x1EA8
	Size: 0x3D7
	Parameters: 2
	Flags: None
*/
function function_b107a7f3(bgb, activating)
{
	self endon("disconnect");
	level endon("end_game");
	unlocked = function_64f7cbc3();
	if(activating)
	{
		self thread function_c3e0b2ba(bgb);
		self thread zm_audio::create_and_play_dialog("bgb", "eat");
	}
	while(self IsSwitchingWeapons())
	{
		self waittill("weapon_change_complete");
	}
	gun = self function_bb702b0a(bgb, activating);
	evt = self util::waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete", "disconnect");
	succeeded = 0;
	if(evt == "weapon_change_complete")
	{
		succeeded = 1;
		if(activating)
		{
			if(isdefined(level.bgb[bgb].var_7ea552f4) && level.bgb[bgb].var_7ea552f4 || self function_b616fe7a(1))
			{
				self notify("hash_83da9d01", bgb);
				self function_103ebe74();
				self thread function_eb4b1160(bgb);
			}
			else
			{
				succeeded = 0;
			}
		}
		else if(!(isdefined(unlocked) && unlocked))
		{
			return 0;
		}
		self notify("hash_fcbbef99", bgb);
		self thread give(bgb);
		self zm_stats::increment_client_stat("bgbs_chewed");
		self zm_stats::increment_player_stat("bgbs_chewed");
		self zm_stats::increment_challenge_stat("GUM_GOBBLER_CONSUME");
		self AddDStat("ItemStats", level.bgb[bgb].var_e25ca181, "stats", "used", "statValue", 1);
		health = 0;
		if(isdefined(self.health))
		{
			health = self.health;
		}
		self RecordMapEvent(4, GetTime(), self.origin, level.round_number, level.bgb[bgb].var_e25ca181, health);
		demo::bookmark("zm_player_bgb_grab", GetTime(), self);
		if(SessionModeIsOnlineGame())
		{
			util::function_a4c90358("zm_bgb_consumed", 1);
		}
	}
	self function_a4493f0e(gun, bgb, activating);
	return succeeded;
}

/*
	Name: function_eb4b1160
	Namespace: bgb
	Checksum: 0x4953F724
	Offset: 0x2288
	Size: 0xA3
	Parameters: 1
	Flags: Private
*/
function private function_eb4b1160(bgb)
{
	self endon("disconnect");
	self function_9b5dc008(1);
	self do_one_shot_use();
	self notify("hash_95b677dc");
	self [[level.bgb[bgb].var_6fa3d682]]();
	self function_9b5dc008(0);
	self function_1565b2f5();
}

/*
	Name: function_f6845bf
	Namespace: bgb
	Checksum: 0xB2C38A9F
	Offset: 0x2338
	Size: 0x29
	Parameters: 2
	Flags: Private
*/
function private function_f6845bf(bgb, activating)
{
	if(activating)
	{
		return level.var_c92b3b33;
	}
	return level.var_adfa48c4;
}

/*
	Name: function_bb702b0a
	Namespace: bgb
	Checksum: 0xC3775DB
	Offset: 0x2370
	Size: 0x157
	Parameters: 2
	Flags: Private
*/
function private function_bb702b0a(bgb, activating)
{
	self zm_utility::increment_is_drinking();
	self zm_utility::disable_player_move_states(1);
	var_e3d21ca6 = self GetCurrentWeapon();
	weapon = function_f6845bf(bgb, activating);
	self GiveWeapon(weapon, self CalcWeaponOptions(level.bgb[bgb].camo_index, 0, 0));
	self SwitchToWeapon(weapon);
	if(weapon == level.var_adfa48c4)
	{
		self playsound("zmb_bgb_powerup_default");
	}
	if(weapon == level.var_c92b3b33)
	{
		self clientfield::increment_to_player("bgb_blow_bubble");
	}
	return var_e3d21ca6;
}

/*
	Name: function_a4493f0e
	Namespace: bgb
	Checksum: 0xCA8BF35F
	Offset: 0x24D0
	Size: 0x253
	Parameters: 3
	Flags: Private
*/
function private function_a4493f0e(var_e3d21ca6, bgb, activating)
{
	/#
		Assert(!var_e3d21ca6.isPerkBottle);
	#/
	/#
		Assert(var_e3d21ca6 != level.weaponReviveTool);
	#/
	self zm_utility::enable_player_move_states();
	weapon = function_f6845bf(bgb, activating);
	if(self laststand::player_is_in_laststand() || (isdefined(self.intermission) && self.intermission))
	{
		self TakeWeapon(weapon);
		return;
	}
	self TakeWeapon(weapon);
	if(self zm_utility::is_multiple_drinking())
	{
		self zm_utility::decrement_is_drinking();
		return;
	}
	else if(var_e3d21ca6 != level.weaponNone && !zm_utility::is_placeable_mine(var_e3d21ca6) && !zm_equipment::is_equipment_that_blocks_purchase(var_e3d21ca6))
	{
		self zm_weapons::switch_back_primary_weapon(var_e3d21ca6);
		if(zm_utility::is_melee_weapon(var_e3d21ca6))
		{
			self zm_utility::decrement_is_drinking();
			return;
		}
	}
	else
	{
		self zm_weapons::switch_back_primary_weapon();
	}
	self util::waittill_any_timeout(1, "weapon_change_complete");
	if(!self laststand::player_is_in_laststand() && (!isdefined(self.intermission) && self.intermission))
	{
		self zm_utility::decrement_is_drinking();
	}
}

/*
	Name: function_3fe79b9
	Namespace: bgb
	Checksum: 0x5D3EB4BD
	Offset: 0x2730
	Size: 0x73
	Parameters: 0
	Flags: Private
*/
function private function_3fe79b9()
{
	self notify("hash_f8dba1d1");
	self notify("hash_d701de2e");
	self clientfield::set_player_uimodel("bgb_display", 0);
	self clientfield::set_player_uimodel("bgb_activations_remaining", 0);
	self clear_timer();
}

/*
	Name: function_f8dba1d1
	Namespace: bgb
	Checksum: 0x3651469
	Offset: 0x27B0
	Size: 0x523
	Parameters: 0
	Flags: Private
*/
function private function_f8dba1d1()
{
	self endon("disconnect");
	self endon("hash_994d5e9e");
	self notify("hash_f8dba1d1");
	self endon("hash_f8dba1d1");
	self clientfield::set_player_uimodel("bgb_display", 1);
	self thread function_5fc6d844(self.bgb);
	switch(level.bgb[self.bgb].var_c9e64d65)
	{
		case "activated":
		{
			self thread function_d701de2e();
			for(i = level.bgb[self.bgb].limit; i > 0; i--)
			{
				level.bgb[self.bgb].var_32fa3cb7 = i;
				if(level.bgb[self.bgb].var_336ffc4e)
				{
					function_497386b0();
				}
				else
				{
					self set_timer(i, level.bgb[self.bgb].limit);
				}
				self clientfield::set_player_uimodel("bgb_activations_remaining", i);
				self thread function_b33a98c7(self.bgb, i);
				self waittill("hash_20e4f529");
				while(isdefined(self function_e2bcf80c()) && self function_e2bcf80c())
				{
					wait(0.05);
				}
				self playsoundtoplayer("zmb_bgb_power_decrement", self);
			}
			level.bgb[self.bgb].var_32fa3cb7 = 0;
			self playsoundtoplayer("zmb_bgb_power_done_delayed", self);
			self set_timer(0, level.bgb[self.bgb].limit);
			while(isdefined(self.var_aa1915a5) && self.var_aa1915a5)
			{
				wait(0.05);
			}
			break;
		}
		case "time":
		{
			self thread function_b33a98c7(self.bgb);
			self thread run_timer(level.bgb[self.bgb].limit);
			wait(level.bgb[self.bgb].limit);
			self playsoundtoplayer("zmb_bgb_power_done", self);
			break;
		}
		case "rounds":
		{
			self thread function_b33a98c7(self.bgb);
			count = level.bgb[self.bgb].limit + 1;
			for(i = 0; i < count; i++)
			{
				self set_timer(count - i, count);
				level waittill("end_of_round");
				self playsoundtoplayer("zmb_bgb_power_decrement", self);
			}
			self playsoundtoplayer("zmb_bgb_power_done_delayed", self);
			break;
		}
		case "event":
		{
			self thread function_b33a98c7(self.bgb);
			self function_63a399b7(1);
			self [[level.bgb[self.bgb].limit]]();
			self playsoundtoplayer("zmb_bgb_power_done_delayed", self);
			break;
		}
		case default:
		{
			/#
				Assert(0, "Dev Block strings are not supported" + self.bgb + "Dev Block strings are not supported" + level.bgb[self.bgb].var_c9e64d65 + "Dev Block strings are not supported");
			#/
		}
	}
	self thread take();
}

/*
	Name: function_7ad7537e
	Namespace: bgb
	Checksum: 0xB19D48FE
	Offset: 0x2CE0
	Size: 0x6B
	Parameters: 0
	Flags: Private
*/
function private function_7ad7537e()
{
	self endon("disconnect");
	self endon("hash_994d5e9e");
	self notify("hash_7ad7537e");
	self endon("hash_7ad7537e");
	self waittill("bled_out");
	self notify("hash_eecacfa5");
	wait(0.1);
	self thread take();
}

/*
	Name: function_d701de2e
	Namespace: bgb
	Checksum: 0xB16E64C3
	Offset: 0x2D58
	Size: 0xB5
	Parameters: 0
	Flags: Private
*/
function private function_d701de2e()
{
	self endon("disconnect");
	self notify("hash_d701de2e");
	self endon("hash_d701de2e");
	if("activated" != level.bgb[self.bgb].var_c9e64d65)
	{
		return;
	}
	for(;;)
	{
		self waittill("hash_10c37787");
		if(!self function_b616fe7a(0))
		{
			continue;
		}
		if(self function_b107a7f3(self.bgb, 1))
		{
			self notify("hash_20e4f529", self.bgb);
		}
	}
}

/*
	Name: function_b616fe7a
	Namespace: bgb
	Checksum: 0x17FBD8B1
	Offset: 0x2E18
	Size: 0x143
	Parameters: 1
	Flags: Private
*/
function private function_b616fe7a(var_5827b083)
{
	if(!isdefined(var_5827b083))
	{
		var_5827b083 = 0;
	}
	var_bb1d9487 = isdefined(level.bgb[self.bgb].validation_func) && !self [[level.bgb[self.bgb].validation_func]]();
	var_847ec8da = isdefined(level.var_9cef605e) && !self [[level.var_9cef605e]]();
	if(!var_5827b083 && (isdefined(self.IS_DRINKING) && self.IS_DRINKING) || (isdefined(self.var_aa1915a5) && self.var_aa1915a5) || self laststand::player_is_in_laststand() || var_bb1d9487 || var_847ec8da)
	{
		self clientfield::increment_uimodel("bgb_invalid_use");
		self playlocalsound("zmb_bgb_deny_plr");
		return 0;
	}
	return 1;
}

/*
	Name: function_5fc6d844
	Namespace: bgb
	Checksum: 0x542A2377
	Offset: 0x2F68
	Size: 0xA3
	Parameters: 1
	Flags: Private
*/
function private function_5fc6d844(bgb)
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("hash_994d5e9e");
	if(isdefined(level.bgb[bgb].var_50fe45f6) && level.bgb[bgb].var_50fe45f6)
	{
		function_650ca64(6);
	}
	else
	{
		return;
	}
	self waittill("hash_10c37787");
	self thread take();
}

/*
	Name: function_650ca64
	Namespace: bgb
	Checksum: 0x981D146B
	Offset: 0x3018
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function function_650ca64(n_value)
{
	self SetActionSlot(1, "bgb");
	self clientfield::set_player_uimodel("bgb_activations_remaining", n_value);
}

/*
	Name: function_eabb0903
	Namespace: bgb
	Checksum: 0x5CF03FCD
	Offset: 0x3070
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_eabb0903(n_value)
{
	self clientfield::set_player_uimodel("bgb_activations_remaining", 0);
}

/*
	Name: function_336ffc4e
	Namespace: bgb
	Checksum: 0xEF99BB19
	Offset: 0x30A8
	Size: 0x27
	Parameters: 1
	Flags: None
*/
function function_336ffc4e(name)
{
	level.bgb[name].var_336ffc4e = 1;
}

/*
	Name: do_one_shot_use
	Namespace: bgb
	Checksum: 0x5D7A7D6D
	Offset: 0x30D8
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function do_one_shot_use(skip_demo_bookmark)
{
	if(!isdefined(skip_demo_bookmark))
	{
		skip_demo_bookmark = 0;
	}
	self clientfield::increment_uimodel("bgb_one_shot_use");
	if(!skip_demo_bookmark)
	{
		demo::bookmark("zm_player_bgb_activate", GetTime(), self);
	}
}

/*
	Name: function_103ebe74
	Namespace: bgb
	Checksum: 0xA8BE8A8A
	Offset: 0x3148
	Size: 0xF
	Parameters: 0
	Flags: Private
*/
function private function_103ebe74()
{
	self.var_aa1915a5 = 1;
}

/*
	Name: function_1565b2f5
	Namespace: bgb
	Checksum: 0x3430D9A
	Offset: 0x3160
	Size: 0x1D
	Parameters: 0
	Flags: Private
*/
function private function_1565b2f5()
{
	self.var_aa1915a5 = 0;
	self notify("hash_1565b2f5");
}

/*
	Name: function_9b5dc008
	Namespace: bgb
	Checksum: 0x33259947
	Offset: 0x3188
	Size: 0x17
	Parameters: 1
	Flags: Private
*/
function private function_9b5dc008(var_71740755)
{
	self.var_3244073f = var_71740755;
}

/*
	Name: function_e2bcf80c
	Namespace: bgb
	Checksum: 0xDA2694C2
	Offset: 0x31A8
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function function_e2bcf80c()
{
	return isdefined(self.var_3244073f) && self.var_3244073f;
}

/*
	Name: is_active
	Namespace: bgb
	Checksum: 0x33748679
	Offset: 0x31C8
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function is_active(name)
{
	if(!isdefined(self.bgb))
	{
		return 0;
	}
	return self.bgb == name && (isdefined(self.var_3244073f) && self.var_3244073f);
}

/*
	Name: is_team_active
	Namespace: bgb
	Checksum: 0x74678969
	Offset: 0x3210
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function is_team_active(name)
{
	foreach(player in level.players)
	{
		if(player is_active(name))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: function_f345a8ce
	Namespace: bgb
	Checksum: 0x97E3FEAA
	Offset: 0x32C0
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_f345a8ce(name)
{
	if(!isdefined(level.bgb[name]))
	{
		return 0;
	}
	var_ad8303b0 = level.bgb[name].ref_count;
	level.bgb[name].ref_count++;
	return var_ad8303b0;
}

/*
	Name: function_72936116
	Namespace: bgb
	Checksum: 0x1DC94792
	Offset: 0x3330
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function function_72936116(name)
{
	if(!isdefined(level.bgb[name]))
	{
		return 0;
	}
	level.bgb[name].ref_count--;
	return level.bgb[name].ref_count;
}

/*
	Name: calc_remaining_duration_lerp
	Namespace: bgb
	Checksum: 0xAF7D7B74
	Offset: 0x3390
	Size: 0x91
	Parameters: 2
	Flags: Private
*/
function private calc_remaining_duration_lerp(start_time, end_time)
{
	if(0 >= end_time - start_time)
	{
		return 0;
	}
	now = GetTime();
	frac = float(end_time - now) / float(end_time - start_time);
	return math::clamp(frac, 0, 1);
}

/*
	Name: function_f9fad8b3
	Namespace: bgb
	Checksum: 0xCDE8A8E
	Offset: 0x3430
	Size: 0xD7
	Parameters: 2
	Flags: Private
*/
function private function_f9fad8b3(var_eeab9300, percent)
{
	self endon("disconnect");
	self endon("hash_f9fad8b3");
	start_time = GetTime();
	end_time = start_time + 1000;
	var_6d8b0ec7 = var_eeab9300;
	while(var_6d8b0ec7 > percent)
	{
		var_6d8b0ec7 = LerpFloat(percent, var_eeab9300, calc_remaining_duration_lerp(start_time, end_time));
		self clientfield::set_player_uimodel("bgb_timer", var_6d8b0ec7);
		wait(0.05);
	}
}

/*
	Name: function_63a399b7
	Namespace: bgb
	Checksum: 0x90DF0BDF
	Offset: 0x3510
	Size: 0xAB
	Parameters: 1
	Flags: Private
*/
function private function_63a399b7(percent)
{
	self notify("hash_f9fad8b3");
	var_eeab9300 = self clientfield::get_player_uimodel("bgb_timer");
	if(percent < var_eeab9300 && 0.1 <= var_eeab9300 - percent)
	{
		self thread function_f9fad8b3(var_eeab9300, percent);
	}
	else
	{
		self clientfield::set_player_uimodel("bgb_timer", percent);
	}
}

/*
	Name: function_497386b0
	Namespace: bgb
	Checksum: 0x84F0B914
	Offset: 0x35C8
	Size: 0x1B
	Parameters: 0
	Flags: Private
*/
function private function_497386b0()
{
	self function_63a399b7(1);
}

/*
	Name: set_timer
	Namespace: bgb
	Checksum: 0x425FDFE8
	Offset: 0x35F0
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function set_timer(current, max)
{
	self function_63a399b7(current / max);
}

/*
	Name: run_timer
	Namespace: bgb
	Checksum: 0x57C0F587
	Offset: 0x3630
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function run_timer(max)
{
	self endon("disconnect");
	self notify("hash_40cdac02");
	self endon("hash_40cdac02");
	for(current = max; current > 0;  = max)
	{
		self set_timer(current, max);
		wait(0.05);
	}
	self clear_timer();
}

/*
	Name: clear_timer
	Namespace: bgb
	Checksum: 0xA40ABFCD
	Offset: 0x36D8
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function clear_timer()
{
	self function_63a399b7(0);
	self notify("hash_40cdac02");
}

/*
	Name: register
	Namespace: bgb
	Checksum: 0x294E0264
	Offset: 0x3710
	Size: 0x52F
	Parameters: 7
	Flags: None
*/
function register(name, var_c9e64d65, limit, var_205ab425, var_f6f70764, validation_func, var_6fa3d682)
{
	/#
		Assert(isdefined(name), "Dev Block strings are not supported");
	#/
	/#
		Assert("Dev Block strings are not supported" != name, "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
	#/
	/#
		Assert(!isdefined(level.bgb[name]), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(var_c9e64d65), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(limit), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(!isdefined(var_205ab425) || IsFunctionPtr(var_205ab425), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(!isdefined(var_f6f70764) || IsFunctionPtr(var_f6f70764), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	switch(var_c9e64d65)
	{
		case "activated":
		{
			/#
				Assert(!isdefined(validation_func) || IsFunctionPtr(validation_func), "Dev Block strings are not supported" + name + "Dev Block strings are not supported" + var_c9e64d65 + "Dev Block strings are not supported");
			#/
			/#
				Assert(isdefined(var_6fa3d682), "Dev Block strings are not supported" + name + "Dev Block strings are not supported" + var_c9e64d65 + "Dev Block strings are not supported");
			#/
			/#
				Assert(IsFunctionPtr(var_6fa3d682), "Dev Block strings are not supported" + name + "Dev Block strings are not supported" + var_c9e64d65 + "Dev Block strings are not supported");
			#/
		}
		case "rounds":
		case "time":
		{
			/#
				Assert(IsInt(limit), "Dev Block strings are not supported" + name + "Dev Block strings are not supported" + limit + "Dev Block strings are not supported" + var_c9e64d65 + "Dev Block strings are not supported");
			#/
			break;
		}
		case "event":
		{
			/#
				Assert(IsFunctionPtr(limit), "Dev Block strings are not supported" + name + "Dev Block strings are not supported" + var_c9e64d65 + "Dev Block strings are not supported");
			#/
			break;
		}
		case default:
		{
			/#
				Assert(0, "Dev Block strings are not supported" + name + "Dev Block strings are not supported" + var_c9e64d65 + "Dev Block strings are not supported");
			#/
		}
	}
	level.bgb[name] = spawnstruct();
	level.bgb[name].name = name;
	level.bgb[name].var_c9e64d65 = var_c9e64d65;
	level.bgb[name].limit = limit;
	level.bgb[name].var_205ab425 = var_205ab425;
	level.bgb[name].var_f6f70764 = var_f6f70764;
	if("activated" == var_c9e64d65)
	{
		level.bgb[name].validation_func = validation_func;
		level.bgb[name].var_6fa3d682 = var_6fa3d682;
		level.bgb[name].var_336ffc4e = 0;
	}
	level.bgb[name].ref_count = 0;
}

/*
	Name: function_3422638b
	Namespace: bgb
	Checksum: 0xB600CE11
	Offset: 0x3C48
	Size: 0x67
	Parameters: 2
	Flags: None
*/
function function_3422638b(name, var_d99aa464)
{
	/#
		Assert(isdefined(level.bgb[name]), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	level.bgb[name].var_d99aa464 = var_d99aa464;
}

/*
	Name: function_e22c6124
	Namespace: bgb
	Checksum: 0x28F077E3
	Offset: 0x3CB8
	Size: 0x67
	Parameters: 2
	Flags: None
*/
function function_e22c6124(name, var_bfbb61c1)
{
	/#
		Assert(isdefined(level.bgb[name]), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	level.bgb[name].var_bfbb61c1 = var_bfbb61c1;
}

/*
	Name: function_2b341a2e
	Namespace: bgb
	Checksum: 0xB5137758
	Offset: 0x3D28
	Size: 0x67
	Parameters: 2
	Flags: None
*/
function function_2b341a2e(name, var_5c0ccc6f)
{
	/#
		Assert(isdefined(level.bgb[name]), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	level.bgb[name].var_5c0ccc6f = var_5c0ccc6f;
}

/*
	Name: register_lost_perk_override
	Namespace: bgb
	Checksum: 0x75A50890
	Offset: 0x3D98
	Size: 0x8B
	Parameters: 3
	Flags: None
*/
function register_lost_perk_override(name, lost_perk_override_func, lost_perk_override_func_always_run)
{
	/#
		Assert(isdefined(level.bgb[name]), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	level.bgb[name].lost_perk_override_func = lost_perk_override_func;
	level.bgb[name].lost_perk_override_func_always_run = lost_perk_override_func_always_run;
}

/*
	Name: function_ff4b2998
	Namespace: bgb
	Checksum: 0xCD6631BB
	Offset: 0x3E30
	Size: 0x8B
	Parameters: 3
	Flags: None
*/
function function_ff4b2998(name, var_e25efdfd, var_cdcc8fcd)
{
	/#
		Assert(isdefined(level.bgb[name]), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	level.bgb[name].var_e25efdfd = var_e25efdfd;
	level.bgb[name].var_cdcc8fcd = var_cdcc8fcd;
}

/*
	Name: function_4cda71bf
	Namespace: bgb
	Checksum: 0xC631F42D
	Offset: 0x3EC8
	Size: 0x67
	Parameters: 2
	Flags: None
*/
function function_4cda71bf(name, var_7ca0e2a7)
{
	/#
		Assert(isdefined(level.bgb[name]), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	level.bgb[name].var_7ca0e2a7 = var_7ca0e2a7;
}

/*
	Name: function_93da425
	Namespace: bgb
	Checksum: 0xE1943FD8
	Offset: 0x3F38
	Size: 0x67
	Parameters: 2
	Flags: None
*/
function function_93da425(name, var_35e23ba2)
{
	/#
		Assert(isdefined(level.bgb[name]), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	level.bgb[name].var_35e23ba2 = var_35e23ba2;
}

/*
	Name: function_2060b89
	Namespace: bgb
	Checksum: 0x1163C55B
	Offset: 0x3FA8
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function function_2060b89(name)
{
	/#
		Assert(isdefined(level.bgb[name]), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	level.bgb[name].var_50fe45f6 = 1;
}

/*
	Name: function_f132da9c
	Namespace: bgb
	Checksum: 0x3F20E3AF
	Offset: 0x4010
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function function_f132da9c(name)
{
	/#
		Assert(isdefined(level.bgb[name]), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	level.bgb[name].var_7ea552f4 = 1;
}

/*
	Name: function_d35f60a1
	Namespace: bgb
	Checksum: 0xA8E2EFFA
	Offset: 0x4078
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function function_d35f60a1(name)
{
	unlocked = function_64f7cbc3();
	if(unlocked)
	{
		self give(name);
	}
}

/*
	Name: give
	Namespace: bgb
	Checksum: 0xC2F91B7E
	Offset: 0x40D0
	Size: 0x1C3
	Parameters: 1
	Flags: None
*/
function give(name)
{
	self thread take();
	if("none" == name)
	{
		return;
	}
	/#
		Assert(isdefined(level.bgb[name]), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	self notify("hash_994d5e9e", name, self.bgb);
	self notify("bgb_update_give_" + name);
	self.bgb = name;
	self clientfield::set_player_uimodel("bgb_current", level.bgb[name].var_e25ca181);
	self LUINotifyEvent(&"zombie_bgb_notification", 1, level.bgb[name].var_e25ca181);
	if(isdefined(level.bgb[name].var_205ab425))
	{
		self thread [[level.bgb[name].var_205ab425]]();
	}
	if(isdefined("activated" == level.bgb[name].var_c9e64d65))
	{
		self SetActionSlot(1, "bgb");
	}
	self thread function_f8dba1d1();
	self thread function_7ad7537e();
}

/*
	Name: take
	Namespace: bgb
	Checksum: 0x1CE0D3EE
	Offset: 0x42A0
	Size: 0xF7
	Parameters: 0
	Flags: None
*/
function take()
{
	if("none" == self.bgb)
	{
		return;
	}
	self SetActionSlot(1, "");
	self thread function_b33a98c7("none");
	if(isdefined(level.bgb[self.bgb].var_f6f70764))
	{
		self thread [[level.bgb[self.bgb].var_f6f70764]]();
	}
	self function_3fe79b9();
	self notify("hash_994d5e9e", "none", self.bgb);
	self notify("bgb_update_take_" + self.bgb);
	self.bgb = "none";
}

/*
	Name: function_51fc7e9d
	Namespace: bgb
	Checksum: 0xBAEC966
	Offset: 0x43A0
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function function_51fc7e9d()
{
	return self.bgb;
}

/*
	Name: is_enabled
	Namespace: bgb
	Checksum: 0x369A99AA
	Offset: 0x43B8
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function is_enabled(name)
{
	/#
		Assert(isdefined(self.bgb));
	#/
	return self.bgb == name;
}

/*
	Name: function_58be9c43
	Namespace: bgb
	Checksum: 0x4A6FEAAC
	Offset: 0x43F8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_58be9c43()
{
	/#
		Assert(isdefined(self.bgb));
	#/
	return self.bgb !== "none";
}

/*
	Name: is_team_enabled
	Namespace: bgb
	Checksum: 0xDD73CECB
	Offset: 0x4438
	Size: 0xC1
	Parameters: 1
	Flags: None
*/
function is_team_enabled(str_name)
{
	foreach(player in level.players)
	{
		/#
			Assert(isdefined(player.bgb));
		#/
		if(player.bgb == str_name)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: function_c219b050
	Namespace: bgb
	Checksum: 0x1DB6D96
	Offset: 0x4508
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function function_c219b050()
{
	var_587cd8a0 = self.origin + VectorScale(AnglesToForward((0, self getPlayerAngles()[1], 0)), 60) + VectorScale((0, 0, 1), 5);
	self zm_stats::increment_challenge_stat("GUM_GOBBLER_POWERUPS");
	return var_587cd8a0;
}

/*
	Name: function_dea74fb0
	Namespace: bgb
	Checksum: 0xADF187F6
	Offset: 0x4598
	Size: 0xC3
	Parameters: 2
	Flags: None
*/
function function_dea74fb0(str_powerup, v_origin)
{
	if(!isdefined(v_origin))
	{
		v_origin = self function_c219b050();
	}
	var_93eb638b = zm_powerups::specific_powerup_drop(str_powerup, v_origin);
	wait(1);
	if(isdefined(var_93eb638b) && (!var_93eb638b zm::in_enabled_playable_area() && !var_93eb638b zm::in_life_brush()))
	{
		level thread function_434235f9(var_93eb638b);
	}
}

/*
	Name: function_434235f9
	Namespace: bgb
	Checksum: 0x7EED9115
	Offset: 0x4668
	Size: 0x37B
	Parameters: 1
	Flags: None
*/
function function_434235f9(var_93eb638b)
{
	if(!isdefined(var_93eb638b))
	{
		return;
	}
	var_93eb638b ghost();
	var_93eb638b.clone_model = util::spawn_model(var_93eb638b.model, var_93eb638b.origin, var_93eb638b.angles);
	var_93eb638b.clone_model LinkTo(var_93eb638b);
	direction = var_93eb638b.origin;
	direction = (direction[1], direction[0], 0);
	if(direction[1] < 0 || (direction[0] > 0 && direction[1] > 0))
	{
		direction = (direction[0], direction[1] * -1, 0);
	}
	else if(direction[0] < 0)
	{
		direction = (direction[0] * -1, direction[1], 0);
	}
	if(!(isdefined(var_93eb638b.sndNoSamLaugh) && var_93eb638b.sndNoSamLaugh))
	{
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			if(isalive(players[i]))
			{
				players[i] playlocalsound(level.zmb_laugh_alias);
			}
		}
	}
	PlayFXOnTag(level._effect["samantha_steal"], var_93eb638b, "tag_origin");
	var_93eb638b.clone_model Unlink();
	var_93eb638b.clone_model MoveZ(60, 1, 0.25, 0.25);
	var_93eb638b.clone_model vibrate(direction, 1.5, 2.5, 1);
	var_93eb638b.clone_model waittill("movedone");
	if(isdefined(self.damagearea))
	{
		self.damagearea delete();
	}
	var_93eb638b.clone_model delete();
	if(isdefined(var_93eb638b))
	{
		if(isdefined(var_93eb638b.damagearea))
		{
			var_93eb638b.damagearea delete();
		}
		var_93eb638b zm_powerups::powerup_delete();
	}
}

/*
	Name: actor_damage_override
	Namespace: bgb
	Checksum: 0x2EA7AF6E
	Offset: 0x49F0
	Size: 0x14F
	Parameters: 12
	Flags: None
*/
function actor_damage_override(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return damage;
	}
	if(isPlayer(attacker))
	{
		name = attacker function_51fc7e9d();
		if(name !== "none" && isdefined(level.bgb[name]) && isdefined(level.bgb[name].var_d99aa464))
		{
			damage = [[level.bgb[name].var_d99aa464]](inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, surfaceType);
		}
	}
	return damage;
}

/*
	Name: vehicle_damage_override
	Namespace: bgb
	Checksum: 0x8CCDAA93
	Offset: 0x4B48
	Size: 0x173
	Parameters: 15
	Flags: None
*/
function vehicle_damage_override(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return iDamage;
	}
	if(isPlayer(eAttacker))
	{
		name = eAttacker function_51fc7e9d();
		if(name !== "none" && isdefined(level.bgb[name]) && isdefined(level.bgb[name].var_bfbb61c1))
		{
			iDamage = [[level.bgb[name].var_bfbb61c1]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal);
		}
	}
	return iDamage;
}

/*
	Name: actor_death_override
	Namespace: bgb
	Checksum: 0xD80802EA
	Offset: 0x4CC8
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function actor_death_override(attacker)
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return 0;
	}
	if(isPlayer(attacker))
	{
		name = attacker function_51fc7e9d();
		if(name !== "none" && isdefined(level.bgb[name]) && isdefined(level.bgb[name].var_5c0ccc6f))
		{
			damage = [[level.bgb[name].var_5c0ccc6f]](attacker);
		}
	}
	return damage;
}

/*
	Name: lost_perk_override
	Namespace: bgb
	Checksum: 0x3E1114E7
	Offset: 0x4DA8
	Size: 0x253
	Parameters: 1
	Flags: None
*/
function lost_perk_override(perk)
{
	b_result = 0;
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return b_result;
	}
	if(!(isdefined(self.laststand) && self.laststand))
	{
		return b_result;
	}
	keys = getArrayKeys(level.bgb);
	for(i = 0; i < keys.size; i++)
	{
		name = keys[i];
		if(isdefined(level.bgb[name].lost_perk_override_func_always_run) && level.bgb[name].lost_perk_override_func_always_run && isdefined(level.bgb[name].lost_perk_override_func))
		{
			b_result = [[level.bgb[name].lost_perk_override_func]](perk, self, undefined);
			if(b_result)
			{
				return b_result;
			}
		}
	}
	foreach(player in level.activePlayers)
	{
		name = player function_51fc7e9d();
		if(name !== "none" && isdefined(level.bgb[name]) && isdefined(level.bgb[name].lost_perk_override_func))
		{
			b_result = [[level.bgb[name].lost_perk_override_func]](perk, self, player);
			if(b_result)
			{
				return b_result;
			}
		}
	}
	return b_result;
}

/*
	Name: add_to_player_score_override
	Namespace: bgb
	Checksum: 0xFC6E925F
	Offset: 0x5008
	Size: 0x1C3
	Parameters: 2
	Flags: None
*/
function add_to_player_score_override(n_points, str_awarded_by)
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return n_points;
	}
	var_8b4008d0 = self function_51fc7e9d();
	keys = getArrayKeys(level.bgb);
	for(i = 0; i < keys.size; i++)
	{
		var_23359ff6 = keys[i];
		if(var_23359ff6 === var_8b4008d0)
		{
			continue;
		}
		if(isdefined(level.bgb[var_23359ff6].var_cdcc8fcd) && level.bgb[var_23359ff6].var_cdcc8fcd && isdefined(level.bgb[var_23359ff6].var_e25efdfd))
		{
			n_points = [[level.bgb[var_23359ff6].var_e25efdfd]](n_points, str_awarded_by, 0);
		}
	}
	if(var_8b4008d0 !== "none" && isdefined(level.bgb[var_8b4008d0]) && isdefined(level.bgb[var_8b4008d0].var_e25efdfd))
	{
		n_points = [[level.bgb[var_8b4008d0].var_e25efdfd]](n_points, str_awarded_by, 1);
	}
	return n_points;
}

/*
	Name: function_d51db887
	Namespace: bgb
	Checksum: 0x5FCF4FAE
	Offset: 0x51D8
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function function_d51db887()
{
	keys = Array::randomize(getArrayKeys(level.bgb));
	for(i = 0; i < keys.size; i++)
	{
		if(level.bgb[keys[i]].var_d277f374 != 1)
		{
			continue;
		}
		if(level.bgb[keys[i]].var_b9af356d > 0)
		{
			continue;
		}
		return keys[i];
	}
}

/*
	Name: function_4ed517b9
	Namespace: bgb
	Checksum: 0x23D70B86
	Offset: 0x52A8
	Size: 0x20B
	Parameters: 3
	Flags: None
*/
function function_4ed517b9(n_max_distance, var_98a3e738, var_287a7adb)
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("hash_994d5e9e");
	self.var_6638f10b = [];
	while(1)
	{
		foreach(e_player in level.players)
		{
			if(e_player == self)
			{
				continue;
			}
			Array::remove_undefined(self.var_6638f10b);
			var_368e2240 = Array::contains(self.var_6638f10b, e_player);
			var_50fd5a04 = zm_utility::is_player_valid(e_player, 0, 1) && function_2469cfe8(n_max_distance, self, e_player);
			if(!var_368e2240 && var_50fd5a04)
			{
				Array::add(self.var_6638f10b, e_player, 0);
				if(isdefined(var_98a3e738))
				{
					self thread [[var_98a3e738]](e_player);
				}
				continue;
			}
			if(var_368e2240 && !var_50fd5a04)
			{
				ArrayRemoveValue(self.var_6638f10b, e_player);
				if(isdefined(var_287a7adb))
				{
					self thread [[var_287a7adb]](e_player);
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_2469cfe8
	Namespace: bgb
	Checksum: 0x6C2A4F72
	Offset: 0x54C0
	Size: 0x7D
	Parameters: 3
	Flags: Private
*/
function private function_2469cfe8(n_distance, var_d21815c4, var_441f84ff)
{
	var_31dc18aa = n_distance * n_distance;
	var_2931dc75 = DistanceSquared(var_d21815c4.origin, var_441f84ff.origin);
	if(var_2931dc75 <= var_31dc18aa)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_ca189700
	Namespace: bgb
	Checksum: 0x194165CC
	Offset: 0x5548
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_ca189700()
{
	self clientfield::increment_uimodel("bgb_invalid_use");
	self playlocalsound("zmb_bgb_deny_plr");
}

/*
	Name: suspend_weapon_cycling
	Namespace: bgb
	Checksum: 0xBB0CA501
	Offset: 0x5598
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function suspend_weapon_cycling()
{
	self flag::clear("bgb_weapon_cycling");
}

/*
	Name: resume_weapon_cycling
	Namespace: bgb
	Checksum: 0x5E7C3417
	Offset: 0x55C8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function resume_weapon_cycling()
{
	self flag::set("bgb_weapon_cycling");
}

/*
	Name: function_959ccfd0
	Namespace: bgb
	Checksum: 0xEE0C457D
	Offset: 0x55F8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_959ccfd0()
{
	if(!self flag::exists("bgb_weapon_cycling"))
	{
		self flag::init("bgb_weapon_cycling");
	}
	self flag::set("bgb_weapon_cycling");
}

/*
	Name: function_378bff5d
	Namespace: bgb
	Checksum: 0xACCEF0B8
	Offset: 0x5668
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_378bff5d()
{
	self flag::wait_till("bgb_weapon_cycling");
}

/*
	Name: function_41ed378b
	Namespace: bgb
	Checksum: 0x8ADBAAE7
	Offset: 0x5698
	Size: 0x1A3
	Parameters: 1
	Flags: None
*/
function function_41ed378b(perk)
{
	self notify("revive_and_return_perk_on_bgb_activation" + perk);
	self endon("revive_and_return_perk_on_bgb_activation" + perk);
	self endon("disconnect");
	self endon("bled_out");
	if(perk == "specialty_widowswine")
	{
		var_376ad33c = self GetWeaponAmmoClip(self.current_lethal_grenade);
	}
	self waittill("player_revived", e_reviver);
	if(isdefined(self.var_df0decf1) && self.var_df0decf1 || (isdefined(e_reviver) && (isdefined(self.bgb) && self is_enabled("zm_bgb_near_death_experience")) || (isdefined(e_reviver.bgb) && e_reviver is_enabled("zm_bgb_near_death_experience"))))
	{
		if(zm_perks::use_solo_revive() && perk == "specialty_quickrevive")
		{
			level.solo_game_free_player_quickrevive = 1;
		}
		wait(0.05);
		self thread zm_perks::give_perk(perk, 0);
		if(perk == "specialty_widowswine" && isdefined(var_376ad33c))
		{
			self SetWeaponAmmoClip(self.current_lethal_grenade, var_376ad33c);
		}
	}
}

/*
	Name: function_7d63d2eb
	Namespace: bgb
	Checksum: 0x37E45910
	Offset: 0x5848
	Size: 0x71
	Parameters: 0
	Flags: None
*/
function function_7d63d2eb()
{
	self endon("disconnect");
	self endon("death");
	self.var_df0decf1 = 1;
	self waittill("player_revived", e_reviver);
	wait(0.05);
	if(isdefined(self.var_df0decf1) && self.var_df0decf1)
	{
		self notify("bgb_revive");
		self.var_df0decf1 = undefined;
	}
}

