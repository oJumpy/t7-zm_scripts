#using scripts\shared\util_shared;

#namespace flagsys;

/*
	Name: set
	Namespace: flagsys
	Checksum: 0xDE220437
	Offset: 0xB0
	Size: 0x3F
	Parameters: 1
	Flags: None
*/
function set(str_flag)
{
	if(!isdefined(self.flag))
	{
		self.flag = [];
	}
	self.flag[str_flag] = 1;
	self notify(str_flag);
}

/*
	Name: set_for_time
	Namespace: flagsys
	Checksum: 0xED3F0DAD
	Offset: 0xF8
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function set_for_time(n_time, str_flag)
{
	self notify("__flag::set_for_time__" + str_flag);
	self endon("__flag::set_for_time__" + str_flag);
	set(str_flag);
	wait(n_time);
	clear(str_flag);
}

/*
	Name: clear
	Namespace: flagsys
	Checksum: 0x39BA2E23
	Offset: 0x170
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function clear(str_flag)
{
	if(isdefined(self.flag) && (isdefined(self.flag[str_flag]) && self.flag[str_flag]))
	{
		self.flag[str_flag] = undefined;
		self notify(str_flag);
	}
}

/*
	Name: set_val
	Namespace: flagsys
	Checksum: 0x350188A2
	Offset: 0x1D0
	Size: 0x73
	Parameters: 2
	Flags: None
*/
function set_val(str_flag, b_val)
{
	/#
		Assert(isdefined(b_val), "Dev Block strings are not supported");
	#/
	if(b_val)
	{
		set(str_flag);
	}
	else
	{
		clear(str_flag);
	}
}

/*
	Name: toggle
	Namespace: flagsys
	Checksum: 0x15FCFFA8
	Offset: 0x250
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function toggle(str_flag)
{
	set(!get(str_flag));
}

/*
	Name: get
	Namespace: flagsys
	Checksum: 0x1AED90CA
	Offset: 0x290
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function get(str_flag)
{
	return isdefined(self.flag) && (isdefined(self.flag[str_flag]) && self.flag[str_flag]);
}

/*
	Name: wait_till
	Namespace: flagsys
	Checksum: 0x5780F27A
	Offset: 0x2D0
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function wait_till(str_flag)
{
	self endon("death");
	while(!get(str_flag))
	{
		self waittill(str_flag);
	}
}

/*
	Name: wait_till_timeout
	Namespace: flagsys
	Checksum: 0xD50C69FD
	Offset: 0x318
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function wait_till_timeout(n_timeout, str_flag)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon("timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	wait_till(str_flag);
}

/*
	Name: wait_till_all
	Namespace: flagsys
	Checksum: 0x9A714D9E
	Offset: 0x3A8
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function wait_till_all(a_flags)
{
	self endon("death");
	for(i = 0; i < a_flags.size; i++)
	{
		str_flag = a_flags[i];
		if(!get(str_flag))
		{
			self waittill(str_flag);
			i = -1;
		}
	}
}

/*
	Name: wait_till_all_timeout
	Namespace: flagsys
	Checksum: 0x62ABA45C
	Offset: 0x438
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function wait_till_all_timeout(n_timeout, a_flags)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon("timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	wait_till_all(a_flags);
}

/*
	Name: wait_till_any
	Namespace: flagsys
	Checksum: 0xE84D6BF7
	Offset: 0x4C8
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function wait_till_any(a_flags)
{
	self endon("death");
	foreach(flag in a_flags)
	{
		if(get(flag))
		{
			return flag;
		}
	}
	util::waittill_any_array(a_flags);
}

/*
	Name: wait_till_any_timeout
	Namespace: flagsys
	Checksum: 0xC948CAE4
	Offset: 0x590
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function wait_till_any_timeout(n_timeout, a_flags)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon("timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	wait_till_any(a_flags);
}

/*
	Name: wait_till_clear
	Namespace: flagsys
	Checksum: 0x19739CED
	Offset: 0x620
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function wait_till_clear(str_flag)
{
	self endon("death");
	while(get(str_flag))
	{
		self waittill(str_flag);
	}
}

/*
	Name: wait_till_clear_timeout
	Namespace: flagsys
	Checksum: 0x3C52029B
	Offset: 0x668
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function wait_till_clear_timeout(n_timeout, str_flag)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon("timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	wait_till_clear(str_flag);
}

/*
	Name: wait_till_clear_all
	Namespace: flagsys
	Checksum: 0x59FE73A2
	Offset: 0x6F8
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function wait_till_clear_all(a_flags)
{
	self endon("death");
	for(i = 0; i < a_flags.size; i++)
	{
		str_flag = a_flags[i];
		if(get(str_flag))
		{
			self waittill(str_flag);
			i = -1;
		}
	}
}

/*
	Name: wait_till_clear_all_timeout
	Namespace: flagsys
	Checksum: 0x638DCD60
	Offset: 0x788
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function wait_till_clear_all_timeout(n_timeout, a_flags)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon("timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	wait_till_clear_all(a_flags);
}

/*
	Name: wait_till_clear_any
	Namespace: flagsys
	Checksum: 0x3858741D
	Offset: 0x818
	Size: 0xC7
	Parameters: 1
	Flags: None
*/
function wait_till_clear_any(a_flags)
{
	self endon("death");
	while(1)
	{
		foreach(flag in a_flags)
		{
			if(!get(flag))
			{
				return flag;
			}
		}
		util::waittill_any_array(a_flags);
	}
}

/*
	Name: wait_till_clear_any_timeout
	Namespace: flagsys
	Checksum: 0x8271C3F9
	Offset: 0x8E8
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function wait_till_clear_any_timeout(n_timeout, a_flags)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon("timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	wait_till_clear_any(a_flags);
}

/*
	Name: delete
	Namespace: flagsys
	Checksum: 0x82581EC9
	Offset: 0x978
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function delete(str_flag)
{
	clear(str_flag);
}

