#using scripts\codescripts\struct;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_weapons;

#namespace zm_utility;

/*
	Name: ignore_triggers
	Namespace: zm_utility
	Checksum: 0xB6AE7601
	Offset: 0x120
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function ignore_triggers(timer)
{
	self endon("death");
	self.ignoreTriggers = 1;
	if(isdefined(timer))
	{
		wait(timer);
	}
	else
	{
		wait(0.5);
	}
	self.ignoreTriggers = 0;
}

/*
	Name: is_encounter
	Namespace: zm_utility
	Checksum: 0x11D2E351
	Offset: 0x178
	Size: 0x5
	Parameters: 0
	Flags: None
*/
function is_encounter()
{
	return 0;
}

/*
	Name: round_up_to_ten
	Namespace: zm_utility
	Checksum: 0xB233F14B
	Offset: 0x188
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function round_up_to_ten(score)
{
	new_score = score - score % 10;
	if(new_score < score)
	{
		new_score = new_score + 10;
	}
	return new_score;
}

/*
	Name: round_up_score
	Namespace: zm_utility
	Checksum: 0x2EEA486C
	Offset: 0x1E0
	Size: 0x6F
	Parameters: 2
	Flags: None
*/
function round_up_score(score, value)
{
	score = Int(score);
	new_score = score - score % value;
	if(new_score < score)
	{
		new_score = new_score + value;
	}
	return new_score;
}

/*
	Name: halve_score
	Namespace: zm_utility
	Checksum: 0xDD0D5FAF
	Offset: 0x258
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function halve_score(n_score)
{
	n_score = n_score / 2;
	n_score = round_up_score(n_score, 10);
	return n_score;
}

/*
	Name: spawn_weapon_model
	Namespace: zm_utility
	Checksum: 0x12F62812
	Offset: 0x2A0
	Size: 0xEF
	Parameters: 6
	Flags: None
*/
function spawn_weapon_model(localClientNum, weapon, model, origin, angles, options)
{
	if(!isdefined(model))
	{
		model = weapon.worldmodel;
	}
	weapon_model = spawn(localClientNum, origin, "script_model");
	if(isdefined(angles))
	{
		weapon_model.angles = angles;
	}
	if(isdefined(options))
	{
		weapon_model UseWeaponModel(weapon, model, options);
	}
	else
	{
		weapon_model UseWeaponModel(weapon, model);
	}
	return weapon_model;
}

/*
	Name: spawn_buildkit_weapon_model
	Namespace: zm_utility
	Checksum: 0x8B1BDCA1
	Offset: 0x398
	Size: 0xAF
	Parameters: 5
	Flags: None
*/
function spawn_buildkit_weapon_model(localClientNum, weapon, camo, origin, angles)
{
	weapon_model = spawn(localClientNum, origin, "script_model");
	if(isdefined(angles))
	{
		weapon_model.angles = angles;
	}
	weapon_model UseBuildKitWeaponModel(localClientNum, weapon, camo, zm_weapons::is_weapon_upgraded(weapon));
	return weapon_model;
}

/*
	Name: is_Classic
	Namespace: zm_utility
	Checksum: 0xEE3FAA58
	Offset: 0x450
	Size: 0x7
	Parameters: 0
	Flags: None
*/
function is_Classic()
{
	return 1;
}

/*
	Name: is_gametype_active
	Namespace: zm_utility
	Checksum: 0x24C4905C
	Offset: 0x460
	Size: 0xB1
	Parameters: 1
	Flags: None
*/
function is_gametype_active(a_gametypes)
{
	b_is_gametype_active = 0;
	if(!IsArray(a_gametypes))
	{
		a_gametypes = Array(a_gametypes);
	}
	for(i = 0; i < a_gametypes.size; i++)
	{
		if(GetDvarString("g_gametype") == a_gametypes[i])
		{
			b_is_gametype_active = 1;
		}
	}
	return b_is_gametype_active;
}

/*
	Name: setInventoryUIModels
	Namespace: zm_utility
	Checksum: 0x363E5E7B
	Offset: 0x520
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function setInventoryUIModels(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(IsSpectating(localClientNum))
	{
		return;
	}
	SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "zmInventory." + fieldName), newVal);
}

/*
	Name: setSharedInventoryUIModels
	Namespace: zm_utility
	Checksum: 0x3437D677
	Offset: 0x5D0
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function setSharedInventoryUIModels(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "zmInventory." + fieldName), newVal);
}

/*
	Name: zm_ui_infotext
	Namespace: zm_utility
	Checksum: 0xA49F2BB2
	Offset: 0x660
	Size: 0xDB
	Parameters: 7
	Flags: None
*/
function zm_ui_infotext(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "zmInventory.infoText"), fieldName);
	}
	else
	{
		SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "zmInventory.infoText"), "");
	}
}

/*
	Name: drawcylinder
	Namespace: zm_utility
	Checksum: 0x195D843
	Offset: 0x748
	Size: 0x2B5
	Parameters: 4
	Flags: None
*/
function drawcylinder(pos, rad, height, color)
{
	/#
		currad = rad;
		curheight = height;
		debugstar(pos, 1, color);
		for(r = 0; r < 20; r++)
		{
			theta = r / 20 * 360;
			theta2 = r + 1 / 20 * 360;
			line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta2) * currad, sin(theta2) * currad, 0), color, 1, 1, 100);
			line(pos + (cos(theta) * currad, sin(theta) * currad, curheight), pos + (cos(theta2) * currad, sin(theta2) * currad, curheight), color, 1, 1, 100);
			line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta) * currad, sin(theta) * currad, curheight), color, 1, 1, 100);
		}
	#/
}

/*
	Name: umbra_fix_logic
	Namespace: zm_utility
	Checksum: 0xBF9F9B53
	Offset: 0xA08
	Size: 0xAF
	Parameters: 1
	Flags: None
*/
function umbra_fix_logic(localClientNum)
{
	self endon("disconnect");
	self endon("entityshutdown");
	umbra_settometrigger(localClientNum, "");
	while(1)
	{
		in_fix_area = 0;
		if(isdefined(level.custom_umbra_hotfix))
		{
			in_fix_area = self thread [[level.custom_umbra_hotfix]](localClientNum);
		}
		if(in_fix_area == 0)
		{
			umbra_settometrigger(localClientNum, "");
		}
		wait(0.05);
	}
}

/*
	Name: umbra_fix_trigger
	Namespace: zm_utility
	Checksum: 0xCBF2EDAC
	Offset: 0xAC0
	Size: 0x12D
	Parameters: 5
	Flags: None
*/
function umbra_fix_trigger(localClientNum, pos, height, radius, umbra_name)
{
	bottomY = pos[2];
	topY = pos[2] + height;
	if(self.origin[2] > bottomY && self.origin[2] < topY)
	{
		if(Distance2DSquared(self.origin, pos) < radius * radius)
		{
			umbra_settometrigger(localClientNum, umbra_name);
			/#
				drawcylinder(pos, radius, height, (0, 1, 0));
			#/
			return 1;
		}
	}
	/#
		drawcylinder(pos, radius, height, (1, 0, 0));
	#/
	return 0;
}

