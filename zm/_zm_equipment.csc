#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace zm_equipment;

/*
	Name: __init__sytem__
	Namespace: zm_equipment
	Checksum: 0x314F8B
	Offset: 0x108
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_equipment", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_equipment
	Checksum: 0x33123316
	Offset: 0x148
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._equip_activated_callbacks = [];
	level.buildable_piece_count = 24;
	if(!(isdefined(level._no_equipment_activated_clientfield) && level._no_equipment_activated_clientfield))
	{
		clientfield::register("scriptmover", "equipment_activated", 1, 4, "int", &equipment_activated_clientfield_cb, 1, 0);
	}
}

/*
	Name: add_equip_activated_callback_override
	Namespace: zm_equipment
	Checksum: 0xD8D48200
	Offset: 0x1D0
	Size: 0x25
	Parameters: 2
	Flags: None
*/
function add_equip_activated_callback_override(model, func)
{
	level._equip_activated_callbacks[model] = func;
}

/*
	Name: equipment_activated_clientfield_cb
	Namespace: zm_equipment
	Checksum: 0x3110322E
	Offset: 0x200
	Size: 0x139
	Parameters: 7
	Flags: None
*/
function equipment_activated_clientfield_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.model) && isdefined(level._equip_activated_callbacks[self.model]))
	{
		[[level._equip_activated_callbacks[self.model]]](localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
	}
	if(!newVal)
	{
		if(isdefined(self._equipment_activated_fx))
		{
			for(i = 0; i < self._equipment_activated_fx.size; i++)
			{
				for(j = 0; j < self._equipment_activated_fx[i].size; j++)
				{
					deletefx(i, self._equipment_activated_fx[i][j]);
				}
			}
			self._equipment_activated_fx = undefined;
		}
	}
}

/*
	Name: play_fx_for_all_clients
	Namespace: zm_equipment
	Checksum: 0x7593F261
	Offset: 0x348
	Size: 0x2A5
	Parameters: 4
	Flags: None
*/
function play_fx_for_all_clients(FX, tag, storeHandles, FORWARD)
{
	if(!isdefined(storeHandles))
	{
		storeHandles = 0;
	}
	if(!isdefined(FORWARD))
	{
		FORWARD = undefined;
	}
	numLocalPlayers = GetLocalPlayers().size;
	if(!isdefined(self._equipment_activated_fx))
	{
		self._equipment_activated_fx = [];
		for(i = 0; i < numLocalPlayers; i++)
		{
			self._equipment_activated_fx[i] = [];
		}
	}
	else if(isdefined(tag))
	{
		for(i = 0; i < numLocalPlayers; i++)
		{
			if(storeHandles)
			{
				self._equipment_activated_fx[i][self._equipment_activated_fx[i].size] = PlayFXOnTag(i, FX, self, tag);
				continue;
			}
			self_for_client = GetEntByNum(i, self GetEntityNumber());
			if(isdefined(self_for_client))
			{
				PlayFXOnTag(i, FX, self_for_client, tag);
			}
		}
		break;
	}
	for(i = 0; i < numLocalPlayers; i++)
	{
		if(storeHandles)
		{
			if(isdefined(FORWARD))
			{
				self._equipment_activated_fx[i][self._equipment_activated_fx[i].size] = playFX(i, FX, self.origin, FORWARD);
			}
			else
			{
				self._equipment_activated_fx[i][self._equipment_activated_fx[i].size] = playFX(i, FX, self.origin);
			}
			continue;
		}
		if(isdefined(FORWARD))
		{
			playFX(i, FX, self.origin, FORWARD);
			continue;
		}
		playFX(i, FX, self.origin);
	}
}

/*
	Name: is_included
	Namespace: zm_equipment
	Checksum: 0x80A7D5FA
	Offset: 0x5F8
	Size: 0x35
	Parameters: 1
	Flags: None
*/
function is_included(equipment)
{
	if(!isdefined(level._included_equipment))
	{
		return 0;
	}
	return isdefined(level._included_equipment[equipment.rootweapon]);
}

/*
	Name: Include
	Namespace: zm_equipment
	Checksum: 0x5E180A1F
	Offset: 0x638
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function Include(equipment_name)
{
	if(!isdefined(level._included_equipment))
	{
		level._included_equipment = [];
	}
	equipment = GetWeapon(equipment_name);
	level._included_equipment[equipment] = equipment;
}

