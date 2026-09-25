#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace antipersonnel_guidance;

/*
	Name: __init__sytem__
	Namespace: antipersonnel_guidance
	Checksum: 0xE4A3775E
	Offset: 0x1D0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("multilockap_guidance", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: antipersonnel_guidance
	Checksum: 0x5A8F374D
	Offset: 0x210
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level thread player_init();
	duplicate_render::set_dr_filter_offscreen("ap", 75, "ap_locked", undefined, 2, "mc/hud_outline_model_red", 0);
}

/*
	Name: player_init
	Namespace: antipersonnel_guidance
	Checksum: 0x6AA4786D
	Offset: 0x268
	Size: 0xC1
	Parameters: 0
	Flags: None
*/
function player_init()
{
	util::waitforclient(0);
	players = GetLocalPlayers();
	foreach(player in players)
	{
		player thread watch_lockon(0);
	}
}

/*
	Name: watch_lockon
	Namespace: antipersonnel_guidance
	Checksum: 0x6009DDB
	Offset: 0x338
	Size: 0x125
	Parameters: 1
	Flags: None
*/
function watch_lockon(localClientNum)
{
	while(1)
	{
		self waittill("lockon_changed", State, target);
		if(isdefined(self.replay_lock) && (!isdefined(target) || self.replay_lock != target))
		{
			self.ap_lock duplicate_render::change_dr_flags(localClientNum, undefined, "ap_locked");
			self.ap_lock = undefined;
		}
		switch(State)
		{
			case 0:
			case 1:
			case 3:
			{
				target duplicate_render::change_dr_flags(localClientNum, undefined, "ap_locked");
				break;
			}
			case 2:
			case 4:
			{
				target duplicate_render::change_dr_flags(localClientNum, "ap_locked", undefined);
				self.ap_lock = target;
				break;
			}
		}
	}
}

