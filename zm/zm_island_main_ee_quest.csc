#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;

#namespace namespace_78528370;

/*
	Name: function_30d4f164
	Namespace: namespace_78528370
	Checksum: 0xF0FB6C74
	Offset: 0x3B0
	Size: 0x253
	Parameters: 0
	Flags: None
*/
function function_30d4f164()
{
	clientfield::register("vehicle", "plane_hit_by_aa_gun", 9000, 1, "int", &function_3b831537, 0, 0);
	clientfield::register("scriptmover", "zipline_lightning_fx", 9000, 1, "int", &function_bd9975bc, 0, 0);
	clientfield::register("allplayers", "lightning_shield_fx", 9000, 1, "int", &function_ac5c6f58, 1, 1);
	clientfield::register("scriptmover", "smoke_trail_fx", 9000, 1, "int", &function_65a49466, 0, 0);
	clientfield::register("scriptmover", "smoke_smolder_fx", 9000, 1, "int", &function_67a61c, 0, 0);
	clientfield::register("zbarrier", "bgb_lightning_fx", 9000, 1, "int", &function_4a5ead3a, 0, 0);
	clientfield::register("scriptmover", "perk_lightning_fx", 9000, GetMinBitCountForNum(6), "int", &function_46605813, 0, 0);
	clientfield::register("world", "umbra_tome_outro_igc", 9000, 1, "int", &function_b87c4724, 0, 0);
}

/*
	Name: function_f0e89ab2
	Namespace: namespace_78528370
	Checksum: 0x11DDCA99
	Offset: 0x610
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_f0e89ab2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayFXOnTag(localClientNum, level._effect["glow_formula_piece"], self, "j_spineupper");
}

/*
	Name: function_e9572f40
	Namespace: namespace_78528370
	Checksum: 0xD3E5A533
	Offset: 0x688
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_e9572f40(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayFXOnTag(localClientNum, level._effect["glow_formula_piece"], self, "j_spineupper");
}

/*
	Name: function_3b831537
	Namespace: namespace_78528370
	Checksum: 0x643C761C
	Offset: 0x700
	Size: 0x11B
	Parameters: 7
	Flags: None
*/
function function_3b831537(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.var_563d869a = PlayFXOnTag(localClientNum, level._effect["bomber_explode"], self, "tag_engine_inner_left");
		wait(1);
		self.var_303b0c31 = PlayFXOnTag(localClientNum, level._effect["bomber_fire_trail"], self, "tag_engine_inner_right");
	}
	else if(isdefined(self.var_563d869a))
	{
		deletefx(localClientNum, self.var_a1d64192);
	}
	if(isdefined(self.var_303b0c31))
	{
		deletefx(localClientNum, self.var_a1d64192);
	}
}

/*
	Name: function_bd9975bc
	Namespace: namespace_78528370
	Checksum: 0xF78E26AE
	Offset: 0x828
	Size: 0x103
	Parameters: 7
	Flags: None
*/
function function_bd9975bc(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.var_1f5ac1dc[localClientNum] = PlayFXOnTag(localClientNum, level._effect["lightning_shield_control_panel"], self, "tag_origin");
	}
	else if(isdefined(self.var_1f5ac1dc))
	{
		a_keys = getArrayKeys(self.var_1f5ac1dc);
		if(IsInArray(a_keys, localClientNum))
		{
			deletefx(localClientNum, self.var_1f5ac1dc[localClientNum], 0);
		}
	}
}

/*
	Name: function_ac5c6f58
	Namespace: namespace_78528370
	Checksum: 0xEA003B22
	Offset: 0x938
	Size: 0x277
	Parameters: 7
	Flags: None
*/
function function_ac5c6f58(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	player = GetLocalPlayer(localClientNum);
	var_ae6a34c0 = player getlocalclientnumber();
	if(newVal == 1)
	{
		self.var_257ef9e4 = [];
		self.var_42ad0d0c = [];
		if(!IsSpectating(localClientNum))
		{
			if(player === self)
			{
				self.var_ac5c6f58 = PlayViewmodelFX(localClientNum, level._effect["lightning_shield_1p"], "tag_shield_lightning_fx");
			}
			else
			{
				self.var_42ad0d0c[var_ae6a34c0] = undefined;
				self.var_257ef9e4[var_ae6a34c0] = PlayFXOnTag(var_ae6a34c0, level._effect["lightning_shield_3p"], self, "tag_shield_lightning_fx");
			}
			self thread function_7ddd182c(localClientNum);
		}
	}
	else
	{
		self notify("hash_1a229bcb");
		if(!IsSpectating(localClientNum))
		{
			if(player === self)
			{
				if(isdefined(self.var_ac5c6f58))
				{
					deletefx(localClientNum, self.var_ac5c6f58);
					self.var_ac5c6f58 = undefined;
				}
			}
			else if(isdefined(self.var_257ef9e4) && isdefined(self.var_257ef9e4[var_ae6a34c0]))
			{
				deletefx(var_ae6a34c0, self.var_257ef9e4[var_ae6a34c0]);
				self.var_257ef9e4[var_ae6a34c0] = undefined;
			}
			if(isdefined(self.var_42ad0d0c) && isdefined(self.var_42ad0d0c[var_ae6a34c0]))
			{
				deletefx(var_ae6a34c0, self.var_42ad0d0c[var_ae6a34c0]);
				self.var_42ad0d0c[var_ae6a34c0] = undefined;
			}
		}
	}
}

/*
	Name: function_7ddd182c
	Namespace: namespace_78528370
	Checksum: 0x7A53D024
	Offset: 0xBB8
	Size: 0x2F5
	Parameters: 1
	Flags: None
*/
function function_7ddd182c(localClientNum)
{
	self endon("disconnect");
	self endon("hash_1a229bcb");
	player = GetLocalPlayer(localClientNum);
	var_ae6a34c0 = player getlocalclientnumber();
	while(1)
	{
		self waittill("weapon_change");
		currentWeapon = GetCurrentWeapon(localClientNum);
		if(!IsSpectating(localClientNum))
		{
			if(isdefined(currentWeapon.isRiotShield) && currentWeapon.isRiotShield)
			{
				if(player === self)
				{
					if(!isdefined(self.var_ac5c6f58))
					{
						self.var_ac5c6f58 = PlayViewmodelFX(localClientNum, level._effect["lightning_shield_1p"], "tag_shield_lightning_fx");
					}
				}
				else if(isdefined(self.var_42ad0d0c) && isdefined(self.var_42ad0d0c[var_ae6a34c0]))
				{
					deletefx(var_ae6a34c0, self.var_42ad0d0c[var_ae6a34c0]);
					self.var_42ad0d0c[var_ae6a34c0] = undefined;
				}
				var_68b2abba = self.var_257ef9e4[var_ae6a34c0];
				if(!isdefined(var_68b2abba))
				{
					self.var_257ef9e4[var_ae6a34c0] = PlayFXOnTag(var_ae6a34c0, level._effect["lightning_shield_3p"], self, "tag_shield_lightning_fx");
				}
			}
			else if(!IsSpectating(localClientNum))
			{
				if(player === self)
				{
					if(isdefined(self.var_ac5c6f58))
					{
						deletefx(localClientNum, self.var_ac5c6f58);
						self.var_ac5c6f58 = undefined;
					}
				}
				else if(isdefined(self.var_257ef9e4) && isdefined(self.var_257ef9e4[var_ae6a34c0]))
				{
					deletefx(var_ae6a34c0, self.var_257ef9e4[var_ae6a34c0]);
					self.var_257ef9e4[var_ae6a34c0] = undefined;
				}
				var_14c202b4 = self.var_42ad0d0c[var_ae6a34c0];
				if(!isdefined(var_14c202b4))
				{
					self.var_42ad0d0c[var_ae6a34c0] = PlayFXOnTag(var_ae6a34c0, level._effect["lightning_shield_3p"], self, "tag_shield_lightning_fx");
				}
			}
		}
	}
}

/*
	Name: function_65a49466
	Namespace: namespace_78528370
	Checksum: 0xDD1CCF0
	Offset: 0xEB8
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function function_65a49466(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.var_43991df3 = PlayFXOnTag(localClientNum, level._effect["gear_smoke_trail"], self, "tag_origin");
	}
	else if(isdefined(self.var_43991df3))
	{
		stopfx(localClientNum, self.var_43991df3);
	}
}

/*
	Name: function_67a61c
	Namespace: namespace_78528370
	Checksum: 0xEAE35C42
	Offset: 0xF78
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function function_67a61c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.var_e05c9faa = PlayFXOnTag(localClientNum, level._effect["gear_smoke_smolder"], self, "tag_origin");
	}
	else if(isdefined(self.var_e05c9faa))
	{
		stopfx(localClientNum, self.var_e05c9faa);
	}
}

/*
	Name: function_46605813
	Namespace: namespace_78528370
	Checksum: 0xBD7D6777
	Offset: 0x1038
	Size: 0x235
	Parameters: 7
	Flags: None
*/
function function_46605813(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 0:
		{
			if(isdefined(self.var_99de3d90))
			{
				stopfx(localClientNum, self.var_99de3d90);
			}
			break;
		}
		case 1:
		{
			self.var_99de3d90 = PlayFXOnTag(localClientNum, level._effect["perk_lightning_fx_dbltap"], self, "tag_origin");
			break;
		}
		case 2:
		{
			self.var_99de3d90 = PlayFXOnTag(localClientNum, level._effect["perk_lightning_fx_jugg"], self, "tag_origin");
			break;
		}
		case 3:
		{
			self.var_99de3d90 = PlayFXOnTag(localClientNum, level._effect["perk_lightning_fx_revive"], self, "tag_origin");
			break;
		}
		case 4:
		{
			self.var_99de3d90 = PlayFXOnTag(localClientNum, level._effect["perk_lightning_fx_speed"], self, "tag_origin");
			break;
		}
		case 5:
		{
			self.var_99de3d90 = PlayFXOnTag(localClientNum, level._effect["perk_lightning_fx_staminup"], self, "tag_origin");
			break;
		}
		case 6:
		{
			self.var_99de3d90 = PlayFXOnTag(localClientNum, level._effect["perk_lightning_fx_mulekick"], self, "tag_origin");
			break;
		}
	}
}

/*
	Name: function_4a5ead3a
	Namespace: namespace_78528370
	Checksum: 0x5F587176
	Offset: 0x1278
	Size: 0xCB
	Parameters: 7
	Flags: None
*/
function function_4a5ead3a(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.var_543f3d1d = PlayFXOnTag(localClientNum, level._effect["bgb_lightning_fx"], self ZBarrierGetPiece(5), "tag_origin");
	}
	else if(isdefined(self.var_543f3d1d))
	{
		stopfx(localClientNum, self.var_543f3d1d);
	}
}

/*
	Name: function_b87c4724
	Namespace: namespace_78528370
	Checksum: 0x2216789D
	Offset: 0x1350
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function function_b87c4724(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		umbra_settometrigger(localClientNum, "bunker_armory_tome");
	}
}

