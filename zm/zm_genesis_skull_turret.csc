#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\beam_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_genesis_skull_turret;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_skull_turret
	Checksum: 0x83B9515A
	Offset: 0x4B8
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_skull_turret", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_skull_turret
	Checksum: 0x8BF4825
	Offset: 0x500
	Size: 0x205
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("vehicle", "skull_turret", 15000, 2, "int", &function_aeaa2ee6, 0, 0);
	clientfield::register("vehicle", "skull_turret_beam_fire", 15000, 1, "int", &skull_turret_beam_fire, 0, 0);
	clientfield::register("vehicle", "turret_beam_fire_crystal", 15000, 1, "int", &function_a70748cf, 0, 0);
	clientfield::register("actor", "skull_turret_shock_fx", 15000, 1, "int", &skull_turret_shock_fx, 0, 0);
	clientfield::register("actor", "skull_turret_shock_eye_fx", 15000, 1, "int", &skull_turret_shock_eye_fx, 0, 0);
	clientfield::register("actor", "skull_turret_explode_fx", 15000, 1, "counter", &skull_turret_explode_fx, 0, 0);
	level._effect["turret_zombie_shock"] = "dlc4/genesis/fx_tesla_trap_body_shock_red";
	level._effect["turret_zombie_explode"] = "dlc4/genesis/fx_tesla_trap_body_exp_red";
	level._effect["skull_turret_shock_eyes"] = "dlc4/genesis/fx_tesla_shock_eyes_zmb_red";
}

/*
	Name: __main__
	Namespace: zm_genesis_skull_turret
	Checksum: 0x99EC1590
	Offset: 0x710
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __main__()
{
}

/*
	Name: function_aeaa2ee6
	Namespace: zm_genesis_skull_turret
	Checksum: 0x273334EC
	Offset: 0x720
	Size: 0xD3
	Parameters: 7
	Flags: None
*/
function function_aeaa2ee6(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_6818044b(localClientNum, newVal);
	if(newVal)
	{
		var_fcb37269 = 1;
		tint = 0;
		if(newVal > 1)
		{
			tint = 1;
		}
		self thread function_6e443da4(localClientNum, var_fcb37269, tint);
	}
	else
	{
		self thread function_6e443da4(localClientNum, 0, 0);
	}
}

/*
	Name: function_6e443da4
	Namespace: zm_genesis_skull_turret
	Checksum: 0xC8C460E5
	Offset: 0x800
	Size: 0x143
	Parameters: 3
	Flags: None
*/
function function_6e443da4(localClientNum, var_fcb37269, tint)
{
	self notify("hash_6e443da4");
	self endon("hash_6e443da4");
	if(!isdefined(self.var_392865b9))
	{
		self.var_392865b9 = 0;
	}
	while(self.var_392865b9 != var_fcb37269)
	{
		if(self.var_392865b9 < var_fcb37269)
		{
			self.var_392865b9 = self.var_392865b9 + 0.033;
			if(self.var_392865b9 > var_fcb37269)
			{
				self.var_392865b9 = var_fcb37269;
			}
		}
		else
		{
			self.var_392865b9 = self.var_392865b9 - 0.033;
			if(self.var_392865b9 < var_fcb37269)
			{
				self.var_392865b9 = var_fcb37269;
			}
		}
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, self.var_392865b9, tint, 0);
		wait(0.016);
	}
	self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, self.var_392865b9, tint, 0);
}

/*
	Name: skull_turret_beam_fire
	Namespace: zm_genesis_skull_turret
	Checksum: 0x9735CD0F
	Offset: 0x950
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function skull_turret_beam_fire(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	function_46870125(localClientNum, newVal);
	function_1046b72f(localClientNum);
	if(newVal)
	{
		self thread function_463d46bd(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
	}
}

/*
	Name: function_1046b72f
	Namespace: zm_genesis_skull_turret
	Checksum: 0x73B72C68
	Offset: 0xA00
	Size: 0x95
	Parameters: 1
	Flags: None
*/
function function_1046b72f(localClientNum)
{
	self notify("hash_f8e6601f");
	if(isdefined(self.var_f929ecf4))
	{
		function_6c8292ba(localClientNum);
		level beam::kill(self, "tag_flash", self.var_f929ecf4, "tag_origin", "dlc4_skull_turret_beam");
		self.var_f929ecf4 delete();
		self.var_f929ecf4 = undefined;
	}
}

/*
	Name: function_6c8292ba
	Namespace: zm_genesis_skull_turret
	Checksum: 0x9B123824
	Offset: 0xAA0
	Size: 0x7D
	Parameters: 1
	Flags: None
*/
function function_6c8292ba(localClientNum)
{
	if(isdefined(self.var_805863e3))
	{
		level beam::kill(self.var_f929ecf4, "tag_origin", self.var_805863e3, "tag_origin", self.var_4a0d7655);
		self.var_805863e3 delete();
		self.var_805863e3 = undefined;
		self.var_4a0d7655 = undefined;
	}
}

/*
	Name: function_1b1753c0
	Namespace: zm_genesis_skull_turret
	Checksum: 0x4B1A5672
	Offset: 0xB28
	Size: 0x15F
	Parameters: 3
	Flags: None
*/
function function_1b1753c0(localClientNum, origin, str_bounced)
{
	if(!isdefined(self.var_805863e3))
	{
		self.var_805863e3 = util::spawn_model(localClientNum, "tag_origin", origin);
		level beam::launch(self.var_f929ecf4, "tag_origin", self.var_805863e3, "tag_origin", str_bounced);
		self.var_4a0d7655 = str_bounced;
	}
	else if(self.var_4a0d7655 !== str_bounced)
	{
		level beam::kill(self.var_f929ecf4, "tag_origin", self.var_805863e3, "tag_origin", self.var_4a0d7655);
		self.var_805863e3.origin = origin;
		level beam::launch(self.var_f929ecf4, "tag_origin", self.var_805863e3, "tag_origin", str_bounced);
		self.var_4a0d7655 = str_bounced;
	}
	else
	{
		self.var_805863e3.origin = origin;
	}
}

/*
	Name: function_463d46bd
	Namespace: zm_genesis_skull_turret
	Checksum: 0xB8E72368
	Offset: 0xC90
	Size: 0xFF
	Parameters: 7
	Flags: None
*/
function function_463d46bd(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self notify("hash_f8e6601f");
	self endon("hash_f8e6601f");
	self.var_f929ecf4 = util::spawn_model(localClientNum, "tag_origin", self.origin);
	level beam::launch(self, "tag_flash", self.var_f929ecf4, "tag_origin", "dlc4_skull_turret_beam");
	while(isdefined(self))
	{
		function_b578a840(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
		wait(0.016);
	}
}

/*
	Name: function_b578a840
	Namespace: zm_genesis_skull_turret
	Checksum: 0x1B9F9D31
	Offset: 0xD98
	Size: 0x42B
	Parameters: 7
	Flags: None
*/
function function_b578a840(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	v_position = self GetTagOrigin("tag_aim");
	v_forward = AnglesToForward(self GetTagAngles("tag_aim"));
	a_trace = beamtrace(v_position, v_position + v_forward * 20000, 1, self);
	self.var_f929ecf4.origin = a_trace["position"];
	self.var_f929ecf4.angles = VectorToAngles(v_forward);
	function_cd048702(v_position, self.var_f929ecf4.origin, (1, 1, 0));
	render_debug_sphere(v_position, (1, 1, 0));
	render_debug_sphere(self.var_f929ecf4.origin, (1, 0, 0));
	var_c18b4417 = 0;
	if(isdefined(a_trace["entity"]))
	{
		e_last_target = a_trace["entity"];
		var_c18b4417 = 1;
		if(e_last_target.model === "p7_zm_ctl_crystal")
		{
			var_c18b4417 = 1;
		}
	}
	if(a_trace["surfacetype"] === "metal" || a_trace["surfacetype"] === "metalcar" || a_trace["surfacetype"] === "glass" || a_trace["surfacetype"] === "glasscar")
	{
		var_c18b4417 = 1;
	}
	if(var_c18b4417)
	{
		if(!isdefined(e_last_target) || (e_last_target.archetype !== "zombie" && e_last_target.archetype !== "parasite"))
		{
			v_forward = reflect_shot(v_forward, a_trace["normal"]);
		}
		self.var_f929ecf4.angles = VectorToAngles(v_forward);
		v_position = self.var_f929ecf4.origin;
		a_trace = beamtrace(v_position, v_position + v_forward * 20000, 1, self);
		str_bounced = "dlc4_skull_turret_beam_reflect";
		if(isdefined(e_last_target) && (e_last_target.archetype === "zombie" || e_last_target.archetype === "parasite"))
		{
			str_bounced = "dlc4_skull_turret_beam";
		}
		function_1b1753c0(localClientNum, a_trace["position"], str_bounced);
		function_cd048702(v_position, self.var_805863e3.origin, (1, 1, 0));
		render_debug_sphere(self.var_805863e3.origin, (1, 0, 0));
	}
	else
	{
		function_6c8292ba(localClientNum);
	}
}

/*
	Name: reflect_shot
	Namespace: zm_genesis_skull_turret
	Checksum: 0x7B2F3661
	Offset: 0x11D0
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function reflect_shot(d, n)
{
	perp = 2 * VectorDot(d, n);
	var_e47d2859 = d - perp * n;
	return var_e47d2859;
}

/*
	Name: render_debug_sphere
	Namespace: zm_genesis_skull_turret
	Checksum: 0x4B285FB
	Offset: 0x1240
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function render_debug_sphere(origin, color)
{
	if(GetDvarInt("turret_debug"))
	{
		/#
			sphere(origin, 2, color, 0.75, 1, 10, 100);
		#/
	}
}

/*
	Name: function_cd048702
	Namespace: zm_genesis_skull_turret
	Checksum: 0x82520E08
	Offset: 0x12B0
	Size: 0x63
	Parameters: 3
	Flags: None
*/
function function_cd048702(origin1, origin2, color)
{
	if(GetDvarInt("turret_debug"))
	{
		/#
			line(origin1, origin2, color, 0.75, 1, 100);
		#/
	}
}

/*
	Name: function_a70748cf
	Namespace: zm_genesis_skull_turret
	Checksum: 0xA90B8F75
	Offset: 0x1320
	Size: 0x75
	Parameters: 7
	Flags: None
*/
function function_a70748cf(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self thread function_9f90a4b0(localClientNum);
	}
	else
	{
		level notify("hash_bd0e918");
	}
}

/*
	Name: function_9f90a4b0
	Namespace: zm_genesis_skull_turret
	Checksum: 0xA26D3B1B
	Offset: 0x13A0
	Size: 0x283
	Parameters: 1
	Flags: None
*/
function function_9f90a4b0(localClientNum)
{
	a_s_crystals = struct::get_array("115_crystals", "script_noteworthy");
	s_target = ArrayGetClosest(self.origin, a_s_crystals);
	var_f929ecf4 = util::spawn_model(localClientNum, "tag_origin", s_target.origin);
	var_1d74a070 = struct::get("ee_beam_sophia", "targetname");
	var_b4e42dd3 = util::spawn_model(localClientNum, "tag_origin", var_1d74a070.origin, var_1d74a070.angles);
	level beam::launch(self, "tag_flash", var_f929ecf4, "tag_origin", "dlc4_skull_turret_beam");
	level beam::launch(var_f929ecf4, "tag_origin", var_b4e42dd3, "tag_origin", "dlc4_skull_turret_beam_reflect");
	audio::playloopat("wpn_skull_turret_loop", self.origin);
	level waittill("hash_bd0e918");
	audio::stoploopat("wpn_skull_turret_loop", self.origin);
	playsound(0, "wpn_skull_turret_stop", self.origin);
	level beam::kill(self, "tag_flash", var_f929ecf4, "tag_origin", "dlc4_skull_turret_beam");
	level beam::kill(var_f929ecf4, "tag_origin", var_b4e42dd3, "tag_origin", "dlc4_skull_turret_beam_reflect");
	var_f929ecf4 delete();
	var_b4e42dd3 delete();
}

/*
	Name: skull_turret_shock_fx
	Namespace: zm_genesis_skull_turret
	Checksum: 0x2F085B7F
	Offset: 0x1630
	Size: 0xFD
	Parameters: 7
	Flags: None
*/
function skull_turret_shock_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(!isdefined(self.var_2fdeee05))
		{
			str_tag = "J_SpineUpper";
			if(!self isai())
			{
				str_tag = "tag_origin";
			}
			self.var_2fdeee05 = PlayFXOnTag(localClientNum, level._effect["turret_zombie_shock"], self, str_tag);
		}
	}
	else if(isdefined(self.var_2fdeee05))
	{
		deletefx(localClientNum, self.var_2fdeee05, 1);
		self.var_2fdeee05 = undefined;
	}
}

/*
	Name: skull_turret_shock_eye_fx
	Namespace: zm_genesis_skull_turret
	Checksum: 0x6D1BA75
	Offset: 0x1738
	Size: 0x115
	Parameters: 7
	Flags: None
*/
function skull_turret_shock_eye_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		if(!isdefined(self.var_9724eab9))
		{
			self.var_9724eab9 = PlayFXOnTag(localClientNum, level._effect["skull_turret_shock_eyes"], self, "J_Eyeball_LE");
			sndOrigin = self GetTagOrigin("J_Eyeball_LE");
			playsound(0, "zmb_vocals_zombie_skull_scream", sndOrigin);
		}
	}
	else
	{
		deletefx(localClientNum, self.var_9724eab9, 1);
		self.var_9724eab9 = undefined;
	}
}

/*
	Name: skull_turret_explode_fx
	Namespace: zm_genesis_skull_turret
	Checksum: 0x61C0D840
	Offset: 0x1858
	Size: 0x93
	Parameters: 7
	Flags: None
*/
function skull_turret_explode_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayFXOnTag(localClientNum, level._effect["turret_zombie_explode"], self, "j_spine4");
	playsound(0, "zmb_zombie_skull_explode", self.origin);
}

/*
	Name: function_6818044b
	Namespace: zm_genesis_skull_turret
	Checksum: 0x15C4F34C
	Offset: 0x18F8
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function function_6818044b(localClientNum, var_365c612)
{
	if(isdefined(self.var_341294b1))
	{
		deletefx(localClientNum, self.var_341294b1);
		self.var_341294b1 = undefined;
	}
	if(var_365c612)
	{
		self.var_341294b1 = PlayFXOnTag(localClientNum, "dlc4/genesis/fx_skullturret_active", self, "tag_turret");
	}
}

/*
	Name: function_46870125
	Namespace: zm_genesis_skull_turret
	Checksum: 0x17EA1B06
	Offset: 0x1980
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function function_46870125(localClientNum, var_365c612)
{
	if(isdefined(self.var_dada95a7))
	{
		deletefx(localClientNum, self.var_dada95a7);
		self.var_dada95a7 = undefined;
	}
	if(var_365c612)
	{
		self.var_dada95a7 = PlayFXOnTag(localClientNum, "dlc4/genesis/fx_skullturret_eyes", self, "tag_fx");
	}
}

