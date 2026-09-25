#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace blood;

/*
	Name: __init__sytem__
	Namespace: blood
	Checksum: 0x78316BA3
	Offset: 0x1B8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("blood", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: blood
	Checksum: 0xA02BB25C
	Offset: 0x1F8
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.bloodStage3 = GetDvarFloat("cg_t7HealthOverlay_Threshold3", 0.5);
	level.bloodStage2 = GetDvarFloat("cg_t7HealthOverlay_Threshold2", 0.8);
	level.bloodStage1 = GetDvarFloat("cg_t7HealthOverlay_Threshold1", 0.99);
	level.use_digital_blood_enabled = GetDvarFloat("scr_use_digital_blood_enabled", 1);
	callback::on_localplayer_spawned(&localplayer_spawned);
}

/*
	Name: localplayer_spawned
	Namespace: blood
	Checksum: 0x8B034714
	Offset: 0x2C8
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function localplayer_spawned(localClientNum)
{
	if(self != GetLocalPlayer(localClientNum))
	{
		return;
	}
	/#
		level.use_digital_blood_enabled = GetDvarFloat("Dev Block strings are not supported", level.use_digital_blood_enabled);
	#/
	self.use_digital_blood = 0;
	bodyType = self GetCharacterBodyType();
	if(level.use_digital_blood_enabled && bodyType >= 0)
	{
		bodyTypeFields = GetCharacterFields(bodyType, CurrentSessionMode());
		if(isdefined(bodyTypeFields.digitalBlood))
		{
		}
		else
		{
		}
		self.use_digital_blood = 0;
	}
	self thread player_watch_blood(localClientNum);
	self thread player_watch_blood_shutdown(localClientNum);
}

/*
	Name: player_watch_blood_shutdown
	Namespace: blood
	Checksum: 0x134C5B6B
	Offset: 0x400
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function player_watch_blood_shutdown(localClientNum)
{
	self util::waittill_any("entityshutdown", "death");
	self disable_blood(localClientNum);
}

/*
	Name: enable_blood
	Namespace: blood
	Checksum: 0x70D371A3
	Offset: 0x458
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function enable_blood(localClientNum)
{
	self.blood_enabled = 1;
	filter::init_filter_feedback_blood(localClientNum, self.use_digital_blood);
	filter::enable_filter_feedback_blood(localClientNum, 2, 2, self.use_digital_blood);
	filter::set_filter_feedback_blood_sundir(localClientNum, 2, 2, 65, 32);
	filter::init_filter_sprite_blood_heavy(localClientNum, self.use_digital_blood);
	filter::enable_filter_sprite_blood_heavy(localClientNum, 2, 1, self.use_digital_blood);
	filter::set_filter_sprite_blood_seed_offset(localClientNum, 2, 1, RandomFloat(1));
}

/*
	Name: disable_blood
	Namespace: blood
	Checksum: 0xD70EE0DA
	Offset: 0x560
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function disable_blood(localClientNum)
{
	if(isdefined(self))
	{
		self.blood_enabled = 0;
	}
	filter::disable_filter_feedback_blood(localClientNum, 2, 2);
	filter::disable_filter_sprite_blood(localClientNum, 2, 1);
	if(!(isdefined(self.noBloodLightBarChange) && self.noBloodLightBarChange))
	{
		SetControllerLightbarColor(localClientNum);
	}
}

/*
	Name: blood_in
	Namespace: blood
	Checksum: 0xA59D1B
	Offset: 0x5F8
	Size: 0x1DB
	Parameters: 2
	Flags: None
*/
function blood_in(localClientNum, playerHealth)
{
	if(playerHealth < level.bloodStage3)
	{
		self.stage3Amount = level.bloodStage3 - playerHealth / level.bloodStage3;
	}
	else
	{
		self.stage3Amount = 0;
	}
	if(playerHealth < level.bloodStage2)
	{
		self.stage2Amount = level.bloodStage2 - playerHealth / level.bloodStage2;
	}
	else
	{
		self.stage2Amount = 0;
	}
	filter::set_filter_feedback_blood_vignette(localClientNum, 2, 2, self.stage3Amount);
	filter::set_filter_feedback_blood_opacity(localClientNum, 2, 2, self.stage2Amount);
	if(playerHealth < level.bloodStage1)
	{
		minStage1Health = 0.55;
		/#
			Assert(level.bloodStage1 > minStage1Health);
		#/
		stageHealth = playerHealth - minStage1Health;
		if(stageHealth < 0)
		{
			stageHealth = 0;
		}
		self.stage1Amount = 1 - stageHealth / level.bloodStage1 - minStage1Health;
	}
	else
	{
		self.stage1Amount = 0;
	}
	filter::set_filter_sprite_blood_opacity(localClientNum, 2, 1, self.stage1Amount);
	filter::set_filter_sprite_blood_elapsed(localClientNum, 2, 1, getServerTime(localClientNum));
}

/*
	Name: blood_out
	Namespace: blood
	Checksum: 0x99281DA8
	Offset: 0x7E0
	Size: 0x1C3
	Parameters: 1
	Flags: None
*/
function blood_out(localClientNum)
{
	currentTime = getServerTime(localClientNum);
	elapsedTime = currentTime - self.lastBloodUpdate;
	self.lastBloodUpdate = currentTime;
	subtract = elapsedTime / 1000;
	if(self.stage3Amount > 0)
	{
		self.stage3Amount = self.stage3Amount - subtract;
	}
	if(self.stage3Amount < 0)
	{
		self.stage3Amount = 0;
	}
	if(self.stage2Amount > 0)
	{
		self.stage2Amount = self.stage2Amount - subtract;
	}
	if(self.stage2Amount < 0)
	{
		self.stage2Amount = 0;
	}
	filter::set_filter_feedback_blood_vignette(localClientNum, 2, 2, self.stage3Amount);
	filter::set_filter_feedback_blood_opacity(localClientNum, 2, 2, self.stage2Amount);
	if(self.stage1Amount > 0)
	{
		self.stage1Amount = self.stage1Amount - subtract;
	}
	if(self.stage1Amount < 0)
	{
		self.stage1Amount = 0;
	}
	filter::set_filter_sprite_blood_opacity(localClientNum, 2, 1, self.stage1Amount);
	filter::set_filter_sprite_blood_elapsed(localClientNum, 2, 1, getServerTime(localClientNum));
}

/*
	Name: player_watch_blood
	Namespace: blood
	Checksum: 0xEA9EC669
	Offset: 0x9B0
	Size: 0x3CF
	Parameters: 1
	Flags: None
*/
function player_watch_blood(localClientNum)
{
	self endon("disconnect");
	self endon("entityshutdown");
	self endon("death");
	self endon("killBloodOverlay");
	self.stage2Amount = 0;
	self.stage3Amount = 0;
	self.lastBloodUpdate = 0;
	priorPlayerHealth = renderhealthoverlayhealth(localClientNum);
	self blood_in(localClientNum, priorPlayerHealth);
	while(1)
	{
		if(renderHealthOverlay(localClientNum) && (!isdefined(self.noBloodOverlay) && self.noBloodOverlay))
		{
			shouldEnabledOverlay = 0;
			playerHealth = renderhealthoverlayhealth(localClientNum);
			if(playerHealth < priorPlayerHealth)
			{
				shouldEnabledOverlay = 1;
				self blood_in(localClientNum, playerHealth);
			}
			else if(playerHealth == priorPlayerHealth && playerHealth != 1)
			{
				shouldEnabledOverlay = 1;
				self.lastBloodUpdate = getServerTime(localClientNum);
			}
			else if(self.stage2Amount > 0 || self.stage3Amount > 0)
			{
				shouldEnabledOverlay = 1;
				self blood_out(localClientNum);
			}
			else if(isdefined(self.blood_enabled) && self.blood_enabled)
			{
				self disable_blood(localClientNum);
			}
			priorPlayerHealth = playerHealth;
			if(!isdefined(self.blood_enabled) && self.blood_enabled && shouldEnabledOverlay)
			{
				self enable_blood(localClientNum);
			}
			if(!(isdefined(self.noBloodLightBarChange) && self.noBloodLightBarChange))
			{
				if(self.stage3Amount > 0)
				{
					SetControllerLightBarColorPulsing(localClientNum, (1, 0, 0), 600);
				}
				else if(self.stage2Amount == 1)
				{
					SetControllerLightBarColorPulsing(localClientNum, VectorScale((1, 0, 0), 0.8), 1200);
				}
				else if(GetGadgetPower(localClientNum) == 1 && (!SessionModeIsCampaignGame() || CodeGetUIModelClientField(self, "playerAbilities.inRange")))
				{
					SetControllerLightBarColorPulsing(localClientNum, (1, 1, 0), 2000);
				}
				else if(isdefined(self.controllerColor))
				{
					SetControllerLightbarColor(localClientNum, self.controllerColor);
				}
				else
				{
					SetControllerLightbarColor(localClientNum);
				}
			}
		}
		else if(isdefined(self.blood_enabled) && self.blood_enabled)
		{
			self disable_blood(localClientNum);
		}
		wait(0.016);
	}
}

/*
	Name: SetControllerLightBarColorPulsing
	Namespace: blood
	Checksum: 0xC2EA4D1F
	Offset: 0xD88
	Size: 0xC3
	Parameters: 3
	Flags: None
*/
function SetControllerLightBarColorPulsing(localClientNum, color, pulseRate)
{
	curColor = color * 0.2;
	scale = GetTime() % pulseRate / pulseRate * 0.5;
	if(scale > 1)
	{
		scale = scale - 2 * -1;
	}
	curColor = curColor + color * 0.8 * scale;
	SetControllerLightbarColor(localClientNum, curColor);
}

