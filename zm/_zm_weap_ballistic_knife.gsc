#using scripts\codescripts\struct;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_stats;

#namespace _zm_weap_ballistic_knife;

/*
	Name: init
	Namespace: _zm_weap_ballistic_knife
	Checksum: 0x9D4D6AEB
	Offset: 0x198
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function init()
{
	if(!isdefined(level.ballistic_knife_autorecover))
	{
		level.ballistic_knife_autorecover = 1;
	}
}

/*
	Name: on_spawn
	Namespace: _zm_weap_ballistic_knife
	Checksum: 0x2CBFACF8
	Offset: 0x1C0
	Size: 0x353
	Parameters: 2
	Flags: None
*/
function on_spawn(watcher, player)
{
	player endon("death");
	player endon("disconnect");
	player endon("zmb_lost_knife");
	level endon("game_ended");
	self waittill("stationary", endPos, normal, angles, attacker, prey, bone);
	isFriendly = 0;
	if(isdefined(endPos))
	{
		retrievable_model = spawn("script_model", endPos);
		retrievable_model SetModel("t6_wpn_ballistic_knife_projectile");
		retrievable_model SetOwner(player);
		retrievable_model.owner = player;
		retrievable_model.angles = angles;
		retrievable_model.weapon = watcher.weapon;
		if(isdefined(prey))
		{
			if(isPlayer(prey) && player.team == prey.team)
			{
				isFriendly = 1;
			}
			else if(isai(prey) && player.team == prey.team)
			{
				isFriendly = 1;
			}
			if(!isFriendly)
			{
				retrievable_model LinkTo(prey, bone);
				retrievable_model thread force_drop_knives_to_ground_on_death(player, prey);
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
		retrievable_model thread drop_knives_to_ground(player);
		if(isFriendly)
		{
			player notify("ballistic_knife_stationary", retrievable_model, normal);
		}
		else
		{
			player notify("ballistic_knife_stationary", retrievable_model, normal, prey);
		}
		retrievable_model thread wait_to_show_glowing_model(prey);
	}
}

/*
	Name: wait_to_show_glowing_model
	Namespace: _zm_weap_ballistic_knife
	Checksum: 0xA37D9A67
	Offset: 0x520
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function wait_to_show_glowing_model(prey)
{
	level endon("game_ended");
	self endon("death");
	wait(2);
	self SetModel("t6_wpn_ballistic_knife_projectile");
}

/*
	Name: on_spawn_retrieve_trigger
	Namespace: _zm_weap_ballistic_knife
	Checksum: 0x449804A3
	Offset: 0x570
	Size: 0x453
	Parameters: 2
	Flags: None
*/
function on_spawn_retrieve_trigger(watcher, player)
{
	player endon("death");
	player endon("disconnect");
	player endon("zmb_lost_knife");
	level endon("game_ended");
	player waittill("ballistic_knife_stationary", retrievable_model, normal, prey);
	if(!isdefined(retrievable_model))
	{
		return;
	}
	trigger_pos = [];
	if(isdefined(prey) && (isPlayer(prey) || isai(prey)))
	{
		trigger_pos[0] = prey.origin[0];
		trigger_pos[1] = prey.origin[1];
		trigger_pos[2] = prey.origin[2] + 10;
	}
	else
	{
		trigger_pos[0] = retrievable_model.origin[0] + 10 * normal[0];
		trigger_pos[1] = retrievable_model.origin[1] + 10 * normal[1];
		trigger_pos[2] = retrievable_model.origin[2] + 10 * normal[2];
	}
	if(isdefined(level.ballistic_knife_autorecover) && level.ballistic_knife_autorecover)
	{
		trigger_pos[2] = trigger_pos[2] - 50;
		pickup_trigger = spawn("trigger_radius", (trigger_pos[0], trigger_pos[1], trigger_pos[2]), 0, 50, 100);
	}
	else
	{
		pickup_trigger = spawn("trigger_radius_use", (trigger_pos[0], trigger_pos[1], trigger_pos[2]));
		pickup_trigger setcursorhint("HINT_NOICON");
	}
	pickup_trigger.owner = player;
	retrievable_model.retrievableTrigger = pickup_trigger;
	hint_string = &"WEAPON_BALLISTIC_KNIFE_PICKUP";
	if(isdefined(hint_string))
	{
		pickup_trigger setHintString(hint_string);
	}
	else
	{
		pickup_trigger setHintString(&"GENERIC_PICKUP");
	}
	pickup_trigger SetTeamForTrigger(player.team);
	player ClientClaimTrigger(pickup_trigger);
	pickup_trigger EnableLinkTo();
	if(isdefined(prey))
	{
		pickup_trigger LinkTo(prey);
	}
	else
	{
		pickup_trigger LinkTo(retrievable_model);
	}
	if(isdefined(level.knife_planted))
	{
		[[level.knife_planted]](retrievable_model, pickup_trigger, prey);
	}
	retrievable_model thread watch_use_trigger(pickup_trigger, retrievable_model, &pick_up, watcher.weapon, watcher.pickUpSoundPlayer, watcher.pickUpSound);
	player thread watch_shutdown(pickup_trigger, retrievable_model);
}

/*
	Name: debug_print
	Namespace: _zm_weap_ballistic_knife
	Checksum: 0x14729F32
	Offset: 0x9D0
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function debug_print(endPos)
{
	/#
		self endon("death");
		while(1)
		{
			print3d(endPos, "Dev Block strings are not supported");
			wait(0.05);
		}
	#/
}

/*
	Name: watch_use_trigger
	Namespace: _zm_weap_ballistic_knife
	Checksum: 0x8396DDDF
	Offset: 0xA20
	Size: 0x34F
	Parameters: 6
	Flags: None
*/
function watch_use_trigger(trigger, model, callback, weapon, playerSoundOnUse, npcSoundOnUse)
{
	self endon("death");
	self endon("delete");
	level endon("game_ended");
	max_ammo = weapon.maxAmmo + 1;
	autorecover = isdefined(level.ballistic_knife_autorecover) && level.ballistic_knife_autorecover;
	while(1)
	{
		trigger waittill("trigger", player);
		if(!isalive(player))
		{
			continue;
		}
		if(!player IsOnGround() && (!isdefined(trigger.force_pickup) && trigger.force_pickup))
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
		ammo_stock = player GetWeaponAmmoStock(weapon);
		ammo_clip = player GetWeaponAmmoClip(weapon);
		current_weapon = player GetCurrentWeapon();
		total_ammo = ammo_stock + ammo_clip;
		hasReloaded = 1;
		if(total_ammo > 0 && ammo_stock == total_ammo && current_weapon == weapon)
		{
			hasReloaded = 0;
		}
		if(total_ammo >= max_ammo || !hasReloaded)
		{
			continue;
		}
		if(autorecover || (player useButtonPressed() && !player.throwingGrenade && !player meleeButtonPressed()) || (isdefined(trigger.force_pickup) && trigger.force_pickup))
		{
			if(isdefined(playerSoundOnUse))
			{
				player playlocalsound(playerSoundOnUse);
			}
			if(isdefined(npcSoundOnUse))
			{
				player playsound(npcSoundOnUse);
			}
			player thread [[callback]](weapon, model, trigger);
			break;
		}
	}
}

/*
	Name: pick_up
	Namespace: _zm_weap_ballistic_knife
	Checksum: 0x9D254968
	Offset: 0xD78
	Size: 0x1B3
	Parameters: 3
	Flags: None
*/
function pick_up(weapon, model, trigger)
{
	if(self HasWeapon(weapon))
	{
		current_weapon = self GetCurrentWeapon();
		if(current_weapon != weapon)
		{
			clip_ammo = self GetWeaponAmmoClip(weapon);
			if(!clip_ammo)
			{
				self SetWeaponAmmoClip(weapon, 1);
			}
			else
			{
				new_ammo_stock = self GetWeaponAmmoStock(weapon) + 1;
				self SetWeaponAmmoStock(weapon, new_ammo_stock);
			}
		}
		else
		{
			new_ammo_stock = self GetWeaponAmmoStock(weapon) + 1;
			self SetWeaponAmmoStock(weapon, new_ammo_stock);
		}
	}
	self zm_stats::increment_client_stat("ballistic_knives_pickedup");
	self zm_stats::increment_player_stat("ballistic_knives_pickedup");
	model destroy_ent();
	trigger destroy_ent();
}

/*
	Name: destroy_ent
	Namespace: _zm_weap_ballistic_knife
	Checksum: 0xBF0DD262
	Offset: 0xF38
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function destroy_ent()
{
	if(isdefined(self))
	{
		if(isdefined(self.glowing_model))
		{
			self.glowing_model delete();
		}
		self delete();
	}
}

/*
	Name: watch_shutdown
	Namespace: _zm_weap_ballistic_knife
	Checksum: 0x76ED68AB
	Offset: 0xF90
	Size: 0x73
	Parameters: 2
	Flags: None
*/
function watch_shutdown(trigger, model)
{
	self util::waittill_any("death", "disconnect", "zmb_lost_knife");
	trigger destroy_ent();
	model destroy_ent();
}

/*
	Name: drop_knives_to_ground
	Namespace: _zm_weap_ballistic_knife
	Checksum: 0x6260A55A
	Offset: 0x1010
	Size: 0xAF
	Parameters: 1
	Flags: None
*/
function drop_knives_to_ground(player)
{
	player endon("death");
	player endon("zmb_lost_knife");
	for(;;)
	{
		level waittill("drop_objects_to_ground", origin, radius);
		if(DistanceSquared(origin, self.origin) < radius * radius)
		{
			self PhysicsLaunch((0, 0, 1), VectorScale((1, 1, 1), 5));
			self thread update_retrieve_trigger(player);
		}
	}
}

/*
	Name: force_drop_knives_to_ground_on_death
	Namespace: _zm_weap_ballistic_knife
	Checksum: 0xA9CCB7D4
	Offset: 0x10C8
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function force_drop_knives_to_ground_on_death(player, prey)
{
	self endon("death");
	player endon("zmb_lost_knife");
	prey waittill("death");
	self Unlink();
	self PhysicsLaunch((0, 0, 1), VectorScale((1, 1, 1), 5));
	self thread update_retrieve_trigger(player);
}

/*
	Name: update_retrieve_trigger
	Namespace: _zm_weap_ballistic_knife
	Checksum: 0x54F633AB
	Offset: 0x1160
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function update_retrieve_trigger(player)
{
	self endon("death");
	player endon("zmb_lost_knife");
	if(isdefined(level.custom_update_retrieve_trigger))
	{
		self [[level.custom_update_retrieve_trigger]](player);
		return;
	}
	self waittill("stationary");
	trigger = self.retrievableTrigger;
	trigger.origin = (self.origin[0], self.origin[1], self.origin[2] + 10);
	trigger LinkTo(self);
}

