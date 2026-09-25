#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\footsteps_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace callback;

/*
	Name: callback
	Namespace: callback
	Checksum: 0xEAAD0C5C
	Offset: 0x1E0
	Size: 0x14B
	Parameters: 3
	Flags: None
*/
function callback(event, localClientNum, params)
{
	if(isdefined(level._callbacks) && isdefined(level._callbacks[event]))
	{
		for(i = 0; i < level._callbacks[event].size; i++)
		{
			callback = level._callbacks[event][i][0];
			obj = level._callbacks[event][i][1];
			if(!isdefined(callback))
			{
				continue;
			}
			if(isdefined(obj))
			{
				if(isdefined(params))
				{
					obj thread [[callback]](localClientNum, self, params);
				}
				else
				{
					obj thread [[callback]](localClientNum, self);
				}
				continue;
			}
			if(isdefined(params))
			{
				self thread [[callback]](localClientNum, params);
				continue;
			}
			self thread [[callback]](localClientNum);
		}
	}
}

/*
	Name: entity_callback
	Namespace: callback
	Checksum: 0x6971A7B4
	Offset: 0x338
	Size: 0x14B
	Parameters: 3
	Flags: None
*/
function entity_callback(event, localClientNum, params)
{
	if(isdefined(self._callbacks) && isdefined(self._callbacks[event]))
	{
		for(i = 0; i < self._callbacks[event].size; i++)
		{
			callback = self._callbacks[event][i][0];
			obj = self._callbacks[event][i][1];
			if(!isdefined(callback))
			{
				continue;
			}
			if(isdefined(obj))
			{
				if(isdefined(params))
				{
					obj thread [[callback]](localClientNum, self, params);
				}
				else
				{
					obj thread [[callback]](localClientNum, self);
				}
				continue;
			}
			if(isdefined(params))
			{
				self thread [[callback]](localClientNum, params);
				continue;
			}
			self thread [[callback]](localClientNum);
		}
	}
}

/*
	Name: add_callback
	Namespace: callback
	Checksum: 0x3A916861
	Offset: 0x490
	Size: 0x18B
	Parameters: 3
	Flags: None
*/
function add_callback(event, func, obj)
{
	/#
		Assert(isdefined(event), "Dev Block strings are not supported");
	#/
	if(!isdefined(level._callbacks) || !isdefined(level._callbacks[event]))
	{
		level._callbacks[event] = [];
	}
	foreach(callback in level._callbacks[event])
	{
		if(callback[0] == func)
		{
			if(!isdefined(obj) || callback[1] == obj)
			{
				return;
			}
		}
	}
	Array::add(level._callbacks[event], Array(func, obj), 0);
	if(isdefined(obj))
	{
		obj thread remove_callback_on_death(event, func);
	}
}

/*
	Name: add_entity_callback
	Namespace: callback
	Checksum: 0x47B03572
	Offset: 0x628
	Size: 0x163
	Parameters: 3
	Flags: None
*/
function add_entity_callback(event, func, obj)
{
	/#
		Assert(isdefined(event), "Dev Block strings are not supported");
	#/
	if(!isdefined(self._callbacks) || !isdefined(self._callbacks[event]))
	{
		self._callbacks[event] = [];
	}
	foreach(callback in self._callbacks[event])
	{
		if(callback[0] == func)
		{
			if(!isdefined(obj) || callback[1] == obj)
			{
				return;
			}
		}
	}
	Array::add(self._callbacks[event], Array(func, obj), 0);
}

/*
	Name: remove_callback_on_death
	Namespace: callback
	Checksum: 0x1E0389D7
	Offset: 0x798
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function remove_callback_on_death(event, func)
{
	self waittill("death");
	remove_callback(event, func, self);
}

/*
	Name: remove_callback
	Namespace: callback
	Checksum: 0xF6DBDC0B
	Offset: 0x7E0
	Size: 0x139
	Parameters: 3
	Flags: None
*/
function remove_callback(event, func, obj)
{
	/#
		Assert(isdefined(event), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(level._callbacks[event]), "Dev Block strings are not supported");
	#/
	foreach(func_group in level._callbacks[event])
	{
		if(func_group[0] == func)
		{
			if(func_group[1] === obj)
			{
				ArrayRemoveIndex(level._callbacks[event], index, 0);
			}
		}
	}
}

/*
	Name: on_localclient_connect
	Namespace: callback
	Checksum: 0x9E9C1FB7
	Offset: 0x928
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_localclient_connect(func, obj)
{
	add_callback("hash_da8d7d74", func, obj);
}

/*
	Name: on_localclient_shutdown
	Namespace: callback
	Checksum: 0x5F5EAA03
	Offset: 0x968
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_localclient_shutdown(func, obj)
{
	add_callback("hash_e64327a6", func, obj);
}

/*
	Name: on_finalize_initialization
	Namespace: callback
	Checksum: 0x827B66A7
	Offset: 0x9A8
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_finalize_initialization(func, obj)
{
	add_callback("hash_36fb1b1a", func, obj);
}

/*
	Name: on_localplayer_spawned
	Namespace: callback
	Checksum: 0x94E186A6
	Offset: 0x9E8
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_localplayer_spawned(func, obj)
{
	add_callback("hash_842e788a", func, obj);
}

/*
	Name: remove_on_localplayer_spawned
	Namespace: callback
	Checksum: 0x49CE9DFB
	Offset: 0xA28
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function remove_on_localplayer_spawned(func, obj)
{
	remove_callback("hash_842e788a", func, obj);
}

/*
	Name: on_spawned
	Namespace: callback
	Checksum: 0x4606D377
	Offset: 0xA68
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_spawned(func, obj)
{
	add_callback("hash_bc12b61f", func, obj);
}

/*
	Name: remove_on_spawned
	Namespace: callback
	Checksum: 0xD71999B3
	Offset: 0xAA8
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function remove_on_spawned(func, obj)
{
	remove_callback("hash_bc12b61f", func, obj);
}

/*
	Name: on_shutdown
	Namespace: callback
	Checksum: 0xE963B01A
	Offset: 0xAE8
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_shutdown(func, obj)
{
	add_entity_callback("hash_390259d9", func, obj);
}

/*
	Name: on_start_gametype
	Namespace: callback
	Checksum: 0x7CBF803B
	Offset: 0xB28
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_start_gametype(func, obj)
{
	add_callback("hash_cc62acca", func, obj);
}

/*
	Name: CodeCallback_PreInitialization
	Namespace: callback
	Checksum: 0xBD9EE26C
	Offset: 0xB68
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function CodeCallback_PreInitialization()
{
	callback("hash_ecc6aecf");
	system::run_pre_systems();
}

/*
	Name: CodeCallback_FinalizeInitialization
	Namespace: callback
	Checksum: 0xAC821D11
	Offset: 0xBA0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function CodeCallback_FinalizeInitialization()
{
	system::run_post_systems();
	callback("hash_36fb1b1a");
}

/*
	Name: CodeCallback_StateChange
	Namespace: callback
	Checksum: 0x6B4192EF
	Offset: 0xBD8
	Size: 0xFB
	Parameters: 3
	Flags: None
*/
function CodeCallback_StateChange(clientNum, system, newState)
{
	if(!isdefined(level._systemStates))
	{
		level._systemStates = [];
	}
	if(!isdefined(level._systemStates[system]))
	{
		level._systemStates[system] = spawnstruct();
	}
	level._systemStates[system].State = newState;
	if(isdefined(level._systemStates[system].callback))
	{
		[[level._systemStates[system].callback]](clientNum, newState);
	}
	else
	{
		println("Dev Block strings are not supported" + system + "Dev Block strings are not supported");
	}
	/#
	#/
}

/*
	Name: CodeCallback_MapRestart
	Namespace: callback
	Checksum: 0xB1A144AF
	Offset: 0xCE0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function CodeCallback_MapRestart()
{
	/#
		println("Dev Block strings are not supported");
	#/
	util::waitforclient(0);
	level thread util::init_utility();
}

/*
	Name: CodeCallback_LocalClientConnect
	Namespace: callback
	Checksum: 0xA3189630
	Offset: 0xD40
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function CodeCallback_LocalClientConnect(localClientNum)
{
	/#
		println("Dev Block strings are not supported" + localClientNum);
	#/
	[[level.callbackLocalClientConnect]](localClientNum);
}

/*
	Name: CodeCallback_LocalClientDisconnect
	Namespace: callback
	Checksum: 0xC07545D1
	Offset: 0xD90
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function CodeCallback_LocalClientDisconnect(clientNum)
{
	/#
		println("Dev Block strings are not supported" + clientNum);
	#/
}

/*
	Name: CodeCallback_GlassSmash
	Namespace: callback
	Checksum: 0x2C1D9C42
	Offset: 0xDD0
	Size: 0x29
	Parameters: 2
	Flags: None
*/
function CodeCallback_GlassSmash(org, dir)
{
	level notify("glass_smash", org, dir);
}

/*
	Name: CodeCallback_SoundSetAmbientState
	Namespace: callback
	Checksum: 0x24FB4F5E
	Offset: 0xE08
	Size: 0x53
	Parameters: 5
	Flags: None
*/
function CodeCallback_SoundSetAmbientState(ambientRoom, ambientPackage, roomColliderCent, packageColliderCent, defaultRoom)
{
	audio::setCurrentAmbientState(ambientRoom, ambientPackage, roomColliderCent, packageColliderCent, defaultRoom);
}

/*
	Name: CodeCallback_SoundSetAiAmbientState
	Namespace: callback
	Checksum: 0x89379260
	Offset: 0xE68
	Size: 0x1B
	Parameters: 3
	Flags: None
*/
function CodeCallback_SoundSetAiAmbientState(triggers, actors, numTriggers)
{
}

/*
	Name: CodeCallback_SoundPlayUiDecodeLoop
	Namespace: callback
	Checksum: 0x30140C87
	Offset: 0xE90
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function CodeCallback_SoundPlayUiDecodeLoop(decodeString, playTimeMs)
{
	self thread audio::soundplayuidecodeloop(decodeString, playTimeMs);
}

/*
	Name: CodeCallback_PlayerSpawned
	Namespace: callback
	Checksum: 0xA19A4E89
	Offset: 0xED0
	Size: 0x3F
	Parameters: 1
	Flags: None
*/
function CodeCallback_PlayerSpawned(localClientNum)
{
	/#
		println("Dev Block strings are not supported");
	#/
	[[level.callbackPlayerSpawned]](localClientNum);
}

/*
	Name: CodeCallback_GibEvent
	Namespace: callback
	Checksum: 0x6E34919E
	Offset: 0xF18
	Size: 0x43
	Parameters: 3
	Flags: None
*/
function CodeCallback_GibEvent(localClientNum, type, locations)
{
	if(isdefined(level._gibEventCBFunc))
	{
		self thread [[level._gibEventCBFunc]](localClientNum, type, locations);
	}
}

/*
	Name: CodeCallback_PrecacheGameType
	Namespace: callback
	Checksum: 0x8C9E42C4
	Offset: 0xF68
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function CodeCallback_PrecacheGameType()
{
	if(isdefined(level.callbackPrecacheGameType))
	{
		[[level.callbackPrecacheGameType]]();
	}
}

/*
	Name: CodeCallback_StartGameType
	Namespace: callback
	Checksum: 0x98EA46D7
	Offset: 0xF90
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function CodeCallback_StartGameType()
{
	if(isdefined(level.callbackStartGameType) && (!isdefined(level.gametypestarted) || !level.gametypestarted))
	{
		[[level.callbackStartGameType]]();
		level.gametypestarted = 1;
	}
}

/*
	Name: CodeCallback_EntitySpawned
	Namespace: callback
	Checksum: 0x90291AD2
	Offset: 0xFE0
	Size: 0x1F
	Parameters: 1
	Flags: None
*/
function CodeCallback_EntitySpawned(localClientNum)
{
	[[level.callbackEntitySpawned]](localClientNum);
}

/*
	Name: CodeCallback_SoundNotify
	Namespace: callback
	Checksum: 0x33D10E9C
	Offset: 0x1008
	Size: 0x75
	Parameters: 3
	Flags: None
*/
function CodeCallback_SoundNotify(localClientNum, entity, note)
{
	switch(note)
	{
		case "scr_bomb_beep":
		{
			if(GetGametypeSetting("silentPlant") == 0)
			{
				entity playsound(localClientNum, "fly_bomb_buttons_npc");
			}
			break;
		}
	}
}

/*
	Name: CodeCallback_EntityShutdown
	Namespace: callback
	Checksum: 0xC75C4AEA
	Offset: 0x1088
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function CodeCallback_EntityShutdown(localClientNum, entity)
{
	if(isdefined(level.callbackEntityShutdown))
	{
		[[level.callbackEntityShutdown]](localClientNum, entity);
	}
	entity entity_callback("hash_390259d9", localClientNum);
}

/*
	Name: CodeCallback_LocalClientShutdown
	Namespace: callback
	Checksum: 0x6444FB87
	Offset: 0x10F0
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function CodeCallback_LocalClientShutdown(localClientNum, entity)
{
	level.localPlayers = GetLocalPlayers();
	entity callback("hash_e64327a6", localClientNum);
}

/*
	Name: CodeCallback_LocalClientChanged
	Namespace: callback
	Checksum: 0x2B71FF28
	Offset: 0x1148
	Size: 0x2B
	Parameters: 2
	Flags: None
*/
function CodeCallback_LocalClientChanged(localClientNum, entity)
{
	level.localPlayers = GetLocalPlayers();
}

/*
	Name: CodeCallback_AirSupport
	Namespace: callback
	Checksum: 0xA7A85A58
	Offset: 0x1180
	Size: 0xAF
	Parameters: 12
	Flags: None
*/
function CodeCallback_AirSupport(localClientNum, x, y, z, type, yaw, team, teamfaction, owner, exittype, time, height)
{
	if(isdefined(level.callbackAirSupport))
	{
		[[level.callbackAirSupport]](localClientNum, x, y, z, type, yaw, team, teamfaction, owner, exittype, time, height);
	}
}

/*
	Name: CodeCallback_DemoJump
	Namespace: callback
	Checksum: 0x37011C8D
	Offset: 0x1238
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function CodeCallback_DemoJump(localClientNum, time)
{
	level notify("demo_jump", time);
	level notify("demo_jump" + localClientNum, time);
}

/*
	Name: CodeCallback_DemoPlayerSwitch
	Namespace: callback
	Checksum: 0xE50F14C4
	Offset: 0x1280
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function CodeCallback_DemoPlayerSwitch(localClientNum)
{
	level notify("demo_player_switch");
	level notify("demo_player_switch" + localClientNum);
}

/*
	Name: CodeCallback_PlayerSwitch
	Namespace: callback
	Checksum: 0xA27AE773
	Offset: 0x12B8
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function CodeCallback_PlayerSwitch(localClientNum)
{
	level notify("player_switch");
	level notify("player_switch" + localClientNum);
}

/*
	Name: CodeCallback_KillcamBegin
	Namespace: callback
	Checksum: 0xF3EFFED8
	Offset: 0x12F0
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function CodeCallback_KillcamBegin(localClientNum, time)
{
	level notify("killcam_begin", time);
	level notify("killcam_begin" + localClientNum, time);
}

/*
	Name: CodeCallback_KillcamEnd
	Namespace: callback
	Checksum: 0xC28A1AB2
	Offset: 0x1338
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function CodeCallback_KillcamEnd(localClientNum, time)
{
	level notify("killcam_end", time);
	level notify("killcam_end" + localClientNum, time);
}

/*
	Name: CodeCallback_CreatingCorpse
	Namespace: callback
	Checksum: 0x3F32EBFA
	Offset: 0x1380
	Size: 0x37
	Parameters: 2
	Flags: None
*/
function CodeCallback_CreatingCorpse(localClientNum, player)
{
	if(isdefined(level.callbackCreatingCorpse))
	{
		[[level.callbackCreatingCorpse]](localClientNum, player);
	}
}

/*
	Name: CodeCallback_PlayerFoliage
	Namespace: callback
	Checksum: 0x5110290A
	Offset: 0x13C0
	Size: 0x43
	Parameters: 4
	Flags: None
*/
function CodeCallback_PlayerFoliage(client_num, player, firstperson, quiet)
{
	footsteps::playerFoliage(client_num, player, firstperson, quiet);
}

/*
	Name: CodeCallback_ActivateExploder
	Namespace: callback
	Checksum: 0xC45A0B4A
	Offset: 0x1410
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function CodeCallback_ActivateExploder(exploder_id)
{
	if(!isdefined(level._exploder_ids))
	{
		return;
	}
	keys = getArrayKeys(level._exploder_ids);
	exploder = undefined;
	for(i = 0; i < keys.size; i++)
	{
		if(level._exploder_ids[keys[i]] == exploder_id)
		{
			exploder = keys[i];
			break;
		}
	}
	if(!isdefined(exploder))
	{
		return;
	}
	exploder::activate_exploder(exploder);
}

/*
	Name: CodeCallback_DeactivateExploder
	Namespace: callback
	Checksum: 0x77BF9CBD
	Offset: 0x14E8
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function CodeCallback_DeactivateExploder(exploder_id)
{
	if(!isdefined(level._exploder_ids))
	{
		return;
	}
	keys = getArrayKeys(level._exploder_ids);
	exploder = undefined;
	for(i = 0; i < keys.size; i++)
	{
		if(level._exploder_ids[keys[i]] == exploder_id)
		{
			exploder = keys[i];
			break;
		}
	}
	if(!isdefined(exploder))
	{
		return;
	}
	exploder::stop_exploder(exploder);
}

/*
	Name: CodeCallback_ChargesHotWeaponSoundNotify
	Namespace: callback
	Checksum: 0x1C1D043E
	Offset: 0x15C0
	Size: 0x43
	Parameters: 3
	Flags: None
*/
function CodeCallback_ChargesHotWeaponSoundNotify(localClientNum, weapon, chargeShotLevel)
{
	if(isdefined(level.sndChargeShot_Func))
	{
		self [[level.sndChargeShot_Func]](localClientNum, weapon, chargeShotLevel);
	}
}

/*
	Name: CodeCallback_HostMigration
	Namespace: callback
	Checksum: 0xF810AE0A
	Offset: 0x1610
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function CodeCallback_HostMigration(localClientNum)
{
	/#
		println("Dev Block strings are not supported");
	#/
	if(isdefined(level.callbackHostMigration))
	{
		[[level.callbackHostMigration]](localClientNum);
	}
}

/*
	Name: CodeCallback_DogSoundNotify
	Namespace: callback
	Checksum: 0xE967BE99
	Offset: 0x1668
	Size: 0x43
	Parameters: 3
	Flags: None
*/
function CodeCallback_DogSoundNotify(client_num, entity, note)
{
	if(isdefined(level.callbackDogSoundNotify))
	{
		[[level.callbackDogSoundNotify]](client_num, entity, note);
	}
}

/*
	Name: CodeCallback_PlayAIFootstep
	Namespace: callback
	Checksum: 0xF8F39517
	Offset: 0x16B8
	Size: 0x4F
	Parameters: 5
	Flags: None
*/
function CodeCallback_PlayAIFootstep(client_num, pos, surface, Notetrack, bone)
{
	[[level.callbackPlayAIFootstep]](client_num, pos, surface, Notetrack, bone);
}

/*
	Name: CodeCallback_PlayLightLoopExploder
	Namespace: callback
	Checksum: 0xD5261361
	Offset: 0x1710
	Size: 0x1F
	Parameters: 1
	Flags: None
*/
function CodeCallback_PlayLightLoopExploder(exploderIndex)
{
	[[level.callbackPlayLightLoopExploder]](exploderIndex);
}

/*
	Name: CodeCallback_StopLightLoopExploder
	Namespace: callback
	Checksum: 0xC9492D6B
	Offset: 0x1738
	Size: 0x1A1
	Parameters: 1
	Flags: None
*/
function CodeCallback_StopLightLoopExploder(exploderIndex)
{
	num = Int(exploderIndex);
	if(isdefined(level.createFXexploders[num]))
	{
		for(i = 0; i < level.createFXexploders[num].size; i++)
		{
			ent = level.createFXexploders[num][i];
			if(!isdefined(ent.looperFX))
			{
				ent.looperFX = [];
			}
			for(clientNum = 0; clientNum < level.max_local_clients; clientNum++)
			{
				if(localClientActive(clientNum))
				{
					if(isdefined(ent.looperFX[clientNum]))
					{
						for(looperFXCount = 0; looperFXCount < ent.looperFX[clientNum].size; looperFXCount++)
						{
							deletefx(clientNum, ent.looperFX[clientNum][looperFXCount]);
						}
					}
				}
				ent.looperFX[clientNum] = [];
			}
			ent.looperFX = [];
		}
	}
}

/*
	Name: CodeCallback_ClientFlag
	Namespace: callback
	Checksum: 0xB0124B18
	Offset: 0x18E8
	Size: 0x43
	Parameters: 3
	Flags: None
*/
function CodeCallback_ClientFlag(localClientNum, flag, set)
{
	if(isdefined(level.callbackClientFlag))
	{
		[[level.callbackClientFlag]](localClientNum, flag, set);
	}
}

/*
	Name: CodeCallback_ClientFlagAsVal
	Namespace: callback
	Checksum: 0x6EE22F78
	Offset: 0x1938
	Size: 0x59
	Parameters: 2
	Flags: None
*/
function CodeCallback_ClientFlagAsVal(localClientNum, VAL)
{
	if(isdefined(level._client_flagasval_callbacks) && isdefined(level._client_flagasval_callbacks[self.type]))
	{
		self thread [[level._client_flagasval_callbacks[self.type]]](localClientNum, VAL);
	}
}

/*
	Name: CodeCallback_ExtraCamRenderHero
	Namespace: callback
	Checksum: 0x99E51925
	Offset: 0x19A0
	Size: 0x5B
	Parameters: 5
	Flags: None
*/
function CodeCallback_ExtraCamRenderHero(localClientNum, jobIndex, extraCamIndex, sessionMode, characterindex)
{
	if(isdefined(level.extra_cam_render_hero_func_callback))
	{
		[[level.extra_cam_render_hero_func_callback]](localClientNum, jobIndex, extraCamIndex, sessionMode, characterindex);
	}
}

/*
	Name: CodeCallback_ExtraCamRenderLobbyClientHero
	Namespace: callback
	Checksum: 0xE5D74533
	Offset: 0x1A08
	Size: 0x4F
	Parameters: 4
	Flags: None
*/
function CodeCallback_ExtraCamRenderLobbyClientHero(localClientNum, jobIndex, extraCamIndex, sessionMode)
{
	if(isdefined(level.extra_cam_render_lobby_client_hero_func_callback))
	{
		[[level.extra_cam_render_lobby_client_hero_func_callback]](localClientNum, jobIndex, extraCamIndex, sessionMode);
	}
}

/*
	Name: CodeCallback_ExtraCamRenderCurrentHeroHeadshot
	Namespace: callback
	Checksum: 0x7E10C680
	Offset: 0x1A60
	Size: 0x67
	Parameters: 6
	Flags: None
*/
function CodeCallback_ExtraCamRenderCurrentHeroHeadshot(localClientNum, jobIndex, extraCamIndex, sessionMode, characterindex, isDefaultHero)
{
	if(isdefined(level.extra_cam_render_current_hero_headshot_func_callback))
	{
		[[level.extra_cam_render_current_hero_headshot_func_callback]](localClientNum, jobIndex, extraCamIndex, sessionMode, characterindex, isDefaultHero);
	}
}

/*
	Name: CodeCallback_ExtraCamRenderCharacterBodyItem
	Namespace: callback
	Checksum: 0xE648D319
	Offset: 0x1AD0
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function CodeCallback_ExtraCamRenderCharacterBodyItem(localClientNum, jobIndex, extraCamIndex, sessionMode, characterindex, itemIndex, defaultItemRender)
{
	if(isdefined(level.extra_cam_render_character_body_item_func_callback))
	{
		[[level.extra_cam_render_character_body_item_func_callback]](localClientNum, jobIndex, extraCamIndex, sessionMode, characterindex, itemIndex, defaultItemRender);
	}
}

/*
	Name: CodeCallback_ExtraCamRenderCharacterHelmetItem
	Namespace: callback
	Checksum: 0x31A14D17
	Offset: 0x1B50
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function CodeCallback_ExtraCamRenderCharacterHelmetItem(localClientNum, jobIndex, extraCamIndex, sessionMode, characterindex, itemIndex, defaultItemRender)
{
	if(isdefined(level.extra_cam_render_character_helmet_item_func_callback))
	{
		[[level.extra_cam_render_character_helmet_item_func_callback]](localClientNum, jobIndex, extraCamIndex, sessionMode, characterindex, itemIndex, defaultItemRender);
	}
}

/*
	Name: CodeCallback_ExtraCamRenderCharacterHeadItem
	Namespace: callback
	Checksum: 0xAA2CDCF9
	Offset: 0x1BD0
	Size: 0x67
	Parameters: 6
	Flags: None
*/
function CodeCallback_ExtraCamRenderCharacterHeadItem(localClientNum, jobIndex, extraCamIndex, sessionMode, headIndex, defaultItemRender)
{
	if(isdefined(level.extra_cam_render_character_head_item_func_callback))
	{
		[[level.extra_cam_render_character_head_item_func_callback]](localClientNum, jobIndex, extraCamIndex, sessionMode, headIndex, defaultItemRender);
	}
}

/*
	Name: CodeCallback_ExtraCamRenderOutfitPreview
	Namespace: callback
	Checksum: 0xE2BA0ABA
	Offset: 0x1C40
	Size: 0x5B
	Parameters: 5
	Flags: None
*/
function CodeCallback_ExtraCamRenderOutfitPreview(localClientNum, jobIndex, extraCamIndex, sessionMode, outfitIndex)
{
	if(isdefined(level.extra_cam_render_outfit_preview_func_callback))
	{
		[[level.extra_cam_render_outfit_preview_func_callback]](localClientNum, jobIndex, extraCamIndex, sessionMode, outfitIndex);
	}
}

/*
	Name: CodeCallback_ExtraCamRenderWCPaintjobIcon
	Namespace: callback
	Checksum: 0x8A9A6CCF
	Offset: 0x1CA8
	Size: 0x97
	Parameters: 10
	Flags: None
*/
function CodeCallback_ExtraCamRenderWCPaintjobIcon(localClientNum, extraCamIndex, jobIndex, attachmentVariantString, weaponOptions, weaponPlusAttachments, loadoutSlot, paintjobIndex, paintjobSlot, isFilesharePreview)
{
	if(isdefined(level.extra_cam_render_wc_paintjobicon_func_callback))
	{
		[[level.extra_cam_render_wc_paintjobicon_func_callback]](localClientNum, extraCamIndex, jobIndex, attachmentVariantString, weaponOptions, weaponPlusAttachments, loadoutSlot, paintjobIndex, paintjobSlot, isFilesharePreview);
	}
}

/*
	Name: CodeCallback_ExtraCamRenderWCVariantIcon
	Namespace: callback
	Checksum: 0x9F9E78A4
	Offset: 0x1D48
	Size: 0x97
	Parameters: 10
	Flags: None
*/
function CodeCallback_ExtraCamRenderWCVariantIcon(localClientNum, extraCamIndex, jobIndex, attachmentVariantString, weaponOptions, weaponPlusAttachments, loadoutSlot, paintjobIndex, paintjobSlot, isFilesharePreview)
{
	if(isdefined(level.extra_cam_render_wc_varianticon_func_callback))
	{
		[[level.extra_cam_render_wc_varianticon_func_callback]](localClientNum, extraCamIndex, jobIndex, attachmentVariantString, weaponOptions, weaponPlusAttachments, loadoutSlot, paintjobIndex, paintjobSlot, isFilesharePreview);
	}
}

/*
	Name: CodeCallback_CollectiblesChanged
	Namespace: callback
	Checksum: 0x687CCC9A
	Offset: 0x1DE8
	Size: 0x43
	Parameters: 3
	Flags: None
*/
function CodeCallback_CollectiblesChanged(changedClient, collectiblesArray, localClientNum)
{
	if(isdefined(level.on_collectibles_change))
	{
		[[level.on_collectibles_change]](changedClient, collectiblesArray, localClientNum);
	}
}

/*
	Name: add_weapon_type
	Namespace: callback
	Checksum: 0xBEBA8A1E
	Offset: 0x1E38
	Size: 0x71
	Parameters: 2
	Flags: None
*/
function add_weapon_type(weapontype, callback)
{
	if(!isdefined(level.weapon_type_callback_array))
	{
		level.weapon_type_callback_array = [];
	}
	if(IsString(weapontype))
	{
		weapontype = GetWeapon(weapontype);
	}
	level.weapon_type_callback_array[weapontype] = callback;
}

/*
	Name: spawned_weapon_type
	Namespace: callback
	Checksum: 0xFCE44147
	Offset: 0x1EB8
	Size: 0x61
	Parameters: 1
	Flags: None
*/
function spawned_weapon_type(localClientNum)
{
	weapontype = self.weapon.rootweapon;
	if(isdefined(level.weapon_type_callback_array) && isdefined(level.weapon_type_callback_array[weapontype]))
	{
		self thread [[level.weapon_type_callback_array[weapontype]]](localClientNum);
	}
}

/*
	Name: CodeCallback_CallClientScript
	Namespace: callback
	Checksum: 0xE70A8280
	Offset: 0x1F28
	Size: 0x59
	Parameters: 3
	Flags: None
*/
function CodeCallback_CallClientScript(pSelf, label, Param)
{
	if(!isdefined(level._animnotifyfuncs))
	{
		return;
	}
	if(isdefined(level._animnotifyfuncs[label]))
	{
		pSelf [[level._animnotifyfuncs[label]]](Param);
	}
}

/*
	Name: CodeCallback_CallClientScriptOnLevel
	Namespace: callback
	Checksum: 0x18C60AD5
	Offset: 0x1F90
	Size: 0x51
	Parameters: 2
	Flags: None
*/
function CodeCallback_CallClientScriptOnLevel(label, Param)
{
	if(!isdefined(level._animnotifyfuncs))
	{
		return;
	}
	if(isdefined(level._animnotifyfuncs[label]))
	{
		level [[level._animnotifyfuncs[label]]](Param);
	}
}

/*
	Name: CodeCallback_ServerSceneInit
	Namespace: callback
	Checksum: 0x6C4AAD3A
	Offset: 0x1FF0
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function CodeCallback_ServerSceneInit(scene_name)
{
	if(isdefined(level.server_scenes[scene_name]))
	{
		level thread scene::init(scene_name);
	}
}

/*
	Name: CodeCallback_ServerScenePlay
	Namespace: callback
	Checksum: 0x1EE31FD4
	Offset: 0x2030
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function CodeCallback_ServerScenePlay(scene_name)
{
	level thread scene_black_screen();
	if(isdefined(level.server_scenes[scene_name]))
	{
		level thread scene::Play(scene_name);
	}
}

/*
	Name: CodeCallback_ServerSceneStop
	Namespace: callback
	Checksum: 0x1DC0BB33
	Offset: 0x2088
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function CodeCallback_ServerSceneStop(scene_name)
{
	level thread scene_black_screen();
	if(isdefined(level.server_scenes[scene_name]))
	{
		level thread scene::stop(scene_name, undefined, undefined, undefined, 1);
	}
}

/*
	Name: scene_black_screen
	Namespace: callback
	Checksum: 0xA6FB2505
	Offset: 0x20F0
	Size: 0x177
	Parameters: 0
	Flags: None
*/
function scene_black_screen()
{
	foreach(player in level.localPlayers)
	{
		if(!isdefined(player.lui_black))
		{
			player.lui_black = CreateLUIMenu(i, "FullScreenBlack");
			OpenLUIMenu(i, player.lui_black);
		}
	}
	wait(0.016);
	foreach(player in level.localPlayers)
	{
		if(isdefined(player.lui_black))
		{
			CloseLUIMenu(i, player.lui_black);
			player.lui_black = undefined;
		}
	}
}

/*
	Name: CodeCallback_GadgetVisionPulse_Reveal
	Namespace: callback
	Checksum: 0x9EC38FA0
	Offset: 0x2270
	Size: 0x43
	Parameters: 3
	Flags: None
*/
function CodeCallback_GadgetVisionPulse_Reveal(local_client_num, entity, bReveal)
{
	if(isdefined(level.gadgetVisionPulse_reveal_func))
	{
		entity [[level.gadgetVisionPulse_reveal_func]](local_client_num, bReveal);
	}
}

