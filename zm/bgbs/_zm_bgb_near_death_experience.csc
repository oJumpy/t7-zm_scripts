#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_near_death_experience;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xAD32B558
	Offset: 0x220
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_near_death_experience", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xA21B77B
	Offset: 0x260
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	clientfield::register("allplayers", "zm_bgb_near_death_experience_3p_fx", 15000, 1, "int", &function_24480126, 0, 0);
	clientfield::register("toplayer", "zm_bgb_near_death_experience_1p_fx", 15000, 1, "int", &function_11972f24, 0, 1);
	bgb::register("zm_bgb_near_death_experience", "rounds");
	level.var_3b53e98b = [];
}

/*
	Name: function_24480126
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xF9B89D2F
	Offset: 0x340
	Size: 0x127
	Parameters: 7
	Flags: None
*/
function function_24480126(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_b84b5692 = GetLocalPlayer(localClientNum);
	if(newVal)
	{
		if(var_b84b5692 != self)
		{
			if(!isdefined(self.var_6b39dbae))
			{
				self.var_6b39dbae = [];
			}
			if(isdefined(self.var_6b39dbae[localClientNum]))
			{
				return;
			}
			self.var_6b39dbae[localClientNum] = PlayFXOnTag(localClientNum, "zombie/fx_bgb_near_death_3p", self, "j_spine4");
		}
	}
	else if(isdefined(self.var_6b39dbae) && isdefined(self.var_6b39dbae[localClientNum]))
	{
		stopfx(localClientNum, self.var_6b39dbae[localClientNum]);
		self.var_6b39dbae[localClientNum] = undefined;
	}
}

/*
	Name: function_11972f24
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xC232C717
	Offset: 0x470
	Size: 0xF7
	Parameters: 7
	Flags: None
*/
function function_11972f24(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(isdefined(level.var_3b53e98b[localClientNum]))
		{
			deletefx(localClientNum, level.var_3b53e98b[localClientNum]);
		}
		level.var_3b53e98b[localClientNum] = PlayFXOnCamera(localClientNum, "zombie/fx_bgb_near_death_1p", (0, 0, 0), (1, 0, 0));
	}
	else if(isdefined(level.var_3b53e98b[localClientNum]))
	{
		stopfx(localClientNum, level.var_3b53e98b[localClientNum]);
		level.var_3b53e98b[localClientNum] = undefined;
	}
}

