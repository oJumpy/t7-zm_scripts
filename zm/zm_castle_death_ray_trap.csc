#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\beam_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace namespace_f2d05c13;

/*
	Name: main
	Namespace: namespace_f2d05c13
	Checksum: 0xE332F20F
	Offset: 0x3D8
	Size: 0x263
	Parameters: 0
	Flags: None
*/
function main()
{
	level._effect["console_green_light"] = "dlc1/castle/fx_glow_panel_green_castle";
	level._effect["console_red_light"] = "dlc1/castle/fx_glow_panel_red_castle";
	level._effect["tesla_zombie_shock"] = "dlc1/castle/fx_tesla_trap_body_shock";
	level._effect["tesla_zombie_explode"] = "dlc1/castle/fx_tesla_trap_body_exp";
	clientfield::register("actor", "death_ray_shock_fx", 5000, 1, "int", &function_3852b0a4, 0, 0);
	clientfield::register("actor", "death_ray_shock_eye_fx", 5000, 1, "int", &function_4513798e, 0, 0);
	clientfield::register("actor", "death_ray_explode_fx", 5000, 1, "counter", &function_499e2d1f, 0, 0);
	clientfield::register("scriptmover", "death_ray_status_light", 5000, 2, "int", &function_7939244, 0, 0);
	clientfield::register("actor", "tesla_beam_fx", 5000, 1, "counter", &function_200eea36, 0, 0);
	clientfield::register("toplayer", "tesla_beam_fx", 5000, 1, "counter", &function_200eea36, 0, 0);
	clientfield::register("actor", "tesla_beam_mechz", 5000, 1, "int", &function_1dc0fcb2, 0, 0);
}

/*
	Name: function_3852b0a4
	Namespace: namespace_f2d05c13
	Checksum: 0x7E36BEDB
	Offset: 0x648
	Size: 0x123
	Parameters: 7
	Flags: None
*/
function function_3852b0a4(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self function_51adc559(localClientNum);
	if(newVal)
	{
		if(!isdefined(self.var_8f44671e))
		{
			tag = "J_SpineUpper";
			if(!self isai())
			{
				tag = "tag_origin";
			}
			self.var_8f44671e = PlayFXOnTag(localClientNum, level._effect["tesla_zombie_shock"], self, tag);
			self playsound(0, "zmb_electrocute_zombie");
		}
		if(IsDemoPlaying())
		{
			self thread function_7772592b(localClientNum);
		}
	}
}

/*
	Name: function_7772592b
	Namespace: namespace_f2d05c13
	Checksum: 0xDC26AB0D
	Offset: 0x778
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function function_7772592b(localClientNum)
{
	self notify("hash_51adc559");
	self endon("hash_51adc559");
	level waittill("demo_jump");
	self function_51adc559(localClientNum);
}

/*
	Name: function_51adc559
	Namespace: namespace_f2d05c13
	Checksum: 0xB62D7854
	Offset: 0x7D0
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function function_51adc559(localClientNum)
{
	if(isdefined(self.var_8f44671e))
	{
		deletefx(localClientNum, self.var_8f44671e, 1);
		self.var_8f44671e = undefined;
	}
	self notify("hash_51adc559");
}

/*
	Name: function_4513798e
	Namespace: namespace_f2d05c13
	Checksum: 0x68D17467
	Offset: 0x830
	Size: 0xC5
	Parameters: 7
	Flags: None
*/
function function_4513798e(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		if(!isdefined(self.var_5f35d5e4))
		{
			self.var_5f35d5e4 = PlayFXOnTag(localClientNum, level._effect["death_ray_shock_eyes"], self, "J_Eyeball_LE");
		}
	}
	else
	{
		deletefx(localClientNum, self.var_5f35d5e4, 1);
		self.var_5f35d5e4 = undefined;
	}
}

/*
	Name: function_499e2d1f
	Namespace: namespace_f2d05c13
	Checksum: 0xC097A2B8
	Offset: 0x900
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_499e2d1f(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayFXOnTag(localClientNum, level._effect["tesla_zombie_explode"], self, "j_spine4");
}

/*
	Name: function_7939244
	Namespace: namespace_f2d05c13
	Checksum: 0x2CC74244
	Offset: 0x978
	Size: 0x17B
	Parameters: 7
	Flags: None
*/
function function_7939244(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	v_forward = AnglesToRight(self.angles);
	v_forward = v_forward * -1;
	v_up = anglesToUp(self.angles);
	if(isdefined(self.var_b99efa04))
	{
		deletefx(localClientNum, self.var_b99efa04, 1);
		self.var_b99efa04 = undefined;
	}
	switch(newVal)
	{
		case 0:
		{
			break;
		}
		case 1:
		{
			str_fx_name = "console_green_light";
			tag = "tag_fx_light_green";
			break;
		}
		case 2:
		{
			str_fx_name = "console_red_light";
			tag = "tag_fx_light_red";
			break;
		}
	}
	self.var_b99efa04 = PlayFXOnTag(localClientNum, level._effect[str_fx_name], self, tag);
}

/*
	Name: function_200eea36
	Namespace: namespace_f2d05c13
	Checksum: 0x1ABB6518
	Offset: 0xB00
	Size: 0x13B
	Parameters: 7
	Flags: None
*/
function function_200eea36(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_fda0d24 = [];
	Array::add(var_fda0d24, struct::get("bolt_source_1"), 0);
	Array::add(var_fda0d24, struct::get("bolt_source_2"), 0);
	s_source = ArrayGetClosest(self.origin, var_fda0d24);
	if(s_source.targetname === "bolt_source_1")
	{
		var_53106e7c = "electric_arc_beam_tesla_trap_1_primary";
	}
	else
	{
		var_53106e7c = "electric_arc_beam_tesla_trap_2_primary";
	}
	self thread function_ec4ecaed(localClientNum, s_source, var_53106e7c);
}

/*
	Name: function_ec4ecaed
	Namespace: namespace_f2d05c13
	Checksum: 0x4E3EE856
	Offset: 0xC48
	Size: 0xFB
	Parameters: 3
	Flags: None
*/
function function_ec4ecaed(localClientNum, s_source, var_53106e7c)
{
	var_e43465f2 = util::spawn_model(localClientNum, "tag_origin", s_source.origin, s_source.angles);
	level beam::launch(var_e43465f2, "tag_origin", self, "j_spinelower", var_53106e7c);
	level util::waittill_any_timeout(1.5, "demo_jump");
	level beam::kill(var_e43465f2, "tag_origin", self, "j_spinelower", var_53106e7c);
	var_e43465f2 delete();
}

/*
	Name: function_1dc0fcb2
	Namespace: namespace_f2d05c13
	Checksum: 0x8E946630
	Offset: 0xD50
	Size: 0x1D3
	Parameters: 7
	Flags: None
*/
function function_1dc0fcb2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		var_fda0d24 = [];
		Array::add(var_fda0d24, struct::get("bolt_source_1"), 0);
		Array::add(var_fda0d24, struct::get("bolt_source_2"), 0);
		s_source = ArrayGetClosest(self.origin, var_fda0d24);
		if(s_source.targetname === "bolt_source_1")
		{
			self.var_53106e7c = "electric_arc_beam_tesla_trap_1_primary";
		}
		else
		{
			self.var_53106e7c = "electric_arc_beam_tesla_trap_2_primary";
		}
		self.var_e43465f2 = util::spawn_model(localClientNum, "tag_origin", s_source.origin, s_source.angles);
		level beam::launch(self.var_e43465f2, "tag_origin", self, "j_spinelower", self.var_53106e7c);
		if(IsDemoPlaying())
		{
			self thread function_3c5fc735(localClientNum);
		}
	}
	else
	{
		function_1139a457(localClientNum);
	}
}

/*
	Name: function_3c5fc735
	Namespace: namespace_f2d05c13
	Checksum: 0xA92B0A90
	Offset: 0xF30
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function function_3c5fc735(localClientNum)
{
	self notify("hash_1139a457");
	self endon("hash_1139a457");
	level waittill("demo_jump");
	function_1139a457(localClientNum);
}

/*
	Name: function_1139a457
	Namespace: namespace_f2d05c13
	Checksum: 0x6EC0DC46
	Offset: 0xF88
	Size: 0x89
	Parameters: 1
	Flags: None
*/
function function_1139a457(localClientNum)
{
	if(isdefined(self.var_e43465f2) && isdefined(self.var_53106e7c))
	{
		level beam::kill(self.var_e43465f2, "tag_origin", self, "j_spinelower", self.var_53106e7c);
		self.var_e43465f2 delete();
		self.var_53106e7c = undefined;
		self notify("hash_1139a457");
	}
}

