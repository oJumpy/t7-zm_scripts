#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_filter;

#namespace zm_castle_weap_quest;

/*
	Name: __init__sytem__
	Namespace: zm_castle_weap_quest
	Checksum: 0x62117A76
	Offset: 0x878
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_castle_weap_quest", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_castle_weap_quest
	Checksum: 0xA87E869F
	Offset: 0x8B8
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.var_f302359b = struct::get_array("dragon_position", "targetname");
	clientfield::register("actor", "make_client_clone", 5000, 4, "int", &pose_dead_body, 0, 0);
	for(i = 0; i < level.var_f302359b.size; i++)
	{
		clientfield::register("world", level.var_f302359b[i].script_parameters, 5000, 3, "int", &soul_catcher_callback, 0, 0);
	}
	clientfield::register("toplayer", "bow_pickup_fx", 5000, 1, "int", &function_4e75b7c1, 0, 0);
}

/*
	Name: main
	Namespace: zm_castle_weap_quest
	Checksum: 0xA1BD4BC4
	Offset: 0xA00
	Size: 0x6E3
	Parameters: 0
	Flags: None
*/
function main()
{
	level._effect["bow_spawn_fx"] = "dlc1/castle/fx_plinth_pick_up_base_bow";
	level._effect["mini_dragon_fire"] = "dlc1/castle/fx_dragon_head_mouth_fire_sm";
	level._effect["mini_dragon_eye"] = "dlc1/castle/fx_dragon_head_eye_glow_sm";
	level.var_b86a93ed = "cin_t7_ai_zm_dlc1_dragonhead_static";
	level.var_dd277883 = "cin_t7_ai_zm_dlc1_dragonhead_intro";
	level.var_160f7e80 = "cin_t7_zm_dlc1_dragonhead_depart";
	level.var_a79e1598 = [];
	level.var_a79e1598["dragonhead_1"] = "p7_fxanim_zm_castle_dragon_crumble_undercroft_bundle";
	level.var_a79e1598["dragonhead_2"] = "p7_fxanim_zm_castle_dragon_crumble_courtyard_bundle";
	level.var_a79e1598["dragonhead_3"] = "p7_fxanim_zm_castle_dragon_crumble_greathall_bundle";
	level.var_c7a1f434 = [];
	level.var_c7a1f434["right"] = "cin_t7_ai_zm_dlc1_dragonhead_pre_eat_r";
	level.var_c7a1f434["left"] = "cin_t7_ai_zm_dlc1_dragonhead_pre_eat_l";
	level.var_c7a1f434["front"] = "cin_t7_ai_zm_dlc1_dragonhead_pre_eat_f";
	level.var_c7a1f434["left_2_right"] = "cin_t7_ai_zm_dlc1_dragonhead_pre_eat_l_2_r";
	level.var_c7a1f434["right_2_left"] = "cin_t7_ai_zm_dlc1_dragonhead_pre_eat_r_2_l";
	level.var_977975d2 = [];
	level.var_977975d2["right"] = "cin_t7_ai_zm_dlc1_dragonhead_consume_r";
	level.var_977975d2["left"] = "cin_t7_ai_zm_dlc1_dragonhead_consume_l";
	level.var_977975d2["front"] = "cin_t7_ai_zm_dlc1_dragonhead_consume_f";
	level.var_d198ed8e = [];
	level.var_d198ed8e["right"] = %rtrg_ai_zm_dlc1_dragonhead_consume_zombie_align_r;
	level.var_d198ed8e["left"] = %rtrg_ai_zm_dlc1_dragonhead_consume_zombie_align_l;
	level.var_d198ed8e["front"] = %rtrg_ai_zm_dlc1_dragonhead_consume_zombie_align_f;
	level.var_93ad1521 = [];
	level.var_93ad1521[0] = "cin_t7_ai_zm_dlc1_dragonhead_idle";
	level.var_93ad1521[1] = "cin_t7_ai_zm_dlc1_dragonhead_idle_b";
	level.var_16db17aa = [];
	level.var_16db17aa[0] = "cin_t7_ai_zm_dlc1_dragonhead_idle_twitch_roar";
	scene::add_scene_func(level.var_93ad1521[0], &function_8cce2397);
	scene::add_scene_func(level.var_93ad1521[1], &function_8cce2397);
	scene::add_scene_func(level.var_16db17aa[0], &function_def5820e);
	level.fake_body_death_anim = %ai_zm_dlc1_dragonhead_zombie_impact;
	assemble_fake_body_head_arrays();
	util::waitforallclients();
	wait(1);
	level.dragon_heads = [];
	level.dragon_bodies = [];
	level.var_abd9e961 = [];
	players = GetLocalPlayers();
	for(j = 0; j < players.size; j++)
	{
		level.dragon_heads[j] = [];
		level.dragon_bodies[j] = [];
		level.var_abd9e961[j] = [];
		for(i = 0; i < level.var_f302359b.size; i++)
		{
			level.dragon_heads[j][level.var_f302359b[i].script_parameters] = GetEnt(j, level.var_f302359b[i].script_label, "targetname");
			level.dragon_heads[j][level.var_f302359b[i].script_parameters] useanimtree(-1);
			level.dragon_heads[j][level.var_f302359b[i].script_parameters] flag::init("dragon_far_right");
			level.dragon_heads[j][level.var_f302359b[i].script_parameters] flag::init("dragon_far_left");
			level.dragon_heads[j][level.var_f302359b[i].script_parameters].b_depart = 1;
			level.dragon_bodies[j][level.var_f302359b[i].script_parameters] = GetEnt(j, level.var_f302359b[i].script_friendname, "targetname");
			level.dragon_bodies[j][level.var_f302359b[i].script_parameters] Hide();
			level.dragon_bodies[j][level.var_f302359b[i].script_parameters] useanimtree(-1);
			level.var_abd9e961[j][level.var_f302359b[i].script_parameters] = GetEnt(j, level.var_f302359b[i].script_label + "_mini", "targetname");
		}
		Array::run_all(level.var_abd9e961[j], &function_c9ca8c4b, j);
	}
	level.weap_quest_init = 1;
}

/*
	Name: soul_catcher_callback
	Namespace: zm_castle_weap_quest
	Checksum: 0x9156A2AB
	Offset: 0x10F0
	Size: 0x5E3
	Parameters: 7
	Flags: None
*/
function soul_catcher_callback(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	while(!isdefined(level.weap_quest_init))
	{
		wait(0.05);
	}
	if(newVal == 7)
	{
		if(isdefined(level.dragon_heads[localClientNum][fieldName]))
		{
			level.dragon_heads[localClientNum][fieldName] thread function_a5ee5367(localClientNum);
		}
	}
	else if(newVal == 1)
	{
		level.dragon_bodies[localClientNum][fieldName] Hide();
		if(isdefined(level.dragon_heads[localClientNum][fieldName]))
		{
			level.dragon_heads[localClientNum][fieldName] show();
			level.dragon_heads[localClientNum][fieldName] thread function_2731927f(localClientNum);
			level.dragon_heads[localClientNum][fieldName] scene::Play(level.var_dd277883, level.dragon_heads[localClientNum][fieldName]);
		}
	}
	else if(newVal == 2)
	{
		level.dragon_bodies[localClientNum][fieldName] Hide();
		if(isdefined(level.dragon_bodies[localClientNum][fieldName].head))
		{
			if(isdefined(level.dragon_bodies[localClientNum][fieldName].head.hat))
			{
				level.dragon_bodies[localClientNum][fieldName].head.hat Hide();
			}
			level.dragon_bodies[localClientNum][fieldName].head Hide();
		}
		if(isdefined(level.dragon_heads[localClientNum][fieldName]))
		{
			level.dragon_heads[localClientNum][fieldName] show();
			level.dragon_heads[localClientNum][fieldName] thread dragonhead_idle(localClientNum);
		}
	}
	else if(newVal == 3 || newVal == 5 || newVal == 4)
	{
		if(isdefined(level.dragon_heads[localClientNum][fieldName]))
		{
			level.dragon_heads[localClientNum][fieldName] show();
			if(newVal == 3)
			{
				level.dragon_heads[localClientNum][fieldName] thread function_4ae89880(level.dragon_bodies[localClientNum][fieldName], localClientNum, "front");
			}
			else if(newVal == 4)
			{
				level.dragon_heads[localClientNum][fieldName] thread function_4ae89880(level.dragon_bodies[localClientNum][fieldName], localClientNum, "right");
			}
			else
			{
				level.dragon_heads[localClientNum][fieldName] thread function_4ae89880(level.dragon_bodies[localClientNum][fieldName], localClientNum, "left");
			}
		}
	}
	else if(newVal == 6)
	{
		level.dragon_bodies[localClientNum][fieldName] Hide();
		if(isdefined(level.dragon_bodies[localClientNum][fieldName].head))
		{
			if(isdefined(level.dragon_bodies[localClientNum][fieldName].head.hat))
			{
				level.dragon_bodies[localClientNum][fieldName].head.hat Hide();
			}
			level.dragon_bodies[localClientNum][fieldName].head Hide();
		}
		if(isdefined(level.dragon_heads[localClientNum][fieldName]))
		{
			level.dragon_heads[localClientNum][fieldName] show();
			level.dragon_heads[localClientNum][fieldName] thread function_aba7532b(localClientNum, level.dragon_bodies[localClientNum][fieldName], level.var_abd9e961[localClientNum][fieldName]);
		}
	}
	else if(newVal == 0)
	{
		level.dragon_heads[localClientNum][fieldName] thread function_8e438650();
	}
}

/*
	Name: function_2731927f
	Namespace: zm_castle_weap_quest
	Checksum: 0xF06BFB33
	Offset: 0x16E0
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function function_2731927f(localClientNum)
{
	ForceStreamXModel("c_zom_dragonhead_e");
	self function_c54660fa(localClientNum);
	self SetModel("c_zom_dragonhead_e");
	StopForceStreamingXModel("c_zom_dragonhead_e");
	self thread function_aa74062f(localClientNum);
}

/*
	Name: function_c54660fa
	Namespace: zm_castle_weap_quest
	Checksum: 0x65EFC1B9
	Offset: 0x1778
	Size: 0x207
	Parameters: 1
	Flags: None
*/
function function_c54660fa(localClientNum)
{
	n_start_time = GetTime();
	n_end_time = n_start_time + 3.6 * 1000;
	var_2f4dbfb7 = n_start_time + 0.5 * 1000;
	b_is_updating = 1;
	while(b_is_updating)
	{
		n_time = GetTime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_time);
		}
		if(n_time >= var_2f4dbfb7)
		{
			var_da3d41af = mapfloat(n_start_time, var_2f4dbfb7, 0, 3, var_2f4dbfb7);
		}
		else
		{
			var_da3d41af = mapfloat(n_start_time, var_2f4dbfb7, 0, 3, n_time);
		}
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, var_da3d41af, 0);
		self MapShaderConstant(localClientNum, 0, "scriptVector0", n_shader_value, 0, 0);
		wait(0.01);
	}
}

/*
	Name: function_2ea674b8
	Namespace: zm_castle_weap_quest
	Checksum: 0x46AEC7D
	Offset: 0x1988
	Size: 0x15F
	Parameters: 1
	Flags: None
*/
function function_2ea674b8(localClientNum)
{
	n_start_time = GetTime();
	n_end_time = n_start_time + 7 * 1000;
	b_is_updating = 1;
	while(b_is_updating && isdefined(self))
	{
		n_time = GetTime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 0, 1, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 0, 1, n_time);
		}
		self MapShaderConstant(localClientNum, 0, "scriptVector0", n_shader_value, 0, 0);
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, 0, 0);
		wait(0.01);
	}
}

/*
	Name: function_aa74062f
	Namespace: zm_castle_weap_quest
	Checksum: 0x95F0896E
	Offset: 0x1AF0
	Size: 0x12F
	Parameters: 1
	Flags: None
*/
function function_aa74062f(localClientNum)
{
	n_start_time = GetTime();
	n_end_time = n_start_time + 5 * 1000;
	b_is_updating = 1;
	while(b_is_updating)
	{
		n_time = GetTime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 0, 2, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 0, 2, n_time);
		}
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, n_shader_value, 0);
		wait(0.01);
	}
}

/*
	Name: function_a5ee5367
	Namespace: zm_castle_weap_quest
	Checksum: 0x113AB1A7
	Offset: 0x1C28
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_a5ee5367(localClientNum)
{
	self MapShaderConstant(localClientNum, 0, "scriptVector0", 1, 0, 0);
	self thread scene::Play(level.var_b86a93ed, self);
}

/*
	Name: dragonhead_idle
	Namespace: zm_castle_weap_quest
	Checksum: 0xFD1E4ED3
	Offset: 0x1C88
	Size: 0xDF
	Parameters: 1
	Flags: None
*/
function dragonhead_idle(localClientNum)
{
	self endon("dragon_eating");
	self endon("dragon_departing");
	self notify("dragon_idling");
	if(isdefined(self.var_d90397ef) && self.var_d90397ef)
	{
		return;
	}
	self.var_d90397ef = 1;
	while(1)
	{
		random_idle_anim = Array::random(level.var_93ad1521);
		self scene::Play(random_idle_anim, self);
		random_twitch_anim = Array::random(level.var_16db17aa);
		self scene::Play(random_twitch_anim, self);
	}
}

/*
	Name: pose_dead_body
	Namespace: zm_castle_weap_quest
	Checksum: 0xB10C46AC
	Offset: 0x1D70
	Size: 0x29D
	Parameters: 7
	Flags: None
*/
function pose_dead_body(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	if(!self hasdobj(localClientNum))
	{
		self util::waittill_dobj(localClientNum);
		wait(0.016);
	}
	while(!isdefined(level.weap_quest_init))
	{
		wait(0.05);
	}
	if(!isdefined(self))
	{
		return;
	}
	s_closest = Array::get_all_closest(self.origin, level.var_f302359b);
	fieldName = s_closest[0].script_parameters;
	m_body = level.dragon_bodies[localClientNum][fieldName];
	if(isdefined(m_body))
	{
		m_body delete();
		m_body = GibClientUtils::CreateScriptModelOfEntity(localClientNum, self);
		if(IsSubStr(m_body.model, "skeleton"))
		{
			m_body HidePart(localClientNum, "tag_weapon_left");
			m_body HidePart(localClientNum, "tag_weapon_right");
		}
		m_body GibClientUtils::HandleGibNotetracks(localClientNum);
		level.dragon_bodies[localClientNum][fieldName] = m_body;
	}
	m_body useanimtree(-1);
	m_body.origin = self.origin;
	m_body show();
	m_body ClearAnim(%root, 0.1);
	m_body SetAnimRestart(level.fake_body_death_anim, 1, 0.2, 1);
	n_anim_time = getanimlength(level.fake_body_death_anim) / 1;
}

/*
	Name: function_4bdc99a
	Namespace: zm_castle_weap_quest
	Checksum: 0xAADB632A
	Offset: 0x2018
	Size: 0x1BB
	Parameters: 4
	Flags: None
*/
function function_4bdc99a(m_body, m_dragon, localClientNum, direction)
{
	/#
		IPrintLnBold("Dev Block strings are not supported" + direction);
	#/
	var_3b282900 = level.var_c7a1f434[direction];
	if(m_dragon flag::get("dragon_far_left") && direction == "right")
	{
		var_3b282900 = level.var_c7a1f434["left_2_right"];
	}
	else if(m_dragon flag::get("dragon_far_right") && direction == "left")
	{
		var_3b282900 = level.var_c7a1f434["right_2_left"];
	}
	s_scenedef = struct::get_script_bundle("scene", var_3b282900);
	var_3c6f5c75 = s_scenedef.objects[0].mainanim;
	m_body Unlink();
	m_body show();
	m_body thread function_939ae9de(m_dragon, localClientNum, direction, var_3c6f5c75);
	m_dragon scene::Play(var_3b282900, m_dragon);
}

/*
	Name: function_8cce2397
	Namespace: zm_castle_weap_quest
	Checksum: 0x63737E2D
	Offset: 0x21E0
	Size: 0x10F
	Parameters: 1
	Flags: None
*/
function function_8cce2397(a_ents)
{
	self notify("hash_7291a140");
	self endon("hash_7291a140");
	self endon("dragon_eating");
	self endon("dragon_departing");
	while(1)
	{
		self waittillmatch("_anim_notify_");
		self flag::set("dragon_far_right");
		self waittillmatch("_anim_notify_");
		self flag::clear("dragon_far_right");
		self waittillmatch("_anim_notify_");
		self flag::set("dragon_far_left");
		self waittillmatch("_anim_notify_");
		self flag::clear("dragon_far_left");
	}
}

/*
	Name: function_def5820e
	Namespace: zm_castle_weap_quest
	Checksum: 0x9FFB944
	Offset: 0x22F8
	Size: 0x10F
	Parameters: 1
	Flags: None
*/
function function_def5820e(a_ents)
{
	self notify("hash_7291a140");
	self endon("hash_7291a140");
	self endon("dragon_eating");
	self endon("dragon_departing");
	while(1)
	{
		self waittillmatch("_anim_notify_");
		self flag::set("dragon_far_left");
		self waittillmatch("_anim_notify_");
		self flag::clear("dragon_far_left");
		self waittillmatch("_anim_notify_");
		self flag::set("dragon_far_right");
		self waittillmatch("_anim_notify_");
		self flag::clear("dragon_far_right");
	}
}

/*
	Name: function_939ae9de
	Namespace: zm_castle_weap_quest
	Checksum: 0xD7F1E87B
	Offset: 0x2410
	Size: 0x385
	Parameters: 4
	Flags: None
*/
function function_939ae9de(m_dragon, localClientNum, direction, var_3c6f5c75)
{
	if(!isdefined(self.m_soul_fx_player))
	{
		self.m_soul_fx_player = spawn(localClientNum, self GetTagOrigin("J_SpineLower"), "script_model");
		self.m_soul_fx_player SetModel("tag_origin");
	}
	self ClearAnim(%root, 0.2);
	self SetAnimRestart("ai_zm_dlc1_dragonhead_zombie_rise");
	vec_dir = m_dragon.origin - self.origin;
	vec_dir_scaled = VectorScale(vec_dir, 0.2);
	self.m_soul_fx_player.angles = VectorToAngles(vec_dir);
	self.m_soul_fx_player LinkTo(self);
	wait(0.3);
	if(!isdefined(self))
	{
		return;
	}
	animlength = getanimlength(var_3c6f5c75);
	animlength = animlength - animlength * m_dragon GetAnimTime(var_3c6f5c75);
	animlength = max(animlength, 0.05);
	self moveto(self.origin + vec_dir_scaled, animlength * 0.75, animlength * 0.75, 0);
	var_31e7de73 = m_dragon GetTagAngles("tag_attach");
	self RotateTo(var_31e7de73, animlength * 0.75);
	self waittill("movedone");
	animlength = getanimlength(var_3c6f5c75);
	animlength = animlength - animlength * m_dragon GetAnimTime(var_3c6f5c75);
	animlength = max(animlength, 0.05);
	var_6b61dff7 = m_dragon GetTagOrigin("tag_attach");
	self moveto(var_6b61dff7, animlength, animlength, 0);
	self waittill("movedone");
	if(!isdefined(self))
	{
		return;
	}
	if(isdefined(self.m_soul_fx_player))
	{
		self.m_soul_fx_player Unlink();
		self.m_soul_fx_player delete();
		self.m_soul_fx_player = undefined;
	}
}

/*
	Name: function_4ae89880
	Namespace: zm_castle_weap_quest
	Checksum: 0x9F166A76
	Offset: 0x27A0
	Size: 0x223
	Parameters: 3
	Flags: None
*/
function function_4ae89880(body, localClientNum, direction)
{
	self endon("dragon_idling");
	self endon("dragon_departing");
	self notify("dragon_eating");
	self.var_d90397ef = 0;
	s_closest = Array::get_all_closest(self.origin, level.var_f302359b);
	fieldName = s_closest[0].script_parameters;
	m_body = level.dragon_bodies[localClientNum][fieldName];
	m_dragon = level.dragon_heads[localClientNum][fieldName];
	level function_4bdc99a(m_body, m_dragon, localClientNum, direction);
	if(!isdefined(m_dragon) || !isdefined(m_body))
	{
		return;
	}
	m_body.animName = "zombie";
	m_dragon.animName = "dragon";
	self thread play_blood_fx_on_bite(localClientNum);
	self scene::Play(level.var_977975d2[direction], Array(m_body, m_dragon));
	if(!isdefined(m_dragon) || !isdefined(m_body))
	{
		return;
	}
	m_body.animName = "";
	m_dragon.animName = "";
	playsound(0, "zmb_weap_wall", m_dragon.origin);
	m_dragon thread dragonhead_idle(localClientNum);
}

/*
	Name: play_blood_fx_on_bite
	Namespace: zm_castle_weap_quest
	Checksum: 0xFEC7B7A0
	Offset: 0x29D0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function play_blood_fx_on_bite(localClientNum)
{
	while(1)
	{
		self waittill("bite", note);
		if(note == "blood")
		{
		}
		else
		{
		}
	}
}

/*
	Name: function_aba7532b
	Namespace: zm_castle_weap_quest
	Checksum: 0xB361205C
	Offset: 0x2A30
	Size: 0x18B
	Parameters: 3
	Flags: None
*/
function function_aba7532b(localClientNum, body, mini)
{
	if(isdefined(self.b_depart) && self.b_depart)
	{
		self notify("dragon_departing");
		self.b_depart = undefined;
		var_1656bbd4 = level.var_a79e1598[self.targetname];
		self.var_d90397ef = 0;
		forcestreambundle(level.var_a79e1598[self.targetname]);
		self SetModel("c_zom_dragonhead");
		self thread function_2ea674b8(localClientNum);
		self scene::Play(level.var_160f7e80, self);
		mini thread function_63f39fc0(localClientNum);
		self thread scene::Play(var_1656bbd4);
		if(isdefined(self))
		{
			self Hide();
		}
		StopForceStreamingXModel("p7_fxanim_zm_castle_dragon_chunks_mod");
		StopForceStreamingXModel("c_zom_dragonhead");
	}
	else if(isdefined(self))
	{
		self Hide();
	}
}

/*
	Name: function_c9ca8c4b
	Namespace: zm_castle_weap_quest
	Checksum: 0x1FAB82B
	Offset: 0x2BC8
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function function_c9ca8c4b(localClientNum)
{
	self MapShaderConstant(localClientNum, 0, "scriptVector0", 1, 0, 0);
}

/*
	Name: function_63f39fc0
	Namespace: zm_castle_weap_quest
	Checksum: 0x3CD014E3
	Offset: 0x2C08
	Size: 0x127
	Parameters: 1
	Flags: None
*/
function function_63f39fc0(localClientNum)
{
	ForceStreamXModel("c_zom_dragonhead_small_e");
	self function_c54660fa(localClientNum);
	self SetModel("c_zom_dragonhead_small_e");
	StopForceStreamingXModel("c_zom_dragonhead_small_e");
	self function_aa74062f(localClientNum);
	PlayFXOnTag(localClientNum, level._effect["mini_dragon_eye"], self, "tag_eye_left_fx");
	while(1)
	{
		wait(randomIntRange(20, 40));
		PlayFXOnTag(localClientNum, level._effect["mini_dragon_fire"], self, "tag_throat_fx");
		wait(randomIntRange(3, 5));
	}
}

/*
	Name: assemble_fake_body_head_arrays
	Namespace: zm_castle_weap_quest
	Checksum: 0x8EC37435
	Offset: 0x2D38
	Size: 0x61
	Parameters: 0
	Flags: None
*/
function assemble_fake_body_head_arrays()
{
	level.var_9c6cddc9[1] = "c_zom_der_zombie_head1";
	level.var_9c6cddc9[2] = "c_zom_der_zombie_head1";
	level.var_9c6cddc9[3] = "c_zom_der_zombie_head1";
	level.var_9c6cddc9[4] = "c_zom_der_zombie_head1";
}

/*
	Name: function_8e438650
	Namespace: zm_castle_weap_quest
	Checksum: 0x8943AC47
	Offset: 0x2DA8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_8e438650()
{
	ForceStreamXModel("p7_fxanim_zm_castle_dragon_chunks_mod");
	ForceStreamXModel("c_zom_dragonhead");
}

/*
	Name: function_4e75b7c1
	Namespace: zm_castle_weap_quest
	Checksum: 0x784F4360
	Offset: 0x2DE8
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function function_4e75b7c1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		exploder::exploder("lgt_bow_family");
	}
	else
	{
		exploder::stop_exploder("lgt_bow_family");
	}
	s_bow_pickup = struct::get("base_bow_pickup_struct", "targetname");
	if(isdefined(s_bow_pickup))
	{
		playFX(localClientNum, level._effect["bow_spawn_fx"], s_bow_pickup.origin);
	}
}

