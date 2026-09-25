#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\killcam_shared;
#using scripts\shared\player_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace lightninggun;

/*
	Name: init_shared
	Namespace: lightninggun
	Checksum: 0x4D8BFBF6
	Offset: 0x358
	Size: 0x183
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level.weaponLightningGun = GetWeapon("hero_lightninggun");
	level.weaponLightningGunArc = GetWeapon("hero_lightninggun_arc");
	level.weaponLightningGunKillcamTime = GetDvarFloat("scr_lightningGunKillcamTime", 0.35);
	level.weaponLightningGunKillcamDecelPercent = GetDvarFloat("scr_lightningGunKillcamDecelPercent", 0.25);
	level.weaponLightningGunKillcamOffset = GetDvarFloat("scr_lightningGunKillcamOffset", 150);
	level.lightninggun_arc_range = 300;
	level.lightninggun_arc_range_sq = level.lightninggun_arc_range * level.lightninggun_arc_range;
	level.lightninggun_arc_speed = 650;
	level.lightninggun_arc_speed_sq = level.lightninggun_arc_speed * level.lightninggun_arc_speed;
	level.lightninggun_arc_fx_min_range = 1;
	level.lightninggun_arc_fx_min_range_sq = level.lightninggun_arc_fx_min_range * level.lightninggun_arc_fx_min_range;
	level._effect["lightninggun_arc"] = "weapon/fx_lightninggun_arc";
	callback::add_weapon_damage(level.weaponLightningGun, &on_damage_lightninggun);
	/#
		level thread update_dvars();
	#/
}

/*
	Name: update_dvars
	Namespace: lightninggun
	Checksum: 0x33CC7E23
	Offset: 0x4E8
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function update_dvars()
{
	/#
		while(1)
		{
			wait(1);
			level.weaponLightningGunKillcamTime = GetDvarFloat("Dev Block strings are not supported", 0.35);
			level.weaponLightningGunKillcamDecelPercent = GetDvarFloat("Dev Block strings are not supported", 0.25);
			level.weaponLightningGunKillcamOffset = GetDvarFloat("Dev Block strings are not supported", 150);
		}
	#/
}

/*
	Name: lightninggun_start_damage_effects
	Namespace: lightninggun
	Checksum: 0xB8A571B7
	Offset: 0x580
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function lightninggun_start_damage_effects(eAttacker)
{
	self endon("disconnect");
	/#
		if(IsGodMode(self))
		{
			return;
		}
	#/
	self SetElectrifiedState(1);
	self.electrifiedBy = eAttacker;
	self PlayRumbleOnEntity("lightninggun_victim");
	wait(2);
	self.electrifiedBy = undefined;
	self SetElectrifiedState(0);
}

/*
	Name: lightninggun_arc_killcam
	Namespace: lightninggun
	Checksum: 0xD1B58D17
	Offset: 0x628
	Size: 0xB3
	Parameters: 5
	Flags: None
*/
function lightninggun_arc_killcam(arc_source_pos, arc_target, arc_target_pos, original_killcam_ent, waitTime)
{
	arc_target.killcamKilledByEnt = create_killcam_entity(original_killcam_ent.origin, original_killcam_ent.angles, level.weaponLightningGunArc);
	arc_target.killcamKilledByEnt killcam::store_killcam_entity_on_entity(original_killcam_ent);
	arc_target.killcamKilledByEnt killcam_move(arc_source_pos, arc_target_pos, waitTime);
}

/*
	Name: lightninggun_arc_fx
	Namespace: lightninggun
	Checksum: 0xF3E1E87A
	Offset: 0x6E8
	Size: 0x281
	Parameters: 5
	Flags: None
*/
function lightninggun_arc_fx(arc_source_pos, arc_target, arc_target_pos, distanceSq, original_killcam_ent)
{
	if(!isdefined(arc_target) || !isdefined(original_killcam_ent))
	{
		return;
	}
	waitTime = 0.25;
	if(level.lightninggun_arc_speed_sq > 100 && distanceSq > 1)
	{
		waitTime = distanceSq / level.lightninggun_arc_speed_sq;
	}
	lightninggun_arc_killcam(arc_source_pos, arc_target, arc_target_pos, original_killcam_ent, waitTime);
	killcamentity = arc_target.killcamKilledByEnt;
	if(!isdefined(arc_target) || !isdefined(original_killcam_ent))
	{
		return;
	}
	if(distanceSq < level.lightninggun_arc_fx_min_range_sq)
	{
		wait(waitTime);
		killcamentity delete();
		if(isdefined(arc_target))
		{
			arc_target.killcamKilledByEnt = undefined;
		}
		return;
	}
	fxOrg = spawn("script_model", arc_source_pos);
	fxOrg SetModel("tag_origin");
	FX = PlayFXOnTag(level._effect["lightninggun_arc"], fxOrg, "tag_origin");
	playsoundatposition("wpn_lightning_gun_bounce", fxOrg.origin);
	fxOrg moveto(arc_target_pos, waitTime);
	fxOrg waittill("movedone");
	util::wait_network_frame();
	util::wait_network_frame();
	util::wait_network_frame();
	fxOrg delete();
	killcamentity delete();
	if(isdefined(arc_target))
	{
		arc_target.killcamKilledByEnt = undefined;
	}
}

/*
	Name: lightninggun_arc
	Namespace: lightninggun
	Checksum: 0xF42CCA32
	Offset: 0x978
	Size: 0x163
	Parameters: 8
	Flags: None
*/
function lightninggun_arc(delay, eAttacker, arc_source, arc_source_origin, arc_source_pos, arc_target, arc_target_pos, distanceSq)
{
	if(delay)
	{
		wait(delay);
		if(!isdefined(arc_target) || !isalive(arc_target))
		{
			return;
		}
		distanceSq = DistanceSquared(arc_target.origin, arc_source_origin);
		if(distanceSq > level.lightninggun_arc_range_sq)
		{
			return;
		}
	}
	if(!isdefined(arc_source))
	{
		return;
	}
	if(!isdefined(arc_source.killcamKilledByEnt))
	{
		return;
	}
	level thread lightninggun_arc_fx(arc_source_pos, arc_target, arc_target_pos, distanceSq, arc_source.killcamKilledByEnt);
	arc_target thread lightninggun_start_damage_effects(eAttacker);
	arc_target DoDamage(arc_target.health, arc_source_pos, eAttacker, arc_source, "none", "MOD_PISTOL_BULLET", 0, level.weaponLightningGunArc);
}

/*
	Name: lightninggun_find_arc_targets
	Namespace: lightninggun
	Checksum: 0x17C5DC1A
	Offset: 0xAE8
	Size: 0x23B
	Parameters: 4
	Flags: None
*/
function lightninggun_find_arc_targets(eAttacker, arc_source, arc_source_origin, arc_source_pos)
{
	delay = 0.05;
	if(!isdefined(eAttacker))
	{
		return;
	}
	allEnemyAlivePlayers = util::get_other_teams_alive_players_s(eAttacker.team);
	closestPlayers = ArraySort(allEnemyAlivePlayers.a, arc_source_origin, 1);
	foreach(player in closestPlayers)
	{
		if(isdefined(arc_source) && player == arc_source)
		{
			continue;
		}
		if(player player::is_spawn_protected())
		{
			continue;
		}
		distanceSq = DistanceSquared(player.origin, arc_source_origin);
		if(distanceSq > level.lightninggun_arc_range_sq)
		{
			break;
		}
		if(eAttacker != player && weaponobjects::friendlyFireCheck(eAttacker, player))
		{
			if(isdefined(self) && !player damageConeTrace(arc_source_pos, self))
			{
				continue;
			}
			level thread lightninggun_arc(delay, eAttacker, arc_source, arc_source_origin, arc_source_pos, player, player GetTagOrigin("j_spineupper"), distanceSq);
			delay = delay + 0.05;
		}
	}
}

/*
	Name: create_killcam_entity
	Namespace: lightninggun
	Checksum: 0x2AC7397F
	Offset: 0xD30
	Size: 0x97
	Parameters: 3
	Flags: None
*/
function create_killcam_entity(origin, angles, weapon)
{
	killcamKilledByEnt = spawn("script_model", origin);
	killcamKilledByEnt SetModel("tag_origin");
	killcamKilledByEnt.angles = angles;
	killcamKilledByEnt setWeapon(weapon);
	return killcamKilledByEnt;
}

/*
	Name: killcam_move
	Namespace: lightninggun
	Checksum: 0x553F1292
	Offset: 0xDD0
	Size: 0x13F
	Parameters: 3
	Flags: None
*/
function killcam_move(start_origin, end_origin, time)
{
	delta = end_origin - start_origin;
	dist = length(delta);
	delta = VectorNormalize(delta);
	move_to_dist = dist - level.weaponLightningGunKillcamOffset;
	end_angles = (0, 0, 0);
	if(move_to_dist > 0)
	{
		move_to_pos = start_origin + delta * move_to_dist;
		self moveto(move_to_pos, time, 0, time * level.weaponLightningGunKillcamDecelPercent);
		end_angles = VectorToAngles(delta);
	}
	else
	{
		delta = end_origin - self.origin;
		end_angles = VectorToAngles(delta);
	}
}

/*
	Name: lightninggun_damage_response
	Namespace: lightninggun
	Checksum: 0xC9EA10C6
	Offset: 0xF18
	Size: 0x251
	Parameters: 5
	Flags: None
*/
function lightninggun_damage_response(eAttacker, eInflictor, weapon, meansOfDeath, damage)
{
	source_pos = eAttacker.origin;
	bolt_source_pos = eAttacker GetTagOrigin("tag_flash");
	arc_source = self;
	arc_source_origin = self.origin;
	arc_source_pos = self GetTagOrigin("j_spineupper");
	delta = arc_source_pos - bolt_source_pos;
	angles = (0, 0, 0);
	arc_source.killcamKilledByEnt = create_killcam_entity(bolt_source_pos, angles, weapon);
	arc_source.killcamKilledByEnt killcam_move(bolt_source_pos, arc_source_pos, level.weaponLightningGunKillcamTime);
	killcamentity = arc_source.killcamKilledByEnt;
	self thread lightninggun_start_damage_effects(eAttacker);
	wait(2);
	if(!isdefined(self))
	{
		self thread lightninggun_find_arc_targets(eAttacker, undefined, arc_source_origin, arc_source_pos);
		return;
	}
	if(isdefined(self.body))
	{
		arc_source_origin = self.body.origin;
		arc_source_pos = self.body GetTagOrigin("j_spineupper");
	}
	self thread lightninggun_find_arc_targets(eAttacker, arc_source, arc_source_origin, arc_source_pos);
	wait(0.45);
	killcamentity delete();
	if(isdefined(arc_source))
	{
		arc_source.killcamKilledByEnt = undefined;
	}
}

/*
	Name: on_damage_lightninggun
	Namespace: lightninggun
	Checksum: 0x9B115F62
	Offset: 0x1178
	Size: 0x73
	Parameters: 5
	Flags: None
*/
function on_damage_lightninggun(eAttacker, eInflictor, weapon, meansOfDeath, damage)
{
	if("MOD_PISTOL_BULLET" != meansOfDeath && "MOD_HEAD_SHOT" != meansOfDeath)
	{
		return;
	}
	self thread lightninggun_damage_response(eAttacker, eInflictor, weapon, meansOfDeath, damage);
}

