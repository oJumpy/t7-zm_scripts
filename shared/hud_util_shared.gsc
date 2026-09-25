#using scripts\codescripts\struct;
#using scripts\shared\lui_shared;
#using scripts\shared\util_shared;

#namespace hud;

/*
	Name: setParent
	Namespace: hud
	Checksum: 0x44B1A20E
	Offset: 0x2E0
	Size: 0xDB
	Parameters: 1
	Flags: None
*/
function setParent(element)
{
	if(isdefined(self.parent) && self.parent == element)
	{
		return;
	}
	if(isdefined(self.parent))
	{
		self.parent removeChild(self);
	}
	self.parent = element;
	self.parent addChild(self);
	if(isdefined(self.point))
	{
		self setPoint(self.point, self.relativePoint, self.xOffset, self.yOffset);
	}
	else
	{
		self setPoint("TOP");
	}
}

/*
	Name: getParent
	Namespace: hud
	Checksum: 0x6ADBF6AC
	Offset: 0x3C8
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function getParent()
{
	return self.parent;
}

/*
	Name: addChild
	Namespace: hud
	Checksum: 0xEBB23835
	Offset: 0x3E0
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function addChild(element)
{
	element.index = self.children.size;
	self.children[self.children.size] = element;
}

/*
	Name: removeChild
	Namespace: hud
	Checksum: 0x6B0DA04E
	Offset: 0x428
	Size: 0xC5
	Parameters: 1
	Flags: None
*/
function removeChild(element)
{
	element.parent = undefined;
	if(self.children[self.children.size - 1] != element)
	{
		self.children[element.index] = self.children[self.children.size - 1];
		self.children[element.index].index = element.index;
	}
	self.children[self.children.size - 1] = undefined;
	element.index = undefined;
}

/*
	Name: setPoint
	Namespace: hud
	Checksum: 0xBA0F5E96
	Offset: 0x4F8
	Size: 0x833
	Parameters: 5
	Flags: None
*/
function setPoint(point, relativePoint, xOffset, yOffset, moveTime)
{
	if(!isdefined(moveTime))
	{
		moveTime = 0;
	}
	element = self getParent();
	if(moveTime)
	{
		self MoveOverTime(moveTime);
	}
	if(!isdefined(xOffset))
	{
		xOffset = 0;
	}
	self.xOffset = xOffset;
	if(!isdefined(yOffset))
	{
		yOffset = 0;
	}
	self.yOffset = yOffset;
	self.point = point;
	self.alignX = "center";
	self.alignY = "middle";
	switch(point)
	{
		case "CENTER":
		{
			break;
		}
		case "TOP":
		{
			self.alignY = "top";
			break;
		}
		case "BOTTOM":
		{
			self.alignY = "bottom";
			break;
		}
		case "LEFT":
		{
			self.alignX = "left";
			break;
		}
		case "RIGHT":
		{
			self.alignX = "right";
			break;
		}
		case "TOPRIGHT":
		case "TOP_RIGHT":
		{
			self.alignY = "top";
			self.alignX = "right";
			break;
		}
		case "TOPLEFT":
		case "TOP_LEFT":
		{
			self.alignY = "top";
			self.alignX = "left";
			break;
		}
		case "TOPCENTER":
		{
			self.alignY = "top";
			self.alignX = "center";
			break;
		}
		case "BOTTOM RIGHT":
		case "BOTTOM_RIGHT":
		{
			self.alignY = "bottom";
			self.alignX = "right";
			break;
		}
		case "BOTTOM LEFT":
		case "BOTTOM_LEFT":
		{
			self.alignY = "bottom";
			self.alignX = "left";
			break;
		}
		case default:
		{
			/#
				println("Dev Block strings are not supported" + point);
			#/
			break;
		}
	}
	if(!isdefined(relativePoint))
	{
		relativePoint = point;
	}
	self.relativePoint = relativePoint;
	relativeX = "center";
	relativeY = "middle";
	switch(relativePoint)
	{
		case "CENTER":
		{
			break;
		}
		case "TOP":
		{
			relativeY = "top";
			break;
		}
		case "BOTTOM":
		{
			relativeY = "bottom";
			break;
		}
		case "LEFT":
		{
			relativeX = "left";
			break;
		}
		case "RIGHT":
		{
			relativeX = "right";
			break;
		}
		case "TOPRIGHT":
		case "TOP_RIGHT":
		{
			relativeY = "top";
			relativeX = "right";
			break;
		}
		case "TOPLEFT":
		case "TOP_LEFT":
		{
			relativeY = "top";
			relativeX = "left";
			break;
		}
		case "TOPCENTER":
		{
			relativeY = "top";
			relativeX = "center";
			break;
		}
		case "BOTTOM RIGHT":
		case "BOTTOM_RIGHT":
		{
			relativeY = "bottom";
			relativeX = "right";
			break;
		}
		case "BOTTOM LEFT":
		case "BOTTOM_LEFT":
		{
			relativeY = "bottom";
			relativeX = "left";
			break;
		}
		case default:
		{
			/#
				println("Dev Block strings are not supported" + relativePoint);
			#/
			break;
		}
	}
	if(element == level.uiParent)
	{
		self.horzAlign = relativeX;
		self.vertAlign = relativeY;
	}
	else
	{
		self.horzAlign = element.horzAlign;
		self.vertAlign = element.vertAlign;
	}
	if(relativeX == element.alignX)
	{
		offsetx = 0;
		xFactor = 0;
	}
	else if(relativeX == "center" || element.alignX == "center")
	{
		offsetx = Int(element.width / 2);
		if(relativeX == "left" || element.alignX == "right")
		{
			xFactor = -1;
		}
		else
		{
			xFactor = 1;
		}
	}
	else
	{
		offsetx = element.width;
		if(relativeX == "left")
		{
			xFactor = -1;
		}
		else
		{
			xFactor = 1;
		}
	}
	self.x = element.x + offsetx * xFactor;
	if(relativeY == element.alignY)
	{
		offsety = 0;
		yFactor = 0;
	}
	else if(relativeY == "middle" || element.alignY == "middle")
	{
		offsety = Int(element.height / 2);
		if(relativeY == "top" || element.alignY == "bottom")
		{
			yFactor = -1;
		}
		else
		{
			yFactor = 1;
		}
	}
	else
	{
		offsety = element.height;
		if(relativeY == "top")
		{
			yFactor = -1;
		}
		else
		{
			yFactor = 1;
		}
	}
	self.y = element.y + offsety * yFactor;
	self.x = self.x + self.xOffset;
	self.y = self.y + self.yOffset;
	switch(self.elemType)
	{
		case "bar":
		{
			setPointBar(point, relativePoint, xOffset, yOffset);
			self.barFrame setParent(self getParent());
			self.barFrame setPoint(point, relativePoint, xOffset, yOffset);
			break;
		}
	}
	self updateChildren();
}

/*
	Name: setPointBar
	Namespace: hud
	Checksum: 0x2B7DBBE2
	Offset: 0xD38
	Size: 0x1BB
	Parameters: 4
	Flags: None
*/
function setPointBar(point, relativePoint, xOffset, yOffset)
{
	self.bar.horzAlign = self.horzAlign;
	self.bar.vertAlign = self.vertAlign;
	self.bar.alignX = "left";
	self.bar.alignY = self.alignY;
	self.bar.y = self.y;
	if(self.alignX == "left")
	{
		self.bar.x = self.x;
	}
	else if(self.alignX == "right")
	{
		self.bar.x = self.x - self.width;
	}
	else
	{
		self.bar.x = self.x - Int(self.width / 2);
	}
	if(self.alignY == "top")
	{
		self.bar.y = self.y;
	}
	else if(self.alignY == "bottom")
	{
		self.bar.y = self.y;
	}
	self updateBar(self.bar.frac);
}

/*
	Name: updateBar
	Namespace: hud
	Checksum: 0xED78D51A
	Offset: 0xF00
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function updateBar(barFrac, rateOfChange)
{
	if(self.elemType == "bar")
	{
		updateBarScale(barFrac, rateOfChange);
	}
}

/*
	Name: updateBarScale
	Namespace: hud
	Checksum: 0xC9043F0A
	Offset: 0xF50
	Size: 0x253
	Parameters: 2
	Flags: None
*/
function updateBarScale(barFrac, rateOfChange)
{
	barWidth = Int(self.width * barFrac + 0.5);
	if(!barWidth)
	{
		barWidth = 1;
	}
	self.bar.frac = barFrac;
	self.bar SetShader(self.bar.shader, barWidth, self.height);
	/#
		Assert(barWidth <= self.width, "Dev Block strings are not supported" + barWidth + "Dev Block strings are not supported" + self.width + "Dev Block strings are not supported" + barFrac);
	#/
	if(isdefined(rateOfChange) && barWidth < self.width)
	{
		if(rateOfChange > 0)
		{
			/#
				Assert(1 - barFrac / rateOfChange > 0, "Dev Block strings are not supported" + barFrac + "Dev Block strings are not supported" + rateOfChange);
			#/
			self.bar ScaleOverTime(1 - barFrac / rateOfChange, self.width, self.height);
		}
		else if(rateOfChange < 0)
		{
			/#
				Assert(barFrac / -1 * rateOfChange > 0, "Dev Block strings are not supported" + barFrac + "Dev Block strings are not supported" + rateOfChange);
			#/
			self.bar ScaleOverTime(barFrac / -1 * rateOfChange, 1, self.height);
		}
	}
	self.bar.rateOfChange = rateOfChange;
	self.bar.lastUpdateTime = GetTime();
}

/*
	Name: createFontString
	Namespace: hud
	Checksum: 0x7D233E29
	Offset: 0x11B0
	Size: 0x12F
	Parameters: 2
	Flags: None
*/
function createFontString(font, fontscale)
{
	fontElem = newClientHudElem(self);
	fontElem.elemType = "font";
	fontElem.font = font;
	fontElem.fontscale = fontscale;
	fontElem.x = 0;
	fontElem.y = 0;
	fontElem.width = 0;
	fontElem.height = Int(level.fontHeight * fontscale);
	fontElem.xOffset = 0;
	fontElem.yOffset = 0;
	fontElem.children = [];
	fontElem setParent(level.uiParent);
	fontElem.hidden = 0;
	return fontElem;
}

/*
	Name: createServerFontString
	Namespace: hud
	Checksum: 0x6EA1784A
	Offset: 0x12E8
	Size: 0x157
	Parameters: 3
	Flags: None
*/
function createServerFontString(font, fontscale, team)
{
	if(isdefined(team))
	{
		fontElem = NewTeamHudElem(team);
	}
	else
	{
		fontElem = NewHudElem();
	}
	fontElem.elemType = "font";
	fontElem.font = font;
	fontElem.fontscale = fontscale;
	fontElem.x = 0;
	fontElem.y = 0;
	fontElem.width = 0;
	fontElem.height = Int(level.fontHeight * fontscale);
	fontElem.xOffset = 0;
	fontElem.yOffset = 0;
	fontElem.children = [];
	fontElem setParent(level.uiParent);
	fontElem.hidden = 0;
	return fontElem;
}

/*
	Name: createServerTimer
	Namespace: hud
	Checksum: 0x885877FD
	Offset: 0x1448
	Size: 0x157
	Parameters: 3
	Flags: None
*/
function createServerTimer(font, fontscale, team)
{
	if(isdefined(team))
	{
		timerElem = NewTeamHudElem(team);
	}
	else
	{
		timerElem = NewHudElem();
	}
	timerElem.elemType = "timer";
	timerElem.font = font;
	timerElem.fontscale = fontscale;
	timerElem.x = 0;
	timerElem.y = 0;
	timerElem.width = 0;
	timerElem.height = Int(level.fontHeight * fontscale);
	timerElem.xOffset = 0;
	timerElem.yOffset = 0;
	timerElem.children = [];
	timerElem setParent(level.uiParent);
	timerElem.hidden = 0;
	return timerElem;
}

/*
	Name: createClientTimer
	Namespace: hud
	Checksum: 0xF387CCCB
	Offset: 0x15A8
	Size: 0x12F
	Parameters: 2
	Flags: None
*/
function createClientTimer(font, fontscale)
{
	timerElem = newClientHudElem(self);
	timerElem.elemType = "timer";
	timerElem.font = font;
	timerElem.fontscale = fontscale;
	timerElem.x = 0;
	timerElem.y = 0;
	timerElem.width = 0;
	timerElem.height = Int(level.fontHeight * fontscale);
	timerElem.xOffset = 0;
	timerElem.yOffset = 0;
	timerElem.children = [];
	timerElem setParent(level.uiParent);
	timerElem.hidden = 0;
	return timerElem;
}

/*
	Name: createIcon
	Namespace: hud
	Checksum: 0x798E9BE7
	Offset: 0x16E0
	Size: 0x12F
	Parameters: 3
	Flags: None
*/
function createIcon(shader, width, height)
{
	iconElem = newClientHudElem(self);
	iconElem.elemType = "icon";
	iconElem.x = 0;
	iconElem.y = 0;
	iconElem.width = width;
	iconElem.height = height;
	iconElem.xOffset = 0;
	iconElem.yOffset = 0;
	iconElem.children = [];
	iconElem setParent(level.uiParent);
	iconElem.hidden = 0;
	if(isdefined(shader))
	{
		iconElem SetShader(shader, width, height);
	}
	return iconElem;
}

/*
	Name: createServerIcon
	Namespace: hud
	Checksum: 0x168C9662
	Offset: 0x1818
	Size: 0x157
	Parameters: 4
	Flags: None
*/
function createServerIcon(shader, width, height, team)
{
	if(isdefined(team))
	{
		iconElem = NewTeamHudElem(team);
	}
	else
	{
		iconElem = NewHudElem();
	}
	iconElem.elemType = "icon";
	iconElem.x = 0;
	iconElem.y = 0;
	iconElem.width = width;
	iconElem.height = height;
	iconElem.xOffset = 0;
	iconElem.yOffset = 0;
	iconElem.children = [];
	iconElem setParent(level.uiParent);
	iconElem.hidden = 0;
	if(isdefined(shader))
	{
		iconElem SetShader(shader, width, height);
	}
	return iconElem;
}

/*
	Name: createServerBar
	Namespace: hud
	Checksum: 0xB0AC180F
	Offset: 0x1978
	Size: 0x46F
	Parameters: 6
	Flags: None
*/
function createServerBar(color, width, height, flashFrac, team, selected)
{
	if(isdefined(team))
	{
		barElem = NewTeamHudElem(team);
	}
	else
	{
		barElem = NewHudElem();
	}
	barElem.x = 0;
	barElem.y = 0;
	barElem.frac = 0;
	barElem.color = color;
	barElem.sort = -2;
	barElem.shader = "progress_bar_fill";
	barElem SetShader("progress_bar_fill", width, height);
	barElem.hidden = 0;
	if(isdefined(flashFrac))
	{
		barElem.flashFrac = flashFrac;
	}
	if(isdefined(team))
	{
		barElemFrame = NewTeamHudElem(team);
	}
	else
	{
		barElemFrame = NewHudElem();
	}
	barElemFrame.elemType = "icon";
	barElemFrame.x = 0;
	barElemFrame.y = 0;
	barElemFrame.width = width;
	barElemFrame.height = height;
	barElemFrame.xOffset = 0;
	barElemFrame.yOffset = 0;
	barElemFrame.bar = barElem;
	barElemFrame.barFrame = barElemFrame;
	barElemFrame.children = [];
	barElemFrame.sort = -1;
	barElemFrame.color = (1, 1, 1);
	barElemFrame setParent(level.uiParent);
	if(isdefined(selected))
	{
		barElemFrame SetShader("progress_bar_fg_sel", width, height);
	}
	else
	{
		barElemFrame SetShader("progress_bar_fg", width, height);
	}
	barElemFrame.hidden = 0;
	if(isdefined(team))
	{
		barElemBG = NewTeamHudElem(team);
	}
	else
	{
		barElemBG = NewHudElem();
	}
	barElemBG.elemType = "bar";
	barElemBG.x = 0;
	barElemBG.y = 0;
	barElemBG.width = width;
	barElemBG.height = height;
	barElemBG.xOffset = 0;
	barElemBG.yOffset = 0;
	barElemBG.bar = barElem;
	barElemBG.barFrame = barElemFrame;
	barElemBG.children = [];
	barElemBG.sort = -3;
	barElemBG.color = (0, 0, 0);
	barElemBG.alpha = 0.5;
	barElemBG setParent(level.uiParent);
	barElemBG SetShader("progress_bar_bg", width, height);
	barElemBG.hidden = 0;
	return barElemBG;
}

/*
	Name: createBar
	Namespace: hud
	Checksum: 0x5D150E36
	Offset: 0x1DF0
	Size: 0x3EF
	Parameters: 4
	Flags: None
*/
function createBar(color, width, height, flashFrac)
{
	barElem = newClientHudElem(self);
	barElem.x = 0;
	barElem.y = 0;
	barElem.frac = 0;
	barElem.color = color;
	barElem.sort = -2;
	barElem.shader = "progress_bar_fill";
	barElem SetShader("progress_bar_fill", width, height);
	barElem.hidden = 0;
	if(isdefined(flashFrac))
	{
		barElem.flashFrac = flashFrac;
	}
	barElemFrame = newClientHudElem(self);
	barElemFrame.elemType = "icon";
	barElemFrame.x = 0;
	barElemFrame.y = 0;
	barElemFrame.width = width;
	barElemFrame.height = height;
	barElemFrame.xOffset = 0;
	barElemFrame.yOffset = 0;
	barElemFrame.bar = barElem;
	barElemFrame.barFrame = barElemFrame;
	barElemFrame.children = [];
	barElemFrame.sort = -1;
	barElemFrame.color = (1, 1, 1);
	barElemFrame setParent(level.uiParent);
	barElemFrame.hidden = 0;
	barElemBG = newClientHudElem(self);
	barElemBG.elemType = "bar";
	if(!level.Splitscreen)
	{
		barElemBG.x = -2;
		barElemBG.y = -2;
	}
	barElemBG.width = width;
	barElemBG.height = height;
	barElemBG.xOffset = 0;
	barElemBG.yOffset = 0;
	barElemBG.bar = barElem;
	barElemBG.barFrame = barElemFrame;
	barElemBG.children = [];
	barElemBG.sort = -3;
	barElemBG.color = (0, 0, 0);
	barElemBG.alpha = 0.5;
	barElemBG setParent(level.uiParent);
	if(!level.Splitscreen)
	{
		barElemBG SetShader("progress_bar_bg", width + 4, height + 4);
	}
	else
	{
		barElemBG SetShader("progress_bar_bg", width + 0, height + 0);
	}
	barElemBG.hidden = 0;
	return barElemBG;
}

/*
	Name: getCurrentFraction
	Namespace: hud
	Checksum: 0xC01AF5D6
	Offset: 0x21E8
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function getCurrentFraction()
{
	frac = self.bar.frac;
	if(isdefined(self.bar.rateOfChange))
	{
		frac = frac + GetTime() - self.bar.lastUpdateTime * self.bar.rateOfChange;
		if(frac > 1)
		{
			frac = 1;
		}
		if(frac < 0)
		{
			frac = 0;
		}
	}
	return frac;
}

/*
	Name: createPrimaryProgressBar
	Namespace: hud
	Checksum: 0x3C4BF479
	Offset: 0x2288
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function createPrimaryProgressBar()
{
	bar = createBar((1, 1, 1), level.primaryProgressBarWidth, level.primaryProgressBarHeight);
	if(level.Splitscreen)
	{
		bar setPoint("TOP", undefined, level.primaryProgressBarX, level.primaryProgressBarY);
	}
	else
	{
		bar setPoint("CENTER", undefined, level.primaryProgressBarX, level.primaryProgressBarY);
	}
	return bar;
}

/*
	Name: createPrimaryProgressBarText
	Namespace: hud
	Checksum: 0x29CCD3D1
	Offset: 0x2330
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function createPrimaryProgressBarText()
{
	text = createFontString("objective", level.primaryProgressBarFontSize);
	if(level.Splitscreen)
	{
		text setPoint("TOP", undefined, level.primaryProgressBarTextX, level.primaryProgressBarTextY);
	}
	else
	{
		text setPoint("CENTER", undefined, level.primaryProgressBarTextX, level.primaryProgressBarTextY);
	}
	text.sort = -1;
	return text;
}

/*
	Name: createSecondaryProgressBar
	Namespace: hud
	Checksum: 0xBDF11818
	Offset: 0x23E8
	Size: 0x11F
	Parameters: 0
	Flags: None
*/
function createSecondaryProgressBar()
{
	secondaryProgressBarHeight = GetDvarInt("scr_secondaryProgressBarHeight", level.secondaryProgressBarHeight);
	secondaryProgressBarX = GetDvarInt("scr_secondaryProgressBarX", level.secondaryProgressBarX);
	secondaryProgressBarY = GetDvarInt("scr_secondaryProgressBarY", level.secondaryProgressBarY);
	bar = createBar((1, 1, 1), level.secondaryProgressBarWidth, secondaryProgressBarHeight);
	if(level.Splitscreen)
	{
		bar setPoint("TOP", undefined, secondaryProgressBarX, secondaryProgressBarY);
	}
	else
	{
		bar setPoint("CENTER", undefined, secondaryProgressBarX, secondaryProgressBarY);
	}
	return bar;
}

/*
	Name: createSecondaryProgressBarText
	Namespace: hud
	Checksum: 0xFA96E4A8
	Offset: 0x2510
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function createSecondaryProgressBarText()
{
	secondaryProgressBarTextX = GetDvarInt("scr_btx", level.secondaryProgressBarTextX);
	secondaryProgressBarTextY = GetDvarInt("scr_bty", level.secondaryProgressBarTextY);
	text = createFontString("objective", level.primaryProgressBarFontSize);
	if(level.Splitscreen)
	{
		text setPoint("TOP", undefined, secondaryProgressBarTextX, secondaryProgressBarTextY);
	}
	else
	{
		text setPoint("CENTER", undefined, secondaryProgressBarTextX, secondaryProgressBarTextY);
	}
	text.sort = -1;
	return text;
}

/*
	Name: createTeamProgressBar
	Namespace: hud
	Checksum: 0xA7E34BD9
	Offset: 0x2620
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function createTeamProgressBar(team)
{
	bar = createServerBar((1, 0, 0), level.teamProgressBarWidth, level.teamProgressBarHeight, undefined, team);
	bar setPoint("TOP", undefined, 0, level.teamProgressBarY);
	return bar;
}

/*
	Name: createTeamProgressBarText
	Namespace: hud
	Checksum: 0x2EAB32F8
	Offset: 0x2698
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function createTeamProgressBarText(team)
{
	text = createServerFontString("default", level.teamProgressBarFontSize, team);
	text setPoint("TOP", undefined, 0, level.teamProgressBarTextY);
	return text;
}

/*
	Name: setFlashFrac
	Namespace: hud
	Checksum: 0xF0C54EBC
	Offset: 0x2710
	Size: 0x1F
	Parameters: 1
	Flags: None
*/
function setFlashFrac(flashFrac)
{
	self.bar.flashFrac = flashFrac;
}

/*
	Name: hideElem
	Namespace: hud
	Checksum: 0x2841263C
	Offset: 0x2738
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function hideElem()
{
	if(self.hidden)
	{
		return;
	}
	self.hidden = 1;
	if(self.alpha != 0)
	{
		self.alpha = 0;
	}
	if(self.elemType == "bar" || self.elemType == "bar_shader")
	{
		self.bar.hidden = 1;
		if(self.bar.alpha != 0)
		{
			self.bar.alpha = 0;
		}
		self.barFrame.hidden = 1;
		if(self.barFrame.alpha != 0)
		{
			self.barFrame.alpha = 0;
		}
	}
}

/*
	Name: showElem
	Namespace: hud
	Checksum: 0x5BB7F40B
	Offset: 0x2818
	Size: 0x107
	Parameters: 0
	Flags: None
*/
function showElem()
{
	if(!self.hidden)
	{
		return;
	}
	self.hidden = 0;
	if(self.elemType == "bar" || self.elemType == "bar_shader")
	{
		if(self.alpha != 0.5)
		{
			self.alpha = 0.5;
		}
		self.bar.hidden = 0;
		if(self.bar.alpha != 1)
		{
			self.bar.alpha = 1;
		}
		self.barFrame.hidden = 0;
		if(self.barFrame.alpha != 1)
		{
			self.barFrame.alpha = 1;
		}
	}
	else if(self.alpha != 1)
	{
		self.alpha = 1;
	}
}

/*
	Name: flashThread
	Namespace: hud
	Checksum: 0x9172B9ED
	Offset: 0x2928
	Size: 0xEF
	Parameters: 0
	Flags: None
*/
function flashThread()
{
	self endon("death");
	if(!self.hidden)
	{
		self.alpha = 1;
	}
	while(1)
	{
		if(self.frac >= self.flashFrac)
		{
			if(!self.hidden)
			{
				self fadeOverTime(0.3);
				self.alpha = 0.2;
				wait(0.35);
				self fadeOverTime(0.3);
				self.alpha = 1;
			}
			wait(0.7);
		}
		else if(!self.hidden && self.alpha != 1)
		{
			self.alpha = 1;
		}
		wait(0.05);
	}
}

/*
	Name: destroyElem
	Namespace: hud
	Checksum: 0xE278F85
	Offset: 0x2A20
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function destroyElem()
{
	tempChildren = [];
	for(index = 0; index < self.children.size; index++)
	{
		if(isdefined(self.children[index]))
		{
			tempChildren[tempChildren.size] = self.children[index];
		}
	}
	for(index = 0; index < tempChildren.size; index++)
	{
		tempChildren[index] setParent(self getParent());
	}
	if(self.elemType == "bar" || self.elemType == "bar_shader")
	{
		self.bar destroy();
		self.barFrame destroy();
	}
	self destroy();
}

/*
	Name: setIconShader
	Namespace: hud
	Checksum: 0x58D979D3
	Offset: 0x2B60
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function setIconShader(shader)
{
	self SetShader(shader, self.width, self.height);
}

/*
	Name: setWidth
	Namespace: hud
	Checksum: 0x9A6E485
	Offset: 0x2BA0
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function setWidth(width)
{
	self.width = width;
}

/*
	Name: setHeight
	Namespace: hud
	Checksum: 0x4299B34
	Offset: 0x2BC0
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function setHeight(height)
{
	self.height = height;
}

/*
	Name: setSize
	Namespace: hud
	Checksum: 0x24809C94
	Offset: 0x2BE0
	Size: 0x2B
	Parameters: 2
	Flags: None
*/
function setSize(width, height)
{
	self.width = width;
	self.height = height;
}

/*
	Name: updateChildren
	Namespace: hud
	Checksum: 0x7816C1EA
	Offset: 0x2C18
	Size: 0x95
	Parameters: 0
	Flags: None
*/
function updateChildren()
{
	for(index = 0; index < self.children.size; index++)
	{
		child = self.children[index];
		child setPoint(child.point, child.relativePoint, child.xOffset, child.yOffset);
	}
}

/*
	Name: createLoadoutIcon
	Namespace: hud
	Checksum: 0x4D45072C
	Offset: 0x2CB8
	Size: 0x13F
	Parameters: 5
	Flags: None
*/
function createLoadoutIcon(player, verIndex, horIndex, xpos, ypos)
{
	iconSize = 32;
	if(player IsSplitscreen())
	{
		iconSize = 22;
	}
	ypos = ypos - 90 + iconSize * 3 - verIndex;
	xpos = xpos - 10 + iconSize * horIndex;
	icon = createIcon("white", iconSize, iconSize);
	icon setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", xpos, ypos);
	icon.horzAlign = "user_right";
	icon.vertAlign = "user_bottom";
	icon.archived = 0;
	icon.foreground = 0;
	return icon;
}

/*
	Name: setLoadoutIconCoords
	Namespace: hud
	Checksum: 0xB22DA31F
	Offset: 0x2E00
	Size: 0x10F
	Parameters: 5
	Flags: None
*/
function setLoadoutIconCoords(player, verIndex, horIndex, xpos, ypos)
{
	iconSize = 32;
	if(player IsSplitscreen())
	{
		iconSize = 22;
	}
	ypos = ypos - 90 + iconSize * 3 - verIndex;
	xpos = xpos - 10 + iconSize * horIndex;
	self setPoint("BOTTOM RIGHT", "BOTTOM RIGHT", xpos, ypos);
	self.horzAlign = "user_right";
	self.vertAlign = "user_bottom";
	self.archived = 0;
	self.foreground = 0;
	self.alpha = 1;
}

/*
	Name: setLoadoutTextCoords
	Namespace: hud
	Checksum: 0x40882419
	Offset: 0x2F18
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function setLoadoutTextCoords(xCoord)
{
	self setPoint("RIGHT", "LEFT", xCoord, 0);
}

/*
	Name: createLoadoutText
	Namespace: hud
	Checksum: 0x15F6A718
	Offset: 0x2F58
	Size: 0xCF
	Parameters: 2
	Flags: None
*/
function createLoadoutText(icon, xCoord)
{
	text = createFontString("small", 1);
	text setParent(icon);
	text setPoint("RIGHT", "LEFT", xCoord, 0);
	text.archived = 0;
	text.alignX = "right";
	text.alignY = "middle";
	text.foreground = 0;
	return text;
}

/*
	Name: showLoadoutAttribute
	Namespace: hud
	Checksum: 0x1EE9DA5F
	Offset: 0x3030
	Size: 0xBB
	Parameters: 5
	Flags: None
*/
function showLoadoutAttribute(iconElem, icon, alpha, textelem, text)
{
	iconSize = 32;
	iconElem.alpha = alpha;
	if(alpha)
	{
		iconElem SetShader(icon, iconSize, iconSize);
	}
	if(isdefined(textelem))
	{
		textelem.alpha = alpha;
		if(alpha)
		{
			textelem setText(text);
		}
	}
}

/*
	Name: hideLoadoutAttribute
	Namespace: hud
	Checksum: 0xBC8A9C53
	Offset: 0x30F8
	Size: 0xC7
	Parameters: 4
	Flags: None
*/
function hideLoadoutAttribute(iconElem, fadetime, textelem, hideTextOnly)
{
	if(isdefined(fadetime))
	{
		if(!isdefined(hideTextOnly) || !hideTextOnly)
		{
			iconElem fadeOverTime(fadetime);
		}
		if(isdefined(textelem))
		{
			textelem fadeOverTime(fadetime);
		}
	}
	if(!isdefined(hideTextOnly) || !hideTextOnly)
	{
		iconElem.alpha = 0;
	}
	if(isdefined(textelem))
	{
		textelem.alpha = 0;
	}
}

/*
	Name: showPerks
	Namespace: hud
	Checksum: 0x62581FB
	Offset: 0x31C8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function showPerks()
{
	self LUINotifyEvent(&"show_perk_notification", 0);
}

/*
	Name: showPerk
	Namespace: hud
	Checksum: 0x6AF53447
	Offset: 0x31F8
	Size: 0x2DB
	Parameters: 3
	Flags: None
*/
function showPerk(index, perk, ypos)
{
	/#
		Assert(game["Dev Block strings are not supported"] != "Dev Block strings are not supported");
	#/
	if(!isdefined(self.perkicon))
	{
		self.perkicon = [];
		self.perkname = [];
	}
	if(!isdefined(self.perkicon[index]))
	{
		/#
			Assert(!isdefined(self.perkname[index]));
		#/
		self.perkicon[index] = createLoadoutIcon(self, index, 0, 200, ypos);
		self.perkname[index] = createLoadoutText(self.perkicon[index], 160);
	}
	else
	{
		self.perkicon[index] setLoadoutIconCoords(self, index, 0, 200, ypos);
		self.perkname[index] setLoadoutTextCoords(160);
	}
	if(perk == "perk_null" || perk == "weapon_null" || perk == "specialty_null")
	{
		alpha = 0;
	}
	else
	{
		Assert(isdefined(level.perkNames[perk]), perk);
		alpha = 1;
	}
	/#
	#/
	showLoadoutAttribute(self.perkicon[index], perk, alpha, self.perkname[index], level.perkNames[perk]);
	self.perkicon[index] MoveOverTime(0.3);
	self.perkicon[index].x = -5;
	self.perkicon[index].hidewheninmenu = 1;
	self.perkname[index] MoveOverTime(0.3);
	self.perkname[index].x = -40;
	self.perkname[index].hidewheninmenu = 1;
}

/*
	Name: hidePerk
	Namespace: hud
	Checksum: 0xC4457C97
	Offset: 0x34E0
	Size: 0x17B
	Parameters: 3
	Flags: None
*/
function hidePerk(index, fadetime, hideTextOnly)
{
	if(!isdefined(fadetime))
	{
		fadetime = 0.05;
	}
	if(level.perksEnabled == 1)
	{
		if(game["state"] == "postgame")
		{
			if(isdefined(self.perkicon))
			{
				/#
					Assert(!isdefined(self.perkicon[index]));
				#/
				/#
					Assert(!isdefined(self.perkname[index]));
				#/
			}
			return;
		}
		/#
			Assert(isdefined(self.perkicon[index]));
		#/
		/#
			Assert(isdefined(self.perkname[index]));
		#/
		if(isdefined(self.perkicon) && isdefined(self.perkicon[index]) && isdefined(self.perkname) && isdefined(self.perkname[index]))
		{
			hideLoadoutAttribute(self.perkicon[index], fadetime, self.perkname[index], hideTextOnly);
		}
	}
}

/*
	Name: showKillstreak
	Namespace: hud
	Checksum: 0xE166C355
	Offset: 0x3668
	Size: 0x15B
	Parameters: 4
	Flags: None
*/
function showKillstreak(index, killstreak, xpos, ypos)
{
	/#
		Assert(game["Dev Block strings are not supported"] != "Dev Block strings are not supported");
	#/
	if(!isdefined(self.killstreakicon))
	{
		self.killstreakicon = [];
	}
	if(!isdefined(self.killstreakicon[index]))
	{
		self.killstreakicon[index] = createLoadoutIcon(self, 3, self.killstreak.size - 1 - index, xpos, ypos);
	}
	if(killstreak == "killstreak_null" || killstreak == "weapon_null")
	{
		alpha = 0;
	}
	else
	{
		Assert(isdefined(level.killStreakIcons[killstreak]), killstreak);
		alpha = 1;
	}
	/#
	#/
	showLoadoutAttribute(self.killstreakicon[index], level.killStreakIcons[killstreak], alpha);
}

/*
	Name: hideKillstreak
	Namespace: hud
	Checksum: 0x4F034ED1
	Offset: 0x37D0
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function hideKillstreak(index, fadetime)
{
	if(util::is_killstreaks_enabled())
	{
		if(game["state"] == "postgame")
		{
			/#
				Assert(!isdefined(self.killstreakicon[index]));
			#/
			return;
		}
		/#
			Assert(isdefined(self.killstreakicon[index]));
		#/
		hideLoadoutAttribute(self.killstreakicon[index], fadetime);
	}
}

/*
	Name: setGamemodeInfoPoint
	Namespace: hud
	Checksum: 0x32844BC2
	Offset: 0x3898
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function setGamemodeInfoPoint()
{
	self.x = 11;
	self.y = 120;
	self.horzAlign = "user_left";
	self.vertAlign = "user_top";
	self.alignX = "left";
	self.alignY = "top";
}

