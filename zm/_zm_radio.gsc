#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_5c41055a;

/*
	Name: __init__sytem__
	Namespace: namespace_5c41055a
	Checksum: 0x69FE121F
	Offset: 0x3B8
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_radio", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_5c41055a
	Checksum: 0x99EC1590
	Offset: 0x400
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

/*
	Name: __main__
	Namespace: namespace_5c41055a
	Checksum: 0x8673CBC7
	Offset: 0x410
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level.var_ce7032d4 = -1;
	str_name = "kzmb";
	str_key = "targetname";
	if(isdefined(level.var_f3b142b3))
	{
		str_name = level.var_f3b142b3;
	}
	if(isdefined(level.kzmb_key))
	{
		key = level.kzmb_key;
	}
	var_903fae71 = GetEntArray(str_name, str_key);
	if(!isdefined(var_903fae71) || !var_903fae71.size)
	{
		/#
			println("Dev Block strings are not supported");
		#/
		return;
	}
	/#
		println("Dev Block strings are not supported" + var_903fae71.size);
	#/
	Array::thread_all(var_903fae71, &function_8554d5da);
}

/*
	Name: function_8554d5da
	Namespace: namespace_5c41055a
	Checksum: 0x6FD48D7
	Offset: 0x530
	Size: 0x171
	Parameters: 0
	Flags: None
*/
function function_8554d5da()
{
	self SetCanDamage(1);
	level thread function_4b776d12();
	self thread function_2d4f4459();
	self thread function_f184004e();
	while(1)
	{
		self waittill("damage", damage, attacker, dir, loc, type, model, tag, part, weapon, flags);
		if(!isdefined(attacker) || !isPlayer(attacker))
		{
			continue;
		}
		if(type == "MOD_PROJECTILE")
		{
			continue;
		}
		if(type == "MOD_MELEE" || type == "MOD_GRENADE_SPLASH")
		{
			self notify("hash_dec13539");
		}
		else
		{
			self notify("hash_34d24635");
		}
	}
}

/*
	Name: function_2d4f4459
	Namespace: namespace_5c41055a
	Checksum: 0x46FB1FC9
	Offset: 0x6B0
	Size: 0xA7
	Parameters: 0
	Flags: None
*/
function function_2d4f4459()
{
	self.Trackname = undefined;
	self.var_63f35de2 = 0;
	while(1)
	{
		self waittill("hash_34d24635");
		if(isdefined(self.var_175c09e5))
		{
			self stopSound(self.var_175c09e5);
			wait(0.05);
		}
		self PlaySoundWithNotify("zmb_musicradio_switch", "sounddone");
		self waittill("sounddone");
		self thread function_c62f1c37();
	}
}

/*
	Name: function_c62f1c37
	Namespace: namespace_5c41055a
	Checksum: 0x2E73FBB2
	Offset: 0x760
	Size: 0x9D
	Parameters: 0
	Flags: None
*/
function function_c62f1c37()
{
	self endon("hash_34d24635");
	self endon("hash_dec13539");
	self PlaySoundWithNotify(level.var_2ec01df2[self.var_63f35de2], "songdone");
	self.var_175c09e5 = level.var_2ec01df2[self.var_63f35de2];
	self.var_63f35de2++;
	if(self.var_63f35de2 >= level.var_2ec01df2.size)
	{
		self.var_63f35de2 = 0;
	}
	self waittill("hash_2e6aeba2");
	self notify("hash_34d24635");
}

/*
	Name: function_f184004e
	Namespace: namespace_5c41055a
	Checksum: 0x6314310E
	Offset: 0x808
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function function_f184004e()
{
	while(1)
	{
		self waittill("hash_dec13539");
		self PlaySoundWithNotify("zmb_musicradio_off", "sounddone");
		if(isdefined(self.var_175c09e5))
		{
			self stopSound(self.var_175c09e5);
		}
	}
}

/*
	Name: function_4b776d12
	Namespace: namespace_5c41055a
	Checksum: 0x4ACA2D9B
	Offset: 0x878
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function function_4b776d12()
{
	level.var_2ec01df2 = Array("mus_radio_track_1", "mus_radio_track_2", "mus_radio_track_3", "mus_radio_track_4", "mus_radio_track_5", "mus_radio_track_6", "mus_radio_track_7", "mus_radio_track_8", "mus_radio_track_9", "mus_radio_track_10", "mus_radio_track_11", "mus_radio_track_12", "mus_radio_track_13", "mus_radio_track_14", "mus_radio_track_15", "mus_radio_track_16", "mus_radio_track_17", "mus_radio_track_18", "mus_radio_track_19", "mus_radio_track_20", "mus_radio_track_21", "mus_radio_track_22", "mus_radio_track_23", "mus_radio_track_24", "mus_radio_track_25", "mus_radio_track_26", "mus_radio_track_27", "mus_radio_track_28", "mus_radio_track_29", "mus_radio_track_30", "mus_radio_track_31");
}

