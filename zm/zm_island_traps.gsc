#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_island_util;

#namespace namespace_14b4d4ab;

/*
	Name: __init__sytem__
	Namespace: namespace_14b4d4ab
	Checksum: 0x17EEA3F6
	Offset: 0xA10
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_traps", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_14b4d4ab
	Checksum: 0xB7EAD024
	Offset: 0xA50
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("world", "proptrap_downdraft_rumble", 9000, 1, "int");
	clientfield::register("toplayer", "proptrap_downdraft_blur", 9000, 1, "int");
	clientfield::register("world", "walltrap_draft_rumble", 9000, 1, "int");
	clientfield::register("toplayer", "walltrap_draft_blur", 9000, 1, "int");
	level flag::init("witnessed_trapkill_dialog");
	callback::on_player_killed(&function_2ee3731e);
}

/*
	Name: function_2ee3731e
	Namespace: namespace_14b4d4ab
	Checksum: 0x828A3182
	Offset: 0xB60
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_2ee3731e()
{
	self clientfield::set("proptrap_downdraft_blur", 0);
	self clientfield::set("walltrap_draft_blur", 0);
}

/*
	Name: function_7309e48
	Namespace: namespace_14b4d4ab
	Checksum: 0x99FA3A57
	Offset: 0xBB0
	Size: 0x65
	Parameters: 0
	Flags: None
*/
function function_7309e48()
{
	function_b2e2a102();
	function_7dea397f();
	function_17303d81();
	level thread function_74ddcad3();
	level notify("hash_288b3c6c");
	level notify("hash_b683cd31");
}

/*
	Name: function_7dea397f
	Namespace: namespace_14b4d4ab
	Checksum: 0x56F1902F
	Offset: 0xC20
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_7dea397f()
{
	level thread scene::init("p7_fxanim_zm_island_engine_trap_on_bundle");
	level thread scene::add_scene_func("p7_fxanim_zm_island_engine_trap_on_bundle", &function_3c8c2e02, "init");
	function_9a88139e();
	function_74859935();
}

/*
	Name: function_3c8c2e02
	Namespace: namespace_14b4d4ab
	Checksum: 0x1A1030A9
	Offset: 0xCA0
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_3c8c2e02(a_ents)
{
	var_f6dbc18f = a_ents["fxanim_engine_trap"];
	var_f6dbc18f SetIgnorePauseWorld(1);
}

/*
	Name: function_9a88139e
	Namespace: namespace_14b4d4ab
	Checksum: 0x842C1CDF
	Offset: 0xCF0
	Size: 0x203
	Parameters: 0
	Flags: None
*/
function function_9a88139e()
{
	level.var_e938db57 = GetEnt("mdl_propellertrap_a_body", "script_string");
	level.var_e938db57.str_type = "PROPTRAP_a";
	level.var_e938db57.var_e80e0d58 = "fxexp_110";
	level.var_e938db57.var_efa7240e = GetEnt("mdl_propellertrap_a_propeller", "script_string");
	level.var_e938db57 Hide();
	level.var_e938db57.var_efa7240e Hide();
	level.var_e938db57.var_d93f9cb8 = GetEnt("t_propellertrap_a_death", "script_string");
	level.var_e938db57.var_2a4af70 = GetEnt("t_proptrap_a_spiders", "targetname");
	level.var_e938db57.var_7117876c = level.var_e938db57.origin;
	level.var_e938db57.v_off_pos = level.var_e938db57.origin + VectorScale((0, 0, 1), 30);
	level.var_e938db57.var_380861c6 = level.var_e938db57.angles;
	level.var_e938db57.var_401e166a = level.var_e938db57.angles;
	level.var_e938db57.var_16e1fdfb = &function_b0658775;
	level.var_e938db57._trap_type = "propeller";
	level.var_e938db57 function_3a8453ed();
}

/*
	Name: function_74859935
	Namespace: namespace_14b4d4ab
	Checksum: 0xEAFFA2D4
	Offset: 0xF00
	Size: 0x203
	Parameters: 0
	Flags: None
*/
function function_74859935()
{
	level.var_77316c1c = GetEnt("mdl_propellertrap_b_body", "script_string");
	level.var_77316c1c.str_type = "PROPTRAP_b";
	level.var_77316c1c.var_e80e0d58 = "fxexp_112";
	level.var_77316c1c.var_efa7240e = GetEnt("mdl_propellertrap_b_propeller", "script_string");
	level.var_77316c1c Hide();
	level.var_77316c1c.var_efa7240e Hide();
	level.var_77316c1c.var_d93f9cb8 = GetEnt("t_propellertrap_b_death", "script_string");
	level.var_77316c1c.var_2a4af70 = GetEnt("t_proptrap_b_spiders", "targetname");
	level.var_77316c1c.var_7117876c = level.var_77316c1c.origin;
	level.var_77316c1c.v_off_pos = level.var_77316c1c.origin + VectorScale((0, 0, 1), 100);
	level.var_77316c1c.var_380861c6 = (75, 270, -89.992);
	level.var_77316c1c.var_401e166a = (75, 270, -90);
	level.var_77316c1c.var_16e1fdfb = &function_bc1706ea;
	level.var_77316c1c._trap_type = "propeller";
	level.var_77316c1c function_3a8453ed();
}

/*
	Name: function_97e8fd81
	Namespace: namespace_14b4d4ab
	Checksum: 0xA3D8C03C
	Offset: 0x1110
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function function_97e8fd81()
{
	self.var_efa7240e LinkTo(self);
	wait(0.1);
	self moveto(self.var_7117876c, 1);
	self RotateTo(self.var_380861c6, 1);
	self playsound("evt_propeller_trap_engine_start");
	self waittill("movedone");
	self.var_efa7240e Unlink();
	self.b_on = 1;
	self.var_d93f9cb8 TriggerEnable(1);
	self thread function_74e1faeb();
	self thread [[self.var_16e1fdfb]]();
	exploder::exploder(self.var_e80e0d58);
	self thread sound::loop_fx_sound("evt_propeller_trap_engine", self.origin, "stoploop");
}

/*
	Name: function_3a8453ed
	Namespace: namespace_14b4d4ab
	Checksum: 0x7607B7D5
	Offset: 0x1260
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function function_3a8453ed()
{
	self notify("hash_a7a4f8be");
	self.b_on = 0;
	self.var_d93f9cb8 TriggerEnable(0);
	exploder::stop_exploder(self.var_e80e0d58);
	self notify("stoploop");
	self playsound("evt_propeller_trap_engine_stop");
	wait(0.5);
	self.var_efa7240e LinkTo(self);
	wait(0.1);
	self moveto(self.v_off_pos, 1);
	self RotateTo(self.var_401e166a, 1);
	wait(1.5);
	self.var_efa7240e Unlink();
}

/*
	Name: function_fd097b36
	Namespace: namespace_14b4d4ab
	Checksum: 0x1BC3BCEC
	Offset: 0x1368
	Size: 0x28B
	Parameters: 1
	Flags: None
*/
function function_fd097b36(var_6afd6b)
{
	var_609ec145 = struct::get("s_engine_trap_loc", "targetname");
	var_609ec145 thread scene::Play("p7_fxanim_zm_island_engine_trap_on_bundle");
	level.var_e938db57 thread function_d93740e5(var_6afd6b);
	level.var_77316c1c thread function_d93740e5(var_6afd6b);
	var_367b15e7 = level.var_cefa7a2a[self.stub.script_noteworthy];
	var_367b15e7 thread scene::Play("p7_fxanim_zm_island_switch_trap_lever_bundle", var_367b15e7);
	level clientfield::set("proptrap_downdraft_rumble", 1);
	foreach(player in level.activePlayers)
	{
		player clientfield::set_to_player("proptrap_downdraft_blur", 1);
	}
	self playsound("evt_propeller_trap_start");
	wait(30);
	level clientfield::set("proptrap_downdraft_rumble", 0);
	foreach(player in level.activePlayers)
	{
		player clientfield::set_to_player("proptrap_downdraft_blur", 0);
	}
	var_609ec145 scene::Play("p7_fxanim_zm_island_engine_trap_off_bundle");
	var_609ec145 scene::init("p7_fxanim_zm_island_engine_trap_on_bundle");
}

/*
	Name: function_d93740e5
	Namespace: namespace_14b4d4ab
	Checksum: 0x113658
	Offset: 0x1600
	Size: 0x193
	Parameters: 3
	Flags: None
*/
function function_d93740e5(e_player, var_edd82165, var_614a7182)
{
	if(!isdefined(var_edd82165))
	{
		var_edd82165 = 30;
	}
	if(!isdefined(var_614a7182))
	{
		var_614a7182 = 30;
	}
	if(self.b_on !== 1 && self.var_b44dbcd2 !== 1)
	{
		self.var_6afd6b = e_player;
		if(isdefined(e_player))
		{
			e_player notify("hash_3b447bc1");
		}
		exploder::exploder_stop("ex_prop_switch");
		self playsound("zmb_trap_activated");
		self thread function_97e8fd81();
		wait(var_edd82165);
		self thread function_3a8453ed();
		self.var_6afd6b = undefined;
		self.var_b44dbcd2 = 1;
		wait(var_614a7182);
		self.var_b44dbcd2 = 0;
		self playsound("zmb_trap_ready");
		if(level flag::get("power_on1") || level flag::get("power_on"))
		{
			exploder::exploder("ex_prop_switch");
		}
	}
}

/*
	Name: function_a9e415bd
	Namespace: namespace_14b4d4ab
	Checksum: 0xFBB3654F
	Offset: 0x17A0
	Size: 0x1D9
	Parameters: 1
	Flags: None
*/
function function_a9e415bd(b_on)
{
	if(!isdefined(b_on))
	{
		b_on = 1;
	}
	if(isdefined(b_on) && b_on)
	{
		var_719bbcb8 = struct::get_array("s_proptrap_downdraft_rumble", "targetname");
		level.var_69abefde = [];
		foreach(var_dd3351d8 in var_719bbcb8)
		{
			e_pos = util::spawn_model("tag_origin", var_dd3351d8.origin, var_dd3351d8.angles);
			Array::add(level.var_69abefde, e_pos);
			e_pos PlayRumbleOnEntity("zm_island_rumble_proptrap_downdraft");
		}
		break;
	}
	foreach(e_pos in level.var_69abefde)
	{
		e_pos delete();
	}
}

/*
	Name: function_b0658775
	Namespace: namespace_14b4d4ab
	Checksum: 0xCC73468C
	Offset: 0x1988
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function function_b0658775()
{
	self endon("hash_a7a4f8be");
	while(self.b_on === 1)
	{
		self.var_efa7240e RotateRoll(1000, 0.5);
		wait(0.5);
	}
}

/*
	Name: function_bc1706ea
	Namespace: namespace_14b4d4ab
	Checksum: 0x4C22EB2F
	Offset: 0x19E0
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function function_bc1706ea()
{
	self endon("hash_a7a4f8be");
	while(self.b_on === 1)
	{
		self.var_efa7240e RotateRoll(1000, 0.5);
		wait(0.5);
	}
}

/*
	Name: function_74e1faeb
	Namespace: namespace_14b4d4ab
	Checksum: 0xF22CCD89
	Offset: 0x1A38
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function function_74e1faeb()
{
	self endon("hash_a7a4f8be");
	self._trap_type = "rotating";
	self.activated_by_player = self.var_6afd6b;
	self thread function_b3390115();
	while(self.b_on === 1)
	{
		self.var_d93f9cb8 waittill("trigger", ent);
		if(zombie_utility::is_player_valid(ent))
		{
			ent thread function_de0d7531(self);
		}
		else
		{
			ent thread function_12a70fc8(self, ent.origin);
			wait(0.1);
		}
	}
}

/*
	Name: function_b3390115
	Namespace: namespace_14b4d4ab
	Checksum: 0x9334F159
	Offset: 0x1B18
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function function_b3390115()
{
	self endon("hash_a7a4f8be");
	while(self.b_on === 1)
	{
		self.var_2a4af70 waittill("trigger", ent);
		if(ent.archetype === "spider" && isalive(ent) && (!isdefined(ent.var_b6e7a15) && ent.var_b6e7a15))
		{
			ent.var_b6e7a15 = 1;
			ent thread function_2319463d(self);
		}
	}
}

/*
	Name: function_2319463d
	Namespace: namespace_14b4d4ab
	Checksum: 0x50710A09
	Offset: 0x1BE8
	Size: 0x14B
	Parameters: 1
	Flags: None
*/
function function_2319463d(var_68fe148c)
{
	self endon("death");
	var_1ee590e5 = var_68fe148c.var_efa7240e.origin;
	var_4ed4eec0 = util::spawn_model("tag_origin", self.origin, self.angles);
	self LinkTo(var_4ed4eec0);
	self thread function_e4b540d1(var_4ed4eec0);
	wait(0.1);
	if(isalive(self))
	{
		self playsound("evt_wall_trap_suck");
		self thread scene::Play("scene_zm_dlc2_spider_death_vacuum_sucked_upward", self);
		self waittill("scene_done");
		self playsound("evt_wall_trap_grind");
		self thread function_12a70fc8(var_68fe148c, var_1ee590e5);
	}
}

/*
	Name: function_e4b540d1
	Namespace: namespace_14b4d4ab
	Checksum: 0x909533B4
	Offset: 0x1D40
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_e4b540d1(var_4ed4eec0)
{
	self waittill("death");
	var_4ed4eec0 delete();
}

/*
	Name: function_17303d81
	Namespace: namespace_14b4d4ab
	Checksum: 0x6B19F6BB
	Offset: 0x1D78
	Size: 0x649
	Parameters: 0
	Flags: None
*/
function function_17303d81()
{
	var_d730823e = GetEntArray("lever", "script_tag");
	level.var_cefa7a2a = [];
	level.var_9c725b07 = [];
	foreach(var_367b15e7 in var_d730823e)
	{
		if(var_367b15e7.script_noteworthy == "proptrap_a_onswitch" || var_367b15e7.script_noteworthy == "proptrap_b_onswitch")
		{
			level.var_cefa7a2a[var_367b15e7.script_noteworthy] = var_367b15e7;
		}
		else
		{
			level.var_9c725b07[var_367b15e7.script_noteworthy] = var_367b15e7;
		}
		var_367b15e7 thread scene::init("p7_fxanim_zm_island_switch_trap_lever_bundle", var_367b15e7);
		var_367b15e7 SetIgnorePauseWorld(1);
	}
	var_d3782b4c = struct::get_array("s_onswitch_unitrigger", "script_label");
	if(var_d3782b4c.size > 0)
	{
		foreach(var_2e0c3d2c in var_d3782b4c)
		{
			var_2e0c3d2c.script_unitrigger_type = "unitrigger_box_use";
			var_2e0c3d2c.cursor_hint = "HINT_NOICON";
			var_2e0c3d2c.require_look_at = 1;
			var_2e0c3d2c.var_a6a648f0 = self;
			var_2e0c3d2c.script_width = 100;
			var_2e0c3d2c.script_length = 100;
			var_2e0c3d2c.script_height = 100;
		}
		level.var_84662f56 = [];
		level.var_84662f56["proptraps_onswitch"] = &"ZM_ISLAND_TRAP_PROPTRAP_USE";
		level.var_84662f56["walltrap_onswitch"] = &"ZM_ISLAND_TRAP_WALLTRAP_USE";
		level.var_2e0a18df = [];
		level.var_2e0a18df["proptraps_onswitch"] = &"ZM_ISLAND_TRAP_PROPTRAP_REST";
		level.var_2e0a18df["walltrap_onswitch"] = &"ZM_ISLAND_TRAP_WALLTRAP_REST";
		level.var_af480c69 = [];
		level.var_af480c69["proptraps_onswitch"] = 1000;
		level.var_af480c69["walltrap_onswitch"] = 1000;
		level.var_8e8608e3 = [];
		level.var_569af21a = [];
		foreach(var_2e0c3d2c in var_d3782b4c)
		{
			/#
				Assert(isdefined(var_2e0c3d2c.script_int), "Dev Block strings are not supported" + var_2e0c3d2c.targetname + "Dev Block strings are not supported");
			#/
			var_9ef8e179 = "power_on" + var_2e0c3d2c.script_int;
			var_2e0c3d2c.var_b28029bc = Array(var_9ef8e179, "power_on");
			if(var_2e0c3d2c.targetname == "walltrap_onswitch")
			{
				var_2e0c3d2c.var_71dddffe = level.var_84662f56["walltrap_onswitch"];
				var_2e0c3d2c.var_d7141317 = level.var_2e0a18df["walltrap_onswitch"];
				var_2e0c3d2c.var_de0db1fd = 30;
				var_2e0c3d2c.var_614a7182 = 30;
				var_2e0c3d2c.n_cost = 1000;
				level.var_569af21a[var_2e0c3d2c.script_noteworthy] = var_2e0c3d2c;
				var_2e0c3d2c.prompt_and_visibility_func = &function_2f33d1b;
				zm_unitrigger::register_static_unitrigger(var_2e0c3d2c, &function_d6b07530);
				continue;
			}
			if(var_2e0c3d2c.targetname == "proptraps_onswitch")
			{
				var_2e0c3d2c.var_71dddffe = level.var_84662f56["proptraps_onswitch"];
				var_2e0c3d2c.var_d7141317 = level.var_2e0a18df["proptraps_onswitch"];
				var_2e0c3d2c.var_de0db1fd = 30;
				var_2e0c3d2c.var_614a7182 = 30;
				var_2e0c3d2c.n_cost = 1000;
				level.var_8e8608e3[var_2e0c3d2c.script_noteworthy] = var_2e0c3d2c;
				var_2e0c3d2c.prompt_and_visibility_func = &function_25bf44e4;
				zm_unitrigger::register_static_unitrigger(var_2e0c3d2c, &function_5245e8c3);
			}
		}
	}
}

/*
	Name: function_2f33d1b
	Namespace: namespace_14b4d4ab
	Checksum: 0xCA6AF825
	Offset: 0x23D0
	Size: 0x1CF
	Parameters: 1
	Flags: None
*/
function function_2f33d1b(player)
{
	if(isdefined(self.stub.script_int) && !level flag::get_any(self.stub.var_b28029bc) && level.var_dd5501c7[self.stub.target].b_on !== 1)
	{
		self setHintString(&"ZM_ISLAND_NO_POWER");
		exploder::stop_exploder("ex_fan_switch");
		return 0;
	}
	else if(isdefined(self.stub.target) && level.var_dd5501c7[self.stub.target].b_on !== 1 && level.var_dd5501c7[self.stub.target].var_b44dbcd2 !== 1)
	{
		self setHintString(level.var_84662f56[self.stub.targetname], level.var_af480c69[self.stub.targetname]);
		exploder::exploder("ex_fan_switch");
		return 1;
	}
	else
	{
		self setHintString(level.var_2e0a18df[self.stub.targetname]);
		exploder::stop_exploder("ex_fan_switch");
		return 0;
	}
}

/*
	Name: function_25bf44e4
	Namespace: namespace_14b4d4ab
	Checksum: 0x8D5571D4
	Offset: 0x25A8
	Size: 0x197
	Parameters: 1
	Flags: None
*/
function function_25bf44e4(player)
{
	if(isdefined(self.stub.script_int) && !level flag::get_any(self.stub.var_b28029bc) && (level.var_e938db57.b_on !== 1 && level.var_77316c1c.b_on !== 1))
	{
		self setHintString(&"ZM_ISLAND_NO_POWER");
		exploder::stop_exploder("ex_prop_switch");
		return 0;
	}
	else if(level.var_e938db57.b_on !== 1 && level.var_e938db57.var_b44dbcd2 !== 1)
	{
		self setHintString(level.var_84662f56[self.stub.targetname], level.var_af480c69[self.stub.targetname]);
		exploder::exploder("ex_prop_switch");
		return 1;
	}
	else
	{
		self setHintString(level.var_2e0a18df[self.stub.targetname]);
		exploder::stop_exploder("ex_prop_switch");
		return 0;
	}
}

/*
	Name: function_d6b07530
	Namespace: namespace_14b4d4ab
	Checksum: 0xDA70B8AA
	Offset: 0x2748
	Size: 0x31F
	Parameters: 0
	Flags: None
*/
function function_d6b07530()
{
	while(1)
	{
		self waittill("trigger", ent);
		var_df549564 = 0;
		if(level.var_dd5501c7[self.stub.target].b_on !== 1 && level.var_dd5501c7[self.stub.target].var_b44dbcd2 !== 1)
		{
			if(isPlayer(ent))
			{
				if(self.stub.n_cost <= ent.score)
				{
					ent zm_score::minus_to_player_score(self.stub.n_cost);
					self playsound("evt_wall_trap_start");
					if(isdefined(self.stub.script_linkto))
					{
						foreach(var_2b23f444 in level.var_569af21a)
						{
							if(self.stub.script_linkto === var_2b23f444.script_noteworthy)
							{
								var_367b15e7 = level.var_9c725b07[self.stub.script_noteworthy];
								var_367b15e7 thread scene::Play("p7_fxanim_zm_island_switch_trap_lever_bundle", var_367b15e7);
								level.var_dd5501c7[var_2b23f444.target] thread [[level.var_dd5501c7[var_2b23f444.target].var_8bf7f16f]](ent);
								var_2b23f444.var_df549564 = 1;
							}
						}
					}
					var_df549564 = 1;
				}
				else
				{
					ent function_770b3c6e();
					var_df549564 = 0;
				}
			}
			else
			{
				var_df549564 = 1;
			}
			if(isdefined(var_df549564) && var_df549564)
			{
				level.var_dd5501c7[self.stub.target] thread [[level.var_dd5501c7[self.stub.target].var_8bf7f16f]](ent);
				self.stub.var_b44dbcd2 = 1;
				wait(self.stub.var_de0db1fd);
				self.stub.var_b44dbcd2 = 0;
			}
		}
	}
}

/*
	Name: function_5245e8c3
	Namespace: namespace_14b4d4ab
	Checksum: 0x3A745F4C
	Offset: 0x2A70
	Size: 0x1F7
	Parameters: 0
	Flags: None
*/
function function_5245e8c3()
{
	while(1)
	{
		self waittill("trigger", ent);
		if(level.var_e938db57.b_on !== 1 && level.var_e938db57.var_b44dbcd2 !== 1)
		{
			if(zm_utility::is_player_valid(ent) && self.stub.n_cost <= ent.score)
			{
				ent zm_score::minus_to_player_score(self.stub.n_cost);
				self thread function_fd097b36(ent);
				foreach(var_f13de5d6 in level.var_8e8608e3)
				{
					var_f13de5d6.var_b44dbcd2 = 1;
				}
				wait(self.stub.var_de0db1fd);
				foreach(var_f13de5d6 in level.var_8e8608e3)
				{
					var_f13de5d6.var_b44dbcd2 = 0;
				}
			}
			else
			{
				ent function_770b3c6e();
			}
		}
	}
}

/*
	Name: function_770b3c6e
	Namespace: namespace_14b4d4ab
	Checksum: 0xB510E5E7
	Offset: 0x2C70
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_770b3c6e()
{
	self playsound("evt_perk_deny");
	self zm_audio::create_and_play_dialog("general", "outofmoney");
}

/*
	Name: function_b2e2a102
	Namespace: namespace_14b4d4ab
	Checksum: 0xEC98BC1
	Offset: 0x2CC8
	Size: 0x461
	Parameters: 0
	Flags: None
*/
function function_b2e2a102()
{
	var_39467626 = GetEntArray("mdl_walltrap_blade", "script_string");
	var_790a24b0 = GetEntArray("t_walltrap_hazard", "script_string");
	var_7e25b6ee = GetEntArray("t_walltrap_death", "script_string");
	var_2b73bb92 = [];
	var_947d0bae = [];
	level.var_dd5501c7 = [];
	for(i = 0; i < var_790a24b0.size; i++)
	{
		if(isdefined(var_790a24b0[i].targetname) && var_790a24b0[i].targetname !== "")
		{
			level.var_dd5501c7[var_790a24b0[i].targetname] = var_790a24b0[i];
			level.var_dd5501c7[var_790a24b0[i].targetname].str_type = "WALLTRAP";
		}
		if(isdefined(var_39467626[i].targetname) && var_39467626[i].targetname !== "")
		{
			var_2b73bb92[var_39467626[i].targetname] = var_39467626[i];
		}
		if(isdefined(var_7e25b6ee[i].targetname) && var_7e25b6ee[i].targetname !== "")
		{
			var_947d0bae[var_7e25b6ee[i].targetname] = var_7e25b6ee[i];
		}
	}
	foreach(var_84d67e66 in level.var_dd5501c7)
	{
		if(isdefined(var_84d67e66.targetname) && var_84d67e66.targetname !== "")
		{
			level.var_dd5501c7[var_84d67e66.targetname].var_7e5afbd = var_2b73bb92[var_84d67e66.targetname];
			level.var_dd5501c7[var_84d67e66.targetname].var_d6d6c058 = AnglesToForward(var_2b73bb92[var_84d67e66.targetname].angles) * -1;
			level.var_dd5501c7[var_84d67e66.targetname].var_6b281b64 = AnglesToRight(var_2b73bb92[var_84d67e66.targetname].angles) + level.var_dd5501c7[var_84d67e66.targetname].var_d6d6c058;
			level.var_dd5501c7[var_84d67e66.targetname].var_d93f9cb8 = var_947d0bae[var_84d67e66.targetname];
			level.var_dd5501c7[var_84d67e66.targetname].var_8bf7f16f = &function_4ed6e5ec;
			level.var_dd5501c7[var_84d67e66.targetname] function_823c5c5a();
		}
	}
}

/*
	Name: function_ddff768c
	Namespace: namespace_14b4d4ab
	Checksum: 0xCD16DDDB
	Offset: 0x3138
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function function_ddff768c()
{
	self.b_on = 1;
	self thread sound::loop_fx_sound("evt_wall_trap_loop", self.origin + (20, 100, 0), "walltrap_off");
	playsoundatposition("evt_wall_trap_start", self.origin + (20, 100, 0));
	self thread function_fde9856();
}

/*
	Name: function_823c5c5a
	Namespace: namespace_14b4d4ab
	Checksum: 0xAB0C5177
	Offset: 0x31D8
	Size: 0x91
	Parameters: 0
	Flags: None
*/
function function_823c5c5a()
{
	self.b_on = 0;
	self TriggerEnable(0);
	self.var_d93f9cb8 TriggerEnable(0);
	self function_4778351d(0);
	playsoundatposition("evt_wall_trap_end", self.origin + (20, 100, 0));
	self notify("hash_823c5c5a");
}

/*
	Name: function_327061db
	Namespace: namespace_14b4d4ab
	Checksum: 0x633FD6D0
	Offset: 0x3278
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_327061db()
{
	if(self.b_on === 1)
	{
		self function_823c5c5a();
	}
	else
	{
		self function_ddff768c();
	}
}

/*
	Name: function_4778351d
	Namespace: namespace_14b4d4ab
	Checksum: 0xB8E5D6C7
	Offset: 0x32C8
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function function_4778351d(var_3d2579d3)
{
	if(!isdefined(var_3d2579d3))
	{
		var_3d2579d3 = 1;
	}
	if(var_3d2579d3)
	{
		exploder::exploder("fxexp_100");
		exploder::exploder("lgt_fan");
	}
	else
	{
		exploder::stop_exploder("fxexp_100");
		exploder::stop_exploder("lgt_fan");
	}
}

/*
	Name: function_4ed6e5ec
	Namespace: namespace_14b4d4ab
	Checksum: 0x4EEFB3E9
	Offset: 0x3368
	Size: 0x2A3
	Parameters: 3
	Flags: None
*/
function function_4ed6e5ec(e_player, var_de0db1fd, var_614a7182)
{
	if(!isdefined(var_de0db1fd))
	{
		var_de0db1fd = 30;
	}
	if(!isdefined(var_614a7182))
	{
		var_614a7182 = 30;
	}
	if(self.b_on !== 1 && self.var_b44dbcd2 !== 1)
	{
		self.var_6afd6b = e_player;
		if(isdefined(e_player))
		{
			e_player notify("hash_9eca5f86");
		}
		level clientfield::set("walltrap_draft_rumble", 1);
		foreach(player in level.activePlayers)
		{
			player clientfield::set_to_player("walltrap_draft_blur", 1);
		}
		exploder::exploder_stop("ex_fan_switch");
		self playsound("zmb_trap_activated");
		self function_ddff768c();
		wait(var_de0db1fd);
		self function_823c5c5a();
		level clientfield::set("walltrap_draft_rumble", 0);
		foreach(player in level.activePlayers)
		{
			player clientfield::set_to_player("walltrap_draft_blur", 0);
		}
		self.var_6afd6b = undefined;
		self.var_b44dbcd2 = 1;
		wait(var_614a7182);
		self.var_b44dbcd2 = 0;
		self playsound("zmb_trap_ready");
		exploder::exploder("ex_fan_switch");
	}
}

/*
	Name: function_fde9856
	Namespace: namespace_14b4d4ab
	Checksum: 0xFA2B6591
	Offset: 0x3618
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function function_fde9856()
{
	self.var_7e5afbd RotateRoll(1000, 1.5, 1);
	wait(1.5);
	self thread function_c801c84a();
	while(self.b_on === 1)
	{
		self.var_7e5afbd RotateRoll(1000, 0.5);
		wait(0.5);
	}
}

/*
	Name: function_c801c84a
	Namespace: namespace_14b4d4ab
	Checksum: 0x4C6AD2FE
	Offset: 0x36B0
	Size: 0x107
	Parameters: 0
	Flags: None
*/
function function_c801c84a()
{
	self endon("hash_823c5c5a");
	self._trap_type = "rotating";
	self.activated_by_player = self.var_6afd6b;
	self function_4778351d(1);
	self TriggerEnable(1);
	self.var_d93f9cb8 TriggerEnable(1);
	while(self.b_on)
	{
		self waittill("trigger", ent);
		if(!ent laststand::player_is_in_laststand() && isalive(ent) && ent.var_96ff34d0 !== 1)
		{
			ent thread function_55a15733(self);
		}
	}
}

/*
	Name: function_55a15733
	Namespace: namespace_14b4d4ab
	Checksum: 0x88026F7D
	Offset: 0x37C0
	Size: 0x363
	Parameters: 1
	Flags: None
*/
function function_55a15733(var_a464d35b)
{
	self endon("hash_5798c1b0");
	var_a464d35b endon("hash_823c5c5a");
	self.var_96ff34d0 = 1;
	if(isPlayer(self))
	{
		var_b14e6934 = var_a464d35b.var_d6d6c058 * 75;
		while(isalive(self) && self istouching(var_a464d35b))
		{
			if(self istouching(var_a464d35b.var_d93f9cb8))
			{
				self function_de0d7531(var_a464d35b);
				self notify("hash_5798c1b0");
				break;
			}
			else if(self IsSliding() || self issprinting())
			{
				v_player_velocity = self GetVelocity();
				var_64c3f8ef = v_player_velocity + var_b14e6934;
			}
			else
			{
				var_64c3f8ef = var_b14e6934;
			}
			self SetVelocity(var_64c3f8ef);
			wait(0.05);
		}
		self.var_96ff34d0 = 0;
	}
	else if(!(isdefined(self.var_61f7b3a0) && self.var_61f7b3a0))
	{
		var_4ed4eec0 = util::spawn_model("tag_origin", self.origin, self.angles);
		self LinkTo(var_4ed4eec0);
		self playsound("evt_wall_trap_suck");
		n_time = Distance(var_4ed4eec0.origin, var_a464d35b.var_d93f9cb8.origin) / 400;
		var_1ee590e5 = (var_a464d35b.var_d93f9cb8.origin[0], var_a464d35b.var_d93f9cb8.origin[1], self.origin[2]);
		level thread function_a569a27d(var_a464d35b, var_4ed4eec0, self);
		var_4ed4eec0 moveto(var_1ee590e5, n_time);
		var_4ed4eec0 waittill("movedone");
		self Unlink();
		self playsound("evt_wall_trap_grind");
		self.var_96ff34d0 = 0;
		self thread function_12a70fc8(var_a464d35b, var_1ee590e5);
		var_4ed4eec0 delete();
	}
}

/*
	Name: function_a569a27d
	Namespace: namespace_14b4d4ab
	Checksum: 0xA284BDDF
	Offset: 0x3B30
	Size: 0x93
	Parameters: 3
	Flags: None
*/
function function_a569a27d(var_a464d35b, var_4ed4eec0, e_victim)
{
	var_a464d35b util::waittill_notify_or_timeout("walltrap_off", 1);
	if(isdefined(e_victim) && isalive(e_victim))
	{
		e_victim Unlink();
	}
	if(isdefined(var_4ed4eec0))
	{
		var_4ed4eec0 delete();
	}
}

/*
	Name: function_12a70fc8
	Namespace: namespace_14b4d4ab
	Checksum: 0x33BC2C7A
	Offset: 0x3BD0
	Size: 0x4A3
	Parameters: 2
	Flags: None
*/
function function_12a70fc8(e_trap, v_pos)
{
	str_kill_notify = "";
	if(e_trap.str_type == "PROPTRAP_a")
	{
		var_3497ae15 = "UPPERONLY";
		self.var_a35053a6 = 1;
		if(self.archetype == "thrasher")
		{
			exploder::exploder("fxexp_117");
		}
		if(self.archetype === "zombie")
		{
			exploder::exploder("fxexp_111");
			var_6afd6b = e_trap.var_6afd6b;
			var_401318b0 = Array("update_challenge_3_4");
			str_kill_notify = "player_saw_proptrap_kill";
		}
		if(self.archetype === "spider")
		{
			exploder::exploder("fxexp_119");
		}
	}
	else if(e_trap.str_type == "PROPTRAP_b")
	{
		var_3497ae15 = "UPPERONLY";
		self.var_a35053a6 = 1;
		if(self.archetype == "thrasher")
		{
			exploder::exploder("fxexp_116");
		}
		if(self.archetype === "zombie")
		{
			exploder::exploder("fxexp_113");
			var_6afd6b = e_trap.var_6afd6b;
			var_401318b0 = Array("update_challenge_3_4");
			str_kill_notify = "player_saw_proptrap_kill";
		}
		if(self.archetype === "spider")
		{
			exploder::exploder("fxexp_118");
		}
	}
	else
	{
		exploder::exploder("fxexp_101");
		if(self.archetype === "spider")
		{
			var_3497ae15 = "ALL";
			exploder::exploder("fxexp_102");
		}
		if(self.archetype === "zombie")
		{
			var_3497ae15 = "DELETE";
			var_6afd6b = e_trap.var_6afd6b;
			var_401318b0 = Array("update_challenge_2_6");
			str_kill_notify = "player_saw_walltrap_kill";
		}
	}
	if(var_3497ae15 !== "DELETE")
	{
		self thread function_21fd498a(var_3497ae15);
		self DoDamage(self.health * 2, v_pos, e_trap, e_trap, "MOD_MELEE");
	}
	else
	{
		self DoDamage(self.health * 2, v_pos, e_trap, e_trap, "MOD_MELEE");
		wait(0.05);
		self delete();
	}
	if(zm_utility::is_player_valid(var_6afd6b))
	{
		var_6afd6b zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_KILL_TRAP");
		foreach(str_challenge_notify in var_401318b0)
		{
			var_6afd6b notify(str_challenge_notify);
			wait(0.1);
		}
	}
	else if(str_kill_notify != "")
	{
		level thread function_df83b6d1(v_pos, str_kill_notify);
	}
}

/*
	Name: function_df83b6d1
	Namespace: namespace_14b4d4ab
	Checksum: 0x802F09CB
	Offset: 0x4080
	Size: 0x18B
	Parameters: 2
	Flags: None
*/
function function_df83b6d1(v_pos, str_kill_notify)
{
	self endon("death");
	if(!level flag::get("witnessed_trapkill_dialog"))
	{
		level flag::set("witnessed_trapkill_dialog");
		a_players = ArrayCopy(level.players);
		do
		{
			e_player = ArrayGetClosest(v_pos, a_players);
			if(zm_utility::is_player_valid(e_player) && e_player namespace_8aed53c9::is_facing(v_pos))
			{
				var_520430be = e_player;
			}
			else
			{
				ArrayRemoveValue(a_players, e_player);
			}
		}
		while(!(!isdefined(var_520430be) && a_players.size > 0));
		if(zm_utility::is_player_valid(var_520430be))
		{
			level flag::set("witnessed_trapkill_dialog");
			var_520430be notify(str_kill_notify);
			wait(10);
			level flag::clear("witnessed_trapkill_dialog");
		}
	}
}

/*
	Name: function_21fd498a
	Namespace: namespace_14b4d4ab
	Checksum: 0x992276F6
	Offset: 0x4218
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function function_21fd498a(str_mode)
{
	if(!isdefined(str_mode))
	{
		str_mode = "ALL";
	}
	if(!(isdefined(self.no_gib) && self.no_gib))
	{
		GibServerUtils::GibHead(self);
	}
	GibServerUtils::GibLeftArm(self);
	GibServerUtils::GibRightArm(self);
	if(str_mode == "ALL")
	{
		GibServerUtils::GibLegs(self);
	}
}

/*
	Name: function_de0d7531
	Namespace: namespace_14b4d4ab
	Checksum: 0x26172FD8
	Offset: 0x42C8
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function function_de0d7531(var_60532813)
{
	if(isdefined(var_60532813.var_6b281b64))
	{
		var_23b6ded0 = var_60532813.var_6b281b64 * 75 * 10;
	}
	else
	{
		var_23b6ded0 = self.origin - var_60532813.origin;
	}
	self SetVelocity(var_23b6ded0);
	wait(0.05);
	self.var_96ff34d0 = 0;
	self DoDamage(self.health * 2, self.origin);
}

/*
	Name: function_74ddcad3
	Namespace: namespace_14b4d4ab
	Checksum: 0xD74EBD73
	Offset: 0x4390
	Size: 0xE7
	Parameters: 0
	Flags: None
*/
function function_74ddcad3()
{
	level flag::wait_till("defend_over");
	var_fdcf3636 = GetEnt("t_penstock_flow", "targetname");
	while(1)
	{
		var_fdcf3636 waittill("trigger", ent);
		if(zm_utility::is_player_valid(ent) && (!isdefined(ent.var_c73f00e0) && ent.var_c73f00e0))
		{
			ent.var_c73f00e0 = 1;
			ent thread function_b90ebe4e(var_fdcf3636);
		}
	}
}

/*
	Name: function_b90ebe4e
	Namespace: namespace_14b4d4ab
	Checksum: 0xEE0C0F4B
	Offset: 0x4480
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function function_b90ebe4e(var_fdcf3636)
{
	self endon("death");
	var_b14e6934 = VectorScale((0, -1, 0), 20);
	while(zm_utility::is_player_valid(self) && self istouching(var_fdcf3636))
	{
		v_player_velocity = self GetVelocity();
		var_64c3f8ef = v_player_velocity + var_b14e6934;
		self SetVelocity(var_64c3f8ef);
		wait(0.1);
	}
	self.var_c73f00e0 = 0;
}

