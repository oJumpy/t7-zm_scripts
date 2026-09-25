#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_utility;

#namespace namespace_78eb0295;

/*
	Name: __init__sytem__
	Namespace: namespace_78eb0295
	Checksum: 0x53B3B716
	Offset: 0x188
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_soda_fountain", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_78eb0295
	Checksum: 0x3F0C8E30
	Offset: 0x1C8
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
	bgb::register("zm_bgb_soda_fountain", "event", &event, undefined, undefined, undefined);
}

/*
	Name: event
	Namespace: namespace_78eb0295
	Checksum: 0xF5A131A5
	Offset: 0x228
	Size: 0x177
	Parameters: 0
	Flags: None
*/
function event()
{
	self endon("disconnect");
	self endon("hash_994d5e9e");
	self.var_76382430 = 5;
	while(self.var_76382430 > 0)
	{
		self waittill("perk_purchased", str_perk);
		self bgb::do_one_shot_use();
		a_str_perks = getArrayKeys(level._custom_perks);
		if(IsInArray(a_str_perks, str_perk))
		{
			ArrayRemoveValue(a_str_perks, str_perk);
		}
		a_str_perks = Array::randomize(a_str_perks);
		for(i = 0; i < a_str_perks.size; i++)
		{
			if(!self hasPerk(a_str_perks[i]))
			{
				self zm_perks::give_perk(a_str_perks[i], 0);
				break;
			}
		}
		self.var_76382430--;
		self bgb::set_timer(self.var_76382430, 5);
	}
}

