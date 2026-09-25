#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\grapple;
#using scripts\zm\_bb;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_altbody;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_lightning_chain;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_zod_util;

#namespace namespace_215602b6;

/*
	Name: __init__sytem__
	Namespace: namespace_215602b6
	Checksum: 0x5F3C5E87
	Offset: 0xB18
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_altbody_beast", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_215602b6
	Checksum: 0x4DAA56FE
	Offset: 0xB60
	Size: 0x5B1
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("missile", "bminteract", 1, 2, "int");
	clientfield::register("scriptmover", "bminteract", 1, 2, "int");
	clientfield::register("actor", "bm_zombie_melee_kill", 1, 1, "int");
	clientfield::register("actor", "bm_zombie_grapple_kill", 1, 1, "int");
	clientfield::register("toplayer", "beast_blood_on_player", 1, 1, "counter");
	clientfield::register("world", "bm_superbeast", 1, 1, "int");
	level thread function_10dcd1d5("beast_mode_kiosk");
	loadout = Array("zombie_beast_grapple_dwr", "zombie_beast_lightning_dwl", "zombie_beast_lightning_dwl2", "zombie_beast_lightning_dwl3");
	var_5a9f87fa = zm_weapons::create_loadout(loadout);
	var_55affbc1 = Array("zm_bgb_disorderly_combat");
	zm_altbody::init("beast_mode", "beast_mode_kiosk", &"ZM_ZOD_ENTER_BEAST_MODE", "zombie_beast_2", 123, var_5a9f87fa, 4, &function_1699b690, &function_b2631b3c, &function_ee30fba9, &"ZM_ZOD_CANT_ENTER_BEAST_MODE", var_55affbc1);
	callback::on_connect(&player_on_connect);
	callback::on_spawned(&player_on_spawned);
	callback::on_player_killed(&function_fc79a296);
	level.var_87ee6f27 = 4;
	level._effect["human_disappears"] = "zombie/fx_bmode_transition_zmb";
	level._effect["zombie_disappears"] = "zombie/fx_bmode_transition_zmb";
	level._effect["beast_shock"] = "zombie/fx_tesla_shock_zmb";
	level._effect["beast_shock_box"] = "zombie/fx_bmode_dest_pwrbox_zod_zmb";
	level._effect["beast_melee_kill"] = "zombie/fx_bmode_attack_grapple_zod_zmb";
	level._effect["beast_grapple_kill"] = "zombie/fx_bmode_attack_grapple_zod_zmb";
	level._effect["beast_return_aoe"] = "zombie/fx_bmode_attack_grapple_zod_zmb";
	level._effect["beast_return_aoe_kill"] = "zombie/fx_bmode_attack_grapple_zod_zmb";
	level._effect["beast_shock_aoe"] = "zombie/fx_bmode_shock_lvl3_zod_zmb";
	level._effect["beast_3p_trail"] = "zombie/fx_bmode_trail_3p_zod_zmb";
	level.grapple_valid_target_check = &grapple_valid_target_check;
	level.var_8a41ce54 = &function_8a41ce54;
	level.grapple_notarget_distance = 120;
	level.grapple_notarget_enabled = 0;
	zm_spawner::register_zombie_damage_callback(&function_f4ee06b4);
	zm_spawner::register_zombie_death_event_callback(&function_d166ff57);
	/#
		thread function_ae9ea3e4();
	#/
	triggers = GetEntArray("trig_beast_mode_kiosk", "targetname");
	foreach(trigger in triggers)
	{
		trigger delete();
	}
	triggers = GetEntArray("trig_beast_mode_kiosk_unavailable", "targetname");
	foreach(trigger in triggers)
	{
		trigger delete();
	}
}

/*
	Name: __main__
	Namespace: namespace_215602b6
	Checksum: 0x9F6A4B4C
	Offset: 0x1120
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function __main__()
{
	thread function_31a1c2c8();
	thread function_d0eeb393();
	thread function_feaada2a();
	thread function_7de05274();
	zm_spawner::add_custom_zombie_spawn_logic(&function_a51e085);
	function_3e9ddcc7();
	level.var_f68f0aeb = GetWeapon("syrette_zod_beast");
}

/*
	Name: function_5613b340
	Namespace: namespace_215602b6
	Checksum: 0x6948187D
	Offset: 0x11C0
	Size: 0x1D
	Parameters: 1
	Flags: None
*/
function function_5613b340(var_2954d4df)
{
	if(!isdefined(var_2954d4df))
	{
		var_2954d4df = 0;
	}
}

/*
	Name: function_9f177855
	Namespace: namespace_215602b6
	Checksum: 0x23858842
	Offset: 0x11E8
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function function_9f177855(washuman)
{
	self ghost();
}

/*
	Name: function_1699b690
	Namespace: namespace_215602b6
	Checksum: 0x951F79E5
	Offset: 0x1218
	Size: 0x5C3
	Parameters: 2
	Flags: None
*/
function function_1699b690(name, trigger)
{
	/#
		Assert(!isdefined(self.beastmode) && self.beastmode);
	#/
	self notify("clear_red_flashing_overlay");
	self disableOffhandWeapons();
	self zm_weapons::suppress_stowed_weapon(1);
	self function_d60ab790(1);
	self function_cf361e94(1);
	self.var_e98bf35e = self.var_b2356a6c;
	self.var_806d7078 = self.var_227fe352;
	self zm_utility::create_streamer_hint(self.origin, self.angles + VectorScale((0, 1, 0), 180), 0.25);
	self thread function_5613b340();
	self playsound("evt_beastmode_enter");
	if(!isdefined(self.firstTime))
	{
		self.firstTime = 1;
		level.var_9ecbc81 = self.characterindex;
		level notify("hash_571c8e3c");
	}
	self function_9f177855(1);
	self.var_a1e8a771 = self.overridePlayerDamage;
	self.overridePlayerDamage = &function_2ff8ae81;
	self.weaponReviveTool = level.var_f68f0aeb;
	self.get_revive_time = &function_5b552caf;
	self zm_utility::increment_ignoreme();
	self.beastmode = 1;
	self.inhibit_scoring_from_zombies = 1;
	self flag::set("in_beastmode");
	bb::function_e367a93e(self, "enter_beast_mode");
	self RecordMapEvent(1, GetTime(), self.origin, level.round_number);
	self AllowStand(1);
	self AllowProne(0);
	self AllowCrouch(0);
	self AllowAds(0);
	self AllowJump(1);
	self function_4651aaf7(0);
	self setMoveSpeedScale(1);
	self SetSprintDuration(4);
	self SetSprintCooldown(0);
	self function_a1b60d91(1);
	self zm_utility::increment_is_drinking();
	self StopShellshock();
	self setPerk("specialty_unlimitedsprint");
	self setPerk("specialty_fallheight");
	self setPerk("specialty_lowgravity");
	wait(0.1);
	self show();
	self thread function_d52a054b();
	self thread function_568f6019();
	self thread function_85f2cde9();
	self thread function_e8aacc36();
	self thread function_8b382e19();
	self thread function_89419316();
	self thread function_5e1ffae();
	self thread function_ce0d3f8c();
	self thread function_f893b14f();
	self thread function_126b475f();
	self thread function_19356f33();
	self thread function_92acebd3();
	if(level clientfield::get("bm_superbeast"))
	{
		self function_5c185b9f();
	}
	/#
		var_1ee18766 = GetDvarInt("Dev Block strings are not supported") > 0;
		self thread function_5d7a94fa();
	#/
}

/*
	Name: function_5d7a94fa
	Namespace: namespace_215602b6
	Checksum: 0xAC0B168C
	Offset: 0x17E8
	Size: 0x189
	Parameters: 1
	Flags: None
*/
function function_5d7a94fa(localClientNum)
{
	self endon("hash_b2631b3c");
	var_3f39d2cc = 0;
	while(isdefined(self))
	{
		var_1ee18766 = GetDvarInt("scr_beast_no_visionset") > 0;
		if(var_1ee18766 != var_3f39d2cc)
		{
			name = "beast_mode";
			visionset = "zombie_beast_2";
			if(var_1ee18766)
			{
				if(isdefined(visionset))
				{
					visionset_mgr::deactivate("visionset", visionset, self);
					self.var_a8e4afcf[name] = 0;
				}
			}
			else if(isdefined(visionset))
			{
				if(isdefined(self.var_a8e4afcf[name]) && self.var_a8e4afcf[name])
				{
					visionset_mgr::deactivate("visionset", visionset, self);
					util::wait_network_frame();
					util::wait_network_frame();
					if(!isdefined(self))
					{
						return;
					}
				}
				visionset_mgr::activate("visionset", visionset, self);
				self.var_a8e4afcf[name] = 1;
			}
		}
		var_3f39d2cc = var_1ee18766;
		wait(1);
	}
}

/*
	Name: function_5c185b9f
	Namespace: namespace_215602b6
	Checksum: 0xD776B18
	Offset: 0x1980
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function function_5c185b9f()
{
	self zm_utility::decrement_ignoreme();
	self.var_e3e3d706 = 1;
	self.var_ff6ba411 = 1;
	self.var_ce25e278 = 1;
	self.var_1333176 = &function_57c301a6;
	self DisableInvulnerability();
	self thread function_f3cafba8();
	bb::function_e367a93e(self, "enter_superbeast_mode");
	self RecordMapEvent(2, GetTime(), self.origin, level.round_number);
}

/*
	Name: function_57c301a6
	Namespace: namespace_215602b6
	Checksum: 0x889B4317
	Offset: 0x1A60
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function function_57c301a6(trigger, name)
{
	level notify("hash_9712055e", trigger.var_8042e4e2);
	self.var_e3e3d706 = 1;
	self function_a1b60d91(1);
}

/*
	Name: function_f3cafba8
	Namespace: namespace_215602b6
	Checksum: 0xEE3DAED4
	Offset: 0x1AC8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_f3cafba8()
{
	self endon("hash_b2631b3c");
	while(isdefined(self))
	{
		self.var_39f3c137 = self.var_e3e3d706;
		wait(0.05);
	}
}

/*
	Name: function_b2631b3c
	Namespace: namespace_215602b6
	Checksum: 0xC48B8418
	Offset: 0x1B08
	Size: 0x3A3
	Parameters: 2
	Flags: None
*/
function function_b2631b3c(name, trigger)
{
	/#
		Assert(isdefined(self.beastmode) && self.beastmode);
	#/
	self notify("clear_red_flashing_overlay");
	self thread function_5613b340(0);
	self function_9f177855(0);
	self function_a1b60d91(0);
	if(self IsThrowingGrenade())
	{
		self forcegrenadethrow();
	}
	if(0)
	{
		wait(0);
	}
	self notify("hash_b2631b3c");
	bb::function_e367a93e(self, "exit_beast_mode");
	self thread function_2d0dc9ac(2);
	self thread function_a8f77c9b(3);
	while(self IsThrowingGrenade() || self IsGrappling() || (isdefined(self.teleporting) && self.teleporting))
	{
		wait(0.05);
	}
	self unsetPerk("specialty_unlimitedsprint");
	self unsetPerk("specialty_fallheight");
	self unsetPerk("specialty_lowgravity");
	self setMoveSpeedScale(1);
	self AllowStand(1);
	self AllowProne(1);
	self AllowCrouch(1);
	self AllowAds(1);
	self AllowJump(1);
	self function_7c34e9c7(0);
	self function_4651aaf7(1);
	self StopShellshock();
	self.inhibit_scoring_from_zombies = 0;
	self.beastmode = 0;
	self flag::clear("in_beastmode");
	self.get_revive_time = undefined;
	self.weaponReviveTool = undefined;
	self.overridePlayerDamage = self.var_a1e8a771;
	self.var_a1e8a771 = undefined;
	if(level clientfield::get("bm_superbeast"))
	{
		var_66a6ef71 = 1;
		self.var_e3e3d706 = 0;
		self.var_ff6ba411 = 0;
		self.var_ce25e278 = 0;
		self.var_1333176 = undefined;
	}
	else
	{
		var_66a6ef71 = 0;
	}
	self thread function_2af409b0(var_66a6ef71);
}

/*
	Name: function_2af409b0
	Namespace: namespace_215602b6
	Checksum: 0x1617416E
	Offset: 0x1EB8
	Size: 0x643
	Parameters: 1
	Flags: None
*/
function function_2af409b0(var_ee3c4cad)
{
	self SetOrigin(self.var_e98bf35e);
	self FreezeControls(1);
	var_3c5e6535 = self.var_e98bf35e + VectorScale((0, 0, 1), 60);
	a_ai = GetAITeamArray(level.zombie_team);
	a_closest = [];
	ai_closest = undefined;
	if(a_ai.size)
	{
		a_closest = ArraySortClosest(a_ai, self.var_e98bf35e);
		foreach(ai in a_closest)
		{
			var_9518d12f = ai SightConeTrace(var_3c5e6535, self);
			if(var_9518d12f > 0.2)
			{
				ai_closest = ai;
				break;
			}
		}
		if(isdefined(ai_closest))
		{
			self SetPlayerAngles(VectorToAngles(ai_closest GetCentroid() - var_3c5e6535));
		}
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 1)
		{
			ai_closest = self;
			self EnableInvulnerability();
		}
	#/
	if(!isdefined(ai_closest))
	{
		self SetPlayerAngles(self.var_806d7078 + VectorScale((0, 1, 0), 180));
	}
	wait(0.5);
	self zm_utility::decrement_is_drinking();
	self zm_weapons::suppress_stowed_weapon(0);
	self show();
	self playsound("evt_beastmode_exit");
	self zm_utility::clear_streamer_hint();
	playFX(level._effect["human_disappears"], self.var_e98bf35e);
	playFX(level._effect["beast_return_aoe"], self.var_e98bf35e);
	a_ai = GetAIArray();
	var_aca0d7c7 = ArraySortClosest(a_ai, self.var_e98bf35e, a_ai.size, 0, 200);
	foreach(ai in var_aca0d7c7)
	{
		if(IsActor(ai))
		{
			if(ai.archetype === "zombie")
			{
				playFX(level._effect["beast_return_aoe_kill"], ai GetTagOrigin("j_spineupper"));
			}
			else
			{
				playFX(level._effect["beast_return_aoe_kill"], ai.origin);
			}
			ai.no_powerups = 1;
			ai.marked_for_recycle = 1;
			ai.has_been_damaged_by_player = 0;
			ai.deathpoints_already_given = 1;
			ai DoDamage(ai.health + 1000, self.var_e98bf35e, self);
		}
	}
	wait(0.2);
	if(!self zm::in_life_brush() && (self zm::in_kill_brush() || !self zm::in_enabled_playable_area()))
	{
		wait(3);
	}
	if(isdefined(self.firstTime) && self.firstTime)
	{
		self.firstTime = 0;
	}
	if(!level.intermission)
	{
		self FreezeControls(0);
	}
	wait(3);
	var_a315b31f = level clientfield::get("bm_superbeast");
	if(!var_ee3c4cad && !var_a315b31f)
	{
		self zm_utility::decrement_ignoreme();
	}
	level notify("hash_43352218", self);
	self thread zm_audio::create_and_play_dialog("beastmode", "exit");
}

/*
	Name: function_2d0dc9ac
	Namespace: namespace_215602b6
	Checksum: 0xC0A4AB60
	Offset: 0x2508
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_2d0dc9ac(time)
{
	was_inv = self EnableInvulnerability();
	wait(time);
	if(isdefined(self) && (!isdefined(was_inv) && was_inv))
	{
		self DisableInvulnerability();
	}
}

/*
	Name: function_a8f77c9b
	Namespace: namespace_215602b6
	Checksum: 0x3ECB7F90
	Offset: 0x2578
	Size: 0x16F
	Parameters: 1
	Flags: None
*/
function function_a8f77c9b(time)
{
	self disableOffhandWeapons();
	wait(time);
	if(isdefined(self))
	{
		self EnableOffhandWeapons();
	}
	if(isdefined(self.var_9fbddc54) && self.var_9fbddc54)
	{
		lethal_grenade = self zm_utility::get_player_lethal_grenade();
		if(!self HasWeapon(lethal_grenade))
		{
			self GiveWeapon(lethal_grenade);
			self SetWeaponAmmoClip(lethal_grenade, 0);
		}
		frac = self GetFractionMaxAmmo(lethal_grenade);
		if(frac < 0.25)
		{
			self SetWeaponAmmoClip(lethal_grenade, 2);
		}
		else if(frac < 0.5)
		{
			self SetWeaponAmmoClip(lethal_grenade, 3);
		}
		else
		{
			self SetWeaponAmmoClip(lethal_grenade, 4);
		}
	}
	self.var_9fbddc54 = 0;
}

/*
	Name: function_ee30fba9
	Namespace: namespace_215602b6
	Checksum: 0xD0755861
	Offset: 0x26F0
	Size: 0xE7
	Parameters: 2
	Flags: None
*/
function function_ee30fba9(name, var_8042e4e2)
{
	var_a315b31f = level clientfield::get("bm_superbeast");
	if(!level flagsys::get("start_zombie_round_logic"))
	{
		return 0;
	}
	if(isdefined(self.beastmode) && self.beastmode && !var_a315b31f)
	{
		return 0;
	}
	if(isdefined(var_8042e4e2) && !function_de85da07(var_8042e4e2))
	{
		return 0;
	}
	if(level clientfield::get("bm_superbeast"))
	{
		return 1;
	}
	return self.var_5e82a563 >= 1;
}

/*
	Name: function_de85da07
	Namespace: namespace_215602b6
	Checksum: 0xEDC001EB
	Offset: 0x27E0
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function function_de85da07(var_8042e4e2)
{
	return !isdefined(var_8042e4e2.var_b55b4180) && var_8042e4e2.var_b55b4180;
}

/*
	Name: player_on_connect
	Namespace: namespace_215602b6
	Checksum: 0x124C36E8
	Offset: 0x2818
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function player_on_connect()
{
	self flag::init("in_beastmode");
}

/*
	Name: player_on_spawned
	Namespace: namespace_215602b6
	Checksum: 0xAFA1D322
	Offset: 0x2848
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function player_on_spawned()
{
	level flag::wait_till("initial_players_connected");
	self.var_39f3c137 = 1;
	if(level flag::get("solo_game"))
	{
		self.var_5e82a563 = 3;
	}
	else
	{
		self.var_5e82a563 = 1;
	}
	self thread function_437c4521();
	self thread function_5b1b9438();
	self function_a1b60d91(0);
}

/*
	Name: function_7de05274
	Namespace: namespace_215602b6
	Checksum: 0x34C86644
	Offset: 0x2910
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function function_7de05274()
{
	while(1)
	{
		level waittill("powerup_dropped", powerup);
		powerup.grapple_type = 2;
		powerup SetGrapplableType(powerup.grapple_type);
	}
}

/*
	Name: function_10dcd1d5
	Namespace: namespace_215602b6
	Checksum: 0x2BF244E
	Offset: 0x2978
	Size: 0x149
	Parameters: 1
	Flags: None
*/
function function_10dcd1d5(var_4cc12170)
{
	level.var_8ad0ec05 = struct::get_array(var_4cc12170, "targetname");
	foreach(var_8042e4e2 in level.var_8ad0ec05)
	{
		var_8042e4e2.var_80eeb471 = var_4cc12170 + "_plr_" + var_8042e4e2.origin;
		var_8042e4e2.var_39a60f4a = var_4cc12170 + "_crs_" + var_8042e4e2.origin;
		clientfield::register("world", var_8042e4e2.var_80eeb471, 1, 4, "int");
		var_8042e4e2 thread function_7237145f();
	}
}

/*
	Name: function_437c4521
	Namespace: namespace_215602b6
	Checksum: 0xE13FC731
	Offset: 0x2AD0
	Size: 0x167
	Parameters: 0
	Flags: None
*/
function function_437c4521()
{
	self endon("death");
	while(isdefined(self))
	{
		n_ent_num = self GetEntityNumber();
		foreach(var_8042e4e2 in level.var_8ad0ec05)
		{
			var_7e9601ff = level clientfield::get(var_8042e4e2.var_80eeb471);
			if(function_de85da07(var_8042e4e2))
			{
				var_7e9601ff = var_7e9601ff | 1 << n_ent_num;
			}
			else
			{
				~var_7e9601ff;
				var_7e9601ff = var_7e9601ff & 1 << n_ent_num;
			}
			level clientfield::set(var_8042e4e2.var_80eeb471, var_7e9601ff);
		}
		wait(RandomFloatRange(0.2, 0.5));
	}
}

/*
	Name: function_61dc030a
	Namespace: namespace_215602b6
	Checksum: 0x9C35D71A
	Offset: 0x2C40
	Size: 0xA5
	Parameters: 0
	Flags: None
*/
function function_61dc030a()
{
	var_ff430db0 = 0;
	foreach(var_8042e4e2 in level.var_8ad0ec05)
	{
		if(function_de85da07(var_8042e4e2))
		{
			var_ff430db0++;
		}
	}
	return var_ff430db0;
}

/*
	Name: function_f6014f2c
	Namespace: namespace_215602b6
	Checksum: 0x4ABCEC3B
	Offset: 0x2CF0
	Size: 0xF5
	Parameters: 2
	Flags: None
*/
function function_f6014f2c(v_origin, var_8ebf7724)
{
	var_21d6ddcd = ArraySortClosest(level.var_8ad0ec05, v_origin);
	var_21d6ddcd = Array::filter(var_21d6ddcd, 0, &function_b7520b09);
	for(i = 0; i < var_21d6ddcd.size && i < var_8ebf7724; i++)
	{
		namespace_8e578893::function_5cc835d6(v_origin, var_21d6ddcd[i].origin, 1);
		var_21d6ddcd[i].var_b55b4180 = 0;
		wait(0.05);
	}
}

/*
	Name: function_b7520b09
	Namespace: namespace_215602b6
	Checksum: 0xE9206972
	Offset: 0x2DF0
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function function_b7520b09(var_20fdcbbc)
{
	if(!isdefined(var_20fdcbbc) || !isdefined(var_20fdcbbc.var_b55b4180) || !var_20fdcbbc.var_b55b4180)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_feaada2a
	Namespace: namespace_215602b6
	Checksum: 0x652DC63A
	Offset: 0x2E40
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function function_feaada2a()
{
	while(1)
	{
		level waittill("hash_9712055e", var_a67f7e);
		if(isdefined(var_a67f7e))
		{
			var_a67f7e thread function_7237145f();
		}
	}
}

/*
	Name: round_number
	Namespace: namespace_215602b6
	Checksum: 0x3B7A2C2F
	Offset: 0x2E90
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function round_number()
{
	var_2c7e96f1 = 0;
	if(isdefined(level.round_number))
	{
		var_2c7e96f1 = level.round_number;
	}
	return var_2c7e96f1;
}

/*
	Name: function_7237145f
	Namespace: namespace_215602b6
	Checksum: 0xA7E37804
	Offset: 0x2EC8
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function function_7237145f()
{
	self notify("hash_7237145f");
	self endon("hash_7237145f");
	self.var_b55b4180 = 1;
	var_2c7e96f1 = round_number();
	while(round_number() - var_2c7e96f1 < 1)
	{
		level waittill("start_of_round");
	}
	self.var_b55b4180 = 0;
}

/*
	Name: function_fd8fb00d
	Namespace: namespace_215602b6
	Checksum: 0x2AF48D55
	Offset: 0x2F58
	Size: 0x10D
	Parameters: 1
	Flags: None
*/
function function_fd8fb00d(var_a48bee9b)
{
	if(!isdefined(var_a48bee9b))
	{
		var_a48bee9b = 1;
	}
	foreach(var_8042e4e2 in level.var_8ad0ec05)
	{
		if(var_a48bee9b)
		{
			if(!(isdefined(var_8042e4e2.var_b55b4180) && var_8042e4e2.var_b55b4180))
			{
				var_8042e4e2 thread function_7237145f();
			}
			continue;
		}
		if(isdefined(var_8042e4e2.var_b55b4180) && var_8042e4e2.var_b55b4180)
		{
			var_8042e4e2.var_b55b4180 = 0;
		}
	}
}

/*
	Name: function_19356f33
	Namespace: namespace_215602b6
	Checksum: 0xF193C9DA
	Offset: 0x3070
	Size: 0xDF
	Parameters: 0
	Flags: None
*/
function function_19356f33()
{
	self endon("hash_b2631b3c");
	self endon("death");
	if(!self flag::exists("beast_hint_shown"))
	{
		self flag::init("beast_hint_shown");
	}
	if(!self flag::get("beast_hint_shown"))
	{
		self thread function_cbcaefc5();
	}
	self.var_6f14dca1 = 0;
	while(isdefined(self))
	{
		if(self StanceButtonPressed())
		{
			self notify("hide_equipment_hint_text");
			self function_19b30216();
		}
		wait(0.05);
	}
}

/*
	Name: function_cbcaefc5
	Namespace: namespace_215602b6
	Checksum: 0xF6B53B9C
	Offset: 0x3158
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function function_cbcaefc5()
{
	hint = &"ZM_ZOD_EXIT_BEAST_MODE_HINT";
	y = 315;
	if(level.players.size > 1)
	{
		hint = &"ZM_ZOD_EXIT_BEAST_MODE_HINT_COOP";
		y = 285;
	}
	self thread function_371979a2(12, 12.05);
	self thread function_59ecc704(12, 12.05);
	zm_equipment::show_hint_text(hint, 12.05, 1.5, y);
}

/*
	Name: function_371979a2
	Namespace: namespace_215602b6
	Checksum: 0x36FDECEB
	Offset: 0x3220
	Size: 0x73
	Parameters: 2
	Flags: None
*/
function function_371979a2(minTime, maxTime)
{
	self endon("disconnect");
	self util::waittill_any_timeout(maxTime, "smashable_smashed", "grapplable_grappled", "shockable_shocked", "disconnect");
	self flag::set("beast_hint_shown");
}

/*
	Name: function_59ecc704
	Namespace: namespace_215602b6
	Checksum: 0xD3825F44
	Offset: 0x32A0
	Size: 0x61
	Parameters: 2
	Flags: None
*/
function function_59ecc704(minTime, maxTime)
{
	self endon("disconnect");
	wait(minTime);
	if(isdefined(self))
	{
		self flag::wait_till_timeout(maxTime - minTime, "beast_hint_shown");
		self notify("hide_equipment_hint_text");
	}
}

/*
	Name: function_19b30216
	Namespace: namespace_215602b6
	Checksum: 0xF3D55F35
	Offset: 0x3310
	Size: 0x81
	Parameters: 0
	Flags: None
*/
function function_19b30216()
{
	self thread function_3236486a();
	retval = self util::waittill_any_return("exit_succeed", "exit_failed");
	if(retval == "exit_succeed")
	{
		self notify("hash_f0078f48");
		return 1;
	}
	self.var_6f14dca1 = 0;
	return 0;
}

/*
	Name: function_92acebd3
	Namespace: namespace_215602b6
	Checksum: 0x2D958236
	Offset: 0x33A0
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function function_92acebd3()
{
	self endon("hash_b2631b3c");
	self endon("death");
	self waittill("player_did_a_revive");
	self PlayRumbleOnEntity("damage_heavy");
	wait(1.5);
	self function_bd84f46(1);
	self notify("hash_f0078f48");
}

/*
	Name: function_4c24c0fb
	Namespace: namespace_215602b6
	Checksum: 0xE613F32B
	Offset: 0x3428
	Size: 0x59
	Parameters: 0
	Flags: None
*/
function function_4c24c0fb()
{
	if(self IsThrowingGrenade())
	{
		return 0;
	}
	if(!self StanceButtonPressed())
	{
		return 0;
	}
	if(isdefined(self.teleporting) && self.teleporting)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_3236486a
	Namespace: namespace_215602b6
	Checksum: 0xEE455655
	Offset: 0x3490
	Size: 0xF5
	Parameters: 0
	Flags: None
*/
function function_3236486a()
{
	wait(0.05);
	if(!isdefined(self))
	{
		self notify("hash_59d92a3f");
		return;
	}
	self.var_6f14dca1 = GetTime();
	build_time = 1000;
	self thread function_bf841805(self.var_6f14dca1, build_time);
	while(isdefined(self) && self function_4c24c0fb() && GetTime() - self.var_6f14dca1 < build_time)
	{
		wait(0.05);
	}
	if(isdefined(self) && self function_4c24c0fb() && GetTime() - self.var_6f14dca1 >= build_time)
	{
		self notify("hash_a7925b74");
	}
	else
	{
		self notify("hash_59d92a3f");
	}
}

/*
	Name: function_bf841805
	Namespace: namespace_215602b6
	Checksum: 0x69CF82F1
	Offset: 0x3590
	Size: 0xC3
	Parameters: 2
	Flags: None
*/
function function_bf841805(start_time, build_time)
{
	self.useBar = self hud::createPrimaryProgressBar();
	self.useBarText = self hud::createPrimaryProgressBarText();
	self.useBarText setText(&"ZM_ZOD_EXIT_BEAST_MODE");
	self player_progress_bar_update(start_time, build_time);
	self.useBarText hud::destroyElem();
	self.useBar hud::destroyElem();
}

/*
	Name: player_progress_bar_update
	Namespace: namespace_215602b6
	Checksum: 0x1B7C2C19
	Offset: 0x3660
	Size: 0xCF
	Parameters: 2
	Flags: None
*/
function player_progress_bar_update(start_time, build_time)
{
	self endon("death");
	self endon("disconnect");
	self endon("hash_b2631b3c");
	self endon("hash_59d92a3f");
	while(isdefined(self) && GetTime() - start_time < build_time)
	{
		progress = GetTime() - start_time / build_time;
		if(progress < 0)
		{
			progress = 0;
		}
		if(progress > 1)
		{
			progress = 1;
		}
		self.useBar hud::updateBar(progress);
		wait(0.05);
	}
}

/*
	Name: function_bd84f46
	Namespace: namespace_215602b6
	Checksum: 0xE16133D8
	Offset: 0x3738
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function function_bd84f46(var_7bd1110)
{
	self.var_39f3c137 = self.var_39f3c137 - var_7bd1110;
	if(self.var_39f3c137 <= 0)
	{
		self.var_39f3c137 = 0;
		self notify("hash_f0078f48");
	}
}

/*
	Name: function_20873276
	Namespace: namespace_215602b6
	Checksum: 0xDCF78A2C
	Offset: 0x3798
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function function_20873276(lives)
{
	self.var_5e82a563 = self.var_5e82a563 + lives;
	if(level flag::get("solo_game"))
	{
		if(self.var_5e82a563 > 3)
		{
			self.var_5e82a563 = 3;
		}
	}
	else if(self.var_5e82a563 > 1)
	{
		self.var_5e82a563 = 1;
	}
}

/*
	Name: function_cf361e94
	Namespace: namespace_215602b6
	Checksum: 0xC75E794E
	Offset: 0x3820
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function function_cf361e94(lives)
{
	self.var_5e82a563 = self.var_5e82a563 - lives;
	if(self.var_39f3c137 <= 0)
	{
		self.var_5e82a563 = 0;
	}
}

/*
	Name: function_d60ab790
	Namespace: namespace_215602b6
	Checksum: 0x456C4FC5
	Offset: 0x3860
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_d60ab790(var_7bd1110)
{
	self.var_39f3c137 = self.var_39f3c137 + var_7bd1110;
	if(self.var_39f3c137 > 1)
	{
		self.var_39f3c137 = 1;
	}
}

/*
	Name: function_5b552caf
	Namespace: namespace_215602b6
	Checksum: 0x66739CD9
	Offset: 0x38B0
	Size: 0x11
	Parameters: 1
	Flags: None
*/
function function_5b552caf(player_being_revived)
{
	return 0.75;
}

/*
	Name: function_2ff8ae81
	Namespace: namespace_215602b6
	Checksum: 0x338AEC33
	Offset: 0x38D0
	Size: 0x1FD
	Parameters: 10
	Flags: None
*/
function function_2ff8ae81(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(isdefined(eAttacker) && isPlayer(eAttacker))
	{
		return 0;
	}
	var_a315b31f = level clientfield::get("bm_superbeast");
	if(var_a315b31f)
	{
		var_cc3794d8 = iDamage * 0.0005;
		if(var_cc3794d8 > 0.4)
		{
			var_cc3794d8 = 0.4;
			self thread namespace_8e578893::function_6edf48d5(3);
		}
		else
		{
			self thread namespace_8e578893::function_6edf48d5(2);
		}
		self.var_e3e3d706 = self.var_e3e3d706 - var_cc3794d8;
		if(self.var_e3e3d706 <= 0)
		{
			self notify("hash_f0078f48");
			self function_bd84f46(1);
			self.var_5e82a563 = 1;
		}
		return 0;
	}
	if(isdefined(eAttacker) && (isdefined(eAttacker.is_zombie) && eAttacker.is_zombie || eAttacker.team === level.zombie_team))
	{
		return 0;
	}
	if(iDamage < self.health)
	{
		return 0;
	}
	self notify("hash_f0078f48");
	self function_bd84f46(1);
	return 0;
}

/*
	Name: function_c35feb1f
	Namespace: namespace_215602b6
	Checksum: 0x31104357
	Offset: 0x3AD8
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function function_c35feb1f()
{
	if(isdefined(self.beastmode) && self.beastmode)
	{
		self.var_9fbddc54 = 1;
	}
}

/*
	Name: function_31a1c2c8
	Namespace: namespace_215602b6
	Checksum: 0x9DD5268E
	Offset: 0x3B08
	Size: 0x19D
	Parameters: 0
	Flags: None
*/
function function_31a1c2c8()
{
	level waittill("start_of_round");
	foreach(player in GetPlayers())
	{
		player function_c35feb1f();
	}
	while(1)
	{
		level waittill("start_of_round");
		foreach(player in GetPlayers())
		{
			if(!(isdefined(player.beastmode) && player.beastmode))
			{
				player function_d60ab790(1);
			}
			player function_20873276(1);
			player function_c35feb1f();
		}
	}
}

/*
	Name: function_5b1b9438
	Namespace: namespace_215602b6
	Checksum: 0x7D4503F1
	Offset: 0x3CB0
	Size: 0x1F7
	Parameters: 0
	Flags: None
*/
function function_5b1b9438()
{
	if(!isdefined(self.var_e3e3d706))
	{
		self.var_e3e3d706 = 0;
	}
	self notify("hash_5b1b9438");
	self endon("hash_5b1b9438");
	while(isdefined(self))
	{
		if(isdefined(level.hostMigrationTimer) && level.hostMigrationTimer)
		{
			wait(1);
			continue;
		}
		if(isdefined(self.beastmode) && self.beastmode && (!isdefined(self.teleporting) && self.teleporting))
		{
			self function_bd84f46(1 / 500);
		}
		if(level clientfield::get("bm_superbeast"))
		{
			n_mapped_mana = math::linear_map(self.var_e3e3d706, 0, 1, 0, 1);
		}
		else
		{
			n_mapped_mana = math::linear_map(self.var_39f3c137, 0, 1, 0, 1);
		}
		self clientfield::set_player_uimodel("player_mana", n_mapped_mana);
		lives = self.var_5e82a563;
		if(lives != self clientfield::get_player_uimodel("player_lives"))
		{
			function_20873276(0);
			lives = self.var_5e82a563;
			self clientfield::set_player_uimodel("player_lives", lives);
		}
		wait(0.05);
	}
}

/*
	Name: function_fc79a296
	Namespace: namespace_215602b6
	Checksum: 0x12BFB3AD
	Offset: 0x3EB0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_fc79a296()
{
	self notify("hash_f0078f48");
	self function_bd84f46(1);
}

/*
	Name: function_d0eeb393
	Namespace: namespace_215602b6
	Checksum: 0xF77787BB
	Offset: 0x3EE8
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function function_d0eeb393()
{
	level flagsys::wait_till("start_zombie_round_logic");
	Ooo = GetEntArray("ooze_only", "script_noteworthy");
	Array::thread_all(Ooo, &function_2438ef4);
	Moo = GetEntArray("beast_melee_only", "script_noteworthy");
	Array::thread_all(Moo, &function_bc086a4b);
	var_f5a8998a = GetEntArray("beast_grapple_only", "script_noteworthy");
	Array::thread_all(var_f5a8998a, &function_815e92f8);
}

/*
	Name: function_a1b60d91
	Namespace: namespace_215602b6
	Checksum: 0xB2DB1481
	Offset: 0x4008
	Size: 0x143
	Parameters: 1
	Flags: None
*/
function function_a1b60d91(onOff)
{
	var_f023f29 = GetEntArray("beast_mode", "script_noteworthy");
	if(isdefined(level.var_8e51f1a6))
	{
		var_fcc5f199 = [[level.var_8e51f1a6]]();
		var_f023f29 = ArrayCombine(var_f023f29, var_fcc5f199, 0, 0);
	}
	Array::run_all(var_f023f29, &function_77fcc1c2, self, onOff);
	var_66757da5 = GetEntArray("not_beast_mode", "script_noteworthy");
	if(isdefined(level.var_692ed1bb))
	{
		var_a225fe35 = [[level.var_692ed1bb]]();
		var_66757da5 = ArrayCombine(var_66757da5, var_a225fe35, 0, 0);
	}
	Array::run_all(var_66757da5, &function_77fcc1c2, self, !onOff);
}

/*
	Name: function_77fcc1c2
	Namespace: namespace_215602b6
	Checksum: 0x83E9767
	Offset: 0x4158
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function function_77fcc1c2(player, onOff)
{
	if(onOff)
	{
		self SetVisibleToPlayer(player);
	}
	else
	{
		self SetInvisibleToPlayer(player);
	}
}

/*
	Name: function_e8aacc36
	Namespace: namespace_215602b6
	Checksum: 0xCD3A3065
	Offset: 0x41B8
	Size: 0x51
	Parameters: 0
	Flags: None
*/
function function_e8aacc36()
{
	self endon("hash_b2631b3c");
	self endon("death");
	while(isdefined(self))
	{
		self waittill("weapon_melee_charge", weapon);
		self notify("weapon_melee", weapon);
	}
}

/*
	Name: function_85f2cde9
	Namespace: namespace_215602b6
	Checksum: 0x2612113F
	Offset: 0x4218
	Size: 0x51
	Parameters: 0
	Flags: None
*/
function function_85f2cde9()
{
	self endon("hash_b2631b3c");
	self endon("death");
	while(isdefined(self))
	{
		self waittill("weapon_melee_power", weapon);
		self notify("weapon_melee", weapon);
	}
}

/*
	Name: function_d52a054b
	Namespace: namespace_215602b6
	Checksum: 0xD92DA702
	Offset: 0x4278
	Size: 0x14F
	Parameters: 0
	Flags: None
*/
function function_d52a054b()
{
	self endon("hash_b2631b3c");
	self endon("death");
	while(isdefined(self))
	{
		self waittill("weapon_melee", weapon);
		if(weapon == GetWeapon("zombie_beast_grapple_dwr"))
		{
			self function_bd84f46(0.03);
			FORWARD = AnglesToForward(self getPlayerAngles());
			up = anglesToUp(self getPlayerAngles());
			var_1a423f4f = self.origin + 15 * up + 30 * FORWARD;
			level notify("hash_4841db", self, var_1a423f4f);
			self RadiusDamage(var_1a423f4f, 48, 5000, 5000, self, "MOD_MELEE");
		}
	}
}

/*
	Name: function_568f6019
	Namespace: namespace_215602b6
	Checksum: 0xA8E0104
	Offset: 0x43D0
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function function_568f6019()
{
	self endon("hash_b2631b3c");
	self endon("death");
	while(isdefined(self))
	{
		self waittill("weapon_melee_juke", weapon);
		if(weapon == GetWeapon("zombie_beast_grapple_dwr"))
		{
			function_bbdbb11d(weapon);
		}
	}
}

/*
	Name: function_bbdbb11d
	Namespace: namespace_215602b6
	Checksum: 0xD972A214
	Offset: 0x4450
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function function_bbdbb11d(weapon)
{
	self endon("weapon_melee");
	self endon("weapon_melee_power");
	self endon("weapon_melee_charge");
	start_time = GetTime();
	while(start_time + 3000 > GetTime())
	{
		self PlayRumbleOnEntity("zod_beast_juke");
		wait(0.1);
	}
}

/*
	Name: function_b484a03e
	Namespace: namespace_215602b6
	Checksum: 0xB66EA038
	Offset: 0x44D0
	Size: 0x79
	Parameters: 2
	Flags: None
*/
function function_b484a03e(var_1a423f4f, radius)
{
	mins = (radius * -1, radius * -1, radius * -1);
	maxs = (radius, radius, radius);
	return self IsTouchingVolume(var_1a423f4f, mins, maxs);
}

/*
	Name: function_bc086a4b
	Namespace: namespace_215602b6
	Checksum: 0x1B4878ED
	Offset: 0x4558
	Size: 0x10F
	Parameters: 0
	Flags: None
*/
function function_bc086a4b()
{
	self endon("death");
	level flagsys::wait_till("start_zombie_round_logic");
	if(isdefined(self.target))
	{
		target = GetEnt(self.target, "targetname");
		if(isdefined(target))
		{
			target EnableAimAssist();
		}
	}
	self SetInvisibleToAll();
	while(isdefined(self))
	{
		level waittill("hash_4841db", player, var_1a423f4f);
		if(isdefined(self) && self function_b484a03e(var_1a423f4f, 48))
		{
			self UseBy(player);
		}
	}
}

/*
	Name: function_4c03fac9
	Namespace: namespace_215602b6
	Checksum: 0x7C1ED15
	Offset: 0x4670
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function function_4c03fac9(weapon)
{
	if(!isdefined(weapon))
	{
		return 0;
	}
	if(weapon == GetWeapon("zombie_beast_lightning_dwl") || weapon == GetWeapon("zombie_beast_lightning_dwl2") || weapon == GetWeapon("zombie_beast_lightning_dwl3"))
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_cebfc03f
	Namespace: namespace_215602b6
	Checksum: 0x52374B7B
	Offset: 0x46F8
	Size: 0x8F
	Parameters: 1
	Flags: None
*/
function function_cebfc03f(weapon)
{
	if(!isdefined(weapon))
	{
		return 0;
	}
	if(weapon == GetWeapon("zombie_beast_lightning_dwl"))
	{
		return 1;
	}
	if(weapon == GetWeapon("zombie_beast_lightning_dwl2"))
	{
		return 2;
	}
	if(weapon == GetWeapon("zombie_beast_lightning_dwl3"))
	{
		return 3;
	}
	return 0;
}

/*
	Name: function_8b382e19
	Namespace: namespace_215602b6
	Checksum: 0xB9DDC1D7
	Offset: 0x4790
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function function_8b382e19()
{
	self endon("hash_b2631b3c");
	self endon("death");
	self.tesla_enemies = undefined;
	self.tesla_enemies_hit = 0;
	self.tesla_powerup_dropped = 0;
	self.tesla_arc_count = 0;
	while(isdefined(self))
	{
		self waittill("weapon_fired", weapon);
		if(function_4c03fac9(weapon))
		{
			self function_bd84f46(0);
		}
	}
}

/*
	Name: function_8ee03bb5
	Namespace: namespace_215602b6
	Checksum: 0x3F65BA91
	Offset: 0x4838
	Size: 0x27F
	Parameters: 1
	Flags: None
*/
function function_8ee03bb5(weapon)
{
	self endon("disconnect");
	self.tesla_enemies = undefined;
	self.tesla_enemies_hit = 0;
	self.tesla_powerup_dropped = 0;
	self.tesla_arc_count = 0;
	var_32105fa5 = function_cebfc03f(weapon);
	var_96f81bff = 36;
	switch(var_32105fa5)
	{
		case 2:
		{
			var_96f81bff = 72;
			break;
		}
		case 3:
		{
			var_96f81bff = 108;
			break;
		}
	}
	FORWARD = AnglesToForward(self getPlayerAngles());
	up = anglesToUp(self getPlayerAngles());
	center = self.origin + 16 * up + 24 * FORWARD;
	if(var_32105fa5 > 1)
	{
		playFX(level._effect["beast_shock_aoe"], center);
	}
	zombies = Array::get_all_closest(center, GetAITeamArray(level.zombie_team), undefined, undefined, var_96f81bff);
	foreach(zombie in zombies)
	{
		zombie thread function_fe8a580e(zombie.origin, center, self, var_32105fa5);
		zombie notify("bhtn_action_notify", "electrocute");
	}
	wait(0.05);
	self.tesla_enemies_hit = 0;
}

/*
	Name: function_fe8a580e
	Namespace: namespace_215602b6
	Checksum: 0xCCAE80DA
	Offset: 0x4AC0
	Size: 0xDB
	Parameters: 4
	Flags: None
*/
function function_fe8a580e(HIT_LOCATION, hit_origin, player, var_32105fa5)
{
	player endon("disconnect");
	if(isdefined(self.zombie_tesla_hit) && self.zombie_tesla_hit)
	{
		return;
	}
	if(var_32105fa5 < 2)
	{
		self lightning_chain::arc_damage(self, player, 1, level.var_3a2dca1e);
	}
	else if(var_32105fa5 < 3)
	{
		self lightning_chain::arc_damage(self, player, 1, level.var_142b4fb5);
	}
	else
	{
		self lightning_chain::arc_damage(self, player, 1, level.var_ee28d54c);
	}
}

/*
	Name: function_3e9ddcc7
	Namespace: namespace_215602b6
	Checksum: 0x34DC2009
	Offset: 0x4BA8
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function function_3e9ddcc7()
{
	level.var_3a2dca1e = lightning_chain::create_lightning_chain_params(1);
	level.var_3a2dca1e.should_kill_enemies = 0;
	level.var_142b4fb5 = lightning_chain::create_lightning_chain_params(2);
	level.var_142b4fb5.should_kill_enemies = 0;
	level.var_142b4fb5.clientside_fx = 0;
	level.var_ee28d54c = lightning_chain::create_lightning_chain_params(3);
	level.var_ee28d54c.should_kill_enemies = 0;
	level.var_ee28d54c.clientside_fx = 0;
}

/*
	Name: function_8a41ce54
	Namespace: namespace_215602b6
	Checksum: 0xFCF77A8B
	Offset: 0x4C78
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function function_8a41ce54()
{
	if(!isdefined(level.var_701d7eb))
	{
		level.var_701d7eb = [];
	}
	return level.var_701d7eb;
}

/*
	Name: function_815e92f8
	Namespace: namespace_215602b6
	Checksum: 0xF36560DD
	Offset: 0x4CA8
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function function_815e92f8()
{
	self endon("death");
	level flagsys::wait_till("start_zombie_round_logic");
	self SetInvisibleToAll();
	while(isdefined(self))
	{
		level waittill("hash_38a78b80", target, player);
		if(isdefined(self) && target istouching(self))
		{
			self UseBy(player);
		}
	}
}

/*
	Name: function_89419316
	Namespace: namespace_215602b6
	Checksum: 0x504693AB
	Offset: 0x4D60
	Size: 0x117
	Parameters: 0
	Flags: None
*/
function function_89419316()
{
	self endon("hash_b2631b3c");
	self endon("death");
	grapple = GetWeapon("zombie_beast_grapple_dwr");
	while(isdefined(self))
	{
		self waittill("hash_333f4ea7", weapon);
		if(weapon == grapple)
		{
			if(isdefined(self.lockonentity))
			{
				if(!self function_668dcfac(self.lockonentity))
				{
					self.lockonentity = undefined;
				}
			}
			self function_bd84f46(0);
			self thread function_77a9a8f6(weapon, "zod_beast_grapple_out", 0.4);
		}
	}
}

/*
	Name: function_668dcfac
	Namespace: namespace_215602b6
	Checksum: 0x287B2FC2
	Offset: 0x4E80
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function function_668dcfac(target)
{
	if(isdefined(target.var_deccd0c8) && target.var_deccd0c8)
	{
		return 0;
	}
	target.var_deccd0c8 = 1;
	self thread function_b8488073(target, 5);
	return 1;
}

/*
	Name: function_b8488073
	Namespace: namespace_215602b6
	Checksum: 0x5D4ED013
	Offset: 0x4EF0
	Size: 0x103
	Parameters: 2
	Flags: None
*/
function function_b8488073(target, time)
{
	self util::waittill_any_timeout(time, "disconnect", "grapple_cancel", "player_exit_beastmode");
	if(isdefined(target))
	{
		target.var_deccd0c8 = undefined;
		if(isdefined(target.is_zombie) && target.is_zombie)
		{
			target DoDamage(target.health + 1000, target.origin);
			if(!isVehicle(target))
			{
				target.no_powerups = 1;
				target.marked_for_recycle = 1;
				target.has_been_damaged_by_player = 0;
			}
		}
	}
}

/*
	Name: function_77a9a8f6
	Namespace: namespace_215602b6
	Checksum: 0xF4CBDE7C
	Offset: 0x5000
	Size: 0x8D
	Parameters: 3
	Flags: None
*/
function function_77a9a8f6(weapon, rumble, length)
{
	self endon("hash_cc80941b");
	self endon("hash_34020bc3");
	self endon("hash_d35b1239");
	self endon("hash_2551795b");
	start_time = GetTime();
	while(start_time + 3000 > GetTime())
	{
		self PlayRumbleOnEntity(rumble);
		wait(length);
	}
}

/*
	Name: grapple_valid_target_check
	Namespace: namespace_215602b6
	Checksum: 0xBDA62C26
	Offset: 0x5098
	Size: 0x75
	Parameters: 1
	Flags: None
*/
function grapple_valid_target_check(ent)
{
	if(!isVehicle(ent))
	{
		if(isdefined(ent.is_zombie) && ent.is_zombie)
		{
			if(!(isdefined(ent.completed_emerging_into_playable_area) && ent.completed_emerging_into_playable_area))
			{
				return 0;
			}
		}
	}
	return 1;
}

/*
	Name: function_a51e085
	Namespace: namespace_215602b6
	Checksum: 0xE2A8F73A
	Offset: 0x5118
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function function_a51e085()
{
	self endon("death");
	self.grapple_type = 0;
	self SetGrapplableType(self.grapple_type);
	if(!isVehicle(self))
	{
		self waittill("completed_emerging_into_playable_area");
	}
	if(!isdefined(self))
	{
		return;
	}
	self.grapple_type = 2;
	self SetGrapplableType(self.grapple_type);
}

/*
	Name: function_ce0d3f8c
	Namespace: namespace_215602b6
	Checksum: 0xF61B4941
	Offset: 0x51B8
	Size: 0x14F
	Parameters: 0
	Flags: None
*/
function function_ce0d3f8c()
{
	self endon("hash_b2631b3c");
	self endon("death");
	grapple = GetWeapon("zombie_beast_grapple_dwr");
	while(isdefined(self))
	{
		self waittill("hash_cc80941b", weapon, target);
		if(weapon == grapple)
		{
			self notify("hash_c5523e8b");
			self PlayRumbleOnEntity("zod_beast_grapple_hit");
			if(isdefined(target))
			{
				if(isdefined(target.is_zombie) && target.is_zombie)
				{
					target function_97e0f416(self);
				}
			}
			level notify("hash_38a78b80", target, self, isdefined(self.var_7044f5ce) && !isPlayer(self.var_7044f5ce));
			playsoundatposition("wpn_beastmode_grapple_imp", target.origin);
		}
	}
}

/*
	Name: function_126b475f
	Namespace: namespace_215602b6
	Checksum: 0xBFDD6FB0
	Offset: 0x5310
	Size: 0xFF
	Parameters: 0
	Flags: None
*/
function function_126b475f()
{
	self endon("hash_b2631b3c");
	self endon("death");
	grapple = GetWeapon("zombie_beast_grapple_dwr");
	while(isdefined(self))
	{
		self waittill("hash_6a26334c", weapon, target);
		if(weapon == grapple)
		{
			origin = target.origin;
			self thread function_abdf7162(origin);
			self playsound("wpn_beastmode_grapple_pullin");
			wait(0.15);
			self thread function_77a9a8f6(weapon, "zod_beast_grapple_reel", 0.2);
		}
	}
}

/*
	Name: function_abdf7162
	Namespace: namespace_215602b6
	Checksum: 0xCDE95143
	Offset: 0x5418
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function function_abdf7162(origin)
{
	self endon("hash_b2631b3c");
	self endon("death");
	self notify("hash_abdf7162");
	self endon("hash_abdf7162");
	self waittill("hash_d35b1239", weapon, target);
	if(Distance2DSquared(self.origin, origin) > 1024)
	{
		self SetOrigin(origin + VectorScale((0, 0, -1), 60));
	}
}

/*
	Name: function_5e1ffae
	Namespace: namespace_215602b6
	Checksum: 0x47D11806
	Offset: 0x54D0
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function function_5e1ffae()
{
	self endon("hash_b2631b3c");
	self endon("death");
	grapple = GetWeapon("zombie_beast_grapple_dwr");
	while(isdefined(self))
	{
		self waittill("hash_e25aaf9d", weapon, target);
		if(weapon == grapple)
		{
			wait(0.15);
			self thread function_77a9a8f6(weapon, "zod_beast_grapple_pull", 0.2);
		}
	}
}

/*
	Name: function_f893b14f
	Namespace: namespace_215602b6
	Checksum: 0x861E5BB1
	Offset: 0x5588
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function function_f893b14f()
{
	self endon("hash_b2631b3c");
	self endon("death");
	grapple = GetWeapon("zombie_beast_grapple_dwr");
	while(isdefined(self))
	{
		self waittill("hash_34020bc3", weapon, target);
		if(weapon == grapple)
		{
			if(isdefined(target))
			{
				if(isdefined(target.is_zombie) && target.is_zombie)
				{
				}
				else if(isdefined(target.powerup_name))
				{
					target.origin = self.origin;
				}
			}
		}
	}
}

/*
	Name: function_97e0f416
	Namespace: namespace_215602b6
	Checksum: 0xD22F52EF
	Offset: 0x5668
	Size: 0x213
	Parameters: 1
	Flags: None
*/
function function_97e0f416(player)
{
	self.grapple_is_fatal = 1;
	var_4361c12b = player.origin - self.origin;
	var_168907b4 = VectorNormalize((var_4361c12b[0], var_4361c12b[1], 0));
	zombie_forward = AnglesToForward(self.angles);
	zombie_forward_2d = VectorNormalize((zombie_forward[0], zombie_forward[1], 0));
	zombie_right = AnglesToRight(self.angles);
	zombie_right_2d = VectorNormalize((zombie_right[0], zombie_right[1], 0));
	dot = VectorDot(var_168907b4, zombie_forward_2d);
	if(dot >= 0.5)
	{
		self.GRAPPLE_DIRECTION = "front";
	}
	else if(dot < 0.5 && dot > -0.5)
	{
		dot = VectorDot(var_168907b4, zombie_right_2d);
		if(dot > 0)
		{
			self.GRAPPLE_DIRECTION = "right";
		}
		else
		{
			self.GRAPPLE_DIRECTION = "left";
		}
	}
	else
	{
		self.GRAPPLE_DIRECTION = "back";
	}
	self thread function_d4252c93(player);
}

/*
	Name: function_d4252c93
	Namespace: namespace_215602b6
	Checksum: 0x7978A822
	Offset: 0x5888
	Size: 0x1AB
	Parameters: 1
	Flags: None
*/
function function_d4252c93(player)
{
	player util::waittill_any_timeout(2.5, "disconnect", "grapple_pulled", "altbody_end");
	wait(0.15);
	if(isdefined(self))
	{
		if(isdefined(player))
		{
			player playsound("wpn_beastmode_grapple_zombie_imp");
		}
		if(!(isdefined(self.grapple_is_fatal) && self.grapple_is_fatal))
		{
			self DoDamage(1000, player.origin, player);
		}
		else if(isdefined(player))
		{
			self DoDamage(self.health + 1000, player.origin, player);
		}
		else
		{
			self DoDamage(self.health + 1000, self.origin);
		}
		if(!isVehicle(self))
		{
			self.no_powerups = 1;
			self.marked_for_recycle = 1;
			self.has_been_damaged_by_player = 0;
			self StartRagdoll();
			if(isdefined(player))
			{
				player clientfield::increment_to_player("beast_blood_on_player");
			}
		}
	}
}

/*
	Name: function_f4ee06b4
	Namespace: namespace_215602b6
	Checksum: 0xD6208464
	Offset: 0x5A40
	Size: 0x16B
	Parameters: 13
	Flags: None
*/
function function_f4ee06b4(mod, HIT_LOCATION, hit_origin, player, amount, weapon, direction_vec, tagName, modelName, partName, dFlags, inflictor, chargeLevel)
{
	if(function_4c03fac9(weapon))
	{
		var_32105fa5 = function_cebfc03f(weapon);
		self.tesla_death = 0;
		self thread function_fe8a580e(HIT_LOCATION, hit_origin, player, var_32105fa5);
		return 1;
	}
	if(weapon === GetWeapon("zombie_beast_grapple_dwr"))
	{
		if(amount > 0 && isdefined(player))
		{
			player PlayRumbleOnEntity("damage_heavy");
			Earthquake(1, 0.75, player.origin, 100);
		}
		return 1;
	}
	return 0;
}

/*
	Name: function_c5c7aef3
	Namespace: namespace_215602b6
	Checksum: 0x67D0EBD9
	Offset: 0x5BB8
	Size: 0x23F
	Parameters: 1
	Flags: None
*/
function function_c5c7aef3(triggers)
{
	self endon("delete");
	self SetCanDamage(1);
	while(isdefined(triggers))
	{
		self waittill("damage", amount, attacker, direction, point, mod, tagName, modelName, partName, weapon);
		if(function_4c03fac9(weapon) && isdefined(attacker) && amount > 0)
		{
			if(isdefined(attacker))
			{
				attacker notify("hash_e22dab6d");
			}
			if(isdefined(level._effect["beast_shock_box"]))
			{
				FORWARD = AnglesToForward(self.angles);
				playFX(level._effect["beast_shock_box"], self.origin, FORWARD);
			}
			if(!isdefined(triggers))
			{
				return;
			}
			if(IsArray(triggers))
			{
				foreach(trigger in triggers)
				{
					if(isdefined(trigger))
					{
						trigger UseBy(attacker);
					}
				}
			}
			else
			{
				triggers UseBy(attacker);
			}
		}
	}
}

/*
	Name: function_d166ff57
	Namespace: namespace_215602b6
	Checksum: 0x8F8AD0B0
	Offset: 0x5E00
	Size: 0x25B
	Parameters: 1
	Flags: None
*/
function function_d166ff57(attacker)
{
	if(isdefined(self.attacker) && (isdefined(self.attacker.beastmode) && self.attacker.beastmode))
	{
		self.no_powerups = 1;
		self.marked_for_recycle = 1;
		self.has_been_damaged_by_player = 0;
	}
	if(function_4c03fac9(self.damageWeapon))
	{
		self.no_powerups = 1;
		self.marked_for_recycle = 1;
		self.has_been_damaged_by_player = 0;
	}
	if(self.damageWeapon === GetWeapon("zombie_beast_grapple_dwr"))
	{
		self.no_powerups = 1;
		self.marked_for_recycle = 1;
		self.has_been_damaged_by_player = 0;
		if(!isVehicle(self))
		{
			if(self.damageMod === "MOD_MELEE")
			{
				player = self.attacker;
				if(isdefined(player))
				{
					player PlayRumbleOnEntity("damage_heavy");
					Earthquake(1, 0.75, player.origin, 100);
				}
				self clientfield::set("bm_zombie_grapple_kill", 1);
				GibServerUtils::Annihilate(self);
			}
			else
			{
				player = self.attacker;
				if(isdefined(player))
				{
					player PlayRumbleOnEntity("damage_heavy");
					Earthquake(1, 0.75, player.origin, 100);
				}
				self clientfield::set("bm_zombie_melee_kill", 1);
				GibServerUtils::Annihilate(self);
			}
		}
	}
}

/*
	Name: function_2438ef4
	Namespace: namespace_215602b6
	Checksum: 0x8D940540
	Offset: 0x6068
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function function_2438ef4()
{
	self endon("death");
	level flagsys::wait_till("start_zombie_round_logic");
	self SetInvisibleToAll();
	while(isdefined(self))
	{
		level waittill("hash_752282bb", grenade, player);
		if(isdefined(self) && isdefined(grenade) && grenade istouching(self))
		{
			self UseBy(player);
		}
	}
}

/*
	Name: function_7fb730b3
	Namespace: namespace_215602b6
	Checksum: 0xBDA24DB1
	Offset: 0x6128
	Size: 0x85
	Parameters: 0
	Flags: None
*/
function function_7fb730b3()
{
	if(isdefined(self.barricade_enter) && self.barricade_enter)
	{
		return 0;
	}
	if(isdefined(self.is_traversing) && self.is_traversing)
	{
		return 0;
	}
	if(!isdefined(self.completed_emerging_into_playable_area) && self.completed_emerging_into_playable_area && !isdefined(self.first_node))
	{
		return 0;
	}
	if(isdefined(self.is_leaping) && self.is_leaping)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_2264dd90
	Namespace: namespace_215602b6
	Checksum: 0x572BF128
	Offset: 0x61B8
	Size: 0x39B
	Parameters: 1
	Flags: None
*/
function function_2264dd90(zombie)
{
	zombie endon("death");
	zombie notify("hash_2264dd90");
	zombie endon("hash_2264dd90");
	if(!zombie function_7fb730b3())
	{
		return;
	}
	num = zombie GetEntityNumber();
	if(!isdefined(zombie.var_6933bc56))
	{
		zombie.var_6933bc56 = 0;
	}
	zombie.var_6933bc56++;
	if(!isdefined(zombie.var_9eb424de))
	{
		zombie.var_9eb424de = 1;
	}
	zombie.var_ffa5f32a = 8;
	zombie thread function_73b14de1(zombie);
	while(isdefined(zombie) && isalive(zombie) && zombie.var_9eb424de > 0.03)
	{
		zombie.var_9eb424de = zombie.var_9eb424de - 0.97 * 0.05;
		if(zombie.var_9eb424de < 0.03)
		{
			zombie.var_9eb424de = 0.03;
		}
		zombie ASMSetAnimationRate(zombie.var_9eb424de);
		zombie.var_ffa5f32a = zombie.var_ffa5f32a - 0.05;
		wait(0.05);
	}
	while(isdefined(zombie) && isalive(zombie) && zombie.var_ffa5f32a > 0.5)
	{
		zombie.var_ffa5f32a = zombie.var_ffa5f32a - 0.05;
		wait(0.05);
	}
	while(isdefined(zombie) && isalive(zombie) && zombie.var_9eb424de < 1)
	{
		zombie.var_9eb424de = zombie.var_9eb424de + 0.97 * 0.1;
		if(zombie.var_9eb424de > 1)
		{
			zombie.var_9eb424de = 1;
		}
		zombie ASMSetAnimationRate(zombie.var_9eb424de);
		zombie.var_ffa5f32a = zombie.var_ffa5f32a - 0.05;
		wait(0.05);
	}
	zombie ASMSetAnimationRate(1);
	zombie.var_ffa5f32a = 0;
	if(isdefined(zombie))
	{
		zombie.var_6933bc56--;
	}
}

/*
	Name: function_73b14de1
	Namespace: namespace_215602b6
	Checksum: 0x301BA0F2
	Offset: 0x6560
	Size: 0xDD
	Parameters: 1
	Flags: None
*/
function function_73b14de1(zombie)
{
	tag = "J_SpineUpper";
	FX = "beast_shock";
	if(isdefined(zombie.isdog) && zombie.isdog)
	{
		tag = "J_Spine1";
	}
	while(isdefined(zombie) && isalive(zombie) && zombie.var_ffa5f32a > 0)
	{
		zombie zm_net::network_safe_play_fx_on_tag("beast_slow_fx", 2, level._effect[FX], zombie, tag);
		wait(1);
	}
}

/*
	Name: function_41cc3fc8
	Namespace: namespace_215602b6
	Checksum: 0xA5BECDC0
	Offset: 0x6648
	Size: 0xB9
	Parameters: 0
	Flags: None
*/
function function_41cc3fc8()
{
	players = level.activePlayers;
	foreach(player in players)
	{
		player thread function_a1b60d91(isdefined(player.beastmode) && player.beastmode);
	}
}

/*
	Name: function_d7b8b2f5
	Namespace: namespace_215602b6
	Checksum: 0x87674772
	Offset: 0x6710
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function function_d7b8b2f5()
{
	self endon("hash_b2631b3c");
	self endon("hash_f0078f48");
	n_start_time = undefined;
	while(1)
	{
		current_zone = self zm_utility::get_current_zone();
		if(!isdefined(current_zone))
		{
			if(!isdefined(n_start_time))
			{
				n_start_time = GetTime();
			}
			n_current_time = GetTime();
			n_time = n_current_time - n_start_time / 1000;
			if(n_time >= level.var_87ee6f27)
			{
				self notify("hash_f0078f48");
				return;
			}
		}
		else
		{
			n_start_time = undefined;
		}
		wait(0.05);
	}
}

/*
	Name: function_ae9ea3e4
	Namespace: namespace_215602b6
	Checksum: 0x646FB2FA
	Offset: 0x67F0
	Size: 0x1CD
	Parameters: 0
	Flags: None
*/
function function_ae9ea3e4()
{
	/#
		level flagsys::wait_till("Dev Block strings are not supported");
		wait(1);
		zm_devgui::function_4acecab5(&function_de43aaee);
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			ip1 = i + 1;
			AddDebugCommand("Dev Block strings are not supported" + players[i].name + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported");
			AddDebugCommand("Dev Block strings are not supported" + players[i].name + "Dev Block strings are not supported" + ip1 + "Dev Block strings are not supported");
		}
	#/
}

/*
	Name: function_de43aaee
	Namespace: namespace_215602b6
	Checksum: 0xEC8A7A23
	Offset: 0x69C8
	Size: 0x5EF
	Parameters: 1
	Flags: None
*/
function function_de43aaee(cmd)
{
	/#
		players = GetPlayers();
		retval = 0;
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				zm_devgui::zombie_devgui_give_powerup(cmd, 1);
				break;
			}
			case "Dev Block strings are not supported":
			{
				zm_devgui::zombie_devgui_give_powerup(GetSubStr(cmd, 5), 0);
				break;
			}
			case "Dev Block strings are not supported":
			{
				Array::thread_all(players, &function_b71892de);
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				Array::thread_all(players, &function_d92721d1);
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				a_trigs = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
				foreach(e_trig in a_trigs)
				{
					e_trig UseBy(level.players[0]);
				}
				a_trigs = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
				foreach(e_trig in a_trigs)
				{
					e_trig UseBy(level.players[0]);
				}
				var_4c4fcdb0 = Array("Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported");
				foreach(var_83f1459 in var_4c4fcdb0)
				{
					level flag::set(var_83f1459);
				}
				level flag::set("Dev Block strings are not supported");
				level flag::set("Dev Block strings are not supported");
				zm_devgui::zombie_devgui_open_sesame();
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(players.size >= 1)
				{
					players[0] thread function_b71892de();
				}
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(players.size >= 2)
				{
					players[1] thread function_b71892de();
				}
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(players.size >= 3)
				{
					players[2] thread function_b71892de();
				}
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(players.size >= 4)
				{
					players[3] thread function_b71892de();
				}
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				Array::thread_all(players, &function_a30c4879);
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(players.size >= 1)
				{
					players[0] thread function_a30c4879();
				}
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(players.size >= 2)
				{
					players[1] thread function_a30c4879();
				}
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(players.size >= 3)
				{
					players[2] thread function_a30c4879();
				}
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(players.size >= 4)
				{
					players[3] thread function_a30c4879();
				}
				retval = 1;
				break;
			}
		}
		return retval;
	#/
}

/*
	Name: function_b71892de
	Namespace: namespace_215602b6
	Checksum: 0x48C5B9DB
	Offset: 0x6FC0
	Size: 0x9D
	Parameters: 0
	Flags: None
*/
function function_b71892de()
{
	/#
		if(self function_2449723c())
		{
			return;
		}
		level flagsys::wait_till("Dev Block strings are not supported");
		if(!(isdefined(self.beastmode) && self.beastmode))
		{
			self function_d60ab790(1);
			self thread zm_altbody::function_4f8260a2("Dev Block strings are not supported");
		}
		else
		{
			self notify("hash_f0078f48");
		}
	#/
}

/*
	Name: function_d92721d1
	Namespace: namespace_215602b6
	Checksum: 0x1CEECE13
	Offset: 0x7068
	Size: 0xD5
	Parameters: 0
	Flags: None
*/
function function_d92721d1()
{
	/#
		if(self function_2449723c())
		{
			return;
		}
		level flagsys::wait_till("Dev Block strings are not supported");
		var_a315b31f = level clientfield::get("Dev Block strings are not supported");
		if(!isdefined(self.beastmode) && self.beastmode && !var_a315b31f)
		{
			self function_d60ab790(1);
			self thread zm_altbody::function_4f8260a2("Dev Block strings are not supported");
		}
		else
		{
			self notify("hash_f0078f48");
		}
	#/
}

/*
	Name: function_2449723c
	Namespace: namespace_215602b6
	Checksum: 0x5B3BDFF5
	Offset: 0x7148
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
	Name: function_a30c4879
	Namespace: namespace_215602b6
	Checksum: 0xCEFBD38E
	Offset: 0x7188
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function function_a30c4879()
{
	/#
		if(self function_2449723c())
		{
			return;
		}
		self notify("hash_57460045");
		self endon("hash_57460045");
		level flagsys::wait_till("Dev Block strings are not supported");
		self.var_bc3ea900 = !isdefined(self.var_bc3ea900) && self.var_bc3ea900;
		if(self.var_bc3ea900)
		{
			while(isdefined(self))
			{
				self function_20873276(3);
				self function_d60ab790(1);
				wait(0.05);
			}
		}
	#/
}

