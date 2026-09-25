#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace proximity_grenade;

/*
	Name: init_shared
	Namespace: proximity_grenade
	Checksum: 0x666763F5
	Offset: 0x2F0
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	clientfield::register("toplayer", "tazered", 1, 1, "int", undefined, 0, 0);
	level._effect["prox_grenade_friendly_default"] = "weapon/fx_prox_grenade_scan_blue";
	level._effect["prox_grenade_friendly_warning"] = "weapon/fx_prox_grenade_wrn_grn";
	level._effect["prox_grenade_enemy_default"] = "weapon/fx_prox_grenade_scan_orng";
	level._effect["prox_grenade_enemy_warning"] = "weapon/fx_prox_grenade_wrn_red";
	level._effect["prox_grenade_player_shock"] = "weapon/fx_prox_grenade_impact_player_spwner";
	callback::add_weapon_type("proximity_grenade", &proximity_spawned);
	level thread watchForProximityExplosion();
}

/*
	Name: proximity_spawned
	Namespace: proximity_grenade
	Checksum: 0xE3118A1E
	Offset: 0x400
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function proximity_spawned(localClientNum)
{
	if(self isGrenadeDud())
	{
		return;
	}
	self.equipmentFriendFX = level._effect["prox_grenade_friendly_default"];
	self.equipmentEnemyFX = level._effect["prox_grenade_enemy_default"];
	self.equipmentTagFX = "tag_fx";
	self thread weaponobjects::equipmentTeamObject(localClientNum);
}

/*
	Name: watchForProximityExplosion
	Namespace: proximity_grenade
	Checksum: 0xC1A64E51
	Offset: 0x490
	Size: 0x197
	Parameters: 0
	Flags: None
*/
function watchForProximityExplosion()
{
	if(GetActiveLocalClients() > 1)
	{
		return;
	}
	weapon_proximity = GetWeapon("proximity_grenade");
	while(1)
	{
		level waittill("explode", localClientNum, position, mod, weapon, owner_cent);
		if(weapon.rootweapon != weapon_proximity)
		{
			continue;
		}
		localPlayer = GetLocalPlayer(localClientNum);
		if(!localPlayer util::is_player_view_linked_to_entity(localClientNum))
		{
			explosionRadius = weapon.explosionRadius;
			if(DistanceSquared(localPlayer.origin, position) < explosionRadius * explosionRadius)
			{
				if(isdefined(owner_cent))
				{
					if(owner_cent == localPlayer || !owner_cent util::friend_not_foe(localClientNum, 1))
					{
						localPlayer thread postfx::playPostfxBundle("pstfx_shock_charge");
					}
				}
			}
		}
	}
}

