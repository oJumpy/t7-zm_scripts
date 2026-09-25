#using scripts\shared\callbacks_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace water_surface;

/*
	Name: __init__sytem__
	Namespace: water_surface
	Checksum: 0xE5937B7
	Offset: 0x1C8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("water_surface", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: water_surface
	Checksum: 0xF3D74054
	Offset: 0x208
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["water_player_jump_in"] = "player/fx_plyr_water_jump_in_bubbles_1p";
	level._effect["water_player_jump_out"] = "player/fx_plyr_water_jump_out_splash_1p";
	if(isdefined(level.disableWaterSurfaceFX) && level.disableWaterSurfaceFX == 1)
	{
		return;
	}
	callback::on_localplayer_spawned(&localplayer_spawned);
}

/*
	Name: localplayer_spawned
	Namespace: water_surface
	Checksum: 0xCAB3EFF
	Offset: 0x290
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function localplayer_spawned(localClientNum)
{
	if(self != GetLocalPlayer(localClientNum))
	{
		return;
	}
	if(isdefined(level.disableWaterSurfaceFX) && level.disableWaterSurfaceFX == 1)
	{
		return;
	}
	filter::init_filter_water_sheeting(self);
	filter::init_filter_water_dive(self);
	self thread underwaterWatchBegin();
	self thread underwaterWatchEnd();
	filter::disable_filter_water_sheeting(self, 1);
	stop_player_fx(self);
}

/*
	Name: underwaterWatchBegin
	Namespace: water_surface
	Checksum: 0x68B8F1F0
	Offset: 0x370
	Size: 0xCF
	Parameters: 0
	Flags: None
*/
function underwaterWatchBegin()
{
	self notify("underwaterWatchBegin");
	self endon("underwaterWatchBegin");
	self endon("entityshutdown");
	while(1)
	{
		self waittill("underwater_begin", teleported);
		if(teleported)
		{
			filter::disable_filter_water_sheeting(self, 1);
			stop_player_fx(self);
			filter::disable_filter_water_dive(self, 1);
			stop_player_fx(self);
		}
		else
		{
			self thread underwaterBegin();
		}
	}
}

/*
	Name: underwaterWatchEnd
	Namespace: water_surface
	Checksum: 0xA38AC746
	Offset: 0x448
	Size: 0xCF
	Parameters: 0
	Flags: None
*/
function underwaterWatchEnd()
{
	self notify("underwaterWatchEnd");
	self endon("underwaterWatchEnd");
	self endon("entityshutdown");
	while(1)
	{
		self waittill("underwater_end", teleported);
		if(teleported)
		{
			filter::disable_filter_water_sheeting(self, 1);
			stop_player_fx(self);
			filter::disable_filter_water_dive(self, 1);
			stop_player_fx(self);
		}
		else
		{
			self thread underwaterEnd();
		}
	}
}

/*
	Name: underwaterBegin
	Namespace: water_surface
	Checksum: 0xF4984DE9
	Offset: 0x520
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function underwaterBegin()
{
	self notify("water_surface_underwater_begin");
	self endon("water_surface_underwater_begin");
	self endon("entityshutdown");
	localClientNum = self getlocalclientnumber();
	filter::disable_filter_water_sheeting(self, 1);
	stop_player_fx(self);
	if(islocalclientdead(localClientNum) == 0)
	{
		self.firstperson_water_fx = PlayFXOnCamera(localClientNum, level._effect["water_player_jump_in"], (0, 0, 0), (1, 0, 0), (0, 0, 1));
		if(!isdefined(self.playingPostfxBundle) || self.playingPostfxBundle != "pstfx_watertransition")
		{
			self thread postfx::playPostfxBundle("pstfx_watertransition");
		}
	}
}

/*
	Name: underwaterEnd
	Namespace: water_surface
	Checksum: 0xD40A9332
	Offset: 0x640
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function underwaterEnd()
{
	self notify("water_surface_underwater_end");
	self endon("water_surface_underwater_end");
	self endon("entityshutdown");
	localClientNum = self getlocalclientnumber();
	if(islocalclientdead(localClientNum) == 0)
	{
		if(!isdefined(self.playingPostfxBundle) || self.playingPostfxBundle != "pstfx_water_t_out")
		{
			self thread postfx::playPostfxBundle("pstfx_water_t_out");
		}
	}
}

/*
	Name: startWaterDive
	Namespace: water_surface
	Checksum: 0x4F941D8D
	Offset: 0x6F0
	Size: 0x249
	Parameters: 0
	Flags: None
*/
function startWaterDive()
{
	filter::enable_filter_water_dive(self, 1);
	filter::set_filter_water_scuba_dive_speed(self, 1, 0.25);
	filter::set_filter_water_wash_color(self, 1, 0.16, 0.5, 0.9);
	filter::set_filter_water_wash_reveal_dir(self, 1, -1);
	for(i = 0; i < 0.05;  = 0)
	{
		filter::set_filter_water_dive_bubbles(self, 1, i / 0.05);
		wait(0.01);
	}
	filter::set_filter_water_dive_bubbles(self, 1, 1);
	filter::set_filter_water_scuba_bubble_attitude(self, 1, -1);
	filter::set_filter_water_scuba_bubbles(self, 1, 1);
	filter::set_filter_water_wash_reveal_dir(self, 1, 1);
	for(i = 0.2; i > 0;  = 0.2)
	{
		filter::set_filter_water_dive_bubbles(self, 1, i / 0.2);
		wait(0.01);
	}
	filter::set_filter_water_dive_bubbles(self, 1, 0);
	wait(0.1);
	for(i = 0.2; i > 0;  = 0.2)
	{
		filter::set_filter_water_scuba_bubbles(self, 1, i / 0.2);
		wait(0.01);
	}
}

/*
	Name: startWaterSheeting
	Namespace: water_surface
	Checksum: 0x8E79A9E6
	Offset: 0x948
	Size: 0x213
	Parameters: 0
	Flags: None
*/
function startWaterSheeting()
{
	self notify("startWaterSheeting_singleton");
	self endon("startWaterSheeting_singleton");
	self endon("entityshutdown");
	filter::enable_filter_water_sheeting(self, 1);
	filter::set_filter_water_sheet_reveal(self, 1, 1);
	filter::set_filter_water_sheet_speed(self, 1, 1);
	for(i = 2; i > 0;  = 2)
	{
		filter::set_filter_water_sheet_reveal(self, 1, i / 2);
		filter::set_filter_water_sheet_speed(self, 1, i / 2);
		rivulet1 = i / 2 - 0.19;
		rivulet2 = i / 2 - 0.13;
		rivulet3 = i / 2 - 0.07;
		filter::set_filter_water_sheet_rivulet_reveal(self, 1, rivulet1, rivulet2, rivulet3);
		wait(0.01);
	}
	filter::set_filter_water_sheet_reveal(self, 1, 0);
	filter::set_filter_water_sheet_speed(self, 1, 0);
	filter::set_filter_water_sheet_rivulet_reveal(self, 1, 0, 0, 0);
}

/*
	Name: stop_player_fx
	Namespace: water_surface
	Checksum: 0x3A588FE3
	Offset: 0xB68
	Size: 0x71
	Parameters: 1
	Flags: None
*/
function stop_player_fx(localClient)
{
	if(isdefined(localClient.firstperson_water_fx))
	{
		localClientNum = localClient getlocalclientnumber();
		stopfx(localClientNum, localClient.firstperson_water_fx);
		localClient.firstperson_water_fx = undefined;
	}
}

