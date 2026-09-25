#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_93a0c6cf;

/*
	Name: __init__sytem__
	Namespace: namespace_93a0c6cf
	Checksum: 0x939E567D
	Offset: 0x1D0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_board_games", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_93a0c6cf
	Checksum: 0x76E19A19
	Offset: 0x210
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_board_games", "rounds", 5, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: namespace_93a0c6cf
	Checksum: 0x17E56E38
	Offset: 0x278
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function enable()
{
	self thread function_7b627622();
}

/*
	Name: disable
	Namespace: namespace_93a0c6cf
	Checksum: 0x99EC1590
	Offset: 0x2A0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function disable()
{
}

/*
	Name: function_7b627622
	Namespace: namespace_93a0c6cf
	Checksum: 0x418D6917
	Offset: 0x2B0
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function function_7b627622()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("hash_994d5e9e");
	while(1)
	{
		self waittill("boarding_window", var_c62a5d83);
		self bgb::do_one_shot_use();
		self thread function_d5ed5165(var_c62a5d83);
	}
}

/*
	Name: function_d5ed5165
	Namespace: namespace_93a0c6cf
	Checksum: 0x8481EE4B
	Offset: 0x330
	Size: 0x2DB
	Parameters: 1
	Flags: None
*/
function function_d5ed5165(var_c62a5d83)
{
	carp_ent = spawn("script_origin", (0, 0, 0));
	carp_ent PlayLoopSound("evt_carpenter");
	num_chunks_checked = 0;
	while(1)
	{
		if(zm_utility::all_chunks_intact(var_c62a5d83, var_c62a5d83.barrier_chunks))
		{
			break;
		}
		chunk = zm_utility::get_random_destroyed_chunk(var_c62a5d83, var_c62a5d83.barrier_chunks);
		if(!isdefined(chunk))
		{
			break;
		}
		var_c62a5d83 thread zm_blockers::replace_chunk(var_c62a5d83, chunk, undefined, 0, 1);
		last_repaired_chunk = chunk;
		if(isdefined(var_c62a5d83.clip))
		{
			var_c62a5d83.clip TriggerEnable(1);
			var_c62a5d83.clip disconnectpaths();
		}
		else
		{
			zm_blockers::blocker_disconnect_paths(var_c62a5d83.neg_start, var_c62a5d83.neg_end);
		}
		util::wait_network_frame();
		num_chunks_checked++;
		if(num_chunks_checked >= 20)
		{
			break;
		}
	}
	if(isdefined(var_c62a5d83.zbarrier))
	{
		if(isdefined(last_repaired_chunk))
		{
			while(var_c62a5d83.zbarrier GetZBarrierPieceState(last_repaired_chunk) == "closing")
			{
				wait(0.05);
			}
			if(isdefined(var_c62a5d83._post_carpenter_callback))
			{
				var_c62a5d83 [[var_c62a5d83._post_carpenter_callback]]();
			}
		}
		break;
	}
	while(isdefined(last_repaired_chunk) && last_repaired_chunk.State == "mid_repair")
	{
		wait(0.05);
	}
	carp_ent StopLoopSound(1);
	carp_ent PlaySoundWithNotify("evt_carpenter_end", "sound_done");
	carp_ent waittill("sound_done");
	carp_ent delete();
}

