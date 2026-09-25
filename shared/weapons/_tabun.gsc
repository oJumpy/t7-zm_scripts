#using scripts\codescripts\struct;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;

#namespace tabun;

/*
	Name: init_shared
	Namespace: tabun
	Checksum: 0x6BE7C8BE
	Offset: 0x390
	Size: 0x2FB
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level.tabunInitialGasShockDuration = GetDvarInt("scr_tabunInitialGasShockDuration", "7");
	level.tabunWalkInGasShockDuration = GetDvarInt("scr_tabunWalkInGasShockDuration", "4");
	level.tabunGasShockRadius = GetDvarInt("scr_tabun_shock_radius", "185");
	level.tabunGasShockHeight = GetDvarInt("scr_tabun_shock_height", "20");
	level.tabunGasPoisonRadius = GetDvarInt("scr_tabun_effect_radius", "185");
	level.tabunGasPoisonHeight = GetDvarInt("scr_tabun_shock_height", "20");
	level.tabunGasDuration = GetDvarInt("scr_tabunGasDuration", "8");
	level.poisonDuration = GetDvarInt("scr_poisonDuration", "8");
	level.poisonDamage = GetDvarInt("scr_poisonDamage", "13");
	level.poisonDamageHardcore = GetDvarInt("scr_poisonDamageHardcore", "5");
	level.fx_tabun_0 = "tabun_tiny_mp";
	level.fx_tabun_1 = "tabun_small_mp";
	level.fx_tabun_2 = "tabun_medium_mp";
	level.fx_tabun_3 = "tabun_large_mp";
	level.fx_tabun_single = "tabun_center_mp";
	level.fx_tabun_radius0 = GetDvarInt("scr_fx_tabun_radius0", 55);
	level.fx_tabun_radius1 = GetDvarInt("scr_fx_tabun_radius1", 55);
	level.fx_tabun_radius2 = GetDvarInt("scr_fx_tabun_radius2", 50);
	level.fx_tabun_radius3 = GetDvarInt("scr_fx_tabun_radius3", 25);
	level.sound_tabun_start = "wpn_gas_hiss_start";
	level.sound_tabun_loop = "wpn_gas_hiss_lp";
	level.sound_tabun_stop = "wpn_gas_hiss_end";
	level.sound_shock_tabun_start = "";
	level.sound_shock_tabun_loop = "";
	level.sound_shock_tabun_stop = "";
	/#
		level thread checkDvarUpdates();
	#/
}

/*
	Name: checkDvarUpdates
	Namespace: tabun
	Checksum: 0x6943BD01
	Offset: 0x698
	Size: 0x247
	Parameters: 0
	Flags: None
*/
function checkDvarUpdates()
{
	while(1)
	{
		level.tabunGasPoisonRadius = GetDvarInt("scr_tabun_effect_radius", level.tabunGasPoisonRadius);
		level.tabunGasPoisonHeight = GetDvarInt("scr_tabun_shock_height", level.tabunGasPoisonHeight);
		level.tabunGasShockRadius = GetDvarInt("scr_tabun_shock_radius", level.tabunGasShockRadius);
		level.tabunGasShockHeight = GetDvarInt("scr_tabun_shock_height", level.tabunGasShockHeight);
		level.tabunInitialGasShockDuration = GetDvarInt("scr_tabunInitialGasShockDuration", level.tabunInitialGasShockDuration);
		level.tabunWalkInGasShockDuration = GetDvarInt("scr_tabunWalkInGasShockDuration", level.tabunWalkInGasShockDuration);
		level.tabunGasDuration = GetDvarInt("scr_tabunGasDuration", level.tabunGasDuration);
		level.poisonDuration = GetDvarInt("scr_poisonDuration", level.poisonDuration);
		level.poisonDamage = GetDvarInt("scr_poisonDamage", level.poisonDamage);
		level.poisonDamageHardcore = GetDvarInt("scr_poisonDamageHardcore", level.poisonDamageHardcore);
		level.fx_tabun_radius0 = GetDvarInt("scr_fx_tabun_radius0", level.fx_tabun_radius0);
		level.fx_tabun_radius1 = GetDvarInt("scr_fx_tabun_radius1", level.fx_tabun_radius1);
		level.fx_tabun_radius2 = GetDvarInt("scr_fx_tabun_radius2", level.fx_tabun_radius2);
		level.fx_tabun_radius3 = GetDvarInt("scr_fx_tabun_radius3", level.fx_tabun_radius3);
		wait(1);
	}
}

/*
	Name: watchTabunGrenadeDetonation
	Namespace: tabun
	Checksum: 0x319B862E
	Offset: 0x8E8
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function watchTabunGrenadeDetonation(owner)
{
	self endon("trophy_destroyed");
	self waittill("explode", position, surface);
	if(!isdefined(level.water_duds) || level.water_duds == 1)
	{
		if(isdefined(surface) && surface == "water")
		{
			return;
		}
	}
	if(GetDvarInt("scr_enable_new_tabun", 1))
	{
		generateLocations(position, owner);
	}
	else
	{
		singleLocation(position, owner);
	}
}

/*
	Name: damageEffectArea
	Namespace: tabun
	Checksum: 0x50B3FA68
	Offset: 0x9C8
	Size: 0x3F1
	Parameters: 5
	Flags: None
*/
function damageEffectArea(owner, position, radius, height, killCamEnt)
{
	shockEffectArea = spawn("trigger_radius", position, 0, radius, height);
	gasEffectArea = spawn("trigger_radius", position, 0, radius, height);
	/#
		if(GetDvarInt("Dev Block strings are not supported"))
		{
			level thread util::drawcylinder(position, radius, height, undefined, "Dev Block strings are not supported");
		}
	#/
	if(isdefined(level.dogsOnFlashDogs))
	{
		owner thread [[level.dogsOnFlashDogs]](shockEffectArea);
		owner thread [[level.dogsOnFlashDogs]](gasEffectArea);
	}
	loopWaitTime = 0.5;
	for(durationOfTabun = level.tabunGasDuration; durationOfTabun > 0;  = level.tabunGasDuration)
	{
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			if(level.friendlyfire == 0)
			{
				if(players[i] != owner)
				{
					if(!isdefined(owner) || !isdefined(owner.team))
					{
						continue;
					}
					if(level.teambased && players[i].team == owner.team)
					{
						continue;
					}
				}
			}
			if(!isdefined(players[i].inPoisonArea) || players[i].inPoisonArea == 0)
			{
				if(players[i] istouching(gasEffectArea) && players[i].sessionstate == "playing")
				{
					if(!players[i] hasPerk("specialty_proximityprotection"))
					{
						trace = bullettrace(position, players[i].origin + VectorScale((0, 0, 1), 12), 0, players[i]);
						if(trace["fraction"] == 1)
						{
							players[i].lastPoisonedBy = owner;
							players[i] thread damageInPoisonArea(shockEffectArea, killCamEnt, trace, position);
						}
					}
				}
			}
		}
		wait(loopWaitTime);
	}
	if(level.tabunGasDuration < level.poisonDuration)
	{
		wait(level.poisonDuration - level.tabunGasDuration);
	}
	shockEffectArea delete();
	gasEffectArea delete();
	/#
		if(GetDvarInt("Dev Block strings are not supported"))
		{
			level notify("tabun_draw_cylinder_stop", durationOfTabun - loopWaitTime);
		}
	#/
}

/*
	Name: damageInPoisonArea
	Namespace: tabun
	Checksum: 0xAE633B96
	Offset: 0xDC8
	Size: 0x3AF
	Parameters: 4
	Flags: None
*/
function damageInPoisonArea(gasEffectArea, killCamEnt, trace, position)
{
	self endon("disconnect");
	self endon("death");
	self thread watch_death();
	self.inPoisonArea = 1;
	self startPoisoning();
	tabunShockSound = spawn("script_origin", (0, 0, 1));
	tabunShockSound thread deleteEntOnOwnerDeath(self);
	tabunShockSound.origin = position;
	tabunShockSound playsound(level.sound_shock_tabun_start);
	tabunShockSound PlayLoopSound(level.sound_shock_tabun_loop);
	timer = 0;
	while(trace["fraction"] == 1 && isdefined(gasEffectArea) && self istouching(gasEffectArea) && self.sessionstate == "playing" && isdefined(self.lastPoisonedBy))
	{
		damage = level.poisonDamage;
		if(level.hardcoreMode)
		{
			damage = level.poisonDamageHardcore;
		}
		self DoDamage(damage, gasEffectArea.origin, self.lastPoisonedBy, killCamEnt, "none", "MOD_GAS", 0, GetWeapon("tabun_gas"));
		if(self util::mayApplyScreenEffect())
		{
			switch(timer)
			{
				case 0:
				{
					self shellshock("tabun_gas_mp", 1);
					break;
				}
				case 1:
				{
					self shellshock("tabun_gas_nokick_mp", 1);
					break;
				}
				case default:
				{
					break;
				}
			}
			timer++;
			if(timer >= 2)
			{
				timer = 0;
			}
			self hide_hud();
		}
		wait(1);
		trace = bullettrace(position, self.origin + VectorScale((0, 0, 1), 12), 0, self);
	}
	tabunShockSound StopLoopSound(0.5);
	wait(0.5);
	thread sound::play_in_space(level.sound_shock_tabun_stop, position);
	wait(0.5);
	tabunShockSound notify("delete");
	tabunShockSound delete();
	self show_hud();
	self stopPoisoning();
	self.inPoisonArea = 0;
}

/*
	Name: deleteEntOnOwnerDeath
	Namespace: tabun
	Checksum: 0x874B0FE4
	Offset: 0x1180
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function deleteEntOnOwnerDeath(owner)
{
	self endon("delete");
	owner waittill("death");
	self delete();
}

/*
	Name: watch_death
	Namespace: tabun
	Checksum: 0xAE128989
	Offset: 0x11C8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function watch_death()
{
	self waittill("death");
	self show_hud();
}

/*
	Name: hide_hud
	Namespace: tabun
	Checksum: 0x5F3C9081
	Offset: 0x11F8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function hide_hud()
{
	self util::show_hud(0);
}

/*
	Name: show_hud
	Namespace: tabun
	Checksum: 0x4323A513
	Offset: 0x1220
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function show_hud()
{
	self util::show_hud(1);
}

/*
	Name: generateLocations
	Namespace: tabun
	Checksum: 0xE0A0BAA
	Offset: 0x1248
	Size: 0xCB
	Parameters: 2
	Flags: None
*/
function generateLocations(position, owner)
{
	oneFoot = VectorScale((0, 0, 1), 12);
	startPos = position + oneFoot;
	/#
		level.tabun_debug = GetDvarInt("Dev Block strings are not supported", 0);
		if(level.tabun_debug)
		{
			black = VectorScale((1, 1, 1), 0.2);
			debugstar(startPos, 2000, black);
		}
	#/
	spawnAllLocs(owner, startPos);
}

/*
	Name: singleLocation
	Namespace: tabun
	Checksum: 0x75D904FF
	Offset: 0x1320
	Size: 0xCB
	Parameters: 2
	Flags: None
*/
function singleLocation(position, owner)
{
	SpawnTimedFX(level.fx_tabun_single, position);
	killCamEnt = spawn("script_model", position + VectorScale((0, 0, 1), 60));
	killCamEnt util::deleteAfterTime(15);
	killCamEnt.startTime = GetTime();
	damageEffectArea(owner, position, level.tabunGasPoisonRadius, level.tabunGasPoisonHeight, killCamEnt);
}

/*
	Name: hitPos
	Namespace: tabun
	Checksum: 0xA81E5806
	Offset: 0x13F8
	Size: 0xD7
	Parameters: 3
	Flags: None
*/
function hitPos(start, end, color)
{
	trace = bullettrace(start, end, 0, undefined);
	/#
		level.tabun_debug = GetDvarInt("Dev Block strings are not supported", 0);
		if(level.tabun_debug)
		{
			debugstar(trace["Dev Block strings are not supported"], 2000, color);
		}
		thread tabun_debug_line(start, trace["Dev Block strings are not supported"], color, 1, 80);
	#/
	return trace["position"];
}

/*
	Name: spawnAllLocs
	Namespace: tabun
	Checksum: 0x6533DE4F
	Offset: 0x14D8
	Size: 0x975
	Parameters: 2
	Flags: None
*/
function spawnAllLocs(owner, startPos)
{
	defaultDistance = GetDvarInt("scr_defaultDistanceTabun", 220);
	cos45 = 0.707;
	negCos45 = -0.707;
	red = (0.9, 0.2, 0.2);
	blue = (0.2, 0.2, 0.9);
	green = (0.2, 0.9, 0.2);
	white = VectorScale((1, 1, 1), 0.9);
	north = startPos + (defaultDistance, 0, 0);
	south = startPos - (defaultDistance, 0, 0);
	east = startPos + (0, defaultDistance, 0);
	west = startPos - (0, defaultDistance, 0);
	nw = startPos + (cos45 * defaultDistance, negCos45 * defaultDistance, 0);
	ne = startPos + (cos45 * defaultDistance, cos45 * defaultDistance, 0);
	sw = startPos + (negCos45 * defaultDistance, negCos45 * defaultDistance, 0);
	se = startPos + (negCos45 * defaultDistance, cos45 * defaultDistance, 0);
	locations = [];
	locations["color"] = [];
	locations["loc"] = [];
	locations["tracePos"] = [];
	locations["distSqrd"] = [];
	locations["fxtoplay"] = [];
	locations["radius"] = [];
	locations["color"][0] = red;
	locations["color"][1] = red;
	locations["color"][2] = blue;
	locations["color"][3] = blue;
	locations["color"][4] = green;
	locations["color"][5] = green;
	locations["color"][6] = white;
	locations["color"][7] = white;
	locations["point"][0] = north;
	locations["point"][1] = ne;
	locations["point"][2] = east;
	locations["point"][3] = se;
	locations["point"][4] = south;
	locations["point"][5] = sw;
	locations["point"][6] = west;
	locations["point"][7] = nw;
	for(count = 0; count < 8; count++)
	{
		trace = hitPos(startPos, locations["point"][count], locations["color"][count]);
		locations["tracePos"][count] = trace;
		locations["loc"][count] = startPos / 2 + trace / 2;
		locations["loc"][count] = locations["loc"][count] - VectorScale((0, 0, 1), 12);
		locations["distSqrd"][count] = DistanceSquared(startPos, trace);
	}
	centroid = getCenterOfLocations(locations);
	killCamEnt = spawn("script_model", centroid + VectorScale((0, 0, 1), 60));
	killCamEnt util::deleteAfterTime(15);
	killCamEnt.startTime = GetTime();
	center = getcenter(locations);
	for(i = 0; i < 8; i++)
	{
		fxToPlay = setUpTabunFx(owner, locations, i);
		switch(fxToPlay)
		{
			case 0:
			{
				locations["fxtoplay"][i] = level.fx_tabun_0;
				locations["radius"][i] = level.fx_tabun_radius0;
				break;
			}
			case 1:
			{
				locations["fxtoplay"][i] = level.fx_tabun_1;
				locations["radius"][i] = level.fx_tabun_radius1;
				break;
			}
			case 2:
			{
				locations["fxtoplay"][i] = level.fx_tabun_2;
				locations["radius"][i] = level.fx_tabun_radius2;
				break;
			}
			case 3:
			{
				locations["fxtoplay"][i] = level.fx_tabun_3;
				locations["radius"][i] = level.fx_tabun_radius3;
				break;
			}
			case default:
			{
				locations["fxtoplay"][i] = undefined;
				locations["radius"][i] = 0;
			}
		}
	}
	singleEffect = 1;
	freepassUsed = 0;
	for(i = 0; i < 8; i++)
	{
		if(locations["radius"][i] != level.fx_tabun_radius0)
		{
			if(freepassUsed == 0 && locations["radius"][i] == level.fx_tabun_radius1)
			{
				freepassUsed = 1;
				continue;
			}
			singleEffect = 0;
		}
	}
	oneFoot = VectorScale((0, 0, 1), 12);
	startPos = startPos - oneFoot;
	thread playTabunSound(startPos);
	if(singleEffect == 1)
	{
		singleLocation(startPos, owner);
		break;
	}
	SpawnTimedFX(level.fx_tabun_3, startPos);
	for(count = 0; count < 8; count++)
	{
		if(isdefined(locations["fxtoplay"][count]))
		{
			SpawnTimedFX(locations["fxtoplay"][count], locations["loc"][count]);
			thread damageEffectArea(owner, locations["loc"][count], locations["radius"][count], locations["radius"][count], killCamEnt);
		}
	}
}

/*
	Name: playTabunSound
	Namespace: tabun
	Checksum: 0xAC500C34
	Offset: 0x1E58
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function playTabunSound(position)
{
	tabunSound = spawn("script_origin", (0, 0, 1));
	tabunSound.origin = position;
	tabunSound playsound(level.sound_tabun_start);
	tabunSound PlayLoopSound(level.sound_tabun_loop);
	wait(level.tabunGasDuration);
	thread sound::play_in_space(level.sound_tabun_stop, position);
	tabunSound StopLoopSound(0.5);
	wait(0.5);
	tabunSound delete();
}

/*
	Name: setUpTabunFx
	Namespace: tabun
	Checksum: 0xFB735030
	Offset: 0x1F58
	Size: 0x2E1
	Parameters: 3
	Flags: None
*/
function setUpTabunFx(owner, locations, count)
{
	fxToPlay = undefined;
	previous = count - 1;
	if(previous < 0)
	{
		previous = previous + locations["loc"].size;
	}
	next = count + 1;
	if(next >= locations["loc"].size)
	{
		next = next - locations["loc"].size;
	}
	effect0Dist = level.fx_tabun_radius0 * level.fx_tabun_radius0;
	effect1Dist = level.fx_tabun_radius1 * level.fx_tabun_radius1;
	effect2Dist = level.fx_tabun_radius2 * level.fx_tabun_radius2;
	effect3Dist = level.fx_tabun_radius3 * level.fx_tabun_radius3;
	effect4Dist = level.fx_tabun_radius3;
	fxToPlay = -1;
	if(locations["distSqrd"][count] > effect0Dist && locations["distSqrd"][previous] > effect1Dist && locations["distSqrd"][next] > effect1Dist)
	{
		fxToPlay = 0;
	}
	else if(locations["distSqrd"][count] > effect1Dist && locations["distSqrd"][previous] > effect2Dist && locations["distSqrd"][next] > effect2Dist)
	{
		fxToPlay = 1;
	}
	else if(locations["distSqrd"][count] > effect2Dist && locations["distSqrd"][previous] > effect3Dist && locations["distSqrd"][next] > effect3Dist)
	{
		fxToPlay = 2;
	}
	else if(locations["distSqrd"][count] > effect3Dist && locations["distSqrd"][previous] > effect4Dist && locations["distSqrd"][next] > effect4Dist)
	{
		fxToPlay = 3;
	}
	return fxToPlay;
}

/*
	Name: getCenterOfLocations
	Namespace: tabun
	Checksum: 0xE3929658
	Offset: 0x2248
	Size: 0xFF
	Parameters: 1
	Flags: None
*/
function getCenterOfLocations(locations)
{
	centroid = (0, 0, 0);
	for(i = 0; i < locations["loc"].size; i++)
	{
		centroid = centroid + locations["loc"][i] / locations["loc"].size;
	}
	/#
		level.tabun_debug = GetDvarInt("Dev Block strings are not supported", 0);
		if(level.tabun_debug)
		{
			purple = (0.9, 0.2, 0.9);
			debugstar(centroid, 2000, purple);
		}
	#/
	return centroid;
}

/*
	Name: getcenter
	Namespace: tabun
	Checksum: 0x9192584C
	Offset: 0x2350
	Size: 0x267
	Parameters: 1
	Flags: None
*/
function getcenter(locations)
{
	center = (0, 0, 0);
	curX = locations["tracePos"][0][0];
	curY = locations["tracePos"][0][1];
	minX = curX;
	maxX = curX;
	minY = curY;
	maxy = curY;
	for(i = 1; i < locations["tracePos"].size; i++)
	{
		curX = locations["tracePos"][i][0];
		curY = locations["tracePos"][i][1];
		if(curX > maxX)
		{
			maxX = curX;
		}
		else if(curX < minX)
		{
			minX = curX;
		}
		if(curY > maxy)
		{
			maxy = curY;
			continue;
		}
		if(curY < minY)
		{
			minY = curY;
		}
	}
	avgX = maxX + minX / 2;
	avgY = maxy + minY / 2;
	center = (avgX, avgY, locations["tracePos"][0][2]);
	/#
		level.tabun_debug = GetDvarInt("Dev Block strings are not supported", 0);
		if(level.tabun_debug)
		{
			cyan = (0.2, 0.9, 0.9);
			debugstar(center, 2000, cyan);
		}
	#/
	return center;
}

/*
	Name: tabun_debug_line
	Namespace: tabun
	Checksum: 0x93C5B9BC
	Offset: 0x25C0
	Size: 0xBB
	Parameters: 5
	Flags: None
*/
function tabun_debug_line(from, to, color, depthTest, time)
{
	/#
		debug_rcbomb = GetDvarInt("Dev Block strings are not supported", 0);
		if(debug_rcbomb == "Dev Block strings are not supported")
		{
			if(!isdefined(time))
			{
				time = 100;
			}
			if(!isdefined(depthTest))
			{
				depthTest = 1;
			}
			line(from, to, color, 1, depthTest, time);
		}
	#/
}

