#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace bouncingbetty;

/*
	Name: init_shared
	Namespace: bouncingbetty
	Checksum: 0xE3073727
	Offset: 0x2E0
	Size: 0x143
	Parameters: 1
	Flags: None
*/
function init_shared(localClientNum)
{
	level.explode_1st_offset = 55;
	level.explode_2nd_offset = 95;
	level.explode_main_offset = 140;
	level._effect["fx_betty_friendly_light"] = "weapon/fx_betty_light_blue";
	level._effect["fx_betty_enemy_light"] = "weapon/fx_betty_light_orng";
	level._effect["fx_betty_exp"] = "weapon/fx_betty_exp";
	level._effect["fx_betty_exp_death"] = "weapon/fx_betty_exp_death";
	level._effect["fx_betty_launch_dust"] = "weapon/fx_betty_launch_dust";
	clientfield::register("missile", "bouncingbetty_state", 1, 2, "int", &bouncingbetty_state_change, 0, 0);
	clientfield::register("scriptmover", "bouncingbetty_state", 1, 2, "int", &bouncingbetty_state_change, 0, 0);
}

/*
	Name: bouncingbetty_state_change
	Namespace: bouncingbetty
	Checksum: 0x4670DA60
	Offset: 0x430
	Size: 0xC5
	Parameters: 7
	Flags: None
*/
function bouncingbetty_state_change(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	switch(newVal)
	{
		case 1:
		{
			self thread BOUNCINGBETTY_DETONATING(localClientNum);
			break;
		}
		case 2:
		{
			self thread BOUNCINGBETTY_DEPLOYING(localClientNum);
			break;
		}
	}
}

/*
	Name: BOUNCINGBETTY_DEPLOYING
	Namespace: bouncingbetty
	Checksum: 0x98D16B11
	Offset: 0x500
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function BOUNCINGBETTY_DEPLOYING(localClientNum)
{
	self endon("entityshutdown");
	self useanimtree(-1);
	self SetAnim(%o_spider_mine_deploy, 1, 0, 1);
}

/*
	Name: BOUNCINGBETTY_DETONATING
	Namespace: bouncingbetty
	Checksum: 0x72050A31
	Offset: 0x578
	Size: 0x133
	Parameters: 1
	Flags: None
*/
function BOUNCINGBETTY_DETONATING(localClientNum)
{
	self endon("entityshutdown");
	up = anglesToUp(self.angles);
	FORWARD = AnglesToForward(self.angles);
	playFX(localClientNum, level._effect["fx_betty_launch_dust"], self.origin, up, FORWARD);
	self playsound(localClientNum, "wpn_betty_jump");
	self useanimtree(-1);
	self SetAnim(%o_spider_mine_detonate, 1, 0, 1);
	self thread watchForExplosionNotetracks(localClientNum, up, FORWARD);
}

/*
	Name: watchForExplosionNotetracks
	Namespace: bouncingbetty
	Checksum: 0x9A05C0DD
	Offset: 0x6B8
	Size: 0x1CD
	Parameters: 3
	Flags: None
*/
function watchForExplosionNotetracks(localClientNum, up, FORWARD)
{
	self endon("entityshutdown");
	while(1)
	{
		Notetrack = self util::waittill_any_return("explode_1st", "explode_2nd", "explode_main", "entityshutdown");
		switch(Notetrack)
		{
			case "explode_1st":
			{
				playFX(localClientNum, level._effect["fx_betty_exp"], self.origin + up * level.explode_1st_offset, up, FORWARD);
				break;
			}
			case "explode_2nd":
			{
				playFX(localClientNum, level._effect["fx_betty_exp"], self.origin + up * level.explode_2nd_offset, up, FORWARD);
				break;
			}
			case "explode_main":
			{
				playFX(localClientNum, level._effect["fx_betty_exp"], self.origin + up * level.explode_main_offset, up, FORWARD);
				playFX(localClientNum, level._effect["fx_betty_exp_death"], self.origin, up, FORWARD);
				break;
			}
			case default:
			{
				break;
			}
		}
	}
}

