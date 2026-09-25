#using scripts\codescripts\struct;
#using scripts\shared\util_shared;

#namespace _claymore;

/*
	Name: init
	Namespace: _claymore
	Checksum: 0xE5F27E9E
	Offset: 0xE8
	Size: 0x25
	Parameters: 1
	Flags: None
*/
function init(localClientNum)
{
	level._effect["fx_claymore_laser"] = "_t6/weapon/claymore/fx_claymore_laser";
}

/*
	Name: spawned
	Namespace: _claymore
	Checksum: 0x61696D2D
	Offset: 0x118
	Size: 0xBF
	Parameters: 1
	Flags: None
*/
function spawned(localClientNum)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	while(1)
	{
		if(isdefined(self.stunned) && self.stunned)
		{
			wait(0.1);
			continue;
		}
		self.claymoreLaserFXId = PlayFXOnTag(localClientNum, level._effect["fx_claymore_laser"], self, "tag_fx");
		self waittill("stunned");
		stopfx(localClientNum, self.claymoreLaserFXId);
	}
}

