#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace duplicate_render;

/*
	Name: __init__sytem__
	Namespace: duplicate_render
	Checksum: 0x497C2333
	Offset: 0x4D0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("duplicate_render", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: duplicate_render
	Checksum: 0xC3C65DE2
	Offset: 0x510
	Size: 0x53B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!isdefined(level.drfilters))
	{
		level.drfilters = [];
	}
	callback::on_spawned(&on_player_spawned);
	callback::on_localclient_connect(&on_player_connect);
	set_dr_filter_framebuffer("none_fb", 0, undefined, undefined, 0, 1, 0);
	set_dr_filter_framebuffer_duplicate("none_fbd", 0, undefined, undefined, 1, 0, 0);
	set_dr_filter_offscreen("none_os", 0, undefined, undefined, 2, 0, 0);
	set_dr_filter_framebuffer("enveh_fb", 8, "enemyvehicle_fb", undefined, 0, 4, 1);
	set_dr_filter_framebuffer("frveh_fb", 8, "friendlyvehicle_fb", undefined, 0, 1, 1);
	set_dr_filter_offscreen("retrv", 5, "retrievable", undefined, 2, "mc/hud_keyline_retrievable", 1);
	set_dr_filter_offscreen("unplc", 7, "unplaceable", undefined, 2, "mc/hud_keyline_unplaceable", 1);
	set_dr_filter_offscreen("eneqp", 8, "enemyequip", undefined, 2, "mc/hud_outline_rim", 1);
	set_dr_filter_offscreen("enexp", 8, "enemyexplo", undefined, 2, "mc/hud_outline_rim", 1);
	set_dr_filter_offscreen("enveh", 8, "enemyvehicle", undefined, 2, "mc/hud_outline_rim", 1);
	set_dr_filter_offscreen("freqp", 8, "friendlyequip", undefined, 2, "mc/hud_keyline_friendlyequip", 1);
	set_dr_filter_offscreen("frexp", 8, "friendlyexplo", undefined, 2, "mc/hud_keyline_friendlyequip", 1);
	set_dr_filter_offscreen("frveh", 8, "friendlyvehicle", undefined, 2, "mc/hud_keyline_friendlyequip", 1);
	set_dr_filter_offscreen("infrared", 9, "infrared_entity", undefined, 2, 2, 1);
	set_dr_filter_offscreen("threat_detector_enemy", 10, "threat_detector_enemy", undefined, 2, "mc/hud_keyline_enemyequip", 1);
	set_dr_filter_offscreen("hthacked", 5, "hacker_tool_hacked", undefined, 2, "mc/mtl_hacker_tool_hacked", 1);
	set_dr_filter_offscreen("hthacking", 5, "hacker_tool_hacking", undefined, 2, "mc/mtl_hacker_tool_hacking", 1);
	set_dr_filter_offscreen("htbreaching", 5, "hacker_tool_breaching", undefined, 2, "mc/mtl_hacker_tool_breaching", 1);
	set_dr_filter_offscreen("bcarrier", 9, "ballcarrier", undefined, 2, "mc/hud_keyline_friendlyequip", 1);
	set_dr_filter_offscreen("poption", 9, "passoption", undefined, 2, "mc/hud_keyline_friendlyequip", 1);
	set_dr_filter_offscreen("prop_look_through", 9, "prop_look_through", undefined, 2, "mc/hud_keyline_friendlyequip", 1);
	set_dr_filter_offscreen("prop_ally", 8, "prop_ally", undefined, 2, "mc/hud_keyline_friendlyequip", 1);
	set_dr_filter_offscreen("prop_clone", 7, "prop_clone", undefined, 2, "mc/hud_keyline_ph_yellow", 1);
	level.friendlyContentOutlines = GetDvarInt("friendlyContentOutlines", 0);
}

/*
	Name: on_player_spawned
	Namespace: duplicate_render
	Checksum: 0xB8BC233
	Offset: 0xA58
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function on_player_spawned(local_client_num)
{
	self.currentdrfilter = [];
	self change_dr_flags(local_client_num);
	if(!level flagsys::get("duplicaterender_registry_ready"))
	{
		wait(0.016);
		level flagsys::set("duplicaterender_registry_ready");
	}
}

/*
	Name: on_player_connect
	Namespace: duplicate_render
	Checksum: 0x496BAB69
	Offset: 0xAE0
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function on_player_connect(localClientNum)
{
	level wait_team_changed(localClientNum);
}

/*
	Name: wait_team_changed
	Namespace: duplicate_render
	Checksum: 0xD432CA10
	Offset: 0xB10
	Size: 0x87
	Parameters: 1
	Flags: None
*/
function wait_team_changed(localClientNum)
{
	while(1)
	{
		level waittill("team_changed");
		while(!isdefined(GetLocalPlayer(localClientNum)))
		{
			wait(0.05);
		}
		player = GetLocalPlayer(localClientNum);
		player Codcaster_Keyline_Enable(0);
	}
}

/*
	Name: set_dr_filter
	Namespace: duplicate_render
	Checksum: 0xCB29D2C9
	Offset: 0xBA0
	Size: 0x3B3
	Parameters: 14
	Flags: None
*/
function set_dr_filter(filterset, name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3)
{
	if(!isdefined(level.drfilters))
	{
		level.drfilters = [];
	}
	if(!isdefined(level.drfilters[filterset]))
	{
		level.drfilters[filterset] = [];
	}
	if(!isdefined(level.drfilters[filterset][name]))
	{
		level.drfilters[filterset][name] = spawnstruct();
	}
	filter = level.drfilters[filterset][name];
	filter.name = name;
	filter.priority = priority * -1;
	if(!isdefined(require_flags))
	{
		filter.require = [];
	}
	else if(IsArray(require_flags))
	{
		filter.require = require_flags;
	}
	else
	{
		filter.require = StrTok(require_flags, ",");
	}
	if(!isdefined(refuse_flags))
	{
		filter.refuse = [];
	}
	else if(IsArray(refuse_flags))
	{
		filter.refuse = refuse_flags;
	}
	else
	{
		filter.refuse = StrTok(refuse_flags, ",");
	}
	filter.types = [];
	filter.values = [];
	filter.culling = [];
	if(isdefined(drtype1))
	{
		idx = filter.types.size;
		filter.types[idx] = drtype1;
		filter.values[idx] = drval1;
		filter.culling[idx] = drcull1;
	}
	if(isdefined(drtype2))
	{
		idx = filter.types.size;
		filter.types[idx] = drtype2;
		filter.values[idx] = drval2;
		filter.culling[idx] = drcull2;
	}
	if(isdefined(drtype3))
	{
		idx = filter.types.size;
		filter.types[idx] = drtype3;
		filter.values[idx] = drval3;
		filter.culling[idx] = drcull3;
	}
	thread register_filter_materials(filter);
}

/*
	Name: set_dr_filter_framebuffer
	Namespace: duplicate_render
	Checksum: 0xDC5CA25A
	Offset: 0xF60
	Size: 0xBB
	Parameters: 13
	Flags: None
*/
function set_dr_filter_framebuffer(name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3)
{
	set_dr_filter("framebuffer", name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3);
}

/*
	Name: set_dr_filter_framebuffer_duplicate
	Namespace: duplicate_render
	Checksum: 0x32073C41
	Offset: 0x1028
	Size: 0xBB
	Parameters: 13
	Flags: None
*/
function set_dr_filter_framebuffer_duplicate(name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3)
{
	set_dr_filter("framebuffer_duplicate", name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3);
}

/*
	Name: set_dr_filter_offscreen
	Namespace: duplicate_render
	Checksum: 0xE6B67E0C
	Offset: 0x10F0
	Size: 0xBB
	Parameters: 13
	Flags: None
*/
function set_dr_filter_offscreen(name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3)
{
	set_dr_filter("offscreen", name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3);
}

/*
	Name: register_filter_materials
	Namespace: duplicate_render
	Checksum: 0xB54A7FAA
	Offset: 0x11B8
	Size: 0x19F
	Parameters: 1
	Flags: None
*/
function register_filter_materials(filter)
{
	playerCount = undefined;
	opts = filter.types.size;
	for(i = 0; i < opts; i++)
	{
		value = filter.values[i];
		if(IsString(value))
		{
			if(!isdefined(playerCount))
			{
				while(!isdefined(level.localPlayers) && !isdefined(level.frontendClientConnected))
				{
					wait(0.016);
				}
				if(isdefined(level.frontendClientConnected))
				{
					playerCount = 1;
				}
				else
				{
					util::waitforallclients();
					playerCount = level.localPlayers.size;
				}
			}
			if(!isdefined(filter::mapped_material_id(value)))
			{
				for(localClientNum = 0; localClientNum < playerCount; localClientNum++)
				{
					filter::map_material_helper_by_localclientnum(localClientNum, value);
				}
			}
		}
	}
	filter.priority = Abs(filter.priority);
}

/*
	Name: update_dr_flag
	Namespace: duplicate_render
	Checksum: 0x307A9179
	Offset: 0x1360
	Size: 0x63
	Parameters: 3
	Flags: None
*/
function update_dr_flag(localClientNum, toset, setto)
{
	if(!isdefined(setto))
	{
		setto = 1;
	}
	if(set_dr_flag(toset, setto))
	{
		update_dr_filters(localClientNum);
	}
}

/*
	Name: set_dr_flag_not_array
	Namespace: duplicate_render
	Checksum: 0x74CFEAEF
	Offset: 0x13D0
	Size: 0xCF
	Parameters: 2
	Flags: None
*/
function set_dr_flag_not_array(toset, setto)
{
	if(!isdefined(setto))
	{
		setto = 1;
	}
	if(!isdefined(self.flag) || !isdefined(self.flag[toset]))
	{
		self flag::init(toset);
	}
	if(setto == self.flag[toset])
	{
		return 0;
	}
	if(isdefined(setto) && setto)
	{
		self flag::set(toset);
	}
	else
	{
		self flag::clear(toset);
	}
	return 1;
}

/*
	Name: set_dr_flag
	Namespace: duplicate_render
	Checksum: 0x461CE453
	Offset: 0x14A8
	Size: 0x197
	Parameters: 2
	Flags: None
*/
function set_dr_flag(toset, setto)
{
	if(!isdefined(setto))
	{
		setto = 1;
	}
	/#
		Assert(isdefined(setto));
	#/
	if(IsArray(toset))
	{
		foreach(ts in toset)
		{
			set_dr_flag(ts, setto);
		}
		return;
	}
	if(!isdefined(self.flag) || !isdefined(self.flag[toset]))
	{
		self flag::init(toset);
	}
	if(setto == self.flag[toset])
	{
		return 0;
	}
	if(isdefined(setto) && setto)
	{
		self flag::set(toset);
	}
	else
	{
		self flag::clear(toset);
	}
	return 1;
}

/*
	Name: clear_dr_flag
	Namespace: duplicate_render
	Checksum: 0x5DAEF493
	Offset: 0x1648
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function clear_dr_flag(toclear)
{
	set_dr_flag(toclear, 0);
}

/*
	Name: change_dr_flags
	Namespace: duplicate_render
	Checksum: 0x60513159
	Offset: 0x1678
	Size: 0xF3
	Parameters: 3
	Flags: None
*/
function change_dr_flags(localClientNum, toset, toclear)
{
	if(isdefined(toset))
	{
		if(IsString(toset))
		{
			toset = StrTok(toset, ",");
		}
		self set_dr_flag(toset);
	}
	if(isdefined(toclear))
	{
		if(IsString(toclear))
		{
			toclear = StrTok(toclear, ",");
		}
		self clear_dr_flag(toclear);
	}
	update_dr_filters(localClientNum);
}

/*
	Name: _update_dr_filters
	Namespace: duplicate_render
	Checksum: 0x5D7EC2FF
	Offset: 0x1778
	Size: 0x121
	Parameters: 1
	Flags: None
*/
function _update_dr_filters(localClientNum)
{
	self notify("update_dr_filters");
	self endon("update_dr_filters");
	self endon("entityshutdown");
	waittillframeend;
	foreach(filterset in level.drfilters)
	{
		filter = self find_dr_filter(filterset);
		if(isdefined(filter) && (!isdefined(self.currentdrfilter) || !self.currentdrfilter[key] === filter.name))
		{
			self apply_filter(localClientNum, filter, key);
		}
	}
}

/*
	Name: update_dr_filters
	Namespace: duplicate_render
	Checksum: 0x4EF65EA6
	Offset: 0x18A8
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function update_dr_filters(localClientNum)
{
	self thread _update_dr_filters(localClientNum);
}

/*
	Name: find_dr_filter
	Namespace: duplicate_render
	Checksum: 0x701AB3F1
	Offset: 0x18D8
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function find_dr_filter(filterset)
{
	if(!isdefined(filterset))
	{
		filterset = level.drfilters["framebuffer"];
	}
	best = undefined;
	foreach(filter in filterset)
	{
		if(self can_use_filter(filter))
		{
			if(!isdefined(best) || filter.priority > best.priority)
			{
				best = filter;
			}
		}
	}
	return best;
}

/*
	Name: can_use_filter
	Namespace: duplicate_render
	Checksum: 0x109F258C
	Offset: 0x19E0
	Size: 0xC7
	Parameters: 1
	Flags: None
*/
function can_use_filter(filter)
{
	for(i = 0; i < filter.require.size; i++)
	{
		if(!self flagsys::get(filter.require[i]))
		{
			return 0;
		}
	}
	for(i = 0; i < filter.refuse.size; i++)
	{
		if(self flagsys::get(filter.refuse[i]))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: apply_filter
	Namespace: duplicate_render
	Checksum: 0x48752A49
	Offset: 0x1AB0
	Size: 0x363
	Parameters: 3
	Flags: None
*/
function apply_filter(localClientNum, filter, filterset)
{
	if(!isdefined(filterset))
	{
		filterset = "framebuffer";
	}
	if(isdefined(level.postGame) && level.postGame && (!isdefined(level.showedTopThreePlayers) && level.showedTopThreePlayers))
	{
		player = GetLocalPlayer(localClientNum);
		if(!player GetInKillcam(localClientNum))
		{
			return;
		}
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported"))
		{
			name = "Dev Block strings are not supported";
			if(self isPlayer())
			{
				if(isdefined(self.name))
				{
					name = "Dev Block strings are not supported" + self.name;
				}
			}
			else if(isdefined(self.model))
			{
				name = name + "Dev Block strings are not supported" + self.model;
			}
			msg = "Dev Block strings are not supported" + filter.name + "Dev Block strings are not supported" + name + "Dev Block strings are not supported" + filterset;
			println(msg);
		}
	#/
	if(!isdefined(self.currentdrfilter))
	{
		self.currentdrfilter = [];
	}
	self.currentdrfilter[filterset] = filter.name;
	opts = filter.types.size;
	for(i = 0; i < opts; i++)
	{
		type = filter.types[i];
		value = filter.values[i];
		culling = filter.culling[i];
		material = undefined;
		if(IsString(value))
		{
			material = filter::mapped_material_id(value);
			value = 3;
			if(isdefined(value) && isdefined(material))
			{
				self AddDuplicateRenderOption(type, value, material, culling);
			}
			else
			{
				self.currentdrfilter[filterset] = undefined;
			}
			continue;
		}
		self AddDuplicateRenderOption(type, value, -1, culling);
	}
	if(SessionModeIsMultiplayerGame())
	{
		self thread disable_all_filters_on_game_ended();
	}
}

/*
	Name: disable_all_filters_on_game_ended
	Namespace: duplicate_render
	Checksum: 0xB86234DF
	Offset: 0x1E20
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function disable_all_filters_on_game_ended()
{
	self endon("entityshutdown");
	self notify("disable_all_filters_on_game_ended");
	self endon("disable_all_filters_on_game_ended");
	level waittill("post_game");
	self disableduplicaterendering();
}

/*
	Name: set_item_retrievable
	Namespace: duplicate_render
	Checksum: 0xB4BF1258
	Offset: 0x1E78
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function set_item_retrievable(localClientNum, on_off)
{
	self update_dr_flag(localClientNum, "retrievable", on_off);
}

/*
	Name: set_item_unplaceable
	Namespace: duplicate_render
	Checksum: 0xFC573133
	Offset: 0x1EC0
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function set_item_unplaceable(localClientNum, on_off)
{
	self update_dr_flag(localClientNum, "unplaceable", on_off);
}

/*
	Name: set_item_enemy_equipment
	Namespace: duplicate_render
	Checksum: 0x69FDC590
	Offset: 0x1F08
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function set_item_enemy_equipment(localClientNum, on_off)
{
	self update_dr_flag(localClientNum, "enemyequip", on_off);
}

/*
	Name: set_item_friendly_equipment
	Namespace: duplicate_render
	Checksum: 0x184C4AC5
	Offset: 0x1F50
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function set_item_friendly_equipment(localClientNum, on_off)
{
	self update_dr_flag(localClientNum, "friendlyequip", on_off);
}

/*
	Name: set_item_enemy_explosive
	Namespace: duplicate_render
	Checksum: 0x30626352
	Offset: 0x1F98
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function set_item_enemy_explosive(localClientNum, on_off)
{
	self update_dr_flag(localClientNum, "enemyexplo", on_off);
}

/*
	Name: set_item_friendly_explosive
	Namespace: duplicate_render
	Checksum: 0xD1E11E6
	Offset: 0x1FE0
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function set_item_friendly_explosive(localClientNum, on_off)
{
	self update_dr_flag(localClientNum, "friendlyexplo", on_off);
}

/*
	Name: set_item_enemy_vehicle
	Namespace: duplicate_render
	Checksum: 0xFEF61605
	Offset: 0x2028
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function set_item_enemy_vehicle(localClientNum, on_off)
{
	self update_dr_flag(localClientNum, "enemyvehicle", on_off);
}

/*
	Name: set_item_friendly_vehicle
	Namespace: duplicate_render
	Checksum: 0xC5C62DE3
	Offset: 0x2070
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function set_item_friendly_vehicle(localClientNum, on_off)
{
	self update_dr_flag(localClientNum, "friendlyvehicle", on_off);
}

/*
	Name: set_entity_thermal
	Namespace: duplicate_render
	Checksum: 0xA733342A
	Offset: 0x20B8
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function set_entity_thermal(localClientNum, on_off)
{
	self update_dr_flag(localClientNum, "infrared_entity", on_off);
}

/*
	Name: set_player_threat_detected
	Namespace: duplicate_render
	Checksum: 0x82D480D6
	Offset: 0x2100
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function set_player_threat_detected(localClientNum, on_off)
{
	self update_dr_flag(localClientNum, "threat_detector_enemy", on_off);
}

/*
	Name: set_hacker_tool_hacked
	Namespace: duplicate_render
	Checksum: 0x66D5F1E4
	Offset: 0x2148
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function set_hacker_tool_hacked(localClientNum, on_off)
{
	self update_dr_flag(localClientNum, "hacker_tool_hacked", on_off);
}

/*
	Name: set_hacker_tool_hacking
	Namespace: duplicate_render
	Checksum: 0x705F2D36
	Offset: 0x2190
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function set_hacker_tool_hacking(localClientNum, on_off)
{
	self update_dr_flag(localClientNum, "hacker_tool_hacking", on_off);
}

/*
	Name: set_hacker_tool_breaching
	Namespace: duplicate_render
	Checksum: 0x95FA120D
	Offset: 0x21D8
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function set_hacker_tool_breaching(localClientNum, on_off)
{
	flags_changed = self set_dr_flag("hacker_tool_breaching", on_off);
	if(on_off)
	{
		flags_changed = self set_dr_flag("enemyvehicle", 0) || flags_changed;
	}
	else if(isdefined(self.isEnemyVehicle) && self.isEnemyVehicle)
	{
		flags_changed = self set_dr_flag("enemyvehicle", 1) || flags_changed;
	}
	if(flags_changed)
	{
		update_dr_filters(localClientNum);
	}
}

/*
	Name: show_friendly_outlines
	Namespace: duplicate_render
	Checksum: 0x25D22344
	Offset: 0x22B8
	Size: 0x45
	Parameters: 1
	Flags: None
*/
function show_friendly_outlines(local_client_num)
{
	if(!(isdefined(level.friendlyContentOutlines) && level.friendlyContentOutlines))
	{
		return 0;
	}
	if(IsShoutcaster(local_client_num))
	{
		return 0;
	}
	return 1;
}

