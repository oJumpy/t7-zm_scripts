#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace weaponobjects;

/*
	Name: init_shared
	Namespace: weaponobjects
	Checksum: 0xAC375D84
	Offset: 0x358
	Size: 0x21F
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	callback::on_localplayer_spawned(&on_localplayer_spawned);
	clientfield::register("toplayer", "proximity_alarm", 1, 2, "int", &proximity_alarm_changed, 0, 1);
	clientfield::register("missile", "retrievable", 1, 1, "int", &retrievable_changed, 0, 1);
	clientfield::register("scriptmover", "retrievable", 1, 1, "int", &retrievable_changed, 0, 0);
	clientfield::register("missile", "enemyequip", 1, 2, "int", &enemyequip_changed, 0, 1);
	clientfield::register("scriptmover", "enemyequip", 1, 2, "int", &enemyequip_changed, 0, 0);
	clientfield::register("missile", "teamequip", 1, 1, "int", &teamequip_changed, 0, 1);
	level._effect["powerLight"] = "weapon/fx_equip_light_os";
	if(!isdefined(level.retrievable))
	{
		level.retrievable = [];
	}
	if(!isdefined(level.enemyequip))
	{
		level.enemyequip = [];
	}
}

/*
	Name: on_localplayer_spawned
	Namespace: weaponobjects
	Checksum: 0xC5C3FA9
	Offset: 0x580
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function on_localplayer_spawned(local_client_num)
{
	if(self != GetLocalPlayer(local_client_num))
	{
		return;
	}
	self thread watch_perks_changed(local_client_num);
	self thread watch_killstreak_tap_activation(local_client_num);
}

/*
	Name: watch_killstreak_tap_activation
	Namespace: weaponobjects
	Checksum: 0xFA820889
	Offset: 0x5E8
	Size: 0x137
	Parameters: 1
	Flags: None
*/
function watch_killstreak_tap_activation(local_client_num)
{
	self notify("watch_killstreak_tap_activation");
	self endon("watch_killstreak_tap_activation");
	self endon("death");
	self endon("disconnect");
	self endon("entityshutdown");
	while(isdefined(self))
	{
		self waittill("Notetrack", note);
		if(note == "activate_datapad")
		{
			uimodel = CreateUIModel(GetUIModelForController(local_client_num), "hudItems.killstreakActivated");
			SetUIModelValue(uimodel, 1);
		}
		if(note == "deactivate_datapad")
		{
			uimodel = CreateUIModel(GetUIModelForController(local_client_num), "hudItems.killstreakActivated");
			SetUIModelValue(uimodel, 0);
		}
	}
}

/*
	Name: proximity_alarm_changed
	Namespace: weaponobjects
	Checksum: 0xCBD78F61
	Offset: 0x728
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function proximity_alarm_changed(local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	update_sound(local_client_num, bNewEnt, newVal, oldVal);
}

/*
	Name: update_sound
	Namespace: weaponobjects
	Checksum: 0x72E6F4DE
	Offset: 0x790
	Size: 0x15B
	Parameters: 4
	Flags: None
*/
function update_sound(local_client_num, bNewEnt, newVal, oldVal)
{
	if(newVal == 2)
	{
		if(!isdefined(self._proximity_alarm_snd_ent))
		{
			self._proximity_alarm_snd_ent = spawn(local_client_num, self.origin, "script_origin");
			self thread sndProxAlert_EntCleanup(local_client_num, self._proximity_alarm_snd_ent);
		}
		playsound(local_client_num, "uin_c4_proximity_alarm_start", (0, 0, 0));
		self._proximity_alarm_snd_ent PlayLoopSound("uin_c4_proximity_alarm_loop", 0.1);
	}
	else if(newVal == 1)
	{
	}
	else if(newVal == 0 && isdefined(oldVal) && oldVal != newVal)
	{
		playsound(local_client_num, "uin_c4_proximity_alarm_stop", (0, 0, 0));
		if(isdefined(self._proximity_alarm_snd_ent))
		{
			self._proximity_alarm_snd_ent StopAllLoopSounds(0.5);
		}
	}
}

/*
	Name: teamequip_changed
	Namespace: weaponobjects
	Checksum: 0x9A7E1ACC
	Offset: 0x8F8
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function teamequip_changed(local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self updateTeamEquipment(local_client_num, newVal);
}

/*
	Name: updateTeamEquipment
	Namespace: weaponobjects
	Checksum: 0x2CBFAEDA
	Offset: 0x960
	Size: 0x2B
	Parameters: 2
	Flags: None
*/
function updateTeamEquipment(local_client_num, newVal)
{
	self checkTeamEquipment(local_client_num);
}

/*
	Name: retrievable_changed
	Namespace: weaponobjects
	Checksum: 0x5F56A585
	Offset: 0x998
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function retrievable_changed(local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(level.var_f12ccf06))
	{
		self [[level.var_f12ccf06]](local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
	}
	else
	{
		self util::add_remove_list(level.retrievable, newVal);
		self updateRetrievable(local_client_num, newVal);
	}
}

/*
	Name: updateRetrievable
	Namespace: weaponobjects
	Checksum: 0x26B546D1
	Offset: 0xA60
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function updateRetrievable(local_client_num, newVal)
{
	if(isdefined(self.owner) && self.owner == GetLocalPlayer(local_client_num))
	{
		self duplicate_render::set_item_retrievable(local_client_num, newVal);
	}
	else if(isdefined(self.currentdrfilter))
	{
		self duplicate_render::set_item_retrievable(local_client_num, 0);
	}
}

/*
	Name: enemyequip_changed
	Namespace: weaponobjects
	Checksum: 0x5371E2C
	Offset: 0xAF0
	Size: 0xC3
	Parameters: 7
	Flags: None
*/
function enemyequip_changed(local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(level.var_c301d021))
	{
		self [[level.var_c301d021]](local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
	}
	else
	{
		newVal = newVal != 0;
		self util::add_remove_list(level.enemyequip, newVal);
		self updateEnemyEquipment(local_client_num, newVal);
	}
}

/*
	Name: updateEnemyEquipment
	Namespace: weaponobjects
	Checksum: 0xA1D278E4
	Offset: 0xBC0
	Size: 0x17B
	Parameters: 2
	Flags: None
*/
function updateEnemyEquipment(local_client_num, newVal)
{
	watcher = GetLocalPlayer(local_client_num);
	friend = self util::friend_not_foe(local_client_num, 1);
	if(!friend && isdefined(watcher) && watcher hasPerk(local_client_num, "specialty_showenemyequipment"))
	{
		self duplicate_render::set_item_friendly_equipment(local_client_num, 0);
		self duplicate_render::set_item_enemy_equipment(local_client_num, newVal);
	}
	else if(friend && isdefined(watcher) && watcher duplicate_render::show_friendly_outlines(local_client_num))
	{
		self duplicate_render::set_item_enemy_equipment(local_client_num, 0);
		self duplicate_render::set_item_friendly_equipment(local_client_num, newVal);
	}
	else
	{
		self duplicate_render::set_item_enemy_equipment(local_client_num, 0);
		self duplicate_render::set_item_friendly_equipment(local_client_num, 0);
	}
}

/*
	Name: equipmentDR
	Namespace: weaponobjects
	Checksum: 0x90F4A382
	Offset: 0xD48
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function equipmentDR(local_client_num)
{
}

/*
	Name: watch_perks_changed
	Namespace: weaponobjects
	Checksum: 0xAAC203E7
	Offset: 0xD60
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function watch_perks_changed(local_client_num)
{
	self notify("watch_perks_changed");
	self endon("watch_perks_changed");
	self endon("death");
	self endon("disconnect");
	self endon("entityshutdown");
	while(isdefined(self))
	{
		wait(0.016);
		util::clean_deleted(level.retrievable);
		util::clean_deleted(level.enemyequip);
		Array::thread_all(level.retrievable, &updateRetrievable, local_client_num, 1);
		Array::thread_all(level.enemyequip, &updateEnemyEquipment, local_client_num, 1);
		self waittill("perks_changed");
	}
}

/*
	Name: checkTeamEquipment
	Namespace: weaponobjects
	Checksum: 0x8CE9836
	Offset: 0xE68
	Size: 0x139
	Parameters: 1
	Flags: None
*/
function checkTeamEquipment(localClientNum)
{
	if(!isdefined(self.owner))
	{
		return;
	}
	if(!isdefined(self.equipmentOldTeam))
	{
		self.equipmentOldTeam = self.team;
	}
	if(!isdefined(self.equipmentOldOwnerTeam))
	{
		self.equipmentOldOwnerTeam = self.owner.team;
	}
	watcher = GetLocalPlayer(localClientNum);
	if(!isdefined(self.equipmentOldWatcherTeam))
	{
		self.equipmentOldWatcherTeam = watcher.team;
	}
	if(self.equipmentOldTeam != self.team || self.equipmentOldOwnerTeam != self.owner.team || self.equipmentOldWatcherTeam != watcher.team)
	{
		self.equipmentOldTeam = self.team;
		self.equipmentOldOwnerTeam = self.owner.team;
		self.equipmentOldWatcherTeam = watcher.team;
		self notify("team_changed");
	}
}

/*
	Name: equipmentTeamObject
	Namespace: weaponobjects
	Checksum: 0x957F9B8E
	Offset: 0xFB0
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function equipmentTeamObject(localClientNum)
{
	if(isdefined(level.disable_equipment_team_object) && level.disable_equipment_team_object)
	{
		return;
	}
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	wait(0.05);
	fx_handle = self thread playFlareFX(localClientNum);
	self thread equipmentWatchTeamFX(localClientNum, fx_handle);
	self thread equipmentWatchPlayerTeamChanged(localClientNum, fx_handle);
	self thread equipmentDR();
}

/*
	Name: playFlareFX
	Namespace: weaponobjects
	Checksum: 0x56F10273
	Offset: 0x1080
	Size: 0x10B
	Parameters: 1
	Flags: None
*/
function playFlareFX(localClientNum)
{
	self endon("entityshutdown");
	level endon("player_switch");
	if(!isdefined(self.equipmentTagFX))
	{
		self.equipmentTagFX = "tag_origin";
	}
	if(!isdefined(self.equipmentFriendFX))
	{
		self.equipmentTagFX = level._effect["powerLightGreen"];
	}
	if(!isdefined(self.equipmentEnemyFX))
	{
		self.equipmentTagFX = level._effect["powerLight"];
	}
	if(self util::friend_not_foe(localClientNum, 1))
	{
		fx_handle = PlayFXOnTag(localClientNum, self.equipmentFriendFX, self, self.equipmentTagFX);
	}
	else
	{
		fx_handle = PlayFXOnTag(localClientNum, self.equipmentEnemyFX, self, self.equipmentTagFX);
	}
	return fx_handle;
}

/*
	Name: equipmentWatchTeamFX
	Namespace: weaponobjects
	Checksum: 0x7A90AC67
	Offset: 0x1198
	Size: 0xAB
	Parameters: 2
	Flags: None
*/
function equipmentWatchTeamFX(localClientNum, fxHandle)
{
	msg = self util::waittill_any_return("entityshutdown", "team_changed", "player_switch");
	if(isdefined(fxHandle))
	{
		stopfx(localClientNum, fxHandle);
	}
	waittillframeend;
	if(msg != "entityshutdown" && isdefined(self))
	{
		self thread equipmentTeamObject(localClientNum);
	}
}

/*
	Name: equipmentWatchPlayerTeamChanged
	Namespace: weaponobjects
	Checksum: 0x772F4850
	Offset: 0x1250
	Size: 0xB5
	Parameters: 2
	Flags: None
*/
function equipmentWatchPlayerTeamChanged(localClientNum, fxHandle)
{
	self endon("entityshutdown");
	self notify("team_changed_watcher");
	self endon("team_changed_watcher");
	watcherPlayer = GetLocalPlayer(localClientNum);
	while(1)
	{
		level waittill("team_changed", clientNum);
		player = GetLocalPlayer(clientNum);
		if(watcherPlayer == player)
		{
			self notify("team_changed");
		}
	}
}

/*
	Name: sndProxAlert_EntCleanup
	Namespace: weaponobjects
	Checksum: 0x97A62F70
	Offset: 0x1310
	Size: 0x93
	Parameters: 2
	Flags: None
*/
function sndProxAlert_EntCleanup(localClientNum, ent)
{
	level util::waittill_any("sndDEDe", "demo_jump", "player_switch", "killcam_begin", "killcam_end");
	if(isdefined(ent))
	{
		ent StopAllLoopSounds(0.5);
		ent delete();
	}
}

