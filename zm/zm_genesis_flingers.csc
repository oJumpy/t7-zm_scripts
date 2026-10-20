#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\postfx_shared;

#namespace zm_genesis_flingers;

/*
	Name: main
	Namespace: zm_genesis_flingers
	Checksum: 0xC6C2070C
	Offset: 0x3D8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function main()
{
	register_clientfields();
	level thread function_4208db02();
}

/*
	Name: register_clientfields
	Namespace: zm_genesis_flingers
	Checksum: 0x66D4FC8B
	Offset: 0x410
	Size: 0x1FB
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("toplayer", "flinger_flying_postfx", 15000, 1, "int", &flinger_flying_postfx, 0, 0);
	clientfield::register("toplayer", "flinger_land_smash", 15000, 1, "counter", &flinger_land_smash, 0, 0);
	clientfield::register("toplayer", "flinger_cooldown_start", 15000, 4, "int", &flinger_cooldown_start, 0, 0);
	clientfield::register("toplayer", "flinger_cooldown_end", 15000, 4, "int", &flinger_cooldown_end, 0, 0);
	clientfield::register("scriptmover", "player_visibility", 15000, 1, "int", &player_visibility_callback, 0, 0);
	clientfield::register("scriptmover", "flinger_launch_fx", 15000, 1, "counter", &flinger_launch_callback, 0, 0);
	clientfield::register("scriptmover", "flinger_pad_active_fx", 15000, 4, "int", &flinger_pad_active_fx, 0, 0);
}

/*
	Name: flinger_flying_postfx
	Namespace: zm_genesis_flingers
	Checksum: 0x4C265362
	Offset: 0x618
	Size: 0x15B
	Parameters: 7
	Flags: None
*/
function flinger_flying_postfx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.var_6f6f69f0 = PlayFXOnTag(localClientNum, level._effect["flinger_trail"], self, "tag_origin");
		self.var_bb0de733 = self PlayLoopSound("zmb_fling_windwhoosh_2d");
		self thread postfx::playPostfxBundle("pstfx_zm_screen_warp");
	}
	else if(isdefined(self.var_6f6f69f0))
	{
		deletefx(localClientNum, self.var_6f6f69f0, 1);
		self.var_6f6f69f0 = undefined;
	}
	if(isdefined(self.var_bb0de733))
	{
		self StopLoopSound(self.var_bb0de733, 0.75);
		self.var_bb0de733 = undefined;
	}
	self thread postfx::exitPostfxBundle();
}

/*
	Name: function_ddcc2bf9
	Namespace: zm_genesis_flingers
	Checksum: 0x9624BF55
	Offset: 0x780
	Size: 0xC3
	Parameters: 2
	Flags: None
*/
function function_ddcc2bf9(localClientNum, var_bfcf4a2a)
{
	if(!self hasdobj(localClientNum))
	{
		return;
	}
	if(var_bfcf4a2a == 1)
	{
		self HidePart(localClientNum, "tag_blue");
		self ShowPart(localClientNum, "tag_red");
	}
	else
	{
		self HidePart(localClientNum, "tag_red");
		self ShowPart(localClientNum, "tag_blue");
	}
}

/*
	Name: flinger_pad_active_fx
	Namespace: zm_genesis_flingers
	Checksum: 0x2CFEB18C
	Offset: 0x850
	Size: 0xF3
	Parameters: 7
	Flags: None
*/
function flinger_pad_active_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal > 0)
	{
		var_1143aa58 = GetEnt(localClientNum, level.var_5646965[newVal]["pad"], "targetname");
		var_1143aa58 thread function_ddcc2bf9(localClientNum, 0);
		exploder::stop_exploder(level.var_5646965[newVal]["cooldown"]);
		exploder::exploder(level.var_5646965[newVal]["ready"]);
	}
}

/*
	Name: flinger_land_smash
	Namespace: zm_genesis_flingers
	Checksum: 0x6D03CAB9
	Offset: 0x950
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function flinger_land_smash(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level notify("hash_92663c14");
	PlayFXOnTag(localClientNum, level._effect["flinger_land"], self, "tag_origin");
}

/*
	Name: flinger_cooldown_start
	Namespace: zm_genesis_flingers
	Checksum: 0xE0045620
	Offset: 0x9D8
	Size: 0x1C3
	Parameters: 7
	Flags: None
*/
function flinger_cooldown_start(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal > 0)
	{
		var_1143aa58 = GetEnt(localClientNum, level.var_5646965[newVal]["pad"], "targetname");
		var_1143aa58 thread function_ddcc2bf9(localClientNum, 1);
		exploder::stop_exploder(level.var_5646965[newVal]["ready"]);
		exploder::exploder(level.var_5646965[newVal]["cooldown"]);
		var_32149294 = level.var_5646965[newVal]["landpad"];
		var_f201110a = GetEnt(localClientNum, level.var_5646965[var_32149294]["pad"], "targetname");
		var_f201110a thread function_ddcc2bf9(localClientNum, 1);
		exploder::stop_exploder(level.var_5646965[var_32149294]["ready"]);
		exploder::exploder(level.var_5646965[var_32149294]["cooldown"]);
	}
}

/*
	Name: flinger_cooldown_end
	Namespace: zm_genesis_flingers
	Checksum: 0x1087EBD4
	Offset: 0xBA8
	Size: 0x1C3
	Parameters: 7
	Flags: None
*/
function flinger_cooldown_end(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal > 0)
	{
		var_1143aa58 = GetEnt(localClientNum, level.var_5646965[newVal]["pad"], "targetname");
		var_1143aa58 thread function_ddcc2bf9(localClientNum, 0);
		exploder::stop_exploder(level.var_5646965[newVal]["cooldown"]);
		exploder::exploder(level.var_5646965[newVal]["ready"]);
		var_32149294 = level.var_5646965[newVal]["landpad"];
		var_f201110a = GetEnt(localClientNum, level.var_5646965[var_32149294]["pad"], "targetname");
		var_f201110a thread function_ddcc2bf9(localClientNum, 0);
		exploder::stop_exploder(level.var_5646965[var_32149294]["cooldown"]);
		exploder::exploder(level.var_5646965[var_32149294]["ready"]);
	}
}

/*
	Name: flinger_launch_callback
	Namespace: zm_genesis_flingers
	Checksum: 0x42417813
	Offset: 0xD78
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function flinger_launch_callback(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayFXOnTag(localClientNum, level._effect["flinger_launch"], self, "tag_origin");
}

/*
	Name: function_4208db02
	Namespace: zm_genesis_flingers
	Checksum: 0x49841DCD
	Offset: 0xDF0
	Size: 0x473
	Parameters: 0
	Flags: None
*/
function function_4208db02()
{
	level.var_5646965 = [];
	level.var_5646965[1] = [];
	level.var_5646965[2] = [];
	level.var_5646965[3] = [];
	level.var_5646965[4] = [];
	level.var_5646965[5] = [];
	level.var_5646965[6] = [];
	level.var_5646965[7] = [];
	level.var_5646965[8] = [];
	level.var_5646965[1]["ready"] = "fxexp_150";
	level.var_5646965[1]["cooldown"] = "fxexp_350";
	level.var_5646965[1]["pad"] = "upper_courtyard_flinger_base7";
	level.var_5646965[1]["landpad"] = 8;
	level.var_5646965[2]["ready"] = "fxexp_151";
	level.var_5646965[2]["cooldown"] = "fxexp_351";
	level.var_5646965[2]["pad"] = "upper_courtyard_flinger_base12";
	level.var_5646965[2]["landpad"] = 3;
	level.var_5646965[3]["ready"] = "fxexp_152";
	level.var_5646965[3]["cooldown"] = "fxexp_352";
	level.var_5646965[3]["pad"] = "upper_courtyard_flinger_base11";
	level.var_5646965[3]["landpad"] = 2;
	level.var_5646965[4]["ready"] = "fxexp_153";
	level.var_5646965[4]["cooldown"] = "fxexp_353";
	level.var_5646965[4]["pad"] = "upper_courtyard_flinger_base4";
	level.var_5646965[4]["landpad"] = 5;
	level.var_5646965[5]["ready"] = "fxexp_154";
	level.var_5646965[5]["cooldown"] = "fxexp_354";
	level.var_5646965[5]["pad"] = "upper_courtyard_flinger_base3";
	level.var_5646965[5]["landpad"] = 4;
	level.var_5646965[6]["ready"] = "fxexp_155";
	level.var_5646965[6]["cooldown"] = "fxexp_355";
	level.var_5646965[6]["pad"] = "upper_courtyard_flinger_base5";
	level.var_5646965[6]["landpad"] = 7;
	level.var_5646965[7]["ready"] = "fxexp_156";
	level.var_5646965[7]["cooldown"] = "fxexp_356";
	level.var_5646965[7]["pad"] = "upper_courtyard_flinger_base6";
	level.var_5646965[7]["landpad"] = 6;
	level.var_5646965[8]["ready"] = "fxexp_157";
	level.var_5646965[8]["cooldown"] = "fxexp_357";
	level.var_5646965[8]["pad"] = "upper_courtyard_flinger_base8";
	level.var_5646965[8]["landpad"] = 1;
}

/*
	Name: player_visibility_callback
	Namespace: zm_genesis_flingers
	Checksum: 0x7FDD1481
	Offset: 0x1270
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function player_visibility_callback(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(self.owner == GetLocalPlayer(localClientNum))
		{
			self thread function_7bd5b92f(localClientNum);
		}
	}
}

/*
	Name: function_7bd5b92f
	Namespace: zm_genesis_flingers
	Checksum: 0x887ED4AC
	Offset: 0x1300
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function function_7bd5b92f(localClientNum)
{
	player = GetLocalPlayer(localClientNum);
	if(isdefined(player))
	{
		if(IsThirdPerson(localClientNum))
		{
			self show();
			player Hide();
		}
		else
		{
			self Hide();
		}
	}
}

