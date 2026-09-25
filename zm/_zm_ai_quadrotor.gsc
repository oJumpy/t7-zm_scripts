#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm_devgui;

#namespace namespace_3a47cb81;

/*
	Name: __init__sytem__
	Namespace: namespace_3a47cb81
	Checksum: 0x654C2274
	Offset: 0x460
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_quadrotor", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_3a47cb81
	Checksum: 0x6B0E8DB7
	Offset: 0x4A0
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __init__()
{
	vehicle::add_main_callback("zm_quadrotor", &quadrotor_think);
	/#
		execdevgui("Dev Block strings are not supported");
		level thread function_a05da9fb();
	#/
}

/*
	Name: quadrotor_think
	Namespace: namespace_3a47cb81
	Checksum: 0x9883EA80
	Offset: 0x510
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function quadrotor_think()
{
	self useanimtree(-1);
	Target_Set(self, (0, 0, 0));
	self.health = self.healthdefault;
	self vehicle::friendly_fire_shield();
	self EnableAimAssist();
	self SetNearGoalNotifyDist(64);
	self.flyHeight = 128;
	self SetVehicleAvoidance(1);
	self.vehFovCosine = 0;
	self.vehFovCosineBusy = 0.574;
	self.vehAirCraftCollisionEnabled = 1;
	self.goalRadius = 128;
	self SetGoal(self.origin, 0, self.goalRadius, self.flyHeight);
	self thread quadrotor_death();
	self thread quadrotor_damage();
	quadrotor_start_ai();
	self thread quadrotor_set_team("allies");
}

/*
	Name: follow_ent
	Namespace: namespace_3a47cb81
	Checksum: 0x31DDDD55
	Offset: 0x698
	Size: 0x1A7
	Parameters: 1
	Flags: None
*/
function follow_ent(e_followee)
{
	level endon("end_game");
	self endon("death");
	while(isdefined(e_followee))
	{
		if(!self.returning_home)
		{
			v_facing = e_followee getPlayerAngles();
			v_forward = AnglesToForward((0, v_facing[1], 0));
			candidate_goalpos = e_followee.origin + v_forward * 128;
			trace_goalpos = PhysicsTrace(self.origin, candidate_goalpos);
			if(trace_goalpos["position"] == candidate_goalpos)
			{
				self.current_pathto_pos = e_followee.origin + v_forward * 128;
			}
			else
			{
				self.current_pathto_pos = e_followee.origin + VectorScale((0, 0, 1), 60);
			}
			self.current_pathto_pos = self GetClosestPointOnNavVolume(self.current_pathto_pos, 100);
			if(!isdefined(self.current_pathto_pos))
			{
				self.current_pathto_pos = self.origin;
			}
		}
		wait(RandomFloatRange(1, 2));
	}
}

/*
	Name: quadrotor_start_ai
	Namespace: namespace_3a47cb81
	Checksum: 0x8DD52D18
	Offset: 0x848
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function quadrotor_start_ai()
{
	self.current_pathto_pos = self.origin;
	self.returning_home = 0;
	quadrotor_main();
}

/*
	Name: quadrotor_main
	Namespace: namespace_3a47cb81
	Checksum: 0xAB38657F
	Offset: 0x888
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function quadrotor_main()
{
	self thread quadrotor_blink_lights();
	self thread quadrotor_fireupdate();
	self thread quadrotor_movementupdate();
	self thread quadrotor_collision();
	self thread quadrotor_watch_for_game_end();
}

/*
	Name: quadrotor_fireupdate
	Namespace: namespace_3a47cb81
	Checksum: 0x880A2E58
	Offset: 0x910
	Size: 0x1A7
	Parameters: 0
	Flags: None
*/
function quadrotor_fireupdate()
{
	level endon("end_game");
	self endon("death");
	while(1)
	{
		if(isdefined(self.enemy) && self VehCanSee(self.enemy))
		{
			self SetLookAtEnt(self.enemy);
			self SetTurretTargetEnt(self.enemy);
			startAim = GetTime();
			while(!self.turretontarget && vehicle_ai::TimeSince(startAim) < 3)
			{
				wait(0.2);
			}
			self quadrotor_fire_for_time(RandomFloatRange(1.5, 3));
			if(isdefined(self.enemy) && isai(self.enemy))
			{
				wait(RandomFloatRange(0.5, 1));
			}
			else
			{
				wait(RandomFloatRange(0.5, 1.5));
			}
		}
		else
		{
			self ClearLookAtEnt();
			wait(0.4);
		}
	}
}

/*
	Name: quadrotor_watch_for_game_end
	Namespace: namespace_3a47cb81
	Checksum: 0x124B4058
	Offset: 0xAC0
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function quadrotor_watch_for_game_end()
{
	self endon("death");
	level waittill("end_game");
	if(isdefined(self))
	{
		playFX(level._effect["tesla_elec_kill"], self.origin);
		self playsound("zmb_qrdrone_leave");
		self delete();
		/#
			iprintln("Dev Block strings are not supported");
		#/
	}
}

/*
	Name: quadrotor_check_move
	Namespace: namespace_3a47cb81
	Checksum: 0xAE670C7A
	Offset: 0xB78
	Size: 0x6D
	Parameters: 1
	Flags: None
*/
function quadrotor_check_move(position)
{
	results = PhysicsTrace(self.origin, position, (-15, -15, -5), (15, 15, 5));
	if(results["fraction"] == 1)
	{
		return 1;
	}
	return 0;
}

/*
	Name: quadrotor_adjust_goal_for_enemy_height
	Namespace: namespace_3a47cb81
	Checksum: 0xF4D5D9F6
	Offset: 0xBF0
	Size: 0x167
	Parameters: 1
	Flags: None
*/
function quadrotor_adjust_goal_for_enemy_height(goalpos)
{
	if(isdefined(self.enemy))
	{
		if(isai(self.enemy))
		{
			offset = 45;
		}
		else
		{
			offset = -100;
		}
		if(self.enemy.origin[2] + offset > goalpos[2])
		{
			goal_z = self.enemy.origin[2] + offset;
			if(goal_z > goalpos[2] + 400)
			{
				goal_z = goalpos[2] + 400;
			}
			results = PhysicsTrace(goalpos, (goalpos[0], goalpos[1], goal_z), (-15, -15, -5), (15, 15, 5));
			if(results["fraction"] == 1)
			{
				goalpos = (goalpos[0], goalpos[1], goal_z);
			}
		}
	}
	return goalpos;
}

/*
	Name: make_sure_goal_is_well_above_ground
	Namespace: namespace_3a47cb81
	Checksum: 0xB010948E
	Offset: 0xD60
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function make_sure_goal_is_well_above_ground(pos)
{
	start = pos + (0, 0, self.flyHeight);
	end = pos + (0, 0, self.flyHeight * -1);
	trace = bullettrace(start, end, 0, self, 0, 0);
	end = trace["position"];
	pos = end + (0, 0, self.flyHeight);
	z = self GetHeliHeightLockHeight(pos);
	pos = (pos[0], pos[1], z);
	pos = self GetClosestPointOnNavVolume(pos, 100);
	if(!isdefined(pos))
	{
		pos = self.origin;
	}
	return pos;
}

/*
	Name: waittill_pathing_done
	Namespace: namespace_3a47cb81
	Checksum: 0xC2A54BBC
	Offset: 0xE98
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function waittill_pathing_done()
{
	level endon("end_game");
	self endon("death");
	self endon("change_state");
	if(self.vehonpath)
	{
		self util::waittill_any("near_goal", "reached_end_node", "force_goal");
	}
}

/*
	Name: quadrotor_movementupdate
	Namespace: namespace_3a47cb81
	Checksum: 0xB3C60C42
	Offset: 0xF00
	Size: 0xCC3
	Parameters: 0
	Flags: None
*/
function quadrotor_movementupdate()
{
	level endon("end_game");
	self endon("death");
	self endon("change_state");
	/#
		Assert(isalive(self));
	#/
	a_powerups = [];
	old_goalpos = self.current_pathto_pos;
	self.current_pathto_pos = self make_sure_goal_is_well_above_ground(self.current_pathto_pos);
	if(!self.vehonpath)
	{
		if(isdefined(self.attachedpath))
		{
			self util::script_delay();
		}
		else if(DistanceSquared(self.origin, self.current_pathto_pos) < 10000 && (self.current_pathto_pos[2] > old_goalpos[2] + 10 || self.origin[2] + 10 < self.current_pathto_pos[2]))
		{
			self SetVehGoalPos(self.current_pathto_pos, 1, 1);
			self PathVariableOffset(VectorScale((0, 0, 1), 20), 2);
			self util::waittill_any_timeout(4, "near_goal", "force_goal", "death", "change_state");
		}
		else
		{
			goalpos = self quadrotor_get_closest_node();
			self SetVehGoalPos(goalpos, 1, 1);
			self util::waittill_any_timeout(2, "near_goal", "force_goal", "death", "change_state");
		}
	}
	/#
		Assert(isalive(self));
	#/
	self SetVehicleAvoidance(1);
	while(1)
	{
		self waittill_pathing_done();
		self thread quadrotor_blink_lights();
		if(self.returning_home)
		{
			self SetNearGoalNotifyDist(64);
			self SetHeliHeightLock(0);
			is_valid_exit_path_found = 0;
			quadrotor_table = level.quadrotor_status.pickup_trig.model;
			var_946c2ab7 = self GetClosestPointOnNavVolume(quadrotor_table.origin, 100);
			if(isdefined(var_946c2ab7))
			{
				is_valid_exit_path_found = self SetVehGoalPos(var_946c2ab7, 1, 1);
			}
			if(is_valid_exit_path_found)
			{
				self notify("attempting_return");
				self util::waittill_any("near_goal", "force_goal", "reached_end_node", "return_timeout");
				continue;
			}
			else
			{
				self thread quadrotor_escape_into_air();
			}
			self util::waittill_any("near_goal", "force_goal", "reached_end_node", "return_timeout");
		}
		if(!isdefined(self.revive_target))
		{
			player = self player_in_last_stand_within_range(500);
			if(isdefined(player))
			{
				self.revive_target = player;
				player.quadrotor_revive = 1;
			}
		}
		if(isdefined(self.revive_target))
		{
			origin = self.revive_target.origin;
			origin = (origin[0], origin[1], origin[2] + 100);
			origin = self GetClosestPointOnNavVolume(origin, 100);
			/#
				Assert(isdefined(origin));
			#/
			if(self SetVehGoalPos(origin, 1, 1))
			{
				self util::waittill_any("near_goal", "force_goal", "reached_end_node");
				level thread watch_for_fail_revive(self);
				wait(1);
				if(isdefined(self.revive_target) && self.revive_target laststand::player_is_in_laststand())
				{
					self.revive_target notify("remote_revive", self.player_owner);
					self.player_owner notify("revived_player_with_quadrotor");
				}
				self.revive_target = undefined;
				self SetVehGoalPos(origin, 1, 1);
				wait(1);
				continue;
			}
			else
			{
				player.quadrotor_revive = undefined;
			}
			wait(0.1);
		}
		a_powerups = [];
		if(level.active_powerups.size > 0 && isdefined(self.player_owner))
		{
			a_powerups = util::get_array_of_closest(self.player_owner.origin, level.active_powerups, undefined, undefined, 500);
		}
		if(a_powerups.size > 0)
		{
			b_got_powerup = 0;
			foreach(powerup in a_powerups)
			{
				var_2b346da7 = self GetClosestPointOnNavVolume(powerup.origin, 100);
				if(!isdefined(var_2b346da7))
				{
					continue;
				}
				if(self SetVehGoalPos(var_2b346da7, 1, 1))
				{
					self util::waittill_any("near_goal", "force_goal", "reached_end_node");
					if(isdefined(powerup))
					{
						self.player_owner.ignore_range_powerup = powerup;
						b_got_powerup = 1;
					}
					wait(1);
					break;
				}
			}
			if(b_got_powerup)
			{
				continue;
			}
			wait(0.1);
		}
		a_special_items = GetEntArray("quad_special_item", "script_noteworthy");
		if(isdefined(level.n_ee_medallions) && level.n_ee_medallions > 0 && isdefined(self.player_owner))
		{
			e_special_item = ArrayGetClosest(self.player_owner.origin, a_special_items, 500);
			if(isdefined(e_special_item))
			{
				var_146a0124 = self GetClosestPointOnNavVolume(e_special_item.origin, 100);
				self SetVehGoalPos(var_146a0124, 1, 1);
				self util::waittill_any("near_goal", "force_goal", "reached_end_node");
				wait(1);
				playFX(level._effect["staff_charge"], e_special_item.origin);
				e_special_item Hide();
				level.n_ee_medallions--;
				level notify("quadrotor_medallion_found", self);
				if(level.n_ee_medallions == 0)
				{
					s_mg_spawn = struct::get("mgspawn", "targetname");
					var_50cc6658 = self GetClosestPointOnNavVolume(s_mg_spawn.origin, 100);
					self SetVehGoalPos(var_50cc6658 + VectorScale((0, 0, 1), 30), 1, 1);
					self util::waittill_any("near_goal", "force_goal", "reached_end_node");
					wait(1);
					playFX(level._effect["staff_charge"], var_50cc6658);
					e_special_item playsound("zmb_perks_packa_ready");
					level flag::set("ee_medallions_collected");
				}
				e_special_item delete();
				self SetNearGoalNotifyDist(30);
				self SetVehGoalPos(self.origin, 1, 1);
			}
		}
		if(isdefined(level.quadrotor_custom_behavior))
		{
			self [[level.quadrotor_custom_behavior]]();
		}
		goalpos = quadrotor_find_new_position();
		if(self SetVehGoalPos(goalpos, 1, 1))
		{
			if(isdefined(self.goal_node))
			{
				self.goal_node.quadrotor_claimed = 1;
			}
			self util::waittill_any_timeout(12, "near_goal", "force_goal", "reached_end_node", "change_state", "death");
			if(isdefined(self.enemy) && self VehCanSee(self.enemy))
			{
				wait(RandomFloatRange(1, 4));
			}
			else
			{
				wait(RandomFloatRange(1, 3));
			}
			if(isdefined(self.goal_node))
			{
				self.goal_node.quadrotor_claimed = undefined;
			}
		}
		else if(isdefined(self.goal_node))
		{
			self.goal_node.quadrotor_fails = 1;
		}
		self.current_pathto_pos = self.origin;
		self SetVehGoalPos(self.origin, 1, 1);
		wait(0.5);
		continue;
	}
}

/*
	Name: quadrotor_escape_into_air
	Namespace: namespace_3a47cb81
	Checksum: 0xC0A36311
	Offset: 0x1BD0
	Size: 0x189
	Parameters: 0
	Flags: None
*/
function quadrotor_escape_into_air()
{
	/#
		iprintln("Dev Block strings are not supported");
	#/
	self.current_pathto_pos = self.origin + VectorScale((0, 0, 1), 2048);
	can_path_straight_up = self SetVehGoalPos(self.current_pathto_pos, 1, 0);
	trace_goalpos = PhysicsTrace(self.origin, self.current_pathto_pos);
	if(can_path_straight_up && trace_goalpos["position"] == self.current_pathto_pos)
	{
		/#
			iprintln("Dev Block strings are not supported");
		#/
		self notify("attempting_return");
	}
	else
	{
		iprintln("Dev Block strings are not supported");
		self notify("attempting_return");
		playFX(level._effect["tesla_elec_kill"], self.origin);
		self playsound("zmb_qrdrone_leave");
		self delete();
		level notify("drone_available");
	}
	/#
	#/
}

/*
	Name: quadrotor_get_closest_node
	Namespace: namespace_3a47cb81
	Checksum: 0xD07F300C
	Offset: 0x1D68
	Size: 0x121
	Parameters: 0
	Flags: None
*/
function quadrotor_get_closest_node()
{
	nodes = GetNodesInRadiusSorted(self.origin, 200, 0, 500, "Path");
	if(nodes.size == 0)
	{
		nodes = GetNodesInRadiusSorted(self.current_pathto_pos, 3000, 0, 2000, "Path");
	}
	foreach(node in nodes)
	{
		if(node.type == "BAD NODE")
		{
			continue;
		}
		return make_sure_goal_is_well_above_ground(node.origin);
	}
	return self.origin;
}

/*
	Name: quadrotor_find_new_position
	Namespace: namespace_3a47cb81
	Checksum: 0x28471008
	Offset: 0x1E98
	Size: 0x32B
	Parameters: 0
	Flags: None
*/
function quadrotor_find_new_position()
{
	if(!isdefined(self.current_pathto_pos))
	{
		self.current_pathto_pos = self.origin;
	}
	origin = self.current_pathto_pos;
	nodes = GetNodesInRadius(self.current_pathto_pos, self.goalRadius, 0, self.flyHeight + 300, "Path");
	if(nodes.size == 0)
	{
		nodes = GetNodesInRadius(self.current_pathto_pos, self.goalRadius + 1000, 0, self.flyHeight + 1000, "Path");
	}
	if(nodes.size == 0)
	{
		nodes = GetNodesInRadius(self.current_pathto_pos, self.goalRadius + 5000, 0, self.flyHeight + 4000, "Path");
	}
	best_node = undefined;
	best_score = 0;
	foreach(node in nodes)
	{
		if(node.type == "BAD NODE")
		{
			continue;
		}
		if(isdefined(node.quadrotor_fails) || isdefined(node.quadrotor_claimed))
		{
			score = RandomFloat(30);
		}
		else
		{
			score = RandomFloat(100);
		}
		if(score > best_score)
		{
			best_score = score;
			best_node = node;
		}
	}
	if(isdefined(best_node))
	{
		node_origin = best_node.origin + (0, 0, self.flyHeight + RandomFloatRange(-30, 40));
		z = self GetHeliHeightLockHeight(node_origin);
		node_origin = (node_origin[0], node_origin[1], z);
		node_origin = self GetClosestPointOnNavVolume(node_origin, 100);
		if(isdefined(node_origin))
		{
			origin = node_origin;
			self.goal_node = best_node;
		}
	}
	return origin;
}

/*
	Name: quadrotor_teleport_to_nearest_node
	Namespace: namespace_3a47cb81
	Checksum: 0x513B5794
	Offset: 0x21D0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function quadrotor_teleport_to_nearest_node()
{
	self.origin = self quadrotor_get_closest_node();
}

/*
	Name: quadrotor_damage
	Namespace: namespace_3a47cb81
	Checksum: 0xA00208FC
	Offset: 0x2200
	Size: 0x23F
	Parameters: 0
	Flags: None
*/
function quadrotor_damage()
{
System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.⁪‏⁭‬‍‬‬⁯‌​‬⁫⁭‮⁬‭​‮⁬​⁫‌‪‬⁫‏⁬‍⁬‪‍​‌‍⁬‍‮⁮‪‎‮()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: quadrotor_cleanup_fx
	Namespace: namespace_3a47cb81
	Checksum: 0xED4D36EE
	Offset: 0x2448
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function quadrotor_cleanup_fx()
{
	if(isdefined(self.stun_fx))
	{
		self.stun_fx delete();
	}
}

/*
	Name: quadrotor_death
	Namespace: namespace_3a47cb81
	Checksum: 0xA89B50FB
	Offset: 0x2480
	Size: 0x1D5
	Parameters: 0
	Flags: None
*/
function quadrotor_death()
{
	wait(0.1);
	self notify("nodeath_thread");
	self waittill("death", attacker, damageFromUnderneath, weaponName, point, dir);
	self notify("nodeath_thread");
	if(isdefined(self.goal_node) && isdefined(self.goal_node.quadrotor_claimed))
	{
		self.goal_node.quadrotor_claimed = undefined;
	}
	if(isdefined(self.delete_on_death))
	{
		if(isdefined(self))
		{
			self quadrotor_cleanup_fx();
			self delete();
			level.maxis_quadrotor = undefined;
		}
		return;
	}
	if(!isdefined(self))
	{
		return;
	}
	self endon("death");
	self DisableAimAssist();
	self death_fx();
	self thread death_radius_damage();
	self thread set_death_model(self.deathmodel, self.modelswapdelay);
	self thread quadrotor_crash_movement(attacker, dir);
	self quadrotor_cleanup_fx();
	self waittill("crash_done");
	self delete();
	level.maxis_quadrotor = undefined;
}

/*
	Name: death_fx
	Namespace: namespace_3a47cb81
	Checksum: 0x811022A0
	Offset: 0x2660
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function death_fx()
{
	if(isdefined(self.deathfx))
	{
		PlayFXOnTag(self.deathfx, self, self.deathfxtag);
	}
	self playsound("veh_qrdrone_sparks");
}

/*
	Name: quadrotor_crash_movement
	Namespace: namespace_3a47cb81
	Checksum: 0x62108DC1
	Offset: 0x26C0
	Size: 0x3B5
	Parameters: 2
	Flags: None
*/
function quadrotor_crash_movement(attacker, hitdir)
{
	level endon("end_game");
	self endon("crash_done");
	self endon("death");
	self CancelAIMove();
	self ClearVehGoalPos();
	self ClearLookAtEnt();
	self SetPhysAcceleration(VectorScale((0, 0, -1), 800));
	self.vehcheckforpredictedcrash = 1;
	if(!isdefined(hitdir))
	{
		hitdir = (1, 0, 0);
	}
	side_dir = VectorCross(hitdir, (0, 0, 1));
	side_dir_mag = RandomFloatRange(-100, 100);
	side_dir_mag = side_dir_mag + math::sign(side_dir_mag) * 80;
	side_dir = side_dir * side_dir_mag;
	self SetVehVelocity(self.velocity + VectorScale((0, 0, 1), 100) + VectorNormalize(side_dir));
	ang_vel = self GetAngularVelocity();
	ang_vel = (ang_vel[0] * 0.3, ang_vel[1], ang_vel[2] * 0.3);
	yaw_vel = RandomFloatRange(0, 210) * math::sign(ang_vel[1]);
	yaw_vel = yaw_vel + math::sign(yaw_vel) * 180;
	ang_vel = ang_vel + (RandomFloatRange(-1, 1), yaw_vel, RandomFloatRange(-1, 1));
	self SetAngularVelocity(ang_vel);
	self.crash_accel = RandomFloatRange(75, 110);
	if(!isdefined(self.off))
	{
		self thread quadrotor_crash_accel();
	}
	self thread quadrotor_collision();
	self playsound("veh_qrdrone_dmg_hit");
	if(!isdefined(self.off))
	{
		self thread qrotor_dmg_snd();
	}
	wait(0.1);
	if(RandomInt(100) < 40 && !isdefined(self.off))
	{
		self thread quadrotor_fire_for_time(RandomFloatRange(0.7, 2));
	}
	wait(15);
	self notify("crash_done");
}

/*
	Name: qrotor_dmg_snd
	Namespace: namespace_3a47cb81
	Checksum: 0x85DD98A3
	Offset: 0x2A80
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function qrotor_dmg_snd()
{
	dmg_ent = spawn("script_origin", self.origin);
	dmg_ent LinkTo(self);
	dmg_ent PlayLoopSound("veh_qrdrone_dmg_loop");
	self util::waittill_any("crash_done", "death");
	dmg_ent StopLoopSound(1);
	wait(2);
	dmg_ent delete();
}

/*
	Name: quadrotor_fire_for_time
	Namespace: namespace_3a47cb81
	Checksum: 0xA91F341
	Offset: 0x2B58
	Size: 0x153
	Parameters: 1
	Flags: None
*/
function quadrotor_fire_for_time(totalFireTime)
{
	level endon("end_game");
	self endon("crash_done");
	self endon("change_state");
	self endon("death");
	if(isdefined(self.emped))
	{
		return;
	}
	weapon = self SeatGetWeapon(0);
	fireTime = weapon.fireTime;
	time = 0;
	fireCount = 1;
	while(time < totalFireTime && !isdefined(self.emped))
	{
		if(isdefined(self.enemy) && isdefined(self.enemy.attackerAccuracy) && self.enemy.attackerAccuracy == 0)
		{
			self FireWeapon(undefined, undefined, 1);
		}
		else
		{
			self FireWeapon();
		}
		fireCount++;
		wait(fireTime);
		time = time + fireTime;
	}
}

/*
	Name: quadrotor_crash_accel
	Namespace: namespace_3a47cb81
	Checksum: 0xD7D6C669
	Offset: 0x2CB8
	Size: 0x1C7
	Parameters: 0
	Flags: None
*/
function quadrotor_crash_accel()
{
	level endon("end_game");
	self endon("crash_done");
	self endon("death");
	count = 0;
	while(1)
	{
		self SetVehVelocity(self.velocity + anglesToUp(self.angles) * self.crash_accel);
		self.crash_accel = self.crash_accel * 0.98;
		wait(0.1);
		count++;
		if(count % 8 == 0)
		{
			if(RandomInt(100) > 40)
			{
				if(self.velocity[2] > 150)
				{
					self.crash_accel = self.crash_accel * 0.75;
				}
				else if(self.velocity[2] < 40 && count < 60)
				{
					if(Abs(self.angles[0]) > 30 || Abs(self.angles[2]) > 30)
					{
						self.crash_accel = RandomFloatRange(160, 200);
					}
					else
					{
						self.crash_accel = RandomFloatRange(85, 120);
					}
				}
			}
		}
	}
}

/*
	Name: quadrotor_predicted_collision
	Namespace: namespace_3a47cb81
	Checksum: 0x667FEBA0
	Offset: 0x2E88
	Size: 0x85
	Parameters: 0
	Flags: None
*/
function quadrotor_predicted_collision()
{
	level endon("end_game");
	self endon("crash_done");
	self endon("death");
	while(1)
	{
		self waittill("veh_predictedcollision", velocity, normal);
		if(normal[2] >= 0.6)
		{
			self notify("veh_collision", velocity, normal);
		}
	}
}

/*
	Name: quadrotor_collision_player
	Namespace: namespace_3a47cb81
	Checksum: 0x4EE4685B
	Offset: 0x2F18
	Size: 0xFF
	Parameters: 0
	Flags: None
*/
function quadrotor_collision_player()
{
	level endon("end_game");
	self endon("change_state");
	self endon("crash_done");
	self endon("death");
	while(1)
	{
		self waittill("veh_collision", velocity, normal);
		driver = self GetSeatOccupant(0);
		if(isdefined(driver) && LengthSquared(velocity) > 4900)
		{
			Earthquake(0.25, 0.25, driver.origin, 50);
			driver PlayRumbleOnEntity("damage_heavy");
		}
	}
}

/*
	Name: quadrotor_collision
	Namespace: namespace_3a47cb81
	Checksum: 0x2829E489
	Offset: 0x3020
	Size: 0x545
	Parameters: 0
	Flags: None
*/
function quadrotor_collision()
{
	level endon("end_game");
	self endon("change_state");
	self endon("crash_done");
	self endon("death");
	if(!isalive(self))
	{
		self thread quadrotor_predicted_collision();
	}
	self.bounce_count = 0;
	time_of_last_bounce = 0;
	while(1)
	{
		self waittill("veh_collision", velocity, normal);
		ang_vel = self GetAngularVelocity() * 0.5;
		self SetAngularVelocity(ang_vel);
		if(normal[2] < 0.6 || (isalive(self) && !isdefined(self.emped)))
		{
			self SetVehVelocity(self.velocity + normal * 90);
			self playsound("veh_qrdrone_wall");
			if(normal[2] < 0.6)
			{
				fx_origin = self.origin - normal * 28;
			}
			else
			{
				fx_origin = self.origin - normal * 10;
			}
			current_time = GetTime();
			if(current_time - time_of_last_bounce < 1000)
			{
				self.bounce_count = self.bounce_count + 1;
				if(self.bounce_count > 2)
				{
					self notify("force_goal");
					self.bounce_count = 0;
				}
			}
			else
			{
				self.bounce_count = 0;
			}
			time_of_last_bounce = GetTime();
		}
		else if(isdefined(self.emped))
		{
			if(isdefined(self.bounced))
			{
				self playsound("veh_qrdrone_wall");
				self SetVehVelocity((0, 0, 0));
				self SetAngularVelocity((0, 0, 0));
				if(self.angles[0] < 0)
				{
					if(self.angles[0] < -15)
					{
						self.angles = (-15, self.angles[1], self.angles[2]);
					}
					else if(self.angles[0] > -10)
					{
						self.angles = (-10, self.angles[1], self.angles[2]);
					}
				}
				else if(self.angles[0] > 15)
				{
					self.angles = (15, self.angles[1], self.angles[2]);
				}
				else if(self.angles[0] < 10)
				{
					self.angles = (10, self.angles[1], self.angles[2]);
				}
				self.bounced = undefined;
				self notify("landed");
				return;
			}
			else
			{
				self.bounced = 1;
				self SetVehVelocity(self.velocity + normal * 120);
				self playsound("veh_qrdrone_wall");
				if(normal[2] < 0.6)
				{
					fx_origin = self.origin - normal * 28;
				}
				else
				{
					fx_origin = self.origin - normal * 10;
				}
				playFX(level._effect["quadrotor_nudge"], fx_origin, normal);
			}
		}
		else
		{
			CreateDynEntAndLaunch(self.deathmodel, self.origin, self.angles, self.origin, self.velocity * 0.01);
			self playsound("veh_qrdrone_explo");
			self thread death_fire_loop_audio();
			self notify("crash_done");
		}
	}
}

/*
	Name: death_fire_loop_audio
	Namespace: namespace_3a47cb81
	Checksum: 0x2F0C9711
	Offset: 0x3570
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function death_fire_loop_audio()
{
	sound_ent = spawn("script_origin", self.origin);
	sound_ent PlayLoopSound("veh_qrdrone_death_fire_loop", 0.1);
	wait(11);
	sound_ent StopLoopSound(1);
	sound_ent delete();
}

/*
	Name: quadrotor_set_team
	Namespace: namespace_3a47cb81
	Checksum: 0x4C5BAFEC
	Offset: 0x3608
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function quadrotor_set_team(team)
{
	self.team = team;
	self.vteam = team;
	self SetTeam(team);
	if(!isdefined(self.off))
	{
		quadrotor_blink_lights();
	}
}

/*
	Name: quadrotor_blink_lights
	Namespace: namespace_3a47cb81
	Checksum: 0x78D28147
	Offset: 0x3670
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function quadrotor_blink_lights()
{
	level endon("end_game");
	self endon("death");
	self vehicle::lights_off();
	wait(0.1);
	self vehicle::lights_on();
}

/*
	Name: quadrotor_self_destruct
	Namespace: namespace_3a47cb81
	Checksum: 0xC9F34E25
	Offset: 0x36C8
	Size: 0x1AB
	Parameters: 0
	Flags: None
*/
function quadrotor_self_destruct()
{
	level endon("end_game");
	self endon("death");
	self endon("exit_vehicle");
	self_destruct = 0;
	self_destruct_time = 0;
	while(1)
	{
		if(!self_destruct)
		{
			if(level.player meleeButtonPressed())
			{
				self_destruct = 1;
				self_destruct_time = 5;
			}
			wait(0.05);
			continue;
		}
		else
		{
			IPrintLnBold(self_destruct_time);
			wait(1);
			self_destruct_time = self_destruct_time - 1;
			if(self_destruct_time == 0)
			{
				driver = self GetSeatOccupant(0);
				if(isdefined(driver))
				{
					driver DisableInvulnerability();
				}
				Earthquake(3, 1, self.origin, 256);
				RadiusDamage(self.origin, 1000, 15000, 15000, level.player, "MOD_EXPLOSIVE");
				self DoDamage(self.health + 1000, self.origin);
			}
			continue;
		}
	}
}

/*
	Name: quadrotor_level_out_for_landing
	Namespace: namespace_3a47cb81
	Checksum: 0xA56FF709
	Offset: 0x3880
	Size: 0xFF
	Parameters: 0
	Flags: None
*/
function quadrotor_level_out_for_landing()
{
	level endon("end_game");
	self endon("death");
	self endon("emped");
	self endon("landed");
	while(isdefined(self.emped))
	{
		velocity = self.velocity;
		self.angles = (self.angles[0] * 0.85, self.angles[1], self.angles[2] * 0.85);
		ang_vel = self GetAngularVelocity() * 0.85;
		self SetAngularVelocity(ang_vel);
		self SetVehVelocity(velocity);
		wait(0.05);
	}
}

/*
	Name: quadrotor_temp_bullet_shield
	Namespace: namespace_3a47cb81
	Checksum: 0x13E8BAB3
	Offset: 0x3988
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function quadrotor_temp_bullet_shield(invulnerable_time)
{
	self notify("bullet_shield");
	self endon("bullet_shield");
	self.bullet_shield = 1;
	wait(invulnerable_time);
	if(isdefined(self))
	{
		self.bullet_shield = undefined;
		wait(3);
		if(isdefined(self) && self.health < 40)
		{
			self.health = 40;
		}
	}
}

/*
	Name: death_radius_damage
	Namespace: namespace_3a47cb81
	Checksum: 0x5AF37F0E
	Offset: 0x3A08
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function death_radius_damage()
{
	if(!isdefined(self) || self.radiusdamageradius <= 0)
	{
		return;
	}
	wait(0.05);
	if(isdefined(self))
	{
		self RadiusDamage(self.origin + VectorScale((0, 0, 1), 15), self.radiusdamageradius, self.radiusdamagemax, self.radiusdamagemin, self, "MOD_EXPLOSIVE");
	}
}

/*
	Name: set_death_model
	Namespace: namespace_3a47cb81
	Checksum: 0xFC86DC36
	Offset: 0x3A90
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function set_death_model(sModel, fDelay)
{
	/#
		Assert(isdefined(sModel));
	#/
	if(isdefined(fDelay) && fDelay > 0)
	{
		wait(fDelay);
	}
	if(!isdefined(self))
	{
		return;
	}
	if(isdefined(self.deathmodel_attached))
	{
		return;
	}
	self SetModel(sModel);
}

/*
	Name: player_in_last_stand_within_range
	Namespace: namespace_3a47cb81
	Checksum: 0x92C1D38
	Offset: 0x3B20
	Size: 0x163
	Parameters: 1
	Flags: None
*/
function player_in_last_stand_within_range(range)
{
	players = GetPlayers();
	if(players.size == 1)
	{
		return;
	}
	foreach(player in players)
	{
		if(player laststand::player_is_in_laststand() && DistanceSquared(self.origin, player.origin) < range * range && !isdefined(player.quadrotor_revive))
		{
			var_d46f516e = self GetClosestPointOnNavVolume(player.origin + VectorScale((0, 0, 1), 100), 100);
			if(!isdefined(var_d46f516e))
			{
				continue;
			}
			return player;
		}
	}
	return;
}

/*
	Name: watch_for_fail_revive
	Namespace: namespace_3a47cb81
	Checksum: 0xE592EA94
	Offset: 0x3C90
	Size: 0xF1
	Parameters: 1
	Flags: None
*/
function watch_for_fail_revive(quad_rotor)
{
	quadrotor = quad_rotor;
	owner = quad_rotor.player_owner;
	revive_target = quad_rotor.revive_target;
	revive_target endon("bled_out");
	revive_target endon("disconnect");
	level thread kill_fx_if_target_revive(quadrotor, revive_target);
	revive_target.revive_hud setText(&"GAME_PLAYER_IS_REVIVING_YOU", owner);
	revive_target laststand::revive_hud_show_n_fade(1);
	wait(1);
	if(isdefined(revive_target))
	{
		revive_target.quadrotor_revive = undefined;
	}
}

/*
	Name: kill_fx_if_target_revive
	Namespace: namespace_3a47cb81
	Checksum: 0x78426348
	Offset: 0x3D90
	Size: 0x1D3
	Parameters: 2
	Flags: None
*/
function kill_fx_if_target_revive(quadrotor, revive_target)
{
	e_fx = spawn("script_model", quadrotor GetTagOrigin("tag_origin"));
	e_fx SetModel("tag_origin");
	e_fx playsound("zmb_drone_revive_fire");
	e_fx PlayLoopSound("zmb_drone_revive_loop", 0.2);
	e_fx moveto(revive_target.origin, 1);
	timer = 0;
	while(1)
	{
		if(isdefined(revive_target) && revive_target laststand::player_is_in_laststand() && isdefined(quadrotor))
		{
			wait(0.1);
			timer = timer + 0.1;
			if(timer >= 1)
			{
				e_fx StopLoopSound(0.1);
				e_fx playsound("zmb_drone_revive_revive_3d");
				revive_target playsoundtoplayer("zmb_drone_revive_revive_plr", revive_target);
				break;
			}
		}
		else
		{
			break;
		}
	}
	e_fx delete();
}

/*
	Name: function_a05da9fb
	Namespace: namespace_3a47cb81
	Checksum: 0x9AAD8BE7
	Offset: 0x3F70
	Size: 0x43
	Parameters: 0
	Flags: Private
*/
function private function_a05da9fb()
{
	/#
		level flagsys::wait_till("Dev Block strings are not supported");
		zm_devgui::function_4acecab5(&function_d3a31a35);
	#/
}

/*
	Name: function_d3a31a35
	Namespace: namespace_3a47cb81
	Checksum: 0x56D97388
	Offset: 0x3FC0
	Size: 0xC7
	Parameters: 1
	Flags: Private
*/
function private function_d3a31a35(cmd)
{
	/#
		if(cmd == "Dev Block strings are not supported")
		{
			player = level.players[0];
			quadrotor = SpawnVehicle("Dev Block strings are not supported", player.origin + VectorScale((0, 0, 1), 32), (0, 0, 0));
			if(isalive(quadrotor))
			{
				quadrotor thread follow_ent(player);
				quadrotor.player_owner = player;
			}
		}
	#/
}

