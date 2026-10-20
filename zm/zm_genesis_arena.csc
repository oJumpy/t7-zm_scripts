#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_genesis_util;

#namespace zm_genesis_arena;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_arena
	Checksum: 0xABAC82CD
	Offset: 0x878
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_arena", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_arena
	Checksum: 0x86409FD2
	Offset: 0x8B8
	Size: 0x7AB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.var_51541120 = [];
	clientfield::register("world", "arena_state", 15000, GetMinBitCountForNum(5), "int", &arena_state, 0, 0);
	clientfield::register("world", "circle_state", 15000, GetMinBitCountForNum(6), "int", &circle_state, 0, 0);
	clientfield::register("world", "circle_challenge_identity", 15000, GetMinBitCountForNum(6), "int", undefined, 0, 0);
	clientfield::register("world", "summoning_key_charge_state", 15000, GetMinBitCountForNum(4), "int", &summoning_key_charge_state, 0, 1);
	clientfield::register("toplayer", "fire_postfx_set", 15000, 1, "int", &fire_postfx_set, 0, 0);
	clientfield::register("scriptmover", "fire_column", 15000, 1, "int", &fire_column, 0, 0);
	clientfield::register("scriptmover", "summoning_circle_fx", 15000, 1, "int", &summoning_circle_fx, 0, 0);
	clientfield::register("toplayer", "darkness_postfx_set", 15000, 1, "int", &darkness_postfx_set, 0, 0);
	clientfield::register("toplayer", "electricity_postfx_set", 15000, 1, "int", &electricity_postfx_set, 0, 0);
	clientfield::register("world", "light_challenge_floor", 15000, 1, "int", &light_challenge_floor, 0, 0);
	clientfield::register("actor", "arena_margwa_init", 15000, 1, "int", &arena_margwa_init, 0, 0);
	clientfield::register("scriptmover", "arena_tornado", 15000, 1, "int", &arena_tornado, 0, 0);
	clientfield::register("scriptmover", "arena_shadow_pillar", 15000, 1, "int", &arena_shadow_pillar, 0, 0);
	clientfield::register("scriptmover", "elec_wall_tell", 15000, 1, "counter", &elec_wall_tell, 0, 0);
	clientfield::register("world", "summoning_key_pickup", 15000, GetMinBitCountForNum(3), "int", &summoning_key_pickup, 0, 0);
	clientfield::register("world", "arena_timeout_warning", 15000, 1, "int", &arena_timeout_warning, 0, 0);
	clientfield::register("world", "basin_state_0", 15000, GetMinBitCountForNum(5), "int", &basin_state_0, 0, 1);
	clientfield::register("world", "basin_state_1", 15000, GetMinBitCountForNum(5), "int", &basin_state_1, 0, 1);
	clientfield::register("world", "basin_state_2", 15000, GetMinBitCountForNum(5), "int", &basin_state_2, 0, 1);
	clientfield::register("world", "basin_state_3", 15000, GetMinBitCountForNum(5), "int", &basin_state_3, 0, 1);
	clientfield::register("scriptmover", "runeprison_rock_fx", 5000, 1, "int", &runeprison_rock_fx, 0, 0);
	clientfield::register("scriptmover", "runeprison_explode_fx", 5000, 1, "int", &runeprison_explode_fx, 0, 0);
	var_29441edd = struct::get_array("powerup_visual", "targetname");
	foreach(s_powerup_loc in var_29441edd)
	{
		s_powerup_loc.var_90369c89 = [];
	}
	clientfield::register("toplayer", "powerup_visual_marker", 15000, 2, "int", &function_b9c422c3, 0, 1);
}

/*
	Name: summoning_key_charge_state
	Namespace: zm_genesis_arena
	Checksum: 0xA9179433
	Offset: 0x1070
	Size: 0x123
	Parameters: 7
	Flags: None
*/
function summoning_key_charge_state(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_244d3483(localClientNum);
	level.mdl_summoning_key[localClientNum] util::waittill_dobj(localClientNum);
	if(isdefined(level.mdl_summoning_key[localClientNum].var_1397ba8a))
	{
		stopfx(localClientNum, level.mdl_summoning_key[localClientNum].var_1397ba8a);
	}
	level.mdl_summoning_key[localClientNum].var_1397ba8a = PlayFXOnTag(localClientNum, level._effect["summoning_key_charge_" + newVal + 1], level.mdl_summoning_key[localClientNum], "key_root_jnt");
}

/*
	Name: arena_timeout_warning
	Namespace: zm_genesis_arena
	Checksum: 0xD00EF7DA
	Offset: 0x11A0
	Size: 0x129
	Parameters: 7
	Flags: None
*/
function arena_timeout_warning(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	a_players = GetPlayers(localClientNum);
	foreach(player in a_players)
	{
		if(newVal > 0)
		{
			var_946b7723 = 5;
		}
		else
		{
			var_946b7723 = 0;
		}
		player thread zm_genesis_util::player_rumble_and_shake(localClientNum, oldVal, var_946b7723, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
	}
}

/*
	Name: elec_wall_tell
	Namespace: zm_genesis_arena
	Checksum: 0x4E2C699C
	Offset: 0x12D8
	Size: 0x12B
	Parameters: 7
	Flags: None
*/
function elec_wall_tell(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	if(newVal)
	{
		PlayFXOnTag(localClientNum, level._effect["elec_wall_tell"], self, "tag_origin");
		v_origin = self.origin;
		wait(0.25);
		if(isdefined(self))
		{
			FX = playFX(localClientNum, level._effect["elec_wall_arc"], v_origin, AnglesToForward(self.angles));
			self waittill("entityshutdown");
			stopfx(localClientNum, FX);
		}
	}
}

/*
	Name: runeprison_rock_fx
	Namespace: zm_genesis_arena
	Checksum: 0x8E5C403E
	Offset: 0x1410
	Size: 0x175
	Parameters: 7
	Flags: None
*/
function runeprison_rock_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 0:
		{
			self.var_f8ac8c8b animation::Play("p7_fxanim_zm_bow_rune_prison_02_anim");
			if(!isdefined(self))
			{
				return;
			}
			self.var_f8ac8c8b SetModel("p7_fxanim_zm_bow_rune_prison_dissolve_mod");
			self.var_f8ac8c8b thread function_79854312(localClientNum);
			self.var_f8ac8c8b animation::Play("p7_fxanim_zm_bow_rune_prison_dissolve_anim");
			self.var_f8ac8c8b delete();
			break;
		}
		case 1:
		{
			self.var_f8ac8c8b = util::spawn_model(localClientNum, "p7_fxanim_zm_bow_rune_prison_mod", self.origin, self.angles);
			self.var_f8ac8c8b useanimtree(-1);
			self.var_f8ac8c8b animation::Play("p7_fxanim_zm_bow_rune_prison_01_anim");
			break;
		}
	}
}

/*
	Name: function_79854312
	Namespace: zm_genesis_arena
	Checksum: 0xDBDA4F78
	Offset: 0x1590
	Size: 0x117
	Parameters: 1
	Flags: None
*/
function function_79854312(localClientNum)
{
	self endon("entityshutdown");
	n_start_time = GetTime();
	n_end_time = n_start_time + 1633;
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
		self MapShaderConstant(localClientNum, 0, "scriptVector0", n_shader_value, 0, 0);
		wait(0.016);
	}
}

/*
	Name: runeprison_explode_fx
	Namespace: zm_genesis_arena
	Checksum: 0x3973CC21
	Offset: 0x16B0
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function runeprison_explode_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playFX(localClientNum, level._effect["rune_fire_eruption"], self.origin, (0, 0, 1), (1, 0, 0));
	}
}

/*
	Name: basin_state_0
	Namespace: zm_genesis_arena
	Checksum: 0x21E9D9F7
	Offset: 0x1738
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function basin_state_0(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	basin_state(localClientNum, newVal, 0);
}

/*
	Name: basin_state_1
	Namespace: zm_genesis_arena
	Checksum: 0xBF945907
	Offset: 0x17A0
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function basin_state_1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	basin_state(localClientNum, newVal, 1);
}

/*
	Name: basin_state_2
	Namespace: zm_genesis_arena
	Checksum: 0x86561420
	Offset: 0x1808
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function basin_state_2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	basin_state(localClientNum, newVal, 2);
}

/*
	Name: basin_state_3
	Namespace: zm_genesis_arena
	Checksum: 0xBADF53EB
	Offset: 0x1870
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function basin_state_3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	basin_state(localClientNum, newVal, 3);
}

/*
	Name: basin_state
	Namespace: zm_genesis_arena
	Checksum: 0xAD58C89C
	Offset: 0x18D8
	Size: 0xAED
	Parameters: 3
	Flags: None
*/
function basin_state(localClientNum, newVal, var_549b41ba)
{
	function_244d3483(localClientNum);
	level.mdl_summoning_key[localClientNum] util::waittill_dobj(localClientNum);
	switch(newVal)
	{
		case 0:
		{
			if(isdefined(level.var_9431a5ac) && isdefined(level.var_9431a5ac[var_549b41ba]))
			{
				stopfx(localClientNum, level.var_9431a5ac[var_549b41ba]);
			}
			if(isdefined(level.var_1da8ae2))
			{
				stopfx(localClientNum, level.var_1da8ae2);
			}
			level.mdl_summoning_key[localClientNum] Hide();
			if(isdefined(level.var_57b86889) && isdefined(level.var_57b86889[var_549b41ba]))
			{
				stopfx(localClientNum, level.var_57b86889[var_549b41ba]);
			}
			var_e764f9dc = struct::get("clientside_flame_" + var_549b41ba, "targetname");
			audio::stoploopat("zmb_finalfight_key_holder_lp", var_e764f9dc.origin);
			audio::stoploopat("zmb_finalfight_key_charging_lp", var_e764f9dc.origin);
			break;
		}
		case 1:
		{
			if(isdefined(level.var_9431a5ac) && isdefined(level.var_9431a5ac[var_549b41ba]))
			{
				stopfx(localClientNum, level.var_9431a5ac[var_549b41ba]);
			}
			if(isdefined(level.var_1da8ae2))
			{
				stopfx(localClientNum, level.var_1da8ae2);
			}
			level.mdl_summoning_key[localClientNum] Hide();
			if(isdefined(level.var_57b86889) && isdefined(level.var_57b86889[var_549b41ba]))
			{
				stopfx(localClientNum, level.var_57b86889[var_549b41ba]);
			}
			if(!isdefined(level.var_57b86889))
			{
				level.var_57b86889 = Array(undefined, undefined, undefined, undefined);
			}
			if(isdefined(level.var_57b86889[var_549b41ba]))
			{
				stopfx(localClientNum, level.var_57b86889[var_549b41ba]);
			}
			var_e764f9dc = struct::get("clientside_flame_" + var_549b41ba, "targetname");
			level.var_57b86889[var_549b41ba] = playFX(localClientNum, level._effect["gateworm_basin_ready"], var_e764f9dc.origin, VectorScale((1, 0, 0), 90));
			audio::playloopat("zmb_finalfight_key_holder_lp", var_e764f9dc.origin);
			audio::stoploopat("zmb_finalfight_key_charging_lp", var_e764f9dc.origin);
			break;
		}
		case 2:
		{
			if(isdefined(level.var_9431a5ac) && isdefined(level.var_9431a5ac[var_549b41ba]))
			{
				stopfx(localClientNum, level.var_9431a5ac[var_549b41ba]);
			}
			s_loc = struct::get("clientside_key_" + var_549b41ba, "targetname");
			level.mdl_summoning_key[localClientNum].origin = s_loc.origin;
			level.mdl_summoning_key[localClientNum] thread animation::Play("p7_fxanim_zm_zod_summoning_key_idle_anim");
			if(!isdefined(level.var_1da8ae2))
			{
				level.var_1da8ae2 = PlayFXOnTag(localClientNum, level._effect["summoning_key_glow"], level.mdl_summoning_key[localClientNum], "key_root_jnt");
			}
			level.mdl_summoning_key[localClientNum] show();
			level.mdl_summoning_key[localClientNum] playsound(0, "zmb_finalfight_key_place");
			if(!isdefined(level.var_57b86889))
			{
				level.var_57b86889 = Array(undefined, undefined, undefined, undefined);
			}
			if(isdefined(level.var_57b86889[var_549b41ba]))
			{
				stopfx(localClientNum, level.var_57b86889[var_549b41ba]);
			}
			var_e764f9dc = struct::get("clientside_flame_" + var_549b41ba, "targetname");
			level.var_57b86889[var_549b41ba] = playFX(localClientNum, level._effect["gateworm_basin_start"], var_e764f9dc.origin, VectorScale((1, 0, 0), 90));
			audio::stoploopat("zmb_finalfight_key_holder_lp", var_e764f9dc.origin);
			audio::playloopat("zmb_finalfight_key_charging_lp", var_e764f9dc.origin);
			break;
		}
		case 3:
		{
			if(isdefined(level.var_9431a5ac) && isdefined(level.var_9431a5ac[var_549b41ba]))
			{
				stopfx(localClientNum, level.var_9431a5ac[var_549b41ba]);
			}
			s_loc = struct::get("clientside_key_" + var_549b41ba, "targetname");
			level.mdl_summoning_key[localClientNum].origin = s_loc.origin;
			level.mdl_summoning_key[localClientNum] thread animation::Play("p7_fxanim_zm_zod_summoning_key_idle_anim");
			if(!isdefined(level.var_1da8ae2))
			{
				level.var_1da8ae2 = PlayFXOnTag(localClientNum, level._effect["summoning_key_glow"], level.mdl_summoning_key[localClientNum], "key_root_jnt");
			}
			level.mdl_summoning_key[localClientNum] show();
			level.mdl_summoning_key[localClientNum] playsound(0, "zmb_finalfight_key_ready");
			if(!isdefined(level.var_57b86889))
			{
				level.var_57b86889 = Array(undefined, undefined, undefined, undefined);
			}
			if(isdefined(level.var_57b86889[var_549b41ba]))
			{
				stopfx(localClientNum, level.var_57b86889[var_549b41ba]);
			}
			var_e764f9dc = struct::get("clientside_flame_" + var_549b41ba, "targetname");
			level.var_57b86889[var_549b41ba] = playFX(localClientNum, level._effect["gateworm_basin_charging"], var_e764f9dc.origin, VectorScale((1, 0, 0), 90));
			audio::playloopat("zmb_finalfight_key_holder_lp", var_e764f9dc.origin);
			audio::stoploopat("zmb_finalfight_key_charging_lp", var_e764f9dc.origin);
			break;
		}
		case 4:
		{
			if(isdefined(level.var_1da8ae2))
			{
				stopfx(localClientNum, level.var_1da8ae2);
			}
			if(!isdefined(level.var_9431a5ac))
			{
				level.var_9431a5ac = Array(undefined, undefined, undefined, undefined);
			}
			if(!isdefined(level.var_9431a5ac[var_549b41ba]))
			{
				var_e764f9dc = struct::get("clientside_flame_" + var_549b41ba, "targetname");
				level.var_9431a5ac[var_549b41ba] = playFX(localClientNum, level._effect["curse_tell"], var_e764f9dc.origin, VectorScale((1, 0, 0), 90));
			}
			if(isdefined(level.var_57b86889) && isdefined(level.var_57b86889[var_549b41ba]))
			{
				stopfx(localClientNum, level.var_57b86889[var_549b41ba]);
			}
			var_e764f9dc = struct::get("clientside_flame_" + var_549b41ba, "targetname");
			audio::stoploopat("zmb_finalfight_key_holder_lp", var_e764f9dc.origin);
			audio::stoploopat("zmb_finalfight_key_charging_lp", var_e764f9dc.origin);
			level.mdl_summoning_key[localClientNum] Hide();
			break;
		}
	}
}

/*
	Name: parasite_fog_on
	Namespace: zm_genesis_arena
	Checksum: 0xAF37010C
	Offset: 0x23D0
	Size: 0x115
	Parameters: 7
	Flags: None
*/
function parasite_fog_on(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		for(localClientNum = 0; localClientNum < level.localPlayers.size; localClientNum++)
		{
			SetLitFogBank(localClientNum, -1, 1, -1);
			SetWorldFogActiveBank(localClientNum, 2);
		}
	}
	else if(newVal == 2)
	{
		for(localClientNum = 0; localClientNum < level.localPlayers.size; localClientNum++)
		{
			SetLitFogBank(localClientNum, -1, 0, -1);
			SetWorldFogActiveBank(localClientNum, 1);
		}
	}
}

/*
	Name: summoning_circle_fx
	Namespace: zm_genesis_arena
	Checksum: 0x93A36279
	Offset: 0x24F0
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function summoning_circle_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.var_63082da9 = playFX(localClientNum, level._effect["summoning_circle_fx"], self.origin, self.angles);
	}
	else if(isdefined(self.var_63082da9))
	{
		stopfx(localClientNum, self.var_63082da9);
	}
}

/*
	Name: summoning_key_pickup
	Namespace: zm_genesis_arena
	Checksum: 0x40E29B38
	Offset: 0x25B0
	Size: 0x465
	Parameters: 7
	Flags: None
*/
function summoning_key_pickup(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level notify("summoning_key_pickup");
	level endon("summoning_key_pickup");
	function_244d3483(localClientNum);
	level.mdl_summoning_key[localClientNum] util::waittill_dobj(localClientNum);
	var_1f5092c = struct::get("arena_reward_pickup", "targetname");
	switch(newVal)
	{
		case 0:
		{
			level.mdl_summoning_key[localClientNum] Hide();
			if(isdefined(level.mdl_summoning_key[localClientNum].fxid))
			{
				stopfx(localClientNum, level.mdl_summoning_key[localClientNum].fxid);
				level.mdl_summoning_key[localClientNum].fxid = undefined;
			}
			if(isdefined(level.mdl_summoning_key[localClientNum].var_e377eac9))
			{
				stopfx(localClientNum, level.mdl_summoning_key[localClientNum].var_e377eac9);
				level.mdl_summoning_key[localClientNum].var_e377eac9 = undefined;
			}
			break;
		}
		case 1:
		{
			level.mdl_summoning_key[localClientNum].origin = var_1f5092c.origin + VectorScale((0, 0, 1), 196);
			level.mdl_summoning_key[localClientNum] show();
			if(!isdefined(level.mdl_summoning_key[localClientNum].fxid))
			{
				level.mdl_summoning_key[localClientNum].fxid = PlayFXOnTag(localClientNum, level._effect["summoning_key_glow"], level.mdl_summoning_key[localClientNum], "key_root_jnt");
			}
			if(!isdefined(level.mdl_summoning_key[localClientNum].var_e377eac9))
			{
				level.mdl_summoning_key[localClientNum].var_e377eac9 = PlayFXOnTag(localClientNum, level._effect["summoning_key_holder"], level.mdl_summoning_key[localClientNum], "key_root_jnt");
			}
			break;
		}
		case 2:
		{
			level.mdl_summoning_key[localClientNum].origin = var_1f5092c.origin + VectorScale((0, 0, 1), 196);
			level.mdl_summoning_key[localClientNum] show();
			level.mdl_summoning_key[localClientNum] moveto(var_1f5092c.origin, 3);
			if(!isdefined(level.mdl_summoning_key[localClientNum].fxid))
			{
				level.mdl_summoning_key[localClientNum].fxid = PlayFXOnTag(localClientNum, level._effect["summoning_key_glow"], level.mdl_summoning_key[localClientNum], "key_root_jnt");
			}
			if(isdefined(level.mdl_summoning_key[localClientNum].var_e377eac9))
			{
				stopfx(localClientNum, level.mdl_summoning_key[localClientNum].var_e377eac9);
				level.mdl_summoning_key[localClientNum].var_e377eac9 = undefined;
			}
			break;
		}
	}
}

/*
	Name: arena_state
	Namespace: zm_genesis_arena
	Checksum: 0x372AFD03
	Offset: 0x2A20
	Size: 0xC9
	Parameters: 7
	Flags: None
*/
function arena_state(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level notify("arena_state");
	level endon("arena_state");
	if(!isdefined(level.var_b175da10))
	{
		function_8fbd23f4(localClientNum);
	}
	switch(newVal)
	{
		case 0:
		{
			break;
		}
		case 1:
		{
			break;
		}
		case 2:
		{
			break;
		}
		case 3:
		{
			break;
		}
		case 4:
		{
			break;
		}
	}
}

/*
	Name: circle_state
	Namespace: zm_genesis_arena
	Checksum: 0x93CCCAE4
	Offset: 0x2AF8
	Size: 0x20D
	Parameters: 7
	Flags: None
*/
function circle_state(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level notify("circle_state");
	level endon("circle_state");
	n_challenge_index = clientfield::get("circle_challenge_identity");
	switch(newVal)
	{
		case 0:
		{
			if(n_challenge_index == 0)
			{
				level thread player_screen_fx(localClientNum, 0);
				level thread function_df81c23d(localClientNum, 0);
			}
			break;
		}
		case 1:
		{
			if(n_challenge_index == 0)
			{
				level thread player_screen_fx(localClientNum, 0);
				level thread function_df81c23d(localClientNum, 0);
			}
			break;
		}
		case 2:
		{
			break;
		}
		case 3:
		{
			if(n_challenge_index == 0)
			{
				level thread player_screen_fx(localClientNum, 1);
				level thread function_df81c23d(localClientNum, 1);
			}
			break;
		}
		case 4:
		{
			if(n_challenge_index == 0)
			{
				level thread player_screen_fx(localClientNum, 0);
				level thread function_df81c23d(localClientNum, 0);
			}
			break;
		}
		case 5:
		{
			if(n_challenge_index == 0)
			{
				level thread player_screen_fx(localClientNum, 0);
				level thread function_df81c23d(localClientNum, 0);
			}
			break;
		}
	}
}

/*
	Name: function_8fbd23f4
	Namespace: zm_genesis_arena
	Checksum: 0x60312C7D
	Offset: 0x2D10
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function function_8fbd23f4(localClientNum)
{
	level.var_b175da10 = spawnstruct();
}

/*
	Name: function_244d3483
	Namespace: zm_genesis_arena
	Checksum: 0xD53E48E7
	Offset: 0x2D40
	Size: 0x19B
	Parameters: 1
	Flags: None
*/
function function_244d3483(localClientNum)
{
	if(!isdefined(level.mdl_summoning_key))
	{
		level.mdl_summoning_key = [];
	}
	if(!isdefined(level.mdl_summoning_key[localClientNum]))
	{
		s_summoning_key = struct::get("summoning_key", "targetname");
		level.mdl_summoning_key[localClientNum] = spawn(localClientNum, s_summoning_key.origin, "script_model");
		level.mdl_summoning_key[localClientNum] SetModel("p7_fxanim_zm_zod_summoning_key_mod");
		level.mdl_summoning_key[localClientNum] useanimtree(-1);
		level.mdl_summoning_key[localClientNum] Hide();
		var_3b86bdff = struct::get("dark_arena_podium", "targetname");
		v_fwd = AnglesToForward(var_3b86bdff.angles);
		playFX(localClientNum, level._effect["dark_arena_podium"], var_3b86bdff.origin, v_fwd);
	}
}

/*
	Name: spawn_model_from_struct
	Namespace: zm_genesis_arena
	Checksum: 0x554D3560
	Offset: 0x2EE8
	Size: 0xAF
	Parameters: 3
	Flags: None
*/
function spawn_model_from_struct(localClientNum, s_location, v_angle_offset)
{
	if(!isdefined(v_angle_offset))
	{
		v_angle_offset = (0, 0, 0);
	}
	mdl_spawned = spawn(localClientNum, s_location.origin, "script_model");
	mdl_spawned.angles = s_location.angles + v_angle_offset;
	mdl_spawned SetModel(s_location.model);
	return mdl_spawned;
}

/*
	Name: function_3d5c3a74
	Namespace: zm_genesis_arena
	Checksum: 0x33419F08
	Offset: 0x2FA0
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function function_3d5c3a74(b_rise)
{
	s_summoning_key = struct::get("summoning_key", "targetname");
	v_offset = VectorScale((0, 0, 1), 512);
	if(!b_rise)
	{
		v_offset = (0, 0, 0);
	}
	self moveto(s_summoning_key.origin + v_offset, 3);
}

/*
	Name: function_17ef53cd
	Namespace: zm_genesis_arena
	Checksum: 0xA4D77E9C
	Offset: 0x3040
	Size: 0x11D
	Parameters: 0
	Flags: None
*/
function function_17ef53cd()
{
	self notify("hash_17ef53cd");
	self endon("hash_17ef53cd");
	v_origin = self.v_origin;
	n_duration = RandomFloatRange(4.75, 5);
	while(1)
	{
		self.mdl_light moveto(v_origin + VectorScale((0, 0, 1), 4), n_duration);
		self.mdl_dark moveto(v_origin + VectorScale((0, 0, 1), 4), n_duration);
		wait(n_duration);
		self.mdl_light moveto(v_origin, n_duration);
		self.mdl_dark moveto(v_origin, n_duration);
		wait(n_duration);
	}
}

/*
	Name: function_5ce8eb7d
	Namespace: zm_genesis_arena
	Checksum: 0xBB058083
	Offset: 0x3168
	Size: 0x55
	Parameters: 1
	Flags: None
*/
function function_5ce8eb7d(n_height)
{
	for(i = 0; i < 5; i++)
	{
		level.var_8962a8a0[i] thread function_fad1f25a(n_height);
	}
}

/*
	Name: function_fad1f25a
	Namespace: zm_genesis_arena
	Checksum: 0x1B08A6A4
	Offset: 0x31C8
	Size: 0x1DD
	Parameters: 1
	Flags: None
*/
function function_fad1f25a(n_height)
{
	self notify("hash_17ef53cd");
	switch(n_height)
	{
		case 0:
		{
			n_duration = RandomFloatRange(1.75, 2);
			self.mdl_light moveto(self.v_origin + VectorScale((0, 0, -1), 128), n_duration);
			self.mdl_dark moveto(self.v_origin + VectorScale((0, 0, -1), 128), n_duration);
			break;
		}
		case 1:
		{
			n_duration = RandomFloatRange(1.75, 2);
			self.mdl_light moveto(self.v_origin, n_duration);
			self.mdl_dark moveto(self.v_origin, n_duration);
			break;
		}
		case 2:
		{
			n_duration = RandomFloatRange(1.75, 2);
			self.mdl_light moveto(self.v_origin + VectorScale((0, 0, 1), 128), n_duration);
			self.mdl_dark moveto(self.v_origin + VectorScale((0, 0, 1), 128), n_duration);
			break;
		}
	}
}

/*
	Name: function_99a05235
	Namespace: zm_genesis_arena
	Checksum: 0x7327A660
	Offset: 0x33B0
	Size: 0x4D
	Parameters: 1
	Flags: None
*/
function function_99a05235(b_on)
{
	for(i = 0; i < 5; i++)
	{
		function_7277f824(i, b_on);
	}
}

/*
	Name: function_7277f824
	Namespace: zm_genesis_arena
	Checksum: 0xCB4859E1
	Offset: 0x3408
	Size: 0xC3
	Parameters: 2
	Flags: None
*/
function function_7277f824(n_index, b_on)
{
	if(b_on)
	{
		level.var_8962a8a0[n_index].mdl_light show();
		level.var_8962a8a0[n_index].mdl_dark Hide();
	}
	else
	{
		level.var_8962a8a0[n_index].mdl_light Hide();
		level.var_8962a8a0[n_index].mdl_dark show();
	}
}

/*
	Name: sndarena
	Namespace: zm_genesis_arena
	Checksum: 0xD8E85EDC
	Offset: 0x34D8
	Size: 0x32D
	Parameters: 2
	Flags: None
*/
function sndarena(State, e_model)
{
	level notify("sndarena");
	level endon("sndarena");
	switch(State)
	{
		case 0:
		{
			e_model playsound(0, "evt_zod_ritual_reset");
			if(isdefined(e_model.sndent))
			{
				e_model.sndent delete();
				e_model.sndent = undefined;
			}
			break;
		}
		case 1:
		{
			e_model playsound(0, "evt_zod_ritual_ready");
			if(!isdefined(e_model.sndent))
			{
				e_model.sndent = spawn(0, e_model.origin, "script_origin");
				e_model.sndent LinkTo(e_model, "tag_origin");
			}
			e_model.sndent PlayLoopSound("evt_zod_ritual_ready_loop", 2);
			break;
		}
		case 2:
		{
			e_model playsound(0, "evt_zod_ritual_started");
			if(!isdefined(e_model.sndent))
			{
				e_model.sndent = spawn(0, e_model.origin, "script_origin");
				e_model.sndent LinkTo(e_model, "tag_origin");
			}
			looper = e_model.sndent PlayLoopSound("evt_zod_ritual_started_loop", 2);
			pitch = 0.5;
			while(1)
			{
				setSoundPitch(looper, pitch);
				setSoundPitchRate(looper, 0.1);
				wait(1);
				pitch = pitch + 0.05;
			}
			break;
		}
		case 4:
		{
			e_model playsound(0, "evt_zod_ritual_finished");
			if(isdefined(e_model.sndent))
			{
				e_model.sndent delete();
				e_model.sndent = undefined;
			}
			break;
		}
	}
}

/*
	Name: sndcircle
	Namespace: zm_genesis_arena
	Checksum: 0x276AA2EA
	Offset: 0x3810
	Size: 0x4CD
	Parameters: 2
	Flags: None
*/
function sndcircle(State, e_model)
{
	level notify("sndcircle");
	level endon("sndcircle");
	switch(State)
	{
		case 0:
		{
			e_model playsound(0, "evt_zod_ritual_reset");
			if(isdefined(e_model.sndent))
			{
				e_model.sndent delete();
				e_model.sndent = undefined;
			}
			break;
		}
		case 1:
		{
			e_model playsound(0, "evt_zod_ritual_ready");
			if(!isdefined(e_model.sndent))
			{
				e_model.sndent = spawn(0, e_model.origin, "script_origin");
				e_model.sndent LinkTo(e_model, "tag_origin");
			}
			e_model.sndent PlayLoopSound("evt_zod_ritual_ready_loop", 2);
			break;
		}
		case 2:
		{
			e_model playsound(0, "evt_zod_ritual_started");
			if(!isdefined(e_model.sndent))
			{
				e_model.sndent = spawn(0, e_model.origin, "script_origin");
				e_model.sndent LinkTo(e_model, "tag_origin");
			}
			looper = e_model.sndent PlayLoopSound("evt_zod_ritual_started_loop", 2);
			pitch = 0.5;
			while(1)
			{
				setSoundPitch(looper, pitch);
				setSoundPitchRate(looper, 0.1);
				wait(1);
				pitch = pitch + 0.05;
			}
			break;
		}
		case 3:
		{
			e_model playsound(0, "evt_zod_ritual_started");
			if(!isdefined(e_model.sndent))
			{
				e_model.sndent = spawn(0, e_model.origin, "script_origin");
				e_model.sndent LinkTo(e_model, "tag_origin");
			}
			looper = e_model.sndent PlayLoopSound("evt_zod_ritual_started_loop", 2);
			pitch = 0.5;
			while(1)
			{
				setSoundPitch(looper, pitch);
				setSoundPitchRate(looper, 0.1);
				wait(1);
				pitch = pitch + 0.05;
			}
			break;
		}
		case 4:
		{
			e_model playsound(0, "evt_zod_ritual_finished");
			if(isdefined(e_model.sndent))
			{
				e_model.sndent delete();
				e_model.sndent = undefined;
			}
			break;
		}
		case 5:
		{
			e_model playsound(0, "evt_zod_ritual_finished");
			if(isdefined(e_model.sndent))
			{
				e_model.sndent delete();
				e_model.sndent = undefined;
			}
			break;
		}
	}
}

/*
	Name: function_b9c422c3
	Namespace: zm_genesis_arena
	Checksum: 0x64F401C8
	Offset: 0x3CE8
	Size: 0x1CD
	Parameters: 7
	Flags: None
*/
function function_b9c422c3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_a42274ee = struct::get_array("challenge_fire_struct", "targetname");
	foreach(var_d2c81bd9 in var_a42274ee)
	{
		if(var_d2c81bd9.script_int == self GetEntityNumber())
		{
			if(!isdefined(var_d2c81bd9.var_90369c89[localClientNum]))
			{
				var_d2c81bd9.var_90369c89[localClientNum] = playFX(localClientNum, level._effect["random_weapon_powerup_marker"], var_d2c81bd9.origin + VectorScale((0, 0, -1), 8));
			}
			continue;
		}
		if(isdefined(var_d2c81bd9.var_90369c89[localClientNum]))
		{
			deletefx(localClientNum, var_d2c81bd9.var_90369c89[localClientNum]);
			var_d2c81bd9.var_90369c89[localClientNum] = undefined;
		}
	}
}

/*
	Name: arena_margwa_init
	Namespace: zm_genesis_arena
	Checksum: 0x469DB4B7
	Offset: 0x3EC0
	Size: 0x53
	Parameters: 7
	Flags: None
*/
function arena_margwa_init(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self.margwa_spawn_effect = level._effect["arena_margwa_spawn"];
}

/*
	Name: electricity_postfx_set
	Namespace: zm_genesis_arena
	Checksum: 0xC8265B11
	Offset: 0x3F20
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function electricity_postfx_set(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self thread postfx::playPostfxBundle("pstfx_shock_charge");
	}
	else
	{
		self thread postfx::exitPostfxBundle();
	}
}

/*
	Name: darkness_postfx_set
	Namespace: zm_genesis_arena
	Checksum: 0x893202B
	Offset: 0x3FA8
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function darkness_postfx_set(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self thread postfx::playPostfxBundle("pstfx_gen_chal_shadow");
	}
	else
	{
		self thread postfx::exitPostfxBundle();
	}
}

/*
	Name: fire_postfx_set
	Namespace: zm_genesis_arena
	Checksum: 0x46DC7963
	Offset: 0x4030
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function fire_postfx_set(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self thread postfx::playPostfxBundle("pstfx_burn_loop");
	}
	else
	{
		self thread postfx::exitPostfxBundle();
	}
}

/*
	Name: fire_column
	Namespace: zm_genesis_arena
	Checksum: 0x91814DC1
	Offset: 0x40B8
	Size: 0xBD
	Parameters: 7
	Flags: None
*/
function fire_column(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.var_7dec59b4 = playFX(localClientNum, level._effect["fire_column"], self.origin + VectorScale((0, 0, -1), 90), (0, -1, 0));
	}
	else
	{
		stopfx(localClientNum, self.var_7dec59b4);
		self.var_7dec59b4 = undefined;
	}
}

/*
	Name: player_screen_fx
	Namespace: zm_genesis_arena
	Checksum: 0xBB9D48BB
	Offset: 0x4180
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function player_screen_fx(localClientNum, newVal)
{
	if(newVal == 1)
	{
		if(isdefined(level.var_51541120[localClientNum]))
		{
			deletefx(localClientNum, level.var_51541120[localClientNum], 1);
		}
		level.var_51541120[localClientNum] = PlayFXOnCamera(localClientNum, level._effect["low_grav_screen_fx"]);
	}
	else if(isdefined(level.var_51541120[localClientNum]))
	{
		deletefx(localClientNum, level.var_51541120[localClientNum], 1);
	}
}

/*
	Name: function_df81c23d
	Namespace: zm_genesis_arena
	Checksum: 0xC65774AA
	Offset: 0x4260
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function function_df81c23d(localClientNum, newVal)
{
	if(newVal == 1)
	{
		setpbgactivebank(localClientNum, 2);
		level.localPlayers[0] thread postfx::playPostfxBundle("pstfx_115_castle_loop");
	}
	else
	{
		setpbgactivebank(localClientNum, 1);
		level.localPlayers[0] thread postfx::exitPostfxBundle();
	}
}

/*
	Name: light_challenge_floor
	Namespace: zm_genesis_arena
	Checksum: 0x18559008
	Offset: 0x4310
	Size: 0xE3
	Parameters: 7
	Flags: None
*/
function light_challenge_floor(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		s_floor = struct::get("arena_light_challenge_floor", "targetname");
		level.var_be73cf11 = util::spawn_model(localClientNum, s_floor.model, s_floor.origin, s_floor.angles);
	}
	else if(isdefined(level.var_be73cf11))
	{
		level.var_be73cf11 delete();
	}
}

/*
	Name: arena_tornado
	Namespace: zm_genesis_arena
	Checksum: 0x2C40C50C
	Offset: 0x4400
	Size: 0xAB
	Parameters: 7
	Flags: None
*/
function arena_tornado(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.var_247afb5a = PlayFXOnTag(localClientNum, level._effect["arena_tornado"], self, "tag_origin");
	}
	else if(isdefined(self.var_247afb5a))
	{
		stopfx(localClientNum, self.var_247afb5a);
	}
}

/*
	Name: arena_shadow_pillar
	Namespace: zm_genesis_arena
	Checksum: 0x1A0A0EC1
	Offset: 0x44B8
	Size: 0xAB
	Parameters: 7
	Flags: None
*/
function arena_shadow_pillar(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.var_e29992ef = PlayFXOnTag(localClientNum, level._effect["arena_shadow_pillar"], self, "tag_origin");
	}
	else if(isdefined(self.var_e29992ef))
	{
		stopfx(localClientNum, self.var_e29992ef);
	}
}

