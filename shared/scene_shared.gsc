#using scripts\codescripts\struct;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\player_shared;
#using scripts\shared\scene_debug_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\scriptbundle_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace scene;

/*
	Name: prepare_player_model_anim
	Namespace: scene
	Checksum: 0xCC50C126
	Offset: 0xBA0
	Size: 0x57
	Parameters: 1
	Flags: Private
*/
function private prepare_player_model_anim(ent)
{
	if(!ent.animTree === "all_player")
	{
		ent useanimtree(-1);
		ent.animTree = "all_player";
	}
}

/*
	Name: prepare_generic_model_anim
	Namespace: scene
	Checksum: 0x60E80E8A
	Offset: 0xC00
	Size: 0x57
	Parameters: 1
	Flags: Private
*/
function private prepare_generic_model_anim(ent)
{
	if(!ent.animTree === "generic")
	{
		ent useanimtree(-1);
		ent.animTree = "generic";
	}
}

#namespace cSceneObject;

/*
	Name: function_9b385ca5
	Namespace: cSceneObject
	Checksum: 0xBD185AF2
	Offset: 0xC60
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
	cScriptBundleObjectBase::function_9b385ca5();
	self._is_valid = 1;
	self._b_spawnonce_used = 0;
	self._b_set_goal = 1;
}

/*
	Name: function_5fba2032
	Namespace: cSceneObject
	Checksum: 0xFA65860E
	Offset: 0xCA0
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
	Checksum: 0x67F8A621
	Offset: 0xCC0
	Size: 0x4D
	Parameters: 3
	Flags: None
*/
function first_init(s_objdef, o_scene, e_ent)
{
	cScriptBundleObjectBase::init(s_objdef, o_scene, e_ent);
	_assign_unique_name();
	return self;
}

/*
	Name: Initialize
	Namespace: cSceneObject
	Checksum: 0x49D97A04
	Offset: 0xD18
	Size: 0x443
	Parameters: 1
	Flags: None
*/
function Initialize(b_force_first_frame)
{
	if(!isdefined(b_force_first_frame))
	{
		b_force_first_frame = 0;
	}
	if(has_init_state() || b_force_first_frame)
	{
		flagsys::clear("ready");
		flagsys::clear("done");
		flagsys::clear("main_done");
		self._str_state = "init";
		self notify("NEW_STATE");
		self endon("NEW_STATE");
		self notify("init");
		cScriptBundleObjectBase::Log("init");
		waittillframeend;
		if(!isdefined(self._s.sharedIGC) && self._s.sharedIGC && (!isdefined(self._s.player) && self._s.player) && (isdefined(self._s.spawnoninit) && self._s.spawnoninit) || b_force_first_frame)
		{
			_spawn(undefined, isdefined(self._s.firstframe) && self._s.firstframe || isdefined(self._s.initanim) || isdefined(self._s.initanimloop));
		}
		if(isdefined(self._s.firstframe) && self._s.firstframe || b_force_first_frame)
		{
			if(!cScriptBundleObjectBase::error(!isdefined(self._s.mainanim), "No animation defined for first frame."))
			{
				self._str_death_anim = self._s.mainanimdeath;
				self._str_death_anim_loop = self._s.mainanimdeathloop;
				_play_anim(self._s.mainanim, 0, 0, 0);
			}
		}
		else if(isdefined(self._s.initanim))
		{
			self._str_death_anim = self._s.initanimdeath;
			self._str_death_anim_loop = self._s.initanimdeathloop;
			_play_anim(self._s.initanim, self._s.initdelaymin, self._s.initdelaymax, 1);
			if(is_alive())
			{
				if(isdefined(self._s.initanimloop))
				{
					self._str_death_anim = self._s.initanimloopdeath;
					self._str_death_anim_loop = self._s.initanimloopdeathloop;
					_play_anim(self._s.initanimloop, 0, 0, 1);
				}
			}
		}
		else if(isdefined(self._s.initanimloop))
		{
			self._str_death_anim = self._s.initanimloopdeath;
			self._str_death_anim_loop = self._s.initanimloopdeathloop;
			_play_anim(self._s.initanimloop, self._s.initdelaymin, self._s.initdelaymax, 1);
		}
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
	Checksum: 0xF71B55E7
	Offset: 0x1168
	Size: 0x573
	Parameters: 0
	Flags: None
*/
function Play()
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			if(isdefined(self._s.name))
			{
				PrintTopRightln("Dev Block strings are not supported" + self._s.name);
			}
			else
			{
				PrintTopRightln("Dev Block strings are not supported" + self._s.model);
			}
		}
	#/
	flagsys::clear("ready");
	flagsys::clear("done");
	flagsys::clear("main_done");
	self._str_state = "play";
	self notify("NEW_STATE");
	self endon("NEW_STATE");
	self notify("Play");
	cScriptBundleObjectBase::Log("play");
	waittillframeend;
	if(isdefined(self._s.Hide) && self._s.Hide && self._is_valid)
	{
		_spawn(undefined, 0, 0);
		self._e Hide();
	}
	else if(isdefined(self._s.mainanim) && self._is_valid)
	{
		self._str_death_anim = self._s.mainanimdeath;
		self._str_death_anim_loop = self._s.mainanimdeathloop;
		if(!(isdefined(self._s.IsCutScene) && self._s.IsCutScene))
		{
			if(!isdefined(self._s.mainblend) || self._s.mainblend == 0)
			{
				self._s.mainblend = 0.2;
			}
			else if(self._s.mainblend == 0.001)
			{
				self._s.mainblend = 0;
			}
		}
		_play_anim(self._s.mainanim, self._s.maindelaymin, self._s.maindelaymax, 1, self._s.mainblend, self._o_bundle.n_start_time);
		flagsys::set("main_done");
		if(isdefined(self._e) && (isdefined(self._s.dynamicpaths) && self._s.dynamicpaths))
		{
			if(Distance2DSquared(self._e.origin, self._e.scene_orig_origin) > 4)
			{
				self._e disconnectpaths(2, 0);
			}
		}
		if(is_alive())
		{
			if(!isdefined(self._s.EndBlend) || self._s.EndBlend == 0)
			{
				self._s.EndBlend = 0.2;
			}
			if(isdefined(self._s.endanim))
			{
				self._str_death_anim = self._s.endanimdeath;
				self._str_death_anim_loop = self._s.endanimdeathloop;
				_play_anim(self._s.endanim, 0, 0, 1, self._s.EndBlend);
				if(is_alive())
				{
					if(isdefined(self._s.endanimloop))
					{
						self._str_death_anim = self._s.endanimloopdeath;
						self._str_death_anim_loop = self._s.endanimloopdeathloop;
						_play_anim(self._s.endanimloop, 0, 0, 1);
					}
				}
			}
			else if(isdefined(self._s.endanimloop))
			{
				self._str_death_anim = self._s.endanimloopdeath;
				self._str_death_anim_loop = self._s.endanimloopdeathloop;
				_play_anim(self._s.endanimloop, 0, 0, 1);
			}
		}
	}
	thread finish();
}

/*
	Name: stop
	Namespace: cSceneObject
	Checksum: 0x12FF2A84
	Offset: 0x16E8
	Size: 0x21B
	Parameters: 3
	Flags: None
*/
function stop(b_clear, b_dont_clear_anim, b_finished)
{
	if(!isdefined(b_clear))
	{
		b_clear = 0;
	}
	if(!isdefined(b_dont_clear_anim))
	{
		b_dont_clear_anim = 0;
	}
	if(!isdefined(b_finished))
	{
		b_finished = 0;
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			if(isdefined(self._s.name))
			{
			}
			else
			{
			}
			PrintTopRightln(self._s.name + self._s.model);
		}
	#/
	if(isalive(self._e))
	{
		if(is_shared_player())
		{
			foreach(player in level.players)
			{
				player StopAnimScripted(0.2);
			}
		}
		else if(!isdefined(self._s.DieWhenFinished) && self._s.DieWhenFinished || !b_finished)
		{
			if(!b_dont_clear_anim || isPlayer(self._e))
			{
				self._e StopAnimScripted(0.2);
			}
		}
	}
	finish(b_clear, !b_finished);
}

/*
	Name: get_align_ent
	Namespace: cSceneObject
	Checksum: 0x589E4BDD
	Offset: 0x1910
	Size: 0x1C3
	Parameters: 0
	Flags: None
*/
function get_align_ent()
{
	e_align = undefined;
	if(isdefined(self._s.aligntarget) && !self._s.aligntarget === self._o_bundle._s.aligntarget)
	{
		a_scene_ents = get_ents();
		if(isdefined(a_scene_ents[self._s.aligntarget]))
		{
			e_align = a_scene_ents[self._s.aligntarget];
		}
		else
		{
			e_align = scene::get_existing_ent(self._s.aligntarget, 0, 1);
		}
		if(!isdefined(e_align))
		{
			if(isdefined(self._s.aligntarget))
			{
			}
			else
			{
			}
			str_msg = "" + self._s.aligntarget + "" + "' doesn't exist for scene object.";
			if(!cScriptBundleObjectBase::warning(self._o_bundle._testing, str_msg))
			{
				cScriptBundleObjectBase::error(GetDvarInt("scene_align_errors", 1), str_msg);
			}
		}
	}
	if(!isdefined(e_align))
	{
		e_align = get_align_ent();
	}
	return e_align;
}

/*
	Name: get_align_tag
	Namespace: cSceneObject
	Checksum: 0x96E156CE
	Offset: 0x1AE0
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function get_align_tag()
{
	if(isdefined(self._s.AlignTargetTag))
	{
		return self._s.AlignTargetTag;
	}
	else if(isdefined(self._o_bundle._e_root.e_scene_link))
	{
		return "tag_origin";
	}
	else
	{
		return self._o_bundle._s.AlignTargetTag;
	}
}

/*
	Name: scene
	Namespace: cSceneObject
	Checksum: 0x707FF5E8
	Offset: 0x1B58
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function scene()
{
	return self._o_bundle;
}

/*
	Name: _on_damage_run_scene_thread
	Namespace: cSceneObject
	Checksum: 0x823860C5
	Offset: 0x1B70
	Size: 0x393
	Parameters: 0
	Flags: None
*/
function _on_damage_run_scene_thread()
{
System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.⁪‏⁭‬‍‬‬⁯‌​‬⁫⁭‮⁬‭​‮⁬​⁫‌‪‬⁫‏⁬‍⁬‪‍​‌‍⁬‍‮⁮‪‎‮()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: _assign_unique_name
	Namespace: cSceneObject
	Checksum: 0xD934056B
	Offset: 0x1F10
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function _assign_unique_name()
{
	if(is_player())
	{
		self._str_name = "player " + self._s.player;
	}
	else if(allows_multiple())
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
	Checksum: 0xE03FA585
	Offset: 0x2078
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
	Checksum: 0x2068C712
	Offset: 0x2090
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
	Checksum: 0x8F747061
	Offset: 0x20B0
	Size: 0x753
	Parameters: 3
	Flags: None
*/
function _spawn(e_spawner, b_hide, b_set_ready_when_spawned)
{
	if(!isdefined(b_hide))
	{
		b_hide = 1;
	}
	if(!isdefined(b_set_ready_when_spawned))
	{
		b_set_ready_when_spawned = 1;
	}
	if(isdefined(e_spawner))
	{
		self._e = e_spawner;
	}
	if(isdefined(self._e) && (isdefined(self._e.isDying) && self._e.isDying))
	{
		self._e delete();
	}
	if(is_player())
	{
		if(isPlayer(self._e))
		{
			self._player = self._e;
		}
		else
		{
			n_player = GetDvarInt("scene_debug_player", 0);
			if(n_player > 0)
			{
				n_player--;
				if(n_player == self._s.player)
				{
					self._player = level.activePlayers[0];
				}
			}
			else
			{
				self._player = level.activePlayers[self._s.player];
			}
		}
	}
	b_skip = self._s.type === "actor" && IsSubStr(self._o_bundle._str_mode, "noai");
	b_skip = b_skip || (self._s.type === "player" && IsSubStr(self._o_bundle._str_mode, "noplayers"));
	if(!b_skip && _should_skip_entity())
	{
		b_skip = 1;
	}
	if(!b_skip)
	{
		if(!isdefined(self._e) && is_player() && (isdefined(self._s.newplayermethod) && self._s.newplayermethod))
		{
			self._e = self._player;
		}
		else if(!isdefined(self._e) || IsSpawner(self._e))
		{
			b_allows_multiple = allows_multiple();
			if(cScriptBundleObjectBase::error(b_allows_multiple && (isdefined(self._s.nospawn) && self._s.nospawn), "Scene that allow multiple instances must be allowed to spawn (uncheck 'Do Not Spawn')."))
			{
				return;
			}
			if(!IsSpawner(self._e))
			{
				e = scene::get_existing_ent(self._str_name, b_allows_multiple);
				if(!isdefined(e) && isdefined(self._s.name))
				{
					e = scene::get_existing_ent(self._s.name, b_allows_multiple);
				}
				if(isPlayer(e))
				{
					if(!(isdefined(self._s.newplayermethod) && self._s.newplayermethod))
					{
						e = undefined;
					}
				}
				if(!isdefined(e) || IsSpawner(e) && (!isdefined(self._s.nospawn) && self._s.nospawn && !self._b_spawnonce_used || self._o_bundle._testing))
				{
					e_spawned = spawn_ent(e);
				}
			}
			else
			{
				e_spawned = spawn_ent(self._e);
			}
			if(isdefined(e_spawned))
			{
				if(b_hide && !self._o_bundle._s scene::is_igc())
				{
					e_spawned Hide();
				}
				e_spawned DontInterpolate();
				e_spawned.scene_spawned = self._o_bundle._s.name;
				if(!isdefined(e_spawned.targetname))
				{
					e_spawned.targetname = self._s.name;
				}
				if(is_player())
				{
					e_spawned Hide();
				}
			}
			if(isdefined(e_spawned))
			{
			}
			else
			{
			}
			self._e = e;
			if(isdefined(self._s.spawnonce) && self._s.spawnonce && self._b_spawnonce_used)
			{
				return;
			}
		}
		cScriptBundleObjectBase::error(!is_player() && (!isdefined(self._s.nospawn) && self._s.nospawn) && (!isdefined(self._e) || IsSpawner(self._e)), "Object failed to spawn or doesn't exist.");
	}
	if(isdefined(self._e) && !IsSpawner(self._e))
	{
		_prepare();
		if(b_set_ready_when_spawned)
		{
			flagsys::set("ready");
		}
		if(isdefined(self._s.spawnonce) && self._s.spawnonce)
		{
			self._b_spawnonce_used = 1;
		}
	}
	else
	{
		flagsys::set("ready");
		flagsys::set("done");
		finish();
	}
}

/*
	Name: _prepare
	Namespace: cSceneObject
	Checksum: 0xDF620025
	Offset: 0x2810
	Size: 0x927
	Parameters: 0
	Flags: None
*/
function _prepare()
{
	if(isdefined(self._s.dynamicpaths) && self._s.dynamicpaths && self._str_state == "play")
	{
		self._e.scene_orig_origin = self._e.origin;
		self._e connectpaths();
	}
	if(self._e.current_scene === self._o_bundle._str_name)
	{
		trigger_scene_sequence_started(self._o_bundle, self);
		return 0;
	}
	self._e endon("death");
	if(!isdefined(self._s.IgnoreAliveCheck) && self._s.IgnoreAliveCheck && (cScriptBundleObjectBase::error(isai(self._e) && !isalive(self._e), "Trying to play a scene on a dead AI.")))
	{
		return;
	}
	if(isdefined(self._e._o_scene))
	{
		foreach(obj in self._e._o_scene._a_objects)
		{
			if(obj._e === self._e)
			{
				finish();
				break;
			}
		}
	}
	else if(!isai(self._e) && !isPlayer(self._e))
	{
		if(!is_player() || (!isdefined(self._s.newplayermethod) && self._s.newplayermethod))
		{
			if(is_player_model())
			{
				scene::prepare_player_model_anim(self._e);
			}
			else
			{
				scene::prepare_generic_model_anim(self._e);
			}
		}
	}
	if(!is_player())
	{
		if(!isdefined(self._e._scene_old_takedamage))
		{
			self._e._scene_old_takedamage = self._e.takedamage;
		}
		if(IsSentient(self._e))
		{
			self._e.takedamage = isdefined(self._e.takedamage) && self._e.takedamage && (isdefined(self._s.takedamage) && self._s.takedamage);
			if(!(isdefined(self._e.magic_bullet_shield) && self._e.magic_bullet_shield))
			{
				self._e.allowdeath = isdefined(self._s.allowdeath) && self._s.allowdeath;
			}
			if(isdefined(self._s.OverrideAICharacter) && self._s.OverrideAICharacter)
			{
				self._e DetachAll();
				self._e SetModel(self._s.model);
			}
		}
		else if(self._e.health > 0)
		{
		}
		else
		{
		}
		self._e.health = 1;
		if(self._s.type === "actor")
		{
			self._e MakeFakeAI();
			if(!(isdefined(self._s.RemoveWeapon) && self._s.RemoveWeapon))
			{
				self._e animation::attach_weapon(GetWeapon("ar_standard"));
			}
		}
		self._e.takedamage = isdefined(self._s.takedamage) && self._s.takedamage;
		self._e.allowdeath = isdefined(self._s.allowdeath) && self._s.allowdeath;
		set_objective();
		if(isdefined(self._s.dynamicpaths) && self._s.dynamicpaths)
		{
			self._e disconnectpaths(2, 0);
		}
	}
	else if(!is_shared_player())
	{
		if(isPlayer(self._player))
		{
		}
		else
		{
		}
		player = self._e;
		_prepare_player(player);
	}
	if(isdefined(self._s.RemoveWeapon) && self._s.RemoveWeapon)
	{
		if(!(isdefined(self._e.gun_removed) && self._e.gun_removed))
		{
			if(isPlayer(self._e))
			{
				self._e player::take_weapons();
			}
			else
			{
				self._e animation::detach_weapon();
			}
		}
		else
		{
			self._e._scene_old_gun_removed = 1;
		}
	}
	self._e.animName = self._str_name;
	self._e.anim_debug_name = self._s.name;
	self._e flagsys::set("scene");
	self._e flagsys::set(self._o_bundle._str_name);
	self._e.current_scene = self._o_bundle._str_name;
	self._e.finished_scene = undefined;
	self._e._o_scene = scene();
	trigger_scene_sequence_started(self._o_bundle, self);
	if(isdefined(self._e.takedamage) && self._e.takedamage)
	{
		thread _on_damage_run_scene_thread();
		thread _on_death();
	}
	if(IsActor(self._e))
	{
		thread _track_goal();
		if(isdefined(self._s.LookAtPlayer) && self._s.LookAtPlayer)
		{
			self._e LookAtEntity(level.activePlayers[0]);
		}
	}
	if(self._o_bundle._s scene::is_igc() || has_player())
	{
		if(!isPlayer(self._e))
		{
			self._e SetHighDetail(1);
		}
	}
	return 1;
}

/*
	Name: _prepare_player
	Namespace: cSceneObject
	Checksum: 0x8E965A82
	Offset: 0x3140
	Size: 0x593
	Parameters: 1
	Flags: None
*/
function _prepare_player(player)
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			PrintTopRightln("Dev Block strings are not supported");
		}
	#/
	if(isdefined(player.play_scene_transition_effect) && player.play_scene_transition_effect)
	{
		player.play_scene_transition_effect = undefined;
		play_regroup_fx_for_scene(player);
	}
	if(player.current_player_scene === self._o_bundle._str_name)
	{
		trigger_scene_sequence_started(self._o_bundle, self);
		return 0;
	}
	player SetHighDetail(1);
	if(player flagsys::get("mobile_armory_in_use"))
	{
		player flagsys::set("cancel_mobile_armory");
		player CloseMenu("ChooseClass_InGame");
		player notify("menuresponse", "ChooseClass_InGame", "cancel", player);
	}
	if(player flagsys::get("mobile_armory_begin_use"))
	{
		player util::_enableWeapon();
		player flagsys::clear("mobile_armory_begin_use");
	}
	if(GetDvarInt("scene_hide_player") > 0)
	{
		player Hide();
	}
	player.current_player_scene = self._o_bundle._str_name;
	if(!(isdefined(player.magic_bullet_shield) && player.magic_bullet_shield))
	{
		player.allowdeath = isdefined(self._s.allowdeath) && self._s.allowdeath;
	}
	player.scene_takedamage = isdefined(self._s.takedamage) && self._s.takedamage;
	if(isdefined(player.hijacked_vehicle_entity))
	{
		player.hijacked_vehicle_entity delete();
	}
	else if(player IsInVehicle())
	{
		vh_occupied = player GetVehicleOccupied();
		n_seat = vh_occupied GetOccupantSeat(player);
		vh_occupied usevehicle(player, n_seat);
	}
	revive_player(player);
	player thread scene::scene_disable_player_stuff(!isdefined(self._s.ShowHUD) && self._s.ShowHUD);
	player.player_anim_look_enabled = !isdefined(self._s.LockView) && self._s.LockView;
	if(isdefined(self._s.viewClampRight))
	{
	}
	else
	{
	}
	player.player_anim_clamp_right = 0;
	if(isdefined(self._s.viewClampLeft))
	{
	}
	else
	{
	}
	player.player_anim_clamp_left = 0;
	if(isdefined(self._s.viewClampBottom))
	{
	}
	else
	{
	}
	player.player_anim_clamp_top = 0;
	if(isdefined(self._s.viewClampBottom))
	{
	}
	else
	{
	}
	player.player_anim_clamp_bottom = 0;
	if(!isdefined(self._s.RemoveWeapon) && self._s.RemoveWeapon || (isdefined(self._s.ShowWeaponInFirstPerson) && self._s.ShowWeaponInFirstPerson) && (!isdefined(self._s.DisablePrimaryWeaponSwitch) && self._s.DisablePrimaryWeaponSwitch))
	{
		player player::switch_to_primary_weapon(1);
	}
	set_player_stance(player);
}

/*
	Name: revive_player
	Namespace: cSceneObject
	Checksum: 0xE0CE13F3
	Offset: 0x36E0
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function revive_player(player)
{
	if(player.sessionstate === "spectator")
	{
		player thread [[level.spawnPlayer]]();
	}
	else if(player laststand::player_is_in_laststand())
	{
		player notify("auto_revive");
	}
}

/*
	Name: set_player_stance
	Namespace: cSceneObject
	Checksum: 0xDECCD62E
	Offset: 0x3750
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function set_player_stance(player)
{
	if(self._s.PlayerStance === "crouch")
	{
		player AllowStand(0);
		player AllowCrouch(1);
		player AllowProne(0);
	}
	else if(self._s.PlayerStance === "prone")
	{
		player AllowStand(0);
		player AllowCrouch(0);
		player AllowProne(1);
	}
	else
	{
		player AllowStand(1);
		player AllowCrouch(0);
		player AllowProne(0);
	}
}

/*
	Name: finish
	Namespace: cSceneObject
	Checksum: 0xF9181D76
	Offset: 0x3888
	Size: 0x703
	Parameters: 2
	Flags: None
*/
function finish(b_clear, b_canceled)
{
	if(!isdefined(b_clear))
	{
		b_clear = 0;
	}
	if(!isdefined(b_canceled))
	{
		b_canceled = 0;
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			if(isdefined(self._s.name))
			{
			}
			else
			{
			}
			PrintTopRightln(self._s.name + self._s.model);
		}
	#/
	if(isdefined(self._str_state))
	{
		self._str_state = undefined;
		self notify("NEW_STATE");
		if(!is_shared_player() && !is_alive())
		{
			_cleanup();
			self._e = undefined;
			self._is_valid = 0;
		}
		else if(!is_player())
		{
			if(isdefined(self._e._scene_old_takedamage))
			{
				self._e.takedamage = self._e._scene_old_takedamage;
			}
			if(!(isdefined(self._e.magic_bullet_shield) && self._e.magic_bullet_shield))
			{
				self._e.allowdeath = 1;
			}
			self._e._scene_old_takedamage = undefined;
			self._e._scene_old_gun_removed = undefined;
		}
		else if(is_shared_player())
		{
			foreach(player in level.players)
			{
				if(player flagsys::get("shared_igc"))
				{
					_finish_player(player);
				}
			}
		}
		else if(isPlayer(self._player))
		{
		}
		else
		{
		}
		player = self._e;
		_finish_player(player);
		if(isdefined(self._s.RemoveWeapon) && self._s.RemoveWeapon && (!isdefined(self._e._scene_old_gun_removed) && self._e._scene_old_gun_removed))
		{
			if(isPlayer(self._e))
			{
				/#
					if(GetDvarInt("Dev Block strings are not supported") > 0)
					{
						if(isdefined(self._s.name))
						{
						}
						else
						{
						}
						PrintTopRightln(self._s.name + self._s.model);
					}
				#/
				self._e player::give_back_weapons();
			}
			else
			{
				if(GetDvarInt("Dev Block strings are not supported") > 0)
				{
					if(isdefined(self._s.name))
					{
					}
					else
					{
					}
					PrintTopRightln(self._s.name + self._s.model);
				}
				self._e animation::attach_weapon();
			}
			/#
			#/
		}
		if(!isPlayer(self._e))
		{
			if(isdefined(self._e))
			{
				self._e SetHighDetail(0);
			}
		}
		flagsys::set("ready");
		flagsys::set("done");
		if(isdefined(self._e))
		{
			if(!is_player())
			{
				if(is_alive() && (isdefined(self._s.deletewhenfinished) && self._s.deletewhenfinished || b_clear))
				{
					self._e thread scene::synced_delete();
				}
				else if(is_alive() && (isdefined(self._s.DieWhenFinished) && self._s.DieWhenFinished) && !b_canceled)
				{
					self._e.skipdeath = 1;
					self._e.allowdeath = 1;
					self._e.skipscenedeath = 1;
					self._e kill();
				}
			}
			if(IsActor(self._e) && isalive(self._e))
			{
				if(isdefined(self._s.DelayMovementAtEnd) && self._s.DelayMovementAtEnd)
				{
					self._e PathMode("move delayed", 1, RandomFloatRange(2, 3));
				}
				else
				{
					self._e PathMode("move allowed");
				}
				if(isdefined(self._s.LookAtPlayer) && self._s.LookAtPlayer)
				{
					self._e LookAtEntity();
				}
			}
		}
		_cleanup();
	}
}

/*
	Name: _finish_player
	Namespace: cSceneObject
	Checksum: 0xEB413B55
	Offset: 0x3F98
	Size: 0x2DB
	Parameters: 1
	Flags: None
*/
function _finish_player(player)
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			PrintTopRightln("Dev Block strings are not supported");
		}
	#/
	player.scene_set_visible_time = level.time;
	player SetVisibleToAll();
	player flagsys::clear("shared_igc");
	if(!(isdefined(player.magic_bullet_shield) && player.magic_bullet_shield))
	{
		player.allowdeath = 1;
	}
	player.current_player_scene = undefined;
	player.scene_takedamage = undefined;
	player._scene_old_gun_removed = undefined;
	player thread scene::scene_enable_player_stuff(!isdefined(self._s.ShowHUD) && self._s.ShowHUD);
	if(!has_next_scene())
	{
		if(is_player_anim_ending_early())
		{
			if(!is_skipping_scene() && is_scene_shared_sequence())
			{
				init_scene_sequence_started(self._o_bundle);
			}
			self._o_bundle thread cscene::_stop_camera_anim_on_player(player);
		}
		else if(self._o_bundle._s scene::is_igc())
		{
			self._o_bundle thread cscene::_stop_camera_anim_on_player(player);
		}
	}
	n_camera_tween_out = get_camera_tween_out();
	if(n_camera_tween_out > 0)
	{
		player StartCameraTween(n_camera_tween_out);
	}
	if(!(isdefined(self._s.DontReloadAmmo) && self._s.DontReloadAmmo))
	{
		player player::fill_current_clip();
	}
	player AllowStand(1);
	player AllowCrouch(1);
	player AllowProne(1);
	player SetHighDetail(0);
}

/*
	Name: set_objective
	Namespace: cSceneObject
	Checksum: 0x75BED9A1
	Offset: 0x4280
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function set_objective()
{
	if(!isdefined(self._e.script_objective))
	{
		if(isdefined(self._o_bundle._e_root.script_objective))
		{
			self._e.script_objective = self._o_bundle._e_root.script_objective;
		}
		else if(isdefined(self._o_bundle._s.script_objective))
		{
			self._e.script_objective = self._o_bundle._s.script_objective;
		}
	}
}

/*
	Name: _on_death
	Namespace: cSceneObject
	Checksum: 0xA654074C
	Offset: 0x4330
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function _on_death()
{
	self endon("CleanUp");
	self._e waittill("death");
	if(isdefined(self._e) && (!isdefined(self._e.skipscenedeath) && self._e.skipscenedeath))
	{
		self thread do_death_anims();
	}
}

/*
	Name: do_death_anims
	Namespace: cSceneObject
	Checksum: 0xC132012F
	Offset: 0x43A8
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function do_death_anims()
{
	ent = self._e;
	if(isai(ent) && !isdefined(self._str_death_anim) && !isdefined(self._str_death_anim_loop))
	{
		ent StopAnimScripted();
		if(IsActor(ent))
		{
			ent StartRagdoll();
		}
	}
	if(isdefined(self._str_death_anim))
	{
		ent.skipdeath = 1;
		ent animation::Play(self._str_death_anim, ent, undefined, 1, 0.2, 0);
	}
	if(isdefined(self._str_death_anim_loop))
	{
		ent.skipdeath = 1;
		ent animation::Play(self._str_death_anim_loop, ent, undefined, 1, 0, 0);
	}
}

/*
	Name: _cleanup
	Namespace: cSceneObject
	Checksum: 0xA1FC53C2
	Offset: 0x44E0
	Size: 0x1D7
	Parameters: 0
	Flags: None
*/
function _cleanup()
{
	if(isdefined(self._e) && isdefined(self._e.current_scene))
	{
		self._e flagsys::clear(self._o_bundle._str_name);
		if(self._e.current_scene == self._o_bundle._str_name)
		{
			self._e flagsys::clear("scene");
			self._e.finished_scene = self._o_bundle._str_name;
			self._e.current_scene = undefined;
			self._e._o_scene = undefined;
			if(is_player())
			{
				if(!(isdefined(self._s.newplayermethod) && self._s.newplayermethod))
				{
					self._e delete();
					thread reset_player();
				}
				self._e.animName = undefined;
			}
		}
	}
	self notify("death");
	self endon("NEW_STATE");
	waittillframeend;
	self notify("CleanUp");
	if(isai(self._e))
	{
		_set_goal();
	}
	if(isdefined(self._o_bundle) && (isdefined(self._o_bundle.scene_stopping) && self._o_bundle.scene_stopping))
	{
		self._o_bundle = undefined;
	}
}

/*
	Name: _set_goal
	Namespace: cSceneObject
	Checksum: 0x543F0381
	Offset: 0x46C0
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function _set_goal()
{
	if(!(self._e.scene_spawned === self._o_bundle._s.name && isdefined(self._e.target)))
	{
		if(!isdefined(self._e.script_forceColor))
		{
			if(!self._e flagsys::get("anim_reach"))
			{
				if(isdefined(self._e.scenegoal))
				{
					self._e SetGoal(self._e.scenegoal);
					self._e.scenegoal = undefined;
				}
				else if(self._b_set_goal)
				{
					self._e SetGoal(self._e.origin);
				}
			}
		}
	}
}

/*
	Name: _track_goal
	Namespace: cSceneObject
	Checksum: 0x8940E196
	Offset: 0x47D0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function _track_goal()
{
	self endon("CleanUp");
	self._e endon("death");
	self._e waittill("goal_changed");
	self._b_set_goal = 0;
}

/*
	Name: _play_anim
	Namespace: cSceneObject
	Checksum: 0x78721EE
	Offset: 0x4818
	Size: 0xB6B
	Parameters: 6
	Flags: None
*/
function _play_anim(animation, n_delay_min, n_delay_max, n_rate, n_blend, n_time)
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
	if(!isdefined(n_blend))
	{
		n_blend = 0.2;
	}
	if(!isdefined(n_time))
	{
		n_time = 0;
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			if(isdefined(self._s.name))
			{
				PrintTopRightln("Dev Block strings are not supported" + self._s.name);
			}
			else
			{
				PrintTopRightln("Dev Block strings are not supported" + self._s.model);
			}
		}
	#/
	if(_should_skip_anim(animation))
	{
		return;
	}
	if(n_time != 0)
	{
		n_time = get_anim_relative_start_time(self._o_bundle, animation);
	}
	n_delay = n_delay_min;
	if(n_delay_max > n_delay_min)
	{
		n_delay = RandomFloatRange(n_delay_min, n_delay_max);
	}
	do_reach = n_time == 0 && (isdefined(self._s.doreach) && self._s.doreach && (!isdefined(self._o_bundle._testing) && self._o_bundle._testing || GetDvarInt("scene_test_with_reach", 0)));
	_spawn(undefined, !do_reach, !do_reach);
	if(!IsActor(self._e))
	{
		do_reach = 0;
	}
	if(n_delay > 0)
	{
		if(n_delay > 0)
		{
			wait(n_delay);
		}
	}
	if(do_reach)
	{
		wait_till_scene_ready(scene());
		if(isdefined(self._s.DisableArrivalInReach) && self._s.DisableArrivalInReach)
		{
			self._e animation::reach(animation, get_align_ent(), get_align_tag(), 1);
		}
		else
		{
			self._e animation::reach(animation, get_align_ent(), get_align_tag());
		}
		flagsys::set("ready");
		break;
	}
	if(n_rate > 0)
	{
		wait_till_scene_ready();
		break;
	}
	if(isdefined(self._s.aligntarget))
	{
		foreach(o_obj in self._o_bundle._a_objects)
		{
			if(o_obj._str_name == self._s.aligntarget)
			{
				o_obj flagsys::wait_till("ready");
				break;
			}
		}
	}
	else if(is_alive())
	{
		align = get_align_ent();
		tag = get_align_tag();
		if(align == level)
		{
			align = (0, 0, 0);
			tag = (0, 0, 0);
		}
		if(is_shared_player())
		{
			_play_shared_player_anim(animation, align, tag, n_rate, n_time);
		}
		else if(is_player() && (!isdefined(self._s.newplayermethod) && self._s.newplayermethod))
		{
			thread link_player();
		}
		if(self._o_bundle._s scene::is_igc() || self._e.scene_spawned === self._o_bundle._s.name)
		{
			self._e DontInterpolate();
			self._e show();
		}
		n_lerp = get_lerp_time();
		if(isPlayer(self._e) && !self._o_bundle._s scene::is_igc())
		{
			n_camera_tween = get_camera_tween();
			if(n_camera_tween > 0)
			{
				self._e StartCameraTween(n_camera_tween);
			}
		}
		if(!has_next_scene())
		{
			if(isai(self._e))
			{
			}
			else
			{
			}
			n_blend_out = 0;
		}
		else
		{
			n_blend_out = 0;
		}
		if(isdefined(self._s.DieWhenFinished) && self._s.DieWhenFinished)
		{
			n_blend_out = 0;
		}
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				if(isdefined(self._s.name))
				{
				}
				else
				{
				}
				PrintTopRightln(self._s.name + self._s.model + "Dev Block strings are not supported" + animation);
			}
		#/
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				if(!isdefined(level.var_dded5f41))
				{
					level.var_dded5f41 = [];
					if(isdefined(self._s.name))
					{
					}
					else
					{
					}
					var_6a040985 = self._s.model + "Dev Block strings are not supported" + animation;
					if(!isdefined(level.var_dded5f41))
					{
						level.var_dded5f41 = [];
					}
					else if(!IsArray(level.var_dded5f41))
					{
						level.var_dded5f41 = Array(level.var_dded5f41);
					}
					level.var_dded5f41[level.var_dded5f41.size] = var_6a040985;
				}
			}
		#/
		self.current_playing_anim = animation;
		if(isdefined(is_skipping_scene()) && is_skipping_scene() && n_rate != 0)
		{
			thread skip_scene(1);
		}
		self._e animation::Play(animation, align, tag, n_rate, n_blend, n_blend_out, n_lerp, n_time, self._s.ShowWeaponInFirstPerson);
		if(!isdefined(self._e) || !self._e IsPlayingAnimScripted())
		{
			self.current_playing_anim = undefined;
		}
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				if(isdefined(level.var_dded5f41))
				{
					for(i = 0; i < level.var_dded5f41.size; i++)
					{
						if(isdefined(self._s.name))
						{
						}
						else
						{
						}
						var_6a040985 = self._s.model + "Dev Block strings are not supported" + animation;
						if(level.var_dded5f41[i] == var_6a040985)
						{
							ArrayRemoveValue(level.var_dded5f41, var_6a040985);
							i--;
							continue;
						}
					}
				}
			}
		#/
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				if(isdefined(self._s.name))
				{
				}
				else
				{
				}
				PrintTopRightln(self._s.name + self._s.model + "Dev Block strings are not supported" + animation);
			}
		#/
	}
	else
	{
		cScriptBundleObjectBase::Log("Dev Block strings are not supported" + animation + "Dev Block strings are not supported");
	}
	/#
	#/
	self._is_valid = is_alive() && !in_a_different_scene();
}

/*
	Name: spawn_ent
	Namespace: cSceneObject
	Checksum: 0x2799129B
	Offset: 0x5390
	Size: 0x28D
	Parameters: 1
	Flags: None
*/
function spawn_ent(e)
{
	b_disable_throttle = self._o_bundle._s scene::is_igc() || (isdefined(self._o_bundle._s.DontThrottle) && self._o_bundle._s.DontThrottle);
	if(is_player() && (!isdefined(self._s.newplayermethod) && self._s.newplayermethod))
	{
		system::wait_till("loadout");
		m_player = util::spawn_anim_model(level.player_interactive_model);
		return m_player;
	}
	else if(isdefined(e))
	{
		if(IsSpawner(e))
		{
			/#
				if(self._o_bundle._testing)
				{
					e.count++;
				}
			#/
			if(!cScriptBundleObjectBase::error(e.count < 1, "Trying to spawn AI for scene with spawner count < 1"))
			{
				return e spawner::spawn(1, undefined, undefined, undefined, b_disable_throttle);
			}
		}
	}
	else if(isdefined(self._s.model))
	{
		new_model = undefined;
		if(is_player_model())
		{
			new_model = util::spawn_anim_player_model(self._s.model, self._o_bundle._e_root.origin, self._o_bundle._e_root.angles);
		}
		else
		{
			new_model = util::spawn_anim_model(self._s.model, self._o_bundle._e_root.origin, self._o_bundle._e_root.angles, undefined, !b_disable_throttle);
		}
		return new_model;
	}
}

/*
	Name: _play_shared_player_anim
	Namespace: cSceneObject
	Checksum: 0x1CA0BC2D
	Offset: 0x5628
	Size: 0x34F
	Parameters: 5
	Flags: None
*/
function _play_shared_player_anim()
{
System.Exception: Function contains invalid OpCode.
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: _play_shared_player_anim_for_player
	Namespace: cSceneObject
	Checksum: 0x6DD40827
	Offset: 0x5980
	Size: 0x78B
	Parameters: 1
	Flags: None
*/
function _play_shared_player_anim_for_player(player)
{
	player endon("death");
	/#
	#/
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			PrintTopRightln("Dev Block strings are not supported" + self.player_animation);
		}
	#/
	if(!isdefined(self._o_bundle))
	{
		return;
	}
	player flagsys::set("shared_igc");
	if(player flagsys::get(self.player_animation_notify))
	{
		player flagsys::set(self.player_animation_notify + "_skip_init_clear");
	}
	player flagsys::set(self.player_animation_notify);
	if(isdefined(player GetLinkedEnt()))
	{
		player Unlink();
	}
	if(!(isdefined(self._s.DisableTransitionIn) && self._s.DisableTransitionIn))
	{
		if(player != self._player || GetDvarInt("scr_player1_postfx", 0))
		{
			if(!isdefined(player.screen_fade_menus))
			{
				if(!(isdefined(level.chyron_text_active) && level.chyron_text_active))
				{
					if(!(isdefined(player.fullscreen_black_active) && player.fullscreen_black_active))
					{
						player.play_scene_transition_effect = 1;
					}
				}
			}
		}
	}
	player show();
	player SetInvisibleToAll();
	_prepare_player(player);
	n_time_passed = GetTime() - self.player_start_time / 1000;
	n_start_time = self.player_time_frac * self.player_animation_length;
	n_time_left = self.player_animation_length - n_time_passed - n_start_time;
	n_time_frac = 1 - n_time_left / self.player_animation_length;
	if(isdefined(self._e) && player != self._e)
	{
		player DontInterpolate();
		player SetOrigin(self._e.origin);
		player SetPlayerAngles(self._e getPlayerAngles());
	}
	n_lerp = get_lerp_time();
	if(!self._o_bundle._s scene::is_igc())
	{
		n_camera_tween = get_camera_tween();
		if(n_camera_tween > 0)
		{
			player StartCameraTween(n_camera_tween);
		}
	}
	if(n_time_frac < 1)
	{
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				player Hide();
			}
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				PrintTopRightln("Dev Block strings are not supported" + self._s.name + "Dev Block strings are not supported" + self.player_animation);
			}
		#/
		str_animation = self.player_animation;
		if(player util::is_female())
		{
			if(isdefined(self._o_bundle._s.s_female_bundle))
			{
				s_bundle = self._o_bundle._s.s_female_bundle;
			}
		}
		else if(isdefined(self._o_bundle._s.s_male_bundle))
		{
			s_bundle = self._o_bundle._s.s_male_bundle;
		}
		if(isdefined(s_bundle))
		{
			foreach(s_object in s_bundle.objects)
			{
				if(isdefined(s_object) && s_object.type === "player")
				{
					str_animation = s_object.mainanim;
					break;
				}
			}
		}
		player_num = player GetEntityNumber();
		if(!isdefined(self.current_playing_anim))
		{
			self.current_playing_anim = [];
		}
		self.current_playing_anim[player_num] = str_animation;
		if(isdefined(is_skipping_scene()) && is_skipping_scene())
		{
			thread skip_scene(1);
		}
		player animation::Play(str_animation, self.player_align, self.player_tag, self.player_rate, 0, 0, n_lerp, n_time_frac, self._s.ShowWeaponInFirstPerson);
		if(!player flagsys::get(self.player_animation_notify + "_skip_init_clear"))
		{
			player flagsys::clear(self.player_animation_notify);
		}
		else
		{
			player flagsys::clear(self.player_animation_notify + "_skip_init_clear");
		}
		if(!player IsPlayingAnimScripted())
		{
			self.current_playing_anim[player_num] = undefined;
		}
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				PrintTopRightln("Dev Block strings are not supported" + self._s.name + "Dev Block strings are not supported" + self.player_animation);
			}
		#/
	}
}

/*
	Name: play_regroup_fx_for_scene
	Namespace: cSceneObject
	Checksum: 0x79BF1223
	Offset: 0x6118
	Size: 0x1EB
	Parameters: 1
	Flags: None
*/
function play_regroup_fx_for_scene(e_player)
{
	align = get_align_ent();
	v_origin = align.origin;
	v_angles = align.angles;
	tag = get_align_tag();
	if(isdefined(tag))
	{
		v_origin = align GetTagOrigin(tag);
		v_angles = align GetTagAngles(tag);
	}
	v_start = GetStartOrigin(v_origin, v_angles, self._s.mainanim);
	n_dist_sq = DistanceSquared(e_player.origin, v_start);
	if(n_dist_sq > 250000 || isdefined(e_player.hijacked_vehicle_entity) && (!isdefined(e_player.force_short_scene_transition_effect) && e_player.force_short_scene_transition_effect))
	{
		self thread regroup_invulnerability(e_player);
		e_player clientfield::increment_to_player("postfx_igc", 1);
	}
	else
	{
		e_player clientfield::increment_to_player("postfx_igc", 3);
	}
	util::wait_network_frame();
}

/*
	Name: regroup_invulnerability
	Namespace: cSceneObject
	Checksum: 0xEAB1AA8D
	Offset: 0x6310
	Size: 0x79
	Parameters: 1
	Flags: None
*/
function regroup_invulnerability(e_player)
{
	e_player endon("disconnect");
	e_player.ignoreme = 1;
	e_player.b_teleport_invulnerability = 1;
	e_player util::streamer_wait(undefined, 0, 7);
	e_player.ignoreme = 0;
	e_player.b_teleport_invulnerability = undefined;
}

/*
	Name: get_lerp_time
	Namespace: cSceneObject
	Checksum: 0x162E8AB9
	Offset: 0x6398
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function get_lerp_time()
{
	if(isPlayer(self._e))
	{
		if(isdefined(self._s.lerpTime))
		{
		}
		else
		{
		}
		return 0;
	}
	else if(isdefined(self._s.EntityLerpTime))
	{
	}
	else
	{
	}
	return 0;
}

/*
	Name: get_camera_tween
	Namespace: cSceneObject
	Checksum: 0x2B82B344
	Offset: 0x6420
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function get_camera_tween()
{
	if(isdefined(self._s.CameraTween))
	{
	}
	else
	{
	}
	return 0;
}

/*
	Name: get_camera_tween_out
	Namespace: cSceneObject
	Checksum: 0xDF496D71
	Offset: 0x6458
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function get_camera_tween_out()
{
	if(isdefined(self._s.CameraTweenOut))
	{
	}
	else
	{
	}
	return 0;
}

/*
	Name: link_player
	Namespace: cSceneObject
	Checksum: 0x81F5C579
	Offset: 0x6490
	Size: 0x39B
	Parameters: 0
	Flags: None
*/
function link_player()
{
System.InvalidOperationException: Stack empty.
   at System.ThrowHelper.ThrowInvalidOperationException(ExceptionResource resource)
   at System.Collections.Generic.Stack`1.Pop()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‍‬‎‎⁯‪‌‌‏⁪‍‬⁯‮‌⁭⁬⁮‬‌‎‎‏‎‫⁪⁮⁭⁪​⁫‌⁯⁯‎⁪​‌‌⁬‮(String , Int32 , Boolean , Boolean )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.​‮‍‬⁯⁭‍⁫‌‭‎⁫‪⁮‏‏⁯⁫‏‏‮⁫⁪‫‪⁪⁭⁯‮⁯‭⁯‫⁯‎‏‍‌⁫‪‮(ScriptOp , ⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: reset_player
	Namespace: cSceneObject
	Checksum: 0xEB7E7615
	Offset: 0x6838
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function reset_player()
{
	level flag::wait_till("all_players_spawned");
	player = self._player;
	player enableUsability();
	player EnableOffhandWeapons();
	player enableWeapons();
	player show();
}

/*
	Name: has_init_state
	Namespace: cSceneObject
	Checksum: 0xB1BD7DB9
	Offset: 0x68D8
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
	Checksum: 0x4EFABA94
	Offset: 0x6900
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function is_alive()
{
	return isdefined(self._e) && (self._e.health > 0 || self._s.IgnoreAliveCheck === 1);
}

/*
	Name: is_player
	Namespace: cSceneObject
	Checksum: 0xC429227B
	Offset: 0x6948
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function is_player()
{
	return isdefined(self._s.player);
}

/*
	Name: is_player_model
	Namespace: cSceneObject
	Checksum: 0x732F0216
	Offset: 0x6968
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function is_player_model()
{
	return self._s.type === "player model";
}

/*
	Name: is_shared_player
	Namespace: cSceneObject
	Checksum: 0x5B09655E
	Offset: 0x6990
	Size: 0x39
	Parameters: 0
	Flags: None
*/
function is_shared_player()
{
	return isdefined(self._s.player) && (isdefined(self._s.sharedIGC) && self._s.sharedIGC);
}

/*
	Name: in_a_different_scene
	Namespace: cSceneObject
	Checksum: 0x16D8F436
	Offset: 0x69D8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function in_a_different_scene()
{
	return isdefined(self._e) && isdefined(self._e.current_scene) && self._e.current_scene != self._o_bundle._str_name;
}

/*
	Name: _should_skip_anim
	Namespace: cSceneObject
	Checksum: 0x857799C5
	Offset: 0x6A28
	Size: 0x175
	Parameters: 1
	Flags: None
*/
function _should_skip_anim(animation)
{
	if(!isdefined(self._s.player) && self._s.player && (!isdefined(self._s.sharedIGC) && self._s.sharedIGC) && (!isdefined(self._s.KeepWhileSkipping) && self._s.KeepWhileSkipping) && (isdefined(is_skipping_scene()) && is_skipping_scene()) && (isdefined(self._s.deletewhenfinished) && self._s.deletewhenfinished))
	{
		if(!AnimHasImportantNotifies(animation))
		{
			if(!IsSpawner(self._e))
			{
				b_allows_multiple = allows_multiple();
				e = scene::get_existing_ent(self._str_name, b_allows_multiple);
				if(isdefined(e))
				{
					return 0;
				}
			}
			return 1;
		}
	}
	return 0;
}

/*
	Name: _should_skip_entity
	Namespace: cSceneObject
	Checksum: 0xB07EB728
	Offset: 0x6BA8
	Size: 0x215
	Parameters: 0
	Flags: None
*/
function _should_skip_entity()
{
	if(!isdefined(self._s.player) && self._s.player && (!isdefined(self._s.sharedIGC) && self._s.sharedIGC) && (!isdefined(self._s.KeepWhileSkipping) && self._s.KeepWhileSkipping) && (isdefined(is_skipping_scene()) && is_skipping_scene()) && (isdefined(self._s.deletewhenfinished) && self._s.deletewhenfinished))
	{
		if(isdefined(self._s.initanim) && AnimHasImportantNotifies(self._s.initanim))
		{
			return 0;
		}
		if(isdefined(self._s.mainanim) && AnimHasImportantNotifies(self._s.mainanim))
		{
			return 0;
		}
		if(isdefined(self._s.endanim) && AnimHasImportantNotifies(self._s.endanim))
		{
			return 0;
		}
		if(!IsSpawner(self._e))
		{
			b_allows_multiple = allows_multiple();
			e = scene::get_existing_ent(self._str_name, b_allows_multiple);
			if(isdefined(e))
			{
				return 0;
			}
		}
		return 1;
	}
	return 0;
}

/*
	Name: skip_anim_on_client
	Namespace: cSceneObject
	Checksum: 0x507B2946
	Offset: 0x6DC8
	Size: 0x8B
	Parameters: 2
	Flags: Private
*/
function private skip_anim_on_client(entity, anim_name)
{
	if(!isdefined(anim_name))
	{
		return;
	}
	if(!isdefined(entity))
	{
		return;
	}
	if(!entity IsPlayingAnimScripted())
	{
		return;
	}
	is_looping = IsAnimLooping(anim_name);
	if(is_looping)
	{
		return;
	}
	entity clientfield::increment("player_scene_animation_skip");
}

/*
	Name: skip_anim_on_server
	Namespace: cSceneObject
	Checksum: 0xA770363A
	Offset: 0x6E60
	Size: 0xBB
	Parameters: 2
	Flags: Private
*/
function private skip_anim_on_server(entity, anim_name)
{
	if(!isdefined(anim_name))
	{
		return;
	}
	if(!isdefined(entity))
	{
		return;
	}
	if(!entity IsPlayingAnimScripted())
	{
		return;
	}
	is_looping = IsAnimLooping(anim_name);
	if(is_looping)
	{
		entity animation::stop();
	}
	else
	{
		entity SetAnimTimebyName(anim_name, 1);
	}
	entity stopsounds();
}

/*
	Name: skip_scene_on_client
	Namespace: cSceneObject
	Checksum: 0xC8D00C1C
	Offset: 0x6F28
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function skip_scene_on_client()
{
	if(isdefined(self.current_playing_anim))
	{
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				PrintTopRightln("Dev Block strings are not supported" + self._s.mainanim + "Dev Block strings are not supported" + GetTime(), VectorScale((1, 1, 1), 0.8));
			}
		#/
		if(is_shared_player())
		{
			foreach(player in level.players)
			{
				skip_anim_on_client(player, self.current_playing_anim[player GetEntityNumber()]);
			}
		}
		else
		{
			skip_anim_on_client(self._e, self.current_playing_anim);
		}
		return 1;
	}
	return 0;
}

/*
	Name: skip_scene_on_server
	Namespace: cSceneObject
	Checksum: 0x3D743F93
	Offset: 0x7090
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function skip_scene_on_server()
{
	if(isdefined(self.current_playing_anim))
	{
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				PrintTopRightln("Dev Block strings are not supported" + self._s.mainanim + "Dev Block strings are not supported" + GetTime(), (1, 1, 1));
			}
		#/
		if(is_shared_player())
		{
			foreach(player in level.players)
			{
				skip_anim_on_server(player, self.current_playing_anim[player GetEntityNumber()]);
			}
		}
		else
		{
			skip_anim_on_server(self._e, self.current_playing_anim);
		}
	}
}

/*
	Name: skip_scene
	Namespace: cSceneObject
	Checksum: 0x74AB899
	Offset: 0x71E8
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function skip_scene(b_wait_one_frame)
{
	if(isdefined(b_wait_one_frame))
	{
		wait(0.05);
	}
	if(skip_scene_on_client())
	{
		wait(0.05);
	}
	skip_scene_on_server();
}

#namespace scene;

/*
	Name: cSceneObject
	Namespace: scene
	Checksum: 0xEEF50CA
	Offset: 0x7248
	Size: 0xAD5
	Parameters: 0
	Flags: 6
*/
function private autoexec cSceneObject()
{
	classes.cSceneObject[0] = spawnstruct();
	classes.cSceneObject[0].__vtable[964891661] = &cScriptBundleObjectBase::get_ent;
	classes.cSceneObject[0].__vtable[-162565429] = &cScriptBundleObjectBase::warning;
	classes.cSceneObject[0].__vtable[-32002227] = &cScriptBundleObjectBase::error;
	classes.cSceneObject[0].__vtable[1621988813] = &cScriptBundleObjectBase::Log;
	classes.cSceneObject[0].__vtable[-1017222485] = &cScriptBundleObjectBase::init;
	classes.cSceneObject[0].__vtable[1606033458] = &cScriptBundleObjectBase::function_5fba2032;
	classes.cSceneObject[0].__vtable[-1690805083] = &cScriptBundleObjectBase::function_9b385ca5;
	classes.cSceneObject[0].__vtable[-533039539] = &cSceneObject::skip_scene;
	classes.cSceneObject[0].__vtable[59785327] = &cSceneObject::skip_scene_on_server;
	classes.cSceneObject[0].__vtable[793954659] = &cSceneObject::skip_scene_on_client;
	classes.cSceneObject[0].__vtable[-1908648798] = &cSceneObject::skip_anim_on_server;
	classes.cSceneObject[0].__vtable[74477678] = &cSceneObject::skip_anim_on_client;
	classes.cSceneObject[0].__vtable[1747665309] = &cSceneObject::_should_skip_entity;
	classes.cSceneObject[0].__vtable[930261435] = &cSceneObject::_should_skip_anim;
	classes.cSceneObject[0].__vtable[-1004716425] = &cSceneObject::in_a_different_scene;
	classes.cSceneObject[0].__vtable[-1769748375] = &cSceneObject::is_shared_player;
	classes.cSceneObject[0].__vtable[9120349] = &cSceneObject::is_player_model;
	classes.cSceneObject[0].__vtable[1426764347] = &cSceneObject::is_player;
	classes.cSceneObject[0].__vtable[-1924366689] = &cSceneObject::is_alive;
	classes.cSceneObject[0].__vtable[1064337886] = &cSceneObject::has_init_state;
	classes.cSceneObject[0].__vtable[-1437057178] = &cSceneObject::reset_player;
	classes.cSceneObject[0].__vtable[458145835] = &cSceneObject::link_player;
	classes.cSceneObject[0].__vtable[-1404324058] = &cSceneObject::get_camera_tween_out;
	classes.cSceneObject[0].__vtable[1796348751] = &cSceneObject::get_camera_tween;
	classes.cSceneObject[0].__vtable[-1574922781] = &cSceneObject::get_lerp_time;
	classes.cSceneObject[0].__vtable[-1725384325] = &cSceneObject::regroup_invulnerability;
	classes.cSceneObject[0].__vtable[372641686] = &cSceneObject::play_regroup_fx_for_scene;
	classes.cSceneObject[0].__vtable[1466913678] = &cSceneObject::_play_shared_player_anim_for_player;
	classes.cSceneObject[0].__vtable[-773801222] = &cSceneObject::_play_shared_player_anim;
	classes.cSceneObject[0].__vtable[-747054044] = &cSceneObject::spawn_ent;
	classes.cSceneObject[0].__vtable[-1706684566] = &cSceneObject::_play_anim;
	classes.cSceneObject[0].__vtable[-140819375] = &cSceneObject::_track_goal;
	classes.cSceneObject[0].__vtable[-1068382246] = &cSceneObject::_set_goal;
	classes.cSceneObject[0].__vtable[751796260] = &cSceneObject::_cleanup;
	classes.cSceneObject[0].__vtable[-480064742] = &cSceneObject::do_death_anims;
	classes.cSceneObject[0].__vtable[-1522430464] = &cSceneObject::_on_death;
	classes.cSceneObject[0].__vtable[1056386707] = &cSceneObject::set_objective;
	classes.cSceneObject[0].__vtable[-61589233] = &cSceneObject::_finish_player;
	classes.cSceneObject[0].__vtable[-1089329960] = &cSceneObject::finish;
	classes.cSceneObject[0].__vtable[-165058024] = &cSceneObject::set_player_stance;
	classes.cSceneObject[0].__vtable[724938382] = &cSceneObject::revive_player;
	classes.cSceneObject[0].__vtable[1573351179] = &cSceneObject::_prepare_player;
	classes.cSceneObject[0].__vtable[-800750439] = &cSceneObject::_prepare;
	classes.cSceneObject[0].__vtable[987150381] = &cSceneObject::_spawn;
	classes.cSceneObject[0].__vtable[-1878563751] = &cSceneObject::get_orig_name;
	classes.cSceneObject[0].__vtable[245263499] = &cSceneObject::get_name;
	classes.cSceneObject[0].__vtable[737108631] = &cSceneObject::_assign_unique_name;
	classes.cSceneObject[0].__vtable[1811815105] = &cSceneObject::_on_damage_run_scene_thread;
	classes.cSceneObject[0].__vtable[214070679] = &cSceneObject::scene;
	classes.cSceneObject[0].__vtable[-2100195004] = &cSceneObject::get_align_tag;
	classes.cSceneObject[0].__vtable[1666938539] = &cSceneObject::get_align_ent;
	classes.cSceneObject[0].__vtable[-51025227] = &cSceneObject::stop;
	classes.cSceneObject[0].__vtable[1131512199] = &cSceneObject::Play;
	classes.cSceneObject[0].__vtable[-422924033] = &cSceneObject::Initialize;
	classes.cSceneObject[0].__vtable[-1191896790] = &cSceneObject::first_init;
	classes.cSceneObject[0].__vtable[1606033458] = &cSceneObject::function_5fba2032;
	classes.cSceneObject[0].__vtable[-1690805083] = &cSceneObject::function_9b385ca5;
}

#namespace cscene;

/*
	Name: function_9b385ca5
	Namespace: cscene
	Checksum: 0xDF0F1158
	Offset: 0x7D28
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
	cScriptBundleBase::function_9b385ca5();
	self._n_object_id = 0;
	self._str_mode = "";
	self._n_streamer_req = -1;
}

/*
	Name: function_5fba2032
	Namespace: cscene
	Checksum: 0x8367A4AD
	Offset: 0x7D70
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
	Checksum: 0x563FCB33
	Offset: 0x7D90
	Size: 0x4A3
	Parameters: 5
	Flags: None
*/
function init(str_scenedef, s_scenedef, e_align, a_ents, b_test_run)
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			PrintTopRightln("Dev Block strings are not supported" + str_scenedef);
		}
		if(isdefined(level.scriptbundles["Dev Block strings are not supported"][s_scenedef.name]))
		{
			level.scriptbundles["Dev Block strings are not supported"][s_scenedef.name].Used = 1;
		}
	#/
	cScriptBundleBase::init(str_scenedef, s_scenedef, b_test_run);
	if(isdefined(s_scenedef.streamerhint) && s_scenedef.streamerhint != "" && !is_skipping_scene())
	{
		self._n_streamer_req = streamerRequest("set", s_scenedef.streamerhint);
	}
	if(IsString(self._s.MaleBundle))
	{
	}
	else
	{
	}
	self._str_notify_name = self._str_name;
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
		foreach(s_obj in a_objs)
		{
			cScriptBundleBase::add_object(first_init(new_object(), self));
		}
		self._n_request_time = GetTime();
		if(!(isdefined(self._s.DontSync) && self._s.DontSync))
		{
			add_to_sync_list();
		}
		self thread Initialize(a_ents);
	}
}

/*
	Name: add_to_sync_list
	Namespace: cscene
	Checksum: 0xF34FE90
	Offset: 0x8240
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function add_to_sync_list()
{
	if(!isdefined(level.scene_sync_list))
	{
		level.scene_sync_list = [];
	}
	if(!isdefined(level.scene_sync_list[self._n_request_time]))
	{
		level.scene_sync_list[self._n_request_time] = [];
	}
	Array::add(level.scene_sync_list[self._n_request_time], self, 0);
}

/*
	Name: remove_from_sync_list
	Namespace: cscene
	Checksum: 0x4F49CE4F
	Offset: 0x82B8
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function remove_from_sync_list()
{
	if(isdefined(level.scene_sync_list) && isdefined(level.scene_sync_list[self._n_request_time]))
	{
		ArrayRemoveValue(level.scene_sync_list[self._n_request_time], self);
		if(!level.scene_sync_list[self._n_request_time].size)
		{
			level.scene_sync_list[self._n_request_time] = undefined;
		}
	}
}

/*
	Name: new_object
	Namespace: cscene
	Checksum: 0xB65273D4
	Offset: 0x8338
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function new_object()
{
	function_9b385ca5();
	return cSceneObject;
}

/*
	Name: get_valid_object_defs
	Namespace: cscene
	Checksum: 0xF324064D
	Offset: 0x8358
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function get_valid_object_defs()
{
	a_obj_defs = [];
	foreach(s_obj in self._s.objects)
	{
		if(self._s.vmtype == "server" || s_obj.vmtype == "server")
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
	Checksum: 0x920C9A5B
	Offset: 0x8500
	Size: 0x1D3
	Parameters: 2
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
	Checksum: 0xF449872A
	Offset: 0x86E0
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
	Name: sync_with_client_scene
	Namespace: cscene
	Checksum: 0x5DE58E10
	Offset: 0x8700
	Size: 0x163
	Parameters: 2
	Flags: None
*/
function sync_with_client_scene(str_state, b_test_run)
{
	if(!isdefined(b_test_run))
	{
		b_test_run = 0;
	}
	if(self._s.vmtype == "both" && !self._s scene::is_igc())
	{
		self endon("NEW_STATE");
		wait_till_scene_ready();
		n_val = undefined;
		if(b_test_run)
		{
			switch(str_state)
			{
				case "stop":
				{
					n_val = 3;
					break;
				}
				case "init":
				{
					n_val = 4;
					break;
				}
				case "play":
				{
					n_val = 5;
					break;
				}
			}
			break;
		}
		switch(str_state)
		{
			case "stop":
			{
				n_val = 0;
				break;
			}
			case "init":
			{
				n_val = 1;
				break;
			}
			case "play":
			{
				n_val = 2;
				break;
			}
		}
		level clientfield::set(self._s.name, n_val);
	}
}

/*
	Name: assign_ents
	Namespace: cscene
	Checksum: 0x1FA40692
	Offset: 0x8870
	Size: 0x215
	Parameters: 1
	Flags: None
*/
function assign_ents(a_ents)
{
	if(!isdefined(a_ents))
	{
		a_ents = [];
	}
	else if(!IsArray(a_ents))
	{
		a_ents = Array(a_ents);
	}
	a_objects = ArrayCopy(self._a_objects);
	if(_assign_ents_by_name(a_objects, a_ents))
	{
		if(_assign_ents_by_type(a_objects, a_ents, "player", &_is_ent_player))
		{
			if(_assign_ents_by_type(a_objects, a_ents, "actor", &_is_ent_actor))
			{
				if(_assign_ents_by_type(a_objects, a_ents, "vehicle", &_is_ent_vehicle))
				{
					if(_assign_ents_by_type(a_objects, a_ents, "prop"))
					{
						foreach(ent in a_ents)
						{
							obj = Array::pop(a_objects);
							if(!cScriptBundleBase::error(!isdefined(obj), "No scene object to assign entity too.  You might have passed in more than the scene supports."))
							{
								obj._e = ent;
							}
						}
					}
				}
			}
		}
	}
}

/*
	Name: _assign_ents_by_name
	Namespace: cscene
	Checksum: 0x6AB56B48
	Offset: 0x8A90
	Size: 0x29F
	Parameters: 2
	Flags: None
*/
function _assign_ents_by_name()
{
System.Exception: Unexpected non-stack operation within jump expression
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‪⁮⁮‪‪‭‎‎‍⁪⁪⁭⁮‎⁪​‎‎⁪‏⁭‪⁬⁫‏‍​‎‬‏‏​​⁫‫⁫‭‎‭⁯‮(ScriptOp )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.​‮‍‬⁯⁭‍⁫‌‭‎⁫‪⁮‏‏⁯⁫‏‏‮⁫⁪‫‪⁪⁭⁯‮⁯‭⁯‫⁯‎‏‍‌⁫‪‮(ScriptOp , ⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‬‪‎⁭⁭⁮‎⁮⁭⁯‭‍⁯⁯⁪⁬‪‎⁪⁮‎⁭‬‪​‍‭⁪‮‪​‮‪⁯‪⁮⁬‪‮‏‮(Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‫⁯⁪​‍⁭​⁫‫⁯‮​‍‬‮‌‪‪‎‫⁫‎‭‫⁪‫⁪⁬‪‍⁮‏‌⁪​‎‎⁯‮‭‮()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: _assign_ents_by_type
	Namespace: cscene
	Checksum: 0x2B723095
	Offset: 0x8D38
	Size: 0x17F
	Parameters: 4
	Flags: None
*/
function _assign_ents_by_type(a_objects, a_ents, str_type, func_test)
{
	if(a_ents.size)
	{
		a_objects_of_type = get_objects(str_type);
		if(a_objects_of_type.size)
		{
			foreach(ent in ArrayCopy(a_ents))
			{
				if(isdefined(func_test) && [[func_test]](ent))
				{
					obj = Array::pop_front(a_objects_of_type);
					if(isdefined(obj))
					{
						obj._e = ent;
						ArrayRemoveValue(a_ents, ent, 1);
						ArrayRemoveValue(a_objects, obj);
						continue;
					}
					break;
				}
			}
		}
	}
	return a_ents.size;
}

/*
	Name: _is_ent_player
	Namespace: cscene
	Checksum: 0x741AF0F0
	Offset: 0x8EC0
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function _is_ent_player(ent)
{
	return isPlayer(ent);
}

/*
	Name: _is_ent_actor
	Namespace: cscene
	Checksum: 0x643EA8A6
	Offset: 0x8EF0
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function _is_ent_actor(ent)
{
	return IsActor(ent) || IsActorSpawner(ent);
}

/*
	Name: _is_ent_vehicle
	Namespace: cscene
	Checksum: 0x6D65A597
	Offset: 0x8F38
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function _is_ent_vehicle(ent)
{
	return isVehicle(ent) || IsVehicleSpawner(ent);
}

/*
	Name: get_objects
	Namespace: cscene
	Checksum: 0x45DDEAEB
	Offset: 0x8F80
	Size: 0x10B
	Parameters: 1
	Flags: None
*/
function get_objects(str_type)
{
	a_ret = [];
	foreach(obj in self._a_objects)
	{
		if(obj._s.type == str_type)
		{
			if(!isdefined(a_ret))
			{
				a_ret = [];
			}
			else if(!IsArray(a_ret))
			{
				a_ret = Array(a_ret);
			}
			a_ret[a_ret.size] = obj;
		}
	}
	return a_ret;
}

/*
	Name: get_anim_relative_start_time
	Namespace: cscene
	Checksum: 0x196EDE29
	Offset: 0x9098
	Size: 0xF7
	Parameters: 2
	Flags: None
*/
function get_anim_relative_start_time(animation, n_time)
{
	if(!isdefined(self.n_start_time) || self.n_start_time == 0 || !isdefined(self.longest_anim_length) || self.longest_anim_length == 0)
	{
		return n_time;
	}
	anim_length = getanimlength(animation);
	is_looping = IsAnimLooping(animation);
	n_time = self.longest_anim_length / anim_length * n_time;
	if(is_looping)
	{
		if(n_time > 0.95)
		{
			n_time = 0.95;
		}
	}
	else if(n_time > 0.99)
	{
		n_time = 0.99;
	}
	return n_time;
}

/*
	Name: is_player_anim_ending_early
	Namespace: cscene
	Checksum: 0x580C2457
	Offset: 0x9198
	Size: 0x135
	Parameters: 0
	Flags: None
*/
function is_player_anim_ending_early()
{
	max_anim_length = -1;
	player_anim_length = -1;
	foreach(obj in self._a_objects)
	{
		if(isdefined(obj._s.mainanim))
		{
			anim_length = getanimlength(obj._s.mainanim);
		}
		if(obj._s.type === "player")
		{
			player_anim_length = anim_length;
		}
		if(anim_length > max_anim_length)
		{
			max_anim_length = anim_length;
		}
	}
	return player_anim_length < max_anim_length;
}

/*
	Name: Play
	Namespace: cscene
	Checksum: 0x7B93E10E
	Offset: 0x92D8
	Size: 0xD83
	Parameters: 4
	Flags: None
*/
function Play()
{
System.ArgumentException: Expecting While Loop At FirstArrayKey
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.⁮‍‏‫‏⁫⁪‏⁬‪‬​‏⁯⁭‪‎​‮⁪‭‭⁭‮‪‍‬‪‍‍⁫‎⁪⁬‍‍‪‪​⁪‮()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: _wait_server_time
	Namespace: cscene
	Checksum: 0xF9DDB393
	Offset: 0xA068
	Size: 0xBF
	Parameters: 2
	Flags: None
*/
function _wait_server_time(n_time, n_start_time)
{
	if(!isdefined(n_start_time))
	{
		n_start_time = 0;
	}
	n_len = n_time - n_time * n_start_time;
	n_len = n_len / 0.05;
	n_len_int = Int(n_len);
	if(n_len_int != n_len)
	{
		n_len = floor(n_len);
	}
	n_server_length = n_len * 0.05;
	wait(n_server_length);
}

/*
	Name: _wait_for_camera_animation
	Namespace: cscene
	Checksum: 0x7A2FE463
	Offset: 0xA130
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function _wait_for_camera_animation(str_cam, n_start_time)
{
	self endon("skip_camera_anims");
	if(IsCamAnimLooping(str_cam))
	{
		level waittill("forever");
	}
	else
	{
		_wait_server_time(GetCamAnimTime(str_cam) / 1000, n_start_time);
	}
}

/*
	Name: _play_camera_anims
	Namespace: cscene
	Checksum: 0x8B1484DB
	Offset: 0xA1B8
	Size: 0x46B
	Parameters: 0
	Flags: None
*/
function _play_camera_anims()
{
	level endon("stop_camera_anims");
	waittillframeend;
	e_align = get_align_ent();
	if(isdefined(e_align.origin))
	{
	}
	else
	{
	}
	v_origin = (0, 0, 0);
	if(isdefined(e_align.angles))
	{
	}
	else
	{
	}
	v_angles = (0, 0, 0);
	xcam_players = [];
	if(isdefined(self._s.LinkXCamToOnePlayer) && self._s.LinkXCamToOnePlayer)
	{
		foreach(o_obj in self._a_objects)
		{
			if(isdefined(o_obj) && is_player() && !is_shared_player())
			{
				if(!isdefined(xcam_players))
				{
					xcam_players = [];
				}
				else if(!IsArray(xcam_players))
				{
					xcam_players = Array(xcam_players);
				}
				xcam_players[xcam_players.size] = o_obj._player;
			}
		}
		if(xcam_players.size == 0)
		{
			xcam_players = level.players;
		}
		else
		{
			self.a_xcam_players = xcam_players;
		}
	}
	else
	{
		xcam_players = level.players;
	}
	if(IsString(self._s.cameraswitcher))
	{
		if(!(isdefined(self._s.LinkXCamToOnePlayer) && self._s.LinkXCamToOnePlayer))
		{
			callback::on_loadout(&_play_camera_anim_on_player_callback, self);
		}
		self.camera_v_origin = v_origin;
		self.camera_v_angles = v_angles;
		self.camera_start_time = GetTime();
		Array::thread_all_ents(xcam_players, &_play_camera_anim_on_player, v_origin, v_angles, 0);
		/#
			display_dev_info();
		#/
	}
	if(IsString(self._s.extraCamSwitcher1))
	{
		Array::thread_all_ents(xcam_players, &_play_extracam_on_player, 0, self._s.extraCamSwitcher1, v_origin, v_angles);
	}
	if(IsString(self._s.extraCamSwitcher2))
	{
		Array::thread_all_ents(xcam_players, &_play_extracam_on_player, 1, self._s.extraCamSwitcher2, v_origin, v_angles);
	}
	if(IsString(self._s.extraCamSwitcher3))
	{
		Array::thread_all_ents(xcam_players, &_play_extracam_on_player, 2, self._s.extraCamSwitcher3, v_origin, v_angles);
	}
	if(IsString(self._s.extraCamSwitcher4))
	{
		Array::thread_all_ents(xcam_players, &_play_extracam_on_player, 3, self._s.extraCamSwitcher4, v_origin, v_angles);
	}
}

/*
	Name: _play_camera_anim_on_player_callback
	Namespace: cscene
	Checksum: 0x6350BAAE
	Offset: 0xA630
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function _play_camera_anim_on_player_callback(player)
{
	self thread _play_camera_anim_on_player(player, self.camera_v_origin, self.camera_v_angles, 1);
}

/*
	Name: _play_camera_anim_on_player
	Namespace: cscene
	Checksum: 0x86172340
	Offset: 0xA678
	Size: 0x11B
	Parameters: 4
	Flags: None
*/
function _play_camera_anim_on_player(player, v_origin, v_angles, ignore_initial_notetracks)
{
	player notify("new_camera_switcher");
	player DontInterpolate();
	player thread scene::scene_disable_player_stuff();
	self.played_camera_anims = 1;
	n_start_time = self.camera_start_time;
	if(!isdefined(self._s.cameraSwitcherGraphicContents) || IsMature(player))
	{
		CamAnimScripted(player, self._s.cameraswitcher, n_start_time, v_origin, v_angles);
	}
	else
	{
		CamAnimScripted(player, self._s.cameraSwitcherGraphicContents, n_start_time, v_origin, v_angles);
	}
}

/*
	Name: loop_camera_anim_to_set_up_for_capture
	Namespace: cscene
	Checksum: 0xDAA6866E
	Offset: 0xA7A0
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function loop_camera_anim_to_set_up_for_capture()
{
	level endon("stop_camera_anims");
	while(1)
	{
		_play_camera_anims();
		_wait_for_camera_animation(self._s.cameraswitcher);
	}
}

/*
	Name: _play_extracam_on_player
	Namespace: cscene
	Checksum: 0xCC122E63
	Offset: 0xA7F8
	Size: 0x63
	Parameters: 5
	Flags: None
*/
function _play_extracam_on_player(player, n_index, str_camera_anim, v_origin, v_angles)
{
	self.played_camera_anims = 1;
	ExtraCamAnimScripted(player, n_index, str_camera_anim, GetTime(), v_origin, v_angles);
}

/*
	Name: _stop_camera_anims
	Namespace: cscene
	Checksum: 0x1D1A0185
	Offset: 0xA868
	Size: 0x101
	Parameters: 0
	Flags: None
*/
function _stop_camera_anims()
{
	if(!(isdefined(self.played_camera_anims) && self.played_camera_anims))
	{
		return;
	}
	level notify("stop_camera_anims");
	xcam_players = [];
	if(isdefined(self.a_xcam_players))
	{
		xcam_players = self.a_xcam_players;
	}
	else
	{
		xcam_players = GetPlayers();
	}
	foreach(player in xcam_players)
	{
		if(isdefined(player))
		{
			self thread _stop_camera_anim_on_player(player);
		}
	}
}

/*
	Name: _stop_camera_anim_on_player
	Namespace: cscene
	Checksum: 0xFC66B766
	Offset: 0xA978
	Size: 0x1D3
	Parameters: 1
	Flags: None
*/
function _stop_camera_anim_on_player(player)
{
	player endon("disconnect");
	if(IsString(self._s.cameraswitcher))
	{
		player endon("new_camera_switcher");
		player DontInterpolate();
		EndCamAnimScripted(player);
		player thread scene::scene_enable_player_stuff();
		if(!(isdefined(self._s.LinkXCamToOnePlayer) && self._s.LinkXCamToOnePlayer))
		{
			callback::remove_on_loadout(&_play_camera_anim_on_player_callback, self);
		}
	}
	if(IsString(self._s.extraCamSwitcher1))
	{
		EndExtraCamAnimScripted(player, 0);
	}
	if(IsString(self._s.extraCamSwitcher2))
	{
		EndExtraCamAnimScripted(player, 1);
	}
	if(IsString(self._s.extraCamSwitcher3))
	{
		EndExtraCamAnimScripted(player, 2);
	}
	if(IsString(self._s.extraCamSwitcher4))
	{
		EndExtraCamAnimScripted(player, 3);
	}
}

/*
	Name: display_dev_info
	Namespace: cscene
	Checksum: 0x19F69593
	Offset: 0xAB58
	Size: 0x373
	Parameters: 0
	Flags: None
*/
function display_dev_info()
{
	if(IsString(self._s.var_d9d1ca59) && GetDvarInt("scr_show_shot_info_for_igcs", 0))
	{
		if(!isdefined(level.var_a57bfb35))
		{
			level.var_a57bfb35 = NewHudElem();
			level.var_a57bfb35.alignX = "right";
			level.var_a57bfb35.alignY = "bottom";
			level.var_a57bfb35.horzAlign = "user_right";
			level.var_a57bfb35.y = 400;
			level.var_a57bfb35.fontscale = 1.3;
			level.var_a57bfb35.color = (0.4392157, 0.5019608, 0.5647059);
			level.var_a57bfb35 setText("SCENE: " + toupper(self._s.name));
		}
		if(!isdefined(level.var_cb7e759e))
		{
			level.var_cb7e759e = NewHudElem();
			level.var_cb7e759e.alignX = "right";
			level.var_cb7e759e.alignY = "bottom";
			level.var_cb7e759e.horzAlign = "user_right";
			level.var_cb7e759e.y = 420;
			level.var_cb7e759e.fontscale = 1.3;
			level.var_cb7e759e.color = (0.4392157, 0.5019608, 0.5647059);
		}
		level.var_cb7e759e setText("SHOT: " + toupper(self._s.name));
		if(!isdefined(level.var_f180f007))
		{
			level.var_f180f007 = NewHudElem();
			level.var_f180f007.alignX = "right";
			level.var_f180f007.alignY = "bottom";
			level.var_f180f007.horzAlign = "user_right";
			level.var_f180f007.y = 440;
			level.var_f180f007.fontscale = 1.3;
			level.var_f180f007.color = (0.4392157, 0.5019608, 0.5647059);
			level.var_f180f007 setText("STATE: " + toupper(self._s.var_d9d1ca59));
		}
	}
	else
	{
		destroy_dev_info();
	}
}

/*
	Name: destroy_dev_info
	Namespace: cscene
	Checksum: 0x5BB01553
	Offset: 0xAED8
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function destroy_dev_info()
{
	if(isdefined(level.var_a57bfb35))
	{
		level.var_a57bfb35 destroy();
	}
	if(isdefined(level.var_cb7e759e))
	{
		level.var_cb7e759e destroy();
	}
	if(isdefined(level.var_f180f007))
	{
		level.var_f180f007 destroy();
	}
}

/*
	Name: is_skipping_scene
	Namespace: cscene
	Checksum: 0x5CF91DB8
	Offset: 0xAF60
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function is_skipping_scene()
{
	if(self._s.name == "cin_ram_02_04_interview_part04")
	{
		return 0;
	}
	return isdefined(self.skipping_scene) && self.skipping_scene || self._str_mode == "skip_scene" || self._str_mode == "skip_scene_player";
}

/*
	Name: is_skipping_player_scene
	Namespace: cscene
	Checksum: 0x6F2E75AE
	Offset: 0xAFC8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function is_skipping_player_scene()
{
	return isdefined(self.b_player_scene) && self.b_player_scene || self._str_mode == "skip_scene_player" && !Array::contains(level.linked_scenes, self._s.name);
}

/*
	Name: has_next_scene
	Namespace: cscene
	Checksum: 0x24D7AC82
	Offset: 0xB030
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function has_next_scene()
{
	return isdefined(self._s.nextscenebundle);
}

/*
	Name: run_next
	Namespace: cscene
	Checksum: 0x4110A62
	Offset: 0xB050
	Size: 0x42B
	Parameters: 0
	Flags: None
*/
function run_next()
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			PrintTopRightln("Dev Block strings are not supported" + GetTime());
		}
	#/
	b_run_next_scene = 0;
	if(isdefined(self._s.nextscenebundle))
	{
		self waittill("stopped", b_finished);
		if(b_finished)
		{
			b_skip_scene = is_skipping_scene();
			if(b_skip_scene)
			{
				self util::waittill_any_timeout(5, "scene_skip_completed");
				/#
					if(GetDvarInt("Dev Block strings are not supported") > 0)
					{
						PrintTopRightln("Dev Block strings are not supported" + self._s.nextscenebundle + "Dev Block strings are not supported" + GetTime(), (1, 1, 0));
					}
				#/
			}
			/#
				if(GetDvarInt("Dev Block strings are not supported") > 0)
				{
					PrintTopRightln("Dev Block strings are not supported" + self._s.nextscenebundle + "Dev Block strings are not supported" + GetTime(), (1, 0, 0));
				}
			#/
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
			else if(b_skip_scene)
			{
				if(is_skipping_player_scene())
				{
					self._str_mode = "skip_scene_player";
				}
				else
				{
					self._str_mode = "skip_scene";
				}
			}
			else
			{
				b_run_next_scene = 1;
			}
			if(allows_multiple())
			{
				self._e_root thread scene::Play(self._s.nextscenebundle, get_ents(), undefined, undefined, undefined, self._str_mode);
			}
			else
			{
				self._e_root thread scene::Play(self._s.nextscenebundle, undefined, undefined, undefined, undefined, self._str_mode);
			}
		}
	}
	if(!(isdefined(b_run_next_scene) && b_run_next_scene))
	{
		if(!is_skipping_scene())
		{
			if(is_scene_shared_sequence())
			{
				init_scene_sequence_started(0);
			}
		}
		else if(isdefined(level.linked_scenes))
		{
			ArrayRemoveValue(level.linked_scenes, self._s.name);
		}
		streamer_request_completed();
	}
}

/*
	Name: streamer_request_completed
	Namespace: cscene
	Checksum: 0x398810E3
	Offset: 0xB488
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function streamer_request_completed()
{
	if(IsString(self._s._endStreamerHint))
	{
		if(GetDvarInt("scene_hide_player") > 0)
		{
			foreach(player in level.players)
			{
				player show();
			}
		}
		streamerRequest("clear", self._s._endStreamerHint);
	}
}

/*
	Name: stop
	Namespace: cscene
	Checksum: 0xB9DFBA90
	Offset: 0xB588
	Size: 0x4F3
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
	Name: _release_object
	Namespace: cscene
	Checksum: 0x78E38572
	Offset: 0xBA88
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function _release_object()
{
	wait(0.05);
	foreach(o_obj in self._a_objects)
	{
		o_obj._o_bundle = undefined;
	}
}

/*
	Name: has_init_state
	Namespace: cscene
	Checksum: 0xE2F8F6D5
	Offset: 0xBB18
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
	Checksum: 0x448415B4
	Offset: 0xBBD0
	Size: 0x35F
	Parameters: 1
	Flags: None
*/
function _call_state_funcs(str_state)
{
	self endon("stopped");
	wait_till_scene_ready(undefined, 1);
	if(str_state == "play")
	{
		waittillframeend;
	}
	level notify(self._str_notify_name + "_" + str_state);
	if(isdefined(level.scene_funcs) && isdefined(level.scene_funcs[self._str_notify_name]) && isdefined(level.scene_funcs[self._str_notify_name][str_state]))
	{
		a_ents = get_ents();
		foreach(handler in level.scene_funcs[self._str_notify_name][str_state])
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

/*
	Name: get_ents
	Namespace: cscene
	Checksum: 0x6F1AB8A6
	Offset: 0xBF38
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function get_ents()
{
	a_ents = [];
	foreach(o_obj in self._a_objects)
	{
		ent = get_ent();
		if(isdefined(o_obj._s.name))
		{
			a_ents[o_obj._s.name] = ent;
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
	return a_ents;
}

/*
	Name: get_root
	Namespace: cscene
	Checksum: 0x15C68FCF
	Offset: 0xC088
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
	Checksum: 0x4A167F39
	Offset: 0xC0A0
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function get_align_ent()
{
	e_align = self._e_root;
	if(isdefined(self._s.aligntarget))
	{
		e_gdt_align = scene::get_existing_ent(self._s.aligntarget, 0, 1);
		if(isdefined(e_gdt_align))
		{
			e_align = e_gdt_align;
		}
		if(!isdefined(e_gdt_align))
		{
			if(isdefined(self._s.aligntarget))
			{
			}
			else
			{
			}
			str_msg = "" + self._s.aligntarget + "" + "' doesn't exist for scene.";
			if(!cScriptBundleBase::warning(self._testing, str_msg))
			{
				cScriptBundleBase::error(GetDvarInt("scene_align_errors", 1), str_msg);
			}
		}
	}
	else if(isdefined(self._e_root.e_scene_link))
	{
		e_align = self._e_root.e_scene_link;
	}
	return e_align;
}

/*
	Name: allows_multiple
	Namespace: cscene
	Checksum: 0x41A897EC
	Offset: 0xC208
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
	Checksum: 0x22F3E629
	Offset: 0xC238
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
	Checksum: 0x5F04BA51
	Offset: 0xC268
	Size: 0x13B
	Parameters: 2
	Flags: None
*/
function wait_till_scene_ready(o_exclude, b_ignore_streamer)
{
	if(!isdefined(b_ignore_streamer))
	{
		b_ignore_streamer = 0;
	}
	a_objects = [];
	if(isdefined(o_exclude))
	{
		a_objects = Array::exclude(self._a_objects, o_exclude);
	}
	else
	{
		a_objects = self._a_objects;
	}
	wait_till_objects_ready(a_objects);
	if(self._n_streamer_req != -1)
	{
		if(!b_ignore_streamer)
		{
			if(isdefined(level.wait_for_streamer_hint_scenes))
			{
				if(IsInArray(level.wait_for_streamer_hint_scenes, self._s.name))
				{
					if(!is_skipping_scene())
					{
						level util::streamer_wait(self._n_streamer_req, 0, 5);
					}
				}
			}
		}
	}
	flagsys::set("ready");
	sync_with_other_scenes();
}

/*
	Name: wait_till_objects_ready
	Namespace: cscene
	Checksum: 0xF09A4FE0
	Offset: 0xC3B0
	Size: 0xEF
	Parameters: 1
	Flags: None
*/
function wait_till_objects_ready(Array)
{
	do
	{
		recheck = 0;
		foreach(ent in Array)
		{
			if(isdefined(ent) && !ent flagsys::get("ready"))
			{
				ent util::waittill_either("death", "ready");
				recheck = 1;
				break;
			}
		}
	}
	while(!recheck);
}

/*
	Name: sync_with_other_scenes
	Namespace: cscene
	Checksum: 0x35D433C4
	Offset: 0xC4A8
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function sync_with_other_scenes()
{
	if(!isdefined(self._s.DontSync) && self._s.DontSync && isdefined(level.scene_sync_list) && IsArray(level.scene_sync_list[self._n_request_time]))
	{
		wait_till_objects_ready(level.scene_sync_list[self._n_request_time]);
	}
}

/*
	Name: get_valid_objects
	Namespace: cscene
	Checksum: 0x7A0BC075
	Offset: 0xC538
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function get_valid_objects()
{
	a_obj = [];
	foreach(obj in self._a_objects)
	{
		if(obj._is_valid)
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
	Checksum: 0xF8F81798
	Offset: 0xC638
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
	Checksum: 0xBBEAFEB1
	Offset: 0xC658
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_state()
{
	return self._str_state;
}

/*
	Name: is_scene_shared
	Namespace: cscene
	Checksum: 0xD10977B7
	Offset: 0xC670
	Size: 0x151
	Parameters: 0
	Flags: None
*/
function is_scene_shared()
{
	if(!isdefined(self._s.skip_scene) && self._s.skip_scene && !self._s scene::is_igc())
	{
		foreach(o_scene_object in self._a_objects)
		{
			if(o_scene_object._is_valid && is_shared_player())
			{
				b_shared_player = 1;
			}
		}
		if(!isdefined(b_shared_player))
		{
			/#
				if(GetDvarInt("Dev Block strings are not supported") > 0)
				{
					PrintTopRightln("Dev Block strings are not supported" + GetTime(), (1, 0, 0));
				}
			#/
			self notify("scene_skip_completed");
			return 0;
		}
	}
	return 1;
}

/*
	Name: skip_scene
	Namespace: cscene
	Checksum: 0xFA5EC6BC
	Offset: 0xC7D0
	Size: 0x721
	Parameters: 1
	Flags: None
*/
function skip_scene(b_sequence)
{
	if(isdefined(b_sequence) && b_sequence && (isdefined(self._s.DisableSceneSkipping) && self._s.DisableSceneSkipping))
	{
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				PrintTopRightln("Dev Block strings are not supported" + self._s.name + "Dev Block strings are not supported" + GetTime(), (1, 0, 0));
			}
		#/
		finish_skip_scene();
		return;
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			PrintTopRightln("Dev Block strings are not supported" + self._s.name + "Dev Block strings are not supported" + GetTime(), (0, 1, 0));
		}
	#/
	if(!(isdefined(b_sequence) && b_sequence))
	{
		if(self._str_state == "init")
		{
			while(self._str_state == "init")
			{
				wait(0.05);
			}
		}
		if(is_skipping_player_scene())
		{
			/#
				if(GetDvarInt("Dev Block strings are not supported") > 0)
				{
					PrintTopRightln("Dev Block strings are not supported" + GetTime());
				}
			#/
			/#
				if(GetDvarInt("Dev Block strings are not supported") == 0)
				{
					b_skip_fading = 0;
				}
				else
				{
					b_skip_fading = 1;
				}
			#/
			if(!(isdefined(b_skip_fading) && b_skip_fading))
			{
				foreach(player in level.players)
				{
					player FreezeControls(1);
				}
				level.suspend_scene_skip_until_fade = 1;
				level thread LUI::screen_fade(1, 1, 0, "black", 0, "scene_system");
				wait(1);
				level.suspend_scene_skip_until_fade = undefined;
			}
			SetPauseWorld(0);
		}
		while(isdefined(level.suspend_scene_skip_until_fade) && level.suspend_scene_skip_until_fade)
		{
			wait(0.05);
		}
	}
	if(isdefined(self._s.nextscenebundle))
	{
		bNextSceneExist = 1;
	}
	else
	{
		bNextSceneExist = 0;
	}
	wait_till_scene_ready();
	wait(0.05);
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			PrintTopRightln("Dev Block strings are not supported" + self._s.name + "Dev Block strings are not supported" + GetTime(), (0, 0, 1));
		}
	#/
	_call_state_funcs("skip_started");
	thread _skip_scene();
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			PrintTopRightln("Dev Block strings are not supported" + GetTime(), (0, 1, 0));
		}
	#/
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			if(isdefined(level.var_dded5f41))
			{
				for(i = 0; i < level.var_dded5f41.size; i++)
				{
					PrintTopRightln("Dev Block strings are not supported" + level.var_dded5f41[i], (1, 0, 0), -1);
				}
			}
		}
	#/
	scene_skip_timeout = GetTime() + 4000;
	while(!isdefined(self.scene_stopped) && self.scene_stopped && GetTime() < scene_skip_timeout)
	{
		wait(0.05);
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			PrintTopRightln("Dev Block strings are not supported" + self._s.name + "Dev Block strings are not supported" + GetTime(), (1, 0.5, 0));
		}
	#/
	_call_state_funcs("skip_completed");
	self notify("scene_skip_completed");
	if(!bNextSceneExist)
	{
		if(is_skipping_player_scene())
		{
			if(isdefined(level.linked_scenes))
			{
				linked_scenes_timeout = GetTime() + 4000;
				while(level.linked_scenes.size > 0 && GetTime() < linked_scenes_timeout)
				{
					wait(0.05);
				}
			}
			finish_skip_scene();
		}
		else if(isdefined(self.skipping_scene) && self.skipping_scene)
		{
			self.skipping_scene = undefined;
			if(isdefined(level.linked_scenes))
			{
				ArrayRemoveValue(level.linked_scenes, self._s.name);
			}
		}
		break;
	}
	if(is_skipping_player_scene())
	{
		if(self._s scene::is_igc())
		{
			foreach(player in level.players)
			{
				player stopsounds();
			}
		}
	}
}

/*
	Name: finish_skip_scene
	Namespace: cscene
	Checksum: 0xAB0FF12
	Offset: 0xCF00
	Size: 0x253
	Parameters: 0
	Flags: Private
*/
function private finish_skip_scene()
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			PrintTopRightln("Dev Block strings are not supported" + GetTime(), (1, 0, 0));
		}
	#/
	if(isdefined(level.player_skipping_scene))
	{
		foreach(player in level.players)
		{
			player clientfield::increment_to_player("player_scene_skip_completed");
			player FreezeControls(0);
			player stopsounds();
		}
		self.b_player_scene = undefined;
		self.skipping_scene = undefined;
		level.player_skipping_scene = undefined;
		level.linked_scenes = undefined;
		init_scene_sequence_started(0);
		level notify("scene_skip_sequence_ended");
		if(isdefined(level.BZM_SceneSeqEndedCallback))
		{
			level thread [[level.BZM_SceneSeqEndedCallback]](self._s.name);
		}
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				PrintTopRightln("Dev Block strings are not supported" + GetTime());
			}
		#/
		/#
			if(GetDvarInt("Dev Block strings are not supported") == 0)
			{
				b_skip_fading = 0;
			}
			else
			{
				b_skip_fading = 1;
			}
		#/
		if(!(isdefined(b_skip_fading) && b_skip_fading))
		{
			if(!(isdefined(level.level_ending) && level.level_ending))
			{
				level thread LUI::screen_fade(1, 0, 1, "black", 0, "scene_system");
			}
		}
	}
}

/*
	Name: _skip_scene
	Namespace: cscene
	Checksum: 0x69921A04
	Offset: 0xD160
	Size: 0x149
	Parameters: 0
	Flags: Private
*/
function private _skip_scene()
{
	self endon("stopped");
	wait(0.05);
	foreach(o_scene_object in self._a_objects)
	{
		if(o_scene_object._is_valid)
		{
			skip_scene_on_client();
		}
	}
	wait(0.05);
	foreach(o_scene_object in self._a_objects)
	{
		if(o_scene_object._is_valid)
		{
			skip_scene_on_server();
		}
	}
	self notify("skip_camera_anims", o_scene_object, o_scene_object);
}

/*
	Name: should_skip_linked_to_players_scene
	Namespace: cscene
	Checksum: 0xBCCC6F8D
	Offset: 0xD2B8
	Size: 0x6D
	Parameters: 0
	Flags: None
*/
function should_skip_linked_to_players_scene()
{
	if(isdefined(level.player_skipping_scene) && (!isdefined(self._s.DisableSceneSkipping) && self._s.DisableSceneSkipping) && Array::contains(level.linked_scenes, self._s.name))
	{
		return 1;
	}
	return 0;
}

/*
	Name: is_scene_shared_sequence
	Namespace: cscene
	Checksum: 0x96435E5A
	Offset: 0xD330
	Size: 0x1F
	Parameters: 0
	Flags: Private
*/
function private is_scene_shared_sequence()
{
	return isdefined(level.shared_scene_sequence_started) && isdefined(self._s.shared_scene_sequence);
}

/*
	Name: update_scene_sequence
	Namespace: cscene
	Checksum: 0x53FF8296
	Offset: 0xD358
	Size: 0x49
	Parameters: 0
	Flags: Private
*/
function private update_scene_sequence()
{
	if(isdefined(self._s.shared_scene_sequence))
	{
		if(isdefined(level.shared_scene_sequence_started))
		{
			level.shared_scene_sequence_name = self._s.name;
		}
		else
		{
			level.shared_scene_sequence_name = undefined;
		}
	}
}

/*
	Name: init_scene_sequence_started
	Namespace: cscene
	Checksum: 0x662B861F
	Offset: 0xD3B0
	Size: 0x221
	Parameters: 1
	Flags: Private
*/
function private init_scene_sequence_started(b_started)
{
	if(isdefined(b_started) && b_started)
	{
		scene::waittill_skip_sequence_completed();
		if(isdefined(level.shared_scene_sequence_started))
		{
			return;
		}
		self._s.shared_scene_sequence = 1;
		if(isdefined(self._s.s_female_bundle))
		{
			self._s.s_female_bundle.shared_scene_sequence = self._s.shared_scene_sequence;
		}
		if(IsString(self._s.nextscenebundle))
		{
			s_cur_bundle = scene::get_scenedef(self._s.nextscenebundle);
			while(1)
			{
				s_cur_bundle.shared_scene_sequence = self._s.shared_scene_sequence;
				if(isdefined(s_cur_bundle.s_female_bundle))
				{
					s_cur_bundle.s_female_bundle.shared_scene_sequence = self._s.shared_scene_sequence;
				}
				if(IsString(s_cur_bundle.nextscenebundle))
				{
					s_cur_bundle = scene::get_scenedef(s_cur_bundle.nextscenebundle);
				}
				else
				{
					break;
				}
			}
		}
		level.shared_scene_sequence_started = 1;
		update_scene_sequence();
		level notify("scene_sequence_started");
	}
	else if(!isdefined(level.shared_scene_sequence_started))
	{
		return;
	}
	if(isdefined(self._s.shared_scene_sequence))
	{
		level.shared_scene_sequence_started = undefined;
		update_scene_sequence();
		level notify("scene_sequence_ended", self._s.name);
	}
}

/*
	Name: trigger_scene_sequence_started
	Namespace: cscene
	Checksum: 0x3873C558
	Offset: 0xD5E0
	Size: 0x13B
	Parameters: 2
	Flags: Private
*/
function private trigger_scene_sequence_started(scene_object, entity)
{
	if(self === scene_object)
	{
		if(!is_skipping_scene())
		{
			init_scene_sequence_started(1);
		}
		return;
	}
	if(isPlayer(entity))
	{
		if(!isdefined(self._s.DisableSceneSkipping) && self._s.DisableSceneSkipping && !is_skipping_scene())
		{
			if(is_shared_player() || self._s scene::is_igc())
			{
				if(self._str_state != "init" || (isdefined(scene_object._s.initanim) || isdefined(scene_object._s.initanimloop)))
				{
					init_scene_sequence_started(1);
				}
			}
		}
	}
}

/*
	Name: has_player
	Namespace: cscene
	Checksum: 0x7A740448
	Offset: 0xD728
	Size: 0x9D
	Parameters: 0
	Flags: None
*/
function has_player()
{
	foreach(obj in self._a_objects)
	{
		if(obj._s.type === "player")
		{
			return 1;
		}
	}
	return 0;
}

#namespace scene;

/*
	Name: cscene
	Namespace: scene
	Checksum: 0x2AD662AC
	Offset: 0xD7D0
	Size: 0xE35
	Parameters: 0
	Flags: 6
*/
function private autoexec cscene()
{
	classes.cscene[0] = spawnstruct();
	classes.cscene[0].__vtable[-162565429] = &cScriptBundleBase::warning;
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
	classes.cscene[0].__vtable[-1880665427] = &cscene::has_player;
	classes.cscene[0].__vtable[-1576975760] = &cscene::trigger_scene_sequence_started;
	classes.cscene[0].__vtable[1513946904] = &cscene::init_scene_sequence_started;
	classes.cscene[0].__vtable[-984761095] = &cscene::update_scene_sequence;
	classes.cscene[0].__vtable[238059560] = &cscene::is_scene_shared_sequence;
	classes.cscene[0].__vtable[1986348612] = &cscene::should_skip_linked_to_players_scene;
	classes.cscene[0].__vtable[-526572144] = &cscene::_skip_scene;
	classes.cscene[0].__vtable[1874227759] = &cscene::finish_skip_scene;
	classes.cscene[0].__vtable[-533039539] = &cscene::skip_scene;
	classes.cscene[0].__vtable[-1865989864] = &cscene::is_scene_shared;
	classes.cscene[0].__vtable[1194857509] = &cscene::get_state;
	classes.cscene[0].__vtable[-498584435] = &cscene::on_error;
	classes.cscene[0].__vtable[-241958475] = &cscene::get_valid_objects;
	classes.cscene[0].__vtable[12225688] = &cscene::sync_with_other_scenes;
	classes.cscene[0].__vtable[1456932829] = &cscene::wait_till_objects_ready;
	classes.cscene[0].__vtable[792158469] = &cscene::wait_till_scene_ready;
	classes.cscene[0].__vtable[17277842] = &cscene::is_looping;
	classes.cscene[0].__vtable[400356434] = &cscene::allows_multiple;
	classes.cscene[0].__vtable[1666938539] = &cscene::get_align_ent;
	classes.cscene[0].__vtable[1282680066] = &cscene::get_root;
	classes.cscene[0].__vtable[64630156] = &cscene::get_ents;
	classes.cscene[0].__vtable[415171386] = &cscene::_call_state_funcs;
	classes.cscene[0].__vtable[1064337886] = &cscene::has_init_state;
	classes.cscene[0].__vtable[-494029713] = &cscene::_release_object;
	classes.cscene[0].__vtable[-51025227] = &cscene::stop;
	classes.cscene[0].__vtable[-452669220] = &cscene::streamer_request_completed;
	classes.cscene[0].__vtable[-1243624088] = &cscene::run_next;
	classes.cscene[0].__vtable[214463356] = &cscene::has_next_scene;
	classes.cscene[0].__vtable[-1889990966] = &cscene::is_skipping_player_scene;
	classes.cscene[0].__vtable[-1402092568] = &cscene::is_skipping_scene;
	classes.cscene[0].__vtable[-2083104676] = &cscene::destroy_dev_info;
	classes.cscene[0].__vtable[2077358244] = &cscene::display_dev_info;
	classes.cscene[0].__vtable[-2028962726] = &cscene::_stop_camera_anim_on_player;
	classes.cscene[0].__vtable[-890532943] = &cscene::_stop_camera_anims;
	classes.cscene[0].__vtable[229949954] = &cscene::_play_extracam_on_player;
	classes.cscene[0].__vtable[-1903538323] = &cscene::loop_camera_anim_to_set_up_for_capture;
	classes.cscene[0].__vtable[1001613456] = &cscene::_play_camera_anim_on_player;
	classes.cscene[0].__vtable[1009630058] = &cscene::_play_camera_anim_on_player_callback;
	classes.cscene[0].__vtable[238037755] = &cscene::_play_camera_anims;
	classes.cscene[0].__vtable[-270289448] = &cscene::_wait_for_camera_animation;
	classes.cscene[0].__vtable[-1564828019] = &cscene::_wait_server_time;
	classes.cscene[0].__vtable[1131512199] = &cscene::Play;
	classes.cscene[0].__vtable[1999725373] = &cscene::is_player_anim_ending_early;
	classes.cscene[0].__vtable[1436097111] = &cscene::get_anim_relative_start_time;
	classes.cscene[0].__vtable[-512051494] = &cscene::get_objects;
	classes.cscene[0].__vtable[308264447] = &cscene::_is_ent_vehicle;
	classes.cscene[0].__vtable[1875786724] = &cscene::_is_ent_actor;
	classes.cscene[0].__vtable[1760832570] = &cscene::_is_ent_player;
	classes.cscene[0].__vtable[328967479] = &cscene::_assign_ents_by_type;
	classes.cscene[0].__vtable[1017166354] = &cscene::_assign_ents_by_name;
	classes.cscene[0].__vtable[1526733891] = &cscene::assign_ents;
	classes.cscene[0].__vtable[-569738146] = &cscene::sync_with_client_scene;
	classes.cscene[0].__vtable[-1443067443] = &cscene::get_object_id;
	classes.cscene[0].__vtable[-422924033] = &cscene::Initialize;
	classes.cscene[0].__vtable[-794265383] = &cscene::get_valid_object_defs;
	classes.cscene[0].__vtable[900706181] = &cscene::new_object;
	classes.cscene[0].__vtable[1130660665] = &cscene::remove_from_sync_list;
	classes.cscene[0].__vtable[614912131] = &cscene::add_to_sync_list;
	classes.cscene[0].__vtable[-1017222485] = &cscene::init;
	classes.cscene[0].__vtable[1606033458] = &cscene::function_5fba2032;
	classes.cscene[0].__vtable[-1690805083] = &cscene::function_9b385ca5;
}

#namespace cAwarenessSceneObject;

/*
	Name: Play
	Namespace: cAwarenessSceneObject
	Checksum: 0xB31AC001
	Offset: 0xE610
	Size: 0x29B
	Parameters: 1
	Flags: None
*/
function Play(str_alert_state)
{
	flagsys::clear("ready");
	flagsys::clear("done");
	flagsys::clear("main_done");
	self._str_state = "play";
	self notify("NEW_STATE");
	self endon("NEW_STATE");
	self notify("Play");
	cScriptBundleObjectBase::Log("play");
	waittillframeend;
	switch(str_alert_state)
	{
		case "low_alert":
		{
			cScriptBundleObjectBase::Log("LOW ALERT");
			if(isdefined(self._s.LowAlertAnim))
			{
				self._str_death_anim = self._s.LowAlertAnimDeath;
				self._str_death_anim_loop = self._s.LowAlertAnimDeathLoop;
				cSceneObject::_play_anim(self._s.LowAlertAnim);
			}
			break;
		}
		case "high_alert":
		{
			cScriptBundleObjectBase::Log("HIGH ALERT");
			if(isdefined(self._s.HighAlertAnim))
			{
				self._str_death_anim = self._s.HighAlertAnimDeath;
				self._str_death_anim_loop = self._s.HighAlertAnimDeathLoop;
				cSceneObject::_play_anim(self._s.HighAlertAnim);
			}
			break;
		}
		case "combat":
		{
			cScriptBundleObjectBase::Log("COMBAT ALERT");
			if(isdefined(self._s.CombatAlertAnim))
			{
				self._str_death_anim = self._s.CombatAlertAnimDeath;
				self._str_death_anim_loop = self._s.CombatAlertAnimDeathLoop;
				cSceneObject::_play_anim(self._s.CombatAlertAnim);
			}
			break;
		}
		case default:
		{
			cScriptBundleObjectBase::error(1, "Unsupported alert state");
		}
	}
	thread cSceneObject::finish();
}

/*
	Name: _prepare
	Namespace: cAwarenessSceneObject
	Checksum: 0x8E41C8C0
	Offset: 0xE8B8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function _prepare()
{
	if(cSceneObject::_prepare())
	{
		if(isai(self._e))
		{
			thread _on_alert_run_scene_thread();
		}
	}
}

/*
	Name: _on_alert_run_scene_thread
	Namespace: cAwarenessSceneObject
	Checksum: 0xF822E1FB
	Offset: 0xE908
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function _on_alert_run_scene_thread()
{
System.Exception: Function contains invalid OpCode.
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: function_9b385ca5
	Namespace: cAwarenessSceneObject
	Checksum: 0x7C31CD6D
	Offset: 0xE9D0
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
	cSceneObject::function_9b385ca5();
}

/*
	Name: function_5fba2032
	Namespace: cAwarenessSceneObject
	Checksum: 0xC732E42C
	Offset: 0xE9F0
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
	cSceneObject::function_5fba2032();
}

#namespace scene;

/*
	Name: cAwarenessSceneObject
	Namespace: scene
	Checksum: 0x7387322E
	Offset: 0xEA10
	Size: 0xBC5
	Parameters: 0
	Flags: 6
*/
function private autoexec cAwarenessSceneObject()
{
	classes.cAwarenessSceneObject[0] = spawnstruct();
	classes.cAwarenessSceneObject[0].__vtable[964891661] = &cScriptBundleObjectBase::get_ent;
	classes.cAwarenessSceneObject[0].__vtable[-162565429] = &cScriptBundleObjectBase::warning;
	classes.cAwarenessSceneObject[0].__vtable[-32002227] = &cScriptBundleObjectBase::error;
	classes.cAwarenessSceneObject[0].__vtable[1621988813] = &cScriptBundleObjectBase::Log;
	classes.cAwarenessSceneObject[0].__vtable[-1017222485] = &cScriptBundleObjectBase::init;
	classes.cAwarenessSceneObject[0].__vtable[1606033458] = &cScriptBundleObjectBase::function_5fba2032;
	classes.cAwarenessSceneObject[0].__vtable[-1690805083] = &cScriptBundleObjectBase::function_9b385ca5;
	classes.cAwarenessSceneObject[0].__vtable[-533039539] = &cSceneObject::skip_scene;
	classes.cAwarenessSceneObject[0].__vtable[59785327] = &cSceneObject::skip_scene_on_server;
	classes.cAwarenessSceneObject[0].__vtable[793954659] = &cSceneObject::skip_scene_on_client;
	classes.cAwarenessSceneObject[0].__vtable[-1908648798] = &cSceneObject::skip_anim_on_server;
	classes.cAwarenessSceneObject[0].__vtable[74477678] = &cSceneObject::skip_anim_on_client;
	classes.cAwarenessSceneObject[0].__vtable[1747665309] = &cSceneObject::_should_skip_entity;
	classes.cAwarenessSceneObject[0].__vtable[930261435] = &cSceneObject::_should_skip_anim;
	classes.cAwarenessSceneObject[0].__vtable[-1004716425] = &cSceneObject::in_a_different_scene;
	classes.cAwarenessSceneObject[0].__vtable[-1769748375] = &cSceneObject::is_shared_player;
	classes.cAwarenessSceneObject[0].__vtable[9120349] = &cSceneObject::is_player_model;
	classes.cAwarenessSceneObject[0].__vtable[1426764347] = &cSceneObject::is_player;
	classes.cAwarenessSceneObject[0].__vtable[-1924366689] = &cSceneObject::is_alive;
	classes.cAwarenessSceneObject[0].__vtable[1064337886] = &cSceneObject::has_init_state;
	classes.cAwarenessSceneObject[0].__vtable[-1437057178] = &cSceneObject::reset_player;
	classes.cAwarenessSceneObject[0].__vtable[458145835] = &cSceneObject::link_player;
	classes.cAwarenessSceneObject[0].__vtable[-1404324058] = &cSceneObject::get_camera_tween_out;
	classes.cAwarenessSceneObject[0].__vtable[1796348751] = &cSceneObject::get_camera_tween;
	classes.cAwarenessSceneObject[0].__vtable[-1574922781] = &cSceneObject::get_lerp_time;
	classes.cAwarenessSceneObject[0].__vtable[-1725384325] = &cSceneObject::regroup_invulnerability;
	classes.cAwarenessSceneObject[0].__vtable[372641686] = &cSceneObject::play_regroup_fx_for_scene;
	classes.cAwarenessSceneObject[0].__vtable[1466913678] = &cSceneObject::_play_shared_player_anim_for_player;
	classes.cAwarenessSceneObject[0].__vtable[-773801222] = &cSceneObject::_play_shared_player_anim;
	classes.cAwarenessSceneObject[0].__vtable[-747054044] = &cSceneObject::spawn_ent;
	classes.cAwarenessSceneObject[0].__vtable[-1706684566] = &cSceneObject::_play_anim;
	classes.cAwarenessSceneObject[0].__vtable[-140819375] = &cSceneObject::_track_goal;
	classes.cAwarenessSceneObject[0].__vtable[-1068382246] = &cSceneObject::_set_goal;
	classes.cAwarenessSceneObject[0].__vtable[751796260] = &cSceneObject::_cleanup;
	classes.cAwarenessSceneObject[0].__vtable[-480064742] = &cSceneObject::do_death_anims;
	classes.cAwarenessSceneObject[0].__vtable[-1522430464] = &cSceneObject::_on_death;
	classes.cAwarenessSceneObject[0].__vtable[1056386707] = &cSceneObject::set_objective;
	classes.cAwarenessSceneObject[0].__vtable[-61589233] = &cSceneObject::_finish_player;
	classes.cAwarenessSceneObject[0].__vtable[-1089329960] = &cSceneObject::finish;
	classes.cAwarenessSceneObject[0].__vtable[-165058024] = &cSceneObject::set_player_stance;
	classes.cAwarenessSceneObject[0].__vtable[724938382] = &cSceneObject::revive_player;
	classes.cAwarenessSceneObject[0].__vtable[1573351179] = &cSceneObject::_prepare_player;
	classes.cAwarenessSceneObject[0].__vtable[-800750439] = &cSceneObject::_prepare;
	classes.cAwarenessSceneObject[0].__vtable[987150381] = &cSceneObject::_spawn;
	classes.cAwarenessSceneObject[0].__vtable[-1878563751] = &cSceneObject::get_orig_name;
	classes.cAwarenessSceneObject[0].__vtable[245263499] = &cSceneObject::get_name;
	classes.cAwarenessSceneObject[0].__vtable[737108631] = &cSceneObject::_assign_unique_name;
	classes.cAwarenessSceneObject[0].__vtable[1811815105] = &cSceneObject::_on_damage_run_scene_thread;
	classes.cAwarenessSceneObject[0].__vtable[214070679] = &cSceneObject::scene;
	classes.cAwarenessSceneObject[0].__vtable[-2100195004] = &cSceneObject::get_align_tag;
	classes.cAwarenessSceneObject[0].__vtable[1666938539] = &cSceneObject::get_align_ent;
	classes.cAwarenessSceneObject[0].__vtable[-51025227] = &cSceneObject::stop;
	classes.cAwarenessSceneObject[0].__vtable[1131512199] = &cSceneObject::Play;
	classes.cAwarenessSceneObject[0].__vtable[-422924033] = &cSceneObject::Initialize;
	classes.cAwarenessSceneObject[0].__vtable[-1191896790] = &cSceneObject::first_init;
	classes.cAwarenessSceneObject[0].__vtable[1606033458] = &cSceneObject::function_5fba2032;
	classes.cAwarenessSceneObject[0].__vtable[-1690805083] = &cSceneObject::function_9b385ca5;
	classes.cAwarenessSceneObject[0].__vtable[1606033458] = &cAwarenessSceneObject::function_5fba2032;
	classes.cAwarenessSceneObject[0].__vtable[-1690805083] = &cAwarenessSceneObject::function_9b385ca5;
	classes.cAwarenessSceneObject[0].__vtable[546281630] = &cAwarenessSceneObject::_on_alert_run_scene_thread;
	classes.cAwarenessSceneObject[0].__vtable[-800750439] = &cAwarenessSceneObject::_prepare;
	classes.cAwarenessSceneObject[0].__vtable[1131512199] = &cAwarenessSceneObject::Play;
}

#namespace cAwarenessScene;

/*
	Name: new_object
	Namespace: cAwarenessScene
	Checksum: 0x327F8B3E
	Offset: 0xF5E0
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function new_object()
{
	function_9b385ca5();
	return cAwarenessSceneObject;
}

/*
	Name: init
	Namespace: cAwarenessScene
	Checksum: 0x919E126F
	Offset: 0xF600
	Size: 0x53
	Parameters: 5
	Flags: None
*/
function init(str_scenedef, s_scenedef, e_align, a_ents, b_test_run)
{
	cscene::init(str_scenedef, s_scenedef, e_align, a_ents, b_test_run);
}

/*
	Name: Play
	Namespace: cAwarenessScene
	Checksum: 0x9881489A
	Offset: 0xF660
	Size: 0x1C3
	Parameters: 1
	Flags: None
*/
function Play()
{
System.ArgumentException: Expecting While Loop At FirstArrayKey
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.⁮‍‏‫‏⁫⁪‏⁬‪‬​‏⁯⁭‪‎​‮⁪‭‭⁭‮‪‍‬‪‍‍⁫‎⁪⁬‍‍‪‪​⁪‮()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: function_9b385ca5
	Namespace: cAwarenessScene
	Checksum: 0x8B7BB795
	Offset: 0xF830
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
	cscene::function_9b385ca5();
}

/*
	Name: function_5fba2032
	Namespace: cAwarenessScene
	Checksum: 0xC404B084
	Offset: 0xF850
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
	cscene::function_5fba2032();
}

#namespace scene;

/*
	Name: cAwarenessScene
	Namespace: scene
	Checksum: 0xFB01E4CB
	Offset: 0xF870
	Size: 0xF25
	Parameters: 0
	Flags: 6
*/
function private autoexec cAwarenessScene()
{
	classes.cAwarenessScene[0] = spawnstruct();
	classes.cAwarenessScene[0].__vtable[-162565429] = &cScriptBundleBase::warning;
	classes.cAwarenessScene[0].__vtable[-32002227] = &cScriptBundleBase::error;
	classes.cAwarenessScene[0].__vtable[1621988813] = &cScriptBundleBase::Log;
	classes.cAwarenessScene[0].__vtable[713694985] = &cScriptBundleBase::remove_object;
	classes.cAwarenessScene[0].__vtable[178798596] = &cScriptBundleBase::add_object;
	classes.cAwarenessScene[0].__vtable[1440274456] = &cScriptBundleBase::is_testing;
	classes.cAwarenessScene[0].__vtable[-512051494] = &cScriptBundleBase::get_objects;
	classes.cAwarenessScene[0].__vtable[575565049] = &cScriptBundleBase::get_vm;
	classes.cAwarenessScene[0].__vtable[245263499] = &cScriptBundleBase::get_name;
	classes.cAwarenessScene[0].__vtable[1872615990] = &cScriptBundleBase::get_type;
	classes.cAwarenessScene[0].__vtable[-1017222485] = &cScriptBundleBase::init;
	classes.cAwarenessScene[0].__vtable[1606033458] = &cScriptBundleBase::function_5fba2032;
	classes.cAwarenessScene[0].__vtable[-1690805083] = &cScriptBundleBase::function_9b385ca5;
	classes.cAwarenessScene[0].__vtable[-498584435] = &cScriptBundleBase::on_error;
	classes.cAwarenessScene[0].__vtable[-1880665427] = &cscene::has_player;
	classes.cAwarenessScene[0].__vtable[-1576975760] = &cscene::trigger_scene_sequence_started;
	classes.cAwarenessScene[0].__vtable[1513946904] = &cscene::init_scene_sequence_started;
	classes.cAwarenessScene[0].__vtable[-984761095] = &cscene::update_scene_sequence;
	classes.cAwarenessScene[0].__vtable[238059560] = &cscene::is_scene_shared_sequence;
	classes.cAwarenessScene[0].__vtable[1986348612] = &cscene::should_skip_linked_to_players_scene;
	classes.cAwarenessScene[0].__vtable[-526572144] = &cscene::_skip_scene;
	classes.cAwarenessScene[0].__vtable[1874227759] = &cscene::finish_skip_scene;
	classes.cAwarenessScene[0].__vtable[-533039539] = &cscene::skip_scene;
	classes.cAwarenessScene[0].__vtable[-1865989864] = &cscene::is_scene_shared;
	classes.cAwarenessScene[0].__vtable[1194857509] = &cscene::get_state;
	classes.cAwarenessScene[0].__vtable[-498584435] = &cscene::on_error;
	classes.cAwarenessScene[0].__vtable[-241958475] = &cscene::get_valid_objects;
	classes.cAwarenessScene[0].__vtable[12225688] = &cscene::sync_with_other_scenes;
	classes.cAwarenessScene[0].__vtable[1456932829] = &cscene::wait_till_objects_ready;
	classes.cAwarenessScene[0].__vtable[792158469] = &cscene::wait_till_scene_ready;
	classes.cAwarenessScene[0].__vtable[17277842] = &cscene::is_looping;
	classes.cAwarenessScene[0].__vtable[400356434] = &cscene::allows_multiple;
	classes.cAwarenessScene[0].__vtable[1666938539] = &cscene::get_align_ent;
	classes.cAwarenessScene[0].__vtable[1282680066] = &cscene::get_root;
	classes.cAwarenessScene[0].__vtable[64630156] = &cscene::get_ents;
	classes.cAwarenessScene[0].__vtable[415171386] = &cscene::_call_state_funcs;
	classes.cAwarenessScene[0].__vtable[1064337886] = &cscene::has_init_state;
	classes.cAwarenessScene[0].__vtable[-494029713] = &cscene::_release_object;
	classes.cAwarenessScene[0].__vtable[-51025227] = &cscene::stop;
	classes.cAwarenessScene[0].__vtable[-452669220] = &cscene::streamer_request_completed;
	classes.cAwarenessScene[0].__vtable[-1243624088] = &cscene::run_next;
	classes.cAwarenessScene[0].__vtable[214463356] = &cscene::has_next_scene;
	classes.cAwarenessScene[0].__vtable[-1889990966] = &cscene::is_skipping_player_scene;
	classes.cAwarenessScene[0].__vtable[-1402092568] = &cscene::is_skipping_scene;
	classes.cAwarenessScene[0].__vtable[-2083104676] = &cscene::destroy_dev_info;
	classes.cAwarenessScene[0].__vtable[2077358244] = &cscene::display_dev_info;
	classes.cAwarenessScene[0].__vtable[-2028962726] = &cscene::_stop_camera_anim_on_player;
	classes.cAwarenessScene[0].__vtable[-890532943] = &cscene::_stop_camera_anims;
	classes.cAwarenessScene[0].__vtable[229949954] = &cscene::_play_extracam_on_player;
	classes.cAwarenessScene[0].__vtable[-1903538323] = &cscene::loop_camera_anim_to_set_up_for_capture;
	classes.cAwarenessScene[0].__vtable[1001613456] = &cscene::_play_camera_anim_on_player;
	classes.cAwarenessScene[0].__vtable[1009630058] = &cscene::_play_camera_anim_on_player_callback;
	classes.cAwarenessScene[0].__vtable[238037755] = &cscene::_play_camera_anims;
	classes.cAwarenessScene[0].__vtable[-270289448] = &cscene::_wait_for_camera_animation;
	classes.cAwarenessScene[0].__vtable[-1564828019] = &cscene::_wait_server_time;
	classes.cAwarenessScene[0].__vtable[1131512199] = &cscene::Play;
	classes.cAwarenessScene[0].__vtable[1999725373] = &cscene::is_player_anim_ending_early;
	classes.cAwarenessScene[0].__vtable[1436097111] = &cscene::get_anim_relative_start_time;
	classes.cAwarenessScene[0].__vtable[-512051494] = &cscene::get_objects;
	classes.cAwarenessScene[0].__vtable[308264447] = &cscene::_is_ent_vehicle;
	classes.cAwarenessScene[0].__vtable[1875786724] = &cscene::_is_ent_actor;
	classes.cAwarenessScene[0].__vtable[1760832570] = &cscene::_is_ent_player;
	classes.cAwarenessScene[0].__vtable[328967479] = &cscene::_assign_ents_by_type;
	classes.cAwarenessScene[0].__vtable[1017166354] = &cscene::_assign_ents_by_name;
	classes.cAwarenessScene[0].__vtable[1526733891] = &cscene::assign_ents;
	classes.cAwarenessScene[0].__vtable[-569738146] = &cscene::sync_with_client_scene;
	classes.cAwarenessScene[0].__vtable[-1443067443] = &cscene::get_object_id;
	classes.cAwarenessScene[0].__vtable[-422924033] = &cscene::Initialize;
	classes.cAwarenessScene[0].__vtable[-794265383] = &cscene::get_valid_object_defs;
	classes.cAwarenessScene[0].__vtable[900706181] = &cscene::new_object;
	classes.cAwarenessScene[0].__vtable[1130660665] = &cscene::remove_from_sync_list;
	classes.cAwarenessScene[0].__vtable[614912131] = &cscene::add_to_sync_list;
	classes.cAwarenessScene[0].__vtable[-1017222485] = &cscene::init;
	classes.cAwarenessScene[0].__vtable[1606033458] = &cscene::function_5fba2032;
	classes.cAwarenessScene[0].__vtable[-1690805083] = &cscene::function_9b385ca5;
	classes.cAwarenessScene[0].__vtable[1606033458] = &cAwarenessScene::function_5fba2032;
	classes.cAwarenessScene[0].__vtable[-1690805083] = &cAwarenessScene::function_9b385ca5;
	classes.cAwarenessScene[0].__vtable[1131512199] = &cAwarenessScene::Play;
	classes.cAwarenessScene[0].__vtable[-1017222485] = &cAwarenessScene::init;
	classes.cAwarenessScene[0].__vtable[900706181] = &cAwarenessScene::new_object;
}

/*
	Name: get_existing_ent
	Namespace: scene
	Checksum: 0x3478FC9D
	Offset: 0x107A0
	Size: 0x361
	Parameters: 3
	Flags: None
*/
function get_existing_ent(str_name, b_spawner_only, b_nodes_and_structs)
{
	if(!isdefined(b_spawner_only))
	{
		b_spawner_only = 0;
	}
	if(!isdefined(b_nodes_and_structs))
	{
		b_nodes_and_structs = 0;
	}
	e = undefined;
	if(b_spawner_only)
	{
		e_array = GetSpawnerArray(str_name, "script_animname");
		if(e_array.size == 0)
		{
			e_array = GetSpawnerArray(str_name, "targetname");
		}
		/#
			Assert(e_array.size <= 1, "Dev Block strings are not supported");
		#/
		foreach(ent in e_array)
		{
			if(!isdefined(ent.isDying))
			{
				e = ent;
				break;
			}
		}
	}
	else
	{
		e = GetEnt(str_name, "animname", 0);
		if(!is_valid_ent(e))
		{
			e = GetEnt(str_name, "script_animname");
			if(!is_valid_ent(e))
			{
				e = GetEnt(str_name + "_ai", "targetname", 1);
				if(!is_valid_ent(e))
				{
					e = GetEnt(str_name + "_vh", "targetname", 1);
					if(!is_valid_ent(e))
					{
						e = GetEnt(str_name, "targetname", 1);
						if(!is_valid_ent(e))
						{
							e = GetEnt(str_name, "targetname");
							if(!is_valid_ent(e) && b_nodes_and_structs)
							{
								e = GetNode(str_name, "targetname");
								if(!is_valid_ent(e))
								{
									e = struct::get(str_name, "targetname");
								}
							}
						}
					}
				}
			}
		}
	}
	if(!is_valid_ent(e))
	{
		e = undefined;
	}
	return e;
}

/*
	Name: is_valid_ent
	Namespace: scene
	Checksum: 0x27C29796
	Offset: 0x10B10
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function is_valid_ent(ent)
{
	return isdefined(ent) && (!isdefined(ent.isDying) && !ent ai::is_dead_sentient() || self._s.IgnoreAliveCheck === 1);
}

/*
	Name: synced_delete
	Namespace: scene
	Checksum: 0x1B69815
	Offset: 0x10B78
	Size: 0x193
	Parameters: 0
	Flags: None
*/
function synced_delete()
{
	self endon("death");
	self.isDying = 1;
	if(isdefined(self.targetname))
	{
		self.targetname = self.targetname + "_sync_deleting";
	}
	if(isdefined(self.animName))
	{
		self.animName = self.animName + "_sync_deleting";
	}
	if(isdefined(self.script_animname))
	{
		self.script_animname = self.script_animname + "_sync_deleting";
	}
	if(!isPlayer(self))
	{
		SetHideonClientWhenScriptedAnimCompleted(self);
		self StopAnimScripted();
	}
	else
	{
		wait(0.05);
		self ghost();
	}
	self notsolid();
	if(isalive(self))
	{
		if(IsSentient(self))
		{
			self.ignoreall = 1;
		}
		if(IsActor(self))
		{
			self PathMode("dont move");
		}
	}
	wait(1);
	self delete();
}

/*
	Name: __init__sytem__
	Namespace: scene
	Checksum: 0xEFFEEE90
	Offset: 0x10D18
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
	Checksum: 0x2D9EBB0A
	Offset: 0x10D60
	Size: 0x83B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.scene_object_id = 0;
	level.active_scenes = [];
	level.sceneSkippedCount = 0;
	level.wait_for_streamer_hint_scenes = [];
	streamerRequest("clear");
	foreach(s_scenedef in struct::get_script_bundles("scene"))
	{
		s_scenedef.editaction = undefined;
		s_scenedef.newobject = undefined;
		if(IsString(s_scenedef.FemaleBundle))
		{
			s_female_bundle = struct::get_script_bundle("scene", s_scenedef.FemaleBundle);
			s_female_bundle.MaleBundle = s_scenedef.name;
			s_scenedef.s_female_bundle = s_female_bundle;
			s_female_bundle.s_male_bundle = s_scenedef;
		}
		if(IsString(s_scenedef.nextscenebundle))
		{
			foreach(s_object in s_scenedef.objects)
			{
				if(s_object.type === "player")
				{
					s_object.DisableTransitionOut = 1;
				}
			}
			s_next_bundle = struct::get_script_bundle("scene", s_scenedef.nextscenebundle);
			s_next_bundle.DontSync = 1;
			foreach(s_object in s_next_bundle.objects)
			{
				if(s_object.type === "player")
				{
					s_object.DisableTransitionIn = 1;
				}
				s_object.IsCutScene = 1;
			}
			if(isdefined(s_next_bundle.FemaleBundle))
			{
				s_next_female_bundle = struct::get_script_bundle("scene", s_next_bundle.FemaleBundle);
				if(isdefined(s_next_female_bundle))
				{
					s_next_female_bundle.DontSync = 1;
					foreach(s_object in s_next_female_bundle.objects)
					{
						if(s_object.type === "player")
						{
							s_object.DisableTransitionIn = 1;
						}
						s_object.IsCutScene = 1;
					}
				}
			}
		}
		else if(IsString(s_scenedef.streamerhint))
		{
			s_cur_bundle = s_scenedef;
			while(1)
			{
				s_cur_bundle._endStreamerHint = s_scenedef.streamerhint;
				if(IsString(s_cur_bundle.nextscenebundle))
				{
					s_cur_bundle = struct::get_script_bundle("scene", s_cur_bundle.nextscenebundle);
				}
				else
				{
					break;
				}
			}
		}
		foreach(s_object in s_scenedef.objects)
		{
			if(s_object.type === "player")
			{
				if(!isdefined(s_object.CameraTween))
				{
					s_object.CameraTween = 0;
				}
				if(isdefined(s_object.player))
				{
					s_object.player--;
				}
				else
				{
					s_object.player = 0;
				}
				s_object.name = "player " + s_object.player + 1;
				s_object.newplayermethod = 1;
				continue;
			}
			s_object.player = undefined;
		}
		if(s_scenedef.vmtype == "both" && !s_scenedef is_igc())
		{
			n_clientbits = GetMinBitCountForNum(3);
			/#
				n_clientbits = GetMinBitCountForNum(6);
			#/
			clientfield::register("world", s_scenedef.name, 1, n_clientbits, "int");
		}
	}
	clientfield::register("toplayer", "postfx_igc", 1, 2, "counter");
	clientfield::register("world", "in_igc", 1, 4, "int");
	clientfield::register("toplayer", "player_scene_skip_completed", 1, 2, "counter");
	clientfield::register("allplayers", "player_scene_animation_skip", 1, 2, "counter");
	clientfield::register("actor", "player_scene_animation_skip", 1, 2, "counter");
	clientfield::register("vehicle", "player_scene_animation_skip", 1, 2, "counter");
	clientfield::register("scriptmover", "player_scene_animation_skip", 1, 2, "counter");
	callback::on_connect(&on_player_connect);
	callback::on_disconnect(&on_player_disconnect);
}

/*
	Name: remove_invalid_scene_objects
	Namespace: scene
	Checksum: 0xE695983F
	Offset: 0x115A8
	Size: 0x181
	Parameters: 1
	Flags: None
*/
function remove_invalid_scene_objects(s_scenedef)
{
	a_invalid_object_indexes = [];
	foreach(s_object in s_scenedef.objects)
	{
		if(!isdefined(s_object.name) && !isdefined(s_object.model) && !s_object.type === "player")
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
	Name: __main__
	Namespace: scene
	Checksum: 0x9E97626D
	Offset: 0x11738
	Size: 0x393
	Parameters: 0
	Flags: None
*/
function __main__()
{
	a_instances = ArrayCombine(struct::get_array("scriptbundle_scene", "classname"), struct::get_array("scriptbundle_fxanim", "classname"), 0, 0);
	foreach(s_instance in a_instances)
	{
		if(isdefined(s_instance.LinkTo))
		{
			s_instance thread _scene_link();
		}
		if(isdefined(s_instance.script_flag_set))
		{
			level flag::init(s_instance.script_flag_set);
		}
		if(isdefined(s_instance.scriptgroup_initscenes))
		{
			foreach(trig in GetEntArray(s_instance.scriptgroup_initscenes, "scriptgroup_initscenes"))
			{
				s_instance thread _trigger_init(trig);
			}
		}
		else if(isdefined(s_instance.scriptgroup_playscenes))
		{
			foreach(trig in GetEntArray(s_instance.scriptgroup_playscenes, "scriptgroup_playscenes"))
			{
				s_instance thread _trigger_play(trig);
			}
		}
		else if(isdefined(s_instance.scriptgroup_stopscenes))
		{
			foreach(trig in GetEntArray(s_instance.scriptgroup_stopscenes, "scriptgroup_stopscenes"))
			{
				s_instance thread _trigger_stop(trig);
			}
		}
	}
	level thread on_load_wait();
	level thread run_instances();
}

/*
	Name: _scene_link
	Namespace: scene
	Checksum: 0x6284FFD
	Offset: 0x11AD8
	Size: 0xBB
	Parameters: 0
	Flags: Private
*/
function private _scene_link()
{
	self.e_scene_link = util::spawn_model("tag_origin", self.origin, self.angles);
	e_linkto = GetEnt(self.LinkTo, "linkname");
	self.e_scene_link LinkTo(e_linkto);
	util::waittill_any_ents_two(self, "death", e_linkto, "death");
	self.e_scene_link delete();
}

/*
	Name: on_load_wait
	Namespace: scene
	Checksum: 0x28242682
	Offset: 0x11BA0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function on_load_wait()
{
	util::wait_network_frame();
	util::wait_network_frame();
	level flagsys::set("scene_on_load_wait");
}

/*
	Name: run_instances
	Namespace: scene
	Checksum: 0x6ED72079
	Offset: 0x11BF0
	Size: 0x119
	Parameters: 0
	Flags: None
*/
function run_instances()
{
	foreach(s_instance in struct::get_script_bundle_instances("scene"))
	{
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

/*
	Name: _trigger_init
	Namespace: scene
	Checksum: 0x1C41B7FE
	Offset: 0x11D18
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function _trigger_init(trig)
{
	trig endon("death");
	trig trigger::wait_till();
	a_ents = [];
	if(get_player_count(self.scriptbundlename) > 0)
	{
		if(isPlayer(trig.who))
		{
			a_ents[0] = trig.who;
		}
	}
	self thread _init_instance(undefined, a_ents);
}

/*
	Name: _trigger_play
	Namespace: scene
	Checksum: 0xC091BC64
	Offset: 0x11DD0
	Size: 0xF5
	Parameters: 1
	Flags: None
*/
function _trigger_play(trig)
{
	trig endon("death");
	do
	{
		trig trigger::wait_till();
		a_ents = [];
		if(get_player_count(self.scriptbundlename) > 0)
		{
			if(isPlayer(trig.who))
			{
				a_ents[0] = trig.who;
			}
		}
		self thread Play(a_ents);
	}
	while(!(isdefined(get_scenedef(self.scriptbundlename).looping) && get_scenedef(self.scriptbundlename).looping));
}

/*
	Name: _trigger_stop
	Namespace: scene
	Checksum: 0xBF9F1DC
	Offset: 0x11ED0
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function _trigger_stop(trig)
{
	trig endon("death");
	trig trigger::wait_till();
	self thread stop();
}

/*
	Name: add_scene_func
	Namespace: scene
	Checksum: 0x9FAB0840
	Offset: 0x11F20
	Size: 0x12B
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
	Array::add(level.scene_funcs[str_scenedef][str_state], Array(func, vararg), 0);
}

/*
	Name: remove_scene_func
	Namespace: scene
	Checksum: 0xA5C585E7
	Offset: 0x12058
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
	Name: get_scenedef
	Namespace: scene
	Checksum: 0xAC6AF666
	Offset: 0x121B0
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
	Checksum: 0x66474AC7
	Offset: 0x121E8
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
	Name: spawn
	Namespace: scene
	Checksum: 0x8221B8E4
	Offset: 0x12320
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
	Checksum: 0x21414476
	Offset: 0x124D0
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
	Name: _init_instance
	Namespace: scene
	Checksum: 0xE4B34C7C
	Offset: 0x12770
	Size: 0x273
	Parameters: 3
	Flags: None
*/
function _init_instance()
{
System.Exception: Function contains invalid OpCode.
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: _load_female_scene
	Namespace: scene
	Checksum: 0xCAE68714
	Offset: 0x129F0
	Size: 0x263
	Parameters: 2
	Flags: Private
*/
function private _load_female_scene(s_bundle, a_ents)
{
	b_has_player = 0;
	foreach(s_object in s_bundle.objects)
	{
		if(!isdefined(s_object))
		{
			continue;
		}
		if(s_object.type === "player")
		{
			b_has_player = 1;
			break;
		}
	}
	if(b_has_player)
	{
		e_player = undefined;
		if(isPlayer(a_ents))
		{
			e_player = a_ents;
			break;
		}
		if(IsArray(a_ents))
		{
			foreach(ent in a_ents)
			{
				if(isPlayer(ent))
				{
					e_player = ent;
					break;
				}
			}
		}
		else if(!isdefined(e_player))
		{
			e_player = level.activePlayers[0];
		}
		if(isPlayer(e_player) && e_player util::is_female())
		{
			if(isdefined(s_bundle.FemaleBundle))
			{
				s_female_bundle = struct::get_script_bundle("scene", s_bundle.FemaleBundle);
				if(isdefined(s_female_bundle))
				{
					return s_female_bundle;
				}
			}
		}
	}
	return s_bundle;
}

/*
	Name: Play
	Namespace: scene
	Checksum: 0x88DFD8F8
	Offset: 0x12C60
	Size: 0x4BB
	Parameters: 6
	Flags: None
*/
function Play(arg1, arg2, arg3, b_test_run, str_state, str_mode)
{
	if(!isdefined(b_test_run))
	{
		b_test_run = 0;
	}
	if(!isdefined(str_mode))
	{
		str_mode = "";
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			if(isdefined(arg1) && IsString(arg1))
			{
				PrintTopRightln("Dev Block strings are not supported" + arg1);
			}
			else
			{
				PrintTopRightln("Dev Block strings are not supported");
			}
		}
	#/
	if(isdefined(arg1) && IsString(arg1) && arg1 == "p7_fxanim_zm_castle_rocket_bell_tower_bundle")
	{
		arg1 = arg1;
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
				self thread _play_instance(s_tracker, str_scenedef, a_ents, b_test_run, undefined, str_mode);
				break;
			}
			s_tracker.n_scene_count = a_instances.size;
			foreach(s_instance in a_instances)
			{
				if(isdefined(s_instance))
				{
					s_instance thread _play_instance(s_tracker, str_scenedef, a_ents, b_test_run, str_state, str_mode);
				}
			}
		}
	}
	else if(IsString(arg1))
	{
		self thread _play_instance(s_tracker, arg1, arg2, b_test_run, str_state, str_mode);
	}
	else
	{
		self thread _play_instance(s_tracker, arg2, arg1, b_test_run, str_state, str_mode);
	}
	for(i = 0; i < s_tracker.n_scene_count; i++)
	{
		s_tracker waittill("scene_done");
	}
}

/*
	Name: _play_instance
	Namespace: scene
	Checksum: 0x3269B728
	Offset: 0x13128
	Size: 0x2AB
	Parameters: 6
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
	Name: skipto_end
	Namespace: scene
	Checksum: 0xE570DDD0
	Offset: 0x133E0
	Size: 0xB3
	Parameters: 5
	Flags: None
*/
function skipto_end(arg1, arg2, arg3, n_time, b_include_players)
{
	if(!isdefined(b_include_players))
	{
		b_include_players = 0;
	}
	str_mode = "skipto";
	if(!b_include_players)
	{
		str_mode = str_mode + "_noplayers";
	}
	if(isdefined(n_time))
	{
		str_mode = str_mode + ":" + n_time;
	}
	Play(arg1, arg2, arg3, 0, undefined, str_mode);
}

/*
	Name: skipto_end_noai
	Namespace: scene
	Checksum: 0xE2DD1DB6
	Offset: 0x134A0
	Size: 0x83
	Parameters: 4
	Flags: None
*/
function skipto_end_noai(arg1, arg2, arg3, n_time)
{
	str_mode = "skipto_noai_noplayers";
	if(isdefined(n_time))
	{
		str_mode = str_mode + ":" + n_time;
	}
	Play(arg1, arg2, arg3, 0, undefined, str_mode);
}

/*
	Name: stop
	Namespace: scene
	Checksum: 0xF46B53FD
	Offset: 0x13530
	Size: 0x273
	Parameters: 3
	Flags: None
*/
function stop(arg1, arg2, arg3)
{
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
						Assert(a_instances.size, "Dev Block strings are not supported" + str_key + "Dev Block strings are not supported" + str_value + "Dev Block strings are not supported");
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
					s_instance _stop_instance(b_clear, str_value);
				}
			}
		}
	}
	else if(IsString(arg1))
	{
		_stop_instance(arg2, arg1);
	}
	else
	{
		_stop_instance(arg1);
	}
}

/*
	Name: _stop_instance
	Namespace: scene
	Checksum: 0xF0BB6473
	Offset: 0x137B0
	Size: 0x101
	Parameters: 2
	Flags: None
*/
function _stop_instance()
{
System.ArgumentException: Expecting While Loop At FirstArrayKey
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.⁮‍‏‫‏⁫⁪‏⁬‪‬​‏⁯⁭‪‎​‮⁪‭‭⁭‮‪‍‬‪‍‍⁫‎⁪⁬‍‍‪‪​⁪‮()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: has_init_state
	Namespace: scene
	Checksum: 0x1ECAC53A
	Offset: 0x138C0
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
	Checksum: 0xE8D56C37
	Offset: 0x139B8
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
	Checksum: 0xF4950FBF
	Offset: 0x13A08
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
	Checksum: 0xD92C0E78
	Offset: 0x13A40
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
	Checksum: 0x17AAA7B0
	Offset: 0x13A78
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
	Checksum: 0x96A17CCA
	Offset: 0x13AB0
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
	Checksum: 0xCDEBBA46
	Offset: 0x13AE8
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
	Checksum: 0xFD4D73A3
	Offset: 0x13C28
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
	Checksum: 0x1463E1B6
	Offset: 0x13C80
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
	Name: is_ready
	Namespace: scene
	Checksum: 0xD5333108
	Offset: 0x13D20
	Size: 0x95
	Parameters: 1
	Flags: None
*/
function is_ready(str_scenedef)
{
	if(self == level)
	{
		return level flagsys::get(str_scenedef + "_ready");
	}
	else if(!isdefined(str_scenedef))
	{
		str_scenedef = self.scriptbundlename;
	}
	o_scene = get_active_scene(str_scenedef);
	if(isdefined(o_scene))
	{
		return o_scene flagsys::get("ready");
	}
	return 0;
}

/*
	Name: get_active_scenes
	Namespace: scene
	Checksum: 0x2F9BC371
	Offset: 0x13DC0
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
	Checksum: 0x9C0EB389
	Offset: 0x13ED0
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
	Name: delete_scene_data
	Namespace: scene
	Checksum: 0xDA0F40B2
	Offset: 0x13F90
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function delete_scene_data(str_scenename)
{
	if(isdefined(level.scriptbundles["scene"][str_scenename]))
	{
		level.scriptbundles["scene"][str_scenename] = undefined;
	}
}

/*
	Name: is_igc
	Namespace: scene
	Checksum: 0x66834A82
	Offset: 0x13FD8
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function is_igc()
{
	return IsString(self.cameraswitcher) || IsString(self.extraCamSwitcher1) || IsString(self.extraCamSwitcher2) || IsString(self.extraCamSwitcher3) || IsString(self.extraCamSwitcher4);
}

/*
	Name: scene_disable_player_stuff
	Namespace: scene
	Checksum: 0xF05CE6B5
	Offset: 0x14060
	Size: 0xF1
	Parameters: 1
	Flags: None
*/
function scene_disable_player_stuff(b_hide_hud)
{
	if(!isdefined(b_hide_hud))
	{
		b_hide_hud = 1;
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			PrintTopRightln("Dev Block strings are not supported");
		}
	#/
	self notify("scene_disable_player_stuff");
	self notify("kill_hint_text");
	self disableOffhandWeapons();
	if(b_hide_hud)
	{
		set_igc_active(1);
		level notify("disable_cybercom", self, 1);
		self util::show_hud(0);
		util::wait_network_frame();
		self notify("delete_weapon_objects");
	}
}

/*
	Name: scene_enable_player_stuff
	Namespace: scene
	Checksum: 0xC1B4962F
	Offset: 0x14160
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function scene_enable_player_stuff(b_hide_hud)
{
	if(!isdefined(b_hide_hud))
	{
		b_hide_hud = 1;
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			PrintTopRightln("Dev Block strings are not supported");
		}
	#/
	self endon("scene_disable_player_stuff");
	self endon("disconnect");
	wait(0.5);
	self EnableOffhandWeapons();
	if(b_hide_hud)
	{
		set_igc_active(0);
		level notify("enable_cybercom", self);
		self notify("scene_enable_cybercom");
		self util::show_hud(1);
	}
}

/*
	Name: updateIGCViewtime
	Namespace: scene
	Checksum: 0xC9FFC8F8
	Offset: 0x14250
	Size: 0x139
	Parameters: 1
	Flags: None
*/
function updateIGCViewtime(b_in_igc)
{
	if(b_in_igc && !isdefined(level.igcStartTime))
	{
		level.igcStartTime = GetTime();
		break;
	}
	if(!b_in_igc && isdefined(level.igcStartTime))
	{
		igcViewtimeSec = GetTime() - level.igcStartTime;
		level.igcStartTime = undefined;
		foreach(player in level.players)
		{
			if(!isdefined(player.totalIGCViewtime))
			{
				player.totalIGCViewtime = 0;
			}
			player.totalIGCViewtime = player.totalIGCViewtime + Int(igcViewtimeSec / 1000);
		}
	}
}

/*
	Name: set_igc_active
	Namespace: scene
	Checksum: 0x384B066F
	Offset: 0x14398
	Size: 0xCF
	Parameters: 1
	Flags: None
*/
function set_igc_active(b_in_igc)
{
	n_ent_num = self GetEntityNumber();
	n_players_in_igc_field = level clientfield::get("in_igc");
	if(b_in_igc)
	{
		n_players_in_igc_field = n_players_in_igc_field | 1 << n_ent_num;
	}
	else
	{
		~n_players_in_igc_field;
		n_players_in_igc_field = n_players_in_igc_field & 1 << n_ent_num;
	}
	updateIGCViewtime(b_in_igc);
	level clientfield::set("in_igc", n_players_in_igc_field);
	/#
	#/
}

/*
	Name: is_igc_active
	Namespace: scene
	Checksum: 0x7493D96F
	Offset: 0x14470
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function is_igc_active()
{
	n_players_in_igc = level clientfield::get("in_igc");
	n_entnum = self GetEntityNumber();
	return n_players_in_igc & 1 << n_entnum;
}

/*
	Name: is_capture_mode
	Namespace: scene
	Checksum: 0x1DDC7420
	Offset: 0x144D8
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

/*
	Name: should_spectate_on_join
	Namespace: scene
	Checksum: 0xC92EBEF5
	Offset: 0x14540
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function should_spectate_on_join()
{
	return isdefined(level.scene_should_spectate_on_hot_join) && level.scene_should_spectate_on_hot_join;
}

/*
	Name: wait_until_spectate_on_join_completes
	Namespace: scene
	Checksum: 0x8EDB56A3
	Offset: 0x14560
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function wait_until_spectate_on_join_completes()
{
	while(isdefined(level.scene_should_spectate_on_hot_join) && level.scene_should_spectate_on_hot_join)
	{
		wait(0.05);
	}
}

/*
	Name: skip_scene
	Namespace: scene
	Checksum: 0xAF9E4FFA
	Offset: 0x14590
	Size: 0x5A1
	Parameters: 4
	Flags: None
*/
function skip_scene(scene_name, b_sequence, b_player_scene, b_check_linked_scene)
{
	if(!isdefined(scene_name))
	{
		if(isdefined(level.shared_scene_sequence_name))
		{
			scene_name = level.shared_scene_sequence_name;
		}
		if(!isdefined(scene_name))
		{
			if(isdefined(level.players) && isdefined(level.players[0].current_scene))
			{
				scene_name = level.players[0].current_scene;
			}
			if(!isdefined(scene_name))
			{
				foreach(player in level.players)
				{
					if(isdefined(player.current_scene))
					{
						scene_name = player.current_scene;
						break;
					}
				}
			}
		}
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			if(isdefined(scene_name))
			{
				PrintTopRightln("Dev Block strings are not supported" + scene_name + "Dev Block strings are not supported" + GetTime(), (1, 0.5, 0));
			}
			else
			{
				PrintTopRightln("Dev Block strings are not supported" + GetTime(), (1, 0.5, 0));
			}
		}
	#/
	if(!isdefined(b_sequence) && b_sequence && !isdefined(b_player_scene))
	{
		foreach(player in level.players)
		{
			if(isdefined(player.current_scene) && player.current_scene == scene_name)
			{
				b_player_scene = 1;
				break;
			}
		}
	}
	else if(!isdefined(b_sequence) && b_sequence && (isdefined(b_player_scene) && b_player_scene))
	{
		a_instances = get_active_scenes(scene_name);
		b_can_skip_player_scene = 0;
		foreach(s_instance in ArrayCopy(a_instances))
		{
			if(isdefined(s_instance))
			{
				b_shared_scene = s_instance _skip_scene(scene_name, b_sequence, 1, 0);
				if(b_shared_scene == 2)
				{
					break;
				}
				if(b_shared_scene == 1)
				{
					b_can_skip_player_scene = 1;
					break;
				}
			}
		}
		if(isdefined(b_can_skip_player_scene) && b_can_skip_player_scene)
		{
			a_instances = get_active_scenes();
			foreach(s_instance in ArrayCopy(a_instances))
			{
				if(isdefined(s_instance))
				{
					s_instance _skip_scene(scene_name, b_sequence, 0, 1);
				}
			}
		}
		else
		{
			level.shared_scene_sequence_started = undefined;
			level.shared_scene_sequence_name = undefined;
		}
		return;
	}
	a_instances = struct::get_array(scene_name, "targetname");
	if(!a_instances.size)
	{
		a_instances = get_active_scenes(scene_name);
	}
	foreach(s_instance in ArrayCopy(a_instances))
	{
		if(isdefined(s_instance))
		{
			s_instance _skip_scene(scene_name, b_sequence, b_player_scene, b_check_linked_scene);
		}
	}
}

/*
	Name: _skip_scene
	Namespace: scene
	Checksum: 0xE6C62634
	Offset: 0x14B40
	Size: 0x455
	Parameters: 4
	Flags: None
*/
function _skip_scene()
{
System.ArgumentException: Expecting While Loop At FirstArrayKey
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.⁮‍‏‫‏⁫⁪‏⁬‪‬​‏⁯⁭‪‎​‮⁪‭‭⁭‮‪‍‬‪‍‍⁫‎⁪⁬‍‍‪‪​⁪‮()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: add_player_linked_scene
	Namespace: scene
	Checksum: 0xF5887147
	Offset: 0x14FA0
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function add_player_linked_scene(linked_scene_str)
{
	if(!isdefined(level.linked_scenes))
	{
		level.linked_scenes = [];
	}
	Array::add(level.linked_scenes, linked_scene_str);
}

/*
	Name: remove_player_linked_scene
	Namespace: scene
	Checksum: 0x41DF380F
	Offset: 0x14FF0
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function remove_player_linked_scene(linked_scene_str)
{
	if(isdefined(level.linked_scenes))
	{
		ArrayRemoveValue(level.linked_scenes, linked_scene_str);
	}
}

/*
	Name: waittill_skip_sequence_completed
	Namespace: scene
	Checksum: 0xFDB78DD2
	Offset: 0x15030
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function waittill_skip_sequence_completed()
{
	while(isdefined(level.player_skipping_scene))
	{
		wait(0.05);
	}
}

/*
	Name: is_skipping_in_progress
	Namespace: scene
	Checksum: 0xC457CE2F
	Offset: 0x15058
	Size: 0xB
	Parameters: 0
	Flags: None
*/
function is_skipping_in_progress()
{
	return isdefined(level.player_skipping_scene);
}

/*
	Name: watch_scene_skip_requests
	Namespace: scene
	Checksum: 0xA473C31A
	Offset: 0x15070
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function watch_scene_skip_requests()
{
	self endon("disconnect");
	while(1)
	{
		level waittill("scene_sequence_started");
		self thread should_skip_scene_loop();
		self thread watch_scene_ending();
		self thread watch_scene_skipping();
		level waittill("scene_sequence_ended");
	}
}

/*
	Name: clear_scene_skipping_ui
	Namespace: scene
	Checksum: 0xC8ED6D1D
	Offset: 0x150F8
	Size: 0xEF
	Parameters: 0
	Flags: None
*/
function clear_scene_skipping_ui()
{
	level endon("scene_sequence_started");
	if(isdefined(self.scene_skip_timer))
	{
		self.scene_skip_timer = undefined;
	}
	if(isdefined(self.scene_skip_start_time))
	{
		self.scene_skip_start_time = undefined;
	}
	foreach(player in level.players)
	{
		if(isdefined(player.skip_scene_menu_handle))
		{
			player CloseLUIMenu(player.skip_scene_menu_handle);
			player.skip_scene_menu_handle = undefined;
		}
	}
}

/*
	Name: watch_scene_ending
	Namespace: scene
	Checksum: 0x7C82604B
	Offset: 0x151F0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function watch_scene_ending()
{
	self endon("disconnect");
	self endon("scene_being_skipped");
	level waittill("scene_sequence_ended");
	clear_scene_skipping_ui();
}

/*
	Name: watch_scene_skipping
	Namespace: scene
	Checksum: 0x7C3F72A8
	Offset: 0x15238
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function watch_scene_skipping()
{
	self endon("disconnect");
	level endon("scene_sequence_ended");
	self waittill("scene_being_skipped");
	level.sceneSkippedCount++;
	clear_scene_skipping_ui();
}

/*
	Name: should_skip_scene_loop
	Namespace: scene
	Checksum: 0xB09721B6
	Offset: 0x15288
	Size: 0x58B
	Parameters: 0
	Flags: None
*/
function should_skip_scene_loop()
{
	self endon("disconnect");
	level endon("scene_sequence_ended");
	b_skip_scene = 0;
	clear_scene_skipping_ui();
	wait(0.05);
	foreach(player in level.players)
	{
		if(isdefined(player.skip_scene_menu_handle))
		{
			player CloseLUIMenu(player.skip_scene_menu_handle);
			wait(0.05);
		}
		player.skip_scene_menu_handle = player OpenLUIMenu("CPSkipSceneMenu");
		player SetLUIMenuData(player.skip_scene_menu_handle, "showSkipButton", 0);
		player SetLUIMenuData(player.skip_scene_menu_handle, "hostIsSkipping", 0);
		player SetLUIMenuData(player.skip_scene_menu_handle, "sceneSkipEndTime", 0);
	}
	while(1)
	{
		if(self any_button_pressed() && (!isdefined(level.chyron_text_active) && level.chyron_text_active))
		{
			if(!isdefined(self.scene_skip_timer))
			{
				self SetLUIMenuData(self.skip_scene_menu_handle, "showSkipButton", 1);
			}
			self.scene_skip_timer = GetTime();
		}
		else if(isdefined(self.scene_skip_timer))
		{
			if(GetTime() - self.scene_skip_timer > 3000)
			{
				self SetLUIMenuData(self.skip_scene_menu_handle, "showSkipButton", 2);
				self.scene_skip_timer = undefined;
			}
		}
		if(self PrimaryButtonPressedLocal() && (!isdefined(level.chyron_text_active) && level.chyron_text_active))
		{
			if(!isdefined(self.scene_skip_start_time))
			{
				foreach(player in level.players)
				{
					if(player IsHost())
					{
						player SetLUIMenuData(player.skip_scene_menu_handle, "sceneSkipEndTime", GetTime() + 2500);
						continue;
					}
					if(isdefined(player.skip_scene_menu_handle))
					{
						player SetLUIMenuData(player.skip_scene_menu_handle, "hostIsSkipping", 1);
					}
				}
				self.scene_skip_start_time = GetTime();
			}
			else if(GetTime() - self.scene_skip_start_time > 2500)
			{
				b_skip_scene = 1;
				break;
			}
		}
		else if(isdefined(self.scene_skip_start_time))
		{
			foreach(player in level.players)
			{
				if(player IsHost())
				{
					player SetLUIMenuData(player.skip_scene_menu_handle, "sceneSkipEndTime", 0);
					continue;
				}
				if(isdefined(player.skip_scene_menu_handle))
				{
					player SetLUIMenuData(player.skip_scene_menu_handle, "hostIsSkipping", 2);
				}
			}
			self.scene_skip_start_time = undefined;
		}
		if(isdefined(level.chyron_text_active) && level.chyron_text_active)
		{
			while(isdefined(level.chyron_text_active) && level.chyron_text_active)
			{
				wait(0.05);
			}
			wait(3);
		}
		wait(0.05);
	}
	if(b_skip_scene)
	{
		self playsound("uin_igc_skip");
		self notify("scene_being_skipped");
		level notify("scene_skip_sequence_started");
		skip_scene(level.shared_scene_sequence_name, 0, 1);
	}
}

/*
	Name: any_button_pressed
	Namespace: scene
	Checksum: 0x57E68DB3
	Offset: 0x15820
	Size: 0x1A5
	Parameters: 0
	Flags: None
*/
function any_button_pressed()
{
	if(self ActionSlotOneButtonPressed())
	{
		return 1;
	}
	else if(self ActionSlotTwoButtonPressed())
	{
		return 1;
	}
	else if(self ActionSlotThreeButtonPressed())
	{
		return 1;
	}
	else if(self ActionSlotFourButtonPressed())
	{
		return 1;
	}
	else if(self JumpButtonPressed())
	{
		return 1;
	}
	else if(self StanceButtonPressed())
	{
		return 1;
	}
	else if(self WeaponSwitchButtonPressed())
	{
		return 1;
	}
	else if(self ReloadButtonPressed())
	{
		return 1;
	}
	else if(self fragButtonPressed())
	{
		return 1;
	}
	else if(self throwbuttonpressed())
	{
		return 1;
	}
	else if(self AttackButtonPressed())
	{
		return 1;
	}
	else if(self SecondaryOffhandButtonPressed())
	{
		return 1;
	}
	else if(self meleeButtonPressed())
	{
		return 1;
	}
	return 0;
}

/*
	Name: on_player_connect
	Namespace: scene
	Checksum: 0x4D0E085F
	Offset: 0x159D0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	if(self IsHost())
	{
		self thread watch_scene_skip_requests();
	}
}

/*
	Name: on_player_disconnect
	Namespace: scene
	Checksum: 0x5A791FE8
	Offset: 0x15A10
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function on_player_disconnect()
{
	self set_igc_active(0);
}

/*
	Name: add_scene_ordered_notetrack
	Namespace: scene
	Checksum: 0xA3A9CB6B
	Offset: 0x15A38
	Size: 0xDB
	Parameters: 2
	Flags: None
*/
function add_scene_ordered_notetrack(group_name, str_note)
{
	if(!isdefined(level.scene_ordered_notetracks))
	{
		level.scene_ordered_notetracks = [];
	}
	group_obj = level.scene_ordered_notetracks[group_name];
	if(!isdefined(group_obj))
	{
		group_obj = spawnstruct();
		group_obj.count = 0;
		group_obj.current_count = 0;
		level.scene_ordered_notetracks[group_name] = group_obj;
	}
	group_obj.count++;
	self thread _wait_for_ordered_notify(group_obj.count - 1, group_obj, group_name, str_note);
}

/*
	Name: _wait_for_ordered_notify
	Namespace: scene
	Checksum: 0xF9E3E899
	Offset: 0x15B20
	Size: 0x253
	Parameters: 4
	Flags: Private
*/
function private _wait_for_ordered_notify(id, group_obj, group_name, str_note)
{
	self waittill(str_note);
	if(group_obj.current_count == id)
	{
		group_obj.current_count++;
		self notify("scene_" + str_note);
		wait(0.05);
		if(group_obj.current_count == group_obj.count)
		{
			group_obj.pending_notifies = undefined;
			level.scene_ordered_notetracks[group_name] = undefined;
		}
		else if(isdefined(group_obj.pending_notifies) && group_obj.current_count + group_obj.pending_notifies.size == group_obj.count)
		{
			self thread _fire_ordered_notitifes(group_obj, group_name);
		}
	}
	else if(!isdefined(group_obj.pending_notifies))
	{
		group_obj.pending_notifies = [];
	}
	Notetrack = spawnstruct();
	Notetrack.id = id;
	Notetrack.str_note = str_note;
	for(i = 0; i < group_obj.pending_notifies.size && group_obj.pending_notifies[i].id < id; i++)
	{
	}
	ArrayInsert(group_obj.pending_notifies, Notetrack, i);
	if(group_obj.current_count + group_obj.pending_notifies.size == group_obj.count)
	{
		self thread _fire_ordered_notitifes(group_obj, group_name);
	}
}

/*
	Name: _fire_ordered_notitifes
	Namespace: scene
	Checksum: 0xEFF68B87
	Offset: 0x15D80
	Size: 0xB3
	Parameters: 2
	Flags: Private
*/
function private _fire_ordered_notitifes(group_obj, group_name)
{
	if(isdefined(group_obj.pending_notifies))
	{
		while(group_obj.pending_notifies.size > 0)
		{
			self notify("scene_" + group_obj.pending_notifies[0].str_note);
			ArrayRemoveIndex(group_obj.pending_notifies, 0);
			wait(0.05);
		}
	}
	group_obj.pending_notifies = undefined;
	level.scene_ordered_notetracks[group_name] = undefined;
}

/*
	Name: add_wait_for_streamer_hint_scene
	Namespace: scene
	Checksum: 0x6E33476F
	Offset: 0x15E40
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function add_wait_for_streamer_hint_scene(str_scene_name)
{
	if(!isdefined(level.wait_for_streamer_hint_scenes))
	{
		level.wait_for_streamer_hint_scenes = [];
	}
	Array::add(level.wait_for_streamer_hint_scenes, str_scene_name);
}

