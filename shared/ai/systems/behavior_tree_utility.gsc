#namespace BehaviorTreeNetwork;

/*
	Name: RegisterBehaviorTreeScriptAPIInternal
	Namespace: BehaviorTreeNetwork
	Checksum: 0x8007C77E
	Offset: 0xC0
	Size: 0xB5
	Parameters: 2
	Flags: None
*/
function RegisterBehaviorTreeScriptAPIInternal(functionName, functionPtr)
{
	if(!isdefined(level._BehaviorTreeScriptFunctions))
	{
		level._BehaviorTreeScriptFunctions = [];
	}
	functionName = ToLower(functionName);
	/#
		Assert(isdefined(functionName) && isdefined(functionPtr), "Dev Block strings are not supported");
	#/
	/#
		Assert(!isdefined(level._BehaviorTreeScriptFunctions[functionName]), "Dev Block strings are not supported");
	#/
	level._BehaviorTreeScriptFunctions[functionName] = functionPtr;
}

/*
	Name: RegisterBehaviorTreeActionInternal
	Namespace: BehaviorTreeNetwork
	Checksum: 0x23618E0F
	Offset: 0x180
	Size: 0x1F7
	Parameters: 4
	Flags: None
*/
function RegisterBehaviorTreeActionInternal(actionName, startFuncPtr, updateFuncPtr, terminateFuncPtr)
{
	if(!isdefined(level._BehaviorTreeActions))
	{
		level._BehaviorTreeActions = [];
	}
	actionName = ToLower(actionName);
	/#
		Assert(IsString(actionName), "Dev Block strings are not supported");
	#/
	/#
		Assert(!isdefined(level._BehaviorTreeActions[actionName]), "Dev Block strings are not supported" + actionName + "Dev Block strings are not supported");
	#/
	level._BehaviorTreeActions[actionName] = Array();
	if(isdefined(startFuncPtr))
	{
		/#
			Assert(IsFunctionPtr(startFuncPtr), "Dev Block strings are not supported");
		#/
		level._BehaviorTreeActions[actionName]["bhtn_action_start"] = startFuncPtr;
	}
	if(isdefined(updateFuncPtr))
	{
		/#
			Assert(IsFunctionPtr(updateFuncPtr), "Dev Block strings are not supported");
		#/
		level._BehaviorTreeActions[actionName]["bhtn_action_update"] = updateFuncPtr;
	}
	if(isdefined(terminateFuncPtr))
	{
		/#
			Assert(IsFunctionPtr(terminateFuncPtr), "Dev Block strings are not supported");
		#/
		level._BehaviorTreeActions[actionName]["bhtn_action_terminate"] = terminateFuncPtr;
	}
}

#namespace BehaviorTreeNetworkUtility;

/*
	Name: RegisterBehaviorTreeScriptAPI
	Namespace: BehaviorTreeNetworkUtility
	Checksum: 0xD6399A01
	Offset: 0x380
	Size: 0x2B
	Parameters: 2
	Flags: None
*/
function RegisterBehaviorTreeScriptAPI(functionName, functionPtr)
{
	BehaviorTreeNetwork::RegisterBehaviorTreeScriptAPIInternal(functionName, functionPtr);
}

/*
	Name: RegisterBehaviorTreeAction
	Namespace: BehaviorTreeNetworkUtility
	Checksum: 0x1B4911C3
	Offset: 0x3B8
	Size: 0x43
	Parameters: 4
	Flags: None
*/
function RegisterBehaviorTreeAction(actionName, startFuncPtr, updateFuncPtr, terminateFuncPtr)
{
	BehaviorTreeNetwork::RegisterBehaviorTreeActionInternal(actionName, startFuncPtr, updateFuncPtr, terminateFuncPtr);
}

