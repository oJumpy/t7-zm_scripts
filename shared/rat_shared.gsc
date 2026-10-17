#using scripts\shared\array_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace rat_shared;

/*
	Name: init
	Namespace: rat_shared
	Checksum: 0x645BC421
	Offset: 0xD0
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function init()
{
	/#
		if(!isdefined(level.rat))
		{
			level.rat = spawnstruct();
			level.rat.common = spawnstruct();
			level.rat.script_command_list = [];
			addratscriptcmd("Dev Block strings are not supported", &rscteleport);
			addratscriptcmd("Dev Block strings are not supported", &rscteleportenemies);
			addratscriptcmd("Dev Block strings are not supported", &rscsimulatescripterror);
			addratscriptcmd("Dev Block strings are not supported", &rscrecteleport);
		}
	#/
}

/*
	Name: addratscriptcmd
	Namespace: rat_shared
	Checksum: 0xA1D5276C
	Offset: 0x1E0
	Size: 0x45
	Parameters: 2
	Flags: None
*/
function addratscriptcmd(commandname, functioncallback)
{
	/#
		init();
		level.rat.script_command_list[commandname] = functioncallback;
	#/
}

/*
	Name: codecallback_ratscriptcommand
	Namespace: rat_shared
	Checksum: 0x177B05BD
	Offset: 0x230
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function codecallback_ratscriptcommand(params)
{
	/#
		init();
		/#
			Assert(isdefined(params._cmd));
		#/
		/#
			Assert(isdefined(params._id));
		#/
		/#
			Assert(isdefined(level.rat.script_command_list[params._cmd]), "Dev Block strings are not supported" + params._cmd);
		#/
		callback = level.rat.script_command_list[params._cmd];
		level thread [[callback]](params);
	#/
}

/*
	Name: rscteleport
	Namespace: rat_shared
	Checksum: 0x58DB72F7
	Offset: 0x340
	Size: 0x17B
	Parameters: 1
	Flags: None
*/
function rscteleport(params)
{
	/#
		player = [[level.rat.common.getHostPlayer]]();
		pos = (float(params.x), float(params.y), float(params.z));
		player SetOrigin(pos);
		if(isdefined(params.ax))
		{
			angles = (float(params.ax), float(params.ay), float(params.az));
			player SetPlayerAngles(angles);
		}
		ratreportcommandresult(params._id, 1);
	#/
}

/*
	Name: rscteleportenemies
	Namespace: rat_shared
	Checksum: 0x5D890268
	Offset: 0x4C8
	Size: 0x1EB
	Parameters: 1
	Flags: None
*/
function rscteleportenemies(params)
{
	/#
		foreach(player in level.players)
		{
			if(!isdefined(player.bot))
			{
				continue;
			}
			pos = (float(params.x), float(params.y), float(params.z));
			player SetOrigin(pos);
			if(isdefined(params.ax))
			{
				angles = (float(params.ax), float(params.ay), float(params.az));
				player SetPlayerAngles(angles);
			}
			if(!isdefined(params.all))
			{
				break;
			}
		}
		ratreportcommandresult(params._id, 1);
	#/
}

/*
	Name: rscsimulatescripterror
	Namespace: rat_shared
	Checksum: 0x1C804330
	Offset: 0x6C0
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function rscsimulatescripterror(params)
{
	/#
		if(params.errorlevel == "Dev Block strings are not supported")
		{
			/#
				ASSERTMSG("Dev Block strings are not supported");
			#/
		}
		else
		{
			thisdoesntexist.orthis = 0;
		}
		ratreportcommandresult(params._id, 1);
	#/
}

/*
	Name: rscrecteleport
	Namespace: rat_shared
	Checksum: 0x8012E80
	Offset: 0x758
	Size: 0x15B
	Parameters: 1
	Flags: None
*/
function rscrecteleport(params)
{
	/#
		println("Dev Block strings are not supported");
		player = [[level.rat.common.getHostPlayer]]();
		pos = player GetOrigin();
		angles = player getPlayerAngles();
		cmd = "Dev Block strings are not supported" + pos[0] + "Dev Block strings are not supported" + pos[1] + "Dev Block strings are not supported" + pos[2] + "Dev Block strings are not supported" + angles[0] + "Dev Block strings are not supported" + angles[1] + "Dev Block strings are not supported" + angles[2];
		ratrecordmessage(0, "Dev Block strings are not supported", cmd);
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
	#/
}

