#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace namespace_d2ddc550;

/*
	Name: __init__sytem__
	Namespace: namespace_d2ddc550
	Checksum: 0xF3F06799
	Offset: 0x130
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("monkey", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_d2ddc550
	Checksum: 0xE54DF840
	Offset: 0x170
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function __init__()
{
	ai::add_archetype_spawn_function("monkey", &function_70fb871f);
	clientfield::register("actor", "monkey_eye_glow", 21000, 1, "int", &function_2e74dabc, 0, 0);
	level._effect["monkey_eye_glow"] = "dlc5/zmhd/fx_zmb_monkey_eyes";
}

/*
	Name: function_70fb871f
	Namespace: namespace_d2ddc550
	Checksum: 0x89B64DCA
	Offset: 0x208
	Size: 0x23
	Parameters: 1
	Flags: Private
*/
function private function_70fb871f(localClientNum)
{
	self function_ec8b2835(1);
}

/*
	Name: function_2e74dabc
	Namespace: namespace_d2ddc550
	Checksum: 0xD9E32814
	Offset: 0x238
	Size: 0x157
	Parameters: 7
	Flags: None
*/
function function_2e74dabc(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		waittillframeend;
		if(!isdefined(self))
		{
			return;
		}
		var_f9e79b00 = self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, 1, 3, 0);
		self._eyeArray[localClientNum] = PlayFXOnTag(localClientNum, level._effect["monkey_eye_glow"], self, "j_eyeball_le");
	}
	else
	{
		waittillframeend;
		if(!isdefined(self))
		{
			return;
		}
		var_f9e79b00 = self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, 0, 3, 0);
		if(isdefined(self._eyeArray))
		{
			if(isdefined(self._eyeArray[localClientNum]))
			{
				deletefx(localClientNum, self._eyeArray[localClientNum], 1);
				self._eyeArray[localClientNum] = undefined;
			}
		}
	}
}

