#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\util_shared;

#namespace zombie_death;

/*
	Name: on_fire_timeout
	Namespace: zombie_death
	Checksum: 0xEEE21498
	Offset: 0x2C8
	Size: 0x65
	Parameters: 0
	Flags: None
*/
function on_fire_timeout()
{
	self endon("death");
	if(isdefined(self.flame_fx_timeout))
	{
		wait(self.flame_fx_timeout);
	}
	else
	{
		wait(12);
	}
	if(isdefined(self) && isalive(self))
	{
		self.is_on_fire = 0;
		self notify("stop_flame_damage");
	}
}

/*
	Name: flame_death_fx
	Namespace: zombie_death
	Checksum: 0xD59F9598
	Offset: 0x338
	Size: 0x3BB
	Parameters: 0
	Flags: None
*/
function flame_death_fx()
{
	self endon("death");
	if(isdefined(self.is_on_fire) && self.is_on_fire)
	{
		return;
	}
	if(isdefined(self.disable_flame_fx) && self.disable_flame_fx)
	{
		return;
	}
	self.is_on_fire = 1;
	self thread on_fire_timeout();
	if(isdefined(level._effect) && isdefined(level._effect["character_fire_death_torso"]))
	{
		fire_tag = "j_spinelower";
		fire_death_torso_fx = level._effect["character_fire_death_torso"];
		if(isdefined(self.weapon_specific_fire_death_torso_fx))
		{
			fire_death_torso_fx = self.weapon_specific_fire_death_torso_fx;
		}
		if(!isdefined(self GetTagOrigin(fire_tag)))
		{
			fire_tag = "tag_origin";
		}
		if(!isdefined(self.isdog) || !self.isdog)
		{
			PlayFXOnTag(fire_death_torso_fx, self, fire_tag);
		}
		self.weapon_specific_fire_death_torso_fx = undefined;
	}
	else
	{
		println("Dev Block strings are not supported");
	}
	/#
	#/
	if(isdefined(level._effect) && isdefined(level._effect["character_fire_death_sm"]))
	{
		if(self.archetype !== "parasite" && self.archetype !== "raps" && self.archetype !== "spider")
		{
			fire_death_sm_fx = level._effect["character_fire_death_sm"];
			if(isdefined(self.weapon_specific_fire_death_sm_fx))
			{
				fire_death_sm_fx = self.weapon_specific_fire_death_sm_fx;
			}
			if(isdefined(self.weapon_specific_fire_death_torso_fx))
			{
				fire_death_torso_fx = self.weapon_specific_fire_death_torso_fx;
			}
			wait(1);
			tagArray = [];
			tagArray[0] = "J_Elbow_LE";
			tagArray[1] = "J_Elbow_RI";
			tagArray[2] = "J_Knee_RI";
			tagArray[3] = "J_Knee_LE";
			tagArray = randomize_array(tagArray);
			PlayFXOnTag(fire_death_sm_fx, self, tagArray[0]);
			wait(1);
			tagArray[0] = "J_Wrist_RI";
			tagArray[1] = "J_Wrist_LE";
			if(!isdefined(self.a.gib_ref) || self.a.gib_ref != "no_legs")
			{
				tagArray[2] = "J_Ankle_RI";
				tagArray[3] = "J_Ankle_LE";
			}
			tagArray = randomize_array(tagArray);
			PlayFXOnTag(fire_death_sm_fx, self, tagArray[0]);
			PlayFXOnTag(fire_death_sm_fx, self, tagArray[1]);
			self.weapon_specific_fire_death_sm_fx = undefined;
		}
	}
	else
	{
		println("Dev Block strings are not supported");
	}
	/#
	#/
}

/*
	Name: randomize_array
	Namespace: zombie_death
	Checksum: 0xCDED09F5
	Offset: 0x700
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function randomize_array(Array)
{
	for(i = 0; i < Array.size; i++)
	{
		j = RandomInt(Array.size);
		temp = Array[i];
		Array[i] = Array[j];
		Array[j] = temp;
	}
	return Array;
}

/*
	Name: set_last_gib_time
	Namespace: zombie_death
	Checksum: 0xC9BFCCF2
	Offset: 0x7A8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function set_last_gib_time()
{
	anim notify("stop_last_gib_time");
	anim endon("stop_last_gib_time");
	wait(0.05);
	anim.lastGibTime = GetTime();
	anim.totalGibs = randomIntRange(anim.minGibs, anim.maxGibs);
}

/*
	Name: get_gib_ref
	Namespace: zombie_death
	Checksum: 0xB5E34966
	Offset: 0x810
	Size: 0x339
	Parameters: 1
	Flags: None
*/
function get_gib_ref(direction)
{
	if(isdefined(self.a.gib_ref))
	{
		return;
	}
	if(self.damageTaken < 165)
	{
		return;
	}
	if(GetTime() > anim.lastGibTime + anim.gibDelay && anim.totalGibs > 0)
	{
		anim.totalGibs--;
		anim thread set_last_gib_time();
		refs = [];
		switch(direction)
		{
			case "right":
			{
				refs[refs.size] = "left_arm";
				refs[refs.size] = "left_leg";
				gib_ref = get_random(refs);
				break;
			}
			case "left":
			{
				refs[refs.size] = "right_arm";
				refs[refs.size] = "right_leg";
				gib_ref = get_random(refs);
				break;
			}
			case "forward":
			{
				refs[refs.size] = "right_arm";
				refs[refs.size] = "left_arm";
				refs[refs.size] = "right_leg";
				refs[refs.size] = "left_leg";
				refs[refs.size] = "guts";
				refs[refs.size] = "no_legs";
				gib_ref = get_random(refs);
				break;
			}
			case "back":
			{
				refs[refs.size] = "right_arm";
				refs[refs.size] = "left_arm";
				refs[refs.size] = "right_leg";
				refs[refs.size] = "left_leg";
				refs[refs.size] = "no_legs";
				gib_ref = get_random(refs);
				break;
			}
			case default:
			{
				refs[refs.size] = "right_arm";
				refs[refs.size] = "left_arm";
				refs[refs.size] = "right_leg";
				refs[refs.size] = "left_leg";
				refs[refs.size] = "no_legs";
				refs[refs.size] = "guts";
				gib_ref = get_random(refs);
				break;
			}
		}
		self.a.gib_ref = gib_ref;
	}
	else
	{
		self.a.gib_ref = undefined;
	}
}

/*
	Name: get_random
	Namespace: zombie_death
	Checksum: 0xBEEB3530
	Offset: 0xB58
	Size: 0x27
	Parameters: 1
	Flags: None
*/
function get_random(Array)
{
	return Array[RandomInt(Array.size)];
}

/*
	Name: do_gib
	Namespace: zombie_death
	Checksum: 0x52D49D55
	Offset: 0xB88
	Size: 0x15D
	Parameters: 0
	Flags: None
*/
function do_gib()
{
	if(!isdefined(self.a.gib_ref))
	{
		return;
	}
	if(isdefined(self.is_on_fire) && self.is_on_fire)
	{
		return;
	}
	switch(self.a.gib_ref)
	{
		case "right_arm":
		{
			GibServerUtils::GibRightArm(self);
			break;
		}
		case "left_arm":
		{
			GibServerUtils::GibLeftArm(self);
			break;
		}
		case "right_leg":
		{
			GibServerUtils::GibRightLeg(self);
			break;
		}
		case "left_leg":
		{
			GibServerUtils::GibLeftLeg(self);
			break;
		}
		case "no_legs":
		{
			GibServerUtils::GibLegs(self);
			break;
		}
		case "head":
		{
			GibServerUtils::GibHead(self);
			break;
		}
		case "guts":
		{
			break;
		}
		case default:
		{
			/#
				ASSERTMSG("Dev Block strings are not supported" + self.a.gib_ref + "Dev Block strings are not supported");
			#/
			break;
		}
	}
}

/*
	Name: precache_gib_fx
	Namespace: zombie_death
	Checksum: 0xEC25BF32
	Offset: 0xCF0
	Size: 0x55
	Parameters: 0
	Flags: None
*/
function precache_gib_fx()
{
	anim._effect["animscript_gib_fx"] = "zombie/fx_blood_torso_explo_zmb";
	anim._effect["animscript_gibtrail_fx"] = "_t6/trail/fx_trail_blood_streak";
	anim._effect["death_neckgrab_spurt"] = "_t6/impacts/fx_flesh_hit_neck_fatal";
}

