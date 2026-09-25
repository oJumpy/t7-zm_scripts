#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\math_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicleriders_shared;

#namespace vehicle;

/*
	Name: __init__sytem__
	Namespace: vehicle
	Checksum: 0x806484A3
	Offset: 0x6B8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("vehicle_shared", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: vehicle
	Checksum: 0xFB287F0
	Offset: 0x6F8
	Size: 0xD9B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._customVehicleCBFunc = &spawned_callback;
	clientfield::register("vehicle", "toggle_lockon", 1, 1, "int", &field_toggle_lockon_handler, 0, 0);
	clientfield::register("vehicle", "toggle_sounds", 1, 1, "int", &field_toggle_sounds, 0, 0);
	clientfield::register("vehicle", "use_engine_damage_sounds", 1, 2, "int", &field_use_engine_damage_sounds, 0, 0);
	clientfield::register("vehicle", "toggle_treadfx", 1, 1, "int", &field_toggle_treadfx, 0, 0);
	clientfield::register("vehicle", "toggle_exhaustfx", 1, 1, "int", &field_toggle_exhaustfx_handler, 0, 0);
	clientfield::register("vehicle", "toggle_lights", 1, 2, "int", &field_toggle_lights_handler, 0, 0);
	clientfield::register("vehicle", "toggle_lights_group1", 1, 1, "int", &field_toggle_lights_group_handler1, 0, 0);
	clientfield::register("vehicle", "toggle_lights_group2", 1, 1, "int", &field_toggle_lights_group_handler2, 0, 0);
	clientfield::register("vehicle", "toggle_lights_group3", 1, 1, "int", &field_toggle_lights_group_handler3, 0, 0);
	clientfield::register("vehicle", "toggle_lights_group4", 1, 1, "int", &field_toggle_lights_group_handler4, 0, 0);
	clientfield::register("vehicle", "toggle_ambient_anim_group1", 1, 1, "int", &field_toggle_ambient_anim_handler1, 0, 0);
	clientfield::register("vehicle", "toggle_ambient_anim_group2", 1, 1, "int", &field_toggle_ambient_anim_handler2, 0, 0);
	clientfield::register("vehicle", "toggle_ambient_anim_group3", 1, 1, "int", &field_toggle_ambient_anim_handler3, 0, 0);
	clientfield::register("vehicle", "toggle_emp_fx", 1, 1, "int", &field_toggle_emp, 0, 0);
	clientfield::register("vehicle", "toggle_burn_fx", 1, 1, "int", &field_toggle_burn, 0, 0);
	clientfield::register("vehicle", "deathfx", 1, 2, "int", &field_do_deathfx, 0, 0);
	clientfield::register("vehicle", "alert_level", 1, 2, "int", &field_update_alert_level, 0, 0);
	clientfield::register("vehicle", "set_lighting_ent", 1, 1, "int", &util::field_set_lighting_ent, 0, 0);
	clientfield::register("vehicle", "use_lighting_ent", 1, 1, "int", &util::field_use_lighting_ent, 0, 0);
	clientfield::register("vehicle", "damage_level", 1, 3, "int", &field_update_damage_state, 0, 0);
	clientfield::register("vehicle", "spawn_death_dynents", 1, 2, "int", &field_death_spawn_dynents, 0, 0);
	clientfield::register("vehicle", "spawn_gib_dynents", 1, 1, "int", &field_gib_spawn_dynents, 0, 0);
	clientfield::register("helicopter", "toggle_lockon", 1, 1, "int", &field_toggle_lockon_handler, 0, 0);
	clientfield::register("helicopter", "toggle_sounds", 1, 1, "int", &field_toggle_sounds, 0, 0);
	clientfield::register("helicopter", "use_engine_damage_sounds", 1, 2, "int", &field_use_engine_damage_sounds, 0, 0);
	clientfield::register("helicopter", "toggle_treadfx", 1, 1, "int", &field_toggle_treadfx, 0, 0);
	clientfield::register("helicopter", "toggle_exhaustfx", 1, 1, "int", &field_toggle_exhaustfx_handler, 0, 0);
	clientfield::register("helicopter", "toggle_lights", 1, 2, "int", &field_toggle_lights_handler, 0, 0);
	clientfield::register("helicopter", "toggle_lights_group1", 1, 1, "int", &field_toggle_lights_group_handler1, 0, 0);
	clientfield::register("helicopter", "toggle_lights_group2", 1, 1, "int", &field_toggle_lights_group_handler2, 0, 0);
	clientfield::register("helicopter", "toggle_lights_group3", 1, 1, "int", &field_toggle_lights_group_handler3, 0, 0);
	clientfield::register("helicopter", "toggle_lights_group4", 1, 1, "int", &field_toggle_lights_group_handler4, 0, 0);
	clientfield::register("helicopter", "toggle_ambient_anim_group1", 1, 1, "int", &field_toggle_ambient_anim_handler1, 0, 0);
	clientfield::register("helicopter", "toggle_ambient_anim_group2", 1, 1, "int", &field_toggle_ambient_anim_handler2, 0, 0);
	clientfield::register("helicopter", "toggle_ambient_anim_group3", 1, 1, "int", &field_toggle_ambient_anim_handler3, 0, 0);
	clientfield::register("helicopter", "toggle_emp_fx", 1, 1, "int", &field_toggle_emp, 0, 0);
	clientfield::register("helicopter", "toggle_burn_fx", 1, 1, "int", &field_toggle_burn, 0, 0);
	clientfield::register("helicopter", "deathfx", 1, 1, "int", &field_do_deathfx, 0, 0);
	clientfield::register("helicopter", "alert_level", 1, 2, "int", &field_update_alert_level, 0, 0);
	clientfield::register("helicopter", "set_lighting_ent", 1, 1, "int", &util::field_set_lighting_ent, 0, 0);
	clientfield::register("helicopter", "use_lighting_ent", 1, 1, "int", &util::field_use_lighting_ent, 0, 0);
	clientfield::register("helicopter", "damage_level", 1, 3, "int", &field_update_damage_state, 0, 0);
	clientfield::register("helicopter", "spawn_death_dynents", 1, 2, "int", &field_death_spawn_dynents, 0, 0);
	clientfield::register("helicopter", "spawn_gib_dynents", 1, 1, "int", &field_gib_spawn_dynents, 0, 0);
	clientfield::register("plane", "toggle_treadfx", 1, 1, "int", &field_toggle_treadfx, 0, 0);
	clientfield::register("toplayer", "toggle_dnidamagefx", 1, 1, "int", &field_toggle_dnidamagefx, 0, 0);
	clientfield::register("toplayer", "toggle_flir_postfx", 1, 2, "int", &toggle_flir_postfxbundle, 0, 0);
	clientfield::register("toplayer", "static_postfx", 1, 1, "int", &set_static_postfxbundle, 0, 0);
}

/*
	Name: add_vehicletype_callback
	Namespace: vehicle
	Checksum: 0x205773E8
	Offset: 0x14A0
	Size: 0x3D
	Parameters: 2
	Flags: None
*/
function add_vehicletype_callback(vehicleType, callback)
{
	if(!isdefined(level.vehicleTypeCallbackArray))
	{
		level.vehicleTypeCallbackArray = [];
	}
	level.vehicleTypeCallbackArray[vehicleType] = callback;
}

/*
	Name: spawned_callback
	Namespace: vehicle
	Checksum: 0xA7093B3
	Offset: 0x14E8
	Size: 0xD5
	Parameters: 1
	Flags: None
*/
function spawned_callback(localClientNum)
{
	if(isdefined(self.vehicleridersbundle))
	{
		set_vehicleriders_bundle(self.vehicleridersbundle);
	}
	vehicleType = self.vehicleType;
	if(isdefined(level.vehicleTypeCallbackArray))
	{
		if(isdefined(vehicleType) && isdefined(level.vehicleTypeCallbackArray[vehicleType]))
		{
			self thread [[level.vehicleTypeCallbackArray[vehicleType]]](localClientNum);
		}
		else if(isdefined(self.scriptvehicletype) && isdefined(level.vehicleTypeCallbackArray[self.scriptvehicletype]))
		{
			self thread [[level.vehicleTypeCallbackArray[self.scriptvehicletype]]](localClientNum);
		}
	}
}

/*
	Name: rumble
	Namespace: vehicle
	Checksum: 0x63F580CD
	Offset: 0x15C8
	Size: 0x2A7
	Parameters: 1
	Flags: None
*/
function rumble(localClientNum)
{
	self endon("entityshutdown");
	if(!isdefined(self.rumbletype) || self.rumbleradius == 0)
	{
		return;
	}
	if(!isdefined(self.rumbleon))
	{
		self.rumbleon = 1;
	}
	height = self.rumbleradius * 2;
	zoffset = -1 * self.rumbleradius;
	self.player_touching = 0;
	radius_squared = self.rumbleradius * self.rumbleradius;
	wait(2);
	while(1)
	{
		if(!isdefined(level.localPlayers[localClientNum]) || DistanceSquared(self.origin, level.localPlayers[localClientNum].origin) > radius_squared || self getspeed() == 0)
		{
			wait(0.2);
			continue;
		}
		if(isdefined(self.rumbleon) && !self.rumbleon)
		{
			wait(0.2);
			continue;
		}
		self PlayRumbleLoopOnEntity(localClientNum, self.rumbletype);
		while(isdefined(level.localPlayers[localClientNum]) && DistanceSquared(self.origin, level.localPlayers[localClientNum].origin) < radius_squared && self getspeed() > 0)
		{
			self Earthquake(self.rumblescale, self.rumbleduration, self.origin, self.rumbleradius);
			time_to_wait = self.rumblebasetime + RandomFloat(self.rumbleadditionaltime);
			if(time_to_wait <= 0)
			{
				time_to_wait = 0.05;
			}
			wait(time_to_wait);
		}
		if(isdefined(level.localPlayers[localClientNum]))
		{
			self StopRumble(localClientNum, self.rumbletype);
		}
		wait(0.05);
	}
}

/*
	Name: kill_treads_forever
	Namespace: vehicle
	Checksum: 0x9FC38D0C
	Offset: 0x1878
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function kill_treads_forever()
{
	self notify("kill_treads_forever");
}

/*
	Name: play_exhaust
	Namespace: vehicle
	Checksum: 0x71F807DE
	Offset: 0x1898
	Size: 0x1B3
	Parameters: 1
	Flags: None
*/
function play_exhaust(localClientNum)
{
	if(isdefined(self.csf_no_exhaust) && self.csf_no_exhaust)
	{
		return;
	}
	if(!isdefined(self.exhaust_fx) && isdefined(self.exhaustfxname))
	{
		if(!isdefined(level._effect))
		{
			level._effect = [];
		}
		if(!isdefined(level._effect[self.exhaustfxname]))
		{
			level._effect[self.exhaustfxname] = self.exhaustfxname;
		}
		self.exhaust_fx = level._effect[self.exhaustfxname];
	}
	if(isdefined(self.exhaust_fx) && isdefined(self.exhaustFxTag1))
	{
		if(isalive(self))
		{
			/#
				Assert(isdefined(self.exhaustFxTag1), self.vehicleType + "Dev Block strings are not supported");
			#/
			self endon("entityshutdown");
			self wait_for_DObj(localClientNum);
			self.exhaust_id_left = PlayFXOnTag(localClientNum, self.exhaust_fx, self, self.exhaustFxTag1);
			if(!isdefined(self.exhaust_id_right) && isdefined(self.exhaustFxTag2))
			{
				self.exhaust_id_right = PlayFXOnTag(localClientNum, self.exhaust_fx, self, self.exhaustFxTag2);
			}
			self thread kill_exhaust_watcher(localClientNum);
		}
	}
}

/*
	Name: kill_exhaust_watcher
	Namespace: vehicle
	Checksum: 0xB0F956F7
	Offset: 0x1A58
	Size: 0x85
	Parameters: 1
	Flags: None
*/
function kill_exhaust_watcher(localClientNum)
{
	self waittill("stop_exhaust_fx");
	if(isdefined(self.exhaust_id_left))
	{
		stopfx(localClientNum, self.exhaust_id_left);
		self.exhaust_id_left = undefined;
	}
	if(isdefined(self.exhaust_id_right))
	{
		stopfx(localClientNum, self.exhaust_id_right);
		self.exhaust_id_right = undefined;
	}
}

/*
	Name: stop_exhaust
	Namespace: vehicle
	Checksum: 0xC8650C06
	Offset: 0x1AE8
	Size: 0x19
	Parameters: 1
	Flags: None
*/
function stop_exhaust(localClientNum)
{
	self notify("stop_exhaust_fx");
}

/*
	Name: aircraft_dustkick
	Namespace: vehicle
	Checksum: 0x46D6B1E2
	Offset: 0x1B10
	Size: 0x2A5
	Parameters: 0
	Flags: None
*/
function aircraft_dustkick()
{
	waittillframeend;
	self endon("kill_treads_forever");
	self endon("entityshutdown");
	if(!isdefined(self))
	{
		return;
	}
	if(isdefined(self.csf_no_tread) && self.csf_no_tread)
	{
		return;
	}
	if(self.vehicleClass == "plane_mig17" || self.vehicleClass == "plane_mig21")
	{
		numFramesPerTrace = 1;
	}
	else
	{
		numFramesPerTrace = 3;
	}
	doTraceThisFrame = numFramesPerTrace;
	repeatRate = 1;
	trace = undefined;
	d = undefined;
	trace_ent = self;
	while(isdefined(self))
	{
		if(repeatRate <= 0)
		{
			repeatRate = 1;
		}
		if(self.vehicleClass == "plane_mig17" || self.vehicleClass == "plane_mig21")
		{
			repeatRate = 0.02;
		}
		WaitRealTime(repeatRate);
		if(!isdefined(self))
		{
			return;
		}
		doTraceThisFrame--;
		if(doTraceThisFrame <= 0)
		{
			doTraceThisFrame = numFramesPerTrace;
			trace = tracepoint(trace_ent.origin, trace_ent.origin - VectorScale((0, 0, 1), 100000));
			d = Distance(trace_ent.origin, trace["position"]);
			if(d > 350)
			{
				repeatRate = d - 350 / 1200 - 350 * 0.2 - 0.1 + 0.1;
			}
			else
			{
				repeatRate = 0.1;
			}
		}
		if(isdefined(trace))
		{
			if(d > 1200)
			{
				repeatRate = 1;
				continue;
			}
			if(!isdefined(trace["surfacetype"]))
			{
				trace["surfacetype"] = "dirt";
			}
		}
	}
}

/*
	Name: weapon_fired
	Namespace: vehicle
	Checksum: 0xA1C60700
	Offset: 0x1DC0
	Size: 0x1B9
	Parameters: 0
	Flags: None
*/
function weapon_fired()
{
	self endon("entityshutdown");
	while(1)
	{
		self waittill("weapon_fired");
		players = level.localPlayers;
		for(i = 0; i < players.size; i++)
		{
			player_distance = DistanceSquared(self.origin, players[i].origin);
			if(player_distance < 250000)
			{
				if(isdefined(self.shootrumble) && self.shootrumble != "")
				{
					PlayRumbleOnPosition(i, self.shootrumble, self.origin + VectorScale((0, 0, 1), 32));
				}
			}
			if(player_distance < 160000)
			{
				fraction = player_distance / 160000;
				time = 4 - 3 * fraction;
				if(isdefined(players[i]))
				{
					if(isdefined(self.shootshock) && self.shootshock != "")
					{
						players[i] shellshock(i, self.shootshock, time);
					}
				}
			}
		}
	}
}

/*
	Name: wait_for_DObj
	Namespace: vehicle
	Checksum: 0x81186169
	Offset: 0x1F88
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function wait_for_DObj(localClientNum)
{
	count = 30;
	while(!self hasdobj(localClientNum))
	{
		if(count < 0)
		{
			/#
				IPrintLnBold("Dev Block strings are not supported");
			#/
			return;
		}
		wait(0.016);
		count = count - 1;
	}
}

/*
	Name: lights_on
	Namespace: vehicle
	Checksum: 0x235A4EFF
	Offset: 0x2010
	Size: 0x135
	Parameters: 2
	Flags: None
*/
function lights_on(localClientNum, team)
{
	self endon("entityshutdown");
	lights_off(localClientNum);
	wait_for_DObj(localClientNum);
	if(isdefined(self.lightfxnamearray))
	{
		if(!isdefined(self.light_fx_handles))
		{
			self.light_fx_handles = [];
		}
		for(i = 0; i < self.lightfxnamearray.size; i++)
		{
			self.light_fx_handles[i] = PlayFXOnTag(localClientNum, self.lightfxnamearray[i], self, self.lightfxtagarray[i]);
			SetFXIgnorePause(localClientNum, self.light_fx_handles[i], 1);
			if(isdefined(team))
			{
				SetFxTeam(localClientNum, self.light_fx_handles[i], team);
			}
		}
	}
}

/*
	Name: addAnimToList
	Namespace: vehicle
	Checksum: 0x9E42FC82
	Offset: 0x2150
	Size: 0x111
	Parameters: 6
	Flags: None
*/
function addAnimToList(animItem, listOn, listOff, playWhenOff, id, maxID)
{
	if(isdefined(animItem) && id <= maxID)
	{
		if(playWhenOff === 1)
		{
			if(!isdefined(listOff))
			{
				listOff = [];
			}
			else if(!IsArray(listOff))
			{
				listOff = Array(listOff);
			}
			listOff[listOff.size] = animItem;
		}
		else if(!isdefined(listOn))
		{
			listOn = [];
		}
		else if(!IsArray(listOn))
		{
			listOn = Array(listOn);
		}
		listOn[listOn.size] = animItem;
	}
}

/*
	Name: ambient_anim_toggle
	Namespace: vehicle
	Checksum: 0x34924C8C
	Offset: 0x2270
	Size: 0x5ED
	Parameters: 3
	Flags: None
*/
function ambient_anim_toggle(localClientNum, groupID, isOn)
{
	self endon("entityshutdown");
	if(!isdefined(self.scriptbundlesettings))
	{
		return;
	}
	settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	if(!isdefined(settings))
	{
		return;
	}
	wait_for_DObj(localClientNum);
	listOn = [];
	listOff = [];
	switch(groupID)
	{
		case 1:
		{
			addAnimToList(settings.ambient_group1_anim1, listOn, listOff, settings.ambient_group1_off1, 1, settings.ambient_group1_numslots);
			addAnimToList(settings.ambient_group1_anim2, listOn, listOff, settings.ambient_group1_off2, 2, settings.ambient_group1_numslots);
			addAnimToList(settings.ambient_group1_anim3, listOn, listOff, settings.ambient_group1_off3, 3, settings.ambient_group1_numslots);
			addAnimToList(settings.ambient_group1_anim4, listOn, listOff, settings.ambient_group1_off4, 4, settings.ambient_group1_numslots);
			break;
		}
		case 2:
		{
			addAnimToList(settings.ambient_group2_anim1, listOn, listOff, settings.ambient_group2_off1, 1, settings.ambient_group2_numslots);
			addAnimToList(settings.ambient_group2_anim2, listOn, listOff, settings.ambient_group2_off2, 2, settings.ambient_group2_numslots);
			addAnimToList(settings.ambient_group2_anim3, listOn, listOff, settings.ambient_group2_off3, 3, settings.ambient_group2_numslots);
			addAnimToList(settings.ambient_group2_anim4, listOn, listOff, settings.ambient_group2_off4, 4, settings.ambient_group2_numslots);
			break;
		}
		case 3:
		{
			addAnimToList(settings.ambient_group3_anim1, listOn, listOff, settings.ambient_group3_off1, 1, settings.ambient_group3_numslots);
			addAnimToList(settings.ambient_group3_anim2, listOn, listOff, settings.ambient_group3_off2, 2, settings.ambient_group3_numslots);
			addAnimToList(settings.ambient_group3_anim3, listOn, listOff, settings.ambient_group3_off3, 3, settings.ambient_group3_numslots);
			addAnimToList(settings.ambient_group3_anim4, listOn, listOff, settings.ambient_group3_off4, 4, settings.ambient_group3_numslots);
			break;
		}
		case 4:
		{
			addAnimToList(settings.ambient_group4_anim1, listOn, listOff, settings.ambient_group4_off1, 1, settings.ambient_group4_numslots);
			addAnimToList(settings.ambient_group4_anim2, listOn, listOff, settings.ambient_group4_off2, 2, settings.ambient_group4_numslots);
			addAnimToList(settings.ambient_group4_anim3, listOn, listOff, settings.ambient_group4_off3, 3, settings.ambient_group4_numslots);
			addAnimToList(settings.ambient_group4_anim4, listOn, listOff, settings.ambient_group4_off4, 4, settings.ambient_group4_numslots);
			break;
		}
	}
	if(isOn)
	{
		weightOn = 1;
		weightOff = 0;
	}
	else
	{
		weightOn = 0;
		weightOff = 1;
	}
	for(i = 0; i < listOn.size; i++)
	{
		self SetAnim(listOn[i], weightOn, 0.2, 1);
	}
	for(i = 0; i < listOff.size; i++)
	{
		self SetAnim(listOff[i], weightOff, 0.2, 1);
	}
}

/*
	Name: field_toggle_ambient_anim_handler1
	Namespace: vehicle
	Checksum: 0x3C115FE6
	Offset: 0x2868
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function field_toggle_ambient_anim_handler1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self ambient_anim_toggle(localClientNum, 1, newVal);
}

/*
	Name: field_toggle_ambient_anim_handler2
	Namespace: vehicle
	Checksum: 0x9795C8EA
	Offset: 0x28D0
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function field_toggle_ambient_anim_handler2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self ambient_anim_toggle(localClientNum, 2, newVal);
}

/*
	Name: field_toggle_ambient_anim_handler3
	Namespace: vehicle
	Checksum: 0x77F3C9F2
	Offset: 0x2938
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function field_toggle_ambient_anim_handler3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self ambient_anim_toggle(localClientNum, 3, newVal);
}

/*
	Name: field_toggle_ambient_anim_handler4
	Namespace: vehicle
	Checksum: 0x13202D04
	Offset: 0x29A0
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function field_toggle_ambient_anim_handler4(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self ambient_anim_toggle(localClientNum, 4, newVal);
}

/*
	Name: lights_group_toggle
	Namespace: vehicle
	Checksum: 0xBF9AA550
	Offset: 0x2A08
	Size: 0x7A1
	Parameters: 3
	Flags: None
*/
function lights_group_toggle(localClientNum, id, isOn)
{
	self endon("entityshutdown");
	if(!isdefined(self.scriptbundlesettings))
	{
		return;
	}
	settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	if(!isdefined(settings) || !isdefined(settings.lightgroups_numGroups))
	{
		return;
	}
	wait_for_DObj(localClientNum);
	groupID = id - 1;
	if(isdefined(self.lightfxgroups) && groupID < self.lightfxgroups.size)
	{
		foreach(fx_handle in self.lightfxgroups[groupID])
		{
			stopfx(localClientNum, fx_handle);
		}
	}
	else if(!isOn)
	{
		return;
	}
	if(!isdefined(self.lightfxgroups))
	{
		self.lightfxgroups = [];
		for(i = 0; i < settings.lightgroups_numGroups; i++)
		{
			newfxhandlearray = [];
			if(!isdefined(self.lightfxgroups))
			{
				self.lightfxgroups = [];
			}
			else if(!IsArray(self.lightfxgroups))
			{
				self.lightfxgroups = Array(self.lightfxgroups);
			}
			self.lightfxgroups[self.lightfxgroups.size] = newfxhandlearray;
		}
	}
	self.lightfxgroups[groupID] = [];
	fxList = [];
	tagList = [];
	switch(groupID)
	{
		case 0:
		{
			addFxAndTagToLists(settings.lightgroups_1_fx1, settings.lightgroups_1_tag1, fxList, tagList, 1, settings.lightgroups_1_numslots);
			addFxAndTagToLists(settings.lightgroups_1_fx2, settings.lightgroups_1_tag2, fxList, tagList, 2, settings.lightgroups_1_numslots);
			addFxAndTagToLists(settings.lightgroups_1_fx3, settings.lightgroups_1_tag3, fxList, tagList, 3, settings.lightgroups_1_numslots);
			addFxAndTagToLists(settings.lightgroups_1_fx4, settings.lightgroups_1_tag4, fxList, tagList, 4, settings.lightgroups_1_numslots);
			break;
		}
		case 1:
		{
			addFxAndTagToLists(settings.lightgroups_2_fx1, settings.lightgroups_2_tag1, fxList, tagList, 1, settings.lightgroups_2_numslots);
			addFxAndTagToLists(settings.lightgroups_2_fx2, settings.lightgroups_2_tag2, fxList, tagList, 2, settings.lightgroups_2_numslots);
			addFxAndTagToLists(settings.lightgroups_2_fx3, settings.lightgroups_2_tag3, fxList, tagList, 3, settings.lightgroups_2_numslots);
			addFxAndTagToLists(settings.lightgroups_2_fx4, settings.lightgroups_2_tag4, fxList, tagList, 4, settings.lightgroups_2_numslots);
			break;
		}
		case 2:
		{
			addFxAndTagToLists(settings.lightgroups_3_fx1, settings.lightgroups_3_tag1, fxList, tagList, 1, settings.lightgroups_3_numslots);
			addFxAndTagToLists(settings.lightgroups_3_fx2, settings.lightgroups_3_tag2, fxList, tagList, 2, settings.lightgroups_3_numslots);
			addFxAndTagToLists(settings.lightgroups_3_fx3, settings.lightgroups_3_tag3, fxList, tagList, 3, settings.lightgroups_3_numslots);
			addFxAndTagToLists(settings.lightgroups_3_fx4, settings.lightgroups_3_tag4, fxList, tagList, 4, settings.lightgroups_3_numslots);
			break;
		}
		case 3:
		{
			addFxAndTagToLists(settings.lightgroups_4_fx1, settings.lightgroups_4_tag1, fxList, tagList, 1, settings.lightgroups_4_numslots);
			addFxAndTagToLists(settings.lightgroups_4_fx2, settings.lightgroups_4_tag2, fxList, tagList, 2, settings.lightgroups_4_numslots);
			addFxAndTagToLists(settings.lightgroups_4_fx3, settings.lightgroups_4_tag3, fxList, tagList, 3, settings.lightgroups_4_numslots);
			addFxAndTagToLists(settings.lightgroups_4_fx4, settings.lightgroups_4_tag4, fxList, tagList, 4, settings.lightgroups_4_numslots);
			break;
		}
	}
	for(i = 0; i < fxList.size; i++)
	{
		fx_handle = PlayFXOnTag(localClientNum, fxList[i], self, tagList[i]);
		if(!isdefined(self.lightfxgroups[groupID]))
		{
			self.lightfxgroups[groupID] = [];
		}
		else if(!IsArray(self.lightfxgroups[groupID]))
		{
			self.lightfxgroups[groupID] = Array(self.lightfxgroups[groupID]);
		}
		self.lightfxgroups[groupID][self.lightfxgroups[groupID].size] = fx_handle;
	}
}

/*
	Name: field_toggle_lights_group_handler1
	Namespace: vehicle
	Checksum: 0xB2754E46
	Offset: 0x31B8
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function field_toggle_lights_group_handler1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self lights_group_toggle(localClientNum, 1, newVal);
}

/*
	Name: field_toggle_lights_group_handler2
	Namespace: vehicle
	Checksum: 0x29A93F2
	Offset: 0x3220
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function field_toggle_lights_group_handler2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self lights_group_toggle(localClientNum, 2, newVal);
}

/*
	Name: field_toggle_lights_group_handler3
	Namespace: vehicle
	Checksum: 0x4BFDF16A
	Offset: 0x3288
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function field_toggle_lights_group_handler3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self lights_group_toggle(localClientNum, 3, newVal);
}

/*
	Name: field_toggle_lights_group_handler4
	Namespace: vehicle
	Checksum: 0x6BFA43A9
	Offset: 0x32F0
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function field_toggle_lights_group_handler4(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self lights_group_toggle(localClientNum, 4, newVal);
}

/*
	Name: delete_alert_lights
	Namespace: vehicle
	Checksum: 0x1F9476D9
	Offset: 0x3358
	Size: 0x6D
	Parameters: 1
	Flags: None
*/
function delete_alert_lights(localClientNum)
{
	if(isdefined(self.alert_light_fx_handles))
	{
		for(i = 0; i < self.alert_light_fx_handles.size; i++)
		{
			stopfx(localClientNum, self.alert_light_fx_handles[i]);
		}
	}
	self.alert_light_fx_handles = undefined;
}

/*
	Name: lights_off
	Namespace: vehicle
	Checksum: 0x328F30B3
	Offset: 0x33D0
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function lights_off(localClientNum)
{
	if(isdefined(self.light_fx_handles))
	{
		for(i = 0; i < self.light_fx_handles.size; i++)
		{
			stopfx(localClientNum, self.light_fx_handles[i]);
		}
	}
	self.light_fx_handles = undefined;
	delete_alert_lights(localClientNum);
}

/*
	Name: field_toggle_emp
	Namespace: vehicle
	Checksum: 0x642D0FB0
	Offset: 0x3460
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function field_toggle_emp(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self thread toggle_fx_bundle(localClientNum, "emp_base", newVal == 1);
}

/*
	Name: field_toggle_burn
	Namespace: vehicle
	Checksum: 0xF2E88636
	Offset: 0x34D0
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function field_toggle_burn(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self thread toggle_fx_bundle(localClientNum, "burn_base", newVal == 1);
}

/*
	Name: toggle_fx_bundle
	Namespace: vehicle
	Checksum: 0x3FA75967
	Offset: 0x3540
	Size: 0x2CD
	Parameters: 3
	Flags: None
*/
function toggle_fx_bundle(localClientNum, name, turnOn)
{
	if(!isdefined(self.settings) && isdefined(self.scriptbundlesettings))
	{
		self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	}
	if(!isdefined(self.settings))
	{
		return;
	}
	self endon("entityshutdown");
	self notify("end_toggle_field_fx_" + name);
	self endon("end_toggle_field_fx_" + name);
	wait_for_DObj(localClientNum);
	if(!isdefined(self.fx_handles))
	{
		self.fx_handles = [];
	}
	if(isdefined(self.fx_handles[name]))
	{
		handle = self.fx_handles[name];
		if(IsArray(handle))
		{
			foreach(handleElement in handle)
			{
				stopfx(localClientNum, handleElement);
			}
		}
		else
		{
			stopfx(localClientNum, handle);
		}
	}
	if(turnOn)
	{
		i = 1;
		for(;;)
		{
			FX = GetStructField(self.settings, name + "_fx_" + i);
			if(!isdefined(FX))
			{
				return;
			}
			tag = GetStructField(self.settings, name + "_tag_" + i);
			delay = GetStructField(self.settings, name + "_delay_" + i);
			self thread delayed_fx_thread(localClientNum, name, FX, tag, delay);
			i++;
		}
	}
}

/*
	Name: delayed_fx_thread
	Namespace: vehicle
	Checksum: 0xF556AE1E
	Offset: 0x3818
	Size: 0x137
	Parameters: 5
	Flags: None
*/
function delayed_fx_thread(localClientNum, name, FX, tag, delay)
{
	self endon("entityshutdown");
	self endon("end_toggle_field_fx_" + name);
	if(!isdefined(tag))
	{
		return;
	}
	if(isdefined(delay) && delay > 0)
	{
		wait(delay);
	}
	fx_handle = PlayFXOnTag(localClientNum, FX, self, tag);
	if(!isdefined(self.fx_handles[name]))
	{
		self.fx_handles[name] = [];
	}
	else if(!IsArray(self.fx_handles[name]))
	{
		self.fx_handles[name] = Array(self.fx_handles[name]);
	}
	self.fx_handles[name][self.fx_handles[name].size] = fx_handle;
}

/*
	Name: field_toggle_sounds
	Namespace: vehicle
	Checksum: 0x20E365AB
	Offset: 0x3958
	Size: 0xD3
	Parameters: 7
	Flags: None
*/
function field_toggle_sounds(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.vehicleClass) && self.vehicleClass == "helicopter")
	{
		if(newVal)
		{
			self notify("stop_heli_sounds");
			self.should_not_play_sounds = 1;
		}
		else
		{
			self notify("play_heli_sounds");
			self.should_not_play_sounds = 0;
		}
	}
	if(newVal)
	{
		self disablevehiclesounds();
	}
	else
	{
		self enablevehiclesounds();
	}
}

/*
	Name: field_toggle_dnidamagefx
	Namespace: vehicle
	Checksum: 0xF54DD689
	Offset: 0x3A38
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function field_toggle_dnidamagefx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self thread postfx::playPostfxBundle("pstfx_dni_vehicle_dmg");
	}
}

/*
	Name: toggle_flir_postfxbundle
	Namespace: vehicle
	Checksum: 0xC3FBD217
	Offset: 0x3AA8
	Size: 0x19B
	Parameters: 7
	Flags: None
*/
function toggle_flir_postfxbundle(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	player = self;
	if(newVal == oldVal)
	{
		return;
	}
	if(!isdefined(player) || !player isLocalPlayer())
	{
		return;
	}
	if(newVal == 0)
	{
		player thread postfx::stopPlayingPostfxBundle();
		update_ui_fullscreen_filter_model(localClientNum, 0);
	}
	else if(newVal == 1)
	{
		if(player ShouldChangeScreenPostFx(localClientNum))
		{
			player thread postfx::playPostfxBundle("pstfx_infrared");
			update_ui_fullscreen_filter_model(localClientNum, 2);
		}
	}
	else if(newVal == 2)
	{
		should_change = 1;
		if(player ShouldChangeScreenPostFx(localClientNum))
		{
			player thread postfx::playPostfxBundle("pstfx_flir");
			update_ui_fullscreen_filter_model(localClientNum, 1);
		}
	}
}

/*
	Name: ShouldChangeScreenPostFx
	Namespace: vehicle
	Checksum: 0x365C2241
	Offset: 0x3C50
	Size: 0x9F
	Parameters: 1
	Flags: None
*/
function ShouldChangeScreenPostFx(localClientNum)
{
	player = self;
	/#
		Assert(isdefined(player));
	#/
	if(player GetInKillcam(localClientNum))
	{
		killcamentity = player GetKillCamEntity(localClientNum);
		if(isdefined(killcamentity) && killcamentity != player)
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: set_static_postfxbundle
	Namespace: vehicle
	Checksum: 0xEBFD0C44
	Offset: 0x3CF8
	Size: 0xD3
	Parameters: 7
	Flags: None
*/
function set_static_postfxbundle(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	player = self;
	if(newVal == oldVal)
	{
		return;
	}
	if(!isdefined(player) || !player isLocalPlayer())
	{
		return;
	}
	if(newVal == 0)
	{
		player thread postfx::stopPlayingPostfxBundle();
	}
	else if(newVal == 1)
	{
		player thread postfx::playPostfxBundle("pstfx_static");
	}
}

/*
	Name: update_ui_fullscreen_filter_model
	Namespace: vehicle
	Checksum: 0x78C212D7
	Offset: 0x3DD8
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function update_ui_fullscreen_filter_model(localClientNum, vision_set_value)
{
	controllerModel = GetUIModelForController(localClientNum);
	model = GetUIModel(controllerModel, "vehicle.fullscreenFilter");
	if(isdefined(model))
	{
		SetUIModelValue(model, vision_set_value);
	}
}

/*
	Name: field_toggle_treadfx
	Namespace: vehicle
	Checksum: 0xE7FEDE0D
	Offset: 0x3E68
	Size: 0x233
	Parameters: 7
	Flags: None
*/
function field_toggle_treadfx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.vehicleClass) && self.vehicleClass == "helicopter" || (isdefined(self.vehicleClass) && self.vehicleClass == "plane"))
	{
		/#
			println("Dev Block strings are not supported");
		#/
		if(newVal)
		{
			if(isdefined(bNewEnt) && bNewEnt)
			{
				self.csf_no_tread = 1;
			}
			else
			{
				self kill_treads_forever();
			}
		}
		else if(isdefined(self.csf_no_tread))
		{
			self.csf_no_tread = 0;
		}
		self kill_treads_forever();
		self thread aircraft_dustkick();
	}
	else if(newVal)
	{
		/#
			println("Dev Block strings are not supported");
		#/
		if(isdefined(bNewEnt) && bNewEnt)
		{
			/#
				println("Dev Block strings are not supported" + self GetEntityNumber());
			#/
			self.csf_no_tread = 1;
		}
		else
		{
			println("Dev Block strings are not supported" + self GetEntityNumber());
			self kill_treads_forever();
		}
		/#
		#/
	}
	else
	{
		println("Dev Block strings are not supported");
		if(isdefined(self.csf_no_tread))
		{
			self.csf_no_tread = 0;
		}
		self kill_treads_forever();
	}
	/#
	#/
}

/*
	Name: field_use_engine_damage_sounds
	Namespace: vehicle
	Checksum: 0xD22E2E61
	Offset: 0x40A8
	Size: 0xD5
	Parameters: 7
	Flags: None
*/
function field_use_engine_damage_sounds(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.vehicleClass) && self.vehicleClass == "helicopter")
	{
		switch(newVal)
		{
			case 0:
			{
				self.engine_damage_low = 0;
				self.engine_damage_high = 0;
				break;
			}
			case 1:
			{
				self.engine_damage_low = 1;
				self.engine_damage_high = 0;
				break;
			}
			case 1:
			{
				self.engine_damage_low = 0;
				self.engine_damage_high = 1;
				break;
			}
		}
	}
}

/*
	Name: field_do_deathfx
	Namespace: vehicle
	Checksum: 0x4DF672A
	Offset: 0x4188
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function field_do_deathfx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	if(newVal == 2)
	{
		self field_do_empdeathfx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
	}
	else
	{
		self field_do_standarddeathfx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
	}
}

/*
	Name: field_do_standarddeathfx
	Namespace: vehicle
	Checksum: 0x4810C4FA
	Offset: 0x4250
	Size: 0x17B
	Parameters: 7
	Flags: None
*/
function field_do_standarddeathfx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal && !bInitialSnap)
	{
		wait_for_DObj(localClientNum);
		if(isdefined(self.deathfxname))
		{
			if(isdefined(self.deathfxtag) && self.deathfxtag != "")
			{
				handle = PlayFXOnTag(localClientNum, self.deathfxname, self, self.deathfxtag);
			}
			else
			{
				handle = playFX(localClientNum, self.deathfxname, self.origin);
			}
			SetFXIgnorePause(localClientNum, handle, 1);
		}
		self playsound(localClientNum, self.deathfxsound);
		if(isdefined(self.deathquakescale) && self.deathquakescale > 0)
		{
			self Earthquake(self.deathquakescale, self.deathquakeduration, self.origin, self.deathquakeradius);
		}
	}
}

/*
	Name: field_do_empdeathfx
	Namespace: vehicle
	Checksum: 0x9968E423
	Offset: 0x43D8
	Size: 0x253
	Parameters: 7
	Flags: None
*/
function field_do_empdeathfx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(self.settings) && isdefined(self.scriptbundlesettings))
	{
		self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	}
	if(!isdefined(self.settings))
	{
		self field_do_standarddeathfx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
		return;
	}
	if(newVal && !bInitialSnap)
	{
		wait_for_DObj(localClientNum);
		s = self.settings;
		if(isdefined(s.emp_death_fx_1))
		{
			if(isdefined(s.emp_death_tag_1) && s.emp_death_tag_1 != "")
			{
				handle = PlayFXOnTag(localClientNum, s.emp_death_fx_1, self, s.emp_death_tag_1);
			}
			else
			{
				handle = playFX(localClientNum, s.emp_death_tag_1, self.origin);
			}
			SetFXIgnorePause(localClientNum, handle, 1);
		}
		self playsound(localClientNum, s.emp_death_sound_1);
		if(isdefined(self.deathquakescale) && self.deathquakescale > 0)
		{
			self Earthquake(self.deathquakescale * 0.25, self.deathquakeduration * 2, self.origin, self.deathquakeradius);
		}
	}
}

/*
	Name: field_update_alert_level
	Namespace: vehicle
	Checksum: 0xA07AD81B
	Offset: 0x4638
	Size: 0x1D1
	Parameters: 7
	Flags: None
*/
function field_update_alert_level(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	delete_alert_lights(localClientNum);
	if(!isdefined(self.scriptbundlesettings))
	{
		return;
	}
	if(!isdefined(self.alert_light_fx_handles))
	{
		self.alert_light_fx_handles = [];
	}
	settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	switch(newVal)
	{
		case 0:
		{
			break;
		}
		case 1:
		{
			if(isdefined(settings.unawarelightfx1))
			{
				self.alert_light_fx_handles[0] = PlayFXOnTag(localClientNum, settings.unawarelightfx1, self, settings.lighttag1);
			}
			break;
		}
		case 2:
		{
			if(isdefined(settings.alertlightfx1))
			{
				self.alert_light_fx_handles[0] = PlayFXOnTag(localClientNum, settings.alertlightfx1, self, settings.lighttag1);
			}
			break;
		}
		case 3:
		{
			if(isdefined(settings.combatlightfx1))
			{
				self.alert_light_fx_handles[0] = PlayFXOnTag(localClientNum, settings.combatlightfx1, self, settings.lighttag1);
			}
			break;
		}
	}
}

/*
	Name: field_toggle_exhaustfx_handler
	Namespace: vehicle
	Checksum: 0x57D4882
	Offset: 0x4818
	Size: 0xD3
	Parameters: 7
	Flags: None
*/
function field_toggle_exhaustfx_handler(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(isdefined(bNewEnt) && bNewEnt)
		{
			self.csf_no_exhaust = 1;
		}
		else
		{
			self stop_exhaust(localClientNum);
		}
	}
	else if(isdefined(self.csf_no_exhaust))
	{
		self.csf_no_exhaust = 0;
	}
	self stop_exhaust(localClientNum);
	self play_exhaust(localClientNum);
}

/*
	Name: control_lights_groups
	Namespace: vehicle
	Checksum: 0xE23FD8C9
	Offset: 0x48F8
	Size: 0x1B3
	Parameters: 2
	Flags: None
*/
function control_lights_groups(localClientNum, on)
{
	if(!isdefined(self.scriptbundlesettings))
	{
		return;
	}
	settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	if(!isdefined(settings) || !isdefined(settings.lightgroups_numGroups))
	{
		return;
	}
	if(settings.lightgroups_numGroups >= 1 && settings.lightgroups_1_always_on !== 1)
	{
		lights_group_toggle(localClientNum, 1, on);
	}
	if(settings.lightgroups_numGroups >= 2 && settings.lightgroups_2_always_on !== 1)
	{
		lights_group_toggle(localClientNum, 2, on);
	}
	if(settings.lightgroups_numGroups >= 3 && settings.lightgroups_3_always_on !== 1)
	{
		lights_group_toggle(localClientNum, 3, on);
	}
	if(settings.lightgroups_numGroups >= 4 && settings.lightgroups_4_always_on !== 1)
	{
		lights_group_toggle(localClientNum, 4, on);
	}
}

/*
	Name: field_toggle_lights_handler
	Namespace: vehicle
	Checksum: 0xD5BBFC5C
	Offset: 0x4AB8
	Size: 0x103
	Parameters: 7
	Flags: None
*/
function field_toggle_lights_handler(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self lights_off(localClientNum);
	}
	else if(newVal == 2)
	{
		self lights_on(localClientNum, "allies");
	}
	else if(newVal == 3)
	{
		self lights_on(localClientNum, "axis");
	}
	else
	{
		self lights_on(localClientNum);
	}
	control_lights_groups(localClientNum, newVal != 1);
}

/*
	Name: field_toggle_lockon_handler
	Namespace: vehicle
	Checksum: 0xD9603104
	Offset: 0x4BC8
	Size: 0x3B
	Parameters: 7
	Flags: None
*/
function field_toggle_lockon_handler(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
}

/*
	Name: addFxAndTagToLists
	Namespace: vehicle
	Checksum: 0x8BE55DB3
	Offset: 0x4C10
	Size: 0x109
	Parameters: 6
	Flags: None
*/
function addFxAndTagToLists(FX, tag, fxList, tagList, id, maxID)
{
	if(isdefined(FX) && isdefined(tag) && id <= maxID)
	{
		if(!isdefined(fxList))
		{
			fxList = [];
		}
		else if(!IsArray(fxList))
		{
			fxList = Array(fxList);
		}
		fxList[fxList.size] = FX;
		if(!isdefined(tagList))
		{
			tagList = [];
		}
		else if(!IsArray(tagList))
		{
			tagList = Array(tagList);
		}
		tagList[tagList.size] = tag;
	}
}

/*
	Name: field_update_damage_state
	Namespace: vehicle
	Checksum: 0x7E10159A
	Offset: 0x4D28
	Size: 0x91B
	Parameters: 7
	Flags: None
*/
function field_update_damage_state(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(self.scriptbundlesettings))
	{
		return;
	}
	settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	if(isdefined(self.damage_state_fx_handles))
	{
		foreach(fx_handle in self.damage_state_fx_handles)
		{
			stopfx(localClientNum, fx_handle);
		}
	}
	self.damage_state_fx_handles = [];
	fxList = [];
	tagList = [];
	sound = undefined;
	switch(newVal)
	{
		case 0:
		{
			break;
		}
		case 1:
		{
			addFxAndTagToLists(settings.damagestate_lv1_fx1, settings.damagestate_lv1_tag1, fxList, tagList, 1, settings.damagestate_lv1_numslots);
			addFxAndTagToLists(settings.damagestate_lv1_fx2, settings.damagestate_lv1_tag2, fxList, tagList, 2, settings.damagestate_lv1_numslots);
			addFxAndTagToLists(settings.damagestate_lv1_fx3, settings.damagestate_lv1_tag3, fxList, tagList, 3, settings.damagestate_lv1_numslots);
			addFxAndTagToLists(settings.damagestate_lv1_fx4, settings.damagestate_lv1_tag4, fxList, tagList, 4, settings.damagestate_lv1_numslots);
			sound = settings.damagestate_lv1_sound;
			break;
		}
		case 2:
		{
			addFxAndTagToLists(settings.damagestate_lv2_fx1, settings.damagestate_lv2_tag1, fxList, tagList, 1, settings.damagestate_lv2_numslots);
			addFxAndTagToLists(settings.damagestate_lv2_fx2, settings.damagestate_lv2_tag2, fxList, tagList, 2, settings.damagestate_lv2_numslots);
			addFxAndTagToLists(settings.damagestate_lv2_fx3, settings.damagestate_lv2_tag3, fxList, tagList, 3, settings.damagestate_lv2_numslots);
			addFxAndTagToLists(settings.damagestate_lv2_fx4, settings.damagestate_lv2_tag4, fxList, tagList, 4, settings.damagestate_lv2_numslots);
			sound = settings.damagestate_lv2_sound;
			break;
		}
		case 3:
		{
			addFxAndTagToLists(settings.damagestate_lv3_fx1, settings.damagestate_lv3_tag1, fxList, tagList, 1, settings.damagestate_lv3_numslots);
			addFxAndTagToLists(settings.damagestate_lv3_fx2, settings.damagestate_lv3_tag2, fxList, tagList, 2, settings.damagestate_lv3_numslots);
			addFxAndTagToLists(settings.damagestate_lv3_fx3, settings.damagestate_lv3_tag3, fxList, tagList, 3, settings.damagestate_lv3_numslots);
			addFxAndTagToLists(settings.damagestate_lv3_fx4, settings.damagestate_lv3_tag4, fxList, tagList, 4, settings.damagestate_lv3_numslots);
			sound = settings.damagestate_lv3_sound;
			break;
		}
		case 4:
		{
			addFxAndTagToLists(settings.damagestate_lv4_fx1, settings.damagestate_lv4_tag1, fxList, tagList, 1, settings.damagestate_lv4_numslots);
			addFxAndTagToLists(settings.damagestate_lv4_fx2, settings.damagestate_lv4_tag2, fxList, tagList, 2, settings.damagestate_lv4_numslots);
			addFxAndTagToLists(settings.damagestate_lv4_fx3, settings.damagestate_lv4_tag3, fxList, tagList, 3, settings.damagestate_lv4_numslots);
			addFxAndTagToLists(settings.damagestate_lv4_fx4, settings.damagestate_lv4_tag4, fxList, tagList, 4, settings.damagestate_lv4_numslots);
			sound = settings.damagestate_lv4_sound;
			break;
		}
		case 5:
		{
			addFxAndTagToLists(settings.damagestate_lv5_fx1, settings.damagestate_lv5_tag1, fxList, tagList, 1, settings.damagestate_lv5_numslots);
			addFxAndTagToLists(settings.damagestate_lv5_fx2, settings.damagestate_lv5_tag2, fxList, tagList, 2, settings.damagestate_lv5_numslots);
			addFxAndTagToLists(settings.damagestate_lv5_fx3, settings.damagestate_lv5_tag3, fxList, tagList, 3, settings.damagestate_lv5_numslots);
			addFxAndTagToLists(settings.damagestate_lv5_fx4, settings.damagestate_lv5_tag4, fxList, tagList, 4, settings.damagestate_lv5_numslots);
			sound = settings.damagestate_lv5_sound;
			break;
		}
		case 6:
		{
			addFxAndTagToLists(settings.damagestate_lv6_fx1, settings.damagestate_lv6_tag1, fxList, tagList, 1, settings.damagestate_lv6_numslots);
			addFxAndTagToLists(settings.damagestate_lv6_fx2, settings.damagestate_lv6_tag2, fxList, tagList, 2, settings.damagestate_lv6_numslots);
			addFxAndTagToLists(settings.damagestate_lv6_fx3, settings.damagestate_lv6_tag3, fxList, tagList, 3, settings.damagestate_lv6_numslots);
			addFxAndTagToLists(settings.damagestate_lv6_fx4, settings.damagestate_lv6_tag4, fxList, tagList, 4, settings.damagestate_lv6_numslots);
			sound = settings.damagestate_lv6_sound;
			break;
		}
	}
	for(i = 0; i < fxList.size; i++)
	{
		fx_handle = PlayFXOnTag(localClientNum, fxList[i], self, tagList[i]);
		if(!isdefined(self.damage_state_fx_handles))
		{
			self.damage_state_fx_handles = [];
		}
		else if(!IsArray(self.damage_state_fx_handles))
		{
			self.damage_state_fx_handles = Array(self.damage_state_fx_handles);
		}
		self.damage_state_fx_handles[self.damage_state_fx_handles.size] = fx_handle;
	}
	if(isdefined(self) && isdefined(sound))
	{
		self playsound(localClientNum, sound);
	}
}

/*
	Name: field_death_spawn_dynents
	Namespace: vehicle
	Checksum: 0xE86B8C28
	Offset: 0x5650
	Size: 0x76D
	Parameters: 7
	Flags: None
*/
function field_death_spawn_dynents(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(self.scriptbundlesettings))
	{
		return;
	}
	settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	if(localClientNum == 0)
	{
		velocity = self GetVelocity();
		if(isdefined(settings.death_dynent_count))
		{
		}
		else
		{
		}
		numDynents = 0;
		for(i = 0; i < numDynents; i++)
		{
			model = GetStructField(settings, "death_dynmodel" + i);
			if(!isdefined(model))
			{
				continue;
			}
			gibpart = GetStructField(settings, "death_dynent_gib" + i);
			if(self.gibbed === 1 && gibpart === 1)
			{
				continue;
			}
			if(isdefined(GetStructField(settings, "death_dynent_force_pitch" + i)))
			{
			}
			else
			{
			}
			pitch = 0;
			if(isdefined(GetStructField(settings, "death_dynent_force_yaw" + i)))
			{
			}
			else
			{
			}
			yaw = 0;
			angles = (RandomFloatRange(pitch - 15, pitch + 15), RandomFloatRange(yaw - 20, yaw + 20), RandomFloatRange(-20, 20));
			direction = AnglesToForward(self.angles + angles);
			if(isdefined(GetStructField(settings, "death_dynent_force_minscale" + i)))
			{
			}
			else
			{
			}
			minscale = 0;
			if(isdefined(GetStructField(settings, "death_dynent_force_maxscale" + i)))
			{
			}
			else
			{
			}
			maxscale = 0;
			force = direction * RandomFloatRange(minscale, maxscale);
			if(isdefined(GetStructField(settings, "death_dynent_offsetZ" + i)))
			{
			}
			else if(isdefined(GetStructField(settings, "death_dynent_offsetY" + i)))
			{
			}
			else if(isdefined(GetStructField(settings, "death_dynent_offsetX" + i)))
			{
			}
			else
			{
			}
			offset = (0, GetStructField(settings, "death_dynent_offsetX" + i), GetStructField(settings, "death_dynent_offsetY" + i));
			switch(newVal)
			{
				case 0:
				{
					break;
				}
				case 1:
				{
					FX = GetStructField(settings, "death_dynent_fx" + i);
					break;
				}
				case 2:
				{
					FX = GetStructField(settings, "death_dynent_elec_fx" + i);
					break;
				}
				case 3:
				{
					FX = GetStructField(settings, "death_dynent_fire_fx" + i);
					break;
				}
			}
			offset = RotatePoint(offset, self.angles);
			if(newVal > 1 && isdefined(FX))
			{
				dynEnt = CreateDynEntAndLaunch(localClientNum, model, self.origin + offset, self.angles, (0, 0, 0), velocity * 0.8, FX);
			}
			else if(newVal == 1 && isdefined(FX))
			{
				dynEnt = CreateDynEntAndLaunch(localClientNum, model, self.origin + offset, self.angles, (0, 0, 0), velocity * 0.8, FX);
			}
			else
			{
				dynEnt = CreateDynEntAndLaunch(localClientNum, model, self.origin + offset, self.angles, (0, 0, 0), velocity * 0.8);
			}
			if(isdefined(dynEnt))
			{
				hitOffset = (RandomFloatRange(-5, 5), RandomFloatRange(-5, 5), RandomFloatRange(-5, 5));
				LaunchDynent(dynEnt, force, hitOffset);
			}
		}
	}
}

/*
	Name: field_gib_spawn_dynents
	Namespace: vehicle
	Checksum: 0x2F817E99
	Offset: 0x5DC8
	Size: 0x675
	Parameters: 7
	Flags: None
*/
function field_gib_spawn_dynents(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(self.scriptbundlesettings))
	{
		return;
	}
	settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	if(localClientNum == 0)
	{
		velocity = self GetVelocity();
		numDynents = 2;
		for(i = 0; i < numDynents; i++)
		{
			model = GetStructField(settings, "servo_gib_model" + i);
			if(!isdefined(model))
			{
				return;
			}
			self.gibbed = 1;
			origin = self.origin;
			angles = self.angles;
			hidetag = GetStructField(settings, "servo_gib_tag" + i);
			if(isdefined(hidetag))
			{
				origin = self GetTagOrigin(hidetag);
				angles = self GetTagAngles(hidetag);
			}
			if(isdefined(GetStructField(settings, "servo_gib_force_pitch" + i)))
			{
			}
			else
			{
			}
			pitch = 0;
			if(isdefined(GetStructField(settings, "servo_gib_force_yaw" + i)))
			{
			}
			else
			{
			}
			yaw = 0;
			relative_angles = (RandomFloatRange(pitch - 5, pitch + 5), RandomFloatRange(yaw - 5, yaw + 5), RandomFloatRange(-5, 5));
			direction = AnglesToForward(angles + relative_angles);
			if(isdefined(GetStructField(settings, "servo_gib_force_minscale" + i)))
			{
			}
			else
			{
			}
			minscale = 0;
			if(isdefined(GetStructField(settings, "servo_gib_force_maxscale" + i)))
			{
			}
			else
			{
			}
			maxscale = 0;
			force = direction * RandomFloatRange(minscale, maxscale);
			if(isdefined(GetStructField(settings, "servo_gib_offsetZ" + i)))
			{
			}
			else if(isdefined(GetStructField(settings, "servo_gib_offsetY" + i)))
			{
			}
			else if(isdefined(GetStructField(settings, "servo_gib_offsetX" + i)))
			{
			}
			else
			{
			}
			offset = (0, GetStructField(settings, "servo_gib_offsetX" + i), GetStructField(settings, "servo_gib_offsetY" + i));
			FX = GetStructField(settings, "servo_gib_fx" + i);
			offset = RotatePoint(offset, angles);
			if(isdefined(FX))
			{
				dynEnt = CreateDynEntAndLaunch(localClientNum, model, origin + offset, angles, (0, 0, 0), velocity * 0.8, FX);
			}
			else
			{
				dynEnt = CreateDynEntAndLaunch(localClientNum, model, origin + offset, angles, (0, 0, 0), velocity * 0.8);
			}
			if(isdefined(dynEnt))
			{
				hitOffset = (RandomFloatRange(-5, 5), RandomFloatRange(-5, 5), RandomFloatRange(-5, 5));
				LaunchDynent(dynEnt, force, hitOffset);
			}
		}
	}
}

/*
	Name: build_damage_filter_list
	Namespace: vehicle
	Checksum: 0xD4FE13F6
	Offset: 0x6448
	Size: 0x8D
	Parameters: 0
	Flags: AutoExec
*/
function autoexec build_damage_filter_list()
{
	if(!isdefined(level.vehicle_damage_filters))
	{
		level.vehicle_damage_filters = [];
	}
	level.vehicle_damage_filters[0] = "generic_filter_vehicle_damage";
	level.vehicle_damage_filters[1] = "generic_filter_sam_damage";
	level.vehicle_damage_filters[2] = "generic_filter_f35_damage";
	level.vehicle_damage_filters[3] = "generic_filter_vehicle_damage_sonar";
	level.vehicle_damage_filters[4] = "generic_filter_rts_vehicle_damage";
}

/*
	Name: init_damage_filter
	Namespace: vehicle
	Checksum: 0xD378F105
	Offset: 0x64E0
	Size: 0xDB
	Parameters: 1
	Flags: None
*/
function init_damage_filter(materialId)
{
	level.localPlayers[0].damage_filter_intensity = 0;
	materialName = level.vehicle_damage_filters[materialId];
	filter::init_filter_vehicle_damage(level.localPlayers[0], materialName);
	filter::enable_filter_vehicle_damage(level.localPlayers[0], 3, materialName);
	filter::set_filter_vehicle_damage_amount(level.localPlayers[0], 3, 0);
	filter::set_filter_vehicle_sun_position(level.localPlayers[0], 3, 0, 0);
}

/*
	Name: damage_filter_enable
	Namespace: vehicle
	Checksum: 0x9C32C6E
	Offset: 0x65C8
	Size: 0x93
	Parameters: 2
	Flags: None
*/
function damage_filter_enable(localClientNum, materialId)
{
	filter::enable_filter_vehicle_damage(level.localPlayers[0], 3, level.vehicle_damage_filters[materialId]);
	level.localPlayers[0].damage_filter_intensity = 0;
	filter::set_filter_vehicle_damage_amount(level.localPlayers[0], 3, level.localPlayers[0].damage_filter_intensity);
}

/*
	Name: damage_filter_disable
	Namespace: vehicle
	Checksum: 0x18B76C93
	Offset: 0x6668
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function damage_filter_disable(localClientNum)
{
	level notify("damage_filter_off");
	level.localPlayers[0].damage_filter_intensity = 0;
	filter::set_filter_vehicle_damage_amount(level.localPlayers[0], 3, level.localPlayers[0].damage_filter_intensity);
	filter::disable_filter_vehicle_damage(level.localPlayers[0], 3);
}

/*
	Name: damage_filter_off
	Namespace: vehicle
	Checksum: 0x9AC8AD0D
	Offset: 0x6700
	Size: 0x117
	Parameters: 1
	Flags: None
*/
function damage_filter_off(localClientNum)
{
	level endon("damage_filter");
	level endon("damage_filter_off");
	level endon("damage_filter_heavy");
	if(!isdefined(level.localPlayers[0].damage_filter_intensity))
	{
		return;
	}
	while(level.localPlayers[0].damage_filter_intensity > 0)
	{
		level.localPlayers[0].damage_filter_intensity = level.localPlayers[0].damage_filter_intensity - 0.05050606;
		if(level.localPlayers[0].damage_filter_intensity < 0)
		{
			level.localPlayers[0].damage_filter_intensity = 0;
		}
		filter::set_filter_vehicle_damage_amount(level.localPlayers[0], 3, level.localPlayers[0].damage_filter_intensity);
		wait(0.016667);
	}
}

/*
	Name: damage_filter_light
	Namespace: vehicle
	Checksum: 0x98D81339
	Offset: 0x6820
	Size: 0x107
	Parameters: 1
	Flags: None
*/
function damage_filter_light(localClientNum)
{
	level endon("damage_filter_off");
	level endon("damage_filter_heavy");
	level notify("damage_filter");
	while(level.localPlayers[0].damage_filter_intensity < 0.5)
	{
		level.localPlayers[0].damage_filter_intensity = level.localPlayers[0].damage_filter_intensity + 0.083335;
		if(level.localPlayers[0].damage_filter_intensity > 0.5)
		{
			level.localPlayers[0].damage_filter_intensity = 0.5;
		}
		filter::set_filter_vehicle_damage_amount(level.localPlayers[0], 3, level.localPlayers[0].damage_filter_intensity);
		wait(0.016667);
	}
}

/*
	Name: damage_filter_heavy
	Namespace: vehicle
	Checksum: 0x418FCAA5
	Offset: 0x6930
	Size: 0xF7
	Parameters: 1
	Flags: None
*/
function damage_filter_heavy(localClientNum)
{
	level endon("damage_filter_off");
	level notify("damage_filter_heavy");
	while(level.localPlayers[0].damage_filter_intensity < 1)
	{
		level.localPlayers[0].damage_filter_intensity = level.localPlayers[0].damage_filter_intensity + 0.083335;
		if(level.localPlayers[0].damage_filter_intensity > 1)
		{
			level.localPlayers[0].damage_filter_intensity = 1;
		}
		filter::set_filter_vehicle_damage_amount(level.localPlayers[0], 3, level.localPlayers[0].damage_filter_intensity);
		wait(0.016667);
	}
}

