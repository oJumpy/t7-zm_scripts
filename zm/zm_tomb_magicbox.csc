#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_bafc277e;

/*
	Name: __init__sytem__
	Namespace: namespace_bafc277e
	Checksum: 0x92F4C972
	Offset: 0x220
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("tomb_magicbox", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_bafc277e
	Checksum: 0x16DB8F03
	Offset: 0x260
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("zbarrier", "magicbox_initial_fx", 21000, 1, "int", &function_cc36f894, 0, 0);
	clientfield::register("zbarrier", "magicbox_amb_fx", 21000, 2, "int", &function_ae458229, 0, 0);
	clientfield::register("zbarrier", "magicbox_open_fx", 21000, 1, "int", &function_c8f2b7a1, 0, 0);
	clientfield::register("zbarrier", "magicbox_leaving_fx", 21000, 1, "int", &function_cac7ed81, 0, 0);
}

/*
	Name: function_cac7ed81
	Namespace: namespace_bafc277e
	Checksum: 0x8D02CD90
	Offset: 0x390
	Size: 0x103
	Parameters: 7
	Flags: None
*/
function function_cac7ed81(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(!isdefined(self.fx_obj))
	{
		self.fx_obj = spawn(localClientNum, self.origin, "script_model");
		self.fx_obj.angles = self.angles;
		self.fx_obj SetModel("tag_origin");
	}
	if(newVal == 1)
	{
		self.fx_obj.var_6217501d = PlayFXOnTag(localClientNum, level._effect["box_is_leaving"], self.fx_obj, "tag_origin");
	}
}

/*
	Name: function_c8f2b7a1
	Namespace: namespace_bafc277e
	Checksum: 0xE0CB8762
	Offset: 0x4A0
	Size: 0x20B
	Parameters: 7
	Flags: None
*/
function function_c8f2b7a1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(!isdefined(self.fx_obj))
	{
		self.fx_obj = spawn(localClientNum, self.origin, "script_model");
		self.fx_obj.angles = self.angles;
		self.fx_obj SetModel("tag_origin");
	}
	if(!isdefined(self.var_9b17c542))
	{
		self.var_9b17c542 = spawn(localClientNum, self.origin, "script_model");
		self.var_9b17c542.angles = self.angles;
		self.var_9b17c542 SetModel("tag_origin");
	}
	if(newVal == 0)
	{
		stopfx(localClientNum, self.fx_obj.var_80194315);
		self.var_9b17c542 StopLoopSound(1);
		self notify("hash_90e6e5c7");
	}
	else if(newVal == 1)
	{
		self.fx_obj.var_80194315 = PlayFXOnTag(localClientNum, level._effect["box_is_open"], self.fx_obj, "tag_origin");
		self.var_9b17c542 PlayLoopSound("zmb_hellbox_open_effect");
		self thread function_b714c89b(localClientNum);
	}
}

/*
	Name: function_b714c89b
	Namespace: namespace_bafc277e
	Checksum: 0x56EC1106
	Offset: 0x6B8
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function function_b714c89b(localClientNum)
{
	wait(0.5);
	self.var_9b17c542.var_a5875243 = PlayFXOnTag(localClientNum, level._effect["box_portal"], self.var_9b17c542, "tag_origin");
	self waittill("hash_90e6e5c7");
	stopfx(localClientNum, self.var_9b17c542.var_a5875243);
}

/*
	Name: function_cc36f894
	Namespace: namespace_bafc277e
	Checksum: 0xE6A4DEF0
	Offset: 0x750
	Size: 0xE3
	Parameters: 7
	Flags: None
*/
function function_cc36f894(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(!isdefined(self.fx_obj))
	{
		self.fx_obj = spawn(localClientNum, self.origin, "script_model");
		self.fx_obj.angles = self.angles;
		self.fx_obj SetModel("tag_origin");
	}
	else
	{
		return;
	}
	if(newVal == 1)
	{
		self.fx_obj PlayLoopSound("zmb_hellbox_amb_low");
	}
}

/*
	Name: function_ae458229
	Namespace: namespace_bafc277e
	Checksum: 0x9FAC0535
	Offset: 0x840
	Size: 0x473
	Parameters: 7
	Flags: None
*/
function function_ae458229(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(!isdefined(self.fx_obj))
	{
		self.fx_obj = spawn(localClientNum, self.origin, "script_model");
		self.fx_obj.angles = self.angles;
		self.fx_obj SetModel("tag_origin");
	}
	if(isdefined(self.fx_obj.var_992b4eed))
	{
		stopfx(localClientNum, self.fx_obj.var_992b4eed);
	}
	if(isdefined(self.fx_obj.var_9eb800bb))
	{
		stopfx(localClientNum, self.fx_obj.var_9eb800bb);
	}
	if(newVal == 0)
	{
		self.fx_obj PlayLoopSound("zmb_hellbox_amb_low");
		playsound(0, "zmb_hellbox_leave", self.fx_obj.origin);
		stopfx(localClientNum, self.fx_obj.var_992b4eed);
	}
	else if(newVal == 1)
	{
		self.fx_obj.var_9eb800bb = PlayFXOnTag(localClientNum, level._effect["box_unpowered"], self.fx_obj, "tag_origin");
		self.fx_obj.var_992b4eed = PlayFXOnTag(localClientNum, level._effect["box_here_ambient"], self.fx_obj, "tag_origin");
		self.fx_obj PlayLoopSound("zmb_hellbox_amb_low");
		playsound(0, "zmb_hellbox_arrive", self.fx_obj.origin);
	}
	else if(newVal == 2)
	{
		self.fx_obj.var_9eb800bb = PlayFXOnTag(localClientNum, level._effect["box_powered"], self.fx_obj, "tag_origin");
		self.fx_obj.var_992b4eed = PlayFXOnTag(localClientNum, level._effect["box_here_ambient"], self.fx_obj, "tag_origin");
		self.fx_obj PlayLoopSound("zmb_hellbox_amb_high");
		playsound(0, "zmb_hellbox_arrive", self.fx_obj.origin);
	}
	else if(newVal == 3)
	{
		self.fx_obj.var_9eb800bb = PlayFXOnTag(localClientNum, level._effect["box_unpowered"], self.fx_obj, "tag_origin");
		self.fx_obj.var_992b4eed = PlayFXOnTag(localClientNum, level._effect["box_gone_ambient"], self.fx_obj, "tag_origin");
		self.fx_obj PlayLoopSound("zmb_hellbox_amb_high");
		playsound(0, "zmb_hellbox_leave", self.fx_obj.origin);
	}
}

