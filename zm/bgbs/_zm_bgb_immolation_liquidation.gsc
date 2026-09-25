#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_cbb0522a;

/*
	Name: __init__sytem__
	Namespace: namespace_cbb0522a
	Checksum: 0x691467CC
	Offset: 0x188
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_immolation_liquidation", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_cbb0522a
	Checksum: 0x4C05325F
	Offset: 0x1C8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_immolation_liquidation", "activated", 3, undefined, undefined, &function_3d1f600e, &activation);
}

/*
	Name: activation
	Namespace: namespace_cbb0522a
	Checksum: 0x33C4332E
	Offset: 0x238
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function activation()
{
	self thread bgb::function_dea74fb0("fire_sale");
}

/*
	Name: function_3d1f600e
	Namespace: namespace_cbb0522a
	Checksum: 0xD54D9F7B
	Offset: 0x268
	Size: 0x3D
	Parameters: 0
	Flags: None
*/
function function_3d1f600e()
{
	if(level.zombie_vars["zombie_powerup_fire_sale_on"] === 1 || (isdefined(level.disable_firesale_drop) && level.disable_firesale_drop))
	{
		return 0;
	}
	return 1;
}

