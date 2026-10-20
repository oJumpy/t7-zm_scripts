#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_ai_quad;

/*
	Name: __init__sytem__
	Namespace: zm_ai_quad
	Checksum: 0xED5FD46F
	Offset: 0x4F0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_quad", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_quad
	Checksum: 0x68B806A4
	Offset: 0x530
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	init_quad_zombie_fx();
	if(!isdefined(level.ai_quad_register_overlay_override) || level.ai_quad_register_overlay_override)
	{
		register_overlay();
	}
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("quad_melee", &quadnotetrackmeleefire);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("quadDeathAction", &quaddeathaction);
	level thread AAT::register_immunity("zm_aat_dead_wire", "zombie_quad", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_turned", "zombie_quad", 1, 1, 1);
}

/*
	Name: quadnotetrackmeleefire
	Namespace: zm_ai_quad
	Checksum: 0xD6D995AB
	Offset: 0x630
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function quadnotetrackmeleefire(entity)
{
	entity melee();
	/#
		Record3DText("Dev Block strings are not supported", self.origin, (1, 0, 0), "Dev Block strings are not supported", entity);
	#/
}

/*
	Name: quaddeathaction
	Namespace: zm_ai_quad
	Checksum: 0x602351C5
	Offset: 0x698
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function quaddeathaction(entity)
{
	if(isdefined(entity.fx_quad_trail))
	{
		entity.fx_quad_trail Unlink();
		entity.fx_quad_trail delete();
	}
	if(entity.can_explode && (!isdefined(entity.guts_explosion) && entity.guts_explosion))
	{
		entity thread quad_gas_explo_death();
	}
	entity StartRagdoll();
}

/*
	Name: activate_quad_spawners
	Namespace: zm_ai_quad
	Checksum: 0xE452B0C0
	Offset: 0x768
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function activate_quad_spawners()
{
	level.quad_spawners = GetEntArray("quad_zombie_spawner", "script_noteworthy");
	Array::thread_all(level.quad_spawners, &spawner::add_spawn_function, &quad_prespawn);
	zm::register_custom_ai_spawn_check("quads", &quad_spawn_check, &get_quad_spawners);
}

/*
	Name: register_overlay
	Namespace: zm_ai_quad
	Checksum: 0xD43DFF69
	Offset: 0x810
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function register_overlay()
{
	if(!isdefined(level.vsmgr_prio_overlay_zm_ai_quad_blur))
	{
		level.vsmgr_prio_overlay_zm_ai_quad_blur = 50;
	}
	visionset_mgr::register_info("overlay", "zm_ai_quad_blur", 1, level.vsmgr_prio_overlay_zm_ai_quad_blur, 1, 1);
}

/*
	Name: quad_spawn_check
	Namespace: zm_ai_quad
	Checksum: 0x61CE2E61
	Offset: 0x870
	Size: 0x31
	Parameters: 0
	Flags: None
*/
function quad_spawn_check()
{
	return isdefined(level.zm_loc_types["quad_location"]) && level.zm_loc_types["quad_location"].size > 0;
}

/*
	Name: get_quad_spawners
	Namespace: zm_ai_quad
	Checksum: 0x75425E99
	Offset: 0x8B0
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_quad_spawners()
{
	return level.quad_spawners;
}

/*
	Name: quad_prespawn
	Namespace: zm_ai_quad
	Checksum: 0xF2C75FFC
	Offset: 0x8C8
	Size: 0x25F
	Parameters: 0
	Flags: None
*/
function quad_prespawn()
{
	self.animName = "quad_zombie";
	self.no_gib = 1;
	self.no_eye_glow = 1;
	self.no_widows_wine = 1;
	self.canBeTargetedByTurnedZombies = 1;
	self.custom_location = &quad_location;
	self zm_spawner::zombie_spawn_init(1);
	self.zombie_can_sidestep = 0;
	self.maxhealth = Int(self.maxhealth * 0.75);
	self.health = self.maxhealth;
	self.freezegun_damage = 0;
	self.meleeDamage = 45;
	self playsound("zmb_quad_spawn");
	self.death_explo_radius_zomb = 96;
	self.death_explo_radius_plr = 96;
	self.death_explo_damage_zomb = 1.05;
	self.death_gas_radius = 125;
	self.death_gas_time = 7;
	if(isdefined(level.quad_explode) && level.quad_explode)
	{
		self.deathFunction = &quad_post_death;
		self.actor_killed_override = &quad_killed_override;
	}
	self set_default_attack_properties();
	self.thundergun_knockdown_func = &quad_thundergun_knockdown;
	self.pre_teleport_func = &quad_pre_teleport;
	self.post_teleport_func = &quad_post_teleport;
	self.can_explode = 0;
	self.exploded = 0;
	self thread quad_trail();
	self AllowPitchAngle(1);
	self setPhysParams(15, 0, 24);
	if(isdefined(level.quad_prespawn))
	{
		self thread [[level.quad_prespawn]]();
	}
}

/*
	Name: init_quad_zombie_fx
	Namespace: zm_ai_quad
	Checksum: 0xAD7BAFB5
	Offset: 0xB30
	Size: 0x39
	Parameters: 0
	Flags: None
*/
function init_quad_zombie_fx()
{
	level._effect["quad_explo_gas"] = "dlc5/zmhd/fx_zombie_quad_gas_nova6";
	level._effect["quad_trail"] = "dlc5/zmhd/fx_zombie_quad_trail";
}

/*
	Name: quad_location
	Namespace: zm_ai_quad
	Checksum: 0x366D89E1
	Offset: 0xB78
	Size: 0x335
	Parameters: 0
	Flags: None
*/
function quad_location()
{
	self endon("death");
	if(level.zm_loc_types["quad_location"].size <= 0)
	{
		/#
			println("Dev Block strings are not supported" + "Dev Block strings are not supported");
		#/
		self DoDamage(self.health * 2, self.origin);
		return;
	}
	spot = Array::random(level.zm_loc_types["quad_location"]);
	if(isdefined(spot.target))
	{
		self.target = spot.target;
	}
	if(isdefined(spot.zone_name))
	{
		self.zone_name = spot.zone_name;
	}
	self.anchor = spawn("script_origin", self.origin);
	self.anchor.angles = self.angles;
	self LinkTo(self.anchor);
	if(!isdefined(spot.angles))
	{
		spot.angles = (0, 0, 0);
	}
	self ghost();
	self.anchor moveto(spot.origin, 0.05);
	self.anchor waittill("movedone");
	target_org = zombie_utility::get_desired_origin();
	if(isdefined(target_org))
	{
		anim_ang = VectorToAngles(target_org - self.origin);
		self.anchor RotateTo((0, anim_ang[1], 0), 0.05);
		self.anchor waittill("rotatedone");
	}
	if(isdefined(level.zombie_spawn_fx))
	{
		playFX(level.zombie_spawn_fx, spot.origin);
	}
	self Unlink();
	if(isdefined(self.anchor))
	{
		self.anchor delete();
	}
	self show();
	self notify("risen", spot.script_string);
}

/*
	Name: quad_vox
	Namespace: zm_ai_quad
	Checksum: 0x99B0FF0D
	Offset: 0xEB8
	Size: 0x197
	Parameters: 0
	Flags: None
*/
function quad_vox()
{
	self endon("death");
	wait(5);
	quad_wait = 5;
	while(1)
	{
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			if(DistanceSquared(self.origin, players[i].origin) > 1440000)
			{
				self playsound("zmb_quad_amb");
				quad_wait = 7;
				continue;
			}
			if(DistanceSquared(self.origin, players[i].origin) > 40000)
			{
				self playsound("zmb_quad_vox");
				quad_wait = 5;
				continue;
			}
			if(DistanceSquared(self.origin, players[i].origin) < 22500)
			{
				wait(0.05);
			}
		}
		wait(RandomFloatRange(1, quad_wait));
	}
}

/*
	Name: set_default_attack_properties
	Namespace: zm_ai_quad
	Checksum: 0x3409B8D1
	Offset: 0x1058
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function set_default_attack_properties()
{
	self.goalRadius = 16;
	self.maxsightdistsqrd = 16384;
	self.can_leap = 0;
}

/*
	Name: quad_thundergun_knockdown
	Namespace: zm_ai_quad
	Checksum: 0xDDC8CB63
	Offset: 0x1088
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function quad_thundergun_knockdown(player, gib)
{
	self endon("death");
	damage = Int(self.maxhealth * 0.5);
	self DoDamage(damage, player.origin, player);
}

/*
	Name: quad_gas_explo_death
	Namespace: zm_ai_quad
	Checksum: 0x6F143A93
	Offset: 0x1110
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function quad_gas_explo_death()
{
	death_vars = [];
	death_vars["explo_radius_zomb"] = self.death_explo_radius_zomb;
	death_vars["explo_radius_plr"] = self.death_explo_radius_plr;
	death_vars["explo_damage_zomb"] = self.death_explo_damage_zomb;
	death_vars["gas_radius"] = self.death_gas_radius;
	death_vars["gas_time"] = self.death_gas_time;
	self thread quad_death_explo(self.origin, death_vars);
	level thread quad_gas_area_of_effect(self.origin, death_vars);
}

/*
	Name: quad_death_explo
	Namespace: zm_ai_quad
	Checksum: 0x1468F5B0
	Offset: 0x11E8
	Size: 0x19B
	Parameters: 2
	Flags: None
*/
function quad_death_explo(origin, death_vars)
{
	playsoundatposition("zmb_quad_explo", origin);
	players = GetPlayers();
	zombies = GetAITeamArray(level.zombie_team);
	for(i = 0; i < players.size; i++)
	{
		if(Distance(origin, players[i].origin) <= death_vars["explo_radius_plr"])
		{
			is_immune = 0;
			if(isdefined(level.quad_gas_immune_func))
			{
				is_immune = players[i] thread [[level.quad_gas_immune_func]]();
			}
			if(!is_immune)
			{
				players[i] shellshock("explosion", 2.5);
			}
		}
	}
	self.exploded = 1;
	self RadiusDamage(origin, death_vars["explo_radius_zomb"], level.zombie_health, level.zombie_health, self, "MOD_EXPLOSIVE");
}

/*
	Name: quad_damage_func
	Namespace: zm_ai_quad
	Checksum: 0x9BA90994
	Offset: 0x1390
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function quad_damage_func(player)
{
	if(self.exploded)
	{
		return 0;
	}
	return self.meleeDamage;
}

/*
	Name: quad_gas_area_of_effect
	Namespace: zm_ai_quad
	Checksum: 0x8C2511E6
	Offset: 0x13C0
	Size: 0x243
	Parameters: 2
	Flags: None
*/
function quad_gas_area_of_effect(origin, death_vars)
{
	effectArea = spawn("trigger_radius", origin, 0, death_vars["gas_radius"], 100);
	playFX(level._effect["quad_explo_gas"], origin);
	for(gas_time = 0; gas_time <= death_vars["gas_time"];  = 0)
	{
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			is_immune = 0;
			if(isdefined(level.quad_gas_immune_func))
			{
				is_immune = players[i] thread [[level.quad_gas_immune_func]]();
			}
			if(players[i] istouching(effectArea) && !is_immune)
			{
				visionset_mgr::activate("overlay", "zm_ai_quad_blur", players[i]);
				continue;
			}
			visionset_mgr::deactivate("overlay", "zm_ai_quad_blur", players[i]);
		}
		wait(1);
	}
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		visionset_mgr::deactivate("overlay", "zm_ai_quad_blur", players[i]);
	}
	effectArea delete();
}

/*
	Name: quad_trail
	Namespace: zm_ai_quad
	Checksum: 0xC0A3626C
	Offset: 0x1610
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function quad_trail()
{
	self endon("death");
	self.fx_quad_trail = spawn("script_model", self GetTagOrigin("tag_origin"));
	self.fx_quad_trail.angles = self GetTagAngles("tag_origin");
	self.fx_quad_trail SetModel("tag_origin");
	self.fx_quad_trail LinkTo(self, "tag_origin");
	zm_net::network_safe_play_fx_on_tag("quad_fx", 2, level._effect["quad_trail"], self.fx_quad_trail, "tag_origin");
}

/*
	Name: quad_post_death
	Namespace: zm_ai_quad
	Checksum: 0xCFD9B922
	Offset: 0x1718
	Size: 0x5D
	Parameters: 8
	Flags: None
*/
function quad_post_death(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime)
{
	self zm_spawner::zombie_death_animscript();
	return 0;
}

/*
	Name: quad_killed_override
	Namespace: zm_ai_quad
	Checksum: 0x49A9A4FF
	Offset: 0x1780
	Size: 0xD7
	Parameters: 8
	Flags: None
*/
function quad_killed_override(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime)
{
	if(sMeansOfDeath == "MOD_PISTOL_BULLET" || sMeansOfDeath == "MOD_RIFLE_BULLET")
	{
		self.can_explode = 1;
	}
	else
	{
		self.can_explode = 0;
		if(isdefined(self.fx_quad_trail))
		{
			self.fx_quad_trail Unlink();
			self.fx_quad_trail delete();
		}
	}
	if(isdefined(level._override_quad_explosion))
	{
		[[level._override_quad_explosion]](self);
	}
}

/*
	Name: quad_pre_teleport
	Namespace: zm_ai_quad
	Checksum: 0xC4B0FA72
	Offset: 0x1860
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function quad_pre_teleport()
{
	if(isdefined(self.fx_quad_trail))
	{
		self.fx_quad_trail Unlink();
		self.fx_quad_trail delete();
		wait(0.1);
	}
}

/*
	Name: quad_post_teleport
	Namespace: zm_ai_quad
	Checksum: 0x4E397D9C
	Offset: 0x18B8
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function quad_post_teleport()
{
	if(isdefined(self.fx_quad_trail))
	{
		self.fx_quad_trail Unlink();
		self.fx_quad_trail delete();
	}
	if(self.health > 0)
	{
		self.fx_quad_trail = spawn("script_model", self GetTagOrigin("tag_origin"));
		self.fx_quad_trail.angles = self GetTagAngles("tag_origin");
		self.fx_quad_trail SetModel("tag_origin");
		self.fx_quad_trail LinkTo(self, "tag_origin");
		zm_net::network_safe_play_fx_on_tag("quad_fx", 2, level._effect["quad_trail"], self.fx_quad_trail, "tag_origin");
	}
}

