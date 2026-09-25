#using scripts\shared\util_shared;

#namespace cScriptBundleObjectBase;

/*
	Name: function_9b385ca5
	Namespace: cScriptBundleObjectBase
	Checksum: 0x99EC1590
	Offset: 0xC8
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
	Offset: 0xD8
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
	Checksum: 0x43C9E43A
	Offset: 0xE8
	Size: 0xD7
	Parameters: 4
	Flags: None
*/
function init(s_objdef, o_bundle, e_ent, localClientNum)
{
	self._s = s_objdef;
	self._o_bundle = o_bundle;
	if(isdefined(e_ent))
	{
		/#
			Assert(!isdefined(localClientNum) || e_ent.localClientNum == localClientNum, "Dev Block strings are not supported");
		#/
		self._n_clientnum = e_ent.localClientNum;
		self._e_array[self._n_clientnum] = e_ent;
	}
	else
	{
		self._e_array = [];
		if(isdefined(localClientNum))
		{
			self._n_clientnum = localClientNum;
		}
	}
}

/*
	Name: Log
	Namespace: cScriptBundleObjectBase
	Checksum: 0xB01247DA
	Offset: 0x1C8
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
	Checksum: 0x7646283A
	Offset: 0x290
	Size: 0x11F
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
	Name: get_ent
	Namespace: cScriptBundleObjectBase
	Checksum: 0x9F43D606
	Offset: 0x3B8
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function get_ent(localClientNum)
{
	return self._e_array[localClientNum];
}

#namespace scriptbundle;

/*
	Name: cScriptBundleObjectBase
	Namespace: scriptbundle
	Checksum: 0xAFD6F135
	Offset: 0x3D8
	Size: 0x145
	Parameters: 0
	Flags: 6
*/
function private autoexec cScriptBundleObjectBase()
{
	classes.cScriptBundleObjectBase[0] = spawnstruct();
	classes.cScriptBundleObjectBase[0].__vtable[964891661] = &cScriptBundleObjectBase::get_ent;
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
	Checksum: 0x2FD958C7
	Offset: 0x528
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
	Checksum: 0xAC1989E2
	Offset: 0x540
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
	Offset: 0x568
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
	Checksum: 0xE513F66
	Offset: 0x578
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
	Checksum: 0xC9A13037
	Offset: 0x5C0
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
	Checksum: 0xCD14F293
	Offset: 0x5E0
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
	Checksum: 0xBDFEB2BC
	Offset: 0x5F8
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
	Checksum: 0x72042D02
	Offset: 0x618
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
	Checksum: 0x1B2EC48B
	Offset: 0x638
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
	Checksum: 0x8072093
	Offset: 0x650
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
	Checksum: 0x263AC26F
	Offset: 0x6D8
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
	Checksum: 0xA969E1B3
	Offset: 0x710
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
	Checksum: 0x1D5FC6B9
	Offset: 0x770
	Size: 0x83
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

#namespace scriptbundle;

/*
	Name: cScriptBundleBase
	Namespace: scriptbundle
	Checksum: 0xAA81C32C
	Offset: 0x800
	Size: 0x295
	Parameters: 0
	Flags: 6
*/
function private autoexec cScriptBundleBase()
{
	classes.cScriptBundleBase[0] = spawnstruct();
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
	Checksum: 0x622E9E5E
	Offset: 0xAA0
	Size: 0x14B
	Parameters: 1
	Flags: None
*/
function error_on_screen(str_msg)
{
	if(str_msg != "")
	{
		if(!isdefined(level.scene_error_hud))
		{
			level.scene_error_hud = CreateLUIMenu(0, "HudElementText");
			SetLUIMenuData(0, level.scene_error_hud, "alignment", 1);
			SetLUIMenuData(0, level.scene_error_hud, "x", 0);
			SetLUIMenuData(0, level.scene_error_hud, "y", 10);
			SetLUIMenuData(0, level.scene_error_hud, "width", 1920);
			OpenLUIMenu(0, level.scene_error_hud);
		}
		SetLUIMenuData(0, level.scene_error_hud, "text", str_msg);
		self thread _destroy_error_on_screen();
	}
}

/*
	Name: _destroy_error_on_screen
	Namespace: scriptbundle
	Checksum: 0xC8B25732
	Offset: 0xBF8
	Size: 0x65
	Parameters: 0
	Flags: None
*/
function _destroy_error_on_screen()
{
	level notify("_destroy_error_on_screen");
	level endon("_destroy_error_on_screen");
	self util::waittill_notify_or_timeout("stopped", 5);
	CloseLUIMenu(0, level.scene_error_hud);
	level.scene_error_hud = undefined;
}

