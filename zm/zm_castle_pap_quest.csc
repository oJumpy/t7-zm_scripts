#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\zm\_zm_pack_a_punch;

#namespace namespace_155a700c;

/*
	Name: main
	Namespace: namespace_155a700c
	Checksum: 0x72592320
	Offset: 0x140
	Size: 0x2D
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	register_clientfields();
	level._effect["pap_tp"] = "dlc1/castle/fx_castle_pap_reform";
}

/*
	Name: register_clientfields
	Namespace: namespace_155a700c
	Checksum: 0x3F56612B
	Offset: 0x178
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("scriptmover", "pap_tp_fx", 5000, 1, "counter", &function_58d6b2a0, 0, 0);
}

/*
	Name: function_58d6b2a0
	Namespace: namespace_155a700c
	Checksum: 0xB5FAD7C4
	Offset: 0x1D0
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_58d6b2a0(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	playFX(localClientNum, level._effect["pap_tp"], self.origin);
}

