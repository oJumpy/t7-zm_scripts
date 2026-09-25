#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_stalingrad_vo;

#namespace namespace_6d9dd78a;

/*
	Name: __init__sytem__
	Namespace: namespace_6d9dd78a
	Checksum: 0xA0554EAF
	Offset: 0x2F0
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_mounted_mg", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_6d9dd78a
	Checksum: 0xB57013CD
	Offset: 0x338
	Size: 0xE7
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("vehicle", "overheat_fx", 12000, 1, "int");
	var_a7761466 = struct::get("pavlov_mg", "targetname");
	s_unitrigger = var_a7761466 zm_unitrigger::create_unitrigger("", 64, &function_f734357f, &function_be759ad7);
	s_unitrigger.hint_parm1 = 1000;
	s_unitrigger.b_enabled = 1;
	s_unitrigger.var_1dcdd471 = 0;
}

/*
	Name: __main__
	Namespace: namespace_6d9dd78a
	Checksum: 0x1D39DDFE
	Offset: 0x428
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level.var_ffcc580a = GetEnt("pavlov_turret", "targetname");
	level.var_ffcc580a.turret_index = 0;
	level.var_ffcc580a turret::set_burst_parameters(0.75, 1.5, 0.25, 0.75, level.var_ffcc580a.turret_index);
}

/*
	Name: function_f734357f
	Namespace: namespace_6d9dd78a
	Checksum: 0x8AD0C9CA
	Offset: 0x4E0
	Size: 0x1BF
	Parameters: 1
	Flags: None
*/
function function_f734357f(e_player)
{
	if(e_player zm_hero_weapon::is_hero_weapon_in_use())
	{
		self setHintString("");
		return 0;
	}
	if(e_player.IS_DRINKING > 0)
	{
		self setHintString("");
		return 0;
	}
	else if(level flag::get("lockdown_active") && level.var_1dfcc9b2.var_22bf30b7 !== 1)
	{
		self setHintString("");
		return 0;
	}
	else if(self.stub.b_enabled == 1 && self.stub.var_1dcdd471 == 0)
	{
		self setHintString(&"ZM_STALINGRAD_MOUNTED_MG_ACTIVATE", self.stub.hint_parm1);
		return 1;
	}
	else if(self.stub.b_enabled == 0 && self.stub.var_1dcdd471 == 0)
	{
		self setHintString(&"ZM_STALINGRAD_MOUNTED_MG_COOLDOWN");
		return 0;
	}
	else
	{
		self setHintString("");
		return 0;
	}
}

/*
	Name: function_be759ad7
	Namespace: namespace_6d9dd78a
	Checksum: 0x6E04EC2D
	Offset: 0x6A8
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function function_be759ad7()
{
	self waittill("trigger", e_who);
	if(!e_who zm_score::can_player_purchase(1000) && self.stub.b_enabled)
	{
		e_who zm_audio::create_and_play_dialog("general", "transport_deny");
	}
	else if(self.stub.b_enabled && !self.stub.var_1dcdd471)
	{
		e_who clientfield::increment_to_player("interact_rumble");
		e_who zm_score::minus_to_player_score(1000);
		self thread function_f8b87a4e(e_who);
	}
}

/*
	Name: function_f8b87a4e
	Namespace: namespace_6d9dd78a
	Checksum: 0xFA21B177
	Offset: 0x798
	Size: 0x191
	Parameters: 1
	Flags: None
*/
function function_f8b87a4e(e_player)
{
	var_8de107a = self.stub;
	var_8de107a.var_1dcdd471 = 1;
	e_player thread namespace_dcf9c464::function_32f35525();
	self.stub thread function_8e896de5(e_player);
	level.var_ffcc580a turret::enable(0, 1);
	level.var_ffcc580a MakeVehicleUsable();
	level.var_ffcc580a usevehicle(e_player, 0);
	level.var_ffcc580a.var_3a61625b = e_player;
	level.var_ffcc580a MakeVehicleUnusable();
	wait(0.5);
	level.var_ffcc580a MakeVehicleUsable();
	e_player waittill("exit_vehicle");
	level.var_ffcc580a MakeVehicleUnusable();
	level.var_ffcc580a ClearTurretTarget();
	var_8de107a thread function_711e7f22();
	wait(1);
	var_8de107a.var_1dcdd471 = 0;
	level.var_ffcc580a.var_3a61625b = undefined;
}

/*
	Name: function_8e896de5
	Namespace: namespace_6d9dd78a
	Checksum: 0xCE9DC375
	Offset: 0x938
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function function_8e896de5(e_player)
{
	e_player endon("exit_vehicle");
	e_player endon("death");
	level.var_ffcc580a.n_start_time = GetTime();
	wait(30);
	level.var_ffcc580a usevehicle(e_player, 0);
}

/*
	Name: function_711e7f22
	Namespace: namespace_6d9dd78a
	Checksum: 0x83E1D0BA
	Offset: 0x9A0
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function function_711e7f22()
{
	self.b_enabled = 0;
	level.var_ffcc580a clientfield::set("overheat_fx", 1);
	var_55acad81 = GetTime() - level.var_ffcc580a.n_start_time / 30000;
	if(var_55acad81 > 1)
	{
		var_55acad81 = 1;
	}
	var_b6c00097 = var_55acad81 * 15;
	wait(var_b6c00097);
	self.b_enabled = 1;
	level.var_ffcc580a clientfield::set("overheat_fx", 0);
}

