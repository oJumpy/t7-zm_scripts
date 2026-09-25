#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\callbacks_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace scoreevents;

/*
	Name: processScoreEvent
	Namespace: scoreevents
	Checksum: 0x96EC284D
	Offset: 0x2B0
	Size: 0x3C7
	Parameters: 4
	Flags: None
*/
function processScoreEvent(event, player, victim, weapon)
{
	PixBeginEvent("processScoreEvent");
	scoreGiven = 0;
	if(!isPlayer(player))
	{
		/#
			ASSERTMSG("Dev Block strings are not supported" + event);
		#/
		return scoreGiven;
	}
	if(GetDvarInt("teamOpsEnabled") == 1)
	{
		if(isdefined(level.teamopsOnProcessPlayerEvent))
		{
			level [[level.teamopsOnProcessPlayerEvent]](event, player);
		}
	}
	if(isdefined(level.challengesOnEventReceived))
	{
		player thread [[level.challengesOnEventReceived]](event);
	}
	if(isRegisteredEvent(event) && (!SessionModeIsZombiesGame() || level.onlineGame))
	{
		allowPlayerScore = 0;
		if(!isdefined(weapon) || !killstreaks::is_killstreak_weapon(weapon))
		{
			allowPlayerScore = 1;
		}
		else
		{
			allowPlayerScore = killstreakWeaponsAllowedScore(event);
		}
		if(allowPlayerScore)
		{
			if(isdefined(level.scoreOnGivePlayerScore))
			{
				scoreGiven = [[level.scoreOnGivePlayerScore]](event, player, victim, undefined, weapon);
				isScoreEvent = scoreGiven > 0;
				if(isScoreEvent)
				{
					hero_restricted = is_hero_score_event_restricted(event);
					player ability_power::power_gain_event_score(victim, scoreGiven, weapon, hero_restricted);
				}
			}
		}
	}
	if(shouldAddRankXP(player) && GetDvarInt("teamOpsEnabled") == 0)
	{
		pickedup = 0;
		if(isdefined(weapon) && isdefined(player.pickedUpWeapons) && isdefined(player.pickedUpWeapons[weapon]))
		{
			pickedup = 1;
		}
		if(SessionModeIsCampaignGame())
		{
			xp_difficulty_multiplier = player gameskill::get_player_xp_difficulty_multiplier();
		}
		else
		{
			xp_difficulty_multiplier = 1;
		}
		player AddRankXp(event, weapon, player.class_num, pickedup, isScoreEvent, xp_difficulty_multiplier);
	}
	PixEndEvent();
	if(SessionModeIsCampaignGame() && isdefined(xp_difficulty_multiplier))
	{
		if(isdefined(victim) && isdefined(victim.team))
		{
			if(victim.team == "axis" || victim.team == "team3")
			{
				scoreGiven = scoreGiven * xp_difficulty_multiplier;
			}
		}
	}
	return scoreGiven;
}

/*
	Name: shouldAddRankXP
	Namespace: scoreevents
	Checksum: 0x81884CBA
	Offset: 0x680
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function shouldAddRankXP(player)
{
	if(SessionModeIsCampaignZombiesGame())
	{
		return 0;
	}
	if(level.gametype == "fr")
	{
		return 0;
	}
	if(!isdefined(level.rankCap) || level.rankCap == 0)
	{
		return 1;
	}
	if(player.pers["plevel"] > 0 || player.pers["rank"] > level.rankCap)
	{
		return 0;
	}
	return 1;
}

/*
	Name: uninterruptedObitFeedKills
	Namespace: scoreevents
	Checksum: 0xE2352C0A
	Offset: 0x730
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function uninterruptedObitFeedKills(attacker, weapon)
{
	self endon("disconnect");
	wait(0.1);
	util::WaitTillSlowProcessAllowed();
	wait(0.1);
	processScoreEvent("uninterrupted_obit_feed_kills", attacker, self, weapon);
}

/*
	Name: isRegisteredEvent
	Namespace: scoreevents
	Checksum: 0x2BA82723
	Offset: 0x7A0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function isRegisteredEvent(type)
{
	if(isdefined(level.scoreInfo[type]))
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

/*
	Name: decrementLastObituaryPlayerCountAfterFade
	Namespace: scoreevents
	Checksum: 0x2107D27E
	Offset: 0x7D8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function decrementLastObituaryPlayerCountAfterFade()
{
	level endon("reset_obituary_count");
	wait(5);
	level.lastObituaryPlayerCount--;
	/#
		Assert(level.lastObituaryPlayerCount >= 0);
	#/
}

/*
	Name: getScoreEventTableName
	Namespace: scoreevents
	Checksum: 0x95F44F5
	Offset: 0x820
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function getScoreEventTableName()
{
	if(SessionModeIsCampaignGame())
	{
		return "gamedata/tables/cp/scoreInfo.csv";
	}
	else if(SessionModeIsZombiesGame())
	{
		return "gamedata/tables/zm/scoreInfo.csv";
	}
	else
	{
		return "gamedata/tables/mp/scoreInfo.csv";
	}
}

/*
	Name: getScoreEventTableID
	Namespace: scoreevents
	Checksum: 0xE86D5F70
	Offset: 0x878
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function getScoreEventTableID()
{
	scoreInfoTableLoaded = 0;
	scoreInfoTableID = TableLookupFindCoreAsset(getScoreEventTableName());
	if(isdefined(scoreInfoTableID))
	{
		scoreInfoTableLoaded = 1;
	}
	/#
		Assert(scoreInfoTableLoaded, "Dev Block strings are not supported" + getScoreEventTableName());
	#/
	return scoreInfoTableID;
}

/*
	Name: getScoreEventColumn
	Namespace: scoreevents
	Checksum: 0xB9267F2C
	Offset: 0x918
	Size: 0x69
	Parameters: 1
	Flags: None
*/
function getScoreEventColumn(gametype)
{
	columnOffset = getColumnOffsetForGametype(gametype);
	/#
		Assert(columnOffset >= 0);
	#/
	if(columnOffset >= 0)
	{
		columnOffset = columnOffset + 0;
	}
	return columnOffset;
}

/*
	Name: getXPEventColumn
	Namespace: scoreevents
	Checksum: 0xD5027DF8
	Offset: 0x990
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function getXPEventColumn(gametype)
{
	columnOffset = getColumnOffsetForGametype(gametype);
	/#
		Assert(columnOffset >= 0);
	#/
	if(columnOffset >= 0)
	{
		columnOffset = columnOffset + 1;
	}
	return columnOffset;
}

/*
	Name: getColumnOffsetForGametype
	Namespace: scoreevents
	Checksum: 0xB0DFFB9E
	Offset: 0xA08
	Size: 0x137
	Parameters: 1
	Flags: None
*/
function getColumnOffsetForGametype(gametype)
{
	foundGameMode = 0;
	if(!isdefined(level.scoreEventTableID))
	{
		level.scoreEventTableID = getScoreEventTableID();
	}
	/#
		Assert(isdefined(level.scoreEventTableID));
	#/
	if(!isdefined(level.scoreEventTableID))
	{
		return -1;
	}
	gameModeColumn = 14;
	for(;;)
	{
		column_header = TableLookupColumnForRow(level.scoreEventTableID, 0, gameModeColumn);
		if(column_header == "")
		{
			gameModeColumn = 14;
		}
		else if(column_header == level.gametype + " score")
		{
			foundGameMode = 1;
		}
		gameModeColumn = gameModeColumn + 2;
	}
	else
	{
	}
	/#
		Assert(foundGameMode, "Dev Block strings are not supported" + gametype);
	#/
	return gameModeColumn;
}

/*
	Name: killstreakWeaponsAllowedScore
	Namespace: scoreevents
	Checksum: 0xBC263923
	Offset: 0xB48
	Size: 0x79
	Parameters: 1
	Flags: None
*/
function killstreakWeaponsAllowedScore(type)
{
	if(GetDvarInt("teamOpsEnabled") == 1)
	{
		return 0;
	}
	if(isdefined(level.scoreInfo[type]["allowKillstreakWeapons"]) && level.scoreInfo[type]["allowKillstreakWeapons"] == 1)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

/*
	Name: is_hero_score_event_restricted
	Namespace: scoreevents
	Checksum: 0x14C99E5B
	Offset: 0xBD0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function is_hero_score_event_restricted(event)
{
	if(!isdefined(level.scoreInfo[event]["allow_hero"]) || level.scoreInfo[event]["allow_hero"] != 1)
	{
		return 1;
	}
	return 0;
}

/*
	Name: giveCrateCaptureMedal
	Namespace: scoreevents
	Checksum: 0x389972ED
	Offset: 0xC30
	Size: 0x1EB
	Parameters: 2
	Flags: None
*/
function giveCrateCaptureMedal(Crate, capturer)
{
	if(isdefined(Crate) && isdefined(capturer) && isdefined(Crate.owner) && isPlayer(Crate.owner))
	{
		if(level.teambased)
		{
			if(capturer.team != Crate.owner.team)
			{
				Crate.owner playlocalsound("mpl_crate_enemy_steals");
				if(!isdefined(Crate.hacker))
				{
					processScoreEvent("capture_enemy_crate", capturer);
				}
			}
			else if(isdefined(Crate.owner) && capturer != Crate.owner)
			{
				Crate.owner playlocalsound("mpl_crate_friendly_steals");
				if(!isdefined(Crate.hacker))
				{
					level.globalSharePackages++;
					processScoreEvent("share_care_package", Crate.owner);
				}
			}
		}
		else if(capturer != Crate.owner)
		{
			Crate.owner playlocalsound("mpl_crate_enemy_steals");
			if(!isdefined(Crate.hacker))
			{
				processScoreEvent("capture_enemy_crate", capturer);
			}
		}
	}
}

/*
	Name: register_hero_ability_kill_event
	Namespace: scoreevents
	Checksum: 0x7417FA2F
	Offset: 0xE28
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function register_hero_ability_kill_event(event_func)
{
	if(!isdefined(level.hero_ability_kill_events))
	{
		level.hero_ability_kill_events = [];
	}
	level.hero_ability_kill_events[level.hero_ability_kill_events.size] = event_func;
}

/*
	Name: register_hero_ability_multikill_event
	Namespace: scoreevents
	Checksum: 0x8FBB5A80
	Offset: 0xE70
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function register_hero_ability_multikill_event(event_func)
{
	if(!isdefined(level.hero_ability_multikill_events))
	{
		level.hero_ability_multikill_events = [];
	}
	level.hero_ability_multikill_events[level.hero_ability_multikill_events.size] = event_func;
}

/*
	Name: register_hero_weapon_multikill_event
	Namespace: scoreevents
	Checksum: 0x76E4F673
	Offset: 0xEB8
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function register_hero_weapon_multikill_event(event_func)
{
	if(!isdefined(level.hero_weapon_multikill_events))
	{
		level.hero_weapon_multikill_events = [];
	}
	level.hero_weapon_multikill_events[level.hero_weapon_multikill_events.size] = event_func;
}

/*
	Name: register_thief_shutdown_enemy_event
	Namespace: scoreevents
	Checksum: 0x90F82B17
	Offset: 0xF00
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function register_thief_shutdown_enemy_event(event_func)
{
	if(!isdefined(level.thief_shutdown_enemy_events))
	{
		level.thief_shutdown_enemy_events = [];
	}
	level.thief_shutdown_enemy_events[level.thief_shutdown_enemy_events.size] = event_func;
}

/*
	Name: hero_ability_kill_event
	Namespace: scoreevents
	Checksum: 0x33BAD423
	Offset: 0xF48
	Size: 0xB3
	Parameters: 2
	Flags: None
*/
function hero_ability_kill_event(ability, victim_ability)
{
	if(!isdefined(level.hero_ability_kill_events))
	{
		return;
	}
	foreach(event_func in level.hero_ability_kill_events)
	{
		if(isdefined(event_func))
		{
			self [[event_func]](ability, victim_ability);
		}
	}
}

/*
	Name: hero_ability_multikill_event
	Namespace: scoreevents
	Checksum: 0xD58684A
	Offset: 0x1008
	Size: 0xB3
	Parameters: 2
	Flags: None
*/
function hero_ability_multikill_event(killcount, ability)
{
	if(!isdefined(level.hero_ability_multikill_events))
	{
		return;
	}
	foreach(event_func in level.hero_ability_multikill_events)
	{
		if(isdefined(event_func))
		{
			self [[event_func]](killcount, ability);
		}
	}
}

/*
	Name: hero_weapon_multikill_event
	Namespace: scoreevents
	Checksum: 0x52BE2291
	Offset: 0x10C8
	Size: 0xB3
	Parameters: 2
	Flags: None
*/
function hero_weapon_multikill_event(killcount, weapon)
{
	if(!isdefined(level.hero_weapon_multikill_events))
	{
		return;
	}
	foreach(event_func in level.hero_weapon_multikill_events)
	{
		if(isdefined(event_func))
		{
			self [[event_func]](killcount, weapon);
		}
	}
}

/*
	Name: thief_shutdown_enemy_event
	Namespace: scoreevents
	Checksum: 0x34FF785A
	Offset: 0x1188
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function thief_shutdown_enemy_event()
{
	if(!isdefined(level.thief_shutdown_enemy_event))
	{
		return;
	}
	foreach(event_func in level.thief_shutdown_enemy_event)
	{
		if(isdefined(event_func))
		{
			self [[event_func]]();
		}
	}
}

