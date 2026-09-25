#using scripts\codescripts\struct;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_lightning_chain;
#using scripts\zm\_zm_weapons;

#namespace _zm_weap_tesla;

/*
	Name: init
	Namespace: _zm_weap_tesla
	Checksum: 0x8B3BDCA7
	Offset: 0x340
	Size: 0x183
	Parameters: 0
	Flags: None
*/
function init()
{
	level.weaponZMTeslaGun = GetWeapon("tesla_gun");
	level.weaponZMTeslaGunUpgraded = GetWeapon("tesla_gun_upgraded");
	if(!zm_weapons::is_weapon_included(level.weaponZMTeslaGun) && (!isdefined(level.uses_tesla_powerup) && level.uses_tesla_powerup))
	{
		return;
	}
	level._effect["tesla_viewmodel_rail"] = "zombie/fx_tesla_rail_view_zmb";
	level._effect["tesla_viewmodel_tube"] = "zombie/fx_tesla_tube_view_zmb";
	level._effect["tesla_viewmodel_tube2"] = "zombie/fx_tesla_tube_view2_zmb";
	level._effect["tesla_viewmodel_tube3"] = "zombie/fx_tesla_tube_view3_zmb";
	level._effect["tesla_viewmodel_rail_upgraded"] = "zombie/fx_tesla_rail_view_ug_zmb";
	level._effect["tesla_viewmodel_tube_upgraded"] = "zombie/fx_tesla_tube_view_ug_zmb";
	level._effect["tesla_viewmodel_tube2_upgraded"] = "zombie/fx_tesla_tube_view2_ug_zmb";
	level._effect["tesla_viewmodel_tube3_upgraded"] = "zombie/fx_tesla_tube_view3_ug_zmb";
	level thread player_init();
	level thread tesla_notetrack_think();
}

/*
	Name: player_init
	Namespace: _zm_weap_tesla
	Checksum: 0x15C5CAF0
	Offset: 0x4D0
	Size: 0x10D
	Parameters: 0
	Flags: None
*/
function player_init()
{
	util::waitforclient(0);
	level.tesla_play_fx = [];
	level.tesla_play_rail = 1;
	players = GetLocalPlayers();
	for(i = 0; i < players.size; i++)
	{
		level.tesla_play_fx[i] = 0;
		players[i] thread tesla_fx_rail(i);
		players[i] thread tesla_fx_tube(i);
		players[i] thread tesla_happy(i);
		players[i] thread tesla_change_watcher(i);
	}
}

/*
	Name: tesla_fx_rail
	Namespace: _zm_weap_tesla
	Checksum: 0x504717F5
	Offset: 0x5E8
	Size: 0x1B7
	Parameters: 1
	Flags: None
*/
function tesla_fx_rail(localClientNum)
{
	self endon("disconnect");
	self endon("entityshutdown");
	for(;;)
	{
		WaitRealTime(RandomFloatRange(8, 12));
		if(!level.tesla_play_fx[localClientNum])
		{
			continue;
		}
		if(!level.tesla_play_rail)
		{
			continue;
		}
		currentWeapon = GetCurrentWeapon(localClientNum);
		if(currentWeapon != level.weaponZMTeslaGun && currentWeapon != level.weaponZMTeslaGunUpgraded)
		{
			continue;
		}
		if(IsADS(localClientNum) || IsThrowingGrenade(localClientNum) || IsMeleeing(localClientNum) || IsOnTurret(localClientNum))
		{
			continue;
		}
		if(GetWeaponAmmoClip(localClientNum, currentWeapon) <= 0)
		{
			continue;
		}
		FX = level._effect["tesla_viewmodel_rail"];
		if(currentWeapon == level.weaponZMTeslaGunUpgraded)
		{
			FX = level._effect["tesla_viewmodel_rail_upgraded"];
		}
		PlayViewmodelFX(localClientNum, FX, "tag_flash");
		playsound(localClientNum, "wpn_tesla_effects", (0, 0, 0));
	}
}

/*
	Name: tesla_fx_tube
	Namespace: _zm_weap_tesla
	Checksum: 0x993616FD
	Offset: 0x7A8
	Size: 0x34F
	Parameters: 1
	Flags: None
*/
function tesla_fx_tube(localClientNum)
{
	self endon("disconnect");
	self endon("entityshutdown");
	for(;;)
	{
		WaitRealTime(0.1);
		if(!level.tesla_play_fx[localClientNum])
		{
			continue;
		}
		w_current = GetCurrentWeapon(localClientNum);
		if(w_current != level.weaponZMTeslaGun && w_current != level.weaponZMTeslaGunUpgraded)
		{
			continue;
		}
		if(IsThrowingGrenade(localClientNum) || IsMeleeing(localClientNum) || IsOnTurret(localClientNum))
		{
			continue;
		}
		n_ammo = GetWeaponAmmoClip(localClientNum, w_current);
		if(n_ammo <= 0)
		{
			self clear_tesla_tube_effect(localClientNum);
			continue;
		}
		str_fx = level._effect["tesla_viewmodel_tube"];
		if(w_current == level.weaponZMTeslaGunUpgraded)
		{
			switch(n_ammo)
			{
				case 1:
				case 2:
				{
					str_fx = level._effect["tesla_viewmodel_tube3_upgraded"];
					n_tint = 2;
					break;
				}
				case 3:
				case 4:
				{
					str_fx = level._effect["tesla_viewmodel_tube2_upgraded"];
					n_tint = 1;
					break;
				}
				case default:
				{
					str_fx = level._effect["tesla_viewmodel_tube_upgraded"];
					n_tint = 0;
					break;
				}
			}
			break;
		}
		switch(n_ammo)
		{
			case 1:
			{
				str_fx = level._effect["tesla_viewmodel_tube3"];
				n_tint = 2;
				break;
			}
			case 2:
			{
				str_fx = level._effect["tesla_viewmodel_tube2"];
				n_tint = 1;
				break;
			}
			case default:
			{
				str_fx = level._effect["tesla_viewmodel_tube"];
				n_tint = 0;
				break;
			}
		}
		if(self.str_tesla_current_tube_effect === str_fx)
		{
			continue;
			continue;
		}
		if(isdefined(self.n_tesla_tube_fx_id))
		{
			deletefx(localClientNum, self.n_tesla_tube_fx_id, 1);
		}
		self.str_tesla_current_tube_effect = str_fx;
		self.n_tesla_tube_fx_id = PlayViewmodelFX(localClientNum, str_fx, "tag_brass");
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, 1, n_tint, 0);
	}
}

/*
	Name: tesla_notetrack_think
	Namespace: _zm_weap_tesla
	Checksum: 0xAB3D9D4
	Offset: 0xB00
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function tesla_notetrack_think()
{
	for(;;)
	{
		level waittill("Notetrack", localClientNum, note);
		switch(note)
		{
			case "tesla_play_fx_off":
			{
				level.tesla_play_fx[localClientNum] = 0;
				break;
			}
			case "tesla_play_fx_on":
			{
				level.tesla_play_fx[localClientNum] = 1;
				break;
			}
		}
	}
}

/*
	Name: tesla_happy
	Namespace: _zm_weap_tesla
	Checksum: 0x9B862F2B
	Offset: 0xB88
	Size: 0x9F
	Parameters: 1
	Flags: None
*/
function tesla_happy(localClientNum)
{
	for(;;)
	{
		level waittill("TGH");
		currentWeapon = GetCurrentWeapon(localClientNum);
		if(currentWeapon == level.weaponZMTeslaGun || currentWeapon == level.weaponZMTeslaGunUpgraded)
		{
			playsound(localClientNum, "wpn_tesla_happy", (0, 0, 0));
			level.tesla_play_rail = 0;
			WaitRealTime(2);
			level.tesla_play_rail = 1;
		}
	}
}

/*
	Name: tesla_change_watcher
	Namespace: _zm_weap_tesla
	Checksum: 0x7F2F6DCE
	Offset: 0xC30
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function tesla_change_watcher(localClientNum)
{
	self endon("disconnect");
	while(1)
	{
		self waittill("weapon_change");
		self clear_tesla_tube_effect(localClientNum);
	}
}

/*
	Name: clear_tesla_tube_effect
	Namespace: _zm_weap_tesla
	Checksum: 0xCB9E7778
	Offset: 0xC80
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function clear_tesla_tube_effect(localClientNum)
{
	if(isdefined(self.n_tesla_tube_fx_id))
	{
		deletefx(localClientNum, self.n_tesla_tube_fx_id, 1);
		self.n_tesla_tube_fx_id = undefined;
		self.str_tesla_current_tube_effect = undefined;
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, 1, 3, 0);
	}
}

