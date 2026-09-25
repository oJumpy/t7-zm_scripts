#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\system_shared;

#namespace hud;

/*
	Name: __init__sytem__
	Namespace: hud
	Checksum: 0xACBA1B15
	Offset: 0x128
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("hud", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: hud
	Checksum: 0x67B6B5B9
	Offset: 0x168
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_start_gametype(&init);
}

/*
	Name: init
	Namespace: hud
	Checksum: 0xCEA92629
	Offset: 0x198
	Size: 0x383
	Parameters: 0
	Flags: None
*/
function init()
{
	level.uiParent = spawnstruct();
	level.uiParent.horzAlign = "left";
	level.uiParent.vertAlign = "top";
	level.uiParent.alignX = "left";
	level.uiParent.alignY = "top";
	level.uiParent.x = 0;
	level.uiParent.y = 0;
	level.uiParent.width = 0;
	level.uiParent.height = 0;
	level.uiParent.children = [];
	level.fontHeight = 12;
	foreach(team in level.teams)
	{
		level.hud[team] = spawnstruct();
	}
	level.primaryProgressBarY = -61;
	level.primaryProgressBarX = 0;
	level.primaryProgressBarHeight = 9;
	level.primaryProgressBarWidth = 120;
	level.primaryProgressBarTextY = -75;
	level.primaryProgressBarTextX = 0;
	level.primaryProgressBarFontSize = 1.4;
	if(level.Splitscreen)
	{
		level.primaryProgressBarX = 20;
		level.primaryProgressBarTextX = 20;
		level.primaryProgressBarY = 15;
		level.primaryProgressBarTextY = 0;
		level.primaryProgressBarHeight = 2;
	}
	level.secondaryProgressBarY = -85;
	level.secondaryProgressBarX = 0;
	level.secondaryProgressBarHeight = 9;
	level.secondaryProgressBarWidth = 120;
	level.secondaryProgressBarTextY = -100;
	level.secondaryProgressBarTextX = 0;
	level.secondaryProgressBarFontSize = 1.4;
	if(level.Splitscreen)
	{
		level.secondaryProgressBarX = 20;
		level.secondaryProgressBarTextX = 20;
		level.secondaryProgressBarY = 15;
		level.secondaryProgressBarTextY = 0;
		level.secondaryProgressBarHeight = 2;
	}
	level.teamProgressBarY = 32;
	level.teamProgressBarHeight = 14;
	level.teamProgressBarWidth = 192;
	level.teamProgressBarTextY = 8;
	level.teamProgressBarFontSize = 1.65;
	SetDvar("ui_generic_status_bar", 0);
	if(level.Splitscreen)
	{
		level.lowerTextYAlign = "BOTTOM";
		level.lowerTextY = -42;
		level.lowerTextFontSize = 1.4;
	}
	else
	{
		level.lowerTextYAlign = "CENTER";
		level.lowerTextY = 40;
		level.lowerTextFontSize = 1.4;
	}
}

/*
	Name: font_pulse_init
	Namespace: hud
	Checksum: 0x1D41364
	Offset: 0x528
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function font_pulse_init()
{
	self.baseFontScale = self.fontscale;
	self.maxFontScale = self.fontscale * 2;
	self.inFrames = 1.5;
	self.outFrames = 3;
}

/*
	Name: font_pulse
	Namespace: hud
	Checksum: 0x225808C6
	Offset: 0x578
	Size: 0x173
	Parameters: 1
	Flags: None
*/
function font_pulse(player)
{
	self notify("fontPulse");
	self endon("fontPulse");
	self endon("death");
	player endon("disconnect");
	player endon("joined_team");
	player endon("joined_spectators");
	if(self.outFrames == 0)
	{
		self.fontscale = 0.01;
	}
	else
	{
		self.fontscale = self.fontscale;
	}
	if(self.inFrames > 0)
	{
		self changeFontScaleOverTime(self.inFrames * 0.05);
		self.fontscale = self.maxFontScale;
		wait(self.inFrames * 0.05);
	}
	else
	{
		self.fontscale = self.maxFontScale;
		self.alpha = 0;
		self fadeOverTime(self.outFrames * 0.05);
		self.alpha = 1;
	}
	if(self.outFrames > 0)
	{
		self changeFontScaleOverTime(self.outFrames * 0.05);
		self.fontscale = self.baseFontScale;
	}
}

/*
	Name: fade_to_black_for_x_sec
	Namespace: hud
	Checksum: 0x2D9AF48C
	Offset: 0x6F8
	Size: 0x73
	Parameters: 5
	Flags: None
*/
function fade_to_black_for_x_sec(startwait, blackscreenwait, fadeInTime, fadeoutTime, shaderName)
{
	self endon("disconnect");
	wait(startwait);
	LUI::screen_fade_out(fadeInTime, shaderName);
	wait(blackscreenwait);
	LUI::screen_fade_in(fadeoutTime, shaderName);
}

/*
	Name: screen_fade_in
	Namespace: hud
	Checksum: 0xC469113F
	Offset: 0x778
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function screen_fade_in(fadeInTime)
{
	LUI::screen_fade_in(fadeInTime);
}

