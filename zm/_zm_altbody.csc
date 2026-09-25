#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_utility;

#namespace zm_altbody;

/*
	Name: __init__sytem__
	Namespace: zm_altbody
	Checksum: 0x51758F32
	Offset: 0x250
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_altbody", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_altbody
	Checksum: 0xCD8A76B9
	Offset: 0x290
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("clientuimodel", "player_mana", 1, 8, "float", &function_277a765, 0, 1);
	clientfield::register("toplayer", "player_in_afterlife", 1, 1, "int", &function_bf48baa3, 0, 1);
	clientfield::register("allplayers", "player_altbody", 1, 1, "int", &function_da02d223, 0, 1);
	SetupClientFieldCodeCallbacks("toplayer", 1, "player_in_afterlife");
}

/*
	Name: init
	Namespace: zm_altbody
	Checksum: 0x1A5E248B
	Offset: 0x3A0
	Size: 0x161
	Parameters: 9
	Flags: None
*/
function init(name, trigger_name, trigger_hint, visionset_name, var_c74f70a2, var_4b737285, var_5cff5411, var_438dff29, var_55e012f5)
{
	if(!isdefined(level.var_16cbb1a8))
	{
		level.var_16cbb1a8 = [];
	}
	if(!isdefined(level.var_3b231394))
	{
		level.var_3b231394 = [];
	}
	if(!isdefined(level.var_7c3c2334))
	{
		level.var_7c3c2334 = [];
	}
	if(!isdefined(level.var_780a9f20))
	{
		level.var_780a9f20 = [];
	}
	if(!isdefined(level.var_b48c4996))
	{
		level.var_b48c4996 = [];
	}
	level.var_105435b0 = name;
	if(isdefined(visionset_name))
	{
		level.var_b48c4996[name] = visionset_name;
		visionset_mgr::register_visionset_info(visionset_name, 1, 1, visionset_name, visionset_name);
	}
	level.var_16cbb1a8[name] = var_4b737285;
	level.var_3b231394[name] = var_5cff5411;
	level.var_7c3c2334[name] = var_438dff29;
	level.var_780a9f20[name] = var_55e012f5;
}

/*
	Name: function_277a765
	Namespace: zm_altbody
	Checksum: 0xCF14282C
	Offset: 0x510
	Size: 0x47
	Parameters: 7
	Flags: None
*/
function function_277a765(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self.var_7bd1110 = newVal;
}

/*
	Name: function_bf48baa3
	Namespace: zm_altbody
	Checksum: 0x2BCFD96F
	Offset: 0x560
	Size: 0x14D
	Parameters: 7
	Flags: None
*/
function function_bf48baa3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(self.altbody))
	{
		self.altbody = 0;
	}
	self function_a960ea9b(newVal);
	if(self.altbody !== newVal)
	{
		self.altbody = newVal;
		if(bWasTimeJump)
		{
			self thread function_9927f5ae(localClientNum, newVal);
		}
		else
		{
			self thread cover_transition(localClientNum, newVal);
		}
		if(newVal == 1)
		{
			callback = level.var_16cbb1a8[level.var_105435b0];
			if(isdefined(callback))
			{
				self [[callback]](localClientNum);
			}
		}
		else
		{
			callback = level.var_3b231394[level.var_105435b0];
			if(isdefined(callback))
			{
				self [[callback]](localClientNum);
			}
		}
	}
}

/*
	Name: function_da02d223
	Namespace: zm_altbody
	Checksum: 0x5EC17C7A
	Offset: 0x6B8
	Size: 0xE5
	Parameters: 7
	Flags: None
*/
function function_da02d223(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(self isLocalPlayer())
	{
		return;
	}
	self.var_6569d6b8 = newVal;
	if(newVal == 1)
	{
		callback = level.var_7c3c2334[level.var_105435b0];
		if(isdefined(callback))
		{
			self [[callback]](localClientNum);
		}
	}
	else
	{
		callback = level.var_780a9f20[level.var_105435b0];
		if(isdefined(callback))
		{
			self [[callback]](localClientNum);
		}
	}
}

/*
	Name: cover_transition
	Namespace: zm_altbody
	Checksum: 0x6F9067A
	Offset: 0x7A8
	Size: 0xFB
	Parameters: 2
	Flags: None
*/
function cover_transition(localClientNum, onOff)
{
	if(!self isLocalPlayer() || IsSpectating(localClientNum, 0) || localClientNum !== self getlocalclientnumber())
	{
		return;
	}
	if(IsDemoPlaying() && DemoIsAnyFreeMoveCamera())
	{
		return;
	}
	LUI::screen_fade_out(0.05);
	level util::waittill_any_timeout(0.15, "demo_jump");
	if(isdefined(self))
	{
		LUI::screen_fade_in(0.1);
	}
}

/*
	Name: function_9927f5ae
	Namespace: zm_altbody
	Checksum: 0xE36A93A2
	Offset: 0x8B0
	Size: 0x2B
	Parameters: 2
	Flags: None
*/
function function_9927f5ae(localClientNum, onOff)
{
	LUI::screen_fade_in(0);
}

