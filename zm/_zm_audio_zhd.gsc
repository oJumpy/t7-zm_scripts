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

#namespace namespace_52adc03e;

/*
	Name: __init__sytem__
	Namespace: namespace_52adc03e
	Checksum: 0xE2F04C87
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
	Namespace: namespace_52adc03e
	Checksum: 0x8BF5F3CB
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
	level thread function_f9e823ac();
	level thread function_e1e44e18();
	level thread setup_personality_character_exerts();
}

/*
	Name: function_f9e823ac
	Namespace: namespace_52adc03e
	Checksum: 0x6C5DF029
	Offset: 0x888
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function function_f9e823ac()
{
	level flag::wait_till("snd_zhdegg_activate");
	level function_513f51e1();
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
			level function_513f51e1(1);
			continue;
		}
		if(isdefined(level.var_8229c449))
		{
			level [[level.var_8229c449]]();
		}
		else
		{
			level function_5b2770da();
		}
		break;
	}
	level thread zm_audio::sndMusicSystem_PlayState("sam");
}

/*
	Name: function_513f51e1
	Namespace: namespace_52adc03e
	Checksum: 0xC36E9B5F
	Offset: 0x9A8
	Size: 0x24B
	Parameters: 1
	Flags: None
*/
function function_513f51e1(restart)
{
	if(!isdefined(restart))
	{
		restart = 0;
	}
	var_6175d76c = struct::get("s_ballerina_start", "targetname");
	if(!isdefined(var_6175d76c))
	{
		return;
	}
	if(!(isdefined(restart) && restart))
	{
		playsoundatposition("zmb_sam_egg_success", (0, 0, 0));
		var_ac086ffb = util::spawn_model(var_6175d76c.model, var_6175d76c.origin - VectorScale((0, 0, 1), 20), var_6175d76c.angles);
		var_ac086ffb clientfield::set("snd_zhdegg", 2);
		var_ac086ffb moveto(var_6175d76c.origin, 2);
		var_ac086ffb waittill("movedone");
	}
	else
	{
		playsoundatposition("zmb_sam_egg_fail", (0, 0, 0));
		var_ac086ffb = util::spawn_model(var_6175d76c.model, var_6175d76c.origin, var_6175d76c.angles);
		var_ac086ffb clientfield::set("snd_zhdegg", 1);
	}
	var_6175d76c zm_unitrigger::create_unitrigger(undefined, 80);
	var_6175d76c waittill("trigger_activated");
	zm_unitrigger::unregister_unitrigger(var_6175d76c.s_unitrigger);
	var_ac086ffb clientfield::set("snd_zhdegg", 0);
	util::wait_network_frame();
	var_ac086ffb delete();
}

/*
	Name: function_cf1b154
	Namespace: namespace_52adc03e
	Checksum: 0xA51385EA
	Offset: 0xC00
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function function_cf1b154()
{
	var_d1f154fd = struct::get_array("s_ballerina_timed", "targetname");
	var_d1f154fd = Array::randomize(var_d1f154fd);
	if(isdefined(var_d1f154fd[0].script_int))
	{
		var_d1f154fd = Array::sort_by_script_int(var_d1f154fd, 1);
	}
	n_amount = var_d1f154fd.size;
	if(n_amount >= 5)
	{
		n_amount = 5;
	}
	for(i = 0; i < n_amount; i++)
	{
		success = var_d1f154fd[i] function_3cf3ba48();
		if(!(isdefined(success) && success))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: function_3cf3ba48
	Namespace: namespace_52adc03e
	Checksum: 0x52B033E6
	Offset: 0xD20
	Size: 0x199
	Parameters: 0
	Flags: None
*/
function function_3cf3ba48()
{
	self.var_ac086ffb = util::spawn_model(self.model, self.origin, self.angles);
	self.var_ac086ffb clientfield::set("snd_zhdegg", 1);
	self.var_ac086ffb PlayLoopSound("mus_musicbox_lp", 2);
	self.success = 0;
	self thread function_9d55fd08();
	self thread function_2fdaabf3();
	self thread function_a9a34039();
	/#
		self.var_ac086ffb thread zm_utility::print3d_ent("Dev Block strings are not supported", (0, 1, 0), 3, VectorScale((0, 0, 1), 24));
	#/
	self util::waittill_any("ballerina_destroyed", "ballerina_timeout");
	/#
		self.var_ac086ffb notify("end_print3d");
	#/
	self.var_ac086ffb clientfield::set("snd_zhdegg", 0);
	util::wait_network_frame();
	self.var_ac086ffb delete();
	return self.success;
}

/*
	Name: function_9d55fd08
	Namespace: namespace_52adc03e
	Checksum: 0x70B5D7BA
	Offset: 0xEC8
	Size: 0x65
	Parameters: 0
	Flags: None
*/
function function_9d55fd08()
{
	self.var_ac086ffb endon("death");
	self endon("hash_636d801f");
	self endon("hash_72624b2b");
	self endon("hash_874b5073");
	while(1)
	{
		self.var_ac086ffb RotateYaw(360, 4);
		wait(4);
	}
}

/*
	Name: function_2fdaabf3
	Namespace: namespace_52adc03e
	Checksum: 0xEDF5438D
	Offset: 0xF38
	Size: 0x1A3
	Parameters: 0
	Flags: None
*/
function function_2fdaabf3()
{
	self endon("hash_874b5073");
	self.var_ac086ffb SetCanDamage(1);
	self.var_ac086ffb.health = 1000000;
	while(1)
	{
		self.var_ac086ffb waittill("damage", damage, attacker, dir, loc, type, model, tag, part, weapon, flags);
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
		self notify("hash_72624b2b");
		level.var_252a085b = 1;
		wait(0.1);
		level.var_252a085b = 0;
		break;
	}
}

/*
	Name: function_a9a34039
	Namespace: namespace_52adc03e
	Checksum: 0x7F53D85
	Offset: 0x10E8
	Size: 0x51
	Parameters: 0
	Flags: None
*/
function function_a9a34039()
{
	self endon("hash_72624b2b");
	if(level.players.size > 1)
	{
		wait(90 - 15 * level.players.size);
	}
	else
	{
		wait(90);
	}
	self notify("hash_874b5073");
}

/*
	Name: function_5b2770da
	Namespace: namespace_52adc03e
	Checksum: 0xAA2AE58C
	Offset: 0x1148
	Size: 0x553
	Parameters: 0
	Flags: None
*/
function function_5b2770da()
{
	playsoundatposition("zmb_sam_egg_success", (0, 0, 0));
	var_2ba18547 = struct::get("s_ballerina_end", "targetname");
	var_2ba18547.var_ac086ffb = util::spawn_model(var_2ba18547.model, var_2ba18547.origin, var_2ba18547.angles);
	var_2ba18547.var_ac086ffb clientfield::set("snd_zhdegg", 1);
	var_2ba18547.var_ac086ffb PlayLoopSound("mus_musicbox_lp", 2);
	var_2ba18547 thread function_9d55fd08();
	var_2ba18547 zm_unitrigger::create_unitrigger(undefined, 65);
	var_2ba18547 waittill("trigger_activated");
	zm_unitrigger::unregister_unitrigger(var_2ba18547.s_unitrigger);
	var_2ba18547 notify("hash_636d801f");
	var_2ba18547.var_ac086ffb StopLoopSound(0.5);
	var_2ba18547.var_ac086ffb playsound("zmb_challenge_skel_arm_up");
	var_f6c28cea = (2, 0, -6.5);
	var_e97ebb83 = (3.5, 0, -18.5);
	var_2ba18547.var_3609adde = util::spawn_model("c_zom_dlc1_skeleton_zombie_body_s_rarm", var_2ba18547.origin, var_2ba18547.angles);
	var_2ba18547.var_2a9b65c7 = util::spawn_model("p7_skulls_bones_arm_lower", var_2ba18547.origin + var_f6c28cea, VectorScale((1, 0, 0), 180));
	var_2ba18547.var_79dc7980 = util::spawn_model("p7_skulls_bones_arm_lower", var_2ba18547.origin + var_e97ebb83, VectorScale((1, 0, 0), 180));
	var_2ba18547.var_ac086ffb MoveZ(20, 0.5);
	var_2ba18547.var_3609adde MoveZ(20, 0.5);
	var_2ba18547.var_2a9b65c7 MoveZ(20, 0.5);
	var_2ba18547.var_79dc7980 MoveZ(20, 0.5);
	wait(0.05);
	var_2ba18547.var_3609adde clientfield::increment("snd_zhdegg_arm");
	var_2ba18547.var_3609adde waittill("movedone");
	wait(1);
	var_2ba18547.var_ac086ffb PlayLoopSound("zmb_challenge_skel_arm_lp", 0.25);
	var_2ba18547.var_ac086ffb MoveZ(-40, 1.5);
	var_2ba18547.var_3609adde MoveZ(-40, 1.5);
	var_2ba18547.var_2a9b65c7 MoveZ(-40, 1.5);
	var_2ba18547.var_79dc7980 MoveZ(-40, 1.5);
	var_2ba18547.var_ac086ffb waittill("movedone");
	zm_powerups::specific_powerup_drop("full_ammo", var_2ba18547.origin);
	var_2ba18547.var_ac086ffb delete();
	var_2ba18547.var_3609adde delete();
	var_2ba18547.var_2a9b65c7 delete();
	var_2ba18547.var_79dc7980 delete();
	level flag::set("snd_zhdegg_completed");
}

/*
	Name: function_e753d4f
	Namespace: namespace_52adc03e
	Checksum: 0x7B686BA6
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
	Namespace: namespace_52adc03e
	Checksum: 0x7AED8638
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
	Namespace: namespace_52adc03e
	Checksum: 0xDC1D08EC
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
	Namespace: namespace_52adc03e
	Checksum: 0x3E61F717
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
	Name: function_e1e44e18
	Namespace: namespace_52adc03e
	Checksum: 0x795419
	Offset: 0x19C8
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function function_e1e44e18()
{
	level waittill("connected", player);
	var_77754758 = struct::get("snd_monty_radio", "targetname");
	if(!isdefined(var_77754758))
	{
		return;
	}
	var_77754758 zm_unitrigger::create_unitrigger();
	var_77754758 waittill("trigger_activated");
	playsoundatposition("vox_abcd_radio", var_77754758.origin);
	zm_unitrigger::unregister_unitrigger(var_77754758.s_unitrigger);
}

/*
	Name: setup_personality_character_exerts
	Namespace: namespace_52adc03e
	Checksum: 0x8EB30A4C
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
	Namespace: namespace_52adc03e
	Checksum: 0x55A6C3A6
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

