#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;

#namespace namespace_f7d4f63b;

/*
	Name: init
	Namespace: namespace_f7d4f63b
	Checksum: 0xA54E5072
	Offset: 0x1B0
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("scriptmover", "show_part", 9000, 1, "int", &play_glow_piece_fx, 0, 0);
	clientfield::register("actor", "zombie_splash", 9000, 1, "int", &zombie_splash_fx, 0, 0);
	clientfield::register("world", "lower_pap_water", 9000, 2, "int", &lower_pap_water, 0, 0);
}

/*
	Name: play_glow_piece_fx
	Namespace: namespace_f7d4f63b
	Checksum: 0xA569E8B2
	Offset: 0x298
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function play_glow_piece_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayFXOnTag(localClientNum, level._effect["glow_piece"], self, "tag_origin");
}

/*
	Name: zombie_splash_fx
	Namespace: namespace_f7d4f63b
	Checksum: 0x4533EEC
	Offset: 0x310
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function zombie_splash_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	playFX(localClientNum, level._effect["water_splash"], self.origin + VectorScale((0, 0, -1), 48));
}

/*
	Name: lower_pap_water
	Namespace: namespace_f7d4f63b
	Checksum: 0x37068F87
	Offset: 0x398
	Size: 0xDB
	Parameters: 7
	Flags: None
*/
function lower_pap_water(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		level thread function_cc69986f(-432, 22, 3);
	}
	else if(newVal == 2)
	{
		level thread function_cc69986f(-454, 22, 3);
	}
	else if(newVal == 3)
	{
		level thread function_cc69986f(-476, 22, 3);
	}
}

/*
	Name: function_cc69986f
	Namespace: namespace_f7d4f63b
	Checksum: 0x787062FD
	Offset: 0x480
	Size: 0xE3
	Parameters: 3
	Flags: None
*/
function function_cc69986f(n_curr, var_e1344a83, n_time)
{
	n_end = n_curr - var_e1344a83;
	n_increments = 187.5;
	n_delta = var_e1344a83 / n_increments;
	var_c0b3756a = n_curr;
	while(var_c0b3756a >= n_end)
	{
		var_c0b3756a = var_c0b3756a - n_delta;
		setwavewaterheight("bunker_pap_room_water", var_c0b3756a);
		wait(0.016);
	}
	if(var_c0b3756a < n_end)
	{
		setwavewaterheight("bunker_pap_room_water", n_end);
	}
}

