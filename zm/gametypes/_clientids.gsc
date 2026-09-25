#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace clientids;

/*
	Name: __init__sytem__
	Namespace: clientids
	Checksum: 0xFA56725D
	Offset: 0xE8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("clientids", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: clientids
	Checksum: 0xE1E095DC
	Offset: 0x128
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_start_gametype(&init);
	callback::on_connect(&on_player_connect);
}

/*
	Name: init
	Namespace: clientids
	Checksum: 0x9337C0DE
	Offset: 0x178
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function init()
{
	level.clientid = 0;
}

/*
	Name: on_player_connect
	Namespace: clientids
	Checksum: 0x3AF59814
	Offset: 0x190
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self.clientid = matchRecordNewPlayer(self);
	if(!isdefined(self.clientid) || self.clientid == -1)
	{
		self.clientid = level.clientid;
		level.clientid++;
	}
	/#
		println("Dev Block strings are not supported" + self.name + "Dev Block strings are not supported" + self.clientid);
	#/
}

