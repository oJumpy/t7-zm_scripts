#using scripts\codescripts\struct;
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
#using scripts\zm\zm_zod_quest;

#namespace zm_zod_pods;

/*
	Name: __init__sytem__
	Namespace: zm_zod_pods
	Checksum: 0x2B3FB5EC
	Offset: 0x5F0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_pods", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_pods
	Checksum: 0xEB501313
	Offset: 0x630
	Size: 0x2D3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "ZM_ZOD_UI_POD_SPRAYER_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("scriptmover", "update_fungus_pod_level", 1, 3, "int", &update_fungus_pod_level, 0, 0);
	clientfield::register("scriptmover", "pod_sprayer_glint", 1, 1, "int", &pod_sprayer_glint, 0, 0);
	clientfield::register("scriptmover", "pod_miasma", 1, 1, "counter", &update_pod_miasma, 0, 0);
	clientfield::register("scriptmover", "pod_harvest", 1, 1, "counter", &play_harvested_fx, 0, 0);
	clientfield::register("scriptmover", "pod_self_destruct", 1, 1, "counter", &pod_self_destruct, 0, 0);
	clientfield::register("toplayer", "pod_sprayer_held", 1, 1, "int", &zm_utility::setInventoryUIModels, 0, 1);
	clientfield::register("toplayer", "pod_sprayer_hint_range", 1, 1, "int", &zm_utility::setInventoryUIModels, 0, 0);
	scene::init("p7_fxanim_zm_zod_fungus_pod_stage1_bundle");
	scene::init("p7_fxanim_zm_zod_fungus_pod_stage1_death_bundle");
	scene::init("p7_fxanim_zm_zod_fungus_pod_stage2_bundle");
	scene::init("p7_fxanim_zm_zod_fungus_pod_stage2_death_bundle");
	scene::init("p7_fxanim_zm_zod_fungus_pod_stage3_bundle");
	scene::init("p7_fxanim_zm_zod_fungus_pod_stage3_death_bundle");
}

/*
	Name: update_fungus_pod_level
	Namespace: zm_zod_pods
	Checksum: 0xB537FEC5
	Offset: 0x910
	Size: 0x381
	Parameters: 7
	Flags: None
*/
function update_fungus_pod_level(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.ambient_fx))
	{
		stopfx(localClientNum, self.ambient_fx);
		self StopAllLoopSounds();
	}
	if(!isdefined(level.mdl_pods))
	{
		level.mdl_pods = [];
	}
	if(!isdefined(level.mdl_pods[localClientNum]))
	{
		level.mdl_pods[localClientNum] = [];
	}
	if(!isdefined(level.mdl_pods[localClientNum][self GetEntityNumber()]))
	{
		level.mdl_pods[localClientNum][self GetEntityNumber()] = util::spawn_model(localClientNum, "p7_fxanim_zm_zod_fungus_pod_base_mod", self.origin, self.angles);
	}
	mdl_pod = level.mdl_pods[localClientNum][self GetEntityNumber()];
	if(IsDemoPlaying() && getnumfreeentities(localClientNum) < 100)
	{
		numfree = getnumfreeentities(localClientNum);
		if(!isdefined(self.n_pod_level))
		{
			self.n_pod_level = 1;
		}
		return;
	}
	if(!isdefined(self.n_pod_level))
	{
		self.n_pod_level = 1;
	}
	switch(newVal)
	{
		case 0:
		case 4:
		{
			self thread scene_play("p7_fxanim_zm_zod_fungus_pod_stage" + self.n_pod_level + "_death_bundle", mdl_pod);
			self.n_pod_level = 0;
			break;
		}
		case 1:
		{
			self thread scene_play("p7_fxanim_zm_zod_fungus_pod_stage1_bundle", mdl_pod);
			self.ambient_fx = playFX(localClientNum, "zombie/fx_fungus_pod_ambient_sm_zod_zmb", self.origin);
			self.n_pod_level = newVal;
			break;
		}
		case 2:
		{
			self thread scene_play("p7_fxanim_zm_zod_fungus_pod_stage2_bundle", mdl_pod);
			self.ambient_fx = playFX(localClientNum, "zombie/fx_fungus_pod_ambient_md_zod_zmb", self.origin);
			self.n_pod_level = newVal;
			break;
		}
		case 3:
		{
			self thread scene_play("p7_fxanim_zm_zod_fungus_pod_stage3_bundle", mdl_pod);
			self.ambient_fx = playFX(localClientNum, "zombie/fx_fungus_pod_ambient_lg_zod_zmb", self.origin);
			self.n_pod_level = newVal;
			break;
		}
	}
}

/*
	Name: scene_play
	Namespace: zm_zod_pods
	Checksum: 0x9C398AC2
	Offset: 0xCA0
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
	Namespace: zm_zod_pods
	Checksum: 0x601D8249
	Offset: 0xD28
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
	Name: play_harvested_fx
	Namespace: zm_zod_pods
	Checksum: 0x4C45E64C
	Offset: 0xD70
	Size: 0x1B3
	Parameters: 7
	Flags: None
*/
function play_harvested_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal === 0)
	{
		return;
	}
	v_origin = self.origin;
	v_angles = AnglesToForward(self.angles);
	n_pod_level = self.n_pod_level;
	if(isdefined(self.ambient_fx))
	{
		stopfx(localClientNum, self.ambient_fx);
	}
	switch(n_pod_level)
	{
		case 1:
		{
			var_9a5eae23 = "zombie/fx_fungus_pod_explo_sm_zod_zmb";
			var_ae4d7909 = "zombie/fx_fungus_pod_linger_sm_zod_zmb";
			break;
		}
		case 2:
		{
			var_9a5eae23 = "zombie/fx_fungus_pod_explo_md_zod_zmb";
			var_ae4d7909 = "zombie/fx_fungus_pod_linger_md_zod_zmb";
			break;
		}
		case 3:
		{
			var_9a5eae23 = "zombie/fx_fungus_pod_explo_lg_zod_zmb";
			var_ae4d7909 = "zombie/fx_fungus_pod_linger_lg_zod_zmb";
			break;
		}
	}
	level thread function_b77a78c9(localClientNum, "zombie/fx_sprayer_mist_zod_zmb", v_origin, 2, v_angles);
	wait(0.3);
	level thread function_b77a78c9(localClientNum, var_ae4d7909, v_origin, 8, v_angles);
}

/*
	Name: function_b77a78c9
	Namespace: zm_zod_pods
	Checksum: 0xEC6C8210
	Offset: 0xF30
	Size: 0xB3
	Parameters: 5
	Flags: None
*/
function function_b77a78c9(localClientNum, str_fx, v_origin, n_duration, v_angles)
{
	if(isdefined(v_angles))
	{
		FX = playFX(localClientNum, str_fx, v_origin, v_angles);
	}
	else
	{
		FX = playFX(localClientNum, str_fx, v_origin);
	}
	wait(n_duration);
	stopfx(localClientNum, FX);
}

/*
	Name: update_pod_miasma
	Namespace: zm_zod_pods
	Checksum: 0xD6C42EB8
	Offset: 0xFF0
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function update_pod_miasma(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level thread function_b77a78c9(localClientNum, "zombie/fx_fungus_pod_miasma_zod_zmb", self.origin, 5);
	}
}

/*
	Name: pod_self_destruct
	Namespace: zm_zod_pods
	Checksum: 0x4B3B710A
	Offset: 0x1070
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function pod_self_destruct(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level thread function_b77a78c9(localClientNum, "zombie/fx_fungus_pod_explo_maxevo_zod_zmb", self.origin, 5, VectorScale((0, 1, 0), 90));
	}
}

/*
	Name: pod_sprayer_glint
	Namespace: zm_zod_pods
	Checksum: 0xE245609F
	Offset: 0x10F8
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function pod_sprayer_glint(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.pod_sprayer_glint_fx))
	{
		stopfx(localClientNum, self.pod_sprayer_glint_fx);
	}
	if(newVal)
	{
		self.pod_sprayer_glint_fx = PlayFXOnTag(localClientNum, "zombie/fx_sprayer_glint_zod_zmb", self, "tag_origin");
	}
}

