#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_c9806b9;

/*
	Name: __init__sytem__
	Namespace: namespace_c9806b9
	Checksum: 0xD504E4EF
	Offset: 0x120
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_staff", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_c9806b9
	Checksum: 0x22C0E03F
	Offset: 0x160
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.var_27b5be99 = [];
	callback::on_localplayer_spawned(&function_d10163c2);
}

/*
	Name: function_4be5e665
	Namespace: namespace_c9806b9
	Checksum: 0x2CD8922
	Offset: 0x1A0
	Size: 0x25
	Parameters: 2
	Flags: None
*/
function function_4be5e665(w_weapon, FX)
{
	level.var_27b5be99[w_weapon] = FX;
}

/*
	Name: function_d10163c2
	Namespace: namespace_c9806b9
	Checksum: 0xC7652C7A
	Offset: 0x1D0
	Size: 0xB7
	Parameters: 1
	Flags: None
*/
function function_d10163c2(localClientNum)
{
	self notify("hash_d10163c2");
	self endon("hash_d10163c2");
	self endon("entityshutdown");
	while(isdefined(self))
	{
		self waittill("weapon_change", w_weapon);
		self notify("hash_d4c51f0");
		self function_d4c51f0(localClientNum);
		if(isdefined(level.var_27b5be99[w_weapon]))
		{
			self thread function_2b18ce1b(localClientNum, level.var_27b5be99[w_weapon]);
		}
	}
}

/*
	Name: function_2b18ce1b
	Namespace: namespace_c9806b9
	Checksum: 0x207FDC2B
	Offset: 0x290
	Size: 0xAF
	Parameters: 2
	Flags: None
*/
function function_2b18ce1b(localClientNum, FX)
{
	self endon("hash_d4c51f0");
	while(isdefined(self))
	{
		charge = function_11e8db(localClientNum);
		if(charge > 0)
		{
			if(!isdefined(self.var_2a76e26))
			{
				self.var_2a76e26 = PlayViewmodelFX(localClientNum, FX, "tag_fx_upg_1");
			}
		}
		else
		{
			function_d4c51f0(localClientNum);
		}
		wait(0.15);
	}
}

/*
	Name: function_d4c51f0
	Namespace: namespace_c9806b9
	Checksum: 0x1854DE80
	Offset: 0x348
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function function_d4c51f0(localClientNum)
{
	if(isdefined(self.var_2a76e26))
	{
		stopfx(localClientNum, self.var_2a76e26);
		self.var_2a76e26 = undefined;
	}
}

