#namespace character;

/*
	Name: setModelFromArray
	Namespace: character
	Checksum: 0xB8CDA92D
	Offset: 0xD0
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function setModelFromArray(a)
{
	self SetModel(a[RandomInt(a.size)]);
}

/*
	Name: randomElement
	Namespace: character
	Checksum: 0x5D8097C3
	Offset: 0x118
	Size: 0x27
	Parameters: 1
	Flags: None
*/
function randomElement(a)
{
	return a[RandomInt(a.size)];
}

/*
	Name: attachFromArray
	Namespace: character
	Checksum: 0xDC69E339
	Offset: 0x148
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function attachFromArray(a)
{
	self Attach(randomElement(a), "", 1);
}

/*
	Name: function_b9c80ba2
	Namespace: character
	Checksum: 0xA087E372
	Offset: 0x198
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_b9c80ba2()
{
	self DetachAll();
	oldGunHand = self.anim_gunHand;
	if(!isdefined(oldGunHand))
	{
		return;
	}
	self.anim_gunHand = "none";
	self [[anim.PutGunInHand]](oldGunHand);
}

/*
	Name: save
	Namespace: character
	Checksum: 0xC734A501
	Offset: 0x208
	Size: 0x1A7
	Parameters: 0
	Flags: None
*/
function save()
{
	info["gunHand"] = self.anim_gunHand;
	info["gunInHand"] = self.anim_gunInHand;
	info["model"] = self.model;
	info["hatModel"] = self.hatModel;
	info["gearModel"] = self.gearModel;
	if(isdefined(self.name))
	{
		info["name"] = self.name;
		/#
			println("Dev Block strings are not supported", self.name);
		#/
	}
	else
	{
		println("Dev Block strings are not supported");
	}
	/#
	#/
	attachSize = self getattachsize();
	for(i = 0; i < attachSize; i++)
	{
		info["attach"][i]["model"] = self getAttachModelName(i);
		info["attach"][i]["tag"] = self getAttachTagName(i);
	}
	return info;
}

/*
	Name: load
	Namespace: character
	Checksum: 0x7B4ECA7
	Offset: 0x3B8
	Size: 0x195
	Parameters: 1
	Flags: None
*/
function load(info)
{
	self DetachAll();
	self.anim_gunHand = info["gunHand"];
	self.anim_gunInHand = info["gunInHand"];
	self SetModel(info["model"]);
	self.hatModel = info["hatModel"];
	self.gearModel = info["gearModel"];
	if(isdefined(info["name"]))
	{
		self.name = info["name"];
		/#
			println("Dev Block strings are not supported", self.name);
		#/
	}
	else
	{
		println("Dev Block strings are not supported");
	}
	/#
	#/
	attachInfo = info["attach"];
	attachSize = attachInfo.size;
	for(i = 0; i < attachSize; i++)
	{
		self Attach(attachInfo[i]["model"], attachInfo[i]["tag"]);
	}
}

/*
	Name: get_random_character
	Namespace: character
	Checksum: 0xFFCA34A7
	Offset: 0x558
	Size: 0x1F1
	Parameters: 1
	Flags: None
*/
function get_random_character(amount)
{
	self_info = StrTok(self.classname, "_");
	if(self_info.size <= 2)
	{
		return RandomInt(amount);
	}
	group = "auto";
	index = undefined;
	prefix = self_info[2];
	if(isdefined(self.script_char_index))
	{
		index = self.script_char_index;
	}
	if(isdefined(self.script_char_group))
	{
		type = "grouped";
		group = "group_" + self.script_char_group;
	}
	if(!isdefined(level.character_index_cache))
	{
		level.character_index_cache = [];
	}
	if(!isdefined(level.character_index_cache[prefix]))
	{
		level.character_index_cache[prefix] = [];
	}
	if(!isdefined(level.character_index_cache[prefix][group]))
	{
		initialize_character_group(prefix, group, amount);
	}
	if(!isdefined(index))
	{
		index = get_least_used_index(prefix, group);
		if(!isdefined(index))
		{
		}
	}
	for(index = RandomInt(5000); index >= amount;  = RandomInt(5000))
	{
	}
	level.character_index_cache[prefix][group][index]++;
	return index;
}

/*
	Name: get_least_used_index
	Namespace: character
	Checksum: 0xD768CA27
	Offset: 0x758
	Size: 0x151
	Parameters: 2
	Flags: None
*/
function get_least_used_index(prefix, group)
{
	lowest_indices = [];
	lowest_use = level.character_index_cache[prefix][group][0];
	lowest_indices[0] = 0;
	for(i = 1; i < level.character_index_cache[prefix][group].size; i++)
	{
		if(level.character_index_cache[prefix][group][i] > lowest_use)
		{
			continue;
		}
		if(level.character_index_cache[prefix][group][i] < lowest_use)
		{
			lowest_indices = [];
			lowest_use = level.character_index_cache[prefix][group][i];
		}
		lowest_indices[lowest_indices.size] = i;
	}
	/#
		Assert(lowest_indices.size, "Dev Block strings are not supported");
	#/
	return random(lowest_indices);
}

/*
	Name: initialize_character_group
	Namespace: character
	Checksum: 0xD3155A34
	Offset: 0x8B8
	Size: 0x5F
	Parameters: 3
	Flags: None
*/
function initialize_character_group(prefix, group, amount)
{
	for(i = 0; i < amount; i++)
	{
		level.character_index_cache[prefix][group][i] = 0;
	}
}

/*
	Name: random
	Namespace: character
	Checksum: 0x4B076887
	Offset: 0x920
	Size: 0x55
	Parameters: 1
	Flags: None
*/
function random(Array)
{
	keys = getArrayKeys(Array);
	return Array[keys[RandomInt(keys.size)]];
}

