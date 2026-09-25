#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_filter;

#namespace _zm_pack_a_punch;

/*
	Name: __init__sytem__
	Namespace: _zm_pack_a_punch
	Checksum: 0x58763584
	Offset: 0x248
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_pack_a_punch", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _zm_pack_a_punch
	Checksum: 0x6C3915B8
	Offset: 0x288
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["pap_working_fx"] = "dlc1/castle/fx_packapunch_castle";
	clientfield::register("zbarrier", "pap_working_FX", 5000, 1, "int", &pap_working_FX_handler, 0, 0);
}

/*
	Name: pap_working_FX_handler
	Namespace: _zm_pack_a_punch
	Checksum: 0x8FDC16D5
	Offset: 0x2F8
	Size: 0xD3
	Parameters: 7
	Flags: None
*/
function pap_working_FX_handler(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		pap_play_fx(localClientNum, 0, "base_jnt");
	}
	else if(isdefined(self.n_pap_fx))
	{
		stopfx(localClientNum, self.n_pap_fx);
		self.n_pap_fx = undefined;
	}
	wait(1);
	if(isdefined(self.mdl_fx))
	{
		self.mdl_fx delete();
	}
}

/*
	Name: pap_play_fx
	Namespace: _zm_pack_a_punch
	Checksum: 0x7EFDDBA2
	Offset: 0x3D8
	Size: 0x14B
	Parameters: 3
	Flags: Private
*/
function private pap_play_fx(localClientNum, n_piece_index, str_tag)
{
	mdl_piece = self ZBarrierGetPiece(n_piece_index);
	if(isdefined(self.mdl_fx))
	{
		self.mdl_fx delete();
	}
	if(isdefined(self.n_pap_fx))
	{
		deletefx(localClientNum, self.n_pap_fx);
		self.n_pap_fx = undefined;
	}
	self.mdl_fx = util::spawn_model(localClientNum, "tag_origin", mdl_piece GetTagOrigin(str_tag), mdl_piece GetTagAngles(str_tag));
	self.mdl_fx LinkTo(mdl_piece, str_tag);
	self.n_pap_fx = PlayFXOnTag(localClientNum, level._effect["pap_working_fx"], self.mdl_fx, "tag_origin");
}

