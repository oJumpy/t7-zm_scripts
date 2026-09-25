#using scripts\shared\aat_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace zm_aat_fire_works;

/*
	Name: __init__sytem__
	Namespace: zm_aat_fire_works
	Checksum: 0x466D6962
	Offset: 0x168
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_aat_fire_works", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_aat_fire_works
	Checksum: 0x8DB38E05
	Offset: 0x1A8
	Size: 0xA5
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use))
	{
		return;
	}
	AAT::register("zm_aat_fire_works", "zmui_zm_aat_fire_works", "t7_icon_zm_aat_fire_works");
	clientfield::register("scriptmover", "zm_aat_fire_works", 1, 1, "int", &zm_aat_fire_works_summon, 0, 0);
	level._effect["zm_aat_fire_works"] = "zombie/fx_aat_fireworks_zmb";
}

/*
	Name: zm_aat_fire_works_summon
	Namespace: zm_aat_fire_works
	Checksum: 0xF595EF0E
	Offset: 0x258
	Size: 0x115
	Parameters: 7
	Flags: None
*/
function zm_aat_fire_works_summon(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.aat_fire_works_fx = playFX(localClientNum, "zombie/fx_aat_fireworks_zmb", self.origin, AnglesToForward(self.angles));
		playsound(localClientNum, "wpn_aat_firework_explo", self.origin);
		if(IsDemoPlaying())
		{
			self thread kill_fx_on_demo_jump(localClientNum);
		}
	}
	else if(isdefined(self.aat_fire_works_fx))
	{
		self notify("kill_fx_on_demo_jump");
		stopfx(localClientNum, self.aat_fire_works_fx);
		self.aat_fire_works_fx = undefined;
	}
}

/*
	Name: kill_fx_on_demo_jump
	Namespace: zm_aat_fire_works
	Checksum: 0x68A80B30
	Offset: 0x378
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function kill_fx_on_demo_jump(localClientNum)
{
	self notify("kill_fx_on_demo_jump");
	self endon("kill_fx_on_demo_jump");
	level waittill("demo_jump");
	if(isdefined(self.aat_fire_works_fx))
	{
		stopfx(localClientNum, self.aat_fire_works_fx);
		self.aat_fire_works_fx = undefined;
	}
}

