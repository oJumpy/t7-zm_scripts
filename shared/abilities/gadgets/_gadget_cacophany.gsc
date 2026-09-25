#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace _gadget_cacophany;

/*
	Name: __init__sytem__
	Namespace: _gadget_cacophany
	Checksum: 0xE4F7C4A2
	Offset: 0x1F8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_cacophany", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_cacophany
	Checksum: 0xDADE025C
	Offset: 0x238
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(25, &gadget_cacophany_on, &gadget_cacophany_off);
	ability_player::register_gadget_possession_callbacks(25, &gadget_cacophany_on_give, &gadget_cacophany_on_take);
	ability_player::register_gadget_flicker_callbacks(25, &gadget_cacophany_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(25, &gadget_cacophany_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(25, &gadget_cacophany_is_flickering);
	ability_player::register_gadget_primed_callbacks(25, &gadget_cacophany_is_primed);
	callback::on_connect(&gadget_cacophany_on_connect);
}

/*
	Name: gadget_cacophany_is_inuse
	Namespace: _gadget_cacophany
	Checksum: 0x140B76FB
	Offset: 0x348
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function gadget_cacophany_is_inuse(slot)
{
	return self flagsys::get("gadget_cacophany_on");
}

/*
	Name: gadget_cacophany_is_flickering
	Namespace: _gadget_cacophany
	Checksum: 0xE45529D
	Offset: 0x380
	Size: 0x4F
	Parameters: 1
	Flags: None
*/
function gadget_cacophany_is_flickering(slot)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.cacophany))
	{
		return self [[level.cybercom.cacophany._is_flickering]](slot);
	}
}

/*
	Name: gadget_cacophany_on_flicker
	Namespace: _gadget_cacophany
	Checksum: 0x62A53A39
	Offset: 0x3D8
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function gadget_cacophany_on_flicker(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.cacophany))
	{
		self [[level.cybercom.cacophany._on_flicker]](slot, weapon);
	}
}

/*
	Name: gadget_cacophany_on_give
	Namespace: _gadget_cacophany
	Checksum: 0xF34173E7
	Offset: 0x440
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function gadget_cacophany_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.cacophany))
	{
		self [[level.cybercom.cacophany._on_give]](slot, weapon);
	}
}

/*
	Name: gadget_cacophany_on_take
	Namespace: _gadget_cacophany
	Checksum: 0xA18B2384
	Offset: 0x4A8
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function gadget_cacophany_on_take(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.cacophany))
	{
		self [[level.cybercom.cacophany._on_take]](slot, weapon);
	}
}

/*
	Name: gadget_cacophany_on_connect
	Namespace: _gadget_cacophany
	Checksum: 0xBDD3CA4B
	Offset: 0x510
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function gadget_cacophany_on_connect()
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.cacophany))
	{
		self [[level.cybercom.cacophany._on_connect]]();
	}
}

/*
	Name: gadget_cacophany_on
	Namespace: _gadget_cacophany
	Checksum: 0x814517FD
	Offset: 0x560
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function gadget_cacophany_on(slot, weapon)
{
	self flagsys::set("gadget_cacophany_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.cacophany))
	{
		self [[level.cybercom.cacophany._on]](slot, weapon);
	}
}

/*
	Name: gadget_cacophany_off
	Namespace: _gadget_cacophany
	Checksum: 0x8AFB5C82
	Offset: 0x5E8
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function gadget_cacophany_off(slot, weapon)
{
	self flagsys::clear("gadget_cacophany_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.cacophany))
	{
		self [[level.cybercom.cacophany._off]](slot, weapon);
	}
}

/*
	Name: gadget_cacophany_is_primed
	Namespace: _gadget_cacophany
	Checksum: 0xEB357B7B
	Offset: 0x670
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function gadget_cacophany_is_primed(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.cacophany))
	{
		self [[level.cybercom.cacophany._is_primed]](slot, weapon);
	}
}

