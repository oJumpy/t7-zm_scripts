#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_util;

#namespace zm_laststand;

/*
	Name: __init__sytem__
	Namespace: zm_laststand
	Checksum: 0x796482E0
	Offset: 0x1B0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_laststand", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_laststand
	Checksum: 0x871FD196
	Offset: 0x1F0
	Size: 0x18B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.laststands = [];
	for(i = 0; i < 4; i++)
	{
		level.laststands[i] = spawnstruct();
		level.laststands[i].bleedoutTime = 0;
		level.laststands[i].laststand_update_clientfields = "laststand_update" + i;
		level.laststands[i].lastBleedoutTime = 0;
		clientfield::register("world", level.laststands[i].laststand_update_clientfields, 1, 5, "counter", &update_bleedout_timer, 0, 0);
	}
	level thread wait_and_set_revive_shader_constant();
	visionset_mgr::register_visionset_info("zombie_last_stand", 1, 31, undefined, "zombie_last_stand", 6);
	visionset_mgr::register_visionset_info("zombie_death", 1, 31, "zombie_last_stand", "zombie_death", 6);
}

/*
	Name: wait_and_set_revive_shader_constant
	Namespace: zm_laststand
	Checksum: 0xD2AA51D5
	Offset: 0x388
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function wait_and_set_revive_shader_constant()
{
	while(1)
	{
		level waittill("Notetrack", localClientNum, note);
		if(note == "revive_shader_constant")
		{
			player = GetLocalPlayer(localClientNum);
			player MapShaderConstant(localClientNum, 0, "scriptVector2", 0, 1, 0, getServerTime(localClientNum) / 1000);
		}
	}
}

/*
	Name: animation_update
	Namespace: zm_laststand
	Checksum: 0x63717055
	Offset: 0x440
	Size: 0x107
	Parameters: 3
	Flags: None
*/
function animation_update(model, oldValue, newValue)
{
	self endon("new_val");
	startTime = GetRealTime();
	timeSinceLastUpdate = 0;
	if(oldValue == newValue)
	{
		newValue = oldValue - 1;
	}
	while(timeSinceLastUpdate <= 1)
	{
		timeSinceLastUpdate = GetRealTime() - startTime / 1000;
		lerpValue = LerpFloat(oldValue, newValue, timeSinceLastUpdate) / 30;
		SetUIModelValue(model, lerpValue);
		wait(0.016);
	}
}

/*
	Name: update_bleedout_timer
	Namespace: zm_laststand
	Checksum: 0x6FDF2AAA
	Offset: 0x550
	Size: 0x2B3
	Parameters: 7
	Flags: None
*/
function update_bleedout_timer(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	subStr = GetSubStr(fieldName, 16);
	playerNum = Int(subStr);
	level.laststands[playerNum].lastBleedoutTime = level.laststands[playerNum].bleedoutTime;
	level.laststands[playerNum].bleedoutTime = newVal - 1;
	if(level.laststands[playerNum].lastBleedoutTime < level.laststands[playerNum].bleedoutTime)
	{
		level.laststands[playerNum].lastBleedoutTime = level.laststands[playerNum].bleedoutTime;
	}
	model = GetUIModel(GetUIModelForController(localClientNum), "WorldSpaceIndicators.bleedOutModel" + playerNum + ".bleedOutPercent");
	if(isdefined(model))
	{
		if(newVal == 30)
		{
			level.laststands[playerNum].bleedoutTime = 0;
			level.laststands[playerNum].lastBleedoutTime = 0;
			SetUIModelValue(model, 1);
		}
		else if(newVal == 29)
		{
			level.laststands[playerNum] notify("new_val");
			level.laststands[playerNum] thread animation_update(model, 30, 28);
		}
		else
		{
			level.laststands[playerNum] notify("new_val");
			level.laststands[playerNum] thread animation_update(model, level.laststands[playerNum].lastBleedoutTime, level.laststands[playerNum].bleedoutTime);
		}
	}
}

