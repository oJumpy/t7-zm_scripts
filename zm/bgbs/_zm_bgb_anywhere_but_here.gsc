#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace zm_bgb_anywhere_but_here;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_anywhere_but_here
	Checksum: 0x7458ABDA
	Offset: 0x310
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_anywhere_but_here", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_anywhere_but_here
	Checksum: 0x872DF9D7
	Offset: 0x350
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	level._effect["teleport_splash"] = "zombie/fx_bgb_anywhere_but_here_teleport_zmb";
	level._effect["teleport_aoe"] = "zombie/fx_bgb_anywhere_but_here_teleport_aoe_zmb";
	level._effect["teleport_aoe_kill"] = "zombie/fx_bgb_anywhere_but_here_teleport_aoe_kill_zmb";
	bgb::register("zm_bgb_anywhere_but_here", "activated", 2, undefined, undefined, &validation, &activation);
	bgb::register_invulnerable_during_activation("zm_bgb_anywhere_but_here", 1);
}

/*
	Name: activation
	Namespace: zm_bgb_anywhere_but_here
	Checksum: 0x68EE913A
	Offset: 0x430
	Size: 0x533
	Parameters: 0
	Flags: None
*/
function activation()
{
	zm_utility::increment_ignoreme();
	playsoundatposition("zmb_bgb_abh_teleport_out", self.origin);
	if(isdefined(level.var_2c12d9a6))
	{
		s_respawn_point = self [[level.var_2c12d9a6]]();
	}
	else
	{
		s_respawn_point = self function_728dfe3();
	}
	self cleargroundent();
	self SetVelocity((0, 0, 0));
	self SetOrigin(s_respawn_point.origin);
	self FreezeControls(1);
	v_return_pos = self.origin + VectorScale((0, 0, 1), 60);
	a_ai = GetAITeamArray(level.zombie_team);
	a_closest = [];
	ai_closest = undefined;
	if(a_ai.size)
	{
		a_closest = ArraySortClosest(a_ai, self.origin);
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
	self playsound("zmb_bgb_abh_teleport_in");
	if(isdefined(level.var_2300a8ad))
	{
		self [[level.var_2300a8ad]]();
	}
	wait(0.5);
	self show();
	playFX(level._effect["teleport_splash"], self.origin);
	playFX(level._effect["teleport_aoe"], self.origin);
	a_ai = GetAIArray();
	a_aoe_ai = ArraySortClosest(a_ai, self.origin, a_ai.size, 0, 200);
	foreach(ai in a_aoe_ai)
	{
		if(IsActor(ai))
		{
			if(ai.archetype === "zombie")
			{
				playFX(level._effect["teleport_aoe_kill"], ai GetTagOrigin("j_spineupper"));
			}
			else
			{
				playFX(level._effect["teleport_aoe_kill"], ai.origin);
			}
			ai.marked_for_recycle = 1;
			ai.has_been_damaged_by_player = 0;
			ai DoDamage(ai.health + 1000, self.origin, self);
		}
	}
	wait(0.2);
	self FreezeControls(0);
	self zm_stats::increment_challenge_stat("GUM_GOBBLER_ANYWHERE_BUT_HERE");
	wait(3);
	zm_utility::decrement_ignoreme();
}

/*
	Name: validation
	Namespace: zm_bgb_anywhere_but_here
	Checksum: 0x63F86335
	Offset: 0x970
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function validation()
{
	if(isdefined(level.zm_bgb_anywhere_but_here_validation_override))
	{
		return [[level.zm_bgb_anywhere_but_here_validation_override]]();
	}
	return 1;
}

/*
	Name: function_728dfe3
	Namespace: zm_bgb_anywhere_but_here
	Checksum: 0x24692623
	Offset: 0x9A0
	Size: 0x2EF
	Parameters: 0
	Flags: None
*/
function function_728dfe3()
{
	var_a6abcc5d = zm_zonemgr::get_zone_from_position(self.origin + VectorScale((0, 0, 1), 32), 0);
	if(!isdefined(var_a6abcc5d))
	{
		var_a6abcc5d = self.zone_name;
	}
	if(isdefined(var_a6abcc5d))
	{
		var_c30975d2 = level.zones[var_a6abcc5d];
	}
	a_s_respawn_points = struct::get_array("player_respawn_point", "targetname");
	a_s_valid_respawn_points = [];
	foreach(s_respawn_point in a_s_respawn_points)
	{
		if(zm_utility::is_point_inside_enabled_zone(s_respawn_point.origin, var_c30975d2))
		{
			if(!isdefined(a_s_valid_respawn_points))
			{
				a_s_valid_respawn_points = [];
			}
			else if(!IsArray(a_s_valid_respawn_points))
			{
				a_s_valid_respawn_points = Array(a_s_valid_respawn_points);
			}
			a_s_valid_respawn_points[a_s_valid_respawn_points.size] = s_respawn_point;
		}
	}
	if(isdefined(level.var_2d4e3645))
	{
		a_s_valid_respawn_points = [[level.var_2d4e3645]](a_s_valid_respawn_points);
	}
	s_player_respawn = undefined;
	if(a_s_valid_respawn_points.size > 0)
	{
		var_90551969 = Array::random(a_s_valid_respawn_points);
		var_46b9bbf8 = struct::get_array(var_90551969.target, "targetname");
		foreach(var_dbd59eb2 in var_46b9bbf8)
		{
			n_script_int = self GetEntityNumber() + 1;
			if(var_dbd59eb2.script_int === n_script_int)
			{
				s_player_respawn = var_dbd59eb2;
			}
		}
	}
	return s_player_respawn;
}

