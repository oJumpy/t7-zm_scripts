#using scripts\codescripts\struct;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_clone;

/*
	Name: spawn_player_clone
	Namespace: zm_clone
	Checksum: 0x46C1B98D
	Offset: 0x1A8
	Size: 0x2F3
	Parameters: 4
	Flags: None
*/
function spawn_player_clone(player, origin, forceweapon, forcemodel)
{
	if(!isdefined(origin))
	{
		origin = player.origin;
	}
	primaryWeapons = player GetWeaponsListPrimaries();
	if(isdefined(forceweapon))
	{
		weapon = forceweapon;
	}
	else if(primaryWeapons.size)
	{
		weapon = primaryWeapons[0];
	}
	else
	{
		weapon = player GetCurrentWeapon();
	}
	weaponModel = weapon.worldmodel;
	spawner = GetEnt("fake_player_spawner", "targetname");
	if(isdefined(spawner))
	{
		clone = spawner SpawnFromSpawner();
		clone.origin = origin;
		clone.IsActor = 1;
	}
	else
	{
		clone = spawn("script_model", origin);
		clone.IsActor = 0;
	}
	if(isdefined(forcemodel))
	{
		clone SetModel(forcemodel);
	}
	else
	{
		mdl_body = player GetCharacterBodyModel();
		clone SetModel(mdl_body);
		bodyRenderOptions = player GetCharacterBodyRenderOptions();
		clone SetBodyRenderOptions(bodyRenderOptions, bodyRenderOptions, bodyRenderOptions);
	}
	if(weaponModel != "" && weaponModel != "none")
	{
		clone Attach(weaponModel, "tag_weapon_right");
	}
	clone.team = player.team;
	clone.is_inert = 1;
	clone.zombie_move_speed = "walk";
	clone.script_noteworthy = "corpse_clone";
	clone.actor_damage_func = &clone_damage_func;
	return clone;
}

/*
	Name: clone_damage_func
	Namespace: zm_clone
	Checksum: 0x2B27C8A2
	Offset: 0x4A8
	Size: 0xA1
	Parameters: 11
	Flags: None
*/
function clone_damage_func(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex)
{
	iDamage = 0;
	if(weapon.isBallisticKnife && zm_weapons::is_weapon_upgraded(weapon))
	{
		self notify("player_revived", eAttacker);
	}
	return iDamage;
}

/*
	Name: clone_give_weapon
	Namespace: zm_clone
	Checksum: 0x81E12050
	Offset: 0x558
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function clone_give_weapon(weapon)
{
	weaponModel = weapon.worldmodel;
	if(weaponModel != "" && weaponModel != "none")
	{
		self Attach(weaponModel, "tag_weapon_right");
	}
}

/*
	Name: clone_animate
	Namespace: zm_clone
	Checksum: 0x4348116F
	Offset: 0x5D0
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function clone_animate(animtype)
{
	if(self.IsActor)
	{
		self thread clone_actor_animate(animtype);
	}
	else
	{
		self thread clone_mover_animate(animtype);
	}
}

/*
	Name: clone_actor_animate
	Namespace: zm_clone
	Checksum: 0x47FBB9DC
	Offset: 0x628
	Size: 0x7D
	Parameters: 1
	Flags: None
*/
function clone_actor_animate(animtype)
{
	wait(0.1);
	switch(animtype)
	{
		case "laststand":
		{
			self SetAnimStateFromASD("laststand");
			break;
		}
		case "idle":
		case default:
		{
			self SetAnimStateFromASD("idle");
			break;
		}
	}
}

/*
	Name: clone_mover_animate
	Namespace: zm_clone
	Checksum: 0x853F6AF0
	Offset: 0x6B0
	Size: 0x12D
	Parameters: 1
	Flags: None
*/
function clone_mover_animate(animtype)
{
	self useanimtree(-1);
	switch(animtype)
	{
		case "laststand":
		{
			self SetAnim(%pb_laststand_idle);
			break;
		}
		case "afterlife":
		{
			self SetAnim(%pb_afterlife_laststand_idle);
			break;
		}
		case "chair":
		{
			self SetAnim(%ai_actor_elec_chair_idle);
			break;
		}
		case "falling":
		{
			self SetAnim(%pb_falling_loop);
			break;
		}
		case "idle":
		case default:
		{
			self SetAnim(%pb_stand_alert);
			break;
		}
	}
}

