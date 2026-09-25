#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace hud_message;

/*
	Name: __init__sytem__
	Namespace: hud_message
	Checksum: 0x3506DA05
	Offset: 0x210
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("hud_message", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: hud_message
	Checksum: 0x1BB5DB15
	Offset: 0x250
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
	Namespace: hud_message
	Checksum: 0x87DBBE5E
	Offset: 0x280
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function init()
{
	callback::on_connect(&on_player_connect);
	callback::on_disconnect(&on_player_disconnect);
}

/*
	Name: on_player_connect
	Namespace: hud_message
	Checksum: 0x7311A22B
	Offset: 0x2D0
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self thread hintMessageDeathThink();
	self thread lowerMessageThink();
	self thread initNotifyMessage();
	self thread initCustomGametypeHeader();
}

/*
	Name: on_player_disconnect
	Namespace: hud_message
	Checksum: 0x49C5D77
	Offset: 0x340
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function on_player_disconnect()
{
	if(isdefined(self.customGametypeHeader))
	{
		self.customGametypeHeader destroy();
	}
	if(isdefined(self.customGametypeSubHeader))
	{
		self.customGametypeSubHeader destroy();
	}
}

/*
	Name: initCustomGametypeHeader
	Namespace: hud_message
	Checksum: 0xE5E223EC
	Offset: 0x3A0
	Size: 0x1D3
	Parameters: 0
	Flags: None
*/
function initCustomGametypeHeader()
{
	font = "default";
	titleSize = 2.5;
	self.customGametypeHeader = hud::createFontString(font, titleSize);
	self.customGametypeHeader hud::setPoint("TOP", undefined, 0, 30);
	self.customGametypeHeader.glowAlpha = 1;
	self.customGametypeHeader.hidewheninmenu = 1;
	self.customGametypeHeader.archived = 0;
	self.customGametypeHeader.color = (1, 1, 0.6);
	self.customGametypeHeader.alpha = 1;
	titleSize = 2;
	self.customGametypeSubHeader = hud::createFontString(font, titleSize);
	self.customGametypeSubHeader hud::setParent(self.customGametypeHeader);
	self.customGametypeSubHeader hud::setPoint("TOP", "BOTTOM", 0, 0);
	self.customGametypeSubHeader.glowAlpha = 1;
	self.customGametypeSubHeader.hidewheninmenu = 1;
	self.customGametypeSubHeader.archived = 0;
	self.customGametypeSubHeader.color = (1, 1, 0.6);
	self.customGametypeSubHeader.alpha = 1;
}

/*
	Name: hintMessage
	Namespace: hud_message
	Checksum: 0x7D1C6755
	Offset: 0x580
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function hintMessage(hintText, duration)
{
	notifyData = spawnstruct();
	notifyData.notifyText = hintText;
	notifyData.duration = duration;
	notifyMessage(notifyData);
}

/*
	Name: hintMessagePlayers
	Namespace: hud_message
	Checksum: 0x325610D
	Offset: 0x5F8
	Size: 0xAD
	Parameters: 3
	Flags: None
*/
function hintMessagePlayers(players, hintText, duration)
{
	notifyData = spawnstruct();
	notifyData.notifyText = hintText;
	notifyData.duration = duration;
	for(i = 0; i < players.size; i++)
	{
		players[i] notifyMessage(notifyData);
	}
}

/*
	Name: showInitialFactionPopup
	Namespace: hud_message
	Checksum: 0x4286D2D8
	Offset: 0x6B0
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function showInitialFactionPopup(team)
{
	self LUINotifyEvent(&"faction_popup", 1, game["strings"][team + "_name"]);
	oldNotifyMessage(undefined, undefined, undefined, undefined);
}

/*
	Name: initNotifyMessage
	Namespace: hud_message
	Checksum: 0xC8ABAD1D
	Offset: 0x718
	Size: 0x4CF
	Parameters: 0
	Flags: None
*/
function initNotifyMessage()
{
	if(!SessionModeIsZombiesGame())
	{
		if(self IsSplitscreen())
		{
			titleSize = 2;
			textSize = 1.4;
			iconSize = 24;
			font = "big";
			point = "TOP";
			relativePoint = "BOTTOM";
			yOffset = 30;
			xOffset = 30;
		}
		else
		{
			titleSize = 2.5;
			textSize = 1.75;
			iconSize = 30;
			font = "big";
			point = "TOP";
			relativePoint = "BOTTOM";
			yOffset = 0;
			xOffset = 0;
		}
	}
	else if(self IsSplitscreen())
	{
		titleSize = 2;
		textSize = 1.4;
		iconSize = 24;
		font = "big";
		point = "TOP";
		relativePoint = "BOTTOM";
		yOffset = 30;
		xOffset = 30;
	}
	else
	{
		titleSize = 2.5;
		textSize = 1.75;
		iconSize = 30;
		font = "big";
		point = "BOTTOM LEFT";
		relativePoint = "TOP";
		yOffset = 0;
		xOffset = 0;
	}
	self.notifyTitle = hud::createFontString(font, titleSize);
	self.notifyTitle hud::setPoint(point, undefined, xOffset, yOffset);
	self.notifyTitle.glowAlpha = 1;
	self.notifyTitle.hidewheninmenu = 1;
	self.notifyTitle.archived = 0;
	self.notifyTitle.alpha = 0;
	self.notifyText = hud::createFontString(font, textSize);
	self.notifyText hud::setParent(self.notifyTitle);
	self.notifyText hud::setPoint(point, relativePoint, 0, 0);
	self.notifyText.glowAlpha = 1;
	self.notifyText.hidewheninmenu = 1;
	self.notifyText.archived = 0;
	self.notifyText.alpha = 0;
	self.notifyText2 = hud::createFontString(font, textSize);
	self.notifyText2 hud::setParent(self.notifyTitle);
	self.notifyText2 hud::setPoint(point, relativePoint, 0, 0);
	self.notifyText2.glowAlpha = 1;
	self.notifyText2.hidewheninmenu = 1;
	self.notifyText2.archived = 0;
	self.notifyText2.alpha = 0;
	self.notifyIcon = hud::createIcon("white", iconSize, iconSize);
	self.notifyIcon hud::setParent(self.notifyText2);
	self.notifyIcon hud::setPoint(point, relativePoint, 0, 0);
	self.notifyIcon.hidewheninmenu = 1;
	self.notifyIcon.archived = 0;
	self.notifyIcon.alpha = 0;
	self.doingNotify = 0;
	self.notifyQueue = [];
}

/*
	Name: oldNotifyMessage
	Namespace: hud_message
	Checksum: 0xB6EB90C5
	Offset: 0xBF0
	Size: 0xF5
	Parameters: 6
	Flags: None
*/
function oldNotifyMessage(titleText, notifyText, iconName, glowColor, sound, duration)
{
	if(level.wagerMatch && !level.teambased)
	{
		return;
	}
	notifyData = spawnstruct();
	notifyData.titleText = titleText;
	notifyData.notifyText = notifyText;
	notifyData.iconName = iconName;
	notifyData.sound = sound;
	notifyData.duration = duration;
	self.startMessageNotifyQueue[self.startMessageNotifyQueue.size] = notifyData;
	self notify("received award");
}

/*
	Name: notifyMessage
	Namespace: hud_message
	Checksum: 0xABA1D943
	Offset: 0xCF0
	Size: 0x5D
	Parameters: 1
	Flags: None
*/
function notifyMessage(notifyData)
{
	self endon("death");
	self endon("disconnect");
	if(!isdefined(self.messageNotifyQueue))
	{
		self.messageNotifyQueue = [];
	}
	self.messageNotifyQueue[self.messageNotifyQueue.size] = notifyData;
	self notify("received award");
}

/*
	Name: playNotifyLoop
	Namespace: hud_message
	Checksum: 0xE940172F
	Offset: 0xD58
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function playNotifyLoop(duration)
{
	playNotifyLoop = spawn("script_origin", (0, 0, 0));
	playNotifyLoop PlayLoopSound("uin_notify_data_loop");
	duration = duration - 4;
	if(duration < 1)
	{
		duration = 1;
	}
	wait(duration);
	playNotifyLoop delete();
}

/*
	Name: showNotifyMessage
	Namespace: hud_message
	Checksum: 0x859CACCE
	Offset: 0xE00
	Size: 0x79B
	Parameters: 2
	Flags: None
*/
function showNotifyMessage(notifyData, duration)
{
	self endon("disconnect");
	self.doingNotify = 1;
	waitRequireVisibility(0);
	self notify("notifyMessageBegin", duration);
	self thread resetOnCancel();
	if(isdefined(notifyData.sound))
	{
		self playlocalsound(notifyData.sound);
	}
	if(isdefined(notifyData.musicState))
	{
		self music::setmusicstate(notifyData.music);
	}
	if(isdefined(notifyData.leaderSound))
	{
		if(isdefined(level.globallogic_audio_dialog_on_player_override))
		{
			self [[level.globallogic_audio_dialog_on_player_override]](notifyData.leaderSound);
		}
	}
	if(isdefined(notifyData.glowColor))
	{
		glowColor = notifyData.glowColor;
	}
	else
	{
		glowColor = (0, 0, 0);
	}
	if(isdefined(notifyData.color))
	{
		color = notifyData.color;
	}
	else
	{
		color = (1, 1, 1);
	}
	anchorElem = self.notifyTitle;
	if(isdefined(notifyData.titleText))
	{
		if(isdefined(notifyData.titleLabel))
		{
			self.notifyTitle.label = notifyData.titleLabel;
		}
		else
		{
			self.notifyTitle.label = &"";
		}
		if(isdefined(notifyData.titleLabel) && !isdefined(notifyData.titleIsString))
		{
			self.notifyTitle setValue(notifyData.titleText);
		}
		else
		{
			self.notifyTitle setText(notifyData.titleText);
		}
		self.notifyTitle setCOD7DecodeFX(200, Int(duration * 1000), 600);
		self.notifyTitle.glowColor = glowColor;
		self.notifyTitle.color = color;
		self.notifyTitle.alpha = 1;
	}
	if(isdefined(notifyData.notifyText))
	{
		if(isdefined(notifyData.textLabel))
		{
			self.notifyText.label = notifyData.textLabel;
		}
		else
		{
			self.notifyText.label = &"";
		}
		if(isdefined(notifyData.textLabel) && !isdefined(notifyData.textIsString))
		{
			self.notifyText setValue(notifyData.notifyText);
		}
		else
		{
			self.notifyText setText(notifyData.notifyText);
		}
		self.notifyText setCOD7DecodeFX(100, Int(duration * 1000), 600);
		self.notifyText.glowColor = glowColor;
		self.notifyText.color = color;
		self.notifyText.alpha = 1;
		anchorElem = self.notifyText;
	}
	if(isdefined(notifyData.notifyText2))
	{
		if(self IsSplitscreen())
		{
			if(isdefined(notifyData.text2Label))
			{
				self IPrintLnBold(notifyData.text2Label, notifyData.notifyText2);
			}
			else
			{
				self IPrintLnBold(notifyData.notifyText2);
			}
		}
		else
		{
			self.notifyText2 hud::setParent(anchorElem);
			if(isdefined(notifyData.text2Label))
			{
				self.notifyText2.label = notifyData.text2Label;
			}
			else
			{
				self.notifyText2.label = &"";
			}
			self.notifyText2 setText(notifyData.notifyText2);
			self.notifyText2 setPulseFX(100, Int(duration * 1000), 1000);
			self.notifyText2.glowColor = glowColor;
			self.notifyText2.color = color;
			self.notifyText2.alpha = 1;
			anchorElem = self.notifyText2;
		}
	}
	if(isdefined(notifyData.iconName))
	{
		iconWidth = 60;
		iconHeight = 60;
		if(isdefined(notifyData.iconWidth))
		{
			iconWidth = notifyData.iconWidth;
		}
		if(isdefined(notifyData.iconHeight))
		{
			iconHeight = notifyData.iconHeight;
		}
		self.notifyIcon hud::setParent(anchorElem);
		self.notifyIcon SetShader(notifyData.iconName, iconWidth, iconHeight);
		self.notifyIcon.alpha = 0;
		self.notifyIcon fadeOverTime(1);
		self.notifyIcon.alpha = 1;
		waitRequireVisibility(duration);
		self.notifyIcon fadeOverTime(0.75);
		self.notifyIcon.alpha = 0;
	}
	else
	{
		waitRequireVisibility(duration);
	}
	self notify("notifyMessageDone");
	self.doingNotify = 0;
}

/*
	Name: waitRequireVisibility
	Namespace: hud_message
	Checksum: 0xFFDC977D
	Offset: 0x15A8
	Size: 0x79
	Parameters: 1
	Flags: None
*/
function waitRequireVisibility(waitTime)
{
	interval = 0.05;
	while(!self canReadText())
	{
		wait(interval);
	}
	while(waitTime > 0)
	{
		wait(interval);
		if(self canReadText())
		{
			waitTime = waitTime - interval;
		}
	}
}

/*
	Name: canReadText
	Namespace: hud_message
	Checksum: 0xC8D94473
	Offset: 0x1630
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function canReadText()
{
	if(self util::is_flashbanged())
	{
		return 0;
	}
	return 1;
}

/*
	Name: resetOnDeath
	Namespace: hud_message
	Checksum: 0x93939159
	Offset: 0x1660
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function resetOnDeath()
{
	self endon("notifyMessageDone");
	self endon("disconnect");
	level endon("game_ended");
	self waittill("death");
	resetNotify();
}

/*
	Name: resetOnCancel
	Namespace: hud_message
	Checksum: 0xF8EBD61F
	Offset: 0x16B0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function resetOnCancel()
{
	self notify("resetOnCancel");
	self endon("resetOnCancel");
	self endon("notifyMessageDone");
	self endon("disconnect");
	level waittill("cancel_notify");
	resetNotify();
}

/*
	Name: resetNotify
	Namespace: hud_message
	Checksum: 0x43825907
	Offset: 0x1710
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function resetNotify()
{
	self.notifyTitle.alpha = 0;
	self.notifyText.alpha = 0;
	self.notifyText2.alpha = 0;
	self.notifyIcon.alpha = 0;
	self.doingNotify = 0;
}

/*
	Name: hintMessageDeathThink
	Namespace: hud_message
	Checksum: 0x8978C336
	Offset: 0x1778
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function hintMessageDeathThink()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("death");
		if(isdefined(self.hintMessage))
		{
			self.hintMessage hud::destroyElem();
		}
	}
}

/*
	Name: lowerMessageThink
	Namespace: hud_message
	Checksum: 0x2CD85EB0
	Offset: 0x17C8
	Size: 0x1C7
	Parameters: 0
	Flags: None
*/
function lowerMessageThink()
{
	self endon("disconnect");
	messageTextY = level.lowerTextY;
	if(self IsSplitscreen())
	{
		messageTextY = level.lowerTextY - 50;
	}
	self.lowerMessage = hud::createFontString("default", level.lowerTextFontSize);
	self.lowerMessage hud::setPoint("CENTER", level.lowerTextYAlign, 0, messageTextY);
	self.lowerMessage setText("");
	self.lowerMessage.archived = 0;
	timerFontSize = 1.5;
	if(self IsSplitscreen())
	{
		timerFontSize = 1.4;
	}
	self.lowerTimer = hud::createFontString("default", timerFontSize);
	self.lowerTimer hud::setParent(self.lowerMessage);
	self.lowerTimer hud::setPoint("TOP", "BOTTOM", 0, 0);
	self.lowerTimer setText("");
	self.lowerTimer.archived = 0;
}

/*
	Name: setMatchScoreHUDElemForTeam
	Namespace: hud_message
	Checksum: 0x4D0387A1
	Offset: 0x1998
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function setMatchScoreHUDElemForTeam(team)
{
	if(level.cumulativeRoundScores)
	{
		self setValue(getTeamScore(team));
	}
	else
	{
		self setValue(util::get_rounds_won(team));
	}
}

/*
	Name: isInTop
	Namespace: hud_message
	Checksum: 0x4C8461C3
	Offset: 0x1A10
	Size: 0x65
	Parameters: 2
	Flags: None
*/
function isInTop(players, topN)
{
	for(i = 0; i < topN; i++)
	{
		if(isdefined(players[i]) && self == players[i])
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: destroyHudElem
	Namespace: hud_message
	Checksum: 0x3D8C1855
	Offset: 0x1A80
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function destroyHudElem(hudelem)
{
	if(isdefined(hudelem))
	{
		hudelem hud::destroyElem();
	}
}

/*
	Name: setShoutcasterWaitingMessage
	Namespace: hud_message
	Checksum: 0xEF39D67C
	Offset: 0x1AB8
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function setShoutcasterWaitingMessage()
{
	if(!isdefined(self.waitingForPlayersText))
	{
		self.waitingForPlayersText = hud::createFontString("objective", 2.5);
		self.waitingForPlayersText hud::setPoint("CENTER", "CENTER", 0, -80);
		self.waitingForPlayersText.sort = 1001;
		self.waitingForPlayersText setText(&"MP_WAITING_FOR_PLAYERS_SHOUTCASTER");
		self.waitingForPlayersText.foreground = 0;
		self.waitingForPlayersText.hidewheninmenu = 1;
	}
}

/*
	Name: clearShoutcasterWaitingMessage
	Namespace: hud_message
	Checksum: 0xFC203B0E
	Offset: 0x1B90
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function clearShoutcasterWaitingMessage()
{
	if(isdefined(self.waitingForPlayersText))
	{
		destroyHudElem(self.waitingForPlayersText);
		self.waitingForPlayersText = undefined;
	}
}

/*
	Name: waitTillNotifiesDone
	Namespace: hud_message
	Checksum: 0x997D5D4F
	Offset: 0x1BD0
	Size: 0xED
	Parameters: 0
	Flags: None
*/
function waitTillNotifiesDone()
{
	pendingNotifies = 1;
	for(timeWaited = 0; pendingNotifies && timeWaited < 12;  = 0)
	{
		pendingNotifies = 0;
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			if(isdefined(players[i].notifyQueue) && players[i].notifyQueue.size > 0)
			{
				pendingNotifies = 1;
			}
		}
		if(pendingNotifies)
		{
			wait(0.2);
		}
	}
}

