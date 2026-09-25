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

#namespace namespace_1d58b607;

/*
	Name: __init__sytem__
	Namespace: namespace_1d58b607
	Checksum: 0xE64DEC0E
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
	Namespace: namespace_1d58b607
	Checksum: 0x3D4BC3EA
	Offset: 0x530
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	function_820fd039();
	if(!isdefined(level.var_b93acc0b) || level.var_b93acc0b)
	{
		function_1bf67b57();
	}
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("quad_melee", &function_b783ed6b);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("quadDeathAction", &function_ec996060);
	level thread AAT::register_immunity("zm_aat_dead_wire", "zombie_quad", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_turned", "zombie_quad", 1, 1, 1);
}

/*
	Name: function_b783ed6b
	Namespace: namespace_1d58b607
	Checksum: 0xDAFB50FD
	Offset: 0x630
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function function_b783ed6b(entity)
{
	entity melee();
	/#
		Record3DText("Dev Block strings are not supported", self.origin, (1, 0, 0), "Dev Block strings are not supported", entity);
	#/
}

/*
	Name: function_ec996060
	Namespace: namespace_1d58b607
	Checksum: 0x588EBF6
	Offset: 0x698
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function function_ec996060(entity)
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
	Name: function_5af423f4
	Namespace: namespace_1d58b607
	Checksum: 0xD9023778
	Offset: 0x768
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function function_5af423f4()
{
	level.quad_spawners = GetEntArray("quad_zombie_spawner", "script_noteworthy");
	Array::thread_all(level.quad_spawners, &spawner::add_spawn_function, &quad_prespawn);
	zm::register_custom_ai_spawn_check("quads", &function_613fce7d, &function_da243141);
}

/*
	Name: function_1bf67b57
	Namespace: namespace_1d58b607
	Checksum: 0x45139164
	Offset: 0x810
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_1bf67b57()
{
	if(!isdefined(level.var_2ac737b1))
	{
		level.var_2ac737b1 = 50;
	}
	visionset_mgr::register_info("overlay", "zm_ai_quad_blur", 1, level.var_2ac737b1, 1, 1);
}

/*
	Name: function_613fce7d
	Namespace: namespace_1d58b607
	Checksum: 0xFA5FE795
	Offset: 0x870
	Size: 0x31
	Parameters: 0
	Flags: None
*/
function function_613fce7d()
{
	return isdefined(level.zm_loc_types["quad_location"]) && level.zm_loc_types["quad_location"].size > 0;
}

/*
	Name: function_da243141
	Namespace: namespace_1d58b607
	Checksum: 0x6ADB06AC
	Offset: 0x8B0
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function function_da243141()
{
	return level.quad_spawners;
}

/*
	Name: quad_prespawn
	Namespace: namespace_1d58b607
	Checksum: 0x4DA88EC0
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
	self.custom_location = &function_cd79a62a;
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
	Name: function_820fd039
	Namespace: namespace_1d58b607
	Checksum: 0xE5F56071
	Offset: 0xB30
	Size: 0x39
	Parameters: 0
	Flags: None
*/
function function_820fd039()
{
	level._effect["quad_explo_gas"] = "dlc5/zmhd/fx_zombie_quad_gas_nova6";
	level._effect["quad_trail"] = "dlc5/zmhd/fx_zombie_quad_trail";
}

/*
	Name: function_cd79a62a
	Namespace: namespace_1d58b607
	Checksum: 0x3D05CF78
	Offset: 0xB78
	Size: 0x335
	Parameters: 0
	Flags: None
*/
function function_cd79a62a()
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
	Namespace: namespace_1d58b607
	Checksum: 0x70E76A59
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
	Namespace: namespace_1d58b607
	Checksum: 0xAB57569C
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
	Namespace: namespace_1d58b607
	Checksum: 0xAB1980F4
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
	Namespace: namespace_1d58b607
	Checksum: 0x4630384C
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
	Namespace: namespace_1d58b607
	Checksum: 0x3D2B81F6
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
	Namespace: namespace_1d58b607
	Checksum: 0x474C6499
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
	Namespace: namespace_1d58b607
	Checksum: 0xE88D1DE1
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
	Namespace: namespace_1d58b607
	Checksum: 0xCC35AACD
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
	Namespace: namespace_1d58b607
	Checksum: 0xA584D0BE
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
	Namespace: namespace_1d58b607
	Checksum: 0xB90AD64C
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
	Namespace: namespace_1d58b607
	Checksum: 0x8FC7CD75
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
	Namespace: namespace_1d58b607
	Checksum: 0x6C1829B4
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

