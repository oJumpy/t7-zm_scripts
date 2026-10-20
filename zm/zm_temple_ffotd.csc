#using scripts\codescripts\struct;

#namespace zm_temple_ffotd;

/*
	Name: main_start
	Namespace: zm_temple_ffotd
	Checksum: 0xC297980B
	Offset: 0xE8
	Size: 0x101
	Parameters: 0
	Flags: None
*/
function main_start()
{
	a_wallbuys = struct::get_array("weapon_upgrade", "targetname");
	foreach(s_wallbuy in a_wallbuys)
	{
		if(s_wallbuy.zombie_weapon_upgrade == "smg_standard")
		{
			s_wallbuy.origin = s_wallbuy.origin + VectorScale((0, 1, 0), 5);
		}
	}
	level._effect["powerup_on_red"] = "zombie/fx_powerup_on_red_zmb";
}

/*
	Name: main_end
	Namespace: zm_temple_ffotd
	Checksum: 0x99EC1590
	Offset: 0x1F8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function main_end()
{
}

