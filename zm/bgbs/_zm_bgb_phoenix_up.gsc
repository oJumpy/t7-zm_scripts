#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace namespace_7ffac71e;

/*
	Name: __init__sytem__
	Namespace: namespace_7ffac71e
	Checksum: 0x1A7644A8
	Offset: 0x1E8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_phoenix_up", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_7ffac71e
	Checksum: 0x74FCAAC7
	Offset: 0x228
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_phoenix_up", "activated", 1, undefined, undefined, &validation, &activation);
	bgb::register_lost_perk_override("zm_bgb_phoenix_up", &lost_perk_override, 1);
}

/*
	Name: validation
	Namespace: namespace_7ffac71e
	Checksum: 0xCC00651F
	Offset: 0x2C8
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function validation()
{
	players = level.players;
	foreach(player in players)
	{
		if(isdefined(player.var_df0decf1) && player.var_df0decf1)
		{
			return 0;
			continue;
		}
		if(isdefined(level.var_11b06c2f) && self [[level.var_11b06c2f]](player, 1, 1))
		{
			return 1;
			continue;
		}
		if(self zm_laststand::can_revive(player, 1, 1))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: activation
	Namespace: namespace_7ffac71e
	Checksum: 0xB1AA846B
	Offset: 0x3E8
	Size: 0x171
	Parameters: 0
	Flags: None
*/
function activation()
{
	playsoundatposition("zmb_bgb_phoenix_activate", (0, 0, 0));
	players = level.players;
	foreach(player in players)
	{
		can_revive = 0;
		if(isdefined(level.var_11b06c2f) && self [[level.var_11b06c2f]](player, 1, 1))
		{
			can_revive = 1;
		}
		else if(self zm_laststand::can_revive(player, 1, 1))
		{
			can_revive = 1;
		}
		if(can_revive)
		{
			player thread bgb::function_7d63d2eb();
			player zm_laststand::auto_revive(self, 0);
			self zm_stats::increment_challenge_stat("GUM_GOBBLER_PHOENIX_UP");
		}
	}
}

/*
	Name: lost_perk_override
	Namespace: namespace_7ffac71e
	Checksum: 0xD209B7EB
	Offset: 0x568
	Size: 0x5D
	Parameters: 3
	Flags: None
*/
function lost_perk_override(perk, var_2488e46a, var_24df4040)
{
	if(!isdefined(var_2488e46a))
	{
		var_2488e46a = undefined;
	}
	if(!isdefined(var_24df4040))
	{
		var_24df4040 = undefined;
	}
	self thread bgb::function_41ed378b(perk);
	return 0;
}

