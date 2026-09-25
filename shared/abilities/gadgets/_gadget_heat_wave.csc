#using scripts\codescripts\struct;
#using scripts\shared\_burnplayer;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_heat_wave;

/*
	Name: __init__sytem__
	Namespace: _gadget_heat_wave
	Checksum: 0x9867C537
	Offset: 0x390
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_heat_wave", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_heat_wave
	Checksum: 0x16276CBA
	Offset: 0x3D0
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "heatwave_fx", 1, 1, "int", &set_heatwave_fx, 0, 0);
	clientfield::register("allplayers", "heatwave_victim", 1, 1, "int", &update_victim, 0, 0);
	clientfield::register("toplayer", "heatwave_activate", 1, 1, "int", &update_activate, 0, 0);
	level.debug_heat_wave_traces = GetDvarInt("scr_debug_heat_wave_traces", 0);
	visionset_mgr::register_visionset_info("heatwave", 1, 16, undefined, "heatwave");
	visionset_mgr::register_visionset_info("charred", 1, 16, undefined, "charred");
	/#
		level thread updateDvars();
	#/
}

/*
	Name: updateDvars
	Namespace: _gadget_heat_wave
	Checksum: 0x58568507
	Offset: 0x540
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function updateDvars()
{
	/#
		while(1)
		{
			level.debug_heat_wave_traces = GetDvarInt("Dev Block strings are not supported", level.debug_heat_wave_traces);
			wait(1);
		}
	#/
}

/*
	Name: update_activate
	Namespace: _gadget_heat_wave
	Checksum: 0x96781E0C
	Offset: 0x590
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function update_activate(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self thread postfx::playPostfxBundle("pstfx_heat_pulse");
	}
}

/*
	Name: update_victim
	Namespace: _gadget_heat_wave
	Checksum: 0x1E653ECA
	Offset: 0x600
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function update_victim(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self endon("entityshutdown");
		self util::waittill_dobj(localClientNum);
		self PlayRumbleOnEntity(localClientNum, "heat_wave_damage");
		PlayTagFXSet(localClientNum, "ability_hero_heat_wave_player_impact", self);
	}
}

/*
	Name: set_heatwave_fx
	Namespace: _gadget_heat_wave
	Checksum: 0xBA2BE5E3
	Offset: 0x6B0
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function set_heatwave_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self clear_heat_wave_fx(localClientNum);
	if(newVal)
	{
		self.heatWaveFx = [];
		self thread aoe_fx(localClientNum);
	}
}

/*
	Name: clear_heat_wave_fx
	Namespace: _gadget_heat_wave
	Checksum: 0x5AA95CC7
	Offset: 0x740
	Size: 0xA9
	Parameters: 1
	Flags: None
*/
function clear_heat_wave_fx(localClientNum)
{
	if(!isdefined(self.heatWaveFx))
	{
		return;
	}
	foreach(FX in self.heatWaveFx)
	{
		stopfx(localClientNum, FX);
	}
}

/*
	Name: aoe_fx
	Namespace: _gadget_heat_wave
	Checksum: 0x2DCC08A7
	Offset: 0x7F8
	Size: 0x355
	Parameters: 1
	Flags: None
*/
function aoe_fx(localClientNum)
{
	self endon("entityshutdown");
	center = self.origin + VectorScale((0, 0, 1), 30);
	startPitch = -90;
	yaw_count = [];
	yaw_count[0] = 1;
	yaw_count[1] = 4;
	yaw_count[2] = 6;
	yaw_count[3] = 8;
	yaw_count[4] = 6;
	yaw_count[5] = 4;
	yaw_count[6] = 1;
	pitch_vals = [];
	pitch_vals[0] = 90;
	pitch_vals[3] = 0;
	pitch_vals[6] = -90;
	trace = bullettrace(center, center + (0, 0, -1) * 400, 0, self);
	if(trace["fraction"] < 1)
	{
		pitch_vals[1] = 90 - ATan(150 / trace["fraction"] * 400);
		pitch_vals[2] = 90 - ATan(300 / trace["fraction"] * 400);
	}
	else
	{
		pitch_vals[1] = 60;
		pitch_vals[2] = 30;
	}
	trace = bullettrace(center, center + (0, 0, 1) * 400, 0, self);
	if(trace["fraction"] < 1)
	{
		pitch_vals[5] = -90 + ATan(150 / trace["fraction"] * 400);
		pitch_vals[4] = -90 + ATan(300 / trace["fraction"] * 400);
	}
	else
	{
		pitch_vals[5] = -60;
		pitch_vals[4] = -30;
	}
	currentPitch = startPitch;
	for(yaw_level = 0; yaw_level < yaw_count.size; yaw_level++)
	{
		currentPitch = pitch_vals[yaw_level];
		do_fx(localClientNum, center, yaw_count[yaw_level], currentPitch);
	}
}

/*
	Name: do_fx
	Namespace: _gadget_heat_wave
	Checksum: 0x2E0B8F5A
	Offset: 0xB58
	Size: 0x4C5
	Parameters: 4
	Flags: None
*/
function do_fx(localClientNum, center, yaw_count, pitch)
{
	currentYaw = RandomInt(360);
	for(fxCount = 0; fxCount < yaw_count; fxCount++)
	{
		randomOffsetPitch = RandomInt(5) - 2.5;
		randomOffsetYaw = RandomInt(30) - 15;
		angles = (pitch + randomOffsetPitch, currentYaw + randomOffsetYaw, 0);
		traceDir = AnglesToForward(angles);
		currentYaw = currentYaw + 360 / yaw_count;
		fx_position = center + traceDir * 400;
		trace = bullettrace(center, fx_position, 0, self);
		sphere_size = 5;
		angles = (0, RandomInt(360), 0);
		FORWARD = AnglesToForward(angles);
		if(trace["fraction"] < 1)
		{
			fx_position = center + traceDir * 400 * trace["fraction"];
			/#
				if(level.debug_heat_wave_traces)
				{
					sphere(fx_position, sphere_size, (1, 0, 1), 1, 1, 8, 300);
					sphere(trace["Dev Block strings are not supported"], sphere_size, (1, 1, 0), 1, 1, 8, 300);
				}
			#/
			normal = trace["normal"];
			if(LengthSquared(normal) == 0)
			{
				normal = -1 * traceDir;
			}
			right = (normal[2] * -1, normal[1] * -1, normal[0]);
			if(LengthSquared(VectorCross(FORWARD, normal)) == 0)
			{
				FORWARD = VectorCross(right, FORWARD);
			}
			self.heatWaveFx[self.heatWaveFx.size] = playFX(localClientNum, "player/fx_plyr_heat_wave_distortion_volume", trace["position"], normal, FORWARD);
		}
		else
		{
			if(level.debug_heat_wave_traces)
			{
				line(fx_position + VectorScale((0, 0, 1), 50), fx_position - VectorScale((0, 0, 1), 50), (1, 0, 0), 1, 0, 300);
				sphere(fx_position, sphere_size, (1, 0, 1), 1, 1, 8, 300);
			}
			if(LengthSquared(VectorCross(FORWARD, traceDir * -1)) == 0)
			{
				FORWARD = VectorCross(right, FORWARD);
			}
			self.heatWaveFx[self.heatWaveFx.size] = playFX(localClientNum, "player/fx_plyr_heat_wave_distortion_volume_air", fx_position, traceDir * -1, FORWARD);
		}
		/#
		#/
		if(fxCount % 2)
		{
			wait(0.016);
		}
	}
}

