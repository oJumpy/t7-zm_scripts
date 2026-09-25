#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace visionset_mgr;

/*
	Name: __init__sytem__
	Namespace: visionset_mgr
	Checksum: 0xBED0694B
	Offset: 0x168
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("visionset_mgr", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: visionset_mgr
	Checksum: 0x40B639D7
	Offset: 0x1A8
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.vsmgr_initializing = 1;
	level.vsmgr_default_info_name = "__none";
	level.vsmgr = [];
	level thread register_type("visionset");
	level thread register_type("overlay");
	callback::on_finalize_initialization(&finalize_clientfields);
	level thread monitor();
	callback::on_connect(&on_player_connect);
}

/*
	Name: register_info
	Namespace: visionset_mgr
	Checksum: 0xB386F735
	Offset: 0x278
	Size: 0x19F
	Parameters: 8
	Flags: None
*/
function register_info(type, name, version, priority, lerp_step_count, should_activate_per_player, lerp_thread, ref_count_lerp_thread)
{
	/#
		Assert(level.vsmgr_initializing, "Dev Block strings are not supported");
	#/
	lower_name = ToLower(name);
	validate_info(type, lower_name, priority);
	add_sorted_name_key(type, lower_name);
	add_sorted_priority_key(type, lower_name, priority);
	level.vsmgr[type].info[lower_name] = spawnstruct();
	level.vsmgr[type].info[lower_name] add_info(type, lower_name, version, priority, lerp_step_count, should_activate_per_player, lerp_thread, ref_count_lerp_thread);
	if(level.vsmgr[type].highest_version < version)
	{
		level.vsmgr[type].highest_version = version;
	}
}

/*
	Name: activate
	Namespace: visionset_mgr
	Checksum: 0xC7B18D4D
	Offset: 0x420
	Size: 0x1B5
	Parameters: 6
	Flags: None
*/
function activate(type, name, player, opt_param_1, opt_param_2, opt_param_3)
{
	if(level.vsmgr[type].info[name].State.should_activate_per_player)
	{
		activate_per_player(type, name, player, opt_param_1, opt_param_2, opt_param_3);
		return;
	}
	State = level.vsmgr[type].info[name].State;
	if(State.ref_count_lerp_thread)
	{
		State.ref_count++;
		if(1 < State.ref_count)
		{
			return;
		}
	}
	if(isdefined(State.lerp_thread))
	{
		State thread lerp_thread_wrapper(State.lerp_thread, opt_param_1, opt_param_2, opt_param_3);
		break;
	}
	players = GetPlayers();
	for(player_index = 0; player_index < players.size; player_index++)
	{
		State set_state_active(players[player_index], 1);
	}
}

/*
	Name: deactivate
	Namespace: visionset_mgr
	Checksum: 0x2D9F0833
	Offset: 0x5E0
	Size: 0x153
	Parameters: 3
	Flags: None
*/
function deactivate(type, name, player)
{
	if(level.vsmgr[type].info[name].State.should_activate_per_player)
	{
		deactivate_per_player(type, name, player);
		return;
	}
	State = level.vsmgr[type].info[name].State;
	if(State.ref_count_lerp_thread)
	{
		State.ref_count--;
		if(0 < State.ref_count)
		{
			return;
		}
	}
	players = GetPlayers();
	for(player_index = 0; player_index < players.size; player_index++)
	{
		State set_state_inactive(players[player_index]);
	}
	State notify("visionset_mgr_deactivate_all");
}

/*
	Name: set_state_active
	Namespace: visionset_mgr
	Checksum: 0x7132E830
	Offset: 0x740
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function set_state_active(player, lerp)
{
	player_entnum = player GetEntityNumber();
	if(!isdefined(self.players[player_entnum]))
	{
		return;
	}
	self.players[player_entnum].active = 1;
	self.players[player_entnum].lerp = lerp;
}

/*
	Name: set_state_inactive
	Namespace: visionset_mgr
	Checksum: 0x76605478
	Offset: 0x7D0
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function set_state_inactive(player)
{
	player_entnum = player GetEntityNumber();
	if(!isdefined(self.players[player_entnum]))
	{
		return;
	}
	self.players[player_entnum].active = 0;
	self.players[player_entnum].lerp = 0;
}

/*
	Name: timeout_lerp_thread
	Namespace: visionset_mgr
	Checksum: 0xAFCD50F2
	Offset: 0x858
	Size: 0xAB
	Parameters: 3
	Flags: None
*/
function timeout_lerp_thread(timeout, opt_param_2, opt_param_3)
{
	players = GetPlayers();
	for(player_index = 0; player_index < players.size; player_index++)
	{
		self set_state_active(players[player_index], 1);
	}
	wait(timeout);
	deactivate(self.type, self.name);
}

/*
	Name: timeout_lerp_thread_per_player
	Namespace: visionset_mgr
	Checksum: 0x1B592607
	Offset: 0x910
	Size: 0x6B
	Parameters: 4
	Flags: None
*/
function timeout_lerp_thread_per_player(player, timeout, opt_param_2, opt_param_3)
{
	self set_state_active(player, 1);
	wait(timeout);
	deactivate_per_player(self.type, self.name, player);
}

/*
	Name: duration_lerp_thread
	Namespace: visionset_mgr
	Checksum: 0x1FF9EBE1
	Offset: 0x988
	Size: 0x15B
	Parameters: 2
	Flags: None
*/
function duration_lerp_thread(duration, max_duration)
{
	start_time = GetTime();
	end_time = start_time + Int(duration * 1000);
	if(isdefined(max_duration))
	{
		start_time = end_time - Int(max_duration * 1000);
	}
	while(1)
	{
		lerp = calc_remaining_duration_lerp(start_time, end_time);
		if(0 >= lerp)
		{
			break;
		}
		players = GetPlayers();
		for(player_index = 0; player_index < players.size; player_index++)
		{
			self set_state_active(players[player_index], lerp);
		}
		wait(0.05);
	}
	deactivate(self.type, self.name);
}

/*
	Name: duration_lerp_thread_per_player
	Namespace: visionset_mgr
	Checksum: 0x3CA9309
	Offset: 0xAF0
	Size: 0x113
	Parameters: 3
	Flags: None
*/
function duration_lerp_thread_per_player(player, duration, max_duration)
{
	start_time = GetTime();
	end_time = start_time + Int(duration * 1000);
	if(isdefined(max_duration))
	{
		start_time = end_time - Int(max_duration * 1000);
	}
	while(1)
	{
		lerp = calc_remaining_duration_lerp(start_time, end_time);
		if(0 >= lerp)
		{
			break;
		}
		self set_state_active(player, lerp);
		wait(0.05);
	}
	deactivate_per_player(self.type, self.name, player);
}

/*
	Name: ramp_in_thread_per_player
	Namespace: visionset_mgr
	Checksum: 0xE15D0BF8
	Offset: 0xC10
	Size: 0xB7
	Parameters: 2
	Flags: None
*/
function ramp_in_thread_per_player(player, duration)
{
	start_time = GetTime();
	end_time = start_time + Int(duration * 1000);
	while(1)
	{
		lerp = calc_ramp_in_lerp(start_time, end_time);
		if(1 <= lerp)
		{
			break;
		}
		self set_state_active(player, lerp);
		wait(0.05);
	}
}

/*
	Name: ramp_in_out_thread_hold_func
	Namespace: visionset_mgr
	Checksum: 0xA06518B5
	Offset: 0xCD0
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function ramp_in_out_thread_hold_func()
{
	level endon("kill_ramp_in_out_thread_hold_func");
	while(1)
	{
		for(player_index = 0; player_index < level.players.size; player_index++)
		{
			self set_state_active(level.players[player_index], 1);
		}
		wait(0.05);
	}
}

/*
	Name: ramp_in_out_thread
	Namespace: visionset_mgr
	Checksum: 0xE2498E5B
	Offset: 0xD50
	Size: 0x25B
	Parameters: 3
	Flags: None
*/
function ramp_in_out_thread(ramp_in, full_period, ramp_out)
{
	start_time = GetTime();
	end_time = start_time + Int(ramp_in * 1000);
	while(1)
	{
		lerp = calc_ramp_in_lerp(start_time, end_time);
		if(1 <= lerp)
		{
			break;
		}
		players = GetPlayers();
		for(player_index = 0; player_index < players.size; player_index++)
		{
			self set_state_active(players[player_index], lerp);
		}
		wait(0.05);
	}
	self thread ramp_in_out_thread_hold_func();
	if(IsFunctionPtr(full_period))
	{
		self [[full_period]]();
	}
	else
	{
		wait(full_period);
	}
	level notify("kill_ramp_in_out_thread_hold_func");
	start_time = GetTime();
	end_time = start_time + Int(ramp_out * 1000);
	while(1)
	{
		lerp = calc_remaining_duration_lerp(start_time, end_time);
		if(0 >= lerp)
		{
			break;
		}
		players = GetPlayers();
		for(player_index = 0; player_index < players.size; player_index++)
		{
			self set_state_active(players[player_index], lerp);
		}
		wait(0.05);
	}
	deactivate(self.type, self.name);
}

/*
	Name: ramp_in_out_thread_per_player_internal
	Namespace: visionset_mgr
	Checksum: 0x60C27F21
	Offset: 0xFB8
	Size: 0x1CB
	Parameters: 4
	Flags: None
*/
function ramp_in_out_thread_per_player_internal(player, ramp_in, full_period, ramp_out)
{
	start_time = GetTime();
	end_time = start_time + Int(ramp_in * 1000);
	while(1)
	{
		lerp = calc_ramp_in_lerp(start_time, end_time);
		if(1 <= lerp)
		{
			break;
		}
		self set_state_active(player, lerp);
		wait(0.05);
	}
	self set_state_active(player, lerp);
	if(IsFunctionPtr(full_period))
	{
		player [[full_period]]();
	}
	else
	{
		wait(full_period);
	}
	start_time = GetTime();
	end_time = start_time + Int(ramp_out * 1000);
	while(1)
	{
		lerp = calc_remaining_duration_lerp(start_time, end_time);
		if(0 >= lerp)
		{
			break;
		}
		self set_state_active(player, lerp);
		wait(0.05);
	}
	deactivate_per_player(self.type, self.name, player);
}

/*
	Name: ramp_in_out_thread_watch_player_shutdown
	Namespace: visionset_mgr
	Checksum: 0xF6FB0F08
	Offset: 0x1190
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function ramp_in_out_thread_watch_player_shutdown(player)
{
	player notify("ramp_in_out_thread_watch_player_shutdown");
	player endon("ramp_in_out_thread_watch_player_shutdown");
	player endon("disconnect");
	player waittill("death");
	if(player IsRemoteControlling() == 0)
	{
		deactivate_per_player(self.type, self.name, player);
	}
}

/*
	Name: ramp_in_out_thread_per_player_death_shutdown
	Namespace: visionset_mgr
	Checksum: 0xB724FC63
	Offset: 0x1220
	Size: 0x63
	Parameters: 4
	Flags: None
*/
function ramp_in_out_thread_per_player_death_shutdown(player, ramp_in, full_period, ramp_out)
{
	player endon("death");
	thread ramp_in_out_thread_watch_player_shutdown(player);
	ramp_in_out_thread_per_player_internal(player, ramp_in, full_period, ramp_out);
}

/*
	Name: ramp_in_out_thread_per_player
	Namespace: visionset_mgr
	Checksum: 0x4650215C
	Offset: 0x1290
	Size: 0x43
	Parameters: 4
	Flags: None
*/
function ramp_in_out_thread_per_player(player, ramp_in, full_period, ramp_out)
{
	ramp_in_out_thread_per_player_internal(player, ramp_in, full_period, ramp_out);
}

/*
	Name: register_type
	Namespace: visionset_mgr
	Checksum: 0x6173706A
	Offset: 0x12E0
	Size: 0x143
	Parameters: 1
	Flags: None
*/
function register_type(type)
{
	level.vsmgr[type] = spawnstruct();
	level.vsmgr[type].type = type;
	level.vsmgr[type].in_use = 0;
	level.vsmgr[type].highest_version = 0;
	level.vsmgr[type].cf_slot_name = type + "_slot";
	level.vsmgr[type].cf_lerp_name = type + "_lerp";
	level.vsmgr[type].info = [];
	level.vsmgr[type].sorted_name_keys = [];
	level.vsmgr[type].sorted_prio_keys = [];
	register_info(type, level.vsmgr_default_info_name, 1, 0, 1, 0, undefined);
}

/*
	Name: finalize_clientfields
	Namespace: visionset_mgr
	Checksum: 0xD8EEAEDE
	Offset: 0x1430
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function finalize_clientfields()
{
	typeKeys = getArrayKeys(level.vsmgr);
	for(type_index = 0; type_index < typeKeys.size; type_index++)
	{
		level.vsmgr[typeKeys[type_index]] thread finalize_type_clientfields();
	}
	level.vsmgr_initializing = 0;
}

/*
	Name: finalize_type_clientfields
	Namespace: visionset_mgr
	Checksum: 0x1A29AD9
	Offset: 0x14B8
	Size: 0x263
	Parameters: 0
	Flags: None
*/
function finalize_type_clientfields()
{
	/#
		println("Dev Block strings are not supported" + self.type + "Dev Block strings are not supported");
	#/
	if(1 >= self.info.size)
	{
		return;
	}
	self.in_use = 1;
	self.cf_slot_bit_count = GetMinBitCountForNum(self.info.size - 1);
	self.cf_lerp_bit_count = self.info[self.sorted_name_keys[0]].lerp_bit_count;
	for(i = 0; i < self.sorted_name_keys.size; i++)
	{
		self.info[self.sorted_name_keys[i]].slot_index = i;
		if(self.info[self.sorted_name_keys[i]].lerp_bit_count > self.cf_lerp_bit_count)
		{
			self.cf_lerp_bit_count = self.info[self.sorted_name_keys[i]].lerp_bit_count;
		}
		/#
			println("Dev Block strings are not supported" + self.info[self.sorted_name_keys[i]].name + "Dev Block strings are not supported" + self.info[self.sorted_name_keys[i]].version + "Dev Block strings are not supported" + self.info[self.sorted_name_keys[i]].lerp_step_count + "Dev Block strings are not supported");
		#/
	}
	clientfield::register("toplayer", self.cf_slot_name, self.highest_version, self.cf_slot_bit_count, "int");
	if(1 < self.cf_lerp_bit_count)
	{
		clientfield::register("toplayer", self.cf_lerp_name, self.highest_version, self.cf_lerp_bit_count, "float");
	}
}

/*
	Name: validate_info
	Namespace: visionset_mgr
	Checksum: 0xEDE77E82
	Offset: 0x1728
	Size: 0x235
	Parameters: 3
	Flags: None
*/
function validate_info(type, name, priority)
{
	keys = getArrayKeys(level.vsmgr);
	for(i = 0; i < keys.size; i++)
	{
		if(type == keys[i])
		{
			break;
		}
	}
	/#
		Assert(i < keys.size, "Dev Block strings are not supported" + type + "Dev Block strings are not supported");
	#/
	keys = getArrayKeys(level.vsmgr[type].info);
	for(i = 0; i < keys.size; i++)
	{
		/#
			Assert(level.vsmgr[type].info[keys[i]].name != name, "Dev Block strings are not supported" + type + "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
		#/
		/#
			Assert(level.vsmgr[type].info[keys[i]].priority != priority, "Dev Block strings are not supported" + type + "Dev Block strings are not supported" + priority + "Dev Block strings are not supported" + name + "Dev Block strings are not supported" + level.vsmgr[type].info[keys[i]].name + "Dev Block strings are not supported");
		#/
	}
}

/*
	Name: add_sorted_name_key
	Namespace: visionset_mgr
	Checksum: 0xDF1C93A2
	Offset: 0x1968
	Size: 0xAB
	Parameters: 2
	Flags: None
*/
function add_sorted_name_key(type, name)
{
	for(i = 0; i < level.vsmgr[type].sorted_name_keys.size; i++)
	{
		if(name < level.vsmgr[type].sorted_name_keys[i])
		{
			break;
		}
	}
	ArrayInsert(level.vsmgr[type].sorted_name_keys, name, i);
}

/*
	Name: add_sorted_priority_key
	Namespace: visionset_mgr
	Checksum: 0xB739C799
	Offset: 0x1A20
	Size: 0xD3
	Parameters: 3
	Flags: None
*/
function add_sorted_priority_key(type, name, priority)
{
	for(i = 0; i < level.vsmgr[type].sorted_prio_keys.size; i++)
	{
		if(priority > level.vsmgr[type].info[level.vsmgr[type].sorted_prio_keys[i]].priority)
		{
			break;
		}
	}
	ArrayInsert(level.vsmgr[type].sorted_prio_keys, name, i);
}

/*
	Name: add_info
	Namespace: visionset_mgr
	Checksum: 0xB6FCBD36
	Offset: 0x1B00
	Size: 0x167
	Parameters: 8
	Flags: None
*/
function add_info(type, name, version, priority, lerp_step_count, should_activate_per_player, lerp_thread, ref_count_lerp_thread)
{
	self.type = type;
	self.name = name;
	self.version = version;
	self.priority = priority;
	self.lerp_step_count = lerp_step_count;
	self.lerp_bit_count = GetMinBitCountForNum(lerp_step_count);
	if(!isdefined(ref_count_lerp_thread))
	{
		ref_count_lerp_thread = 0;
	}
	self.State = spawnstruct();
	self.State.type = type;
	self.State.name = name;
	self.State.should_activate_per_player = should_activate_per_player;
	self.State.lerp_thread = lerp_thread;
	self.State.ref_count_lerp_thread = ref_count_lerp_thread;
	self.State.players = [];
	if(ref_count_lerp_thread && !should_activate_per_player)
	{
		self.State.ref_count = 0;
	}
}

/*
	Name: on_player_connect
	Namespace: visionset_mgr
	Checksum: 0x6E7B4DC
	Offset: 0x1C70
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self player_setup();
}

/*
	Name: player_setup
	Namespace: visionset_mgr
	Checksum: 0xE2D1F463
	Offset: 0x1C98
	Size: 0x2DD
	Parameters: 0
	Flags: None
*/
function player_setup()
{
	self.vsmgr_player_entnum = self GetEntityNumber();
	typeKeys = getArrayKeys(level.vsmgr);
	for(type_index = 0; type_index < typeKeys.size; type_index++)
	{
		type = typeKeys[type_index];
		if(!level.vsmgr[type].in_use)
		{
			continue;
		}
		for(name_index = 0; name_index < level.vsmgr[type].sorted_name_keys.size; name_index++)
		{
			name_key = level.vsmgr[type].sorted_name_keys[name_index];
			level.vsmgr[type].info[name_key].State.players[self.vsmgr_player_entnum] = spawnstruct();
			level.vsmgr[type].info[name_key].State.players[self.vsmgr_player_entnum].active = 0;
			level.vsmgr[type].info[name_key].State.players[self.vsmgr_player_entnum].lerp = 0;
			if(level.vsmgr[type].info[name_key].State.ref_count_lerp_thread && level.vsmgr[type].info[name_key].State.should_activate_per_player)
			{
				level.vsmgr[type].info[name_key].State.players[self.vsmgr_player_entnum].ref_count = 0;
			}
		}
		level.vsmgr[type].info[level.vsmgr_default_info_name].State set_state_active(self, 1);
	}
}

/*
	Name: player_shutdown
	Namespace: visionset_mgr
	Checksum: 0x111D8A7A
	Offset: 0x1F80
	Size: 0x12F
	Parameters: 0
	Flags: None
*/
function player_shutdown()
{
	self.vsmgr_player_entnum = self GetEntityNumber();
	typeKeys = getArrayKeys(level.vsmgr);
	for(type_index = 0; type_index < typeKeys.size; type_index++)
	{
		type = typeKeys[type_index];
		if(!level.vsmgr[type].in_use)
		{
			break;
		}
		for(name_index = 0; name_index < level.vsmgr[type].sorted_name_keys.size; name_index++)
		{
			name_key = level.vsmgr[type].sorted_name_keys[name_index];
			deactivate_per_player(type, name_key, self);
		}
	}
}

/*
	Name: monitor
	Namespace: visionset_mgr
	Checksum: 0x5760D870
	Offset: 0x20B8
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function monitor()
{
	while(level.vsmgr_initializing)
	{
		wait(0.05);
	}
	typeKeys = getArrayKeys(level.vsmgr);
	while(1)
	{
		wait(0.05);
		waittillframeend;
		players = GetPlayers();
		for(type_index = 0; type_index < typeKeys.size; type_index++)
		{
			type = typeKeys[type_index];
			if(!level.vsmgr[type].in_use)
			{
				break;
			}
			for(player_index = 0; player_index < players.size; player_index++)
			{
				if(!isdefined(players[player_index].vsmgr_player_entnum))
				{
					continue;
				}
				update_clientfields(players[player_index], level.vsmgr[type]);
			}
		}
	}
}

/*
	Name: get_first_active_name
	Namespace: visionset_mgr
	Checksum: 0xF62AB4
	Offset: 0x2208
	Size: 0xBD
	Parameters: 1
	Flags: None
*/
function get_first_active_name(type_struct)
{
	SIZE = type_struct.sorted_prio_keys.size;
	for(prio_index = 0; prio_index < SIZE; prio_index++)
	{
		prio_key = type_struct.sorted_prio_keys[prio_index];
		if(type_struct.info[prio_key].State.players[self.vsmgr_player_entnum].active)
		{
			return prio_key;
		}
	}
	return level.vsmgr_default_info_name;
}

/*
	Name: update_clientfields
	Namespace: visionset_mgr
	Checksum: 0x75F1F7E0
	Offset: 0x22D0
	Size: 0xEB
	Parameters: 2
	Flags: None
*/
function update_clientfields(player, type_struct)
{
	name = player get_first_active_name(type_struct);
	player clientfield::set_to_player(type_struct.cf_slot_name, type_struct.info[name].slot_index);
	if(1 < type_struct.cf_lerp_bit_count)
	{
		player clientfield::set_to_player(type_struct.cf_lerp_name, type_struct.info[name].State.players[player.vsmgr_player_entnum].lerp);
	}
}

/*
	Name: lerp_thread_wrapper
	Namespace: visionset_mgr
	Checksum: 0x9DD102C3
	Offset: 0x23C8
	Size: 0x57
	Parameters: 4
	Flags: None
*/
function lerp_thread_wrapper(func, opt_param_1, opt_param_2, opt_param_3)
{
	self notify("visionset_mgr_deactivate_all");
	self endon("visionset_mgr_deactivate_all");
	self [[func]](opt_param_1, opt_param_2, opt_param_3);
}

/*
	Name: lerp_thread_per_player_wrapper
	Namespace: visionset_mgr
	Checksum: 0x3141507F
	Offset: 0x2428
	Size: 0xAD
	Parameters: 5
	Flags: None
*/
function lerp_thread_per_player_wrapper(func, player, opt_param_1, opt_param_2, opt_param_3)
{
	player_entnum = player GetEntityNumber();
	self.players[player_entnum] notify("visionset_mgr_deactivate");
	self.players[player_entnum] endon("visionset_mgr_deactivate");
	player endon("disconnect");
	self [[func]](player, opt_param_1, opt_param_2, opt_param_3);
}

/*
	Name: activate_per_player
	Namespace: visionset_mgr
	Checksum: 0xAE9E8393
	Offset: 0x24E0
	Size: 0x14B
	Parameters: 6
	Flags: None
*/
function activate_per_player(type, name, player, opt_param_1, opt_param_2, opt_param_3)
{
	player_entnum = player GetEntityNumber();
	State = level.vsmgr[type].info[name].State;
	if(State.ref_count_lerp_thread)
	{
		State.players[player_entnum].ref_count++;
		if(1 < State.players[player_entnum].ref_count)
		{
			return;
		}
	}
	if(isdefined(State.lerp_thread))
	{
		State thread lerp_thread_per_player_wrapper(State.lerp_thread, player, opt_param_1, opt_param_2, opt_param_3);
	}
	else
	{
		State set_state_active(player, 1);
	}
}

/*
	Name: deactivate_per_player
	Namespace: visionset_mgr
	Checksum: 0x70443DE6
	Offset: 0x2638
	Size: 0x101
	Parameters: 3
	Flags: None
*/
function deactivate_per_player(type, name, player)
{
	player_entnum = player GetEntityNumber();
	State = level.vsmgr[type].info[name].State;
	if(State.ref_count_lerp_thread)
	{
		State.players[player_entnum].ref_count--;
		if(0 < State.players[player_entnum].ref_count)
		{
			return;
		}
	}
	State set_state_inactive(player);
	State.players[player_entnum] notify("visionset_mgr_deactivate");
}

/*
	Name: calc_ramp_in_lerp
	Namespace: visionset_mgr
	Checksum: 0xCB14DEF2
	Offset: 0x2748
	Size: 0x99
	Parameters: 2
	Flags: None
*/
function calc_ramp_in_lerp(start_time, end_time)
{
	if(0 >= end_time - start_time)
	{
		return 1;
	}
	now = GetTime();
	frac = float(now - start_time) / float(end_time - start_time);
	return math::clamp(frac, 0, 1);
}

/*
	Name: calc_remaining_duration_lerp
	Namespace: visionset_mgr
	Checksum: 0x6E807159
	Offset: 0x27F0
	Size: 0x91
	Parameters: 2
	Flags: None
*/
function calc_remaining_duration_lerp(start_time, end_time)
{
	if(0 >= end_time - start_time)
	{
		return 0;
	}
	now = GetTime();
	frac = float(end_time - now) / float(end_time - start_time);
	return math::clamp(frac, 0, 1);
}

