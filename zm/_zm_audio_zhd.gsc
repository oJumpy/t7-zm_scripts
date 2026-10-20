#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\music_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace zm_audio_zhd;

/*
	Name: __init__sytem__
	Namespace: zm_audio_zhd
	Checksum: 0x107F701E
	Offset: 0x728
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_audio_zhd", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_audio_zhd
	Checksum: 0x6D7F67A5
	Offset: 0x768
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level flag::init("snd_zhdegg_activate");
	level flag::init("snd_zhdegg_completed");
	level flag::init("snd_song_completed");
	clientfield::register("scriptmover", "snd_zhdegg", 21000, 2, "int");
	clientfield::register("scriptmover", "snd_zhdegg_arm", 21000, 1, "counter");
	level.var_252a085b = 0;
	level thread snd_zhdegg_activate();
	level thread snd_monty_radio();
	level thread setup_personality_character_exerts();
}

/*
	Name: snd_zhdegg_activate
	Namespace: zm_audio_zhd
	Checksum: 0x6AA1ECDC
	Offset: 0x888
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function snd_zhdegg_activate()
{
	level flag::wait_till("snd_zhdegg_activate");
	level snd_zhdegg_start();
	while(1)
	{
		if(isdefined(level.var_61f315ab))
		{
			success = [[level.var_61f315ab]]();
		}
		else
		{
			success = level function_cf1b154();
		}
		if(!(isdefined(success) && success))
		{
			level snd_zhdegg_start(1);
			continue;
		}
		if(isdefined(level.var_8229c449))
		{
			level [[level.var_8229c449]]();
		}
		else
		{
			level snd_zhdegg_end();
		}
		break;
	}
	level thread zm_audio::sndMusicSystem_PlayState("sam");
}

/*
	Name: snd_zhdegg_start
	Namespace: zm_audio_zhd
	Checksum: 0x705CB4FD
	Offset: 0x9A8
	Size: 0x24B
	Parameters: 1
	Flags: None
*/
function snd_zhdegg_start(restart)
{
	if(!isdefined(restart))
	{
		restart = 0;
	}
	s_ballerina_start = struct::get("s_ballerina_start", "targetname");
	if(!isdefined(s_ballerina_start))
	{
		return;
	}
	if(!(isdefined(restart) && restart))
	{
		playsoundatposition("zmb_sam_egg_success", (0, 0, 0));
		mdl_ballerina = util::spawn_model(s_ballerina_start.model, s_ballerina_start.origin - VectorScale((0, 0, 1), 20), s_ballerina_start.angles);
		mdl_ballerina clientfield::set("snd_zhdegg", 2);
		mdl_ballerina moveto(s_ballerina_start.origin, 2);
		mdl_ballerina waittill("movedone");
	}
	else
	{
		playsoundatposition("zmb_sam_egg_fail", (0, 0, 0));
		mdl_ballerina = util::spawn_model(s_ballerina_start.model, s_ballerina_start.origin, s_ballerina_start.angles);
		mdl_ballerina clientfield::set("snd_zhdegg", 1);
	}
	s_ballerina_start zm_unitrigger::create_unitrigger(undefined, 80);
	s_ballerina_start waittill("trigger_activated");
	zm_unitrigger::unregister_unitrigger(s_ballerina_start.s_unitrigger);
	mdl_ballerina clientfield::set("snd_zhdegg", 0);
	util::wait_network_frame();
	mdl_ballerina delete();
}

/*
	Name: function_cf1b154
	Namespace: zm_audio_zhd
	Checksum: 0xA9D80ECF
	Offset: 0xC00
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function function_cf1b154()
{
	a_s_ballerina_timed = struct::get_array("s_ballerina_timed", "targetname");
	a_s_ballerina_timed = Array::randomize(a_s_ballerina_timed);
	if(isdefined(a_s_ballerina_timed[0].script_int))
	{
		a_s_ballerina_timed = Array::sort_by_script_int(a_s_ballerina_timed, 1);
	}
	n_amount = a_s_ballerina_timed.size;
	if(n_amount >= 5)
	{
		n_amount = 5;
	}
	for(i = 0; i < n_amount; i++)
	{
		success = a_s_ballerina_timed[i] function_3cf3ba48();
		if(!(isdefined(success) && success))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: function_3cf3ba48
	Namespace: zm_audio_zhd
	Checksum: 0x80470CD8
	Offset: 0xD20
	Size: 0x199
	Parameters: 0
	Flags: None
*/
function function_3cf3ba48()
{
	self.mdl_ballerina = util::spawn_model(self.model, self.origin, self.angles);
	self.mdl_ballerina clientfield::set("snd_zhdegg", 1);
	self.mdl_ballerina PlayLoopSound("mus_musicbox_lp", 2);
	self.success = 0;
	self thread function_9d55fd08();
	self thread function_2fdaabf3();
	self thread function_a9a34039();
	/#
		self.mdl_ballerina thread zm_utility::print3d_ent("Dev Block strings are not supported", (0, 1, 0), 3, VectorScale((0, 0, 1), 24));
	#/
	self util::waittill_any("ballerina_destroyed", "ballerina_timeout");
	/#
		self.mdl_ballerina notify("end_print3d");
	#/
	self.mdl_ballerina clientfield::set("snd_zhdegg", 0);
	util::wait_network_frame();
	self.mdl_ballerina delete();
	return self.success;
}

/*
	Name: function_9d55fd08
	Namespace: zm_audio_zhd
	Checksum: 0x3BFA8F44
	Offset: 0xEC8
	Size: 0x65
	Parameters: 0
	Flags: None
*/
function function_9d55fd08()
{
	self.mdl_ballerina endon("death");
	self endon("hash_636d801f");
	self endon("ballerina_destroyed");
	self endon("ballerina_timeout");
	while(1)
	{
		self.mdl_ballerina RotateYaw(360, 4);
		wait(4);
	}
}

/*
	Name: function_2fdaabf3
	Namespace: zm_audio_zhd
	Checksum: 0xDD62F5C
	Offset: 0xF38
	Size: 0x1A3
	Parameters: 0
	Flags: None
*/
function function_2fdaabf3()
{
	self endon("ballerina_timeout");
	self.mdl_ballerina SetCanDamage(1);
	self.mdl_ballerina.health = 1000000;
	while(1)
	{
		self.mdl_ballerina waittill("damage", damage, attacker, dir, loc, type, model, tag, part, weapon, flags);
		if(isdefined(level.var_252a085b) && level.var_252a085b)
		{
			continue;
		}
		if(!isdefined(attacker) || !isPlayer(attacker))
		{
			continue;
		}
		if(type == "MOD_PROJECTILE" || type == "MOD_GRENADE_SPLASH" || type == "MOD_GRENADE" || type == "MOD_EXPLOSIVE")
		{
			continue;
		}
		self.success = 1;
		self notify("ballerina_destroyed");
		level.var_252a085b = 1;
		wait(0.1);
		level.var_252a085b = 0;
		break;
	}
}

/*
	Name: function_a9a34039
	Namespace: zm_audio_zhd
	Checksum: 0x51CBD27D
	Offset: 0x10E8
	Size: 0x51
	Parameters: 0
	Flags: None
*/
function function_a9a34039()
{
	self endon("ballerina_destroyed");
	if(level.players.size > 1)
	{
		wait(90 - 15 * level.players.size);
	}
	else
	{
		wait(90);
	}
	self notify("ballerina_timeout");
}

/*
	Name: snd_zhdegg_end
	Namespace: zm_audio_zhd
	Checksum: 0xC8029FD0
	Offset: 0x1148
	Size: 0x553
	Parameters: 0
	Flags: None
*/
function snd_zhdegg_end()
{
	playsoundatposition("zmb_sam_egg_success", (0, 0, 0));
	s_ballerina_end = struct::get("s_ballerina_end", "targetname");
	s_ballerina_end.mdl_ballerina = util::spawn_model(s_ballerina_end.model, s_ballerina_end.origin, s_ballerina_end.angles);
	s_ballerina_end.mdl_ballerina clientfield::set("snd_zhdegg", 1);
	s_ballerina_end.mdl_ballerina PlayLoopSound("mus_musicbox_lp", 2);
	s_ballerina_end thread function_9d55fd08();
	s_ballerina_end zm_unitrigger::create_unitrigger(undefined, 65);
	s_ballerina_end waittill("trigger_activated");
	zm_unitrigger::unregister_unitrigger(s_ballerina_end.s_unitrigger);
	s_ballerina_end notify("hash_636d801f");
	s_ballerina_end.mdl_ballerina StopLoopSound(0.5);
	s_ballerina_end.mdl_ballerina playsound("zmb_challenge_skel_arm_up");
	var_f6c28cea = (2, 0, -6.5);
	var_e97ebb83 = (3.5, 0, -18.5);
	s_ballerina_end.mdl_hand = util::spawn_model("c_zom_dlc1_skeleton_zombie_body_s_rarm", s_ballerina_end.origin, s_ballerina_end.angles);
	s_ballerina_end.var_2a9b65c7 = util::spawn_model("p7_skulls_bones_arm_lower", s_ballerina_end.origin + var_f6c28cea, VectorScale((1, 0, 0), 180));
	s_ballerina_end.var_79dc7980 = util::spawn_model("p7_skulls_bones_arm_lower", s_ballerina_end.origin + var_e97ebb83, VectorScale((1, 0, 0), 180));
	s_ballerina_end.mdl_ballerina MoveZ(20, 0.5);
	s_ballerina_end.mdl_hand MoveZ(20, 0.5);
	s_ballerina_end.var_2a9b65c7 MoveZ(20, 0.5);
	s_ballerina_end.var_79dc7980 MoveZ(20, 0.5);
	wait(0.05);
	s_ballerina_end.mdl_hand clientfield::increment("snd_zhdegg_arm");
	s_ballerina_end.mdl_hand waittill("movedone");
	wait(1);
	s_ballerina_end.mdl_ballerina PlayLoopSound("zmb_challenge_skel_arm_lp", 0.25);
	s_ballerina_end.mdl_ballerina MoveZ(-40, 1.5);
	s_ballerina_end.mdl_hand MoveZ(-40, 1.5);
	s_ballerina_end.var_2a9b65c7 MoveZ(-40, 1.5);
	s_ballerina_end.var_79dc7980 MoveZ(-40, 1.5);
	s_ballerina_end.mdl_ballerina waittill("movedone");
	zm_powerups::specific_powerup_drop("full_ammo", s_ballerina_end.origin);
	s_ballerina_end.mdl_ballerina delete();
	s_ballerina_end.mdl_hand delete();
	s_ballerina_end.var_2a9b65c7 delete();
	s_ballerina_end.var_79dc7980 delete();
	level flag::set("snd_zhdegg_completed");
}

/*
	Name: function_e753d4f
	Namespace: zm_audio_zhd
	Checksum: 0x43E40827
	Offset: 0x16A8
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function function_e753d4f()
{
	level.var_2a0600f = 0;
	var_8bd44282 = struct::get_array("songstructs", "targetname");
	Array::thread_all(var_8bd44282, &function_929c4dba);
	while(1)
	{
		level waittill("hash_9b53c751");
		if(level.var_2a0600f == var_8bd44282.size)
		{
			break;
		}
	}
	level flag::set("snd_song_completed");
}

/*
	Name: function_929c4dba
	Namespace: zm_audio_zhd
	Checksum: 0x2FDDF483
	Offset: 0x1760
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function function_929c4dba()
{
	e_origin = spawn("script_origin", self.origin);
	e_origin zm_unitrigger::create_unitrigger();
	e_origin PlayLoopSound("zmb_ee_mus_lp", 1);
	/#
		e_origin thread zm_utility::print3d_ent("Dev Block strings are not supported", (1, 1, 0), 3, VectorScale((0, 0, 1), 24));
	#/
	while(!(isdefined(e_origin.b_activated) && e_origin.b_activated))
	{
		e_origin waittill("trigger_activated", who);
		if(!function_8090042c())
		{
			continue;
		}
		who notify("hash_9b53c751");
		e_origin function_bd90259b(who);
	}
	/#
		e_origin notify("end_print3d");
	#/
	zm_unitrigger::unregister_unitrigger(e_origin.s_unitrigger);
	e_origin delete();
}

/*
	Name: function_8090042c
	Namespace: zm_audio_zhd
	Checksum: 0xD304A02A
	Offset: 0x18E0
	Size: 0x4D
	Parameters: 0
	Flags: None
*/
function function_8090042c()
{
	if(isdefined(level.musicSystem.currentPlaytype) && level.musicSystem.currentPlaytype >= 4 || (isdefined(level.musicSystemOverride) && level.musicSystemOverride))
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_bd90259b
	Namespace: zm_audio_zhd
	Checksum: 0x9D6A36C4
	Offset: 0x1938
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function function_bd90259b(e_player)
{
	if(!(isdefined(self.b_activated) && self.b_activated))
	{
		self.b_activated = 1;
		level.var_2a0600f++;
		level notify("hash_9b53c751", e_player);
		self StopLoopSound(0.2);
	}
	self playsound("zmb_ee_mus_activate");
}

/*
	Name: snd_monty_radio
	Namespace: zm_audio_zhd
	Checksum: 0xA52F3B72
	Offset: 0x19C8
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function snd_monty_radio()
{
	level waittill("connected", player);
	s_radio = struct::get("snd_monty_radio", "targetname");
	if(!isdefined(s_radio))
	{
		return;
	}
	s_radio zm_unitrigger::create_unitrigger();
	s_radio waittill("trigger_activated");
	playsoundatposition("vox_abcd_radio", s_radio.origin);
	zm_unitrigger::unregister_unitrigger(s_radio.s_unitrigger);
}

/*
	Name: setup_personality_character_exerts
	Namespace: zm_audio_zhd
	Checksum: 0x3814DDE0
	Offset: 0x1A98
	Size: 0x621
	Parameters: 0
	Flags: None
*/
function setup_personality_character_exerts()
{
	level.exert_sounds[1]["hitmed"][0] = "vox_plr_0_exert_pain_0";
	level.exert_sounds[1]["hitmed"][1] = "vox_plr_0_exert_pain_1";
	level.exert_sounds[1]["hitmed"][2] = "vox_plr_0_exert_pain_2";
	level.exert_sounds[1]["hitmed"][3] = "vox_plr_0_exert_pain_3";
	level.exert_sounds[1]["hitmed"][4] = "vox_plr_0_exert_pain_4";
	level.exert_sounds[2]["hitmed"][0] = "vox_plr_1_exert_pain_0";
	level.exert_sounds[2]["hitmed"][1] = "vox_plr_1_exert_pain_1";
	level.exert_sounds[2]["hitmed"][2] = "vox_plr_1_exert_pain_2";
	level.exert_sounds[2]["hitmed"][3] = "vox_plr_1_exert_pain_3";
	level.exert_sounds[2]["hitmed"][4] = "vox_plr_1_exert_pain_4";
	level.exert_sounds[3]["hitmed"][0] = "vox_plr_2_exert_pain_0";
	level.exert_sounds[3]["hitmed"][1] = "vox_plr_2_exert_pain_1";
	level.exert_sounds[3]["hitmed"][2] = "vox_plr_2_exert_pain_2";
	level.exert_sounds[3]["hitmed"][3] = "vox_plr_2_exert_pain_3";
	level.exert_sounds[3]["hitmed"][4] = "vox_plr_2_exert_pain_4";
	level.exert_sounds[4]["hitmed"][0] = "vox_plr_3_exert_pain_0";
	level.exert_sounds[4]["hitmed"][1] = "vox_plr_3_exert_pain_1";
	level.exert_sounds[4]["hitmed"][2] = "vox_plr_3_exert_pain_2";
	level.exert_sounds[4]["hitmed"][3] = "vox_plr_3_exert_pain_3";
	level.exert_sounds[4]["hitmed"][3] = "vox_plr_3_exert_pain_4";
	level.exert_sounds[1]["hitlrg"][0] = "vox_plr_0_exert_pain_0";
	level.exert_sounds[1]["hitlrg"][1] = "vox_plr_0_exert_pain_1";
	level.exert_sounds[1]["hitlrg"][2] = "vox_plr_0_exert_pain_2";
	level.exert_sounds[1]["hitlrg"][3] = "vox_plr_0_exert_pain_3";
	level.exert_sounds[1]["hitlrg"][4] = "vox_plr_0_exert_pain_4";
	level.exert_sounds[2]["hitlrg"][0] = "vox_plr_1_exert_pain_0";
	level.exert_sounds[2]["hitlrg"][1] = "vox_plr_1_exert_pain_1";
	level.exert_sounds[2]["hitlrg"][2] = "vox_plr_1_exert_pain_2";
	level.exert_sounds[2]["hitlrg"][3] = "vox_plr_1_exert_pain_3";
	level.exert_sounds[2]["hitlrg"][4] = "vox_plr_1_exert_pain_4";
	level.exert_sounds[3]["hitlrg"][0] = "vox_plr_2_exert_pain_0";
	level.exert_sounds[3]["hitlrg"][1] = "vox_plr_2_exert_pain_1";
	level.exert_sounds[3]["hitlrg"][2] = "vox_plr_2_exert_pain_2";
	level.exert_sounds[3]["hitlrg"][3] = "vox_plr_2_exert_pain_3";
	level.exert_sounds[3]["hitlrg"][4] = "vox_plr_2_exert_pain_4";
	level.exert_sounds[4]["hitlrg"][0] = "vox_plr_3_exert_pain_0";
	level.exert_sounds[4]["hitlrg"][1] = "vox_plr_3_exert_pain_1";
	level.exert_sounds[4]["hitlrg"][2] = "vox_plr_3_exert_pain_2";
	level.exert_sounds[4]["hitlrg"][3] = "vox_plr_3_exert_pain_3";
	level.exert_sounds[4]["hitlrg"][4] = "vox_plr_3_exert_pain_4";
}

/*
	Name: set_exert_id
	Namespace: zm_audio_zhd
	Checksum: 0x8DF49E05
	Offset: 0x20C8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function set_exert_id()
{
	self endon("disconnect");
	util::wait_network_frame();
	util::wait_network_frame();
	self zm_audio::SetExertVoice(self.characterindex + 1);
}

