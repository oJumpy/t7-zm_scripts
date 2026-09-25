#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_equipment;

#namespace namespace_11fcf241;

/*
	Name: __init__sytem__
	Namespace: namespace_11fcf241
	Checksum: 0x712E7161
	Offset: 0x1D8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_equip_gasmask", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_11fcf241
	Checksum: 0xB327CC4B
	Offset: 0x218
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_equipment::Include("equip_gasmask");
	clientfield::register("toplayer", "gasmaskoverlay", 21000, 1, "int", &gasmask_overlay_handler, 0, 0);
	clientfield::register("clientuimodel", "hudItems.showDpadDown_PES", 21000, 1, "int", undefined, 0, 0);
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_gasmask_postfx", 21000, 32, "pstfx_moon_helmet", 3);
}

/*
	Name: gasmask_overlay_handler
	Namespace: namespace_11fcf241
	Checksum: 0xB643961
	Offset: 0x2F0
	Size: 0x145
	Parameters: 7
	Flags: None
*/
function gasmask_overlay_handler(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(!self isLocalPlayer() || IsSpectating(localClientNum, 0) || (isdefined(level.localPlayers[localClientNum]) && self GetEntityNumber() != level.localPlayers[localClientNum] GetEntityNumber()))
	{
		return;
	}
	if(newVal)
	{
		if(!isdefined(self.var_cf129735))
		{
			self.var_cf129735 = self PlayLoopSound("evt_gasmask_loop", 0.5);
		}
	}
	else if(isdefined(self.var_cf129735))
	{
		self StopLoopSound(self.var_cf129735, 0.5);
		self.var_cf129735 = undefined;
	}
}

