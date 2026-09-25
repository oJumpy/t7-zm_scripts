#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#namespace namespace_b025d12c;

/*
	Name: function_7944a602
	Namespace: namespace_b025d12c
	Checksum: 0x7FD9638B
	Offset: 0x238
	Size: 0x1E3
	Parameters: 6
	Flags: None
*/
function function_7944a602(var_d42f02cf, script_int, var_76ed2e72, func, arg1, var_e4d75d16)
{
	if(!isdefined(var_e4d75d16))
	{
		var_e4d75d16 = 0;
	}
	var_20b0fc79 = GetEntArray("stair_control", "targetname");
	var_20b0fc79 = Array::filter(var_20b0fc79, 0, &function_1bfbfa4c, var_d42f02cf);
	self.var_8b97288d = var_20b0fc79[var_e4d75d16];
	var_61b625c6 = GetEntArray("stair_control_usetrigger", "targetname");
	var_61b625c6 = Array::filter(var_61b625c6, 0, &function_1bfbfa4c, var_d42f02cf);
	self.var_d461052a = var_61b625c6[var_e4d75d16];
	self.var_d461052a setHintString(&"ZM_ZOD_POWERSWITCH_UNPOWERED");
	self.var_19295d02 = script_int;
	self.var_e289acc3 = func;
	self.var_20a1be38 = arg1;
	self.var_d461052a EnableLinkTo();
	self.var_d461052a LinkTo(self.var_8b97288d);
	if(isdefined(var_76ed2e72))
	{
		self.var_8b97288d LinkTo(var_76ed2e72);
	}
	self thread function_5e9f96b6();
}

/*
	Name: function_1bfbfa4c
	Namespace: namespace_b025d12c
	Checksum: 0xECC657E
	Offset: 0x428
	Size: 0x47
	Parameters: 2
	Flags: None
*/
function function_1bfbfa4c(e_entity, var_d42f02cf)
{
	if(!isdefined(e_entity.script_string) || e_entity.script_string != var_d42f02cf)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_5e9f96b6
	Namespace: namespace_b025d12c
	Checksum: 0x2E261650
	Offset: 0x478
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_5e9f96b6()
{
	level flag::wait_till("power_on" + self.var_19295d02);
	local_power_on();
}

/*
	Name: function_3d8cc198
	Namespace: namespace_b025d12c
	Checksum: 0xCA7F8CCA
	Offset: 0x4C0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function function_3d8cc198()
{
	self.var_d461052a SetInvisibleToAll();
}

/*
	Name: function_68132e8f
	Namespace: namespace_b025d12c
	Checksum: 0x7076DE93
	Offset: 0x4E8
	Size: 0x45
	Parameters: 1
	Flags: None
*/
function function_68132e8f(player)
{
	if(player zm_utility::in_revive_trigger())
	{
		return 0;
	}
	if(player.IS_DRINKING > 0)
	{
		return 0;
	}
	return 1;
}

/*
	Name: local_power_on
	Namespace: namespace_b025d12c
	Checksum: 0xE984FEA1
	Offset: 0x538
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function local_power_on()
{
	self.var_d461052a setHintString(&"ZM_ZOD_POWERSWITCH_POWERED");
	do
	{
		self.var_d461052a waittill("trigger", player);
	}
	while(!!function_68132e8f(player));
	self.var_d461052a SetInvisibleToAll();
	[[self.var_e289acc3]](self.var_20a1be38);
}

/*
	Name: function_9b385ca5
	Namespace: namespace_b025d12c
	Checksum: 0x99EC1590
	Offset: 0x5D8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
}

/*
	Name: function_5fba2032
	Namespace: namespace_b025d12c
	Checksum: 0x99EC1590
	Offset: 0x5E8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

#namespace namespace_f7e00735;

/*
	Name: function_b025d12c
	Namespace: namespace_f7e00735
	Checksum: 0x9F3040A8
	Offset: 0x5F8
	Size: 0x1A5
	Parameters: 0
	Flags: 6
*/
function private autoexec function_b025d12c()
{
	classes.var_b025d12c[0] = spawnstruct();
	classes.var_b025d12c[0].__vtable[1606033458] = &namespace_b025d12c::function_5fba2032;
	classes.var_b025d12c[0].__vtable[-1690805083] = &namespace_b025d12c::function_9b385ca5;
	classes.var_b025d12c[0].__vtable[1961570100] = &namespace_b025d12c::local_power_on;
	classes.var_b025d12c[0].__vtable[1746087567] = &namespace_b025d12c::function_68132e8f;
	classes.var_b025d12c[0].__vtable[1032634776] = &namespace_b025d12c::function_3d8cc198;
	classes.var_b025d12c[0].__vtable[1587517110] = &namespace_b025d12c::function_5e9f96b6;
	classes.var_b025d12c[0].__vtable[469498444] = &namespace_b025d12c::function_1bfbfa4c;
	classes.var_b025d12c[0].__vtable[2034542082] = &namespace_b025d12c::function_7944a602;
}

