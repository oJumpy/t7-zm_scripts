#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#namespace zm_zdraw;

/*
	Name: __init__sytem__
	Namespace: zm_zdraw
	Checksum: 0x40AE5D3
	Offset: 0x198
	Size: 0x43
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	/#
		system::register("Dev Block strings are not supported", &__init__, &__main__, undefined);
	#/
}

/*
	Name: __init__
	Namespace: zm_zdraw
	Checksum: 0xBCF0CE2D
	Offset: 0x1E8
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	/#
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		level.var_9cf5ce57 = spawnstruct();
		function_3e630288();
		function_aa8545fe();
		function_404ac348();
		level thread function_41fec76e();
	#/
}

/*
	Name: __main__
	Namespace: zm_zdraw
	Checksum: 0xEB8FACF
	Offset: 0x280
	Size: 0x7
	Parameters: 0
	Flags: None
*/
function __main__()
{
	/#
	#/
}

/*
	Name: function_3e630288
	Namespace: zm_zdraw
	Checksum: 0x634BD6E3
	Offset: 0x290
	Size: 0x3BD
	Parameters: 0
	Flags: None
*/
function function_3e630288()
{
	/#
		level.var_9cf5ce57.colors = [];
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = (1, 0, 0);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = (0, 1, 0);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = (0, 0, 1);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = (1, 1, 0);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = (1, 0.5, 0);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = (0, 1, 1);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = (1, 0, 1);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = (0, 0, 0);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = (1, 1, 1);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.75);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.1);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.2);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.3);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.4);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.5);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.6);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.7);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.8);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.9);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = (0.4392157, 0.5019608, 0.5647059);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = (1, 0.7529412, 0.7960784);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 0), 0.5019608);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = (0.5450981, 0.2705882, 0.07450981);
		level.var_9cf5ce57.colors["Dev Block strings are not supported"] = (1, 1, 1);
	#/
}

/*
	Name: function_aa8545fe
	Namespace: zm_zdraw
	Checksum: 0xF1BE390B
	Offset: 0x658
	Size: 0x1D5
	Parameters: 0
	Flags: None
*/
function function_aa8545fe()
{
	/#
		level.var_9cf5ce57.commands = [];
		level.var_9cf5ce57.commands["Dev Block strings are not supported"] = &function_5ef6cf9b;
		level.var_9cf5ce57.commands["Dev Block strings are not supported"] = &function_eae4114a;
		level.var_9cf5ce57.commands["Dev Block strings are not supported"] = &function_f2f3c18e;
		level.var_9cf5ce57.commands["Dev Block strings are not supported"] = &function_8f04ad79;
		level.var_9cf5ce57.commands["Dev Block strings are not supported"] = &function_a13efe1c;
		level.var_9cf5ce57.commands["Dev Block strings are not supported"] = &function_b3b92edc;
		level.var_9cf5ce57.commands["Dev Block strings are not supported"] = &function_8c2ca616;
		level.var_9cf5ce57.commands["Dev Block strings are not supported"] = &function_3145e33f;
		level.var_9cf5ce57.commands["Dev Block strings are not supported"] = &function_f36ec3d2;
		level.var_9cf5ce57.commands["Dev Block strings are not supported"] = &function_7bdd3089;
		level.var_9cf5ce57.commands["Dev Block strings are not supported"] = &function_be7cf134;
	#/
}

/*
	Name: function_404ac348
	Namespace: zm_zdraw
	Checksum: 0x6298CA10
	Offset: 0x838
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function function_404ac348()
{
	/#
		level.var_9cf5ce57.color = level.var_9cf5ce57.colors["Dev Block strings are not supported"];
		level.var_9cf5ce57.alpha = 1;
		level.var_9cf5ce57.scale = 1;
		level.var_9cf5ce57.duration = Int(1 * 62.5);
		level.var_9cf5ce57.radius = 8;
		level.var_9cf5ce57.sides = 10;
		level.var_9cf5ce57.var_5f3c7817 = (0, 0, 0);
		level.var_9cf5ce57.var_922ae5d = 0;
		level.var_9cf5ce57.var_c1953771 = "Dev Block strings are not supported";
	#/
}

/*
	Name: function_41fec76e
	Namespace: zm_zdraw
	Checksum: 0xC11A2415
	Offset: 0x938
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function function_41fec76e()
{
	/#
		level notify("hash_15f14510");
		level endon("hash_15f14510");
		for(;;)
		{
			cmd = GetDvarString("Dev Block strings are not supported");
			if(cmd.size)
			{
				function_404ac348();
				params = StrTok(cmd, "Dev Block strings are not supported");
				function_4282fd75(params, 0, 1);
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			wait(0.5);
		}
	#/
}

/*
	Name: function_4282fd75
	Namespace: zm_zdraw
	Checksum: 0xE3D442E7
	Offset: 0xA18
	Size: 0xE3
	Parameters: 3
	Flags: None
*/
function function_4282fd75(var_859cfb21, var_c0438d98, var_37cd5424)
{
	/#
		if(!isdefined(var_37cd5424))
		{
			var_37cd5424 = 0;
		}
		while(isdefined(var_859cfb21[var_c0438d98]))
		{
			if(isdefined(level.var_9cf5ce57.commands[var_859cfb21[var_c0438d98]]))
			{
				var_c0438d98 = [[level.var_9cf5ce57.commands[var_859cfb21[var_c0438d98]]]](var_859cfb21, var_c0438d98 + 1);
			}
			else if(isdefined(var_37cd5424) && var_37cd5424)
			{
				function_c69caf7e("Dev Block strings are not supported" + var_859cfb21[var_c0438d98]);
			}
			return var_c0438d98;
		}
		return var_c0438d98;
	#/
}

/*
	Name: function_7bdd3089
	Namespace: zm_zdraw
	Checksum: 0x3DCFCACE
	Offset: 0xB08
	Size: 0x16B
	Parameters: 2
	Flags: None
*/
function function_7bdd3089(var_859cfb21, var_c0438d98)
{
	/#
		while(isdefined(var_859cfb21[var_c0438d98]))
		{
			if(function_c0fb9425(var_859cfb21[var_c0438d98]))
			{
				var_b78d9698 = function_36371547(var_859cfb21, var_c0438d98);
				if(var_b78d9698 > var_c0438d98)
				{
					var_c0438d98 = var_b78d9698;
					center = level.var_9cf5ce57.var_5f3c7817;
					sphere(center, level.var_9cf5ce57.radius, level.var_9cf5ce57.color, level.var_9cf5ce57.alpha, 1, level.var_9cf5ce57.sides, level.var_9cf5ce57.duration);
					level.var_9cf5ce57.var_5f3c7817 = (0, 0, 0);
				}
			}
			else
			{
				var_b78d9698 = function_4282fd75(var_859cfb21, var_c0438d98);
				if(var_b78d9698 > var_c0438d98)
				{
					var_c0438d98 = var_b78d9698;
				}
				else
				{
					return var_c0438d98;
				}
			}
		}
		return var_c0438d98;
	#/
}

/*
	Name: function_f36ec3d2
	Namespace: zm_zdraw
	Checksum: 0x8C83621A
	Offset: 0xC80
	Size: 0x13B
	Parameters: 2
	Flags: None
*/
function function_f36ec3d2(var_859cfb21, var_c0438d98)
{
	/#
		while(isdefined(var_859cfb21[var_c0438d98]))
		{
			if(function_c0fb9425(var_859cfb21[var_c0438d98]))
			{
				var_b78d9698 = function_36371547(var_859cfb21, var_c0438d98);
				if(var_b78d9698 > var_c0438d98)
				{
					var_c0438d98 = var_b78d9698;
					center = level.var_9cf5ce57.var_5f3c7817;
					debugstar(center, level.var_9cf5ce57.duration, level.var_9cf5ce57.color);
					level.var_9cf5ce57.var_5f3c7817 = (0, 0, 0);
				}
			}
			else
			{
				var_b78d9698 = function_4282fd75(var_859cfb21, var_c0438d98);
				if(var_b78d9698 > var_c0438d98)
				{
					var_c0438d98 = var_b78d9698;
				}
				else
				{
					return var_c0438d98;
				}
			}
		}
		return var_c0438d98;
	#/
}

/*
	Name: function_be7cf134
	Namespace: zm_zdraw
	Checksum: 0xD7519BA1
	Offset: 0xDC8
	Size: 0x19B
	Parameters: 2
	Flags: None
*/
function function_be7cf134(var_859cfb21, var_c0438d98)
{
	/#
		level.var_9cf5ce57.LineStart = undefined;
		while(isdefined(var_859cfb21[var_c0438d98]))
		{
			if(function_c0fb9425(var_859cfb21[var_c0438d98]))
			{
				var_b78d9698 = function_36371547(var_859cfb21, var_c0438d98);
				if(var_b78d9698 > var_c0438d98)
				{
					var_c0438d98 = var_b78d9698;
					LineEnd = level.var_9cf5ce57.var_5f3c7817;
					if(isdefined(level.var_9cf5ce57.LineStart))
					{
						line(level.var_9cf5ce57.LineStart, LineEnd, level.var_9cf5ce57.color, level.var_9cf5ce57.alpha, 1, level.var_9cf5ce57.duration);
					}
					level.var_9cf5ce57.LineStart = LineEnd;
					level.var_9cf5ce57.var_5f3c7817 = (0, 0, 0);
				}
			}
			else
			{
				var_b78d9698 = function_4282fd75(var_859cfb21, var_c0438d98);
				if(var_b78d9698 > var_c0438d98)
				{
					var_c0438d98 = var_b78d9698;
				}
				else
				{
					return var_c0438d98;
				}
			}
		}
		return var_c0438d98;
	#/
}

/*
	Name: function_3145e33f
	Namespace: zm_zdraw
	Checksum: 0x3F83E1B0
	Offset: 0xF70
	Size: 0x203
	Parameters: 2
	Flags: None
*/
function function_3145e33f(var_859cfb21, var_c0438d98)
{
	/#
		level.var_9cf5ce57.text = "Dev Block strings are not supported";
		if(isdefined(var_859cfb21[var_c0438d98]))
		{
			var_b78d9698 = function_ce50bae5(var_859cfb21, var_c0438d98);
			if(var_b78d9698 > var_c0438d98)
			{
				var_c0438d98 = var_b78d9698;
				level.var_9cf5ce57.text = level.var_9cf5ce57.var_c1953771;
				level.var_9cf5ce57.var_c1953771 = "Dev Block strings are not supported";
			}
		}
		while(isdefined(var_859cfb21[var_c0438d98]))
		{
			if(function_c0fb9425(var_859cfb21[var_c0438d98]))
			{
				var_b78d9698 = function_36371547(var_859cfb21, var_c0438d98);
				if(var_b78d9698 > var_c0438d98)
				{
					var_c0438d98 = var_b78d9698;
					center = level.var_9cf5ce57.var_5f3c7817;
					print3d(center, level.var_9cf5ce57.text, level.var_9cf5ce57.color, level.var_9cf5ce57.alpha, level.var_9cf5ce57.scale, level.var_9cf5ce57.duration);
					level.var_9cf5ce57.var_5f3c7817 = (0, 0, 0);
				}
			}
			else
			{
				var_b78d9698 = function_4282fd75(var_859cfb21, var_c0438d98);
				if(var_b78d9698 > var_c0438d98)
				{
					var_c0438d98 = var_b78d9698;
				}
				else
				{
					return var_c0438d98;
				}
			}
		}
		return var_c0438d98;
	#/
}

/*
	Name: function_5ef6cf9b
	Namespace: zm_zdraw
	Checksum: 0x28301E68
	Offset: 0x1180
	Size: 0x179
	Parameters: 2
	Flags: None
*/
function function_5ef6cf9b(var_859cfb21, var_c0438d98)
{
	/#
		if(isdefined(var_859cfb21[var_c0438d98]))
		{
			if(function_c0fb9425(var_859cfb21[var_c0438d98]))
			{
				var_b78d9698 = function_36371547(var_859cfb21, var_c0438d98);
				if(var_b78d9698 > var_c0438d98)
				{
					var_c0438d98 = var_b78d9698;
					level.var_9cf5ce57.color = level.var_9cf5ce57.var_5f3c7817;
					level.var_9cf5ce57.var_5f3c7817 = (0, 0, 0);
				}
				else
				{
					level.var_9cf5ce57.color = (1, 1, 1);
				}
			}
			else if(isdefined(level.var_9cf5ce57.colors[var_859cfb21[var_c0438d98]]))
			{
				level.var_9cf5ce57.color = level.var_9cf5ce57.colors[var_859cfb21[var_c0438d98]];
			}
			else
			{
				level.var_9cf5ce57.color = (1, 1, 1);
				function_c69caf7e("Dev Block strings are not supported" + var_859cfb21[var_c0438d98]);
			}
			var_c0438d98 = var_c0438d98 + 1;
		}
		return var_c0438d98;
	#/
}

/*
	Name: function_eae4114a
	Namespace: zm_zdraw
	Checksum: 0x22D4065C
	Offset: 0x1308
	Size: 0xB9
	Parameters: 2
	Flags: None
*/
function function_eae4114a(var_859cfb21, var_c0438d98)
{
	/#
		if(isdefined(var_859cfb21[var_c0438d98]))
		{
			var_b78d9698 = function_33acda19(var_859cfb21, var_c0438d98);
			if(var_b78d9698 > var_c0438d98)
			{
				var_c0438d98 = var_b78d9698;
				level.var_9cf5ce57.alpha = level.var_9cf5ce57.var_922ae5d;
				level.var_9cf5ce57.var_922ae5d = 0;
			}
			else
			{
				level.var_9cf5ce57.alpha = 1;
			}
		}
		return var_c0438d98;
	#/
}

/*
	Name: function_a13efe1c
	Namespace: zm_zdraw
	Checksum: 0x51378D73
	Offset: 0x13D0
	Size: 0xB9
	Parameters: 2
	Flags: None
*/
function function_a13efe1c(var_859cfb21, var_c0438d98)
{
	/#
		if(isdefined(var_859cfb21[var_c0438d98]))
		{
			var_b78d9698 = function_33acda19(var_859cfb21, var_c0438d98);
			if(var_b78d9698 > var_c0438d98)
			{
				var_c0438d98 = var_b78d9698;
				level.var_9cf5ce57.scale = level.var_9cf5ce57.var_922ae5d;
				level.var_9cf5ce57.var_922ae5d = 0;
			}
			else
			{
				level.var_9cf5ce57.scale = 1;
			}
		}
		return var_c0438d98;
	#/
}

/*
	Name: function_f2f3c18e
	Namespace: zm_zdraw
	Checksum: 0xAECAD868
	Offset: 0x1498
	Size: 0xE9
	Parameters: 2
	Flags: None
*/
function function_f2f3c18e(var_859cfb21, var_c0438d98)
{
	/#
		if(isdefined(var_859cfb21[var_c0438d98]))
		{
			var_b78d9698 = function_33acda19(var_859cfb21, var_c0438d98);
			if(var_b78d9698 > var_c0438d98)
			{
				var_c0438d98 = var_b78d9698;
				level.var_9cf5ce57.duration = Int(level.var_9cf5ce57.var_922ae5d);
				level.var_9cf5ce57.var_922ae5d = 0;
			}
			else
			{
				level.var_9cf5ce57.duration = Int(1 * 62.5);
			}
		}
		return var_c0438d98;
	#/
}

/*
	Name: function_8f04ad79
	Namespace: zm_zdraw
	Checksum: 0xFCC0D5ED
	Offset: 0x1590
	Size: 0xF1
	Parameters: 2
	Flags: None
*/
function function_8f04ad79(var_859cfb21, var_c0438d98)
{
	/#
		if(isdefined(var_859cfb21[var_c0438d98]))
		{
			var_b78d9698 = function_33acda19(var_859cfb21, var_c0438d98);
			if(var_b78d9698 > var_c0438d98)
			{
				var_c0438d98 = var_b78d9698;
				level.var_9cf5ce57.duration = Int(62.5 * level.var_9cf5ce57.var_922ae5d);
				level.var_9cf5ce57.var_922ae5d = 0;
			}
			else
			{
				level.var_9cf5ce57.duration = Int(1 * 62.5);
			}
		}
		return var_c0438d98;
	#/
}

/*
	Name: function_b3b92edc
	Namespace: zm_zdraw
	Checksum: 0xC3CBAEE6
	Offset: 0x1690
	Size: 0xB9
	Parameters: 2
	Flags: None
*/
function function_b3b92edc(var_859cfb21, var_c0438d98)
{
	/#
		if(isdefined(var_859cfb21[var_c0438d98]))
		{
			var_b78d9698 = function_33acda19(var_859cfb21, var_c0438d98);
			if(var_b78d9698 > var_c0438d98)
			{
				var_c0438d98 = var_b78d9698;
				level.var_9cf5ce57.radius = level.var_9cf5ce57.var_922ae5d;
				level.var_9cf5ce57.var_922ae5d = 0;
			}
			else
			{
				level.var_9cf5ce57.radius = 8;
			}
		}
		return var_c0438d98;
	#/
}

/*
	Name: function_8c2ca616
	Namespace: zm_zdraw
	Checksum: 0xFE5106DB
	Offset: 0x1758
	Size: 0xCD
	Parameters: 2
	Flags: None
*/
function function_8c2ca616(var_859cfb21, var_c0438d98)
{
	/#
		if(isdefined(var_859cfb21[var_c0438d98]))
		{
			var_b78d9698 = function_33acda19(var_859cfb21, var_c0438d98);
			if(var_b78d9698 > var_c0438d98)
			{
				var_c0438d98 = var_b78d9698;
				level.var_9cf5ce57.sides = Int(level.var_9cf5ce57.var_922ae5d);
				level.var_9cf5ce57.var_922ae5d = 0;
			}
			else
			{
				level.var_9cf5ce57.sides = 10;
			}
		}
		return var_c0438d98;
	#/
}

/*
	Name: function_c0fb9425
	Namespace: zm_zdraw
	Checksum: 0x1C3EE0D0
	Offset: 0x1830
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function function_c0fb9425(Param)
{
	/#
		if(isdefined(Param) && (IsInt(Param) || IsFloat(Param) || (IsString(Param) && StrIsNumber(Param))))
		{
			return 1;
		}
		return 0;
	#/
}

/*
	Name: function_36371547
	Namespace: zm_zdraw
	Checksum: 0xB60484EA
	Offset: 0x18C0
	Size: 0x25F
	Parameters: 2
	Flags: None
*/
function function_36371547(var_859cfb21, var_c0438d98)
{
	/#
		if(isdefined(var_859cfb21[var_c0438d98]))
		{
			var_b78d9698 = function_33acda19(var_859cfb21, var_c0438d98);
			if(var_b78d9698 > var_c0438d98)
			{
				var_c0438d98 = var_b78d9698;
				level.var_9cf5ce57.var_5f3c7817 = (level.var_9cf5ce57.var_922ae5d, level.var_9cf5ce57.var_5f3c7817[1], level.var_9cf5ce57.var_5f3c7817[2]);
				level.var_9cf5ce57.var_922ae5d = 0;
			}
			else
			{
				function_c69caf7e("Dev Block strings are not supported");
				return var_c0438d98;
			}
			var_b78d9698 = function_33acda19(var_859cfb21, var_c0438d98);
			if(var_b78d9698 > var_c0438d98)
			{
				var_c0438d98 = var_b78d9698;
				level.var_9cf5ce57.var_5f3c7817 = (level.var_9cf5ce57.var_5f3c7817[0], level.var_9cf5ce57.var_922ae5d, level.var_9cf5ce57.var_5f3c7817[2]);
				level.var_9cf5ce57.var_922ae5d = 0;
			}
			else
			{
				function_c69caf7e("Dev Block strings are not supported");
				return var_c0438d98;
			}
			var_b78d9698 = function_33acda19(var_859cfb21, var_c0438d98);
			if(var_b78d9698 > var_c0438d98)
			{
				var_c0438d98 = var_b78d9698;
				level.var_9cf5ce57.var_5f3c7817 = (level.var_9cf5ce57.var_5f3c7817[0], level.var_9cf5ce57.var_5f3c7817[1], level.var_9cf5ce57.var_922ae5d);
				level.var_9cf5ce57.var_922ae5d = 0;
			}
			else
			{
				function_c69caf7e("Dev Block strings are not supported");
				return var_c0438d98;
			}
		}
		return var_c0438d98;
	#/
}

/*
	Name: function_33acda19
	Namespace: zm_zdraw
	Checksum: 0x24066F26
	Offset: 0x1B28
	Size: 0x89
	Parameters: 2
	Flags: None
*/
function function_33acda19(var_859cfb21, var_c0438d98)
{
	/#
		if(isdefined(var_859cfb21[var_c0438d98]))
		{
			if(function_c0fb9425(var_859cfb21[var_c0438d98]))
			{
				level.var_9cf5ce57.var_922ae5d = float(var_859cfb21[var_c0438d98]);
				var_c0438d98 = var_c0438d98 + 1;
			}
		}
		return var_c0438d98;
	#/
}

/*
	Name: function_ce50bae5
	Namespace: zm_zdraw
	Checksum: 0x2F7F683F
	Offset: 0x1BC0
	Size: 0x59
	Parameters: 2
	Flags: None
*/
function function_ce50bae5(var_859cfb21, var_c0438d98)
{
	/#
		if(isdefined(var_859cfb21[var_c0438d98]))
		{
			level.var_9cf5ce57.var_c1953771 = var_859cfb21[var_c0438d98];
			var_c0438d98 = var_c0438d98 + 1;
		}
		return var_c0438d98;
	#/
}

/*
	Name: function_c69caf7e
	Namespace: zm_zdraw
	Checksum: 0x8CAFBD4A
	Offset: 0x1C28
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function function_c69caf7e(msg)
{
	/#
		println("Dev Block strings are not supported" + msg);
	#/
}

