#using scripts\codescripts\struct;
#using scripts\shared\bb_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace bb;

/*
	Name: __init__sytem__
	Namespace: bb
	Checksum: 0xBEE79C6C
	Offset: 0x698
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("bb", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: bb
	Checksum: 0x6E8779F7
	Offset: 0x6D8
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function __init__()
{
	init_shared();
}

/*
	Name: logdamage
	Namespace: bb
	Checksum: 0x9FF373F7
	Offset: 0x6F8
	Size: 0x533
	Parameters: 8
	Flags: None
*/
function logdamage(attacker, victim, weapon, damage, damageType, hitlocation, victimkilled, victimdowned)
{
	victimid = -1;
	victimtype = "";
	victimOrigin = (0, 0, 0);
	victimignoreme = 0;
	victimignoreall = 0;
	victimfovcos = 0;
	victimmaxsightdistsqrd = 0;
	victimanimname = "";
	victimName = "";
	victimdowns = 0;
	attackerid = -1;
	attackertype = "";
	attackerOrigin = (0, 0, 0);
	attackerignoreme = 0;
	attackerignoreall = 0;
	attackerfovcos = 0;
	attackermaxsightdistsqrd = 0;
	attackeranimname = "";
	attackerName = "";
	aivictimtype = "";
	aivictimrank = "";
	aivictimcombatmode = "";
	aiattackertype = "";
	aiattackerrank = "";
	aiattackercombatmode = "";
	if(isdefined(attacker))
	{
		if(isPlayer(attacker))
		{
			attackerid = getplayerspawnid(attacker);
			attackertype = "_player";
			attackerName = attacker.name;
		}
		else if(isai(attacker))
		{
			attackertype = "_ai";
			aiattackercombatmode = attacker.combatmode;
			attackerid = attacker.actor_id;
		}
		else
		{
			attackertype = "_other";
		}
		attackerOrigin = attacker.origin;
		attackerignoreme = attacker.ignoreme;
		attackerfovcos = attacker.fovcosine;
		attackermaxsightdistsqrd = attacker.maxsightdistsqrd;
		if(isdefined(attacker.animName))
		{
			attackeranimname = attacker.animName;
		}
	}
	if(isdefined(victim))
	{
		if(isPlayer(victim))
		{
			victimid = getplayerspawnid(victim);
			victimtype = "_player";
			victimName = victim.name;
			victimdowns = victim.downs;
		}
		else if(isai(victim))
		{
			victimtype = "_ai";
			aivictimcombatmode = victim.combatmode;
			victimid = victim.actor_id;
		}
		else
		{
			victimtype = "_other";
		}
		victimOrigin = victim.origin;
		victimignoreme = victim.ignoreme;
		victimfovcos = victim.fovcosine;
		victimmaxsightdistsqrd = victim.maxsightdistsqrd;
		if(isdefined(victim.animName))
		{
			victimanimname = victim.animName;
		}
	}
	bbPrint("zmattacks", "gametime %d roundnumber %d attackerid %d attackername %s attackertype %s attackerweapon %s attackerx %d attackery %d attackerz %d aiattckercombatmode %s attackerignoreme %d attackerignoreall %d attackerfovcos %d attackermaxsightdistsqrd %d attackeranimname %s victimid %d victimname %s victimtype %s victimx %d victimy %d victimz %d aivictimcombatmode %s victimignoreme %d victimignoreall %d victimfovcos %d victimmaxsightdistsqrd %d victimanimname %s damage %d damagetype %s damagelocation %s death %d downed %d downs %d", GetTime(), level.round_number, attackerid, attackerName, attackertype, weapon.name, attackerOrigin, aiattackercombatmode, attackerignoreme, attackerignoreall, attackerfovcos, attackermaxsightdistsqrd, attackeranimname, victimid, victimName, victimtype, victimOrigin, aivictimcombatmode, victimignoreme, victimignoreall, victimfovcos, victimmaxsightdistsqrd, victimanimname, damage, damageType, hitlocation, victimkilled, victimdowned, victimdowns);
}

/*
	Name: logaispawn
	Namespace: bb
	Checksum: 0xFFA916FC
	Offset: 0xC38
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function logaispawn(aient, spawner)
{
	bbPrint("zmaispawn", "gametime %d actorid %d aitype %s archetype %s airank %s accuracy %d originx %d originy %d originz %d weapon %s melee_weapon %s health %d roundNum %d", GetTime(), aient.actor_id, aient.aitype, aient.archetype, aient.airank, aient.accuracy, aient.origin, aient.primaryWeapon.name, aient.meleeWeapon.name, aient.health, level.round_number);
}

/*
	Name: logplayerevent
	Namespace: bb
	Checksum: 0xB437D062
	Offset: 0xD00
	Size: 0x143
	Parameters: 2
	Flags: None
*/
function logplayerevent(player, eventName)
{
	currentWeapon = "";
	beastmodeactive = 0;
	if(isdefined(player.currentWeapon))
	{
		currentWeapon = player.currentWeapon.name;
	}
	if(isdefined(player.beastmode))
	{
		beastmodeactive = player.beastmode;
	}
	bbPrint("zmplayerevents", "gametime %d roundnumber %d eventname %s spawnid %d username %s originx %d originy %d originz %d health %d beastlives %d currentweapon %s kills %d zone_name %s sessionstate %s currentscore %d totalscore %d beastmodeon %d", GetTime(), level.round_number, eventName, getplayerspawnid(player), player.name, player.origin, player.health, player.beastlives, currentWeapon, player.kills, player.zone_name, player.sessionstate, player.score, player.score_total, beastmodeactive);
}

/*
	Name: logroundevent
	Namespace: bb
	Checksum: 0x5493D249
	Offset: 0xE50
	Size: 0xC9
	Parameters: 1
	Flags: None
*/
function logroundevent(eventName)
{
	bbPrint("zmroundevents", "gametime %d roundnumber %d eventname %s", GetTime(), level.round_number, eventName);
	foreach(player in level.players)
	{
		logplayerevent(player, eventName);
	}
}

/*
	Name: logpurchaseevent
	Namespace: bb
	Checksum: 0x7CEF30F4
	Offset: 0xF28
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function logpurchaseevent(player, sellerent, cost, itemName, itemupgraded, itemType, eventName)
{
	bbPrint("zmpurchases", "gametime %d roundnumber %d playerspawnid %d username %s itemname %s isupgraded %d itemtype %s purchasecost %d playeroriginx %d playeroriginy %d playeroriginz %d selleroriginx %d selleroriginy %d selleroriginz %d playerkills %d playerhealth %d playercurrentscore %d playertotalscore %d zone_name %s", GetTime(), level.round_number, getplayerspawnid(player), player.name, itemName, itemupgraded, itemType, cost, player.origin, sellerent.origin, player.kills, player.health, player.score, player.score_total, player.zone_name);
}

/*
	Name: logpowerupevent
	Namespace: bb
	Checksum: 0x5792FC11
	Offset: 0x1020
	Size: 0x189
	Parameters: 3
	Flags: None
*/
function logpowerupevent(powerup, optplayer, eventName)
{
	playerspawnid = -1;
	playerName = "";
	if(isdefined(optplayer) && isPlayer(optplayer))
	{
		playerspawnid = getplayerspawnid(optplayer);
		playerName = optplayer.name;
	}
	bbPrint("zmpowerups", "gametime %d roundnumber %d powerupname %s powerupx %d powerupy %d powerupz %d, eventname %s playerspawnid %d playername %s", GetTime(), level.round_number, powerup.powerup_name, powerup.origin, eventName, playerspawnid, playerName);
	foreach(player in level.players)
	{
		logplayerevent(player, "powerup_" + powerup.powerup_name + "_" + eventName);
	}
}

