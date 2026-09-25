#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace namespace_f3043f41;

/*
	Name: __init__sytem__
	Namespace: namespace_f3043f41
	Checksum: 0x5C89C7F2
	Offset: 0x1B8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_alchemical_antithesis", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_f3043f41
	Checksum: 0xF7A937ED
	Offset: 0x1F8
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_alchemical_antithesis", "activated", 2, undefined, undefined, &validation, &activation);
	bgb::function_336ffc4e("zm_bgb_alchemical_antithesis");
	bgb::function_ff4b2998("zm_bgb_alchemical_antithesis", &add_to_player_score_override, 0);
}

/*
	Name: validation
	Namespace: namespace_f3043f41
	Checksum: 0xA7310812
	Offset: 0x2A8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function validation()
{
	return !isdefined(self bgb::function_e2bcf80c()) && self bgb::function_e2bcf80c();
}

/*
	Name: activation
	Namespace: namespace_f3043f41
	Checksum: 0xFE1733BE
	Offset: 0x2E8
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function activation()
{
	self.ready_for_score_events = 0;
	self bgb::run_timer(60);
	self.ready_for_score_events = 1;
}

/*
	Name: add_to_player_score_override
	Namespace: namespace_f3043f41
	Checksum: 0x4F116CAB
	Offset: 0x328
	Size: 0x155
	Parameters: 3
	Flags: None
*/
function add_to_player_score_override(points, str_awarded_by, var_1ed9bd9b)
{
	if(!(isdefined(self.var_3244073f) && self.var_3244073f))
	{
		return points;
	}
	var_4375ef8a = Int(points / 10);
	current_weapon = self GetCurrentWeapon();
	if(zm_utility::is_offhand_weapon(current_weapon))
	{
		return points;
	}
	if(isdefined(self.IS_DRINKING) && self.IS_DRINKING)
	{
		return points;
	}
	if(current_weapon == level.weaponReviveTool)
	{
		return points;
	}
	var_b8f62d73 = self GetWeaponAmmoStock(current_weapon);
	var_b8f62d73 = var_b8f62d73 + var_4375ef8a;
	self SetWeaponAmmoStock(current_weapon, var_b8f62d73);
	self thread function_a6bf711f();
	self zm_stats::increment_challenge_stat("GUM_GOBBLER_ALCHEMICAL_ANTITHESIS", var_4375ef8a);
	return 0;
}

/*
	Name: function_a6bf711f
	Namespace: namespace_f3043f41
	Checksum: 0x6C1E26FE
	Offset: 0x488
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function function_a6bf711f()
{
	if(!isdefined(self.var_82764e33))
	{
		self.var_82764e33 = 0;
	}
	if(!self.var_82764e33)
	{
		self.var_82764e33 = 1;
		self playsoundtoplayer("zmb_bgb_alchemical_ammoget", self);
		wait(0.5);
		if(isdefined(self))
		{
			self.var_82764e33 = 0;
		}
	}
}

