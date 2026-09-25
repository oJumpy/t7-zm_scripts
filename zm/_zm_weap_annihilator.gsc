#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_weap_annihilator;

/*
	Name: __init__sytem__
	Namespace: zm_weap_annihilator
	Checksum: 0xF6C601BB
	Offset: 0x260
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_annihilator", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_annihilator
	Checksum: 0xC6490ADF
	Offset: 0x2A0
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_spawner::register_zombie_death_event_callback(&check_annihilator_death);
	zm_hero_weapon::register_hero_weapon("hero_annihilator");
	level.weaponAnnihilator = GetWeapon("hero_annihilator");
}

/*
	Name: check_annihilator_death
	Namespace: zm_weap_annihilator
	Checksum: 0xF0B58EB3
	Offset: 0x308
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function check_annihilator_death(attacker)
{
	if(isdefined(self.damageWeapon) && !self.damageWeapon === level.weaponNone)
	{
		if(self.damageWeapon === level.weaponAnnihilator)
		{
			self zombie_utility::gib_random_parts();
			GibServerUtils::Annihilate(self);
		}
	}
}

