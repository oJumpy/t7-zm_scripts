#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;

#namespace zm_perk_random;

/*
	Name: __init__sytem__
	Namespace: zm_perk_random
	Checksum: 0x580E7367
	Offset: 0x3E8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_random", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_random
	Checksum: 0x90AF070D
	Offset: 0x428
	Size: 0x2F9
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "perk_bottle_cycle_state", 5000, 2, "int", &start_bottle_cycling, 0, 0);
	clientfield::register("zbarrier", "set_client_light_state", 5000, 2, "int", &set_light_state, 0, 0);
	clientfield::register("zbarrier", "init_perk_random_machine", 5000, 1, "int", &perk_random_machine_init, 0, 0);
	clientfield::register("zbarrier", "client_stone_emmissive_blink", 5000, 1, "int", &perk_random_machine_rock_emissive, 0, 0);
	clientfield::register("scriptmover", "turn_active_perk_light_green", 5000, 1, "int", &turn_on_active_light_green, 0, 0);
	clientfield::register("scriptmover", "turn_on_location_indicator", 5000, 1, "int", &turn_on_location_indicator, 0, 0);
	clientfield::register("zbarrier", "lightning_bolt_FX_toggle", 10000, 1, "int", &lightning_bolt_fx_toggle, 0, 0);
	clientfield::register("scriptmover", "turn_active_perk_ball_light", 5000, 1, "int", &turn_on_active_ball_light, 0, 0);
	clientfield::register("scriptmover", "zone_captured", 5000, 1, "int", &zone_captured_cb, 0, 0);
	level._effect["perk_machine_light_yellow"] = "dlc1/castle/fx_wonder_fizz_light_yellow";
	level._effect["perk_machine_light_red"] = "dlc1/castle/fx_wonder_fizz_light_red";
	level._effect["perk_machine_light_green"] = "dlc1/castle/fx_wonder_fizz_light_green";
	level._effect["perk_machine_location"] = "zombie/fx_wonder_fizz_lightning_all";
}

/*
	Name: init_animtree
	Namespace: zm_perk_random
	Checksum: 0x99EC1590
	Offset: 0x730
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function init_animtree()
{
}

/*
	Name: turn_on_location_indicator
	Namespace: zm_perk_random
	Checksum: 0x5F75A0CF
	Offset: 0x740
	Size: 0x3B
	Parameters: 7
	Flags: None
*/
function turn_on_location_indicator(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
}

/*
	Name: lightning_bolt_fx_toggle
	Namespace: zm_perk_random
	Checksum: 0x88703C4
	Offset: 0x788
	Size: 0x1A9
	Parameters: 7
	Flags: None
*/
function lightning_bolt_fx_toggle(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(IsDemoPlaying() && GetDemoVersion() < 17)
	{
		return;
	}
	self notify("lightning_bolt_fx_toggle" + localClientNum);
	self endon("lightning_bolt_fx_toggle" + localClientNum);
	player = GetLocalPlayer(localClientNum);
	player endon("entityshutdown");
	if(!isdefined(self._location_indicator))
	{
		self._location_indicator = [];
	}
	while(1)
	{
		if(newVal == 1 && !IsIGCActive(localClientNum))
		{
			if(!isdefined(self._location_indicator[localClientNum]))
			{
				self._location_indicator[localClientNum] = playFX(localClientNum, level._effect["perk_machine_location"], self.origin);
			}
		}
		else if(isdefined(self._location_indicator[localClientNum]))
		{
			stopfx(localClientNum, self._location_indicator[localClientNum]);
			self._location_indicator[localClientNum] = undefined;
		}
		wait(1);
	}
}

/*
	Name: zone_captured_cb
	Namespace: zm_perk_random
	Checksum: 0xF3A48CA6
	Offset: 0x940
	Size: 0xD3
	Parameters: 7
	Flags: None
*/
function zone_captured_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(self.mapped_const))
	{
		self MapShaderConstant(localClientNum, 1, "ScriptVector0");
		self.mapped_const = 1;
	}
	if(newVal == 1)
	{
	}
	else
	{
		self.artifact_glow_setting = 1;
		self.machinery_glow_setting = 0;
		self SetShaderConstant(localClientNum, 1, self.artifact_glow_setting, 0, self.machinery_glow_setting, 0);
	}
}

/*
	Name: perk_random_machine_rock_emissive
	Namespace: zm_perk_random
	Checksum: 0xC7BD1009
	Offset: 0xA20
	Size: 0xB7
	Parameters: 7
	Flags: None
*/
function perk_random_machine_rock_emissive(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		piece = self ZBarrierGetPiece(3);
		piece.blinking = 1;
		piece thread rock_emissive_think(localClientNum);
	}
	else if(newVal == 0)
	{
		self.blinking = 0;
	}
}

/*
	Name: rock_emissive_think
	Namespace: zm_perk_random
	Checksum: 0x532378E9
	Offset: 0xAE0
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function rock_emissive_think(localClientNum)
{
	level endon("demo_jump");
	while(isdefined(self.blinking) && self.blinking)
	{
		self rock_emissive_fade(localClientNum, 8, 0);
		self rock_emissive_fade(localClientNum, 0, 8);
	}
}

/*
	Name: rock_emissive_fade
	Namespace: zm_perk_random
	Checksum: 0x22128F03
	Offset: 0xB58
	Size: 0x18F
	Parameters: 3
	Flags: None
*/
function rock_emissive_fade(localClientNum, n_max_val, n_min_val)
{
	n_start_time = GetTime();
	n_end_time = n_start_time + 0.5 * 1000;
	b_is_updating = 1;
	while(b_is_updating)
	{
		n_time = GetTime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, n_min_val, n_max_val, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, n_min_val, n_max_val, n_time);
		}
		if(isdefined(self))
		{
			self MapShaderConstant(localClientNum, 0, "scriptVector2", n_shader_value, 0, 0);
			self MapShaderConstant(localClientNum, 0, "scriptVector0", 0, n_shader_value, 0);
			self MapShaderConstant(localClientNum, 0, "scriptVector0", 0, 0, n_shader_value);
		}
		wait(0.01);
	}
}

/*
	Name: perk_random_machine_init
	Namespace: zm_perk_random
	Checksum: 0x8A84A10F
	Offset: 0xCF0
	Size: 0xA9
	Parameters: 7
	Flags: Private
*/
function private perk_random_machine_init(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.perk_random_machine_fx))
	{
		return;
	}
	if(!isdefined(self))
	{
		return;
	}
	self.perk_random_machine_fx = [];
	self.perk_random_machine_fx["tag_animate" + 1] = [];
	self.perk_random_machine_fx["tag_animate" + 2] = [];
	self.perk_random_machine_fx["tag_animate" + 3] = [];
}

/*
	Name: set_light_state
	Namespace: zm_perk_random
	Checksum: 0x19987032
	Offset: 0xDA8
	Size: 0x193
	Parameters: 7
	Flags: None
*/
function set_light_state(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	a_n_piece_indices = Array(1, 2, 3);
	foreach(n_piece_index in a_n_piece_indices)
	{
		if(newVal == 0)
		{
			perk_random_machine_play_fx(localClientNum, n_piece_index, "tag_animate", undefined);
			continue;
		}
		if(newVal == 3)
		{
			perk_random_machine_play_fx(localClientNum, n_piece_index, "tag_animate", level._effect["perk_machine_light_red"]);
			continue;
		}
		if(newVal == 1)
		{
			perk_random_machine_play_fx(localClientNum, n_piece_index, "tag_animate", level._effect["perk_machine_light_green"]);
			continue;
		}
	}
}

/*
	Name: perk_random_machine_play_fx
	Namespace: zm_perk_random
	Checksum: 0x2AE12CE6
	Offset: 0xF48
	Size: 0x11B
	Parameters: 5
	Flags: Private
*/
function private perk_random_machine_play_fx(localClientNum, piece_index, tag, FX, deleteImmediate)
{
	if(!isdefined(deleteImmediate))
	{
		deleteImmediate = 1;
	}
	piece = self ZBarrierGetPiece(piece_index);
	if(isdefined(self.perk_random_machine_fx[tag + piece_index][localClientNum]))
	{
		deletefx(localClientNum, self.perk_random_machine_fx[tag + piece_index][localClientNum], deleteImmediate);
		self.perk_random_machine_fx[tag + piece_index][localClientNum] = undefined;
	}
	if(isdefined(FX))
	{
		self.perk_random_machine_fx[tag + piece_index][localClientNum] = PlayFXOnTag(localClientNum, FX, piece, tag);
	}
}

/*
	Name: turn_on_active_light_green
	Namespace: zm_perk_random
	Checksum: 0x7527AC28
	Offset: 0x1070
	Size: 0x97
	Parameters: 7
	Flags: None
*/
function turn_on_active_light_green(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.artifact_glow_setting = 1;
		self.machinery_glow_setting = 0.7;
		self SetShaderConstant(localClientNum, 1, self.artifact_glow_setting, 0, self.machinery_glow_setting, 0);
	}
}

/*
	Name: turn_on_active_ball_light
	Namespace: zm_perk_random
	Checksum: 0xDFBC9EAD
	Offset: 0x1110
	Size: 0x97
	Parameters: 7
	Flags: None
*/
function turn_on_active_ball_light(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.artifact_glow_setting = 1;
		self.machinery_glow_setting = 1;
		self SetShaderConstant(localClientNum, 1, self.artifact_glow_setting, 0, self.machinery_glow_setting, 0);
	}
}

/*
	Name: start_bottle_cycling
	Namespace: zm_perk_random
	Checksum: 0x771694BA
	Offset: 0x11B0
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function start_bottle_cycling(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self thread start_vortex_fx(localClientNum);
	}
	else
	{
		self thread stop_vortex_fx(localClientNum);
	}
}

/*
	Name: start_vortex_fx
	Namespace: zm_perk_random
	Checksum: 0x16E25DB2
	Offset: 0x1240
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function start_vortex_fx(localClientNum)
{
	self endon("activation_electricity_finished");
	self endon("entityshutdown");
	if(!isdefined(self.glow_location))
	{
		self.glow_location = spawn(localClientNum, self.origin, "script_model");
		self.glow_location.angles = self.angles;
		self.glow_location SetModel("tag_origin");
	}
	self thread fx_activation_electric_loop(localClientNum);
	self thread fx_artifact_pulse_thread(localClientNum);
	wait(0.5);
	self thread fx_bottle_cycling(localClientNum);
}

/*
	Name: stop_vortex_fx
	Namespace: zm_perk_random
	Checksum: 0xB8CAD584
	Offset: 0x1330
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function stop_vortex_fx(localClientNum)
{
	self endon("entityshutdown");
	self notify("bottle_cycling_finished");
	wait(0.5);
	if(!isdefined(self))
	{
		return;
	}
	self notify("activation_electricity_finished");
	if(isdefined(self.glow_location))
	{
		self.glow_location delete();
	}
	self.artifact_glow_setting = 1;
	self.machinery_glow_setting = 0.7;
	self SetShaderConstant(localClientNum, 1, self.artifact_glow_setting, 0, self.machinery_glow_setting, 0);
}

/*
	Name: fx_artifact_pulse_thread
	Namespace: zm_perk_random
	Checksum: 0x2EB00F8E
	Offset: 0x13F0
	Size: 0xFF
	Parameters: 1
	Flags: None
*/
function fx_artifact_pulse_thread(localClientNum)
{
	self endon("activation_electricity_finished");
	self endon("entityshutdown");
	while(isdefined(self))
	{
		shader_amount = sin(GetRealTime() * 0.2);
		if(shader_amount < 0)
		{
			shader_amount = shader_amount * -1;
		}
		shader_amount = 0.75 - shader_amount * 0.75;
		self.artifact_glow_setting = shader_amount;
		self.machinery_glow_setting = 1;
		self SetShaderConstant(localClientNum, 1, self.artifact_glow_setting, 0, self.machinery_glow_setting, 0);
		wait(0.05);
	}
}

/*
	Name: fx_activation_electric_loop
	Namespace: zm_perk_random
	Checksum: 0xC98C9B46
	Offset: 0x14F8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function fx_activation_electric_loop(localClientNum)
{
	self endon("activation_electricity_finished");
	self endon("entityshutdown");
	while(1)
	{
		wait(0.1);
	}
}

/*
	Name: fx_bottle_cycling
	Namespace: zm_perk_random
	Checksum: 0x583A710
	Offset: 0x1548
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function fx_bottle_cycling(localClientNum)
{
	self endon("bottle_cycling_finished");
	while(1)
	{
		wait(0.1);
	}
}

