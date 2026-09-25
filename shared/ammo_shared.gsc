#using scripts\shared\ai\systems\shared;
#using scripts\shared\array_shared;
#using scripts\shared\throttle_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons\_weapons;

#namespace ammo;

/*
	Name: main
	Namespace: ammo
	Checksum: 0xBCA363B3
	Offset: 0x178
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	function_9b385ca5();
	level.ai_ammo_throttle = Throttle;
	Initialize(level.ai_ammo_throttle, 1);
}

/*
	Name: DropAIAmmo
	Namespace: ammo
	Checksum: 0x29CFCA2D
	Offset: 0x1C0
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function DropAIAmmo()
{
	self endon("death");
	if(!isdefined(self.ammoPouch))
	{
		return;
	}
	if(isdefined(self.disableAmmoDrop) && self.disableAmmoDrop)
	{
		return;
	}
	WaitInQueue(level.ai_ammo_throttle);
	droppedWeapon = shared::ThrowWeapon(self.ammoPouch, "tag_stowed_back", 1);
	if(isdefined(droppedWeapon))
	{
		droppedWeapon thread ammo_pouch_think();
		~droppedWeapon;
		droppedWeapon setContents(droppedWeapon setContents(0) & 32768 | 67108864 | 8388608 | 33554432);
	}
}

/*
	Name: ammo_pouch_think
	Namespace: ammo
	Checksum: 0xE5FB5F96
	Offset: 0x2C0
	Size: 0x5F5
	Parameters: 0
	Flags: None
*/
function ammo_pouch_think()
{
	self endon("death");
	self waittill("scavenger", player);
	primary_weapons = player GetWeaponsListPrimaries();
	offhand_weapons_and_alts = Array::exclude(player GetWeaponsList(1), primary_weapons);
	ArrayRemoveValue(offhand_weapons_and_alts, level.weaponBaseMelee);
	offhand_weapons_and_alts = Array::reverse(offhand_weapons_and_alts);
	player playsound("wpn_ammo_pickup");
	player playlocalsound("wpn_ammo_pickup");
	if(isdefined(level.b_disable_scavenger_icon) && level.b_disable_scavenger_icon)
	{
		player weapons::flash_scavenger_icon();
	}
	for(i = 0; i < offhand_weapons_and_alts.size; i++)
	{
		weapon = offhand_weapons_and_alts[i];
		maxAmmo = 0;
		b_is_primary_or_secondary_grenade = 0;
		if(weapon == player.grenadeTypePrimary && isdefined(player.grenadeTypePrimaryCount) && player.grenadeTypePrimaryCount > 0)
		{
			maxAmmo = player.grenadeTypePrimaryCount;
			b_is_primary_or_secondary_grenade = 1;
		}
		else if(weapon == player.grenadeTypeSecondary && isdefined(player.grenadeTypeSecondaryCount) && player.grenadeTypeSecondaryCount > 0)
		{
			maxAmmo = player.grenadeTypeSecondaryCount;
			b_is_primary_or_secondary_grenade = 1;
		}
		else if(weapon.inventoryType == "hero" && (isdefined(level.overrideAmmoDropHeroWeapon) && level.overrideAmmoDropHeroWeapon))
		{
			maxAmmo = weapon.maxAmmo;
		}
		if(b_is_primary_or_secondary_grenade && player function_76f34311("cybercom_copycat") != 2)
		{
			continue;
		}
		if(isdefined(level.customLoadoutScavenge))
		{
			maxAmmo = self [[level.customLoadoutScavenge]](weapon);
		}
		if(maxAmmo == 0)
		{
			continue;
		}
		if(weapon.rootweapon == level.weaponSatchelCharge)
		{
			if(player weaponobjects::anyObjectsInWorld(weapon.rootweapon))
			{
				continue;
			}
		}
		stock = player GetWeaponAmmoStock(weapon);
		if(weapon.inventoryType == "hero" && (isdefined(level.overrideAmmoDropHeroWeapon) && level.overrideAmmoDropHeroWeapon))
		{
			ammo = stock + weapon.clipSize;
			if(ammo > maxAmmo)
			{
				ammo = maxAmmo;
			}
			player SetWeaponAmmoStock(weapon, ammo);
			player.scavenged = 1;
			continue;
		}
		if(stock < maxAmmo)
		{
			ammo = stock + 1;
			if(ammo > maxAmmo)
			{
				ammo = maxAmmo;
			}
			else if(weapon == player.grenadeTypePrimary)
			{
				player notify("scavenged_primary_grenade");
			}
			player SetWeaponAmmoStock(weapon, ammo);
			player.scavenged = 1;
		}
	}
	for(i = 0; i < primary_weapons.size; i++)
	{
		weapon = primary_weapons[i];
		stock = player GetWeaponAmmoStock(weapon);
		start = player GetFractionStartAmmo(weapon);
		clip = weapon.clipSize;
		clip = clip * GetDvarFloat("scavenger_clip_multiplier", 1);
		clip = Int(clip);
		maxAmmo = weapon.maxAmmo;
		if(stock < maxAmmo - clip * 3)
		{
			ammo = stock + clip * 3;
			player SetWeaponAmmoStock(weapon, ammo);
			continue;
		}
		player SetWeaponAmmoStock(weapon, maxAmmo);
	}
}

