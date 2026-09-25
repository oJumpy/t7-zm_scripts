#using scripts\codescripts\struct;

#namespace compass;

/*
	Name: setupMiniMap
	Namespace: compass
	Checksum: 0xB5439AEF
	Offset: 0xC0
	Size: 0x46B
	Parameters: 1
	Flags: None
*/
function setupMiniMap(material)
{
	requiredMapAspectRatio = GetDvarFloat("scr_requiredMapAspectRatio");
	corners = GetEntArray("minimap_corner", "targetname");
	if(corners.size != 2)
	{
		/#
			println("Dev Block strings are not supported");
		#/
		return;
	}
	corner0 = (corners[0].origin[0], corners[0].origin[1], 0);
	corner1 = (corners[1].origin[0], corners[1].origin[1], 0);
	cornerdiff = corner1 - corner0;
	north = (cos(getnorthyaw()), sin(getnorthyaw()), 0);
	west = (0 - north[1], north[0], 0);
	if(VectorDot(cornerdiff, west) > 0)
	{
		if(VectorDot(cornerdiff, north) > 0)
		{
			northwest = corner1;
			southeast = corner0;
		}
		else
		{
			side = vecscale(north, VectorDot(cornerdiff, north));
			northwest = corner1 - side;
			southeast = corner0 + side;
		}
	}
	else if(VectorDot(cornerdiff, north) > 0)
	{
		side = vecscale(north, VectorDot(cornerdiff, north));
		northwest = corner0 + side;
		southeast = corner1 - side;
	}
	else
	{
		northwest = corner0;
		southeast = corner1;
	}
	if(requiredMapAspectRatio > 0)
	{
		northportion = VectorDot(northwest - southeast, north);
		westportion = VectorDot(northwest - southeast, west);
		mapAspectRatio = westportion / northportion;
		if(mapAspectRatio < requiredMapAspectRatio)
		{
			incr = requiredMapAspectRatio / mapAspectRatio;
			addvec = vecscale(west, westportion * incr - 1 * 0.5);
		}
		else
		{
			incr = mapAspectRatio / requiredMapAspectRatio;
			addvec = vecscale(north, northportion * incr - 1 * 0.5);
		}
		northwest = northwest + addvec;
		southeast = southeast - addvec;
	}
	setMiniMap(material, northwest[0], northwest[1], southeast[0], southeast[1]);
}

/*
	Name: vecscale
	Namespace: compass
	Checksum: 0x9F81D54E
	Offset: 0x538
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function vecscale(vec, scalar)
{
	return (vec[0] * scalar, vec[1] * scalar, vec[2] * scalar);
}

