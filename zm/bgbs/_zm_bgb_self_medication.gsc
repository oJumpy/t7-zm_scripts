#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_a7758d0b;

/*
	Name: __init__sytem__
	Namespace: namespace_a7758d0b
	Checksum: 0xD39F7AA2
	Offset: 0x250
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_self_medication", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_a7758d0b
	Checksum: 0x99DFF58A
	Offset: 0x290
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_self_medication", "event", &event, undefined, undefined, &validation);
	bgb::function_2b341a2e("zm_bgb_self_medication", &actor_death_override);
	bgb::register_lost_perk_override("zm_bgb_self_medication", &lost_perk_override, 0);
}

/*
	Name: event
	Namespace: namespace_a7758d0b
	Checksum: 0x94DE5BAE
	Offset: 0x348
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function event()
{
	self endon("disconnect");
	self endon("hash_994d5e9e");
	self endon("hash_1c39189f");
	self.var_25b88da = 3;
	self.w_min_last_stand_pistol_override = GetWeapon("ray_gun");
	level zm_utility::increment_no_end_game_check();
	self thread function_5816d71a();
	self thread function_cfc2c8d5();
	while(1)
	{
		self waittill("player_downed");
		self thread function_a8fd61f4();
	}
}

/*
	Name: validation
	Namespace: namespace_a7758d0b
	Checksum: 0x898C956D
	Offset: 0x418
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function validation()
{
	if(isdefined(self.var_df0decf1) && self.var_df0decf1)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_5816d71a
	Namespace: namespace_a7758d0b
	Checksum: 0x20389A43
	Offset: 0x448
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_5816d71a()
{
	self util::waittill_any("disconnect", "bgb_update", "bgb_self_medication_complete");
	if(isdefined(self))
	{
		self.w_min_last_stand_pistol_override = undefined;
	}
	wait(0.2);
	level zm_utility::decrement_no_end_game_check();
}

/*
	Name: actor_death_override
	Namespace: namespace_a7758d0b
	Checksum: 0xDE13F5F
	Offset: 0x4B8
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function actor_death_override(e_attacker)
{
	if(e_attacker laststand::player_is_in_laststand() && (!isdefined(e_attacker.var_df0decf1) && e_attacker.var_df0decf1))
	{
		e_attacker thread bgb::function_7d63d2eb();
		e_attacker notify("hash_935cc366");
	}
}

/*
	Name: function_cfc2c8d5
	Namespace: namespace_a7758d0b
	Checksum: 0x7CA72261
	Offset: 0x538
	Size: 0x1A3
	Parameters: 0
	Flags: None
*/
function function_cfc2c8d5()
{
	self endon("disconnect");
	self endon("hash_994d5e9e");
	while(1)
	{
		self waittill("hash_935cc366");
		while(self GetCurrentWeapon() !== self.laststandpistol)
		{
			wait(0.05);
		}
		if(isdefined(self.has_specific_powerup_weapon) && (isdefined(self.has_specific_powerup_weapon["minigun"]) && self.has_specific_powerup_weapon["minigun"]))
		{
			zm_powerups::weapon_powerup_remove(self, "minigun_time_over", "minigun", 1);
		}
		self bgb::do_one_shot_use();
		self playsoundtoplayer("zmb_bgb_self_medication", self);
		if(isdefined(self.reviveTrigger) && isdefined(self.reviveTrigger.beingRevived))
		{
			self.reviveTrigger SetInvisibleToAll();
			self.reviveTrigger.beingRevived = 0;
		}
		self zm_laststand::auto_revive(self, 0);
		self.var_25b88da--;
		self bgb::set_timer(self.var_25b88da, 3);
		if(self.var_25b88da == 0)
		{
			self notify("hash_1c39189f");
			return;
		}
	}
}

/*
	Name: function_a8fd61f4
	Namespace: namespace_a7758d0b
	Checksum: 0xAFF20DE
	Offset: 0x6E8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_a8fd61f4()
{
	self endon("player_revived");
	self endon("disconnect");
	self endon("bled_out");
	self waittill("player_eaten_by_thrasher");
	self.thrasher kill(self.thrasher.origin, self);
}

/*
	Name: lost_perk_override
	Namespace: namespace_a7758d0b
	Checksum: 0x51CBB794
	Offset: 0x750
	Size: 0x7D
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
	if(isdefined(var_2488e46a) && isdefined(var_24df4040) && var_2488e46a == var_24df4040)
	{
		self thread bgb::function_41ed378b(perk);
	}
	return 0;
}

