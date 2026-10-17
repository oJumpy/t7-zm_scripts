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
	Name: devgui_notif_getgunleveltablename
	Namespace: popups
	Checksum: 0xB34EB0A6
	Offset: 0x510
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function devgui_notif_getgunleveltablename()
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
	Name: devgui_notif_getchallengestablecount
	Namespace: popups
	Checksum: 0xA0AAB2C2
	Offset: 0x570
	Size: 0x4D
	Parameters: 0
	Flags: None
*/
function devgui_notif_getchallengestablecount()
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
	Name: devgui_notif_getchallengestablename
	Namespace: popups
	Checksum: 0x6CFDA47E
	Offset: 0x5C8
	Size: 0x89
	Parameters: 1
	Flags: None
*/
function devgui_notif_getchallengestablename(tableID)
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
	Name: devgui_create_weapon_levels_table
	Namespace: popups
	Checksum: 0xBED6750F
	Offset: 0x6B0
	Size: 0x205
	Parameters: 0
	Flags: None
*/
function devgui_create_weapon_levels_table()
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
		util::add_devgui(var_deda26ca + "Dev Block strings are not supported", "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
		while(1)
		{
			if(GetDvarInt("Dev Block strings are not supported", 0) > 0)
			{
				util::remove_devgui(var_deda26ca);
				level thread devgui_notif_init();
				break;
			}
			wait(1);
		}
	#/
}

/*
	Name: devgui_notif_init
	Namespace: popups
	Checksum: 0x6C6630A3
	Offset: 0x9E0
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function devgui_notif_init()
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
		level thread notif_devgui_rank();
		level thread notif_devgui_gun_rank();
		if(!SessionModeIsCampaignGame())
		{
			level thread notif_devgui_challenges();
		}
	#/
}

/*
	Name: notif_devgui_rank
	Namespace: popups
	Checksum: 0xA431CF3
	Offset: 0xAD8
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function notif_devgui_rank()
{
	/#
		if(!isdefined(level.rankTable))
		{
			return;
		}
		notif_rank_devgui_base = "Dev Block strings are not supported";
		for(i = 1; i < level.rankTable.size; i++)
		{
			display_level = i + 1;
			if(display_level < 10)
			{
				display_level = "Dev Block strings are not supported" + display_level;
			}
			AddDebugCommand(notif_rank_devgui_base + display_level + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + i + "Dev Block strings are not supported");
			if(i % 10 == 0)
			{
				wait(0.05);
			}
		}
		wait(0.05);
		level thread notif_devgui_rank_up_think();
	#/
}

/*
	Name: notif_devgui_rank_up_think
	Namespace: popups
	Checksum: 0x71C447B5
	Offset: 0xC08
	Size: 0x95
	Parameters: 0
	Flags: None
*/
function notif_devgui_rank_up_think()
{
	/#
		for(;;)
		{
			rank_number = GetDvarInt("Dev Block strings are not supported");
			if(rank_number == 0)
			{
				wait(0.05);
				continue;
			}
			level.players[0] rank::CodeCallback_RankUp(rank_number, 0, 1);
			SetDvar("Dev Block strings are not supported", 0);
			wait(1);
		}
	#/
}

/*
	Name: notif_devgui_gun_rank
	Namespace: popups
	Checksum: 0x3982CB3B
	Offset: 0xCA8
	Size: 0x7FB
	Parameters: 0
	Flags: None
*/
function notif_devgui_gun_rank()
{
	/#
		notif_gun_rank_devgui_base = "Dev Block strings are not supported";
		gunlevel_rankid_col = 0;
		gunlevel_gunref_col = 2;
		gunlevel_attachment_unlock_col = 3;
		gunlevel_xpgained_col = 4;
		level flag::wait_till("Dev Block strings are not supported");
		if(!isdefined(level.tbl_weaponIDs))
		{
			devgui_create_weapon_levels_table();
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
		gun_levels_table = devgui_notif_getgunleveltablename();
		foreach(weapon in level.tbl_weaponIDs)
		{
			gun = [];
			gun["Dev Block strings are not supported"] = weapon["Dev Block strings are not supported"];
			gun["Dev Block strings are not supported"] = GetItemIndexFromRef(weapon["Dev Block strings are not supported"]);
			gun["Dev Block strings are not supported"] = [];
			gun_weapon_attachments = StrTok(weapon["Dev Block strings are not supported"], "Dev Block strings are not supported");
			foreach(attachment in gun_weapon_attachments)
			{
				gun["Dev Block strings are not supported"][attachment] = [];
				gun["Dev Block strings are not supported"][attachment]["Dev Block strings are not supported"] = getattachmenttableindex(attachment);
				gun["Dev Block strings are not supported"][attachment]["Dev Block strings are not supported"] = tableLookup(gun_levels_table, gunlevel_gunref_col, gun["Dev Block strings are not supported"], gunlevel_attachment_unlock_col, attachment, gunlevel_rankid_col);
				gun["Dev Block strings are not supported"][attachment]["Dev Block strings are not supported"] = tableLookup(gun_levels_table, gunlevel_gunref_col, gun["Dev Block strings are not supported"], gunlevel_attachment_unlock_col, attachment, gunlevel_xpgained_col);
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
		foreach(gun_group in a_weapons)
		{
			foreach(attachment_group in gun_group)
			{
				foreach(attachment_data in attachment_group["Dev Block strings are not supported"])
				{
					devgui_cmd_gun_path = notif_gun_rank_devgui_base + group_name + "Dev Block strings are not supported" + gun_group[gun]["Dev Block strings are not supported"] + "Dev Block strings are not supported" + attachment;
					AddDebugCommand(devgui_cmd_gun_path + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + attachment_data["Dev Block strings are not supported"] + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + attachment_data["Dev Block strings are not supported"] + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + gun_group[gun]["Dev Block strings are not supported"] + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + attachment_data["Dev Block strings are not supported"] + "Dev Block strings are not supported");
				}
			}
			wait(0.05);
		}
		level thread notif_devgui_gun_level_think();
	#/
}

/*
	Name: notif_devgui_gun_level_think
	Namespace: popups
	Checksum: 0x7DF47C8F
	Offset: 0x14B0
	Size: 0x155
	Parameters: 0
	Flags: None
*/
function notif_devgui_gun_level_think()
{
	/#
		for(;;)
		{
			weapon_item_index = GetDvarInt("Dev Block strings are not supported");
			if(weapon_item_index == 0)
			{
				wait(0.05);
				continue;
			}
			xp_reward = GetDvarInt("Dev Block strings are not supported");
			attachment_index = GetDvarInt("Dev Block strings are not supported");
			rank_id = GetDvarInt("Dev Block strings are not supported");
			level.players[0] persistence::CodeCallback_GunChallengeComplete(xp_reward, attachment_index, weapon_item_index, rank_id);
			SetDvar("Dev Block strings are not supported", 0);
			SetDvar("Dev Block strings are not supported", 0);
			SetDvar("Dev Block strings are not supported", 0);
			SetDvar("Dev Block strings are not supported", 0);
			wait(1);
		}
	#/
}

/*
	Name: notif_devgui_challenges
	Namespace: popups
	Checksum: 0xE91159F8
	Offset: 0x1610
	Size: 0x32B
	Parameters: 0
	Flags: None
*/
function notif_devgui_challenges()
{
	/#
		notif_challenges_devgui_base = "Dev Block strings are not supported";
		for(i = 1; i <= devgui_notif_getchallengestablecount(); i++)
		{
			tableName = devgui_notif_getchallengestablename(i);
			rows = tablelookuprowcount(tableName);
			for(j = 1; j < rows; j++)
			{
				challengeid = TableLookupColumnForRow(tableName, j, 0);
				if(challengeid != "Dev Block strings are not supported" && StrIsInt(TableLookupColumnForRow(tableName, j, 0)))
				{
					challengeString = TableLookupColumnForRow(tableName, j, 5);
					type = TableLookupColumnForRow(tableName, j, 3);
					challengeTier = Int(TableLookupColumnForRow(tableName, j, 1));
					challengetierstring = "Dev Block strings are not supported" + challengeTier;
					if(challengeTier < 10)
					{
						challengetierstring = "Dev Block strings are not supported" + challengeTier;
					}
					name = TableLookupColumnForRow(tableName, j, 5);
					devgui_cmd_challenge_path = notif_challenges_devgui_base + type + "Dev Block strings are not supported" + MakeLocalizedString(name) + "Dev Block strings are not supported" + challengetierstring + "Dev Block strings are not supported" + challengeid;
					AddDebugCommand(devgui_cmd_challenge_path + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + j + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + i + "Dev Block strings are not supported");
					if(Int(challengeid) % 10 == 0)
					{
						wait(0.05);
					}
				}
			}
		}
		level thread notif_devgui_challenges_think();
	#/
}

/*
	Name: notif_devgui_challenges_think
	Namespace: popups
	Checksum: 0xB79669BD
	Offset: 0x1948
	Size: 0x345
	Parameters: 0
	Flags: None
*/
function notif_devgui_challenges_think()
{
	/#
		SetDvar("Dev Block strings are not supported", 0);
		SetDvar("Dev Block strings are not supported", 0);
		for(;;)
		{
			row = GetDvarInt("Dev Block strings are not supported");
			table = GetDvarInt("Dev Block strings are not supported");
			if(table < 1 || table > devgui_notif_getchallengestablecount())
			{
				wait(0.05);
				continue;
			}
			tableName = devgui_notif_getchallengestablename(table);
			if(row < 1 || row > tablelookuprowcount(tableName))
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
			xpreward = Int(TableLookupColumnForRow(tableName, row, 6));
			challengeid = Int(TableLookupColumnForRow(tableName, row, 0));
			maxValue = Int(TableLookupColumnForRow(tableName, row, 2));
			level.players[0] persistence::CodeCallback_ChallengeComplete(xpreward, maxValue, row, table - 1, type, itemIndex, challengeid);
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

