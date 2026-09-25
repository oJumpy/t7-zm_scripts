#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

#namespace Array;

/*
	Name: filter
	Namespace: Array
	Checksum: 0x4EA9F1F3
	Offset: 0x120
	Size: 0x19D
	Parameters: 8
	Flags: None
*/
function filter(Array, b_keep_keys, func_filter, arg1, arg2, arg3, arg4, arg5)
{
	a_new = [];
	foreach(VAL in Array)
	{
		if(util::single_func(self, func_filter, VAL, arg1, arg2, arg3, arg4, arg5))
		{
			if(IsString(key) || IsWeapon(key))
			{
				if(isdefined(b_keep_keys) && !b_keep_keys)
				{
					a_new[a_new.size] = VAL;
				}
				else
				{
					a_new[key] = VAL;
				}
				continue;
			}
			if(isdefined(b_keep_keys) && b_keep_keys)
			{
				a_new[key] = VAL;
				continue;
			}
			a_new[a_new.size] = VAL;
		}
	}
	return a_new;
}

/*
	Name: remove_undefined
	Namespace: Array
	Checksum: 0xEDC67DD3
	Offset: 0x2C8
	Size: 0x5F
	Parameters: 2
	Flags: None
*/
function remove_undefined(Array, b_keep_keys)
{
	if(isdefined(b_keep_keys))
	{
		ArrayRemoveValue(Array, undefined, b_keep_keys);
	}
	else
	{
		ArrayRemoveValue(Array, undefined);
	}
	return Array;
}

/*
	Name: get_touching
	Namespace: Array
	Checksum: 0xA1B25701
	Offset: 0x330
	Size: 0x39
	Parameters: 2
	Flags: None
*/
function get_touching(Array, b_keep_keys)
{
	return filter(Array, b_keep_keys, &istouching);
}

/*
	Name: remove_index
	Namespace: Array
	Checksum: 0x33526F10
	Offset: 0x378
	Size: 0xEB
	Parameters: 3
	Flags: None
*/
function remove_index(Array, index, b_keep_keys)
{
	a_new = [];
	foreach(VAL in Array)
	{
		if(key == index)
		{
			continue;
			continue;
		}
		if(isdefined(b_keep_keys) && b_keep_keys)
		{
			a_new[key] = VAL;
			continue;
		}
		a_new[a_new.size] = VAL;
	}
	return a_new;
}

/*
	Name: delete_all
	Namespace: Array
	Checksum: 0xDA7D54CD
	Offset: 0x470
	Size: 0xF9
	Parameters: 2
	Flags: None
*/
function delete_all(Array, is_struct)
{
	foreach(ent in Array)
	{
		if(isdefined(ent))
		{
			if(isdefined(is_struct) && is_struct)
			{
				ent struct::delete();
				continue;
			}
			if(isdefined(ent.__vtable))
			{
				ent notify("death");
				ent = undefined;
				continue;
			}
			ent delete();
		}
	}
}

/*
	Name: notify_all
	Namespace: Array
	Checksum: 0x3DAE409A
	Offset: 0x578
	Size: 0x8D
	Parameters: 2
	Flags: None
*/
function notify_all(Array, str_notify)
{
	foreach(elem in Array)
	{
		elem notify(str_notify);
	}
}

/*
	Name: thread_all
	Namespace: Array
	Checksum: 0xE0409060
	Offset: 0x610
	Size: 0x4CB
	Parameters: 8
	Flags: None
*/
function thread_all(entities, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	/#
		Assert(isdefined(entities), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(func), "Dev Block strings are not supported");
	#/
	if(IsArray(entities))
	{
		if(isdefined(arg6))
		{
			foreach(ent in entities)
			{
				ent thread [[func]](arg1, arg2, arg3, arg4, arg5, arg6);
			}
			break;
		}
		if(isdefined(arg5))
		{
			foreach(ent in entities)
			{
				ent thread [[func]](arg1, arg2, arg3, arg4, arg5);
			}
			break;
		}
		if(isdefined(arg4))
		{
			foreach(ent in entities)
			{
				ent thread [[func]](arg1, arg2, arg3, arg4);
			}
			break;
		}
		if(isdefined(arg3))
		{
			foreach(ent in entities)
			{
				ent thread [[func]](arg1, arg2, arg3);
			}
			break;
		}
		if(isdefined(arg2))
		{
			foreach(ent in entities)
			{
				ent thread [[func]](arg1, arg2);
			}
			break;
		}
		if(isdefined(arg1))
		{
			foreach(ent in entities)
			{
				ent thread [[func]](arg1);
			}
			break;
		}
		foreach(ent in entities)
		{
			ent thread [[func]]();
		}
	}
	else
	{
		util::single_thread(entities, func, arg1, arg2, arg3, arg4, arg5, arg6);
	}
}

/*
	Name: thread_all_ents
	Namespace: Array
	Checksum: 0x25D9A24F
	Offset: 0xAE8
	Size: 0x16B
	Parameters: 7
	Flags: None
*/
function thread_all_ents(entities, func, arg1, arg2, arg3, arg4, arg5)
{
	/#
		Assert(isdefined(entities), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(func), "Dev Block strings are not supported");
	#/
	if(IsArray(entities))
	{
		if(entities.size)
		{
			keys = getArrayKeys(entities);
			for(i = 0; i < keys.size; i++)
			{
				util::single_thread(self, func, entities[keys[i]], arg1, arg2, arg3, arg4, arg5);
			}
		}
	}
	else
	{
		util::single_thread(self, func, entities, arg1, arg2, arg3, arg4, arg5);
	}
}

/*
	Name: run_all
	Namespace: Array
	Checksum: 0x36DEB30
	Offset: 0xC60
	Size: 0x4CB
	Parameters: 8
	Flags: None
*/
function run_all(entities, func, arg1, arg2, arg3, arg4, arg5, arg6)
{
	/#
		Assert(isdefined(entities), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(func), "Dev Block strings are not supported");
	#/
	if(IsArray(entities))
	{
		if(isdefined(arg6))
		{
			foreach(ent in entities)
			{
				ent [[func]](arg1, arg2, arg3, arg4, arg5, arg6);
			}
			break;
		}
		if(isdefined(arg5))
		{
			foreach(ent in entities)
			{
				ent [[func]](arg1, arg2, arg3, arg4, arg5);
			}
			break;
		}
		if(isdefined(arg4))
		{
			foreach(ent in entities)
			{
				ent [[func]](arg1, arg2, arg3, arg4);
			}
			break;
		}
		if(isdefined(arg3))
		{
			foreach(ent in entities)
			{
				ent [[func]](arg1, arg2, arg3);
			}
			break;
		}
		if(isdefined(arg2))
		{
			foreach(ent in entities)
			{
				ent [[func]](arg1, arg2);
			}
			break;
		}
		if(isdefined(arg1))
		{
			foreach(ent in entities)
			{
				ent [[func]](arg1);
			}
			break;
		}
		foreach(ent in entities)
		{
			ent [[func]]();
		}
	}
	else
	{
		util::single_func(entities, func, arg1, arg2, arg3, arg4, arg5, arg6);
	}
}

/*
	Name: exclude
	Namespace: Array
	Checksum: 0xCFEB73C6
	Offset: 0x1138
	Size: 0xA7
	Parameters: 2
	Flags: None
*/
function exclude(Array, array_exclude)
{
	newArray = Array;
	if(IsArray(array_exclude))
	{
		for(i = 0; i < array_exclude.size; i++)
		{
			ArrayRemoveValue(newArray, array_exclude[i]);
		}
	}
	else
	{
		ArrayRemoveValue(newArray, array_exclude);
	}
	return newArray;
}

/*
	Name: add
	Namespace: Array
	Checksum: 0xA6B8ECB7
	Offset: 0x11E8
	Size: 0x75
	Parameters: 3
	Flags: None
*/
function add(Array, item, allow_dupes)
{
	if(!isdefined(allow_dupes))
	{
		allow_dupes = 1;
	}
	if(isdefined(item))
	{
		if(allow_dupes || !IsInArray(Array, item))
		{
			Array[Array.size] = item;
		}
	}
	return Array;
}

/*
	Name: add_sorted
	Namespace: Array
	Checksum: 0xE0C45F1E
	Offset: 0x1268
	Size: 0xD1
	Parameters: 3
	Flags: None
*/
function add_sorted(Array, item, allow_dupes)
{
	if(!isdefined(allow_dupes))
	{
		allow_dupes = 1;
	}
	if(isdefined(item))
	{
		if(allow_dupes || !IsInArray(Array, item))
		{
			for(i = 0; i <= Array.size; i++)
			{
				if(i == Array.size || item <= Array[i])
				{
					ArrayInsert(Array, item, i);
					break;
				}
			}
		}
	}
}

/*
	Name: wait_till
	Namespace: Array
	Checksum: 0x8F8FD719
	Offset: 0x1348
	Size: 0x16D
	Parameters: 3
	Flags: None
*/
function wait_till(Array, msg, n_timeout)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon("timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	s_tracker = spawnstruct();
	s_tracker._wait_count = 0;
	foreach(ent in Array)
	{
		if(isdefined(ent))
		{
			ent thread util::timeout(n_timeout, &util::_waitlogic, s_tracker, msg);
		}
	}
	if(s_tracker._wait_count > 0)
	{
		s_tracker waittill("waitlogic_finished");
	}
}

/*
	Name: flag_wait
	Namespace: Array
	Checksum: 0x11947C1A
	Offset: 0x14C0
	Size: 0x85
	Parameters: 2
	Flags: None
*/
function flag_wait(Array, str_flag)
{
	for(i = 0; i < Array.size; i++)
	{
		ent = Array[i];
		if(!ent flag::get(str_flag))
		{
			ent waittill(str_flag);
			i = -1;
		}
	}
}

/*
	Name: flagsys_wait
	Namespace: Array
	Checksum: 0x110C2047
	Offset: 0x1550
	Size: 0x85
	Parameters: 2
	Flags: None
*/
function flagsys_wait(Array, str_flag)
{
	for(i = 0; i < Array.size; i++)
	{
		ent = Array[i];
		if(!ent flagsys::get(str_flag))
		{
			ent waittill(str_flag);
			i = -1;
		}
	}
}

/*
	Name: flagsys_wait_any_flag
	Namespace: Array
	Checksum: 0x1733A161
	Offset: 0x15E0
	Size: 0x137
	Parameters: 2
	Flags: 32
*/
function flagsys_wait_any_flag(Array, vararg)
{
	for(i = 0; i < Array.size; i++)
	{
		ent = Array[i];
		if(isdefined(ent))
		{
			b_flag_set = 0;
			foreach(str_flag in vararg)
			{
				if(ent flagsys::get(str_flag))
				{
					b_flag_set = 1;
					break;
				}
			}
			if(!b_flag_set)
			{
				ent util::waittill_any_array(vararg);
				i = -1;
			}
		}
	}
}

/*
	Name: flag_wait_clear
	Namespace: Array
	Checksum: 0x172AB17A
	Offset: 0x1720
	Size: 0x85
	Parameters: 2
	Flags: None
*/
function flag_wait_clear(Array, str_flag)
{
	for(i = 0; i < Array.size; i++)
	{
		ent = Array[i];
		if(ent flag::get(str_flag))
		{
			ent waittill(str_flag);
			i = -1;
		}
	}
}

/*
	Name: flagsys_wait_clear
	Namespace: Array
	Checksum: 0x23E66C2E
	Offset: 0x17B0
	Size: 0x85
	Parameters: 2
	Flags: None
*/
function flagsys_wait_clear(Array, str_flag)
{
	for(i = 0; i < Array.size; i++)
	{
		ent = Array[i];
		if(ent flagsys::get(str_flag))
		{
			ent waittill(str_flag);
			i = -1;
		}
	}
}

/*
	Name: wait_any
	Namespace: Array
	Checksum: 0x24910351
	Offset: 0x1840
	Size: 0x1F3
	Parameters: 3
	Flags: None
*/
function wait_any(Array, msg, n_timeout)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon("timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	s_tracker = spawnstruct();
	a_structs = [];
	foreach(ent in Array)
	{
		if(isdefined(ent))
		{
			s = spawnstruct();
			s thread util::timeout(n_timeout, &_waitlogic2, s_tracker, ent, msg);
			if(!isdefined(a_structs))
			{
				a_structs = [];
			}
			else if(!IsArray(a_structs))
			{
				a_structs = Array(a_structs);
			}
			a_structs[a_structs.size] = s;
		}
	}
	s_tracker endon("array_wait");
	wait_till(Array, "death");
}

/*
	Name: _waitlogic2
	Namespace: Array
	Checksum: 0xE122F8E2
	Offset: 0x1A40
	Size: 0x4F
	Parameters: 3
	Flags: None
*/
function _waitlogic2(s_tracker, ent, msg)
{
	s_tracker endon("array_wait");
	ent endon("death");
	ent waittill(msg);
	s_tracker notify("array_wait");
}

/*
	Name: flag_wait_any
	Namespace: Array
	Checksum: 0xB9F72E12
	Offset: 0x1A98
	Size: 0xCB
	Parameters: 2
	Flags: None
*/
function flag_wait_any(Array, str_flag)
{
	self endon("death");
	foreach(ent in Array)
	{
		if(ent flag::get(str_flag))
		{
			return ent;
		}
	}
	wait_any(Array, str_flag);
}

/*
	Name: random
	Namespace: Array
	Checksum: 0x37DE7978
	Offset: 0x1B70
	Size: 0x55
	Parameters: 1
	Flags: None
*/
function random(Array)
{
	keys = getArrayKeys(Array);
	return Array[keys[RandomInt(keys.size)]];
}

/*
	Name: randomize
	Namespace: Array
	Checksum: 0x33E209A5
	Offset: 0x1BD0
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function randomize(Array)
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
	Name: reverse
	Namespace: Array
	Checksum: 0xBB8CA7AB
	Offset: 0x1C78
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function reverse(Array)
{
	a_array2 = [];
	for(i = Array.size - 1; i >= 0; i--)
	{
		a_array2[a_array2.size] = Array[i];
	}
	return a_array2;
}

/*
	Name: remove_keys
	Namespace: Array
	Checksum: 0x1EEDCD47
	Offset: 0x1CE8
	Size: 0xA9
	Parameters: 1
	Flags: None
*/
function remove_keys(Array)
{
	a_new = [];
	foreach(VAL in Array)
	{
		if(isdefined(VAL))
		{
			a_new[a_new.size] = VAL;
		}
	}
	return a_new;
}

/*
	Name: swap
	Namespace: Array
	Checksum: 0xC64DA545
	Offset: 0x1DA0
	Size: 0xA9
	Parameters: 3
	Flags: None
*/
function swap(Array, index1, index2)
{
	/#
		Assert(index1 < Array.size, "Dev Block strings are not supported");
	#/
	/#
		Assert(index2 < Array.size, "Dev Block strings are not supported");
	#/
	temp = Array[index1];
	Array[index1] = Array[index2];
	Array[index2] = temp;
}

/*
	Name: pop
	Namespace: Array
	Checksum: 0xB58035DF
	Offset: 0x1E58
	Size: 0xC1
	Parameters: 3
	Flags: None
*/
function pop(Array, index, b_keep_keys)
{
	if(!isdefined(b_keep_keys))
	{
		b_keep_keys = 1;
	}
	if(Array.size > 0)
	{
		if(!isdefined(index))
		{
			keys = getArrayKeys(Array);
			index = keys[0];
		}
		if(isdefined(Array[index]))
		{
			ret = Array[index];
			ArrayRemoveIndex(Array, index, b_keep_keys);
			return ret;
		}
	}
}

/*
	Name: pop_front
	Namespace: Array
	Checksum: 0xC2569658
	Offset: 0x1F28
	Size: 0x81
	Parameters: 2
	Flags: None
*/
function pop_front(Array, b_keep_keys)
{
	if(!isdefined(b_keep_keys))
	{
		b_keep_keys = 1;
	}
	keys = getArrayKeys(Array);
	index = keys[keys.size - 1];
	return pop(Array, index, b_keep_keys);
}

/*
	Name: push
	Namespace: Array
	Checksum: 0xEF751FE6
	Offset: 0x1FB8
	Size: 0x103
	Parameters: 3
	Flags: None
*/
function push(Array, VAL, index)
{
	if(!isdefined(index))
	{
		index = 0;
		foreach(key in getArrayKeys(Array))
		{
			if(IsInt(key) && key >= index)
			{
				index = key + 1;
			}
		}
	}
	ArrayInsert(Array, VAL, index);
}

/*
	Name: push_front
	Namespace: Array
	Checksum: 0xF0326F59
	Offset: 0x20C8
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function push_front(Array, VAL)
{
	push(Array, VAL, 0);
}

/*
	Name: get_closest
	Namespace: Array
	Checksum: 0x5BCF3371
	Offset: 0x2108
	Size: 0x4B
	Parameters: 3
	Flags: None
*/
function get_closest(org, Array, dist)
{
	if(!isdefined(dist))
	{
		dist = undefined;
	}
	/#
		Assert(0, "Dev Block strings are not supported");
	#/
}

/*
	Name: get_farthest
	Namespace: Array
	Checksum: 0xD538273A
	Offset: 0x2160
	Size: 0x4B
	Parameters: 3
	Flags: None
*/
function get_farthest(org, Array, dist)
{
	if(!isdefined(dist))
	{
		dist = undefined;
	}
	/#
		Assert(0, "Dev Block strings are not supported");
	#/
}

/*
	Name: closerFunc
	Namespace: Array
	Checksum: 0x7D943098
	Offset: 0x21B8
	Size: 0x1D
	Parameters: 2
	Flags: None
*/
function closerFunc(dist1, dist2)
{
	return dist1 >= dist2;
}

/*
	Name: fartherFunc
	Namespace: Array
	Checksum: 0xD36A7F6B
	Offset: 0x21E0
	Size: 0x1D
	Parameters: 2
	Flags: None
*/
function fartherFunc(dist1, dist2)
{
	return dist1 <= dist2;
}

/*
	Name: get_all_farthest
	Namespace: Array
	Checksum: 0x12BFBA14
	Offset: 0x2208
	Size: 0xDB
	Parameters: 4
	Flags: None
*/
function get_all_farthest(org, Array, excluders, max)
{
	sorted_array = get_closest(org, Array, excluders);
	if(isdefined(max))
	{
		temp_array = [];
		for(i = 0; i < sorted_array.size; i++)
		{
			temp_array[temp_array.size] = sorted_array[sorted_array.size - i];
		}
		sorted_array = temp_array;
	}
	sorted_array = reverse(sorted_array);
	return sorted_array;
}

/*
	Name: get_all_closest
	Namespace: Array
	Checksum: 0xDEBFF42F
	Offset: 0x22F0
	Size: 0x32F
	Parameters: 5
	Flags: None
*/
function get_all_closest(org, Array, excluders, max, maxdist)
{
	if(!isdefined(max))
	{
		max = Array.size;
	}
	if(!isdefined(excluders))
	{
		excluders = [];
	}
	maxdists2rd = undefined;
	if(isdefined(maxdist))
	{
		maxdists2rd = maxdist * maxdist;
	}
	dist = [];
	index = [];
	for(i = 0; i < Array.size; i++)
	{
		if(!isdefined(Array[i]))
		{
			continue;
		}
		excluded = 0;
		for(p = 0; p < excluders.size; p++)
		{
			if(Array[i] != excluders[p])
			{
				continue;
			}
			excluded = 1;
			break;
		}
		if(excluded)
		{
			continue;
		}
		length = DistanceSquared(org, Array[i].origin);
		if(isdefined(maxdists2rd) && maxdists2rd < length)
		{
			continue;
		}
		dist[dist.size] = length;
		index[index.size] = i;
	}
	for(;;)
	{
		change = 0;
		for(i = 0; i < dist.size - 1; i++)
		{
			if(dist[i] <= dist[i + 1])
			{
				continue;
			}
			change = 1;
			temp = dist[i];
			dist[i] = dist[i + 1];
			dist[i + 1] = temp;
			temp = index[i];
			index[i] = index[i + 1];
			index[i + 1] = temp;
		}
		if(!change)
		{
		}
	}
	else
	{
	}
	newArray = [];
	if(max > dist.size)
	{
		max = dist.size;
	}
	for(i = 0; i < max; i++)
	{
		newArray[i] = Array[index[i]];
	}
	return newArray;
}

/*
	Name: alphabetize
	Namespace: Array
	Checksum: 0xC5D2AD4
	Offset: 0x2628
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function alphabetize(Array)
{
	return sort_by_value(Array, 1);
}

/*
	Name: sort_by_value
	Namespace: Array
	Checksum: 0xAB0399A9
	Offset: 0x2658
	Size: 0x49
	Parameters: 2
	Flags: None
*/
function sort_by_value(Array, b_lowest_first)
{
	if(!isdefined(b_lowest_first))
	{
		b_lowest_first = 0;
	}
	return merge_sort(Array, &_sort_by_value_compare_func, b_lowest_first);
}

/*
	Name: _sort_by_value_compare_func
	Namespace: Array
	Checksum: 0xF5CAEB0F
	Offset: 0x26B0
	Size: 0x3F
	Parameters: 3
	Flags: None
*/
function _sort_by_value_compare_func(val1, val2, b_lowest_first)
{
	if(b_lowest_first)
	{
		return val1 < val2;
	}
	else
	{
		return val1 > val2;
	}
}

/*
	Name: sort_by_script_int
	Namespace: Array
	Checksum: 0x1D35FDE7
	Offset: 0x26F8
	Size: 0x49
	Parameters: 2
	Flags: None
*/
function sort_by_script_int(a_ents, b_lowest_first)
{
	if(!isdefined(b_lowest_first))
	{
		b_lowest_first = 0;
	}
	return merge_sort(a_ents, &_sort_by_script_int_compare_func, b_lowest_first);
}

/*
	Name: _sort_by_script_int_compare_func
	Namespace: Array
	Checksum: 0xC7217C81
	Offset: 0x2750
	Size: 0x61
	Parameters: 3
	Flags: None
*/
function _sort_by_script_int_compare_func(e1, e2, b_lowest_first)
{
	if(b_lowest_first)
	{
		return e1.script_int < e2.script_int;
	}
	else
	{
		return e1.script_int > e2.script_int;
	}
}

/*
	Name: merge_sort
	Namespace: Array
	Checksum: 0xE0FC88B5
	Offset: 0x27C0
	Size: 0x1E3
	Parameters: 3
	Flags: None
*/
function merge_sort(current_list, func_sort, Param)
{
	if(current_list.size <= 1)
	{
		return current_list;
	}
	left = [];
	right = [];
	middle = current_list.size / 2;
	for(x = 0; x < middle; x++)
	{
		if(!isdefined(left))
		{
			left = [];
		}
		else if(!IsArray(left))
		{
			left = Array(left);
		}
		left[left.size] = current_list[x];
	}
	while(x < current_list.size)
	{
		if(!isdefined(right))
		{
			right = [];
		}
		else if(!IsArray(right))
		{
			right = Array(right);
		}
		right[right.size] = current_list[x];
		x++;
	}
	left = merge_sort(left, func_sort, Param);
	right = merge_sort(right, func_sort, Param);
	result = merge(left, right, func_sort, Param);
	return result;
}

/*
	Name: merge
	Namespace: Array
	Checksum: 0xC9EF56E8
	Offset: 0x29B0
	Size: 0x191
	Parameters: 4
	Flags: None
*/
function merge(left, right, func_sort, Param)
{
	result = [];
	li = 0;
	ri = 0;
	while(li < left.size && ri < right.size)
	{
		b_result = undefined;
		if(isdefined(Param))
		{
			b_result = [[func_sort]](left[li], right[ri], Param);
		}
		else
		{
			b_result = [[func_sort]](left[li], right[ri]);
		}
		if(b_result)
		{
			result[result.size] = left[li];
			li++;
		}
		else
		{
			result[result.size] = right[ri];
			ri++;
		}
	}
	while(li < left.size)
	{
		result[result.size] = left[li];
		li++;
	}
	while(ri < right.size)
	{
		result[result.size] = right[ri];
		ri++;
	}
	return result;
}

/*
	Name: spread_all
	Namespace: Array
	Checksum: 0x69A07E96
	Offset: 0x2B50
	Size: 0x1B3
	Parameters: 7
	Flags: None
*/
function spread_all(entities, func, arg1, arg2, arg3, arg4, arg5)
{
	/#
		Assert(isdefined(entities), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(func), "Dev Block strings are not supported");
	#/
	if(IsArray(entities))
	{
		foreach(ent in entities)
		{
			util::single_thread(ent, func, arg1, arg2, arg3, arg4, arg5);
			wait(RandomFloatRange(0.06666666, 0.1333333));
		}
	}
	else
	{
		util::single_thread(entities, func, arg1, arg2, arg3, arg4, arg5);
		wait(RandomFloatRange(0.06666666, 0.1333333));
	}
}

