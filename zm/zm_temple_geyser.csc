#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#namespace zm_temple_geyser;

/*
	Name: main
	Namespace: zm_temple_geyser
	Checksum: 0xDBF776BC
	Offset: 0x190
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function main()
{
	clientfield::register("allplayers", "geyserfakestand", 21000, 1, "int", &geyser_player_setup_stand, 0, 0);
	clientfield::register("allplayers", "geyserfakeprone", 21000, 1, "int", &geyser_player_setup_prone, 0, 0);
}

/*
	Name: geyser_player_setup_prone
	Namespace: zm_temple_geyser
	Checksum: 0xAAB74AA8
	Offset: 0x230
	Size: 0x41F
	Parameters: 7
	Flags: None
*/
function geyser_player_setup_prone(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(IsSpectating(localClientNum, 0))
	{
		return;
	}
	player = GetLocalPlayers()[localClientNum];
	if(player GetEntityNumber() == self GetEntityNumber())
	{
		if(newVal)
		{
			self PlayRumbleOnEntity(localClientNum, "slide_rumble");
		}
		else
		{
			self StopRumble(localClientNum, "slide_rumble");
		}
		return;
	}
	if(newVal)
	{
		if(localClientNum == 0)
		{
			self thread player_disconnect_tracker();
		}
		fake_player = spawn(localClientNum, self.origin + VectorScale((0, 0, -1), 800), "script_model");
		fake_player.angles = self.angles;
		fake_player SetModel(self.model);
		if(self.model == "c_ger_richtofen_body")
		{
			fake_player Attach("c_ger_richtofen_head", "J_Spine4");
			fake_player Attach("c_ger_richtofen_offcap", "J_Head");
		}
		fake_player.fake_weapon = spawn(localClientNum, self.origin, "script_model");
		if(self.weapon != "none" && self.weapon != "syrette")
		{
			fake_player.fake_weapon UseWeaponHideTags(self.weapon);
		}
		else
		{
			self thread geyser_weapon_monitor(fake_player.fake_weapon);
		}
		fake_player.fake_weapon LinkTo(fake_player, "tag_weapon_right");
		WaitRealTime(0.016);
		fake_player LinkTo(self, "tag_origin");
		if(!isdefined(self.fake_player))
		{
			self.fake_player = [];
		}
		self.fake_player[localClientNum] = fake_player;
		self thread wait_for_geyser_player_to_disconnect(localClientNum);
	}
	else if(!isdefined(self.fake_player) && !isdefined(self.fake_player[localClientNum]))
	{
		return;
	}
	str_notify = "player_geyser" + localClientNum;
	self notify(str_notify);
	self notify("end_geyser");
	if(isdefined(self.fake_player[localClientNum].fake_weapon))
	{
		self.fake_player[localClientNum].fake_weapon delete();
		self.fake_player[localClientNum].fake_weapon = undefined;
	}
	self.fake_player[localClientNum] delete();
	self.fake_player[localClientNum] = undefined;
}

/*
	Name: geyser_player_setup_stand
	Namespace: zm_temple_geyser
	Checksum: 0xB8739EAE
	Offset: 0x658
	Size: 0x447
	Parameters: 7
	Flags: None
*/
function geyser_player_setup_stand(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(IsSpectating(localClientNum, 0))
	{
		return;
	}
	player = GetLocalPlayers()[localClientNum];
	if(player GetEntityNumber() == self GetEntityNumber())
	{
		if(newVal)
		{
			self PlayRumbleOnEntity(localClientNum, "slide_rumble");
		}
		else
		{
			self StopRumble(localClientNum, "slide_rumble");
		}
		return;
	}
	if(newVal)
	{
		if(localClientNum == 0)
		{
			self thread player_disconnect_tracker();
		}
		fake_player = spawn(localClientNum, self.origin + VectorScale((0, 0, -1), 800), "script_model");
		fake_player.angles = self.angles;
		fake_player SetModel(self.model);
		if(self.model == "c_ger_richtofen_body")
		{
			fake_player Attach("c_ger_richtofen_head", "J_Spine4");
			fake_player Attach("c_ger_richtofen_offcap", "J_Head");
		}
		fake_player.fake_weapon = spawn(localClientNum, self.origin, "script_model");
		if(self.weapon.name != "none" && self.weapon.name != "syrette")
		{
			fake_player.fake_weapon UseWeaponHideTags(self.weapon);
		}
		else
		{
			self thread geyser_weapon_monitor(fake_player.fake_weapon);
		}
		fake_player.fake_weapon LinkTo(fake_player, "tag_weapon_right");
		WaitRealTime(0.016);
		fake_player.origin = self.origin;
		fake_player LinkTo(self, "tag_origin");
		if(!isdefined(self.fake_player))
		{
			self.fake_player = [];
		}
		self.fake_player[localClientNum] = fake_player;
		self thread wait_for_geyser_player_to_disconnect(localClientNum);
	}
	else if(!isdefined(self.fake_player) || !isdefined(self.fake_player[localClientNum]))
	{
		return;
	}
	str_notify = "player_geyser" + localClientNum;
	self notify(str_notify);
	self notify("end_geyser");
	if(isdefined(self.fake_player[localClientNum].fake_weapon))
	{
		self.fake_player[localClientNum].fake_weapon delete();
		self.fake_player[localClientNum].fake_weapon = undefined;
	}
	self.fake_player[localClientNum] delete();
	self.fake_player[localClientNum] = undefined;
}

/*
	Name: geyser_weapon_monitor
	Namespace: zm_temple_geyser
	Checksum: 0x8EAF6A1F
	Offset: 0xAA8
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function geyser_weapon_monitor(fake_weapon)
{
	self endon("end_geyser");
	self endon("disconnect");
	while(self.weapon == "none")
	{
		wait(0.05);
	}
	if(self.weapon != "syrette")
	{
		fake_weapon UseWeaponHideTags(self.weapon);
	}
}

/*
	Name: player_disconnect_tracker
	Namespace: zm_temple_geyser
	Checksum: 0x612AEAE1
	Offset: 0xB28
	Size: 0x65
	Parameters: 0
	Flags: None
*/
function player_disconnect_tracker()
{
	self notify("stop_tracking");
	self endon("stop_tracking");
	ent_num = self GetEntityNumber();
	while(isdefined(self))
	{
		wait(0.05);
	}
	level notify("player_disconnected", ent_num);
}

/*
	Name: geyser_model_remover
	Namespace: zm_temple_geyser
	Checksum: 0xA15C22C1
	Offset: 0xB98
	Size: 0x73
	Parameters: 2
	Flags: None
*/
function geyser_model_remover(str_endon, player)
{
	player endon(str_endon);
	level waittill("player_disconnected", client);
	if(isdefined(self.fake_weapon))
	{
		self.fake_weapon delete();
	}
	self delete();
}

/*
	Name: wait_for_geyser_player_to_disconnect
	Namespace: zm_temple_geyser
	Checksum: 0xA452BF0B
	Offset: 0xC18
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function wait_for_geyser_player_to_disconnect(localClientNum)
{
	str_endon = "player_geyser" + localClientNum;
	self.fake_player[localClientNum] thread geyser_model_remover(str_endon, self);
}

