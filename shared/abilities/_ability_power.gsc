#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_gadgets;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;

#namespace ability_power;

/*
	Name: __init__sytem__
	Namespace: ability_power
	Checksum: 0x46D4B0BD
	Offset: 0x288
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ability_power", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ability_power
	Checksum: 0xCB703D1D
	Offset: 0x2C8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_connect(&on_player_connect);
}

/*
	Name: function_13b0d3c3
	Namespace: ability_power
	Checksum: 0x8576C243
	Offset: 0x2F8
	Size: 0x10B
	Parameters: 2
	Flags: None
*/
function function_13b0d3c3(slot, STR)
{
	/#
		color = "Dev Block strings are not supported";
		var_ce775097 = color + "Dev Block strings are not supported" + STR;
		weaponName = "Dev Block strings are not supported";
		if(isdefined(self._gadgets_player[slot]))
		{
			weaponName = self._gadgets_player[slot].name;
		}
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			self IPrintLnBold(var_ce775097);
		}
		else
		{
			println(self.playerName + "Dev Block strings are not supported" + weaponName + "Dev Block strings are not supported" + var_ce775097);
		}
	#/
}

/*
	Name: on_player_connect
	Namespace: ability_power
	Checksum: 0x99EC1590
	Offset: 0x410
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
}

/*
	Name: power_is_hero_ability
	Namespace: ability_power
	Checksum: 0xFA7262E4
	Offset: 0x420
	Size: 0x1D
	Parameters: 1
	Flags: None
*/
function power_is_hero_ability(gadget)
{
	return gadget.gadget_type != 0;
}

/*
	Name: is_weapon_or_variant_same_as_gadget
	Namespace: ability_power
	Checksum: 0x80A20107
	Offset: 0x448
	Size: 0x67
	Parameters: 2
	Flags: None
*/
function is_weapon_or_variant_same_as_gadget(weapon, gadget)
{
	if(weapon == gadget)
	{
		return 1;
	}
	if(isdefined(level.weaponLightningGun) && gadget == level.weaponLightningGun)
	{
		if(isdefined(level.weaponLightningGunArc) && weapon == level.weaponLightningGunArc)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: power_gain_event_score
	Namespace: ability_power
	Checksum: 0xDCED7892
	Offset: 0x4B8
	Size: 0x24D
	Parameters: 4
	Flags: None
*/
function power_gain_event_score(eAttacker, score, weapon, hero_restricted)
{
	if(score > 0)
	{
		for(slot = 0; slot < 3; slot++)
		{
			gadget = self._gadgets_player[slot];
			if(isdefined(gadget))
			{
				ignoreSelf = gadget.gadget_powerGainScoreIgnoreSelf;
				if(isdefined(weapon) && ignoreSelf && is_weapon_or_variant_same_as_gadget(weapon, gadget))
				{
					continue;
				}
				ignoreWhenActive = gadget.gadget_powerGainScoreIgnoreWhenActive;
				if(ignoreWhenActive && self GadgetIsActive(slot))
				{
					continue;
				}
				if(isdefined(hero_restricted) && hero_restricted && power_is_hero_ability(gadget))
				{
					continue;
				}
				scoreFactor = gadget.gadget_powerGainScoreFactor;
				if(isdefined(self.gadgetThiefActive) && self.gadgetThiefActive == 1)
				{
					continue;
				}
				gametypeFactor = GetGametypeSetting("scoreHeroPowerGainFactor");
				perkFactor = 1;
				if(self hasPerk("specialty_overcharge"))
				{
					perkFactor = GetDvarFloat("gadgetPowerOverchargePerkScoreFactor");
				}
				if(scoreFactor > 0 && gametypeFactor > 0)
				{
					gainToAdd = score * scoreFactor * gametypeFactor * perkFactor;
					self power_gain_event(slot, eAttacker, gainToAdd, "score");
				}
			}
		}
	}
}

/*
	Name: power_gain_event_damage_actor
	Namespace: ability_power
	Checksum: 0xCACA1B14
	Offset: 0x710
	Size: 0x8D
	Parameters: 1
	Flags: None
*/
function power_gain_event_damage_actor(eAttacker)
{
	baseGain = 0;
	if(baseGain > 0)
	{
		for(slot = 0; slot < 3; slot++)
		{
			if(isdefined(self._gadgets_player[slot]))
			{
				self power_gain_event(slot, eAttacker, baseGain, "damaged actor");
			}
		}
	}
}

/*
	Name: power_gain_event_killed_actor
	Namespace: ability_power
	Checksum: 0x3EDEDDCE
	Offset: 0x7A8
	Size: 0x185
	Parameters: 2
	Flags: None
*/
function power_gain_event_killed_actor(eAttacker, meansOfDeath)
{
	baseGain = 5;
	for(slot = 0; slot < 3; slot++)
	{
		if(isdefined(self._gadgets_player[slot]))
		{
			if(meansOfDeath == "MOD_MELEE_ASSASSINATE" && self ability_util::gadget_is_camo_suit_on())
			{
				if(self._gadgets_player[slot].gadget_powertakedowngain > 0)
				{
					source = "assassinate actor";
					self power_gain_event(slot, eAttacker, self._gadgets_player[slot].gadget_powertakedowngain, source);
				}
			}
			if(self._gadgets_player[slot].gadget_powerreplenishfactor > 0)
			{
				gainToAdd = baseGain * self._gadgets_player[slot].gadget_powerreplenishfactor;
				if(gainToAdd > 0)
				{
					source = "killed actor";
					self power_gain_event(slot, eAttacker, gainToAdd, source);
				}
			}
		}
	}
}

/*
	Name: power_gain_event
	Namespace: ability_power
	Checksum: 0x637B828A
	Offset: 0x938
	Size: 0xF3
	Parameters: 4
	Flags: None
*/
function power_gain_event(slot, eAttacker, VAL, source)
{
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	powerToAdd = VAL;
	if(powerToAdd > 0.1 || powerToAdd < -0.1)
	{
		powerLeft = self GadgetPowerChange(slot, powerToAdd);
		/#
			self function_13b0d3c3(slot, "Dev Block strings are not supported" + powerToAdd + "Dev Block strings are not supported" + source + "Dev Block strings are not supported" + powerLeft);
		#/
	}
}

/*
	Name: power_loss_event_took_damage
	Namespace: ability_power
	Checksum: 0xEF257ACE
	Offset: 0xA38
	Size: 0x195
	Parameters: 5
	Flags: None
*/
function power_loss_event_took_damage(eAttacker, eInflictor, weapon, sMeansOfDeath, iDamage)
{
	baseLoss = iDamage;
	for(slot = 0; slot < 3; slot++)
	{
		if(isdefined(self._gadgets_player[slot]))
		{
			if(self GadgetIsActive(slot))
			{
				powerLoss = baseLoss * self._gadgets_player[slot].gadget_powerOnLossOnDamage;
				if(powerLoss > 0)
				{
					self power_loss_event(slot, eAttacker, powerLoss, "took damage with power on");
				}
				if(self._gadgets_player[slot].gadget_flickerOnDamage > 0)
				{
					self ability_gadgets::SetFlickering(slot, self._gadgets_player[slot].gadget_flickerOnDamage);
				}
				continue;
			}
			powerLoss = baseLoss * self._gadgets_player[slot].gadget_powerOffLossOnDamage;
			if(powerLoss > 0)
			{
				self power_loss_event(slot, eAttacker, powerLoss, "took damage");
			}
		}
	}
}

/*
	Name: power_loss_event
	Namespace: ability_power
	Checksum: 0xA4806B6F
	Offset: 0xBD8
	Size: 0xD3
	Parameters: 4
	Flags: None
*/
function power_loss_event(slot, eAttacker, VAL, source)
{
	powerToRemove = VAL * -1;
	if(powerToRemove > 0.1 || powerToRemove < -0.1)
	{
		powerLeft = self GadgetPowerChange(slot, powerToRemove);
		/#
			self function_13b0d3c3(slot, "Dev Block strings are not supported" + powerToRemove + "Dev Block strings are not supported" + source + "Dev Block strings are not supported" + powerLeft);
		#/
	}
}

/*
	Name: power_drain_completely
	Namespace: ability_power
	Checksum: 0x3FB9A5D0
	Offset: 0xCB8
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function power_drain_completely(slot)
{
	powerLeft = self GadgetPowerChange(slot, 0);
	powerLeft = self GadgetPowerChange(slot, powerLeft * -1);
}

/*
	Name: IsMovingPowerloss
	Namespace: ability_power
	Checksum: 0xA06FE933
	Offset: 0xD18
	Size: 0x6D
	Parameters: 0
	Flags: None
*/
function IsMovingPowerloss()
{
	velocity = self GetVelocity();
	speedsq = LengthSquared(velocity);
	return speedsq > self._gadgets_player.gadget_powermovespeed * self._gadgets_player.gadget_powermovespeed;
}

/*
	Name: power_consume_timer_think
	Namespace: ability_power
	Checksum: 0x9750AEA3
	Offset: 0xD90
	Size: 0x23F
	Parameters: 2
	Flags: None
*/
function power_consume_timer_think(slot, weapon)
{
	self endon("disconnect");
	self endon("death");
	time = GetTime();
	while(1)
	{
		wait(0.1);
		if(!isdefined(self._gadgets_player[slot]))
		{
			return;
		}
		if(!self GadgetIsActive(slot))
		{
			return;
		}
		currentTime = GetTime();
		interval = currentTime - time;
		time = currentTime;
		powerConsumpted = 0;
		if(self IsOnGround())
		{
			if(self._gadgets_player[slot].gadget_powersprintloss > 0 && self issprinting())
			{
				powerConsumpted = powerConsumpted + 1 * interval / 1000 * self._gadgets_player[slot].gadget_powersprintloss;
			}
			else if(self._gadgets_player[slot].gadget_powermoveloss && self IsMovingPowerloss())
			{
				powerConsumpted = powerConsumpted + 1 * interval / 1000 * self._gadgets_player[slot].gadget_powermoveloss;
			}
		}
		if(powerConsumpted > 0.1)
		{
			self power_loss_event(slot, self, powerConsumpted, "consume");
			if(self._gadgets_player[slot].gadget_flickerOnPowerloss > 0)
			{
				self ability_gadgets::SetFlickering(slot, self._gadgets_player[slot].gadget_flickerOnPowerloss);
			}
		}
	}
}

