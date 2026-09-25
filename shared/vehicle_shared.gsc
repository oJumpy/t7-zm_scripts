#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicleriders_shared;
#using scripts\shared\vehicles\_auto_turret;

#namespace vehicle;

/*
	Name: __init__sytem__
	Namespace: vehicle
	Checksum: 0xA60EFE9
	Offset: 0x778
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("vehicle_shared", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: vehicle
	Checksum: 0x410B6DEB
	Offset: 0x7C0
	Size: 0x9DB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("vehicle", "toggle_lockon", 1, 1, "int");
	clientfield::register("vehicle", "toggle_sounds", 1, 1, "int");
	clientfield::register("vehicle", "use_engine_damage_sounds", 1, 2, "int");
	clientfield::register("vehicle", "toggle_treadfx", 1, 1, "int");
	clientfield::register("vehicle", "toggle_exhaustfx", 1, 1, "int");
	clientfield::register("vehicle", "toggle_lights", 1, 2, "int");
	clientfield::register("vehicle", "toggle_lights_group1", 1, 1, "int");
	clientfield::register("vehicle", "toggle_lights_group2", 1, 1, "int");
	clientfield::register("vehicle", "toggle_lights_group3", 1, 1, "int");
	clientfield::register("vehicle", "toggle_lights_group4", 1, 1, "int");
	clientfield::register("vehicle", "toggle_ambient_anim_group1", 1, 1, "int");
	clientfield::register("vehicle", "toggle_ambient_anim_group2", 1, 1, "int");
	clientfield::register("vehicle", "toggle_ambient_anim_group3", 1, 1, "int");
	clientfield::register("vehicle", "toggle_emp_fx", 1, 1, "int");
	clientfield::register("vehicle", "toggle_burn_fx", 1, 1, "int");
	clientfield::register("vehicle", "deathfx", 1, 2, "int");
	clientfield::register("vehicle", "alert_level", 1, 2, "int");
	clientfield::register("vehicle", "set_lighting_ent", 1, 1, "int");
	clientfield::register("vehicle", "use_lighting_ent", 1, 1, "int");
	clientfield::register("vehicle", "damage_level", 1, 3, "int");
	clientfield::register("vehicle", "spawn_death_dynents", 1, 2, "int");
	clientfield::register("vehicle", "spawn_gib_dynents", 1, 1, "int");
	clientfield::register("helicopter", "toggle_lockon", 1, 1, "int");
	clientfield::register("helicopter", "toggle_sounds", 1, 1, "int");
	clientfield::register("helicopter", "use_engine_damage_sounds", 1, 2, "int");
	clientfield::register("helicopter", "toggle_treadfx", 1, 1, "int");
	clientfield::register("helicopter", "toggle_exhaustfx", 1, 1, "int");
	clientfield::register("helicopter", "toggle_lights", 1, 2, "int");
	clientfield::register("helicopter", "toggle_lights_group1", 1, 1, "int");
	clientfield::register("helicopter", "toggle_lights_group2", 1, 1, "int");
	clientfield::register("helicopter", "toggle_lights_group3", 1, 1, "int");
	clientfield::register("helicopter", "toggle_lights_group4", 1, 1, "int");
	clientfield::register("helicopter", "toggle_ambient_anim_group1", 1, 1, "int");
	clientfield::register("helicopter", "toggle_ambient_anim_group2", 1, 1, "int");
	clientfield::register("helicopter", "toggle_ambient_anim_group3", 1, 1, "int");
	clientfield::register("helicopter", "toggle_emp_fx", 1, 1, "int");
	clientfield::register("helicopter", "toggle_burn_fx", 1, 1, "int");
	clientfield::register("helicopter", "deathfx", 1, 1, "int");
	clientfield::register("helicopter", "alert_level", 1, 2, "int");
	clientfield::register("helicopter", "set_lighting_ent", 1, 1, "int");
	clientfield::register("helicopter", "use_lighting_ent", 1, 1, "int");
	clientfield::register("helicopter", "damage_level", 1, 3, "int");
	clientfield::register("helicopter", "spawn_death_dynents", 1, 2, "int");
	clientfield::register("helicopter", "spawn_gib_dynents", 1, 1, "int");
	clientfield::register("plane", "toggle_treadfx", 1, 1, "int");
	clientfield::register("toplayer", "toggle_dnidamagefx", 1, 1, "int");
	clientfield::register("toplayer", "toggle_flir_postfx", 1, 2, "int");
	clientfield::register("toplayer", "static_postfx", 1, 1, "int");
	if(isdefined(level.bypassVehicleScripts))
	{
		return;
	}
	level.heli_default_decel = 10;
	setup_targetname_spawners();
	setup_dvars();
	setup_level_vars();
	setup_triggers();
	setup_nodes();
	level Array::thread_all_ents(level.vehicle_processtriggers, &trigger_process);
	level.vehicle_processtriggers = undefined;
	level.vehicle_enemy_tanks = [];
	level.vehicle_enemy_tanks["vehicle_ger_tracked_king_tiger"] = 1;
	level thread _watch_for_hijacked_vehicles();
}

/*
	Name: __main__
	Namespace: vehicle
	Checksum: 0x5D8287B6
	Offset: 0x11A8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __main__()
{
	a_all_spawners = GetVehicleSpawnerArray();
	setup_spawners(a_all_spawners);
	/#
		level thread vehicle_spawner_tool();
		level thread spline_debug();
	#/
}

/*
	Name: setup_script_gatetrigger
	Namespace: vehicle
	Checksum: 0x82676BC8
	Offset: 0x1218
	Size: 0x4D
	Parameters: 1
	Flags: None
*/
function setup_script_gatetrigger(trigger)
{
	gates = [];
	if(isdefined(trigger.script_gatetrigger))
	{
		return level.vehicle_gatetrigger[trigger.script_gatetrigger];
	}
	return gates;
}

/*
	Name: trigger_process
	Namespace: vehicle
	Checksum: 0x1121FA1C
	Offset: 0x1270
	Size: 0x61D
	Parameters: 1
	Flags: None
*/
function trigger_process(trigger)
{
	if(isdefined(trigger.classname) && (trigger.classname == "trigger_multiple" || trigger.classname == "trigger_radius" || trigger.classname == "trigger_lookat" || trigger.classname == "trigger_box"))
	{
		bTriggeronce = 1;
	}
	else
	{
		bTriggeronce = 0;
	}
	if(isdefined(trigger.script_noteworthy) && trigger.script_noteworthy == "trigger_multiple")
	{
		bTriggeronce = 0;
	}
	trigger.processed_trigger = undefined;
	gates = setup_script_gatetrigger(trigger);
	script_vehicledetour = isdefined(trigger.script_vehicledetour) && (is_node_script_origin(trigger) || is_node_script_struct(trigger));
	detoured = isdefined(trigger.detoured) && (!is_node_script_origin(trigger) || is_node_script_struct(trigger));
	gotrigger = 1;
	while(gotrigger)
	{
		trigger trigger::wait_till();
		other = trigger.who;
		if(isdefined(trigger.enabled) && !trigger.enabled)
		{
			trigger waittill("enable");
		}
		if(isdefined(trigger.script_flag_set))
		{
			if(isdefined(other) && isdefined(other.vehicle_flags))
			{
				other.vehicle_flags[trigger.script_flag_set] = 1;
			}
			if(isdefined(other))
			{
				other notify("vehicle_flag_arrived", trigger.script_flag_set);
			}
			level flag::set(trigger.script_flag_set);
		}
		if(isdefined(trigger.script_flag_clear))
		{
			if(isdefined(other) && isdefined(other.vehicle_flags))
			{
				other.vehicle_flags[trigger.script_flag_clear] = 0;
			}
			level flag::clear(trigger.script_flag_clear);
		}
		if(isdefined(other) && script_vehicledetour)
		{
			other thread path_detour_script_origin(trigger);
		}
		else if(detoured && isdefined(other))
		{
			other thread path_detour(trigger);
		}
		trigger util::script_delay();
		if(bTriggeronce)
		{
			gotrigger = 0;
		}
		if(isdefined(trigger.script_vehicleGroupDelete))
		{
			if(!isdefined(level.vehicle_DeleteGroup[trigger.script_vehicleGroupDelete]))
			{
				/#
					println("Dev Block strings are not supported", trigger.script_vehicleGroupDelete);
				#/
				level.vehicle_DeleteGroup[trigger.script_vehicleGroupDelete] = [];
			}
			Array::delete_all(level.vehicle_DeleteGroup[trigger.script_vehicleGroupDelete]);
		}
		if(isdefined(trigger.script_VehicleSpawngroup))
		{
			level notify("spawnvehiclegroup" + trigger.script_VehicleSpawngroup);
			level waittill("vehiclegroup spawned" + trigger.script_VehicleSpawngroup);
		}
		if(gates.size > 0 && bTriggeronce)
		{
			level Array::thread_all_ents(gates, &path_gate_open);
		}
		if(isdefined(trigger) && isdefined(trigger.script_VehicleStartMove))
		{
			if(!isdefined(level.vehicle_StartMoveGroup[trigger.script_VehicleStartMove]))
			{
				/#
					println("Dev Block strings are not supported", trigger.script_VehicleStartMove);
				#/
				return;
			}
			foreach(vehicle in ArrayCopy(level.vehicle_StartMoveGroup[trigger.script_VehicleStartMove]))
			{
				if(isdefined(vehicle))
				{
					vehicle thread go_path();
				}
			}
		}
	}
}

/*
	Name: path_detour_get_detourpath
	Namespace: vehicle
	Checksum: 0xC35A24E8
	Offset: 0x1898
	Size: 0xD5
	Parameters: 1
	Flags: None
*/
function path_detour_get_detourpath(detournode)
{
	detourpath = undefined;
	for(j = 0; j < level.vehicle_detourpaths[detournode.script_vehicledetour].size; j++)
	{
		if(level.vehicle_detourpaths[detournode.script_vehicledetour][j] != detournode)
		{
			if(!islastnode(level.vehicle_detourpaths[detournode.script_vehicledetour][j]))
			{
				detourpath = level.vehicle_detourpaths[detournode.script_vehicledetour][j];
			}
		}
	}
	return detourpath;
}

/*
	Name: path_detour_script_origin
	Namespace: vehicle
	Checksum: 0x99CA5C67
	Offset: 0x1978
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function path_detour_script_origin(detournode)
{
	detourpath = path_detour_get_detourpath(detournode);
	if(isdefined(detourpath))
	{
		self thread paths(detourpath);
	}
}

/*
	Name: crash_detour_check
	Namespace: vehicle
	Checksum: 0xDD85592F
	Offset: 0x19D8
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function crash_detour_check(detourpath)
{
	return isdefined(detourpath.script_crashtype) && (isdefined(self.deaddriver) || self.health <= 0 || detourpath.script_crashtype == "forced") && (!isdefined(detourpath.derailed) || (isdefined(detourpath.script_crashtype) && detourpath.script_crashtype == "plane"));
}

/*
	Name: crash_derailed_check
	Namespace: vehicle
	Checksum: 0xBC39A35A
	Offset: 0x1A78
	Size: 0x2D
	Parameters: 1
	Flags: None
*/
function crash_derailed_check(detourpath)
{
	return isdefined(detourpath.derailed) && detourpath.derailed;
}

/*
	Name: path_detour
	Namespace: vehicle
	Checksum: 0xCF31AEB8
	Offset: 0x1AB0
	Size: 0x15D
	Parameters: 1
	Flags: None
*/
function path_detour(node)
{
	detournode = GetVehicleNode(node.target, "targetname");
	detourpath = path_detour_get_detourpath(detournode);
	if(!isdefined(detourpath))
	{
		return;
	}
	if(node.detoured && !isdefined(detourpath.script_vehicledetourgroup))
	{
		return;
	}
	if(crash_detour_check(detourpath))
	{
		self notify("crashPath", detourpath);
		detourpath.derailed = 1;
		self notify("newpath");
		self setSwitchNode(node, detourpath);
		return;
	}
	else if(crash_derailed_check(detourpath))
	{
		return;
	}
	if(isdefined(detourpath.script_vehicledetourgroup))
	{
		if(!isdefined(self.script_vehicledetourgroup))
		{
			return;
		}
		if(detourpath.script_vehicledetourgroup != self.script_vehicledetourgroup)
		{
			return;
		}
	}
}

/*
	Name: levelstuff
	Namespace: vehicle
	Checksum: 0x5FD58841
	Offset: 0x1C18
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function levelstuff(vehicle)
{
	if(isdefined(vehicle.script_linkname))
	{
		level.vehicle_link = array_2d_add(level.vehicle_link, vehicle.script_linkname, vehicle);
	}
	if(isdefined(vehicle.script_VehicleSpawngroup))
	{
		level.vehicle_SpawnGroup = array_2d_add(level.vehicle_SpawnGroup, vehicle.script_VehicleSpawngroup, vehicle);
	}
	if(isdefined(vehicle.script_VehicleStartMove))
	{
		level.vehicle_StartMoveGroup = array_2d_add(level.vehicle_StartMoveGroup, vehicle.script_VehicleStartMove, vehicle);
	}
	if(isdefined(vehicle.script_vehicleGroupDelete))
	{
		level.vehicle_DeleteGroup = array_2d_add(level.vehicle_DeleteGroup, vehicle.script_vehicleGroupDelete, vehicle);
	}
}

/*
	Name: _spawn_array
	Namespace: vehicle
	Checksum: 0x266D98E8
	Offset: 0x1D50
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function _spawn_array(spawners)
{
	ai = _remove_non_riders_from_array(spawner::simple_spawn(spawners));
	return ai;
}

/*
	Name: _remove_non_riders_from_array
	Namespace: vehicle
	Checksum: 0xEE3791AF
	Offset: 0x1DA0
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function _remove_non_riders_from_array(ai)
{
	living_ai = [];
	for(i = 0; i < ai.size; i++)
	{
		if(!ai_should_be_added(ai[i]))
		{
			continue;
		}
		living_ai[living_ai.size] = ai[i];
	}
	return living_ai;
}

/*
	Name: ai_should_be_added
	Namespace: vehicle
	Checksum: 0xE872CD3C
	Offset: 0x1E30
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function ai_should_be_added(ai)
{
	if(isalive(ai))
	{
		return 1;
	}
	if(!isdefined(ai))
	{
		return 0;
	}
	if(!isdefined(ai.classname))
	{
		return 0;
	}
	return ai.classname == "script_model";
}

/*
	Name: sort_by_startingpos
	Namespace: vehicle
	Checksum: 0x1853FB6F
	Offset: 0x1EA0
	Size: 0xC1
	Parameters: 1
	Flags: None
*/
function sort_by_startingpos(guysarray)
{
	firstarray = [];
	secondarray = [];
	for(i = 0; i < guysarray.size; i++)
	{
		if(isdefined(guysarray[i].script_startingposition))
		{
			firstarray[firstarray.size] = guysarray[i];
			continue;
		}
		secondarray[secondarray.size] = guysarray[i];
	}
	return ArrayCombine(firstarray, secondarray, 1, 0);
}

/*
	Name: rider_walk_setup
	Namespace: vehicle
	Checksum: 0xA9A4F432
	Offset: 0x1F70
	Size: 0x9F
	Parameters: 1
	Flags: None
*/
function rider_walk_setup(vehicle)
{
	if(!isdefined(self.script_vehiclewalk))
	{
		return;
	}
	if(isdefined(self.script_followmode))
	{
		self.FollowMode = self.script_followmode;
	}
	else
	{
		self.FollowMode = "cover nodes";
	}
	if(!isdefined(self.target))
	{
		return;
	}
	node = GetNode(self.target, "targetname");
	if(isdefined(node))
	{
		self.NodeAftervehicleWalk = node;
	}
}

/*
	Name: setup_groundnode_detour
	Namespace: vehicle
	Checksum: 0x754A82D3
	Offset: 0x2018
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function setup_groundnode_detour(node)
{
	realdetournode = GetVehicleNode(node.targetname, "target");
	if(!isdefined(realdetournode))
	{
		return;
	}
	realdetournode.detoured = 0;
	add_proccess_trigger(realdetournode);
}

/*
	Name: add_proccess_trigger
	Namespace: vehicle
	Checksum: 0x27A7E0C4
	Offset: 0x2098
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function add_proccess_trigger(trigger)
{
	if(isdefined(trigger.processed_trigger))
	{
		return;
	}
	if(!isdefined(level.vehicle_processtriggers))
	{
		level.vehicle_processtriggers = [];
	}
	else if(!IsArray(level.vehicle_processtriggers))
	{
		level.vehicle_processtriggers = Array(level.vehicle_processtriggers);
	}
	level.vehicle_processtriggers[level.vehicle_processtriggers.size] = trigger;
	trigger.processed_trigger = 1;
}

/*
	Name: islastnode
	Namespace: vehicle
	Checksum: 0x69517D66
	Offset: 0x2148
	Size: 0x81
	Parameters: 1
	Flags: None
*/
function islastnode(node)
{
	if(!isdefined(node.target))
	{
		return 1;
	}
	if(!isdefined(GetVehicleNode(node.target, "targetname")) && !isdefined(get_vehiclenode_any_dynamic(node.target)))
	{
		return 1;
	}
	return 0;
}

/*
	Name: paths
	Namespace: vehicle
	Checksum: 0x1EA903F9
	Offset: 0x21D8
	Size: 0xB83
	Parameters: 1
	Flags: None
*/
function paths(node)
{
	self endon("death");
	/#
		Assert(isdefined(node) || isdefined(self.attachedpath), "Dev Block strings are not supported");
	#/
	self notify("newpath");
	if(isdefined(node))
	{
		self.attachedpath = node;
	}
	pathstart = self.attachedpath;
	self.currentNode = self.attachedpath;
	if(!isdefined(pathstart))
	{
		return;
	}
	/#
		self thread debug_vehicle_paths();
	#/
	self endon("newpath");
	currentPoint = pathstart;
	while(isdefined(currentPoint))
	{
		self waittill("reached_node", currentPoint);
		currentPoint enable_turrets(self);
		if(!isdefined(self))
		{
			return;
		}
		self.currentNode = currentPoint;
		if(isdefined(currentPoint.target))
		{
		}
		else
		{
		}
		self.nextnode = undefined;
		if(isdefined(currentPoint.gateopen) && !currentPoint.gateopen)
		{
			self thread path_gate_wait_till_open(currentPoint);
		}
		currentPoint notify("trigger", self, GetVehicleNode(currentPoint.target, "targetname"));
		if(isdefined(currentPoint.script_dropbombs) && currentPoint.script_dropbombs > 0)
		{
			amount = currentPoint.script_dropbombs;
			delay = 0;
			delaytrace = 0;
			if(isdefined(currentPoint.script_dropbombs_delay) && currentPoint.script_dropbombs_delay > 0)
			{
				delay = currentPoint.script_dropbombs_delay;
			}
			if(isdefined(currentPoint.script_dropbombs_delaytrace) && currentPoint.script_dropbombs_delaytrace > 0)
			{
				delaytrace = currentPoint.script_dropbombs_delaytrace;
			}
			self notify("drop_bombs", amount, delay, delaytrace);
		}
		if(isdefined(currentPoint.script_noteworthy))
		{
			self notify(currentPoint.script_noteworthy);
			self notify("noteworthy", currentPoint.script_noteworthy);
		}
		if(isdefined(currentPoint.script_notify))
		{
			self notify(currentPoint.script_notify);
			level notify(currentPoint.script_notify);
		}
		waittillframeend;
		if(!isdefined(self))
		{
			return;
		}
		if(isdefined(currentPoint.script_delete) && currentPoint.script_delete)
		{
			if(isdefined(self.riders) && self.riders.size > 0)
			{
				Array::delete_all(self.riders);
			}
			self.delete_on_death = 1;
			self notify("death");
			if(!isalive(self))
			{
				self delete();
			}
			return;
		}
		if(isdefined(currentPoint.script_sound))
		{
			self playsound(currentPoint.script_sound);
		}
		if(isdefined(currentPoint.script_noteworthy))
		{
			if(currentPoint.script_noteworthy == "godon")
			{
				self god_on();
			}
			else if(currentPoint.script_noteworthy == "godoff")
			{
				self god_off();
			}
			else if(currentPoint.script_noteworthy == "drivepath")
			{
				self DrivePath();
			}
			else if(currentPoint.script_noteworthy == "lockpath")
			{
				self StartPath();
			}
			else if(currentPoint.script_noteworthy == "brake")
			{
				if(self.isphysicsvehicle)
				{
					self SetBrake(1);
				}
				self SetSpeed(0, 60, 60);
			}
			else if(currentPoint.script_noteworthy == "resumespeed")
			{
				Accel = 30;
				if(isdefined(currentPoint.script_float))
				{
					Accel = currentPoint.script_float;
				}
				self ResumeSpeed(Accel);
			}
		}
		if(isdefined(currentPoint.script_crashtypeoverride))
		{
			self.script_crashtypeoverride = currentPoint.script_crashtypeoverride;
		}
		if(isdefined(currentPoint.script_badplace))
		{
			self.script_badplace = currentPoint.script_badplace;
		}
		if(isdefined(currentPoint.script_team))
		{
			self.team = currentPoint.script_team;
		}
		if(isdefined(currentPoint.script_turningdir))
		{
			self notify("turning", currentPoint.script_turningdir);
		}
		if(isdefined(currentPoint.script_deathroll))
		{
			if(currentPoint.script_deathroll == 0)
			{
				self thread vehicle_death::deathrolloff();
			}
			else
			{
				self thread vehicle_death::deathrollon();
			}
		}
		if(isdefined(currentPoint.script_exploder))
		{
			exploder::exploder(currentPoint.script_exploder);
		}
		if(isdefined(currentPoint.script_flag_set))
		{
			if(isdefined(self.vehicle_flags))
			{
				self.vehicle_flags[currentPoint.script_flag_set] = 1;
			}
			self notify("vehicle_flag_arrived", currentPoint.script_flag_set);
			level flag::set(currentPoint.script_flag_set);
		}
		if(isdefined(currentPoint.script_flag_clear))
		{
			if(isdefined(self.vehicle_flags))
			{
				self.vehicle_flags[currentPoint.script_flag_clear] = 0;
			}
			level flag::clear(currentPoint.script_flag_clear);
		}
		if(isdefined(self.vehicleClass) && self.vehicleClass == "helicopter" && isdefined(self.DrivePath) && self.DrivePath == 1)
		{
			if(isdefined(self.nextnode) && self.nextnode is_unload_node())
			{
				unload_node_helicopter(undefined);
				self.attachedpath = self.nextnode;
				self DrivePath(self.attachedpath);
			}
		}
		else if(currentPoint is_unload_node())
		{
			unload_node(currentPoint);
		}
		if(isdefined(currentPoint.script_wait))
		{
			pause_path();
			currentPoint util::script_wait();
		}
		if(isdefined(currentPoint.script_waittill))
		{
			pause_path();
			util::waittill_any_ents(self, currentPoint.script_waittill, level, currentPoint.script_waittill);
		}
		if(isdefined(currentPoint.script_flag_wait))
		{
			if(!isdefined(self.vehicle_flags))
			{
				self.vehicle_flags = [];
			}
			self.vehicle_flags[currentPoint.script_flag_wait] = 1;
			self notify("vehicle_flag_arrived", currentPoint.script_flag_wait);
			self flag::set("waiting_for_flag");
			if(!level flag::get(currentPoint.script_flag_wait))
			{
				pause_path();
				level flag::wait_till(currentPoint.script_flag_wait);
			}
			self flag::clear("waiting_for_flag");
		}
		if(isdefined(self.set_lookat_point))
		{
			self.set_lookat_point = undefined;
			self ClearLookAtEnt();
		}
		if(isdefined(currentPoint.script_lights_on))
		{
			if(currentPoint.script_lights_on)
			{
				self lights_on();
			}
			else
			{
				self lights_off();
			}
		}
		if(isdefined(currentPoint.script_stopnode))
		{
			self set_goal_pos(currentPoint.origin, 1);
		}
		if(isdefined(self.switchNode))
		{
			if(currentPoint == self.switchNode)
			{
				self.switchNode = undefined;
			}
		}
		else if(!isdefined(currentPoint.target))
		{
			break;
		}
		resume_path();
	}
	self notify("reached_dynamic_path_end");
	if(isdefined(self.script_delete))
	{
		self delete();
	}
}

/*
	Name: pause_path
	Namespace: vehicle
	Checksum: 0xD13A6CAB
	Offset: 0x2D68
	Size: 0xDF
	Parameters: 0
	Flags: None
*/
function pause_path()
{
	if(!(isdefined(self.vehicle_paused) && self.vehicle_paused))
	{
		if(self.isphysicsvehicle)
		{
			self SetBrake(1);
		}
		if(isdefined(self.vehicleClass) && self.vehicleClass == "helicopter")
		{
			if(isdefined(self.DrivePath) && self.DrivePath)
			{
				self SetVehGoalPos(self.origin, 1);
			}
			else
			{
				self SetSpeed(0, 100, 100);
			}
		}
		else
		{
			self SetSpeed(0, 35, 35);
		}
		self.vehicle_paused = 1;
	}
}

/*
	Name: resume_path
	Namespace: vehicle
	Checksum: 0xC86E33EC
	Offset: 0x2E50
	Size: 0xCD
	Parameters: 0
	Flags: None
*/
function resume_path()
{
	if(isdefined(self.vehicle_paused) && self.vehicle_paused)
	{
		if(self.isphysicsvehicle)
		{
			self SetBrake(0);
		}
		if(isdefined(self.vehicleClass) && self.vehicleClass == "helicopter")
		{
			if(isdefined(self.DrivePath) && self.DrivePath)
			{
				self DrivePath(self.currentNode);
			}
			self ResumeSpeed(100);
		}
		else
		{
			self ResumeSpeed(35);
		}
		self.vehicle_paused = undefined;
	}
}

/*
	Name: get_on_path
	Namespace: vehicle
	Checksum: 0x708860E1
	Offset: 0x2F28
	Size: 0x1BB
	Parameters: 2
	Flags: None
*/
function get_on_path(path_start, str_key)
{
	if(!isdefined(str_key))
	{
		str_key = "targetname";
	}
	if(IsString(path_start))
	{
		path_start = GetVehicleNode(path_start, str_key);
	}
	if(!isdefined(path_start))
	{
		if(isdefined(self.targetname))
		{
			/#
				ASSERTMSG("Dev Block strings are not supported" + self.targetname);
			#/
		}
		else
		{
			ASSERTMSG("Dev Block strings are not supported" + self.targetname);
		}
		/#
		#/
	}
	if(isdefined(self.hasstarted))
	{
		self.hasstarted = undefined;
	}
	self.attachedpath = path_start;
	if(!(isdefined(self.DrivePath) && self.DrivePath))
	{
		self AttachPath(path_start);
	}
	if(self.disconnectPathOnStop === 1 && !IsSentient(self))
	{
		self disconnect_paths(self.disconnectPathDetail);
	}
	if(isdefined(self.isphysicsvehicle) && self.isphysicsvehicle)
	{
		self SetBrake(1);
	}
	self thread paths();
}

/*
	Name: get_off_path
	Namespace: vehicle
	Checksum: 0x5D764080
	Offset: 0x30F0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function get_off_path()
{
	self CancelAIMove();
	self ClearVehGoalPos();
}

/*
	Name: create_from_spawngroup_and_go_path
	Namespace: vehicle
	Checksum: 0xEFD7E7E7
	Offset: 0x3130
	Size: 0x89
	Parameters: 1
	Flags: None
*/
function create_from_spawngroup_and_go_path(spawnGroup)
{
	vehicleArray = _scripted_spawn(spawnGroup);
	for(i = 0; i < vehicleArray.size; i++)
	{
		if(isdefined(vehicleArray[i]))
		{
			vehicleArray[i] thread go_path();
		}
	}
	return vehicleArray;
}

/*
	Name: get_on_and_go_path
	Namespace: vehicle
	Checksum: 0x794A1227
	Offset: 0x31C8
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function get_on_and_go_path(path_start)
{
	self get_on_path(path_start);
	self go_path();
}

/*
	Name: go_path
	Namespace: vehicle
	Checksum: 0x3CA25D03
	Offset: 0x3210
	Size: 0x1C1
	Parameters: 0
	Flags: None
*/
function go_path()
{
	self endon("death");
	self endon("stop path");
	if(self.isphysicsvehicle)
	{
		self SetBrake(0);
	}
	if(isdefined(self.script_VehicleStartMove))
	{
		ArrayRemoveValue(level.vehicle_StartMoveGroup[self.script_VehicleStartMove], self);
	}
	if(isdefined(self.hasstarted))
	{
		/#
			println("Dev Block strings are not supported");
		#/
		return;
	}
	else
	{
		self.hasstarted = 1;
	}
	self util::script_delay();
	self notify("start_vehiclepath");
	if(isdefined(self.DrivePath) && self.DrivePath)
	{
		self DrivePath(self.attachedpath);
	}
	else
	{
		self StartPath();
	}
	wait(0.05);
	self connect_paths();
	self waittill("reached_end_node");
	if(self.disconnectPathOnStop === 1 && !IsSentient(self))
	{
		self disconnect_paths(self.disconnectPathDetail);
	}
	if(isdefined(self.currentNode) && isdefined(self.currentNode.script_noteworthy) && self.currentNode.script_noteworthy == "deleteme")
	{
		return;
	}
}

/*
	Name: path_gate_open
	Namespace: vehicle
	Checksum: 0xC00134F5
	Offset: 0x33E0
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function path_gate_open(node)
{
	node.gateopen = 1;
	node notify("gate opened");
}

/*
	Name: path_gate_wait_till_open
	Namespace: vehicle
	Checksum: 0x5A9CFC8F
	Offset: 0x3418
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function path_gate_wait_till_open(pathspot)
{
	self endon("death");
	self.waitingforgate = 1;
	self set_speed(0, 15, "path gate closed");
	pathspot waittill("gate opened");
	self.waitingforgate = 0;
	if(self.health > 0)
	{
		script_resume_speed("gate opened", level.vehicle_ResumeSpeed);
	}
}

/*
	Name: _spawn_group
	Namespace: vehicle
	Checksum: 0x4C3843F4
	Offset: 0x34B0
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function _spawn_group(spawnGroup)
{
	while(1)
	{
		level waittill("spawnvehiclegroup" + spawnGroup);
		spawned_vehicles = [];
		for(i = 0; i < level.vehicle_spawners[spawnGroup].size; i++)
		{
			spawned_vehicles[spawned_vehicles.size] = _vehicle_spawn(level.vehicle_spawners[spawnGroup][i]);
		}
		level notify("vehiclegroup spawned" + spawnGroup, spawned_vehicles);
	}
}

/*
	Name: _scripted_spawn
	Namespace: vehicle
	Checksum: 0x7739E092
	Offset: 0x3570
	Size: 0x45
	Parameters: 1
	Flags: None
*/
function _scripted_spawn(group)
{
	thread _scripted_spawn_go(group);
	level waittill("vehiclegroup spawned" + group, vehicles);
	return vehicles;
}

/*
	Name: _scripted_spawn_go
	Namespace: vehicle
	Checksum: 0x4F574C20
	Offset: 0x35C0
	Size: 0x1F
	Parameters: 1
	Flags: None
*/
function _scripted_spawn_go(group)
{
	waittillframeend;
	level notify("spawnvehiclegroup" + group);
}

/*
	Name: set_variables
	Namespace: vehicle
	Checksum: 0x54D6AE4F
	Offset: 0x35E8
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function set_variables(vehicle)
{
	if(isdefined(vehicle.script_deathflag))
	{
		if(!level flag::exists(vehicle.script_deathflag))
		{
			level flag::init(vehicle.script_deathflag);
		}
	}
}

/*
	Name: _vehicle_spawn
	Namespace: vehicle
	Checksum: 0x1EC913E8
	Offset: 0x3660
	Size: 0x21F
	Parameters: 2
	Flags: None
*/
function _vehicle_spawn(vspawner, from)
{
	if(!isdefined(vspawner) || !vspawner.count)
	{
		return;
	}
	str_targetname = undefined;
	if(isdefined(vspawner.targetname))
	{
		str_targetname = vspawner.targetname + "_vh";
	}
	spawner::global_spawn_throttle(1);
	if(!isdefined(vspawner) || !vspawner.count)
	{
		return;
	}
	vehicle = vspawner SpawnFromSpawner(str_targetname, 1);
	if(!isdefined(vehicle))
	{
		return;
	}
	if(isdefined(vspawner.script_team))
	{
		vehicle SetTeam(vspawner.script_team);
	}
	if(isdefined(vehicle.lockheliheight))
	{
		vehicle SetHeliHeightLock(vehicle.lockheliheight);
	}
	if(isdefined(vehicle.targetname))
	{
		level notify("new_vehicle_spawned" + vehicle.targetname, vehicle);
	}
	if(isdefined(vehicle.script_noteworthy))
	{
		level notify("new_vehicle_spawned" + vehicle.script_noteworthy, vehicle);
	}
	if(isdefined(vehicle.script_animname))
	{
		vehicle.animName = vehicle.script_animname;
	}
	if(isdefined(vehicle.script_animscripted))
	{
		vehicle.supportsAnimScripted = vehicle.script_animscripted;
	}
	return vehicle;
}

/*
	Name: init
	Namespace: vehicle
	Checksum: 0xC6FECF87
	Offset: 0x3888
	Size: 0x8BB
	Parameters: 1
	Flags: None
*/
function init(vehicle)
{
	callback::callback("hash_bae82b92");
	vehicle useanimtree(-1);
	if(isdefined(vehicle.e_dyn_path))
	{
		vehicle.e_dyn_path LinkTo(vehicle);
	}
	vehicle flag::init("waiting_for_flag");
	vehicle.takedamage = !isdefined(vehicle.script_godmode) && vehicle.script_godmode;
	vehicle.zerospeed = 1;
	if(!isdefined(vehicle.modeldummyon))
	{
		vehicle.modeldummyon = 0;
	}
	if(isdefined(vehicle.isphysicsvehicle) && vehicle.isphysicsvehicle)
	{
		if(isdefined(vehicle.script_brake) && vehicle.script_brake)
		{
			vehicle SetBrake(1);
		}
	}
	type = vehicle.vehicleType;
	vehicle _vehicle_life();
	vehicle thread maingun_fx();
	vehicle.getoutrig = [];
	if(isdefined(level.vehicle_attachedmodels) && isdefined(level.vehicle_attachedmodels[type]))
	{
		rigs = level.vehicle_attachedmodels[type];
		strings = getArrayKeys(rigs);
		for(i = 0; i < strings.size; i++)
		{
			vehicle.getoutrig[strings[i]] = undefined;
			vehicle.getoutriganimating[strings[i]] = 0;
		}
	}
	else if(isdefined(self.script_badplace))
	{
		vehicle thread _vehicle_bad_place();
	}
	if(isdefined(vehicle.scriptbundlesettings))
	{
		settings = struct::get_script_bundle("vehiclecustomsettings", vehicle.scriptbundlesettings);
		if(isdefined(settings) && isdefined(settings.lightgroups_numGroups))
		{
			if(settings.lightgroups_numGroups >= 1 && settings.lightgroups_1_always_on === 1)
			{
				vehicle toggle_lights_group(1, 1);
			}
			if(settings.lightgroups_numGroups >= 2 && settings.lightgroups_2_always_on === 1)
			{
				vehicle toggle_lights_group(2, 1);
			}
			if(settings.lightgroups_numGroups >= 3 && settings.lightgroups_3_always_on === 1)
			{
				vehicle toggle_lights_group(3, 1);
			}
			if(settings.lightgroups_numGroups >= 4 && settings.lightgroups_4_always_on === 1)
			{
				vehicle toggle_lights_group(4, 1);
			}
		}
	}
	if(!vehicle is_cheap())
	{
		vehicle friendly_fire_shield();
	}
	levelstuff(vehicle);
	if(isdefined(vehicle.vehicleClass) && vehicle.vehicleClass == "artillery")
	{
		vehicle.disconnectPathOnStop = undefined;
		self disconnect_paths(0);
	}
	else
	{
		vehicle.disconnectPathOnStop = self.script_disconnectpaths;
	}
	vehicle.disconnectPathDetail = self.script_disconnectpath_detail;
	if(!isdefined(vehicle.disconnectPathDetail))
	{
		vehicle.disconnectPathDetail = 0;
	}
	if(!vehicle is_cheap() && (!isdefined(vehicle.vehicleClass) && vehicle.vehicleClass == "plane") && (!isdefined(vehicle.vehicleClass) && vehicle.vehicleClass == "artillery"))
	{
		vehicle thread _disconnect_paths_when_stopped();
	}
	if(!isdefined(vehicle.script_nonmovingvehicle))
	{
		if(isdefined(vehicle.target))
		{
			path_start = GetVehicleNode(vehicle.target, "targetname");
			if(!isdefined(path_start))
			{
				path_start = GetEnt(vehicle.target, "targetname");
				if(!isdefined(path_start))
				{
					path_start = struct::get(vehicle.target, "targetname");
				}
			}
		}
		if(isdefined(path_start) && vehicle.vehicleType != "inc_base_jump_spotlight")
		{
			vehicle thread get_on_path(path_start);
		}
	}
	if(isdefined(vehicle.script_vehicleattackgroup))
	{
		vehicle thread attack_group_think();
	}
	/#
		if(isdefined(vehicle.script_recordent) && vehicle.script_recordent)
		{
			RecordEnt(vehicle);
		}
	#/
	if(vehicle has_helicopter_dust_kickup())
	{
		if(!level.clientscripts)
		{
			vehicle thread aircraft_dust_kickup();
		}
	}
	/#
		vehicle thread debug_vehicle();
	#/
	vehicle thread vehicle_death::main();
	if(isdefined(vehicle.script_targetset) && vehicle.script_targetset == 1)
	{
		offset = (0, 0, 0);
		if(isdefined(vehicle.script_targetoffset))
		{
			offset = vehicle.script_targetoffset;
		}
		Target_Set(vehicle, offset);
	}
	if(isdefined(vehicle.script_vehicleavoidance) && vehicle.script_vehicleavoidance)
	{
		vehicle SetVehicleAvoidance(1);
	}
	vehicle enable_turrets();
	if(isdefined(level.vehicleSpawnCallbackThread))
	{
		level thread [[level.vehicleSpawnCallbackThread]](vehicle);
	}
}

/*
	Name: detach_getoutrigs
	Namespace: vehicle
	Checksum: 0x4C5BC4FF
	Offset: 0x4150
	Size: 0x95
	Parameters: 0
	Flags: None
*/
function detach_getoutrigs()
{
	if(!isdefined(self.getoutrig))
	{
		return;
	}
	if(!self.getoutrig.size)
	{
		return;
	}
	keys = getArrayKeys(self.getoutrig);
	for(i = 0; i < keys.size; i++)
	{
		self.getoutrig[keys[i]] Unlink();
	}
}

/*
	Name: enable_turrets
	Namespace: vehicle
	Checksum: 0x564C0A3C
	Offset: 0x41F0
	Size: 0x1FB
	Parameters: 1
	Flags: None
*/
function enable_turrets(veh)
{
	if(!isdefined(veh))
	{
		veh = self;
	}
	if(isdefined(self.script_enable_turret0) && self.script_enable_turret0)
	{
		veh turret::enable(0);
	}
	if(isdefined(self.script_enable_turret1) && self.script_enable_turret1)
	{
		veh turret::enable(1);
	}
	if(isdefined(self.script_enable_turret2) && self.script_enable_turret2)
	{
		veh turret::enable(2);
	}
	if(isdefined(self.script_enable_turret3) && self.script_enable_turret3)
	{
		veh turret::enable(3);
	}
	if(isdefined(self.script_enable_turret4) && self.script_enable_turret4)
	{
		veh turret::enable(4);
	}
	if(isdefined(self.script_enable_turret0) && !self.script_enable_turret0)
	{
		veh turret::disable(0);
	}
	if(isdefined(self.script_enable_turret1) && !self.script_enable_turret1)
	{
		veh turret::disable(1);
	}
	if(isdefined(self.script_enable_turret2) && !self.script_enable_turret2)
	{
		veh turret::disable(2);
	}
	if(isdefined(self.script_enable_turret3) && !self.script_enable_turret3)
	{
		veh turret::disable(3);
	}
	if(isdefined(self.script_enable_turret4) && !self.script_enable_turret4)
	{
		veh turret::disable(4);
	}
}

/*
	Name: enable_auto_disconnect_path
	Namespace: vehicle
	Checksum: 0xDB99331F
	Offset: 0x43F8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function enable_auto_disconnect_path()
{
	self notify("kill_disconnect_paths_forever");
	self.disconnectPathOnStop = 0;
	self thread _disconnect_paths_when_stopped();
}

/*
	Name: _disconnect_paths_when_stopped
	Namespace: vehicle
	Checksum: 0x15825851
	Offset: 0x4438
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function _disconnect_paths_when_stopped()
{
	if(IsPathfinder(self))
	{
		self.disconnectPathOnStop = 0;
		return;
	}
	if(isdefined(self.script_disconnectpaths) && !self.script_disconnectpaths)
	{
		self.disconnectPathOnStop = 0;
		return;
	}
	self endon("death");
	self endon("kill_disconnect_paths_forever");
	wait(1);
	threshold = 3;
	while(isdefined(self))
	{
		if(LengthSquared(self.velocity) < threshold * threshold)
		{
			if(self.disconnectPathOnStop === 1)
			{
				self disconnect_paths(self.disconnectPathDetail);
				self notify("speed_zero_path_disconnect");
			}
			while(LengthSquared(self.velocity) < threshold * threshold)
			{
				wait(0.05);
			}
		}
		self connect_paths();
		while(LengthSquared(self.velocity) >= threshold * threshold)
		{
			wait(0.05);
		}
	}
}

/*
	Name: set_speed
	Namespace: vehicle
	Checksum: 0xD05836E7
	Offset: 0x45B8
	Size: 0x8B
	Parameters: 3
	Flags: None
*/
function set_speed(speed, rate, msg)
{
	if(self GetSpeedMPH() == 0 && speed == 0)
	{
		return;
	}
	/#
		self thread debug_set_speed(speed, rate, msg);
	#/
	self SetSpeed(speed, rate);
}

/*
	Name: debug_set_speed
	Namespace: vehicle
	Checksum: 0x702521F7
	Offset: 0x4650
	Size: 0xDB
	Parameters: 3
	Flags: None
*/
function debug_set_speed(speed, rate, msg)
{
	/#
		self notify("new debug_vehiclesetspeed");
		self endon("new debug_vehiclesetspeed");
		self endon("resuming speed");
		self endon("death");
		while(1)
		{
			while(GetDvarString("Dev Block strings are not supported") != "Dev Block strings are not supported")
			{
				print3d(self.origin + VectorScale((0, 0, 1), 192), "Dev Block strings are not supported" + msg, (1, 1, 1), 1, 3);
				wait(0.05);
			}
			wait(0.5);
		}
	#/
}

/*
	Name: script_resume_speed
	Namespace: vehicle
	Checksum: 0x97563405
	Offset: 0x4738
	Size: 0x163
	Parameters: 2
	Flags: None
*/
function script_resume_speed(msg, rate)
{
	self endon("death");
	fSetspeed = 0;
	type = "resumespeed";
	if(!isdefined(self.resumemsgs))
	{
		self.resumemsgs = [];
	}
	if(isdefined(self.waitingforgate) && self.waitingforgate)
	{
		return;
	}
	if(isdefined(self.attacking) && self.attacking)
	{
		fSetspeed = self.attackspeed;
		type = "setspeed";
	}
	self.zerospeed = 0;
	if(fSetspeed == 0)
	{
		self.zerospeed = 1;
	}
	if(type == "resumespeed")
	{
		self ResumeSpeed(rate);
	}
	else if(type == "setspeed")
	{
		self set_speed(fSetspeed, 15, "resume setspeed from attack");
	}
	self notify("resuming speed");
	/#
		self thread function_f15f4528(msg + "Dev Block strings are not supported" + type);
	#/
}

/*
	Name: function_f15f4528
	Namespace: vehicle
	Checksum: 0xE01AFE90
	Offset: 0x48A8
	Size: 0x113
	Parameters: 1
	Flags: None
*/
function function_f15f4528(msg)
{
	/#
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			return;
		}
		self endon("death");
		Number = self.resumemsgs.size;
		self.resumemsgs[Number] = msg;
		self thread print_resume_speed(GetTime() + 3 * 1000);
		wait(3);
		newArray = [];
		for(i = 0; i < self.resumemsgs.size; i++)
		{
			if(i != Number)
			{
				newArray[newArray.size] = self.resumemsgs[i];
			}
		}
		self.resumemsgs = newArray;
	#/
}

/*
	Name: print_resume_speed
	Namespace: vehicle
	Checksum: 0x8FB96E99
	Offset: 0x49C8
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function print_resume_speed(timer)
{
	self notify("newresumespeedmsag");
	self endon("newresumespeedmsag");
	self endon("death");
	while(GetTime() < timer && isdefined(self.resumemsgs))
	{
		if(self.resumemsgs.size > 6)
		{
			start = self.resumemsgs.size - 5;
		}
		else
		{
			start = 0;
		}
		for(i = start; i < self.resumemsgs.size; i++)
		{
			position = i * 32;
			/#
				print3d(self.origin + (0, 0, position), "Dev Block strings are not supported" + self.resumemsgs[i], (0, 1, 0), 1, 3);
			#/
		}
		wait(0.05);
	}
}

/*
	Name: god_on
	Namespace: vehicle
	Checksum: 0xA4A428F0
	Offset: 0x4B00
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function god_on()
{
	self.takedamage = 0;
}

/*
	Name: god_off
	Namespace: vehicle
	Checksum: 0x8D6DB416
	Offset: 0x4B18
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function god_off()
{
	self.takedamage = 1;
}

/*
	Name: get_normal_anim_time
	Namespace: vehicle
	Checksum: 0xF96FF649
	Offset: 0x4B30
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function get_normal_anim_time(animation)
{
	animtime = self GetAnimTime(animation);
	animlength = getanimlength(animation);
	if(animtime == 0)
	{
		return 0;
	}
	return self GetAnimTime(animation) / getanimlength(animation);
}

/*
	Name: setup_dynamic_detour
	Namespace: vehicle
	Checksum: 0x4807908D
	Offset: 0x4BD0
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function setup_dynamic_detour(pathnode, get_func)
{
	prevnode = [[get_func]](pathnode.targetname);
	/#
		Assert(isdefined(prevnode), "Dev Block strings are not supported");
	#/
	prevnode.detoured = 0;
}

/*
	Name: array_2d_add
	Namespace: vehicle
	Checksum: 0x4C6502EE
	Offset: 0x4C48
	Size: 0x5B
	Parameters: 3
	Flags: None
*/
function array_2d_add(Array, firstelem, newelem)
{
	if(!isdefined(Array[firstelem]))
	{
		Array[firstelem] = [];
	}
	Array[firstelem][Array[firstelem].size] = newelem;
	return Array;
}

/*
	Name: is_node_script_origin
	Namespace: vehicle
	Checksum: 0x631496FF
	Offset: 0x4CB0
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function is_node_script_origin(pathnode)
{
	return isdefined(pathnode.classname) && pathnode.classname == "script_origin";
}

/*
	Name: node_trigger_process
	Namespace: vehicle
	Checksum: 0xA833E79
	Offset: 0x4CF0
	Size: 0x323
	Parameters: 0
	Flags: None
*/
function node_trigger_process()
{
	processtrigger = 0;
	if(isdefined(self.SPAWNFLAGS) && self.SPAWNFLAGS & 1 == 1)
	{
		if(isdefined(self.script_crashtype))
		{
			level.vehicle_crashpaths[level.vehicle_crashpaths.size] = self;
		}
		level.vehicle_startnodes[level.vehicle_startnodes.size] = self;
	}
	if(isdefined(self.script_vehicledetour) && isdefined(self.targetname))
	{
		get_func = undefined;
		if(isdefined(get_from_entity(self.targetname)))
		{
			get_func = &get_from_entity_target;
		}
		if(isdefined(get_from_spawnstruct(self.targetname)))
		{
			get_func = &get_from_spawnstruct_target;
		}
		if(isdefined(get_func))
		{
			setup_dynamic_detour(self, get_func);
			processtrigger = 1;
		}
		else
		{
			setup_groundnode_detour(self);
		}
		level.vehicle_detourpaths = array_2d_add(level.vehicle_detourpaths, self.script_vehicledetour, self);
		/#
			if(level.vehicle_detourpaths[self.script_vehicledetour].size > 2)
			{
				println("Dev Block strings are not supported", self.script_vehicledetour);
			}
		#/
	}
	if(isdefined(self.script_gatetrigger))
	{
		level.vehicle_gatetrigger = array_2d_add(level.vehicle_gatetrigger, self.script_gatetrigger, self);
		self.gateopen = 0;
	}
	if(isdefined(self.script_flag_set))
	{
		if(!isdefined(level.flag) || !isdefined(level.flag[self.script_flag_set]))
		{
			level flag::init(self.script_flag_set);
		}
	}
	if(isdefined(self.script_flag_clear))
	{
		if(!level flag::exists(self.script_flag_clear))
		{
			level flag::init(self.script_flag_clear);
		}
	}
	if(isdefined(self.script_flag_wait))
	{
		if(!level flag::exists(self.script_flag_wait))
		{
			level flag::init(self.script_flag_wait);
		}
	}
	if(isdefined(self.script_VehicleSpawngroup) || isdefined(self.script_VehicleStartMove) || isdefined(self.script_gatetrigger) || isdefined(self.script_vehicleGroupDelete))
	{
		processtrigger = 1;
	}
	if(processtrigger)
	{
		add_proccess_trigger(self);
	}
}

/*
	Name: setup_triggers
	Namespace: vehicle
	Checksum: 0xFE7C03FF
	Offset: 0x5020
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function setup_triggers()
{
	level.vehicle_processtriggers = [];
	triggers = [];
	triggers = ArrayCombine(GetAllVehicleNodes(), GetEntArray("script_origin", "classname"), 1, 0);
	triggers = ArrayCombine(triggers, level.struct, 1, 0);
	triggers = ArrayCombine(triggers, trigger::get_all(), 1, 0);
	Array::thread_all(triggers, &node_trigger_process);
}

/*
	Name: setup_nodes
	Namespace: vehicle
	Checksum: 0x5AAB4E77
	Offset: 0x5118
	Size: 0xE9
	Parameters: 0
	Flags: None
*/
function setup_nodes()
{
	a_nodes = GetAllVehicleNodes();
	foreach(node in a_nodes)
	{
		if(isdefined(node.script_flag_set))
		{
			if(!level flag::exists(node.script_flag_set))
			{
				level flag::init(node.script_flag_set);
			}
		}
	}
}

/*
	Name: is_node_script_struct
	Namespace: vehicle
	Checksum: 0x71242B34
	Offset: 0x5210
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function is_node_script_struct(node)
{
	if(!isdefined(node.targetname))
	{
		return 0;
	}
	return isdefined(struct::get(node.targetname, "targetname"));
}

/*
	Name: setup_spawners
	Namespace: vehicle
	Checksum: 0xD30A2687
	Offset: 0x5268
	Size: 0x3A9
	Parameters: 1
	Flags: None
*/
function setup_spawners(a_veh_spawners)
{
	spawnvehicles = [];
	groups = [];
	foreach(spawner in a_veh_spawners)
	{
		if(isdefined(spawner.script_VehicleSpawngroup))
		{
			if(!isdefined(spawnvehicles[spawner.script_VehicleSpawngroup]))
			{
				spawnvehicles[spawner.script_VehicleSpawngroup] = [];
			}
			else if(!IsArray(spawnvehicles[spawner.script_VehicleSpawngroup]))
			{
				spawnvehicles[spawner.script_VehicleSpawngroup] = Array(spawnvehicles[spawner.script_VehicleSpawngroup]);
			}
			spawnvehicles[spawner.script_VehicleSpawngroup][spawnvehicles[spawner.script_VehicleSpawngroup].size] = spawner;
			addgroup[0] = spawner.script_VehicleSpawngroup;
			groups = ArrayCombine(groups, addgroup, 0, 0);
		}
	}
	waittillframeend;
	foreach(spawnGroup in groups)
	{
		a_veh_spawners = spawnvehicles[spawnGroup];
		level.vehicle_spawners[spawnGroup] = [];
		foreach(SP in a_veh_spawners)
		{
			if(SP.count < 1)
			{
				SP.count = 1;
			}
			set_variables(SP);
			if(!isdefined(level.vehicle_spawners[spawnGroup]))
			{
				level.vehicle_spawners[spawnGroup] = [];
			}
			else if(!IsArray(level.vehicle_spawners[spawnGroup]))
			{
				level.vehicle_spawners[spawnGroup] = Array(level.vehicle_spawners[spawnGroup]);
			}
			level.vehicle_spawners[spawnGroup][level.vehicle_spawners[spawnGroup].size] = SP;
		}
		level thread _spawn_group(spawnGroup);
	}
}

/*
	Name: _vehicle_life
	Namespace: vehicle
	Checksum: 0x32ABBB8B
	Offset: 0x5620
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function _vehicle_life()
{
	if(isdefined(self.destructibledef))
	{
		self.health = 99999;
	}
	else
	{
		type = self.vehicleType;
		if(isdefined(self.script_startinghealth))
		{
			self.health = self.script_startinghealth;
		}
		else if(self.healthdefault == -1)
		{
			return;
		}
		else
		{
			self.health = self.healthdefault;
		}
	}
}

/*
	Name: _vehicle_load_assets
	Namespace: vehicle
	Checksum: 0x99EC1590
	Offset: 0x56A8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function _vehicle_load_assets()
{
}

/*
	Name: is_cheap
	Namespace: vehicle
	Checksum: 0xA4671E65
	Offset: 0x56B8
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function is_cheap()
{
	if(!isdefined(self.script_cheap))
	{
		return 0;
	}
	if(!self.script_cheap)
	{
		return 0;
	}
	return 1;
}

/*
	Name: has_helicopter_dust_kickup
	Namespace: vehicle
	Checksum: 0x77FC3AAD
	Offset: 0x56E8
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function has_helicopter_dust_kickup()
{
	if(!(isdefined(self.vehicleClass) && self.vehicleClass == "plane"))
	{
		return 0;
	}
	if(is_cheap())
	{
		return 0;
	}
	return 1;
}

/*
	Name: play_looped_fx_on_tag
	Namespace: vehicle
	Checksum: 0x7EA7E806
	Offset: 0x5738
	Size: 0xCD
	Parameters: 3
	Flags: None
*/
function play_looped_fx_on_tag(effect, durration, tag)
{
	eModel = get_dummy();
	effectorigin = sys::spawn("script_origin", eModel.origin);
	self endon("fire_extinguish");
	thread _play_looped_fx_on_tag_origin_update(tag, effectorigin);
	while(1)
	{
		playFX(effect, effectorigin.origin, effectorigin.upvec);
		wait(durration);
	}
}

/*
	Name: _play_looped_fx_on_tag_origin_update
	Namespace: vehicle
	Checksum: 0x235AAEC7
	Offset: 0x5810
	Size: 0x1B3
	Parameters: 2
	Flags: None
*/
function _play_looped_fx_on_tag_origin_update(tag, effectorigin)
{
	effectorigin.angles = self GetTagAngles(tag);
	effectorigin.origin = self GetTagOrigin(tag);
	effectorigin.forwardVec = AnglesToForward(effectorigin.angles);
	effectorigin.upvec = anglesToUp(effectorigin.angles);
	while(isdefined(self) && self.classname == "script_vehicle" && self GetSpeedMPH() > 0)
	{
		eModel = get_dummy();
		effectorigin.angles = eModel GetTagAngles(tag);
		effectorigin.origin = eModel GetTagOrigin(tag);
		effectorigin.forwardVec = AnglesToForward(effectorigin.angles);
		effectorigin.upvec = anglesToUp(effectorigin.angles);
		wait(0.05);
	}
}

/*
	Name: setup_dvars
	Namespace: vehicle
	Checksum: 0xA2CFA7DC
	Offset: 0x59D0
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function setup_dvars()
{
	/#
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
	#/
}

/*
	Name: setup_level_vars
	Namespace: vehicle
	Checksum: 0xC7FF180A
	Offset: 0x5A78
	Size: 0x2A3
	Parameters: 0
	Flags: None
*/
function setup_level_vars()
{
	level.vehicle_ResumeSpeed = 5;
	level.vehicle_DeleteGroup = [];
	level.vehicle_SpawnGroup = [];
	level.vehicle_StartMoveGroup = [];
	level.vehicle_DeathSwitch = [];
	level.vehicle_gatetrigger = [];
	level.vehicle_crashpaths = [];
	level.vehicle_link = [];
	level.vehicle_detourpaths = [];
	level.vehicle_startnodes = [];
	level.vehicle_spawners = [];
	level.a_vehicle_types = [];
	level.a_vehicle_targetnames = [];
	level.vehicle_walkercount = [];
	level.helicopter_crash_locations = GetEntArray("helicopter_crash_location", "targetname");
	level.playervehicle = sys::spawn("script_origin", (0, 0, 0));
	level.playervehiclenone = level.playervehicle;
	if(!isdefined(level.vehicle_death_thread))
	{
		level.vehicle_death_thread = [];
	}
	if(!isdefined(level.vehicle_DriveIdle))
	{
		level.vehicle_DriveIdle = [];
	}
	if(!isdefined(level.vehicle_DriveIdle_r))
	{
		level.vehicle_DriveIdle_r = [];
	}
	if(!isdefined(level.attack_origin_condition_threadd))
	{
		level.attack_origin_condition_threadd = [];
	}
	if(!isdefined(level.vehiclefireanim))
	{
		level.vehiclefireanim = [];
	}
	if(!isdefined(level.vehiclefireanim_settle))
	{
		level.vehiclefireanim_settle = [];
	}
	if(!isdefined(level.vehicle_hasname))
	{
		level.vehicle_hasname = [];
	}
	if(!isdefined(level.vehicle_turret_requiresrider))
	{
		level.vehicle_turret_requiresrider = [];
	}
	if(!isdefined(level.vehicle_isStationary))
	{
		level.vehicle_isStationary = [];
	}
	if(!isdefined(level.vehicle_compassicon))
	{
		level.vehicle_compassicon = [];
	}
	if(!isdefined(level.vehicle_unloadgroups))
	{
		level.vehicle_unloadgroups = [];
	}
	if(!isdefined(level.vehicle_unloadwhenattacked))
	{
		level.vehicle_unloadwhenattacked = [];
	}
	if(!isdefined(level.vehicle_deckdust))
	{
		level.vehicle_deckdust = [];
	}
	if(!isdefined(level.vehicle_types))
	{
		level.vehicle_types = [];
	}
	if(!isdefined(level.vehicle_compass_types))
	{
		level.vehicle_compass_types = [];
	}
	if(!isdefined(level.vehicle_bulletshield))
	{
		level.vehicle_bulletshield = [];
	}
	if(!isdefined(level.vehicle_death_badplace))
	{
		level.vehicle_death_badplace = [];
	}
}

/*
	Name: attacker_is_on_my_team
	Namespace: vehicle
	Checksum: 0x2352A77B
	Offset: 0x5D28
	Size: 0x5D
	Parameters: 1
	Flags: None
*/
function attacker_is_on_my_team(attacker)
{
	if(isdefined(attacker) && isdefined(attacker.team) && isdefined(self.team) && attacker.team == self.team)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

/*
	Name: attacker_troop_is_on_my_team
	Namespace: vehicle
	Checksum: 0x92051792
	Offset: 0x5D90
	Size: 0x9D
	Parameters: 1
	Flags: None
*/
function attacker_troop_is_on_my_team(attacker)
{
	if(isdefined(self.team) && self.team == "allies" && isdefined(attacker) && isdefined(level.player) && attacker == level.player)
	{
		return 1;
	}
	else if(isai(attacker) && attacker.team == self.team)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

/*
	Name: bullet_shielded
	Namespace: vehicle
	Checksum: 0xF133E7AE
	Offset: 0x5E38
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function bullet_shielded(type)
{
	if(!isdefined(self.script_bulletshield))
	{
		return 0;
	}
	type = ToLower(type);
	if(!isdefined(type) || !IsSubStr(type, "bullet"))
	{
		return 0;
	}
	if(self.script_bulletshield)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

/*
	Name: friendly_fire_shield
	Namespace: vehicle
	Checksum: 0xA8936637
	Offset: 0x5EC8
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function friendly_fire_shield()
{
	self.friendlyfire_shield = 1;
	if(isdefined(level.vehicle_bulletshield[self.vehicleType]) && !isdefined(self.script_bulletshield))
	{
		self.script_bulletshield = level.vehicle_bulletshield[self.vehicleType];
	}
}

/*
	Name: friendly_fire_shield_callback
	Namespace: vehicle
	Checksum: 0x1420F818
	Offset: 0x5F20
	Size: 0xC5
	Parameters: 3
	Flags: None
*/
function friendly_fire_shield_callback(attacker, amount, type)
{
	if(!isdefined(self.friendlyfire_shield) || !self.friendlyfire_shield)
	{
		return 0;
	}
	if(!isdefined(attacker) && self.team != "neutral" || attacker_is_on_my_team(attacker) || attacker_troop_is_on_my_team(attacker) || is_destructible() || bullet_shielded(type))
	{
		return 1;
	}
	return 0;
}

/*
	Name: _vehicle_bad_place
	Namespace: vehicle
	Checksum: 0xED5B4321
	Offset: 0x5FF0
	Size: 0x205
	Parameters: 0
	Flags: None
*/
function _vehicle_bad_place()
{
	self endon("kill_badplace_forever");
	self endon("death");
	self endon("delete");
	if(isdefined(level.custombadplacethread))
	{
		self thread [[level.custombadplacethread]]();
		return;
	}
	hasturret = isdefined(self.turretWeapon) && self.turretWeapon != level.weaponNone;
	while(1)
	{
		if(!self.script_badplace)
		{
			while(!self.script_badplace)
			{
				wait(0.5);
			}
		}
		speed = self GetSpeedMPH();
		if(speed <= 0)
		{
			wait(0.5);
			continue;
		}
		if(speed < 5)
		{
			bp_radius = 200;
		}
		else if(speed > 5 && speed < 8)
		{
			bp_radius = 350;
		}
		else
		{
			bp_radius = 500;
		}
		if(isdefined(self.BadPlaceModifier))
		{
			bp_radius = bp_radius * self.BadPlaceModifier;
		}
		v_turret_angles = self GetTagAngles("tag_turret");
		if(hasturret && isdefined(v_turret_angles))
		{
			bp_direction = AnglesToForward(v_turret_angles);
		}
		else
		{
			bp_direction = AnglesToForward(self.angles);
		}
		wait(0.5 + 0.05);
	}
}

/*
	Name: get_vehiclenode_any_dynamic
	Namespace: vehicle
	Checksum: 0x507AB904
	Offset: 0x6200
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function get_vehiclenode_any_dynamic(target)
{
	path_start = GetVehicleNode(target, "targetname");
	if(!isdefined(path_start))
	{
		path_start = GetEnt(target, "targetname");
	}
	else if(isdefined(self.vehicleClass) && self.vehicleClass == "plane")
	{
		/#
			println("Dev Block strings are not supported" + path_start.targetname);
			println("Dev Block strings are not supported" + self.vehicleType);
		#/
		/#
			ASSERTMSG("Dev Block strings are not supported");
		#/
	}
	if(!isdefined(path_start))
	{
		path_start = struct::get(target, "targetname");
	}
	return path_start;
}

/*
	Name: resume_path_vehicle
	Namespace: vehicle
	Checksum: 0xF0C85CD4
	Offset: 0x6338
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function resume_path_vehicle()
{
	if(isdefined(self.currentNode.target))
	{
		node = get_vehiclenode_any_dynamic(self.currentNode.target);
	}
	if(isdefined(node))
	{
		self ResumeSpeed(35);
		paths(node);
	}
}

/*
	Name: land
	Namespace: vehicle
	Checksum: 0x446920EB
	Offset: 0x63C8
	Size: 0xDF
	Parameters: 0
	Flags: None
*/
function land()
{
	self SetNearGoalNotifyDist(2);
	self SetHoverParams(0, 0, 10);
	self clearGoalYaw();
	self settargetyaw((0, self.angles[1], 0)[1]);
	self set_goal_pos(bullettrace(self.origin, self.origin + VectorScale((0, 0, -1), 100000), 0, self)["position"], 1);
	self waittill("goal");
}

/*
	Name: set_goal_pos
	Namespace: vehicle
	Checksum: 0x31402E36
	Offset: 0x64B0
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function set_goal_pos(origin, bStop)
{
	if(self.health <= 0)
	{
		return;
	}
	if(isdefined(self.originheightoffset))
	{
		origin = origin + (0, 0, self.originheightoffset);
	}
	self SetVehGoalPos(origin, bStop);
}

/*
	Name: liftoff
	Namespace: vehicle
	Checksum: 0x745AA242
	Offset: 0x6520
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function liftoff(height)
{
	if(!isdefined(height))
	{
		height = 512;
	}
	dest = self.origin + (0, 0, height);
	self SetNearGoalNotifyDist(10);
	self set_goal_pos(dest, 1);
	self waittill("goal");
}

/*
	Name: wait_till_stable
	Namespace: vehicle
	Checksum: 0x760857E7
	Offset: 0x65B0
	Size: 0xCF
	Parameters: 0
	Flags: None
*/
function wait_till_stable()
{
	timer = GetTime() + 400;
	while(isdefined(self))
	{
		if(self.angles[0] > 12 || self.angles[0] < -1 * 12)
		{
			timer = GetTime() + 400;
		}
		if(self.angles[2] > 12 || self.angles[2] < -1 * 12)
		{
			timer = GetTime() + 400;
		}
		if(GetTime() > timer)
		{
			break;
		}
		wait(0.05);
	}
}

/*
	Name: unload_node
	Namespace: vehicle
	Checksum: 0x4BA1EDCA
	Offset: 0x6688
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function unload_node(node)
{
	if(isdefined(self.custom_unload_function))
	{
		[[self.custom_unload_function]]();
		return;
	}
	pause_path();
	if(isdefined(self.vehicleClass) && self.vehicleClass == "plane")
	{
		wait_till_stable();
	}
	else if(isdefined(self.vehicleClass) && self.vehicleClass == "helicopter")
	{
		self SetHoverParams(0, 0, 10);
		wait_till_stable();
	}
	if(node is_unload_node())
	{
		unload(node.script_unload);
	}
}

/*
	Name: is_unload_node
	Namespace: vehicle
	Checksum: 0xB5E6094F
	Offset: 0x6788
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function is_unload_node()
{
	return isdefined(self.script_unload) && self.script_unload != "none";
}

/*
	Name: unload_node_helicopter
	Namespace: vehicle
	Checksum: 0x528EE15D
	Offset: 0x67B0
	Size: 0x213
	Parameters: 1
	Flags: None
*/
function unload_node_helicopter(node)
{
	if(isdefined(self.custom_unload_function))
	{
		self thread [[self.custom_unload_function]]();
	}
	self SetHoverParams(0, 0, 10);
	goal = self.nextnode.origin;
	start = self.nextnode.origin;
	end = start - VectorScale((0, 0, 1), 10000);
	trace = bullettrace(start, end, 0, undefined, 1);
	if(trace["fraction"] <= 1)
	{
		goal = (trace["position"][0], trace["position"][1], trace["position"][2] + self.fastropeoffset);
	}
	drop_offset_tag = "tag_fastrope_ri";
	if(isdefined(self.drop_offset_tag))
	{
		drop_offset_tag = self.drop_offset_tag;
	}
	drop_offset = self GetTagOrigin("tag_origin") - self GetTagOrigin(drop_offset_tag);
	goal = goal + (drop_offset[0], drop_offset[1], 0);
	self SetVehGoalPos(goal, 1);
	self waittill("goal");
	self notify("unload", self.nextnode.script_unload);
	self waittill("unloaded");
}

/*
	Name: detach_path
	Namespace: vehicle
	Checksum: 0x7F7F9E4D
	Offset: 0x69D0
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function detach_path()
{
	self.attachedpath = undefined;
	self notify("newpath");
	self SetGoalYaw((0, self.angles[1], 0)[1]);
	self SetVehGoalPos(self.origin + VectorScale((0, 0, 1), 4), 1);
}

/*
	Name: setup_targetname_spawners
	Namespace: vehicle
	Checksum: 0x6CE3534A
	Offset: 0x6A58
	Size: 0x20D
	Parameters: 0
	Flags: None
*/
function setup_targetname_spawners()
{
	level.vehicle_targetname_array = [];
	vehicles = GetEntArray("script_vehicle", "classname");
	n_highest_group = 0;
	foreach(vh in vehicles)
	{
		if(isdefined(vh.script_VehicleSpawngroup))
		{
			n_spawn_group = Int(vh.script_VehicleSpawngroup);
			if(n_spawn_group > n_highest_group)
			{
				n_highest_group = n_spawn_group;
			}
		}
	}
	for(i = 0; i < vehicles.size; i++)
	{
		vehicle = vehicles[i];
		if(isdefined(vehicle.targetname) && IsVehicleSpawner(vehicle))
		{
			if(!isdefined(vehicle.script_VehicleSpawngroup))
			{
				n_highest_group++;
				vehicle.script_VehicleSpawngroup = n_highest_group;
			}
			if(!isdefined(level.vehicle_targetname_array[vehicle.targetname]))
			{
				level.vehicle_targetname_array[vehicle.targetname] = [];
			}
			level.vehicle_targetname_array[vehicle.targetname][vehicle.script_VehicleSpawngroup] = 1;
		}
	}
}

/*
	Name: simple_spawn
	Namespace: vehicle
	Checksum: 0x5F3AA380
	Offset: 0x6C70
	Size: 0x181
	Parameters: 2
	Flags: None
*/
function simple_spawn(name, b_supress_assert)
{
	if(!isdefined(b_supress_assert))
	{
		b_supress_assert = 0;
	}
	/#
		Assert(b_supress_assert || isdefined(level.vehicle_targetname_array[name]), "Dev Block strings are not supported" + name);
	#/
	vehicles = [];
	if(isdefined(level.vehicle_targetname_array[name]))
	{
		Array = level.vehicle_targetname_array[name];
		if(Array.size > 0)
		{
			keys = getArrayKeys(Array);
			foreach(key in keys)
			{
				vehicle_array = _scripted_spawn(key);
				vehicles = ArrayCombine(vehicles, vehicle_array, 1, 0);
			}
		}
	}
	return vehicles;
}

/*
	Name: simple_spawn_single
	Namespace: vehicle
	Checksum: 0x6429205E
	Offset: 0x6E00
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function simple_spawn_single(name, b_supress_assert)
{
	if(!isdefined(b_supress_assert))
	{
		b_supress_assert = 0;
	}
	vehicle_array = simple_spawn(name, b_supress_assert);
	/#
		Assert(b_supress_assert || vehicle_array.size == 1, "Dev Block strings are not supported" + name + "Dev Block strings are not supported" + vehicle_array.size + "Dev Block strings are not supported");
	#/
	if(vehicle_array.size > 0)
	{
		return vehicle_array[0];
	}
}

/*
	Name: simple_spawn_single_and_drive
	Namespace: vehicle
	Checksum: 0xD2315509
	Offset: 0x6EC8
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function simple_spawn_single_and_drive(name)
{
	vehicleArray = simple_spawn(name);
	/#
		Assert(vehicleArray.size == 1, "Dev Block strings are not supported" + name + "Dev Block strings are not supported" + vehicleArray.size + "Dev Block strings are not supported");
	#/
	vehicleArray[0] thread go_path();
	return vehicleArray[0];
}

/*
	Name: simple_spawn_and_drive
	Namespace: vehicle
	Checksum: 0x63B8258
	Offset: 0x6F70
	Size: 0x79
	Parameters: 1
	Flags: None
*/
function simple_spawn_and_drive(name)
{
	vehicleArray = simple_spawn(name);
	for(i = 0; i < vehicleArray.size; i++)
	{
		vehicleArray[i] thread go_path();
	}
	return vehicleArray;
}

/*
	Name: spawn
	Namespace: vehicle
	Checksum: 0xA4535D12
	Offset: 0x6FF8
	Size: 0xD9
	Parameters: 6
	Flags: None
*/
function spawn(modelName, targetname, vehicleType, origin, angles, destructibledef)
{
	/#
		Assert(isdefined(targetname));
	#/
	/#
		Assert(isdefined(vehicleType));
	#/
	/#
		Assert(isdefined(origin));
	#/
	/#
		Assert(isdefined(angles));
	#/
	return SpawnVehicle(vehicleType, origin, angles, targetname, destructibledef);
}

/*
	Name: aircraft_dust_kickup
	Namespace: vehicle
	Checksum: 0x55371F96
	Offset: 0x70E0
	Size: 0x38F
	Parameters: 1
	Flags: None
*/
function aircraft_dust_kickup(model)
{
	self endon("death");
	self endon("death_finished");
	self endon("stop_kicking_up_dust");
	/#
		Assert(isdefined(self.vehicleType));
	#/
	doTraceThisFrame = 3;
	repeatRate = 1;
	trace = undefined;
	d = undefined;
	trace_ent = self;
	if(isdefined(model))
	{
		trace_ent = model;
	}
	while(isdefined(self))
	{
		if(repeatRate <= 0)
		{
			repeatRate = 1;
		}
		wait(repeatRate);
		if(!isdefined(self))
		{
			return;
		}
		doTraceThisFrame--;
		if(doTraceThisFrame <= 0)
		{
			doTraceThisFrame = 3;
			trace = bullettrace(trace_ent.origin, trace_ent.origin - VectorScale((0, 0, 1), 100000), 0, trace_ent);
			d = Distance(trace_ent.origin, trace["position"]);
			repeatRate = d - 350 / 1200 - 350 * 0.15 - 0.05 + 0.05;
		}
		if(!isdefined(trace))
		{
			continue;
		}
		/#
			Assert(isdefined(d));
		#/
		if(d > 1200)
		{
			repeatRate = 1;
			continue;
		}
		if(isdefined(trace["entity"]))
		{
			repeatRate = 1;
			continue;
		}
		if(!isdefined(trace["position"]))
		{
			repeatRate = 1;
			continue;
		}
		if(!isdefined(trace["surfacetype"]))
		{
			trace["surfacetype"] = "dirt";
		}
		/#
			Assert(isdefined(level._vehicle_effect[self.vehicleType]), self.vehicleType + "Dev Block strings are not supported");
		#/
		/#
			Assert(isdefined(level._vehicle_effect[self.vehicleType][trace["Dev Block strings are not supported"]]), "Dev Block strings are not supported" + trace["Dev Block strings are not supported"]);
		#/
		if(level._vehicle_effect[self.vehicleType][trace["surfacetype"]] != -1)
		{
			playFX(level._vehicle_effect[self.vehicleType][trace["surfacetype"]], trace["position"]);
		}
	}
}

/*
	Name: impact_fx
	Namespace: vehicle
	Checksum: 0x1DE37D03
	Offset: 0x7478
	Size: 0x1C3
	Parameters: 2
	Flags: None
*/
function impact_fx(fxName, surfaceTypes)
{
	if(isdefined(fxName))
	{
		body = self GetTagOrigin("tag_body");
		if(!isdefined(body))
		{
			body = self.origin + VectorScale((0, 0, 1), 10);
		}
		trace = bullettrace(body, body - (0, 0, 2 * self.radius), 0, self);
		if(trace["fraction"] < 1 && !isdefined(trace["entity"]) && (!isdefined(surfaceTypes) || Array::contains(surfaceTypes, trace["surfacetype"])))
		{
			pos = 0.5 * self.origin + trace["position"];
			up = 0.5 * trace["normal"] + anglesToUp(self.angles);
			FORWARD = AnglesToForward(self.angles);
			playFX(fxName, pos, up, FORWARD);
		}
	}
}

/*
	Name: maingun_fx
	Namespace: vehicle
	Checksum: 0x1F593402
	Offset: 0x7648
	Size: 0xF7
	Parameters: 0
	Flags: None
*/
function maingun_fx()
{
	if(!isdefined(level.vehicle_deckdust[self.model]))
	{
		return;
	}
	self endon("death");
	while(1)
	{
		self waittill("weapon_fired");
		PlayFXOnTag(level.vehicle_deckdust[self.model], self, "tag_engine_exhaust");
		barrel_origin = self GetTagOrigin("tag_flash");
		GROUND = PhysicsTrace(barrel_origin, barrel_origin + VectorScale((0, 0, -1), 128));
		PhysicsExplosionSphere(GROUND, 192, 100, 1);
	}
}

/*
	Name: lights_on
	Namespace: vehicle
	Checksum: 0xD5EB0447
	Offset: 0x7748
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function lights_on(team)
{
	if(isdefined(team))
	{
		if(team == "allies")
		{
			self clientfield::set("toggle_lights", 2);
		}
		else if(team == "axis")
		{
			self clientfield::set("toggle_lights", 3);
		}
	}
	else
	{
		self clientfield::set("toggle_lights", 0);
	}
}

/*
	Name: lights_off
	Namespace: vehicle
	Checksum: 0xCAE79F65
	Offset: 0x77F8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function lights_off()
{
	self clientfield::set("toggle_lights", 1);
}

/*
	Name: toggle_lights_group
	Namespace: vehicle
	Checksum: 0x6A105985
	Offset: 0x7828
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function toggle_lights_group(groupID, on)
{
	bit = 1;
	if(!on)
	{
		bit = 0;
	}
	self clientfield::set("toggle_lights_group" + groupID, bit);
}

/*
	Name: toggle_ambient_anim_group
	Namespace: vehicle
	Checksum: 0x7C8D6446
	Offset: 0x7890
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function toggle_ambient_anim_group(groupID, on)
{
	bit = 1;
	if(!on)
	{
		bit = 0;
	}
	self clientfield::set("toggle_ambient_anim_group" + groupID, bit);
}

/*
	Name: do_death_fx
	Namespace: vehicle
	Checksum: 0x56705A84
	Offset: 0x78F8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function do_death_fx()
{
	if(self.died_by_emp === 1)
	{
	}
	else
	{
	}
	deathfxtype = 1;
	self clientfield::set("deathfx", deathfxtype);
	self stopsounds();
}

/*
	Name: toggle_emp_fx
	Namespace: vehicle
	Checksum: 0xBEBA4671
	Offset: 0x7968
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function toggle_emp_fx(on)
{
	self clientfield::set("toggle_emp_fx", on);
}

/*
	Name: toggle_burn_fx
	Namespace: vehicle
	Checksum: 0x64C99A8C
	Offset: 0x79A0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function toggle_burn_fx(on)
{
	self clientfield::set("toggle_burn_fx", on);
}

/*
	Name: do_death_dynents
	Namespace: vehicle
	Checksum: 0x924B7C73
	Offset: 0x79D8
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function do_death_dynents(special_status)
{
	if(!isdefined(special_status))
	{
		special_status = 1;
	}
	/#
		Assert(special_status >= 0 && special_status <= 3);
	#/
	self clientfield::set("spawn_death_dynents", special_status);
}

/*
	Name: do_gib_dynents
	Namespace: vehicle
	Checksum: 0x3BC37FF9
	Offset: 0x7A50
	Size: 0xBD
	Parameters: 0
	Flags: None
*/
function do_gib_dynents()
{
	self clientfield::set("spawn_gib_dynents", 1);
	numDynents = 2;
	for(i = 0; i < numDynents; i++)
	{
		hidetag = GetStructField(self.settings, "servo_gib_tag" + i);
		if(isdefined(hidetag))
		{
			self HidePart(hidetag, "", 1);
		}
	}
}

/*
	Name: set_alert_fx_level
	Namespace: vehicle
	Checksum: 0x71F0A60B
	Offset: 0x7B18
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function set_alert_fx_level(alert_level)
{
	self clientfield::set("alert_level", alert_level);
}

/*
	Name: should_update_damage_fx_level
	Namespace: vehicle
	Checksum: 0x16A15E96
	Offset: 0x7B50
	Size: 0x3AB
	Parameters: 3
	Flags: None
*/
function should_update_damage_fx_level(currentHealth, damage, maxhealth)
{
	settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	if(!isdefined(settings))
	{
		return 0;
	}
	currentRatio = math::clamp(float(currentHealth) / float(maxhealth), 0, 1);
	afterDamageRatio = math::clamp(float(currentHealth - damage) / float(maxhealth), 0, 1);
	currentLevel = undefined;
	afterDamageLevel = undefined;
	if(isdefined(settings.damagestate_numStates))
	{
	}
	else
	{
	}
	switch(0)
	{
		case 6:
		{
			if(settings.damagestate_lv6_ratio >= afterDamageRatio)
			{
				afterDamageLevel = 6;
				currentLevel = 6;
				if(settings.damagestate_lv6_ratio < currentRatio)
				{
					currentLevel = 5;
				}
				break;
			}
		}
		case 5:
		{
			if(settings.damagestate_lv5_ratio >= afterDamageRatio)
			{
				afterDamageLevel = 5;
				currentLevel = 5;
				if(settings.damagestate_lv5_ratio < currentRatio)
				{
					currentLevel = 4;
				}
				break;
			}
		}
		case 4:
		{
			if(settings.damagestate_lv4_ratio >= afterDamageRatio)
			{
				afterDamageLevel = 4;
				currentLevel = 4;
				if(settings.damagestate_lv4_ratio < currentRatio)
				{
					currentLevel = 3;
				}
				break;
			}
		}
		case 3:
		{
			if(settings.damagestate_lv3_ratio >= afterDamageRatio)
			{
				afterDamageLevel = 3;
				currentLevel = 3;
				if(settings.damagestate_lv3_ratio < currentRatio)
				{
					currentLevel = 2;
				}
				break;
			}
		}
		case 2:
		{
			if(settings.damagestate_lv2_ratio >= afterDamageRatio)
			{
				afterDamageLevel = 2;
				currentLevel = 2;
				if(settings.damagestate_lv2_ratio < currentRatio)
				{
					currentLevel = 1;
				}
				break;
			}
		}
		case 1:
		{
			if(settings.damagestate_lv1_ratio >= afterDamageRatio)
			{
				afterDamageLevel = 1;
				currentLevel = 1;
				if(settings.damagestate_lv1_ratio < currentRatio)
				{
					currentLevel = 0;
				}
				break;
			}
		}
		case default:
		{
		}
	}
	if(!isdefined(currentLevel) || !isdefined(afterDamageLevel))
	{
		return 0;
	}
	if(currentLevel != afterDamageLevel)
	{
		return afterDamageLevel;
	}
	return 0;
}

/*
	Name: update_damage_fx_level
	Namespace: vehicle
	Checksum: 0x2D151FA6
	Offset: 0x7F08
	Size: 0x73
	Parameters: 3
	Flags: None
*/
function update_damage_fx_level(currentHealth, damage, maxhealth)
{
	newDamageLevel = should_update_damage_fx_level(currentHealth, damage, maxhealth);
	if(newDamageLevel > 0)
	{
		self set_damage_fx_level(newDamageLevel);
		return 1;
	}
	return 0;
}

/*
	Name: set_damage_fx_level
	Namespace: vehicle
	Checksum: 0x89959B06
	Offset: 0x7F88
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function set_damage_fx_level(damage_level)
{
	self clientfield::set("damage_level", damage_level);
}

/*
	Name: build_drive
	Namespace: vehicle
	Checksum: 0x2F931624
	Offset: 0x7FC0
	Size: 0xA5
	Parameters: 4
	Flags: None
*/
function build_drive(FORWARD, reverse, normalspeed, rate)
{
	if(!isdefined(normalspeed))
	{
		normalspeed = 10;
	}
	level.vehicle_DriveIdle[self.model] = FORWARD;
	if(isdefined(reverse))
	{
		level.vehicle_DriveIdle_r[self.model] = reverse;
	}
	level.vehicle_DriveIdle_normal_speed[self.model] = normalspeed;
	if(isdefined(rate))
	{
		level.vehicle_DriveIdle_animrate[self.model] = rate;
	}
}

/*
	Name: get_from_spawnstruct
	Namespace: vehicle
	Checksum: 0x507F770F
	Offset: 0x8070
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function get_from_spawnstruct(target)
{
	return struct::get(target, "targetname");
}

/*
	Name: get_from_entity
	Namespace: vehicle
	Checksum: 0xAC16740F
	Offset: 0x80A8
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function get_from_entity(target)
{
	return GetEnt(target, "targetname");
}

/*
	Name: get_from_spawnstruct_target
	Namespace: vehicle
	Checksum: 0x9A529C78
	Offset: 0x80E0
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function get_from_spawnstruct_target(target)
{
	return struct::get(target, "target");
}

/*
	Name: get_from_entity_target
	Namespace: vehicle
	Checksum: 0x54CFB24D
	Offset: 0x8118
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function get_from_entity_target(target)
{
	return GetEnt(target, "target");
}

/*
	Name: is_destructible
	Namespace: vehicle
	Checksum: 0xE70A7877
	Offset: 0x8150
	Size: 0xB
	Parameters: 0
	Flags: None
*/
function is_destructible()
{
	return isdefined(self.destructible_type);
}

/*
	Name: attack_group_think
	Namespace: vehicle
	Checksum: 0xBA8D2384
	Offset: 0x8168
	Size: 0x2CB
	Parameters: 0
	Flags: None
*/
function attack_group_think()
{
	self endon("death");
	self endon("switch group");
	self endon("killed all targets");
	if(isdefined(self.script_vehicleattackgroupwait))
	{
		wait(self.script_vehicleattackgroupwait);
	}
	for(;;)
	{
		group = GetEntArray("script_vehicle", "classname");
		valid_targets = [];
		for(i = 0; i < group.size; i++)
		{
			if(!isdefined(group[i].script_VehicleSpawngroup))
			{
				continue;
			}
			if(group[i].script_VehicleSpawngroup == self.script_vehicleattackgroup)
			{
				if(group[i].team != self.team)
				{
					if(!isdefined(valid_targets))
					{
						valid_targets = [];
					}
					else if(!IsArray(valid_targets))
					{
						valid_targets = Array(valid_targets);
					}
					valid_targets[valid_targets.size] = group[i];
				}
			}
		}
		if(valid_targets.size == 0)
		{
			wait(0.5);
			continue;
		}
		for(;;)
		{
			current_target = undefined;
			if(valid_targets.size != 0)
			{
				current_target = self get_nearest_target(valid_targets);
			}
			else
			{
				self notify("killed all targets");
			}
			if(current_target.health <= 0)
			{
				ArrayRemoveValue(valid_targets, current_target);
				continue;
				continue;
			}
			self SetTurretTargetEnt(current_target, VectorScale((0, 0, 1), 50));
			if(isdefined(self.fire_delay_min) && isdefined(self.fire_delay_max))
			{
				if(self.fire_delay_max < self.fire_delay_min)
				{
					self.fire_delay_max = self.fire_delay_min;
				}
				wait(randomIntRange(self.fire_delay_min, self.fire_delay_max));
			}
			else
			{
				wait(randomIntRange(4, 6));
			}
			self FireWeapon();
		}
	}
}

/*
	Name: get_nearest_target
	Namespace: vehicle
	Checksum: 0xA4A305EA
	Offset: 0x8440
	Size: 0xD5
	Parameters: 1
	Flags: None
*/
function get_nearest_target(valid_targets)
{
	nearest_distsq = 99999999;
	nearest = undefined;
	for(i = 0; i < valid_targets.size; i++)
	{
		if(!isdefined(valid_targets[i]))
		{
			continue;
		}
		current_distsq = DistanceSquared(self.origin, valid_targets[i].origin);
		if(current_distsq < nearest_distsq)
		{
			nearest_distsq = current_distsq;
			nearest = valid_targets[i];
		}
	}
	return nearest;
}

/*
	Name: debug_vehicle
	Namespace: vehicle
	Checksum: 0x6968E79E
	Offset: 0x8520
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function debug_vehicle()
{
	/#
		self endon("death");
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		while(1)
		{
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				print3d(self.origin, "Dev Block strings are not supported" + self.health, (1, 1, 1), 1, 3);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: debug_vehicle_paths
	Namespace: vehicle
	Checksum: 0xCCDD0C38
	Offset: 0x85E8
	Size: 0x13F
	Parameters: 0
	Flags: None
*/
function debug_vehicle_paths()
{
	/#
		self endon("death");
		self endon("newpath");
		self endon("reached_dynamic_path_end");
		nextnode = self.currentNode;
		while(1)
		{
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				recordLine(self.origin, self.currentNode.origin, (1, 0, 0), "Dev Block strings are not supported", self);
				recordLine(self.origin, nextnode.origin, (0, 1, 0), "Dev Block strings are not supported", self);
				recordLine(self.currentNode.origin, nextnode.origin, (1, 1, 1), "Dev Block strings are not supported", self);
			}
			wait(0.05);
			if(isdefined(self.nextnode) && self.nextnode != nextnode)
			{
				nextnode = self.nextnode;
			}
		}
	#/
}

/*
	Name: get_dummy
	Namespace: vehicle
	Checksum: 0xE9344D2E
	Offset: 0x8730
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function get_dummy()
{
	if(isdefined(self.modeldummyon) && self.modeldummyon)
	{
		eModel = self.modeldummy;
	}
	else
	{
		eModel = self;
	}
	return eModel;
}

/*
	Name: add_main_callback
	Namespace: vehicle
	Checksum: 0xD13E788E
	Offset: 0x8778
	Size: 0x7D
	Parameters: 2
	Flags: None
*/
function add_main_callback(vehicleType, main)
{
	if(!isdefined(level.vehicle_main_callback))
	{
		level.vehicle_main_callback = [];
	}
	/#
		if(isdefined(level.vehicle_main_callback[vehicleType]))
		{
			println("Dev Block strings are not supported" + vehicleType + "Dev Block strings are not supported");
		}
	#/
	level.vehicle_main_callback[vehicleType] = main;
}

/*
	Name: vehicle_get_occupant_team
	Namespace: vehicle
	Checksum: 0x78108709
	Offset: 0x8800
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function vehicle_get_occupant_team()
{
	occupants = self GetVehOccupants();
	if(occupants.size != 0)
	{
		occupant = occupants[0];
		if(isPlayer(occupant))
		{
			return occupant.team;
		}
	}
	return self.team;
}

/*
	Name: toggle_exhaust_fx
	Namespace: vehicle
	Checksum: 0x8EEC6F80
	Offset: 0x8888
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function toggle_exhaust_fx(on)
{
	if(!on)
	{
		self clientfield::set("toggle_exhaustfx", 1);
	}
	else
	{
		self clientfield::set("toggle_exhaustfx", 0);
	}
}

/*
	Name: toggle_tread_fx
	Namespace: vehicle
	Checksum: 0xF167DA92
	Offset: 0x88E8
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function toggle_tread_fx(on)
{
	if(on)
	{
		self clientfield::set("toggle_treadfx", 1);
	}
	else
	{
		self clientfield::set("toggle_treadfx", 0);
	}
}

/*
	Name: toggle_sounds
	Namespace: vehicle
	Checksum: 0x81E02204
	Offset: 0x8948
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function toggle_sounds(on)
{
	if(!on)
	{
		self clientfield::set("toggle_sounds", 1);
	}
	else
	{
		self clientfield::set("toggle_sounds", 0);
	}
}

/*
	Name: is_corpse
	Namespace: vehicle
	Checksum: 0x6B3793BC
	Offset: 0x89A8
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function is_corpse(veh)
{
	if(isdefined(veh))
	{
		if(isdefined(veh.isacorpse) && veh.isacorpse)
		{
			return 1;
		}
		else if(isdefined(veh.classname) && veh.classname == "script_vehicle_corpse")
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: is_on
	Namespace: vehicle
	Checksum: 0x1E70218C
	Offset: 0x8A30
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function is_on(vehicle)
{
	if(!isdefined(self.viewlockedentity))
	{
		return 0;
	}
	else if(self.viewlockedentity == vehicle)
	{
		return 1;
	}
	if(!isdefined(self.groundentity))
	{
		return 0;
	}
	else if(self.groundentity == vehicle)
	{
		return 1;
	}
	return 0;
}

/*
	Name: add_spawn_function
	Namespace: vehicle
	Checksum: 0x8E6C9390
	Offset: 0x8AA0
	Size: 0x157
	Parameters: 6
	Flags: None
*/
function add_spawn_function(veh_targetname, spawn_func, param1, param2, param3, param4)
{
	func = [];
	func["function"] = spawn_func;
	func["param1"] = param1;
	func["param2"] = param2;
	func["param3"] = param3;
	func["param4"] = param4;
	if(!isdefined(level.a_vehicle_targetnames))
	{
		level.a_vehicle_targetnames = [];
	}
	if(!isdefined(level.a_vehicle_targetnames[veh_targetname]))
	{
		level.a_vehicle_targetnames[veh_targetname] = [];
	}
	else if(!IsArray(level.a_vehicle_targetnames[veh_targetname]))
	{
		level.a_vehicle_targetnames[veh_targetname] = Array(level.a_vehicle_targetnames[veh_targetname]);
	}
	level.a_vehicle_targetnames[veh_targetname][level.a_vehicle_targetnames[veh_targetname].size] = func;
}

/*
	Name: add_spawn_function_by_type
	Namespace: vehicle
	Checksum: 0x94639992
	Offset: 0x8C00
	Size: 0x157
	Parameters: 6
	Flags: None
*/
function add_spawn_function_by_type(veh_type, spawn_func, param1, param2, param3, param4)
{
	func = [];
	func["function"] = spawn_func;
	func["param1"] = param1;
	func["param2"] = param2;
	func["param3"] = param3;
	func["param4"] = param4;
	if(!isdefined(level.a_vehicle_types))
	{
		level.a_vehicle_types = [];
	}
	if(!isdefined(level.a_vehicle_types[veh_type]))
	{
		level.a_vehicle_types[veh_type] = [];
	}
	else if(!IsArray(level.a_vehicle_types[veh_type]))
	{
		level.a_vehicle_types[veh_type] = Array(level.a_vehicle_types[veh_type]);
	}
	level.a_vehicle_types[veh_type][level.a_vehicle_types[veh_type].size] = func;
}

/*
	Name: add_hijack_function
	Namespace: vehicle
	Checksum: 0x76A27C14
	Offset: 0x8D60
	Size: 0x157
	Parameters: 6
	Flags: None
*/
function add_hijack_function(veh_targetname, spawn_func, param1, param2, param3, param4)
{
	func = [];
	func["function"] = spawn_func;
	func["param1"] = param1;
	func["param2"] = param2;
	func["param3"] = param3;
	func["param4"] = param4;
	if(!isdefined(level.a_vehicle_hijack_targetnames))
	{
		level.a_vehicle_hijack_targetnames = [];
	}
	if(!isdefined(level.a_vehicle_hijack_targetnames[veh_targetname]))
	{
		level.a_vehicle_hijack_targetnames[veh_targetname] = [];
	}
	else if(!IsArray(level.a_vehicle_hijack_targetnames[veh_targetname]))
	{
		level.a_vehicle_hijack_targetnames[veh_targetname] = Array(level.a_vehicle_hijack_targetnames[veh_targetname]);
	}
	level.a_vehicle_hijack_targetnames[veh_targetname][level.a_vehicle_hijack_targetnames[veh_targetname].size] = func;
}

/*
	Name: _watch_for_hijacked_vehicles
	Namespace: vehicle
	Checksum: 0x566BF525
	Offset: 0x8EC0
	Size: 0x18D
	Parameters: 0
	Flags: Private
*/
function private _watch_for_hijacked_vehicles()
{
	while(1)
	{
		level waittill("ClonedEntity", clone);
		str_targetname = clone.targetname;
		if(isdefined(str_targetname) && StrEndsWith(str_targetname, "_ai"))
		{
			str_targetname = GetSubStr(str_targetname, 0, str_targetname.size - 3);
		}
		waittillframeend;
		if(isdefined(str_targetname) && isdefined(level.a_vehicle_hijack_targetnames) && isdefined(level.a_vehicle_hijack_targetnames[str_targetname]))
		{
			foreach(func in level.a_vehicle_hijack_targetnames[str_targetname])
			{
				util::single_thread(clone, func["function"], func["param1"], func["param2"], func["param3"], func["param4"]);
			}
		}
	}
}

/*
	Name: disconnect_paths
	Namespace: vehicle
	Checksum: 0x8B1AD4C9
	Offset: 0x9058
	Size: 0x73
	Parameters: 2
	Flags: None
*/
function disconnect_paths(detail_level, move_allowed)
{
	if(!isdefined(detail_level))
	{
		detail_level = 2;
	}
	if(!isdefined(move_allowed))
	{
		move_allowed = 1;
	}
	self disconnectpaths(detail_level, move_allowed);
	self EnableObstacle(0);
}

/*
	Name: connect_paths
	Namespace: vehicle
	Checksum: 0x5EE00D34
	Offset: 0x90D8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function connect_paths()
{
	self connectpaths();
	self EnableObstacle(1);
}

/*
	Name: init_target_group
	Namespace: vehicle
	Checksum: 0xD02D2CD0
	Offset: 0x9118
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function init_target_group()
{
	self.target_group = [];
}

/*
	Name: add_to_target_group
	Namespace: vehicle
	Checksum: 0x6B6DC23C
	Offset: 0x9130
	Size: 0xA1
	Parameters: 1
	Flags: None
*/
function add_to_target_group(target_ent)
{
	/#
		Assert(isdefined(self.target_group), "Dev Block strings are not supported");
	#/
	if(!isdefined(self.target_group))
	{
		self.target_group = [];
	}
	else if(!IsArray(self.target_group))
	{
		self.target_group = Array(self.target_group);
	}
	self.target_group[self.target_group.size] = target_ent;
}

/*
	Name: remove_from_target_group
	Namespace: vehicle
	Checksum: 0xD3B10DB0
	Offset: 0x91E0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function remove_from_target_group(target_ent)
{
	/#
		Assert(isdefined(self.target_group), "Dev Block strings are not supported");
	#/
	ArrayRemoveValue(self.target_group, target_ent);
}

/*
	Name: monitor_missiles_locked_on_to_me
	Namespace: vehicle
	Checksum: 0x21F2016C
	Offset: 0x9240
	Size: 0xED
	Parameters: 2
	Flags: None
*/
function monitor_missiles_locked_on_to_me(player, wait_time)
{
	if(!isdefined(wait_time))
	{
		wait_time = 0.1;
	}
	monitored_entity = self;
	monitored_entity endon("death");
	/#
		Assert(isdefined(monitored_entity.target_group), "Dev Block strings are not supported");
	#/
	player endon("stop_monitor_missile_locked_on_to_me");
	player endon("disconnect");
	player endon("joined_team");
	while(1)
	{
		closest_attacker = player get_closest_attacker_with_missile_locked_on_to_me(monitored_entity);
		player SetVehicleLockedOnByEnt(closest_attacker);
		wait(wait_time);
	}
}

/*
	Name: stop_monitor_missiles_locked_on_to_me
	Namespace: vehicle
	Checksum: 0xBB900BC6
	Offset: 0x9338
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function stop_monitor_missiles_locked_on_to_me()
{
	self notify("stop_monitor_missile_locked_on_to_me");
}

/*
	Name: get_closest_attacker_with_missile_locked_on_to_me
	Namespace: vehicle
	Checksum: 0x988C90AE
	Offset: 0x9358
	Size: 0x2A9
	Parameters: 1
	Flags: None
*/
function get_closest_attacker_with_missile_locked_on_to_me(monitored_entity)
{
	/#
		Assert(isdefined(monitored_entity.target_group), "Dev Block strings are not supported");
	#/
	player = self;
	closest_attacker = undefined;
	closest_attacker_dot = -999;
	view_origin = player GetPlayerCameraPos();
	view_forward = AnglesToForward(player getPlayerAngles());
	remaining_locked_on_flags = 0;
	foreach(target_ent in monitored_entity.target_group)
	{
		if(isdefined(target_ent) && isdefined(target_ent.locked_on))
		{
			remaining_locked_on_flags = remaining_locked_on_flags | target_ent.locked_on;
		}
	}
	for(i = 0; remaining_locked_on_flags && i < level.players.size; i++)
	{
		attacker = level.players[i];
		if(isdefined(attacker))
		{
			client_flag = 1 << attacker GetEntityNumber();
			if(client_flag & remaining_locked_on_flags)
			{
				to_attacker = VectorNormalize(attacker.origin - view_origin);
				attacker_dot = VectorDot(view_forward, to_attacker);
				if(attacker_dot > closest_attacker_dot)
				{
					closest_attacker = attacker;
					closest_attacker_dot = attacker_dot;
				}
				~closest_attacker_dot;
				remaining_locked_on_flags = remaining_locked_on_flags & client_flag;
			}
		}
	}
	return closest_attacker;
}

/*
	Name: set_vehicle_drivable_time_starting_now
	Namespace: vehicle
	Checksum: 0x79449A
	Offset: 0x9610
	Size: 0x3F
	Parameters: 1
	Flags: None
*/
function set_vehicle_drivable_time_starting_now(duration_ms)
{
	end_time_ms = GetTime() + duration_ms;
	set_vehicle_drivable_time(duration_ms, end_time_ms);
	return end_time_ms;
}

/*
	Name: set_vehicle_drivable_time
	Namespace: vehicle
	Checksum: 0x92F02B0B
	Offset: 0x9658
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function set_vehicle_drivable_time(duration_ms, end_time_ms)
{
	self SetVehicleDrivableDuration(duration_ms);
	self SetVehicleDrivableEndTime(end_time_ms);
}

/*
	Name: update_damage_as_occupant
	Namespace: vehicle
	Checksum: 0x76CB8433
	Offset: 0x96A8
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function update_damage_as_occupant(damage_taken, max_health)
{
	damage_taken_normalized = math::clamp(damage_taken / max_health, 0, 1);
	self SetVehicleDamageMeter(damage_taken_normalized);
}

/*
	Name: stop_monitor_damage_as_occupant
	Namespace: vehicle
	Checksum: 0x73BF85B8
	Offset: 0x9720
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function stop_monitor_damage_as_occupant()
{
	self notify("stop_monitor_damage_as_occupant");
}

/*
	Name: monitor_damage_as_occupant
	Namespace: vehicle
	Checksum: 0xA48FE1A1
	Offset: 0x9740
	Size: 0xDF
	Parameters: 1
	Flags: None
*/
function monitor_damage_as_occupant(player)
{
	player endon("disconnect");
	player notify("stop_monitor_damage_as_occupant");
	player endon("stop_monitor_damage_as_occupant");
	self endon("death");
	if(!isdefined(self.maxhealth))
	{
		self.maxhealth = self.healthdefault;
	}
	wait(0.1);
	player update_damage_as_occupant(self.maxhealth - self.health, self.maxhealth);
	while(1)
	{
		self waittill("damage");
		waittillframeend;
		player update_damage_as_occupant(self.maxhealth - self.health, self.maxhealth);
	}
}

/*
	Name: kill_vehicle
	Namespace: vehicle
	Checksum: 0x99A00F9
	Offset: 0x9828
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function kill_vehicle(attacker)
{
	damageOrigin = self.origin + (0, 0, 1);
	self finishVehicleRadiusDamage(attacker, attacker, 32000, 32000, 10, 0, "MOD_EXPLOSIVE", level.weaponNone, damageOrigin, 400, -1, (0, 0, 1), 0);
}

/*
	Name: player_is_driver
	Namespace: vehicle
	Checksum: 0x3B9C13CA
	Offset: 0x98A8
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function player_is_driver()
{
	if(!isalive(self))
	{
		return 0;
	}
	vehicle = self GetVehicleOccupied();
	if(isdefined(vehicle))
	{
		seat = vehicle GetOccupantSeat(self);
		if(isdefined(seat) && seat == 0)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: vehicle_spawner_tool
	Namespace: vehicle
	Checksum: 0x2B7D6323
	Offset: 0x9940
	Size: 0x7F5
	Parameters: 0
	Flags: None
*/
function vehicle_spawner_tool()
{
	/#
		allvehicles = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
		vehicletypes = [];
		foreach(veh in allvehicles)
		{
			vehicletypes[veh.vehicleType] = veh.model;
		}
		if(IsAssetLoaded("Dev Block strings are not supported", "Dev Block strings are not supported"))
		{
			veh = SpawnVehicle("Dev Block strings are not supported", VectorScale((0, 0, 1), 10000), (0, 0, 0), "Dev Block strings are not supported");
			vehicletypes[veh.vehicleType] = veh.model;
			veh delete();
		}
		if(IsAssetLoaded("Dev Block strings are not supported", "Dev Block strings are not supported"))
		{
			veh = SpawnVehicle("Dev Block strings are not supported", VectorScale((0, 0, 1), 10000), (0, 0, 0), "Dev Block strings are not supported");
			vehicletypes[veh.vehicleType] = veh.model;
			veh delete();
		}
		if(IsAssetLoaded("Dev Block strings are not supported", "Dev Block strings are not supported"))
		{
			veh = SpawnVehicle("Dev Block strings are not supported", VectorScale((0, 0, 1), 10000), (0, 0, 0), "Dev Block strings are not supported");
			vehicletypes[veh.vehicleType] = veh.model;
			veh delete();
		}
		if(IsAssetLoaded("Dev Block strings are not supported", "Dev Block strings are not supported"))
		{
			veh = SpawnVehicle("Dev Block strings are not supported", VectorScale((0, 0, 1), 10000), (0, 0, 0), "Dev Block strings are not supported");
			vehicletypes[veh.vehicleType] = veh.model;
			veh delete();
		}
		if(IsAssetLoaded("Dev Block strings are not supported", "Dev Block strings are not supported"))
		{
			veh = SpawnVehicle("Dev Block strings are not supported", VectorScale((0, 0, 1), 10000), (0, 0, 0), "Dev Block strings are not supported");
			vehicletypes[veh.vehicleType] = veh.model;
			veh delete();
		}
		types = getArrayKeys(vehicletypes);
		if(types.size == 0)
		{
			return;
		}
		type_index = 0;
		while(1)
		{
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				player = GetPlayers()[0];
				dynamic_spawn_hud = newClientHudElem(player);
				dynamic_spawn_hud.alignX = "Dev Block strings are not supported";
				dynamic_spawn_hud.x = 20;
				dynamic_spawn_hud.y = 395;
				dynamic_spawn_hud.fontscale = 2;
				dynamic_spawn_dummy_model = sys::spawn("Dev Block strings are not supported", (0, 0, 0));
				while(GetDvarInt("Dev Block strings are not supported") > 0)
				{
					origin = player.origin + AnglesToForward(player getPlayerAngles()) * 270;
					origin = origin + VectorScale((0, 0, 1), 40);
					if(player useButtonPressed())
					{
						dynamic_spawn_dummy_model Hide();
						vehicle = SpawnVehicle(types[type_index], origin, player.angles, "Dev Block strings are not supported");
						vehicle MakeVehicleUsable();
						if(GetDvarInt("Dev Block strings are not supported") == 1)
						{
							SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
							continue;
						}
						wait(0.3);
					}
					if(player buttonpressed("Dev Block strings are not supported"))
					{
						dynamic_spawn_dummy_model Hide();
						type_index++;
						if(type_index >= types.size)
						{
							type_index = 0;
						}
						wait(0.3);
					}
					if(player buttonpressed("Dev Block strings are not supported"))
					{
						dynamic_spawn_dummy_model Hide();
						type_index--;
						if(type_index < 0)
						{
							type_index = types.size - 1;
						}
						wait(0.3);
					}
					type = types[type_index];
					dynamic_spawn_hud setText("Dev Block strings are not supported" + type);
					dynamic_spawn_dummy_model SetModel(vehicletypes[type]);
					dynamic_spawn_dummy_model show();
					dynamic_spawn_dummy_model notsolid();
					dynamic_spawn_dummy_model.origin = origin;
					dynamic_spawn_dummy_model.angles = player.angles;
					wait(0.05);
				}
				dynamic_spawn_hud destroy();
				dynamic_spawn_dummy_model delete();
			}
			wait(2);
		}
	#/
}

/*
	Name: spline_debug
	Namespace: vehicle
	Checksum: 0x8C624A52
	Offset: 0xA140
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function spline_debug()
{
	/#
		level flag::init("Dev Block strings are not supported");
		level thread _spline_debug();
		while(1)
		{
			level flag::set_val("Dev Block strings are not supported", GetDvarInt("Dev Block strings are not supported"));
			wait(0.05);
		}
	#/
}

/*
	Name: _spline_debug
	Namespace: vehicle
	Checksum: 0xD818B99
	Offset: 0xA1C8
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function _spline_debug()
{
	/#
		while(1)
		{
			level flag::wait_till("Dev Block strings are not supported");
			foreach(nd in GetAllVehicleNodes())
			{
				nd show_node_debug_info();
			}
			wait(0.05);
		}
	#/
}

/*
	Name: show_node_debug_info
	Namespace: vehicle
	Checksum: 0x8C4F754B
	Offset: 0xA298
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function show_node_debug_info()
{
	/#
		self.n_debug_display_count = 0;
		if(is_unload_node())
		{
			print_debug_info("Dev Block strings are not supported" + self.script_unload + "Dev Block strings are not supported");
		}
		if(isdefined(self.script_notify))
		{
			print_debug_info("Dev Block strings are not supported" + self.script_notify + "Dev Block strings are not supported");
		}
		if(isdefined(self.script_delete) && self.script_delete)
		{
			print_debug_info("Dev Block strings are not supported");
		}
	#/
}

/*
	Name: print_debug_info
	Namespace: vehicle
	Checksum: 0xB2D3D624
	Offset: 0xA360
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function print_debug_info(str_info)
{
	/#
		self.n_debug_display_count++;
		print3d(self.origin - (0, 0, self.n_debug_display_count * 20), str_info, (0, 0, 1), 1, 1);
	#/
}

