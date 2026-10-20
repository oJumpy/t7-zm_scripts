#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_sumpf;
#using scripts\zm\zm_sumpf_zipline;

#namespace zm_sumpf_trap_pendulum;

/*
	Name: initPendulumTrap
	Namespace: zm_sumpf_trap_pendulum
	Checksum: 0x21D92F5E
	Offset: 0x428
	Size: 0x20F
	Parameters: 0
	Flags: None
*/
function initPendulumTrap()
{
	penBuyTrigger = GetEntArray("pendulum_buy_trigger", "targetname");
	for(i = 0; i < penBuyTrigger.size; i++)
	{
		penBuyTrigger[i].lever = GetEnt(penBuyTrigger[i].target, "targetname");
		penBuyTrigger[i].penDamageTrig = GetEnt(penBuyTrigger[i].lever.target, "targetname");
		penBuyTrigger[i].pen = GetEnt(penBuyTrigger[i].penDamageTrig.target, "targetname");
		penBuyTrigger[i].pulley = GetEnt(penBuyTrigger[i].pen.target, "targetname");
		penBuyTrigger[i]._trap_type = "flogger";
	}
	penBuyTrigger[0].penDamageTrig EnableLinkTo();
	penBuyTrigger[0].penDamageTrig LinkTo(penBuyTrigger[0].pen);
	level thread namespace_e722cafc::turnLightGreen("pendulum_light");
	level.var_99432870 = 0;
}

/*
	Name: moveLeverDown
	Namespace: zm_sumpf_trap_pendulum
	Checksum: 0x84A42404
	Offset: 0x640
	Size: 0xE1
	Parameters: 0
	Flags: None
*/
function moveLeverDown()
{
	soundent_left = GetEnt("switch_left", "targetname");
	soundent_right = GetEnt("switch_right", "targetname");
	self.lever RotatePitch(180, 0.5);
	soundent_left playsound("zmb_switch_on");
	soundent_right playsound("zmb_switch_on");
	self.lever waittill("rotatedone");
	self notify("leverDown");
}

/*
	Name: moveLeverUp
	Namespace: zm_sumpf_trap_pendulum
	Checksum: 0xDAA11660
	Offset: 0x730
	Size: 0xE1
	Parameters: 0
	Flags: None
*/
function moveLeverUp()
{
	soundent_left = GetEnt("switch_left", "targetname");
	soundent_right = GetEnt("switch_right", "targetname");
	self.lever RotatePitch(-180, 0.5);
	soundent_left playsound("zmb_switch_off");
	soundent_right playsound("zmb_switch_off");
	self.lever waittill("rotatedone");
	self notify("leverUp");
}

/*
	Name: hint_string
	Namespace: zm_sumpf_trap_pendulum
	Checksum: 0x2A2F17D1
	Offset: 0x820
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function hint_string(string)
{
	if(string == &"ZOMBIE_BUTTON_BUY_TRAP")
	{
		self.is_available = 1;
		self.zombie_cost = 750;
		self.in_use = 0;
		self setHintString(string, self.zombie_cost);
	}
	else
	{
		self setHintString(string);
	}
	self setcursorhint("HINT_NOICON");
}

/*
	Name: penThink
	Namespace: zm_sumpf_trap_pendulum
	Checksum: 0x98DE429A
	Offset: 0x8D0
	Size: 0x437
	Parameters: 0
	Flags: None
*/
function penThink()
{
	self setHintString("");
	pa_system = GetEnt("speaker_by_log", "targetname");
	wait(0.5);
	self.is_available = 1;
	self.zombie_cost = 750;
	self setHintString(&"ZOMBIE_BUTTON_BUY_TRAP", self.zombie_cost);
	self setcursorhint("HINT_NOICON");
	triggers = GetEntArray("pendulum_buy_trigger", "targetname");
	Array::thread_all(triggers, &hint_string, &"ZOMBIE_BUTTON_BUY_TRAP");
	while(1)
	{
		self waittill("trigger", who);
		self.used_by = who;
		if(who zm_utility::in_revive_trigger() || level.var_99432870)
		{
			continue;
		}
		if(zombie_utility::is_player_valid(who))
		{
			if(who zm_score::can_player_purchase(self.zombie_cost))
			{
				if(!level.var_99432870)
				{
					level.var_99432870 = 1;
					level thread namespace_e722cafc::turnLightRed("pendulum_light");
					Array::thread_all(triggers, &hint_string, &"ZOMBIE_TRAP_ACTIVE");
					zm_utility::play_sound_at_pos("purchase", who.origin);
					who thread zm_audio::create_and_play_dialog("level", "trap_log");
					who zm_score::minus_to_player_score(self.zombie_cost);
					self thread moveLeverDown();
					self waittill("leverDown");
					motor_left = GetEnt("engine_loop_left", "targetname");
					motor_right = GetEnt("engine_loop_right", "targetname");
					playsoundatposition("zmb_motor_start_left", motor_left.origin);
					playsoundatposition("zmb_motor_start_right", motor_right.origin);
					wait(0.5);
					self thread activatePen(motor_left, motor_right, who);
					self waittill("penDown");
					Array::thread_all(triggers, &hint_string, &"ZOMBIE_TRAP_COOLDOWN");
					self thread moveLeverUp();
					self waittill("leverUp");
					wait(45);
					pa_system playsound("zmb_warning");
					level thread namespace_e722cafc::turnLightGreen("pendulum_light");
					level.var_99432870 = 0;
					Array::thread_all(triggers, &hint_string, &"ZOMBIE_BUTTON_BUY_TRAP");
				}
			}
		}
	}
}

/*
	Name: activatePen
	Namespace: zm_sumpf_trap_pendulum
	Checksum: 0xF4E47C6C
	Offset: 0xD10
	Size: 0x343
	Parameters: 3
	Flags: None
*/
function activatePen(motor_left, motor_right, who)
{
	wheel_left = spawn("script_origin", motor_left.origin);
	wheel_right = spawn("script_origin", motor_right.origin);
	util::wait_network_frame();
	motor_left PlayLoopSound("zmb_motor_loop_left");
	motor_right PlayLoopSound("zmb_motor_loop_right");
	util::wait_network_frame();
	wheel_left PlayLoopSound("zmb_wheel_loop");
	wheel_right PlayLoopSound("zmb_belt_loop");
	self.pen notify("stopmonitorsolid");
	self.pen notsolid();
	self.penDamageTrig TriggerEnable(1);
	self.penDamageTrig thread penDamage(self, who);
	self.penactive = 1;
	if(self.script_noteworthy == "1")
	{
		self.pulley RotatePitch(-14040, 30, 6, 6);
		self.pen RotatePitch(-14040, 30, 6, 6);
	}
	else
	{
		self.pulley RotatePitch(14040, 30, 6, 6);
		self.pen RotatePitch(14040, 30, 6, 6);
	}
	level thread trap_sounds(motor_left, motor_right, wheel_left, wheel_right);
	self.pen thread blade_sounds();
	self.pen waittill("rotatedone");
	self.penDamageTrig TriggerEnable(0);
	self.penactive = 0;
	self.pen thread zm_sumpf_zipline::objectSolid();
	self notify("penDown");
	level notify("stop_blade_sounds");
	wait(3);
	wheel_left delete();
	wheel_right delete();
}

/*
	Name: blade_sounds
	Namespace: zm_sumpf_trap_pendulum
	Checksum: 0x3D95905D
	Offset: 0x1060
	Size: 0x269
	Parameters: 0
	Flags: None
*/
function blade_sounds()
{
	self endon("rotatedone");
	blade_left = GetEnt("blade_left", "targetname");
	blade_right = GetEnt("blade_right", "targetname");
	lastAngle = self.angles[0];
	for(;;)
	{
		wooshAngle = 90;
		wait(0.01);
		angle = self.angles[0];
		speed = Int(Abs(angle - lastAngle)) % 360;
		relPos = Int(Abs(angle)) % 360;
		lastRelPos = Int(Abs(lastAngle)) % 360;
		if(relPos == lastRelPos || speed < 7)
		{
			lastAngle = angle;
			continue;
		}
		if(relPos > wooshAngle && lastRelPos <= wooshAngle)
		{
			blade_left playsound("zmb_blade_right");
			blade_right playsound("zmb_blade_right");
		}
		if(relPos + 180 % 360 > wooshAngle && lastRelPos + 180 % 360 <= wooshAngle)
		{
			blade_left playsound("zmb_blade_right");
			blade_right playsound("zmb_blade_right");
		}
		lastAngle = angle;
	}
}

/*
	Name: trap_sounds
	Namespace: zm_sumpf_trap_pendulum
	Checksum: 0xB9AFC176
	Offset: 0x12D8
	Size: 0xD3
	Parameters: 4
	Flags: None
*/
function trap_sounds(motor_left, motor_right, wheel_left, wheel_right)
{
	wait(13);
	motor_left StopLoopSound(2);
	motor_left playsound("zmb_motor_stop_left");
	motor_right StopLoopSound(2);
	motor_right playsound("zmb_motor_stop_right");
	wait(8);
	wheel_left StopLoopSound(8);
	wheel_right StopLoopSound(8);
}

/*
	Name: penDamage
	Namespace: zm_sumpf_trap_pendulum
	Checksum: 0x76900D20
	Offset: 0x13B8
	Size: 0xB7
	Parameters: 2
	Flags: None
*/
function penDamage(parent, who)
{
	level thread customTimer();
	while(1)
	{
		self waittill("trigger", ent);
		if(parent.penactive == 1)
		{
			if(isPlayer(ent))
			{
				ent thread playerPenDamage();
			}
			else
			{
				ent thread zombiePenDamage(parent, who);
			}
		}
	}
}

/*
	Name: customTimer
	Namespace: zm_sumpf_trap_pendulum
	Checksum: 0xF4BFAC35
	Offset: 0x1478
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function customTimer()
{
	for(level.my_time = 0; level.my_time <= 20;  = 0)
	{
		wait(0.1);
	}
}

/*
	Name: playerPenDamage
	Namespace: zm_sumpf_trap_pendulum
	Checksum: 0x866F0943
	Offset: 0x14C8
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function playerPenDamage()
{
	self endon("death");
	self endon("disconnect");
	players = GetPlayers();
	if(players.size == 1)
	{
		self DoDamage(80, self.origin + VectorScale((0, 0, 1), 20));
		self SetStance("crouch");
	}
	else if(!self laststand::player_is_in_laststand())
	{
		RadiusDamage(self.origin, 10, self.health + 100, self.health + 100);
	}
}

/*
	Name: zombiePenDamage
	Namespace: zm_sumpf_trap_pendulum
	Checksum: 0xE12DA9F6
	Offset: 0x15C0
	Size: 0x263
	Parameters: 2
	Flags: None
*/
function zombiePenDamage(parent, who)
{
	self endon("death");
	self.var_9a9a0f55 = parent;
	self.var_aa99de67 = who;
	parent.activated_by_player = who;
	if(level flag::get("dog_round"))
	{
		self.a.nodeath = 1;
	}
	else if(!isdefined(level.numLaunched))
	{
		level thread launch_monitor();
	}
	if(!isdefined(self.flung))
	{
		if(parent.script_noteworthy == "1")
		{
			x = randomIntRange(200, 250);
			y = randomIntRange(-35, 35);
			z = randomIntRange(95, 120);
		}
		else
		{
			x = randomIntRange(-250, -200);
			y = randomIntRange(-35, 35);
			z = randomIntRange(95, 120);
		}
		if(level.my_time < 6)
		{
			adjustment = level.my_time / 6;
		}
		else if(level.my_time > 24)
		{
			adjustment = 30 - level.my_time / 6;
		}
		else
		{
			adjustment = 1;
		}
		x = x * adjustment;
		y = y * adjustment;
		z = z * adjustment;
		self thread do_launch(x, y, z, parent);
	}
}

/*
	Name: launch_monitor
	Namespace: zm_sumpf_trap_pendulum
	Checksum: 0xCC78F9F3
	Offset: 0x1830
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function launch_monitor()
{
	level.numLaunched = 0;
	while(1)
	{
		util::wait_network_frame();
		util::wait_network_frame();
		level.numLaunched = 0;
	}
}

/*
	Name: do_launch
	Namespace: zm_sumpf_trap_pendulum
	Checksum: 0x11DAFD2A
	Offset: 0x1888
	Size: 0x13B
	Parameters: 4
	Flags: None
*/
function do_launch(x, y, z, parent)
{
	self.flung = 1;
	while(level.numLaunched > 4)
	{
		util::wait_network_frame();
	}
	self thread play_imp_sound();
	self StartRagdoll();
	self LaunchRagdoll((x, y, z));
	util::wait_network_frame();
	self DoDamage(self.health, self.origin, parent);
	if(isdefined(parent.activated_by_player) && isPlayer(parent.activated_by_player))
	{
		parent.activated_by_player zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_KILL_TRAP");
	}
	level.numLaunched++;
}

/*
	Name: flogger_vocal_monitor
	Namespace: zm_sumpf_trap_pendulum
	Checksum: 0xAEE0D34
	Offset: 0x19D0
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function flogger_vocal_monitor()
{
	while(1)
	{
		level.numFloggerVox = 0;
		util::wait_network_frame();
		util::wait_network_frame();
	}
}

/*
	Name: play_imp_sound
	Namespace: zm_sumpf_trap_pendulum
	Checksum: 0x427ED8A9
	Offset: 0x1A18
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function play_imp_sound()
{
	if(!isdefined(level.numFloggerVox))
	{
		level thread flogger_vocal_monitor();
	}
	self playsound("zmb_flogger_death");
	if(level.numFloggerVox < 5)
	{
		self playsound("zmb_vocals_zombie_death");
		self clientfield::set("zombie_flogger_trap", 1);
		level.numFloggerVox++;
	}
	wait(0.75);
	self DoDamage(self.health + 600, self.origin);
}

