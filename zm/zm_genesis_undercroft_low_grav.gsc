#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_genesis_portals;
#using scripts\zm\zm_genesis_zombie;

#namespace zm_genesis_undercroft_low_grav;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x39B65E8D
	Offset: 0x788
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_undercroft_low_grav", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xE7B11716
	Offset: 0x7D0
	Size: 0x16D
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "low_grav_powerup_triggered", 15000, 1, "counter");
	clientfield::register("toplayer", "player_screen_fx", 15000, 1, "int");
	clientfield::register("toplayer", "player_postfx", 15000, 1, "int");
	clientfield::register("scriptmover", "undercroft_emissives", 15000, 1, "int");
	clientfield::register("scriptmover", "undercroft_wall_panel_shutdown", 15000, 1, "counter");
	clientfield::register("scriptmover", "floor_panel_emissives_glow", 15000, 1, "int");
	clientfield::register("world", "snd_low_gravity_state", 15000, 2, "int");
	level._effect["low_grav_player_jump"] = "dlc1/castle/fx_plyr_115_liquid_trail";
}

/*
	Name: __main__
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x7286D077
	Offset: 0x948
	Size: 0x1B3
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level flag::init("low_grav_countdown");
	level flag::init("low_grav_on");
	level.t_grav_trig = GetEnt("undercroft_zone_lowgrav_trig", "targetname");
	level.var_4fb25bb9 = [];
	level.var_4fb25bb9["walk"] = 4;
	level.var_4fb25bb9["run"] = 4;
	level.var_4fb25bb9["sprint"] = 4;
	level.var_4fb25bb9["crawl"] = 3;
	/#
		level thread function_ab786717();
	#/
	level flag::wait_till("start_zombie_round_logic");
	level flag::init("pressure_pads_activated");
	level flag::init("undercroft_powerup_available");
	level flag::init("grav_off_for_ee");
	level function_3fa7f11a();
	level thread function_efcb9832();
	level thread function_c3e8e4a4();
}

/*
	Name: function_3fa7f11a
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x31BD156D
	Offset: 0xB08
	Size: 0x243
	Parameters: 0
	Flags: None
*/
function function_3fa7f11a()
{
	level endon("pressure_pads_activated");
	var_15ed352b = GetEntArray("grav_pad_trigger", "targetname");
	level.var_4a455ac4 = 0;
	level.var_eca8388c = [];
	foreach(t_pad_trigger in var_15ed352b)
	{
		t_pad_trigger thread grav_pad_trigger_think();
		var_4de8678a = GetEnt(t_pad_trigger.target, "targetname");
		var_e3260cf = GetEnt(var_4de8678a.target, "targetname");
		Array::add(level.var_eca8388c, var_e3260cf);
	}
	while(level.var_4a455ac4 < var_15ed352b.size)
	{
		wait(0.05);
	}
	foreach(t_pad_trigger in var_15ed352b)
	{
		var_544a882 = GetEnt(t_pad_trigger.target, "targetname");
	}
	level thread function_ed0d48ca();
	level flag::set("pressure_pads_activated");
}

/*
	Name: function_ed0d48ca
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x89C8E24C
	Offset: 0xD58
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_ed0d48ca()
{
	wait(5);
	exploder::exploder_stop("lgt_grav_pad_n");
	exploder::exploder_stop("lgt_grav_pad_s");
	exploder::exploder_stop("lgt_grav_pad_e");
	exploder::exploder_stop("lgt_grav_pad_w");
}

/*
	Name: grav_pad_trigger_think
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x7385AC27
	Offset: 0xDD0
	Size: 0x2F7
	Parameters: 0
	Flags: None
*/
function grav_pad_trigger_think()
{
	var_4de8678a = GetEnt(self.target, "targetname");
	var_4de8678a EnableLinkTo();
	var_e3260cf = GetEnt(var_4de8678a.target, "targetname");
	var_e3260cf EnableLinkTo();
	var_e3260cf LinkTo(var_4de8678a);
	var_2e8e2853 = var_4de8678a.origin - VectorScale((0, 0, 1), 2);
	var_93f2a402 = var_4de8678a.origin;
	while(1)
	{
		self waittill("trigger", e_who);
		var_4de8678a moveto(var_2e8e2853, 0.5);
		playsoundatposition("evt_stone_plate_down", var_4de8678a.origin);
		var_4de8678a waittill("movedone");
		var_e3260cf clientfield::set("undercroft_emissives", 1);
		n_start_time = GetTime();
		n_end_time = n_start_time + 3000;
		while(e_who istouching(self))
		{
			n_time = GetTime();
			if(n_time >= n_end_time)
			{
				level.var_4a455ac4++;
				exploder::exploder("lgt_" + self.script_string);
				playsoundatposition("evt_stone_plate_up", var_4de8678a.origin);
				e_who PlayRumbleOnEntity("zm_castle_low_grav_panel_rumble");
				return;
			}
			wait(0.05);
		}
		var_4de8678a moveto(var_93f2a402, 0.5);
		playsoundatposition("evt_stone_plate_down", var_4de8678a.origin);
		var_e3260cf clientfield::set("undercroft_emissives", 0);
		var_e3260cf clientfield::increment("undercroft_wall_panel_shutdown");
	}
}

/*
	Name: function_efcb9832
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xFC9D4048
	Offset: 0x10D0
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function function_efcb9832()
{
	SetDvar("wallrun_enabled", 1);
	SetDvar("doublejump_enabled", 1);
	SetDvar("playerEnergy_enabled", 1);
	SetDvar("bg_lowGravity", 300);
	SetDvar("wallRun_maxTimeMs_zm", 10000);
	SetDvar("playerEnergy_maxReserve_zm", 200);
	SetDvar("wallRun_peakTest_zm", 0);
	level thread function_5f1fa8cd();
}

/*
	Name: function_5f1fa8cd
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xDAFF1F72
	Offset: 0x11D0
	Size: 0x2AD
	Parameters: 1
	Flags: None
*/
function function_5f1fa8cd(n_duration)
{
	if(!isdefined(n_duration))
	{
		n_duration = 50;
	}
	/#
		level endon("hash_9c3be857");
	#/
	var_e31d98a1 = GetEntArray("lowgrav_glow", "targetname");
	a_e_pyramid = GetEntArray("pyramid", "targetname");
	var_e31d98a1 = ArrayCombine(a_e_pyramid, var_e31d98a1, 0, 0);
	level thread function_ba48ca38();
	while(1)
	{
		level flag::set("low_grav_on");
		exploder::exploder("lgt_low_gravity_on");
		if(!(isdefined(level.var_513683a6) && level.var_513683a6))
		{
			exploder::exploder("fxexp_117");
		}
		level clientfield::set("snd_low_gravity_state", 1);
		Array::thread_all(var_e31d98a1, &clientfield::set, "undercroft_emissives", 1);
		Array::thread_all(level.var_eca8388c, &clientfield::set, "floor_panel_emissives_glow", 1);
		wait(n_duration - 10);
		level function_e1998cb5();
		level flag::clear("low_grav_on");
		exploder::stop_exploder("lgt_low_gravity_on");
		level clientfield::set("snd_low_gravity_state", 0);
		Array::thread_all(var_e31d98a1, &clientfield::set, "undercroft_emissives", 0);
		Array::thread_all(level.var_eca8388c, &clientfield::set, "floor_panel_emissives_glow", 0);
		level flag::wait_till_clear("grav_off_for_ee");
		wait(60);
	}
}

/*
	Name: function_e1998cb5
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xFA6E2FA2
	Offset: 0x1488
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function function_e1998cb5()
{
	level clientfield::set("snd_low_gravity_state", 2);
	level flag::set("low_grav_countdown");
	exploder::exploder("lgt_low_gravity_flash");
	wait(7);
	exploder::stop_exploder("lgt_low_gravity_flash");
	exploder::stop_exploder("fxexp_117");
	exploder::exploder("lgt_low_gravity_flash_fast");
	wait(3);
	exploder::stop_exploder("lgt_low_gravity_flash_fast");
	level flag::clear("low_grav_countdown");
}

/*
	Name: function_3ccd9604
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xE549ACFC
	Offset: 0x1580
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function function_3ccd9604()
{
	self endon("death");
	while(1)
	{
		if(self istouching(level.t_grav_trig) && level flag::get("low_grav_on") && self.LOW_GRAVITY == 0)
		{
			self zm_genesis_zombie::set_gravity("low");
			self.LOW_GRAVITY = 1;
		}
		else if(!self istouching(level.t_grav_trig) || !level flag::get("low_grav_on"))
		{
			self zm_genesis_zombie::set_gravity("normal");
			self.LOW_GRAVITY = 0;
		}
		wait(0.5);
	}
}

/*
	Name: function_f4766f6
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xFD7157B1
	Offset: 0x1698
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function function_f4766f6()
{
	self endon("death");
	while(1)
	{
		if(self istouching(level.t_grav_trig) && level flag::get("low_grav_on") && (!isdefined(self.LOW_GRAVITY) && self.LOW_GRAVITY))
		{
			self ai::set_behavior_attribute("gravity", "low");
			self.LOW_GRAVITY = 1;
		}
		else if(!self istouching(level.t_grav_trig) || !level flag::get("low_grav_on"))
		{
			self ai::set_behavior_attribute("gravity", "normal");
			self.LOW_GRAVITY = 0;
		}
		wait(0.5);
	}
}

/*
	Name: function_c3f6aa22
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xF17DA384
	Offset: 0x17C8
	Size: 0x2B3
	Parameters: 0
	Flags: None
*/
function function_c3f6aa22()
{
	self endon("death");
	self endon("disconnect");
	level flag::wait_till("low_grav_on");
	self.var_6921c563 = 0;
	while(1)
	{
		while(self istouching(level.t_grav_trig))
		{
			while(level flag::get("low_grav_on") && self istouching(level.t_grav_trig))
			{
				if(self.var_6921c563 == 0)
				{
					self allowwallrun(1);
					self allowdoublejump(1);
					self setPerk("specialty_lowgravity");
					self.var_6921c563 = 1;
					self clientfield::set_to_player("player_screen_fx", 1);
					self thread function_573a448e();
					self clientfield::set_to_player("player_postfx", 1);
					self thread function_e997f73a();
					/#
						if(GetDvarInt("Dev Block strings are not supported") > 0)
						{
							SetDvar("Dev Block strings are not supported", GetDvarInt("Dev Block strings are not supported"));
						}
					#/
				}
				wait(0.1);
			}
			if(self.var_6921c563 == 1)
			{
				self allowdoublejump(0);
				self allowwallrun(0);
				self unsetPerk("specialty_lowgravity");
				self clientfield::set_to_player("player_screen_fx", 0);
				self clientfield::set_to_player("player_postfx", 0);
				self notify("low_grav_off");
				self.var_6921c563 = 0;
			}
			wait(0.1);
		}
		wait(0.1);
	}
}

/*
	Name: function_e997f73a
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x94339071
	Offset: 0x1A88
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function function_e997f73a()
{
	self endon("death");
	self endon("disconnect");
	self endon("low_grav_off");
	while(1)
	{
		if(self IsOnGround() || self IsWallRunning())
		{
			self setdoublejumpenergy(200);
		}
		wait(0.05);
	}
}

/*
	Name: function_573a448e
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x7397884A
	Offset: 0x1B10
	Size: 0x16F
	Parameters: 0
	Flags: None
*/
function function_573a448e()
{
	self endon("death");
	self endon("disconnect");
	while(self.var_6921c563 == 1)
	{
		self waittill("hash_83e193a3");
		var_5ed20759 = spawn("script_model", self.origin);
		var_5ed20759 SetModel("tag_origin");
		var_5ed20759 EnableLinkTo();
		var_5ed20759 LinkTo(self, "j_spineupper");
		PlayFXOnTag(level._effect["low_grav_player_jump"], var_5ed20759, "tag_origin");
		while(!self IsOnGround() || self IsWallRunning() && level flag::get("low_grav_on"))
		{
			wait(0.5);
		}
		var_5ed20759 delete();
		wait(0.5);
	}
}

/*
	Name: function_ba48ca38
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x52F483C4
	Offset: 0x1C88
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function function_ba48ca38()
{
	e_trig = GetEnt("low_grav_tp_return", "targetname");
	while(1)
	{
		e_trig waittill("trigger", e_who);
		if(!isdefined(e_who.b_is_falling))
		{
			e_who thread function_23f211e9();
		}
	}
}

/*
	Name: function_23f211e9
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x845D1354
	Offset: 0x1D10
	Size: 0xAD
	Parameters: 0
	Flags: None
*/
function function_23f211e9()
{
	self.b_is_falling = 1;
	self playlocalsound("zmb_teleporter_teleport_2d");
	playsoundatposition("zmb_teleporter_teleport_out", self.origin);
	a_s_port_locs = struct::get_array("temple_portal_top", "targetname");
	self namespace_766d6099::portal_teleport_player(1, a_s_port_locs, undefined, self.origin, "temple_portal_top");
	self.b_is_falling = undefined;
}

/*
	Name: function_c3e8e4a4
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x53904DA2
	Offset: 0x1DC8
	Size: 0x109
	Parameters: 0
	Flags: None
*/
function function_c3e8e4a4()
{
	s_loc = struct::get("perk_powerup_loc", "targetname");
	level._powerup_timeout_override = &function_e4e4f426;
	foreach(e_player in level.players)
	{
		var_6e4b5e90 = level thread zm_powerups::specific_powerup_drop("free_perk", s_loc.origin, undefined, undefined, undefined, e_player);
	}
	wait(0.5);
	level._powerup_timeout_override = undefined;
}

/*
	Name: function_e4e4f426
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xA2503E07
	Offset: 0x1EE0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_e4e4f426()
{
	self endon("powerup_grabbed");
	self endon("death");
	self endon("powerup_reset");
	self zm_powerups::powerup_show(1);
}

/*
	Name: detect_reentry
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x20A43F1D
	Offset: 0x1F28
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function detect_reentry()
{
	/#
		if(isdefined(self.devgui_time))
		{
			if(self.devgui_time == GetTime())
			{
				return 1;
			}
		}
		self.devgui_time = GetTime();
		return 0;
	#/
}

/*
	Name: function_ab786717
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x1E4E9D3F
	Offset: 0x1F68
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_ab786717()
{
	/#
		level flagsys::wait_till("Dev Block strings are not supported");
		wait(1);
		zm_devgui::add_custom_devgui_callback(&function_e41a2453);
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_e41a2453
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xA5F1D4A4
	Offset: 0x1FD8
	Size: 0x75
	Parameters: 1
	Flags: None
*/
function function_e41a2453(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				if(level detect_reentry())
				{
					return 1;
				}
				level notify("hash_9c3be857");
				level thread function_5f1fa8cd(9999);
				return 1;
			}
		}
		return 0;
	#/
}

