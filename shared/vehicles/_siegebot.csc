#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\spike_charge_siegebot;

#namespace siegebot;

/*
	Name: main
	Namespace: siegebot
	Checksum: 0x17543661
	Offset: 0x178
	Size: 0x2B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	vehicle::add_vehicletype_callback("siegebot", &_setup_);
}

/*
	Name: _setup_
	Namespace: siegebot
	Checksum: 0x905B8876
	Offset: 0x1B0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function _setup_(localClientNum)
{
	if(isdefined(self.scriptbundlesettings))
	{
		settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	}
	if(!isdefined(settings))
	{
		return;
	}
}

