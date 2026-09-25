#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_b0f00253;

/*
	Name: __init__sytem__
	Namespace: namespace_b0f00253
	Checksum: 0xC51104C2
	Offset: 0x178
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_on_the_house", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_b0f00253
	Checksum: 0xE8DD6036
	Offset: 0x1B8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_on_the_house", "activated", 1, undefined, undefined, undefined, &activation);
}

/*
	Name: activation
	Namespace: namespace_b0f00253
	Checksum: 0x3431E142
	Offset: 0x218
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function activation()
{
	self thread bgb::function_dea74fb0("free_perk");
}

