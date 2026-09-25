#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\_zm_utility;

#namespace namespace_6c01a8f1;

/*
	Name: init
	Namespace: namespace_6c01a8f1
	Checksum: 0x4D18A7BE
	Offset: 0x140
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function init()
{
	level thread function_248ca286();
	level thread function_7c864458();
	level thread callback::on_connect(&onPlayerConnect);
}

/*
	Name: onPlayerConnect
	Namespace: namespace_6c01a8f1
	Checksum: 0x5747E637
	Offset: 0x1A0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function onPlayerConnect()
{
	self thread function_f5674b33();
	self thread function_44c51c07();
	self thread function_c333cafb();
}

/*
	Name: function_248ca286
	Namespace: namespace_6c01a8f1
	Checksum: 0xC3CE49BA
	Offset: 0x1F8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_248ca286()
{
	level flag::wait_till_all(Array("lander_a_used", "lander_b_used", "lander_c_used"));
	level zm_utility::giveachievement_wrapper("DLC2_ZOM_LUNARLANDERS", 1);
}

/*
	Name: function_7c864458
	Namespace: namespace_6c01a8f1
	Checksum: 0x375410A
	Offset: 0x260
	Size: 0xA1
	Parameters: 0
	Flags: None
*/
function function_7c864458()
{
	level endon("end_game");
	for(;;)
	{
		level waittill("trap_kill", zombie, trap);
		if(!isPlayer(zombie) && "monkey_zombie" == zombie.animName && "fire" == trap._trap_type)
		{
			zm_utility::giveachievement_wrapper("DLC2_ZOM_FIREMONKEY", 1);
			return;
		}
	}
}

/*
	Name: function_f5674b33
	Namespace: namespace_6c01a8f1
	Checksum: 0xA715D891
	Offset: 0x310
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function function_f5674b33()
{
	level endon("end_game");
	self endon("disconnect");
	self waittill("hash_24f3af69");
}

/*
	Name: function_44c51c07
	Namespace: namespace_6c01a8f1
	Checksum: 0x83A49E50
	Offset: 0x340
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function function_44c51c07()
{
	level endon("end_game");
	self endon("disconnect");
	self waittill("black_hole_kills_achievement");
}

/*
	Name: function_c333cafb
	Namespace: namespace_6c01a8f1
	Checksum: 0x47F312E7
	Offset: 0x370
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function function_c333cafb()
{
	level endon("end_game");
	self endon("disconnect");
	self waittill("pap_taken");
}

