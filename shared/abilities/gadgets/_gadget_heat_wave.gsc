#using scripts\codescripts\struct;
#using scripts\shared\_burnplayer;
#using scripts\shared\abilities\_ability_gadgets;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace heat_wave;

/*
	Name: __init__sytem__
	Namespace: heat_wave
	Checksum: 0x559395F0
	Offset: 0x440
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_heat_wave", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: heat_wave
	Checksum: 0x8E9BFD7B
	Offset: 0x480
	Size: 0x247
	Parameters: 0
	Flags: None
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(41, &gadget_heat_wave_on_activate, &gadget_heat_wave_on_deactivate);
	ability_player::register_gadget_possession_callbacks(41, &gadget_heat_wave_on_give, &gadget_heat_wave_on_take);
	ability_player::register_gadget_flicker_callbacks(41, &gadget_heat_wave_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(41, &gadget_heat_wave_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(41, &gadget_heat_wave_is_flickering);
	callback::on_connect(&gadget_heat_wave_on_connect);
	callback::on_spawned(&gadget_heat_wave_on_player_spawn);
	clientfield::register("scriptmover", "heatwave_fx", 1, 1, "int");
	clientfield::register("allplayers", "heatwave_victim", 1, 1, "int");
	clientfield::register("toplayer", "heatwave_activate", 1, 1, "int");
	if(!isdefined(level.vsmgr_prio_visionset_heatwave_activate))
	{
		level.vsmgr_prio_visionset_heatwave_activate = 52;
	}
	if(!isdefined(level.vsmgr_prio_visionset_heatwave_charred))
	{
		level.vsmgr_prio_visionset_heatwave_charred = 53;
	}
	visionset_mgr::register_info("visionset", "heatwave", 1, level.vsmgr_prio_visionset_heatwave_activate, 16, 1, &visionset_mgr::ramp_in_out_thread_per_player_death_shutdown, 0);
	visionset_mgr::register_info("visionset", "charred", 1, level.vsmgr_prio_visionset_heatwave_charred, 16, 1, &visionset_mgr::ramp_in_out_thread_per_player_death_shutdown, 0);
	/#
	#/
}

/*
	Name: updateDvars
	Namespace: heat_wave
	Checksum: 0x3909D333
	Offset: 0x6D0
	Size: 0x17
	Parameters: 0
	Flags: None
*/
function updateDvars()
{
	while(1)
	{
		wait(1);
	}
}

/*
	Name: gadget_heat_wave_is_inuse
	Namespace: heat_wave
	Checksum: 0x76DB6B76
	Offset: 0x6F0
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function gadget_heat_wave_is_inuse(slot)
{
	return self GadgetIsActive(slot);
}

/*
	Name: gadget_heat_wave_is_flickering
	Namespace: heat_wave
	Checksum: 0xC6D08034
	Offset: 0x720
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function gadget_heat_wave_is_flickering(slot)
{
	return self GadgetFlickering(slot);
}

/*
	Name: gadget_heat_wave_on_flicker
	Namespace: heat_wave
	Checksum: 0x52CB0928
	Offset: 0x750
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function gadget_heat_wave_on_flicker(slot, weapon)
{
	self thread gadget_heat_wave_flicker(slot, weapon);
}

/*
	Name: gadget_heat_wave_on_give
	Namespace: heat_wave
	Checksum: 0xADBEADA5
	Offset: 0x790
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_heat_wave_on_give(slot, weapon)
{
}

/*
	Name: gadget_heat_wave_on_take
	Namespace: heat_wave
	Checksum: 0x20B60633
	Offset: 0x7B0
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function gadget_heat_wave_on_take(slot, weapon)
{
	self clientfield::set_to_player("heatwave_activate", 0);
}

/*
	Name: gadget_heat_wave_on_connect
	Namespace: heat_wave
	Checksum: 0x99EC1590
	Offset: 0x7F0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function gadget_heat_wave_on_connect()
{
}

/*
	Name: gadget_heat_wave_on_player_spawn
	Namespace: heat_wave
	Checksum: 0x6940A513
	Offset: 0x800
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function gadget_heat_wave_on_player_spawn()
{
	self clientfield::set("heatwave_victim", 0);
	self._heat_wave_stuned_end = 0;
	self._heat_wave_stunned_by = undefined;
	self thread watch_entity_shutdown();
}

/*
	Name: watch_entity_shutdown
	Namespace: heat_wave
	Checksum: 0x1F8EDB3
	Offset: 0x858
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function watch_entity_shutdown()
{
	self endon("disconnect");
	self waittill("death");
	if(self IsRemoteControlling() == 0)
	{
		visionset_mgr::deactivate("visionset", "charred", self);
		visionset_mgr::deactivate("visionset", "heatwave", self);
	}
}

/*
	Name: gadget_heat_wave_on_activate
	Namespace: heat_wave
	Checksum: 0xF42DAA51
	Offset: 0x8E0
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function gadget_heat_wave_on_activate(slot, weapon)
{
	self PlayRumbleOnEntity("heat_wave_activate");
	self thread toggle_activate_clientfields();
	visionset_mgr::activate("visionset", "heatwave", self, 0.01, 0.1, 1.1);
	self thread heat_wave_think(slot, weapon);
}

/*
	Name: toggle_activate_clientfields
	Namespace: heat_wave
	Checksum: 0x2B5A6823
	Offset: 0x990
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function toggle_activate_clientfields()
{
	self endon("death");
	self endon("disconnect");
	self clientfield::set_to_player("heatwave_activate", 1);
	util::wait_network_frame();
	self clientfield::set_to_player("heatwave_activate", 0);
}

/*
	Name: gadget_heat_wave_on_deactivate
	Namespace: heat_wave
	Checksum: 0x63EEDD79
	Offset: 0xA08
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_heat_wave_on_deactivate(slot, weapon)
{
}

/*
	Name: gadget_heat_wave_flicker
	Namespace: heat_wave
	Checksum: 0x6DB021EA
	Offset: 0xA28
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_heat_wave_flicker(slot, weapon)
{
}

/*
	Name: set_gadget_status
	Namespace: heat_wave
	Checksum: 0x199CA3F3
	Offset: 0xA48
	Size: 0x9B
	Parameters: 2
	Flags: None
*/
function set_gadget_status(status, time)
{
	timeStr = "";
	if(isdefined(time))
	{
		timeStr = "^3" + ", time: " + time;
	}
	if(GetDvarInt("scr_cpower_debug_prints") > 0)
	{
		self IPrintLnBold("Gadget Heat Wave: " + status + timeStr);
	}
}

/*
	Name: is_entity_valid
	Namespace: heat_wave
	Checksum: 0x510A89F5
	Offset: 0xAF0
	Size: 0xC5
	Parameters: 2
	Flags: None
*/
function is_entity_valid(entity, heatwave)
{
	if(!isPlayer(entity))
	{
		return 0;
	}
	if(self GetEntityNumber() == entity GetEntityNumber())
	{
		return 0;
	}
	if(!isalive(entity))
	{
		return 0;
	}
	if(!entity util::mayApplyScreenEffect())
	{
		return 0;
	}
	if(!heat_wave_trace_entity(entity, heatwave))
	{
		return 0;
	}
	return 1;
}

/*
	Name: heat_wave_trace_entity
	Namespace: heat_wave
	Checksum: 0xF4B9A7F0
	Offset: 0xBC0
	Size: 0xA7
	Parameters: 2
	Flags: None
*/
function heat_wave_trace_entity(entity, heatwave)
{
	entityPoint = entity.origin + VectorScale((0, 0, 1), 50);
	if(!BulletTracePassed(heatwave.origin, entityPoint, 1, self, undefined, 0, 1))
	{
		return 0;
	}
	/#
		thread util::draw_debug_line(heatwave.origin, entityPoint, 1);
	#/
	return 1;
}

/*
	Name: heat_wave_fx_cleanup
	Namespace: heat_wave
	Checksum: 0x8138C621
	Offset: 0xC70
	Size: 0xB3
	Parameters: 2
	Flags: None
*/
function heat_wave_fx_cleanup(fxOrg, direction)
{
	self util::waittill_any("heat_wave_think", "heat_wave_think_finished");
	if(isdefined(fxOrg))
	{
		fxOrg StopLoopSound();
		fxOrg playsound("gdt_heatwave_dissipate");
		fxOrg clientfield::set("heatwave_fx", 0);
		fxOrg delete();
	}
}

/*
	Name: heat_wave_fx
	Namespace: heat_wave
	Checksum: 0xDFCF81C0
	Offset: 0xD30
	Size: 0x17F
	Parameters: 2
	Flags: None
*/
function heat_wave_fx(origin, direction)
{
	if(direction == (0, 0, 0))
	{
		direction = (0, 0, 1);
	}
	dirVec = VectorNormalize(direction);
	angles = VectorToAngles(dirVec);
	fxOrg = spawn("script_model", origin + VectorScale((0, 0, -1), 30), 0, angles);
	fxOrg.angles = angles;
	fxOrg SetOwner(self);
	fxOrg SetModel("tag_origin");
	fxOrg clientfield::set("heatwave_fx", 1);
	fxOrg PlayLoopSound("gdt_heatwave_3p_loop");
	fxOrg.soundMod = "heatwave";
	fxOrg.hitsomething = 0;
	self thread heat_wave_fx_cleanup(fxOrg, direction);
	return fxOrg;
}

/*
	Name: heat_wave_setup
	Namespace: heat_wave
	Checksum: 0x37DEBEE2
	Offset: 0xEB8
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function heat_wave_setup(weapon)
{
	heatwave = spawnstruct();
	heatwave.radius = weapon.gadget_shockfield_radius;
	heatwave.origin = self GetEye();
	heatwave.direction = AnglesToForward(self getPlayerAngles());
	heatwave.up = anglesToUp(self getPlayerAngles());
	heatwave.fxOrg = heat_wave_fx(heatwave.origin, heatwave.direction);
	return heatwave;
}

/*
	Name: heat_wave_think
	Namespace: heat_wave
	Checksum: 0xE63CEDE6
	Offset: 0xFC8
	Size: 0x105
	Parameters: 2
	Flags: None
*/
function heat_wave_think(slot, weapon)
{
	self endon("disconnect");
	self notify("heat_wave_think");
	self endon("heat_wave_think");
	self.heroAbilityActive = 1;
	heatwave = heat_wave_setup(weapon);
	glassRadiusDamage(heatwave.origin, heatwave.radius, 400, 400, "MOD_BURNED");
	self thread heat_wave_damage_entities(weapon, heatwave);
	self thread heat_wave_damage_projectiles(weapon, heatwave);
	wait(0.25);
	self.heroAbilityActive = 0;
	self notify("heat_wave_think_finished");
}

/*
	Name: heat_wave_damage_entities
	Namespace: heat_wave
	Checksum: 0xF9626BB2
	Offset: 0x10D8
	Size: 0x257
	Parameters: 2
	Flags: None
*/
function heat_wave_damage_entities(weapon, heatwave)
{
	self endon("disconnect");
	self endon("heat_wave_think");
	startTime = GetTime();
	burnedEnemy = 0;
	while(250 + startTime > GetTime())
	{
		entities = GetDamageableEntArray(heatwave.origin, heatwave.radius, 1);
		foreach(entity in entities)
		{
			if(isdefined(entity._heat_wave_damaged_time) && entity._heat_wave_damaged_time + 250 + 1 > GetTime())
			{
				continue;
			}
			if(is_entity_valid(entity, heatwave))
			{
				burnedEnemy = burnedEnemy | heat_wave_burn_entities(weapon, entity, heatwave);
				continue;
			}
			if(!isPlayer(entity))
			{
				entity DoDamage(1, heatwave.origin, self, self, "none", "MOD_BURNED", 0, weapon);
				entity thread update_last_burned_by(heatwave);
			}
		}
		wait(0.05);
	}
	if(isalive(self) && (isdefined(burnedEnemy) && burnedEnemy) && isdefined(level.playGadgetSuccess))
	{
		self [[level.playGadgetSuccess]](weapon, "heatwaveSuccessDelay");
	}
}

/*
	Name: heat_wave_burn_entities
	Namespace: heat_wave
	Checksum: 0x63FC4747
	Offset: 0x1338
	Size: 0x15F
	Parameters: 3
	Flags: None
*/
function heat_wave_burn_entities(weapon, entity, heatwave)
{
	burn_self = 0;
	burn_entity = 1;
	burned_enemy = 1;
	if(self.team == entity.team)
	{
		burned_enemy = 0;
		switch(level.friendlyfire)
		{
			case 0:
			{
				burn_entity = 0;
				break;
			}
			case 1:
			{
				break;
			}
			case 2:
			{
				burn_entity = 0;
				burn_self = 1;
				break;
			}
			case 3:
			{
				burn_self = 1;
				break;
			}
		}
	}
	if(burn_entity)
	{
		apply_burn(weapon, entity, heatwave);
		entity thread update_last_burned_by(heatwave);
	}
	if(burn_self)
	{
		apply_burn(weapon, self, heatwave);
		self thread update_last_burned_by(heatwave);
	}
	return burned_enemy;
}

/*
	Name: heat_wave_damage_projectiles
	Namespace: heat_wave
	Checksum: 0x18602068
	Offset: 0x14A0
	Size: 0x297
	Parameters: 2
	Flags: None
*/
function heat_wave_damage_projectiles(weapon, heatwave)
{
	self endon("disconnect");
	self endon("heat_wave_think");
	owner = self;
	startTime = GetTime();
	while(250 + startTime > GetTime())
	{
		if(level.MissileEntities.size < 1)
		{
			wait(0.05);
			continue;
		}
		for(index = 0; index < level.MissileEntities.size; index++)
		{
			wait(0.05);
			grenade = level.MissileEntities[index];
			if(!isdefined(grenade))
			{
				continue;
			}
			if(grenade.weapon.isTacticalInsertion)
			{
				continue;
			}
			switch(grenade.model)
			{
				case "t6_wpn_grenade_supply_projectile":
				{
					continue;
				}
			}
			if(!isdefined(grenade.owner))
			{
				grenade.owner = GetMissileOwner(grenade);
			}
			if(isdefined(grenade.owner))
			{
				if(level.teambased)
				{
					if(grenade.owner.team == owner.team)
					{
						continue;
					}
				}
				else if(grenade.owner == owner)
				{
					continue;
				}
				grenadeDistanceSquared = DistanceSquared(grenade.origin, heatwave.origin);
				if(grenadeDistanceSquared < heatwave.radius * heatwave.radius)
				{
					if(BulletTracePassed(grenade.origin, heatwave.origin + VectorScale((0, 0, 1), 29), 0, owner, grenade, 0, 1))
					{
						owner projectileExplode(grenade, heatwave, weapon);
						index--;
					}
				}
			}
		}
	}
}

/*
	Name: projectileExplode
	Namespace: heat_wave
	Checksum: 0xB07D4E51
	Offset: 0x1740
	Size: 0xAB
	Parameters: 3
	Flags: None
*/
function projectileExplode(projectile, heatwave, weapon)
{
	projPosition = projectile.origin;
	playFX(level.trophydetonationfx, projPosition);
	projectile notify("trophy_destroyed");
	self RadiusDamage(projPosition, 128, 105, 10, self, "MOD_BURNED", weapon);
	projectile delete();
}

/*
	Name: apply_burn
	Namespace: heat_wave
	Checksum: 0x3A19DFDA
	Offset: 0x17F8
	Size: 0x205
	Parameters: 3
	Flags: None
*/
function apply_burn(weapon, entity, heatwave)
{
	damage = floor(entity.health * 0.2);
	entity DoDamage(damage, self.origin + VectorScale((0, 0, 1), 30), self, heatwave.fxOrg, 0, "MOD_BURNED", 0, weapon);
	entity setdoublejumpenergy(0);
	entity clientfield::set("heatwave_victim", 1);
	visionset_mgr::activate("visionset", "charred", entity, 0.01, 2, 1.5);
	entity thread watch_burn_clear();
	entity resetdoublejumprechargetime();
	shellshock_duration = 2.5;
	entity._heat_wave_stuned_end = GetTime() + shellshock_duration * 1000;
	if(!isdefined(entity._heat_wave_stunned_by))
	{
		entity._heat_wave_stunned_by = [];
	}
	entity._heat_wave_stunned_by[self.clientid] = entity._heat_wave_stuned_end;
	entity shellshock("heat_wave", shellshock_duration, 1);
	entity thread heat_wave_burn_sound(shellshock_duration);
	burned = 1;
}

/*
	Name: watch_burn_clear
	Namespace: heat_wave
	Checksum: 0x356F2356
	Offset: 0x1A08
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function watch_burn_clear()
{
	self endon("disconnect");
	self endon("death");
	util::wait_network_frame();
	self clientfield::set("heatwave_victim", 0);
}

/*
	Name: update_last_burned_by
	Namespace: heat_wave
	Checksum: 0x7FD4F08A
	Offset: 0x1A60
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function update_last_burned_by(heatwave)
{
	self endon("disconnect");
	self endon("death");
	self._heat_wave_damaged_time = GetTime();
	wait(250);
}

/*
	Name: heat_wave_burn_sound
	Namespace: heat_wave
	Checksum: 0x56683D25
	Offset: 0x1AA0
	Size: 0xDB
	Parameters: 1
	Flags: None
*/
function heat_wave_burn_sound(shellshock_duration)
{
	fire_sound_ent = spawn("script_origin", self.origin);
	fire_sound_ent LinkTo(self, "tag_origin", (0, 0, 0), (0, 0, 0));
	fire_sound_ent PlayLoopSound("mpl_heatwave_burn_loop");
	wait(shellshock_duration);
	if(isdefined(fire_sound_ent))
	{
		fire_sound_ent StopLoopSound(0.5);
		util::wait_network_frame();
		fire_sound_ent delete();
	}
}

