#using scripts\codescripts\struct;
#using scripts\shared\_oob;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace ball;

/*
	Name: __init__sytem__
	Namespace: ball
	Checksum: 0x3CFCEC76
	Offset: 0x880
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ball", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: ball
	Checksum: 0x8886B071
	Offset: 0x8C8
	Size: 0x1D3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("allplayers", "ballcarrier", 15000, 1, "int");
	clientfield::register("allplayers", "passoption", 15000, 1, "int");
	clientfield::register("world", "ball_away", 15000, 1, "int");
	clientfield::register("world", "ball_score_allies", 15000, 1, "int");
	clientfield::register("world", "ball_score_axis", 15000, 1, "int");
	clientfield::register("scriptmover", "ball_on_ground_fx", 15000, 1, "int");
	level.ballWeapon = GetWeapon("ball");
	level.ballworldweapon = GetWeapon("ball_world");
	level.passingballweapon = GetWeapon("ball_world_pass");
	level._grab_minigun = &ball_grab_minigun;
	zm_hero_weapon::register_hero_weapon("ball");
	zm::register_zombie_damage_override_callback(&ball_zombie_damage_response);
}

/*
	Name: ball_grab_minigun
	Namespace: ball
	Checksum: 0xA3E3BEB3
	Offset: 0xAA8
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function ball_grab_minigun(player)
{
	player function_257ed160(player, 0);
}

/*
	Name: function_797c5146
	Namespace: ball
	Checksum: 0x7FFD82EA
	Offset: 0xAE0
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function function_797c5146(weapon)
{
	return weapon == level.ballworldweapon;
}

/*
	Name: function_3652dc9c
	Namespace: ball
	Checksum: 0x6EC218AD
	Offset: 0xB00
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function function_3652dc9c(weapon)
{
	return weapon == level.ballWeapon;
}

/*
	Name: function_c004c2bd
	Namespace: ball
	Checksum: 0xC43D0C8B
	Offset: 0xB20
	Size: 0x31D
	Parameters: 0
	Flags: None
*/
function function_c004c2bd()
{
	playFX("dlc4/genesis/fx_weapon_key_throw_impact", self.origin);
	playsoundatposition("wpn_summoning_key_impact", self.origin);
	zombies = Array::get_all_closest(self.origin, GetAITeamArray(level.zombie_team), undefined, undefined, 150);
	if(!isdefined(zombies))
	{
		return;
	}
	dist_sq = 150 * 150;
	zombies_burned_out = [];
	for(i = 0; i < zombies.size; i++)
	{
		if(isdefined(zombies[i].ignore_nuke) && zombies[i].ignore_nuke)
		{
			continue;
		}
		if(isdefined(zombies[i].marked_for_death) && zombies[i].marked_for_death)
		{
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(zombies[i]))
		{
			continue;
		}
		zombies[i].marked_for_death = 1;
		if(isVehicle(zombies[i]))
		{
			zombies[i] clientfield::increment("zm_bgb_burned_out" + "_fire_torso" + "_vehicle");
		}
		else
		{
			zombies[i] clientfield::increment("zm_bgb_burned_out" + "_fire_torso" + "_actor");
		}
		zombies_burned_out[zombies_burned_out.size] = zombies[i];
	}
	for(i = 0; i < zombies_burned_out.size; i++)
	{
		util::wait_network_frame();
		if(!isdefined(zombies_burned_out[i]))
		{
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(zombies_burned_out[i]))
		{
			continue;
		}
		if(!(isdefined(zombies_burned_out[i].exclude_cleanup_adding_to_total) && zombies_burned_out[i].exclude_cleanup_adding_to_total))
		{
			level.zombie_total++;
		}
		zombies_burned_out[i] DoDamage(zombies_burned_out[i].health + 666, zombies_burned_out[i].origin);
	}
}

/*
	Name: ball_zombie_damage_response
	Namespace: ball
	Checksum: 0xF42EFBAB
	Offset: 0xE48
	Size: 0x1F3
	Parameters: 13
	Flags: None
*/
function ball_zombie_damage_response(willBeKilled, inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if(function_797c5146(weapon) && isdefined(self.var_c732138b))
	{
		return self [[self.var_c732138b]]();
	}
	if(self.archetype === "mechz" || self.archetype === "margwa")
	{
		return 0;
	}
	if(self function_797c5146(weapon))
	{
		launchvector = VectorScale(vDir, 0.1);
		self thread zm_spawner::zombie_ragdoll_then_explode(launchvector, attacker);
		self thread function_c004c2bd();
		PlayFXOnTag("dlc4/genesis/fx_weapon_key_impact_fire_torso_zmb", self, "j_spine4");
		return 1;
	}
	else if(self function_3652dc9c(weapon))
	{
		if(!(isdefined(self.exclude_cleanup_adding_to_total) && self.exclude_cleanup_adding_to_total))
		{
			level.zombie_total++;
		}
		PlayFXOnTag("dlc4/genesis/fx_weapon_key_impact_fire_torso_zmb", self, "j_spine4");
		self DoDamage(self.health + 666, self.origin);
		return 1;
	}
	return 0;
}

/*
	Name: __main__
	Namespace: ball
	Checksum: 0x615AD18
	Offset: 0x1048
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function __main__()
{
	callback::on_connect(&function_cffd1019);
	level.ball_start = undefined;
	level.ball = undefined;
	level.objectivePingDelay = 1;
}

/*
	Name: function_cffd1019
	Namespace: ball
	Checksum: 0xF3BD672C
	Offset: 0x1098
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_cffd1019()
{
	self flag::init("has_ball");
	self thread carry_think_ball();
}

/*
	Name: carry_think_ball
	Namespace: ball
	Checksum: 0x330A59F0
	Offset: 0x10E0
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function carry_think_ball()
{
	self endon("disconnect");
	self flag::wait_till("has_ball");
	self thread ball_pass_watch();
	self thread ball_shoot_watch();
	self thread ball_weapon_change_watch();
}

/*
	Name: anyballsintheair
	Namespace: ball
	Checksum: 0x819A5384
	Offset: 0x1160
	Size: 0x69
	Parameters: 0
	Flags: None
*/
function anyballsintheair()
{
	if(isdefined(level.ball))
	{
		if(isdefined(level.ball.carrier))
		{
			return;
		}
		if(isdefined(level.ball.projectile))
		{
			if(!level.ball.projectile IsOnGround())
			{
				return level.ball;
			}
		}
	}
	return;
}

/*
	Name: waitforballtocometorest
	Namespace: ball
	Checksum: 0x11FF7059
	Offset: 0x11D8
	Size: 0x89
	Parameters: 0
	Flags: None
*/
function waitforballtocometorest()
{
	self endon("reset");
	self endon("pickup_object");
	if(isdefined(self.projectile))
	{
		if(self.projectile IsOnGround())
		{
			return;
		}
		self.projectile endon("death");
		self.projectile endon("stationary");
		self.projectile endon("grenade_bounce");
		while(1)
		{
			wait(1);
		}
	}
}

/*
	Name: freezeplayersforroundend
	Namespace: ball
	Checksum: 0xD17CCA66
	Offset: 0x1270
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function freezeplayersforroundend()
{
	self endon("disconnect");
	self waittill("spawned");
}

/*
	Name: waitforallballstocometorest
	Namespace: ball
	Checksum: 0x4AE72B98
	Offset: 0x12A8
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function waitforallballstocometorest()
{
	ball = anyballsintheair();
	if(isdefined(ball))
	{
		level notify("game_ended");
		foreach(player in level.players)
		{
			player thread freezeplayersforroundend();
		}
		ball waitforballtocometorest();
	}
}

/*
	Name: ball_ontimelimit
	Namespace: ball
	Checksum: 0xE7221575
	Offset: 0x1390
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function ball_ontimelimit()
{
	waitforallballstocometorest();
}

/*
	Name: ballovertimeround2_ontimelimit
	Namespace: ball
	Checksum: 0xFA31EDE2
	Offset: 0x13B0
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function ballovertimeround2_ontimelimit()
{
	waitforallballstocometorest();
	winner = undefined;
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			if(game["teamSuddenDeath"][team])
			{
				winner = team;
				break;
			}
		}
	}
	else
	{
		if(isdefined(winner))
		{
			print("Dev Block strings are not supported" + winner.name);
		}
		else
		{
			print("Dev Block strings are not supported");
		}
	}
	/#
	#/
	SetDvar("ui_text_endreason", game["strings"]["time_limit_reached"]);
}

/*
	Name: onSpawnPlayer
	Namespace: ball
	Checksum: 0x133D2FCD
	Offset: 0x1518
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function onSpawnPlayer(predictedSpawn)
{
	self.isballcarrier = 0;
	self.ballcarried = undefined;
	self clientfield::set("ctf_flag_carrier", 0);
	self thread ballconsistencyswitchthread();
}

/*
	Name: ballconsistencyswitchthread
	Namespace: ball
	Checksum: 0x79F4010A
	Offset: 0x1580
	Size: 0x147
	Parameters: 0
	Flags: None
*/
function ballconsistencyswitchthread()
{
	self endon("death");
	self endon("delete");
	player = self;
	ball = GetWeapon("ball");
	while(1)
	{
		if(isdefined(ball) && player HasWeapon(ball))
		{
			curWeapon = player GetCurrentWeapon();
			if(isdefined(curWeapon) && curWeapon != ball)
			{
				if(curWeapon.isHeroWeapon)
				{
					slot = self GadgetGetSlot(curWeapon);
				}
				player SwitchToWeaponImmediate(ball);
				player DisableWeaponCycling();
				player disableOffhandWeapons();
			}
		}
		wait(0.05);
	}
}

/*
	Name: onPlayerKilled
	Namespace: ball
	Checksum: 0x687FB336
	Offset: 0x16D0
	Size: 0x1EF
	Parameters: 9
	Flags: None
*/
function onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	if(isdefined(self.carryObject))
	{
	}
	else
	{
	}
	if(isdefined(level.ball))
	{
		ballcarrier = level.ball.carrier;
		if(isdefined(ballcarrier))
		{
			ballorigin = level.ball.carrier.origin;
			isCarried = 1;
		}
		else
		{
			ballorigin = level.ball.curorigin;
			isCarried = 0;
		}
		if(isCarried && isdefined(attacker) && isdefined(attacker.team) && attacker != self && ballcarrier != attacker)
		{
			if(attacker.team == level.ball.carrier.team)
			{
				dist = Distance2DSquared(self.origin, ballorigin);
				if(dist < level.defaultOffenseRadiusSQ)
				{
					attacker AddPlayerStat("defend_carrier", 1);
				}
			}
		}
	}
	else
	{
		victim = self;
	}
	else
	{
	}
	else
	{
	}
	else
	{
	}
}

/*
	Name: get_real_ball_location
	Namespace: ball
	Checksum: 0x2B685EFC
	Offset: 0x18C8
	Size: 0x153
	Parameters: 6
	Flags: None
*/
function get_real_ball_location(startPos, startAngles, index, count, defaultDistance, rotation)
{
	currentAngle = startAngles[1] + 360 / count * 0.5 + 360 / count * index;
	cosCurrent = cos(currentAngle + rotation);
	sinCurrent = sin(currentAngle + rotation);
	new_position = startPos + (defaultDistance * cosCurrent, defaultDistance * sinCurrent, 0);
	clip_mask = 1 | 8;
	trace = PhysicsTrace(startPos, new_position, VectorScale((-1, -1, -1), 5), VectorScale((1, 1, 1), 5), self, clip_mask);
	return trace["position"];
}

/*
	Name: function_b4352e6c
	Namespace: ball
	Checksum: 0x69580572
	Offset: 0x1A28
	Size: 0x11B
	Parameters: 1
	Flags: None
*/
function function_b4352e6c(player)
{
	direction = player getPlayerAngles();
	direction_vec = AnglesToForward(direction);
	eye = player GetEye();
	scale = 8000;
	direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
	trace = bullettrace(eye, eye + direction_vec, 0, undefined);
	var_a1c100ee = trace["position"];
	function_4bff2a85(var_a1c100ee);
}

/*
	Name: function_7eb07bb0
	Namespace: ball
	Checksum: 0x9835A869
	Offset: 0x1B50
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function function_7eb07bb0(player)
{
	if(!isdefined(player) || !isdefined(player.carryObject))
	{
		return;
	}
	var_e870556 = player.carryObject;
	function_257ed160(player, 0);
	var_e870556 function_a41df27c();
}

/*
	Name: function_a41df27c
	Namespace: ball
	Checksum: 0x4BCCBDAB
	Offset: 0x1BD8
	Size: 0xF5
	Parameters: 0
	Flags: None
*/
function function_a41df27c()
{
	self notify("reset");
	visual = self.visuals[0];
	linkedparent = visual GetLinkedEnt();
	if(isdefined(linkedparent))
	{
		visual Unlink();
	}
	visual delete();
	if(isdefined(self.projectile))
	{
		self.projectile delete();
	}
	self gameobjects::allow_carry("none");
	level.ball_start delete();
	level.ball = undefined;
}

/*
	Name: give_player_ball
	Namespace: ball
	Checksum: 0xA72152B5
	Offset: 0x1CD8
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function give_player_ball(player)
{
	level.ball_start = spawn("trigger_radius", player.origin + (0, 0, 0), 2, 50, 50);
	level.ball = spawn_ball(level.ball_start);
}

/*
	Name: function_257ed160
	Namespace: ball
	Checksum: 0x8BF9CFFF
	Offset: 0x1D50
	Size: 0x20B
	Parameters: 2
	Flags: None
*/
function function_257ed160(player, should_upload)
{
	if(!isdefined(player) || !isdefined(player.carryObject))
	{
		return;
	}
	if(isdefined(player.carryObject.scorefrozenuntil) && player.carryObject.scorefrozenuntil > GetTime())
	{
		return;
	}
	player.carryObject.scorefrozenuntil = GetTime() + 10000;
	ball_check_assist(player, 1);
	team = self.team;
	otherTeam = util::getOtherTeam(team);
	if(isdefined(player.shoot_charge_bar))
	{
		player.shoot_charge_bar.inUse = 0;
	}
	ball = player.carryObject;
	ball.lastcarrierscored = 1;
	player gameobjects::take_carry_weapon(ball.carryWeapon);
	ball ball_set_dropped(1);
	if(should_upload)
	{
		ball thread upload_ball(self);
	}
	if(isdefined(player.pers["carries"]))
	{
		player.pers["carries"]++;
		player.carries = player.pers["carries"];
	}
	ball_give_score(otherTeam, level.carryscore);
}

/*
	Name: function_4bff2a85
	Namespace: ball
	Checksum: 0xB0D447AE
	Offset: 0x1F68
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function function_4bff2a85(v_pos)
{
	level.ball_start = spawn("trigger_radius", v_pos, 2, 50, 50);
	level.ball = spawn_ball(level.ball_start);
}

/*
	Name: setup_goal
	Namespace: ball
	Checksum: 0x20155A78
	Offset: 0x1FD0
	Size: 0x1BB
	Parameters: 2
	Flags: None
*/
function setup_goal(trigger, team)
{
	useObj = gameobjects::create_use_object(team, trigger, [], (0, 0, trigger.height * 0.5), istring("ball_goal_" + team));
	useObj gameobjects::set_visible_team("any");
	useObj gameobjects::set_model_visibility(1);
	useObj gameobjects::allow_use("enemy");
	useObj gameobjects::set_use_time(0);
	if(isdefined(level.ball))
	{
		useObj gameobjects::set_key_object(level.ball);
	}
	useObj.canuseobj = &f35_eject_enemies_fly_away;
	useObj.onUse = &on_use_goal;
	useObj.ball_in_goal = 0;
	useObj.radiusSq = trigger.radius * trigger.radius;
	useObj.center = trigger.origin + (0, 0, trigger.height * 0.5);
	return useObj;
}

/*
	Name: f35_eject_enemies_fly_away
	Namespace: ball
	Checksum: 0x975B8988
	Offset: 0x2198
	Size: 0x13
	Parameters: 1
	Flags: None
*/
function f35_eject_enemies_fly_away(player)
{
	return !self.ball_in_goal;
}

/*
	Name: on_use_goal
	Namespace: ball
	Checksum: 0xE9FBF82
	Offset: 0x21B8
	Size: 0x2CB
	Parameters: 1
	Flags: None
*/
function on_use_goal(player)
{
	if(!isdefined(player) || !isdefined(player.carryObject))
	{
		return;
	}
	if(isdefined(player.carryObject.scorefrozenuntil) && player.carryObject.scorefrozenuntil > GetTime())
	{
		return;
	}
	self play_goal_score_fx();
	player.carryObject.scorefrozenuntil = GetTime() + 10000;
	ball_check_assist(player, 1);
	team = self.team;
	otherTeam = util::getOtherTeam(team);
	if(isdefined(player.shoot_charge_bar))
	{
		player.shoot_charge_bar.inUse = 0;
	}
	ball = player.carryObject;
	ball.lastcarrierscored = 1;
	player gameobjects::take_carry_weapon(ball.carryWeapon);
	ball ball_set_dropped(1);
	ball thread upload_ball(self);
	if(isdefined(player.pers["carries"]))
	{
		player.pers["carries"]++;
		player.carries = player.pers["carries"];
	}
	bbPrint("mpobjective", "gametime %d objtype %s team %s playerx %d playery %d playerz %d", GetTime(), "ball_capture", team, player.origin);
	player RecordGameEvent("capture");
	player AddPlayerStatWithGameType("CARRIES", 1);
	player AddPlayerStatWithGameType("captures", 1);
	ball_give_score(otherTeam, level.carryscore);
}

/*
	Name: spawn_ball
	Namespace: ball
	Checksum: 0xA276A0D5
	Offset: 0x2490
	Size: 0x35F
	Parameters: 1
	Flags: None
*/
function spawn_ball(trigger)
{
	visuals = [];
	visuals[0] = spawn("script_model", trigger.origin);
	visuals[0] SetModel("wpn_t7_zmb_dlc4_summoning_key_world");
	visuals[0] notsolid();
	trigger EnableLinkTo();
	trigger LinkTo(visuals[0]);
	trigger.no_moving_platfrom_unlink = 1;
	ballobj = gameobjects::create_carry_object("neutral", trigger, visuals, (0, 0, 0), istring("ball_ball"), "mpl_hit_alert_ballholder");
	ballobj gameobjects::allow_carry("any");
	ballobj gameobjects::set_drop_offset(16);
	ballobj.objectiveOnVisuals = 1;
	ballobj.allowWeapons = 0;
	ballobj.carryWeapon = GetWeapon("ball");
	ballobj.keepcarryweapon = 1;
	ballobj.waterbadtrigger = 0;
	ballobj.disallowRemoteControl = 1;
	ballobj.disallowPlaceablePickup = 1;
	ballobj gameobjects::update_objective();
	ballobj.canUseObject = &can_use_ball;
	ballobj.onPickup = &on_pickup_ball;
	ballobj.setDropped = &ball_set_dropped;
	ballobj.onReset = &on_reset_ball;
	ballobj.pickupTimeoutOverride = &ball_physics_timeout;
	ballobj.carryWeaponThink = &carry_think_ball;
	ballobj.onUse = &function_756cbdda;
	ballobj.in_goal = 0;
	ballobj.lastcarrierscored = 0;
	ballobj.lastcarrierteam = "neutral";
	if(isdefined(level.idleFlagReturnTime) && level.idleFlagReturnTime > 0)
	{
		ballobj.autoResetTime = level.idleFlagReturnTime;
	}
	else
	{
		ballobj.autoResetTime = 15;
	}
	PlayFXOnTag("ui/fx_uplink_ball_trail", ballobj.visuals[0], "tag_origin");
	return ballobj;
}

/*
	Name: function_756cbdda
	Namespace: ball
	Checksum: 0x41B53A29
	Offset: 0x27F8
	Size: 0x24B
	Parameters: 1
	Flags: None
*/
function function_756cbdda(player)
{
	if(!isalive(player))
	{
		return;
	}
	while(!zm_laststand::laststand_has_players_weapons_returned(player))
	{
		wait(0.05);
	}
	if(self.type == "carryObject")
	{
		if(isdefined(player.carryObject))
		{
			if(isdefined(player.carryObject.swappable) && player.carryObject.swappable)
			{
				player.carryObject thread gameobjects::set_dropped();
			}
			else if(isdefined(self.onPickupFailed))
			{
				self [[self.onPickupFailed]](player);
			}
			return;
		}
		player gameobjects::give_object(self);
	}
	else if(self.type == "packObject")
	{
		if(isdefined(level.max_packObjects) && level.max_packObjects <= player.packObject.size)
		{
			if(isdefined(self.onPickupFailed))
			{
				self [[self.onPickupFailed]](player);
			}
			return;
		}
		player gameobjects::give_pack_object(self);
	}
	self gameobjects::set_carrier(player);
	self gameobjects::ghost_visuals();
	self.trigger.origin = self.trigger.origin + VectorScale((0, 0, 1), 10000);
	self notify("pickup_object");
	level notify("po");
	if(isdefined(self.onPickup))
	{
		self [[self.onPickup]](player);
	}
	self gameobjects::update_compass_icons();
	self gameobjects::update_world_icons();
}

/*
	Name: can_use_ball
	Namespace: ball
	Checksum: 0xA835B23B
	Offset: 0x2A50
	Size: 0x307
	Parameters: 1
	Flags: None
*/
function can_use_ball(player)
{
	if(!isdefined(player))
	{
		return 0;
	}
	if(!self gameobjects::can_interact_with(player))
	{
		return 0;
	}
	if(isdefined(self.DropTime) && self.DropTime >= GetTime())
	{
		return 0;
	}
	if(isdefined(player.resurrect_weapon) && player GetCurrentWeapon() == player.resurrect_weapon)
	{
		return 0;
	}
	if(player isCarryingTurret())
	{
		return 0;
	}
	currentWeapon = player GetCurrentWeapon();
	if(isdefined(currentWeapon))
	{
		if(!valid_ball_pickup_weapon(currentWeapon))
		{
			return 0;
		}
	}
	nextweapon = player.changingweapon;
	if(isdefined(nextweapon) && player IsSwitchingWeapons())
	{
		if(!valid_ball_pickup_weapon(nextweapon))
		{
			return 0;
		}
	}
	if(player player_no_pickup_time())
	{
		return 0;
	}
	ball = self.visuals[0];
	thresh = 15;
	dist2 = Distance2DSquared(ball.origin, player.origin);
	if(dist2 < thresh * thresh)
	{
		return 1;
	}
	ball = self.visuals[0];
	start = player GetEye();
	end = (self.curorigin[0], self.curorigin[1], self.curorigin[2] + 5);
	if(isdefined(self.carrier) && isPlayer(self.carrier))
	{
		end = self.carrier GetEye();
	}
	if(!SightTracePassed(end, start, 0, ball) && !SightTracePassed(end, player.origin, 0, ball))
	{
		return 0;
	}
	return 1;
}

/*
	Name: chief_mammal_reset
	Namespace: ball
	Checksum: 0x939D91AA
	Offset: 0x2D60
	Size: 0x19F
	Parameters: 0
	Flags: None
*/
function chief_mammal_reset()
{
	self.isResetting = 1;
	self notify("reset");
	origin = self.curorigin;
	if(isdefined(self.projectile))
	{
		origin = self.projectile.origin;
	}
	foreach(visual in self.visuals)
	{
		visual.origin = origin;
		visual.angles = visual.baseAngles;
		visual DontInterpolate();
		visual show();
	}
	if(isdefined(self.projectile))
	{
		self.projectile delete();
	}
	self gameobjects::clear_carrier();
	gameobjects::update_world_icons();
	gameobjects::update_compass_icons();
	gameobjects::update_objective();
	self.isResetting = 0;
}

/*
	Name: on_pickup_ball
	Namespace: ball
	Checksum: 0x35CB1C5E
	Offset: 0x2F08
	Size: 0x39B
	Parameters: 1
	Flags: None
*/
function on_pickup_ball(player)
{
	if(!isalive(player))
	{
		self chief_mammal_reset();
		return;
	}
	player disableUsability();
	player disableOffhandWeapons();
	level.useStartSpawns = 0;
	level clientfield::set("ball_away", 1);
	self.visuals[0] clientfield::set("ball_on_ground_fx", 0);
	linkedparent = self.visuals[0] GetLinkedEnt();
	if(isdefined(linkedparent))
	{
		self.visuals[0] Unlink();
	}
	player resetflashback();
	pass = 0;
	ball_velocity = 0;
	if(isdefined(self.projectile))
	{
		pass = 1;
		ball_velocity = self.projectile GetVelocity();
		self.projectile delete();
	}
	if(pass)
	{
		if(self.lastcarrierteam == player.team)
		{
			if(self.lastcarrier != player)
			{
				player.passtime = GetTime();
				player.passplayer = self.lastcarrier;
			}
		}
		else
		{
		}
	}
	otherTeam = util::getOtherTeam(player.team);
	self.lastcarrierscored = 0;
	self.lastcarrier = player;
	self.lastcarrierteam = player.team;
	self function_74db1ec9(player.team);
	player.balldropdelay = GetDvarInt("scr_ball_water_drop_delay", 10);
	player.objective = 1;
	player.hasperksprintfire = player hasPerk("specialty_sprintfire");
	player setPerk("specialty_sprintfire");
	player clientfield::set("ballcarrier", 1);
	player thread player_update_pass_target(self);
	player RecordGameEvent("pickup");
	player flag::set("has_ball");
}

/*
	Name: function_a472302d
	Namespace: ball
	Checksum: 0x1D222C64
	Offset: 0x32B0
	Size: 0xB5
	Parameters: 1
	Flags: Private
*/
function private function_a472302d(team)
{
	self.ownerTeam = team;
	if(team != "any")
	{
		self.team = team;
		foreach(visual in self.visuals)
		{
			visual.team = team;
		}
	}
}

/*
	Name: function_74db1ec9
	Namespace: ball
	Checksum: 0x23DCADEA
	Offset: 0x3370
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_74db1ec9(team)
{
	self function_a472302d(team);
	self gameobjects::update_trigger();
}

/*
	Name: ball_carrier_cleanup
	Namespace: ball
	Checksum: 0x1ACDD324
	Offset: 0x33B8
	Size: 0x137
	Parameters: 0
	Flags: None
*/
function ball_carrier_cleanup()
{
	self function_74db1ec9("neutral");
	if(isdefined(self.carrier))
	{
		self.carrier clientfield::set("ballcarrier", 0);
		self.carrier.balldropdelay = undefined;
		self.carrier.nopickuptime = GetTime() + 500;
		self.carrier player_clear_pass_target();
		self.carrier notify("cancel_update_pass_target");
		if(!self.carrier.hasperksprintfire)
		{
			self.carrier unsetPerk("specialty_sprintfire");
		}
		self.carrier enableUsability();
		self.carrier EnableOffhandWeapons();
		self.carrier setballpassallowed(0);
		self.carrier.objective = 0;
	}
}

/*
	Name: function_8f5b30b3
	Namespace: ball
	Checksum: 0x14B8F1EE
	Offset: 0x34F8
	Size: 0x14F
	Parameters: 2
	Flags: None
*/
function function_8f5b30b3(origin, angles)
{
	self.isResetting = 1;
	foreach(visual in self.visuals)
	{
		visual.origin = origin;
		visual.angles = angles;
		visual DontInterpolate();
		visual show();
	}
	self.trigger.origin = origin;
	self.curorigin = self.trigger.origin;
	self gameobjects::clear_carrier();
	gameobjects::update_world_icons();
	gameobjects::update_compass_icons();
	self.isResetting = 0;
}

/*
	Name: ball_set_dropped
	Namespace: ball
	Checksum: 0xB0B45124
	Offset: 0x3650
	Size: 0x237
	Parameters: 1
	Flags: None
*/
function ball_set_dropped(skip_physics)
{
	if(!isdefined(skip_physics))
	{
		skip_physics = 0;
	}
	self.isResetting = 1;
	self.DropTime = GetTime();
	self notify("dropped");
	dropAngles = (0, 0, 0);
	carrier = self.carrier;
	if(isdefined(carrier) && carrier.team != "spectator")
	{
		dropOrigin = carrier.origin;
		dropAngles = carrier.angles;
	}
	else
	{
		dropOrigin = self.origin;
	}
	if(!isdefined(dropOrigin))
	{
		dropOrigin = self.safeOrigin;
	}
	dropOrigin = dropOrigin + VectorScale((0, 0, 1), 40);
	if(isdefined(self.projectile))
	{
		self.projectile delete();
	}
	self ball_carrier_cleanup();
	self gameobjects::clear_carrier();
	self function_8f5b30b3(dropOrigin, dropAngles);
	self thread gameobjects::pickup_timeout(dropOrigin[2], dropOrigin[2] - 40);
	self.isResetting = 0;
	if(!skip_physics)
	{
		angles = (0, dropAngles[1], 0);
		FORWARD = AnglesToForward(angles);
		velocity = FORWARD * 250 + VectorScale((0, 0, 1), 140);
		ball_physics_launch(velocity);
	}
	return 1;
}

/*
	Name: on_reset_ball
	Namespace: ball
	Checksum: 0xACA9DADE
	Offset: 0x3890
	Size: 0x153
	Parameters: 3
	Flags: None
*/
function on_reset_ball(prev_origin, var_fd894ecd, var_6f3d4b2e)
{
	if(!isdefined(var_fd894ecd))
	{
		var_fd894ecd = 1;
	}
	if(isdefined(level.gameEnded) && level.gameEnded)
	{
		return;
	}
	visual = self.visuals[0];
	linkedparent = visual GetLinkedEnt();
	if(isdefined(linkedparent))
	{
		visual Unlink();
	}
	if(isdefined(self.projectile))
	{
		self.projectile delete();
	}
	if(!self gameobjects::get_flags(1))
	{
		playFX("ui/fx_uplink_ball_vanish", prev_origin);
		self play_return_vo();
	}
	self.lastcarrierteam = "none";
	self thread download_ball(var_fd894ecd, var_6f3d4b2e);
}

/*
	Name: ball_return_home
	Namespace: ball
	Checksum: 0xEE158203
	Offset: 0x39F0
	Size: 0xFF
	Parameters: 2
	Flags: None
*/
function ball_return_home(var_fd894ecd, var_6f3d4b2e)
{
	self.isResetting = 1;
	prev_origin = self.trigger.origin;
	self notify("reset");
	self gameobjects::move_visuals_to_base();
	self.trigger.origin = self.trigger.baseOrigin;
	self.curorigin = self.trigger.origin;
	if(isdefined(self.onReset))
	{
		self [[self.onReset]](prev_origin, var_fd894ecd, var_6f3d4b2e);
	}
	self gameobjects::clear_carrier();
	gameobjects::update_world_icons();
	gameobjects::update_compass_icons();
	self.isResetting = 0;
}

/*
	Name: reset_ball
	Namespace: ball
	Checksum: 0x810CDB60
	Offset: 0x3AF8
	Size: 0x293
	Parameters: 3
	Flags: None
*/
function reset_ball(var_fd894ecd, var_a987c5a2, var_6f3d4b2e)
{
	if(!isdefined(var_fd894ecd))
	{
		var_fd894ecd = 1;
	}
	self.visuals[0] clientfield::set("ball_on_ground_fx", 0);
	if(isdefined(var_a987c5a2))
	{
		self.trigger.baseOrigin = var_a987c5a2;
		foreach(visual in self.visuals)
		{
			visual.baseOrigin = var_a987c5a2;
		}
		break;
	}
	if(zm_utility::is_player_valid(self.lastcarrier))
	{
		while(isdefined(self.lastcarrier.is_flung) && self.lastcarrier.is_flung)
		{
			wait(0.1);
		}
		if(!self.lastcarrier IsOnGround())
		{
			var_195da49c = bullettrace(self.lastcarrier.origin, self.lastcarrier.origin + VectorScale((0, 0, -1), 100000), 0, self.lastcarrier)["position"] + VectorScale((0, 0, 1), 16);
		}
		else
		{
			var_195da49c = self.lastcarrier.origin;
		}
		self.trigger.baseOrigin = var_195da49c;
		foreach(visual in self.visuals)
		{
			visual.baseOrigin = var_195da49c;
		}
	}
	self thread ball_return_home(var_fd894ecd, var_6f3d4b2e);
}

/*
	Name: upload_ball
	Namespace: ball
	Checksum: 0x149319CD
	Offset: 0x3D98
	Size: 0x233
	Parameters: 1
	Flags: None
*/
function upload_ball(goal)
{
	self notify("score_event");
	self.in_goal = 1;
	goal.ball_in_goal = 1;
	if(isdefined(self.projectile))
	{
		self.projectile delete();
	}
	self gameobjects::allow_carry("none");
	move_to_center_time = 0.4;
	move_up_time = 1.2;
	rotate_time = 1;
	in_enemygoal_time = move_to_center_time + rotate_time;
	total_time = in_enemygoal_time + move_up_time;
	visual = self.visuals[0];
	visual moveto(self.trigger.origin, move_to_center_time, 0, move_to_center_time);
	visual rotateVelocity(VectorScale((1, 1, 0), 1080), total_time, total_time, 0);
	wait(in_enemygoal_time);
	goal.ball_in_goal = 0;
	self.visibleTeam = "neutral";
	self gameobjects::update_world_icon("friendly", 0);
	self gameobjects::update_world_icon("enemy", 0);
	self gameobjects::update_objective();
	visual MoveZ(4000, move_up_time, move_up_time * 0.1, 0);
	wait(move_up_time);
	self thread ball_return_home();
}

/*
	Name: download_ball
	Namespace: ball
	Checksum: 0x2F148195
	Offset: 0x3FD8
	Size: 0x277
	Parameters: 2
	Flags: None
*/
function download_ball(var_fd894ecd, var_6f3d4b2e)
{
	if(!isdefined(var_6f3d4b2e))
	{
		var_6f3d4b2e = 0;
	}
	self endon("pickup_object");
	self gameobjects::allow_carry("any");
	self function_74db1ec9("neutral");
	visual = self.visuals[0];
	if(var_fd894ecd)
	{
		visual.origin = visual.baseOrigin + VectorScale((0, 0, 1), 4000);
		visual DontInterpolate();
		fall_time = 3;
		visual moveto(visual.baseOrigin, fall_time, 0, fall_time);
		visual rotateVelocity(VectorScale((0, 1, 0), 720), fall_time, 0, fall_time);
		visual thread function_c2bef09f();
	}
	self.visibleTeam = "any";
	self gameobjects::update_world_icon("friendly", 1);
	self gameobjects::update_world_icon("enemy", 1);
	if(var_fd894ecd)
	{
		wait(fall_time);
	}
	level clientfield::set("ball_away", 0);
	visual clientfield::set("ball_on_ground_fx", 1);
	if(!isdefined(var_6f3d4b2e) && var_6f3d4b2e && isdefined(level.var_1c0253f1))
	{
		self thread [[level.var_1c0253f1]]();
	}
	PlayFXOnTag("ui/fx_uplink_ball_trail", visual, "tag_origin");
	self thread ball_download_fx(visual, fall_time);
	self.in_goal = 0;
}

/*
	Name: function_c2bef09f
	Namespace: ball
	Checksum: 0x1090ABD
	Offset: 0x4258
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_c2bef09f()
{
	self PlayLoopSound("prj_ball_loop");
	level waittill("po");
	self StopLoopSound();
}

/*
	Name: function_b8faebaf
	Namespace: ball
	Checksum: 0x44E19C7F
	Offset: 0x42A8
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function function_b8faebaf(var_dbefa1ce)
{
	self notify("reset");
	visual = self.visuals[0];
	linkedparent = visual GetLinkedEnt();
	if(isdefined(linkedparent))
	{
		visual Unlink();
	}
	if(isdefined(self.projectile))
	{
		self.projectile delete();
	}
	self gameobjects::allow_carry("none");
	wait(var_dbefa1ce);
	self gameobjects::allow_carry("any");
}

/*
	Name: ball_pass_watch
	Namespace: ball
	Checksum: 0xFD4A190A
	Offset: 0x4398
	Size: 0x253
	Parameters: 0
	Flags: None
*/
function ball_pass_watch()
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("death");
	self endon("drop_object");
	while(1)
	{
		self waittill("ball_pass", weapon);
		if(!isdefined(self.pass_target))
		{
			playerAngles = self getPlayerAngles();
			playerAngles = (math::clamp(playerAngles[0], -85, 85), playerAngles[1], playerAngles[2]);
			dir = AnglesToForward(playerAngles);
			force = 90;
			self.carryObject thread ball_physics_launch_drop(dir * force, self);
			return;
		}
		break;
	}
	if(isdefined(self.carryObject))
	{
		self thread ball_pass_or_throw_active();
		pass_target = self.pass_target;
		last_target_origin = self.pass_target.origin;
		wait(0.15);
		if(isdefined(self.pass_target))
		{
			pass_target = self.pass_target;
			self.carryObject thread ball_pass_projectile(self, pass_target, last_target_origin);
		}
		else
		{
			playerAngles = self getPlayerAngles();
			playerAngles = (math::clamp(playerAngles[0], -85, 85), playerAngles[1], playerAngles[2]);
			dir = AnglesToForward(playerAngles);
			force = 90;
			self.carryObject thread ball_physics_launch_drop(dir * force, self);
		}
	}
}

/*
	Name: ball_shoot_watch
	Namespace: ball
	Checksum: 0x5DCAC164
	Offset: 0x45F8
	Size: 0x263
	Parameters: 0
	Flags: None
*/
function ball_shoot_watch()
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("death");
	self endon("drop_object");
	extra_pitch = GetDvarFloat("scr_ball_shoot_extra_pitch", -6);
	force = GetDvarFloat("scr_ball_shoot_force", 1200);
	playsoundatposition("wpn_ball_pickup", self.origin);
	self PlayLoopSound("prj_ball_loop_idle");
	while(1)
	{
		self waittill("weapon_fired", weapon);
		self StopLoopSound();
		self playsound("wpn_throw_ball");
		if(weapon != GetWeapon("ball"))
		{
			continue;
		}
		break;
	}
	if(isdefined(self.carryObject))
	{
		playerAngles = self getPlayerAngles();
		playerAngles = playerAngles + (extra_pitch, 0, 0);
		playerAngles = (math::clamp(playerAngles[0], -85, 85), playerAngles[1], playerAngles[2]);
		dir = AnglesToForward(playerAngles);
		self thread ball_pass_or_throw_active();
		self thread ball_check_pass_kill_pickup(self.carryObject);
		self.carryObject ball_create_killcam_ent();
		self.carryObject thread ball_physics_launch_drop(dir * force, self, 1);
	}
}

/*
	Name: ball_weapon_change_watch
	Namespace: ball
	Checksum: 0x64D8BD34
	Offset: 0x4868
	Size: 0x1D3
	Parameters: 0
	Flags: None
*/
function ball_weapon_change_watch()
{
	level endon("game_ended");
	self endon("disconnect");
	self endon("death");
	self endon("drop_object");
	ballWeapon = GetWeapon("ball");
	while(1)
	{
		if(ballWeapon == self GetCurrentWeapon())
		{
			break;
		}
		self waittill("weapon_change");
	}
	while(1)
	{
		self waittill("weapon_change", weapon, lastWeapon);
		if(isdefined(weapon) && weapon.gadget_type == 14)
		{
			break;
		}
		if(weapon === level.weaponNone && lastWeapon === ballWeapon)
		{
			break;
		}
	}
	playerAngles = self getPlayerAngles();
	playerAngles = (math::clamp(playerAngles[0], -85, 85), AbsAngleClamp360(playerAngles[1] + 20), playerAngles[2]);
	dir = AnglesToForward(playerAngles);
	force = 90;
	self.carryObject thread ball_physics_launch_drop(dir * force, self);
}

/*
	Name: valid_ball_pickup_weapon
	Namespace: ball
	Checksum: 0xAC2A4257
	Offset: 0x4A48
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function valid_ball_pickup_weapon(weapon)
{
	if(weapon == level.weaponNone)
	{
		return 0;
	}
	if(weapon == GetWeapon("ball"))
	{
		return 0;
	}
	return 1;
}

/*
	Name: player_no_pickup_time
	Namespace: ball
	Checksum: 0x5F1EADE5
	Offset: 0x4A98
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function player_no_pickup_time()
{
	return isdefined(self.nopickuptime) && self.nopickuptime > GetTime();
}

/*
	Name: watchunderwater
	Namespace: ball
	Checksum: 0x63F8D550
	Offset: 0x4AC0
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function watchunderwater(trigger)
{
	self endon("death");
	self endon("disconnect");
	while(1)
	{
		if(self IsPlayerUnderwater())
		{
			if(isdefined(level.ball))
			{
				if(isdefined(level.ball.carrier) && level.ball.carrier == self)
				{
					level.ball gameobjects::set_dropped();
					return;
				}
			}
		}
		self.balldropdelay = undefined;
		wait(0.05);
	}
}

/*
	Name: ball_physics_launch_drop
	Namespace: ball
	Checksum: 0xAE34336
	Offset: 0x4B70
	Size: 0x4B
	Parameters: 3
	Flags: None
*/
function ball_physics_launch_drop(force, droppingPlayer, switchWeapon)
{
	ball_set_dropped(1);
	ball_physics_launch(force, droppingPlayer);
}

/*
	Name: ball_check_pass_kill_pickup
	Namespace: ball
	Checksum: 0x3E8390A9
	Offset: 0x4BC8
	Size: 0x1A3
	Parameters: 1
	Flags: None
*/
function ball_check_pass_kill_pickup(carryobj)
{
	self endon("death");
	self endon("disconnect");
	carryobj endon("reset");
	timer = spawnstruct();
	timer endon("timer_done");
	timer thread timer_run(1.5);
	carryobj waittill("pickup_object");
	timer timer_cancel();
	if(!isdefined(carryobj.carrier) || carryobj.carrier.team == self.team)
	{
		return;
	}
	carryobj.carrier endon("disconnect");
	timer thread timer_run(5);
	carryobj.carrier waittill("death", attacker);
	timer timer_cancel();
	if(!isdefined(attacker) || attacker != self)
	{
		return;
	}
	timer thread timer_run(2);
	carryobj waittill("pickup_object");
	timer timer_cancel();
}

/*
	Name: timer_run
	Namespace: ball
	Checksum: 0x38FCF7F2
	Offset: 0x4D78
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function timer_run(time)
{
	self endon("cancel_timer");
	wait(time);
	self notify("timer_done");
}

/*
	Name: timer_cancel
	Namespace: ball
	Checksum: 0x30570CD0
	Offset: 0x4DB0
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function timer_cancel()
{
	self notify("cancel_timer");
}

/*
	Name: adjust_for_stance
	Namespace: ball
	Checksum: 0x26071C78
	Offset: 0x4DD0
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function adjust_for_stance(ball)
{
	target = self;
	target endon("pass_end");
	offs = 0;
	while(isdefined(target) && isdefined(ball))
	{
		newoffs = 50;
		switch(target GetStance())
		{
			case "crouch":
			{
				newoffs = 30;
				break;
			}
			case "prone":
			{
				newoffs = 15;
				break;
			}
		}
		if(newoffs != offs)
		{
			ball ballsettarget(target, (0, 0, newoffs));
			newoffs = offs;
		}
		wait(0.05);
	}
}

/*
	Name: ball_pass_projectile
	Namespace: ball
	Checksum: 0x57433828
	Offset: 0x4ED8
	Size: 0x443
	Parameters: 3
	Flags: None
*/
function ball_pass_projectile(Passer, target, last_target_origin)
{
	ball_set_dropped(1);
	if(isdefined(target))
	{
		last_target_origin = target.origin;
	}
	offset = VectorScale((0, 0, 1), 60);
	if(target GetStance() == "prone")
	{
		offset = VectorScale((0, 0, 1), 15);
	}
	else if(target GetStance() == "crouch")
	{
		offset = VectorScale((0, 0, 1), 30);
	}
	playerAngles = Passer getPlayerAngles();
	playerAngles = (0, playerAngles[1], 0);
	dir = AnglesToForward(playerAngles);
	delta = dir * 50;
	origin = self.visuals[0].origin + delta;
	SIZE = 5;
	trace = PhysicsTrace(self.visuals[0].origin, origin, (SIZE * -1, SIZE * -1, SIZE * -1), (SIZE, SIZE, SIZE), Passer, 1);
	if(trace["fraction"] < 1)
	{
		t = 0.7 * trace["fraction"];
		self function_8f5b30b3(self.visuals[0].origin + delta * t, self.visuals[0].angles);
	}
	else
	{
		self function_8f5b30b3(trace["position"], self.visuals[0].angles);
	}
	pass_dir = VectorNormalize(last_target_origin + offset - self.visuals[0].origin);
	pass_vel = pass_dir * 850;
	Passer flag::clear("has_ball");
	self.projectile = Passer magicmissile(level.passingballweapon, self.visuals[0].origin, pass_vel);
	target thread adjust_for_stance(self.projectile);
	self.visuals[0] LinkTo(self.projectile);
	self gameobjects::ghost_visuals();
	self ball_create_killcam_ent();
	self ball_clear_contents();
	self thread ball_on_projectile_hit_client(Passer);
	self thread ball_on_projectile_death();
	self thread ball_watch_touch_enemy_goal();
}

/*
	Name: ball_on_projectile_death
	Namespace: ball
	Checksum: 0x4BF1CA61
	Offset: 0x5328
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function ball_on_projectile_death()
{
	self.projectile waittill("death");
	ball = self.visuals[0];
	if(!isdefined(self.carrier) && !self.in_goal)
	{
		if(ball.origin != ball.baseOrigin + VectorScale((0, 0, 1), 4000))
		{
			self ball_physics_launch(VectorScale((0, 0, 1), 10));
		}
	}
	self ball_restore_contents();
	ball notify("pass_end");
}

/*
	Name: ball_restore_contents
	Namespace: ball
	Checksum: 0x332AD60E
	Offset: 0x53F8
	Size: 0x69
	Parameters: 0
	Flags: None
*/
function ball_restore_contents()
{
	if(isdefined(self.visuals[0].old_contents))
	{
		self.visuals[0] setContents(self.visuals[0].old_contents);
		self.visuals[0].old_contents = undefined;
	}
}

/*
	Name: ball_on_projectile_hit_client
	Namespace: ball
	Checksum: 0xFD5CFF9E
	Offset: 0x5470
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function ball_on_projectile_hit_client(Passer)
{
	self endon("pass_end");
	self.projectile waittill("projectile_impact_player", player);
	self.trigger notify("trigger", player);
	if(isdefined(Passer))
	{
		Passer RecordGameEvent("pass");
	}
}

/*
	Name: ball_clear_contents
	Namespace: ball
	Checksum: 0x8CF20C73
	Offset: 0x54F0
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function ball_clear_contents()
{
	self.visuals[0].old_contents = self.visuals[0] setContents(0);
}

/*
	Name: ball_create_killcam_ent
	Namespace: ball
	Checksum: 0x248926A5
	Offset: 0x5530
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function ball_create_killcam_ent()
{
	if(isdefined(self.killCamEnt))
	{
		self.killCamEnt delete();
	}
	self.killCamEnt = spawn("script_model", self.visuals[0].origin);
	self.killCamEnt LinkTo(self.visuals[0]);
	self.killCamEnt setContents(0);
}

/*
	Name: ball_pass_or_throw_active
	Namespace: ball
	Checksum: 0xD3432320
	Offset: 0x55D8
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function ball_pass_or_throw_active()
{
	self endon("death");
	self endon("disconnect");
	self.pass_or_throw_active = 1;
	self AllowMelee(0);
	while(GetWeapon("ball") == self GetCurrentWeapon())
	{
		wait(0.05);
	}
	self AllowMelee(1);
	self.pass_or_throw_active = 0;
}

/*
	Name: ball_download_fx
	Namespace: ball
	Checksum: 0x6787E55C
	Offset: 0x5678
	Size: 0x1F
	Parameters: 2
	Flags: None
*/
function ball_download_fx(ball_model, waitTime)
{
	self.scorefrozenuntil = 0;
}

/*
	Name: ball_assign_random_start
	Namespace: ball
	Checksum: 0xB9B95269
	Offset: 0x56A0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function ball_assign_random_start()
{
	ball_assign_start(level.ball_start);
}

/*
	Name: ball_assign_start
	Namespace: ball
	Checksum: 0x1DB264E1
	Offset: 0x56C8
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function ball_assign_start(start)
{
	foreach(vis in self.visuals)
	{
		vis.baseOrigin = start.origin;
	}
	self.trigger.baseOrigin = start.origin;
	self.current_start = start;
	start.in_use = 1;
}

/*
	Name: ball_physics_launch
	Namespace: ball
	Checksum: 0xB76A53FF
	Offset: 0x57A8
	Size: 0x36B
	Parameters: 2
	Flags: None
*/
function ball_physics_launch(force, droppingPlayer)
{
	visuals = self.visuals[0];
	visuals.origin_prev = undefined;
	origin = visuals.origin;
	owner = visuals;
	if(isdefined(droppingPlayer))
	{
		owner = droppingPlayer;
		owner flag::clear("has_ball");
		origin = droppingPlayer GetWeaponMuzzlePoint();
		right = AnglesToRight(force);
		origin = origin + (right[0], right[1], 0) * 7;
		startPos = origin;
		delta = VectorNormalize(force) * 80;
		SIZE = 5;
		trace = PhysicsTrace(startPos, startPos + delta, (SIZE * -1, SIZE * -1, SIZE * -1), (SIZE, SIZE, SIZE), droppingPlayer, 1);
		if(trace["fraction"] < 1)
		{
			t = 0.7 * trace["fraction"];
			self function_8f5b30b3(startPos + delta * t, visuals.angles);
		}
		else
		{
			self function_8f5b30b3(trace["position"], visuals.angles);
		}
	}
	grenade = owner magicmissile(level.ballworldweapon, visuals.origin, force);
	grenade PlayLoopSound("prj_ball_loop");
	visuals LinkTo(grenade);
	self gameobjects::ghost_visuals();
	self.projectile = grenade;
	visuals DontInterpolate();
	self thread ball_physics_out_of_level();
	self thread ball_watch_touch_enemy_goal();
	self thread ball_physics_touch_cant_pickup_player(droppingPlayer);
	self thread ball_check_oob();
	self.var_b4c16cba = 0;
	self thread function_1b26c689();
}

/*
	Name: function_1b26c689
	Namespace: ball
	Checksum: 0xE62EB836
	Offset: 0x5B20
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function function_1b26c689()
{
	self endon("death");
	while(1)
	{
		self.projectile waittill("grenade_bounce", pos, normal);
		if(self.var_b4c16cba == 0)
		{
			dot = VectorDot(normal, (0, 0, 1));
			self.projectile thread function_c004c2bd();
		}
		self.var_b4c16cba++;
	}
}

/*
	Name: function_fed77788
	Namespace: ball
	Checksum: 0x6743B5D7
	Offset: 0x5BC8
	Size: 0x15B
	Parameters: 2
	Flags: None
*/
function function_fed77788(var_bdc0f958, v_force)
{
	visuals = self.visuals[0];
	visuals Unlink();
	wait(0.05);
	if(isdefined(self.projectile))
	{
		self.projectile delete();
	}
	grenade = visuals magicmissile(level.ballworldweapon, var_bdc0f958, v_force);
	visuals LinkTo(grenade);
	self gameobjects::ghost_visuals();
	self.projectile = grenade;
	visuals DontInterpolate();
	self thread ball_physics_out_of_level();
	self thread ball_check_oob();
	self thread gameobjects::pickup_timeout(var_bdc0f958[2], var_bdc0f958[2] - 400);
}

/*
	Name: ball_check_oob
	Namespace: ball
	Checksum: 0x3897865D
	Offset: 0x5D30
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function ball_check_oob()
{
	self endon("reset");
	self endon("pickup_object");
	visual = self.visuals[0];
	while(1)
	{
		skip_oob_check = isdefined(self.in_goal) && self.in_goal || (isdefined(self.isResetting) && self.isResetting);
		if(!skip_oob_check)
		{
			if(!isdefined(visual))
			{
				return;
			}
			if(visual oob::IsTouchingAnyOOBTrigger() || visual is_touching_any_ball_return_trigger() || self gameobjects::should_be_reset(visual.origin[2], visual.origin[2] + 10, 1))
			{
				self reset_ball();
				return;
			}
		}
		wait(0.05);
	}
}

/*
	Name: ball_physics_touch_cant_pickup_player
	Namespace: ball
	Checksum: 0x39376613
	Offset: 0x5E60
	Size: 0x13F
	Parameters: 1
	Flags: None
*/
function ball_physics_touch_cant_pickup_player(droppingPlayer)
{
	self endon("reset");
	self endon("pickup_object");
	ball = self.visuals[0];
	trigger = self.trigger;
	while(1)
	{
		trigger waittill("trigger", player);
		if(IsActor(player))
		{
			continue;
		}
		if(isdefined(droppingPlayer) && droppingPlayer == player && player player_no_pickup_time())
		{
			continue;
		}
		if(self.DropTime >= GetTime())
		{
			continue;
		}
		if(ball.origin == ball.baseOrigin + VectorScale((0, 0, 1), 4000))
		{
			continue;
		}
	}
}

/*
	Name: ball_physics_fake_bounce
	Namespace: ball
	Checksum: 0x3593F924
	Offset: 0x5FA8
	Size: 0x91
	Parameters: 0
	Flags: None
*/
function ball_physics_fake_bounce()
{
	ball = self.visuals[0];
	vel = ball GetVelocity();
	bounceforce = length(vel) / 10;
	bouncedir = -1 * VectorNormalize(vel);
}

/*
	Name: ball_watch_touch_enemy_goal
	Namespace: ball
	Checksum: 0x99EC1590
	Offset: 0x6048
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function ball_watch_touch_enemy_goal()
{
}

/*
	Name: line_intersect_sphere
	Namespace: ball
	Checksum: 0xFD1FEC38
	Offset: 0x6058
	Size: 0xE3
	Parameters: 4
	Flags: None
*/
function line_intersect_sphere(line_start, line_end, sphere_center, sphere_radius)
{
	dir = VectorNormalize(line_end - line_start);
	a = VectorDot(dir, line_start - sphere_center);
	a = a * a;
	b = line_start - sphere_center;
	b = b * b;
	c = sphere_radius * sphere_radius;
	return a - b + c >= 0;
}

/*
	Name: ball_touched_goal
	Namespace: ball
	Checksum: 0x6BB7B9CD
	Offset: 0x6148
	Size: 0x283
	Parameters: 1
	Flags: None
*/
function ball_touched_goal(goal)
{
	if(isdefined(self.claimPlayer))
	{
		return;
	}
	if(isdefined(self.scorefrozenuntil) && self.scorefrozenuntil > GetTime())
	{
		return;
	}
	self gameobjects::allow_carry("none");
	goal play_goal_score_fx();
	self.scorefrozenuntil = GetTime() + 10000;
	team = goal.team;
	otherTeam = util::getOtherTeam(team);
	if(isdefined(self.lastcarrier))
	{
		if(isdefined(self.lastcarrier.pers["throws"]))
		{
			self.lastcarrier.pers["throws"]++;
			self.lastcarrier.throws = self.lastcarrier.pers["throws"];
		}
		bbPrint("mpobjective", "gametime %d objtype %s team %s playerx %d playery %d playerz %d", GetTime(), "ball_throw", team, self.lastcarrier.origin);
		self.lastcarrier RecordGameEvent("throw");
		self.lastcarrier AddPlayerStatWithGameType("THROWS", 1);
		self.lastcarrierscored = 1;
		ball_check_assist(self.lastcarrier, 0);
		self.lastcarrier AddPlayerStatWithGameType("CAPTURES", 1);
	}
	if(isdefined(self.killCamEnt))
	{
		self.killCamEnt Unlink();
	}
	self thread upload_ball(goal);
	ball_give_score(otherTeam, level.throwscore);
}

/*
	Name: ball_give_score
	Namespace: ball
	Checksum: 0x6EECA1DA
	Offset: 0x63D8
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function ball_give_score(team, score)
{
	if(isdefined(game["overtime_round"]))
	{
		if(game["overtime_round"] == 1)
		{
		}
		else
		{
			team_score = [[level._getTeamScore]](team);
			other_team_score = [[level._getTeamScore]](util::getOtherTeam(team));
		}
	}
}

/*
	Name: should_record_final_score_cam
	Namespace: ball
	Checksum: 0x7DD2B369
	Offset: 0x6488
	Size: 0x73
	Parameters: 2
	Flags: None
*/
function should_record_final_score_cam(team, score_to_add)
{
	team_score = [[level._getTeamScore]](team);
	other_team_score = [[level._getTeamScore]](util::getOtherTeam(team));
	return team_score + score_to_add >= other_team_score;
}

/*
	Name: ball_check_assist
	Namespace: ball
	Checksum: 0xBCDD10B2
	Offset: 0x6508
	Size: 0x5D
	Parameters: 2
	Flags: None
*/
function ball_check_assist(player, wasdunk)
{
	if(!isdefined(player.passtime) || !isdefined(player.passplayer))
	{
		return;
	}
	if(player.passtime + 3000 < GetTime())
	{
		return;
	}
}

/*
	Name: ball_physics_timeout
	Namespace: ball
	Checksum: 0x3C68052A
	Offset: 0x6570
	Size: 0x183
	Parameters: 0
	Flags: None
*/
function ball_physics_timeout()
{
	self endon("reset");
	self endon("pickup_object");
	self endon("score_event");
	if(isdefined(self.autoResetTime) && self.autoResetTime > 15)
	{
		physicstime = self.autoResetTime;
	}
	else
	{
		physicstime = 15;
	}
	if(isdefined(self.projectile))
	{
		timeoutreason = self.projectile util::waittill_any_ex(physicstime, "stationary", self, "reset", "pickup_object", "score_event");
		if(!isdefined(timeoutreason))
		{
			return;
		}
		if(timeoutreason == "stationary")
		{
			str_zone_name = self.projectile zm_utility::get_current_zone();
			if(isdefined(str_zone_name) && IsPointOnNavMesh(self.projectile.origin))
			{
				self.visuals[0] clientfield::set("ball_on_ground_fx", 1);
				if(isdefined(level.var_1c0253f1))
				{
					self thread [[level.var_1c0253f1]]();
				}
				return;
			}
		}
	}
	self reset_ball();
}

/*
	Name: ball_physics_out_of_level
	Namespace: ball
	Checksum: 0x1DE890ED
	Offset: 0x6700
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function ball_physics_out_of_level()
{
	self endon("reset");
	self endon("pickup_object");
	ball = self.visuals[0];
	self waittill("entity_oob");
	self reset_ball(0);
}

/*
	Name: player_update_pass_target
	Namespace: ball
	Checksum: 0xF336A46
	Offset: 0x6760
	Size: 0x397
	Parameters: 1
	Flags: None
*/
function player_update_pass_target(ballobj)
{
	self notify("update_pass_target");
	self endon("update_pass_target");
	self endon("disconnect");
	self endon("cancel_update_pass_target");
	test_dot = 0.8;
	while(1)
	{
		new_target = undefined;
		if(!self isOnLadder())
		{
			playerdir = AnglesToForward(self getPlayerAngles());
			playerEye = self GetEye();
			possible_pass_targets = [];
			foreach(target in level.players)
			{
				if(target.team != self.team)
				{
					continue;
				}
				if(!isalive(target))
				{
					continue;
				}
				if(!ballobj can_use_ball(target))
				{
					continue;
				}
				targeteye = target GetEye();
				distSq = DistanceSquared(targeteye, playerEye);
				if(distSq > 1000000)
				{
					continue;
				}
				dirToTarget = VectorNormalize(targeteye - playerEye);
				dot = VectorDot(playerdir, dirToTarget);
				if(dot > test_dot)
				{
					target.pass_dot = dot;
					target.pass_origin = targeteye;
					possible_pass_targets[possible_pass_targets.size] = target;
				}
			}
			possible_pass_targets = Array::function_1e686f36(possible_pass_targets, &compare_player_pass_dot);
			foreach(target in possible_pass_targets)
			{
				if(SightTracePassed(playerEye, target.pass_origin, 0, target))
				{
					new_target = target;
					break;
				}
			}
		}
		self player_set_pass_target(new_target);
		wait(0.05);
	}
}

/*
	Name: play_return_vo
	Namespace: ball
	Checksum: 0x99EC1590
	Offset: 0x6B00
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function play_return_vo()
{
}

/*
	Name: compare_player_pass_dot
	Namespace: ball
	Checksum: 0x98D0A7CE
	Offset: 0x6B10
	Size: 0x2F
	Parameters: 2
	Flags: None
*/
function compare_player_pass_dot(left, right)
{
	return left.pass_dot >= right.pass_dot;
}

/*
	Name: player_set_pass_target
	Namespace: ball
	Checksum: 0x949D5FCF
	Offset: 0x6B48
	Size: 0x19B
	Parameters: 1
	Flags: None
*/
function player_set_pass_target(new_target)
{
	if(isdefined(self.pass_target) && isdefined(new_target) && self.pass_target == new_target)
	{
		return;
	}
	if(!isdefined(self.pass_target) && !isdefined(new_target))
	{
		return;
	}
	self player_clear_pass_target();
	if(isdefined(new_target))
	{
		offset = VectorScale((0, 0, 1), 80);
		new_target clientfield::set("passoption", 1);
		self.pass_target = new_target;
		team_players = [];
		foreach(player in level.players)
		{
			if(player.team == self.team && player != self && player != new_target)
			{
				team_players[team_players.size] = player;
			}
		}
		self setballpassallowed(1);
	}
}

/*
	Name: player_clear_pass_target
	Namespace: ball
	Checksum: 0x856AB54E
	Offset: 0x6CF0
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function player_clear_pass_target()
{
	if(isdefined(self.pass_icon))
	{
		self.pass_icon destroy();
	}
	team_players = [];
	foreach(player in level.players)
	{
		if(player.team == self.team && player != self)
		{
			team_players[team_players.size] = player;
		}
	}
	if(isdefined(self.pass_target))
	{
		self.pass_target clientfield::set("passoption", 0);
	}
	self.pass_target = undefined;
	self setballpassallowed(0);
}

/*
	Name: ballfindground
	Namespace: ball
	Checksum: 0x88BAA0C3
	Offset: 0x6E30
	Size: 0xB9
	Parameters: 1
	Flags: None
*/
function ballfindground(z_offset)
{
	traceStart = self.origin + VectorScale((0, 0, 1), 32);
	traceEnd = self.origin + VectorScale((0, 0, -1), 1000);
	trace = bullettrace(traceStart, traceEnd, 0, undefined);
	self.ground_origin = trace["position"];
	return trace["fraction"] != 0 && trace["fraction"] != 1;
}

/*
	Name: play_goal_score_fx
	Namespace: ball
	Checksum: 0x7A7360A0
	Offset: 0x6EF8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function play_goal_score_fx()
{
	key = "ball_score_" + self.team;
	level clientfield::set(key, !level clientfield::get(key));
}

/*
	Name: is_touching_any_ball_return_trigger
	Namespace: ball
	Checksum: 0x3DBDE67A
	Offset: 0x6F58
	Size: 0x1E5
	Parameters: 0
	Flags: None
*/
function is_touching_any_ball_return_trigger()
{
	if(!isdefined(level.ball_return_trigger))
	{
		return 0;
	}
	triggers_to_remove = [];
	result = 0;
	foreach(trigger in level.ball_return_trigger)
	{
		if(!isdefined(trigger))
		{
			if(!isdefined(triggers_to_remove))
			{
				triggers_to_remove = [];
			}
			else if(!IsArray(triggers_to_remove))
			{
				triggers_to_remove = Array(triggers_to_remove);
			}
			triggers_to_remove[triggers_to_remove.size] = trigger;
			continue;
		}
		if(!trigger IsTriggerEnabled())
		{
			continue;
		}
		if(self istouching(trigger))
		{
			result = 1;
			break;
		}
	}
	foreach(trigger in triggers_to_remove)
	{
		ArrayRemoveValue(level.ball_return_trigger, trigger);
	}
	triggers_to_remove = [];
	triggers_to_remove = undefined;
	return result;
}

