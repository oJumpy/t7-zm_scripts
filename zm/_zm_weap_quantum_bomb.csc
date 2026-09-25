#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_weapons;

#namespace namespace_ddd35ff;

/*
	Name: __init__sytem__
	Namespace: namespace_ddd35ff
	Checksum: 0x3333389C
	Offset: 0x1D8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_quantum_bomb", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_ddd35ff
	Checksum: 0x23D6B394
	Offset: 0x218
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::add_weapon_type(GetWeapon("quantum_bomb"), &quantum_bomb_spawned);
	level._effect["quantum_bomb_viewmodel_twist"] = "dlc5/zmb_weapon/fx_twist";
	level._effect["quantum_bomb_viewmodel_press"] = "dlc5/zmb_weapon/fx_press";
	level thread quantum_bomb_notetrack_think();
}

/*
	Name: quantum_bomb_notetrack_think
	Namespace: namespace_ddd35ff
	Checksum: 0x8D1F7953
	Offset: 0x2A8
	Size: 0xB9
	Parameters: 0
	Flags: None
*/
function quantum_bomb_notetrack_think()
{
	for(;;)
	{
		level waittill("Notetrack", localClientNum, note);
		switch(note)
		{
			case "quantum_bomb_twist":
			{
				PlayViewmodelFX(localClientNum, level._effect["quantum_bomb_viewmodel_twist"], "tag_weapon");
				break;
			}
			case "quantum_bomb_press":
			{
				PlayViewmodelFX(localClientNum, level._effect["quantum_bomb_viewmodel_press"], "tag_weapon");
				break;
			}
		}
	}
}

/*
	Name: quantum_bomb_spawned
	Namespace: namespace_ddd35ff
	Checksum: 0xC30F72D7
	Offset: 0x370
	Size: 0xAB
	Parameters: 2
	Flags: None
*/
function quantum_bomb_spawned(localClientNum, play_sound)
{
	temp_ent = spawn(0, self.origin, "script_origin");
	temp_ent PlayLoopSound("wpn_quantum_rise", 0.5);
	while(isdefined(self))
	{
		temp_ent.origin = self.origin;
		wait(0.05);
	}
	temp_ent delete();
}

