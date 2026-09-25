#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;

#namespace archetype_damage_effects;

/*
	Name: main
	Namespace: archetype_damage_effects
	Checksum: 0x25729624
	Offset: 0x208
	Size: 0xE3
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("actor", "arch_actor_fire_fx", 1, 2, "int");
	clientfield::register("actor", "arch_actor_char", 1, 2, "int");
	callback::on_actor_damage(&OnActorDamageCallback);
	callback::on_vehicle_damage(&OnVehicleDamageCallback);
	callback::on_actor_killed(&OnActorKilledCallback);
	callback::on_vehicle_killed(&OnVehicleKilledCallback);
}

/*
	Name: OnActorDamageCallback
	Namespace: archetype_damage_effects
	Checksum: 0x15D56AC5
	Offset: 0x2F8
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function OnActorDamageCallback(params)
{
	OnActorDamage(params);
}

/*
	Name: OnVehicleDamageCallback
	Namespace: archetype_damage_effects
	Checksum: 0xDF17122B
	Offset: 0x328
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function OnVehicleDamageCallback(params)
{
	OnVehicleDamage(params);
}

/*
	Name: OnActorKilledCallback
	Namespace: archetype_damage_effects
	Checksum: 0x18ABF46B
	Offset: 0x358
	Size: 0x6D
	Parameters: 1
	Flags: None
*/
function OnActorKilledCallback(params)
{
	OnActorKilled();
	switch(self.archetype)
	{
		case "human":
		{
			OnHumanKilled();
			break;
		}
		case "robot":
		{
			OnRobotKilled();
			break;
		}
	}
}

/*
	Name: OnVehicleKilledCallback
	Namespace: archetype_damage_effects
	Checksum: 0x95693ED5
	Offset: 0x3D0
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function OnVehicleKilledCallback(params)
{
	OnVehicleKilled(params);
}

/*
	Name: OnActorDamage
	Namespace: archetype_damage_effects
	Checksum: 0x90504447
	Offset: 0x400
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function OnActorDamage(params)
{
}

/*
	Name: OnVehicleDamage
	Namespace: archetype_damage_effects
	Checksum: 0x12F19214
	Offset: 0x418
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function OnVehicleDamage(params)
{
	OnVehicleKilled(params);
}

/*
	Name: OnActorKilled
	Namespace: archetype_damage_effects
	Checksum: 0x48E1FF5A
	Offset: 0x448
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function OnActorKilled()
{
	if(isdefined(self.damageMod))
	{
		if(self.damageMod == "MOD_BURNED")
		{
			if(isdefined(self.damageWeapon) && isdefined(self.damageWeapon.specialpain) && self.damageWeapon.specialpain == 0)
			{
				self clientfield::set("arch_actor_fire_fx", 2);
			}
		}
	}
}

/*
	Name: OnHumanKilled
	Namespace: archetype_damage_effects
	Checksum: 0x99EC1590
	Offset: 0x4D0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function OnHumanKilled()
{
}

/*
	Name: OnRobotKilled
	Namespace: archetype_damage_effects
	Checksum: 0x99EC1590
	Offset: 0x4E0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function OnRobotKilled()
{
}

/*
	Name: OnVehicleKilled
	Namespace: archetype_damage_effects
	Checksum: 0x8CB7853B
	Offset: 0x4F0
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function OnVehicleKilled(params)
{
}

