#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_unbearable;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_unbearable
	Checksum: 0x6A21CC2C
	Offset: 0x1A0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_unbearable", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_bgb_unbearable
	Checksum: 0x64AAF439
	Offset: 0x1E0
	Size: 0x9D
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_unbearable", "event");
	clientfield::register("zbarrier", "zm_bgb_unbearable", 1, 1, "counter", &function_cd297226, 0, 0);
	level._effect["zm_bgb_unbearable"] = "zombie/fx_bgb_unbearable_box_flash_zmb";
}

/*
	Name: function_cd297226
	Namespace: zm_bgb_unbearable
	Checksum: 0x549D0CEF
	Offset: 0x288
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_cd297226(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	playFX(localClientNum, level._effect["zm_bgb_unbearable"], self.origin, AnglesToForward(self.angles), anglesToUp(self.angles));
}

