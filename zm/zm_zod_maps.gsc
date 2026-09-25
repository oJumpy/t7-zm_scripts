#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\zm_zod_quest;

#namespace namespace_9d6f65aa;

/*
	Name: init
	Namespace: namespace_9d6f65aa
	Checksum: 0x2ED6EB9E
	Offset: 0x310
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function init()
{
	thread function_ca1a937();
}

/*
	Name: function_ca1a937
	Namespace: namespace_9d6f65aa
	Checksum: 0x12300971
	Offset: 0x330
	Size: 0x431
	Parameters: 0
	Flags: None
*/
function function_ca1a937()
{
	level flag::wait_till("all_players_spawned");
	level flag::wait_till("zones_initialized");
	var_1fb56ce6 = GetEntArray("map_city", "targetname");
	foreach(var_4d3ce43f in var_1fb56ce6)
	{
		switch(var_4d3ce43f.script_string)
		{
			case "canal":
			{
				var_4d3ce43f ShowPart("tag_ur_here_canal");
				var_4d3ce43f HidePart("tag_ur_here_foot");
				var_4d3ce43f HidePart("tag_ur_here_junction");
				var_4d3ce43f HidePart("tag_ur_here_water");
				break;
			}
			case "footlight":
			{
				var_4d3ce43f HidePart("tag_ur_here_canal");
				var_4d3ce43f ShowPart("tag_ur_here_foot");
				var_4d3ce43f HidePart("tag_ur_here_junction");
				var_4d3ce43f HidePart("tag_ur_here_water");
				break;
			}
			case "junction":
			{
				var_4d3ce43f HidePart("tag_ur_here_canal");
				var_4d3ce43f HidePart("tag_ur_here_foot");
				var_4d3ce43f ShowPart("tag_ur_here_junction");
				var_4d3ce43f HidePart("tag_ur_here_water");
				break;
			}
			case "waterfront":
			{
				var_4d3ce43f HidePart("tag_ur_here_canal");
				var_4d3ce43f HidePart("tag_ur_here_foot");
				var_4d3ce43f HidePart("tag_ur_here_junction");
				var_4d3ce43f ShowPart("tag_ur_here_water");
				break;
			}
		}
		var_4d3ce43f ShowPart("tag_memento_badge");
		var_4d3ce43f ShowPart("tag_memento_belt");
		var_4d3ce43f ShowPart("tag_memento_pen");
		var_4d3ce43f ShowPart("tag_memento_wig");
		var_4d3ce43f HidePart("tag_ritual_canal");
		var_4d3ce43f HidePart("tag_ritual_foot");
		var_4d3ce43f HidePart("tag_ritual_junction");
		var_4d3ce43f HidePart("tag_ritual_water");
		var_4d3ce43f thread function_87325d74();
	}
}

/*
	Name: function_87325d74
	Namespace: namespace_9d6f65aa
	Checksum: 0x71FEB0C0
	Offset: 0x770
	Size: 0x31F
	Parameters: 0
	Flags: None
*/
function function_87325d74()
{
	while(1)
	{
		if(level flag::get("memento_detective_found"))
		{
			self HidePart("tag_memento_badge");
		}
		if(level flag::get("memento_boxer_found"))
		{
			self HidePart("tag_memento_belt");
		}
		if(level flag::get("memento_magician_found"))
		{
			self HidePart("tag_memento_pen");
		}
		if(level flag::get("memento_femme_found"))
		{
			self HidePart("tag_memento_wig");
		}
		if(level flag::get("ritual_detective_complete"))
		{
			self ShowPart("tag_ritual_canal");
		}
		if(level flag::get("ritual_boxer_complete"))
		{
			self ShowPart("tag_ritual_water");
		}
		if(level flag::get("ritual_magician_complete"))
		{
			self ShowPart("tag_ritual_junction");
		}
		if(level flag::get("ritual_femme_complete"))
		{
			self ShowPart("tag_ritual_foot");
		}
		if(level flag::get("memento_detective_found") && level flag::get("memento_boxer_found") && level flag::get("memento_magician_found") && level flag::get("memento_femme_found") && level flag::get("ritual_detective_complete") && level flag::get("ritual_boxer_complete") && level flag::get("ritual_magician_complete") && level flag::get("ritual_femme_complete"))
		{
			break;
		}
		wait(0.1);
	}
}

