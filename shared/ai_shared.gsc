#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\init;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\systems\weaponlist;
#using scripts\shared\array_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;

#namespace ai;

/*
	Name: set_ignoreme
	Namespace: ai
	Checksum: 0xB59FC317
	Offset: 0x3F0
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function set_ignoreme(VAL)
{
	/#
		Assert(IsSentient(self), "Dev Block strings are not supported");
	#/
	self.ignoreme = VAL;
}

/*
	Name: set_ignoreall
	Namespace: ai
	Checksum: 0x3A6658F7
	Offset: 0x440
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function set_ignoreall(VAL)
{
	/#
		Assert(IsSentient(self), "Dev Block strings are not supported");
	#/
	self.ignoreall = VAL;
}

/*
	Name: set_pacifist
	Namespace: ai
	Checksum: 0x27A29B78
	Offset: 0x490
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function set_pacifist(VAL)
{
	/#
		Assert(IsSentient(self), "Dev Block strings are not supported");
	#/
	self.pacifist = VAL;
}

/*
	Name: disable_pain
	Namespace: ai
	Checksum: 0xA458B23A
	Offset: 0x4E0
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function disable_pain()
{
	/#
		Assert(isalive(self), "Dev Block strings are not supported");
	#/
	self.allowPain = 0;
}

/*
	Name: enable_pain
	Namespace: ai
	Checksum: 0x55D9EAF7
	Offset: 0x528
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function enable_pain()
{
	/#
		Assert(isalive(self), "Dev Block strings are not supported");
	#/
	self.allowPain = 1;
}

/*
	Name: gun_remove
	Namespace: ai
	Checksum: 0xE1849AF1
	Offset: 0x570
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function gun_remove()
{
	self shared::placeWeaponOn(self.weapon, "none");
	self.gun_removed = 1;
}

/*
	Name: gun_switchto
	Namespace: ai
	Checksum: 0xA28C8FB1
	Offset: 0x5B0
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function gun_switchto(weapon, whichHand)
{
	self shared::placeWeaponOn(weapon, whichHand);
}

/*
	Name: gun_recall
	Namespace: ai
	Checksum: 0x1D87AEE2
	Offset: 0x5F0
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function gun_recall()
{
	self shared::placeWeaponOn(self.primaryWeapon, "right");
	self.gun_removed = undefined;
}

/*
	Name: set_behavior_attribute
	Namespace: ai
	Checksum: 0xDFE647D
	Offset: 0x630
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function set_behavior_attribute(attribute, value)
{
	if(SessionModeIsCampaignZombiesGame())
	{
		if(has_behavior_attribute(attribute))
		{
			SetAiAttribute(self, attribute, value);
		}
	}
	else
	{
		SetAiAttribute(self, attribute, value);
	}
}

/*
	Name: get_behavior_attribute
	Namespace: ai
	Checksum: 0x68741A61
	Offset: 0x6B8
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function get_behavior_attribute(attribute)
{
	return GetAiAttribute(self, attribute);
}

/*
	Name: has_behavior_attribute
	Namespace: ai
	Checksum: 0x4F212DA3
	Offset: 0x6E8
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function has_behavior_attribute(attribute)
{
	return HasAiAttribute(self, attribute);
}

/*
	Name: is_dead_sentient
	Namespace: ai
	Checksum: 0xB1B6C6EB
	Offset: 0x718
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function is_dead_sentient()
{
	if(IsSentient(self) && !isalive(self))
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

/*
	Name: waittill_dead
	Namespace: ai
	Checksum: 0x21FA2768
	Offset: 0x768
	Size: 0x215
	Parameters: 3
	Flags: None
*/
function waittill_dead(guys, num, timeoutLength)
{
	allAlive = 1;
	for(i = 0; i < guys.size; i++)
	{
		if(isalive(guys[i]))
		{
			continue;
		}
		allAlive = 0;
		break;
	}
	/#
		Assert(allAlive, "Dev Block strings are not supported");
	#/
	if(!allAlive)
	{
		newArray = [];
		for(i = 0; i < guys.size; i++)
		{
			if(isalive(guys[i]))
			{
				newArray[newArray.size] = guys[i];
			}
		}
		guys = newArray;
	}
	ent = spawnstruct();
	if(isdefined(timeoutLength))
	{
		ent endon("thread_timed_out");
		ent thread waittill_dead_timeout(timeoutLength);
	}
	ent.count = guys.size;
	if(isdefined(num) && num < ent.count)
	{
		ent.count = num;
	}
	Array::thread_all(guys, &waittill_dead_thread, ent);
	while(ent.count > 0)
	{
		ent waittill("waittill_dead guy died");
	}
}

/*
	Name: waittill_dead_or_dying
	Namespace: ai
	Checksum: 0x86A47A77
	Offset: 0x988
	Size: 0x19D
	Parameters: 3
	Flags: None
*/
function waittill_dead_or_dying(guys, num, timeoutLength)
{
	newArray = [];
	for(i = 0; i < guys.size; i++)
	{
		if(isalive(guys[i]) && !guys[i].ignoreForFixedNodeSafeCheck)
		{
			newArray[newArray.size] = guys[i];
		}
	}
	guys = newArray;
	ent = spawnstruct();
	if(isdefined(timeoutLength))
	{
		ent endon("thread_timed_out");
		ent thread waittill_dead_timeout(timeoutLength);
	}
	ent.count = guys.size;
	if(isdefined(num) && num < ent.count)
	{
		ent.count = num;
	}
	Array::thread_all(guys, &waittill_dead_or_dying_thread, ent);
	while(ent.count > 0)
	{
		ent waittill("waittill_dead_guy_dead_or_dying");
	}
}

/*
	Name: waittill_dead_thread
	Namespace: ai
	Checksum: 0x65E47EBF
	Offset: 0xB30
	Size: 0x37
	Parameters: 1
	Flags: Private
*/
function private waittill_dead_thread(ent)
{
	self waittill("death");
	ent.count--;
	ent notify("waittill_dead guy died");
}

/*
	Name: waittill_dead_or_dying_thread
	Namespace: ai
	Checksum: 0x9213AEC0
	Offset: 0xB70
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function waittill_dead_or_dying_thread(ent)
{
	self util::waittill_either("death", "pain_death");
	ent.count--;
	ent notify("waittill_dead_guy_dead_or_dying");
}

/*
	Name: waittill_dead_timeout
	Namespace: ai
	Checksum: 0x5BE3679A
	Offset: 0xBD0
	Size: 0x1D
	Parameters: 1
	Flags: None
*/
function waittill_dead_timeout(timeoutLength)
{
	wait(timeoutLength);
	self notify("thread_timed_out");
}

/*
	Name: wait_for_shoot
	Namespace: ai
	Checksum: 0x4E000238
	Offset: 0xBF8
	Size: 0x4F
	Parameters: 0
	Flags: Private
*/
function private wait_for_shoot()
{
	self endon("stop_shoot_at_target");
	if(isVehicle(self))
	{
		self waittill("weapon_fired");
	}
	else
	{
		self waittill("shoot");
	}
	self.start_duration_comp = 1;
}

/*
	Name: shoot_at_target
	Namespace: ai
	Checksum: 0xE0BEB50A
	Offset: 0xC50
	Size: 0x3E3
	Parameters: 6
	Flags: None
*/
function shoot_at_target(mode, target, tag, duration, setHealth, ignoreFirstShotWait)
{
	self endon("death");
	self endon("stop_shoot_at_target");
	/#
		Assert(isdefined(target), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(mode), "Dev Block strings are not supported");
	#/
	mode_flag = mode === "normal" || mode === "shoot_until_target_dead" || mode === "kill_within_time";
	/#
		Assert(mode_flag, "Dev Block strings are not supported");
	#/
	if(isdefined(duration))
	{
		/#
			Assert(duration >= 0, "Dev Block strings are not supported");
		#/
	}
	else
	{
		duration = 0;
	}
	if(isdefined(setHealth) && isdefined(target))
	{
		target.health = setHealth;
	}
	if(!isdefined(target) || (mode === "shoot_until_target_dead" && target.health <= 0))
	{
		return;
	}
	if(isdefined(tag) && tag != "")
	{
		self SetEntityTarget(target, 1, tag);
	}
	else
	{
		self SetEntityTarget(target, 1);
	}
	self.cansee_override = 1;
	self.start_duration_comp = 0;
	switch(mode)
	{
		case "normal":
		{
			break;
		}
		case "shoot_until_target_dead":
		{
			duration = -1;
			break;
		}
		case "kill_within_time":
		{
			target DamageMode("next_shot_kills");
			break;
		}
	}
	if(isVehicle(self))
	{
		self vehicle_ai::ClearAllCooldowns();
	}
	if(ignoreFirstShotWait === 1)
	{
		self.start_duration_comp = 1;
	}
	else
	{
		self thread wait_for_shoot();
	}
	if(isdefined(duration) && isdefined(target) && target.health > 0)
	{
		if(duration >= 0)
		{
			elapsed = 0;
			while(isdefined(target) && target.health > 0 && elapsed <= duration)
			{
				elapsed = elapsed + 0.05;
				if(!(isdefined(self.start_duration_comp) && self.start_duration_comp))
				{
					elapsed = 0;
				}
				wait(0.05);
			}
			if(isdefined(target) && mode == "kill_within_time")
			{
				self.perfectaim = 1;
				self.aim_set_by_shoot_at_target = 1;
				target waittill("death");
			}
		}
		else if(duration == -1)
		{
			target waittill("death");
		}
	}
	stop_shoot_at_target();
}

/*
	Name: stop_shoot_at_target
	Namespace: ai
	Checksum: 0xC83AC2C7
	Offset: 0x1040
	Size: 0x61
	Parameters: 0
	Flags: None
*/
function stop_shoot_at_target()
{
	self clearentitytarget();
	if(isdefined(self.aim_set_by_shoot_at_target) && self.aim_set_by_shoot_at_target)
	{
		self.perfectaim = 0;
		self.aim_set_by_shoot_at_target = 0;
	}
	self.cansee_override = 0;
	self notify("stop_shoot_at_target");
}

/*
	Name: wait_until_done_speaking
	Namespace: ai
	Checksum: 0x82675813
	Offset: 0x10B0
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function wait_until_done_speaking()
{
	self endon("death");
	while(self.isSpeaking)
	{
		wait(0.05);
	}
}

/*
	Name: set_goal
	Namespace: ai
	Checksum: 0x6CD958A
	Offset: 0x10E0
	Size: 0x137
	Parameters: 3
	Flags: None
*/
function set_goal(value, key, b_force)
{
	if(!isdefined(key))
	{
		key = "targetname";
	}
	if(!isdefined(b_force))
	{
		b_force = 0;
	}
	goal = GetNode(value, key);
	if(isdefined(goal))
	{
		self SetGoal(goal, b_force);
	}
	else
	{
		goal = GetEnt(value, key);
		if(isdefined(goal))
		{
			self SetGoal(goal, b_force);
		}
		else
		{
			goal = struct::get(value, key);
			if(isdefined(goal))
			{
				self SetGoal(goal.origin, b_force);
			}
		}
	}
	return goal;
}

/*
	Name: force_goal
	Namespace: ai
	Checksum: 0x4EAC0295
	Offset: 0x1220
	Size: 0xD9
	Parameters: 6
	Flags: None
*/
function force_goal(goto, n_radius, b_shoot, str_end_on, b_keep_colors, b_should_sprint)
{
	if(!isdefined(b_shoot))
	{
		b_shoot = 1;
	}
	if(!isdefined(b_keep_colors))
	{
		b_keep_colors = 0;
	}
	if(!isdefined(b_should_sprint))
	{
		b_should_sprint = 0;
	}
	self endon("death");
	s_tracker = spawnstruct();
	self thread _force_goal(s_tracker, goto, n_radius, b_shoot, str_end_on, b_keep_colors, b_should_sprint);
	s_tracker waittill("done");
}

/*
	Name: _force_goal
	Namespace: ai
	Checksum: 0x70F76AE7
	Offset: 0x1308
	Size: 0x453
	Parameters: 7
	Flags: None
*/
function _force_goal(s_tracker, goto, n_radius, b_shoot, str_end_on, b_keep_colors, b_should_sprint)
{
	if(!isdefined(b_shoot))
	{
		b_shoot = 1;
	}
	if(!isdefined(b_keep_colors))
	{
		b_keep_colors = 0;
	}
	if(!isdefined(b_should_sprint))
	{
		b_should_sprint = 0;
	}
	self endon("death");
	self notify("new_force_goal");
	flagsys::wait_till_clear("force_goal");
	flagsys::set("force_goal");
	goalRadius = self.goalRadius;
	if(isdefined(n_radius))
	{
		/#
			Assert(IsFloat(n_radius) || IsInt(n_radius), "Dev Block strings are not supported");
		#/
		self.goalRadius = n_radius;
	}
	color_enabled = 0;
	if(!b_keep_colors)
	{
		if(isdefined(colors::get_force_color()))
		{
			color_enabled = 1;
			self colors::disable();
		}
	}
	allowPain = self.allowPain;
	ignoreall = self.ignoreall;
	ignoreme = self.ignoreme;
	ignoreSuppression = self.ignoreSuppression;
	grenadeawareness = self.grenadeawareness;
	if(!b_shoot)
	{
		self set_ignoreall(1);
	}
	if(b_should_sprint)
	{
		self set_behavior_attribute("sprint", 1);
	}
	self.ignoreSuppression = 1;
	self.grenadeawareness = 0;
	self set_ignoreme(1);
	self disable_pain();
	self PushPlayer(1);
	if(isdefined(goto))
	{
		if(isdefined(n_radius))
		{
			/#
				Assert(IsFloat(n_radius) || IsInt(n_radius), "Dev Block strings are not supported");
			#/
			self SetGoal(goto);
		}
		else
		{
			self SetGoal(goto, 1);
		}
	}
	self util::waittill_any("goal", "new_force_goal", str_end_on);
	if(color_enabled)
	{
		colors::enable();
	}
	self PushPlayer(0);
	self ClearForcedGoal();
	self.goalRadius = goalRadius;
	self set_ignoreall(ignoreall);
	self set_ignoreme(ignoreme);
	if(allowPain)
	{
		self enable_pain();
	}
	self set_behavior_attribute("sprint", 0);
	self.ignoreSuppression = ignoreSuppression;
	self.grenadeawareness = grenadeawareness;
	flagsys::clear("force_goal");
	s_tracker notify("done");
}

/*
	Name: stopPainWaitInterval
	Namespace: ai
	Checksum: 0xAA64916F
	Offset: 0x1768
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function stopPainWaitInterval()
{
	self notify("painWaitIntervalRemove");
}

/*
	Name: _allowPainRestore
	Namespace: ai
	Checksum: 0x68C5C59E
	Offset: 0x1788
	Size: 0x3F
	Parameters: 0
	Flags: Private
*/
function private _allowPainRestore()
{
	self endon("death");
	self util::waittill_any("painWaitIntervalRemove", "painWaitInterval");
	self.allowPain = 1;
}

/*
	Name: painWaitInterval
	Namespace: ai
	Checksum: 0x83077B41
	Offset: 0x17D0
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function painWaitInterval(mSec)
{
	self endon("death");
	self notify("painWaitInterval");
	self endon("painWaitInterval");
	self endon("painWaitIntervalRemove");
	self thread _allowPainRestore();
	if(!isdefined(mSec) || mSec < 20)
	{
		mSec = 20;
	}
	while(isalive(self))
	{
		self waittill("pain");
		self.allowPain = 0;
		wait(mSec / 1000);
		self.allowPain = 1;
	}
}

/*
	Name: patrol
	Namespace: ai
	Checksum: 0xACA329F4
	Offset: 0x1898
	Size: 0x4F7
	Parameters: 1
	Flags: None
*/
function patrol(start_path_node)
{
	self endon("death");
	self endon("stop_patrolling");
	/#
		Assert(isdefined(start_path_node), self.targetname + "Dev Block strings are not supported");
	#/
	if(start_path_node.type == "BAD NODE")
	{
		/#
			errormsg = "Dev Block strings are not supported" + start_path_node.targetname + "Dev Block strings are not supported" + Int(start_path_node.origin[0]) + "Dev Block strings are not supported" + Int(start_path_node.origin[1]) + "Dev Block strings are not supported" + Int(start_path_node.origin[2]) + "Dev Block strings are not supported";
			iprintln(errormsg);
			logPrint(errormsg);
		#/
		return;
	}
	/#
		Assert(start_path_node.type == "Dev Block strings are not supported" || isdefined(start_path_node.scriptbundlename), "Dev Block strings are not supported" + start_path_node.targetname + "Dev Block strings are not supported");
	#/
	self notify("go_to_spawner_target");
	self.target = undefined;
	self.old_goal_radius = self.goalRadius;
	self thread end_patrol_on_enemy_targetting();
	self.currentgoal = start_path_node;
	self.patroller = 1;
	while(1)
	{
		if(isdefined(self.currentgoal.type) && self.currentgoal.type == "Path")
		{
			if(self has_behavior_attribute("patrol"))
			{
				self set_behavior_attribute("patrol", 1);
			}
			self SetGoal(self.currentgoal, 1);
			self waittill("goal");
			if(isdefined(self.currentgoal.script_notify))
			{
				self notify(self.currentgoal.script_notify);
				level notify(self.currentgoal.script_notify);
			}
			if(isdefined(self.currentgoal.script_flag_set))
			{
				flag = self.currentgoal.script_flag_set;
				if(!isdefined(level.flag[flag]))
				{
					level flag::init(flag);
				}
				level flag::set(flag);
			}
			if(!isdefined(self.currentgoal.script_wait_min))
			{
				self.currentgoal.script_wait_min = 0;
			}
			if(!isdefined(self.currentgoal.script_wait_max))
			{
				self.currentgoal.script_wait_max = 0;
			}
			/#
				Assert(self.currentgoal.script_wait_min <= self.currentgoal.script_wait_max, "Dev Block strings are not supported" + self.currentgoal.targetname);
			#/
			if(!isdefined(self.currentgoal.scriptbundlename))
			{
				wait_variability = self.currentgoal.script_wait_max - self.currentgoal.script_wait_min;
				wait_time = self.currentgoal.script_wait_min + RandomFloat(wait_variability);
				self notify("patrol_goal", self.currentgoal);
				wait(wait_time);
			}
			else
			{
				self scene::Play(self.currentgoal.scriptbundlename, self);
			}
		}
		else
		{
			self.currentgoal scene::Play(self);
		}
		self patrol_next_node();
	}
}

/*
	Name: patrol_next_node
	Namespace: ai
	Checksum: 0xA3A4449
	Offset: 0x1D98
	Size: 0x11B
	Parameters: 0
	Flags: None
*/
function patrol_next_node()
{
	target_nodes = [];
	target_scenes = [];
	if(isdefined(self.currentgoal.target))
	{
		target_nodes = GetNodeArray(self.currentgoal.target, "targetname");
		target_scenes = struct::get_array(self.currentgoal.target, "targetname");
	}
	if(target_nodes.size == 0 && target_scenes.size == 0)
	{
		self end_and_clean_patrol_behaviors();
	}
	else if(target_nodes.size != 0)
	{
		self.currentgoal = Array::random(target_nodes);
	}
	else
	{
		self.currentgoal = Array::random(target_scenes);
	}
}

/*
	Name: end_patrol_on_enemy_targetting
	Namespace: ai
	Checksum: 0xD8C65FE9
	Offset: 0x1EC0
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function end_patrol_on_enemy_targetting()
{
	self endon("death");
	self endon("stop_patrolling");
	while(1)
	{
		if(isdefined(self.enemy) || self.should_stop_patrolling === 1)
		{
			self end_and_clean_patrol_behaviors();
		}
		wait(0.1);
	}
}

/*
	Name: end_and_clean_patrol_behaviors
	Namespace: ai
	Checksum: 0xE6C35951
	Offset: 0x1F28
	Size: 0xD1
	Parameters: 0
	Flags: None
*/
function end_and_clean_patrol_behaviors()
{
	if(isdefined(self.currentgoal) && isdefined(self.currentgoal.scriptbundlename) && isdefined(self._o_scene))
	{
		self._o_scene cscene::stop();
	}
	if(self has_behavior_attribute("patrol"))
	{
		self set_behavior_attribute("patrol", 0);
	}
	if(isdefined(self.old_goal_radius))
	{
		self.goalRadius = self.old_goal_radius;
	}
	self ClearForcedGoal();
	self notify("stop_patrolling");
	self.patroller = undefined;
}

/*
	Name: bloody_death
	Namespace: ai
	Checksum: 0xBC818625
	Offset: 0x2008
	Size: 0x2C3
	Parameters: 2
	Flags: None
*/
function bloody_death(n_delay, hit_loc)
{
	self endon("death");
	if(!isdefined(self))
	{
		return;
	}
	/#
		Assert(IsActor(self));
	#/
	/#
		Assert(isalive(self));
	#/
	if(isdefined(self.__bloody_death) && self.__bloody_death)
	{
		return;
	}
	self.__bloody_death = 1;
	if(isdefined(n_delay))
	{
		wait(n_delay);
	}
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	if(isdefined(hit_loc))
	{
		/#
			Assert(IsInArray(Array("Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported"), hit_loc), "Dev Block strings are not supported");
		#/
	}
	else
	{
		hit_loc = Array::random(Array("helmet", "head", "neck", "torso_upper", "torso_mid", "torso_lower", "right_arm_upper", "left_arm_upper", "right_arm_lower", "left_arm_lower", "right_hand", "left_hand", "right_leg_upper", "left_leg_upper", "right_leg_lower", "left_leg_lower", "right_foot", "left_foot", "gun", "riotshield"));
	}
	self DoDamage(self.health + 100, self.origin, undefined, undefined, hit_loc);
}

/*
	Name: shouldRegisterClientFieldForArchetype
	Namespace: ai
	Checksum: 0x31FF0920
	Offset: 0x22D8
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function shouldRegisterClientFieldForArchetype(archetype)
{
	if(isdefined(level.clientFieldAICheck) && level.clientFieldAICheck && !IsArchetypeLoaded(archetype))
	{
		return 0;
	}
	return 1;
}

