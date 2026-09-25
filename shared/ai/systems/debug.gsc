#using scripts\shared\ai\archetype_utility;
#using scripts\shared\system_shared;

#namespace as_debug;

/*
	Name: __init__sytem__
	Namespace: as_debug
	Checksum: 0x59872824
	Offset: 0xC0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	/#
		system::register("Dev Block strings are not supported", &__init__, undefined, undefined);
	#/
}

/*
	Name: __init__
	Namespace: as_debug
	Checksum: 0xC334B472
	Offset: 0x100
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	/#
		level thread debugDvars();
	#/
}

/*
	Name: debugDvars
	Namespace: as_debug
	Checksum: 0x8ED8704A
	Offset: 0x128
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function debugDvars()
{
	/#
		while(1)
		{
			if(GetDvarInt("Dev Block strings are not supported", 0))
			{
				function_8bef747();
			}
			wait(0.05);
		}
	#/
}

/*
	Name: isDebugOn
	Namespace: as_debug
	Checksum: 0x24117F0F
	Offset: 0x180
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function isDebugOn()
{
	/#
		return GetDvarInt("Dev Block strings are not supported") == 1 || (isdefined(anim.debugEnt) && anim.debugEnt == self);
	#/
}

/*
	Name: drawDebugLineInternal
	Namespace: as_debug
	Checksum: 0xDCCEF656
	Offset: 0x1D8
	Size: 0x75
	Parameters: 4
	Flags: None
*/
function drawDebugLineInternal(fromPoint, toPoint, color, durationFrames)
{
	/#
		for(i = 0; i < durationFrames; i++)
		{
			line(fromPoint, toPoint, color);
			wait(0.05);
		}
	#/
}

/*
	Name: drawDebugLine
	Namespace: as_debug
	Checksum: 0x1D597F48
	Offset: 0x258
	Size: 0x63
	Parameters: 4
	Flags: None
*/
function drawDebugLine(fromPoint, toPoint, color, durationFrames)
{
	/#
		if(isDebugOn())
		{
			thread drawDebugLineInternal(fromPoint, toPoint, color, durationFrames);
		}
	#/
}

/*
	Name: debugLine
	Namespace: as_debug
	Checksum: 0x5D0BA0D
	Offset: 0x2C8
	Size: 0x7D
	Parameters: 4
	Flags: None
*/
function debugLine(fromPoint, toPoint, color, durationFrames)
{
	/#
		for(i = 0; i < durationFrames * 20; i++)
		{
			line(fromPoint, toPoint, color);
			wait(0.05);
		}
	#/
}

/*
	Name: drawDebugCross
	Namespace: as_debug
	Checksum: 0x37CF8633
	Offset: 0x350
	Size: 0x153
	Parameters: 4
	Flags: None
*/
function drawDebugCross(atPoint, radius, color, durationFrames)
{
	/#
		atPoint_high = atPoint + (0, 0, radius);
		atPoint_low = atPoint + (0, 0, -1 * radius);
		atPoint_left = atPoint + (0, radius, 0);
		atPoint_right = atPoint + (0, -1 * radius, 0);
		atPoint_forward = atPoint + (radius, 0, 0);
		atPoint_back = atPoint + (-1 * radius, 0, 0);
		thread debugLine(atPoint_high, atPoint_low, color, durationFrames);
		thread debugLine(atPoint_left, atPoint_right, color, durationFrames);
		thread debugLine(atPoint_forward, atPoint_back, color, durationFrames);
	#/
}

/*
	Name: UpdateDebugInfo
	Namespace: as_debug
	Checksum: 0x3C9F817F
	Offset: 0x4B0
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function UpdateDebugInfo()
{
	/#
		self endon("death");
		self.debugInfo = spawnstruct();
		self.debugInfo.enabled = GetDvarInt("Dev Block strings are not supported") > 0;
		debugClearState();
		while(1)
		{
			wait(0.05);
			UpdateDebugInfoInternal();
			wait(0.05);
		}
	#/
}

/*
	Name: UpdateDebugInfoInternal
	Namespace: as_debug
	Checksum: 0x32300C78
	Offset: 0x550
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function UpdateDebugInfoInternal()
{
	/#
		if(isdefined(anim.debugEnt) && anim.debugEnt == self)
		{
			doInfo = 1;
		}
		else
		{
			doInfo = GetDvarInt("Dev Block strings are not supported") > 0;
			if(doInfo)
			{
				ai_entNum = GetDvarInt("Dev Block strings are not supported");
				if(ai_entNum > -1 && ai_entNum != self GetEntityNumber())
				{
					doInfo = 0;
				}
			}
			if(!self.debugInfo.enabled && doInfo)
			{
				self.debugInfo.shouldClearOnAnimscriptChange = 1;
			}
			self.debugInfo.enabled = doInfo;
		}
	#/
}

/*
	Name: drawDebugEntText
	Namespace: as_debug
	Checksum: 0x5BE148D
	Offset: 0x660
	Size: 0x143
	Parameters: 4
	Flags: None
*/
function drawDebugEntText(text, ent, color, channel)
{
	/#
		/#
			Assert(isdefined(ent));
		#/
		if(!GetDvarInt("Dev Block strings are not supported"))
		{
			if(!isdefined(ent.debugAnimScriptTime) || GetTime() > ent.debugAnimScriptTime)
			{
				ent.debugAnimScriptLevel = 0;
				ent.debugAnimScriptTime = GetTime();
			}
			indentLevel = VectorScale(VectorScale((0, 0, -1), 10), ent.debugAnimScriptLevel);
			print3d(self.origin + VectorScale((0, 0, 1), 70) + indentLevel, text, color);
			ent.debugAnimScriptLevel++;
		}
		else
		{
			recordEntText(text, ent, color, channel);
		}
	#/
}

/*
	Name: debugPushState
	Namespace: as_debug
	Checksum: 0x16828103
	Offset: 0x7B0
	Size: 0x1A1
	Parameters: 2
	Flags: None
*/
function debugPushState(stateName, extraInfo)
{
	/#
		if(!GetDvarInt("Dev Block strings are not supported"))
		{
			return;
		}
		ai_entNum = GetDvarInt("Dev Block strings are not supported");
		if(ai_entNum > -1 && ai_entNum != self GetEntityNumber())
		{
			return;
		}
		/#
			Assert(isdefined(self.debugInfo.states));
		#/
		/#
			Assert(isdefined(stateName));
		#/
		State = spawnstruct();
		State.stateName = stateName;
		State.stateLevel = self.debugInfo.stateLevel;
		State.stateTime = GetTime();
		State.stateValid = 1;
		self.debugInfo.stateLevel++;
		if(isdefined(extraInfo))
		{
			State.extraInfo = extraInfo + "Dev Block strings are not supported";
		}
		self.debugInfo.states[self.debugInfo.states.size] = State;
	#/
}

/*
	Name: debugAddStateInfo
	Namespace: as_debug
	Checksum: 0xA3CBF9FF
	Offset: 0x960
	Size: 0x2F7
	Parameters: 2
	Flags: None
*/
function debugAddStateInfo(stateName, extraInfo)
{
	/#
		if(!GetDvarInt("Dev Block strings are not supported"))
		{
			return;
		}
		ai_entNum = GetDvarInt("Dev Block strings are not supported");
		if(ai_entNum > -1 && ai_entNum != self GetEntityNumber())
		{
			return;
		}
		/#
			Assert(isdefined(self.debugInfo.states));
		#/
		if(isdefined(stateName))
		{
			for(i = self.debugInfo.states.size - 1; i >= 0; i--)
			{
				/#
					Assert(isdefined(self.debugInfo.states[i]));
				#/
				if(self.debugInfo.states[i].stateName == stateName)
				{
					if(!isdefined(self.debugInfo.states[i].extraInfo))
					{
						self.debugInfo.states[i].extraInfo = "Dev Block strings are not supported";
					}
					self.debugInfo.states[i].extraInfo = self.debugInfo.states[i].extraInfo + extraInfo + "Dev Block strings are not supported";
					break;
				}
			}
		}
		else if(self.debugInfo.states.size > 0)
		{
			lastIndex = self.debugInfo.states.size - 1;
			/#
				Assert(isdefined(self.debugInfo.states[lastIndex]));
			#/
			if(!isdefined(self.debugInfo.states[lastIndex].extraInfo))
			{
				self.debugInfo.states[lastIndex].extraInfo = "Dev Block strings are not supported";
			}
			self.debugInfo.states[lastIndex].extraInfo = self.debugInfo.states[lastIndex].extraInfo + extraInfo + "Dev Block strings are not supported";
		}
	#/
}

/*
	Name: debugPopState
	Namespace: as_debug
	Checksum: 0x88CAA3AA
	Offset: 0xC60
	Size: 0x351
	Parameters: 2
	Flags: None
*/
function debugPopState(stateName, exitReason)
{
	/#
		if(!GetDvarInt("Dev Block strings are not supported") || self.debugInfo.states.size <= 0)
		{
			return;
		}
		ai_entNum = GetDvarInt("Dev Block strings are not supported");
		if(!isdefined(self) || !isalive(self))
		{
			return;
		}
		if(ai_entNum > -1 && ai_entNum != self GetEntityNumber())
		{
			return;
		}
		/#
			Assert(isdefined(self.debugInfo.states));
		#/
		if(isdefined(stateName))
		{
			for(i = 0; i < self.debugInfo.states.size; i++)
			{
				if(self.debugInfo.states[i].stateName == stateName && self.debugInfo.states[i].stateValid)
				{
					self.debugInfo.states[i].stateValid = 0;
					self.debugInfo.states[i].exitReason = exitReason;
					self.debugInfo.stateLevel = self.debugInfo.states[i].stateLevel;
					for(j = i + 1; j < self.debugInfo.states.size && self.debugInfo.states[j].stateLevel > self.debugInfo.states[i].stateLevel; j++)
					{
						self.debugInfo.states[j].stateValid = 0;
					}
					break;
				}
			}
			break;
		}
		for(i = self.debugInfo.states.size - 1; i >= 0; i--)
		{
			if(self.debugInfo.states[i].stateValid)
			{
				self.debugInfo.states[i].stateValid = 0;
				self.debugInfo.states[i].exitReason = exitReason;
				self.debugInfo.stateLevel--;
				break;
			}
		}
	#/
}

/*
	Name: debugClearState
	Namespace: as_debug
	Checksum: 0xC670A3B3
	Offset: 0xFC0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function debugClearState()
{
	/#
		self.debugInfo.states = [];
		self.debugInfo.stateLevel = 0;
		self.debugInfo.shouldClearOnAnimscriptChange = 0;
	#/
}

/*
	Name: debugShouldClearState
	Namespace: as_debug
	Checksum: 0x7D00FEA8
	Offset: 0x1010
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function debugShouldClearState()
{
	/#
		if(isdefined(self.debugInfo) && isdefined(self.debugInfo.shouldClearOnAnimscriptChange) && self.debugInfo.shouldClearOnAnimscriptChange)
		{
			return 1;
		}
		return 0;
	#/
}

/*
	Name: debugCleanStateStack
	Namespace: as_debug
	Checksum: 0x2E69DCA5
	Offset: 0x1060
	Size: 0xA7
	Parameters: 0
	Flags: None
*/
function debugCleanStateStack()
{
	/#
		newArray = [];
		for(i = 0; i < self.debugInfo.states.size; i++)
		{
			if(self.debugInfo.states[i].stateValid)
			{
				newArray[newArray.size] = self.debugInfo.states[i];
			}
		}
		self.debugInfo.states = newArray;
	#/
}

/*
	Name: indent
	Namespace: as_debug
	Checksum: 0xCFFEBBBD
	Offset: 0x1110
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function indent(depth)
{
	/#
		indent = "Dev Block strings are not supported";
		for(i = 0; i < depth; i++)
		{
			indent = indent + "Dev Block strings are not supported";
		}
		return indent;
	#/
}

/*
	Name: function_7da65dd6
	Namespace: as_debug
	Checksum: 0xB7386487
	Offset: 0x1180
	Size: 0x105
	Parameters: 3
	Flags: None
*/
function function_7da65dd6(entity, points, weights)
{
	/#
		var_ea788292 = 0;
		highestValue = 0;
		for(index = 0; index < points.size; index++)
		{
			if(weights[index] < var_ea788292)
			{
				var_ea788292 = weights[index];
			}
			if(weights[index] > highestValue)
			{
				highestValue = weights[index];
			}
		}
		for(index = 0; index < points.size; index++)
		{
			function_700f290f(entity, points[index], weights[index], var_ea788292, highestValue);
		}
	#/
}

/*
	Name: function_700f290f
	Namespace: as_debug
	Checksum: 0xCA208AE4
	Offset: 0x1290
	Size: 0x173
	Parameters: 5
	Flags: None
*/
function function_700f290f(entity, point, weight, var_ea788292, highestValue)
{
	/#
		var_1318fcc4 = highestValue - var_ea788292;
		var_7f57ff27 = var_1318fcc4 / 2;
		var_596aac88 = var_ea788292 + var_1318fcc4 / 2;
		if(var_7f57ff27 == 0)
		{
			var_7f57ff27 = 1;
		}
		if(weight <= var_596aac88)
		{
			var_862f5d6b = 1 - Abs(weight - var_ea788292 / var_7f57ff27);
			RecordCircle(point, 2, (var_862f5d6b, 0, 0), "Dev Block strings are not supported", entity);
		}
		else
		{
			var_dcf0d28b = 1 - Abs(highestValue - weight / var_7f57ff27);
			RecordCircle(point, 2, (0, var_dcf0d28b, 0), "Dev Block strings are not supported", entity);
		}
	#/
}

/*
	Name: function_8bef747
	Namespace: as_debug
	Checksum: 0x99621017
	Offset: 0x1410
	Size: 0xD9
	Parameters: 0
	Flags: None
*/
function function_8bef747()
{
	/#
		SetDvar("Dev Block strings are not supported", 0);
		corpses = GetCorpseArray();
		foreach(corpse in corpses)
		{
			if(function_329c21f4(corpse))
			{
				corpse delete();
			}
		}
	#/
}

