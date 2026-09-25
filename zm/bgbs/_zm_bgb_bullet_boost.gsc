#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace namespace_59f1b581;

/*
	Name: __init__sytem__
	Namespace: namespace_59f1b581
	Checksum: 0xB4D0182E
	Offset: 0x220
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_bullet_boost", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_59f1b581
	Checksum: 0x1BB414A6
	Offset: 0x260
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_bullet_boost", "activated", 2, undefined, undefined, &validation, &activation);
	bgb::function_f132da9c("zm_bgb_bullet_boost");
}

/*
	Name: validation
	Namespace: namespace_59f1b581
	Checksum: 0x2C0F609C
	Offset: 0x2E8
	Size: 0x12F
	Parameters: 0
	Flags: None
*/
function validation()
{
	current_weapon = self GetCurrentWeapon();
	if(!self zm_magicbox::can_buy_weapon() || self laststand::player_is_in_laststand() || (isdefined(self.intermission) && self.intermission) || self IsThrowingGrenade() || (!self zm_weapons::can_upgrade_weapon(current_weapon) && !zm_weapons::weapon_supports_aat(current_weapon)))
	{
		return 0;
	}
	if(self IsSwitchingWeapons())
	{
		return 0;
	}
	if(!zm_weapons::is_weapon_or_base_included(current_weapon))
	{
		return 0;
	}
	b_weapon_supports_aat = zm_weapons::weapon_supports_aat(current_weapon);
	if(!b_weapon_supports_aat)
	{
		return 0;
	}
	return 1;
}

/*
	Name: activation
	Namespace: namespace_59f1b581
	Checksum: 0x3FD0E64C
	Offset: 0x420
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function activation()
{
	self endon("death");
	self endon("disconnect");
	self playsoundtoplayer("zmb_bgb_bullet_boost", self);
	self util::waittill_any_timeout(1, "weapon_change_complete", "death", "disconnect");
	current_weapon = self GetCurrentWeapon();
	current_weapon = self zm_weapons::switch_from_alt_weapon(current_weapon);
	var_3a5329e8 = 0;
	while(current_weapon === level.weaponNone || !zm_weapons::weapon_supports_aat(current_weapon))
	{
		wait(0.05);
		current_weapon = self GetCurrentWeapon();
		var_3a5329e8++;
		if(current_weapon === level.weaponNone || !zm_weapons::weapon_supports_aat(current_weapon) && var_3a5329e8 > 300)
		{
			return;
		}
	}
	self AAT::acquire(current_weapon);
}

