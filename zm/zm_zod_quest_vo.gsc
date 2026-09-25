#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#namespace namespace_6294c69f;

/*
	Name: opening_vo
	Namespace: namespace_6294c69f
	Checksum: 0x99EC1590
	Offset: 0x1B0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function opening_vo()
{
}

/*
	Name: function_3e539ffc
	Namespace: namespace_6294c69f
	Checksum: 0x99EC1590
	Offset: 0x1C0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_3e539ffc()
{
}

/*
	Name: vo_play_soliloquy
	Namespace: namespace_6294c69f
	Checksum: 0x10947887
	Offset: 0x1D0
	Size: 0x209
	Parameters: 1
	Flags: None
*/
function vo_play_soliloquy(convo)
{
	self endon("disconnect");
	/#
		Assert(isdefined(convo), "Dev Block strings are not supported");
	#/
	if(!level flag::get("story_vo_playing"))
	{
		level flag::set("story_vo_playing");
		self thread vo_play_soliloquy_disconnect_listener();
		self.dontspeak = 1;
		self clientfield::set_to_player("isspeaking", 1);
		for(i = 0; i < convo.size; i++)
		{
			if(isdefined(self.afterlife) && self.afterlife)
			{
				self.dontspeak = 0;
				self clientfield::set_to_player("isspeaking", 0);
				level flag::clear("story_vo_playing");
				self notify("soliloquy_vo_done");
				return;
			}
			else
			{
				self PlaySoundWithNotify(convo[i], "sound_done" + convo[i]);
				self waittill("sound_done" + convo[i]);
			}
			wait(1);
		}
		self.dontspeak = 0;
		self clientfield::set_to_player("isspeaking", 0);
		level flag::clear("story_vo_playing");
		self notify("soliloquy_vo_done");
	}
}

/*
	Name: vo_play_soliloquy_disconnect_listener
	Namespace: namespace_6294c69f
	Checksum: 0xFB29D215
	Offset: 0x3E8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function vo_play_soliloquy_disconnect_listener()
{
	self endon("soliloquy_vo_done");
	self waittill("disconnect");
	level flag::clear("story_vo_playing");
}

/*
	Name: vo_play_four_part_conversation
	Namespace: namespace_6294c69f
	Checksum: 0xFBD773CD
	Offset: 0x430
	Size: 0x703
	Parameters: 1
	Flags: None
*/
function vo_play_four_part_conversation(convo)
{
	/#
		Assert(isdefined(convo), "Dev Block strings are not supported");
	#/
	players = GetPlayers();
	if(players.size == 4 && !level flag::get("story_vo_playing"))
	{
		level flag::set("story_vo_playing");
		old_speaking_player = undefined;
		speaking_player = undefined;
		n_dist = 0;
		n_max_reply_dist = 1500;
		e_player1 = undefined;
		e_player2 = undefined;
		var_d1c0f9 = undefined;
		var_bede2506 = undefined;
		foreach(player in players)
		{
			if(isdefined(player))
			{
				switch(player.character_name)
				{
					case "Arlington":
					{
						e_player1 = player;
						break;
					}
					case "Sal":
					{
						e_player2 = player;
						break;
					}
					case "Billy":
					{
						var_d1c0f9 = player;
						break;
					}
					case "Finn":
					{
						var_bede2506 = player;
						break;
					}
				}
			}
		}
		if(!isdefined(e_player1) || !isdefined(e_player2) || !isdefined(var_d1c0f9) || !isdefined(var_bede2506))
		{
			return;
			break;
		}
		foreach(player in players)
		{
			if(isdefined(player))
			{
				player.dontspeak = 1;
				player clientfield::set_to_player("isspeaking", 1);
			}
		}
		for(i = 0; i < convo.size; i++)
		{
			players = GetPlayers();
			if(players.size != 4)
			{
				foreach(player in players)
				{
					if(isdefined(player))
					{
						player.dontspeak = 0;
						player clientfield::set_to_player("isspeaking", 0);
					}
				}
				level flag::clear("story_vo_playing");
				return;
			}
			if(IsSubStr(convo[i], "plr_0"))
			{
				speaking_player = var_bede2506;
			}
			else if(IsSubStr(convo[i], "plr_1"))
			{
				speaking_player = e_player2;
			}
			else if(IsSubStr(convo[i], "plr_2"))
			{
				speaking_player = var_d1c0f9;
			}
			else if(IsSubStr(convo[i], "plr_3"))
			{
				speaking_player = e_player1;
			}
			if(isdefined(old_speaking_player))
			{
				n_dist = Distance(old_speaking_player.origin, speaking_player.origin);
			}
			if(speaking_player.afterlife || n_dist > n_max_reply_dist)
			{
				foreach(player in players)
				{
					if(isdefined(player))
					{
						player.dontspeak = 0;
						player clientfield::set_to_player("isspeaking", 0);
					}
				}
				level flag::clear("story_vo_playing");
				return;
			}
			else
			{
				speaking_player PlaySoundWithNotify(convo[i], "sound_done" + convo[i]);
				speaking_player waittill("sound_done" + convo[i]);
				old_speaking_player = speaking_player;
			}
			wait(1);
		}
		foreach(player in players)
		{
			if(isdefined(player))
			{
				player.dontspeak = 0;
				player clientfield::set_to_player("isspeaking", 0);
			}
		}
		level flag::clear("story_vo_playing");
	}
}

