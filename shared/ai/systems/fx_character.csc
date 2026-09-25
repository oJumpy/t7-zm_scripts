#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\systems\gib;

#namespace fx_character;

/*
	Name: main
	Namespace: fx_character
	Checksum: 0xBEA295CF
	Offset: 0x168
	Size: 0x2D5
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	var_1dd1d142 = struct::get_script_bundles("fxcharacterdef");
	var_a15f98 = [];
	foreach(var_86d68913 in var_1dd1d142)
	{
		var_cab8fa31 = spawnstruct();
		var_cab8fa31.var_d26cd73 = var_86d68913.var_d26cd73;
		var_cab8fa31.FX = [];
		var_cab8fa31.name = var_e07d138e;
		for(index = 1; index <= var_86d68913.var_d26cd73; index++)
		{
			FX = GetStructField(var_86d68913, "effect" + index + "_fx");
			if(isdefined(FX))
			{
				var_d2fb73a4 = spawnstruct();
				var_d2fb73a4.attachTag = GetStructField(var_86d68913, "effect" + index + "_attachtag");
				var_d2fb73a4.FX = GetStructField(var_86d68913, "effect" + index + "_fx");
				var_d2fb73a4.var_9f61ef70 = FxClientUtils::function_f15cfa19(GetStructField(var_86d68913, "effect" + index + "_stopongib"));
				var_d2fb73a4.var_db4d454d = GetStructField(var_86d68913, "effect" + index + "_stoponpiecedestroyed");
				var_cab8fa31.FX[var_cab8fa31.FX.size] = var_d2fb73a4;
			}
		}
		var_a15f98[var_e07d138e] = var_cab8fa31;
	}
	level.scriptbundles["fxcharacterdef"] = var_a15f98;
}

#namespace FxClientUtils;

/*
	Name: function_d0275787
	Namespace: FxClientUtils
	Checksum: 0xD069E952
	Offset: 0x448
	Size: 0x155
	Parameters: 2
	Flags: Private
*/
function private function_d0275787(localClientNum, entity)
{
	if(!isdefined(entity.var_30cd35b))
	{
		entity.var_30cd35b = [];
		var_50dc7ab0 = Array(8, 16, 32, 128, 256);
		foreach(gibFlag in var_50dc7ab0)
		{
			GibClientUtils::AddGibCallback(localClientNum, entity, gibFlag, &_GibHandler);
		}
		for(index = 1; index <= 20; index++)
		{
			namespace_6eef25d9::AddDestructPieceCallback(localClientNum, entity, index, &function_303292de);
		}
	}
}

/*
	Name: function_303292de
	Namespace: FxClientUtils
	Checksum: 0xEDC6AABF
	Offset: 0x5A8
	Size: 0x165
	Parameters: 3
	Flags: Private
*/
function private function_303292de(localClientNum, entity, pieceNumber)
{
	if(!isdefined(entity.var_30cd35b))
	{
		return;
	}
	foreach(var_629f930f in entity.var_30cd35b)
	{
		var_86d68913 = struct::get_script_bundle("fxcharacterdef", var_e07d138e);
		for(index = 0; index < var_86d68913.FX.size; index++)
		{
			if(isdefined(var_629f930f[index]) && var_86d68913.FX[index].var_db4d454d === pieceNumber)
			{
				stopfx(localClientNum, var_629f930f[index]);
				var_629f930f[index] = undefined;
			}
		}
	}
}

/*
	Name: _GibHandler
	Namespace: FxClientUtils
	Checksum: 0xA16325FF
	Offset: 0x718
	Size: 0x165
	Parameters: 3
	Flags: Private
*/
function private _GibHandler(localClientNum, entity, gibFlag)
{
	if(!isdefined(entity.var_30cd35b))
	{
		return;
	}
	foreach(var_629f930f in entity.var_30cd35b)
	{
		var_86d68913 = struct::get_script_bundle("fxcharacterdef", var_e07d138e);
		for(index = 0; index < var_86d68913.FX.size; index++)
		{
			if(isdefined(var_629f930f[index]) && var_86d68913.FX[index].var_9f61ef70 === gibFlag)
			{
				stopfx(localClientNum, var_629f930f[index]);
				var_629f930f[index] = undefined;
			}
		}
	}
}

/*
	Name: function_f15cfa19
	Namespace: FxClientUtils
	Checksum: 0xB67E2208
	Offset: 0x888
	Size: 0x6D
	Parameters: 1
	Flags: Private
*/
function private function_f15cfa19(var_533c9637)
{
	if(isdefined(var_533c9637))
	{
		switch(var_533c9637)
		{
			case "head":
			{
				return 8;
			}
			case "right arm":
			{
				return 16;
			}
			case "left arm":
			{
				return 32;
			}
			case "right leg":
			{
				return 128;
			}
			case "left leg":
			{
				return 256;
			}
		}
	}
}

/*
	Name: function_7fb33d1b
	Namespace: FxClientUtils
	Checksum: 0x9C83D894
	Offset: 0x900
	Size: 0x49
	Parameters: 3
	Flags: Private
*/
function private function_7fb33d1b(localClientNum, entity, var_97122fe6)
{
	if(!isdefined(var_97122fe6))
	{
		return 0;
	}
	return GibClientUtils::IsGibbed(localClientNum, entity, var_97122fe6);
}

/*
	Name: function_c624bdb3
	Namespace: FxClientUtils
	Checksum: 0x4227EFD6
	Offset: 0x958
	Size: 0x49
	Parameters: 3
	Flags: Private
*/
function private function_c624bdb3(localClientNum, entity, var_db4d454d)
{
	if(!isdefined(var_db4d454d))
	{
		return 0;
	}
	return namespace_6eef25d9::function_3955bc40(localClientNum, entity, var_db4d454d);
}

/*
	Name: function_870694b5
	Namespace: FxClientUtils
	Checksum: 0x53BF3B0A
	Offset: 0x9B0
	Size: 0x7D
	Parameters: 3
	Flags: Private
*/
function private function_870694b5(localClientNum, entity, var_d2fb73a4)
{
	if(function_7fb33d1b(localClientNum, entity, var_d2fb73a4.var_9f61ef70))
	{
		return 0;
	}
	if(function_c624bdb3(localClientNum, entity, var_d2fb73a4.var_db4d454d))
	{
		return 0;
	}
	return 1;
}

/*
	Name: PlayFxBundle
	Namespace: FxClientUtils
	Checksum: 0x72DD5148
	Offset: 0xA38
	Size: 0x18D
	Parameters: 3
	Flags: None
*/
function PlayFxBundle(localClientNum, entity, fxScriptBundle)
{
	if(!isdefined(fxScriptBundle))
	{
		return;
	}
	function_d0275787(localClientNum, entity);
	var_86d68913 = struct::get_script_bundle("fxcharacterdef", fxScriptBundle);
	if(isdefined(entity.var_30cd35b[var_86d68913.name]))
	{
		return;
	}
	if(isdefined(var_86d68913))
	{
		var_18065b7f = [];
		for(index = 0; index < var_86d68913.FX.size; index++)
		{
			var_d2fb73a4 = var_86d68913.FX[index];
			if(function_870694b5(localClientNum, entity, var_d2fb73a4))
			{
				var_18065b7f[index] = GibClientUtils::_PlayGibFX(localClientNum, entity, var_d2fb73a4.FX, var_d2fb73a4.attachTag);
			}
		}
		if(var_18065b7f.size > 0)
		{
			entity.var_30cd35b[var_86d68913.name] = var_18065b7f;
		}
	}
}

/*
	Name: StopAllFXBundles
	Namespace: FxClientUtils
	Checksum: 0x9B874D97
	Offset: 0xBD0
	Size: 0x149
	Parameters: 2
	Flags: None
*/
function StopAllFXBundles(localClientNum, entity)
{
	function_d0275787(localClientNum, entity);
	var_2bcdc031 = [];
	foreach(var_86d68913 in entity.var_30cd35b)
	{
		var_2bcdc031[var_2bcdc031.size] = var_e07d138e;
	}
	foreach(var_e07d138e in var_2bcdc031)
	{
		function_fd87a5b(localClientNum, entity, var_e07d138e);
	}
}

/*
	Name: function_fd87a5b
	Namespace: FxClientUtils
	Checksum: 0xB0508C91
	Offset: 0xD28
	Size: 0x153
	Parameters: 3
	Flags: None
*/
function function_fd87a5b(localClientNum, entity, fxScriptBundle)
{
	if(!isdefined(fxScriptBundle))
	{
		return;
	}
	function_d0275787(localClientNum, entity);
	var_86d68913 = struct::get_script_bundle("fxcharacterdef", fxScriptBundle);
	if(isdefined(entity.var_30cd35b[var_86d68913.name]))
	{
		foreach(FX in entity.var_30cd35b[var_86d68913.name])
		{
			if(isdefined(FX))
			{
				stopfx(localClientNum, FX);
			}
		}
		entity.var_30cd35b[var_86d68913.name] = undefined;
	}
}

