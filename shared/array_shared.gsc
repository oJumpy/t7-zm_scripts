#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

#namespace Array;

/*
	Name: filter
	Namespace: Array
	Checksum: 0x48F2EA9E
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
	Name: remove_dead
	Namespace: Array
	Checksum: 0xAE5F9937
	Offset: 0x2C8
	Size: 0x39
	Parameters: 2
	Flags: None
*/
function remove_dead(Array, b_keep_keys)
{
	return filter(Array, b_keep_keys, &_filter_dead);
}

/*
	Name: _filter_undefined
	Namespace: Array
	Checksum: 0xCA3CBB34
	Offset: 0x310
	Size: 0x11
	Parameters: 1
	Flags: None
*/
function _filter_undefined(VAL)
{
	return isdefined(VAL);
}

/*
	Name: remove_undefined
	Namespace: Array
	Checksum: 0x1C8EB978
	Offset: 0x330
	Size: 0x39
	Parameters: 2
	Flags: None
*/
function remove_undefined(Array, b_keep_keys)
{
	return filter(Array, b_keep_keys, &_filter_undefined);
}

/*
	Name: CleanUp
	Namespace: Array
	Checksum: 0xE5050BA
	Offset: 0x378
	Size: 0x14D
	Parameters: 2
	Flags: None
*/
function CleanUp(Array, b_keep_empty_arrays)
{
	if(!isdefined(b_keep_empty_arrays))
	{
		b_keep_empty_arrays = 0;
	}
	a_keys = getArrayKeys(Array);
	for(i = a_keys.size - 1; i >= 0; i--)
	{
		key = a_keys[i];
		if(IsArray(Array[key]) && Array[key].size)
		{
			CleanUp(Array[key], b_keep_empty_arrays);
			continue;
		}
		if(!isdefined(Array[key]) || (!b_keep_empty_arrays && IsArray(Array[key]) && !Array[key].size))
		{
			ArrayRemoveIndex(Array, key);
		}
	}
}

/*
	Name: filter_classname
	Namespace: Array
	Checksum: 0xFD64D624
	Offset: 0x4D0
	Size: 0x49
	Parameters: 3
	Flags: None
*/
function filter_classname(Array, b_keep_keys, str_classname)
{
	return filter(Array, b_keep_keys, &_filter_classname, str_classname);
}

/*
	Name: get_touching
	Namespace: Array
	Checksum: 0xD43D8948
	Offset: 0x528
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
	Checksum: 0x2D00F0BB
	Offset: 0x570
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
	Checksum: 0x38F99515
	Offset: 0x668
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
	Checksum: 0xFC87ACD1
	Offset: 0x770
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
	Checksum: 0xBFC1EDA4
	Offset: 0x808
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
	Checksum: 0xC4372881
	Offset: 0xCE0
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
	Checksum: 0x3C895DC1
	Offset: 0xE58
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
	Checksum: 0xC2768DF0
	Offset: 0x1330
	Size: 0xEF
	Parameters: 2
	Flags: None
*/
function exclude(Array, array_exclude)
{
	newArray = Array;
	if(IsArray(array_exclude))
	{
		foreach(exclude_item in array_exclude)
		{
			ArrayRemoveValue(newArray, exclude_item);
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
	Checksum: 0x416F7F3A
	Offset: 0x1428
	Size: 0x71
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
}

/*
	Name: add_sorted
	Namespace: Array
	Checksum: 0xEA169CE6
	Offset: 0x14A8
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
	Checksum: 0xF8DCB179
	Offset: 0x1588
	Size: 0x16D
	Parameters: 3
	Flags: None
*/
function wait_till(Array, notifies, n_timeout)
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
			ent thread util::timeout(n_timeout, &util::_waitlogic, s_tracker, notifies);
		}
	}
	if(s_tracker._wait_count > 0)
	{
		s_tracker waittill("waitlogic_finished");
	}
}

/*
	Name: wait_till_match
	Namespace: Array
	Checksum: 0xF010E87B
	Offset: 0x1700
	Size: 0x1B5
	Parameters: 4
	Flags: None
*/
function wait_till_match(Array, str_notify, str_match, n_timeout)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon("timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	s_tracker = spawnstruct();
	s_tracker._array_wait_count = 0;
	foreach(ent in Array)
	{
		if(isdefined(ent))
		{
			s_tracker._array_wait_count++;
			ent thread util::timeout(n_timeout, &_waitlogic_match, s_tracker, str_notify, str_match);
			ent thread util::timeout(n_timeout, &_waitlogic_death, s_tracker);
		}
	}
	if(s_tracker._array_wait_count > 0)
	{
		s_tracker waittill("array_wait");
	}
}

/*
	Name: _waitlogic_match
	Namespace: Array
	Checksum: 0xC6A73A2A
	Offset: 0x18C0
	Size: 0x4B
	Parameters: 3
	Flags: None
*/
function _waitlogic_match(s_tracker, str_notify, str_match)
{
	self endon("death");
	self waittillmatch(str_notify);
	update_waitlogic_tracker(s_tracker);
}

/*
	Name: _waitlogic_death
	Namespace: Array
	Checksum: 0xC0595426
	Offset: 0x1918
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function _waitlogic_death(s_tracker)
{
	self waittill("death");
	update_waitlogic_tracker(s_tracker);
}

/*
	Name: update_waitlogic_tracker
	Namespace: Array
	Checksum: 0x4ABF1116
	Offset: 0x1950
	Size: 0x3F
	Parameters: 1
	Flags: None
*/
function update_waitlogic_tracker(s_tracker)
{
	s_tracker._array_wait_count--;
	if(s_tracker._array_wait_count == 0)
	{
		s_tracker notify("array_wait");
	}
}

/*
	Name: flag_wait
	Namespace: Array
	Checksum: 0x99A39A50
	Offset: 0x1998
	Size: 0xCB
	Parameters: 2
	Flags: None
*/
function flag_wait(Array, str_flag)
{
	do
	{
		recheck = 0;
		for(i = 0; i < Array.size; i++)
		{
			ent = Array[i];
			if(isdefined(ent) && !ent flag::get(str_flag))
			{
				ent util::waittill_either("death", str_flag);
				recheck = 1;
				break;
			}
		}
	}
	while(!recheck);
}

/*
	Name: flagsys_wait
	Namespace: Array
	Checksum: 0x838C7C25
	Offset: 0x1A70
	Size: 0xCB
	Parameters: 2
	Flags: None
*/
function flagsys_wait(Array, str_flag)
{
	do
	{
		recheck = 0;
		for(i = 0; i < Array.size; i++)
		{
			ent = Array[i];
			if(isdefined(ent) && !ent flagsys::get(str_flag))
			{
				ent util::waittill_either("death", str_flag);
				recheck = 1;
				break;
			}
		}
	}
	while(!recheck);
}

/*
	Name: flagsys_wait_any_flag
	Namespace: Array
	Checksum: 0x46708E91
	Offset: 0x1B48
	Size: 0x14F
	Parameters: 2
	Flags: 32
*/
function flagsys_wait_any_flag(Array, vararg)
{
	do
	{
		recheck = 0;
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
					recheck = 1;
				}
			}
		}
	}
	while(!recheck);
}

/*
	Name: flagsys_wait_any
	Namespace: Array
	Checksum: 0x8DC809C9
	Offset: 0x1CA0
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function flagsys_wait_any(Array, str_flag)
{
	foreach(ent in Array)
	{
		if(ent flagsys::get(str_flag))
		{
			return ent;
		}
	}
	wait_any(Array, str_flag);
}

/*
	Name: flag_wait_clear
	Namespace: Array
	Checksum: 0x117CAEDC
	Offset: 0x1D68
	Size: 0x9D
	Parameters: 2
	Flags: None
*/
function flag_wait_clear(Array, str_flag)
{
	do
	{
		recheck = 0;
		for(i = 0; i < Array.size; i++)
		{
			ent = Array[i];
			if(ent flag::get(str_flag))
			{
				ent waittill(str_flag);
				recheck = 1;
			}
		}
	}
	while(!recheck);
}

/*
	Name: flagsys_wait_clear
	Namespace: Array
	Checksum: 0x629872E9
	Offset: 0x1E10
	Size: 0x10D
	Parameters: 3
	Flags: None
*/
function flagsys_wait_clear(Array, str_flag, n_timeout)
{
	if(isdefined(n_timeout))
	{
		__s = spawnstruct();
		__s endon("timeout");
		__s util::delay_notify(n_timeout, "timeout");
	}
	do
	{
		recheck = 0;
		for(i = 0; i < Array.size; i++)
		{
			ent = Array[i];
			if(isdefined(ent) && ent flagsys::get(str_flag))
			{
				ent waittill(str_flag);
				recheck = 1;
			}
		}
	}
	while(!recheck);
}

/*
	Name: wait_any
	Namespace: Array
	Checksum: 0xFE2DF630
	Offset: 0x1F28
	Size: 0x163
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
	foreach(ent in Array)
	{
		if(isdefined(ent))
		{
			level thread util::timeout(n_timeout, &_waitlogic2, s_tracker, ent, msg);
		}
	}
	s_tracker endon("array_wait");
	wait_till(Array, "death");
}

/*
	Name: _waitlogic2
	Namespace: Array
	Checksum: 0x9DFD6D35
	Offset: 0x2098
	Size: 0x6B
	Parameters: 3
	Flags: None
*/
function _waitlogic2(s_tracker, ent, msg)
{
	s_tracker endon("array_wait");
	if(msg != "death")
	{
		ent endon("death");
	}
	ent util::waittill_any_array(msg);
	s_tracker notify("array_wait");
}

/*
	Name: flag_wait_any
	Namespace: Array
	Checksum: 0x633AD1F
	Offset: 0x2110
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
	Checksum: 0xC1ADB6A4
	Offset: 0x21E8
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function random(Array)
{
	if(Array.size > 0)
	{
		keys = getArrayKeys(Array);
		return Array[keys[RandomInt(keys.size)]];
	}
}

/*
	Name: randomize
	Namespace: Array
	Checksum: 0xB435E2CE
	Offset: 0x2258
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
	Name: clamp_size
	Namespace: Array
	Checksum: 0x6D15F724
	Offset: 0x2300
	Size: 0x65
	Parameters: 2
	Flags: None
*/
function clamp_size(Array, n_size)
{
	a_ret = [];
	for(i = 0; i < n_size; i++)
	{
		a_ret[i] = Array[i];
	}
	return a_ret;
}

/*
	Name: reverse
	Namespace: Array
	Checksum: 0x64B3717F
	Offset: 0x2370
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
	Checksum: 0x1D20894A
	Offset: 0x23E0
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
	Checksum: 0xCBCAADA3
	Offset: 0x2498
	Size: 0x59
	Parameters: 3
	Flags: None
*/
function swap(Array, index1, index2)
{
	temp = Array[index1];
	Array[index1] = Array[index2];
	Array[index2] = temp;
}

/*
	Name: pop
	Namespace: Array
	Checksum: 0x54E5164A
	Offset: 0x2500
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
	Checksum: 0x97E768CA
	Offset: 0x25D0
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
	Checksum: 0xA246B8C
	Offset: 0x2660
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
	Checksum: 0xB3701521
	Offset: 0x2770
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
	Checksum: 0x73F13020
	Offset: 0x27B0
	Size: 0x3B
	Parameters: 3
	Flags: None
*/
function get_closest(org, Array, dist)
{
	/#
		Assert(0, "Dev Block strings are not supported");
	#/
}

/*
	Name: get_farthest
	Namespace: Array
	Checksum: 0x2803DF89
	Offset: 0x27F8
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
	Checksum: 0xF131CA05
	Offset: 0x2850
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
	Checksum: 0xC1C365ED
	Offset: 0x2878
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
	Checksum: 0x1D0B4F1C
	Offset: 0x28A0
	Size: 0xC3
	Parameters: 5
	Flags: None
*/
function get_all_farthest(org, Array, a_exclude, n_max, n_maxdist)
{
	if(!isdefined(n_max))
	{
		n_max = Array.size;
	}
	a_ret = exclude(Array, a_exclude);
	if(isdefined(n_maxdist))
	{
		a_ret = ArraySort(a_ret, org, 0, n_max, n_maxdist);
	}
	else
	{
		a_ret = ArraySort(a_ret, org, 0, n_max);
	}
	return a_ret;
}

/*
	Name: get_all_closest
	Namespace: Array
	Checksum: 0x388139B5
	Offset: 0x2970
	Size: 0xCB
	Parameters: 5
	Flags: None
*/
function get_all_closest(org, Array, a_exclude, n_max, n_maxdist)
{
	if(!isdefined(n_max))
	{
		n_max = Array.size;
	}
	a_ret = exclude(Array, a_exclude);
	if(isdefined(n_maxdist))
	{
		a_ret = ArraySort(a_ret, org, 1, n_max, n_maxdist);
	}
	else
	{
		a_ret = ArraySort(a_ret, org, 1, n_max);
	}
	return a_ret;
}

/*
	Name: alphabetize
	Namespace: Array
	Checksum: 0x1874D73B
	Offset: 0x2A48
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
	Checksum: 0x2FA18433
	Offset: 0x2A78
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
	Checksum: 0x8FCAA61B
	Offset: 0x2AD0
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
	Checksum: 0x602F5FB4
	Offset: 0x2B18
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
	Checksum: 0x7D1D00FF
	Offset: 0x2B70
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
	Checksum: 0xCE74A113
	Offset: 0x2BE0
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
	Checksum: 0x88388D37
	Offset: 0x2DD0
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
	Name: insertion_sort
	Namespace: Array
	Checksum: 0x623BC17E
	Offset: 0x2F70
	Size: 0xB9
	Parameters: 3
	Flags: None
*/
function insertion_sort(a, compareFunc, VAL)
{
	if(!isdefined(a))
	{
		a = [];
		a[0] = VAL;
		return;
	}
	for(i = 0; i < a.size; i++)
	{
		if([[compareFunc]](a[i], VAL) <= 0)
		{
			ArrayInsert(a, VAL, i);
			return;
		}
	}
	a[a.size] = VAL;
}

/*
	Name: spread_all
	Namespace: Array
	Checksum: 0xDC8831E9
	Offset: 0x3038
	Size: 0x1BB
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
			if(isdefined(ent))
			{
				util::single_thread(ent, func, arg1, arg2, arg3, arg4, arg5);
			}
			wait(RandomFloatRange(0.06666666, 0.1333333));
		}
	}
	else
	{
		util::single_thread(entities, func, arg1, arg2, arg3, arg4, arg5);
		wait(RandomFloatRange(0.06666666, 0.1333333));
	}
}

/*
	Name: wait_till_touching
	Namespace: Array
	Checksum: 0x85A7D872
	Offset: 0x3200
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function wait_till_touching(a_ents, e_volume)
{
	while(!is_touching(a_ents, e_volume))
	{
		wait(0.05);
	}
}

/*
	Name: is_touching
	Namespace: Array
	Checksum: 0xAD2808CD
	Offset: 0x3248
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function is_touching(a_ents, e_volume)
{
	foreach(e_ent in a_ents)
	{
		if(!e_ent istouching(e_volume))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: contains
	Namespace: Array
	Checksum: 0xFB7E7375
	Offset: 0x32F8
	Size: 0xBD
	Parameters: 2
	Flags: None
*/
function contains(var_8aeaac2c, value)
{
	if(IsArray(var_8aeaac2c))
	{
		foreach(element in var_8aeaac2c)
		{
			if(element === value)
			{
				return 1;
			}
		}
		return 0;
	}
	return var_8aeaac2c === value;
}

/*
	Name: _filter_dead
	Namespace: Array
	Checksum: 0x1E69047E
	Offset: 0x33C0
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function _filter_dead(VAL)
{
	return isalive(VAL);
}

/*
	Name: _filter_classname
	Namespace: Array
	Checksum: 0xDF98B053
	Offset: 0x33F0
	Size: 0x31
	Parameters: 2
	Flags: None
*/
function _filter_classname(VAL, arg)
{
	return IsSubStr(VAL.classname, arg);
}

/*
	Name: function_1e686f36
	Namespace: Array
	Checksum: 0x807F5242
	Offset: 0x3430
	Size: 0x39
	Parameters: 2
	Flags: None
*/
function function_1e686f36(Array, compare_func)
{
	return function_8c158a48(Array, 0, Array.size - 1, compare_func);
}

/*
	Name: function_8c158a48
	Namespace: Array
	Checksum: 0x866A62F6
	Offset: 0x3478
	Size: 0x1DD
	Parameters: 4
	Flags: None
*/
function function_8c158a48(Array, start, end, compare_func)
{
	i = start;
	K = end;
	if(!isdefined(compare_func))
	{
		compare_func = &function_1cde8a52;
	}
	if(end - start >= 1)
	{
		pivot = Array[start];
		while(K > i)
		{
			while([[compare_func]](Array[i], pivot) && i <= end && K > i)
			{
				i++;
			}
			while(![[compare_func]](Array[K], pivot) && K >= start && K >= i)
			{
				K--;
			}
			if(K > i)
			{
				swap(Array, i, K);
			}
		}
		swap(Array, start, K);
		Array = function_8c158a48(Array, start, K - 1, compare_func);
		Array = function_8c158a48(Array, K + 1, end, compare_func);
	}
	else
	{
		return Array;
	}
	return Array;
}

/*
	Name: function_1cde8a52
	Namespace: Array
	Checksum: 0xB0A4B4AB
	Offset: 0x3660
	Size: 0x1D
	Parameters: 2
	Flags: None
*/
function function_1cde8a52(left, right)
{
	return left <= right;
}

