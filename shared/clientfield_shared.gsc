#namespace clientfield;

/*
	Name: register
	Namespace: clientfield
	Checksum: 0xE517FF89
	Offset: 0x78
	Size: 0x53
	Parameters: 5
	Flags: None
*/
function register(str_pool_name, str_name, n_version, n_bits, str_type)
{
	RegisterClientField(str_pool_name, str_name, n_version, n_bits, str_type);
}

/*
	Name: set
	Namespace: clientfield
	Checksum: 0x4076E995
	Offset: 0xD8
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function set(str_field_name, n_value)
{
	if(self == level)
	{
		CodeSetWorldClientField(str_field_name, n_value);
	}
	else
	{
		CodeSetClientField(self, str_field_name, n_value);
	}
}

/*
	Name: set_to_player
	Namespace: clientfield
	Checksum: 0x72F4F0BC
	Offset: 0x140
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function set_to_player(str_field_name, n_value)
{
	CodeSetPlayerStateClientField(self, str_field_name, n_value);
}

/*
	Name: set_player_uimodel
	Namespace: clientfield
	Checksum: 0x7680423F
	Offset: 0x180
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function set_player_uimodel(str_field_name, n_value)
{
	if(!IsEntity(self))
	{
		return;
	}
	CodeSetUIModelClientField(self, str_field_name, n_value);
}

/*
	Name: get_player_uimodel
	Namespace: clientfield
	Checksum: 0x794BB944
	Offset: 0x1D8
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function get_player_uimodel(str_field_name)
{
	return CodeGetUIModelClientField(self, str_field_name);
}

/*
	Name: increment
	Namespace: clientfield
	Checksum: 0xA2ED5C1B
	Offset: 0x208
	Size: 0x8D
	Parameters: 2
	Flags: None
*/
function increment(str_field_name, n_increment_count)
{
	if(!isdefined(n_increment_count))
	{
		n_increment_count = 1;
	}
	for(i = 0; i < n_increment_count; i++)
	{
		if(self == level)
		{
			CodeIncrementWorldClientField(str_field_name);
			continue;
		}
		CodeIncrementClientField(self, str_field_name);
	}
}

/*
	Name: increment_uimodel
	Namespace: clientfield
	Checksum: 0xF74DCBAF
	Offset: 0x2A0
	Size: 0x11D
	Parameters: 2
	Flags: None
*/
function increment_uimodel(str_field_name, n_increment_count)
{
	if(!isdefined(n_increment_count))
	{
		n_increment_count = 1;
	}
	if(self == level)
	{
		foreach(player in level.players)
		{
			for(i = 0; i < n_increment_count; i++)
			{
				CodeIncrementUIModelClientField(player, str_field_name);
			}
		}
		break;
	}
	for(i = 0; i < n_increment_count; i++)
	{
		CodeIncrementUIModelClientField(self, str_field_name);
	}
}

/*
	Name: increment_to_player
	Namespace: clientfield
	Checksum: 0x6CC3899A
	Offset: 0x3C8
	Size: 0x65
	Parameters: 2
	Flags: None
*/
function increment_to_player(str_field_name, n_increment_count)
{
	if(!isdefined(n_increment_count))
	{
		n_increment_count = 1;
	}
	for(i = 0; i < n_increment_count; i++)
	{
		CodeIncrementPlayerStateClientField(self, str_field_name);
	}
}

/*
	Name: get
	Namespace: clientfield
	Checksum: 0x31FE6086
	Offset: 0x438
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function get(str_field_name)
{
	if(self == level)
	{
		return CodeGetWorldClientField(str_field_name);
	}
	else
	{
		return CodeGetClientField(self, str_field_name);
	}
}

/*
	Name: get_to_player
	Namespace: clientfield
	Checksum: 0x9D06D42D
	Offset: 0x490
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function get_to_player(field_name)
{
	return CodeGetPlayerStateClientField(self, field_name);
}

