#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#namespace zm_tomb_tank;

/*
	Name: init
	Namespace: zm_tomb_tank
	Checksum: 0xECAC75D
	Offset: 0x2F8
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("vehicle", "tank_tread_fx", 21000, 1, "int", &function_66e53adf, 0, 0);
	clientfield::register("vehicle", "tank_flamethrower_fx", 21000, 2, "int", &function_de8b2ce1, 0, 0);
	clientfield::register("vehicle", "tank_cooldown_fx", 21000, 2, "int", &function_5bc757af, 0, 0);
}

/*
	Name: function_66e53adf
	Namespace: zm_tomb_tank
	Checksum: 0xE4D3786
	Offset: 0x3E0
	Size: 0xC9
	Parameters: 7
	Flags: None
*/
function function_66e53adf(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == oldVal)
	{
		return;
	}
	if(newVal == 1)
	{
		/#
			println("Dev Block strings are not supported");
		#/
		self thread function_b809a3fd(localClientNum);
	}
	else if(newVal == 0)
	{
		/#
			println("Dev Block strings are not supported");
		#/
		self notify("hash_51963593");
	}
}

/*
	Name: function_fec9fe59
	Namespace: zm_tomb_tank
	Checksum: 0x78A6116C
	Offset: 0x4B8
	Size: 0x147
	Parameters: 2
	Flags: None
*/
function function_fec9fe59(localClientNum, str_tag)
{
	self endon("hash_53f5220a");
	sndOrigin = self GetTagOrigin(str_tag);
	sndent = spawn(0, sndOrigin, "script_origin");
	sndent LinkTo(self, str_tag);
	sndent playsound(0, "zmb_tank_flame_start");
	sndent.var_9bdbad77 = sndent PlayLoopSound("zmb_tank_flame_loop", 0.6);
	self thread function_a7df9920(sndent);
	while(1)
	{
		self.var_f53cfaa3 = PlayFXOnTag(localClientNum, level._effect["mech_wpn_flamethrower"], self, str_tag);
		wait(0.1);
	}
}

/*
	Name: function_a7df9920
	Namespace: zm_tomb_tank
	Checksum: 0x66D558C7
	Offset: 0x608
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function function_a7df9920(ent)
{
	self waittill("hash_53f5220a");
	ent playsound(0, "zmb_tank_flame_stop");
	ent StopLoopSound(ent.var_9bdbad77, 0.25);
	wait(1);
	ent delete();
}

/*
	Name: function_de8b2ce1
	Namespace: zm_tomb_tank
	Checksum: 0x4D1FF73A
	Offset: 0x698
	Size: 0x113
	Parameters: 7
	Flags: None
*/
function function_de8b2ce1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self notify("hash_53f5220a");
	if(!isdefined(self.var_1be9b23))
	{
		self.var_1be9b23 = spawn(0, (0, 0, 0), "script_origin");
	}
	if(newVal == 0)
	{
		return;
	}
	str_tag = "tag_flash";
	switch(newVal)
	{
		case 2:
		{
			str_tag = "tag_flash_gunner1";
			break;
		}
		case 3:
		{
			str_tag = "tag_flash_gunner2";
			break;
		}
		case default:
		{
			break;
		}
	}
	self thread function_fec9fe59(localClientNum, str_tag);
}

/*
	Name: function_a2fe7f71
	Namespace: zm_tomb_tank
	Checksum: 0xE2AA29C5
	Offset: 0x7B8
	Size: 0xEF
	Parameters: 2
	Flags: None
*/
function function_a2fe7f71(localClientNum, var_2bc319f0)
{
	self notify("stop_exhaust_fx");
	self endon("entityshutdown");
	self endon("stop_exhaust_fx");
	fx_id = level._effect["tank_exhaust"];
	if(var_2bc319f0)
	{
		fx_id = level._effect["tank_overheat"];
	}
	if(var_2bc319f0)
	{
		self thread function_341f7b4c(self.origin);
		continue;
	}
	self thread function_64744406();
	while(1)
	{
		PlayFXOnTag(localClientNum, fx_id, self, "tag_origin");
		wait(0.1);
	}
}

/*
	Name: function_341f7b4c
	Namespace: zm_tomb_tank
	Checksum: 0x545F15E8
	Offset: 0x8B0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_341f7b4c(origin)
{
	audio::playloopat("zmb_bot_timeout_steam", origin);
	self waittill("stop_exhaust_fx");
	audio::stoploopat("zmb_bot_timeout_steam", origin);
}

/*
	Name: function_64744406
	Namespace: zm_tomb_tank
	Checksum: 0x71E4D048
	Offset: 0x910
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function function_64744406()
{
	origin1 = self GetTagOrigin("tag_exhaust_1");
	ent1 = spawn(0, origin1, "script_origin");
	ent1 LinkTo(self, "tag_exhaust_1");
	origin2 = self GetTagOrigin("tag_exhaust_2");
	ent2 = spawn(0, origin2, "script_origin");
	ent2 LinkTo(self, "tag_exhaust_2");
	ent1 PlayLoopSound("zmb_tank_exhaust_pipe", 1);
	ent2 PlayLoopSound("zmb_tank_exhaust_pipe", 1);
	self waittill("stop_exhaust_fx");
	ent1 delete();
	ent2 delete();
}

/*
	Name: function_5bc757af
	Namespace: zm_tomb_tank
	Checksum: 0x3F97DB39
	Offset: 0xA98
	Size: 0x205
	Parameters: 7
	Flags: None
*/
function function_5bc757af(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self notify("stop_exhaust_fx");
	if(isdefined(self.var_d168dad5))
	{
		stopfx(localClientNum, self.var_d168dad5);
		self.var_d168dad5 = undefined;
	}
	if(isdefined(self.var_f76b553e))
	{
		stopfx(localClientNum, self.var_f76b553e);
		self.var_f76b553e = undefined;
	}
	switch(newVal)
	{
		case 1:
		{
			self thread function_a2fe7f71(localClientNum, 1);
			self.var_d168dad5 = PlayFXOnTag(localClientNum, level._effect["tank_light_red"], self, "tag_light_left");
			self.var_f76b553e = PlayFXOnTag(localClientNum, level._effect["tank_light_red"], self, "tag_light_right");
			break;
		}
		case 2:
		{
			self.var_d168dad5 = PlayFXOnTag(localClientNum, level._effect["tank_light_grn"], self, "tag_light_left");
			self.var_f76b553e = PlayFXOnTag(localClientNum, level._effect["tank_light_grn"], self, "tag_light_right");
			break;
		}
		case 0:
		{
			self thread function_a2fe7f71(localClientNum, 0);
			break;
		}
	}
}

/*
	Name: function_b809a3fd
	Namespace: zm_tomb_tank
	Checksum: 0x9B0ED436
	Offset: 0xCA8
	Size: 0xAF
	Parameters: 1
	Flags: None
*/
function function_b809a3fd(localClientNum)
{
	self endon("hash_51963593");
	self thread function_85886bc2();
	while(1)
	{
		self.var_f39aab64 = PlayFXOnTag(localClientNum, level._effect["tank_treads"], self, "tag_wheel_back_left");
		self.var_50198d5b = PlayFXOnTag(localClientNum, level._effect["tank_treads"], self, "tag_wheel_back_right");
		wait(0.5);
	}
}

/*
	Name: function_85886bc2
	Namespace: zm_tomb_tank
	Checksum: 0xD6EA0071
	Offset: 0xD60
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function function_85886bc2()
{
	origin3 = self GetTagOrigin("tag_wheel_back_left");
	ent3 = spawn(0, origin3, "script_origin");
	ent3 LinkTo(self, "tag_wheel_back_left");
	origin4 = self GetTagOrigin("tag_wheel_back_right");
	ent4 = spawn(0, origin4, "script_origin");
	ent4 LinkTo(self, "tag_wheel_back_right");
	ent3 PlayLoopSound("zmb_tank_mud_tread", 1);
	ent4 PlayLoopSound("zmb_tank_mud_tread", 1);
	self waittill("hash_51963593");
	ent3 delete();
	ent4 delete();
}

