#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace warlord;

/*
	Name: __init__sytem__
	Namespace: warlord
	Checksum: 0xBAC6971B
	Offset: 0x3C0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("warlord", &__init__, undefined, undefined);
}

/*
	Name: Precache
	Namespace: warlord
	Checksum: 0x6AB4E328
	Offset: 0x400
	Size: 0xE1
	Parameters: 0
	Flags: AutoExec
*/
function autoexec Precache()
{
	level._effect["fx_elec_warlord_damage_1"] = "electric/fx_elec_warlord_damage_1";
	level._effect["fx_elec_warlord_damage_2"] = "electric/fx_elec_warlord_damage_2";
	level._effect["fx_elec_warlord_lower_damage_1"] = "electric/fx_elec_warlord_lower_damage_1";
	level._effect["fx_elec_warlord_lower_damage_2"] = "electric/fx_elec_warlord_lower_damage_2";
	level._effect["fx_exp_warlord_death"] = "explosions/fx_exp_warlord_death";
	level._effect["fx_exhaust_jetpack_warlord_juke"] = "vehicle/fx_exhaust_jetpack_warlord_juke";
	level._effect["fx_light_eye_glow_warlord"] = "light/fx_light_eye_glow_warlord";
	level._effect["fx_light_body_glow_warlord"] = "light/fx_light_body_glow_warlord";
}

/*
	Name: __init__
	Namespace: warlord
	Checksum: 0x64A4DEB8
	Offset: 0x4F0
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(ai::shouldRegisterClientFieldForArchetype("warlord"))
	{
		clientfield::register("actor", "warlord_type", 1, 2, "int", &WarlordClientUtils::warlordTypeHandler, 0, 0);
		clientfield::register("actor", "warlord_damage_state", 1, 2, "int", &WarlordClientUtils::warlordDamageStateHandler, 0, 0);
		clientfield::register("actor", "warlord_thruster_direction", 1, 3, "int", &WarlordClientUtils::warlordThrusterHandler, 0, 0);
		clientfield::register("actor", "warlord_lights_state", 1, 1, "int", &WarlordClientUtils::warlordLightsHandler, 0, 0);
	}
}

#namespace WarlordClientUtils;

/*
	Name: warlordDamageStateHandler
	Namespace: WarlordClientUtils
	Checksum: 0xE0444911
	Offset: 0x638
	Size: 0x22D
	Parameters: 7
	Flags: None
*/
function warlordDamageStateHandler(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	if(isdefined(entity.var_4154355f))
	{
		stopfx(localClientNum, entity.var_4154355f);
		entity.var_4154355f = undefined;
	}
	if(isdefined(entity.var_c57c11b8))
	{
		stopfx(localClientNum, entity.var_c57c11b8);
		entity.var_c57c11b8 = undefined;
	}
	switch(newValue)
	{
		case 0:
		{
			break;
		}
		case 2:
		{
			entity.var_c57c11b8 = PlayFXOnTag(localClientNum, level._effect["fx_elec_warlord_damage_2"], entity, "j_spine4");
			PlayFXOnTag(localClientNum, level._effect["fx_elec_warlord_lower_damage_2"], entity, "j_mainroot");
		}
		case 1:
		{
			entity.var_4154355f = PlayFXOnTag(localClientNum, level._effect["fx_elec_warlord_damage_1"], entity, "j_spine4");
			PlayFXOnTag(localClientNum, level._effect["fx_elec_warlord_lower_damage_1"], entity, "j_mainroot");
			break;
		}
		case 3:
		{
			PlayFXOnTag(localClientNum, level._effect["fx_exp_warlord_death"], entity, "j_spine4");
			break;
		}
	}
}

/*
	Name: warlordTypeHandler
	Namespace: WarlordClientUtils
	Checksum: 0x6AF2E411
	Offset: 0x870
	Size: 0x5F
	Parameters: 7
	Flags: None
*/
function warlordTypeHandler(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	entity.var_e69b4288 = newValue;
}

/*
	Name: warlordThrusterHandler
	Namespace: WarlordClientUtils
	Checksum: 0xF139463B
	Offset: 0x8D8
	Size: 0x25B
	Parameters: 7
	Flags: None
*/
function warlordThrusterHandler(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	if(isdefined(entity.var_a8d008e0))
	{
		/#
			Assert(IsArray(entity.var_a8d008e0));
		#/
		for(index = 0; index < entity.var_a8d008e0.size; index++)
		{
			stopfx(localClientNum, entity.var_a8d008e0[index]);
		}
	}
	entity.var_a8d008e0 = [];
	tags = [];
	switch(newValue)
	{
		case 0:
		{
			break;
		}
		case 1:
		{
			tags = Array("tag_jets_left_front", "tag_jets_right_front");
			break;
		}
		case 2:
		{
			tags = Array("tag_jets_left_back", "tag_jets_right_back");
			break;
		}
		case 3:
		{
			tags = Array("tag_jets_left_side");
			break;
		}
		case 4:
		{
			tags = Array("tag_jets_right_side");
			break;
		}
	}
	for(index = 0; index < tags.size; index++)
	{
		entity.var_a8d008e0[entity.var_a8d008e0.size] = PlayFXOnTag(localClientNum, level._effect["fx_exhaust_jetpack_warlord_juke"], entity, tags[index]);
	}
}

/*
	Name: warlordLightsHandler
	Namespace: WarlordClientUtils
	Checksum: 0xBF029161
	Offset: 0xB40
	Size: 0xC3
	Parameters: 7
	Flags: None
*/
function warlordLightsHandler(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	if(newValue == 1)
	{
		PlayFXOnTag(localClientNum, level._effect["fx_light_eye_glow_warlord"], entity, "tag_eye");
		PlayFXOnTag(localClientNum, level._effect["fx_light_body_glow_warlord"], entity, "j_spine4");
	}
}

