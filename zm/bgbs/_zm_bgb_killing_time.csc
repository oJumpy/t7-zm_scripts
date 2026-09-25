#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_9dd35181;

/*
	Name: __init__sytem__
	Namespace: namespace_9dd35181
	Checksum: 0xC0FA76BD
	Offset: 0x1D8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_killing_time", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_9dd35181
	Checksum: 0x57DE1A93
	Offset: 0x218
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_killing_time", "activated");
	clientfield::register("actor", "zombie_instakill_fx", 1, 1, "int", &function_a81107fc, 0, 1);
	clientfield::register("toplayer", "instakill_upgraded_fx", 1, 1, "int", &function_cf8c9fce, 0, 0);
}

/*
	Name: function_cf8c9fce
	Namespace: namespace_9dd35181
	Checksum: 0x53C00BA2
	Offset: 0x2F0
	Size: 0x55
	Parameters: 7
	Flags: None
*/
function function_cf8c9fce(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
	}
	else
	{
		self notify("hash_eb366021");
	}
}

/*
	Name: function_2a30e2ca
	Namespace: namespace_9dd35181
	Checksum: 0x6E3D244B
	Offset: 0x350
	Size: 0x85
	Parameters: 1
	Flags: None
*/
function function_2a30e2ca(localClientNum)
{
	self endon("death");
	self endon("end_demo_jump_listener");
	self endon("entityshutdown");
	self notify("hash_eb366021");
	self endon("hash_eb366021");
	while(1)
	{
		self.var_dedf9511 = self playsound(localClientNum, "zmb_music_box", self.origin);
		wait(4);
	}
}

/*
	Name: function_a81107fc
	Namespace: namespace_9dd35181
	Checksum: 0x13EBA211
	Offset: 0x3E0
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function function_a81107fc(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(newVal))
	{
		return;
	}
	if(newVal)
	{
		fxObj = util::spawn_model(localClientNum, "tag_origin", self.origin, self.angles);
		fxObj thread function_10dcbf51(localClientNum, fxObj);
	}
}

/*
	Name: function_10dcbf51
	Namespace: namespace_9dd35181
	Checksum: 0x4D0D7EF4
	Offset: 0x490
	Size: 0x53
	Parameters: 2
	Flags: Private
*/
function private function_10dcbf51(localClientNum, fxObj)
{
	fxObj playsound(localClientNum, "evt_ai_explode");
	wait(1);
	fxObj delete();
}

