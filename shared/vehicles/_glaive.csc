#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace glaive;

/*
	Name: main
	Namespace: glaive
	Checksum: 0xCBDF1820
	Offset: 0x1B0
	Size: 0x4B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("vehicle", "glaive_blood_fx", 1, 1, "int", &glaiveBloodFxHandler, 0, 0);
}

/*
	Name: glaiveBloodFxHandler
	Namespace: glaive
	Checksum: 0x4F87C05D
	Offset: 0x208
	Size: 0xDB
	Parameters: 7
	Flags: Private
*/
function private glaiveBloodFxHandler(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(isdefined(self.bloodFxHandle))
	{
		stopfx(localClientNum, self.bloodFxHandle);
		self.bloodFxHandle = undefined;
	}
	settings = struct::get_script_bundle("vehiclecustomsettings", "glaivesettings");
	if(isdefined(settings))
	{
		if(newValue)
		{
			self.bloodFxHandle = PlayFXOnTag(localClientNum, settings.weakspotfx, self, "j_spineupper");
		}
	}
}

