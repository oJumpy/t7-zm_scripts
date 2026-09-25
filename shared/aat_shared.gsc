#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;

#namespace AAT;

/*
	Name: __init__sytem__
	Namespace: AAT
	Checksum: 0x76876137
	Offset: 0x1F0
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("aat", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: AAT
	Checksum: 0xBB1B5306
	Offset: 0x238
	Size: 0x1BB
	Parameters: 0
	Flags: Private
*/
function private __init__()
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use))
	{
		return;
	}
	level.aat_initializing = 1;
	level.AAT = [];
	level.AAT["none"] = spawnstruct();
	level.AAT["none"].name = "none";
	level.aat_reroll = [];
	callback::on_connect(&on_player_connect);
	spawners = GetSpawnerArray();
	foreach(spawner in spawners)
	{
		spawner spawner::add_spawn_function(&aat_cooldown_init);
	}
	level.aat_exemptions = [];
	zm::register_vehicle_damage_callback(&aat_vehicle_damage_monitor);
	callback::on_finalize_initialization(&finalize_clientfields);
	/#
		level thread setup_devgui();
	#/
}

/*
	Name: __main__
	Namespace: AAT
	Checksum: 0x8A25A474
	Offset: 0x400
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function __main__()
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use))
	{
		return;
	}
	zm::register_zombie_damage_override_callback(&aat_response);
}

/*
	Name: on_player_connect
	Namespace: AAT
	Checksum: 0x4DFE6E68
	Offset: 0x448
	Size: 0xD7
	Parameters: 0
	Flags: Private
*/
function private on_player_connect()
{
	self.AAT = [];
	self.aat_cooldown_start = [];
	keys = getArrayKeys(level.AAT);
	foreach(key in keys)
	{
		self.aat_cooldown_start[key] = 0;
	}
	self thread watch_weapon_changes();
	/#
	#/
}

/*
	Name: setup_devgui
	Namespace: AAT
	Checksum: 0x6F2A47F7
	Offset: 0x528
	Size: 0x183
	Parameters: 0
	Flags: Private
*/
function private setup_devgui()
{
	/#
		waittillframeend;
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		var_7ea63cce = "Dev Block strings are not supported";
		keys = getArrayKeys(level.AAT);
		foreach(key in keys)
		{
			if(key != "Dev Block strings are not supported")
			{
				AddDebugCommand(var_7ea63cce + key + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + key + "Dev Block strings are not supported");
			}
		}
		AddDebugCommand(var_7ea63cce + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
		level thread function_832cf813();
	#/
}

/*
	Name: function_832cf813
	Namespace: AAT
	Checksum: 0x249169AE
	Offset: 0x6B8
	Size: 0x157
	Parameters: 0
	Flags: Private
*/
function private function_832cf813()
{
	/#
		for(;;)
		{
			var_ad818af9 = GetDvarString("Dev Block strings are not supported");
			if(var_ad818af9 != "Dev Block strings are not supported")
			{
				for(i = 0; i < level.players.size; i++)
				{
					if(var_ad818af9 == "Dev Block strings are not supported")
					{
						level.players[i] thread remove(level.players[i] GetCurrentWeapon());
					}
					else
					{
						level.players[i] thread acquire(level.players[i] GetCurrentWeapon(), var_ad818af9);
					}
					level.players[i] thread function_288d5482(var_ad818af9, 0, 0, 0);
				}
			}
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			wait(0.5);
		}
	#/
}

/*
	Name: function_6d77b957
	Namespace: AAT
	Checksum: 0x516DC590
	Offset: 0x818
	Size: 0x15B
	Parameters: 0
	Flags: Private
*/
function private function_6d77b957()
{
	/#
		self.var_169d4d7d = newClientHudElem(self);
		self.var_169d4d7d.elemType = "Dev Block strings are not supported";
		self.var_169d4d7d.font = "Dev Block strings are not supported";
		self.var_169d4d7d.fontscale = 1.8;
		self.var_169d4d7d.horzAlign = "Dev Block strings are not supported";
		self.var_169d4d7d.vertAlign = "Dev Block strings are not supported";
		self.var_169d4d7d.alignX = "Dev Block strings are not supported";
		self.var_169d4d7d.alignY = "Dev Block strings are not supported";
		self.var_169d4d7d.x = 15;
		self.var_169d4d7d.y = 15;
		self.var_169d4d7d.sort = 2;
		self.var_169d4d7d.color = (1, 1, 1);
		self.var_169d4d7d.alpha = 1;
		self.var_169d4d7d.hidewheninmenu = 1;
		self thread function_3d05ca49();
	#/
}

/*
	Name: function_3d05ca49
	Namespace: AAT
	Checksum: 0x7B8DE09D
	Offset: 0x980
	Size: 0x8F
	Parameters: 0
	Flags: Private
*/
function private function_3d05ca49()
{
	/#
		self endon("disconnect");
		while(1)
		{
			self waittill("weapon_change", weapon);
			name = "Dev Block strings are not supported";
			if(isdefined(self.AAT[weapon]))
			{
				name = self.AAT[weapon];
			}
			self thread function_288d5482(name, 0, 0, 0);
		}
	#/
}

/*
	Name: function_288d5482
	Namespace: AAT
	Checksum: 0x7EAA0364
	Offset: 0xA18
	Size: 0x1F3
	Parameters: 4
	Flags: Private
*/
function private function_288d5482(name, success, var_5448a493, fail)
{
	/#
		self notify("hash_a9ea8db9");
		self endon("hash_a9ea8db9");
		self endon("disconnect");
		if(!isdefined(self.var_169d4d7d))
		{
			return;
		}
		percentage = "Dev Block strings are not supported";
		if(isdefined(level.AAT[name]) && name != "Dev Block strings are not supported")
		{
			percentage = level.AAT[name].percentage;
		}
		self.var_169d4d7d fadeOverTime(0.05);
		self.var_169d4d7d.alpha = 1;
		self.var_169d4d7d setText("Dev Block strings are not supported" + name + "Dev Block strings are not supported" + percentage);
		if(success)
		{
			self.var_169d4d7d.color = (0, 1, 0);
		}
		else if(var_5448a493)
		{
			self.var_169d4d7d.color = VectorScale((1, 0, 1), 0.8);
		}
		else if(fail)
		{
			self.var_169d4d7d.color = (1, 0, 0);
		}
		else
		{
			self.var_169d4d7d.color = (1, 1, 1);
		}
		wait(1);
		self.var_169d4d7d fadeOverTime(1);
		self.var_169d4d7d.color = (1, 1, 1);
		if("Dev Block strings are not supported" == name)
		{
			self.var_169d4d7d.alpha = 0;
		}
	#/
}

/*
	Name: aat_cooldown_init
	Namespace: AAT
	Checksum: 0x9C126700
	Offset: 0xC18
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function aat_cooldown_init()
{
	self.aat_cooldown_start = [];
	keys = getArrayKeys(level.AAT);
	foreach(key in keys)
	{
		self.aat_cooldown_start[key] = 0;
	}
}

/*
	Name: aat_vehicle_damage_monitor
	Namespace: AAT
	Checksum: 0x9E699FB9
	Offset: 0xCD8
	Size: 0xFF
	Parameters: 15
	Flags: Private
*/
function private aat_vehicle_damage_monitor(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	willBeKilled = self.health - iDamage <= 0;
	if(isdefined(level.aat_in_use) && level.aat_in_use)
	{
		self thread aat_response(willBeKilled, eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, vSurfaceNormal);
	}
	return iDamage;
}

/*
	Name: get_nonalternate_weapon
	Namespace: AAT
	Checksum: 0x8503CB0E
	Offset: 0xDE0
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function get_nonalternate_weapon(weapon)
{
	if(isdefined(weapon) && weapon.isAltMode)
	{
		return weapon.altweapon;
	}
	return weapon;
}

/*
	Name: aat_response
	Namespace: AAT
	Checksum: 0x2031490D
	Offset: 0xE20
	Size: 0x5FB
	Parameters: 13
	Flags: None
*/
function aat_response(death, inflictor, attacker, damage, flags, mod, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if(!isPlayer(attacker))
	{
		return;
	}
	if(mod != "MOD_PISTOL_BULLET" && mod != "MOD_RIFLE_BULLET" && mod != "MOD_GRENADE" && mod != "MOD_PROJECTILE" && mod != "MOD_EXPLOSIVE" && mod != "MOD_IMPACT")
	{
		return;
	}
	weapon = get_nonalternate_weapon(weapon);
	name = attacker.AAT[weapon];
	if(!isdefined(name))
	{
		return;
	}
	if(death && !level.AAT[name].occurs_on_death)
	{
		return;
	}
	if(!isdefined(self.archetype))
	{
		return;
	}
	if(isdefined(level.AAT[name].immune_trigger[self.archetype]) && level.AAT[name].immune_trigger[self.archetype])
	{
		return;
	}
	now = GetTime() / 1000;
	if(now <= self.aat_cooldown_start[name] + level.AAT[name].cooldown_time_entity)
	{
		return;
	}
	if(now <= attacker.aat_cooldown_start[name] + level.AAT[name].cooldown_time_attacker)
	{
		return;
	}
	if(now <= level.AAT[name].cooldown_time_global_start + level.AAT[name].cooldown_time_global)
	{
		return;
	}
	if(isdefined(level.AAT[name].validation_func))
	{
		if(!self [[level.AAT[name].validation_func]]())
		{
			return;
		}
	}
	success = 0;
	reroll_icon = undefined;
	percentage = level.AAT[name].percentage;
	/#
		var_7bab268f = GetDvarFloat("Dev Block strings are not supported");
		if(var_7bab268f > 0)
		{
			percentage = var_7bab268f;
		}
	#/
	if(percentage >= RandomFloat(1))
	{
		success = 1;
		attacker thread function_288d5482(name, 1, 0, 0);
	}
	if(!success)
	{
		keys = getArrayKeys(level.aat_reroll);
		keys = Array::randomize(keys);
		foreach(key in keys)
		{
			if(attacker [[level.aat_reroll[key].active_func]]())
			{
				for(i = 0; i < level.aat_reroll[key].count; i++)
				{
					if(percentage >= RandomFloat(1))
					{
						success = 1;
						reroll_icon = level.aat_reroll[key].damage_feedback_icon;
						attacker thread function_288d5482(name, 0, 1, 0);
						break;
					}
				}
			}
			else if(success)
			{
				break;
			}
		}
	}
	else if(!success)
	{
		attacker thread function_288d5482(name, 0, 0, 1);
		return;
	}
	level.AAT[name].cooldown_time_global_start = now;
	attacker.aat_cooldown_start[name] = now;
	self thread [[level.AAT[name].result_func]](death, attacker, mod, weapon);
	attacker thread damagefeedback::update_override(level.AAT[name].damage_feedback_icon, level.AAT[name].damage_feedback_sound, reroll_icon);
}

/*
	Name: register
	Namespace: AAT
	Checksum: 0x412B79F4
	Offset: 0x1428
	Size: 0x5E7
	Parameters: 10
	Flags: None
*/
function register(name, percentage, cooldown_time_entity, cooldown_time_attacker, cooldown_time_global, occurs_on_death, result_func, damage_feedback_icon, damage_feedback_sound, validation_func)
{
	/#
		Assert(isdefined(level.aat_initializing) && level.aat_initializing, "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(name), "Dev Block strings are not supported");
	#/
	/#
		Assert("Dev Block strings are not supported" != name, "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
	#/
	/#
		Assert(!isdefined(level.AAT[name]), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(percentage), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(0 <= percentage && 1 > percentage, "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(cooldown_time_entity), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(0 <= cooldown_time_entity, "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(cooldown_time_entity), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(0 <= cooldown_time_entity, "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(cooldown_time_global), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(0 <= cooldown_time_global, "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(occurs_on_death), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(result_func), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(damage_feedback_icon), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(IsString(damage_feedback_icon), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(damage_feedback_sound), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(IsString(damage_feedback_sound), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	level.AAT[name] = spawnstruct();
	level.AAT[name].name = name;
	level.AAT[name].hash_id = HashString(name);
	level.AAT[name].percentage = percentage;
	level.AAT[name].cooldown_time_entity = cooldown_time_entity;
	level.AAT[name].cooldown_time_attacker = cooldown_time_attacker;
	level.AAT[name].cooldown_time_global = cooldown_time_global;
	level.AAT[name].cooldown_time_global_start = 0;
	level.AAT[name].occurs_on_death = occurs_on_death;
	level.AAT[name].result_func = result_func;
	level.AAT[name].damage_feedback_icon = damage_feedback_icon;
	level.AAT[name].damage_feedback_sound = damage_feedback_sound;
	level.AAT[name].validation_func = validation_func;
	level.AAT[name].immune_trigger = [];
	level.AAT[name].immune_result_direct = [];
	level.AAT[name].immune_result_indirect = [];
}

/*
	Name: register_immunity
	Namespace: AAT
	Checksum: 0x37AAA5CD
	Offset: 0x1A18
	Size: 0x21D
	Parameters: 5
	Flags: None
*/
function register_immunity(name, archetype, immune_trigger, immune_result_direct, immune_result_indirect)
{
	while(level.aat_initializing !== 0)
	{
		wait(0.05);
	}
	/#
		Assert(isdefined(name), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(archetype), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(immune_trigger), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(immune_result_direct), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(immune_result_indirect), "Dev Block strings are not supported");
	#/
	if(!isdefined(level.AAT[name].immune_trigger))
	{
		level.AAT[name].immune_trigger = [];
	}
	if(!isdefined(level.AAT[name].immune_result_direct))
	{
		level.AAT[name].immune_result_direct = [];
	}
	if(!isdefined(level.AAT[name].immune_result_indirect))
	{
		level.AAT[name].immune_result_indirect = [];
	}
	level.AAT[name].immune_trigger[archetype] = immune_trigger;
	level.AAT[name].immune_result_direct[archetype] = immune_result_direct;
	level.AAT[name].immune_result_indirect[archetype] = immune_result_indirect;
}

/*
	Name: finalize_clientfields
	Namespace: AAT
	Checksum: 0x6B9ED8D1
	Offset: 0x1C40
	Size: 0x17F
	Parameters: 0
	Flags: None
*/
function finalize_clientfields()
{
	/#
		println("Dev Block strings are not supported");
	#/
	if(level.AAT.size > 1)
	{
		Array::alphabetize(level.AAT);
		i = 0;
		foreach(AAT in level.AAT)
		{
			AAT.var_4851adad = i;
			i++;
			/#
				println("Dev Block strings are not supported" + AAT.name);
			#/
		}
		n_bits = GetMinBitCountForNum(level.AAT.size - 1);
		clientfield::register("toplayer", "aat_current", 1, n_bits, "int");
	}
	level.aat_initializing = 0;
}

/*
	Name: register_aat_exemption
	Namespace: AAT
	Checksum: 0xD31EFC16
	Offset: 0x1DC8
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function register_aat_exemption(weapon)
{
	weapon = get_nonalternate_weapon(weapon);
	level.aat_exemptions[weapon] = 1;
}

/*
	Name: is_exempt_weapon
	Namespace: AAT
	Checksum: 0xFC2A3A52
	Offset: 0x1E10
	Size: 0x35
	Parameters: 1
	Flags: None
*/
function is_exempt_weapon(weapon)
{
	weapon = get_nonalternate_weapon(weapon);
	return isdefined(level.aat_exemptions[weapon]);
}

/*
	Name: register_reroll
	Namespace: AAT
	Checksum: 0xC6AF835A
	Offset: 0x1E50
	Size: 0x263
	Parameters: 4
	Flags: None
*/
function register_reroll(name, count, active_func, damage_feedback_icon)
{
	/#
		Assert(isdefined(name), "Dev Block strings are not supported");
	#/
	/#
		Assert("Dev Block strings are not supported" != name, "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
	#/
	/#
		Assert(!isdefined(level.AAT[name]), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(count), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(0 < count, "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(active_func), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(damage_feedback_icon), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(IsString(damage_feedback_icon), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	level.aat_reroll[name] = spawnstruct();
	level.aat_reroll[name].name = name;
	level.aat_reroll[name].count = count;
	level.aat_reroll[name].active_func = active_func;
	level.aat_reroll[name].damage_feedback_icon = damage_feedback_icon;
}

/*
	Name: getAATOnWeapon
	Namespace: AAT
	Checksum: 0xCD56BAF7
	Offset: 0x20C0
	Size: 0xBF
	Parameters: 1
	Flags: None
*/
function getAATOnWeapon(weapon)
{
	weapon = get_nonalternate_weapon(weapon);
	if(weapon == level.weaponNone || (!isdefined(level.aat_in_use) && level.aat_in_use) || is_exempt_weapon(weapon) || (!isdefined(self.AAT) || !isdefined(self.AAT[weapon])) || !isdefined(level.AAT[self.AAT[weapon]]))
	{
		return undefined;
	}
	return level.AAT[self.AAT[weapon]];
}

/*
	Name: acquire
	Namespace: AAT
	Checksum: 0x35532001
	Offset: 0x2188
	Size: 0x25B
	Parameters: 2
	Flags: None
*/
function acquire(weapon, name)
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use))
	{
		return;
	}
	/#
		Assert(isdefined(weapon), "Dev Block strings are not supported");
	#/
	/#
		Assert(weapon != level.weaponNone, "Dev Block strings are not supported");
	#/
	weapon = get_nonalternate_weapon(weapon);
	if(is_exempt_weapon(weapon))
	{
		return;
	}
	if(isdefined(name))
	{
		/#
			Assert("Dev Block strings are not supported" != name, "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
		#/
		/#
			Assert(isdefined(level.AAT[name]), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
		#/
		self.AAT[weapon] = name;
	}
	else
	{
		keys = getArrayKeys(level.AAT);
		ArrayRemoveValue(keys, "none");
		if(isdefined(self.AAT[weapon]))
		{
			ArrayRemoveValue(keys, self.AAT[weapon]);
		}
		rand = RandomInt(keys.size);
		self.AAT[weapon] = keys[rand];
	}
	if(weapon == self GetCurrentWeapon())
	{
		self clientfield::set_to_player("aat_current", level.AAT[self.AAT[weapon]].var_4851adad);
	}
}

/*
	Name: remove
	Namespace: AAT
	Checksum: 0x27EB2834
	Offset: 0x23F0
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function remove(weapon)
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use))
	{
		return;
	}
	/#
		Assert(isdefined(weapon), "Dev Block strings are not supported");
	#/
	/#
		Assert(weapon != level.weaponNone, "Dev Block strings are not supported");
	#/
	weapon = get_nonalternate_weapon(weapon);
	self.AAT[weapon] = undefined;
}

/*
	Name: watch_weapon_changes
	Namespace: AAT
	Checksum: 0xD8E52F7B
	Offset: 0x24A0
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function watch_weapon_changes()
{
	self endon("disconnect");
	self endon("entityshutdown");
	while(isdefined(self))
	{
		self waittill("weapon_change", weapon);
		weapon = get_nonalternate_weapon(weapon);
		name = "none";
		if(isdefined(self.AAT[weapon]))
		{
			name = self.AAT[weapon];
		}
		self clientfield::set_to_player("aat_current", level.AAT[name].var_4851adad);
	}
}

