#namespace blackboard;

/*
	Name: RegisterBlackBoardAttribute
	Namespace: blackboard
	Checksum: 0x13510906
	Offset: 0x80
	Size: 0x11D
	Parameters: 4
	Flags: None
*/
function RegisterBlackBoardAttribute(entity, attributeName, defaultAttributeValue, getterFunction)
{
	/#
		Assert(isdefined(entity.__blackboard), "Dev Block strings are not supported");
	#/
	/#
		Assert(!isdefined(entity.__blackboard[attributeName]), "Dev Block strings are not supported" + attributeName + "Dev Block strings are not supported");
	#/
	if(isdefined(getterFunction))
	{
		/#
			Assert(IsFunctionPtr(getterFunction));
		#/
		entity.__blackboard[attributeName] = getterFunction;
	}
	else if(!isdefined(defaultAttributeValue))
	{
		defaultAttributeValue = undefined;
	}
	entity.__blackboard[attributeName] = defaultAttributeValue;
}

/*
	Name: GetBlackBoardAttribute
	Namespace: blackboard
	Checksum: 0x2BC848D0
	Offset: 0x1A8
	Size: 0x111
	Parameters: 2
	Flags: None
*/
function GetBlackBoardAttribute(entity, attributeName)
{
	if(IsFunctionPtr(entity.__blackboard[attributeName]))
	{
		getterFunction = entity.__blackboard[attributeName];
		attributeValue = entity [[getterFunction]]();
		/#
			if(IsActor(entity))
			{
				entity updatetrackedblackboardattribute(attributeName);
			}
		#/
		return attributeValue;
	}
	else
	{
		if(IsActor(entity))
		{
			entity updatetrackedblackboardattribute(attributeName);
		}
		return entity.__blackboard[attributeName];
	}
	/#
	#/
}

/*
	Name: SetBlackBoardAttribute
	Namespace: blackboard
	Checksum: 0xD86DD684
	Offset: 0x2C8
	Size: 0x10B
	Parameters: 3
	Flags: None
*/
function SetBlackBoardAttribute(entity, attributeName, attributeValue)
{
	if(isdefined(entity.__blackboard[attributeName]))
	{
		if(!isdefined(attributeValue) && IsFunctionPtr(entity.__blackboard[attributeName]))
		{
			return;
		}
		/#
			Assert(!IsFunctionPtr(entity.__blackboard[attributeName]), "Dev Block strings are not supported");
		#/
	}
	entity.__blackboard[attributeName] = attributeValue;
	/#
		if(IsActor(entity))
		{
			entity updatetrackedblackboardattribute(attributeName);
		}
	#/
}

/*
	Name: CreateBlackBoardForEntity
	Namespace: blackboard
	Checksum: 0x3811A412
	Offset: 0x3E0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function CreateBlackBoardForEntity(entity)
{
	if(!isdefined(entity.__blackboard))
	{
		entity.__blackboard = [];
	}
	if(!isdefined(level._setBlackboardAttributeFunc))
	{
		level._setBlackboardAttributeFunc = &SetBlackBoardAttribute;
	}
}

