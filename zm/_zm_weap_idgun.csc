#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_vortex;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_weapons;

#namespace idgun;

/*
	Name: __init__sytem__
	Namespace: idgun
	Checksum: 0xCF1414B7
	Offset: 0x240
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("idgun", &init, undefined, undefined);
}

/*
	Name: init
	Namespace: idgun
	Checksum: 0xB082EC8B
	Offset: 0x280
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function init()
{
	level.weaponNone = GetWeapon("none");
	level.var_29323b70 = GetWeapon("robotech_launcher");
	level.var_672ab258 = GetWeapon("robotech_launcher_upgraded");
	function_436486f7();
	callback::on_spawned(&function_50ee0a95);
}

/*
	Name: function_50ee0a95
	Namespace: idgun
	Checksum: 0xDAFB843A
	Offset: 0x320
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function function_50ee0a95(localClientNum)
{
}

/*
	Name: function_e1efbc50
	Namespace: idgun
	Checksum: 0xA6F9628D
	Offset: 0x338
	Size: 0x89
	Parameters: 1
	Flags: None
*/
function function_e1efbc50(var_9727e47e)
{
	if(var_9727e47e != level.weaponNone)
	{
		if(!isdefined(level.idgun_weapons))
		{
			level.idgun_weapons = [];
		}
		else if(!IsArray(level.idgun_weapons))
		{
			level.idgun_weapons = Array(level.idgun_weapons);
		}
		level.idgun_weapons[level.idgun_weapons.size] = var_9727e47e;
	}
}

/*
	Name: function_436486f7
	Namespace: idgun
	Checksum: 0x52357579
	Offset: 0x3D0
	Size: 0x153
	Parameters: 0
	Flags: None
*/
function function_436486f7()
{
	level.idgun_weapons = [];
	function_e1efbc50(GetWeapon("idgun_0"));
	function_e1efbc50(GetWeapon("idgun_1"));
	function_e1efbc50(GetWeapon("idgun_2"));
	function_e1efbc50(GetWeapon("idgun_3"));
	function_e1efbc50(GetWeapon("idgun_upgraded_0"));
	function_e1efbc50(GetWeapon("idgun_upgraded_1"));
	function_e1efbc50(GetWeapon("idgun_upgraded_2"));
	function_e1efbc50(GetWeapon("idgun_upgraded_3"));
}

/*
	Name: function_9b7ac6a9
	Namespace: idgun
	Checksum: 0xD667D9A7
	Offset: 0x530
	Size: 0x97
	Parameters: 1
	Flags: None
*/
function function_9b7ac6a9(weapon)
{
	if(weapon === GetWeapon("idgun_upgraded_0") || weapon === GetWeapon("idgun_upgraded_1") || weapon === GetWeapon("idgun_upgraded_2") || weapon === GetWeapon("idgun_upgraded_3"))
	{
		return 1;
	}
	return 0;
}

/*
	Name: is_idgun_damage
	Namespace: idgun
	Checksum: 0xA7233AB0
	Offset: 0x5D0
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function is_idgun_damage(weapon)
{
	if(isdefined(level.idgun_weapons))
	{
		if(IsInArray(level.idgun_weapons, weapon))
		{
			return 1;
		}
	}
	return 0;
}

