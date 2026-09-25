#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_aat_blast_furnace;

/*
	Name: __init__sytem__
	Namespace: zm_aat_blast_furnace
	Checksum: 0x45B18C7A
	Offset: 0x2A0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_aat_blast_furnace", &__init__, undefined, "aat");
}

/*
	Name: __init__
	Namespace: zm_aat_blast_furnace
	Checksum: 0x3490D32E
	Offset: 0x2E0
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use))
	{
		return;
	}
	AAT::register("zm_aat_blast_furnace", 0.15, 0, 15, 0, 1, &result, "t7_hud_zm_aat_blastfurnace", "wpn_aat_blast_furnace_plr");
	clientfield::register("actor", "zm_aat_blast_furnace" + "_explosion", 1, 1, "counter");
	clientfield::register("vehicle", "zm_aat_blast_furnace" + "_explosion_vehicle", 1, 1, "counter");
	clientfield::register("actor", "zm_aat_blast_furnace" + "_burn", 1, 1, "counter");
	clientfield::register("vehicle", "zm_aat_blast_furnace" + "_burn_vehicle", 1, 1, "counter");
}

/*
	Name: result
	Namespace: zm_aat_blast_furnace
	Checksum: 0xD336C103
	Offset: 0x430
	Size: 0x43
	Parameters: 4
	Flags: None
*/
function result(death, attacker, mod, weapon)
{
	self thread blast_furnace_explosion(attacker, weapon);
}

/*
	Name: blast_furnace_explosion
	Namespace: zm_aat_blast_furnace
	Checksum: 0xE49EC50E
	Offset: 0x480
	Size: 0x3CB
	Parameters: 2
	Flags: None
*/
function blast_furnace_explosion(e_attacker, w_weapon)
{
	if(isVehicle(self))
	{
		self thread clientfield::increment("zm_aat_blast_furnace" + "_explosion_vehicle");
	}
	else
	{
		self thread clientfield::increment("zm_aat_blast_furnace" + "_explosion");
	}
	a_e_blasted_zombies = Array::get_all_closest(self.origin, GetAITeamArray("axis"), undefined, undefined, 120);
	if(a_e_blasted_zombies.size > 0)
	{
		i = 0;
		while(i < a_e_blasted_zombies.size)
		{
			if(isalive(a_e_blasted_zombies[i]))
			{
				if(isdefined(level.AAT["zm_aat_blast_furnace"].immune_result_indirect[a_e_blasted_zombies[i].archetype]) && level.AAT["zm_aat_blast_furnace"].immune_result_indirect[a_e_blasted_zombies[i].archetype])
				{
					ArrayRemoveValue(a_e_blasted_zombies, a_e_blasted_zombies[i]);
					continue;
				}
				if(a_e_blasted_zombies[i] == self && (!isdefined(level.AAT["zm_aat_blast_furnace"].immune_result_direct[a_e_blasted_zombies[i].archetype]) && level.AAT["zm_aat_blast_furnace"].immune_result_direct[a_e_blasted_zombies[i].archetype]))
				{
					self thread zombie_death_gib(e_attacker, w_weapon);
					if(isVehicle(a_e_blasted_zombies[i]))
					{
						a_e_blasted_zombies[i] thread clientfield::increment("zm_aat_blast_furnace" + "_burn_vehicle");
					}
					else
					{
						a_e_blasted_zombies[i] thread clientfield::increment("zm_aat_blast_furnace" + "_burn");
					}
					ArrayRemoveValue(a_e_blasted_zombies, a_e_blasted_zombies[i]);
					continue;
				}
				if(isVehicle(a_e_blasted_zombies[i]))
				{
					a_e_blasted_zombies[i] thread clientfield::increment("zm_aat_blast_furnace" + "_burn_vehicle");
				}
				else
				{
					a_e_blasted_zombies[i] thread clientfield::increment("zm_aat_blast_furnace" + "_burn");
				}
			}
			i++;
		}
		wait(0.25);
		a_e_blasted_zombies = Array::remove_dead(a_e_blasted_zombies);
		a_e_blasted_zombies = Array::remove_undefined(a_e_blasted_zombies);
		Array::thread_all(a_e_blasted_zombies, &blast_furnace_zombie_burn, e_attacker, w_weapon);
	}
}

/*
	Name: blast_furnace_zombie_burn
	Namespace: zm_aat_blast_furnace
	Checksum: 0x4DBBDCE1
	Offset: 0x858
	Size: 0xCF
	Parameters: 2
	Flags: None
*/
function blast_furnace_zombie_burn(e_attacker, w_weapon)
{
	self endon("death");
	n_damage = self.health / 6;
	for(i = 0; i <= 6; i++)
	{
		if(self.health < n_damage)
		{
			e_attacker zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_BLAST_FURNACE");
		}
		self DoDamage(n_damage, self.origin, e_attacker, undefined, "none", "MOD_UNKNOWN", 0, w_weapon);
		wait(0.5);
	}
}

/*
	Name: zombie_death_gib
	Namespace: zm_aat_blast_furnace
	Checksum: 0x8AD1D450
	Offset: 0x930
	Size: 0xEB
	Parameters: 2
	Flags: None
*/
function zombie_death_gib(e_attacker, w_weapon)
{
	GibServerUtils::GibHead(self);
	if(math::cointoss())
	{
		GibServerUtils::GibLeftArm(self);
	}
	else
	{
		GibServerUtils::GibRightArm(self);
	}
	GibServerUtils::GibLegs(self);
	self DoDamage(self.health, self.origin, e_attacker);
	if(isdefined(e_attacker) && isPlayer(e_attacker))
	{
		e_attacker zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_BLAST_FURNACE");
	}
}

