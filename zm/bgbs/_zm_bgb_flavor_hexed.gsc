#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#namespace namespace_3ecfcb30;

/*
	Name: __init__sytem__
	Namespace: namespace_3ecfcb30
	Checksum: 0xD8BFB07
	Offset: 0x240
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_flavor_hexed", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_3ecfcb30
	Checksum: 0x85B9D166
	Offset: 0x280
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
	bgb::register("zm_bgb_flavor_hexed", "event", &event, undefined, undefined, undefined);
}

/*
	Name: event
	Namespace: namespace_3ecfcb30
	Checksum: 0x1C0336DD
	Offset: 0x2E0
	Size: 0x1C3
	Parameters: 0
	Flags: None
*/
function event()
{
	self endon("disconnect");
	self endon("bled_out");
	self.var_c3a5a8 = [];
	var_2cf032a6 = self.var_98ba48a2;
	foreach(var_410edbc8 in level.bgb)
	{
		if(var_410edbc8.var_e0715b48 == 1)
		{
			if(!IsInArray(var_2cf032a6, var_23359ff6) && var_23359ff6 != "zm_bgb_flavor_hexed")
			{
				if(!isdefined(self.var_c3a5a8))
				{
					self.var_c3a5a8 = [];
				}
				else if(!IsArray(self.var_c3a5a8))
				{
					self.var_c3a5a8 = Array(self.var_c3a5a8);
				}
				self.var_c3a5a8[self.var_c3a5a8.size] = var_23359ff6;
			}
		}
	}
	/#
		Assert(self.var_c3a5a8.size, "Dev Block strings are not supported");
	#/
	var_50f0f8bb = Array::random(self.var_c3a5a8);
	self thread function_9a45adfb(var_50f0f8bb);
}

/*
	Name: function_9a45adfb
	Namespace: namespace_3ecfcb30
	Checksum: 0x82B521A0
	Offset: 0x4B0
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function function_9a45adfb(var_50f0f8bb)
{
	wait(1);
	self thread function_655e0571(var_50f0f8bb);
	self playsoundtoplayer("zmb_bgb_flavorhex", self);
	self thread bgb::give(var_50f0f8bb);
	ArrayRemoveValue(self.var_c3a5a8, var_50f0f8bb);
}

/*
	Name: function_655e0571
	Namespace: namespace_3ecfcb30
	Checksum: 0x218D34AA
	Offset: 0x540
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function function_655e0571(var_50f0f8bb)
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("hash_fcbbef99");
	self waittill("bgb_update_give_" + var_50f0f8bb);
	self notify("bgb_flavor_hexed_give_" + var_50f0f8bb);
	self waittill("hash_994d5e9e", var_1531e8c4, var_9a4acf7);
	if(var_9a4acf7 === var_50f0f8bb && self.var_c3a5a8.size)
	{
		var_df8558a0 = Array::random(self.var_c3a5a8);
		self playsoundtoplayer("zmb_bgb_flavorhex", self);
		self thread function_21f6c6f5(var_df8558a0);
		self bgb::give(var_df8558a0);
	}
}

/*
	Name: function_21f6c6f5
	Namespace: namespace_3ecfcb30
	Checksum: 0x8ED1A3AD
	Offset: 0x650
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function function_21f6c6f5(var_50f0f8bb)
{
	self endon("disconnect");
	self endon("bled_out");
	self waittill("bgb_update_give_" + var_50f0f8bb);
	self notify("bgb_flavor_hexed_give_" + var_50f0f8bb);
}

