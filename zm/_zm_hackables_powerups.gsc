#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_equip_hacker;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;

#namespace namespace_27e18f93;

/*
	Name: unhackable_powerup
	Namespace: namespace_27e18f93
	Checksum: 0xDE066432
	Offset: 0x1C0
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function unhackable_powerup(name)
{
	ret = 0;
	switch(name)
	{
		case "bonus_points_player":
		case "bonus_points_team":
		case "lose_points_team":
		case "random_weapon":
		case "ww_grenade":
		{
			ret = 1;
			break;
		}
	}
	return ret;
}

/*
	Name: hack_powerups
	Namespace: namespace_27e18f93
	Checksum: 0xC54CB437
	Offset: 0x230
	Size: 0x127
	Parameters: 0
	Flags: None
*/
function hack_powerups()
{
	while(1)
	{
		level waittill("powerup_dropped", powerup);
		if(!unhackable_powerup(powerup.powerup_name))
		{
			struct = spawnstruct();
			struct.origin = powerup.origin;
			struct.radius = 65;
			struct.height = 72;
			struct.script_float = 5;
			struct.script_int = 5000;
			struct.powerup = powerup;
			powerup thread powerup_pickup_watcher(struct);
			namespace_6d813654::register_pooled_hackable_struct(struct, &powerup_hack);
		}
	}
}

/*
	Name: powerup_pickup_watcher
	Namespace: namespace_27e18f93
	Checksum: 0xA3063F9C
	Offset: 0x360
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function powerup_pickup_watcher(powerup_struct)
{
	self endon("hacked");
	self waittill("death");
	namespace_6d813654::deregister_hackable_struct(powerup_struct);
}

/*
	Name: powerup_hack
	Namespace: namespace_27e18f93
	Checksum: 0x586497CC
	Offset: 0x3A8
	Size: 0x1B3
	Parameters: 1
	Flags: None
*/
function powerup_hack(hacker)
{
	self.powerup notify("hacked");
	if(isdefined(self.powerup.zombie_grabbable) && self.powerup.zombie_grabbable)
	{
		self.powerup notify("powerup_timedout");
		origin = self.powerup.origin;
		self.powerup delete();
		self.powerup = zm_net::network_safe_spawn("powerup", 1, "script_model", origin);
		if(isdefined(self.powerup))
		{
			self.powerup zm_powerups::powerup_setup("full_ammo");
			self.powerup thread zm_powerups::powerup_timeout();
			self.powerup thread zm_powerups::powerup_wobble();
			self.powerup thread zm_powerups::powerup_grab();
		}
	}
	else if(self.powerup.powerup_name == "full_ammo")
	{
		self.powerup zm_powerups::powerup_setup("fire_sale");
	}
	else
	{
		self.powerup zm_powerups::powerup_setup("full_ammo");
	}
	namespace_6d813654::deregister_hackable_struct(self);
}

