#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#namespace GibClientUtils;

/*
	Name: main
	Namespace: GibClientUtils
	Checksum: 0x79A307F1
	Offset: 0x208
	Size: 0x433
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("actor", "gib_state", 1, 9, "int", &_GibHandler, 0, 0);
	clientfield::register("playercorpse", "gib_state", 1, 15, "int", &_GibHandler, 0, 0);
	gibDefinitions = struct::get_script_bundles("gibcharacterdef");
	gibPieceLookup = [];
	gibPieceLookup[2] = "annihilate";
	gibPieceLookup[8] = "head";
	gibPieceLookup[16] = "rightarm";
	gibPieceLookup[32] = "leftarm";
	gibPieceLookup[128] = "rightleg";
	gibPieceLookup[256] = "leftleg";
	processedBundles = [];
	foreach(definition in gibDefinitions)
	{
		gibBundle = spawnstruct();
		gibBundle.gibs = [];
		gibBundle.name = definitionName;
		foreach(gibPieceName in gibPieceLookup)
		{
			gibStruct = spawnstruct();
			gibStruct.gibmodel = GetStructField(definition, gibPieceLookup[gibPieceFlag] + "_gibmodel");
			gibStruct.gibtag = GetStructField(definition, gibPieceLookup[gibPieceFlag] + "_gibtag");
			gibStruct.gibfx = GetStructField(definition, gibPieceLookup[gibPieceFlag] + "_gibfx");
			gibStruct.gibfxtag = GetStructField(definition, gibPieceLookup[gibPieceFlag] + "_gibeffecttag");
			gibStruct.gibdynentfx = GetStructField(definition, gibPieceLookup[gibPieceFlag] + "_gibdynentfx");
			gibStruct.gibsound = GetStructField(definition, gibPieceLookup[gibPieceFlag] + "_gibsound");
			gibBundle.gibs[gibPieceFlag] = gibStruct;
		}
		processedBundles[definitionName] = gibBundle;
	}
	level.scriptbundles["gibcharacterdef"] = processedBundles;
	level thread _AnnihilateCorpse();
}

/*
	Name: _AnnihilateCorpse
	Namespace: GibClientUtils
	Checksum: 0x19FDF876
	Offset: 0x648
	Size: 0x1F7
	Parameters: 0
	Flags: Private
*/
function private _AnnihilateCorpse()
{
	while(1)
	{
		level waittill("corpse_explode", localClientNum, body, origin);
		if(!util::is_mature() || util::is_gib_restricted_build())
		{
			continue;
		}
		if(isdefined(body) && _HasGibDef(body) && body IsRagdoll())
		{
			ClientEntGibHead(localClientNum, body);
			ClientEntGibRightArm(localClientNum, body);
			ClientEntGibLeftArm(localClientNum, body);
			ClientEntGibRightLeg(localClientNum, body);
			ClientEntGibLeftLeg(localClientNum, body);
		}
		if(isdefined(body) && _HasGibDef(body) && body.archetype == "human")
		{
			if(RandomInt(100) >= 50)
			{
				continue;
			}
			if(isdefined(origin) && DistanceSquared(body.origin, origin) <= 14400)
			{
				body.ignoreRagdoll = 1;
				body _GibEntity(localClientNum, 50 | 384, 1);
			}
		}
	}
}

/*
	Name: _CloneGibData
	Namespace: GibClientUtils
	Checksum: 0x41014BCC
	Offset: 0x848
	Size: 0x20B
	Parameters: 3
	Flags: Private
*/
function private _CloneGibData(localClientNum, entity, clone)
{
	clone.gib_data = spawnstruct();
	clone.gib_data.gib_state = entity.gib_state;
	clone.gib_data.gibdef = entity.gibdef;
	clone.gib_data.hatModel = entity.hatModel;
	clone.gib_data.head = entity.head;
	clone.gib_data.legdmg1 = entity.legdmg1;
	clone.gib_data.legdmg2 = entity.legdmg2;
	clone.gib_data.legdmg3 = entity.legdmg3;
	clone.gib_data.legdmg4 = entity.legdmg4;
	clone.gib_data.torsodmg1 = entity.torsodmg1;
	clone.gib_data.torsodmg2 = entity.torsodmg2;
	clone.gib_data.torsodmg3 = entity.torsodmg3;
	clone.gib_data.torsodmg4 = entity.torsodmg4;
	clone.gib_data.torsodmg5 = entity.torsodmg5;
}

/*
	Name: _GetGibDef
	Namespace: GibClientUtils
	Checksum: 0x51917E21
	Offset: 0xA60
	Size: 0x91
	Parameters: 1
	Flags: Private
*/
function private _GetGibDef(entity)
{
	if(entity isPlayer() || entity IsPlayerCorpse())
	{
		return entity GetPlayerGibDef();
	}
	else if(isdefined(entity.gib_data))
	{
		return entity.gib_data.gibdef;
	}
	return entity.gibdef;
}

/*
	Name: _GetGibbedState
	Namespace: GibClientUtils
	Checksum: 0xF077F9C0
	Offset: 0xB00
	Size: 0x85
	Parameters: 2
	Flags: Private
*/
function private _GetGibbedState(localClientNum, entity)
{
	if(isdefined(entity.gib_data) && isdefined(entity.gib_data.gib_state))
	{
		return entity.gib_data.gib_state;
	}
	else if(isdefined(entity.gib_state))
	{
		return entity.gib_state;
	}
	return 0;
}

/*
	Name: _GetGibbedLegModel
	Namespace: GibClientUtils
	Checksum: 0xB4C565C0
	Offset: 0xB90
	Size: 0x17D
	Parameters: 2
	Flags: Private
*/
function private _GetGibbedLegModel(localClientNum, entity)
{
	gibState = _GetGibbedState(localClientNum, entity);
	rightLegGibbed = gibState & 128;
	leftLegGibbed = gibState & 256;
	if(rightLegGibbed && leftLegGibbed)
	{
		if(isdefined(entity.gib_data))
		{
		}
		else
		{
		}
		return entity.legdmg4;
	}
	else if(rightLegGibbed)
	{
		if(isdefined(entity.gib_data))
		{
		}
		else
		{
		}
		return entity.legdmg2;
	}
	else if(leftLegGibbed)
	{
		if(isdefined(entity.gib_data))
		{
		}
		else
		{
		}
		return entity.legdmg3;
	}
	if(isdefined(entity.gib_data))
	{
	}
	else
	{
	}
	return entity.legdmg1;
}

/*
	Name: _GetGibExtraModel
	Namespace: GibClientUtils
	Checksum: 0xFE07E53D
	Offset: 0xD18
	Size: 0xD3
	Parameters: 3
	Flags: Private
*/
function private _GetGibExtraModel(localClientNumm, entity, gibFlag)
{
	if(gibFlag == 4)
	{
		if(isdefined(entity.gib_data))
		{
		}
		else
		{
		}
		return entity.hatModel;
	}
	else if(gibFlag == 8)
	{
		if(isdefined(entity.gib_data))
		{
		}
		else
		{
		}
		return entity.head;
	}
	else
	{
		ASSERTMSG("Dev Block strings are not supported");
	}
	/#
	#/
}

/*
	Name: _GetGibbedTorsoModel
	Namespace: GibClientUtils
	Checksum: 0xF5514252
	Offset: 0xDF8
	Size: 0x17D
	Parameters: 2
	Flags: Private
*/
function private _GetGibbedTorsoModel(localClientNum, entity)
{
	gibState = _GetGibbedState(localClientNum, entity);
	rightArmGibbed = gibState & 16;
	leftArmGibbed = gibState & 32;
	if(rightArmGibbed && leftArmGibbed)
	{
		if(isdefined(entity.gib_data))
		{
		}
		else
		{
		}
		return entity.torsodmg2;
	}
	else if(rightArmGibbed)
	{
		if(isdefined(entity.gib_data))
		{
		}
		else
		{
		}
		return entity.torsodmg2;
	}
	else if(leftArmGibbed)
	{
		if(isdefined(entity.gib_data))
		{
		}
		else
		{
		}
		return entity.torsodmg3;
	}
	if(isdefined(entity.gib_data))
	{
	}
	else
	{
	}
	return entity.torsodmg1;
}

/*
	Name: _GibPieceTag
	Namespace: GibClientUtils
	Checksum: 0xC9277A10
	Offset: 0xF80
	Size: 0xB3
	Parameters: 3
	Flags: Private
*/
function private _GibPieceTag(localClientNum, entity, gibFlag)
{
	if(!_HasGibDef(self))
	{
		return;
	}
	gibBundle = struct::get_script_bundle("gibcharacterdef", _GetGibDef(entity));
	gibPiece = gibBundle.gibs[gibFlag];
	if(isdefined(gibPiece))
	{
		return gibPiece.gibfxtag;
	}
}

/*
	Name: _GibEntity
	Namespace: GibClientUtils
	Checksum: 0x227FAC2A
	Offset: 0x1040
	Size: 0x29F
	Parameters: 3
	Flags: Private
*/
function private _GibEntity(localClientNum, gibFlags, shouldSpawnGibs)
{
	entity = self;
	if(!_HasGibDef(entity))
	{
		return;
	}
	currentGibFlag = 2;
	gibDir = undefined;
	if(entity isPlayer() || entity IsPlayerCorpse())
	{
		yaw_bits = gibFlags >> 9 & 8 - 1;
		yaw = getanglefrombits(yaw_bits, 3);
		gibDir = AnglesToForward((0, yaw, 0));
	}
	gibBundle = struct::get_script_bundle("gibcharacterdef", _GetGibDef(entity));
	while(gibFlags >= currentGibFlag)
	{
		if(gibFlags & currentGibFlag)
		{
			gibPiece = gibBundle.gibs[currentGibFlag];
			if(isdefined(gibPiece))
			{
				if(shouldSpawnGibs)
				{
					entity thread _GibPiece(localClientNum, entity, gibPiece.gibmodel, gibPiece.gibtag, gibPiece.gibdynentfx, gibDir);
				}
				_PlayGibFX(localClientNum, entity, gibPiece.gibfx, gibPiece.gibfxtag);
				_PlayGibSound(localClientNum, entity, gibPiece.gibsound);
				if(currentGibFlag == 2)
				{
					entity Hide();
					entity.ignoreRagdoll = 1;
				}
			}
			_HandleGibCallbacks(localClientNum, entity, currentGibFlag);
		}
		currentGibFlag = currentGibFlag << 1;
	}
}

/*
	Name: _SetGibbed
	Namespace: GibClientUtils
	Checksum: 0xC67CD0A3
	Offset: 0x12E8
	Size: 0x97
	Parameters: 3
	Flags: Private
*/
function private _SetGibbed(localClientNum, entity, gibFlag)
{
	gib_state = _GetGibbedState(localClientNum, entity) | gibFlag & 512 - 1;
	if(isdefined(entity.gib_data))
	{
		entity.gib_data.gib_state = gib_state;
	}
	else
	{
		entity.gib_state = gib_state;
	}
}

/*
	Name: _GibClientEntityInternal
	Namespace: GibClientUtils
	Checksum: 0x9B25048B
	Offset: 0x1388
	Size: 0x1C3
	Parameters: 3
	Flags: Private
*/
function private _GibClientEntityInternal(localClientNum, entity, gibFlag)
{
	if(!util::is_mature() || util::is_gib_restricted_build())
	{
		return;
	}
	if(!isdefined(entity) || !_HasGibDef(entity))
	{
		return;
	}
	if(entity.type !== "scriptmover")
	{
		return;
	}
	if(IsGibbed(localClientNum, entity, gibFlag))
	{
		return;
	}
	if(!_GetGibbedState(localClientNum, entity) < 16)
	{
		legModel = _GetGibbedLegModel(localClientNum, entity);
		entity Detach(legModel, "");
	}
	_SetGibbed(localClientNum, entity, gibFlag);
	entity SetModel(_GetGibbedTorsoModel(localClientNum, entity));
	entity Attach(_GetGibbedLegModel(localClientNum, entity), "");
	entity _GibEntity(localClientNum, gibFlag, 1);
}

/*
	Name: _GibClientExtraInternal
	Namespace: GibClientUtils
	Checksum: 0xA71976E1
	Offset: 0x1558
	Size: 0x1EB
	Parameters: 3
	Flags: Private
*/
function private _GibClientExtraInternal(localClientNum, entity, gibFlag)
{
	if(!util::is_mature() || util::is_gib_restricted_build())
	{
		return;
	}
	if(!isdefined(entity))
	{
		return;
	}
	if(entity.type !== "scriptmover")
	{
		return;
	}
	if(IsGibbed(localClientNum, entity, gibFlag))
	{
		return;
	}
	gibmodel = _GetGibExtraModel(localClientNum, entity, gibFlag);
	if(isdefined(gibmodel) && entity IsAttached(gibmodel, ""))
	{
		entity Detach(gibmodel, "");
	}
	if(gibFlag == 8)
	{
		if(isdefined(entity.gib_data))
		{
		}
		else if(isdefined(entity.torsodmg5))
		{
			if(isdefined(entity.gib_data))
			{
			}
			else
			{
			}
			entity Attach(entity.torsodmg5, entity.gib_data.torsodmg5);
		}
	}
	_SetGibbed(localClientNum, entity, gibFlag);
	entity _GibEntity(localClientNum, gibFlag, 1);
}

/*
	Name: _GibHandler
	Namespace: GibClientUtils
	Checksum: 0x8F4D523D
	Offset: 0x1750
	Size: 0x1AF
	Parameters: 7
	Flags: Private
*/
function private _GibHandler(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	if(entity isPlayer() || entity IsPlayerCorpse())
	{
		if(!util::is_mature() || util::is_gib_restricted_build())
		{
			return;
		}
	}
	else if(isdefined(entity.maturegib) && entity.maturegib && !util::is_mature())
	{
		return;
	}
	if(isdefined(entity.restrictedgib) && entity.restrictedgib && !IsShowGibsEnabled())
	{
		return;
	}
	gibFlags = oldValue ^ newValue;
	shouldSpawnGibs = !newValue & 1;
	if(bNewEnt)
	{
		gibFlags = 0 ^ newValue;
	}
	entity _GibEntity(localClientNum, gibFlags, shouldSpawnGibs);
	entity.gib_state = newValue;
}

/*
	Name: _GibPiece
	Namespace: GibClientUtils
	Checksum: 0x9567B73A
	Offset: 0x1908
	Size: 0x303
	Parameters: 6
	Flags: None
*/
function _GibPiece(localClientNum, entity, gibmodel, gibtag, gibfx, gibDir)
{
	if(!isdefined(gibtag) || !isdefined(gibmodel))
	{
		return;
	}
	startPosition = entity GetTagOrigin(gibtag);
	startAngles = entity GetTagAngles(gibtag);
	endPosition = startPosition;
	endAngles = startAngles;
	forwardVector = undefined;
	if(!isdefined(startPosition) || !isdefined(startAngles))
	{
		return 0;
	}
	if(isdefined(gibDir))
	{
		startPosition = (0, 0, 0);
		forwardVector = gibDir;
		forwardVector = forwardVector * RandomFloatRange(100, 500);
	}
	else
	{
		wait(0.016);
		if(isdefined(entity))
		{
			endPosition = entity GetTagOrigin(gibtag);
			endAngles = entity GetTagAngles(gibtag);
		}
		else
		{
			endPosition = startPosition + AnglesToForward(startAngles) * 10;
			endAngles = startAngles;
		}
		if(!isdefined(endPosition) || !isdefined(endAngles))
		{
			return 0;
		}
		forwardVector = VectorNormalize(endPosition - startPosition);
		forwardVector = forwardVector * RandomFloatRange(0.6, 1);
		forwardVector = forwardVector + (RandomFloatRange(0, 0.2), RandomFloatRange(0, 0.2), RandomFloatRange(0.2, 0.7));
	}
	if(isdefined(entity))
	{
		GibEntity = CreateDynEntAndLaunch(localClientNum, gibmodel, endPosition, endAngles, startPosition, forwardVector, gibfx, 1);
		if(isdefined(GibEntity))
		{
			SetDynEntBodyRenderOptionsPacked(GibEntity, entity GetBodyRenderOptionsPacked());
		}
	}
}

/*
	Name: _HandleGibCallbacks
	Namespace: GibClientUtils
	Checksum: 0x9789438D
	Offset: 0x1C18
	Size: 0xDD
	Parameters: 3
	Flags: Private
*/
function private _HandleGibCallbacks(localClientNum, entity, gibFlag)
{
	if(isdefined(entity._gibCallbacks) && isdefined(entity._gibCallbacks[gibFlag]))
	{
		foreach(callback in entity._gibCallbacks[gibFlag])
		{
			[[callback]](localClientNum, entity, gibFlag);
		}
	}
}

/*
	Name: _HandleGibAnnihilate
	Namespace: GibClientUtils
	Checksum: 0x2230DBA5
	Offset: 0x1D00
	Size: 0x5B
	Parameters: 1
	Flags: Private
*/
function private _HandleGibAnnihilate(localClientNum)
{
	entity = self;
	entity endon("entityshutdown");
	entity waittillmatch("_anim_notify_");
	ClientEntGibAnnihilate(localClientNum, entity);
}

/*
	Name: _HandleGibHead
	Namespace: GibClientUtils
	Checksum: 0x12A546E0
	Offset: 0x1D68
	Size: 0x5B
	Parameters: 1
	Flags: Private
*/
function private _HandleGibHead(localClientNum)
{
	entity = self;
	entity endon("entityshutdown");
	entity waittillmatch("_anim_notify_");
	ClientEntGibHead(localClientNum, entity);
}

/*
	Name: _HandleGibRightArm
	Namespace: GibClientUtils
	Checksum: 0xCC7FEB5C
	Offset: 0x1DD0
	Size: 0x5B
	Parameters: 1
	Flags: Private
*/
function private _HandleGibRightArm(localClientNum)
{
	entity = self;
	entity endon("entityshutdown");
	entity waittillmatch("_anim_notify_");
	ClientEntGibRightArm(localClientNum, entity);
}

/*
	Name: _HandleGibLeftArm
	Namespace: GibClientUtils
	Checksum: 0x45FD21E3
	Offset: 0x1E38
	Size: 0x5B
	Parameters: 1
	Flags: Private
*/
function private _HandleGibLeftArm(localClientNum)
{
	entity = self;
	entity endon("entityshutdown");
	entity waittillmatch("_anim_notify_");
	ClientEntGibLeftArm(localClientNum, entity);
}

/*
	Name: _HandleGibRightLeg
	Namespace: GibClientUtils
	Checksum: 0x9C070701
	Offset: 0x1EA0
	Size: 0x5B
	Parameters: 1
	Flags: Private
*/
function private _HandleGibRightLeg(localClientNum)
{
	entity = self;
	entity endon("entityshutdown");
	entity waittillmatch("_anim_notify_");
	ClientEntGibRightLeg(localClientNum, entity);
}

/*
	Name: _HandleGibLeftLeg
	Namespace: GibClientUtils
	Checksum: 0xCEE07666
	Offset: 0x1F08
	Size: 0x5B
	Parameters: 1
	Flags: Private
*/
function private _HandleGibLeftLeg(localClientNum)
{
	entity = self;
	entity endon("entityshutdown");
	entity waittillmatch("_anim_notify_");
	ClientEntGibLeftLeg(localClientNum, entity);
}

/*
	Name: _HasGibDef
	Namespace: GibClientUtils
	Checksum: 0xC685497C
	Offset: 0x1F70
	Size: 0x6B
	Parameters: 1
	Flags: Private
*/
function private _HasGibDef(entity)
{
	return isdefined(entity.gib_data) && isdefined(entity.gib_data.gibdef) || isdefined(entity.gibdef) || entity GetPlayerGibDef() != "unknown";
}

/*
	Name: _PlayGibFX
	Namespace: GibClientUtils
	Checksum: 0x1E96FE57
	Offset: 0x1FE8
	Size: 0x109
	Parameters: 4
	Flags: None
*/
function _PlayGibFX(localClientNum, entity, fxFileName, fxTag)
{
	if(isdefined(fxFileName) && isdefined(fxTag) && entity hasdobj(localClientNum))
	{
		FX = PlayFXOnTag(localClientNum, fxFileName, entity, fxTag);
		if(isdefined(FX))
		{
			if(isdefined(entity.team))
			{
				SetFxTeam(localClientNum, FX, entity.team);
			}
			if(isdefined(level.SetGibFXToIgnorePause) && level.SetGibFXToIgnorePause)
			{
				SetFXIgnorePause(localClientNum, FX, 1);
			}
		}
		return FX;
	}
}

/*
	Name: _PlayGibSound
	Namespace: GibClientUtils
	Checksum: 0xFBC0048
	Offset: 0x2100
	Size: 0x4B
	Parameters: 3
	Flags: None
*/
function _PlayGibSound(localClientNum, entity, soundAlias)
{
	if(isdefined(soundAlias))
	{
		playsound(localClientNum, soundAlias, entity.origin);
	}
}

/*
	Name: AddGibCallback
	Namespace: GibClientUtils
	Checksum: 0x30D2D745
	Offset: 0x2158
	Size: 0xF5
	Parameters: 4
	Flags: None
*/
function AddGibCallback(localClientNum, entity, gibFlag, callbackFunction)
{
	/#
		Assert(IsFunctionPtr(callbackFunction));
	#/
	if(!isdefined(entity._gibCallbacks))
	{
		entity._gibCallbacks = [];
	}
	if(!isdefined(entity._gibCallbacks[gibFlag]))
	{
		entity._gibCallbacks[gibFlag] = [];
	}
	gibCallbacks = entity._gibCallbacks[gibFlag];
	gibCallbacks[gibCallbacks.size] = callbackFunction;
	entity._gibCallbacks[gibFlag] = gibCallbacks;
}

/*
	Name: ClientEntGibAnnihilate
	Namespace: GibClientUtils
	Checksum: 0x5D4A37DD
	Offset: 0x2258
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function ClientEntGibAnnihilate(localClientNum, entity)
{
	if(!util::is_mature() || util::is_gib_restricted_build())
	{
		return;
	}
	entity.ignoreRagdoll = 1;
	entity _GibEntity(localClientNum, 50 | 384, 1);
}

/*
	Name: ClientEntGibHead
	Namespace: GibClientUtils
	Checksum: 0x99ACDA71
	Offset: 0x22E0
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function ClientEntGibHead(localClientNum, entity)
{
	_GibClientExtraInternal(localClientNum, entity, 4);
	_GibClientExtraInternal(localClientNum, entity, 8);
}

/*
	Name: ClientEntGibLeftArm
	Namespace: GibClientUtils
	Checksum: 0x33BACE49
	Offset: 0x2340
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function ClientEntGibLeftArm(localClientNum, entity)
{
	if(IsGibbed(localClientNum, entity, 16))
	{
		return;
	}
	_GibClientEntityInternal(localClientNum, entity, 32);
}

/*
	Name: ClientEntGibRightArm
	Namespace: GibClientUtils
	Checksum: 0xDB348E9D
	Offset: 0x23A0
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function ClientEntGibRightArm(localClientNum, entity)
{
	if(IsGibbed(localClientNum, entity, 32))
	{
		return;
	}
	_GibClientEntityInternal(localClientNum, entity, 16);
}

/*
	Name: ClientEntGibLeftLeg
	Namespace: GibClientUtils
	Checksum: 0x10359DCA
	Offset: 0x2400
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function ClientEntGibLeftLeg(localClientNum, entity)
{
	_GibClientEntityInternal(localClientNum, entity, 256);
}

/*
	Name: ClientEntGibRightLeg
	Namespace: GibClientUtils
	Checksum: 0xADC4650A
	Offset: 0x2440
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function ClientEntGibRightLeg(localClientNum, entity)
{
	_GibClientEntityInternal(localClientNum, entity, 128);
}

/*
	Name: CreateScriptModelOfEntity
	Namespace: GibClientUtils
	Checksum: 0x6E4C48B6
	Offset: 0x2480
	Size: 0x377
	Parameters: 2
	Flags: None
*/
function CreateScriptModelOfEntity()
{
System.Exception: Unexpected non-stack operation within jump expression
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‪⁮⁮‪‪‭‎‎‍⁪⁪⁭⁮‎⁪​‎‎⁪‏⁭‪⁬⁫‏‍​‎‬‏‏​​⁫‫⁫‭‎‭⁯‮(ScriptOp )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.​‮‍‬⁯⁭‍⁫‌‭‎⁫‪⁮‏‏⁯⁫‏‏‮⁫⁪‫‪⁪⁭⁯‮⁯‭⁯‫⁯‎‏‍‌⁫‪‮(ScriptOp , ⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‬‪‎⁭⁭⁮‎⁮⁭⁯‭‍⁯⁯⁪⁬‪‎⁪⁮‎⁭‬‪​‍‭⁪‮‪​‮‪⁯‪⁮⁬‪‮‏‮(Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‫⁯⁪​‍⁭​⁫‫⁯‮​‍‬‮‌‪‪‎‫⁫‎‭‫⁪‫⁪⁬‪‍⁮‏‌⁪​‎‎⁯‮‭‮()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: IsGibbed
	Namespace: GibClientUtils
	Checksum: 0xB80F09C8
	Offset: 0x2800
	Size: 0x37
	Parameters: 3
	Flags: None
*/
function IsGibbed(localClientNum, entity, gibFlag)
{
	return _GetGibbedState(localClientNum, entity) & gibFlag;
}

/*
	Name: IsUndamaged
	Namespace: GibClientUtils
	Checksum: 0x62794254
	Offset: 0x2840
	Size: 0x2D
	Parameters: 2
	Flags: None
*/
function IsUndamaged(localClientNum, entity)
{
	return _GetGibbedState(localClientNum, entity) == 0;
}

/*
	Name: GibEntity
	Namespace: GibClientUtils
	Checksum: 0xC94319C4
	Offset: 0x2878
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function GibEntity(localClientNum, gibFlags)
{
	self _GibEntity(localClientNum, gibFlags, 1);
	self.gib_state = _GetGibbedState(localClientNum, self) | gibFlags & 512 - 1;
}

/*
	Name: HandleGibNotetracks
	Namespace: GibClientUtils
	Checksum: 0x85465374
	Offset: 0x28E8
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function HandleGibNotetracks(localClientNum)
{
	entity = self;
	entity thread _HandleGibAnnihilate(localClientNum);
	entity thread _HandleGibHead(localClientNum);
	entity thread _HandleGibRightArm(localClientNum);
	entity thread _HandleGibLeftArm(localClientNum);
	entity thread _HandleGibRightLeg(localClientNum);
	entity thread _HandleGibLeftLeg(localClientNum);
}

/*
	Name: PlayerGibLeftArm
	Namespace: GibClientUtils
	Checksum: 0xF57717A3
	Offset: 0x29A0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function PlayerGibLeftArm(localClientNum)
{
	self GibEntity(localClientNum, 32);
}

/*
	Name: PlayerGibRightArm
	Namespace: GibClientUtils
	Checksum: 0xDB12AA18
	Offset: 0x29D8
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function PlayerGibRightArm(localClientNum)
{
	self GibEntity(localClientNum, 16);
}

/*
	Name: PlayerGibLeftLeg
	Namespace: GibClientUtils
	Checksum: 0x4987943E
	Offset: 0x2A10
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function PlayerGibLeftLeg(localClientNum)
{
	self GibEntity(localClientNum, 256);
}

/*
	Name: PlayerGibRightLeg
	Namespace: GibClientUtils
	Checksum: 0x219354D
	Offset: 0x2A48
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function PlayerGibRightLeg(localClientNum)
{
	self GibEntity(localClientNum, 128);
}

/*
	Name: PlayerGibLegs
	Namespace: GibClientUtils
	Checksum: 0x3C5F7A02
	Offset: 0x2A80
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function PlayerGibLegs(localClientNum)
{
	self GibEntity(localClientNum, 128);
	self GibEntity(localClientNum, 256);
}

/*
	Name: PlayerGibTag
	Namespace: GibClientUtils
	Checksum: 0x1D8D4FBA
	Offset: 0x2AD8
	Size: 0x31
	Parameters: 2
	Flags: None
*/
function PlayerGibTag(localClientNum, gibFlag)
{
	return _GibPieceTag(localClientNum, self, gibFlag);
}

