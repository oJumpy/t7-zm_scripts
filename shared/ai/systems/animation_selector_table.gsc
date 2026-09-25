#namespace AnimationSelectorTable;

/*
	Name: RegisterAnimationSelectorTableEvaluator
	Namespace: AnimationSelectorTable
	Checksum: 0x9C7915C
	Offset: 0x88
	Size: 0xA5
	Parameters: 2
	Flags: None
*/
function RegisterAnimationSelectorTableEvaluator(functionName, functionPtr)
{
	if(!isdefined(level._astevaluatorscriptfunctions))
	{
		level._astevaluatorscriptfunctions = [];
	}
	functionName = ToLower(functionName);
	/#
		Assert(isdefined(functionName) && isdefined(functionPtr));
	#/
	/#
		Assert(!isdefined(level._astevaluatorscriptfunctions[functionName]));
	#/
	level._astevaluatorscriptfunctions[functionName] = functionPtr;
}

