#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace gadget_roulette;

/*
	Name: __init__sytem__
	Namespace: gadget_roulette
	Checksum: 0xFC02A92D
	Offset: 0x188
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_roulette", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: gadget_roulette
	Checksum: 0xDE03DE54
	Offset: 0x1C8
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "roulette_state", 11000, 2, "int", &roulette_clientfield_cb, 0, 0);
	callback::on_localplayer_spawned(&on_localplayer_spawned);
}

/*
	Name: roulette_clientfield_cb
	Namespace: gadget_roulette
	Checksum: 0x58A93926
	Offset: 0x240
	Size: 0x53
	Parameters: 7
	Flags: None
*/
function roulette_clientfield_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	update_roulette(localClientNum, newVal);
}

/*
	Name: update_roulette
	Namespace: gadget_roulette
	Checksum: 0x1896B8F6
	Offset: 0x2A0
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function update_roulette(localClientNum, newVal)
{
	controllerModel = GetUIModelForController(localClientNum);
	if(isdefined(controllerModel))
	{
		rouletteStatusModel = GetUIModel(controllerModel, "playerAbilities.playerGadget3.rouletteStatus");
		if(isdefined(rouletteStatusModel))
		{
			SetUIModelValue(rouletteStatusModel, newVal);
		}
	}
}

/*
	Name: on_localplayer_spawned
	Namespace: gadget_roulette
	Checksum: 0x2086FA7B
	Offset: 0x338
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function on_localplayer_spawned(localClientNum)
{
	roulette_state = 0;
	if(getserverhighestclientfieldversion() >= 11000)
	{
		roulette_state = self clientfield::get_to_player("roulette_state");
	}
	update_roulette(localClientNum, roulette_state);
}

