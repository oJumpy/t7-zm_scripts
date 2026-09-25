#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_43a18dd5;

/*
	Name: __init__sytem__
	Namespace: namespace_43a18dd5
	Checksum: 0x10A3FFA2
	Offset: 0x2F0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_zombie_blood", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_43a18dd5
	Checksum: 0xBC45CE0B
	Offset: 0x330
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_localclient_connect(&function_a0b86d2c);
	RegisterClientField("allplayers", "player_zombie_blood_fx", 21000, 1, "int", &function_2d30244a, 0, 1);
	level._effect["zombie_blood"] = "dlc5/tomb/fx_pwr_up_blood";
	level._effect["zombie_blood_1st"] = "dlc5/tomb/fx_pwr_up_blood_overlay";
	zm_powerups::include_zombie_powerup("zombie_blood");
	zm_powerups::add_zombie_powerup("zombie_blood", "powerup_zombie_blood");
	visionset_mgr::register_visionset_info("zm_tomb_in_plain_sight", 1, 31, undefined, "zm_tomb_in_plain_sight");
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_tomb_in_plain_sight", 1, 1, "pstfx_zm_tomb_in_plain_sight");
}

/*
	Name: function_a0b86d2c
	Namespace: namespace_43a18dd5
	Checksum: 0x5958323F
	Offset: 0x468
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_a0b86d2c(localClientNum)
{
	player = GetLocalPlayer(localClientNum);
	filter::init_filter_indices();
	filter::map_material_helper(player, "generic_filter_zombie_blood_tomb");
}

/*
	Name: function_2d30244a
	Namespace: namespace_43a18dd5
	Checksum: 0x78770197
	Offset: 0x4D8
	Size: 0x1B5
	Parameters: 7
	Flags: None
*/
function function_2d30244a(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(IsSpectating(localClientNum, 0) || IsDemoPlaying())
	{
		return;
	}
	if(newVal == 1)
	{
		if(self isLocalPlayer() && self getlocalclientnumber() == localClientNum)
		{
			if(!isdefined(self.var_c5eb485f))
			{
				self.var_c5eb485f = PlayViewmodelFX(localClientNum, level._effect["zombie_blood_1st"], "tag_camera");
				playsound(localClientNum, "zmb_zombieblood_start", (0, 0, 0));
				audio::playloopat("zmb_zombieblood_loop", (0, 0, 0));
			}
		}
	}
	else if(isdefined(self.var_c5eb485f))
	{
		stopfx(localClientNum, self.var_c5eb485f);
		playsound(localClientNum, "zmb_zombieblood_stop", (0, 0, 0));
		audio::stoploopat("zmb_zombieblood_loop", (0, 0, 0));
		self.var_c5eb485f = undefined;
	}
}

