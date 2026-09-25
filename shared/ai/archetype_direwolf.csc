#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace ArchetypeDirewolf;

/*
	Name: __init__sytem__
	Namespace: ArchetypeDirewolf
	Checksum: 0xACAE8F51
	Offset: 0x140
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("direwolf", &__init__, undefined, undefined);
}

/*
	Name: Precache
	Namespace: ArchetypeDirewolf
	Checksum: 0x3DEC4EE8
	Offset: 0x180
	Size: 0x1D
	Parameters: 0
	Flags: AutoExec
*/
function autoexec Precache()
{
	level._effect["fx_bio_direwolf_eyes"] = "animals/fx_bio_direwolf_eyes";
}

/*
	Name: __init__
	Namespace: ArchetypeDirewolf
	Checksum: 0x11DDFCB1
	Offset: 0x1A8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(ai::shouldRegisterClientFieldForArchetype("direwolf"))
	{
		clientfield::register("actor", "direwolf_eye_glow_fx", 1, 1, "int", &direwolfEyeGlowFxHandler, 0, 1);
	}
}

/*
	Name: direwolfEyeGlowFxHandler
	Namespace: ArchetypeDirewolf
	Checksum: 0xF0DF0394
	Offset: 0x218
	Size: 0x107
	Parameters: 7
	Flags: Private
*/
function private direwolfEyeGlowFxHandler(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	if(isdefined(entity.archetype) && entity.archetype != "direwolf")
	{
		return;
	}
	if(isdefined(entity.eyeGlowFx))
	{
		stopfx(localClientNum, entity.eyeGlowFx);
		entity.eyeGlowFx = undefined;
	}
	if(newValue)
	{
		entity.eyeGlowFx = PlayFXOnTag(localClientNum, level._effect["fx_bio_direwolf_eyes"], entity, "tag_eye");
	}
}

