#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\system_shared;

#namespace zm_zod_transformer;

/*
	Name: __init__sytem__
	Namespace: zm_zod_transformer
	Checksum: 0x603E7BF9
	Offset: 0x148
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_transformer", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_transformer
	Checksum: 0x15052C5A
	Offset: 0x188
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	n_bits = GetMinBitCountForNum(16);
	clientfield::register("scriptmover", "transformer_light_switch", 1, n_bits, "int", &transformer_light_switch, 0, 0);
}

/*
	Name: transformer_light_switch
	Namespace: zm_zod_transformer
	Checksum: 0x41F0C6D2
	Offset: 0x200
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function transformer_light_switch(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		exploder::exploder("powerbox_" + newVal);
	}
}

