#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#namespace namespace_ddb9c921;

/*
	Name: __init__sytem__
	Namespace: namespace_ddb9c921
	Checksum: 0x303AC2B3
	Offset: 0x200
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_respin_cycle", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_ddb9c921
	Checksum: 0x9CFF218C
	Offset: 0x240
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
	bgb::register("zm_bgb_respin_cycle", "activated", 2, undefined, undefined, &validation, &activation);
	clientfield::register("zbarrier", "zm_bgb_respin_cycle", 1, 1, "counter");
}

/*
	Name: validation
	Namespace: namespace_ddb9c921
	Checksum: 0x98B25939
	Offset: 0x2E0
	Size: 0x95
	Parameters: 0
	Flags: None
*/
function validation()
{
	for(i = 0; i < level.chests.size; i++)
	{
		Chest = level.chests[i];
		if(isdefined(Chest.zbarrier.weapon_model) && isdefined(Chest.chest_user) && self == Chest.chest_user)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: activation
	Namespace: namespace_ddb9c921
	Checksum: 0xB4E0655
	Offset: 0x380
	Size: 0xB5
	Parameters: 0
	Flags: None
*/
function activation()
{
	self endon("disconnect");
	for(i = 0; i < level.chests.size; i++)
	{
		Chest = level.chests[i];
		if(isdefined(Chest.zbarrier.weapon_model) && isdefined(Chest.chest_user) && self == Chest.chest_user)
		{
			Chest thread function_7a5dc39b(self);
		}
	}
}

/*
	Name: function_7a5dc39b
	Namespace: namespace_ddb9c921
	Checksum: 0x898A9EDB
	Offset: 0x440
	Size: 0x1CB
	Parameters: 1
	Flags: None
*/
function function_7a5dc39b(player)
{
	self.zbarrier clientfield::increment("zm_bgb_respin_cycle");
	if(isdefined(self.zbarrier.weapon_model))
	{
		self.zbarrier.weapon_model notify("kill_respin_think_thread");
	}
	self.no_fly_away = 1;
	self.zbarrier notify("box_hacked_respin");
	self.zbarrier playsound("zmb_bgb_powerup_respin");
	self thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	zm_utility::play_sound_at_pos("open_chest", self.zbarrier.origin);
	zm_utility::play_sound_at_pos("music_chest", self.zbarrier.origin);
	self.zbarrier thread zm_magicbox::treasure_chest_weapon_spawn(self, player);
	self.zbarrier waittill("randomization_done");
	self.no_fly_away = undefined;
	if(!level flag::get("moving_chest_now"))
	{
		self.grab_weapon_hint = 1;
		self.grab_weapon = self.zbarrier.weapon;
		self thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &zm_magicbox::magicbox_unitrigger_think);
		self thread zm_magicbox::treasure_chest_timeout();
	}
}

