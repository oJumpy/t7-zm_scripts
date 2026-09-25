#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#namespace zm_game_module;

/*
	Name: register_game_module
	Namespace: zm_game_module
	Checksum: 0xB699760B
	Offset: 0x210
	Size: 0x237
	Parameters: 7
	Flags: None
*/
function register_game_module(index, module_name, pre_init_func, post_init_func, pre_init_zombie_spawn_func, post_init_zombie_spawn_func, hub_start_func)
{
	if(!isdefined(level._game_modules))
	{
		level._game_modules = [];
		level._num_registered_game_modules = 0;
	}
	for(i = 0; i < level._num_registered_game_modules; i++)
	{
		if(!isdefined(level._game_modules[i]))
		{
			continue;
		}
		if(isdefined(level._game_modules[i].index) && level._game_modules[i].index == index)
		{
			/#
				Assert(level._game_modules[i].index != index, "Dev Block strings are not supported" + index + "Dev Block strings are not supported");
			#/
		}
	}
	level._game_modules[level._num_registered_game_modules] = spawnstruct();
	level._game_modules[level._num_registered_game_modules].index = index;
	level._game_modules[level._num_registered_game_modules].module_name = module_name;
	level._game_modules[level._num_registered_game_modules].pre_init_func = pre_init_func;
	level._game_modules[level._num_registered_game_modules].post_init_func = post_init_func;
	level._game_modules[level._num_registered_game_modules].pre_init_zombie_spawn_func = pre_init_zombie_spawn_func;
	level._game_modules[level._num_registered_game_modules].post_init_zombie_spawn_func = post_init_zombie_spawn_func;
	level._game_modules[level._num_registered_game_modules].hub_start_func = hub_start_func;
	level._num_registered_game_modules++;
}

/*
	Name: set_current_game_module
	Namespace: zm_game_module
	Checksum: 0xC303764
	Offset: 0x450
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function set_current_game_module(game_module_index)
{
	if(!isdefined(game_module_index))
	{
		level.current_game_module = level.GAME_MODULE_CLASSIC_INDEX;
		level.scr_zm_game_module = level.GAME_MODULE_CLASSIC_INDEX;
		return;
	}
	game_module = get_game_module(game_module_index);
	if(!isdefined(game_module))
	{
		/#
			Assert(isdefined(game_module), "Dev Block strings are not supported" + game_module_index + "Dev Block strings are not supported");
		#/
		return;
	}
	level.current_game_module = game_module_index;
}

/*
	Name: get_current_game_module
	Namespace: zm_game_module
	Checksum: 0xA9200637
	Offset: 0x508
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function get_current_game_module()
{
	return get_game_module(level.current_game_module);
}

/*
	Name: get_game_module
	Namespace: zm_game_module
	Checksum: 0xDC5D0D66
	Offset: 0x530
	Size: 0x79
	Parameters: 1
	Flags: None
*/
function get_game_module(game_module_index)
{
	if(!isdefined(game_module_index))
	{
		return undefined;
	}
	for(i = 0; i < level._game_modules.size; i++)
	{
		if(level._game_modules[i].index == game_module_index)
		{
			return level._game_modules[i];
		}
	}
	return undefined;
}

/*
	Name: game_module_pre_zombie_spawn_init
	Namespace: zm_game_module
	Checksum: 0xEF8244E8
	Offset: 0x5B8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function game_module_pre_zombie_spawn_init()
{
	current_module = get_current_game_module();
	if(!isdefined(current_module) || !isdefined(current_module.pre_init_zombie_spawn_func))
	{
		return;
	}
	self [[current_module.pre_init_zombie_spawn_func]]();
}

/*
	Name: game_module_post_zombie_spawn_init
	Namespace: zm_game_module
	Checksum: 0xDA46626F
	Offset: 0x620
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function game_module_post_zombie_spawn_init()
{
	current_module = get_current_game_module();
	if(!isdefined(current_module) || !isdefined(current_module.post_init_zombie_spawn_func))
	{
		return;
	}
	self [[current_module.post_init_zombie_spawn_func]]();
}

/*
	Name: freeze_players
	Namespace: zm_game_module
	Checksum: 0xF2433D7E
	Offset: 0x688
	Size: 0x75
	Parameters: 1
	Flags: None
*/
function freeze_players(freeze)
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] util::freeze_player_controls(freeze);
	}
}

/*
	Name: respawn_spectators_and_freeze_players
	Namespace: zm_game_module
	Checksum: 0xECB72F48
	Offset: 0x708
	Size: 0x109
	Parameters: 0
	Flags: None
*/
function respawn_spectators_and_freeze_players()
{
	players = GetPlayers();
	foreach(player in players)
	{
		if(player.sessionstate == "spectator")
		{
			if(isdefined(player.spectate_hud))
			{
				player.spectate_hud destroy();
			}
			player [[level.spawnPlayer]]();
		}
		player util::freeze_player_controls(1);
	}
}

/*
	Name: damage_callback_no_pvp_damage
	Namespace: zm_game_module
	Checksum: 0x96304F2E
	Offset: 0x820
	Size: 0xC7
	Parameters: 10
	Flags: None
*/
function damage_callback_no_pvp_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, eapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(isdefined(eAttacker) && isPlayer(eAttacker) && eAttacker == self)
	{
		return iDamage;
	}
	if(isdefined(eAttacker) && !isPlayer(eAttacker))
	{
		return iDamage;
	}
	if(!isdefined(eAttacker))
	{
		return iDamage;
	}
	return 0;
}

/*
	Name: respawn_players
	Namespace: zm_game_module
	Checksum: 0xF83D6D4C
	Offset: 0x8F0
	Size: 0xB9
	Parameters: 0
	Flags: None
*/
function respawn_players()
{
	players = GetPlayers();
	foreach(player in players)
	{
		player [[level.spawnPlayer]]();
		player util::freeze_player_controls(1);
	}
}

/*
	Name: zombie_goto_round
	Namespace: zm_game_module
	Checksum: 0x727EB208
	Offset: 0x9B8
	Size: 0x109
	Parameters: 1
	Flags: None
*/
function zombie_goto_round(target_round)
{
	level notify("restart_round");
	if(target_round < 1)
	{
		target_round = 1;
	}
	level.zombie_total = 0;
	zombie_utility::ai_calculate_health(target_round);
	zombies = zombie_utility::get_round_enemy_array();
	if(isdefined(zombies))
	{
		for(i = 0; i < zombies.size; i++)
		{
			zombies[i] DoDamage(zombies[i].health + 666, zombies[i].origin);
		}
	}
	respawn_players();
	wait(1);
}

/*
	Name: make_supersprinter
	Namespace: zm_game_module
	Checksum: 0xE8377067
	Offset: 0xAD0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function make_supersprinter()
{
	self zombie_utility::set_zombie_run_cycle("super_sprint");
}

/*
	Name: game_module_custom_intermission
	Namespace: zm_game_module
	Checksum: 0x41C6C77
	Offset: 0xB00
	Size: 0x383
	Parameters: 1
	Flags: None
*/
function game_module_custom_intermission(intermission_struct)
{
	self closeInGameMenu();
	level endon("stop_intermission");
	self endon("disconnect");
	self endon("death");
	self notify("_zombie_game_over");
	self.score = self.score_total;
	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psOffsetTime = 0;
	self.friendlydamage = undefined;
	s_point = struct::get(intermission_struct, "targetname");
	if(!isdefined(level.intermission_cam_model))
	{
		level.intermission_cam_model = spawn("script_model", s_point.origin);
		level.intermission_cam_model.angles = s_point.angles;
		level.intermission_cam_model SetModel("tag_origin");
	}
	self.game_over_bg = newClientHudElem(self);
	self.game_over_bg.horzAlign = "fullscreen";
	self.game_over_bg.vertAlign = "fullscreen";
	self.game_over_bg SetShader("black", 640, 480);
	self.game_over_bg.alpha = 1;
	self spawn(level.intermission_cam_model.origin, level.intermission_cam_model.angles);
	self CameraSetPosition(level.intermission_cam_model);
	self CameraSetLookAt();
	self CameraActivate(1);
	self LinkTo(level.intermission_cam_model);
	level.intermission_cam_model moveto(struct::get(s_point.target, "targetname").origin, 12);
	if(isdefined(level.intermission_cam_model.angles))
	{
		level.intermission_cam_model RotateTo(struct::get(s_point.target, "targetname").angles, 12);
	}
	self.game_over_bg fadeOverTime(2);
	self.game_over_bg.alpha = 0;
	wait(2);
	self.game_over_bg thread zm::fade_up_over_time(1);
}

/*
	Name: create_fireworks
	Namespace: zm_game_module
	Checksum: 0xBD00A67B
	Offset: 0xE90
	Size: 0x11F
	Parameters: 4
	Flags: None
*/
function create_fireworks(launch_spots, min_wait, max_wait, randomize)
{
	level endon("stop_fireworks");
	while(1)
	{
		if(isdefined(randomize) && randomize)
		{
			launch_spots = Array::randomize(launch_spots);
		}
		foreach(spot in launch_spots)
		{
			level thread fireworks_launch(spot);
			wait(RandomFloatRange(min_wait, max_wait));
		}
		wait(RandomFloatRange(min_wait, max_wait));
	}
}

/*
	Name: fireworks_launch
	Namespace: zm_game_module
	Checksum: 0xAC5616A1
	Offset: 0xFB8
	Size: 0x2BB
	Parameters: 1
	Flags: None
*/
function fireworks_launch(launch_spot)
{
	firework = spawn("script_model", launch_spot.origin + (randomIntRange(-60, 60), randomIntRange(-60, 60), 0));
	firework SetModel("tag_origin");
	util::wait_network_frame();
	PlayFXOnTag(level._effect["fw_trail_cheap"], firework, "tag_origin");
	firework PlayLoopSound("zmb_souls_loop", 0.75);
	dest = launch_spot;
	while(isdefined(dest) && isdefined(dest.target))
	{
		random_offset = (randomIntRange(-60, 60), randomIntRange(-60, 60), 0);
		new_dests = struct::get_array(dest.target, "targetname");
		new_dest = Array::random(new_dests);
		dest = new_dest;
		dist = Distance(new_dest.origin + random_offset, firework.origin);
		time = dist / 700;
		firework moveto(new_dest.origin + random_offset, time);
		firework waittill("movedone");
	}
	firework playsound("zmb_souls_end");
	playFX(level._effect["fw_pre_burst"], firework.origin);
	firework delete();
}

