#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_score;
#using scripts\zm\zm_temple_ai_monkey;

#namespace zm_temple_triggers;

/*
	Name: main
	Namespace: zm_temple_triggers
	Checksum: 0xC35EC214
	Offset: 0x368
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function main()
{
	level thread init_code_triggers();
	level thread init_water_drop_triggers();
	level thread init_slow_trigger();
	level thread init_code_structs();
}

/*
	Name: init_code_triggers
	Namespace: zm_temple_triggers
	Checksum: 0xFEDC25AD
	Offset: 0x3D8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function init_code_triggers()
{
	triggers = GetEntArray("code_trigger", "targetname");
	Array::thread_all(triggers, &trigger_code);
}

/*
	Name: trigger_code
	Namespace: zm_temple_triggers
	Checksum: 0xDCF14283
	Offset: 0x438
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function trigger_code()
{
	code = self.script_noteworthy;
	if(!isdefined(code))
	{
		code = "DPAD_UP DPAD_UP DPAD_DOWN DPAD_DOWN DPAD_LEFT DPAD_RIGHT DPAD_LEFT DPAD_RIGHT BUTTON_B BUTTON_A";
	}
	if(!isdefined(self.script_string))
	{
		self.script_string = "cash";
	}
	self.players = [];
	while(1)
	{
		self waittill("trigger", who);
		if(is_in_array(self.players, who))
		{
			continue;
		}
		who thread watch_for_code_touching_trigger(code, self);
	}
}

/*
	Name: watch_for_code_touching_trigger
	Namespace: zm_temple_triggers
	Checksum: 0xD8A614A1
	Offset: 0x4F8
	Size: 0x187
	Parameters: 2
	Flags: None
*/
function watch_for_code_touching_trigger(code, trigger)
{
	if(!isdefined(trigger.players))
	{
		trigger.players = [];
	}
	else if(!IsArray(trigger.players))
	{
		trigger.players = Array(trigger.players);
	}
	trigger.players[trigger.players.size] = self;
	self thread watch_for_code(code);
	self thread touching_trigger(trigger);
	returnnotify = self util::waittill_any_return("code_correct", "stopped_touching_trigger", "death");
	self notify("code_trigger_end");
	if(returnnotify == "code_correct")
	{
		trigger code_trigger_activated(self);
	}
	else
	{
		trigger.players = ArrayRemoveValue(trigger.players, self);
	}
}

/*
	Name: is_in_array
	Namespace: zm_temple_triggers
	Checksum: 0x37C9EF78
	Offset: 0x688
	Size: 0x97
	Parameters: 2
	Flags: None
*/
function is_in_array(Array, item)
{
	foreach(index in Array)
	{
		if(index == item)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: array_remove
	Namespace: zm_temple_triggers
	Checksum: 0xB4550F95
	Offset: 0x728
	Size: 0x11B
	Parameters: 2
	Flags: None
*/
function array_remove(Array, object)
{
	if(!isdefined(Array) && !isdefined(object))
	{
		return;
	}
	new_array = [];
	foreach(item in Array)
	{
		if(item != object)
		{
			if(!isdefined(new_array))
			{
				new_array = [];
			}
			else if(!IsArray(new_array))
			{
				new_array = Array(new_array);
			}
			new_array[new_array.size] = item;
		}
	}
	return new_array;
}

/*
	Name: array_removeundefined
	Namespace: zm_temple_triggers
	Checksum: 0xAEC05AFE
	Offset: 0x850
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function array_removeundefined(Array)
{
	if(!isdefined(Array))
	{
		return;
	}
	new_array = [];
	foreach(item in Array)
	{
		if(isdefined(item))
		{
			if(!isdefined(new_array))
			{
				new_array = [];
			}
			else if(!IsArray(new_array))
			{
				new_array = Array(new_array);
			}
			new_array[new_array.size] = item;
		}
	}
	return new_array;
}

/*
	Name: code_trigger_activated
	Namespace: zm_temple_triggers
	Checksum: 0x150FBAB4
	Offset: 0x958
	Size: 0x4D
	Parameters: 1
	Flags: None
*/
function code_trigger_activated(who)
{
	switch(self.script_string)
	{
		case "cash":
		{
			who zm_score::add_to_player_score(100);
			break;
		}
		case default:
		{
		}
	}
}

/*
	Name: touching_trigger
	Namespace: zm_temple_triggers
	Checksum: 0xC0A65BE9
	Offset: 0x9B0
	Size: 0x49
	Parameters: 1
	Flags: None
*/
function touching_trigger(trigger)
{
	self endon("code_trigger_end");
	while(self istouching(trigger))
	{
		wait(0.1);
	}
	self notify("stopped_touching_trigger");
}

/*
	Name: watch_for_code
	Namespace: zm_temple_triggers
	Checksum: 0x251C9106
	Offset: 0xA08
	Size: 0x10F
	Parameters: 1
	Flags: None
*/
function watch_for_code(code)
{
	self endon("code_trigger_end");
	codes = StrTok(code, " ");
	while(1)
	{
		for(i = 0; i < codes.size; i++)
		{
			button = codes[i];
			if(!self button_pressed(button, 0.3))
			{
				break;
			}
			if(!self button_not_pressed(button, 0.3))
			{
				break;
			}
			if(i == codes.size - 1)
			{
				self notify("code_correct");
				return;
			}
		}
		wait(0.1);
	}
}

/*
	Name: button_not_pressed
	Namespace: zm_temple_triggers
	Checksum: 0x78DB1668
	Offset: 0xB20
	Size: 0x69
	Parameters: 2
	Flags: None
*/
function button_not_pressed(button, time)
{
	endTime = GetTime() + time * 1000;
	while(GetTime() < endTime)
	{
		if(!self buttonpressed(button))
		{
			return 1;
		}
		wait(0.01);
	}
	return 0;
}

/*
	Name: button_pressed
	Namespace: zm_temple_triggers
	Checksum: 0x358B248C
	Offset: 0xB98
	Size: 0x69
	Parameters: 2
	Flags: None
*/
function button_pressed(button, time)
{
	endTime = GetTime() + time * 1000;
	while(GetTime() < endTime)
	{
		if(self buttonpressed(button))
		{
			return 1;
		}
		wait(0.01);
	}
	return 0;
}

/*
	Name: init_slow_trigger
	Namespace: zm_temple_triggers
	Checksum: 0x6FE7A23B
	Offset: 0xC10
	Size: 0x10D
	Parameters: 0
	Flags: None
*/
function init_slow_trigger()
{
	level flag::wait_till("initial_players_connected");
	slowtriggers = GetEntArray("slow_trigger", "targetname");
	for(t = 0; t < slowtriggers.size; t++)
	{
		trig = slowtriggers[t];
		if(!isdefined(trig.script_float))
		{
			trig.script_float = 0.5;
		}
		trig.inturp_time = 1;
		trig.inturp_rate = trig.script_float / trig.inturp_time;
		trig thread trigger_slow_touched_wait();
	}
}

/*
	Name: trigger_slow_touched_wait
	Namespace: zm_temple_triggers
	Checksum: 0xEF97744E
	Offset: 0xD28
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function trigger_slow_touched_wait()
{
	while(1)
	{
		self waittill("trigger", player);
		player notify("enter_slowtrigger");
		self trigger::function_thread(player, &trigger_slow_ent, &trigger_unslow_ent);
		wait(0.1);
	}
}

/*
	Name: trigger_slow_ent
	Namespace: zm_temple_triggers
	Checksum: 0x51297CE8
	Offset: 0xDA8
	Size: 0x14B
	Parameters: 2
	Flags: None
*/
function trigger_slow_ent(player, endon_condition)
{
	player endon(endon_condition);
	if(isdefined(player))
	{
		prevtime = GetTime();
		while(player.moveSpeedScale > self.script_float)
		{
			wait(0.05);
			delta = GetTime() - prevtime;
			player.moveSpeedScale = player.moveSpeedScale - delta / 1000 * self.inturp_rate;
			prevtime = GetTime();
			player setMoveSpeedScale(player.moveSpeedScale);
		}
		player.moveSpeedScale = self.script_float;
		player AllowJump(0);
		player AllowSprint(0);
		player setMoveSpeedScale(self.script_float);
		player SetVelocity((0, 0, 0));
	}
}

/*
	Name: trigger_unslow_ent
	Namespace: zm_temple_triggers
	Checksum: 0xE45B921F
	Offset: 0xF00
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function trigger_unslow_ent(player)
{
	player endon("enter_slowtrigger");
	if(isdefined(player))
	{
		prevtime = GetTime();
		while(player.moveSpeedScale < 1)
		{
			wait(0.05);
			delta = GetTime() - prevtime;
			player.moveSpeedScale = player.moveSpeedScale + delta / 1000 * self.inturp_rate;
			prevtime = GetTime();
			player setMoveSpeedScale(player.moveSpeedScale);
		}
		player.moveSpeedScale = 1;
		player AllowJump(1);
		player AllowSprint(1);
		player setMoveSpeedScale(1);
	}
}

/*
	Name: trigger_corpse
	Namespace: zm_temple_triggers
	Checksum: 0xAC98D42E
	Offset: 0x1038
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function trigger_corpse()
{
	if(!isdefined(self.script_string))
	{
		self.script_string = "";
	}
	while(1)
	{
		/#
			box(self.origin, self.mins, self.maxs, 0, (1, 0, 0));
		#/
		corpses = GetCorpseArray();
		for(i = 0; i < corpses.size; i++)
		{
			corpse = corpses[i];
			/#
				box(corpse.orign, corpse.mins, corpse.maxs, 0, (1, 1, 0));
			#/
			if(corpse istouching(self))
			{
				self trigger_corpse_activated();
				return;
			}
		}
		wait(0.3);
	}
}

/*
	Name: trigger_corpse_activated
	Namespace: zm_temple_triggers
	Checksum: 0x9164D34F
	Offset: 0x1180
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function trigger_corpse_activated()
{
	IPrintLnBold("Corpse Trigger Activated");
}

/*
	Name: init_water_drop_triggers
	Namespace: zm_temple_triggers
	Checksum: 0x6CEEEC50
	Offset: 0x11A8
	Size: 0x135
	Parameters: 0
	Flags: None
*/
function init_water_drop_triggers()
{
	triggers = GetEntArray("water_drop_trigger", "script_noteworthy");
	for(i = 0; i < triggers.size; i++)
	{
		trig = triggers[i];
		trig.water_drop_time = 0.5;
		trig.waterdrops = 1;
		trig.watersheeting = 1;
		if(isdefined(trig.script_string))
		{
			if(trig.script_string == "sheetingonly")
			{
				trig.waterdrops = 0;
			}
			else if(trig.script_string == "dropsonly")
			{
				trig.watersheeting = 0;
			}
		}
		trig thread water_drop_trigger_think();
	}
}

/*
	Name: water_drop_trigger_think
	Namespace: zm_temple_triggers
	Checksum: 0x205FFA5E
	Offset: 0x12E8
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function water_drop_trigger_think()
{
	level flag::wait_till("initial_players_connected");
	wait(1);
	if(isdefined(self.script_flag))
	{
		level flag::wait_till(self.script_flag);
	}
	if(isdefined(self.script_float))
	{
		wait(self.script_float);
	}
	while(1)
	{
		self waittill("trigger", who);
		if(isPlayer(who))
		{
			self trigger::function_thread(who, &water_drop_trig_entered, &water_drop_trig_exit);
		}
		else if(isdefined(who.water_trigger_func))
		{
			who thread [[who.water_trigger_func]](self);
		}
	}
}

/*
	Name: water_drop_trig_entered
	Namespace: zm_temple_triggers
	Checksum: 0x9BEB4579
	Offset: 0x1400
	Size: 0x1B3
	Parameters: 2
	Flags: None
*/
function water_drop_trig_entered(player, endon_string)
{
	if(isdefined(endon_string))
	{
		player endon(endon_string);
	}
	player notify("water_drop_trig_enter");
	player endon("death");
	player endon("disconnect");
	player endon("spawned_spectator");
	if(player.sessionstate == "spectator")
	{
		return;
	}
	if(!isdefined(player.water_drop_ents))
	{
		player.water_drop_ents = [];
	}
	if(isdefined(self.script_sound))
	{
		player playsound(self.script_sound);
	}
	if(self.waterdrops)
	{
		if(!isdefined(player.water_drop_ents))
		{
			player.water_drop_ents = [];
		}
		else if(!IsArray(player.water_drop_ents))
		{
			player.water_drop_ents = Array(player.water_drop_ents);
		}
		player.water_drop_ents[player.water_drop_ents.size] = self;
		if(!self.watersheeting)
		{
			player SetWaterDrops(player player_get_num_water_drops());
		}
	}
	if(self.watersheeting)
	{
		self thread water_sheeting(player);
	}
}

/*
	Name: water_sheeting
	Namespace: zm_temple_triggers
	Checksum: 0x693304E9
	Offset: 0x15C0
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function water_sheeting(player)
{
	player notify("water_drop_trig_enter");
	player endon("death");
	player endon("disconnect");
	player endon("spawned_spectator");
	player endon("irt");
	player clientfield::set_to_player("floorrumble", 1);
	player thread intermission_rumble_clean_up();
	visionset_mgr::activate("overlay", "zm_waterfall_postfx", player);
}

/*
	Name: water_drop_trig_exit
	Namespace: zm_temple_triggers
	Checksum: 0x5629087A
	Offset: 0x1678
	Size: 0x153
	Parameters: 1
	Flags: None
*/
function water_drop_trig_exit(player)
{
	if(!isdefined(player.water_drop_ents))
	{
		player.water_drop_ents = [];
	}
	if(self.waterdrops)
	{
		if(self.watersheeting)
		{
			player notify("irt");
			player clientfield::set_to_player("floorrumble", 0);
			player SetWaterDrops(player player_get_num_water_drops());
			visionset_mgr::deactivate("overlay", "zm_waterfall_postfx", player);
		}
		player.water_drop_ents = array_remove(player.water_drop_ents, self);
		if(player.water_drop_ents.size == 0)
		{
			player water_drop_remove(0);
		}
		else
		{
			player SetWaterDrops(player player_get_num_water_drops());
		}
	}
}

/*
	Name: water_drop_remove
	Namespace: zm_temple_triggers
	Checksum: 0x178E7640
	Offset: 0x17D8
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function water_drop_remove(delay)
{
	self endon("death");
	self endon("disconnect");
	self endon("water_drop_trig_enter");
	wait(delay);
	self SetWaterDrops(0);
}

/*
	Name: player_get_num_water_drops
	Namespace: zm_temple_triggers
	Checksum: 0x6695C88B
	Offset: 0x1830
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function player_get_num_water_drops()
{
	if(self.water_drop_ents.size > 0)
	{
		return 50;
	}
	else
	{
		return 0;
	}
}

/*
	Name: init_code_structs
	Namespace: zm_temple_triggers
	Checksum: 0x6BBB5551
	Offset: 0x1860
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function init_code_structs()
{
	structs = struct::get_array("code_struct", "targetname");
	Array::thread_all(structs, &structs_code);
}

/*
	Name: structs_code
	Namespace: zm_temple_triggers
	Checksum: 0x350529F6
	Offset: 0x18C0
	Size: 0x243
	Parameters: 0
	Flags: None
*/
function structs_code()
{
	code = self.script_noteworthy;
	if(!isdefined(code))
	{
		code = "DPAD_UP DPAD_DOWN DPAD_LEFT DPAD_RIGHT BUTTON_B BUTTON_A";
	}
	self.codes = StrTok(code, " ");
	if(!isdefined(self.script_string))
	{
		self.script_string = "cash";
	}
	self.reward = self.script_string;
	if(!isdefined(self.radius))
	{
		self.radius = 32;
	}
	self.radiusSq = self.radius * self.radius;
	playersinradius = [];
	while(1)
	{
		players = GetPlayers();
		for(i = playersinradius.size - 1; i >= 0; i--)
		{
			player = playersinradius[i];
			if(!self is_player_in_radius(player))
			{
				if(isdefined(player))
				{
					playersinradius = array_remove(playersinradius, player);
					self notify("end_code_struct");
				}
				else
				{
					playersinradius = array_removeundefined(playersinradius);
				}
			}
			players = array_remove(players, player);
		}
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(self is_player_in_radius(player))
			{
				self thread code_entry(player);
				playersinradius[playersinradius.size] = player;
			}
		}
		wait(0.5);
	}
}

/*
	Name: code_entry
	Namespace: zm_temple_triggers
	Checksum: 0xA05E8FB0
	Offset: 0x1B10
	Size: 0x10B
	Parameters: 1
	Flags: None
*/
function code_entry(player)
{
	self endon("end_code_struct");
	player endon("death");
	player endon("disconnect");
	while(1)
	{
		for(i = 0; i < self.codes.size; i++)
		{
			button = self.codes[i];
			if(!player button_pressed(button, 0.3))
			{
				break;
			}
			if(!player button_not_pressed(button, 0.3))
			{
				break;
			}
			if(i == self.codes.size - 1)
			{
				self code_reward(player);
				return;
			}
		}
		wait(0.1);
	}
}

/*
	Name: code_reward
	Namespace: zm_temple_triggers
	Checksum: 0x704E938A
	Offset: 0x1C28
	Size: 0x6D
	Parameters: 1
	Flags: None
*/
function code_reward(player)
{
	switch(self.reward)
	{
		case "cash":
		{
			player zm_score::add_to_player_score(100);
			break;
		}
		case "mb":
		{
			zm_temple_ai_monkey::monkey_ambient_gib_all();
			break;
		}
		case default:
		{
		}
	}
}

/*
	Name: is_player_in_radius
	Namespace: zm_temple_triggers
	Checksum: 0xD80C5986
	Offset: 0x1CA0
	Size: 0x9F
	Parameters: 1
	Flags: None
*/
function is_player_in_radius(player)
{
	if(!zombie_utility::is_player_valid(player))
	{
		return 0;
	}
	if(Abs(self.origin[2] - player.origin[2]) > 30)
	{
		return 0;
	}
	if(Distance2DSquared(self.origin, player.origin) > self.radiusSq)
	{
		return 0;
	}
	return 1;
}

/*
	Name: intermission_rumble_clean_up
	Namespace: zm_temple_triggers
	Checksum: 0xF57AF174
	Offset: 0x1D48
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function intermission_rumble_clean_up()
{
	self endon("irt");
	level waittill("intermission");
	self clientfield::set_to_player("floorrumble", 0);
}

