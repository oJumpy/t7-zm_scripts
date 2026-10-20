#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\beam_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_grappler;

/*
	Name: __init__sytem__
	Namespace: zm_grappler
	Checksum: 0xF7763E72
	Offset: 0x208
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_grappler", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_grappler
	Checksum: 0xD78A5AEB
	Offset: 0x248
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "grappler_beam_source", 15000, 1, "int", &grappler_source, 0, 0);
	clientfield::register("scriptmover", "grappler_beam_target", 15000, 1, "int", &grappler_beam, 0, 0);
}

/*
	Name: grappler_source
	Namespace: zm_grappler
	Checksum: 0x2BEDF7C9
	Offset: 0x2E8
	Size: 0x6D
	Parameters: 7
	Flags: None
*/
function grappler_source(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(level.grappler_sources))
	{
		level.grappler_sources = [];
	}
	if(newVal)
	{
		level.grappler_sources[localClientNum] = self;
	}
}

/*
	Name: grappler_beam
	Namespace: zm_grappler
	Checksum: 0x99739A26
	Offset: 0x360
	Size: 0xD5
	Parameters: 7
	Flags: None
*/
function grappler_beam(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(level.grappler_sources))
	{
		level.grappler_sources = [];
	}
	/#
		Assert(isdefined(level.grappler_sources[localClientNum]));
	#/
	pivot = level.grappler_sources[localClientNum];
	if(newVal)
	{
		thread function_55af4b5b(self, "tag_origin", pivot, 0.05);
	}
	else
	{
		self notify("grappler_done");
	}
}

/*
	Name: function_55af4b5b
	Namespace: zm_grappler
	Checksum: 0x10DD379B
	Offset: 0x440
	Size: 0x53
	Parameters: 4
	Flags: None
*/
function function_55af4b5b(player, tag, pivot, delay)
{
	player endon("grappler_done");
	wait(delay);
	thread grapple_beam(player, tag, pivot);
}

/*
	Name: grapple_beam
	Namespace: zm_grappler
	Checksum: 0x48D4D47E
	Offset: 0x4A0
	Size: 0x8B
	Parameters: 3
	Flags: None
*/
function grapple_beam(player, tag, pivot)
{
	level beam::launch(player, tag, pivot, "tag_origin", "zod_beast_grapple_beam");
	player waittill("grappler_done");
	level beam::kill(player, tag, pivot, "tag_origin", "zod_beast_grapple_beam");
}

