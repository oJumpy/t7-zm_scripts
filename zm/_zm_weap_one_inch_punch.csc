#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;

#namespace _zm_weap_one_inch_punch;

/*
	Name: init
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0x34B56D3E
	Offset: 0x120
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("allplayers", "oneinchpunch_impact", 21000, 1, "int", &function_c9202f92, 0, 0);
	clientfield::register("actor", "oneinchpunch_physics_launchragdoll", 21000, 1, "int", &function_7c6b248c, 0, 0);
}

/*
	Name: function_c9202f92
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0x5BCC485E
	Offset: 0x1C0
	Size: 0x17B
	Parameters: 7
	Flags: None
*/
function function_c9202f92(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self endon("death");
	self endon("disconnect");
	var_4383636a = 75;
	var_bf0c8e05 = 60;
	if(newVal == 1)
	{
		if(!isdefined(level.var_57220446))
		{
			level.var_57220446 = [];
		}
		level.var_57220446[self GetEntityNumber()] = GetTime();
		self Earthquake(0.5, 0.5, self.origin, 300);
		self PlayRumbleOnEntity(localClientNum, "damage_heavy");
		if(isdefined(self.b_punch_upgraded) && self.b_punch_upgraded && isdefined(self.str_punch_element) && self.str_punch_element == "air")
		{
			var_4383636a = var_4383636a * 2;
		}
		PhysicsExplosionCylinder(localClientNum, self.origin, var_4383636a, var_bf0c8e05, 1);
	}
}

/*
	Name: function_7c6b248c
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0xA4AD2197
	Offset: 0x348
	Size: 0x1D3
	Parameters: 7
	Flags: None
*/
function function_7c6b248c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self endon("entity_shutdown");
	if(newVal == 1)
	{
		var_70efc576 = undefined;
		var_17013cd1 = 0;
		if(isdefined(level.var_57220446))
		{
			for(i = 0; i < level.var_57220446.size; i++)
			{
				if(isdefined(level.var_57220446[i]) && level.var_57220446[i] > var_17013cd1)
				{
					var_70efc576 = i;
					var_17013cd1 = level.var_57220446[i];
				}
			}
		}
		else if(isdefined(var_70efc576))
		{
			a_players = GetLocalPlayers();
			var_b262e13f = a_players[var_70efc576];
		}
		if(isdefined(var_b262e13f))
		{
			v_launch = VectorNormalize(self.origin - var_b262e13f.origin) * randomIntRange(125, 150) + (0, 0, randomIntRange(75, 150));
		}
		if(isdefined(v_launch))
		{
			self LaunchRagdoll(v_launch);
		}
	}
}

