#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace _zm_weap_claymore;

/*
	Name: __init__sytem__
	Namespace: _zm_weap_claymore
	Checksum: 0x51E77591
	Offset: 0x2C8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("claymore", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _zm_weap_claymore
	Checksum: 0xC135554
	Offset: 0x308
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["claymore_laser"] = "_t6/weapon/claymore/fx_claymore_laser";
	zm_placeable_mine::add_mine_type("claymore", &"ZOMBIE_CLAYMORE_PICKUP");
	zm_placeable_mine::add_planted_callback(&play_claymore_effects, "claymore");
	zm_placeable_mine::add_planted_callback(&claymore_detonation, "claymore");
}

/*
	Name: play_claymore_effects
	Namespace: _zm_weap_claymore
	Checksum: 0xDADB4BD3
	Offset: 0x3A0
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function play_claymore_effects(e_planter)
{
	self endon("death");
	self zm_utility::waittill_not_moving();
	PlayFXOnTag(level._effect["claymore_laser"], self, "tag_fx");
}

/*
	Name: claymore_detonation
	Namespace: _zm_weap_claymore
	Checksum: 0x42991B25
	Offset: 0x408
	Size: 0x349
	Parameters: 1
	Flags: None
*/
function claymore_detonation(e_planter)
{
	self endon("death");
	self zm_utility::waittill_not_moving();
	detonateRadius = 96;
	damagearea = spawn("trigger_radius", self.origin, 9, detonateRadius, detonateRadius * 2);
	damagearea SetExcludeTeamForTrigger(self.owner.team);
	damagearea EnableLinkTo();
	damagearea LinkTo(self);
	if(isdefined(self.isOnBus) && self.isOnBus)
	{
		damagearea SetMovingPlatformEnabled(1);
	}
	self.damagearea = damagearea;
	self thread delete_mines_on_death(self.owner, damagearea);
	if(!isdefined(self.owner.placeable_mines))
	{
		self.owner.placeable_mines = [];
	}
	else if(!IsArray(self.owner.placeable_mines))
	{
		self.owner.placeable_mines = Array(self.owner.placeable_mines);
	}
	self.owner.placeable_mines[self.owner.placeable_mines.size] = self;
	while(1)
	{
		damagearea waittill("trigger", ent);
		if(isdefined(self.owner) && ent == self.owner)
		{
			continue;
		}
		if(isdefined(ent.pers) && isdefined(ent.pers["team"]) && ent.pers["team"] == self.team)
		{
			continue;
		}
		if(isdefined(ent.ignore_placeable_mine) && ent.ignore_placeable_mine)
		{
			continue;
		}
		if(!ent should_trigger_claymore(self))
		{
			continue;
		}
		if(ent damageConeTrace(self.origin, self) > 0)
		{
			self playsound("wpn_claymore_alert");
			wait(0.4);
			if(isdefined(self.owner))
			{
				self detonate(self.owner);
			}
			else
			{
				self detonate(undefined);
			}
			return;
		}
	}
}

/*
	Name: should_trigger_claymore
	Namespace: _zm_weap_claymore
	Checksum: 0x514284A6
	Offset: 0x760
	Size: 0x139
	Parameters: 1
	Flags: Private
*/
function private should_trigger_claymore(e_mine)
{
	n_detonation_dot = cos(70);
	pos = self.origin + VectorScale((0, 0, 1), 32);
	dirToPos = pos - e_mine.origin;
	objectForward = AnglesToForward(e_mine.angles);
	dist = VectorDot(dirToPos, objectForward);
	if(dist < 20)
	{
		return 0;
	}
	dirToPos = VectorNormalize(dirToPos);
	dot = VectorDot(dirToPos, objectForward);
	return dot > n_detonation_dot;
}

/*
	Name: delete_mines_on_death
	Namespace: _zm_weap_claymore
	Checksum: 0xD5036324
	Offset: 0x8A8
	Size: 0x73
	Parameters: 2
	Flags: Private
*/
function private delete_mines_on_death(player, ent)
{
	self waittill("death");
	if(isdefined(player))
	{
		ArrayRemoveValue(player.placeable_mines, self);
	}
	wait(0.05);
	if(isdefined(ent))
	{
		ent delete();
	}
}

