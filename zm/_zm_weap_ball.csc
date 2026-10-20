#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace ball;

/*
	Name: __init__sytem__
	Namespace: ball
	Checksum: 0x4DC8603D
	Offset: 0x3C8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ball", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ball
	Checksum: 0x10DE5810
	Offset: 0x408
	Size: 0x2B9
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("allplayers", "ballcarrier", 15000, 1, "int", &player_ballcarrier_changed, 0, 1);
	clientfield::register("allplayers", "passoption", 15000, 1, "int", &player_passoption_changed, 0, 0);
	clientfield::register("world", "ball_away", 15000, 1, "int", &world_ball_away_changed, 0, 1);
	clientfield::register("world", "ball_score_allies", 15000, 1, "int", &world_ball_score_allies, 0, 1);
	clientfield::register("world", "ball_score_axis", 15000, 1, "int", &world_ball_score_axis, 0, 1);
	clientfield::register("scriptmover", "ball_on_ground_fx", 15000, 1, "int", &ball_on_ground_fx, 0, 0);
	callback::on_localclient_connect(&on_localclient_connect);
	callback::on_spawned(&on_player_spawned);
	level.effect_scriptbundles = [];
	level.effect_scriptbundles["goal"] = struct::get_script_bundle("teamcolorfx", "teamcolorfx_uplink_goal");
	level.effect_scriptbundles["goal_score"] = struct::get_script_bundle("teamcolorfx", "teamcolorfx_uplink_goal_score");
	level._effect["ball_on_ground"] = "dlc1/skyjacked/fx_light_blue_flashing_md_02";
	level._effect["balllight_fx"] = "dlc4/genesis/fx_summoningkey_light_loop";
	level._effect["lght_marker"] = "zombie/fx_weapon_box_marker_zmb";
}

/*
	Name: on_localclient_connect
	Namespace: ball
	Checksum: 0xFF2F5B2F
	Offset: 0x6D0
	Size: 0x17B
	Parameters: 1
	Flags: None
*/
function on_localclient_connect(localClientNum)
{
	objective_ids = [];
	while(!isdefined(objective_ids["allies"]))
	{
		objective_ids["allies"] = ServerObjective_GetObjective(localClientNum, "ball_goal_allies");
		objective_ids["axis"] = ServerObjective_GetObjective(localClientNum, "ball_goal_axis");
		wait(0.05);
	}
	foreach(objective in objective_ids)
	{
		level.goals[key] = spawnstruct();
		level.goals[key].objectiveId = objective;
		setup_goal(localClientNum, level.goals[key]);
	}
	setup_fx(localClientNum);
}

/*
	Name: on_player_spawned
	Namespace: ball
	Checksum: 0x86417DCC
	Offset: 0x858
	Size: 0xE1
	Parameters: 1
	Flags: None
*/
function on_player_spawned(localClientNum)
{
	players = GetPlayers(localClientNum);
	foreach(player in players)
	{
		if(player util::IsEnemyPlayer(self))
		{
			player duplicate_render::update_dr_flag(localClientNum, "ballcarrier", 0);
		}
	}
}

/*
	Name: setup_goal
	Namespace: ball
	Checksum: 0x3DA0FB73
	Offset: 0x948
	Size: 0xBF
	Parameters: 2
	Flags: None
*/
function setup_goal(localClientNum, goal)
{
	goal.origin = ServerObjective_GetObjectiveOrigin(localClientNum, goal.objectiveId);
	goal_entity = ServerObjective_GetObjectiveEntity(localClientNum, goal.objectiveId);
	if(isdefined(goal_entity))
	{
		goal.origin = goal_entity.origin;
	}
	goal.team = ServerObjective_GetObjectiveTeam(localClientNum, goal.objectiveId);
}

/*
	Name: setup_goal_fx
	Namespace: ball
	Checksum: 0xCA107740
	Offset: 0xA10
	Size: 0xC3
	Parameters: 3
	Flags: None
*/
function setup_goal_fx(localClientNum, goal, effects)
{
	if(isdefined(goal.base_fx))
	{
		stopfx(localClientNum, goal.base_fx);
	}
	goal.base_fx = playFX(localClientNum, effects[goal.team], goal.origin);
	SetFxTeam(localClientNum, goal.base_fx, goal.team);
}

/*
	Name: setup_fx
	Namespace: ball
	Checksum: 0x95B9D2E1
	Offset: 0xAE0
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function setup_fx(localClientNum)
{
	effects = [];
	effects["allies"] = "ui/fx_uplink_goal_marker";
	effects["axis"] = "ui/fx_uplink_goal_marker";
	foreach(goal in level.goals)
	{
	}
	thread watch_for_team_change(localClientNum);
}

/*
	Name: play_score_fx
	Namespace: ball
	Checksum: 0x509A5365
	Offset: 0xBC0
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function play_score_fx(localClientNum, goal)
{
	effects = [];
	effects["allies"] = "ui/fx_uplink_goal_marker_flash";
	effects["axis"] = "ui/fx_uplink_goal_marker_flash";
	fx_handle = playFX(localClientNum, effects[goal.team], goal.origin);
	SetFxTeam(localClientNum, fx_handle, goal.team);
}

/*
	Name: play_goal_score_fx
	Namespace: ball
	Checksum: 0x18C62B62
	Offset: 0xC88
	Size: 0x7B
	Parameters: 6
	Flags: None
*/
function play_goal_score_fx(localClientNum, team, oldVal, newVal, bInitialSnap, bWasTimeJump)
{
	if(newVal != oldVal && !bInitialSnap && !bWasTimeJump)
	{
		play_score_fx(localClientNum, level.goals[team]);
	}
}

/*
	Name: world_ball_score_allies
	Namespace: ball
	Checksum: 0xFC6E145F
	Offset: 0xD10
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function world_ball_score_allies(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	play_goal_score_fx(localClientNum, "allies", oldVal, newVal, bInitialSnap, bWasTimeJump);
}

/*
	Name: world_ball_score_axis
	Namespace: ball
	Checksum: 0x30743B6D
	Offset: 0xD88
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function world_ball_score_axis(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	play_goal_score_fx(localClientNum, "axis", oldVal, newVal, bInitialSnap, bWasTimeJump);
}

/*
	Name: player_ballcarrier_changed
	Namespace: ball
	Checksum: 0x2A21C751
	Offset: 0xE00
	Size: 0x18B
	Parameters: 7
	Flags: None
*/
function player_ballcarrier_changed(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	localPlayer = GetLocalPlayer(localClientNum);
	if(localPlayer == self)
	{
		if(newVal)
		{
			self._hasball = 1;
		}
		else
		{
			self._hasball = 0;
			SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "ballGametype.passOption"), 0);
		}
	}
	if(localPlayer != self && self isFriendly(localClientNum))
	{
		self set_player_ball_carrier_dr(localClientNum, newVal);
	}
	else
	{
		self set_player_ball_carrier_dr(localClientNum, 0);
	}
	if(isdefined(level.ball_carrier) && level.ball_carrier != self)
	{
		return;
	}
	level notify("watch_for_death");
	if(newVal == 1)
	{
		self thread watch_for_death(localClientNum);
	}
}

/*
	Name: set_hud
	Namespace: ball
	Checksum: 0xA9F2ADEB
	Offset: 0xF98
	Size: 0x20B
	Parameters: 1
	Flags: None
*/
function set_hud(localClientNum)
{
	level.ball_carrier = self;
	friendly = self isFriendly(localClientNum);
	if(isdefined(self.name))
	{
		SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "ballGametype.ballStatusText"), self.name);
	}
	else
	{
		SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "ballGametype.ballStatusText"), "");
	}
	if(isdefined(friendly))
	{
		SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "ballGametype.ballHeldByFriendly"), friendly);
		SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "ballGametype.ballHeldByEnemy"), !friendly);
	}
	else
	{
		SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "ballGametype.ballHeldByFriendly"), 0);
		SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "ballGametype.ballHeldByEnemy"), 0);
	}
}

/*
	Name: clear_hud
	Namespace: ball
	Checksum: 0x1A097270
	Offset: 0x11B0
	Size: 0xEB
	Parameters: 1
	Flags: None
*/
function clear_hud(localClientNum)
{
	level.ball_carrier = undefined;
	SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "ballGametype.ballHeldByEnemy"), 0);
	SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "ballGametype.ballHeldByFriendly"), 0);
	SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "ballGametype.ballStatusText"), &"MPUI_BALL_AWAY");
}

/*
	Name: watch_for_death
	Namespace: ball
	Checksum: 0x67116BD0
	Offset: 0x12A8
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function watch_for_death(localClientNum)
{
	level endon("watch_for_death");
	self waittill("entityshutdown");
}

/*
	Name: player_passoption_changed
	Namespace: ball
	Checksum: 0x41442339
	Offset: 0x12D8
	Size: 0xF3
	Parameters: 7
	Flags: None
*/
function player_passoption_changed(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	localPlayer = GetLocalPlayer(localClientNum);
	if(localPlayer != self && self isFriendly(localClientNum))
	{
		if(isdefined(localPlayer._hasball) && localPlayer._hasball)
		{
			SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "ballGametype.passOption"), newVal);
		}
	}
}

/*
	Name: world_ball_away_changed
	Namespace: ball
	Checksum: 0xFE63EA6F
	Offset: 0x13D8
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function world_ball_away_changed(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "ballGametype.ballAway"), newVal);
}

/*
	Name: set_player_ball_carrier_dr
	Namespace: ball
	Checksum: 0x5E082203
	Offset: 0x1468
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function set_player_ball_carrier_dr(localClientNum, on_off)
{
	self duplicate_render::update_dr_flag(localClientNum, "ballcarrier", on_off);
}

/*
	Name: set_player_pass_option_dr
	Namespace: ball
	Checksum: 0x24FA823C
	Offset: 0x14B0
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function set_player_pass_option_dr(localClientNum, on_off)
{
	self duplicate_render::update_dr_flag(localClientNum, "passoption", on_off);
}

/*
	Name: resetOnDemoJump
	Namespace: ball
	Checksum: 0x2A5801
	Offset: 0x14F8
	Size: 0x4F
	Parameters: 3
	Flags: None
*/
function resetOnDemoJump(localClientNum, goal, effects)
{
	for(;;)
	{
		level waittill("demo_jump" + localClientNum);
		setup_goal_fx(localClientNum, goal, effects);
	}
}

/*
	Name: watch_for_team_change
	Namespace: ball
	Checksum: 0x4E6236C7
	Offset: 0x1550
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function watch_for_team_change(localClientNum)
{
	level notify("end_team_change_watch");
	level endon("end_team_change_watch");
	level waittill("team_changed");
	thread setup_fx(localClientNum);
}

/*
	Name: ball_on_ground_fx
	Namespace: ball
	Checksum: 0xD1E2CB69
	Offset: 0x15A8
	Size: 0x20D
	Parameters: 7
	Flags: None
*/
function ball_on_ground_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(!isdefined(self.var_ff242ed4))
		{
			self.var_ff242ed4 = playFX(localClientNum, level._effect["ball_on_ground"], self.origin + VectorScale((0, 0, 1), 72), (0, 0, 1), (1, 0, 0));
		}
		if(!isdefined(self.var_cd030ed9))
		{
			self.var_cd030ed9 = playFX(localClientNum, level._effect["balllight_fx"], self.origin + VectorScale((0, 0, 1), 72), (0, 0, 1), (1, 0, 0));
		}
		if(!isdefined(self.var_2e7f5bfb))
		{
			self.var_2e7f5bfb = playFX(localClientNum, level._effect["lght_marker"], self.origin + VectorScale((0, 0, 1), 72), (0, 0, 1), (1, 0, 0));
		}
	}
	else if(isdefined(self.var_ff242ed4))
	{
		stopfx(localClientNum, self.var_ff242ed4);
		self.var_ff242ed4 = undefined;
	}
	if(isdefined(self.var_cd030ed9))
	{
		stopfx(localClientNum, self.var_cd030ed9);
		self.var_cd030ed9 = undefined;
	}
	if(isdefined(self.var_2e7f5bfb))
	{
		stopfx(localClientNum, self.var_2e7f5bfb);
		self.var_2e7f5bfb = undefined;
	}
}

