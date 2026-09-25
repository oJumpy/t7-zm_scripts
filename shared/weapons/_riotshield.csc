#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace riotshield;

/*
	Name: init_shared
	Namespace: riotshield
	Checksum: 0x19D90BED
	Offset: 0x260
	Size: 0x81
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	clientfield::register("scriptmover", "riotshield_state", 1, 2, "int", &shield_state_change, 0, 0);
	level._effect["riotshield_light"] = "_t6/weapon/riotshield/fx_riotshield_depoly_lights";
	level._effect["riotshield_dust"] = "_t6/weapon/riotshield/fx_riotshield_depoly_dust";
}

/*
	Name: shield_state_change
	Namespace: riotshield
	Checksum: 0x4150614B
	Offset: 0x2F0
	Size: 0xBD
	Parameters: 7
	Flags: None
*/
function shield_state_change(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	switch(newVal)
	{
		case 1:
		{
			instant = oldVal == 2;
			self thread riotshield_deploy_anim(localClientNum, instant);
			break;
		}
		case 2:
		{
			self thread riotshield_destroy_anim(localClientNum);
			break;
		}
	}
}

/*
	Name: riotshield_deploy_anim
	Namespace: riotshield
	Checksum: 0x8D16BAC6
	Offset: 0x3B8
	Size: 0x153
	Parameters: 2
	Flags: None
*/
function riotshield_deploy_anim(localClientNum, instant)
{
	self endon("entityshutdown");
	self thread watch_riotshield_damage();
	self util::waittill_dobj(localClientNum);
	self useanimtree(-1);
	if(instant)
	{
		self SetAnimTime(%o_riot_stand_deploy, 1);
	}
	else
	{
		self SetAnim(%o_riot_stand_deploy, 1, 0, 1);
		PlayFXOnTag(localClientNum, level._effect["riotshield_dust"], self, "tag_origin");
	}
	if(!instant)
	{
		wait(0.8);
	}
	self.shieldLightFx = PlayFXOnTag(localClientNum, level._effect["riotshield_light"], self, "tag_fx");
}

/*
	Name: watch_riotshield_damage
	Namespace: riotshield
	Checksum: 0x1D0E80E
	Offset: 0x518
	Size: 0x107
	Parameters: 0
	Flags: None
*/
function watch_riotshield_damage()
{
	self endon("entityshutdown");
	while(1)
	{
		self waittill("damage", damage_loc, damage_type);
		self useanimtree(-1);
		if(damage_type == "MOD_MELEE" || damage_type == "MOD_MELEE_WEAPON_BUTT" || damage_type == "MOD_MELEE_ASSASSINATE")
		{
			self SetAnim(%o_riot_stand_melee_front, 1, 0, 1);
		}
		else
		{
			self SetAnim(%o_riot_stand_shot, 1, 0, 1);
		}
	}
}

/*
	Name: riotshield_destroy_anim
	Namespace: riotshield
	Checksum: 0x63BD9418
	Offset: 0x628
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function riotshield_destroy_anim(localClientNum)
{
	self endon("entityshutdown");
	if(isdefined(self.shieldLightFx))
	{
		stopfx(localClientNum, self.shieldLightFx);
	}
	wait(0.05);
	self playsound(localClientNum, "wpn_shield_destroy");
	self useanimtree(-1);
	self SetAnim(%o_riot_stand_destroyed, 1, 0, 1);
	wait(1);
	self SetForceNotSimple();
}

