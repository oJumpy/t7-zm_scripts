#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\zm_temple_sq;

#namespace zm_temple_sq_brock;

/*
	Name: init
	Namespace: zm_temple_sq_brock
	Checksum: 0x50D3E64C
	Offset: 0x208
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function init()
{
	level flag::init("radio_4_played");
	level._brock_naglines = [];
	level._brock_corpse_locations = [];
	level._radio_structs = struct::get_array("sq_radios", "targetname");
}

/*
	Name: delete_radio_internal
	Namespace: zm_temple_sq_brock
	Checksum: 0xB7C30401
	Offset: 0x278
	Size: 0x7D
	Parameters: 0
	Flags: None
*/
function delete_radio_internal()
{
	if(isdefined(level._active_sq_radio))
	{
		level._active_sq_radio.trigger delete();
		level._active_sq_radio stopsounds();
		util::wait_network_frame();
		level._active_sq_radio delete();
		level._active_sq_radio = undefined;
	}
}

/*
	Name: delete_radio
	Namespace: zm_temple_sq_brock
	Checksum: 0x962B93F3
	Offset: 0x300
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function delete_radio()
{
	level thread delete_radio_internal();
}

/*
	Name: trig_thread
	Namespace: zm_temple_sq_brock
	Checksum: 0x68F4C0AA
	Offset: 0x328
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function trig_thread()
{
	self endon("death");
	while(1)
	{
		self waittill("trigger");
		self.owner_ent notify("triggered");
	}
}

/*
	Name: radio_debug
	Namespace: zm_temple_sq_brock
	Checksum: 0x315FE699
	Offset: 0x370
	Size: 0x6D
	Parameters: 0
	Flags: None
*/
function radio_debug()
{
	self endon("death");
	level endon("radio_7_played");
	/#
		while(!(isdefined(level.disable_print3d_ent) && level.disable_print3d_ent))
		{
			print3d(self.origin, "Dev Block strings are not supported", (0, 255, 255), 1);
			wait(1);
		}
	#/
}

/*
	Name: radio9_override
	Namespace: zm_temple_sq_brock
	Checksum: 0xCA01E1D0
	Offset: 0x3E8
	Size: 0x303
	Parameters: 1
	Flags: None
*/
function radio9_override(struct)
{
	self notify("overridden");
	self endon("death");
	self.trigger delete();
	self ghost();
	sidequest = level._zombie_sidequests["sq"];
	if(sidequest.num_reps >= 3)
	{
		return;
	}
	level waittill("picked_up");
	level waittill("flush_done");
	self show();
	for(target = struct.target; isdefined(target);  = struct.target)
	{
		struct = struct::get(target, "targetname");
		time = struct.script_float;
		if(!isdefined(time))
		{
			time = 1;
		}
		self moveto(struct.origin, time, time / 10);
		self waittill("movedone");
	}
	self.trigger = spawn("trigger_radius_use", self.origin + VectorScale((0, 0, 1), 12), 0, 64, 72);
	self.trigger TriggerIgnoreTeam();
	self.trigger.radius = 64;
	self.trigger.height = 72;
	self.trigger setcursorhint("HINT_NOICON");
	self.trigger.owner_ent = self;
	self.trigger thread trig_thread();
	self waittill("triggered");
	snd = "vox_radio_egg_" + self.script_int - 1;
	self playsound(snd);
	self PlayLoopSound("vox_radio_egg_snapshot", 1);
	wait(self.manual_wait);
	self StopLoopSound(1);
	level flag::set("radio_9_played");
}

/*
	Name: radio7_override
	Namespace: zm_temple_sq_brock
	Checksum: 0xAF8CD1C8
	Offset: 0x6F8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function radio7_override(struct)
{
	self endon("death");
	self waittill("triggered");
	level flag::set("radio_7_played");
}

/*
	Name: radio4_override
	Namespace: zm_temple_sq_brock
	Checksum: 0x7F699553
	Offset: 0x748
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function radio4_override(struct)
{
	self endon("death");
	self waittill("triggered");
	level flag::set("radio_4_played");
}

/*
	Name: radio2_override
	Namespace: zm_temple_sq_brock
	Checksum: 0x62D263E3
	Offset: 0x798
	Size: 0x183
	Parameters: 1
	Flags: None
*/
function radio2_override(struct)
{
	self endon("death");
	self notify("overridden");
	self waittill("triggered");
	n_char_id = level._player_who_pressed_the_switch.characterindex;
	if(!isdefined(n_char_id))
	{
		n_char_id = 0;
	}
	var_bc7547cb = "a";
	switch(n_char_id)
	{
		case 0:
		{
			var_bc7547cb = "a";
			break;
		}
		case 1:
		{
			var_bc7547cb = "b";
			break;
		}
		case 2:
		{
			var_bc7547cb = "d";
			break;
		}
		case 3:
		{
			var_bc7547cb = "c";
			break;
		}
	}
	snd = "vox_radio_egg_" + self.script_int - 1 + "" + var_bc7547cb;
	self PlaySoundWithNotify(snd, "radiodone");
	self PlayLoopSound("vox_radio_egg_snapshot", 1);
	self waittill("radiodone");
	self StopLoopSound(1);
}

/*
	Name: radio_thread
	Namespace: zm_temple_sq_brock
	Checksum: 0xEBE5CDEF
	Offset: 0x928
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function radio_thread()
{
	self endon("death");
	self endon("overridden");
	self thread radio_debug();
	self waittill("triggered");
	snd = "vox_radio_egg_" + self.script_int - 1;
	self playsound(snd);
	self PlayLoopSound("vox_radio_egg_snapshot", 1);
	wait(self.manual_wait);
	self StopLoopSound(1);
}

/*
	Name: create_radio
	Namespace: zm_temple_sq_brock
	Checksum: 0x87564AF8
	Offset: 0x9E8
	Size: 0x2C7
	Parameters: 2
	Flags: None
*/
function create_radio(radio_num, thread_func)
{
	delete_radio();
	radio_struct = undefined;
	for(i = 0; i < level._radio_structs.size; i++)
	{
		if(level._radio_structs[i].script_int == radio_num)
		{
			radio_struct = level._radio_structs[i];
			break;
		}
	}
	if(!isdefined(radio_struct))
	{
		/#
			println("Dev Block strings are not supported" + radio_num);
		#/
		return;
	}
	radio = spawn("script_model", radio_struct.origin);
	radio.angles = radio_struct.angles;
	radio SetModel("p7_zm_sha_recorder_digital");
	radio.script_int = radio_struct.script_int;
	radio.script_noteworthy = radio_struct.script_noteworthy;
	radio set_manual_wait_time(radio_num);
	radio.trigger = spawn("trigger_radius_use", radio.origin + VectorScale((0, 0, 1), 12), 0, 64, 72);
	radio.trigger TriggerIgnoreTeam();
	radio.trigger.radius = 64;
	radio.trigger.height = 72;
	radio.trigger setcursorhint("HINT_NOICON");
	radio.trigger.owner_ent = radio;
	radio.trigger thread trig_thread();
	radio thread radio_thread();
	if(isdefined(thread_func))
	{
		radio thread [[thread_func]](radio_struct);
	}
	level._active_sq_radio = radio;
}

/*
	Name: set_manual_wait_time
	Namespace: zm_temple_sq_brock
	Checksum: 0xCE6D9FCC
	Offset: 0xCB8
	Size: 0x117
	Parameters: 1
	Flags: None
*/
function set_manual_wait_time(num)
{
	if(!isdefined(num))
	{
		num = 1;
	}
	waitTime = 45;
	switch(num)
	{
		case 1:
		{
			waitTime = 113;
			break;
		}
		case 2:
		{
			waitTime = 95;
			break;
		}
		case 3:
		{
			waitTime = 20;
			break;
		}
		case 4:
		{
			waitTime = 58;
			break;
		}
		case 5:
		{
			waitTime = 74;
			break;
		}
		case 6:
		{
			waitTime = 35;
			break;
		}
		case 7:
		{
			waitTime = 40;
			break;
		}
		case 8:
		{
			waitTime = 39;
			break;
		}
		case 9:
		{
			waitTime = 76;
			break;
		}
	}
	self.manual_wait = waitTime;
}

