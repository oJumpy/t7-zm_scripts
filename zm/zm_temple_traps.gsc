#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_thundergun;
#using scripts\zm\zm_temple_triggers;

#namespace zm_temple_traps;

/*
	Name: init_temple_traps
	Namespace: zm_temple_traps
	Checksum: 0xD9E45A6C
	Offset: 0x520
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function init_temple_traps()
{
	level thread spear_trap_init();
	level thread waterfall_trap_init();
	level thread init_maze_trap();
}

/*
	Name: trigger_wait_for_power
	Namespace: zm_temple_traps
	Checksum: 0x73CDACE8
	Offset: 0x578
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function trigger_wait_for_power()
{
	self setHintString(&"ZOMBIE_NEED_POWER");
	self setcursorhint("HINT_NOICON");
	self.in_use = 0;
	level flag::wait_till("power_on");
}

/*
	Name: spear_trap_init
	Namespace: zm_temple_traps
	Checksum: 0x6EEE6CE9
	Offset: 0x5F0
	Size: 0x10D
	Parameters: 0
	Flags: None
*/
function spear_trap_init()
{
	speartraps = GetEntArray("spear_trap", "targetname");
	for(i = 0; i < speartraps.size; i++)
	{
		speartrap = speartraps[i];
		speartrap.clip = GetEnt(speartrap.target, "targetname");
		speartrap.clip notsolid();
		speartrap.clip connectpaths();
		speartrap.enable_flag = speartrap.script_noteworthy;
		speartrap thread spear_trap_think();
	}
}

/*
	Name: spear_trap_think
	Namespace: zm_temple_traps
	Checksum: 0x81E7C4AF
	Offset: 0x708
	Size: 0x109
	Parameters: 0
	Flags: None
*/
function spear_trap_think()
{
	if(isdefined(self.enable_flag) && !level flag::get(self.enable_flag))
	{
		level flag::wait_till(self.enable_flag);
	}
	while(1)
	{
		self waittill("trigger", who);
		if(!isdefined(who) || !isPlayer(who) || who.sessionstate == "spectator")
		{
			continue;
		}
		for(i = 0; i < 3; i++)
		{
			wait(0.4);
			self thread sprear_trap_activate_spears(i, who);
			wait(2);
		}
	}
}

/*
	Name: sprear_trap_activate_spears
	Namespace: zm_temple_traps
	Checksum: 0xC395BB44
	Offset: 0x820
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function sprear_trap_activate_spears(audio_counter, player)
{
	self spear_trap_damage_all_characters(audio_counter, player);
	self thread spear_activate(0);
}

/*
	Name: spear_trap_damage_all_characters
	Namespace: zm_temple_traps
	Checksum: 0x69963516
	Offset: 0x878
	Size: 0x155
	Parameters: 2
	Flags: None
*/
function spear_trap_damage_all_characters(audio_counter, player)
{
	wait(0.1);
	characters = ArrayCombine(GetPlayers(), GetAISpeciesArray("axis"), 1, 1);
	for(i = 0; i < characters.size; i++)
	{
		char = characters[i];
		if(self spear_trap_is_character_touching(char))
		{
			self thread spear_damage_character(char);
			continue;
		}
		if(isPlayer(char) && audio_counter == 0 && randomIntRange(0, 101) <= 10)
		{
			if(isdefined(player) && player == char)
			{
				char thread delayed_spikes_close_vox();
			}
		}
	}
}

/*
	Name: delayed_spikes_close_vox
	Namespace: zm_temple_traps
	Checksum: 0x5FC373AE
	Offset: 0x9D8
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function delayed_spikes_close_vox()
{
	self notify("playing_spikes_close_vox");
	self endon("death");
	self endon("playing_spikes_close_vox");
	wait(0.5);
	if(isdefined(self) && (!isdefined(self.spear_trap_slow) || (isdefined(self.spear_trap_slow) && self.spear_trap_slow == 0)))
	{
		self thread zm_audio::create_and_play_dialog("general", "spikes_close");
	}
}

/*
	Name: spear_damage_character
	Namespace: zm_temple_traps
	Checksum: 0xC21AF182
	Offset: 0xA70
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function spear_damage_character(char)
{
	char thread spear_trap_slow();
}

/*
	Name: spear_trap_slow
	Namespace: zm_temple_traps
	Checksum: 0x9C12E22B
	Offset: 0xAA0
	Size: 0x19F
	Parameters: 0
	Flags: None
*/
function spear_trap_slow()
{
	self endon("death");
	if(isdefined(self.spear_trap_slow) && self.spear_trap_slow)
	{
		return;
	}
	self.spear_trap_slow = 1;
	if(isPlayer(self))
	{
		if(zombie_utility::is_player_valid(self))
		{
			self thread zm_audio::create_and_play_dialog("general", "spikes_damage");
			self thread _fake_red();
			self DoDamage(5, self.origin);
			playsoundatposition("evt_spear_butt", self.origin);
			self PlayRumbleOnEntity("pistol_fire");
		}
		self SetVelocity((0, 0, 0));
		self setMoveSpeedScale(0.2);
		wait(1);
		self setMoveSpeedScale(1);
		wait(0.5);
	}
	else if(!(isdefined(self.missingLegs) && self.missingLegs))
	{
		self _zombie_spear_trap_damage_wait();
	}
	self.spear_trap_slow = 0;
}

/*
	Name: spear_choke
	Namespace: zm_temple_traps
	Checksum: 0xD713184D
	Offset: 0xC48
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function spear_choke()
{
	level._num_ai_released = 0;
	while(1)
	{
		wait(0.05);
		level._num_ai_released = 0;
	}
}

/*
	Name: _zombie_spear_trap_damage_wait
	Namespace: zm_temple_traps
	Checksum: 0xEFC2FAD9
	Offset: 0xC80
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function _zombie_spear_trap_damage_wait()
{
	self endon("death");
	if(!isdefined(level._spear_choke))
	{
		level._spear_choke = 1;
		level thread spear_choke();
	}
	endTime = GetTime() + randomIntRange(800, 1200);
	while(endTime > GetTime())
	{
		if(isdefined(self.missingLegs) && self.missingLegs)
		{
			break;
		}
		wait(0.05);
	}
	while(level._num_ai_released > 2)
	{
		/#
			println("Dev Block strings are not supported");
		#/
		wait(0.05);
	}
	self StopAnimScripted(0.5);
	level._num_ai_released++;
}

/*
	Name: _fake_red
	Namespace: zm_temple_traps
	Checksum: 0xDE44C5D0
	Offset: 0xD88
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function _fake_red()
{
	prompt = newClientHudElem(self);
	prompt.alignX = "left";
	prompt.x = 0;
	prompt.y = 0;
	prompt.alignX = "left";
	prompt.alignY = "top";
	prompt.horzAlign = "fullscreen";
	prompt.vertAlign = "fullscreen";
	fadetime = 1;
	prompt.color = VectorScale((1, 0, 0), 0.2);
	prompt.alpha = 0.7;
	prompt fadeOverTime(fadetime);
	prompt.alpha = 0;
	prompt.shader = "white";
	prompt SetShader("white", 640, 480);
	wait(fadetime);
	prompt destroy();
}

/*
	Name: spear_trap_is_character_touching
	Namespace: zm_temple_traps
	Checksum: 0x5E278EB9
	Offset: 0xF08
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function spear_trap_is_character_touching(char)
{
	return self istouching(char);
}

/*
	Name: spear_activate
	Namespace: zm_temple_traps
	Checksum: 0x6EF7956B
	Offset: 0xF38
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function spear_activate(delay)
{
	wait(delay);
	if(isdefined(self.clip))
	{
		self.clip solid();
		self.clip clientfield::set("spiketrap", 1);
	}
	wait(2);
	if(isdefined(self.clip))
	{
		self.clip notsolid();
		self.clip clientfield::set("spiketrap", 0);
	}
	wait(0.2);
}

/*
	Name: spear_kill
	Namespace: zm_temple_traps
	Checksum: 0x2C0A4874
	Offset: 0x1000
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function spear_kill(magnitude)
{
	self StartRagdoll();
	self LaunchRagdoll(VectorScale((0, 0, 1), 50));
	util::wait_network_frame();
	self.a.gib_ref = "head";
	self DoDamage(self.health + 666, self.origin);
}

/*
	Name: temple_trap_move_switch
	Namespace: zm_temple_traps
	Checksum: 0xF0BF4A00
	Offset: 0x10A0
	Size: 0x1BD
	Parameters: 0
	Flags: None
*/
function temple_trap_move_switch()
{
	trap_switch = undefined;
	for(i = 0; i < self.trap_switches.size; i++)
	{
		trap_switch = self.trap_switches[i];
		trap_switch MoveY(-5, 0.75);
	}
	if(isdefined(trap_switch))
	{
		trap_switch PlayLoopSound("zmb_pressure_plate_loop");
		trap_switch waittill("movedone");
		trap_switch StopLoopSound();
		trap_switch playsound("zmb_pressure_plate_lock");
	}
	self notify("switch_activated");
	self waittill("trap_ready");
	for(i = 0; i < self.trap_switches.size; i++)
	{
		trap_switch = self.trap_switches[i];
		trap_switch MoveY(5, 0.75);
		trap_switch PlayLoopSound("zmb_pressure_plate_loop");
		trap_switch waittill("movedone");
		trap_switch StopLoopSound();
		trap_switch playsound("zmb_pressure_plate_lock");
	}
}

/*
	Name: waterfall_trap_init
	Namespace: zm_temple_traps
	Checksum: 0x9BF923BD
	Offset: 0x1268
	Size: 0x3C5
	Parameters: 0
	Flags: None
*/
function waterfall_trap_init()
{
	usetriggers = GetEntArray("waterfall_trap", "targetname");
	for(i = 0; i < usetriggers.size; i++)
	{
		trapstruct = spawnstruct();
		trapstruct.useTrigger = usetriggers[i];
		trapstruct.useTrigger setHintString(&"ZOMBIE_NEED_POWER");
		trapstruct.useTrigger setcursorhint("HINT_NOICON");
		trapstruct.trap_switches = [];
		trapstruct.trap_damage = [];
		trapstruct.trap_shake = [];
		trapstruct.water_drop_trigs = [];
		trapstruct.var_41f396e4 = [];
		targetEnts = GetEntArray(trapstruct.useTrigger.target, "targetname");
		targetstructs = struct::get_array(trapstruct.useTrigger.target, "targetname");
		targets = ArrayCombine(targetEnts, targetstructs, 1, 1);
		for(j = 0; j < targets.size; j++)
		{
			if(!isdefined(targets[j].script_noteworthy))
			{
				break;
			}
			switch(targets[j].script_noteworthy)
			{
				case "trap_switch":
				{
					trapstruct.trap_switches[trapstruct.trap_switches.size] = targets[j];
					break;
				}
				case "trap_damage":
				{
					trapstruct.trap_damage[trapstruct.trap_damage.size] = targets[j];
					break;
				}
				case "trap_shake":
				{
					trapstruct.trap_shake[trapstruct.trap_shake.size] = targets[j];
					break;
				}
				case "water_drop_trigger":
				{
					targets[j] TriggerEnable(0);
					trapstruct.water_drop_trigs[trapstruct.water_drop_trigs.size] = targets[j];
					break;
				}
				case "water_trap_trigger":
				{
					targets[j] TriggerEnable(0);
					trapstruct.var_41f396e4[trapstruct.var_41f396e4.size] = targets[j];
					break;
				}
			}
		}
		trapstruct.enable_flag = trapstruct.useTrigger.script_noteworthy;
		trapstruct waterfall_trap_think();
	}
}

/*
	Name: waterfall_trap_think
	Namespace: zm_temple_traps
	Checksum: 0xC5D45D1A
	Offset: 0x1638
	Size: 0x227
	Parameters: 0
	Flags: None
*/
function waterfall_trap_think()
{
	while(1)
	{
		self notify("trap_ready");
		self.useTrigger setHintString(&"ZM_TEMPLE_USE_WATER_TRAP");
		self.useTrigger waittill("trigger", who);
		if(zombie_utility::is_player_valid(who) && !who zm_utility::in_revive_trigger())
		{
			who.used_waterfall = 1;
			self thread temple_trap_move_switch();
			self waittill("switch_activated");
			self.useTrigger setHintString("");
			waterfall_trap_on();
			wait(0.5);
			who.used_waterfall = 0;
			Array::thread_all(self.trap_damage, &waterfall_trap_damage);
			activeTime = 5.5;
			Array::thread_all(self.var_41f396e4, &waterfall_screen_fx, activeTime);
			self thread waterfall_screen_shake(activeTime);
			wait(activeTime);
			self notify("trap_off");
			self.useTrigger setHintString(&"ZM_TEMPLE_WATER_TRAP_COOL");
			Array::thread_all(self.var_41f396e4, &function_a6e2b85f);
			waterfall_trap_off();
			Array::notify_all(self.trap_damage, "trap_off");
			wait(30);
		}
	}
}

/*
	Name: function_a6e2b85f
	Namespace: zm_temple_traps
	Checksum: 0x31CA6B67
	Offset: 0x1868
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function function_a6e2b85f()
{
	self TriggerEnable(0);
	self notify("waterfall_trap_off");
}

/*
	Name: waterfall_screen_fx
	Namespace: zm_temple_traps
	Checksum: 0xE8683894
	Offset: 0x18A0
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function waterfall_screen_fx(activeTime)
{
	self.water_drop_time = 5;
	self.waterdrops = 1;
	self.watersheeting = 1;
	wait(1.5);
	self.watersheetingtime = activeTime - 1.5;
	self thread function_b68fdf22();
}

/*
	Name: function_b68fdf22
	Namespace: zm_temple_traps
	Checksum: 0xA703DA4B
	Offset: 0x1918
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function function_b68fdf22()
{
	self endon("waterfall_trap_off");
	self TriggerEnable(1);
	while(1)
	{
		self waittill("trigger", who);
		if(isPlayer(who))
		{
			self thread function_5e706bd9(who);
		}
	}
}

/*
	Name: function_5e706bd9
	Namespace: zm_temple_traps
	Checksum: 0xF89CE165
	Offset: 0x1998
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function function_5e706bd9(player)
{
	player endon("disconnect");
	self thread zm_temple_triggers::water_drop_trig_entered(player);
	while(isdefined(player) && player istouching(self) && self IsTriggerEnabled())
	{
		wait(0.05);
	}
	self thread zm_temple_triggers::water_drop_trig_exit(player);
}

/*
	Name: waterfall_screen_shake
	Namespace: zm_temple_traps
	Checksum: 0x2977555E
	Offset: 0x1A38
	Size: 0x6D
	Parameters: 1
	Flags: None
*/
function waterfall_screen_shake(activeTime)
{
	wait(1);
	for(i = 0; i < self.trap_shake.size; i++)
	{
		waterfall_screen_shake_single(activeTime, self.trap_shake[i].origin);
	}
}

/*
	Name: waterfall_screen_shake_single
	Namespace: zm_temple_traps
	Checksum: 0xF0ADABF5
	Offset: 0x1AB0
	Size: 0xA1
	Parameters: 2
	Flags: None
*/
function waterfall_screen_shake_single(activeTime, origin)
{
	remainingTime = 1;
	if(activeTime > 6)
	{
	}
	for(remainingTime = activeTime - 6; remainingTime > 0;  = activeTime - 6)
	{
		Earthquake(0.14, activeTime, origin, 400);
		wait(1);
	}
}

/*
	Name: waterfall_trap_on
	Namespace: zm_temple_traps
	Checksum: 0x4BA2C357
	Offset: 0x1B60
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function waterfall_trap_on()
{
	soundstruct = struct::get("waterfall_trap_origin", "targetname");
	if(isdefined(soundstruct))
	{
		playsoundatposition("evt_waterfall_trap", soundstruct.origin);
	}
	level notify("waterfall");
	level clientfield::set("waterfall_trap", 1);
	exploder::exploder("fxexp_21");
	exploder::stop_exploder("fxexp_20");
}

/*
	Name: waterfall_trap_off
	Namespace: zm_temple_traps
	Checksum: 0x622A57F9
	Offset: 0x1C30
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function waterfall_trap_off()
{
	exploder::exploder("fxexp_20");
	exploder::stop_exploder("fxexp_21");
}

/*
	Name: waterfall_trap_damage
	Namespace: zm_temple_traps
	Checksum: 0xED467420
	Offset: 0x1C70
	Size: 0x1AF
	Parameters: 0
	Flags: None
*/
function waterfall_trap_damage()
{
	self endon("trap_off");
	fwd = AnglesToForward(self.angles);
	zombies_knocked_down = [];
	while(1)
	{
		self waittill("trigger", who);
		if(isPlayer(who))
		{
			if(isdefined(self.script_string) && self.script_string == "hurt_player")
			{
				who DoDamage(20, self.origin);
				wait(1);
			}
			else
			{
				who thread waterfall_trap_player(fwd, 5.45);
			}
		}
		if(isdefined(who.animName) && who.animName == "monkey_zombie")
		{
			who thread waterfall_trap_monkey(randomIntRange(30, 80), fwd);
		}
		else if(!ent_in_array(who, zombies_knocked_down))
		{
			zombies_knocked_down[zombies_knocked_down.size] = who;
			util::wait_network_frame();
			who thread zombie_waterfall_knockdown(self);
		}
	}
}

/*
	Name: waterfall_trap_player
	Namespace: zm_temple_traps
	Checksum: 0x21997B1F
	Offset: 0x1E28
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function waterfall_trap_player(fwd, time)
{
	wait(1);
	vel = self GetVelocity();
	self SetVelocity(vel + fwd * 60);
	self PlayRumbleOnEntity("slide_rumble");
}

/*
	Name: waterfall_trap_monkey
	Namespace: zm_temple_traps
	Checksum: 0x10E036D8
	Offset: 0x1EB8
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function waterfall_trap_monkey(magnitude, dir)
{
	wait(1);
	self StartRagdoll();
	self LaunchRagdoll(dir * magnitude);
	util::wait_network_frame();
	self DoDamage(self.health + 666, self.origin);
}

/*
	Name: ent_in_array
	Namespace: zm_temple_traps
	Checksum: 0x5D0A9B5B
	Offset: 0x1F48
	Size: 0x59
	Parameters: 2
	Flags: None
*/
function ent_in_array(ent, _array)
{
	for(i = 0; i < _array.size; i++)
	{
		if(_array[i] == ent)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: init_maze_trap
	Namespace: zm_temple_traps
	Checksum: 0x1BBEE468
	Offset: 0x1FB0
	Size: 0x5E3
	Parameters: 0
	Flags: None
*/
function init_maze_trap()
{
	level.mazecells = [];
	level.mazefloors = [];
	level.mazewalls = [];
	level.mazepath = [];
	level.startcells = [];
	level.pathplayers = [];
	level.pathactive = 0;
	mazeclip = GetEnt("maze_path_clip", "targetname");
	if(isdefined(mazeclip))
	{
		mazeclip delete();
	}
	init_maze_paths();
	mazetriggers = GetEntArray("maze_trigger", "targetname");
	for(i = 0; i < mazetriggers.size; i++)
	{
		mazetrigger = mazetriggers[i];
		mazetrigger.pathcount = 0;
		triggernum = mazetrigger.script_int;
		if(!isdefined(triggernum))
		{
			continue;
		}
		_add_maze_cell(triggernum);
		level.mazecells[triggernum - 1].trigger = mazetrigger;
		if(isdefined(mazetrigger.script_string))
		{
			startcell = mazetrigger.script_string == "start";
			if(startcell)
			{
				level.startcells[level.startcells.size] = level.mazecells[triggernum - 1];
			}
		}
	}
	mazefloors = GetEntArray("maze_floor", "targetname");
	for(i = 0; i < mazefloors.size; i++)
	{
		mazefloor = mazefloors[i];
		floornum = mazefloor.script_int;
		if(!isdefined(floornum))
		{
			continue;
		}
		mazefloor init_maze_mover(16, 0.25, 0.5, 0, "evt_maze_floor_up", "evt_maze_floor_up", 0);
		level.mazecells[floornum - 1].floor = mazefloor;
		level.mazefloors[level.mazefloors.size] = mazefloor;
	}
	mazewalls = GetEntArray("maze_door", "targetname");
	for(i = 0; i < mazewalls.size; i++)
	{
		mazewall = mazewalls[i];
		wallnum = mazewall.script_int;
		if(!isdefined(wallnum))
		{
			continue;
		}
		mazewall init_maze_mover(-128, 0.25, 1, 1, "evt_maze_wall_down", "evt_maze_wall_up", 1);
		mazewall notsolid();
		mazewall connectpaths();
		mazewall.script_fxid = level._effect["maze_wall_impact"];
		mazewall.script_fxid2 = level._effect["maze_wall_raise"];
		mazewall.fx_active_offset = VectorScale((0, 0, -1), 60);
		mazewall.adjacentcells = [];
		adjacent_cell_nums = [];
		adjacent_cell_nums[0] = wallnum % 100;
		adjacent_cell_nums[1] = Int(wallnum - wallnum % 100 / 100);
		for(j = 0; j < adjacent_cell_nums.size; j++)
		{
			cell_num = adjacent_cell_nums[j];
			if(cell_num == 0)
			{
				continue;
			}
			mazecell = level.mazecells[cell_num - 1];
			mazecell.walls[mazecell.walls.size] = mazewall;
			mazewall.adjacentcells[mazewall.adjacentcells.size] = mazecell;
		}
		level.mazewalls[level.mazewalls.size] = mazewall;
	}
	maze_show_starts();
	Array::thread_all(level.mazecells, &maze_cell_watch);
}

/*
	Name: init_maze_paths
	Namespace: zm_temple_traps
	Checksum: 0x4D3854A1
	Offset: 0x25A0
	Size: 0x613
	Parameters: 0
	Flags: None
*/
function init_maze_paths()
{
	level.mazepathcounter = 0;
	level.mazepaths = [];
	add_maze_path(Array(5, 4, 3));
	add_maze_path(Array(5, 4, 1, 0, 3));
	add_maze_path(Array(5, 4, 7, 6, 3));
	add_maze_path(Array(5, 4, 3, 6, 9, 12));
	add_maze_path(Array(5, 4, 7, 10, 11, 14, 13, 12));
	add_maze_path(Array(5, 4, 1, 0, 3, 6, 9, 12));
	add_maze_path(Array(5, 4, 7, 8), 1);
	add_maze_path(Array(5, 4, 1, 0, 3, 6, 7, 8), 1);
	add_maze_path(Array(3, 4, 7, 10, 13, 12));
	add_maze_path(Array(3, 4, 5, 8, 7, 6, 9, 12));
	add_maze_path(Array(3, 4, 1, 2, 5, 8, 11, 10, 9, 12));
	add_maze_path(Array(3, 4, 5));
	add_maze_path(Array(3, 4, 7, 6, 9, 10, 11, 8, 5));
	add_maze_path(Array(3, 4, 1, 2, 5));
	add_maze_path(Array(3, 4, 7, 6), 1);
	add_maze_path(Array(3, 4, 1, 2, 5, 8, 7, 6), 1);
	add_maze_path(Array(12, 9, 6, 3));
	add_maze_path(Array(12, 9, 10, 7, 4, 3));
	add_maze_path(Array(12, 9, 10, 13, 14, 11, 8, 5, 4, 3));
	add_maze_path(Array(12, 9, 6, 3, 4, 5));
	add_maze_path(Array(12, 9, 10, 11, 8, 7, 4, 5));
	add_maze_path(Array(12, 9, 6, 3, 0, 1, 2, 5));
	add_maze_path(Array(12, 9, 10, 13), 1);
	add_maze_path(Array(12, 9, 6, 7, 10, 13), 1);
}

/*
	Name: add_maze_path
	Namespace: zm_temple_traps
	Checksum: 0x9DD3E1EA
	Offset: 0x2BC0
	Size: 0x85
	Parameters: 2
	Flags: None
*/
function add_maze_path(path, loopback)
{
	if(!isdefined(loopback))
	{
		loopback = 0;
	}
	s = spawnstruct();
	s.path = path;
	s.loopback = loopback;
	level.mazepaths[level.mazepaths.size] = s;
}

/*
	Name: init_maze_mover
	Namespace: zm_temple_traps
	Checksum: 0x2C4F2EF5
	Offset: 0x2C50
	Size: 0x12F
	Parameters: 7
	Flags: None
*/
function init_maze_mover(moveDist, moveUpTime, moveDownTime, blockspaths, moveupsound, movedownsound, cliponly)
{
	self.isActive = 0;
	self.activeCount = 0;
	self.ismoving = 0;
	self.moveDist = moveDist;
	self.activeheight = self.origin[2] + moveDist;
	self.moveUpTime = moveUpTime;
	self.moveDownTime = moveDownTime;
	self.pathblocker = blockspaths;
	self.alwaysactive = 0;
	self.moveupsound = moveupsound;
	self.movedownsound = movedownsound;
	self.startAngles = self.angles;
	self.cliponly = cliponly;
	if(isdefined(self.script_string) && self.script_string == "always_active")
	{
		maze_mover_active(1);
		self.alwaysactive = 1;
	}
}

/*
	Name: _add_maze_cell
	Namespace: zm_temple_traps
	Checksum: 0x84B928B4
	Offset: 0x2D88
	Size: 0x7D
	Parameters: 1
	Flags: None
*/
function _add_maze_cell(cell_index)
{
	for(i = level.mazecells.size; i < cell_index; i++)
	{
		level.mazecells[i] = spawnstruct();
		level.mazecells[i] _init_maze_cell();
	}
}

/*
	Name: _init_maze_cell
	Namespace: zm_temple_traps
	Checksum: 0x76EFB1AA
	Offset: 0x2E10
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function _init_maze_cell()
{
	self.trigger = undefined;
	self.floor = undefined;
	self.walls = [];
}

/*
	Name: maze_mover_active
	Namespace: zm_temple_traps
	Checksum: 0x576ADDF7
	Offset: 0x2E38
	Size: 0x2FB
	Parameters: 1
	Flags: None
*/
function maze_mover_active(active)
{
	if(self.alwaysactive)
	{
		return;
	}
	if(active)
	{
		self.activeCount++;
	}
	else
	{
		self.activeCount = Int(max(0, self.activeCount - 1));
	}
	active = self.activeCount > 0;
	if(self.isActive == active)
	{
		return;
	}
	if(active && isdefined(self.moveupsound))
	{
		self playsound(self.moveupsound);
	}
	if(!active && isdefined(self.movedownsound))
	{
		self playsound(self.movedownsound);
	}
	goalpos = (self.origin[0], self.origin[1], self.activeheight);
	if(!active)
	{
		goalpos = (goalpos[0], goalpos[1], goalpos[2] - self.moveDist);
	}
	moveTime = self.moveUpTime;
	if(!active)
	{
		moveTime = self.moveDownTime;
	}
	if(self.ismoving)
	{
		currentz = self.origin[2];
		goalz = goalpos[2];
		Ratio = Abs(goalz - currentz) / Abs(self.moveDist);
		moveTime = moveTime * Ratio;
	}
	self notify("stop_maze_mover");
	self.isActive = active;
	if(self.cliponly)
	{
		if(active)
		{
			self solid();
			self disconnectpaths();
			self clientfield::set("mazewall", 1);
		}
		else
		{
			self notsolid();
			self connectpaths();
			self clientfield::set("mazewall", 0);
		}
	}
	else
	{
		self thread _maze_mover_move(goalpos, moveTime);
	}
}

/*
	Name: _maze_mover_move
	Namespace: zm_temple_traps
	Checksum: 0x8E8D01E6
	Offset: 0x3140
	Size: 0x10B
	Parameters: 2
	Flags: None
*/
function _maze_mover_move(goal, time)
{
	self endon("stop_maze_mover");
	self.ismoving = 1;
	if(time == 0)
	{
		time = 0.01;
	}
	self moveto(goal, time);
	self waittill("movedone");
	self.ismoving = 0;
	if(self.isActive)
	{
		_maze_mover_play_fx(self.script_fxid, self.fx_active_offset);
	}
	else
	{
		_maze_mover_play_fx(self.script_fxid2, self.fx_active2_offset);
	}
	if(self.pathblocker)
	{
		if(self.isActive)
		{
			self disconnectpaths();
		}
		else
		{
			self connectpaths();
		}
	}
}

/*
	Name: _maze_mover_play_fx
	Namespace: zm_temple_traps
	Checksum: 0xE5B347D6
	Offset: 0x3258
	Size: 0x93
	Parameters: 2
	Flags: None
*/
function _maze_mover_play_fx(fx_name, offset)
{
	if(isdefined(fx_name))
	{
		vFwd = AnglesToForward(self.angles);
		org = self.origin;
		if(isdefined(offset))
		{
			org = org + offset;
		}
		playFX(fx_name, org, vFwd, (0, 0, 1));
	}
}

/*
	Name: maze_cell_watch
	Namespace: zm_temple_traps
	Checksum: 0x60AA273C
	Offset: 0x32F8
	Size: 0x1CF
	Parameters: 0
	Flags: None
*/
function maze_cell_watch()
{
	level endon("fake_death");
	while(1)
	{
		self.trigger waittill("trigger", who);
		if(self.trigger.pathcount > 0)
		{
			if(isPlayer(who))
			{
				if(who is_player_maze_slow())
				{
					continue;
				}
				if(who.sessionstate == "spectator")
				{
					continue;
				}
				self thread maze_cell_player_enter(who);
			}
			else if(isdefined(who.animName) && who.animName == "zombie")
			{
				self.trigger thread zombie_normal_trigger_exit(who);
			}
		}
		else if(isPlayer(who))
		{
			if(who is_player_on_path())
			{
				continue;
			}
			if(who.sessionstate == "spectator")
			{
				continue;
			}
			self.trigger thread watch_slow_trigger_exit(who);
		}
		else if(isdefined(who.animName) && who.animName == "zombie")
		{
			self.trigger thread zombie_slow_trigger_exit(who);
		}
	}
}

/*
	Name: zombie_mud_move_slow
	Namespace: zm_temple_traps
	Checksum: 0xD45DB5D9
	Offset: 0x34D0
	Size: 0x75
	Parameters: 0
	Flags: None
*/
function zombie_mud_move_slow()
{
	self.zm_move_speed_pre_mud = self.zombie_move_speed;
	switch(self.zombie_move_speed)
	{
		case "run":
		{
			self zombie_utility::set_zombie_run_cycle("walk");
			break;
		}
		case "sprint":
		{
			self zombie_utility::set_zombie_run_cycle("run");
			break;
		}
	}
}

/*
	Name: zombie_mud_move_normal
	Namespace: zm_temple_traps
	Checksum: 0x7D5FE3AA
	Offset: 0x3550
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function zombie_mud_move_normal()
{
	self zombie_utility::set_zombie_run_cycle(self.zm_move_speed_pre_mud);
}

/*
	Name: zombie_slow_trigger_exit
	Namespace: zm_temple_traps
	Checksum: 0x150A26E6
	Offset: 0x3580
	Size: 0x153
	Parameters: 1
	Flags: None
*/
function zombie_slow_trigger_exit(zombie)
{
	zombie endon("death");
	if(isdefined(zombie.mud_triggers))
	{
		if(is_in_array(zombie.mud_triggers, self))
		{
			return;
		}
	}
	else
	{
		zombie.mud_triggers = [];
	}
	if(!zombie zombie_on_mud())
	{
		zombie zombie_mud_move_slow();
	}
	zombie.mud_triggers[zombie.mud_triggers.size] = self;
	while(self.pathcount == 0 && zombie istouching(self))
	{
		wait(0.1);
	}
	ArrayRemoveValue(zombie.mud_triggers, self);
	if(!zombie zombie_on_mud() && !zombie zombie_on_path())
	{
		zombie zombie_mud_move_normal();
	}
}

/*
	Name: is_in_array
	Namespace: zm_temple_traps
	Checksum: 0x9EC19CB9
	Offset: 0x36E0
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
	Name: zombie_on_path
	Namespace: zm_temple_traps
	Checksum: 0x3F2644F3
	Offset: 0x3780
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function zombie_on_path()
{
	return isdefined(self.path_triggers) && self.path_triggers.size > 0;
}

/*
	Name: zombie_on_mud
	Namespace: zm_temple_traps
	Checksum: 0x8A43C486
	Offset: 0x37A8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function zombie_on_mud()
{
	return isdefined(self.mud_triggers) && self.mud_triggers.size > 0;
}

/*
	Name: zombie_normal_trigger_exit
	Namespace: zm_temple_traps
	Checksum: 0x9B9293CF
	Offset: 0x37D0
	Size: 0x10B
	Parameters: 1
	Flags: None
*/
function zombie_normal_trigger_exit(zombie)
{
	zombie endon("death");
	if(isdefined(zombie.path_triggers))
	{
		if(is_in_array(zombie.path_triggers, self))
		{
			return;
		}
	}
	else
	{
		zombie.path_triggers = [];
	}
	if(!zombie zombie_on_path())
	{
		zombie zombie_mud_move_normal();
	}
	zombie.path_triggers[zombie.path_triggers.size] = self;
	while(self.pathcount != 0 && zombie istouching(self))
	{
		wait(0.1);
	}
	ArrayRemoveValue(zombie.path_triggers, self);
}

/*
	Name: is_player_on_path
	Namespace: zm_temple_traps
	Checksum: 0x43C04CB0
	Offset: 0x38E8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function is_player_on_path()
{
	return isdefined(self.mazepathcells) && self.mazepathcells.size > 0;
}

/*
	Name: is_player_maze_slow
	Namespace: zm_temple_traps
	Checksum: 0xFEE74F4B
	Offset: 0x3910
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function is_player_maze_slow()
{
	return isdefined(self.mazeslowtrigger) && self.mazeslowtrigger.size > 0;
}

/*
	Name: maze_cell_player_enter
	Namespace: zm_temple_traps
	Checksum: 0xB7F6391D
	Offset: 0x3938
	Size: 0x1E3
	Parameters: 1
	Flags: None
*/
function maze_cell_player_enter(player)
{
	if(isdefined(player.mazepathcells))
	{
		if(is_in_array(player.mazepathcells, self))
		{
			return;
		}
	}
	else
	{
		player.mazepathcells = [];
	}
	if(!is_in_array(level.pathplayers, player))
	{
		level.pathplayers[level.pathplayers.size] = player;
	}
	player.mazepathcells[player.mazepathcells.size] = self;
	if(!level.pathactive)
	{
		self maze_start_path();
	}
	on_maze_cell_enter();
	self path_trigger_wait(player);
	isplayervalid = isdefined(player);
	if(isplayervalid)
	{
		ArrayRemoveValue(player.mazepathcells, self);
	}
	if(!isplayervalid || !player is_player_on_path())
	{
		level.pathplayers = Array::remove_undefined(level.pathplayers);
		if(isplayervalid)
		{
			ArrayRemoveValue(level.pathplayers, player);
		}
		if(level.pathplayers.size == 0)
		{
			maze_end_path();
		}
	}
	on_maze_cell_exit();
}

/*
	Name: path_trigger_wait
	Namespace: zm_temple_traps
	Checksum: 0xC3AFF33E
	Offset: 0x3B28
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function path_trigger_wait(player)
{
	player endon("disconnect");
	player endon("fake_death");
	player endon("death");
	level endon("maze_timer_end");
	while(self.trigger.pathcount != 0 && player istouching(self.trigger) && player.sessionstate != "spectator")
	{
		wait(0.1);
	}
}

/*
	Name: on_maze_cell_enter
	Namespace: zm_temple_traps
	Checksum: 0x1F8ABC2B
	Offset: 0x3BC8
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function on_maze_cell_enter()
{
	current = self;
	previous = current cell_get_previous();
	next = current cell_get_next();
	raise_floor(previous);
	raise_floor(current);
	raise_floor(next);
	activate_walls(previous);
	activate_walls(current);
	activate_walls(next);
}

/*
	Name: on_maze_cell_exit
	Namespace: zm_temple_traps
	Checksum: 0xDB8309E9
	Offset: 0x3CB8
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function on_maze_cell_exit()
{
	current = self;
	previous = current cell_get_previous();
	next = current cell_get_next();
	lower_floor(previous);
	lower_floor(current);
	lower_floor(next);
	lower_walls(previous);
	lower_walls(current);
	lower_walls(next);
}

/*
	Name: watch_slow_trigger_exit
	Namespace: zm_temple_traps
	Checksum: 0x105359C1
	Offset: 0x3DA8
	Size: 0x233
	Parameters: 1
	Flags: None
*/
function watch_slow_trigger_exit(player)
{
	player endon("death");
	player endon("fake_death");
	player endon("disconnect");
	player AllowJump(0);
	if(isdefined(player.mazeslowtrigger))
	{
		if(is_in_array(player.mazeslowtrigger, self))
		{
			return;
		}
	}
	else
	{
		player.mazeslowtrigger = [];
	}
	if(!player is_player_maze_slow())
	{
		player AllowSprint(0);
		player AllowProne(0);
		player allowslide(0);
		player setMoveSpeedScale(0.35);
	}
	player.mazeslowtrigger[player.mazeslowtrigger.size] = self;
	while(self.pathcount == 0 && player istouching(self))
	{
		wait(0.1);
	}
	ArrayRemoveValue(player.mazeslowtrigger, self);
	if(!player is_player_maze_slow())
	{
		player AllowJump(1);
		player AllowSprint(1);
		player AllowProne(1);
		player allowslide(1);
		player setMoveSpeedScale(1);
	}
}

/*
	Name: lower_walls
	Namespace: zm_temple_traps
	Checksum: 0xA8632B77
	Offset: 0x3FE8
	Size: 0x85
	Parameters: 1
	Flags: None
*/
function lower_walls(cell)
{
	if(!isdefined(cell))
	{
		return;
	}
	for(i = 0; i < cell.walls.size; i++)
	{
		wall = cell.walls[i];
		wall thread maze_mover_active(0);
	}
}

/*
	Name: activate_walls
	Namespace: zm_temple_traps
	Checksum: 0x72F22D4E
	Offset: 0x4078
	Size: 0x1AD
	Parameters: 1
	Flags: None
*/
function activate_walls(cell)
{
	if(!isdefined(cell))
	{
		return;
	}
	previous = cell cell_get_previous();
	next = cell cell_get_next();
	previoussharedwall = maze_cells_get_shared_wall(previous, cell);
	nextsharedwall = maze_cells_get_shared_wall(cell, next);
	for(i = 0; i < cell.walls.size; i++)
	{
		wall = cell.walls[i];
		activatewall = 1;
		if(isdefined(previoussharedwall) && wall == previoussharedwall || (isdefined(nextsharedwall) && wall == nextsharedwall) || (!isdefined(previous) && wall.adjacentcells.size == 1) || (!isdefined(next) && wall.adjacentcells.size == 1))
		{
			activatewall = 0;
		}
		wall thread maze_mover_active(activatewall);
	}
}

/*
	Name: raise_floor
	Namespace: zm_temple_traps
	Checksum: 0xDF1965BE
	Offset: 0x4230
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function raise_floor(mazecell)
{
	if(isdefined(mazecell))
	{
		mazecell.trigger.pathcount++;
		mazecell.floor thread maze_mover_active(1);
		level thread delete_cell_corpses(mazecell);
	}
}

/*
	Name: delete_cell_corpses
	Namespace: zm_temple_traps
	Checksum: 0xCA66184B
	Offset: 0x42A0
	Size: 0xED
	Parameters: 1
	Flags: None
*/
function delete_cell_corpses(mazecell)
{
	bodies = GetCorpseArray();
	for(i = 0; i < bodies.size; i++)
	{
		if(!isdefined(bodies[i]))
		{
			continue;
		}
		if(bodies[i] istouching(mazecell.trigger) || bodies[i] istouching(mazecell.floor))
		{
			bodies[i] thread delete_corpse();
			util::wait_network_frame();
		}
	}
}

/*
	Name: delete_corpse
	Namespace: zm_temple_traps
	Checksum: 0x204A83FF
	Offset: 0x4398
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function delete_corpse()
{
	self endon("death");
	playFX(level._effect["animscript_gib_fx"], self.origin);
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: lower_floor
	Namespace: zm_temple_traps
	Checksum: 0xD4AE6023
	Offset: 0x4400
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function lower_floor(mazecell)
{
	if(isdefined(mazecell))
	{
		mazecell.trigger.pathcount--;
		mazecell.floor thread maze_mover_active(0);
	}
}

/*
	Name: maze_cells_get_shared_wall
	Namespace: zm_temple_traps
	Checksum: 0x5EA5E89A
	Offset: 0x4458
	Size: 0xD7
	Parameters: 2
	Flags: None
*/
function maze_cells_get_shared_wall(a, b)
{
	if(!isdefined(a) || !isdefined(b))
	{
		return undefined;
	}
	for(i = 0; i < a.walls.size; i++)
	{
		for(j = 0; j < b.walls.size; j++)
		{
			if(a.walls[i] == b.walls[j])
			{
				return a.walls[i];
			}
		}
	}
	return undefined;
}

/*
	Name: maze_show_starts
	Namespace: zm_temple_traps
	Checksum: 0x40273D55
	Offset: 0x4538
	Size: 0x4D
	Parameters: 0
	Flags: None
*/
function maze_show_starts()
{
	for(i = 0; i < level.startcells.size; i++)
	{
		raise_floor(level.startcells[i]);
	}
}

/*
	Name: maze_start_path
	Namespace: zm_temple_traps
	Checksum: 0x3FF346C7
	Offset: 0x4590
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function maze_start_path()
{
	level.pathactive = 1;
	for(i = 0; i < level.startcells.size; i++)
	{
		lower_floor(level.startcells[i]);
	}
	self maze_generate_path();
	level thread maze_path_timer(10);
}

/*
	Name: maze_end_path
	Namespace: zm_temple_traps
	Checksum: 0x44BC1800
	Offset: 0x4628
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function maze_end_path()
{
	level notify("maze_path_end");
	level.pathactive = 0;
	level thread maze_show_starts_delayed();
}

/*
	Name: maze_show_starts_delayed
	Namespace: zm_temple_traps
	Checksum: 0x5641CFFB
	Offset: 0x4668
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function maze_show_starts_delayed()
{
	level endon("maze_all_safe");
	wait(3);
	maze_show_starts();
}

/*
	Name: maze_path_timer
	Namespace: zm_temple_traps
	Checksum: 0x7AB7CB61
	Offset: 0x4698
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function maze_path_timer(time)
{
	level endon("maze_path_end");
	level endon("maze_all_safe");
	vibrateTime = 3;
	wait(time - vibrateTime);
	level thread maze_vibrate_floor_stop();
	level thread maze_vibrate_active_floors(vibrateTime);
	wait(vibrateTime);
	level notify("maze_timer_end");
	level thread repath_zombies_in_maze();
}

/*
	Name: repath_zombies_in_maze
	Namespace: zm_temple_traps
	Checksum: 0xDBD45999
	Offset: 0x4738
	Size: 0x129
	Parameters: 0
	Flags: None
*/
function repath_zombies_in_maze()
{
	util::wait_network_frame();
	zombies = GetAITeamArray(level.zombie_team);
	for(i = 0; i < zombies.size; i++)
	{
		zombie = zombies[i];
		if(!isdefined(zombie))
		{
			continue;
		}
		if(!isdefined(zombie.animName) || zombie.animName == "monkey_zombie")
		{
			continue;
		}
		if(zombie zombie_on_path() || zombie zombie_on_mud())
		{
			zombie notify("stop_find_flesh");
			zombie notify("zombie_acquire_enemy");
			util::wait_network_frame();
			zombie.ai_state = "find_flesh";
		}
	}
}

/*
	Name: maze_vibrate_active_floors
	Namespace: zm_temple_traps
	Checksum: 0x91B2B69B
	Offset: 0x4870
	Size: 0x19B
	Parameters: 1
	Flags: None
*/
function maze_vibrate_active_floors(time)
{
	level endon("maze_path_end");
	level endon("maze_all_safe");
	endTime = GetTime() + time * 1000;
	while(endTime > GetTime())
	{
		for(i = 0; i < level.mazecells.size; i++)
		{
			cell = level.mazecells[i];
			if(cell.floor.isActive)
			{
				cell thread maze_vibrate_floor(endTime - GetTime() / 1000);
				players = GetPlayers();
				for(w = 0; w < players.size; w++)
				{
					if(players[w] istouching(cell.trigger))
					{
						cell.trigger thread trigger::function_thread(players[w], &temple_maze_player_vibrate_on, &temple_maze_player_vibrate_off);
					}
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: temple_maze_player_vibrate_on
	Namespace: zm_temple_traps
	Checksum: 0xF621A88E
	Offset: 0x4A18
	Size: 0x73
	Parameters: 2
	Flags: None
*/
function temple_maze_player_vibrate_on(player, endon_condition)
{
	if(isdefined(endon_condition))
	{
		player endon(endon_condition);
	}
	player clientfield::set_to_player("floorrumble", 1);
	util::wait_network_frame();
	self thread temple_inactive_floor_rumble_cancel(player);
}

/*
	Name: temple_maze_player_vibrate_off
	Namespace: zm_temple_traps
	Checksum: 0xE4646F47
	Offset: 0x4A98
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function temple_maze_player_vibrate_off(player)
{
	player endon("frc");
	player clientfield::set_to_player("floorrumble", 0);
	player notify("frc");
}

/*
	Name: temple_inactive_floor_rumble_cancel
	Namespace: zm_temple_traps
	Checksum: 0x917F4BD2
	Offset: 0x4AE8
	Size: 0x11B
	Parameters: 1
	Flags: None
*/
function temple_inactive_floor_rumble_cancel(ent_player)
{
	ent_player endon("frc");
	floor_piece = undefined;
	maze_floor_array = GetEntArray("maze_floor", "targetname");
	for(i = 0; i < maze_floor_array.size; i++)
	{
		if(maze_floor_array[i].script_int == self.script_int)
		{
			floor_piece = maze_floor_array[i];
		}
	}
	while(isdefined(floor_piece) && floor_piece.isActive == 1)
	{
		wait(0.05);
	}
	if(isdefined(ent_player))
	{
		ent_player clientfield::set_to_player("floorrumble", 0);
	}
	ent_player notify("frc");
}

/*
	Name: maze_vibrate_floor
	Namespace: zm_temple_traps
	Checksum: 0xFB5A4B6F
	Offset: 0x4C10
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function maze_vibrate_floor(time)
{
	if(isdefined(self.isvibrating) && self.isvibrating)
	{
		return;
	}
	self.floor playsound("evt_maze_floor_collapse");
	self.isvibrating = 1;
	dir = (RandomFloatRange(-1, 1), RandomFloatRange(-1, 1), 0);
	self.floor vibrate(dir, 0.75, 0.3, time);
	wait(time);
	self.isvibrating = 0;
}

/*
	Name: maze_vibrate_floor_stop
	Namespace: zm_temple_traps
	Checksum: 0x84AD0F6B
	Offset: 0x4CF0
	Size: 0x125
	Parameters: 0
	Flags: None
*/
function maze_vibrate_floor_stop()
{
	level util::waittill_any("maze_path_end", "maze_timer_end", "maze_all_safe");
	for(i = 0; i < level.mazecells.size; i++)
	{
		cell = level.mazecells[i];
		if(isdefined(cell.isvibrating) && cell.isvibrating)
		{
			cell.floor vibrate((0, 0, 1), 1, 1, 0.05);
			cell.floor RotateTo(cell.floor.startAngles, 0.1);
			cell.floor stopsounds();
		}
	}
}

/*
	Name: maze_generate_path
	Namespace: zm_temple_traps
	Checksum: 0xA5545057
	Offset: 0x4E20
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function maze_generate_path()
{
	level.mazepath = [];
	for(i = 0; i < level.mazecells.size; i++)
	{
		level.mazecells[i].pathindex = -1;
	}
	path_index = self pick_random_path_index();
	path = level.mazepaths[path_index].path;
	level.mazepathlaststart = path[0];
	level.mazepathlastend = path[path.size - 1];
	for(i = 0; i < path.size; i++)
	{
		level.mazepath[i] = level.mazecells[path[i]];
		level.mazepath[i].pathindex = i;
	}
	level.mazepathcounter++;
}

/*
	Name: pick_random_path_index
	Namespace: zm_temple_traps
	Checksum: 0x5769542E
	Offset: 0x4F60
	Size: 0x1F3
	Parameters: 0
	Flags: None
*/
function pick_random_path_index()
{
	startIndex = 0;
	for(i = 0; i < level.mazecells.size; i++)
	{
		if(level.mazecells[i] == self)
		{
			startIndex = i;
			break;
		}
	}
	path_indexes = [];
	for(i = 0; i < level.mazepaths.size; i++)
	{
		path_indexes[i] = i;
	}
	path_indexes = Array::randomize(path_indexes);
	returnindex = -1;
	for(i = 0; i < path_indexes.size; i++)
	{
		index = path_indexes[i];
		path = level.mazepaths[index].path;
		if(level.mazepaths[index].loopback)
		{
			if(level.mazepathcounter < 3)
			{
				continue;
			}
			if(RandomFloat(100) > 40)
			{
				continue;
			}
		}
		if(isdefined(level.mazepathlaststart) && isdefined(level.mazepathlastend))
		{
			if(level.mazepathlaststart == path[0] && level.mazepathlastend == path[path.size - 1])
			{
				continue;
			}
		}
		if(startIndex == path[0])
		{
			returnindex = index;
			break;
		}
	}
	return returnindex;
}

/*
	Name: cell_get_next
	Namespace: zm_temple_traps
	Checksum: 0x2ACCA835
	Offset: 0x5160
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function cell_get_next()
{
	index = self.pathindex;
	if(index < level.mazepath.size - 1)
	{
		return level.mazepath[index + 1];
	}
	return undefined;
}

/*
	Name: cell_get_previous
	Namespace: zm_temple_traps
	Checksum: 0x5DD35934
	Offset: 0x51B0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function cell_get_previous()
{
	index = self.pathindex;
	if(index > 0)
	{
		return level.mazepath[index - 1];
	}
	return undefined;
}

/*
	Name: zombie_waterfall_knockdown
	Namespace: zm_temple_traps
	Checksum: 0x8DEEEEEA
	Offset: 0x51F8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function zombie_waterfall_knockdown(entity)
{
	self endon("death");
	self.lander_knockdown = 1;
	wait(1.25);
	self zombie_utility::setup_zombie_knockdown(entity);
}

/*
	Name: override_thundergun_damage_func
	Namespace: zm_temple_traps
	Checksum: 0x3A438BC1
	Offset: 0x5248
	Size: 0x9B
	Parameters: 2
	Flags: None
*/
function override_thundergun_damage_func(player, gib)
{
	dmg_point = struct::get("waterfall_dmg_point", "script_noteworthy");
	self.thundergun_handle_pain_notetracks = &handle_knockdown_pain_notetracks;
	self DoDamage(1, dmg_point.origin);
	self animcustom(&zm_weap_thundergun::playThundergunPainAnim);
}

/*
	Name: handle_knockdown_pain_notetracks
	Namespace: zm_temple_traps
	Checksum: 0x3D0337CF
	Offset: 0x52F0
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function handle_knockdown_pain_notetracks(note)
{
}

