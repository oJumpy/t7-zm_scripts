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
	clientfield::register("allplayers", "oneinchpunch_impact", 21000, 1, "int", &oneinchpunch_impact, 0, 0);
	clientfield::register("actor", "oneinchpunch_physics_launchragdoll", 21000, 1, "int", &oneinchpunch_physics_launchragdoll, 0, 0);
}

/*
	Name: oneinchpunch_impact
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0x5BCC485E
	Offset: 0x1C0
	Size: 0x17B
	Parameters: 7
	Flags: None
*/
function oneinchpunch_impact(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self endon("death");
	self endon("disconnect");
	phys_explosion_outer_radius = 75;
	phys_explosion_inner_radius = 60;
	if(newVal == 1)
	{
		if(!isdefined(level.punching_players))
		{
			level.punching_players = [];
		}
		level.punching_players[self GetEntityNumber()] = GetTime();
		self Earthquake(0.5, 0.5, self.origin, 300);
		self PlayRumbleOnEntity(localClientNum, "damage_heavy");
		if(isdefined(self.b_punch_upgraded) && self.b_punch_upgraded && isdefined(self.str_punch_element) && self.str_punch_element == "air")
		{
			phys_explosion_outer_radius = phys_explosion_outer_radius * 2;
		}
		PhysicsExplosionCylinder(localClientNum, self.origin, phys_explosion_outer_radius, phys_explosion_inner_radius, 1);
	}
}

/*
	Name: oneinchpunch_physics_launchragdoll
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0xA4AD2197
	Offset: 0x348
	Size: 0x1D3
	Parameters: 7
	Flags: None
*/
function oneinchpunch_physics_launchragdoll(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self endon("entity_shutdown");
	if(newVal == 1)
	{
		punching_player_index = undefined;
		most_recent_punch_time = 0;
		if(isdefined(level.punching_players))
		{
			for(i = 0; i < level.punching_players.size; i++)
			{
				if(isdefined(level.punching_players[i]) && level.punching_players[i] > most_recent_punch_time)
				{
					punching_player_index = i;
					most_recent_punch_time = level.punching_players[i];
				}
			}
		}
		else if(isdefined(punching_player_index))
		{
			a_players = GetLocalPlayers();
			punching_player = a_players[punching_player_index];
		}
		if(isdefined(punching_player))
		{
			v_launch = VectorNormalize(self.origin - punching_player.origin) * randomIntRange(125, 150) + (0, 0, randomIntRange(75, 150));
		}
		if(isdefined(v_launch))
		{
			self LaunchRagdoll(v_launch);
		}
	}
}

