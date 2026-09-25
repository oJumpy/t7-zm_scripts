#using scripts\codescripts\struct;
#using scripts\shared\_burnplayer;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\mechz;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_elemental_zombies;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_riotshield;
#using scripts\zm\_zm_zonemgr;

#namespace namespace_19d9d56d;

/*
	Name: __init__sytem__
	Namespace: namespace_19d9d56d
	Checksum: 0x9EC616A5
	Offset: 0x8A0
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_mechz_claw", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_19d9d56d
	Checksum: 0x31EF4976
	Offset: 0x8E8
	Size: 0x18B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	function_f20c04a4();
	spawner::add_archetype_spawn_function("mechz", &function_1aacf7d4);
	level.mechz_claw_cooldown_time = 7000;
	level.mechz_left_arm_damage_callback = &function_671deda5;
	level.mechz_explosive_damage_reaction_callback = &function_6028875a;
	level.mechz_powercap_destroyed_callback = &function_d6f31ed2;
	level flag::init("mechz_launching_claw");
	level flag::init("mechz_claw_move_complete");
	clientfield::register("actor", "mechz_fx", 21000, 12, "int");
	clientfield::register("scriptmover", "mechz_claw", 21000, 1, "int");
	clientfield::register("actor", "mechz_wpn_source", 21000, 1, "int");
	clientfield::register("toplayer", "mechz_grab", 21000, 1, "int");
}

/*
	Name: __main__
	Namespace: namespace_19d9d56d
	Checksum: 0x99EC1590
	Offset: 0xA80
	Size: 0x3
	Parameters: 0
	Flags: Private
*/
function private __main__()
{
}

/*
	Name: function_f20c04a4
	Namespace: namespace_19d9d56d
	Checksum: 0xFBFB3FD1
	Offset: 0xA90
	Size: 0x163
	Parameters: 0
	Flags: Private
*/
function private function_f20c04a4()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zmMechzShouldShootClaw", &function_bdc90f38);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zmMechzShootClawAction", &function_86ac6346, &function_a94df749, &function_1b118e5);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zmMechzShootClaw", &function_456e76fa);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zmMechzUpdateClaw", &function_a844c266);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zmMechzStopClaw", &function_75278fab);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("muzzleflash", &function_de3abdba);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("start_ft", &function_48c03479);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("stop_ft", &function_235008e3);
}

/*
	Name: function_bdc90f38
	Namespace: namespace_19d9d56d
	Checksum: 0x907B18C3
	Offset: 0xC00
	Size: 0x2B1
	Parameters: 1
	Flags: Private
*/
function private function_bdc90f38(entity)
{
	if(!isdefined(entity.favoriteenemy))
	{
		return 0;
	}
	if(!(isdefined(entity.has_powercap) && entity.has_powercap))
	{
		return 0;
	}
	if(isdefined(entity.last_claw_time) && GetTime() - self.last_claw_time < level.mechz_claw_cooldown_time)
	{
		return 0;
	}
	if(isdefined(entity.Berserk) && entity.Berserk)
	{
		return 0;
	}
	if(!entity MechzServerUtils::mechzCheckInArc())
	{
		return 0;
	}
	dist_sq = DistanceSquared(entity.origin, entity.favoriteenemy.origin);
	if(dist_sq < 40000 || dist_sq > 1000000)
	{
		return 0;
	}
	if(!entity.favoriteenemy player_can_be_grabbed())
	{
		return 0;
	}
	curr_zone = zm_zonemgr::get_zone_from_position(self.origin + VectorScale((0, 0, 1), 36));
	if(isdefined(curr_zone) && "ug_bottom_zone" == curr_zone)
	{
		return 0;
	}
	clip_mask = 1 | 8;
	claw_origin = entity.origin + VectorScale((0, 0, 1), 65);
	trace = PhysicsTrace(claw_origin, entity.favoriteenemy.origin + VectorScale((0, 0, 1), 30), (-15, -15, -20), (15, 15, 40), entity, clip_mask);
	b_cansee = trace["fraction"] == 1 || (isdefined(trace["entity"]) && trace["entity"] == entity.favoriteenemy);
	if(!b_cansee)
	{
		return 0;
	}
}

/*
	Name: player_can_be_grabbed
	Namespace: namespace_19d9d56d
	Checksum: 0xB0E1850E
	Offset: 0xEC0
	Size: 0x4D
	Parameters: 0
	Flags: Private
*/
function private player_can_be_grabbed()
{
	if(self GetStance() == "prone")
	{
		return 0;
	}
	if(!zm_utility::is_player_valid(self))
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_86ac6346
	Namespace: namespace_19d9d56d
	Checksum: 0x352735E5
	Offset: 0xF18
	Size: 0x47
	Parameters: 2
	Flags: Private
*/
function private function_86ac6346(entity, asmStateName)
{
	AnimationStateNetworkUtility::RequestState(entity, asmStateName);
	function_456e76fa(entity);
	return 5;
}

/*
	Name: function_a94df749
	Namespace: namespace_19d9d56d
	Checksum: 0xFFB16407
	Offset: 0xF68
	Size: 0x43
	Parameters: 2
	Flags: Private
*/
function private function_a94df749(entity, asmStateName)
{
	if(!(isdefined(entity.var_7bee990f) && entity.var_7bee990f))
	{
		return 4;
	}
	return 5;
}

/*
	Name: function_1b118e5
	Namespace: namespace_19d9d56d
	Checksum: 0x9CF512EF
	Offset: 0xFB8
	Size: 0x17
	Parameters: 2
	Flags: Private
*/
function private function_1b118e5(entity, asmStateName)
{
	return 4;
}

/*
	Name: function_456e76fa
	Namespace: namespace_19d9d56d
	Checksum: 0xA327E930
	Offset: 0xFD8
	Size: 0x43
	Parameters: 1
	Flags: Private
*/
function private function_456e76fa(entity)
{
	self thread function_31c4b972();
	level flag::set("mechz_launching_claw");
}

/*
	Name: function_a844c266
	Namespace: namespace_19d9d56d
	Checksum: 0x2FFBD5C6
	Offset: 0x1028
	Size: 0xB
	Parameters: 1
	Flags: Private
*/
function private function_a844c266(entity)
{
}

/*
	Name: function_75278fab
	Namespace: namespace_19d9d56d
	Checksum: 0x5B9513E3
	Offset: 0x1040
	Size: 0xB
	Parameters: 1
	Flags: Private
*/
function private function_75278fab(entity)
{
}

/*
	Name: function_de3abdba
	Namespace: namespace_19d9d56d
	Checksum: 0x8D09ACA8
	Offset: 0x1058
	Size: 0x5F
	Parameters: 1
	Flags: Private
*/
function private function_de3abdba(entity)
{
	self.var_7bee990f = 1;
	self.last_claw_time = GetTime();
	entity function_672f9804();
	entity function_90832db7();
	self.last_claw_time = GetTime();
}

/*
	Name: function_48c03479
	Namespace: namespace_19d9d56d
	Checksum: 0x4E70C510
	Offset: 0x10C0
	Size: 0x63
	Parameters: 1
	Flags: Private
*/
function private function_48c03479(entity)
{
	entity notify("hash_8225d137");
	entity clientfield::set("mechz_ft", 1);
	entity.isShootingFlame = 1;
	entity thread function_fa513ca0();
}

/*
	Name: function_fa513ca0
	Namespace: namespace_19d9d56d
	Checksum: 0xC2AC5BEF
	Offset: 0x1130
	Size: 0x117
	Parameters: 0
	Flags: Private
*/
function private function_fa513ca0()
{
	self endon("death");
	self endon("hash_8225d137");
	while(1)
	{
		players = GetPlayers();
		foreach(player in players)
		{
			if(!(isdefined(player.is_burning) && player.is_burning))
			{
				if(player istouching(self.flameTrigger))
				{
					player thread MechzBehavior::playerFlameDamage(self);
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_235008e3
	Namespace: namespace_19d9d56d
	Checksum: 0xFF08A825
	Offset: 0x1250
	Size: 0x71
	Parameters: 1
	Flags: Private
*/
function private function_235008e3(entity)
{
	entity notify("hash_8225d137");
	entity clientfield::set("mechz_ft", 0);
	entity.isShootingFlame = 0;
	entity.nextFlameTime = GetTime() + 7500;
	entity.stopShootingFlameTime = undefined;
}

/*
	Name: function_1aacf7d4
	Namespace: namespace_19d9d56d
	Checksum: 0xD1A9ED74
	Offset: 0x12D0
	Size: 0x2EB
	Parameters: 0
	Flags: Private
*/
function private function_1aacf7d4()
{
	if(isdefined(self.m_claw))
	{
		self.m_claw delete();
		self.m_claw = undefined;
	}
	self.fx_field = 0;
	org = self GetTagOrigin("tag_claw");
	ang = self GetTagAngles("tag_claw");
	self.m_claw = spawn("script_model", org);
	self.m_claw SetModel("c_t7_zm_dlchd_origins_mech_claw");
	self.m_claw.angles = ang;
	self.m_claw LinkTo(self, "tag_claw");
	self.m_claw useanimtree(-1);
	if(isdefined(self.m_claw_damage_trigger))
	{
		self.m_claw_damage_trigger Unlink();
		self.m_claw_damage_trigger delete();
		self.m_claw_damage_trigger = undefined;
	}
	trigger_spawnflags = 0;
	trigger_radius = 3;
	trigger_height = 15;
	self.m_claw_damage_trigger = spawn("script_model", org);
	self.m_claw_damage_trigger SetModel("p7_chemistry_kit_large_bottle");
	ang = combineangles(VectorScale((-1, 0, 0), 90), ang);
	self.m_claw_damage_trigger.angles = ang;
	self.m_claw_damage_trigger Hide();
	self.m_claw_damage_trigger SetCanDamage(1);
	self.m_claw_damage_trigger.health = 10000;
	self.m_claw_damage_trigger EnableLinkTo();
	self.m_claw_damage_trigger LinkTo(self, "tag_claw");
	self thread function_5dfc412a();
	self HidePart("tag_claw");
}

/*
	Name: function_5dfc412a
	Namespace: namespace_19d9d56d
	Checksum: 0x34E549BA
	Offset: 0x15C8
	Size: 0x165
	Parameters: 0
	Flags: Private
*/
function private function_5dfc412a()
{
	self endon("death");
	self.m_claw_damage_trigger endon("death");
	while(1)
	{
		self.m_claw_damage_trigger waittill("damage", amount, inflictor, direction, point, type, tagName, modelName, partName, weaponName, iDFlags);
		self.m_claw_damage_trigger.health = 10000;
		if(self.m_claw islinkedto(self))
		{
			continue;
		}
		if(zm_utility::is_player_valid(inflictor))
		{
			self DoDamage(1, inflictor.origin, inflictor, inflictor, "left_hand", type);
			self.m_claw SetCanDamage(0);
			self notify("claw_damaged");
		}
	}
}

/*
	Name: function_31c4b972
	Namespace: namespace_19d9d56d
	Checksum: 0x4AB73000
	Offset: 0x1738
	Size: 0x4B
	Parameters: 0
	Flags: Private
*/
function private function_31c4b972()
{
	self endon("claw_complete");
	self util::waittill_either("death", "kill_claw");
	self function_90832db7();
}

/*
	Name: function_90832db7
	Namespace: namespace_19d9d56d
	Checksum: 0x3488FB5D
	Offset: 0x1790
	Size: 0x3C3
	Parameters: 0
	Flags: Private
*/
function private function_90832db7()
{
	~;
	self.fx_field = self.fx_field & 256;
	~self.fx_field;
	self.fx_field = self.fx_field & 64;
	self clientfield::set("mechz_fx", self.fx_field);
	self function_9bfd96c8();
	if(isdefined(self.m_claw))
	{
		self.m_claw ClearAnim(%root, 0.2);
		if(isdefined(self.m_claw.fx_ent))
		{
			self.m_claw.fx_ent delete();
			self.m_claw.fx_ent = undefined;
		}
		if(!(isdefined(self.has_powercap) && self.has_powercap))
		{
			self function_4208b4ec();
			level flag::clear("mechz_launching_claw");
		}
		else if(!self.m_claw islinkedto(self))
		{
			v_claw_origin = self GetTagOrigin("tag_claw");
			v_claw_angles = self GetTagAngles("tag_claw");
			n_dist = Distance(self.m_claw.origin, v_claw_origin);
			n_time = n_dist / 1000;
			self.m_claw moveto(v_claw_origin, max(0.05, n_time));
			self.m_claw PlayLoopSound("zmb_ai_mechz_claw_loop_in", 0.1);
			self.m_claw waittill("movedone");
			v_claw_origin = self GetTagOrigin("tag_claw");
			v_claw_angles = self GetTagAngles("tag_claw");
			self.m_claw playsound("zmb_ai_mechz_claw_back");
			self.m_claw StopLoopSound(1);
			self.m_claw.origin = v_claw_origin;
			self.m_claw.angles = v_claw_angles;
			self.m_claw ClearAnim(%root, 0.2);
			self.m_claw LinkTo(self, "tag_claw", (0, 0, 0));
		}
		self.m_claw SetAnim(%ai_zombie_mech_grapple_arm_closed_idle, 1, 0.2, 1);
	}
	self notify("claw_complete");
	self.var_7bee990f = 0;
}

/*
	Name: function_4208b4ec
	Namespace: namespace_19d9d56d
	Checksum: 0xC95B0CC8
	Offset: 0x1B60
	Size: 0x135
	Parameters: 0
	Flags: Private
*/
function private function_4208b4ec()
{
	if(isdefined(self.m_claw))
	{
		self.m_claw SetAnim(%ai_zombie_mech_grapple_arm_open_idle, 1, 0.2, 1);
		if(isdefined(self.m_claw.fx_ent))
		{
			self.m_claw.fx_ent delete();
		}
		self.m_claw Unlink();
		self.m_claw PhysicsLaunch(self.m_claw.origin, (0, 0, -1));
		self.m_claw thread function_36db86b();
		self.m_claw = undefined;
	}
	if(isdefined(self.m_claw_damage_trigger))
	{
		self.m_claw_damage_trigger Unlink();
		self.m_claw_damage_trigger delete();
		self.m_claw_damage_trigger = undefined;
	}
}

/*
	Name: function_36db86b
	Namespace: namespace_19d9d56d
	Checksum: 0x170A4A0C
	Offset: 0x1CA0
	Size: 0x1B
	Parameters: 0
	Flags: Private
*/
function private function_36db86b()
{
	wait(30);
	self delete();
}

/*
	Name: function_9bfd96c8
	Namespace: namespace_19d9d56d
	Checksum: 0x3726CB94
	Offset: 0x1CC8
	Size: 0x1DB
	Parameters: 1
	Flags: Private
*/
function private function_9bfd96c8(bopenclaw)
{
	self.explosive_dmg_taken_on_grab_start = undefined;
	if(isdefined(self.e_grabbed))
	{
		if(isPlayer(self.e_grabbed))
		{
			self.e_grabbed clientfield::set_to_player("mechz_grab", 0);
			self.e_grabbed AllowCrouch(1);
			self.e_grabbed AllowProne(1);
		}
		if(!isdefined(self.e_grabbed._fall_down_anchor))
		{
			trace_start = self.e_grabbed.origin + VectorScale((0, 0, 1), 70);
			trace_end = self.e_grabbed.origin + VectorScale((0, 0, -1), 500);
			drop_trace = playerphysicstrace(trace_start, trace_end) + VectorScale((0, 0, 1), 24);
			self.e_grabbed Unlink();
			self.e_grabbed SetOrigin(drop_trace);
		}
		self.e_grabbed = undefined;
		if(isdefined(bopenclaw) && bopenclaw)
		{
			self.m_claw SetAnim(%ai_zombie_mech_grapple_arm_open_idle, 1, 0.2, 1);
		}
	}
}

/*
	Name: function_7c33f4fb
	Namespace: namespace_19d9d56d
	Checksum: 0x821DF5F5
	Offset: 0x1EB0
	Size: 0x2B
	Parameters: 0
	Flags: Private
*/
function private function_7c33f4fb()
{
	if(!isdefined(self.explosive_dmg_taken))
	{
		self.explosive_dmg_taken = 0;
	}
	self.explosive_dmg_taken_on_grab_start = self.explosive_dmg_taken;
}

/*
	Name: function_d6f31ed2
	Namespace: namespace_19d9d56d
	Checksum: 0x941D14BB
	Offset: 0x1EE8
	Size: 0x3B
	Parameters: 0
	Flags: Private
*/
function private function_d6f31ed2()
{
	self MechzServerUtils::hide_part("tag_claw");
	self.m_claw Hide();
}

/*
	Name: function_5f5eaf3a
	Namespace: namespace_19d9d56d
	Checksum: 0xA7799255
	Offset: 0x1F30
	Size: 0xAB
	Parameters: 1
	Flags: Private
*/
function private function_5f5eaf3a(ai_mechz)
{
	self endon("disconnect");
	self zm_audio::create_and_play_dialog("general", "mech_grab");
	while(isdefined(self) && (isdefined(self.isSpeaking) && self.isSpeaking))
	{
		wait(0.1);
	}
	wait(1);
	if(isalive(ai_mechz) && isdefined(ai_mechz.e_grabbed))
	{
		ai_mechz thread play_shoot_arm_hint_vo();
	}
}

/*
	Name: play_shoot_arm_hint_vo
	Namespace: namespace_19d9d56d
	Checksum: 0xBA759057
	Offset: 0x1FE8
	Size: 0x187
	Parameters: 0
	Flags: Private
*/
function private play_shoot_arm_hint_vo()
{
	self endon("death");
	while(1)
	{
		if(!isdefined(self.e_grabbed))
		{
			return;
		}
		a_players = GetPlayers();
		foreach(player in a_players)
		{
			if(player == self.e_grabbed)
			{
				continue;
			}
			if(DistanceSquared(self.origin, player.origin) < 1000000)
			{
				if(player util::is_player_looking_at(self.origin + VectorScale((0, 0, 1), 60), 0.75))
				{
					if(!(isdefined(player.dontspeak) && player.dontspeak))
					{
						player zm_audio::create_and_play_dialog("general", "shoot_mech_arm");
						return;
					}
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_671deda5
	Namespace: namespace_19d9d56d
	Checksum: 0x75701F2F
	Offset: 0x2178
	Size: 0x2B
	Parameters: 0
	Flags: Private
*/
function private function_671deda5()
{
	if(isdefined(self.e_grabbed))
	{
		self thread function_9bfd96c8(1);
	}
}

/*
	Name: function_6028875a
	Namespace: namespace_19d9d56d
	Checksum: 0x34B66BA7
	Offset: 0x21B0
	Size: 0x5B
	Parameters: 0
	Flags: Private
*/
function private function_6028875a()
{
	if(isdefined(self.explosive_dmg_taken_on_grab_start))
	{
		if(isdefined(self.e_grabbed) && self.explosive_dmg_taken - self.explosive_dmg_taken_on_grab_start > self.mechz_explosive_dmg_to_cancel_claw)
		{
			self.show_pain_from_explosive_dmg = 1;
			self thread function_9bfd96c8();
		}
	}
}

/*
	Name: function_8b0a73b5
	Namespace: namespace_19d9d56d
	Checksum: 0x169F6E1E
	Offset: 0x2218
	Size: 0x93
	Parameters: 1
	Flags: Private
*/
function private function_8b0a73b5(mechz)
{
	self endon("death");
	self endon("disconnect");
	mechz endon("death");
	mechz endon("claw_complete");
	mechz endon("kill_claw");
	while(1)
	{
		if(isdefined(self) && self laststand::player_is_in_laststand())
		{
			mechz thread function_9bfd96c8();
			return;
		}
		wait(0.05);
	}
}

/*
	Name: function_bed84b4
	Namespace: namespace_19d9d56d
	Checksum: 0xE32C1EFF
	Offset: 0x22B8
	Size: 0x91
	Parameters: 1
	Flags: Private
*/
function private function_bed84b4(mechz)
{
	self endon("death");
	self endon("disconnect");
	mechz endon("death");
	mechz endon("claw_complete");
	mechz endon("kill_claw");
	while(1)
	{
		self waittill("hash_10c37787");
		if(isdefined(self) && self.bgb === "zm_bgb_anywhere_but_here")
		{
			mechz thread function_9bfd96c8();
			return;
		}
	}
}

/*
	Name: function_38d105a4
	Namespace: namespace_19d9d56d
	Checksum: 0xF69E84FF
	Offset: 0x2358
	Size: 0x79
	Parameters: 1
	Flags: Private
*/
function private function_38d105a4(mechz)
{
	self endon("death");
	self endon("disconnect");
	mechz endon("death");
	mechz endon("claw_complete");
	mechz endon("kill_claw");
	while(1)
	{
		self waittill("hash_e2be4752");
		mechz thread function_9bfd96c8();
		return;
	}
}

/*
	Name: function_672f9804
	Namespace: namespace_19d9d56d
	Checksum: 0xF302A04C
	Offset: 0x23E0
	Size: 0xE4B
	Parameters: 0
	Flags: Private
*/
function private function_672f9804()
{
	self endon("death");
	self endon("kill_claw");
	if(!isdefined(self.favoriteenemy))
	{
		return;
	}
	v_claw_origin = self GetTagOrigin("tag_claw");
	v_claw_angles = VectorToAngles(self.origin - self.favoriteenemy.origin);
	self.fx_field = self.fx_field | 256;
	self clientfield::set("mechz_fx", self.fx_field);
	self.m_claw SetAnim(%ai_zombie_mech_grapple_arm_open_idle, 1, 0, 1);
	self.m_claw Unlink();
	self.m_claw.fx_ent = spawn("script_model", self.m_claw GetTagOrigin("tag_claw"));
	self.m_claw.fx_ent.angles = self.m_claw GetTagAngles("tag_claw");
	self.m_claw.fx_ent SetModel("tag_origin");
	self.m_claw.fx_ent LinkTo(self.m_claw, "tag_claw");
	self.m_claw.fx_ent clientfield::set("mechz_claw", 1);
	self clientfield::set("mechz_wpn_source", 1);
	v_enemy_origin = self.favoriteenemy.origin + VectorScale((0, 0, 1), 36);
	n_dist = Distance(v_claw_origin, v_enemy_origin);
	n_time = n_dist / 1200;
	self playsound("zmb_ai_mechz_claw_fire");
	self.m_claw moveto(v_enemy_origin, n_time);
	self.m_claw thread function_2998f2a1();
	self.m_claw PlayLoopSound("zmb_ai_mechz_claw_loop_out", 0.1);
	self.e_grabbed = undefined;
	do
	{
		a_players = GetPlayers();
		foreach(player in a_players)
		{
			if(!zm_utility::is_player_valid(player, 1, 1) || !player player_can_be_grabbed())
			{
				continue;
			}
			n_dist_sq = DistanceSquared(player.origin + VectorScale((0, 0, 1), 36), self.m_claw.origin);
			if(n_dist_sq < 2304)
			{
				clip_mask = 1 | 8;
				var_7d76644b = self.origin + VectorScale((0, 0, 1), 65);
				trace = PhysicsTrace(var_7d76644b, player.origin + VectorScale((0, 0, 1), 30), (-15, -15, -20), (15, 15, 40), self, clip_mask);
				b_cansee = trace["fraction"] == 1 || (isdefined(trace["entity"]) && trace["entity"] == player);
				if(!b_cansee)
				{
					continue;
				}
				if(isdefined(player.hasRiotShield) && player.hasRiotShield && (isdefined(player.hasRiotShieldEquipped) && player.hasRiotShieldEquipped))
				{
					shield_dmg = level.zombie_vars["riotshield_hit_points"];
					player riotshield::player_damage_shield(shield_dmg - 1, 1);
					wait(1);
					player riotshield::player_damage_shield(1, 1);
				}
				else
				{
					self.e_grabbed = player;
					self.e_grabbed clientfield::set_to_player("mechz_grab", 1);
					self.e_grabbed PlayerLinkToDelta(self.m_claw, "tag_attach_player");
					self.e_grabbed SetPlayerAngles(VectorToAngles(self.origin - self.e_grabbed.origin));
					self.e_grabbed playsound("zmb_ai_mechz_claw_grab");
					self.e_grabbed SetStance("stand");
					self.e_grabbed AllowCrouch(0);
					self.e_grabbed AllowProne(0);
					self.e_grabbed thread function_5f5eaf3a(self);
					self.e_grabbed thread function_bed84b4(self);
					self.e_grabbed thread function_38d105a4(self);
					if(!level flag::get("mechz_claw_move_complete"))
					{
						self.m_claw moveto(self.m_claw.origin, 0.05);
					}
				}
				break;
			}
		}
		wait(0.05);
	}
	while(!(!level flag::get("mechz_claw_move_complete") && !isdefined(self.e_grabbed)));
	if(!isdefined(self.e_grabbed))
	{
		a_ai_zombies = zombie_utility::get_round_enemy_array();
		foreach(ai_zombie in a_ai_zombies)
		{
			if(!isalive(ai_zombie) || (isdefined(ai_zombie.is_giant_robot) && ai_zombie.is_giant_robot) || (isdefined(ai_zombie.is_mechz) && ai_zombie.is_mechz))
			{
				continue;
			}
			n_dist_sq = DistanceSquared(ai_zombie.origin + VectorScale((0, 0, 1), 36), self.m_claw.origin);
			if(n_dist_sq < 2304)
			{
				self.e_grabbed = ai_zombie;
				self.e_grabbed LinkTo(self.m_claw, "tag_attach_player", (0, 0, 0));
				self.e_grabbed.mechz_grabbed_by = self;
				break;
			}
		}
	}
	self.m_claw ClearAnim(%root, 0.2);
	self.m_claw SetAnim(%ai_zombie_mech_grapple_arm_closed_idle, 1, 0.2, 1);
	wait(0.5);
	if(isdefined(self.e_grabbed))
	{
		n_time = n_dist / 200;
	}
	else
	{
		n_time = n_dist / 1000;
	}
	self function_7c33f4fb();
	v_claw_origin = self GetTagOrigin("tag_claw");
	v_claw_angles = self GetTagAngles("tag_claw");
	self.m_claw moveto(v_claw_origin, max(0.05, n_time));
	self.m_claw PlayLoopSound("zmb_ai_mechz_claw_loop_in", 0.1);
	self.m_claw waittill("movedone");
	v_claw_origin = self GetTagOrigin("tag_claw");
	v_claw_angles = self GetTagAngles("tag_claw");
	self.m_claw playsound("zmb_ai_mechz_claw_back");
	self.m_claw StopLoopSound(1);
	if(zm_audio::sndIsNetworkSafe())
	{
		self playsound("zmb_ai_mechz_vox_angry");
	}
	self.m_claw.origin = v_claw_origin;
	self.m_claw.angles = v_claw_angles;
	self.m_claw ClearAnim(%root, 0.2);
	self.m_claw LinkTo(self, "tag_claw", (0, 0, 0));
	self.m_claw SetAnim(%ai_zombie_mech_grapple_arm_closed_idle, 1, 0.2, 1);
	self.m_claw.fx_ent delete();
	self.m_claw.fx_ent = undefined;
	~self.m_claw.angles;
	self.fx_field = self.fx_field & 256;
	self clientfield::set("mechz_fx", self.fx_field);
	self clientfield::set("mechz_wpn_source", 0);
	level flag::clear("mechz_launching_claw");
	if(isdefined(self.e_grabbed))
	{
		if(isPlayer(self.e_grabbed) && zm_utility::is_player_valid(self.e_grabbed))
		{
			self.e_grabbed thread function_8b0a73b5(self);
		}
		else if(isai(self.e_grabbed))
		{
			self.e_grabbed thread function_860f0461(self);
		}
		self thread function_eb9df173(self.e_grabbed);
		self AnimScripted("flamethrower_anim", self.origin, self.angles, "ai_zombie_mech_ft_burn_player");
		self zombie_shared::DoNoteTracks("flamethrower_anim");
	}
	level flag::clear("mechz_claw_move_complete");
}

/*
	Name: function_eb9df173
	Namespace: namespace_19d9d56d
	Checksum: 0x96078390
	Offset: 0x3238
	Size: 0x1A9
	Parameters: 1
	Flags: Private
*/
function private function_eb9df173(player)
{
	player endon("death");
	player endon("disconnect");
	self endon("death");
	self endon("claw_complete");
	self endon("kill_claw");
	self thread function_7792d05e(player);
	player thread function_d0e280a0(self);
	self.m_claw SetCanDamage(1);
	while(isdefined(self.e_grabbed))
	{
		self.m_claw waittill("damage", amount, inflictor, direction, point, type, tagName, modelName, partName, weaponName, iDFlags);
		if(zm_utility::is_player_valid(inflictor))
		{
			self DoDamage(1, inflictor.origin, inflictor, inflictor, "left_hand", type);
			self.m_claw SetCanDamage(0);
			self notify("claw_damaged");
			break;
		}
	}
}

/*
	Name: function_7792d05e
	Namespace: namespace_19d9d56d
	Checksum: 0xD27C5750
	Offset: 0x33F0
	Size: 0x8B
	Parameters: 1
	Flags: Private
*/
function private function_7792d05e(player)
{
	self endon("claw_damaged");
	player endon("death");
	player endon("disconnect");
	self util::waittill_any("death", "claw_complete", "kill_claw");
	if(isdefined(self) && isdefined(self.m_claw))
	{
		self.m_claw SetCanDamage(0);
	}
}

/*
	Name: function_d0e280a0
	Namespace: namespace_19d9d56d
	Checksum: 0xBB4AC903
	Offset: 0x3488
	Size: 0xA3
	Parameters: 1
	Flags: Private
*/
function private function_d0e280a0(mechz)
{
	mechz endon("claw_damaged");
	mechz endon("death");
	mechz endon("claw_complete");
	mechz endon("kill_claw");
	self util::waittill_any("death", "disconnect");
	if(isdefined(mechz) && isdefined(mechz.m_claw))
	{
		mechz.m_claw SetCanDamage(0);
	}
}

/*
	Name: function_2998f2a1
	Namespace: namespace_19d9d56d
	Checksum: 0x7FDF7C4B
	Offset: 0x3538
	Size: 0x33
	Parameters: 0
	Flags: Private
*/
function private function_2998f2a1()
{
	self waittill("movedone");
	wait(0.05);
	level flag::set("mechz_claw_move_complete");
}

/*
	Name: function_860f0461
	Namespace: namespace_19d9d56d
	Checksum: 0xB7441423
	Offset: 0x3578
	Size: 0x93
	Parameters: 1
	Flags: Private
*/
function private function_860f0461(mechz)
{
	mechz waittillmatch("flamethrower_anim");
	if(isalive(self))
	{
		self DoDamage(self.health, self.origin, self);
		self zombie_utility::gib_random_parts();
		GibServerUtils::Annihilate(self);
	}
}

