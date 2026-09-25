#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\abilities\gadgets\_gadget_clone_render;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_clone;

/*
	Name: __init__sytem__
	Namespace: _gadget_clone
	Checksum: 0x4FCC7EA5
	Offset: 0x2D8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_clone", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_clone
	Checksum: 0x172B240F
	Offset: 0x318
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("actor", "clone_activated", 1, 1, "int", &clone_activated, 0, 1);
	clientfield::register("actor", "clone_damaged", 1, 1, "int", &clone_damaged, 0, 0);
	clientfield::register("allplayers", "clone_activated", 1, 1, "int", &player_clone_activated, 0, 0);
}

/*
	Name: set_shader
	Namespace: _gadget_clone
	Checksum: 0x98284375
	Offset: 0x400
	Size: 0x83
	Parameters: 3
	Flags: None
*/
function set_shader(localClientNum, enabled, entity)
{
	if(entity isFriendly(localClientNum))
	{
		self duplicate_render::update_dr_flag(localClientNum, "clone_ally_on", enabled);
	}
	else
	{
		self duplicate_render::update_dr_flag(localClientNum, "clone_enemy_on", enabled);
	}
}

/*
	Name: clone_activated
	Namespace: _gadget_clone
	Checksum: 0x5C834F63
	Offset: 0x490
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function clone_activated(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self._isClone = 1;
		self set_shader(localClientNum, 1, self GetOwner(localClientNum));
		if(isdefined(level._monitor_tracker))
		{
			self thread [[level._monitor_tracker]](localClientNum);
		}
		self thread gadget_clone_render::transition_shader(localClientNum);
	}
}

/*
	Name: player_clone_activated
	Namespace: _gadget_clone
	Checksum: 0x45B8F3
	Offset: 0x558
	Size: 0xDB
	Parameters: 7
	Flags: None
*/
function player_clone_activated(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(self))
	{
		return;
	}
	if(newVal)
	{
		self set_shader(localClientNum, 1, self);
		self thread gadget_clone_render::transition_shader(localClientNum);
	}
	else
	{
		self set_shader(localClientNum, 0, self);
		self notify("clone_shader_off");
		self MapShaderConstant(localClientNum, 0, "scriptVector3", 1, 0, 0, 1);
	}
}

/*
	Name: clone_damage_flicker
	Namespace: _gadget_clone
	Checksum: 0xEA2814F6
	Offset: 0x640
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function clone_damage_flicker(localClientNum)
{
	self endon("entityshutdown");
	self notify("start_flicker");
	self endon("start_flicker");
	self duplicate_render::update_dr_flag(localClientNum, "clone_damage", 1);
	self waittill("stop_flicker");
	self duplicate_render::update_dr_flag(localClientNum, "clone_damage", 0);
}

/*
	Name: clone_damage_finish
	Namespace: _gadget_clone
	Checksum: 0xBE0400B5
	Offset: 0x6D0
	Size: 0x3D
	Parameters: 0
	Flags: None
*/
function clone_damage_finish()
{
	self endon("entityshutdown");
	self endon("start_flicker");
	self endon("stop_flicker");
	wait(0.2);
	self notify("stop_flicker");
}

/*
	Name: clone_damaged
	Namespace: _gadget_clone
	Checksum: 0x41EA835C
	Offset: 0x718
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function clone_damaged(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self thread clone_damage_flicker(localClientNum);
	}
	else
	{
		self thread clone_damage_finish();
	}
}

