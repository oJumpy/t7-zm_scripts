#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\throttle_shared;

#namespace gib;

/*
	Name: fields_equal
	Namespace: gib
	Checksum: 0x42D702E7
	Offset: 0x388
	Size: 0x5B
	Parameters: 2
	Flags: Private
*/
function private fields_equal(field_a, field_b)
{
	if(!isdefined(field_a) && !isdefined(field_b))
	{
		return 1;
	}
	if(isdefined(field_a) && isdefined(field_b) && field_a == field_b)
	{
		return 1;
	}
	return 0;
}

/*
	Name: _IsDefaultPlayerGib
	Namespace: gib
	Checksum: 0xE3E8B332
	Offset: 0x3F0
	Size: 0x135
	Parameters: 2
	Flags: Private
*/
function private _IsDefaultPlayerGib(gibPieceFlag, gibStruct)
{
	if(!fields_equal(level.playerGibBundle.gibs[gibPieceFlag].gibdynentfx, gibStruct.gibdynentfx))
	{
		return 0;
	}
	if(!fields_equal(level.playerGibBundle.gibs[gibPieceFlag].gibfxtag, gibStruct.gibfxtag))
	{
		return 0;
	}
	if(!fields_equal(level.playerGibBundle.gibs[gibPieceFlag].gibfx, gibStruct.gibfx))
	{
		return 0;
	}
	if(!fields_equal(level.playerGibBundle.gibs[gibPieceFlag].gibtag, gibStruct.gibtag))
	{
		return 0;
	}
	return 1;
}

/*
	Name: main
	Namespace: gib
	Checksum: 0x2643FFA5
	Offset: 0x530
	Size: 0x9AF
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("actor", "gib_state", 1, 9, "int");
	clientfield::register("playercorpse", "gib_state", 1, 15, "int");
	gibDefinitions = struct::get_script_bundles("gibcharacterdef");
	gibPieceLookup = [];
	gibPieceLookup[2] = "annihilate";
	gibPieceLookup[8] = "head";
	gibPieceLookup[16] = "rightarm";
	gibPieceLookup[32] = "leftarm";
	gibPieceLookup[128] = "rightleg";
	gibPieceLookup[256] = "leftleg";
	processedBundles = [];
	if(SessionModeIsMultiplayerGame())
	{
		level.playerGibBundle = spawnstruct();
		level.playerGibBundle.gibs = [];
		level.playerGibBundle.name = "default_player";
		level.playerGibBundle.gibs[2] = spawnstruct();
		level.playerGibBundle.gibs[8] = spawnstruct();
		level.playerGibBundle.gibs[32] = spawnstruct();
		level.playerGibBundle.gibs[256] = spawnstruct();
		level.playerGibBundle.gibs[16] = spawnstruct();
		level.playerGibBundle.gibs[128] = spawnstruct();
		level.playerGibBundle.gibs[2].gibfxtag = "j_spinelower";
		level.playerGibBundle.gibs[2].gibfx = "blood/fx_blood_impact_exp_body_lg";
		level.playerGibBundle.gibs[32].gibmodel = "c_t7_mp_battery_mpc_body1_s_larm";
		level.playerGibBundle.gibs[32].gibdynentfx = "blood/fx_blood_gib_limb_trail_emitter";
		level.playerGibBundle.gibs[32].gibfxtag = "j_elbow_le";
		level.playerGibBundle.gibs[32].gibfx = "blood/fx_blood_gib_arm_sever_burst";
		level.playerGibBundle.gibs[32].gibtag = "j_elbow_le";
		level.playerGibBundle.gibs[256].gibmodel = "c_t7_mp_battery_mpc_body1_s_lleg";
		level.playerGibBundle.gibs[256].gibdynentfx = "blood/fx_blood_gib_limb_trail_emitter";
		level.playerGibBundle.gibs[256].gibfxtag = "j_knee_le";
		level.playerGibBundle.gibs[256].gibfx = "blood/fx_blood_gib_leg_sever_burst";
		level.playerGibBundle.gibs[256].gibtag = "j_knee_le";
		level.playerGibBundle.gibs[16].gibmodel = "c_t7_mp_battery_mpc_body1_s_rarm";
		level.playerGibBundle.gibs[16].gibdynentfx = "blood/fx_blood_gib_limb_trail_emitter";
		level.playerGibBundle.gibs[16].gibfxtag = "j_elbow_ri";
		level.playerGibBundle.gibs[16].gibfx = "blood/fx_blood_gib_arm_sever_burst_rt";
		level.playerGibBundle.gibs[16].gibtag = "j_elbow_ri";
		level.playerGibBundle.gibs[128].gibmodel = "c_t7_mp_battery_mpc_body1_s_rleg";
		level.playerGibBundle.gibs[128].gibdynentfx = "blood/fx_blood_gib_limb_trail_emitter";
		level.playerGibBundle.gibs[128].gibfxtag = "j_knee_ri";
		level.playerGibBundle.gibs[128].gibfx = "blood/fx_blood_gib_leg_sever_burst_rt";
		level.playerGibBundle.gibs[128].gibtag = "j_knee_ri";
	}
	foreach(definition in gibDefinitions)
	{
		gibBundle = spawnstruct();
		gibBundle.gibs = [];
		gibBundle.name = definitionName;
		default_player = 0;
		foreach(gibPieceName in gibPieceLookup)
		{
			gibStruct = spawnstruct();
			gibStruct.gibmodel = GetStructField(definition, gibPieceLookup[gibPieceFlag] + "_gibmodel");
			gibStruct.gibtag = GetStructField(definition, gibPieceLookup[gibPieceFlag] + "_gibtag");
			gibStruct.gibfx = GetStructField(definition, gibPieceLookup[gibPieceFlag] + "_gibfx");
			gibStruct.gibfxtag = GetStructField(definition, gibPieceLookup[gibPieceFlag] + "_gibeffecttag");
			gibStruct.gibdynentfx = GetStructField(definition, gibPieceLookup[gibPieceFlag] + "_gibdynentfx");
			gibStruct.gibsound = GetStructField(definition, gibPieceLookup[gibPieceFlag] + "_gibsound");
			gibStruct.gibhidetag = GetStructField(definition, gibPieceLookup[gibPieceFlag] + "_gibhidetag");
			if(SessionModeIsMultiplayerGame() && _IsDefaultPlayerGib(gibPieceFlag, gibStruct))
			{
				default_player = 1;
			}
			gibBundle.gibs[gibPieceFlag] = gibStruct;
		}
		if(SessionModeIsMultiplayerGame() && default_player)
		{
			processedBundles[definitionName] = level.playerGibBundle;
			continue;
		}
		processedBundles[definitionName] = gibBundle;
	}
	level.scriptbundles["gibcharacterdef"] = processedBundles;
	if(!isdefined(level.gib_throttle))
	{
		function_9b385ca5();
		level.gib_throttle = Throttle;
		Initialize(level.gib_throttle, 2);
	}
}

#namespace GibServerUtils;

/*
	Name: _Annihilate
	Namespace: GibServerUtils
	Checksum: 0x5DBFCA45
	Offset: 0xEE8
	Size: 0x2B
	Parameters: 1
	Flags: Private
*/
function private _Annihilate(entity)
{
	if(isdefined(entity))
	{
		entity notsolid();
	}
}

/*
	Name: _GetGibExtraModel
	Namespace: GibServerUtils
	Checksum: 0x479C7B20
	Offset: 0xF20
	Size: 0xCB
	Parameters: 2
	Flags: Private
*/
function private _GetGibExtraModel(entity, gibFlag)
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
	Name: _GibExtra
	Namespace: GibServerUtils
	Checksum: 0xA2F9D2FE
	Offset: 0xFF8
	Size: 0x77
	Parameters: 2
	Flags: Private
*/
function private _GibExtra(entity, gibFlag)
{
	if(IsGibbed(entity, gibFlag))
	{
		return 0;
	}
	if(!_HasGibDef(entity))
	{
		return 0;
	}
	entity thread _GibExtraInternal(entity, gibFlag);
	return 1;
}

/*
	Name: _GibExtraInternal
	Namespace: GibServerUtils
	Checksum: 0xDAA335D6
	Offset: 0x1078
	Size: 0x1F3
	Parameters: 2
	Flags: Private
*/
function private _GibExtraInternal(entity, gibFlag)
{
	if(entity.gib_time !== GetTime())
	{
		WaitInQueue(level.gib_throttle);
	}
	if(!isdefined(entity))
	{
		return;
	}
	entity.gib_time = GetTime();
	if(IsGibbed(entity, gibFlag))
	{
		return 0;
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
			entity Attach(entity.torsodmg5, entity.gib_data.torsodmg5, entity.gib_data.torsodmg5);
		}
	}
	_SetGibbed(entity, gibFlag, undefined);
	DestructServerUtils::ShowDestructedPieces(entity);
	ShowHiddenGibPieces(entity);
	gibmodel = _GetGibExtraModel(entity, gibFlag);
	if(isdefined(gibmodel))
	{
		entity Detach(gibmodel, "");
	}
	DestructServerUtils::ReapplyDestructedPieces(entity);
	ReapplyHiddenGibPieces(entity);
}

/*
	Name: _GibEntity
	Namespace: GibServerUtils
	Checksum: 0x52FD8A3F
	Offset: 0x1278
	Size: 0x97
	Parameters: 2
	Flags: Private
*/
function private _GibEntity(entity, gibFlag)
{
	if(IsGibbed(entity, gibFlag) || !_HasGibPieces(entity, gibFlag))
	{
		return 0;
	}
	if(!_HasGibDef(entity))
	{
		return 0;
	}
	entity thread _GibEntityInternal(entity, gibFlag);
	return 1;
}

/*
	Name: _GibEntityInternal
	Namespace: GibServerUtils
	Checksum: 0xDBE849CE
	Offset: 0x1318
	Size: 0x1A3
	Parameters: 2
	Flags: Private
*/
function private _GibEntityInternal(entity, gibFlag)
{
	if(entity.gib_time !== GetTime())
	{
		WaitInQueue(level.gib_throttle);
	}
	if(!isdefined(entity))
	{
		return;
	}
	entity.gib_time = GetTime();
	if(IsGibbed(entity, gibFlag))
	{
		return;
	}
	DestructServerUtils::ShowDestructedPieces(entity);
	ShowHiddenGibPieces(entity);
	if(!_GetGibbedState(entity) < 16)
	{
		legModel = _GetGibbedLegModel(entity);
		entity Detach(legModel);
	}
	_SetGibbed(entity, gibFlag, undefined);
	entity SetModel(_GetGibbedTorsoModel(entity));
	entity Attach(_GetGibbedLegModel(entity));
	DestructServerUtils::ReapplyDestructedPieces(entity);
	ReapplyHiddenGibPieces(entity);
}

/*
	Name: _GetGibbedLegModel
	Namespace: GibServerUtils
	Checksum: 0xB30D77F3
	Offset: 0x14C8
	Size: 0x175
	Parameters: 1
	Flags: Private
*/
function private _GetGibbedLegModel(entity)
{
	gibState = _GetGibbedState(entity);
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
	Name: _GetGibbedState
	Namespace: GibServerUtils
	Checksum: 0xB55C6C41
	Offset: 0x1648
	Size: 0x31
	Parameters: 1
	Flags: Private
*/
function private _GetGibbedState(entity)
{
	if(isdefined(entity.gib_state))
	{
		return entity.gib_state;
	}
	return 0;
}

/*
	Name: _GetGibbedTorsoModel
	Namespace: GibServerUtils
	Checksum: 0xB5A41075
	Offset: 0x1688
	Size: 0x175
	Parameters: 1
	Flags: Private
*/
function private _GetGibbedTorsoModel(entity)
{
	gibState = _GetGibbedState(entity);
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
	Name: _HasGibDef
	Namespace: GibServerUtils
	Checksum: 0x157917AD
	Offset: 0x1808
	Size: 0x1B
	Parameters: 1
	Flags: Private
*/
function private _HasGibDef(entity)
{
	return isdefined(entity.gibdef);
}

/*
	Name: _HasGibPieces
	Namespace: GibServerUtils
	Checksum: 0xB07614EF
	Offset: 0x1830
	Size: 0xBF
	Parameters: 2
	Flags: Private
*/
function private _HasGibPieces(entity, gibFlag)
{
	hasGibPieces = 0;
	gibState = _GetGibbedState(entity);
	entity.gib_state = gibState | gibFlag & 512 - 1;
	if(isdefined(_GetGibbedTorsoModel(entity)) && isdefined(_GetGibbedLegModel(entity)))
	{
		hasGibPieces = 1;
	}
	entity.gib_state = gibState;
	return hasGibPieces;
}

/*
	Name: _SetGibbed
	Namespace: GibServerUtils
	Checksum: 0x7DF5D939
	Offset: 0x18F8
	Size: 0x143
	Parameters: 3
	Flags: Private
*/
function private _SetGibbed(entity, gibFlag, gibDir)
{
	if(isdefined(gibDir))
	{
		angles = VectorToAngles(gibDir);
		yaw = angles[1];
		yaw_bits = getbitsforangle(yaw, 3);
		entity.gib_state = _GetGibbedState(entity) | gibFlag & 512 - 1 + yaw_bits << 9;
	}
	else
	{
		entity.gib_state = _GetGibbedState(entity) | gibFlag & 512 - 1;
	}
	entity.gibbed = 1;
	entity clientfield::set("gib_state", entity.gib_state);
}

/*
	Name: Annihilate
	Namespace: GibServerUtils
	Checksum: 0x276243B5
	Offset: 0x1A48
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function Annihilate(entity)
{
	if(!_HasGibDef(entity))
	{
		return 0;
	}
	gibBundle = struct::get_script_bundle("gibcharacterdef", entity.gibdef);
	if(!isdefined(gibBundle) || !isdefined(gibBundle.gibs))
	{
		return 0;
	}
	gibPieceStruct = gibBundle.gibs[2];
	if(isdefined(gibPieceStruct))
	{
		if(isdefined(gibPieceStruct.gibfx))
		{
			_SetGibbed(entity, 2, undefined);
			entity thread _Annihilate(entity);
			return 1;
		}
	}
	return 0;
}

/*
	Name: CopyGibState
	Namespace: GibServerUtils
	Checksum: 0xFCAD44A4
	Offset: 0x1B58
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function CopyGibState(originalEntity, newEntity)
{
	newEntity.gib_state = _GetGibbedState(originalEntity);
	ToggleSpawnGibs(newEntity, 0);
	ReapplyHiddenGibPieces(newEntity);
}

/*
	Name: IsGibbed
	Namespace: GibServerUtils
	Checksum: 0x80D566BF
	Offset: 0x1BD0
	Size: 0x2F
	Parameters: 2
	Flags: None
*/
function IsGibbed(entity, gibFlag)
{
	return _GetGibbedState(entity) & gibFlag;
}

/*
	Name: GibHat
	Namespace: GibServerUtils
	Checksum: 0x17F2938B
	Offset: 0x1C08
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function GibHat(entity)
{
	return _GibExtra(entity, 4);
}

/*
	Name: GibHead
	Namespace: GibServerUtils
	Checksum: 0xE759E19A
	Offset: 0x1C38
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function GibHead(entity)
{
	GibHat(entity);
	return _GibExtra(entity, 8);
}

/*
	Name: GibLeftArm
	Namespace: GibServerUtils
	Checksum: 0x17F592C0
	Offset: 0x1C80
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function GibLeftArm(entity)
{
	if(IsGibbed(entity, 16))
	{
		return 0;
	}
	if(_GibEntity(entity, 32))
	{
		DestructServerUtils::DestructLeftArmPieces(entity);
		return 1;
	}
	return 0;
}

/*
	Name: GibRightArm
	Namespace: GibServerUtils
	Checksum: 0x8F925700
	Offset: 0x1CF0
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function GibRightArm(entity)
{
	if(IsGibbed(entity, 32))
	{
		return 0;
	}
	if(_GibEntity(entity, 16))
	{
		DestructServerUtils::DestructRightArmPieces(entity);
		entity thread shared::DropAIWeapon();
		return 1;
	}
	return 0;
}

/*
	Name: GibLeftLeg
	Namespace: GibServerUtils
	Checksum: 0xF18CC13B
	Offset: 0x1D78
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function GibLeftLeg(entity)
{
	if(_GibEntity(entity, 256))
	{
		DestructServerUtils::DestructLeftLegPieces(entity);
		return 1;
	}
	return 0;
}

/*
	Name: GibRightLeg
	Namespace: GibServerUtils
	Checksum: 0x7C71D188
	Offset: 0x1DC8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function GibRightLeg(entity)
{
	if(_GibEntity(entity, 128))
	{
		DestructServerUtils::DestructRightLegPieces(entity);
		return 1;
	}
	return 0;
}

/*
	Name: GibLegs
	Namespace: GibServerUtils
	Checksum: 0x725869FA
	Offset: 0x1E18
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function GibLegs(entity)
{
	if(_GibEntity(entity, 384))
	{
		DestructServerUtils::DestructRightLegPieces(entity);
		DestructServerUtils::DestructLeftLegPieces(entity);
		return 1;
	}
	return 0;
}

/*
	Name: PlayerGibLeftArm
	Namespace: GibServerUtils
	Checksum: 0x5846B8FD
	Offset: 0x1E80
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function PlayerGibLeftArm(entity)
{
	if(isdefined(entity.body))
	{
		dir = (1, 0, 0);
		_SetGibbed(entity.body, 32, dir);
	}
}

/*
	Name: PlayerGibRightArm
	Namespace: GibServerUtils
	Checksum: 0x59A20878
	Offset: 0x1EE8
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function PlayerGibRightArm(entity)
{
	if(isdefined(entity.body))
	{
		dir = (1, 0, 0);
		_SetGibbed(entity.body, 16, dir);
	}
}

/*
	Name: PlayerGibLeftLeg
	Namespace: GibServerUtils
	Checksum: 0x478EDFE7
	Offset: 0x1F50
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function PlayerGibLeftLeg(entity)
{
	if(isdefined(entity.body))
	{
		dir = (1, 0, 0);
		_SetGibbed(entity.body, 256, dir);
	}
}

/*
	Name: PlayerGibRightLeg
	Namespace: GibServerUtils
	Checksum: 0x669F5CC8
	Offset: 0x1FB8
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function PlayerGibRightLeg(entity)
{
	if(isdefined(entity.body))
	{
		dir = (1, 0, 0);
		_SetGibbed(entity.body, 128, dir);
	}
}

/*
	Name: PlayerGibLegs
	Namespace: GibServerUtils
	Checksum: 0x251702AB
	Offset: 0x2020
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function PlayerGibLegs(entity)
{
	if(isdefined(entity.body))
	{
		dir = (1, 0, 0);
		_SetGibbed(entity.body, 128, dir);
		_SetGibbed(entity.body, 256, dir);
	}
}

/*
	Name: PlayerGibLeftArmVel
	Namespace: GibServerUtils
	Checksum: 0x3E16A791
	Offset: 0x20B0
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function PlayerGibLeftArmVel(entity, dir)
{
	if(isdefined(entity.body))
	{
		_SetGibbed(entity.body, 32, dir);
	}
}

/*
	Name: PlayerGibRightArmVel
	Namespace: GibServerUtils
	Checksum: 0x3A735DD7
	Offset: 0x2108
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function PlayerGibRightArmVel(entity, dir)
{
	if(isdefined(entity.body))
	{
		_SetGibbed(entity.body, 16, dir);
	}
}

/*
	Name: PlayerGibLeftLegVel
	Namespace: GibServerUtils
	Checksum: 0xC4DA859B
	Offset: 0x2160
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function PlayerGibLeftLegVel(entity, dir)
{
	if(isdefined(entity.body))
	{
		_SetGibbed(entity.body, 256, dir);
	}
}

/*
	Name: PlayerGibRightLegVel
	Namespace: GibServerUtils
	Checksum: 0xBCF2EDC
	Offset: 0x21B8
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function PlayerGibRightLegVel(entity, dir)
{
	if(isdefined(entity.body))
	{
		_SetGibbed(entity.body, 128, dir);
	}
}

/*
	Name: PlayerGibLegsVel
	Namespace: GibServerUtils
	Checksum: 0x4C1ADF1C
	Offset: 0x2210
	Size: 0x73
	Parameters: 2
	Flags: None
*/
function PlayerGibLegsVel(entity, dir)
{
	if(isdefined(entity.body))
	{
		_SetGibbed(entity.body, 128, dir);
		_SetGibbed(entity.body, 256, dir);
	}
}

/*
	Name: ReapplyHiddenGibPieces
	Namespace: GibServerUtils
	Checksum: 0xA1208547
	Offset: 0x2290
	Size: 0x191
	Parameters: 1
	Flags: None
*/
function ReapplyHiddenGibPieces(entity)
{
	if(!_HasGibDef(entity))
	{
		return;
	}
	gibBundle = struct::get_script_bundle("gibcharacterdef", entity.gibdef);
	foreach(gib in gibBundle.gibs)
	{
		if(!IsGibbed(entity, gibFlag))
		{
			continue;
		}
		if(isdefined(gib.gibhidetag) && isalive(entity) && entity HasPart(gib.gibhidetag))
		{
			if(!(isdefined(entity.skipdeath) && entity.skipdeath))
			{
				entity HidePart(gib.gibhidetag, "", 1);
			}
		}
	}
}

/*
	Name: ShowHiddenGibPieces
	Namespace: GibServerUtils
	Checksum: 0x42C66B39
	Offset: 0x2430
	Size: 0x131
	Parameters: 1
	Flags: None
*/
function ShowHiddenGibPieces(entity)
{
	if(!_HasGibDef(entity))
	{
		return;
	}
	gibBundle = struct::get_script_bundle("gibcharacterdef", entity.gibdef);
	foreach(gib in gibBundle.gibs)
	{
		if(isdefined(gib.gibhidetag) && entity HasPart(gib.gibhidetag))
		{
			entity ShowPart(gib.gibhidetag, "", 1);
		}
	}
}

/*
	Name: ToggleSpawnGibs
	Namespace: GibServerUtils
	Checksum: 0xADA9F41D
	Offset: 0x2570
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function ToggleSpawnGibs(entity, shouldSpawnGibs)
{
	if(!shouldSpawnGibs)
	{
		entity.gib_state = _GetGibbedState(entity) | 1;
	}
	else
	{
		entity.gib_state = _GetGibbedState(entity) & -2;
	}
	entity clientfield::set("gib_state", entity.gib_state);
}

