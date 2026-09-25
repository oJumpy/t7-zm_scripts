#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace FX;

/*
	Name: __init__sytem__
	Namespace: FX
	Checksum: 0x324888C6
	Offset: 0x1C8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("fx", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: FX
	Checksum: 0x8A558064
	Offset: 0x208
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_localclient_connect(&player_init);
}

/*
	Name: player_init
	Namespace: FX
	Checksum: 0x84565917
	Offset: 0x238
	Size: 0x257
	Parameters: 1
	Flags: None
*/
function player_init(clientNum)
{
	if(!isdefined(level.createFXent))
	{
		return;
	}
	creatingExploderArray = 0;
	if(!isdefined(level.createFXexploders))
	{
		creatingExploderArray = 1;
		level.createFXexploders = [];
	}
	for(i = 0; i < level.createFXent.size; i++)
	{
		ent = level.createFXent[i];
		if(!isdefined(level._createfxforwardandupset))
		{
			if(!isdefined(level._createfxforwardandupset))
			{
				ent set_forward_and_up_vectors();
			}
		}
		if(ent.V["type"] == "loopfx")
		{
			ent thread loop_thread(clientNum);
		}
		if(ent.V["type"] == "oneshotfx")
		{
			ent thread oneshot_thread(clientNum);
		}
		if(ent.V["type"] == "soundfx")
		{
			ent thread loop_sound(clientNum);
		}
		if(creatingExploderArray && ent.V["type"] == "exploder")
		{
			if(!isdefined(level.createFXexploders[ent.V["exploder"]]))
			{
				level.createFXexploders[ent.V["exploder"]] = [];
			}
			ent.V["exploder_id"] = exploder::getexploderid(ent);
			level.createFXexploders[ent.V["exploder"]][level.createFXexploders[ent.V["exploder"]].size] = ent;
		}
	}
	level._createfxforwardandupset = 1;
}

/*
	Name: validate
	Namespace: FX
	Checksum: 0x9D50E50D
	Offset: 0x498
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function validate(fxid, origin)
{
	/#
		if(!isdefined(level._effect[fxid]))
		{
			/#
				ASSERTMSG("Dev Block strings are not supported" + fxid + "Dev Block strings are not supported" + origin);
			#/
		}
	#/
}

/*
	Name: create_loop_sound
	Namespace: FX
	Checksum: 0xE3213726
	Offset: 0x500
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function create_loop_sound()
{
	ent = spawnstruct();
	if(!isdefined(level.createFXent))
	{
		level.createFXent = [];
	}
	level.createFXent[level.createFXent.size] = ent;
	ent.V = [];
	ent.V["type"] = "soundfx";
	ent.V["fxid"] = "No FX";
	ent.V["soundalias"] = "nil";
	ent.V["angles"] = (0, 0, 0);
	ent.V["origin"] = (0, 0, 0);
	ent.drawn = 1;
	return ent;
}

/*
	Name: create_effect
	Namespace: FX
	Checksum: 0x5933BEFF
	Offset: 0x618
	Size: 0xF3
	Parameters: 2
	Flags: None
*/
function create_effect(type, fxid)
{
	ent = spawnstruct();
	if(!isdefined(level.createFXent))
	{
		level.createFXent = [];
	}
	level.createFXent[level.createFXent.size] = ent;
	ent.V = [];
	ent.V["type"] = type;
	ent.V["fxid"] = fxid;
	ent.V["angles"] = (0, 0, 0);
	ent.V["origin"] = (0, 0, 0);
	ent.drawn = 1;
	return ent;
}

/*
	Name: create_oneshot_effect
	Namespace: FX
	Checksum: 0x34FAADD4
	Offset: 0x718
	Size: 0x55
	Parameters: 1
	Flags: None
*/
function create_oneshot_effect(fxid)
{
	ent = create_effect("oneshotfx", fxid);
	ent.V["delay"] = -15;
	return ent;
}

/*
	Name: create_loop_effect
	Namespace: FX
	Checksum: 0x15C625AC
	Offset: 0x778
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function create_loop_effect(fxid)
{
	ent = create_effect("loopfx", fxid);
	ent.V["delay"] = 0.5;
	return ent;
}

/*
	Name: set_forward_and_up_vectors
	Namespace: FX
	Checksum: 0xB2A3D3DD
	Offset: 0x7E0
	Size: 0x75
	Parameters: 0
	Flags: None
*/
function set_forward_and_up_vectors()
{
	self.V["up"] = anglesToUp(self.V["angles"]);
	self.V["forward"] = AnglesToForward(self.V["angles"]);
}

/*
	Name: oneshot_thread
	Namespace: FX
	Checksum: 0xAE8EBC44
	Offset: 0x860
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function oneshot_thread(clientNum)
{
	if(self.V["delay"] > 0)
	{
		WaitRealTime(self.V["delay"]);
	}
	create_trigger(clientNum);
}

/*
	Name: report_num_effects
	Namespace: FX
	Checksum: 0xEB8FACF
	Offset: 0x8B8
	Size: 0x7
	Parameters: 0
	Flags: None
*/
function report_num_effects()
{
	/#
	#/
}

/*
	Name: loop_sound
	Namespace: FX
	Checksum: 0x4DCBE226
	Offset: 0x8C8
	Size: 0x10B
	Parameters: 1
	Flags: None
*/
function loop_sound(clientNum)
{
	if(clientNum != 0)
	{
		return;
	}
	self notify("stop_loop");
	if(isdefined(self.V["soundalias"]) && self.V["soundalias"] != "nil")
	{
		if(isdefined(self.V["stopable"]) && self.V["stopable"])
		{
			thread sound::loop_fx_sound(clientNum, self.V["soundalias"], self.V["origin"], "stop_loop");
		}
		else
		{
			thread sound::loop_fx_sound(clientNum, self.V["soundalias"], self.V["origin"]);
		}
	}
}

/*
	Name: lightning
	Namespace: FX
	Checksum: 0x4B028E2C
	Offset: 0x9E0
	Size: 0x4F
	Parameters: 2
	Flags: None
*/
function lightning(normalFunc, flashFunc)
{
	[[flashFunc]]();
	WaitRealTime(RandomFloatRange(0.05, 0.1));
	[[normalFunc]]();
}

/*
	Name: loop_thread
	Namespace: FX
	Checksum: 0x4B1C7F3E
	Offset: 0xA38
	Size: 0xEF
	Parameters: 1
	Flags: None
*/
function loop_thread(clientNum)
{
	if(isdefined(self.fxStart))
	{
		level waittill("start fx" + self.fxStart);
	}
	while(1)
	{
		create_looper(clientNum);
		if(isdefined(self.timeout))
		{
			thread loop_stop(clientNum, self.timeout);
		}
		if(isdefined(self.fxStop))
		{
			level waittill("stop fx" + self.fxStop);
		}
		else
		{
			return;
		}
		if(isdefined(self.looperFX))
		{
			deletefx(clientNum, self.looperFX);
		}
		if(isdefined(self.fxStart))
		{
			level waittill("start fx" + self.fxStart);
		}
		else
		{
			return;
		}
	}
}

/*
	Name: loop_stop
	Namespace: FX
	Checksum: 0x7638ACE2
	Offset: 0xB30
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function loop_stop(clientNum, timeout)
{
	self endon("death");
	wait(timeout);
	if(isdefined(self.looper))
	{
		deletefx(clientNum, self.looper);
	}
}

/*
	Name: create_looper
	Namespace: FX
	Checksum: 0x7C655DB0
	Offset: 0xB88
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function create_looper(clientNum)
{
	self thread loop(clientNum);
	loop_sound(clientNum);
}

/*
	Name: loop
	Namespace: FX
	Checksum: 0xF1CD1AA5
	Offset: 0xBD0
	Size: 0x1CF
	Parameters: 1
	Flags: None
*/
function loop(clientNum)
{
	validate(self.V["fxid"], self.V["origin"]);
	self.looperFX = playFX(clientNum, level._effect[self.V["fxid"]], self.V["origin"], self.V["forward"], self.V["up"], self.V["delay"], self.V["primlightfrac"], self.V["lightoriginoffs"]);
	while(1)
	{
		if(isdefined(self.V["delay"]))
		{
			WaitRealTime(self.V["delay"]);
		}
		while(isfxplaying(clientNum, self.looperFX))
		{
			wait(0.25);
		}
		self.looperFX = playFX(clientNum, level._effect[self.V["fxid"]], self.V["origin"], self.V["forward"], self.V["up"], 0, self.V["primlightfrac"], self.V["lightoriginoffs"]);
	}
}

/*
	Name: create_trigger
	Namespace: FX
	Checksum: 0x78622461
	Offset: 0xDA8
	Size: 0x143
	Parameters: 1
	Flags: None
*/
function create_trigger(clientNum)
{
	validate(self.V["fxid"], self.V["origin"]);
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			println("Dev Block strings are not supported" + self.V["Dev Block strings are not supported"]);
		}
	#/
	self.looperFX = playFX(clientNum, level._effect[self.V["fxid"]], self.V["origin"], self.V["forward"], self.V["up"], self.V["delay"], self.V["primlightfrac"], self.V["lightoriginoffs"]);
	loop_sound(clientNum);
}

/*
	Name: blinky_light
	Namespace: FX
	Checksum: 0xA68D7FB0
	Offset: 0xEF8
	Size: 0x14F
	Parameters: 4
	Flags: None
*/
function blinky_light(localClientNum, tagName, friendlyfx, enemyfx)
{
	self endon("entityshutdown");
	self endon("stop_blinky_light");
	self.lightTagName = tagName;
	self util::waittill_dobj(localClientNum);
	self thread blinky_emp_wait(localClientNum);
	while(1)
	{
		if(isdefined(self.stunned) && self.stunned)
		{
			wait(0.1);
			continue;
		}
		if(isdefined(self))
		{
			if(util::friend_not_foe(localClientNum))
			{
				self.blinkyLightFx = PlayFXOnTag(localClientNum, friendlyfx, self, self.lightTagName);
			}
			else
			{
				self.blinkyLightFx = PlayFXOnTag(localClientNum, enemyfx, self, self.lightTagName);
			}
		}
		util::server_wait(localClientNum, 0.5, 0.016);
	}
}

/*
	Name: stop_blinky_light
	Namespace: FX
	Checksum: 0xFE4BAD2E
	Offset: 0x1050
	Size: 0x4D
	Parameters: 1
	Flags: None
*/
function stop_blinky_light(localClientNum)
{
	self notify("stop_blinky_light");
	if(!isdefined(self.blinkyLightFx))
	{
		return;
	}
	stopfx(localClientNum, self.blinkyLightFx);
	self.blinkyLightFx = undefined;
}

/*
	Name: blinky_emp_wait
	Namespace: FX
	Checksum: 0x28BF7038
	Offset: 0x10A8
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function blinky_emp_wait(localClientNum)
{
	self endon("entityshutdown");
	self endon("stop_blinky_light");
	self waittill("emp");
	self stop_blinky_light(localClientNum);
}

