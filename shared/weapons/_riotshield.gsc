#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace riotshield;

/*
	Name: init_shared
	Namespace: riotshield
	Checksum: 0xABC8FB53
	Offset: 0x540
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	if(!isdefined(level.weaponRiotshield))
	{
		level.weaponRiotshield = GetWeapon("riotshield");
	}
	level.deployedShieldModel = "t6_wpn_shield_carry_world";
	level.stowedShieldModel = "t6_wpn_shield_stow_world";
	level.carriedShieldModel = "t6_wpn_shield_carry_world";
	level.detectShieldModel = "t6_wpn_shield_carry_world_detect";
	level.riotshieldDestroyAnim = %o_riot_stand_destroyed;
	level.riotshieldDeployAnim = %o_riot_stand_deploy;
	level.riotshieldShotAnimFront = %o_riot_stand_shot;
	level.riotshieldShotAnimBack = %o_riot_stand_shot_back;
	level.riotshieldMeleeAnimFront = %o_riot_stand_melee_front;
	level.riotshieldMeleeAnimBack = %o_riot_stand_melee_back;
	level.riotshield_placement_zoffset = 26;
	thread register();
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: register
	Namespace: riotshield
	Checksum: 0x77681D8F
	Offset: 0x690
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function register()
{
	clientfield::register("scriptmover", "riotshield_state", 1, 2, "int");
}

/*
	Name: watchPregameClassChange
	Namespace: riotshield
	Checksum: 0xA1A2F67B
	Offset: 0x6D0
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function watchPregameClassChange()
{
	self endon("death");
	self endon("disconnect");
	self endon("track_riot_shield");
	self waittill("changed_class");
	if(level.inGracePeriod && !self.hasDoneCombat)
	{
		self ClearStowedWeapon();
		self RefreshShieldAttachment();
		self thread trackRiotShield();
	}
}

/*
	Name: watchRiotshieldPickup
	Namespace: riotshield
	Checksum: 0x8B435AF6
	Offset: 0x770
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function watchRiotshieldPickup()
{
	self endon("death");
	self endon("disconnect");
	self endon("track_riot_shield");
	self notify("watch_riotshield_pickup");
	self endon("watch_riotshield_pickup");
	self waittill("pickup_riotshield");
	self endon("weapon_change");
	/#
		println("Dev Block strings are not supported");
	#/
	wait(0.5);
	/#
		println("Dev Block strings are not supported");
	#/
	currentWeapon = self GetCurrentWeapon();
	self.hasRiotShield = self hasRiotShield();
	self.hasRiotShieldEquipped = currentWeapon.isRiotShield;
	self RefreshShieldAttachment();
}

/*
	Name: trackRiotShield
	Namespace: riotshield
	Checksum: 0x49EBDAF
	Offset: 0x888
	Size: 0x257
	Parameters: 0
	Flags: None
*/
function trackRiotShield()
{
	self endon("death");
	self endon("disconnect");
	self notify("track_riot_shield");
	self endon("track_riot_shield");
	self thread watchPregameClassChange();
	self waittill("weapon_change", newWeapon);
	self RefreshShieldAttachment();
	currentWeapon = self GetCurrentWeapon();
	self.hasRiotShield = self hasRiotShield();
	self.hasRiotShieldEquipped = currentWeapon.isRiotShield;
	self.lastNonShieldWeapon = level.weaponNone;
	while(1)
	{
		self thread watchRiotshieldPickup();
		currentWeapon = self GetCurrentWeapon();
		currentWeapon = self GetCurrentWeapon();
		self.hasRiotShield = self hasRiotShield();
		self.hasRiotShieldEquipped = currentWeapon.isRiotShield;
		refresh_attach = 0;
		self waittill("weapon_change", newWeapon);
		if(newWeapon.isRiotShield)
		{
			refresh_attach = 1;
			if(isdefined(self.riotshieldEntity))
			{
				self notify("destroy_riotshield");
			}
			if(self.hasRiotShield)
			{
				if(isdefined(self.riotshieldTakeWeapon))
				{
					self TakeWeapon(self.riotshieldTakeWeapon);
					self.riotshieldTakeWeapon = undefined;
				}
			}
			if(isValidNonShieldWeapon(currentWeapon))
			{
				self.lastNonShieldWeapon = currentWeapon;
			}
		}
		if(self.hasRiotShield || refresh_attach == 1)
		{
			self RefreshShieldAttachment();
		}
	}
}

/*
	Name: isValidNonShieldWeapon
	Namespace: riotshield
	Checksum: 0xAAAA4193
	Offset: 0xAE8
	Size: 0x81
	Parameters: 1
	Flags: None
*/
function isValidNonShieldWeapon(weapon)
{
	if(killstreaks::is_killstreak_weapon(weapon))
	{
		return 0;
	}
	if(weapon.isCarriedKillstreak)
	{
		return 0;
	}
	if(weapon.isGameplayWeapon)
	{
		return 0;
	}
	if(weapon == level.weaponNone)
	{
		return 0;
	}
	if(weapon.isEquipment)
	{
		return 0;
	}
	return 1;
}

/*
	Name: startRiotshieldDeploy
	Namespace: riotshield
	Checksum: 0xD9BBF2C0
	Offset: 0xB78
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function startRiotshieldDeploy()
{
	self notify("start_riotshield_deploy");
	self thread watchRiotshieldDeploy();
}

/*
	Name: resetReconModelVisibility
	Namespace: riotshield
	Checksum: 0x814FA445
	Offset: 0xBA8
	Size: 0x16D
	Parameters: 1
	Flags: None
*/
function resetReconModelVisibility(owner)
{
	if(!isdefined(self))
	{
		return;
	}
	self SetInvisibleToAll();
	self SetForceNoCull();
	if(!isdefined(owner))
	{
		return;
	}
	for(i = 0; i < level.players.size; i++)
	{
		if(level.players[i] hasPerk("specialty_showenemyequipment"))
		{
			if(level.players[i].team == "spectator")
			{
				continue;
			}
			isEnemy = 1;
			if(level.teambased)
			{
				if(level.players[i].team == owner.team)
				{
					isEnemy = 0;
				}
			}
			else if(level.players[i] == owner)
			{
				isEnemy = 0;
			}
			if(isEnemy)
			{
				self SetVisibleToPlayer(level.players[i]);
			}
		}
	}
}

/*
	Name: resetReconModelOnEvent
	Namespace: riotshield
	Checksum: 0x267C6CBB
	Offset: 0xD20
	Size: 0x67
	Parameters: 2
	Flags: None
*/
function resetReconModelOnEvent(eventName, owner)
{
	self endon("death");
	for(;;)
	{
		level waittill(eventName, newOwner);
		if(isdefined(newOwner))
		{
			owner = newOwner;
		}
		self resetReconModelVisibility(owner);
	}
}

/*
	Name: attachReconModel
	Namespace: riotshield
	Checksum: 0x51DAAAF9
	Offset: 0xD90
	Size: 0x11F
	Parameters: 2
	Flags: None
*/
function attachReconModel(modelName, owner)
{
	if(!isdefined(self))
	{
		return;
	}
	reconModel = spawn("script_model", self.origin);
	reconModel.angles = self.angles;
	reconModel SetModel(modelName);
	reconModel.model_name = modelName;
	reconModel LinkTo(self);
	reconModel setContents(0);
	reconModel resetReconModelVisibility(owner);
	reconModel thread resetReconModelOnEvent("joined_team", owner);
	reconModel thread resetReconModelOnEvent("player_spawned", owner);
	self.reconModel = reconModel;
}

/*
	Name: spawnRiotshieldCover
	Namespace: riotshield
	Checksum: 0x19B6FE81
	Offset: 0xEB8
	Size: 0x14F
	Parameters: 2
	Flags: None
*/
function spawnRiotshieldCover(origin, angles)
{
	shield_ent = spawn("script_model", origin, 1);
	shield_ent.targetname = "riotshield_mp";
	shield_ent.angles = angles;
	shield_ent SetModel(level.deployedShieldModel);
	shield_ent SetOwner(self);
	shield_ent.owner = self;
	shield_ent.team = self.team;
	shield_ent SetTeam(self.team);
	shield_ent attachReconModel(level.detectShieldModel, self);
	shield_ent useanimtree(-1);
	shield_ent SetScriptMoverFlag(0);
	shield_ent disconnectpaths();
	return shield_ent;
}

/*
	Name: watchRiotshieldDeploy
	Namespace: riotshield
	Checksum: 0x2C70E987
	Offset: 0x1010
	Size: 0x423
	Parameters: 0
	Flags: None
*/
function watchRiotshieldDeploy()
{
	self endon("death");
	self endon("disconnect");
	self endon("start_riotshield_deploy");
	self waittill("deploy_riotshield", deploy_attempt, weapon);
	self SetPlacementHint(1);
	placement_hint = 0;
	if(deploy_attempt)
	{
		placement = self CanPlaceRiotshield("deploy_riotshield");
		if(placement["result"])
		{
			self.hasDoneCombat = 1;
			zoffset = level.riotshield_placement_zoffset;
			shield_ent = self spawnRiotshieldCover(placement["origin"] + (0, 0, zoffset), placement["angles"]);
			item_ent = DeployRiotShield(self, shield_ent);
			Primaries = self GetWeaponsListPrimaries();
			/#
				/#
					Assert(isdefined(item_ent));
				#/
				/#
					Assert(!isdefined(self.riotshieldRetrieveTrigger));
				#/
				/#
					Assert(!isdefined(self.riotshieldEntity));
				#/
				if(level.gametype != "Dev Block strings are not supported")
				{
					/#
						Assert(Primaries.size > 0);
					#/
				}
			#/
			shield_ent clientfield::set("riotshield_state", 1);
			shield_ent.reconModel clientfield::set("riotshield_state", 1);
			if(level.gametype != "shrp")
			{
				if(self.lastNonShieldWeapon != level.weaponNone && self HasWeapon(self.lastNonShieldWeapon))
				{
					self SwitchToWeapon(self.lastNonShieldWeapon);
				}
				else
				{
					self SwitchToWeapon(Primaries[0]);
				}
			}
			if(!self HasWeapon(level.weaponBaseMeleeHeld))
			{
				self GiveWeapon(level.weaponBaseMeleeHeld);
				self.riotshieldTakeWeapon = level.weaponBaseMeleeHeld;
			}
			self.riotshieldRetrieveTrigger = item_ent;
			self.riotshieldEntity = shield_ent;
			self thread watchDeployedRiotshieldEnts();
			self thread deleteShieldOnTriggerDeath(self.riotshieldRetrieveTrigger);
			self thread deleteShieldOnPlayerDeathOrDisconnect(shield_ent);
			self.riotshieldEntity thread watchDeployedRiotshieldDamage();
			level notify("riotshield_planted", self);
		}
		else
		{
			placement_hint = 1;
			clip_max_ammo = weapon.clipSize;
			self SetWeaponAmmoClip(weapon, clip_max_ammo);
		}
	}
	else
	{
		placement_hint = 1;
	}
	if(placement_hint)
	{
		self SetRiotshieldFailHint();
	}
}

/*
	Name: riotshieldDistanceTest
	Namespace: riotshield
	Checksum: 0x622D8140
	Offset: 0x1440
	Size: 0x11D
	Parameters: 1
	Flags: None
*/
function riotshieldDistanceTest(origin)
{
	/#
		/#
			Assert(isdefined(origin));
		#/
	#/
	min_dist_squared = GetDvarFloat("riotshield_deploy_limit_radius");
	min_dist_squared = min_dist_squared * min_dist_squared;
	for(i = 0; i < level.players.size; i++)
	{
		if(isdefined(level.players[i].riotshieldEntity))
		{
			dist_squared = DistanceSquared(level.players[i].riotshieldEntity.origin, origin);
			if(min_dist_squared > dist_squared)
			{
				/#
					println("Dev Block strings are not supported");
				#/
				return 0;
			}
		}
	}
	return 1;
}

/*
	Name: watchDeployedRiotshieldEnts
	Namespace: riotshield
	Checksum: 0x25742695
	Offset: 0x1568
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function watchDeployedRiotshieldEnts()
{
	/#
		/#
			Assert(isdefined(self.riotshieldRetrieveTrigger));
		#/
		/#
			Assert(isdefined(self.riotshieldEntity));
		#/
	#/
	self waittill("destroy_riotshield");
	if(isdefined(self.riotshieldRetrieveTrigger))
	{
		self.riotshieldRetrieveTrigger delete();
	}
	if(isdefined(self.riotshieldEntity))
	{
		if(isdefined(self.riotshieldEntity.reconModel))
		{
			self.riotshieldEntity.reconModel delete();
		}
		self.riotshieldEntity connectpaths();
		self.riotshieldEntity delete();
	}
}

/*
	Name: watchDeployedRiotshieldDamage
	Namespace: riotshield
	Checksum: 0x37061F2A
	Offset: 0x1660
	Size: 0x33B
	Parameters: 0
	Flags: None
*/
function watchDeployedRiotshieldDamage()
{
	self endon("death");
	damageMax = GetDvarInt("riotshield_deployed_health");
	self.damageTaken = 0;
	while(1)
	{
		self.maxhealth = 100000;
		self.health = self.maxhealth;
		self waittill("damage", damage, attacker, direction, point, type, tagName, modelName, partName, weapon, iDFlags);
		if(!isdefined(attacker))
		{
			continue;
		}
		/#
			/#
				Assert(isdefined(self.owner) && isdefined(self.owner.team));
			#/
		#/
		if(isPlayer(attacker))
		{
			if(level.teambased && attacker.team == self.owner.team && attacker != self.owner)
			{
				continue;
			}
		}
		if(type == "MOD_MELEE" || type == "MOD_MELEE_ASSASSINATE")
		{
			damage = damage * GetDvarFloat("riotshield_melee_damage_scale");
		}
		else if(type == "MOD_PISTOL_BULLET" || type == "MOD_RIFLE_BULLET")
		{
			damage = damage * GetDvarFloat("riotshield_bullet_damage_scale");
		}
		else if(type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" || type == "MOD_EXPLOSIVE" || type == "MOD_EXPLOSIVE_SPLASH" || type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH")
		{
			damage = damage * GetDvarFloat("riotshield_explosive_damage_scale");
		}
		else if(type == "MOD_IMPACT")
		{
			damage = damage * GetDvarFloat("riotshield_projectile_damage_scale");
		}
		else if(type == "MOD_CRUSH")
		{
			damage = damageMax;
		}
		self.damageTaken = self.damageTaken + damage;
		if(self.damageTaken >= damageMax)
		{
			self thread damageThenDestroyRiotshield(attacker, weapon);
			break;
		}
	}
}

/*
	Name: damageThenDestroyRiotshield
	Namespace: riotshield
	Checksum: 0x22736A25
	Offset: 0x19A8
	Size: 0x16B
	Parameters: 2
	Flags: None
*/
function damageThenDestroyRiotshield(attacker, weapon)
{
	self notify("damageThenDestroyRiotshield");
	self endon("death");
	if(isdefined(self.owner.riotshieldRetrieveTrigger))
	{
		self.owner.riotshieldRetrieveTrigger delete();
	}
	if(isdefined(self.reconModel))
	{
		self.reconModel delete();
	}
	self connectpaths();
	self.owner.riotshieldEntity = undefined;
	self notsolid();
	self clientfield::set("riotshield_state", 2);
	if(isdefined(attacker) && attacker != self.owner && isPlayer(attacker))
	{
		scoreevents::processScoreEvent("destroyed_shield", attacker, self.owner, weapon);
	}
	wait(GetDvarFloat("riotshield_destroyed_cleanup_time"));
	self delete();
}

/*
	Name: deleteShieldOnTriggerDeath
	Namespace: riotshield
	Checksum: 0x2176B6CE
	Offset: 0x1B20
	Size: 0x41
	Parameters: 1
	Flags: None
*/
function deleteShieldOnTriggerDeath(shield_trigger)
{
	shield_trigger util::waittill_any("trigger", "death");
	self notify("destroy_riotshield");
}

/*
	Name: deleteShieldOnPlayerDeathOrDisconnect
	Namespace: riotshield
	Checksum: 0x8B35E804
	Offset: 0x1B70
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function deleteShieldOnPlayerDeathOrDisconnect(shield_ent)
{
	shield_ent endon("death");
	shield_ent endon("damageThenDestroyRiotshield");
	self util::waittill_any("death", "disconnect", "remove_planted_weapons");
	shield_ent thread damageThenDestroyRiotshield();
}

/*
	Name: watchRiotshieldStuckEntityDeath
	Namespace: riotshield
	Checksum: 0x7E4AB3EB
	Offset: 0x1BE8
	Size: 0x73
	Parameters: 2
	Flags: None
*/
function watchRiotshieldStuckEntityDeath(grenade, owner)
{
	grenade endon("death");
	self util::waittill_any("damageThenDestroyRiotshield", "death", "disconnect", "weapon_change", "deploy_riotshield");
	grenade detonate(owner);
}

/*
	Name: on_player_spawned
	Namespace: riotshield
	Checksum: 0xA762D4C4
	Offset: 0x1C68
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self thread watch_riot_shield_use();
	self thread begin_other_grenade_tracking();
}

/*
	Name: watch_riot_shield_use
	Namespace: riotshield
	Checksum: 0x17CF46A0
	Offset: 0x1CA8
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function watch_riot_shield_use()
{
	self endon("death");
	self endon("disconnect");
	self thread trackRiotShield();
	for(;;)
	{
		self waittill("raise_riotshield");
		self thread startRiotshieldDeploy();
	}
}

/*
	Name: begin_other_grenade_tracking
	Namespace: riotshield
	Checksum: 0x78B77817
	Offset: 0x1D00
	Size: 0xD1
	Parameters: 0
	Flags: None
*/
function begin_other_grenade_tracking()
{
	self endon("death");
	self endon("disconnect");
	self notify("riotshieldTrackingStart");
	self endon("riotshieldTrackingStart");
	for(;;)
	{
		self waittill("grenade_fire", grenade, weapon, cookTime);
		if(grenade util::isHacked())
		{
			break;
		}
		switch(weapon.name)
		{
			case "explosive_bolt":
			case "proximity_grenade":
			case "sticky_grenade":
			{
				grenade thread check_stuck_to_shield();
				break;
			}
		}
	}
}

/*
	Name: check_stuck_to_shield
	Namespace: riotshield
	Checksum: 0xC37A4A67
	Offset: 0x1DE0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function check_stuck_to_shield()
{
	self endon("death");
	self waittill("stuck_to_shield", other, owner);
	other watchRiotshieldStuckEntityDeath(self, owner);
}

