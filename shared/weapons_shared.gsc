#using scripts\codescripts\struct;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapons;

#namespace weapons;

/*
	Name: is_primary_weapon
	Namespace: weapons
	Checksum: 0xAA47FC6F
	Offset: 0x148
	Size: 0x45
	Parameters: 1
	Flags: None
*/
function is_primary_weapon(weapon)
{
	root_weapon = weapon.rootweapon;
	return root_weapon != level.weaponNone && isdefined(level.primary_weapon_array[root_weapon]);
}

/*
	Name: is_side_arm
	Namespace: weapons
	Checksum: 0xB598AAC4
	Offset: 0x198
	Size: 0x45
	Parameters: 1
	Flags: None
*/
function is_side_arm(weapon)
{
	root_weapon = weapon.rootweapon;
	return root_weapon != level.weaponNone && isdefined(level.side_arm_array[root_weapon]);
}

/*
	Name: is_inventory
	Namespace: weapons
	Checksum: 0xB2504E18
	Offset: 0x1E8
	Size: 0x45
	Parameters: 1
	Flags: None
*/
function is_inventory(weapon)
{
	root_weapon = weapon.rootweapon;
	return root_weapon != level.weaponNone && isdefined(level.inventory_array[root_weapon]);
}

/*
	Name: is_grenade
	Namespace: weapons
	Checksum: 0xB59BADA3
	Offset: 0x238
	Size: 0x45
	Parameters: 1
	Flags: None
*/
function is_grenade(weapon)
{
	root_weapon = weapon.rootweapon;
	return root_weapon != level.weaponNone && isdefined(level.grenade_array[root_weapon]);
}

/*
	Name: force_stowed_weapon_update
	Namespace: weapons
	Checksum: 0xC449641B
	Offset: 0x288
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function force_stowed_weapon_update()
{
	detach_all_weapons();
	stow_on_back();
	stow_on_hip();
}

/*
	Name: detach_carry_object_model
	Namespace: weapons
	Checksum: 0xA387F0BE
	Offset: 0x2C8
	Size: 0x6D
	Parameters: 0
	Flags: None
*/
function detach_carry_object_model()
{
	if(isdefined(self.carryObject) && isdefined(self.carryObject gameobjects::get_visible_carrier_model()))
	{
		if(isdefined(self.tag_stowed_back))
		{
			self Detach(self.tag_stowed_back, "tag_stowed_back");
			self.tag_stowed_back = undefined;
		}
	}
}

/*
	Name: detach_all_weapons
	Namespace: weapons
	Checksum: 0x84C9E58E
	Offset: 0x340
	Size: 0x135
	Parameters: 0
	Flags: None
*/
function detach_all_weapons()
{
	if(isdefined(self.tag_stowed_back))
	{
		clear_weapon = 1;
		if(isdefined(self.carryObject))
		{
			carrierModel = self.carryObject gameobjects::get_visible_carrier_model();
			if(isdefined(carrierModel) && carrierModel == self.tag_stowed_back)
			{
				self Detach(self.tag_stowed_back, "tag_stowed_back");
				clear_weapon = 0;
			}
		}
		if(clear_weapon)
		{
			self ClearStowedWeapon();
		}
		self.tag_stowed_back = undefined;
	}
	else
	{
		self ClearStowedWeapon();
	}
	if(isdefined(self.tag_stowed_hip))
	{
		detach_model = self.tag_stowed_hip.worldmodel;
		self Detach(detach_model, "tag_stowed_hip_rear");
		self.tag_stowed_hip = undefined;
	}
}

/*
	Name: stow_on_back
	Namespace: weapons
	Checksum: 0xD8C6006E
	Offset: 0x480
	Size: 0x1D3
	Parameters: 1
	Flags: None
*/
function stow_on_back(current)
{
	currentWeapon = self GetCurrentWeapon();
	currentAltWeapon = currentWeapon.altweapon;
	self.tag_stowed_back = undefined;
	weaponOptions = 0;
	index_weapon = level.weaponNone;
	if(isdefined(self.carryObject) && isdefined(self.carryObject gameobjects::get_visible_carrier_model()))
	{
		self.tag_stowed_back = self.carryObject gameobjects::get_visible_carrier_model();
		self Attach(self.tag_stowed_back, "tag_stowed_back", 1);
		return;
		break;
	}
	if(currentWeapon != level.weaponNone)
	{
		for(idx = 0; idx < self.weapon_array_primary.size; idx++)
		{
			temp_index_weapon = self.weapon_array_primary[idx];
			/#
				Assert(isdefined(temp_index_weapon), "Dev Block strings are not supported");
			#/
			if(temp_index_weapon == currentWeapon)
			{
				continue;
			}
			if(temp_index_weapon == currentAltWeapon)
			{
				continue;
			}
			if(temp_index_weapon.nonStowedWeapon)
			{
				continue;
			}
			index_weapon = temp_index_weapon;
		}
	}
	self SetStowedWeapon(index_weapon);
}

/*
	Name: stow_on_hip
	Namespace: weapons
	Checksum: 0x255225CE
	Offset: 0x660
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function stow_on_hip()
{
	currentWeapon = self GetCurrentWeapon();
	self.tag_stowed_hip = undefined;
	for(idx = 0; idx < self.weapon_array_inventory.size; idx++)
	{
		if(self.weapon_array_inventory[idx] == currentWeapon)
		{
			continue;
		}
		if(!self GetWeaponAmmoStock(self.weapon_array_inventory[idx]))
		{
			continue;
		}
		self.tag_stowed_hip = self.weapon_array_inventory[idx];
	}
	if(!isdefined(self.tag_stowed_hip))
	{
		return;
	}
	self Attach(self.tag_stowed_hip.worldmodel, "tag_stowed_hip_rear", 1);
}

/*
	Name: weaponDamageTracePassed
	Namespace: weapons
	Checksum: 0xC0D88EB3
	Offset: 0x768
	Size: 0x61
	Parameters: 4
	Flags: None
*/
function weaponDamageTracePassed(from, to, startRadius, Ignore)
{
	trace = weaponDamageTrace(from, to, startRadius, Ignore);
	return trace["fraction"] == 1;
}

/*
	Name: weaponDamageTrace
	Namespace: weapons
	Checksum: 0x5E48222D
	Offset: 0x7D8
	Size: 0x1DF
	Parameters: 4
	Flags: None
*/
function weaponDamageTrace(from, to, startRadius, Ignore)
{
	midpos = undefined;
	diff = to - from;
	if(LengthSquared(diff) < startRadius * startRadius)
	{
		midpos = to;
	}
	dir = VectorNormalize(diff);
	midpos = from + (dir[0] * startRadius, dir[1] * startRadius, dir[2] * startRadius);
	trace = bullettrace(midpos, to, 0, Ignore);
	if(GetDvarInt("scr_damage_debug") != 0)
	{
		if(trace["fraction"] == 1)
		{
			thread debugLine(midpos, to, (1, 1, 1));
		}
		else
		{
			thread debugLine(midpos, trace["position"], (1, 0.9, 0.8));
			thread debugLine(trace["position"], to, (1, 0.4, 0.3));
		}
	}
	return trace;
}

/*
	Name: has_lmg
	Namespace: weapons
	Checksum: 0x67A3FC62
	Offset: 0x9C0
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function has_lmg()
{
	weapon = self GetCurrentWeapon();
	return weapon.weapClass == "mg";
}

/*
	Name: has_launcher
	Namespace: weapons
	Checksum: 0x2A71F790
	Offset: 0xA08
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function has_launcher()
{
	weapon = self GetCurrentWeapon();
	return weapon.isRocketLauncher;
}

/*
	Name: has_hero_weapon
	Namespace: weapons
	Checksum: 0x5595CE02
	Offset: 0xA48
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function has_hero_weapon()
{
	weapon = self GetCurrentWeapon();
	return weapon.gadget_type == 14;
}

/*
	Name: has_lockon
	Namespace: weapons
	Checksum: 0xC42C8FB4
	Offset: 0xA90
	Size: 0x6D
	Parameters: 1
	Flags: None
*/
function has_lockon(target)
{
	player = self;
	clientNum = player GetEntityNumber();
	return isdefined(target.locked_on) && target.locked_on & 1 << clientNum;
}

