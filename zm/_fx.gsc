#using scripts\codescripts\struct;
#using scripts\shared\exploder_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\sound_shared;
#using scripts\zm\_util;

#namespace FX;

/*
	Name: print_org
	Namespace: FX
	Checksum: 0x692DA508
	Offset: 0x110
	Size: 0x183
	Parameters: 4
	Flags: None
*/
function print_org(fxcommand, fxid, fxpos, waitTime)
{
	/#
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported" + fxpos[0] + "Dev Block strings are not supported" + fxpos[1] + "Dev Block strings are not supported" + fxpos[2] + "Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported");
			println("Dev Block strings are not supported" + fxcommand + "Dev Block strings are not supported");
			println("Dev Block strings are not supported" + fxid + "Dev Block strings are not supported");
			println("Dev Block strings are not supported" + waitTime + "Dev Block strings are not supported");
			println("Dev Block strings are not supported");
		}
	#/
}

/*
	Name: GunFireLoopfx
	Namespace: FX
	Checksum: 0x78A02089
	Offset: 0x2A0
	Size: 0x73
	Parameters: 8
	Flags: None
*/
function GunFireLoopfx(fxid, fxpos, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax)
{
	thread gunfireloopfxthread(fxid, fxpos, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax);
}

/*
	Name: gunfireloopfxthread
	Namespace: FX
	Checksum: 0x57640D33
	Offset: 0x320
	Size: 0x231
	Parameters: 8
	Flags: None
*/
function gunfireloopfxthread(fxid, fxpos, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax)
{
	level endon("stop all gunfireloopfx");
	wait(0.05);
	if(betweenSetsMax < betweenSetsMin)
	{
		temp = betweenSetsMax;
		betweenSetsMax = betweenSetsMin;
		betweenSetsMin = temp;
	}
	betweenSetsBase = betweenSetsMin;
	betweenSetsRange = betweenSetsMax - betweenSetsMin;
	if(shotdelayMax < shotdelayMin)
	{
		temp = shotdelayMax;
		shotdelayMax = shotdelayMin;
		shotdelayMin = temp;
	}
	shotdelayBase = shotdelayMin;
	shotdelayRange = shotdelayMax - shotdelayMin;
	if(shotsMax < shotsMin)
	{
		temp = shotsMax;
		shotsMax = shotsMin;
		shotsMin = temp;
	}
	shotsBase = shotsMin;
	shotsRange = shotsMax - shotsMin;
	fxEnt = spawnFx(level._effect[fxid], fxpos);
	for(;;)
	{
		shotnum = shotsBase + RandomInt(shotsRange);
		for(i = 0; i < shotnum; i++)
		{
			triggerFx(fxEnt);
			wait(shotdelayBase + RandomFloat(shotdelayRange));
		}
		wait(betweenSetsBase + RandomFloat(betweenSetsRange));
	}
}

/*
	Name: gunfireloopfxVec
	Namespace: FX
	Checksum: 0x7261CB9C
	Offset: 0x560
	Size: 0x83
	Parameters: 9
	Flags: None
*/
function gunfireloopfxVec(fxid, fxpos, fxPos2, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax)
{
	thread gunfireloopfxVecthread(fxid, fxpos, fxPos2, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax);
}

/*
	Name: gunfireloopfxVecthread
	Namespace: FX
	Checksum: 0x53E758C6
	Offset: 0x5F0
	Size: 0x2D1
	Parameters: 9
	Flags: None
*/
function gunfireloopfxVecthread(fxid, fxpos, fxPos2, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax)
{
	level endon("stop all gunfireloopfx");
	wait(0.05);
	if(betweenSetsMax < betweenSetsMin)
	{
		temp = betweenSetsMax;
		betweenSetsMax = betweenSetsMin;
		betweenSetsMin = temp;
	}
	betweenSetsBase = betweenSetsMin;
	betweenSetsRange = betweenSetsMax - betweenSetsMin;
	if(shotdelayMax < shotdelayMin)
	{
		temp = shotdelayMax;
		shotdelayMax = shotdelayMin;
		shotdelayMin = temp;
	}
	shotdelayBase = shotdelayMin;
	shotdelayRange = shotdelayMax - shotdelayMin;
	if(shotsMax < shotsMin)
	{
		temp = shotsMax;
		shotsMax = shotsMin;
		shotsMin = temp;
	}
	shotsBase = shotsMin;
	shotsRange = shotsMax - shotsMin;
	fxPos2 = VectorNormalize(fxPos2 - fxpos);
	fxEnt = spawnFx(level._effect[fxid], fxpos, fxPos2);
	for(;;)
	{
		shotnum = shotsBase + RandomInt(shotsRange);
		for(i = 0; i < Int(shotnum / level.fxfireloopmod); i++)
		{
			triggerFx(fxEnt);
			delay = shotdelayBase + RandomFloat(shotdelayRange) * level.fxfireloopmod;
			if(delay < 0.05)
			{
				delay = 0.05;
			}
			wait(delay);
		}
		wait(shotdelayBase + RandomFloat(shotdelayRange));
		wait(betweenSetsBase + RandomFloat(betweenSetsRange));
	}
}

/*
	Name: GrenadeExplosionfx
	Namespace: FX
	Checksum: 0xD996A8C1
	Offset: 0x8D0
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function GrenadeExplosionfx(pos)
{
	playFX(level._effect["mechanical explosion"], pos);
	Earthquake(0.15, 0.5, pos, 250);
}

