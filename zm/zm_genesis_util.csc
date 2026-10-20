#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_utility;

#namespace zm_genesis_util;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_util
	Checksum: 0x7CAED6F5
	Offset: 0x400
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_util", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_util
	Checksum: 0xDF2873DB
	Offset: 0x448
	Size: 0x3DB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	n_bits = GetMinBitCountForNum(8);
	clientfield::register("toplayer", "player_rumble_and_shake", 15000, n_bits, "int", &player_rumble_and_shake, 0, 0);
	n_bits = GetMinBitCountForNum(4);
	clientfield::register("scriptmover", "emit_smoke", 15000, n_bits, "int", &emit_smoke, 0, 0);
	n_bits = GetMinBitCountForNum(4);
	clientfield::register("scriptmover", "fire_trap", 15000, n_bits, "int", &function_9dca8db5, 0, 0);
	clientfield::register("actor", "fire_trap_ignite_enemy", 15000, 1, "int", &fire_trap_ignite_enemy, 0, 0);
	clientfield::register("scriptmover", "rq_gateworm_magic", 15000, 1, "int", &rq_gateworm_magic, 0, 0);
	clientfield::register("scriptmover", "rq_gateworm_dissolve_finish", 15000, 1, "int", &rq_gateworm_dissolve_finish, 0, 0);
	clientfield::register("scriptmover", "rq_rune_glow", 15000, 1, "int", &rq_rune_glow, 0, 0);
	RegisterClientField("world", "gen_rune_electricity", 15000, 1, "int", &zm_utility::setSharedInventoryUIModels, 0, 1);
	RegisterClientField("world", "gen_rune_fire", 15000, 1, "int", &zm_utility::setSharedInventoryUIModels, 0, 1);
	RegisterClientField("world", "gen_rune_light", 15000, 1, "int", &zm_utility::setSharedInventoryUIModels, 0, 1);
	RegisterClientField("world", "gen_rune_shadow", 15000, 1, "int", &zm_utility::setSharedInventoryUIModels, 0, 1);
	clientfield::register("clientuimodel", "zmInventory.widget_rune_parts", 15000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.player_rune_quest", 15000, 1, "int", undefined, 0, 0);
}

/*
	Name: __main__
	Namespace: zm_genesis_util
	Checksum: 0x99EC1590
	Offset: 0x830
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __main__()
{
}

/*
	Name: player_rumble_and_shake
	Namespace: zm_genesis_util
	Checksum: 0x38D77B9E
	Offset: 0x840
	Size: 0x291
	Parameters: 7
	Flags: None
*/
function player_rumble_and_shake(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("disconnect");
	switch(newVal)
	{
		case 5:
		{
			self thread player_continuous_rumble(localClientNum, 1);
			break;
		}
		case 6:
		{
			self notify("stop_rumble_and_shake");
			self Earthquake(0.6, 1.5, self.origin, 100);
			self PlayRumbleOnEntity(localClientNum, "artillery_rumble");
			break;
		}
		case 4:
		{
			self Earthquake(0.6, 1.5, self.origin, 100);
			self PlayRumbleOnEntity(localClientNum, "artillery_rumble");
			break;
		}
		case 3:
		{
			self Earthquake(0.3, 1.5, self.origin, 100);
			self PlayRumbleOnEntity(localClientNum, "shotgun_fire");
			break;
		}
		case 2:
		{
			self Earthquake(0.1, 1, self.origin, 100);
			self PlayRumbleOnEntity(localClientNum, "damage_light");
			break;
		}
		case 1:
		{
			self PlayRumbleOnEntity(localClientNum, "reload_large");
			break;
		}
		case 7:
		{
			self thread player_continuous_rumble(localClientNum, 3, 0);
			break;
		}
		case 0:
		{
			self notify("stop_rumble_and_shake");
			break;
		}
		case default:
		{
			self notify("stop_rumble_and_shake");
			break;
		}
	}
}

/*
	Name: player_continuous_rumble
	Namespace: zm_genesis_util
	Checksum: 0x32DB5BC7
	Offset: 0xAE0
	Size: 0x203
	Parameters: 3
	Flags: None
*/
function player_continuous_rumble(localClientNum, n_rumble_level, var_10ba4a4c)
{
	if(!isdefined(var_10ba4a4c))
	{
		var_10ba4a4c = 1;
	}
	self notify("stop_rumble_and_shake");
	self endon("disconnect");
	self endon("stop_rumble_and_shake");
	start_time = GetTime();
	while(GetTime() - start_time < 120000)
	{
		if(isdefined(self) && self isLocalPlayer() && isdefined(self))
		{
			switch(n_rumble_level)
			{
				case 1:
				{
					if(var_10ba4a4c)
					{
						self Earthquake(0.2, 1, self.origin, 100);
					}
					self PlayRumbleOnEntity(localClientNum, "reload_small");
					wait(0.05);
					break;
				}
				case 2:
				{
					if(var_10ba4a4c)
					{
						self Earthquake(0.3, 1, self.origin, 100);
					}
					self PlayRumbleOnEntity(localClientNum, "damage_light");
					break;
				}
				case 3:
				{
					if(var_10ba4a4c)
					{
						self Earthquake(0.3, 1, self.origin, 100);
					}
					self PlayRumbleOnEntity(localClientNum, "artillery_rumble");
					break;
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: emit_smoke
	Namespace: zm_genesis_util
	Checksum: 0x64355709
	Offset: 0xCF0
	Size: 0x22D
	Parameters: 7
	Flags: None
*/
function emit_smoke(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 1:
		{
			self.var_c9da3e70 = playFX(localClientNum, level._effect["smoke_standard"], self.origin, AnglesToForward(self.angles), anglesToUp(self.angles));
			break;
		}
		case 2:
		{
			self.var_c9da3e70 = playFX(localClientNum, level._effect["smoke_wall"], self.origin, AnglesToForward(self.angles), anglesToUp(self.angles));
			break;
		}
		case 3:
		{
			self.var_c9da3e70 = playFX(localClientNum, level._effect["smoke_geyser"], self.origin, AnglesToForward(self.angles), anglesToUp(self.angles));
			break;
		}
		case 0:
		{
			self notify("hash_b9956414");
			if(isdefined(self.var_c9da3e70))
			{
				deletefx(localClientNum, self.var_c9da3e70, 0);
			}
			break;
		}
		case default:
		{
			/#
				Assert(0, "Dev Block strings are not supported");
			#/
			break;
		}
	}
}

/*
	Name: function_ed6c6bcf
	Namespace: zm_genesis_util
	Checksum: 0x582360A5
	Offset: 0xF28
	Size: 0xD9
	Parameters: 3
	Flags: None
*/
function function_ed6c6bcf(localClientNum, str_fx_name, var_bec640ba)
{
	self endon("hash_b9956414");
	v_forward = AnglesToForward(self.angles);
	v_up = anglesToUp(self.angles);
	while(1)
	{
		self.var_c9da3e70 = playFX(localClientNum, level._effect[str_fx_name], self.origin, v_forward, v_up);
		wait(var_bec640ba + RandomFloatRange(0, 0.3));
	}
}

/*
	Name: function_9dca8db5
	Namespace: zm_genesis_util
	Checksum: 0xC37E986D
	Offset: 0x1010
	Size: 0x185
	Parameters: 7
	Flags: None
*/
function function_9dca8db5(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	switch(newVal)
	{
		case 0:
		{
			self function_379d49e8(localClientNum);
			break;
		}
		case 1:
		{
			self.var_39d354b5 = PlayFXOnTag(localClientNum, level._effect["fire_ground_spotfire"], self, "tag_origin");
			break;
		}
		case 2:
		{
			self thread function_379d49e8(localClientNum, 1);
			self.var_39d354b5 = PlayFXOnTag(localClientNum, level._effect["fire_ground_spotfire_smoke"], self, "tag_origin");
			break;
		}
		case 3:
		{
			self function_379d49e8(localClientNum);
			self.var_39d354b5 = PlayFXOnTag(localClientNum, level._effect["fire_moving_fire_trap"], self, "tag_origin");
			break;
		}
	}
}

/*
	Name: function_379d49e8
	Namespace: zm_genesis_util
	Checksum: 0xEAF8A08
	Offset: 0x11A0
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function function_379d49e8(localClientNum, n_delay)
{
	if(!isdefined(n_delay))
	{
		n_delay = 0;
	}
	self endon("entityshutdown");
	wait(n_delay);
	if(isdefined(self.var_39d354b5))
	{
		deletefx(localClientNum, self.var_39d354b5, 0);
	}
}

/*
	Name: fire_trap_ignite_enemy
	Namespace: zm_genesis_util
	Checksum: 0x9AEE19BC
	Offset: 0x1210
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function fire_trap_ignite_enemy(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		PlayFXOnTag(localClientNum, level._effect["fire_ignite_zombie"], self, "J_SpineUpper");
	}
}

/*
	Name: function_267f859f
	Namespace: zm_genesis_util
	Checksum: 0xB278C18
	Offset: 0x1290
	Size: 0x18F
	Parameters: 5
	Flags: None
*/
function function_267f859f(localClientNum, fx_id, b_on, b_is_ent, str_tag)
{
	if(!isdefined(fx_id))
	{
		fx_id = undefined;
	}
	if(!isdefined(b_on))
	{
		b_on = 1;
	}
	if(!isdefined(b_is_ent))
	{
		b_is_ent = 0;
	}
	if(!isdefined(str_tag))
	{
		str_tag = "tag_origin";
	}
	if(!isdefined(self.vfx_ref))
	{
		self.vfx_ref = [];
	}
	if(b_on)
	{
		if(!isdefined(self))
		{
			return;
		}
		if(isdefined(self.vfx_ref[localClientNum]))
		{
			stopfx(localClientNum, self.vfx_ref[localClientNum]);
		}
		if(b_is_ent)
		{
			self.vfx_ref[localClientNum] = PlayFXOnTag(localClientNum, fx_id, self, str_tag);
		}
		else
		{
			self.vfx_ref[localClientNum] = playFX(localClientNum, fx_id, self.origin, self.angles);
		}
	}
	else if(isdefined(self.vfx_ref[localClientNum]))
	{
		stopfx(localClientNum, self.vfx_ref[localClientNum]);
		self.vfx_ref[localClientNum] = undefined;
	}
}

/*
	Name: rq_gateworm_magic
	Namespace: zm_genesis_util
	Checksum: 0xBD27B902
	Offset: 0x1428
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function rq_gateworm_magic(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.var_7bd93049 = PlayFXOnTag(localClientNum, level._effect["rq_gateworm_dissolve"], self, "tag_origin");
		self thread rq_gateworm_dissolve(localClientNum, "scriptVector2");
	}
	else if(isdefined(self.var_7bd93049))
	{
		KillFX(localClientNum, self.var_1ac96e93);
	}
	PlayFXOnTag(localClientNum, level._effect["rq_gateworm_magic_explo"], self, "j_head_1");
}

/*
	Name: rq_gateworm_dissolve
	Namespace: zm_genesis_util
	Checksum: 0x190937AE
	Offset: 0x1530
	Size: 0x13F
	Parameters: 2
	Flags: None
*/
function rq_gateworm_dissolve(localClientNum, var_9304bb31)
{
	self endon("entityshutdown");
	n_start_time = GetTime();
	n_end_time = n_start_time + 2 * 1000;
	b_is_updating = 1;
	while(b_is_updating)
	{
		n_time = GetTime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_time);
		}
		self MapShaderConstant(localClientNum, 0, var_9304bb31, n_shader_value, 0, 0);
		wait(0.01);
	}
}

/*
	Name: rq_gateworm_dissolve_finish
	Namespace: zm_genesis_util
	Checksum: 0xF8D076E9
	Offset: 0x1678
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function rq_gateworm_dissolve_finish(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self thread rq_gateworm_dissolve(localClientNum, "scriptVector0");
}

/*
	Name: rq_rune_glow
	Namespace: zm_genesis_util
	Checksum: 0xFC55F258
	Offset: 0x16E0
	Size: 0x135
	Parameters: 7
	Flags: None
*/
function rq_rune_glow(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.var_fc9c3ea1 = PlayFXOnTag(localClientNum, level._effect["rq_rune_glow"], self, "tag_origin");
		self playsound(0, "zmb_main_searchparty_rune_appear");
		if(!isdefined(self.var_a20d5c5c))
		{
			self.var_a20d5c5c = self PlayLoopSound("zmb_main_searchparty_rune_lp", 1);
		}
	}
	else if(isdefined(self.n_fx))
	{
		KillFX(localClientNum, self.var_fc9c3ea1);
	}
	if(isdefined(self.var_a20d5c5c))
	{
		self StopLoopSound(self.var_a20d5c5c);
		self.var_a20d5c5c = undefined;
	}
}

