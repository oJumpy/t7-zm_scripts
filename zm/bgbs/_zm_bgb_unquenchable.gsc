#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_unquenchable;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_unquenchable
	Checksum: 0xC9AAF7E7
	Offset: 0x148
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_unquenchable", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_unquenchable
	Checksum: 0x98F6E7AC
	Offset: 0x188
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
	bgb::register("zm_bgb_unquenchable", "event", &event, undefined, undefined, undefined);
}

/*
	Name: event
	Namespace: zm_bgb_unquenchable
	Checksum: 0x23D1DECD
	Offset: 0x1E8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function event()
{
	self endon("disconnect");
	self endon("bgb_update");
	do
	{
		self waittill("perk_purchased");
	}
	while(!self.num_perks < self zm_utility::get_player_perk_purchase_limit());
	self bgb::do_one_shot_use(1);
}

