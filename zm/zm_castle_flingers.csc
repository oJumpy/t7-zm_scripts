#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;

#namespace namespace_4fd1ba2a;

/*
	Name: main
	Namespace: namespace_4fd1ba2a
	Checksum: 0xD587833E
	Offset: 0x258
	Size: 0x81
	Parameters: 0
	Flags: None
*/
function main()
{
	register_clientfields();
	level._effect["flinger_launch"] = "dlc1/castle/fx_elec_jumppad";
	level._effect["flinger_land"] = "dlc1/castle/fx_dust_landingpad";
	level._effect["flinger_trail"] = "dlc1/castle/fx_elec_jumppad_player_trail";
	level._effect["landing_pad_glow"] = "dlc1/castle/fx_elec_landingpad_glow";
}

/*
	Name: register_clientfields
	Namespace: namespace_4fd1ba2a
	Checksum: 0xB8529C12
	Offset: 0x2E8
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("toplayer", "flinger_flying_postfx", 1, 1, "int", &function_a1f3f959, 0, 0);
	clientfield::register("toplayer", "flinger_land_smash", 1, 1, "counter", &function_8dcf5001, 0, 0);
	clientfield::register("scriptmover", "player_visibility", 1, 1, "int", &function_a0a5829, 0, 0);
	clientfield::register("scriptmover", "flinger_launch_fx", 1, 1, "counter", &function_3762396c, 0, 0);
	clientfield::register("scriptmover", "flinger_pad_active_fx", 1, 1, "int", &function_7dd4913c, 0, 0);
}

/*
	Name: function_a1f3f959
	Namespace: namespace_4fd1ba2a
	Checksum: 0x1D14EE41
	Offset: 0x460
	Size: 0x15B
	Parameters: 7
	Flags: None
*/
function function_a1f3f959(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
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
	Name: function_7dd4913c
	Namespace: namespace_4fd1ba2a
	Checksum: 0xA4697BCC
	Offset: 0x5C8
	Size: 0xBD
	Parameters: 7
	Flags: None
*/
function function_7dd4913c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.var_c64ddf2c = PlayFXOnTag(localClientNum, level._effect["landing_pad_glow"], self, "tag_origin");
	}
	else if(isdefined(self.var_c64ddf2c))
	{
		deletefx(localClientNum, self.var_c64ddf2c, 1);
		self.var_c64ddf2c = undefined;
	}
}

/*
	Name: function_8dcf5001
	Namespace: namespace_4fd1ba2a
	Checksum: 0x820AB1A5
	Offset: 0x690
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_8dcf5001(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayFXOnTag(localClientNum, level._effect["flinger_land"], self, "tag_origin");
}

/*
	Name: function_3762396c
	Namespace: namespace_4fd1ba2a
	Checksum: 0xAB67D2D3
	Offset: 0x708
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_3762396c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayFXOnTag(localClientNum, level._effect["flinger_launch"], self, "tag_origin");
}

/*
	Name: function_a0a5829
	Namespace: namespace_4fd1ba2a
	Checksum: 0x1A25C659
	Offset: 0x780
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function function_a0a5829(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
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
	Namespace: namespace_4fd1ba2a
	Checksum: 0xB55A6AA8
	Offset: 0x810
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

