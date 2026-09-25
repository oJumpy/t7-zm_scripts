#namespace trigger;

/*
	Name: function_thread
	Namespace: trigger
	Checksum: 0x369EF334
	Offset: 0x78
	Size: 0xFB
	Parameters: 3
	Flags: None
*/
function function_thread(ent, on_enter_payload, on_exit_payload)
{
	ent endon("entityshutdown");
	if(ent ent_already_in(self))
	{
		return;
	}
	add_to_ent(ent, self);
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
		remove_from_ent(ent, self);
	}
}

/*
	Name: ent_already_in
	Namespace: trigger
	Checksum: 0xEAF7149E
	Offset: 0x180
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function ent_already_in(trig)
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
	Name: add_to_ent
	Namespace: trigger
	Checksum: 0x196BFB39
	Offset: 0x1F8
	Size: 0x61
	Parameters: 2
	Flags: None
*/
function add_to_ent(ent, trig)
{
	if(!isdefined(ent._triggers))
	{
		ent._triggers = [];
	}
	ent._triggers[trig GetEntityNumber()] = 1;
}

/*
	Name: remove_from_ent
	Namespace: trigger
	Checksum: 0x9138ADED
	Offset: 0x268
	Size: 0x81
	Parameters: 2
	Flags: None
*/
function remove_from_ent(ent, trig)
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
	Name: death_monitor
	Namespace: trigger
	Checksum: 0xFD01048D
	Offset: 0x2F8
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function death_monitor(ent, ender)
{
	ent waittill("death");
	self endon(ender);
	self remove_from_ent(ent);
}

