#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace dev;

/*
	Name: debug_sphere
	Namespace: dev
	Checksum: 0x6A755D42
	Offset: 0x150
	Size: 0xCB
	Parameters: 5
	Flags: None
*/
function debug_sphere(origin, radius, color, alpha, time)
{
	/#
		if(!isdefined(time))
		{
			time = 1000;
		}
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		sides = Int(10 * 1 + Int(radius) % 100);
		sphere(origin, radius, color, alpha, 1, sides, time);
	#/
}

/*
	Name: updateMinimapSetting
	Namespace: dev
	Checksum: 0x9CB49404
	Offset: 0x228
	Size: 0xB1B
	Parameters: 0
	Flags: None
*/
function updateMinimapSetting()
{
	/#
		requiredMapAspectRatio = GetDvarFloat("Dev Block strings are not supported");
		if(!isdefined(level.minimapheight))
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			level.minimapheight = 0;
		}
		minimapheight = GetDvarFloat("Dev Block strings are not supported");
		if(minimapheight != level.minimapheight)
		{
			if(minimapheight <= 0)
			{
				util::getHostPlayer() CameraActivate(0);
				level.minimapheight = minimapheight;
				level notify("end_draw_map_bounds");
			}
			if(minimapheight > 0)
			{
				level.minimapheight = minimapheight;
				players = GetPlayers();
				if(players.size > 0)
				{
					player = util::getHostPlayer();
					corners = GetEntArray("Dev Block strings are not supported", "Dev Block strings are not supported");
					if(corners.size == 2)
					{
						viewpos = corners[0].origin + corners[1].origin;
						viewpos = (viewpos[0] * 0.5, viewpos[1] * 0.5, viewpos[2] * 0.5);
						level thread minimapWarn(corners);
						maxcorner = (corners[0].origin[0], corners[0].origin[1], viewpos[2]);
						mincorner = (corners[0].origin[0], corners[0].origin[1], viewpos[2]);
						if(corners[1].origin[0] > corners[0].origin[0])
						{
							maxcorner = (corners[1].origin[0], maxcorner[1], maxcorner[2]);
						}
						else
						{
							mincorner = (corners[1].origin[0], mincorner[1], mincorner[2]);
						}
						if(corners[1].origin[1] > corners[0].origin[1])
						{
							maxcorner = (maxcorner[0], corners[1].origin[1], maxcorner[2]);
						}
						else
						{
							mincorner = (mincorner[0], corners[1].origin[1], mincorner[2]);
						}
						viewpostocorner = maxcorner - viewpos;
						viewpos = (viewpos[0], viewpos[1], viewpos[2] + minimapheight);
						northvector = (cos(getnorthyaw()), sin(getnorthyaw()), 0);
						eastvector = (northvector[1], 0 - northvector[0], 0);
						disttotop = VectorDot(northvector, viewpostocorner);
						if(disttotop < 0)
						{
							disttotop = 0 - disttotop;
						}
						disttoside = VectorDot(eastvector, viewpostocorner);
						if(disttoside < 0)
						{
							disttoside = 0 - disttoside;
						}
						if(requiredMapAspectRatio > 0)
						{
							mapAspectRatio = disttoside / disttotop;
							if(mapAspectRatio < requiredMapAspectRatio)
							{
								incr = requiredMapAspectRatio / mapAspectRatio;
								disttoside = disttoside * incr;
								addvec = vecscale(eastvector, VectorDot(eastvector, maxcorner - viewpos) * incr - 1);
								mincorner = mincorner - addvec;
								maxcorner = maxcorner + addvec;
							}
							else
							{
								incr = mapAspectRatio / requiredMapAspectRatio;
								disttotop = disttotop * incr;
								addvec = vecscale(northvector, VectorDot(northvector, maxcorner - viewpos) * incr - 1);
								mincorner = mincorner - addvec;
								maxcorner = maxcorner + addvec;
							}
						}
						if(level.console)
						{
							aspectratioguess = 1.777778;
							angleside = 2 * ATan(disttoside * 0.8 / minimapheight);
							angletop = 2 * ATan(disttotop * aspectratioguess * 0.8 / minimapheight);
						}
						else
						{
							aspectratioguess = 1.333333;
							angleside = 2 * ATan(disttoside / minimapheight);
							angletop = 2 * ATan(disttotop * aspectratioguess / minimapheight);
						}
						if(angleside > angletop)
						{
							angle = angleside;
						}
						else
						{
							angle = angletop;
						}
						znear = minimapheight - 1000;
						if(znear < 16)
						{
							znear = 16;
						}
						if(znear > 10000)
						{
							znear = 10000;
						}
						player CameraSetPosition(viewpos, (90, getnorthyaw(), 0));
						player CameraActivate(1);
						player TakeAllWeapons();
						SetDvar("Dev Block strings are not supported", 0);
						SetDvar("Dev Block strings are not supported", 0);
						SetDvar("Dev Block strings are not supported", 0);
						SetDvar("Dev Block strings are not supported", 0);
						SetDvar("Dev Block strings are not supported", 0);
						SetDvar("Dev Block strings are not supported", 0);
						SetDvar("Dev Block strings are not supported", znear);
						SetDvar("Dev Block strings are not supported", 0.1);
						SetDvar("Dev Block strings are not supported", 0);
						SetDvar("Dev Block strings are not supported", 1);
						SetDvar("Dev Block strings are not supported", 90);
						SetDvar("Dev Block strings are not supported", 0);
						SetDvar("Dev Block strings are not supported", 1);
						SetDvar("Dev Block strings are not supported", 1);
						SetDvar("Dev Block strings are not supported", 0);
						SetDvar("Dev Block strings are not supported", 0);
						SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
						if(isdefined(level.objPoints))
						{
							for(i = 0; i < level.objPointNames.size; i++)
							{
								if(isdefined(level.objPoints[level.objPointNames[i]]))
								{
									level.objPoints[level.objPointNames[i]] destroy();
								}
							}
							level.objPoints = [];
							level.objPointNames = [];
						}
						thread drawMiniMapBounds(viewpos, mincorner, maxcorner);
					}
					else
					{
						println("Dev Block strings are not supported");
					}
				}
				else
				{
					SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
				}
			}
		}
	#/
}

/*
	Name: vecscale
	Namespace: dev
	Checksum: 0x301D0C37
	Offset: 0xD50
	Size: 0x49
	Parameters: 2
	Flags: None
*/
function vecscale(vec, scalar)
{
	/#
		return (vec[0] * scalar, vec[1] * scalar, vec[2] * scalar);
	#/
}

/*
	Name: drawMiniMapBounds
	Namespace: dev
	Checksum: 0x6B765295
	Offset: 0xDA8
	Size: 0x3BF
	Parameters: 3
	Flags: None
*/
function drawMiniMapBounds(viewpos, mincorner, maxcorner)
{
	/#
		level notify("end_draw_map_bounds");
		level endon("end_draw_map_bounds");
		viewheight = viewpos[2] - maxcorner[2];
		north = (cos(getnorthyaw()), sin(getnorthyaw()), 0);
		diaglen = length(mincorner - maxcorner);
		mincorneroffset = mincorner - viewpos;
		mincorneroffset = VectorNormalize((mincorneroffset[0], mincorneroffset[1], 0));
		mincorner = mincorner + vecscale(mincorneroffset, diaglen * 1 / 800);
		maxcorneroffset = maxcorner - viewpos;
		maxcorneroffset = VectorNormalize((maxcorneroffset[0], maxcorneroffset[1], 0));
		maxcorner = maxcorner + vecscale(maxcorneroffset, diaglen * 1 / 800);
		DIAGONAL = maxcorner - mincorner;
		side = vecscale(north, VectorDot(DIAGONAL, north));
		sidenorth = vecscale(north, Abs(VectorDot(DIAGONAL, north)));
		corner0 = mincorner;
		corner1 = mincorner + side;
		corner2 = maxcorner;
		corner3 = maxcorner - side;
		topPos = vecscale(mincorner + maxcorner, 0.5) + vecscale(sidenorth, 0.51);
		textscale = diaglen * 0.003;
		while(1)
		{
			line(corner0, corner1);
			line(corner1, corner2);
			line(corner2, corner3);
			line(corner3, corner0);
			print3d(topPos, "Dev Block strings are not supported", (1, 1, 1), 1, textscale);
			wait(0.05);
		}
	#/
}

/*
	Name: minimapWarn
	Namespace: dev
	Checksum: 0x3ABD2D34
	Offset: 0x1170
	Size: 0x1E5
	Parameters: 1
	Flags: None
*/
function minimapWarn(corners)
{
	/#
		threshold = 10;
		width = Abs(corners[0].origin[0] - corners[1].origin[0]);
		width = Int(width);
		height = Abs(corners[0].origin[1] - corners[1].origin[1]);
		height = Int(height);
		if(Abs(width - height) > threshold)
		{
			for(;;)
			{
				iprintln("Dev Block strings are not supported" + width + "Dev Block strings are not supported" + height + "Dev Block strings are not supported");
				if(height > width)
				{
					scale = height / width;
					iprintln("Dev Block strings are not supported" + scale + "Dev Block strings are not supported");
				}
				else
				{
					scale = width / height;
					iprintln("Dev Block strings are not supported" + scale + "Dev Block strings are not supported");
				}
				wait(10);
			}
		}
	#/
}

/*
	Name: body_customization_setup_helmet
	Namespace: dev
	Checksum: 0xF87EFA4F
	Offset: 0x1360
	Size: 0xA9
	Parameters: 1
	Flags: None
*/
function body_customization_setup_helmet(helmet_index)
{
	/#
		foreach(player in GetPlayers())
		{
			player SetCharacterHelmetStyle(helmet_index);
		}
	#/
}

/*
	Name: body_customization_setup_body
	Namespace: dev
	Checksum: 0x22469CFD
	Offset: 0x1418
	Size: 0xC9
	Parameters: 2
	Flags: None
*/
function body_customization_setup_body(character_index, body_index)
{
	/#
		foreach(player in GetPlayers())
		{
			player SetCharacterBodyType(character_index);
			player SetCharacterBodyStyle(body_index);
		}
	#/
}

/*
	Name: body_customization_process_command
	Namespace: dev
	Checksum: 0xCAEB5420
	Offset: 0x14F0
	Size: 0x21D
	Parameters: 1
	Flags: None
*/
function body_customization_process_command(character_index)
{
	/#
		split = StrTok(character_index, "Dev Block strings are not supported");
		switch(split.size)
		{
			case 1:
			case default:
			{
				command0 = StrTok(split[0], "Dev Block strings are not supported");
				character_index = Int(command0[1]);
				body_index = 0;
				helmet_index = 0;
				body_customization_setup_helmet(helmet_index);
				body_customization_setup_body(character_index, body_index);
				break;
			}
			case 2:
			{
				command0 = StrTok(split[0], "Dev Block strings are not supported");
				character_index = Int(command0[1]);
				command1 = StrTok(split[1], "Dev Block strings are not supported");
				if(command1[0] == "Dev Block strings are not supported")
				{
					body_index = Int(command1[1]);
					body_customization_setup_body(character_index, body_index);
				}
				else if(command1[0] == "Dev Block strings are not supported")
				{
					helmet_index = Int(command1[1]);
					body_customization_setup_helmet(helmet_index);
				}
				break;
			}
		}
	#/
}

/*
	Name: body_customization_populate
	Namespace: dev
	Checksum: 0x13761B6
	Offset: 0x1718
	Size: 0x2E5
	Parameters: 1
	Flags: None
*/
function body_customization_populate(mode)
{
	/#
		bodies = getallcharacterbodies(mode);
		body_customization_devgui_base = "Dev Block strings are not supported";
		foreach(playerbodytype in bodies)
		{
			body_name = MakeLocalizedString(getcharacterdisplayname(playerbodytype, mode)) + "Dev Block strings are not supported" + getcharacterassetname(playerbodytype, mode) + "Dev Block strings are not supported";
			AddDebugCommand(body_customization_devgui_base + body_name + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + playerbodytype + "Dev Block strings are not supported");
			for(i = 0; i < getcharacterbodymodelcount(playerbodytype, mode); i++)
			{
				AddDebugCommand(body_customization_devgui_base + body_name + "Dev Block strings are not supported" + i + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + playerbodytype + "Dev Block strings are not supported" + "Dev Block strings are not supported" + i + "Dev Block strings are not supported");
				wait(0.05);
			}
			for(i = 0; i < getcharacterhelmetmodelcount(playerbodytype, mode); i++)
			{
				AddDebugCommand(body_customization_devgui_base + body_name + "Dev Block strings are not supported" + i + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + playerbodytype + "Dev Block strings are not supported" + "Dev Block strings are not supported" + i + "Dev Block strings are not supported");
				wait(0.05);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: body_customization_devgui
	Namespace: dev
	Checksum: 0xCE02794D
	Offset: 0x1A08
	Size: 0x97
	Parameters: 1
	Flags: None
*/
function body_customization_devgui(mode)
{
	/#
		thread body_customization_populate(mode);
		for(;;)
		{
			character_index = GetDvarString("Dev Block strings are not supported");
			if(character_index != "Dev Block strings are not supported")
			{
				body_customization_process_command(character_index);
			}
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			wait(0.5);
		}
	#/
}

/*
	Name: add_perk_devgui
	Namespace: dev
	Checksum: 0xA9980C64
	Offset: 0x1AA8
	Size: 0xDB
	Parameters: 2
	Flags: None
*/
function add_perk_devgui(name, specialties)
{
	/#
		perk_devgui_base = "Dev Block strings are not supported";
		perk_name = MakeLocalizedString(name);
		test = perk_devgui_base + perk_name + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + specialties + "Dev Block strings are not supported";
		AddDebugCommand(perk_devgui_base + perk_name + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + specialties + "Dev Block strings are not supported");
	#/
}

