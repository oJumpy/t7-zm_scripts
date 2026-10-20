#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm_ai_spiders;
#using scripts\zm\_zm_ai_thrasher;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_island_util;
#using scripts\zm\zm_island_vo;

#namespace zm_island_skullquest;

/*
	Name: __init__sytem__
	Namespace: zm_island_skullquest
	Checksum: 0xEDD9D6B4
	Offset: 0x1268
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_skullquest", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_island_skullquest
	Checksum: 0x64DF121F
	Offset: 0x12A8
	Size: 0x2E3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("world", "keeper_spawn_portals", 1, 1, "int");
	clientfield::register("actor", "keeper_fx", 1, 1, "int");
	clientfield::register("actor", "ritual_attacker_fx", 1, 1, "int");
	clientfield::register("world", "skullquest_ritual_1_fx", 1, 3, "int");
	clientfield::register("world", "skullquest_ritual_2_fx", 1, 3, "int");
	clientfield::register("world", "skullquest_ritual_3_fx", 1, 3, "int");
	clientfield::register("world", "skullquest_ritual_4_fx", 1, 3, "int");
	clientfield::register("scriptmover", "skullquest_finish_start_fx", 1, 1, "int");
	clientfield::register("scriptmover", "skullquest_finish_trail_fx", 1, 1, "int");
	clientfield::register("scriptmover", "skullquest_finish_end_fx", 1, 1, "int");
	clientfield::register("scriptmover", "skullquest_finish_done_glow_fx", 1, 1, "int");
	callback::on_spawned(&on_player_spawned);
	scene::add_scene_func("scene_zm_dlc2_zombie_quick_rise_v2", &function_1c624caf, "done");
	level flag::init("a_player_got_skullgun");
	callback::on_spawned(&function_940267cd);
	callback::on_spawned(&function_ba04e236);
	callback::on_spawned(&function_e0075c9f);
}

/*
	Name: main
	Namespace: zm_island_skullquest
	Checksum: 0x5F79C743
	Offset: 0x1598
	Size: 0x14C7
	Parameters: 0
	Flags: None
*/
function main()
{
	/#
		level thread function_18d60013();
	#/
	level.var_b34be0cd = Array(0, 1, 2, 0, 3);
	level.var_53df8575 = Array(0, "p7_zm_isl_pedestal_battle", "p7_zm_isl_pedestal_blood", "p7_zm_isl_pedestal_chaos", "p7_zm_isl_pedestal_doom");
	level.var_8b0a8fa9 = &"ZM_ISLAND_SKULL_GET";
	level.var_983da0e6 = &"ZM_ISLAND_SKULL_PUT";
	level.var_8b418269 = &"ZM_ISLAND_SKULL_START";
	level.var_452c59e0 = 0;
	level.var_3846d9a8 = 0;
	level.var_55c48492 = GetEnt("mdl_skullgun", "targetname");
	level.var_55c48492.var_5cd7e450 = level.var_55c48492.origin;
	level.var_55c48492.var_d7778aba = level.var_55c48492.angles;
	level.var_b2152df5 = struct::get("s_utrig_get_skullgun", "targetname");
	var_cdbcb282 = GetEntArray("mdl_skull_s", "targetname");
	var_a7ba3819 = GetEntArray("mdl_skull_p", "targetname");
	var_45f27370 = GetEntArray("mdl_skulltar", "targetname");
	var_9d3ee5ea = struct::get_array("s_skulltar_skull_pos", "targetname");
	var_71b2b241 = struct::get_array("s_skulltar_attractor_src", "targetname");
	var_ca0fb49a = struct::get_array("s_skulltar_base_pos", "targetname");
	var_d76f80e0 = struct::get_array("s_utrig_pillar", "targetname");
	var_4b5bea8 = struct::get_array("s_utrig_skulltar", "targetname");
	/#
		Assert(var_cdbcb282.size == 4, "Dev Block strings are not supported" + var_cdbcb282.size);
	#/
	/#
		Assert(var_a7ba3819.size == 4, "Dev Block strings are not supported" + var_a7ba3819.size);
	#/
	level.var_cdbcb282 = [];
	level.var_d76f80e0 = [];
	level.a_skullquests = [];
	for(i = 1; i <= 4; i++)
	{
		level.a_skullquests[i] = spawnstruct();
		level.a_skullquests[i].targetname = "skullquest_" + i;
		level.a_skullquests[i].var_d38f69da = [];
		level.a_skullquests[i].var_41335b73 = [];
		level.a_skullquests[i].a_s_skulltar_attack_pos = [];
		level.a_skullquests[i] flag::init("skullquest_completed");
		level flag::init("skull_p_retrieved_for_ritual_" + i);
	}
	a_s_skulltar_attack_pos = struct::get_array("s_skulltar_attack_pos", "targetname");
	foreach(s_skulltar_attack_pos in a_s_skulltar_attack_pos)
	{
		Array::add(level.a_skullquests[s_skulltar_attack_pos.script_special].a_s_skulltar_attack_pos, s_skulltar_attack_pos);
	}
	for(i = 0; i < 4; i++)
	{
		level.var_cdbcb282[var_cdbcb282[i].script_special] = var_cdbcb282[i];
		level.a_skullquests[var_cdbcb282[i].script_special].mdl_skull_s = var_cdbcb282[i];
		level.a_skullquests[var_cdbcb282[i].script_special].mdl_skull_s.var_5cd7e450 = var_cdbcb282[i].origin;
		level.a_skullquests[var_cdbcb282[i].script_special].mdl_skull_s.var_d7778aba = var_cdbcb282[i].angles;
		level.a_skullquests[var_cdbcb282[i].script_special].mdl_skull_s.var_afb64bf6 = undefined;
		level.a_skullquests[var_cdbcb282[i].script_special].mdl_skull_s.var_f7d3c273 = level.a_skullquests[var_cdbcb282[i].script_special].mdl_skull_s.script_special;
		level.a_skullquests[var_a7ba3819[i].script_special].mdl_skull_p = var_a7ba3819[i];
		level.a_skullquests[var_a7ba3819[i].script_special].mdl_skull_p.var_5cd7e450 = var_a7ba3819[i].origin;
		level.a_skullquests[var_a7ba3819[i].script_special].mdl_skull_p.var_d7778aba = var_a7ba3819[i].angles;
		level.a_skullquests[var_a7ba3819[i].script_special].mdl_skull_p.var_afb64bf6 = undefined;
		level.a_skullquests[var_a7ba3819[i].script_special].mdl_skull_p ghost();
		level.a_skullquests[var_a7ba3819[i].script_special].mdl_skull_p.var_f7d3c273 = level.a_skullquests[var_a7ba3819[i].script_special].mdl_skull_p.script_special;
		level.var_d76f80e0[var_d76f80e0[i].script_special] = var_d76f80e0[i];
		level.a_skullquests[var_d76f80e0[i].script_special].s_utrig_pillar = var_d76f80e0[i];
		level.a_skullquests[var_4b5bea8[i].script_special].s_utrig_skulltar = var_4b5bea8[i];
		level.a_skullquests[var_9d3ee5ea[i].script_special].s_skulltar_skull_pos = var_9d3ee5ea[i];
		level.a_skullquests[var_71b2b241[i].script_special].s_skulltar_attractor_src = var_71b2b241[i];
		level.a_skullquests[var_ca0fb49a[i].script_special].s_skulltar_base_pos = var_ca0fb49a[i];
		level.a_skullquests[var_45f27370[i].script_special].mdl_skulltar = var_45f27370[i];
	}
	level.var_21406c35 = [];
	for(i = 0; i < 4; i++)
	{
		level.var_21406c35[i] = i + 1;
	}
	level.var_21406c35 = Array::randomize(level.var_21406c35);
	for(i = 3; i >= 0; i--)
	{
		level.var_21406c35[i + 1] = level.var_21406c35[i];
	}
	var_5bdf835e = [];
	Array::add(var_5bdf835e, "zone_start_water");
	Array::add(var_5bdf835e, "zone_start");
	Array::add(var_5bdf835e, "zone_start_2");
	var_35dd08f5 = [];
	Array::add(var_35dd08f5, "zone_crash_site");
	Array::add(var_35dd08f5, "zone_crash_site_2");
	var_fda8e8c = [];
	Array::add(var_fda8e8c, "zone_operating_rooms");
	var_80db60d2 = [];
	Array::add(var_80db60d2, "zone_cliffside");
	var_aa15c945 = [];
	var_aa15c945[1] = var_5bdf835e;
	var_aa15c945[2] = var_35dd08f5;
	var_aa15c945[3] = var_fda8e8c;
	var_aa15c945[4] = var_80db60d2;
	level.var_e534ade = GetEntArray("dais_center", "targetname");
	level.var_9046e7b0 = level.var_e534ade[0];
	if(isdefined(level.var_9046e7b0))
	{
		for(i = 1; i < level.var_e534ade.size; i++)
		{
			level.var_e534ade[i] LinkTo(level.var_9046e7b0);
		}
	}
	level scene::init("p7_fxanim_zm_island_alter_stairs_bundle");
	level.var_1a9b1b91 = GetEnt("dais_altar", "targetname");
	level.var_9046e7b0.var_9c93e17 = level.var_9046e7b0.origin;
	level.var_1a9b1b91.var_9c93e17 = level.var_1a9b1b91.origin;
	level.var_9046e7b0.v_open_pos = level.var_9046e7b0.origin - VectorScale((0, 0, 1), 256);
	level.var_1a9b1b91.v_open_pos = level.var_1a9b1b91.origin + VectorScale((1, 0, 0), 24);
	level.var_b10ab148 = 0;
	level flag::init("skull_quest_complete");
	for(i = 1; i <= 4; i++)
	{
		level.a_skullquests[i].script_special = i;
		level.a_skullquests[i].var_ba133ee2 = "skullquest_ritual_" + level.a_skullquests[i].script_special + "_fx";
		level.a_skullquests[i].origin = level.a_skullquests[i].s_skulltar_skull_pos.origin;
		level.a_skullquests[i].angles = level.a_skullquests[i].s_skulltar_skull_pos.angles;
		var_8fb7dd10 = "skullquest_ritual_failed_" + i;
		level zm_island_vo::function_65f8953a(var_8fb7dd10, "response", "negative", 5, 0, 0.5, level.a_skullquests[i].origin);
		var_4a347901 = "skulltar_" + i + "_spawnpts";
		level.a_skullquests[i].a_s_spawnpts = struct::get_array(var_4a347901, "targetname");
		level.a_skullquests[i].var_aa15c945 = var_aa15c945[i];
		var_c0032031 = level.var_21406c35[i];
		level.a_skullquests[i].mdl_skull_s = level.var_cdbcb282[var_c0032031];
		level.a_skullquests[i].mdl_skull_s.var_5cd7e450 = level.var_cdbcb282[var_c0032031].origin;
		level.a_skullquests[i].mdl_skull_s.var_d7778aba = level.var_cdbcb282[var_c0032031].angles;
		level.a_skullquests[i].mdl_skull_s.var_afb64bf6 = undefined;
		level.a_skullquests[i].mdl_skull_s.script_special = i;
		level.a_skullquests[i].mdl_skull_s clientfield::set("do_fade_material", 1);
		level.a_skullquests[i].mdl_skull_p SetModel(level.a_skullquests[i].mdl_skull_s.model);
		level.a_skullquests[i].mdl_skull_p.var_f7d3c273 = level.a_skullquests[i].mdl_skull_s.var_f7d3c273;
		level.a_skullquests[i].mdl_skulltar SetModel(level.var_53df8575[level.a_skullquests[i].mdl_skull_s.var_f7d3c273]);
		level.a_skullquests[i].s_utrig_pillar = level.var_d76f80e0[var_c0032031];
		level.a_skullquests[i].s_utrig_pillar.script_special = i;
		level.a_skullquests[i].s_utrig_pillar.script_string = "s_utrig_pillar_" + i;
		skullquest_init(i);
	}
	level flag::init("skullquest_ritual_inprogress1");
	level flag::init("skullquest_ritual_inprogress2");
	level flag::init("skullquest_ritual_inprogress3");
	level flag::init("skullquest_ritual_inprogress4");
	level flag::init("skullquest_ritual_complete1");
	level flag::init("skullquest_ritual_complete2");
	level flag::init("skullquest_ritual_complete3");
	level flag::init("skullquest_ritual_complete4");
	var_93999912 = [];
	var_93999912[1] = GetEnt("reveal_keeper_mural_01", "targetname");
	var_93999912[2] = GetEnt("reveal_keeper_mural_02", "targetname");
	var_93999912[3] = GetEnt("reveal_keeper_mural_03", "targetname");
	foreach(e_mural in var_93999912)
	{
		if(isdefined(e_mural))
		{
			e_mural clientfield::set("do_emissive_material", 0);
		}
	}
	var_c9260a5 = Array("", "p7_fxanim_zm_island_altar_skull_battle_bundle", "p7_fxanim_zm_island_altar_skull_blood_bundle", "p7_fxanim_zm_island_altar_skull_chaos_bundle", "p7_fxanim_zm_island_altar_skull_doom_bundle");
	foreach(var_e7e46205 in var_c9260a5)
	{
		level thread scene::init(var_c9260a5);
	}
	level.var_4ffafd2 = 0;
	level.var_69fe775a = 0;
}

/*
	Name: function_80794095
	Namespace: zm_island_skullquest
	Checksum: 0x902D01AC
	Offset: 0x2A68
	Size: 0x1C3
	Parameters: 0
	Flags: None
*/
function function_80794095()
{
	level flag::set("skullquest_ritual_inprogress" + self.script_special);
	self.var_6f46f579 = 1;
	self.mdl_skull_s show();
	self thread function_279e8476("rise");
	var_e9206c7f = 100;
	if(level.var_69fe775a === 0)
	{
		self.n_goal = 350;
	}
	else
	{
		self.n_goal = level.var_69fe775a;
	}
	self.n_progress = 0;
	self.var_cec6c329 = 0;
	self.var_f9d4e953 = 0;
	self.var_2f6a00a = 0;
	zm_spawner::register_zombie_death_event_callback(&function_3aa06eec);
	callback::on_vehicle_killed(&function_5681b8d3);
	self thread function_d15f7b3d();
	self thread function_9098a17a();
	self thread function_ff1550bd();
	level clientfield::set(self.var_ba133ee2, 1);
	self thread function_be54bf9f();
	self thread function_c3360ba8();
}

/*
	Name: function_279e8476
	Namespace: zm_island_skullquest
	Checksum: 0xE51881EB
	Offset: 0x2C38
	Size: 0x163
	Parameters: 1
	Flags: None
*/
function function_279e8476(str_state)
{
	switch(str_state)
	{
		case "rise":
		{
			str_anim = "p7_fxanim_zm_island_pedestal_skull_rise_bundle";
			mdl_skull = self.mdl_skull_s;
			break;
		}
		case "fall":
		{
			str_anim = "p7_fxanim_zm_island_pedestal_skull_fall_bundle";
			mdl_skull = self.mdl_skull_s;
			break;
		}
	}
	scene::add_scene_func(str_anim, &function_b00b433f, "play", self.script_special);
	self.mdl_skulltar thread scene::Play(str_anim);
	if(str_state == "rise")
	{
		wait(1);
	}
	else if(str_state == "fall")
	{
		self.mdl_skulltar waittill("scene_done");
		mdl_skull Unlink();
		if(isdefined(self.var_226d2560))
		{
			self.var_226d2560 delete();
		}
	}
	scene::remove_scene_func(str_anim, &function_b00b433f);
}

/*
	Name: function_b00b433f
	Namespace: zm_island_skullquest
	Checksum: 0x173DF114
	Offset: 0x2DA8
	Size: 0xEF
	Parameters: 2
	Flags: None
*/
function function_b00b433f(a_ents, n_ritual)
{
	mdl_skull = level.a_skullquests[n_ritual].mdl_skull_s;
	mdl_attach = a_ents["pedestal_skull"];
	mdl_skull.origin = mdl_attach GetTagOrigin("skull_link_jnt");
	mdl_skull.angles = mdl_attach GetTagAngles("skull_link_jnt");
	mdl_skull show();
	mdl_skull LinkTo(mdl_attach, "skull_link_jnt");
	level.a_skullquests[n_ritual].var_226d2560 = mdl_attach;
}

/*
	Name: function_e1c1e667
	Namespace: zm_island_skullquest
	Checksum: 0x69CE0BA6
	Offset: 0x2EA0
	Size: 0x1AD
	Parameters: 0
	Flags: None
*/
function function_e1c1e667()
{
	self.var_fcfa044d = 0;
	self._team = "axis";
	if(!isdefined(self.s_attractor))
	{
		self.s_attractor = spawnstruct();
		self.s_attractor.origin = self.s_skulltar_attractor_src.origin;
		self.s_attractor.angles = self.s_skulltar_attractor_src.angles;
	}
	var_b045a027 = 768;
	n_attractors = 48;
	var_d78038f4 = 5;
	self.s_attractor zm_utility::create_zombie_point_of_interest(var_b045a027, n_attractors, 10000);
	self.s_attractor.attract_to_origin = 1;
	self.s_attractor thread zm_utility::create_zombie_point_of_interest_attractor_positions(4, var_d78038f4);
	self.s_attractor thread zm_utility::wait_for_attractor_positions_complete();
	/#
		self.s_attractor thread zm_utility::debug_draw_attractor_positions();
	#/
	self thread function_d15f7b3d();
	level flag::wait_till_clear("skullquest_ritual_inprogress" + self.script_special);
	self.s_attractor notify("death");
	self notify("skulltar_attractors_off");
}

/*
	Name: function_d15f7b3d
	Namespace: zm_island_skullquest
	Checksum: 0xB08BCC04
	Offset: 0x3058
	Size: 0x153
	Parameters: 0
	Flags: None
*/
function function_d15f7b3d()
{
	self endon("skulltar_attractors_off");
	level endon("skullquest_ritual_ended" + self.script_special);
	while(1)
	{
		a_enemy_ai = self.var_41335b73;
		if(isdefined(a_enemy_ai))
		{
			foreach(ai in a_enemy_ai)
			{
				if(isalive(ai) && (!isdefined(ai.aat_turned) && ai.aat_turned) && DistanceSquared(ai.origin, self.s_skulltar_skull_pos.origin) <= 4200)
				{
					self thread function_afdb341(ai);
				}
			}
		}
		wait(1);
	}
}

/*
	Name: function_afdb341
	Namespace: zm_island_skullquest
	Checksum: 0xC3663C3C
	Offset: 0x31B8
	Size: 0x2D3
	Parameters: 1
	Flags: None
*/
function function_afdb341(ai)
{
	self endon("skulltar_attractors_off" + self.script_special);
	level endon("skullquest_ritual_ended" + self.script_special);
	ai endon("hash_87952665");
	ai endon("death");
	if(isdefined(ai.var_6a7c27af) && ai.var_6a7c27af)
	{
		return;
	}
	ai ai::set_ignoreall(1);
	switch(ai.archetype)
	{
		case "zombie":
		{
			var_872d00dd = "ai_zombie_base_ad_attack_v1";
			ai LookAtEntity(self.mdl_skull_s);
			n_damage = -15;
			break;
		}
		case "thrasher":
		{
			var_872d00dd = "ai_zm_dlc2_thrasher_attack_swing_swipe";
			ai LookAtEntity(self.mdl_skull_s);
			n_damage = -15;
			break;
		}
		case "spider":
		{
			var_872d00dd = "ai_zm_dlc2_spider_attack_melee";
			n_damage = -15;
			break;
		}
	}
	var_430b638 = getanimlength(var_872d00dd);
	self thread function_2a2ce01f(ai);
	ai notify("hash_aedf5455");
	while(level flag::get("skullquest_ritual_inprogress" + self.script_special) && isalive(ai) && (!isdefined(ai.var_3f6ea790) && ai.var_3f6ea790))
	{
		self thread function_f20126b2();
		if(!(isdefined(ai.var_3f6ea790) && ai.var_3f6ea790))
		{
			ai AnimScripted("melee", ai.origin, ai.angles, var_872d00dd, "normal", undefined, undefined, 0.5, 0.5);
			self.mdl_skull_s playsound("zmb_skull_ritual_hit");
			wait(var_430b638 + 1);
		}
	}
}

/*
	Name: function_2a2ce01f
	Namespace: zm_island_skullquest
	Checksum: 0x83E26191
	Offset: 0x3498
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_2a2ce01f(ai)
{
	self.var_cec6c329++;
	ai.var_6a7c27af = 1;
	ai waittill("death");
	if(isdefined(ai.var_6a7c27af) && ai.var_6a7c27af)
	{
		self.var_cec6c329--;
	}
}

/*
	Name: function_9098a17a
	Namespace: zm_island_skullquest
	Checksum: 0x3B68FD21
	Offset: 0x3508
	Size: 0x11B
	Parameters: 1
	Flags: None
*/
function function_9098a17a(var_c198423)
{
	if(!isdefined(var_c198423))
	{
		var_c198423 = 1;
	}
	self endon("skullquest_ritual_abandoned" + self.script_special);
	level endon("skullquest_ritual_ended" + self.script_special);
	while(self.n_progress < self.n_goal && self.n_progress >= 0 && self.var_2f6a00a < 10)
	{
		self thread function_194dd3fe();
		if(self function_44181b60() && self.n_progress >= 0)
		{
			self thread function_3654cf4c(10);
			self.var_f9d4e953 = 0;
		}
		else
		{
			self.var_f9d4e953++;
			if(self.var_f9d4e953 >= 5)
			{
				break;
			}
		}
		wait(var_c198423);
	}
	self thread function_186d9bd6();
}

/*
	Name: function_194dd3fe
	Namespace: zm_island_skullquest
	Checksum: 0xF3AE7F68
	Offset: 0x3630
	Size: 0xB7
	Parameters: 2
	Flags: None
*/
function function_194dd3fe(var_9f8b46b0, var_d03250e)
{
	if(!isdefined(var_9f8b46b0))
	{
		var_9f8b46b0 = 2;
	}
	if(!isdefined(var_d03250e))
	{
		var_d03250e = 0.25;
	}
	var_fc1e97a0 = self.n_progress / self.n_goal * 0.75;
	var_f3370df8 = var_9f8b46b0 - var_d03250e;
	if(var_fc1e97a0 < 0.75)
	{
		self.var_9543b4d3 = var_9f8b46b0 - var_fc1e97a0 * var_f3370df8;
	}
	else
	{
		self.var_9543b4d3 = var_d03250e;
	}
}

/*
	Name: function_be54bf9f
	Namespace: zm_island_skullquest
	Checksum: 0x718CAADE
	Offset: 0x36F0
	Size: 0x12F
	Parameters: 0
	Flags: None
*/
function function_be54bf9f()
{
	var_8e94b38a = self.var_2f6a00a / 10;
	if(var_8e94b38a > 1)
	{
		var_8e94b38a = 1;
	}
	if(var_8e94b38a < 0.25)
	{
		var_ced215df = 1;
	}
	else if(var_8e94b38a >= 0.25 && var_8e94b38a < 0.5)
	{
		var_ced215df = 2;
	}
	else if(var_8e94b38a >= 0.5 && var_8e94b38a < 0.75)
	{
		var_ced215df = 3;
	}
	else if(var_8e94b38a >= 0.75)
	{
		var_ced215df = 4;
	}
	level clientfield::set(self.var_ba133ee2, var_ced215df);
	if(self.var_ced215df !== var_ced215df)
	{
		self.mdl_skull_s thread function_85a2a491();
		self.var_ced215df = var_ced215df;
	}
}

/*
	Name: function_85a2a491
	Namespace: zm_island_skullquest
	Checksum: 0x5C23471A
	Offset: 0x3828
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function function_85a2a491()
{
	mdl_temp = util::spawn_model("tag_origin", self.origin, self.angles);
	mdl_temp clientfield::set("skullquest_finish_start_fx", 1);
	wait(0.5);
	mdl_temp clientfield::set("skullquest_finish_start_fx", 0);
	mdl_temp delete();
}

/*
	Name: function_c3360ba8
	Namespace: zm_island_skullquest
	Checksum: 0xE3E32D8C
	Offset: 0x38D0
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function function_c3360ba8(n_step_time)
{
	if(!isdefined(n_step_time))
	{
		n_step_time = 0.1;
	}
	self endon("hash_52ad0df5");
	var_da791f1d = 30 / n_step_time;
	n_steps = 0;
	while(1)
	{
		var_a747f278 = n_steps / var_da791f1d;
		var_9bcf211d = 1 - var_a747f278;
		self.mdl_skull_s clientfield::set("do_fade_material_direct", var_9bcf211d);
		self.mdl_skulltar clientfield::set("do_emissive_material_direct", var_a747f278);
		wait(n_step_time);
		n_steps++;
	}
}

/*
	Name: function_186d9bd6
	Namespace: zm_island_skullquest
	Checksum: 0x25711656
	Offset: 0x39D0
	Size: 0x2C7
	Parameters: 0
	Flags: None
*/
function function_186d9bd6()
{
	zm_spawner::deregister_zombie_death_event_callback(&function_3aa06eec);
	callback::remove_on_vehicle_killed(&function_5681b8d3);
	self notify("hash_52ad0df5");
	level flag::clear("skullquest_ritual_inprogress" + self.script_special);
	level notify("skullquest_ritual_ended" + self.script_special);
	self.mdl_skulltar thread scene::stop("p7_fxanim_zm_island_pedestal_skull_rise_bundle");
	self.mdl_skull_s Unlink();
	foreach(s_skulltar_attack_pos in self.a_s_skulltar_attack_pos)
	{
		s_skulltar_attack_pos.e_occupier = undefined;
	}
	if(self.n_progress >= self.n_goal)
	{
		self thread function_2b848418();
		b_success = 1;
	}
	else if(self.var_f9d4e953 >= 5 && self.n_progress >= 0)
	{
		self thread function_743b2f2f(0);
		b_success = 0;
	}
	else
	{
		self thread function_743b2f2f(1);
		b_success = 0;
	}
	a_ai_enemies = GetAITeamArray("axis");
	if(a_ai_enemies.size > 0)
	{
		for(i = 0; i < a_ai_enemies.size; i++)
		{
			if(isalive(a_ai_enemies[i]) && a_ai_enemies[i].var_ecc789a5 === self.script_special)
			{
				a_ai_enemies[i] thread function_c7a0c111(b_success);
			}
		}
	}
	level.zombie_ai_limit = level.zombie_ai_limit + self.var_eca4fee1;
}

/*
	Name: function_c7a0c111
	Namespace: zm_island_skullquest
	Checksum: 0x1A943C6B
	Offset: 0x3CA0
	Size: 0x2AB
	Parameters: 2
	Flags: None
*/
function function_c7a0c111(b_success, var_bf49654c)
{
	if(!isdefined(b_success))
	{
		b_success = 1;
	}
	if(!isdefined(var_bf49654c))
	{
		var_bf49654c = 1;
	}
	self endon("death");
	self notify("hash_eb13d3a5");
	if(!(isdefined(self.var_3f6ea790) && self.var_3f6ea790))
	{
		self SetGoal(self.origin);
		if(isdefined(var_bf49654c) && var_bf49654c)
		{
			wait(RandomFloatRange(0.05, 0.25));
		}
		if(isdefined(b_success) && b_success)
		{
			if(self.archetype === "zombie")
			{
				self thread zombie_utility::zombie_eye_glow_stop();
				self clientfield::set("death_ray_shock_eye_fx", 1);
				self thread scene::Play("cin_zm_dlc1_zombie_dth_deathray_04", self);
				wait(0.75);
				self clientfield::set("death_ray_shock_eye_fx", 0);
				self zombie_utility::zombie_head_gib(self);
			}
			if(self.archetype !== "spider")
			{
				util::wait_network_frame();
				self thread zombie_utility::zombie_gut_explosion();
			}
			if(isdefined(level.bzm_worldPaused) && level.bzm_worldPaused && self.archetype === "spider")
			{
				var_601391ec = namespace_8aed53c9::function_4bf4ac40(self.origin);
				self DoDamage(self.health, self.origin, var_601391ec);
				self thread FX::Play("spider_gib", self.origin, self.angles, undefined, 0, undefined, 1, 1);
				self ghost();
			}
		}
		self DoDamage(self.health * 2, self.origin);
	}
}

/*
	Name: function_44181b60
	Namespace: zm_island_skullquest
	Checksum: 0x31C86B49
	Offset: 0x3F58
	Size: 0xA9
	Parameters: 0
	Flags: None
*/
function function_44181b60()
{
	b_is_defended = 0;
	foreach(zone in self.var_aa15c945)
	{
		b_is_defended = b_is_defended || zm_zonemgr::any_player_in_zone(zone);
	}
	return b_is_defended;
}

/*
	Name: function_3654cf4c
	Namespace: zm_island_skullquest
	Checksum: 0x5B1FCD32
	Offset: 0x4010
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function function_3654cf4c(n_amount, var_f8ad0afc)
{
	if(!isdefined(n_amount))
	{
		n_amount = 10;
	}
	if(isdefined(var_f8ad0afc))
	{
		v_src = var_f8ad0afc + VectorScale((0, 0, 1), 32);
		v_dest = self.mdl_skulltar.origin + VectorScale((0, 0, 1), 16);
		function_a050863e(v_src, v_dest);
	}
	self.n_progress = self.n_progress + n_amount;
	if(self.n_progress > self.n_goal)
	{
		self.n_progress = self.n_goal;
	}
}

/*
	Name: function_82fc8508
	Namespace: zm_island_skullquest
	Checksum: 0x417D0AC
	Offset: 0x40F0
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_82fc8508(n_penalty)
{
	if(!isdefined(n_penalty))
	{
		n_penalty = -1 * self.n_progress / 4;
		if(n_penalty <= 10)
		{
			n_penalty = -100;
		}
	}
	self thread function_3654cf4c(n_penalty);
}

/*
	Name: function_f20126b2
	Namespace: zm_island_skullquest
	Checksum: 0xFE1BCFBF
	Offset: 0x4160
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_f20126b2()
{
	self.var_2f6a00a++;
	self thread function_be54bf9f();
	if(self.var_2f6a00a >= 10)
	{
		self thread function_186d9bd6();
	}
}

/*
	Name: function_a050863e
	Namespace: zm_island_skullquest
	Checksum: 0x1156EC7C
	Offset: 0x41B8
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function function_a050863e(v_src, v_dest)
{
	if(isdefined(v_src) && isdefined(v_dest))
	{
		mdl_flare = spawn("script_model", v_src);
		mdl_flare SetModel("p7_sky_vista_light_flare_blue");
		mdl_flare playsound("zmb_skull_soul_feed");
		mdl_flare moveto(v_dest, 0.5);
		mdl_flare waittill("movedone");
		mdl_flare delete();
	}
}

/*
	Name: function_2b848418
	Namespace: zm_island_skullquest
	Checksum: 0xF807A937
	Offset: 0x4298
	Size: 0x183
	Parameters: 0
	Flags: None
*/
function function_2b848418()
{
	level clientfield::set(self.var_ba133ee2, 5);
	self.mdl_skulltar clientfield::set("do_emissive_material", 1);
	level notify("skullquest_ritual_complete" + self.script_special);
	level flag::set("skullquest_ritual_complete" + self.script_special);
	self.var_6f46f579 = 0;
	level.var_3846d9a8++;
	foreach(player in level.activePlayers)
	{
		if(zombie_utility::is_player_valid(player))
		{
			player zm_score::add_to_player_score(500);
		}
	}
	self function_279e8476("fall");
	function_fae0aa01(self.script_special, "postritual");
}

/*
	Name: function_743b2f2f
	Namespace: zm_island_skullquest
	Checksum: 0x92E9751
	Offset: 0x4428
	Size: 0x203
	Parameters: 1
	Flags: None
*/
function function_743b2f2f(var_6763afa8)
{
	str_notify = "skullquest_ritual_failed_" + self.script_special;
	level notify(str_notify);
	self.mdl_skull_s clientfield::set("do_fade_material", 1);
	self.mdl_skulltar clientfield::set("do_emissive_material", 0);
	level clientfield::set(self.var_ba133ee2, 6);
	fail_sound = spawn("script_origin", self.origin);
	fail_sound playsound("zmb_skull_ritual_fail");
	if(isdefined(self.var_226d2560))
	{
		self.var_226d2560 delete();
	}
	self thread function_7fe36843();
	var_70181bbb = -1.1 * Abs(self.n_progress);
	self thread function_3654cf4c(var_70181bbb);
	self.var_6f46f579 = 0;
	wait(0.1);
	switch(var_6763afa8)
	{
		case 0:
		{
			self notify("skullquest_ritual_abandoned" + self.script_special);
			break;
		}
		case 1:
		{
			break;
		}
	}
	wait(2);
	fail_sound delete();
	level thread function_fae0aa01(self.script_special, "pre_retry");
}

/*
	Name: function_7fe36843
	Namespace: zm_island_skullquest
	Checksum: 0x4D8051FF
	Offset: 0x4638
	Size: 0x10B
	Parameters: 1
	Flags: None
*/
function function_7fe36843(var_a9df1394)
{
	if(!isdefined(var_a9df1394))
	{
		var_a9df1394 = 1;
	}
	self.mdl_skulltar scene::stop("p7_fxanim_zm_island_pedestal_skull_rise_bundle");
	self.mdl_skull_s Unlink();
	self.mdl_skull_s ghost();
	mdl_temp = util::spawn_model("tag_origin", self.origin, self.angles);
	mdl_temp clientfield::set("skullquest_finish_start_fx", 1);
	wait(var_a9df1394);
	mdl_temp clientfield::set("skullquest_finish_start_fx", 0);
	mdl_temp delete();
}

/*
	Name: function_ff1550bd
	Namespace: zm_island_skullquest
	Checksum: 0x7D0FFF92
	Offset: 0x4750
	Size: 0xBDB
	Parameters: 0
	Flags: None
*/
function function_ff1550bd()
{
	self endon("skullquest_ritual_abandoned" + self.script_special);
	level endon("skullquest_ritual_ended" + self.script_special);
	n_ritual = self.script_special;
	self.var_bd61ef5b = 0;
	self.var_d38f69da = [];
	self.var_41335b73 = [];
	var_19b19369 = "skull" + n_ritual + "_attacker";
	a_spawners = [];
	var_89f44116 = level.zombie_spawners;
	var_64cc2fa5 = level.thrasher_spawners;
	var_6469b451 = level.spider_spawners;
	if(level.var_4ffafd2 > 0)
	{
		var_90d3df61 = level.var_4ffafd2;
		break;
	}
	var_90d3df61 = 0;
	for(i = 1; i <= 4; i++)
	{
		if(level flag::get("skullquest_ritual_complete" + i) || level flag::get("skullquest_ritual_inprogress" + i))
		{
			var_90d3df61++;
		}
	}
	var_63ba0b02 = 0;
	switch(var_90d3df61)
	{
		case 1:
		{
			a_spawners = var_89f44116;
			var_63ba0b02 = 1;
			var_8f4e08a8 = Array(0, 3, 4, 5, 6);
			var_419b220b = Array(0, 3, 4, 5, 6);
			self.var_9543b4d3 = 2;
			self.var_7905a128 = 0;
			break;
		}
		case 2:
		{
			a_spawners = Array(var_6469b451[0], var_6469b451[0], var_6469b451[0], var_6469b451[0]);
			var_8f4e08a8 = Array(0, 6, 7, 8, 9);
			var_419b220b = Array(0, 4, 5, 6, 7);
			self.var_9543b4d3 = 2;
			self.var_7905a128 = 0;
			break;
		}
		case 3:
		{
			a_spawners = Array(var_64cc2fa5[0], var_64cc2fa5[0], var_64cc2fa5[0], var_64cc2fa5[0]);
			var_8f4e08a8 = Array(0, 6, 7, 8, 9);
			var_419b220b = Array(0, 4, 5, 6, 7);
			self.var_9543b4d3 = 2;
			self.var_7905a128 = 1;
			break;
		}
		case 4:
		{
			a_spawners = Array(var_6469b451[0], var_6469b451[0], var_6469b451[0], var_64cc2fa5[0]);
			var_8f4e08a8 = Array(0, 6, 7, 8, 9);
			var_419b220b = Array(0, 4, 5, 6, 7);
			self.var_9543b4d3 = 2;
			self.var_7905a128 = 0;
			break;
		}
	}
	var_eca4fee1 = var_8f4e08a8[level.activePlayers.size];
	var_3be27b2b = var_419b220b[level.activePlayers.size];
	self.var_eca4fee1 = var_eca4fee1;
	level.zombie_ai_limit = level.zombie_ai_limit - self.var_eca4fee1;
	var_d94cc36a = Array(0, 1, 1, 1, 1);
	var_44da5f74 = var_d94cc36a[level.activePlayers.size];
	self.a_s_spawnpts = Array::randomize(self.a_s_spawnpts);
	self.var_d8cdf3a = 1;
	while(!level flag::get("skullquest_ritual_complete" + self.script_special))
	{
		for(i = 0; i < self.a_s_spawnpts.size; i++)
		{
			level.a_skullquests[n_ritual].var_41335b73 = Array::remove_undefined(level.a_skullquests[n_ritual].var_41335b73);
			level.a_skullquests[n_ritual].var_d38f69da = Array::remove_undefined(level.a_skullquests[n_ritual].var_d38f69da);
			while(GetFreeActorCount() < 1)
			{
				wait(0.05);
			}
			while(level.a_skullquests[n_ritual].var_d38f69da.size >= var_eca4fee1)
			{
				wait(0.05);
			}
			if(isdefined(self.var_7905a128 == 1) && self.var_7905a128 == 1 && self.var_bd61ef5b == 0)
			{
				e_spawner = var_64cc2fa5[0];
			}
			else if(isdefined(self.var_d8cdf3a) && self.var_d8cdf3a || level.a_skullquests[n_ritual].var_41335b73.size < 2)
			{
				e_spawner = var_89f44116[0];
			}
			else
			{
				e_spawner = Array::random(a_spawners);
			}
			self.var_d8cdf3a = !self.var_d8cdf3a;
			ai_attacker = undefined;
			self.a_s_spawnpts[i].script_string = "";
			if(isdefined(e_spawner) && isdefined(e_spawner.script_noteworthy))
			{
				switch(e_spawner.script_noteworthy)
				{
					case "zombie_spawner":
					{
						if(level.a_skullquests[n_ritual].var_41335b73.size < var_3be27b2b)
						{
							self.a_s_spawnpts[i].script_string = "find_flesh";
							self.a_s_spawnpts[i].script_noteworthy = "spawn_location";
							ai_attacker = zombie_utility::spawn_zombie(e_spawner, var_19b19369, self.a_s_spawnpts[i]);
							/#
								if(isdefined(level.var_32d5991a) && level.var_32d5991a)
								{
									IPrintLnBold("Dev Block strings are not supported" + i + "Dev Block strings are not supported" + self.a_s_spawnpts[i].origin);
								}
							#/
						}
						break;
					}
					case "zombie_thrasher_spawner":
					{
						if(level.a_skullquests[n_ritual].var_bd61ef5b < var_44da5f74)
						{
							self.a_s_spawnpts[i].script_noteworthy = "thrasher_location";
							ai_attacker = zombie_utility::spawn_zombie(e_spawner, var_19b19369);
						}
						break;
					}
					case "zombie_spider_spawner":
					{
						self.a_s_spawnpts[i].script_noteworthy = "spider_location";
						ai_attacker = zombie_utility::spawn_zombie(e_spawner, var_19b19369, self.a_s_spawnpts[i]);
						break;
					}
				}
				wait(0.1);
			}
			if(isalive(ai_attacker))
			{
				ai_attacker.var_ecc789a5 = n_ritual;
				Array::add(level.a_skullquests[n_ritual].var_d38f69da, ai_attacker);
				ai_attacker.ignore_enemy_count = 1;
				ai_attacker.no_damage_points = 1;
				ai_attacker.deathpoints_already_given = 1;
				switch(e_spawner.script_noteworthy)
				{
					case "zombie_spawner":
					{
						ai_attacker ForceTeleport(self.a_s_spawnpts[i].origin, self.a_s_spawnpts[i].angles);
						if(ai_attacker.health > 1263)
						{
							ai_attacker.maxhealth = 1263;
							ai_attacker.health = 1263;
						}
						ai_attacker thread function_bd5d2a96(self);
						break;
					}
					case "zombie_thrasher_spawner":
					{
						ai_attacker zm_ai_thrasher::thrasher_teleport(self.a_s_spawnpts[i].origin);
						self.var_bd61ef5b++;
						ai_attacker clientfield::set("ritual_attacker_fx", 1);
						ai_attacker.var_75729ddd = 1;
						break;
					}
					case "zombie_spider_spawner":
					{
						ai_attacker.favoriteenemy = zm_ai_spiders::get_favorite_enemy();
						self.a_s_spawnpts[i] thread zm_ai_spiders::spider_spawn_fx(ai_attacker, self.a_s_spawnpts[i]);
						break;
					}
				}
				ai_attacker thread function_c46730e7(self.script_special);
				ai_attacker thread namespace_8aed53c9::zombie_no_powerups();
				wait(self.var_9543b4d3);
			}
			level.zombie_ai_limit = level.zombie_ai_limit + self.var_eca4fee1;
			var_eca4fee1 = var_8f4e08a8[level.activePlayers.size];
			self.var_eca4fee1 = var_eca4fee1;
			level.zombie_ai_limit = level.zombie_ai_limit - self.var_eca4fee1;
		}
		wait(self.var_9543b4d3);
	}
}

/*
	Name: function_c46730e7
	Namespace: zm_island_skullquest
	Checksum: 0x8EB8C0E0
	Offset: 0x5338
	Size: 0x113
	Parameters: 1
	Flags: None
*/
function function_c46730e7(n_ritual)
{
	self endon("death");
	wait(5);
	if(!self function_b948e12a(n_ritual))
	{
		/#
			if(isdefined(level.var_32d5991a) && level.var_32d5991a)
			{
				IPrintLnBold("Dev Block strings are not supported" + self.origin + "Dev Block strings are not supported");
			}
		#/
		ArrayRemoveValue(level.a_skullquests[n_ritual].var_d38f69da, self);
		ArrayRemoveValue(level.a_skullquests[n_ritual].var_41335b73, self);
		util::stop_magic_bullet_shield(self);
		if(isalive(self))
		{
			self kill();
		}
	}
}

/*
	Name: function_b948e12a
	Namespace: zm_island_skullquest
	Checksum: 0xB38E778C
	Offset: 0x5458
	Size: 0xC1
	Parameters: 1
	Flags: None
*/
function function_b948e12a(n_ritual)
{
	b_in_zone = 0;
	foreach(zone in level.a_skullquests[n_ritual].var_aa15c945)
	{
		b_in_zone = b_in_zone || self zm_zonemgr::entity_in_zone(zone);
	}
	return b_in_zone;
}

/*
	Name: function_bd5d2a96
	Namespace: zm_island_skullquest
	Checksum: 0x8401F053
	Offset: 0x5528
	Size: 0x1E3
	Parameters: 1
	Flags: None
*/
function function_bd5d2a96(s_ritual)
{
	self endon("death");
	if(isalive(self))
	{
		self DisableAimAssist();
		Array::add(s_ritual.var_41335b73, self);
		self.var_8853cc2a = 1;
		self.noCrawler = 1;
		self ghost();
		self clientfield::set("ritual_attacker_fx", 1);
		self.var_75729ddd = 1;
		self SetGoal(self.origin);
		mdl_align = util::spawn_model("tag_origin", self.origin, self.angles);
		mdl_align thread scene::Play("scene_zm_dlc2_zombie_quick_rise_v2", self);
		self playsound("zmb_skull_ritual_portal_zombie");
		wait(0.05);
		if(isalive(self))
		{
			self show();
			mdl_align waittill("scene_done");
			self thread function_1cbe53ee(s_ritual);
			self EnableAimAssist();
		}
		if(isdefined(mdl_align))
		{
			mdl_align delete();
		}
	}
}

/*
	Name: function_1c624caf
	Namespace: zm_island_skullquest
	Checksum: 0xFDDF7360
	Offset: 0x5718
	Size: 0x2B
	Parameters: 2
	Flags: None
*/
function function_1c624caf(a_ents, e_align)
{
	self zm_utility::self_delete();
}

/*
	Name: function_1cbe53ee
	Namespace: zm_island_skullquest
	Checksum: 0xE66502AB
	Offset: 0x5750
	Size: 0x2A9
	Parameters: 1
	Flags: None
*/
function function_1cbe53ee(var_5e9499e0)
{
	self endon("death");
	self endon("hash_aedf5455");
	self endon("hash_eb13d3a5");
	self zombie_utility::set_zombie_run_cycle("walk");
	self notify("stop_find_flesh");
	self notify("zombie_acquire_enemy");
	self ai::set_ignoreall(1);
	while(Distance(self.origin, var_5e9499e0.s_skulltar_skull_pos.origin) > 32 && (!isdefined(self.aat_turned) && self.aat_turned))
	{
		var_b6bec422 = undefined;
		var_4800ca35 = ArrayCopy(var_5e9499e0.a_s_skulltar_attack_pos);
		var_8432e700 = ArrayGetClosest(self.origin, var_4800ca35);
		while(!isdefined(var_b6bec422) && var_4800ca35.size > 0)
		{
			ArrayRemoveValue(var_4800ca35, var_8432e700);
			if(!isdefined(var_8432e700.e_occupier) || var_8432e700.e_occupier === self)
			{
				var_b6bec422 = GetClosestPointOnNavMesh(var_8432e700.origin, 32);
			}
			if(!isdefined(var_b6bec422))
			{
				var_8432e700 = Array::random(var_4800ca35);
			}
		}
		if(!isdefined(var_b6bec422))
		{
			var_b6bec422 = GetClosestPointOnNavMesh(var_5e9499e0.s_skulltar_base_pos.origin, 48);
			var_8432e700 = undefined;
		}
		self SetGoal(var_b6bec422, 1);
		if(isdefined(var_8432e700))
		{
			self.s_goal = var_8432e700;
			self.s_goal.e_occupier = self;
		}
		self LookAtEntity(var_5e9499e0.mdl_skull_s);
		self waittill("goal");
		wait(1);
	}
}

/*
	Name: function_5681b8d3
	Namespace: zm_island_skullquest
	Checksum: 0x813EBD99
	Offset: 0x5A08
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_5681b8d3(params)
{
	self thread function_3aa06eec(params.eAttacker);
}

/*
	Name: function_3aa06eec
	Namespace: zm_island_skullquest
	Checksum: 0xB6BA1A6A
	Offset: 0x5A40
	Size: 0x149
	Parameters: 1
	Flags: None
*/
function function_3aa06eec(e_attacker)
{
	if(isdefined(self) && isdefined(self.var_ecc789a5) && IsInArray(level.a_skullquests[self.var_ecc789a5].var_d38f69da, self))
	{
		ArrayRemoveValue(level.a_skullquests[self.var_ecc789a5].var_d38f69da, self);
		if(self.script_noteworthy === "zombie_thrasher_spawner")
		{
			level.a_skullquests[self.var_ecc789a5].var_bd61ef5b--;
		}
		if(isdefined(self.var_75729ddd))
		{
			self clientfield::set("keeper_fx", 0);
		}
		if(isdefined(self.var_8853cc2a) && self.var_8853cc2a)
		{
			ArrayRemoveValue(level.a_skullquests[self.var_ecc789a5].var_41335b73, self);
			if(isdefined(self.s_goal) && isdefined(self.s_goal.e_occupier))
			{
				self.s_goal.e_occupier = undefined;
			}
		}
	}
}

/*
	Name: function_25b82d3f
	Namespace: zm_island_skullquest
	Checksum: 0xD7905BF2
	Offset: 0x5B98
	Size: 0x16F
	Parameters: 0
	Flags: None
*/
function function_25b82d3f()
{
	self waittill("death");
	if(isdefined(self) && isdefined(self.var_ecc789a5) && IsInArray(level.a_skullquests[self.var_ecc789a5].var_d38f69da, self))
	{
		ArrayRemoveValue(level.a_skullquests[self.var_ecc789a5].var_d38f69da, self);
		if(self.script_noteworthy === "zombie_thrasher_spawner")
		{
			level.a_skullquests[self.var_ecc789a5].var_bd61ef5b--;
		}
		if(isdefined(self.var_75729ddd))
		{
			self clientfield::set("keeper_fx", 0);
		}
		if(isdefined(self.var_8853cc2a) && self.var_8853cc2a)
		{
			ArrayRemoveValue(level.a_skullquests[self.var_ecc789a5].var_41335b73, self);
			level.a_skullquests[self.var_ecc789a5].var_41335b73 = Array::remove_dead(level.a_skullquests[self.var_ecc789a5].var_41335b73);
		}
	}
}

/*
	Name: function_f94079c3
	Namespace: zm_island_skullquest
	Checksum: 0x87AA30FF
	Offset: 0x5D10
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function function_f94079c3(n_skull)
{
	switch(self.archetype)
	{
		case "zombie":
		{
			n_value = 50;
			break;
		}
		case "thrasher":
		{
			n_value = 70;
			break;
		}
		case "spider":
		{
			n_value = 50;
			break;
		}
		case default:
		{
			n_value = 50;
			break;
		}
	}
	level.a_skullquests[n_skull] thread function_3654cf4c(n_value, self.origin);
}

/*
	Name: function_3fe31e5b
	Namespace: zm_island_skullquest
	Checksum: 0xEF808FB
	Offset: 0x5DC8
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function function_3fe31e5b(n_ritual, var_9fe01ec5)
{
	if(!isdefined(var_9fe01ec5))
	{
		var_9fe01ec5 = 0;
	}
	var_f8a0e213 = level.a_skullquests[n_ritual].mdl_skull_s.var_afb64bf6;
	if(zombie_utility::is_player_valid(var_f8a0e213))
	{
		var_f8a0e213.var_d64275e8 = 0;
	}
	level.a_skullquests[n_ritual].mdl_skull_s.var_afb64bf6 = undefined;
	function_880d3333(n_ritual);
	function_fae0aa01(n_ritual, "start");
}

/*
	Name: function_eba0c996
	Namespace: zm_island_skullquest
	Checksum: 0x3251651A
	Offset: 0x5EA8
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function function_eba0c996(n_ritual)
{
	var_f8a0e213 = level.a_skullquests[n_ritual].mdl_skull_p.var_afb64bf6;
	if(isdefined(var_f8a0e213))
	{
		var_f8a0e213.var_4849e523 = 0;
	}
	level.a_skullquests[n_ritual].mdl_skull_p.var_afb64bf6 = undefined;
	function_fae0aa01(n_ritual, "postritual");
}

/*
	Name: function_fdafeea2
	Namespace: zm_island_skullquest
	Checksum: 0x4D2BFAA7
	Offset: 0x5F40
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function function_fdafeea2(var_48d11f40)
{
	if(!(isdefined(level.var_d19220ee) && level.var_d19220ee))
	{
		level.var_d19220ee = 1;
		level.var_9964c1b2 = struct::get("s_ut_skullroom", "targetname");
		level thread function_f20b6331();
		skullroom_init();
		if(zm_utility::is_player_valid(var_48d11f40))
		{
			var_48d11f40 thread zm_island_vo::function_5dbba1d3();
		}
	}
}

/*
	Name: function_f20b6331
	Namespace: zm_island_skullquest
	Checksum: 0x10DE97B6
	Offset: 0x6000
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function function_f20b6331()
{
	level thread exploder::exploder("fxexp_500");
	level thread scene::Play("p7_fxanim_zm_island_alter_stairs_bundle");
	if(isdefined(level.var_e534ade))
	{
		foreach(e_piece in level.var_e534ade)
		{
			e_piece delete();
		}
	}
	function_e20f6c97(0);
	level flag::set("connect_ruins_to_ruins_underground");
}

/*
	Name: function_9839b367
	Namespace: zm_island_skullquest
	Checksum: 0xF02885A4
	Offset: 0x6118
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_9839b367()
{
	level.var_9046e7b0 playsound("zmb_skull_door_close");
	level.var_9046e7b0 moveto(level.var_9046e7b0.var_9c93e17, 3);
	exploder::exploder("fxexp_501");
}

/*
	Name: function_e20f6c97
	Namespace: zm_island_skullquest
	Checksum: 0x72FAE60C
	Offset: 0x6190
	Size: 0x13F
	Parameters: 1
	Flags: None
*/
function function_e20f6c97(b_on)
{
	if(!isdefined(b_on))
	{
		b_on = 1;
	}
	mdl_skullroom_seal = GetEnt("mdl_skullroom_seal", "targetname");
	if(isdefined(b_on) && b_on)
	{
		mdl_skullroom_seal show();
		mdl_skullroom_seal solid();
		exploder::exploder("fxexp_501");
		mdl_skullroom_seal disconnectpaths();
		level.var_a5db31a9 = 1;
	}
	else
	{
		mdl_skullroom_seal ghost();
		mdl_skullroom_seal notsolid();
		exploder::stop_exploder("fxexp_501");
		mdl_skullroom_seal connectpaths();
		level.var_a5db31a9 = 0;
	}
}

/*
	Name: skullroom_init
	Namespace: zm_island_skullquest
	Checksum: 0x8E99EA98
	Offset: 0x62D8
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function skullroom_init()
{
	if(!level flag::exists("skullroom_defend_inprogress"))
	{
		level flag::init("skullroom_defend_inprogress");
	}
	if(isdefined(level.var_55c48492))
	{
		level.var_55c48492 show();
	}
	if(isdefined(level.var_b2152df5))
	{
		level.var_b2152df5 setup_unitrigger("unitrigger_radius_use", &function_d3554921, &s_utrig_get_skullgun_think);
	}
}

/*
	Name: function_d3554921
	Namespace: zm_island_skullquest
	Checksum: 0xBC8D23F8
	Offset: 0x63A0
	Size: 0xE9
	Parameters: 1
	Flags: None
*/
function function_d3554921(player)
{
	if(isdefined(level.var_b10ab148) && level.var_b10ab148 && player bgb::is_enabled("zm_bgb_disorderly_combat"))
	{
		self setHintString("");
		return 0;
	}
	if(level flag::get("skullroom_defend_inprogress") || player HasWeapon(level.var_c003f5b, 1))
	{
		self setHintString("");
		return 0;
	}
	else
	{
		self setHintString(&"ZM_ISLAND_SKULLQUEST_GET_SKULLGUN");
		return 1;
	}
}

/*
	Name: s_utrig_get_skullgun_think
	Namespace: zm_island_skullquest
	Checksum: 0x8548EB4B
	Offset: 0x6498
	Size: 0x17D
	Parameters: 0
	Flags: None
*/
function s_utrig_get_skullgun_think()
{
	while(1)
	{
		self waittill("trigger", ent);
		if(ent function_9e2f0e52() && !level flag::get("skullroom_defend_inprogress"))
		{
			if(isdefined(level.var_b10ab148) && level.var_b10ab148 && !ent HasWeapon(level.var_c003f5b, 1))
			{
				ent thread function_458f50f2();
				if(!(isdefined(level.var_e2f72654) && level.var_e2f72654))
				{
					level.var_e2f72654 = 1;
					ent thread zm_island_vo::function_b2a7853b();
				}
			}
			else if(!ent HasWeapon(level.var_c003f5b, 1))
			{
				level thread function_b10feb68();
				self playsound("zmb_skulltar_place");
				if(!(isdefined(level.var_d299e345) && level.var_d299e345))
				{
					ent thread zm_island_vo::function_ab027b72();
				}
			}
		}
		wait(1);
	}
}

/*
	Name: function_b10feb68
	Namespace: zm_island_skullquest
	Checksum: 0x8CD34D94
	Offset: 0x6620
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function function_b10feb68()
{
	if(!level flag::get("skullroom_defend_inprogress"))
	{
		level flag::set("skullroom_defend_inprogress");
		level.var_55c48492 PlayLoopSound("mus_island_skullbattle", 2);
		level thread function_e20f6c97(1);
		level thread function_ef5b1df5();
		level flag::wait_till_clear("skullroom_defend_inprogress");
		level.var_55c48492 StopLoopSound(2);
		if(isdefined(level.var_b10ab148) && level.var_b10ab148)
		{
			level util::waittill_any_timeout(10, "a_player_got_skullgun");
		}
		level thread function_e20f6c97(0);
		exploder::exploder("fxexp_502");
	}
}

/*
	Name: function_ef5b1df5
	Namespace: zm_island_skullquest
	Checksum: 0x18769216
	Offset: 0x6778
	Size: 0x777
	Parameters: 0
	Flags: None
*/
function function_ef5b1df5()
{
	var_8ac892bf = Array(0, 3, 5, 7, 8);
	var_59d27c2f = Array(0, 20, 29, 38, 47);
	level.var_d15b7db3 = var_8ac892bf[level.players.size];
	level.var_49c6fb1c = var_59d27c2f[level.players.size];
	level.zombie_ai_limit = level.zombie_ai_limit - level.var_d15b7db3;
	level flag::clear("spawn_zombies");
	level.disable_nuke_delay_spawning = 1;
	level.var_92914699 = 0;
	level.var_9bc0cd6e = 0;
	var_bc3b3f4c = GetEnt("skullroom_keeper_spawner", "targetname");
	level.var_55c48492 clientfield::set("skullquest_finish_start_fx", 1);
	level.var_55c48492 clientfield::set("skullquest_finish_trail_fx", 1);
	level thread function_41b94a87();
	wait(0.25);
	level clientfield::set("keeper_spawn_portals", 1);
	wait(2.5);
	a_spawn_points = struct::get_array("s_spawnpt_skullroom");
	level flag::clear("skullroom_empty_of_players");
	a_ai_keepers = [];
	level thread function_d91adba6();
	a_spawn_points = Array::randomize(a_spawn_points);
	while(level.var_9bc0cd6e < level.var_49c6fb1c && !level flag::get("skullroom_empty_of_players") && (!isdefined(level.var_d9d19dae) && level.var_d9d19dae))
	{
		foreach(s_spawn_point in a_spawn_points)
		{
			while(GetFreeActorCount() < 1 && !level flag::get("skullroom_empty_of_players") && (!isdefined(level.var_d9d19dae) && level.var_d9d19dae))
			{
				wait(0.05);
			}
			while(level.var_92914699 >= level.var_d15b7db3 && !level flag::get("skullroom_empty_of_players") && (!isdefined(level.var_d9d19dae) && level.var_d9d19dae))
			{
				wait(0.05);
			}
			if(level.var_9bc0cd6e >= level.var_49c6fb1c || level flag::get("skullroom_empty_of_players") || (isdefined(level.var_d9d19dae) && level.var_d9d19dae))
			{
				break;
			}
			s_spawn_point.script_string = "find_flesh";
			ai = zombie_utility::spawn_zombie(var_bc3b3f4c, "skullroom_keeper_zombie", s_spawn_point);
			if(isdefined(ai))
			{
				level.var_92914699++;
				ai.var_2f846873 = 1;
				ai.targetname = "skullroom_keeper_zombie";
				ai thread function_2d0c5aa1(s_spawn_point);
				level thread function_efbd4abf(ai, s_spawn_point);
				ai.custom_location = &function_b820cada;
				Array::add(a_ai_keepers, ai);
			}
			wait(1);
		}
	}
	level flag::clear("skullroom_defend_inprogress");
	level clientfield::set("keeper_spawn_portals", 0);
	level.var_55c48492 clientfield::set("skullquest_finish_start_fx", 0);
	level.var_55c48492 clientfield::set("skullquest_finish_trail_fx", 0);
	level.var_b10ab148 = level.var_9bc0cd6e >= level.var_49c6fb1c;
	level flag::set("skull_quest_complete");
	if(isdefined(level.var_b10ab148) && level.var_b10ab148)
	{
		var_363b7d39 = GetEnt("volume_thrasher_non_teleport_ruins_underground", "targetname");
		var_363b7d39 delete();
		level.var_55c48492 thread function_85a2a491();
	}
	a_ai_keepers = Array::remove_dead(a_ai_keepers, 0);
	foreach(straggler in a_ai_keepers)
	{
		if(isalive(straggler))
		{
			straggler kill();
		}
	}
	level.var_55c48492 playsound("evt_keeper_quest_done");
	wait(1.5);
	level.var_55c48492 moveto(level.var_55c48492.var_5cd7e450, 0.5);
	level.zombie_ai_limit = level.zombie_ai_limit + level.var_d15b7db3;
	level flag::set("spawn_zombies");
	level.disable_nuke_delay_spawning = 0;
}

/*
	Name: function_d91adba6
	Namespace: zm_island_skullquest
	Checksum: 0xD8B4CFF0
	Offset: 0x6EF8
	Size: 0x1E5
	Parameters: 0
	Flags: None
*/
function function_d91adba6()
{
	t_inside_skullroom = GetEnt("t_inside_skullroom", "targetname");
	level.var_d9d19dae = 0;
	while(level flag::get("skullroom_defend_inprogress"))
	{
		var_f66cf9d4 = [];
		foreach(player in level.activePlayers)
		{
			if(player zm_zonemgr::entity_in_zone("zone_ruins_underground", 1))
			{
				Array::add(var_f66cf9d4, player);
			}
		}
		var_c277590a = 0;
		foreach(player in var_f66cf9d4)
		{
			if(player laststand::player_is_in_laststand())
			{
				var_c277590a++;
			}
		}
		if(var_c277590a === var_f66cf9d4.size)
		{
			level.var_d9d19dae = 1;
			break;
		}
		wait(1);
	}
}

/*
	Name: function_41b94a87
	Namespace: zm_island_skullquest
	Checksum: 0xCFE812B4
	Offset: 0x70E8
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function function_41b94a87()
{
	var_e312b793 = level.var_9bc0cd6e / level.var_49c6fb1c;
	if(var_e312b793 > 1)
	{
		var_e312b793 = 1;
	}
	var_3de76631 = level.var_55c48492.var_5cd7e450[2] + 10 * 1 - var_e312b793;
	var_ba7b8d86 = (level.var_55c48492.origin[0], level.var_55c48492.origin[1], var_3de76631);
	level.var_55c48492 moveto(var_ba7b8d86, 0.2);
}

/*
	Name: function_b820cada
	Namespace: zm_island_skullquest
	Checksum: 0x99EC1590
	Offset: 0x71C8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_b820cada()
{
}

/*
	Name: function_2d0c5aa1
	Namespace: zm_island_skullquest
	Checksum: 0x4501E29A
	Offset: 0x71D8
	Size: 0x19B
	Parameters: 1
	Flags: None
*/
function function_2d0c5aa1(s_spawn_point)
{
	self endon("death");
	self.script_string = "find_flesh";
	self setPhysParams(15, 0, 72);
	self.ignore_enemy_count = 1;
	self.no_eye_glow = 1;
	self.deathpoints_already_given = 1;
	self.exclude_distance_cleanup_adding_to_total = 1;
	self.exclude_cleanup_adding_to_total = 1;
	self SetTeam("axis");
	self.start_inert = 1;
	self thread zm_spawner::zombie_think();
	self thread zm_spawner::enemy_death_detection();
	self.noCrawler = 1;
	self.no_powerups = 1;
	util::wait_network_frame();
	self clientfield::set("keeper_fx", 1);
	self.voicePrefix = "keeper";
	self.animName = "keeper";
	self thread zm_spawner::play_ambient_zombie_vocals();
	self thread zm_audio::zmbAIVox_NotifyConvert();
	if(self.zombie_move_speed === "walk")
	{
		self zombie_utility::set_zombie_run_cycle("run");
	}
}

/*
	Name: keeper_death_callback
	Namespace: zm_island_skullquest
	Checksum: 0xD0395F39
	Offset: 0x7380
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function keeper_death_callback(params)
{
	if(isdefined(self) && (isdefined(self.var_2f846873) && self.var_2f846873))
	{
		level.var_92914699--;
		level.var_9bc0cd6e++;
		function_a050863e(self.origin, level.var_55c48492.origin);
		level thread function_41b94a87();
		if(isdefined(self))
		{
			self clientfield::set("keeper_fx", 0);
		}
	}
}

/*
	Name: function_efbd4abf
	Namespace: zm_island_skullquest
	Checksum: 0x3BC296BC
	Offset: 0x7430
	Size: 0x10B
	Parameters: 2
	Flags: None
*/
function function_efbd4abf(ai_zombie, s_spawn_point)
{
	ai_zombie waittill("death");
	var_4124898d = ai_zombie.origin;
	level.var_92914699--;
	level.var_9bc0cd6e++;
	if(level flag::get("skullroom_defend_inprogress"))
	{
		if(isdefined(var_4124898d))
		{
			function_a050863e(var_4124898d, level.var_55c48492.origin);
		}
		level thread function_41b94a87();
	}
	if(isdefined(ai_zombie))
	{
		ai_zombie clientfield::set("keeper_fx", 0);
	}
	util::wait_network_frame();
	if(isdefined(ai_zombie))
	{
		ai_zombie delete();
	}
}

/*
	Name: function_458f50f2
	Namespace: zm_island_skullquest
	Checksum: 0x2E70A059
	Offset: 0x7548
	Size: 0x31B
	Parameters: 0
	Flags: None
*/
function function_458f50f2()
{
	self endon("death");
	if(!self HasWeapon(level.var_c003f5b, 1))
	{
		if(!(isdefined(self.var_b319e777) && self.var_b319e777))
		{
			self.var_b319e777 = 1;
			self DisableWeaponCycling();
			self playsound("zmb_skullgun_pickup");
			var_7277c7f7 = self GetCurrentWeapon();
			self function_29d2aa0e(3, undefined, 1);
			self thread zm_audio::create_and_play_dialog("quest_skull", "weapon_success");
			self zm_weapons::weapon_give(level.var_c003f5b, undefined, undefined, 1);
			self GadgetPowerSet(0, 100);
			self SwitchToWeapon(level.var_c003f5b);
			self notify("hash_ae5d6003");
			level flag::set("a_player_got_skullgun");
			self waittill("weapon_change_complete");
			wait(0.25);
			self SwitchToWeapon(var_7277c7f7);
			self waittill("weapon_change_complete");
			self GadgetPowerSet(0, 100);
			self SetWeaponAmmoClip(level.var_c003f5b, 0);
			self GiveAchievement("ZM_ISLAND_OBTAIN_SKULL");
			self EnableWeaponCycling();
			self flag::set("has_skull");
			self thread function_5d65695d();
		}
		else
		{
			self zm_weapons::weapon_give(level.var_c003f5b, undefined, undefined, 1);
			self GadgetPowerSet(0, 100);
			self SetWeaponAmmoClip(level.var_c003f5b, 0);
			self zm_hero_weapon::set_hero_weapon_state(level.var_c003f5b, 2);
			self thread function_29d2aa0e(3, undefined, 1);
			self thread zm_hero_weapon::watch_hero_weapon_take();
		}
	}
}

/*
	Name: function_940267cd
	Namespace: zm_island_skullquest
	Checksum: 0x9F9A8188
	Offset: 0x7870
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function function_940267cd()
{
	self endon("disconnect");
	level flag::wait_till("a_player_got_skullgun");
	e_mural = GetEnt("reveal_keeper_mural_01", "targetname");
	if(isdefined(e_mural) && !isdefined(e_mural.b_shown))
	{
		self thread function_f293f820(e_mural, "mural1_revealed");
	}
	else
	{
		callback::remove_on_spawned(&function_940267cd);
	}
}

/*
	Name: function_ba04e236
	Namespace: zm_island_skullquest
	Checksum: 0x925C564
	Offset: 0x7938
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function function_ba04e236()
{
	self endon("disconnect");
	level flag::wait_till("a_player_got_skullgun");
	e_mural = GetEnt("reveal_keeper_mural_02", "targetname");
	if(isdefined(e_mural) && !isdefined(e_mural.b_shown))
	{
		self thread function_f293f820(e_mural, "mural2_revealed");
	}
	else
	{
		callback::remove_on_spawned(&function_ba04e236);
	}
}

/*
	Name: function_e0075c9f
	Namespace: zm_island_skullquest
	Checksum: 0xBF01C4C0
	Offset: 0x7A00
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function function_e0075c9f()
{
	self endon("disconnect");
	level flag::wait_till("a_player_got_skullgun");
	e_mural = GetEnt("reveal_keeper_mural_03", "targetname");
	if(isdefined(e_mural) && !isdefined(e_mural.b_shown))
	{
		self thread function_f293f820(e_mural, "mural3_revealed");
	}
	else
	{
		callback::remove_on_spawned(&function_e0075c9f);
	}
}

/*
	Name: function_f293f820
	Namespace: zm_island_skullquest
	Checksum: 0x1C5DB16A
	Offset: 0x7AC8
	Size: 0x91
	Parameters: 2
	Flags: None
*/
function function_f293f820(mdl_target, var_6a4cf64a)
{
	self endon("disconnect");
	self endon("death");
	level endon(var_6a4cf64a);
	if(isdefined(mdl_target))
	{
		self namespace_8aed53c9::function_7448e472(mdl_target);
		mdl_target clientfield::set("do_emissive_material", 1);
		mdl_target.b_shown = 1;
		level notify(var_6a4cf64a);
	}
}

/*
	Name: function_d4ebb4b0
	Namespace: zm_island_skullquest
	Checksum: 0x3F9A5566
	Offset: 0x7B68
	Size: 0xC5
	Parameters: 0
	Flags: None
*/
function function_d4ebb4b0()
{
	if(isdefined(self.var_d64275e8) && self.var_d64275e8 > 0)
	{
		e_skull = level.a_skullquests[self.var_d64275e8].mdl_skull_s;
	}
	else if(isdefined(self.var_4849e523) && self.var_4849e523 > 0)
	{
		e_skull = level.a_skullquests[self.var_4849e523].mdl_skull_p;
	}
	if(isdefined(e_skull))
	{
		var_96b8c7e2 = level.var_b34be0cd[e_skull.var_f7d3c273];
		return var_96b8c7e2;
	}
	else
	{
		return -1;
	}
}

/*
	Name: function_9e63bcd3
	Namespace: zm_island_skullquest
	Checksum: 0x7263FB0E
	Offset: 0x7C38
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_9e63bcd3(n_ritual)
{
	level.a_skullquests[n_ritual].mdl_skull_s.var_afb64bf6 = undefined;
	if(isdefined(self))
	{
		self thread function_71593151();
		self.var_d64275e8 = 0;
	}
	function_c029cf5b(n_ritual);
}

/*
	Name: function_880d3333
	Namespace: zm_island_skullquest
	Checksum: 0x3801C10F
	Offset: 0x7CA8
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function function_880d3333(n_ritual)
{
	level.a_skullquests[n_ritual].mdl_skull_s set_at(level.a_skullquests[n_ritual].mdl_skull_s.var_5cd7e450, level.a_skullquests[n_ritual].mdl_skull_s.var_d7778aba);
}

/*
	Name: function_c029cf5b
	Namespace: zm_island_skullquest
	Checksum: 0xC8C27F5D
	Offset: 0x7D28
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function function_c029cf5b(n_ritual)
{
	level.a_skullquests[n_ritual].mdl_skull_s set_at(level.a_skullquests[n_ritual].s_skulltar_skull_pos.origin, level.a_skullquests[n_ritual].s_skulltar_skull_pos.angles);
	level.a_skullquests[n_ritual].mdl_skull_s show();
}

/*
	Name: set_at
	Namespace: zm_island_skullquest
	Checksum: 0xA3EFA459
	Offset: 0x7DD0
	Size: 0x6B
	Parameters: 3
	Flags: None
*/
function set_at(v_pos, v_angles, b_show)
{
	if(!isdefined(b_show))
	{
		b_show = 1;
	}
	self.origin = v_pos;
	self.angles = v_angles;
	if(isdefined(b_show) && b_show)
	{
		self show();
	}
}

/*
	Name: function_e3ff3bac
	Namespace: zm_island_skullquest
	Checksum: 0x73AC0DEC
	Offset: 0x7E48
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function function_e3ff3bac(n_ritual)
{
	level.a_skullquests[n_ritual].mdl_skull_p ghost();
	level.a_skullquests[n_ritual].mdl_skull_p.var_afb64bf6 = self;
	self.var_4849e523 = n_ritual;
	var_96b8c7e2 = self function_d4ebb4b0();
	self function_29d2aa0e(2, var_96b8c7e2, 1);
	self thread zm_island_vo::function_87d97caa();
}

/*
	Name: function_b6c35b21
	Namespace: zm_island_skullquest
	Checksum: 0x48444B5F
	Offset: 0x7F18
	Size: 0x48B
	Parameters: 1
	Flags: None
*/
function function_b6c35b21(n_ritual)
{
	if(!(isdefined(level.a_skullquests[n_ritual].mdl_skull_p.b_returned) && level.a_skullquests[n_ritual].mdl_skull_p.b_returned))
	{
		level.a_skullquests[n_ritual].mdl_skull_p.b_returned = 1;
		self thread function_71593151();
		level.a_skullquests[n_ritual].mdl_skull_p.var_afb64bf6 = undefined;
		var_1a3afb94 = self.var_4849e523;
		var_96b8c7e2 = self function_d4ebb4b0();
		self function_29d2aa0e(0, var_96b8c7e2, 0);
		self.var_4849e523 = 0;
		level.a_skullquests[n_ritual].mdl_skull_s ghost();
		self thread zm_island_vo::function_64f4c27();
		level.a_skullquests[n_ritual].mdl_skull_p.origin = level.a_skullquests[n_ritual].mdl_skull_s.var_5cd7e450;
		level.a_skullquests[n_ritual].mdl_skull_p.angles = level.a_skullquests[n_ritual].mdl_skull_s.var_d7778aba;
		level.a_skullquests[n_ritual].mdl_skull_p show();
		level.a_skullquests[n_ritual].mdl_skull_p clientfield::set("skullquest_finish_start_fx", 1);
		level.a_skullquests[n_ritual].mdl_skull_p playsound("zmb_skull_pillar_fly");
		level.a_skullquests[n_ritual].mdl_skull_p clientfield::set("skullquest_finish_end_fx", 1);
		s_ritual = level.a_skullquests[n_ritual];
		mdl_skull_p = level.a_skullquests[n_ritual].mdl_skull_p;
		var_f7d3c273 = mdl_skull_p.var_f7d3c273;
		var_c274e933 = Array("", "altar_skull_battle", "altar_skull_blood", "altar_skull_chaos", "altar_skull_doom");
		var_9d012998 = Array("", "skull_battle_jnt", "skull_blood_jnt", "skull_chaos_jnt", "skull_doom_jnt");
		var_c9260a5 = Array("", "p7_fxanim_zm_island_altar_skull_battle_bundle", "p7_fxanim_zm_island_altar_skull_blood_bundle", "p7_fxanim_zm_island_altar_skull_chaos_bundle", "p7_fxanim_zm_island_altar_skull_doom_bundle");
		var_e36aa077 = GetEnt(var_c274e933[var_f7d3c273], "targetname");
		var_e36aa077 clientfield::set("do_emissive_material", 1);
		var_e36aa077 thread scene::Play(var_c9260a5[var_f7d3c273], var_e36aa077);
		mdl_skull_p LinkTo(var_e36aa077, var_9d012998[var_f7d3c273]);
		var_e36aa077 waittill("scene_done");
		level notify("skull_p_returned" + var_1a3afb94);
	}
}

/*
	Name: function_76e79e0e
	Namespace: zm_island_skullquest
	Checksum: 0xC48BD38B
	Offset: 0x83B0
	Size: 0x17
	Parameters: 0
	Flags: None
*/
function function_76e79e0e()
{
	return self.var_4849e523 + self.var_d64275e8 > 0;
}

/*
	Name: function_9e2f0e52
	Namespace: zm_island_skullquest
	Checksum: 0x5E8A58B7
	Offset: 0x83D0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_9e2f0e52()
{
	return zombie_utility::is_player_valid(self) && isalive(self) && !self laststand::player_is_in_laststand();
}

/*
	Name: on_player_spawned
	Namespace: zm_island_skullquest
	Checksum: 0x9A50C1F3
	Offset: 0x8428
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self.var_d64275e8 = 0;
	self.var_4849e523 = 0;
	self.var_335e6491 = [];
	self.var_335e6491[0] = undefined;
	self.var_335e6491[1] = undefined;
	while(1)
	{
		self waittill("bled_out");
		self thread function_c7cd5585();
		self function_29d2aa0e(0, 0, 0);
	}
}

/*
	Name: function_c7cd5585
	Namespace: zm_island_skullquest
	Checksum: 0x8901A7BA
	Offset: 0x84B8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_c7cd5585()
{
	if(self.var_d64275e8 !== 0)
	{
		level thread function_3fe31e5b(self.var_d64275e8);
	}
	else if(self.var_4849e523 !== 0)
	{
		level thread function_eba0c996(self.var_4849e523);
	}
}

/*
	Name: function_18d60013
	Namespace: zm_island_skullquest
	Checksum: 0x9A5CFD92
	Offset: 0x8520
	Size: 0x20B
	Parameters: 0
	Flags: None
*/
function function_18d60013()
{
	/#
		zm_devgui::add_custom_devgui_callback(&function_3bd86987);
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_3bd86987
	Namespace: zm_island_skullquest
	Checksum: 0x572BFF83
	Offset: 0x8738
	Size: 0x421
	Parameters: 1
	Flags: None
*/
function function_3bd86987(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				function_fdafeea2(level.activePlayers[0]);
				level flag::set("Dev Block strings are not supported");
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_f7ec6ad4(1, level.activePlayers[0]);
				wait(1);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_f7ec6ad4(2, level.activePlayers[0]);
				wait(1);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_f7ec6ad4(3, level.activePlayers[0]);
				wait(1);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_f7ec6ad4(4, level.activePlayers[0]);
				wait(1);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				foreach(player in level.activePlayers)
				{
					player GadgetPowerSet(0, 100);
				}
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_8196b5ee();
				level flag::set("Dev Block strings are not supported");
				wait(1);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_bc2507a3(1);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_bc2507a3(2);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_bc2507a3(3);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_bc2507a3(4);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_bc2507a3(0);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_138d72ee(1);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_138d72ee(2);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_138d72ee(3);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_138d72ee(4);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				if(!(isdefined(level.var_32d5991a) && level.var_32d5991a))
				{
					level.var_32d5991a = 1;
				}
				else
				{
					level.var_32d5991a = 0;
				}
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level.var_69fe775a = 100;
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level.var_69fe775a = 1200;
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level.var_69fe775a = 0;
				return 1;
			}
		}
		return 0;
	#/
}

/*
	Name: function_138d72ee
	Namespace: zm_island_skullquest
	Checksum: 0xC389BF35
	Offset: 0x8B68
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_138d72ee(n_ritual)
{
	/#
		level thread function_fae0aa01(n_ritual, "Dev Block strings are not supported", level.activePlayers[0]);
	#/
}

/*
	Name: function_bc2507a3
	Namespace: zm_island_skullquest
	Checksum: 0x87B9484
	Offset: 0x8BB0
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function function_bc2507a3(n_progress)
{
	/#
		level.var_4ffafd2 = n_progress;
	#/
}

/*
	Name: function_8196b5ee
	Namespace: zm_island_skullquest
	Checksum: 0x8A38A04
	Offset: 0x8BD8
	Size: 0x91
	Parameters: 0
	Flags: None
*/
function function_8196b5ee()
{
	/#
		foreach(player in level.activePlayers)
		{
			player function_458f50f2();
		}
	#/
}

/*
	Name: function_f7ec6ad4
	Namespace: zm_island_skullquest
	Checksum: 0x29036CC0
	Offset: 0x8C78
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function function_f7ec6ad4(n_ritual, ent)
{
	/#
		if(ent.var_d64275e8 === 0)
		{
			function_fae0aa01(n_ritual, "Dev Block strings are not supported", ent);
		}
	#/
}

/*
	Name: skullquest_init
	Namespace: zm_island_skullquest
	Checksum: 0x1E751342
	Offset: 0x8CD0
	Size: 0x113
	Parameters: 1
	Flags: None
*/
function skullquest_init(n_ritual)
{
	if(!level flag::exists("skullquest_completed" + n_ritual))
	{
		level flag::init("skullquest_completed" + n_ritual);
	}
	function_fae0aa01(n_ritual, "start");
	level.a_skullquests[n_ritual].s_utrig_pillar setup_unitrigger("unitrigger_radius_use", &function_8c6a13d0, &function_dc9fe8fe, 24);
	level.a_skullquests[n_ritual].s_utrig_skulltar setup_unitrigger("unitrigger_radius_use", &function_3cd83908, &function_d757eab6);
}

/*
	Name: setup_unitrigger
	Namespace: zm_island_skullquest
	Checksum: 0x1D79DEE7
	Offset: 0x8DF0
	Size: 0xF3
	Parameters: 6
	Flags: None
*/
function setup_unitrigger(str_type, func_vis, func_think, n_radius, n_height, b_lookat)
{
	if(!isdefined(str_type))
	{
		str_type = "unitrigger_radius_use";
	}
	if(!isdefined(n_radius))
	{
		n_radius = 64;
	}
	if(!isdefined(n_height))
	{
		n_height = 256;
	}
	if(!isdefined(b_lookat))
	{
		b_lookat = 1;
	}
	self.script_unitrigger_type = "unitrigger_radius_use";
	self.cursor_hint = "HINT_NOICON";
	self.require_look_at = b_lookat;
	self.radius = n_radius;
	self.height = n_height;
	self.prompt_and_visibility_func = func_vis;
	zm_unitrigger::register_static_unitrigger(self, func_think);
}

/*
	Name: function_fae0aa01
	Namespace: zm_island_skullquest
	Checksum: 0x7D644B35
	Offset: 0x8EF0
	Size: 0xA35
	Parameters: 3
	Flags: None
*/
function function_fae0aa01(n_ritual, var_f2a1da83, player)
{
	var_f1556de = Array("start", "skull_s_picked_up", "inritual", "pre_retry", "retry", "postritual", "skull_p_picked_up", "completed");
	if(level.a_skullquests[n_ritual].str_state !== var_f2a1da83 && IsInArray(var_f1556de, var_f2a1da83))
	{
		level.a_skullquests[n_ritual].str_state = var_f2a1da83;
		switch(var_f2a1da83)
		{
			case "start":
			{
				level.a_skullquests[n_ritual].mdl_skull_s.origin = level.a_skullquests[n_ritual].mdl_skull_s.var_5cd7e450;
				level.a_skullquests[n_ritual].mdl_skull_s.angles = level.a_skullquests[n_ritual].mdl_skull_s.var_d7778aba;
				level.a_skullquests[n_ritual].mdl_skull_s clientfield::set("do_fade_material_direct", 1);
				level.a_skullquests[n_ritual].mdl_skull_s show();
				level.a_skullquests[n_ritual].mdl_skull_s clientfield::set("skullquest_finish_start_fx", 1);
				level.a_skullquests[n_ritual].mdl_skull_s playsound("zmb_skull_reappear");
				level.a_skullquests[n_ritual].mdl_skull_s.var_afb64bf6 = undefined;
				foreach(plyr in level.activePlayers)
				{
					if(plyr.var_d64275e8 === n_ritual)
					{
						plyr.var_d64275e8 = 0;
					}
				}
				level.a_skullquests[n_ritual].mdl_skull_p ghost();
				level.a_skullquests[n_ritual].mdl_skulltar clientfield::set("do_emissive_material", 0);
				break;
			}
			case "skull_s_picked_up":
			{
				player function_5f43b720(n_ritual);
				break;
			}
			case "inritual":
			{
				if(!level flag::get("skullquest_ritual_inprogress" + n_ritual))
				{
					if(zombie_utility::is_player_valid(player))
					{
						player function_9e63bcd3(n_ritual);
						player playsound("zmb_skulltar_place");
					}
					player thread zm_island_vo::function_9984d8f0();
					level.a_skullquests[n_ritual].mdl_skull_p.origin = level.a_skullquests[n_ritual].s_skulltar_skull_pos.origin;
					level.a_skullquests[n_ritual].mdl_skull_p.angles = level.a_skullquests[n_ritual].s_skulltar_skull_pos.angles;
					level.a_skullquests[n_ritual].mdl_skull_p ghost();
					level.a_skullquests[n_ritual] thread function_80794095();
					break;
				}
			}
			case "pre_retry":
			{
				level.a_skullquests[n_ritual].mdl_skull_s.origin = level.a_skullquests[n_ritual].s_skulltar_skull_pos.origin;
				level.a_skullquests[n_ritual].mdl_skull_s.angles = level.a_skullquests[n_ritual].s_skulltar_skull_pos.angles;
				level.a_skullquests[n_ritual].mdl_skull_s ghost();
				level.a_skullquests[n_ritual].mdl_skull_s clientfield::set("skullquest_finish_start_fx", 1);
				level waittill("start_of_round");
				if(level.a_skullquests[n_ritual].str_state === "pre_retry")
				{
					level thread function_fae0aa01(n_ritual, "start");
				}
				break;
			}
			case "retry":
			{
				level.a_skullquests[n_ritual].mdl_skull_s.origin = level.a_skullquests[n_ritual].s_skulltar_skull_pos.origin;
				level.a_skullquests[n_ritual].mdl_skull_s.angles = level.a_skullquests[n_ritual].s_skulltar_skull_pos.angles;
				level.a_skullquests[n_ritual].mdl_skull_s show();
				level.a_skullquests[n_ritual].mdl_skull_p.origin = level.a_skullquests[n_ritual].s_skulltar_skull_pos.origin;
				level.a_skullquests[n_ritual].mdl_skull_p.angles = level.a_skullquests[n_ritual].s_skulltar_skull_pos.angles;
				level.a_skullquests[n_ritual].mdl_skull_p ghost();
				break;
			}
			case "postritual":
			{
				level.a_skullquests[n_ritual].mdl_skull_p.origin = level.a_skullquests[n_ritual].mdl_skull_s.origin;
				level.a_skullquests[n_ritual].mdl_skull_p.angles = level.a_skullquests[n_ritual].mdl_skull_s.angles;
				level.a_skullquests[n_ritual].mdl_skull_p show();
				level.a_skullquests[n_ritual].mdl_skull_s ghost();
				break;
			}
			case "skull_p_picked_up":
			{
				level.a_skullquests[n_ritual].mdl_skull_s ghost();
				player function_e3ff3bac(n_ritual);
				break;
			}
			case "completed":
			{
				level.a_skullquests[n_ritual] flag::set("skullquest_completed");
				player function_b6c35b21(n_ritual);
				level.var_452c59e0++;
				if(level.var_452c59e0 == 4)
				{
					level thread exploder::exploder("fxexp_503");
					wait(0.25);
					level thread function_fdafeea2(player);
					foreach(skullquest in level.a_skullquests)
					{
						skullquest.mdl_skull_p clientfield::set("skullquest_finish_done_glow_fx", 1);
					}
				}
				zm_unitrigger::unregister_unitrigger(level.a_skullquests[n_ritual].s_utrig_pillar);
				zm_unitrigger::unregister_unitrigger(level.a_skullquests[n_ritual].s_utrig_skulltar);
				break;
			}
		}
	}
}

/*
	Name: function_741beb6d
	Namespace: zm_island_skullquest
	Checksum: 0xBA5DC3CD
	Offset: 0x9930
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function function_741beb6d(n_ritual)
{
	return level.a_skullquests[n_ritual].str_state;
}

/*
	Name: function_8c6a13d0
	Namespace: zm_island_skullquest
	Checksum: 0xFDA63421
	Offset: 0x9960
	Size: 0x20F
	Parameters: 1
	Flags: None
*/
function function_8c6a13d0(player)
{
	var_6d538e4e = function_741beb6d(self.stub.script_special);
	if(player !== level.var_2371bbc)
	{
		switch(var_6d538e4e)
		{
			case "start":
			{
				if(!player function_76e79e0e())
				{
					self sethintstringforplayer(player, level.var_8b0a8fa9);
					return 1;
				}
				else
				{
					self sethintstringforplayer(player, "");
					return 0;
				}
			}
			case "skull_s_picked_up":
			{
				if(player.var_d64275e8 === self.stub.script_special)
				{
					self sethintstringforplayer(player, level.var_983da0e6);
					return 1;
				}
				else
				{
					self sethintstringforplayer(player, "");
					return 0;
				}
			}
			case "skull_p_picked_up":
			{
				if(player.var_4849e523 === self.stub.script_special)
				{
					self sethintstringforplayer(player, level.var_983da0e6);
					return 1;
				}
				else
				{
					self sethintstringforplayer(player, "");
					return 0;
				}
			}
			case default:
			{
				self sethintstringforplayer(player, "");
				return 0;
			}
		}
	}
	else
	{
		self sethintstringforplayer(player, "");
		return 0;
	}
}

/*
	Name: function_dc9fe8fe
	Namespace: zm_island_skullquest
	Checksum: 0xB9D2BE94
	Offset: 0x9B78
	Size: 0x25F
	Parameters: 0
	Flags: None
*/
function function_dc9fe8fe()
{
	while(1)
	{
		self waittill("trigger", player);
		if(player function_9e2f0e52())
		{
			var_6d538e4e = function_741beb6d(self.stub.script_special);
			switch(var_6d538e4e)
			{
				case "start":
				{
					if(!player function_76e79e0e())
					{
						level thread function_fae0aa01(self.stub.script_special, "skull_s_picked_up", player);
						player playsound("zmb_skull_pickup");
						self setHintString("");
					}
					break;
				}
				case "skull_s_picked_up":
				{
					if(player.var_d64275e8 === self.stub.script_special)
					{
						player thread function_8302a101(self.stub.script_special);
						player playsound("zmb_skull_place");
						level thread function_fae0aa01(self.stub.script_special, "start");
						self setHintString("");
					}
					break;
				}
				case "skull_p_picked_up":
				{
					if(player.var_4849e523 === self.stub.script_special)
					{
						level thread function_fae0aa01(self.stub.script_special, "completed", player);
						self setHintString("");
					}
					break;
				}
			}
			wait(1);
		}
	}
}

/*
	Name: function_3cd83908
	Namespace: zm_island_skullquest
	Checksum: 0xA3740A08
	Offset: 0x9DE0
	Size: 0x17D
	Parameters: 1
	Flags: None
*/
function function_3cd83908(player)
{
	var_6d538e4e = function_741beb6d(self.stub.script_special);
	switch(var_6d538e4e)
	{
		case "skull_s_picked_up":
		case "start":
		{
			if(player.var_d64275e8 === self.stub.script_special)
			{
				self sethintstringforplayer(player, level.var_983da0e6);
				return 1;
			}
			else
			{
				self sethintstringforplayer(player, "");
				return 0;
			}
		}
		case "pre_retry":
		{
			return 0;
		}
		case "retry":
		{
			self sethintstringforplayer(player, level.var_8b418269);
			return 1;
		}
		case "postritual":
		{
			if(player function_76e79e0e())
			{
				return 0;
			}
			else
			{
				self setHintString(level.var_8b0a8fa9);
				return 1;
			}
		}
		case default:
		{
			self sethintstringforplayer(player, "");
			return 0;
		}
	}
}

/*
	Name: function_d757eab6
	Namespace: zm_island_skullquest
	Checksum: 0xB8329916
	Offset: 0x9F68
	Size: 0x21F
	Parameters: 0
	Flags: None
*/
function function_d757eab6()
{
	while(1)
	{
		self waittill("trigger", player);
		if(player function_9e2f0e52())
		{
			var_6d538e4e = function_741beb6d(self.stub.script_special);
			switch(var_6d538e4e)
			{
				case "skull_s_picked_up":
				case "start":
				{
					if(player.var_d64275e8 === self.stub.script_special)
					{
						level thread function_fae0aa01(self.stub.script_special, "inritual", player);
						self setHintString("");
					}
					break;
				}
				case "retry":
				{
					level.a_skullquests[self.stub.script_special] thread function_80794095();
					level thread function_fae0aa01(self.stub.script_special, "inritual");
					self setHintString("");
					break;
				}
				case "postritual":
				{
					if(!player function_76e79e0e())
					{
						level thread function_fae0aa01(self.stub.script_special, "skull_p_picked_up", player);
						player playsound("zmb_skull_pickup");
						self setHintString("");
					}
					break;
				}
			}
			wait(1);
		}
	}
}

/*
	Name: function_5f43b720
	Namespace: zm_island_skullquest
	Checksum: 0x3263A6C7
	Offset: 0xA190
	Size: 0x123
	Parameters: 1
	Flags: None
*/
function function_5f43b720(n_ritual)
{
	var_de2720b3 = level.a_skullquests[n_ritual].mdl_skulltar.origin - VectorScale((0, 0, 1), 32);
	level.a_skullquests[n_ritual].mdl_skull_s set_at(var_de2720b3, level.a_skullquests[n_ritual].s_skulltar_skull_pos.angles);
	level.a_skullquests[n_ritual].mdl_skull_s.var_afb64bf6 = self;
	self.var_d64275e8 = n_ritual;
	var_96b8c7e2 = self function_d4ebb4b0();
	self function_29d2aa0e(1, var_96b8c7e2, 1);
	self thread zm_island_vo::function_97ed7288();
}

/*
	Name: function_8302a101
	Namespace: zm_island_skullquest
	Checksum: 0xCA6CFCE0
	Offset: 0xA2C0
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_8302a101(n_ritual)
{
	var_96b8c7e2 = self function_d4ebb4b0();
	self function_29d2aa0e(0, var_96b8c7e2, 1);
	level thread function_3fe31e5b(n_ritual);
}

/*
	Name: function_74513d26
	Namespace: zm_island_skullquest
	Checksum: 0x2862AE22
	Offset: 0xA330
	Size: 0x91
	Parameters: 0
	Flags: None
*/
function function_74513d26()
{
	var_28ff596b = 0;
	for(i = 1; i <= 4; i++)
	{
		str_flag = "skullquest_ritual_inprogress" + i;
		if(level flag::exists(str_flag) && level flag::get(str_flag))
		{
			var_28ff596b++;
		}
	}
	return var_28ff596b;
}

/*
	Name: function_567dfe61
	Namespace: zm_island_skullquest
	Checksum: 0x7C1A3070
	Offset: 0xA3D0
	Size: 0x91
	Parameters: 0
	Flags: None
*/
function function_567dfe61()
{
	var_aa60e64e = 0;
	for(i = 1; i <= 4; i++)
	{
		str_flag = "skullquest_ritual_complete" + i;
		if(level flag::exists(str_flag) && level flag::get(str_flag))
		{
			var_aa60e64e++;
		}
	}
	return var_aa60e64e;
}

/*
	Name: function_29d2aa0e
	Namespace: zm_island_skullquest
	Checksum: 0x33114096
	Offset: 0xA470
	Size: 0x9B
	Parameters: 3
	Flags: None
*/
function function_29d2aa0e(var_228798e1, var_96b8c7e2, var_b89973c8)
{
	if(!isdefined(var_b89973c8))
	{
		var_b89973c8 = 0;
	}
	self clientfield::set_to_player("skull_skull_state", var_228798e1);
	if(isdefined(var_96b8c7e2))
	{
		self clientfield::set_to_player("skull_skull_type", var_96b8c7e2);
	}
	if(var_b89973c8)
	{
		self thread zm_craftables::player_show_craftable_parts_ui(undefined, "zmInventory.widget_skull_parts", 0);
	}
}

/*
	Name: function_71593151
	Namespace: zm_island_skullquest
	Checksum: 0x1ACD51DF
	Offset: 0xA518
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function function_71593151()
{
	self function_29d2aa0e(0, 0, 0);
}

/*
	Name: function_5d65695d
	Namespace: zm_island_skullquest
	Checksum: 0x57D69C80
	Offset: 0xA540
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function function_5d65695d()
{
	self endon("disconnect");
	self.var_1ff2320b = 0;
	while(!self.var_1ff2320b)
	{
		self waittill("weapon_change");
		if(self GetCurrentWeapon() == level.var_c003f5b)
		{
			self.var_1ff2320b = 1;
			self zm_equipment::show_hint_text(&"ZM_ISLAND_SKULL_VAPORIZE", 4);
		}
	}
}

