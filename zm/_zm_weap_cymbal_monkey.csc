#using scripts\codescripts\struct;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace _zm_weap_cymbal_monkey;

/*
	Name: init
	Namespace: _zm_weap_cymbal_monkey
	Checksum: 0x1164836
	Offset: 0x110
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function init()
{
	if(isdefined(level.legacy_cymbal_monkey) && level.legacy_cymbal_monkey)
	{
		level.cymbal_monkey_model = "weapon_zombie_monkey_bomb";
	}
	else
	{
		level.cymbal_monkey_model = "wpn_t7_zmb_monkey_bomb_world";
	}
	if(!zm_weapons::is_weapon_included(GetWeapon("cymbal_monkey")))
	{
		return;
	}
}

