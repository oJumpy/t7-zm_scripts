#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;

#namespace namespace_eaae7728;

/*
	Name: function_30d4f164
	Namespace: namespace_eaae7728
	Checksum: 0x7410E9E2
	Offset: 0x210
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function function_30d4f164()
{
	clientfield::register("scriptmover", "play_underwater_plant_fx", 9000, 1, "int", &function_54254560, 0, 0);
	clientfield::register("actor", "play_carrier_fx", 9000, 1, "int", &function_f0e89ab2, 0, 0);
	clientfield::register("scriptmover", "play_vial_fx", 9000, 1, "int", &function_e9572f40, 0, 0);
	clientfield::register("world", "add_ww_to_box", 9000, 4, "int", &function_fcdf674f, 0, 0);
	clientfield::register("scriptmover", "spider_bait", 9000, 1, "int", &function_6eb27bd9, 0, 0);
}

/*
	Name: function_fcdf674f
	Namespace: namespace_eaae7728
	Checksum: 0x46D171D6
	Offset: 0x388
	Size: 0x93
	Parameters: 7
	Flags: None
*/
function function_fcdf674f(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		var_989d36e = GetWeapon("hero_mirg2000");
		AddZombieBoxWeapon(var_989d36e, var_989d36e.worldmodel, var_989d36e.isDualWield);
	}
}

/*
	Name: function_54254560
	Namespace: namespace_eaae7728
	Checksum: 0xE2BDDD9B
	Offset: 0x428
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_54254560(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayFXOnTag(localClientNum, level._effect["ww_part_underwater_plant"], self, "tag_origin");
}

/*
	Name: function_f0e89ab2
	Namespace: namespace_eaae7728
	Checksum: 0x6E9CC6A7
	Offset: 0x4A0
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_f0e89ab2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayFXOnTag(localClientNum, level._effect["ww_part_scientist_vial"], self, "j_spineupper");
}

/*
	Name: function_e9572f40
	Namespace: namespace_eaae7728
	Checksum: 0x4934485F
	Offset: 0x518
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_e9572f40(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayFXOnTag(localClientNum, level._effect["ww_part_scientist_vial"], self, "tag_origin");
}

/*
	Name: function_6eb27bd9
	Namespace: namespace_eaae7728
	Checksum: 0xD98EE7D8
	Offset: 0x590
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function function_6eb27bd9(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.n_fx_id = playFX(localClientNum, level._effect["spider_pheromone"], self.origin + VectorScale((0, 0, -1), 100));
	}
	else if(isdefined(self.n_fx_id))
	{
		stopfx(localClientNum, self.n_fx_id);
	}
}

