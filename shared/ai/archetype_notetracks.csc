#using scripts\shared\ai_shared;
#using scripts\shared\util_shared;

#namespace notetracks;

/*
	Name: main
	Namespace: notetracks
	Checksum: 0xC0D60468
	Offset: 0x138
	Size: 0x8B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	if(SessionModeIsZombiesGame() && GetDvarInt("splitscreen_playerCount") > 2)
	{
		return;
	}
	if(SessionModeIsCampaignDeadOpsGame() && GetDvarInt("splitscreen_playerCount") > 2)
	{
		return;
	}
	ai::add_ai_spawn_function(&InitializeNotetrackHandlers);
}

/*
	Name: InitializeNotetrackHandlers
	Namespace: notetracks
	Checksum: 0xCB1D4E7F
	Offset: 0x1D0
	Size: 0x83
	Parameters: 1
	Flags: Private
*/
function private InitializeNotetrackHandlers(localClientNum)
{
	AddSurfaceNotetrackFXHandler(localClientNum, "jumping", "surfacefxtable_jumping");
	AddSurfaceNotetrackFXHandler(localClientNum, "landing", "surfacefxtable_landing");
	AddSurfaceNotetrackFXHandler(localClientNum, "vtol_landing", "surfacefxtable_vtollanding");
}

/*
	Name: AddSurfaceNotetrackFXHandler
	Namespace: notetracks
	Checksum: 0xAD88A276
	Offset: 0x260
	Size: 0x4B
	Parameters: 3
	Flags: Private
*/
function private AddSurfaceNotetrackFXHandler(localClientNum, Notetrack, surfaceTable)
{
	entity = self;
	entity thread HandleSurfaceNotetrackFX(localClientNum, Notetrack, surfaceTable);
}

/*
	Name: HandleSurfaceNotetrackFX
	Namespace: notetracks
	Checksum: 0xAFA940E2
	Offset: 0x2B8
	Size: 0xAF
	Parameters: 3
	Flags: Private
*/
function private HandleSurfaceNotetrackFX(localClientNum, Notetrack, surfaceTable)
{
	entity = self;
	entity endon("entityshutdown");
	while(1)
	{
		entity waittill(Notetrack);
		fxName = entity GetAIFxName(localClientNum, surfaceTable);
		if(isdefined(fxName))
		{
			playFX(localClientNum, fxName, entity.origin);
		}
	}
}

