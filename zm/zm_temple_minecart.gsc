#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace zm_temple_minecart;

/*
	Name: precache_assets
	Namespace: zm_temple_minecart
	Checksum: 0x62CAB016
	Offset: 0x5A8
	Size: 0x1D
	Parameters: 0
	Flags: None
*/
function precache_assets()
{
	level._effect["fx_headlight"] = "env/light/fx_flashlight_ai_spotlight";
}

/*
	Name: minecart_main
	Namespace: zm_temple_minecart
	Checksum: 0x4FB7C879
	Offset: 0x5D0
	Size: 0x95
	Parameters: 0
	Flags: None
*/
function minecart_main()
{
	level flag::init("players_riding_minecart");
	level.minecart_levers = GetEntArray("minecart_lever_trigger", "targetname");
	for(i = 0; i < level.minecart_levers.size; i++)
	{
		level.minecart_levers[i] thread minecart_lever_think();
	}
}

/*
	Name: minecart_setup
	Namespace: zm_temple_minecart
	Checksum: 0x8C7FB37F
	Offset: 0x670
	Size: 0x763
	Parameters: 0
	Flags: None
*/
function minecart_setup()
{
	self.DrivePath = 0;
	self.Accel = 5;
	self.Decel = 30;
	self.loopingpath = self.script_string === "loopingPath";
	self.away = 0;
	self.passengers = [];
	self.floorheight = 24;
	self.width = 20;
	self.linkEnts = [];
	minecart_add_linkent((50, self.width, self.floorheight));
	minecart_add_linkent((50, 0 - self.width, self.floorheight));
	minecart_add_linkent((-66, self.width, self.floorheight));
	minecart_add_linkent((-66, 0 - self.width, self.floorheight));
	minecart_add_linkent((-8, 0, self.floorheight));
	self.headlights_offset = (87, 0, 15);
	self.headlights_angles = (0, 0, 0);
	self.headlights_offset_reverse = (0 - self.headlights_offset[0], self.headlights_offset[1], self.headlights_offset[2]);
	self.headlights_angles_reverse = VectorScale((0, 1, 0), 180);
	self.start_switch = GetEnt(self.targetname + "_start_switch", "targetname");
	self.cage = GetEnt(self.targetname + "_cage", "targetname");
	if(isdefined(self.cage))
	{
		self.cage LinkTo(self);
	}
	self.cage_door = GetEnt(self.targetname + "_cage_door", "targetname");
	if(isdefined(self.cage_door))
	{
		self.cage_door LinkTo(self);
		self.cage_door notsolid();
	}
	self.door = GetEnt(self.targetname + "_door", "targetname");
	if(isdefined(self.door))
	{
		self.door.closed = 1;
		self.door.clip = GetEnt(self.targetname + "_door_clip", "targetname");
		self thread _minecart_open_door(1);
	}
	self.pusher = GetEnt(self.targetname + "_pusher", "targetname");
	if(isdefined(self.pusher))
	{
		self.pusher.out = 0;
	}
	self.floor = GetEnt(self.targetname + "_floor", "targetname");
	if(isdefined(self.floor))
	{
		self.floor LinkTo(self);
	}
	self.front = GetEnt(self.targetname + "_front", "targetname");
	if(isdefined(self.front))
	{
		self.front LinkTo(self);
	}
	self.front_doors = GetEntArray(self.targetname + "_front_door", "targetname");
	self.front_doors_closed = 1;
	self.front_doors_clip = GetEnt(self.targetname + "_front_door_clip", "targetname");
	self.start_volume = GetEnt(self.targetname + "_start_volume", "targetname");
	if(isdefined(self.start_volume))
	{
		self.start_volume.minecart = self;
		self.start_volume thread show_players_on_mine_cart();
	}
	self.trigger_splash = GetEnt("trigger_minecart_water_splash", "targetname");
	if(isdefined(self.trigger_splash))
	{
		self.trigger_splash thread minecart_trigger_splash_think();
	}
	self.speaker_left = spawn("script_model", self.origin);
	self.speaker_left SetModel("tag_origin");
	self.speaker_left LinkTo(self, "tag_origin", (0, 32, 40));
	util::wait_network_frame();
	self.speaker_right = spawn("script_model", self.origin);
	self.speaker_right SetModel("tag_origin");
	self.speaker_right LinkTo(self, "tag_origin", (0, -32, 40));
	blockers = GetEntArray(self.targetname + "_blocker", "targetname");
	Array::thread_all(blockers, &blocker_think, self);
	level.minecart_force_zone_active = 0;
	self minecart_begin_path("start");
	self minecart_stop();
}

/*
	Name: blocker_think
	Namespace: zm_temple_minecart
	Checksum: 0x7BF882AF
	Offset: 0xDE0
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function blocker_think(minecart)
{
	minecart endon("minecart_end");
	minecart waittill("minecart_start");
	while(1)
	{
		if(self blocker_is_mine_cart_touching(minecart))
		{
			self thread blocker_break();
			break;
		}
		wait(0.05);
	}
}

/*
	Name: blocker_is_mine_cart_touching
	Namespace: zm_temple_minecart
	Checksum: 0xDAD062F3
	Offset: 0xE58
	Size: 0x49
	Parameters: 1
	Flags: None
*/
function blocker_is_mine_cart_touching(minecart)
{
	dist2 = Distance2DSquared(minecart.origin, self.origin);
	return dist2 < 4900;
}

/*
	Name: blocker_is_any_player_touching
	Namespace: zm_temple_minecart
	Checksum: 0xDFFBA077
	Offset: 0xEB0
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function blocker_is_any_player_touching()
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i] istouching(self))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: blocker_break
	Namespace: zm_temple_minecart
	Checksum: 0x153B5B05
	Offset: 0xF28
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function blocker_break()
{
	level thread scene::Play("p7_fxanim_zm_sha_minecart_gate_bundle");
	exploder::exploder("fxexp_400");
	self playsound("evt_minecart_barrier");
}

/*
	Name: minecart_add_linkent
	Namespace: zm_temple_minecart
	Checksum: 0x82DFFCBA
	Offset: 0xF90
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function minecart_add_linkent(offsetOrigin)
{
	linkEnt = spawn("script_model", (0, 0, 0));
	linkEnt.offsetOrigin = offsetOrigin;
	linkEnt LinkTo(self, "", linkEnt.offsetOrigin, (0, 0, 0));
	linkEnt SetModel("tag_origin");
	linkEnt.occupied = 0;
	self.linkEnts[self.linkEnts.size] = linkEnt;
	util::wait_network_frame();
}

/*
	Name: minecart_link_passengers
	Namespace: zm_temple_minecart
	Checksum: 0x1B994E5B
	Offset: 0x1070
	Size: 0x4CB
	Parameters: 0
	Flags: None
*/
function minecart_link_passengers()
{
	wait(0.5);
	players = GetPlayers();
	if(isdefined(self.cage_door))
	{
		self.cage_door solid();
	}
	for(i = 0; i < self.linkEnts.size; i++)
	{
		self.linkEnts[i].claimed = 0;
	}
	linkplayers = [];
	for(p = 0; p < players.size; p++)
	{
		player = players[p];
		closestEnt = undefined;
		closestdist = 0;
		playernear = self minecart_contains(player);
		if(!playernear)
		{
			continue;
		}
		linkplayers[linkplayers.size] = player;
		for(e = 0; e < self.linkEnts.size; e++)
		{
			linkEnt = self.linkEnts[e];
			dist = DistanceSquared(player.origin, linkEnt.origin);
			if(!linkEnt.claimed && (!isdefined(closestEnt) || dist < closestdist))
			{
				closestEnt = linkEnt;
				closestdist = dist;
			}
		}
		closestEnt.claimed = 1;
		player.minecart_link = closestEnt;
	}
	Array::thread_all(linkplayers, &player_minecart_ride, self);
	level thread delayed_player_response_to_minecart_ride(linkplayers);
	zombies = GetAISpeciesArray("axis", "all");
	zombie_sort = util::get_array_of_closest(self.origin, zombies, undefined, undefined, 300);
	self.linkzombies = [];
	for(i = 0; i < zombie_sort.size; i++)
	{
		zombie = zombie_sort[i];
		closestEnt = undefined;
		closestdist = 0;
		if(zombie.animName == "monkey_zombie")
		{
			continue;
		}
		if(isdefined(zombie.shrinked) && zombie.shrinked)
		{
			continue;
		}
		zombienear = self minecart_contains(zombie);
		if(!zombienear)
		{
			continue;
		}
		for(e = 0; e < self.linkEnts.size; e++)
		{
			linkEnt = self.linkEnts[e];
			dist = DistanceSquared(zombie.origin, linkEnt.origin);
			if(!linkEnt.claimed && (!isdefined(closestEnt) || dist < closestdist))
			{
				closestEnt = linkEnt;
				closestdist = dist;
			}
		}
		if(isdefined(closestEnt))
		{
			closestEnt.claimed = 1;
			zombie.minecart_link = closestEnt;
			self.linkzombies[self.linkzombies.size] = zombie;
		}
	}
	Array::thread_all(self.linkzombies, &zombie_minecart_ride, self);
}

/*
	Name: player_minecart_ride
	Namespace: zm_temple_minecart
	Checksum: 0x3867337F
	Offset: 0x1548
	Size: 0x16B
	Parameters: 1
	Flags: None
*/
function player_minecart_ride(minecart)
{
	self endon("death");
	self endon("disconnect");
	level endon("minecart_end");
	self.is_on_minecart = 1;
	self AllowSprint(0);
	turn_angle = 360;
	pitch_up = 90;
	PITCH_DOWN = 75;
	if(self laststand::player_is_in_laststand())
	{
		self SetOrigin(self.minecart_link.origin);
		while(self laststand::player_is_in_laststand())
		{
			wait(0.1);
		}
	}
	else
	{
		self EnableInvulnerability();
		self playerlinktominecart(360);
		wait(1);
	}
	self EnableInvulnerability();
	self playerlinktominecart(360);
	self thread minecart_screen_shake();
}

/*
	Name: zombie_minecart_ride
	Namespace: zm_temple_minecart
	Checksum: 0xE1772631
	Offset: 0x16C0
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function zombie_minecart_ride(minecart)
{
	level endon("minecart_end");
	self SetPlayerCollision(0);
	self LinkTo(self.minecart_link, "tag_origin", (0, 0, 0), (0, 0, 0));
	self waittill("death");
	self Unlink();
}

/*
	Name: minecart_screen_shake
	Namespace: zm_temple_minecart
	Checksum: 0xC89A9E03
	Offset: 0x1748
	Size: 0xCF
	Parameters: 1
	Flags: None
*/
function minecart_screen_shake(activeTime)
{
	self endon("death");
	self endon("disconnect");
	self endon("minecart_exit");
	self clientfield::set_to_player("minecart_rumble", 1);
	while(1)
	{
		Earthquake(RandomFloatRange(0.1, 0.2), RandomFloatRange(1, 2), self.origin, 100, self);
		wait(RandomFloatRange(0.1, 0.3));
	}
}

/*
	Name: playerlinktominecart
	Namespace: zm_temple_minecart
	Checksum: 0x2F7EFEC1
	Offset: 0x1820
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function playerlinktominecart(view_yaw)
{
	if(!self laststand::player_is_in_laststand())
	{
		self SetStance("crouch");
		self AllowStand(0);
		self AllowProne(0);
		self clientfield::set("player_legs_hide", 1);
	}
	self PlayerLinkToDelta(self.minecart_link, undefined, 1, view_yaw, view_yaw, 90, 75, 1);
}

/*
	Name: minecart_unlink_passengers
	Namespace: zm_temple_minecart
	Checksum: 0x4EA130DE
	Offset: 0x18F8
	Size: 0x1F5
	Parameters: 1
	Flags: None
*/
function minecart_unlink_passengers(throw_velocity)
{
	self notify("minecart_end");
	level notify("minecart_end");
	if(isdefined(self.front))
	{
		self.front notsolid();
	}
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(isdefined(player.minecart_link))
		{
			player clientfield::set("player_legs_hide", 0);
			player Unlink();
			player SetVelocity(throw_velocity);
			player.minecart_link = undefined;
			player.is_on_minecart = 0;
			inLastStand = player laststand::player_is_in_laststand();
			if(!inLastStand)
			{
				player AllowCrouch(1);
				player AllowProne(1);
				player AllowLean(1);
				player AllowStand(1);
				player SetStance("stand");
			}
			player AllowSprint(1);
		}
	}
}

/*
	Name: minecart_throw_zombie
	Namespace: zm_temple_minecart
	Checksum: 0x6416859A
	Offset: 0x1AF8
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function minecart_throw_zombie(zombie, vel)
{
	if(!isdefined(zombie))
	{
		return;
	}
	zombie StartRagdoll();
	zombie LaunchRagdoll(vel);
	util::wait_network_frame();
	level.zombie_total++;
	if(isdefined(zombie))
	{
		zombie DoDamage(zombie.health + 666, zombie.origin);
	}
}

/*
	Name: minecart_contains
	Namespace: zm_temple_minecart
	Checksum: 0x72836A8F
	Offset: 0x1BA8
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function minecart_contains(ent)
{
	if(isdefined(self.start_volume))
	{
		return ent istouching(self.start_volume);
	}
	else
	{
		return Distance2D(ent.origin, self.origin) < 120;
	}
}

/*
	Name: get_ai_touching_volume
	Namespace: zm_temple_minecart
	Checksum: 0x56C4EFEB
	Offset: 0x1C18
	Size: 0xE1
	Parameters: 2
	Flags: None
*/
function get_ai_touching_volume(team, volume)
{
	ai_list = GetAIArray();
	return_set = [];
	foreach(ai in ai_list)
	{
		if(ai istouching(volume))
		{
			return_set[return_set.size] = ai;
		}
	}
	return return_set;
}

/*
	Name: _minecart_nuke
	Namespace: zm_temple_minecart
	Checksum: 0x7C189904
	Offset: 0x1D08
	Size: 0xFD
	Parameters: 0
	Flags: None
*/
function _minecart_nuke()
{
	ai_list = get_ai_touching_volume(level.zombie_team, self.start_volume);
	for(i = 0; i < ai_list.size; i++)
	{
		wait(RandomFloatRange(0.05, 0.1));
		if(!isdefined(ai_list[i]))
		{
			continue;
		}
		if(isdefined(ai_list[i].minecart_link))
		{
			continue;
		}
		level.zombie_total++;
		ai_list[i] DoDamage(ai_list[i].health + 100, ai_list[i].origin);
	}
}

/*
	Name: _minecart_fire_spikemores
	Namespace: zm_temple_minecart
	Checksum: 0x679FEEA7
	Offset: 0x1E10
	Size: 0x1A5
	Parameters: 0
	Flags: None
*/
function _minecart_fire_spikemores()
{
	if(!isdefined(level.spikemores) || level.spikemores.size <= 0)
	{
		return;
	}
	minecart_spikemores = [];
	for(i = 0; i < level.spikemores.size; i++)
	{
		if(!isdefined(level.spikemores[i]))
		{
			continue;
		}
		trace = GroundTrace(level.spikemores[i].origin, level.spikemores[i].origin + VectorScale((0, 0, -1), 24), 0, level.spikemores[i]);
		if(isdefined(trace["entity"]))
		{
			if(self == trace["entity"] || (isdefined(self.floor) && self.floor == trace["entity"]))
			{
				if(!isdefined(minecart_spikemores))
				{
					minecart_spikemores = [];
				}
				else if(!IsArray(minecart_spikemores))
				{
					minecart_spikemores = Array(minecart_spikemores);
				}
				minecart_spikemores[minecart_spikemores.size] = level.spikemores[i];
			}
		}
	}
}

/*
	Name: minecart_spikemore_detonate
	Namespace: zm_temple_minecart
	Checksum: 0x99EC1590
	Offset: 0x1FC0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function minecart_spikemore_detonate()
{
}

/*
	Name: minecart_begin_path
	Namespace: zm_temple_minecart
	Checksum: 0x89263928
	Offset: 0x1FD0
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function minecart_begin_path(name)
{
	node = GetVehicleNode(self.targetname + "_" + name, "targetname");
	if(isdefined(node))
	{
		self AttachPath(node);
		self StartPath();
	}
}

/*
	Name: minecart_start
	Namespace: zm_temple_minecart
	Checksum: 0xE15A5E5C
	Offset: 0x2060
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function minecart_start(Accel)
{
	self notify("minecart_start");
	if(!isdefined(Accel))
	{
		Accel = self.Accel;
	}
	self ResumeSpeed(Accel);
	self thread minecart_animate_wheels();
}

/*
	Name: minecart_animate_wheels
	Namespace: zm_temple_minecart
	Checksum: 0x6861B2B5
	Offset: 0x20D0
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function minecart_animate_wheels()
{
	self endon("death");
	if(!isdefined(self.wheel_spin_scale))
	{
		self.wheel_spin_scale = 1;
	}
	self waittill("wheels_turn_stop");
}

/*
	Name: minecart_stop
	Namespace: zm_temple_minecart
	Checksum: 0x97096CD5
	Offset: 0x2110
	Size: 0x71
	Parameters: 2
	Flags: None
*/
function minecart_stop(Accel, Decel)
{
	if(!isdefined(Accel))
	{
		Accel = self.Accel;
	}
	if(!isdefined(Decel))
	{
		Decel = self.Decel;
	}
	self SetSpeed(0, Accel, Decel);
	self notify("wheels_turn_stop");
}

/*
	Name: minecart_stop_instant
	Namespace: zm_temple_minecart
	Checksum: 0x762C05CE
	Offset: 0x2190
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function minecart_stop_instant()
{
	self SetSpeed(0, 10000);
	self notify("wheels_turn_stop");
}

/*
	Name: minecart_lever_move
	Namespace: zm_temple_minecart
	Checksum: 0x81428B6E
	Offset: 0x21C8
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function minecart_lever_move(to_on_position)
{
	playsoundatposition("evt_mine_cart_bar", self.origin);
	if(self.makeinvisible)
	{
		if(to_on_position)
		{
			self SetVisibleToAll();
		}
		else
		{
			self SetInvisibleToAll();
		}
	}
}

/*
	Name: minecart_lever_think
	Namespace: zm_temple_minecart
	Checksum: 0xC1280592
	Offset: 0x2240
	Size: 0xAF9
	Parameters: 0
	Flags: None
*/
function minecart_lever_think()
{
	level endon("fake_death");
	if(!isdefined(self.zombie_cost))
	{
		self.zombie_cost = 250;
	}
	self.cooldowntimer = 10;
	self.makeinvisible = 0;
	self setcursorhint("HINT_NOICON");
	self setHintString("");
	self UseTriggerRequireLookAt();
	self.cost = 250;
	minecart_poi = GetEnt("minecart_poi", "targetname");
	minecart_poi zm_utility::create_zombie_point_of_interest(undefined, 30, 0, 0);
	minecart_poi thread zm_utility::create_zombie_point_of_interest_attractor_positions(4, 45);
	if(isdefined(self.target))
	{
		self.minecart = GetEnt(self.target, "targetname");
	}
	else
	{
		self.minecart = GetEnt("minecart", "targetname");
	}
	self.minecart minecart_setup();
	self minecart_lever_move(0);
	wait_for_flags = 1;
	/#
		wait_for_flags = GetDvarInt("Dev Block strings are not supported") == 0;
	#/
	if(wait_for_flags)
	{
		self setHintString(&"ZOMBIE_NEED_POWER");
		level flag::wait_till("power_on");
		self setHintString(&"ZM_TEMPLE_DESTINATION_NOT_OPEN");
		level flag::wait_till_any(Array("cave_water_to_waterfall", "waterfall_to_tunnel"));
	}
	wait(1);
	level notify("mine_cart_ready");
	while(1)
	{
		self minecart_lever_move(1);
		if(isdefined(self.minecart.cage))
		{
			self.minecart.cage solid();
		}
		if(isdefined(self.minecart.cage_door))
		{
			self.minecart.cage_door notsolid();
		}
		if(isdefined(self.minecart.front))
		{
			self.minecart.front solid();
		}
		self setHintString(&"ZM_TEMPLE_MINECART_COST", self.zombie_cost);
		while(1)
		{
			self waittill("trigger", player);
			if(player zm_score::can_player_purchase(self.zombie_cost))
			{
				zm_utility::play_sound_at_pos("purchase", self.origin);
				player zm_score::minus_to_player_score(self.zombie_cost);
				break;
			}
		}
		level flag::set("players_riding_minecart");
		level thread minecart_clean_up_corpses();
		self TriggerEnable(0);
		self setHintString(&"ZM_TEMPLE_MINECART_UNAVAILABLE");
		if(isdefined(self.minecart.start_switch))
		{
			self.minecart.start_switch RotateRoll(180, 0.3, 0.1, 0.1);
			self.minecart.start_switch waittill("rotatedone");
		}
		frontdooropentime = 0.25;
		self.minecart thread _minecart_open_front_door(frontdooropentime);
		self.minecart thread _minecart_fire_spikemores();
		self.minecart thread _minecart_close_door();
		self.minecart thread _minecart_pusher_out();
		self.minecart.away = 1;
		self.minecart minecart_start();
		self.minecart.speaker_left playsound("evt_minecart_l");
		self.minecart.speaker_right playsound("evt_minecart_r");
		self.minecart.speaker_left PlayLoopSound("zmb_singing", 5);
		self thread minecart_lever_move(0);
		self.minecart minecart_link_passengers();
		self.minecart thread _minecart_nuke();
		self.minecart thread _minecart_close_front_door_delay(2);
		cageopentime = 0.5;
		self.minecart thread _minecart_open_door_delay(cageopentime, 2);
		should_activate_poi = check_should_activate_minecart_poi();
		self.minecart thread minecart_activate_zone();
		zm_zonemgr::zone_init("waterfall_lower_zone");
		zm_zonemgr::enable_zone("waterfall_lower_zone");
		if(should_activate_poi)
		{
			minecart_poi zm_utility::activate_zombie_point_of_interest();
		}
		wait(1);
		self TriggerEnable(1);
		self.minecart waittill("reached_end_node");
		self.minecart minecart_crash();
		self.minecart.speaker_left StopLoopSound(1);
		wait(1);
		level flag::clear("players_riding_minecart");
		if(should_activate_poi)
		{
			minecart_poi zm_utility::deactivate_zombie_point_of_interest();
		}
		if(!GetDvarInt("scr_minecart_cheat"))
		{
			backvehicle = SpawnVehicle("zombie_minecart", self.minecart.origin, self.minecart.angles, self.minecart.targetname + "_reverse");
			backvehicle.DrivePath = 0;
			backvehicle.headlights_offset = self.minecart.headlights_offset_reverse;
			backvehicle.headlights_angles = self.minecart.headlights_angles_reverse;
			backvehicle minecart_stop_instant();
			backvehicle minecart_begin_path("start");
			backvehicle ghost();
			_minecart_lerp(self.minecart, backvehicle);
			backvehicle PlayLoopSound("evt_minecart_climb_loop");
			self.minecart.away = 0;
			self.minecart minecart_begin_path("start");
			backvehicle minecart_start(self.minecart.Accel);
			backvehicle waittill("reached_end_node");
			backvehicle minecart_stop(self.minecart.Accel, self.minecart.Decel);
			_minecart_lerp(backvehicle, self.minecart);
			backvehicle StopLoopSound();
			self.minecart playsound("evt_spiketrap_warn");
			backvehicle delete();
		}
		else
		{
			self.minecart.away = 0;
			self.minecart minecart_begin_path("start");
		}
		if(isdefined(self.minecart.start_switch))
		{
			self.minecart.start_switch RotateRoll(-180, 0.3, 0.1, 0.1);
			self.minecart.start_switch waittill("rotatedone");
		}
	}
}

/*
	Name: check_should_activate_minecart_poi
	Namespace: zm_temple_minecart
	Checksum: 0xB658202E
	Offset: 0x2D48
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function check_should_activate_minecart_poi()
{
	all_players_riding = 1;
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i] laststand::player_is_in_laststand())
		{
			continue;
		}
		if(!(isdefined(players[i].is_on_minecart) && players[i].is_on_minecart))
		{
			all_players_riding = 0;
		}
	}
	return all_players_riding;
}

/*
	Name: _minecart_lerp
	Namespace: zm_temple_minecart
	Checksum: 0x398C27EA
	Offset: 0x2E10
	Size: 0x18B
	Parameters: 3
	Flags: None
*/
function _minecart_lerp(start_vehicle, end_vehicle, time)
{
	model = spawn("script_model", start_vehicle.origin);
	model SetModel(start_vehicle.model);
	model.angles = start_vehicle.angles;
	start_vehicle ghost();
	model moveto(end_vehicle.origin, 1, 0.1, 0.1);
	rotateAngles = (0 - end_vehicle.angles[0], end_vehicle.angles[1] - 180, 0);
	model RotateTo(rotateAngles, 1, 0.1, 0.1);
	model waittill("movedone");
	model delete();
	end_vehicle show();
}

/*
	Name: minecart_crash
	Namespace: zm_temple_minecart
	Checksum: 0x90EBB348
	Offset: 0x2FA8
	Size: 0x4BD
	Parameters: 0
	Flags: None
*/
function minecart_crash()
{
	speed = 500;
	self minecart_stop_instant();
	exploder::exploder("fxexp_6");
	if(isdefined(self.trigger_splash))
	{
		self.trigger_splash thread minecart_trigger_splash_activate();
	}
	FORWARD = AnglesToForward(self.angles);
	forwardDist = 370;
	throw_velocity = FORWARD * forwardDist + VectorScale((0, 0, 1), 110);
	time = forwardDist / speed;
	players = GetPlayers();
	crashed_players = [];
	if(isdefined(self.front))
	{
		self.front notsolid();
	}
	for(i = 0; i < self.linkzombies.size; i++)
	{
		self thread minecart_throw_zombie(self.linkzombies[i], throw_velocity / 2);
	}
	playersonminecart = [];
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(!isdefined(player.minecart_link))
		{
			continue;
		}
		playersonminecart[playersonminecart.size] = player;
		crashed_players[crashed_players.size] = player;
		player notify("minecart_exit");
		player clientfield::set_to_player("minecart_rumble", 0);
		player PlayRumbleOnEntity("damage_heavy");
		Earthquake(0.5, 2, player.origin, 100, player);
		player.minecart_splash_time = GetTime() + 2000;
		player.minecart_link Unlink();
		if(!isdefined(player GetLinkedEnt()))
		{
			player playerlinktominecart(360);
		}
		player EnableInvulnerability();
		player util::delay(2, undefined, &minecart_remove_invulnerable);
		player.minecart_link MoveGravity(throw_velocity, time);
	}
	throw_velocity = (0, 0, 0);
	wait(time * 0.9 - 0.1);
	if(playersonminecart.size > 0)
	{
		old_origin = playersonminecart[0].minecart_link.origin;
		wait(0.1);
		throw_velocity = playersonminecart[0].minecart_link.origin - old_origin * 10;
	}
	else
	{
		wait(0.1);
	}
	self minecart_unlink_passengers(throw_velocity);
	wait(0.5);
	for(i = 0; i < self.linkEnts.size; i++)
	{
		e = self.linkEnts[i];
		e Unlink();
		e.origin = (0, 0, 0);
		e LinkTo(self, "", e.offsetOrigin, (0, 0, 0));
	}
}

/*
	Name: minecart_remove_invulnerable
	Namespace: zm_temple_minecart
	Checksum: 0x537BD127
	Offset: 0x3470
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function minecart_remove_invulnerable()
{
	if(isdefined(self))
	{
		self DisableInvulnerability();
	}
}

/*
	Name: _poi_ensure_off
	Namespace: zm_temple_minecart
	Checksum: 0x2EABFA1B
	Offset: 0x34A0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function _poi_ensure_off(minecart)
{
	minecart waittill("reached_end_node");
	self zm_utility::deactivate_zombie_point_of_interest();
}

/*
	Name: minecart_activate_zone
	Namespace: zm_temple_minecart
	Checksum: 0x77B49A94
	Offset: 0x34D8
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function minecart_activate_zone()
{
	trigger = GetEnt("force_waterfall_active", "script_noteworthy");
	if(isdefined(trigger))
	{
		trigger waittill("trigger");
		level.minecart_force_zone_active = 1;
		self waittill("reached_end_node");
		level.minecart_force_zone_active = 0;
	}
}

/*
	Name: _minecart_open_door_delay
	Namespace: zm_temple_minecart
	Checksum: 0x995373E7
	Offset: 0x3550
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function _minecart_open_door_delay(time, delay)
{
	wait(delay);
	self thread _minecart_open_door(time);
}

/*
	Name: _minecart_open_door
	Namespace: zm_temple_minecart
	Checksum: 0x8D87B856
	Offset: 0x3590
	Size: 0xDB
	Parameters: 1
	Flags: None
*/
function _minecart_open_door(time)
{
	if(isdefined(self.door))
	{
		if(self.door.closed)
		{
			self.door MoveZ(-130, time, 0.1, 0.1);
			self.door.clip MoveZ(-130, time, 0.1, 0.1);
			self.door waittill("movedone");
			self.door.closed = 0;
			self.door.clip connectpaths();
		}
	}
}

/*
	Name: _minecart_close_door
	Namespace: zm_temple_minecart
	Checksum: 0x77727FB6
	Offset: 0x3678
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function _minecart_close_door()
{
	if(isdefined(self.door))
	{
		if(!self.door.closed)
		{
			self.door MoveZ(130, 0.5, 0.1, 0.1);
			self.door.clip MoveZ(130, 0.1);
			self.door waittill("movedone");
			self.door.closed = 1;
			self.door.clip disconnectpaths();
		}
	}
}

/*
	Name: _minecart_open_front_door
	Namespace: zm_temple_minecart
	Checksum: 0x563143E5
	Offset: 0x3750
	Size: 0xEB
	Parameters: 1
	Flags: None
*/
function _minecart_open_front_door(time)
{
	if(self.front_doors_closed)
	{
		door = undefined;
		for(i = 0; i < self.front_doors.size; i++)
		{
			door = self.front_doors[i];
			door RotateYaw(door.script_vector[1], time, 0.1, 0.1);
		}
		if(isdefined(door))
		{
			door waittill("rotatedone");
		}
		self.front_doors_closed = 0;
		if(isdefined(self.front_doors_clip))
		{
			self.front_doors_clip notsolid();
		}
	}
}

/*
	Name: _minecart_close_front_door
	Namespace: zm_temple_minecart
	Checksum: 0xC96A3FCE
	Offset: 0x3848
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function _minecart_close_front_door()
{
	if(!self.front_doors_closed)
	{
		if(isdefined(self.front_doors_clip))
		{
			self.front_doors_clip solid();
		}
		door = undefined;
		for(i = 0; i < self.front_doors.size; i++)
		{
			door = self.front_doors[i];
			door RotateYaw(-1 * door.script_vector[1], 1, 0.1, 0.1);
		}
		if(isdefined(door))
		{
			door waittill("rotatedone");
		}
		self.front_doors_closed = 1;
	}
}

/*
	Name: _minecart_close_front_door_delay
	Namespace: zm_temple_minecart
	Checksum: 0x40FF18C
	Offset: 0x3940
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function _minecart_close_front_door_delay(delay)
{
	wait(delay);
	self thread _minecart_close_front_door();
}

/*
	Name: _minecart_pusher_out
	Namespace: zm_temple_minecart
	Checksum: 0x267E3C77
	Offset: 0x3970
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function _minecart_pusher_out()
{
	if(isdefined(self.pusher))
	{
		if(!self.pusher.out)
		{
			wait(0.3);
			self.pusher MoveY(166, 2, 0.25, 0.1);
			self.pusher waittill("movedone");
			self.pusher.out = 1;
			level waittill("minecart_returned");
			wait(2.7);
			self thread _minecart_pusher_in();
		}
	}
}

/*
	Name: _minecart_pusher_in
	Namespace: zm_temple_minecart
	Checksum: 0x427567AD
	Offset: 0x3A30
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function _minecart_pusher_in()
{
	if(isdefined(self.pusher))
	{
		if(self.pusher.out)
		{
			self.pusher MoveY(-166, 4, 0.25, 0.1);
			self.pusher waittill("movedone");
			self.pusher.out = 0;
		}
	}
}

/*
	Name: show_players_on_mine_cart
	Namespace: zm_temple_minecart
	Checksum: 0x19241B5B
	Offset: 0x3AB0
	Size: 0x427
	Parameters: 0
	Flags: None
*/
function show_players_on_mine_cart()
{
	height = 0;
	scale = GetEnt("minecart1_scale", "targetname");
	if(!isdefined(scale))
	{
		return;
	}
	scale.origin = scale.origin + VectorScale((0, 0, -1), 37);
	level waittill("mine_cart_ready");
	while(1)
	{
		count = 0;
		if(isdefined(self.minecart) && !self.minecart.away)
		{
			players = GetPlayers();
			for(i = 0; i < players.size; i++)
			{
				if(players[i] istouching(self))
				{
					count++;
				}
			}
		}
		else if(height < count)
		{
			while(height < count)
			{
				rise = 0;
				if(height == 3)
				{
					rise = 10;
				}
				else if(height == 0)
				{
					rise = 11;
				}
				else
				{
					rise = 8;
				}
				height++;
				if(height == count)
				{
					rise = rise + 1;
				}
				scale MoveZ(rise, 0.35, 0.05, 0);
				scale waittill("movedone");
			}
			scale MoveZ(-2, 0.2, 0, 0);
			scale waittill("movedone");
			scale MoveZ(1, 0.1, 0, 0);
			scale waittill("movedone");
		}
		else if(height > count)
		{
			drop = 0;
			time = 0;
			pop = 2;
			dip = -1;
			while(height > count)
			{
				if(height == 4)
				{
					drop = drop + -10;
				}
				else if(height == 1)
				{
					drop = drop + -11;
				}
				else
				{
					drop = drop + -8;
				}
				time = time + 0.2;
				height--;
			}
			if(height == 0)
			{
				pop = 1;
			}
			else
			{
				drop = drop + -1;
			}
			scale MoveZ(drop, time, 0.1, 0);
			scale waittill("movedone");
			scale MoveZ(pop, pop * 0.1, 0, 0);
			scale waittill("movedone");
			scale MoveZ(dip, Abs(dip * 0.1), 0, 0);
			scale waittill("movedone");
		}
		wait(0.1);
	}
}

/*
	Name: minecart_trigger_splash_activate
	Namespace: zm_temple_minecart
	Checksum: 0xA95569BB
	Offset: 0x3EE0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function minecart_trigger_splash_activate()
{
	self TriggerEnable(1);
	wait(3);
	self TriggerEnable(0);
}

/*
	Name: minecart_trigger_splash_think
	Namespace: zm_temple_minecart
	Checksum: 0xB4AE8342
	Offset: 0x3F28
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function minecart_trigger_splash_think()
{
	while(1)
	{
		self waittill("trigger", player);
		if(isdefined(player) && isdefined(player.minecart_splash_time) && player.minecart_splash_time > GetTime())
		{
			playFX(level._effect["player_water_splash"], player.origin);
			player playsound("fly_bodyfall_large_water");
			player.minecart_splash_time = 0;
		}
	}
}

/*
	Name: delayed_player_response_to_minecart_ride
	Namespace: zm_temple_minecart
	Checksum: 0x454099B9
	Offset: 0x3FF0
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function delayed_player_response_to_minecart_ride(Array)
{
	if(Array.size == 0)
	{
		return;
	}
	wait(6);
	player = Array[randomIntRange(0, Array.size)];
	if(isdefined(player) && isPlayer(player))
	{
		player thread zm_audio::create_and_play_dialog("general", "mine_ride");
	}
}

/*
	Name: minecart_clean_up_corpses
	Namespace: zm_temple_minecart
	Checksum: 0x27915BF8
	Offset: 0x4090
	Size: 0xC5
	Parameters: 0
	Flags: None
*/
function minecart_clean_up_corpses()
{
	corpse_trig = GetEnt("minecart1_start_volume", "targetname");
	corpses = GetCorpseArray();
	if(isdefined(corpses))
	{
		for(i = 0; i < corpses.size; i++)
		{
			if(corpses[i] istouching(corpse_trig))
			{
				corpses[i] thread minecart_remove_corpses();
			}
		}
	}
}

/*
	Name: minecart_remove_corpses
	Namespace: zm_temple_minecart
	Checksum: 0x6AAA0453
	Offset: 0x4160
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function minecart_remove_corpses()
{
	playFX(level._effect["corpse_gib"], self.origin);
	self delete();
}

