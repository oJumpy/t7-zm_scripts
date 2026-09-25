#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_weapons;

#namespace namespace_6cf1d5bd;

/*
	Name: __init__sytem__
	Namespace: namespace_6cf1d5bd
	Checksum: 0x48175B48
	Offset: 0x158
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("plunger_knife", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_6cf1d5bd
	Checksum: 0x99EC1590
	Offset: 0x1A0
	Size: 0x3
	Parameters: 0
	Flags: Private
*/
function private __init__()
{
}

/*
	Name: __main__
	Namespace: namespace_6cf1d5bd
	Checksum: 0x2B654610
	Offset: 0x1B0
	Size: 0x7B
	Parameters: 0
	Flags: Private
*/
function private __main__()
{
	cost = 3000;
	zm_melee_weapon::init("knife_plunger", "zombie_plunger_flourish", undefined, undefined, cost, "bowie_upgrade", &"ZMWEAPON_NONE", "plunger", undefined);
	zm_melee_weapon::set_fallback_weapon("knife_plunger", "zombie_fists_plunger");
}

/*
	Name: init
	Namespace: namespace_6cf1d5bd
	Checksum: 0x99EC1590
	Offset: 0x238
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function init()
{
}

