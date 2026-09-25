#using scripts\shared\util_shared;

#namespace math;

/*
	Name: cointoss
	Namespace: math
	Checksum: 0x84ADC07
	Offset: 0xB8
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function cointoss()
{
	return RandomInt(100) >= 50;
}

/*
	Name: clamp
	Namespace: math
	Checksum: 0x59E381C5
	Offset: 0xE0
	Size: 0x67
	Parameters: 3
	Flags: None
*/
function clamp(VAL, val_min, val_max)
{
	if(!isdefined(val_max))
	{
		val_max = VAL;
	}
	if(VAL < val_min)
	{
		VAL = val_min;
	}
	else if(VAL > val_max)
	{
		VAL = val_max;
	}
	return VAL;
}

/*
	Name: linear_map
	Namespace: math
	Checksum: 0x823A56E0
	Offset: 0x150
	Size: 0x69
	Parameters: 5
	Flags: None
*/
function linear_map(num, min_a, max_a, min_b, max_b)
{
	return clamp(num - min_a / max_a - min_a * max_b - min_b + min_b, min_b, max_b);
}

/*
	Name: lag
	Namespace: math
	Checksum: 0x553D62C4
	Offset: 0x1C8
	Size: 0xA5
	Parameters: 4
	Flags: None
*/
function lag(desired, curr, K, DT)
{
	r = 0;
	if(K * DT >= 1 || K <= 0)
	{
		r = desired;
	}
	else
	{
		err = desired - curr;
		r = curr + K * err * DT;
	}
	return r;
}

/*
	Name: find_box_center
	Namespace: math
	Checksum: 0x28970463
	Offset: 0x278
	Size: 0x75
	Parameters: 2
	Flags: None
*/
function find_box_center(mins, maxs)
{
	center = (0, 0, 0);
	center = maxs - mins;
	center = (center[0] / 2, center[1] / 2, center[2] / 2) + mins;
	return center;
}

/*
	Name: expand_mins
	Namespace: math
	Checksum: 0x40DC1D52
	Offset: 0x2F8
	Size: 0xCD
	Parameters: 2
	Flags: None
*/
function expand_mins(mins, point)
{
	if(mins[0] > point[0])
	{
		mins = (point[0], mins[1], mins[2]);
	}
	if(mins[1] > point[1])
	{
		mins = (mins[0], point[1], mins[2]);
	}
	if(mins[2] > point[2])
	{
		mins = (mins[0], mins[1], point[2]);
	}
	return mins;
}

/*
	Name: expand_maxs
	Namespace: math
	Checksum: 0xB6ECC46B
	Offset: 0x3D0
	Size: 0xCD
	Parameters: 2
	Flags: None
*/
function expand_maxs(maxs, point)
{
	if(maxs[0] < point[0])
	{
		maxs = (point[0], maxs[1], maxs[2]);
	}
	if(maxs[1] < point[1])
	{
		maxs = (maxs[0], point[1], maxs[2]);
	}
	if(maxs[2] < point[2])
	{
		maxs = (maxs[0], maxs[1], point[2]);
	}
	return maxs;
}

/*
	Name: vector_compare
	Namespace: math
	Checksum: 0xDE6E0AF6
	Offset: 0x4A8
	Size: 0xB3
	Parameters: 2
	Flags: None
*/
function vector_compare(vec1, vec2)
{
	return Abs(vec1[0] - vec2[0]) < 0.001 && Abs(vec1[1] - vec2[1]) < 0.001 && Abs(vec1[2] - vec2[2]) < 0.001;
}

/*
	Name: random_vector
	Namespace: math
	Checksum: 0xEF9A6139
	Offset: 0x568
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function random_vector(max_length)
{
	return (RandomFloatRange(-1 * max_length, max_length), RandomFloatRange(-1 * max_length, max_length), RandomFloatRange(-1 * max_length, max_length));
}

/*
	Name: angle_dif
	Namespace: math
	Checksum: 0x3D4D486A
	Offset: 0x5E0
	Size: 0x75
	Parameters: 2
	Flags: None
*/
function angle_dif(oldangle, newangle)
{
	outvalue = oldangle - newangle % 360;
	if(outvalue < 0)
	{
		outvalue = outvalue + 360;
	}
	if(outvalue > 180)
	{
		outvalue = outvalue - 360 * -1;
	}
	return outvalue;
}

/*
	Name: sign
	Namespace: math
	Checksum: 0x46F22169
	Offset: 0x660
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function sign(x)
{
	if(x >= 0)
	{
	}
	else
	{
	}
	return -1;
}

/*
	Name: randomSign
	Namespace: math
	Checksum: 0x13951D4E
	Offset: 0x690
	Size: 0x2D
	Parameters: 0
	Flags: None
*/
function randomSign()
{
	if(randomIntRange(-1, 1) >= 0)
	{
	}
	else
	{
	}
	return -1;
}

/*
	Name: get_dot_direction
	Namespace: math
	Checksum: 0xEE08EFD7
	Offset: 0x6C8
	Size: 0x383
	Parameters: 5
	Flags: None
*/
function get_dot_direction(v_point, b_ignore_z, b_normalize, str_direction, b_use_eye)
{
	/#
		Assert(isdefined(v_point), "Dev Block strings are not supported");
	#/
	if(!isdefined(b_ignore_z))
	{
		b_ignore_z = 0;
	}
	if(!isdefined(b_normalize))
	{
		b_normalize = 1;
	}
	if(!isdefined(str_direction))
	{
		str_direction = "forward";
	}
	if(!isdefined(b_use_eye))
	{
		b_use_eye = 0;
		if(isPlayer(self))
		{
			b_use_eye = 1;
		}
	}
	v_angles = self.angles;
	v_origin = self.origin;
	if(b_use_eye)
	{
		v_origin = self util::get_eye();
	}
	if(isPlayer(self))
	{
		v_angles = self getPlayerAngles();
		if(level.wiiu)
		{
			v_angles = self GetGunAngles();
		}
	}
	if(b_ignore_z)
	{
		v_angles = (v_angles[0], v_angles[1], 0);
		v_point = (v_point[0], v_point[1], 0);
		v_origin = (v_origin[0], v_origin[1], 0);
	}
	switch(str_direction)
	{
		case "forward":
		{
			v_direction = AnglesToForward(v_angles);
			break;
		}
		case "backward":
		{
			v_direction = AnglesToForward(v_angles) * -1;
			break;
		}
		case "right":
		{
			v_direction = AnglesToRight(v_angles);
			break;
		}
		case "left":
		{
			v_direction = AnglesToRight(v_angles) * -1;
			break;
		}
		case "up":
		{
			v_direction = anglesToUp(v_angles);
			break;
		}
		case "down":
		{
			v_direction = anglesToUp(v_angles) * -1;
			break;
		}
		case default:
		{
			/#
				ASSERTMSG(str_direction + "Dev Block strings are not supported");
			#/
			v_direction = AnglesToForward(v_angles);
			break;
		}
	}
	v_to_point = v_point - v_origin;
	if(b_normalize)
	{
		v_to_point = VectorNormalize(v_to_point);
	}
	n_dot = VectorDot(v_direction, v_to_point);
	return n_dot;
}

/*
	Name: get_dot_right
	Namespace: math
	Checksum: 0x994EB935
	Offset: 0xA58
	Size: 0x7B
	Parameters: 3
	Flags: None
*/
function get_dot_right(v_point, b_ignore_z, b_normalize)
{
	/#
		Assert(isdefined(v_point), "Dev Block strings are not supported");
	#/
	n_dot = get_dot_direction(v_point, b_ignore_z, b_normalize, "right");
	return n_dot;
}

/*
	Name: get_dot_up
	Namespace: math
	Checksum: 0xF6EFC644
	Offset: 0xAE0
	Size: 0x7B
	Parameters: 3
	Flags: None
*/
function get_dot_up(v_point, b_ignore_z, b_normalize)
{
	/#
		Assert(isdefined(v_point), "Dev Block strings are not supported");
	#/
	n_dot = get_dot_direction(v_point, b_ignore_z, b_normalize, "up");
	return n_dot;
}

/*
	Name: get_dot_forward
	Namespace: math
	Checksum: 0x21434A0A
	Offset: 0xB68
	Size: 0x7B
	Parameters: 3
	Flags: None
*/
function get_dot_forward(v_point, b_ignore_z, b_normalize)
{
	/#
		Assert(isdefined(v_point), "Dev Block strings are not supported");
	#/
	n_dot = get_dot_direction(v_point, b_ignore_z, b_normalize, "forward");
	return n_dot;
}

/*
	Name: get_dot_from_eye
	Namespace: math
	Checksum: 0xBA8DB492
	Offset: 0xBF0
	Size: 0xE3
	Parameters: 4
	Flags: None
*/
function get_dot_from_eye(v_point, b_ignore_z, b_normalize, str_direction)
{
	/#
		Assert(isdefined(v_point), "Dev Block strings are not supported");
	#/
	/#
		Assert(isPlayer(self) || isai(self), "Dev Block strings are not supported" + self.classname + "Dev Block strings are not supported");
	#/
	n_dot = get_dot_direction(v_point, b_ignore_z, b_normalize, str_direction, 1);
	return n_dot;
}

/*
	Name: array_average
	Namespace: math
	Checksum: 0x80C85E22
	Offset: 0xCE0
	Size: 0xB7
	Parameters: 1
	Flags: None
*/
function array_average(Array)
{
	/#
		Assert(IsArray(Array));
	#/
	/#
		Assert(Array.size > 0);
	#/
	Total = 0;
	for(i = 0; i < Array.size; i++)
	{
		Total = Total + Array[i];
	}
	return Total / Array.size;
}

/*
	Name: array_std_deviation
	Namespace: math
	Checksum: 0x78DCDE4F
	Offset: 0xDA0
	Size: 0x131
	Parameters: 2
	Flags: None
*/
function array_std_deviation(Array, mean)
{
	/#
		Assert(IsArray(Array));
	#/
	/#
		Assert(Array.size > 0);
	#/
	tmp = [];
	for(i = 0; i < Array.size; i++)
	{
		tmp[i] = Array[i] - mean * Array[i] - mean;
	}
	Total = 0;
	for(i = 0; i < tmp.size; i++)
	{
		Total = Total + tmp[i];
	}
	return sqrt(Total / Array.size);
}

/*
	Name: random_normal_distribution
	Namespace: math
	Checksum: 0x5CCC166B
	Offset: 0xEE0
	Size: 0x19D
	Parameters: 4
	Flags: None
*/
function random_normal_distribution(mean, std_deviation, lower_bound, upper_bound)
{
	x1 = 0;
	x2 = 0;
	w = 1;
	y1 = 0;
	while(w >= 1)
	{
		x1 = 2 * RandomFloatRange(0, 1) - 1;
		x2 = 2 * RandomFloatRange(0, 1) - 1;
		w = x1 * x1 + x2 * x2;
	}
	w = sqrt(-2 * Log(w) / w);
	y1 = x1 * w;
	Number = mean + y1 * std_deviation;
	if(isdefined(lower_bound) && Number < lower_bound)
	{
		Number = lower_bound;
	}
	if(isdefined(upper_bound) && Number > upper_bound)
	{
		Number = upper_bound;
	}
	return Number;
}

/*
	Name: closest_point_on_line
	Namespace: math
	Checksum: 0x132AE5B1
	Offset: 0x1088
	Size: 0x1BF
	Parameters: 3
	Flags: None
*/
function closest_point_on_line(point, LineStart, LineEnd)
{
	LineMagSqrd = LengthSquared(LineEnd - LineStart);
	t = point[0] - LineStart[0] * LineEnd[0] - LineStart[0] + point[1] - LineStart[1] * LineEnd[1] - LineStart[1] + point[2] - LineStart[2] * LineEnd[2] - LineStart[2] / LineMagSqrd;
	if(t < 0)
	{
		return LineStart;
	}
	else if(t > 1)
	{
		return LineEnd;
	}
	start_x = LineStart[0] + t * LineEnd[0] - LineStart[0];
	start_y = LineStart[1] + t * LineEnd[1] - LineStart[1];
	start_z = LineStart[2] + t * LineEnd[2] - LineStart[2];
	return (start_x, start_y, start_z);
}

/*
	Name: get_2d_yaw
	Namespace: math
	Checksum: 0x7C8D97AF
	Offset: 0x1250
	Size: 0x61
	Parameters: 2
	Flags: None
*/
function get_2d_yaw(start, end)
{
	vector = (end[0] - start[0], end[1] - start[1], 0);
	return function_aeddf416(vector);
}

/*
	Name: function_aeddf416
	Namespace: math
	Checksum: 0xDD2B0AD7
	Offset: 0x12C0
	Size: 0xDD
	Parameters: 1
	Flags: None
*/
function function_aeddf416(vector)
{
	yaw = 0;
	vecX = vector[0];
	vecY = vector[1];
	if(vecX == 0 && vecY == 0)
	{
		return 0;
	}
	if(vecY < 0.001 && vecY > -0.001)
	{
		vecY = 0.001;
	}
	yaw = ATan(vecX / vecY);
	if(vecY < 0)
	{
		yaw = yaw + 180;
	}
	return 90 - yaw;
}

/*
	Name: pow
	Namespace: math
	Checksum: 0xDAEB5FF
	Offset: 0x13A8
	Size: 0x79
	Parameters: 2
	Flags: None
*/
function pow(base, exp)
{
	if(exp == 0)
	{
		return 1;
	}
	result = base;
	for(i = 0; i < exp - 1; i++)
	{
		result = result * base;
	}
	return result;
}

