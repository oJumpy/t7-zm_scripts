#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace art;

/*
	Name: __init__sytem__
	Namespace: art
	Checksum: 0x4BED714A
	Offset: 0x1D0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("art", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: art
	Checksum: 0x23317B66
	Offset: 0x210
	Size: 0x26B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	/#
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported" || GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", 0);
		}
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", level.script);
		}
	#/
	if(!isdefined(level.dofDefault))
	{
		level.dofDefault["nearStart"] = 0;
		level.dofDefault["nearEnd"] = 1;
		level.dofDefault["farStart"] = 8000;
		level.dofDefault["farEnd"] = 10000;
		level.dofDefault["nearBlur"] = 6;
		level.dofDefault["farBlur"] = 0;
	}
	level.curDoF = level.dofDefault["farStart"] - level.dofDefault["nearEnd"] / 2;
	/#
		thread tweakart();
	#/
	if(!isdefined(level.script))
	{
		level.script = ToLower(GetDvarString("mapname"));
	}
}

/*
	Name: artfxprintln
	Namespace: art
	Checksum: 0xFA9C27A1
	Offset: 0x488
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function artfxprintln(file, string)
{
	/#
		if(file == -1)
		{
			return;
		}
		fprintln(file, string);
	#/
}

/*
	Name: strtok_loc
	Namespace: art
	Checksum: 0xC7A63654
	Offset: 0x4D8
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function strtok_loc(string, par1)
{
	stringlist = [];
	indexstring = "";
	for(i = 0; i < string.size; i++)
	{
		if(string[i] == " ")
		{
			stringlist[stringlist.size] = indexstring;
			indexstring = "";
			continue;
		}
		indexstring = indexstring + string[i];
	}
	if(indexstring.size)
	{
		stringlist[stringlist.size] = indexstring;
	}
	return stringlist;
}

/*
	Name: setfogsliders
	Namespace: art
	Checksum: 0xBBA05D5D
	Offset: 0x5B8
	Size: 0x1B3
	Parameters: 0
	Flags: None
*/
function setfogsliders()
{
	fogall = strtok_loc(GetDvarString("g_fogColorReadOnly"), " ");
	red = fogall[0];
	green = fogall[1];
	blue = fogall[2];
	halfplane = GetDvarString("g_fogHalfDistReadOnly");
	nearplane = GetDvarString("g_fogStartDistReadOnly");
	if(!isdefined(red) || !isdefined(green) || !isdefined(blue) || !isdefined(halfplane))
	{
		red = 1;
		green = 1;
		blue = 1;
		halfplane = 10000001;
		nearplane = 10000000;
	}
	SetDvar("scr_fog_exp_halfplane", halfplane);
	SetDvar("scr_fog_nearplane", nearplane);
	SetDvar("scr_fog_color", red + " " + green + " " + blue);
}

/*
	Name: tweakart
	Namespace: art
	Checksum: 0xF1AF3530
	Offset: 0x778
	Size: 0x95F
	Parameters: 0
	Flags: None
*/
function tweakart()
{
	/#
		if(!isdefined(level.tweakfile))
		{
			level.tweakfile = 0;
		}
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", level.dofDefault["Dev Block strings are not supported"]);
		SetDvar("Dev Block strings are not supported", level.dofDefault["Dev Block strings are not supported"]);
		SetDvar("Dev Block strings are not supported", level.dofDefault["Dev Block strings are not supported"]);
		SetDvar("Dev Block strings are not supported", level.dofDefault["Dev Block strings are not supported"]);
		SetDvar("Dev Block strings are not supported", level.dofDefault["Dev Block strings are not supported"]);
		SetDvar("Dev Block strings are not supported", level.dofDefault["Dev Block strings are not supported"]);
		file = undefined;
		filename = undefined;
		tweak_toggle = 1;
		while(GetDvarInt("Dev Block strings are not supported") == 0)
		{
			tweak_toggle = 1;
			wait(0.05);
			continue;
			if(tweak_toggle)
			{
				tweak_toggle = 0;
				fogsettings = getfogsettings();
				SetDvar("Dev Block strings are not supported", fogsettings[0]);
				SetDvar("Dev Block strings are not supported", fogsettings[1]);
				SetDvar("Dev Block strings are not supported", fogsettings[3]);
				SetDvar("Dev Block strings are not supported", fogsettings[2]);
				SetDvar("Dev Block strings are not supported", fogsettings[4] + "Dev Block strings are not supported" + fogsettings[5] + "Dev Block strings are not supported" + fogsettings[6]);
				SetDvar("Dev Block strings are not supported", fogsettings[7]);
				SetDvar("Dev Block strings are not supported", fogsettings[8] + "Dev Block strings are not supported" + fogsettings[9] + "Dev Block strings are not supported" + fogsettings[10]);
				level.fogsundir = [];
				level.fogsundir[0] = fogsettings[11];
				level.fogsundir[1] = fogsettings[12];
				level.fogsundir[2] = fogsettings[13];
				SetDvar("Dev Block strings are not supported", fogsettings[14]);
				SetDvar("Dev Block strings are not supported", fogsettings[15]);
				SetDvar("Dev Block strings are not supported", fogsettings[16]);
			}
			level.fogexphalfplane = GetDvarFloat("Dev Block strings are not supported");
			level.fogexphalfheight = GetDvarFloat("Dev Block strings are not supported");
			level.fognearplane = GetDvarFloat("Dev Block strings are not supported");
			level.fogbaseheight = GetDvarFloat("Dev Block strings are not supported");
			colors = StrTok(GetDvarString("Dev Block strings are not supported"), "Dev Block strings are not supported");
			level.fogcolorred = Int(colors[0]);
			level.fogcolorgreen = Int(colors[1]);
			level.fogcolorblue = Int(colors[2]);
			level.fogcolorscale = GetDvarFloat("Dev Block strings are not supported");
			colors = StrTok(GetDvarString("Dev Block strings are not supported"), "Dev Block strings are not supported");
			level.sunfogcolorred = Int(colors[0]);
			level.sunfogcolorgreen = Int(colors[1]);
			level.sunfogcolorblue = Int(colors[2]);
			level.sunstartangle = GetDvarFloat("Dev Block strings are not supported");
			level.sunendangle = GetDvarFloat("Dev Block strings are not supported");
			level.fogmaxopacity = GetDvarFloat("Dev Block strings are not supported");
			if(GetDvarInt("Dev Block strings are not supported"))
			{
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				println("Dev Block strings are not supported");
				players = GetPlayers();
				dir = VectorNormalize(AnglesToForward(players[0] getPlayerAngles()));
				level.fogsundir = [];
				level.fogsundir[0] = dir[0];
				level.fogsundir[1] = dir[1];
				level.fogsundir[2] = dir[2];
			}
			fovslidercheck();
			dumpsettings();
			if(!GetDvarInt("Dev Block strings are not supported"))
			{
				if(!isdefined(level.fogsundir))
				{
					level.fogsundir = [];
					level.fogsundir[0] = 1;
					level.fogsundir[1] = 0;
					level.fogsundir[2] = 0;
				}
				SetVolFog(level.fognearplane, level.fogexphalfplane, level.fogexphalfheight, level.fogbaseheight, level.fogcolorred, level.fogcolorgreen, level.fogcolorblue, level.fogcolorscale, level.sunfogcolorred, level.sunfogcolorgreen, level.sunfogcolorblue, level.fogsundir[0], level.fogsundir[1], level.fogsundir[2], level.sunstartangle, level.sunendangle, 0, level.fogmaxopacity);
			}
			else
			{
				setExpFog(100000000, 100000001, 0, 0, 0, 0);
			}
			wait(0.1);
		}
	#/
}

/*
	Name: fovslidercheck
	Namespace: art
	Checksum: 0x106EB74A
	Offset: 0x10E0
	Size: 0x2D3
	Parameters: 0
	Flags: None
*/
function fovslidercheck()
{
	if(level.dofDefault["nearStart"] >= level.dofDefault["nearEnd"])
	{
		level.dofDefault["nearStart"] = level.dofDefault["nearEnd"] - 1;
		SetDvar("scr_dof_nearStart", level.dofDefault["nearStart"]);
	}
	if(level.dofDefault["nearEnd"] <= level.dofDefault["nearStart"])
	{
		level.dofDefault["nearEnd"] = level.dofDefault["nearStart"] + 1;
		SetDvar("scr_dof_nearEnd", level.dofDefault["nearEnd"]);
	}
	if(level.dofDefault["farStart"] >= level.dofDefault["farEnd"])
	{
		level.dofDefault["farStart"] = level.dofDefault["farEnd"] - 1;
		SetDvar("scr_dof_farStart", level.dofDefault["farStart"]);
	}
	if(level.dofDefault["farEnd"] <= level.dofDefault["farStart"])
	{
		level.dofDefault["farEnd"] = level.dofDefault["farStart"] + 1;
		SetDvar("scr_dof_farEnd", level.dofDefault["farEnd"]);
	}
	if(level.dofDefault["farBlur"] >= level.dofDefault["nearBlur"])
	{
		level.dofDefault["farBlur"] = level.dofDefault["nearBlur"] - 0.1;
		SetDvar("scr_dof_farBlur", level.dofDefault["farBlur"]);
	}
	if(level.dofDefault["farStart"] <= level.dofDefault["nearEnd"])
	{
		level.dofDefault["farStart"] = level.dofDefault["nearEnd"] + 1;
		SetDvar("scr_dof_farStart", level.dofDefault["farStart"]);
	}
}

/*
	Name: dumpsettings
	Namespace: art
	Checksum: 0x8D4D7218
	Offset: 0x13C0
	Size: 0x403
	Parameters: 0
	Flags: None
*/
function dumpsettings()
{
	/#
		if(GetDvarString("Dev Block strings are not supported") != "Dev Block strings are not supported")
		{
			println("Dev Block strings are not supported" + level.fognearplane + "Dev Block strings are not supported");
			println("Dev Block strings are not supported" + level.fogexphalfplane + "Dev Block strings are not supported");
			println("Dev Block strings are not supported" + level.fogexphalfheight + "Dev Block strings are not supported");
			println("Dev Block strings are not supported" + level.fogbaseheight + "Dev Block strings are not supported");
			println("Dev Block strings are not supported" + level.fogcolorred + "Dev Block strings are not supported");
			println("Dev Block strings are not supported" + level.fogcolorgreen + "Dev Block strings are not supported");
			println("Dev Block strings are not supported" + level.fogcolorblue + "Dev Block strings are not supported");
			println("Dev Block strings are not supported" + level.fogcolorscale + "Dev Block strings are not supported");
			println("Dev Block strings are not supported" + level.sunfogcolorred + "Dev Block strings are not supported");
			println("Dev Block strings are not supported" + level.sunfogcolorgreen + "Dev Block strings are not supported");
			println("Dev Block strings are not supported" + level.sunfogcolorblue + "Dev Block strings are not supported");
			println("Dev Block strings are not supported" + level.fogsundir[0] + "Dev Block strings are not supported");
			println("Dev Block strings are not supported" + level.fogsundir[1] + "Dev Block strings are not supported");
			println("Dev Block strings are not supported" + level.fogsundir[2] + "Dev Block strings are not supported");
			println("Dev Block strings are not supported" + level.sunstartangle + "Dev Block strings are not supported");
			println("Dev Block strings are not supported" + level.sunendangle + "Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported" + level.fogmaxopacity + "Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
	#/
}

