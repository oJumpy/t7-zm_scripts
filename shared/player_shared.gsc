#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace player;

/*
	Name: __init__sytem__
	Namespace: player
	Checksum: 0x662C3511
	Offset: 0x200
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("player", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: player
	Checksum: 0x770BA8EB
	Offset: 0x240
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_spawned(&on_player_spawned);
	clientfield::register("world", "gameplay_started", 4000, 1, "int");
}

/*
	Name: on_player_spawned
	Namespace: player
	Checksum: 0x36853D18
	Offset: 0x2A0
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	mapname = GetDvarString("mapname");
	if(mapname === "core_frontend")
	{
		return;
	}
	if(SessionModeIsZombiesGame() || SessionModeIsCampaignGame())
	{
		snappedOrigin = self get_snapped_spot_origin(self.origin);
		if(!self flagsys::get("shared_igc"))
		{
			self SetOrigin(snappedOrigin);
		}
	}
	isMultiplayer = !SessionModeIsZombiesGame() && !SessionModeIsCampaignGame();
	if(!isMultiplayer || (isdefined(level._enableLastValidPosition) && level._enableLastValidPosition))
	{
		self thread last_valid_position();
	}
}

/*
	Name: last_valid_position
	Namespace: player
	Checksum: 0xE399B5E8
	Offset: 0x3D8
	Size: 0x22B
	Parameters: 0
	Flags: None
*/
function last_valid_position()
{
	self endon("disconnect");
	self notify("stop_last_valid_position");
	self endon("stop_last_valid_position");
	while(!isdefined(self.last_valid_position))
	{
		self.last_valid_position = GetClosestPointOnNavMesh(self.origin, 2048, 0);
		wait(0.1);
	}
	while(1)
	{
		if(Distance2DSquared(self.origin, self.last_valid_position) < 15 * 15 && self.origin[2] - self.last_valid_position[2] * self.origin[2] - self.last_valid_position[2] < 16 * 16)
		{
			wait(0.1);
			break;
		}
		if(isdefined(level.last_valid_position_override) && self [[level.last_valid_position_override]]())
		{
			wait(0.1);
			break;
		}
		else if(IsPointOnNavMesh(self.origin, self))
		{
			self.last_valid_position = self.origin;
		}
		else if(!IsPointOnNavMesh(self.origin, self) && IsPointOnNavMesh(self.last_valid_position, self) && Distance2DSquared(self.origin, self.last_valid_position) < 32 * 32)
		{
			wait(0.1);
			break;
		}
		else
		{
			position = GetClosestPointOnNavMesh(self.origin, 100, 15);
			if(isdefined(position))
			{
				self.last_valid_position = position;
			}
		}
		wait(0.1);
	}
}

/*
	Name: take_weapons
	Namespace: player
	Checksum: 0xBA0B2581
	Offset: 0x610
	Size: 0x211
	Parameters: 0
	Flags: None
*/
function take_weapons()
{
	if(!(isdefined(self.gun_removed) && self.gun_removed))
	{
		self.gun_removed = 1;
		self._weapons = [];
		if(!isdefined(self._current_weapon))
		{
			self._current_weapon = level.weaponNone;
		}
		w_current = self GetCurrentWeapon();
		if(w_current != level.weaponNone)
		{
			self._current_weapon = w_current;
		}
		a_weapon_list = self GetWeaponsList();
		if(self._current_weapon == level.weaponNone)
		{
			if(isdefined(a_weapon_list[0]))
			{
				self._current_weapon = a_weapon_list[0];
			}
		}
		foreach(weapon in a_weapon_list)
		{
			if(isdefined(weapon.dniweapon) && weapon.dniweapon)
			{
				continue;
			}
			if(!isdefined(self._weapons))
			{
				self._weapons = [];
			}
			else if(!IsArray(self._weapons))
			{
				self._weapons = Array(self._weapons);
			}
			self._weapons[self._weapons.size] = get_weapondata(weapon);
			self TakeWeapon(weapon);
		}
	}
}

/*
	Name: generate_weapon_data
	Namespace: player
	Checksum: 0xE3A5CC14
	Offset: 0x830
	Size: 0x233
	Parameters: 0
	Flags: None
*/
function generate_weapon_data()
{
	self._generated_weapons = [];
	if(!isdefined(self._generated_current_weapon))
	{
		self._generated_current_weapon = level.weaponNone;
	}
	if(isdefined(self.gun_removed) && self.gun_removed && isdefined(self._weapons))
	{
		self._generated_weapons = ArrayCopy(self._weapons);
		self._generated_current_weapon = self._current_weapon;
		break;
	}
	w_current = self GetCurrentWeapon();
	if(w_current != level.weaponNone)
	{
		self._generated_current_weapon = w_current;
	}
	a_weapon_list = self GetWeaponsList();
	if(self._generated_current_weapon == level.weaponNone)
	{
		if(isdefined(a_weapon_list[0]))
		{
			self._generated_current_weapon = a_weapon_list[0];
		}
	}
	foreach(weapon in a_weapon_list)
	{
		if(isdefined(weapon.dniweapon) && weapon.dniweapon)
		{
			continue;
		}
		if(!isdefined(self._generated_weapons))
		{
			self._generated_weapons = [];
		}
		else if(!IsArray(self._generated_weapons))
		{
			self._generated_weapons = Array(self._generated_weapons);
		}
		self._generated_weapons[self._generated_weapons.size] = get_weapondata(weapon);
	}
}

/*
	Name: give_back_weapons
	Namespace: player
	Checksum: 0x45CFC367
	Offset: 0xA70
	Size: 0x175
	Parameters: 1
	Flags: None
*/
function give_back_weapons(b_immediate)
{
	if(!isdefined(b_immediate))
	{
		b_immediate = 0;
	}
	if(isdefined(self._weapons))
	{
		foreach(weapondata in self._weapons)
		{
			weapondata_give(weapondata);
		}
		if(isdefined(self._current_weapon) && self._current_weapon != level.weaponNone)
		{
			if(b_immediate)
			{
				self SwitchToWeaponImmediate(self._current_weapon);
			}
			else
			{
				self SwitchToWeapon(self._current_weapon);
			}
		}
		else if(isdefined(self.primaryLoadoutWeapon) && self HasWeapon(self.primaryLoadoutWeapon))
		{
			switch_to_primary_weapon(b_immediate);
		}
	}
	self._weapons = undefined;
	self.gun_removed = undefined;
}

/*
	Name: get_weapondata
	Namespace: player
	Checksum: 0xD3F45951
	Offset: 0xBF0
	Size: 0x309
	Parameters: 1
	Flags: None
*/
function get_weapondata(weapon)
{
	weapondata = [];
	if(!isdefined(weapon))
	{
		weapon = self GetCurrentWeapon();
	}
	weapondata["weapon"] = weapon.name;
	if(weapon != level.weaponNone)
	{
		weapondata["clip"] = self GetWeaponAmmoClip(weapon);
		weapondata["stock"] = self GetWeaponAmmoStock(weapon);
		weapondata["fuel"] = self GetWeaponAmmoFuel(weapon);
		weapondata["heat"] = self IsWeaponOverheating(1, weapon);
		weapondata["overheat"] = self IsWeaponOverheating(0, weapon);
		weapondata["renderOptions"] = self GetWeaponOptions(weapon);
		weapondata["acvi"] = self GetPlayerAttachmentCosmeticVariantIndexes(weapon);
		if(weapon.isRiotShield)
		{
			weapondata["health"] = self.weaponHealth;
		}
	}
	else
	{
		weapondata["clip"] = 0;
		weapondata["stock"] = 0;
		weapondata["fuel"] = 0;
		weapondata["heat"] = 0;
		weapondata["overheat"] = 0;
	}
	if(weapon.dualWieldWeapon != level.weaponNone)
	{
		weapondata["lh_clip"] = self GetWeaponAmmoClip(weapon.dualWieldWeapon);
	}
	else
	{
		weapondata["lh_clip"] = 0;
	}
	if(weapon.altweapon != level.weaponNone)
	{
		weapondata["alt_clip"] = self GetWeaponAmmoClip(weapon.altweapon);
		weapondata["alt_stock"] = self GetWeaponAmmoStock(weapon.altweapon);
	}
	else
	{
		weapondata["alt_clip"] = 0;
		weapondata["alt_stock"] = 0;
	}
	return weapondata;
}

/*
	Name: weapondata_give
	Namespace: player
	Checksum: 0x644277D1
	Offset: 0xF08
	Size: 0x263
	Parameters: 1
	Flags: None
*/
function weapondata_give(weapondata)
{
	weapon = util::get_weapon_by_name(weapondata["weapon"]);
	self GiveWeapon(weapon, weapondata["renderOptions"], weapondata["acvi"]);
	if(weapon != level.weaponNone)
	{
		self SetWeaponAmmoClip(weapon, weapondata["clip"]);
		self SetWeaponAmmoStock(weapon, weapondata["stock"]);
		if(isdefined(weapondata["fuel"]))
		{
			self SetWeaponAmmoFuel(weapon, weapondata["fuel"]);
		}
		if(isdefined(weapondata["heat"]) && isdefined(weapondata["overheat"]))
		{
			self SetWeaponOverheating(weapondata["overheat"], weapondata["heat"], weapon);
		}
		if(weapon.isRiotShield && isdefined(weapondata["health"]))
		{
			self.weaponHealth = weapondata["health"];
		}
	}
	if(weapon.dualWieldWeapon != level.weaponNone)
	{
		self SetWeaponAmmoClip(weapon.dualWieldWeapon, weapondata["lh_clip"]);
	}
	if(weapon.altweapon != level.weaponNone)
	{
		self SetWeaponAmmoClip(weapon.altweapon, weapondata["alt_clip"]);
		self SetWeaponAmmoStock(weapon.altweapon, weapondata["alt_stock"]);
	}
}

/*
	Name: switch_to_primary_weapon
	Namespace: player
	Checksum: 0xD1E657B6
	Offset: 0x1178
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function switch_to_primary_weapon(b_immediate)
{
	if(!isdefined(b_immediate))
	{
		b_immediate = 0;
	}
	if(is_valid_weapon(self.primaryLoadoutWeapon))
	{
		if(b_immediate)
		{
			self SwitchToWeaponImmediate(self.primaryLoadoutWeapon);
		}
		else
		{
			self SwitchToWeapon(self.primaryLoadoutWeapon);
		}
	}
}

/*
	Name: fill_current_clip
	Namespace: player
	Checksum: 0x27CBE6A9
	Offset: 0x1200
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function fill_current_clip()
{
	w_current = self GetCurrentWeapon();
	if(w_current.isHeroWeapon)
	{
		w_current = self.primaryLoadoutWeapon;
	}
	if(isdefined(w_current) && self HasWeapon(w_current))
	{
		self SetWeaponAmmoClip(w_current, w_current.clipSize);
	}
}

/*
	Name: is_valid_weapon
	Namespace: player
	Checksum: 0xCAD2BE8B
	Offset: 0x12A0
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function is_valid_weapon(weaponObject)
{
	return isdefined(weaponObject) && weaponObject != level.weaponNone;
}

/*
	Name: is_spawn_protected
	Namespace: player
	Checksum: 0x52846471
	Offset: 0x12D0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function is_spawn_protected()
{
	if(isdefined(self.spawntime))
	{
	}
	else
	{
	}
	return self.spawntime - 0 <= level.spawnProtectionTimeMS;
}

/*
	Name: simple_respawn
	Namespace: player
	Checksum: 0x15A9F39B
	Offset: 0x1308
	Size: 0x17
	Parameters: 0
	Flags: None
*/
function simple_respawn()
{
	self [[level.onSpawnPlayer]](0);
}

/*
	Name: get_snapped_spot_origin
	Namespace: player
	Checksum: 0x940B8FC8
	Offset: 0x1328
	Size: 0x141
	Parameters: 1
	Flags: None
*/
function get_snapped_spot_origin(spot_position)
{
	snap_max_height = 100;
	SIZE = 15;
	height = SIZE * 2;
	mins = (-1 * SIZE, -1 * SIZE, 0);
	maxs = (SIZE, SIZE, height);
	spot_position = (spot_position[0], spot_position[1], spot_position[2] + 5);
	new_spot_position = (spot_position[0], spot_position[1], spot_position[2] - snap_max_height);
	trace = PhysicsTrace(spot_position, new_spot_position, mins, maxs, self);
	if(trace["fraction"] < 1)
	{
		return trace["position"];
	}
	return spot_position;
}

/*
	Name: allow_stance_change
	Namespace: player
	Checksum: 0x41B17CBE
	Offset: 0x1478
	Size: 0x19D
	Parameters: 1
	Flags: None
*/
function allow_stance_change(b_allow)
{
	if(!isdefined(b_allow))
	{
		b_allow = 1;
	}
	if(b_allow)
	{
		self AllowProne(1);
		self AllowCrouch(1);
		self AllowStand(1);
		break;
	}
	str_stance = self GetStance();
	switch(str_stance)
	{
		case "prone":
		{
			self AllowProne(1);
			self AllowCrouch(0);
			self AllowStand(0);
			break;
		}
		case "crouch":
		{
			self AllowProne(0);
			self AllowCrouch(1);
			self AllowStand(0);
			break;
		}
		case "stand":
		{
			self AllowProne(0);
			self AllowCrouch(0);
			self AllowStand(1);
			break;
		}
	}
}

