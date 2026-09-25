#using scripts\shared\flagsys_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace util;

/*
	Name: empty
	Namespace: util
	Checksum: 0x8EECE268
	Offset: 0x2B0
	Size: 0x2B
	Parameters: 5
	Flags: None
*/
function empty(a, b, c, d, e)
{
}

/*
	Name: waitforallclients
	Namespace: util
	Checksum: 0x33122F03
	Offset: 0x2E8
	Size: 0x85
	Parameters: 0
	Flags: None
*/
function waitforallclients()
{
	localClient = 0;
	if(!isdefined(level.localPlayers))
	{
		while(!isdefined(level.localPlayers))
		{
			wait(0.016);
		}
	}
	while(level.localPlayers.size <= 0)
	{
		wait(0.016);
	}
	while(localClient < level.localPlayers.size)
	{
		waitforclient(localClient);
		localClient++;
	}
}

/*
	Name: waitforclient
	Namespace: util
	Checksum: 0xA401AC1C
	Offset: 0x378
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function waitforclient(client)
{
	while(!clienthassnapshot(client))
	{
		wait(0.016);
	}
}

/*
	Name: get_dvar_float_default
	Namespace: util
	Checksum: 0x944B1C1A
	Offset: 0x3B8
	Size: 0x61
	Parameters: 2
	Flags: None
*/
function get_dvar_float_default(str_dvar, default_val)
{
	value = GetDvarString(str_dvar);
	if(value != "")
	{
	}
	else
	{
	}
	return default_val;
}

/*
	Name: get_dvar_int_default
	Namespace: util
	Checksum: 0xDE99DEBF
	Offset: 0x428
	Size: 0x61
	Parameters: 2
	Flags: None
*/
function get_dvar_int_default(str_dvar, default_val)
{
	value = GetDvarString(str_dvar);
	if(value != "")
	{
	}
	else
	{
	}
	return default_val;
}

/*
	Name: spawn_model
	Namespace: util
	Checksum: 0x9A2DCB15
	Offset: 0x498
	Size: 0xAB
	Parameters: 4
	Flags: None
*/
function spawn_model(n_client, STR_MODEL, origin, angles)
{
	if(!isdefined(origin))
	{
		origin = (0, 0, 0);
	}
	if(!isdefined(angles))
	{
		angles = (0, 0, 0);
	}
	model = spawn(n_client, origin, "script_model");
	model SetModel(STR_MODEL);
	model.angles = angles;
	return model;
}

/*
	Name: waittill_string
	Namespace: util
	Checksum: 0x49B06D09
	Offset: 0x550
	Size: 0x57
	Parameters: 2
	Flags: None
*/
function waittill_string(msg, ent)
{
	if(msg != "entityshutdown")
	{
		self endon("entityshutdown");
	}
	ent endon("die");
	self waittill(msg);
	ent notify("returned", msg);
}

/*
	Name: waittill_multiple
	Namespace: util
	Checksum: 0x7554B5F1
	Offset: 0x5B0
	Size: 0xA9
	Parameters: 1
	Flags: 32
*/
function waittill_multiple(vararg)
{
	s_tracker = spawnstruct();
	s_tracker._wait_count = 0;
	for(i = 0; i < vararg.size; i++)
	{
		self thread _waitlogic(s_tracker, vararg[i]);
	}
	if(s_tracker._wait_count > 0)
	{
		s_tracker waittill("waitlogic_finished");
	}
}

/*
	Name: waittill_multiple_ents
	Namespace: util
	Checksum: 0x3C0E4EBA
	Offset: 0x668
	Size: 0x1E1
	Parameters: 1
	Flags: 32
*/
function waittill_multiple_ents(vararg)
{
	a_ents = [];
	a_notifies = [];
	for(i = 0; i < vararg.size; i++)
	{
		if(i % 2)
		{
			if(!isdefined(a_notifies))
			{
				a_notifies = [];
			}
			else if(!IsArray(a_notifies))
			{
				a_notifies = Array(a_notifies);
			}
			a_notifies[a_notifies.size] = vararg[i];
			continue;
		}
		if(!isdefined(a_ents))
		{
			a_ents = [];
		}
		else if(!IsArray(a_ents))
		{
			a_ents = Array(a_ents);
		}
		a_ents[a_ents.size] = vararg[i];
	}
	s_tracker = spawnstruct();
	s_tracker._wait_count = 0;
	for(i = 0; i < a_ents.size; i++)
	{
		ent = a_ents[i];
		if(isdefined(ent))
		{
			ent thread _waitlogic(s_tracker, a_notifies[i]);
		}
	}
	if(s_tracker._wait_count > 0)
	{
		s_tracker waittill("waitlogic_finished");
	}
}

/*
	Name: _waitlogic
	Namespace: util
	Checksum: 0xC88C8F6E
	Offset: 0x858
	Size: 0xCF
	Parameters: 2
	Flags: None
*/
function _waitlogic(s_tracker, notifies)
{
	s_tracker._wait_count++;
	if(!isdefined(notifies))
	{
		notifies = [];
	}
	else if(!IsArray(notifies))
	{
		notifies = Array(notifies);
	}
	notifies[notifies.size] = "entityshutdown";
	waittill_any_array(notifies);
	s_tracker._wait_count--;
	if(s_tracker._wait_count == 0)
	{
		s_tracker notify("waitlogic_finished");
	}
}

/*
	Name: waittill_any_return
	Namespace: util
	Checksum: 0x776FB161
	Offset: 0x930
	Size: 0x267
	Parameters: 7
	Flags: None
*/
function waittill_any_return(string1, string2, string3, string4, string5, string6, string7)
{
	if(!isdefined(string1) || string1 != "entityshutdown" && (!isdefined(string2) || string2 != "entityshutdown") && (!isdefined(string3) || string3 != "entityshutdown") && (!isdefined(string4) || string4 != "entityshutdown") && (!isdefined(string5) || string5 != "entityshutdown") && (!isdefined(string6) || string6 != "entityshutdown") && (!isdefined(string7) || string7 != "entityshutdown"))
	{
		self endon("entityshutdown");
	}
	ent = spawnstruct();
	if(isdefined(string1))
	{
		self thread waittill_string(string1, ent);
	}
	if(isdefined(string2))
	{
		self thread waittill_string(string2, ent);
	}
	if(isdefined(string3))
	{
		self thread waittill_string(string3, ent);
	}
	if(isdefined(string4))
	{
		self thread waittill_string(string4, ent);
	}
	if(isdefined(string5))
	{
		self thread waittill_string(string5, ent);
	}
	if(isdefined(string6))
	{
		self thread waittill_string(string6, ent);
	}
	if(isdefined(string7))
	{
		self thread waittill_string(string7, ent);
	}
	ent waittill("returned", msg);
	ent notify("die");
	return msg;
}

/*
	Name: waittill_any_ex
	Namespace: util
	Checksum: 0xD9AFF40C
	Offset: 0xBA0
	Size: 0x1CB
	Parameters: 1
	Flags: 32
*/
function waittill_any_ex(vararg)
{
	s_common = spawnstruct();
	e_current = self;
	n_arg_index = 0;
	if(StrIsNumber(vararg[0]))
	{
		n_timeout = vararg[0];
		n_arg_index++;
		if(n_timeout > 0)
		{
			s_common thread _timeout(n_timeout);
		}
	}
	if(IsArray(vararg[n_arg_index]))
	{
		a_params = vararg[n_arg_index];
		n_start_index = 0;
	}
	else
	{
		a_params = vararg;
		n_start_index = n_arg_index;
	}
	for(i = n_start_index; i < a_params.size; i++)
	{
		if(!IsString(a_params[i]))
		{
			e_current = a_params[i];
			continue;
		}
		if(isdefined(e_current))
		{
			e_current thread waittill_string(a_params[i], s_common);
		}
	}
	s_common waittill("returned", str_notify);
	s_common notify("die");
	return str_notify;
}

/*
	Name: waittill_any_array_return
	Namespace: util
	Checksum: 0x191BF226
	Offset: 0xD78
	Size: 0x117
	Parameters: 1
	Flags: None
*/
function waittill_any_array_return(a_notifies)
{
	if(IsInArray(a_notifies, "entityshutdown"))
	{
		self endon("entityshutdown");
	}
	s_tracker = spawnstruct();
	foreach(str_notify in a_notifies)
	{
		if(isdefined(str_notify))
		{
			self thread waittill_string(str_notify, s_tracker);
		}
	}
	s_tracker waittill("returned", msg);
	s_tracker notify("die");
	return msg;
}

/*
	Name: waittill_any
	Namespace: util
	Checksum: 0x827B0C90
	Offset: 0xE98
	Size: 0x83
	Parameters: 5
	Flags: None
*/
function waittill_any(str_notify1, str_notify2, str_notify3, str_notify4, str_notify5)
{
	/#
		Assert(isdefined(str_notify1));
	#/
	waittill_any_array(Array(str_notify1, str_notify2, str_notify3, str_notify4, str_notify5));
}

/*
	Name: waittill_any_array
	Namespace: util
	Checksum: 0x6BCE93A1
	Offset: 0xF28
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function waittill_any_array(a_notifies)
{
	/#
		Assert(isdefined(a_notifies[0]), "Dev Block strings are not supported");
	#/
	for(i = 1; i < a_notifies.size; i++)
	{
		if(isdefined(a_notifies[i]))
		{
			self endon(a_notifies[i]);
		}
	}
	self waittill(a_notifies[0]);
}

/*
	Name: waittill_any_timeout
	Namespace: util
	Checksum: 0x8261B2F8
	Offset: 0xFC0
	Size: 0x1EF
	Parameters: 6
	Flags: None
*/
function waittill_any_timeout(n_timeout, string1, string2, string3, string4, string5)
{
	if(!isdefined(string1) || string1 != "entityshutdown" && (!isdefined(string2) || string2 != "entityshutdown") && (!isdefined(string3) || string3 != "entityshutdown") && (!isdefined(string4) || string4 != "entityshutdown") && (!isdefined(string5) || string5 != "entityshutdown"))
	{
		self endon("entityshutdown");
	}
	ent = spawnstruct();
	if(isdefined(string1))
	{
		self thread waittill_string(string1, ent);
	}
	if(isdefined(string2))
	{
		self thread waittill_string(string2, ent);
	}
	if(isdefined(string3))
	{
		self thread waittill_string(string3, ent);
	}
	if(isdefined(string4))
	{
		self thread waittill_string(string4, ent);
	}
	if(isdefined(string5))
	{
		self thread waittill_string(string5, ent);
	}
	ent thread _timeout(n_timeout);
	ent waittill("returned", msg);
	ent notify("die");
	return msg;
}

/*
	Name: _timeout
	Namespace: util
	Checksum: 0x52DE6BA9
	Offset: 0x11B8
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function _timeout(delay)
{
	self endon("die");
	wait(delay);
	self notify("returned", "timeout");
}

/*
	Name: waittill_notify_or_timeout
	Namespace: util
	Checksum: 0xA3251A25
	Offset: 0x11F8
	Size: 0x21
	Parameters: 2
	Flags: None
*/
function waittill_notify_or_timeout(msg, timer)
{
	self endon(msg);
	wait(timer);
}

/*
	Name: waittill_any_ents
	Namespace: util
	Checksum: 0x4A1A4249
	Offset: 0x1228
	Size: 0x173
	Parameters: 14
	Flags: None
*/
function waittill_any_ents(ent1, string1, ent2, string2, ent3, string3, ent4, string4, ent5, string5, ent6, string6, ent7, string7)
{
	/#
		Assert(isdefined(ent1));
	#/
	/#
		Assert(isdefined(string1));
	#/
	if(isdefined(ent2) && isdefined(string2))
	{
		ent2 endon(string2);
	}
	if(isdefined(ent3) && isdefined(string3))
	{
		ent3 endon(string3);
	}
	if(isdefined(ent4) && isdefined(string4))
	{
		ent4 endon(string4);
	}
	if(isdefined(ent5) && isdefined(string5))
	{
		ent5 endon(string5);
	}
	if(isdefined(ent6) && isdefined(string6))
	{
		ent6 endon(string6);
	}
	if(isdefined(ent7) && isdefined(string7))
	{
		ent7 endon(string7);
	}
	ent1 waittill(string1);
}

/*
	Name: waittill_any_ents_two
	Namespace: util
	Checksum: 0x418113D0
	Offset: 0x13A8
	Size: 0x8D
	Parameters: 4
	Flags: None
*/
function waittill_any_ents_two(ent1, string1, ent2, string2)
{
	/#
		Assert(isdefined(ent1));
	#/
	/#
		Assert(isdefined(string1));
	#/
	if(isdefined(ent2) && isdefined(string2))
	{
		ent2 endon(string2);
	}
	ent1 waittill(string1);
}

/*
	Name: single_func
	Namespace: util
	Checksum: 0x74A1AB65
	Offset: 0x1440
	Size: 0x16D
	Parameters: 8
	Flags: None
*/
function single_func(entity, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	if(!isdefined(entity))
	{
		entity = level;
	}
	if(isdefined(arg6))
	{
		return entity [[func]](arg1, arg2, arg3, arg4, arg5, arg6);
	}
	else if(isdefined(arg5))
	{
		return entity [[func]](arg1, arg2, arg3, arg4, arg5);
	}
	else if(isdefined(arg4))
	{
		return entity [[func]](arg1, arg2, arg3, arg4);
	}
	else if(isdefined(arg3))
	{
		return entity [[func]](arg1, arg2, arg3);
	}
	else if(isdefined(arg2))
	{
		return entity [[func]](arg1, arg2);
	}
	else if(isdefined(arg1))
	{
		return entity [[func]](arg1);
	}
	else
	{
		return entity [[func]]();
	}
}

/*
	Name: new_func
	Namespace: util
	Checksum: 0x8DEA8452
	Offset: 0x15B8
	Size: 0xE7
	Parameters: 7
	Flags: None
*/
function new_func(func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	s_func = spawnstruct();
	s_func.func = func;
	s_func.arg1 = arg1;
	s_func.arg2 = arg2;
	s_func.arg3 = arg3;
	s_func.arg4 = arg4;
	s_func.arg5 = arg5;
	s_func.arg6 = arg6;
	return s_func;
}

/*
	Name: call_func
	Namespace: util
	Checksum: 0xC0A45989
	Offset: 0x16A8
	Size: 0x71
	Parameters: 1
	Flags: None
*/
function call_func(s_func)
{
	return single_func(self, s_func.func, s_func.arg1, s_func.arg2, s_func.arg3, s_func.arg4, s_func.arg5, s_func.arg6);
}

/*
	Name: array_ent_thread
	Namespace: util
	Checksum: 0x710C3196
	Offset: 0x1728
	Size: 0x16B
	Parameters: 7
	Flags: None
*/
function array_ent_thread(entities, func, arg1, arg2, arg3, arg4, arg5)
{
	/#
		Assert(isdefined(entities), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(func), "Dev Block strings are not supported");
	#/
	if(IsArray(entities))
	{
		if(entities.size)
		{
			keys = getArrayKeys(entities);
			for(i = 0; i < keys.size; i++)
			{
				single_thread(self, func, entities[keys[i]], arg1, arg2, arg3, arg4, arg5);
			}
		}
	}
	else
	{
		single_thread(self, func, entities, arg1, arg2, arg3, arg4, arg5);
	}
}

/*
	Name: single_thread
	Namespace: util
	Checksum: 0xEF0E77EE
	Offset: 0x18A0
	Size: 0x183
	Parameters: 8
	Flags: None
*/
function single_thread(entity, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	/#
		Assert(isdefined(entity), "Dev Block strings are not supported");
	#/
	if(isdefined(arg6))
	{
		entity thread [[func]](arg1, arg2, arg3, arg4, arg5, arg6);
	}
	else if(isdefined(arg5))
	{
		entity thread [[func]](arg1, arg2, arg3, arg4, arg5);
	}
	else if(isdefined(arg4))
	{
		entity thread [[func]](arg1, arg2, arg3, arg4);
	}
	else if(isdefined(arg3))
	{
		entity thread [[func]](arg1, arg2, arg3);
	}
	else if(isdefined(arg2))
	{
		entity thread [[func]](arg1, arg2);
	}
	else if(isdefined(arg1))
	{
		entity thread [[func]](arg1);
	}
	else
	{
		entity thread [[func]]();
	}
}

/*
	Name: add_listen_thread
	Namespace: util
	Checksum: 0x89A716E9
	Offset: 0x1A30
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function add_listen_thread(wait_till, func, param1, param2, param3, param4, param5)
{
	level thread add_listen_thread_internal(wait_till, func, param1, param2, param3, param4, param5);
}

/*
	Name: add_listen_thread_internal
	Namespace: util
	Checksum: 0x5806AAA2
	Offset: 0x1AA8
	Size: 0x77
	Parameters: 7
	Flags: None
*/
function add_listen_thread_internal(wait_till, func, param1, param2, param3, param4, param5)
{
	for(;;)
	{
		level waittill(wait_till);
		single_thread(level, func, param1, param2, param3, param4, param5);
	}
}

/*
	Name: timeout
	Namespace: util
	Checksum: 0xE165CA36
	Offset: 0x1B28
	Size: 0xD3
	Parameters: 8
	Flags: None
*/
function timeout(n_time, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	self endon("entityshutdown");
	if(isdefined(n_time))
	{
		__s = spawnstruct();
		__s endon("timeout");
		__s delay_notify(n_time, "timeout");
	}
	single_func(self, func, arg1, arg2, arg3, arg4, arg5, arg6);
}

/*
	Name: delay
	Namespace: util
	Checksum: 0x1E8A8113
	Offset: 0x1C08
	Size: 0x83
	Parameters: 9
	Flags: None
*/
function delay(time_or_notify, str_endon, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	self thread _delay(time_or_notify, str_endon, func, arg1, arg2, arg3, arg4, arg5, arg6);
}

/*
	Name: _delay
	Namespace: util
	Checksum: 0xBFCFE531
	Offset: 0x1C98
	Size: 0xC3
	Parameters: 9
	Flags: None
*/
function _delay(time_or_notify, str_endon, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	self endon("entityshutdown");
	if(isdefined(str_endon))
	{
		self endon(str_endon);
	}
	if(IsString(time_or_notify))
	{
		self waittill(time_or_notify);
	}
	else
	{
		wait(time_or_notify);
	}
	single_func(self, func, arg1, arg2, arg3, arg4, arg5, arg6);
}

/*
	Name: delay_notify
	Namespace: util
	Checksum: 0xB6A36DA2
	Offset: 0x1D68
	Size: 0x3B
	Parameters: 3
	Flags: None
*/
function delay_notify(time_or_notify, str_notify, str_endon)
{
	self thread _delay_notify(time_or_notify, str_notify, str_endon);
}

/*
	Name: _delay_notify
	Namespace: util
	Checksum: 0x8F9AD867
	Offset: 0x1DB0
	Size: 0x6B
	Parameters: 3
	Flags: None
*/
function _delay_notify(time_or_notify, str_notify, str_endon)
{
	self endon("entityshutdown");
	if(isdefined(str_endon))
	{
		self endon(str_endon);
	}
	if(IsString(time_or_notify))
	{
		self waittill(time_or_notify);
	}
	else
	{
		wait(time_or_notify);
	}
	self notify(str_notify);
}

/*
	Name: new_timer
	Namespace: util
	Checksum: 0x7C0BB092
	Offset: 0x1E28
	Size: 0x4F
	Parameters: 1
	Flags: None
*/
function new_timer(n_timer_length)
{
	s_timer = spawnstruct();
	s_timer.n_time_created = GetTime();
	s_timer.n_length = n_timer_length;
	return s_timer;
}

/*
	Name: get_time
	Namespace: util
	Checksum: 0xA5D5574
	Offset: 0x1E80
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function get_time()
{
	t_now = GetTime();
	return t_now - self.n_time_created;
}

/*
	Name: get_time_in_seconds
	Namespace: util
	Checksum: 0xE2A3F7D6
	Offset: 0x1EA8
	Size: 0x17
	Parameters: 0
	Flags: None
*/
function get_time_in_seconds()
{
	return get_time() / 1000;
}

/*
	Name: get_time_frac
	Namespace: util
	Checksum: 0xA129ED4A
	Offset: 0x1EC8
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function get_time_frac(n_end_time)
{
	if(!isdefined(n_end_time))
	{
		n_end_time = self.n_length;
	}
	return LerpFloat(0, 1, get_time_in_seconds() / n_end_time);
}

/*
	Name: get_time_left
	Namespace: util
	Checksum: 0x408DAA33
	Offset: 0x1F28
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function get_time_left()
{
	if(isdefined(self.n_length))
	{
		n_current_time = get_time_in_seconds();
		return max(self.n_length - n_current_time, 0);
	}
	return -1;
}

/*
	Name: is_time_left
	Namespace: util
	Checksum: 0x5B6F6F20
	Offset: 0x1F88
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function is_time_left()
{
	return get_time_left() != 0;
}

/*
	Name: timer_wait
	Namespace: util
	Checksum: 0x8B84F150
	Offset: 0x1FA8
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function timer_wait(n_wait)
{
	if(isdefined(self.n_length))
	{
		n_wait = min(n_wait, get_time_left());
	}
	wait(n_wait);
	n_current_time = get_time_in_seconds();
	return n_current_time;
}

/*
	Name: add_remove_list
	Namespace: util
	Checksum: 0x866BC067
	Offset: 0x2020
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function add_remove_list(a, on_off)
{
	if(!isdefined(a))
	{
		a = [];
	}
	if(on_off)
	{
		if(!IsInArray(a, self))
		{
			ArrayInsert(a, self, a.size);
		}
	}
	else
	{
		ArrayRemoveValue(a, self, 0);
	}
}

/*
	Name: clean_deleted
	Namespace: util
	Checksum: 0xF2AB6FAB
	Offset: 0x20B0
	Size: 0xE1
	Parameters: 1
	Flags: None
*/
function clean_deleted(Array)
{
	done = 0;
	while(!done && Array.size > 0)
	{
		done = 1;
		foreach(VAL in Array)
		{
			if(!isdefined(VAL))
			{
				ArrayRemoveIndex(Array, key, 0);
				done = 0;
				break;
			}
		}
	}
}

/*
	Name: get_eye
	Namespace: util
	Checksum: 0xA43FE45A
	Offset: 0x21A0
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function get_eye()
{
	if(SessionModeIsCampaignGame())
	{
		if(self isPlayer())
		{
			linked_ent = self GetLinkedEnt();
			if(isdefined(linked_ent) && GetDvarInt("cg_cameraUseTagCamera") > 0)
			{
				camera = linked_ent GetTagOrigin("tag_camera");
				if(isdefined(camera))
				{
					return camera;
				}
			}
		}
	}
	pos = self GetEye();
	return pos;
}

/*
	Name: spawn_player_arms
	Namespace: util
	Checksum: 0x39E2D8E4
	Offset: 0x2280
	Size: 0xA7
	Parameters: 0
	Flags: None
*/
function spawn_player_arms()
{
	arms = spawn(self getlocalclientnumber(), self.origin + VectorScale((0, 0, -1), 1000), "script_model");
	if(isdefined(level.player_viewmodel))
	{
		arms SetModel(level.player_viewmodel);
	}
	else
	{
		arms SetModel("c_usa_cia_masonjr_viewhands");
	}
	return arms;
}

/*
	Name: lerp_dvar
	Namespace: util
	Checksum: 0x8F83E1E6
	Offset: 0x2330
	Size: 0x141
	Parameters: 7
	Flags: None
*/
function lerp_dvar(str_dvar, n_start_val, n_end_val, n_lerp_time, b_saved_dvar, b_client_dvar, n_client)
{
	if(!isdefined(n_client))
	{
		n_client = 0;
	}
	if(!isdefined(n_start_val))
	{
		n_start_val = GetDvarFloat(str_dvar);
	}
	s_timer = new_timer();
	do
	{
		n_time_delta = s_timer timer_wait(0.01666);
		n_curr_val = LerpFloat(n_start_val, n_end_val, n_time_delta / n_lerp_time);
		if(isdefined(b_saved_dvar) && b_saved_dvar)
		{
			SetSavedDvar(str_dvar, n_curr_val);
		}
		else
		{
			SetDvar(str_dvar, n_curr_val);
		}
	}
	while(!n_time_delta < n_lerp_time);
}

/*
	Name: is_valid_type_for_callback
	Namespace: util
	Checksum: 0xA92F97E5
	Offset: 0x2480
	Size: 0x85
	Parameters: 1
	Flags: None
*/
function is_valid_type_for_callback(type)
{
	switch(type)
	{
		case "NA":
		case "actor":
		case "general":
		case "helicopter":
		case "missile":
		case "plane":
		case "player":
		case "scriptmover":
		case "trigger":
		case "turret":
		case "vehicle":
		{
			return 1;
		}
		case default:
		{
			return 0;
		}
	}
}

/*
	Name: wait_till_not_touching
	Namespace: util
	Checksum: 0xA83A3FF9
	Offset: 0x2510
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function wait_till_not_touching(e_to_check, e_to_touch)
{
	/#
		Assert(isdefined(e_to_check), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(e_to_touch), "Dev Block strings are not supported");
	#/
	e_to_check endon("entityshutdown");
	e_to_touch endon("entityshutdown");
	while(e_to_check istouching(e_to_touch))
	{
		wait(0.05);
	}
}

/*
	Name: error
	Namespace: util
	Checksum: 0xC17CBCE5
	Offset: 0x25C0
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function error(message)
{
	/#
		println("Dev Block strings are not supported", message);
		wait(0.05);
	#/
}

/*
	Name: REGISTER_SYSTEM
	Namespace: util
	Checksum: 0x1BD5B5E
	Offset: 0x2600
	Size: 0xD7
	Parameters: 2
	Flags: None
*/
function REGISTER_SYSTEM(sSysName, cbFunc)
{
	if(!isdefined(level._systemStates))
	{
		level._systemStates = [];
	}
	if(level._systemStates.size >= 32)
	{
		/#
			error("Dev Block strings are not supported");
		#/
		return;
	}
	if(isdefined(level._systemStates[sSysName]))
	{
		/#
			error("Dev Block strings are not supported" + sSysName);
		#/
		return;
	}
	else
	{
		level._systemStates[sSysName] = spawnstruct();
		level._systemStates[sSysName].callback = cbFunc;
	}
}

/*
	Name: field_set_lighting_ent
	Namespace: util
	Checksum: 0x6F8A68AC
	Offset: 0x26E0
	Size: 0x47
	Parameters: 7
	Flags: None
*/
function field_set_lighting_ent(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level.light_entity = self;
}

/*
	Name: field_use_lighting_ent
	Namespace: util
	Checksum: 0x372D0D26
	Offset: 0x2730
	Size: 0x3B
	Parameters: 7
	Flags: None
*/
function field_use_lighting_ent(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
}

/*
	Name: waittill_dobj
	Namespace: util
	Checksum: 0x5FCF7E7
	Offset: 0x2778
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function waittill_dobj(localClientNum)
{
	while(isdefined(self) && !self hasdobj(localClientNum))
	{
		wait(0.016);
	}
}

/*
	Name: server_wait
	Namespace: util
	Checksum: 0xB4E33953
	Offset: 0x27C0
	Size: 0x121
	Parameters: 4
	Flags: None
*/
function server_wait(localClientNum, seconds, waitBetweenChecks, level_endon)
{
	if(isdefined(level_endon))
	{
		level endon(level_endon);
	}
	if(level.IsDemoPlaying && seconds != 0)
	{
		if(!isdefined(waitBetweenChecks))
		{
			waitBetweenChecks = 0.2;
		}
		waitCompletedSuccessfully = 0;
		startTime = level.serverTime;
		lastTime = startTime;
		endTime = startTime + seconds * 1000;
		while(level.serverTime < endTime && level.serverTime >= lastTime)
		{
			lastTime = level.serverTime;
			wait(waitBetweenChecks);
		}
		if(lastTime < level.serverTime)
		{
			waitCompletedSuccessfully = 1;
		}
	}
	else
	{
		WaitRealTime(seconds);
		waitCompletedSuccessfully = 1;
	}
	return waitCompletedSuccessfully;
}

/*
	Name: friend_not_foe
	Namespace: util
	Checksum: 0xCD5F35C1
	Offset: 0x28F0
	Size: 0x14B
	Parameters: 2
	Flags: None
*/
function friend_not_foe(localClientIndex, predicted)
{
	player = GetNonPredictedLocalPlayer(localClientIndex);
	if(isdefined(predicted) && predicted || (isdefined(player) && isdefined(player.team) && player.team == "spectator"))
	{
		player = GetLocalPlayer(localClientIndex);
	}
	if(isdefined(player) && isdefined(player.team))
	{
		team = player.team;
		if(team == "free")
		{
			owner = self GetOwner(localClientIndex);
			if(isdefined(owner) && owner == player)
			{
				return 1;
			}
		}
		else if(self.team == team)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: friend_not_foe_team
	Namespace: util
	Checksum: 0x4EC08C2E
	Offset: 0x2A48
	Size: 0xE3
	Parameters: 3
	Flags: None
*/
function friend_not_foe_team(localClientIndex, team, predicted)
{
	player = GetNonPredictedLocalPlayer(localClientIndex);
	if(isdefined(predicted) && predicted || (isdefined(player) && isdefined(player.team) && player.team == "spectator"))
	{
		player = GetLocalPlayer(localClientIndex);
	}
	if(isdefined(player) && isdefined(player.team))
	{
		if(player.team == team)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: IsEnemyPlayer
	Namespace: util
	Checksum: 0xEE926CB8
	Offset: 0x2B38
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function IsEnemyPlayer(player)
{
	/#
		Assert(isdefined(player));
	#/
	if(!player isPlayer())
	{
		return 0;
	}
	if(player.team != "free")
	{
		if(player.team == self.team)
		{
			return 0;
		}
	}
	else if(player == self)
	{
		return 0;
	}
	return 1;
}

/*
	Name: is_player_view_linked_to_entity
	Namespace: util
	Checksum: 0x85F8153F
	Offset: 0x2BE0
	Size: 0x4D
	Parameters: 1
	Flags: None
*/
function is_player_view_linked_to_entity(localClientNum)
{
	if(self IsDriving(localClientNum))
	{
		return 1;
	}
	if(self IsLocalPlayerWeaponViewOnlyLinked())
	{
		return 1;
	}
	return 0;
}

/*
	Name: init_utility
	Namespace: util
	Checksum: 0x1242C61B
	Offset: 0x2C38
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function init_utility()
{
	level.IsDemoPlaying = IsDemoPlaying();
	level.localPlayers = [];
	level.numGametypeReservedObjectives = [];
	level.releasedObjectives = [];
	maxLocalClients = GetMaxLocalClients();
	for(localClientNum = 0; localClientNum < maxLocalClients; localClientNum++)
	{
		level.releasedObjectives[localClientNum] = [];
		level.numGametypeReservedObjectives[localClientNum] = 0;
	}
	waitforclient(0);
	level.localPlayers = GetLocalPlayers();
}

/*
	Name: within_fov
	Namespace: util
	Checksum: 0x7B19BC71
	Offset: 0x2D18
	Size: 0xA1
	Parameters: 4
	Flags: None
*/
function within_fov(start_origin, start_angles, end_origin, fov)
{
	normal = VectorNormalize(end_origin - start_origin);
	FORWARD = AnglesToForward(start_angles);
	dot = VectorDot(FORWARD, normal);
	return dot >= fov;
}

/*
	Name: is_mature
	Namespace: util
	Checksum: 0x3B2E7EB4
	Offset: 0x2DC8
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function is_mature()
{
	return IsMatureContentEnabled();
}

/*
	Name: is_gib_restricted_build
	Namespace: util
	Checksum: 0xC7F32CC1
	Offset: 0x2DE8
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function is_gib_restricted_build()
{
	if(!(IsMatureContentEnabled() && IsShowGibsEnabled()))
	{
		return 1;
	}
	return 0;
}

/*
	Name: registerSystem
	Namespace: util
	Checksum: 0xB9B641E8
	Offset: 0x2E28
	Size: 0xD7
	Parameters: 2
	Flags: None
*/
function registerSystem(sSysName, cbFunc)
{
	if(!isdefined(level._systemStates))
	{
		level._systemStates = [];
	}
	if(level._systemStates.size >= 32)
	{
		/#
			error("Dev Block strings are not supported");
		#/
		return;
	}
	if(isdefined(level._systemStates[sSysName]))
	{
		/#
			error("Dev Block strings are not supported" + sSysName);
		#/
		return;
	}
	else
	{
		level._systemStates[sSysName] = spawnstruct();
		level._systemStates[sSysName].callback = cbFunc;
	}
}

/*
	Name: getStatsTableName
	Namespace: util
	Checksum: 0xE485BD4F
	Offset: 0x2F08
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function getStatsTableName()
{
	if(SessionModeIsCampaignGame())
	{
		return "gamedata/stats/cp/cp_statstable.csv";
	}
	else if(SessionModeIsZombiesGame())
	{
		return "gamedata/stats/zm/zm_statstable.csv";
	}
	else
	{
		return "gamedata/stats/mp/mp_statstable.csv";
	}
}

/*
	Name: add_trigger_to_ent
	Namespace: util
	Checksum: 0xD377B04
	Offset: 0x2F60
	Size: 0x61
	Parameters: 2
	Flags: None
*/
function add_trigger_to_ent(ent, trig)
{
	if(!isdefined(ent._triggers))
	{
		ent._triggers = [];
	}
	ent._triggers[trig GetEntityNumber()] = 1;
}

/*
	Name: remove_trigger_from_ent
	Namespace: util
	Checksum: 0x601E8A9C
	Offset: 0x2FD0
	Size: 0x81
	Parameters: 2
	Flags: None
*/
function remove_trigger_from_ent(ent, trig)
{
	if(!isdefined(ent._triggers))
	{
		return;
	}
	if(!isdefined(ent._triggers[trig GetEntityNumber()]))
	{
		return;
	}
	ent._triggers[trig GetEntityNumber()] = 0;
}

/*
	Name: ent_already_in_trigger
	Namespace: util
	Checksum: 0x54CC1C39
	Offset: 0x3060
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function ent_already_in_trigger(trig)
{
	if(!isdefined(self._triggers))
	{
		return 0;
	}
	if(!isdefined(self._triggers[trig GetEntityNumber()]))
	{
		return 0;
	}
	if(!self._triggers[trig GetEntityNumber()])
	{
		return 0;
	}
	return 1;
}

/*
	Name: trigger_thread
	Namespace: util
	Checksum: 0xF23F481
	Offset: 0x30D8
	Size: 0xFB
	Parameters: 3
	Flags: None
*/
function trigger_thread(ent, on_enter_payload, on_exit_payload)
{
	ent endon("entityshutdown");
	if(ent ent_already_in_trigger(self))
	{
		return;
	}
	add_trigger_to_ent(ent, self);
	if(isdefined(on_enter_payload))
	{
		[[on_enter_payload]](ent);
	}
	while(isdefined(ent) && ent istouching(self))
	{
		wait(0.016);
	}
	if(isdefined(ent) && isdefined(on_exit_payload))
	{
		[[on_exit_payload]](ent);
	}
	if(isdefined(ent))
	{
		remove_trigger_from_ent(ent, self);
	}
}

/*
	Name: local_player_trigger_thread_always_exit
	Namespace: util
	Checksum: 0x79DA31B8
	Offset: 0x31E0
	Size: 0xFB
	Parameters: 3
	Flags: None
*/
function local_player_trigger_thread_always_exit(ent, on_enter_payload, on_exit_payload)
{
	if(ent ent_already_in_trigger(self))
	{
		return;
	}
	add_trigger_to_ent(ent, self);
	if(isdefined(on_enter_payload))
	{
		[[on_enter_payload]](ent);
	}
	while(isdefined(ent) && ent istouching(self) && ent IsSplitScreenHost())
	{
		wait(0.016);
	}
	if(isdefined(on_exit_payload))
	{
		[[on_exit_payload]](ent);
	}
	if(isdefined(ent))
	{
		remove_trigger_from_ent(ent, self);
	}
}

/*
	Name: local_player_entity_thread
	Namespace: util
	Checksum: 0x168448BF
	Offset: 0x32E8
	Size: 0x93
	Parameters: 7
	Flags: None
*/
function local_player_entity_thread(localClientNum, entity, func, arg1, arg2, arg3, arg4)
{
	entity endon("entityshutdown");
	entity waittill_dobj(localClientNum);
	single_thread(entity, func, localClientNum, arg1, arg2, arg3, arg4);
}

/*
	Name: local_players_entity_thread
	Namespace: util
	Checksum: 0x6E8B7F10
	Offset: 0x3388
	Size: 0xAD
	Parameters: 6
	Flags: None
*/
function local_players_entity_thread(entity, func, arg1, arg2, arg3, arg4)
{
	players = level.localPlayers;
	for(i = 0; i < players.size; i++)
	{
		players[i] thread local_player_entity_thread(i, entity, func, arg1, arg2, arg3, arg4);
	}
}

/*
	Name: debug_line
	Namespace: util
	Checksum: 0xCA7F475B
	Offset: 0x3440
	Size: 0xAB
	Parameters: 4
	Flags: None
*/
function debug_line(from, to, color, time)
{
	/#
		level.debug_line = GetDvarInt("Dev Block strings are not supported", 0);
		if(isdefined(level.debug_line) && level.debug_line == 1)
		{
			if(!isdefined(time))
			{
				time = 1000;
			}
			line(from, to, color, 1, 1, time);
		}
	#/
}

/*
	Name: debug_star
	Namespace: util
	Checksum: 0x36A2D4D9
	Offset: 0x34F8
	Size: 0xAB
	Parameters: 3
	Flags: None
*/
function debug_star(origin, color, time)
{
	/#
		level.debug_star = GetDvarInt("Dev Block strings are not supported", 0);
		if(isdefined(level.debug_star) && level.debug_star == 1)
		{
			if(!isdefined(time))
			{
				time = 1000;
			}
			if(!isdefined(color))
			{
				color = (1, 1, 1);
			}
			debugstar(origin, time, color);
		}
	#/
}

/*
	Name: serverTime
	Namespace: util
	Checksum: 0xE56E953F
	Offset: 0x35B0
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function serverTime()
{
	for(;;)
	{
		level.serverTime = getServerTime(0);
		wait(0.016);
	}
}

/*
	Name: getNextObjID
	Namespace: util
	Checksum: 0xB7755A33
	Offset: 0x35E8
	Size: 0x10F
	Parameters: 1
	Flags: None
*/
function getNextObjID(localClientNum)
{
	nextID = 0;
	if(level.releasedObjectives[localClientNum].size > 0)
	{
		nextID = level.releasedObjectives[localClientNum][level.releasedObjectives[localClientNum].size - 1];
		level.releasedObjectives[localClientNum][level.releasedObjectives[localClientNum].size - 1] = undefined;
	}
	else
	{
		nextID = level.numGametypeReservedObjectives[localClientNum];
		level.numGametypeReservedObjectives[localClientNum]++;
	}
	/#
		if(nextID > 31)
		{
			println("Dev Block strings are not supported");
		}
		/#
			Assert(nextID < 32);
		#/
	#/
	if(nextID > 31)
	{
		nextID = 31;
	}
	return nextID;
}

/*
	Name: releaseObjID
	Namespace: util
	Checksum: 0x8EAB1241
	Offset: 0x3700
	Size: 0xAF
	Parameters: 2
	Flags: None
*/
function releaseObjID(localClientNum, objId)
{
	/#
		Assert(objId < level.numGametypeReservedObjectives[localClientNum]);
	#/
	for(i = 0; i < level.releasedObjectives[localClientNum].size; i++)
	{
		if(objId == level.releasedObjectives[localClientNum][i])
		{
			return;
		}
	}
	level.releasedObjectives[localClientNum][level.releasedObjectives[localClientNum].size] = objId;
}

/*
	Name: get_next_safehouse
	Namespace: util
	Checksum: 0xE087CD68
	Offset: 0x37B8
	Size: 0x6D
	Parameters: 1
	Flags: None
*/
function get_next_safehouse(str_next_map)
{
	switch(str_next_map)
	{
		case "cp_mi_sing_biodomes":
		case "cp_mi_sing_blackstation":
		case "cp_mi_sing_sgen":
		{
			return "cp_sh_singapore";
		}
		case "cp_mi_cairo_aquifer":
		case "cp_mi_cairo_infection":
		case "cp_mi_cairo_lotus":
		{
			return "cp_sh_cairo";
		}
		case default:
		{
			return "cp_sh_mobile";
		}
	}
}

/*
	Name: is_safehouse
	Namespace: util
	Checksum: 0xFDD175CB
	Offset: 0x3830
	Size: 0x81
	Parameters: 1
	Flags: None
*/
function is_safehouse(str_next_map)
{
	if(!isdefined(str_next_map))
	{
		str_next_map = ToLower(GetDvarString("mapname"));
	}
	switch(str_next_map)
	{
		case "cp_sh_cairo":
		case "cp_sh_mobile":
		case "cp_sh_singapore":
		{
			return 1;
		}
		case default:
		{
			return 0;
		}
	}
}

/*
	Name: button_held_think
	Namespace: util
	Checksum: 0x98C7A806
	Offset: 0x38C0
	Size: 0x11F
	Parameters: 1
	Flags: None
*/
function button_held_think(which_button)
{
	/#
		self endon("disconnect");
		if(!isdefined(self._holding_button))
		{
			self._holding_button = [];
		}
		self._holding_button[which_button] = 0;
		time_started = 0;
		while(1)
		{
			if(self._holding_button[which_button])
			{
				if(!self [[level._button_funcs[which_button]]]())
				{
					self._holding_button[which_button] = 0;
				}
			}
			else if(self [[level._button_funcs[which_button]]]())
			{
				if(time_started == 0)
				{
					time_started = GetTime();
				}
				if(GetTime() - time_started > 250)
				{
					self._holding_button[which_button] = 1;
				}
			}
			else if(time_started != 0)
			{
				time_started = 0;
			}
			wait(0.016);
		}
	#/
}

/*
	Name: init_button_wrappers
	Namespace: util
	Checksum: 0xBCDC8FE3
	Offset: 0x39E8
	Size: 0x51
	Parameters: 0
	Flags: None
*/
function init_button_wrappers()
{
	/#
		if(!isdefined(level._button_funcs))
		{
			level._button_funcs[4] = &function_5298bc32;
			level._button_funcs[5] = &function_95f33d4f;
		}
	#/
}

/*
	Name: function_d286c26d
	Namespace: util
	Checksum: 0x28F1A770
	Offset: 0x3A48
	Size: 0x5D
	Parameters: 0
	Flags: None
*/
function function_d286c26d()
{
	/#
		init_button_wrappers();
		if(!isdefined(self.var_8ea437f9))
		{
			self thread button_held_think(4);
			self.var_8ea437f9 = 1;
		}
		return self._holding_button[4];
	#/
}

/*
	Name: function_1adfa50a
	Namespace: util
	Checksum: 0xCE566DF5
	Offset: 0x3AB0
	Size: 0x5D
	Parameters: 0
	Flags: None
*/
function function_1adfa50a()
{
	/#
		init_button_wrappers();
		if(!isdefined(self.var_2aff266a))
		{
			self thread button_held_think(5);
			self.var_2aff266a = 1;
		}
		return self._holding_button[5];
	#/
}

/*
	Name: function_5298bc32
	Namespace: util
	Checksum: 0xA274F376
	Offset: 0x3B18
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_5298bc32()
{
	/#
		return self buttonpressed("Dev Block strings are not supported") || self buttonpressed("Dev Block strings are not supported");
	#/
}

/*
	Name: function_e0163a6f
	Namespace: util
	Checksum: 0xC77FF59
	Offset: 0x3B68
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_e0163a6f()
{
	/#
		while(!self function_5298bc32())
		{
			wait(0.05);
		}
	#/
}

/*
	Name: function_95f33d4f
	Namespace: util
	Checksum: 0xB61215B3
	Offset: 0x3BA0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_95f33d4f()
{
	/#
		return self buttonpressed("Dev Block strings are not supported") || self buttonpressed("Dev Block strings are not supported");
	#/
}

/*
	Name: function_d9a6f8a6
	Namespace: util
	Checksum: 0xE3221DD8
	Offset: 0x3BF0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_d9a6f8a6()
{
	/#
		while(!self function_95f33d4f())
		{
			wait(0.05);
		}
	#/
}

