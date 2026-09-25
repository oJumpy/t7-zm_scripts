#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_cfbe948b;

/*
	Name: init
	Namespace: namespace_cfbe948b
	Checksum: 0x72867DD5
	Offset: 0x1F0
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function init()
{
	level._effect["box_open"] = "zombie/fx_weapon_box_open_zod_zmb";
	level._effect["box_closed"] = "zombie/fx_weapon_box_closed_zod_zmb";
	RegisterClientField("zbarrier", "magicbox_initial_fx", 1, 1, "int", &function_cc36f894);
	RegisterClientField("zbarrier", "magicbox_amb_sound", 1, 1, "int", &function_1c9eb55c);
	RegisterClientField("zbarrier", "magicbox_open_fx", 1, 2, "int", &function_c8f2b7a1);
}

/*
	Name: function_c8f2b7a1
	Namespace: namespace_cfbe948b
	Checksum: 0xA0B9E134
	Offset: 0x2F8
	Size: 0x285
	Parameters: 7
	Flags: None
*/
function function_c8f2b7a1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(self.fx_obj))
	{
		self.fx_obj = util::spawn_model(localClientNum, "tag_origin", self.origin, self.angles);
	}
	if(!isdefined(self.var_9b17c542))
	{
		self.var_9b17c542 = util::spawn_model(localClientNum, "tag_origin", self.origin, self.angles);
	}
	switch(newVal)
	{
		case 0:
		case 3:
		{
			if(isdefined(self.fx_obj.var_80194315))
			{
				stopfx(localClientNum, self.fx_obj.var_80194315);
			}
			self.fx_obj.var_992b4eed = PlayFXOnTag(localClientNum, level._effect["box_closed"], self.fx_obj, "tag_origin");
			self.var_9b17c542 StopAllLoopSounds(1);
			self notify("hash_90e6e5c7");
			break;
		}
		case 1:
		{
			if(isdefined(self.fx_obj.var_992b4eed))
			{
				stopfx(localClientNum, self.fx_obj.var_992b4eed);
			}
			self.fx_obj.var_80194315 = PlayFXOnTag(localClientNum, level._effect["box_open"], self.fx_obj, "tag_origin");
			self.var_9b17c542 PlayLoopSound("zmb_hellbox_open_effect");
			break;
		}
		case 2:
		{
			self.fx_obj delete();
			self.var_9b17c542 delete();
			break;
		}
	}
}

/*
	Name: function_cc36f894
	Namespace: namespace_cfbe948b
	Checksum: 0x3CFE9F14
	Offset: 0x588
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function function_cc36f894(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(self.fx_obj))
	{
		self.fx_obj = util::spawn_model(localClientNum, "tag_origin", self.origin, self.angles);
	}
	else
	{
		return;
	}
	if(newVal == 1)
	{
		self.fx_obj PlayLoopSound("zmb_hellbox_amb_low");
	}
}

/*
	Name: function_1c9eb55c
	Namespace: namespace_cfbe948b
	Checksum: 0x2013F6E0
	Offset: 0x648
	Size: 0x173
	Parameters: 7
	Flags: None
*/
function function_1c9eb55c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(self.fx_obj))
	{
		self.fx_obj = util::spawn_model(localClientNum, "tag_origin", self.origin, self.angles);
	}
	if(isdefined(self.fx_obj.var_992b4eed))
	{
		stopfx(localClientNum, self.fx_obj.var_992b4eed);
	}
	if(newVal == 0)
	{
		self.fx_obj PlayLoopSound("zmb_hellbox_amb_low");
		playsound(0, "zmb_hellbox_leave", self.fx_obj.origin);
	}
	else if(newVal == 1)
	{
		self.fx_obj PlayLoopSound("zmb_hellbox_amb_low");
		playsound(0, "zmb_hellbox_arrive", self.fx_obj.origin);
	}
}

