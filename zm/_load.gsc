#using scripts\codescripts\struct;
#using scripts\shared\_oob;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\load_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\music_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\serverfaceanim_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_art;
#using scripts\zm\_callbacks;
#using scripts\zm\_destructible;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_bot;
#using scripts\zm\_zm_clone;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_playerhealth;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_traps;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\gametypes\_clientids;
#using scripts\zm\gametypes\_scoreboard;
#using scripts\zm\gametypes\_serversettings;
#using scripts\zm\gametypes\_shellshock;
#using scripts\zm\gametypes\_spawnlogic;
#using scripts\zm\gametypes\_spectating;
#using scripts\zm\gametypes\_weaponobjects;

#namespace load;

/*
	Name: main
	Namespace: load
	Checksum: 0x85A46EC4
	Offset: 0x7C0
	Size: 0x11B
	Parameters: 0
	Flags: None
*/
function main()
{
	/#
		/#
			Assert(isdefined(level.first_frame), "Dev Block strings are not supported");
		#/
	#/
	zm::init();
	level._loadStarted = 1;
	register_clientfields();
	level.aiTriggerSpawnFlags = getaitriggerflags();
	level.vehicleTriggerSpawnFlags = getvehicletriggerflags();
	level thread start_intro_screen_zm();
	setup_traversals();
	footsteps();
	system::wait_till("all");
	level thread art_review();
	level flagsys::set("load_main_complete");
}

/*
	Name: footsteps
	Namespace: load
	Checksum: 0x4240B549
	Offset: 0x8E8
	Size: 0x23B
	Parameters: 0
	Flags: None
*/
function footsteps()
{
	if(isdefined(level.FX_exclude_footsteps) && level.FX_exclude_footsteps)
	{
		return;
	}
	zombie_utility::setFootstepEffect("asphalt", "_t6/bio/player/fx_footstep_dust");
	zombie_utility::setFootstepEffect("brick", "_t6/bio/player/fx_footstep_dust");
	zombie_utility::setFootstepEffect("carpet", "_t6/bio/player/fx_footstep_dust");
	zombie_utility::setFootstepEffect("cloth", "_t6/bio/player/fx_footstep_dust");
	zombie_utility::setFootstepEffect("concrete", "_t6/bio/player/fx_footstep_dust");
	zombie_utility::setFootstepEffect("dirt", "_t6/bio/player/fx_footstep_sand");
	zombie_utility::setFootstepEffect("foliage", "_t6/bio/player/fx_footstep_sand");
	zombie_utility::setFootstepEffect("gravel", "_t6/bio/player/fx_footstep_dust");
	zombie_utility::setFootstepEffect("grass", "_t6/bio/player/fx_footstep_dust");
	zombie_utility::setFootstepEffect("metal", "_t6/bio/player/fx_footstep_dust");
	zombie_utility::setFootstepEffect("mud", "_t6/bio/player/fx_footstep_mud");
	zombie_utility::setFootstepEffect("paper", "_t6/bio/player/fx_footstep_dust");
	zombie_utility::setFootstepEffect("plaster", "_t6/bio/player/fx_footstep_dust");
	zombie_utility::setFootstepEffect("rock", "_t6/bio/player/fx_footstep_dust");
	zombie_utility::setFootstepEffect("sand", "_t6/bio/player/fx_footstep_sand");
	zombie_utility::setFootstepEffect("water", "_t6/bio/player/fx_footstep_water");
	zombie_utility::setFootstepEffect("wood", "_t6/bio/player/fx_footstep_dust");
}

/*
	Name: setup_traversals
	Namespace: load
	Checksum: 0x99EC1590
	Offset: 0xB30
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function setup_traversals()
{
}

/*
	Name: start_intro_screen_zm
	Namespace: load
	Checksum: 0xBE8A0915
	Offset: 0xB40
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function start_intro_screen_zm()
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] LUI::screen_fade_out(0, undefined);
		players[i] FreezeControls(1);
	}
	wait(1);
}

/*
	Name: register_clientfields
	Namespace: load
	Checksum: 0xE474FA
	Offset: 0xBE0
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("allplayers", "zmbLastStand", 1, 1, "int");
	clientfield::register("clientuimodel", "zmhud.swordEnergy", 1, 7, "float");
	clientfield::register("clientuimodel", "zmhud.swordState", 1, 4, "int");
	clientfield::register("clientuimodel", "zmhud.swordChargeUpdate", 1, 1, "counter");
}

