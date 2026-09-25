#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\util_shared;

#namespace laststand;

/*
	Name: player_is_in_laststand
	Namespace: laststand
	Checksum: 0xF997EFC
	Offset: 0x190
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function player_is_in_laststand()
{
	if(!(isdefined(self.no_revive_trigger) && self.no_revive_trigger))
	{
		return isdefined(self.reviveTrigger);
	}
	else
	{
		return isdefined(self.laststand) && self.laststand;
	}
}

/*
	Name: player_num_in_laststand
	Namespace: laststand
	Checksum: 0x310E3175
	Offset: 0x1D8
	Size: 0x81
	Parameters: 0
	Flags: None
*/
function player_num_in_laststand()
{
	num = 0;
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i] player_is_in_laststand())
		{
			num++;
		}
	}
	return num;
}

/*
	Name: player_all_players_in_laststand
	Namespace: laststand
	Checksum: 0x4FDDB829
	Offset: 0x268
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function player_all_players_in_laststand()
{
	return player_num_in_laststand() == GetPlayers().size;
}

/*
	Name: player_any_player_in_laststand
	Namespace: laststand
	Checksum: 0xDA614525
	Offset: 0x298
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function player_any_player_in_laststand()
{
	return player_num_in_laststand() > 0;
}

/*
	Name: laststand_allowed
	Namespace: laststand
	Checksum: 0x196606
	Offset: 0x2B8
	Size: 0x37
	Parameters: 3
	Flags: None
*/
function laststand_allowed(sWeapon, sMeansOfDeath, sHitLoc)
{
	if(level.laststandpistol == "none")
	{
		return 0;
	}
	return 1;
}

/*
	Name: cleanup_suicide_hud
	Namespace: laststand
	Checksum: 0xF977FFA6
	Offset: 0x2F8
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function cleanup_suicide_hud()
{
	if(isdefined(self.suicidePrompt))
	{
		self.suicidePrompt destroy();
	}
	self.suicidePrompt = undefined;
}

/*
	Name: clean_up_suicide_hud_on_end_game
	Namespace: laststand
	Checksum: 0x9C90E015
	Offset: 0x338
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function clean_up_suicide_hud_on_end_game()
{
	self endon("disconnect");
	self endon("stop_revive_trigger");
	self endon("player_revived");
	self endon("bled_out");
	level util::waittill_any("game_ended", "stop_suicide_trigger");
	self cleanup_suicide_hud();
	if(isdefined(self.suicideTextHud))
	{
		self.suicideTextHud destroy();
	}
	if(isdefined(self.suicideProgressBar))
	{
		self.suicideProgressBar hud::destroyElem();
	}
}

/*
	Name: clean_up_suicide_hud_on_bled_out
	Namespace: laststand
	Checksum: 0xBE6ACC14
	Offset: 0x400
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function clean_up_suicide_hud_on_bled_out()
{
	self endon("disconnect");
	self endon("stop_revive_trigger");
	self util::waittill_any("bled_out", "player_revived", "fake_death");
	self cleanup_suicide_hud();
	if(isdefined(self.suicideProgressBar))
	{
		self.suicideProgressBar hud::destroyElem();
	}
	if(isdefined(self.suicideTextHud))
	{
		self.suicideTextHud destroy();
	}
}

/*
	Name: is_facing
	Namespace: laststand
	Checksum: 0xDBF1BB69
	Offset: 0x4B8
	Size: 0x159
	Parameters: 2
	Flags: None
*/
function is_facing(facee, requiredDot)
{
	if(!isdefined(requiredDot))
	{
		requiredDot = 0.9;
	}
	orientation = self getPlayerAngles();
	forwardVec = AnglesToForward(orientation);
	forwardVec2D = (forwardVec[0], forwardVec[1], 0);
	unitForwardVec2D = VectorNormalize(forwardVec2D);
	toFaceeVec = facee.origin - self.origin;
	toFaceeVec2D = (toFaceeVec[0], toFaceeVec[1], 0);
	unitToFaceeVec2D = VectorNormalize(toFaceeVec2D);
	dotProduct = VectorDot(unitForwardVec2D, unitToFaceeVec2D);
	return dotProduct > requiredDot;
}

/*
	Name: revive_hud_create
	Namespace: laststand
	Checksum: 0x5CFC7D19
	Offset: 0x620
	Size: 0x137
	Parameters: 0
	Flags: None
*/
function revive_hud_create()
{
	self.revive_hud = newClientHudElem(self);
	self.revive_hud.alignX = "center";
	self.revive_hud.alignY = "middle";
	self.revive_hud.horzAlign = "center";
	self.revive_hud.vertAlign = "bottom";
	self.revive_hud.foreground = 1;
	self.revive_hud.font = "default";
	self.revive_hud.fontscale = 1.5;
	self.revive_hud.alpha = 0;
	self.revive_hud.color = (1, 1, 1);
	self.revive_hud.hidewheninmenu = 1;
	self.revive_hud setText("");
	self.revive_hud.y = -148;
}

/*
	Name: revive_hud_show
	Namespace: laststand
	Checksum: 0xCCE6BB0D
	Offset: 0x760
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function revive_hud_show()
{
	/#
		Assert(isdefined(self));
	#/
	/#
		Assert(isdefined(self.revive_hud));
	#/
	self.revive_hud.alpha = 1;
}

/*
	Name: revive_hud_show_n_fade
	Namespace: laststand
	Checksum: 0xFCD44F36
	Offset: 0x7B8
	Size: 0x4F
	Parameters: 1
	Flags: None
*/
function revive_hud_show_n_fade(time)
{
	revive_hud_show();
	self.revive_hud fadeOverTime(time);
	self.revive_hud.alpha = 0;
}

/*
	Name: drawcylinder
	Namespace: laststand
	Checksum: 0xD86F4EFD
	Offset: 0x810
	Size: 0x25D
	Parameters: 3
	Flags: None
*/
function drawcylinder(pos, rad, height)
{
	/#
		currad = rad;
		curheight = height;
		for(r = 0; r < 20; r++)
		{
			theta = r / 20 * 360;
			theta2 = r + 1 / 20 * 360;
			line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta2) * currad, sin(theta2) * currad, 0));
			line(pos + (cos(theta) * currad, sin(theta) * currad, curheight), pos + (cos(theta2) * currad, sin(theta2) * currad, curheight));
			line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta) * currad, sin(theta) * currad, curheight));
		}
	#/
}

/*
	Name: get_lives_remaining
	Namespace: laststand
	Checksum: 0xA29137BA
	Offset: 0xA78
	Size: 0x7D
	Parameters: 0
	Flags: None
*/
function get_lives_remaining()
{
	/#
		Assert(level.lastStandGetupAllowed, "Dev Block strings are not supported");
	#/
	if(level.lastStandGetupAllowed && isdefined(self.laststand_info) && isdefined(self.laststand_info.type_getup_lives))
	{
		return max(0, self.laststand_info.type_getup_lives);
	}
	return 0;
}

/*
	Name: update_lives_remaining
	Namespace: laststand
	Checksum: 0x8EAB02C1
	Offset: 0xB00
	Size: 0xD9
	Parameters: 1
	Flags: None
*/
function update_lives_remaining(increment)
{
	/#
		Assert(level.lastStandGetupAllowed, "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(increment), "Dev Block strings are not supported");
	#/
	if(isdefined(increment))
	{
	}
	else
	{
	}
	increment = 0;
	if(increment)
	{
	}
	else
	{
	}
	self.laststand_info.type_getup_lives = max(0, self.laststand_info.type_getup_lives - 1);
	self notify("laststand_lives_updated", self.laststand_info.type_getup_lives + 1, increment);
}

/*
	Name: player_getup_setup
	Namespace: laststand
	Checksum: 0xB0221D88
	Offset: 0xBE8
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function player_getup_setup()
{
	/#
		println("Dev Block strings are not supported");
	#/
	self.laststand_info = spawnstruct();
	self.laststand_info.type_getup_lives = 0;
}

/*
	Name: laststand_getup_damage_watcher
	Namespace: laststand
	Checksum: 0x7A430A53
	Offset: 0xC40
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function laststand_getup_damage_watcher()
{
	self endon("player_revived");
	self endon("disconnect");
	while(1)
	{
		self waittill("damage");
		self.laststand_info.getup_bar_value = self.laststand_info.getup_bar_value - 0.1;
		if(self.laststand_info.getup_bar_value < 0)
		{
			self.laststand_info.getup_bar_value = 0;
		}
	}
}

/*
	Name: laststand_getup_hud
	Namespace: laststand
	Checksum: 0x7210C0C0
	Offset: 0xCD0
	Size: 0x18F
	Parameters: 0
	Flags: None
*/
function laststand_getup_hud()
{
	self endon("player_revived");
	self endon("disconnect");
	hudelem = newClientHudElem(self);
	hudelem.alignX = "left";
	hudelem.alignY = "middle";
	hudelem.horzAlign = "left";
	hudelem.vertAlign = "middle";
	hudelem.x = 5;
	hudelem.y = 170;
	hudelem.font = "big";
	hudelem.fontscale = 1.5;
	hudelem.foreground = 1;
	hudelem.hidewheninmenu = 1;
	hudelem.hidewhendead = 1;
	hudelem.sort = 2;
	hudelem.label = &"SO_WAR_LASTSTAND_GETUP_BAR";
	self thread laststand_getup_hud_destroy(hudelem);
	while(1)
	{
		hudelem setValue(self.laststand_info.getup_bar_value);
		wait(0.05);
	}
}

/*
	Name: laststand_getup_hud_destroy
	Namespace: laststand
	Checksum: 0xD86B10F0
	Offset: 0xE68
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function laststand_getup_hud_destroy(hudelem)
{
	self util::waittill_either("player_revived", "disconnect");
	hudelem destroy();
}

/*
	Name: cleanup_laststand_on_disconnect
	Namespace: laststand
	Checksum: 0xA6344D42
	Offset: 0xEC0
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function cleanup_laststand_on_disconnect()
{
	self endon("player_revived");
	self endon("player_suicide");
	self endon("bled_out");
	trig = self.reviveTrigger;
	self waittill("disconnect");
	if(isdefined(trig))
	{
		trig delete();
	}
}

