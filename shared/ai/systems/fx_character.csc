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
	fxbundles = struct::get_script_bundles("fxcharacterdef");
	processedfxbundles = [];
	foreach(fxbundle in fxbundles)
	{
		processedfxbundle = spawnstruct();
		processedfxbundle.effectcount = fxbundle.effectcount;
		processedfxbundle.FX = [];
		processedfxbundle.name = fxbundlename;
		for(index = 1; index <= fxbundle.effectcount; index++)
		{
			FX = GetStructField(fxbundle, "effect" + index + "_fx");
			if(isdefined(FX))
			{
				fxstruct = spawnstruct();
				fxstruct.attachTag = GetStructField(fxbundle, "effect" + index + "_attachtag");
				fxstruct.FX = GetStructField(fxbundle, "effect" + index + "_fx");
				fxstruct.stopongib = FxClientUtils::_gibpartnametogibflag(GetStructField(fxbundle, "effect" + index + "_stopongib"));
				fxstruct.stoponpiecedestroyed = GetStructField(fxbundle, "effect" + index + "_stoponpiecedestroyed");
				processedfxbundle.FX[processedfxbundle.FX.size] = fxstruct;
			}
		}
		processedfxbundles[fxbundlename] = processedfxbundle;
	}
	level.scriptbundles["fxcharacterdef"] = processedfxbundles;
}

#namespace FxClientUtils;

/*
	Name: _configentity
	Namespace: FxClientUtils
	Checksum: 0xD069E952
	Offset: 0x448
	Size: 0x155
	Parameters: 2
	Flags: Private
*/
function private _configentity(localClientNum, entity)
{
	if(!isdefined(entity._fxcharacter))
	{
		entity._fxcharacter = [];
		handledgibs = Array(8, 16, 32, 128, 256);
		foreach(gibFlag in handledgibs)
		{
			GibClientUtils::AddGibCallback(localClientNum, entity, gibFlag, &_GibHandler);
		}
		for(index = 1; index <= 20; index++)
		{
			destructclientutils::AddDestructPieceCallback(localClientNum, entity, index, &_destructhandler);
		}
	}
}

/*
	Name: _destructhandler
	Namespace: FxClientUtils
	Checksum: 0xEDC6AABF
	Offset: 0x5A8
	Size: 0x165
	Parameters: 3
	Flags: Private
*/
function private _destructhandler(localClientNum, entity, pieceNumber)
{
	if(!isdefined(entity._fxcharacter))
	{
		return;
	}
	foreach(fxbundleinst in entity._fxcharacter)
	{
		fxbundle = struct::get_script_bundle("fxcharacterdef", fxbundlename);
		for(index = 0; index < fxbundle.FX.size; index++)
		{
			if(isdefined(fxbundleinst[index]) && fxbundle.FX[index].stoponpiecedestroyed === pieceNumber)
			{
				stopfx(localClientNum, fxbundleinst[index]);
				fxbundleinst[index] = undefined;
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
	if(!isdefined(entity._fxcharacter))
	{
		return;
	}
	foreach(fxbundleinst in entity._fxcharacter)
	{
		fxbundle = struct::get_script_bundle("fxcharacterdef", fxbundlename);
		for(index = 0; index < fxbundle.FX.size; index++)
		{
			if(isdefined(fxbundleinst[index]) && fxbundle.FX[index].stopongib === gibFlag)
			{
				stopfx(localClientNum, fxbundleinst[index]);
				fxbundleinst[index] = undefined;
			}
		}
	}
}

/*
	Name: _gibpartnametogibflag
	Namespace: FxClientUtils
	Checksum: 0xB67E2208
	Offset: 0x888
	Size: 0x6D
	Parameters: 1
	Flags: Private
*/
function private _gibpartnametogibflag(gibpartname)
{
	if(isdefined(gibpartname))
	{
		switch(gibpartname)
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
	Name: _isgibbed
	Namespace: FxClientUtils
	Checksum: 0x9C83D894
	Offset: 0x900
	Size: 0x49
	Parameters: 3
	Flags: Private
*/
function private _isgibbed(localClientNum, entity, stopongibflag)
{
	if(!isdefined(stopongibflag))
	{
		return 0;
	}
	return GibClientUtils::IsGibbed(localClientNum, entity, stopongibflag);
}

/*
	Name: _ispiecedestructed
	Namespace: FxClientUtils
	Checksum: 0x4227EFD6
	Offset: 0x958
	Size: 0x49
	Parameters: 3
	Flags: Private
*/
function private _ispiecedestructed(localClientNum, entity, stoponpiecedestroyed)
{
	if(!isdefined(stoponpiecedestroyed))
	{
		return 0;
	}
	return destructclientutils::ispiecedestructed(localClientNum, entity, stoponpiecedestroyed);
}

/*
	Name: _shouldplayfx
	Namespace: FxClientUtils
	Checksum: 0x53BF3B0A
	Offset: 0x9B0
	Size: 0x7D
	Parameters: 3
	Flags: Private
*/
function private _shouldplayfx(localClientNum, entity, fxstruct)
{
	if(_isgibbed(localClientNum, entity, fxstruct.stopongib))
	{
		return 0;
	}
	if(_ispiecedestructed(localClientNum, entity, fxstruct.stoponpiecedestroyed))
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
	_configentity(localClientNum, entity);
	fxbundle = struct::get_script_bundle("fxcharacterdef", fxScriptBundle);
	if(isdefined(entity._fxcharacter[fxbundle.name]))
	{
		return;
	}
	if(isdefined(fxbundle))
	{
		playingfx = [];
		for(index = 0; index < fxbundle.FX.size; index++)
		{
			fxstruct = fxbundle.FX[index];
			if(_shouldplayfx(localClientNum, entity, fxstruct))
			{
				playingfx[index] = GibClientUtils::_PlayGibFX(localClientNum, entity, fxstruct.FX, fxstruct.attachTag);
			}
		}
		if(playingfx.size > 0)
		{
			entity._fxcharacter[fxbundle.name] = playingfx;
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
	_configentity(localClientNum, entity);
	fxbundlenames = [];
	foreach(fxbundle in entity._fxcharacter)
	{
		fxbundlenames[fxbundlenames.size] = fxbundlename;
	}
	foreach(fxbundlename in fxbundlenames)
	{
		stopfxbundle(localClientNum, entity, fxbundlename);
	}
}

/*
	Name: stopfxbundle
	Namespace: FxClientUtils
	Checksum: 0xB0508C91
	Offset: 0xD28
	Size: 0x153
	Parameters: 3
	Flags: None
*/
function stopfxbundle(localClientNum, entity, fxScriptBundle)
{
	if(!isdefined(fxScriptBundle))
	{
		return;
	}
	_configentity(localClientNum, entity);
	fxbundle = struct::get_script_bundle("fxcharacterdef", fxScriptBundle);
	if(isdefined(entity._fxcharacter[fxbundle.name]))
	{
		foreach(FX in entity._fxcharacter[fxbundle.name])
		{
			if(isdefined(FX))
			{
				stopfx(localClientNum, FX);
			}
		}
		entity._fxcharacter[fxbundle.name] = undefined;
	}
}

