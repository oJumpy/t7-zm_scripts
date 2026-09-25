#using scripts\codescripts\struct;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\system_shared;

#namespace _gadget_camo_render;

/*
	Name: __init__sytem__
	Namespace: _gadget_camo_render
	Checksum: 0x9A5421E1
	Offset: 0x420
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_camo_render", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_camo_render
	Checksum: 0xAB0EC71B
	Offset: 0x460
	Size: 0x183
	Parameters: 0
	Flags: None
*/
function __init__()
{
	duplicate_render::set_dr_filter_framebuffer_duplicate("camo_rev_dr", 90, "gadget_camo_reveal,", "gadget_camo_flicker,gadget_camo_break,hide_model", 1, "mc/hud_outline_predator", 0);
	duplicate_render::set_dr_filter_framebuffer("camo_rev", 90, "gadget_camo_reveal,hide_model", "gadget_camo_flicker,gadget_camo_break", 0, "mc/hud_outline_predator", 0);
	duplicate_render::set_dr_filter_framebuffer("camo_fr", 90, "gadget_camo_on,gadget_camo_friend,hide_model", "gadget_camo_flicker,gadget_camo_break", 0, "mc/hud_outline_predator_camo_active_ally", 0);
	duplicate_render::set_dr_filter_framebuffer("camo_en", 90, "gadget_camo_on,hide_model", "gadget_camo_flicker,gadget_camo_break,gadget_camo_friend", 0, "mc/hud_outline_predator_camo_active_enemy", 0);
	duplicate_render::set_dr_filter_framebuffer("camo_fr_fl", 80, "gadget_camo_on,gadget_camo_flicker,gadget_camo_friend", "gadget_camo_break", 0, "mc/hud_outline_predator_camo_disruption_ally", 0);
	duplicate_render::set_dr_filter_framebuffer("camo_en_fl", 80, "gadget_camo_on,gadget_camo_flicker", "gadget_camo_break,gadget_camo_friend", 0, "mc/hud_outline_predator_camo_disruption_enemy", 0);
	duplicate_render::set_dr_filter_framebuffer("camo_brk", 70, "gadget_camo_on,gadget_camo_break", undefined, 0, "mc/hud_outline_predator_break", 0);
}

#namespace gadget_camo_render;

/*
	Name: forceOn
	Namespace: gadget_camo_render
	Checksum: 0x29AA0B9F
	Offset: 0x5F0
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function forceOn(local_client_num)
{
	self notify("kill_gadget_camo_render_doreveal");
	self duplicate_render::update_dr_flag(local_client_num, "hide_model", 1);
	self MapShaderConstant(local_client_num, 0, "scriptVector0", 1, 0, 0, 0);
	self duplicate_render::set_dr_flag("gadget_camo_reveal", 0);
	self duplicate_render::set_dr_flag("gadget_camo_on", 1);
	self duplicate_render::update_dr_filters(local_client_num);
}

/*
	Name: doReveal
	Namespace: gadget_camo_render
	Checksum: 0xC14D6820
	Offset: 0x6B8
	Size: 0x363
	Parameters: 2
	Flags: None
*/
function doReveal(local_client_num, direction)
{
	self notify("kill_gadget_camo_render_doreveal");
	self endon("kill_gadget_camo_render_doreveal");
	self endon("entityshutdown");
	if(!isdefined(self))
	{
		return;
	}
	delta = 0.04571429;
	if(direction)
	{
		self duplicate_render::update_dr_flag(local_client_num, "hide_model", 0);
		self MapShaderConstant(local_client_num, 0, "scriptVector0", 0, 0, 0, 0);
		model_hidden = 0;
		for(currentValue = 0; currentValue < 1;  = 0)
		{
			self MapShaderConstant(local_client_num, 0, "scriptVector0", currentValue, 0, 0, 0);
			if(currentValue >= 0.5 && model_hidden == 0)
			{
				model_hidden = 1;
				self duplicate_render::update_dr_flag(local_client_num, "hide_model", 1);
			}
			wait(0.016);
		}
		self MapShaderConstant(local_client_num, 0, "scriptVector0", 1, 0, 0, 0);
		self duplicate_render::set_dr_flag("gadget_camo_reveal", 0);
		self duplicate_render::set_dr_flag("gadget_camo_on", 1);
		self duplicate_render::update_dr_filters(local_client_num);
	}
	else
	{
		self duplicate_render::update_dr_flag(local_client_num, "hide_model", 1);
		self MapShaderConstant(local_client_num, 0, "scriptVector0", 1, 0, 0, 0);
		model_hidden = 1;
		for(currentValue = 1; currentValue > 0;  = 1)
		{
			self MapShaderConstant(local_client_num, 0, "scriptVector0", currentValue, 0, 0, 0);
			if(currentValue < 0.5 && model_hidden)
			{
				self duplicate_render::update_dr_flag(local_client_num, "hide_model", 0);
				model_hidden = 0;
			}
			wait(0.016);
		}
		self MapShaderConstant(local_client_num, 0, "scriptVector0", 0, 0, 0, 0);
		self duplicate_render::set_dr_flag("gadget_camo_reveal", 0);
		self duplicate_render::set_dr_flag("gadget_camo_on", 0);
		self duplicate_render::update_dr_filters(local_client_num);
	}
}

