#using scripts\codescripts\struct;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

#namespace debug_menu;

/*
	Name: open
	Namespace: debug_menu
	Checksum: 0xDA27FA8C
	Offset: 0x138
	Size: 0xC3
	Parameters: 2
	Flags: None
*/
function open(localClientNum, a_menu_items)
{
	close(localClientNum);
	level flagsys::set("menu_open");
	PopulateScriptDebugMenu(localClientNum, a_menu_items);
	LuiLoad("uieditor.menus.ScriptDebugMenu");
	level.scriptDebugMenu = CreateLUIMenu(localClientNum, "ScriptDebugMenu");
	OpenLUIMenu(localClientNum, level.scriptDebugMenu);
}

/*
	Name: close
	Namespace: debug_menu
	Checksum: 0x1625BACB
	Offset: 0x208
	Size: 0x5D
	Parameters: 1
	Flags: None
*/
function close(localClientNum)
{
	level flagsys::clear("menu_open");
	if(isdefined(level.scriptDebugMenu))
	{
		CloseLUIMenu(localClientNum, level.scriptDebugMenu);
		level.scriptDebugMenu = undefined;
	}
}

/*
	Name: set_item_text
	Namespace: debug_menu
	Checksum: 0xCCAC289
	Offset: 0x270
	Size: 0xB3
	Parameters: 3
	Flags: None
*/
function set_item_text(localClientNum, index, name)
{
	controllerModel = GetUIModelForController(localClientNum);
	parentModel = GetUIModel(controllerModel, "cscDebugMenu.listItem" + index);
	model = GetUIModel(parentModel, "name");
	SetUIModelValue(model, name);
}

/*
	Name: set_item_color
	Namespace: debug_menu
	Checksum: 0x7E599460
	Offset: 0x330
	Size: 0x11B
	Parameters: 3
	Flags: None
*/
function set_item_color(localClientNum, index, color)
{
	controllerModel = GetUIModelForController(localClientNum);
	parentModel = GetUIModel(controllerModel, "cscDebugMenu.listItem" + index);
	model = GetUIModel(parentModel, "color");
	if(IsVec(color))
	{
		color = "" + color[0] * 255 + " " + color[1] * 255 + " " + color[2] * 255;
	}
	SetUIModelValue(model, color);
}

