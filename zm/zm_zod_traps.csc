#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
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

#namespace namespace_d8d03071;

/*
	Name: __init__sytem__
	Namespace: namespace_d8d03071
	Checksum: 0xB7499AD7
	Offset: 0x528
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_traps", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_d8d03071
	Checksum: 0x54CBFDDC
	Offset: 0x568
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "trap_chain_state", 1, 2, "int", &function_470e01bb, 0, 0);
	clientfield::register("scriptmover", "trap_chain_location", 1, 2, "int", &function_4903bbf5, 0, 0);
}

/*
	Name: function_470e01bb
	Namespace: namespace_d8d03071
	Checksum: 0xF418AB20
	Offset: 0x608
	Size: 0x17B
	Parameters: 7
	Flags: None
*/
function function_470e01bb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_4951672f = [];
	var_4951672f[0] = "theater";
	var_4951672f[1] = "slums";
	var_4951672f[2] = "canals";
	var_4951672f[3] = "pap";
	var_6f7d4e5a = self clientfield::get("trap_chain_location");
	var_d42f02cf = var_4951672f[var_6f7d4e5a];
	var_2ff7b73d = GetEntArray(localClientNum, "fxanim_chain_trap", "targetname");
	var_2ff7b73d = Array::filter(var_2ff7b73d, 0, &function_1bfbfa4c, var_d42f02cf);
	if(var_2ff7b73d.size > 0)
	{
		Array::thread_all(var_2ff7b73d, &function_53aebe0a, localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName);
	}
}

/*
	Name: function_4903bbf5
	Namespace: namespace_d8d03071
	Checksum: 0x87806552
	Offset: 0x790
	Size: 0x3B
	Parameters: 7
	Flags: None
*/
function function_4903bbf5(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
}

/*
	Name: function_1bfbfa4c
	Namespace: namespace_d8d03071
	Checksum: 0x131B17F7
	Offset: 0x7D8
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function function_1bfbfa4c(e_entity, var_d42f02cf)
{
	if(e_entity.script_noteworthy !== var_d42f02cf)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_53aebe0a
	Namespace: namespace_d8d03071
	Checksum: 0x632CE833
	Offset: 0x818
	Size: 0x18D
	Parameters: 7
	Flags: None
*/
function function_53aebe0a(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self notify("hash_53aebe0a");
	self endon("hash_53aebe0a");
	var_9f9d6054 = self;
	var_9f9d6054 util::waittill_dobj(localClientNum);
	switch(newVal)
	{
		case 0:
		{
			self thread function_406fdb8("p7_fxanim_zm_zod_chain_trap_symbol_off_bundle", self);
			break;
		}
		case 1:
		{
			var_9f9d6054 show();
			scene::stop("p7_fxanim_zm_zod_chain_trap_symbol_off_bundle");
			self thread function_406fdb8("p7_fxanim_zm_zod_chain_trap_symbol_on_bundle", self);
			break;
		}
		case 2:
		{
			self scene::stop();
			var_9f9d6054 thread function_a89bd6f9();
			break;
		}
		case 3:
		{
			while(isdefined(self.var_d8823dfd))
			{
				wait(0.01);
			}
			self thread function_406fdb8("p7_fxanim_zm_zod_chain_trap_symbol_off_bundle", self);
			break;
		}
	}
}

/*
	Name: function_406fdb8
	Namespace: namespace_d8d03071
	Checksum: 0xD7013C9D
	Offset: 0x9B0
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function function_406fdb8(scene, var_165d49f6)
{
	self notify("hash_406fdb8");
	self endon("hash_406fdb8");
	self scene::stop();
	self function_6221b6b9(scene, var_165d49f6);
	self scene::stop();
}

/*
	Name: function_6221b6b9
	Namespace: namespace_d8d03071
	Checksum: 0x532443A6
	Offset: 0xA38
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function function_6221b6b9(scene, var_165d49f6)
{
	level endon("demo_jump");
	self scene::Play(scene, var_165d49f6);
}

/*
	Name: function_a89bd6f9
	Namespace: namespace_d8d03071
	Checksum: 0x3AE9D485
	Offset: 0xA80
	Size: 0x1CD
	Parameters: 0
	Flags: None
*/
function function_a89bd6f9()
{
	self.var_d8823dfd = 1;
	self StopAllLoopSounds();
	self playsound(0, "evt_chaintrap_start");
	self PlayLoopSound("evt_chaintrap_loop", 0.5);
	scene::stop("p7_fxanim_zm_zod_chain_trap_symbol_on_bundle");
	function_3f7430db();
	scene::Play(self.var_b33065b0, self);
	self thread scene::Play(self.var_68a0b25, self);
	n_start_time = getanimlength(self.var_b33065b0);
	var_b13eaf00 = getanimlength(self.var_aec39a66);
	n_time = 15;
	wait(n_time);
	scene::stop(self.var_68a0b25);
	scene::Play(self.var_aec39a66, self);
	self thread scene::Play("p7_fxanim_zm_zod_chain_trap_symbol_off_bundle", self);
	self StopAllLoopSounds(0.5);
	self PlayLoopSound("evt_chaintrap_idle");
	self.var_d8823dfd = undefined;
}

/*
	Name: function_3f7430db
	Namespace: namespace_d8d03071
	Checksum: 0xE7D8A97F
	Offset: 0xC58
	Size: 0x111
	Parameters: 0
	Flags: None
*/
function function_3f7430db()
{
	switch(self.script_noteworthy)
	{
		case "pap":
		{
			self.var_b33065b0 = "p7_fxanim_zm_zod_chain_trap_pap_start_bundle";
			self.var_68a0b25 = "p7_fxanim_zm_zod_chain_trap_pap_on_bundle";
			self.var_aec39a66 = "p7_fxanim_zm_zod_chain_trap_pap_end_bundle";
			break;
		}
		case "canals":
		{
			self.var_b33065b0 = "p7_fxanim_zm_zod_chain_trap_canal_start_bundle";
			self.var_68a0b25 = "p7_fxanim_zm_zod_chain_trap_canal_on_bundle";
			self.var_aec39a66 = "p7_fxanim_zm_zod_chain_trap_canal_end_bundle";
			break;
		}
		case "slums":
		{
			self.var_b33065b0 = "p7_fxanim_zm_zod_chain_trap_waterfront_start_bundle";
			self.var_68a0b25 = "p7_fxanim_zm_zod_chain_trap_waterfront_on_bundle";
			self.var_aec39a66 = "p7_fxanim_zm_zod_chain_trap_waterfront_end_bundle";
			break;
		}
		case "theater":
		case default:
		{
			self.var_b33065b0 = "p7_fxanim_zm_zod_chain_trap_footlight_start_bundle";
			self.var_68a0b25 = "p7_fxanim_zm_zod_chain_trap_footlight_on_bundle";
			self.var_aec39a66 = "p7_fxanim_zm_zod_chain_trap_footlight_end_bundle";
			break;
		}
	}
}

