#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_genesis_challenges;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_challenges
	Checksum: 0xB5A7F82C
	Offset: 0x228
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_challenges", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_challenges
	Checksum: 0x69AC929C
	Offset: 0x268
	Size: 0x287
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "challenge1state", 15000, 2, "int", &function_4ff59189, 0, 0);
	clientfield::register("toplayer", "challenge2state", 15000, 2, "int", &function_4ff59189, 0, 0);
	clientfield::register("toplayer", "challenge3state", 15000, 2, "int", &function_4ff59189, 0, 0);
	clientfield::register("toplayer", "challenge_board_eyes", 15000, 1, "int", &function_1664174d, 0, 0);
	clientfield::register("scriptmover", "challenge_board_base", 15000, 1, "int", &function_aae53847, 0, 0);
	clientfield::register("scriptmover", "challenge_board_reward", 15000, 1, "int", &function_2494cf3d, 0, 0);
	level.a_s_skull = [];
	for(x = 0; x < 4; x++)
	{
		str_name = "challenge_board_" + x;
		if(!isdefined(level.a_s_skull))
		{
			level.a_s_skull = [];
		}
		else if(!IsArray(level.a_s_skull))
		{
			level.a_s_skull = Array(level.a_s_skull);
		}
		level.a_s_skull[level.a_s_skull.size] = struct::get(str_name);
	}
}

/*
	Name: function_4ff59189
	Namespace: zm_genesis_challenges
	Checksum: 0x104BA44A
	Offset: 0x4F8
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function function_4ff59189(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(IsSpectating(localClientNum))
	{
		return;
	}
	var_42bfa7b6 = GetUIModel(GetUIModelForController(localClientNum), "trialWidget." + fieldName);
	if(isdefined(var_42bfa7b6))
	{
		SetUIModelValue(var_42bfa7b6, newVal);
	}
}

/*
	Name: function_1664174d
	Namespace: zm_genesis_challenges
	Checksum: 0xD57104C8
	Offset: 0x5C0
	Size: 0x225
	Parameters: 7
	Flags: None
*/
function function_1664174d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_a879fa43 = self GetEntityNumber();
	str_name = "challenge_board_" + var_a879fa43;
	s_skull = struct::get(str_name, "targetname");
	foreach(s_skull in level.a_s_skull)
	{
		if(!isdefined(s_skull.var_90369c89))
		{
			s_skull.var_90369c89 = [];
		}
		if(s_skull.script_int == self GetEntityNumber())
		{
			if(!isdefined(s_skull.var_90369c89[localClientNum]))
			{
				s_skull.var_90369c89[localClientNum] = playFX(localClientNum, level._effect["skull_eyes"], s_skull.origin, AnglesToForward(s_skull.angles));
			}
			continue;
		}
		if(isdefined(s_skull.var_90369c89[localClientNum]))
		{
			deletefx(localClientNum, s_skull.var_90369c89[localClientNum]);
			s_skull.var_90369c89[localClientNum] = undefined;
		}
	}
}

/*
	Name: function_aae53847
	Namespace: zm_genesis_challenges
	Checksum: 0x5C046E5B
	Offset: 0x7F0
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_aae53847(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayFXOnTag(localClientNum, level._effect["challenge_base"], self, "tag_fx_box_base");
}

/*
	Name: function_2494cf3d
	Namespace: zm_genesis_challenges
	Checksum: 0x5A0CD566
	Offset: 0x868
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function function_2494cf3d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(!isdefined(self.n_fx_id))
		{
			self.n_fx_id = PlayFXOnTag(localClientNum, level._effect["challenge_reward"], self, "tag_fx_box_base");
		}
	}
	else if(isdefined(self.n_fx_id))
	{
		stopfx(localClientNum, self.n_fx_id);
	}
}

