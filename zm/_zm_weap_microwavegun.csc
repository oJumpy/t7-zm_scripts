#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace namespace_1a0051d2;

/*
	Name: __init__sytem__
	Namespace: namespace_1a0051d2
	Checksum: 0xE4DC6790
	Offset: 0x2E8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_microwavegun", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_1a0051d2
	Checksum: 0xB583057F
	Offset: 0x328
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("actor", "toggle_microwavegun_hit_response", 21000, 1, "int", &microwavegun_zombie_initial_hit_response, 0, 0);
	clientfield::register("actor", "toggle_microwavegun_expand_response", 21000, 1, "int", &microwavegun_zombie_expand_response, 0, 0);
	clientfield::register("clientuimodel", "hudItems.showDpadLeft_WaveGun", 21000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "hudItems.dpadLeftAmmo", 21000, 5, "int", undefined, 0, 0);
	level._effect["microwavegun_sizzle_blood_eyes"] = "dlc5/zmb_weapon/fx_sizzle_blood_eyes";
	level._effect["microwavegun_sizzle_death_mist"] = "dlc5/zmb_weapon/fx_sizzle_mist";
	level._effect["microwavegun_sizzle_death_mist_low_g"] = "dlc5/zmb_weapon/fx_sizzle_mist_low_g";
	level thread player_init();
}

/*
	Name: player_init
	Namespace: namespace_1a0051d2
	Checksum: 0x852BA97
	Offset: 0x4A0
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function player_init()
{
	util::waitforclient(0);
	players = GetLocalPlayers();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
	}
}

/*
	Name: microwavegun_create_hit_response_fx
	Namespace: namespace_1a0051d2
	Checksum: 0xDCAF4BA2
	Offset: 0x528
	Size: 0x67
	Parameters: 3
	Flags: None
*/
function microwavegun_create_hit_response_fx(localClientNum, tag, effect)
{
	if(!isdefined(self._microwavegun_hit_response_fx[localClientNum][tag]))
	{
		self._microwavegun_hit_response_fx[localClientNum][tag] = PlayFXOnTag(localClientNum, effect, self, tag);
	}
}

/*
	Name: microwavegun_delete_hit_response_fx
	Namespace: namespace_1a0051d2
	Checksum: 0x30D3C6F4
	Offset: 0x598
	Size: 0x65
	Parameters: 2
	Flags: None
*/
function microwavegun_delete_hit_response_fx(localClientNum, tag)
{
	if(isdefined(self._microwavegun_hit_response_fx[localClientNum][tag]))
	{
		deletefx(localClientNum, self._microwavegun_hit_response_fx[localClientNum][tag], 0);
		self._microwavegun_hit_response_fx[localClientNum][tag] = undefined;
	}
}

/*
	Name: microwavegun_bloat
	Namespace: namespace_1a0051d2
	Checksum: 0xBF90A093
	Offset: 0x608
	Size: 0x17B
	Parameters: 1
	Flags: None
*/
function microwavegun_bloat(localClientNum)
{
	self endon("entityshutdown");
	durationMsec = 2500;
	tag_pos = self GetTagOrigin("J_SpineLower");
	bloat_max_fraction = 1;
	if(!isdefined(tag_pos))
	{
		durationMsec = 1000;
	}
	self MapShaderConstant(localClientNum, 0, "scriptVector6", 0, 0, 0, 0);
	begin_time = GetRealTime();
	while(1)
	{
		age = GetRealTime() - begin_time;
		bloat_fraction = age / durationMsec;
		if(bloat_fraction > bloat_max_fraction)
		{
			bloat_fraction = bloat_max_fraction;
		}
		if(!isdefined(self))
		{
			return;
		}
		self MapShaderConstant(localClientNum, 0, "scriptVector6", 4 * bloat_fraction, 0, 0, 0);
		if(bloat_fraction >= bloat_max_fraction)
		{
			break;
		}
		WaitRealTime(0.05);
	}
}

/*
	Name: microwavegun_zombie_initial_hit_response
	Namespace: namespace_1a0051d2
	Checksum: 0x1EFA0C2
	Offset: 0x790
	Size: 0x165
	Parameters: 7
	Flags: None
*/
function microwavegun_zombie_initial_hit_response(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(isdefined(self.microwavegun_zombie_hit_response))
	{
		self [[self.microwavegun_zombie_hit_response]](localClientNum, newVal, bNewEnt);
		return;
	}
	if(localClientNum != 0)
	{
		return;
	}
	if(!isdefined(self._microwavegun_hit_response_fx))
	{
		self._microwavegun_hit_response_fx = [];
	}
	self.microwavegun_initial_hit_response = 1;
	players = GetLocalPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(!isdefined(self._microwavegun_hit_response_fx[i]))
		{
			self._microwavegun_hit_response_fx[i] = [];
		}
		if(newVal)
		{
			self microwavegun_create_hit_response_fx(i, "J_Eyeball_LE", level._effect["microwavegun_sizzle_blood_eyes"]);
			playsound(0, "wpn_mgun_impact_zombie", self.origin);
		}
	}
}

/*
	Name: microwavegun_zombie_expand_response
	Namespace: namespace_1a0051d2
	Checksum: 0xFC4397FE
	Offset: 0x900
	Size: 0x30D
	Parameters: 7
	Flags: None
*/
function microwavegun_zombie_expand_response(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(isdefined(self.microwavegun_zombie_hit_response))
	{
		self [[self.microwavegun_zombie_hit_response]](localClientNum, newVal, bNewEnt);
		return;
	}
	if(localClientNum != 0)
	{
		return;
	}
	if(!isdefined(self._microwavegun_hit_response_fx))
	{
		self._microwavegun_hit_response_fx = [];
	}
	initial_hit_occurred = isdefined(self.microwavegun_initial_hit_response) && self.microwavegun_initial_hit_response;
	players = GetLocalPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(!isdefined(self._microwavegun_hit_response_fx[i]))
		{
			self._microwavegun_hit_response_fx[i] = [];
		}
		if(newVal && initial_hit_occurred)
		{
			playsound(0, "wpn_mgun_impact_zombie", self.origin);
			self thread microwavegun_bloat(i);
			continue;
		}
		self thread microwavegun_bloat(i);
		if(initial_hit_occurred)
		{
			self microwavegun_delete_hit_response_fx(i, "J_Eyeball_LE");
		}
		tag_pos = self GetTagOrigin("J_SpineLower");
		tag_angles = self GetTagAngles("J_SpineLower");
		if(!isdefined(tag_pos))
		{
			tag_pos = self GetTagOrigin("J_Spine1");
			tag_angles = self GetTagAngles("J_Spine1");
		}
		FX = level._effect["microwavegun_sizzle_death_mist"];
		if(isdefined(self.in_low_g) && self.in_low_g)
		{
			FX = level._effect["microwavegun_sizzle_death_mist_low_g"];
		}
		if(isdefined(tag_pos))
		{
			playFX(i, FX, tag_pos, AnglesToForward(tag_angles), anglesToUp(tag_angles));
		}
		playsound(0, "wpn_mgun_explode_zombie", self.origin);
	}
}

