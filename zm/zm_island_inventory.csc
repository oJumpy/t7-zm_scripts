#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_utility;

#namespace namespace_48e6dffb;

/*
	Name: init
	Namespace: namespace_48e6dffb
	Checksum: 0x8B6AE55A
	Offset: 0x398
	Size: 0x643
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("clientuimodel", "zmInventory.widget_bucket_parts", 9000, 1, "int", undefined, 0, 0);
	clientfield::register("toplayer", "bucket_held", 9000, GetMinBitCountForNum(2), "int", &zm_utility::setInventoryUIModels, 0, 0);
	clientfield::register("toplayer", "bucket_bucket_type", 9000, GetMinBitCountForNum(2), "int", &zm_utility::setInventoryUIModels, 0, 0);
	clientfield::register("toplayer", "bucket_bucket_water_type", 9000, GetMinBitCountForNum(3), "int", &zm_utility::setInventoryUIModels, 0, 1);
	clientfield::register("toplayer", "bucket_bucket_water_level", 9000, GetMinBitCountForNum(3), "int", &zm_utility::setInventoryUIModels, 0, 1);
	clientfield::register("clientuimodel", "zmInventory.widget_skull_parts", 9000, 1, "int", undefined, 0, 0);
	clientfield::register("toplayer", "skull_skull_state", 9000, GetMinBitCountForNum(3), "int", &zm_utility::setInventoryUIModels, 0, 1);
	clientfield::register("toplayer", "skull_skull_type", 9000, GetMinBitCountForNum(3), "int", &zm_utility::setInventoryUIModels, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_gasmask_parts", 9000, 1, "int", undefined, 0, 0);
	clientfield::register("toplayer", "gaskmask_part_visor", 9000, 1, "int", &zm_utility::setSharedInventoryUIModels, 0, 0);
	clientfield::register("toplayer", "gaskmask_part_strap", 9000, 1, "int", &zm_utility::setSharedInventoryUIModels, 0, 0);
	clientfield::register("toplayer", "gaskmask_part_filter", 9000, 1, "int", &zm_utility::setSharedInventoryUIModels, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.gaskmask_gasmask_active", 9000, 1, "int", undefined, 0, 0);
	clientfield::register("toplayer", "gaskmask_gasmask_progress", 9000, GetMinBitCountForNum(10), "int", &function_67b53ed4, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_machinetools_parts", 9000, 1, "int", undefined, 0, 0);
	clientfield::register("toplayer", "valveone_part_lever", 9000, 1, "int", &zm_utility::setSharedInventoryUIModels, 0, 0);
	clientfield::register("toplayer", "valvetwo_part_lever", 9000, 1, "int", &zm_utility::setSharedInventoryUIModels, 0, 0);
	clientfield::register("toplayer", "valvethree_part_lever", 9000, 1, "int", &zm_utility::setSharedInventoryUIModels, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_wonderweapon_parts", 9000, 1, "int", undefined, 0, 0);
	clientfield::register("toplayer", "wonderweapon_part_wwi", 9000, 1, "int", &zm_utility::setSharedInventoryUIModels, 0, 0);
	clientfield::register("toplayer", "wonderweapon_part_wwii", 9000, 1, "int", &zm_utility::setSharedInventoryUIModels, 0, 0);
	clientfield::register("toplayer", "wonderweapon_part_wwiii", 9000, 1, "int", &zm_utility::setSharedInventoryUIModels, 0, 0);
}

/*
	Name: main
	Namespace: namespace_48e6dffb
	Checksum: 0x99EC1590
	Offset: 0x9E8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function main()
{
}

/*
	Name: function_67b53ed4
	Namespace: namespace_48e6dffb
	Checksum: 0x7F908EA1
	Offset: 0x9F8
	Size: 0x18B
	Parameters: 7
	Flags: None
*/
function function_67b53ed4(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(self.var_b6689566))
	{
		self.var_b6689566 = CreateUIModel(GetUIModelForController(localClientNum), "zmInventory.gaskmask_gasmask_progress");
	}
	self.var_7d73c1cd = newVal / 10;
	self.var_7d73c1cd = math::clamp(self.var_7d73c1cd, 0, 1);
	if(isdefined(self.var_b6689566))
	{
		if(self.var_7d73c1cd == 1)
		{
			self.var_1abec487 = 0;
			self thread function_63119d2(self.var_b6689566, self.var_1abec487, self.var_7d73c1cd);
			self.var_1abec487 = self.var_7d73c1cd;
		}
		else if(!isdefined(self.var_1abec487))
		{
			self.var_1abec487 = self.var_7d73c1cd + 0.1;
		}
		self thread function_63119d2(self.var_b6689566, self.var_1abec487, self.var_7d73c1cd);
		self.var_1abec487 = self.var_7d73c1cd;
	}
}

/*
	Name: function_63119d2
	Namespace: namespace_48e6dffb
	Checksum: 0x26C3EF99
	Offset: 0xB90
	Size: 0xFF
	Parameters: 3
	Flags: None
*/
function function_63119d2(var_1b778cf0, var_6e653641, var_ee3cd374)
{
	self endon("death");
	self notify("hash_63119d2");
	self endon("hash_63119d2");
	n_start_time = GetRealTime();
	var_1c9f31e1 = 0;
	while(var_1c9f31e1 <= 1)
	{
		var_1c9f31e1 = GetRealTime() - n_start_time / 1000;
		var_9b20c5f5 = LerpFloat(var_6e653641, var_ee3cd374, var_1c9f31e1);
		SetUIModelValue(var_1b778cf0, var_9b20c5f5);
		wait(0.016);
	}
}

