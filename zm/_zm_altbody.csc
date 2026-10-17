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
	clientfield::register("clientuimodel", "player_mana", 1, 8, "float", &set_player_mana, 0, 1);
	clientfield::register("toplayer", "player_in_afterlife", 1, 1, "int", &toggle_player_altbody, 0, 1);
	clientfield::register("allplayers", "player_altbody", 1, 1, "int", &toggle_player_altbody_3p, 0, 1);
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
function init(name, trigger_name, trigger_hint, visionset_name, visionset_priority, enter_callback, exit_callback, enter_3p_callback, exit_3p_callback)
{
	if(!isdefined(level.altbody_enter_callbacks))
	{
		level.altbody_enter_callbacks = [];
	}
	if(!isdefined(level.altbody_exit_callbacks))
	{
		level.altbody_exit_callbacks = [];
	}
	if(!isdefined(level.altbody_enter_3p_callbacks))
	{
		level.altbody_enter_3p_callbacks = [];
	}
	if(!isdefined(level.altbody_exit_3p_callbacks))
	{
		level.altbody_exit_3p_callbacks = [];
	}
	if(!isdefined(level.altbody_visionsets))
	{
		level.altbody_visionsets = [];
	}
	level.altbody_name = name;
	if(isdefined(visionset_name))
	{
		level.altbody_visionsets[name] = visionset_name;
		visionset_mgr::register_visionset_info(visionset_name, 1, 1, visionset_name, visionset_name);
	}
	level.altbody_enter_callbacks[name] = enter_callback;
	level.altbody_exit_callbacks[name] = exit_callback;
	level.altbody_enter_3p_callbacks[name] = enter_3p_callback;
	level.altbody_exit_3p_callbacks[name] = exit_3p_callback;
}

/*
	Name: set_player_mana
	Namespace: zm_altbody
	Checksum: 0xCF14282C
	Offset: 0x510
	Size: 0x47
	Parameters: 7
	Flags: None
*/
function set_player_mana(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self.mana = newVal;
}

/*
	Name: toggle_player_altbody
	Namespace: zm_altbody
	Checksum: 0x2BCFD96F
	Offset: 0x560
	Size: 0x14D
	Parameters: 7
	Flags: None
*/
function toggle_player_altbody(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(self.altbody))
	{
		self.altbody = 0;
	}
	self usealternatehud(newVal);
	if(self.altbody !== newVal)
	{
		self.altbody = newVal;
		if(bWasTimeJump)
		{
			self thread clear_transition(localClientNum, newVal);
		}
		else
		{
			self thread cover_transition(localClientNum, newVal);
		}
		if(newVal == 1)
		{
			callback = level.altbody_enter_callbacks[level.altbody_name];
			if(isdefined(callback))
			{
				self [[callback]](localClientNum);
			}
		}
		else
		{
			callback = level.altbody_exit_callbacks[level.altbody_name];
			if(isdefined(callback))
			{
				self [[callback]](localClientNum);
			}
		}
	}
}

/*
	Name: toggle_player_altbody_3p
	Namespace: zm_altbody
	Checksum: 0x5EC17C7A
	Offset: 0x6B8
	Size: 0xE5
	Parameters: 7
	Flags: None
*/
function toggle_player_altbody_3p(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(self isLocalPlayer())
	{
		return;
	}
	self.altbody_3p = newVal;
	if(newVal == 1)
	{
		callback = level.altbody_enter_3p_callbacks[level.altbody_name];
		if(isdefined(callback))
		{
			self [[callback]](localClientNum);
		}
	}
	else
	{
		callback = level.altbody_exit_3p_callbacks[level.altbody_name];
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
	Name: clear_transition
	Namespace: zm_altbody
	Checksum: 0xE36A93A2
	Offset: 0x8B0
	Size: 0x2B
	Parameters: 2
	Flags: None
*/
function clear_transition(localClientNum, onOff)
{
	LUI::screen_fade_in(0);
}

