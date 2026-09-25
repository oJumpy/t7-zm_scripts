#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\entityheadicons_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace decoy;

/*
	Name: init_shared
	Namespace: decoy
	Checksum: 0xC7475156
	Offset: 0x240
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level.decoyWeapons = [];
	level.decoyWeapons["fullauto"] = [];
	level.decoyWeapons["semiauto"] = [];
	level.decoyWeapons["fullauto"][level.decoyWeapons["fullauto"].size] = GetWeapon("ar_accurate");
	level.decoyWeapons["semiauto"][level.decoyWeapons["semiauto"].size] = GetWeapon("pistol_standard");
	callback::add_weapon_watcher(&create_watcher);
}

/*
	Name: create_watcher
	Namespace: decoy
	Checksum: 0x69CD926C
	Offset: 0x328
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function create_watcher()
{
	watcher = self weaponobjects::createUseWeaponObjectWatcher("nightingale", self.team);
	watcher.onSpawn = &on_spawn;
	watcher.onDetonateCallback = &detonate;
	watcher.deleteOnDifferentObjectSpawn = 0;
	watcher.headicon = 0;
}

/*
	Name: on_spawn
	Namespace: decoy
	Checksum: 0xBD5CE5C2
	Offset: 0x3B8
	Size: 0x12B
	Parameters: 2
	Flags: None
*/
function on_spawn(watcher, owner)
{
	owner endon("disconnect");
	self endon("death");
	weaponobjects::onSpawnUseWeaponObject(watcher, owner);
	self.initial_velocity = self GetVelocity();
	delay = 1;
	wait(delay);
	decoy_time = 30;
	spawn_time = GetTime();
	owner addweaponstat(self.weapon, "used", 1);
	self thread simulate_weapon_fire(owner);
	while(1)
	{
		if(GetTime() > spawn_time + decoy_time * 1000)
		{
			self destroy(watcher, owner);
			return;
		}
		wait(0.05);
	}
}

/*
	Name: move
	Namespace: decoy
	Checksum: 0x8621B3E
	Offset: 0x4F0
	Size: 0x2D3
	Parameters: 5
	Flags: None
*/
function move(owner, count, fire_time, main_dir, max_offset_angle)
{
	self endon("death");
	self endon("done");
	if(!self IsOnGround())
	{
		return;
	}
	min_speed = 100;
	max_speed = 200;
	min_up_speed = 100;
	max_up_speed = 200;
	current_main_dir = randomIntRange(main_dir - max_offset_angle, main_dir + max_offset_angle);
	avel = (RandomFloatRange(800, 1800) * randomIntRange(0, 2) * 2 - 1, 0, RandomFloatRange(580, 940) * randomIntRange(0, 2) * 2 - 1);
	intial_up = RandomFloatRange(min_up_speed, max_up_speed);
	start_time = GetTime();
	gravity = GetDvarInt("bg_gravity");
	for(i = 0; i < 1; i++)
	{
		angles = (0, randomIntRange(current_main_dir - max_offset_angle, current_main_dir + max_offset_angle), 0);
		dir = AnglesToForward(angles);
		dir = VectorScale(dir, RandomFloatRange(min_speed, max_speed));
		deltaTime = GetTime() - start_time * 0.001;
		up = (0, 0, intial_up - 800 * deltaTime);
		self launch(dir + up, avel);
		wait(fire_time);
	}
}

/*
	Name: destroy
	Namespace: decoy
	Checksum: 0xC401C86C
	Offset: 0x7D0
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function destroy(watcher, owner)
{
	self notify("done");
	self entityheadicons::setEntityHeadIcon("none");
}

/*
	Name: detonate
	Namespace: decoy
	Checksum: 0xB9D2828E
	Offset: 0x818
	Size: 0x43
	Parameters: 3
	Flags: None
*/
function detonate(attacker, weapon, target)
{
	self notify("done");
	self entityheadicons::setEntityHeadIcon("none");
}

/*
	Name: simulate_weapon_fire
	Namespace: decoy
	Checksum: 0x6C51E50D
	Offset: 0x868
	Size: 0x1A5
	Parameters: 1
	Flags: None
*/
function simulate_weapon_fire(owner)
{
	owner endon("disconnect");
	self endon("death");
	self endon("done");
	weapon = pick_random_weapon();
	self thread watch_for_explosion(owner, weapon);
	self thread track_main_direction();
	self.max_offset_angle = 30;
	WEAPON_CLASS = util::getWeaponClass(weapon);
	switch(WEAPON_CLASS)
	{
		case "weapon_assault":
		case "weapon_cqb":
		case "weapon_hmg":
		case "weapon_lmg":
		case "weapon_smg":
		{
			simulate_weapon_fire_machine_gun(owner, weapon);
			break;
		}
		case "weapon_sniper":
		{
			simulate_weapon_fire_sniper(owner, weapon);
			break;
		}
		case "weapon_pistol":
		{
			simulate_weapon_fire_pistol(owner, weapon);
			break;
		}
		case "weapon_shotgun":
		{
			simulate_weapon_fire_shotgun(owner, weapon);
			break;
		}
		case default:
		{
			simulate_weapon_fire_machine_gun(owner, weapon);
			break;
		}
	}
}

/*
	Name: simulate_weapon_fire_machine_gun
	Namespace: decoy
	Checksum: 0xFC2F3047
	Offset: 0xA18
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function simulate_weapon_fire_machine_gun(owner, weapon)
{
	if(weapon.isSemiAuto)
	{
		simulate_weapon_fire_machine_gun_semi_auto(owner, weapon);
	}
	else
	{
		simulate_weapon_fire_machine_gun_full_auto(owner, weapon);
	}
}

/*
	Name: simulate_weapon_fire_machine_gun_semi_auto
	Namespace: decoy
	Checksum: 0x9A06B8C9
	Offset: 0xA88
	Size: 0x157
	Parameters: 2
	Flags: None
*/
function simulate_weapon_fire_machine_gun_semi_auto(owner, weapon)
{
	clipSize = weapon.clipSize;
	fireTime = weapon.fireTime;
	reloadTime = weapon.reloadTime;
	burst_spacing_min = 4;
	burst_spacing_max = 10;
	while(1)
	{
		if(clipSize <= 1)
		{
			burst_count = 1;
		}
		else
		{
			burst_count = randomIntRange(1, clipSize);
		}
		self thread move(owner, burst_count, fireTime, self.main_dir, self.max_offset_angle);
		self fire_burst(owner, weapon, fireTime, burst_count, 1);
		finish_while_loop(weapon, reloadTime, burst_spacing_min, burst_spacing_max);
	}
}

/*
	Name: simulate_weapon_fire_pistol
	Namespace: decoy
	Checksum: 0x4FED54E5
	Offset: 0xBE8
	Size: 0x13F
	Parameters: 2
	Flags: None
*/
function simulate_weapon_fire_pistol(owner, weapon)
{
	clipSize = weapon.clipSize;
	fireTime = weapon.fireTime;
	reloadTime = weapon.reloadTime;
	burst_spacing_min = 0.5;
	burst_spacing_max = 4;
	while(1)
	{
		burst_count = randomIntRange(1, clipSize);
		self thread move(owner, burst_count, fireTime, self.main_dir, self.max_offset_angle);
		self fire_burst(owner, weapon, fireTime, burst_count, 0);
		finish_while_loop(weapon, reloadTime, burst_spacing_min, burst_spacing_max);
	}
}

/*
	Name: simulate_weapon_fire_shotgun
	Namespace: decoy
	Checksum: 0xE711D714
	Offset: 0xD30
	Size: 0x157
	Parameters: 2
	Flags: None
*/
function simulate_weapon_fire_shotgun(owner, weapon)
{
	clipSize = weapon.clipSize;
	fireTime = weapon.fireTime;
	reloadTime = weapon.reloadTime;
	if(clipSize > 2)
	{
		clipSize = 2;
	}
	burst_spacing_min = 0.5;
	burst_spacing_max = 4;
	while(1)
	{
		burst_count = randomIntRange(1, clipSize);
		self thread move(owner, burst_count, fireTime, self.main_dir, self.max_offset_angle);
		self fire_burst(owner, weapon, fireTime, burst_count, 0);
		finish_while_loop(weapon, reloadTime, burst_spacing_min, burst_spacing_max);
	}
}

/*
	Name: simulate_weapon_fire_machine_gun_full_auto
	Namespace: decoy
	Checksum: 0x12CBB3C7
	Offset: 0xE90
	Size: 0x17F
	Parameters: 2
	Flags: None
*/
function simulate_weapon_fire_machine_gun_full_auto(owner, weapon)
{
	clipSize = weapon.clipSize;
	fireTime = weapon.fireTime;
	reloadTime = weapon.reloadTime;
	if(clipSize > 30)
	{
		clipSize = 30;
	}
	burst_spacing_min = 2;
	burst_spacing_max = 6;
	while(1)
	{
		burst_count = randomIntRange(Int(clipSize * 0.6), clipSize);
		INTERRUPT = 0;
		self thread move(owner, burst_count, fireTime, self.main_dir, self.max_offset_angle);
		self fire_burst(owner, weapon, fireTime, burst_count, INTERRUPT);
		finish_while_loop(weapon, reloadTime, burst_spacing_min, burst_spacing_max);
	}
}

/*
	Name: simulate_weapon_fire_sniper
	Namespace: decoy
	Checksum: 0xD88CBB05
	Offset: 0x1018
	Size: 0x14F
	Parameters: 2
	Flags: None
*/
function simulate_weapon_fire_sniper(owner, weapon)
{
	clipSize = weapon.clipSize;
	fireTime = weapon.fireTime;
	reloadTime = weapon.reloadTime;
	if(clipSize > 2)
	{
		clipSize = 2;
	}
	burst_spacing_min = 3;
	burst_spacing_max = 5;
	while(1)
	{
		burst_count = randomIntRange(1, clipSize);
		self thread move(owner, burst_count, fireTime, self.main_dir, self.max_offset_angle);
		self fire_burst(owner, weapon, fireTime, burst_count, 0);
		finish_while_loop(weapon, reloadTime, burst_spacing_min, burst_spacing_max);
	}
}

/*
	Name: fire_burst
	Namespace: decoy
	Checksum: 0x12B29E4F
	Offset: 0x1170
	Size: 0xFD
	Parameters: 5
	Flags: None
*/
function fire_burst(owner, weapon, fireTime, count, INTERRUPT)
{
	interrupt_shot = count;
	if(INTERRUPT)
	{
		interrupt_shot = Int(count * RandomFloatRange(0.6, 0.8));
	}
	self FakeFire(owner, self.origin, weapon, interrupt_shot);
	wait(fireTime * interrupt_shot);
	if(INTERRUPT)
	{
		self FakeFire(owner, self.origin, weapon, count - interrupt_shot);
		wait(fireTime * count - interrupt_shot);
	}
}

/*
	Name: finish_while_loop
	Namespace: decoy
	Checksum: 0xC5B877E2
	Offset: 0x1278
	Size: 0x73
	Parameters: 4
	Flags: None
*/
function finish_while_loop(weapon, reloadTime, burst_spacing_min, burst_spacing_max)
{
	if(should_play_reload_sound())
	{
		play_reload_sounds(weapon, reloadTime);
	}
	else
	{
		wait(RandomFloatRange(burst_spacing_min, burst_spacing_max));
	}
}

/*
	Name: play_reload_sounds
	Namespace: decoy
	Checksum: 0x5D8DCEB4
	Offset: 0x12F8
	Size: 0x81
	Parameters: 2
	Flags: None
*/
function play_reload_sounds(weapon, reloadTime)
{
	divy_it_up = reloadTime - 0.1 / 2;
	wait(0.1);
	self playsound("fly_assault_reload_npc_mag_out");
	wait(divy_it_up);
	self playsound("fly_assault_reload_npc_mag_in");
	wait(divy_it_up);
}

/*
	Name: watch_for_explosion
	Namespace: decoy
	Checksum: 0x8121E9E5
	Offset: 0x1388
	Size: 0x9B
	Parameters: 2
	Flags: None
*/
function watch_for_explosion(owner, weapon)
{
	self thread watch_for_death_before_explosion();
	owner endon("disconnect");
	self endon("death_before_explode");
	self waittill("explode", pos);
	level thread do_explosion(owner, pos, weapon, randomIntRange(5, 10));
}

/*
	Name: watch_for_death_before_explosion
	Namespace: decoy
	Checksum: 0x27CBD27D
	Offset: 0x1430
	Size: 0x2D
	Parameters: 0
	Flags: None
*/
function watch_for_death_before_explosion()
{
	self waittill("death");
	wait(0.1);
	if(isdefined(self))
	{
		self notify("death_before_explode");
	}
}

/*
	Name: do_explosion
	Namespace: decoy
	Checksum: 0xF18C82DF
	Offset: 0x1468
	Size: 0x14D
	Parameters: 4
	Flags: None
*/
function do_explosion(owner, pos, weapon, count)
{
	min_offset = 100;
	max_offset = 500;
	for(i = 0; i < count; i++)
	{
		wait(RandomFloatRange(0.1, 0.5));
		offset = (RandomFloatRange(min_offset, max_offset) * randomIntRange(0, 2) * 2 - 1, RandomFloatRange(min_offset, max_offset) * randomIntRange(0, 2) * 2 - 1, 0);
		owner FakeFire(owner, pos + offset, weapon, 1);
	}
}

/*
	Name: pick_random_weapon
	Namespace: decoy
	Checksum: 0xB1F6D0E4
	Offset: 0x15C0
	Size: 0xD5
	Parameters: 0
	Flags: None
*/
function pick_random_weapon()
{
	type = "fullauto";
	if(randomIntRange(0, 10) < 3)
	{
		type = "semiauto";
	}
	randomval = randomIntRange(0, level.decoyWeapons[type].size);
	/#
		println("Dev Block strings are not supported" + type + "Dev Block strings are not supported" + level.decoyWeapons[type][randomval].name);
	#/
	return level.decoyWeapons[type][randomval];
}

/*
	Name: should_play_reload_sound
	Namespace: decoy
	Checksum: 0xAC62A783
	Offset: 0x16A0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function should_play_reload_sound()
{
	if(randomIntRange(0, 5) == 1)
	{
		return 1;
	}
	return 0;
}

/*
	Name: track_main_direction
	Namespace: decoy
	Checksum: 0x96BF3906
	Offset: 0x16D8
	Size: 0x12F
	Parameters: 0
	Flags: None
*/
function track_main_direction()
{
	self endon("death");
	self endon("done");
	self.main_dir = Int(VectorToAngles((self.initial_velocity[0], self.initial_velocity[1], 0))[1]);
	up = (0, 0, 1);
	while(1)
	{
		self waittill("grenade_bounce", pos, normal);
		dot = VectorDot(normal, up);
		if(dot < 0.5 && dot > -0.5)
		{
			self.main_dir = Int(VectorToAngles((normal[0], normal[1], 0))[1]);
		}
	}
}

