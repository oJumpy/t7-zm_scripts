#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;

#namespace zm_genesis_shadowman;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_shadowman
	Checksum: 0x80F065F8
	Offset: 0x378
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_shadowman", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_shadowman
	Checksum: 0x4C0B4543
	Offset: 0x3B8
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "shadowman_fx", 15000, 3, "int", &shadowman_fx, 0, 0);
}

/*
	Name: shadowman_fx
	Namespace: zm_genesis_shadowman
	Checksum: 0xFB9D61A5
	Offset: 0x410
	Size: 0x3D9
	Parameters: 7
	Flags: None
*/
function shadowman_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.var_6067fcbe))
	{
		stopfx(localClientNum, self.var_6067fcbe);
	}
	if(isdefined(self.var_8eb9fdc0))
	{
		stopfx(localClientNum, self.var_8eb9fdc0);
	}
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	switch(newVal)
	{
		case 1:
		{
			PlayFXOnTag(localClientNum, level._effect["shadowman_teleport"], self, "j_spinelower");
			self.var_8741354e = PlayFXOnTag(localClientNum, level._effect["shadowman_light"], self, "j_spineupper");
			self.vfx_smoke = PlayFXOnTag(localClientNum, level._effect["shadowman_smoke"], self, "tag_origin");
			break;
		}
		case 2:
		{
			if(isdefined(self.var_8741354e))
			{
				stopfx(localClientNum, self.var_8741354e);
			}
			if(isdefined(self.vfx_smoke))
			{
				stopfx(localClientNum, self.vfx_smoke);
			}
			var_87c8152d = level clientfield::get("circle_challenge_identity");
			if(isdefined(self.var_b0063e15) && var_87c8152d === 4)
			{
				KillFX(localClientNum, self.var_b0063e15);
			}
			v_origin = self GetTagOrigin("j_spinelower");
			level thread function_705b696b(localClientNum, level._effect["shadowman_teleport"], v_origin, 2);
			level thread function_705b696b(localClientNum, level._effect["shadowman_smoke"], v_origin, 2);
			break;
		}
		case 3:
		{
			self.var_6067fcbe = PlayFXOnTag(localClientNum, level._effect["shadowman_hover_charge"], self, "j_spinelower");
			self.var_8eb9fdc0 = PlayFXOnTag(localClientNum, level._effect["shadowman_energy_ball_charge"], self, "tag_weapon_right");
			break;
		}
		case 4:
		{
			self.var_8eb9fdc0 = PlayFXOnTag(localClientNum, level._effect["shadowman_energy_ball"], self, "tag_weapon_right");
			break;
		}
		case 5:
		{
			self.var_8eb9fdc0 = PlayFXOnTag(localClientNum, level._effect["shadowman_energy_ball_explosion"], self, "tag_weapon_right");
			break;
		}
		case 6:
		{
			break;
		}
	}
}

/*
	Name: function_705b696b
	Namespace: zm_genesis_shadowman
	Checksum: 0xF747EB5B
	Offset: 0x7F8
	Size: 0x73
	Parameters: 4
	Flags: None
*/
function function_705b696b(localClientNum, str_fx, v_origin, n_seconds)
{
	fx_id = playFX(localClientNum, str_fx, v_origin);
	wait(n_seconds);
	stopfx(localClientNum, fx_id);
}

