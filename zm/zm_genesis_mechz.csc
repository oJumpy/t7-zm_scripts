#using scripts\codescripts\struct;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_genesis_mechz;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_mechz
	Checksum: 0xF7C34F46
	Offset: 0x2B0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_mechz", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_mechz
	Checksum: 0xCF13C96E
	Offset: 0x2F0
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["tesla_zombie_shock"] = "dlc4/genesis/fx_elec_trap_body_shock";
	if(ai::shouldRegisterClientFieldForArchetype("mechz"))
	{
		clientfield::register("actor", "death_ray_shock_fx", 15000, 1, "int", &death_ray_shock_fx, 0, 0);
	}
	clientfield::register("actor", "mechz_fx_spawn", 15000, 1, "counter", &function_4b9cfd4c, 0, 0);
}

/*
	Name: death_ray_shock_fx
	Namespace: zm_genesis_mechz
	Checksum: 0x6328DA43
	Offset: 0x3C0
	Size: 0x123
	Parameters: 7
	Flags: None
*/
function death_ray_shock_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self stop_death_ray_shock_fx(localClientNum);
	if(newVal)
	{
		if(!isdefined(self.tesla_shock_fx))
		{
			tag = "J_SpineUpper";
			if(!self isai())
			{
				tag = "tag_origin";
			}
			self.tesla_shock_fx = PlayFXOnTag(localClientNum, level._effect["tesla_zombie_shock"], self, tag);
			self playsound(0, "zmb_electrocute_zombie");
		}
		if(IsDemoPlaying())
		{
			self thread function_7772592b(localClientNum);
		}
	}
}

/*
	Name: function_7772592b
	Namespace: zm_genesis_mechz
	Checksum: 0xF53BC5BA
	Offset: 0x4F0
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function function_7772592b(localClientNum)
{
	self notify("stop_death_ray_shock_fx");
	self endon("stop_death_ray_shock_fx");
	level waittill("demo_jump");
	self stop_death_ray_shock_fx(localClientNum);
}

/*
	Name: stop_death_ray_shock_fx
	Namespace: zm_genesis_mechz
	Checksum: 0xB537C374
	Offset: 0x548
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function stop_death_ray_shock_fx(localClientNum)
{
	if(isdefined(self.tesla_shock_fx))
	{
		deletefx(localClientNum, self.tesla_shock_fx, 1);
		self.tesla_shock_fx = undefined;
	}
	self notify("stop_death_ray_shock_fx");
}

/*
	Name: function_4b9cfd4c
	Namespace: zm_genesis_mechz
	Checksum: 0xEDC769C0
	Offset: 0x5A8
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function function_4b9cfd4c(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue)
	{
		self.spawnFx = PlayFXOnTag(localClientNum, level._effect["mechz_ground_spawn"], self, "tag_origin");
		playsound(0, "zmb_mechz_spawn_nofly", self.origin);
	}
}

