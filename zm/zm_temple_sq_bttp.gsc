#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\zm_temple_sq;
#using scripts\zm\zm_temple_sq_brock;
#using scripts\zm\zm_temple_sq_skits;

#namespace zm_temple_sq_bttp;

/*
	Name: init
	Namespace: zm_temple_sq_bttp
	Checksum: 0x830FAFC7
	Offset: 0x520
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function init()
{
	zm_sidequests::declare_sidequest_stage("sq", "bttp", &init_stage, &stage_logic, &exit_stage);
	zm_sidequests::set_stage_time_limit("sq", "bttp", 300);
	zm_sidequests::declare_stage_asset_from_struct("sq", "bttp", "sq_bttp_glyph", undefined, &bttp_damage_thread);
}

/*
	Name: init_stage
	Namespace: zm_temple_sq_bttp
	Checksum: 0x78374DEE
	Offset: 0x5E0
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function init_stage()
{
	if(isdefined(level._sq_skel))
	{
		level._sq_skel ghost();
	}
	level._num_done = 0;
	zm_temple_sq_brock::delete_radio();
	a_e_spike_traps = GetEntArray("sq_spiketrap", "targetname");
	Array::thread_all(a_e_spike_traps, &trap_thread);
	level thread delayed_start_skit();
}

/*
	Name: delayed_start_skit
	Namespace: zm_temple_sq_bttp
	Checksum: 0xEE9F00A7
	Offset: 0x6A0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function delayed_start_skit()
{
	wait(0.5);
	level thread zm_temple_sq_skits::start_skit("tt6");
}

/*
	Name: trap_trigger
	Namespace: zm_temple_sq_bttp
	Checksum: 0x6D10CB84
	Offset: 0x6D8
	Size: 0xED
	Parameters: 0
	Flags: None
*/
function trap_trigger()
{
	level endon("sq_bttp_over");
	while(1)
	{
		self waittill("damage", amount, attacker, direction, point, dmg_type, modelName, tagName);
		if(isPlayer(attacker) && (dmg_type == "MOD_EXPLOSIVE" || dmg_type == "MOD_EXPLOSIVE_SPLASH" || dmg_type == "MOD_GRENADE" || dmg_type == "MOD_GRENADE_SPLASH"))
		{
			self.owner_ent notify("triggered", attacker);
			return;
		}
	}
}

/*
	Name: trap_thread
	Namespace: zm_temple_sq_bttp
	Checksum: 0x319F992A
	Offset: 0x7D0
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function trap_thread()
{
	level endon("sq_bttp_over");
	self.trigger = spawn("trigger_damage", self.origin, 0, 32, 72);
	self.trigger.height = 72;
	self.trigger.radius = 32;
	self.trigger.owner_ent = self;
	self.trigger thread trap_trigger();
	self waittill("triggered", who);
	who thread zm_audio::create_and_play_dialog("eggs", "quest1", 7);
	self.trigger playsound("evt_sq_bttp_wood_explo");
	self ghost();
	level flag::set("trap_destroyed");
}

/*
	Name: bttp_debug
	Namespace: zm_temple_sq_bttp
	Checksum: 0x7B4B813D
	Offset: 0x910
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function bttp_debug()
{
	/#
		self endon("death");
		self endon("done");
		level endon("sq_bttp_over");
		while(!(isdefined(level.disable_print3d_ent) && level.disable_print3d_ent))
		{
			print3d(self.origin, "Dev Block strings are not supported", VectorScale((0, 0, 1), 255), 1);
			wait(0.1);
		}
	#/
}

/*
	Name: bttp_damage_thread
	Namespace: zm_temple_sq_bttp
	Checksum: 0x56DA5F35
	Offset: 0x998
	Size: 0x1BB
	Parameters: 0
	Flags: None
*/
function bttp_damage_thread()
{
	hits = 0;
	self thread bttp_debug();
	while(1)
	{
		self waittill("damage", amount, attacker, dir, point, type);
		self playsound("evt_sq_bttp_carve");
		if(type == "MOD_MELEE")
		{
			hits++;
			if(hits >= 1)
			{
				break;
			}
		}
	}
	self SetModel(self.Tile);
	self notify("done");
	level._num_done++;
	if(isdefined(attacker) && isPlayer(attacker))
	{
		if(level._num_done < level._bttp_num_goal)
		{
			if(randomIntRange(0, 101) <= 75)
			{
				attacker thread zm_audio::create_and_play_dialog("eggs", "quest6", randomIntRange(0, 4));
			}
		}
		else
		{
			attacker thread zm_audio::create_and_play_dialog("eggs", "quest6", 4);
		}
	}
}

/*
	Name: get_unfinished_tile_model
	Namespace: zm_temple_sq_bttp
	Checksum: 0x8A414554
	Offset: 0xB60
	Size: 0x155
	Parameters: 1
	Flags: None
*/
function get_unfinished_tile_model(Tile)
{
	retval = "p_ztem_glyphs_01_unfinished";
	switch(Tile)
	{
		case "p7_zm_sha_glyph_stone_01_unlit":
		{
			retval = "p7_zm_sha_glyph_stone_01";
			break;
		}
		case "p7_zm_sha_glyph_stone_02_unlit":
		{
			retval = "p7_zm_sha_glyph_stone_02";
			break;
		}
		case "p7_zm_sha_glyph_stone_03_unlit":
		{
			retval = "p7_zm_sha_glyph_stone_03";
			break;
		}
		case "p7_zm_sha_glyph_stone_04_unlit":
		{
			retval = "p7_zm_sha_glyph_stone_04";
			break;
		}
		case "p7_zm_sha_glyph_stone_05_unlit":
		{
			retval = "p7_zm_sha_glyph_stone_05";
			break;
		}
		case "p7_zm_sha_glyph_stone_06_unlit":
		{
			retval = "p7_zm_sha_glyph_stone_06";
			break;
		}
		case "p7_zm_sha_glyph_stone_07_unlit":
		{
			retval = "p7_zm_sha_glyph_stone_07";
			break;
		}
		case "p7_zm_sha_glyph_stone_08_unlit":
		{
			retval = "p7_zm_sha_glyph_stone_08";
			break;
		}
		case "p7_zm_sha_glyph_stone_09_unlit":
		{
			retval = "p7_zm_sha_glyph_stone_09";
			break;
		}
		case "p7_zm_sha_glyph_stone_10_unlit":
		{
			retval = "p7_zm_sha_glyph_stone_10";
			break;
		}
		case "p7_zm_sha_glyph_stone_11_unlit":
		{
			retval = "p7_zm_sha_glyph_stone_11";
			break;
		}
		case "p7_zm_sha_glyph_stone_12_unlit":
		{
			retval = "p7_zm_sha_glyph_stone_12";
			break;
		}
	}
	return retval;
}

/*
	Name: stage_logic
	Namespace: zm_temple_sq_bttp
	Checksum: 0x5E39524A
	Offset: 0xCC0
	Size: 0x1E3
	Parameters: 0
	Flags: None
*/
function stage_logic()
{
	level endon("sq_bttp_over");
	tile_models = Array("p7_zm_sha_glyph_stone_01_unlit", "p7_zm_sha_glyph_stone_02_unlit", "p7_zm_sha_glyph_stone_03_unlit", "p7_zm_sha_glyph_stone_04_unlit", "p7_zm_sha_glyph_stone_05_unlit", "p7_zm_sha_glyph_stone_06_unlit", "p7_zm_sha_glyph_stone_07_unlit", "p7_zm_sha_glyph_stone_08_unlit", "p7_zm_sha_glyph_stone_09_unlit", "p7_zm_sha_glyph_stone_10_unlit", "p7_zm_sha_glyph_stone_11_unlit", "p7_zm_sha_glyph_stone_12_unlit");
	tile_models = Array::randomize(tile_models);
	ents = GetEntArray("sq_bttp_glyph", "targetname");
	level._bttp_num_goal = ents.size;
	for(i = 0; i < ents.size; i++)
	{
		ents[i].Tile = get_unfinished_tile_model(tile_models[i]);
		ents[i] SetModel(tile_models[i]);
	}
	while(1)
	{
		if(level._num_done == ents.size)
		{
			break;
		}
		wait(0.1);
	}
	level flag::wait_till("trap_destroyed");
	level notify("suspend_timer");
	wait(5);
	zm_sidequests::stage_completed("sq", "bttp");
}

/*
	Name: exit_stage
	Namespace: zm_temple_sq_bttp
	Checksum: 0x9E6C47B2
	Offset: 0xEB0
	Size: 0x1E1
	Parameters: 1
	Flags: None
*/
function exit_stage(success)
{
	a_e_spike_traps = GetEntArray("sq_spiketrap", "targetname");
	if(success)
	{
		zm_temple_sq::remove_skel();
		zm_temple_sq_brock::create_radio(7, &zm_temple_sq_brock::radio7_override);
	}
	else if(isdefined(level._sq_skel))
	{
		level._sq_skel show();
	}
	zm_temple_sq_brock::create_radio(6);
	foreach(e_trap in a_e_spike_traps)
	{
		e_trap show();
	}
	level thread zm_temple_sq_skits::fail_skit();
	foreach(e_trap in a_e_spike_traps)
	{
		if(isdefined(e_trap.trigger))
		{
			e_trap.trigger delete();
		}
	}
}

