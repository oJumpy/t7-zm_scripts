#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zm_tomb_teleporter;

/*
	Name: init
	Namespace: zm_tomb_teleporter
	Checksum: 0xACA97E60
	Offset: 0x260
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("allplayers", "teleport_arrival_departure_fx", 21000, 1, "counter", &function_dadd24b7, 0, 0);
	clientfield::register("vehicle", "teleport_arrival_departure_fx", 21000, 1, "counter", &function_dadd24b7, 0, 0);
}

/*
	Name: main
	Namespace: zm_tomb_teleporter
	Checksum: 0x7784DED7
	Offset: 0x300
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function main()
{
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_factory_teleport", 21000, 1, "pstfx_zm_tomb_teleport");
}

/*
	Name: function_a8255fab
	Namespace: zm_tomb_teleporter
	Checksum: 0xD3E25CE2
	Offset: 0x338
	Size: 0x105
	Parameters: 7
	Flags: None
*/
function function_a8255fab(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self endon("disconnect");
	if(newVal == 1)
	{
		if(!isdefined(self.var_1e8e073f))
		{
			self.var_1e8e073f = PlayFXOnTag(localClientNum, level._effect["teleport_1p"], self, "tag_origin");
			SetFXIgnorePause(localClientNum, self.var_1e8e073f, 1);
		}
	}
	else if(isdefined(self.var_1e8e073f))
	{
		stopfx(localClientNum, self.var_1e8e073f);
		self.var_1e8e073f = undefined;
	}
}

/*
	Name: function_ffedfe48
	Namespace: zm_tomb_teleporter
	Checksum: 0xB8CCA17
	Offset: 0x448
	Size: 0xE3
	Parameters: 7
	Flags: None
*/
function function_ffedfe48(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	var_b162502d = !isdefined(self.var_76534568) && self.var_76534568;
	if(!(isdefined(self.var_76534568) && self.var_76534568))
	{
		self useanimtree(-1);
		self.var_76534568 = 1;
	}
	if(newVal)
	{
		self thread scene::Play("p7_fxanim_zm_ori_portal_open_bundle", self);
	}
	else
	{
		self thread scene::Play("p7_fxanim_zm_ori_portal_collapse_bundle", self);
	}
}

/*
	Name: function_dadd24b7
	Namespace: zm_tomb_teleporter
	Checksum: 0xE7FFB710
	Offset: 0x538
	Size: 0x171
	Parameters: 7
	Flags: None
*/
function function_dadd24b7(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	str_tag_name = "";
	if(self isPlayer())
	{
		str_tag_name = "j_spinelower";
	}
	else
	{
		str_tag_name = "tag_brain";
	}
	a_e_players = GetLocalPlayers();
	foreach(e_player in a_e_players)
	{
		self.var_16ab725 = PlayFXOnTag(e_player.localClientNum, level._effect["teleport_arrive_player"], self, str_tag_name);
		SetFXIgnorePause(e_player.localClientNum, self.var_16ab725, 1);
	}
}

