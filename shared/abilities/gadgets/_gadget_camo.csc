#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\abilities\gadgets\_gadget_camo_render;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace _gadget_camo;

/*
	Name: __init__sytem__
	Namespace: _gadget_camo
	Checksum: 0xD3687DE0
	Offset: 0x2C0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_camo", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_camo
	Checksum: 0x6C915674
	Offset: 0x300
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("allplayers", "camo_shader", 1, 3, "int", &ent_camo_material_callback, 0, 1);
}

/*
	Name: ent_camo_material_callback
	Namespace: _gadget_camo
	Checksum: 0x689D464D
	Offset: 0x358
	Size: 0x273
	Parameters: 7
	Flags: None
*/
function ent_camo_material_callback(local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(oldVal == newVal && oldVal == 0 && !bWasTimeJump)
	{
		return;
	}
	flags_changed = self duplicate_render::set_dr_flag_not_array("gadget_camo_friend", util::friend_not_foe(local_client_num, 1));
	flags_changed = flags_changed | self duplicate_render::set_dr_flag_not_array("gadget_camo_flicker", newVal == 2);
	flags_changed = flags_changed | self duplicate_render::set_dr_flag_not_array("gadget_camo_break", newVal == 3);
	flags_changed = flags_changed | self duplicate_render::set_dr_flag_not_array("gadget_camo_reveal", newVal != oldVal);
	flags_changed = flags_changed | self duplicate_render::set_dr_flag_not_array("gadget_camo_on", newVal != 0);
	flags_changed = flags_changed | self duplicate_render::set_dr_flag_not_array("hide_model", newVal == 0);
	flags_changed = flags_changed | bNewEnt;
	if(flags_changed)
	{
		self duplicate_render::update_dr_filters(local_client_num);
	}
	self notify("endtest");
	if(newVal && (bWasTimeJump || bNewEnt))
	{
		self thread gadget_camo_render::forceOn(local_client_num);
	}
	else if(newVal != oldVal)
	{
		self thread gadget_camo_render::doReveal(local_client_num, newVal != 0);
	}
	if(newVal && !oldVal || (newVal && (bWasTimeJump || bNewEnt)))
	{
		self GadgetPulseResetReveal();
	}
}

