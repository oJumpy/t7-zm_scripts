#using scripts\codescripts\struct;
#using scripts\shared\_oob;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfaceanim_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\footsteps_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\load_shared;
#using scripts\shared\music_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_ambient;
#using scripts\zm\_callbacks;
#using scripts\zm\_destructible;
#using scripts\zm\_global_fx;
#using scripts\zm\_radiant_live_update;
#using scripts\zm\_sticky_grenade;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_playerhealth;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_traps;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\gametypes\_weaponobjects;

#namespace load;

/*
	Name: levelNotifyHandler
	Namespace: load
	Checksum: 0xEEA521CA
	Offset: 0x4F0
	Size: 0x39
	Parameters: 3
	Flags: None
*/
function levelNotifyHandler(clientNum, State, oldState)
{
	if(State != "")
	{
		level notify(State, clientNum);
	}
}

/*
	Name: warnMissileLocking
	Namespace: load
	Checksum: 0x8AA5A2BB
	Offset: 0x538
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function warnMissileLocking(localClientNum, set)
{
}

/*
	Name: warnMissileLocked
	Namespace: load
	Checksum: 0x45712ABB
	Offset: 0x558
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function warnMissileLocked(localClientNum, set)
{
}

/*
	Name: warnMissileFired
	Namespace: load
	Checksum: 0x836BFE92
	Offset: 0x578
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function warnMissileFired(localClientNum, set)
{
}

/*
	Name: main
	Namespace: load
	Checksum: 0x12999F87
	Offset: 0x598
	Size: 0x14B
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
	level thread server_time();
	level thread util::init_utility();
	util::REGISTER_SYSTEM("levelNotify", &levelNotifyHandler);
	register_clientfields();
	level.createFX_disable_fx = GetDvarInt("disable_fx") == 1;
	if(isdefined(level._uses_sticky_grenades) && level._uses_sticky_grenades)
	{
		level thread _sticky_grenade::main();
	}
	system::wait_till("all");
	level thread art_review();
	level flagsys::set("load_main_complete");
}

/*
	Name: server_time
	Namespace: load
	Checksum: 0x6D016E91
	Offset: 0x6F0
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function server_time()
{
	for(;;)
	{
		level.serverTime = getServerTime(0);
		wait(0.01);
	}
}

/*
	Name: register_clientfields
	Namespace: load
	Checksum: 0xD69FF95C
	Offset: 0x728
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("allplayers", "zmbLastStand", 1, 1, "int", &zm::laststand, 0, 1);
	clientfield::register("clientuimodel", "zmhud.swordEnergy", 1, 7, "float", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmhud.swordState", 1, 4, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmhud.swordChargeUpdate", 1, 1, "counter", undefined, 0, 0);
}

