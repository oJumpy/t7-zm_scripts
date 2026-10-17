#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\clientfield_shared;

#namespace destructible_character;

/*
	Name: main
	Namespace: destructible_character
	Checksum: 0xD7C6F9F5
	Offset: 0x198
	Size: 0x3E5
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("actor", "destructible_character_state", 1, 21, "int", &destructclientutils::_destructhandler, 0, 0);
	destructibles = struct::get_script_bundles("destructiblecharacterdef");
	processedBundles = [];
	foreach(destructible in destructibles)
	{
		destructbundle = spawnstruct();
		destructbundle.pieceCount = destructible.pieceCount;
		destructbundle.pieces = [];
		destructbundle.name = destructiblename;
		for(index = 1; index <= destructbundle.pieceCount; index++)
		{
			piecestruct = spawnstruct();
			piecestruct.gibmodel = GetStructField(destructible, "piece" + index + "_gibmodel");
			piecestruct.gibtag = GetStructField(destructible, "piece" + index + "_gibtag");
			piecestruct.gibfx = GetStructField(destructible, "piece" + index + "_gibfx");
			piecestruct.gibfxtag = GetStructField(destructible, "piece" + index + "_gibeffecttag");
			piecestruct.gibdynentfx = GetStructField(destructible, "piece" + index + "_gibdynentfx");
			piecestruct.gibsound = GetStructField(destructible, "piece" + index + "_gibsound");
			piecestruct.hitlocation = GetStructField(destructible, "piece" + index + "_hitlocation");
			piecestruct.hidetag = GetStructField(destructible, "piece" + index + "_hidetag");
			piecestruct.detachmodel = GetStructField(destructible, "piece" + index + "_detachmodel");
			destructbundle.pieces[destructbundle.pieces.size] = piecestruct;
		}
		processedBundles[destructiblename] = destructbundle;
	}
	level.scriptbundles["destructiblecharacterdef"] = processedBundles;
}

#namespace destructclientutils;

/*
	Name: _destructhandler
	Namespace: destructclientutils
	Checksum: 0xACFAC1D4
	Offset: 0x588
	Size: 0x137
	Parameters: 7
	Flags: Private
*/
function private _destructhandler(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	destructflags = oldValue ^ newValue;
	shouldSpawnGibs = newValue & 1;
	if(bNewEnt)
	{
		destructflags = 0 ^ newValue;
	}
	if(!isdefined(entity.destructibledef))
	{
		return;
	}
	currentdestructflag = 2;
	pieceNumber = 1;
	while(destructflags >= currentdestructflag)
	{
		if(destructflags & currentdestructflag)
		{
			_destructpiece(localClientNum, entity, pieceNumber, shouldSpawnGibs);
		}
		currentdestructflag = currentdestructflag << 1;
		pieceNumber++;
	}
	entity._destruct_state = newValue;
}

/*
	Name: _destructpiece
	Namespace: destructclientutils
	Checksum: 0x521F25B2
	Offset: 0x6C8
	Size: 0x163
	Parameters: 4
	Flags: Private
*/
function private _destructpiece(localClientNum, entity, pieceNumber, shouldSpawnGibs)
{
	if(!isdefined(entity.destructibledef))
	{
		return;
	}
	destructbundle = struct::get_script_bundle("destructiblecharacterdef", entity.destructibledef);
	piece = destructbundle.pieces[pieceNumber - 1];
	if(isdefined(piece))
	{
		if(shouldSpawnGibs)
		{
			GibClientUtils::_PlayGibFX(localClientNum, entity, piece.gibfx, piece.gibfxtag);
			entity thread GibClientUtils::_GibPiece(localClientNum, entity, piece.gibmodel, piece.gibtag, piece.gibdynentfx);
			GibClientUtils::_PlayGibSound(localClientNum, entity, piece.gibsound);
		}
		_handledestructcallbacks(localClientNum, entity, pieceNumber);
	}
}

/*
	Name: _getdestructstate
	Namespace: destructclientutils
	Checksum: 0x557F08AF
	Offset: 0x838
	Size: 0x39
	Parameters: 2
	Flags: Private
*/
function private _getdestructstate(localClientNum, entity)
{
	if(isdefined(entity._destruct_state))
	{
		return entity._destruct_state;
	}
	return 0;
}

/*
	Name: _handledestructcallbacks
	Namespace: destructclientutils
	Checksum: 0xE0D458C6
	Offset: 0x880
	Size: 0xF3
	Parameters: 3
	Flags: Private
*/
function private _handledestructcallbacks(localClientNum, entity, pieceNumber)
{
	if(isdefined(entity._destructcallbacks) && isdefined(entity._destructcallbacks[pieceNumber]))
	{
		foreach(callback in entity._destructcallbacks[pieceNumber])
		{
			if(IsFunctionPtr(callback))
			{
				[[callback]](localClientNum, entity, pieceNumber);
			}
		}
	}
}

/*
	Name: AddDestructPieceCallback
	Namespace: destructclientutils
	Checksum: 0xB1C157A2
	Offset: 0x980
	Size: 0xF5
	Parameters: 4
	Flags: None
*/
function AddDestructPieceCallback(localClientNum, entity, pieceNumber, callbackFunction)
{
	/#
		Assert(IsFunctionPtr(callbackFunction));
	#/
	if(!isdefined(entity._destructcallbacks))
	{
		entity._destructcallbacks = [];
	}
	if(!isdefined(entity._destructcallbacks[pieceNumber]))
	{
		entity._destructcallbacks[pieceNumber] = [];
	}
	destructcallbacks = entity._destructcallbacks[pieceNumber];
	destructcallbacks[destructcallbacks.size] = callbackFunction;
	entity._destructcallbacks[pieceNumber] = destructcallbacks;
}

/*
	Name: ispiecedestructed
	Namespace: destructclientutils
	Checksum: 0x50F61D1F
	Offset: 0xA80
	Size: 0x3D
	Parameters: 3
	Flags: None
*/
function ispiecedestructed(localClientNum, entity, pieceNumber)
{
	return _getdestructstate(localClientNum, entity) & 1 << pieceNumber;
}

