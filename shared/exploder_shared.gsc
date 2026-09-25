#using scripts\codescripts\struct;
#using scripts\shared\fx_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace exploder;

/*
	Name: __init__sytem__
	Namespace: exploder
	Checksum: 0x1346CA21
	Offset: 0x310
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("exploder", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: exploder
	Checksum: 0x12F6CFC3
	Offset: 0x358
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._client_exploders = [];
	level._client_exploder_ids = [];
}

/*
	Name: __main__
	Namespace: exploder
	Checksum: 0x13229C63
	Offset: 0x380
	Size: 0xEE1
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level.exploders = [];
	ents = GetEntArray("script_brushmodel", "classname");
	smodels = GetEntArray("script_model", "classname");
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
		if(isdefined(ents[i].script_exploder))
		{
			if(ents[i].script_exploder < 10000)
			{
				level.exploders[ents[i].script_exploder] = 1;
			}
			if(ents[i].model == "fx" && (!isdefined(ents[i].targetname) || ents[i].targetname != "exploderchunk"))
			{
				ents[i] Hide();
				continue;
			}
			if(isdefined(ents[i].targetname) && ents[i].targetname == "exploder")
			{
				ents[i] Hide();
				ents[i] notsolid();
				if(isdefined(ents[i].script_disconnectpaths))
				{
					ents[i] connectpaths();
				}
				continue;
			}
			if(isdefined(ents[i].targetname) && ents[i].targetname == "exploderchunk")
			{
				ents[i] Hide();
				ents[i] notsolid();
				if(isdefined(ents[i].SPAWNFLAGS) && ents[i].SPAWNFLAGS & 1 == 1)
				{
					ents[i] connectpaths();
				}
			}
		}
	}
	script_exploders = [];
	potentialExploders = GetEntArray("script_brushmodel", "classname");
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
	/#
		println("Dev Block strings are not supported" + potentialExploders.size);
	#/
	potentialExploders = GetEntArray("script_model", "classname");
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
	/#
		println("Dev Block strings are not supported" + potentialExploders.size);
	#/
	potentialExploders = GetEntArray("item_health", "classname");
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
	/#
		println("Dev Block strings are not supported" + potentialExploders.size);
	#/
	if(!isdefined(level.createFXent))
	{
		level.createFXent = [];
	}
	acceptableTargetnames = [];
	acceptableTargetnames["exploderchunk visible"] = 1;
	acceptableTargetnames["exploderchunk"] = 1;
	acceptableTargetnames["exploder"] = 1;
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
		ent.V["earthquake"] = exploder.script_earthquake;
		ent.V["damage"] = exploder.script_damage;
		ent.V["damage_radius"] = exploder.script_radius;
		ent.V["soundalias"] = exploder.script_soundalias;
		ent.V["repeat"] = exploder.script_repeat;
		ent.V["delay_min"] = exploder.script_delay_min;
		ent.V["delay_max"] = exploder.script_delay_max;
		ent.V["target"] = exploder.target;
		ent.V["ender"] = exploder.script_ender;
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
		/#
			Assert(isdefined(exploder.script_exploder), "Dev Block strings are not supported" + exploder.origin + "Dev Block strings are not supported");
		#/
		if(!isdefined(ent.V["delay"]))
		{
			ent.V["delay"] = 0;
		}
		if(isdefined(exploder.target))
		{
			e_target = GetEnt(ent.V["target"], "targetname");
			if(!isdefined(e_target))
			{
				e_target = struct::get(ent.V["target"], "targetname");
			}
			org = e_target.origin;
			ent.V["angles"] = VectorToAngles(org - ent.V["origin"]);
		}
		if(exploder.classname == "script_brushmodel" || isdefined(exploder.model))
		{
			ent.model = exploder;
			ent.model.disconnect_paths = exploder.script_disconnectpaths;
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
	level.radiantExploders = [];
	reportexploderids();
	foreach(trig in trigger::get_all())
	{
		if(isdefined(trig.script_prefab_exploder))
		{
			trig.script_exploder = trig.script_prefab_exploder;
		}
		if(isdefined(trig.script_exploder))
		{
			level thread exploder_trigger(trig, trig.script_exploder);
		}
		if(isdefined(trig.script_exploder_radiant))
		{
			level thread exploder_trigger(trig, trig.script_exploder_radiant);
		}
		if(isdefined(trig.script_stop_exploder))
		{
			level trigger::add_function(trig, undefined, &stop_exploder, trig.script_stop_exploder);
		}
		if(isdefined(trig.script_stop_exploder_radiant))
		{
			level trigger::add_function(trig, undefined, &stop_exploder, trig.script_stop_exploder_radiant);
		}
	}
}

/*
	Name: exploder_before_load
	Namespace: exploder
	Checksum: 0xCD688731
	Offset: 0x1270
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function exploder_before_load(num)
{
	waittillframeend;
	waittillframeend;
	exploder(num);
}

/*
	Name: exploder
	Namespace: exploder
	Checksum: 0x41E1C104
	Offset: 0x12A0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function exploder(exploder_id)
{
	if(IsInt(exploder_id))
	{
		activate_exploder(exploder_id);
	}
	else
	{
		activate_radiant_exploder(exploder_id);
	}
}

/*
	Name: exploder_stop
	Namespace: exploder
	Checksum: 0x3C87688D
	Offset: 0x1300
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function exploder_stop(num)
{
	stop_exploder(num);
}

/*
	Name: exploder_sound
	Namespace: exploder
	Checksum: 0x53536519
	Offset: 0x1330
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function exploder_sound()
{
	if(isdefined(self.script_delay))
	{
		wait(self.script_delay);
	}
	self playsound(level.scr_sound[self.script_sound]);
}

/*
	Name: cannon_effect
	Namespace: exploder
	Checksum: 0x5026B206
	Offset: 0x1378
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function cannon_effect()
{
	if(isdefined(self.V["repeat"]))
	{
		for(i = 0; i < self.V["repeat"]; i++)
		{
			playFX(level._effect[self.V["fxid"]], self.V["origin"], self.V["forward"], self.V["up"]);
			self exploder_delay();
		}
		return;
	}
	self exploder_delay();
	if(isdefined(self.looper))
	{
		self.looper delete();
	}
	self.looper = spawnFx(FX::get(self.V["fxid"]), self.V["origin"], self.V["forward"], self.V["up"]);
	triggerFx(self.looper);
	exploder_playSound();
}

/*
	Name: fire_effect
	Namespace: exploder
	Checksum: 0x8F1782FE
	Offset: 0x1520
	Size: 0x18B
	Parameters: 0
	Flags: None
*/
function fire_effect()
{
	FORWARD = self.V["forward"];
	up = self.V["up"];
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
	if(isdefined(firefxSound))
	{
		level thread sound::loop_fx_sound(firefxSound, origin, ender);
	}
	playFX(level._effect[firefx], self.V["origin"], FORWARD, up);
}

/*
	Name: sound_effect
	Namespace: exploder
	Checksum: 0x85A1F603
	Offset: 0x16B8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function sound_effect()
{
	self effect_soundalias();
}

/*
	Name: effect_soundalias
	Namespace: exploder
	Checksum: 0x888E2668
	Offset: 0x16E0
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function effect_soundalias()
{
	origin = self.V["origin"];
	alias = self.V["soundalias"];
	self exploder_delay();
	sound::play_in_space(alias, origin);
}

/*
	Name: trail_effect
	Namespace: exploder
	Checksum: 0xC840FB1D
	Offset: 0x1758
	Size: 0x283
	Parameters: 0
	Flags: None
*/
function trail_effect()
{
	self exploder_delay();
	if(!isdefined(self.V["trailfxtag"]))
	{
		self.V["trailfxtag"] = "tag_origin";
	}
	temp_ent = undefined;
	if(self.V["trailfxtag"] == "tag_origin")
	{
		PlayFXOnTag(level._effect[self.V["trailfx"]], self.model, self.V["trailfxtag"]);
	}
	else
	{
		temp_ent = spawn("script_model", self.model.origin);
		temp_ent SetModel("tag_origin");
		temp_ent LinkTo(self.model, self.V["trailfxtag"]);
		PlayFXOnTag(level._effect[self.V["trailfx"]], temp_ent, "tag_origin");
	}
	if(isdefined(self.V["trailfxsound"]))
	{
		if(!isdefined(temp_ent))
		{
			self.model PlayLoopSound(self.V["trailfxsound"]);
		}
		else
		{
			temp_ent PlayLoopSound(self.V["trailfxsound"]);
		}
	}
	if(isdefined(self.V["ender"]) && isdefined(temp_ent))
	{
		level thread trail_effect_ender(temp_ent, self.V["ender"]);
	}
	if(!isdefined(self.V["trailfxtimeout"]))
	{
		return;
	}
	wait(self.V["trailfxtimeout"]);
	if(isdefined(temp_ent))
	{
		temp_ent delete();
	}
}

/*
	Name: trail_effect_ender
	Namespace: exploder
	Checksum: 0x2795C590
	Offset: 0x19E8
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function trail_effect_ender(ent, ender)
{
	ent endon("death");
	self waittill(ender);
	ent delete();
}

/*
	Name: exploder_delay
	Namespace: exploder
	Checksum: 0x4FAC9DDE
	Offset: 0x1A38
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
		wait(RandomFloatRange(min_delay, max_delay));
	}
}

/*
	Name: exploder_playSound
	Namespace: exploder
	Checksum: 0x471E6195
	Offset: 0x1B40
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
	sound::play_in_space(self.V["soundalias"], self.V["origin"]);
}

/*
	Name: brush_delete
	Namespace: exploder
	Checksum: 0xF741A4A5
	Offset: 0x1BB8
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function brush_delete()
{
	num = self.V["exploder"];
	if(isdefined(self.V["delay"]))
	{
		wait(self.V["delay"]);
	}
	else
	{
		wait(0.05);
	}
	if(!isdefined(self.model))
	{
		return;
	}
	/#
		Assert(isdefined(self.model));
	#/
	if(!isdefined(self.V["fxid"]) || self.V["fxid"] == "No FX")
	{
		self.V["exploder"] = undefined;
	}
	waittillframeend;
	self.model delete();
}

/*
	Name: brush_show
	Namespace: exploder
	Checksum: 0xB256C3D6
	Offset: 0x1CB0
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function brush_show()
{
	if(isdefined(self.V["delay"]))
	{
		wait(self.V["delay"]);
	}
	/#
		Assert(isdefined(self.model));
	#/
	self.model show();
	self.model solid();
}

/*
	Name: brush_throw
	Namespace: exploder
	Checksum: 0x1CF27BD3
	Offset: 0x1D38
	Size: 0x20B
	Parameters: 0
	Flags: None
*/
function brush_throw()
{
	if(isdefined(self.V["delay"]))
	{
		wait(self.V["delay"]);
	}
	ent = undefined;
	if(isdefined(self.V["target"]))
	{
		ent = GetEnt(self.V["target"], "targetname");
	}
	if(!isdefined(ent))
	{
		self.model delete();
		return;
	}
	self.model show();
	startorg = self.V["origin"];
	startAng = self.V["angles"];
	org = ent.origin;
	temp_vec = org - self.V["origin"];
	x = temp_vec[0];
	y = temp_vec[1];
	z = temp_vec[2];
	self.model rotateVelocity((x, y, z), 12);
	self.model MoveGravity((x, y, z), 12);
	self.V["exploder"] = undefined;
	wait(6);
	self.model delete();
}

/*
	Name: exploder_trigger
	Namespace: exploder
	Checksum: 0x1EB087E8
	Offset: 0x1F50
	Size: 0xEF
	Parameters: 2
	Flags: None
*/
function exploder_trigger(trigger, script_value)
{
	trigger endon("death");
	level endon("killexplodertridgers" + script_value);
	trigger trigger::wait_till();
	if(isdefined(trigger.script_chance) && RandomFloat(1) > trigger.script_chance)
	{
		if(isdefined(trigger.script_delay))
		{
			wait(trigger.script_delay);
		}
		else
		{
			wait(4);
		}
		level thread exploder_trigger(trigger, script_value);
		return;
	}
	exploder(script_value);
	level notify("killexplodertridgers" + script_value);
}

/*
	Name: reportexploderids
	Namespace: exploder
	Checksum: 0xDF04D322
	Offset: 0x2048
	Size: 0xB5
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
	/#
		println("Dev Block strings are not supported");
		for(i = 0; i < keys.size; i++)
		{
			println(keys[i] + "Dev Block strings are not supported" + level._exploder_ids[keys[i]]);
		}
	#/
}

/*
	Name: getexploderid
	Namespace: exploder
	Checksum: 0x26E88023
	Offset: 0x2108
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
	Name: createExploder
	Namespace: exploder
	Checksum: 0x2FB805D2
	Offset: 0x21B0
	Size: 0x91
	Parameters: 1
	Flags: None
*/
function createExploder(fxid)
{
	ent = FX::create_effect("exploder", fxid);
	ent.V["delay"] = 0;
	ent.V["exploder"] = 1;
	ent.V["exploder_type"] = "normal";
	return ent;
}

/*
	Name: activate_exploder
	Namespace: exploder
	Checksum: 0xC56BA970
	Offset: 0x2250
	Size: 0x123
	Parameters: 1
	Flags: None
*/
function activate_exploder(num)
{
	num = Int(num);
	level notify("exploder" + num);
	client_send = 1;
	if(isdefined(level.createFXexploders[num]))
	{
		for(i = 0; i < level.createFXexploders[num].size; i++)
		{
			if(client_send && isdefined(level.createFXexploders[num][i].V["exploder_server"]))
			{
				client_send = 0;
			}
			level.createFXexploders[num][i] activate_individual_exploder(num);
		}
	}
	else if(level.clientscripts)
	{
		if(client_send == 1)
		{
			activate_exploder_on_clients(num);
		}
	}
}

/*
	Name: activate_radiant_exploder
	Namespace: exploder
	Checksum: 0xFF961004
	Offset: 0x2380
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function activate_radiant_exploder(string)
{
	level notify("exploder" + string);
	ActivateClientRadiantExploder(string);
}

/*
	Name: activate_individual_exploder
	Namespace: exploder
	Checksum: 0x8598D314
	Offset: 0x23C0
	Size: 0x29B
	Parameters: 1
	Flags: None
*/
function activate_individual_exploder(num)
{
	level notify("exploder" + self.V["exploder"]);
	if(!level.clientscripts || !isdefined(level._exploder_ids[Int(self.V["exploder"])]) || isdefined(self.V["exploder_server"]))
	{
		/#
			println("Dev Block strings are not supported" + self.V["Dev Block strings are not supported"] + "Dev Block strings are not supported");
		#/
		if(isdefined(self.V["firefx"]))
		{
			self thread fire_effect();
		}
		if(isdefined(self.V["fxid"]) && self.V["fxid"] != "No FX")
		{
			self thread cannon_effect();
		}
		else if(isdefined(self.V["soundalias"]))
		{
			self thread sound_effect();
		}
		if(isdefined(self.V["earthquake"]))
		{
			self thread Earthquake();
		}
		if(isdefined(self.V["rumble"]))
		{
			self thread rumble();
		}
	}
	if(isdefined(self.V["trailfx"]))
	{
		self thread trail_effect();
	}
	if(isdefined(self.V["damage"]))
	{
		self thread exploder_damage();
	}
	if(self.V["exploder_type"] == "exploder")
	{
		self thread brush_show();
	}
	else if(self.V["exploder_type"] == "exploderchunk" || self.V["exploder_type"] == "exploderchunk visible")
	{
		self thread brush_throw();
	}
	else
	{
		self thread brush_delete();
	}
}

/*
	Name: activate_exploder_on_clients
	Namespace: exploder
	Checksum: 0x27FF6653
	Offset: 0x2668
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function activate_exploder_on_clients(num)
{
	if(!isdefined(level._exploder_ids[num]))
	{
		return;
	}
	if(!isdefined(level._client_exploders[num]))
	{
		level._client_exploders[num] = 1;
	}
	if(!isdefined(level._client_exploder_ids[num]))
	{
		level._client_exploder_ids[num] = 1;
	}
	ActivateClientExploder(level._exploder_ids[num]);
}

/*
	Name: stop_exploder
	Namespace: exploder
	Checksum: 0x6783933E
	Offset: 0x2700
	Size: 0xC5
	Parameters: 1
	Flags: None
*/
function stop_exploder(num)
{
	if(level.clientscripts)
	{
		delete_exploder_on_clients(num);
	}
	if(isdefined(level.createFXexploders[num]))
	{
		for(i = 0; i < level.createFXexploders[num].size; i++)
		{
			if(!isdefined(level.createFXexploders[num][i].looper))
			{
				continue;
			}
			level.createFXexploders[num][i].looper delete();
		}
	}
}

/*
	Name: delete_exploder_on_clients
	Namespace: exploder
	Checksum: 0xC3AF6CC9
	Offset: 0x27D0
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function delete_exploder_on_clients(exploder_id)
{
	if(IsString(exploder_id))
	{
		DeactivateClientRadiantExploder(exploder_id);
		return;
	}
	if(!isdefined(level._exploder_ids[exploder_id]))
	{
		return;
	}
	if(!isdefined(level._client_exploders[exploder_id]))
	{
		return;
	}
	level._client_exploders[exploder_id] = undefined;
	level._client_exploder_ids[exploder_id] = undefined;
	DeactivateClientExploder(level._exploder_ids[exploder_id]);
}

/*
	Name: kill_exploder
	Namespace: exploder
	Checksum: 0xD9BC7DE8
	Offset: 0x2880
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function kill_exploder(exploder_string)
{
	if(IsString(exploder_string))
	{
		KillClientRadiantExploder(exploder_string);
		return;
	}
	/#
		ASSERTMSG("Dev Block strings are not supported");
	#/
}

/*
	Name: exploder_damage
	Namespace: exploder
	Checksum: 0x3E0A9C0
	Offset: 0x28E8
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function exploder_damage()
{
	if(isdefined(self.V["delay"]))
	{
		delay = self.V["delay"];
	}
	else
	{
		delay = 0;
	}
	if(isdefined(self.V["damage_radius"]))
	{
		radius = self.V["damage_radius"];
	}
	else
	{
		radius = 128;
	}
	damage = self.V["damage"];
	origin = self.V["origin"];
	wait(delay);
	self.model RadiusDamage(origin, radius, damage, damage / 3);
}

/*
	Name: Earthquake
	Namespace: exploder
	Checksum: 0xDEC55E2A
	Offset: 0x29F0
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function Earthquake()
{
	earthquake_name = self.V["earthquake"];
	/#
		Assert(isdefined(level.Earthquake) && isdefined(level.Earthquake[earthquake_name]), "Dev Block strings are not supported" + earthquake_name + "Dev Block strings are not supported");
	#/
	self exploder_delay();
	eq = level.Earthquake[earthquake_name];
	Earthquake(eq["magnitude"], eq["duration"], self.V["origin"], eq["radius"]);
}

/*
	Name: rumble
	Namespace: exploder
	Checksum: 0x4318C1FF
	Offset: 0x2AD8
	Size: 0x175
	Parameters: 0
	Flags: None
*/
function rumble()
{
	self exploder_delay();
	a_players = GetPlayers();
	if(isdefined(self.V["damage_radius"]))
	{
		n_rumble_threshold_squared = self.V["damage_radius"] * self.V["damage_radius"];
	}
	else
	{
		println("Dev Block strings are not supported" + self.V["Dev Block strings are not supported"] + "Dev Block strings are not supported");
		n_rumble_threshold_squared = 16384;
	}
	/#
	#/
	for(i = 0; i < a_players.size; i++)
	{
		n_player_dist_squared = DistanceSquared(a_players[i].origin, self.V["origin"]);
		if(n_player_dist_squared < n_rumble_threshold_squared)
		{
			a_players[i] PlayRumbleOnEntity(self.V["rumble"]);
		}
	}
}

/*
	Name: stop_after_duration
	Namespace: exploder
	Checksum: 0xFEE2C177
	Offset: 0x2C58
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
	Checksum: 0x82E2BDC5
	Offset: 0x2C98
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

