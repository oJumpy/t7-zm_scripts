#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;

#namespace namespace_1ed7595f;

/*
	Name: __init__sytem__
	Namespace: namespace_1ed7595f
	Checksum: 0xF15F8AC7
	Offset: 0x308
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_prototype_barrels", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_1ed7595f
	Checksum: 0x142F833E
	Offset: 0x348
	Size: 0x1E3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	var_37ec7c95 = 0;
	a_barrels = GetEntArray("explodable_barrel", "targetname");
	if(isdefined(a_barrels) && a_barrels.size > 0)
	{
		var_37ec7c95 = 1;
	}
	a_barrels = GetEntArray("explodable_barrel", "script_noteworthy");
	if(isdefined(a_barrels) && a_barrels.size > 0)
	{
		var_37ec7c95 = 1;
	}
	if(!var_37ec7c95)
	{
		return;
	}
	clientfield::register("scriptmover", "exploding_barrel_burn_fx", 21000, 1, "int");
	clientfield::register("scriptmover", "exploding_barrel_explode_fx", 21000, 1, "int");
	level.barrelExpSound = "exp_redbarrel";
	level.barrelIngSound = "exp_redbarrel_ignition";
	level.barrelHealth = 350;
	level.barrelExplodingThisFrame = 0;
	Array::thread_all(GetEntArray("explodable_barrel", "targetname"), &explodable_barrel_think);
	Array::thread_all(GetEntArray("explodable_barrel", "script_noteworthy"), &explodable_barrel_think);
	level thread function_28ed3370();
}

/*
	Name: function_66d46c7d
	Namespace: namespace_1ed7595f
	Checksum: 0x33453107
	Offset: 0x538
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_66d46c7d()
{
	self clientfield::set("exploding_barrel_burn_fx", 1);
}

/*
	Name: function_b6fe19c5
	Namespace: namespace_1ed7595f
	Checksum: 0x1B19FE27
	Offset: 0x568
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_b6fe19c5()
{
	self clientfield::set("exploding_barrel_explode_fx", 1);
}

/*
	Name: explodable_barrel_think
	Namespace: namespace_1ed7595f
	Checksum: 0x9B41691
	Offset: 0x598
	Size: 0x1CF
	Parameters: 0
	Flags: None
*/
function explodable_barrel_think()
{
	if(self.classname != "script_model")
	{
		return;
	}
	self endon("exploding");
	self.damageTaken = 0;
	self SetCanDamage(1);
	for(;;)
	{
		self waittill("damage", amount, attacker, direction_vec, p, type);
		/#
			println("Dev Block strings are not supported" + type);
		#/
		if(type == "MOD_MELEE" || type == "MOD_IMPACT")
		{
			continue;
		}
		if(isdefined(self.script_requires_player) && self.script_requires_player && (!isPlayer(attacker) && (isdefined(attacker.classname) && attacker.classname != "worldspawn")))
		{
			continue;
		}
		if(isdefined(self.script_selfisattacker) && self.script_selfisattacker)
		{
			self.damageOwner = self;
		}
		else
		{
			self.damageOwner = attacker;
		}
		if(level.barrelExplodingThisFrame)
		{
			wait(RandomFloat(1));
		}
		self.damageTaken = self.damageTaken + amount;
		if(self.damageTaken == amount)
		{
			self thread explodable_barrel_burn();
		}
	}
}

/*
	Name: explodable_barrel_burn
	Namespace: namespace_1ed7595f
	Checksum: 0xA49A7A4B
	Offset: 0x770
	Size: 0x153
	Parameters: 0
	Flags: None
*/
function explodable_barrel_burn()
{
	count = 0;
	startedfx = 0;
	while(self.damageTaken < level.barrelHealth)
	{
		if(!startedfx)
		{
			function_66d46c7d();
			level thread sound::play_in_space(level.barrelIngSound, self.origin);
			startedfx = 1;
		}
		if(count > 20)
		{
			count = 0;
		}
		if(count == 0)
		{
			self.damageTaken = self.damageTaken + 10 + RandomFloat(10);
			badplace_cylinder("", 1, self.origin, 128, 250, "axis");
			self playsound("exp_barrel_fuse");
		}
		count++;
		wait(0.05);
	}
	self thread explodable_barrel_explode();
}

/*
	Name: explodable_barrel_explode
	Namespace: namespace_1ed7595f
	Checksum: 0x2B6E1189
	Offset: 0x8D0
	Size: 0x41F
	Parameters: 0
	Flags: None
*/
function explodable_barrel_explode()
{
	self notify("exploding");
	self notify("death");
	up = anglesToUp(self.angles);
	worldup = anglesToUp(VectorScale((0, 1, 0), 90));
	dot = VectorDot(up, worldup);
	offset = (0, 0, 0);
	if(dot < 0.5)
	{
		start = self.origin + VectorScale(up, 22);
		end = PhysicsTrace(start, start + VectorScale((0, 0, -1), 64));
		offset = end - self.origin;
	}
	offset = offset + VectorScale((0, 0, 1), 4);
	function_b6fe19c5();
	level thread sound::play_in_space(level.barrelExpSound, self.origin);
	PhysicsExplosionSphere(self.origin + offset, 100, 80, 1);
	PlayRumbleOnPosition("barrel_explosion", self.origin + VectorScale((0, 0, 1), 32));
	level notify("hash_83cc4809");
	level.barrelExplodingThisFrame = 1;
	if(isdefined(self.remove))
	{
		self.remove connectpaths();
		self.remove delete();
	}
	maxDamage = 250;
	if(isdefined(self.script_damage))
	{
		maxDamage = self.script_damage;
	}
	blastRadius = 250;
	if(isdefined(self.radius))
	{
		blastRadius = self.radius;
	}
	attacker = undefined;
	if(isdefined(self.damageOwner))
	{
		attacker = self.damageOwner;
	}
	level.lastExplodingBarrel["time"] = GetTime();
	level.lastExplodingBarrel["origin"] = self.origin + VectorScale((0, 0, 1), 30);
	self RadiusDamage(self.origin + VectorScale((0, 0, 1), 30), blastRadius, maxDamage, 1, attacker);
	if(RandomInt(2) == 0)
	{
		self SetModel("p7_zm_nac_barrel_explosive_red_dmg_01");
	}
	else
	{
		self SetModel("p7_zm_nac_barrel_explosive_red_dmg_02");
	}
	if(dot < 0.5)
	{
		start = self.origin + VectorScale(up, 22);
		pos = PhysicsTrace(start, start + VectorScale((0, 0, -1), 64));
		self.origin = pos;
		self.angles = self.angles + VectorScale((0, 0, 1), 90);
	}
	waittillframeend;
	level.barrelExplodingThisFrame = 0;
}

/*
	Name: breakable_clip
	Namespace: namespace_1ed7595f
	Checksum: 0xDB63DD25
	Offset: 0xCF8
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function breakable_clip()
{
	if(isdefined(self.target))
	{
		targ = GetEnt(self.target, "targetname");
		if(targ.classname == "script_brushmodel")
		{
			self.remove = targ;
			return;
		}
	}
	if(isdefined(self.remove))
	{
		ArrayRemoveValue(level.breakables_clip, self.remove);
	}
}

/*
	Name: function_28ed3370
	Namespace: namespace_1ed7595f
	Checksum: 0xFF61EC09
	Offset: 0xDA0
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function function_28ed3370()
{
	var_e1c041e0 = GetEntArray("explodable_barrel", "targetname");
	var_53c7b11b = GetEntArray("explodable_barrel", "script_noteworthy");
	if(isdefined(var_e1c041e0))
	{
		var_69238c0b = var_e1c041e0.size;
	}
	if(isdefined(var_53c7b11b))
	{
		var_69238c0b = var_69238c0b + var_53c7b11b.size;
	}
	for(var_1d2242bc = 0; var_1d2242bc < var_69238c0b; var_1d2242bc++)
	{
		level waittill("hash_83cc4809");
	}
	level thread zm_audio::sndMusicSystem_PlayState("undone");
}

