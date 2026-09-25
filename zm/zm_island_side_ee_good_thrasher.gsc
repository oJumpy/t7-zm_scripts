#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\drown;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm_ai_thrasher;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_keeper_skull;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_island_spores;
#using scripts\zm\zm_island_util;

#namespace namespace_f777c489;

/*
	Name: __init__sytem__
	Namespace: namespace_f777c489
	Checksum: 0x41CB140A
	Offset: 0x788
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_side_ee_good_thrasher", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_f777c489
	Checksum: 0x20EE8F39
	Offset: 0x7C8
	Size: 0x383
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.var_564761a3 = spawnstruct();
	level.var_564761a3.var_69299ec6 = GetEnt("mdl_side_ee_gt_vine", "targetname");
	level.var_564761a3.var_978adea0 = GetEntArray("mdl_good_thrasher_vines", "targetname");
	level.var_564761a3.var_11c98268 = struct::get("s_side_ee_gt_spore_pos", "targetname");
	level.var_564761a3.var_ff07b157 = GetEnt("mdl_side_ee_gt_sporeplant", "targetname");
	level.var_564761a3.var_ff07b157.var_7117876c = level.var_564761a3.var_ff07b157.origin;
	level.var_564761a3.var_ff07b157.v_off_pos = level.var_564761a3.var_ff07b157.origin - VectorScale((0, 0, 1), 50);
	level.var_564761a3.var_ff07b157.var_baeb5712 = 1;
	level.var_564761a3.var_ff07b157 SetScale(0.1);
	v_pos = level.var_564761a3.var_ff07b157.origin + (-16, -48, 0);
	level.var_564761a3.var_480b39a3 = util::spawn_model("tag_origin", v_pos, level.var_564761a3.var_ff07b157.angles);
	callback::on_spawned(&on_player_spawned);
	callback::on_connect(&function_8feafce2);
	var_d1cfa380 = GetMinBitCountForNum(7);
	var_a15256dd = GetMinBitCountForNum(3);
	clientfield::register("scriptmover", "side_ee_gt_spore_glow_fx", 9000, 1, "int");
	clientfield::register("scriptmover", "side_ee_gt_spore_cloud_fx", 9000, var_d1cfa380, "int");
	clientfield::register("actor", "side_ee_gt_spore_trail_enemy_fx", 9000, 1, "int");
	clientfield::register("allplayers", "side_ee_gt_spore_trail_player_fx", 9000, var_a15256dd, "int");
	clientfield::register("actor", "good_thrasher_fx", 9000, 1, "int");
}

/*
	Name: main
	Namespace: namespace_f777c489
	Checksum: 0x8E165141
	Offset: 0xB58
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function main()
{
	/#
		level thread function_a0e0b4c2();
	#/
	var_895c0fb2 = GetEnt("mdl_goodthrasher_wall_decal", "targetname");
	var_895c0fb2 clientfield::set("do_fade_material", 0.5);
	var_199cfb62 = GetEntArray("mdl_good_thrasher_wall", "targetname");
	var_c047302 = var_199cfb62[0];
	var_c047302 clientfield::set("do_fade_material", 1);
}

/*
	Name: on_player_spawned
	Namespace: namespace_f777c489
	Checksum: 0x43F17568
	Offset: 0xC30
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self thread function_4aee2763();
}

/*
	Name: function_8feafce2
	Namespace: namespace_f777c489
	Checksum: 0x99EC1590
	Offset: 0xC58
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_8feafce2()
{
}

/*
	Name: function_4aee2763
	Namespace: namespace_f777c489
	Checksum: 0xF4C8DB3F
	Offset: 0xC68
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function function_4aee2763()
{
	self endon("disconnect");
	self endon("death");
	level endon("hash_9fe92074");
	var_199cfb62 = GetEntArray("mdl_good_thrasher_wall", "targetname");
	var_c047302 = var_199cfb62[0];
	self namespace_8aed53c9::function_7448e472(var_c047302);
	level thread function_ad9a2050();
}

/*
	Name: function_ad9a2050
	Namespace: namespace_f777c489
	Checksum: 0xE80FCFDA
	Offset: 0xD08
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function function_ad9a2050()
{
	callback::remove_on_spawned(&on_player_spawned);
	level notify("hash_9fe92074");
	var_199cfb62 = GetEntArray("mdl_good_thrasher_wall", "targetname");
	var_c047302 = var_199cfb62[0];
	if(isdefined(var_c047302))
	{
		exploder::exploder("fxexp_506");
		var_895c0fb2 = GetEnt("mdl_goodthrasher_wall_decal", "targetname");
		var_c047302 clientfield::set("do_fade_material", 0);
		wait(0.25);
		var_895c0fb2 clientfield::set("do_fade_material", 0);
		wait(0.25);
		var_c047302 delete();
		var_895c0fb2 delete();
		exploder::exploder("ex_goodthrasher");
		level.var_564761a3.var_69299ec6 thread function_f3ed4502();
	}
}

/*
	Name: function_f3ed4502
	Namespace: namespace_f777c489
	Checksum: 0xF6D34B68
	Offset: 0xE90
	Size: 0x12F
	Parameters: 0
	Flags: None
*/
function function_f3ed4502()
{
	self SetCanDamage(1);
	var_f7ecb00a = 0;
	level.var_564761a3.var_480b39a3 clientfield::set("spore_grows", 3);
	while(!(isdefined(var_f7ecb00a) && var_f7ecb00a))
	{
		self waittill("damage", n_damage, e_attacker, var_a3382de1, v_point, str_means_of_death, var_c4fe462, var_e64d69f9, var_c04aef90, w_weapon);
		self.health = 10000;
		if(w_weapon.name === "hero_mirg2000_upgraded")
		{
			var_f7ecb00a = 1;
			self thread function_302fe6aa();
		}
	}
}

/*
	Name: function_302fe6aa
	Namespace: namespace_f777c489
	Checksum: 0xC2F1CDC4
	Offset: 0xFC8
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function function_302fe6aa()
{
	self Hide();
	self SetCanDamage(0);
	self notsolid();
	foreach(var_4165e349 in level.var_564761a3.var_978adea0)
	{
		if(isdefined(var_4165e349))
		{
			var_4165e349 delete();
		}
	}
	wait(1);
	level thread function_95caef47();
}

/*
	Name: function_95caef47
	Namespace: namespace_f777c489
	Checksum: 0x844C81C7
	Offset: 0x10D0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_95caef47()
{
	level thread function_4724011d("ready");
}

/*
	Name: function_4724011d
	Namespace: namespace_f777c489
	Checksum: 0x21D58BF4
	Offset: 0x1100
	Size: 0xC5
	Parameters: 1
	Flags: None
*/
function function_4724011d(str_state)
{
	var_db03d856 = level.var_564761a3.var_ff07b157;
	if(var_db03d856.str_state !== str_state)
	{
		var_db03d856.str_state = str_state;
		switch(str_state)
		{
			case "ready":
			{
				var_db03d856 thread function_c8310977();
				break;
			}
			case "exploded":
			{
				var_db03d856 thread function_19f54a6f();
				break;
			}
			case "dormant":
			{
				var_db03d856 thread function_784ed421();
				break;
			}
		}
	}
}

/*
	Name: function_c8310977
	Namespace: namespace_f777c489
	Checksum: 0x330C5244
	Offset: 0x11D0
	Size: 0x1F3
	Parameters: 0
	Flags: None
*/
function function_c8310977()
{
	self endon("hash_593bd276");
	self endon("hash_101ca32e");
	self endon("death");
	self notify("hash_1fb62748");
	if(self.origin !== self.var_7117876c)
	{
		self moveto(self.var_7117876c, 1);
		self waittill("movedone");
	}
	level.var_564761a3.var_480b39a3 clientfield::set("spore_grows", 3);
	var_1811ea40 = GetEnt("mdl_mushroom_clip", "targetname");
	var_1811ea40 SetCanDamage(1);
	var_1811ea40 thread function_ecaf0cc6();
	while(1)
	{
		var_1811ea40.health = 10000;
		var_1811ea40 waittill("damage", n_damage, e_attacker, var_a3382de1, v_point, str_means_of_death, var_c4fe462, var_e64d69f9, var_c04aef90, w_weapon);
		if(zm_utility::is_player_valid(e_attacker))
		{
			var_1811ea40 SetCanDamage(0);
			level thread function_4724011d("exploded");
			break;
		}
	}
}

/*
	Name: function_ecaf0cc6
	Namespace: namespace_f777c489
	Checksum: 0xC2B8384F
	Offset: 0x13D0
	Size: 0x12F
	Parameters: 0
	Flags: None
*/
function function_ecaf0cc6()
{
	self endon("hash_593bd276");
	self endon("hash_101ca32e");
	self endon("death");
	var_b38b99d1 = 0;
	while(!(isdefined(var_b38b99d1) && var_b38b99d1))
	{
		foreach(player in level.activePlayers)
		{
			n_dist = DistanceSquared(self.origin, player.origin);
			if(n_dist <= 6000)
			{
				level thread function_4724011d("exploded");
				var_b38b99d1 = 1;
			}
		}
		wait(0.5);
	}
}

/*
	Name: function_19f54a6f
	Namespace: namespace_f777c489
	Checksum: 0xB738836C
	Offset: 0x1508
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function function_19f54a6f()
{
	self endon("hash_1fb62748");
	self endon("hash_101ca32e");
	self notify("hash_593bd276");
	self SetCanDamage(0);
	self thread function_4c6beece(4, 1);
	level.var_564761a3.var_480b39a3 clientfield::set("spore_grows", 0);
	level thread function_4724011d("dormant");
}

/*
	Name: function_784ed421
	Namespace: namespace_f777c489
	Checksum: 0xC90B3CCB
	Offset: 0x15B8
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function function_784ed421()
{
	self endon("hash_1fb62748");
	self endon("hash_593bd276");
	self endon("death");
	self notify("hash_101ca32e");
	self SetCanDamage(0);
	if(self.origin !== self.v_off_pos)
	{
		self moveto(self.v_off_pos, 1);
		self waittill("movedone");
	}
	var_5cddf7a = level.var_564761a3.var_1cd02afb;
	if(isdefined(var_5cddf7a))
	{
		while(isalive(var_5cddf7a))
		{
			wait(1);
		}
		level.var_564761a3.var_1cd02afb = undefined;
	}
	for(var_3c249619 = 3; var_3c249619 > 0; var_3c249619--)
	{
		level waittill("start_of_round");
	}
	level thread function_4724011d("ready");
}

/*
	Name: function_4c6beece
	Namespace: namespace_f777c489
	Checksum: 0xF48B5FD4
	Offset: 0x16F8
	Size: 0x299
	Parameters: 3
	Flags: None
*/
function function_4c6beece(var_f9f788a6, var_8963ba33, e_attacker)
{
	if(var_f9f788a6 == 1)
	{
		self.var_d7bb540a = 5;
		self.var_66bbb0c0 = 44;
	}
	else if(var_f9f788a6 == 2)
	{
		self.var_d7bb540a = 10;
		self.var_66bbb0c0 = 60;
	}
	else if(var_f9f788a6 == 3)
	{
		self.var_d7bb540a = 15;
		self.var_66bbb0c0 = 76;
	}
	else
	{
		self.var_d7bb540a = 45;
		self.var_66bbb0c0 = 76;
	}
	s_org = level.var_564761a3.var_11c98268;
	self thread function_63a5615b(var_8963ba33, s_org, var_f9f788a6);
	playsoundatposition("zmb_spore_eject", self.origin);
	var_88c0f006 = self function_cc07e4ad(self.var_66bbb0c0, s_org);
	while(self.var_d7bb540a > 0 && (!isdefined(level.var_564761a3.var_1cd02afb) || !isalive(level.var_564761a3.var_1cd02afb)))
	{
		self.var_d7bb540a = self.var_d7bb540a - 1;
		var_961d572f = var_88c0f006 Array::get_touching(GetAITeamArray("axis"));
		a_e_players = var_88c0f006 Array::get_touching(level.players);
		Array::thread_all(var_961d572f, &function_c6cec92d, 1, var_8963ba33, e_attacker);
		Array::thread_all(a_e_players, &function_c6cec92d, 1, var_8963ba33, undefined);
		wait(1);
	}
	self clientfield::set("side_ee_gt_spore_cloud_fx", 0);
	var_88c0f006 delete();
	self notify("hash_91dd564f");
}

/*
	Name: function_63a5615b
	Namespace: namespace_f777c489
	Checksum: 0x8F515C99
	Offset: 0x19A0
	Size: 0x133
	Parameters: 3
	Flags: None
*/
function function_63a5615b(var_8963ba33, s_org, var_f9f788a6)
{
	if(var_8963ba33)
	{
		if(var_f9f788a6 == 1)
		{
			self clientfield::set("side_ee_gt_spore_cloud_fx", 1);
		}
		else if(var_f9f788a6 == 2)
		{
			self clientfield::set("side_ee_gt_spore_cloud_fx", 2);
		}
		else
		{
			self clientfield::set("side_ee_gt_spore_cloud_fx", 3);
		}
	}
	else if(var_f9f788a6 == 1)
	{
		self clientfield::set("side_ee_gt_spore_cloud_fx", 4);
	}
	else if(var_f9f788a6 == 2)
	{
		self clientfield::set("side_ee_gt_spore_cloud_fx", 5);
	}
	else
	{
		self clientfield::set("side_ee_gt_spore_cloud_fx", 6);
	}
}

/*
	Name: function_cc07e4ad
	Namespace: namespace_f777c489
	Checksum: 0x451E8327
	Offset: 0x1AE0
	Size: 0x7F
	Parameters: 2
	Flags: None
*/
function function_cc07e4ad(var_66bbb0c0, s_org)
{
	var_9f786393 = 90;
	t_trig = spawn("trigger_radius", s_org.origin, 0, var_66bbb0c0, var_9f786393);
	t_trig.angles = s_org.angles;
	return t_trig;
}

/*
	Name: function_c6cec92d
	Namespace: namespace_f777c489
	Checksum: 0xA0237CEE
	Offset: 0x1B68
	Size: 0x4EB
	Parameters: 3
	Flags: None
*/
function function_c6cec92d(var_2cfe5148, var_8963ba33, e_attacker)
{
	self endon("death");
	self endon("disconnect");
	if(!isdefined(self.var_d07c64b6))
	{
		self.var_d07c64b6 = 0;
	}
	if(var_2cfe5148)
	{
		if(isdefined(self.targetname) && self.targetname == "zombie")
		{
			if(!self.var_d07c64b6)
			{
				self.var_d07c64b6 = 1;
				if(isdefined(level.var_564761a3.var_2d3405bf) && level.var_564761a3.var_2d3405bf || isalive(level.var_564761a3.var_1cd02afb))
				{
					self clientfield::set("side_ee_gt_spore_trail_enemy_fx", 1);
					self thread function_20ca7e14();
					wait(10);
					self.var_d07c64b6 = 0;
					self notify("hash_36dceca1");
					self clientfield::set("side_ee_gt_spore_trail_enemy_fx", 0);
				}
				else
				{
					self clientfield::set("side_ee_gt_spore_trail_enemy_fx", 1);
					if(!isdefined(level.var_564761a3.var_2d3405bf) && level.var_564761a3.var_2d3405bf && !isalive(level.var_564761a3.var_1cd02afb))
					{
						self thread function_5115d0a7();
					}
					else
					{
						self.var_317d58a6 = self.zombie_move_speed;
						self zombie_utility::set_zombie_run_cycle("walk");
						wait(10);
						self zombie_utility::set_zombie_run_cycle(self.var_317d58a6);
						self.var_d07c64b6 = 0;
						self clientfield::set("side_ee_gt_spore_trail_enemy_fx", 0);
					}
				}
			}
		}
		else if(isdefined(self.var_3940f450) && self.var_3940f450)
		{
			if(!self.var_d07c64b6)
			{
				self.var_d07c64b6 = 1;
				if(isdefined(e_attacker))
				{
					e_attacker notify("hash_2e126bd2");
				}
				if(var_8963ba33)
				{
					RadiusDamage(self.origin, 128, 1000, 1000);
				}
				else
				{
					self kill();
				}
			}
		}
		else if(isdefined(self.var_61f7b3a0) && self.var_61f7b3a0 && (!isdefined(self.var_60cb45e5) && self.var_60cb45e5))
		{
			if(!self.var_d07c64b6)
			{
				if(var_8963ba33)
				{
					self.var_d07c64b6 = 1;
					self DoDamage(self.health / 2, self.origin);
					wait(10);
					self.var_d07c64b6 = 0;
				}
			}
		}
	}
	else if(!self.var_d07c64b6)
	{
		self.var_d07c64b6 = 1;
		self notify("hash_ece519d9");
		if(self IsPlayerUnderwater())
		{
			self thread function_703ef5e8();
		}
		if(var_8963ba33)
		{
			self clientfield::set("side_ee_gt_spore_trail_player_fx", 1);
			self thread function_365b46bb();
			wait(30);
		}
		else if(self.var_df4182b1)
		{
			self notify("hash_b56a74a8");
			wait(5);
		}
		else
		{
			self clientfield::set("side_ee_gt_spore_trail_player_fx", 2);
			if(!self IsPlayerUnderwater())
			{
				self thread function_36f14fa1();
				self thread function_7fa4a0dd();
				self waittill("hash_59bc7047");
			}
			else
			{
				wait(3);
			}
		}
		self.var_d07c64b6 = 0;
		self notify("hash_dd8e5266");
		self clientfield::set("side_ee_gt_spore_trail_player_fx", 0);
	}
}

/*
	Name: function_5115d0a7
	Namespace: namespace_f777c489
	Checksum: 0xACCEBBF3
	Offset: 0x2060
	Size: 0x2B3
	Parameters: 0
	Flags: None
*/
function function_5115d0a7()
{
	if(!isdefined(level.var_564761a3.var_2d3405bf) && level.var_564761a3.var_2d3405bf && !isalive(level.var_564761a3.var_1cd02afb))
	{
		level.var_564761a3.var_2d3405bf = 1;
		level.var_564761a3.var_1cd02afb = namespace_756d2c3d::function_8b323113(self, 0, 0);
		for(n_wait = 5; n_wait > 0 && !isdefined(level.var_564761a3.var_1cd02afb); n_wait--)
		{
			wait(1);
		}
		if(isdefined(level.var_564761a3.var_1cd02afb))
		{
			level.var_564761a3.var_1cd02afb.var_60cb45e5 = 1;
			level.var_564761a3.var_1cd02afb SetTeam("allies");
			level.var_564761a3.var_1cd02afb util::magic_bullet_shield();
			level.var_564761a3.var_1cd02afb ai::set_behavior_attribute("move_mode", "friendly");
			level.var_564761a3.var_1cd02afb thread function_8870fa6e();
			var_ab3b4634 = ArrayGetClosest(level.var_564761a3.var_1cd02afb.origin, level.activePlayers);
			level.var_564761a3.var_1cd02afb SetOwner(var_ab3b4634);
			if(zm_utility::is_player_valid(var_ab3b4634) && !level flag::exists("side_ee_good_thrasher_seen"))
			{
				level flag::init("side_ee_good_thrasher_seen");
				level flag::set("side_ee_good_thrasher_seen");
				var_ab3b4634 notify("hash_a4a48b98");
			}
			level.var_564761a3.var_ff07b157.var_d7bb540a = 0;
		}
		level.var_564761a3.var_2d3405bf = 0;
	}
}

/*
	Name: function_8870fa6e
	Namespace: namespace_f777c489
	Checksum: 0xB97A7BF2
	Offset: 0x2320
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function function_8870fa6e()
{
	self thread function_2b2a9b70();
	self thread function_d3e5e5f4();
	self clientfield::set("good_thrasher_fx", 1);
	self util::waittill_any_timeout(300, "death", "gassed");
	self clientfield::set("good_thrasher_fx", 0);
	var_3cec36e5 = ArrayGetClosest(self.origin, level.activePlayers);
	if(zm_utility::is_player_valid(var_3cec36e5))
	{
		var_3cec36e5 notify("hash_52449593");
	}
	if(isalive(self))
	{
		self util::stop_magic_bullet_shield();
		self kill();
	}
}

/*
	Name: function_2b2a9b70
	Namespace: namespace_f777c489
	Checksum: 0x8BEC53C2
	Offset: 0x2460
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function function_2b2a9b70()
{
	self endon("death");
	trigger::wait_till("trigger_gas_hurt", "targetname", self);
	wait(2);
	self notify("gassed");
}

/*
	Name: function_d3e5e5f4
	Namespace: namespace_f777c489
	Checksum: 0xD9220A20
	Offset: 0x24B0
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function function_d3e5e5f4()
{
	self endon("death");
	while(1)
	{
		str_zone = self zm_utility::get_current_zone();
		if(str_zone === "zone_bunker_prison" && level.var_5258ba34)
		{
			wait(3);
			self notify("gassed");
		}
		wait(1);
	}
}

/*
	Name: function_365b46bb
	Namespace: namespace_f777c489
	Checksum: 0x2F7C7E10
	Offset: 0x2528
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function function_365b46bb()
{
	self endon("disconnect");
	self endon("death");
	self setMoveSpeedScale(1.3);
	self SetSprintDuration(60);
	self clientfield::set_to_player("speed_burst", 1);
	self playsound("zmb_spore_power_start");
	self PlayLoopSound("zmb_spore_power_loop", 0.5);
	self waittill("hash_dd8e5266");
	self playsound("zmb_spore_power_stop");
	self StopLoopSound(1);
	self setMoveSpeedScale(1);
	self SetSprintDuration(4);
	self clientfield::set_to_player("speed_burst", 0);
}

/*
	Name: function_97e9942
	Namespace: namespace_f777c489
	Checksum: 0x62D7ED9F
	Offset: 0x2680
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function function_97e9942()
{
	self endon("hash_dd8e5266");
	self endon("disconnect");
	while(1)
	{
		self clientfield::increment_to_player("postfx_futz_mild");
		wait(2.7);
	}
}

/*
	Name: function_6001fb15
	Namespace: namespace_f777c489
	Checksum: 0x73F4D10C
	Offset: 0x26D0
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function function_6001fb15()
{
	self endon("disconnect");
	self endon("death");
	self DisableWeapons();
	self disableUsability();
	self thread function_36f14fa1();
	self waittill("hash_dd8e5266");
	self enableWeapons();
	self enableUsability();
}

/*
	Name: function_703ef5e8
	Namespace: namespace_f777c489
	Checksum: 0x46925DF1
	Offset: 0x2770
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_703ef5e8()
{
	self notify("hash_337fabcf");
	self.drownStage = 0;
	self clientfield::set_to_player("drown_stage", 0);
	self.lastWaterDamageTime = GetTime();
	self drown::deactivate_player_health_visionset();
}

/*
	Name: function_20ca7e14
	Namespace: namespace_f777c489
	Checksum: 0x9631C9BA
	Offset: 0x27D8
	Size: 0x55
	Parameters: 0
	Flags: None
*/
function function_20ca7e14()
{
	self endon("hash_36dceca1");
	self endon("death");
	while(1)
	{
		self DoDamage(self.health / 10, self.origin);
		wait(1);
	}
}

/*
	Name: function_36f14fa1
	Namespace: namespace_f777c489
	Checksum: 0xA6FF9FEC
	Offset: 0x2838
	Size: 0x65
	Parameters: 0
	Flags: None
*/
function function_36f14fa1()
{
	self endon("death");
	self endon("hash_dd8e5266");
	if(self IsInVehicle())
	{
		return;
	}
	while(1)
	{
		self thread zm_audio::playerExert("cough", 1);
		wait(1);
	}
}

/*
	Name: function_7fa4a0dd
	Namespace: namespace_f777c489
	Checksum: 0x6529DE3A
	Offset: 0x28A8
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function function_7fa4a0dd()
{
	self endon("disconnect");
	if(self IsInVehicle())
	{
		return;
	}
	self function_2ce1c95f();
	self util::waittill_any("fake_death", "death", "player_downed", "weapon_change_complete");
	self function_909c515f();
	self notify("hash_59bc7047");
}

/*
	Name: function_2ce1c95f
	Namespace: namespace_f777c489
	Checksum: 0x93FC057F
	Offset: 0x2950
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function function_2ce1c95f()
{
	self zm_utility::increment_is_drinking();
	self zm_utility::disable_player_move_states(1);
	original_weapon = self GetCurrentWeapon();
	weapon = GetWeapon("zombie_cough");
	if(original_weapon != level.weaponNone && !zm_utility::is_placeable_mine(original_weapon) && !zm_equipment::is_equipment(original_weapon))
	{
		self.original_weapon = original_weapon;
	}
	else
	{
		return;
	}
	self GiveWeapon(weapon);
	self SwitchToWeapon(weapon);
}

/*
	Name: function_909c515f
	Namespace: namespace_f777c489
	Checksum: 0x5CE2FE98
	Offset: 0x2A60
	Size: 0x1AB
	Parameters: 0
	Flags: None
*/
function function_909c515f()
{
	self zm_utility::enable_player_move_states();
	weapon = GetWeapon("zombie_cough");
	if(self laststand::player_is_in_laststand() || (isdefined(self.intermission) && self.intermission))
	{
		self TakeWeapon(weapon);
		return;
	}
	self zm_utility::decrement_is_drinking();
	var_d82ff565 = self GetWeaponsListPrimaries();
	self TakeWeapon(weapon);
	if(self.IS_DRINKING > 0)
	{
		return;
	}
	else if(isdefined(self.original_weapon))
	{
		self SwitchToWeapon(self.original_weapon);
	}
	else if(isdefined(var_d82ff565) && var_d82ff565.size > 0)
	{
		self SwitchToWeapon(var_d82ff565[0]);
	}
	else if(self HasWeapon(level.laststandpistol))
	{
		self SwitchToWeapon(level.laststandpistol);
	}
	else
	{
		self zm_weapons::give_fallback_weapon();
	}
}

/*
	Name: function_a0e0b4c2
	Namespace: namespace_f777c489
	Checksum: 0x2734E4D
	Offset: 0x2C18
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_a0e0b4c2()
{
	/#
		zm_devgui::function_4acecab5(&function_9eaf14a2);
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_9eaf14a2
	Namespace: namespace_f777c489
	Checksum: 0xD50D729A
	Offset: 0x2C80
	Size: 0x75
	Parameters: 1
	Flags: None
*/
function function_9eaf14a2(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				level thread function_ad9a2050();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level.var_564761a3.var_69299ec6 thread function_302fe6aa();
				return 1;
			}
		}
		return 0;
	#/
}

