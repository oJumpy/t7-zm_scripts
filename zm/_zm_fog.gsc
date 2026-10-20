#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_utility;

#namespace zm_fog;

/*
	Name: __init__sytem__
	Namespace: zm_fog
	Checksum: 0x706D9577
	Offset: 0x180
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_fog", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_fog
	Checksum: 0x9AA1599C
	Offset: 0x1C8
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("world", "globalfog_bank", 15000, 2, "int");
	clientfield::register("world", "litfog_scriptid_to_edit", 15000, 4, "int");
	clientfield::register("world", "litfog_bank", 15000, 2, "int");
}

/*
	Name: __main__
	Namespace: zm_fog
	Checksum: 0xC6B3E7A5
	Offset: 0x268
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function __main__()
{
	SetDvar("fogtest_litfog_scriptid", 0);
	level.var_f87fe25d = [];
	level.var_9814fc19 = 0;
	level thread devgui_fog();
}

/*
	Name: function_b8a83a11
	Namespace: zm_fog
	Checksum: 0xDD9F0AF1
	Offset: 0x2C0
	Size: 0x115
	Parameters: 1
	Flags: None
*/
function function_b8a83a11(var_1cafad33)
{
	/#
		Assert(isdefined(level.var_f87fe25d[var_1cafad33]), "Dev Block strings are not supported" + var_1cafad33 + "Dev Block strings are not supported");
	#/
	var_f832704f = level.var_f87fe25d[var_1cafad33];
	if(isdefined(var_f832704f.var_400d18c9))
	{
		function_facb5f71(var_f832704f.var_400d18c9);
	}
	if(isdefined(var_f832704f.var_67098efc))
	{
		for(i = 0; i < var_f832704f.var_67098efc.size; i++)
		{
			if(isdefined(var_f832704f.var_67098efc[i]))
			{
				function_bd594680(i, var_f832704f.var_67098efc[i]);
			}
		}
	}
}

/*
	Name: function_848b74be
	Namespace: zm_fog
	Checksum: 0xB1BBE4E6
	Offset: 0x3E0
	Size: 0x67
	Parameters: 2
	Flags: None
*/
function function_848b74be(var_1cafad33, var_400d18c9)
{
	if(!isdefined(level.var_f87fe25d[var_1cafad33]))
	{
		level.var_f87fe25d[var_1cafad33] = spawnstruct();
	}
	level.var_f87fe25d[var_1cafad33].var_400d18c9 = var_400d18c9;
}

/*
	Name: function_e920efc6
	Namespace: zm_fog
	Checksum: 0x647105
	Offset: 0x450
	Size: 0xAD
	Parameters: 3
	Flags: None
*/
function function_e920efc6(var_1cafad33, n_scriptid, var_ab3af963)
{
	if(!isdefined(level.var_f87fe25d[var_1cafad33]))
	{
		level.var_f87fe25d[var_1cafad33] = spawnstruct();
	}
	if(!isdefined(level.var_f87fe25d[var_1cafad33].var_67098efc))
	{
		level.var_f87fe25d[var_1cafad33].var_67098efc = [];
	}
	level.var_f87fe25d[var_1cafad33].var_67098efc[n_scriptid] = var_ab3af963;
}

/*
	Name: function_facb5f71
	Namespace: zm_fog
	Checksum: 0xB1D29C8D
	Offset: 0x508
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_facb5f71(var_400d18c9)
{
	clientfield::set("globalfog_bank", var_400d18c9);
}

/*
	Name: function_bd594680
	Namespace: zm_fog
	Checksum: 0x669D8E70
	Offset: 0x540
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function function_bd594680(n_scriptid, n_bank)
{
	clientfield::set("litfog_scriptid_to_edit", n_scriptid);
	util::wait_network_frame();
	clientfield::set("litfog_bank", n_bank);
}

/*
	Name: setup_devgui_func
	Namespace: zm_fog
	Checksum: 0x54E78503
	Offset: 0x5B0
	Size: 0x11F
	Parameters: 5
	Flags: None
*/
function setup_devgui_func(str_devgui_path, str_dvar, n_value, func, n_base_value)
{
	if(!isdefined(n_base_value))
	{
		n_base_value = -1;
	}
	SetDvar(str_dvar, n_base_value);
	AddDebugCommand("devgui_cmd "" + str_devgui_path + "" "" + str_dvar + " " + n_value + "" ");
	while(1)
	{
		n_dvar = GetDvarInt(str_dvar);
		if(n_dvar > n_base_value)
		{
			[[func]](n_dvar);
			SetDvar(str_dvar, n_base_value);
		}
		util::wait_network_frame();
	}
}

/*
	Name: devgui_fog
	Namespace: zm_fog
	Checksum: 0x2C08B2B
	Offset: 0x6D8
	Size: 0x115
	Parameters: 0
	Flags: None
*/
function devgui_fog()
{
	/#
		for(i = 0; i < 4; i++)
		{
			level thread setup_devgui_func("Dev Block strings are not supported" + i, "Dev Block strings are not supported", i, &function_3dec91b9);
		}
		for(i = 0; i < 16; i++)
		{
			level thread setup_devgui_func("Dev Block strings are not supported" + i, "Dev Block strings are not supported", i, &function_49720b6e);
		}
		for(i = 1; i <= 4; i++)
		{
			level thread setup_devgui_func("Dev Block strings are not supported" + i, "Dev Block strings are not supported", i, &function_124286f7);
		}
	#/
}

/*
	Name: function_3dec91b9
	Namespace: zm_fog
	Checksum: 0xA1C2A2E8
	Offset: 0x7F8
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function function_3dec91b9(n_val)
{
	/#
		IPrintLnBold("Dev Block strings are not supported" + n_val);
		function_facb5f71(n_val);
	#/
}

/*
	Name: function_49720b6e
	Namespace: zm_fog
	Checksum: 0xEE07C534
	Offset: 0x850
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_49720b6e(n_val)
{
	/#
		level.var_9814fc19 = n_val;
		IPrintLnBold("Dev Block strings are not supported" + n_val);
	#/
}

/*
	Name: function_124286f7
	Namespace: zm_fog
	Checksum: 0x6BBD5C4F
	Offset: 0x898
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_124286f7(n_val)
{
	/#
		IPrintLnBold("Dev Block strings are not supported" + level.var_9814fc19 + "Dev Block strings are not supported" + n_val);
		function_bd594680(level.var_9814fc19, n_val - 1);
	#/
}

