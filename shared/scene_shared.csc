#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\scene_debug_shared;
#using scripts\shared\scriptbundle_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace scene;

/*
	Name: player_scene_animation_skip
	Namespace: scene
	Checksum: 0xD4A1ED75
	Offset: 0x640
	Size: 0x123
	Parameters: 7
	Flags: None
*/
function player_scene_animation_skip(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	anim_name = self GetCurrentAnimScriptedName();
	if(isdefined(anim_name) && anim_name != "")
	{
		is_looping = IsAnimLooping(localClientNum, anim_name);
		if(!is_looping)
		{
			/#
				if(GetDvarInt("Dev Block strings are not supported") > 0)
				{
					PrintTopRightln("Dev Block strings are not supported" + anim_name + "Dev Block strings are not supported" + GetTime(), VectorScale((1, 1, 1), 0.6));
				}
			#/
			self SetAnimTimebyName(anim_name, 1, 1);
		}
	}
}

/*
	Name: player_scene_skip_completed
	Namespace: scene
	Checksum: 0xD3017F8
	Offset: 0x770
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function player_scene_skip_completed(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	flushsubtitles(localClientNum);
	SetDvar("r_graphicContentBlur", 0);
	SetDvar("r_makeDark_enable", 0);
}

#namespace cSceneObject;

/*
	Name: function_9b385ca5
	Namespace: cSceneObject
	Checksum: 0xEAF1916D
	Offset: 0x800
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
	cScriptBundleObjectBase::function_9b385ca5();
	self._b_spawnonce_used = 0;
	self._is_valid = 1;
}

/*
	Name: function_5fba2032
	Namespace: cSceneObject
	Checksum: 0x68D45E22
	Offset: 0x838
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
	cScriptBundleObjectBase::function_5fba2032();
}

/*
	Name: first_init
	Namespace: cSceneObject
	Checksum: 0x45DC0719
	Offset: 0x858
	Size: 0x7D
	Parameters: 4
	Flags: None
*/
function first_init(s_objdef, o_scene, e_ent, localClientNum)
{
	cScriptBundleObjectBase::init(s_objdef, o_scene, e_ent, localClientNum);
	_assign_unique_name();
	if(self._e_array.size)
	{
		_prepare(self._n_clientnum);
	}
	return self;
}

/*
	Name: Initialize
	Namespace: cSceneObject
	Checksum: 0x2F9C8F4C
	Offset: 0x8E0
	Size: 0x2EB
	Parameters: 0
	Flags: None
*/
function Initialize()
{
	if(isdefined(self._s.spawnoninit) && self._s.spawnoninit)
	{
		if(isdefined(self._n_clientnum))
		{
			_spawn(self._n_clientnum, isdefined(self._s.firstframe) && self._s.firstframe || isdefined(self._s.initanim) || isdefined(self._s.initanimloop));
			break;
		}
		_spawn(0, isdefined(self._s.firstframe) && self._s.firstframe || isdefined(self._s.initanim) || isdefined(self._s.initanimloop));
		for(clientNum = 1; clientNum < GetMaxLocalClients(); clientNum++)
		{
			if(isdefined(GetLocalPlayer(clientNum)))
			{
				if(isdefined(self._s.spawnoninit) && self._s.spawnoninit)
				{
					_spawn(clientNum, isdefined(self._s.firstframe) && self._s.firstframe || isdefined(self._s.initanim) || isdefined(self._s.initanimloop));
				}
			}
		}
	}
	flagsys::clear("ready");
	flagsys::clear("done");
	flagsys::clear("main_done");
	self notify("NEW_STATE");
	self endon("NEW_STATE");
	self notify("init");
	waittillframeend;
	if(isdefined(self._n_clientnum))
	{
		thread initialize_per_client(self._n_clientnum);
	}
	else
	{
		for(clientNum = 1; clientNum < GetMaxLocalClients(); clientNum++)
		{
			if(isdefined(GetLocalPlayer(clientNum)))
			{
				thread initialize_per_client(clientNum);
			}
		}
		initialize_per_client(0);
	}
}

/*
	Name: initialize_per_client
	Namespace: cSceneObject
	Checksum: 0xA4DE13E7
	Offset: 0xBD8
	Size: 0x243
	Parameters: 1
	Flags: None
*/
function initialize_per_client(clientNum)
{
	self endon("NEW_STATE");
	if(isdefined(self._s.firstframe) && self._s.firstframe)
	{
		if(!cScriptBundleObjectBase::error(!isdefined(self._s.mainanim), "No animation defined for first frame."))
		{
			_play_anim(clientNum, self._s.mainanim, 0, 0, 0, undefined, self._s.mainshot);
		}
	}
	else if(isdefined(self._s.initanim))
	{
		_play_anim(clientNum, self._s.initanim, self._s.initdelaymin, self._s.initdelaymax, 1, undefined, self._s.initshot);
		if(is_alive(clientNum))
		{
			if(isdefined(self._s.initanimloop))
			{
				_play_anim(clientNum, self._s.initanimloop, 0, 0, 1, undefined, self._s.initshotloop, 1);
			}
		}
	}
	else if(isdefined(self._s.initanimloop))
	{
		_play_anim(clientNum, self._s.initanimloop, self._s.initdelaymin, self._s.initdelaymax, 1, undefined, self._s.initshotloop, 1);
	}
	else
	{
		flagsys::set("ready");
	}
	if(!self._is_valid)
	{
		flagsys::set("done");
	}
}

/*
	Name: Play
	Namespace: cSceneObject
	Checksum: 0xB5328D40
	Offset: 0xE28
	Size: 0x11B
	Parameters: 0
	Flags: None
*/
function Play()
{
	flagsys::clear("ready");
	flagsys::clear("done");
	flagsys::clear("main_done");
	self notify("NEW_STATE");
	self endon("NEW_STATE");
	self notify("Play");
	waittillframeend;
	if(isdefined(self._n_clientnum))
	{
		play_per_client(self._n_clientnum);
	}
	else
	{
		for(clientNum = 1; clientNum < GetMaxLocalClients(); clientNum++)
		{
			if(isdefined(GetLocalPlayer(clientNum)))
			{
				thread play_per_client(clientNum);
			}
		}
		play_per_client(0);
	}
}

/*
	Name: play_per_client
	Namespace: cSceneObject
	Checksum: 0x6C84BAC0
	Offset: 0xF50
	Size: 0x1FB
	Parameters: 1
	Flags: None
*/
function play_per_client(clientNum)
{
	self endon("NEW_STATE");
	if(isdefined(self._s.mainanim))
	{
		_play_anim(clientNum, self._s.mainanim, self._s.maindelaymin, self._s.maindelaymax, 1, self._s.mainblend, self._s.mainshot);
		flagsys::set("main_done");
		if(is_alive(clientNum))
		{
			if(isdefined(self._s.endanim))
			{
				_play_anim(clientNum, self._s.endanim, 0, 0, 1, undefined, self._s.endshot, 1);
				if(is_alive(clientNum))
				{
					if(isdefined(self._s.endanimloop))
					{
						_play_anim(clientNum, self._s.endanimloop, 0, 0, 1, undefined, self._s.endshotloop, 1);
					}
				}
			}
			else if(isdefined(self._s.endanimloop))
			{
				_play_anim(clientNum, self._s.endanimloop, 0, 0, 1, undefined, self._s.endshotloop, 1);
			}
		}
	}
	thread finish_per_client(clientNum);
}

/*
	Name: finish
	Namespace: cSceneObject
	Checksum: 0xF5354C11
	Offset: 0x1158
	Size: 0xDB
	Parameters: 1
	Flags: None
*/
function finish(b_clear)
{
	if(!isdefined(b_clear))
	{
		b_clear = 0;
	}
	self notify("NEW_STATE");
	if(isdefined(self._n_clientnum))
	{
		finish_per_client(self._n_clientnum, b_clear);
	}
	else
	{
		for(clientNum = 1; clientNum < GetMaxLocalClients(); clientNum++)
		{
			if(isdefined(GetLocalPlayer(clientNum)))
			{
				finish_per_client(clientNum, b_clear);
			}
		}
		finish_per_client(0, b_clear);
	}
}

/*
	Name: finish_per_client
	Namespace: cSceneObject
	Checksum: 0x877B71D
	Offset: 0x1240
	Size: 0x12B
	Parameters: 2
	Flags: None
*/
function finish_per_client(clientNum, b_clear)
{
	if(!isdefined(b_clear))
	{
		b_clear = 0;
	}
	if(!is_alive(clientNum))
	{
		_cleanup(clientNum);
		self._e_array[clientNum] = undefined;
		self._is_valid = 0;
	}
	flagsys::set("ready");
	flagsys::set("done");
	if(isdefined(self._e_array[clientNum]))
	{
		if(is_alive(clientNum) && (isdefined(self._s.deletewhenfinished) && self._s.deletewhenfinished || b_clear))
		{
			self._e_array[clientNum] delete();
		}
	}
	_cleanup(clientNum);
}

/*
	Name: get_align_ent
	Namespace: cSceneObject
	Checksum: 0x8801C705
	Offset: 0x1378
	Size: 0x153
	Parameters: 1
	Flags: None
*/
function get_align_ent(clientNum)
{
	e_align = undefined;
	if(isdefined(self._s.aligntarget))
	{
		a_scene_ents = get_ents();
		if(isdefined(a_scene_ents[clientNum][self._s.aligntarget]))
		{
			e_align = a_scene_ents[clientNum][self._s.aligntarget];
		}
		else
		{
			e_align = scene::get_existing_ent(clientNum, self._s.aligntarget);
		}
		if(isdefined(self._s.aligntarget))
		{
		}
		else
		{
		}
		cScriptBundleObjectBase::error(!isdefined(e_align), "" + self._s.aligntarget + "" + "' doesn't exist for scene object.");
	}
	if(!isdefined(e_align))
	{
		e_align = get_align_ent(scene());
	}
	return e_align;
}

/*
	Name: scene
	Namespace: cSceneObject
	Checksum: 0xD376B57B
	Offset: 0x14D8
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function scene()
{
	return self._o_bundle;
}

/*
	Name: _assign_unique_name
	Namespace: cSceneObject
	Checksum: 0x78723F65
	Offset: 0x14F0
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function _assign_unique_name()
{
	if(allows_multiple())
	{
		if(isdefined(self._s.name))
		{
			self._str_name = self._s.name + "_gen" + level.scene_object_id;
		}
		else
		{
			self._str_name = get_name() + "_noname" + level.scene_object_id;
		}
		level.scene_object_id++;
	}
	else if(isdefined(self._s.name))
	{
		self._str_name = self._s.name;
	}
	else
	{
		self._str_name = scene() + get_object_id();
	}
}

/*
	Name: get_name
	Namespace: cSceneObject
	Checksum: 0x76170705
	Offset: 0x1620
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_name()
{
	return self._str_name;
}

/*
	Name: get_orig_name
	Namespace: cSceneObject
	Checksum: 0x563CC1A3
	Offset: 0x1638
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function get_orig_name()
{
	return self._s.name;
}

/*
	Name: _spawn
	Namespace: cSceneObject
	Checksum: 0x83C31024
	Offset: 0x1658
	Size: 0x3C7
	Parameters: 2
	Flags: None
*/
function _spawn(clientNum, b_hide)
{
	if(!isdefined(b_hide))
	{
		b_hide = 1;
	}
	if(!isdefined(self._e_array[clientNum]))
	{
		b_allows_multiple = allows_multiple();
		if(cScriptBundleObjectBase::error(b_allows_multiple && (isdefined(self._s.nospawn) && self._s.nospawn), "Scene that allow multiple instances must be allowed to spawn (uncheck 'Do Not Spawn')."))
		{
			return;
		}
		self._e_array[clientNum] = scene::get_existing_ent(clientNum, self._str_name);
		if(!isdefined(self._e_array[clientNum]) && isdefined(self._s.name) && !b_allows_multiple)
		{
			self._e_array[clientNum] = scene::get_existing_ent(clientNum, self._s.name);
		}
		if(!isdefined(self._e_array[clientNum]) && (!isdefined(self._s.nospawn) && self._s.nospawn) && !self._b_spawnonce_used)
		{
			_e_align = get_align_ent(clientNum);
			self._e_array[clientNum] = util::spawn_model(clientNum, self._s.model, _e_align.origin, _e_align.angles);
			if(isdefined(self._e_array[clientNum]))
			{
				if(b_hide)
				{
					self._e_array[clientNum] Hide();
				}
				self._e_array[clientNum].scene_spawned = self._o_bundle._s.name;
				self._e_array[clientNum].targetname = self._s.name;
			}
			else
			{
				cScriptBundleObjectBase::error(!isdefined(self._s.nospawn) && self._s.nospawn, "No entity exists with matching name of scene object.");
			}
		}
		if(isdefined(self._s.spawnonce) && self._s.spawnonce && self._b_spawnonce_used)
		{
			return;
		}
		if(!(cScriptBundleObjectBase::error(!isdefined(self._s.nospawn) && self._s.nospawn && !isdefined(self._e_array[clientNum]), "No entity exists with matching name of scene object. Make sure a model is specified if you want to spawn it.")))
		{
			_prepare(clientNum);
		}
	}
	if(isdefined(self._e_array[clientNum]))
	{
		flagsys::set("ready");
		if(isdefined(self._s.spawnonce) && self._s.spawnonce)
		{
			self._b_spawnonce_used = 1;
		}
	}
}

/*
	Name: _prepare
	Namespace: cSceneObject
	Checksum: 0x5ED05F14
	Offset: 0x1A28
	Size: 0x159
	Parameters: 1
	Flags: None
*/
function _prepare(clientNum)
{
	if(!(isdefined(self._s.issiege) && self._s.issiege))
	{
		if(!self._e_array[clientNum] HasAnimTree())
		{
			self._e_array[clientNum] useanimtree(-1);
		}
	}
	self._e_array[clientNum].animName = self._str_name;
	self._e_array[clientNum].anim_debug_name = self._s.name;
	self._e_array[clientNum] flagsys::set("scene");
	self._e_array[clientNum] flagsys::set(self._o_bundle._str_name);
	self._e_array[clientNum].current_scene = self._o_bundle._str_name;
	self._e_array[clientNum].finished_scene = undefined;
}

/*
	Name: _cleanup
	Namespace: cSceneObject
	Checksum: 0xAF66C5EA
	Offset: 0x1B90
	Size: 0x15B
	Parameters: 1
	Flags: None
*/
function _cleanup(clientNum)
{
	if(isdefined(self._e_array[clientNum]) && isdefined(self._e_array[clientNum].current_scene))
	{
		self._e_array[clientNum] flagsys::clear(self._o_bundle._str_name);
		if(self._e_array[clientNum].current_scene == self._o_bundle._str_name)
		{
			self._e_array[clientNum] flagsys::clear("scene");
			self._e_array[clientNum].finished_scene = self._o_bundle._str_name;
			self._e_array[clientNum].current_scene = undefined;
		}
	}
	if(clientNum === self._n_clientnum || clientNum == 0)
	{
		if(isdefined(self._o_bundle) && (isdefined(self._o_bundle.scene_stopped) && self._o_bundle.scene_stopped))
		{
			self._o_bundle = undefined;
		}
	}
}

/*
	Name: _play_anim
	Namespace: cSceneObject
	Checksum: 0xC6944AF9
	Offset: 0x1CF8
	Size: 0x2A3
	Parameters: 8
	Flags: None
*/
function _play_anim(clientNum, animation, n_delay_min, n_delay_max, n_rate, n_blend, str_siege_shot, loop)
{
	if(!isdefined(n_delay_min))
	{
		n_delay_min = 0;
	}
	if(!isdefined(n_delay_max))
	{
		n_delay_max = 0;
	}
	if(!isdefined(n_rate))
	{
		n_rate = 1;
	}
	n_delay = n_delay_min;
	if(n_delay_max > n_delay_min)
	{
		n_delay = RandomFloatRange(n_delay_min, n_delay_max);
	}
	if(n_delay > 0)
	{
		flagsys::set("ready");
		wait(n_delay);
		_spawn(clientNum);
	}
	else
	{
		_spawn(clientNum);
	}
	if(is_alive(clientNum))
	{
		self._e_array[clientNum] show();
		if(isdefined(self._s.issiege) && self._s.issiege)
		{
			self._e_array[clientNum] notify("end");
			self._e_array[clientNum] animation::play_siege(animation, str_siege_shot, n_rate, loop);
		}
		else
		{
			align = get_align_ent(clientNum);
			tag = get_align_tag();
			if(align == level)
			{
				align = (0, 0, 0);
				tag = (0, 0, 0);
			}
			self._e_array[clientNum] animation::Play(animation, align, tag, n_rate, n_blend);
		}
	}
	else
	{
		cScriptBundleObjectBase::Log("Dev Block strings are not supported" + animation + "Dev Block strings are not supported");
	}
	/#
	#/
	self._is_valid = is_alive(clientNum);
}

/*
	Name: get_align_tag
	Namespace: cSceneObject
	Checksum: 0xA8DFED11
	Offset: 0x1FA8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function get_align_tag()
{
	if(isdefined(self._s.AlignTargetTag))
	{
		return self._s.AlignTargetTag;
	}
	else
	{
		return self._o_bundle._s.AlignTargetTag;
	}
}

/*
	Name: wait_till_scene_ready
	Namespace: cSceneObject
	Checksum: 0x40202F70
	Offset: 0x1FF8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function wait_till_scene_ready()
{
	wait_till_scene_ready();
}

/*
	Name: has_init_state
	Namespace: cSceneObject
	Checksum: 0xFAECC5A3
	Offset: 0x2028
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function has_init_state()
{
	return self._s scene::_has_init_state();
}

/*
	Name: is_alive
	Namespace: cSceneObject
	Checksum: 0x2A65885D
	Offset: 0x2050
	Size: 0x19
	Parameters: 1
	Flags: None
*/
function is_alive(clientNum)
{
	return isdefined(self._e_array[clientNum]);
}

/*
	Name: in_a_different_scene
	Namespace: cSceneObject
	Checksum: 0xE43A5B4D
	Offset: 0x2078
	Size: 0xDF
	Parameters: 0
	Flags: None
*/
function in_a_different_scene()
{
	if(isdefined(self._n_clientnum))
	{
		if(isdefined(self._e_array[self._n_clientnum]) && isdefined(self._e_array[self._n_clientnum].current_scene) && self._e_array[self._n_clientnum].current_scene != self._o_bundle._str_name)
		{
			return 1;
		}
	}
	else if(isdefined(self._e_array[0]) && isdefined(self._e_array[0].current_scene) && self._e_array[0].current_scene != self._o_bundle._str_name)
	{
		return 1;
	}
	return 0;
}

#namespace scene;

/*
	Name: cSceneObject
	Namespace: scene
	Checksum: 0x3DF11B57
	Offset: 0x2160
	Size: 0x595
	Parameters: 0
	Flags: 6
*/
function private autoexec cSceneObject()
{
	classes.cSceneObject[0] = spawnstruct();
	classes.cSceneObject[0].__vtable[964891661] = &cScriptBundleObjectBase::get_ent;
	classes.cSceneObject[0].__vtable[-32002227] = &cScriptBundleObjectBase::error;
	classes.cSceneObject[0].__vtable[1621988813] = &cScriptBundleObjectBase::Log;
	classes.cSceneObject[0].__vtable[-1017222485] = &cScriptBundleObjectBase::init;
	classes.cSceneObject[0].__vtable[1606033458] = &cScriptBundleObjectBase::function_5fba2032;
	classes.cSceneObject[0].__vtable[-1690805083] = &cScriptBundleObjectBase::function_9b385ca5;
	classes.cSceneObject[0].__vtable[-1004716425] = &cSceneObject::in_a_different_scene;
	classes.cSceneObject[0].__vtable[-1924366689] = &cSceneObject::is_alive;
	classes.cSceneObject[0].__vtable[1064337886] = &cSceneObject::has_init_state;
	classes.cSceneObject[0].__vtable[792158469] = &cSceneObject::wait_till_scene_ready;
	classes.cSceneObject[0].__vtable[-2100195004] = &cSceneObject::get_align_tag;
	classes.cSceneObject[0].__vtable[-1706684566] = &cSceneObject::_play_anim;
	classes.cSceneObject[0].__vtable[751796260] = &cSceneObject::_cleanup;
	classes.cSceneObject[0].__vtable[-800750439] = &cSceneObject::_prepare;
	classes.cSceneObject[0].__vtable[987150381] = &cSceneObject::_spawn;
	classes.cSceneObject[0].__vtable[-1878563751] = &cSceneObject::get_orig_name;
	classes.cSceneObject[0].__vtable[245263499] = &cSceneObject::get_name;
	classes.cSceneObject[0].__vtable[737108631] = &cSceneObject::_assign_unique_name;
	classes.cSceneObject[0].__vtable[214070679] = &cSceneObject::scene;
	classes.cSceneObject[0].__vtable[1666938539] = &cSceneObject::get_align_ent;
	classes.cSceneObject[0].__vtable[847716238] = &cSceneObject::finish_per_client;
	classes.cSceneObject[0].__vtable[-1089329960] = &cSceneObject::finish;
	classes.cSceneObject[0].__vtable[-1148721625] = &cSceneObject::play_per_client;
	classes.cSceneObject[0].__vtable[1131512199] = &cSceneObject::Play;
	classes.cSceneObject[0].__vtable[-675334113] = &cSceneObject::initialize_per_client;
	classes.cSceneObject[0].__vtable[-422924033] = &cSceneObject::Initialize;
	classes.cSceneObject[0].__vtable[-1191896790] = &cSceneObject::first_init;
	classes.cSceneObject[0].__vtable[1606033458] = &cSceneObject::function_5fba2032;
	classes.cSceneObject[0].__vtable[-1690805083] = &cSceneObject::function_9b385ca5;
}

#namespace cscene;

/*
	Name: function_9b385ca5
	Namespace: cscene
	Checksum: 0x2BEFF95F
	Offset: 0x2700
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
	cScriptBundleBase::function_9b385ca5();
	self._n_object_id = 0;
	self._str_state = "";
}

/*
	Name: function_5fba2032
	Namespace: cscene
	Checksum: 0xA2582C78
	Offset: 0x2738
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
	cScriptBundleBase::function_5fba2032();
}

/*
	Name: init
	Namespace: cscene
	Checksum: 0xA85F5853
	Offset: 0x2758
	Size: 0x4CB
	Parameters: 5
	Flags: None
*/
function init(str_scenedef, s_scenedef, e_align, a_ents, b_test_run)
{
	cScriptBundleBase::init(str_scenedef, s_scenedef, b_test_run);
	if(!isdefined(a_ents))
	{
		a_ents = [];
	}
	else if(!IsArray(a_ents))
	{
		a_ents = Array(a_ents);
	}
	if(!cScriptBundleBase::error(a_ents.size > self._s.objects.size, "Trying to use more entities than scene supports."))
	{
		self._e_root = e_align;
		if(!isdefined(level.active_scenes[self._str_name]))
		{
			level.active_scenes[self._str_name] = [];
		}
		else if(!IsArray(level.active_scenes[self._str_name]))
		{
			level.active_scenes[self._str_name] = Array(level.active_scenes[self._str_name]);
		}
		level.active_scenes[self._str_name][level.active_scenes[self._str_name].size] = self._e_root;
		if(!isdefined(self._e_root.scenes))
		{
			self._e_root.scenes = [];
		}
		else if(!IsArray(self._e_root.scenes))
		{
			self._e_root.scenes = Array(self._e_root.scenes);
		}
		self._e_root.scenes[self._e_root.scenes.size] = self;
		a_objs = get_valid_object_defs();
		foreach(e_ent in ArrayCopy(a_ents))
		{
			foreach(s_obj in ArrayCopy(a_objs))
			{
				if(isdefined(str_name))
				{
				}
				else if(s_obj.name === "")
				{
					function_9b385ca5();
					cScriptBundleBase::add_object(first_init(cSceneObject, s_obj, self, e_ent));
					ArrayRemoveIndex(a_ents, str_name);
					ArrayRemoveIndex(a_objs, i);
					break;
				}
			}
		}
		foreach(s_obj in a_objs)
		{
			function_9b385ca5();
			cScriptBundleBase::add_object(first_init(cSceneObject, s_obj, self, Array::pop(a_ents)));
		}
		self thread Initialize();
	}
}

/*
	Name: get_valid_object_defs
	Namespace: cscene
	Checksum: 0x335E1C45
	Offset: 0x2C30
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function get_valid_object_defs()
{
	a_obj_defs = [];
	foreach(s_obj in self._s.objects)
	{
		if(self._s.vmtype == "client" || s_obj.vmtype == "client")
		{
			if(isdefined(s_obj.name) || isdefined(s_obj.model) || isdefined(s_obj.initanim) || isdefined(s_obj.mainanim))
			{
				if(!(isdefined(s_obj.disabled) && s_obj.disabled))
				{
					if(!isdefined(a_obj_defs))
					{
						a_obj_defs = [];
					}
					else if(!IsArray(a_obj_defs))
					{
						a_obj_defs = Array(a_obj_defs);
					}
					a_obj_defs[a_obj_defs.size] = s_obj;
				}
			}
		}
	}
	return a_obj_defs;
}

/*
	Name: Initialize
	Namespace: cscene
	Checksum: 0xC2EB031F
	Offset: 0x2DD8
	Size: 0x14B
	Parameters: 1
	Flags: None
*/
function Initialize()
{
System.ArgumentException: Expecting While Loop At FirstArrayKey
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.⁮‍‏‫‏⁫⁪‏⁬‪‬​‏⁯⁭‪‎​‮⁪‭‭⁭‮‪‍‬‪‍‍⁫‎⁪⁬‍‍‪‪​⁪‮()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: get_object_id
	Namespace: cscene
	Checksum: 0xC389D09B
	Offset: 0x2F30
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function get_object_id()
{
	self._n_object_id++;
	return self._n_object_id;
}

/*
	Name: Play
	Namespace: cscene
	Checksum: 0xB43C8A89
	Offset: 0x2F50
	Size: 0x30B
	Parameters: 2
	Flags: None
*/
function Play()
{
System.ArgumentException: Expecting While Loop At FirstArrayKey
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.⁮‍‏‫‏⁫⁪‏⁬‪‬​‏⁯⁭‪‎​‮⁪‭‭⁭‮‪‍‬‪‍‍⁫‎⁪⁬‍‍‪‪​⁪‮()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: run_next
	Namespace: cscene
	Checksum: 0xAA417818
	Offset: 0x3268
	Size: 0x1E3
	Parameters: 0
	Flags: None
*/
function run_next()
{
	if(isdefined(self._s.nextscenebundle) && self._s.vmtype != "both")
	{
		self waittill("stopped", b_finished);
		if(b_finished)
		{
			if(self._s.scenetype == "fxanim" && self._s.nextscenemode === "init")
			{
				if(!cScriptBundleBase::error(!has_init_state(), "Scene can't init next scene '" + self._s.nextscenebundle + "' because it doesn't have an init state."))
				{
					if(allows_multiple())
					{
						self._e_root thread scene::init(self._s.nextscenebundle, get_ents());
					}
					else
					{
						self._e_root thread scene::init(self._s.nextscenebundle);
					}
				}
			}
			else if(allows_multiple())
			{
				self._e_root thread scene::Play(self._s.nextscenebundle, get_ents());
			}
			else
			{
				self._e_root thread scene::Play(self._s.nextscenebundle);
			}
		}
	}
}

/*
	Name: stop
	Namespace: cscene
	Checksum: 0xDBEFFB09
	Offset: 0x3458
	Size: 0x27F
	Parameters: 2
	Flags: None
*/
function stop()
{
System.ArgumentException: Expecting While Loop At FirstArrayKey
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.⁮‍‏‫‏⁫⁪‏⁬‪‬​‏⁯⁭‪‎​‮⁪‭‭⁭‮‪‍‬‪‍‍⁫‎⁪⁬‍‍‪‪​⁪‮()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: has_init_state
	Namespace: cscene
	Checksum: 0x3D90F786
	Offset: 0x36E0
	Size: 0xA9
	Parameters: 0
	Flags: None
*/
function has_init_state()
{
	b_has_init_state = 0;
	foreach(o_scene_object in self._a_objects)
	{
		if(has_init_state())
		{
			b_has_init_state = 1;
			break;
		}
	}
	return b_has_init_state;
}

/*
	Name: _call_state_funcs
	Namespace: cscene
	Checksum: 0x24E99D13
	Offset: 0x3798
	Size: 0x3CD
	Parameters: 1
	Flags: None
*/
function _call_state_funcs(str_state)
{
	self endon("stopped");
	wait_till_scene_ready();
	if(str_state == "play")
	{
		waittillframeend;
	}
	level notify(self._str_name + "_" + str_state);
	if(isdefined(level.scene_funcs) && isdefined(level.scene_funcs[self._str_name]) && isdefined(level.scene_funcs[self._str_name][str_state]))
	{
		a_all_ents = get_ents();
		foreach(a_ents in a_all_ents)
		{
			foreach(handler in level.scene_funcs[self._str_name][str_state])
			{
				func = handler[0];
				args = handler[1];
				switch(args.size)
				{
					case 6:
					{
						self._e_root thread [[func]](a_ents, args[0], args[1], args[2], args[3], args[4], args[5]);
						break;
					}
					case 5:
					{
						self._e_root thread [[func]](a_ents, args[0], args[1], args[2], args[3], args[4]);
						break;
					}
					case 4:
					{
						self._e_root thread [[func]](a_ents, args[0], args[1], args[2], args[3]);
						break;
					}
					case 3:
					{
						self._e_root thread [[func]](a_ents, args[0], args[1], args[2]);
						break;
					}
					case 2:
					{
						self._e_root thread [[func]](a_ents, args[0], args[1]);
						break;
					}
					case 1:
					{
						self._e_root thread [[func]](a_ents, args[0]);
						break;
					}
					case 0:
					{
						self._e_root thread [[func]](a_ents);
						break;
					}
					case default:
					{
						/#
							ASSERTMSG("Dev Block strings are not supported");
						#/
					}
				}
			}
		}
	}
}

/*
	Name: get_ents
	Namespace: cscene
	Checksum: 0xA7AF3FE1
	Offset: 0x3B70
	Size: 0x1AD
	Parameters: 0
	Flags: None
*/
function get_ents()
{
	a_ents = [];
	for(clientNum = 0; clientNum < GetMaxLocalClients(); clientNum++)
	{
		if(isdefined(GetLocalPlayer(clientNum)))
		{
			a_ents[clientNum] = [];
			foreach(o_obj in self._a_objects)
			{
				ent = get_ent(o_obj);
				if(isdefined(o_obj._s.name))
				{
					a_ents[clientNum][o_obj._s.name] = ent;
					continue;
				}
				if(!isdefined(a_ents))
				{
					a_ents = [];
				}
				else if(!IsArray(a_ents))
				{
					a_ents = Array(a_ents);
				}
				a_ents[a_ents.size] = ent;
			}
		}
	}
	return a_ents;
}

/*
	Name: get_root
	Namespace: cscene
	Checksum: 0xE82BCB26
	Offset: 0x3D28
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_root()
{
	return self._e_root;
}

/*
	Name: get_align_ent
	Namespace: cscene
	Checksum: 0x34BA963D
	Offset: 0x3D40
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function get_align_ent(clientNum)
{
	e_align = self._e_root;
	if(isdefined(self._s.aligntarget))
	{
		e_gdt_align = scene::get_existing_ent(clientNum, self._s.aligntarget);
		if(isdefined(e_gdt_align))
		{
			e_align = e_gdt_align;
		}
	}
	return e_align;
}

/*
	Name: allows_multiple
	Namespace: cscene
	Checksum: 0xB376D501
	Offset: 0x3DC8
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function allows_multiple()
{
	return isdefined(self._s.allowmultiple) && self._s.allowmultiple;
}

/*
	Name: is_looping
	Namespace: cscene
	Checksum: 0xF318E046
	Offset: 0x3DF8
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function is_looping()
{
	return isdefined(self._s.looping) && self._s.looping;
}

/*
	Name: wait_till_scene_ready
	Namespace: cscene
	Checksum: 0x69DC4DD6
	Offset: 0x3E28
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function wait_till_scene_ready()
{
	if(isdefined(self._a_objects))
	{
		Array::flagsys_wait(self._a_objects, "ready");
	}
}

/*
	Name: wait_till_scene_done
	Namespace: cscene
	Checksum: 0x543BFC11
	Offset: 0x3E68
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function wait_till_scene_done()
{
	Array::flagsys_wait(self._a_objects, "done");
}

/*
	Name: get_valid_objects
	Namespace: cscene
	Checksum: 0xFA5AD4C4
	Offset: 0x3E98
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function get_valid_objects()
{
	a_obj = [];
	foreach(obj in self._a_objects)
	{
		if(obj._is_valid && !in_a_different_scene())
		{
			if(!isdefined(a_obj))
			{
				a_obj = [];
			}
			else if(!IsArray(a_obj))
			{
				a_obj = Array(a_obj);
			}
			a_obj[a_obj.size] = obj;
		}
	}
	return a_obj;
}

/*
	Name: on_error
	Namespace: cscene
	Checksum: 0x30D4688A
	Offset: 0x3FB0
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function on_error()
{
	stop();
}

/*
	Name: get_state
	Namespace: cscene
	Checksum: 0xDB7643BE
	Offset: 0x3FD0
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_state()
{
	return self._str_state;
}

#namespace scene;

/*
	Name: cscene
	Namespace: scene
	Checksum: 0xC5A34294
	Offset: 0x3FE8
	Size: 0x685
	Parameters: 0
	Flags: 6
*/
function private autoexec cscene()
{
	classes.cscene[0] = spawnstruct();
	classes.cscene[0].__vtable[-32002227] = &cScriptBundleBase::error;
	classes.cscene[0].__vtable[1621988813] = &cScriptBundleBase::Log;
	classes.cscene[0].__vtable[713694985] = &cScriptBundleBase::remove_object;
	classes.cscene[0].__vtable[178798596] = &cScriptBundleBase::add_object;
	classes.cscene[0].__vtable[1440274456] = &cScriptBundleBase::is_testing;
	classes.cscene[0].__vtable[-512051494] = &cScriptBundleBase::get_objects;
	classes.cscene[0].__vtable[575565049] = &cScriptBundleBase::get_vm;
	classes.cscene[0].__vtable[245263499] = &cScriptBundleBase::get_name;
	classes.cscene[0].__vtable[1872615990] = &cScriptBundleBase::get_type;
	classes.cscene[0].__vtable[-1017222485] = &cScriptBundleBase::init;
	classes.cscene[0].__vtable[1606033458] = &cScriptBundleBase::function_5fba2032;
	classes.cscene[0].__vtable[-1690805083] = &cScriptBundleBase::function_9b385ca5;
	classes.cscene[0].__vtable[-498584435] = &cScriptBundleBase::on_error;
	classes.cscene[0].__vtable[1194857509] = &cscene::get_state;
	classes.cscene[0].__vtable[-498584435] = &cscene::on_error;
	classes.cscene[0].__vtable[-241958475] = &cscene::get_valid_objects;
	classes.cscene[0].__vtable[-399287968] = &cscene::wait_till_scene_done;
	classes.cscene[0].__vtable[792158469] = &cscene::wait_till_scene_ready;
	classes.cscene[0].__vtable[17277842] = &cscene::is_looping;
	classes.cscene[0].__vtable[400356434] = &cscene::allows_multiple;
	classes.cscene[0].__vtable[1666938539] = &cscene::get_align_ent;
	classes.cscene[0].__vtable[1282680066] = &cscene::get_root;
	classes.cscene[0].__vtable[64630156] = &cscene::get_ents;
	classes.cscene[0].__vtable[415171386] = &cscene::_call_state_funcs;
	classes.cscene[0].__vtable[1064337886] = &cscene::has_init_state;
	classes.cscene[0].__vtable[-51025227] = &cscene::stop;
	classes.cscene[0].__vtable[-1243624088] = &cscene::run_next;
	classes.cscene[0].__vtable[1131512199] = &cscene::Play;
	classes.cscene[0].__vtable[-1443067443] = &cscene::get_object_id;
	classes.cscene[0].__vtable[-422924033] = &cscene::Initialize;
	classes.cscene[0].__vtable[-794265383] = &cscene::get_valid_object_defs;
	classes.cscene[0].__vtable[-1017222485] = &cscene::init;
	classes.cscene[0].__vtable[1606033458] = &cscene::function_5fba2032;
	classes.cscene[0].__vtable[-1690805083] = &cscene::function_9b385ca5;
}

/*
	Name: get_existing_ent
	Namespace: scene
	Checksum: 0xF3679CA8
	Offset: 0x4678
	Size: 0xCB
	Parameters: 2
	Flags: None
*/
function get_existing_ent(clientNum, str_name)
{
	e = GetEnt(clientNum, str_name, "animname");
	if(!isdefined(e))
	{
		e = GetEnt(clientNum, str_name, "script_animname");
		if(!isdefined(e))
		{
			e = GetEnt(clientNum, str_name, "targetname");
			if(!isdefined(e))
			{
				e = struct::get(str_name, "targetname");
			}
		}
	}
	return e;
}

/*
	Name: __init__sytem__
	Namespace: scene
	Checksum: 0xCE6A6039
	Offset: 0x4750
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("scene", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: scene
	Checksum: 0xF6F1967E
	Offset: 0x4798
	Size: 0x3BB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	a_scenedefs = struct::get_script_bundles("scene");
	level.server_scenes = [];
	foreach(s_scenedef in a_scenedefs)
	{
		s_scenedef.editaction = undefined;
		s_scenedef.newobject = undefined;
		if(s_scenedef is_igc())
		{
			level.server_scenes[s_scenedef.name] = s_scenedef;
			continue;
		}
		if(s_scenedef.vmtype == "both")
		{
			n_clientbits = GetMinBitCountForNum(3);
			/#
				n_clientbits = GetMinBitCountForNum(6);
			#/
			clientfield::register("world", s_scenedef.name, 1, n_clientbits, "int", &cf_server_sync, 0, 0);
		}
	}
	clientfield::register("toplayer", "postfx_igc", 1, 2, "counter", &postfx_igc, 0, 0);
	clientfield::register("world", "in_igc", 1, 4, "int", &in_igc, 0, 0);
	clientfield::register("toplayer", "player_scene_skip_completed", 1, 2, "counter", &player_scene_skip_completed, 0, 0);
	clientfield::register("allplayers", "player_scene_animation_skip", 1, 2, "counter", &player_scene_animation_skip, 0, 0);
	clientfield::register("actor", "player_scene_animation_skip", 1, 2, "counter", &player_scene_animation_skip, 0, 0);
	clientfield::register("vehicle", "player_scene_animation_skip", 1, 2, "counter", &player_scene_animation_skip, 0, 0);
	clientfield::register("scriptmover", "player_scene_animation_skip", 1, 2, "counter", &player_scene_animation_skip, 0, 0);
	level.scene_object_id = 0;
	level.active_scenes = [];
	callback::on_localclient_shutdown(&on_localplayer_shutdown);
}

/*
	Name: in_igc
	Namespace: scene
	Checksum: 0xA99E32
	Offset: 0x4B60
	Size: 0xCF
	Parameters: 7
	Flags: None
*/
function in_igc(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	player = GetLocalPlayer(localClientNum);
	n_entnum = player GetEntityNumber();
	b_igc_active = 0;
	if(newVal & 1 << n_entnum)
	{
		b_igc_active = 1;
	}
	IGCactive(localClientNum, b_igc_active);
	/#
	#/
}

/*
	Name: on_localplayer_shutdown
	Namespace: scene
	Checksum: 0x8BD9BB9B
	Offset: 0x4C38
	Size: 0xDB
	Parameters: 1
	Flags: Private
*/
function private on_localplayer_shutdown(localClientNum)
{
	localPlayer = self;
	codeLocalPlayer = GetLocalPlayer(localClientNum);
	if(isdefined(localPlayer) && isdefined(localPlayer.localClientNum) && isdefined(codeLocalPlayer) && localPlayer == codeLocalPlayer)
	{
		filter::disable_filter_base_frame_transition(localPlayer, 5);
		filter::disable_filter_sprite_transition(localPlayer, 5);
		filter::disable_filter_frame_transition(localPlayer, 5);
		localPlayer.postfx_igc_on = undefined;
		localPlayer.pstfx_world_construction = 0;
	}
}

/*
	Name: postfx_igc
	Namespace: scene
	Checksum: 0xE77C235B
	Offset: 0x4D20
	Size: 0x1095
	Parameters: 7
	Flags: None
*/
function postfx_igc(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	if(isdefined(self.postfx_igc_on) && self.postfx_igc_on)
	{
		return;
	}
	if(SessionModeIsZombiesGame())
	{
		postfx_igc_zombies(localClientNum);
		return;
	}
	if(newVal == 3)
	{
		self thread postfx_igc_short(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
		return;
	}
	self.postfx_igc_on = 1;
	codeImageName = "postfx_igc_image" + localClientNum;
	CreateSceneCodeImage(localClientNum, codeImageName);
	CaptureFrame(localClientNum, codeImageName);
	filter::init_filter_base_frame_transition(self);
	filter::init_filter_sprite_transition(self);
	filter::init_filter_frame_transition(self);
	setFilterPassCodeTexture(localClientNum, 5, 0, 0, codeImageName);
	setFilterPassCodeTexture(localClientNum, 5, 1, 0, codeImageName);
	setFilterPassCodeTexture(localClientNum, 5, 2, 0, codeImageName);
	filter::enable_filter_base_frame_transition(self, 5);
	filter::enable_filter_sprite_transition(self, 5);
	filter::enable_filter_frame_transition(self, 5);
	filter::set_filter_base_frame_transition_warp(self, 5, 1);
	filter::set_filter_base_frame_transition_boost(self, 5, 0.5);
	filter::set_filter_base_frame_transition_durden(self, 5, 1);
	filter::set_filter_base_frame_transition_durden_blur(self, 5, 1);
	filter::set_filter_sprite_transition_elapsed(self, 5, 0);
	filter::set_filter_sprite_transition_octogons(self, 5, 1);
	filter::set_filter_sprite_transition_blur(self, 5, 0);
	filter::set_filter_sprite_transition_boost(self, 5, 0);
	filter::set_filter_frame_transition_light_hexagons(self, 5, 0);
	filter::set_filter_frame_transition_heavy_hexagons(self, 5, 0);
	filter::set_filter_frame_transition_flare(self, 5, 0);
	filter::set_filter_frame_transition_blur(self, 5, 0);
	filter::set_filter_frame_transition_iris(self, 5, 0);
	filter::set_filter_frame_transition_saved_frame_reveal(self, 5, 0);
	filter::set_filter_frame_transition_warp(self, 5, 0);
	filter::set_filter_sprite_transition_move_radii(self, 5, 0, 0);
	filter::set_filter_base_frame_transition_warp(self, 5, 1);
	filter::set_filter_base_frame_transition_boost(self, 5, 1);
	n_hex = 0;
	b_streamer_wait = 1;
	for(i = 0; i < 2000;  = 0)
	{
		sT = i / 1000;
		if(b_streamer_wait && sT >= 0.65)
		{
			for(n_streamer_time_total = 0; !isStreamerReady() && n_streamer_time_total < 5000;  = 0)
			{
				n_streamer_time = GetTime();
				for(j = 650; j < 1150;  = 650)
				{
					jT = j / 1000;
					filter::set_filter_frame_transition_heavy_hexagons(self, 5, mapfloat(0.65, 1.15, 0, 1, jT));
					wait(0.016);
				}
				for(j = 1150; j < 650;  = 1150)
				{
					jT = j / 1000;
					filter::set_filter_frame_transition_heavy_hexagons(self, 5, mapfloat(0.65, 1.15, 0, 1, jT));
					wait(0.016);
				}
			}
			b_streamer_wait = 0;
		}
		if(sT <= 0.5)
		{
			filter::set_filter_frame_transition_iris(self, 5, mapfloat(0, 0.5, 0, 1, sT));
		}
		else if(sT > 0.5 && sT <= 0.85)
		{
			filter::set_filter_frame_transition_iris(self, 5, 1 - mapfloat(0.5, 0.85, 0, 1, sT));
		}
		else
		{
			filter::set_filter_frame_transition_iris(self, 5, 0);
		}
		if(newVal == 2)
		{
			if(sT > 1 && (!isdefined(self.pstfx_world_construction) && self.pstfx_world_construction))
			{
				self thread postfx::playPostfxBundle("pstfx_world_construction");
				self.pstfx_world_construction = 1;
			}
		}
		if(sT > 0.5 && sT <= 1)
		{
			n_hex = mapfloat(0.5, 1, 0, 1, sT);
			filter::set_filter_frame_transition_light_hexagons(self, 5, n_hex);
			if(sT >= 0.8)
			{
				filter::set_filter_frame_transition_flare(self, 5, mapfloat(0.8, 1, 0, 1, sT));
			}
		}
		else if(sT > 1 && sT < 1.5)
		{
			filter::set_filter_frame_transition_light_hexagons(self, 5, 1);
			filter::set_filter_frame_transition_flare(self, 5, 1);
		}
		else
		{
			filter::set_filter_frame_transition_light_hexagons(self, 5, 0);
			filter::set_filter_frame_transition_flare(self, 5, 0);
		}
		if(sT > 0.65 && sT <= 1.15)
		{
			filter::set_filter_frame_transition_heavy_hexagons(self, 5, mapfloat(0.65, 1.15, 0, 1, sT));
		}
		else if(sT > 1.21 && sT < 1.5)
		{
			filter::set_filter_frame_transition_heavy_hexagons(self, 5, 1);
		}
		else
		{
			filter::set_filter_frame_transition_heavy_hexagons(self, 5, 0);
		}
		if(sT > 1.21 && sT <= 1.5)
		{
			filter::set_filter_frame_transition_blur(self, 5, mapfloat(1, 1.5, 0, 1, sT));
			filter::set_filter_sprite_transition_boost(self, 5, mapfloat(1, 1.5, 0, 1, sT));
			filter::set_filter_frame_transition_saved_frame_reveal(self, 5, mapfloat(1, 1.5, 0, 1, sT));
			filter::set_filter_base_frame_transition_durden_blur(self, 5, 1 - mapfloat(1, 1.5, 0, 1, sT));
			filter::set_filter_sprite_transition_blur(self, 5, mapfloat(1, 1.5, 0, 0.1, sT));
		}
		else if(sT > 1.5)
		{
			filter::set_filter_frame_transition_blur(self, 5, 1);
			filter::set_filter_sprite_transition_boost(self, 5, 1);
			filter::set_filter_frame_transition_saved_frame_reveal(self, 5, 1);
			filter::set_filter_base_frame_transition_durden_blur(self, 5, 0);
			filter::set_filter_sprite_transition_blur(self, 5, 0.1);
		}
		if(sT > 1 && sT <= 1.45)
		{
			filter::set_filter_base_frame_transition_boost(self, 5, mapfloat(1, 1.45, 0.5, 1, sT));
		}
		else if(sT > 1.45 && sT < 1.75)
		{
			filter::set_filter_base_frame_transition_boost(self, 5, 1);
		}
		else if(sT >= 1.75)
		{
			filter::set_filter_base_frame_transition_boost(self, 5, 1 - mapfloat(1.75, 2, 0, 1, sT));
		}
		if(sT >= 1.75)
		{
			VAL = 1 - mapfloat(1.75, 2, 0, 1, sT);
			filter::set_filter_frame_transition_blur(self, 5, VAL);
			filter::set_filter_base_frame_transition_warp(self, 5, VAL);
		}
		if(sT >= 1.25)
		{
			VAL = 1 - mapfloat(1.25, 1.75, 0, 1, sT);
			filter::set_filter_sprite_transition_octogons(self, 5, VAL);
		}
		if(sT >= 1.75 && sT < 2)
		{
			filter::set_filter_base_frame_transition_durden(self, 5, 1 - mapfloat(1.75, 2, 0, 1, sT));
		}
		if(sT > 1)
		{
			filter::set_filter_sprite_transition_elapsed(self, 5, i - 1000);
			outer_radii = mapfloat(1, 1.5, 0, 2000, sT);
			filter::set_filter_sprite_transition_move_radii(self, 5, outer_radii - 256, outer_radii);
		}
		if(sT > 1.15 && sT < 1.85)
		{
			filter::set_filter_frame_transition_warp(self, 5, -1 * mapfloat(1.15, 1.85, 0, 1, sT));
		}
		else if(sT >= 1.85)
		{
			filter::set_filter_frame_transition_warp(self, 5, -1 * 1 - mapfloat(1.85, 2, 0, 1, sT));
		}
		wait(0.016);
	}
	filter::disable_filter_base_frame_transition(self, 5);
	filter::disable_filter_sprite_transition(self, 5);
	filter::disable_filter_frame_transition(self, 5);
	self.pstfx_world_construction = 0;
	FreeCodeImage(localClientNum, codeImageName);
	self.postfx_igc_on = undefined;
}

/*
	Name: postfx_igc_zombies
	Namespace: scene
	Checksum: 0x75FBB1F6
	Offset: 0x5DC0
	Size: 0x55
	Parameters: 1
	Flags: None
*/
function postfx_igc_zombies(localClientNum)
{
	LUI::screen_fade_out(0, "black");
	wait(0.016);
	LUI::screen_fade_in(0.3);
	self.postfx_igc_on = undefined;
}

/*
	Name: postfx_igc_short
	Namespace: scene
	Checksum: 0xAAC913F6
	Offset: 0x5E20
	Size: 0x385
	Parameters: 7
	Flags: None
*/
function postfx_igc_short(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self.postfx_igc_on = 1;
	codeImageName = "postfx_igc_image" + localClientNum;
	CreateSceneCodeImage(localClientNum, codeImageName);
	CaptureFrame(localClientNum, codeImageName);
	filter::init_filter_base_frame_transition(self);
	filter::init_filter_sprite_transition(self);
	filter::init_filter_frame_transition(self);
	setFilterPassCodeTexture(localClientNum, 5, 0, 0, codeImageName);
	setFilterPassCodeTexture(localClientNum, 5, 1, 0, codeImageName);
	setFilterPassCodeTexture(localClientNum, 5, 2, 0, codeImageName);
	filter::enable_filter_base_frame_transition(self, 5);
	filter::enable_filter_sprite_transition(self, 5);
	filter::enable_filter_frame_transition(self, 5);
	filter::set_filter_frame_transition_iris(self, 5, 0);
	b_streamer_wait = 1;
	for(i = 0; i < 850;  = 0)
	{
		sT = i / 1000;
		if(sT <= 0.5)
		{
			filter::set_filter_frame_transition_iris(self, 5, mapfloat(0, 0.5, 0, 1, sT));
		}
		else if(sT > 0.5 && sT <= 0.85)
		{
			filter::set_filter_frame_transition_iris(self, 5, 1 - mapfloat(0.5, 0.85, 0, 1, sT));
		}
		else
		{
			filter::set_filter_frame_transition_iris(self, 5, 0);
		}
		wait(0.016);
	}
	filter::disable_filter_base_frame_transition(self, 5);
	filter::disable_filter_sprite_transition(self, 5);
	filter::disable_filter_frame_transition(self, 5);
	FreeCodeImage(localClientNum, codeImageName);
	self.postfx_igc_on = undefined;
}

/*
	Name: cf_server_sync
	Namespace: scene
	Checksum: 0xF8235B94
	Offset: 0x61B0
	Size: 0x195
	Parameters: 7
	Flags: None
*/
function cf_server_sync(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 0:
		{
			if(is_active(fieldName))
			{
				level thread stop(fieldName);
			}
			break;
		}
		case 1:
		{
			level thread init(fieldName);
			break;
		}
		case 2:
		{
			level thread Play(fieldName);
			break;
		}
	}
	/#
		switch(newVal)
		{
			case 3:
			{
				if(is_active(fieldName))
				{
					level thread stop(fieldName, 1, undefined, undefined, 1);
				}
				break;
			}
			case 4:
			{
				level thread init(fieldName, undefined, undefined, 1);
				break;
			}
			case 5:
			{
				level thread Play(fieldName, undefined, undefined, 1);
				break;
			}
		}
	#/
}

/*
	Name: remove_invalid_scene_objects
	Namespace: scene
	Checksum: 0xAC0EC652
	Offset: 0x6350
	Size: 0x169
	Parameters: 1
	Flags: None
*/
function remove_invalid_scene_objects(s_scenedef)
{
	a_invalid_object_indexes = [];
	foreach(s_object in s_scenedef.objects)
	{
		if(!isdefined(s_object.name) && !isdefined(s_object.model))
		{
			if(!isdefined(a_invalid_object_indexes))
			{
				a_invalid_object_indexes = [];
			}
			else if(!IsArray(a_invalid_object_indexes))
			{
				a_invalid_object_indexes = Array(a_invalid_object_indexes);
			}
			a_invalid_object_indexes[a_invalid_object_indexes.size] = i;
		}
	}
	for(i = a_invalid_object_indexes.size - 1; i >= 0; i--)
	{
		ArrayRemoveIndex(s_scenedef.objects, a_invalid_object_indexes[i]);
	}
	return s_scenedef;
}

/*
	Name: is_igc
	Namespace: scene
	Checksum: 0x259FB470
	Offset: 0x64C8
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function is_igc()
{
	return IsString(self.cameraswitcher) || IsString(self.extraCamSwitcher1) || IsString(self.extraCamSwitcher2) || IsString(self.extraCamSwitcher3) || IsString(self.extraCamSwitcher4);
}

/*
	Name: __main__
	Namespace: scene
	Checksum: 0x6B8262B2
	Offset: 0x6550
	Size: 0x2D9
	Parameters: 0
	Flags: None
*/
function __main__()
{
	wait(0.05);
	if(isdefined(level.disableFXAnimInSplitscreenCount))
	{
		if(isdefined(level.localPlayers))
		{
			if(level.localPlayers.size >= level.disableFXAnimInSplitscreenCount)
			{
				return;
			}
		}
	}
	a_instances = ArrayCombine(struct::get_array("scriptbundle_scene", "classname"), struct::get_array("scriptbundle_fxanim", "classname"), 0, 0);
	foreach(s_instance in a_instances)
	{
	}
	foreach(s_instance in a_instances)
	{
		s_scenedef = struct::get_script_bundle("scene", s_instance.scriptbundlename);
		/#
			Assert(isdefined(s_scenedef), "Dev Block strings are not supported" + s_instance.origin + "Dev Block strings are not supported" + s_instance.scriptbundlename + "Dev Block strings are not supported");
		#/
		if(s_scenedef.vmtype == "client")
		{
			if(isdefined(level.var_283122e6) && [[level.var_283122e6]](s_instance.scriptbundlename))
			{
				continue;
			}
			if(isdefined(s_instance.SPAWNFLAGS) && s_instance.SPAWNFLAGS & 2 == 2)
			{
				s_instance thread Play();
				continue;
			}
			if(isdefined(s_instance.SPAWNFLAGS) && s_instance.SPAWNFLAGS & 1 == 1)
			{
				s_instance thread init();
			}
		}
	}
}

/*
	Name: _trigger_init
	Namespace: scene
	Checksum: 0xD2FB4DFF
	Offset: 0x6838
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function _trigger_init(trig)
{
	trig endon("entityshutdown");
	trig waittill("trigger");
	_init_instance();
}

/*
	Name: _trigger_play
	Namespace: scene
	Checksum: 0x314CD7B2
	Offset: 0x6880
	Size: 0x85
	Parameters: 1
	Flags: None
*/
function _trigger_play(trig)
{
	trig endon("entityshutdown");
	do
	{
		trig waittill("trigger");
		_play_instance();
	}
	while(!(isdefined(get_scenedef(self.scriptbundlename).looping) && get_scenedef(self.scriptbundlename).looping));
}

/*
	Name: _trigger_stop
	Namespace: scene
	Checksum: 0xDC027431
	Offset: 0x6910
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function _trigger_stop(trig)
{
	trig endon("entityshutdown");
	trig waittill("trigger");
	_stop_instance();
}

/*
	Name: add_scene_func
	Namespace: scene
	Checksum: 0xCA6922F0
	Offset: 0x6958
	Size: 0x19D
	Parameters: 4
	Flags: 32
*/
function add_scene_func(str_scenedef, func, str_state, vararg)
{
	if(!isdefined(str_state))
	{
		str_state = "play";
	}
	/#
		/#
			Assert(isdefined(get_scenedef(str_scenedef)), "Dev Block strings are not supported" + str_scenedef + "Dev Block strings are not supported");
		#/
	#/
	if(!isdefined(level.scene_funcs))
	{
		level.scene_funcs = [];
	}
	if(!isdefined(level.scene_funcs[str_scenedef]))
	{
		level.scene_funcs[str_scenedef] = [];
	}
	if(!isdefined(level.scene_funcs[str_scenedef][str_state]))
	{
		level.scene_funcs[str_scenedef][str_state] = [];
	}
	else if(!IsArray(level.scene_funcs[str_scenedef][str_state]))
	{
		level.scene_funcs[str_scenedef][str_state] = Array(level.scene_funcs[str_scenedef][str_state]);
	}
	level.scene_funcs[str_scenedef][str_state][level.scene_funcs[str_scenedef][str_state].size] = Array(func, vararg);
}

/*
	Name: remove_scene_func
	Namespace: scene
	Checksum: 0x3F26A687
	Offset: 0x6B00
	Size: 0x14D
	Parameters: 3
	Flags: None
*/
function remove_scene_func(str_scenedef, func, str_state)
{
	if(!isdefined(str_state))
	{
		str_state = "play";
	}
	/#
		/#
			Assert(isdefined(get_scenedef(str_scenedef)), "Dev Block strings are not supported" + str_scenedef + "Dev Block strings are not supported");
		#/
	#/
	if(!isdefined(level.scene_funcs))
	{
		level.scene_funcs = [];
	}
	if(isdefined(level.scene_funcs[str_scenedef]) && isdefined(level.scene_funcs[str_scenedef][str_state]))
	{
		for(i = level.scene_funcs[str_scenedef][str_state].size - 1; i >= 0; i--)
		{
			if(level.scene_funcs[str_scenedef][str_state][i][0] == func)
			{
				ArrayRemoveIndex(level.scene_funcs[str_scenedef][str_state], i);
			}
		}
	}
}

/*
	Name: spawn
	Namespace: scene
	Checksum: 0x5750D335
	Offset: 0x6C58
	Size: 0x1A7
	Parameters: 5
	Flags: None
*/
function spawn(arg1, arg2, arg3, arg4, b_test_run)
{
	str_scenedef = arg1;
	/#
		Assert(isdefined(str_scenedef), "Dev Block strings are not supported");
	#/
	if(IsVec(arg2))
	{
		v_origin = arg2;
		v_angles = arg3;
		a_ents = arg4;
	}
	else
	{
		a_ents = arg2;
		v_origin = arg3;
		v_angles = arg4;
	}
	s_instance = spawnstruct();
	if(isdefined(v_origin))
	{
	}
	else
	{
	}
	s_instance.origin = (0, 0, 0);
	if(isdefined(v_angles))
	{
	}
	else
	{
	}
	s_instance.angles = (0, 0, 0);
	s_instance.classname = "scriptbundle_scene";
	s_instance.scriptbundlename = str_scenedef;
	s_instance struct::init();
	s_instance init(str_scenedef, a_ents, undefined, b_test_run);
	return s_instance;
}

/*
	Name: init
	Namespace: scene
	Checksum: 0xCBA0D410
	Offset: 0x6E08
	Size: 0x297
	Parameters: 4
	Flags: None
*/
function init(arg1, arg2, arg3, b_test_run)
{
	if(self == level)
	{
		if(IsString(arg1))
		{
			if(IsString(arg2))
			{
				str_value = arg1;
				str_key = arg2;
				a_ents = arg3;
			}
			else
			{
				str_value = arg1;
				a_ents = arg2;
			}
			if(isdefined(str_key))
			{
				a_instances = struct::get_array(str_value, str_key);
				/#
					/#
						Assert(a_instances.size, "Dev Block strings are not supported" + str_key + "Dev Block strings are not supported" + str_value + "Dev Block strings are not supported");
					#/
				#/
			}
			else
			{
				a_instances = struct::get_array(str_value, "targetname");
				if(!a_instances.size)
				{
					a_instances = struct::get_array(str_value, "scriptbundlename");
				}
			}
			if(!a_instances.size)
			{
				_init_instance(str_value, a_ents, b_test_run);
				break;
			}
			foreach(s_instance in a_instances)
			{
				if(isdefined(s_instance))
				{
					s_instance thread _init_instance(undefined, a_ents, b_test_run);
				}
			}
		}
	}
	else if(IsString(arg1))
	{
		_init_instance(arg1, arg2, b_test_run);
	}
	else
	{
		_init_instance(arg2, arg1, b_test_run);
	}
	return self;
}

/*
	Name: get_scenedef
	Namespace: scene
	Checksum: 0xC44FF642
	Offset: 0x70A8
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function get_scenedef(str_scenedef)
{
	return struct::get_script_bundle("scene", str_scenedef);
}

/*
	Name: get_scenedefs
	Namespace: scene
	Checksum: 0x6C5F10DA
	Offset: 0x70E0
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function get_scenedefs(str_type)
{
	if(!isdefined(str_type))
	{
		str_type = "scene";
	}
	a_scenedefs = [];
	foreach(s_scenedef in struct::get_script_bundles("scene"))
	{
		if(s_scenedef.scenetype == str_type)
		{
			if(!isdefined(a_scenedefs))
			{
				a_scenedefs = [];
			}
			else if(!IsArray(a_scenedefs))
			{
				a_scenedefs = Array(a_scenedefs);
			}
			a_scenedefs[a_scenedefs.size] = s_scenedef;
		}
	}
	return a_scenedefs;
}

/*
	Name: _init_instance
	Namespace: scene
	Checksum: 0x31F219CA
	Offset: 0x7218
	Size: 0x1BB
	Parameters: 3
	Flags: None
*/
function _init_instance()
{
System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.⁪‏⁭‬‍‬‬⁯‌​‬⁫⁭‮⁬‭​‮⁬​⁫‌‪‬⁫‏⁬‍⁬‪‍​‌‍⁬‍‮⁮‪‎‮()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: Play
	Namespace: scene
	Checksum: 0x9DA0CD6A
	Offset: 0x73E0
	Size: 0x3BB
	Parameters: 5
	Flags: None
*/
function Play(arg1, arg2, arg3, b_test_run, str_mode)
{
	if(!isdefined(b_test_run))
	{
		b_test_run = 0;
	}
	if(!isdefined(str_mode))
	{
		str_mode = "";
	}
	s_tracker = spawnstruct();
	s_tracker.n_scene_count = 1;
	if(self == level)
	{
		if(IsString(arg1))
		{
			if(IsString(arg2))
			{
				str_value = arg1;
				str_key = arg2;
				a_ents = arg3;
			}
			else
			{
				str_value = arg1;
				a_ents = arg2;
			}
			str_scenedef = str_value;
			if(isdefined(str_key))
			{
				a_instances = struct::get_array(str_value, str_key);
				str_scenedef = undefined;
				/#
					/#
						Assert(a_instances.size, "Dev Block strings are not supported" + str_key + "Dev Block strings are not supported" + str_value + "Dev Block strings are not supported");
					#/
				#/
			}
			else
			{
				a_instances = struct::get_array(str_value, "targetname");
				if(!a_instances.size)
				{
					a_instances = struct::get_array(str_value, "scriptbundlename");
				}
				else
				{
					str_scenedef = undefined;
				}
			}
			if(isdefined(str_scenedef))
			{
				a_active_instances = get_active_scenes(str_scenedef);
				a_instances = ArrayCombine(a_active_instances, a_instances, 0, 0);
			}
			if(!a_instances.size)
			{
				self thread _play_instance(s_tracker, str_scenedef, a_ents, b_test_run, str_mode);
				break;
			}
			s_tracker.n_scene_count = a_instances.size;
			foreach(s_instance in a_instances)
			{
				if(isdefined(s_instance))
				{
					s_instance thread _play_instance(s_tracker, str_scenedef, a_ents, b_test_run, str_mode);
				}
			}
		}
	}
	else if(IsString(arg1))
	{
		self thread _play_instance(s_tracker, arg1, arg2, b_test_run, str_mode);
	}
	else
	{
		self thread _play_instance(s_tracker, arg2, arg1, b_test_run, str_mode);
	}
	waittill_scene_done(s_tracker);
}

/*
	Name: waittill_scene_done
	Namespace: scene
	Checksum: 0x43CD7EA2
	Offset: 0x77A8
	Size: 0x53
	Parameters: 1
	Flags: Private
*/
function private waittill_scene_done(s_tracker)
{
	level endon("demo_jump");
	for(i = 0; i < s_tracker.n_scene_count; i++)
	{
		s_tracker waittill("scene_done");
	}
}

/*
	Name: _play_instance
	Namespace: scene
	Checksum: 0xF0B42825
	Offset: 0x7808
	Size: 0x14F
	Parameters: 5
	Flags: None
*/
function _play_instance()
{
System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.⁪‏⁭‬‍‬‬⁯‌​‬⁫⁭‮⁬‭​‮⁬​⁫‌‪‬⁫‏⁬‍⁬‪‍​‌‍⁬‍‮⁮‪‎‮()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: waittill_instance_scene_done
	Namespace: scene
	Checksum: 0x6867A7DA
	Offset: 0x7960
	Size: 0x29
	Parameters: 1
	Flags: Private
*/
function private waittill_instance_scene_done(str_scenedef)
{
	level endon("demo_jump");
	self waittillmatch("scene_done");
}

/*
	Name: stop
	Namespace: scene
	Checksum: 0xE6F7D47B
	Offset: 0x7998
	Size: 0x2AB
	Parameters: 5
	Flags: None
*/
function stop(arg1, arg2, arg3, b_cancel, b_no_assert)
{
	if(!isdefined(b_no_assert))
	{
		b_no_assert = 0;
	}
	if(self == level)
	{
		if(IsString(arg1))
		{
			if(IsString(arg2))
			{
				str_value = arg1;
				str_key = arg2;
				b_clear = arg3;
			}
			else
			{
				str_value = arg1;
				b_clear = arg2;
			}
			if(isdefined(str_key))
			{
				a_instances = struct::get_array(str_value, str_key);
				/#
					/#
						Assert(b_no_assert || a_instances.size, "Dev Block strings are not supported" + str_key + "Dev Block strings are not supported" + str_value + "Dev Block strings are not supported");
					#/
				#/
				str_value = undefined;
			}
			else
			{
				a_instances = struct::get_array(str_value, "targetname");
				if(!a_instances.size)
				{
					a_instances = get_active_scenes(str_value);
				}
				else
				{
					str_value = undefined;
				}
			}
			foreach(s_instance in ArrayCopy(a_instances))
			{
				if(isdefined(s_instance))
				{
					s_instance _stop_instance(b_clear, str_value, b_cancel);
				}
			}
		}
	}
	else if(IsString(arg1))
	{
		_stop_instance(arg2, arg1, b_cancel);
	}
	else
	{
		_stop_instance(arg1, arg2, b_cancel);
	}
}

/*
	Name: _stop_instance
	Namespace: scene
	Checksum: 0xBB55AE47
	Offset: 0x7C50
	Size: 0x11D
	Parameters: 3
	Flags: None
*/
function _stop_instance()
{
System.ArgumentException: Expecting While Loop At FirstArrayKey
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.⁮‍‏‫‏⁫⁪‏⁬‪‬​‏⁯⁭‪‎​‮⁪‭‭⁭‮‪‍‬‪‍‍⁫‎⁪⁬‍‍‪‪​⁪‮()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: Cancel
	Namespace: scene
	Checksum: 0xF50F7A1A
	Offset: 0x7D78
	Size: 0x3B
	Parameters: 3
	Flags: None
*/
function Cancel(arg1, arg2, arg3)
{
	stop(arg1, arg2, arg3, 1);
}

/*
	Name: has_init_state
	Namespace: scene
	Checksum: 0x65A90505
	Offset: 0x7DC0
	Size: 0xEB
	Parameters: 1
	Flags: None
*/
function has_init_state(str_scenedef)
{
	s_scenedef = get_scenedef(str_scenedef);
	foreach(s_obj in s_scenedef.objects)
	{
		if(!isdefined(s_obj.disabled) && s_obj.disabled && s_obj _has_init_state())
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: _has_init_state
	Namespace: scene
	Checksum: 0xF51E0C3B
	Offset: 0x7EB8
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function _has_init_state()
{
	return isdefined(self.spawnoninit) && self.spawnoninit || isdefined(self.initanim) || isdefined(self.initanimloop) || (isdefined(self.firstframe) && self.firstframe);
}

/*
	Name: get_prop_count
	Namespace: scene
	Checksum: 0x33D116EF
	Offset: 0x7F08
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function get_prop_count(str_scenedef)
{
	return _get_type_count("prop", str_scenedef);
}

/*
	Name: get_vehicle_count
	Namespace: scene
	Checksum: 0x2A373B43
	Offset: 0x7F40
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function get_vehicle_count(str_scenedef)
{
	return _get_type_count("vehicle", str_scenedef);
}

/*
	Name: get_actor_count
	Namespace: scene
	Checksum: 0x28CE90AF
	Offset: 0x7F78
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function get_actor_count(str_scenedef)
{
	return _get_type_count("actor", str_scenedef);
}

/*
	Name: get_player_count
	Namespace: scene
	Checksum: 0x24EE00F3
	Offset: 0x7FB0
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function get_player_count(str_scenedef)
{
	return _get_type_count("player", str_scenedef);
}

/*
	Name: _get_type_count
	Namespace: scene
	Checksum: 0xB865B883
	Offset: 0x7FE8
	Size: 0x137
	Parameters: 2
	Flags: None
*/
function _get_type_count(str_type, str_scenedef)
{
	if(isdefined(str_scenedef))
	{
	}
	else
	{
	}
	s_scenedef = get_scenedef(self.scriptbundlename);
	n_count = 0;
	foreach(s_obj in s_scenedef.objects)
	{
		if(isdefined(s_obj.type))
		{
			if(ToLower(s_obj.type) == ToLower(str_type))
			{
				n_count++;
			}
		}
	}
	return n_count;
}

/*
	Name: is_active
	Namespace: scene
	Checksum: 0x53AE60E5
	Offset: 0x8128
	Size: 0x4D
	Parameters: 1
	Flags: None
*/
function is_active(str_scenedef)
{
	if(self == level)
	{
		return get_active_scenes(str_scenedef).size > 0;
	}
	else
	{
		return isdefined(get_active_scene(str_scenedef));
	}
}

/*
	Name: is_playing
	Namespace: scene
	Checksum: 0xF9A181B8
	Offset: 0x8180
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function is_playing(str_scenedef)
{
	if(self == level)
	{
		return level flagsys::get(str_scenedef + "_playing");
	}
	else if(!isdefined(str_scenedef))
	{
		str_scenedef = self.scriptbundlename;
	}
	o_scene = get_active_scene(str_scenedef);
	if(isdefined(o_scene))
	{
		return o_scene._str_state === "play";
	}
	return 0;
}

/*
	Name: get_active_scenes
	Namespace: scene
	Checksum: 0x97AC7EE9
	Offset: 0x8220
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function get_active_scenes(str_scenedef)
{
	if(!isdefined(level.active_scenes))
	{
		level.active_scenes = [];
	}
	if(isdefined(str_scenedef))
	{
		if(isdefined(level.active_scenes[str_scenedef]))
		{
		}
		else
		{
		}
		return [];
	}
	else
	{
		a_active_scenes = [];
		foreach(_ in level.active_scenes)
		{
			a_active_scenes = ArrayCombine(a_active_scenes, level.active_scenes[str_scenedef], 0, 0);
		}
		return a_active_scenes;
	}
}

/*
	Name: get_active_scene
	Namespace: scene
	Checksum: 0xF7F21354
	Offset: 0x8330
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function get_active_scene(str_scenedef)
{
	if(isdefined(str_scenedef) && isdefined(self.scenes))
	{
		foreach(o_scene in self.scenes)
		{
			if(get_name() == str_scenedef)
			{
				return o_scene;
			}
		}
	}
}

/*
	Name: is_capture_mode
	Namespace: scene
	Checksum: 0x7EDA69AC
	Offset: 0x83F0
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function is_capture_mode()
{
	str_mode = GetDvarString("scene_menu_mode", "default");
	if(IsSubStr(str_mode, "capture"))
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

