#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_utility;
#using scripts\zm\gametypes\_spawnlogic;
#using scripts\zm\gametypes\_zm_gametype;

#namespace zm_turned;

/*
	Name: init
	Namespace: zm_turned
	Checksum: 0x332C7349
	Offset: 0x3D8
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function init()
{
	dvar = GetDvarString("ui_gametype");
	if(dvar == "zcleansed")
	{
		level.var_c20c02c0 = GetWeapon("zombiemelee");
		level.var_eef57dd3 = GetWeapon("zombiemelee_dw");
		if(!isdefined(level.vsmgr_prio_visionset_zombie_turned))
		{
			level.vsmgr_prio_visionset_zombie_turned = 123;
		}
		visionset_mgr::register_info("visionset", "zombie_turned", 1, level.vsmgr_prio_visionset_zombie_turned, 1, 1);
		clientfield::register("toplayer", "turned_ir", 1, 1, "int");
		clientfield::register("allplayers", "player_has_eyes", 1, 1, "int");
		clientfield::register("allplayers", "player_eyes_special", 1, 1, "int");
		thread setup_zombie_exerts();
	}
}

/*
	Name: setup_zombie_exerts
	Namespace: zm_turned
	Checksum: 0x8E533754
	Offset: 0x550
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function setup_zombie_exerts()
{
	wait(0.05);
	level.exert_sounds[1]["burp"] = "null";
	level.exert_sounds[1]["hitmed"] = "null";
	level.exert_sounds[1]["hitlrg"] = "null";
}

/*
	Name: delay_turning_on_eyes
	Namespace: zm_turned
	Checksum: 0x220671CE
	Offset: 0x5C8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function delay_turning_on_eyes()
{
	self endon("death");
	self endon("disconnect");
	util::wait_network_frame();
	wait(0.1);
	self clientfield::set("player_has_eyes", 1);
}

/*
	Name: turn_to_zombie
	Namespace: zm_turned
	Checksum: 0x2E9A3AD5
	Offset: 0x628
	Size: 0x6C7
	Parameters: 0
	Flags: None
*/
function turn_to_zombie()
{
	if(self.sessionstate == "playing" && (isdefined(self.is_zombie) && self.is_zombie) && (!isdefined(self.laststand) && self.laststand))
	{
		return;
	}
	if(isdefined(self.is_in_process_of_zombify) && self.is_in_process_of_zombify)
	{
		return;
	}
	while(isdefined(self.is_in_process_of_humanify) && self.is_in_process_of_humanify)
	{
		wait(0.1);
	}
	if(!level flag::get("pregame"))
	{
		self playsoundtoplayer("evt_spawn", self);
		playsoundatposition("evt_disappear_3d", self.origin);
		if(!self.is_zombie)
		{
			playsoundatposition("vox_plr_" + randomIntRange(0, 4) + "_exert_death_high_" + randomIntRange(0, 4), self.origin);
		}
	}
	self._can_score = 1;
	self clientfield::set("player_has_eyes", 0);
	self ghost();
	self turned_disable_player_weapons();
	self notify("clear_red_flashing_overlay");
	self notify("zombify");
	self.is_in_process_of_zombify = 1;
	self.team = level.zombie_team;
	self.pers["team"] = level.zombie_team;
	self.sessionteam = level.zombie_team;
	util::wait_network_frame();
	self zm_gametype::onSpawnPlayer();
	self FreezeControls(1);
	self.is_zombie = 1;
	self setburn(0);
	if(isdefined(self.turned_visionset) && self.turned_visionset)
	{
		visionset_mgr::deactivate("visionset", "zombie_turned", self);
		util::wait_network_frame();
		util::wait_network_frame();
		if(!isdefined(self))
		{
			return;
		}
	}
	visionset_mgr::activate("visionset", "zombie_turned", self);
	self.turned_visionset = 1;
	self clientfield::set_to_player("turned_ir", 1);
	self zm_audio::SetExertVoice(1);
	self.laststand = undefined;
	util::wait_network_frame();
	if(!isdefined(self))
	{
		return;
	}
	self enableWeapons();
	self show();
	playsoundatposition("evt_appear_3d", self.origin);
	playsoundatposition("zmb_zombie_spawn", self.origin);
	self thread delay_turning_on_eyes();
	self thread turned_player_buttons();
	self setPerk("specialty_playeriszombie");
	self setPerk("specialty_unlimitedsprint");
	self setPerk("specialty_fallheight");
	self turned_give_melee_weapon();
	self setMoveSpeedScale(1);
	self.animName = "zombie";
	self disableOffhandWeapons();
	self AllowStand(1);
	self AllowProne(0);
	self AllowCrouch(0);
	self AllowAds(0);
	self AllowJump(0);
	self DisableWeaponCycling();
	self setMoveSpeedScale(1);
	self SetSprintDuration(4);
	self SetSprintCooldown(0);
	self StopShellshock();
	self.maxhealth = 256;
	self.health = 256;
	self.meleeDamage = 1000;
	self DetachAll();
	if(isdefined(level.custom_zombie_player_loadout))
	{
		self [[level.custom_zombie_player_loadout]]();
	}
	else
	{
		self SetModel("c_zom_player_zombie_fb");
		self.voice = "american";
		self.skeleton = "base";
	}
	self.shock_onpain = 0;
	self DisableInvulnerability();
	if(isdefined(level.player_movement_suppressed))
	{
		self FreezeControls(level.player_movement_suppressed);
	}
	else if(!(isdefined(self.hostMigrationControlsFrozen) && self.hostMigrationControlsFrozen))
	{
		self FreezeControls(0);
	}
	self.is_in_process_of_zombify = 0;
}

/*
	Name: turn_to_human
	Namespace: zm_turned
	Checksum: 0x7F7E6FC2
	Offset: 0xCF8
	Size: 0x547
	Parameters: 0
	Flags: None
*/
function turn_to_human()
{
	if(self.sessionstate == "playing" && (!isdefined(self.is_zombie) && self.is_zombie) && (!isdefined(self.laststand) && self.laststand))
	{
		return;
	}
	if(isdefined(self.is_in_process_of_humanify) && self.is_in_process_of_humanify)
	{
		return;
	}
	while(isdefined(self.is_in_process_of_zombify) && self.is_in_process_of_zombify)
	{
		wait(0.1);
	}
	self playsoundtoplayer("evt_spawn", self);
	playsoundatposition("evt_disappear_3d", self.origin);
	self clientfield::set("player_has_eyes", 0);
	self ghost();
	self notify("humanify");
	self.is_in_process_of_humanify = 1;
	self.is_zombie = 0;
	self notify("clear_red_flashing_overlay");
	self.team = self.prevteam;
	self.pers["team"] = self.prevteam;
	self.sessionteam = self.prevteam;
	util::wait_network_frame();
	self zm_gametype::onSpawnPlayer();
	self.maxhealth = 100;
	self.health = 100;
	self FreezeControls(1);
	if(self HasWeapon(level.weaponZMDeathThroe))
	{
		self TakeWeapon(level.weaponZMDeathThroe);
	}
	self unsetPerk("specialty_playeriszombie");
	self unsetPerk("specialty_unlimitedsprint");
	self unsetPerk("specialty_fallheight");
	self turned_enable_player_weapons();
	self zm_audio::SetExertVoice(0);
	self.turned_visionset = 0;
	visionset_mgr::deactivate("visionset", "zombie_turned", self);
	self clientfield::set_to_player("turned_ir", 0);
	self setMoveSpeedScale(1);
	self.ignoreme = 0;
	self.shock_onpain = 1;
	self EnableWeaponCycling();
	self AllowStand(1);
	self AllowProne(1);
	self AllowCrouch(1);
	self AllowAds(1);
	self AllowJump(1);
	self TurnedHuman();
	self EnableOffhandWeapons();
	self StopShellshock();
	self.laststand = undefined;
	self.is_burning = undefined;
	self.meleeDamage = undefined;
	self DetachAll();
	self [[level.giveCustomCharacters]]();
	if(!self HasWeapon(level.weaponBaseMelee))
	{
		self GiveWeapon(level.weaponBaseMelee);
	}
	util::wait_network_frame();
	if(!isdefined(self))
	{
		return;
	}
	self DisableInvulnerability();
	if(isdefined(level.player_movement_suppressed))
	{
		self FreezeControls(level.player_movement_suppressed);
	}
	else if(!(isdefined(self.hostMigrationControlsFrozen) && self.hostMigrationControlsFrozen))
	{
		self FreezeControls(0);
	}
	self show();
	playsoundatposition("evt_appear_3d", self.origin);
	self.is_in_process_of_humanify = 0;
}

/*
	Name: deleteZombiesInRadius
	Namespace: zm_turned
	Checksum: 0x74FDE542
	Offset: 0x1248
	Size: 0x171
	Parameters: 1
	Flags: None
*/
function deleteZombiesInRadius(origin)
{
	zombies = zombie_utility::get_round_enemy_array();
	maxRadius = 128;
	foreach(zombie in zombies)
	{
		if(isdefined(zombie) && isalive(zombie) && (!isdefined(zombie.is_being_used_as_spawner) && zombie.is_being_used_as_spawner))
		{
			if(DistanceSquared(zombie.origin, origin) < maxRadius * maxRadius)
			{
				playFX(level._effect["wood_chunk_destory"], zombie.origin);
				zombie thread silentlyRemoveZombie();
			}
			wait(0.05);
		}
	}
}

/*
	Name: turned_give_melee_weapon
	Namespace: zm_turned
	Checksum: 0x23B29F0F
	Offset: 0x13C8
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function turned_give_melee_weapon()
{
	/#
		Assert(isdefined(self.var_c20c02c0));
	#/
	/#
		Assert(self.var_c20c02c0 != level.weaponNone);
	#/
	self.turned_had_knife = self HasWeapon(level.weaponBaseMelee);
	if(isdefined(self.turned_had_knife) && self.turned_had_knife)
	{
		self TakeWeapon(level.weaponBaseMelee);
	}
	self GiveWeapon(self.var_eef57dd3);
	self giveMaxAmmo(self.var_eef57dd3);
	self GiveWeapon(self.var_c20c02c0);
	self giveMaxAmmo(self.var_c20c02c0);
	self SwitchToWeapon(self.var_eef57dd3);
	self SwitchToWeapon(self.var_c20c02c0);
}

/*
	Name: turned_player_buttons
	Namespace: zm_turned
	Checksum: 0x16CAAFE3
	Offset: 0x1538
	Size: 0x1B3
	Parameters: 0
	Flags: None
*/
function turned_player_buttons()
{
	self endon("disconnect");
	self endon("humanify");
	level endon("end_game");
	while(isdefined(self.is_zombie) && self.is_zombie)
	{
		if(self AttackButtonPressed() || self AdsButtonPressed() || self meleeButtonPressed())
		{
			if(math::cointoss())
			{
				self notify("bhtn_action_notify", "attack");
			}
			while(self AttackButtonPressed() || self AdsButtonPressed() || self meleeButtonPressed())
			{
				wait(0.05);
			}
		}
		if(self useButtonPressed())
		{
			self notify("bhtn_action_notify", "taunt");
			while(self useButtonPressed())
			{
				wait(0.05);
			}
		}
		if(self issprinting())
		{
			while(self issprinting())
			{
				self notify("bhtn_action_notify", "sprint");
				wait(0.05);
			}
		}
		wait(0.05);
	}
}

/*
	Name: turned_disable_player_weapons
	Namespace: zm_turned
	Checksum: 0xC8E68765
	Offset: 0x16F8
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function turned_disable_player_weapons()
{
	if(isdefined(self.is_zombie) && self.is_zombie)
	{
		return;
	}
	weaponInventory = self GetWeaponsList();
	self.lastActiveWeapon = self GetCurrentWeapon();
	self SetLastStandPrevWeap(self.lastActiveWeapon);
	self.laststandpistol = undefined;
	self.hadpistol = 0;
	if(!isdefined(self.var_c20c02c0))
	{
		self.var_c20c02c0 = level.var_c20c02c0;
	}
	if(!isdefined(self.var_eef57dd3))
	{
		self.var_eef57dd3 = level.var_eef57dd3;
	}
	self TakeAllWeapons();
	self DisableWeaponCycling();
}

/*
	Name: turned_enable_player_weapons
	Namespace: zm_turned
	Checksum: 0xFAA999E1
	Offset: 0x17F8
	Size: 0x2A3
	Parameters: 0
	Flags: None
*/
function turned_enable_player_weapons()
{
	self TakeAllWeapons();
	self EnableWeaponCycling();
	self EnableOffhandWeapons();
	self.turned_had_knife = undefined;
	var_bf2681a = GetWeapon("rottweil72");
	if(isdefined(level.humanify_custom_loadout))
	{
		self thread [[level.humanify_custom_loadout]]();
		return;
	}
	else if(!self HasWeapon(var_bf2681a))
	{
		self GiveWeapon(var_bf2681a);
		self SwitchToWeapon(var_bf2681a);
	}
	if(!isdefined(self.is_zombie) && self.is_zombie && !self HasWeapon(level.start_weapon))
	{
		if(!self HasWeapon(level.weaponBaseMelee))
		{
			self GiveWeapon(level.weaponBaseMelee);
		}
		self zm_utility::give_start_weapon(0);
	}
	if(self HasWeapon(var_bf2681a))
	{
		self SetWeaponAmmoClip(var_bf2681a, 2);
		self SetWeaponAmmoStock(var_bf2681a, 0);
	}
	if(self HasWeapon(level.start_weapon))
	{
		self giveMaxAmmo(level.start_weapon);
	}
	if(self HasWeapon(self zm_utility::get_player_lethal_grenade()))
	{
		self GetWeaponAmmoClip(self zm_utility::get_player_lethal_grenade());
	}
	else
	{
		self GiveWeapon(self zm_utility::get_player_lethal_grenade());
	}
	self SetWeaponAmmoClip(self zm_utility::get_player_lethal_grenade(), 2);
}

/*
	Name: get_farthest_available_zombie
	Namespace: zm_turned
	Checksum: 0x91450807
	Offset: 0x1AA8
	Size: 0x193
	Parameters: 1
	Flags: None
*/
function get_farthest_available_zombie(player)
{
	while(1)
	{
		zombies = Array::get_all_closest(player.origin, GetAITeamArray(level.zombie_team));
		for(x = 0; x < zombies.size; x++)
		{
			zombie = zombies[x];
			if(isdefined(zombie) && isalive(zombie) && (!isdefined(zombie.in_the_ground) && zombie.in_the_ground) && (!isdefined(zombie.gibbed) && zombie.gibbed) && (!isdefined(zombie.head_gibbed) && zombie.head_gibbed) && (!isdefined(zombie.is_being_used_as_spawnpoint) && zombie.is_being_used_as_spawnpoint) && zombie zm_utility::in_playable_area())
			{
				zombie.is_being_used_as_spawnpoint = 1;
				return zombie;
			}
		}
		wait(0.05);
	}
}

/*
	Name: get_available_human
	Namespace: zm_turned
	Checksum: 0x71B511D6
	Offset: 0x1C48
	Size: 0xB9
	Parameters: 0
	Flags: None
*/
function get_available_human()
{
	players = GetPlayers();
	foreach(player in players)
	{
		if(!(isdefined(player.is_zombie) && player.is_zombie))
		{
			return player;
		}
	}
}

/*
	Name: silentlyRemoveZombie
	Namespace: zm_turned
	Checksum: 0xE30F7BF3
	Offset: 0x1D10
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function silentlyRemoveZombie()
{
	self.skip_death_notetracks = 1;
	self.nodeathragdoll = 1;
	self DoDamage(self.maxhealth * 2, self.origin, self, self, "none", "MOD_SUICIDE");
	self zm_utility::self_delete();
}

/*
	Name: getSpawnPoint
	Namespace: zm_turned
	Checksum: 0xF427A550
	Offset: 0x1D90
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function getSpawnPoint()
{
	spawnpoint = self spawnlogic::getSpawnpoint_DM(level._turned_zombie_respawnpoints);
	return spawnpoint;
}

