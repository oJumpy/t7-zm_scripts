#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_placeable_mine;

/*
	Name: __init__sytem__
	Namespace: zm_placeable_mine
	Checksum: 0xF8BBDC12
	Offset: 0x2A8
	Size: 0x2B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("placeable_mine", undefined, &__main__, undefined);
}

/*
	Name: __main__
	Namespace: zm_placeable_mine
	Checksum: 0x835E99C8
	Offset: 0x2E0
	Size: 0x23
	Parameters: 0
	Flags: Private
*/
function private __main__()
{
	if(isdefined(level.placeable_mines))
	{
		level thread replenish_after_rounds();
	}
}

/*
	Name: init_internal
	Namespace: zm_placeable_mine
	Checksum: 0x80B3D893
	Offset: 0x310
	Size: 0x6F
	Parameters: 0
	Flags: Private
*/
function private init_internal()
{
	if(isdefined(level.placeable_mines))
	{
		return;
	}
	level.placeable_mines = [];
	level.placeable_mines_on_damage = &placeable_mine_damage;
	level.pickup_placeable_mine = &pickup_placeable_mine;
	level.pickup_placeable_mine_trigger_listener = &pickup_placeable_mine_trigger_listener;
	level.placeable_mine_planted_callbacks = [];
}

/*
	Name: get_first_available
	Namespace: zm_placeable_mine
	Checksum: 0x49678755
	Offset: 0x388
	Size: 0x61
	Parameters: 0
	Flags: None
*/
function get_first_available()
{
	if(isdefined(level.placeable_mines) && level.placeable_mines.size > 0)
	{
		str_key = getArrayKeys(level.placeable_mines)[0];
		return level.placeable_mines[str_key];
	}
	return level.weaponNone;
}

/*
	Name: add_mine_type
	Namespace: zm_placeable_mine
	Checksum: 0xAA8A7E11
	Offset: 0x3F8
	Size: 0x71
	Parameters: 2
	Flags: None
*/
function add_mine_type(mine_name, str_retrieval_prompt)
{
	init_internal();
	weaponobjects::createRetrievableHint(mine_name, str_retrieval_prompt);
	level.placeable_mines[mine_name] = GetWeapon(mine_name);
	level.placeable_mine_planted_callbacks[mine_name] = [];
}

/*
	Name: add_weapon_to_mine_slot
	Namespace: zm_placeable_mine
	Checksum: 0xC8230F66
	Offset: 0x478
	Size: 0x91
	Parameters: 1
	Flags: None
*/
function add_weapon_to_mine_slot(mine_name)
{
	init_internal();
	level.placeable_mines[mine_name] = GetWeapon(mine_name);
	level.placeable_mine_planted_callbacks[mine_name] = [];
	if(!isdefined(level.placeable_mines_in_name_only))
	{
		level.placeable_mines_in_name_only = [];
	}
	level.placeable_mines_in_name_only[mine_name] = GetWeapon(mine_name);
}

/*
	Name: set_max_per_player
	Namespace: zm_placeable_mine
	Checksum: 0xF6D4CEF8
	Offset: 0x518
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function set_max_per_player(n_max_per_player)
{
	level.placeable_mines_max_per_player = n_max_per_player;
}

/*
	Name: add_planted_callback
	Namespace: zm_placeable_mine
	Checksum: 0x485A70A1
	Offset: 0x538
	Size: 0xAF
	Parameters: 2
	Flags: None
*/
function add_planted_callback(fn_planted_cb, wpn_name)
{
	if(!isdefined(level.placeable_mine_planted_callbacks[wpn_name]))
	{
		level.placeable_mine_planted_callbacks[wpn_name] = [];
	}
	else if(!IsArray(level.placeable_mine_planted_callbacks[wpn_name]))
	{
		level.placeable_mine_planted_callbacks[wpn_name] = Array(level.placeable_mine_planted_callbacks[wpn_name]);
	}
	level.placeable_mine_planted_callbacks[wpn_name][level.placeable_mine_planted_callbacks[wpn_name].size] = fn_planted_cb;
}

/*
	Name: run_planted_callbacks
	Namespace: zm_placeable_mine
	Checksum: 0x2D51C8F1
	Offset: 0x5F0
	Size: 0x9F
	Parameters: 1
	Flags: Private
*/
function private run_planted_callbacks(e_planter)
{
	foreach(fn in level.placeable_mine_planted_callbacks[self.weapon.name])
	{
		self thread [[fn]](e_planter);
	}
}

/*
	Name: safe_to_plant
	Namespace: zm_placeable_mine
	Checksum: 0xDF12834A
	Offset: 0x698
	Size: 0x33
	Parameters: 0
	Flags: Private
*/
function private safe_to_plant()
{
	if(isdefined(level.placeable_mines_max_per_player) && self.owner.placeable_mines.size >= level.placeable_mines_max_per_player)
	{
		return 0;
	}
	return 1;
}

/*
	Name: wait_and_detonate
	Namespace: zm_placeable_mine
	Checksum: 0xEA0A8BE2
	Offset: 0x6D8
	Size: 0x2B
	Parameters: 0
	Flags: Private
*/
function private wait_and_detonate()
{
	wait(0.1);
	self detonate(self.owner);
}

/*
	Name: mine_watch
	Namespace: zm_placeable_mine
	Checksum: 0xF8466FE8
	Offset: 0x710
	Size: 0x15F
	Parameters: 1
	Flags: Private
*/
function private mine_watch(wpn_type)
{
	self endon("death");
	self notify("mine_watch");
	self endon("mine_watch");
	while(1)
	{
		self waittill("grenade_fire", mine, fired_weapon);
		if(fired_weapon == wpn_type)
		{
			mine.owner = self;
			mine.team = self.team;
			mine.weapon = fired_weapon;
			self notify("zmb_enable_" + fired_weapon.name + "_prompt");
			if(mine safe_to_plant())
			{
				mine run_planted_callbacks(self);
				self zm_stats::increment_client_stat(fired_weapon.name + "_planted");
				self zm_stats::increment_player_stat(fired_weapon.name + "_planted");
			}
			else
			{
				mine thread wait_and_detonate();
			}
		}
	}
}

/*
	Name: is_true_placeable_mine
	Namespace: zm_placeable_mine
	Checksum: 0xB8D25709
	Offset: 0x878
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function is_true_placeable_mine(mine_name)
{
	if(!isdefined(level.placeable_mines_in_name_only))
	{
		return 1;
	}
	if(!isdefined(level.placeable_mines_in_name_only[mine_name]))
	{
		return 1;
	}
	return 0;
}

/*
	Name: setup_for_player
	Namespace: zm_placeable_mine
	Checksum: 0xE6820507
	Offset: 0x8C0
	Size: 0x16F
	Parameters: 2
	Flags: None
*/
function setup_for_player(wpn_type, ui_model)
{
	if(!isdefined(ui_model))
	{
		ui_model = "hudItems.showDpadRight";
	}
	if(!isdefined(self.placeable_mines))
	{
		self.placeable_mines = [];
	}
	if(isdefined(self.last_placeable_mine_uimodel))
	{
		self clientfield::set_player_uimodel(self.last_placeable_mine_uimodel, 0);
	}
	if(is_true_placeable_mine(wpn_type.name))
	{
		self thread mine_watch(wpn_type);
	}
	self GiveWeapon(wpn_type);
	self zm_utility::set_player_placeable_mine(wpn_type);
	self SetActionSlot(4, "weapon", wpn_type);
	startammo = wpn_type.startammo;
	if(startammo)
	{
		self SetWeaponAmmoStock(wpn_type, startammo);
	}
	if(isdefined(ui_model))
	{
		self clientfield::set_player_uimodel(ui_model, 1);
	}
	self.last_placeable_mine_uimodel = ui_model;
}

/*
	Name: disable_prompt_for_player
	Namespace: zm_placeable_mine
	Checksum: 0x56BD53EA
	Offset: 0xA38
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function disable_prompt_for_player(wpn_type)
{
	self notify("zmb_disable_" + wpn_type.name + "_prompt");
}

/*
	Name: disable_all_prompts_for_player
	Namespace: zm_placeable_mine
	Checksum: 0x97206E3D
	Offset: 0xA70
	Size: 0x89
	Parameters: 0
	Flags: None
*/
function disable_all_prompts_for_player()
{
	foreach(mine in level.placeable_mines)
	{
		self disable_prompt_for_player(mine);
	}
}

/*
	Name: pickup_placeable_mine
	Namespace: zm_placeable_mine
	Checksum: 0xC346B41B
	Offset: 0xB08
	Size: 0x2BB
	Parameters: 0
	Flags: Private
*/
function private pickup_placeable_mine()
{
	player = self.owner;
	wpn_type = self.weapon;
	if(player.IS_DRINKING > 0)
	{
		return;
	}
	current_player_mine = player zm_utility::get_player_placeable_mine();
	if(current_player_mine != wpn_type)
	{
		player TakeWeapon(current_player_mine);
	}
	if(!player HasWeapon(wpn_type))
	{
		player thread mine_watch(wpn_type);
		player GiveWeapon(wpn_type);
		player zm_utility::set_player_placeable_mine(wpn_type);
		player SetActionSlot(4, "weapon", wpn_type);
		player SetWeaponAmmoClip(wpn_type, 0);
		player notify("zmb_enable_" + wpn_type.name + "_prompt");
	}
	else
	{
		clip_ammo = player GetWeaponAmmoClip(wpn_type);
		clip_max_ammo = wpn_type.clipSize;
		if(clip_ammo >= clip_max_ammo)
		{
			self zm_utility::destroy_ent();
			player disable_prompt_for_player(wpn_type);
			return;
		}
	}
	self zm_utility::pick_up();
	clip_ammo = player GetWeaponAmmoClip(wpn_type);
	clip_max_ammo = wpn_type.clipSize;
	if(clip_ammo >= clip_max_ammo)
	{
		player disable_prompt_for_player(wpn_type);
	}
	player zm_stats::increment_client_stat(wpn_type.name + "_pickedup");
	player zm_stats::increment_player_stat(wpn_type.name + "_pickedup");
}

/*
	Name: pickup_placeable_mine_trigger_listener
	Namespace: zm_placeable_mine
	Checksum: 0x9C0CE992
	Offset: 0xDD0
	Size: 0x53
	Parameters: 2
	Flags: Private
*/
function private pickup_placeable_mine_trigger_listener(trigger, player)
{
	self thread pickup_placeable_mine_trigger_listener_enable(trigger, player);
	self thread pickup_placeable_mine_trigger_listener_disable(trigger, player);
}

/*
	Name: pickup_placeable_mine_trigger_listener_enable
	Namespace: zm_placeable_mine
	Checksum: 0x76825AD7
	Offset: 0xE30
	Size: 0xB7
	Parameters: 2
	Flags: Private
*/
function private pickup_placeable_mine_trigger_listener_enable(trigger, player)
{
	self endon("delete");
	self endon("death");
	while(1)
	{
		player util::waittill_any("zmb_enable_" + self.weapon.name + "_prompt", "spawned_player");
		if(!isdefined(trigger))
		{
			return;
		}
		trigger TriggerEnable(1);
		trigger LinkTo(self);
	}
}

/*
	Name: pickup_placeable_mine_trigger_listener_disable
	Namespace: zm_placeable_mine
	Checksum: 0xE3D0407E
	Offset: 0xEF0
	Size: 0x97
	Parameters: 2
	Flags: Private
*/
function private pickup_placeable_mine_trigger_listener_disable(trigger, player)
{
	self endon("delete");
	self endon("death");
	while(1)
	{
		player waittill("zmb_disable_" + self.weapon.name + "_prompt");
		if(!isdefined(trigger))
		{
			return;
		}
		trigger Unlink();
		trigger TriggerEnable(0);
	}
}

/*
	Name: placeable_mine_damage
	Namespace: zm_placeable_mine
	Checksum: 0x69C4B4EE
	Offset: 0xF90
	Size: 0x1AB
	Parameters: 0
	Flags: Private
*/
function private placeable_mine_damage()
{
	self endon("death");
	self SetCanDamage(1);
	self.health = 100000;
	self.maxhealth = self.health;
	attacker = undefined;
	while(1)
	{
		self waittill("damage", amount, attacker);
		if(!isdefined(self))
		{
			return;
		}
		self.health = self.maxhealth;
		if(!isPlayer(attacker))
		{
			continue;
		}
		if(isdefined(self.owner) && attacker == self.owner)
		{
			continue;
		}
		if(isdefined(attacker.pers) && isdefined(attacker.pers["team"]) && attacker.pers["team"] != level.zombie_team)
		{
			continue;
		}
		break;
	}
	if(level.satchelexplodethisframe)
	{
		wait(0.1 + RandomFloat(0.4));
	}
	else
	{
		wait(0.05);
	}
	if(!isdefined(self))
	{
		return;
	}
	level.satchelexplodethisframe = 1;
	thread reset_satchel_explode_this_frame();
	self detonate(attacker);
}

/*
	Name: reset_satchel_explode_this_frame
	Namespace: zm_placeable_mine
	Checksum: 0x36342F21
	Offset: 0x1148
	Size: 0x17
	Parameters: 0
	Flags: Private
*/
function private reset_satchel_explode_this_frame()
{
	wait(0.05);
	level.satchelexplodethisframe = 0;
}

/*
	Name: replenish_after_rounds
	Namespace: zm_placeable_mine
	Checksum: 0x977C8570
	Offset: 0x1168
	Size: 0x213
	Parameters: 0
	Flags: Private
*/
function private replenish_after_rounds()
{
	while(1)
	{
		level waittill("between_round_over");
		if(isdefined(level.func_custom_placeable_mine_round_replenish))
		{
			[[level.func_custom_placeable_mine_round_replenish]]();
			continue;
		}
		if(!level flag::exists("teleporter_used") || !level flag::get("teleporter_used"))
		{
			players = GetPlayers();
			for(i = 0; i < players.size; i++)
			{
				foreach(mine in level.placeable_mines)
				{
					if(players[i] zm_utility::is_player_placeable_mine(mine) && is_true_placeable_mine(mine.name))
					{
						players[i] GiveWeapon(mine);
						players[i] zm_utility::set_player_placeable_mine(mine);
						players[i] SetActionSlot(4, "weapon", mine);
						players[i] SetWeaponAmmoClip(mine, 2);
						break;
					}
				}
			}
		}
	}
}

/*
	Name: setup_watchers
	Namespace: zm_placeable_mine
	Checksum: 0x9343B07D
	Offset: 0x1388
	Size: 0x171
	Parameters: 0
	Flags: None
*/
function setup_watchers()
{
	if(isdefined(level.placeable_mines))
	{
		foreach(mine_type in level.placeable_mines)
		{
			watcher = self weaponobjects::createUseWeaponObjectWatcher(mine_type.name, self.team);
			watcher.onSpawnRetrieveTriggers = &on_spawn_retrieve_trigger;
			watcher.adjustTriggerOrigin = &adjust_trigger_origin;
			watcher.pickup = level.pickup_placeable_mine;
			watcher.pickup_trigger_listener = level.pickup_placeable_mine_trigger_listener;
			watcher.skip_weapon_object_damage = 1;
			watcher.headicon = 0;
			watcher.watchForFire = 1;
			watcher.onDetonateCallback = &placeable_mine_detonate;
			watcher.onDamage = level.placeable_mines_on_damage;
		}
	}
}

/*
	Name: on_spawn_retrieve_trigger
	Namespace: zm_placeable_mine
	Checksum: 0x7C620D33
	Offset: 0x1508
	Size: 0x5B
	Parameters: 2
	Flags: Private
*/
function private on_spawn_retrieve_trigger(watcher, player)
{
	self weaponobjects::onSpawnRetrievableWeaponObject(watcher, player);
	if(isdefined(self.pickupTrigger))
	{
		self.pickupTrigger SetHintLowPriority(0);
	}
}

/*
	Name: adjust_trigger_origin
	Namespace: zm_placeable_mine
	Checksum: 0xC501C98E
	Offset: 0x1570
	Size: 0x27
	Parameters: 1
	Flags: Private
*/
function private adjust_trigger_origin(origin)
{
	origin = origin + VectorScale((0, 0, 1), 20);
	return origin;
}

/*
	Name: placeable_mine_detonate
	Namespace: zm_placeable_mine
	Checksum: 0x3FB965AA
	Offset: 0x15A0
	Size: 0xCB
	Parameters: 3
	Flags: Private
*/
function private placeable_mine_detonate(attacker, weapon, target)
{
	if(weapon.isEmp)
	{
		self delete();
		return;
	}
	if(isdefined(attacker))
	{
		self detonate(attacker);
	}
	else if(isdefined(self.owner) && isPlayer(self.owner))
	{
		self detonate(self.owner);
	}
	else
	{
		self detonate();
	}
}

