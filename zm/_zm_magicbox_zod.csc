#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_magicbox_zod;

/*
	Name: init
	Namespace: zm_magicbox_zod
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
	RegisterClientField("zbarrier", "magicbox_initial_fx", 1, 1, "int", &magicbox_initial_closed_fx);
	RegisterClientField("zbarrier", "magicbox_amb_sound", 1, 1, "int", &magicbox_ambient_sound);
	RegisterClientField("zbarrier", "magicbox_open_fx", 1, 2, "int", &function_c8f2b7a1);
}

/*
	Name: function_c8f2b7a1
	Namespace: zm_magicbox_zod
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
	if(!isdefined(self.fx_obj_2))
	{
		self.fx_obj_2 = util::spawn_model(localClientNum, "tag_origin", self.origin, self.angles);
	}
	switch(newVal)
	{
		case 0:
		case 3:
		{
			if(isdefined(self.fx_obj.curr_open_fx))
			{
				stopfx(localClientNum, self.fx_obj.curr_open_fx);
			}
			self.fx_obj.curr_amb_fx = PlayFXOnTag(localClientNum, level._effect["box_closed"], self.fx_obj, "tag_origin");
			self.fx_obj_2 StopAllLoopSounds(1);
			self notify("magicbox_portal_finished");
			break;
		}
		case 1:
		{
			if(isdefined(self.fx_obj.curr_amb_fx))
			{
				stopfx(localClientNum, self.fx_obj.curr_amb_fx);
			}
			self.fx_obj.curr_open_fx = PlayFXOnTag(localClientNum, level._effect["box_open"], self.fx_obj, "tag_origin");
			self.fx_obj_2 PlayLoopSound("zmb_hellbox_open_effect");
			break;
		}
		case 2:
		{
			self.fx_obj delete();
			self.fx_obj_2 delete();
			break;
		}
	}
}

/*
	Name: magicbox_initial_closed_fx
	Namespace: zm_magicbox_zod
	Checksum: 0x3CFE9F14
	Offset: 0x588
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function magicbox_initial_closed_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
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
	Name: magicbox_ambient_sound
	Namespace: zm_magicbox_zod
	Checksum: 0x2013F6E0
	Offset: 0x648
	Size: 0x173
	Parameters: 7
	Flags: None
*/
function magicbox_ambient_sound(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(self.fx_obj))
	{
		self.fx_obj = util::spawn_model(localClientNum, "tag_origin", self.origin, self.angles);
	}
	if(isdefined(self.fx_obj.curr_amb_fx))
	{
		stopfx(localClientNum, self.fx_obj.curr_amb_fx);
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

