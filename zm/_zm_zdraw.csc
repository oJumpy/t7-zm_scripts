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
		level.zdraw = spawnstruct();
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
		level.zdraw.colors = [];
		level.zdraw.colors["Dev Block strings are not supported"] = (1, 0, 0);
		level.zdraw.colors["Dev Block strings are not supported"] = (0, 1, 0);
		level.zdraw.colors["Dev Block strings are not supported"] = (0, 0, 1);
		level.zdraw.colors["Dev Block strings are not supported"] = (1, 1, 0);
		level.zdraw.colors["Dev Block strings are not supported"] = (1, 0.5, 0);
		level.zdraw.colors["Dev Block strings are not supported"] = (0, 1, 1);
		level.zdraw.colors["Dev Block strings are not supported"] = (1, 0, 1);
		level.zdraw.colors["Dev Block strings are not supported"] = (0, 0, 0);
		level.zdraw.colors["Dev Block strings are not supported"] = (1, 1, 1);
		level.zdraw.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.75);
		level.zdraw.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.1);
		level.zdraw.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.2);
		level.zdraw.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.3);
		level.zdraw.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.4);
		level.zdraw.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.5);
		level.zdraw.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.6);
		level.zdraw.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.7);
		level.zdraw.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.8);
		level.zdraw.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 1), 0.9);
		level.zdraw.colors["Dev Block strings are not supported"] = (0.4392157, 0.5019608, 0.5647059);
		level.zdraw.colors["Dev Block strings are not supported"] = (1, 0.7529412, 0.7960784);
		level.zdraw.colors["Dev Block strings are not supported"] = VectorScale((1, 1, 0), 0.5019608);
		level.zdraw.colors["Dev Block strings are not supported"] = (0.5450981, 0.2705882, 0.07450981);
		level.zdraw.colors["Dev Block strings are not supported"] = (1, 1, 1);
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
		level.zdraw.commands = [];
		level.zdraw.commands["Dev Block strings are not supported"] = &zdraw_color;
		level.zdraw.commands["Dev Block strings are not supported"] = &zdraw_alpha;
		level.zdraw.commands["Dev Block strings are not supported"] = &zdraw_duration;
		level.zdraw.commands["Dev Block strings are not supported"] = &function_8f04ad79;
		level.zdraw.commands["Dev Block strings are not supported"] = &zdraw_scale;
		level.zdraw.commands["Dev Block strings are not supported"] = &function_b3b92edc;
		level.zdraw.commands["Dev Block strings are not supported"] = &function_8c2ca616;
		level.zdraw.commands["Dev Block strings are not supported"] = &zdraw_text;
		level.zdraw.commands["Dev Block strings are not supported"] = &function_f36ec3d2;
		level.zdraw.commands["Dev Block strings are not supported"] = &function_7bdd3089;
		level.zdraw.commands["Dev Block strings are not supported"] = &zdraw_line;
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
		level.zdraw.color = level.zdraw.colors["Dev Block strings are not supported"];
		level.zdraw.alpha = 1;
		level.zdraw.scale = 1;
		level.zdraw.duration = Int(1 * 62.5);
		level.zdraw.radius = 8;
		level.zdraw.sides = 10;
		level.zdraw.var_5f3c7817 = (0, 0, 0);
		level.zdraw.var_922ae5d = 0;
		level.zdraw.var_c1953771 = "Dev Block strings are not supported";
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
				zdraw_command(params, 0, 1);
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			wait(0.5);
		}
	#/
}

/*
	Name: zdraw_command
	Namespace: zm_zdraw
	Checksum: 0xE3D442E7
	Offset: 0xA18
	Size: 0xE3
	Parameters: 3
	Flags: None
*/
function zdraw_command(var_859cfb21, startat, toplevel)
{
	/#
		if(!isdefined(toplevel))
		{
			toplevel = 0;
		}
		while(isdefined(var_859cfb21[startat]))
		{
			if(isdefined(level.zdraw.commands[var_859cfb21[startat]]))
			{
				startat = [[level.zdraw.commands[var_859cfb21[startat]]]](var_859cfb21, startat + 1);
			}
			else if(isdefined(toplevel) && toplevel)
			{
				function_c69caf7e("Dev Block strings are not supported" + var_859cfb21[startat]);
			}
			return startat;
		}
		return startat;
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
function function_7bdd3089(var_859cfb21, startat)
{
	/#
		while(isdefined(var_859cfb21[startat]))
		{
			if(function_c0fb9425(var_859cfb21[startat]))
			{
				var_b78d9698 = zdraw_vector(var_859cfb21, startat);
				if(var_b78d9698 > startat)
				{
					startat = var_b78d9698;
					center = level.zdraw.var_5f3c7817;
					sphere(center, level.zdraw.radius, level.zdraw.color, level.zdraw.alpha, 1, level.zdraw.sides, level.zdraw.duration);
					level.zdraw.var_5f3c7817 = (0, 0, 0);
				}
			}
			else
			{
				var_b78d9698 = zdraw_command(var_859cfb21, startat);
				if(var_b78d9698 > startat)
				{
					startat = var_b78d9698;
				}
				else
				{
					return startat;
				}
			}
		}
		return startat;
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
function function_f36ec3d2(var_859cfb21, startat)
{
	/#
		while(isdefined(var_859cfb21[startat]))
		{
			if(function_c0fb9425(var_859cfb21[startat]))
			{
				var_b78d9698 = zdraw_vector(var_859cfb21, startat);
				if(var_b78d9698 > startat)
				{
					startat = var_b78d9698;
					center = level.zdraw.var_5f3c7817;
					debugstar(center, level.zdraw.duration, level.zdraw.color);
					level.zdraw.var_5f3c7817 = (0, 0, 0);
				}
			}
			else
			{
				var_b78d9698 = zdraw_command(var_859cfb21, startat);
				if(var_b78d9698 > startat)
				{
					startat = var_b78d9698;
				}
				else
				{
					return startat;
				}
			}
		}
		return startat;
	#/
}

/*
	Name: zdraw_line
	Namespace: zm_zdraw
	Checksum: 0xD7519BA1
	Offset: 0xDC8
	Size: 0x19B
	Parameters: 2
	Flags: None
*/
function zdraw_line(var_859cfb21, startat)
{
	/#
		level.zdraw.LineStart = undefined;
		while(isdefined(var_859cfb21[startat]))
		{
			if(function_c0fb9425(var_859cfb21[startat]))
			{
				var_b78d9698 = zdraw_vector(var_859cfb21, startat);
				if(var_b78d9698 > startat)
				{
					startat = var_b78d9698;
					LineEnd = level.zdraw.var_5f3c7817;
					if(isdefined(level.zdraw.LineStart))
					{
						line(level.zdraw.LineStart, LineEnd, level.zdraw.color, level.zdraw.alpha, 1, level.zdraw.duration);
					}
					level.zdraw.LineStart = LineEnd;
					level.zdraw.var_5f3c7817 = (0, 0, 0);
				}
			}
			else
			{
				var_b78d9698 = zdraw_command(var_859cfb21, startat);
				if(var_b78d9698 > startat)
				{
					startat = var_b78d9698;
				}
				else
				{
					return startat;
				}
			}
		}
		return startat;
	#/
}

/*
	Name: zdraw_text
	Namespace: zm_zdraw
	Checksum: 0x3F83E1B0
	Offset: 0xF70
	Size: 0x203
	Parameters: 2
	Flags: None
*/
function zdraw_text(var_859cfb21, startat)
{
	/#
		level.zdraw.text = "Dev Block strings are not supported";
		if(isdefined(var_859cfb21[startat]))
		{
			var_b78d9698 = function_ce50bae5(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.text = level.zdraw.var_c1953771;
				level.zdraw.var_c1953771 = "Dev Block strings are not supported";
			}
		}
		while(isdefined(var_859cfb21[startat]))
		{
			if(function_c0fb9425(var_859cfb21[startat]))
			{
				var_b78d9698 = zdraw_vector(var_859cfb21, startat);
				if(var_b78d9698 > startat)
				{
					startat = var_b78d9698;
					center = level.zdraw.var_5f3c7817;
					print3d(center, level.zdraw.text, level.zdraw.color, level.zdraw.alpha, level.zdraw.scale, level.zdraw.duration);
					level.zdraw.var_5f3c7817 = (0, 0, 0);
				}
			}
			else
			{
				var_b78d9698 = zdraw_command(var_859cfb21, startat);
				if(var_b78d9698 > startat)
				{
					startat = var_b78d9698;
				}
				else
				{
					return startat;
				}
			}
		}
		return startat;
	#/
}

/*
	Name: zdraw_color
	Namespace: zm_zdraw
	Checksum: 0x28301E68
	Offset: 0x1180
	Size: 0x179
	Parameters: 2
	Flags: None
*/
function zdraw_color(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			if(function_c0fb9425(var_859cfb21[startat]))
			{
				var_b78d9698 = zdraw_vector(var_859cfb21, startat);
				if(var_b78d9698 > startat)
				{
					startat = var_b78d9698;
					level.zdraw.color = level.zdraw.var_5f3c7817;
					level.zdraw.var_5f3c7817 = (0, 0, 0);
				}
				else
				{
					level.zdraw.color = (1, 1, 1);
				}
			}
			else if(isdefined(level.zdraw.colors[var_859cfb21[startat]]))
			{
				level.zdraw.color = level.zdraw.colors[var_859cfb21[startat]];
			}
			else
			{
				level.zdraw.color = (1, 1, 1);
				function_c69caf7e("Dev Block strings are not supported" + var_859cfb21[startat]);
			}
			startat = startat + 1;
		}
		return startat;
	#/
}

/*
	Name: zdraw_alpha
	Namespace: zm_zdraw
	Checksum: 0x22D4065C
	Offset: 0x1308
	Size: 0xB9
	Parameters: 2
	Flags: None
*/
function zdraw_alpha(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			var_b78d9698 = zdraw_number(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.alpha = level.zdraw.var_922ae5d;
				level.zdraw.var_922ae5d = 0;
			}
			else
			{
				level.zdraw.alpha = 1;
			}
		}
		return startat;
	#/
}

/*
	Name: zdraw_scale
	Namespace: zm_zdraw
	Checksum: 0x51378D73
	Offset: 0x13D0
	Size: 0xB9
	Parameters: 2
	Flags: None
*/
function zdraw_scale(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			var_b78d9698 = zdraw_number(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.scale = level.zdraw.var_922ae5d;
				level.zdraw.var_922ae5d = 0;
			}
			else
			{
				level.zdraw.scale = 1;
			}
		}
		return startat;
	#/
}

/*
	Name: zdraw_duration
	Namespace: zm_zdraw
	Checksum: 0xAECAD868
	Offset: 0x1498
	Size: 0xE9
	Parameters: 2
	Flags: None
*/
function zdraw_duration(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			var_b78d9698 = zdraw_number(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.duration = Int(level.zdraw.var_922ae5d);
				level.zdraw.var_922ae5d = 0;
			}
			else
			{
				level.zdraw.duration = Int(1 * 62.5);
			}
		}
		return startat;
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
function function_8f04ad79(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			var_b78d9698 = zdraw_number(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.duration = Int(62.5 * level.zdraw.var_922ae5d);
				level.zdraw.var_922ae5d = 0;
			}
			else
			{
				level.zdraw.duration = Int(1 * 62.5);
			}
		}
		return startat;
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
function function_b3b92edc(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			var_b78d9698 = zdraw_number(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.radius = level.zdraw.var_922ae5d;
				level.zdraw.var_922ae5d = 0;
			}
			else
			{
				level.zdraw.radius = 8;
			}
		}
		return startat;
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
function function_8c2ca616(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			var_b78d9698 = zdraw_number(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.sides = Int(level.zdraw.var_922ae5d);
				level.zdraw.var_922ae5d = 0;
			}
			else
			{
				level.zdraw.sides = 10;
			}
		}
		return startat;
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
	Name: zdraw_vector
	Namespace: zm_zdraw
	Checksum: 0xB60484EA
	Offset: 0x18C0
	Size: 0x25F
	Parameters: 2
	Flags: None
*/
function zdraw_vector(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			var_b78d9698 = zdraw_number(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.var_5f3c7817 = (level.zdraw.var_922ae5d, level.zdraw.var_5f3c7817[1], level.zdraw.var_5f3c7817[2]);
				level.zdraw.var_922ae5d = 0;
			}
			else
			{
				function_c69caf7e("Dev Block strings are not supported");
				return startat;
			}
			var_b78d9698 = zdraw_number(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.var_5f3c7817 = (level.zdraw.var_5f3c7817[0], level.zdraw.var_922ae5d, level.zdraw.var_5f3c7817[2]);
				level.zdraw.var_922ae5d = 0;
			}
			else
			{
				function_c69caf7e("Dev Block strings are not supported");
				return startat;
			}
			var_b78d9698 = zdraw_number(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.var_5f3c7817 = (level.zdraw.var_5f3c7817[0], level.zdraw.var_5f3c7817[1], level.zdraw.var_922ae5d);
				level.zdraw.var_922ae5d = 0;
			}
			else
			{
				function_c69caf7e("Dev Block strings are not supported");
				return startat;
			}
		}
		return startat;
	#/
}

/*
	Name: zdraw_number
	Namespace: zm_zdraw
	Checksum: 0x24066F26
	Offset: 0x1B28
	Size: 0x89
	Parameters: 2
	Flags: None
*/
function zdraw_number(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			if(function_c0fb9425(var_859cfb21[startat]))
			{
				level.zdraw.var_922ae5d = float(var_859cfb21[startat]);
				startat = startat + 1;
			}
		}
		return startat;
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
function function_ce50bae5(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			level.zdraw.var_c1953771 = var_859cfb21[startat];
			startat = startat + 1;
		}
		return startat;
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

