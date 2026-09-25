#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_filter;

#namespace namespace_bbfc4da3;

/*
	Name: init
	Namespace: namespace_bbfc4da3
	Checksum: 0x6FF34A8A
	Offset: 0x3C8
	Size: 0x3CB
	Parameters: 0
	Flags: None
*/
function init()
{
	var_850da4c5 = GetMinBitCountForNum(4);
	clientfield::register("world", "pillar_challenge_0_1", 9000, var_850da4c5, "int", &function_bb9aac12, 0, 0);
	clientfield::register("world", "pillar_challenge_0_2", 9000, var_850da4c5, "int", &function_959831a9, 0, 0);
	clientfield::register("world", "pillar_challenge_0_3", 9000, var_850da4c5, "int", &function_6f95b740, 0, 0);
	clientfield::register("world", "pillar_challenge_1_1", 9000, var_850da4c5, "int", &function_6f81a273, 0, 0);
	clientfield::register("world", "pillar_challenge_1_2", 9000, var_850da4c5, "int", &function_fd7a3338, 0, 0);
	clientfield::register("world", "pillar_challenge_1_3", 9000, var_850da4c5, "int", &function_237cada1, 0, 0);
	clientfield::register("world", "pillar_challenge_2_1", 9000, var_850da4c5, "int", &function_4f007cd4, 0, 0);
	clientfield::register("world", "pillar_challenge_2_2", 9000, var_850da4c5, "int", &function_c107ec0f, 0, 0);
	clientfield::register("world", "pillar_challenge_2_3", 9000, var_850da4c5, "int", &function_9b0571a6, 0, 0);
	clientfield::register("world", "pillar_challenge_3_1", 9000, var_850da4c5, "int", &function_8e509935, 0, 0);
	clientfield::register("world", "pillar_challenge_3_2", 9000, var_850da4c5, "int", &function_b453139e, 0, 0);
	clientfield::register("world", "pillar_challenge_3_3", 9000, var_850da4c5, "int", &function_da558e07, 0, 0);
	clientfield::register("scriptmover", "challenge_glow_fx", 9000, 2, "int", &function_7dcb8f25, 0, 0);
}

/*
	Name: function_bb9aac12
	Namespace: namespace_bbfc4da3
	Checksum: 0x4E5F7FDC
	Offset: 0x7A0
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_bb9aac12(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_4c6172ff = GetEnt(localClientNum, "challenge_pillar_0", "targetname");
	var_2ca030e2 = 0;
	player = GetLocalPlayer(localClientNum);
	if(player GetEntityNumber() == 0)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localClientNum, newVal, 1, var_2ca030e2);
}

/*
	Name: function_959831a9
	Namespace: namespace_bbfc4da3
	Checksum: 0xC016F565
	Offset: 0x8A8
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_959831a9(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_4c6172ff = GetEnt(localClientNum, "challenge_pillar_0", "targetname");
	var_2ca030e2 = 0;
	player = GetLocalPlayer(localClientNum);
	if(player GetEntityNumber() == 0)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localClientNum, newVal, 2, var_2ca030e2);
}

/*
	Name: function_6f95b740
	Namespace: namespace_bbfc4da3
	Checksum: 0xF1448737
	Offset: 0x9B0
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_6f95b740(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_4c6172ff = GetEnt(localClientNum, "challenge_pillar_0", "targetname");
	var_2ca030e2 = 0;
	player = GetLocalPlayer(localClientNum);
	if(player GetEntityNumber() == 0)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localClientNum, newVal, 3, var_2ca030e2);
}

/*
	Name: function_6f81a273
	Namespace: namespace_bbfc4da3
	Checksum: 0x8D043E1B
	Offset: 0xAB8
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_6f81a273(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_4c6172ff = GetEnt(localClientNum, "challenge_pillar_1", "targetname");
	var_2ca030e2 = 0;
	player = GetLocalPlayer(localClientNum);
	if(player GetEntityNumber() == 1)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localClientNum, newVal, 1, var_2ca030e2);
}

/*
	Name: function_fd7a3338
	Namespace: namespace_bbfc4da3
	Checksum: 0x67B770FF
	Offset: 0xBC0
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_fd7a3338(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_4c6172ff = GetEnt(localClientNum, "challenge_pillar_1", "targetname");
	var_2ca030e2 = 0;
	player = GetLocalPlayer(localClientNum);
	if(player GetEntityNumber() == 1)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localClientNum, newVal, 2, var_2ca030e2);
}

/*
	Name: function_237cada1
	Namespace: namespace_bbfc4da3
	Checksum: 0xE617369C
	Offset: 0xCC8
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_237cada1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_4c6172ff = GetEnt(localClientNum, "challenge_pillar_1", "targetname");
	var_2ca030e2 = 0;
	player = GetLocalPlayer(localClientNum);
	if(player GetEntityNumber() == 1)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localClientNum, newVal, 3, var_2ca030e2);
}

/*
	Name: function_4f007cd4
	Namespace: namespace_bbfc4da3
	Checksum: 0x75AB2C3B
	Offset: 0xDD0
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_4f007cd4(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_4c6172ff = GetEnt(localClientNum, "challenge_pillar_2", "targetname");
	var_2ca030e2 = 0;
	player = GetLocalPlayer(localClientNum);
	if(player GetEntityNumber() == 2)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localClientNum, newVal, 1, var_2ca030e2);
}

/*
	Name: function_c107ec0f
	Namespace: namespace_bbfc4da3
	Checksum: 0x6C85C18B
	Offset: 0xED8
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_c107ec0f(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_4c6172ff = GetEnt(localClientNum, "challenge_pillar_2", "targetname");
	var_2ca030e2 = 0;
	player = GetLocalPlayer(localClientNum);
	if(player GetEntityNumber() == 2)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localClientNum, newVal, 2, var_2ca030e2);
}

/*
	Name: function_9b0571a6
	Namespace: namespace_bbfc4da3
	Checksum: 0xC4C01CC8
	Offset: 0xFE0
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_9b0571a6(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_4c6172ff = GetEnt(localClientNum, "challenge_pillar_2", "targetname");
	var_2ca030e2 = 0;
	player = GetLocalPlayer(localClientNum);
	if(player GetEntityNumber() == 2)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localClientNum, newVal, 3, var_2ca030e2);
}

/*
	Name: function_8e509935
	Namespace: namespace_bbfc4da3
	Checksum: 0x7277989B
	Offset: 0x10E8
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_8e509935(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_4c6172ff = GetEnt(localClientNum, "challenge_pillar_3", "targetname");
	var_2ca030e2 = 0;
	player = GetLocalPlayer(localClientNum);
	if(player GetEntityNumber() == 3)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localClientNum, newVal, 1, var_2ca030e2);
}

/*
	Name: function_b453139e
	Namespace: namespace_bbfc4da3
	Checksum: 0x513ED6BC
	Offset: 0x11F0
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_b453139e(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_4c6172ff = GetEnt(localClientNum, "challenge_pillar_3", "targetname");
	var_2ca030e2 = 0;
	player = GetLocalPlayer(localClientNum);
	if(player GetEntityNumber() == 3)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localClientNum, newVal, 2, var_2ca030e2);
}

/*
	Name: function_da558e07
	Namespace: namespace_bbfc4da3
	Checksum: 0x5622176D
	Offset: 0x12F8
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_da558e07(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_4c6172ff = GetEnt(localClientNum, "challenge_pillar_3", "targetname");
	var_2ca030e2 = 0;
	player = GetLocalPlayer(localClientNum);
	if(player GetEntityNumber() == 3)
	{
		var_2ca030e2 = 1;
	}
	var_4c6172ff thread function_4aadb052(localClientNum, newVal, 3, var_2ca030e2);
}

/*
	Name: function_4aadb052
	Namespace: namespace_bbfc4da3
	Checksum: 0x9DA02333
	Offset: 0x1400
	Size: 0xED
	Parameters: 4
	Flags: None
*/
function function_4aadb052(localClientNum, newVal, var_15fa438f, var_2ca030e2)
{
	switch(newVal)
	{
		case 1:
		{
			self thread function_4516da29(localClientNum, var_15fa438f);
			break;
		}
		case 2:
		{
			self thread function_2fba808e(localClientNum, var_15fa438f, var_2ca030e2);
			break;
		}
		case 3:
		{
			self thread function_21cf53eb(localClientNum, var_15fa438f, var_2ca030e2);
			break;
		}
		case 4:
		{
			self thread function_72573d3d(localClientNum, var_15fa438f, var_2ca030e2);
			break;
		}
	}
}

/*
	Name: function_4516da29
	Namespace: namespace_bbfc4da3
	Checksum: 0x6098F423
	Offset: 0x14F8
	Size: 0x14B
	Parameters: 2
	Flags: None
*/
function function_4516da29(localClientNum, var_15fa438f)
{
	self util::waittill_dobj(localClientNum);
	self HidePart(localClientNum, "j_player_started_0" + var_15fa438f, "p7_zm_isl_ritual_pillar_symbol");
	self HidePart(localClientNum, "j_player_completed_0" + var_15fa438f, "p7_zm_isl_ritual_pillar_symbol");
	self HidePart(localClientNum, "j_player_claimed_0" + var_15fa438f, "p7_zm_isl_ritual_pillar_symbol");
	self HidePart(localClientNum, "j_ally_started_0" + var_15fa438f, "p7_zm_isl_ritual_pillar_symbol");
	self HidePart(localClientNum, "j_ally_completed_0" + var_15fa438f, "p7_zm_isl_ritual_pillar_symbol");
	self HidePart(localClientNum, "j_ally_claimed_0" + var_15fa438f, "p7_zm_isl_ritual_pillar_symbol");
}

/*
	Name: function_2fba808e
	Namespace: namespace_bbfc4da3
	Checksum: 0xBFAAF255
	Offset: 0x1650
	Size: 0xBB
	Parameters: 3
	Flags: None
*/
function function_2fba808e(localClientNum, var_15fa438f, var_2ca030e2)
{
	self util::waittill_dobj(localClientNum);
	self function_4516da29(localClientNum, var_15fa438f);
	if(var_2ca030e2)
	{
		self ShowPart(localClientNum, "j_player_started_0" + var_15fa438f, "p7_zm_isl_ritual_pillar_symbol");
	}
	else
	{
		self ShowPart(localClientNum, "j_ally_started_0" + var_15fa438f, "p7_zm_isl_ritual_pillar_symbol");
	}
}

/*
	Name: function_21cf53eb
	Namespace: namespace_bbfc4da3
	Checksum: 0xFE92D449
	Offset: 0x1718
	Size: 0xBB
	Parameters: 3
	Flags: None
*/
function function_21cf53eb(localClientNum, var_15fa438f, var_2ca030e2)
{
	self util::waittill_dobj(localClientNum);
	self function_4516da29(localClientNum, var_15fa438f);
	if(var_2ca030e2)
	{
		self ShowPart(localClientNum, "j_player_completed_0" + var_15fa438f, "p7_zm_isl_ritual_pillar_symbol");
	}
	else
	{
		self ShowPart(localClientNum, "j_ally_completed_0" + var_15fa438f, "p7_zm_isl_ritual_pillar_symbol");
	}
}

/*
	Name: function_72573d3d
	Namespace: namespace_bbfc4da3
	Checksum: 0xF5A33374
	Offset: 0x17E0
	Size: 0xBB
	Parameters: 3
	Flags: None
*/
function function_72573d3d(localClientNum, var_15fa438f, var_2ca030e2)
{
	self util::waittill_dobj(localClientNum);
	self function_4516da29(localClientNum, var_15fa438f);
	if(var_2ca030e2)
	{
		self ShowPart(localClientNum, "j_player_claimed_0" + var_15fa438f, "p7_zm_isl_ritual_pillar_symbol");
	}
	else
	{
		self ShowPart(localClientNum, "j_ally_claimed_0" + var_15fa438f, "p7_zm_isl_ritual_pillar_symbol");
	}
}

/*
	Name: function_7dcb8f25
	Namespace: namespace_bbfc4da3
	Checksum: 0x2FD8ABCA
	Offset: 0x18A8
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function function_7dcb8f25(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		PlayFXOnTag(localClientNum, level._effect["powerup_on"], self, "tag_origin");
	}
	if(newVal == 2)
	{
		PlayFXOnTag(localClientNum, level._effect["powerup_on_solo"], self, "tag_origin");
	}
}

