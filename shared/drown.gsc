#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace drown;

/*
	Name: __init__sytem__
	Namespace: drown
	Checksum: 0xB0721313
	Offset: 0x1E0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("drown", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: drown
	Checksum: 0x90F85851
	Offset: 0x220
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_spawned(&on_player_spawned);
	level.DROWN_DAMAGE = GetDvarFloat("player_swimDamage");
	level.drown_damage_interval = GetDvarFloat("player_swimDamagerInterval") * 1000;
	level.drown_damage_after_time = GetDvarFloat("player_swimTime") * 1000;
	level.drown_pre_damage_stage_time = 2000;
	if(!isdefined(level.vsmgr_prio_overlay_drown_blur))
	{
		level.vsmgr_prio_overlay_drown_blur = 10;
	}
	visionset_mgr::register_info("overlay", "drown_blur", 1, level.vsmgr_prio_overlay_drown_blur, 1, 1, &visionset_mgr::ramp_in_out_thread_per_player, 1);
	clientfield::register("toplayer", "drown_stage", 1, 3, "int");
}

/*
	Name: activate_player_health_visionset
	Namespace: drown
	Checksum: 0x6EC5F7A5
	Offset: 0x358
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function activate_player_health_visionset()
{
	self deactivate_player_health_visionset();
	if(!self.drown_vision_set)
	{
		visionset_mgr::activate("overlay", "drown_blur", self, 0.1, 0.25, 0.1);
		self.drown_vision_set = 1;
	}
}

/*
	Name: deactivate_player_health_visionset
	Namespace: drown
	Checksum: 0x988638A
	Offset: 0x3C8
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function deactivate_player_health_visionset()
{
	if(!isdefined(self.drown_vision_set) || self.drown_vision_set)
	{
		visionset_mgr::deactivate("overlay", "drown_blur", self);
		self.drown_vision_set = 0;
	}
}

/*
	Name: on_player_spawned
	Namespace: drown
	Checksum: 0xE64699D5
	Offset: 0x420
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self thread watch_player_drowning();
	self thread watch_player_drown_death();
	self thread watch_game_ended();
	self deactivate_player_health_visionset();
}

/*
	Name: watch_player_drowning
	Namespace: drown
	Checksum: 0x5E216765
	Offset: 0x490
	Size: 0x277
	Parameters: 0
	Flags: None
*/
function watch_player_drowning()
{
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");
	self.lastWaterDamageTime = self getlastoutwatertime();
	self.drownStage = 0;
	self clientfield::set_to_player("drown_stage", 0);
	if(!isdefined(self.drown_damage_after_time))
	{
		self.drown_damage_after_time = level.drown_damage_after_time;
	}
	if(isdefined(self.var_d1d70226) && self.var_d1d70226)
	{
		return;
	}
	while(1)
	{
		if(self IsPlayerUnderwater() && self IsPlayerSwimming())
		{
			if(GetTime() - self.lastWaterDamageTime > self.drown_damage_after_time - level.drown_pre_damage_stage_time && self.drownStage == 0)
			{
				self.drownStage++;
				self clientfield::set_to_player("drown_stage", self.drownStage);
			}
			if(GetTime() - self.lastWaterDamageTime > self.drown_damage_after_time)
			{
				self.lastWaterDamageTime = self.lastWaterDamageTime + level.drown_damage_interval;
				drownFlags = 6;
				self DoDamage(level.DROWN_DAMAGE, self.origin, undefined, undefined, undefined, "MOD_DROWN", drownFlags);
				self activate_player_health_visionset();
				if(self.drownStage < 4)
				{
					self.drownStage++;
					self clientfield::set_to_player("drown_stage", self.drownStage);
				}
			}
		}
		else
		{
			self.drownStage = 0;
			self clientfield::set_to_player("drown_stage", 0);
			self.lastWaterDamageTime = self getlastoutwatertime();
			self deactivate_player_health_visionset();
		}
		wait(0.05);
	}
}

/*
	Name: watch_player_drown_death
	Namespace: drown
	Checksum: 0xAB8EF219
	Offset: 0x710
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function watch_player_drown_death()
{
	self endon("disconnect");
	self endon("game_ended");
	self waittill("death");
	self.drownStage = 0;
	self clientfield::set_to_player("drown_stage", 0);
	self deactivate_player_health_visionset();
}

/*
	Name: watch_game_ended
	Namespace: drown
	Checksum: 0x29F3389
	Offset: 0x788
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function watch_game_ended()
{
	self endon("disconnect");
	self endon("death");
	level waittill("game_ended");
	self.drownStage = 0;
	self clientfield::set_to_player("drown_stage", 0);
	self deactivate_player_health_visionset();
}

/*
	Name: is_player_drowning
	Namespace: drown
	Checksum: 0xAD6FE649
	Offset: 0x800
	Size: 0x41
	Parameters: 0
	Flags: None
*/
function is_player_drowning()
{
	drowning = 1;
	if(!isdefined(self.drownStage) || self.drownStage == 0)
	{
		drowning = 0;
	}
	return drowning;
}

