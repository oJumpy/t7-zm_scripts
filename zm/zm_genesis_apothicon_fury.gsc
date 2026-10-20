#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\archetype_apothicon_fury;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#namespace zm_genesis_apothicon_fury;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_apothicon_fury
	Checksum: 0xFB65AF02
	Offset: 0x5F8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_apothicon_fury", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_apothicon_fury
	Checksum: 0x31D89297
	Offset: 0x638
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	spawner::add_archetype_spawn_function("apothicon_fury", &function_2c871f46);
	spawner::add_archetype_spawn_function("apothicon_fury", &function_e5e94978);
	spawner::add_archetype_spawn_function("apothicon_fury", &function_1dcdd145);
	if(ai::shouldRegisterClientFieldForArchetype("apothicon_fury"))
	{
		clientfield::register("scriptmover", "apothicon_fury_spawn_meteor", 15000, 2, "int");
	}
	/#
		execdevgui("Dev Block strings are not supported");
		level thread function_bc2e7a98();
	#/
}

/*
	Name: function_51dd865c
	Namespace: zm_genesis_apothicon_fury
	Checksum: 0x95908DFB
	Offset: 0x740
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_51dd865c()
{
	level thread AAT::register_immunity("zm_aat_turned", "apothicon_fury", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_thunder_wall", "apothicon_fury", 1, 1, 1);
}

/*
	Name: function_d7808406
	Namespace: zm_genesis_apothicon_fury
	Checksum: 0x28527A94
	Offset: 0x7B0
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_d7808406()
{
	self waittill("death", e_attacker);
	if(isdefined(e_attacker) && isdefined(e_attacker.var_4d307aef))
	{
		e_attacker.var_4d307aef++;
	}
	if(isdefined(e_attacker) && isdefined(e_attacker.var_8b5008fe))
	{
		e_attacker.var_8b5008fe++;
	}
}

/*
	Name: function_21bbe70d
	Namespace: zm_genesis_apothicon_fury
	Checksum: 0x77605070
	Offset: 0x830
	Size: 0x207
	Parameters: 3
	Flags: None
*/
function function_21bbe70d(v_origin, v_angles, var_8d71b2b8)
{
	e_boss = SpawnActor("spawner_zm_genesis_apothicon_fury", v_origin, v_angles, undefined, 1, 1);
	if(isdefined(e_boss))
	{
		e_boss endon("death");
		e_boss.spawn_time = GetTime();
		e_boss.var_1cba9ac3 = 1;
		e_boss.heroweapon_kill_power = 2;
		e_boss.completed_emerging_into_playable_area = 1;
		e_boss thread function_d7808406();
		e_boss thread zm::update_zone_name();
		level thread zm_spawner::zombie_death_event(e_boss);
		e_boss thread zm_spawner::enemy_death_detection();
		e_boss thread function_7ba80ea7();
		e_boss thread function_1be68e3f();
		e_boss.voicePrefix = "fury";
		e_boss.animName = "fury";
		e_boss thread zm_spawner::play_ambient_zombie_vocals();
		e_boss thread zm_audio::zmbAIVox_NotifyConvert();
		e_boss playsound("zmb_vocals_fury_spawn");
		/#
			e_boss thread function_ab27e73a();
		#/
		if(isdefined(var_8d71b2b8) && var_8d71b2b8)
		{
			wait(1);
			e_boss.zombie_think_done = 1;
		}
		return e_boss;
	}
	return undefined;
}

/*
	Name: function_7ba80ea7
	Namespace: zm_genesis_apothicon_fury
	Checksum: 0x6D3572C1
	Offset: 0xA40
	Size: 0x123
	Parameters: 0
	Flags: Private
*/
function private function_7ba80ea7()
{
	self.is_zombie = 1;
	zombiehealth = level.zombie_health;
	if(!isdefined(zombiehealth))
	{
		zombiehealth = level.zombie_vars["zombie_health_start"];
	}
	if(level.round_number <= 20)
	{
		self.maxhealth = zombiehealth * 1.2;
	}
	else if(level.round_number <= 50)
	{
		self.maxhealth = zombiehealth * 1.5;
	}
	else
	{
		self.maxhealth = zombiehealth * 1.7;
	}
	if(!isdefined(self.maxhealth) || self.maxhealth <= 0 || self.maxhealth > 2147483647 || self.maxhealth != self.maxhealth)
	{
		self.maxhealth = zombiehealth;
	}
	self.health = Int(self.maxhealth);
}

/*
	Name: function_1be68e3f
	Namespace: zm_genesis_apothicon_fury
	Checksum: 0x5408839C
	Offset: 0xB70
	Size: 0xB7
	Parameters: 0
	Flags: Private
*/
function private function_1be68e3f()
{
	self endon("death");
	while(1)
	{
		if(isdefined(self.zone_name))
		{
			if(self.zone_name == "dark_arena_zone" || self.zone_name == "dark_arena2_zone")
			{
				if(!IsPointOnNavMesh(self.origin))
				{
					point = GetClosestPointOnNavMesh(self.origin, 256, 30);
					self ForceTeleport(point);
				}
			}
		}
		wait(0.25);
	}
}

/*
	Name: function_ab27e73a
	Namespace: zm_genesis_apothicon_fury
	Checksum: 0x97E79D02
	Offset: 0xC30
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function function_ab27e73a()
{
	self endon("death");
	if(isdefined(level.var_31c836af) && level.var_31c836af > 0)
	{
		self.health = level.var_31c836af;
	}
	while(1)
	{
		if(isdefined(level.var_2db0d4e8) && level.var_2db0d4e8)
		{
			/#
				print3d(self.origin, "Dev Block strings are not supported" + self.health, (0, 0, 1), 1.2);
			#/
		}
		wait(0.05);
	}
}

/*
	Name: function_16beb600
	Namespace: zm_genesis_apothicon_fury
	Checksum: 0xA0DC8D7A
	Offset: 0xCD8
	Size: 0xA7
	Parameters: 6
	Flags: None
*/
function function_16beb600(var_8cc26a7f, var_7ab4c34a, var_535f5919, var_13d4cd83, var_3988ba7b, var_8d71b2b8)
{
	if(!isdefined(var_8d71b2b8))
	{
		var_8d71b2b8 = 0;
	}
	function_b55fb314(var_8cc26a7f, var_7ab4c34a, var_535f5919, var_13d4cd83, var_3988ba7b);
	var_165d8ccd = function_21bbe70d(var_13d4cd83, var_3988ba7b, var_8d71b2b8);
	if(isdefined(var_165d8ccd))
	{
		return var_165d8ccd;
	}
}

/*
	Name: function_b55fb314
	Namespace: zm_genesis_apothicon_fury
	Checksum: 0x8CA681E2
	Offset: 0xD88
	Size: 0x493
	Parameters: 5
	Flags: None
*/
function function_b55fb314(var_8cc26a7f, var_7ab4c34a, var_535f5919, var_13d4cd83, var_3988ba7b)
{
	var_7ae4bfa0 = var_535f5919;
	var_8a1358c0 = var_7ab4c34a[2] + var_7ae4bfa0 - var_13d4cd83[2];
	var_dfcea895 = (var_13d4cd83[0] - var_7ab4c34a[0], var_13d4cd83[1] - var_7ab4c34a[1], 0);
	var_30280c29 = var_7ab4c34a + var_dfcea895 * 0.5 + (0, 0, var_535f5919);
	var_be9b92b3 = spawn("script_model", var_7ab4c34a);
	var_be9b92b3 SetModel("tag_origin");
	var_be9b92b3 clientfield::set("apothicon_fury_spawn_meteor", 1);
	var_22077f2a = var_7ab4c34a + (0, 0, var_7ae4bfa0 * 0.5);
	var_be9b92b3.angles = VectorToAngles(var_22077f2a - var_be9b92b3.origin);
	var_be9b92b3 moveto(var_22077f2a, var_8cc26a7f / 6);
	var_be9b92b3 waittill("movedone");
	var_22077f2a = var_be9b92b3.origin + (0, 0, var_7ae4bfa0 * 0.25) + var_dfcea895 * 0.25;
	var_be9b92b3.angles = VectorToAngles(var_22077f2a - var_be9b92b3.origin);
	var_be9b92b3 moveto(var_22077f2a, var_8cc26a7f / 6);
	var_be9b92b3 waittill("movedone");
	var_22077f2a = var_30280c29;
	var_be9b92b3.angles = VectorToAngles(var_22077f2a - var_be9b92b3.origin);
	var_be9b92b3 moveto(var_30280c29, var_8cc26a7f / 6);
	var_be9b92b3 waittill("movedone");
	var_22077f2a = var_be9b92b3.origin - (0, 0, var_8a1358c0 * 0.25) + var_dfcea895 * 0.25;
	var_be9b92b3.angles = VectorToAngles(var_22077f2a - var_be9b92b3.origin);
	var_be9b92b3 moveto(var_22077f2a, var_8cc26a7f / 6);
	var_be9b92b3 waittill("movedone");
	var_22077f2a = var_13d4cd83 - (0, 0, var_8a1358c0 * 0.5);
	var_be9b92b3.angles = VectorToAngles(var_22077f2a - var_be9b92b3.origin);
	var_be9b92b3 moveto(var_22077f2a, var_8cc26a7f / 6);
	var_be9b92b3 waittill("movedone");
	var_22077f2a = var_13d4cd83;
	var_be9b92b3.angles = VectorToAngles(var_22077f2a - var_be9b92b3.origin);
	var_be9b92b3 moveto(var_13d4cd83, var_8cc26a7f / 6);
	var_be9b92b3 waittill("movedone");
	var_be9b92b3 clientfield::set("apothicon_fury_spawn_meteor", 2);
	var_be9b92b3 delete();
}

/*
	Name: function_2c871f46
	Namespace: zm_genesis_apothicon_fury
	Checksum: 0x38900F55
	Offset: 0x1228
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function function_2c871f46()
{
	self AAT::aat_cooldown_init();
}

/*
	Name: function_e5e94978
	Namespace: zm_genesis_apothicon_fury
	Checksum: 0x7858AADF
	Offset: 0x1250
	Size: 0x117
	Parameters: 0
	Flags: None
*/
function function_e5e94978()
{
	self endon("death");
	while(isalive(self))
	{
		self waittill("damage");
		if(isPlayer(self.attacker))
		{
			if(zm_spawner::player_using_hi_score_weapon(self.attacker))
			{
				str_notify = "damage";
			}
			else
			{
				str_notify = "damage_light";
			}
			if(!(isdefined(self.deathpoints_already_given) && self.deathpoints_already_given))
			{
				self.attacker zm_score::player_add_points(str_notify, self.damageMod, self.damagelocation, undefined, self.team, self.damageWeapon);
			}
			if(isdefined(level.hero_power_update))
			{
				[[level.hero_power_update]](self.attacker, self);
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_1dcdd145
	Namespace: zm_genesis_apothicon_fury
	Checksum: 0x3E2C8AF1
	Offset: 0x1370
	Size: 0xA7
	Parameters: 0
	Flags: None
*/
function function_1dcdd145()
{
	self waittill("death");
	if(isPlayer(self.attacker))
	{
		if(!(isdefined(self.deathpoints_already_given) && self.deathpoints_already_given))
		{
			self.attacker zm_score::player_add_points("death", self.damageMod, self.damagelocation, undefined, self.team, self.damageWeapon);
		}
		if(isdefined(level.hero_power_update))
		{
			[[level.hero_power_update]](self.attacker, self);
		}
	}
}

/*
	Name: function_bc2e7a98
	Namespace: zm_genesis_apothicon_fury
	Checksum: 0xFA5D2DC8
	Offset: 0x1420
	Size: 0x43
	Parameters: 0
	Flags: Private
*/
function private function_bc2e7a98()
{
	/#
		level flagsys::wait_till("Dev Block strings are not supported");
		zm_devgui::add_custom_devgui_callback(&function_744725d0);
	#/
}

/*
	Name: function_744725d0
	Namespace: zm_genesis_apothicon_fury
	Checksum: 0xE7339969
	Offset: 0x1470
	Size: 0x6C5
	Parameters: 1
	Flags: Private
*/
function private function_744725d0(cmd)
{
	if(cmd == "apothicon_fury_spawn")
	{
		queryResult = PositionQuery_Source_Navigation(level.players[0].origin, 128, 256, 128, 20);
		if(isdefined(queryResult) && queryResult.data.size > 0)
		{
			origin = queryResult.data[0].origin;
			angles = level.players[0].angles;
			level thread function_21bbe70d(origin, angles, 1);
		}
	}
	else if(cmd == "apothicon_fury_walk")
	{
		ais = GetAIArchetypeArray("apothicon_fury");
		foreach(ai in ais)
		{
			ai ai::set_behavior_attribute("move_speed", "walk");
		}
	}
	else if(cmd == "apothicon_fury_sprint")
	{
		ais = GetAIArchetypeArray("apothicon_fury");
		foreach(ai in ais)
		{
			ai ai::set_behavior_attribute("move_speed", "sprint");
		}
	}
	else if(cmd == "apothicon_fury_run")
	{
		ais = GetAIArchetypeArray("apothicon_fury");
		foreach(ai in ais)
		{
			ai ai::set_behavior_attribute("move_speed", "run");
		}
	}
	else if(cmd == "apothicon_fury_disable_bamf")
	{
		ais = GetAIArchetypeArray("apothicon_fury");
		foreach(ai in ais)
		{
			ai ai::set_behavior_attribute("can_bamf", 0);
			ai ai::set_behavior_attribute("can_juke", 0);
		}
	}
	else if(cmd == "apothicon_fury_force_furious")
	{
		ais = GetAIArchetypeArray("apothicon_fury");
		foreach(ai in ais)
		{
			if(!(isdefined(ai.isFurious) && ai.isFurious))
			{
				apothiconFuryBehavior::apothiconFuriousModeInit(ai);
			}
		}
	}
	else if(cmd == "apothicon_fury_debug_health")
	{
		if(isdefined(level.var_2db0d4e8) && level.var_2db0d4e8)
		{
			level.var_2db0d4e8 = 0;
		}
		else
		{
			level.var_2db0d4e8 = 1;
		}
	}
	if(GetDvarInt("zombie_apothicon_health") > 0)
	{
		level.var_31c836af = GetDvarInt("zombie_apothicon_health");
	}
	else
	{
		level.var_31c836af = 0;
	}
	if(GetDvarInt("zombie_apothicon_juke_min") > 0)
	{
		level.nextjukeMeleeTimeMin = GetDvarFloat("zombie_apothicon_juke_min") * 1000;
	}
	else
	{
		level.nextjukeMeleeTimeMin = undefined;
	}
	if(GetDvarInt("zombie_apothicon_juke_max") > 0)
	{
		level.nextjukeMeleeTimeMax = GetDvarFloat("zombie_apothicon_juke_max") * 1000;
	}
	else
	{
		level.nextjukeMeleeTimeMax = undefined;
	}
	if(GetDvarInt("zombie_apothicon_bamf_min") > 0)
	{
		level.nextBamfMeleeTimeMin = GetDvarFloat("zombie_apothicon_bamf_min") * 1000;
	}
	else
	{
		level.nextBamfMeleeTimeMin = undefined;
	}
	if(GetDvarInt("zombie_apothicon_bamf_max") > 0)
	{
		level.nextBamfMeleeTimeMax = GetDvarFloat("zombie_apothicon_bamf_max") * 1000;
	}
	else
	{
		level.nextBamfMeleeTimeMax = undefined;
	}
}

