#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace namespace_bcb3abbf;

/*
	Name: __init__sytem__
	Namespace: namespace_bcb3abbf
	Checksum: 0xF8ED0BCC
	Offset: 0x3B0
	Size: 0x43
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_disorderly_combat", &__init__, &__main__, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_bcb3abbf
	Checksum: 0xAA7C8B1C
	Offset: 0x400
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
	bgb::register("zm_bgb_disorderly_combat", "time", 300, &enable, &disable, undefined, undefined);
	bgb::function_2060b89("zm_bgb_disorderly_combat");
	level.var_8fcdc919 = [];
	level.var_5013e65c = [];
}

/*
	Name: __main__
	Namespace: namespace_bcb3abbf
	Checksum: 0x53464231
	Offset: 0x4A0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function __main__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	function_32710943();
}

/*
	Name: enable
	Namespace: namespace_bcb3abbf
	Checksum: 0x7BCFE5E3
	Offset: 0x4D8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function enable()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("hash_994d5e9e");
	self function_7039f685();
}

/*
	Name: disable
	Namespace: namespace_bcb3abbf
	Checksum: 0xF5DEC5E0
	Offset: 0x520
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function disable()
{
	function_bd7f98af();
}

/*
	Name: function_32710943
	Namespace: namespace_bcb3abbf
	Checksum: 0x7DB249BE
	Offset: 0x540
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function function_32710943()
{
	var_dd341085 = getArrayKeys(level.zombie_weapons);
	foreach(var_134a15b0 in var_dd341085)
	{
		var_134a15b0 function_32818605();
	}
	if(isdefined(level.AAT))
	{
		level.var_5013e65c = getArrayKeys(level.AAT);
		ArrayRemoveValue(level.var_5013e65c, "none");
	}
}

/*
	Name: function_a2ab8d19
	Namespace: namespace_bcb3abbf
	Checksum: 0x9DDDFA3B
	Offset: 0x648
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_a2ab8d19(var_390e457)
{
	ArrayRemoveValue(level.var_8fcdc919, var_390e457);
}

/*
	Name: function_32818605
	Namespace: namespace_bcb3abbf
	Checksum: 0x1601F055
	Offset: 0x680
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_32818605()
{
	if(!self.isMeleeWeapon && !self.isgrenadeweapon && !self function_f0cecf3c())
	{
		Array::add(level.var_8fcdc919, self, 0);
	}
}

/*
	Name: function_7039f685
	Namespace: namespace_bcb3abbf
	Checksum: 0x3A61DE60
	Offset: 0x6E0
	Size: 0x34D
	Parameters: 0
	Flags: None
*/
function function_7039f685()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("hash_994d5e9e");
	level.var_8fcdc919 = Array::randomize(level.var_8fcdc919);
	self setPerk("specialty_ammodrainsfromstockfirst");
	self thread disable_weapons();
	self.get_player_weapon_limit = &function_7087df78;
	self util::waittill_either("weapon_change_complete", "bgb_flavor_hexed_give_zm_bgb_disorderly_combat");
	if(!isdefined(self.var_fe555a38))
	{
		self.var_fe555a38 = self GetCurrentWeapon();
	}
	var_2826b50 = zm_weapons::is_weapon_upgraded(self.var_fe555a38);
	var_6c94ea19 = self AAT::getAATOnWeapon(self.var_fe555a38);
	if(isdefined(var_6c94ea19))
	{
		function_c7d73bac(var_6c94ea19.name);
	}
	if(isdefined(self.AAT) && self.AAT.size)
	{
		self.var_cc73883d = ArrayCopy(self.AAT);
		self.AAT = [];
	}
	n_index = 0;
	var_1ff6fb34 = 0;
	while(1)
	{
		self bgb::function_378bff5d();
		self function_8a5ef15f();
		if(isdefined(self.var_8cee13f3))
		{
			if(self HasWeapon(self.var_8cee13f3))
			{
				self TakeWeapon(self.var_8cee13f3);
			}
			else
			{
				self TakeWeapon(self GetCurrentWeapon());
			}
		}
		self playsoundtoplayer("zmb_bgb_disorderly_weap_switch", self);
		if(isdefined(var_6c94ea19) && level.var_5013e65c.size)
		{
			var_77bd95a = level.var_5013e65c[var_1ff6fb34];
			var_1ff6fb34++;
			if(var_1ff6fb34 >= level.var_5013e65c.size)
			{
				level.var_5013e65c = Array::randomize(level.var_5013e65c);
				var_1ff6fb34 = 0;
			}
		}
		do
		{
			var_aca7cde1 = self function_4035ce17(n_index, var_2826b50, var_77bd95a);
			n_index++;
		}
		while(!!var_aca7cde1);
		self thread function_dedb7bff();
		wait(10);
	}
}

/*
	Name: function_dedb7bff
	Namespace: namespace_bcb3abbf
	Checksum: 0x99D0311D
	Offset: 0xA38
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_dedb7bff()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("hash_994d5e9e");
	wait(5);
	self playsoundtoplayer("zmb_bgb_disorderly_5seconds", self);
}

/*
	Name: disable_weapons
	Namespace: namespace_bcb3abbf
	Checksum: 0x26973370
	Offset: 0xA90
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function disable_weapons()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("hash_994d5e9e");
	while(1)
	{
		waittillframeend;
		self DisableWeaponCycling();
		self disableOffhandWeapons();
		wait(0.05);
	}
}

/*
	Name: function_4035ce17
	Namespace: namespace_bcb3abbf
	Checksum: 0xCE0C0F39
	Offset: 0xB00
	Size: 0x1A7
	Parameters: 3
	Flags: None
*/
function function_4035ce17(n_index, var_2826b50, var_77bd95a)
{
	if(n_index >= level.var_8fcdc919.size)
	{
		level.var_8fcdc919 = Array::randomize(level.var_8fcdc919);
		n_index = 0;
	}
	var_e3c04036 = level.var_8fcdc919[n_index];
	if(var_2826b50)
	{
		var_e3c04036 = zm_weapons::get_upgrade_weapon(var_e3c04036);
	}
	if(!self has_weapon(var_e3c04036))
	{
		var_e3c04036 = self zm_weapons::give_build_kit_weapon(var_e3c04036);
		self.var_8cee13f3 = var_e3c04036;
		self GiveWeapon(var_e3c04036);
		self function_92dca8b7(var_e3c04036, 0);
		self SwitchToWeaponImmediate(var_e3c04036);
		if(isdefined(var_77bd95a) && var_77bd95a != "none")
		{
			self thread AAT::acquire(var_e3c04036, var_77bd95a);
		}
		self bgb::do_one_shot_use(1);
		return 1;
	}
	else
	{
		println("Dev Block strings are not supported" + var_e3c04036.displayName);
		return 0;
	}
	/#
	#/
}

/*
	Name: function_f0cecf3c
	Namespace: namespace_bcb3abbf
	Checksum: 0x102EF4D5
	Offset: 0xCB0
	Size: 0x95
	Parameters: 0
	Flags: None
*/
function function_f0cecf3c()
{
	switch(self.name)
	{
		case "ar_marksman":
		case "launcher_standard":
		case "none":
		case "pistol_burst":
		case "pistol_c96":
		case "pistol_m1911":
		case "pistol_revolver38":
		case "sniper_fastbolt":
		case "sniper_powerbolt":
		{
			return 1;
			break;
		}
	}
	if(zm_weapons::is_wonder_weapon(self) || level.start_weapon == self)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_bd7f98af
	Namespace: namespace_bcb3abbf
	Checksum: 0xEBF79993
	Offset: 0xD50
	Size: 0x181
	Parameters: 0
	Flags: None
*/
function function_bd7f98af()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("bgb_update_give_" + "zm_bgb_disorderly_combat");
	self thread function_be4232bc();
	self unsetPerk("specialty_ammodrainsfromstockfirst");
	self function_8a5ef15f();
	if(isdefined(self.var_8cee13f3) && self HasWeapon(self.var_8cee13f3))
	{
		self TakeWeapon(self.var_8cee13f3);
		self.var_8cee13f3 = undefined;
	}
	self.get_player_weapon_limit = undefined;
	if(isdefined(self.var_fe555a38))
	{
		self zm_weapons::switch_back_primary_weapon(self.var_fe555a38);
	}
	self EnableWeaponCycling();
	self EnableOffhandWeapons();
	self.var_fe555a38 = undefined;
	if(isdefined(self.var_cc73883d))
	{
		self.AAT = ArrayCopy(self.var_cc73883d);
		self.var_cc73883d = undefined;
	}
	self notify("hash_46a5bae0");
}

/*
	Name: function_be4232bc
	Namespace: namespace_bcb3abbf
	Checksum: 0xCBEC705C
	Offset: 0xEE0
	Size: 0x2D
	Parameters: 0
	Flags: None
*/
function function_be4232bc()
{
	self endon("hash_46a5bae0");
	self waittill("bled_out");
	self.var_8cee13f3 = undefined;
	self.var_fe555a38 = undefined;
}

/*
	Name: function_1f90c35a
	Namespace: namespace_bcb3abbf
	Checksum: 0x460964ED
	Offset: 0xF18
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function function_1f90c35a()
{
	if(isdefined(level.var_464197de))
	{
		return self [[level.var_464197de]]();
	}
	return 0;
}

/*
	Name: function_8a5ef15f
	Namespace: namespace_bcb3abbf
	Checksum: 0x18EB50ED
	Offset: 0xF48
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function function_8a5ef15f()
{
	while(self.IS_DRINKING > 0 || zm_utility::is_placeable_mine(self.currentWeapon) || zm_equipment::is_equipment(self.currentWeapon) || self zm_utility::is_player_revive_tool(self.currentWeapon) || level.weaponNone == self.currentWeapon || self zm_equipment::hacker_active() || self laststand::player_is_in_laststand() || self function_1f90c35a())
	{
		wait(0.05);
	}
}

/*
	Name: function_c7d73bac
	Namespace: namespace_bcb3abbf
	Checksum: 0xF6B7C8F0
	Offset: 0x1028
	Size: 0xB9
	Parameters: 1
	Flags: None
*/
function function_c7d73bac(str_name)
{
	ArrayRemoveValue(level.var_5013e65c, str_name);
	level.var_5013e65c = Array::randomize(level.var_5013e65c);
	if(!isdefined(level.var_5013e65c))
	{
		level.var_5013e65c = [];
	}
	else if(!IsArray(level.var_5013e65c))
	{
		level.var_5013e65c = Array(level.var_5013e65c);
	}
	level.var_5013e65c[level.var_5013e65c.size] = str_name;
}

/*
	Name: has_weapon
	Namespace: namespace_bcb3abbf
	Checksum: 0x575CFA8C
	Offset: 0x10F0
	Size: 0xBD
	Parameters: 1
	Flags: None
*/
function has_weapon(var_382bb75)
{
	a_weapons = self GetWeaponsListPrimaries();
	w_base = zm_weapons::get_base_weapon(var_382bb75);
	if(self HasWeapon(w_base, 1))
	{
		return 1;
	}
	var_7321b53b = zm_weapons::get_upgrade_weapon(var_382bb75);
	if(self HasWeapon(var_7321b53b, 1))
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_7087df78
	Namespace: namespace_bcb3abbf
	Checksum: 0x1C90CA94
	Offset: 0x11B8
	Size: 0x55
	Parameters: 1
	Flags: None
*/
function function_7087df78(e_player)
{
	var_dd27188c = 2;
	if(e_player hasPerk("specialty_additionalprimaryweapon"))
	{
		var_dd27188c = level.additionalprimaryweapon_limit;
	}
	var_dd27188c++;
	return var_dd27188c;
}

