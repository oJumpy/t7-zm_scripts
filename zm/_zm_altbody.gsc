#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_altbody;

/*
	Name: __init__sytem__
	Namespace: zm_altbody
	Checksum: 0xA3AB6A63
	Offset: 0x448
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_altbody", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_altbody
	Checksum: 0x89CD61E
	Offset: 0x488
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("clientuimodel", "player_lives", 1, 2, "int");
	clientfield::register("toplayer", "player_in_afterlife", 1, 1, "int");
	clientfield::register("clientuimodel", "player_mana", 1, 8, "float");
	clientfield::register("allplayers", "player_altbody", 1, 1, "int");
}

/*
	Name: init
	Namespace: zm_altbody
	Checksum: 0x560D4879
	Offset: 0x558
	Size: 0x1E3
	Parameters: 12
	Flags: None
*/
function init(name, var_4cc12170, trigger_hint, visionset_name, var_c74f70a2, loadout, character_index, var_4b737285, var_5cff5411, var_32a95a02, var_c99685e8, var_1982079a)
{
	if(!isdefined(level.var_16cbb1a8))
	{
		level.var_16cbb1a8 = [];
	}
	if(!isdefined(level.var_3b231394))
	{
		level.var_3b231394 = [];
	}
	if(!isdefined(level.var_4c59c11))
	{
		level.var_4c59c11 = [];
	}
	if(!isdefined(level.var_740d155e))
	{
		level.var_740d155e = [];
	}
	if(!isdefined(level.var_b48c4996))
	{
		level.var_b48c4996 = [];
	}
	if(!isdefined(level.var_3f7a17f))
	{
		level.var_3f7a17f = [];
	}
	if(isdefined(visionset_name))
	{
		level.var_b48c4996[name] = visionset_name;
		visionset_mgr::register_info("visionset", visionset_name, 1, var_c74f70a2, 1, 1);
	}
	function_b32967de(name, var_4cc12170, trigger_hint, var_c99685e8);
	level.var_16cbb1a8[name] = var_4b737285;
	level.var_3b231394[name] = var_5cff5411;
	level.var_4c59c11[name] = var_32a95a02;
	level.var_740d155e[name] = loadout;
	level.var_3f7a17f[name] = character_index;
	level.var_ba1ef2b1[name] = var_1982079a;
	level thread function_a2c7acf5();
}

/*
	Name: function_a2c7acf5
	Namespace: zm_altbody
	Checksum: 0x13F9A2AE
	Offset: 0x748
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function function_a2c7acf5()
{
	level waittill("end_game");
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] notify("hash_f0078f48");
	}
}

/*
	Name: function_4f8260a2
	Namespace: zm_altbody
	Checksum: 0x4C662578
	Offset: 0x7C0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_4f8260a2(name)
{
	/#
		self function_b3e2d176(name);
	#/
}

/*
	Name: function_3c17a460
	Namespace: zm_altbody
	Checksum: 0xA6D9A84C
	Offset: 0x7F8
	Size: 0xF7
	Parameters: 2
	Flags: Private
*/
function private function_3c17a460(trigger, name)
{
	if(self.IS_DRINKING > 0 && (!isdefined(self.var_ce25e278) && self.var_ce25e278))
	{
		return 0;
	}
	if(self zm_utility::in_revive_trigger())
	{
		return 0;
	}
	if(self laststand::player_is_in_laststand())
	{
		return 0;
	}
	if(self IsThrowingGrenade())
	{
		return 0;
	}
	if(self function_a27a52af(name))
	{
		return 0;
	}
	callback = level.var_4c59c11[name];
	if(isdefined(callback))
	{
		if(!self [[callback]](name, trigger.var_8042e4e2))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: function_b7c5c6d1
	Namespace: zm_altbody
	Checksum: 0xD7DD5737
	Offset: 0x8F8
	Size: 0x10F
	Parameters: 2
	Flags: Private
*/
function private function_b7c5c6d1(var_8042e4e2, name)
{
	if(isdefined(self.altbody) && self.altbody)
	{
		return 0;
	}
	if(self.IS_DRINKING > 0 && (!isdefined(self.var_ce25e278) && self.var_ce25e278))
	{
		return 0;
	}
	if(self zm_utility::in_revive_trigger())
	{
		return 0;
	}
	if(self laststand::player_is_in_laststand())
	{
		return 0;
	}
	if(self IsThrowingGrenade())
	{
		return 0;
	}
	if(self function_a27a52af(name))
	{
		return 0;
	}
	callback = level.var_4c59c11[name];
	if(isdefined(callback))
	{
		if(!self [[callback]](name, var_8042e4e2))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: function_a27a52af
	Namespace: zm_altbody
	Checksum: 0xD2B5D9DB
	Offset: 0xA10
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function function_a27a52af(name)
{
	foreach(var_23359ff6 in level.var_ba1ef2b1[name])
	{
		if(self bgb::is_enabled(var_23359ff6))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: function_e81daf64
	Namespace: zm_altbody
	Checksum: 0xC4C90EA5
	Offset: 0xAC0
	Size: 0x7B
	Parameters: 2
	Flags: Private
*/
function private function_e81daf64(trigger, name)
{
	self endon("disconnect");
	if(self function_b7c5c6d1(trigger, name))
	{
		level notify("hash_9712055e", trigger.stub.var_8042e4e2);
		self function_b3e2d176(name, trigger);
	}
}

/*
	Name: function_b3e2d176
	Namespace: zm_altbody
	Checksum: 0xC68371C3
	Offset: 0xB48
	Size: 0x87
	Parameters: 2
	Flags: Private
*/
function private function_b3e2d176(name, trigger)
{
	self.altbody = 1;
	self thread function_1f9554ce();
	self function_39fc0f41(name, trigger);
	self waittill("hash_f0078f48");
	self function_32a45d2d(name, trigger);
	self.altbody = 0;
}

/*
	Name: function_1f9554ce
	Namespace: zm_altbody
	Checksum: 0xCF678878
	Offset: 0xBD8
	Size: 0x63
	Parameters: 0
	Flags: Private
*/
function private function_1f9554ce()
{
	self endon("disconnect");
	was_inv = self EnableInvulnerability();
	wait(1);
	if(isdefined(self) && (!isdefined(was_inv) && was_inv))
	{
		self DisableInvulnerability();
	}
}

/*
	Name: function_9244ee8e
	Namespace: zm_altbody
	Checksum: 0xCBFBAE55
	Offset: 0xC48
	Size: 0xF
	Parameters: 1
	Flags: None
*/
function function_9244ee8e(player)
{
	return 16;
}

/*
	Name: function_39fc0f41
	Namespace: zm_altbody
	Checksum: 0xC3D7C316
	Offset: 0xC60
	Size: 0x173
	Parameters: 2
	Flags: Private
*/
function private function_39fc0f41(name, trigger)
{
	charIndex = level.var_3f7a17f[name];
	self.var_b2356a6c = self.origin;
	self.var_227fe352 = self.angles;
	self setPerk("specialty_playeriszombie");
	self thread function_72c3fae0(1);
	self SetCharacterBodyType(charIndex);
	self SetCharacterBodyStyle(0);
	self SetCharacterHelmetStyle(0);
	clientfield::set_to_player("player_in_afterlife", 1);
	self function_96a57786(name);
	self thread function_43af326a(name);
	callback = level.var_16cbb1a8[name];
	if(isdefined(callback))
	{
		self [[callback]](name, trigger);
	}
	clientfield::set("player_altbody", 1);
}

/*
	Name: function_43af326a
	Namespace: zm_altbody
	Checksum: 0xBA45A28A
	Offset: 0xDE0
	Size: 0xE5
	Parameters: 1
	Flags: Private
*/
function private function_43af326a(name)
{
	if(!isdefined(self.var_a8e4afcf))
	{
		self.var_a8e4afcf = [];
	}
	visionset = level.var_b48c4996[name];
	if(isdefined(visionset))
	{
		if(isdefined(self.var_a8e4afcf[name]) && self.var_a8e4afcf[name])
		{
			visionset_mgr::deactivate("visionset", visionset, self);
			util::wait_network_frame();
			util::wait_network_frame();
			if(!isdefined(self))
			{
				return;
			}
		}
		visionset_mgr::activate("visionset", visionset, self);
		self.var_a8e4afcf[name] = 1;
	}
}

/*
	Name: function_96a57786
	Namespace: zm_altbody
	Checksum: 0xC42F34A1
	Offset: 0xED0
	Size: 0x173
	Parameters: 1
	Flags: Private
*/
function private function_96a57786(name)
{
	self bgb::suspend_weapon_cycling();
	loadout = level.var_740d155e[name];
	if(isdefined(loadout))
	{
		self DisableWeaponCycling();
		/#
			Assert(!isdefined(self.get_player_weapon_limit));
		#/
		self.get_player_weapon_limit = &function_9244ee8e;
		self.var_67e131e7[name] = zm_weapons::player_get_loadout();
		self zm_weapons::player_give_loadout(loadout, 0, 1);
		if(!isdefined(self.var_8b5ec154))
		{
			self.var_8b5ec154 = [];
		}
		if(isdefined(self.var_8b5ec154[name]) && self.var_8b5ec154[name])
		{
			self SetEverHadWeaponAll(1);
		}
		self.var_8b5ec154[name] = 1;
		self util::waittill_any_timeout(1, "weapon_change_complete");
		self function_b47ed897();
	}
}

/*
	Name: function_32a45d2d
	Namespace: zm_altbody
	Checksum: 0xB1121081
	Offset: 0x1050
	Size: 0x163
	Parameters: 2
	Flags: Private
*/
function private function_32a45d2d(name, trigger)
{
	clientfield::set("player_altbody", 0);
	clientfield::set_to_player("player_in_afterlife", 0);
	callback = level.var_3b231394[name];
	if(isdefined(callback))
	{
		self [[callback]](name, trigger);
	}
	if(!isdefined(self.var_a8e4afcf))
	{
		self.var_a8e4afcf = [];
	}
	visionset = level.var_b48c4996[name];
	if(isdefined(visionset))
	{
		visionset_mgr::deactivate("visionset", visionset, self);
		self.var_a8e4afcf[name] = 0;
	}
	self thread function_d97ca744(name);
	self unsetPerk("specialty_playeriszombie");
	self DetachAll();
	self thread function_72c3fae0(0);
	self [[level.giveCustomCharacters]]();
}

/*
	Name: function_d97ca744
	Namespace: zm_altbody
	Checksum: 0x827131B9
	Offset: 0x11C0
	Size: 0x143
	Parameters: 2
	Flags: Private
*/
function private function_d97ca744(name, trigger)
{
	loadout = level.var_740d155e[name];
	if(isdefined(loadout))
	{
		if(isdefined(self.var_67e131e7[name]))
		{
			self zm_weapons::switch_back_primary_weapon(self.var_67e131e7[name].current, 1);
			self.var_67e131e7[name] = undefined;
			self util::waittill_any_timeout(1, "weapon_change_complete");
		}
		self zm_weapons::player_take_loadout(loadout);
		/#
			Assert(self.get_player_weapon_limit == &function_9244ee8e);
		#/
		self.get_player_weapon_limit = undefined;
		self function_b47ed897();
		self EnableWeaponCycling();
	}
	self bgb::resume_weapon_cycling();
}

/*
	Name: function_72c3fae0
	Namespace: zm_altbody
	Checksum: 0x3909F48B
	Offset: 0x1310
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function function_72c3fae0(washuman)
{
	if(washuman)
	{
		playFX(level._effect["human_disappears"], self.origin);
	}
	else
	{
		playFX(level._effect["zombie_disappears"], self.origin);
		playsoundatposition("zmb_player_disapparate", self.origin);
		self playlocalsound("zmb_player_disapparate_2d");
	}
}

/*
	Name: function_b32967de
	Namespace: zm_altbody
	Checksum: 0x9C1BA611
	Offset: 0x13D0
	Size: 0x111
	Parameters: 4
	Flags: None
*/
function function_b32967de(name, var_4cc12170, trigger_hint, var_c99685e8)
{
	if(!isdefined(level.var_1a198949))
	{
		level.var_1a198949 = [];
	}
	level.var_1a198949[name] = struct::get_array(var_4cc12170, "targetname");
	foreach(var_8042e4e2 in level.var_1a198949[name])
	{
		function_9621c06b(var_8042e4e2, name, trigger_hint, var_c99685e8);
	}
	level notify("hash_725464dc", name);
}

/*
	Name: function_9621c06b
	Namespace: zm_altbody
	Checksum: 0x721E9A86
	Offset: 0x14F0
	Size: 0x19B
	Parameters: 4
	Flags: None
*/
function function_9621c06b(var_8042e4e2, name, trigger_hint, var_c99685e8)
{
	width = 128;
	height = 128;
	length = 128;
	unitrigger_stub = spawnstruct();
	unitrigger_stub.origin = var_8042e4e2.origin + VectorScale((0, 0, 1), 32);
	unitrigger_stub.angles = var_8042e4e2.angles;
	unitrigger_stub.script_unitrigger_type = "unitrigger_radius_use";
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	unitrigger_stub.radius = 64;
	unitrigger_stub.require_look_at = 0;
	unitrigger_stub.var_8042e4e2 = var_8042e4e2;
	unitrigger_stub.var_105435b0 = name;
	unitrigger_stub.trigger_hint = trigger_hint;
	unitrigger_stub.var_c99685e8 = var_c99685e8;
	unitrigger_stub.prompt_and_visibility_func = &function_d06c7b0a;
	zm_unitrigger::register_static_unitrigger(unitrigger_stub, &function_f270a7f6);
}

/*
	Name: function_d06c7b0a
	Namespace: zm_altbody
	Checksum: 0xF83ED536
	Offset: 0x1698
	Size: 0x14F
	Parameters: 1
	Flags: None
*/
function function_d06c7b0a(player)
{
	visible = !isdefined(player.altbody) && player.altbody || (isdefined(player.var_ff6ba411) && player.var_ff6ba411);
	self.stub.usable = player function_b7c5c6d1(self.stub.var_8042e4e2, self.stub.var_105435b0);
	if(self.stub.usable)
	{
		self.stub.hint_string = self.stub.trigger_hint;
	}
	else
	{
		self.stub.hint_string = self.stub.var_c99685e8;
	}
	self setHintString(self.stub.hint_string);
	self SetInvisibleToPlayer(player, !visible);
	return visible;
}

/*
	Name: function_f270a7f6
	Namespace: zm_altbody
	Checksum: 0xACB65556
	Offset: 0x17F0
	Size: 0xCF
	Parameters: 0
	Flags: None
*/
function function_f270a7f6()
{
	while(1)
	{
		self waittill("trigger", player);
		if(isdefined(self.stub.usable) && self.stub.usable)
		{
			self.stub.usable = 0;
			name = self.stub.var_105435b0;
			if(isdefined(player.var_1333176))
			{
				player thread [[player.var_1333176]](self, name);
			}
			else
			{
				player thread function_e81daf64(self, name);
			}
		}
	}
}

/*
	Name: function_66dbe82a
	Namespace: zm_altbody
	Checksum: 0x255CD372
	Offset: 0x18C8
	Size: 0xAB
	Parameters: 4
	Flags: Private
*/
function private function_66dbe82a(name, trigger_name, trigger_hint, var_87802c85)
{
	triggers = GetEntArray(trigger_name, "targetname");
	if(!triggers.size)
	{
		triggers = GetEntArray(trigger_name, "script_noteworthy");
	}
	Array::thread_all(triggers, &function_ebd43723, name, trigger_name, trigger_hint, var_87802c85);
}

/*
	Name: function_ebd43723
	Namespace: zm_altbody
	Checksum: 0x92D2EB44
	Offset: 0x1980
	Size: 0x167
	Parameters: 4
	Flags: Private
*/
function private function_ebd43723(name, trigger_name, trigger_hint, var_87802c85)
{
	self endon("death");
	self setHintString(trigger_hint);
	self setcursorhint("HINT_NOICON");
	self SetVisibleToAll();
	self thread function_64f6ca83(name, var_87802c85);
	if(var_87802c85)
	{
		if(isdefined(self.target))
		{
			target = GetEnt(self.target, "targetname");
			self.var_8042e4e2 = target;
		}
		while(isdefined(self))
		{
			self waittill("trigger", player);
			if(isdefined(player.var_1333176))
			{
				player thread [[player.var_1333176]](self, name);
			}
			else
			{
				player thread function_e81daf64(self, name);
			}
		}
	}
}

/*
	Name: function_64f6ca83
	Namespace: zm_altbody
	Checksum: 0x7467037C
	Offset: 0x1AF0
	Size: 0x1E7
	Parameters: 2
	Flags: None
*/
function function_64f6ca83(name, var_87802c85)
{
	self endon("death");
	self SetInvisibleToAll();
	level flagsys::wait_till("start_zombie_round_logic");
	self SetVisibleToAll();
	pId = 0;
	self.var_5c0036b3 = 1;
	while(isdefined(self))
	{
		players = level.players;
		if(pId >= players.size)
		{
			pId = 0;
		}
		player = players[pId];
		pId++;
		if(isdefined(player))
		{
			visible = 1;
			visible = player function_b7c5c6d1(self, name);
			if(visible == var_87802c85 && (!isdefined(player.altbody) && player.altbody || (isdefined(player.var_ff6ba411) && player.var_ff6ba411)) && (isdefined(self.var_5c0036b3) && self.var_5c0036b3))
			{
				self SetVisibleToPlayer(player);
			}
			else
			{
				self SetInvisibleToPlayer(player);
			}
		}
		wait(RandomFloatRange(0.2, 0.5));
	}
}

