#using scripts\shared\util_shared;

#namespace sound;

/*
	Name: loop_fx_sound
	Namespace: sound
	Checksum: 0x58245982
	Offset: 0xB8
	Size: 0xA3
	Parameters: 3
	Flags: None
*/
function loop_fx_sound(alias, origin, ender)
{
	org = spawn("script_origin", (0, 0, 0));
	if(isdefined(ender))
	{
		thread loop_delete(ender, org);
		self endon(ender);
	}
	org.origin = origin;
	org PlayLoopSound(alias);
}

/*
	Name: loop_delete
	Namespace: sound
	Checksum: 0xD927BE59
	Offset: 0x168
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function loop_delete(ender, ent)
{
	ent endon("death");
	self waittill(ender);
	ent delete();
}

/*
	Name: play_in_space
	Namespace: sound
	Checksum: 0x5B6206DD
	Offset: 0x1B8
	Size: 0xC3
	Parameters: 3
	Flags: None
*/
function play_in_space(alias, origin, master)
{
	org = spawn("script_origin", (0, 0, 1));
	if(!isdefined(origin))
	{
		origin = self.origin;
	}
	org.origin = origin;
	org PlaySoundWithNotify(alias, "sounddone");
	org waittill("sounddone");
	if(isdefined(org))
	{
		org delete();
	}
}

/*
	Name: loop_on_tag
	Namespace: sound
	Checksum: 0xE6C1C665
	Offset: 0x288
	Size: 0x15B
	Parameters: 3
	Flags: None
*/
function loop_on_tag(alias, tag, bStopSoundOnDeath)
{
	org = spawn("script_origin", (0, 0, 0));
	org endon("death");
	if(!isdefined(bStopSoundOnDeath))
	{
		bStopSoundOnDeath = 1;
	}
	if(bStopSoundOnDeath)
	{
		thread util::delete_on_death(org);
	}
	if(isdefined(tag))
	{
		org LinkTo(self, tag, (0, 0, 0), (0, 0, 0));
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org LinkTo(self);
	}
	org PlayLoopSound(alias);
	self waittill("stop sound" + alias);
	org StopLoopSound(alias);
	org delete();
}

/*
	Name: play_on_tag
	Namespace: sound
	Checksum: 0x4B1702D3
	Offset: 0x3F0
	Size: 0x19B
	Parameters: 3
	Flags: None
*/
function play_on_tag(alias, tag, ends_on_death)
{
	org = spawn("script_origin", (0, 0, 0));
	org endon("death");
	thread delete_on_death_wait(org, "sounddone");
	if(isdefined(tag))
	{
		org.origin = self GetTagOrigin(tag);
		org LinkTo(self, tag, (0, 0, 0), (0, 0, 0));
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org LinkTo(self);
	}
	org PlaySoundWithNotify(alias, "sounddone");
	if(isdefined(ends_on_death))
	{
		/#
			Assert(ends_on_death, "Dev Block strings are not supported");
		#/
		wait_for_sounddone_or_death(org);
		wait(0.05);
	}
	else
	{
		org waittill("sounddone");
	}
	org delete();
}

/*
	Name: play_on_entity
	Namespace: sound
	Checksum: 0x5A2CFDDF
	Offset: 0x598
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function play_on_entity(alias)
{
	play_on_tag(alias);
}

/*
	Name: wait_for_sounddone_or_death
	Namespace: sound
	Checksum: 0x32AE8974
	Offset: 0x5C8
	Size: 0x25
	Parameters: 1
	Flags: None
*/
function wait_for_sounddone_or_death(org)
{
	self endon("death");
	org waittill("sounddone");
}

/*
	Name: stop_loop_on_entity
	Namespace: sound
	Checksum: 0x16A8D5E0
	Offset: 0x5F8
	Size: 0x1F
	Parameters: 1
	Flags: None
*/
function stop_loop_on_entity(alias)
{
	self notify("stop sound" + alias);
}

/*
	Name: loop_on_entity
	Namespace: sound
	Checksum: 0xE09CA0E2
	Offset: 0x620
	Size: 0x163
	Parameters: 2
	Flags: None
*/
function loop_on_entity(alias, offset)
{
	org = spawn("script_origin", (0, 0, 0));
	org endon("death");
	thread util::delete_on_death(org);
	if(isdefined(offset))
	{
		org.origin = self.origin + offset;
		org.angles = self.angles;
		org LinkTo(self);
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org LinkTo(self);
	}
	org PlayLoopSound(alias);
	self waittill("stop sound" + alias);
	org StopLoopSound(0.1);
	org delete();
}

/*
	Name: loop_in_space
	Namespace: sound
	Checksum: 0x43CF5034
	Offset: 0x790
	Size: 0xCB
	Parameters: 3
	Flags: None
*/
function loop_in_space(alias, origin, ender)
{
	org = spawn("script_origin", (0, 0, 1));
	if(!isdefined(origin))
	{
		origin = self.origin;
	}
	org.origin = origin;
	org PlayLoopSound(alias);
	level waittill(ender);
	org StopLoopSound();
	wait(0.1);
	org delete();
}

/*
	Name: delete_on_death_wait
	Namespace: sound
	Checksum: 0x5E68983
	Offset: 0x868
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function delete_on_death_wait(ent, sounddone)
{
	ent endon("death");
	self waittill("death");
	if(isdefined(ent))
	{
		ent delete();
	}
}

/*
	Name: play_on_players
	Namespace: sound
	Checksum: 0xE2110BAB
	Offset: 0x8C0
	Size: 0x175
	Parameters: 2
	Flags: None
*/
function play_on_players(sound, team)
{
	/#
		Assert(isdefined(level.players));
	#/
	if(level.Splitscreen)
	{
		if(isdefined(level.players[0]))
		{
			level.players[0] playlocalsound(sound);
		}
		break;
	}
	if(isdefined(team))
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			if(isdefined(player.pers["team"]) && player.pers["team"] == team)
			{
				player playlocalsound(sound);
			}
		}
		break;
	}
	for(i = 0; i < level.players.size; i++)
	{
		level.players[i] playlocalsound(sound);
	}
}

