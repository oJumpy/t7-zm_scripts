#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\beam_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_genesis_util;

#namespace zm_genesis_boss;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_boss
	Checksum: 0xBCE2BC2F
	Offset: 0x688
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_boss", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_boss
	Checksum: 0xB30DC8B1
	Offset: 0x6C8
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["boss_shield"] = "zombie/fx_ee_shadowman_shield_loop_zod";
	level._effect["powerup_column"] = "dlc4/genesis/fx_darkarena_powerup_pillar";
	clientfield::register("scriptmover", "boss_clone_fx", 15000, GetMinBitCountForNum(3), "int", &boss_clone_fx, 0, 0);
	clientfield::register("world", "sophia_state", 15000, GetMinBitCountForNum(4), "int", &sophia_state, 0, 1);
	clientfield::register("world", "boss_beam_state", 15000, 1, "int", &boss_beam_state, 0, 1);
}

/*
	Name: boss_clone_fx
	Namespace: zm_genesis_boss
	Checksum: 0x94B90D76
	Offset: 0x800
	Size: 0x25D
	Parameters: 7
	Flags: None
*/
function boss_clone_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.var_83ba4dad))
	{
		stopfx(localClientNum, self.var_83ba4dad);
	}
	if(isdefined(self.var_b0063e15))
	{
		stopfx(localClientNum, self.var_b0063e15);
	}
	if(!isdefined(level.var_114bbd15))
	{
		level.var_114bbd15 = 0;
	}
	switch(newVal)
	{
		case 1:
		{
			self.var_b0063e15 = PlayFXOnTag(localClientNum, level._effect["shadowman_shield_glow_off"], self, "tag_origin");
			if(level.var_114bbd15 != 1)
			{
				self playsound(0, "zmb_finalfight_shadowman_shield_down");
				self.var_af44f4d3 = self PlayLoopSound("zmb_finalfight_shadowman_shield_down_lp", 2);
				level.var_114bbd15 = 1;
			}
			break;
		}
		case 2:
		{
			if(level.var_114bbd15 != 2)
			{
				self playsound(0, "zmb_finalfight_shadowman_shield_up");
				self.var_af44f4d3 = self PlayLoopSound("zmb_finalfight_shadowman_shield_up_lp", 2);
				level.var_114bbd15 = 2;
			}
			self.var_83ba4dad = PlayFXOnTag(localClientNum, level._effect["boss_shield"], self, "j_spineupper");
			SetFXIgnorePause(localClientNum, self.var_83ba4dad, 1);
			self.var_b0063e15 = PlayFXOnTag(localClientNum, level._effect["shadowman_shield_glow_on"], self, "tag_origin");
			break;
		}
	}
}

/*
	Name: sophia_state
	Namespace: zm_genesis_boss
	Checksum: 0x9D9E9A45
	Offset: 0xA68
	Size: 0x50D
	Parameters: 7
	Flags: None
*/
function sophia_state(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level notify("sophia_state");
	level endon("sophia_state");
	function_eec997a(localClientNum);
	level.var_f0444f1b[localClientNum] util::waittill_dobj(localClientNum);
	var_b19b9bc4 = struct::get("boss_sophia_hover", "targetname");
	var_76fc2b6f = struct::get("boss_sophia_ground", "targetname");
	switch(newVal)
	{
		case 0:
		{
			level.var_f0444f1b[localClientNum] Hide();
			break;
		}
		case 1:
		{
			level.var_f0444f1b[localClientNum] SetModel("p7_zm_gen_dark_arena_sphere_metal");
			level.var_f0444f1b[localClientNum].origin = var_b19b9bc4.origin;
			level.var_f0444f1b[localClientNum] show();
			level.var_f0444f1b[localClientNum] thread animation::Play("ai_zm_dlc4_sophia_idle_loop");
			level.var_f0444f1b[localClientNum] playsound(0, "zmb_finafight_sophia_materialize");
			level.var_f0444f1b[localClientNum].sndloop = level.var_f0444f1b[localClientNum] PlayLoopSound("zmb_finafight_sophia_materialized_lp", 2);
			break;
		}
		case 2:
		{
			level.var_f0444f1b[localClientNum] SetModel("p7_zm_gen_dark_arena_sphere");
			level.var_f0444f1b[localClientNum].origin = var_b19b9bc4.origin;
			level.var_f0444f1b[localClientNum] show();
			level.var_f0444f1b[localClientNum] playsound(0, "zmb_finafight_sophia_downed");
			level.var_f0444f1b[localClientNum].sndloop = level.var_f0444f1b[localClientNum] PlayLoopSound("zmb_finafight_sophia_ghost_lp", 2);
			level.var_f0444f1b[localClientNum] animation::Play("ai_zm_dlc4_sophia_down");
			level.var_f0444f1b[localClientNum] thread animation::Play("ai_zm_dlc4_sophia_down_idle");
			break;
		}
		case 3:
		{
			level.var_f0444f1b[localClientNum] thread sophia_transition_fx(localClientNum);
			level.var_f0444f1b[localClientNum] SetModel("p7_zm_gen_dark_arena_sphere_metal");
			level.var_f0444f1b[localClientNum].origin = var_b19b9bc4.origin;
			level.var_f0444f1b[localClientNum] show();
			level.var_f0444f1b[localClientNum] playsound(0, "zmb_finafight_sophia_powerup");
			level.var_f0444f1b[localClientNum].sndloop = level.var_f0444f1b[localClientNum] PlayLoopSound("zmb_finafight_sophia_materialized_lp", 2);
			level.var_f0444f1b[localClientNum] thread function_24b59946(localClientNum);
			level.var_f0444f1b[localClientNum] animation::Play("ai_zm_dlc4_sophia_attack");
			level.var_f0444f1b[localClientNum] thread animation::Play("ai_zm_dlc4_sophia_idle_loop");
			break;
		}
	}
}

/*
	Name: sophia_transition_fx
	Namespace: zm_genesis_boss
	Checksum: 0xC446D7BA
	Offset: 0xF80
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function sophia_transition_fx(localClientNum)
{
	var_c6f38611 = PlayFXOnTag(localClientNum, level._effect["sophia_transition"], self, "tag_origin");
	wait(1.8);
	if(isdefined(var_c6f38611))
	{
		deletefx(localClientNum, var_c6f38611, 0);
	}
}

/*
	Name: function_24b59946
	Namespace: zm_genesis_boss
	Checksum: 0x95BBEBF7
	Offset: 0x1000
	Size: 0x183
	Parameters: 1
	Flags: None
*/
function function_24b59946(localClientNum)
{
	s_loc = struct::get("boss_shadowman_4");
	var_f929ecf4 = util::spawn_model(localClientNum, "tag_origin", s_loc.origin + VectorScale((0, 0, 1), 54));
	level beam::launch(self, "tag_beam", var_f929ecf4, "tag_origin", "dlc4_skull_turret_beam");
	self playsound(0, "zmb_finafight_sophia_laser_start");
	self.var_36ffe62d = self PlayLoopSound("zmb_finafight_sophia_laser_lp", 0.25);
	wait(2);
	self playsound(0, "zmb_finafight_sophia_laser_end");
	self StopLoopSound(self.var_36ffe62d);
	level beam::kill(self, "tag_beam", var_f929ecf4, "tag_origin", "dlc4_skull_turret_beam");
	var_f929ecf4 delete();
}

/*
	Name: boss_beam_state
	Namespace: zm_genesis_boss
	Checksum: 0xC117E575
	Offset: 0x1190
	Size: 0x26B
	Parameters: 7
	Flags: None
*/
function boss_beam_state(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		s_start = struct::get("ee_book_arena", "targetname");
		level.var_7e52585c = util::spawn_model(localClientNum, "tag_origin", s_start.origin);
		s_end = struct::get("boss_shadowman_4_12");
		level.var_f929ecf4 = util::spawn_model(localClientNum, "tag_origin", s_end.origin);
		level.var_7e52585c playsound(0, "zmb_finafight_book_laser_start");
		level.var_7e52585c.var_36ffe62d = level.var_7e52585c PlayLoopSound("zmb_finafight_book_laser_lp", 0.25);
		level beam::launch(level.var_7e52585c, "tag_origin", level.var_f929ecf4, "tag_origin", "dlc4_skull_turret_beam");
	}
	else if(isdefined(level.var_7e52585c) && isdefined(level.var_f929ecf4))
	{
		level.var_7e52585c playsound(0, "zmb_finafight_book_laser_end");
		level.var_7e52585c StopLoopSound(level.var_7e52585c.var_36ffe62d);
		level beam::kill(level.var_7e52585c, "tag_beam", level.var_f929ecf4, "tag_origin", "dlc4_skull_turret_beam");
		level.var_7e52585c delete();
		level.var_f929ecf4 delete();
	}
}

/*
	Name: function_eec997a
	Namespace: zm_genesis_boss
	Checksum: 0x4D9719B2
	Offset: 0x1408
	Size: 0x11F
	Parameters: 1
	Flags: None
*/
function function_eec997a(localClientNum)
{
	s_loc = struct::get("boss_sophia_hover", "targetname");
	if(!isdefined(level.var_f0444f1b))
	{
		level.var_f0444f1b = [];
	}
	if(!isdefined(level.var_f0444f1b[localClientNum]))
	{
		level.var_f0444f1b[localClientNum] = spawn(localClientNum, s_loc.origin, "script_model");
		level.var_f0444f1b[localClientNum].angles = s_loc.angles;
		level.var_f0444f1b[localClientNum] SetModel("p7_zm_gen_dark_arena_sphere");
		level.var_f0444f1b[localClientNum] useanimtree(-1);
	}
	return level.var_f0444f1b[localClientNum];
}

/*
	Name: stop_fx_if_defined
	Namespace: zm_genesis_boss
	Checksum: 0x1EE5D344
	Offset: 0x1530
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function stop_fx_if_defined(localClientNum, fx_reference)
{
	if(isdefined(fx_reference))
	{
		stopfx(localClientNum, fx_reference);
	}
}

