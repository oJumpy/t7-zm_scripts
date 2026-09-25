#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace _gadget_armor;

/*
	Name: __init__sytem__
	Namespace: _gadget_armor
	Checksum: 0xD2F680B0
	Offset: 0x2F0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_armor", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_armor
	Checksum: 0x8982A122
	Offset: 0x330
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_localplayer_spawned(&on_local_player_spawned);
	clientfield::register("allplayers", "armor_status", 1, 5, "int", &player_armor_changed, 0, 0);
	clientfield::register("toplayer", "player_damage_type", 1, 1, "int", &player_damage_type_changed, 0, 0);
	duplicate_render::set_dr_filter_framebuffer_duplicate("armor_pl", 40, "armor_on", undefined, 1, "mc/mtl_power_armor", 0);
	/#
		level thread function_cc0cff2a();
	#/
}

/*
	Name: on_local_player_spawned
	Namespace: _gadget_armor
	Checksum: 0x506372AD
	Offset: 0x438
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function on_local_player_spawned(localClientNum)
{
	if(self != GetLocalPlayer(localClientNum))
	{
		return;
	}
	newVal = self clientfield::get("armor_status");
	self player_armor_changed_event(localClientNum, newVal);
}

/*
	Name: player_damage_type_changed
	Namespace: _gadget_armor
	Checksum: 0x1AC1566D
	Offset: 0x4B0
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function player_damage_type_changed(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self armor_update_fx_event(localClientNum, newVal);
}

/*
	Name: player_armor_changed
	Namespace: _gadget_armor
	Checksum: 0x92C36AE1
	Offset: 0x518
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function player_armor_changed(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self player_armor_changed_event(localClientNum, newVal);
}

/*
	Name: player_armor_changed_event
	Namespace: _gadget_armor
	Checksum: 0xE55162B3
	Offset: 0x580
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function player_armor_changed_event(localClientNum, newVal)
{
	self armor_update_fx_event(localClientNum, newVal);
	self armor_update_shader_event(localClientNum, newVal);
}

/*
	Name: armor_update_shader_event
	Namespace: _gadget_armor
	Checksum: 0xC661CAE3
	Offset: 0x5E0
	Size: 0x223
	Parameters: 2
	Flags: None
*/
function armor_update_shader_event(localClientNum, armorStatusNew)
{
	if(armorStatusNew)
	{
		self duplicate_render::update_dr_flag(localClientNum, "armor_on", 1);
		shieldExpansionNcolor = "scriptVector3";
		shieldExpansionValueX = 0.3;
		colorVector = armor_get_shader_color(armorStatusNew);
		if(GetDvarInt("scr_armor_dev"))
		{
			shieldExpansionValueX = GetDvarFloat("scr_armor_expand", shieldExpansionValueX);
			colorVector = (GetDvarFloat("scr_armor_colorR", colorVector[0]), GetDvarFloat("scr_armor_colorG", colorVector[1]), GetDvarFloat("scr_armor_colorB", colorVector[2]));
		}
		colorTintValueY = colorVector[0];
		colorTintValueZ = colorVector[1];
		colorTintValueW = colorVector[2];
		damageState = "scriptVector4";
		damageStateValue = armorStatusNew / 5;
		self MapShaderConstant(localClientNum, 0, shieldExpansionNcolor, shieldExpansionValueX, colorTintValueY, colorTintValueZ, colorTintValueW);
		self MapShaderConstant(localClientNum, 0, damageState, damageStateValue);
	}
	else
	{
		self duplicate_render::update_dr_flag(localClientNum, "armor_on", 0);
	}
}

/*
	Name: armor_get_shader_color
	Namespace: _gadget_armor
	Checksum: 0x682C141D
	Offset: 0x810
	Size: 0x35
	Parameters: 1
	Flags: None
*/
function armor_get_shader_color(armorStatusNew)
{
	color = (0.3, 0.3, 0.2);
	return color;
}

/*
	Name: armor_update_fx_event
	Namespace: _gadget_armor
	Checksum: 0x5AA83E2A
	Offset: 0x850
	Size: 0xAB
	Parameters: 2
	Flags: None
*/
function armor_update_fx_event(localClientNum, doArmorFx)
{
	if(!self armor_is_local_player(localClientNum))
	{
		return;
	}
	if(doArmorFx)
	{
		self SetDamageDirectionIndicator(1);
		setsoundcontext("plr_impact", "pwr_armor");
	}
	else
	{
		self SetDamageDirectionIndicator(0);
		setsoundcontext("plr_impact", "");
	}
}

/*
	Name: armor_overlay_transition_fx
	Namespace: _gadget_armor
	Checksum: 0x6D03D5BB
	Offset: 0x908
	Size: 0x14F
	Parameters: 2
	Flags: None
*/
function armor_overlay_transition_fx(localClientNum, armorStatusNew)
{
	self endon("disconnect");
	if(!isdefined(self._gadget_armor_state))
	{
		self._gadget_armor_state = 0;
	}
	if(armorStatusNew == self._gadget_armor_state)
	{
		return;
	}
	self._gadget_armor_state = armorStatusNew;
	if(armorStatusNew == 5)
	{
		return;
	}
	if(isdefined(self._armor_doing_transition) && self._armor_doing_transition)
	{
		return;
	}
	self._armor_doing_transition = 1;
	transition = 0;
	flicker_start_time = GetRealTime();
	saved_vision = GetVisionSetNaked(localClientNum);
	visionSetNaked(localClientNum, "taser_mine_shock", transition);
	self playsound(0, "wpn_taser_mine_tacmask");
	wait(0.3);
	visionSetNaked(localClientNum, saved_vision, transition);
	self._armor_doing_transition = 0;
}

/*
	Name: armor_is_local_player
	Namespace: _gadget_armor
	Checksum: 0x282F2F3A
	Offset: 0xA60
	Size: 0x49
	Parameters: 1
	Flags: None
*/
function armor_is_local_player(localClientNum)
{
	player_view = GetLocalPlayer(localClientNum);
	sameEntity = self == player_view;
	return sameEntity;
}

/*
	Name: function_cc0cff2a
	Namespace: _gadget_armor
	Checksum: 0xEF0A8C9A
	Offset: 0xAB8
	Size: 0x13F
	Parameters: 0
	Flags: None
*/
function function_cc0cff2a()
{
	/#
		var_72e51998 = 0;
		SetDvar("Dev Block strings are not supported", 0);
		while(1)
		{
			wait(0.1);
			armorStatusNew = GetDvarInt("Dev Block strings are not supported");
			if(armorStatusNew != var_72e51998)
			{
				players = GetLocalPlayers();
				foreach(localPlayer in players)
				{
					if(!isdefined(localPlayer))
					{
						continue;
					}
					localPlayer player_armor_changed_event(i, armorStatusNew);
				}
				var_72e51998 = armorStatusNew;
			}
		}
	#/
}

