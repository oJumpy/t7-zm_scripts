#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#namespace zm_tomb_quest_fire;

/*
	Name: main
	Namespace: zm_tomb_quest_fire
	Checksum: 0x9F4233FC
	Offset: 0x1A8
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function main()
{
	clientfield::register("scriptmover", "barbecue_fx", 21000, 1, "int", &barbecue_fx, 0, 0);
}

/*
	Name: barbecue_fx_loop
	Namespace: zm_tomb_quest_fire
	Checksum: 0x7BEC3A4F
	Offset: 0x200
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function barbecue_fx_loop(localClientNum)
{
	self notify("stop_bbq_fx_loop");
	self endon("stop_bbq_fx_loop");
	self endon("entityshutdown");
	while(1)
	{
		PlayFXOnTag(localClientNum, level._effect["fire_sacrifice_flame"], self, "tag_origin");
		wait(0.5);
	}
}

/*
	Name: barbecue_fx
	Namespace: zm_tomb_quest_fire
	Checksum: 0x47660F45
	Offset: 0x280
	Size: 0x85
	Parameters: 7
	Flags: None
*/
function barbecue_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		self thread barbecue_fx_loop(localClientNum);
		level thread function_ebebc90(self);
	}
	else
	{
		self notify("stop_bbq_fx_loop");
	}
}

/*
	Name: function_ebebc90
	Namespace: zm_tomb_quest_fire
	Checksum: 0x2CA25794
	Offset: 0x310
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function function_ebebc90(entity)
{
	origin = entity.origin;
	audio::playloopat("zmb_squest_fire_bbq_lp", origin);
	entity util::waittill_any("stop_bbq_fx_loop", "entityshutdown");
	audio::stoploopat("zmb_squest_fire_bbq_lp", origin);
}

