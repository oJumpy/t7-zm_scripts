#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_clone;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_ai_clone;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_island_util;

#namespace namespace_28a54cd6;

/*
	Name: __init__sytem__
	Namespace: namespace_28a54cd6
	Checksum: 0x2A0E63F0
	Offset: 0x4A0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_side_ee_doppleganger", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_28a54cd6
	Checksum: 0xC69A70B7
	Offset: 0x4E0
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_connect(&function_8feafce2);
	callback::on_spawned(&on_player_spawned);
	callback::on_disconnect(&on_player_disconnected);
	level.var_5f4ff545 = -1;
}

/*
	Name: main
	Namespace: namespace_28a54cd6
	Checksum: 0xDA917A1C
	Offset: 0x558
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function main()
{
	level thread function_46051422();
	/#
		level thread function_bece461b();
	#/
}

/*
	Name: function_8feafce2
	Namespace: namespace_28a54cd6
	Checksum: 0x6ACA1D38
	Offset: 0x598
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_8feafce2()
{
	self flag::init("doppleganger_enabled");
}

/*
	Name: on_player_spawned
	Namespace: namespace_28a54cd6
	Checksum: 0x83AC1999
	Offset: 0x5C8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self flag::clear("doppleganger_enabled");
}

/*
	Name: on_player_disconnected
	Namespace: namespace_28a54cd6
	Checksum: 0x81186781
	Offset: 0x5F8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function on_player_disconnected()
{
	if(isdefined(self.var_c748f21c))
	{
		self.var_c748f21c function_38165cb6();
	}
}

/*
	Name: function_46051422
	Namespace: namespace_28a54cd6
	Checksum: 0x23C5904D
	Offset: 0x630
	Size: 0x129
	Parameters: 1
	Flags: None
*/
function function_46051422(n_time)
{
	if(!isdefined(n_time))
	{
		n_time = 60;
	}
	level thread function_b1aa7056();
	level waittill("hash_8d6c8d6d");
	while(1)
	{
		if(level.activePlayers.size > 1)
		{
			var_f72c48e9 = RandomInt(10);
			if(var_f72c48e9 == 7)
			{
				wait(randomIntRange(60, 300));
				var_2bb7b39d = function_8c3f76f3();
				if(zm_utility::is_player_valid(var_2bb7b39d))
				{
					var_2bb7b39d thread function_5ee3951f();
					while(isalive(var_2bb7b39d.var_c748f21c))
					{
						wait(1);
					}
				}
			}
		}
		wait(60);
	}
}

/*
	Name: function_b1aa7056
	Namespace: namespace_28a54cd6
	Checksum: 0x18EAF58C
	Offset: 0x768
	Size: 0x137
	Parameters: 0
	Flags: None
*/
function function_b1aa7056()
{
	var_d47cc4f9 = GetEnt("t_lookat_doppleganger_enable", "targetname");
	if(isdefined(var_d47cc4f9))
	{
		while(1)
		{
			var_d47cc4f9 waittill("trigger", e_who);
			if(zm_utility::is_player_valid(e_who) && e_who util::ads_button_held() && !e_who flag::get("doppleganger_enabled"))
			{
				e_weapon = e_who GetCurrentWeapon();
				var_5d131e4a = StrTok(e_weapon.name, "_");
				if(var_5d131e4a[0] === "sniper")
				{
					e_who thread function_957b43e5();
				}
			}
			wait(0.1);
		}
	}
}

/*
	Name: function_957b43e5
	Namespace: namespace_28a54cd6
	Checksum: 0xD99FDFFF
	Offset: 0x8A8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_957b43e5()
{
	self endon("death");
	self flag::set("doppleganger_enabled");
	level notify("hash_8d6c8d6d");
	wait(300);
	self flag::clear("doppleganger_enabled");
}

/*
	Name: function_8c3f76f3
	Namespace: namespace_28a54cd6
	Checksum: 0x8E3A1205
	Offset: 0x910
	Size: 0x377
	Parameters: 0
	Flags: None
*/
function function_8c3f76f3()
{
	var_9876cb30 = [];
	var_7378d690 = [];
	var_2bb7b39d = undefined;
	var_506c0a63 = [];
	foreach(player in level.activePlayers)
	{
		if(zm_utility::is_player_valid(player) && player flag::get("doppleganger_enabled"))
		{
			Array::add(var_506c0a63, player);
		}
	}
	if(var_506c0a63.size)
	{
		foreach(player in var_506c0a63)
		{
			n_index = player zm_zonemgr::get_player_zone();
			if(!isdefined(var_9876cb30[n_index]))
			{
				var_9876cb30[n_index] = 0;
			}
			var_9876cb30[n_index]++;
			var_7378d690[n_index] = player;
		}
		var_2ca3526b = getArrayKeys(var_9876cb30);
		foreach(key in var_2ca3526b)
		{
			if(var_9876cb30[key] == 1)
			{
				var_8662c367 = var_7378d690[key];
				if(zm_utility::is_player_valid(var_8662c367))
				{
					var_fb6aeae6 = ArrayCopy(level.activePlayers);
					ArrayRemoveValue(var_fb6aeae6, var_8662c367);
					e_closest_player = ArrayGetClosest(var_8662c367.origin, var_fb6aeae6);
					if(zm_utility::is_player_valid(e_closest_player) && Distance2DSquared(var_8662c367.origin, e_closest_player.origin) >= 1000000)
					{
						var_2bb7b39d = var_8662c367;
						break;
					}
				}
			}
		}
	}
	return var_2bb7b39d;
}

/*
	Name: function_5ee3951f
	Namespace: namespace_28a54cd6
	Checksum: 0x8D155736
	Offset: 0xC90
	Size: 0x3B3
	Parameters: 0
	Flags: None
*/
function function_5ee3951f()
{
	var_697ad100 = Array(0, 1, 2, 3);
	a_players = ArrayCopy(level.activePlayers);
	ArrayRemoveValue(a_players, self);
	if(isdefined(self.var_c748f21c))
	{
		self.var_c748f21c delete();
	}
	var_91a9d91c = AnglesToForward(self.angles);
	v_new_pos = self.origin - var_91a9d91c * 220;
	self.var_d73c077d = GetClosestPointOnNavMesh(v_new_pos, 64);
	if(!isdefined(self.var_d73c077d))
	{
		var_6e3e5458 = AnglesToRight(self.angles);
		v_new_pos = self.origin - var_6e3e5458 * 220;
		self.var_d73c077d = GetClosestPointOnNavMesh(v_new_pos, 64);
	}
	if(!isdefined(self.var_d73c077d))
	{
		var_379fad75 = AnglesToRight(self.angles) * -1;
		v_new_pos = self.origin - var_379fad75 * 220;
		self.var_d73c077d = GetClosestPointOnNavMesh(v_new_pos, 64);
	}
	if(isdefined(self.var_d73c077d))
	{
		var_411ea70c = self.var_d73c077d - self.origin;
		var_4e08bd7 = VectorToAngles(var_411ea70c);
		self.var_c748f21c = SpawnActor("spawner_zm_island_clone", self.var_d73c077d, var_4e08bd7, "ai_doppleganger", 1);
		if(a_players.size > 0)
		{
			ArrayRemoveValue(a_players, self);
			do
			{
				var_52b4a338 = Array::random(a_players);
				ArrayRemoveValue(a_players, var_52b4a338);
			}
			while(!(!zm_utility::is_player_valid(var_52b4a338) && a_players.size > 0));
		}
		if(!zm_utility::is_player_valid(var_52b4a338))
		{
			var_52b4a338 = self;
		}
		self.var_c748f21c CloneServerUtils::clonePlayerLook(self.var_c748f21c, var_52b4a338, self);
		self.var_c748f21c Hide();
		self.var_c748f21c ShowToPlayer(self);
		self thread function_c948de86();
		self flag::clear("doppleganger_enabled");
	}
}

/*
	Name: function_c948de86
	Namespace: namespace_28a54cd6
	Checksum: 0x4C1CE2EC
	Offset: 0x1050
	Size: 0x1E5
	Parameters: 0
	Flags: None
*/
function function_c948de86()
{
	self.var_c748f21c endon("death");
	self endon("death");
	self.var_c748f21c ASMSetAnimationRate(1.2);
	util::magic_bullet_shield(self.var_c748f21c);
	var_4010e215 = 10000;
	var_66d72d36 = 360000;
	var_87c6d702 = "";
	do
	{
		n_dist_sq = DistanceSquared(self.origin, self.var_c748f21c.origin);
		if(n_dist_sq <= var_4010e215 && self namespace_8aed53c9::is_facing(self.var_c748f21c, 0.7))
		{
			var_87c6d702 = "scare";
		}
		else if(n_dist_sq > var_66d72d36 && !self namespace_8aed53c9::is_facing(self.var_c748f21c, 0.5))
		{
			var_87c6d702 = "delete";
		}
		else
		{
			wait(0.1);
		}
	}
	while(!(zm_utility::is_player_valid(self) && isdefined(self.var_c748f21c) && var_87c6d702 == ""));
	switch(var_87c6d702)
	{
		case "scare":
		{
			self thread function_69f74476();
			break;
		}
		case "delete":
		{
			self thread function_38165cb6();
			break;
		}
	}
}

/*
	Name: function_69f74476
	Namespace: namespace_28a54cd6
	Checksum: 0x9AE2D383
	Offset: 0x1240
	Size: 0x2B3
	Parameters: 0
	Flags: None
*/
function function_69f74476()
{
	if(isalive(self) && isdefined(self.var_c748f21c))
	{
		self util::player_lock_control();
		self DisableWeapons(1);
		self EnableInvulnerability();
		ai = self.var_c748f21c;
		var_1f377995 = util::spawn_model("tag_origin", ai.origin, self.angles);
		ai LinkTo(var_1f377995);
		self SetPlayerAngles(VectorToAngles(ai.origin - self.origin));
		self thread function_89b0bd32();
		v_dest = self.origin + VectorNormalize(AnglesToForward(self.angles)) * 30;
		ai util::stop_magic_bullet_shield();
		ai thread scene::Play("zm_dlc2_side_ee_doppleganger_scare_180l");
		wait(0.05);
		var_1f377995 moveto(v_dest, 0.1);
		var_1f377995 waittill("movedone");
		var_1f377995 LinkTo(self);
		ai waittill("scene_done");
		self notify("hash_916d8c9f");
		self util::player_unlock_control();
		self function_38165cb6();
		self enableWeapons();
		self DisableInvulnerability();
		var_1f377995 delete();
	}
	else if(isdefined(self.var_c748f21c))
	{
		self function_38165cb6();
	}
}

/*
	Name: function_89b0bd32
	Namespace: namespace_28a54cd6
	Checksum: 0x230C0374
	Offset: 0x1500
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function function_89b0bd32()
{
	self endon("hash_916d8c9f");
	self endon("disconnect");
	while(1)
	{
		self PlayRumbleOnEntity("tank_damage_heavy_mp");
		Earthquake(0.35, 0.5, self.origin, 325);
		wait(0.15);
	}
}

/*
	Name: function_38165cb6
	Namespace: namespace_28a54cd6
	Checksum: 0x3CD5390D
	Offset: 0x1580
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_38165cb6()
{
	if(isdefined(self.var_c748f21c))
	{
		util::stop_magic_bullet_shield(self.var_c748f21c);
		self.var_c748f21c delete();
	}
}

/*
	Name: function_bece461b
	Namespace: namespace_28a54cd6
	Checksum: 0x47110361
	Offset: 0x15D0
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function function_bece461b()
{
	/#
		zm_devgui::function_4acecab5(&function_8924dbff);
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_8924dbff
	Namespace: namespace_28a54cd6
	Checksum: 0x7E1FDEA2
	Offset: 0x1668
	Size: 0x13D
	Parameters: 1
	Flags: None
*/
function function_8924dbff(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				level.activePlayers[0] function_5ee3951f();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				foreach(player in level.players)
				{
					player flag::set("Dev Block strings are not supported");
				}
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level.activePlayers[0] function_38165cb6();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				function_8c3f76f3();
				return 1;
			}
		}
		return 0;
	#/
}

