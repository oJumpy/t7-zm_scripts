#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_net;

#namespace namespace_5daad52;

/*
	Name: magic_box_init
	Namespace: namespace_5daad52
	Checksum: 0x43A16D54
	Offset: 0x1D0
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function magic_box_init()
{
	util::registerClientSys("box_indicator");
	level._BOX_INDICATOR_NO_LIGHTS = -1;
	level._BOX_INDICATOR_FLASH_LIGHTS_MOVING = 99;
	level._BOX_INDICATOR_FLASH_LIGHTS_FIRE_SALE = 98;
	level._box_locations = Array("start_chest", "foyer_chest", "crematorium_chest", "alleyway_chest", "control_chest", "stage_chest", "dressing_chest", "dining_chest", "theater_chest");
	level thread magic_box_update();
	level thread watch_fire_sale();
	callback::on_connect(&function_72feb26b);
}

/*
	Name: function_72feb26b
	Namespace: namespace_5daad52
	Checksum: 0x28E6571A
	Offset: 0x2D0
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_72feb26b()
{
	if(level flag::get("power_on"))
	{
		util::setClientSysState("box_indicator", get_location_from_chest_index(level.chest_index));
	}
}

/*
	Name: get_location_from_chest_index
	Namespace: namespace_5daad52
	Checksum: 0xBE7D5BF1
	Offset: 0x338
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function get_location_from_chest_index(chest_index)
{
	chest_loc = level.chests[chest_index].script_noteworthy;
	for(i = 0; i < level._box_locations.size; i++)
	{
		if(level._box_locations[i] == chest_loc)
		{
			return i;
		}
	}
	/#
		ASSERTMSG("Dev Block strings are not supported" + chest_loc);
	#/
}

/*
	Name: magic_box_update
	Namespace: namespace_5daad52
	Checksum: 0x442C0B2B
	Offset: 0x3E0
	Size: 0x15F
	Parameters: 0
	Flags: None
*/
function magic_box_update()
{
	wait(2);
	level flag::wait_till("power_on");
	box_mode = "Box Available";
	util::setClientSysState("box_indicator", get_location_from_chest_index(level.chest_index));
	while(1)
	{
		switch(box_mode)
		{
			case "Box Available":
			{
				if(level flag::get("moving_chest_now"))
				{
					util::setClientSysState("box_indicator", level._BOX_INDICATOR_FLASH_LIGHTS_MOVING);
					box_mode = "Box is Moving";
				}
				break;
			}
			case "Box is Moving":
			{
				while(level flag::get("moving_chest_now"))
				{
					wait(0.1);
				}
				util::setClientSysState("box_indicator", get_location_from_chest_index(level.chest_index));
				box_mode = "Box Available";
				break;
			}
		}
		wait(0.5);
	}
}

/*
	Name: watch_fire_sale
	Namespace: namespace_5daad52
	Checksum: 0xB5219CB
	Offset: 0x548
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function watch_fire_sale()
{
	while(1)
	{
		level waittill("powerup fire sale");
		util::setClientSysState("box_indicator", level._BOX_INDICATOR_FLASH_LIGHTS_FIRE_SALE);
		while(level.zombie_vars["zombie_powerup_fire_sale_time"] > 0)
		{
			wait(0.1);
		}
		util::setClientSysState("box_indicator", get_location_from_chest_index(level.chest_index));
	}
}

