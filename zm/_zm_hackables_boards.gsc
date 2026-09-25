#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_equip_hacker;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;

#namespace namespace_b1d3fbb7;

/*
	Name: hack_boards
	Namespace: namespace_b1d3fbb7
	Checksum: 0x4FB0F4FE
	Offset: 0x190
	Size: 0x295
	Parameters: 0
	Flags: None
*/
function hack_boards()
{
	windows = struct::get_array("exterior_goal", "targetname");
	for(i = 0; i < windows.size; i++)
	{
		window = windows[i];
		struct = spawnstruct();
		spot = window;
		if(isdefined(window.trigger_location))
		{
			spot = window.trigger_location;
		}
		org = zm_utility::GROUNDPOS(spot.origin) + VectorScale((0, 0, 1), 4);
		r = 96;
		h = 96;
		if(isdefined(spot.radius))
		{
			r = spot.radius;
		}
		if(isdefined(spot.height))
		{
			h = spot.height;
		}
		struct.origin = org + VectorScale((0, 0, 1), 48);
		struct.radius = r;
		struct.height = h;
		struct.script_float = 2;
		struct.script_int = 0;
		struct.window = window;
		struct.no_bullet_trace = 1;
		struct.no_sight_check = 1;
		struct.dot_limit = 0.7;
		struct.no_touch_check = 1;
		struct.last_hacked_round = 0;
		struct.num_hacks = 0;
		namespace_6d813654::register_pooled_hackable_struct(struct, &board_hack, &board_qualifier);
	}
}

/*
	Name: board_hack
	Namespace: namespace_b1d3fbb7
	Checksum: 0x1E06E7DD
	Offset: 0x430
	Size: 0x363
	Parameters: 1
	Flags: None
*/
function board_hack(hacker)
{
	namespace_6d813654::deregister_hackable_struct(self);
	num_chunks_checked = 0;
	last_repaired_chunk = undefined;
	if(self.last_hacked_round != level.round_number)
	{
		self.last_hacked_round = level.round_number;
		self.num_hacks = 0;
	}
	self.num_hacks++;
	if(self.num_hacks < 3)
	{
		hacker zm_score::add_to_player_score(100);
		continue;
	}
	cost = Int(min(300, hacker.score));
	if(cost)
	{
		hacker zm_score::minus_to_player_score(cost);
	}
	while(1)
	{
		if(zm_utility::all_chunks_intact(self.window, self.window.barrier_chunks))
		{
			break;
		}
		chunk = zm_utility::get_random_destroyed_chunk(self.window, self.window.barrier_chunks);
		if(!isdefined(chunk))
		{
			break;
		}
		self.window thread zm_blockers::replace_chunk(self.window, chunk, undefined, 0, 1);
		last_repaired_chunk = chunk;
		if(isdefined(self.clip))
		{
			self.window.clip TriggerEnable(1);
			self.window.clip disconnectpaths();
		}
		else
		{
			zm_blockers::blocker_disconnect_paths(self.window.neg_start, self.window.neg_end);
		}
		util::wait_network_frame();
		num_chunks_checked++;
		if(num_chunks_checked >= 20)
		{
			break;
		}
	}
	if(isdefined(self.window.zbarrier))
	{
		if(isdefined(last_repaired_chunk))
		{
			while(self.window.zbarrier GetZBarrierPieceState(last_repaired_chunk) == "closing")
			{
				wait(0.05);
			}
		}
		break;
	}
	while(isdefined(last_repaired_chunk) && last_repaired_chunk.State == "mid_repair")
	{
		wait(0.05);
	}
	namespace_6d813654::register_pooled_hackable_struct(self, &board_hack, &board_qualifier);
	self.window notify("blocker_hacked");
	self.window notify("no valid boards");
}

/*
	Name: board_qualifier
	Namespace: namespace_b1d3fbb7
	Checksum: 0xDE0C4AF9
	Offset: 0x7A0
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function board_qualifier(player)
{
	if(zm_utility::all_chunks_intact(self.window, self.window.barrier_chunks) || zm_utility::no_valid_repairable_boards(self.window, self.window.barrier_chunks))
	{
		return 0;
	}
	return 1;
}

