#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm_grappler;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_genesis_flingers;
#using scripts\zm\zm_genesis_util;
#using scripts\zm\zm_genesis_vo;

#namespace zm_genesis_pap;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_pap
	Checksum: 0x37FBBDD6
	Offset: 0x5F8
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_pap_quest", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_pap
	Checksum: 0x761E948E
	Offset: 0x640
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.var_e1ee8457 = 0;
	level.pack_a_punch.custom_power_think = &function_23a5b653;
	level.zombiemode_reusing_pack_a_punch = 1;
	scene::add_scene_func("p7_fxanim_zm_gen_apoth_pap_sac_arm_lft_bundle", &function_d2b266ee, "init");
	scene::add_scene_func("p7_fxanim_zm_gen_apoth_pap_sac_arm_cnt_bundle", &function_d2b266ee, "init");
	scene::add_scene_func("p7_fxanim_zm_gen_apoth_pap_sac_arm_rt_bundle", &function_d2b266ee, "init");
	scene::add_scene_func("p7_fxanim_zm_gen_apoth_pap_sac_bundle", &init_sac, "init");
	level thread scene::init("p7_fxanim_zm_gen_apoth_pap_sac_arm_lft_bundle");
	level thread scene::init("p7_fxanim_zm_gen_apoth_pap_sac_arm_cnt_bundle");
	level thread scene::init("p7_fxanim_zm_gen_apoth_pap_sac_arm_rt_bundle");
	level thread scene::init("p7_fxanim_zm_gen_apoth_pap_sac_bundle");
}

/*
	Name: __main__
	Namespace: zm_genesis_pap
	Checksum: 0xD1F43254
	Offset: 0x7C8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level flag::init("pap_power_on");
	level flag::init("apotho_pack_freed");
}

/*
	Name: function_23a5b653
	Namespace: zm_genesis_pap
	Checksum: 0x27896673
	Offset: 0x818
	Size: 0xEB
	Parameters: 1
	Flags: None
*/
function function_23a5b653(powered_on)
{
	if(!powered_on)
	{
		self.zbarrier set_pap_zbarrier_state("initial");
		level flag::wait_till_all(Array("power_on1", "power_on2", "power_on3", "power_on4"));
		self thread function_e488a6a8();
	}
	for(;;)
	{
		self.zbarrier set_pap_zbarrier_state("power_on");
		level waittill("Pack_A_Punch_off");
		self.zbarrier set_pap_zbarrier_state("power_off");
		level waittill("Pack_A_Punch_on");
	}
}

/*
	Name: set_pap_zbarrier_state
	Namespace: zm_genesis_pap
	Checksum: 0xC8327104
	Offset: 0x910
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function set_pap_zbarrier_state(State)
{
	for(i = 0; i < self GetNumZBarrierPieces(); i++)
	{
		self HideZBarrierPiece(i);
	}
	self notify("zbarrier_state_change");
	self [[level.pap_zbarrier_state_func]](State);
}

/*
	Name: function_8d5c3682
	Namespace: zm_genesis_pap
	Checksum: 0x9B9675D9
	Offset: 0x998
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_8d5c3682()
{
	var_d1f5ed14 = getvehiclenodearray("pap_travel_spline", "targetname");
	Array::thread_all(var_d1f5ed14, &function_21d887cd);
}

/*
	Name: function_21d887cd
	Namespace: zm_genesis_pap
	Checksum: 0xF2DC44AA
	Offset: 0x9F8
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function function_21d887cd()
{
	/#
		Assert(IsPointOnNavMesh(self.origin), "Dev Block strings are not supported" + self.origin + "Dev Block strings are not supported");
	#/
	s_stub = level zm_genesis_util::spawn_trigger_radius(self.origin, 256, undefined, &function_f8c1234b);
	while(1)
	{
		s_stub waittill("trigger", e_player);
		e_player thread function_4ab898f4(self);
		level.var_6fe80781 = GetTime();
	}
}

/*
	Name: function_f8c1234b
	Namespace: zm_genesis_pap
	Checksum: 0x4C310D41
	Offset: 0xAD8
	Size: 0x11
	Parameters: 1
	Flags: None
*/
function function_f8c1234b(e_player)
{
	return "";
}

/*
	Name: function_e8ef758e
	Namespace: zm_genesis_pap
	Checksum: 0x853238E0
	Offset: 0xAF8
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function function_e8ef758e()
{
	if(!isdefined(level.apothicon_grapple_source))
	{
		level.apothicon_grapple_source = struct::get("apothicon_grapple_source");
	}
	if(!isdefined(level.apothicon_grapple_source))
	{
		level.apothicon_grapple_source = spawnstruct();
		level.apothicon_grapple_source.origin = (1894, -438, -127);
		level.apothicon_grapple_source.angles = VectorScale((0, 1, 0), 180);
		level.apothicon_grapple_source.targetname = "apothicon_grapple_source";
	}
	if(isdefined(level.apothicon_grapple_source))
	{
		e_player = self;
		e_player.grapple_tag = "j_spine4";
		if(!(isdefined(e_player.grapple_test) && e_player.grapple_test))
		{
			e_player.grapple_test = 1;
			zm_grappler::start_grapple(level.apothicon_grapple_source, e_player, 2, 3300);
			e_player.grapple_test = 0;
		}
	}
}

/*
	Name: function_4ab898f4
	Namespace: zm_genesis_pap
	Checksum: 0x6288F18E
	Offset: 0xC50
	Size: 0x5FB
	Parameters: 1
	Flags: None
*/
function function_4ab898f4(nd_start)
{
	self endon("death");
	if(isdefined(self.is_flung) && self.is_flung)
	{
		return;
	}
	self.is_flung = 1;
	self.var_a393601c = 1;
	self function_e8ef758e();
	self.b_invulnerable = self EnableInvulnerability();
	self AllowCrouch(0);
	self AllowProne(0);
	self FreezeControls(1);
	self notsolid();
	if(self GetStance() != "stand")
	{
		self SetStance("stand");
		wait(1);
	}
	var_413ea50f = vehicle::spawn(undefined, "player_vehicle", "flinger_vehicle", nd_start.origin, nd_start.angles);
	s_connect = struct::get(nd_start.target);
	var_f28a4a19 = s_connect function_fc804fdd();
	self PlayerLinkToDelta(var_413ea50f);
	self PlayRumbleOnEntity("zm_castle_flinger_launch");
	self clientfield::set_to_player("apothicon_entry_postfx", 1);
	self thread zm_genesis_flingers::function_c1f1756a();
	var_6a7beeb2 = zm_genesis_flingers::function_cbac68fe(self);
	var_6a7beeb2 LinkTo(var_413ea50f);
	w_current = self.currentWeapon;
	var_f5434f17 = zm_utility::spawn_buildkit_weapon_model(self, w_current, undefined, var_6a7beeb2 GetTagOrigin("tag_weapon_right"), var_6a7beeb2 GetTagAngles("tag_weapon_right"));
	var_f5434f17 LinkTo(var_6a7beeb2, "tag_weapon_right");
	var_f5434f17 SetOwner(self);
	var_6a7beeb2 thread scene::Play("cin_zm_dlc1_jump_pad_air_loop", var_6a7beeb2);
	var_6a7beeb2 clientfield::set("player_visibility", 1);
	var_f5434f17 clientfield::set("player_visibility", 1);
	self ghost();
	var_413ea50f SetIgnorePauseWorld(1);
	var_413ea50f vehicle::get_on_and_go_path(nd_start);
	while(positionWouldTelefrag(var_f28a4a19.origin))
	{
		wait(0.05);
	}
	var_413ea50f vehicle::get_on_and_go_path(var_f28a4a19);
	self thread function_3298b25f();
	self thread zm_genesis_flingers::function_29c06608();
	self PlayRumbleOnEntity("zm_castle_flinger_land");
	self clientfield::set_to_player("apothicon_entry_postfx", 0);
	var_6a7beeb2 clientfield::set("player_visibility", 0);
	var_f5434f17 clientfield::set("player_visibility", 0);
	var_6a7beeb2 thread scene::stop("cin_zm_dlc1_jump_pad_air_loop");
	var_f5434f17 delete();
	self show();
	self solid();
	self thread zm_genesis_flingers::function_9f131b98();
	var_6a7beeb2 Hide();
	util::wait_network_frame();
	var_6a7beeb2 delete();
	self thread function_10171438();
	self.is_flung = undefined;
	self thread cleanup_vehicle(var_413ea50f);
	wait(2);
	self AllowCrouch(1);
	self AllowProne(1);
	self FreezeControls(0);
}

/*
	Name: cleanup_vehicle
	Namespace: zm_genesis_pap
	Checksum: 0xFB0D69CA
	Offset: 0x1258
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
	Name: function_10171438
	Namespace: zm_genesis_pap
	Checksum: 0x84510305
	Offset: 0x12C8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_10171438()
{
	self endon("death");
	self endon("disconnect");
	wait(3);
	self.var_a393601c = 0;
}

/*
	Name: function_fc804fdd
	Namespace: zm_genesis_pap
	Checksum: 0x9A878F7E
	Offset: 0x1300
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function function_fc804fdd(var_16caea3d)
{
	var_62a30970 = getvehiclenodearray(self.target, "targetname");
	foreach(nd_spline in var_62a30970)
	{
		if(nd_spline.script_noteworthy === var_16caea3d)
		{
			return nd_spline;
		}
	}
	/#
		Assert(isdefined(nd_spline), "Dev Block strings are not supported" + var_16caea3d + "Dev Block strings are not supported" + self.origin + "Dev Block strings are not supported");
	#/
}

/*
	Name: function_3298b25f
	Namespace: zm_genesis_pap
	Checksum: 0x2C909673
	Offset: 0x1410
	Size: 0x167
	Parameters: 0
	Flags: None
*/
function function_3298b25f()
{
	self.var_3298b25f = 0;
	var_6b138e28 = GroundTrace(self.origin, self.origin + VectorScale((0, 0, -1), 10000), 0, undefined)["position"];
	for(var_16f5c370 = var_6b138e28; positionWouldTelefrag(var_16f5c370) || !IsPointOnNavMesh(var_16f5c370);  = var_6b138e28)
	{
		util::wait_network_frame();
	}
	self Unlink();
	self SetOrigin(var_16f5c370);
	self clientfield::increment_to_player("flinger_land_smash");
	self thread zm_genesis_vo::function_e1bf753b();
	self.var_3298b25f = 1;
}

/*
	Name: function_e488a6a8
	Namespace: zm_genesis_pap
	Checksum: 0x983122DC
	Offset: 0x1580
	Size: 0x1CB
	Parameters: 0
	Flags: None
*/
function function_e488a6a8()
{
	level flag::set("pap_power_on");
	level notify("Pack_A_Punch_on");
	self.origin = self.origin + VectorScale((0, 0, 1), 500);
	self.clip.origin = self.clip.origin + VectorScale((0, 0, 1), 500);
	self.pap_machine.origin = self.pap_machine.origin - VectorScale((0, 0, 1), 500);
	for(var_9748d143 = 0; var_9748d143 < 3; var_9748d143++)
	{
		level waittill("hash_80f97945");
	}
	level scene::Play("p7_fxanim_zm_gen_apoth_pap_sac_bundle");
	playsoundatposition("evt_pap_freed", (873, 110, -3239));
	self.pap_machine.origin = self.pap_machine.origin + VectorScale((0, 0, 1), 500);
	level flag::set("apotho_pack_freed");
	self.origin = self.origin - VectorScale((0, 0, 1), 500);
	self.clip.origin = self.clip.origin - VectorScale((0, 0, 1), 500);
}

/*
	Name: function_9278bc8a
	Namespace: zm_genesis_pap
	Checksum: 0xB9810E04
	Offset: 0x1758
	Size: 0x1F3
	Parameters: 1
	Flags: None
*/
function function_9278bc8a(var_181e2689)
{
	self SetCanDamage(1);
	self.health = 6000;
	self.n_damage = 0;
	while(1)
	{
		self waittill("damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, weapon, iDFlags);
		playFX(level._effect["pap_cord_impact"], point, (0, 0, -1));
		self.n_damage = self.n_damage - damage;
		self.health = self.health + damage;
		if(self.n_damage <= 1000)
		{
			playsoundatposition("evt_pap_cord_burst", self.origin);
			self SetCanDamage(0);
			break;
		}
	}
	level notify("hash_80f97945");
	if(isPlayer(attacker))
	{
		attacker thread zm_genesis_vo::function_57f3d77();
	}
	exploder::exploder("fxexp_" + 106 + var_181e2689);
	level thread scene::Play(self.current_scene);
}

/*
	Name: function_d2b266ee
	Namespace: zm_genesis_pap
	Checksum: 0x5352FBBB
	Offset: 0x1958
	Size: 0xE5
	Parameters: 1
	Flags: None
*/
function function_d2b266ee(a_ents)
{
	a_str_keys = getArrayKeys(a_ents);
	str_key = a_str_keys[0];
	var_9f585353 = a_ents[str_key];
	switch(str_key)
	{
		case "pap_sac_lft_arm":
		{
			var_9f585353 thread function_9278bc8a(1);
			break;
		}
		case "pap_sac_cnt_arm":
		{
			var_9f585353 thread function_9278bc8a(2);
			break;
		}
		case "pap_sac_rt_arm":
		{
			var_9f585353 thread function_9278bc8a(3);
			break;
		}
	}
}

/*
	Name: init_sac
	Namespace: zm_genesis_pap
	Checksum: 0xB8151441
	Offset: 0x1A48
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function init_sac(a_ents)
{
	mdl_pap = a_ents["pap_sac_vending"];
	level waittill("apotho_pack_freed");
	wait(0.2);
	mdl_pap delete();
}

