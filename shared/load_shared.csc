#using scripts\shared\_explode;
#using scripts\shared\blood;
#using scripts\shared\drown;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\fx_shared;
#using scripts\shared\player_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\water_surface;
#using scripts\shared\weapons\_empgrenade;
#using scripts\shared\weapons_shared;

#namespace load;

/*
	Name: __init__sytem__
	Namespace: load
	Checksum: 0xA6285F1A
	Offset: 0x228
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("load", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: load
	Checksum: 0xEB152B63
	Offset: 0x268
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	/#
		level thread first_frame();
	#/
	function_b018f2a7();
}

/*
	Name: first_frame
	Namespace: load
	Checksum: 0xBF1FDC1
	Offset: 0x2A0
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function first_frame()
{
	/#
		level.first_frame = 1;
		wait(0.05);
		level.first_frame = undefined;
	#/
}

/*
	Name: function_b018f2a7
	Namespace: load
	Checksum: 0xCB85F097
	Offset: 0x2D0
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_b018f2a7()
{
	var_ae867510 = GetDvarFloat("tu16_physicsPushOutThreshold", -1);
	if(var_ae867510 != -1)
	{
		SetDvar("tu16_physicsPushOutThreshold", 20);
	}
}

/*
	Name: art_review
	Namespace: load
	Checksum: 0xC008A629
	Offset: 0x340
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function art_review()
{
	if(GetDvarString("art_review") == "")
	{
		SetDvar("art_review", "0");
	}
	if(GetDvarString("art_review") == "1")
	{
		level waittill("forever");
	}
}

