#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_hacker_tool;
#using scripts\shared\weapons\_weaponobjects;

#namespace tacticalinsertion;

/*
	Name: init_shared
	Namespace: tacticalinsertion
	Checksum: 0x4BF2B742
	Offset: 0x448
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	if(level.gametype == "infect")
	{
		level.weapontacticalInsertion = GetWeapon("trophy_system");
	}
	else
	{
		level.weapontacticalInsertion = GetWeapon("tactical_insertion");
	}
	level._effect["tacticalInsertionFizzle"] = "_t6/misc/fx_equip_tac_insert_exp";
	clientfield::register("scriptmover", "tacticalinsertion", 1, 1, "int");
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: on_player_spawned
	Namespace: tacticalinsertion
	Checksum: 0x5FBB91D4
	Offset: 0x520
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self thread begin_other_grenade_tracking();
}

/*
	Name: isTacSpawnTouchingCrates
	Namespace: tacticalinsertion
	Checksum: 0xDDB00F46
	Offset: 0x548
	Size: 0xE7
	Parameters: 2
	Flags: None
*/
function isTacSpawnTouchingCrates(origin, angles)
{
	crate_ents = GetEntArray("care_package", "script_noteworthy");
	mins = (-17, -17, -40);
	maxs = (17, 17, 40);
	for(i = 0; i < crate_ents.size; i++)
	{
		if(crate_ents[i] IsTouchingVolume(origin + VectorScale((0, 0, 1), 40), mins, maxs))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: overrideSpawn
	Namespace: tacticalinsertion
	Checksum: 0xC01EBAB1
	Offset: 0x638
	Size: 0x147
	Parameters: 1
	Flags: None
*/
function overrideSpawn(isPredictedSpawn)
{
	if(!isdefined(self.tacticalinsertion))
	{
		return 0;
	}
	origin = self.tacticalinsertion.origin;
	angles = self.tacticalinsertion.angles;
	team = self.tacticalinsertion.team;
	if(!isPredictedSpawn)
	{
		self.tacticalinsertion destroy_tactical_insertion();
	}
	if(team != self.team)
	{
		return 0;
	}
	if(isTacSpawnTouchingCrates(origin))
	{
		return 0;
	}
	if(!isPredictedSpawn)
	{
		self.tacticalInsertionTime = GetTime();
		self spawn(origin, angles, "tactical insertion");
		self SetSpawnClientFlag("SCDFL_DISABLE_LOGGING");
		self addweaponstat(level.weapontacticalInsertion, "used", 1);
	}
	return 1;
}

/*
	Name: WaitAndDelete
	Namespace: tacticalinsertion
	Checksum: 0xCA239D62
	Offset: 0x788
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function WaitAndDelete(time)
{
	self endon("death");
	wait(0.05);
	self delete();
}

/*
	Name: watch
	Namespace: tacticalinsertion
	Checksum: 0xFA400B03
	Offset: 0x7C8
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function watch(player)
{
	if(isdefined(player.tacticalinsertion))
	{
		player.tacticalinsertion destroy_tactical_insertion();
	}
	player thread spawnTacticalInsertion();
	self WaitAndDelete(0.05);
}

/*
	Name: watchUseTrigger
	Namespace: tacticalinsertion
	Checksum: 0xBEB5C2A8
	Offset: 0x848
	Size: 0x1D1
	Parameters: 4
	Flags: None
*/
function watchUseTrigger(trigger, callback, playerSoundOnUse, npcSoundOnUse)
{
	self endon("delete");
	while(1)
	{
		trigger waittill("trigger", player);
		if(!isalive(player))
		{
			continue;
		}
		if(!player IsOnGround())
		{
			continue;
		}
		if(isdefined(trigger.triggerTeam) && player.team != trigger.triggerTeam)
		{
			continue;
		}
		if(isdefined(trigger.triggerTeamIgnore) && player.team == trigger.triggerTeamIgnore)
		{
			continue;
		}
		if(isdefined(trigger.ClaimedBy) && player != trigger.ClaimedBy)
		{
			continue;
		}
		if(player useButtonPressed() && !player.throwingGrenade && !player meleeButtonPressed())
		{
			if(isdefined(playerSoundOnUse))
			{
				player playlocalsound(playerSoundOnUse);
			}
			if(isdefined(npcSoundOnUse))
			{
				player playsound(npcSoundOnUse);
			}
			self thread [[callback]](player);
		}
	}
}

/*
	Name: watchDisconnect
	Namespace: tacticalinsertion
	Checksum: 0xCF66D2B6
	Offset: 0xA28
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function watchDisconnect()
{
	self.tacticalinsertion endon("delete");
	self waittill("disconnect");
	self.tacticalinsertion thread destroy_tactical_insertion();
}

/*
	Name: destroy_tactical_insertion
	Namespace: tacticalinsertion
	Checksum: 0xDF66AEF9
	Offset: 0xA70
	Size: 0x1E3
	Parameters: 1
	Flags: None
*/
function destroy_tactical_insertion(attacker)
{
	self.owner.tacticalinsertion = undefined;
	self notify("delete");
	self.owner notify("tactical_insertion_destroyed");
	self.friendlyTrigger delete();
	self.enemyTrigger delete();
	if(isdefined(attacker) && isdefined(attacker.pers["team"]) && isdefined(self.owner) && isdefined(self.owner.pers["team"]))
	{
		if(level.teambased)
		{
			if(attacker.pers["team"] != self.owner.pers["team"])
			{
				attacker notify("destroyed_explosive");
				attacker challenges::destroyedEquipment();
				attacker challenges::destroyedTacticalInsert();
				scoreevents::processScoreEvent("destroyed_tac_insert", attacker);
			}
		}
		else if(attacker != self.owner)
		{
			attacker notify("destroyed_explosive");
			attacker challenges::destroyedEquipment();
			attacker challenges::destroyedTacticalInsert();
			scoreevents::processScoreEvent("destroyed_tac_insert", attacker);
		}
	}
	self delete();
}

/*
	Name: fizzle
	Namespace: tacticalinsertion
	Checksum: 0xF1A555FD
	Offset: 0xC60
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function fizzle(attacker)
{
	if(isdefined(self.fizzle) && self.fizzle)
	{
		return;
	}
	self.fizzle = 1;
	playFX(level._effect["tacticalInsertionFizzle"], self.origin);
	self playsound("dst_tac_insert_break");
	if(isdefined(attacker) && attacker != self.owner)
	{
		if(isdefined(level.globallogic_audio_dialog_on_player_override))
		{
			self.owner [[level.globallogic_audio_dialog_on_player_override]]("tact_destroyed", "item_destroyed");
		}
	}
	self destroy_tactical_insertion(attacker);
}

/*
	Name: pickup
	Namespace: tacticalinsertion
	Checksum: 0x4E58DF5B
	Offset: 0xD50
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function pickup(attacker)
{
	player = self.owner;
	self destroy_tactical_insertion();
	player GiveWeapon(level.weapontacticalInsertion);
	player SetWeaponAmmoClip(level.weapontacticalInsertion, 1);
}

/*
	Name: spawnTacticalInsertion
	Namespace: tacticalinsertion
	Checksum: 0x27334525
	Offset: 0xDD0
	Size: 0x8CF
	Parameters: 0
	Flags: None
*/
function spawnTacticalInsertion()
{
	self endon("disconnect");
	trace = bullettrace(self.origin, self.origin + VectorScale((0, 0, -1), 30), 0, self);
	trace["position"] = trace["position"] + (0, 0, 1);
	if(!self IsOnGround() && BulletTracePassed(self.origin, self.origin + VectorScale((0, 0, -1), 30), 0, self))
	{
		self GiveWeapon(level.weapontacticalInsertion);
		self SetWeaponAmmoClip(level.weapontacticalInsertion, 1);
		return;
	}
	self.tacticalinsertion = spawn("script_model", trace["position"]);
	self.tacticalinsertion SetModel("wpn_t7_trophy_system");
	self.tacticalinsertion.origin = self.origin + (0, 0, 1);
	self.tacticalinsertion.angles = self.angles;
	self.tacticalinsertion.team = self.team;
	self.tacticalinsertion SetTeam(self.team);
	self.tacticalinsertion.owner = self;
	self.tacticalinsertion SetOwner(self);
	self.tacticalinsertion setWeapon(level.weapontacticalInsertion);
	self.tacticalinsertion endon("delete");
	self.tacticalinsertion hacker_tool::registerWithHackerTool(level.equipmentHackerToolRadius, level.equipmentHackerToolTimeMs);
	triggerHeight = 64;
	triggerRadius = 128;
	self.tacticalinsertion.friendlyTrigger = spawn("trigger_radius_use", self.tacticalinsertion.origin + VectorScale((0, 0, 1), 3));
	self.tacticalinsertion.friendlyTrigger setcursorhint("HINT_NOICON", self.tacticalinsertion);
	self.tacticalinsertion.friendlyTrigger setHintString(&"MP_TACTICAL_INSERTION_PICKUP");
	if(level.teambased)
	{
		self.tacticalinsertion.friendlyTrigger SetTeamForTrigger(self.team);
		self.tacticalinsertion.friendlyTrigger.triggerTeam = self.team;
	}
	self ClientClaimTrigger(self.tacticalinsertion.friendlyTrigger);
	self.tacticalinsertion.friendlyTrigger.ClaimedBy = self;
	self.tacticalinsertion.enemyTrigger = spawn("trigger_radius_use", self.tacticalinsertion.origin + VectorScale((0, 0, 1), 3));
	self.tacticalinsertion.enemyTrigger setcursorhint("HINT_NOICON", self.tacticalinsertion);
	self.tacticalinsertion.enemyTrigger setHintString(&"MP_TACTICAL_INSERTION_DESTROY");
	self.tacticalinsertion.enemyTrigger SetInvisibleToPlayer(self);
	if(level.teambased)
	{
		self.tacticalinsertion.enemyTrigger SetExcludeTeamForTrigger(self.team);
		self.tacticalinsertion.enemyTrigger.triggerTeamIgnore = self.team;
	}
	self.tacticalinsertion clientfield::set("tacticalinsertion", 1);
	self thread watchDisconnect();
	watcher = weaponobjects::getWeaponObjectWatcherByWeapon(level.weapontacticalInsertion);
	self.tacticalinsertion thread watchUseTrigger(self.tacticalinsertion.friendlyTrigger, &pickup, watcher.pickUpSoundPlayer, watcher.pickUpSound);
	self.tacticalinsertion thread watchUseTrigger(self.tacticalinsertion.enemyTrigger, &fizzle);
	if(isdefined(self.tacticalInsertionCount))
	{
		self.tacticalInsertionCount++;
	}
	else
	{
		self.tacticalInsertionCount = 1;
	}
	self.tacticalinsertion SetCanDamage(1);
	self.tacticalinsertion.health = 1;
	while(1)
	{
		self.tacticalinsertion waittill("damage", damage, attacker, direction, point, type, tagName, modelName, partName, weapon, iDFlags);
		if(level.teambased && (!isdefined(attacker) || !isPlayer(attacker) || attacker.team == self.team) && attacker != self)
		{
			continue;
		}
		if(attacker != self)
		{
			attacker challenges::destroyedEquipment(weapon);
			attacker challenges::destroyedTacticalInsert();
			scoreevents::processScoreEvent("destroyed_tac_insert", attacker);
		}
		if(watcher.stunTime > 0 && weapon.doStun)
		{
			self thread weaponobjects::stunStart(watcher, watcher.stunTime);
		}
		if(weapon.doDamageFeedback)
		{
			if(level.teambased && self.tacticalinsertion.owner.team != attacker.team)
			{
				if(damagefeedback::doDamageFeedback(weapon, attacker))
				{
					attacker damagefeedback::update();
				}
			}
			else if(!level.teambased && self.tacticalinsertion.owner != attacker)
			{
				if(damagefeedback::doDamageFeedback(weapon, attacker))
				{
					attacker damagefeedback::update();
				}
			}
		}
		if(isdefined(attacker) && attacker != self)
		{
			if(isdefined(level.globallogic_audio_dialog_on_player_override))
			{
				self [[level.globallogic_audio_dialog_on_player_override]]("tact_destroyed", "item_destroyed");
			}
		}
		self.tacticalinsertion thread fizzle();
	}
}

/*
	Name: cancel_button_think
	Namespace: tacticalinsertion
	Checksum: 0x6BA4F317
	Offset: 0x16A8
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function cancel_button_think()
{
	if(!isdefined(self.tacticalinsertion))
	{
		return;
	}
	text = cancel_text_create();
	self thread cancel_button_press();
	event = self util::waittill_any_return("tactical_insertion_destroyed", "disconnect", "end_killcam", "abort_killcam", "tactical_insertion_canceled", "spawned");
	if(event == "tactical_insertion_canceled")
	{
		self.tacticalinsertion destroy_tactical_insertion();
	}
	if(isdefined(text))
	{
		text destroy();
	}
}

/*
	Name: cancelTackInsertionButton
	Namespace: tacticalinsertion
	Checksum: 0x27F4F62B
	Offset: 0x1798
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function cancelTackInsertionButton()
{
	if(level.console)
	{
		return self ChangeSeatButtonPressed();
	}
	else
	{
		return self JumpButtonPressed();
	}
}

/*
	Name: cancel_button_press
	Namespace: tacticalinsertion
	Checksum: 0x60C973E8
	Offset: 0x17E0
	Size: 0x61
	Parameters: 0
	Flags: None
*/
function cancel_button_press()
{
	self endon("disconnect");
	self endon("end_killcam");
	self endon("abort_killcam");
	while(1)
	{
		wait(0.05);
		if(self cancelTackInsertionButton())
		{
			break;
		}
	}
	self notify("tactical_insertion_canceled");
}

/*
	Name: cancel_text_create
	Namespace: tacticalinsertion
	Checksum: 0x672BAC1A
	Offset: 0x1850
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function cancel_text_create()
{
	text = newClientHudElem(self);
	text.archived = 0;
	text.y = -100;
	text.alignX = "center";
	text.alignY = "middle";
	text.horzAlign = "center";
	text.vertAlign = "bottom";
	text.sort = 10;
	text.font = "small";
	text.foreground = 1;
	text.hidewheninmenu = 1;
	if(self IsSplitscreen())
	{
		text.y = -80;
		text.fontscale = 1.2;
	}
	else
	{
		text.fontscale = 1.6;
	}
	text setText(&"PLATFORM_PRESS_TO_CANCEL_TACTICAL_INSERTION");
	text.alpha = 1;
	return text;
}

/*
	Name: getTacticalInsertions
	Namespace: tacticalinsertion
	Checksum: 0x8FAAE533
	Offset: 0x19D8
	Size: 0xB5
	Parameters: 0
	Flags: None
*/
function getTacticalInsertions()
{
	tac_inserts = [];
	foreach(player in level.players)
	{
		if(isdefined(player.tacticalinsertion))
		{
			tac_inserts[tac_inserts.size] = player.tacticalinsertion;
		}
	}
	return tac_inserts;
}

/*
	Name: tacticalInsertionDestroyedByTrophySystem
	Namespace: tacticalinsertion
	Checksum: 0x21FBC319
	Offset: 0x1A98
	Size: 0xDF
	Parameters: 2
	Flags: None
*/
function tacticalInsertionDestroyedByTrophySystem(attacker, trophySystem)
{
	owner = self.owner;
	if(isdefined(attacker))
	{
		attacker challenges::destroyedEquipment(trophySystem.name);
		attacker challenges::destroyedTacticalInsert();
	}
	self thread fizzle();
	if(isdefined(owner))
	{
		owner endon("death");
		owner endon("disconnect");
		wait(0.05);
		if(isdefined(level.globallogic_audio_dialog_on_player_override))
		{
			owner [[level.globallogic_audio_dialog_on_player_override]]("tact_destroyed", "item_destroyed");
		}
	}
}

/*
	Name: begin_other_grenade_tracking
	Namespace: tacticalinsertion
	Checksum: 0xB6D0258C
	Offset: 0x1B80
	Size: 0xDF
	Parameters: 0
	Flags: None
*/
function begin_other_grenade_tracking()
{
	self endon("death");
	self endon("disconnect");
	self notify("insertionTrackingStart");
	self endon("insertionTrackingStart");
	for(;;)
	{
		self waittill("grenade_fire", grenade, weapon, cookTime);
		if(grenade util::isHacked())
		{
			continue;
		}
		if(weapon == level.weapontacticalInsertion)
		{
			if(level.gametype == "infect" && self.team == game["defenders"])
			{
				return;
			}
			grenade thread watch(self);
		}
	}
}

