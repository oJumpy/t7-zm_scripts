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
			level.rat.var_2d2e6b8d = [];
			function_e98bbc2e("Dev Block strings are not supported", &function_8dc59c52);
			function_e98bbc2e("Dev Block strings are not supported", &function_edac6d3e);
			function_e98bbc2e("Dev Block strings are not supported", &function_a627dcf2);
			function_e98bbc2e("Dev Block strings are not supported", &function_919ad68e);
		}
	#/
}

/*
	Name: function_e98bbc2e
	Namespace: rat_shared
	Checksum: 0xA1D5276C
	Offset: 0x1E0
	Size: 0x45
	Parameters: 2
	Flags: None
*/
function function_e98bbc2e(var_b03aaa45, var_2c91ea88)
{
	/#
		init();
		level.rat.var_2d2e6b8d[var_b03aaa45] = var_2c91ea88;
	#/
}

/*
	Name: function_2f718a9
	Namespace: rat_shared
	Checksum: 0x177B05BD
	Offset: 0x230
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function function_2f718a9(params)
{
	/#
		init();
		/#
			Assert(isdefined(params.var_cd26a408));
		#/
		/#
			Assert(isdefined(params.var_4af46077));
		#/
		/#
			Assert(isdefined(level.rat.var_2d2e6b8d[params.var_cd26a408]), "Dev Block strings are not supported" + params.var_cd26a408);
		#/
		callback = level.rat.var_2d2e6b8d[params.var_cd26a408];
		level thread [[callback]](params);
	#/
}

/*
	Name: function_8dc59c52
	Namespace: rat_shared
	Checksum: 0x58DB72F7
	Offset: 0x340
	Size: 0x17B
	Parameters: 1
	Flags: None
*/
function function_8dc59c52(params)
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
		function_6f515a70(params.var_4af46077, 1);
	#/
}

/*
	Name: function_edac6d3e
	Namespace: rat_shared
	Checksum: 0x5D890268
	Offset: 0x4C8
	Size: 0x1EB
	Parameters: 1
	Flags: None
*/
function function_edac6d3e(params)
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
		function_6f515a70(params.var_4af46077, 1);
	#/
}

/*
	Name: function_a627dcf2
	Namespace: rat_shared
	Checksum: 0x1C804330
	Offset: 0x6C0
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function function_a627dcf2(params)
{
	/#
		if(params.var_ec9df30d == "Dev Block strings are not supported")
		{
			/#
				ASSERTMSG("Dev Block strings are not supported");
			#/
		}
		else
		{
			var_39767681.var_15d5343a = 0;
		}
		function_6f515a70(params.var_4af46077, 1);
	#/
}

/*
	Name: function_919ad68e
	Namespace: rat_shared
	Checksum: 0x8012E80
	Offset: 0x758
	Size: 0x15B
	Parameters: 1
	Flags: None
*/
function function_919ad68e(params)
{
	/#
		println("Dev Block strings are not supported");
		player = [[level.rat.common.getHostPlayer]]();
		pos = player GetOrigin();
		angles = player getPlayerAngles();
		cmd = "Dev Block strings are not supported" + pos[0] + "Dev Block strings are not supported" + pos[1] + "Dev Block strings are not supported" + pos[2] + "Dev Block strings are not supported" + angles[0] + "Dev Block strings are not supported" + angles[1] + "Dev Block strings are not supported" + angles[2];
		function_25c75042(0, "Dev Block strings are not supported", cmd);
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
	#/
}

