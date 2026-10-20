#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_genesis_portals;
#using scripts\zm\zm_genesis_util;

#namespace zm_genesis_flingers;

/*
	Name: function_976c9217
	Namespace: zm_genesis_flingers
	Checksum: 0xE649E65F
	Offset: 0x828
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function function_976c9217()
{
	register_clientfields();
	zm::register_player_damage_callback(&function_4b3d145d);
	var_fa27add4 = struct::get_array("115_flinger_pad_aimer", "targetname");
	Array::thread_all(var_fa27add4, &function_5ecbd7cb);
	level._effect["flinger_land_kill"] = "zombie/fx_bgb_anywhere_but_here_teleport_aoe_kill_zmb";
	level thread function_4208db02();
}

/*
	Name: register_clientfields
	Namespace: zm_genesis_flingers
	Checksum: 0xBEA5C760
	Offset: 0x8E8
	Size: 0x153
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("toplayer", "flinger_flying_postfx", 15000, 1, "int");
	clientfield::register("toplayer", "flinger_land_smash", 15000, 1, "counter");
	clientfield::register("toplayer", "flinger_cooldown_start", 15000, 4, "int");
	clientfield::register("toplayer", "flinger_cooldown_end", 15000, 4, "int");
	clientfield::register("scriptmover", "player_visibility", 15000, 1, "int");
	clientfield::register("scriptmover", "flinger_launch_fx", 15000, 1, "counter");
	clientfield::register("scriptmover", "flinger_pad_active_fx", 15000, 4, "int");
}

/*
	Name: function_5ecbd7cb
	Namespace: zm_genesis_flingers
	Checksum: 0x5EA007BB
	Offset: 0xA48
	Size: 0x45F
	Parameters: 0
	Flags: None
*/
function function_5ecbd7cb()
{
	level waittill("start_zombie_round_logic");
	var_845e036a = GetEnt(self.target, "targetname");
	vol_fling = GetEnt(var_845e036a.target, "targetname");
	var_cec95fd7 = struct::get(self.target, "targetname");
	var_cec95fd7 thread function_86ef1da5();
	v_fling = AnglesToForward(self.angles) * self.script_int;
	var_845e036a clientfield::set("flinger_pad_active_fx", level.var_6ad55648[var_845e036a.targetname]["ready"]);
	s_unitrigger_stub = self zm_unitrigger::create_unitrigger("", 50, &function_485001bf, &function_4029cf56, "unitrigger_radius");
	s_unitrigger_stub.angles = (0, 0, 0);
	s_unitrigger_stub.hint_parm1 = 0;
	s_unitrigger_stub.script_string = vol_fling.script_string;
	zm_unitrigger::unitrigger_force_per_player_triggers(s_unitrigger_stub, 1);
	var_3432399a = var_845e036a.target + "_spline";
	nd_start = GetVehicleNode(var_3432399a, "targetname");
	while(1)
	{
		s_unitrigger_stub waittill("trigger", e_who);
		if(isdefined(e_who.var_8dbb72b1) && e_who.var_8dbb72b1[vol_fling.script_string] === 1)
		{
			e_who zm_audio::create_and_play_dialog("general", "transport_deny");
			continue;
		}
		level.var_6fe80781 = GetTime();
		n_timer = 0;
		vol_fling playsound("zmb_fling_activate");
		while(n_timer <= 3)
		{
			a_ai_zombies = zombie_utility::get_zombie_array();
			a_ai_zombies = function_3dcd0982(a_ai_zombies, vol_fling);
			if(a_ai_zombies.size)
			{
				foreach(ai_zombie in a_ai_zombies)
				{
					if(math::cointoss())
					{
						ai_zombie thread do_fling(vol_fling, v_fling, nd_start);
					}
				}
			}
			else
			{
				a_active_players = function_3dcd0982(level.activePlayers, vol_fling);
				Array::thread_all(a_active_players, &do_fling, vol_fling, v_fling, nd_start, var_845e036a);
			}
			n_timer = n_timer + 0.1;
			wait(0.1);
		}
	}
}

/*
	Name: unitrigger_think
	Namespace: zm_genesis_flingers
	Checksum: 0xFB4DB389
	Offset: 0xEB0
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function unitrigger_think()
{
	self endon("kill_trigger");
	self.stub thread unitrigger_refresh_message();
	while(1)
	{
		self waittill("trigger", var_4161ad80);
		self.stub notify("trigger", var_4161ad80);
	}
}

/*
	Name: unitrigger_refresh_message
	Namespace: zm_genesis_flingers
	Checksum: 0x4DD59B9B
	Offset: 0xF18
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function unitrigger_refresh_message()
{
	self zm_unitrigger::run_visibility_function_for_all_triggers();
}

/*
	Name: function_3dcd0982
	Namespace: zm_genesis_flingers
	Checksum: 0x45B8F97
	Offset: 0xF40
	Size: 0x41
	Parameters: 2
	Flags: None
*/
function function_3dcd0982(Array, var_8d88ae81)
{
	return Array::filter(Array, 0, &function_a78c631a, var_8d88ae81);
}

/*
	Name: function_a78c631a
	Namespace: zm_genesis_flingers
	Checksum: 0x584785F3
	Offset: 0xF90
	Size: 0x69
	Parameters: 2
	Flags: None
*/
function function_a78c631a(VAL, var_8d88ae81)
{
	return isalive(VAL) && (!isdefined(VAL.is_flung) && VAL.is_flung) && VAL istouching(var_8d88ae81);
}

/*
	Name: function_86ef1da5
	Namespace: zm_genesis_flingers
	Checksum: 0x8804116
	Offset: 0x1008
	Size: 0x11F
	Parameters: 0
	Flags: None
*/
function function_86ef1da5()
{
	while(1)
	{
		foreach(e_player in level.activePlayers)
		{
			if(zombie_utility::is_player_valid(e_player) && Distance(e_player.origin, self.origin) <= 525 && e_player util::is_looking_at(self.origin, 0.85, 0))
			{
				self thread scene::Play(self.scriptbundlename);
				return;
			}
		}
		wait(0.25);
	}
}

/*
	Name: function_149a5187
	Namespace: zm_genesis_flingers
	Checksum: 0x2BC9BFBF
	Offset: 0x1130
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function function_149a5187()
{
	self endon("flinger_landed");
	level waittill("end_game");
	self.var_3048ac6d = 1;
}

/*
	Name: do_fling
	Namespace: zm_genesis_flingers
	Checksum: 0x878E428
	Offset: 0x1160
	Size: 0xB55
	Parameters: 4
	Flags: None
*/
function do_fling(var_a89f74ed, v_fling, nd_start, var_173065cc)
{
	self endon("death");
	if(isdefined(self.is_flung) && self.is_flung || (isdefined(self.var_8dbb72b1) && self.var_8dbb72b1[var_a89f74ed.script_string] === 1))
	{
		return;
	}
	if(isPlayer(self))
	{
		self thread function_149a5187();
		self.b_invulnerable = self EnableInvulnerability();
		self.var_fa1ecd39 = self.origin;
		self.is_flung = 1;
		if(!self laststand::player_is_in_laststand() && !self inLastStand())
		{
			self AllowCrouch(0);
			self AllowProne(0);
			self AllowStand(1);
		}
		self disableOffhandWeapons();
		self notsolid();
		self notify(var_173065cc.target);
		if(self GetStance() != "stand")
		{
			self SetStance("stand");
		}
		self playsound("zmb_fling_fly");
		var_413ea50f = vehicle::spawn(undefined, "player_vehicle", "flinger_vehicle", nd_start.origin, nd_start.angles);
		self PlayerLinkToDelta(var_413ea50f);
		a_ai_enemies = GetAITeamArray("axis");
		a_ai_enemies = ArraySort(a_ai_enemies, nd_start.origin, 1, 99, 768);
		Array::thread_all(a_ai_enemies, &ai_delay_cleanup);
		self thread function_44659337(nd_start, var_a89f74ed, v_fling);
		self PlayRumbleOnEntity("zm_castle_flinger_launch");
		self clientfield::set_to_player("flinger_flying_postfx", 1);
		self thread function_c1f1756a();
		if(isdefined(var_173065cc))
		{
			var_173065cc clientfield::increment("flinger_launch_fx");
			exploder::exploder(level.var_6ad55648[var_173065cc.targetname]["launch"]);
		}
		var_6a7beeb2 = function_cbac68fe(self);
		var_6a7beeb2 LinkTo(var_413ea50f);
		w_current = self.currentWeapon;
		if(w_current != level.weaponNone)
		{
			var_f5434f17 = zm_utility::spawn_buildkit_weapon_model(self, w_current, undefined, var_6a7beeb2 GetTagOrigin("tag_weapon_right"), var_6a7beeb2 GetTagAngles("tag_weapon_right"));
			var_f5434f17 LinkTo(var_6a7beeb2, "tag_weapon_right");
			var_f5434f17 SetOwner(self);
		}
		var_6a7beeb2 thread scene::Play("cin_zm_dlc1_jump_pad_air_loop", var_6a7beeb2);
		var_6a7beeb2 clientfield::set("player_visibility", 1);
		var_f5434f17 clientfield::set("player_visibility", 1);
		self ghost();
		self thread function_b19e2d45(var_a89f74ed);
		switch(var_a89f74ed.script_noteworthy)
		{
			case "upper_courtyard_landing_pad11":
			case "upper_courtyard_landing_pad8":
			{
				self zm_genesis_portals::function_eec1f014("start", 2, 1);
				break;
			}
			case "upper_courtyard_landing_pad12":
			case "upper_courtyard_landing_pad3":
			{
				self zm_genesis_portals::function_eec1f014("temple", 8, 1);
				break;
			}
			case "upper_courtyard_landing_pad5":
			case "upper_courtyard_landing_pad7":
			{
				self zm_genesis_portals::function_eec1f014("prison", 4, 1);
				break;
			}
			case "upper_courtyard_landing_pad4":
			case "upper_courtyard_landing_pad6":
			{
				self zm_genesis_portals::function_eec1f014("asylum", 6, 1);
				break;
			}
		}
		var_413ea50f SetIgnorePauseWorld(1);
		var_413ea50f AttachPath(nd_start);
		var_413ea50f StartPath();
		var_413ea50f waittill("reached_end_node");
		self thread function_3298b25f(var_a89f74ed);
		self thread function_29c06608();
		self PlayRumbleOnEntity("zm_castle_flinger_land");
		self clientfield::set_to_player("flinger_flying_postfx", 0);
		var_6a7beeb2 clientfield::set("player_visibility", 0);
		if(isdefined(var_f5434f17))
		{
			var_f5434f17 clientfield::set("player_visibility", 0);
		}
		var_6a7beeb2 thread scene::stop("cin_zm_dlc1_jump_pad_air_loop");
		if(isdefined(var_f5434f17))
		{
			var_f5434f17 delete();
		}
		self show();
		self solid();
		self thread function_9f131b98();
		if(!self laststand::player_is_in_laststand())
		{
			self AllowCrouch(1);
			self AllowProne(1);
		}
		self playsound("zmb_fling_land");
		var_6a7beeb2 Hide();
		util::wait_network_frame();
		var_6a7beeb2 delete();
		self EnableOffhandWeapons();
		self notify("flinger_landed");
		self thread function_e905a9df(var_a89f74ed, var_173065cc);
		self thread cleanup_vehicle(var_413ea50f);
	}
	else if(self.isdog)
	{
		self kill();
	}
	else if(self.archetype === "zombie")
	{
		self.is_flung = 1;
		self PathMode("dont move");
		self SetPlayerCollision(0);
		self.mdl_anchor = util::spawn_model("tag_origin", nd_start.origin, nd_start.angles);
		self LinkTo(self.mdl_anchor);
		nd_next = GetVehicleNode(nd_start.target, "targetname");
		n_distance = Distance(nd_start.origin, nd_next.origin);
		n_time = n_distance / 600;
		self.mdl_anchor moveto(nd_next.origin, n_time);
		self.mdl_anchor waittill("movedone");
		self Unlink();
		self PathMode("dont move");
		self StartRagdoll();
		self LaunchRagdoll(v_fling * RandomFloatRange(0.17, 0.21));
		util::wait_network_frame();
		self DoDamage(self.health, self.origin);
		level.zombie_total++;
		while(self istouching(var_a89f74ed))
		{
			wait(0.1);
		}
		self.is_flung = undefined;
	}
}

/*
	Name: cleanup_vehicle
	Namespace: zm_genesis_flingers
	Checksum: 0x36A07229
	Offset: 0x1CC0
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function cleanup_vehicle(var_413ea50f)
{
	while(1)
	{
		if(!isdefined(self) || (isdefined(self.var_3298b25f) && self.var_3298b25f))
		{
			break;
		}
		util::wait_network_frame();
	}
	var_413ea50f delete();
}

/*
	Name: function_9f131b98
	Namespace: zm_genesis_flingers
	Checksum: 0xE1DC38A1
	Offset: 0x1D30
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_9f131b98()
{
	if(isdefined(self.b_invulnerable) && self.b_invulnerable)
	{
		self.b_invulnerable = undefined;
		return;
	}
	wait(0.5);
	self DisableInvulnerability();
}

/*
	Name: ai_delay_cleanup
	Namespace: zm_genesis_flingers
	Checksum: 0xC453F49
	Offset: 0x1D88
	Size: 0x71
	Parameters: 0
	Flags: None
*/
function ai_delay_cleanup()
{
	if(!(isdefined(self.b_ignore_cleanup) && self.b_ignore_cleanup))
	{
		self notify("delay_cleanup");
		self endon("death");
		self endon("delay_cleanup");
		self.b_ignore_cleanup = 1;
		self.var_b6b1080c = 1;
		wait(10);
		self.b_ignore_cleanup = undefined;
		self.var_b6b1080c = undefined;
	}
}

/*
	Name: function_e905a9df
	Namespace: zm_genesis_flingers
	Checksum: 0x47F923E8
	Offset: 0x1E08
	Size: 0xCD
	Parameters: 2
	Flags: None
*/
function function_e905a9df(var_a89f74ed, var_173065cc)
{
	self endon("death");
	self.var_8dbb72b1[var_a89f74ed.script_string] = 1;
	self clientfield::set_to_player("flinger_cooldown_start", level.var_6ad55648[var_173065cc.targetname]["ready"]);
	wait(15);
	self clientfield::set_to_player("flinger_cooldown_end", level.var_6ad55648[var_173065cc.targetname]["ready"]);
	self.var_8dbb72b1[var_a89f74ed.script_string] = 0;
}

/*
	Name: function_cbac68fe
	Namespace: zm_genesis_flingers
	Checksum: 0x8D01A657
	Offset: 0x1EE0
	Size: 0x1DF
	Parameters: 1
	Flags: None
*/
function function_cbac68fe(e_player)
{
	mdl_clone = spawn("script_model", e_player.origin);
	mdl_clone.angles = e_player.angles;
	mdl_body = e_player GetCharacterBodyModel();
	mdl_clone SetModel(mdl_body);
	if(isdefined(e_player.s_wearable) && isdefined(e_player.s_wearable.STR_MODEL))
	{
		STR_MODEL = e_player.s_wearable.STR_MODEL;
		str_tag = e_player.s_wearable.str_tag;
		mdl_clone Attach(STR_MODEL, str_tag);
	}
	bodyRenderOptions = e_player GetCharacterBodyRenderOptions();
	mdl_clone SetBodyRenderOptions(bodyRenderOptions, bodyRenderOptions, bodyRenderOptions);
	mdl_clone.health = 100;
	mdl_clone SetOwner(e_player);
	mdl_clone.team = e_player.team;
	mdl_clone solid();
	return mdl_clone;
}

/*
	Name: function_c1f1756a
	Namespace: zm_genesis_flingers
	Checksum: 0x4A9887AD
	Offset: 0x20C8
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function function_c1f1756a()
{
	while(isdefined(self.is_flung) && self.is_flung)
	{
		self PlayRumbleOnEntity("zod_beast_grapple_reel");
		wait(0.2);
	}
}

/*
	Name: function_3298b25f
	Namespace: zm_genesis_flingers
	Checksum: 0xAA9797F7
	Offset: 0x2118
	Size: 0x1DF
	Parameters: 1
	Flags: None
*/
function function_3298b25f(var_a89f74ed)
{
	self endon("death");
	self.var_3298b25f = 0;
	var_a7d28374 = 0;
	var_a05a47c7 = var_a89f74ed achievement_none();
	var_16f5c370 = var_a05a47c7.origin;
	while(positionWouldTelefrag(var_16f5c370))
	{
		util::wait_network_frame();
		var_a7d28374++;
		if(var_a7d28374 > 4)
		{
			var_a05a47c7 = var_a89f74ed achievement_none(1);
			var_16f5c370 = var_a05a47c7.origin;
		}
		else
		{
			var_16f5c370 = var_a05a47c7.origin + (RandomFloatRange(-24, 24), RandomFloatRange(-24, 24), 0);
		}
	}
	self Unlink();
	self SetOrigin(var_16f5c370);
	if(isdefined(self.var_3048ac6d) && self.var_3048ac6d)
	{
		self FreezeControls(1);
	}
	self clientfield::increment_to_player("flinger_land_smash");
	self.is_flung = undefined;
	wait(3);
	var_a05a47c7.occupied = undefined;
	self.var_3298b25f = 1;
}

/*
	Name: achievement_none
	Namespace: zm_genesis_flingers
	Checksum: 0xF39B2E93
	Offset: 0x2300
	Size: 0x21D
	Parameters: 1
	Flags: None
*/
function achievement_none(b_random)
{
	if(!isdefined(b_random))
	{
		b_random = 0;
	}
	var_2b58409e = struct::get(self.script_noteworthy, "targetname");
	/#
		Assert(isdefined(var_2b58409e), "Dev Block strings are not supported" + self.script_noteworthy);
	#/
	a_s_spots = struct::get_array(var_2b58409e.target, "targetname");
	Array::add(a_s_spots, var_2b58409e, 0);
	for(i = 0; i < a_s_spots.size; i++)
	{
		for(j = i; j < a_s_spots.size; j++)
		{
			if(a_s_spots[j].script_int < a_s_spots[i].script_int)
			{
				temp = a_s_spots[i];
				a_s_spots[i] = a_s_spots[j];
				a_s_spots[j] = temp;
			}
		}
	}
	if(b_random)
	{
		return Array::random(a_s_spots);
		break;
	}
	for(i = 0; i < a_s_spots.size; i++)
	{
		if(!(isdefined(a_s_spots[i].occupied) && a_s_spots[i].occupied))
		{
			a_s_spots[i].occupied = 1;
			return a_s_spots[i];
		}
	}
}

/*
	Name: function_b19e2d45
	Namespace: zm_genesis_flingers
	Checksum: 0xBA2B35B
	Offset: 0x2528
	Size: 0xBF
	Parameters: 1
	Flags: None
*/
function function_b19e2d45(var_a89f74ed)
{
	var_2b58409e = struct::get(var_a89f74ed.script_noteworthy, "targetname");
	str_zone = zm_zonemgr::get_zone_from_position(var_2b58409e.origin + VectorScale((0, 0, 1), 32), 1);
	while(isdefined(self.is_flung) && self.is_flung)
	{
		level.zones[str_zone].is_active = 1;
		wait(0.1);
	}
}

/*
	Name: function_44659337
	Namespace: zm_genesis_flingers
	Checksum: 0xFC010E23
	Offset: 0x25F0
	Size: 0xA3
	Parameters: 3
	Flags: None
*/
function function_44659337(nd_target, var_a89f74ed, v_fling)
{
	a_ai = GetAITeamArray(level.zombie_team);
	a_sorted_ai = ArraySortClosest(a_ai, nd_target.origin, a_ai.size, 0, 512);
	Array::thread_all(a_sorted_ai, &function_1a4837ab, nd_target, self, var_a89f74ed, v_fling);
}

/*
	Name: function_1a4837ab
	Namespace: zm_genesis_flingers
	Checksum: 0x35BC5EBA
	Offset: 0x26A0
	Size: 0x23B
	Parameters: 4
	Flags: None
*/
function function_1a4837ab(nd_target, e_target, var_a89f74ed, v_fling)
{
	self endon("death");
	if(!(isdefined(self.completed_emerging_into_playable_area) && self.completed_emerging_into_playable_area))
	{
		return;
	}
	var_c95b4513 = [];
	for(i = 0; i < level.activePlayers.size; i++)
	{
		if(level.activePlayers[i] != e_target)
		{
			Array::add(var_c95b4513, level.activePlayers[i]);
		}
	}
	var_57cf6f70 = ArraySortClosest(var_c95b4513, self.origin, var_c95b4513.size, 0, 512);
	if(var_57cf6f70.size)
	{
		return;
	}
	if(self.archetype === "zombie" && self.ai_state === "zombie_think")
	{
		self.ignoreall = 1;
		self SetGoal(nd_target.origin, 1);
		n_start_time = GetTime();
		self util::waittill_any_timeout(6, "goal", "death");
		self.ignoreall = 0;
		n_end_time = GetTime();
		n_total_time = n_end_time - n_start_time / 1000;
		if(!isdefined(self.is_flung) && self.is_flung && n_total_time < 6)
		{
			n_randy = RandomInt(100);
			if(n_randy < 25)
			{
				self thread do_fling(var_a89f74ed, v_fling, nd_target);
			}
		}
	}
}

/*
	Name: function_29c06608
	Namespace: zm_genesis_flingers
	Checksum: 0x2894A173
	Offset: 0x28E8
	Size: 0x2C1
	Parameters: 0
	Flags: None
*/
function function_29c06608()
{
	a_ai = GetAITeamArray(level.zombie_team);
	a_ai_kill = ArraySortClosest(a_ai, self.origin, a_ai.size, 0, 128);
	foreach(ai_zombie in a_ai_kill)
	{
		if(ai_zombie.archetype === "zombie")
		{
			playFX(level._effect["beast_return_aoe_kill"], ai_zombie GetTagOrigin("j_spineupper"));
			ai_zombie.marked_for_recycle = 1;
			ai_zombie.has_been_damaged_by_player = 0;
			ai_zombie.deathpoints_already_given = 1;
			ai_zombie.no_powerups = 1;
			ai_zombie DoDamage(ai_zombie.health + 1000, ai_zombie.origin, self);
			ArrayRemoveValue(a_ai, ai_zombie);
		}
	}
	util::wait_network_frame();
	a_ai_slam = ArraySortClosest(a_ai, self.origin, a_ai.size, 0, 200);
	foreach(ai_zombie in a_ai_slam)
	{
		if(isalive(ai_zombie) && ai_zombie.archetype === "zombie")
		{
			self thread zombie_slam_direction(ai_zombie);
		}
	}
}

/*
	Name: zombie_slam_direction
	Namespace: zm_genesis_flingers
	Checksum: 0x54D70C0E
	Offset: 0x2BB8
	Size: 0x2AB
	Parameters: 1
	Flags: None
*/
function zombie_slam_direction(ai_zombie)
{
	ai_zombie.KNOCKDOWN = 1;
	v_zombie_to_player = self.origin - ai_zombie.origin;
	v_zombie_to_player_2d = VectorNormalize((v_zombie_to_player[0], v_zombie_to_player[1], 0));
	v_zombie_forward = AnglesToForward(ai_zombie.angles);
	v_zombie_forward_2d = VectorNormalize((v_zombie_forward[0], v_zombie_forward[1], 0));
	v_zombie_right = AnglesToRight(ai_zombie.angles);
	v_zombie_right_2d = VectorNormalize((v_zombie_right[0], v_zombie_right[1], 0));
	v_dot = VectorDot(v_zombie_to_player_2d, v_zombie_forward_2d);
	if(v_dot >= 0.5)
	{
		ai_zombie.knockdown_direction = "front";
		ai_zombie.getup_direction = "getup_back";
	}
	else if(v_dot < 0.5 && v_dot > -0.5)
	{
		v_dot = VectorDot(v_zombie_to_player_2d, v_zombie_right_2d);
		if(v_dot > 0)
		{
			ai_zombie.knockdown_direction = "right";
			if(math::cointoss())
			{
				ai_zombie.getup_direction = "getup_back";
			}
			else
			{
				ai_zombie.getup_direction = "getup_belly";
			}
		}
		else
		{
			ai_zombie.knockdown_direction = "left";
			ai_zombie.getup_direction = "getup_belly";
		}
	}
	else
	{
		ai_zombie.knockdown_direction = "back";
		ai_zombie.getup_direction = "getup_belly";
	}
	wait(1);
	ai_zombie.KNOCKDOWN = 0;
}

/*
	Name: function_4b3d145d
	Namespace: zm_genesis_flingers
	Checksum: 0x380C8D5C
	Offset: 0x2E70
	Size: 0x7F
	Parameters: 11
	Flags: None
*/
function function_4b3d145d(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex)
{
	if(isdefined(self.is_flung) && self.is_flung)
	{
		return 0;
	}
	else
	{
		return -1;
	}
}

/*
	Name: function_485001bf
	Namespace: zm_genesis_flingers
	Checksum: 0x28D8A014
	Offset: 0x2EF8
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function function_485001bf(e_player)
{
	if(isdefined(e_player.var_8dbb72b1) && e_player.var_8dbb72b1[self.stub.script_string] === 1)
	{
		self setHintString(&"ZM_GENESIS_JUMP_PAD_COOLDOWN");
		return 0;
	}
	return 1;
}

/*
	Name: function_4029cf56
	Namespace: zm_genesis_flingers
	Checksum: 0x41C236E5
	Offset: 0x2F70
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function function_4029cf56()
{
	self endon("kill_trigger");
	self.stub thread zm_unitrigger::run_visibility_function_for_all_triggers();
	while(1)
	{
		self waittill("trigger", var_4161ad80);
		self.stub notify("trigger", var_4161ad80);
	}
}

/*
	Name: function_4208db02
	Namespace: zm_genesis_flingers
	Checksum: 0xD0F69322
	Offset: 0x2FD8
	Size: 0x2D3
	Parameters: 0
	Flags: None
*/
function function_4208db02()
{
	level.var_6ad55648 = [];
	level.var_6ad55648["upper_courtyard_flinger_base3"] = [];
	level.var_6ad55648["upper_courtyard_flinger_base4"] = [];
	level.var_6ad55648["upper_courtyard_flinger_base5"] = [];
	level.var_6ad55648["upper_courtyard_flinger_base6"] = [];
	level.var_6ad55648["upper_courtyard_flinger_base7"] = [];
	level.var_6ad55648["upper_courtyard_flinger_base8"] = [];
	level.var_6ad55648["upper_courtyard_flinger_base11"] = [];
	level.var_6ad55648["upper_courtyard_flinger_base12"] = [];
	level.var_6ad55648["upper_courtyard_flinger_base7"]["launch"] = "fxexp_250";
	level.var_6ad55648["upper_courtyard_flinger_base7"]["ready"] = 1;
	level.var_6ad55648["upper_courtyard_flinger_base12"]["launch"] = "fxexp_251";
	level.var_6ad55648["upper_courtyard_flinger_base12"]["ready"] = 2;
	level.var_6ad55648["upper_courtyard_flinger_base11"]["launch"] = "fxexp_252";
	level.var_6ad55648["upper_courtyard_flinger_base11"]["ready"] = 3;
	level.var_6ad55648["upper_courtyard_flinger_base4"]["launch"] = "fxexp_253";
	level.var_6ad55648["upper_courtyard_flinger_base4"]["ready"] = 4;
	level.var_6ad55648["upper_courtyard_flinger_base8"]["launch"] = "fxexp_257";
	level.var_6ad55648["upper_courtyard_flinger_base8"]["ready"] = 8;
	level.var_6ad55648["upper_courtyard_flinger_base6"]["launch"] = "fxexp_256";
	level.var_6ad55648["upper_courtyard_flinger_base6"]["ready"] = 7;
	level.var_6ad55648["upper_courtyard_flinger_base5"]["launch"] = "fxexp_255";
	level.var_6ad55648["upper_courtyard_flinger_base5"]["ready"] = 6;
	level.var_6ad55648["upper_courtyard_flinger_base3"]["launch"] = "fxexp_254";
	level.var_6ad55648["upper_courtyard_flinger_base3"]["ready"] = 5;
}

