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
	clientfield::register("vehicle", "tank_tread_fx", 21000, 1, "int", &play_tread_fx, 0, 0);
	clientfield::register("vehicle", "tank_flamethrower_fx", 21000, 2, "int", &play_flamethrower_fx, 0, 0);
	clientfield::register("vehicle", "tank_cooldown_fx", 21000, 2, "int", &play_tank_fx, 0, 0);
}

/*
	Name: play_tread_fx
	Namespace: zm_tomb_tank
	Checksum: 0xE4D3786
	Offset: 0x3E0
	Size: 0xC9
	Parameters: 7
	Flags: None
*/
function play_tread_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
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
		self thread tread_fx_loop(localClientNum);
	}
	else if(newVal == 0)
	{
		/#
			println("Dev Block strings are not supported");
		#/
		self notify("tread_fx_stop");
	}
}

/*
	Name: flamethrower_fx_loop
	Namespace: zm_tomb_tank
	Checksum: 0x78A6116C
	Offset: 0x4B8
	Size: 0x147
	Parameters: 2
	Flags: None
*/
function flamethrower_fx_loop(localClientNum, str_tag)
{
	self endon("stop_flamethrower");
	sndOrigin = self GetTagOrigin(str_tag);
	sndent = spawn(0, sndOrigin, "script_origin");
	sndent LinkTo(self, str_tag);
	sndent playsound(0, "zmb_tank_flame_start");
	sndent.var_9bdbad77 = sndent PlayLoopSound("zmb_tank_flame_loop", 0.6);
	self thread sndstopflamethrower(sndent);
	while(1)
	{
		self.flame_fx = PlayFXOnTag(localClientNum, level._effect["mech_wpn_flamethrower"], self, str_tag);
		wait(0.1);
	}
}

/*
	Name: sndstopflamethrower
	Namespace: zm_tomb_tank
	Checksum: 0x66D558C7
	Offset: 0x608
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function sndstopflamethrower(ent)
{
	self waittill("stop_flamethrower");
	ent playsound(0, "zmb_tank_flame_stop");
	ent StopLoopSound(ent.var_9bdbad77, 0.25);
	wait(1);
	ent delete();
}

/*
	Name: play_flamethrower_fx
	Namespace: zm_tomb_tank
	Checksum: 0x4D1FF73A
	Offset: 0x698
	Size: 0x113
	Parameters: 7
	Flags: None
*/
function play_flamethrower_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self notify("stop_flamethrower");
	if(!isdefined(self.sndflame))
	{
		self.sndflame = spawn(0, (0, 0, 0), "script_origin");
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
	self thread flamethrower_fx_loop(localClientNum, str_tag);
}

/*
	Name: play_exhaust_fx
	Namespace: zm_tomb_tank
	Checksum: 0xE2AA29C5
	Offset: 0x7B8
	Size: 0xEF
	Parameters: 2
	Flags: None
*/
function play_exhaust_fx(localClientNum, is_overheat)
{
	self notify("stop_exhaust_fx");
	self endon("entityshutdown");
	self endon("stop_exhaust_fx");
	fx_id = level._effect["tank_exhaust"];
	if(is_overheat)
	{
		fx_id = level._effect["tank_overheat"];
	}
	if(is_overheat)
	{
		self thread sndplayoverheat(self.origin);
		continue;
	}
	self thread sndplayexhaust();
	while(1)
	{
		PlayFXOnTag(localClientNum, fx_id, self, "tag_origin");
		wait(0.1);
	}
}

/*
	Name: sndplayoverheat
	Namespace: zm_tomb_tank
	Checksum: 0x545F15E8
	Offset: 0x8B0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function sndplayoverheat(origin)
{
	audio::playloopat("zmb_bot_timeout_steam", origin);
	self waittill("stop_exhaust_fx");
	audio::stoploopat("zmb_bot_timeout_steam", origin);
}

/*
	Name: sndplayexhaust
	Namespace: zm_tomb_tank
	Checksum: 0x71E4D048
	Offset: 0x910
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function sndplayexhaust()
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
	Name: play_tank_fx
	Namespace: zm_tomb_tank
	Checksum: 0x3F97DB39
	Offset: 0xA98
	Size: 0x205
	Parameters: 7
	Flags: None
*/
function play_tank_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self notify("stop_exhaust_fx");
	if(isdefined(self.light_fx1))
	{
		stopfx(localClientNum, self.light_fx1);
		self.light_fx1 = undefined;
	}
	if(isdefined(self.light_fx2))
	{
		stopfx(localClientNum, self.light_fx2);
		self.light_fx2 = undefined;
	}
	switch(newVal)
	{
		case 1:
		{
			self thread play_exhaust_fx(localClientNum, 1);
			self.light_fx1 = PlayFXOnTag(localClientNum, level._effect["tank_light_red"], self, "tag_light_left");
			self.light_fx2 = PlayFXOnTag(localClientNum, level._effect["tank_light_red"], self, "tag_light_right");
			break;
		}
		case 2:
		{
			self.light_fx1 = PlayFXOnTag(localClientNum, level._effect["tank_light_grn"], self, "tag_light_left");
			self.light_fx2 = PlayFXOnTag(localClientNum, level._effect["tank_light_grn"], self, "tag_light_right");
			break;
		}
		case 0:
		{
			self thread play_exhaust_fx(localClientNum, 0);
			break;
		}
	}
}

/*
	Name: tread_fx_loop
	Namespace: zm_tomb_tank
	Checksum: 0x9B0ED436
	Offset: 0xCA8
	Size: 0xAF
	Parameters: 1
	Flags: None
*/
function tread_fx_loop(localClientNum)
{
	self endon("tread_fx_stop");
	self thread sndplaymud();
	while(1)
	{
		self.tread_fx_left = PlayFXOnTag(localClientNum, level._effect["tank_treads"], self, "tag_wheel_back_left");
		self.tread_fx_right = PlayFXOnTag(localClientNum, level._effect["tank_treads"], self, "tag_wheel_back_right");
		wait(0.5);
	}
}

/*
	Name: sndplaymud
	Namespace: zm_tomb_tank
	Checksum: 0xD6EA0071
	Offset: 0xD60
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function sndplaymud()
{
	origin3 = self GetTagOrigin("tag_wheel_back_left");
	ent3 = spawn(0, origin3, "script_origin");
	ent3 LinkTo(self, "tag_wheel_back_left");
	origin4 = self GetTagOrigin("tag_wheel_back_right");
	ent4 = spawn(0, origin4, "script_origin");
	ent4 LinkTo(self, "tag_wheel_back_right");
	ent3 PlayLoopSound("zmb_tank_mud_tread", 1);
	ent4 PlayLoopSound("zmb_tank_mud_tread", 1);
	self waittill("tread_fx_stop");
	ent3 delete();
	ent4 delete();
}

