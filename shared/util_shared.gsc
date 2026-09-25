#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;

#namespace util;

/*
	Name: empty
	Namespace: util
	Checksum: 0xF567718D
	Offset: 0xA98
	Size: 0x2B
	Parameters: 5
	Flags: None
*/
function empty(a, b, c, d, e)
{
}

/*
	Name: wait_network_frame
	Namespace: util
	Checksum: 0xC5E03B92
	Offset: 0xAD0
	Size: 0xD1
	Parameters: 1
	Flags: None
*/
function wait_network_frame(n_count)
{
	if(!isdefined(n_count))
	{
		n_count = 1;
	}
	if(NumRemoteClients())
	{
		for(i = 0; i < n_count; i++)
		{
			snapshot_ids = GetSnapShotIndexArray();
			for(acked = undefined; !isdefined(acked);  = undefined)
			{
				level waittill("snapacknowledged");
			}
		}
	}
	else
	{
		wait(0.1 * n_count);
	}
}

/*
	Name: streamer_wait
	Namespace: util
	Checksum: 0xED6E48D2
	Offset: 0xBB0
	Size: 0x29F
	Parameters: 4
	Flags: None
*/
function streamer_wait(n_stream_request_id, n_wait_frames, n_timeout, b_bonuszm_streamer_fallback)
{
	if(!isdefined(n_wait_frames))
	{
		n_wait_frames = 0;
	}
	if(!isdefined(n_timeout))
	{
		n_timeout = 0;
	}
	if(!isdefined(b_bonuszm_streamer_fallback))
	{
		b_bonuszm_streamer_fallback = 1;
	}
	level endon("loading_movie_done");
	if(n_wait_frames > 0)
	{
		wait_network_frame(n_wait_frames);
	}
	if(SessionModeIsCampaignZombiesGame() && (isdefined(b_bonuszm_streamer_fallback) && b_bonuszm_streamer_fallback))
	{
		if(!n_timeout)
		{
			n_timeout = 7;
		}
	}
	timeout = GetTime() + n_timeout * 1000;
	if(self == level)
	{
		n_num_streamers_ready = 0;
		do
		{
			wait_network_frame();
			n_num_streamers_ready = 0;
			foreach(player in GetPlayers())
			{
				if(isdefined(n_stream_request_id))
				{
				}
				else if(player isStreamerReady())
				{
					n_num_streamers_ready++;
				}
			}
			if(n_timeout > 0 && GetTime() > timeout)
			{
			}
		}
		while(!n_num_streamers_ready < max(1, GetPlayers().size));
		else
		{
		}
	}
	else
	{
		self endon("disconnect");
		do
		{
			wait_network_frame();
			if(n_timeout > 0 && GetTime() > timeout)
			{
			}
			else if(isdefined(n_stream_request_id))
			{
			}
			else
			{
			}
		}
		while(!!self isStreamerReady());
	}
}

/*
	Name: draw_debug_line
	Namespace: util
	Checksum: 0x899EDFFB
	Offset: 0xE58
	Size: 0x85
	Parameters: 3
	Flags: None
*/
function draw_debug_line(start, end, timer)
{
	/#
		for(i = 0; i < timer * 20; i++)
		{
			line(start, end, (1, 1, 0.5));
			wait(0.05);
		}
	#/
}

/*
	Name: debug_line
	Namespace: util
	Checksum: 0xAA6A427E
	Offset: 0xEE8
	Size: 0xB3
	Parameters: 6
	Flags: None
*/
function debug_line(start, end, color, alpha, depthTest, duration)
{
	/#
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		if(!isdefined(alpha))
		{
			alpha = 1;
		}
		if(!isdefined(depthTest))
		{
			depthTest = 0;
		}
		if(!isdefined(duration))
		{
			duration = 100;
		}
		line(start, end, color, alpha, depthTest, duration);
	#/
}

/*
	Name: debug_spherical_cone
	Namespace: util
	Checksum: 0x20251A7A
	Offset: 0xFA8
	Size: 0xDB
	Parameters: 8
	Flags: None
*/
function debug_spherical_cone(origin, domeApex, angle, slices, color, alpha, depthTest, duration)
{
	/#
		if(!isdefined(slices))
		{
			slices = 10;
		}
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		if(!isdefined(alpha))
		{
			alpha = 1;
		}
		if(!isdefined(depthTest))
		{
			depthTest = 0;
		}
		if(!isdefined(duration))
		{
			duration = 100;
		}
		sphericalcone(origin, domeApex, angle, slices, color, alpha, depthTest, duration);
	#/
}

/*
	Name: debug_sphere
	Namespace: util
	Checksum: 0xB68F69B4
	Offset: 0x1090
	Size: 0xCB
	Parameters: 5
	Flags: None
*/
function debug_sphere(origin, radius, color, alpha, time)
{
	/#
		if(!isdefined(time))
		{
			time = 1000;
		}
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		sides = Int(10 * 1 + Int(radius) % 100);
		sphere(origin, radius, color, alpha, 1, sides, time);
	#/
}

/*
	Name: waittillend
	Namespace: util
	Checksum: 0x160F1E6A
	Offset: 0x1168
	Size: 0x1D
	Parameters: 1
	Flags: None
*/
function waittillend(msg)
{
	self waittillmatch(msg);
}

/*
	Name: track
	Namespace: util
	Checksum: 0xBB916E55
	Offset: 0x1190
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function track(spot_to_track)
{
	if(isdefined(self.current_target))
	{
		if(spot_to_track == self.current_target)
		{
			return;
		}
	}
	self.current_target = spot_to_track;
}

/*
	Name: waittill_string
	Namespace: util
	Checksum: 0x7277804F
	Offset: 0x11D0
	Size: 0x57
	Parameters: 2
	Flags: None
*/
function waittill_string(msg, ent)
{
	if(msg != "death")
	{
		self endon("death");
	}
	ent endon("die");
	self waittill(msg);
	ent notify("returned", msg);
}

/*
	Name: waittill_level_string
	Namespace: util
	Checksum: 0x502FF31F
	Offset: 0x1230
	Size: 0x4F
	Parameters: 3
	Flags: None
*/
function waittill_level_string(msg, ent, otherEnt)
{
	otherEnt endon("death");
	ent endon("die");
	level waittill(msg);
	ent notify("returned", msg);
}

/*
	Name: waittill_multiple
	Namespace: util
	Checksum: 0xF39C1963
	Offset: 0x1288
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
	Name: waittill_either
	Namespace: util
	Checksum: 0xFAF43561
	Offset: 0x1340
	Size: 0x25
	Parameters: 2
	Flags: None
*/
function waittill_either(msg1, msg2)
{
	self endon(msg1);
	self waittill(msg2);
}

/*
	Name: break_glass
	Namespace: util
	Checksum: 0x73F9F2B4
	Offset: 0x1370
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function break_glass(n_radius)
{
	if(!isdefined(n_radius))
	{
		n_radius = 50;
	}
	n_radius = float(n_radius);
	if(n_radius == -1)
	{
		v_origin_offset = (0, 0, 0);
		n_radius = 100;
	}
	else
	{
		v_origin_offset = VectorScale((0, 0, 1), 40);
	}
	glassRadiusDamage(self.origin + v_origin_offset, n_radius, 500, 500);
}

/*
	Name: waittill_multiple_ents
	Namespace: util
	Checksum: 0xC4C8467
	Offset: 0x1430
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
	Checksum: 0xC3A6C319
	Offset: 0x1620
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
	notifies[notifies.size] = "death";
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
	Checksum: 0x8440F153
	Offset: 0x16F8
	Size: 0x267
	Parameters: 7
	Flags: None
*/
function waittill_any_return(string1, string2, string3, string4, string5, string6, string7)
{
	if(!isdefined(string1) || string1 != "death" && (!isdefined(string2) || string2 != "death") && (!isdefined(string3) || string3 != "death") && (!isdefined(string4) || string4 != "death") && (!isdefined(string5) || string5 != "death") && (!isdefined(string6) || string6 != "death") && (!isdefined(string7) || string7 != "death"))
	{
		self endon("death");
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
	Checksum: 0x4C6EF606
	Offset: 0x1968
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
	Checksum: 0x49BA8C12
	Offset: 0x1B40
	Size: 0x117
	Parameters: 1
	Flags: None
*/
function waittill_any_array_return(a_notifies)
{
	if(IsInArray(a_notifies, "death"))
	{
		self endon("death");
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
	Checksum: 0x85988244
	Offset: 0x1C60
	Size: 0x93
	Parameters: 6
	Flags: None
*/
function waittill_any(str_notify1, str_notify2, str_notify3, str_notify4, str_notify5, str_notify6)
{
	/#
		Assert(isdefined(str_notify1));
	#/
	waittill_any_array(Array(str_notify1, str_notify2, str_notify3, str_notify4, str_notify5, str_notify6));
}

/*
	Name: waittill_any_array
	Namespace: util
	Checksum: 0xFE9828CE
	Offset: 0x1D00
	Size: 0xDB
	Parameters: 1
	Flags: None
*/
function waittill_any_array(a_notifies)
{
	if(!isdefined(a_notifies))
	{
		a_notifies = [];
	}
	else if(!IsArray(a_notifies))
	{
		a_notifies = Array(a_notifies);
	}
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
	Checksum: 0x878D6DF4
	Offset: 0x1DE8
	Size: 0x1EF
	Parameters: 6
	Flags: None
*/
function waittill_any_timeout(n_timeout, string1, string2, string3, string4, string5)
{
	if(!isdefined(string1) || string1 != "death" && (!isdefined(string2) || string2 != "death") && (!isdefined(string3) || string3 != "death") && (!isdefined(string4) || string4 != "death") && (!isdefined(string5) || string5 != "death"))
	{
		self endon("death");
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
	Name: waittill_level_any_timeout
	Namespace: util
	Checksum: 0x937EAAFF
	Offset: 0x1FE0
	Size: 0x19F
	Parameters: 7
	Flags: None
*/
function waittill_level_any_timeout(n_timeout, otherEnt, string1, string2, string3, string4, string5)
{
	otherEnt endon("death");
	ent = spawnstruct();
	if(isdefined(string1))
	{
		level thread waittill_level_string(string1, ent, otherEnt);
	}
	if(isdefined(string2))
	{
		level thread waittill_level_string(string2, ent, otherEnt);
	}
	if(isdefined(string3))
	{
		level thread waittill_level_string(string3, ent, otherEnt);
	}
	if(isdefined(string4))
	{
		level thread waittill_level_string(string4, ent, otherEnt);
	}
	if(isdefined(string5))
	{
		level thread waittill_level_string(string5, ent, otherEnt);
	}
	if(isdefined(otherEnt))
	{
		otherEnt thread waittill_string("death", ent);
	}
	ent thread _timeout(n_timeout);
	ent waittill("returned", msg);
	ent notify("die");
	return msg;
}

/*
	Name: _timeout
	Namespace: util
	Checksum: 0x930B4D6D
	Offset: 0x2188
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
	Name: waittill_any_ents
	Namespace: util
	Checksum: 0x6FEEBC0E
	Offset: 0x21C8
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
	Checksum: 0xC5D3EE7E
	Offset: 0x2348
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
	Name: isFlashed
	Namespace: util
	Checksum: 0x2EBC088D
	Offset: 0x23E0
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function isFlashed()
{
	if(!isdefined(self.flashEndTime))
	{
		return 0;
	}
	return GetTime() < self.flashEndTime;
}

/*
	Name: isStunned
	Namespace: util
	Checksum: 0x384A53E0
	Offset: 0x2408
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function isStunned()
{
	if(!isdefined(self.flashEndTime))
	{
		return 0;
	}
	return GetTime() < self.flashEndTime;
}

/*
	Name: single_func
	Namespace: util
	Checksum: 0xB717BCD5
	Offset: 0x2430
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
	Checksum: 0x4EDC8ACE
	Offset: 0x25A8
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
	Checksum: 0x24BBD6AF
	Offset: 0x2698
	Size: 0x71
	Parameters: 1
	Flags: None
*/
function call_func(s_func)
{
	return single_func(self, s_func.func, s_func.arg1, s_func.arg2, s_func.arg3, s_func.arg4, s_func.arg5, s_func.arg6);
}

/*
	Name: single_thread
	Namespace: util
	Checksum: 0x99D39132
	Offset: 0x2718
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
	Name: script_delay
	Namespace: util
	Checksum: 0xD8472350
	Offset: 0x28A8
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function script_delay()
{
	if(isdefined(self.script_delay))
	{
		wait(self.script_delay);
		return 1;
	}
	else if(isdefined(self.script_delay_min) && isdefined(self.script_delay_max))
	{
		if(self.script_delay_max > self.script_delay_min)
		{
			wait(RandomFloatRange(self.script_delay_min, self.script_delay_max));
		}
		else
		{
			wait(self.script_delay_min);
		}
		return 1;
	}
	return 0;
}

/*
	Name: timeout
	Namespace: util
	Checksum: 0x8D188C1
	Offset: 0x2938
	Size: 0xCB
	Parameters: 8
	Flags: None
*/
function timeout(n_time, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	if(isdefined(n_time))
	{
		__s = spawnstruct();
		__s endon("timeout");
		__s delay_notify(n_time, "timeout");
	}
	single_func(self, func, arg1, arg2, arg3, arg4, arg5, arg6);
}

/*
	Name: create_flags_and_return_tokens
	Namespace: util
	Checksum: 0x640CFC76
	Offset: 0x2A10
	Size: 0xA9
	Parameters: 1
	Flags: None
*/
function create_flags_and_return_tokens(flags)
{
	tokens = StrTok(flags, " ");
	for(i = 0; i < tokens.size; i++)
	{
		if(!level flag::exists(tokens[i]))
		{
			level flag::init(tokens[i], undefined, 1);
		}
	}
	return tokens;
}

/*
	Name: fileprint_start
	Namespace: util
	Checksum: 0xB15BB138
	Offset: 0x2AC8
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function fileprint_start(file)
{
	/#
		filename = file;
		file = openfile(filename, "Dev Block strings are not supported");
		level.fileprint = file;
		level.fileprintlinecount = 0;
		level.fileprint_filename = filename;
	#/
}

/*
	Name: fileprint_map_start
	Namespace: util
	Checksum: 0x22631536
	Offset: 0x2B38
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function fileprint_map_start(file)
{
	/#
		file = "Dev Block strings are not supported" + file + "Dev Block strings are not supported";
		fileprint_start(file);
		level.fileprint_mapentcount = 0;
		fileprint_map_header(1);
	#/
}

/*
	Name: fileprint_chk
	Namespace: util
	Checksum: 0x9960EFAA
	Offset: 0x2BA8
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function fileprint_chk(file, STR)
{
	/#
		level.fileprintlinecount++;
		if(level.fileprintlinecount > 400)
		{
			wait(0.05);
			level.fileprintlinecount++;
			level.fileprintlinecount = 0;
		}
		fprintln(file, STR);
	#/
}

/*
	Name: fileprint_map_header
	Namespace: util
	Checksum: 0x95328F7F
	Offset: 0x2C18
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function fileprint_map_header(bInclude_blank_worldspawn)
{
	if(!isdefined(bInclude_blank_worldspawn))
	{
		bInclude_blank_worldspawn = 0;
	}
	/#
		Assert(isdefined(level.fileprint));
	#/
	/#
		fileprint_chk(level.fileprint, "Dev Block strings are not supported");
		fileprint_chk(level.fileprint, "Dev Block strings are not supported");
		fileprint_chk(level.fileprint, "Dev Block strings are not supported");
		if(!bInclude_blank_worldspawn)
		{
			return;
		}
		fileprint_map_entity_start();
		fileprint_map_keypairprint("Dev Block strings are not supported", "Dev Block strings are not supported");
		fileprint_map_entity_end();
	#/
}

/*
	Name: fileprint_map_keypairprint
	Namespace: util
	Checksum: 0xBD95B79B
	Offset: 0x2D18
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function fileprint_map_keypairprint(key1, key2)
{
	/#
		/#
			Assert(isdefined(level.fileprint));
		#/
		fileprint_chk(level.fileprint, "Dev Block strings are not supported" + key1 + "Dev Block strings are not supported" + key2 + "Dev Block strings are not supported");
	#/
}

/*
	Name: fileprint_map_entity_start
	Namespace: util
	Checksum: 0xD6ECF47F
	Offset: 0x2DA0
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function fileprint_map_entity_start()
{
	/#
		/#
			Assert(!isdefined(level.fileprint_entitystart));
		#/
		level.fileprint_entitystart = 1;
		/#
			Assert(isdefined(level.fileprint));
		#/
		fileprint_chk(level.fileprint, "Dev Block strings are not supported" + level.fileprint_mapentcount);
		fileprint_chk(level.fileprint, "Dev Block strings are not supported");
		level.fileprint_mapentcount++;
	#/
}

/*
	Name: fileprint_map_entity_end
	Namespace: util
	Checksum: 0x420399C5
	Offset: 0x2E58
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function fileprint_map_entity_end()
{
	/#
		/#
			Assert(isdefined(level.fileprint_entitystart));
		#/
		/#
			Assert(isdefined(level.fileprint));
		#/
		level.fileprint_entitystart = undefined;
		fileprint_chk(level.fileprint, "Dev Block strings are not supported");
	#/
}

/*
	Name: fileprint_end
	Namespace: util
	Checksum: 0xA7EC44F9
	Offset: 0x2ED8
	Size: 0x25D
	Parameters: 0
	Flags: None
*/
function fileprint_end()
{
	/#
		/#
			Assert(!isdefined(level.fileprint_entitystart));
		#/
		saved = closefile(level.fileprint);
		if(saved != 1)
		{
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported" + level.fileprint_filename);
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
		}
		level.fileprint = undefined;
		level.fileprint_filename = undefined;
	#/
}

/*
	Name: fileprint_radiant_vec
	Namespace: util
	Checksum: 0x90472F71
	Offset: 0x3140
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function fileprint_radiant_vec(vector)
{
	/#
		string = "Dev Block strings are not supported" + vector[0] + "Dev Block strings are not supported" + vector[1] + "Dev Block strings are not supported" + vector[2] + "Dev Block strings are not supported";
		return string;
	#/
}

/*
	Name: death_notify_wrapper
	Namespace: util
	Checksum: 0xA529E94
	Offset: 0x31B0
	Size: 0x3D
	Parameters: 2
	Flags: None
*/
function death_notify_wrapper(attacker, damageType)
{
	level notify("face", "death", self);
	self notify("death", attacker, damageType);
}

/*
	Name: damage_notify_wrapper
	Namespace: util
	Checksum: 0xCF9F8BE3
	Offset: 0x31F8
	Size: 0x91
	Parameters: 9
	Flags: None
*/
function damage_notify_wrapper(damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags)
{
	level notify("face", "damage", self);
	self notify("damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags);
}

/*
	Name: explode_notify_wrapper
	Namespace: util
	Checksum: 0x7F145899
	Offset: 0x3298
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function explode_notify_wrapper()
{
	level notify("face", "explode", self);
	self notify("explode");
}

/*
	Name: alert_notify_wrapper
	Namespace: util
	Checksum: 0x7851D5D7
	Offset: 0x32C8
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function alert_notify_wrapper()
{
	level notify("face", "alert", self);
	self notify("alert");
}

/*
	Name: shoot_notify_wrapper
	Namespace: util
	Checksum: 0x86F3F8D9
	Offset: 0x32F8
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function shoot_notify_wrapper()
{
	level notify("face", "shoot", self);
	self notify("shoot");
}

/*
	Name: melee_notify_wrapper
	Namespace: util
	Checksum: 0xC2917E90
	Offset: 0x3328
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function melee_notify_wrapper()
{
	level notify("face", "melee", self);
	self notify("melee");
}

/*
	Name: isUsabilityEnabled
	Namespace: util
	Checksum: 0x5B39E015
	Offset: 0x3358
	Size: 0xB
	Parameters: 0
	Flags: None
*/
function isUsabilityEnabled()
{
	return !self.disabledUsability;
}

/*
	Name: _disableUsability
	Namespace: util
	Checksum: 0xCC0896EE
	Offset: 0x3370
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function _disableUsability()
{
	self.disabledUsability++;
	self disableUsability();
}

/*
	Name: _enableUsability
	Namespace: util
	Checksum: 0xE4810DEE
	Offset: 0x33A0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function _enableUsability()
{
	self.disabledUsability--;
	/#
		Assert(self.disabledUsability >= 0);
	#/
	if(!self.disabledUsability)
	{
		self enableUsability();
	}
}

/*
	Name: resetUsability
	Namespace: util
	Checksum: 0x849256FD
	Offset: 0x33F8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function resetUsability()
{
	self.disabledUsability = 0;
	self enableUsability();
}

/*
	Name: _disableWeapon
	Namespace: util
	Checksum: 0x353F58D5
	Offset: 0x3428
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function _disableWeapon()
{
	if(!isdefined(self.disabledWeapon))
	{
		self.disabledWeapon = 0;
	}
	self.disabledWeapon++;
	self DisableWeapons();
}

/*
	Name: _enableWeapon
	Namespace: util
	Checksum: 0xE7808E32
	Offset: 0x3470
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function _enableWeapon()
{
	if(self.disabledWeapon > 0)
	{
		self.disabledWeapon--;
		if(!self.disabledWeapon)
		{
			self enableWeapons();
		}
	}
}

/*
	Name: isWeaponEnabled
	Namespace: util
	Checksum: 0x557C22F2
	Offset: 0x34B8
	Size: 0xB
	Parameters: 0
	Flags: None
*/
function isWeaponEnabled()
{
	return !self.disabledWeapon;
}

/*
	Name: orient_to_normal
	Namespace: util
	Checksum: 0x21B9989
	Offset: 0x34D0
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function orient_to_normal(normal)
{
	hor_normal = (normal[0], normal[1], 0);
	hor_length = length(hor_normal);
	if(!hor_length)
	{
		return (0, 0, 0);
	}
	hor_dir = VectorNormalize(hor_normal);
	neg_height = normal[2] * -1;
	tangent = (hor_dir[0] * neg_height, hor_dir[1] * neg_height, hor_length);
	plant_angle = VectorToAngles(tangent);
	return plant_angle;
}

/*
	Name: delay
	Namespace: util
	Checksum: 0xF0F60ED0
	Offset: 0x35D0
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
	Checksum: 0x900C6D85
	Offset: 0x3660
	Size: 0xC3
	Parameters: 9
	Flags: None
*/
function _delay(time_or_notify, str_endon, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	self endon("death");
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
	Name: delay_network_frames
	Namespace: util
	Checksum: 0xC439C538
	Offset: 0x3730
	Size: 0x83
	Parameters: 9
	Flags: None
*/
function delay_network_frames(n_frames, str_endon, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	self thread _delay_network_frames(n_frames, str_endon, func, arg1, arg2, arg3, arg4, arg5, arg6);
}

/*
	Name: _delay_network_frames
	Namespace: util
	Checksum: 0x4B1D49FD
	Offset: 0x37C0
	Size: 0xAB
	Parameters: 9
	Flags: None
*/
function _delay_network_frames(n_frames, str_endon, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	self endon("entityshutdown");
	if(isdefined(str_endon))
	{
		self endon(str_endon);
	}
	wait_network_frame(n_frames);
	single_func(self, func, arg1, arg2, arg3, arg4, arg5, arg6);
}

/*
	Name: delay_notify
	Namespace: util
	Checksum: 0xB2A47F6B
	Offset: 0x3878
	Size: 0x7B
	Parameters: 8
	Flags: None
*/
function delay_notify(time_or_notify, str_notify, str_endon, arg1, arg2, arg3, arg4, arg5)
{
	self thread _delay_notify(time_or_notify, str_notify, str_endon, arg1, arg2, arg3, arg4, arg5);
}

/*
	Name: _delay_notify
	Namespace: util
	Checksum: 0xFE893EE8
	Offset: 0x3900
	Size: 0xA7
	Parameters: 8
	Flags: None
*/
function _delay_notify(time_or_notify, str_notify, str_endon, arg1, arg2, arg3, arg4, arg5)
{
	self endon("death");
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
	self notify(str_notify, arg1, arg2, arg3, arg4, arg5);
}

/*
	Name: get_closest_player
	Namespace: util
	Checksum: 0xEFB2A1C8
	Offset: 0x39B0
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function get_closest_player(org, str_team)
{
	players = GetPlayers(str_team);
	return ArraySort(players, org, 1, 1)[0];
}

/*
	Name: registerClientSys
	Namespace: util
	Checksum: 0x76FD5BC0
	Offset: 0x3A18
	Size: 0xEB
	Parameters: 1
	Flags: None
*/
function registerClientSys(sSysName)
{
	if(!isdefined(level._clientSys))
	{
		level._clientSys = [];
	}
	if(level._clientSys.size >= 32)
	{
		/#
			/#
				ASSERTMSG("Dev Block strings are not supported");
			#/
		#/
		return;
	}
	if(isdefined(level._clientSys[sSysName]))
	{
		/#
			/#
				ASSERTMSG("Dev Block strings are not supported" + sSysName);
			#/
		#/
		return;
	}
	else
	{
		level._clientSys[sSysName] = spawnstruct();
		level._clientSys[sSysName].sysID = ClientSysRegister(sSysName);
	}
}

/*
	Name: setClientSysState
	Namespace: util
	Checksum: 0xCE16F5F8
	Offset: 0x3B10
	Size: 0x117
	Parameters: 3
	Flags: None
*/
function setClientSysState(sSysName, sSysState, player)
{
	if(!isdefined(level._clientSys))
	{
		/#
			/#
				ASSERTMSG("Dev Block strings are not supported");
			#/
		#/
		return;
	}
	if(!isdefined(level._clientSys[sSysName]))
	{
		/#
			/#
				ASSERTMSG("Dev Block strings are not supported" + sSysName);
			#/
		#/
		return;
	}
	if(isdefined(player))
	{
		player ClientSysSetState(level._clientSys[sSysName].sysID, sSysState);
	}
	else
	{
		ClientSysSetState(level._clientSys[sSysName].sysID, sSysState);
		level._clientSys[sSysName].sysState = sSysState;
	}
}

/*
	Name: getClientSysState
	Namespace: util
	Checksum: 0xB5E55DA9
	Offset: 0x3C30
	Size: 0xC5
	Parameters: 1
	Flags: None
*/
function getClientSysState(sSysName)
{
	if(!isdefined(level._clientSys))
	{
		/#
			/#
				ASSERTMSG("Dev Block strings are not supported");
			#/
		#/
		return "";
	}
	if(!isdefined(level._clientSys[sSysName]))
	{
		/#
			/#
				ASSERTMSG("Dev Block strings are not supported" + sSysName + "Dev Block strings are not supported");
			#/
		#/
		return "";
	}
	if(isdefined(level._clientSys[sSysName].sysState))
	{
		return level._clientSys[sSysName].sysState;
	}
	return "";
}

/*
	Name: clientNotify
	Namespace: util
	Checksum: 0x10AE3DA9
	Offset: 0x3D00
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function clientNotify(event)
{
	if(level.clientscripts)
	{
		if(isPlayer(self))
		{
			setClientSysState("levelNotify", event, self);
		}
		else
		{
			setClientSysState("levelNotify", event);
		}
	}
}

/*
	Name: coopGame
	Namespace: util
	Checksum: 0x133BF790
	Offset: 0x3D78
	Size: 0x41
	Parameters: 0
	Flags: None
*/
function coopGame()
{
	return SessionModeIsSystemlink() || (SessionModeIsOnlineGame() || IsSplitscreen());
}

/*
	Name: is_looking_at
	Namespace: util
	Checksum: 0x65DCBE5D
	Offset: 0x3DC8
	Size: 0x1D9
	Parameters: 4
	Flags: None
*/
function is_looking_at(ent_or_org, n_dot_range, do_trace, v_offset)
{
	if(!isdefined(n_dot_range))
	{
		n_dot_range = 0.67;
	}
	if(!isdefined(do_trace))
	{
		do_trace = 0;
	}
	/#
		Assert(isdefined(ent_or_org), "Dev Block strings are not supported");
	#/
	if(IsVec(ent_or_org))
	{
	}
	else
	{
	}
	v_point = ent_or_org.origin;
	if(IsVec(v_offset))
	{
		v_point = v_point + v_offset;
	}
	b_can_see = 0;
	b_use_tag_eye = 0;
	if(isPlayer(self) || isai(self))
	{
		b_use_tag_eye = 1;
	}
	n_dot = self math::get_dot_direction(v_point, 0, 1, "forward", b_use_tag_eye);
	if(n_dot > n_dot_range)
	{
		if(do_trace)
		{
			v_eye = self get_eye();
			b_can_see = SightTracePassed(v_eye, v_point, 0, ent_or_org);
		}
		else
		{
			b_can_see = 1;
		}
	}
	return b_can_see;
}

/*
	Name: get_eye
	Namespace: util
	Checksum: 0x3747916F
	Offset: 0x3FB0
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function get_eye()
{
	if(isPlayer(self))
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
	pos = self GetEye();
	return pos;
}

/*
	Name: is_ads
	Namespace: util
	Checksum: 0xAC1840F3
	Offset: 0x4080
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function is_ads()
{
	return self PlayerAds() > 0.5;
}

/*
	Name: spawn_model
	Namespace: util
	Checksum: 0x99F64631
	Offset: 0x40B0
	Size: 0xEB
	Parameters: 5
	Flags: None
*/
function spawn_model(model_name, origin, angles, n_spawnflags, b_throttle)
{
	if(!isdefined(n_spawnflags))
	{
		n_spawnflags = 0;
	}
	if(!isdefined(b_throttle))
	{
		b_throttle = 0;
	}
	if(b_throttle)
	{
		spawner::global_spawn_throttle(1);
	}
	if(!isdefined(origin))
	{
		origin = (0, 0, 0);
	}
	model = spawn("script_model", origin, n_spawnflags);
	model SetModel(model_name);
	if(isdefined(angles))
	{
		model.angles = angles;
	}
	return model;
}

/*
	Name: spawn_anim_model
	Namespace: util
	Checksum: 0xD250EA5E
	Offset: 0x41A8
	Size: 0xA3
	Parameters: 5
	Flags: None
*/
function spawn_anim_model(model_name, origin, angles, n_spawnflags, b_throttle)
{
	if(!isdefined(n_spawnflags))
	{
		n_spawnflags = 0;
	}
	model = spawn_model(model_name, origin, angles, n_spawnflags, b_throttle);
	model useanimtree(-1);
	model.animTree = "generic";
	return model;
}

/*
	Name: spawn_anim_player_model
	Namespace: util
	Checksum: 0xD032C41D
	Offset: 0x4258
	Size: 0x9B
	Parameters: 4
	Flags: None
*/
function spawn_anim_player_model(model_name, origin, angles, n_spawnflags)
{
	if(!isdefined(n_spawnflags))
	{
		n_spawnflags = 0;
	}
	model = spawn_model(model_name, origin, angles, n_spawnflags);
	model useanimtree(-1);
	model.animTree = "all_player";
	return model;
}

/*
	Name: waittill_player_looking_at
	Namespace: util
	Checksum: 0xA20D3AD6
	Offset: 0x4300
	Size: 0xC3
	Parameters: 4
	Flags: None
*/
function waittill_player_looking_at(origin, arc_angle_degrees, do_trace, e_ignore)
{
	if(!isdefined(arc_angle_degrees))
	{
		arc_angle_degrees = 90;
	}
	self endon("death");
	arc_angle_degrees = AbsAngleClamp360(arc_angle_degrees);
	dot = cos(arc_angle_degrees * 0.5);
	while(!is_player_looking_at(origin, dot, do_trace, e_ignore))
	{
		wait(0.05);
	}
}

/*
	Name: waittill_player_not_looking_at
	Namespace: util
	Checksum: 0x465DC933
	Offset: 0x43D0
	Size: 0x53
	Parameters: 3
	Flags: None
*/
function waittill_player_not_looking_at(origin, dot, do_trace)
{
	self endon("death");
	while(is_player_looking_at(origin, dot, do_trace))
	{
		wait(0.05);
	}
}

/*
	Name: is_player_looking_at
	Namespace: util
	Checksum: 0x5C5791E6
	Offset: 0x4430
	Size: 0x15F
	Parameters: 4
	Flags: None
*/
function is_player_looking_at(origin, dot, do_trace, ignore_ent)
{
	/#
		Assert(isPlayer(self), "Dev Block strings are not supported");
	#/
	if(!isdefined(dot))
	{
		dot = 0.7;
	}
	if(!isdefined(do_trace))
	{
		do_trace = 1;
	}
	eye = self get_eye();
	delta_vec = VectorNormalize(origin - eye);
	view_vec = AnglesToForward(self getPlayerAngles());
	new_dot = VectorDot(delta_vec, view_vec);
	if(new_dot >= dot)
	{
		if(do_trace)
		{
			return BulletTracePassed(origin, eye, 0, ignore_ent);
		}
		else
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: wait_endon
	Namespace: util
	Checksum: 0x2D839133
	Offset: 0x4598
	Size: 0x73
	Parameters: 5
	Flags: None
*/
function wait_endon(waitTime, endOnString, endonString2, endonString3, endonString4)
{
	self endon(endOnString);
	if(isdefined(endonString2))
	{
		self endon(endonString2);
	}
	if(isdefined(endonString3))
	{
		self endon(endonString3);
	}
	if(isdefined(endonString4))
	{
		self endon(endonString4);
	}
	wait(waitTime);
	return 1;
}

/*
	Name: WaitTillEndOnThreaded
	Namespace: util
	Checksum: 0xD1E55D02
	Offset: 0x4618
	Size: 0x85
	Parameters: 5
	Flags: None
*/
function WaitTillEndOnThreaded(waitCondition, callback, endCondition1, endCondition2, endCondition3)
{
	if(isdefined(endCondition1))
	{
		self endon(endCondition1);
	}
	if(isdefined(endCondition2))
	{
		self endon(endCondition2);
	}
	if(isdefined(endCondition3))
	{
		self endon(endCondition3);
	}
	self waittill(waitCondition);
	if(isdefined(callback))
	{
		[[callback]](waitCondition);
	}
}

/*
	Name: new_timer
	Namespace: util
	Checksum: 0xABE50925
	Offset: 0x46A8
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
	Checksum: 0x844FF1F2
	Offset: 0x4700
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
	Checksum: 0xE6971794
	Offset: 0x4728
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
	Checksum: 0x4DE86BE0
	Offset: 0x4748
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
	Checksum: 0xEF79D6F7
	Offset: 0x47A8
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
	Checksum: 0x320C693A
	Offset: 0x4808
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
	Checksum: 0x5B9BD5C2
	Offset: 0x4828
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
	Name: is_primary_damage
	Namespace: util
	Checksum: 0x7CB18FB0
	Offset: 0x48A0
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function is_primary_damage(meansOfDeath)
{
	if(meansOfDeath == "MOD_RIFLE_BULLET" || meansOfDeath == "MOD_PISTOL_BULLET")
	{
		return 1;
	}
	return 0;
}

/*
	Name: delete_on_death
	Namespace: util
	Checksum: 0x7F2C84A4
	Offset: 0x48E0
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function delete_on_death(ent)
{
	ent endon("death");
	self waittill("death");
	if(isdefined(ent))
	{
		ent delete();
	}
}

/*
	Name: delete_on_death_or_notify
	Namespace: util
	Checksum: 0x25FA6D63
	Offset: 0x4930
	Size: 0xAB
	Parameters: 3
	Flags: None
*/
function delete_on_death_or_notify(e_to_delete, str_notify, str_clientfield)
{
	if(!isdefined(str_clientfield))
	{
		str_clientfield = undefined;
	}
	e_to_delete endon("death");
	self waittill_either("death", str_notify);
	if(isdefined(e_to_delete))
	{
		if(isdefined(str_clientfield))
		{
			e_to_delete clientfield::set(str_clientfield, 0);
			wait(0.1);
		}
		e_to_delete delete();
	}
}

/*
	Name: wait_till_not_touching
	Namespace: util
	Checksum: 0xA2896E
	Offset: 0x49E8
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
	e_to_check endon("death");
	e_to_touch endon("death");
	while(e_to_check istouching(e_to_touch))
	{
		wait(0.05);
	}
}

/*
	Name: any_player_is_touching
	Namespace: util
	Checksum: 0xC4A4D302
	Offset: 0x4A98
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function any_player_is_touching(ent, str_team)
{
	foreach(player in GetPlayers(str_team))
	{
		if(isalive(player) && player istouching(ent))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: waittill_notify_or_timeout
	Namespace: util
	Checksum: 0x6399CB0
	Offset: 0x4B78
	Size: 0x25
	Parameters: 2
	Flags: None
*/
function waittill_notify_or_timeout(msg, timer)
{
	self endon(msg);
	wait(timer);
	return 1;
}

/*
	Name: set_console_status
	Namespace: util
	Checksum: 0xE182DCD9
	Offset: 0x4BA8
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function set_console_status()
{
	if(!isdefined(level.console))
	{
		level.console = GetDvarString("consoleGame") == "true";
	}
	else
	{
		Assert(level.console == GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported", "Dev Block strings are not supported");
	}
	/#
	#/
	if(!isdefined(level.Consolexenon))
	{
		level.xenon = GetDvarString("xenonGame") == "true";
	}
	else
	{
		Assert(level.xenon == GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported", "Dev Block strings are not supported");
	}
	/#
	#/
}

/*
	Name: waittill_asset_loaded
	Namespace: util
	Checksum: 0xA37347C5
	Offset: 0x4CB8
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function waittill_asset_loaded(str_type, str_name)
{
}

/*
	Name: script_wait
	Namespace: util
	Checksum: 0x4E2E00B3
	Offset: 0x4CD8
	Size: 0x18F
	Parameters: 1
	Flags: None
*/
function script_wait(called_from_spawner)
{
	if(!isdefined(called_from_spawner))
	{
		called_from_spawner = 0;
	}
	coop_scalar = 1;
	if(called_from_spawner)
	{
		players = GetPlayers();
		if(players.size == 2)
		{
			coop_scalar = 0.7;
		}
		else if(players.size == 3)
		{
			coop_scalar = 0.4;
		}
		else if(players.size == 4)
		{
			coop_scalar = 0.1;
		}
	}
	startTime = GetTime();
	if(isdefined(self.script_wait))
	{
		wait(self.script_wait * coop_scalar);
		if(isdefined(self.script_wait_add))
		{
			self.script_wait = self.script_wait + self.script_wait_add;
		}
	}
	else if(isdefined(self.script_wait_min) && isdefined(self.script_wait_max))
	{
		wait(RandomFloatRange(self.script_wait_min, self.script_wait_max) * coop_scalar);
		if(isdefined(self.script_wait_add))
		{
			self.script_wait_min = self.script_wait_min + self.script_wait_add;
			self.script_wait_max = self.script_wait_max + self.script_wait_add;
		}
	}
	return GetTime() - startTime;
}

/*
	Name: is_killstreaks_enabled
	Namespace: util
	Checksum: 0xDEFCF40D
	Offset: 0x4E70
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function is_killstreaks_enabled()
{
	return isdefined(level.killstreaksenabled) && level.killstreaksenabled;
}

/*
	Name: is_flashbanged
	Namespace: util
	Checksum: 0xE8FC524
	Offset: 0x4E90
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function is_flashbanged()
{
	return isdefined(self.flashEndTime) && GetTime() < self.flashEndTime;
}

/*
	Name: magic_bullet_shield
	Namespace: util
	Checksum: 0xCCE9549
	Offset: 0x4EB8
	Size: 0x10F
	Parameters: 1
	Flags: None
*/
function magic_bullet_shield(ent)
{
	if(!isdefined(ent))
	{
		ent = self;
	}
	ent.allowdeath = 0;
	ent.magic_bullet_shield = 1;
	/#
		ent notify("_stop_magic_bullet_shield_debug");
		level thread debug_magic_bullet_shield_death(ent);
	#/
	/#
		Assert(isalive(ent), "Dev Block strings are not supported");
	#/
	if(isai(ent))
	{
		if(IsActor(ent))
		{
			ent BloodImpact("hero");
		}
		ent.attackerAccuracy = 0.1;
	}
}

/*
	Name: debug_magic_bullet_shield_death
	Namespace: util
	Checksum: 0x41717B7
	Offset: 0x4FD0
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function debug_magic_bullet_shield_death(guy)
{
	targetname = "none";
	if(isdefined(guy.targetname))
	{
		targetname = guy.targetname;
	}
	guy endon("stop_magic_bullet_shield");
	guy endon("_stop_magic_bullet_shield_debug");
	guy waittill("death");
	/#
		Assert(!isdefined(guy), "Dev Block strings are not supported" + targetname);
	#/
}

/*
	Name: spawn_player_clone
	Namespace: util
	Checksum: 0xD6051E10
	Offset: 0x5078
	Size: 0x257
	Parameters: 2
	Flags: None
*/
function spawn_player_clone(player, animName)
{
	playerClone = spawn("script_model", player.origin);
	playerClone.angles = player.angles;
	bodyModel = player GetCharacterBodyModel();
	playerClone SetModel(bodyModel);
	Headmodel = player GetCharacterHeadModel();
	if(isdefined(Headmodel))
	{
		playerClone Attach(Headmodel, "");
	}
	helmetModel = player GetCharacterHelmetModel();
	if(isdefined(helmetModel))
	{
		playerClone Attach(helmetModel, "");
	}
	bodyRenderOptions = player GetCharacterBodyRenderOptions();
	playerClone SetBodyRenderOptions(bodyRenderOptions, bodyRenderOptions, bodyRenderOptions);
	playerClone useanimtree(-1);
	if(isdefined(animName))
	{
		playerClone AnimScripted("clone_anim", playerClone.origin, playerClone.angles, animName);
	}
	playerClone.health = 100;
	playerClone SetOwner(player);
	playerClone.team = player.team;
	playerClone solid();
	return playerClone;
}

/*
	Name: stop_magic_bullet_shield
	Namespace: util
	Checksum: 0xBAD221CD
	Offset: 0x52D8
	Size: 0xAF
	Parameters: 1
	Flags: None
*/
function stop_magic_bullet_shield(ent)
{
	if(!isdefined(ent))
	{
		ent = self;
	}
	ent.allowdeath = 1;
	ent.magic_bullet_shield = undefined;
	if(isai(ent))
	{
		if(IsActor(ent))
		{
			ent BloodImpact("normal");
		}
		ent.attackerAccuracy = 1;
	}
	ent notify("stop_magic_bullet_shield");
}

/*
	Name: is_one_round
	Namespace: util
	Checksum: 0x34CA433B
	Offset: 0x5390
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function is_one_round()
{
	if(level.roundLimit == 1)
	{
		return 1;
	}
	return 0;
}

/*
	Name: is_first_round
	Namespace: util
	Checksum: 0x8E80E42E
	Offset: 0x53B8
	Size: 0x2D
	Parameters: 0
	Flags: None
*/
function is_first_round()
{
	if(level.roundLimit > 1 && game["roundsplayed"] == 0)
	{
		return 1;
	}
	return 0;
}

/*
	Name: is_lastround
	Namespace: util
	Checksum: 0xDFBF5345
	Offset: 0x53F0
	Size: 0x39
	Parameters: 0
	Flags: None
*/
function is_lastround()
{
	if(level.roundLimit > 1 && game["roundsplayed"] >= level.roundLimit - 1)
	{
		return 1;
	}
	return 0;
}

/*
	Name: get_rounds_won
	Namespace: util
	Checksum: 0xB264467B
	Offset: 0x5438
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function get_rounds_won(team)
{
	return game["roundswon"][team];
}

/*
	Name: get_other_teams_rounds_won
	Namespace: util
	Checksum: 0x249207D
	Offset: 0x5460
	Size: 0xBD
	Parameters: 1
	Flags: None
*/
function get_other_teams_rounds_won(skip_team)
{
	roundsWon = 0;
	foreach(team in level.teams)
	{
		if(team == skip_team)
		{
			continue;
		}
		roundsWon = roundsWon + game["roundswon"][team];
	}
	return roundsWon;
}

/*
	Name: get_rounds_played
	Namespace: util
	Checksum: 0x236717CB
	Offset: 0x5528
	Size: 0xD
	Parameters: 0
	Flags: None
*/
function get_rounds_played()
{
	return game["roundsplayed"];
}

/*
	Name: is_round_based
	Namespace: util
	Checksum: 0x50501C2B
	Offset: 0x5540
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function is_round_based()
{
	if(level.roundLimit != 1 && level.roundWinLimit != 1)
	{
		return 1;
	}
	return 0;
}

/*
	Name: within_fov
	Namespace: util
	Checksum: 0xCBC349DB
	Offset: 0x5578
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
	Name: button_held_think
	Namespace: util
	Checksum: 0x45995387
	Offset: 0x5628
	Size: 0x11B
	Parameters: 1
	Flags: None
*/
function button_held_think(which_button)
{
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
		wait(0.05);
	}
}

/*
	Name: use_button_held
	Namespace: util
	Checksum: 0x92383585
	Offset: 0x5750
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function use_button_held()
{
	init_button_wrappers();
	if(!isdefined(self._use_button_think_threaded))
	{
		self thread button_held_think(0);
		self._use_button_think_threaded = 1;
	}
	return self._holding_button[0];
}

/*
	Name: stance_button_held
	Namespace: util
	Checksum: 0xEBEBE79A
	Offset: 0x57A8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function stance_button_held()
{
	init_button_wrappers();
	if(!isdefined(self._stance_button_think_threaded))
	{
		self thread button_held_think(1);
		self._stance_button_think_threaded = 1;
	}
	return self._holding_button[1];
}

/*
	Name: ads_button_held
	Namespace: util
	Checksum: 0x2CBE4896
	Offset: 0x5808
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function ads_button_held()
{
	init_button_wrappers();
	if(!isdefined(self._ads_button_think_threaded))
	{
		self thread button_held_think(2);
		self._ads_button_think_threaded = 1;
	}
	return self._holding_button[2];
}

/*
	Name: attack_button_held
	Namespace: util
	Checksum: 0x7E75347A
	Offset: 0x5868
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function attack_button_held()
{
	init_button_wrappers();
	if(!isdefined(self._attack_button_think_threaded))
	{
		self thread button_held_think(3);
		self._attack_button_think_threaded = 1;
	}
	return self._holding_button[3];
}

/*
	Name: button_right_held
	Namespace: util
	Checksum: 0xD497489F
	Offset: 0x58C8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function button_right_held()
{
	init_button_wrappers();
	if(!isdefined(self._dpad_right_button_think_threaded))
	{
		self thread button_held_think(6);
		self._dpad_right_button_think_threaded = 1;
	}
	return self._holding_button[6];
}

/*
	Name: waittill_use_button_pressed
	Namespace: util
	Checksum: 0x9A819CD3
	Offset: 0x5928
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function waittill_use_button_pressed()
{
	while(!self useButtonPressed())
	{
		wait(0.05);
	}
}

/*
	Name: waittill_use_button_held
	Namespace: util
	Checksum: 0x4C45126D
	Offset: 0x5960
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function waittill_use_button_held()
{
	while(!self use_button_held())
	{
		wait(0.05);
	}
}

/*
	Name: waittill_stance_button_pressed
	Namespace: util
	Checksum: 0x408D80DC
	Offset: 0x5998
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function waittill_stance_button_pressed()
{
	while(!self StanceButtonPressed())
	{
		wait(0.05);
	}
}

/*
	Name: waittill_stance_button_held
	Namespace: util
	Checksum: 0xBD1FEFCD
	Offset: 0x59D0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function waittill_stance_button_held()
{
	while(!self stance_button_held())
	{
		wait(0.05);
	}
}

/*
	Name: waittill_attack_button_pressed
	Namespace: util
	Checksum: 0xFB49759E
	Offset: 0x5A08
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function waittill_attack_button_pressed()
{
	while(!self AttackButtonPressed())
	{
		wait(0.05);
	}
}

/*
	Name: waittill_ads_button_pressed
	Namespace: util
	Checksum: 0x99111C7B
	Offset: 0x5A40
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function waittill_ads_button_pressed()
{
	while(!self AdsButtonPressed())
	{
		wait(0.05);
	}
}

/*
	Name: waittill_vehicle_move_up_button_pressed
	Namespace: util
	Checksum: 0xFDC442A1
	Offset: 0x5A78
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function waittill_vehicle_move_up_button_pressed()
{
	while(!self VehicleMoveUpButtonPressed())
	{
		wait(0.05);
	}
}

/*
	Name: init_button_wrappers
	Namespace: util
	Checksum: 0x3B07C602
	Offset: 0x5AB0
	Size: 0xE1
	Parameters: 0
	Flags: None
*/
function init_button_wrappers()
{
	if(!isdefined(level._button_funcs))
	{
		level._button_funcs[0] = &useButtonPressed;
		level._button_funcs[2] = &AdsButtonPressed;
		level._button_funcs[3] = &AttackButtonPressed;
		level._button_funcs[1] = &StanceButtonPressed;
		level._button_funcs[6] = &ActionSlotFourButtonPressed;
		/#
			level._button_funcs[4] = &function_5298bc32;
			level._button_funcs[5] = &function_95f33d4f;
		#/
	}
}

/*
	Name: function_d286c26d
	Namespace: util
	Checksum: 0x9770C448
	Offset: 0x5BA0
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
	Checksum: 0x193B944
	Offset: 0x5C08
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
	Checksum: 0x209F1AC9
	Offset: 0x5C70
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
	Checksum: 0xDA85DA42
	Offset: 0x5CC0
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
	Checksum: 0x29ECBE16
	Offset: 0x5CF8
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
	Checksum: 0xA37ED3DF
	Offset: 0x5D48
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

/*
	Name: freeze_player_controls
	Namespace: util
	Checksum: 0x1B2CC398
	Offset: 0x5D80
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function freeze_player_controls(b_frozen)
{
	if(!isdefined(b_frozen))
	{
		b_frozen = 1;
	}
	if(isdefined(level.hostMigrationTimer))
	{
		b_frozen = 1;
	}
	if(b_frozen || !level.gameEnded)
	{
		self FreezeControls(b_frozen);
	}
}

/*
	Name: is_bot
	Namespace: util
	Checksum: 0xC029F559
	Offset: 0x5DF0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function is_bot()
{
	return isPlayer(self) && isdefined(self.pers["isBot"]) && self.pers["isBot"] != 0;
}

/*
	Name: isHacked
	Namespace: util
	Checksum: 0xDD357881
	Offset: 0x5E48
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function isHacked()
{
	return isdefined(self.hacked) && self.hacked;
}

/*
	Name: getLastWeapon
	Namespace: util
	Checksum: 0x9B3AF3B6
	Offset: 0x5E68
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function getLastWeapon()
{
	last_weapon = undefined;
	if(isdefined(self.lastNonKillstreakWeapon) && self HasWeapon(self.lastNonKillstreakWeapon))
	{
		last_weapon = self.lastNonKillstreakWeapon;
	}
	else if(isdefined(self.lastdroppableweapon) && self HasWeapon(self.lastdroppableweapon))
	{
		last_weapon = self.lastdroppableweapon;
	}
	return last_weapon;
}

/*
	Name: IsEnemyPlayer
	Namespace: util
	Checksum: 0x484D35A
	Offset: 0x5F00
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function IsEnemyPlayer(player)
{
	/#
		Assert(isdefined(player));
	#/
	if(!isPlayer(player))
	{
		return 0;
	}
	if(level.teambased)
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
	Name: WaitTillSlowProcessAllowed
	Namespace: util
	Checksum: 0x101DABE2
	Offset: 0x5F98
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function WaitTillSlowProcessAllowed()
{
	while(level.lastSlowProcessFrame == GetTime())
	{
		wait(0.05);
	}
	level.lastSlowProcessFrame = GetTime();
}

/*
	Name: get_start_time
	Namespace: util
	Checksum: 0x8DD2BB7B
	Offset: 0x5FD0
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function get_start_time()
{
	return GetMicrosecondsRaw();
}

/*
	Name: note_elapsed_time
	Namespace: util
	Checksum: 0xBDD83C1A
	Offset: 0x5FF0
	Size: 0xEB
	Parameters: 2
	Flags: None
*/
function note_elapsed_time(start_time, label)
{
	if(!isdefined(label))
	{
		label = "unknown";
	}
	/#
		elapsed_time = get_elapsed_time(start_time, GetMicrosecondsRaw());
		if(!isdefined(start_time))
		{
			return;
		}
		elapsed_time = elapsed_time * 0.001;
		if(!level.orbis)
		{
			elapsed_time = Int(elapsed_time);
		}
		msg = label + "Dev Block strings are not supported" + elapsed_time + "Dev Block strings are not supported";
		iprintln(msg);
	#/
}

/*
	Name: get_elapsed_time
	Namespace: util
	Checksum: 0x80050702
	Offset: 0x60E8
	Size: 0x81
	Parameters: 2
	Flags: None
*/
function get_elapsed_time(start_time, end_time)
{
	if(!isdefined(end_time))
	{
		end_time = GetMicrosecondsRaw();
	}
	if(!isdefined(start_time))
	{
		return undefined;
	}
	elapsed_time = end_time - start_time;
	if(elapsed_time < 0)
	{
		elapsed_time = elapsed_time + -2147483648;
	}
	return elapsed_time;
}

/*
	Name: mayApplyScreenEffect
	Namespace: util
	Checksum: 0x3C7D4AE5
	Offset: 0x6178
	Size: 0x4D
	Parameters: 0
	Flags: None
*/
function mayApplyScreenEffect()
{
	/#
		Assert(isdefined(self));
	#/
	/#
		Assert(isPlayer(self));
	#/
	return !isdefined(self.viewlockedentity);
}

/*
	Name: waitTillNotMoving
	Namespace: util
	Checksum: 0xA8CBF491
	Offset: 0x61D0
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function waitTillNotMoving()
{
	if(self isHacked())
	{
		wait(0.05);
		return;
	}
	if(self.classname == "grenade")
	{
		self waittill("stationary");
		break;
	}
	prevOrigin = self.origin;
	while(1)
	{
		wait(0.15);
		if(self.origin == prevOrigin)
		{
			break;
		}
		prevOrigin = self.origin;
	}
}

/*
	Name: waitTillRollingOrNotMoving
	Namespace: util
	Checksum: 0xA55D7523
	Offset: 0x6270
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function waitTillRollingOrNotMoving()
{
	if(self isHacked())
	{
		wait(0.05);
		return "stationary";
	}
	moveState = self waittill_any_return("stationary", "rolling");
	return moveState;
}

/*
	Name: getStatsTableName
	Namespace: util
	Checksum: 0x4150021D
	Offset: 0x62E0
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
	Name: getWeaponClass
	Namespace: util
	Checksum: 0x970D5E25
	Offset: 0x6338
	Size: 0xFD
	Parameters: 1
	Flags: None
*/
function getWeaponClass(weapon)
{
	if(weapon == level.weaponNone)
	{
		return undefined;
	}
	if(!weapon.isValid)
	{
		return undefined;
	}
	if(!isdefined(level.weaponClassArray))
	{
		level.weaponClassArray = [];
	}
	if(isdefined(level.weaponClassArray[weapon]))
	{
		return level.weaponClassArray[weapon];
	}
	baseWeaponParam = [[level.get_base_weapon_param]](weapon);
	baseWeaponIndex = GetBaseWeaponItemIndex(baseWeaponParam);
	weaponClass = tableLookup(getStatsTableName(), 0, baseWeaponIndex, 2);
	level.weaponClassArray[weapon] = weaponClass;
	return weaponClass;
}

/*
	Name: isUsingRemote
	Namespace: util
	Checksum: 0xEF6CA5D9
	Offset: 0x6440
	Size: 0xB
	Parameters: 0
	Flags: None
*/
function isUsingRemote()
{
	return isdefined(self.usingRemote);
}

/*
	Name: deleteAfterTime
	Namespace: util
	Checksum: 0x2281F4B6
	Offset: 0x6458
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function deleteAfterTime(time)
{
	/#
		Assert(isdefined(self));
	#/
	/#
		Assert(isdefined(time));
	#/
	/#
		Assert(time >= 0.05);
	#/
	self thread deleteAfterTimeThread(time);
}

/*
	Name: deleteAfterTimeThread
	Namespace: util
	Checksum: 0x6EF2BEFA
	Offset: 0x64E8
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function deleteAfterTimeThread(time)
{
	self endon("death");
	wait(time);
	self delete();
}

/*
	Name: waitForTime
	Namespace: util
	Checksum: 0xCB4A837C
	Offset: 0x6528
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function waitForTime(time)
{
	if(!isdefined(time))
	{
		time = 0;
	}
	if(time > 0)
	{
		wait(time);
	}
}

/*
	Name: waitForTimeAndNetworkFrame
	Namespace: util
	Checksum: 0xABB97701
	Offset: 0x6570
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function waitForTimeAndNetworkFrame(time)
{
	if(!isdefined(time))
	{
		time = 0;
	}
	start_time_ms = GetTime();
	wait_network_frame();
	elapsed_time = GetTime() - start_time_ms * 0.001;
	remaining_time = time - elapsed_time;
	if(remaining_time > 0)
	{
		wait(remaining_time);
	}
}

/*
	Name: deleteAfterTimeAndNetworkFrame
	Namespace: util
	Checksum: 0x4800DD1C
	Offset: 0x6608
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function deleteAfterTimeAndNetworkFrame(time)
{
	/#
		Assert(isdefined(self));
	#/
	waitForTimeAndNetworkFrame(time);
	self delete();
}

/*
	Name: drawcylinder
	Namespace: util
	Checksum: 0xB3C1DEEF
	Offset: 0x6668
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function drawcylinder(pos, rad, height, duration, stop_notify, color, alpha)
{
	/#
		if(!isdefined(duration))
		{
			duration = 0;
		}
		level thread drawcylinder_think(pos, rad, height, duration, stop_notify, color, alpha);
	#/
}

/*
	Name: drawcylinder_think
	Namespace: util
	Checksum: 0xB48D5914
	Offset: 0x66F8
	Size: 0x313
	Parameters: 7
	Flags: None
*/
function drawcylinder_think(pos, rad, height, seconds, stop_notify, color, alpha)
{
	/#
		if(isdefined(stop_notify))
		{
			level endon(stop_notify);
		}
		stop_time = GetTime() + seconds * 1000;
		currad = rad;
		curheight = height;
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		if(!isdefined(alpha))
		{
			alpha = 1;
		}
		while(seconds > 0 && stop_time <= GetTime())
		{
			return;
			for(r = 0; r < 20; r++)
			{
				theta = r / 20 * 360;
				theta2 = r + 1 / 20 * 360;
				line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta2) * currad, sin(theta2) * currad, 0), color, alpha);
				line(pos + (cos(theta) * currad, sin(theta) * currad, curheight), pos + (cos(theta2) * currad, sin(theta2) * currad, curheight), color, alpha);
				line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta) * currad, sin(theta) * currad, curheight), color, alpha);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: get_team_alive_players_s
	Namespace: util
	Checksum: 0xA59401C9
	Offset: 0x6A18
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function get_team_alive_players_s(teamName)
{
	teamPlayers_s = spawn_array_struct();
	if(isdefined(teamName) && isdefined(level.aliveplayers) && isdefined(level.aliveplayers[teamName]))
	{
		for(i = 0; i < level.aliveplayers[teamName].size; i++)
		{
			teamPlayers_s.a[teamPlayers_s.a.size] = level.aliveplayers[teamName][i];
		}
	}
	return teamPlayers_s;
}

/*
	Name: get_other_teams_alive_players_s
	Namespace: util
	Checksum: 0xB1DCC58F
	Offset: 0x6AE0
	Size: 0x161
	Parameters: 1
	Flags: None
*/
function get_other_teams_alive_players_s(teamNameToIgnore)
{
	teamPlayers_s = spawn_array_struct();
	if(isdefined(teamNameToIgnore) && isdefined(level.aliveplayers))
	{
		foreach(team in level.teams)
		{
			if(team == teamNameToIgnore)
			{
				break;
			}
			foreach(player in level.aliveplayers[team])
			{
				teamPlayers_s.a[teamPlayers_s.a.size] = player;
			}
		}
	}
	return teamPlayers_s;
}

/*
	Name: get_all_alive_players_s
	Namespace: util
	Checksum: 0x101F37F6
	Offset: 0x6C50
	Size: 0xF9
	Parameters: 0
	Flags: None
*/
function get_all_alive_players_s()
{
	allPlayers_s = spawn_array_struct();
	if(isdefined(level.aliveplayers))
	{
		keys = getArrayKeys(level.aliveplayers);
		for(i = 0; i < keys.size; i++)
		{
			team = keys[i];
			for(j = 0; j < level.aliveplayers[team].size; j++)
			{
				allPlayers_s.a[allPlayers_s.a.size] = level.aliveplayers[team][j];
			}
		}
	}
	return allPlayers_s;
}

/*
	Name: spawn_array_struct
	Namespace: util
	Checksum: 0xB1A1B181
	Offset: 0x6D58
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function spawn_array_struct()
{
	s = spawnstruct();
	s.a = [];
	return s;
}

/*
	Name: getHostPlayer
	Namespace: util
	Checksum: 0x5FDE2E9
	Offset: 0x6D98
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function getHostPlayer()
{
	players = GetPlayers();
	for(index = 0; index < players.size; index++)
	{
		if(players[index] IsHost())
		{
			return players[index];
		}
	}
}

/*
	Name: getHostPlayerForBots
	Namespace: util
	Checksum: 0xA1DC7F68
	Offset: 0x6E18
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function getHostPlayerForBots()
{
	players = GetPlayers();
	for(index = 0; index < players.size; index++)
	{
		if(players[index] IsHostForBots())
		{
			return players[index];
		}
	}
}

/*
	Name: get_array_of_closest
	Namespace: util
	Checksum: 0x9CA2CFD
	Offset: 0x6E98
	Size: 0x327
	Parameters: 5
	Flags: None
*/
function get_array_of_closest(org, Array, excluders, max, maxdist)
{
	if(!isdefined(max))
	{
		max = Array.size;
	}
	if(!isdefined(excluders))
	{
		excluders = [];
	}
	maxdists2rd = undefined;
	if(isdefined(maxdist))
	{
		maxdists2rd = maxdist * maxdist;
	}
	dist = [];
	index = [];
	for(i = 0; i < Array.size; i++)
	{
		if(!isdefined(Array[i]))
		{
			continue;
		}
		if(IsInArray(excluders, Array[i]))
		{
			continue;
		}
		if(IsVec(Array[i]))
		{
			length = DistanceSquared(org, Array[i]);
		}
		else
		{
			length = DistanceSquared(org, Array[i].origin);
		}
		if(isdefined(maxdists2rd) && maxdists2rd < length)
		{
			continue;
		}
		dist[dist.size] = length;
		index[index.size] = i;
	}
	for(;;)
	{
		change = 0;
		for(i = 0; i < dist.size - 1; i++)
		{
			if(dist[i] <= dist[i + 1])
			{
				continue;
			}
			change = 1;
			temp = dist[i];
			dist[i] = dist[i + 1];
			dist[i + 1] = temp;
			temp = index[i];
			index[i] = index[i + 1];
			index[i + 1] = temp;
		}
		if(!change)
		{
		}
	}
	else
	{
	}
	newArray = [];
	if(max > dist.size)
	{
		max = dist.size;
	}
	for(i = 0; i < max; i++)
	{
		newArray[i] = Array[index[i]];
	}
	return newArray;
}

/*
	Name: set_lighting_state
	Namespace: util
	Checksum: 0x449D6D98
	Offset: 0x71C8
	Size: 0x143
	Parameters: 1
	Flags: None
*/
function set_lighting_state(n_state)
{
	if(isdefined(n_state))
	{
		self.lighting_state = n_state;
	}
	else
	{
		self.lighting_state = level.lighting_state;
	}
	if(isdefined(self.lighting_state))
	{
		if(self == level)
		{
			if(isdefined(level.activePlayers))
			{
				foreach(player in level.activePlayers)
				{
					player set_lighting_state(level.lighting_state);
				}
			}
		}
		else if(isPlayer(self))
		{
			self SetLightingState(self.lighting_state);
		}
		else
		{
			ASSERTMSG("Dev Block strings are not supported");
		}
		/#
		#/
	}
}

/*
	Name: set_sun_shadow_split_distance
	Namespace: util
	Checksum: 0x7CC5229D
	Offset: 0x7318
	Size: 0x143
	Parameters: 1
	Flags: None
*/
function set_sun_shadow_split_distance(f_distance)
{
	if(isdefined(f_distance))
	{
		self.sun_shadow_split_distance = f_distance;
	}
	else
	{
		self.sun_shadow_split_distance = level.sun_shadow_split_distance;
	}
	if(isdefined(self.sun_shadow_split_distance))
	{
		if(self == level)
		{
			if(isdefined(level.activePlayers))
			{
				foreach(player in level.activePlayers)
				{
					player set_sun_shadow_split_distance(level.sun_shadow_split_distance);
				}
			}
		}
		else if(isPlayer(self))
		{
			self SetSunShadowSplitDistance(self.sun_shadow_split_distance);
		}
		else
		{
			ASSERTMSG("Dev Block strings are not supported");
		}
		/#
		#/
	}
}

/*
	Name: auto_delete
	Namespace: util
	Checksum: 0xF9B150A4
	Offset: 0x7468
	Size: 0x49B
	Parameters: 4
	Flags: None
*/
function auto_delete(n_mode, n_min_time_alive, n_dist_horizontal, n_dist_vertical)
{
	if(!isdefined(n_mode))
	{
		n_mode = 1;
	}
	if(!isdefined(n_min_time_alive))
	{
		n_min_time_alive = 0;
	}
	if(!isdefined(n_dist_horizontal))
	{
		n_dist_horizontal = 0;
	}
	if(!isdefined(n_dist_vertical))
	{
		n_dist_vertical = 0;
	}
	self endon("death");
	self notify("__auto_delete__");
	self endon("__auto_delete__");
	level flag::wait_till("all_players_spawned");
	if(isdefined(level.heroes) && IsInArray(level.heroes, self))
	{
		return;
	}
	if(n_mode & 16 || n_mode == 1 || n_mode == 8)
	{
		n_mode = n_mode | 2;
		n_mode = n_mode | 4;
	}
	n_think_time = 1;
	n_tests_to_do = 2;
	n_dot_check = 0;
	if(n_mode & 16)
	{
		n_think_time = 0.2;
		n_tests_to_do = 1;
		n_dot_check = 0.4;
	}
	n_test_count = 0;
	while(1)
	{
		do
		{
			wait(RandomFloatRange(n_think_time - n_think_time / 3, n_think_time + n_think_time / 3));
		}
		while(!(isdefined(self.birthtime) && GetTime() - self.birthtime / 1000 < n_min_time_alive));
		n_tests_passed = 0;
		foreach(player in level.players)
		{
			if(n_dist_horizontal && Distance2DSquared(self.origin, player.origin) < n_dist_horizontal)
			{
				continue;
			}
			if(n_dist_vertical && Abs(self.origin[2] - player.origin[2]) < n_dist_vertical)
			{
				continue;
			}
			v_eye = player GetEye();
			b_behind = 0;
			if(n_mode & 2)
			{
				v_facing = AnglesToForward(player getPlayerAngles());
				v_to_ent = VectorNormalize(self.origin - v_eye);
				n_dot = VectorDot(v_facing, v_to_ent);
				if(n_dot < n_dot_check)
				{
					b_behind = 1;
					if(!n_mode & 1)
					{
						n_tests_passed++;
						continue;
					}
				}
			}
			if(n_mode & 4)
			{
				if(!self SightConeTrace(v_eye, player))
				{
					if(b_behind || !n_mode & 1)
					{
						n_tests_passed++;
					}
				}
			}
		}
		if(n_tests_passed == level.players.size)
		{
			n_test_count++;
			if(n_test_count < n_tests_to_do)
			{
				continue;
			}
			self notify("_disable_reinforcement");
			self delete();
		}
		else
		{
			n_test_count = 0;
		}
	}
}

/*
	Name: query_ents
	Namespace: util
	Checksum: 0x20A20F9B
	Offset: 0x7910
	Size: 0x3F1
	Parameters: 5
	Flags: None
*/
function query_ents(a_kvps_match, b_match_all, a_kvps_ingnore, b_ignore_spawners, b_match_substrings)
{
	if(!isdefined(b_match_all))
	{
		b_match_all = 1;
	}
	if(!isdefined(b_ignore_spawners))
	{
		b_ignore_spawners = 0;
	}
	if(!isdefined(b_match_substrings))
	{
		b_match_substrings = 0;
	}
	a_ret = [];
	if(b_match_substrings)
	{
		a_all_ents = GetEntArray();
		b_first = 1;
		foreach(V in a_kvps_match)
		{
			a_ents = _query_ents_by_substring_helper(a_all_ents, V, K, b_ignore_spawners);
			if(b_first)
			{
				a_ret = a_ents;
				b_first = 0;
				continue;
			}
			if(b_match_all)
			{
				a_ret = ArrayIntersect(a_ret, a_ents);
				continue;
			}
			a_ret = ArrayCombine(a_ret, a_ents, 0, 0);
		}
		if(isdefined(a_kvps_ingnore))
		{
			foreach(V in a_kvps_ingnore)
			{
				a_ents = _query_ents_by_substring_helper(a_all_ents, V, K, b_ignore_spawners);
				a_ret = Array::exclude(a_ret, a_ents);
			}
		}
		break;
	}
	b_first = 1;
	foreach(V in a_kvps_match)
	{
		a_ents = GetEntArray(V, K);
		if(b_first)
		{
			a_ret = a_ents;
			b_first = 0;
			continue;
		}
		if(b_match_all)
		{
			a_ret = ArrayIntersect(a_ret, a_ents);
			continue;
		}
		a_ret = ArrayCombine(a_ret, a_ents, 0, 0);
	}
	if(isdefined(a_kvps_ingnore))
	{
		foreach(V in a_kvps_ingnore)
		{
			a_ents = GetEntArray(V, K);
			a_ret = Array::exclude(a_ret, a_ents);
		}
	}
	return a_ret;
}

/*
	Name: _query_ents_by_substring_helper
	Namespace: util
	Checksum: 0xA1A1C160
	Offset: 0x7D10
	Size: 0x60B
	Parameters: 4
	Flags: None
*/
function _query_ents_by_substring_helper(a_ents, str_value, str_key, b_ignore_spawners)
{
	if(!isdefined(str_key))
	{
		str_key = "targetname";
	}
	if(!isdefined(b_ignore_spawners))
	{
		b_ignore_spawners = 0;
	}
	a_ret = [];
	foreach(ent in a_ents)
	{
		if(b_ignore_spawners && IsSpawner(ent))
		{
			break;
		}
		switch(str_key)
		{
			case "targetname":
			{
				if(IsString(ent.targetname) && IsSubStr(ent.targetname, str_value))
				{
					if(!isdefined(a_ret))
					{
						a_ret = [];
					}
					else if(!IsArray(a_ret))
					{
						a_ret = Array(a_ret);
					}
					a_ret[a_ret.size] = ent;
				}
				break;
			}
			case "script_noteworthy":
			{
				if(IsString(ent.script_noteworthy) && IsSubStr(ent.script_noteworthy, str_value))
				{
					if(!isdefined(a_ret))
					{
						a_ret = [];
					}
					else if(!IsArray(a_ret))
					{
						a_ret = Array(a_ret);
					}
					a_ret[a_ret.size] = ent;
				}
				break;
			}
			case "classname":
			{
				if(IsString(ent.classname) && IsSubStr(ent.classname, str_value))
				{
					if(!isdefined(a_ret))
					{
						a_ret = [];
					}
					else if(!IsArray(a_ret))
					{
						a_ret = Array(a_ret);
					}
					a_ret[a_ret.size] = ent;
				}
				break;
			}
			case "vehicletype":
			{
				if(IsString(ent.vehicleType) && IsSubStr(ent.vehicleType, str_value))
				{
					if(!isdefined(a_ret))
					{
						a_ret = [];
					}
					else if(!IsArray(a_ret))
					{
						a_ret = Array(a_ret);
					}
					a_ret[a_ret.size] = ent;
				}
				break;
			}
			case "script_string":
			{
				if(IsString(ent.script_string) && IsSubStr(ent.script_string, str_value))
				{
					if(!isdefined(a_ret))
					{
						a_ret = [];
					}
					else if(!IsArray(a_ret))
					{
						a_ret = Array(a_ret);
					}
					a_ret[a_ret.size] = ent;
				}
				break;
			}
			case "script_color_axis":
			{
				if(IsString(ent.script_color_axis) && IsSubStr(ent.script_color_axis, str_value))
				{
					if(!isdefined(a_ret))
					{
						a_ret = [];
					}
					else if(!IsArray(a_ret))
					{
						a_ret = Array(a_ret);
					}
					a_ret[a_ret.size] = ent;
				}
				break;
			}
			case "script_color_allies":
			{
				if(IsString(ent.script_color_axis) && IsSubStr(ent.script_color_axis, str_value))
				{
					if(!isdefined(a_ret))
					{
						a_ret = [];
					}
					else if(!IsArray(a_ret))
					{
						a_ret = Array(a_ret);
					}
					a_ret[a_ret.size] = ent;
				}
				break;
			}
			case default:
			{
				/#
					Assert("Dev Block strings are not supported" + str_key + "Dev Block strings are not supported");
				#/
			}
		}
	}
	return a_ret;
}

/*
	Name: get_weapon_by_name
	Namespace: util
	Checksum: 0xA847374C
	Offset: 0x8328
	Size: 0x34D
	Parameters: 1
	Flags: None
*/
function get_weapon_by_name(weapon_name)
{
	split = StrTok(weapon_name, "+");
	switch(split.size)
	{
		case 1:
		case default:
		{
			weapon = GetWeapon(split[0]);
			break;
		}
		case 2:
		{
			weapon = GetWeapon(split[0], split[1]);
			break;
		}
		case 3:
		{
			weapon = GetWeapon(split[0], split[1], split[2]);
			break;
		}
		case 4:
		{
			weapon = GetWeapon(split[0], split[1], split[2], split[3]);
			break;
		}
		case 5:
		{
			weapon = GetWeapon(split[0], split[1], split[2], split[3], split[4]);
			break;
		}
		case 6:
		{
			weapon = GetWeapon(split[0], split[1], split[2], split[3], split[4], split[5]);
			break;
		}
		case 7:
		{
			weapon = GetWeapon(split[0], split[1], split[2], split[3], split[4], split[5], split[6]);
			break;
		}
		case 8:
		{
			weapon = GetWeapon(split[0], split[1], split[2], split[3], split[4], split[5], split[6], split[7]);
			break;
		}
		case 9:
		{
			weapon = GetWeapon(split[0], split[1], split[2], split[3], split[4], split[5], split[6], split[7], split[8]);
			break;
		}
	}
	return weapon;
}

/*
	Name: is_female
	Namespace: util
	Checksum: 0xC171AFC9
	Offset: 0x8680
	Size: 0x71
	Parameters: 0
	Flags: None
*/
function is_female()
{
	gender = self GetPlayerGenderType(CurrentSessionMode());
	b_female = 0;
	if(isdefined(gender) && gender == "female")
	{
		b_female = 1;
	}
	return b_female;
}

/*
	Name: PositionQuery_PointArray
	Namespace: util
	Checksum: 0x2020085F
	Offset: 0x8700
	Size: 0x195
	Parameters: 6
	Flags: None
*/
function PositionQuery_PointArray(origin, minSearchRadius, maxSearchRadius, halfHeight, innerSpacing, reachableBy_Ent)
{
	if(isdefined(reachableBy_Ent))
	{
		queryResult = PositionQuery_Source_Navigation(origin, minSearchRadius, maxSearchRadius, halfHeight, innerSpacing, reachableBy_Ent);
	}
	else
	{
		queryResult = PositionQuery_Source_Navigation(origin, minSearchRadius, maxSearchRadius, halfHeight, innerSpacing);
	}
	pointarray = [];
	foreach(pointStruct in queryResult.data)
	{
		if(!isdefined(pointarray))
		{
			pointarray = [];
		}
		else if(!IsArray(pointarray))
		{
			pointarray = Array(pointarray);
		}
		pointarray[pointarray.size] = pointStruct.origin;
	}
	return pointarray;
}

/*
	Name: totalPlayerCount
	Namespace: util
	Checksum: 0xAEADF2DC
	Offset: 0x88A0
	Size: 0xA1
	Parameters: 0
	Flags: None
*/
function totalPlayerCount()
{
	count = 0;
	foreach(team in level.teams)
	{
		count = count + level.playerCount[team];
	}
	return count;
}

/*
	Name: isRankEnabled
	Namespace: util
	Checksum: 0x92CFF701
	Offset: 0x8950
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function isRankEnabled()
{
	return isdefined(level.rankEnabled) && level.rankEnabled;
}

/*
	Name: isOneRound
	Namespace: util
	Checksum: 0xE0CBB521
	Offset: 0x8970
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function isOneRound()
{
	if(level.roundLimit == 1)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isFirstRound
	Namespace: util
	Checksum: 0x9CABC86C
	Offset: 0x8998
	Size: 0x2D
	Parameters: 0
	Flags: None
*/
function isFirstRound()
{
	if(level.roundLimit > 1 && game["roundsplayed"] == 0)
	{
		return 1;
	}
	return 0;
}

/*
	Name: isLastRound
	Namespace: util
	Checksum: 0x36F62146
	Offset: 0x89D0
	Size: 0x39
	Parameters: 0
	Flags: None
*/
function isLastRound()
{
	if(level.roundLimit > 1 && game["roundsplayed"] >= level.roundLimit - 1)
	{
		return 1;
	}
	return 0;
}

/*
	Name: wasLastRound
	Namespace: util
	Checksum: 0x347AB8C3
	Offset: 0x8A18
	Size: 0xAD
	Parameters: 0
	Flags: None
*/
function wasLastRound()
{
	if(level.forcedEnd)
	{
		return 1;
	}
	if(isdefined(level.shouldPlayOvertimeRound))
	{
		if([[level.shouldPlayOvertimeRound]]())
		{
			level.nextRoundIsOvertime = 1;
			return 0;
		}
		else if(isdefined(game["overtime_round"]))
		{
			return 1;
		}
	}
	if(hitRoundLimit() || hitScoreLimit() || hitRoundWinLimit())
	{
		return 1;
	}
	return 0;
}

/*
	Name: hitRoundLimit
	Namespace: util
	Checksum: 0xB23BDF08
	Offset: 0x8AD0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function hitRoundLimit()
{
	if(level.roundLimit <= 0)
	{
		return 0;
	}
	return getRoundsPlayed() >= level.roundLimit;
}

/*
	Name: anyTeamHitRoundWinLimit
	Namespace: util
	Checksum: 0xFAA9D468
	Offset: 0x8B10
	Size: 0x9D
	Parameters: 0
	Flags: None
*/
function anyTeamHitRoundWinLimit()
{
	foreach(team in level.teams)
	{
		if(getRoundsWon(team) >= level.roundWinLimit)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: anyTeamHitRoundLimitWithDraws
	Namespace: util
	Checksum: 0x91D81FA0
	Offset: 0x8BB8
	Size: 0xC9
	Parameters: 0
	Flags: None
*/
function anyTeamHitRoundLimitWithDraws()
{
	tie_wins = game["roundswon"]["tie"];
	foreach(team in level.teams)
	{
		if(getRoundsWon(team) + tie_wins >= level.roundWinLimit)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: getRoundWinLimitWinningTeam
	Namespace: util
	Checksum: 0x89FE85
	Offset: 0x8C90
	Size: 0x11B
	Parameters: 0
	Flags: None
*/
function getRoundWinLimitWinningTeam()
{
	max_wins = 0;
	winning_team = undefined;
	foreach(team in level.teams)
	{
		wins = getRoundsWon(team);
		if(!isdefined(winning_team))
		{
			max_wins = wins;
			winning_team = team;
			continue;
		}
		if(wins == max_wins)
		{
			winning_team = "tie";
			continue;
		}
		if(wins > max_wins)
		{
			max_wins = wins;
			winning_team = team;
		}
	}
	return winning_team;
}

/*
	Name: hitRoundWinLimit
	Namespace: util
	Checksum: 0xE5EB4B51
	Offset: 0x8DB8
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function hitRoundWinLimit()
{
	if(!isdefined(level.roundWinLimit) || level.roundWinLimit <= 0)
	{
		return 0;
	}
	if(anyTeamHitRoundWinLimit())
	{
		return 1;
	}
	if(anyTeamHitRoundLimitWithDraws())
	{
		if(getRoundWinLimitWinningTeam() != "tie")
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: any_team_hit_score_limit
	Namespace: util
	Checksum: 0x96BB2848
	Offset: 0x8E40
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function any_team_hit_score_limit()
{
	foreach(team in level.teams)
	{
		if(game["teamScores"][team] >= level.scoreLimit)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: hitScoreLimit
	Namespace: util
	Checksum: 0xB8BFDB7B
	Offset: 0x8EE8
	Size: 0xCD
	Parameters: 0
	Flags: None
*/
function hitScoreLimit()
{
	if(level.scoreRoundWinBased)
	{
		return 0;
	}
	if(level.scoreLimit <= 0)
	{
		return 0;
	}
	if(level.teambased)
	{
		if(any_team_hit_score_limit())
		{
			return 1;
		}
		break;
	}
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(isdefined(player.pointstowin) && player.pointstowin >= level.scoreLimit)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: get_current_round_score_limit
	Namespace: util
	Checksum: 0x873BDE19
	Offset: 0x8FC0
	Size: 0x1D
	Parameters: 0
	Flags: None
*/
function get_current_round_score_limit()
{
	return level.roundScoreLimit * game["roundsplayed"] + 1;
}

/*
	Name: any_team_hit_round_score_limit
	Namespace: util
	Checksum: 0xCA854C44
	Offset: 0x8FE8
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function any_team_hit_round_score_limit()
{
	round_score_limit = get_current_round_score_limit();
	foreach(team in level.teams)
	{
		if(game["teamScores"][team] >= round_score_limit)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: hitRoundScoreLimit
	Namespace: util
	Checksum: 0x83A31C5A
	Offset: 0x90A8
	Size: 0xD9
	Parameters: 0
	Flags: None
*/
function hitRoundScoreLimit()
{
	if(level.roundScoreLimit <= 0)
	{
		return 0;
	}
	if(level.teambased)
	{
		if(any_team_hit_round_score_limit())
		{
			return 1;
		}
		break;
	}
	roundScoreLimit = get_current_round_score_limit();
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(isdefined(player.pointstowin) && player.pointstowin >= roundScoreLimit)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: getRoundsWon
	Namespace: util
	Checksum: 0xBD2E2CF8
	Offset: 0x9190
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function getRoundsWon(team)
{
	return game["roundswon"][team];
}

/*
	Name: getOtherTeamsRoundsWon
	Namespace: util
	Checksum: 0xF2DBA2CF
	Offset: 0x91B8
	Size: 0xBD
	Parameters: 1
	Flags: None
*/
function getOtherTeamsRoundsWon(skip_team)
{
	roundsWon = 0;
	foreach(team in level.teams)
	{
		if(team == skip_team)
		{
			continue;
		}
		roundsWon = roundsWon + game["roundswon"][team];
	}
	return roundsWon;
}

/*
	Name: getRoundsPlayed
	Namespace: util
	Checksum: 0xE6FF0484
	Offset: 0x9280
	Size: 0xD
	Parameters: 0
	Flags: None
*/
function getRoundsPlayed()
{
	return game["roundsplayed"];
}

/*
	Name: isRoundBased
	Namespace: util
	Checksum: 0xA2F4ADDD
	Offset: 0x9298
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function isRoundBased()
{
	if(level.roundLimit != 1 && level.roundWinLimit != 1)
	{
		return 1;
	}
	return 0;
}

/*
	Name: GetCurrentGameMode
	Namespace: util
	Checksum: 0x1FABB68
	Offset: 0x92D0
	Size: 0x2D
	Parameters: 0
	Flags: None
*/
function GetCurrentGameMode()
{
	if(GameModeIsMode(6))
	{
		return "leaguematch";
	}
	return "publicmatch";
}

/*
	Name: ground_position
	Namespace: util
	Checksum: 0xCBDE9A9A
	Offset: 0x9308
	Size: 0x13B
	Parameters: 6
	Flags: None
*/
function ground_position(v_start, n_max_dist, n_ground_offset, e_ignore, b_ignore_water, b_ignore_glass)
{
	if(!isdefined(n_max_dist))
	{
		n_max_dist = 5000;
	}
	if(!isdefined(n_ground_offset))
	{
		n_ground_offset = 0;
	}
	if(!isdefined(b_ignore_water))
	{
		b_ignore_water = 0;
	}
	if(!isdefined(b_ignore_glass))
	{
		b_ignore_glass = 0;
	}
	v_trace_start = v_start + (0, 0, 5);
	v_trace_end = v_trace_start + (0, 0, n_max_dist + 5 * -1);
	a_trace = GroundTrace(v_trace_start, v_trace_end, 0, e_ignore, b_ignore_water, b_ignore_glass);
	if(a_trace["surfacetype"] != "none")
	{
		return a_trace["position"] + (0, 0, n_ground_offset);
	}
	else
	{
		return v_start;
	}
}

/*
	Name: delayed_notify
	Namespace: util
	Checksum: 0x4884D367
	Offset: 0x9450
	Size: 0x2B
	Parameters: 2
	Flags: None
*/
function delayed_notify(str_notify, f_delay_seconds)
{
	wait(f_delay_seconds);
	if(isdefined(self))
	{
		self notify(str_notify);
	}
}

/*
	Name: delayed_delete
	Namespace: util
	Checksum: 0x181F7AE1
	Offset: 0x9488
	Size: 0x73
	Parameters: 2
	Flags: None
*/
function delayed_delete(str_notify, f_delay_seconds)
{
	/#
		Assert(IsEntity(self));
	#/
	wait(f_delay_seconds);
	if(isdefined(self) && IsEntity(self))
	{
		self delete();
	}
}

/*
	Name: do_chyron_text
	Namespace: util
	Checksum: 0x964EDC9
	Offset: 0x9508
	Size: 0x1AB
	Parameters: 11
	Flags: None
*/
function do_chyron_text(str_1_full, str_1_short, str_2_full, str_2_short, str_3_full, str_3_short, str_4_full, str_4_short, str_5_full, str_5_short, n_duration)
{
	if(!isdefined(str_5_full))
	{
		str_5_full = "";
	}
	if(!isdefined(str_5_short))
	{
		str_5_short = "";
	}
	level.chyron_text_active = 1;
	level flagsys::set("chyron_active");
	if(!isdefined(n_duration))
	{
		n_duration = 12;
	}
	foreach(player in level.players)
	{
		player thread player_set_chyron_menu(str_1_full, str_1_short, str_2_full, str_2_short, str_3_full, str_3_short, str_4_full, str_4_short, str_5_full, str_5_short, n_duration);
	}
	level waittill("chyron_menu_closed");
	level.chyron_text_active = undefined;
	level flagsys::clear("chyron_active");
}

/*
	Name: player_set_chyron_menu
	Namespace: util
	Checksum: 0xCFFBE204
	Offset: 0x96C0
	Size: 0x383
	Parameters: 11
	Flags: None
*/
function player_set_chyron_menu(str_1_full, str_1_short, str_2_full, str_2_short, str_3_full, str_3_short, str_4_full, str_4_short, str_5_full, str_5_short, n_duration)
{
	if(!isdefined(str_5_full))
	{
		str_5_full = "";
	}
	if(!isdefined(str_5_short))
	{
		str_5_short = "";
	}
	self endon("disconnect");
	/#
		Assert(isdefined(n_duration), "Dev Block strings are not supported");
	#/
	menuHandle = self OpenLUIMenu("CPChyron");
	self SetLUIMenuData(menuHandle, "line1full", str_1_full);
	self SetLUIMenuData(menuHandle, "line1short", str_1_short);
	self SetLUIMenuData(menuHandle, "line2full", str_2_full);
	self SetLUIMenuData(menuHandle, "line2short", str_2_short);
	mapname = GetDvarString("mapname");
	hideLine3Full = 0;
	if(mapname == "cp_mi_eth_prologue" && SessionModeIsCampaignZombiesGame())
	{
		hideLine3Full = 1;
	}
	if(!hideLine3Full)
	{
		self SetLUIMenuData(menuHandle, "line3full", str_3_full);
		self SetLUIMenuData(menuHandle, "line3short", str_3_short);
	}
	if(!SessionModeIsCampaignZombiesGame())
	{
		self SetLUIMenuData(menuHandle, "line4full", str_4_full);
		self SetLUIMenuData(menuHandle, "line4short", str_4_short);
		self SetLUIMenuData(menuHandle, "line5full", str_5_full);
		self SetLUIMenuData(menuHandle, "line5short", str_5_short);
	}
	waittillframeend;
	self notify("chyron_menu_open");
	level notify("chyron_menu_open");
	do
	{
		self waittill("menuresponse", menu, response);
	}
	while(!(menu != "CPChyron" || response != "closed"));
	self notify("chyron_menu_closed");
	level notify("chyron_menu_closed");
	wait(5);
	self CloseLUIMenu(menuHandle);
}

/*
	Name: get_next_safehouse
	Namespace: util
	Checksum: 0x4A8AD5A0
	Offset: 0x9A50
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
	Checksum: 0xF7ED560F
	Offset: 0x9AC8
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function is_safehouse()
{
	mapname = ToLower(GetDvarString("mapname"));
	if(mapname == "cp_sh_cairo" || mapname == "cp_sh_mobile" || mapname == "cp_sh_singapore")
	{
		return 1;
	}
	return 0;
}

/*
	Name: is_new_cp_map
	Namespace: util
	Checksum: 0x43F45CC6
	Offset: 0x9B40
	Size: 0xB9
	Parameters: 0
	Flags: None
*/
function is_new_cp_map()
{
	mapname = ToLower(GetDvarString("mapname"));
	switch(mapname)
	{
		case "cp_mi_cairo_aquifer":
		case "cp_mi_cairo_infection":
		case "cp_mi_cairo_lotus":
		case "cp_mi_cairo_ramses":
		case "cp_mi_eth_prologue":
		case "cp_mi_sing_biodomes":
		case "cp_mi_sing_blackstation":
		case "cp_mi_sing_chinatown":
		case "cp_mi_sing_sgen":
		case "cp_mi_sing_vengeance":
		case "cp_mi_zurich_coalescene":
		case "cp_mi_zurich_newworld":
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
	Name: function_316771cc
	Namespace: util
	Checksum: 0x7032DF76
	Offset: 0x9C08
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function function_316771cc(cmd)
{
	/#
		if(!isdefined(level.var_dee0e693))
		{
			level thread function_82af066f();
		}
		if(isdefined(level.var_dee0e693))
		{
			Array::push(level.var_dee0e693, cmd, 0);
		}
	#/
}

/*
	Name: function_82af066f
	Namespace: util
	Checksum: 0x68553086
	Offset: 0x9C70
	Size: 0xA7
	Parameters: 0
	Flags: None
*/
function function_82af066f()
{
	/#
		self notify("hash_82af066f");
		self endon("hash_82af066f");
		if(!isdefined(level.var_dee0e693))
		{
			level.var_dee0e693 = [];
		}
		while(1)
		{
			wait(0.05);
			if(level.var_dee0e693.size == 0)
			{
				level.var_dee0e693 = undefined;
				return;
			}
			cmd = Array::pop_front(level.var_dee0e693, 0);
			AddDebugCommand(cmd);
		}
	#/
}

/*
	Name: player_lock_control
	Namespace: util
	Checksum: 0x18BD3C9
	Offset: 0x9D20
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function player_lock_control()
{
	if(self == level)
	{
		foreach(e_player in level.activePlayers)
		{
			e_player freeze_player_controls(1);
			e_player scene::set_igc_active(1);
			level notify("disable_cybercom", e_player, 1);
			e_player show_hud(0);
		}
	}
	else
	{
		self freeze_player_controls(1);
		self scene::set_igc_active(1);
		level notify("disable_cybercom", self, 1);
		self show_hud(0);
	}
}

/*
	Name: player_unlock_control
	Namespace: util
	Checksum: 0xBD91552D
	Offset: 0x9E68
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function player_unlock_control()
{
	if(self == level)
	{
		foreach(e_player in level.activePlayers)
		{
			e_player freeze_player_controls(0);
			e_player scene::set_igc_active(0);
			level notify("enable_cybercom", e_player);
			e_player show_hud(1);
		}
	}
	else
	{
		self freeze_player_controls(0);
		self scene::set_igc_active(0);
		level notify("enable_cybercom", e_player);
		self show_hud(1);
	}
}

/*
	Name: show_hud
	Namespace: util
	Checksum: 0xA5EE6DD2
	Offset: 0x9FB0
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function show_hud(b_show)
{
	if(b_show)
	{
		if(!(isdefined(self.fullscreen_black_active) && self.fullscreen_black_active))
		{
			if(!self flagsys::get("playing_movie_hide_hud"))
			{
				if(!scene::is_igc_active())
				{
					if(!(isdefined(self.dont_show_hud) && self.dont_show_hud))
					{
						self setClientUIVisibilityFlag("hud_visible", 1);
					}
				}
			}
		}
	}
	else
	{
		self setClientUIVisibilityFlag("hud_visible", 0);
	}
}

/*
	Name: array_copy_if_array
	Namespace: util
	Checksum: 0x7751E1CB
	Offset: 0xA070
	Size: 0x41
	Parameters: 1
	Flags: None
*/
function array_copy_if_array(any_var)
{
	if(IsArray(any_var))
	{
	}
	else
	{
	}
	return any_var;
}

/*
	Name: is_item_purchased
	Namespace: util
	Checksum: 0xD5F568CC
	Offset: 0xA0C0
	Size: 0x69
	Parameters: 1
	Flags: None
*/
function is_item_purchased(ref)
{
	itemIndex = GetItemIndexFromRef(ref);
	if(itemIndex < 0 || itemIndex >= 256)
	{
	}
	else
	{
	}
	return self isItemPurchased(itemIndex);
}

/*
	Name: has_purchased_perk_equipped
	Namespace: util
	Checksum: 0xAB3A1C31
	Offset: 0xA138
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function has_purchased_perk_equipped(ref)
{
	return self hasPerk(ref) && self is_item_purchased(ref);
}

/*
	Name: has_purchased_perk_equipped_with_specific_stat
	Namespace: util
	Checksum: 0x7AB246F9
	Offset: 0xA180
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function has_purchased_perk_equipped_with_specific_stat(single_perk_ref, stats_table_ref)
{
	if(isPlayer(self))
	{
		return self hasPerk(single_perk_ref) && self is_item_purchased(stats_table_ref);
	}
	else
	{
		return 0;
	}
}

/*
	Name: has_flak_jacket_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0xBDE4192F
	Offset: 0xA1F0
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function has_flak_jacket_perk_purchased_and_equipped()
{
	return has_purchased_perk_equipped("specialty_flakjacket");
}

/*
	Name: has_blind_eye_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0x59932EFC
	Offset: 0xA218
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function has_blind_eye_perk_purchased_and_equipped()
{
	return self has_purchased_perk_equipped_with_specific_stat("specialty_nottargetedbyairsupport", "specialty_nottargetedbyairsupport|specialty_nokillstreakreticle");
}

/*
	Name: has_ghost_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0x9D68080B
	Offset: 0xA250
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function has_ghost_perk_purchased_and_equipped()
{
	return has_purchased_perk_equipped("specialty_gpsjammer");
}

/*
	Name: has_tactical_mask_purchased_and_equipped
	Namespace: util
	Checksum: 0x151A8403
	Offset: 0xA278
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function has_tactical_mask_purchased_and_equipped()
{
	return self has_purchased_perk_equipped_with_specific_stat("specialty_stunprotection", "specialty_stunprotection|specialty_flashprotection|specialty_proximityprotection");
}

/*
	Name: has_hacker_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0x15F70C5E
	Offset: 0xA2B0
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function has_hacker_perk_purchased_and_equipped()
{
	return self has_purchased_perk_equipped_with_specific_stat("specialty_showenemyequipment", "specialty_showenemyequipment|specialty_showscorestreakicons|specialty_showenemyvehicles");
}

/*
	Name: has_cold_blooded_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0x6515334D
	Offset: 0xA2E8
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function has_cold_blooded_perk_purchased_and_equipped()
{
	return self has_purchased_perk_equipped_with_specific_stat("specialty_nottargetedbyaitank", "specialty_nottargetedbyaitank|specialty_nottargetedbyraps|specialty_nottargetedbysentry|specialty_nottargetedbyrobot|specialty_immunenvthermal");
}

/*
	Name: has_hard_wired_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0xF0B0A969
	Offset: 0xA320
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function has_hard_wired_perk_purchased_and_equipped()
{
	return self has_purchased_perk_equipped_with_specific_stat("specialty_immunecounteruav", "specialty_immunecounteruav|specialty_immuneemp|specialty_immunetriggerc4|specialty_immunetriggershock|specialty_immunetriggerbetty|specialty_sixthsensejammer|specialty_trackerjammer|specialty_immunesmoke");
}

/*
	Name: has_gung_ho_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0x778970B4
	Offset: 0xA358
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function has_gung_ho_perk_purchased_and_equipped()
{
	return self has_purchased_perk_equipped_with_specific_stat("specialty_sprintfire", "specialty_sprintfire|specialty_sprintgrenadelethal|specialty_sprintgrenadetactical|specialty_sprintequipment");
}

/*
	Name: has_fast_hands_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0x91D6D0CF
	Offset: 0xA390
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function has_fast_hands_perk_purchased_and_equipped()
{
	return self has_purchased_perk_equipped_with_specific_stat("specialty_fastweaponswitch", "specialty_fastweaponswitch|specialty_sprintrecovery|specialty_sprintfirerecovery");
}

/*
	Name: has_scavenger_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0x687F0449
	Offset: 0xA3C8
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function has_scavenger_perk_purchased_and_equipped()
{
	return has_purchased_perk_equipped("specialty_scavenger");
}

/*
	Name: has_jetquiet_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0xC70CA53
	Offset: 0xA3F0
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function has_jetquiet_perk_purchased_and_equipped()
{
	return self has_purchased_perk_equipped_with_specific_stat("specialty_jetquiet", "specialty_jetnoradar|specialty_jetquiet");
}

/*
	Name: has_awareness_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0xE75E7F2A
	Offset: 0xA428
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function has_awareness_perk_purchased_and_equipped()
{
	return has_purchased_perk_equipped("specialty_loudenemies");
}

/*
	Name: has_ninja_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0xCAFBC055
	Offset: 0xA450
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function has_ninja_perk_purchased_and_equipped()
{
	return has_purchased_perk_equipped("specialty_quieter");
}

/*
	Name: has_toughness_perk_purchased_and_equipped
	Namespace: util
	Checksum: 0x5B7CA752
	Offset: 0xA478
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function has_toughness_perk_purchased_and_equipped()
{
	return has_purchased_perk_equipped("specialty_bulletflinch");
}

/*
	Name: str_strip_lh
	Namespace: util
	Checksum: 0x74DB5FF
	Offset: 0xA4A0
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function str_strip_lh(STR)
{
	if(StrEndsWith(STR, "_lh"))
	{
		return GetSubStr(STR, 0, STR.size - 3);
	}
	return STR;
}

/*
	Name: trackWallRunningDistance
	Namespace: util
	Checksum: 0x332F1B1E
	Offset: 0xA500
	Size: 0x167
	Parameters: 0
	Flags: None
*/
function trackWallRunningDistance()
{
	self endon("disconnect");
	self.movementTracking.wallRunning = spawnstruct();
	self.movementTracking.wallRunning.Distance = 0;
	self.movementTracking.wallRunning.count = 0;
	self.movementTracking.wallRunning.time = 0;
	while(1)
	{
		self waittill("wallrun_begin");
		startPos = self.origin;
		startTime = GetTime();
		self.movementTracking.wallRunning.count++;
		self waittill("wallrun_end");
		self.movementTracking.wallRunning.Distance = self.movementTracking.wallRunning.Distance + Distance(startPos, self.origin);
		self.movementTracking.wallRunning.time = self.movementTracking.wallRunning.time + GetTime() - startTime;
	}
}

/*
	Name: trackSprintDistance
	Namespace: util
	Checksum: 0xF475EED6
	Offset: 0xA670
	Size: 0x167
	Parameters: 0
	Flags: None
*/
function trackSprintDistance()
{
	self endon("disconnect");
	self.movementTracking.sprinting = spawnstruct();
	self.movementTracking.sprinting.Distance = 0;
	self.movementTracking.sprinting.count = 0;
	self.movementTracking.sprinting.time = 0;
	while(1)
	{
		self waittill("sprint_begin");
		startPos = self.origin;
		startTime = GetTime();
		self.movementTracking.sprinting.count++;
		self waittill("sprint_end");
		self.movementTracking.sprinting.Distance = self.movementTracking.sprinting.Distance + Distance(startPos, self.origin);
		self.movementTracking.sprinting.time = self.movementTracking.sprinting.time + GetTime() - startTime;
	}
}

/*
	Name: trackDoubleJumpDistance
	Namespace: util
	Checksum: 0x6157E4DE
	Offset: 0xA7E0
	Size: 0x167
	Parameters: 0
	Flags: None
*/
function trackDoubleJumpDistance()
{
	self endon("disconnect");
	self.movementTracking.doublejump = spawnstruct();
	self.movementTracking.doublejump.Distance = 0;
	self.movementTracking.doublejump.count = 0;
	self.movementTracking.doublejump.time = 0;
	while(1)
	{
		self waittill("doublejump_begin");
		startPos = self.origin;
		startTime = GetTime();
		self.movementTracking.doublejump.count++;
		self waittill("doublejump_end");
		self.movementTracking.doublejump.Distance = self.movementTracking.doublejump.Distance + Distance(startPos, self.origin);
		self.movementTracking.doublejump.time = self.movementTracking.doublejump.time + GetTime() - startTime;
	}
}

/*
	Name: GetPlaySpaceCenter
	Namespace: util
	Checksum: 0x26193B6B
	Offset: 0xA950
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function GetPlaySpaceCenter()
{
	minimapOrigins = GetEntArray("minimap_corner", "targetname");
	if(minimapOrigins.size)
	{
		return math::find_box_center(minimapOrigins[0].origin, minimapOrigins[1].origin);
	}
	return (0, 0, 0);
}

/*
	Name: GetPlaySpaceMaxWidth
	Namespace: util
	Checksum: 0x949F992B
	Offset: 0xA9C8
	Size: 0xF5
	Parameters: 0
	Flags: None
*/
function GetPlaySpaceMaxWidth()
{
	minimapOrigins = GetEntArray("minimap_corner", "targetname");
	if(minimapOrigins.size)
	{
		x = Abs(minimapOrigins[0].origin[0] - minimapOrigins[1].origin[0]);
		y = Abs(minimapOrigins[0].origin[1] - minimapOrigins[1].origin[1]);
		return max(x, y);
	}
	return 0;
}

/*
	Name: function_e2ac06bb
	Namespace: util
	Checksum: 0xE2C4A529
	Offset: 0xAAC8
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function function_e2ac06bb(var_ce7e654a, commands)
{
	AddDebugCommand("devgui_cmd "" + var_ce7e654a + "" "" + commands + ""
");
}

/*
	Name: function_181cbd1a
	Namespace: util
	Checksum: 0x842121EC
	Offset: 0xAB20
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function function_181cbd1a(var_ce7e654a)
{
	AddDebugCommand("devgui_remove "" + var_ce7e654a + ""
");
}

/*
	Name: function_a4c90358
	Namespace: util
	Checksum: 0x7737F3AF
	Offset: 0xAB60
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function function_a4c90358(counter_name, amount)
{
	if(GetDvarInt("live_enableCounters", 0))
	{
		incrementCounter(counter_name, amount);
	}
}

/*
	Name: function_ad904acd
	Namespace: util
	Checksum: 0x94A69868
	Offset: 0xABB8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_ad904acd()
{
	if(GetDvarInt("live_enableCounters", 0))
	{
		function_3a323142();
	}
}

/*
	Name: function_522d8c7d
	Namespace: util
	Checksum: 0xA47ABC26
	Offset: 0xABF8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_522d8c7d(amount)
{
	if(GetDvarInt("ui_enablePromoTracking", 0))
	{
		function_a4c90358("zmhd_thermometer", amount);
	}
}

