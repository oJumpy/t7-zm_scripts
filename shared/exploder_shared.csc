#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;

#namespace exploder;

/*
	Name: __init__sytem__
	Namespace: exploder
	Checksum: 0xFB0C9846
	Offset: 0x2E8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("exploder", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: exploder
	Checksum: 0xD8E5AFEF
	Offset: 0x328
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(SessionModeIsCampaignGame())
	{
		callback::on_localclient_connect(&player_init);
	}
}

/*
	Name: player_init
	Namespace: exploder
	Checksum: 0x41006843
	Offset: 0x368
	Size: 0xC23
	Parameters: 1
	Flags: None
*/
function player_init(clientNum)
{
	script_exploders = [];
	ents = struct::get_array("script_brushmodel", "classname");
	smodels = struct::get_array("script_model", "classname");
	for(i = 0; i < smodels.size; i++)
	{
		ents[ents.size] = smodels[i];
	}
	for(i = 0; i < ents.size; i++)
	{
		if(isdefined(ents[i].script_prefab_exploder))
		{
			ents[i].script_exploder = ents[i].script_prefab_exploder;
		}
	}
	potentialExploders = struct::get_array("script_brushmodel", "classname");
	for(i = 0; i < potentialExploders.size; i++)
	{
		if(isdefined(potentialExploders[i].script_prefab_exploder))
		{
			potentialExploders[i].script_exploder = potentialExploders[i].script_prefab_exploder;
		}
		if(isdefined(potentialExploders[i].script_exploder))
		{
			script_exploders[script_exploders.size] = potentialExploders[i];
		}
	}
	potentialExploders = struct::get_array("script_model", "classname");
	for(i = 0; i < potentialExploders.size; i++)
	{
		if(isdefined(potentialExploders[i].script_prefab_exploder))
		{
			potentialExploders[i].script_exploder = potentialExploders[i].script_prefab_exploder;
		}
		if(isdefined(potentialExploders[i].script_exploder))
		{
			script_exploders[script_exploders.size] = potentialExploders[i];
		}
	}
	for(i = 0; i < level.struct.size; i++)
	{
		if(isdefined(level.struct[i].script_prefab_exploder))
		{
			level.struct[i].script_exploder = level.struct[i].script_prefab_exploder;
		}
		if(isdefined(level.struct[i].script_exploder))
		{
			script_exploders[script_exploders.size] = level.struct[i];
		}
	}
	if(!isdefined(level.createFXent))
	{
		level.createFXent = [];
	}
	acceptableTargetnames = [];
	acceptableTargetnames["exploderchunk visible"] = 1;
	acceptableTargetnames["exploderchunk"] = 1;
	acceptableTargetnames["exploder"] = 1;
	exploder_id = 1;
	for(i = 0; i < script_exploders.size; i++)
	{
		exploder = script_exploders[i];
		ent = createExploder(exploder.script_fxid);
		ent.V = [];
		ent.V["origin"] = exploder.origin;
		ent.V["angles"] = exploder.angles;
		ent.V["delay"] = exploder.script_delay;
		ent.V["firefx"] = exploder.script_firefx;
		ent.V["firefxdelay"] = exploder.script_firefxdelay;
		ent.V["firefxsound"] = exploder.script_firefxsound;
		ent.V["firefxtimeout"] = exploder.script_firefxtimeout;
		ent.V["trailfx"] = exploder.script_trailfx;
		ent.V["trailfxtag"] = exploder.script_trailfxtag;
		ent.V["trailfxdelay"] = exploder.script_trailfxdelay;
		ent.V["trailfxsound"] = exploder.script_trailfxsound;
		ent.V["trailfxtimeout"] = exploder.script_firefxtimeout;
		ent.V["earthquake"] = exploder.script_earthquake;
		ent.V["rumble"] = exploder.script_rumble;
		ent.V["damage"] = exploder.script_damage;
		ent.V["damage_radius"] = exploder.script_radius;
		ent.V["repeat"] = exploder.script_repeat;
		ent.V["delay_min"] = exploder.script_delay_min;
		ent.V["delay_max"] = exploder.script_delay_max;
		ent.V["target"] = exploder.target;
		ent.V["ender"] = exploder.script_ender;
		ent.V["physics"] = exploder.script_physics;
		ent.V["type"] = "exploder";
		if(!isdefined(exploder.script_fxid))
		{
			ent.V["fxid"] = "No FX";
		}
		else
		{
			ent.V["fxid"] = exploder.script_fxid;
		}
		ent.V["exploder"] = exploder.script_exploder;
		if(!isdefined(ent.V["delay"]))
		{
			ent.V["delay"] = 0;
		}
		if(isdefined(exploder.script_sound))
		{
			ent.V["soundalias"] = exploder.script_sound;
		}
		else if(ent.V["fxid"] != "No FX")
		{
			if(isdefined(level.scr_sound) && isdefined(level.scr_sound[ent.V["fxid"]]))
			{
				ent.V["soundalias"] = level.scr_sound[ent.V["fxid"]];
			}
		}
		fixup_set = 0;
		if(isdefined(ent.V["target"]))
		{
			ent.needs_fixup = exploder_id;
			exploder_id++;
			fixup_set = 1;
			temp_ent = struct::get(ent.V["target"], "targetname");
			if(isdefined(temp_ent))
			{
				org = temp_ent.origin;
			}
			if(isdefined(org))
			{
				ent.V["angles"] = VectorToAngles(org - ent.V["origin"]);
			}
			if(isdefined(ent.V["angles"]))
			{
				ent FX::set_forward_and_up_vectors();
			}
		}
		if(isdefined(exploder.classname) && exploder.classname == "script_brushmodel" || isdefined(exploder.model))
		{
			ent.model = exploder;
			if(fixup_set == 0)
			{
				ent.needs_fixup = exploder_id;
				exploder_id++;
			}
		}
		if(isdefined(exploder.targetname) && isdefined(acceptableTargetnames[exploder.targetname]))
		{
			ent.V["exploder_type"] = exploder.targetname;
			continue;
		}
		ent.V["exploder_type"] = "normal";
	}
	level.createFXexploders = [];
	for(i = 0; i < level.createFXent.size; i++)
	{
		ent = level.createFXent[i];
		if(ent.V["type"] != "exploder")
		{
			continue;
		}
		ent.V["exploder_id"] = getexploderid(ent);
		if(!isdefined(level.createFXexploders[ent.V["exploder"]]))
		{
			level.createFXexploders[ent.V["exploder"]] = [];
		}
		level.createFXexploders[ent.V["exploder"]][level.createFXexploders[ent.V["exploder"]].size] = ent;
	}
	reportexploderids();
}

/*
	Name: getexploderid
	Namespace: exploder
	Checksum: 0x6418F9DE
	Offset: 0xF98
	Size: 0x9F
	Parameters: 1
	Flags: None
*/
function getexploderid(ent)
{
	if(!isdefined(level._exploder_ids))
	{
		level._exploder_ids = [];
		level._exploder_id = 1;
	}
	if(!isdefined(level._exploder_ids[ent.V["exploder"]]))
	{
		level._exploder_ids[ent.V["exploder"]] = level._exploder_id;
		level._exploder_id++;
	}
	return level._exploder_ids[ent.V["exploder"]];
}

/*
	Name: reportexploderids
	Namespace: exploder
	Checksum: 0x8C320123
	Offset: 0x1040
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function reportexploderids()
{
	if(!isdefined(level._exploder_ids))
	{
		return;
	}
	keys = getArrayKeys(level._exploder_ids);
}

/*
	Name: exploder
	Namespace: exploder
	Checksum: 0x4A12393A
	Offset: 0x1080
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function exploder(exploder_id, n_localclientnumber)
{
	if(IsInt(exploder_id))
	{
		activate_exploder(exploder_id);
	}
	else
	{
		activate_radiant_exploder(exploder_id, n_localclientnumber);
	}
}

/*
	Name: activate_exploder
	Namespace: exploder
	Checksum: 0x6D5F153C
	Offset: 0x10F0
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function activate_exploder(num)
{
	num = Int(num);
	if(isdefined(level.createFXexploders) && isdefined(level.createFXexploders[num]))
	{
		for(i = 0; i < level.createFXexploders[num].size; i++)
		{
			level.createFXexploders[num][i] activate_individual_exploder();
		}
	}
	else if(exploder_is_lightning_exploder(num))
	{
		if(isdefined(level.lightningNormalFunc) && isdefined(level.lightningFlashFunc))
		{
			thread FX::lightning(level.lightningNormalFunc, level.lightningFlashFunc);
		}
	}
}

/*
	Name: activate_individual_exploder
	Namespace: exploder
	Checksum: 0x18524AF9
	Offset: 0x11F0
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function activate_individual_exploder()
{
	if(!isdefined(self.V["angles"]))
	{
		self.V["angles"] = (0, 0, 0);
		self FX::set_forward_and_up_vectors();
	}
	if(isdefined(self.V["firefx"]))
	{
		self thread fire_effect();
	}
	if(isdefined(self.V["fxid"]) && self.V["fxid"] != "No FX")
	{
		self thread cannon_effect();
	}
	if(isdefined(self.V["earthquake"]))
	{
		self thread exploder_earthquake();
	}
}

/*
	Name: activate_radiant_exploder
	Namespace: exploder
	Checksum: 0xA54FCEF2
	Offset: 0x12D8
	Size: 0x85
	Parameters: 2
	Flags: None
*/
function activate_radiant_exploder(string, n_localclientnumber)
{
	if(isdefined(n_localclientnumber))
	{
		PlayRadiantExploder(n_localclientnumber, string);
		break;
	}
	for(localClientNum = 0; localClientNum < level.localPlayers.size; localClientNum++)
	{
		PlayRadiantExploder(localClientNum, string);
	}
}

/*
	Name: stop_exploder
	Namespace: exploder
	Checksum: 0xE5868DCF
	Offset: 0x1368
	Size: 0x1D5
	Parameters: 2
	Flags: None
*/
function stop_exploder(exploder_id, n_localclientnumber)
{
	if(IsString(exploder_id))
	{
		if(isdefined(n_localclientnumber))
		{
			StopRadiantExploder(n_localclientnumber, exploder_id);
			break;
		}
		for(localClientNum = 0; localClientNum < level.localPlayers.size; localClientNum++)
		{
			StopRadiantExploder(localClientNum, exploder_id);
		}
		return;
	}
	num = Int(exploder_id);
	if(isdefined(level.createFXexploders[exploder_id]))
	{
		for(i = 0; i < level.createFXexploders[exploder_id].size; i++)
		{
			ent = level.createFXexploders[exploder_id][i];
			if(isdefined(ent.loopFX))
			{
				for(j = 0; j < ent.loopFX.size; j++)
				{
					if(isdefined(ent.loopFX[j]))
					{
						stopfx(j, ent.loopFX[j]);
						ent.loopFX[j] = undefined;
					}
				}
				ent.loopFX = [];
			}
		}
	}
}

/*
	Name: kill_exploder
	Namespace: exploder
	Checksum: 0x17D07FD4
	Offset: 0x1548
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function kill_exploder(exploder_id)
{
	if(IsString(exploder_id))
	{
		for(localClientNum = 0; localClientNum < level.localPlayers.size; localClientNum++)
		{
			KillRadiantExploder(localClientNum, exploder_id);
		}
		return;
	}
	/#
		ASSERTMSG("Dev Block strings are not supported" + exploder_id);
	#/
}

/*
	Name: exploder_delay
	Namespace: exploder
	Checksum: 0xDC3E1AE6
	Offset: 0x15E8
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function exploder_delay()
{
	if(!isdefined(self.V["delay"]))
	{
		self.V["delay"] = 0;
	}
	min_delay = self.V["delay"];
	max_delay = self.V["delay"] + 0.001;
	if(isdefined(self.V["delay_min"]))
	{
		min_delay = self.V["delay_min"];
	}
	if(isdefined(self.V["delay_max"]))
	{
		max_delay = self.V["delay_max"];
	}
	if(min_delay > 0)
	{
		WaitRealTime(RandomFloatRange(min_delay, max_delay));
	}
}

/*
	Name: exploder_playSound
	Namespace: exploder
	Checksum: 0xEB00B34F
	Offset: 0x16F0
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function exploder_playSound()
{
	if(!isdefined(self.V["soundalias"]) || self.V["soundalias"] == "nil")
	{
		return;
	}
	sound::play_in_space(0, self.V["soundalias"], self.V["origin"]);
}

/*
	Name: exploder_earthquake
	Namespace: exploder
	Checksum: 0xE92537B5
	Offset: 0x1768
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function exploder_earthquake()
{
	self exploder_delay();
	eq = level.Earthquake[self.V["earthquake"]];
	if(isdefined(eq))
	{
		GetLocalPlayers()[0] Earthquake(eq["magnitude"], eq["duration"], self.V["origin"], eq["radius"]);
	}
}

/*
	Name: exploder_is_lightning_exploder
	Namespace: exploder
	Checksum: 0x5679A701
	Offset: 0x1820
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function exploder_is_lightning_exploder(num)
{
	if(isdefined(level.lightningExploder))
	{
		for(i = 0; i < level.lightningExploder.size; i++)
		{
			if(level.lightningExploder[i] == num)
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: stopLightLoopExploder
	Namespace: exploder
	Checksum: 0x82F5049D
	Offset: 0x1890
	Size: 0x1A1
	Parameters: 1
	Flags: None
*/
function stopLightLoopExploder(exploderIndex)
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
	Name: playlightloopexploder
	Namespace: exploder
	Checksum: 0x32E63AF2
	Offset: 0x1A40
	Size: 0x16F
	Parameters: 1
	Flags: None
*/
function playlightloopexploder(exploderIndex)
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
					if(!isdefined(ent.looperFX[clientNum]))
					{
						ent.looperFX[clientNum] = [];
					}
					ent.looperFX[clientNum][ent.looperFX[clientNum].size] = ent playExploderFX(clientNum);
				}
			}
		}
	}
}

/*
	Name: createExploder
	Namespace: exploder
	Checksum: 0x992D271E
	Offset: 0x1BB8
	Size: 0x75
	Parameters: 1
	Flags: None
*/
function createExploder(fxid)
{
	ent = FX::create_effect("exploder", fxid);
	ent.V["delay"] = 0;
	ent.V["exploder_type"] = "normal";
	return ent;
}

/*
	Name: cannon_effect
	Namespace: exploder
	Checksum: 0xB1CCC439
	Offset: 0x1C38
	Size: 0x2D3
	Parameters: 0
	Flags: None
*/
function cannon_effect()
{
	if(isdefined(self.V["repeat"]))
	{
		for(i = 0; i < self.V["repeat"]; i++)
		{
			players = GetLocalPlayers();
			for(player = 0; player < players.size; player++)
			{
				playFX(player, level._effect[self.V["fxid"]], self.V["origin"], self.V["forward"], self.V["up"]);
			}
			self exploder_delay();
		}
		return;
	}
	self exploder_delay();
	players = GetLocalPlayers();
	if(isdefined(self.loopFX))
	{
		for(i = 0; i < self.loopFX.size; i++)
		{
			stopfx(i, self.loopFX[i]);
		}
		self.loopFX = [];
	}
	if(!isdefined(self.loopFX))
	{
		self.loopFX = [];
	}
	if(!isdefined(level._effect[self.V["fxid"]]))
	{
		/#
			ASSERTMSG("Dev Block strings are not supported" + self.V["Dev Block strings are not supported"] + "Dev Block strings are not supported");
		#/
		return;
	}
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(self.V["fxid"]))
		{
			self.loopFX[i] = playFX(i, level._effect[self.V["fxid"]], self.V["origin"], self.V["forward"], self.V["up"]);
		}
	}
	self exploder_playSound();
}

/*
	Name: fire_effect
	Namespace: exploder
	Checksum: 0x753B1149
	Offset: 0x1F18
	Size: 0x265
	Parameters: 0
	Flags: None
*/
function fire_effect()
{
	FORWARD = self.V["forward"];
	if(!isdefined(FORWARD))
	{
		FORWARD = AnglesToForward(self.V["angles"]);
	}
	up = self.V["up"];
	if(!isdefined(up))
	{
		up = anglesToUp(self.V["angles"]);
	}
	firefxSound = self.V["firefxsound"];
	origin = self.V["origin"];
	firefx = self.V["firefx"];
	ender = self.V["ender"];
	if(!isdefined(ender))
	{
		ender = "createfx_effectStopper";
	}
	fireFxDelay = 0.5;
	if(isdefined(self.V["firefxdelay"]))
	{
		fireFxDelay = self.V["firefxdelay"];
	}
	self exploder_delay();
	players = GetLocalPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(firefxSound))
		{
			level thread sound::loop_fx_sound(i, firefxSound, origin, ender);
		}
		playFX(i, level._effect[firefx], self.V["origin"], FORWARD, up, 0, self.V["primlightfrac"], self.V["lightoriginoffs"]);
	}
}

/*
	Name: playExploderFX
	Namespace: exploder
	Checksum: 0x618CEF46
	Offset: 0x2188
	Size: 0xD9
	Parameters: 1
	Flags: None
*/
function playExploderFX(clientNum)
{
	/#
		if(!isdefined(self.V["Dev Block strings are not supported"]))
		{
			return;
		}
		if(!isdefined(self.V["Dev Block strings are not supported"]))
		{
			return;
		}
		if(!isdefined(self.V["Dev Block strings are not supported"]))
		{
			return;
		}
	#/
	return playFX(clientNum, level._effect[self.V["fxid"]], self.V["origin"], self.V["forward"], self.V["up"], 0, self.V["primlightfrac"], self.V["lightoriginoffs"]);
}

/*
	Name: stop_after_duration
	Namespace: exploder
	Checksum: 0xF119375B
	Offset: 0x2270
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function stop_after_duration(name, duration)
{
	wait(duration);
	stop_exploder(name);
}

/*
	Name: exploder_duration
	Namespace: exploder
	Checksum: 0xB6CD25A1
	Offset: 0x22B0
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function exploder_duration(name, duration)
{
	if(!(isdefined(duration) && duration))
	{
		return;
	}
	exploder(name);
	level thread stop_after_duration(name, duration);
}

