#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_utility;

#namespace zm_grappler;

/*
	Name: __init__sytem__
	Namespace: zm_grappler
	Checksum: 0xC67EF4F
	Offset: 0x220
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_grappler", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_grappler
	Checksum: 0x3225733
	Offset: 0x268
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "grappler_beam_source", 15000, 1, "int");
	clientfield::register("scriptmover", "grappler_beam_target", 15000, 1, "int");
}

/*
	Name: __main__
	Namespace: zm_grappler
	Checksum: 0x99EC1590
	Offset: 0x2D8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __main__()
{
}

/*
	Name: start_grapple
	Namespace: zm_grappler
	Checksum: 0xE69FE55D
	Offset: 0x2E8
	Size: 0x3BB
	Parameters: 4
	Flags: None
*/
function start_grapple(e_grappler, e_grapplee, n_type, n_speed)
{
	if(!isdefined(n_speed))
	{
		n_speed = 1800;
	}
	/#
		Assert(n_type == 2);
	#/
	e_source = create_mover(e_grappler grapple_point(), e_grappler.angles);
	e_beamend = create_mover(e_grappler grapple_point(), e_grappler.angles * -1);
	thread function_28ac2916(e_source, e_beamend);
	if(isdefined(e_beamend))
	{
		e_grapplee function_63b4b8a5(1);
		util::wait_network_frame();
		n_time = grapple_time(e_grappler, e_grapplee, n_speed);
		e_beamend.origin = e_grappler grapple_point();
		var_c35f0f99 = e_grapplee grapple_point();
		e_beamend playsound("zmb_grapple_start");
		e_beamend moveto(var_c35f0f99, n_time);
		e_beamend waittill("movedone");
		var_8986f6e8 = var_c35f0f99 - e_grapplee.origin;
		e_beamend.origin = e_grapplee.origin;
		if(isPlayer(e_grapplee))
		{
			e_grapplee playerLinkTo(e_beamend, "tag_origin");
		}
		else
		{
			e_grapplee LinkTo(e_beamend);
		}
		e_grapplee playsound("zmb_grapple_grab");
		var_de84fe14 = e_grappler grapple_point() - var_8986f6e8;
		e_beamend moveto(var_de84fe14, n_time);
		e_beamend playsound("zmb_grapple_pull");
		e_beamend waittill("movedone");
		function_b7c692b0();
		e_beamend clientfield::set("grappler_beam_target", 0);
		e_grapplee Unlink();
		e_grapplee function_63b4b8a5(0);
		util::wait_network_frame();
		destroy_mover(e_beamend);
		destroy_mover(e_source);
	}
}

/*
	Name: function_b7c692b0
	Namespace: zm_grappler
	Checksum: 0x140F8570
	Offset: 0x6B0
	Size: 0x27
	Parameters: 0
	Flags: Private
*/
function private function_b7c692b0()
{
	while(isdefined(level.var_5b94112c) && level.var_5b94112c)
	{
		wait(0.05);
	}
}

/*
	Name: function_28ac2916
	Namespace: zm_grappler
	Checksum: 0xD04D742B
	Offset: 0x6E0
	Size: 0xAF
	Parameters: 2
	Flags: Private
*/
function private function_28ac2916(e_source, e_target)
{
	function_b7c692b0();
	level.var_5b94112c = 1;
	if(isdefined(e_source))
	{
		e_source clientfield::set("grappler_beam_source", 1);
	}
	util::wait_network_frame();
	if(isdefined(e_target))
	{
		e_target clientfield::set("grappler_beam_target", 1);
	}
	util::wait_network_frame();
	level.var_5b94112c = 0;
}

/*
	Name: grapple_time
	Namespace: zm_grappler
	Checksum: 0x6D5DC9A2
	Offset: 0x798
	Size: 0x71
	Parameters: 3
	Flags: Private
*/
function private grapple_time(e_from, e_to, n_speed)
{
	n_distance = Distance(e_from grapple_point(), e_to grapple_point());
	return n_distance / n_speed;
}

/*
	Name: function_63b4b8a5
	Namespace: zm_grappler
	Checksum: 0xE8143A3E
	Offset: 0x818
	Size: 0x103
	Parameters: 1
	Flags: Private
*/
function private function_63b4b8a5(var_365c612)
{
	if(!isdefined(self))
	{
		return;
	}
	if(var_365c612 != isdefined(self.var_14f171d3) && self.var_14f171d3)
	{
		self.var_14f171d3 = var_365c612;
		if(isPlayer(self))
		{
			self util::freeze_player_controls(var_365c612);
			self SetPlayerCollision(!var_365c612);
			if(var_365c612)
			{
				self zm_utility::increment_ignoreme();
				self.var_61f01d73 = self EnableInvulnerability();
			}
			else
			{
				self zm_utility::decrement_ignoreme();
				if(!(isdefined(self.var_61f01d73) && self.var_61f01d73))
				{
					self DisableInvulnerability();
				}
			}
		}
	}
}

/*
	Name: grapple_point
	Namespace: zm_grappler
	Checksum: 0x48E5527D
	Offset: 0x928
	Size: 0x45
	Parameters: 0
	Flags: Private
*/
function private grapple_point()
{
	if(isdefined(self.grapple_tag))
	{
		v_origin = self GetTagOrigin(self.grapple_tag);
		return v_origin;
	}
	return self.origin;
}

/*
	Name: create_mover
	Namespace: zm_grappler
	Checksum: 0x805558DF
	Offset: 0x978
	Size: 0x53
	Parameters: 2
	Flags: Private
*/
function private create_mover(v_origin, v_angles)
{
	model = "tag_origin";
	e_ent = util::spawn_model(model, v_origin, v_angles);
	return e_ent;
}

/*
	Name: destroy_mover
	Namespace: zm_grappler
	Checksum: 0x41501F2B
	Offset: 0x9D8
	Size: 0x2B
	Parameters: 1
	Flags: Private
*/
function private destroy_mover(e_beamend)
{
	if(isdefined(e_beamend))
	{
		e_beamend delete();
	}
}

