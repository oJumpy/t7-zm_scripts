#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace drown;

/*
	Name: __init__sytem__
	Namespace: drown
	Checksum: 0xA963C19B
	Offset: 0x220
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
	Checksum: 0x840F6871
	Offset: 0x260
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "drown_stage", 1, 3, "int", &drown_stage_callback, 0, 0);
	callback::on_localplayer_spawned(&player_spawned);
	level.playerMaxHealth = GetGametypeSetting("playerMaxHealth");
	level.player_swim_damage_interval = GetDvarFloat("player_swimDamagerInterval", 5000) * 1000;
	level.player_swim_damage = GetDvarFloat("player_swimDamage", 5000);
	level.player_swim_time = GetDvarFloat("player_swimTime", 5000) * 1000;
	level.player_swim_death_time = level.playerMaxHealth / level.player_swim_damage * level.player_swim_damage_interval + 2000;
	visionset_mgr::register_overlay_info_style_speed_blur("drown_blur", 1, 1, 0.04, 1, 1, 0, 0, 125, 125, 0);
	setup_radius_values();
}

/*
	Name: setup_radius_values
	Namespace: drown
	Checksum: 0x78E0D25
	Offset: 0x3E8
	Size: 0x3BF
	Parameters: 0
	Flags: None
*/
function setup_radius_values()
{
	level.drown_radius["inner"]["begin"][1] = 0.8;
	level.drown_radius["inner"]["begin"][2] = 0.6;
	level.drown_radius["inner"]["begin"][3] = 0.6;
	level.drown_radius["inner"]["begin"][4] = 0.5;
	level.drown_radius["inner"]["end"][1] = 0.5;
	level.drown_radius["inner"]["end"][2] = 0.3;
	level.drown_radius["inner"]["end"][3] = 0.3;
	level.drown_radius["inner"]["end"][4] = 0.2;
	level.drown_radius["outer"]["begin"][1] = 1;
	level.drown_radius["outer"]["begin"][2] = 0.8;
	level.drown_radius["outer"]["begin"][3] = 0.8;
	level.drown_radius["outer"]["begin"][4] = 0.7;
	level.drown_radius["outer"]["end"][1] = 0.8;
	level.drown_radius["outer"]["end"][2] = 0.6;
	level.drown_radius["outer"]["end"][3] = 0.6;
	level.drown_radius["outer"]["end"][4] = 0.5;
	level.opacity["begin"][1] = 0.4;
	level.opacity["begin"][2] = 0.5;
	level.opacity["begin"][3] = 0.6;
	level.opacity["begin"][4] = 0.6;
	level.opacity["end"][1] = 0.5;
	level.opacity["end"][2] = 0.6;
	level.opacity["end"][3] = 0.7;
	level.opacity["end"][4] = 0.7;
}

/*
	Name: player_spawned
	Namespace: drown
	Checksum: 0x526A1F7F
	Offset: 0x7B0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function player_spawned(localClientNum)
{
	if(self != GetLocalPlayer(localClientNum))
	{
		return;
	}
	self player_init_drown_values();
	self thread player_watch_drown_shutdown(localClientNum);
}

/*
	Name: player_init_drown_values
	Namespace: drown
	Checksum: 0x39402047
	Offset: 0x810
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function player_init_drown_values()
{
	if(!isdefined(self.drown_start_time))
	{
		self.drown_start_time = 0;
		self.drown_outerRadius = 0;
		self.drown_innerRadius = 0;
		self.drown_opacity = 0;
	}
}

/*
	Name: player_watch_drown_shutdown
	Namespace: drown
	Checksum: 0x87BE34C2
	Offset: 0x858
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function player_watch_drown_shutdown(localClientNum)
{
	self util::waittill_any("entityshutdown", "death");
	self disable_drown(localClientNum);
}

/*
	Name: enable_drown
	Namespace: drown
	Checksum: 0xD41A63C
	Offset: 0x8B0
	Size: 0x9B
	Parameters: 2
	Flags: None
*/
function enable_drown(localClientNum, stage)
{
	filter::init_filter_drowning_damage(localClientNum);
	filter::enable_filter_drowning_damage(localClientNum, 1);
	self.drown_start_time = getServerTime(localClientNum) - stage - 1 * level.player_swim_damage_interval;
	self.drown_outerRadius = 0;
	self.drown_innerRadius = 0;
	self.drown_opacity = 0;
}

/*
	Name: disable_drown
	Namespace: drown
	Checksum: 0x577FE723
	Offset: 0x958
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function disable_drown(localClientNum)
{
	filter::disable_filter_drowning_damage(localClientNum, 1);
}

/*
	Name: player_drown_fx
	Namespace: drown
	Checksum: 0xF743E8F6
	Offset: 0x988
	Size: 0x2C7
	Parameters: 2
	Flags: None
*/
function player_drown_fx(localClientNum, stage)
{
	self endon("death");
	self endon("entityshutdown");
	self endon("player_fade_out_drown_fx");
	self notify("player_drown_fx");
	self endon("player_drown_fx");
	self player_init_drown_values();
	lastOutWaterTimeStage = self.drown_start_time + stage - 1 * level.player_swim_damage_interval;
	stageDuration = level.player_swim_damage_interval;
	if(stage == 1)
	{
		stageDuration = 2000;
	}
	while(1)
	{
		currentTime = getServerTime(localClientNum);
		elapsedTime = currentTime - self.drown_start_time;
		stageRatio = math::clamp(currentTime - lastOutWaterTimeStage / stageDuration, 0, 1);
		self.drown_outerRadius = LerpFloat(level.drown_radius["outer"]["begin"][stage], level.drown_radius["outer"]["end"][stage], stageRatio) * 1.41421;
		self.drown_innerRadius = LerpFloat(level.drown_radius["inner"]["begin"][stage], level.drown_radius["inner"]["end"][stage], stageRatio) * 1.41421;
		self.drown_opacity = LerpFloat(level.opacity["begin"][stage], level.opacity["end"][stage], stageRatio);
		filter::set_filter_drowning_damage_inner_radius(localClientNum, 1, self.drown_innerRadius);
		filter::set_filter_drowning_damage_outer_radius(localClientNum, 1, self.drown_outerRadius);
		filter::set_filter_drowning_damage_opacity(localClientNum, 1, self.drown_opacity);
		wait(0.016);
	}
}

/*
	Name: player_fade_out_drown_fx
	Namespace: drown
	Checksum: 0xEBA819F9
	Offset: 0xC58
	Size: 0x1F3
	Parameters: 1
	Flags: None
*/
function player_fade_out_drown_fx(localClientNum)
{
	self endon("death");
	self endon("entityshutdown");
	self endon("player_drown_fx");
	self notify("player_fade_out_drown_fx");
	self endon("player_fade_out_drown_fx");
	self player_init_drown_values();
	fadeStartTime = getServerTime(localClientNum);
	for(currentTime = getServerTime(localClientNum); currentTime - fadeStartTime < 250;  = getServerTime(localClientNum))
	{
		Ratio = currentTime - fadeStartTime / 250;
		outerRadius = LerpFloat(self.drown_outerRadius, 1.41421, Ratio);
		innerRadius = LerpFloat(self.drown_innerRadius, 1.41421, Ratio);
		opacity = LerpFloat(self.drown_opacity, 0, Ratio);
		filter::set_filter_drowning_damage_outer_radius(localClientNum, 1, outerRadius);
		filter::set_filter_drowning_damage_inner_radius(localClientNum, 1, innerRadius);
		filter::set_filter_drowning_damage_opacity(localClientNum, 1, opacity);
		wait(0.016);
	}
	self disable_drown(localClientNum);
}

/*
	Name: drown_stage_callback
	Namespace: drown
	Checksum: 0x51B7E3D
	Offset: 0xE58
	Size: 0xCB
	Parameters: 7
	Flags: None
*/
function drown_stage_callback(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal > 0)
	{
		self enable_drown(localClientNum, newVal);
		self thread player_drown_fx(localClientNum, newVal);
	}
	else if(!bNewEnt)
	{
		self thread player_fade_out_drown_fx(localClientNum);
	}
	else
	{
		self disable_drown(localClientNum);
	}
}

