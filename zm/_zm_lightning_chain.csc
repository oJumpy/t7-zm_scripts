#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace lightning_chain;

/*
	Name: __init__sytem__
	Namespace: lightning_chain
	Checksum: 0x31266CCA
	Offset: 0x258
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("lightning_chain", &init, undefined, undefined);
}

/*
	Name: init
	Namespace: lightning_chain
	Checksum: 0x43B3577A
	Offset: 0x298
	Size: 0x1AB
	Parameters: 0
	Flags: None
*/
function init()
{
	level._effect["tesla_bolt"] = "zombie/fx_tesla_bolt_secondary_zmb";
	level._effect["tesla_shock"] = "zombie/fx_tesla_shock_zmb";
	level._effect["tesla_shock_secondary"] = "zombie/fx_tesla_bolt_secondary_zmb";
	level._effect["tesla_shock_nonfatal"] = "zombie/fx_bmode_shock_os_zod_zmb";
	level._effect["tesla_shock_eyes"] = "zombie/fx_tesla_shock_eyes_zmb";
	clientfield::register("actor", "lc_fx", 1, 2, "int", &lc_shock_fx, 0, 1);
	clientfield::register("vehicle", "lc_fx", 1, 2, "int", &lc_shock_fx, 0, 0);
	clientfield::register("actor", "lc_death_fx", 1, 2, "int", &lc_play_death_fx, 0, 0);
	clientfield::register("vehicle", "lc_death_fx", 8000, 2, "int", &lc_play_death_fx, 0, 0);
}

/*
	Name: lc_shock_fx
	Namespace: lightning_chain
	Checksum: 0x7A432861
	Offset: 0x450
	Size: 0x165
	Parameters: 7
	Flags: None
*/
function lc_shock_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	if(newVal)
	{
		if(!isdefined(self.lc_shock_fx))
		{
			str_tag = "J_SpineUpper";
			str_fx = "tesla_shock";
			if(!self isai())
			{
				str_tag = "tag_origin";
			}
			if(newVal > 1)
			{
				str_fx = "tesla_shock_secondary";
			}
			self.lc_shock_fx = PlayFXOnTag(localClientNum, level._effect[str_fx], self, str_tag);
			self playsound(0, "zmb_electrocute_zombie");
		}
	}
	else if(isdefined(self.lc_shock_fx))
	{
		stopfx(localClientNum, self.lc_shock_fx);
		self.lc_shock_fx = undefined;
	}
}

/*
	Name: lc_play_death_fx
	Namespace: lightning_chain
	Checksum: 0x9E4AC16F
	Offset: 0x5C0
	Size: 0x163
	Parameters: 7
	Flags: None
*/
function lc_play_death_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	str_tag = "J_SpineUpper";
	if(isdefined(self.isdog) && self.isdog)
	{
		str_tag = "J_Spine1";
	}
	if(!self.archetype === "zombie")
	{
		tag = "tag_origin";
	}
	switch(newVal)
	{
		case 2:
		{
			str_fx = level._effect["tesla_shock_secondary"];
			break;
		}
		case 3:
		{
			str_fx = level._effect["tesla_shock_nonfatal"];
			break;
		}
		case default:
		{
			str_fx = level._effect["tesla_shock"];
			break;
		}
	}
	PlayFXOnTag(localClientNum, str_fx, self, str_tag);
}

