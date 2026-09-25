#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;

#namespace namespace_6d813654;

/*
	Name: __init__sytem__
	Namespace: namespace_6d813654
	Checksum: 0x40BF0FE8
	Offset: 0x388
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_equip_hacker", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_6d813654
	Checksum: 0x7FD05CC3
	Offset: 0x3D0
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_equipment::register("equip_hacker", &"ZOMBIE_EQUIP_HACKER_PICKUP_HINT_STRING", &"ZOMBIE_EQUIP_HACKER_HOWTO", undefined, "hacker");
	level._hackable_objects = [];
	level._pooled_hackable_objects = [];
	callback::on_connect(&hacker_on_player_connect);
	callback::on_spawned(&function_fa12cef4);
	level thread hack_trigger_think();
	level thread hacker_trigger_pool_think();
	level thread hacker_round_reward();
	if(GetDvarInt("scr_debug_hacker") == 1)
	{
		level thread hacker_debug();
	}
	level.var_bbd4901d = GetWeapon("equip_hacker");
}

/*
	Name: __main__
	Namespace: namespace_6d813654
	Checksum: 0x2F76F0A5
	Offset: 0x508
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function __main__()
{
	zm_equipment::register_for_level("equip_hacker");
	zm_equipment::Include("equip_hacker");
}

/*
	Name: function_fa12cef4
	Namespace: namespace_6d813654
	Checksum: 0x71E35195
	Offset: 0x548
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_fa12cef4()
{
	self thread function_b743c597();
	self thread function_778301bd();
}

/*
	Name: hacker_round_reward
	Namespace: namespace_6d813654
	Checksum: 0xFBB38E7D
	Offset: 0x588
	Size: 0x1B5
	Parameters: 0
	Flags: None
*/
function hacker_round_reward()
{
	while(1)
	{
		level waittill("end_of_round");
		if(!isdefined(level._from_nml))
		{
			players = GetPlayers();
			for(i = 0; i < players.size; i++)
			{
				if(isdefined(players[i] zm_equipment::get_player_equipment()) && players[i] zm_equipment::get_player_equipment() == level.var_bbd4901d)
				{
					if(isdefined(players[i].equipment_got_in_round[level.var_bbd4901d]))
					{
						got_in_round = players[i].equipment_got_in_round[level.var_bbd4901d];
						rounds_kept = level.round_number - got_in_round;
						rounds_kept = rounds_kept - 1;
						if(rounds_kept > 0)
						{
							rounds_kept = min(rounds_kept, 5);
							score = rounds_kept * 500;
							players[i] zm_score::add_to_player_score(Int(score));
						}
					}
				}
			}
		}
		else
		{
			level._from_nml = undefined;
		}
	}
}

/*
	Name: hacker_debug
	Namespace: namespace_6d813654
	Checksum: 0x68F4A329
	Offset: 0x748
	Size: 0x18B
	Parameters: 0
	Flags: None
*/
function hacker_debug()
{
	while(1)
	{
		for(i = 0; i < level._hackable_objects.size; i++)
		{
			hackable = level._hackable_objects[i];
			if(isdefined(hackable.pooled) && hackable.pooled)
			{
				if(isdefined(hackable._trigger))
				{
					col = VectorScale((0, 1, 0), 255);
					if(isdefined(hackable.custom_debug_color))
					{
						col = hackable.custom_debug_color;
					}
					/#
						print3d(hackable.origin, "Dev Block strings are not supported", col, 1, 1);
					#/
				}
				else
				{
					print3d(hackable.origin, "Dev Block strings are not supported", VectorScale((0, 0, 1), 255), 1, 1);
				}
				/#
				#/
				continue;
			}
			/#
				print3d(hackable.origin, "Dev Block strings are not supported", VectorScale((1, 0, 0), 255), 1, 1);
			#/
		}
		wait(0.1);
	}
}

/*
	Name: hacker_trigger_pool_think
	Namespace: namespace_6d813654
	Checksum: 0x5C9CB870
	Offset: 0x8E0
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function hacker_trigger_pool_think()
{
	if(!isdefined(level._zombie_hacker_trigger_pool_size))
	{
		level._zombie_hacker_trigger_pool_size = 8;
	}
	pool_active = 0;
	level._hacker_pool = [];
	while(1)
	{
		if(pool_active)
		{
			if(!any_hackers_active())
			{
				destroy_pooled_items();
			}
			else
			{
				sweep_pooled_items();
				add_eligable_pooled_items();
			}
		}
		else if(any_hackers_active())
		{
			pool_active = 1;
		}
		wait(0.1);
	}
}

/*
	Name: destroy_pooled_items
	Namespace: namespace_6d813654
	Checksum: 0x8D88849F
	Offset: 0x9B8
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function destroy_pooled_items()
{
	pool_active = 0;
	for(i = 0; i < level._hacker_pool.size; i++)
	{
		level._hacker_pool[i]._trigger delete();
		level._hacker_pool[i]._trigger = undefined;
	}
	level._hacker_pool = [];
}

/*
	Name: sweep_pooled_items
	Namespace: namespace_6d813654
	Checksum: 0x17107939
	Offset: 0xA48
	Size: 0xE7
	Parameters: 0
	Flags: None
*/
function sweep_pooled_items()
{
	new_hacker_pool = [];
	for(i = 0; i < level._hacker_pool.size; i++)
	{
		if(level._hacker_pool[i] should_pooled_object_exist())
		{
			new_hacker_pool[new_hacker_pool.size] = level._hacker_pool[i];
			continue;
		}
		if(isdefined(level._hacker_pool[i]._trigger))
		{
			level._hacker_pool[i]._trigger delete();
		}
		level._hacker_pool[i]._trigger = undefined;
	}
	level._hacker_pool = new_hacker_pool;
}

/*
	Name: should_pooled_object_exist
	Namespace: namespace_6d813654
	Checksum: 0xCE47B176
	Offset: 0xB38
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function should_pooled_object_exist()
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i] zm_equipment::hacker_active())
		{
			if(isdefined(self.entity))
			{
				if(self.entity != players[i])
				{
					if(Distance2DSquared(players[i].origin, self.entity.origin) <= self.radius * self.radius)
					{
						return 1;
					}
				}
				continue;
			}
			if(Distance2DSquared(players[i].origin, self.origin) <= self.radius * self.radius)
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: add_eligable_pooled_items
	Namespace: namespace_6d813654
	Checksum: 0x50DE5E97
	Offset: 0xC70
	Size: 0x26F
	Parameters: 0
	Flags: None
*/
function add_eligable_pooled_items()
{
	candidates = [];
	for(i = 0; i < level._hackable_objects.size; i++)
	{
		hackable = level._hackable_objects[i];
		if(isdefined(hackable.pooled) && hackable.pooled && !isdefined(hackable._trigger))
		{
			if(!IsInArray(level._hacker_pool, hackable))
			{
				if(hackable should_pooled_object_exist())
				{
					candidates[candidates.size] = hackable;
				}
			}
		}
	}
	for(i = 0; i < candidates.size; i++)
	{
		candidate = candidates[i];
		height = 72;
		radius = 32;
		if(isdefined(candidate.radius))
		{
			radius = candidate.radius;
		}
		if(isdefined(candidate.height))
		{
			height = candidate.height;
		}
		trigger = spawn("trigger_radius_use", candidate.origin, 0, radius, height);
		trigger UseTriggerRequireLookAt();
		trigger TriggerIgnoreTeam();
		trigger setcursorhint("HINT_NOICON");
		trigger.radius = radius;
		trigger.height = height;
		trigger.BeingHacked = 0;
		candidate._trigger = trigger;
		level._hacker_pool[level._hacker_pool.size] = candidate;
	}
}

/*
	Name: get_hackable_trigger
	Namespace: namespace_6d813654
	Checksum: 0x5F856108
	Offset: 0xEE8
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function get_hackable_trigger()
{
	if(isdefined(self.door))
	{
		return self.door;
	}
	else if(isdefined(self.perk))
	{
		return self.perk;
	}
	else if(isdefined(self.window))
	{
		return self.window.unitrigger_stub.trigger;
	}
	else if(isdefined(self.classname) && GetSubStr(self.classname, 0, 7) == "trigger_")
	{
		return self;
	}
}

/*
	Name: any_hackers_active
	Namespace: namespace_6d813654
	Checksum: 0xFA42406A
	Offset: 0xF88
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function any_hackers_active()
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i] zm_equipment::hacker_active())
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: register_hackable
	Namespace: namespace_6d813654
	Checksum: 0xE9CDD9AC
	Offset: 0x1000
	Size: 0x1ED
	Parameters: 3
	Flags: None
*/
function register_hackable(name, callback_func, qualifier_func)
{
	structs = struct::get_array(name, "script_noteworthy");
	if(!isdefined(structs))
	{
		/#
			println("Dev Block strings are not supported" + name + "Dev Block strings are not supported");
		#/
		return;
	}
	for(i = 0; i < structs.size; i++)
	{
		if(!IsInArray(level._hackable_objects, structs[i]))
		{
			structs[i]._hack_callback_func = callback_func;
			structs[i]._hack_qualifier_func = qualifier_func;
			structs[i].pooled = level._hacker_pooled;
			if(isdefined(structs[i].targetname))
			{
				structs[i].hacker_target = GetEnt(structs[i].targetname, "targetname");
			}
			level._hackable_objects[level._hackable_objects.size] = structs[i];
			if(isdefined(level._hacker_pooled))
			{
				level._pooled_hackable_objects[level._pooled_hackable_objects.size] = structs[i];
			}
			structs[i] thread hackable_object_thread();
			util::wait_network_frame();
		}
	}
}

/*
	Name: register_hackable_struct
	Namespace: namespace_6d813654
	Checksum: 0x86A188ED
	Offset: 0x11F8
	Size: 0x113
	Parameters: 3
	Flags: None
*/
function register_hackable_struct(struct, callback_func, qualifier_func)
{
	if(!IsInArray(level._hackable_objects, struct))
	{
		struct._hack_callback_func = callback_func;
		struct._hack_qualifier_func = qualifier_func;
		struct.pooled = level._hacker_pooled;
		if(isdefined(struct.targetname))
		{
			struct.hacker_target = GetEnt(struct.targetname, "targetname");
		}
		level._hackable_objects[level._hackable_objects.size] = struct;
		if(isdefined(level._hacker_pooled))
		{
			level._pooled_hackable_objects[level._pooled_hackable_objects.size] = struct;
		}
		struct thread hackable_object_thread();
	}
}

/*
	Name: register_pooled_hackable_struct
	Namespace: namespace_6d813654
	Checksum: 0x774F82EF
	Offset: 0x1318
	Size: 0x4D
	Parameters: 3
	Flags: None
*/
function register_pooled_hackable_struct(struct, callback_func, qualifier_func)
{
	level._hacker_pooled = 1;
	register_hackable_struct(struct, callback_func, qualifier_func);
	level._hacker_pooled = undefined;
}

/*
	Name: register_pooled_hackable
	Namespace: namespace_6d813654
	Checksum: 0xD7ED9CC1
	Offset: 0x1370
	Size: 0x4D
	Parameters: 3
	Flags: None
*/
function register_pooled_hackable(name, callback_func, qualifier_func)
{
	level._hacker_pooled = 1;
	register_hackable(name, callback_func, qualifier_func);
	level._hacker_pooled = undefined;
}

/*
	Name: deregister_hackable_struct
	Namespace: namespace_6d813654
	Checksum: 0x691DD008
	Offset: 0x13C8
	Size: 0x193
	Parameters: 1
	Flags: None
*/
function deregister_hackable_struct(struct)
{
	if(IsInArray(level._hackable_objects, struct))
	{
		new_list = [];
		for(i = 0; i < level._hackable_objects.size; i++)
		{
			if(level._hackable_objects[i] != struct)
			{
				new_list[new_list.size] = level._hackable_objects[i];
				continue;
			}
			level._hackable_objects[i] notify("hackable_deregistered");
			if(isdefined(level._hackable_objects[i]._trigger))
			{
				level._hackable_objects[i]._trigger delete();
			}
			if(isdefined(level._hackable_objects[i].pooled) && level._hackable_objects[i].pooled)
			{
				ArrayRemoveValue(level._hacker_pool, level._hackable_objects[i]);
				ArrayRemoveValue(level._pooled_hackable_objects, level._hackable_objects[i]);
			}
		}
		level._hackable_objects = new_list;
	}
}

/*
	Name: deregister_hackable
	Namespace: namespace_6d813654
	Checksum: 0xF0337C44
	Offset: 0x1568
	Size: 0x16B
	Parameters: 1
	Flags: None
*/
function deregister_hackable(noteworthy)
{
	new_list = [];
	for(i = 0; i < level._hackable_objects.size; i++)
	{
		if(!isdefined(level._hackable_objects[i].script_noteworthy) || level._hackable_objects[i].script_noteworthy != noteworthy)
		{
			new_list[new_list.size] = level._hackable_objects[i];
		}
		else
		{
			level._hackable_objects[i] notify("hackable_deregistered");
			if(isdefined(level._hackable_objects[i]._trigger))
			{
				level._hackable_objects[i]._trigger delete();
			}
		}
		if(isdefined(level._hackable_objects[i].pooled) && level._hackable_objects[i].pooled)
		{
			ArrayRemoveValue(level._hacker_pool, level._hackable_objects[i]);
		}
	}
	level._hackable_objects = new_list;
}

/*
	Name: hack_trigger_think
	Namespace: namespace_6d813654
	Checksum: 0x4FEC3F9E
	Offset: 0x16E0
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function hack_trigger_think()
{
	while(1)
	{
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			for(j = 0; j < level._hackable_objects.size; j++)
			{
				hackable = level._hackable_objects[j];
				if(isdefined(hackable._trigger))
				{
					qualifier_passed = 1;
					if(isdefined(hackable._hack_qualifier_func))
					{
						qualifier_passed = hackable [[hackable._hack_qualifier_func]](player);
					}
					if(player zm_equipment::hacker_active() && qualifier_passed && !hackable._trigger.BeingHacked)
					{
						hackable._trigger SetInvisibleToPlayer(player, 0);
						continue;
					}
					hackable._trigger SetInvisibleToPlayer(player, 1);
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: is_facing
	Namespace: namespace_6d813654
	Checksum: 0xBAF1C376
	Offset: 0x1888
	Size: 0x175
	Parameters: 1
	Flags: None
*/
function is_facing(facee)
{
	orientation = self getPlayerAngles();
	forwardVec = AnglesToForward(orientation);
	forwardVec2D = (forwardVec[0], forwardVec[1], 0);
	unitForwardVec2D = VectorNormalize(forwardVec2D);
	toFaceeVec = facee.origin - self.origin;
	toFaceeVec2D = (toFaceeVec[0], toFaceeVec[1], 0);
	unitToFaceeVec2D = VectorNormalize(toFaceeVec2D);
	dotProduct = VectorDot(unitForwardVec2D, unitToFaceeVec2D);
	dot_limit = 0.8;
	if(isdefined(facee.dot_limit))
	{
		dot_limit = facee.dot_limit;
	}
	return dotProduct > dot_limit;
}

/*
	Name: can_hack
	Namespace: namespace_6d813654
	Checksum: 0x1FEA1F67
	Offset: 0x1A08
	Size: 0x2E7
	Parameters: 1
	Flags: None
*/
function can_hack(hackable)
{
	if(!isalive(self))
	{
		return 0;
	}
	if(self laststand::player_is_in_laststand())
	{
		return 0;
	}
	if(!self zm_equipment::hacker_active())
	{
		return 0;
	}
	if(!isdefined(hackable._trigger))
	{
		return 0;
	}
	if(isdefined(hackable.player))
	{
		if(hackable.player != self)
		{
			return 0;
		}
	}
	if(self throwbuttonpressed())
	{
		return 0;
	}
	if(self fragButtonPressed())
	{
		return 0;
	}
	if(isdefined(hackable._hack_qualifier_func))
	{
		if(!hackable [[hackable._hack_qualifier_func]](self))
		{
			return 0;
		}
	}
	if(!IsInArray(level._hackable_objects, hackable))
	{
		return 0;
	}
	radsquared = 1024;
	if(isdefined(hackable.radius))
	{
		radsquared = hackable.radius * hackable.radius;
	}
	origin = hackable.origin;
	if(isdefined(hackable.entity))
	{
		origin = hackable.entity.origin;
	}
	if(Distance2DSquared(self.origin, origin) > radsquared)
	{
		return 0;
	}
	if(!isdefined(hackable.no_touch_check) && !self istouching(hackable._trigger))
	{
		return 0;
	}
	if(!self is_facing(hackable))
	{
		return 0;
	}
	if(!isdefined(hackable.no_sight_check) && !SightTracePassed(self.origin + VectorScale((0, 0, 1), 50), origin, 0, undefined))
	{
		return 0;
	}
	if(!isdefined(hackable.no_bullet_trace) && !BulletTracePassed(self.origin + VectorScale((0, 0, 1), 50), origin, 0, undefined))
	{
		return 0;
	}
	return 1;
}

/*
	Name: is_hacking
	Namespace: namespace_6d813654
	Checksum: 0x6FC165D5
	Offset: 0x1CF8
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function is_hacking(hackable)
{
	return can_hack(hackable) && self useButtonPressed();
}

/*
	Name: set_hack_hint_string
	Namespace: namespace_6d813654
	Checksum: 0xD9CAD803
	Offset: 0x1D40
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function set_hack_hint_string()
{
	if(isdefined(self._trigger))
	{
		if(isdefined(self.custom_string))
		{
			self._trigger setHintString(self.custom_string);
		}
		else if(!isdefined(self.script_int) || self.script_int <= 0)
		{
			self._trigger setHintString(&"ZOMBIE_HACK_NO_COST");
		}
		else
		{
			self._trigger setHintString(&"ZOMBIE_HACK", self.script_int);
		}
	}
}

/*
	Name: tidy_on_deregister
	Namespace: namespace_6d813654
	Checksum: 0xAFAB32AC
	Offset: 0x1DF8
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function tidy_on_deregister(hackable)
{
	self endon("clean_up_tidy_up");
	hackable waittill("hackable_deregistered");
	if(isdefined(self.hackerProgressBar))
	{
		self.hackerProgressBar hud::destroyElem();
	}
	if(isdefined(self.hackerTextHud))
	{
		self.hackerTextHud destroy();
	}
}

/*
	Name: hacker_do_hack
	Namespace: namespace_6d813654
	Checksum: 0x1879C239
	Offset: 0x1E78
	Size: 0x419
	Parameters: 1
	Flags: None
*/
function hacker_do_hack(hackable)
{
	timer = 0;
	hacked = 0;
	hackable._trigger.BeingHacked = 1;
	if(!isdefined(self.hackerProgressBar))
	{
		self.hackerProgressBar = self hud::createPrimaryProgressBar();
	}
	if(!isdefined(self.hackerTextHud))
	{
		self.hackerTextHud = newClientHudElem(self);
	}
	hack_duration = hackable.script_float;
	if(self hasPerk("specialty_fastreload"))
	{
		hack_duration = hack_duration * 0.66;
	}
	hack_duration = max(1.5, hack_duration);
	self thread tidy_on_deregister(hackable);
	self.hackerProgressBar hud::updateBar(0.01, 1 / hack_duration);
	self.hackerTextHud.alignX = "center";
	self.hackerTextHud.alignY = "middle";
	self.hackerTextHud.horzAlign = "center";
	self.hackerTextHud.vertAlign = "bottom";
	self.hackerTextHud.y = -140;
	if(IsSplitscreen())
	{
		self.hackerTextHud.y = -134;
	}
	self.hackerTextHud.foreground = 1;
	self.hackerTextHud.font = "default";
	self.hackerTextHud.fontscale = 1.8;
	self.hackerTextHud.alpha = 1;
	self.hackerTextHud.color = (1, 1, 1);
	self.hackerTextHud setText(&"ZOMBIE_HACKING");
	self PlayLoopSound("zmb_progress_bar", 0.5);
	while(self is_hacking(hackable))
	{
		wait(0.05);
		timer = timer + 0.05;
		if(self laststand::player_is_in_laststand())
		{
			break;
		}
		if(timer >= hack_duration)
		{
			hacked = 1;
			break;
		}
	}
	self StopLoopSound(0.5);
	if(hacked)
	{
		self playsound("vox_mcomp_hack_success");
	}
	else
	{
		self playsound("vox_mcomp_hack_fail");
	}
	if(isdefined(self.hackerProgressBar))
	{
		self.hackerProgressBar hud::destroyElem();
	}
	if(isdefined(self.hackerTextHud))
	{
		self.hackerTextHud destroy();
	}
	hackable set_hack_hint_string();
	if(isdefined(hackable._trigger))
	{
		hackable._trigger.BeingHacked = 0;
	}
	self notify("clean_up_tidy_up");
	return hacked;
}

/*
	Name: lowreadywatcher
	Namespace: namespace_6d813654
	Checksum: 0x83E1D548
	Offset: 0x22A0
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function lowreadywatcher(player)
{
	player endon("disconnected");
	self endon("kill_lowreadywatcher");
	self waittill("hackable_deregistered");
	player SetLowReady(0);
}

/*
	Name: hackable_object_thread
	Namespace: namespace_6d813654
	Checksum: 0x2428E82A
	Offset: 0x22F8
	Size: 0x489
	Parameters: 0
	Flags: None
*/
function hackable_object_thread()
{
	self endon("hackable_deregistered");
	height = 72;
	radius = 64;
	if(isdefined(self.radius))
	{
		radius = self.radius;
	}
	if(isdefined(self.height))
	{
		height = self.height;
	}
	if(!isdefined(self.pooled))
	{
		trigger = spawn("trigger_radius_use", self.origin, 0, radius, height);
		trigger UseTriggerRequireLookAt();
		trigger setcursorhint("HINT_NOICON");
		trigger.radius = radius;
		trigger.height = height;
		trigger.BeingHacked = 0;
		self._trigger = trigger;
	}
	cost = 0;
	if(isdefined(self.script_int))
	{
		cost = self.script_int;
	}
	duration = 1;
	if(isdefined(self.script_float))
	{
		duration = self.script_float;
	}
	while(1)
	{
		wait(0.1);
		if(!isdefined(self._trigger))
		{
			continue;
		}
		players = GetPlayers();
		if(isdefined(self._trigger))
		{
			if(isdefined(self.entity))
			{
				self.origin = self.entity.origin;
				self._trigger.origin = self.entity.origin;
				if(isdefined(self.trigger_offset))
				{
					self._trigger.origin = self._trigger.origin + self.trigger_offset;
				}
			}
		}
		for(i = 0; i < players.size; i++)
		{
			if(players[i] can_hack(self))
			{
				self set_hack_hint_string();
				break;
			}
		}
		for(i = 0; i < players.size; i++)
		{
			hacker = players[i];
			if(!hacker is_hacking(self))
			{
				continue;
			}
			if(hacker.score >= cost || cost <= 0)
			{
				hacker SetLowReady(1);
				self thread lowreadywatcher(hacker);
				hack_success = hacker hacker_do_hack(self);
				self notify("kill_lowreadywatcher");
				if(isdefined(hacker))
				{
					hacker SetLowReady(0);
				}
				if(isdefined(hacker) && hack_success)
				{
					if(cost)
					{
						if(cost > 0)
						{
							hacker zm_score::minus_to_player_score(cost);
						}
						else
						{
							hacker zm_score::add_to_player_score(cost * -1, 1, "equip_hacker");
						}
					}
					hacker notify("successful_hack");
					if(isdefined(self._hack_callback_func))
					{
						self thread [[self._hack_callback_func]](hacker);
					}
				}
				continue;
			}
			hacker zm_utility::play_sound_on_ent("no_purchase");
			hacker zm_audio::create_and_play_dialog("general", "no_money", 1);
		}
	}
}

/*
	Name: hacker_on_player_connect
	Namespace: namespace_6d813654
	Checksum: 0x1DB0A2B4
	Offset: 0x2790
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function hacker_on_player_connect()
{
	struct = spawnstruct();
	struct.origin = self.origin;
	struct.radius = 48;
	struct.height = 64;
	struct.script_float = 10;
	struct.script_int = 500;
	struct.entity = self;
	struct.trigger_offset = VectorScale((0, 0, 1), 48);
	register_pooled_hackable_struct(struct, &player_hack, &player_qualifier);
	struct thread player_hack_disconnect_watcher(self);
}

/*
	Name: player_hack_disconnect_watcher
	Namespace: namespace_6d813654
	Checksum: 0x559C4D94
	Offset: 0x2898
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function player_hack_disconnect_watcher(player)
{
	player waittill("disconnect");
	deregister_hackable_struct(self);
}

/*
	Name: function_b743c597
	Namespace: namespace_6d813654
	Checksum: 0xF7403287
	Offset: 0x28D0
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function function_b743c597()
{
	self notify("hash_36caa6f");
	self endon("hash_36caa6f");
	self endon("disconnect");
	while(1)
	{
		self waittill("player_given", equipment);
		if(equipment == level.var_bbd4901d)
		{
			self clientfield::set_player_uimodel("hudItems.showDpadDown_HackTool", 1);
		}
	}
}

/*
	Name: function_778301bd
	Namespace: namespace_6d813654
	Checksum: 0x1DDE1074
	Offset: 0x2958
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function function_778301bd()
{
	self notify("hash_b90a8375");
	self endon("hash_b90a8375");
	self endon("disconnect");
	while(1)
	{
		self waittill("hash_e15d5390");
		self clientfield::set_player_uimodel("hudItems.showDpadDown_HackTool", 0);
	}
}

/*
	Name: player_hack
	Namespace: namespace_6d813654
	Checksum: 0xACFB6CC
	Offset: 0x29C0
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function player_hack(hacker)
{
	if(isdefined(self.entity))
	{
		self.entity zm_score::player_add_points("hacker_transfer", 500);
	}
	if(isdefined(hacker))
	{
		hacker thread zm_audio::create_and_play_dialog("general", "hack_plr");
	}
}

/*
	Name: player_qualifier
	Namespace: namespace_6d813654
	Checksum: 0xAC40880D
	Offset: 0x2A38
	Size: 0xA7
	Parameters: 1
	Flags: None
*/
function player_qualifier(player)
{
	if(player == self.entity)
	{
		return 0;
	}
	if(self.entity laststand::player_is_in_laststand())
	{
		return 0;
	}
	if(player laststand::player_is_in_laststand())
	{
		return 0;
	}
	if(isdefined(self.entity.sessionstate == "spectator") && self.entity.sessionstate == "spectator")
	{
		return 0;
	}
	return 1;
}

/*
	Name: hide_hint_when_hackers_active
	Namespace: namespace_6d813654
	Checksum: 0xD7AF7019
	Offset: 0x2AE8
	Size: 0x19B
	Parameters: 2
	Flags: None
*/
function hide_hint_when_hackers_active(custom_logic_func, custom_logic_func_param)
{
	invis_to_any = 0;
	while(1)
	{
		if(isdefined(custom_logic_func))
		{
			self [[custom_logic_func]](custom_logic_func_param);
		}
		if(any_hackers_active())
		{
			players = GetPlayers();
			for(i = 0; i < players.size; i++)
			{
				if(players[i] zm_equipment::hacker_active())
				{
					self SetInvisibleToPlayer(players[i], 1);
					invis_to_any = 1;
					continue;
				}
				self SetInvisibleToPlayer(players[i], 0);
			}
			break;
		}
		if(invis_to_any)
		{
			invis_to_any = 0;
			players = GetPlayers();
			for(i = 0; i < players.size; i++)
			{
				self SetInvisibleToPlayer(players[i], 0);
			}
		}
		wait(0.1);
	}
}

/*
	Name: hacker_debug_print
	Namespace: namespace_6d813654
	Checksum: 0x2B7D5403
	Offset: 0x2C90
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function hacker_debug_print(msg, color)
{
	/#
		if(!GetDvarInt("Dev Block strings are not supported"))
		{
			return;
		}
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		print3d(self.origin + VectorScale((0, 0, 1), 60), msg, color, 1, 1, 40);
	#/
}

