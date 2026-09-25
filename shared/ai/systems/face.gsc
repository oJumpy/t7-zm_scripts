#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace face;

/*
	Name: SayGenericDialogue
	Namespace: face
	Checksum: 0xAD7967B3
	Offset: 0x198
	Size: 0x113
	Parameters: 1
	Flags: None
*/
function SayGenericDialogue(typeString)
{
	if(level.disableGenericDialog)
	{
		return;
	}
	switch(typeString)
	{
		case "attack":
		{
			importance = 0.5;
			break;
		}
		case "swing":
		{
			importance = 0.5;
			typeString = "attack";
			break;
		}
		case "flashbang":
		{
			importance = 0.7;
			break;
		}
		case "pain_small":
		{
			importance = 0.4;
			break;
		}
		case "pain_bullet":
		{
			wait(0.01);
			importance = 0.4;
			break;
		}
		case default:
		{
			/#
				println("Dev Block strings are not supported" + typeString);
			#/
			importance = 0.3;
			break;
		}
	}
	SayGenericDialogueWithImportance(typeString, importance);
}

/*
	Name: SayGenericDialogueWithImportance
	Namespace: face
	Checksum: 0x7D7EA58A
	Offset: 0x2B8
	Size: 0xB3
	Parameters: 2
	Flags: None
*/
function SayGenericDialogueWithImportance(typeString, importance)
{
	soundAlias = "dds_";
	if(isdefined(self.dds_characterID))
	{
		soundAlias = soundAlias + self.dds_characterID;
	}
	else
	{
		println("Dev Block strings are not supported");
		return;
	}
	/#
	#/
	soundAlias = soundAlias + "_" + typeString;
	if(SoundExists(soundAlias))
	{
		self thread PlayFaceThread(undefined, soundAlias, importance);
	}
}

/*
	Name: SetIdleFaceDelayed
	Namespace: face
	Checksum: 0xAE0F325C
	Offset: 0x378
	Size: 0x1F
	Parameters: 1
	Flags: None
*/
function SetIdleFaceDelayed(facialAnimationArray)
{
	self.a.idleFace = facialAnimationArray;
}

/*
	Name: SetIdleFace
	Namespace: face
	Checksum: 0xEAF5D1EF
	Offset: 0x3A0
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function SetIdleFace(facialAnimationArray)
{
	if(!anim.useFacialAnims)
	{
		return;
	}
	self.a.idleFace = facialAnimationArray;
	self PlayIdleFace();
}

/*
	Name: SaySpecificDialogue
	Namespace: face
	Checksum: 0xCDA62950
	Offset: 0x3F0
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function SaySpecificDialogue(facialAnim, soundAlias, importance, notifyString, waitOrNot, timeToWait, toplayer)
{
	self thread PlayFaceThread(facialAnim, soundAlias, importance, notifyString, waitOrNot, timeToWait, toplayer);
}

/*
	Name: PlayIdleFace
	Namespace: face
	Checksum: 0x1787F7B3
	Offset: 0x468
	Size: 0x5
	Parameters: 0
	Flags: None
*/
function PlayIdleFace()
{
	return;
}

/*
	Name: PlayFaceThread
	Namespace: face
	Checksum: 0x2C36F57B
	Offset: 0x478
	Size: 0x6A7
	Parameters: 7
	Flags: None
*/
function PlayFaceThread(facialAnim, str_script_alias, importance, notifyString, waitOrNot, timeToWait, toplayer)
{
	self endon("death");
	if(!isdefined(str_script_alias))
	{
		wait(1);
		self notify(notifyString);
		return;
	}
	str_notify_alias = str_script_alias;
	if(!isdefined(level.NumberOfImportantPeopleTalking))
	{
		level.NumberOfImportantPeopleTalking = 0;
	}
	if(!isdefined(level.TalkNotifySeed))
	{
		level.TalkNotifySeed = 0;
	}
	if(!isdefined(notifyString))
	{
		notifyString = "PlayFaceThread " + str_script_alias;
	}
	if(!isdefined(self.a))
	{
		self.a = spawnstruct();
	}
	if(!isdefined(self.a.facialSoundDone))
	{
		self.a.facialSoundDone = 1;
	}
	if(!isdefined(self.isTalking))
	{
		self.isTalking = 0;
	}
	if(self.isTalking)
	{
		if(isdefined(self.a.currentDialogImportance))
		{
			if(importance < self.a.currentDialogImportance)
			{
				wait(1);
				self notify(notifyString);
				return;
				break;
			}
			if(importance == self.a.currentDialogImportance)
			{
				if(self.a.facialSoundAlias == str_script_alias)
				{
					return;
				}
				/#
					println("Dev Block strings are not supported" + self.a.facialSoundAlias + "Dev Block strings are not supported" + str_script_alias);
				#/
				while(self.isTalking)
				{
					self waittill("done speaking");
				}
			}
			break;
		}
		/#
			println("Dev Block strings are not supported" + self.a.facialSoundAlias + "Dev Block strings are not supported" + str_script_alias);
		#/
		self stopSound(self.a.facialSoundAlias);
		self notify("cancel speaking");
		while(self.isTalking)
		{
			self waittill("done speaking");
		}
	}
	/#
		Assert(self.a.facialSoundDone);
	#/
	/#
		Assert(self.a.facialSoundAlias == undefined);
	#/
	/#
		Assert(self.a.facialSoundNotify == undefined);
	#/
	/#
		Assert(self.a.currentDialogImportance == undefined);
	#/
	/#
		Assert(!self.isTalking);
	#/
	self notify("bc_interrupt");
	self.isTalking = 1;
	self.a.facialSoundDone = 0;
	self.a.facialSoundNotify = notifyString;
	self.a.facialSoundAlias = str_script_alias;
	self.a.currentDialogImportance = importance;
	if(importance == 1)
	{
		level.NumberOfImportantPeopleTalking = level.NumberOfImportantPeopleTalking + 1;
	}
	/#
		if(level.NumberOfImportantPeopleTalking > 1)
		{
			println("Dev Block strings are not supported" + str_script_alias);
		}
	#/
	uniqueNotify = notifyString + " " + level.TalkNotifySeed;
	level.TalkNotifySeed = level.TalkNotifySeed + 1;
	if(isdefined(level.scr_sound) && isdefined(level.scr_sound["generic"]))
	{
		str_vox_file = level.scr_sound["generic"][str_script_alias];
	}
	if(isdefined(str_vox_file))
	{
		if(SoundExists(str_vox_file))
		{
			if(isPlayer(toplayer))
			{
				self thread _play_sound_to_player_with_notify(str_vox_file, toplayer, uniqueNotify);
			}
			else if(isdefined(self GetTagOrigin("J_Head")))
			{
				self PlaySoundWithNotify(str_vox_file, uniqueNotify, "J_Head");
			}
			else
			{
				self PlaySoundWithNotify(str_vox_file, uniqueNotify);
			}
		}
		else
		{
			println("Dev Block strings are not supported" + str_script_alias + "Dev Block strings are not supported");
			self thread _missing_dialog(str_script_alias, str_vox_file, uniqueNotify);
		}
		/#
		#/
	}
	else
	{
		self thread _temp_dialog(str_script_alias, uniqueNotify);
	}
	self util::waittill_any("death", "cancel speaking", uniqueNotify);
	if(importance == 1)
	{
		level.NumberOfImportantPeopleTalking = level.NumberOfImportantPeopleTalking - 1;
		level.ImportantPeopleTalkingTime = GetTime();
	}
	if(isdefined(self))
	{
		self.isTalking = 0;
		self.a.facialSoundDone = 1;
		self.a.facialSoundNotify = undefined;
		self.a.facialSoundAlias = undefined;
		self.a.currentDialogImportance = undefined;
		self.lastSayTime = GetTime();
	}
	self notify("done speaking", str_notify_alias);
	self notify(notifyString);
}

/*
	Name: _play_sound_to_player_with_notify
	Namespace: face
	Checksum: 0x8D055A2A
	Offset: 0xB28
	Size: 0xA9
	Parameters: 3
	Flags: None
*/
function _play_sound_to_player_with_notify(soundAlias, toplayer, uniqueNotify)
{
	self endon("death");
	toplayer endon("death");
	self playsoundtoplayer(soundAlias, toplayer);
	n_playbackTime = soundgetplaybacktime(soundAlias);
	if(n_playbackTime > 0)
	{
		wait(n_playbackTime * 0.001);
	}
	else
	{
		wait(1);
	}
	self notify(uniqueNotify);
}

/*
	Name: _temp_dialog
	Namespace: face
	Checksum: 0x9FFD662D
	Offset: 0xBE0
	Size: 0x33D
	Parameters: 3
	Flags: Private
*/
function private _temp_dialog(str_line, uniqueNotify, b_missing_vo)
{
	if(!isdefined(b_missing_vo))
	{
		b_missing_vo = 0;
	}
	SetDvar("bgcache_disablewarninghints", 1);
	if(!b_missing_vo && isdefined(self.properName))
	{
		str_line = self.properName + ": " + str_line;
	}
	foreach(player in level.players)
	{
		if(!isdefined(player GetLuiMenu("TempDialog")))
		{
			player OpenLUIMenu("TempDialog");
		}
		player SetLUIMenuData(player GetLuiMenu("TempDialog"), "dialogText", str_line);
		if(b_missing_vo)
		{
			player SetLUIMenuData(player GetLuiMenu("TempDialog"), "title", "MISSING VO SOUND");
			continue;
		}
		player SetLUIMenuData(player GetLuiMenu("TempDialog"), "title", "TEMP VO");
	}
	n_wait_time = StrTok(str_line, " ").size - 1 / 2;
	n_wait_time = math::clamp(n_wait_time, 2, 5);
	util::waittill_any_timeout(n_wait_time, "death", "cancel speaking");
	foreach(player in level.players)
	{
		if(isdefined(player GetLuiMenu("TempDialog")))
		{
			player CloseLUIMenu(player GetLuiMenu("TempDialog"));
		}
	}
	SetDvar("bgcache_disablewarninghints", 0);
	self notify(uniqueNotify);
}

/*
	Name: _missing_dialog
	Namespace: face
	Checksum: 0x9D9FDE07
	Offset: 0xF28
	Size: 0x53
	Parameters: 3
	Flags: Private
*/
function private _missing_dialog(str_script_alias, str_vox_file, uniqueNotify)
{
	_temp_dialog("script id: " + str_script_alias + " sound alias: " + str_vox_file, uniqueNotify, 1);
}

/*
	Name: PlayFace_WaitForNotify
	Namespace: face
	Checksum: 0x4FF23AB5
	Offset: 0xF88
	Size: 0x59
	Parameters: 3
	Flags: None
*/
function PlayFace_WaitForNotify(waitForString, notifyString, killmestring)
{
	self endon("death");
	self endon(killmestring);
	self waittill(waitForString);
	self.a.faceWaitForResult = "notify";
	self notify(notifyString);
}

/*
	Name: PlayFace_WaitForTime
	Namespace: face
	Checksum: 0xDC9EA251
	Offset: 0xFF0
	Size: 0x55
	Parameters: 3
	Flags: None
*/
function PlayFace_WaitForTime(time, notifyString, killmestring)
{
	self endon("death");
	self endon(killmestring);
	wait(time);
	self.a.faceWaitForResult = "time";
	self notify(notifyString);
}

