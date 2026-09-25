#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;

#namespace zombie;

/*
	Name: Precache
	Namespace: zombie
	Checksum: 0x99EC1590
	Offset: 0x3C0
	Size: 0x3
	Parameters: 0
	Flags: AutoExec
*/
function autoexec Precache()
{
}

/*
	Name: main
	Namespace: zombie
	Checksum: 0x2FC1BADC
	Offset: 0x3D0
	Size: 0xD3
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	level._effect["zombie_special_day_effect"] = "zombie/fx_val_chest_burst";
	ai::add_archetype_spawn_function("zombie", &ZombieClientUtils::zombie_override_burn_fx);
	clientfield::register("actor", "zombie", 1, 1, "int", &ZombieClientUtils::zombieHandler, 0, 0);
	clientfield::register("actor", "zombie_special_day", 6001, 1, "counter", &ZombieClientUtils::zombieSpecialDayEffectsHandler, 0, 0);
}

#namespace ZombieClientUtils;

/*
	Name: zombieHandler
	Namespace: ZombieClientUtils
	Checksum: 0x2000701F
	Offset: 0x4B0
	Size: 0x183
	Parameters: 7
	Flags: None
*/
function zombieHandler(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	if(isdefined(entity.archetype) && entity.archetype != "zombie")
	{
		return;
	}
	if(!isdefined(entity.initializedGibCallbacks) || !entity.initializedGibCallbacks)
	{
		entity.initializedGibCallbacks = 1;
		GibClientUtils::AddGibCallback(localClientNum, entity, 8, &_gibCallback);
		GibClientUtils::AddGibCallback(localClientNum, entity, 16, &_gibCallback);
		GibClientUtils::AddGibCallback(localClientNum, entity, 32, &_gibCallback);
		GibClientUtils::AddGibCallback(localClientNum, entity, 128, &_gibCallback);
		GibClientUtils::AddGibCallback(localClientNum, entity, 256, &_gibCallback);
	}
}

/*
	Name: _gibCallback
	Namespace: ZombieClientUtils
	Checksum: 0x1D4B1DA8
	Offset: 0x640
	Size: 0xC5
	Parameters: 3
	Flags: Private
*/
function private _gibCallback(localClientNum, entity, gibFlag)
{
	switch(gibFlag)
	{
		case 8:
		{
			playsound(0, "zmb_zombie_head_gib", self.origin + VectorScale((0, 0, 1), 60));
			break;
		}
		case 16:
		case 32:
		case 128:
		case 256:
		{
			playsound(0, "zmb_death_gibs", self.origin + VectorScale((0, 0, 1), 30));
			break;
		}
	}
}

/*
	Name: zombieSpecialDayEffectsHandler
	Namespace: ZombieClientUtils
	Checksum: 0x3E5013C9
	Offset: 0x710
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function zombieSpecialDayEffectsHandler(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	if(isdefined(entity.archetype) && entity.archetype != "zombie")
	{
		return;
	}
	origin = entity GetTagOrigin("j_spine4");
	FX = playFX(localClientNum, level._effect["zombie_special_day_effect"], origin);
	SetFXIgnorePause(localClientNum, FX, 1);
}

/*
	Name: zombie_override_burn_fx
	Namespace: ZombieClientUtils
	Checksum: 0x2DD457DF
	Offset: 0x818
	Size: 0x14D
	Parameters: 1
	Flags: None
*/
function zombie_override_burn_fx(localClientNum)
{
	if(SessionModeIsZombiesGame())
	{
		if(!isdefined(self._effect))
		{
			self._effect = [];
		}
		level._effect["fire_zombie_j_elbow_le_loop"] = "fire/fx_fire_ai_human_arm_left_loop_optim";
		level._effect["fire_zombie_j_elbow_ri_loop"] = "fire/fx_fire_ai_human_arm_right_loop_optim";
		level._effect["fire_zombie_j_shoulder_le_loop"] = "fire/fx_fire_ai_human_arm_left_loop_optim";
		level._effect["fire_zombie_j_shoulder_ri_loop"] = "fire/fx_fire_ai_human_arm_right_loop_optim";
		level._effect["fire_zombie_j_spine4_loop"] = "fire/fx_fire_ai_human_torso_loop_optim";
		level._effect["fire_zombie_j_hip_le_loop"] = "fire/fx_fire_ai_human_hip_left_loop_optim";
		level._effect["fire_zombie_j_hip_ri_loop"] = "fire/fx_fire_ai_human_hip_right_loop_optim";
		level._effect["fire_zombie_j_knee_le_loop"] = "fire/fx_fire_ai_human_leg_left_loop_optim";
		level._effect["fire_zombie_j_knee_ri_loop"] = "fire/fx_fire_ai_human_leg_right_loop_optim";
		level._effect["fire_zombie_j_head_loop"] = "fire/fx_fire_ai_human_head_loop_optim";
	}
}

