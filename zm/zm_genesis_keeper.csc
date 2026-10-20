#using scripts\codescripts\struct;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_genesis_keeper;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_keeper
	Checksum: 0x3462193B
	Offset: 0x228
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_keeper", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_keeper
	Checksum: 0x8CD9D433
	Offset: 0x268
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	ai::add_archetype_spawn_function("keeper", &function_6ded398b);
	if(ai::shouldRegisterClientFieldForArchetype("keeper"))
	{
		clientfield::register("actor", "keeper_death", 15000, 2, "int", &function_6e8422e9, 0, 0);
	}
}

/*
	Name: function_6ded398b
	Namespace: zm_genesis_keeper
	Checksum: 0x244FF664
	Offset: 0x300
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function function_6ded398b(localClientNum)
{
	self thread function_ea48e71e(localClientNum);
}

/*
	Name: function_ea48e71e
	Namespace: zm_genesis_keeper
	Checksum: 0x1A010F33
	Offset: 0x330
	Size: 0x13F
	Parameters: 1
	Flags: None
*/
function function_ea48e71e(localClientNum)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	s_timer = new_timer(localClientNum);
	n_phase_in = 1;
	do
	{
		util::server_wait(localClientNum, 0.11);
		n_current_time = s_timer get_time_in_seconds();
		n_delta_val = LerpFloat(0, 1, n_current_time / n_phase_in);
		self MapShaderConstant(localClientNum, 0, "scriptVector2", n_delta_val);
		self MapShaderConstant(localClientNum, 0, "scriptVector0", n_delta_val);
	}
	while(!n_current_time < n_phase_in);
	s_timer notify("timer_done");
}

/*
	Name: new_timer
	Namespace: zm_genesis_keeper
	Checksum: 0x3F9BF60F
	Offset: 0x478
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function new_timer(localClientNum)
{
	s_timer = spawnstruct();
	s_timer.n_time_current = 0;
	s_timer thread timer_increment_loop(localClientNum, self);
	return s_timer;
}

/*
	Name: timer_increment_loop
	Namespace: zm_genesis_keeper
	Checksum: 0xEDBCC95E
	Offset: 0x4D8
	Size: 0x67
	Parameters: 2
	Flags: None
*/
function timer_increment_loop(localClientNum, entity)
{
	entity endon("entityshutdown");
	self endon("timer_done");
	while(isdefined(self))
	{
		util::server_wait(localClientNum, 0.016);
		self.n_time_current = self.n_time_current + 0.016;
	}
}

/*
	Name: get_time
	Namespace: zm_genesis_keeper
	Checksum: 0xEE270E23
	Offset: 0x548
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function get_time()
{
	return self.n_time_current * 1000;
}

/*
	Name: get_time_in_seconds
	Namespace: zm_genesis_keeper
	Checksum: 0xD575C899
	Offset: 0x560
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_time_in_seconds()
{
	return self.n_time_current;
}

/*
	Name: reset_timer
	Namespace: zm_genesis_keeper
	Checksum: 0x4EC7C232
	Offset: 0x578
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function reset_timer()
{
	self.n_time_current = 0;
}

/*
	Name: function_6e8422e9
	Namespace: zm_genesis_keeper
	Checksum: 0x1D179980
	Offset: 0x590
	Size: 0x27B
	Parameters: 7
	Flags: None
*/
function function_6e8422e9(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	if(newVal == 1)
	{
		s_timer = new_timer(localClientNum);
		n_phase_in = 0.3;
		self.removingFireShader = 1;
		do
		{
			util::server_wait(localClientNum, 0.11);
			n_current_time = s_timer get_time_in_seconds();
			n_delta_val = LerpFloat(1, 0.1, n_current_time / n_phase_in);
			self MapShaderConstant(localClientNum, 0, "scriptVector2", n_delta_val);
		}
		while(!n_current_time < n_phase_in);
		s_timer notify("timer_done");
		self.removingFireShader = 0;
	}
	else if(newVal == 2)
	{
		if(!isdefined(self))
		{
			return;
		}
		n_phase_in = 0.3;
		s_timer = new_timer(localClientNum);
		do
		{
			util::server_wait(localClientNum, 0.11);
			n_current_time = s_timer get_time_in_seconds();
			n_delta_val = LerpFloat(1, 0, n_current_time / n_phase_in);
			self MapShaderConstant(localClientNum, 0, "scriptVector0", n_delta_val);
		}
		while(!n_current_time < n_phase_in);
		s_timer notify("timer_done");
		self MapShaderConstant(localClientNum, 0, "scriptVector0", 0);
	}
}

