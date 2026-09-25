#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#namespace zm_moon_digger;

/*
	Name: main
	Namespace: zm_moon_digger
	Checksum: 0x4F4EED3C
	Offset: 0x268
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function main()
{
	level thread init_excavator_consoles();
}

/*
	Name: digger_moving_earthquake_rumble
	Namespace: zm_moon_digger
	Checksum: 0xE01F350F
	Offset: 0x290
	Size: 0x1A9
	Parameters: 7
	Flags: None
*/
function digger_moving_earthquake_rumble(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(localClientNum != 0)
	{
		return;
	}
	if(newVal)
	{
		for(i = 0; i < level.localPlayers.size; i++)
		{
			level thread do_digger_moving_earthquake_rumble(i, self);
		}
	}
	else if(isdefined(self.headlight1))
	{
		for(i = 0; i < level.localPlayers.size; i++)
		{
			stopfx(i, self.headlight1);
			stopfx(i, self.headlight2);
			stopfx(i, self.blink1);
			stopfx(i, self.blink2);
			if(isdefined(self.tread_fx))
			{
				stopfx(i, self.tread_fx);
			}
			if(isdefined(self.var_deef11e2))
			{
				stopfx(i, self.var_deef11e2);
			}
		}
	}
	self notify("stop_moving_rumble");
}

/*
	Name: function_a0cf54a0
	Namespace: zm_moon_digger
	Checksum: 0x11B4843C
	Offset: 0x448
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_a0cf54a0(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		level thread function_1e254f15();
	}
}

/*
	Name: function_1e254f15
	Namespace: zm_moon_digger
	Checksum: 0xB3DABE75
	Offset: 0x4B0
	Size: 0x147
	Parameters: 0
	Flags: None
*/
function function_1e254f15()
{
	for(i = 0; i < level.localPlayers.size; i++)
	{
		player = GetLocalPlayers()[i];
		if(!isdefined(player))
		{
			continue;
		}
		piece = struct::get("biodome_breached", "targetname");
		if(DistanceSquared(player.origin, piece.origin) < 6250000)
		{
			player Earthquake(0.5, 3, player.origin, 1500);
			player thread bio_breach_rumble(i);
		}
		scene::Play("p7_fxanim_zmhd_moon_biodome_glass_bundle");
		level notify("sl9");
		level notify("sl10");
	}
}

/*
	Name: bio_breach_rumble
	Namespace: zm_moon_digger
	Checksum: 0xDBFFF6D0
	Offset: 0x600
	Size: 0x7D
	Parameters: 1
	Flags: None
*/
function bio_breach_rumble(localClientNum)
{
	self endon("disconnect");
	for(i = 0; i < 10; i++)
	{
		self PlayRumbleOnEntity(localClientNum, "damage_heavy");
		wait(RandomFloatRange(0.1, 0.2));
	}
}

/*
	Name: digger_digging_earthquake_rumble
	Namespace: zm_moon_digger
	Checksum: 0xC8BAE123
	Offset: 0x688
	Size: 0xAD
	Parameters: 7
	Flags: None
*/
function digger_digging_earthquake_rumble(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(localClientNum != 0)
	{
		return;
	}
	if(newVal)
	{
		for(i = 0; i < level.localPlayers.size; i++)
		{
			level thread do_digger_digging_earthquake_rumble(i, self);
		}
	}
	else
	{
		self notify("stop_digging_rumble");
	}
}

/*
	Name: do_digger_moving_earthquake_rumble
	Namespace: zm_moon_digger
	Checksum: 0xA0B22697
	Offset: 0x740
	Size: 0x1D7
	Parameters: 2
	Flags: None
*/
function do_digger_moving_earthquake_rumble(localClientNum, quake_ent)
{
	quake_ent util::waittill_dobj(localClientNum);
	quake_ent endon("entityshutdown");
	quake_ent endon("stop_moving_rumble");
	dist_sqd = 6250000;
	quake_ent.tread_fx = PlayFXOnTag(localClientNum, level._effect["digger_treadfx_fwd"], quake_ent, "tag_origin");
	quake_ent.var_deef11e2 = PlayFXOnTag(localClientNum, level._effect["exca_body_all"], quake_ent, "tag_origin");
	player = GetLocalPlayers()[localClientNum];
	if(!isdefined(player))
	{
		return;
	}
	while(1)
	{
		if(!isdefined(player))
		{
			return;
		}
		player Earthquake(RandomFloatRange(0.15, 0.25), 3, quake_ent.origin, 2500);
		if(DistanceSquared(quake_ent.origin, player.origin) < dist_sqd)
		{
			player PlayRumbleOnEntity(localClientNum, "slide_rumble");
		}
		wait(RandomFloatRange(0.05, 0.15));
	}
}

/*
	Name: do_digger_digging_earthquake_rumble
	Namespace: zm_moon_digger
	Checksum: 0x39B1720F
	Offset: 0x920
	Size: 0x197
	Parameters: 2
	Flags: None
*/
function do_digger_digging_earthquake_rumble(localClientNum, quake_ent)
{
	quake_ent endon("entityshutdown");
	quake_ent endon("stop_digging_rumble");
	player = GetLocalPlayers()[localClientNum];
	if(!isdefined(player))
	{
		return;
	}
	count = 0;
	dist = 2250000;
	while(1)
	{
		if(!isdefined(player))
		{
			return;
		}
		player Earthquake(RandomFloatRange(0.12, 0.17), 3, quake_ent.origin, 1500);
		if(DistanceSquared(quake_ent.origin, player.origin) < dist && Abs(quake_ent.origin[2] - player.origin[2]) < 750)
		{
			player PlayRumbleOnEntity(localClientNum, "grenade_rumble");
		}
		wait(RandomFloatRange(0.1, 0.25));
	}
}

/*
	Name: digger_arm_fx
	Namespace: zm_moon_digger
	Checksum: 0xA4D7B11B
	Offset: 0xAC0
	Size: 0x15D
	Parameters: 7
	Flags: None
*/
function digger_arm_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(localClientNum != 0)
	{
		return;
	}
	if(newVal)
	{
		for(i = 0; i < level.localPlayers.size; i++)
		{
			level thread do_digger_arm_fx(i, self);
		}
		break;
	}
	if(isdefined(self.blink1))
	{
		for(i = 0; i < level.localPlayers.size; i++)
		{
			stopfx(i, self.blink1);
			stopfx(i, self.blink2);
		}
	}
	else if(isdefined(self.var_5f9ccb3a))
	{
		for(i = 0; i < level.localPlayers.size; i++)
		{
			stopfx(i, self.var_5f9ccb3a);
		}
	}
}

/*
	Name: do_digger_arm_fx
	Namespace: zm_moon_digger
	Checksum: 0x405BEC01
	Offset: 0xC28
	Size: 0x8F
	Parameters: 2
	Flags: None
*/
function do_digger_arm_fx(localClientNum, ent)
{
	ent endon("entityshutdown");
	player = GetLocalPlayers()[localClientNum];
	if(!isdefined(player))
	{
		return;
	}
	ent.var_5f9ccb3a = PlayFXOnTag(localClientNum, level._effect["exca_arm_all"], ent, "tag_origin");
}

/*
	Name: function_245b13ce
	Namespace: zm_moon_digger
	Checksum: 0xA1753AB6
	Offset: 0xCC0
	Size: 0x8B
	Parameters: 7
	Flags: None
*/
function function_245b13ce(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		level thread digger_visibility_toggle(localClientNum, "hide");
	}
	else
	{
		level thread digger_visibility_toggle(localClientNum, "show");
	}
}

/*
	Name: digger_visibility_toggle
	Namespace: zm_moon_digger
	Checksum: 0x2F718ED7
	Offset: 0xD58
	Size: 0x339
	Parameters: 2
	Flags: None
*/
function digger_visibility_toggle(localClient, visible)
{
	diggers = GetEntArray(localClient, "digger_body", "targetname");
	tracks = GetEntArray(localClient, "tracks", "targetname");
	switch(visible)
	{
		case "hide":
		{
			for(i = 0; i < tracks.size; i++)
			{
				tracks[i] Hide();
			}
			for(i = 0; i < diggers.size; i++)
			{
				arm = GetEnt(localClient, diggers[i].target, "targetname");
				blade_center = GetEnt(localClient, arm.target, "targetname");
				blade = GetEnt(localClient, blade_center.target, "targetname");
				diggers[i] Hide();
				arm Hide();
				blade Hide();
			}
			break;
		}
		case "show":
		{
			for(i = 0; i < tracks.size; i++)
			{
				tracks[i] show();
			}
			for(i = 0; i < diggers.size; i++)
			{
				arm = GetEnt(localClient, diggers[i].target, "targetname");
				blade_center = GetEnt(localClient, arm.target, "targetname");
				blade = GetEnt(localClient, blade_center.target, "targetname");
				diggers[i] show();
				arm show();
				blade show();
			}
			break;
		}
	}
}

/*
	Name: init_excavator_consoles
	Namespace: zm_moon_digger
	Checksum: 0x31B1CC67
	Offset: 0x10A0
	Size: 0x175
	Parameters: 0
	Flags: None
*/
function init_excavator_consoles()
{
	wait(15);
	for(index = 0; index < level.localPlayers.size; index++)
	{
		if(!level clientfield::get("TCA"))
		{
			var_cc373138 = GetEnt(index, "tunnel_console", "targetname");
			function_9b3daafa(index, var_cc373138, 0);
		}
		if(!level clientfield::get("HCA"))
		{
			var_cc373138 = GetEnt(index, "hangar_console", "targetname");
			function_9b3daafa(index, var_cc373138, 0);
		}
		if(!level clientfield::get("BCA"))
		{
			var_cc373138 = GetEnt(index, "biodome_console", "targetname");
			function_9b3daafa(index, var_cc373138, 0);
		}
	}
}

/*
	Name: function_774edb15
	Namespace: zm_moon_digger
	Checksum: 0x77DA2126
	Offset: 0x1220
	Size: 0x10B
	Parameters: 7
	Flags: None
*/
function function_774edb15(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	switch(fieldName)
	{
		case "TCA":
		{
			var_ffc320da = "tunnel_console";
			break;
		}
		case "HCA":
		{
			var_ffc320da = "hangar_console";
			break;
		}
		case "BCA":
		{
			var_ffc320da = "biodome_console";
			break;
		}
	}
	var_cc373138 = GetEnt(localClientNum, var_ffc320da, "targetname");
	if(newVal)
	{
		function_9b3daafa(localClientNum, var_cc373138, 1);
	}
	else
	{
		function_9b3daafa(localClientNum, var_cc373138, 0);
	}
}

/*
	Name: function_9b3daafa
	Namespace: zm_moon_digger
	Checksum: 0x7278C0DE
	Offset: 0x1338
	Size: 0xE7
	Parameters: 3
	Flags: None
*/
function function_9b3daafa(localClientNum, var_cc373138, var_a61a4e58)
{
	if(isdefined(var_cc373138.n_fx_id))
	{
		stopfx(localClientNum, var_cc373138.n_fx_id);
	}
	if(var_a61a4e58)
	{
		var_cc373138.n_fx_id = PlayFXOnTag(localClientNum, level._effect["panel_on"], var_cc373138, "tag_origin");
	}
	else
	{
		var_cc373138.n_fx_id = PlayFXOnTag(localClientNum, level._effect["panel_off"], var_cc373138, "tag_origin");
	}
}

