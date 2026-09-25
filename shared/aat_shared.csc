#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace AAT;

/*
	Name: __init__sytem__
	Namespace: AAT
	Checksum: 0x7A1F1815
	Offset: 0x150
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("aat", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: AAT
	Checksum: 0x79F2846A
	Offset: 0x190
	Size: 0x83
	Parameters: 0
	Flags: Private
*/
function private __init__()
{
	level.aat_initializing = 1;
	level.aat_default_info_name = "none";
	level.aat_default_info_icon = "blacktransparent";
	level.AAT = [];
	register("none", level.aat_default_info_name, level.aat_default_info_icon);
	callback::on_finalize_initialization(&finalize_clientfields);
}

/*
	Name: register
	Namespace: AAT
	Checksum: 0xC478BD7C
	Offset: 0x220
	Size: 0x177
	Parameters: 3
	Flags: None
*/
function register(name, localized_string, icon)
{
	/#
		Assert(isdefined(level.aat_initializing) && level.aat_initializing, "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(name), "Dev Block strings are not supported");
	#/
	/#
		Assert(!isdefined(level.AAT[name]), "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(localized_string), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(icon), "Dev Block strings are not supported");
	#/
	level.AAT[name] = spawnstruct();
	level.AAT[name].name = name;
	level.AAT[name].localized_string = localized_string;
	level.AAT[name].icon = icon;
}

/*
	Name: aat_hud_manager
	Namespace: AAT
	Checksum: 0x3E92723B
	Offset: 0x3A0
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function aat_hud_manager(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(level.update_aat_hud))
	{
		[[level.update_aat_hud]](localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
	}
}

/*
	Name: finalize_clientfields
	Namespace: AAT
	Checksum: 0xD278F4B0
	Offset: 0x420
	Size: 0x18F
	Parameters: 0
	Flags: None
*/
function finalize_clientfields()
{
	/#
		println("Dev Block strings are not supported");
	#/
	if(level.AAT.size > 1)
	{
		Array::alphabetize(level.AAT);
		i = 0;
		foreach(AAT in level.AAT)
		{
			AAT.n_index = i;
			i++;
			/#
				println("Dev Block strings are not supported" + AAT.name);
			#/
		}
		n_bits = GetMinBitCountForNum(level.AAT.size - 1);
		clientfield::register("toplayer", "aat_current", 1, n_bits, "int", &aat_hud_manager, 0, 1);
	}
	level.aat_initializing = 0;
}

/*
	Name: get_string
	Namespace: AAT
	Checksum: 0x958679C9
	Offset: 0x5B8
	Size: 0xA9
	Parameters: 1
	Flags: None
*/
function get_string(n_aat_index)
{
	foreach(AAT in level.AAT)
	{
		if(AAT.n_index == n_aat_index)
		{
			return AAT.localized_string;
		}
	}
	return level.aat_default_info_name;
}

/*
	Name: get_icon
	Namespace: AAT
	Checksum: 0xB001F4E2
	Offset: 0x670
	Size: 0xA9
	Parameters: 1
	Flags: None
*/
function get_icon(n_aat_index)
{
	foreach(AAT in level.AAT)
	{
		if(AAT.n_index == n_aat_index)
		{
			return AAT.icon;
		}
	}
	return level.aat_default_info_icon;
}

