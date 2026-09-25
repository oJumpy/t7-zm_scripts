#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_bgb_machine;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_powerup_fire_sale;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_fire_sale
	Checksum: 0x52F24C1B
	Offset: 0x368
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_fire_sale", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_fire_sale
	Checksum: 0x6A100743
	Offset: 0x3A8
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_powerups::register_powerup("fire_sale", &grab_fire_sale);
	if(ToLower(GetDvarString("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("fire_sale", "p7_zm_power_up_firesale", &"ZOMBIE_POWERUP_MAX_AMMO", &func_should_drop_fire_sale, 0, 0, 0, undefined, "powerup_fire_sale", "zombie_powerup_fire_sale_time", "zombie_powerup_fire_sale_on");
	}
}

/*
	Name: grab_fire_sale
	Namespace: zm_powerup_fire_sale
	Checksum: 0xC7D73E46
	Offset: 0x470
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function grab_fire_sale(player)
{
	level thread start_fire_sale(self);
	player thread zm_powerups::powerup_vo("firesale");
}

/*
	Name: start_fire_sale
	Namespace: zm_powerup_fire_sale
	Checksum: 0x8B8DBAB1
	Offset: 0x4C0
	Size: 0x205
	Parameters: 1
	Flags: None
*/
function start_fire_sale(item)
{
	if(isdefined(level.custom_firesale_box_leave) && level.custom_firesale_box_leave)
	{
		while(firesale_chest_is_leaving())
		{
			wait(0.05);
		}
	}
	if(level.zombie_vars["zombie_powerup_fire_sale_time"] > 0 && (isdefined(level.zombie_vars["zombie_powerup_fire_sale_on"]) && level.zombie_vars["zombie_powerup_fire_sale_on"]))
	{
		level.zombie_vars["zombie_powerup_fire_sale_time"] = level.zombie_vars["zombie_powerup_fire_sale_time"] + 30;
		return;
	}
	level notify("powerup fire sale");
	level endon("powerup fire sale");
	level thread zm_audio::sndAnnouncerPlayVox("fire_sale");
	level.zombie_vars["zombie_powerup_fire_sale_on"] = 1;
	level.disable_firesale_drop = 1;
	level thread toggle_fire_sale_on();
	level.zombie_vars["zombie_powerup_fire_sale_time"] = 30;
	if(bgb::is_team_enabled("zm_bgb_temporal_gift"))
	{
		level.zombie_vars["zombie_powerup_fire_sale_time"] = level.zombie_vars["zombie_powerup_fire_sale_time"] + 30;
	}
	while(level.zombie_vars["zombie_powerup_fire_sale_time"] > 0)
	{
		wait(0.05);
		level.zombie_vars["zombie_powerup_fire_sale_time"] = level.zombie_vars["zombie_powerup_fire_sale_time"] - 0.05;
	}
	level thread check_to_clear_fire_sale();
	level.zombie_vars["zombie_powerup_fire_sale_on"] = 0;
	level notify("fire_sale_off");
}

/*
	Name: check_to_clear_fire_sale
	Namespace: zm_powerup_fire_sale
	Checksum: 0xC79543F9
	Offset: 0x6D0
	Size: 0x2D
	Parameters: 0
	Flags: None
*/
function check_to_clear_fire_sale()
{
	while(firesale_chest_is_leaving())
	{
		wait(0.05);
	}
	level.disable_firesale_drop = undefined;
}

/*
	Name: firesale_chest_is_leaving
	Namespace: zm_powerup_fire_sale
	Checksum: 0xC5706698
	Offset: 0x708
	Size: 0xF9
	Parameters: 0
	Flags: None
*/
function firesale_chest_is_leaving()
{
	for(i = 0; i < level.chests.size; i++)
	{
		if(i !== level.chest_index)
		{
			if(level.chests[i].zbarrier.State === "leaving" || level.chests[i].zbarrier.State === "open" || level.chests[i].zbarrier.State === "close" || level.chests[i].zbarrier.State === "closing")
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: toggle_fire_sale_on
	Namespace: zm_powerup_fire_sale
	Checksum: 0xFFE756C4
	Offset: 0x810
	Size: 0x255
	Parameters: 0
	Flags: None
*/
function toggle_fire_sale_on()
{
	level endon("powerup fire sale");
	if(!isdefined(level.zombie_vars["zombie_powerup_fire_sale_on"]))
	{
		return;
	}
	level thread sndFiresaleMusic_Start();
	bgb_machine::turn_on_fire_sale();
	for(i = 0; i < level.chests.size; i++)
	{
		show_firesale_box = level.chests[i] [[level._zombiemode_check_firesale_loc_valid_func]]();
		if(show_firesale_box)
		{
			level.chests[i].zombie_cost = 10;
			if(level.chest_index != i)
			{
				level.chests[i].was_temp = 1;
				if(isdefined(level.chests[i].hidden) && level.chests[i].hidden)
				{
					level.chests[i] thread apply_fire_sale_to_chest();
				}
			}
		}
	}
	level notify("fire_sale_on");
	level waittill("fire_sale_off");
	waittillframeend;
	level thread sndFiresaleMusic_Stop();
	bgb_machine::turn_off_fire_sale();
	for(i = 0; i < level.chests.size; i++)
	{
		show_firesale_box = level.chests[i] [[level._zombiemode_check_firesale_loc_valid_func]]();
		if(show_firesale_box)
		{
			if(level.chest_index != i && isdefined(level.chests[i].was_temp))
			{
				level.chests[i].was_temp = undefined;
				level thread remove_temp_chest(i);
			}
			level.chests[i].zombie_cost = level.chests[i].old_cost;
		}
	}
}

/*
	Name: apply_fire_sale_to_chest
	Namespace: zm_powerup_fire_sale
	Checksum: 0x28421C1
	Offset: 0xA70
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function apply_fire_sale_to_chest()
{
	if(self.zbarrier GetZBarrierPieceState(1) == "closing")
	{
		while(self.zbarrier GetZBarrierPieceState(1) == "closing")
		{
			wait(0.1);
		}
		self.zbarrier waittill("left");
	}
	wait(0.1);
	self thread zm_magicbox::show_chest();
}

/*
	Name: remove_temp_chest
	Namespace: zm_powerup_fire_sale
	Checksum: 0x3D438E2C
	Offset: 0xB10
	Size: 0x267
	Parameters: 1
	Flags: None
*/
function remove_temp_chest(chest_index)
{
	level.chests[chest_index].being_removed = 1;
	while(isdefined(level.chests[chest_index].chest_user) || (isdefined(level.chests[chest_index]._box_open) && level.chests[chest_index]._box_open == 1))
	{
		util::wait_network_frame();
	}
	if(level.zombie_vars["zombie_powerup_fire_sale_on"])
	{
		level.chests[chest_index].was_temp = 1;
		level.chests[chest_index].zombie_cost = 10;
		level.chests[chest_index].being_removed = 0;
		return;
	}
	for(i = 0; i < chest_index; i++)
	{
		util::wait_network_frame();
	}
	playFX(level._effect["poltergeist"], level.chests[chest_index].orig_origin);
	level.chests[chest_index].zbarrier playsound("zmb_box_poof_land");
	level.chests[chest_index].zbarrier playsound("zmb_couch_slam");
	util::wait_network_frame();
	if(isdefined(level.custom_firesale_box_leave) && level.custom_firesale_box_leave)
	{
		level.chests[chest_index] zm_magicbox::hide_chest(1);
	}
	else
	{
		level.chests[chest_index] zm_magicbox::hide_chest();
	}
	level.chests[chest_index].being_removed = 0;
}

/*
	Name: func_should_drop_fire_sale
	Namespace: zm_powerup_fire_sale
	Checksum: 0x3B720526
	Offset: 0xD80
	Size: 0x4D
	Parameters: 0
	Flags: None
*/
function func_should_drop_fire_sale()
{
	if(level.zombie_vars["zombie_powerup_fire_sale_on"] == 1 || level.chest_moves < 1 || (isdefined(level.disable_firesale_drop) && level.disable_firesale_drop))
	{
		return 0;
	}
	return 1;
}

/*
	Name: sndFiresaleMusic_Start
	Namespace: zm_powerup_fire_sale
	Checksum: 0x29813674
	Offset: 0xDD8
	Size: 0x149
	Parameters: 0
	Flags: None
*/
function sndFiresaleMusic_Start()
{
	Array = level.chests;
	foreach(struct in Array)
	{
		if(!isdefined(struct.sndent))
		{
			struct.sndent = spawn("script_origin", struct.origin + VectorScale((0, 0, 1), 100));
		}
		if(isdefined(level.player_4_vox_override) && level.player_4_vox_override)
		{
			struct.sndent PlayLoopSound("mus_fire_sale_rich", 1);
			continue;
		}
		struct.sndent PlayLoopSound("mus_fire_sale", 1);
	}
}

/*
	Name: sndFiresaleMusic_Stop
	Namespace: zm_powerup_fire_sale
	Checksum: 0x42A35B19
	Offset: 0xF30
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function sndFiresaleMusic_Stop()
{
	Array = level.chests;
	foreach(struct in Array)
	{
		if(isdefined(struct.sndent))
		{
			struct.sndent delete();
			struct.sndent = undefined;
		}
	}
}

