#using scripts\shared\abilities\_ability_player;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\throttle_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_dragon_whelp;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace namespace_2ef08cd1;

/*
	Name: __init__sytem__
	Namespace: namespace_2ef08cd1
	Checksum: 0xBE46462E
	Offset: 0x708
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_dragon_gauntlet", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_2ef08cd1
	Checksum: 0xE29D5E01
	Offset: 0x748
	Size: 0x253
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.var_207d01be = GetWeapon("dragon_gauntlet_flamethrower");
	level.var_ae0fff53 = GetWeapon("dragon_gauntlet");
	zm_hero_weapon::register_hero_recharge_event(level.var_207d01be, &function_fa885ef2);
	zm_hero_weapon::register_hero_recharge_event(level.var_ae0fff53, &function_fa885ef2);
	callback::on_connect(&function_44774881);
	callback::on_player_killed(&function_421902c5);
	zm_hero_weapon::register_hero_weapon("dragon_gauntlet_flamethrower");
	zm_hero_weapon::register_hero_weapon_wield_unwield_callbacks("dragon_gauntlet_flamethrower", &function_712b36f9, &function_b90c6ba);
	zm_hero_weapon::register_hero_weapon_power_callbacks("dragon_gauntlet_flamethrower", &function_cd7dbd9d, &function_2f36d185);
	zm_hero_weapon::register_hero_weapon("dragon_gauntlet");
	zm_hero_weapon::register_hero_weapon_wield_unwield_callbacks("dragon_gauntlet", &function_f79afde0, &function_d638417f);
	zm_hero_weapon::register_hero_weapon_power_callbacks("dragon_gauntlet", &function_cd7dbd9d, &function_2f36d185);
	zm::register_actor_damage_callback(&function_cb315e40);
	function_9b385ca5();
	level.var_af9cd4ca = Throttle;
	Initialize(level.var_af9cd4ca, 6);
	/#
		level thread function_a23fb854();
	#/
}

/*
	Name: function_44774881
	Namespace: namespace_2ef08cd1
	Checksum: 0xC197E6F0
	Offset: 0x9A8
	Size: 0x1EB
	Parameters: 0
	Flags: Private
*/
function private function_44774881()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("death");
	self endon("hash_b24d78f");
	self function_36f6c07f(0);
	self.var_207d01be = level.var_207d01be;
	self.var_ae0fff53 = level.var_ae0fff53;
	self.var_d15b9a33 = "spawner_bo3_dragon_whelp";
	self.var_956fba75 = 0;
	self.var_5307dedb = 0;
	if(isdefined(self.var_cc844f4c) && self.var_cc844f4c)
	{
		self.var_cc844f4c = 0;
	}
	if(isdefined(self.var_4bd1ce6b))
	{
		self function_22d7caeb();
	}
	do
	{
		self waittill("new_hero_weapon", weapon);
	}
	while(!weapon != self.var_207d01be);
	if(isdefined(self.var_85466cc5) && isdefined(self.var_85466cc5["dragon_gauntlet_flamethrower"]))
	{
		self SetWeaponAmmoClip(level.var_207d01be, self.var_85466cc5["dragon_gauntlet_flamethrower"]);
		self.var_85466cc5 = undefined;
	}
	else
	{
		self SetWeaponAmmoClip(self.var_207d01be, self.var_207d01be.clipSize);
	}
	if(isdefined(self.var_f7f91f37))
	{
		self GadgetPowerSet(0, self.var_f7f91f37);
		self.var_f7f91f37 = undefined;
	}
	else
	{
		self GadgetPowerSet(0, 100);
	}
	self thread weapon_change_watcher();
}

/*
	Name: reset_after_bleeding_out
	Namespace: namespace_2ef08cd1
	Checksum: 0x3078337
	Offset: 0xBA0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function reset_after_bleeding_out()
{
	self endon("disconnect");
	self waittill("spawned_player");
	self function_421902c5();
	self thread function_44774881();
}

/*
	Name: function_421902c5
	Namespace: namespace_2ef08cd1
	Checksum: 0x6188835
	Offset: 0xBF8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_421902c5()
{
	player = self;
	if(isdefined(player.var_cc844f4c) && player.var_cc844f4c)
	{
		player thread function_22d7caeb();
	}
}

/*
	Name: function_99a68dd
	Namespace: namespace_2ef08cd1
	Checksum: 0x3A2A6B65
	Offset: 0xC58
	Size: 0xFF
	Parameters: 0
	Flags: None
*/
function function_99a68dd()
{
	player = self;
	player zm_weapons::weapon_give(self.var_207d01be, 0, 1);
	player thread zm_equipment::show_hint_text(&"DLC3_WEAP_DRAGON_GAUNTLET_USE_HINT", 3);
	player.var_8afc8427 = 100;
	player.hero_power = 100;
	player GadgetPowerSet(0, 100);
	player zm_hero_weapon::set_hero_weapon_state(self.var_207d01be, 2);
	player SetWeaponAmmoClip(self.var_207d01be, self.var_207d01be.clipSize);
	player.var_fd007e55 = 1;
}

/*
	Name: function_36f6c07f
	Namespace: namespace_2ef08cd1
	Checksum: 0xF5D3BE02
	Offset: 0xD60
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function function_36f6c07f(var_147067e4)
{
	self.var_147067e4 = var_147067e4;
}

/*
	Name: function_712b36f9
	Namespace: namespace_2ef08cd1
	Checksum: 0x16735161
	Offset: 0xD80
	Size: 0x233
	Parameters: 1
	Flags: None
*/
function function_712b36f9(var_40c4a571)
{
	if(isdefined(self.var_cc844f4c) && self.var_cc844f4c)
	{
		self function_22d7caeb();
	}
	if(!(isdefined(self.var_d0827e15) && self.var_d0827e15))
	{
		self.var_d0827e15 = 1;
		self zm_audio::create_and_play_dialog("whelp", "aquire");
	}
	self zm_hero_weapon::default_wield(var_40c4a571);
	self function_36f6c07f(3);
	self SetWeaponAmmoClip(var_40c4a571, var_40c4a571.clipSize);
	self.var_8afc8427 = self GadgetPowerGet(0);
	self.hero_power = self GadgetPowerGet(0);
	self disableOffhandWeapons();
	if(isdefined(self.var_8afc8427))
	{
		self GadgetPowerSet(0, self.var_8afc8427);
	}
	self.hero_power = self GadgetPowerGet(0);
	self notify("stop_draining_hero_weapon");
	if(!isdefined(self.var_956fba75) || self.var_956fba75 < 3)
	{
		self thread zm_equipment::show_hint_text(&"DLC3_WEAP_DRAGON_GAUNTLET_FLAMETHROWER_HINT", 3);
		self.var_956fba75 = self.var_956fba75 + 1;
	}
	self thread zm_hero_weapon::continue_draining_hero_weapon(self.var_207d01be);
	self.var_4c8e9f40 = GetTime() + 1000;
	self thread function_c0093887();
	self thread function_22a08c51(var_40c4a571);
}

/*
	Name: function_b90c6ba
	Namespace: namespace_2ef08cd1
	Checksum: 0x81E25C37
	Offset: 0xFC0
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function function_b90c6ba(var_40c4a571)
{
	self notify("hash_e48b9ad6");
	self.var_8afc8427 = self GadgetPowerGet(0);
	self.hero_power = self GadgetPowerGet(0);
	self zm_hero_weapon::default_unwield(var_40c4a571);
	self function_36f6c07f(1);
	self notify("stop_draining_hero_weapon");
	self EnableOffhandWeapons();
	if(zm_weapons::has_weapon_or_attachments(var_40c4a571))
	{
		self SetWeaponAmmoClip(var_40c4a571, 0);
	}
}

/*
	Name: function_f79afde0
	Namespace: namespace_2ef08cd1
	Checksum: 0x7FC9F7D3
	Offset: 0x10B0
	Size: 0x1DB
	Parameters: 1
	Flags: None
*/
function function_f79afde0(var_dabe8ae8)
{
	self zm_hero_weapon::default_wield(var_dabe8ae8);
	self function_36f6c07f(3);
	self SetWeaponAmmoClip(var_dabe8ae8, var_dabe8ae8.clipSize);
	self.var_8afc8427 = self GadgetPowerGet(0);
	self.hero_power = self GadgetPowerGet(0);
	self disableOffhandWeapons();
	if(isdefined(self.var_8afc8427))
	{
		self GadgetPowerSet(0, self.var_8afc8427);
	}
	if(!isdefined(self.var_5307dedb) || self.var_5307dedb < 3)
	{
		self thread zm_equipment::show_hint_text(&"DLC3_WEAP_DRAGON_GAUNTLET_MELEE_HINT", 3);
		self.var_5307dedb = self.var_5307dedb + 1;
	}
	self.hero_power = self GadgetPowerGet(0);
	self notify("stop_draining_hero_weapon");
	self thread zm_hero_weapon::continue_draining_hero_weapon(self.var_ae0fff53);
	self thread function_d7a4275d();
	self thread function_62d6a233();
	self thread function_8e2014a0();
	self thread function_22a08c51(var_dabe8ae8);
}

/*
	Name: function_d638417f
	Namespace: namespace_2ef08cd1
	Checksum: 0x62D44725
	Offset: 0x1298
	Size: 0x173
	Parameters: 1
	Flags: None
*/
function function_d638417f(var_dabe8ae8)
{
	self notify("hash_20599947");
	self.var_8afc8427 = self GadgetPowerGet(0);
	self.hero_power = self GadgetPowerGet(0);
	self zm_hero_weapon::default_unwield(var_dabe8ae8);
	self function_36f6c07f(1);
	self EnableOffhandWeapons();
	if(zm_weapons::has_weapon_or_attachments(var_dabe8ae8))
	{
		self SetWeaponAmmoClip(var_dabe8ae8, 0);
	}
	self notify("stop_draining_hero_weapon");
	if(self zm_weapons::has_weapon_or_attachments(var_dabe8ae8))
	{
		self SetWeaponAmmoClip(var_dabe8ae8, 0);
	}
	if(isdefined(self.var_cc844f4c) && self.var_cc844f4c)
	{
		self thread zm_hero_weapon::continue_draining_hero_weapon(self.var_ae0fff53);
		self thread zm_hero_weapon::continue_draining_hero_weapon(self.var_207d01be);
	}
}

/*
	Name: weapon_change_watcher
	Namespace: namespace_2ef08cd1
	Checksum: 0xDBF74E8B
	Offset: 0x1418
	Size: 0x1FF
	Parameters: 0
	Flags: None
*/
function weapon_change_watcher()
{
	self endon("disconnect");
	self.var_f2a52896 = undefined;
	while(1)
	{
		self waittill("weapon_change", w_current, w_previous);
		if(w_current === level.var_207d01be)
		{
			if(self.var_f2a52896 === "wpn_t7_zmb_dlc3_gauntlet_dragon_elbow_upg_world")
			{
				self Detach(self.var_f2a52896, "J_Elbow_RI");
			}
			self.var_f2a52896 = "wpn_t7_zmb_dlc3_gauntlet_dragon_elbow_world";
			self Attach(self.var_f2a52896, "J_Elbow_RI");
		}
		else if(w_current === level.var_ae0fff53)
		{
			if(self.var_f2a52896 === "wpn_t7_zmb_dlc3_gauntlet_dragon_elbow_world")
			{
				self Detach(self.var_f2a52896, "J_Elbow_RI");
			}
			self.var_f2a52896 = "wpn_t7_zmb_dlc3_gauntlet_dragon_elbow_upg_world";
			self Attach(self.var_f2a52896, "J_Elbow_RI");
		}
		else if(isdefined(self.var_f2a52896))
		{
			self Detach(self.var_f2a52896, "J_Elbow_RI");
			self.var_f2a52896 = undefined;
		}
		if(isdefined(w_previous) && w_previous.name !== "none" && zm_utility::is_hero_weapon(w_current) && !zm_utility::is_hero_weapon(w_previous))
		{
			self.var_a1ee595 = w_previous;
		}
	}
}

/*
	Name: function_22a08c51
	Namespace: namespace_2ef08cd1
	Checksum: 0xC371313E
	Offset: 0x1620
	Size: 0x11D
	Parameters: 1
	Flags: None
*/
function function_22a08c51(weapon)
{
	self endon("death");
	self endon("bled_out");
	self endon("disconnect");
	self endon("hash_b24d78f");
	self endon("stop_draining_hero_weapon");
	self endon("hash_9b74f71e");
	self notify("hash_22a08c51");
	self endon("hash_22a08c51");
	while(1)
	{
		if(!self laststand::player_is_in_laststand())
		{
			if(isdefined(self.var_9e2dd97) && self.var_9e2dd97 && self.hero_power < 98)
			{
				self.hero_power = 98;
				self GadgetPowerSet(0, 98);
				self.hero_power = 98;
				self.var_8afc8427 = 98;
			}
			self SetWeaponAmmoClip(weapon, weapon.clipSize);
		}
		wait(1);
	}
}

/*
	Name: function_c0093887
	Namespace: namespace_2ef08cd1
	Checksum: 0xE640FFC0
	Offset: 0x1748
	Size: 0x23B
	Parameters: 0
	Flags: None
*/
function function_c0093887()
{
	self endon("disconnect");
	self endon("hash_b24d78f");
	self endon("hash_89dc36f4");
	self notify("hash_309d2dbf");
	self endon("hash_309d2dbf");
	while(self AdsButtonPressed())
	{
		wait(0.05);
	}
	while(!(isdefined(self.var_cc844f4c) && self.var_cc844f4c))
	{
		time = GetTime();
		if(isdefined(self.var_4c8e9f40) && time < self.var_4c8e9f40)
		{
			wait(0.05);
			break;
		}
		if(self GadgetPowerGet(0) <= 3)
		{
			wait(0.05);
			break;
		}
		if(self AdsButtonPressed() && self GetCurrentWeapon() === self.var_207d01be && (!isdefined(self.var_a0a9409e) && self.var_a0a9409e) && (!isdefined(level.var_163a43e4) || !is_in_array(self, level.var_163a43e4)))
		{
			self DisableWeaponCycling();
			self function_f5802b55();
			self.var_8afc8427 = self GadgetPowerGet(0);
			self SwitchToWeapon(self.var_ae0fff53);
			while(self GetCurrentWeapon() !== self.var_ae0fff53)
			{
				wait(0.05);
			}
			self EnableWeaponCycling();
			level notify("hash_fbd59317", self);
			self notify("hash_89dc36f4");
		}
		wait(0.05);
	}
}

/*
	Name: is_in_array
	Namespace: namespace_2ef08cd1
	Checksum: 0xD82E75F2
	Offset: 0x1990
	Size: 0xA1
	Parameters: 2
	Flags: None
*/
function is_in_array(item, Array)
{
	if(isdefined(Array))
	{
		foreach(index in Array)
		{
			if(index == item)
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: function_d7a4275d
	Namespace: namespace_2ef08cd1
	Checksum: 0x73CFC544
	Offset: 0x1A40
	Size: 0x2A7
	Parameters: 0
	Flags: None
*/
function function_d7a4275d()
{
	self endon("disconnect");
	self endon("death");
	self endon("bled_out");
	self endon("hash_b24d78f");
	self endon("hash_3307435");
	while(self AdsButtonPressed())
	{
		if(isdefined(self.var_a0a9409e) && self.var_a0a9409e || (isdefined(level.var_163a43e4) && is_in_array(self, level.var_163a43e4)))
		{
			continue;
		}
		wait(0.05);
	}
	while(1)
	{
		time = GetTime();
		if(isdefined(self.var_d4b932e6) && time < self.var_d4b932e6)
		{
			wait(0.05);
			break;
		}
		if(self GadgetPowerGet(0) <= 3)
		{
			wait(0.05);
			break;
		}
		if(isdefined(self.var_9d9ac25d) && self.var_9d9ac25d)
		{
			wait(0.05);
			break;
		}
		if(self AdsButtonPressed() && self GetCurrentWeapon() === self.var_ae0fff53 || (isdefined(self.var_a0a9409e) && self.var_a0a9409e) || (isdefined(level.var_163a43e4) && is_in_array(self, level.var_163a43e4)) || !isalive(self.var_4bd1ce6b))
		{
			self DisableWeaponCycling();
			self function_22d7caeb();
			self.var_8afc8427 = self GadgetPowerGet(0);
			self SwitchToWeapon(self.var_207d01be);
			while(self GetCurrentWeapon() !== self.var_207d01be)
			{
				wait(0.05);
			}
			self EnableWeaponCycling();
			self notify("hash_3307435");
		}
		wait(0.05);
	}
}

/*
	Name: function_62d6a233
	Namespace: namespace_2ef08cd1
	Checksum: 0xB2E9807C
	Offset: 0x1CF0
	Size: 0x11F
	Parameters: 0
	Flags: None
*/
function function_62d6a233()
{
	self endon("disconnect");
	self endon("death");
	self endon("bled_out");
	self endon("hash_b24d78f");
	self endon("hash_e48b9ad6");
	self endon("hash_20599947");
	self endon("hash_3307435");
	self notify("hash_cf68b84e");
	self endon("hash_cf68b84e");
	while(1)
	{
		self util::waittill_any("weapon_melee", "weapon_melee_power");
		var_ebcc1e01 = self GetTagOrigin("tag_weapon_right");
		PhysicsExplosionCylinder(var_ebcc1e01, 96, 48, 1.5);
		self thread function_345e492a(var_ebcc1e01, 128);
		wait(0.05);
	}
}

/*
	Name: function_8e2014a0
	Namespace: namespace_2ef08cd1
	Checksum: 0x50D866A6
	Offset: 0x1E18
	Size: 0xFD
	Parameters: 0
	Flags: None
*/
function function_8e2014a0()
{
	self endon("disconnect");
	self endon("death");
	self endon("bled_out");
	self endon("hash_b24d78f");
	self endon("hash_e48b9ad6");
	self endon("hash_20599947");
	self endon("hash_3307435");
	self notify("hash_e3575e9f");
	self endon("hash_e3575e9f");
	for(;;)
	{
		self waittill("weapon_melee_juke", weapon);
		if(weapon === self.var_ae0fff53)
		{
			self playsound("zmb_rocketshield_start");
			self function_e7fe168a(weapon);
			self playsound("zmb_rocketshield_end");
			self notify("hash_206bebc2");
		}
	}
}

/*
	Name: function_e7fe168a
	Namespace: namespace_2ef08cd1
	Checksum: 0x5EBDE3A
	Offset: 0x1F20
	Size: 0x17F
	Parameters: 1
	Flags: None
*/
function function_e7fe168a(weapon)
{
	self endon("disconnect");
	self endon("death");
	self endon("bled_out");
	self endon("hash_b24d78f");
	self endon("hash_e48b9ad6");
	self endon("hash_20599947");
	self endon("hash_3307435");
	self endon("weapon_melee");
	self endon("weapon_melee_power");
	self endon("weapon_melee_charge");
	self notify("hash_c0a47e94");
	self endon("hash_c0a47e94");
	start_time = GetTime();
	while(start_time + 1000 > GetTime())
	{
		self PlayRumbleOnEntity("zod_shield_juke");
		FORWARD = AnglesToForward(self getPlayerAngles());
		velocity = self GetVelocity();
		predicted_pos = self.origin + velocity * 0.1;
		self thread function_345e492a(predicted_pos, 96);
		wait(0.1);
	}
}

/*
	Name: function_345e492a
	Namespace: namespace_2ef08cd1
	Checksum: 0x3B1FC9F3
	Offset: 0x20A8
	Size: 0x329
	Parameters: 2
	Flags: None
*/
function function_345e492a(var_ebcc1e01, radius)
{
	player = self;
	a_enemies_in_range = Array::get_all_closest(var_ebcc1e01, GetAITeamArray(level.zombie_team), undefined, undefined, radius);
	if(!isdefined(a_enemies_in_range) || a_enemies_in_range.size <= 0)
	{
		return;
	}
	foreach(enemy in a_enemies_in_range)
	{
		if(!isdefined(enemy) || (isdefined(enemy.var_96906507) && enemy.var_96906507))
		{
			continue;
		}
		range_sq = DistanceSquared(enemy.origin, var_ebcc1e01);
		radius_sq = radius * radius;
		enemy.var_96906507 = 1;
		if(range_sq > radius_sq)
		{
			continue;
		}
		WaitInQueue(level.var_af9cd4ca);
		if(isdefined(enemy) && isalive(enemy))
		{
			enemy DoDamage(enemy.health + 6000, var_ebcc1e01, player, undefined, undefined, "MOD_MELEE", 0, level.var_ae0fff53);
			if(isVehicle(enemy))
			{
				continue;
			}
			if(enemy.health <= 0)
			{
				n_random_x = RandomFloatRange(-3, 3);
				n_random_y = RandomFloatRange(-3, 3);
				player thread zm_audio::create_and_play_dialog("whelp", "punch");
				enemy StartRagdoll(1);
				enemy LaunchRagdoll(100 * VectorNormalize(enemy.origin - self.origin + (n_random_x, n_random_y, 100)), "torso_lower");
			}
		}
	}
}

/*
	Name: function_fa885ef2
	Namespace: namespace_2ef08cd1
	Checksum: 0xFF348C9D
	Offset: 0x23E0
	Size: 0x35B
	Parameters: 2
	Flags: None
*/
function function_fa885ef2(e_player, ai_enemy)
{
	if(e_player laststand::player_is_in_laststand())
	{
		return;
	}
	if(ai_enemy.damageWeapon === level.var_207d01be || ai_enemy.damageWeapon === level.var_ae0fff53)
	{
		return;
	}
	if(isdefined(e_player.var_cc844f4c) && e_player.var_cc844f4c)
	{
		return;
	}
	if(e_player.var_147067e4 === 0)
	{
		return;
	}
	if(isdefined(e_player.disable_hero_power_charging) && e_player.disable_hero_power_charging)
	{
		return;
	}
	e_player.var_8afc8427 = e_player GadgetPowerGet(0);
	if(isdefined(e_player) && isdefined(e_player.var_8afc8427))
	{
		if(isdefined(ai_enemy.heroweapon_kill_power))
		{
			n_perk_factor = 1;
			if(e_player hasPerk("specialty_overcharge"))
			{
				n_perk_factor = GetDvarFloat("gadgetPowerOverchargePerkScoreFactor");
			}
			if(isdefined(ai_enemy.damageWeapon))
			{
				weapon = ai_enemy.damageWeapon;
				if(IsSubStr(weapon.name, "elemental_bow_demongate") || IsSubStr(weapon.name, "elemental_bow_run_prison") || IsSubStr(weapon.name, "elemental_bow_storm") || IsSubStr(weapon.name, "elemental_bow_wolf_howl"))
				{
					n_perk_factor = 0.25;
				}
			}
			e_player.var_8afc8427 = e_player.var_8afc8427 + n_perk_factor * ai_enemy.heroweapon_kill_power;
			e_player.var_8afc8427 = math::clamp(e_player.var_8afc8427, 0, 100);
			if(e_player.var_8afc8427 >= e_player.hero_power_prev)
			{
				e_player GadgetPowerSet(0, e_player.var_8afc8427);
				e_player clientfield::set_player_uimodel("zmhud.swordEnergy", e_player.var_8afc8427 / 100);
				e_player clientfield::increment_uimodel("zmhud.swordChargeUpdate");
			}
		}
	}
}

/*
	Name: function_2f36d185
	Namespace: namespace_2ef08cd1
	Checksum: 0x47700A4D
	Offset: 0x2748
	Size: 0x173
	Parameters: 1
	Flags: None
*/
function function_2f36d185(weapon)
{
	self zm_hero_weapon::default_power_empty(weapon);
	self notify("stop_draining_hero_weapon");
	self notify("hash_b24d78f");
	self.var_8afc8427 = 0;
	self.hero_power = 0;
	if(isdefined(self.var_cc844f4c) && self.var_cc844f4c)
	{
		self function_22d7caeb();
	}
	current_weapon = self GetCurrentWeapon();
	if(self HasWeapon(weapon) && current_weapon === weapon)
	{
		self SetWeaponAmmoClip(weapon, 0);
	}
	if(current_weapon === self.var_207d01be || current_weapon === self.var_ae0fff53)
	{
		if(isdefined(self.var_a1ee595) && !IsSubStr(self.var_a1ee595.name, "minigun"))
		{
			self SwitchToWeapon(self.var_a1ee595);
		}
		else
		{
			self zm_weapons::switch_back_primary_weapon();
		}
	}
}

/*
	Name: function_cd7dbd9d
	Namespace: namespace_2ef08cd1
	Checksum: 0xCE863D25
	Offset: 0x28C8
	Size: 0xCF
	Parameters: 1
	Flags: None
*/
function function_cd7dbd9d(weapon)
{
	self thread zm_equipment::show_hint_text(&"DLC3_WEAP_DRAGON_GAUNTLET_USE_HINT", 3);
	self zm_hero_weapon::set_hero_weapon_state(weapon, 2);
	self function_36f6c07f(2);
	self SetWeaponAmmoClip(weapon, weapon.clipSize);
	if(!(isdefined(self.var_fd007e55) && self.var_fd007e55))
	{
		self thread zm_audio::create_and_play_dialog("whelp", "ready");
	}
	self.var_fd007e55 = 0;
}

/*
	Name: function_f5802b55
	Namespace: namespace_2ef08cd1
	Checksum: 0xCE3ABDE3
	Offset: 0x29A0
	Size: 0x193
	Parameters: 0
	Flags: None
*/
function function_f5802b55()
{
	if(isdefined(self.var_cc844f4c) && self.var_cc844f4c || isdefined(self.var_4bd1ce6b))
	{
		return;
	}
	self.var_cc844f4c = 1;
	spawn_pos = self GetTagOrigin("tag_dragon_world");
	spawn_angles = self GetTagAngles("tag_dragon_world");
	var_42c06d64 = SpawnVehicle(self.var_d15b9a33, spawn_pos, spawn_angles);
	if(isdefined(var_42c06d64))
	{
		self.var_4bd1ce6b = var_42c06d64;
		var_42c06d64 ai::set_ignoreme(1);
		var_42c06d64 SetIgnorePauseWorld(1);
		var_42c06d64.owner = self;
		self thread zm_audio::create_and_play_dialog("whelp", "command");
		var_42c06d64 thread function_44ecb9cb();
		var_42c06d64 thread function_b80d5548();
		self thread function_1692b405();
	}
	self.var_d4b932e6 = GetTime() + 1000;
}

/*
	Name: function_44ecb9cb
	Namespace: namespace_2ef08cd1
	Checksum: 0xD7D9C291
	Offset: 0x2B40
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_44ecb9cb()
{
	self endon("death");
	self ghost();
	wait(0.15);
	self show();
}

/*
	Name: function_1692b405
	Namespace: namespace_2ef08cd1
	Checksum: 0x39E3894
	Offset: 0x2B90
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_1692b405()
{
	self notify("hash_22d7caeb");
	self endon("hash_22d7caeb");
	self waittill("entering_last_stand");
	self thread function_22d7caeb();
}

/*
	Name: function_22d7caeb
	Namespace: namespace_2ef08cd1
	Checksum: 0x7F97B335
	Offset: 0x2BE0
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function function_22d7caeb()
{
	self notify("hash_22d7caeb");
	self.var_cc844f4c = 0;
	if(isdefined(self.var_4bd1ce6b))
	{
		var_42c06d64 = self.var_4bd1ce6b;
		var_42c06d64 notify("hash_22d7caeb");
		var_42c06d64.dragon_recall_death = 1;
		var_42c06d64.var_a0e2dfff = 1;
		var_42c06d64 kill();
	}
}

/*
	Name: function_b80d5548
	Namespace: namespace_2ef08cd1
	Checksum: 0x880B5889
	Offset: 0x2C78
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function function_b80d5548()
{
	while(isdefined(self))
	{
		if(!isdefined(self.owner) || self.owner laststand::player_is_in_laststand())
		{
			self.dragon_recall_death = 1;
			self.var_a0e2dfff = 1;
			self kill();
		}
		wait(0.25);
	}
}

/*
	Name: function_cb315e40
	Namespace: namespace_2ef08cd1
	Checksum: 0xBB41D809
	Offset: 0x2CF0
	Size: 0x255
	Parameters: 12
	Flags: None
*/
function function_cb315e40(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if(isdefined(attacker) && isPlayer(attacker))
	{
		if(isdefined(weapon) && weapon === level.var_207d01be)
		{
			if(meansOfDeath === "MOD_BURNED")
			{
				self.weapon_specific_fire_death_torso_fx = "dlc3/stalingrad/fx_fire_torso_zmb_green";
				self.weapon_specific_fire_death_sm_fx = "dlc3/stalingrad/fx_fire_generic_zmb_green";
				if(self.archetype === "zombie" || (isdefined(level.zombie_vars[attacker.team]) && (isdefined(level.zombie_vars[attacker.team]["zombie_insta_kill"]) && level.zombie_vars[attacker.team]["zombie_insta_kill"])))
				{
					damage = self.health + 6000;
					attacker thread zm_audio::create_and_play_dialog("whelp", "flamethrower_kill");
					return damage;
				}
			}
			if(meansOfDeath === "MOD_MELEE" && (!isdefined(self.var_96906507) && self.var_96906507))
			{
				damage = self.health + 6000;
				self.deathFunction = &function_cb6fb97;
				return damage;
			}
		}
		if(isdefined(weapon) && weapon === level.var_ae0fff53)
		{
			if(meansOfDeath === "MOD_MELEE" && (!isdefined(self.var_96906507) && self.var_96906507))
			{
				damage = self.health + 6000;
				self.deathFunction = &function_d775fe77;
				return damage;
			}
		}
	}
	return -1;
}

/*
	Name: function_d775fe77
	Namespace: namespace_2ef08cd1
	Checksum: 0x527B208B
	Offset: 0x2F50
	Size: 0x103
	Parameters: 8
	Flags: None
*/
function function_d775fe77(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime)
{
	n_random_x = RandomFloatRange(-3, 3);
	n_random_y = RandomFloatRange(-3, 3);
	self StartRagdoll(1);
	self LaunchRagdoll(100 * VectorNormalize(self.origin - attacker.origin + (n_random_x, n_random_y, 100)), "torso_lower");
}

/*
	Name: function_cb6fb97
	Namespace: namespace_2ef08cd1
	Checksum: 0x6375ECB1
	Offset: 0x3060
	Size: 0x11B
	Parameters: 8
	Flags: None
*/
function function_cb6fb97(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime)
{
	GibServerUtils::GibHead(self);
	n_random_x = RandomFloatRange(-3, 3);
	n_random_y = RandomFloatRange(-3, 3);
	self StartRagdoll(1);
	self LaunchRagdoll(100 * VectorNormalize(self.origin - attacker.origin + (n_random_x, n_random_y, 100)), "torso_lower");
}

/*
	Name: function_a23fb854
	Namespace: namespace_2ef08cd1
	Checksum: 0x5FFB6F76
	Offset: 0x3188
	Size: 0x747
	Parameters: 0
	Flags: None
*/
function function_a23fb854()
{
	/#
		wait(0.05);
		level waittill("start_zombie_round_logic");
		wait(0.05);
		var_40c4a571 = self.var_207d01be;
		var_f86eaea5 = var_40c4a571.name;
		str_cmd = "Dev Block strings are not supported" + var_f86eaea5 + "Dev Block strings are not supported";
		AddDebugCommand(str_cmd);
		str_cmd = "Dev Block strings are not supported" + var_f86eaea5 + "Dev Block strings are not supported";
		AddDebugCommand(str_cmd);
		str_cmd = "Dev Block strings are not supported" + var_f86eaea5 + "Dev Block strings are not supported";
		AddDebugCommand(str_cmd);
		str_cmd = "Dev Block strings are not supported" + var_f86eaea5 + "Dev Block strings are not supported";
		AddDebugCommand(str_cmd);
		str_cmd = "Dev Block strings are not supported";
		AddDebugCommand(str_cmd);
		str_cmd = "Dev Block strings are not supported";
		AddDebugCommand(str_cmd);
		while(1)
		{
			var_f86eaea5 = GetDvarString("Dev Block strings are not supported");
			if(var_f86eaea5 != "Dev Block strings are not supported")
			{
				foreach(player in GetPlayers())
				{
					if(var_f86eaea5 == var_40c4a571.name)
					{
						player function_99a68dd();
					}
				}
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			var_f86eaea5 = GetDvarString("Dev Block strings are not supported");
			if(var_f86eaea5 != "Dev Block strings are not supported")
			{
				foreach(player in GetPlayers())
				{
					if(var_f86eaea5 == var_40c4a571.name)
					{
						player GadgetPowerSet(0, 100);
						player.var_8afc8427 = 100;
						player.hero_power = 100;
					}
				}
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			var_f86eaea5 = GetDvarString("Dev Block strings are not supported");
			if(var_f86eaea5 != "Dev Block strings are not supported")
			{
				foreach(player in GetPlayers())
				{
					if(var_f86eaea5 == var_40c4a571.name)
					{
						player GadgetPowerSet(0, 100);
						player.var_8afc8427 = 100;
						player.var_9e2dd97 = 1;
					}
				}
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			var_f86eaea5 = GetDvarString("Dev Block strings are not supported");
			if(var_f86eaea5 != "Dev Block strings are not supported")
			{
				foreach(player in GetPlayers())
				{
					if(var_f86eaea5 == var_40c4a571.name)
					{
						player.var_9e2dd97 = 0;
					}
				}
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			string = GetDvarString("Dev Block strings are not supported");
			if(string === "Dev Block strings are not supported")
			{
				foreach(player in GetPlayers())
				{
					player thread function_82f11e44();
				}
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			string = GetDvarString("Dev Block strings are not supported");
			if(string === "Dev Block strings are not supported")
			{
				foreach(player in GetPlayers())
				{
					player function_c2e5ffc1();
				}
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_82f11e44
	Namespace: namespace_2ef08cd1
	Checksum: 0xFC7184E3
	Offset: 0x38D8
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function function_82f11e44()
{
	/#
		self endon("disconnect");
		self endon("death");
		self endon("bled_out");
		self endon("hash_bd42c97e");
		while(1)
		{
			self EnableInvulnerability();
			wait(0.5);
		}
	#/
}

/*
	Name: function_c2e5ffc1
	Namespace: namespace_2ef08cd1
	Checksum: 0x12F83EF8
	Offset: 0x3940
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_c2e5ffc1()
{
	/#
		self notify("hash_bd42c97e");
		self DisableInvulnerability();
	#/
}

