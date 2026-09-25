#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_zombie_blood;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_one_inch_punch;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_challenges_tomb;
#using scripts\zm\zm_tomb_vo;

#namespace zm_tomb_challenges;

/*
	Name: challenges_init
	Namespace: zm_tomb_challenges
	Checksum: 0xC57866F3
	Offset: 0x580
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function challenges_init()
{
	level.challenges_add_stats = &tomb_challenges_add_stats;
}

/*
	Name: tomb_challenges_add_stats
	Namespace: zm_tomb_challenges
	Checksum: 0x3145D99A
	Offset: 0x5A8
	Size: 0x183
	Parameters: 0
	Flags: None
*/
function tomb_challenges_add_stats()
{
	n_kills = 115;
	n_zone_caps = 6;
	N_POINTS_SPENT = 30000;
	n_boxes_filled = 4;
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			n_kills = 1;
			n_zone_caps = 2;
			N_POINTS_SPENT = 500;
			n_boxes_filled = 1;
		}
	#/
	namespace_a528e918::add_stat("zc_headshots", 0, &"ZM_TOMB_CH1", n_kills, undefined, &reward_packed_weapon);
	namespace_a528e918::add_stat("zc_zone_captures", 0, &"ZM_TOMB_CH2", n_zone_caps, undefined, &reward_powerup_max_ammo);
	namespace_a528e918::add_stat("zc_points_spent", 0, &"ZM_TOMB_CH3", N_POINTS_SPENT, undefined, &reward_double_tap, &track_points_spent);
	namespace_a528e918::add_stat("zc_boxes_filled", 1, &"ZM_TOMB_CHT", n_boxes_filled, undefined, &reward_one_inch_punch, &init_box_footprints);
}

/*
	Name: track_points_spent
	Namespace: zm_tomb_challenges
	Checksum: 0x60DC65B4
	Offset: 0x738
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function track_points_spent()
{
	while(1)
	{
		level waittill("spent_points", player, points);
		player namespace_a528e918::increment_stat("zc_points_spent", points);
	}
}

/*
	Name: init_box_footprints
	Namespace: zm_tomb_challenges
	Checksum: 0xBCCB72C0
	Offset: 0x798
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function init_box_footprints()
{
	level.n_soul_boxes_completed = 0;
	level flag::init("vo_soul_box_intro_played");
	level flag::init("vo_soul_box_continue_played");
	a_boxes = GetEntArray("foot_box", "script_noteworthy");
	Array::thread_all(a_boxes, &box_footprint_think);
}

/*
	Name: box_footprint_think
	Namespace: zm_tomb_challenges
	Checksum: 0x47476CD2
	Offset: 0x840
	Size: 0x723
	Parameters: 0
	Flags: None
*/
function box_footprint_think()
{
	self.n_souls_absorbed = 0;
	self disconnectpaths();
	n_souls_required = 30;
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			n_souls_required = 10;
		}
	#/
	self thread watch_for_foot_stomp();
	wait(1);
	self clientfield::set("foot_print_box_glow", 1);
	wait(1);
	self clientfield::set("foot_print_box_glow", 0);
	while(self.n_souls_absorbed < n_souls_required)
	{
		self waittill("soul_absorbed", player);
		self.n_souls_absorbed++;
		if(self.n_souls_absorbed == 1)
		{
			self thread scene::Play("p7_fxanim_zm_ori_challenge_box_open_bundle", self);
			self util::delay(1, undefined, &clientfield::set, "foot_print_box_glow", 1);
			if(isdefined(player) && !level flag::get("vo_soul_box_intro_played"))
			{
				player util::delay(1.5, undefined, &zm_tomb_vo::richtofenrespondvoplay, "zm_box_start", 0, "vo_soul_box_intro_played");
			}
		}
		if(self.n_souls_absorbed == floor(n_souls_required / 4))
		{
			if(isdefined(player) && level flag::get("vo_soul_box_intro_played") && !level flag::get("vo_soul_box_continue_played"))
			{
				player thread zm_tomb_vo::richtofenrespondvoplay("zm_box_continue", 1, "vo_soul_box_continue_played");
			}
		}
		if(self.n_souls_absorbed == floor(n_souls_required / 2) || self.n_souls_absorbed == floor(n_souls_required / 1.3))
		{
			if(isdefined(player))
			{
				player zm_audio::create_and_play_dialog("soul_box", "zm_box_encourage");
			}
		}
		if(self.n_souls_absorbed == n_souls_required)
		{
			wait(1);
			self scene::Play("p7_fxanim_zm_ori_challenge_box_close_bundle", self);
		}
	}
	self notify("box_finished");
	level.n_soul_boxes_completed++;
	self scene::stop("p7_fxanim_zm_ori_challenge_box_close_bundle", self);
	e_volume = GetEnt(self.target, "targetname");
	e_volume delete();
	self util::delay(0.5, undefined, &clientfield::set, "foot_print_box_glow", 0);
	wait(2);
	self StopAnimScripted();
	v_start_angles = self.angles;
	self MoveZ(30, 1, 1);
	self.angles = v_start_angles;
	playsoundatposition("zmb_footprintbox_disappear", self.origin);
	wait(0.5);
	n_rotations = randomIntRange(5, 7);
	for(i = 0; i < n_rotations; i++)
	{
		v_rotate_angles = v_start_angles + (RandomFloatRange(-10, 10), RandomFloatRange(-10, 10), RandomFloatRange(-10, 10));
		n_rotate_time = RandomFloatRange(0.2, 0.4);
		self RotateTo(v_rotate_angles, n_rotate_time);
		self waittill("rotatedone");
	}
	self RotateTo(v_start_angles, 0.3);
	self MoveZ(-60, 0.5, 0.5);
	self waittill("rotatedone");
	trace_start = self.origin + VectorScale((0, 0, 1), 200);
	trace_end = self.origin;
	fx_trace = bullettrace(trace_start, trace_end, 0, self);
	playFX(level._effect["mech_booster_landing"], fx_trace["position"], AnglesToForward(self.angles), anglesToUp(self.angles));
	self waittill("movedone");
	level namespace_a528e918::increment_stat("zc_boxes_filled");
	if(isdefined(player))
	{
		if(level.n_soul_boxes_completed == 1)
		{
			player thread zm_tomb_vo::richtofenrespondvoplay("zm_box_complete");
		}
		else if(level.n_soul_boxes_completed == 4)
		{
			player thread zm_tomb_vo::richtofenrespondvoplay("zm_box_final_complete", 1);
		}
	}
	self connectpaths();
	self delete();
}

/*
	Name: watch_for_foot_stomp
	Namespace: zm_tomb_challenges
	Checksum: 0xC06AE652
	Offset: 0xF70
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function watch_for_foot_stomp()
{
	self endon("box_finished");
	while(1)
	{
		self waittill("robot_foot_stomp");
		self scene::Play("p7_fxanim_zm_ori_challenge_box_close_bundle", self);
		self clientfield::set("foot_print_box_glow", 0);
		self.n_souls_absorbed = 0;
		wait(5);
		self scene::stop("p7_fxanim_zm_ori_challenge_box_close_bundle", self);
	}
}

/*
	Name: footprint_zombie_killed
	Namespace: zm_tomb_challenges
	Checksum: 0x843AF902
	Offset: 0x1010
	Size: 0x151
	Parameters: 1
	Flags: None
*/
function footprint_zombie_killed(attacker)
{
	a_volumes = GetEntArray("foot_box_volume", "script_noteworthy");
	foreach(e_volume in a_volumes)
	{
		if(self istouching(e_volume) && isdefined(attacker) && isPlayer(attacker))
		{
			self clientfield::set("foot_print_box_fx", 1);
			m_box = GetEnt(e_volume.target, "targetname");
			m_box notify("soul_absorbed", attacker);
			return 1;
		}
	}
	return 0;
}

/*
	Name: reward_packed_weapon
	Namespace: zm_tomb_challenges
	Checksum: 0x693573FD
	Offset: 0x1170
	Size: 0x35F
	Parameters: 2
	Flags: None
*/
function reward_packed_weapon(player, s_stat)
{
	if(!isdefined(s_stat.var_e564b69e))
	{
		a_weapons = Array("smg_capacity", "smg_mp40_1940", "ar_accurate");
		var_7e5dd894 = GetWeapon(Array::random(a_weapons));
		s_stat.var_e564b69e = zm_weapons::get_upgrade_weapon(var_7e5dd894);
	}
	m_weapon = spawn("script_model", self.origin);
	m_weapon.angles = self.angles + VectorScale((0, 1, 0), 180);
	m_weapon playsound("zmb_spawn_powerup");
	m_weapon PlayLoopSound("zmb_spawn_powerup_loop", 0.5);
	STR_MODEL = GetWeaponModel(s_stat.var_e564b69e);
	options = player zm_weapons::get_pack_a_punch_weapon_options(s_stat.var_e564b69e);
	m_weapon UseWeaponModel(s_stat.var_e564b69e, STR_MODEL, options);
	util::wait_network_frame();
	if(!namespace_a528e918::reward_rise_and_grab(m_weapon, 50, 2, 2, 10))
	{
		return 0;
	}
	weapon_limit = zm_utility::get_player_weapon_limit(player);
	Primaries = player GetWeaponsListPrimaries();
	if(isdefined(Primaries) && Primaries.size >= weapon_limit)
	{
		player zm_weapons::weapon_give(s_stat.var_e564b69e);
	}
	else
	{
		player zm_weapons::give_build_kit_weapon(s_stat.var_e564b69e);
		player GiveStartAmmo(s_stat.var_e564b69e);
	}
	player SwitchToWeapon(s_stat.var_e564b69e);
	m_weapon StopLoopSound(0.1);
	player playsound("zmb_powerup_grabbed");
	m_weapon delete();
	return 1;
}

/*
	Name: reward_powerup_max_ammo
	Namespace: zm_tomb_challenges
	Checksum: 0xA8217238
	Offset: 0x14D8
	Size: 0x31
	Parameters: 2
	Flags: None
*/
function reward_powerup_max_ammo(player, s_stat)
{
	return reward_powerup(player, "full_ammo");
}

/*
	Name: reward_powerup_double_points
	Namespace: zm_tomb_challenges
	Checksum: 0xDED5B6D2
	Offset: 0x1518
	Size: 0x31
	Parameters: 2
	Flags: None
*/
function reward_powerup_double_points(player, n_timeout)
{
	return reward_powerup(player, "double_points", n_timeout);
}

/*
	Name: reward_powerup_zombie_blood
	Namespace: zm_tomb_challenges
	Checksum: 0x5DA3C5B5
	Offset: 0x1558
	Size: 0x31
	Parameters: 2
	Flags: None
*/
function reward_powerup_zombie_blood(player, n_timeout)
{
	return reward_powerup(player, "zombie_blood", n_timeout);
}

/*
	Name: reward_powerup
	Namespace: zm_tomb_challenges
	Checksum: 0x88284733
	Offset: 0x1598
	Size: 0x2AF
	Parameters: 3
	Flags: None
*/
function reward_powerup(player, str_powerup, n_timeout)
{
	if(!isdefined(n_timeout))
	{
		n_timeout = 10;
	}
	if(!isdefined(level.zombie_powerups[str_powerup]))
	{
		return;
	}
	s_powerup = level.zombie_powerups[str_powerup];
	m_reward = spawn("script_model", self.origin);
	m_reward.angles = self.angles + VectorScale((0, 1, 0), 180);
	m_reward SetModel(s_powerup.model_name);
	m_reward playsound("zmb_spawn_powerup");
	m_reward PlayLoopSound("zmb_spawn_powerup_loop", 0.5);
	util::wait_network_frame();
	if(!namespace_a528e918::reward_rise_and_grab(m_reward, 50, 2, 2, n_timeout))
	{
		return 0;
	}
	m_reward.hint = s_powerup.hint;
	if(!isdefined(player))
	{
		player = self.player_using;
	}
	switch(str_powerup)
	{
		case "full_ammo":
		{
			level thread zm_powerup_full_ammo::full_ammo_powerup(m_reward, player);
			player thread zm_powerups::powerup_vo("full_ammo");
			break;
		}
		case "double_points":
		{
			level thread zm_powerup_double_points::double_points_powerup(m_reward, player);
			player thread zm_powerups::powerup_vo("double_points");
			break;
		}
		case "zombie_blood":
		{
			level thread namespace_43a18dd5::zombie_blood_powerup(m_reward, player);
			break;
		}
	}
	wait(0.1);
	m_reward StopLoopSound(0.1);
	player playsound("zmb_powerup_grabbed");
	m_reward delete();
	return 1;
}

/*
	Name: reward_double_tap
	Namespace: zm_tomb_challenges
	Checksum: 0x3131F67F
	Offset: 0x1850
	Size: 0x23F
	Parameters: 2
	Flags: None
*/
function reward_double_tap(player, s_stat)
{
	m_reward = spawn("script_model", self.origin);
	m_reward.angles = self.angles + VectorScale((0, 1, 0), 180);
	STR_MODEL = GetWeaponModel(GetWeapon("zombie_perk_bottle_doubletap"));
	m_reward SetModel(STR_MODEL);
	m_reward playsound("zmb_spawn_powerup");
	m_reward PlayLoopSound("zmb_spawn_powerup_loop", 0.5);
	util::wait_network_frame();
	if(!namespace_a528e918::reward_rise_and_grab(m_reward, 50, 2, 2, 10))
	{
		return 0;
	}
	if(player hasPerk("specialty_doubletap2") || player zm_perks::has_perk_paused("specialty_doubletap2"))
	{
		m_reward thread bottle_reject_sink(player);
		return 0;
	}
	m_reward StopLoopSound(0.1);
	player playsound("zmb_powerup_grabbed");
	m_reward thread zm_perks::vending_trigger_post_think(player, "specialty_doubletap2");
	m_reward ghost();
	player waittill("burp");
	wait(1.2);
	m_reward delete();
	return 1;
}

/*
	Name: bottle_reject_sink
	Namespace: zm_tomb_challenges
	Checksum: 0x9BA3B77E
	Offset: 0x1A98
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function bottle_reject_sink(player)
{
	n_time = 1;
	player playlocalsound(level.zmb_laugh_alias);
	self thread namespace_a528e918::reward_sink(0, 61, n_time);
	wait(n_time);
	self delete();
}

/*
	Name: reward_one_inch_punch
	Namespace: zm_tomb_challenges
	Checksum: 0xF644B7E0
	Offset: 0x1B18
	Size: 0x1C7
	Parameters: 2
	Flags: None
*/
function reward_one_inch_punch(player, s_stat)
{
	m_reward = spawn("script_model", self.origin);
	m_reward.angles = self.angles + VectorScale((0, 1, 0), 180);
	m_reward SetModel("tag_origin");
	PlayFXOnTag(level._effect["staff_soul"], m_reward, "tag_origin");
	m_reward playsound("zmb_spawn_powerup");
	m_reward PlayLoopSound("zmb_spawn_powerup_loop", 0.5);
	util::wait_network_frame();
	if(!namespace_a528e918::reward_rise_and_grab(m_reward, 50, 2, 2, 10))
	{
		return 0;
	}
	player thread _zm_weap_one_inch_punch::one_inch_punch_melee_attack();
	m_reward StopLoopSound(0.1);
	player playsound("zmb_powerup_grabbed");
	m_reward delete();
	player thread one_inch_punch_watch_for_death(s_stat);
	return 1;
}

/*
	Name: one_inch_punch_watch_for_death
	Namespace: zm_tomb_challenges
	Checksum: 0x4D3C8B16
	Offset: 0x1CE8
	Size: 0x61
	Parameters: 1
	Flags: None
*/
function one_inch_punch_watch_for_death(s_stat)
{
	self endon("disconnect");
	self waittill("bled_out");
	if(s_stat.b_reward_claimed)
	{
		s_stat.b_reward_claimed = 0;
	}
	s_stat.a_b_player_rewarded[self.characterindex] = 0;
}

/*
	Name: reward_beacon
	Namespace: zm_tomb_challenges
	Checksum: 0xAB1B3491
	Offset: 0x1D58
	Size: 0x1FF
	Parameters: 2
	Flags: None
*/
function reward_beacon(player, s_stat)
{
	m_reward = spawn("script_model", self.origin);
	m_reward.angles = self.angles + VectorScale((0, 1, 0), 180);
	STR_MODEL = GetWeaponModel(level.var_25ef5fab);
	m_reward SetModel(STR_MODEL);
	m_reward playsound("zmb_spawn_powerup");
	m_reward PlayLoopSound("zmb_spawn_powerup_loop", 0.5);
	util::wait_network_frame();
	if(!namespace_a528e918::reward_rise_and_grab(m_reward, 50, 2, 2, 10))
	{
		return 0;
	}
	player zm_weapons::weapon_give(level.var_25ef5fab);
	if(isdefined(level.zombie_include_weapons[level.var_25ef5fab]) & !level.zombie_include_weapons[level.var_25ef5fab])
	{
		level.zombie_include_weapons[level.var_25ef5fab] = 1;
		level.zombie_weapons[level.var_25ef5fab].is_in_box = 1;
	}
	m_reward StopLoopSound(0.1);
	player playsound("zmb_powerup_grabbed");
	m_reward delete();
	return 1;
}

/*
	Name: GetWeaponModel
	Namespace: zm_tomb_challenges
	Checksum: 0x319FB4E2
	Offset: 0x1F60
	Size: 0x19
	Parameters: 1
	Flags: None
*/
function GetWeaponModel(weapon)
{
	return weapon.worldmodel;
}

