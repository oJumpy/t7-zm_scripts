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

#namespace zm_altbody_beast;

/*
	Name: __init__sytem__
	Namespace: zm_altbody_beast
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
	Namespace: zm_altbody_beast
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
	beastmode_loadout = zm_weapons::create_loadout(loadout);
	var_55affbc1 = Array("zm_bgb_disorderly_combat");
	zm_altbody::init("beast_mode", "beast_mode_kiosk", &"ZM_ZOD_ENTER_BEAST_MODE", "zombie_beast_2", 123, beastmode_loadout, 4, &player_enter_beastmode, &player_exit_beastmode, &player_allow_beastmode, &"ZM_ZOD_CANT_ENTER_BEAST_MODE", var_55affbc1);
	callback::on_connect(&player_on_connect);
	callback::on_spawned(&player_on_spawned);
	callback::on_player_killed(&player_on_killed);
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
	level.get_grapple_targets = &get_grapple_targets;
	level.grapple_notarget_distance = 120;
	level.grapple_notarget_enabled = 0;
	zm_spawner::register_zombie_damage_callback(&lightning_zombie_damage_response);
	zm_spawner::register_zombie_death_event_callback(&beast_mode_death_watch);
	/#
		thread beastmode_devgui();
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
	Namespace: zm_altbody_beast
	Checksum: 0x9F6A4B4C
	Offset: 0x1120
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function __main__()
{
	thread watch_round_start_mana();
	thread hide_ooze_triggers();
	thread kiosk_cooldown();
	thread make_powerups_grapplable();
	zm_spawner::add_custom_zombie_spawn_logic(&zombie_on_spawn);
	create_lightning_params();
	level.weaponbeastrevivetool = GetWeapon("syrette_zod_beast");
}

/*
	Name: player_cover_transition
	Namespace: zm_altbody_beast
	Checksum: 0x6948187D
	Offset: 0x11C0
	Size: 0x1D
	Parameters: 1
	Flags: None
*/
function player_cover_transition(extra_time)
{
	if(!isdefined(extra_time))
	{
		extra_time = 0;
	}
}

/*
	Name: player_disappear_in_flash
	Namespace: zm_altbody_beast
	Checksum: 0x23858842
	Offset: 0x11E8
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function player_disappear_in_flash(washuman)
{
	self ghost();
}

/*
	Name: player_enter_beastmode
	Namespace: zm_altbody_beast
	Checksum: 0x951F79E5
	Offset: 0x1218
	Size: 0x5C3
	Parameters: 2
	Flags: None
*/
function player_enter_beastmode(name, trigger)
{
	/#
		Assert(!isdefined(self.beastmode) && self.beastmode);
	#/
	self notify("clear_red_flashing_overlay");
	self disableOffhandWeapons();
	self zm_weapons::suppress_stowed_weapon(1);
	self player_give_mana(1);
	self player_take_lives(1);
	self.beast_mode_return_origin = self.var_b2356a6c;
	self.beast_mode_return_angles = self.var_227fe352;
	self zm_utility::create_streamer_hint(self.origin, self.angles + VectorScale((0, 1, 0), 180), 0.25);
	self thread player_cover_transition();
	self playsound("evt_beastmode_enter");
	if(!isdefined(self.firstTime))
	{
		self.firstTime = 1;
		level.n_first_beast_mode_player_index = self.characterindex;
		level notify("a_player_entered_beast_mode");
	}
	self player_disappear_in_flash(1);
	self.overrideplayerdamage_original = self.overridePlayerDamage;
	self.overridePlayerDamage = &player_damage_override_beast_mode;
	self.weaponReviveTool = level.weaponbeastrevivetool;
	self.get_revive_time = &player_get_revive_time;
	self zm_utility::increment_ignoreme();
	self.beastmode = 1;
	self.inhibit_scoring_from_zombies = 1;
	self flag::set("in_beastmode");
	bb::logplayerevent(self, "enter_beast_mode");
	self RecordMapEvent(1, GetTime(), self.origin, level.round_number);
	self AllowStand(1);
	self AllowProne(0);
	self AllowCrouch(0);
	self AllowAds(0);
	self AllowJump(1);
	self allowslide(0);
	self setMoveSpeedScale(1);
	self SetSprintDuration(4);
	self SetSprintCooldown(0);
	self player_update_beast_mode_objects(1);
	self zm_utility::increment_is_drinking();
	self StopShellshock();
	self setPerk("specialty_unlimitedsprint");
	self setPerk("specialty_fallheight");
	self setPerk("specialty_lowgravity");
	wait(0.1);
	self show();
	self thread player_watch_melee();
	self thread player_watch_melee_juke();
	self thread player_watch_melee_power();
	self thread player_watch_melee_charge();
	self thread player_watch_lightning();
	self thread player_watch_grapple();
	self thread player_watch_grappled_zombies();
	self thread player_watch_grappled_object();
	self thread player_kill_grappled_zombies();
	self thread player_watch_grapple_traverse();
	self thread player_watch_cancel();
	self thread function_92acebd3();
	if(level clientfield::get("bm_superbeast"))
	{
		self player_enter_superbeastmode();
	}
	/#
		scr_beast_no_visionset = GetDvarInt("Dev Block strings are not supported") > 0;
		self thread watch_scr_beast_no_visionset();
	#/
}

/*
	Name: watch_scr_beast_no_visionset
	Namespace: zm_altbody_beast
	Checksum: 0xAC0B168C
	Offset: 0x17E8
	Size: 0x189
	Parameters: 1
	Flags: None
*/
function watch_scr_beast_no_visionset(localClientNum)
{
	self endon("player_exit_beastmode");
	was_scr_beast_no_visionset = 0;
	while(isdefined(self))
	{
		scr_beast_no_visionset = GetDvarInt("scr_beast_no_visionset") > 0;
		if(scr_beast_no_visionset != was_scr_beast_no_visionset)
		{
			name = "beast_mode";
			visionset = "zombie_beast_2";
			if(scr_beast_no_visionset)
			{
				if(isdefined(visionset))
				{
					visionset_mgr::deactivate("visionset", visionset, self);
					self.altbody_visionset[name] = 0;
				}
			}
			else if(isdefined(visionset))
			{
				if(isdefined(self.altbody_visionset[name]) && self.altbody_visionset[name])
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
				self.altbody_visionset[name] = 1;
			}
		}
		was_scr_beast_no_visionset = scr_beast_no_visionset;
		wait(1);
	}
}

/*
	Name: player_enter_superbeastmode
	Namespace: zm_altbody_beast
	Checksum: 0xD776B18
	Offset: 0x1980
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function player_enter_superbeastmode()
{
	self zm_utility::decrement_ignoreme();
	self.superbeastmana = 1;
	self.see_kiosks_in_altbody = 1;
	self.trigger_kiosks_in_altbody = 1;
	self.custom_altbody_callback = &player_recharge_superbeastmode;
	self DisableInvulnerability();
	self thread superbeastmode_override_hp();
	bb::logplayerevent(self, "enter_superbeast_mode");
	self RecordMapEvent(2, GetTime(), self.origin, level.round_number);
}

/*
	Name: player_recharge_superbeastmode
	Namespace: zm_altbody_beast
	Checksum: 0x889B4317
	Offset: 0x1A60
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function player_recharge_superbeastmode(trigger, name)
{
	level notify("kiosk_used", trigger.kiosk);
	self.superbeastmana = 1;
	self player_update_beast_mode_objects(1);
}

/*
	Name: superbeastmode_override_hp
	Namespace: zm_altbody_beast
	Checksum: 0xEE3DAED4
	Offset: 0x1AC8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function superbeastmode_override_hp()
{
	self endon("player_exit_beastmode");
	while(isdefined(self))
	{
		self.beastmana = self.superbeastmana;
		wait(0.05);
	}
}

/*
	Name: player_exit_beastmode
	Namespace: zm_altbody_beast
	Checksum: 0xC48B8418
	Offset: 0x1B08
	Size: 0x3A3
	Parameters: 2
	Flags: None
*/
function player_exit_beastmode(name, trigger)
{
	/#
		Assert(isdefined(self.beastmode) && self.beastmode);
	#/
	self notify("clear_red_flashing_overlay");
	self thread player_cover_transition(0);
	self player_disappear_in_flash(0);
	self player_update_beast_mode_objects(0);
	if(self IsThrowingGrenade())
	{
		self forcegrenadethrow();
	}
	if(0)
	{
		wait(0);
	}
	self notify("player_exit_beastmode");
	bb::logplayerevent(self, "exit_beast_mode");
	self thread wait_invulnerable(2);
	self thread wait_enable_offhand_weapons(3);
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
	self allowdoublejump(0);
	self allowslide(1);
	self StopShellshock();
	self.inhibit_scoring_from_zombies = 0;
	self.beastmode = 0;
	self flag::clear("in_beastmode");
	self.get_revive_time = undefined;
	self.weaponReviveTool = undefined;
	self.overridePlayerDamage = self.overrideplayerdamage_original;
	self.overrideplayerdamage_original = undefined;
	if(level clientfield::get("bm_superbeast"))
	{
		was_superbeast = 1;
		self.superbeastmana = 0;
		self.see_kiosks_in_altbody = 0;
		self.trigger_kiosks_in_altbody = 0;
		self.custom_altbody_callback = undefined;
	}
	else
	{
		was_superbeast = 0;
	}
	self thread wait_and_appear(was_superbeast);
}

/*
	Name: wait_and_appear
	Namespace: zm_altbody_beast
	Checksum: 0x1617416E
	Offset: 0x1EB8
	Size: 0x643
	Parameters: 1
	Flags: None
*/
function wait_and_appear(no_ignore)
{
	self SetOrigin(self.beast_mode_return_origin);
	self FreezeControls(1);
	v_return_pos = self.beast_mode_return_origin + VectorScale((0, 0, 1), 60);
	a_ai = GetAITeamArray(level.zombie_team);
	a_closest = [];
	ai_closest = undefined;
	if(a_ai.size)
	{
		a_closest = ArraySortClosest(a_ai, self.beast_mode_return_origin);
		foreach(ai in a_closest)
		{
			n_trace_val = ai SightConeTrace(v_return_pos, self);
			if(n_trace_val > 0.2)
			{
				ai_closest = ai;
				break;
			}
		}
		if(isdefined(ai_closest))
		{
			self SetPlayerAngles(VectorToAngles(ai_closest GetCentroid() - v_return_pos));
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
		self SetPlayerAngles(self.beast_mode_return_angles + VectorScale((0, 1, 0), 180));
	}
	wait(0.5);
	self zm_utility::decrement_is_drinking();
	self zm_weapons::suppress_stowed_weapon(0);
	self show();
	self playsound("evt_beastmode_exit");
	self zm_utility::clear_streamer_hint();
	playFX(level._effect["human_disappears"], self.beast_mode_return_origin);
	playFX(level._effect["beast_return_aoe"], self.beast_mode_return_origin);
	a_ai = GetAIArray();
	a_aoe_ai = ArraySortClosest(a_ai, self.beast_mode_return_origin, a_ai.size, 0, 200);
	foreach(ai in a_aoe_ai)
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
			ai DoDamage(ai.health + 1000, self.beast_mode_return_origin, self);
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
	b_superbeastmode = level clientfield::get("bm_superbeast");
	if(!no_ignore && !b_superbeastmode)
	{
		self zm_utility::decrement_ignoreme();
	}
	level notify("a_player_exited_beast_mode", self);
	self thread zm_audio::create_and_play_dialog("beastmode", "exit");
}

/*
	Name: wait_invulnerable
	Namespace: zm_altbody_beast
	Checksum: 0xC0A4AB60
	Offset: 0x2508
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function wait_invulnerable(time)
{
	was_inv = self EnableInvulnerability();
	wait(time);
	if(isdefined(self) && (!isdefined(was_inv) && was_inv))
	{
		self DisableInvulnerability();
	}
}

/*
	Name: wait_enable_offhand_weapons
	Namespace: zm_altbody_beast
	Checksum: 0x3ECB7F90
	Offset: 0x2578
	Size: 0x16F
	Parameters: 1
	Flags: None
*/
function wait_enable_offhand_weapons(time)
{
	self disableOffhandWeapons();
	wait(time);
	if(isdefined(self))
	{
		self EnableOffhandWeapons();
	}
	if(isdefined(self.beast_grenades_missed) && self.beast_grenades_missed)
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
	self.beast_grenades_missed = 0;
}

/*
	Name: player_allow_beastmode
	Namespace: zm_altbody_beast
	Checksum: 0xD0755861
	Offset: 0x26F0
	Size: 0xE7
	Parameters: 2
	Flags: None
*/
function player_allow_beastmode(name, kiosk)
{
	b_superbeastmode = level clientfield::get("bm_superbeast");
	if(!level flagsys::get("start_zombie_round_logic"))
	{
		return 0;
	}
	if(isdefined(self.beastmode) && self.beastmode && !b_superbeastmode)
	{
		return 0;
	}
	if(isdefined(kiosk) && !kiosk_allowed(kiosk))
	{
		return 0;
	}
	if(level clientfield::get("bm_superbeast"))
	{
		return 1;
	}
	return self.beastlives >= 1;
}

/*
	Name: kiosk_allowed
	Namespace: zm_altbody_beast
	Checksum: 0xEDC001EB
	Offset: 0x27E0
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function kiosk_allowed(kiosk)
{
	return !isdefined(kiosk.is_cooling_down) && kiosk.is_cooling_down;
}

/*
	Name: player_on_connect
	Namespace: zm_altbody_beast
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
	Namespace: zm_altbody_beast
	Checksum: 0xAFA1D322
	Offset: 0x2848
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function player_on_spawned()
{
	level flag::wait_till("initial_players_connected");
	self.beastmana = 1;
	if(level flag::get("solo_game"))
	{
		self.beastlives = 3;
	}
	else
	{
		self.beastlives = 1;
	}
	self thread update_kiosk_effects();
	self thread player_watch_mana();
	self player_update_beast_mode_objects(0);
}

/*
	Name: make_powerups_grapplable
	Namespace: zm_altbody_beast
	Checksum: 0x34C86644
	Offset: 0x2910
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function make_powerups_grapplable()
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
	Namespace: zm_altbody_beast
	Checksum: 0x2BF244E
	Offset: 0x2978
	Size: 0x149
	Parameters: 1
	Flags: None
*/
function function_10dcd1d5(kiosk_name)
{
	level.beast_kiosks = struct::get_array(kiosk_name, "targetname");
	foreach(kiosk in level.beast_kiosks)
	{
		kiosk.player_label = kiosk_name + "_plr_" + kiosk.origin;
		kiosk.var_39a60f4a = kiosk_name + "_crs_" + kiosk.origin;
		clientfield::register("world", kiosk.player_label, 1, 4, "int");
		kiosk thread _kiosk_cooldown();
	}
}

/*
	Name: update_kiosk_effects
	Namespace: zm_altbody_beast
	Checksum: 0xE13FC731
	Offset: 0x2AD0
	Size: 0x167
	Parameters: 0
	Flags: None
*/
function update_kiosk_effects()
{
	self endon("death");
	while(isdefined(self))
	{
		n_ent_num = self GetEntityNumber();
		foreach(kiosk in level.beast_kiosks)
		{
			n_players_allowed = level clientfield::get(kiosk.player_label);
			if(kiosk_allowed(kiosk))
			{
				n_players_allowed = n_players_allowed | 1 << n_ent_num;
			}
			else
			{
				~n_players_allowed;
				n_players_allowed = n_players_allowed & 1 << n_ent_num;
			}
			level clientfield::set(kiosk.player_label, n_players_allowed);
		}
		wait(RandomFloatRange(0.2, 0.5));
	}
}

/*
	Name: get_number_of_available_kiosks
	Namespace: zm_altbody_beast
	Checksum: 0x9C35D71A
	Offset: 0x2C40
	Size: 0xA5
	Parameters: 0
	Flags: None
*/
function get_number_of_available_kiosks()
{
	n_available_kiosks = 0;
	foreach(kiosk in level.beast_kiosks)
	{
		if(kiosk_allowed(kiosk))
		{
			n_available_kiosks++;
		}
	}
	return n_available_kiosks;
}

/*
	Name: function_f6014f2c
	Namespace: zm_altbody_beast
	Checksum: 0x4ABCEC3B
	Offset: 0x2CF0
	Size: 0xF5
	Parameters: 2
	Flags: None
*/
function function_f6014f2c(v_origin, var_8ebf7724)
{
	a_kiosks = ArraySortClosest(level.beast_kiosks, v_origin);
	a_kiosks = Array::filter(a_kiosks, 0, &function_b7520b09);
	for(i = 0; i < a_kiosks.size && i < var_8ebf7724; i++)
	{
		zm_zod_util::function_5cc835d6(v_origin, a_kiosks[i].origin, 1);
		a_kiosks[i].is_cooling_down = 0;
		wait(0.05);
	}
}

/*
	Name: function_b7520b09
	Namespace: zm_altbody_beast
	Checksum: 0xE9206972
	Offset: 0x2DF0
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function function_b7520b09(s_kiosk)
{
	if(!isdefined(s_kiosk) || !isdefined(s_kiosk.is_cooling_down) || !s_kiosk.is_cooling_down)
	{
		return 0;
	}
	return 1;
}

/*
	Name: kiosk_cooldown
	Namespace: zm_altbody_beast
	Checksum: 0x652DC63A
	Offset: 0x2E40
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function kiosk_cooldown()
{
	while(1)
	{
		level waittill("kiosk_used", e_kiosk);
		if(isdefined(e_kiosk))
		{
			e_kiosk thread _kiosk_cooldown();
		}
	}
}

/*
	Name: round_number
	Namespace: zm_altbody_beast
	Checksum: 0x3B7A2C2F
	Offset: 0x2E90
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function round_number()
{
	n_start_round = 0;
	if(isdefined(level.round_number))
	{
		n_start_round = level.round_number;
	}
	return n_start_round;
}

/*
	Name: _kiosk_cooldown
	Namespace: zm_altbody_beast
	Checksum: 0xA7E37804
	Offset: 0x2EC8
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function _kiosk_cooldown()
{
	self notify("_kiosk_cooldown");
	self endon("_kiosk_cooldown");
	self.is_cooling_down = 1;
	n_start_round = round_number();
	while(round_number() - n_start_round < 1)
	{
		level waittill("start_of_round");
	}
	self.is_cooling_down = 0;
}

/*
	Name: function_fd8fb00d
	Namespace: zm_altbody_beast
	Checksum: 0x2AF48D55
	Offset: 0x2F58
	Size: 0x10D
	Parameters: 1
	Flags: None
*/
function function_fd8fb00d(b_cooldown)
{
	if(!isdefined(b_cooldown))
	{
		b_cooldown = 1;
	}
	foreach(kiosk in level.beast_kiosks)
	{
		if(b_cooldown)
		{
			if(!(isdefined(kiosk.is_cooling_down) && kiosk.is_cooling_down))
			{
				kiosk thread _kiosk_cooldown();
			}
			continue;
		}
		if(isdefined(kiosk.is_cooling_down) && kiosk.is_cooling_down)
		{
			kiosk.is_cooling_down = 0;
		}
	}
}

/*
	Name: player_watch_cancel
	Namespace: zm_altbody_beast
	Checksum: 0xF193C9DA
	Offset: 0x3070
	Size: 0xDF
	Parameters: 0
	Flags: None
*/
function player_watch_cancel()
{
	self endon("player_exit_beastmode");
	self endon("death");
	if(!self flag::exists("beast_hint_shown"))
	{
		self flag::init("beast_hint_shown");
	}
	if(!self flag::get("beast_hint_shown"))
	{
		self thread beast_cancel_hint();
	}
	self.beast_cancel_timer = 0;
	while(isdefined(self))
	{
		if(self StanceButtonPressed())
		{
			self notify("hide_equipment_hint_text");
			self player_stance_hold_think();
		}
		wait(0.05);
	}
}

/*
	Name: beast_cancel_hint
	Namespace: zm_altbody_beast
	Checksum: 0xF6B53B9C
	Offset: 0x3158
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function beast_cancel_hint()
{
	hint = &"ZM_ZOD_EXIT_BEAST_MODE_HINT";
	y = 315;
	if(level.players.size > 1)
	{
		hint = &"ZM_ZOD_EXIT_BEAST_MODE_HINT_COOP";
		y = 285;
	}
	self thread watch_beast_hint_use(12, 12.05);
	self thread watch_beast_hint_end(12, 12.05);
	zm_equipment::show_hint_text(hint, 12.05, 1.5, y);
}

/*
	Name: watch_beast_hint_use
	Namespace: zm_altbody_beast
	Checksum: 0x36FDECEB
	Offset: 0x3220
	Size: 0x73
	Parameters: 2
	Flags: None
*/
function watch_beast_hint_use(minTime, maxTime)
{
	self endon("disconnect");
	self util::waittill_any_timeout(maxTime, "smashable_smashed", "grapplable_grappled", "shockable_shocked", "disconnect");
	self flag::set("beast_hint_shown");
}

/*
	Name: watch_beast_hint_end
	Namespace: zm_altbody_beast
	Checksum: 0xD3825F44
	Offset: 0x32A0
	Size: 0x61
	Parameters: 2
	Flags: None
*/
function watch_beast_hint_end(minTime, maxTime)
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
	Name: player_stance_hold_think
	Namespace: zm_altbody_beast
	Checksum: 0xF3D55F35
	Offset: 0x3310
	Size: 0x81
	Parameters: 0
	Flags: None
*/
function player_stance_hold_think()
{
	self thread player_stance_hold_think_internal();
	retval = self util::waittill_any_return("exit_succeed", "exit_failed");
	if(retval == "exit_succeed")
	{
		self notify("altbody_end");
		return 1;
	}
	self.beast_cancel_timer = 0;
	return 0;
}

/*
	Name: function_92acebd3
	Namespace: zm_altbody_beast
	Checksum: 0x2D958236
	Offset: 0x33A0
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function function_92acebd3()
{
	self endon("player_exit_beastmode");
	self endon("death");
	self waittill("player_did_a_revive");
	self PlayRumbleOnEntity("damage_heavy");
	wait(1.5);
	self player_take_mana(1);
	self notify("altbody_end");
}

/*
	Name: player_continue_cancel
	Namespace: zm_altbody_beast
	Checksum: 0xE613F32B
	Offset: 0x3428
	Size: 0x59
	Parameters: 0
	Flags: None
*/
function player_continue_cancel()
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
	Name: player_stance_hold_think_internal
	Namespace: zm_altbody_beast
	Checksum: 0xEE455655
	Offset: 0x3490
	Size: 0xF5
	Parameters: 0
	Flags: None
*/
function player_stance_hold_think_internal()
{
	wait(0.05);
	if(!isdefined(self))
	{
		self notify("exit_failed");
		return;
	}
	self.beast_cancel_timer = GetTime();
	build_time = 1000;
	self thread player_beast_cancel_bar(self.beast_cancel_timer, build_time);
	while(isdefined(self) && self player_continue_cancel() && GetTime() - self.beast_cancel_timer < build_time)
	{
		wait(0.05);
	}
	if(isdefined(self) && self player_continue_cancel() && GetTime() - self.beast_cancel_timer >= build_time)
	{
		self notify("exit_succeed");
	}
	else
	{
		self notify("exit_failed");
	}
}

/*
	Name: player_beast_cancel_bar
	Namespace: zm_altbody_beast
	Checksum: 0x69CF82F1
	Offset: 0x3590
	Size: 0xC3
	Parameters: 2
	Flags: None
*/
function player_beast_cancel_bar(start_time, build_time)
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
	Namespace: zm_altbody_beast
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
	self endon("player_exit_beastmode");
	self endon("exit_failed");
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
	Name: player_take_mana
	Namespace: zm_altbody_beast
	Checksum: 0xE16133D8
	Offset: 0x3738
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function player_take_mana(mana)
{
	self.beastmana = self.beastmana - mana;
	if(self.beastmana <= 0)
	{
		self.beastmana = 0;
		self notify("altbody_end");
	}
}

/*
	Name: player_give_lives
	Namespace: zm_altbody_beast
	Checksum: 0xDCF78A2C
	Offset: 0x3798
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function player_give_lives(lives)
{
	self.beastlives = self.beastlives + lives;
	if(level flag::get("solo_game"))
	{
		if(self.beastlives > 3)
		{
			self.beastlives = 3;
		}
	}
	else if(self.beastlives > 1)
	{
		self.beastlives = 1;
	}
}

/*
	Name: player_take_lives
	Namespace: zm_altbody_beast
	Checksum: 0xC75E794E
	Offset: 0x3820
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function player_take_lives(lives)
{
	self.beastlives = self.beastlives - lives;
	if(self.beastmana <= 0)
	{
		self.beastlives = 0;
	}
}

/*
	Name: player_give_mana
	Namespace: zm_altbody_beast
	Checksum: 0x456C4FC5
	Offset: 0x3860
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function player_give_mana(mana)
{
	self.beastmana = self.beastmana + mana;
	if(self.beastmana > 1)
	{
		self.beastmana = 1;
	}
}

/*
	Name: player_get_revive_time
	Namespace: zm_altbody_beast
	Checksum: 0x66739CD9
	Offset: 0x38B0
	Size: 0x11
	Parameters: 1
	Flags: None
*/
function player_get_revive_time(player_being_revived)
{
	return 0.75;
}

/*
	Name: player_damage_override_beast_mode
	Namespace: zm_altbody_beast
	Checksum: 0x338AEC33
	Offset: 0x38D0
	Size: 0x1FD
	Parameters: 10
	Flags: None
*/
function player_damage_override_beast_mode(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(isdefined(eAttacker) && isPlayer(eAttacker))
	{
		return 0;
	}
	b_superbeastmode = level clientfield::get("bm_superbeast");
	if(b_superbeastmode)
	{
		superbeastdamage = iDamage * 0.0005;
		if(superbeastdamage > 0.4)
		{
			superbeastdamage = 0.4;
			self thread zm_zod_util::set_rumble_to_player(3);
		}
		else
		{
			self thread zm_zod_util::set_rumble_to_player(2);
		}
		self.superbeastmana = self.superbeastmana - superbeastdamage;
		if(self.superbeastmana <= 0)
		{
			self notify("altbody_end");
			self player_take_mana(1);
			self.beastlives = 1;
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
	self notify("altbody_end");
	self player_take_mana(1);
	return 0;
}

/*
	Name: player_check_grenades
	Namespace: zm_altbody_beast
	Checksum: 0x31104357
	Offset: 0x3AD8
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function player_check_grenades()
{
	if(isdefined(self.beastmode) && self.beastmode)
	{
		self.beast_grenades_missed = 1;
	}
}

/*
	Name: watch_round_start_mana
	Namespace: zm_altbody_beast
	Checksum: 0x9DD5268E
	Offset: 0x3B08
	Size: 0x19D
	Parameters: 0
	Flags: None
*/
function watch_round_start_mana()
{
	level waittill("start_of_round");
	foreach(player in GetPlayers())
	{
		player player_check_grenades();
	}
	while(1)
	{
		level waittill("start_of_round");
		foreach(player in GetPlayers())
		{
			if(!(isdefined(player.beastmode) && player.beastmode))
			{
				player player_give_mana(1);
			}
			player player_give_lives(1);
			player player_check_grenades();
		}
	}
}

/*
	Name: player_watch_mana
	Namespace: zm_altbody_beast
	Checksum: 0x7D4503F1
	Offset: 0x3CB0
	Size: 0x1F7
	Parameters: 0
	Flags: None
*/
function player_watch_mana()
{
	if(!isdefined(self.superbeastmana))
	{
		self.superbeastmana = 0;
	}
	self notify("player_watch_mana");
	self endon("player_watch_mana");
	while(isdefined(self))
	{
		if(isdefined(level.hostMigrationTimer) && level.hostMigrationTimer)
		{
			wait(1);
			continue;
		}
		if(isdefined(self.beastmode) && self.beastmode && (!isdefined(self.teleporting) && self.teleporting))
		{
			self player_take_mana(1 / 500);
		}
		if(level clientfield::get("bm_superbeast"))
		{
			n_mapped_mana = math::linear_map(self.superbeastmana, 0, 1, 0, 1);
		}
		else
		{
			n_mapped_mana = math::linear_map(self.beastmana, 0, 1, 0, 1);
		}
		self clientfield::set_player_uimodel("player_mana", n_mapped_mana);
		lives = self.beastlives;
		if(lives != self clientfield::get_player_uimodel("player_lives"))
		{
			player_give_lives(0);
			lives = self.beastlives;
			self clientfield::set_player_uimodel("player_lives", lives);
		}
		wait(0.05);
	}
}

/*
	Name: player_on_killed
	Namespace: zm_altbody_beast
	Checksum: 0x12BFB3AD
	Offset: 0x3EB0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function player_on_killed()
{
	self notify("altbody_end");
	self player_take_mana(1);
}

/*
	Name: hide_ooze_triggers
	Namespace: zm_altbody_beast
	Checksum: 0xF77787BB
	Offset: 0x3EE8
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function hide_ooze_triggers()
{
	level flagsys::wait_till("start_zombie_round_logic");
	Ooo = GetEntArray("ooze_only", "script_noteworthy");
	Array::thread_all(Ooo, &trigger_ooze_only);
	Moo = GetEntArray("beast_melee_only", "script_noteworthy");
	Array::thread_all(Moo, &trigger_melee_only);
	goo = GetEntArray("beast_grapple_only", "script_noteworthy");
	Array::thread_all(goo, &trigger_grapple_only);
}

/*
	Name: player_update_beast_mode_objects
	Namespace: zm_altbody_beast
	Checksum: 0xB2DB1481
	Offset: 0x4008
	Size: 0x143
	Parameters: 1
	Flags: None
*/
function player_update_beast_mode_objects(onOff)
{
	bmo = GetEntArray("beast_mode", "script_noteworthy");
	if(isdefined(level.get_beast_mode_objects))
	{
		more_bmo = [[level.get_beast_mode_objects]]();
		bmo = ArrayCombine(bmo, more_bmo, 0, 0);
	}
	Array::run_all(bmo, &entity_set_visible, self, onOff);
	bmho = GetEntArray("not_beast_mode", "script_noteworthy");
	if(isdefined(level.get_beast_mode_hide_objects))
	{
		more_bmho = [[level.get_beast_mode_hide_objects]]();
		bmho = ArrayCombine(bmho, more_bmho, 0, 0);
	}
	Array::run_all(bmho, &entity_set_visible, self, !onOff);
}

/*
	Name: entity_set_visible
	Namespace: zm_altbody_beast
	Checksum: 0x83E9767
	Offset: 0x4158
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function entity_set_visible(player, onOff)
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
	Name: player_watch_melee_charge
	Namespace: zm_altbody_beast
	Checksum: 0xCD3A3065
	Offset: 0x41B8
	Size: 0x51
	Parameters: 0
	Flags: None
*/
function player_watch_melee_charge()
{
	self endon("player_exit_beastmode");
	self endon("death");
	while(isdefined(self))
	{
		self waittill("weapon_melee_charge", weapon);
		self notify("weapon_melee", weapon);
	}
}

/*
	Name: player_watch_melee_power
	Namespace: zm_altbody_beast
	Checksum: 0x2612113F
	Offset: 0x4218
	Size: 0x51
	Parameters: 0
	Flags: None
*/
function player_watch_melee_power()
{
	self endon("player_exit_beastmode");
	self endon("death");
	while(isdefined(self))
	{
		self waittill("weapon_melee_power", weapon);
		self notify("weapon_melee", weapon);
	}
}

/*
	Name: player_watch_melee
	Namespace: zm_altbody_beast
	Checksum: 0xD92DA702
	Offset: 0x4278
	Size: 0x14F
	Parameters: 0
	Flags: None
*/
function player_watch_melee()
{
	self endon("player_exit_beastmode");
	self endon("death");
	while(isdefined(self))
	{
		self waittill("weapon_melee", weapon);
		if(weapon == GetWeapon("zombie_beast_grapple_dwr"))
		{
			self player_take_mana(0.03);
			FORWARD = AnglesToForward(self getPlayerAngles());
			up = anglesToUp(self getPlayerAngles());
			meleepos = self.origin + 15 * up + 30 * FORWARD;
			level notify("beast_melee", self, meleepos);
			self RadiusDamage(meleepos, 48, 5000, 5000, self, "MOD_MELEE");
		}
	}
}

/*
	Name: player_watch_melee_juke
	Namespace: zm_altbody_beast
	Checksum: 0xA8E0104
	Offset: 0x43D0
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function player_watch_melee_juke()
{
	self endon("player_exit_beastmode");
	self endon("death");
	while(isdefined(self))
	{
		self waittill("weapon_melee_juke", weapon);
		if(weapon == GetWeapon("zombie_beast_grapple_dwr"))
		{
			player_beast_melee_juke(weapon);
		}
	}
}

/*
	Name: player_beast_melee_juke
	Namespace: zm_altbody_beast
	Checksum: 0xD972A214
	Offset: 0x4450
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function player_beast_melee_juke(weapon)
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
	Name: trigger_touching_meleepos
	Namespace: zm_altbody_beast
	Checksum: 0xB66EA038
	Offset: 0x44D0
	Size: 0x79
	Parameters: 2
	Flags: None
*/
function trigger_touching_meleepos(meleepos, radius)
{
	mins = (radius * -1, radius * -1, radius * -1);
	maxs = (radius, radius, radius);
	return self IsTouchingVolume(meleepos, mins, maxs);
}

/*
	Name: trigger_melee_only
	Namespace: zm_altbody_beast
	Checksum: 0x1B4878ED
	Offset: 0x4558
	Size: 0x10F
	Parameters: 0
	Flags: None
*/
function trigger_melee_only()
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
		level waittill("beast_melee", player, meleepos);
		if(isdefined(self) && self trigger_touching_meleepos(meleepos, 48))
		{
			self UseBy(player);
		}
	}
}

/*
	Name: is_lightning_weapon
	Namespace: zm_altbody_beast
	Checksum: 0x7C1ED15
	Offset: 0x4670
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function is_lightning_weapon(weapon)
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
	Name: lightning_weapon_level
	Namespace: zm_altbody_beast
	Checksum: 0x52374B7B
	Offset: 0x46F8
	Size: 0x8F
	Parameters: 1
	Flags: None
*/
function lightning_weapon_level(weapon)
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
	Name: player_watch_lightning
	Namespace: zm_altbody_beast
	Checksum: 0xB9DDC1D7
	Offset: 0x4790
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function player_watch_lightning()
{
	self endon("player_exit_beastmode");
	self endon("death");
	self.tesla_enemies = undefined;
	self.tesla_enemies_hit = 0;
	self.tesla_powerup_dropped = 0;
	self.tesla_arc_count = 0;
	while(isdefined(self))
	{
		self waittill("weapon_fired", weapon);
		if(is_lightning_weapon(weapon))
		{
			self player_take_mana(0);
		}
	}
}

/*
	Name: lightning_aoe
	Namespace: zm_altbody_beast
	Checksum: 0x3F65BA91
	Offset: 0x4838
	Size: 0x27F
	Parameters: 1
	Flags: None
*/
function lightning_aoe(weapon)
{
	self endon("disconnect");
	self.tesla_enemies = undefined;
	self.tesla_enemies_hit = 0;
	self.tesla_powerup_dropped = 0;
	self.tesla_arc_count = 0;
	shocklevel = lightning_weapon_level(weapon);
	shockradius = 36;
	switch(shocklevel)
	{
		case 2:
		{
			shockradius = 72;
			break;
		}
		case 3:
		{
			shockradius = 108;
			break;
		}
	}
	FORWARD = AnglesToForward(self getPlayerAngles());
	up = anglesToUp(self getPlayerAngles());
	center = self.origin + 16 * up + 24 * FORWARD;
	if(shocklevel > 1)
	{
		playFX(level._effect["beast_shock_aoe"], center);
	}
	zombies = Array::get_all_closest(center, GetAITeamArray(level.zombie_team), undefined, undefined, shockradius);
	foreach(zombie in zombies)
	{
		zombie thread arc_damage_init(zombie.origin, center, self, shocklevel);
		zombie notify("bhtn_action_notify", "electrocute");
	}
	wait(0.05);
	self.tesla_enemies_hit = 0;
}

/*
	Name: arc_damage_init
	Namespace: zm_altbody_beast
	Checksum: 0xCCAE80DA
	Offset: 0x4AC0
	Size: 0xDB
	Parameters: 4
	Flags: None
*/
function arc_damage_init(HIT_LOCATION, hit_origin, player, shocklevel)
{
	player endon("disconnect");
	if(isdefined(self.zombie_tesla_hit) && self.zombie_tesla_hit)
	{
		return;
	}
	if(shocklevel < 2)
	{
		self lightning_chain::arc_damage(self, player, 1, level.beast_lightning_level_1);
	}
	else if(shocklevel < 3)
	{
		self lightning_chain::arc_damage(self, player, 1, level.beast_lightning_level_2);
	}
	else
	{
		self lightning_chain::arc_damage(self, player, 1, level.beast_lightning_level_3);
	}
}

/*
	Name: create_lightning_params
	Namespace: zm_altbody_beast
	Checksum: 0x34DC2009
	Offset: 0x4BA8
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function create_lightning_params()
{
	level.beast_lightning_level_1 = lightning_chain::create_lightning_chain_params(1);
	level.beast_lightning_level_1.should_kill_enemies = 0;
	level.beast_lightning_level_2 = lightning_chain::create_lightning_chain_params(2);
	level.beast_lightning_level_2.should_kill_enemies = 0;
	level.beast_lightning_level_2.clientside_fx = 0;
	level.beast_lightning_level_3 = lightning_chain::create_lightning_chain_params(3);
	level.beast_lightning_level_3.should_kill_enemies = 0;
	level.beast_lightning_level_3.clientside_fx = 0;
}

/*
	Name: get_grapple_targets
	Namespace: zm_altbody_beast
	Checksum: 0xFCF77A8B
	Offset: 0x4C78
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function get_grapple_targets()
{
	if(!isdefined(level.beast_mode_targets))
	{
		level.beast_mode_targets = [];
	}
	return level.beast_mode_targets;
}

/*
	Name: trigger_grapple_only
	Namespace: zm_altbody_beast
	Checksum: 0xF36560DD
	Offset: 0x4CA8
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function trigger_grapple_only()
{
	self endon("death");
	level flagsys::wait_till("start_zombie_round_logic");
	self SetInvisibleToAll();
	while(isdefined(self))
	{
		level waittill("grapple_hit", target, player);
		if(isdefined(self) && target istouching(self))
		{
			self UseBy(player);
		}
	}
}

/*
	Name: player_watch_grapple
	Namespace: zm_altbody_beast
	Checksum: 0x504693AB
	Offset: 0x4D60
	Size: 0x117
	Parameters: 0
	Flags: None
*/
function player_watch_grapple()
{
	self endon("player_exit_beastmode");
	self endon("death");
	grapple = GetWeapon("zombie_beast_grapple_dwr");
	while(isdefined(self))
	{
		self waittill("grapple_fired", weapon);
		if(weapon == grapple)
		{
			if(isdefined(self.lockonentity))
			{
				if(!self function_668dcfac(self.lockonentity))
				{
					self.lockonentity = undefined;
				}
			}
			self player_take_mana(0);
			self thread player_beast_grapple_rumble(weapon, "zod_beast_grapple_out", 0.4);
		}
	}
}

/*
	Name: function_668dcfac
	Namespace: zm_altbody_beast
	Checksum: 0x287B2FC2
	Offset: 0x4E80
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function function_668dcfac(target)
{
	if(isdefined(target.grapple_lock) && target.grapple_lock)
	{
		return 0;
	}
	target.grapple_lock = 1;
	self thread function_b8488073(target, 5);
	return 1;
}

/*
	Name: function_b8488073
	Namespace: zm_altbody_beast
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
		target.grapple_lock = undefined;
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
	Name: player_beast_grapple_rumble
	Namespace: zm_altbody_beast
	Checksum: 0xF4CBDE7C
	Offset: 0x5000
	Size: 0x8D
	Parameters: 3
	Flags: None
*/
function player_beast_grapple_rumble(weapon, rumble, length)
{
	self endon("grapple_stick");
	self endon("grapple_pulled");
	self endon("grapple_landed");
	self endon("grapple_cancel");
	start_time = GetTime();
	while(start_time + 3000 > GetTime())
	{
		self PlayRumbleOnEntity(rumble);
		wait(length);
	}
}

/*
	Name: grapple_valid_target_check
	Namespace: zm_altbody_beast
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
	Name: zombie_on_spawn
	Namespace: zm_altbody_beast
	Checksum: 0xE2A8F73A
	Offset: 0x5118
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function zombie_on_spawn()
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
	Name: player_watch_grappled_object
	Namespace: zm_altbody_beast
	Checksum: 0xF61B4941
	Offset: 0x51B8
	Size: 0x14F
	Parameters: 0
	Flags: None
*/
function player_watch_grappled_object()
{
	self endon("player_exit_beastmode");
	self endon("death");
	grapple = GetWeapon("zombie_beast_grapple_dwr");
	while(isdefined(self))
	{
		self waittill("grapple_stick", weapon, target);
		if(weapon == grapple)
		{
			self notify("grapplable_grappled");
			self PlayRumbleOnEntity("zod_beast_grapple_hit");
			if(isdefined(target))
			{
				if(isdefined(target.is_zombie) && target.is_zombie)
				{
					target zombie_gets_pulled(self);
				}
			}
			level notify("grapple_hit", target, self, isdefined(self.pivotentity) && !isPlayer(self.pivotentity));
			playsoundatposition("wpn_beastmode_grapple_imp", target.origin);
		}
	}
}

/*
	Name: player_watch_grapple_traverse
	Namespace: zm_altbody_beast
	Checksum: 0xBFDD6FB0
	Offset: 0x5310
	Size: 0xFF
	Parameters: 0
	Flags: None
*/
function player_watch_grapple_traverse()
{
	self endon("player_exit_beastmode");
	self endon("death");
	grapple = GetWeapon("zombie_beast_grapple_dwr");
	while(isdefined(self))
	{
		self waittill("grapple_reelin", weapon, target);
		if(weapon == grapple)
		{
			origin = target.origin;
			self thread player_watch_grapple_landing(origin);
			self playsound("wpn_beastmode_grapple_pullin");
			wait(0.15);
			self thread player_beast_grapple_rumble(weapon, "zod_beast_grapple_reel", 0.2);
		}
	}
}

/*
	Name: player_watch_grapple_landing
	Namespace: zm_altbody_beast
	Checksum: 0xCDE95143
	Offset: 0x5418
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function player_watch_grapple_landing(origin)
{
	self endon("player_exit_beastmode");
	self endon("death");
	self notify("player_watch_grapple_landing");
	self endon("player_watch_grapple_landing");
	self waittill("grapple_landed", weapon, target);
	if(Distance2DSquared(self.origin, origin) > 1024)
	{
		self SetOrigin(origin + VectorScale((0, 0, -1), 60));
	}
}

/*
	Name: player_watch_grappled_zombies
	Namespace: zm_altbody_beast
	Checksum: 0x47D11806
	Offset: 0x54D0
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function player_watch_grappled_zombies()
{
	self endon("player_exit_beastmode");
	self endon("death");
	grapple = GetWeapon("zombie_beast_grapple_dwr");
	while(isdefined(self))
	{
		self waittill("grapple_pullin", weapon, target);
		if(weapon == grapple)
		{
			wait(0.15);
			self thread player_beast_grapple_rumble(weapon, "zod_beast_grapple_pull", 0.2);
		}
	}
}

/*
	Name: player_kill_grappled_zombies
	Namespace: zm_altbody_beast
	Checksum: 0x861E5BB1
	Offset: 0x5588
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function player_kill_grappled_zombies()
{
	self endon("player_exit_beastmode");
	self endon("death");
	grapple = GetWeapon("zombie_beast_grapple_dwr");
	while(isdefined(self))
	{
		self waittill("grapple_pulled", weapon, target);
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
	Name: zombie_gets_pulled
	Namespace: zm_altbody_beast
	Checksum: 0xD22F52EF
	Offset: 0x5668
	Size: 0x213
	Parameters: 1
	Flags: None
*/
function zombie_gets_pulled(player)
{
	self.grapple_is_fatal = 1;
	zombie_to_player = player.origin - self.origin;
	zombie_to_player_2d = VectorNormalize((zombie_to_player[0], zombie_to_player[1], 0));
	zombie_forward = AnglesToForward(self.angles);
	zombie_forward_2d = VectorNormalize((zombie_forward[0], zombie_forward[1], 0));
	zombie_right = AnglesToRight(self.angles);
	zombie_right_2d = VectorNormalize((zombie_right[0], zombie_right[1], 0));
	dot = VectorDot(zombie_to_player_2d, zombie_forward_2d);
	if(dot >= 0.5)
	{
		self.GRAPPLE_DIRECTION = "front";
	}
	else if(dot < 0.5 && dot > -0.5)
	{
		dot = VectorDot(zombie_to_player_2d, zombie_right_2d);
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
	Namespace: zm_altbody_beast
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
	Name: lightning_zombie_damage_response
	Namespace: zm_altbody_beast
	Checksum: 0xD6208464
	Offset: 0x5A40
	Size: 0x16B
	Parameters: 13
	Flags: None
*/
function lightning_zombie_damage_response(mod, HIT_LOCATION, hit_origin, player, amount, weapon, direction_vec, tagName, modelName, partName, dFlags, inflictor, chargeLevel)
{
	if(is_lightning_weapon(weapon))
	{
		shocklevel = lightning_weapon_level(weapon);
		self.tesla_death = 0;
		self thread arc_damage_init(HIT_LOCATION, hit_origin, player, shocklevel);
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
	Name: watch_lightning_damage
	Namespace: zm_altbody_beast
	Checksum: 0x67D0EBD9
	Offset: 0x5BB8
	Size: 0x23F
	Parameters: 1
	Flags: None
*/
function watch_lightning_damage(triggers)
{
	self endon("delete");
	self SetCanDamage(1);
	while(isdefined(triggers))
	{
		self waittill("damage", amount, attacker, direction, point, mod, tagName, modelName, partName, weapon);
		if(is_lightning_weapon(weapon) && isdefined(attacker) && amount > 0)
		{
			if(isdefined(attacker))
			{
				attacker notify("shockable_shocked");
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
	Name: beast_mode_death_watch
	Namespace: zm_altbody_beast
	Checksum: 0x8F8AD0B0
	Offset: 0x5E00
	Size: 0x25B
	Parameters: 1
	Flags: None
*/
function beast_mode_death_watch(attacker)
{
	if(isdefined(self.attacker) && (isdefined(self.attacker.beastmode) && self.attacker.beastmode))
	{
		self.no_powerups = 1;
		self.marked_for_recycle = 1;
		self.has_been_damaged_by_player = 0;
	}
	if(is_lightning_weapon(self.damageWeapon))
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
	Name: trigger_ooze_only
	Namespace: zm_altbody_beast
	Checksum: 0x8D940540
	Offset: 0x6068
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function trigger_ooze_only()
{
	self endon("death");
	level flagsys::wait_till("start_zombie_round_logic");
	self SetInvisibleToAll();
	while(isdefined(self))
	{
		level waittill("ooze_detonate", grenade, player);
		if(isdefined(self) && isdefined(grenade) && grenade istouching(self))
		{
			self UseBy(player);
		}
	}
}

/*
	Name: zombie_can_be_zapped
	Namespace: zm_altbody_beast
	Checksum: 0xBDA24DB1
	Offset: 0x6128
	Size: 0x85
	Parameters: 0
	Flags: None
*/
function zombie_can_be_zapped()
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
	Name: lightning_slow_zombie
	Namespace: zm_altbody_beast
	Checksum: 0x572BF128
	Offset: 0x61B8
	Size: 0x39B
	Parameters: 1
	Flags: None
*/
function lightning_slow_zombie(zombie)
{
	zombie endon("death");
	zombie notify("lightning_slow_zombie");
	zombie endon("lightning_slow_zombie");
	if(!zombie zombie_can_be_zapped())
	{
		return;
	}
	num = zombie GetEntityNumber();
	if(!isdefined(zombie.beast_slow_count))
	{
		zombie.beast_slow_count = 0;
	}
	zombie.beast_slow_count++;
	if(!isdefined(zombie.animation_rate))
	{
		zombie.animation_rate = 1;
	}
	zombie.slow_time_left = 8;
	zombie thread lightning_slow_zombie_fx(zombie);
	while(isdefined(zombie) && isalive(zombie) && zombie.animation_rate > 0.03)
	{
		zombie.animation_rate = zombie.animation_rate - 0.97 * 0.05;
		if(zombie.animation_rate < 0.03)
		{
			zombie.animation_rate = 0.03;
		}
		zombie ASMSetAnimationRate(zombie.animation_rate);
		zombie.slow_time_left = zombie.slow_time_left - 0.05;
		wait(0.05);
	}
	while(isdefined(zombie) && isalive(zombie) && zombie.slow_time_left > 0.5)
	{
		zombie.slow_time_left = zombie.slow_time_left - 0.05;
		wait(0.05);
	}
	while(isdefined(zombie) && isalive(zombie) && zombie.animation_rate < 1)
	{
		zombie.animation_rate = zombie.animation_rate + 0.97 * 0.1;
		if(zombie.animation_rate > 1)
		{
			zombie.animation_rate = 1;
		}
		zombie ASMSetAnimationRate(zombie.animation_rate);
		zombie.slow_time_left = zombie.slow_time_left - 0.05;
		wait(0.05);
	}
	zombie ASMSetAnimationRate(1);
	zombie.slow_time_left = 0;
	if(isdefined(zombie))
	{
		zombie.beast_slow_count--;
	}
}

/*
	Name: lightning_slow_zombie_fx
	Namespace: zm_altbody_beast
	Checksum: 0x301BA0F2
	Offset: 0x6560
	Size: 0xDD
	Parameters: 1
	Flags: None
*/
function lightning_slow_zombie_fx(zombie)
{
	tag = "J_SpineUpper";
	FX = "beast_shock";
	if(isdefined(zombie.isdog) && zombie.isdog)
	{
		tag = "J_Spine1";
	}
	while(isdefined(zombie) && isalive(zombie) && zombie.slow_time_left > 0)
	{
		zombie zm_net::network_safe_play_fx_on_tag("beast_slow_fx", 2, level._effect[FX], zombie, tag);
		wait(1);
	}
}

/*
	Name: function_41cc3fc8
	Namespace: zm_altbody_beast
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
		player thread player_update_beast_mode_objects(isdefined(player.beastmode) && player.beastmode);
	}
}

/*
	Name: function_d7b8b2f5
	Namespace: zm_altbody_beast
	Checksum: 0x87674772
	Offset: 0x6710
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function function_d7b8b2f5()
{
	self endon("player_exit_beastmode");
	self endon("altbody_end");
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
				self notify("altbody_end");
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
	Name: beastmode_devgui
	Namespace: zm_altbody_beast
	Checksum: 0x646FB2FA
	Offset: 0x67F0
	Size: 0x1CD
	Parameters: 0
	Flags: None
*/
function beastmode_devgui()
{
	/#
		level flagsys::wait_till("Dev Block strings are not supported");
		wait(1);
		zm_devgui::add_custom_devgui_callback(&beastmode_devgui_callback);
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
	Name: beastmode_devgui_callback
	Namespace: zm_altbody_beast
	Checksum: 0xEC8A7A23
	Offset: 0x69C8
	Size: 0x5EF
	Parameters: 1
	Flags: None
*/
function beastmode_devgui_callback(cmd)
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
				Array::thread_all(players, &player_zombie_devgui_beast_mode);
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				Array::thread_all(players, &player_zombie_devgui_superbeast_mode);
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
				a_str_ritual_flags = Array("Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported");
				foreach(str_ritual_flag in a_str_ritual_flags)
				{
					level flag::set(str_ritual_flag);
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
					players[0] thread player_zombie_devgui_beast_mode();
				}
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(players.size >= 2)
				{
					players[1] thread player_zombie_devgui_beast_mode();
				}
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(players.size >= 3)
				{
					players[2] thread player_zombie_devgui_beast_mode();
				}
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(players.size >= 4)
				{
					players[3] thread player_zombie_devgui_beast_mode();
				}
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				Array::thread_all(players, &player_zombie_devgui_beast_mode_preserve);
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(players.size >= 1)
				{
					players[0] thread player_zombie_devgui_beast_mode_preserve();
				}
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(players.size >= 2)
				{
					players[1] thread player_zombie_devgui_beast_mode_preserve();
				}
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(players.size >= 3)
				{
					players[2] thread player_zombie_devgui_beast_mode_preserve();
				}
				retval = 1;
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(players.size >= 4)
				{
					players[3] thread player_zombie_devgui_beast_mode_preserve();
				}
				retval = 1;
				break;
			}
		}
		return retval;
	#/
}

/*
	Name: player_zombie_devgui_beast_mode
	Namespace: zm_altbody_beast
	Checksum: 0x48C5B9DB
	Offset: 0x6FC0
	Size: 0x9D
	Parameters: 0
	Flags: None
*/
function player_zombie_devgui_beast_mode()
{
	/#
		if(self detect_reentry())
		{
			return;
		}
		level flagsys::wait_till("Dev Block strings are not supported");
		if(!(isdefined(self.beastmode) && self.beastmode))
		{
			self player_give_mana(1);
			self thread zm_altbody::devgui_start_altbody("Dev Block strings are not supported");
		}
		else
		{
			self notify("altbody_end");
		}
	#/
}

/*
	Name: player_zombie_devgui_superbeast_mode
	Namespace: zm_altbody_beast
	Checksum: 0x1CEECE13
	Offset: 0x7068
	Size: 0xD5
	Parameters: 0
	Flags: None
*/
function player_zombie_devgui_superbeast_mode()
{
	/#
		if(self detect_reentry())
		{
			return;
		}
		level flagsys::wait_till("Dev Block strings are not supported");
		b_superbeastmode = level clientfield::get("Dev Block strings are not supported");
		if(!isdefined(self.beastmode) && self.beastmode && !b_superbeastmode)
		{
			self player_give_mana(1);
			self thread zm_altbody::devgui_start_altbody("Dev Block strings are not supported");
		}
		else
		{
			self notify("altbody_end");
		}
	#/
}

/*
	Name: detect_reentry
	Namespace: zm_altbody_beast
	Checksum: 0x5B3BDFF5
	Offset: 0x7148
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function detect_reentry()
{
	/#
		if(isdefined(self.devgui_preserve_time))
		{
			if(self.devgui_preserve_time == GetTime())
			{
				return 1;
			}
		}
		self.devgui_preserve_time = GetTime();
		return 0;
	#/
}

/*
	Name: player_zombie_devgui_beast_mode_preserve
	Namespace: zm_altbody_beast
	Checksum: 0xCEFBD38E
	Offset: 0x7188
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function player_zombie_devgui_beast_mode_preserve()
{
	/#
		if(self detect_reentry())
		{
			return;
		}
		self notify("zombie_devgui_beast_mode_preserve");
		self endon("zombie_devgui_beast_mode_preserve");
		level flagsys::wait_till("Dev Block strings are not supported");
		self.devgui_preserve_beast_mode = !isdefined(self.devgui_preserve_beast_mode) && self.devgui_preserve_beast_mode;
		if(self.devgui_preserve_beast_mode)
		{
			while(isdefined(self))
			{
				self player_give_lives(3);
				self player_give_mana(1);
				wait(0.05);
			}
		}
	#/
}

