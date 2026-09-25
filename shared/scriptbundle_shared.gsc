#using scripts\shared\lui_shared;
#using scripts\shared\util_shared;

#namespace cScriptBundleObjectBase;

/*
	Name: function_9b385ca5
	Namespace: cScriptBundleObjectBase
	Checksum: 0x99EC1590
	Offset: 0x100
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
}

/*
	Name: function_5fba2032
	Namespace: cScriptBundleObjectBase
	Checksum: 0x99EC1590
	Offset: 0x110
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

/*
	Name: init
	Namespace: cScriptBundleObjectBase
	Checksum: 0x5844D1C3
	Offset: 0x120
	Size: 0x3F
	Parameters: 3
	Flags: None
*/
function init(s_objdef, o_bundle, e_ent)
{
	self._s = s_objdef;
	self._o_bundle = o_bundle;
	self._e = e_ent;
}

/*
	Name: Log
	Namespace: cScriptBundleObjectBase
	Checksum: 0xFB9CA0A7
	Offset: 0x168
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function Log(str_msg)
{
	/#
		if(isdefined(self._s.name))
		{
		}
		else if(isdefined("Dev Block strings are not supported"))
		{
		}
		else
		{
		}
		println("Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + str_msg);
	#/
}

/*
	Name: error
	Namespace: cScriptBundleObjectBase
	Checksum: 0x8F30BEF4
	Offset: 0x230
	Size: 0x10F
	Parameters: 2
	Flags: None
*/
function error()
{
System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.⁪‏⁭‬‍‬‬⁯‌​‬⁫⁭‮⁬‭​‮⁬​⁫‌‪‬⁫‏⁬‍⁬‪‍​‌‍⁬‍‮⁮‪‎‮()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: warning
	Namespace: cScriptBundleObjectBase
	Checksum: 0xEF96D976
	Offset: 0x348
	Size: 0xC3
	Parameters: 2
	Flags: None
*/
function warning(condition, str_msg)
{
	if(condition)
	{
		if(isdefined(self._s.name))
		{
		}
		else if(isdefined("no name"))
		{
		}
		else
		{
		}
		str_msg = "" + "no name" + "" + ": " + str_msg;
		scriptbundle::warning_on_screen(str_msg);
		return 1;
	}
	return 0;
}

/*
	Name: get_ent
	Namespace: cScriptBundleObjectBase
	Checksum: 0x54798668
	Offset: 0x418
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_ent()
{
	return self._e;
}

#namespace scriptbundle;

/*
	Name: cScriptBundleObjectBase
	Namespace: scriptbundle
	Checksum: 0x5E939D39
	Offset: 0x430
	Size: 0x175
	Parameters: 0
	Flags: 6
*/
function private autoexec cScriptBundleObjectBase()
{
	classes.cScriptBundleObjectBase[0] = spawnstruct();
	classes.cScriptBundleObjectBase[0].__vtable[964891661] = &cScriptBundleObjectBase::get_ent;
	classes.cScriptBundleObjectBase[0].__vtable[-162565429] = &cScriptBundleObjectBase::warning;
	classes.cScriptBundleObjectBase[0].__vtable[-32002227] = &cScriptBundleObjectBase::error;
	classes.cScriptBundleObjectBase[0].__vtable[1621988813] = &cScriptBundleObjectBase::Log;
	classes.cScriptBundleObjectBase[0].__vtable[-1017222485] = &cScriptBundleObjectBase::init;
	classes.cScriptBundleObjectBase[0].__vtable[1606033458] = &cScriptBundleObjectBase::function_5fba2032;
	classes.cScriptBundleObjectBase[0].__vtable[-1690805083] = &cScriptBundleObjectBase::function_9b385ca5;
}

#namespace cScriptBundleBase;

/*
	Name: on_error
	Namespace: cScriptBundleBase
	Checksum: 0x67ED96C9
	Offset: 0x5B0
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function on_error(e)
{
}

/*
	Name: function_9b385ca5
	Namespace: cScriptBundleBase
	Checksum: 0x6DE21345
	Offset: 0x5C8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
	self._a_objects = [];
	self._testing = 0;
}

/*
	Name: function_5fba2032
	Namespace: cScriptBundleBase
	Checksum: 0x99EC1590
	Offset: 0x5F0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

/*
	Name: init
	Namespace: cScriptBundleBase
	Checksum: 0xECFF8071
	Offset: 0x600
	Size: 0x3F
	Parameters: 3
	Flags: None
*/
function init(str_name, s, b_testing)
{
	self._s = s;
	self._str_name = str_name;
	self._testing = b_testing;
}

/*
	Name: get_type
	Namespace: cScriptBundleBase
	Checksum: 0x63864013
	Offset: 0x648
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function get_type()
{
	return self._s.type;
}

/*
	Name: get_name
	Namespace: cScriptBundleBase
	Checksum: 0x3E31FF60
	Offset: 0x668
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_name()
{
	return self._str_name;
}

/*
	Name: get_vm
	Namespace: cScriptBundleBase
	Checksum: 0xC521A181
	Offset: 0x680
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function get_vm()
{
	return self._s.vmtype;
}

/*
	Name: get_objects
	Namespace: cScriptBundleBase
	Checksum: 0xD36AB5BC
	Offset: 0x6A0
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function get_objects()
{
	return self._s.objects;
}

/*
	Name: is_testing
	Namespace: cScriptBundleBase
	Checksum: 0x4394C8E9
	Offset: 0x6C0
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function is_testing()
{
	return self._testing;
}

/*
	Name: add_object
	Namespace: cScriptBundleBase
	Checksum: 0x394EAE86
	Offset: 0x6D8
	Size: 0x79
	Parameters: 1
	Flags: None
*/
function add_object(o_object)
{
	if(!isdefined(self._a_objects))
	{
		self._a_objects = [];
	}
	else if(!IsArray(self._a_objects))
	{
		self._a_objects = Array(self._a_objects);
	}
	self._a_objects[self._a_objects.size] = o_object;
}

/*
	Name: remove_object
	Namespace: cScriptBundleBase
	Checksum: 0x6F4CF57E
	Offset: 0x760
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function remove_object(o_object)
{
	ArrayRemoveValue(self._a_objects, o_object);
}

/*
	Name: Log
	Namespace: cScriptBundleBase
	Checksum: 0x76DBFEE2
	Offset: 0x798
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function Log(str_msg)
{
	/#
		println(self._s.type + "Dev Block strings are not supported" + self._str_name + "Dev Block strings are not supported" + str_msg);
	#/
}

/*
	Name: error
	Namespace: cScriptBundleBase
	Checksum: 0x109A92D7
	Offset: 0x7F8
	Size: 0x9B
	Parameters: 2
	Flags: None
*/
function error()
{
System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.⁪‏⁭‬‍‬‬⁯‌​‬⁫⁭‮⁬‭​‮⁬​⁫‌‪‬⁫‏⁬‍⁬‪‍​‌‍⁬‍‮⁮‪‎‮()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: warning
	Namespace: cScriptBundleBase
	Checksum: 0x6ED1FA83
	Offset: 0x8A0
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function warning(condition, str_msg)
{
	if(condition)
	{
		if(self._testing)
		{
			scriptbundle::warning_on_screen("[ " + self._str_name + " ]: " + str_msg);
		}
		return 1;
	}
	return 0;
}

#namespace scriptbundle;

/*
	Name: cScriptBundleBase
	Namespace: scriptbundle
	Checksum: 0x48FD85CE
	Offset: 0x908
	Size: 0x2C5
	Parameters: 0
	Flags: 6
*/
function private autoexec cScriptBundleBase()
{
	classes.cScriptBundleBase[0] = spawnstruct();
	classes.cScriptBundleBase[0].__vtable[-162565429] = &cScriptBundleBase::warning;
	classes.cScriptBundleBase[0].__vtable[-32002227] = &cScriptBundleBase::error;
	classes.cScriptBundleBase[0].__vtable[1621988813] = &cScriptBundleBase::Log;
	classes.cScriptBundleBase[0].__vtable[713694985] = &cScriptBundleBase::remove_object;
	classes.cScriptBundleBase[0].__vtable[178798596] = &cScriptBundleBase::add_object;
	classes.cScriptBundleBase[0].__vtable[1440274456] = &cScriptBundleBase::is_testing;
	classes.cScriptBundleBase[0].__vtable[-512051494] = &cScriptBundleBase::get_objects;
	classes.cScriptBundleBase[0].__vtable[575565049] = &cScriptBundleBase::get_vm;
	classes.cScriptBundleBase[0].__vtable[245263499] = &cScriptBundleBase::get_name;
	classes.cScriptBundleBase[0].__vtable[1872615990] = &cScriptBundleBase::get_type;
	classes.cScriptBundleBase[0].__vtable[-1017222485] = &cScriptBundleBase::init;
	classes.cScriptBundleBase[0].__vtable[1606033458] = &cScriptBundleBase::function_5fba2032;
	classes.cScriptBundleBase[0].__vtable[-1690805083] = &cScriptBundleBase::function_9b385ca5;
	classes.cScriptBundleBase[0].__vtable[-498584435] = &cScriptBundleBase::on_error;
}

/*
	Name: error_on_screen
	Namespace: scriptbundle
	Checksum: 0xBF45821F
	Offset: 0xBD8
	Size: 0x183
	Parameters: 1
	Flags: None
*/
function error_on_screen(str_msg)
{
	if(str_msg != "")
	{
		if(!isdefined(level.scene_error_hud))
		{
			level.scene_error_hud = level.players[0] OpenLUIMenu("HudElementText");
			level.players[0] SetLUIMenuData(level.scene_error_hud, "alignment", 2);
			level.players[0] SetLUIMenuData(level.scene_error_hud, "x", 0);
			level.players[0] SetLUIMenuData(level.scene_error_hud, "y", 10);
			level.players[0] SetLUIMenuData(level.scene_error_hud, "width", 1280);
			level.players[0] LUI::set_color(level.scene_error_hud, (1, 0, 0));
		}
		level.players[0] SetLUIMenuData(level.scene_error_hud, "text", str_msg);
		self thread _destroy_error_on_screen();
	}
}

/*
	Name: _destroy_error_on_screen
	Namespace: scriptbundle
	Checksum: 0x1005FCA8
	Offset: 0xD68
	Size: 0x6D
	Parameters: 0
	Flags: None
*/
function _destroy_error_on_screen()
{
	level notify("_destroy_error_on_screen");
	level endon("_destroy_error_on_screen");
	self util::waittill_notify_or_timeout("stopped", 5);
	level.players[0] CloseLUIMenu(level.scene_error_hud);
	level.scene_error_hud = undefined;
}

/*
	Name: warning_on_screen
	Namespace: scriptbundle
	Checksum: 0x6A7DD4E6
	Offset: 0xDE0
	Size: 0x18B
	Parameters: 1
	Flags: None
*/
function warning_on_screen(str_msg)
{
	/#
		if(str_msg != "Dev Block strings are not supported")
		{
			if(!isdefined(level.scene_warning_hud))
			{
				level.scene_warning_hud = level.players[0] OpenLUIMenu("Dev Block strings are not supported");
				level.players[0] SetLUIMenuData(level.scene_warning_hud, "Dev Block strings are not supported", 2);
				level.players[0] SetLUIMenuData(level.scene_warning_hud, "Dev Block strings are not supported", 0);
				level.players[0] SetLUIMenuData(level.scene_warning_hud, "Dev Block strings are not supported", 1060);
				level.players[0] SetLUIMenuData(level.scene_warning_hud, "Dev Block strings are not supported", 1280);
				level.players[0] LUI::set_color(level.scene_warning_hud, (1, 1, 0));
			}
			level.players[0] SetLUIMenuData(level.scene_warning_hud, "Dev Block strings are not supported", str_msg);
			self thread _destroy_warning_on_screen();
		}
	#/
}

/*
	Name: _destroy_warning_on_screen
	Namespace: scriptbundle
	Checksum: 0xEF4B6A8F
	Offset: 0xF78
	Size: 0x6D
	Parameters: 0
	Flags: None
*/
function _destroy_warning_on_screen()
{
	level notify("_destroy_warning_on_screen");
	level endon("_destroy_warning_on_screen");
	self util::waittill_notify_or_timeout("stopped", 10);
	level.players[0] CloseLUIMenu(level.scene_warning_hud);
	level.scene_warning_hud = undefined;
}

