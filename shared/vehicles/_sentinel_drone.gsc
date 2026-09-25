#using scripts\codescripts\struct;
#using scripts\shared\ai\blackboard_vehicle;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;

#namespace sentinel_drone;

/*
	Name: __init__sytem__
	Namespace: sentinel_drone
	Checksum: 0x14959206
	Offset: 0xB98
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("sentinel_drone", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: sentinel_drone
	Checksum: 0xE37725F6
	Offset: 0xBD8
	Size: 0x73D
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "sentinel_drone_beam_set_target_id", 12000, 5, "int");
	clientfield::register("vehicle", "sentinel_drone_beam_set_source_to_target", 12000, 5, "int");
	clientfield::register("toplayer", "sentinel_drone_damage_player_fx", 12000, 1, "counter");
	clientfield::register("vehicle", "sentinel_drone_beam_fire1", 12000, 1, "int");
	clientfield::register("vehicle", "sentinel_drone_beam_fire2", 12000, 1, "int");
	clientfield::register("vehicle", "sentinel_drone_beam_fire3", 12000, 1, "int");
	clientfield::register("vehicle", "sentinel_drone_arm_cut_1", 12000, 1, "int");
	clientfield::register("vehicle", "sentinel_drone_arm_cut_2", 12000, 1, "int");
	clientfield::register("vehicle", "sentinel_drone_arm_cut_3", 12000, 1, "int");
	clientfield::register("vehicle", "sentinel_drone_face_cut", 12000, 1, "int");
	clientfield::register("vehicle", "sentinel_drone_beam_charge", 12000, 1, "int");
	clientfield::register("vehicle", "sentinel_drone_camera_scanner", 12000, 1, "int");
	clientfield::register("vehicle", "sentinel_drone_camera_destroyed", 12000, 1, "int");
	clientfield::register("scriptmover", "sentinel_drone_deathfx", 1, 1, "int");
	vehicle::add_main_callback("sentinel_drone", &sentinel_drone_initialize);
	level._sentinel_Enemy_Detected_Taunts = [];
	if(!isdefined(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = [];
	}
	else if(!IsArray(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = Array(level._sentinel_Enemy_Detected_Taunts);
	}
	level._sentinel_Enemy_Detected_Taunts[level._sentinel_Enemy_Detected_Taunts.size] = "vox_valk_valkyrie_detected_0";
	if(!isdefined(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = [];
	}
	else if(!IsArray(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = Array(level._sentinel_Enemy_Detected_Taunts);
	}
	level._sentinel_Enemy_Detected_Taunts[level._sentinel_Enemy_Detected_Taunts.size] = "vox_valk_valkyrie_detected_1";
	if(!isdefined(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = [];
	}
	else if(!IsArray(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = Array(level._sentinel_Enemy_Detected_Taunts);
	}
	level._sentinel_Enemy_Detected_Taunts[level._sentinel_Enemy_Detected_Taunts.size] = "vox_valk_valkyrie_detected_2";
	if(!isdefined(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = [];
	}
	else if(!IsArray(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = Array(level._sentinel_Enemy_Detected_Taunts);
	}
	level._sentinel_Enemy_Detected_Taunts[level._sentinel_Enemy_Detected_Taunts.size] = "vox_valk_valkyrie_detected_3";
	if(!isdefined(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = [];
	}
	else if(!IsArray(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = Array(level._sentinel_Enemy_Detected_Taunts);
	}
	level._sentinel_Enemy_Detected_Taunts[level._sentinel_Enemy_Detected_Taunts.size] = "vox_valk_valkyrie_detected_4";
	level._sentinel_System_Critical_Taunts = [];
	if(!isdefined(level._sentinel_System_Critical_Taunts))
	{
		level._sentinel_System_Critical_Taunts = [];
	}
	else if(!IsArray(level._sentinel_System_Critical_Taunts))
	{
		level._sentinel_System_Critical_Taunts = Array(level._sentinel_System_Critical_Taunts);
	}
	level._sentinel_System_Critical_Taunts[level._sentinel_System_Critical_Taunts.size] = "vox_valk_valkyrie_health_low_0";
	if(!isdefined(level._sentinel_System_Critical_Taunts))
	{
		level._sentinel_System_Critical_Taunts = [];
	}
	else if(!IsArray(level._sentinel_System_Critical_Taunts))
	{
		level._sentinel_System_Critical_Taunts = Array(level._sentinel_System_Critical_Taunts);
	}
	level._sentinel_System_Critical_Taunts[level._sentinel_System_Critical_Taunts.size] = "vox_valk_valkyrie_health_low_1";
	if(!isdefined(level._sentinel_System_Critical_Taunts))
	{
		level._sentinel_System_Critical_Taunts = [];
	}
	else if(!IsArray(level._sentinel_System_Critical_Taunts))
	{
		level._sentinel_System_Critical_Taunts = Array(level._sentinel_System_Critical_Taunts);
	}
	level._sentinel_System_Critical_Taunts[level._sentinel_System_Critical_Taunts.size] = "vox_valk_valkyrie_health_low_2";
	if(!isdefined(level._sentinel_System_Critical_Taunts))
	{
		level._sentinel_System_Critical_Taunts = [];
	}
	else if(!IsArray(level._sentinel_System_Critical_Taunts))
	{
		level._sentinel_System_Critical_Taunts = Array(level._sentinel_System_Critical_Taunts);
	}
	level._sentinel_System_Critical_Taunts[level._sentinel_System_Critical_Taunts.size] = "vox_valk_valkyrie_health_low_3";
	if(!isdefined(level._sentinel_System_Critical_Taunts))
	{
		level._sentinel_System_Critical_Taunts = [];
	}
	else if(!IsArray(level._sentinel_System_Critical_Taunts))
	{
		level._sentinel_System_Critical_Taunts = Array(level._sentinel_System_Critical_Taunts);
	}
	level._sentinel_System_Critical_Taunts[level._sentinel_System_Critical_Taunts.size] = "vox_valk_valkyrie_health_low_4";
}

/*
	Name: sentinel_drone_initialize
	Namespace: sentinel_drone
	Checksum: 0x4BB131F1
	Offset: 0x1320
	Size: 0x58B
	Parameters: 0
	Flags: None
*/
function sentinel_drone_initialize()
{
	self useanimtree(-1);
	Target_Set(self, (0, 0, 0));
	self.health = self.healthdefault;
	if(!isdefined(level.sentinelDroneMaxHealth))
	{
		level.sentinelDroneMaxHealth = self.health;
	}
	self.maxhealth = level.sentinelDroneMaxHealth;
	if(!isdefined(level.sentinelDroneHealthArmLeft))
	{
		level.sentinelDroneHealthArmLeft = 200;
	}
	if(!isdefined(level.sentinelDroneHealthArmRight))
	{
		level.sentinelDroneHealthArmRight = 200;
	}
	if(!isdefined(level.sentinelDroneHealthArmTop))
	{
		level.sentinelDroneHealthArmTop = 200;
	}
	if(!isdefined(level.sentinelDroneHealthFace))
	{
		level.sentinelDroneHealthFace = 200;
	}
	if(!isdefined(level.sentinelDroneHealthCamera))
	{
		level.sentinelDroneHealthCamera = 300;
	}
	if(!isdefined(level.sentinelDroneHealthCore))
	{
		level.sentinelDroneHealthCore = 100;
	}
	self.sentinelDroneHealthArms = [];
	self.sentinelDroneHealthArms[2] = level.sentinelDroneHealthArmLeft;
	self.sentinelDroneHealthArms[1] = level.sentinelDroneHealthArmRight;
	self.sentinelDroneHealthArms[3] = level.sentinelDroneHealthArmTop;
	self.sentinelDroneHealthFace = level.sentinelDroneHealthFace;
	self.sentinelDroneHealthCamera = level.sentinelDroneHealthCamera;
	self.sentinelDroneHealthCore = level.sentinelDroneHealthCore;
	self.beam_fire_target = util::spawn_model("tag_origin", self.position, self.angles);
	if(!isdefined(level.sentinel_drone_target_id))
	{
		level.sentinel_drone_target_id = 0;
	}
	level.sentinel_drone_target_id = level.sentinel_drone_target_id + 1 % 32;
	if(level.sentinel_drone_target_id == 0)
	{
		level.sentinel_drone_target_id = 1;
	}
	self.drone_target_id = level.sentinel_drone_target_id;
	blackboard::CreateBlackBoardForEntity(self);
	self blackboard::RegisterVehicleBlackBoardAttributes();
	ai::CreateInterfaceForEntity(self);
	self vehicle::friendly_fire_shield();
	self EnableAimAssist();
	self SetNearGoalNotifyDist(35);
	self SetVehicleAvoidance(1);
	self SetDrawInfrared(1);
	self SetHoverParams(0, 0, 10);
	self.no_gib = 1;
	self.fovcosine = 0;
	self.fovcosinebusy = 0;
	self.vehAirCraftCollisionEnabled = 1;
	/#
		Assert(isdefined(self.scriptbundlesettings));
	#/
	self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	self.goalRadius = 999999;
	self.goalHeight = 4000;
	self SetGoal(self.origin, 0, self.goalRadius, self.goalHeight);
	self.nextJukeTime = 0;
	self.nextRollTime = 0;
	self.arms_count = 3;
	SetDvar("Sentinel_Move_Speed", 25);
	SetDvar("Sentinel_Evade_Speed", 40);
	self.should_buff_zombies = 0;
	self.disable_flame_fx = 1;
	self.no_widows_wine = 1;
	self.targetPlayerTime = GetTime() + 1000 + RandomInt(1000);
	self.pers = [];
	self.pers["team"] = self.team;
	self.overrideVehicleDamage = &sentinel_CallbackDamage;
	self.overrideVehicleRadiusDamage = &sentinel_drone_CallbackRadiusDamage;
	if(!isdefined(level.a_sentinel_drones))
	{
		level.a_sentinel_drones = [];
	}
	Array::add(level.a_sentinel_drones, self);
	if(isdefined(level.func_custom_sentinel_drone_cleanup_check))
	{
		self.func_custom_cleanup_check = level.func_custom_sentinel_drone_cleanup_check;
	}
	self thread vehicle_ai::nudge_collision();
	self thread sentinel_HideInitialBrokenParts();
	self thread sentinel_InitBeamLaunchers();
	/#
		self thread sentinel_DebugFX();
		self thread sentinel_DebugBehavior();
	#/
	defaultRole();
}

/*
	Name: sentinel_InitBeamLaunchers
	Namespace: sentinel_drone
	Checksum: 0x108BAFD
	Offset: 0x18B8
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function sentinel_InitBeamLaunchers()
{
	self endon("death");
	if(!isdefined(self.target_initialized))
	{
		wait(1);
		self.beam_fire_target clientfield::set("sentinel_drone_beam_set_target_id", self.drone_target_id);
		wait(0.1);
		self clientfield::set("sentinel_drone_beam_set_source_to_target", self.drone_target_id);
		wait(1);
		self.target_initialized = 1;
	}
}

/*
	Name: defaultRole
	Namespace: sentinel_drone
	Checksum: 0xA8D77FC6
	Offset: 0x1950
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role("default");
	self vehicle_ai::get_state_callbacks("combat").update_func = &state_combat_update;
	self vehicle_ai::get_state_callbacks("death").update_func = &state_death_update;
	self vehicle_ai::call_custom_add_state_callbacks();
	vehicle_ai::StartInitialState("combat");
}

/*
	Name: is_target_valid
	Namespace: sentinel_drone
	Checksum: 0x83EECE16
	Offset: 0x1A10
	Size: 0x197
	Parameters: 1
	Flags: Private
*/
function private is_target_valid(target)
{
	if(!isdefined(target))
	{
		return 0;
	}
	if(!isalive(target))
	{
		return 0;
	}
	if(isPlayer(target) && target.sessionstate == "spectator")
	{
		return 0;
	}
	if(isPlayer(target) && target.sessionstate == "intermission")
	{
		return 0;
	}
	if(isdefined(target.ignoreme) && target.ignoreme)
	{
		return 0;
	}
	if(target IsNoTarget())
	{
		return 0;
	}
	if(isdefined(target.is_elemental_zombie) && target.is_elemental_zombie)
	{
		return 0;
	}
	if(isdefined(level.is_valid_player_for_sentinel_drone))
	{
		if(![[level.is_valid_player_for_sentinel_drone]](target))
		{
			return 0;
		}
	}
	if(isdefined(self.should_buff_zombies) && self.should_buff_zombies && isPlayer(target))
	{
		if(isdefined(get_sentinel_nearest_zombie()))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: get_sentinel_nearest_zombie
	Namespace: sentinel_drone
	Checksum: 0x429A4E
	Offset: 0x1BB0
	Size: 0x9B
	Parameters: 3
	Flags: None
*/
function get_sentinel_nearest_zombie(b_ignore_elemental, b_outside_playable_area, radius)
{
	if(!isdefined(b_ignore_elemental))
	{
		b_ignore_elemental = 1;
	}
	if(!isdefined(b_outside_playable_area))
	{
		b_outside_playable_area = 1;
	}
	if(!isdefined(radius))
	{
		radius = 2000;
	}
	if(isdefined(self.sentinel_GetNearestZombie))
	{
		ai_zombie = [[self.sentinel_GetNearestZombie]](self.origin, b_ignore_elemental, b_outside_playable_area, radius);
		return ai_zombie;
	}
	return undefined;
}

/*
	Name: get_sentinel_drone_enemy
	Namespace: sentinel_drone
	Checksum: 0x25A4874C
	Offset: 0x1C58
	Size: 0x1EB
	Parameters: 0
	Flags: None
*/
function get_sentinel_drone_enemy()
{
	sentinel_drone_targets = GetPlayers();
	least_hunted = sentinel_drone_targets[0];
	search_distance_sq = 2000 * 2000;
	for(i = 0; i < sentinel_drone_targets.size; i++)
	{
		if(!isdefined(sentinel_drone_targets[i].hunted_by_sentinel))
		{
			sentinel_drone_targets[i].hunted_by_sentinel = 0;
		}
		if(!is_target_valid(sentinel_drone_targets[i]))
		{
			continue;
		}
		if(!is_target_valid(least_hunted))
		{
			least_hunted = sentinel_drone_targets[i];
			continue;
		}
		dist_to_target_sq = Distance2DSquared(self.origin, sentinel_drone_targets[i].origin);
		dist_to_least_hunted_sq = Distance2DSquared(self.origin, least_hunted.origin);
		if(dist_to_least_hunted_sq >= search_distance_sq && dist_to_target_sq < search_distance_sq)
		{
			least_hunted = sentinel_drone_targets[i];
			continue;
		}
		if(sentinel_drone_targets[i].hunted_by_sentinel < least_hunted.hunted_by_sentinel)
		{
			least_hunted = sentinel_drone_targets[i];
		}
	}
	if(!is_target_valid(least_hunted))
	{
		return undefined;
	}
	else
	{
		return least_hunted;
	}
}

/*
	Name: set_sentinel_drone_enemy
	Namespace: sentinel_drone
	Checksum: 0x5CD21A5
	Offset: 0x1E50
	Size: 0x183
	Parameters: 1
	Flags: None
*/
function set_sentinel_drone_enemy(enemy)
{
	if(isdefined(self.sentinel_droneEnemy))
	{
		if(!isdefined(self.sentinel_droneEnemy.hunted_by_sentinel))
		{
			self.sentinel_droneEnemy.hunted_by_sentinel = 0;
		}
		if(self.sentinel_droneEnemy.hunted_by_sentinel > 0)
		{
			self.sentinel_droneEnemy.hunted_by_sentinel--;
		}
	}
	if(!is_target_valid(enemy))
	{
		self.sentinel_droneEnemy = undefined;
		self ClearLookAtEnt();
		self ClearTurretTarget(0);
		return;
	}
	self.sentinel_droneEnemy = enemy;
	if(isdefined(self.skip_first_taunt))
	{
		if(isPlayer(enemy))
		{
			sentinel_play_taunt(level._sentinel_Enemy_Detected_Taunts);
		}
	}
	else
	{
		self.skip_first_taunt = 1;
	}
	if(!isdefined(self.sentinel_droneEnemy.hunted_by_sentinel))
	{
		self.sentinel_droneEnemy.hunted_by_sentinel = 0;
	}
	self.sentinel_droneEnemy.hunted_by_sentinel++;
	self SetLookAtEnt(self.sentinel_droneEnemy);
	self SetTurretTargetEnt(self.sentinel_droneEnemy);
}

/*
	Name: sentinel_drone_target_selection
	Namespace: sentinel_drone
	Checksum: 0xBEF6F57F
	Offset: 0x1FE0
	Size: 0xF7
	Parameters: 0
	Flags: Private
*/
function private sentinel_drone_target_selection()
{
	self endon("change_state");
	self endon("death");
	while(isdefined(self.ignoreall) && self.ignoreall)
	{
		wait(0.5);
		continue;
		if(is_target_valid(self.sentinel_droneEnemy))
		{
			wait(0.5);
		}
		else if(isdefined(self.should_buff_zombies) && self.should_buff_zombies)
		{
			target = get_sentinel_nearest_zombie();
			if(!isdefined(target))
			{
				target = get_sentinel_drone_enemy();
			}
		}
		else
		{
			target = get_sentinel_drone_enemy();
		}
		set_sentinel_drone_enemy(target);
		wait(0.5);
	}
}

/*
	Name: state_combat_update
	Namespace: sentinel_drone
	Checksum: 0x8A4ED1A5
	Offset: 0x20E0
	Size: 0x1CF
	Parameters: 1
	Flags: None
*/
function state_combat_update(params)
{
	self endon("change_state");
	self endon("death");
	self.lastTimeTargetInSight = 0;
	self.nextJukeTime = 0;
	wait(0.3);
	if(isdefined(self.owner) && isdefined(self.owner.enemy))
	{
		self.sentinel_droneEnemy = self.owner.enemy;
	}
	thread sentinel_drone_target_selection();
	thread sentinel_NavigateTheWorld();
	thread sentine_RumbleWhenNearPlayer();
	while(1)
	{
		if(isdefined(self.playing_intro_anim) && self.playing_intro_anim)
		{
			wait(0.1);
		}
		else if(isdefined(self.is_charging_at_player) && self.is_charging_at_player)
		{
			wait(0.1);
		}
		else if(!isdefined(self.forced_pos) && (isdefined(self.shouldRoll) && self.shouldRoll))
		{
			if(sentinel_DodgeRoll())
			{
				thread sentinel_NavigateTheWorld();
			}
		}
		else if(!isdefined(self.sentinel_droneEnemy))
		{
			wait(0.25);
		}
		else if(self.arms_count > 0)
		{
			if(RandomInt(100) < 30)
			{
				if(self sentinel_FireLogic())
				{
					thread sentinel_NavigateTheWorld();
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: sentinel_Intro
	Namespace: sentinel_drone
	Checksum: 0xECB70B5
	Offset: 0x22B8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function sentinel_Intro()
{
	sentinel_NavigationStandStill();
	self.playing_intro_anim = 1;
	self ASMRequestSubstate("intro@default");
}

/*
	Name: sentinel_IntroCompleted
	Namespace: sentinel_drone
	Checksum: 0xE811DD29
	Offset: 0x2300
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function sentinel_IntroCompleted()
{
	self.playing_intro_anim = 0;
	if(!self vehicle_ai::is_instate("scripted"))
	{
		self thread sentinel_NavigateTheWorld();
	}
}

/*
	Name: sentinel_DodgeRoll
	Namespace: sentinel_drone
	Checksum: 0xDA023DCA
	Offset: 0x2350
	Size: 0x4C7
	Parameters: 0
	Flags: None
*/
function sentinel_DodgeRoll()
{
	self endon("change_state");
	self endon("death");
	roll_dir = AnglesToRight(self.angles);
	roll_dir = VectorNormalize(roll_dir);
	juke_initial_pause = GetDvarFloat("sentinel_drone_juke_initial_pause_dvar", 0.2);
	juke_speed = GetDvarInt("sentinel_drone_juke_speed_dvar", 300);
	juke_offset = GetDvarInt("sentinel_drone_juke_offset_dvar", 20);
	JUKE_DISTANCE = GetDvarInt("sentinel_drone_juke_distance_dvar", 100);
	juke_distance_max = GetDvarInt("sentinel_drone_juke_distance_max_dvar", 250);
	juke_min_anim_rate = GetDvarFloat("sentinel_drone_juke_min_anim_rate_dvar", 0.9);
	can_roll = 0;
	if(math::cointoss())
	{
		roll_point = self.origin + VectorScale(roll_dir, juke_distance_max);
		roll_asm_state = "dodge_right@attack";
	}
	else
	{
		roll_dir = VectorScale(roll_dir, -1);
		roll_point = self.origin - VectorScale(roll_dir, juke_distance_max * -1);
		roll_asm_state = "dodge_left@attack";
	}
	trace = sentinel_Trace(self.origin, roll_point, self, 1);
	if(isdefined(trace["position"]))
	{
		if(!IsPointInNavvolume(trace["position"], "navvolume_small"))
		{
			trace["position"] = self GetClosestPointOnNavVolume(trace["position"], 100);
		}
		if(isdefined(trace["position"]))
		{
			if(trace["fraction"] == 1)
			{
				roll_distance = juke_distance_max - juke_offset;
			}
			else
			{
				roll_distance = juke_distance_max * trace["fraction"] - juke_offset;
			}
			if(roll_distance >= JUKE_DISTANCE)
			{
				roll_anim_rate = JUKE_DISTANCE / roll_distance;
				if(roll_anim_rate < juke_min_anim_rate)
				{
					roll_anim_rate = juke_min_anim_rate;
				}
				roll_speed = roll_distance / JUKE_DISTANCE * juke_speed;
				can_roll = 1;
			}
		}
	}
	self.shouldRoll = 0;
	if(can_roll)
	{
		sentinel_NavigationStandStill();
		wait(0.1);
		self clientfield::set("sentinel_drone_camera_scanner", 1);
		self ASMRequestSubstate(roll_asm_state);
		self ASMSetAnimationRate(roll_anim_rate);
		wait(juke_initial_pause);
		self SetSpeed(roll_speed);
		self SetVehVelocity(VectorScale(roll_dir, roll_speed));
		self SetVehGoalPos(trace["position"], 1, 0);
		wait(1);
		self ASMSetAnimationRate(1);
		sentinel_NavigationStandStill();
		self clientfield::set("sentinel_drone_camera_scanner", 0);
		wait(0.1);
	}
	if(math::cointoss())
	{
		self sentinel_FireLogic();
	}
	return can_roll;
}

/*
	Name: sentinel_NavigationStandStill
	Namespace: sentinel_drone
	Checksum: 0xA8730C5A
	Offset: 0x2820
	Size: 0x27B
	Parameters: 0
	Flags: None
*/
function sentinel_NavigationStandStill()
{
	self endon("change_state");
	self endon("death");
	self notify("abort_navigation");
	self notify("near_goal");
	wait(0.05);
	if(GetDvarInt("sentinel_NavigationStandStill_new", 0) > 0)
	{
		self ClearVehGoalPos();
		self SetVehVelocity((0, 0, 0));
		self.vehAirCraftCollisionEnabled = 1;
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				RecordSphere(self.origin, 30, (1, 0.5, 0));
			}
		#/
		return;
	}
	if(GetDvarInt("sentinel_ClearVehGoalPos", 1) == 1)
	{
		self ClearVehGoalPos();
	}
	if(GetDvarInt("sentinel_PathVariableOffsetClear", 1) == 1)
	{
		self PathVariableOffsetClear();
	}
	if(GetDvarInt("sentinel_PathFixedOffsetClear", 1) == 1)
	{
		self PathFixedOffsetClear();
	}
	if(GetDvarInt("sentinel_ClearSpeed", 1) == 1)
	{
		self SetSpeed(0);
		self SetVehVelocity((0, 0, 0));
		self SetPhysAcceleration((0, 0, 0));
		self SetAngularVelocity((0, 0, 0));
	}
	self.vehAirCraftCollisionEnabled = 1;
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			RecordSphere(self.origin, 30, (1, 0.5, 0));
		}
	#/
}

/*
	Name: sentinel_ShouldChangeSentinelPosition
	Namespace: sentinel_drone
	Checksum: 0xA63BE82B
	Offset: 0x2AA8
	Size: 0xBD
	Parameters: 0
	Flags: Private
*/
function private sentinel_ShouldChangeSentinelPosition()
{
	if(GetTime() > self.nextJukeTime)
	{
		return 1;
	}
	if(isdefined(self.sentinel_droneEnemy))
	{
		if(isdefined(self.lastJukeTime))
		{
			if(GetTime() - self.lastJukeTime > 3000)
			{
				speed = self getspeed();
				if(speed < 1)
				{
					if(!sentinel_IsInsideEngagementDistance(self.origin, self.sentinel_droneEnemy.origin + VectorScale((0, 0, 1), 48), 1))
					{
						return 1;
					}
				}
			}
		}
	}
	return 0;
}

/*
	Name: sentinel_changeSentinelPosition
	Namespace: sentinel_drone
	Checksum: 0x42A3C24C
	Offset: 0x2B70
	Size: 0xF
	Parameters: 0
	Flags: Private
*/
function private sentinel_changeSentinelPosition()
{
	self.nextJukeTime = 0;
}

/*
	Name: sentinel_NavigateTheWorld
	Namespace: sentinel_drone
	Checksum: 0x4D5A5AC4
	Offset: 0x2B88
	Size: 0xA7F
	Parameters: 0
	Flags: None
*/
function sentinel_NavigateTheWorld()
{
	self endon("change_state");
	self endon("death");
	self endon("abort_navigation");
	self notify("sentinel_NavigateTheWorld");
	self endon("sentinel_NavigateTheWorld");
	lastTimeChangePosition = 0;
	self.shouldGotoNewPosition = 0;
	self.last_failsafe_count = 0;
	Sentinel_Move_Speed = GetDvarInt("Sentinel_Move_Speed", 25);
	Sentinel_Evade_Speed = GetDvarInt("Sentinel_Evade_Speed", 40);
	self SetSpeed(Sentinel_Move_Speed);
	self ASMRequestSubstate("locomotion@movement");
	self.current_pathto_pos = undefined;
	self.next_near_player_check = 0;
	b_use_path_finding = 1;
	while(1)
	{
		current_pathto_pos = undefined;
		b_in_tactical_position = 0;
		if(isdefined(self.playing_intro_anim) && self.playing_intro_anim)
		{
			wait(0.1);
		}
		else if(self.goalforced)
		{
			returnData = [];
			returnData["origin"] = self GetClosestPointOnNavVolume(self.goalpos, 100);
			returnData["centerOnNav"] = IsPointInNavvolume(self.origin, "navvolume_small");
			current_pathto_pos = returnData["origin"];
		}
		else if(isdefined(self.forced_pos))
		{
			returnData = [];
			returnData["origin"] = self GetClosestPointOnNavVolume(self.forced_pos, 100);
			returnData["centerOnNav"] = IsPointInNavvolume(self.origin, "navvolume_small");
			current_pathto_pos = returnData["origin"];
		}
		else if(sentinel_ShouldChangeSentinelPosition())
		{
			if(isdefined(self.evading_player) && self.evading_player)
			{
				self.evading_player = 0;
				self SetSpeed(Sentinel_Evade_Speed);
			}
			else
			{
				self SetSpeed(Sentinel_Move_Speed);
			}
			returnData = sentinel_GetNextMovePositionTactical(self.should_buff_zombies);
			current_pathto_pos = returnData["origin"];
			self.lastJukeTime = GetTime();
			self.nextJukeTime = GetTime() + 1000 + RandomInt(4000);
			b_in_tactical_position = 1;
		}
		else if(GetTime() > self.next_near_player_check && sentinel_IsNearAnotherPlayer(self.origin, 100))
		{
			self.evading_player = 1;
			self.next_near_player_check = GetTime() + 1000;
			self.nextJukeTime = 0;
			self notify("near_goal");
		}
		is_on_nav_volume = IsPointInNavvolume(self.origin, "navvolume_small");
		/#
			if(GetDvarInt("Dev Block strings are not supported", 0) == 1)
			{
				current_pathto_pos = undefined;
				is_on_nav_volume = 1;
			}
		#/
		if(isdefined(current_pathto_pos))
		{
			if(isdefined(self.stuckTime) && (isdefined(is_on_nav_volume) && is_on_nav_volume))
			{
				self.stuckTime = undefined;
			}
			/#
				if(GetDvarInt("Dev Block strings are not supported") > 0)
				{
					RecordSphere(current_pathto_pos, 8, (0, 0, 1));
				}
			#/
			/#
				if(GetDvarInt("Dev Block strings are not supported") > 0)
				{
					if(!IsPointInNavvolume(current_pathto_pos, "Dev Block strings are not supported"))
					{
						recordLine(current_pathto_pos, level.players[0].origin + VectorScale((0, 0, 1), 48), (1, 1, 1));
						RecordSphere(current_pathto_pos, 10, (1, 1, 1));
						PrintTopRightln("Dev Block strings are not supported" + self GetEntityNumber(), (1, 1, 1));
					}
					if(!(isdefined(is_on_nav_volume) && is_on_nav_volume))
					{
						recordLine(self.origin, level.players[0].origin + VectorScale((0, 0, 1), 48), (0, 1, 0));
						RecordSphere(self.origin, 10, (0, 1, 0));
						PrintTopRightln("Dev Block strings are not supported" + self GetEntityNumber(), (0, 1, 0));
					}
				}
			#/
			if(self SetVehGoalPos(current_pathto_pos, 1, b_use_path_finding))
			{
				b_use_path_finding = 1;
				self.b_in_tactical_position = b_in_tactical_position;
				self thread sentinel_PathUpdateInterrupt();
				self vehicle_ai::waittill_pathing_done(5);
				current_pathto_pos = undefined;
			}
			else if(isdefined(is_on_nav_volume) && is_on_nav_volume)
			{
				/#
					if(GetDvarInt("Dev Block strings are not supported") > 0)
					{
						PrintTopRightln("Dev Block strings are not supported" + self GetEntityNumber(), (1, 0, 0));
						recordLine(current_pathto_pos, level.players[0].origin + VectorScale((0, 0, 1), 48), (1, 0, 0));
						RecordSphere(current_pathto_pos, 10, (1, 0, 0));
						recordLine(self.origin, level.players[0].origin + VectorScale((0, 0, 1), 48), (1, 0.2, 0.2));
						RecordSphere(self.origin, 10, (1, 0, 0));
					}
				#/
				self sentinel_KillMyself();
				self.last_failsafe_time = undefined;
			}
		}
		if(!(isdefined(is_on_nav_volume) && is_on_nav_volume))
		{
			if(!isdefined(self.last_failsafe_time))
			{
				self.last_failsafe_time = GetTime();
			}
			if(GetTime() - self.last_failsafe_time >= 3000)
			{
				self.last_failsafe_count = 0;
			}
			else
			{
				self.last_failsafe_count++;
			}
			self.last_failsafe_time = GetTime();
			if(self.last_failsafe_count > 25)
			{
				new_sentinel_pos = self GetClosestPointOnNavVolume(self.origin, 120);
				if(isdefined(new_sentinel_pos))
				{
					dvar_sentinel_getback_to_volume_epsilon = GetDvarInt("dvar_sentinel_getback_to_volume_epsilon", 5);
					if(Distance(self.origin, new_sentinel_pos) < dvar_sentinel_getback_to_volume_epsilon)
					{
						self.origin = new_sentinel_pos;
						/#
							if(GetDvarInt("Dev Block strings are not supported") > 0)
							{
								RecordSphere(new_sentinel_pos, 8, (1, 0, 0));
							}
						#/
					}
					else
					{
						self.vehAirCraftCollisionEnabled = 0;
						/#
							if(GetDvarInt("Dev Block strings are not supported") > 0)
							{
								RecordSphere(new_sentinel_pos, 8, (1, 0, 0));
							}
						#/
						if(self SetVehGoalPos(new_sentinel_pos, 1, 0))
						{
							self thread sentinel_PathUpdateInterrupt();
							self vehicle_ai::waittill_pathing_done(5);
							current_pathto_pos = undefined;
						}
						self.vehAirCraftCollisionEnabled = 1;
					}
				}
				else if(self.last_failsafe_count > 100)
				{
					self sentinel_KillMyself();
				}
			}
		}
		if(!(isdefined(is_on_nav_volume) && is_on_nav_volume))
		{
			if(!isdefined(self.stuckTime))
			{
				self.stuckTime = GetTime();
			}
			if(GetTime() - self.stuckTime > 15000)
			{
				self sentinel_KillMyself();
			}
		}
		wait(0.1);
	}
}

/*
	Name: sentinel_GetNextMovePositionTactical
	Namespace: sentinel_drone
	Checksum: 0x8CAD2A6E
	Offset: 0x3610
	Size: 0xEC5
	Parameters: 1
	Flags: None
*/
function sentinel_GetNextMovePositionTactical(b_do_not_chase_enemy)
{
	self endon("change_state");
	self endon("death");
	if(isdefined(self.sentinel_droneEnemy))
	{
		selfDistToTarget = Distance2D(self.origin, self.sentinel_droneEnemy.origin);
	}
	else
	{
		selfDistToTarget = 0;
	}
	goodDist = 0.5 * sentinel_GetEngagementDistMin() + sentinel_GetEngagementDistMax();
	closeDist = 1.2 * goodDist;
	farDist = 3 * goodDist;
	queryMultiplier = mapfloat(closeDist, farDist, 1, 3, selfDistToTarget);
	preferedHeightRange = 0.5 * sentinel_GetEngagementHeightMax() + sentinel_GetEngagementHeightMin();
	randomness = 20;
	SENTINEL_DRONE_TOO_CLOSE_TO_SELF_DIST_EX = GetDvarInt("SENTINEL_DRONE_TOO_CLOSE_TO_SELF_DIST_EX", 70);
	SENTINEL_DRONE_MOVE_DIST_MAX_EX = GetDvarInt("SENTINEL_DRONE_MOVE_DIST_MAX_EX", 600);
	SENTINEL_DRONE_MOVE_SPACING = GetDvarInt("SENTINEL_DRONE_MOVE_SPACING", 25);
	SENTINEL_DRONE_RADIUS_EX = GetDvarInt("SENTINEL_DRONE_RADIUS_EX", 35);
	SENTINEL_DRONE_HIGHT_EX = GetDvarInt("SENTINEL_DRONE_HIGHT_EX", Int(preferedHeightRange));
	spacing_multiplier = 1.5;
	query_min_dist = self.settings.engagementDistMin;
	query_max_dist = SENTINEL_DRONE_MOVE_DIST_MAX_EX;
	if(!isdefined(b_do_not_chase_enemy) && b_do_not_chase_enemy && isdefined(self.sentinel_droneEnemy) && GetTime() > self.targetPlayerTime)
	{
		charge_at_position = self.sentinel_droneEnemy.origin + VectorScale((0, 0, 1), 48);
		if(!IsPointInNavvolume(charge_at_position, "navvolume_small"))
		{
			closest_point_on_nav_volume = GetDvarInt("closest_point_on_nav_volume", 120);
			charge_at_position = self GetClosestPointOnNavVolume(charge_at_position, closest_point_on_nav_volume);
		}
		if(!isdefined(charge_at_position))
		{
			queryResult = PositionQuery_Source_Navigation(self.origin, SENTINEL_DRONE_TOO_CLOSE_TO_SELF_DIST_EX, SENTINEL_DRONE_MOVE_DIST_MAX_EX * queryMultiplier, SENTINEL_DRONE_HIGHT_EX * queryMultiplier, SENTINEL_DRONE_MOVE_SPACING, "navvolume_small", SENTINEL_DRONE_MOVE_SPACING * spacing_multiplier);
		}
		else if(sentinel_IsEnemyInNarrowPlace())
		{
			spacing_multiplier = 1;
			SENTINEL_DRONE_MOVE_SPACING = 15;
			query_min_dist = self.settings.engagementDistMin * GetDvarFloat("sentinel_query_min_dist", 0.2);
			query_max_dist = query_max_dist * 0.5;
		}
		else if(isdefined(self.in_compact_mode) && self.in_compact_mode || sentinel_IsEnemyIndoors())
		{
			spacing_multiplier = 1;
			SENTINEL_DRONE_MOVE_SPACING = 15;
			query_min_dist = self.settings.engagementDistMin * GetDvarFloat("sentinel_query_min_dist", 0.5);
		}
		queryResult = PositionQuery_Source_Navigation(charge_at_position, query_min_dist, query_max_dist * queryMultiplier, SENTINEL_DRONE_HIGHT_EX * queryMultiplier, SENTINEL_DRONE_MOVE_SPACING, "navvolume_small", SENTINEL_DRONE_MOVE_SPACING * spacing_multiplier);
	}
	else
	{
		queryResult = PositionQuery_Source_Navigation(self.origin, SENTINEL_DRONE_TOO_CLOSE_TO_SELF_DIST_EX, SENTINEL_DRONE_MOVE_DIST_MAX_EX * queryMultiplier, SENTINEL_DRONE_HIGHT_EX * queryMultiplier, SENTINEL_DRONE_MOVE_SPACING, "navvolume_small", SENTINEL_DRONE_MOVE_SPACING * spacing_multiplier);
	}
	PositionQuery_Filter_DistanceToGoal(queryResult, self);
	vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor(queryResult);
	if(isdefined(self.sentinel_droneEnemy))
	{
		if(RandomInt(100) > 15)
		{
			self vehicle_ai::PositionQuery_Filter_EngagementDist(queryResult, self.sentinel_droneEnemy, sentinel_GetEngagementDistMin(), sentinel_GetEngagementDistMax());
		}
		goalHeight = self.sentinel_droneEnemy.origin[2] + 0.5 * sentinel_GetEngagementHeightMin() + sentinel_GetEngagementHeightMax();
		enemy_origin = self.sentinel_droneEnemy.origin + VectorScale((0, 0, 1), 48);
	}
	else
	{
		goalHeight = self.origin[2] + 0.5 * sentinel_GetEngagementHeightMin() + sentinel_GetEngagementHeightMax();
		enemy_origin = self.origin;
	}
	best_point = undefined;
	best_score = undefined;
	trace_count = 0;
	foreach(point in queryResult.data)
	{
		if(sentinel_IsInsideEngagementDistance(enemy_origin, point.origin))
		{
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = 25;
			#/
			point.score = point.score + 25;
		}
		/#
			if(!isdefined(point._scoreDebug))
			{
				point._scoreDebug = [];
			}
			point._scoreDebug["Dev Block strings are not supported"] = RandomFloatRange(0, randomness);
		#/
		point.score = point.score + RandomFloatRange(0, randomness);
		if(isdefined(point.distAwayFromEngagementArea))
		{
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = point.distAwayFromEngagementArea * -1;
			#/
			point.score = point.score + point.distAwayFromEngagementArea * -1;
		}
		is_near_another_sentinel = Sentinel_IsNearAnotherSentinel(point.origin, 200);
		if(isdefined(is_near_another_sentinel) && is_near_another_sentinel)
		{
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = -200;
			#/
			point.score = point.score + -200;
		}
		is_overlap_another_sentinel = Sentinel_IsNearAnotherSentinel(point.origin, 100);
		if(isdefined(is_overlap_another_sentinel) && is_overlap_another_sentinel)
		{
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = -2000;
			#/
			point.score = point.score + -2000;
		}
		is_near_another_player = sentinel_IsNearAnotherPlayer(point.origin, 150);
		if(isdefined(is_near_another_player) && is_near_another_player)
		{
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = -200;
			#/
			point.score = point.score + -200;
		}
		distFromPreferredHeight = Abs(point.origin[2] - goalHeight);
		if(distFromPreferredHeight > preferedHeightRange)
		{
			heightScore = distFromPreferredHeight - preferedHeightRange * 3;
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = heightScore * -1;
			#/
			point.score = point.score + heightScore * -1;
		}
		if(!isdefined(best_score))
		{
			best_score = point.score;
			best_point = point;
			if(isdefined(self.sentinel_droneEnemy))
			{
				best_point.visibile = Int(BulletTracePassed(point.origin, enemy_origin, 0, self, self.sentinel_droneEnemy));
			}
			else
			{
				best_point.visibile = Int(BulletTracePassed(point.origin, enemy_origin, 0, self));
			}
			continue;
		}
		if(point.score > best_score)
		{
			if(isdefined(self.sentinel_droneEnemy))
			{
				point.visibile = Int(BulletTracePassed(point.origin, enemy_origin, 0, self, self.sentinel_droneEnemy));
			}
			else
			{
				point.visibile = Int(BulletTracePassed(point.origin, enemy_origin, 0, self));
			}
			if(point.visibile >= best_point.visibile)
			{
				best_score = point.score;
				best_point = point;
			}
		}
	}
	if(isdefined(best_point))
	{
		if(best_point.score < -1000)
		{
			best_point = undefined;
		}
	}
	self vehicle_ai::PositionQuery_DebugScores(queryResult);
	/#
		if(isdefined(GetDvarInt("Dev Block strings are not supported")) && GetDvarInt("Dev Block strings are not supported"))
		{
			if(isdefined(best_point))
			{
				recordLine(self.origin, best_point.origin, (0.3, 1, 0));
			}
			if(isdefined(self.sentinel_droneEnemy))
			{
				recordLine(self.origin, self.sentinel_droneEnemy.origin, (1, 0, 0.4));
			}
		}
	#/
	returnData = [];
	if(isdefined(best_point))
	{
	}
	else
	{
	}
	returnData["origin"] = undefined;
	returnData["centerOnNav"] = queryResult.centerOnNav;
	return returnData;
}

/*
	Name: sentinel_ChargeAtPlayerNavigation
	Namespace: sentinel_drone
	Checksum: 0x55ED72B4
	Offset: 0x44E0
	Size: 0x38B
	Parameters: 3
	Flags: None
*/
function sentinel_ChargeAtPlayerNavigation(b_charge_at_player, time_out, charge_at_position)
{
	self endon("change_state");
	self endon("death");
	if(isdefined(time_out))
	{
		max_charge_time = GetTime() + time_out;
	}
	if(!isdefined(charge_at_position))
	{
		if(isdefined(b_charge_at_player) && b_charge_at_player)
		{
			charge_at_position = self.sentinel_droneEnemy.origin + VectorScale((0, 0, 1), 48);
		}
		else
		{
			sentinel_dir = AnglesToForward(self.angles);
			charge_at_position = self.origin + sentinel_dir * length(self.sentinel_droneEnemy.origin - self.origin);
			charge_at_position = (charge_at_position[0], charge_at_position[1], self.sentinel_droneEnemy.origin[2]);
		}
	}
	charge_at_dir = VectorNormalize(charge_at_position - self.origin);
	charge_at_position = self.origin + charge_at_dir * 1200;
	self ClearLookAtEnt();
	self SetVehGoalPos(charge_at_position, 1, 0);
	self SetLookAtOrigin(charge_at_position);
	while(1)
	{
		velocity = self GetVelocity() * 0.1;
		velocityMag = length(velocity);
		if(velocityMag < 1)
		{
			velocityMag = 1;
		}
		predicted_pos = self.origin + velocity;
		offset = VectorNormalize(predicted_pos - self.origin) * 35;
		trace = sentinel_Trace(self.origin + offset, predicted_pos + offset, self, 1);
		if(trace["fraction"] < 1)
		{
			if(!(isdefined(trace["entity"]) && trace["entity"].archetype === "zombie" && isdefined(trace["entity"].health) && trace["entity"].health == 0))
			{
				sentinel_KillMyself();
				return;
			}
		}
		if(isdefined(max_charge_time) && GetTime() > max_charge_time)
		{
			sentinel_KillMyself();
			return;
		}
		wait(0.1);
	}
}

/*
	Name: sentinel_PathUpdateInterrupt
	Namespace: sentinel_drone
	Checksum: 0x2C5250A9
	Offset: 0x4878
	Size: 0x137
	Parameters: 0
	Flags: None
*/
function sentinel_PathUpdateInterrupt()
{
	self endon("death");
	self endon("change_state");
	self endon("near_goal");
	self endon("reached_end_node");
	self notify("sentinel_PathUpdateInterrupt");
	self endon("sentinel_PathUpdateInterrupt");
	skip_sentinel_PathUpdateInterrupt = GetDvarInt("skip_sentinel_PathUpdateInterrupt", 1);
	if(skip_sentinel_PathUpdateInterrupt == 1)
	{
		return;
	}
	wait(1);
	while(1)
	{
		if(isdefined(self.current_pathto_pos))
		{
			if(Distance2DSquared(self.origin, self.goalpos) < self.goalRadius * self.goalRadius)
			{
				/#
					if(GetDvarInt("Dev Block strings are not supported") > 0)
					{
						RecordSphere(self.origin, 30, (1, 0, 0));
					}
				#/
				wait(0.2);
				self notify("near_goal");
			}
		}
		wait(0.2);
	}
}

/*
	Name: sentine_RumbleWhenNearPlayer
	Namespace: sentinel_drone
	Checksum: 0x3CC00F00
	Offset: 0x49B8
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function sentine_RumbleWhenNearPlayer()
{
	self endon("death");
	self endon("change_state");
	while(1)
	{
		while(sentinel_IsNearAnotherPlayer(self.origin, 120))
		{
			self PlayRumbleOnEntity("damage_heavy");
			wait(0.1);
		}
		wait(0.5);
	}
}

/*
	Name: sentinel_CanSeeEnemy
	Namespace: sentinel_drone
	Checksum: 0x3DA810D
	Offset: 0x4A38
	Size: 0x687
	Parameters: 2
	Flags: None
*/
function sentinel_CanSeeEnemy(sentinel_origin, prev_enemy_position)
{
	result = spawnstruct();
	result.can_see_enemy = 0;
	enemy_moved = 0;
	b_still_enemy_in_pos_check = 0;
	origin_point = sentinel_origin;
	if(!isdefined(prev_enemy_position))
	{
		target_point = self.sentinel_droneEnemy.origin + VectorScale((0, 0, 1), 48);
		if(isPlayer(self.sentinel_droneEnemy))
		{
			enemy_stance = self.sentinel_droneEnemy GetStance();
			if(enemy_stance == "prone")
			{
				target_point = self.sentinel_droneEnemy.origin + VectorScale((0, 0, 1), 2);
			}
		}
	}
	else
	{
		b_still_enemy_in_pos_check = 1;
		target_point = prev_enemy_position;
	}
	forward_vect = AnglesToForward(self.angles);
	vect_to_enemy = target_point - origin_point;
	if(VectorDot(forward_vect, vect_to_enemy) <= 0)
	{
		if(!b_still_enemy_in_pos_check)
		{
			return result;
		}
		else
		{
			enemy_moved = 1;
		}
	}
	if(!(isdefined(enemy_moved) && enemy_moved))
	{
		right_vect = AnglesToRight(self.angles);
		vect_to_enemy_2d = (vect_to_enemy[0], vect_to_enemy[1], 0);
		projected_distance = VectorDot(vect_to_enemy_2d, right_vect);
		if(Abs(projected_distance) > 50)
		{
			if(!b_still_enemy_in_pos_check)
			{
				return result;
			}
			else
			{
				enemy_moved = 1;
			}
		}
	}
	if(b_still_enemy_in_pos_check)
	{
		beam_to_enemy_length = Distance(target_point, origin_point);
		beam_to_enemy_dir = target_point - origin_point;
		beam_to_enemy_dir = VectorNormalize(beam_to_enemy_dir);
		target_point = origin_point + VectorScale(beam_to_enemy_dir, 1200);
	}
	trace = sentinel_Trace(origin_point, target_point, self.sentinel_droneEnemy, 0);
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			recordLine(origin_point, target_point, (0, 1, 0));
			RecordSphere(target_point, 8);
		}
	#/
	result.hit_entity = trace["entity"];
	result.hit_position = trace["position"];
	if(isPlayer(trace["entity"]) || (isdefined(self.should_buff_zombies) && self.should_buff_zombies && isdefined(trace["entity"]) && isdefined(trace["entity"].archetype) && trace["entity"].archetype == "zombie"))
	{
		result.can_see_enemy = 1;
		return result;
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			if(isdefined(trace["Dev Block strings are not supported"]) && isdefined(trace["Dev Block strings are not supported"].archetype) && trace["Dev Block strings are not supported"].archetype == "Dev Block strings are not supported" && !isalive(trace["Dev Block strings are not supported"]))
			{
				PrintTopRightln("Dev Block strings are not supported" + trace["Dev Block strings are not supported"] GetEntityNumber() + "Dev Block strings are not supported" + GetTime());
				recordLine(origin_point, trace["Dev Block strings are not supported"], (1, 0, 0));
				RecordSphere(trace["Dev Block strings are not supported"], 8, (1, 0, 0));
			}
		}
	#/
	if(isdefined(trace["entity"]) && isdefined(trace["entity"].archetype) && trace["entity"].archetype == "zombie" && !isalive(trace["entity"]))
	{
		trace = sentinel_Trace(origin_point, target_point, self.sentinel_droneEnemy, 0, 1);
		if(trace["fraction"] == 1)
		{
			result.hit_entity = self.sentinel_droneEnemy;
			result.hit_position = target_point;
			result.can_see_enemy = 1;
		}
	}
	return result;
}

/*
	Name: sentinel_FireLogic
	Namespace: sentinel_drone
	Checksum: 0x5C61CF52
	Offset: 0x50C8
	Size: 0x65B
	Parameters: 0
	Flags: None
*/
function sentinel_FireLogic()
{
	if(isdefined(self.playing_intro_anim) && self.playing_intro_anim)
	{
		return 0;
	}
	if(self.arms_count <= 0)
	{
		return 0;
	}
	if(!(isdefined(self.target_initialized) && self.target_initialized))
	{
		wait(0.5);
		return 0;
	}
	if(isdefined(self.sentinel_droneEnemy) && (!isdefined(self.nextFireTime) || GetTime() > self.nextFireTime))
	{
		if(isdefined(self.b_in_tactical_position) && self.b_in_tactical_position && (isdefined(self.in_compact_mode) && self.in_compact_mode || sentinel_IsEnemyIndoors()) || (sentinel_IsInsideEngagementDistance(self.origin, self.sentinel_droneEnemy.origin + VectorScale((0, 0, 1), 48), 1) && IsPointInNavvolume(self.origin, "navvolume_small")) && !Sentinel_IsNearAnotherSentinel(self.origin, 100))
		{
			result = sentinel_CanSeeEnemy(self.origin);
			if(result.can_see_enemy)
			{
				self.nextFireTime = GetTime() + 2500 + RandomInt(2500);
				sentinel_NavigationStandStill();
				wait(0.1);
				if(!isdefined(self.sentinel_droneEnemy))
				{
					return 1;
				}
				enemy_pos = self.sentinel_droneEnemy.origin;
				if(RandomInt(100) < 70)
				{
					b_succession = 1;
				}
				self.beam_start_position = self.origin;
				if(isdefined(b_succession) && b_succession)
				{
					fire_state_name = "fire_succession@attack";
				}
				else
				{
					fire_state_name = "fire@attack";
				}
				self ASMRequestSubstate(fire_state_name);
				self clientfield::set("sentinel_drone_beam_charge", 1);
				beam_dir = result.hit_position - self.origin;
				self.beam_fire_target.origin = result.hit_position;
				self.beam_fire_target.angles = VectorToAngles(beam_dir * -1);
				/#
					if(GetDvarInt("Dev Block strings are not supported") > 0)
					{
						recordLine(self.origin, result.hit_position, (0.9, 0.7, 0.6));
						RecordSphere(result.hit_position, 8, (0.9, 0.7, 0.6));
					}
				#/
				self ClearLookAtEnt();
				self.angles = VectorToAngles(beam_dir);
				self SetLookAtEnt(self.beam_fire_target);
				self SetTurretTargetEnt(self.beam_fire_target);
				self waittill("fire_beam");
				self clientfield::set("sentinel_drone_beam_charge", 0);
				result = sentinel_CanSeeEnemy(self.beam_start_position, result.hit_position);
				if(result.can_see_enemy)
				{
					if(!isdefined(b_succession) && b_succession && isPlayer(result.hit_entity))
					{
						result.hit_entity thread sentinel_DamagePlayer(Int(50), self);
					}
					sentinel_FireBeam(result.hit_position, b_succession);
				}
				else
				{
					sentinel_FireBeam(result.hit_position, b_succession);
				}
				self vehicle_ai::waittill_asm_complete(fire_state_name, 5);
				if(isdefined(self.sentinel_droneEnemy))
				{
					self SetLookAtEnt(self.sentinel_droneEnemy);
					self SetTurretTargetEnt(self.sentinel_droneEnemy);
				}
				self ASMRequestSubstate("locomotion@movement");
				if(RandomInt(100) < 40)
				{
					sentinel_changeSentinelPosition();
				}
				if(RandomInt(100) < 30)
				{
					self.nextFireTime = GetTime() + 2500 + RandomInt(2500);
				}
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: sentinel_FireBeam
	Namespace: sentinel_drone
	Checksum: 0x3B11866D
	Offset: 0x5730
	Size: 0x147
	Parameters: 2
	Flags: None
*/
function sentinel_FireBeam(target_position, b_succession)
{
	self endon("change_state");
	self endon("disconnect");
	self endon("death");
	self endon("death_state_activated");
	self.lastTimeFired = GetTime();
	beam_dir = target_position - self.origin;
	self.beam_fire_target.origin = target_position;
	self.beam_fire_target.angles = VectorToAngles(beam_dir * -1);
	self.angles = VectorToAngles(beam_dir);
	self SetTurretTargetEnt(self.beam_fire_target);
	self.is_firing_beam = 1;
	if(!(isdefined(b_succession) && b_succession))
	{
		sentinel_FireBeamBurst(target_position);
	}
	else
	{
		sentinel_FireBeamSuccession(target_position);
	}
	self.is_firing_beam = 0;
}

/*
	Name: sentinel_FireBeamBurst
	Namespace: sentinel_drone
	Checksum: 0xD1942439
	Offset: 0x5880
	Size: 0x1AD
	Parameters: 1
	Flags: None
*/
function sentinel_FireBeamBurst(target_position)
{
	self endon("change_state");
	self endon("disconnect");
	self endon("death");
	self endon("death_state_activated");
	for(i = 1; i <= 3; i++)
	{
		if(self.sentinelDroneHealthArms[i] <= 0)
		{
			continue;
		}
		self clientfield::set("sentinel_drone_beam_fire" + i, 1);
	}
	wait(0.1);
	start_beam_time = GetTime() + 2000;
	beam_damage_update = 0.1;
	player_damage = Int(100 * beam_damage_update);
	while(GetTime() < start_beam_time || (isdefined(self.sentinel_DebugFX_PlayAll) && self.sentinel_DebugFX_PlayAll))
	{
		sentinel_DamageBeamTouchingEntity(player_damage, target_position);
		wait(beam_damage_update);
	}
	for(i = 1; i <= 3; i++)
	{
		if(self.sentinelDroneHealthArms[i] <= 0)
		{
			continue;
		}
		self clientfield::set("sentinel_drone_beam_fire" + i, 0);
	}
}

/*
	Name: sentinel_FireBeamSuccession
	Namespace: sentinel_drone
	Checksum: 0xCF2E17C7
	Offset: 0x5A38
	Size: 0x1D5
	Parameters: 1
	Flags: None
*/
function sentinel_FireBeamSuccession(target_position)
{
	self endon("change_state");
	self endon("disconnect");
	self endon("death");
	self endon("death_state_activated");
	player_damage = Int(30);
	arms_order = [];
	arms_order[0] = 2;
	arms_order[1] = 1;
	arms_order[2] = 3;
	arms_notifies = [];
	arms_notifies[0] = "attack_quick_left";
	arms_notifies[1] = "attack_quick_right";
	arms_notifies[2] = "attack_quick_top";
	for(i = 0; i < 3; i++)
	{
		if(self.sentinelDroneHealthArms[arms_order[i]] <= 0)
		{
			continue;
		}
		self util::waittill_any_timeout(0.3, arms_notifies[i]);
		self clientfield::set("sentinel_drone_beam_fire" + arms_order[i], 1);
		sentinel_DamageBeamTouchingEntity(player_damage, target_position, 1);
		wait(0.1);
		self clientfield::set("sentinel_drone_beam_fire" + arms_order[i], 0);
	}
}

/*
	Name: sentinel_DamageBeamTouchingEntity
	Namespace: sentinel_drone
	Checksum: 0x1F50650F
	Offset: 0x5C18
	Size: 0x1EB
	Parameters: 3
	Flags: None
*/
function sentinel_DamageBeamTouchingEntity(player_damage, target_position, b_succession)
{
	if(!isdefined(b_succession))
	{
		b_succession = 0;
	}
	trace = sentinel_Trace(self.origin, target_position, self.sentinel_droneEnemy, 0);
	trace_entity = trace["entity"];
	if(isdefined(trace["entity"]) && isdefined(trace["entity"].archetype) && trace["entity"].archetype == "zombie" && !isalive(trace["entity"]))
	{
		trace = sentinel_Trace(self.origin, target_position, self.sentinel_droneEnemy, 0, 1);
		if(trace["fraction"] == 1)
		{
			trace_entity = self.sentinel_droneEnemy;
		}
	}
	if(isPlayer(trace_entity))
	{
		trace_entity thread sentinel_DamagePlayer(player_damage, self, b_succession);
	}
	else if(isdefined(trace_entity) && isdefined(trace_entity.archetype) && trace_entity.archetype == "zombie")
	{
		self thread sentinel_ElectrifyZombie(trace_entity.origin, trace_entity, 80);
	}
}

/*
	Name: sentinel_SelfDestruct
	Namespace: sentinel_drone
	Checksum: 0xD25584EE
	Offset: 0x5E10
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function sentinel_SelfDestruct(time)
{
	self endon("change_state");
	self endon("disconnect");
	self endon("death");
	self endon("death_state_activated");
	wait(time);
	sentinel_KillMyself();
}

/*
	Name: sentinel_ChargeAtPlayer
	Namespace: sentinel_drone
	Checksum: 0xC33A9AD4
	Offset: 0x5E70
	Size: 0x1F7
	Parameters: 0
	Flags: None
*/
function sentinel_ChargeAtPlayer()
{
	if(!isdefined(self))
	{
		return;
	}
	self endon("change_state");
	self endon("disconnect");
	self endon("death");
	self endon("death_state_activated");
	wait(0.3);
	self.is_charging_at_player = 1;
	self sentinel_NavigationStandStill();
	sentinel_play_taunt(level._sentinel_System_Critical_Taunts);
	charge_at_position = self.sentinel_droneEnemy.origin + VectorScale((0, 0, 1), 48);
	self ASMRequestSubstate("suicide_intro@death");
	wait(2);
	if(self.sentinelDroneHealthCamera <= 0)
	{
		b_charge_at_player = 0;
	}
	else
	{
		charge_at_position = undefined;
		b_charge_at_player = 1;
	}
	self ASMRequestSubstate("suicide_charge@death");
	self SetSpeed(60);
	self thread sentinel_ChargeAtPlayerNavigation(b_charge_at_player, 4000, charge_at_position);
	detonation_distance_sq = 10000;
	while(isdefined(self) && isdefined(self.sentinel_droneEnemy))
	{
		distance_sq = DistanceSquared(self.sentinel_droneEnemy.origin + VectorScale((0, 0, 1), 48), self.origin);
		if(distance_sq <= detonation_distance_sq)
		{
			sentinel_KillMyself();
		}
		wait(0.2);
	}
}

/*
	Name: IsLeftArm
	Namespace: sentinel_drone
	Checksum: 0xCCFA80C
	Offset: 0x6070
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function IsLeftArm(part_name)
{
	if(!isdefined(part_name))
	{
		return 0;
	}
	return IsSubStr(part_name, "tag_arm_left");
}

/*
	Name: IsRightArm
	Namespace: sentinel_drone
	Checksum: 0x2ED068B9
	Offset: 0x60B0
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function IsRightArm(part_name)
{
	if(!isdefined(part_name))
	{
		return 0;
	}
	return IsSubStr(part_name, "tag_arm_right");
}

/*
	Name: IsTopArm
	Namespace: sentinel_drone
	Checksum: 0xDBDDC3D5
	Offset: 0x60F0
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function IsTopArm(part_name)
{
	if(!isdefined(part_name))
	{
		return 0;
	}
	return IsSubStr(part_name, "tag_arm_top");
}

/*
	Name: IsCore
	Namespace: sentinel_drone
	Checksum: 0x262EDB5D
	Offset: 0x6130
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function IsCore(part_name)
{
	if(!isdefined(part_name))
	{
		return 0;
	}
	if(part_name == "tag_faceplate_d0" || part_name == "ag_core_d0" || part_name == "tag_center_core" || part_name == "tag_core_spin")
	{
		return 1;
	}
	return 0;
}

/*
	Name: IsCamera
	Namespace: sentinel_drone
	Checksum: 0xBE33B815
	Offset: 0x61A0
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function IsCamera(part_name)
{
	if(!isdefined(part_name))
	{
		return 0;
	}
	if(part_name == "tag_camera_dead" || part_name == "tag_flash" || part_name == "tag_laser" || part_name == "tag_turret")
	{
		return 1;
	}
	return 0;
}

/*
	Name: sentinel_GetArmNumber
	Namespace: sentinel_drone
	Checksum: 0x33634F31
	Offset: 0x6210
	Size: 0x7D
	Parameters: 1
	Flags: None
*/
function sentinel_GetArmNumber(part_name)
{
	if(!isdefined(part_name))
	{
		return 0;
	}
	if(IsLeftArm(part_name))
	{
		return 2;
	}
	else if(IsRightArm(part_name))
	{
		return 1;
	}
	else if(IsTopArm(part_name))
	{
		return 3;
	}
	return 0;
}

/*
	Name: sentinel_ArmDamage
	Namespace: sentinel_drone
	Checksum: 0xC184B465
	Offset: 0x6298
	Size: 0x2D5
	Parameters: 3
	Flags: Private
*/
function private sentinel_ArmDamage(damage, arm, eAttacker)
{
	if(!isdefined(eAttacker))
	{
		eAttacker = undefined;
	}
	if(self.arms_count == 0)
	{
		return;
	}
	if(arm == 0 || damage == 0)
	{
		return;
	}
	if(self.sentinelDroneHealthArms[arm] <= 0)
	{
		return;
	}
	self.sentinelDroneHealthArms[arm] = self.sentinelDroneHealthArms[arm] - damage;
	if(self.sentinelDroneHealthArms[arm] <= 0)
	{
		self.arms_count--;
		if(isPlayer(eAttacker))
		{
			if(!isdefined(self.e_arms_attacker) && self.arms_count == 2)
			{
				self.e_arms_attacker = eAttacker;
				self.b_same_arms_attacker = 1;
			}
			else if(self.e_arms_attacker !== eAttacker)
			{
				self.b_same_arms_attacker = 0;
			}
		}
		self clientfield::set("sentinel_drone_arm_cut_" + arm, 1);
		if(arm == 2)
		{
			self HidePart("tag_arm_left_01", "", 1);
			self ShowPart("tag_arm_left_01_d1", "", 1);
		}
		else if(arm == 1)
		{
			self HidePart("tag_arm_right_01", "", 1);
			self ShowPart("tag_arm_right_01_d1", "", 1);
		}
		else if(arm == 3)
		{
			self HidePart("tag_arm_top_01", "", 1);
			self ShowPart("tag_arm_top_01_d1", "", 1);
		}
		if(self.arms_count == 0 && (!isdefined(self.disable_charge_when_no_arms) && self.disable_charge_when_no_arms))
		{
			sentinel_OnAllArmsDestroyed();
			if(isPlayer(eAttacker))
			{
				level notify("all_sentinel_arms_destroyed", self.b_same_arms_attacker, eAttacker);
			}
		}
	}
}

/*
	Name: sentinel_DestroyAllArms
	Namespace: sentinel_drone
	Checksum: 0xC77BA67F
	Offset: 0x6578
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function sentinel_DestroyAllArms(b_disable_charge)
{
	self.disable_charge_when_no_arms = isdefined(b_disable_charge) && b_disable_charge;
	sentinel_ArmDamage(self.sentinelDroneHealthArms[2] + 1000, 2);
	sentinel_ArmDamage(self.sentinelDroneHealthArms[1] + 1000, 1);
	sentinel_ArmDamage(self.sentinelDroneHealthArms[3] + 1000, 3);
}

/*
	Name: sentinel_OnAllArmsDestroyed
	Namespace: sentinel_drone
	Checksum: 0xE24824B6
	Offset: 0x6620
	Size: 0x43
	Parameters: 0
	Flags: Private
*/
function private sentinel_OnAllArmsDestroyed()
{
	sentinel_DestroyFace();
	sentinel_DestroyCore();
	wait(0.1);
	self thread sentinel_ChargeAtPlayer();
}

/*
	Name: sentinel_DestroyFace
	Namespace: sentinel_drone
	Checksum: 0x27D97A9F
	Offset: 0x6670
	Size: 0x2B
	Parameters: 0
	Flags: Private
*/
function private sentinel_DestroyFace()
{
	sentinel_FaceDamage(self.sentinelDroneHealthFace + 1000, "tag_faceplate_d0");
}

/*
	Name: sentinel_DestroyCore
	Namespace: sentinel_drone
	Checksum: 0x27686850
	Offset: 0x66A8
	Size: 0x2B
	Parameters: 0
	Flags: Private
*/
function private sentinel_DestroyCore()
{
	sentinel_CoreDamage(self.sentinelDroneHealthCore + 1000, "ag_core_d0");
}

/*
	Name: sentinel_FaceDamage
	Namespace: sentinel_drone
	Checksum: 0xC591878D
	Offset: 0x66E0
	Size: 0xBB
	Parameters: 2
	Flags: Private
*/
function private sentinel_FaceDamage(damage, partName)
{
	if(damage == 0)
	{
		return;
	}
	if(self.sentinelDroneHealthFace <= 0)
	{
		return;
	}
	if(!isdefined(partName) || partName != "tag_faceplate_d0")
	{
		return;
	}
	self.sentinelDroneHealthFace = self.sentinelDroneHealthFace - damage;
	if(self.sentinelDroneHealthFace <= 0)
	{
		self clientfield::set("sentinel_drone_face_cut", 1);
		self HidePart("tag_faceplate_d0", "", 1);
	}
}

/*
	Name: sentinel_CoreDamage
	Namespace: sentinel_drone
	Checksum: 0x8B39CC62
	Offset: 0x67A8
	Size: 0xD3
	Parameters: 2
	Flags: Private
*/
function private sentinel_CoreDamage(damage, partName)
{
	if(damage == 0)
	{
		return;
	}
	if(self.sentinelDroneHealthFace > 0)
	{
		return;
	}
	if(self.sentinelDroneHealthCore <= 0)
	{
		return;
	}
	if(!IsCore(partName))
	{
		return;
	}
	self.sentinelDroneHealthCore = self.sentinelDroneHealthCore - damage;
	if(self.sentinelDroneHealthCore <= 0)
	{
		self HidePart("tag_center_core_emmisive_blue", "", 1);
		self ShowPart("tag_center_core_emmisive_red", "", 1);
	}
}

/*
	Name: sentinel_CameraDamage
	Namespace: sentinel_drone
	Checksum: 0x866361B
	Offset: 0x6888
	Size: 0x165
	Parameters: 3
	Flags: Private
*/
function private sentinel_CameraDamage(damage, partName, eAttacker)
{
	if(damage == 0)
	{
		return;
	}
	if(self.sentinelDroneHealthCamera <= 0)
	{
		return;
	}
	if(!IsCamera(partName))
	{
		return;
	}
	self.sentinelDroneHealthCamera = self.sentinelDroneHealthCamera - damage;
	if(self.sentinelDroneHealthCamera <= 0)
	{
		self HidePart("tag_turret", "", 1);
		self ShowPart("Tag_camera_dead", "", 1);
		self clientfield::set("sentinel_drone_camera_destroyed", 1);
		sentinel_DestroyFace();
		sentinel_DestroyCore();
		self thread sentinel_SelfDestruct(2000);
		self thread sentinel_ChargeAtPlayer();
		if(isPlayer(eAttacker))
		{
			level notify("sentinel_camera_destroyed", eAttacker);
		}
	}
}

/*
	Name: sentinel_CallbackDamage
	Namespace: sentinel_drone
	Checksum: 0xFF900459
	Offset: 0x69F8
	Size: 0x267
	Parameters: 15
	Flags: None
*/
function sentinel_CallbackDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	if(isdefined(eAttacker) && eAttacker.archetype === "sentinel_drone")
	{
		return 0;
	}
	if(isdefined(eInflictor) && eInflictor.archetype === "sentinel_drone")
	{
		return 0;
	}
	if(isdefined(eAttacker) && isdefined(eAttacker.team) && isdefined(level.zombie_vars) && isdefined(level.zombie_vars[eAttacker.team]) && (isdefined(level.zombie_vars[eAttacker.team]["zombie_insta_kill"]) && level.zombie_vars[eAttacker.team]["zombie_insta_kill"]))
	{
		iDamage = iDamage * 4;
	}
	if(self.sentinelDroneHealthFace <= 0 && IsCore(partName))
	{
		iDamage = iDamage * 2;
	}
	if(GetTime() > self.nextRollTime)
	{
		if(math::cointoss())
		{
			self.shouldRoll = 1;
		}
		else
		{
			self.nextRollTime = GetTime() + RandomInt(3000);
		}
	}
	thread sentinel_ArmDamage(iDamage, sentinel_GetArmNumber(partName), eAttacker);
	thread sentinel_FaceDamage(iDamage, partName);
	thread sentinel_CameraDamage(iDamage, partName, eAttacker);
	return iDamage;
}

/*
	Name: sentinel_drone_CallbackRadiusDamage
	Namespace: sentinel_drone
	Checksum: 0x4A936EBE
	Offset: 0x6C68
	Size: 0x117
	Parameters: 13
	Flags: None
*/
function sentinel_drone_CallbackRadiusDamage(eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, psOffsetTime)
{
	if(isdefined(eAttacker) && eAttacker.archetype === "sentinel_drone")
	{
		return 0;
	}
	if(isdefined(eInflictor) && eInflictor.archetype === "sentinel_drone")
	{
		return 0;
	}
	if(GetTime() > self.nextRollTime)
	{
		if(math::cointoss())
		{
			self.shouldRoll = 1;
		}
		else
		{
			self.nextRollTime = GetTime() + 3000 + RandomInt(4000);
		}
	}
	return iDamage;
}

/*
	Name: state_death_update
	Namespace: sentinel_drone
	Checksum: 0x8E60EF0F
	Offset: 0x6D88
	Size: 0x20B
	Parameters: 1
	Flags: None
*/
function state_death_update(params)
{
	self endon("death");
	self sentinel_RemoveFromLevelArray();
	self sentinel_DeactivateAllEffects();
	self ASMRequestSubstate("normal@death");
	set_sentinel_drone_enemy(undefined);
	self thread vehicle_death::death_fx();
	self.beam_fire_target thread sentinel_DeleteDroneDeathFX(self.origin);
	min_distance = 110;
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(!is_target_valid(players[i]))
		{
			continue;
		}
		MIN_DISTANCE_SQ = min_distance * min_distance;
		distance_sq = DistanceSquared(self.origin, players[i].origin + VectorScale((0, 0, 1), 48));
		if(distance_sq < MIN_DISTANCE_SQ)
		{
			players[i] sentinel_DamagePlayer(60, self);
		}
	}
	self sentinel_ElectrifyZombie(self.origin, undefined, 100);
	wait(0.1);
	self delete();
}

/*
	Name: sentinel_DeleteDroneDeathFX
	Namespace: sentinel_drone
	Checksum: 0xB6026089
	Offset: 0x6FA0
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function sentinel_DeleteDroneDeathFX(explosion_origin)
{
	self endon("disconnect");
	self endon("death");
	self.origin = explosion_origin;
	wait(0.1);
	self clientfield::set("sentinel_drone_deathfx", 1);
	wait(6);
	self delete();
}

/*
	Name: sentinel_ForceGoAndStayInPosition
	Namespace: sentinel_drone
	Checksum: 0x38D19739
	Offset: 0x7020
	Size: 0x4D
	Parameters: 2
	Flags: None
*/
function sentinel_ForceGoAndStayInPosition(b_enable, position)
{
	if(isdefined(b_enable) && b_enable)
	{
		self.forced_pos = position;
	}
	else
	{
		self.shouldRoll = 0;
		self.forced_pos = undefined;
	}
}

/*
	Name: sentinel_IsEnemyIndoors
	Namespace: sentinel_drone
	Checksum: 0xD8616208
	Offset: 0x7078
	Size: 0x6D
	Parameters: 0
	Flags: None
*/
function sentinel_IsEnemyIndoors()
{
	if(!isdefined(self.v_compact_mode))
	{
		v_compact_mode = GetEnt("sentinel_compact", "targetname");
	}
	if(isdefined(v_compact_mode))
	{
		if(self.sentinel_droneEnemy istouching(v_compact_mode))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: sentinel_IsEnemyInNarrowPlace
	Namespace: sentinel_drone
	Checksum: 0x6D114289
	Offset: 0x70F0
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function sentinel_IsEnemyInNarrowPlace()
{
	if(!isdefined(self.sentinel_droneEnemy))
	{
		return 0;
	}
	if(!isdefined(self.v_narrow_volume))
	{
		self.v_narrow_volume = GetEnt("sentinel_narrow_nav", "targetname");
	}
	if(isdefined(self.v_narrow_volume) && isdefined(self.sentinel_droneEnemy))
	{
		if(self.sentinel_droneEnemy istouching(self.v_narrow_volume))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: sentinel_SetCompactMode
	Namespace: sentinel_drone
	Checksum: 0xCD7C4B1
	Offset: 0x7188
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function sentinel_SetCompactMode(b_compact)
{
	if(isdefined(b_compact) && b_compact)
	{
		self.in_compact_mode = 1;
		blackboard::SetBlackBoardAttribute(self, "_stance", "crouch");
	}
	else
	{
		self.in_compact_mode = 0;
		blackboard::SetBlackBoardAttribute(self, "_stance", "stand");
	}
}

/*
	Name: sentinel_HideInitialBrokenParts
	Namespace: sentinel_drone
	Checksum: 0xD02A7E25
	Offset: 0x7220
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function sentinel_HideInitialBrokenParts()
{
	self endon("disconnect");
	self endon("death");
	wait(0.2);
	self HidePart("tag_arm_left_01_d1", "", 1);
	self HidePart("tag_arm_right_01_d1", "", 1);
	self HidePart("tag_arm_top_01_d1", "", 1);
	self HidePart("Tag_camera_dead", "", 1);
	self HidePart("tag_center_core_emmisive_red", "", 1);
}

/*
	Name: sentinel_KillMyself
	Namespace: sentinel_drone
	Checksum: 0xEDAD9CE3
	Offset: 0x7318
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function sentinel_KillMyself()
{
	self DoDamage(self.health + 100, self.origin);
}

/*
	Name: sentinel_GetEngagementDistMax
	Namespace: sentinel_drone
	Checksum: 0x76523226
	Offset: 0x7350
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function sentinel_GetEngagementDistMax()
{
	if(sentinel_IsEnemyInNarrowPlace())
	{
		return self.settings.engagementDistMin * 0.3;
	}
	else if(isdefined(self.in_compact_mode) && self.in_compact_mode)
	{
		return self.settings.engagementDistMax * 0.85;
	}
	return self.settings.engagementDistMax;
}

/*
	Name: sentinel_GetEngagementDistMin
	Namespace: sentinel_drone
	Checksum: 0x8D8280FC
	Offset: 0x73D8
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function sentinel_GetEngagementDistMin()
{
	if(sentinel_IsEnemyInNarrowPlace())
	{
		return self.settings.engagementDistMin * 0.2;
	}
	else if(isdefined(self.in_compact_mode) && self.in_compact_mode)
	{
		return self.settings.engagementDistMin * 0.5;
	}
	return self.settings.engagementDistMin;
}

/*
	Name: sentinel_GetEngagementHeightMax
	Namespace: sentinel_drone
	Checksum: 0xA2379A1F
	Offset: 0x7460
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function sentinel_GetEngagementHeightMax()
{
	if(isdefined(self.in_compact_mode) && self.in_compact_mode)
	{
		return self.settings.engagementHeightMax * 0.8;
	}
	return self.settings.engagementHeightMax;
}

/*
	Name: sentinel_GetEngagementHeightMin
	Namespace: sentinel_drone
	Checksum: 0xFB4D5505
	Offset: 0x74B0
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function sentinel_GetEngagementHeightMin()
{
	if(!isdefined(self.sentinel_droneEnemy))
	{
		return self.settings.engagementHeightMin * 3;
	}
	return self.settings.engagementHeightMin;
}

/*
	Name: sentinel_IsInsideEngagementDistance
	Namespace: sentinel_drone
	Checksum: 0x25A0A1F
	Offset: 0x74F0
	Size: 0x18D
	Parameters: 3
	Flags: None
*/
function sentinel_IsInsideEngagementDistance(origin, position, b_accept_negative_height)
{
	if(!(Distance2DSquared(position, origin) > sentinel_GetEngagementDistMin() * sentinel_GetEngagementDistMin() && Distance2DSquared(position, origin) < sentinel_GetEngagementDistMax() * sentinel_GetEngagementDistMax()))
	{
		return 0;
	}
	if(isdefined(b_accept_negative_height) && b_accept_negative_height)
	{
		return Abs(origin[2] - position[2]) >= sentinel_GetEngagementHeightMin() && Abs(origin[2] - position[2]) <= sentinel_GetEngagementHeightMax();
	}
	else
	{
		return position[2] - origin[2] >= sentinel_GetEngagementHeightMin() && position[2] - origin[2] <= sentinel_GetEngagementHeightMax();
	}
}

/*
	Name: sentinel_Trace
	Namespace: sentinel_drone
	Checksum: 0xFA832B01
	Offset: 0x7688
	Size: 0xDB
	Parameters: 5
	Flags: None
*/
function sentinel_Trace(start, end, ignore_ent, b_physics_trace, ignore_characters)
{
	if(isdefined(b_physics_trace) && b_physics_trace)
	{
		trace = PhysicsTrace(start, end, VectorScale((-1, -1, -1), 10), VectorScale((1, 1, 1), 10), self, 1 | 2);
		if(trace["fraction"] < 1)
		{
			return trace;
		}
	}
	trace = bullettrace(start, end, !isdefined(ignore_characters) && ignore_characters, self);
	return trace;
}

/*
	Name: sentinel_ElectrifyZombie
	Namespace: sentinel_drone
	Checksum: 0x29C62636
	Offset: 0x7770
	Size: 0x5B
	Parameters: 3
	Flags: None
*/
function sentinel_ElectrifyZombie(origin, zombie, radius)
{
	self endon("disconnect");
	self endon("death");
	if(isdefined(self.sentinel_ElectrifyZombie))
	{
		self thread [[self.sentinel_ElectrifyZombie]](origin, zombie, radius);
	}
}

/*
	Name: sentinel_DeactivateAllEffects
	Namespace: sentinel_drone
	Checksum: 0x1B67D9D3
	Offset: 0x77D8
	Size: 0x4D
	Parameters: 0
	Flags: None
*/
function sentinel_DeactivateAllEffects()
{
	for(i = 1; i <= 3; i++)
	{
		self clientfield::set("sentinel_drone_arm_cut_" + i, 0);
	}
}

/*
	Name: sentinel_DamagePlayer
	Namespace: sentinel_drone
	Checksum: 0xDC76E773
	Offset: 0x7830
	Size: 0x173
	Parameters: 3
	Flags: None
*/
function sentinel_DamagePlayer(damage, eAttacker, b_light_damage)
{
	if(!isdefined(b_light_damage))
	{
		b_light_damage = 0;
	}
	self notify("proximityGrenadeDamageStart");
	self endon("proximityGrenadeDamageStart");
	self endon("disconnect");
	self endon("death");
	eAttacker endon("disconnect");
	self DoDamage(damage, eAttacker.origin, eAttacker, eAttacker);
	if(b_light_damage)
	{
		self PlayRumbleOnEntity("damage_heavy");
	}
	else
	{
		self PlayRumbleOnEntity("proximity_grenade");
	}
	if(self util::mayApplyScreenEffect())
	{
		self clientfield::increment_to_player("sentinel_drone_damage_player_fx");
		if(b_light_damage)
		{
			self shellshock("electrocution_sentinel_drone", 0.5);
		}
		else
		{
			self shellshock("electrocution_sentinel_drone", 1);
		}
	}
}

/*
	Name: sentinel_RemoveFromLevelArray
	Namespace: sentinel_drone
	Checksum: 0x38C01283
	Offset: 0x79B0
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function sentinel_RemoveFromLevelArray()
{
	if(!isdefined(level.a_sentinel_drones))
	{
		return;
	}
	for(i = 0; i < level.a_sentinel_drones.size; i++)
	{
		if(level.a_sentinel_drones[i] == self)
		{
			level.a_sentinel_drones[i] = undefined;
			break;
		}
	}
	level.a_sentinel_drones = Array::remove_undefined(level.a_sentinel_drones);
}

/*
	Name: Sentinel_IsNearAnotherSentinel
	Namespace: sentinel_drone
	Checksum: 0xBFD4E364
	Offset: 0x7A40
	Size: 0xE7
	Parameters: 2
	Flags: None
*/
function Sentinel_IsNearAnotherSentinel(point, min_distance)
{
	if(!isdefined(level.a_sentinel_drones))
	{
		return 0;
	}
	for(i = 0; i < level.a_sentinel_drones.size; i++)
	{
		if(!isdefined(level.a_sentinel_drones[i]))
		{
			continue;
		}
		if(level.a_sentinel_drones[i] == self)
		{
			continue;
		}
		MIN_DISTANCE_SQ = min_distance * min_distance;
		distance_sq = DistanceSquared(level.a_sentinel_drones[i].origin, point);
		if(distance_sq < MIN_DISTANCE_SQ)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: sentinel_IsNearAnotherPlayer
	Namespace: sentinel_drone
	Checksum: 0xC2E2545B
	Offset: 0x7B30
	Size: 0xEF
	Parameters: 2
	Flags: None
*/
function sentinel_IsNearAnotherPlayer(origin, min_distance)
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(!is_target_valid(players[i]))
		{
			continue;
		}
		MIN_DISTANCE_SQ = min_distance * min_distance;
		distance_sq = DistanceSquared(origin, players[i].origin + VectorScale((0, 0, 1), 48));
		if(distance_sq < MIN_DISTANCE_SQ)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: sentinel_play_taunt
	Namespace: sentinel_drone
	Checksum: 0xBB19DA19
	Offset: 0x7C28
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function sentinel_play_taunt(taunt_Arr)
{
	if(isdefined(level._lastplayed_drone_taunt) && GetTime() - level._lastplayed_drone_taunt < 6000)
	{
		return;
	}
	taunt = RandomInt(taunt_Arr.size);
	level._lastplayed_drone_taunt = GetTime();
	self playsound(taunt_Arr[taunt]);
}

/*
	Name: sentinel_DebugDrawSize
	Namespace: sentinel_drone
	Checksum: 0xE7500709
	Offset: 0x7CB8
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function sentinel_DebugDrawSize()
{
	/#
		self endon("death");
		while(1)
		{
			radius = GetDvarInt("Dev Block strings are not supported", 35);
			sphere(self.origin, radius, (0, 1, 0), 0.5);
			wait(0.01);
		}
	#/
}

/*
	Name: sentinel_DebugFX
	Namespace: sentinel_drone
	Checksum: 0x1D781517
	Offset: 0x7D38
	Size: 0x265
	Parameters: 0
	Flags: None
*/
function sentinel_DebugFX()
{
	/#
		self endon("death");
		while(1)
		{
			if(GetDvarInt("Dev Block strings are not supported", 0) == 1)
			{
				self.sentinel_DebugFX_PlayAll = 1;
				forward_vector = AnglesToForward(self.angles);
				forward_vector = self.origin + VectorScale(forward_vector, 1200);
				thread sentinel_FireBeam(forward_vector);
				self clientfield::set("Dev Block strings are not supported", 1);
			}
			else if(isdefined(self.sentinel_DebugFX_PlayAll) && self.sentinel_DebugFX_PlayAll)
			{
				self.sentinel_DebugFX_PlayAll = 0;
				self clientfield::set("Dev Block strings are not supported", 0);
			}
			if(GetDvarInt("Dev Block strings are not supported", 0) == 1)
			{
				self.sentinel_DebugFX_BeamCharge = 1;
			}
			else if(isdefined(self.sentinel_DebugFX_BeamCharge) && self.sentinel_DebugFX_BeamCharge)
			{
				self.sentinel_DebugFX_BeamCharge = 0;
				self clientfield::set("Dev Block strings are not supported", 0);
			}
			if(GetDvarInt("Dev Block strings are not supported", 0) == 1)
			{
				if(!(isdefined(self.sentinel_DebugFX_NoArms) && self.sentinel_DebugFX_NoArms))
				{
					self.sentinel_DebugFX_NoArms = 1;
					thread sentinel_ArmDamage(1000, 2);
					thread sentinel_ArmDamage(1000, 1);
					thread sentinel_ArmDamage(1000, 3);
				}
			}
			if(GetDvarInt("Dev Block strings are not supported", 0) == 1)
			{
				if(!(isdefined(self.sentinel_DebugFX_NoFace) && self.sentinel_DebugFX_NoFace))
				{
					self.sentinel_DebugFX_NoFace = 1;
					thread sentinel_FaceDamage(1000, "Dev Block strings are not supported");
				}
			}
			wait(3);
		}
	#/
}

/*
	Name: sentinel_DebugBehavior
	Namespace: sentinel_drone
	Checksum: 0xF023BAB6
	Offset: 0x7FA8
	Size: 0x115
	Parameters: 0
	Flags: None
*/
function sentinel_DebugBehavior()
{
	/#
		self endon("death");
		while(isdefined(self))
		{
			if(GetDvarInt("Dev Block strings are not supported", 0) == 1)
			{
				self.debug_should_buff_zombies = 1;
				self.should_buff_zombies = 1;
			}
			else if(isdefined(self.debug_should_buff_zombies))
			{
				self.debug_should_buff_zombies = undefined;
				self.should_buff_zombies = 0;
			}
			if(GetDvarInt("Dev Block strings are not supported", 0) == 1)
			{
				self.debug_sentinel_debug_compact = 1;
				blackboard::SetBlackBoardAttribute(self, "Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			else if(isdefined(self.debug_sentinel_debug_compact))
			{
				self.debug_sentinel_debug_compact = undefined;
				blackboard::SetBlackBoardAttribute(self, "Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			wait(1);
		}
	#/
}

