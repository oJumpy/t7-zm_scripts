#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerup_ww_grenade;

#namespace zm_perk_widows_wine;

/*
	Name: __init__sytem__
	Namespace: zm_perk_widows_wine
	Checksum: 0x95C9EFCF
	Offset: 0x2D8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_widows_wine", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_widows_wine
	Checksum: 0x42B776B7
	Offset: 0x318
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_perks::register_perk_clientfields("specialty_widowswine", &widows_wine_client_field_func, &widows_wine_code_callback_func);
	zm_perks::register_perk_effects("specialty_widowswine", "widow_light");
	zm_perks::register_perk_init_thread("specialty_widowswine", &init_widows_wine);
	clientfield::register("toplayer", "widows_wine_1p_contact_explosion", 1, 1, "counter", &widows_wine_1p_contact_explosion, 0, 0);
}

/*
	Name: init_widows_wine
	Namespace: zm_perk_widows_wine
	Checksum: 0x6D7C4BE6
	Offset: 0x3F0
	Size: 0x51
	Parameters: 0
	Flags: None
*/
function init_widows_wine()
{
	if(isdefined(level.enable_magic) && level.enable_magic)
	{
		level._effect["widow_light"] = "zombie/fx_perk_widows_wine_zmb";
		level._effect["widows_wine_wrap"] = "zombie/fx_widows_wrap_torso_zmb";
	}
}

/*
	Name: widows_wine_client_field_func
	Namespace: zm_perk_widows_wine
	Checksum: 0xFC8467A9
	Offset: 0x450
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function widows_wine_client_field_func()
{
	clientfield::register("clientuimodel", "hudItems.perks.widows_wine", 1, 2, "int", undefined, 0, 1);
	clientfield::register("actor", "widows_wine_wrapping", 1, 1, "int", &widows_wine_wrap_cb, 0, 1);
	clientfield::register("vehicle", "widows_wine_wrapping", 1, 1, "int", &widows_wine_wrap_cb, 0, 0);
}

/*
	Name: widows_wine_code_callback_func
	Namespace: zm_perk_widows_wine
	Checksum: 0x99EC1590
	Offset: 0x528
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function widows_wine_code_callback_func()
{
}

/*
	Name: widows_wine_wrap_cb
	Namespace: zm_perk_widows_wine
	Checksum: 0x9F6E86A5
	Offset: 0x538
	Size: 0x193
	Parameters: 7
	Flags: None
*/
function widows_wine_wrap_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(isdefined(self) && isalive(self))
		{
			if(!isdefined(self.fx_widows_wine_wrap))
			{
				self.fx_widows_wine_wrap = PlayFXOnTag(localClientNum, level._effect["widows_wine_wrap"], self, "j_spineupper");
			}
			if(!isdefined(self.sndWidowsWine))
			{
				self playsound(0, "wpn_wwgrenade_cocoon_imp");
				self.sndWidowsWine = self PlayLoopSound("wpn_wwgrenade_cocoon_lp", 0.1);
			}
		}
	}
	else if(isdefined(self.fx_widows_wine_wrap))
	{
		stopfx(localClientNum, self.fx_widows_wine_wrap);
		self.fx_widows_wine_wrap = undefined;
	}
	if(isdefined(self.sndWidowsWine))
	{
		self playsound(0, "wpn_wwgrenade_cocoon_stop");
		self StopLoopSound(self.sndWidowsWine, 0.1);
	}
}

/*
	Name: widows_wine_1p_contact_explosion
	Namespace: zm_perk_widows_wine
	Checksum: 0x6B737327
	Offset: 0x6D8
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function widows_wine_1p_contact_explosion(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	owner = self GetOwner(localClientNum);
	if(isdefined(owner) && owner == GetLocalPlayer(localClientNum))
	{
		thread widows_wine_1p_contact_explosion_play(localClientNum);
	}
}

/*
	Name: widows_wine_1p_contact_explosion_play
	Namespace: zm_perk_widows_wine
	Checksum: 0x2C27DD78
	Offset: 0x780
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function widows_wine_1p_contact_explosion_play(localClientNum)
{
	tag = "tag_flash";
	if(!ViewmodelHasTag(localClientNum, tag))
	{
		tag = "tag_weapon";
		if(!ViewmodelHasTag(localClientNum, tag))
		{
			return;
		}
	}
	fx_contact_explosion = PlayViewmodelFX(localClientNum, "zombie/fx_widows_exp_1p_zmb", tag);
	wait(2);
	deletefx(localClientNum, fx_contact_explosion, 1);
}

