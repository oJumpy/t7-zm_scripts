#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_moon_amb;
#using scripts\zm\zm_moon_sq;

#namespace zm_moon_sq_datalogs;

/*
	Name: init
	Namespace: zm_moon_sq_datalogs
	Checksum: 0xFFAE8298
	Offset: 0x368
	Size: 0x403
	Parameters: 0
	Flags: None
*/
function init()
{
	datalogs = Array("vox_story_2_log_1", "vox_story_2_log_2", "vox_story_2_log_3", "vox_story_2_log_4", "vox_story_2_log_5", "vox_story_2_log_6");
	datalogs_delay = [];
	datalogs_delay["vox_story_2_log_1"] = 40;
	datalogs_delay["vox_story_2_log_2"] = 28;
	datalogs_delay["vox_story_2_log_3"] = 29;
	datalogs_delay["vox_story_2_log_4"] = 52;
	datalogs_delay["vox_story_2_log_5"] = 37;
	datalogs_delay["vox_story_2_log_6"] = 138;
	i = 0;
	datalog_locs = struct::get_array("sq_datalog", "targetname");
	player = struct::get("sq_reel_to_reel", "targetname");
	datalog_locs = Array::randomize(datalog_locs);
	while(i < datalogs.size)
	{
		log_struct = datalog_locs[0];
		Log = spawn("script_model", log_struct.origin);
		if(isdefined(log_struct.angles))
		{
			Log.angles = log_struct.angles;
		}
		Log SetModel("p7_zm_moo_data_reel");
		Log thread zm_sidequests::fake_use("pickedup");
		Log waittill("pickedup", who);
		playsoundatposition("fly_log_pickup", who.origin);
		who._has_log = 1;
		Log delete();
		who zm_sidequests::add_sidequest_icon("sq", "datalog");
		player thread zm_sidequests::fake_use("placed", &log_qualifier);
		player waittill("placed", who);
		who._has_log = undefined;
		who zm_sidequests::remove_sidequest_icon("sq", "datalog");
		sound_ent = spawn("script_origin", player.origin);
		sound_ent PlaySoundWithNotify(datalogs[i], "sounddone");
		sound_ent PlayLoopSound("vox_radio_egg_snapshot", 1);
		wait(datalogs_delay[datalogs[i]]);
		sound_ent StopLoopSound(1);
		i++;
		ArrayRemoveValue(datalog_locs, log_struct);
		datalog_locs = Array::randomize(datalog_locs);
	}
}

/*
	Name: log_qualifier
	Namespace: zm_moon_sq_datalogs
	Checksum: 0x20A4EECD
	Offset: 0x778
	Size: 0x17
	Parameters: 0
	Flags: None
*/
function log_qualifier()
{
	if(isdefined(self._has_log))
	{
		return 1;
	}
	return 0;
}

