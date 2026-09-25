#namespace AnimationStateNetwork;

/*
	Name: InitAnimationMocomps
	Namespace: AnimationStateNetwork
	Checksum: 0x7DC7C359
	Offset: 0xC8
	Size: 0xF
	Parameters: 0
	Flags: AutoExec
*/
function autoexec InitAnimationMocomps()
{
	level._AnimationMocomps = [];
}

/*
	Name: RunAnimationMocomp
	Namespace: AnimationStateNetwork
	Checksum: 0xB8F8ACDE
	Offset: 0xE0
	Size: 0x13B
	Parameters: 6
	Flags: None
*/
function RunAnimationMocomp(mocompName, mocompStatus, asmEntity, mocompAnim, mocompAnimBlendOutTime, mocompDuration)
{
	/#
		Assert(mocompStatus >= 0 && mocompStatus <= 2, "Dev Block strings are not supported" + mocompStatus + "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(level._AnimationMocomps[mocompName]), "Dev Block strings are not supported" + mocompName + "Dev Block strings are not supported");
	#/
	if(mocompStatus == 0)
	{
		mocompStatus = "asm_mocomp_start";
	}
	else if(mocompStatus == 1)
	{
		mocompStatus = "asm_mocomp_update";
	}
	else
	{
		mocompStatus = "asm_mocomp_terminate";
	}
	animationMocompResult = asmEntity [[level._AnimationMocomps[mocompName][mocompStatus]]](asmEntity, mocompAnim, mocompAnimBlendOutTime, "", mocompDuration);
	return animationMocompResult;
}

/*
	Name: RegisterAnimationMocomp
	Namespace: AnimationStateNetwork
	Checksum: 0x789731E0
	Offset: 0x228
	Size: 0x233
	Parameters: 4
	Flags: None
*/
function RegisterAnimationMocomp(mocompName, startFuncPtr, updateFuncPtr, terminateFuncPtr)
{
	mocompName = ToLower(mocompName);
	/#
		Assert(IsString(mocompName), "Dev Block strings are not supported");
	#/
	/#
		Assert(!isdefined(level._AnimationMocomps[mocompName]), "Dev Block strings are not supported" + mocompName + "Dev Block strings are not supported");
	#/
	level._AnimationMocomps[mocompName] = Array();
	/#
		Assert(isdefined(startFuncPtr) && IsFunctionPtr(startFuncPtr), "Dev Block strings are not supported");
	#/
	level._AnimationMocomps[mocompName]["asm_mocomp_start"] = startFuncPtr;
	if(isdefined(updateFuncPtr))
	{
		/#
			Assert(IsFunctionPtr(updateFuncPtr), "Dev Block strings are not supported");
		#/
		level._AnimationMocomps[mocompName]["asm_mocomp_update"] = updateFuncPtr;
	}
	else
	{
		level._AnimationMocomps[mocompName]["asm_mocomp_update"] = &AnimationMocompEmptyFunc;
	}
	if(isdefined(terminateFuncPtr))
	{
		/#
			Assert(IsFunctionPtr(terminateFuncPtr), "Dev Block strings are not supported");
		#/
		level._AnimationMocomps[mocompName]["asm_mocomp_terminate"] = terminateFuncPtr;
	}
	else
	{
		level._AnimationMocomps[mocompName]["asm_mocomp_terminate"] = &AnimationMocompEmptyFunc;
	}
}

/*
	Name: AnimationMocompEmptyFunc
	Namespace: AnimationStateNetwork
	Checksum: 0x2CF62241
	Offset: 0x468
	Size: 0x2B
	Parameters: 5
	Flags: None
*/
function AnimationMocompEmptyFunc(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
}

