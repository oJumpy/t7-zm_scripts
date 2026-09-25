#using scripts\shared\system_shared;

#namespace tweakables;

/*
	Name: __init__sytem__
	Namespace: tweakables
	Checksum: 0x3EE9FD73
	Offset: 0x448
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("tweakables", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: tweakables
	Checksum: 0xCDE7E501
	Offset: 0x488
	Size: 0x4CB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.clientTweakables = [];
	level.tweakablesInitialized = 1;
	level.Rules = [];
	level.gameTweaks = [];
	level.teamTweaks = [];
	level.playerTweaks = [];
	level.classTweaks = [];
	level.weaponTweaks = [];
	level.hardpointTweaks = [];
	level.hudTweaks = [];
	registerTweakable("game", "arcadescoring", "scr_game_arcadescoring", 0);
	registerTweakable("game", "difficulty", "scr_game_difficulty", 1);
	registerTweakable("game", "pinups", "scr_game_pinups", 0);
	registerTweakable("team", "teamkillerplaylistbanquantum", "scr_team_teamkillerplaylistbanquantum", 0);
	registerTweakable("team", "teamkillerplaylistbanpenalty", "scr_team_teamkillerplaylistbanpenalty", 0);
	registerTweakable("player", "allowrevive", "scr_player_allowrevive", 1);
	registerTweakable("weapon", "allowfrag", "scr_weapon_allowfrags", 1);
	registerTweakable("weapon", "allowsmoke", "scr_weapon_allowsmoke", 1);
	registerTweakable("weapon", "allowflash", "scr_weapon_allowflash", 1);
	registerTweakable("weapon", "allowc4", "scr_weapon_allowc4", 1);
	registerTweakable("weapon", "allowsatchel", "scr_weapon_allowsatchel", 1);
	registerTweakable("weapon", "allowbetty", "scr_weapon_allowbetty", 1);
	registerTweakable("weapon", "allowrpgs", "scr_weapon_allowrpgs", 1);
	registerTweakable("weapon", "allowmines", "scr_weapon_allowmines", 1);
	registerTweakable("hud", "showobjicons", "ui_hud_showobjicons", 1);
	setClientTweakable("hud", "showobjicons");
	registerTweakable("killstreak", "allowradar", "scr_hardpoint_allowradar", 1);
	registerTweakable("killstreak", "allowradardirection", "scr_hardpoint_allowradardirection", 1);
	registerTweakable("killstreak", "allowcounteruav", "scr_hardpoint_allowcounteruav", 1);
	registerTweakable("killstreak", "allowdogs", "scr_hardpoint_allowdogs", 1);
	registerTweakable("killstreak", "allowhelicopter_comlink", "scr_hardpoint_allowhelicopter_comlink", 1);
	registerTweakable("killstreak", "allowrcbomb", "scr_hardpoint_allowrcbomb", 1);
	registerTweakable("killstreak", "allowauto_turret", "scr_hardpoint_allowauto_turret", 1);
	/#
		var_63c594d2 = 1;
	#/
	level thread updateUITweakables(var_63c594d2);
}

/*
	Name: getTweakableDVarValue
	Namespace: tweakables
	Checksum: 0x93066055
	Offset: 0x960
	Size: 0x1C3
	Parameters: 2
	Flags: None
*/
function getTweakableDVarValue(category, name)
{
	switch(category)
	{
		case "rule":
		{
			dvar = level.Rules[name].dvar;
			break;
		}
		case "game":
		{
			dvar = level.gameTweaks[name].dvar;
			break;
		}
		case "team":
		{
			dvar = level.teamTweaks[name].dvar;
			break;
		}
		case "player":
		{
			dvar = level.playerTweaks[name].dvar;
			break;
		}
		case "class":
		{
			dvar = level.classTweaks[name].dvar;
			break;
		}
		case "weapon":
		{
			dvar = level.weaponTweaks[name].dvar;
			break;
		}
		case "killstreak":
		{
			dvar = level.hardpointTweaks[name].dvar;
			break;
		}
		case "hud":
		{
			dvar = level.hudTweaks[name].dvar;
			break;
		}
		case default:
		{
			dvar = undefined;
			break;
		}
	}
	/#
		Assert(isdefined(dvar));
	#/
	value = GetDvarInt(dvar);
	return value;
}

/*
	Name: getTweakableDVar
	Namespace: tweakables
	Checksum: 0x9F27CE84
	Offset: 0xB30
	Size: 0x19F
	Parameters: 2
	Flags: None
*/
function getTweakableDVar(category, name)
{
	switch(category)
	{
		case "rule":
		{
			value = level.Rules[name].dvar;
			break;
		}
		case "game":
		{
			value = level.gameTweaks[name].dvar;
			break;
		}
		case "team":
		{
			value = level.teamTweaks[name].dvar;
			break;
		}
		case "player":
		{
			value = level.playerTweaks[name].dvar;
			break;
		}
		case "class":
		{
			value = level.classTweaks[name].dvar;
			break;
		}
		case "weapon":
		{
			value = level.weaponTweaks[name].dvar;
			break;
		}
		case "killstreak":
		{
			value = level.hardpointTweaks[name].dvar;
			break;
		}
		case "hud":
		{
			value = level.hudTweaks[name].dvar;
			break;
		}
		case default:
		{
			value = undefined;
			break;
		}
	}
	/#
		Assert(isdefined(value));
	#/
	return value;
}

/*
	Name: getTweakableValue
	Namespace: tweakables
	Checksum: 0x9629BCE
	Offset: 0xCD8
	Size: 0x217
	Parameters: 2
	Flags: None
*/
function getTweakableValue(category, name)
{
	switch(category)
	{
		case "rule":
		{
			value = level.Rules[name].value;
			break;
		}
		case "game":
		{
			value = level.gameTweaks[name].value;
			break;
		}
		case "team":
		{
			value = level.teamTweaks[name].value;
			break;
		}
		case "player":
		{
			value = level.playerTweaks[name].value;
			break;
		}
		case "class":
		{
			value = level.classTweaks[name].value;
			break;
		}
		case "weapon":
		{
			value = level.weaponTweaks[name].value;
			break;
		}
		case "killstreak":
		{
			value = level.hardpointTweaks[name].value;
			break;
		}
		case "hud":
		{
			value = level.hudTweaks[name].value;
			break;
		}
		case default:
		{
			value = undefined;
			break;
		}
	}
	overrideDvar = "scr_" + level.gametype + "_" + category + "_" + name;
	if(GetDvarString(overrideDvar) != "")
	{
		return GetDvarInt(overrideDvar);
	}
	/#
		Assert(isdefined(value));
	#/
	return value;
}

/*
	Name: getTweakableLastValue
	Namespace: tweakables
	Checksum: 0x31FC11E7
	Offset: 0xEF8
	Size: 0x19F
	Parameters: 2
	Flags: None
*/
function getTweakableLastValue(category, name)
{
	switch(category)
	{
		case "rule":
		{
			value = level.Rules[name].lastValue;
			break;
		}
		case "game":
		{
			value = level.gameTweaks[name].lastValue;
			break;
		}
		case "team":
		{
			value = level.teamTweaks[name].lastValue;
			break;
		}
		case "player":
		{
			value = level.playerTweaks[name].lastValue;
			break;
		}
		case "class":
		{
			value = level.classTweaks[name].lastValue;
			break;
		}
		case "weapon":
		{
			value = level.weaponTweaks[name].lastValue;
			break;
		}
		case "killstreak":
		{
			value = level.hardpointTweaks[name].lastValue;
			break;
		}
		case "hud":
		{
			value = level.hudTweaks[name].lastValue;
			break;
		}
		case default:
		{
			value = undefined;
			break;
		}
	}
	/#
		Assert(isdefined(value));
	#/
	return value;
}

/*
	Name: setTweakableValue
	Namespace: tweakables
	Checksum: 0x2EE0F11C
	Offset: 0x10A0
	Size: 0x1A3
	Parameters: 3
	Flags: None
*/
function setTweakableValue(category, name, value)
{
	switch(category)
	{
		case "rule":
		{
			dvar = level.Rules[name].dvar;
			break;
		}
		case "game":
		{
			dvar = level.gameTweaks[name].dvar;
			break;
		}
		case "team":
		{
			dvar = level.teamTweaks[name].dvar;
			break;
		}
		case "player":
		{
			dvar = level.playerTweaks[name].dvar;
			break;
		}
		case "class":
		{
			dvar = level.classTweaks[name].dvar;
			break;
		}
		case "weapon":
		{
			dvar = level.weaponTweaks[name].dvar;
			break;
		}
		case "killstreak":
		{
			dvar = level.hardpointTweaks[name].dvar;
			break;
		}
		case "hud":
		{
			dvar = level.hudTweaks[name].dvar;
			break;
		}
		case default:
		{
			dvar = undefined;
			break;
		}
	}
	SetDvar(dvar, value);
}

/*
	Name: setTweakableLastValue
	Namespace: tweakables
	Checksum: 0x17D9D3F5
	Offset: 0x1250
	Size: 0x179
	Parameters: 3
	Flags: None
*/
function setTweakableLastValue(category, name, value)
{
	switch(category)
	{
		case "rule":
		{
			level.Rules[name].lastValue = value;
			break;
		}
		case "game":
		{
			level.gameTweaks[name].lastValue = value;
			break;
		}
		case "team":
		{
			level.teamTweaks[name].lastValue = value;
			break;
		}
		case "player":
		{
			level.playerTweaks[name].lastValue = value;
			break;
		}
		case "class":
		{
			level.classTweaks[name].lastValue = value;
			break;
		}
		case "weapon":
		{
			level.weaponTweaks[name].lastValue = value;
			break;
		}
		case "killstreak":
		{
			level.hardpointTweaks[name].lastValue = value;
			break;
		}
		case "hud":
		{
			level.hudTweaks[name].lastValue = value;
			break;
		}
		case default:
		{
			break;
		}
	}
}

/*
	Name: registerTweakable
	Namespace: tweakables
	Checksum: 0xF1CCAD1
	Offset: 0x13D8
	Size: 0x5C9
	Parameters: 4
	Flags: None
*/
function registerTweakable(category, name, dvar, value)
{
	if(IsString(value))
	{
		if(GetDvarString(dvar) == "")
		{
			SetDvar(dvar, value);
		}
		else
		{
			value = GetDvarString(dvar);
		}
	}
	else if(GetDvarString(dvar) == "")
	{
		SetDvar(dvar, value);
	}
	else
	{
		value = GetDvarInt(dvar);
	}
	switch(category)
	{
		case "rule":
		{
			if(!isdefined(level.Rules[name]))
			{
				level.Rules[name] = spawnstruct();
			}
			level.Rules[name].value = value;
			level.Rules[name].lastValue = value;
			level.Rules[name].dvar = dvar;
			break;
		}
		case "game":
		{
			if(!isdefined(level.gameTweaks[name]))
			{
				level.gameTweaks[name] = spawnstruct();
			}
			level.gameTweaks[name].value = value;
			level.gameTweaks[name].lastValue = value;
			level.gameTweaks[name].dvar = dvar;
			break;
		}
		case "team":
		{
			if(!isdefined(level.teamTweaks[name]))
			{
				level.teamTweaks[name] = spawnstruct();
			}
			level.teamTweaks[name].value = value;
			level.teamTweaks[name].lastValue = value;
			level.teamTweaks[name].dvar = dvar;
			break;
		}
		case "player":
		{
			if(!isdefined(level.playerTweaks[name]))
			{
				level.playerTweaks[name] = spawnstruct();
			}
			level.playerTweaks[name].value = value;
			level.playerTweaks[name].lastValue = value;
			level.playerTweaks[name].dvar = dvar;
			break;
		}
		case "class":
		{
			if(!isdefined(level.classTweaks[name]))
			{
				level.classTweaks[name] = spawnstruct();
			}
			level.classTweaks[name].value = value;
			level.classTweaks[name].lastValue = value;
			level.classTweaks[name].dvar = dvar;
			break;
		}
		case "weapon":
		{
			if(!isdefined(level.weaponTweaks[name]))
			{
				level.weaponTweaks[name] = spawnstruct();
			}
			level.weaponTweaks[name].value = value;
			level.weaponTweaks[name].lastValue = value;
			level.weaponTweaks[name].dvar = dvar;
			break;
		}
		case "killstreak":
		{
			if(!isdefined(level.hardpointTweaks[name]))
			{
				level.hardpointTweaks[name] = spawnstruct();
			}
			level.hardpointTweaks[name].value = value;
			level.hardpointTweaks[name].lastValue = value;
			level.hardpointTweaks[name].dvar = dvar;
			break;
		}
		case "hud":
		{
			if(!isdefined(level.hudTweaks[name]))
			{
				level.hudTweaks[name] = spawnstruct();
			}
			level.hudTweaks[name].value = value;
			level.hudTweaks[name].lastValue = value;
			level.hudTweaks[name].dvar = dvar;
			break;
		}
	}
}

/*
	Name: setClientTweakable
	Namespace: tweakables
	Checksum: 0x91310E53
	Offset: 0x19B0
	Size: 0x29
	Parameters: 2
	Flags: None
*/
function setClientTweakable(category, name)
{
	level.clientTweakables[level.clientTweakables.size] = name;
}

/*
	Name: updateUITweakables
	Namespace: tweakables
	Checksum: 0x68FAE5B6
	Offset: 0x19E8
	Size: 0x12D
	Parameters: 1
	Flags: None
*/
function updateUITweakables(var_63c594d2)
{
	do
	{
		for(index = 0; index < level.clientTweakables.size; index++)
		{
			clientTweakable = level.clientTweakables[index];
			curValue = getTweakableDVarValue("hud", clientTweakable);
			lastValue = getTweakableLastValue("hud", clientTweakable);
			if(curValue != lastValue)
			{
				updateServerDvar(getTweakableDVar("hud", clientTweakable), curValue);
				setTweakableLastValue("hud", clientTweakable, curValue);
			}
		}
		wait(RandomFloatRange(0.9, 1.1));
	}
	while(!isdefined(var_63c594d2));
}

/*
	Name: updateServerDvar
	Namespace: tweakables
	Checksum: 0xE472FDD5
	Offset: 0x1B20
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function updateServerDvar(dvar, value)
{
}

