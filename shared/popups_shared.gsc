#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\medals_shared;
#using scripts\shared\persistence_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapons;
#using scripts\shared\weapons_shared;

#namespace popups;

/*
	Name: __init__sytem__
	Namespace: popups
	Checksum: 0xD9CEE6CE
	Offset: 0x248
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("popups", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: popups
	Checksum: 0x867E07C8
	Offset: 0x288
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_start_gametype(&init);
}

/*
	Name: init
	Namespace: popups
	Checksum: 0x1D47A933
	Offset: 0x2B8
	Size: 0x1FB
	Parameters: 0
	Flags: None
*/
function init()
{
	level.contractSettings = spawnstruct();
	level.contractSettings.waitTime = 4.2;
	level.killstreakSettings = spawnstruct();
	level.killstreakSettings.waitTime = 3;
	level.rankSettings = spawnstruct();
	level.rankSettings.waitTime = 3;
	level.startMessage = spawnstruct();
	level.startMessageDefaultDuration = 2;
	level.endMessageDefaultDuration = 2;
	level.challengeSettings = spawnstruct();
	level.challengeSettings.waitTime = 3;
	level.teamMessage = spawnstruct();
	level.teamMessage.waitTime = 3;
	level.regularGameMessages = spawnstruct();
	level.regularGameMessages.waitTime = 6;
	level.wagerSettings = spawnstruct();
	level.wagerSettings.waitTime = 3;
	level.momentumNotifyWaitTime = 0;
	level.momentumNotifyWaitLastTime = 0;
	level.teamMessageQueueMax = 8;
	/#
		level thread popupsFromConsole();
		level thread function_9a14a686();
	#/
	callback::on_connecting(&on_player_connect);
}

/*
	Name: on_player_connect
	Namespace: popups
	Checksum: 0x545A4F4D
	Offset: 0x4C0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self.resetGameOverHudRequired = 0;
	self thread displayPopupsWaiter();
	if(!level.hardcoreMode)
	{
		self thread displayTeamMessageWaiter();
	}
}

/*
	Name: function_d661ce6
	Namespace: popups
	Checksum: 0xB34EB0A6
	Offset: 0x510
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_d661ce6()
{
	/#
		if(SessionModeIsCampaignGame())
		{
			return "Dev Block strings are not supported";
		}
		else if(SessionModeIsZombiesGame())
		{
			return "Dev Block strings are not supported";
		}
		else
		{
			return "Dev Block strings are not supported";
		}
	#/
}

/*
	Name: function_bcf0ce52
	Namespace: popups
	Checksum: 0xA0AAB2C2
	Offset: 0x570
	Size: 0x4D
	Parameters: 0
	Flags: None
*/
function function_bcf0ce52()
{
	/#
		if(SessionModeIsCampaignGame())
		{
			return 4;
		}
		else if(SessionModeIsZombiesGame())
		{
			return 4;
		}
		else
		{
			return 6;
		}
	#/
}

/*
	Name: function_5f5fa154
	Namespace: popups
	Checksum: 0x6CFDA47E
	Offset: 0x5C8
	Size: 0x89
	Parameters: 1
	Flags: None
*/
function function_5f5fa154(tableID)
{
	/#
		if(SessionModeIsCampaignGame())
		{
			return "Dev Block strings are not supported" + tableID + "Dev Block strings are not supported";
		}
		else if(SessionModeIsZombiesGame())
		{
			return "Dev Block strings are not supported" + tableID + "Dev Block strings are not supported";
		}
		else
		{
			return "Dev Block strings are not supported" + tableID + "Dev Block strings are not supported";
		}
	#/
}

/*
	Name: set_statstable_id
	Namespace: popups
	Checksum: 0xEB7D1C2F
	Offset: 0x660
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function set_statstable_id()
{
	/#
		if(!isdefined(level.statsTableID))
		{
			level.statsTableID = TableLookupFindCoreAsset(util::getStatsTableName());
		}
	#/
}

/*
	Name: function_fd48e858
	Namespace: popups
	Checksum: 0xBED6750F
	Offset: 0x6B0
	Size: 0x205
	Parameters: 0
	Flags: None
*/
function function_fd48e858()
{
	/#
		level.tbl_weaponIDs = [];
		set_statstable_id();
		if(!isdefined(level.statsTableID))
		{
			return;
		}
		for(i = 0; i < 256; i++)
		{
			itemRow = TableLookupRowNum(level.statsTableID, 0, i);
			if(itemRow > -1)
			{
				group_s = TableLookupColumnForRow(level.statsTableID, itemRow, 2);
				if(IsSubStr(group_s, "Dev Block strings are not supported") || group_s == "Dev Block strings are not supported")
				{
					reference_s = TableLookupColumnForRow(level.statsTableID, itemRow, 4);
					if(reference_s != "Dev Block strings are not supported")
					{
						weapon = GetWeapon(reference_s);
						level.tbl_weaponIDs[i]["Dev Block strings are not supported"] = reference_s;
						level.tbl_weaponIDs[i]["Dev Block strings are not supported"] = group_s;
						level.tbl_weaponIDs[i]["Dev Block strings are not supported"] = Int(TableLookupColumnForRow(level.statsTableID, itemRow, 5));
						level.tbl_weaponIDs[i]["Dev Block strings are not supported"] = TableLookupColumnForRow(level.statsTableID, itemRow, 8);
					}
				}
			}
		}
	#/
}

/*
	Name: function_9a14a686
	Namespace: popups
	Checksum: 0xEB16DA80
	Offset: 0x8C0
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function function_9a14a686()
{
	/#
		if(IsDedicated())
		{
			return;
		}
		if(GetDvarInt("Dev Block strings are not supported", -999) == -999)
		{
			SetDvar("Dev Block strings are not supported", 0);
		}
		var_deda26ca = "Dev Block strings are not supported";
		util::function_e2ac06bb(var_deda26ca + "Dev Block strings are not supported", "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
		while(1)
		{
			if(GetDvarInt("Dev Block strings are not supported", 0) > 0)
			{
				util::function_181cbd1a(var_deda26ca);
				level thread function_4b6c58e5();
				break;
			}
			wait(1);
		}
	#/
}

/*
	Name: function_4b6c58e5
	Namespace: popups
	Checksum: 0x6C6630A3
	Offset: 0x9E0
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function function_4b6c58e5()
{
	/#
		SetDvar("Dev Block strings are not supported", 0);
		SetDvar("Dev Block strings are not supported", 0);
		SetDvar("Dev Block strings are not supported", 0);
		SetDvar("Dev Block strings are not supported", 0);
		SetDvar("Dev Block strings are not supported", 0);
		if(IsDedicated())
		{
			return;
		}
		level thread function_e2246547();
		level thread function_c3cec5b6();
		if(!SessionModeIsCampaignGame())
		{
			level thread function_eafd7f5b();
		}
	#/
}

/*
	Name: function_e2246547
	Namespace: popups
	Checksum: 0xA431CF3
	Offset: 0xAD8
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function function_e2246547()
{
	/#
		if(!isdefined(level.rankTable))
		{
			return;
		}
		var_224b06c1 = "Dev Block strings are not supported";
		for(i = 1; i < level.rankTable.size; i++)
		{
			var_ef841aa = i + 1;
			if(var_ef841aa < 10)
			{
				var_ef841aa = "Dev Block strings are not supported" + var_ef841aa;
			}
			AddDebugCommand(var_224b06c1 + var_ef841aa + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + i + "Dev Block strings are not supported");
			if(i % 10 == 0)
			{
				wait(0.05);
			}
		}
		wait(0.05);
		level thread function_69d13854();
	#/
}

/*
	Name: function_69d13854
	Namespace: popups
	Checksum: 0x71C447B5
	Offset: 0xC08
	Size: 0x95
	Parameters: 0
	Flags: None
*/
function function_69d13854()
{
	/#
		for(;;)
		{
			var_1d37f2d9 = GetDvarInt("Dev Block strings are not supported");
			if(var_1d37f2d9 == 0)
			{
				wait(0.05);
				continue;
			}
			level.players[0] rank::CodeCallback_RankUp(var_1d37f2d9, 0, 1);
			SetDvar("Dev Block strings are not supported", 0);
			wait(1);
		}
	#/
}

/*
	Name: function_c3cec5b6
	Namespace: popups
	Checksum: 0x3982CB3B
	Offset: 0xCA8
	Size: 0x7FB
	Parameters: 0
	Flags: None
*/
function function_c3cec5b6()
{
	/#
		var_e018f980 = "Dev Block strings are not supported";
		var_2ce93f4e = 0;
		var_ed402ca6 = 2;
		var_47c6ecb9 = 3;
		var_374718d1 = 4;
		level flag::wait_till("Dev Block strings are not supported");
		if(!isdefined(level.tbl_weaponIDs))
		{
			function_fd48e858();
		}
		if(!isdefined(level.tbl_weaponIDs))
		{
			return;
		}
		a_weapons = [];
		a_weapons["Dev Block strings are not supported"] = [];
		a_weapons["Dev Block strings are not supported"] = [];
		a_weapons["Dev Block strings are not supported"] = [];
		a_weapons["Dev Block strings are not supported"] = [];
		a_weapons["Dev Block strings are not supported"] = [];
		a_weapons["Dev Block strings are not supported"] = [];
		a_weapons["Dev Block strings are not supported"] = [];
		a_weapons["Dev Block strings are not supported"] = [];
		var_42bc0e48 = function_d661ce6();
		foreach(weapon in level.tbl_weaponIDs)
		{
			gun = [];
			gun["Dev Block strings are not supported"] = weapon["Dev Block strings are not supported"];
			gun["Dev Block strings are not supported"] = GetItemIndexFromRef(weapon["Dev Block strings are not supported"]);
			gun["Dev Block strings are not supported"] = [];
			var_311c337b = StrTok(weapon["Dev Block strings are not supported"], "Dev Block strings are not supported");
			foreach(attachment in var_311c337b)
			{
				gun["Dev Block strings are not supported"][attachment] = [];
				gun["Dev Block strings are not supported"][attachment]["Dev Block strings are not supported"] = function_e0e8d954(attachment);
				gun["Dev Block strings are not supported"][attachment]["Dev Block strings are not supported"] = tableLookup(var_42bc0e48, var_ed402ca6, gun["Dev Block strings are not supported"], var_47c6ecb9, attachment, var_2ce93f4e);
				gun["Dev Block strings are not supported"][attachment]["Dev Block strings are not supported"] = tableLookup(var_42bc0e48, var_ed402ca6, gun["Dev Block strings are not supported"], var_47c6ecb9, attachment, var_374718d1);
			}
			switch(weapon["Dev Block strings are not supported"])
			{
				case "Dev Block strings are not supported":
				{
					if(weapon["Dev Block strings are not supported"] != "Dev Block strings are not supported")
					{
						ArrayInsert(a_weapons["Dev Block strings are not supported"], gun, 0);
					}
					break;
				}
				case "Dev Block strings are not supported":
				{
					ArrayInsert(a_weapons["Dev Block strings are not supported"], gun, 0);
					break;
				}
				case "Dev Block strings are not supported":
				{
					ArrayInsert(a_weapons["Dev Block strings are not supported"], gun, 0);
					break;
				}
				case "Dev Block strings are not supported":
				{
					ArrayInsert(a_weapons["Dev Block strings are not supported"], gun, 0);
					break;
				}
				case "Dev Block strings are not supported":
				{
					ArrayInsert(a_weapons["Dev Block strings are not supported"], gun, 0);
					break;
				}
				case "Dev Block strings are not supported":
				{
					ArrayInsert(a_weapons["Dev Block strings are not supported"], gun, 0);
					break;
				}
				case "Dev Block strings are not supported":
				{
					ArrayInsert(a_weapons["Dev Block strings are not supported"], gun, 0);
					break;
				}
				case "Dev Block strings are not supported":
				{
					ArrayInsert(a_weapons["Dev Block strings are not supported"], gun, 0);
					break;
				}
				case default:
				{
					break;
				}
			}
		}
		foreach(var_ba41c56d in a_weapons)
		{
			foreach(var_ef156e02 in var_ba41c56d)
			{
				foreach(var_10e20df5 in var_ef156e02["Dev Block strings are not supported"])
				{
					var_ba046d31 = var_e018f980 + group_name + "Dev Block strings are not supported" + var_ba41c56d[gun]["Dev Block strings are not supported"] + "Dev Block strings are not supported" + attachment;
					AddDebugCommand(var_ba046d31 + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + var_10e20df5["Dev Block strings are not supported"] + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + var_10e20df5["Dev Block strings are not supported"] + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + var_ba41c56d[gun]["Dev Block strings are not supported"] + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + var_10e20df5["Dev Block strings are not supported"] + "Dev Block strings are not supported");
				}
			}
			wait(0.05);
		}
		level thread function_503b1c43();
	#/
}

/*
	Name: function_503b1c43
	Namespace: popups
	Checksum: 0x7DF47C8F
	Offset: 0x14B0
	Size: 0x155
	Parameters: 0
	Flags: None
*/
function function_503b1c43()
{
	/#
		for(;;)
		{
			var_be219c34 = GetDvarInt("Dev Block strings are not supported");
			if(var_be219c34 == 0)
			{
				wait(0.05);
				continue;
			}
			var_9e7ab2f5 = GetDvarInt("Dev Block strings are not supported");
			var_a0fa640f = GetDvarInt("Dev Block strings are not supported");
			var_5c1bbe91 = GetDvarInt("Dev Block strings are not supported");
			level.players[0] persistence::CodeCallback_GunChallengeComplete(var_9e7ab2f5, var_a0fa640f, var_be219c34, var_5c1bbe91);
			SetDvar("Dev Block strings are not supported", 0);
			SetDvar("Dev Block strings are not supported", 0);
			SetDvar("Dev Block strings are not supported", 0);
			SetDvar("Dev Block strings are not supported", 0);
			wait(1);
		}
	#/
}

/*
	Name: function_eafd7f5b
	Namespace: popups
	Checksum: 0xE91159F8
	Offset: 0x1610
	Size: 0x32B
	Parameters: 0
	Flags: None
*/
function function_eafd7f5b()
{
	/#
		var_1f037201 = "Dev Block strings are not supported";
		for(i = 1; i <= function_bcf0ce52(); i++)
		{
			tableName = function_5f5fa154(i);
			rows = function_1556496c(tableName);
			for(j = 1; j < rows; j++)
			{
				var_9a0d8e07 = TableLookupColumnForRow(tableName, j, 0);
				if(var_9a0d8e07 != "Dev Block strings are not supported" && StrIsInt(TableLookupColumnForRow(tableName, j, 0)))
				{
					challengeString = TableLookupColumnForRow(tableName, j, 5);
					type = TableLookupColumnForRow(tableName, j, 3);
					challengeTier = Int(TableLookupColumnForRow(tableName, j, 1));
					var_9a5d32ff = "Dev Block strings are not supported" + challengeTier;
					if(challengeTier < 10)
					{
						var_9a5d32ff = "Dev Block strings are not supported" + challengeTier;
					}
					name = TableLookupColumnForRow(tableName, j, 5);
					var_61711a6a = var_1f037201 + type + "Dev Block strings are not supported" + MakeLocalizedString(name) + "Dev Block strings are not supported" + var_9a5d32ff + "Dev Block strings are not supported" + var_9a0d8e07;
					AddDebugCommand(var_61711a6a + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + j + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + i + "Dev Block strings are not supported");
					if(Int(var_9a0d8e07) % 10 == 0)
					{
						wait(0.05);
					}
				}
			}
		}
		level thread function_7ece286a();
	#/
}

/*
	Name: function_7ece286a
	Namespace: popups
	Checksum: 0xB79669BD
	Offset: 0x1948
	Size: 0x345
	Parameters: 0
	Flags: None
*/
function function_7ece286a()
{
	/#
		SetDvar("Dev Block strings are not supported", 0);
		SetDvar("Dev Block strings are not supported", 0);
		for(;;)
		{
			row = GetDvarInt("Dev Block strings are not supported");
			table = GetDvarInt("Dev Block strings are not supported");
			if(table < 1 || table > function_bcf0ce52())
			{
				wait(0.05);
				continue;
			}
			tableName = function_5f5fa154(table);
			if(row < 1 || row > function_1556496c(tableName))
			{
				wait(0.05);
				continue;
			}
			type = TableLookupColumnForRow(tableName, row, 3);
			itemIndex = 0;
			if(type == "Dev Block strings are not supported")
			{
				type = 0;
			}
			else if(type == "Dev Block strings are not supported")
			{
				itemIndex = 4;
				type = 3;
			}
			else if(type == "Dev Block strings are not supported")
			{
				itemIndex = 1;
				type = 4;
			}
			else if(type == "Dev Block strings are not supported")
			{
				type = 2;
			}
			else if(type == "Dev Block strings are not supported")
			{
				type = 5;
			}
			else
			{
				itemIndex = 23;
				type = 1;
			}
			var_5f763e28 = Int(TableLookupColumnForRow(tableName, row, 6));
			var_9a0d8e07 = Int(TableLookupColumnForRow(tableName, row, 0));
			maxValue = Int(TableLookupColumnForRow(tableName, row, 2));
			level.players[0] persistence::CodeCallback_ChallengeComplete(var_5f763e28, maxValue, row, table - 1, type, itemIndex, var_9a0d8e07);
			SetDvar("Dev Block strings are not supported", 0);
			SetDvar("Dev Block strings are not supported", 0);
			wait(1);
		}
	#/
}

/*
	Name: popupsFromConsole
	Namespace: popups
	Checksum: 0x7829FCCA
	Offset: 0x1C98
	Size: 0x6A7
	Parameters: 0
	Flags: None
*/
function popupsFromConsole()
{
	/#
		while(1)
		{
			timeout = GetDvarFloat("Dev Block strings are not supported", 1);
			if(timeout == 0)
			{
				timeout = 1;
			}
			wait(timeout);
			medal = GetDvarInt("Dev Block strings are not supported", 0);
			challenge = GetDvarInt("Dev Block strings are not supported", 0);
			rank = GetDvarInt("Dev Block strings are not supported", 0);
			gun = GetDvarInt("Dev Block strings are not supported", 0);
			contractPass = GetDvarInt("Dev Block strings are not supported", 0);
			contractFail = GetDvarInt("Dev Block strings are not supported", 0);
			gameModeMsg = GetDvarInt("Dev Block strings are not supported", 0);
			teamMsg = GetDvarInt("Dev Block strings are not supported", 0);
			challengeIndex = GetDvarInt("Dev Block strings are not supported", 1);
			for(i = 0; i < medal; i++)
			{
				level.players[0] Medals::CodeCallback_Medal(86);
			}
			for(i = 0; i < challenge; i++)
			{
				level.players[0] persistence::CodeCallback_ChallengeComplete(1000, 10, 19, 0, 0, 0, 18);
				level.players[0] persistence::CodeCallback_ChallengeComplete(1000, 1, 21, 0, 0, 0, 20);
				rewardXP = 500;
				maxVal = 1;
				row = 1;
				tableNumber = 0;
				challengeType = 1;
				itemIndex = 111;
				challengeIndex = 0;
				maxVal = 50;
				row = 1;
				tableNumber = 2;
				challengeType = 1;
				itemIndex = 20;
				challengeIndex = 512;
				maxVal = 150;
				row = 100;
				tableNumber = 2;
				challengeType = 4;
				itemIndex = 1;
				challengeIndex = 611;
				level.players[0] persistence::CodeCallback_ChallengeComplete(rewardXP, maxVal, row, tableNumber, challengeType, itemIndex, challengeIndex);
			}
			for(i = 0; i < rank; i++)
			{
				level.players[0] rank::CodeCallback_RankUp(4, 0, 1);
			}
			for(i = 0; i < gun; i++)
			{
				level.players[0] persistence::CodeCallback_GunChallengeComplete(0, 20, 25, 0);
			}
			for(i = 0; i < contractPass; i++)
			{
				level.players[0] persistence::add_contract_to_queue(12, 1);
			}
			for(i = 0; i < contractFail; i++)
			{
				level.players[0] persistence::add_contract_to_queue(12, 0);
			}
			for(i = 0; i < teamMsg; i++)
			{
				player = level.players[0];
				if(isdefined(level.players[1]))
				{
					player = level.players[1];
				}
				level.players[0] DisplayTeamMessageToAll(&"Dev Block strings are not supported", player);
			}
			reset = GetDvarInt("Dev Block strings are not supported", 1);
			if(reset)
			{
				if(medal)
				{
					SetDvar("Dev Block strings are not supported", 0);
				}
				if(challenge)
				{
					SetDvar("Dev Block strings are not supported", 0);
				}
				if(gun)
				{
					SetDvar("Dev Block strings are not supported", 0);
				}
				if(rank)
				{
					SetDvar("Dev Block strings are not supported", 0);
				}
				if(contractPass)
				{
					SetDvar("Dev Block strings are not supported", 0);
				}
				if(contractFail)
				{
					SetDvar("Dev Block strings are not supported", 0);
				}
				if(gameModeMsg)
				{
					SetDvar("Dev Block strings are not supported", 0);
				}
				if(teamMsg)
				{
					SetDvar("Dev Block strings are not supported", 0);
				}
			}
		}
	#/
}

/*
	Name: DisplayKillstreakTeamMessageToAll
	Namespace: popups
	Checksum: 0x2092EBE5
	Offset: 0x2348
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function DisplayKillstreakTeamMessageToAll(killstreak, player)
{
	if(!isdefined(level.killstreaks[killstreak]))
	{
		return;
	}
	if(!isdefined(level.killstreaks[killstreak].inboundtext))
	{
		return;
	}
	message = level.killstreaks[killstreak].inboundtext;
	self DisplayTeamMessageToAll(message, player);
}

/*
	Name: DisplayKillstreakHackedTeamMessageToAll
	Namespace: popups
	Checksum: 0x88CD6A5F
	Offset: 0x23E0
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function DisplayKillstreakHackedTeamMessageToAll(killstreak, player)
{
	if(!isdefined(level.killstreaks[killstreak]))
	{
		return;
	}
	if(!isdefined(level.killstreaks[killstreak].hackedText))
	{
		return;
	}
	message = level.killstreaks[killstreak].hackedText;
	self DisplayTeamMessageToAll(message, player);
}

/*
	Name: shouldDisplayTeamMessages
	Namespace: popups
	Checksum: 0xB7681166
	Offset: 0x2478
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function shouldDisplayTeamMessages()
{
	if(level.hardcoreMode == 1 || level.Splitscreen == 1)
	{
		return 0;
	}
	return 1;
}

/*
	Name: DisplayTeamMessageToAll
	Namespace: popups
	Checksum: 0x2D8E08C5
	Offset: 0x24B0
	Size: 0x135
	Parameters: 2
	Flags: None
*/
function DisplayTeamMessageToAll(message, player)
{
	if(!shouldDisplayTeamMessages())
	{
		return;
	}
	for(i = 0; i < level.players.size; i++)
	{
		cur_player = level.players[i];
		if(cur_player IsEmpJammed())
		{
			continue;
		}
		SIZE = cur_player.teamMessageQueue.size;
		if(SIZE >= level.teamMessageQueueMax)
		{
			continue;
		}
		cur_player.teamMessageQueue[SIZE] = spawnstruct();
		cur_player.teamMessageQueue[SIZE].message = message;
		cur_player.teamMessageQueue[SIZE].player = player;
		cur_player notify("received teammessage");
	}
}

/*
	Name: DisplayTeamMessageToTeam
	Namespace: popups
	Checksum: 0xA1846B22
	Offset: 0x25F0
	Size: 0x155
	Parameters: 3
	Flags: None
*/
function DisplayTeamMessageToTeam(message, player, team)
{
	if(!shouldDisplayTeamMessages())
	{
		return;
	}
	for(i = 0; i < level.players.size; i++)
	{
		cur_player = level.players[i];
		if(cur_player.team != team)
		{
			continue;
		}
		if(cur_player IsEmpJammed())
		{
			continue;
		}
		SIZE = cur_player.teamMessageQueue.size;
		if(SIZE >= level.teamMessageQueueMax)
		{
			continue;
		}
		cur_player.teamMessageQueue[SIZE] = spawnstruct();
		cur_player.teamMessageQueue[SIZE].message = message;
		cur_player.teamMessageQueue[SIZE].player = player;
		cur_player notify("received teammessage");
	}
}

/*
	Name: displayTeamMessageWaiter
	Namespace: popups
	Checksum: 0xACF6B28A
	Offset: 0x2750
	Size: 0x14F
	Parameters: 0
	Flags: None
*/
function displayTeamMessageWaiter()
{
	if(!shouldDisplayTeamMessages())
	{
		return;
	}
	self endon("disconnect");
	level endon("game_ended");
	self.teamMessageQueue = [];
	while(self.teamMessageQueue.size == 0)
	{
		self waittill("received teammessage");
		if(self.teamMessageQueue.size > 0)
		{
			nextNotifyData = self.teamMessageQueue[0];
			ArrayRemoveIndex(self.teamMessageQueue, 0, 0);
			if(!isdefined(nextNotifyData.player) || !isPlayer(nextNotifyData.player))
			{
			}
			else if(self IsEmpJammed())
			{
			}
			self LUINotifyEvent(&"player_callout", 2, nextNotifyData.message, nextNotifyData.player.entnum);
		}
		else
		{
			wait(level.teamMessage.waitTime);
		}
	}
}

/*
	Name: displayPopupsWaiter
	Namespace: popups
	Checksum: 0x928D1EB1
	Offset: 0x28A8
	Size: 0x299
	Parameters: 0
	Flags: None
*/
function displayPopupsWaiter()
{
	self endon("disconnect");
	self.rankNotifyQueue = [];
	if(!isdefined(self.pers["challengeNotifyQueue"]))
	{
		self.pers["challengeNotifyQueue"] = [];
	}
	if(!isdefined(self.pers["contractNotifyQueue"]))
	{
		self.pers["contractNotifyQueue"] = [];
	}
	self.messageNotifyQueue = [];
	self.startMessageNotifyQueue = [];
	self.wagerNotifyQueue = [];
	while(isdefined(level) && isdefined(level.gameEnded) && !level.gameEnded)
	{
		if(!isdefined(self) || !isdefined(self.startMessageNotifyQueue) || !isdefined(self.messageNotifyQueue))
		{
			break;
		}
		if(self.startMessageNotifyQueue.size == 0 && self.messageNotifyQueue.size == 0)
		{
			self waittill("received award");
		}
		waittillframeend;
		if(!isdefined(level))
		{
			break;
		}
		if(!isdefined(level.gameEnded))
		{
			break;
		}
		if(level.gameEnded)
		{
			break;
		}
		if(self.startMessageNotifyQueue.size > 0)
		{
			nextNotifyData = self.startMessageNotifyQueue[0];
			ArrayRemoveIndex(self.startMessageNotifyQueue, 0, 0);
			if(isdefined(nextNotifyData.duration))
			{
				duration = nextNotifyData.duration;
			}
			else
			{
				duration = level.startMessageDefaultDuration;
			}
			self hud_message::showNotifyMessage(nextNotifyData, duration);
			wait(duration);
		}
		else if(self.messageNotifyQueue.size > 0)
		{
			nextNotifyData = self.messageNotifyQueue[0];
			ArrayRemoveIndex(self.messageNotifyQueue, 0, 0);
			if(isdefined(nextNotifyData.duration))
			{
				duration = nextNotifyData.duration;
			}
			else
			{
				duration = level.regularGameMessages.waitTime;
			}
			self hud_message::showNotifyMessage(nextNotifyData, duration);
		}
		else
		{
			wait(1);
		}
	}
}

/*
	Name: milestoneNotify
	Namespace: popups
	Checksum: 0x7F32B7F5
	Offset: 0x2B50
	Size: 0x129
	Parameters: 4
	Flags: None
*/
function milestoneNotify(index, itemIndex, type, tier)
{
	level.globalChallenges++;
	if(!isdefined(type))
	{
		type = "global";
	}
	SIZE = self.pers["challengeNotifyQueue"].size;
	self.pers["challengeNotifyQueue"][SIZE] = [];
	self.pers["challengeNotifyQueue"][SIZE]["tier"] = tier;
	self.pers["challengeNotifyQueue"][SIZE]["index"] = index;
	self.pers["challengeNotifyQueue"][SIZE]["itemIndex"] = itemIndex;
	self.pers["challengeNotifyQueue"][SIZE]["type"] = type;
	self notify("received award");
}

