#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_aat_thunder_wall;

/*
	Name: __init__sytem__
	Namespace: zm_aat_thunder_wall
	Checksum: 0xE4285D40
	Offset: 0x2B8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_aat_thunder_wall", &__init__, undefined, "aat");
}

/*
	Name: __init__
	Namespace: zm_aat_thunder_wall
	Checksum: 0x1D65D2CA
	Offset: 0x2F8
	Size: 0x85
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use))
	{
		return;
	}
	AAT::register("zm_aat_thunder_wall", 0.25, 0, 10, 0, 1, &result, "t7_hud_zm_aat_thunderwall", "wpn_aat_thunder_wall_plr");
	level._effect["zm_aat_thunder_wall" + "_break_fx"] = "zombie/fx_aat_thunderwall_zmb";
}

/*
	Name: result
	Namespace: zm_aat_thunder_wall
	Checksum: 0x1C0F7F83
	Offset: 0x388
	Size: 0x3B
	Parameters: 4
	Flags: None
*/
function result(death, attacker, mod, weapon)
{
	self thread thunder_wall_blast(attacker);
}

/*
	Name: thunder_wall_blast
	Namespace: zm_aat_thunder_wall
	Checksum: 0xFEDD4197
	Offset: 0x3D0
	Size: 0x535
	Parameters: 1
	Flags: None
*/
function thunder_wall_blast(attacker)
{
	v_thunder_wall_blast_pos = self.origin;
	v_attacker_facing_forward_dir = VectorToAngles(v_thunder_wall_blast_pos - attacker.origin);
	v_attacker_facing = attacker GetWeaponForwardDir();
	v_attacker_orientation = attacker.angles;
	a_ai_zombies = Array::get_all_closest(v_thunder_wall_blast_pos, GetAITeamArray("axis"), undefined, undefined, 360);
	if(!isdefined(a_ai_zombies))
	{
		return;
	}
	f_thunder_wall_range_sq = 32400;
	f_thunder_wall_effect_area_sq = 291600;
	end_pos = v_thunder_wall_blast_pos + VectorScale(v_attacker_facing, 180);
	self playsound("wpn_aat_thunderwall_impact");
	level thread thunder_wall_blast_fx(v_thunder_wall_blast_pos, v_attacker_orientation);
	n_flung_zombies = 0;
	for(i = 0; i < a_ai_zombies.size; i++)
	{
		if(!isdefined(a_ai_zombies[i]) || !isalive(a_ai_zombies[i]))
		{
			continue;
		}
		if(isdefined(level.AAT["zm_aat_thunder_wall"].immune_result_direct[a_ai_zombies[i].archetype]) && level.AAT["zm_aat_thunder_wall"].immune_result_direct[a_ai_zombies[i].archetype])
		{
			continue;
		}
		if(a_ai_zombies[i] == self)
		{
			v_curr_zombie_origin = self.origin;
			v_curr_zombie_origin_sq = 0;
		}
		else
		{
			v_curr_zombie_origin = a_ai_zombies[i] GetCentroid();
			v_curr_zombie_origin_sq = DistanceSquared(v_thunder_wall_blast_pos, v_curr_zombie_origin);
			v_curr_zombie_to_thunder_wall = VectorNormalize(v_curr_zombie_origin - v_thunder_wall_blast_pos);
			v_curr_zombie_facing_dot = VectorDot(v_attacker_facing, v_curr_zombie_to_thunder_wall);
			if(v_curr_zombie_facing_dot < 0)
			{
				continue;
			}
			radial_origin = PointOnSegmentNearestToPoint(v_thunder_wall_blast_pos, end_pos, v_curr_zombie_origin);
			if(DistanceSquared(v_curr_zombie_origin, radial_origin) > f_thunder_wall_effect_area_sq)
			{
				continue;
			}
		}
		if(v_curr_zombie_origin_sq < f_thunder_wall_range_sq)
		{
			a_ai_zombies[i] DoDamage(a_ai_zombies[i].health, v_curr_zombie_origin, attacker, attacker, "none", "MOD_IMPACT");
			if(isdefined(attacker) && isPlayer(attacker))
			{
				attacker zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_THUNDER_WALL");
			}
			if(!(isdefined(level.AAT["zm_aat_thunder_wall"].immune_result_indirect[self.archetype]) && level.AAT["zm_aat_thunder_wall"].immune_result_indirect[self.archetype]))
			{
				n_random_x = RandomFloatRange(-3, 3);
				n_random_y = RandomFloatRange(-3, 3);
				a_ai_zombies[i] StartRagdoll(1);
				a_ai_zombies[i] LaunchRagdoll(100 * VectorNormalize(v_curr_zombie_origin - v_thunder_wall_blast_pos + (n_random_x, n_random_y, 30)), "torso_lower");
			}
			n_flung_zombies++;
		}
		if(-1 && n_flung_zombies >= 6)
		{
			break;
		}
	}
}

/*
	Name: thunder_wall_blast_fx
	Namespace: zm_aat_thunder_wall
	Checksum: 0x81EA2A9D
	Offset: 0x910
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function thunder_wall_blast_fx(v_blast_origin, v_attacker_orientation)
{
	FX::Play("zm_aat_thunder_wall" + "_break_fx", v_blast_origin, v_attacker_orientation, 1);
}

