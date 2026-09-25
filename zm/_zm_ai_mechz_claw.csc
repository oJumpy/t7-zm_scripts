#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace namespace_19d9d56d;

/*
	Name: __init__sytem__
	Namespace: namespace_19d9d56d
	Checksum: 0x89E45E09
	Offset: 0x1B0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_mechz_claw", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_19d9d56d
	Checksum: 0x4C4D1B5D
	Offset: 0x1F0
	Size: 0x13B
	Parameters: 0
	Flags: Private
*/
function private __init__()
{
	clientfield::register("actor", "mechz_fx", 21000, 12, "int", &function_22b149ce, 0, 0);
	clientfield::register("scriptmover", "mechz_claw", 21000, 1, "int", &function_2ad55883, 0, 0);
	clientfield::register("actor", "mechz_wpn_source", 21000, 1, "int", &function_54ae128d, 0, 0);
	clientfield::register("toplayer", "mechz_grab", 21000, 1, "int", &function_8dfa08c1, 0, 0);
	level.mechz_detach_claw_override = &mechz_detach_claw_override;
}

/*
	Name: __main__
	Namespace: namespace_19d9d56d
	Checksum: 0x99EC1590
	Offset: 0x338
	Size: 0x3
	Parameters: 0
	Flags: Private
*/
function private __main__()
{
}

/*
	Name: mechz_detach_claw_override
	Namespace: namespace_19d9d56d
	Checksum: 0xF9F83FD2
	Offset: 0x348
	Size: 0x173
	Parameters: 7
	Flags: Private
*/
function private mechz_detach_claw_override(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	pos = self GetTagOrigin("tag_claw");
	ang = self GetTagAngles("tag_claw");
	velocity = self GetVelocity();
	dynEnt = CreateDynEntAndLaunch(localClientNum, "c_t7_zm_dlchd_origins_mech_claw", pos, ang, self.origin, velocity);
	PlayFXOnTag(localClientNum, level._effect["fx_mech_dmg_armor"], self, "tag_grappling_source_fx");
	self playsound(0, "zmb_ai_mechz_destruction");
	PlayFXOnTag(localClientNum, level._effect["fx_mech_dmg_sparks"], self, "tag_grappling_source_fx");
}

/*
	Name: function_22b149ce
	Namespace: namespace_19d9d56d
	Checksum: 0x9A423DC9
	Offset: 0x4C8
	Size: 0x3B
	Parameters: 7
	Flags: Private
*/
function private function_22b149ce(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
}

/*
	Name: function_2ad55883
	Namespace: namespace_19d9d56d
	Checksum: 0xC5EF36F3
	Offset: 0x510
	Size: 0x73
	Parameters: 7
	Flags: Private
*/
function private function_2ad55883(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue)
	{
		PlayFXOnTag(localClientNum, level._effect["mechz_claw"], self, "tag_origin");
	}
}

/*
	Name: function_54ae128d
	Namespace: namespace_19d9d56d
	Checksum: 0x4388791F
	Offset: 0x590
	Size: 0xB5
	Parameters: 7
	Flags: Private
*/
function private function_54ae128d(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue)
	{
		self.var_ba7e45cf = PlayFXOnTag(localClientNum, level._effect["mechz_wpn_source"], self, "j_elbow_le");
	}
	else if(isdefined(self.var_ba7e45cf))
	{
		stopfx(localClientNum, self.var_ba7e45cf);
		self.var_ba7e45cf = undefined;
	}
}

/*
	Name: function_8dfa08c1
	Namespace: namespace_19d9d56d
	Checksum: 0x92ADCC87
	Offset: 0x650
	Size: 0x73
	Parameters: 7
	Flags: Private
*/
function private function_8dfa08c1(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue)
	{
		self function_21fc862d();
	}
	else
	{
		self function_fedaa2a6();
	}
}

