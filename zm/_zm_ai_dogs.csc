#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm;

#namespace zm_ai_dogs;

/*
	Name: __init__sytem__
	Namespace: zm_ai_dogs
	Checksum: 0xAF7023C
	Offset: 0x168
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_dogs", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_dogs
	Checksum: 0xF1DD48CA
	Offset: 0x1A8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	init_dog_fx();
	clientfield::register("actor", "dog_fx", 1, 1, "int", &dog_fx, 0, 0);
}

/*
	Name: init_dog_fx
	Namespace: zm_ai_dogs
	Checksum: 0x7B418A18
	Offset: 0x210
	Size: 0x39
	Parameters: 0
	Flags: None
*/
function init_dog_fx()
{
	level._effect["dog_eye_glow"] = "zombie/fx_dog_eyes_zmb";
	level._effect["dog_trail_fire"] = "zombie/fx_dog_fire_trail_zmb";
}

/*
	Name: dog_fx
	Namespace: zm_ai_dogs
	Checksum: 0xDFCDD8A5
	Offset: 0x258
	Size: 0x17B
	Parameters: 7
	Flags: None
*/
function dog_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self._eyeglow_fx_override = level._effect["dog_eye_glow"];
		self zm::createZombieEyes(localClientNum);
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, zm::get_eyeball_on_luminance(), self zm::get_eyeball_color());
		self.n_trails_fx_id = PlayFXOnTag(localClientNum, level._effect["dog_trail_fire"], self, "j_spine2");
	}
	else
	{
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, zm::get_eyeball_off_luminance(), self zm::get_eyeball_color());
		self zm::deleteZombieEyes(localClientNum);
		if(isdefined(self.n_trails_fx_id))
		{
			deletefx(localClientNum, self.n_trails_fx_id);
		}
	}
}

