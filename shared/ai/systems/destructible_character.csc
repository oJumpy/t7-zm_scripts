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
	clientfield::register("actor", "destructible_character_state", 1, 21, "int", &namespace_6eef25d9::function_303292de, 0, 0);
	destructibles = struct::get_script_bundles("destructiblecharacterdef");
	processedBundles = [];
	foreach(destructible in destructibles)
	{
		var_c2acfcd7 = spawnstruct();
		var_c2acfcd7.pieceCount = destructible.pieceCount;
		var_c2acfcd7.pieces = [];
		var_c2acfcd7.name = var_93dca242;
		for(index = 1; index <= var_c2acfcd7.pieceCount; index++)
		{
			var_c16a4812 = spawnstruct();
			var_c16a4812.gibmodel = GetStructField(destructible, "piece" + index + "_gibmodel");
			var_c16a4812.gibtag = GetStructField(destructible, "piece" + index + "_gibtag");
			var_c16a4812.gibfx = GetStructField(destructible, "piece" + index + "_gibfx");
			var_c16a4812.gibfxtag = GetStructField(destructible, "piece" + index + "_gibeffecttag");
			var_c16a4812.gibdynentfx = GetStructField(destructible, "piece" + index + "_gibdynentfx");
			var_c16a4812.gibsound = GetStructField(destructible, "piece" + index + "_gibsound");
			var_c16a4812.hitlocation = GetStructField(destructible, "piece" + index + "_hitlocation");
			var_c16a4812.hidetag = GetStructField(destructible, "piece" + index + "_hidetag");
			var_c16a4812.var_639d6497 = GetStructField(destructible, "piece" + index + "_detachmodel");
			var_c2acfcd7.pieces[var_c2acfcd7.pieces.size] = var_c16a4812;
		}
		processedBundles[var_93dca242] = var_c2acfcd7;
	}
	level.scriptbundles["destructiblecharacterdef"] = processedBundles;
}

#namespace namespace_6eef25d9;

/*
	Name: function_303292de
	Namespace: namespace_6eef25d9
	Checksum: 0xACFAC1D4
	Offset: 0x588
	Size: 0x137
	Parameters: 7
	Flags: Private
*/
function private function_303292de(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	var_e0ec9e9c = oldValue ^ newValue;
	shouldSpawnGibs = newValue & 1;
	if(bNewEnt)
	{
		var_e0ec9e9c = 0 ^ newValue;
	}
	if(!isdefined(entity.destructibledef))
	{
		return;
	}
	var_af3027a4 = 2;
	pieceNumber = 1;
	while(var_e0ec9e9c >= var_af3027a4)
	{
		if(var_e0ec9e9c & var_af3027a4)
		{
			function_fbba3c4(localClientNum, entity, pieceNumber, shouldSpawnGibs);
		}
		var_af3027a4 = var_af3027a4 << 1;
		pieceNumber++;
	}
	entity.var_417f4578 = newValue;
}

/*
	Name: function_fbba3c4
	Namespace: namespace_6eef25d9
	Checksum: 0x521F25B2
	Offset: 0x6C8
	Size: 0x163
	Parameters: 4
	Flags: Private
*/
function private function_fbba3c4(localClientNum, entity, pieceNumber, shouldSpawnGibs)
{
	if(!isdefined(entity.destructibledef))
	{
		return;
	}
	var_c2acfcd7 = struct::get_script_bundle("destructiblecharacterdef", entity.destructibledef);
	piece = var_c2acfcd7.pieces[pieceNumber - 1];
	if(isdefined(piece))
	{
		if(shouldSpawnGibs)
		{
			GibClientUtils::_PlayGibFX(localClientNum, entity, piece.gibfx, piece.gibfxtag);
			entity thread GibClientUtils::_GibPiece(localClientNum, entity, piece.gibmodel, piece.gibtag, piece.gibdynentfx);
			GibClientUtils::_PlayGibSound(localClientNum, entity, piece.gibsound);
		}
		function_f00bb74(localClientNum, entity, pieceNumber);
	}
}

/*
	Name: function_2cb45fe1
	Namespace: namespace_6eef25d9
	Checksum: 0x557F08AF
	Offset: 0x838
	Size: 0x39
	Parameters: 2
	Flags: Private
*/
function private function_2cb45fe1(localClientNum, entity)
{
	if(isdefined(entity.var_417f4578))
	{
		return entity.var_417f4578;
	}
	return 0;
}

/*
	Name: function_f00bb74
	Namespace: namespace_6eef25d9
	Checksum: 0xE0D458C6
	Offset: 0x880
	Size: 0xF3
	Parameters: 3
	Flags: Private
*/
function private function_f00bb74(localClientNum, entity, pieceNumber)
{
	if(isdefined(entity.var_f6e00c36) && isdefined(entity.var_f6e00c36[pieceNumber]))
	{
		foreach(callback in entity.var_f6e00c36[pieceNumber])
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
	Namespace: namespace_6eef25d9
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
	if(!isdefined(entity.var_f6e00c36))
	{
		entity.var_f6e00c36 = [];
	}
	if(!isdefined(entity.var_f6e00c36[pieceNumber]))
	{
		entity.var_f6e00c36[pieceNumber] = [];
	}
	var_33773215 = entity.var_f6e00c36[pieceNumber];
	var_33773215[var_33773215.size] = callbackFunction;
	entity.var_f6e00c36[pieceNumber] = var_33773215;
}

/*
	Name: function_3955bc40
	Namespace: namespace_6eef25d9
	Checksum: 0x50F61D1F
	Offset: 0xA80
	Size: 0x3D
	Parameters: 3
	Flags: None
*/
function function_3955bc40(localClientNum, entity, pieceNumber)
{
	return function_2cb45fe1(localClientNum, entity) & 1 << pieceNumber;
}

