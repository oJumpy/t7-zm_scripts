#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\bots\bot_traversals;
#using scripts\shared\system_shared;
#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_actor;
#using scripts\zm\gametypes\_globallogic_player;
#using scripts\zm\gametypes\_globallogic_vehicle;
#using scripts\zm\gametypes\_hostmigration;

#namespace callback;

/*
	Name: __init__sytem__
	Namespace: callback
	Checksum: 0x8A9E0809
	Offset: 0x1E8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("callback", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: callback
	Checksum: 0x9E4FDC6A
	Offset: 0x228
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level thread setup_callbacks();
}

/*
	Name: setup_callbacks
	Namespace: callback
	Checksum: 0xEECC2927
	Offset: 0x250
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function setup_callbacks()
{
	SetDefaultCallbacks();
	level.IDFLAGS_NOFLAG = 0;
	level.IDFLAGS_RADIUS = 1;
	level.IDFLAGS_NO_ARMOR = 2;
	level.IDFLAGS_NO_KNOCKBACK = 4;
	level.IDFLAGS_PENETRATION = 8;
	level.IDFLAGS_DESTRUCTIBLE_ENTITY = 16;
	level.IDFLAGS_SHIELD_EXPLOSIVE_IMPACT = 32;
	level.IDFLAGS_SHIELD_EXPLOSIVE_IMPACT_HUGE = 64;
	level.IDFLAGS_SHIELD_EXPLOSIVE_SPLASH = 128;
	level.IDFLAGS_HURT_TRIGGER_ALLOW_LASTSTAND = 256;
	level.IDFLAGS_DISABLE_RAGDOLL_SKIP = 512;
	level.IDFLAGS_NO_TEAM_PROTECTION = 1024;
	level.IDFLAGS_NO_PROTECTION = 2048;
	level.IDFLAGS_PASSTHRU = 4096;
}

/*
	Name: SetDefaultCallbacks
	Namespace: callback
	Checksum: 0x879E00A8
	Offset: 0x318
	Size: 0x1DB
	Parameters: 0
	Flags: None
*/
function SetDefaultCallbacks()
{
	level.callbackStartGameType = &globallogic::Callback_StartGameType;
	level.callbackPlayerConnect = &globallogic_player::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = &globallogic_player::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = &globallogic_player::Callback_PlayerDamage;
	level.callbackPlayerKilled = &globallogic_player::Callback_PlayerKilled;
	level.callbackPlayerMelee = &globallogic_player::Callback_PlayerMelee;
	level.callbackPlayerLastStand = &globallogic_player::Callback_PlayerLastStand;
	level.callbackActorDamage = &globallogic_actor::Callback_ActorDamage;
	level.callbackActorSpawned = &globallogic_actor::Callback_ActorSpawned;
	level.callbackActorKilled = &globallogic_actor::Callback_ActorKilled;
	level.callbackActorCloned = &globallogic_actor::Callback_ActorCloned;
	level.callbackVehicleSpawned = &globallogic_vehicle::Callback_VehicleSpawned;
	level.callbackVehicleDamage = &globallogic_vehicle::Callback_VehicleDamage;
	level.callbackVehicleRadiusDamage = &globallogic_vehicle::Callback_VehicleRadiusDamage;
	level.callbackPlayerMigrated = &globallogic_player::Callback_PlayerMigrated;
	level.callbackHostMigration = &hostmigration::Callback_HostMigration;
	level.callbackHostMigrationSave = &hostmigration::Callback_HostMigrationSave;
	level.callbackPreHostMigrationSave = &hostmigration::Callback_PreHostMigrationSave;
	level.callbackBotEnteredUserEdge = &bot::Callback_BotEnteredUserEdge;
	level._gametype_default = "zclassic";
}

