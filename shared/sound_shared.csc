#namespace sound;

/*
	Name: loop_fx_sound
	Namespace: sound
	Checksum: 0x9063C75E
	Offset: 0x80
	Size: 0x93
	Parameters: 4
	Flags: None
*/
function loop_fx_sound(clientNum, alias, origin, ender)
{
	sound_entity = spawn(clientNum, origin, "script_origin");
	if(isdefined(ender))
	{
		thread loop_delete(ender, sound_entity);
		self endon(ender);
	}
	sound_entity PlayLoopSound(alias);
}

/*
	Name: play_in_space
	Namespace: sound
	Checksum: 0x6D5E6BBA
	Offset: 0x120
	Size: 0x3B
	Parameters: 3
	Flags: None
*/
function play_in_space(localClientNum, alias, origin)
{
	playsound(localClientNum, alias, origin);
}

/*
	Name: loop_delete
	Namespace: sound
	Checksum: 0xD672EB05
	Offset: 0x168
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function loop_delete(ender, sound_entity)
{
	self waittill(ender);
	sound_entity delete();
}

/*
	Name: play_on_client
	Namespace: sound
	Checksum: 0xA45C4987
	Offset: 0x1A8
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function play_on_client(sound_alias)
{
	players = level.localPlayers;
	playsound(0, sound_alias, players[0].origin);
}

/*
	Name: loop_on_client
	Namespace: sound
	Checksum: 0x71DC55A7
	Offset: 0x200
	Size: 0x81
	Parameters: 4
	Flags: None
*/
function loop_on_client(sound_alias, min_delay, max_delay, end_on)
{
	players = level.localPlayers;
	if(isdefined(end_on))
	{
		level endon(end_on);
	}
	for(;;)
	{
		play_on_client(sound_alias);
		wait(min_delay + RandomFloat(max_delay));
	}
}

