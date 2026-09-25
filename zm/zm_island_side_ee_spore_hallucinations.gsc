#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_island_util;

#namespace namespace_c63a0940;

/*
	Name: __init__sytem__
	Namespace: namespace_c63a0940
	Checksum: 0x361863EF
	Offset: 0x4A8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_side_ee_spore_hallucinations", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_c63a0940
	Checksum: 0x5B969E32
	Offset: 0x4E8
	Size: 0x115
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "hallucinate_bloody_walls", 9000, 1, "int");
	clientfield::register("toplayer", "hallucinate_spooky_sounds", 9000, 1, "int");
	callback::on_spawned(&on_player_spawned);
	callback::on_connect(&function_8feafce2);
	level.var_40e8eaa5 = [];
	level.var_40e8eaa5["bloody_walls"] = GetEnt("vol_hallucinate_bloody_walls", "targetname");
	level.var_40e8eaa5["corpses"] = GetEnt("vol_hallucinate_corpses", "targetname");
}

/*
	Name: main
	Namespace: namespace_c63a0940
	Checksum: 0x6FB9BFF0
	Offset: 0x608
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function main()
{
	/#
		level thread function_c6d55b0d();
	#/
}

/*
	Name: function_8feafce2
	Namespace: namespace_c63a0940
	Checksum: 0x8E40123B
	Offset: 0x630
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_8feafce2()
{
	self flag::init("hallucination_spookysounds_on");
	self flag::init("hallucination_bloodywalls_on");
}

/*
	Name: on_player_spawned
	Namespace: namespace_c63a0940
	Checksum: 0x73EBBDE2
	Offset: 0x680
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self.var_5f5af9f0 = 0;
	self thread function_e58be395();
}

/*
	Name: function_e58be395
	Namespace: namespace_c63a0940
	Checksum: 0x213284E0
	Offset: 0x6B0
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function function_e58be395()
{
	self endon("death");
	self thread function_b200c473();
	while(1)
	{
		self waittill("hash_ece519d9");
		self.var_5f5af9f0++;
		if(self.var_5f5af9f0 > 5)
		{
			self thread function_51d3efd();
		}
		if(self.var_5f5af9f0 > 15)
		{
			self thread function_5d6bcf98();
		}
	}
}

/*
	Name: function_b200c473
	Namespace: namespace_c63a0940
	Checksum: 0x63D0E2E4
	Offset: 0x748
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function function_b200c473()
{
	self endon("death");
	while(1)
	{
		wait(300);
		if(self.var_5f5af9f0 > 0)
		{
			self.var_5f5af9f0--;
		}
	}
}

/*
	Name: function_51d3efd
	Namespace: namespace_c63a0940
	Checksum: 0x7268493C
	Offset: 0x788
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function function_51d3efd()
{
	self endon("death");
	if(!self flag::get("hallucination_spookysounds_on"))
	{
		self flag::set("hallucination_spookysounds_on");
		while(self.var_5f5af9f0 >= 5)
		{
			var_2499b02a = self namespace_8aed53c9::function_1867f3e8(800);
			if(var_2499b02a <= 3 && !self laststand::player_is_in_laststand())
			{
				self function_5d3a5f36();
				wait(randomIntRange(360, 480));
			}
			wait(5);
		}
		self flag::clear("hallucination_spookysounds_on");
	}
}

/*
	Name: function_5d6bcf98
	Namespace: namespace_c63a0940
	Checksum: 0xD00B27FF
	Offset: 0x890
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function function_5d6bcf98()
{
	self endon("death");
	if(!self flag::get("hallucination_bloodywalls_on"))
	{
		self flag::set("hallucination_bloodywalls_on");
		var_558d1e01 = GetEnt("vol_hallucinate_bloody_walls", "targetname");
		var_58077680 = Array("zone_jungle_lab_upper", "zone_swamp_lab_inside", "zone_operating_rooms");
		while(self.var_5f5af9f0 >= 15)
		{
			if(self namespace_8aed53c9::function_f2a55b5f(var_58077680) && self istouching(var_558d1e01))
			{
				self function_f0e36b57();
				wait(randomIntRange(360, 480));
			}
			wait(5);
		}
		self flag::clear("hallucination_bloodywalls_on");
	}
}

/*
	Name: function_5d3a5f36
	Namespace: namespace_c63a0940
	Checksum: 0xEBCB71DD
	Offset: 0x9E8
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_5d3a5f36()
{
	self function_f0aa6b80(1);
	wait(randomIntRange(10, 20));
	self function_f0aa6b80(0);
}

/*
	Name: function_f0e36b57
	Namespace: namespace_c63a0940
	Checksum: 0x27CCA0D3
	Offset: 0xA40
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function function_f0e36b57()
{
	self function_38943e4d(1);
	exploder::exploder("ex_ee_redtanks");
	wait(randomIntRange(10, 20));
	self function_38943e4d(0);
	exploder::stop_exploder("ex_ee_redtanks");
}

/*
	Name: function_38943e4d
	Namespace: namespace_c63a0940
	Checksum: 0x5A7450C2
	Offset: 0xAC8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_38943e4d(b_on)
{
	if(!isdefined(b_on))
	{
		b_on = 1;
	}
	self clientfield::set_to_player("hallucinate_bloody_walls", b_on);
}

/*
	Name: function_f0aa6b80
	Namespace: namespace_c63a0940
	Checksum: 0xE06F5D35
	Offset: 0xB18
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_f0aa6b80(b_on)
{
	if(!isdefined(b_on))
	{
		b_on = 1;
	}
	self clientfield::set_to_player("hallucinate_spooky_sounds", b_on);
}

/*
	Name: function_c6d55b0d
	Namespace: namespace_c63a0940
	Checksum: 0xCF38628A
	Offset: 0xB68
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function function_c6d55b0d()
{
	/#
		zm_devgui::function_4acecab5(&function_4c6daca1);
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_4c6daca1
	Namespace: namespace_c63a0940
	Checksum: 0xAB39E749
	Offset: 0xC18
	Size: 0xFD
	Parameters: 1
	Flags: None
*/
function function_4c6daca1(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				level.activePlayers[0] thread function_f0e36b57();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level.activePlayers[0] thread function_5d3a5f36();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_ef6cd11(5);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_ef6cd11(10);
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level thread function_ef6cd11(20);
				return 1;
			}
		}
		return 0;
	#/
}

/*
	Name: function_ef6cd11
	Namespace: namespace_c63a0940
	Checksum: 0x96B544D3
	Offset: 0xD20
	Size: 0xE1
	Parameters: 1
	Flags: None
*/
function function_ef6cd11(var_7156fcfa)
{
	/#
		foreach(player in level.activePlayers)
		{
			player.var_5f5af9f0 = var_7156fcfa;
			if(var_7156fcfa > 5)
			{
				player thread function_51d3efd();
			}
			if(var_7156fcfa > 15)
			{
				player thread function_5d6bcf98();
			}
		}
	#/
}

