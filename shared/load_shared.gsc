#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\debug_shared;
#using scripts\shared\doors_shared;
#using scripts\shared\drown;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\player_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicles\_raps;
#using scripts\shared\visionset_mgr_shared;

#namespace load;

/*
	Name: __init__sytem__
	Namespace: load
	Checksum: 0x9CDD5C3
	Offset: 0x698
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("load", &__init__, undefined, undefined);
}

/*
	Name: first_frame
	Namespace: load
	Checksum: 0xEE1E469C
	Offset: 0x6D8
	Size: 0x21
	Parameters: 0
	Flags: AutoExec
*/
function autoexec first_frame()
{
	level.first_frame = 1;
	wait(0.05);
	level.first_frame = undefined;
}

/*
	Name: __init__
	Namespace: load
	Checksum: 0x5398DEC
	Offset: 0x708
	Size: 0x3C3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	/#
		level thread function_bce02ad1();
		level thread level_notify_listener();
		level thread client_notify_listener();
		level thread function_c03acd92();
		level thread function_3f68ed9b();
	#/
	if(SessionModeIsCampaignGame())
	{
		level.game_mode_suffix = "_cp";
	}
	else if(SessionModeIsZombiesGame())
	{
		level.game_mode_suffix = "_zm";
	}
	else
	{
		level.game_mode_suffix = "_mp";
	}
	level.script = ToLower(GetDvarString("mapname"));
	level.clientscripts = GetDvarString("cg_usingClientScripts") != "";
	level.Campaign = "american";
	level.clientscripts = GetDvarString("cg_usingClientScripts") != "";
	level flag::init("all_players_connected");
	level flag::init("all_players_spawned");
	level flag::init("first_player_spawned");
	if(!isdefined(level.timeofday))
	{
		level.timeofday = "day";
	}
	if(GetDvarString("scr_RequiredMapAspectratio") == "")
	{
		SetDvar("scr_RequiredMapAspectratio", "1");
	}
	SetDvar("r_waterFogTest", 0);
	SetDvar("tu6_player_shallowWaterHeight", "0.0");
	util::registerClientSys("levelNotify");
	level thread all_players_spawned();
	level thread keep_time();
	level thread count_network_frames();
	callback::on_spawned(&on_spawned);
	self thread playerDamageRumble();
	Array::thread_all(GetEntArray("water", "targetname"), &water_think);
	Array::thread_all_ents(GetEntArray("badplace", "targetname"), &badplace_think);
	weapon_ammo();
	set_objective_text_colors();
	link_ents();
	function_b018f2a7();
}

/*
	Name: function_b018f2a7
	Namespace: load
	Checksum: 0x5ED8D3F1
	Offset: 0xAD8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_b018f2a7()
{
	var_ae867510 = GetDvarFloat("tu16_physicsPushOutThreshold", -1);
	if(var_ae867510 != -1)
	{
		SetDvar("tu16_physicsPushOutThreshold", 20);
	}
}

/*
	Name: count_network_frames
	Namespace: load
	Checksum: 0xBA8C27C7
	Offset: 0xB48
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function count_network_frames()
{
	level.network_frame = 0;
	while(1)
	{
		util::wait_network_frame();
		level.network_frame++;
	}
}

/*
	Name: keep_time
	Namespace: load
	Checksum: 0x5B6582A7
	Offset: 0xB88
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function keep_time()
{
	while(1)
	{
		level.time = GetTime();
		wait(0.05);
	}
}

/*
	Name: add_cleanup_msg
	Namespace: load
	Checksum: 0xF3818246
	Offset: 0xBB8
	Size: 0x79
	Parameters: 1
	Flags: None
*/
function add_cleanup_msg(msg)
{
	/#
		if(!isdefined(level.var_ed1cf314))
		{
			level.var_ed1cf314 = [];
		}
		else if(!IsArray(level.var_ed1cf314))
		{
			level.var_ed1cf314 = Array(level.var_ed1cf314);
		}
		level.var_ed1cf314[level.var_ed1cf314.size] = msg;
	#/
}

/*
	Name: function_bce02ad1
	Namespace: load
	Checksum: 0xDEC56495
	Offset: 0xC40
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function function_bce02ad1()
{
	/#
		level.var_ed1cf314 = Array("Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported");
		wait(1);
		println("Dev Block strings are not supported");
		foreach(msg in level.var_ed1cf314)
		{
			println("Dev Block strings are not supported");
		}
		println("Dev Block strings are not supported");
	#/
}

/*
	Name: level_notify_listener
	Namespace: load
	Checksum: 0x362B6A9D
	Offset: 0xD48
	Size: 0x10F
	Parameters: 0
	Flags: None
*/
function level_notify_listener()
{
	/#
		while(1)
		{
			VAL = GetDvarString("Dev Block strings are not supported");
			if(VAL != "Dev Block strings are not supported")
			{
				toks = StrTok(VAL, "Dev Block strings are not supported");
				if(toks.size == 3)
				{
					level notify(toks[0], toks[1], toks[2]);
				}
				else if(toks.size == 2)
				{
					level notify(toks[0], toks[1]);
				}
				else
				{
					level notify(toks[0]);
				}
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			wait(0.2);
		}
	#/
}

/*
	Name: client_notify_listener
	Namespace: load
	Checksum: 0x8820C67
	Offset: 0xE60
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function client_notify_listener()
{
	/#
		while(1)
		{
			VAL = GetDvarString("Dev Block strings are not supported");
			if(VAL != "Dev Block strings are not supported")
			{
				util::clientNotify(VAL);
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			wait(0.2);
		}
	#/
}

/*
	Name: function_c03acd92
	Namespace: load
	Checksum: 0x3C5E9AF4
	Offset: 0xEF0
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function function_c03acd92()
{
	/#
		while(1)
		{
			level waittill("save");
			function_d2250e2f();
			function_297d2d7c();
		}
	#/
}

/*
	Name: function_3f68ed9b
	Namespace: load
	Checksum: 0x59E2E37E
	Offset: 0xF38
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function function_3f68ed9b()
{
	/#
		while(1)
		{
			level waittill("load");
			function_ada65d6b();
		}
	#/
}

/*
	Name: weapon_ammo
	Namespace: load
	Checksum: 0xDDAACA7C
	Offset: 0xF70
	Size: 0x23D
	Parameters: 0
	Flags: None
*/
function weapon_ammo()
{
	ents = GetEntArray();
	for(i = 0; i < ents.size; i++)
	{
		if(isdefined(ents[i].classname) && GetSubStr(ents[i].classname, 0, 7) == "weapon_")
		{
			weap = ents[i];
			change_ammo = 0;
			clip = undefined;
			extra = undefined;
			if(isdefined(weap.script_ammo_clip))
			{
				clip = weap.script_ammo_clip;
				change_ammo = 1;
			}
			if(isdefined(weap.script_ammo_extra))
			{
				extra = weap.script_ammo_extra;
				change_ammo = 1;
			}
			if(change_ammo)
			{
				if(!isdefined(clip))
				{
					/#
						ASSERTMSG("Dev Block strings are not supported" + weap.classname + "Dev Block strings are not supported" + weap.origin + "Dev Block strings are not supported");
					#/
				}
				if(!isdefined(extra))
				{
					/#
						ASSERTMSG("Dev Block strings are not supported" + weap.classname + "Dev Block strings are not supported" + weap.origin + "Dev Block strings are not supported");
					#/
				}
				weap ItemWeaponSetAmmo(clip, extra);
				weap ItemWeaponSetAmmo(clip, extra, 1);
			}
		}
	}
}

/*
	Name: badplace_think
	Namespace: load
	Checksum: 0x4D039A56
	Offset: 0x11B8
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function badplace_think(badplace)
{
	if(!isdefined(level.badPlaces))
	{
		level.badPlaces = 0;
	}
	level.badPlaces++;
	BadPlace_Box("badplace" + level.badPlaces, -1, badplace.origin, badplace.radius, "all");
}

/*
	Name: playerDamageRumble
	Namespace: load
	Checksum: 0x1B47364C
	Offset: 0x1238
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function playerDamageRumble()
{
	while(1)
	{
		self waittill("damage", amount);
		if(isdefined(self.specialDamage))
		{
			continue;
		}
		self PlayRumbleOnEntity("damage_heavy");
	}
}

/*
	Name: map_is_early_in_the_game
	Namespace: load
	Checksum: 0xEC502C05
	Offset: 0x1298
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function map_is_early_in_the_game()
{
	/#
		if(isdefined(level.testmap))
		{
			return 1;
		}
	#/
	/#
		if(!isdefined(level.early_level[level.script]))
		{
			level.early_level[level.script] = 0;
		}
	#/
	return isdefined(level.early_level[level.script]) && level.early_level[level.script];
}

/*
	Name: player_throwgrenade_timer
	Namespace: load
	Checksum: 0x77C3F75A
	Offset: 0x1318
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function player_throwgrenade_timer()
{
	self endon("death");
	self endon("disconnect");
	self.lastgrenadetime = 0;
	while(1)
	{
		while(!self IsThrowingGrenade())
		{
			wait(0.05);
		}
		self.lastgrenadetime = GetTime();
		while(self IsThrowingGrenade())
		{
			wait(0.05);
		}
	}
}

/*
	Name: player_special_death_hint
	Namespace: load
	Checksum: 0x21318FFC
	Offset: 0x13A8
	Size: 0x375
	Parameters: 0
	Flags: None
*/
function player_special_death_hint()
{
	self endon("disconnect");
	self thread player_throwgrenade_timer();
	if(IsSplitscreen() || util::coopGame())
	{
		return;
	}
	self waittill("death", attacker, cause, weapon, inflicter);
	if(cause != "MOD_GAS" && cause != "MOD_GRENADE" && cause != "MOD_GRENADE_SPLASH" && cause != "MOD_SUICIDE" && cause != "MOD_EXPLOSIVE" && cause != "MOD_PROJECTILE" && cause != "MOD_PROJECTILE_SPLASH")
	{
		return;
	}
	if(level.gameskill >= 2)
	{
		if(!map_is_early_in_the_game())
		{
			return;
		}
	}
	if(cause == "MOD_EXPLOSIVE")
	{
		if(isdefined(attacker) && (attacker.classname == "script_vehicle" || isdefined(attacker.create_fake_vehicle_damage)))
		{
			level notify("new_quote_string");
			SetDvar("ui_deadquote", "@SCRIPT_EXPLODING_VEHICLE_DEATH");
			self thread explosive_vehice_death_indicator_hudelement();
			return;
		}
		if(isdefined(inflicter) && isdefined(inflicter.destructibledef))
		{
			if(IsSubStr(inflicter.destructibledef, "barrel_explosive"))
			{
				level notify("new_quote_string");
				SetDvar("ui_deadquote", "@SCRIPT_EXPLODING_BARREL_DEATH");
				return;
			}
			if(isdefined(inflicter.destructiblecar) && inflicter.destructiblecar)
			{
				level notify("new_quote_string");
				SetDvar("ui_deadquote", "@SCRIPT_EXPLODING_VEHICLE_DEATH");
				self thread explosive_vehice_death_indicator_hudelement();
				return;
			}
		}
	}
	if(cause == "MOD_GRENADE" || cause == "MOD_GRENADE_SPLASH")
	{
		if(!weapon.isTimedDetonation || !weapon.isgrenadeweapon)
		{
			return;
		}
		level notify("new_quote_string");
		if(weapon.name == "explosive_bolt")
		{
			SetDvar("ui_deadquote", "@SCRIPT_EXPLOSIVE_BOLT_DEATH");
			thread explosive_arrow_death_indicator_hudelement();
		}
		else
		{
			SetDvar("ui_deadquote", "@SCRIPT_GRENADE_DEATH");
			thread grenade_death_indicator_hudelement();
		}
		return;
	}
}

/*
	Name: grenade_death_text_hudelement
	Namespace: load
	Checksum: 0x774D10C1
	Offset: 0x1728
	Size: 0x303
	Parameters: 2
	Flags: None
*/
function grenade_death_text_hudelement(textLine1, textLine2)
{
	self.failingMission = 1;
	SetDvar("ui_deadquote", "");
	wait(0.5);
	fontElem = NewHudElem();
	fontElem.elemType = "font";
	fontElem.font = "default";
	fontElem.fontscale = 1.5;
	fontElem.x = 0;
	fontElem.y = -60;
	fontElem.alignX = "center";
	fontElem.alignY = "middle";
	fontElem.horzAlign = "center";
	fontElem.vertAlign = "middle";
	fontElem setText(textLine1);
	fontElem.foreground = 1;
	fontElem.alpha = 0;
	fontElem fadeOverTime(1);
	fontElem.alpha = 1;
	fontElem.hidewheninmenu = 1;
	if(isdefined(textLine2))
	{
		fontElem = NewHudElem();
		fontElem.elemType = "font";
		fontElem.font = "default";
		fontElem.fontscale = 1.5;
		fontElem.x = 0;
		fontElem.y = -60 + level.fontHeight * fontElem.fontscale;
		fontElem.alignX = "center";
		fontElem.alignY = "middle";
		fontElem.horzAlign = "center";
		fontElem.vertAlign = "middle";
		fontElem setText(textLine2);
		fontElem.foreground = 1;
		fontElem.alpha = 0;
		fontElem fadeOverTime(1);
		fontElem.alpha = 1;
		fontElem.hidewheninmenu = 1;
	}
}

/*
	Name: grenade_death_indicator_hudelement
	Namespace: load
	Checksum: 0x5BB0EBA9
	Offset: 0x1A38
	Size: 0x283
	Parameters: 0
	Flags: None
*/
function grenade_death_indicator_hudelement()
{
	self endon("disconnect");
	wait(0.5);
	overlayIcon = newClientHudElem(self);
	overlayIcon.x = 0;
	overlayIcon.y = 68;
	overlayIcon SetShader("hud_grenadeicon_256", 50, 50);
	overlayIcon.alignX = "center";
	overlayIcon.alignY = "middle";
	overlayIcon.horzAlign = "center";
	overlayIcon.vertAlign = "middle";
	overlayIcon.foreground = 1;
	overlayIcon.alpha = 0;
	overlayIcon fadeOverTime(1);
	overlayIcon.alpha = 1;
	overlayIcon.hidewheninmenu = 1;
	overlayPointer = newClientHudElem(self);
	overlayPointer.x = 0;
	overlayPointer.y = 25;
	overlayPointer SetShader("hud_grenadepointer", 50, 25);
	overlayPointer.alignX = "center";
	overlayPointer.alignY = "middle";
	overlayPointer.horzAlign = "center";
	overlayPointer.vertAlign = "middle";
	overlayPointer.foreground = 1;
	overlayPointer.alpha = 0;
	overlayPointer fadeOverTime(1);
	overlayPointer.alpha = 1;
	overlayPointer.hidewheninmenu = 1;
	self thread grenade_death_indicator_hudelement_cleanup(overlayIcon, overlayPointer);
}

/*
	Name: explosive_arrow_death_indicator_hudelement
	Namespace: load
	Checksum: 0x6B0C41CB
	Offset: 0x1CC8
	Size: 0x283
	Parameters: 0
	Flags: None
*/
function explosive_arrow_death_indicator_hudelement()
{
	self endon("disconnect");
	wait(0.5);
	overlayIcon = newClientHudElem(self);
	overlayIcon.x = 0;
	overlayIcon.y = 68;
	overlayIcon SetShader("hud_explosive_arrow_icon", 50, 50);
	overlayIcon.alignX = "center";
	overlayIcon.alignY = "middle";
	overlayIcon.horzAlign = "center";
	overlayIcon.vertAlign = "middle";
	overlayIcon.foreground = 1;
	overlayIcon.alpha = 0;
	overlayIcon fadeOverTime(1);
	overlayIcon.alpha = 1;
	overlayIcon.hidewheninmenu = 1;
	overlayPointer = newClientHudElem(self);
	overlayPointer.x = 0;
	overlayPointer.y = 25;
	overlayPointer SetShader("hud_grenadepointer", 50, 25);
	overlayPointer.alignX = "center";
	overlayPointer.alignY = "middle";
	overlayPointer.horzAlign = "center";
	overlayPointer.vertAlign = "middle";
	overlayPointer.foreground = 1;
	overlayPointer.alpha = 0;
	overlayPointer fadeOverTime(1);
	overlayPointer.alpha = 1;
	overlayPointer.hidewheninmenu = 1;
	self thread grenade_death_indicator_hudelement_cleanup(overlayIcon, overlayPointer);
}

/*
	Name: explosive_dart_death_indicator_hudelement
	Namespace: load
	Checksum: 0x76D9E67
	Offset: 0x1F58
	Size: 0x283
	Parameters: 0
	Flags: None
*/
function explosive_dart_death_indicator_hudelement()
{
	self endon("disconnect");
	wait(0.5);
	overlayIcon = newClientHudElem(self);
	overlayIcon.x = 0;
	overlayIcon.y = 68;
	overlayIcon SetShader("hud_monsoon_titus_arrow", 50, 50);
	overlayIcon.alignX = "center";
	overlayIcon.alignY = "middle";
	overlayIcon.horzAlign = "center";
	overlayIcon.vertAlign = "middle";
	overlayIcon.foreground = 1;
	overlayIcon.alpha = 0;
	overlayIcon fadeOverTime(1);
	overlayIcon.alpha = 1;
	overlayIcon.hidewheninmenu = 1;
	overlayPointer = newClientHudElem(self);
	overlayPointer.x = 0;
	overlayPointer.y = 25;
	overlayPointer SetShader("hud_grenadepointer", 50, 25);
	overlayPointer.alignX = "center";
	overlayPointer.alignY = "middle";
	overlayPointer.horzAlign = "center";
	overlayPointer.vertAlign = "middle";
	overlayPointer.foreground = 1;
	overlayPointer.alpha = 0;
	overlayPointer fadeOverTime(1);
	overlayPointer.alpha = 1;
	overlayPointer.hidewheninmenu = 1;
	self thread grenade_death_indicator_hudelement_cleanup(overlayIcon, overlayPointer);
}

/*
	Name: explosive_nitrogen_tank_death_indicator_hudelement
	Namespace: load
	Checksum: 0x924542EA
	Offset: 0x21E8
	Size: 0x283
	Parameters: 0
	Flags: None
*/
function explosive_nitrogen_tank_death_indicator_hudelement()
{
	self endon("disconnect");
	wait(0.5);
	overlayIcon = newClientHudElem(self);
	overlayIcon.x = 0;
	overlayIcon.y = 68;
	overlayIcon SetShader("hud_monsoon_nitrogen_barrel", 50, 50);
	overlayIcon.alignX = "center";
	overlayIcon.alignY = "middle";
	overlayIcon.horzAlign = "center";
	overlayIcon.vertAlign = "middle";
	overlayIcon.foreground = 1;
	overlayIcon.alpha = 0;
	overlayIcon fadeOverTime(1);
	overlayIcon.alpha = 1;
	overlayIcon.hidewheninmenu = 1;
	overlayPointer = newClientHudElem(self);
	overlayPointer.x = 0;
	overlayPointer.y = 25;
	overlayPointer SetShader("hud_grenadepointer", 50, 25);
	overlayPointer.alignX = "center";
	overlayPointer.alignY = "middle";
	overlayPointer.horzAlign = "center";
	overlayPointer.vertAlign = "middle";
	overlayPointer.foreground = 1;
	overlayPointer.alpha = 0;
	overlayPointer fadeOverTime(1);
	overlayPointer.alpha = 1;
	overlayPointer.hidewheninmenu = 1;
	self thread grenade_death_indicator_hudelement_cleanup(overlayIcon, overlayPointer);
}

/*
	Name: explosive_vehice_death_indicator_hudelement
	Namespace: load
	Checksum: 0x49103B34
	Offset: 0x2478
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function explosive_vehice_death_indicator_hudelement()
{
	self endon("disconnect");
	wait(0.5);
	overlayIcon = newClientHudElem(self);
	overlayIcon.x = 0;
	overlayIcon.y = -10;
	overlayIcon SetShader("hud_exploding_vehicles", 50, 50);
	overlayIcon.alignX = "center";
	overlayIcon.alignY = "middle";
	overlayIcon.horzAlign = "center";
	overlayIcon.vertAlign = "middle";
	overlayIcon.foreground = 1;
	overlayIcon.alpha = 0;
	overlayIcon fadeOverTime(1);
	overlayIcon.alpha = 1;
	overlayIcon.hidewheninmenu = 1;
	overlayPointer = newClientHudElem(self);
	self thread grenade_death_indicator_hudelement_cleanup(overlayIcon, overlayPointer);
}

/*
	Name: grenade_death_indicator_hudelement_cleanup
	Namespace: load
	Checksum: 0x23C483FF
	Offset: 0x2600
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function grenade_death_indicator_hudelement_cleanup(hudElemIcon, hudElemPointer)
{
	self endon("disconnect");
	self waittill("spawned");
	hudElemIcon destroy();
	hudElemPointer destroy();
}

/*
	Name: special_death_indicator_hudelement
	Namespace: load
	Checksum: 0xF8F3D539
	Offset: 0x2668
	Size: 0x1C3
	Parameters: 6
	Flags: None
*/
function special_death_indicator_hudelement(shader, iWidth, iHeight, fDelay, x, y)
{
	if(!isdefined(fDelay))
	{
		fDelay = 0.5;
	}
	wait(fDelay);
	overlay = newClientHudElem(self);
	if(isdefined(x))
	{
		overlay.x = x;
	}
	else
	{
		overlay.x = 0;
	}
	if(isdefined(y))
	{
		overlay.y = y;
	}
	else
	{
		overlay.y = 40;
	}
	overlay SetShader(shader, iWidth, iHeight);
	overlay.alignX = "center";
	overlay.alignY = "middle";
	overlay.horzAlign = "center";
	overlay.vertAlign = "middle";
	overlay.foreground = 1;
	overlay.alpha = 0;
	overlay fadeOverTime(1);
	overlay.alpha = 1;
	overlay.hidewheninmenu = 1;
	self thread special_death_death_indicator_hudelement_cleanup(overlay);
}

/*
	Name: special_death_death_indicator_hudelement_cleanup
	Namespace: load
	Checksum: 0xEE24E4C9
	Offset: 0x2838
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function special_death_death_indicator_hudelement_cleanup(overlay)
{
	self endon("disconnect");
	self waittill("spawned");
	overlay destroy();
}

/*
	Name: water_think
	Namespace: load
	Checksum: 0xBFB5C250
	Offset: 0x2880
	Size: 0x447
	Parameters: 0
	Flags: None
*/
function water_think()
{
	/#
		Assert(isdefined(self.target));
	#/
	targeted = GetEnt(self.target, "targetname");
	/#
		Assert(isdefined(targeted));
	#/
	waterHeight = targeted.origin[2];
	targeted = undefined;
	level.depth_allow_prone = 8;
	level.depth_allow_crouch = 33;
	level.depth_allow_stand = 50;
	while(1)
	{
		wait(0.05);
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			if(players[i].inWater)
			{
				players[i] AllowProne(1);
				players[i] AllowCrouch(1);
				players[i] AllowStand(1);
			}
		}
		self waittill("trigger", other);
		if(!isPlayer(other))
		{
			continue;
		}
		while(1)
		{
			players = GetPlayers();
			players_in_water_count = 0;
			for(i = 0; i < players.size; i++)
			{
				if(players[i] istouching(self))
				{
					players_in_water_count++;
					players[i].inWater = 1;
					playerOrg = players[i] GetOrigin();
					d = playerOrg[2] - waterHeight;
					if(d > 0)
					{
						continue;
					}
					newSpeed = Int(level.default_run_speed - Abs(d * 5));
					if(newSpeed < 50)
					{
						newSpeed = 50;
					}
					/#
						Assert(newSpeed <= 190);
					#/
					if(Abs(d) > level.depth_allow_crouch)
					{
						players[i] AllowCrouch(0);
					}
					else
					{
						players[i] AllowCrouch(1);
					}
					if(Abs(d) > level.depth_allow_prone)
					{
						players[i] AllowProne(0);
					}
					else
					{
						players[i] AllowProne(1);
					}
					continue;
				}
				if(players[i].inWater)
				{
					players[i].inWater = 0;
				}
			}
			if(players_in_water_count == 0)
			{
				break;
			}
			wait(0.5);
		}
		wait(0.05);
	}
}

/*
	Name: indicate_start
	Namespace: load
	Checksum: 0xE3D7DDEF
	Offset: 0x2CD0
	Size: 0x13B
	Parameters: 1
	Flags: None
*/
function indicate_start(start)
{
	hudelem = NewHudElem();
	hudelem.alignX = "left";
	hudelem.alignY = "middle";
	hudelem.x = 70;
	hudelem.y = 400;
	hudelem.label = start;
	hudelem.alpha = 0;
	hudelem.fontscale = 3;
	wait(1);
	hudelem fadeOverTime(1);
	hudelem.alpha = 1;
	wait(5);
	hudelem fadeOverTime(1);
	hudelem.alpha = 0;
	wait(1);
	hudelem destroy();
}

/*
	Name: calculate_map_center
	Namespace: load
	Checksum: 0x9E185602
	Offset: 0x2E18
	Size: 0x1E3
	Parameters: 0
	Flags: None
*/
function calculate_map_center()
{
	if(!isdefined(level.mapCenter))
	{
		nodes = GetAllNodes();
		if(isdefined(nodes[0]))
		{
			level.nodesMins = nodes[0].origin;
			level.nodesMaxs = nodes[0].origin;
		}
		else
		{
			level.nodesMins = (0, 0, 0);
			level.nodesMaxs = (0, 0, 0);
		}
		for(index = 0; index < nodes.size; index++)
		{
			if(nodes[index].type == "BAD NODE")
			{
				/#
					println("Dev Block strings are not supported", nodes[index].origin);
				#/
				continue;
			}
			origin = nodes[index].origin;
			level.nodesMins = math::expand_mins(level.nodesMins, origin);
			level.nodesMaxs = math::expand_maxs(level.nodesMaxs, origin);
		}
		level.mapCenter = math::find_box_center(level.nodesMins, level.nodesMaxs);
		/#
			println("Dev Block strings are not supported", level.mapCenter);
		#/
		setMapCenter(level.mapCenter);
	}
}

/*
	Name: set_objective_text_colors
	Namespace: load
	Checksum: 0x6B709E43
	Offset: 0x3008
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function set_objective_text_colors()
{
	MY_TEXTBRIGHTNESS_DEFAULT = "1.0 1.0 1.0";
	MY_TEXTBRIGHTNESS_90 = "0.9 0.9 0.9";
	MY_TEXTBRIGHTNESS_85 = "0.85 0.85 0.85";
	if(level.script == "armada")
	{
		SetSavedDvar("con_typewriterColorBase", MY_TEXTBRIGHTNESS_90);
		return;
	}
	SetSavedDvar("con_typewriterColorBase", MY_TEXTBRIGHTNESS_DEFAULT);
}

/*
	Name: lerp_trigger_dvar_value
	Namespace: load
	Checksum: 0x30BF5067
	Offset: 0x30A8
	Size: 0x121
	Parameters: 4
	Flags: None
*/
function lerp_trigger_dvar_value(trigger, dvar, value, time)
{
	trigger.lerping_dvar[dvar] = 1;
	steps = time * 20;
	curr_value = GetDvarFloat(dvar);
	diff = curr_value - value / steps;
	for(i = 0; i < steps; i++)
	{
		curr_value = curr_value - diff;
		SetSavedDvar(dvar, curr_value);
		wait(0.05);
	}
	SetSavedDvar(dvar, value);
	trigger.lerping_dvar[dvar] = 0;
}

/*
	Name: set_fog_progress
	Namespace: load
	Checksum: 0x29780F2
	Offset: 0x31D8
	Size: 0xEB
	Parameters: 1
	Flags: None
*/
function set_fog_progress(progress)
{
	anti_progress = 1 - progress;
	startdist = self.script_start_dist * anti_progress + self.script_start_dist * progress;
	halfwayDist = self.script_halfway_dist * anti_progress + self.script_halfway_dist * progress;
	color = self.script_color * anti_progress + self.script_color * progress;
	SetVolFog(startdist, halfwayDist, self.script_halfway_height, self.script_base_height, color[0], color[1], color[2], 0.4);
}

/*
	Name: ascii_logo
	Namespace: load
	Checksum: 0xA50B7B47
	Offset: 0x32D0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function ascii_logo()
{
	/#
		println("Dev Block strings are not supported");
	#/
}

/*
	Name: all_players_spawned
	Namespace: load
	Checksum: 0x45AF9438
	Offset: 0x3300
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function all_players_spawned()
{
	level flag::wait_till("all_players_connected");
	waittillframeend;
	level.host = util::getHostPlayer();
	while(1)
	{
		if(getnumconnectedplayers() == 0)
		{
			wait(0.05);
			continue;
		}
		players = GetPlayers();
		count = 0;
		for(i = 0; i < players.size; i++)
		{
			if(players[i].sessionstate == "playing")
			{
				count++;
			}
		}
		wait(0.05);
		if(count > 0)
		{
			level flag::set("first_player_spawned");
		}
		if(count == players.size)
		{
			break;
		}
	}
	level flag::set("all_players_spawned");
}

/*
	Name: shock_onpain
	Namespace: load
	Checksum: 0x875110EC
	Offset: 0x3468
	Size: 0x1DF
	Parameters: 0
	Flags: None
*/
function shock_onpain()
{
	self endon("death");
	self endon("disconnect");
	self endon("killOnPainMonitor");
	if(GetDvarString("blurpain") == "")
	{
		SetDvar("blurpain", "on");
	}
	while(1)
	{
		oldhealth = self.health;
		self waittill("damage", damage, attacker, direction_vec, point, mod);
		if(isdefined(level.shock_onpain) && !level.shock_onpain)
		{
			continue;
		}
		if(isdefined(self.shock_onpain) && !self.shock_onpain)
		{
			continue;
		}
		if(self.health < 1)
		{
			continue;
		}
		if(mod == "MOD_PROJECTILE")
		{
			continue;
		}
		else if(mod == "MOD_GRENADE_SPLASH" || mod == "MOD_GRENADE" || mod == "MOD_EXPLOSIVE" || mod == "MOD_PROJECTILE_SPLASH")
		{
			self shock_onexplosion(damage);
		}
		else if(GetDvarString("blurpain") == "on")
		{
			self shellshock("pain", 0.5);
		}
	}
}

/*
	Name: shock_onexplosion
	Namespace: load
	Checksum: 0x80405272
	Offset: 0x3650
	Size: 0xC1
	Parameters: 1
	Flags: None
*/
function shock_onexplosion(damage)
{
	time = 0;
	multiplier = self.maxhealth / 100;
	scaled_damage = damage * multiplier;
	if(scaled_damage >= 90)
	{
		time = 4;
	}
	else if(scaled_damage >= 50)
	{
		time = 3;
	}
	else if(scaled_damage >= 25)
	{
		time = 2;
	}
	else if(scaled_damage > 10)
	{
		time = 1;
	}
}

/*
	Name: shock_ondeath
	Namespace: load
	Checksum: 0xABB7BF06
	Offset: 0x3720
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function shock_ondeath()
{
	self waittill("death");
	if(isdefined(level.shock_ondeath) && !level.shock_ondeath)
	{
		return;
	}
	if(isdefined(self.shock_ondeath) && !self.shock_ondeath)
	{
		return;
	}
	if(isdefined(self.specialDeath))
	{
		return;
	}
	if(GetDvarString("r_texturebits") == "16")
	{
		return;
	}
}

/*
	Name: on_spawned
	Namespace: load
	Checksum: 0xCAB53541
	Offset: 0x37A8
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function on_spawned()
{
	if(!isdefined(self.player_inited) || !self.player_inited)
	{
		if(SessionModeIsCampaignGame())
		{
			self thread shock_ondeath();
			self thread shock_onpain();
		}
		wait(0.05);
		if(isdefined(self))
		{
			self.player_inited = 1;
		}
	}
}

/*
	Name: link_ents
	Namespace: load
	Checksum: 0xA913F354
	Offset: 0x3830
	Size: 0xF9
	Parameters: 0
	Flags: None
*/
function link_ents()
{
	foreach(ent in GetEntArray())
	{
		if(isdefined(ent.LinkTo))
		{
			e_link = GetEnt(ent.LinkTo, "linkname");
			if(isdefined(e_link))
			{
				ent EnableLinkTo();
				ent LinkTo(e_link);
			}
		}
	}
}

/*
	Name: art_review
	Namespace: load
	Checksum: 0x4FE714B4
	Offset: 0x3938
	Size: 0x241
	Parameters: 0
	Flags: None
*/
function art_review()
{
	str_dvar = GetDvarString("art_review");
	switch(str_dvar)
	{
		case "":
		{
			SetDvar("art_review", "0");
			break;
		}
		case "1":
		case "2":
		{
			hud = hud::createServerFontString("objective", 1.2);
			hud hud::setPoint("CENTER", "CENTER", 0, -200);
			hud.sort = 1001;
			hud.color = (1, 0, 0);
			hud setText("ART REVIEW");
			hud.foreground = 0;
			hud.hidewheninmenu = 0;
			if(SessionModeIsZombiesGame())
			{
				SetDvar("zombie_cheat", "2");
				if(str_dvar == "1")
				{
					SetDvar("zombie_devgui", "power_on");
				}
				break;
			}
			foreach(trig in trigger::get_all())
			{
				trig TriggerEnable(0);
			}
			level waittill("forever");
			break;
		}
	}
}

