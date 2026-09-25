#namespace table;

/*
	Name: load
	Namespace: table
	Checksum: 0xB1E72BDA
	Offset: 0x80
	Size: 0x27F
	Parameters: 3
	Flags: None
*/
function load(str_filename, str_table_start, b_convert_numbers)
{
	if(!isdefined(b_convert_numbers))
	{
		b_convert_numbers = 1;
	}
	a_table = [];
	n_header_row = TableLookupRowNum(str_filename, 0, str_table_start);
	/#
		Assert(n_header_row > -1, "Dev Block strings are not supported");
	#/
	a_headers = TableLookupRow(str_filename, n_header_row);
	n_row = n_header_row + 1;
	do
	{
		a_row = TableLookupRow(str_filename, n_row);
		if(isdefined(a_row) && a_row.size > 0)
		{
			index = StrStrip(a_row[0]);
			if(index != "")
			{
				if(index == "table_end")
				{
				}
				else if(b_convert_numbers)
				{
					index = str_to_num(index);
				}
				a_table[index] = [];
				for(VAL = 1; VAL < a_row.size; VAL++)
				{
					if(StrStrip(a_headers[VAL]) != "" && StrStrip(a_row[VAL]) != "")
					{
						value = a_row[VAL];
						if(b_convert_numbers)
						{
							value = str_to_num(value);
						}
						a_table[index][a_headers[VAL]] = value;
					}
				}
			}
		}
		n_row++;
	}
	while(!(isdefined(a_row) && a_row.size > 0));
	return a_table;
}

/*
	Name: str_to_num
	Namespace: table
	Checksum: 0x3C48F56
	Offset: 0x308
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function str_to_num(value)
{
	if(StrIsInt(value))
	{
		value = Int(value);
	}
	else if(StrIsFloat(value))
	{
		value = float(value);
	}
	return value;
}

