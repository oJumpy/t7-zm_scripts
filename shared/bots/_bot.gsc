#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot_combat;
#using scripts\shared\bots\bot_buttons;
#using scripts\shared\bots\bot_traversals;
#using scripts\shared\callbacks_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace bot;

/*
	Name: __init__sytem__
	Namespace: bot
	Checksum: 0xD24E8FB0
	Offset: 0x3D8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("bot", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: bot
	Checksum: 0xCDD1D3B8
	Offset: 0x418
	Size: 0x2DB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_start_gametype(&init);
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	callback::on_player_killed(&on_player_killed);
	if(!isdefined(level.getBotSettings))
	{
		level.getBotSettings = &get_bot_default_settings;
	}
	if(!isdefined(level.onBotRemove))
	{
		level.onBotRemove = &bot_void;
	}
	if(!isdefined(level.onBotConnect))
	{
		level.onBotConnect = &bot_void;
	}
	if(!isdefined(level.onBotSpawned))
	{
		level.onBotSpawned = &bot_void;
	}
	if(!isdefined(level.onBotKilled))
	{
		level.onBotKilled = &bot_void;
	}
	if(!isdefined(level.onBotDamage))
	{
		level.onBotDamage = &bot_void;
	}
	if(!isdefined(level.botUpdate))
	{
		level.botUpdate = &bot_update;
	}
	if(!isdefined(level.botPreCombat))
	{
		level.botPreCombat = &bot_void;
	}
	if(!isdefined(level.botCombat))
	{
		level.botCombat = &bot_combat::combat_think;
	}
	if(!isdefined(level.botPostCombat))
	{
		level.botPostCombat = &bot_void;
	}
	if(!isdefined(level.botIdle))
	{
		level.botIdle = &bot_void;
	}
	if(!isdefined(level.botThreatDead))
	{
		level.botThreatDead = &bot_combat::clear_threat;
	}
	if(!isdefined(level.botThreatEngage))
	{
		level.botThreatEngage = &bot_combat::engage_threat;
	}
	if(!isdefined(level.botUpdateThreatGoal))
	{
		level.botUpdateThreatGoal = &bot_combat::update_threat_goal;
	}
	if(!isdefined(level.botThreatLost))
	{
		level.botThreatLost = &bot_combat::clear_threat;
	}
	if(!isdefined(level.botGetThreats))
	{
		level.botGetThreats = &bot_combat::get_bot_threats;
	}
	if(!isdefined(level.botIgnoreThreat))
	{
		level.botIgnoreThreat = &bot_combat::ignore_non_sentient;
	}
	SetDvar("bot_maxMantleHeight", 200);
	/#
		level thread bot_devgui_think();
	#/
}

/*
	Name: init
	Namespace: bot
	Checksum: 0x40462943
	Offset: 0x700
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function init()
{
	init_bot_settings();
}

/*
	Name: is_bot_ranked_match
	Namespace: bot
	Checksum: 0xE404801D
	Offset: 0x720
	Size: 0x5
	Parameters: 0
	Flags: None
*/
function is_bot_ranked_match()
{
	return 0;
}

/*
	Name: bot_void
	Namespace: bot
	Checksum: 0x99EC1590
	Offset: 0x730
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function bot_void()
{
}

/*
	Name: bot_unhandled
	Namespace: bot
	Checksum: 0x4AA714A7
	Offset: 0x740
	Size: 0x5
	Parameters: 0
	Flags: None
*/
function bot_unhandled()
{
	return 0;
}

/*
	Name: add_bots
	Namespace: bot
	Checksum: 0xD1C99D13
	Offset: 0x750
	Size: 0x55
	Parameters: 2
	Flags: None
*/
function add_bots(count, team)
{
	for(i = 0; i < count; i++)
	{
		add_bot(team);
	}
}

/*
	Name: add_bot
	Namespace: bot
	Checksum: 0xC535196A
	Offset: 0x7B0
	Size: 0xD1
	Parameters: 1
	Flags: None
*/
function add_bot(team)
{
	botEnt = AddTestClient();
	if(!isdefined(botEnt))
	{
		return undefined;
	}
	botEnt BotSetRandomCharacterCustomization();
	if(isdefined(level.disableClassSelection) && level.disableClassSelection)
	{
		botEnt.pers["class"] = level.defaultClass;
		botEnt.curClass = level.defaultClass;
	}
	if(level.teambased && team !== "autoassign")
	{
		botEnt.pers["team"] = team;
	}
	return botEnt;
}

/*
	Name: remove_bots
	Namespace: bot
	Checksum: 0xCD6DF001
	Offset: 0x890
	Size: 0x111
	Parameters: 2
	Flags: None
*/
function remove_bots(count, team)
{
	players = GetPlayers();
	foreach(player in players)
	{
		if(!player IsTestClient())
		{
			continue;
		}
		if(isdefined(team) && player.team != team)
		{
			continue;
		}
		remove_bot(player);
		if(isdefined(count))
		{
			count--;
			if(count <= 0)
			{
				break;
			}
		}
	}
}

/*
	Name: remove_bot
	Namespace: bot
	Checksum: 0x89FE72DD
	Offset: 0x9B0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function remove_bot(bot)
{
	if(!bot IsTestClient())
	{
		return;
	}
	bot [[level.onBotRemove]]();
	bot BotDropClient();
}

/*
	Name: filter_bots
	Namespace: bot
	Checksum: 0x66B013FC
	Offset: 0xA10
	Size: 0xB9
	Parameters: 1
	Flags: None
*/
function filter_bots(players)
{
	bots = [];
	foreach(player in players)
	{
		if(player util::is_bot())
		{
			bots[bots.size] = player;
		}
	}
	return bots;
}

/*
	Name: on_player_connect
	Namespace: bot
	Checksum: 0xCA8F5DAC
	Offset: 0xAD8
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	if(!self IsTestClient())
	{
		return;
	}
	self endon("disconnect");
	self.bot = spawnstruct();
	self.bot.threat = spawnstruct();
	self.bot.damage = spawnstruct();
	self.pers["isBot"] = 1;
	if(level.teambased)
	{
		self notify("menuresponse", game["menu_team"], self.team);
		wait(0.5);
	}
	self notify("joined_team");
	callback::callback("hash_95a6c4c0");
	self thread [[level.onBotConnect]]();
}

/*
	Name: on_player_spawned
	Namespace: bot
	Checksum: 0xBA949B8D
	Offset: 0xBE8
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	if(!self util::is_bot())
	{
		return;
	}
	self clear_stuck();
	self bot_combat::clear_threat();
	self.bot.prevWeapon = undefined;
	self BotLookForward();
	self thread [[level.onBotSpawned]]();
	self thread bot_combat::wait_damage_loop();
	self thread wait_bot_path_failed_loop();
	self thread wait_bot_goal_reached_loop();
	self thread bot_think_loop();
}

/*
	Name: on_player_killed
	Namespace: bot
	Checksum: 0x8F8A5E9
	Offset: 0xCD0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function on_player_killed()
{
	if(!self util::is_bot())
	{
		return;
	}
	self thread [[level.onBotKilled]]();
	self BotReleaseManualControl();
}

/*
	Name: bot_think_loop
	Namespace: bot
	Checksum: 0x8D6BE3A8
	Offset: 0xD20
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function bot_think_loop()
{
	self endon("death");
	level endon("game_ended");
	while(1)
	{
		self bot_think();
		wait(level.botSettings.thinkInterval);
	}
}

/*
	Name: bot_think
	Namespace: bot
	Checksum: 0x5B437328
	Offset: 0xD70
	Size: 0x10F
	Parameters: 0
	Flags: None
*/
function bot_think()
{
	self BotReleaseButtons();
	if(level.inPrematchPeriod || level.gameEnded || !isalive(self))
	{
		return;
	}
	self check_stuck();
	self sprint_think();
	self update_swim();
	self thread [[level.botUpdate]]();
	self thread [[level.botPreCombat]]();
	self thread [[level.botCombat]]();
	self thread [[level.botPostCombat]]();
	if(!self bot_combat::has_threat() && !self BotGoalSet())
	{
		self thread [[level.botIdle]]();
	}
}

/*
	Name: bot_update
	Namespace: bot
	Checksum: 0x99EC1590
	Offset: 0xE88
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function bot_update()
{
}

/*
	Name: update_swim
	Namespace: bot
	Checksum: 0xDD977F64
	Offset: 0xE98
	Size: 0x2BB
	Parameters: 0
	Flags: None
*/
function update_swim()
{
	if(!self IsPlayerSwimming())
	{
		self.bot.resurfaceTime = undefined;
		return;
	}
	if(self IsPlayerUnderwater())
	{
		if(!isdefined(self.bot.resurfaceTime))
		{
			self.bot.resurfaceTime = GetTime() + level.botSettings.swimTime;
		}
	}
	else
	{
		self.bot.resurfaceTime = undefined;
	}
	if(self BotUnderManualControl())
	{
		return;
	}
	goalPosition = self BotGetGoalPosition();
	if(Distance2DSquared(goalPosition, self.origin) <= 16384 && GetWaterHeight(goalPosition) > 0)
	{
		self press_swim_down();
		return;
	}
	if(isdefined(self.bot.resurfaceTime) && self.bot.resurfaceTime <= GetTime())
	{
		press_swim_up();
		return;
	}
	bottomTrace = GroundTrace(self.origin, self.origin + VectorScale((0, 0, -1), 1000), 0, self, 1);
	swimHeight = self.origin[2] - bottomTrace["position"][2];
	if(swimHeight < 25)
	{
		self press_swim_up();
		vertDist = 25 - swimHeight;
	}
	else if(swimHeight > 45)
	{
		self press_swim_down();
		vertDist = swimHeight - 45;
	}
	if(isdefined(vertDist))
	{
		intervalDist = level.botSettings.swimVerticalSpeed * level.botSettings.thinkInterval;
		if(intervalDist > vertDist)
		{
			self wait_release_swim_buttons(level.botSettings.thinkInterval * vertDist / intervalDist);
		}
	}
}

/*
	Name: wait_release_swim_buttons
	Namespace: bot
	Checksum: 0x3D46EB
	Offset: 0x1160
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function wait_release_swim_buttons(waitTime)
{
	self endon("death");
	level endon("game_ended");
	wait(waitTime);
	self release_swim_up();
	self release_swim_down();
}

/*
	Name: init_bot_settings
	Namespace: bot
	Checksum: 0xB6CC53AB
	Offset: 0x11C0
	Size: 0x687
	Parameters: 0
	Flags: None
*/
function init_bot_settings()
{
	level.botSettings = [[level.getBotSettings]]();
	if(isdefined(level.botSettings.AllowMelee))
	{
	}
	else
	{
	}
	SetDvar("bot_AllowMelee", 0);
	if(isdefined(level.botSettings.allowGrenades))
	{
	}
	else
	{
	}
	SetDvar("bot_AllowGrenades", 0);
	if(isdefined(level.botSettings.allowKillstreaks))
	{
	}
	else
	{
	}
	SetDvar("bot_AllowKillstreaks", 0);
	if(isdefined(level.botSettings.allowHeroGadgets))
	{
	}
	else
	{
	}
	SetDvar("bot_AllowHeroGadgets", 0);
	if(isdefined(level.botSettings.fov))
	{
	}
	else
	{
	}
	SetDvar("bot_Fov", 0);
	if(isdefined(level.botSettings.fovAds))
	{
	}
	else
	{
	}
	SetDvar("bot_FovAds", 0);
	SetDvar("bot_PitchSensitivity", level.botSettings.pitchSensitivity);
	SetDvar("bot_YawSensitivity", level.botSettings.yawSensitivity);
	if(isdefined(level.botSettings.pitchSpeed))
	{
	}
	else
	{
	}
	SetDvar("bot_PitchSpeed", 0);
	if(isdefined(level.botSettings.pitchSpeedAds))
	{
	}
	else
	{
	}
	SetDvar("bot_PitchSpeedAds", 0);
	if(isdefined(level.botSettings.yawSpeed))
	{
	}
	else
	{
	}
	SetDvar("bot_YawSpeed", 0);
	if(isdefined(level.botSettings.yawSpeedAds))
	{
	}
	else
	{
	}
	SetDvar("bot_YawSpeedAds", 0);
	if(isdefined(level.botSettings.pitchAccelerationTime))
	{
	}
	else
	{
	}
	SetDvar("pitchAccelerationTime", 0);
	if(isdefined(level.botSettings.yawAccelerationTime))
	{
	}
	else
	{
	}
	SetDvar("yawAccelerationTime", 0);
	if(isdefined(level.botSettings.pitchDecelerationThreshold))
	{
	}
	else
	{
	}
	SetDvar("pitchDecelerationThreshold", 0);
	if(isdefined(level.botSettings.yawDecelerationThreshold))
	{
	}
	else
	{
	}
	SetDvar("yawDecelerationThreshold", 0);
	if(isdefined(level.botSettings.meleeRangeMultiplier))
	{
	}
	else
	{
	}
	meleeRange = level.botSettings.meleeRangeMultiplier * 0;
	level.botSettings.meleeRange = Int(meleeRange);
	level.botSettings.meleeRangeSq = meleeRange * meleeRange;
	level.botSettings.threatRadiusMinSq = level.botSettings.threatRadiusMin * level.botSettings.threatRadiusMin;
	level.botSettings.threatRadiusMaxSq = level.botSettings.threatRadiusMax * level.botSettings.threatRadiusMax;
	if(isdefined(level.botSettings.lethalDistanceMin))
	{
	}
	else
	{
	}
	lethalDistanceMin = 0;
	level.botSettings.lethalDistanceMinSq = lethalDistanceMin * lethalDistanceMin;
	if(isdefined(level.botSettings.lethalDistanceMax))
	{
	}
	else
	{
	}
	lethalDistanceMax = 1024;
	level.botSettings.lethalDistanceMaxSq = lethalDistanceMax * lethalDistanceMax;
	if(isdefined(level.botSettings.tacticalDistanceMin))
	{
	}
	else
	{
	}
	tacticalDistanceMin = 0;
	level.botSettings.tacticalDistanceMinSq = tacticalDistanceMin * tacticalDistanceMin;
	if(isdefined(level.botSettings.tacticalDistanceMax))
	{
	}
	else
	{
	}
	tacticalDistanceMax = 1024;
	level.botSettings.tacticalDistanceMaxSq = tacticalDistanceMax * tacticalDistanceMax;
	level.botSettings.swimVerticalSpeed = GetDvarFloat("player_swimVerticalSpeedMax");
	level.botSettings.swimTime = GetDvarFloat("player_swimTime", 5) * 1000;
}

/*
	Name: get_bot_default_settings
	Namespace: bot
	Checksum: 0xF73A4A26
	Offset: 0x1850
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function get_bot_default_settings()
{
	return struct::get_script_bundle("botsettings", "bot_default");
}

/*
	Name: sprint_to_goal
	Namespace: bot
	Checksum: 0x11C741FD
	Offset: 0x1880
	Size: 0x17
	Parameters: 0
	Flags: None
*/
function sprint_to_goal()
{
	self.bot.sprintToGoal = 1;
}

/*
	Name: end_sprint_to_goal
	Namespace: bot
	Checksum: 0x8838991
	Offset: 0x18A0
	Size: 0x17
	Parameters: 0
	Flags: None
*/
function end_sprint_to_goal()
{
	self.bot.sprintToGoal = 0;
}

/*
	Name: sprint_think
	Namespace: bot
	Checksum: 0xFDF326D5
	Offset: 0x18C0
	Size: 0x6D
	Parameters: 0
	Flags: None
*/
function sprint_think()
{
	if(isdefined(self.bot.sprintToGoal) && self.bot.sprintToGoal)
	{
		if(self BotGoalReached())
		{
			self end_sprint_to_goal();
			return;
		}
		self press_sprint_button();
		return;
	}
}

/*
	Name: goal_in_trigger
	Namespace: bot
	Checksum: 0x16D86964
	Offset: 0x1938
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function goal_in_trigger(trigger)
{
	radius = self get_trigger_radius(trigger);
	return DistanceSquared(trigger.origin, self BotGetGoalPosition()) <= radius * radius;
}

/*
	Name: point_in_goal
	Namespace: bot
	Checksum: 0x8F819DD0
	Offset: 0x19A8
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function point_in_goal(point)
{
	deltaSq = Distance2DSquared(self BotGetGoalPosition(), point);
	goalRadius = self BotGetGoalRadius();
	return deltaSq <= goalRadius * goalRadius;
}

/*
	Name: path_to_trigger
	Namespace: bot
	Checksum: 0xEA05BB9
	Offset: 0x1A20
	Size: 0x14B
	Parameters: 2
	Flags: None
*/
function path_to_trigger(trigger, radius)
{
	if(trigger.classname == "trigger_use" || trigger.classname == "trigger_use_touch")
	{
		if(!isdefined(radius))
		{
			radius = get_trigger_radius(trigger);
		}
		randomAngle = (0, RandomInt(360), 0);
		randomVec = AnglesToForward(randomAngle);
		point = trigger.origin + randomVec * radius;
		self BotSetGoal(point);
	}
	if(!isdefined(radius))
	{
		radius = 0;
	}
	self BotSetGoal(trigger.origin, Int(radius));
}

/*
	Name: path_to_point_in_trigger
	Namespace: bot
	Checksum: 0x21D2C2AA
	Offset: 0x1B78
	Size: 0x33B
	Parameters: 1
	Flags: None
*/
function path_to_point_in_trigger(trigger)
{
	mins = trigger GetMins();
	maxs = trigger GetMaxs();
	radius = min(maxs[0], maxs[1]);
	height = maxs[2] - mins[2];
	minOrigin = trigger.origin + (0, 0, mins[2]);
	queryHeight = height / 4;
	queryOrigin = minOrigin + (0, 0, queryHeight);
	/#
		if(GetDvarInt("Dev Block strings are not supported", 0))
		{
			Draws = 10;
			circle(queryOrigin, radius, (0, 1, 0), 0, 1, 20 * Draws);
			circle(queryOrigin + (0, 0, queryHeight), radius, (0, 1, 0), 0, 1, 20 * Draws);
			circle(queryOrigin - (0, 0, queryHeight), radius, (0, 1, 0), 0, 1, 20 * Draws);
		}
	#/
	queryResult = PositionQuery_Source_Navigation(queryOrigin, 0, radius, queryHeight, 17, self);
	best_point = undefined;
	foreach(point in queryResult.data)
	{
		point.score = RandomFloatRange(0, 100);
		if(!isdefined(best_point) || point.score > best_point.score)
		{
			best_point = point;
		}
	}
	if(isdefined(best_point))
	{
		self BotSetGoal(best_point.origin, 24);
		return;
	}
	self path_to_trigger(trigger, radius);
}

/*
	Name: get_trigger_radius
	Namespace: bot
	Checksum: 0x7B6C1CE3
	Offset: 0x1EC0
	Size: 0x79
	Parameters: 1
	Flags: None
*/
function get_trigger_radius(trigger)
{
	maxs = trigger GetMaxs();
	if(trigger.classname == "trigger_radius")
	{
		return maxs[0];
	}
	return min(maxs[0], maxs[1]);
}

/*
	Name: get_trigger_height
	Namespace: bot
	Checksum: 0xE5DFA0B
	Offset: 0x1F48
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function get_trigger_height(trigger)
{
	maxs = trigger GetMaxs();
	if(trigger.classname == "trigger_radius")
	{
		return maxs[2];
	}
	return maxs[2] * 2;
}

/*
	Name: check_stuck
	Namespace: bot
	Checksum: 0x54016300
	Offset: 0x1FB8
	Size: 0x283
	Parameters: 0
	Flags: None
*/
function check_stuck()
{
	/#
		if(!GetDvarInt("Dev Block strings are not supported"))
		{
			return;
		}
	#/
	if(self BotUnderManualControl() || self BotGoalReached() || self util::isStunned() || self IsMeleeing() || self meleeButtonPressed() || (self bot_combat::has_threat() && self.bot.threat.lastDistanceSq < 16384))
	{
		return;
	}
	velocity = self GetVelocity();
	if(velocity[0] == 0 && velocity[1] == 0 && (velocity[2] == 0 || self IsPlayerSwimming()))
	{
		if(!isdefined(self.bot.stuckCycles))
		{
			self.bot.stuckCycles = 0;
		}
		self.bot.stuckCycles++;
		if(self.bot.stuckCycles >= 3)
		{
			/#
				if(GetDvarInt("Dev Block strings are not supported", 0))
				{
					sphere(self.origin, 16, (1, 0, 0), 0.25, 0, 16, 1200);
					iprintln("Dev Block strings are not supported" + self.name + "Dev Block strings are not supported" + self.origin);
				}
			#/
			self thread stuck_resolution();
		}
	}
	else
	{
		self.bot.stuckCycles = 0;
	}
	if(!self bot_combat::threat_visible())
	{
		self check_stuck_position();
	}
}

/*
	Name: check_stuck_position
	Namespace: bot
	Checksum: 0x341D4ADC
	Offset: 0x2248
	Size: 0x2AB
	Parameters: 0
	Flags: None
*/
function check_stuck_position()
{
	if(GetTime() < self.bot.checkPositionTime)
	{
		return;
	}
	self.bot.checkPositionTime = GetTime() + 500;
	self.bot.positionHistory[self.bot.positionHistoryIndex] = self.origin;
	self.bot.positionHistoryIndex = self.bot.positionHistoryIndex + 1 % 5;
	if(self.bot.positionHistory.size < 5)
	{
		return;
	}
	maxDistSq = undefined;
	for(i = 0; i < self.bot.positionHistory.size; i++)
	{
		/#
			if(GetDvarInt("Dev Block strings are not supported", 0))
			{
				line(self.bot.positionHistory[i], self.bot.positionHistory[i] + VectorScale((0, 0, 1), 72), (0, 1, 0), 1, 0, 10);
			}
		#/
		for(j = i + 1; j < self.bot.positionHistory.size; j++)
		{
			distSq = DistanceSquared(self.bot.positionHistory[i], self.bot.positionHistory[j]);
			if(distSq > 16384)
			{
				return;
			}
		}
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported", 0))
		{
			sphere(self.origin, 128, (1, 0, 0), 0.25, 0, 16, 1200);
			iprintln("Dev Block strings are not supported" + self.name + "Dev Block strings are not supported" + self.origin);
		}
	#/
	self thread stuck_resolution();
}

/*
	Name: stuck_resolution
	Namespace: bot
	Checksum: 0xEBA93359
	Offset: 0x2500
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function stuck_resolution()
{
	self endon("death");
	level endon("game_ended");
	self clear_stuck();
	self BotTakeManualControl();
	escapeAngle = self GetAngles()[1] + 180 + randomIntRange(-60, 60);
	escapeDir = AnglesToForward((0, escapeAngle, 0));
	self BotSetMoveAngle(escapeDir);
	self BotSetMoveMagnitude(1);
	wait(1.5);
	self BotReleaseManualControl();
}

/*
	Name: clear_stuck
	Namespace: bot
	Checksum: 0xDC719305
	Offset: 0x2610
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function clear_stuck()
{
	self.bot.stuckCycles = 0;
	self.bot.positionHistory = [];
	self.bot.positionHistoryIndex = 0;
	self.bot.checkPositionTime = 0;
}

/*
	Name: camp
	Namespace: bot
	Checksum: 0xC993C7F5
	Offset: 0x2670
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function camp()
{
	self BotSetGoal(self.origin);
	self press_crouch_button();
}

/*
	Name: wait_bot_path_failed_loop
	Namespace: bot
	Checksum: 0x7DC91E22
	Offset: 0x26B8
	Size: 0x18F
	Parameters: 0
	Flags: None
*/
function wait_bot_path_failed_loop()
{
	self endon("death");
	level endon("game_ended");
	while(1)
	{
		self waittill("bot_path_failed", reason);
		/#
			if(GetDvarInt("Dev Block strings are not supported", 0))
			{
				goalPosition = self BotGetGoalPosition();
				box(self.origin, VectorScale((-1, -1, 0), 15), (15, 15, 72), 0, (0, 1, 0), 0.25, 0, 1200);
				box(goalPosition, VectorScale((-1, -1, 0), 15), (15, 15, 72), 0, (1, 0, 0), 0.25, 0, 1200);
				line(self.origin, goalPosition, (1, 1, 1), 1, 0, 1200);
				iprintln("Dev Block strings are not supported" + self.name + "Dev Block strings are not supported" + self.origin + "Dev Block strings are not supported" + goalPosition);
			}
		#/
		self thread stuck_resolution();
	}
}

/*
	Name: wait_bot_goal_reached_loop
	Namespace: bot
	Checksum: 0x1D52E868
	Offset: 0x2850
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function wait_bot_goal_reached_loop()
{
	self endon("death");
	level endon("game_ended");
	while(1)
	{
		self waittill("bot_goal_reached", reason);
		self clear_stuck();
	}
}

/*
	Name: stow_gun_gadget
	Namespace: bot
	Checksum: 0xC9B3CC76
	Offset: 0x28B0
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function stow_gun_gadget()
{
	currentWeapon = self GetCurrentWeapon();
	if(self GetWeaponAmmoClip(currentWeapon) || !currentWeapon.isHeroWeapon)
	{
		return;
	}
	if(isdefined(self.lastdroppableweapon) && self HasWeapon(self.lastdroppableweapon))
	{
		self SwitchToWeapon(self.lastdroppableweapon);
	}
}

/*
	Name: get_ready_gadget
	Namespace: bot
	Checksum: 0x8B3C430E
	Offset: 0x2960
	Size: 0x115
	Parameters: 0
	Flags: None
*/
function get_ready_gadget()
{
	weapons = self GetWeaponsList();
	foreach(weapon in weapons)
	{
		slot = self GadgetGetSlot(weapon);
		if(slot < 0 || !self GadgetIsReady(slot) || self GadgetIsActive(slot))
		{
			continue;
		}
		return weapon;
	}
	return level.weaponNone;
}

/*
	Name: get_ready_gun_gadget
	Namespace: bot
	Checksum: 0xB0875F01
	Offset: 0x2A80
	Size: 0x12D
	Parameters: 0
	Flags: None
*/
function get_ready_gun_gadget()
{
	weapons = self GetWeaponsList();
	foreach(weapon in weapons)
	{
		if(!is_gun_gadget(weapon))
		{
			continue;
		}
		slot = self GadgetGetSlot(weapon);
		if(slot < 0 || !self GadgetIsReady(slot) || self GadgetIsActive(slot))
		{
			continue;
		}
		return weapon;
	}
	return level.weaponNone;
}

/*
	Name: is_gun_gadget
	Namespace: bot
	Checksum: 0x3D28D0E7
	Offset: 0x2BB8
	Size: 0x7D
	Parameters: 1
	Flags: None
*/
function is_gun_gadget(weapon)
{
	if(!isdefined(weapon) || weapon == level.weaponNone || !weapon.isHeroWeapon)
	{
		return 0;
	}
	return weapon.isBulletWeapon || weapon.isProjectileWeapon || weapon.isLauncher || weapon.isGasWeapon;
}

/*
	Name: activate_hero_gadget
	Namespace: bot
	Checksum: 0x64966E8B
	Offset: 0x2C40
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function activate_hero_gadget(weapon)
{
	if(!isdefined(weapon) || weapon == level.weaponNone || !weapon.isgadget)
	{
		return;
	}
	if(is_gun_gadget(weapon))
	{
		self SwitchToWeapon(weapon);
	}
	else if(weapon.isHeroWeapon)
	{
		self tap_offhand_special_button();
	}
	else
	{
		self BotPressButtonForGadget(weapon);
	}
}

/*
	Name: coop_pre_combat
	Namespace: bot
	Checksum: 0x7908E56C
	Offset: 0x2D00
	Size: 0x13F
	Parameters: 0
	Flags: None
*/
function coop_pre_combat()
{
	self bot_combat::bot_pre_combat();
	if(self bot_combat::has_threat())
	{
		return;
	}
	if(self IsReloading() || self IsSwitchingWeapons() || self IsThrowingGrenade() || self fragButtonPressed() || self SecondaryOffhandButtonPressed() || self IsMeleeing() || self IsRemoteControlling() || self IsInVehicle() || self IsWeaponViewOnlyLinked())
	{
		return;
	}
	if(self bot_combat::switch_weapon())
	{
		return;
	}
	if(self bot_combat::reload_weapon())
	{
		return;
	}
}

/*
	Name: coop_post_combat
	Namespace: bot
	Checksum: 0x8D061F74
	Offset: 0x2E48
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function coop_post_combat()
{
	if(self revive_players())
	{
		if(self bot_combat::has_threat())
		{
			self bot_combat::clear_threat();
			self BotSetGoal(self.origin);
		}
		return;
	}
	self bot_combat::bot_post_combat();
}

/*
	Name: follow_coop_players
	Namespace: bot
	Checksum: 0x2BE90678
	Offset: 0x2ED8
	Size: 0x1BB
	Parameters: 0
	Flags: None
*/
function follow_coop_players()
{
	host = get_host_player();
	if(!isalive(host))
	{
		players = ArraySort(level.players, self.origin);
		foreach(player in players)
		{
			if(!player util::is_bot() && player.team == self.team && isalive(player))
			{
				break;
			}
		}
	}
	else
	{
		player = host;
	}
	if(isdefined(player))
	{
		fwd = AnglesToForward(player.angles);
		botDir = self.origin - player.origin;
		if(VectorDot(botDir, fwd) < 0)
		{
			self thread lead_player(player, 150);
		}
	}
}

/*
	Name: lead_player
	Namespace: bot
	Checksum: 0x83E1AC9F
	Offset: 0x30A0
	Size: 0x12B
	Parameters: 2
	Flags: None
*/
function lead_player(player, followmin)
{
	radiusMin = followmin - 32;
	radiusMax = followmin;
	dotMin = 0.85;
	dotMax = 0.92;
	queryResult = PositionQuery_Source_Navigation(player.origin, radiusMin, radiusMax, 150, 32, self);
	fwd = AnglesToForward(player.angles);
	point = player.origin + fwd * 72;
	self BotSetGoal(point, 42);
	self sprint_to_goal();
}

/*
	Name: follow_entity
	Namespace: bot
	Checksum: 0xCD932C6
	Offset: 0x31D8
	Size: 0xD3
	Parameters: 3
	Flags: None
*/
function follow_entity(entity, radiusMin, radiusMax)
{
	if(!isdefined(radiusMin))
	{
		radiusMin = 24;
	}
	if(!isdefined(radiusMax))
	{
		radiusMax = radiusMin + 1;
	}
	if(!point_in_goal(entity.origin))
	{
		radius = randomIntRange(radiusMin, radiusMax);
		self BotSetGoal(entity.origin, radius);
		self sprint_to_goal();
	}
}

/*
	Name: navmesh_wander
	Namespace: bot
	Checksum: 0xA7EE6018
	Offset: 0x32B8
	Size: 0x543
	Parameters: 5
	Flags: None
*/
function navmesh_wander(fwd, radiusMin, radiusMax, spacing, fwdDot)
{
	if(!isdefined(radiusMin))
	{
		if(isdefined(level.botSettings.wanderMin))
		{
		}
		else
		{
		}
		radiusMin = 0;
	}
	if(!isdefined(radiusMax))
	{
		if(isdefined(level.botSettings.wanderMax))
		{
		}
		else
		{
		}
		radiusMax = 0;
	}
	if(!isdefined(spacing))
	{
		if(isdefined(level.botSettings.wanderSpacing))
		{
		}
		else
		{
		}
		spacing = 0;
	}
	if(!isdefined(fwdDot))
	{
		if(isdefined(level.botSettings.wanderFwdDot))
		{
		}
		else
		{
		}
		fwdDot = 0;
	}
	if(!isdefined(fwd))
	{
		fwd = AnglesToForward(self.angles);
	}
	fwd = VectorNormalize((fwd[0], fwd[1], 0));
	/#
	#/
	queryResult = PositionQuery_Source_Navigation(self.origin, radiusMin, radiusMax, 150, spacing, self);
	best_point = undefined;
	origin = (self.origin[0], self.origin[1], 0);
	foreach(point in queryResult.data)
	{
		movePoint = (point.origin[0], point.origin[1], 0);
		moveDir = VectorNormalize(movePoint - origin);
		dot = VectorDot(moveDir, fwd);
		point.score = mapfloat(radiusMin, radiusMax, 0, 50, point.distToOrigin2D);
		if(dot > fwdDot)
		{
			point.score = point.score + RandomFloatRange(30, 50);
		}
		else if(dot > 0)
		{
			point.score = point.score + RandomFloatRange(10, 35);
		}
		else
		{
			point.score = point.score + RandomFloatRange(0, 15);
		}
		/#
		#/
		if(!isdefined(best_point) || point.score > best_point.score)
		{
			best_point = point;
		}
	}
	if(isdefined(best_point))
	{
		/#
		#/
		self BotSetGoal(best_point.origin, radiusMin);
	}
	else
	{
		if(GetDvarInt("Dev Block strings are not supported", 0))
		{
			circle(self.origin, radiusMin, (1, 0, 0), 0, 1, 1200);
			circle(self.origin, radiusMax, (1, 0, 0), 0, 1, 1200);
			sphere(self.origin, 16, (0, 1, 0), 0.25, 0, 16, 1200);
			iprintln("Dev Block strings are not supported" + self.name + "Dev Block strings are not supported" + self.origin);
		}
		self thread stuck_resolution();
	}
	/#
	#/
}

/*
	Name: approach_goal_trigger
	Namespace: bot
	Checksum: 0x520B72D7
	Offset: 0x3808
	Size: 0xF3
	Parameters: 3
	Flags: None
*/
function approach_goal_trigger(trigger, radiusMax, spacing)
{
	if(!isdefined(radiusMax))
	{
		radiusMax = 1500;
	}
	if(!isdefined(spacing))
	{
		spacing = 128;
	}
	distSq = DistanceSquared(self.origin, trigger.origin);
	if(distSq < radiusMax * radiusMax)
	{
		self path_to_point_in_trigger(trigger);
		return;
	}
	radiusMin = self get_trigger_radius(trigger);
	self approach_point(trigger.origin, radiusMin, radiusMax, spacing);
}

/*
	Name: approach_point
	Namespace: bot
	Checksum: 0x7A8E2522
	Offset: 0x3908
	Size: 0x37B
	Parameters: 4
	Flags: None
*/
function approach_point(point, radiusMin, radiusMax, spacing)
{
	if(!isdefined(radiusMin))
	{
		radiusMin = 0;
	}
	if(!isdefined(radiusMax))
	{
		radiusMax = 1500;
	}
	if(!isdefined(spacing))
	{
		spacing = 128;
	}
	distSq = DistanceSquared(self.origin, point);
	if(distSq < radiusMax * radiusMax)
	{
		self BotSetGoal(point, 24);
		return;
	}
	queryResult = PositionQuery_Source_Navigation(point, radiusMin, radiusMax, 150, spacing, self);
	fwd = AnglesToForward(self.angles);
	fwd = (fwd[0], fwd[1], 0);
	origin = (self.origin[0], self.origin[1], 0);
	best_point = undefined;
	foreach(point in queryResult.data)
	{
		movePoint = (point.origin[0], point.origin[1], 0);
		moveDir = VectorNormalize(movePoint - origin);
		dot = VectorDot(moveDir, fwd);
		point.score = RandomFloatRange(0, 50);
		if(dot < 0.5)
		{
			point.score = point.score + RandomFloatRange(30, 50);
		}
		else
		{
			point.score = point.score + RandomFloatRange(0, 15);
		}
		if(!isdefined(best_point) || point.score > best_point.score)
		{
			best_point = point;
		}
	}
	if(isdefined(best_point))
	{
		self BotSetGoal(best_point.origin, 24);
	}
}

/*
	Name: revive_players
	Namespace: bot
	Checksum: 0xEAA81190
	Offset: 0x3C90
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function revive_players()
{
	players = self get_team_players_in_laststand();
	if(players.size > 0)
	{
		revive_player(players[0]);
		return 1;
	}
	return 0;
}

/*
	Name: get_team_players_in_laststand
	Namespace: bot
	Checksum: 0x28B517DC
	Offset: 0x3CF8
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function get_team_players_in_laststand()
{
	players = [];
	foreach(player in level.players)
	{
		if(player != self && player laststand::player_is_in_laststand() && player.team == self.team)
		{
			players[players.size] = player;
		}
	}
	players = ArraySort(players, self.origin);
	return players;
}

/*
	Name: revive_player
	Namespace: bot
	Checksum: 0xD42B2BA8
	Offset: 0x3E00
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function revive_player(player)
{
	if(!point_in_goal(player.origin))
	{
		self BotSetGoal(player.origin, 64);
		self sprint_to_goal();
		return;
	}
	if(self BotGoalReached())
	{
		self BotSetLookAnglesFromPoint(player GetCentroid());
		self tap_use_button();
	}
}

/*
	Name: watch_bot_corner
	Namespace: bot
	Checksum: 0x63B22886
	Offset: 0x3ED0
	Size: 0x16F
	Parameters: 2
	Flags: None
*/
function watch_bot_corner(startCornerDist, cornerDist)
{
	self endon("death");
	self endon("bot_combat_target");
	level endon("game_ended");
	if(!isdefined(startCornerDist))
	{
		startCornerDist = 64;
	}
	if(!isdefined(cornerDist))
	{
		cornerDist = 128;
	}
	startCornerDistSq = cornerDist * cornerDist;
	cornerDistSq = cornerDist * cornerDist;
	while(1)
	{
		self waittill("bot_corner", centerPoint, enterPoint, leavePoint, angle, nextEnterPoint);
		if(self bot_combat::has_threat())
		{
			continue;
		}
		if(Distance2DSquared(self.origin, enterPoint) < startCornerDistSq || Distance2DSquared(leavePoint, nextEnterPoint) < cornerDistSq)
		{
			continue;
		}
		self thread wait_corner_radius(startCornerDistSq, centerPoint, enterPoint, leavePoint, angle, nextEnterPoint);
	}
}

/*
	Name: wait_corner_radius
	Namespace: bot
	Checksum: 0xFE82EDD
	Offset: 0x4048
	Size: 0x10B
	Parameters: 6
	Flags: None
*/
function wait_corner_radius(startCornerDistSq, centerPoint, enterPoint, leavePoint, angle, nextEnterPoint)
{
	self endon("death");
	self endon("bot_corner");
	self endon("bot_goal_reached");
	self endon("bot_combat_target");
	level endon("game_ended");
	while(Distance2DSquared(self.origin, enterPoint) > startCornerDistSq)
	{
		if(self bot_combat::has_threat())
		{
			return;
		}
		wait(0.05);
	}
	self BotLookAtPoint((nextEnterPoint[0], nextEnterPoint[1], nextEnterPoint[1] + 60));
	self thread finish_corner();
}

/*
	Name: finish_corner
	Namespace: bot
	Checksum: 0x3E052610
	Offset: 0x4160
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function finish_corner()
{
	self endon("death");
	self endon("combat_target");
	level endon("game_ended");
	self util::waittill_any("bot_corner", "bot_goal_reached");
	self BotLookForward();
}

/*
	Name: get_host_player
	Namespace: bot
	Checksum: 0x33006195
	Offset: 0x41D0
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function get_host_player()
{
	players = GetPlayers();
	foreach(player in players)
	{
		if(player IsHost())
		{
			return player;
		}
	}
	return undefined;
}

/*
	Name: fwd_dot
	Namespace: bot
	Checksum: 0x88446226
	Offset: 0x4288
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function fwd_dot(point)
{
	angles = self getPlayerAngles();
	fwd = AnglesToForward(angles);
	delta = point - self GetEye();
	delta = VectorNormalize(delta);
	dot = VectorDot(fwd, delta);
	return dot;
}

/*
	Name: has_launcher
	Namespace: bot
	Checksum: 0x6807058C
	Offset: 0x4358
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function has_launcher()
{
	weapons = self GetWeaponsList();
	foreach(weapon in weapons)
	{
		if(weapon.isRocketLauncher)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: kill_bot
	Namespace: bot
	Checksum: 0x5A9A61F7
	Offset: 0x4410
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function kill_bot()
{
	self DoDamage(self.health, self.origin);
}

/*
	Name: kill_bots
	Namespace: bot
	Checksum: 0x5405430A
	Offset: 0x4448
	Size: 0xA9
	Parameters: 0
	Flags: None
*/
function kill_bots()
{
	/#
		foreach(player in level.players)
		{
			if(player util::is_bot())
			{
				player kill_bot();
			}
		}
	#/
}

/*
	Name: add_bot_at_eye_trace
	Namespace: bot
	Checksum: 0xF51CEA5B
	Offset: 0x4500
	Size: 0x159
	Parameters: 1
	Flags: None
*/
function add_bot_at_eye_trace(team)
{
	/#
		host = util::getHostPlayer();
		trace = host eye_trace();
		direction_vec = host.origin - trace["Dev Block strings are not supported"];
		direction = VectorToAngles(direction_vec);
		yaw = direction[1];
		bot = add_bot(team);
		if(isdefined(bot))
		{
			bot waittill("spawned_player");
			bot SetOrigin(trace["Dev Block strings are not supported"]);
			bot SetPlayerAngles((bot.angles[0], yaw, bot.angles[2]));
		}
		return bot;
	#/
}

/*
	Name: eye_trace
	Namespace: bot
	Checksum: 0xA97D49DF
	Offset: 0x4668
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function eye_trace()
{
	/#
		direction = self getPlayerAngles();
		direction_vec = AnglesToForward(direction);
		eye = self GetEye();
		scale = 8000;
		direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
		return bullettrace(eye, eye + direction_vec, 0, undefined);
	#/
}

/*
	Name: devgui_debug_route
	Namespace: bot
	Checksum: 0xBA222ABC
	Offset: 0x4748
	Size: 0x151
	Parameters: 0
	Flags: None
*/
function devgui_debug_route()
{
	/#
		iprintln("Dev Block strings are not supported");
		points = self get_nav_points();
		if(!isdefined(points) || points.size == 0)
		{
			iprintln("Dev Block strings are not supported");
			return;
		}
		iprintln("Dev Block strings are not supported");
		players = GetPlayers();
		foreach(player in players)
		{
			if(!player util::is_bot())
			{
				continue;
			}
			player thread debug_patrol(points);
		}
	#/
}

/*
	Name: get_nav_points
	Namespace: bot
	Checksum: 0xA866648F
	Offset: 0x48A8
	Size: 0x229
	Parameters: 0
	Flags: None
*/
function get_nav_points()
{
	/#
		iprintln("Dev Block strings are not supported");
		iprintln("Dev Block strings are not supported");
		iprintln("Dev Block strings are not supported");
		points = [];
		while(1)
		{
			wait(0.05);
			point = self eye_trace()["Dev Block strings are not supported"];
			if(isdefined(point))
			{
				point = GetClosestPointOnNavMesh(point, 128);
				if(isdefined(point))
				{
					sphere(point, 16, (0, 0, 1), 0.25, 0, 16, 1);
				}
			}
			if(self buttonpressed("Dev Block strings are not supported"))
			{
				if(isdefined(point) && (points.size == 0 || Distance2D(point, points[points.size - 1]) > 16))
				{
					points[points.size] = point;
				}
			}
			else if(self buttonpressed("Dev Block strings are not supported"))
			{
				return points;
			}
			else if(self buttonpressed("Dev Block strings are not supported"))
			{
				return undefined;
			}
			for(i = 0; i < points.size; i++)
			{
				sphere(points[i], 16, (0, 1, 0), 0.25, 0, 16, 1);
			}
		}
	#/
}

/*
	Name: debug_patrol
	Namespace: bot
	Checksum: 0xBB172EBE
	Offset: 0x4AE0
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function debug_patrol(points)
{
	/#
		self notify("debug_patrol");
		self endon("death");
		self endon("debug_patrol");
		i = 0;
		while(1)
		{
			self BotSetGoal(points[i], 24);
			self sprint_to_goal();
			self waittill("bot_goal_reached");
			i = i + 1 % points.size;
		}
	#/
}

/*
	Name: bot_devgui_think
	Namespace: bot
	Checksum: 0x11E3E8FD
	Offset: 0x4BA0
	Size: 0x127
	Parameters: 0
	Flags: None
*/
function bot_devgui_think()
{
	/#
		while(1)
		{
			wait(0.25);
			cmd = GetDvarString("Dev Block strings are not supported", "Dev Block strings are not supported");
			if(!isdefined(level.botDevguiCmd) || ![[level.botDevguiCmd]](cmd))
			{
				host = util::getHostPlayer();
				switch(cmd)
				{
					case "Dev Block strings are not supported":
					{
						remove_bots();
						break;
					}
					case "Dev Block strings are not supported":
					{
						kill_bots();
						break;
					}
					case "Dev Block strings are not supported":
					{
						host devgui_debug_route();
						break;
					}
					case default:
					{
						break;
					}
				}
			}
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
	#/
}

/*
	Name: coop_bot_devgui_cmd
	Namespace: bot
	Checksum: 0xCBAFBDDD
	Offset: 0x4CD0
	Size: 0xF1
	Parameters: 1
	Flags: None
*/
function coop_bot_devgui_cmd(cmd)
{
	/#
		host = get_host_player();
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				add_bot(host.team);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				add_bots(3, host.team);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				add_bot_at_eye_trace();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				remove_bots(1);
				return 1;
				break;
			}
		}
		return 0;
	#/
}

/*
	Name: debug_star
	Namespace: bot
	Checksum: 0x6DBFB4D4
	Offset: 0x4DD0
	Size: 0x8B
	Parameters: 3
	Flags: None
*/
function debug_star(origin, seconds, color)
{
	/#
		if(!isdefined(seconds))
		{
			seconds = 1;
		}
		if(!isdefined(color))
		{
			color = (1, 0, 0);
		}
		frames = Int(20 * seconds);
		debugstar(origin, frames, color);
	#/
}

