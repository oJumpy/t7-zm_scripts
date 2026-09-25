#using scripts\shared\ai\systems\blackboard;

#namespace AnimationStateNetwork;

/*
	Name: InitNotetrackHandler
	Namespace: AnimationStateNetwork
	Checksum: 0xF8F80D1F
	Offset: 0xC0
	Size: 0xF
	Parameters: 0
	Flags: AutoExec
*/
function autoexec InitNotetrackHandler()
{
	level._NOTETRACK_HANDLER = [];
}

/*
	Name: RunNotetrackHandler
	Namespace: AnimationStateNetwork
	Checksum: 0x3DCF0A81
	Offset: 0xD8
	Size: 0x8D
	Parameters: 2
	Flags: Private
*/
function private RunNotetrackHandler(entity, notetracks)
{
	/#
		Assert(IsArray(notetracks));
	#/
	for(index = 0; index < notetracks.size; index++)
	{
		HandleNoteTrack(entity, notetracks[index]);
	}
}

/*
	Name: HandleNoteTrack
	Namespace: AnimationStateNetwork
	Checksum: 0x93449524
	Offset: 0x170
	Size: 0x9B
	Parameters: 2
	Flags: Private
*/
function private HandleNoteTrack(entity, Notetrack)
{
	NotetrackHandler = level._NOTETRACK_HANDLER[Notetrack];
	if(!isdefined(NotetrackHandler))
	{
		return;
	}
	if(IsFunctionPtr(NotetrackHandler))
	{
		[[NotetrackHandler]](entity);
	}
	else
	{
		blackboard::SetBlackBoardAttribute(entity, NotetrackHandler.blackboardAttributeName, NotetrackHandler.blackBoardValue);
	}
}

/*
	Name: RegisterNotetrackHandlerFunction
	Namespace: AnimationStateNetwork
	Checksum: 0x2FFE03ED
	Offset: 0x218
	Size: 0xD5
	Parameters: 2
	Flags: None
*/
function RegisterNotetrackHandlerFunction(notetrackname, notetrackFuncPtr)
{
	/#
		Assert(IsString(notetrackname), "Dev Block strings are not supported");
	#/
	/#
		Assert(IsFunctionPtr(notetrackFuncPtr), "Dev Block strings are not supported");
	#/
	/#
		Assert(!isdefined(level._NOTETRACK_HANDLER[notetrackname]), "Dev Block strings are not supported" + notetrackname + "Dev Block strings are not supported");
	#/
	level._NOTETRACK_HANDLER[notetrackname] = notetrackFuncPtr;
}

/*
	Name: RegisterBlackboardNotetrackHandler
	Namespace: AnimationStateNetwork
	Checksum: 0x7075B8B9
	Offset: 0x2F8
	Size: 0x71
	Parameters: 3
	Flags: None
*/
function RegisterBlackboardNotetrackHandler(notetrackname, blackboardAttributeName, blackBoardValue)
{
	NotetrackHandler = spawnstruct();
	NotetrackHandler.blackboardAttributeName = blackboardAttributeName;
	NotetrackHandler.blackBoardValue = blackBoardValue;
	level._NOTETRACK_HANDLER[notetrackname] = NotetrackHandler;
}

