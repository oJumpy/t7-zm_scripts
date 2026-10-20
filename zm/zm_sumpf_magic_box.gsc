#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\zm_sumpf_perks;
#using scripts\zm\zm_sumpf_trap_pendulum;
#using scripts\zm\zm_sumpf_zipline;

#namespace zm_sumpf_magic_box;

/*
	Name: magic_box_init
	Namespace: zm_sumpf_magic_box
	Checksum: 0xD83F6499
	Offset: 0x2C8
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function magic_box_init()
{
	level thread waitfor_flag_open_chest_location("nw_magic_box");
	level thread waitfor_flag_open_chest_location("ne_magic_box");
	level thread waitfor_flag_open_chest_location("se_magic_box");
	level thread waitfor_flag_open_chest_location("sw_magic_box");
	level thread waitfor_flag_open_chest_location("start_zombie_round_logic");
	level.pandora_fx_func = &swamp_pandora_fx_func;
}

/*
	Name: swamp_pandora_fx_func
	Namespace: zm_sumpf_magic_box
	Checksum: 0x85698F57
	Offset: 0x390
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function swamp_pandora_fx_func()
{
	self.pandora_light = spawn("script_model", self.origin);
	self.pandora_light.angles = self.angles + VectorScale((-1, -1, 0), 90);
	self.pandora_light SetModel("tag_origin");
	if(self.script_noteworthy == "start_chest")
	{
		PlayFXOnTag(level._effect["lght_marker"], self.pandora_light, "tag_origin");
	}
	else
	{
		PlayFXOnTag(level._effect["lght_marker_old"], self.pandora_light, "tag_origin");
	}
}

/*
	Name: waitfor_flag_open_chest_location
	Namespace: zm_sumpf_magic_box
	Checksum: 0xDC865184
	Offset: 0x490
	Size: 0x2F9
	Parameters: 1
	Flags: None
*/
function waitfor_flag_open_chest_location(which)
{
	wait(3);
	switch(which)
	{
		case "nw_magic_box":
		{
			setup_pendulum_trap();
			break;
		}
		case "ne_magic_box":
		{
			level flag::wait_till("ne_magic_box");
			level thread zm_sumpf_zipline::initZipline();
			break;
		}
		case "se_magic_box":
		{
			level flag::wait_till("se_magic_box");
			break;
		}
		case "sw_magic_box":
		{
			level flag::wait_till("sw_magic_box");
			break;
		}
		case "start_zombie_round_logic":
		{
			level flag::wait_till("start_zombie_round_logic");
			break;
		}
		case default:
		{
			return;
		}
	}
	if(isdefined(level.randomize_perks) && level.randomize_perks == 0)
	{
		zm_sumpf_perks::randomize_vending_machines();
		level.vending_model_info = [];
		level.vending_model_info[level.vending_model_info.size] = "p7_zm_vending_jugg";
		level.vending_model_info[level.vending_model_info.size] = "p7_zm_vending_doubletap2";
		level.vending_model_info[level.vending_model_info.size] = "p7_zm_vending_revive";
		level.vending_model_info[level.vending_model_info.size] = "p7_zm_vending_sleight";
		level.vending_model_info[level.vending_model_info.size] = "p7_zm_vending_three_gun";
		level.randomize_perks = 1;
	}
	switch(which)
	{
		case "nw_magic_box":
		{
			level flag::wait_till("northwest_building_unlocked");
			zm_sumpf_perks::vending_randomization_effect(0);
			break;
		}
		case "ne_magic_box":
		{
			level flag::wait_till("northeast_building_unlocked");
			zm_sumpf_perks::vending_randomization_effect(1);
			break;
		}
		case "se_magic_box":
		{
			level flag::wait_till("southeast_building_unlocked");
			zm_sumpf_perks::vending_randomization_effect(2);
			break;
		}
		case "sw_magic_box":
		{
			level flag::wait_till("southwest_building_unlocked");
			zm_sumpf_perks::vending_randomization_effect(3);
			break;
		}
		case "start_zombie_round_logic":
		{
			break;
		}
	}
}

/*
	Name: setup_pendulum_trap
	Namespace: zm_sumpf_magic_box
	Checksum: 0x1AA1F55A
	Offset: 0x798
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function setup_pendulum_trap()
{
	penBuyTrigger = GetEntArray("pendulum_buy_trigger", "targetname");
	foreach(t_buy_trig in penBuyTrigger)
	{
		t_buy_trig setHintString(&"ZOMBIE_CLEAR_DEBRIS");
		t_buy_trig setcursorhint("HINT_NOICON");
	}
	level flag::wait_till("nw_magic_box");
	zm_sumpf_trap_pendulum::initPendulumTrap();
	Array::thread_all(penBuyTrigger, &zm_sumpf_trap_pendulum::penThink);
}

