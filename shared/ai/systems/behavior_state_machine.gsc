#namespace BehaviorStateMachine;

/*
	Name: RegisterBSMScriptAPIInternal
	Namespace: BehaviorStateMachine
	Checksum: 0x2B8AA8F7
	Offset: 0x88
	Size: 0xB5
	Parameters: 2
	Flags: None
*/
function RegisterBSMScriptAPIInternal(functionName, scriptFunction)
{
	if(!isdefined(level._bsmscriptfunctions))
	{
		level._bsmscriptfunctions = [];
	}
	functionName = ToLower(functionName);
	/#
		Assert(isdefined(scriptFunction) && isdefined(scriptFunction), "Dev Block strings are not supported");
	#/
	/#
		Assert(!isdefined(level._bsmscriptfunctions[functionName]), "Dev Block strings are not supported");
	#/
	level._bsmscriptfunctions[functionName] = scriptFunction;
}

