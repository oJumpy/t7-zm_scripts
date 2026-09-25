#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\bgbs\_zm_bgb_extra_credit;

#namespace namespace_7084af67;

/*
	Name: __init__sytem__
	Namespace: namespace_7084af67
	Checksum: 0xDED1DE76
	Offset: 0x1E0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_reign_drops", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_7084af67
	Checksum: 0xEFAB241D
	Offset: 0x220
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_reign_drops", "activated", 2, undefined, undefined, &validation, &activation);
}

/*
	Name: validation
	Namespace: namespace_7084af67
	Checksum: 0x7F3D91FE
	Offset: 0x290
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function validation()
{
	if(isdefined(self.var_b90dda44) && self.var_b90dda44)
	{
		return 0;
	}
	return 1;
}

/*
	Name: activation
	Namespace: namespace_7084af67
	Checksum: 0x1CC28CDD
	Offset: 0x2C0
	Size: 0x1E3
	Parameters: 0
	Flags: None
*/
function activation()
{
	self endon("disconnect");
	self endon("bled_out");
	level thread bgb::function_dea74fb0("minigun", self function_ed573cc2(1));
	self thread namespace_828507ab::function_b18c3b2d(self function_ed573cc2(2));
	level thread bgb::function_dea74fb0("nuke", self function_ed573cc2(3));
	level thread bgb::function_dea74fb0("carpenter", self function_ed573cc2(4));
	level thread bgb::function_dea74fb0("free_perk", self function_ed573cc2(5));
	level thread bgb::function_dea74fb0("fire_sale", self function_ed573cc2(6));
	level thread bgb::function_dea74fb0("insta_kill", self function_ed573cc2(7));
	level thread bgb::function_dea74fb0("full_ammo", self function_ed573cc2(8));
	level thread bgb::function_dea74fb0("double_points", self function_ed573cc2(9));
	self.var_b90dda44 = 1;
	self thread function_7892610e();
}

/*
	Name: function_7892610e
	Namespace: namespace_7084af67
	Checksum: 0x495E79A9
	Offset: 0x4B0
	Size: 0x91
	Parameters: 0
	Flags: None
*/
function function_7892610e()
{
	wait(0.05);
	n_start_time = GetTime();
	n_total_time = 0;
	while(isdefined(level.active_powerups) && level.active_powerups.size)
	{
		wait(0.5);
		n_current_time = GetTime();
		n_total_time = n_current_time - n_start_time / 1000;
		if(n_total_time >= 28)
		{
			break;
		}
	}
	self.var_b90dda44 = undefined;
}

/*
	Name: function_ed573cc2
	Namespace: namespace_7084af67
	Checksum: 0xAB8C78BA
	Offset: 0x550
	Size: 0x281
	Parameters: 1
	Flags: None
*/
function function_ed573cc2(var_d858aeb5)
{
	var_7ec6c170 = self bgb::function_c219b050();
	v_up = VectorScale((0, 0, 1), 5);
	var_8e2dcc47 = var_7ec6c170 + AnglesToForward(self.angles) * 60 + v_up;
	var_682b51de = var_8e2dcc47 + AnglesToForward(self.angles) * 60 + v_up;
	switch(var_d858aeb5)
	{
		case 1:
		{
			v_origin = var_7ec6c170 + AnglesToRight(self.angles) * -60 + v_up;
			break;
		}
		case 2:
		{
			v_origin = var_7ec6c170;
			break;
		}
		case 3:
		{
			v_origin = var_7ec6c170 + AnglesToRight(self.angles) * 60 + v_up;
			break;
		}
		case 4:
		{
			v_origin = var_8e2dcc47 + AnglesToRight(self.angles) * -60 + v_up;
			break;
		}
		case 5:
		{
			v_origin = var_8e2dcc47;
			break;
		}
		case 6:
		{
			v_origin = var_8e2dcc47 + AnglesToRight(self.angles) * 60 + v_up;
			break;
		}
		case 7:
		{
			v_origin = var_682b51de + AnglesToRight(self.angles) * -60 + v_up;
			break;
		}
		case 8:
		{
			v_origin = var_682b51de;
			break;
		}
		case 9:
		{
			v_origin = var_682b51de + AnglesToRight(self.angles) * 60 + v_up;
			break;
		}
		case default:
		{
			v_origin = var_7ec6c170;
			break;
		}
	}
	return v_origin;
}

