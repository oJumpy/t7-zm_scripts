#namespace ai_interface;

/*
	Name: main
	Namespace: ai_interface
	Checksum: 0x493A47D0
	Offset: 0xE8
	Size: 0x2B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	/#
		level.__ai_debugInterface = GetDvarInt("Dev Block strings are not supported");
	#/
}

/*
	Name: _CheckValue
	Namespace: ai_interface
	Checksum: 0x85FDF085
	Offset: 0x120
	Size: 0x2D5
	Parameters: 3
	Flags: Private
*/
function private _CheckValue(archetype, attributeName, value)
{
	/#
		attribute = level.__ai_interface[archetype][attributeName];
		switch(attribute["Dev Block strings are not supported"])
		{
			case "Dev Block strings are not supported":
			{
				possibleValues = attribute["Dev Block strings are not supported"];
				/#
					Assert(!IsArray(possibleValues) || IsInArray(possibleValues, value), "Dev Block strings are not supported" + value + "Dev Block strings are not supported" + attributeName + "Dev Block strings are not supported");
				#/
				break;
			}
			case "Dev Block strings are not supported":
			{
				maxValue = attribute["Dev Block strings are not supported"];
				minValue = attribute["Dev Block strings are not supported"];
				/#
					Assert(IsInt(value) || IsFloat(value), "Dev Block strings are not supported" + attributeName + "Dev Block strings are not supported" + value + "Dev Block strings are not supported");
				#/
				/#
					Assert(!isdefined(maxValue) && !isdefined(minValue) || (value <= maxValue && value >= minValue), "Dev Block strings are not supported" + value + "Dev Block strings are not supported" + minValue + "Dev Block strings are not supported" + maxValue + "Dev Block strings are not supported");
				#/
				break;
			}
			case "Dev Block strings are not supported":
			{
				if(isdefined(value))
				{
					/#
						Assert(IsVec(value), "Dev Block strings are not supported" + attributeName + "Dev Block strings are not supported" + value + "Dev Block strings are not supported");
					#/
				}
				break;
			}
			case default:
			{
				/#
					Assert("Dev Block strings are not supported" + attribute["Dev Block strings are not supported"] + "Dev Block strings are not supported" + attributeName + "Dev Block strings are not supported");
				#/
				break;
			}
		}
	#/
}

/*
	Name: _CheckPrerequisites
	Namespace: ai_interface
	Checksum: 0x7B801FCE
	Offset: 0x400
	Size: 0x2B3
	Parameters: 2
	Flags: Private
*/
function private _CheckPrerequisites(entity, attribute)
{
	/#
		/#
			Assert(IsEntity(entity), "Dev Block strings are not supported");
		#/
		/#
			Assert(IsActor(entity) || isVehicle(entity), "Dev Block strings are not supported");
		#/
		/#
			Assert(IsString(attribute), "Dev Block strings are not supported");
		#/
		if(isdefined(level.__ai_debugInterface) && level.__ai_debugInterface > 0)
		{
			/#
				Assert(IsArray(entity.__interface), "Dev Block strings are not supported" + entity.archetype + "Dev Block strings are not supported" + "Dev Block strings are not supported");
			#/
			/#
				Assert(IsArray(level.__ai_interface), "Dev Block strings are not supported");
			#/
			/#
				Assert(IsArray(level.__ai_interface[entity.archetype]), "Dev Block strings are not supported" + entity.archetype + "Dev Block strings are not supported");
			#/
			/#
				Assert(IsArray(level.__ai_interface[entity.archetype][attribute]), "Dev Block strings are not supported" + attribute + "Dev Block strings are not supported" + entity.archetype + "Dev Block strings are not supported");
			#/
			/#
				Assert(IsString(level.__ai_interface[entity.archetype][attribute]["Dev Block strings are not supported"]), "Dev Block strings are not supported" + attribute + "Dev Block strings are not supported");
			#/
		}
	#/
}

/*
	Name: _CheckRegistrationPrerequisites
	Namespace: ai_interface
	Checksum: 0x758169D8
	Offset: 0x6C0
	Size: 0xCB
	Parameters: 3
	Flags: Private
*/
function private _CheckRegistrationPrerequisites(archetype, attribute, callbackFunction)
{
	/#
		/#
			Assert(IsString(archetype), "Dev Block strings are not supported");
		#/
		/#
			Assert(IsString(attribute), "Dev Block strings are not supported");
		#/
		/#
			Assert(!isdefined(callbackFunction) || IsFunctionPtr(callbackFunction), "Dev Block strings are not supported");
		#/
	#/
}

/*
	Name: _InitializeLevelInterface
	Namespace: ai_interface
	Checksum: 0xC53888B5
	Offset: 0x798
	Size: 0x45
	Parameters: 1
	Flags: Private
*/
function private _InitializeLevelInterface(archetype)
{
	if(!isdefined(level.__ai_interface))
	{
		level.__ai_interface = [];
	}
	if(!isdefined(level.__ai_interface[archetype]))
	{
		level.__ai_interface[archetype] = [];
	}
}

#namespace ai;

/*
	Name: CreateInterfaceForEntity
	Namespace: ai
	Checksum: 0x16E05325
	Offset: 0x7E8
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function CreateInterfaceForEntity(entity)
{
	if(!isdefined(entity.__interface))
	{
		entity.__interface = [];
	}
}

/*
	Name: GetAiAttribute
	Namespace: ai
	Checksum: 0xF3E78B73
	Offset: 0x820
	Size: 0x87
	Parameters: 2
	Flags: None
*/
function GetAiAttribute(entity, attribute)
{
	/#
		ai_interface::_CheckPrerequisites(entity, attribute);
	#/
	if(!isdefined(entity.__interface[attribute]))
	{
		return level.__ai_interface[entity.archetype][attribute]["default_value"];
	}
	return entity.__interface[attribute];
}

/*
	Name: HasAiAttribute
	Namespace: ai
	Checksum: 0x1FEC0C42
	Offset: 0x8B0
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function HasAiAttribute(entity, attribute)
{
	return isdefined(entity) && isdefined(attribute) && isdefined(entity.archetype) && isdefined(level.__ai_interface) && isdefined(level.__ai_interface[entity.archetype]) && isdefined(level.__ai_interface[entity.archetype][attribute]);
}

/*
	Name: RegisterMatchedInterface
	Namespace: ai
	Checksum: 0x28515ADB
	Offset: 0x940
	Size: 0x1CB
	Parameters: 5
	Flags: None
*/
function RegisterMatchedInterface(archetype, attribute, defaultValue, possibleValues, callbackFunction)
{
	/#
		ai_interface::_CheckRegistrationPrerequisites(archetype, attribute, callbackFunction);
		/#
			Assert(!isdefined(possibleValues) || IsArray(possibleValues), "Dev Block strings are not supported");
		#/
	#/
	ai_interface::_InitializeLevelInterface(archetype);
	/#
		/#
			Assert(!isdefined(level.__ai_interface[archetype][attribute]), "Dev Block strings are not supported" + attribute + "Dev Block strings are not supported" + archetype + "Dev Block strings are not supported");
		#/
	#/
	level.__ai_interface[archetype][attribute] = [];
	level.__ai_interface[archetype][attribute]["callback"] = callbackFunction;
	level.__ai_interface[archetype][attribute]["default_value"] = defaultValue;
	level.__ai_interface[archetype][attribute]["type"] = "_interface_match";
	level.__ai_interface[archetype][attribute]["values"] = possibleValues;
	/#
		ai_interface::_CheckValue(archetype, attribute, defaultValue);
	#/
}

/*
	Name: RegisterNumericInterface
	Namespace: ai
	Checksum: 0x29BA9605
	Offset: 0xB18
	Size: 0x303
	Parameters: 6
	Flags: None
*/
function RegisterNumericInterface(archetype, attribute, defaultValue, minimum, maximum, callbackFunction)
{
	/#
		ai_interface::_CheckRegistrationPrerequisites(archetype, attribute, callbackFunction);
		/#
			Assert(!isdefined(minimum) || IsInt(minimum) || IsFloat(minimum), "Dev Block strings are not supported");
		#/
		/#
			Assert(!isdefined(maximum) || IsInt(maximum) || IsFloat(maximum), "Dev Block strings are not supported");
		#/
		/#
			Assert(!isdefined(minimum) && !isdefined(maximum) || (isdefined(minimum) && isdefined(maximum)), "Dev Block strings are not supported");
		#/
		/#
			Assert(!isdefined(minimum) && !isdefined(maximum) || minimum <= maximum, "Dev Block strings are not supported" + attribute + "Dev Block strings are not supported" + "Dev Block strings are not supported");
		#/
	#/
	ai_interface::_InitializeLevelInterface(archetype);
	/#
		/#
			Assert(!isdefined(level.__ai_interface[archetype][attribute]), "Dev Block strings are not supported" + attribute + "Dev Block strings are not supported" + archetype + "Dev Block strings are not supported");
		#/
	#/
	level.__ai_interface[archetype][attribute] = [];
	level.__ai_interface[archetype][attribute]["callback"] = callbackFunction;
	level.__ai_interface[archetype][attribute]["default_value"] = defaultValue;
	level.__ai_interface[archetype][attribute]["max_value"] = maximum;
	level.__ai_interface[archetype][attribute]["min_value"] = minimum;
	level.__ai_interface[archetype][attribute]["type"] = "_interface_numeric";
	/#
		ai_interface::_CheckValue(archetype, attribute, defaultValue);
	#/
}

/*
	Name: RegisterVectorInterface
	Namespace: ai
	Checksum: 0xE702D1D2
	Offset: 0xE28
	Size: 0x15B
	Parameters: 4
	Flags: None
*/
function RegisterVectorInterface(archetype, attribute, defaultValue, callbackFunction)
{
	/#
		ai_interface::_CheckRegistrationPrerequisites(archetype, attribute, callbackFunction);
	#/
	ai_interface::_InitializeLevelInterface(archetype);
	/#
		/#
			Assert(!isdefined(level.__ai_interface[archetype][attribute]), "Dev Block strings are not supported" + attribute + "Dev Block strings are not supported" + archetype + "Dev Block strings are not supported");
		#/
	#/
	level.__ai_interface[archetype][attribute] = [];
	level.__ai_interface[archetype][attribute]["callback"] = callbackFunction;
	level.__ai_interface[archetype][attribute]["default_value"] = defaultValue;
	level.__ai_interface[archetype][attribute]["type"] = "_interface_vector";
	/#
		ai_interface::_CheckValue(archetype, attribute, defaultValue);
	#/
}

/*
	Name: SetAiAttribute
	Namespace: ai
	Checksum: 0x4B1EB09
	Offset: 0xF90
	Size: 0x139
	Parameters: 3
	Flags: None
*/
function SetAiAttribute(entity, attribute, value)
{
	/#
		ai_interface::_CheckPrerequisites(entity, attribute);
		ai_interface::_CheckValue(entity.archetype, attribute, value);
	#/
	oldValue = entity.__interface[attribute];
	if(!isdefined(oldValue))
	{
		oldValue = level.__ai_interface[entity.archetype][attribute]["default_value"];
	}
	entity.__interface[attribute] = value;
	callback = level.__ai_interface[entity.archetype][attribute]["callback"];
	if(IsFunctionPtr(callback))
	{
		[[callback]](entity, attribute, oldValue, value);
	}
}

