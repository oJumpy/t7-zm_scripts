#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace gfx;

/*
	Name: SetStage
	Namespace: gfx
	Checksum: 0x2D77B00C
	Offset: 0x260
	Size: 0x5EB
	Parameters: 8
	Flags: None
*/
function SetStage(localClientNum, bundle, filterid, stagePrefix, stageLength, accumTime, totalAccumTime, setConstants)
{
	num_consts = GetStructFieldOrZero(bundle, stagePrefix + "num_consts");
	for(constIdx = 0; constIdx < num_consts; constIdx++)
	{
		constPrefix = stagePrefix + "c";
		if(constIdx < 10)
		{
			constPrefix = constPrefix + "0";
		}
		constPrefix = constPrefix + constIdx + "_";
		startValue = getShaderConstantValue(bundle, constPrefix, "start", 0);
		endValue = getShaderConstantValue(bundle, constPrefix, "end", 0);
		delays = getShaderConstantValue(bundle, constPrefix, "delay", 1);
		channels = GetStructField(bundle, constPrefix + "channels");
		isColor = IsString(channels) && (channels == "color" || channels == "color+alpha");
		animName = GetStructField(bundle, constPrefix + "anm");
		values = [];
		for(i = 0; i < 4; i++)
		{
			values[i] = 0;
		}
		for(chanIdx = 0; chanIdx < startValue.size; chanIdx++)
		{
			if(isColor)
			{
			}
			else
			{
			}
			delayTime = delays[chanIdx] * 1000;
			if(accumTime > delayTime && stageLength > delayTime)
			{
				timeRatio = accumTime - delayTime / stageLength - delayTime;
				timeRatio = math::clamp(timeRatio, 0, 1);
				lerpRatio = 0;
				delta = endValue[chanIdx] - startValue[chanIdx];
				switch(animName)
				{
					case "linear":
					{
						lerpRatio = timeRatio;
						break;
					}
					case "step":
					{
						lerpRatio = 1;
						break;
					}
					case "ease in":
					{
						lerpRatio = timeRatio * timeRatio;
						break;
					}
					case "ease out":
					{
						lerpRatio = timeRatio * -1 * timeRatio - 2;
						break;
					}
					case "ease inout":
					{
						timeRatio = timeRatio * 2;
						if(timeRatio < 1)
						{
							lerpRatio = 0.5 * lerpRatio * lerpRatio;
						}
						else
						{
							timeRatio = timeRatio - 1;
							lerpRatio = -0.5 * lerpRatio * lerpRatio - 2 - 1;
						}
						break;
					}
					case "linear repeat":
					{
						lerpRatio = timeRatio;
						break;
					}
					case "linear mirror":
					{
						if(timeRatio > 0.5)
						{
							lerpRatio = 1 - timeRatio;
						}
						else
						{
							lerpRatio = timeRatio;
						}
						break;
					}
					case "sin":
					{
						lerpRatio = 0.5 - 0.5 * cos(360 * timeRatio);
						break;
					}
					case default:
					{
						break;
					}
				}
				lerpRatio = math::clamp(lerpRatio, 0, 1);
				values[chanIdx] = startValue[chanIdx] + lerpRatio * delta;
				continue;
			}
			values[chanIdx] = startValue[chanIdx];
		}
		[[setConstants]](localClientNum, GetStructField(bundle, constPrefix + "name"), filterid, values);
	}
	stageConstants = [];
	stageConstants[0] = totalAccumTime;
	stageConstants[1] = accumTime;
	stageConstants[2] = stageLength;
	stageConstants[3] = 0;
	[[setConstants]](localClientNum, "scriptvector7", filterid, stageConstants);
}

/*
	Name: getShaderConstantValue
	Namespace: gfx
	Checksum: 0x99E635A9
	Offset: 0x858
	Size: 0x4AD
	Parameters: 4
	Flags: None
*/
function getShaderConstantValue(bundle, constPrefix, constName, delay)
{
	channels = GetStructField(bundle, constPrefix + "channels");
	if(delay && IsString(channels) && (channels == "color" || channels == "color+alpha"))
	{
		channels = "1";
	}
	vals = [];
	switch(channels)
	{
		case "1":
		case 1:
		{
			vals[0] = GetStructFieldOrZero(bundle, constPrefix + constName + "_x");
			break;
		}
		case "2":
		case 2:
		{
			vals[0] = GetStructFieldOrZero(bundle, constPrefix + constName + "_x");
			vals[1] = GetStructFieldOrZero(bundle, constPrefix + constName + "_y");
			break;
		}
		case "3":
		case 3:
		{
			vals[0] = GetStructFieldOrZero(bundle, constPrefix + constName + "_x");
			vals[1] = GetStructFieldOrZero(bundle, constPrefix + constName + "_y");
			vals[2] = GetStructFieldOrZero(bundle, constPrefix + constName + "_z");
			break;
		}
		case 4:
		case "4":
		{
			vals[0] = GetStructFieldOrZero(bundle, constPrefix + constName + "_x");
			vals[1] = GetStructFieldOrZero(bundle, constPrefix + constName + "_y");
			vals[2] = GetStructFieldOrZero(bundle, constPrefix + constName + "_z");
			vals[3] = GetStructFieldOrZero(bundle, constPrefix + constName + "_w");
			break;
		}
		case "color":
		{
			vals[0] = GetStructFieldOrZero(bundle, constPrefix + constName + "_clr_r");
			vals[1] = GetStructFieldOrZero(bundle, constPrefix + constName + "_clr_g");
			vals[2] = GetStructFieldOrZero(bundle, constPrefix + constName + "_clr_b");
			break;
		}
		case "color+alpha":
		{
			vals[0] = GetStructFieldOrZero(bundle, constPrefix + constName + "_clr_r");
			vals[1] = GetStructFieldOrZero(bundle, constPrefix + constName + "_clr_g");
			vals[2] = GetStructFieldOrZero(bundle, constPrefix + constName + "_clr_b");
			vals[3] = GetStructFieldOrZero(bundle, constPrefix + constName + "_clr_a");
			break;
		}
	}
	return vals;
}

/*
	Name: GetStructFieldOrZero
	Namespace: gfx
	Checksum: 0xA0C3E150
	Offset: 0xD10
	Size: 0x4D
	Parameters: 2
	Flags: None
*/
function GetStructFieldOrZero(bundle, field)
{
	ret = GetStructField(bundle, field);
	if(!isdefined(ret))
	{
		ret = 0;
	}
	return ret;
}

/*
	Name: getShaderConstantIndex
	Namespace: gfx
	Checksum: 0x8933ADED
	Offset: 0xD68
	Size: 0x8D
	Parameters: 1
	Flags: None
*/
function getShaderConstantIndex(codeConstName)
{
	switch(codeConstName)
	{
		case "scriptvector0":
		{
			return 0;
		}
		case "scriptvector1":
		{
			return 4;
		}
		case "scriptvector2":
		{
			return 8;
		}
		case "scriptvector3":
		{
			return 12;
		}
		case "scriptvector4":
		{
			return 16;
		}
		case "scriptvector5":
		{
			return 20;
		}
		case "scriptvector6":
		{
			return 24;
		}
		case "scriptvector7":
		{
			return 28;
		}
	}
	return -1;
}

