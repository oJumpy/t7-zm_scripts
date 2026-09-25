#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace ballistic_knife;

/*
	Name: init_shared
	Namespace: ballistic_knife
	Checksum: 0x79AD53C6
	Offset: 0x1C8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	callback::add_weapon_watcher(&createBallisticKnifeWatcher);
}

/*
	Name: onSpawn
	Namespace: ballistic_knife
	Checksum: 0xB6F9F2BC
	Offset: 0x1F8
	Size: 0x333
	Parameters: 2
	Flags: None
*/
function onSpawn(watcher, player)
{
	player endon("death");
	player endon("disconnect");
	level endon("game_ended");
	self waittill("stationary", endPos, normal, angles, attacker, prey, bone);
	isFriendly = 0;
	if(isdefined(endPos))
	{
		retrievable_model = spawn("script_model", endPos);
		retrievable_model SetModel("wpn_t7_loot_ballistic_knife_projectile");
		retrievable_model SetTeam(player.team);
		retrievable_model SetOwner(player);
		retrievable_model.owner = player;
		retrievable_model.angles = angles;
		retrievable_model.name = watcher.weapon;
		retrievable_model.targetname = "sticky_weapon";
		if(isdefined(prey))
		{
			if(level.teambased && player.team == prey.team)
			{
				isFriendly = 1;
			}
			if(!isFriendly)
			{
				if(isalive(prey))
				{
					retrievable_model dropToGround(retrievable_model.origin, 80);
				}
				else
				{
					retrievable_model LinkTo(prey, bone);
				}
			}
			else if(isFriendly)
			{
				retrievable_model PhysicsLaunch(normal, (RandomInt(10), RandomInt(10), RandomInt(10)));
				normal = (0, 0, 1);
			}
		}
		watcher.objectArray[watcher.objectArray.size] = retrievable_model;
		if(isFriendly)
		{
			retrievable_model waittill("stationary");
		}
		retrievable_model thread dropKnivesToGround();
		if(isFriendly)
		{
			player notify("ballistic_knife_stationary", retrievable_model, normal);
		}
		else
		{
			player notify("ballistic_knife_stationary", retrievable_model, normal, prey);
		}
	}
}

/*
	Name: watch_shutdown
	Namespace: ballistic_knife
	Checksum: 0xBED08E73
	Offset: 0x538
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function watch_shutdown()
{
	pickupTrigger = self.pickupTrigger;
	self waittill("death");
	if(isdefined(pickupTrigger))
	{
		pickupTrigger delete();
	}
}

/*
	Name: onSpawnRetrieveTrigger
	Namespace: ballistic_knife
	Checksum: 0x33386E08
	Offset: 0x588
	Size: 0x32B
	Parameters: 2
	Flags: None
*/
function onSpawnRetrieveTrigger(watcher, player)
{
	player endon("death");
	player endon("disconnect");
	level endon("game_ended");
	player waittill("ballistic_knife_stationary", retrievable_model, normal, prey);
	if(!isdefined(retrievable_model))
	{
		return;
	}
	vec_scale = 10;
	trigger_pos = [];
	if(isdefined(prey) && (isPlayer(prey) || isai(prey)))
	{
		trigger_pos[0] = prey.origin[0];
		trigger_pos[1] = prey.origin[1];
		trigger_pos[2] = prey.origin[2] + vec_scale;
	}
	else
	{
		trigger_pos[0] = retrievable_model.origin[0] + vec_scale * normal[0];
		trigger_pos[1] = retrievable_model.origin[1] + vec_scale * normal[1];
		trigger_pos[2] = retrievable_model.origin[2] + vec_scale * normal[2];
	}
	trigger_pos[2] = trigger_pos[2] - 50;
	retrievable_model clientfield::set("retrievable", 1);
	pickup_trigger = spawn("trigger_radius", (trigger_pos[0], trigger_pos[1], trigger_pos[2]), 0, 50, 100);
	pickup_trigger.owner = player;
	retrievable_model.pickupTrigger = pickup_trigger;
	pickup_trigger EnableLinkTo();
	if(isdefined(prey))
	{
		pickup_trigger LinkTo(prey);
	}
	else
	{
		pickup_trigger LinkTo(retrievable_model);
	}
	retrievable_model thread watch_use_trigger(pickup_trigger, retrievable_model, &pick_up, watcher.pickUpSoundPlayer, watcher.pickUpSound);
	retrievable_model thread watch_shutdown();
}

/*
	Name: watch_use_trigger
	Namespace: ballistic_knife
	Checksum: 0xA5C5FE6C
	Offset: 0x8C0
	Size: 0x2CD
	Parameters: 5
	Flags: None
*/
function watch_use_trigger(trigger, model, callback, playerSoundOnUse, npcSoundOnUse)
{
	self endon("death");
	self endon("delete");
	level endon("game_ended");
	max_ammo = level.weaponBallisticKnife.maxAmmo + 1;
	while(1)
	{
		trigger waittill("trigger", player);
		if(!isalive(player))
		{
			continue;
		}
		if(!player IsOnGround() && !SessionModeIsMultiplayerGame())
		{
			continue;
		}
		if(isdefined(trigger.triggerTeam) && player.team != trigger.triggerTeam)
		{
			continue;
		}
		if(isdefined(trigger.ClaimedBy) && player != trigger.ClaimedBy)
		{
			continue;
		}
		if(!player HasWeapon(level.weaponBallisticKnife, 1))
		{
			continue;
		}
		heldBallisticKnife = player GetWeaponForWeaponRoot(level.weaponBallisticKnife);
		if(!isdefined(heldBallisticKnife))
		{
			continue;
		}
		ammo_stock = player GetWeaponAmmoStock(heldBallisticKnife);
		ammo_clip = player GetWeaponAmmoClip(heldBallisticKnife);
		total_ammo = ammo_stock + ammo_clip;
		hasReloaded = 1;
		if(total_ammo > 0 && ammo_stock == total_ammo)
		{
			hasReloaded = 0;
		}
		if(total_ammo >= max_ammo || !hasReloaded)
		{
			continue;
		}
		if(isdefined(playerSoundOnUse))
		{
			player playlocalsound(playerSoundOnUse);
		}
		if(isdefined(npcSoundOnUse))
		{
			player playsound(npcSoundOnUse);
		}
		self thread [[callback]](player);
		break;
	}
}

/*
	Name: pick_up
	Namespace: ballistic_knife
	Checksum: 0xF774C980
	Offset: 0xB98
	Size: 0x18B
	Parameters: 1
	Flags: None
*/
function pick_up(player)
{
	self destroy_ent();
	current_weapon = player GetCurrentWeapon();
	player challenges::pickedUpBallisticKnife();
	if(current_weapon.rootweapon != level.weaponBallisticKnife)
	{
		heldBallisticKnife = player GetWeaponForWeaponRoot(level.weaponBallisticKnife);
		if(!isdefined(heldBallisticKnife))
		{
			return;
		}
		clip_ammo = player GetWeaponAmmoClip(heldBallisticKnife);
		if(!clip_ammo)
		{
			player SetWeaponAmmoClip(heldBallisticKnife, 1);
		}
		else
		{
			new_ammo_stock = player GetWeaponAmmoStock(heldBallisticKnife) + 1;
			player SetWeaponAmmoStock(heldBallisticKnife, new_ammo_stock);
		}
	}
	else
	{
		new_ammo_stock = player GetWeaponAmmoStock(current_weapon) + 1;
		player SetWeaponAmmoStock(current_weapon, new_ammo_stock);
	}
}

/*
	Name: destroy_ent
	Namespace: ballistic_knife
	Checksum: 0xA5EFF024
	Offset: 0xD30
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function destroy_ent()
{
	if(isdefined(self))
	{
		pickupTrigger = self.pickupTrigger;
		if(isdefined(pickupTrigger))
		{
			pickupTrigger delete();
		}
		self delete();
	}
}

/*
	Name: dropKnivesToGround
	Namespace: ballistic_knife
	Checksum: 0x748F31AA
	Offset: 0xD98
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function dropKnivesToGround()
{
	self endon("death");
	for(;;)
	{
		level waittill("drop_objects_to_ground", origin, radius);
		self dropToGround(origin, radius);
	}
}

/*
	Name: dropToGround
	Namespace: ballistic_knife
	Checksum: 0xF9503A0B
	Offset: 0xDF8
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function dropToGround(origin, radius)
{
	if(DistanceSquared(origin, self.origin) < radius * radius)
	{
		self PhysicsLaunch((0, 0, 1), VectorScale((1, 1, 1), 5));
		self thread updateRetrieveTrigger();
	}
}

/*
	Name: updateRetrieveTrigger
	Namespace: ballistic_knife
	Checksum: 0x4CDEFEB9
	Offset: 0xE80
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function updateRetrieveTrigger()
{
	self endon("death");
	self waittill("stationary");
	trigger = self.pickupTrigger;
	trigger.origin = (self.origin[0], self.origin[1], self.origin[2] + 10);
	trigger LinkTo(self);
}

/*
	Name: createBallisticKnifeWatcher
	Namespace: ballistic_knife
	Checksum: 0x34016E70
	Offset: 0xF10
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function createBallisticKnifeWatcher()
{
	watcher = self weaponobjects::createUseWeaponObjectWatcher("knife_ballistic", self.team);
	watcher.onSpawn = &onSpawn;
	watcher.onDetonateCallback = &weaponobjects::deleteEnt;
	watcher.onSpawnRetrieveTriggers = &onSpawnRetrieveTrigger;
	watcher.storeDifferentObject = 1;
}

