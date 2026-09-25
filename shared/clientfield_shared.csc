#namespace clientfield;

/*
	Name: register
	Namespace: clientfield
	Checksum: 0x5CF03B24
	Offset: 0x78
	Size: 0x73
	Parameters: 8
	Flags: None
*/
function register(str_pool_name, str_name, n_version, n_bits, str_type, func_callback, var_3debd71e, var_37d3ccda)
{
	RegisterClientField(str_pool_name, str_name, n_version, n_bits, str_type, func_callback, var_3debd71e, var_37d3ccda);
}

/*
	Name: get
	Namespace: clientfield
	Checksum: 0x4E79446D
	Offset: 0xF8
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function get(field_name)
{
	if(self == level)
	{
		return CodeGetWorldClientField(field_name);
	}
	else
	{
		return CodeGetClientField(self, field_name);
	}
}

/*
	Name: get_to_player
	Namespace: clientfield
	Checksum: 0xEDA893FF
	Offset: 0x150
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function get_to_player(field_name)
{
	return CodeGetPlayerStateClientField(self, field_name);
}

/*
	Name: get_player_uimodel
	Namespace: clientfield
	Checksum: 0x62B4F328
	Offset: 0x180
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function get_player_uimodel(field_name)
{
	return CodeGetUIModelClientField(self, field_name);
}

