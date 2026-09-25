#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;

#namespace destructible_character;

/*
	Name: main
	Namespace: destructible_character
	Checksum: 0x80508B30
	Offset: 0x258
	Size: 0x3CD
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("actor", "destructible_character_state", 1, 21, "int");
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

#namespace DestructServerUtils;

/*
	Name: function_2cb45fe1
	Namespace: DestructServerUtils
	Checksum: 0x5B7D7283
	Offset: 0x630
	Size: 0x31
	Parameters: 1
	Flags: Private
*/
function private function_2cb45fe1(entity)
{
	if(isdefined(entity.var_417f4578))
	{
		return entity.var_417f4578;
	}
	return 0;
}

/*
	Name: function_736f4019
	Namespace: DestructServerUtils
	Checksum: 0xE9F4B4FF
	Offset: 0x670
	Size: 0x6B
	Parameters: 2
	Flags: Private
*/
function private function_736f4019(entity, var_f75965d)
{
	entity.var_417f4578 = function_2cb45fe1(entity) | var_f75965d;
	entity clientfield::set("destructible_character_state", entity.var_417f4578);
}

/*
	Name: CopyDestructState
	Namespace: DestructServerUtils
	Checksum: 0x7C881414
	Offset: 0x6E8
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function CopyDestructState(originalEntity, newEntity)
{
	newEntity.var_417f4578 = function_2cb45fe1(originalEntity);
	ToggleSpawnGibs(newEntity, 0);
	ReapplyDestructedPieces(newEntity);
}

/*
	Name: function_a6d21b4d
	Namespace: DestructServerUtils
	Checksum: 0xF486511E
	Offset: 0x760
	Size: 0xF5
	Parameters: 2
	Flags: None
*/
function function_a6d21b4d(entity, hitLoc)
{
	if(isdefined(entity.destructibledef))
	{
		var_c2acfcd7 = struct::get_script_bundle("destructiblecharacterdef", entity.destructibledef);
		for(index = 1; index <= var_c2acfcd7.pieces.size; index++)
		{
			piece = var_c2acfcd7.pieces[index - 1];
			if(isdefined(piece.hitlocation) && piece.hitlocation == hitLoc)
			{
				DestructPiece(entity, index);
			}
		}
	}
}

/*
	Name: DestructLeftArmPieces
	Namespace: DestructServerUtils
	Checksum: 0x6431ABE9
	Offset: 0x860
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function DestructLeftArmPieces(entity)
{
	function_a6d21b4d(entity, "left_arm_upper");
	function_a6d21b4d(entity, "left_arm_lower");
	function_a6d21b4d(entity, "left_hand");
}

/*
	Name: DestructLeftLegPieces
	Namespace: DestructServerUtils
	Checksum: 0x4616100B
	Offset: 0x8D8
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function DestructLeftLegPieces(entity)
{
	function_a6d21b4d(entity, "left_leg_upper");
	function_a6d21b4d(entity, "left_leg_lower");
	function_a6d21b4d(entity, "left_foot");
}

/*
	Name: DestructPiece
	Namespace: DestructServerUtils
	Checksum: 0xE0C62230
	Offset: 0x950
	Size: 0x193
	Parameters: 2
	Flags: None
*/
function DestructPiece(entity, pieceNumber)
{
	/#
		/#
			Assert(1 <= pieceNumber && pieceNumber <= 20);
		#/
	#/
	if(IsDestructed(entity, pieceNumber))
	{
		return;
	}
	function_736f4019(entity, 1 << pieceNumber);
	if(!isdefined(entity.destructibledef))
	{
		return;
	}
	var_c2acfcd7 = struct::get_script_bundle("destructiblecharacterdef", entity.destructibledef);
	piece = var_c2acfcd7.pieces[pieceNumber - 1];
	if(isdefined(piece.hidetag) && entity HasPart(piece.hidetag))
	{
		entity HidePart(piece.hidetag);
	}
	if(isdefined(piece.var_639d6497))
	{
		entity Detach(piece.var_639d6497, "");
	}
}

/*
	Name: DestructNumberRandomPieces
	Namespace: DestructServerUtils
	Checksum: 0xB71E5D11
	Offset: 0xAF0
	Size: 0x187
	Parameters: 2
	Flags: None
*/
function DestructNumberRandomPieces(entity, num_pieces_to_destruct)
{
	if(!isdefined(num_pieces_to_destruct))
	{
		num_pieces_to_destruct = 0;
	}
	var_8fd68c0a = [];
	var_e87e246e = GetPieceCount(entity);
	if(num_pieces_to_destruct == 0)
	{
		num_pieces_to_destruct = var_e87e246e;
	}
	for(i = 0; i < var_e87e246e; i++)
	{
		var_8fd68c0a[i] = i + 1;
	}
	var_8fd68c0a = Array::randomize(var_8fd68c0a);
	foreach(piece in var_8fd68c0a)
	{
		if(!IsDestructed(entity, piece))
		{
			DestructPiece(entity, piece);
			num_pieces_to_destruct--;
			if(num_pieces_to_destruct == 0)
			{
				break;
			}
		}
	}
}

/*
	Name: DestructRandomPieces
	Namespace: DestructServerUtils
	Checksum: 0x69FABBAC
	Offset: 0xC80
	Size: 0x8D
	Parameters: 1
	Flags: None
*/
function DestructRandomPieces(entity)
{
	var_9491468e = GetPieceCount(entity);
	for(index = 0; index < var_9491468e; index++)
	{
		if(math::cointoss())
		{
			DestructPiece(entity, index + 1);
		}
	}
}

/*
	Name: DestructRightArmPieces
	Namespace: DestructServerUtils
	Checksum: 0x81D5BD7E
	Offset: 0xD18
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function DestructRightArmPieces(entity)
{
	function_a6d21b4d(entity, "right_arm_upper");
	function_a6d21b4d(entity, "right_arm_lower");
	function_a6d21b4d(entity, "right_hand");
}

/*
	Name: DestructRightLegPieces
	Namespace: DestructServerUtils
	Checksum: 0xD0A8F0CF
	Offset: 0xD90
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function DestructRightLegPieces(entity)
{
	function_a6d21b4d(entity, "right_leg_upper");
	function_a6d21b4d(entity, "right_leg_lower");
	function_a6d21b4d(entity, "right_foot");
}

/*
	Name: GetPieceCount
	Namespace: DestructServerUtils
	Checksum: 0x5831DDDD
	Offset: 0xE08
	Size: 0x69
	Parameters: 1
	Flags: None
*/
function GetPieceCount(entity)
{
	if(isdefined(entity.destructibledef))
	{
		var_c2acfcd7 = struct::get_script_bundle("destructiblecharacterdef", entity.destructibledef);
		if(isdefined(var_c2acfcd7))
		{
			return var_c2acfcd7.pieceCount;
		}
	}
	return 0;
}

/*
	Name: handleDamage
	Namespace: DestructServerUtils
	Checksum: 0xB4D83525
	Offset: 0xE80
	Size: 0xFF
	Parameters: 12
	Flags: None
*/
function handleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, modelIndex)
{
	entity = self;
	if(isdefined(entity.skipdeath) && entity.skipdeath)
	{
		return iDamage;
	}
	if(isdefined(entity.var_132756fd) && entity.var_132756fd)
	{
		return iDamage;
	}
	ToggleSpawnGibs(entity, 1);
	function_a6d21b4d(entity, sHitLoc);
	return iDamage;
}

/*
	Name: IsDestructed
	Namespace: DestructServerUtils
	Checksum: 0xF5E6BF8C
	Offset: 0xF88
	Size: 0x65
	Parameters: 2
	Flags: None
*/
function IsDestructed(entity, pieceNumber)
{
	/#
		/#
			Assert(1 <= pieceNumber && pieceNumber <= 20);
		#/
	#/
	return function_2cb45fe1(entity) & 1 << pieceNumber;
}

/*
	Name: ReapplyDestructedPieces
	Namespace: DestructServerUtils
	Checksum: 0x211C5F3E
	Offset: 0xFF8
	Size: 0x12D
	Parameters: 1
	Flags: None
*/
function ReapplyDestructedPieces(entity)
{
	if(!isdefined(entity.destructibledef))
	{
		return;
	}
	var_c2acfcd7 = struct::get_script_bundle("destructiblecharacterdef", entity.destructibledef);
	for(index = 1; index <= var_c2acfcd7.pieces.size; index++)
	{
		if(!IsDestructed(entity, index))
		{
			continue;
		}
		piece = var_c2acfcd7.pieces[index - 1];
		if(isdefined(piece.hidetag) && entity HasPart(piece.hidetag))
		{
			entity HidePart(piece.hidetag);
		}
	}
}

/*
	Name: ShowDestructedPieces
	Namespace: DestructServerUtils
	Checksum: 0xBBC3B6D1
	Offset: 0x1130
	Size: 0x10D
	Parameters: 1
	Flags: None
*/
function ShowDestructedPieces(entity)
{
	if(!isdefined(entity.destructibledef))
	{
		return;
	}
	var_c2acfcd7 = struct::get_script_bundle("destructiblecharacterdef", entity.destructibledef);
	for(index = 1; index <= var_c2acfcd7.pieces.size; index++)
	{
		piece = var_c2acfcd7.pieces[index - 1];
		if(isdefined(piece.hidetag) && entity HasPart(piece.hidetag))
		{
			entity ShowPart(piece.hidetag);
		}
	}
}

/*
	Name: ToggleSpawnGibs
	Namespace: DestructServerUtils
	Checksum: 0x50FBA039
	Offset: 0x1248
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function ToggleSpawnGibs(entity, shouldSpawnGibs)
{
	if(shouldSpawnGibs)
	{
		entity.var_417f4578 = function_2cb45fe1(entity) | 1;
	}
	else
	{
		entity.var_417f4578 = function_2cb45fe1(entity) & -2;
	}
	entity clientfield::set("destructible_character_state", entity.var_417f4578);
}

