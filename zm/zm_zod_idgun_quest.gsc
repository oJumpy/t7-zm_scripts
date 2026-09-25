#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_raps;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_idgun;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_zod_smashables;
#using scripts\zm\zm_zod_sword_quest;
#using scripts\zm\zm_zod_util;
#using scripts\zm\zm_zod_vo;

#namespace zm_zod_idgun_quest;

/*
	Name: __init__sytem__
	Namespace: zm_zod_idgun_quest
	Checksum: 0xC1DDEEC0
	Offset: 0x600
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_idgun_quest", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_idgun_quest
	Checksum: 0x5D65E931
	Offset: 0x648
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	clientfield::register("world", "add_idgun_to_box", 1, 4, "int");
	clientfield::register("world", "remove_idgun_from_box", 1, 4, "int");
	level flag::init("second_idgun_time");
	for(i = 0; i < 3; i++)
	{
		level flag::init("idgun_cocoon_" + i + "_found");
	}
	/#
		level thread function_1c946455();
		level thread function_e4e5cd30();
	#/
}

/*
	Name: __main__
	Namespace: zm_zod_idgun_quest
	Checksum: 0xB38D215E
	Offset: 0x798
	Size: 0x1EF
	Parameters: 0
	Flags: None
*/
function __main__()
{
	var_fd261f68 = Array("idgun_0", "idgun_1", "idgun_2", "idgun_3");
	level function_436486f7();
	zm_spawner::register_zombie_death_event_callback(&function_101cc4e2);
	for(i = 0; i < 2; i++)
	{
		level.idgun[i] = spawnstruct();
		level.idgun[i].kill_count = 0;
		level.idgun[i].var_356fbd8b = i;
		var_fd261f68 = Array::randomize(var_fd261f68);
		level.idgun[i].var_e4be281f = Array::pop_front(var_fd261f68);
		zm_weapons::add_limited_weapon(level.idgun[i].var_e4be281f, 1);
		for(j = 0; j < level.idgun_weapons.size; j++)
		{
			if(level.idgun[i].var_e4be281f == level.idgun_weapons[j].name)
			{
				level.idgun[i].var_e787e99a = j;
				break;
			}
		}
	}
	wait(0.5);
}

/*
	Name: function_e1efbc50
	Namespace: zm_zod_idgun_quest
	Checksum: 0x8B83F51F
	Offset: 0x990
	Size: 0x89
	Parameters: 1
	Flags: None
*/
function function_e1efbc50(var_9727e47e)
{
	if(var_9727e47e != level.weaponNone)
	{
		if(!isdefined(level.idgun_weapons))
		{
			level.idgun_weapons = [];
		}
		else if(!IsArray(level.idgun_weapons))
		{
			level.idgun_weapons = Array(level.idgun_weapons);
		}
		level.idgun_weapons[level.idgun_weapons.size] = var_9727e47e;
	}
}

/*
	Name: function_436486f7
	Namespace: zm_zod_idgun_quest
	Checksum: 0x283CFE5B
	Offset: 0xA28
	Size: 0x153
	Parameters: 0
	Flags: None
*/
function function_436486f7()
{
	level.idgun_weapons = [];
	function_e1efbc50(GetWeapon("idgun_0"));
	function_e1efbc50(GetWeapon("idgun_1"));
	function_e1efbc50(GetWeapon("idgun_2"));
	function_e1efbc50(GetWeapon("idgun_3"));
	function_e1efbc50(GetWeapon("idgun_upgraded_0"));
	function_e1efbc50(GetWeapon("idgun_upgraded_1"));
	function_e1efbc50(GetWeapon("idgun_upgraded_2"));
	function_e1efbc50(GetWeapon("idgun_upgraded_3"));
}

/*
	Name: on_player_connect
	Namespace: zm_zod_idgun_quest
	Checksum: 0x99EC1590
	Offset: 0xB88
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
}

/*
	Name: on_player_spawned
	Namespace: zm_zod_idgun_quest
	Checksum: 0x99EC1590
	Offset: 0xB98
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
}

/*
	Name: function_14e2eca6
	Namespace: zm_zod_idgun_quest
	Checksum: 0xF6C8B2D9
	Offset: 0xBA8
	Size: 0x247
	Parameters: 1
	Flags: None
*/
function function_14e2eca6(params)
{
	if(level.round_number < 12)
	{
		return;
	}
	if(self.does_not_count_to_round === 1)
	{
		return;
	}
	if(level flag::get("part_xenomatter" + "_found"))
	{
		return;
	}
	if(isdefined(level.var_689ff92e) && level.var_689ff92e)
	{
		return;
	}
	if(!isPlayer(params.eAttacker))
	{
		return;
	}
	n_rand = RandomFloatRange(0, 1);
	if(n_rand >= 0.1)
	{
		return;
	}
	level.var_689ff92e = 1;
	var_dad4b542 = self GetOrigin();
	var_72cd7c0a = GetClosestPointOnNavMesh(var_dad4b542, 500, 0);
	var_ca79e2ce = (var_dad4b542[0], var_dad4b542[1], 0);
	var_dcaa8f8e = (var_72cd7c0a[0], var_72cd7c0a[1], 0);
	if(var_ca79e2ce == var_dcaa8f8e)
	{
		function_f5469e1(var_72cd7c0a, "part_xenomatter");
	}
	if(!level flag::get("part_xenomatter" + "_found"))
	{
		var_71e3d70a = level zm_craftables::get_craftable_piece_model("idgun", "part_xenomatter");
		var_55d0f940 = struct::get("safe_place_for_items", "targetname");
		var_71e3d70a.origin = var_55d0f940.origin;
		level.var_689ff92e = 0;
	}
}

/*
	Name: function_c3ffc175
	Namespace: zm_zod_idgun_quest
	Checksum: 0x885CFA7E
	Offset: 0xDF8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_c3ffc175()
{
	if(level clientfield::get("bm_superbeast"))
	{
		function_6baaa92e();
	}
	else if(self.var_89905c65 !== 1)
	{
		function_44e0f6b4();
	}
}

/*
	Name: function_44e0f6b4
	Namespace: zm_zod_idgun_quest
	Checksum: 0xB1E0CC54
	Offset: 0xE68
	Size: 0x17F
	Parameters: 0
	Flags: None
*/
function function_44e0f6b4()
{
	if(GetDvarInt("splitscreen_playerCount") > 2 && (!isdefined(level.var_5fadf2ff) && level.var_5fadf2ff))
	{
		function_6893c200();
		return;
	}
	if(isdefined(level.var_359f6a1d) && level.var_359f6a1d)
	{
		return;
	}
	level.var_359f6a1d = 1;
	drop_point = self GetOrigin();
	drop_point = drop_point + VectorScale((0, 0, 1), 30);
	function_f5469e1(drop_point, "part_heart");
	if(!level flag::get("part_heart" + "_found"))
	{
		var_71e3d70a = level zm_craftables::get_craftable_piece_model("idgun", "part_heart");
		var_55d0f940 = struct::get("safe_place_for_items", "targetname");
		var_71e3d70a.origin = var_55d0f940.origin;
		level.var_359f6a1d = 0;
	}
}

/*
	Name: function_6893c200
	Namespace: zm_zod_idgun_quest
	Checksum: 0xAA00D251
	Offset: 0xFF0
	Size: 0x117
	Parameters: 0
	Flags: None
*/
function function_6893c200()
{
	level.var_5fadf2ff = 1;
	drop_point = self GetOrigin();
	drop_point = drop_point + VectorScale((0, 0, 1), 30);
	function_f5469e1(drop_point, "part_skeleton");
	if(!level flag::get("part_skeleton" + "_found"))
	{
		var_71e3d70a = level zm_craftables::get_craftable_piece_model("idgun", "part_skeleton");
		var_55d0f940 = struct::get("safe_place_for_items", "targetname");
		var_71e3d70a.origin = var_55d0f940.origin;
		level.var_5fadf2ff = 0;
	}
}

/*
	Name: function_6baaa92e
	Namespace: zm_zod_idgun_quest
	Checksum: 0xBDE7DF9
	Offset: 0x1110
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function function_6baaa92e()
{
	drop_point = self GetOrigin();
	drop_point = drop_point + VectorScale((0, 0, 1), 30);
	var_5404ad23 = spawn("script_model", drop_point);
	var_5404ad23 SetModel("p7_zm_zod_margwa_heart");
	function_a3712047(var_5404ad23);
}

/*
	Name: function_a3712047
	Namespace: zm_zod_idgun_quest
	Checksum: 0x84D2FF7F
	Offset: 0x11B8
	Size: 0x193
	Parameters: 1
	Flags: None
*/
function function_a3712047(var_5404ad23)
{
	width = 128;
	height = 128;
	length = 128;
	var_5404ad23.unitrigger_stub = spawnstruct();
	var_5404ad23.unitrigger_stub.origin = var_5404ad23.origin;
	var_5404ad23.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	var_5404ad23.unitrigger_stub.cursor_hint = "HINT_NOICON";
	var_5404ad23.unitrigger_stub.script_width = width;
	var_5404ad23.unitrigger_stub.script_height = height;
	var_5404ad23.unitrigger_stub.script_length = length;
	var_5404ad23.unitrigger_stub.require_look_at = 0;
	var_5404ad23.unitrigger_stub.prompt_and_visibility_func = &function_12fffd19;
	zm_unitrigger::register_static_unitrigger(var_5404ad23.unitrigger_stub, &function_dd2f6fe3);
	wait(5);
	var_5404ad23 delete();
}

/*
	Name: function_12fffd19
	Namespace: zm_zod_idgun_quest
	Checksum: 0x48A555F6
	Offset: 0x1358
	Size: 0x61
	Parameters: 1
	Flags: None
*/
function function_12fffd19(player)
{
	b_is_invis = isdefined(player.beastmode) && player.beastmode;
	self SetInvisibleToPlayer(player, b_is_invis);
	return !b_is_invis;
}

/*
	Name: function_dd2f6fe3
	Namespace: zm_zod_idgun_quest
	Checksum: 0xE5974A5A
	Offset: 0x13C8
	Size: 0xB9
	Parameters: 0
	Flags: None
*/
function function_dd2f6fe3()
{
	while(1)
	{
		self waittill("trigger", player);
		if(player zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(player.IS_DRINKING > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(player))
		{
			continue;
		}
		player thread zm_audio::create_and_play_dialog("margwa", "heart_pickup");
		level thread function_32d36516(self);
		return;
	}
}

/*
	Name: function_32d36516
	Namespace: zm_zod_idgun_quest
	Checksum: 0x5BA6E2F2
	Offset: 0x1490
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function function_32d36516(var_5404ad23)
{
	foreach(player in level.activePlayers)
	{
		player RevivePlayer();
	}
	var_5404ad23 delete();
}

/*
	Name: function_f5469e1
	Namespace: zm_zod_idgun_quest
	Checksum: 0x32C4DBC8
	Offset: 0x1548
	Size: 0x1E9
	Parameters: 4
	Flags: None
*/
function function_f5469e1(v_origin, str_part, var_1907d45e, var_6a2f1c3a)
{
	if(!isdefined(var_1907d45e))
	{
		var_1907d45e = 1;
	}
	if(!isdefined(var_6a2f1c3a))
	{
		var_6a2f1c3a = 0;
	}
	level endon("hash_14edc619");
	if(!var_6a2f1c3a)
	{
		var_71e3d70a = level zm_craftables::get_craftable_piece_model("idgun", str_part);
	}
	else
	{
		var_71e3d70a = level zm_craftables::get_craftable_piece_model("second_idgun", str_part);
	}
	var_71e3d70a.origin = v_origin;
	playable_area = GetEntArray("player_volume", "script_noteworthy");
	valid_drop = 0;
	for(i = 0; i < playable_area.size; i++)
	{
		if(var_71e3d70a istouching(playable_area[i]))
		{
			valid_drop = 1;
		}
	}
	if(!valid_drop)
	{
		var_71e3d70a SetInvisibleToAll();
		return;
	}
	var_71e3d70a SetVisibleToAll();
	if(!var_1907d45e)
	{
		return;
	}
	wait(10);
	level thread function_21ad8866(var_71e3d70a);
	wait(10);
	var_71e3d70a SetInvisibleToAll();
	level notify("hash_21ad8866");
}

/*
	Name: function_21ad8866
	Namespace: zm_zod_idgun_quest
	Checksum: 0x349E75F1
	Offset: 0x1740
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function function_21ad8866(var_71e3d70a)
{
	level notify("hash_21ad8866");
	level endon("hash_21ad8866");
	level endon("hash_14edc619");
	while(1)
	{
		var_71e3d70a SetInvisibleToAll();
		wait(0.5);
		var_71e3d70a SetVisibleToAll();
		wait(0.5);
	}
}

/*
	Name: function_e70e794e
	Namespace: zm_zod_idgun_quest
	Checksum: 0x7EF2E29E
	Offset: 0x17C8
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function function_e70e794e(var_bd705d9a)
{
	if(isdefined(var_bd705d9a.is_speaking) && var_bd705d9a.is_speaking)
	{
		return;
	}
}

/*
	Name: function_101cc4e2
	Namespace: zm_zod_idgun_quest
	Checksum: 0xE6DC09AA
	Offset: 0x1808
	Size: 0x12D
	Parameters: 1
	Flags: None
*/
function function_101cc4e2(attacker)
{
	for(i = 0; i < level.idgun_weapons.size; i++)
	{
		var_d2af076 = level.idgun_weapons[i];
		if(!isdefined(self))
		{
			return;
		}
		if(self.damageWeapon === var_d2af076)
		{
			idgun = function_b9729f28(self.attacker);
			if(!isdefined(idgun))
			{
				return;
			}
			idgun.kill_count++;
			if(level flag::get("second_idgun_time"))
			{
				return;
			}
			if(idgun.kill_count > 10)
			{
				level flag::set("second_idgun_time");
				idgun.owner namespace_b8707f8e::function_1a180bd3("vox_idgun_upgrade_ready");
			}
		}
	}
}

/*
	Name: function_b9729f28
	Namespace: zm_zod_idgun_quest
	Checksum: 0x7114FF0D
	Offset: 0x1940
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_b9729f28(player)
{
	for(i = 0; i < 2; i++)
	{
		if(level.idgun[i].owner === player)
		{
			return level.idgun[i];
		}
	}
}

/*
	Name: function_b4c3b798
	Namespace: zm_zod_idgun_quest
	Checksum: 0x78A12DB5
	Offset: 0x19B0
	Size: 0x255
	Parameters: 0
	Flags: None
*/
function function_b4c3b798()
{
	level flag::wait_till("second_idgun_time");
	var_ffcd34fb = struct::get_array("idgun_cocoon_point", "targetname");
	if(!isdefined(level.var_a26610f1))
	{
		level.var_a26610f1 = [];
	}
	for(i = 0; i < 3; i++)
	{
		switch(i)
		{
			case 0:
			{
				var_d42f02cf = "theater";
				str_part = "part_heart";
				break;
			}
			case 1:
			{
				var_d42f02cf = "slums";
				str_part = "part_skeleton";
				break;
			}
			case 2:
			{
				var_d42f02cf = "canal";
				str_part = "part_xenomatter";
				break;
			}
		}
		var_c6a8002 = Array::filter(var_ffcd34fb, 0, &function_1bfbfa4c, var_d42f02cf);
		level.var_a26610f1[i] = Array::random(var_c6a8002);
		var_e6d966e = spawn("script_model", level.var_a26610f1[i].origin);
		var_e6d966e SetModel("p7_zm_zod_cocoon");
		var_e6d966e SetCanDamage(1);
		var_e6d966e thread function_47867b41(i, str_part);
		if(isdefined(level.idgun[0].owner))
		{
			level.idgun[0].owner thread function_538643a3(i);
		}
	}
}

/*
	Name: function_1bfbfa4c
	Namespace: zm_zod_idgun_quest
	Checksum: 0xC809A9E1
	Offset: 0x1C10
	Size: 0x47
	Parameters: 2
	Flags: None
*/
function function_1bfbfa4c(e_entity, var_d42f02cf)
{
	if(!isdefined(e_entity.script_string) || e_entity.script_string != var_d42f02cf)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_47867b41
	Namespace: zm_zod_idgun_quest
	Checksum: 0x6FB988F5
	Offset: 0x1C60
	Size: 0x279
	Parameters: 2
	Flags: None
*/
function function_47867b41(var_3fbc06aa, str_part)
{
	while(1)
	{
		self waittill("damage", amount, attacker, direction_vec, point, type, tagName, modelName, partName, weapon);
		level flag::set("idgun_cocoon_" + var_3fbc06aa + "_found");
		if(isdefined(zm::is_idgun_damage(weapon)) && zm::is_idgun_damage(weapon) === 0)
		{
			return;
		}
		self show();
		v_origin = self GetOrigin();
		direction_vec = (0, 0, -1);
		scale = 8000;
		direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
		trace = bullettrace(v_origin, v_origin + direction_vec, 0, undefined);
		drop_point = trace["position"];
		drop_point = drop_point + VectorScale((0, 0, 1), 10);
		self moveto(drop_point, 1);
		wait(1);
		self Hide();
		playFX(level._effect["idgun_cocoon_off"], self.origin);
		function_f5469e1(drop_point, str_part, 0, 1);
		return;
	}
}

/*
	Name: function_538643a3
	Namespace: zm_zod_idgun_quest
	Checksum: 0xE68DD99B
	Offset: 0x1EE8
	Size: 0x3E3
	Parameters: 1
	Flags: None
*/
function function_538643a3(var_3fbc06aa)
{
	self endon("bleed_out");
	self endon("death");
	self endon("disconnect");
	var_e610614b = level.var_a26610f1[var_3fbc06aa].origin;
	var_76cf6eef = 262144;
	var_9d192e2d = 4096;
	var_2509d2fc = var_76cf6eef - var_9d192e2d;
	var_4a166ae5 = 0.7;
	var_f6b0cbe4 = undefined;
	var_ac3d0ec3 = undefined;
	n_scale = undefined;
	var_887c2fcb = undefined;
	while(1)
	{
		var_5cc8da3f = self GetCurrentWeapon();
		var_3262a5f7 = GetWeapon(level.idgun[0].var_e4be281f);
		if(var_5cc8da3f !== var_3262a5f7)
		{
			wait(0.1);
			break;
		}
		var_888da1cf = (var_e610614b[0], var_e610614b[1], self.origin[2]);
		var_30c97f9b = DistanceSquared(self.origin, var_888da1cf);
		if(var_30c97f9b <= var_76cf6eef)
		{
			var_ac3d0ec3 = 1;
			v_eye_origin = self GetPlayerCameraPos();
			v_eye_direction = AnglesToForward(self getPlayerAngles());
			var_744d3805 = VectorNormalize(var_e610614b - v_eye_origin);
			n_dot = VectorDot(var_744d3805, v_eye_direction);
			if(n_dot > 0.9)
			{
				var_ac3d0ec3 = 0.3;
				n_scale = 1;
				var_887c2fcb = 2;
			}
			else if(n_dot <= 0.5)
			{
				n_dot = 0.5;
				n_scale = n_dot / 0.9;
				var_f6b0cbe4 = n_scale * var_4a166ae5;
				var_ac3d0ec3 = 0.3 + var_f6b0cbe4;
				var_887c2fcb = 1;
			}
			else
			{
				n_scale = n_dot / 0.9;
				var_f6b0cbe4 = n_scale * var_4a166ae5;
				var_ac3d0ec3 = 0.3 + var_f6b0cbe4;
				var_887c2fcb = 1;
			}
		}
		else
		{
			var_ac3d0ec3 = undefined;
		}
		if(level flag::get("idgun_cocoon_" + var_3fbc06aa + "_found"))
		{
			return;
		}
		if(isdefined(var_ac3d0ec3))
		{
			wait(var_ac3d0ec3);
			self namespace_8e578893::function_6edf48d5(2);
			util::wait_network_frame();
			self namespace_8e578893::function_6edf48d5(0);
		}
		else
		{
			wait(0.05);
		}
	}
}

/*
	Name: function_eaadff84
	Namespace: zm_zod_idgun_quest
	Checksum: 0xDB675B88
	Offset: 0x22D8
	Size: 0x17B
	Parameters: 1
	Flags: None
*/
function function_eaadff84(var_f7cef040)
{
	if(var_f7cef040 == 0)
	{
		var_566556d8 = GetWeapon(level.idgun[0].var_e4be281f);
	}
	else
	{
		var_566556d8 = GetWeapon(level.idgun[0].var_e4be281f);
		var_566556d8 = zm_weapons::get_upgrade_weapon(var_566556d8, 0);
	}
	/#
		Assert(isdefined(var_566556d8));
	#/
	self zm_weapons::weapon_give(var_566556d8, 0, 0);
	self SwitchToWeapon(var_566556d8);
	if(!isdefined(level.idgun[0].owner))
	{
		var_6aa62cd2 = 0;
	}
	else if(!isdefined(level.idgun[1].owner))
	{
		var_6aa62cd2 = 1;
	}
	else
	{
		return;
	}
	level.idgun[var_6aa62cd2].owner = self;
	self namespace_b8707f8e::function_aca1bc0c(0);
}

/*
	Name: function_1c946455
	Namespace: zm_zod_idgun_quest
	Checksum: 0xEA757C4E
	Offset: 0x2460
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function function_1c946455()
{
	/#
		level thread namespace_8e578893::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 0, &function_9e990d87);
		level thread namespace_8e578893::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_9e990d87);
		level thread namespace_8e578893::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 1, &function_8c7ac1b9);
	#/
}

/*
	Name: function_e4e5cd30
	Namespace: zm_zod_idgun_quest
	Checksum: 0x8AD5C04E
	Offset: 0x2518
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_e4e5cd30()
{
	/#
		level thread namespace_8e578893::setup_devgui_func("Dev Block strings are not supported", "Dev Block strings are not supported", 0, &function_1f7b4ebf);
	#/
}

/*
	Name: function_9e990d87
	Namespace: zm_zod_idgun_quest
	Checksum: 0xF26F30E3
	Offset: 0x2560
	Size: 0xA9
	Parameters: 1
	Flags: None
*/
function function_9e990d87(n_value)
{
	/#
		foreach(e_player in level.players)
		{
			e_player function_eaadff84(n_value);
			util::wait_network_frame();
		}
	#/
}

/*
	Name: function_1f7b4ebf
	Namespace: zm_zod_idgun_quest
	Checksum: 0xB3198B8E
	Offset: 0x2618
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_1f7b4ebf(n_val)
{
	/#
		level flag::set("Dev Block strings are not supported");
	#/
}

/*
	Name: function_8c7ac1b9
	Namespace: zm_zod_idgun_quest
	Checksum: 0x3CCD0851
	Offset: 0x2650
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_8c7ac1b9(n_value)
{
	/#
		if(isdefined(level.idgun_draw_debug))
		{
			level.idgun_draw_debug = !level.idgun_draw_debug;
		}
		else
		{
			level.idgun_draw_debug = 1;
		}
	#/
}

