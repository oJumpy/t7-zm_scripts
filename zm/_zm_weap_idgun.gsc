#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_vortex;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace idgun;

/*
	Name: __init__sytem__
	Namespace: idgun
	Checksum: 0x1FD0E74C
	Offset: 0x2F8
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("idgun", &init, &main, undefined);
}

/*
	Name: init
	Namespace: idgun
	Checksum: 0x3788B2AE
	Offset: 0x340
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function init()
{
	callback::on_connect(&function_2bd571b9);
	zm::register_player_damage_callback(&function_b618ee82);
}

/*
	Name: main
	Namespace: idgun
	Checksum: 0x40CDF142
	Offset: 0x390
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function main()
{
	if(!isdefined(level.idgun_weapons))
	{
		if(!isdefined(level.idgun_weapons))
		{
			level.idgun_weapons = [];
		}
		else if(!IsArray(level.idgun_weapons))
		{
			level.idgun_weapons = Array(level.idgun_weapons);
		}
		level.idgun_weapons[level.idgun_weapons.size] = GetWeapon("idgun");
	}
	level zm::register_vehicle_damage_callback(&function_61f631bc);
}

/*
	Name: is_idgun_damage
	Namespace: idgun
	Checksum: 0x57B54C66
	Offset: 0x448
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function is_idgun_damage(weapon)
{
	if(isdefined(level.idgun_weapons))
	{
		if(IsInArray(level.idgun_weapons, weapon))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: function_9b7ac6a9
	Namespace: idgun
	Checksum: 0x43CBFD0E
	Offset: 0x490
	Size: 0x45
	Parameters: 1
	Flags: None
*/
function function_9b7ac6a9(weapon)
{
	if(is_idgun_damage(weapon) && zm_weapons::is_weapon_upgraded(weapon))
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_6fbe2b2c
	Namespace: idgun
	Checksum: 0xAEEF9597
	Offset: 0x4E0
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function function_6fbe2b2c(v_vortex_origin)
{
	v_nearest_navmesh_point = GetClosestPointOnNavMesh(v_vortex_origin, 36, 15);
	if(isdefined(v_nearest_navmesh_point))
	{
		f_distance = Distance(v_vortex_origin, v_nearest_navmesh_point);
		if(f_distance < 41)
		{
			v_vortex_origin = v_vortex_origin + VectorScale((0, 0, 1), 36);
		}
	}
	return v_vortex_origin;
}

/*
	Name: function_2bd571b9
	Namespace: idgun
	Checksum: 0x24EEF596
	Offset: 0x580
	Size: 0x16F
	Parameters: 0
	Flags: None
*/
function function_2bd571b9()
{
	self endon("disconnect");
	while(1)
	{
		self waittill("projectile_impact", weapon, position, radius, attacker, normal);
		position = function_6fbe2b2c(position + normal * 20);
		if(is_idgun_damage(weapon))
		{
			var_12edbbc6 = radius * 1.8;
			if(function_9b7ac6a9(weapon))
			{
				thread zombie_vortex::start_timed_vortex(position, radius, 9, 10, var_12edbbc6, self, weapon, 1, undefined, 0, 2);
			}
			else
			{
				thread zombie_vortex::start_timed_vortex(position, radius, 4, 5, var_12edbbc6, self, weapon, 1, undefined, 0, 1);
			}
			level notify("hash_2751215d", position, weapon, self);
		}
		wait(0.05);
	}
}

/*
	Name: function_b618ee82
	Namespace: idgun
	Checksum: 0x67F7E07C
	Offset: 0x6F8
	Size: 0x75
	Parameters: 10
	Flags: None
*/
function function_b618ee82(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(is_idgun_damage(sWeapon))
	{
		return 0;
	}
	return -1;
}

/*
	Name: function_61f631bc
	Namespace: idgun
	Checksum: 0xECE36CF9
	Offset: 0x778
	Size: 0xC3
	Parameters: 15
	Flags: None
*/
function function_61f631bc(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	if(isdefined(weapon))
	{
		if(is_idgun_damage(weapon) && (!isdefined(self.veh_idgun_allow_damage) && self.veh_idgun_allow_damage))
		{
			iDamage = 0;
		}
	}
	return iDamage;
}

