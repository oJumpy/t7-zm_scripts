#using scripts\shared\array_shared;

#namespace statemachine;

/*
	Name: create
	Namespace: statemachine
	Checksum: 0x8804A1DF
	Offset: 0xB8
	Size: 0x13D
	Parameters: 3
	Flags: None
*/
function create(name, owner, change_notify)
{
	if(!isdefined(change_notify))
	{
		change_notify = "change_state";
	}
	state_machine = spawnstruct();
	state_machine.name = name;
	state_machine.states = [];
	state_machine.previous_state = undefined;
	state_machine.current_state = undefined;
	state_machine.next_state = undefined;
	state_machine.change_note = change_notify;
	if(isdefined(owner))
	{
		state_machine.owner = owner;
	}
	else
	{
		state_machine.owner = level;
	}
	if(!isdefined(state_machine.owner.state_machines))
	{
		state_machine.owner.state_machines = [];
	}
	state_machine.owner.state_machines[state_machine.name] = state_machine;
	return state_machine;
}

/*
	Name: clear
	Namespace: statemachine
	Checksum: 0x8D8DDB9E
	Offset: 0x200
	Size: 0xED
	Parameters: 0
	Flags: None
*/
function clear()
{
	if(isdefined(self.states) && IsArray(self.states))
	{
		foreach(State in self.states)
		{
			State.connections_notify = undefined;
			State.connections_utility = undefined;
		}
	}
	self.states = undefined;
	self.previous_state = undefined;
	self.current_state = undefined;
	self.next_state = undefined;
	self.owner = undefined;
	self notify("_cancel_connections");
}

/*
	Name: add_state
	Namespace: statemachine
	Checksum: 0x2FE729DF
	Offset: 0x2F8
	Size: 0x14F
	Parameters: 5
	Flags: None
*/
function add_state(name, enter_func, update_func, exit_func, reenter_func)
{
	if(!isdefined(self.states[name]))
	{
		self.states[name] = spawnstruct();
	}
	self.states[name].name = name;
	self.states[name].enter_func = enter_func;
	self.states[name].exit_func = exit_func;
	self.states[name].update_func = update_func;
	self.states[name].reenter_func = reenter_func;
	self.states[name].connections_notify = [];
	self.states[name].connections_utility = [];
	self.states[name].owner = self;
	return self.states[name];
}

/*
	Name: get_state
	Namespace: statemachine
	Checksum: 0x66265ABA
	Offset: 0x450
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function get_state(name)
{
	return self.states[name];
}

/*
	Name: add_interrupt_connection
	Namespace: statemachine
	Checksum: 0x2E38B809
	Offset: 0x470
	Size: 0x10F
	Parameters: 4
	Flags: None
*/
function add_interrupt_connection(from_state_name, to_state_name, on_notify, checkfunc)
{
	from_state = get_state(from_state_name);
	to_state = get_state(to_state_name);
	connection = spawnstruct();
	connection.to_state = to_state;
	connection.type = 0;
	connection.on_notify = on_notify;
	connection.checkfunc = checkfunc;
	from_state.connections_notify[on_notify] = connection;
	return from_state.connections_notify[from_state.connections_notify.size - 1];
}

/*
	Name: add_utility_connection
	Namespace: statemachine
	Checksum: 0x6AD26937
	Offset: 0x588
	Size: 0x1B7
	Parameters: 4
	Flags: None
*/
function add_utility_connection(from_state_name, to_state_name, checkfunc, defaultScore)
{
	from_state = get_state(from_state_name);
	to_state = get_state(to_state_name);
	connection = spawnstruct();
	connection.to_state = to_state;
	connection.type = 1;
	connection.checkfunc = checkfunc;
	connection.score = defaultScore;
	if(!isdefined(connection.score))
	{
		connection.score = 100;
	}
	if(!isdefined(from_state.connections_utility))
	{
		from_state.connections_utility = [];
	}
	else if(!IsArray(from_state.connections_utility))
	{
		from_state.connections_utility = Array(from_state.connections_utility);
	}
	from_state.connections_utility[from_state.connections_utility.size] = connection;
	return from_state.connections_utility[from_state.connections_utility.size - 1];
}

/*
	Name: set_state
	Namespace: statemachine
	Checksum: 0x3EAD35A3
	Offset: 0x748
	Size: 0x287
	Parameters: 2
	Flags: None
*/
function set_state(name, state_params)
{
	State = self.states[name];
	if(!isdefined(self.owner))
	{
		return 0;
	}
	if(!isdefined(State))
	{
		/#
			ASSERTMSG("Dev Block strings are not supported" + name + "Dev Block strings are not supported" + self.name);
		#/
		return 0;
	}
	reenter = self.current_state === State;
	if(isdefined(State.reenter_func) && reenter)
	{
		shouldReenter = self.owner [[State.reenter_func]](State.state_params);
	}
	if(reenter && shouldReenter !== 1)
	{
		return 0;
	}
	if(isdefined(self.current_state))
	{
		self.next_state = State;
		if(isdefined(self.current_state.exit_func))
		{
			self.owner [[self.current_state.exit_func]](self.current_state.state_params);
		}
		if(!reenter)
		{
			self.previous_state = self.current_state;
		}
		self.current_state.state_params = undefined;
	}
	if(!isdefined(state_params))
	{
		state_params = spawnstruct();
	}
	State.state_params = state_params;
	self.owner notify(self.change_note);
	self.current_state = State;
	self threadNotifyConnections(self.current_state);
	if(isdefined(self.current_state.enter_func))
	{
		self.owner [[self.current_state.enter_func]](self.current_state.state_params);
	}
	if(isdefined(self.current_state.update_func))
	{
		self.owner thread [[self.current_state.update_func]](self.current_state.state_params);
	}
	return 1;
}

/*
	Name: threadNotifyConnections
	Namespace: statemachine
	Checksum: 0x96F8689D
	Offset: 0x9D8
	Size: 0xE1
	Parameters: 1
	Flags: None
*/
function threadNotifyConnections(State)
{
	self notify("_cancel_connections");
	foreach(connection in State.connections_notify)
	{
		/#
			Assert(connection.type == 0);
		#/
		self.owner thread connection_on_notify(self, connection.on_notify, connection);
	}
}

/*
	Name: connection_on_notify
	Namespace: statemachine
	Checksum: 0xB0171B66
	Offset: 0xAC8
	Size: 0xB5F
	Parameters: 3
	Flags: None
*/
function connection_on_notify(state_machine, notify_name, connection)
{
	self endon(state_machine.change_note);
	state_machine endon("_cancel_connections");
	while(1)
	{
		self waittill(notify_name, param0, param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13, param14, param15);
		params = spawnstruct();
		params.notify_param = [];
		if(!isdefined(params.notify_param))
		{
			params.notify_param = [];
		}
		else if(!IsArray(params.notify_param))
		{
			params.notify_param = Array(params.notify_param);
		}
		params.notify_param[params.notify_param.size] = param0;
		if(!isdefined(params.notify_param))
		{
			params.notify_param = [];
		}
		else if(!IsArray(params.notify_param))
		{
			params.notify_param = Array(params.notify_param);
		}
		params.notify_param[params.notify_param.size] = param1;
		if(!isdefined(params.notify_param))
		{
			params.notify_param = [];
		}
		else if(!IsArray(params.notify_param))
		{
			params.notify_param = Array(params.notify_param);
		}
		params.notify_param[params.notify_param.size] = param2;
		if(!isdefined(params.notify_param))
		{
			params.notify_param = [];
		}
		else if(!IsArray(params.notify_param))
		{
			params.notify_param = Array(params.notify_param);
		}
		params.notify_param[params.notify_param.size] = param3;
		if(!isdefined(params.notify_param))
		{
			params.notify_param = [];
		}
		else if(!IsArray(params.notify_param))
		{
			params.notify_param = Array(params.notify_param);
		}
		params.notify_param[params.notify_param.size] = param4;
		if(!isdefined(params.notify_param))
		{
			params.notify_param = [];
		}
		else if(!IsArray(params.notify_param))
		{
			params.notify_param = Array(params.notify_param);
		}
		params.notify_param[params.notify_param.size] = param5;
		if(!isdefined(params.notify_param))
		{
			params.notify_param = [];
		}
		else if(!IsArray(params.notify_param))
		{
			params.notify_param = Array(params.notify_param);
		}
		params.notify_param[params.notify_param.size] = param6;
		if(!isdefined(params.notify_param))
		{
			params.notify_param = [];
		}
		else if(!IsArray(params.notify_param))
		{
			params.notify_param = Array(params.notify_param);
		}
		params.notify_param[params.notify_param.size] = param7;
		if(!isdefined(params.notify_param))
		{
			params.notify_param = [];
		}
		else if(!IsArray(params.notify_param))
		{
			params.notify_param = Array(params.notify_param);
		}
		params.notify_param[params.notify_param.size] = param8;
		if(!isdefined(params.notify_param))
		{
			params.notify_param = [];
		}
		else if(!IsArray(params.notify_param))
		{
			params.notify_param = Array(params.notify_param);
		}
		params.notify_param[params.notify_param.size] = param9;
		if(!isdefined(params.notify_param))
		{
			params.notify_param = [];
		}
		else if(!IsArray(params.notify_param))
		{
			params.notify_param = Array(params.notify_param);
		}
		params.notify_param[params.notify_param.size] = param10;
		if(!isdefined(params.notify_param))
		{
			params.notify_param = [];
		}
		else if(!IsArray(params.notify_param))
		{
			params.notify_param = Array(params.notify_param);
		}
		params.notify_param[params.notify_param.size] = param11;
		if(!isdefined(params.notify_param))
		{
			params.notify_param = [];
		}
		else if(!IsArray(params.notify_param))
		{
			params.notify_param = Array(params.notify_param);
		}
		params.notify_param[params.notify_param.size] = param12;
		if(!isdefined(params.notify_param))
		{
			params.notify_param = [];
		}
		else if(!IsArray(params.notify_param))
		{
			params.notify_param = Array(params.notify_param);
		}
		params.notify_param[params.notify_param.size] = param13;
		if(!isdefined(params.notify_param))
		{
			params.notify_param = [];
		}
		else if(!IsArray(params.notify_param))
		{
			params.notify_param = Array(params.notify_param);
		}
		params.notify_param[params.notify_param.size] = param14;
		if(!isdefined(params.notify_param))
		{
			params.notify_param = [];
		}
		else if(!IsArray(params.notify_param))
		{
			params.notify_param = Array(params.notify_param);
		}
		params.notify_param[params.notify_param.size] = param15;
		connectionValid = 1;
		if(isdefined(connection.checkfunc))
		{
			connectionValid = self [[connection.checkfunc]](self.current_state, connection.to_state.name, connection, params);
		}
		if(connectionValid)
		{
			state_machine thread set_state(connection.to_state.name, params);
		}
	}
}

/*
	Name: evaluate_connections
	Namespace: statemachine
	Checksum: 0xEA2ECBC7
	Offset: 0x1630
	Size: 0x2EB
	Parameters: 2
	Flags: None
*/
function evaluate_connections(eval_func, params)
{
	/#
		Assert(isdefined(self.current_state));
	#/
	connectionArray = [];
	scoreArray = [];
	best_connection = undefined;
	best_score = -1;
	foreach(connection in self.current_state.connections_utility)
	{
		/#
			Assert(connection.type == 1);
		#/
		score = connection.score;
		if(isdefined(connection.checkfunc))
		{
			score = self.owner [[connection.checkfunc]](self.current_state.name, connection.to_state.name, connection);
		}
		if(score > 0)
		{
			if(!isdefined(connectionArray))
			{
				connectionArray = [];
			}
			else if(!IsArray(connectionArray))
			{
				connectionArray = Array(connectionArray);
			}
			connectionArray[connectionArray.size] = connection;
			if(!isdefined(scoreArray))
			{
				scoreArray = [];
			}
			else if(!IsArray(scoreArray))
			{
				scoreArray = Array(scoreArray);
			}
			scoreArray[scoreArray.size] = score;
			if(score > best_score)
			{
				best_connection = connection;
				best_score = score;
			}
		}
	}
	if(isdefined(eval_func) && connectionArray.size > 0)
	{
		best_connection = self.owner [[eval_func]](connectionArray, scoreArray, self.current_state);
	}
	if(isdefined(best_connection))
	{
		self thread set_state(best_connection.to_state.name, params);
	}
}

/*
	Name: debugOn
	Namespace: statemachine
	Checksum: 0xA0A5BE3
	Offset: 0x1928
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function debugOn()
{
	dvarVal = GetDvarInt("statemachine_debug");
	return dvarVal;
}

