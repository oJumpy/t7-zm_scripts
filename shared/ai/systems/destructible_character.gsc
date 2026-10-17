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

#namespace DestructServerUtils;

/*
	Name: _getdestructstate
	Namespace: DestructServerUtils
	Checksum: 0x5B7D7283
	Offset: 0x630
	Size: 0x31
	Parameters: 1
	Flags: Private
*/
function private _getdestructstate(entity)
{
	if(isdefined(entity._destruct_state))
	{
		return entity._destruct_state;
	}
	return 0;
}

/*
	Name: _setdestructed
	Namespace: DestructServerUtils
	Checksum: 0xE9F4B4FF
	Offset: 0x670
	Size: 0x6B
	Parameters: 2
	Flags: Private
*/
function private _setdestructed(entity, destructflag)
{
	entity._destruct_state = _getdestructstate(entity) | destructflag;
	entity clientfield::set("destructible_character_state", entity._destruct_state);
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
	newEntity._destruct_state = _getdestructstate(originalEntity);
	ToggleSpawnGibs(newEntity, 0);
	ReapplyDestructedPieces(newEntity);
}

/*
	Name: destructhitlocpieces
	Namespace: DestructServerUtils
	Checksum: 0xF486511E
	Offset: 0x760
	Size: 0xF5
	Parameters: 2
	Flags: None
*/
function destructhitlocpieces(entity, hitLoc)
{
	if(isdefined(entity.destructibledef))
	{
		destructbundle = struct::get_script_bundle("destructiblecharacterdef", entity.destructibledef);
		for(index = 1; index <= destructbundle.pieces.size; index++)
		{
			piece = destructbundle.pieces[index - 1];
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
	destructhitlocpieces(entity, "left_arm_upper");
	destructhitlocpieces(entity, "left_arm_lower");
	destructhitlocpieces(entity, "left_hand");
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
	destructhitlocpieces(entity, "left_leg_upper");
	destructhitlocpieces(entity, "left_leg_lower");
	destructhitlocpieces(entity, "left_foot");
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
	_setdestructed(entity, 1 << pieceNumber);
	if(!isdefined(entity.destructibledef))
	{
		return;
	}
	destructbundle = struct::get_script_bundle("destructiblecharacterdef", entity.destructibledef);
	piece = destructbundle.pieces[pieceNumber - 1];
	if(isdefined(piece.hidetag) && entity HasPart(piece.hidetag))
	{
		entity HidePart(piece.hidetag);
	}
	if(isdefined(piece.detachmodel))
	{
		entity Detach(piece.detachmodel, "");
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
	destructible_pieces_list = [];
	destructablepieces = GetPieceCount(entity);
	if(num_pieces_to_destruct == 0)
	{
		num_pieces_to_destruct = destructablepieces;
	}
	for(i = 0; i < destructablepieces; i++)
	{
		destructible_pieces_list[i] = i + 1;
	}
	destructible_pieces_list = Array::randomize(destructible_pieces_list);
	foreach(piece in destructible_pieces_list)
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
	destructpieces = GetPieceCount(entity);
	for(index = 0; index < destructpieces; index++)
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
	destructhitlocpieces(entity, "right_arm_upper");
	destructhitlocpieces(entity, "right_arm_lower");
	destructhitlocpieces(entity, "right_hand");
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
	destructhitlocpieces(entity, "right_leg_upper");
	destructhitlocpieces(entity, "right_leg_lower");
	destructhitlocpieces(entity, "right_foot");
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
		destructbundle = struct::get_script_bundle("destructiblecharacterdef", entity.destructibledef);
		if(isdefined(destructbundle))
		{
			return destructbundle.pieceCount;
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
	destructhitlocpieces(entity, sHitLoc);
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
	return _getdestructstate(entity) & 1 << pieceNumber;
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
	destructbundle = struct::get_script_bundle("destructiblecharacterdef", entity.destructibledef);
	for(index = 1; index <= destructbundle.pieces.size; index++)
	{
		if(!IsDestructed(entity, index))
		{
			continue;
		}
		piece = destructbundle.pieces[index - 1];
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
	destructbundle = struct::get_script_bundle("destructiblecharacterdef", entity.destructibledef);
	for(index = 1; index <= destructbundle.pieces.size; index++)
	{
		piece = destructbundle.pieces[index - 1];
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
		entity._destruct_state = _getdestructstate(entity) | 1;
	}
	else
	{
		entity._destruct_state = _getdestructstate(entity) & -2;
	}
	entity clientfield::set("destructible_character_state", entity._destruct_state);
}

