#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace namespace_6d4de49;

/*
	Name: __init__sytem__
	Namespace: namespace_6d4de49
	Checksum: 0x7FE34B79
	Offset: 0x278
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_ephemeral_enhancement", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_6d4de49
	Checksum: 0xFECB091C
	Offset: 0x2B8
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_ephemeral_enhancement", "activated", 2, undefined, undefined, &validation, &activation);
	bgb::function_f132da9c("zm_bgb_ephemeral_enhancement");
	bgb::function_336ffc4e("zm_bgb_ephemeral_enhancement");
}

/*
	Name: validation
	Namespace: namespace_6d4de49
	Checksum: 0xA6C5F10A
	Offset: 0x358
	Size: 0xA1
	Parameters: 0
	Flags: None
*/
function validation()
{
	if(isdefined(self bgb::get_active()) && self bgb::get_active())
	{
		return 0;
	}
	if(isdefined(self.zombie_vars["zombie_powerup_minigun_on"]) && self.zombie_vars["zombie_powerup_minigun_on"])
	{
		return 0;
	}
	weap = self GetCurrentWeapon();
	return zm_weapons::can_upgrade_weapon(weap);
}

/*
	Name: activation
	Namespace: namespace_6d4de49
	Checksum: 0xFE4205DF
	Offset: 0x408
	Size: 0x483
	Parameters: 0
	Flags: None
*/
function activation()
{
	self endon("death");
	self endon("disconnect");
	self endon("bled_out");
	self endon("hash_cf1b207b");
	self util::waittill_any_timeout(1, "weapon_change_complete", "death", "disconnect", "bled_out", "replaced_upgraded_weapon");
	if(self laststand::player_is_in_laststand())
	{
		return;
	}
	if(isdefined(self.zombie_vars["zombie_powerup_minigun_on"]) && self.zombie_vars["zombie_powerup_minigun_on"])
	{
		return;
	}
	w_orig_weapon = self GetCurrentWeapon();
	self.var_fb11234e = w_orig_weapon;
	if(!zm_weapons::can_upgrade_weapon(w_orig_weapon))
	{
		return;
	}
	self zm_stats::increment_challenge_stat("GUM_GOBBLER_EPHEMERAL_ENHANCEMENT");
	n_orig_clip = self GetWeaponAmmoClip(w_orig_weapon);
	n_orig_stock = self GetWeaponAmmoStock(w_orig_weapon);
	w_upgraded_weapon = zm_weapons::get_upgrade_weapon(w_orig_weapon);
	w_upgraded_weapon = self zm_weapons::give_build_kit_weapon(w_upgraded_weapon);
	self GiveStartAmmo(w_upgraded_weapon);
	self SwitchToWeaponImmediate(w_upgraded_weapon);
	self TakeWeapon(w_orig_weapon, 1);
	self thread watch_for_upgraded_weapon_lost(w_upgraded_weapon);
	self bgb::run_timer(60);
	self notify("hash_5cefcc84");
	if(self laststand::player_is_in_laststand())
	{
		self waittill("player_revived");
	}
	if(isdefined(level.var_b6d13a4e))
	{
		[[level.var_b6d13a4e]]();
	}
	self.var_fb11234e = undefined;
	if(!self zm_weapons::has_weapon_or_attachments(w_upgraded_weapon))
	{
		return;
	}
	var_5ddb5ced = self GetWeaponAmmoClip(w_upgraded_weapon);
	var_398b66eb = self GetWeaponAmmoStock(w_upgraded_weapon);
	w_orig_weapon = self zm_weapons::switch_from_alt_weapon(w_orig_weapon);
	w_orig_weapon = self zm_weapons::give_build_kit_weapon(w_orig_weapon);
	if(var_5ddb5ced + var_398b66eb > n_orig_clip + n_orig_stock)
	{
		self GiveStartAmmo(w_orig_weapon);
		n_orig_clip = self GetWeaponAmmoClip(w_orig_weapon);
		n_orig_stock = self GetWeaponAmmoStock(w_orig_weapon);
		if(var_5ddb5ced + var_398b66eb < n_orig_clip + n_orig_stock)
		{
			n_orig_clip = var_5ddb5ced;
			n_orig_stock = var_398b66eb;
		}
	}
	self SetWeaponAmmoClip(w_orig_weapon, n_orig_clip);
	self SetWeaponAmmoStock(w_orig_weapon, n_orig_stock);
	current_weapon = self GetCurrentWeapon();
	if(current_weapon == w_upgraded_weapon)
	{
		self zm_weapons::switch_back_primary_weapon(w_orig_weapon, 1);
	}
	self TakeWeapon(w_upgraded_weapon, 1);
}

/*
	Name: watch_for_upgraded_weapon_lost
	Namespace: namespace_6d4de49
	Checksum: 0x81199122
	Offset: 0x898
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function watch_for_upgraded_weapon_lost(w_upgraded_weapon)
{
	self endon("death");
	self endon("disconnect");
	self endon("hash_994d5e9e");
	self endon("hash_5cefcc84");
	while(1)
	{
		self waittill("weapon_change_complete");
		if(!self zm_weapons::has_weapon_or_attachments(w_upgraded_weapon))
		{
			self notify("hash_cf1b207b");
			self.var_fb11234e = undefined;
			return;
		}
	}
}

