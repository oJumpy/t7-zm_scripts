#using scripts\codescripts\struct;
#using scripts\shared\util_shared;

#namespace zombie_death;

/*
	Name: init_fire_fx
	Namespace: zombie_death
	Checksum: 0x70598E7A
	Offset: 0x180
	Size: 0x59
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init_fire_fx()
{
	wait(0.016);
	if(!isdefined(level._effect))
	{
		level._effect = [];
	}
	level._effect["character_fire_death_sm"] = "zombie/fx_fire_torso_zmb";
	level._effect["character_fire_death_torso"] = "zombie/fx_fire_torso_zmb";
}

/*
	Name: on_fire_timeout
	Namespace: zombie_death
	Checksum: 0xEB2011AA
	Offset: 0x1E8
	Size: 0x5D
	Parameters: 1
	Flags: None
*/
function on_fire_timeout(localClientNum)
{
	self endon("death");
	self endon("entityshutdown");
	wait(12);
	if(isdefined(self) && isalive(self))
	{
		self.is_on_fire = 0;
		self notify("stop_flame_damage");
	}
}

/*
	Name: flame_death_fx
	Namespace: zombie_death
	Checksum: 0xDADB1011
	Offset: 0x250
	Size: 0x333
	Parameters: 1
	Flags: None
*/
function flame_death_fx(localClientNum)
{
	self endon("death");
	self endon("entityshutdown");
	if(isdefined(self.is_on_fire) && self.is_on_fire)
	{
		return;
	}
	self.is_on_fire = 1;
	self thread on_fire_timeout();
	if(isdefined(level._effect) && isdefined(level._effect["character_fire_death_torso"]))
	{
		fire_tag = "j_spinelower";
		if(!isdefined(self GetTagOrigin(fire_tag)))
		{
			fire_tag = "tag_origin";
		}
		if(!isdefined(self.isdog) || !self.isdog)
		{
			PlayFXOnTag(localClientNum, level._effect["character_fire_death_torso"], self, fire_tag);
		}
	}
	else
	{
		println("Dev Block strings are not supported");
	}
	/#
	#/
	if(isdefined(level._effect) && isdefined(level._effect["character_fire_death_sm"]))
	{
		if(self.archetype !== "parasite" && self.archetype !== "raps")
		{
			wait(1);
			tagArray = [];
			tagArray[0] = "J_Elbow_LE";
			tagArray[1] = "J_Elbow_RI";
			tagArray[2] = "J_Knee_RI";
			tagArray[3] = "J_Knee_LE";
			tagArray = randomize_array(tagArray);
			PlayFXOnTag(localClientNum, level._effect["character_fire_death_sm"], self, tagArray[0]);
			wait(1);
			tagArray[0] = "J_Wrist_RI";
			tagArray[1] = "J_Wrist_LE";
			if(!(isdefined(self.missingLegs) && self.missingLegs))
			{
				tagArray[2] = "J_Ankle_RI";
				tagArray[3] = "J_Ankle_LE";
			}
			tagArray = randomize_array(tagArray);
			PlayFXOnTag(localClientNum, level._effect["character_fire_death_sm"], self, tagArray[0]);
			PlayFXOnTag(localClientNum, level._effect["character_fire_death_sm"], self, tagArray[1]);
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
	Checksum: 0x9FDF39C8
	Offset: 0x590
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

