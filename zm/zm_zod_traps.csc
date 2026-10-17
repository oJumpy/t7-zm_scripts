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
	clientfield::register("scriptmover", "trap_chain_state", 1, 2, "int", &update_chain_anims, 0, 0);
	clientfield::register("scriptmover", "trap_chain_location", 1, 2, "int", &location_func, 0, 0);
}

/*
	Name: update_chain_anims
	Namespace: namespace_d8d03071
	Checksum: 0xF418AB20
	Offset: 0x608
	Size: 0x17B
	Parameters: 7
	Flags: None
*/
function update_chain_anims(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	a_str_areaname = [];
	a_str_areaname[0] = "theater";
	a_str_areaname[1] = "slums";
	a_str_areaname[2] = "canals";
	a_str_areaname[3] = "pap";
	int_location = self clientfield::get("trap_chain_location");
	str_areaname = a_str_areaname[int_location];
	a_mdl_chain_active = GetEntArray(localClientNum, "fxanim_chain_trap", "targetname");
	a_mdl_chain_active = Array::filter(a_mdl_chain_active, 0, &filter_areaname, str_areaname);
	if(a_mdl_chain_active.size > 0)
	{
		Array::thread_all(a_mdl_chain_active, &update_active_chain_anims, localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName);
	}
}

/*
	Name: location_func
	Namespace: namespace_d8d03071
	Checksum: 0x87806552
	Offset: 0x790
	Size: 0x3B
	Parameters: 7
	Flags: None
*/
function location_func(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
}

/*
	Name: filter_areaname
	Namespace: namespace_d8d03071
	Checksum: 0x131B17F7
	Offset: 0x7D8
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function filter_areaname(e_entity, str_areaname)
{
	if(e_entity.script_noteworthy !== str_areaname)
	{
		return 0;
	}
	return 1;
}

/*
	Name: update_active_chain_anims
	Namespace: namespace_d8d03071
	Checksum: 0x632CE833
	Offset: 0x818
	Size: 0x18D
	Parameters: 7
	Flags: None
*/
function update_active_chain_anims(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self notify("update_active_chain_anims");
	self endon("update_active_chain_anims");
	mdl_chains_active = self;
	mdl_chains_active util::waittill_dobj(localClientNum);
	switch(newVal)
	{
		case 0:
		{
			self thread scene_play("p7_fxanim_zm_zod_chain_trap_symbol_off_bundle", self);
			break;
		}
		case 1:
		{
			mdl_chains_active show();
			scene::stop("p7_fxanim_zm_zod_chain_trap_symbol_off_bundle");
			self thread scene_play("p7_fxanim_zm_zod_chain_trap_symbol_on_bundle", self);
			break;
		}
		case 2:
		{
			self scene::stop();
			mdl_chains_active thread function_a89bd6f9();
			break;
		}
		case 3:
		{
			while(isdefined(self.trap_active))
			{
				wait(0.01);
			}
			self thread scene_play("p7_fxanim_zm_zod_chain_trap_symbol_off_bundle", self);
			break;
		}
	}
}

/*
	Name: scene_play
	Namespace: namespace_d8d03071
	Checksum: 0xD7013C9D
	Offset: 0x9B0
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function scene_play(scene, mdl_pod)
{
	self notify("scene_play");
	self endon("scene_play");
	self scene::stop();
	self function_6221b6b9(scene, mdl_pod);
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
function function_6221b6b9(scene, mdl_pod)
{
	level endon("demo_jump");
	self scene::Play(scene, mdl_pod);
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
	self.trap_active = 1;
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
	self.trap_active = undefined;
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

