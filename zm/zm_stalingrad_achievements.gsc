#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_734d511;

/*
	Name: __init__sytem__
	Namespace: namespace_734d511
	Checksum: 0x585FCE64
	Offset: 0x238
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_achievements", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_734d511
	Checksum: 0xEA67B9D9
	Offset: 0x278
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level thread function_73d8758f();
	level thread function_42b2ae41();
	callback::on_connect(&on_player_connect);
}

/*
	Name: on_player_connect
	Namespace: namespace_734d511
	Checksum: 0xA6044A79
	Offset: 0x2D8
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self thread function_69021ea7();
	self thread function_35e5c39b();
	self thread function_68cad44c();
	self thread function_77f84ddb();
	self thread function_3a3c9cc6();
	self thread function_b6e817dd();
	self thread function_bdcf8e90();
	self thread function_54dbe534();
}

/*
	Name: function_73d8758f
	Namespace: namespace_734d511
	Checksum: 0xA321952E
	Offset: 0x3A8
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_73d8758f()
{
	level waittill("hash_c1471acf");
	Array::run_all(level.players, &GiveAchievement, "ZM_STALINGRAD_NIKOLAI");
}

/*
	Name: function_69021ea7
	Namespace: namespace_734d511
	Checksum: 0xBEB66235
	Offset: 0x3F8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_69021ea7()
{
	self endon("death");
	self waittill("hash_4e21f047");
	self GiveAchievement("ZM_STALINGRAD_WIELD_DRAGON");
}

/*
	Name: function_42b2ae41
	Namespace: namespace_734d511
	Checksum: 0x367D7C03
	Offset: 0x440
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_42b2ae41()
{
	level waittill("hash_399599c1");
	Array::run_all(level.players, &GiveAchievement, "ZM_STALINGRAD_TWENTY_ROUNDS");
}

/*
	Name: function_35e5c39b
	Namespace: namespace_734d511
	Checksum: 0x3C8FA777
	Offset: 0x490
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_35e5c39b()
{
	self endon("death");
	self waittill("hash_2e47bc4a");
	self GiveAchievement("ZM_STALINGRAD_RIDE_DRAGON");
}

/*
	Name: function_68cad44c
	Namespace: namespace_734d511
	Checksum: 0xDC7C9333
	Offset: 0x4D8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_68cad44c()
{
	self endon("death");
	self waittill("hash_1d89afbc");
	self GiveAchievement("ZM_STALINGRAD_LOCKDOWN");
}

/*
	Name: function_77f84ddb
	Namespace: namespace_734d511
	Checksum: 0xBC007367
	Offset: 0x520
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_77f84ddb()
{
	self endon("death");
	self waittill("hash_41370469");
	self GiveAchievement("ZM_STALINGRAD_SOLO_TRIALS");
}

/*
	Name: function_3a3c9cc6
	Namespace: namespace_734d511
	Checksum: 0xBC451B59
	Offset: 0x568
	Size: 0x69
	Parameters: 0
	Flags: None
*/
function function_3a3c9cc6()
{
	self endon("death");
	while(1)
	{
		self waittill("hash_c925c266", n_kill_count);
		if(n_kill_count >= 20)
		{
			self GiveAchievement("ZM_STALINGRAD_BEAM_KILL");
			return;
		}
	}
}

/*
	Name: function_b6e817dd
	Namespace: namespace_734d511
	Checksum: 0x45CCA3B4
	Offset: 0x5E0
	Size: 0x69
	Parameters: 0
	Flags: None
*/
function function_b6e817dd()
{
	self endon("death");
	while(1)
	{
		self waittill("hash_ddb84fad", n_kill_count);
		if(n_kill_count >= 8)
		{
			self GiveAchievement("ZM_STALINGRAD_STRIKE_DRAGON");
			return;
		}
	}
}

/*
	Name: function_bdcf8e90
	Namespace: namespace_734d511
	Checksum: 0x8B84FE90
	Offset: 0x658
	Size: 0x69
	Parameters: 0
	Flags: None
*/
function function_bdcf8e90()
{
	self endon("death");
	while(1)
	{
		self waittill("hash_8c80a390", n_kill_count);
		if(n_kill_count >= 10)
		{
			self GiveAchievement("ZM_STALINGRAD_FAFNIR_KILL");
			return;
		}
	}
}

/*
	Name: function_54dbe534
	Namespace: namespace_734d511
	Checksum: 0xB2E9EACD
	Offset: 0x6D0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_54dbe534()
{
	self thread function_99a5ed1a(10);
	self thread function_60593db9(10);
}

/*
	Name: function_99a5ed1a
	Namespace: namespace_734d511
	Checksum: 0xB42D02C0
	Offset: 0x718
	Size: 0x7D
	Parameters: 1
	Flags: None
*/
function function_99a5ed1a(n_target_kills)
{
	self endon("death");
	self endon("hash_c43b59a6");
	while(1)
	{
		self waittill("hash_e442448", n_kill_count);
		if(n_kill_count >= n_target_kills)
		{
			self GiveAchievement("ZM_STALINGRAD_AIR_ZOMBIES");
			self notify("hash_c43b59a6");
		}
	}
}

/*
	Name: function_60593db9
	Namespace: namespace_734d511
	Checksum: 0xF2CC378B
	Offset: 0x7A0
	Size: 0x7D
	Parameters: 1
	Flags: None
*/
function function_60593db9(n_target_kills)
{
	self endon("death");
	self endon("hash_c43b59a6");
	while(1)
	{
		self waittill("hash_f7608efe", n_kill_count);
		if(n_kill_count >= n_target_kills)
		{
			self GiveAchievement("ZM_STALINGRAD_AIR_ZOMBIES");
			self notify("hash_c43b59a6");
		}
	}
}

