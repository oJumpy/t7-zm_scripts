#using scripts\codescripts\struct;
#using scripts\shared\util_shared;

#namespace zm_net;

/*
	Name: network_choke_init
	Namespace: zm_net
	Checksum: 0xA1DA08C3
	Offset: 0xA8
	Size: 0x73
	Parameters: 2
	Flags: None
*/
function network_choke_init(id, max)
{
	if(!isdefined(level.zombie_network_choke_ids_max))
	{
		level.zombie_network_choke_ids_max = [];
		level.zombie_network_choke_ids_count = [];
	}
	level.zombie_network_choke_ids_max[id] = max;
	level.zombie_network_choke_ids_count[id] = 0;
	level thread network_choke_thread(id);
}

/*
	Name: network_choke_thread
	Namespace: zm_net
	Checksum: 0x73C8D11B
	Offset: 0x128
	Size: 0x49
	Parameters: 1
	Flags: None
*/
function network_choke_thread(id)
{
	while(1)
	{
		util::wait_network_frame();
		util::wait_network_frame();
		level.zombie_network_choke_ids_count[id] = 0;
	}
}

/*
	Name: network_choke_safe
	Namespace: zm_net
	Checksum: 0x4BB00CEE
	Offset: 0x180
	Size: 0x25
	Parameters: 1
	Flags: None
*/
function network_choke_safe(id)
{
	return level.zombie_network_choke_ids_count[id] < level.zombie_network_choke_ids_max[id];
}

/*
	Name: network_choke_action
	Namespace: zm_net
	Checksum: 0x53E1A62C
	Offset: 0x1B0
	Size: 0xFD
	Parameters: 5
	Flags: None
*/
function network_choke_action(id, choke_action, arg1, arg2, arg3)
{
	/#
		Assert(isdefined(level.zombie_network_choke_ids_max[id]), "Dev Block strings are not supported" + id + "Dev Block strings are not supported");
	#/
	while(!network_choke_safe(id))
	{
		wait(0.05);
	}
	level.zombie_network_choke_ids_count[id]++;
	if(!isdefined(arg1))
	{
		return [[choke_action]]();
	}
	if(!isdefined(arg2))
	{
		return [[choke_action]](arg1);
	}
	if(!isdefined(arg3))
	{
		return [[choke_action]](arg1, arg2);
	}
	return [[choke_action]](arg1, arg2, arg3);
}

/*
	Name: network_entity_valid
	Namespace: zm_net
	Checksum: 0x83EBE64A
	Offset: 0x2B8
	Size: 0x1D
	Parameters: 1
	Flags: None
*/
function network_entity_valid(entity)
{
	if(!isdefined(entity))
	{
		return 0;
	}
	return 1;
}

/*
	Name: network_safe_init
	Namespace: zm_net
	Checksum: 0x9EE5E724
	Offset: 0x2E0
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function network_safe_init(id, max)
{
	if(!isdefined(level.zombie_network_choke_ids_max) || !isdefined(level.zombie_network_choke_ids_max[id]))
	{
		network_choke_init(id, max);
	}
	/#
		Assert(max == level.zombie_network_choke_ids_max[id]);
	#/
}

/*
	Name: _network_safe_spawn
	Namespace: zm_net
	Checksum: 0xB6A05505
	Offset: 0x368
	Size: 0x29
	Parameters: 2
	Flags: None
*/
function _network_safe_spawn(classname, origin)
{
	return spawn(classname, origin);
}

/*
	Name: network_safe_spawn
	Namespace: zm_net
	Checksum: 0xB95F31D6
	Offset: 0x3A0
	Size: 0x61
	Parameters: 4
	Flags: None
*/
function network_safe_spawn(id, max, classname, origin)
{
	network_safe_init(id, max);
	return network_choke_action(id, &_network_safe_spawn, classname, origin);
}

/*
	Name: _network_safe_play_fx_on_tag
	Namespace: zm_net
	Checksum: 0x500E8AB9
	Offset: 0x410
	Size: 0x53
	Parameters: 3
	Flags: None
*/
function _network_safe_play_fx_on_tag(FX, entity, tag)
{
	if(network_entity_valid(entity))
	{
		PlayFXOnTag(FX, entity, tag);
	}
}

/*
	Name: network_safe_play_fx_on_tag
	Namespace: zm_net
	Checksum: 0xC9E60C48
	Offset: 0x470
	Size: 0x73
	Parameters: 5
	Flags: None
*/
function network_safe_play_fx_on_tag(id, max, FX, entity, tag)
{
	network_safe_init(id, max);
	network_choke_action(id, &_network_safe_play_fx_on_tag, FX, entity, tag);
}

