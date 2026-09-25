#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm;

#namespace namespace_af029029;

/*
	Name: __init__sytem__
	Namespace: namespace_af029029
	Checksum: 0x3B24078B
	Offset: 0x100
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_spiders", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_af029029
	Checksum: 0x99EC1590
	Offset: 0x148
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

/*
	Name: __main__
	Namespace: namespace_af029029
	Checksum: 0x2BFA4382
	Offset: 0x158
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function __main__()
{
	register_clientfields();
}

/*
	Name: register_clientfields
	Namespace: namespace_af029029
	Checksum: 0x99EC1590
	Offset: 0x178
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
}

