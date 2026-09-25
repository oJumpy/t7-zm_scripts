#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weap_elemental_bow;

#namespace namespace_efd1ef23;

/*
	Name: __init__sytem__
	Namespace: namespace_efd1ef23
	Checksum: 0x75E7AF2
	Offset: 0x630
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("_zm_weap_elemental_bow_demongate", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_efd1ef23
	Checksum: 0x4848905A
	Offset: 0x670
	Size: 0x39D
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "elemental_bow_demongate" + "_ambient_bow_fx", 5000, 1, "int", &function_da7a9948, 0, 0);
	clientfield::register("missile", "elemental_bow_demongate" + "_arrow_impact_fx", 5000, 1, "int", &function_f514bd4b, 0, 0);
	clientfield::register("missile", "elemental_bow_demongate4" + "_arrow_impact_fx", 5000, 1, "int", &function_3e42c666, 0, 0);
	clientfield::register("scriptmover", "demongate_portal_fx", 5000, 1, "int", &function_b60106f1, 0, 0);
	clientfield::register("toplayer", "demongate_portal_rumble", 1, 1, "int", &function_2e7aea94, 0, 0);
	clientfield::register("scriptmover", "demongate_wander_locomotion_anim", 5000, 1, "int", &function_b463a519, 0, 0);
	clientfield::register("scriptmover", "demongate_attack_locomotion_anim", 5000, 1, "int", &function_ac6d79d2, 0, 0);
	clientfield::register("scriptmover", "demongate_chomper_fx", 5000, 1, "int", &function_f763292d, 0, 0);
	clientfield::register("scriptmover", "demongate_chomper_bite_fx", 5000, 1, "counter", &function_ac9c30de, 0, 0);
	level._effect["demongate_ambient_bow"] = "dlc1/zmb_weapon/fx_bow_demongate_ambient_1p_zmb";
	level._effect["demongate_arrow_impact"] = "dlc1/zmb_weapon/fx_bow_demongate_impact_zmb";
	level._effect["demongate_arrow_charged_impact"] = "dlc1/zmb_weapon/fx_bow_demongate_impact_ug_zmb";
	level._effect["demongate_chomper_trail"] = "dlc1/zmb_weapon/fx_bow_demonhead_trail_zmb";
	level._effect["demongate_chomper_bite"] = "dlc1/zmb_weapon/fx_bow_demonhead_bite_zmb";
	level._effect["demongate_chomper_end"] = "dlc1/zmb_weapon/fx_bow_demonhead_despawn_zmb";
	level._effect["demongate_portal_open"] = "dlc1/zmb_weapon/fx_bow_demongate_portal_open_zmb";
	level._effect["demongate_portal_loop"] = "dlc1/zmb_weapon/fx_bow_demongate_portal_loop_zmb";
	level._effect["demongate_portal_close"] = "dlc1/zmb_weapon/fx_bow_demongate_portal_close_zmb";
}

/*
	Name: function_da7a9948
	Namespace: namespace_efd1ef23
	Checksum: 0xE3B3815B
	Offset: 0xA18
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function function_da7a9948(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self zm_weap_elemental_bow::function_3158b481(localClientNum, newVal, "demongate_ambient_bow");
}

/*
	Name: function_f514bd4b
	Namespace: namespace_efd1ef23
	Checksum: 0xE3A53729
	Offset: 0xA88
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function function_f514bd4b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playFX(localClientNum, level._effect["demongate_arrow_impact"], self.origin);
	}
}

/*
	Name: function_3e42c666
	Namespace: namespace_efd1ef23
	Checksum: 0x7DEAB41F
	Offset: 0xB08
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function function_3e42c666(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playFX(localClientNum, level._effect["demongate_arrow_charged_impact"], self.origin);
	}
}

/*
	Name: function_b60106f1
	Namespace: namespace_efd1ef23
	Checksum: 0xD0AE3DF6
	Offset: 0xB88
	Size: 0x1A3
	Parameters: 7
	Flags: None
*/
function function_b60106f1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playFX(localClientNum, level._effect["demongate_portal_open"], self.origin, AnglesToForward(self.angles));
		self.var_4b6fd850 = self PlayLoopSound("zmb_demongate_portal_lp", 1);
		wait(0.45);
		self.var_fd0edd83 = playFX(localClientNum, level._effect["demongate_portal_loop"], self.origin, AnglesToForward(self.angles));
	}
	else
	{
		deletefx(localClientNum, self.var_fd0edd83, 0);
		playFX(localClientNum, level._effect["demongate_portal_close"], self.origin, AnglesToForward(self.angles));
		if(isdefined(self.var_4b6fd850))
		{
			self StopLoopSound(self.var_4b6fd850, 1);
		}
	}
}

/*
	Name: function_2e7aea94
	Namespace: namespace_efd1ef23
	Checksum: 0x55E92D05
	Offset: 0xD38
	Size: 0x6D
	Parameters: 7
	Flags: None
*/
function function_2e7aea94(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self thread function_35e3ef91(localClientNum);
	}
	else
	{
		self notify("hash_3e0789ec");
	}
}

/*
	Name: function_35e3ef91
	Namespace: namespace_efd1ef23
	Checksum: 0x10D6567B
	Offset: 0xDB0
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function function_35e3ef91(localClientNum)
{
	level endon("demo_jump");
	self endon("hash_3e0789ec");
	self endon("death");
	while(isdefined(self))
	{
		self PlayRumbleOnEntity(localClientNum, "zod_idgun_vortex_interior");
		wait(0.075);
	}
}

/*
	Name: function_b463a519
	Namespace: namespace_efd1ef23
	Checksum: 0x13859D7E
	Offset: 0xE18
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_b463a519(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!self HasAnimTree())
	{
		self useanimtree(-1);
	}
	if(newVal)
	{
		self SetAnim("ai_zm_dlc1_chomper_a_demongate_swarm_locomotion_f_notrans");
	}
}

/*
	Name: function_ac6d79d2
	Namespace: namespace_efd1ef23
	Checksum: 0x6FA9C9E1
	Offset: 0xEC0
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_ac6d79d2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!self HasAnimTree())
	{
		self useanimtree(-1);
	}
	if(newVal)
	{
		self SetAnim("ai_zm_dlc1_chomper_a_demongate_swarm_locomotion_f_notrans");
	}
}

/*
	Name: function_f763292d
	Namespace: namespace_efd1ef23
	Checksum: 0x8060380D
	Offset: 0xF68
	Size: 0x15B
	Parameters: 7
	Flags: None
*/
function function_f763292d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	if(newVal)
	{
		if(isdefined(self.var_a581816a))
		{
			deletefx(localClientNum, self.var_a581816a, 1);
		}
		self.var_a581816a = PlayFXOnTag(localClientNum, level._effect["demongate_chomper_trail"], self, "tag_fx");
	}
	else if(isdefined(self.var_a581816a))
	{
		deletefx(localClientNum, self.var_a581816a, 0);
		self.var_a581816a = undefined;
	}
	self playsound(0, "zmb_demongate_chomper_disappear");
	PlayFXOnTag(localClientNum, level._effect["demongate_chomper_end"], self, "tag_fx");
	wait(0.4);
	self Hide();
}

/*
	Name: function_ac9c30de
	Namespace: namespace_efd1ef23
	Checksum: 0x95C5F1C
	Offset: 0x10D0
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_ac9c30de(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	if(isdefined(self.var_64b4f506))
	{
		stopfx(localClientNum, self.var_64b4f506);
	}
	self playsound(0, "zmb_demongate_chomper_bite");
	self.var_64b4f506 = playFX(localClientNum, level._effect["demongate_chomper_bite"], self.origin);
	wait(0.1);
	if(isdefined(self.var_64b4f506))
	{
		stopfx(localClientNum, self.var_64b4f506);
	}
}

