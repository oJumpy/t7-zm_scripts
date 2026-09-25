#using scripts\shared\array_shared;

#namespace string;

/*
	Name: rfill
	Namespace: string
	Checksum: 0xA8CCE6FE
	Offset: 0x98
	Size: 0x10B
	Parameters: 3
	Flags: None
*/
function rfill(str_input, n_length, str_fill_char)
{
	/#
		if(!isdefined(str_fill_char))
		{
			str_fill_char = "Dev Block strings are not supported";
		}
		if(str_fill_char == "Dev Block strings are not supported")
		{
			str_fill_char = "Dev Block strings are not supported";
		}
		/#
			Assert(str_fill_char.size == 1, "Dev Block strings are not supported");
		#/
		str_input = "Dev Block strings are not supported" + str_input;
		n_fill_count = n_length - str_input.size;
		str_fill = "Dev Block strings are not supported";
		if(n_fill_count > 0)
		{
			for(i = 0; i < n_fill_count; i++)
			{
				str_fill = str_fill + str_fill_char;
			}
		}
		return str_fill + str_input;
	#/
}

