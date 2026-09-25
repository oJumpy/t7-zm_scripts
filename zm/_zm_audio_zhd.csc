#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\beam_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_52adc03e;

/*
	Name: __init__sytem__
	Namespace: namespace_52adc03e
	Checksum: 0xB5103422
	Offset: 0x5F0
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
	Checksum: 0x839BD7D2
	Offset: 0x630
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "snd_zhdegg", 21000, 2, "int", &function_97d247be, 0, 0);
	clientfield::register("scriptmover", "snd_zhdegg_arm", 21000, 1, "counter", &function_e312f684, 0, 0);
	level._effect["zhdegg_ballerina_appear"] = "dlc3/stalingrad/fx_main_impact_success";
	level._effect["zhdegg_ballerina_disappear"] = "dlc3/stalingrad/fx_main_impact_success";
	level._effect["zhdegg_arm_appear"] = "dlc3/stalingrad/fx_dirt_hand_burst_challenges";
	level thread setup_personality_character_exerts();
}

/*
	Name: function_97d247be
	Namespace: namespace_52adc03e
	Checksum: 0xF6F1245
	Offset: 0x738
	Size: 0x10B
	Parameters: 7
	Flags: None
*/
function function_97d247be(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(newVal == 1)
		{
			playFX(localClientNum, level._effect["zhdegg_ballerina_appear"], self.origin);
			playsound(0, "zmb_sam_egg_appear", self.origin);
		}
	}
	else
	{
		playFX(localClientNum, level._effect["zhdegg_ballerina_disappear"], self.origin);
		playsound(0, "zmb_sam_egg_disappear", self.origin);
	}
}

/*
	Name: function_e312f684
	Namespace: namespace_52adc03e
	Checksum: 0x4D78CB81
	Offset: 0x850
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_e312f684(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playFX(localClientNum, level._effect["zhdegg_arm_appear"], self.origin, (0, 0, 1));
	}
}

/*
	Name: setup_personality_character_exerts
	Namespace: namespace_52adc03e
	Checksum: 0x43DC65DD
	Offset: 0x8D8
	Size: 0x4D9
	Parameters: 0
	Flags: None
*/
function setup_personality_character_exerts()
{
	util::waitforclient(0);
	level.exert_sounds[1]["meleeswipesoundplayer"][0] = "vox_plr_0_exert_knife_swipe_0";
	level.exert_sounds[1]["meleeswipesoundplayer"][1] = "vox_plr_0_exert_knife_swipe_1";
	level.exert_sounds[1]["meleeswipesoundplayer"][2] = "vox_plr_0_exert_knife_swipe_2";
	level.exert_sounds[1]["meleeswipesoundplayer"][3] = "vox_plr_0_exert_knife_swipe_3";
	level.exert_sounds[1]["meleeswipesoundplayer"][4] = "vox_plr_0_exert_knife_swipe_4";
	level.exert_sounds[2]["meleeswipesoundplayer"][0] = "vox_plr_1_exert_knife_swipe_0";
	level.exert_sounds[2]["meleeswipesoundplayer"][1] = "vox_plr_1_exert_knife_swipe_1";
	level.exert_sounds[2]["meleeswipesoundplayer"][2] = "vox_plr_1_exert_knife_swipe_2";
	level.exert_sounds[2]["meleeswipesoundplayer"][3] = "vox_plr_1_exert_knife_swipe_3";
	level.exert_sounds[2]["meleeswipesoundplayer"][4] = "vox_plr_1_exert_knife_swipe_4";
	level.exert_sounds[3]["meleeswipesoundplayer"][0] = "vox_plr_2_exert_knife_swipe_0";
	level.exert_sounds[3]["meleeswipesoundplayer"][1] = "vox_plr_2_exert_knife_swipe_1";
	level.exert_sounds[3]["meleeswipesoundplayer"][2] = "vox_plr_2_exert_knife_swipe_2";
	level.exert_sounds[3]["meleeswipesoundplayer"][3] = "vox_plr_2_exert_knife_swipe_3";
	level.exert_sounds[3]["meleeswipesoundplayer"][4] = "vox_plr_2_exert_knife_swipe_4";
	level.exert_sounds[4]["meleeswipesoundplayer"][0] = "vox_plr_3_exert_knife_swipe_0";
	level.exert_sounds[4]["meleeswipesoundplayer"][1] = "vox_plr_3_exert_knife_swipe_1";
	level.exert_sounds[4]["meleeswipesoundplayer"][2] = "vox_plr_3_exert_knife_swipe_2";
	level.exert_sounds[4]["meleeswipesoundplayer"][3] = "vox_plr_3_exert_knife_swipe_3";
	level.exert_sounds[4]["meleeswipesoundplayer"][4] = "vox_plr_3_exert_knife_swipe_4";
	level.exert_sounds[1]["playerbreathinsound"][0] = "vox_plr_0_exert_inhale_0";
	level.exert_sounds[2]["playerbreathinsound"][0] = "vox_plr_1_exert_inhale_0";
	level.exert_sounds[3]["playerbreathinsound"][0] = "vox_plr_2_exert_inhale_0";
	level.exert_sounds[4]["playerbreathinsound"][0] = "vox_plr_3_exert_inhale_0";
	level.exert_sounds[1]["playerbreathoutsound"][0] = "vox_plr_0_exert_exhale_0";
	level.exert_sounds[2]["playerbreathoutsound"][0] = "vox_plr_1_exert_exhale_0";
	level.exert_sounds[3]["playerbreathoutsound"][0] = "vox_plr_2_exert_exhale_0";
	level.exert_sounds[4]["playerbreathoutsound"][0] = "vox_plr_3_exert_exhale_0";
	level.exert_sounds[1]["playerbreathgaspsound"][0] = "vox_plr_0_exert_exhale_0";
	level.exert_sounds[2]["playerbreathgaspsound"][0] = "vox_plr_1_exert_exhale_0";
	level.exert_sounds[3]["playerbreathgaspsound"][0] = "vox_plr_2_exert_exhale_0";
	level.exert_sounds[4]["playerbreathgaspsound"][0] = "vox_plr_3_exert_exhale_0";
}

