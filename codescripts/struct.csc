#using scripts\shared\scene_shared;

#namespace struct;

/*
	Name: __init__
	Namespace: struct
	Checksum: 0xA3ED084
	Offset: 0x168
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
	Checksum: 0xA9C54487
	Offset: 0x198
	Size: 0xD5
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
}

/*
	Name: function_aa4875d1
	Namespace: struct
	Checksum: 0x81604F94
	Offset: 0x278
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
	Checksum: 0x28D0AD9A
	Offset: 0x2E8
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
	Checksum: 0x4AB77E1E
	Offset: 0x4F0
	Size: 0x53
	Parameters: 3
	Flags: None
*/
function function_f3b581d0(items, type, name)
{
	if(!isdefined(level.struct))
	{
		init_structs();
	}
	level.var_570603[type][name] = items;
}

/*
	Name: init
	Namespace: struct
	Checksum: 0xE33582D4
	Offset: 0x550
	Size: 0x835
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
}

/*
	Name: get
	Namespace: struct
	Checksum: 0x486B83BF
	Offset: 0xD90
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
	if(!isdefined(kvp_value))
	{
		return undefined;
	}
	if(isdefined(level.struct_class_names[kvp_key][kvp_value]))
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
	Checksum: 0xD8BE9110
	Offset: 0xE70
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
	Checksum: 0x52BECA9F
	Offset: 0xF00
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
	Checksum: 0x8F8E1478
	Offset: 0xF78
	Size: 0x1C3
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
}

/*
	Name: get_script_bundle
	Namespace: struct
	Checksum: 0x579F1CB1
	Offset: 0x1148
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
	Checksum: 0x21A23AC7
	Offset: 0x11A8
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
	Name: get_script_bundles_of_type
	Namespace: struct
	Checksum: 0x9809255C
	Offset: 0x1208
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function get_script_bundles_of_type(str_type)
{
	if(isdefined(level.scriptbundles[str_type]))
	{
		return ArrayCopy(level.scriptbundles[str_type]);
	}
}

/*
	Name: get_script_bundles
	Namespace: struct
	Checksum: 0x7C2C8DDC
	Offset: 0x1250
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
	Checksum: 0x9A4C7A6D
	Offset: 0x1298
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
	Checksum: 0xC8B04F65
	Offset: 0x12F8
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
	Checksum: 0x25760073
	Offset: 0x1418
	Size: 0x239
	Parameters: 1
	Flags: None
*/
function FindStruct(position)
{
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
	return undefined;
}

