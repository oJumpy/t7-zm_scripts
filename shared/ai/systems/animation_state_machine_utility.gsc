#using scripts\shared\ai\archetype_utility;

#namespace AnimationStateNetworkUtility;

/*
	Name: RequestState
	Namespace: AnimationStateNetworkUtility
	Checksum: 0x435607BF
	Offset: 0xC0
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function RequestState(entity, stateName)
{
	/#
		Assert(isdefined(entity));
	#/
	entity ASMRequestSubstate(stateName);
}

/*
	Name: SearchAnimationMap
	Namespace: AnimationStateNetworkUtility
	Checksum: 0xBE537519
	Offset: 0x118
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function SearchAnimationMap(entity, aliasname)
{
	if(isdefined(entity) && isdefined(aliasname))
	{
		animationName = entity AnimMappingSearch(istring(aliasname));
		if(isdefined(animationName))
		{
			return FindAnimByName("generic", animationName);
		}
	}
}

