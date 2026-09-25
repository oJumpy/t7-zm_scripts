#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_66043662;

/*
	Name: __init__sytem__
	Namespace: namespace_66043662
	Checksum: 0x1FF411DC
	Offset: 0x140
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_tone_death", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_66043662
	Checksum: 0x543D2E8B
	Offset: 0x180
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_tone_death", "event");
}

