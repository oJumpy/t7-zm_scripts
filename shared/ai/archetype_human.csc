#using scripts\shared\ai\systems\fx_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\util_shared;

#namespace ARCHETYPE_HUMAN;

/*
	Name: Precache
	Namespace: ARCHETYPE_HUMAN
	Checksum: 0x99EC1590
	Offset: 0x170
	Size: 0x3
	Parameters: 0
	Flags: AutoExec
*/
function autoexec Precache()
{
}

/*
	Name: main
	Namespace: ARCHETYPE_HUMAN
	Checksum: 0xD88AF5A1
	Offset: 0x180
	Size: 0x4B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("actor", "facial_dial", 1, 1, "int", &HumanClientUtils::facialDialogueHandler, 0, 1);
}

#namespace HumanClientUtils;

/*
	Name: facialDialogueHandler
	Namespace: HumanClientUtils
	Checksum: 0xD40EE132
	Offset: 0x1D8
	Size: 0x8B
	Parameters: 7
	Flags: None
*/
function facialDialogueHandler(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue)
	{
		self.facialDialogueActive = 1;
	}
	else if(isdefined(self.facialDialogueActive) && self.facialDialogueActive)
	{
		self ClearAnim(%faces, 0);
	}
}

