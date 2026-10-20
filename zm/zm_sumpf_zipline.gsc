#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_bgb_machine;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_sumpf_zipline;

/*
	Name: initZipline
	Namespace: zm_sumpf_zipline
	Checksum: 0xCD5E9A67
	Offset: 0x540
	Size: 0x893
	Parameters: 0
	Flags: None
*/
function initZipline()
{
	callback::on_connect(&function_3c93cd15);
	zipBuyTrigger = GetEntArray("zipline_buy_trigger", "targetname");
	nonstatictrig = undefined;
	statictrig = undefined;
	level.direction = undefined;
	level.znodes = [];
	level.zrnodes = [];
	level.zipinuse = 0;
	for(i = 0; i < zipBuyTrigger.size; i++)
	{
		zipBuyTrigger[i].zip = GetEnt(zipBuyTrigger[i].target, "targetname");
		zipBuyTrigger[i].blocker = GetEnt("zipline_blocker", "targetname");
		zipBuyTrigger[i].aiblocker = GetEnt("zipline_ai_blocker", "targetname");
		zipBuyTrigger[i].tempclip = GetEntArray("zip_temp_clip", "targetname");
		zipBuyTrigger[i].handle = GetEnt("zip_handle", "targetname");
		zipBuyTrigger[i].lever = GetEnt("zip_lever", "targetname");
		zipBuyTrigger[i].volume = GetEnt(zipBuyTrigger[i].zip.target, "targetname");
		zipBuyTrigger[i].zipDamageTrigger = GetEnt(zipBuyTrigger[i].volume.target, "targetname");
		zipBuyTrigger[i].zipDamageVolume = GetEnt(zipBuyTrigger[i].zipDamageTrigger.target, "targetname");
		if(isdefined(zipBuyTrigger[i].script_noteworthy) && zipBuyTrigger[i].script_noteworthy == "nonstatic")
		{
			nonstatictrig = zipBuyTrigger[i];
		}
		else if(isdefined(zipBuyTrigger[i].script_noteworthy) && zipBuyTrigger[i].script_noteworthy == "static")
		{
			statictrig = zipBuyTrigger[i];
		}
		level.znodes = GetEntArray("zipline_nodes", "script_noteworthy");
		level.zrnodes = [];
		zipBuyTrigger[i] setcursorhint("HINT_NOICON");
	}
	nonstatictrig EnableLinkTo();
	nonstatictrig LinkTo(nonstatictrig.zip);
	statictrig TriggerEnable(0);
	zipBuyTrigger[0].volume EnableLinkTo();
	zipBuyTrigger[0].volume LinkTo(zipBuyTrigger[0].zip);
	zipBuyTrigger[0].zipDamageTrigger EnableLinkTo();
	zipBuyTrigger[0].zipDamageTrigger LinkTo(zipBuyTrigger[0].zip);
	zipBuyTrigger[0].zipDamageVolume EnableLinkTo();
	zipBuyTrigger[0].zipDamageVolume LinkTo(zipBuyTrigger[0].zip);
	for(i = 0; i < zipBuyTrigger[0].tempclip.size; i++)
	{
		zipBuyTrigger[0].tempclip[i] LinkTo(zipBuyTrigger[0].zip);
	}
	zipPowerTrigger = GetEnt("zip_lever_trigger", "targetname");
	zipPowerTrigger.lever = GetEnt(zipPowerTrigger.target, "targetname");
	zipPowerTrigger setHintString(&"ZOMBIE_ZIPLINE_ACTIVATE");
	zipPowerTrigger setcursorhint("HINT_NOICON");
	zipPowerTrigger waittill("trigger", who);
	zipHintDeactivated = GetEnt("zipline_deactivated_hint_trigger", "targetname");
	zipHintDeactivated delete();
	zipPowerTrigger thread recallZipSwitch(180);
	zipPowerTrigger waittill("recallLeverDone");
	who thread zm_audio::create_and_play_dialog("level", "zipline");
	zipPowerTrigger delete();
	statictrig thread activateZip(undefined);
	statictrig waittill("zipDone");
	zipBuyTrigger[0].blocker connectpaths();
	zipBuyTrigger[0].blocker notsolid();
	zm_utility::play_sound_at_pos("door_rotate_open", zipBuyTrigger[0].blocker.origin);
	zipBuyTrigger[0].blocker RotateYaw(80, 1);
	zipBuyTrigger[0].blocker playsound("zmb_wooden_door");
	zipBuyTrigger[0].blocker waittill("rotatedone");
	zipBuyTrigger[0].blocker thread objectSolid();
	waitTime = 40;
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			waitTime = 5;
		}
	#/
	wait(waitTime);
	statictrig thread recallZipSwitch(-180);
	statictrig waittill("recallLeverDone");
	Array::thread_all(zipBuyTrigger, &zipThink);
}

/*
	Name: zip_rope_audio
	Namespace: zm_sumpf_zipline
	Checksum: 0x6FDB58DB
	Offset: 0xDE0
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function zip_rope_audio()
{
	zip_rope = GetEntArray("zip_line_rope", "targetname");
	for(i = 0; i < zip_rope.size; i++)
	{
		if(isdefined(zip_rope[i].script_sound))
		{
			zip_rope[i] thread rope_sounds();
		}
	}
}

/*
	Name: zip_line_audio
	Namespace: zm_sumpf_zipline
	Checksum: 0x451F06DC
	Offset: 0xE78
	Size: 0x12D
	Parameters: 0
	Flags: None
*/
function zip_line_audio()
{
	level thread zip_rope_audio();
	zip_audio = GetEntArray("zip_line_wheel", "targetname");
	for(i = 0; i < zip_audio.size; i++)
	{
		if(isdefined(zip_audio[i].script_label))
		{
			zip_audio[i] playsound(zip_audio[i].script_label);
		}
		if(isdefined(zip_audio[i].script_sound))
		{
			zip_audio[i] PlayLoopSound(zip_audio[i].script_sound, 1);
		}
		zip_audio[i] thread zip_line_stopsound();
	}
}

/*
	Name: rope_sounds
	Namespace: zm_sumpf_zipline
	Checksum: 0x49F509F6
	Offset: 0xFB0
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function rope_sounds()
{
	level endon("MACHINE_OFF");
	while(1)
	{
		wait(RandomFloatRange(0.5, 1.5));
		self playsound(self.script_sound);
	}
}

/*
	Name: zip_line_stopsound
	Namespace: zm_sumpf_zipline
	Checksum: 0xB14DAFC1
	Offset: 0x1010
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function zip_line_stopsound()
{
	level waittill("MACHINE_OFF");
	self StopLoopSound(1);
	if(isdefined(self.script_label))
	{
		self playsound("zmb_motor_stop_left");
	}
}

/*
	Name: recallZipSwitch
	Namespace: zm_sumpf_zipline
	Checksum: 0xABBC0366
	Offset: 0x1070
	Size: 0xD1
	Parameters: 1
	Flags: None
*/
function recallZipSwitch(dir)
{
	self.lever RotatePitch(dir, 0.5);
	org = GetEnt("zip_line_switch", "targetname");
	if(isdefined(org))
	{
		if(dir == 180)
		{
			org playsound("zmb_switch_on");
		}
		else
		{
			org playsound("zmb_switch_off");
		}
	}
	self.lever waittill("rotatedone");
	self notify("recallLeverDone");
}

/*
	Name: function_3c93cd15
	Namespace: zm_sumpf_zipline
	Checksum: 0x5427C54E
	Offset: 0x1150
	Size: 0xB9
	Parameters: 0
	Flags: None
*/
function function_3c93cd15()
{
	var_68782483 = GetEntArray("zipline_buy_trigger", "targetname");
	foreach(e_trigger in var_68782483)
	{
		e_trigger SetInvisibleToPlayer(self);
	}
}

/*
	Name: function_73a6adde
	Namespace: zm_sumpf_zipline
	Checksum: 0x31E1EC6F
	Offset: 0x1218
	Size: 0x187
	Parameters: 0
	Flags: None
*/
function function_73a6adde()
{
	level endon("end_game");
	foreach(player in level.players)
	{
		self SetInvisibleToPlayer(player);
	}
	while(1)
	{
		foreach(player in level.players)
		{
			if(player istouching(self) && (!isdefined(player.var_ff423fef) && player.var_ff423fef))
			{
				player.var_ff423fef = 1;
				player thread function_d3655c8e(self);
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_d3655c8e
	Namespace: zm_sumpf_zipline
	Checksum: 0xC02D9D6F
	Offset: 0x13A8
	Size: 0x22F
	Parameters: 1
	Flags: None
*/
function function_d3655c8e(e_trigger)
{
	level endon("end_game");
	self endon("disconnect");
	while(self istouching(e_trigger))
	{
		wait(0.05);
		if(self laststand::player_is_in_laststand() || self zm_utility::in_revive_trigger())
		{
			e_trigger SetInvisibleToPlayer(self);
			continue;
		}
		if(isdefined(self.IS_DRINKING) && self.IS_DRINKING > 0)
		{
			e_trigger SetInvisibleToPlayer(self);
			continue;
		}
		if(self bgb::is_enabled("zm_bgb_disorderly_combat"))
		{
			e_trigger SetInvisibleToPlayer(self);
			continue;
		}
		initial_current_weapon = self GetCurrentWeapon();
		current_weapon = zm_weapons::get_nonalternate_weapon(initial_current_weapon);
		if(current_weapon.isHeroWeapon || current_weapon.isgadget)
		{
			e_trigger SetInvisibleToPlayer(self);
			continue;
		}
		if(zm_equipment::is_equipment(current_weapon))
		{
			e_trigger SetInvisibleToPlayer(self);
			continue;
		}
		if(self.zombie_vars["zombie_powerup_minigun_on"] === 1)
		{
			e_trigger SetInvisibleToPlayer(self);
			continue;
		}
		e_trigger SetVisibleToPlayer(self);
	}
	e_trigger SetInvisibleToPlayer(self);
	self.var_ff423fef = 0;
}

/*
	Name: zipThink
	Namespace: zm_sumpf_zipline
	Checksum: 0xC9054239
	Offset: 0x15E0
	Size: 0x653
	Parameters: 0
	Flags: None
*/
function zipThink()
{
	self setHintString(&"ZOMBIE_ZIPLINE_USE");
	self setcursorhint("HINT_NOICON");
	self.zombie_cost = 1500;
	zipBuyTrigger = GetEntArray("zipline_buy_trigger", "targetname");
	self thread function_73a6adde();
	if(isdefined(self.script_noteworthy) && self.script_noteworthy == "nonstatic")
	{
		self.triggeron = 1;
		self Unlink();
		self thread monitorZipHint();
	}
	while(1)
	{
		self waittill("trigger", who);
		if(who zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(zombie_utility::is_player_valid(who))
		{
			if(who zm_score::can_player_purchase(self.zombie_cost))
			{
				if(!level.zipinuse)
				{
					if(isdefined(self.script_noteworthy) && self.script_noteworthy == "nonstatic" && who istouching(self.volume) || (isdefined(self.script_noteworthy) && self.script_noteworthy == "static"))
					{
						level.zipinuse = 1;
						for(i = 0; i < zipBuyTrigger.size; i++)
						{
							if(isdefined(zipBuyTrigger[i].script_noteworthy) && zipBuyTrigger[i].script_noteworthy == "nonstatic")
							{
								zipBuyTrigger[i] notify("stopstringmonitor");
								zipBuyTrigger[i] LinkTo(zipBuyTrigger[i].zip);
								zipBuyTrigger[i] setHintString("");
								continue;
							}
							if(isdefined(zipBuyTrigger[i].script_noteworthy) && zipBuyTrigger[i].script_noteworthy == "static" && !isdefined(level.direction))
							{
								zipBuyTrigger[i] TriggerEnable(0);
							}
						}
						zm_utility::play_sound_at_pos("purchase", who.origin);
						if(isdefined(self.script_noteworthy) && self.script_noteworthy == "static")
						{
							self thread recallZipSwitch(180);
							self waittill("recallLeverDone");
						}
						who zm_score::minus_to_player_score(self.zombie_cost);
						if(isdefined(self.script_noteworthy) && self.script_noteworthy == "nonstatic")
						{
							self thread activateZip(who);
						}
						else if(isdefined(self.script_noteworthy) && self.script_noteworthy == "static")
						{
							self thread activateZip(undefined);
						}
						self waittill("zipDone");
						if(isdefined(self.script_noteworthy) && self.script_noteworthy == "nonstatic")
						{
							self Unlink();
							self triggerOffSumpf();
						}
						waitTime = 40;
						/#
							if(GetDvarInt("Dev Block strings are not supported") > 0)
							{
								waitTime = 5;
							}
						#/
						wait(waitTime);
						if(isdefined(self.script_noteworthy) && self.script_noteworthy == "static")
						{
							self thread recallZipSwitch(-180);
							self waittill("recallLeverDone");
						}
						for(i = 0; i < zipBuyTrigger.size; i++)
						{
							if(isdefined(zipBuyTrigger[i].script_noteworthy) && zipBuyTrigger[i].script_noteworthy == "nonstatic")
							{
								zipBuyTrigger[i] setHintString(&"ZOMBIE_ZIPLINE_USE");
								zipBuyTrigger[i] setcursorhint("HINT_NOICON");
								zipBuyTrigger[i] TriggerEnable(1);
								zipBuyTrigger[i] thread monitorZipHint();
							}
							if(isdefined(zipBuyTrigger[i].script_noteworthy) && zipBuyTrigger[i].script_noteworthy == "static" && !isdefined(level.direction))
							{
								zipBuyTrigger[i] TriggerEnable(1);
							}
						}
						level.zipinuse = 0;
					}
				}
			}
		}
	}
}

/*
	Name: triggerOnSumpf
	Namespace: zm_sumpf_zipline
	Checksum: 0xA9E0DE78
	Offset: 0x1C40
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function triggerOnSumpf()
{
	if(isdefined(self.triggeron) && !self.triggeron)
	{
		self.origin = (self.origin[0], self.origin[1], self.origin[2] + 10000);
		self.triggeron = 1;
	}
}

/*
	Name: triggerOffSumpf
	Namespace: zm_sumpf_zipline
	Checksum: 0x18C204C5
	Offset: 0x1CA8
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function triggerOffSumpf()
{
	if(isdefined(self.triggeron) && self.triggeron)
	{
		self.origin = (self.origin[0], self.origin[1], self.origin[2] - 10000);
		self.triggeron = 0;
	}
}

/*
	Name: monitorZipHint
	Namespace: zm_sumpf_zipline
	Checksum: 0xFFBC1C65
	Offset: 0x1D10
	Size: 0x2C5
	Parameters: 0
	Flags: None
*/
function monitorZipHint()
{
	self endon("stopstringmonitor");
	while(1)
	{
		players = GetPlayers();
		downedplayers = [];
		aliveplayers = [];
		stoptrigger = 0;
		for(i = 0; i < players.size; i++)
		{
			if(players[i] laststand::player_is_in_laststand() && players[i] istouching(self.volume))
			{
				if(!isdefined(downedplayers))
				{
					downedplayers = [];
				}
				else if(!IsArray(downedplayers))
				{
					downedplayers = Array(downedplayers);
				}
				downedplayers[downedplayers.size] = players[i];
				continue;
			}
			if(isdefined(players[i]) && isalive(players[i]))
			{
				if(!isdefined(aliveplayers))
				{
					aliveplayers = [];
				}
				else if(!IsArray(aliveplayers))
				{
					aliveplayers = Array(aliveplayers);
				}
				aliveplayers[aliveplayers.size] = players[i];
			}
		}
		if(aliveplayers.size > 0 && downedplayers.size > 0)
		{
			for(i = 0; i < aliveplayers.size; i++)
			{
				for(p = 0; p < downedplayers.size; p++)
				{
					if(aliveplayers[i] istouching(downedplayers[p].reviveTrigger))
					{
						stoptrigger = 1;
						break;
					}
				}
				if(stoptrigger)
				{
					break;
				}
			}
		}
		else if(stoptrigger)
		{
			self triggerOffSumpf();
		}
		else
		{
			self triggerOnSumpf();
		}
		wait(1);
	}
}

/*
	Name: activateZip
	Namespace: zm_sumpf_zipline
	Checksum: 0xED8343C7
	Offset: 0x1FE0
	Size: 0x901
	Parameters: 1
	Flags: None
*/
function activateZip(rider)
{
	zombs = GetAISpeciesArray("axis");
	self.riders = [];
	self.canshock = 0;
	for(i = 0; i < zombs.size; i++)
	{
		if(isdefined(zombs[i]) && isalive(zombs[i]) && zombs[i] istouching(self.zipDamageVolume))
		{
			if(zombs[i].isdog)
			{
				zombs[i].a.nodeath = 1;
			}
			else
			{
				zombs[i] StartRagdoll();
			}
			zombs[i] DoDamage(zombs[i].health + 600, zombs[i].origin);
		}
	}
	level thread zip_line_audio();
	a_attachspot = Array("link_player1", "link_player2", "link_player3", "link_player4");
	peeps = GetPlayers();
	for(i = 0; i < peeps.size; i++)
	{
		if(zombie_utility::is_player_valid(peeps[i]) && (peeps[i] istouching(self.volume) || (isdefined(rider) && peeps[i] == rider)))
		{
			prevDist = undefined;
			playerspot = undefined;
			playerOrg = peeps[i] GetOrigin();
			foreach(attach_spot in a_attachspot)
			{
				attachOrg = self.zip GetTagOrigin(attach_spot);
				dist = Distance2D(playerOrg, attachOrg);
				if(!isdefined(prevDist))
				{
					prevDist = dist;
					playerspot = attach_spot;
					continue;
				}
				if(dist <= prevDist)
				{
					prevDist = dist;
					playerspot = attach_spot;
				}
			}
			if(!isdefined(self.riders))
			{
				self.riders = [];
			}
			else if(!IsArray(self.riders))
			{
				self.riders = Array(self.riders);
			}
			self.riders[self.riders.size] = peeps[i];
			peeps[i] FreezeControls(1);
			peeps[i] thread util::magic_bullet_shield();
			peeps[i].on_zipline = 1;
			peeps[i] SetStance("stand");
			peeps[i] AllowCrouch(0);
			peeps[i] AllowProne(0);
			peeps[i] clientfield::set("player_legs_hide", 1);
			peeps[i] playerLinkTo(self.zip, playerspot, 0, 180, 180, 180, 180, 1);
			ArrayRemoveValue(a_attachspot, playerspot);
		}
	}
	wait(0.1);
	if(a_attachspot.size > 0)
	{
		center = self.zip GetTagOrigin("link_zipline_jnt");
		PhysicsExplosionSphere(center, 128, 64, 2);
	}
	self thread activate_switch();
	if(!isdefined(level.direction))
	{
		self.aiblocker solid();
		self.aiblocker disconnectpaths(0, 0);
		for(i = 0; i < self.riders.size; i++)
		{
			self.riders[i] thread zm::store_crumb((11216, 2883, -648));
		}
		level scene::Play("p7_fxanim_zm_sumpf_zipline_down_bundle");
		level notify("machine_done");
		level.direction = "back";
	}
	else
	{
		for(i = 0; i < self.riders.size; i++)
		{
			self.riders[i] thread zm::store_crumb((10750, 1516, -501));
		}
		level scene::Play("p7_fxanim_zm_sumpf_zipline_up_bundle");
		self.aiblocker notsolid();
		self.aiblocker connectpaths();
		level.direction = undefined;
	}
	self.zipActive = 0;
	wait(0.1);
	for(i = 0; i < self.riders.size; i++)
	{
		if(isdefined(self.riders[i]))
		{
			self.riders[i] Unlink();
			self.riders[i] util::stop_magic_bullet_shield();
			self.riders[i] thread zm::store_crumb(self.origin);
			self.riders[i].on_zipline = 0;
			self.riders[i] AllowCrouch(1);
			self.riders[i] AllowProne(1);
			self.riders[i] FreezeControls(0);
			self.riders[i] clientfield::set("player_legs_hide", 0);
		}
	}
	self player_collision_fix();
	self notify("zipDone");
}

/*
	Name: activate_switch
	Namespace: zm_sumpf_zipline
	Checksum: 0x60335074
	Offset: 0x28F0
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function activate_switch()
{
	wait(0.5);
	self.zipDamageTrigger thread zipDamage(self);
	self.zipActive = 1;
}

/*
	Name: zipDamage
	Namespace: zm_sumpf_zipline
	Checksum: 0x3504B92C
	Offset: 0x2928
	Size: 0xB7
	Parameters: 1
	Flags: None
*/
function zipDamage(parent)
{
	while(1)
	{
		self waittill("trigger", ent);
		if(parent.zipActive == 1 && isdefined(ent) && isalive(ent))
		{
			if(isPlayer(ent))
			{
				ent thread playerZipDamage(parent);
			}
			else
			{
				ent thread zombieZipDamage();
			}
		}
	}
}

/*
	Name: playerZipDamage
	Namespace: zm_sumpf_zipline
	Checksum: 0x462887DC
	Offset: 0x29E8
	Size: 0x109
	Parameters: 1
	Flags: None
*/
function playerZipDamage(parent)
{
	self endon("death");
	self endon("disconnect");
	players = GetPlayers();
	for(i = 0; i < parent.riders.size; i++)
	{
		if(self == parent.riders[i])
		{
			return;
		}
	}
	if(!isdefined(self.zipshock) && !self laststand::player_is_in_laststand() && parent.canshock == 1)
	{
		self.zipshock = 1;
		self shellshock("death", 3);
		wait(2);
		self.zipshock = undefined;
	}
}

/*
	Name: zombieZipDamage
	Namespace: zm_sumpf_zipline
	Checksum: 0xC3548FCB
	Offset: 0x2B00
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function zombieZipDamage()
{
	self endon("death");
	if(self.isdog)
	{
		self.a.nodeath = 1;
	}
	else
	{
		self StartRagdoll();
	}
	self DoDamage(self.health + 600, self.origin);
}

/*
	Name: objectSolid
	Namespace: zm_sumpf_zipline
	Checksum: 0xE206FA40
	Offset: 0x2B80
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function objectSolid()
{
	self endon("stopmonitorsolid");
	while(1)
	{
		players = GetPlayers();
		player_touching = 0;
		for(i = 0; i < players.size; i++)
		{
			if(players[i] istouching(self))
			{
				player_touching = 1;
				break;
			}
		}
		if(!player_touching)
		{
			self solid();
			return;
		}
		wait(0.5);
	}
}

/*
	Name: player_collision_fix
	Namespace: zm_sumpf_zipline
	Checksum: 0xCECFADAE
	Offset: 0x2C58
	Size: 0x235
	Parameters: 0
	Flags: None
*/
function player_collision_fix()
{
	/#
		Assert(isdefined(self));
	#/
	/#
		Assert(isdefined(self.tempclip));
	#/
	if(isdefined(level.direction))
	{
		return;
	}
	base = undefined;
	for(i = 0; i < self.tempclip.size; i++)
	{
		clip = self.tempclip[i];
		if(isdefined(clip.script_noteworthy) && clip.script_noteworthy == "zip_base")
		{
			base = clip;
			break;
		}
	}
	/#
		Assert(isdefined(base));
	#/
	z = base.origin[2];
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(!zombie_utility::is_player_valid(player))
		{
			continue;
		}
		if(!player istouching(base))
		{
			continue;
		}
		if(player.origin[2] < z)
		{
			offset = z + 6;
			origin = (player.origin[0], player.origin[1], offset);
			player SetOrigin(origin);
		}
	}
}

