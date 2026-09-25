#using scripts\shared\scene_shared;

#namespace struct;

/*
	Name: __init__
	Namespace: struct
	Checksum: 0x7DA99B52
	Offset: 0x170
	Size: 0x23
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__()
{
	if(!isdefined(level.struct))
	{
		init_structs();
	}
}

/*
	Name: init_structs
	Namespace: struct
	Checksum: 0x98B4DD06
	Offset: 0x1A0
	Size: 0xE9
	Parameters: 0
	Flags: None
*/
function init_structs()
{
	level.struct = [];
	level.scriptbundles = [];
	level.var_570603 = [];
	level.struct_class_names = [];
	level.struct_class_names["target"] = [];
	level.struct_class_names["targetname"] = [];
	level.struct_class_names["script_noteworthy"] = [];
	level.struct_class_names["script_linkname"] = [];
	level.struct_class_names["script_label"] = [];
	level.struct_class_names["classname"] = [];
	level.struct_class_names["script_unitrigger_type"] = [];
	level.struct_class_names["scriptbundlename"] = [];
	level.struct_class_names["prefabname"] = [];
}

/*
	Name: function_aa4875d1
	Namespace: struct
	Checksum: 0x198D4C90
	Offset: 0x298
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function function_aa4875d1(struct)
{
	struct.var_5aabff8a = undefined;
	struct.var_eb4e79c2 = undefined;
	/#
		var_d9d1ca59 = struct.var_d9d1ca59;
	#/
	struct.var_d9d1ca59 = undefined;
	/#
		struct.var_d9d1ca59 = var_d9d1ca59;
	#/
}

/*
	Name: CreateStruct
	Namespace: struct
	Checksum: 0xA9EFCA9E
	Offset: 0x308
	Size: 0x1FB
	Parameters: 3
	Flags: None
*/
function CreateStruct(struct, type, name)
{
	if(!isdefined(level.struct))
	{
		init_structs();
	}
	if(isdefined(type))
	{
		var_d64c42bd = GetDvarString("mapname") == "core_frontend";
		if(!isdefined(level.scriptbundles[type]))
		{
			level.scriptbundles[type] = [];
		}
		if(isdefined(level.scriptbundles[type][name]))
		{
			return level.scriptbundles[type][name];
		}
		if(type == "scene")
		{
			level.scriptbundles[type][name] = scene::remove_invalid_scene_objects(struct);
		}
		else if(!SessionModeIsMultiplayerGame() || var_d64c42bd && type == "mpdialog_player")
		{
		}
		else if(!SessionModeIsMultiplayerGame() || var_d64c42bd && type == "gibcharacterdef" && IsSubStr(name, "c_t7_mp_"))
		{
		}
		else if(!SessionModeIsCampaignGame() || var_d64c42bd && type == "collectibles")
		{
		}
		else
		{
			level.scriptbundles[type][name] = struct;
		}
		function_aa4875d1(struct);
	}
	else
	{
		struct init();
	}
}

/*
	Name: function_f3b581d0
	Namespace: struct
	Checksum: 0xAF40FD54
	Offset: 0x510
	Size: 0x53
	Parameters: 3
	Flags: None
*/
function function_f3b581d0(items, var_1578b6b3, name)
{
	if(!isdefined(level.struct))
	{
		init_structs();
	}
	level.var_570603[var_1578b6b3][name] = items;
}

/*
	Name: init
	Namespace: struct
	Checksum: 0xAA77F2F9
	Offset: 0x570
	Size: 0x93D
	Parameters: 0
	Flags: None
*/
function init()
{
	if(!isdefined(level.struct))
	{
		level.struct = [];
	}
	else if(!IsArray(level.struct))
	{
		level.struct = Array(level.struct);
	}
	level.struct[level.struct.size] = self;
	if(!isdefined(self.angles))
	{
		self.angles = (0, 0, 0);
	}
	if(isdefined(self.targetname))
	{
		if(!isdefined(level.struct_class_names["targetname"][self.targetname]))
		{
			level.struct_class_names["targetname"][self.targetname] = [];
		}
		else if(!IsArray(level.struct_class_names["targetname"][self.targetname]))
		{
			level.struct_class_names["targetname"][self.targetname] = Array(level.struct_class_names["targetname"][self.targetname]);
		}
		level.struct_class_names["targetname"][self.targetname][level.struct_class_names["targetname"][self.targetname].size] = self;
	}
	if(isdefined(self.target))
	{
		if(!isdefined(level.struct_class_names["target"][self.target]))
		{
			level.struct_class_names["target"][self.target] = [];
		}
		else if(!IsArray(level.struct_class_names["target"][self.target]))
		{
			level.struct_class_names["target"][self.target] = Array(level.struct_class_names["target"][self.target]);
		}
		level.struct_class_names["target"][self.target][level.struct_class_names["target"][self.target].size] = self;
	}
	if(isdefined(self.script_noteworthy))
	{
		if(!isdefined(level.struct_class_names["script_noteworthy"][self.script_noteworthy]))
		{
			level.struct_class_names["script_noteworthy"][self.script_noteworthy] = [];
		}
		else if(!IsArray(level.struct_class_names["script_noteworthy"][self.script_noteworthy]))
		{
			level.struct_class_names["script_noteworthy"][self.script_noteworthy] = Array(level.struct_class_names["script_noteworthy"][self.script_noteworthy]);
		}
		level.struct_class_names["script_noteworthy"][self.script_noteworthy][level.struct_class_names["script_noteworthy"][self.script_noteworthy].size] = self;
	}
	if(isdefined(self.script_linkname))
	{
		/#
			Assert(!isdefined(level.struct_class_names["Dev Block strings are not supported"][self.script_linkname]), "Dev Block strings are not supported");
		#/
		level.struct_class_names["script_linkname"][self.script_linkname][0] = self;
	}
	if(isdefined(self.script_label))
	{
		if(!isdefined(level.struct_class_names["script_label"][self.script_label]))
		{
			level.struct_class_names["script_label"][self.script_label] = [];
		}
		else if(!IsArray(level.struct_class_names["script_label"][self.script_label]))
		{
			level.struct_class_names["script_label"][self.script_label] = Array(level.struct_class_names["script_label"][self.script_label]);
		}
		level.struct_class_names["script_label"][self.script_label][level.struct_class_names["script_label"][self.script_label].size] = self;
	}
	if(isdefined(self.classname))
	{
		if(!isdefined(level.struct_class_names["classname"][self.classname]))
		{
			level.struct_class_names["classname"][self.classname] = [];
		}
		else if(!IsArray(level.struct_class_names["classname"][self.classname]))
		{
			level.struct_class_names["classname"][self.classname] = Array(level.struct_class_names["classname"][self.classname]);
		}
		level.struct_class_names["classname"][self.classname][level.struct_class_names["classname"][self.classname].size] = self;
	}
	if(isdefined(self.script_unitrigger_type))
	{
		if(!isdefined(level.struct_class_names["script_unitrigger_type"][self.script_unitrigger_type]))
		{
			level.struct_class_names["script_unitrigger_type"][self.script_unitrigger_type] = [];
		}
		else if(!IsArray(level.struct_class_names["script_unitrigger_type"][self.script_unitrigger_type]))
		{
			level.struct_class_names["script_unitrigger_type"][self.script_unitrigger_type] = Array(level.struct_class_names["script_unitrigger_type"][self.script_unitrigger_type]);
		}
		level.struct_class_names["script_unitrigger_type"][self.script_unitrigger_type][level.struct_class_names["script_unitrigger_type"][self.script_unitrigger_type].size] = self;
	}
	if(isdefined(self.scriptbundlename))
	{
		if(!isdefined(level.struct_class_names["scriptbundlename"][self.scriptbundlename]))
		{
			level.struct_class_names["scriptbundlename"][self.scriptbundlename] = [];
		}
		else if(!IsArray(level.struct_class_names["scriptbundlename"][self.scriptbundlename]))
		{
			level.struct_class_names["scriptbundlename"][self.scriptbundlename] = Array(level.struct_class_names["scriptbundlename"][self.scriptbundlename]);
		}
		level.struct_class_names["scriptbundlename"][self.scriptbundlename][level.struct_class_names["scriptbundlename"][self.scriptbundlename].size] = self;
	}
	if(isdefined(self.var_47c44e16))
	{
		if(!isdefined(level.struct_class_names["prefabname"][self.var_47c44e16]))
		{
			level.struct_class_names["prefabname"][self.var_47c44e16] = [];
		}
		else if(!IsArray(level.struct_class_names["prefabname"][self.var_47c44e16]))
		{
			level.struct_class_names["prefabname"][self.var_47c44e16] = Array(level.struct_class_names["prefabname"][self.var_47c44e16]);
		}
		level.struct_class_names["prefabname"][self.var_47c44e16][level.struct_class_names["prefabname"][self.var_47c44e16].size] = self;
	}
}

/*
	Name: get
	Namespace: struct
	Checksum: 0xF9CFB9
	Offset: 0xEB8
	Size: 0xD1
	Parameters: 2
	Flags: None
*/
function get(kvp_value, kvp_key)
{
	if(!isdefined(kvp_key))
	{
		kvp_key = "targetname";
	}
	if(isdefined(level.struct_class_names[kvp_key]) && isdefined(level.struct_class_names[kvp_key][kvp_value]))
	{
		/#
			if(level.struct_class_names[kvp_key][kvp_value].size > 1)
			{
				/#
					ASSERTMSG("Dev Block strings are not supported" + kvp_key + "Dev Block strings are not supported" + kvp_value + "Dev Block strings are not supported");
				#/
				return undefined;
			}
		#/
		return level.struct_class_names[kvp_key][kvp_value][0];
	}
}

/*
	Name: spawn
	Namespace: struct
	Checksum: 0x6F176828
	Offset: 0xF98
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function spawn(v_origin, v_angles)
{
	if(!isdefined(v_origin))
	{
		v_origin = (0, 0, 0);
	}
	if(!isdefined(v_angles))
	{
		v_angles = (0, 0, 0);
	}
	s = spawnstruct();
	s.origin = v_origin;
	s.angles = v_angles;
	return s;
}

/*
	Name: get_array
	Namespace: struct
	Checksum: 0x31B74458
	Offset: 0x1028
	Size: 0x6D
	Parameters: 2
	Flags: None
*/
function get_array(kvp_value, kvp_key)
{
	if(!isdefined(kvp_key))
	{
		kvp_key = "targetname";
	}
	if(isdefined(level.struct_class_names[kvp_key][kvp_value]))
	{
		return ArrayCopy(level.struct_class_names[kvp_key][kvp_value]);
	}
	return [];
}

/*
	Name: delete
	Namespace: struct
	Checksum: 0x75BCE4B5
	Offset: 0x10A0
	Size: 0x1FB
	Parameters: 0
	Flags: None
*/
function delete()
{
	if(isdefined(self.target))
	{
		ArrayRemoveValue(level.struct_class_names["target"][self.target], self);
	}
	if(isdefined(self.targetname))
	{
		ArrayRemoveValue(level.struct_class_names["targetname"][self.targetname], self);
	}
	if(isdefined(self.script_noteworthy))
	{
		ArrayRemoveValue(level.struct_class_names["script_noteworthy"][self.script_noteworthy], self);
	}
	if(isdefined(self.script_linkname))
	{
		ArrayRemoveValue(level.struct_class_names["script_linkname"][self.script_linkname], self);
	}
	if(isdefined(self.script_label))
	{
		ArrayRemoveValue(level.struct_class_names["script_label"][self.script_label], self);
	}
	if(isdefined(self.classname))
	{
		ArrayRemoveValue(level.struct_class_names["classname"][self.classname], self);
	}
	if(isdefined(self.script_unitrigger_type))
	{
		ArrayRemoveValue(level.struct_class_names["script_unitrigger_type"][self.script_unitrigger_type], self);
	}
	if(isdefined(self.scriptbundlename))
	{
		ArrayRemoveValue(level.struct_class_names["scriptbundlename"][self.scriptbundlename], self);
	}
	if(isdefined(self.var_47c44e16))
	{
		ArrayRemoveValue(level.struct_class_names["prefabname"][self.var_47c44e16], self);
	}
}

/*
	Name: get_script_bundle
	Namespace: struct
	Checksum: 0xF37A50F0
	Offset: 0x12A8
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function get_script_bundle(str_type, str_name)
{
	if(isdefined(level.scriptbundles[str_type]) && isdefined(level.scriptbundles[str_type][str_name]))
	{
		return level.scriptbundles[str_type][str_name];
	}
}

/*
	Name: delete_script_bundle
	Namespace: struct
	Checksum: 0x8F5993BA
	Offset: 0x1308
	Size: 0x51
	Parameters: 2
	Flags: None
*/
function delete_script_bundle(str_type, str_name)
{
	if(isdefined(level.scriptbundles[str_type]) && isdefined(level.scriptbundles[str_type][str_name]))
	{
		level.scriptbundles[str_type][str_name] = undefined;
	}
}

/*
	Name: get_script_bundles
	Namespace: struct
	Checksum: 0xACD6EAEB
	Offset: 0x1368
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function get_script_bundles(str_type)
{
	if(isdefined(level.scriptbundles) && isdefined(level.scriptbundles[str_type]))
	{
		return level.scriptbundles[str_type];
	}
	return [];
}

/*
	Name: get_script_bundle_list
	Namespace: struct
	Checksum: 0x6E491D6
	Offset: 0x13B0
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function get_script_bundle_list(str_type, str_name)
{
	if(isdefined(level.var_570603[str_type]) && isdefined(level.var_570603[str_type][str_name]))
	{
		return level.var_570603[str_type][str_name];
	}
}

/*
	Name: get_script_bundle_instances
	Namespace: struct
	Checksum: 0x817C52F3
	Offset: 0x1410
	Size: 0x115
	Parameters: 2
	Flags: None
*/
function get_script_bundle_instances(str_type, str_name)
{
	if(!isdefined(str_name))
	{
		str_name = "";
	}
	a_instances = get_array("scriptbundle_" + str_type, "classname");
	if(str_name != "")
	{
		foreach(s_instance in a_instances)
		{
			if(s_instance.name != str_name)
			{
				ArrayRemoveIndex(a_instances, i, 1);
			}
		}
	}
	return a_instances;
}

/*
	Name: FindStruct
	Namespace: struct
	Checksum: 0x404B2231
	Offset: 0x1530
	Size: 0x313
	Parameters: 3
	Flags: None
*/
function FindStruct(param1, name, index)
{
	if(IsVec(param1))
	{
		position = param1;
		foreach(_ in level.struct_class_names)
		{
			foreach(s_array in level.struct_class_names[key])
			{
				foreach(struct in s_array)
				{
					if(DistanceSquared(struct.origin, position) < 1)
					{
						return struct;
					}
				}
			}
		}
		if(isdefined(level.struct))
		{
			foreach(struct in level.struct)
			{
				if(DistanceSquared(struct.origin, position) < 1)
				{
					return struct;
				}
			}
		}
	}
	else
	{
		s = get(param1);
		if(isdefined(s))
		{
			return s;
		}
		s = get_script_bundle(param1, name);
		if(isdefined(s))
		{
			if(index < 0)
			{
				return s;
			}
			else if(isdefined(s.objects))
			{
				return s.objects[index];
			}
		}
	}
	return undefined;
}

