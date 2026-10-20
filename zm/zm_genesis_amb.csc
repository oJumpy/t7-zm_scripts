#using scripts\codescripts\struct;
#using scripts\shared\music_shared;

#namespace zm_genesis_amb;

/*
	Name: main
	Namespace: zm_genesis_amb
	Checksum: 0x33D448FF
	Offset: 0xD8
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function main()
{
	thread startzmbspawnersoundloops();
}

/*
	Name: startzmbspawnersoundloops
	Namespace: zm_genesis_amb
	Checksum: 0xBA4561FA
	Offset: 0xF8
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function startzmbspawnersoundloops()
{
	loopers = struct::get_array("exterior_goal", "targetname");
	if(isdefined(loopers) && loopers.size > 0)
	{
		delay = 0;
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				println("Dev Block strings are not supported" + loopers.size + "Dev Block strings are not supported");
			}
		#/
		for(i = 0; i < loopers.size; i++)
		{
			loopers[i] thread soundLoopThink();
			delay = delay + 1;
			if(delay % 20 == 0)
			{
				wait(0.016);
			}
		}
	}
	else
	{
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			println("Dev Block strings are not supported");
		}
	}
	/#
	#/
}

/*
	Name: soundLoopThink
	Namespace: zm_genesis_amb
	Checksum: 0x72BFF574
	Offset: 0x260
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function soundLoopThink()
{
	if(!isdefined(self.origin))
	{
		return;
	}
	if(!isdefined(self.script_sound))
	{
		self.script_sound = "zmb_spawn_walla";
	}
	notifyname = "";
	/#
		Assert(isdefined(notifyname));
	#/
	if(isdefined(self.script_string))
	{
		notifyname = self.script_string;
	}
	/#
		Assert(isdefined(notifyname));
	#/
	started = 1;
	if(isdefined(self.script_int))
	{
		started = self.script_int != 0;
	}
	if(started)
	{
		soundloopemitter(self.script_sound, self.origin);
	}
	if(notifyname != "")
	{
		for(;;)
		{
			level waittill(notifyname);
			if(started)
			{
				soundstoploopemitter(self.script_sound, self.origin);
			}
			else
			{
				soundloopemitter(self.script_sound, self.origin);
			}
			started = !started;
		}
	}
}

