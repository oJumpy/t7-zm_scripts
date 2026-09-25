#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;

#namespace ability_gadgets;

/*
	Name: __init__sytem__
	Namespace: ability_gadgets
	Checksum: 0x6EF44C6D
	Offset: 0x1C0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ability_gadgets", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ability_gadgets
	Checksum: 0xF87324B1
	Offset: 0x200
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: gadgets_print
	Namespace: ability_gadgets
	Checksum: 0x99E6F959
	Offset: 0x250
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function gadgets_print(STR)
{
	/#
		if(GetDvarInt("Dev Block strings are not supported"))
		{
			var_ce775097 = STR;
			println(self.playerName + "Dev Block strings are not supported" + "Dev Block strings are not supported" + var_ce775097);
		}
	#/
}

/*
	Name: on_player_connect
	Namespace: ability_gadgets
	Checksum: 0x99EC1590
	Offset: 0x2D0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
}

/*
	Name: SetFlickering
	Namespace: ability_gadgets
	Checksum: 0x3058B03C
	Offset: 0x2E0
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function SetFlickering(slot, length)
{
	if(!isdefined(length))
	{
		length = 0;
	}
	self GadgetFlickering(slot, 1, length);
}

/*
	Name: on_player_spawned
	Namespace: ability_gadgets
	Checksum: 0x99EC1590
	Offset: 0x330
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
}

/*
	Name: gadget_give_callback
	Namespace: ability_gadgets
	Checksum: 0x431087E3
	Offset: 0x340
	Size: 0x6B
	Parameters: 3
	Flags: None
*/
function gadget_give_callback(ent, slot, weapon)
{
	/#
		ent gadgets_print("Dev Block strings are not supported" + slot + "Dev Block strings are not supported");
	#/
	ent ability_player::give_gadget(slot, weapon);
}

/*
	Name: gadget_take_callback
	Namespace: ability_gadgets
	Checksum: 0x5B0C47B3
	Offset: 0x3B8
	Size: 0x6B
	Parameters: 3
	Flags: None
*/
function gadget_take_callback(ent, slot, weapon)
{
	/#
		ent gadgets_print("Dev Block strings are not supported" + slot + "Dev Block strings are not supported");
	#/
	ent ability_player::take_gadget(slot, weapon);
}

/*
	Name: gadget_primed_callback
	Namespace: ability_gadgets
	Checksum: 0x9D8460FF
	Offset: 0x430
	Size: 0x6B
	Parameters: 3
	Flags: None
*/
function gadget_primed_callback(ent, slot, weapon)
{
	/#
		ent gadgets_print("Dev Block strings are not supported" + slot + "Dev Block strings are not supported");
	#/
	ent ability_player::gadget_primed(slot, weapon);
}

/*
	Name: gadget_ready_callback
	Namespace: ability_gadgets
	Checksum: 0xFD9662F3
	Offset: 0x4A8
	Size: 0x6B
	Parameters: 3
	Flags: None
*/
function gadget_ready_callback(ent, slot, weapon)
{
	/#
		ent gadgets_print("Dev Block strings are not supported" + slot + "Dev Block strings are not supported");
	#/
	ent ability_player::gadget_ready(slot, weapon);
}

/*
	Name: gadget_on_callback
	Namespace: ability_gadgets
	Checksum: 0xF6E77F53
	Offset: 0x520
	Size: 0x8B
	Parameters: 3
	Flags: None
*/
function gadget_on_callback(ent, slot, weapon)
{
	/#
		ent gadgets_print("Dev Block strings are not supported" + slot + "Dev Block strings are not supported");
	#/
	if(isdefined(level.BZMOnCyberComOnCallback))
	{
		level thread [[level.BZMOnCyberComOnCallback]](ent);
	}
	ent ability_player::turn_gadget_on(slot, weapon);
}

/*
	Name: gadget_off_callback
	Namespace: ability_gadgets
	Checksum: 0x64B60644
	Offset: 0x5B8
	Size: 0x6B
	Parameters: 3
	Flags: None
*/
function gadget_off_callback(ent, slot, weapon)
{
	/#
		ent gadgets_print("Dev Block strings are not supported" + slot + "Dev Block strings are not supported");
	#/
	ent ability_player::turn_gadget_off(slot, weapon);
}

/*
	Name: gadget_flicker_callback
	Namespace: ability_gadgets
	Checksum: 0x3F5D2D8A
	Offset: 0x630
	Size: 0x6B
	Parameters: 3
	Flags: None
*/
function gadget_flicker_callback(ent, slot, weapon)
{
	/#
		ent gadgets_print("Dev Block strings are not supported" + slot + "Dev Block strings are not supported");
	#/
	ent ability_player::gadget_flicker(slot, weapon);
}

