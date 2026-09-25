#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_14b4d4ab;

/*
	Name: init
	Namespace: namespace_14b4d4ab
	Checksum: 0xDF5D7F41
	Offset: 0x218
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("world", "proptrap_downdraft_rumble", 9000, 1, "int", &function_a9e415bd, 0, 0);
	clientfield::register("toplayer", "proptrap_downdraft_blur", 9000, 1, "int", &function_fb8158d9, 0, 0);
	clientfield::register("world", "walltrap_draft_rumble", 9000, 1, "int", &function_4736704, 0, 0);
	clientfield::register("toplayer", "walltrap_draft_blur", 9000, 1, "int", &function_3abeaee0, 0, 0);
}

/*
	Name: function_a9e415bd
	Namespace: namespace_14b4d4ab
	Checksum: 0xC9D4DB6D
	Offset: 0x348
	Size: 0x2ED
	Parameters: 7
	Flags: None
*/
function function_a9e415bd(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	player = GetLocalPlayer(localClientNum);
	if(isdefined(newVal) && newVal)
	{
		if(!isdefined(player.var_69abefde))
		{
			player.var_69abefde = [];
			var_719bbcb8 = struct::get_array("s_proptrap_downdraft_rumble", "targetname");
			foreach(var_dd3351d8 in var_719bbcb8)
			{
				e_pos = util::spawn_model(localClientNum, "tag_origin", var_dd3351d8.origin, var_dd3351d8.angles);
				Array::add(player.var_69abefde, e_pos);
			}
		}
		foreach(e_pos in player.var_69abefde)
		{
			e_pos PlayRumbleOnEntity(localClientNum, "zm_island_rumble_proptrap_downdraft");
		}
	}
	else if(isdefined(player.var_69abefde))
	{
		foreach(e_pos in player.var_69abefde)
		{
			e_pos StopRumble(localClientNum, "zm_island_rumble_proptrap_downdraft");
			e_pos delete();
		}
	}
	player.var_69abefde = undefined;
}

/*
	Name: function_fb8158d9
	Namespace: namespace_14b4d4ab
	Checksum: 0xA8BEFD82
	Offset: 0x640
	Size: 0x8B
	Parameters: 7
	Flags: None
*/
function function_fb8158d9(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self thread function_24f1be38(localClientNum, "s_proptrap_downdraft_rumble");
	}
	else
	{
		self notify("hash_602aae2b");
		DisableSpeedBlur(localClientNum);
	}
}

/*
	Name: function_4736704
	Namespace: namespace_14b4d4ab
	Checksum: 0x27DAF088
	Offset: 0x6D8
	Size: 0x2ED
	Parameters: 7
	Flags: None
*/
function function_4736704(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	player = GetLocalPlayer(localClientNum);
	if(isdefined(newVal) && newVal)
	{
		if(!isdefined(player.var_d33c558c))
		{
			player.var_d33c558c = [];
			var_52928b68 = struct::get_array("s_walltrap_draft_rumble", "targetname");
			foreach(var_7f2e4e88 in var_52928b68)
			{
				e_pos = util::spawn_model(localClientNum, "tag_origin", var_7f2e4e88.origin, var_7f2e4e88.angles);
				Array::add(player.var_d33c558c, e_pos);
			}
		}
		foreach(e_pos in player.var_d33c558c)
		{
			e_pos PlayRumbleOnEntity(localClientNum, "zm_island_rumble_proptrap_downdraft");
		}
	}
	else if(isdefined(player.var_d33c558c))
	{
		foreach(e_pos in player.var_d33c558c)
		{
			e_pos StopRumble(localClientNum, "zm_island_rumble_proptrap_downdraft");
			e_pos delete();
		}
	}
	player.var_d33c558c = undefined;
}

/*
	Name: function_3abeaee0
	Namespace: namespace_14b4d4ab
	Checksum: 0x82EAEB21
	Offset: 0x9D0
	Size: 0x8B
	Parameters: 7
	Flags: None
*/
function function_3abeaee0(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self thread function_24f1be38(localClientNum, "s_walltrap_draft_rumble");
	}
	else
	{
		self notify("hash_602aae2b");
		DisableSpeedBlur(localClientNum);
	}
}

/*
	Name: function_24f1be38
	Namespace: namespace_14b4d4ab
	Checksum: 0x81875FD7
	Offset: 0xA68
	Size: 0x14F
	Parameters: 2
	Flags: None
*/
function function_24f1be38(localClientNum, str_structname)
{
	self endon("hash_602aae2b");
	self endon("death");
	var_719bbcb8 = struct::get_array(str_structname, "targetname");
	while(1)
	{
		foreach(var_dd3351d8 in var_719bbcb8)
		{
			if(isdefined(self) && DistanceSquared(self.origin, var_dd3351d8.origin) < 3600)
			{
				EnableSpeedBlur(localClientNum, 0.1, 0.5, 0.75);
				continue;
			}
			DisableSpeedBlur(localClientNum);
		}
		wait(0.5);
	}
}

