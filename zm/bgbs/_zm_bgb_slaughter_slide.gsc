#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_2f637cea;

/*
	Name: __init__sytem__
	Namespace: namespace_2f637cea
	Checksum: 0x7A3A96B
	Offset: 0x170
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_slaughter_slide", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_2f637cea
	Checksum: 0xD3822A92
	Offset: 0x1B0
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_slaughter_slide", "event", &event, undefined, undefined, undefined);
	bgb::function_3422638b("zm_bgb_slaughter_slide", &actor_damage_override);
	bgb::function_e22c6124("zm_bgb_slaughter_slide", &vehicle_damage_override);
	level.var_77eb3698 = GetWeapon("frag_grenade_slaughter_slide");
}

/*
	Name: event
	Namespace: namespace_2f637cea
	Checksum: 0xECF54B59
	Offset: 0x280
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function event()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("hash_994d5e9e");
	self.var_abd23dd0 = 6;
	while(self.var_abd23dd0 > 0)
	{
		var_2a23ce90 = self is_sliding(2);
		if(var_2a23ce90)
		{
			self thread function_42722ac4();
			while(self IsSliding())
			{
				wait(0.2);
			}
		}
		wait(0.05);
	}
}

/*
	Name: is_sliding
	Namespace: namespace_2f637cea
	Checksum: 0xBC1FB679
	Offset: 0x340
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function is_sliding(n_count)
{
	var_2a23ce90 = 0;
	for(x = 0; x < n_count; x++)
	{
		var_2a23ce90 = self IsSliding();
		wait(0.05);
	}
	return var_2a23ce90;
}

/*
	Name: function_42722ac4
	Namespace: namespace_2f637cea
	Checksum: 0x85313658
	Offset: 0x3B0
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function function_42722ac4()
{
	v_launch_offset = VectorScale((0, 0, 1), 48);
	v_facing = AnglesToForward(self.angles);
	v_right = AnglesToRight(self.angles);
	self MagicGrenadeType(level.var_77eb3698, self.origin + v_launch_offset, v_facing * 1000, 0.5);
	util::wait_network_frame();
	self MagicGrenadeType(level.var_77eb3698, self.origin + v_launch_offset, v_facing * -1 * 100, 0.05);
	self bgb::do_one_shot_use();
	self.var_abd23dd0--;
	self bgb::set_timer(self.var_abd23dd0, 6);
}

/*
	Name: actor_damage_override
	Namespace: namespace_2f637cea
	Checksum: 0x4BE7629A
	Offset: 0x520
	Size: 0xCD
	Parameters: 12
	Flags: None
*/
function actor_damage_override(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if(weapon === level.var_77eb3698)
	{
		if(isdefined(self.ignore_nuke) && self.ignore_nuke || (isdefined(self.marked_for_death) && self.marked_for_death) || zm_utility::is_magic_bullet_shield_enabled(self))
		{
			return damage;
		}
		return self.health + 666;
	}
	return damage;
}

/*
	Name: vehicle_damage_override
	Namespace: namespace_2f637cea
	Checksum: 0x5428EC4D
	Offset: 0x5F8
	Size: 0xE5
	Parameters: 15
	Flags: None
*/
function vehicle_damage_override(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	if(weapon === level.var_77eb3698)
	{
		if(isdefined(self.ignore_nuke) && self.ignore_nuke || (isdefined(self.marked_for_death) && self.marked_for_death) || zm_utility::is_magic_bullet_shield_enabled(self))
		{
			return iDamage;
		}
		return self.health + 666;
	}
	return iDamage;
}

