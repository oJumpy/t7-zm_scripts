#using scripts\shared\util_shared;

#namespace zm_moon_teleporter;

/*
	Name: main
	Namespace: zm_moon_teleporter
	Checksum: 0xA8E36342
	Offset: 0x130
	Size: 0xCD
	Parameters: 0
	Flags: None
*/
function main()
{
	level thread wait_for_teleport_aftereffect();
	util::waitforallclients();
	level.portal_effect = level._effect["zombie_pentagon_teleporter"];
	players = GetLocalPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] thread teleporter_fx_setup(i);
		players[i] thread teleporter_fx_cool_down(i);
	}
}

/*
	Name: teleporter_fx_setup
	Namespace: zm_moon_teleporter
	Checksum: 0x5C8F200E
	Offset: 0x208
	Size: 0x1A1
	Parameters: 1
	Flags: None
*/
function teleporter_fx_setup(clientNum)
{
	teleporters = GetEntArray(clientNum, "pentagon_teleport_fx", "targetname");
	level.fxents[clientNum] = [];
	level.packtime[clientNum] = 1;
	for(i = 0; i < teleporters.size; i++)
	{
		fx_ent = spawn(clientNum, teleporters[i].origin, "script_model");
		fx_ent SetModel("tag_origin");
		fx_ent.angles = teleporters[i].angles;
		if(!isdefined(level.fxents[clientNum]))
		{
			level.fxents[clientNum] = [];
		}
		else if(!IsArray(level.fxents[clientNum]))
		{
			level.fxents[clientNum] = Array(level.fxents[clientNum]);
		}
		level.fxents[clientNum][level.fxents[clientNum].size] = fx_ent;
	}
}

/*
	Name: teleporter_fx_init
	Namespace: zm_moon_teleporter
	Checksum: 0x98C2A46E
	Offset: 0x3B8
	Size: 0x1A5
	Parameters: 3
	Flags: None
*/
function teleporter_fx_init(clientNum, set, newent)
{
	fx_array = level.fxents[clientNum];
	if(set && level.packtime[clientNum] == 1)
	{
		/#
			println("Dev Block strings are not supported", clientNum);
		#/
		level.packtime[clientNum] = 0;
		for(i = 0; i < fx_array.size; i++)
		{
			if(isdefined(fx_array[i].portalfx))
			{
				deletefx(clientNum, fx_array[i].portalfx);
			}
			wait(0.01);
			fx_array[i].portalfx = PlayFXOnTag(clientNum, level.portal_effect, fx_array[i], "tag_origin");
			playsound(clientNum, "evt_teleporter_start", fx_array[i].origin);
			fx_array[i] PlayLoopSound("evt_teleporter_loop", 1.75);
		}
	}
}

/*
	Name: teleporter_fx_cool_down
	Namespace: zm_moon_teleporter
	Checksum: 0xDD8FD674
	Offset: 0x568
	Size: 0x217
	Parameters: 1
	Flags: None
*/
function teleporter_fx_cool_down(clientNum)
{
	while(1)
	{
		level waittill("cool_fx", clientNum);
		players = GetLocalPlayers();
		if(level.packtime[clientNum] == 0)
		{
			fx_pos = undefined;
			closest = 512;
			for(i = 0; i < level.fxents[clientNum].size; i++)
			{
				if(isdefined(level.fxents[clientNum][i]))
				{
					if(closest > Distance(level.fxents[clientNum][i].origin, players[clientNum].origin))
					{
						closest = Distance(level.fxents[clientNum][i].origin, players[clientNum].origin);
						fx_pos = level.fxents[clientNum][i];
					}
				}
			}
			if(isdefined(fx_pos) && isdefined(fx_pos.portalfx))
			{
				deletefx(clientNum, fx_pos.portalfx);
				fx_pos.portalfx = PlayFXOnTag(clientNum, level._effect["zombie_pent_portal_cool"], fx_pos, "tag_origin");
				self thread turn_off_cool_down_fx(fx_pos, clientNum);
			}
		}
		wait(0.1);
	}
}

/*
	Name: turn_off_cool_down_fx
	Namespace: zm_moon_teleporter
	Checksum: 0x17359D1F
	Offset: 0x788
	Size: 0xC7
	Parameters: 2
	Flags: None
*/
function turn_off_cool_down_fx(fx_pos, clientNum)
{
	fx_pos thread cool_down_timer();
	fx_pos waittill("cool_down_over");
	if(isdefined(fx_pos) && isdefined(fx_pos.portalfx))
	{
		deletefx(clientNum, fx_pos.portalfx);
		if(level.packtime[clientNum] == 0)
		{
			fx_pos.portalfx = PlayFXOnTag(clientNum, level.portal_effect, fx_pos, "tag_origin");
		}
	}
}

/*
	Name: cool_down_timer
	Namespace: zm_moon_teleporter
	Checksum: 0x28AB658F
	Offset: 0x858
	Size: 0x69
	Parameters: 0
	Flags: None
*/
function cool_down_timer()
{
	time = 0;
	self.defcon_active = 0;
	self thread pack_cooldown_listener();
	while(!self.defcon_active && time < 20)
	{
		wait(1);
		time++;
	}
	self notify("cool_down_over");
}

/*
	Name: pack_cooldown_listener
	Namespace: zm_moon_teleporter
	Checksum: 0xC2021E56
	Offset: 0x8D0
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function pack_cooldown_listener()
{
	self endon("cool_down_over");
	level waittill("end_cool_downs");
	self.defcon_active = 1;
}

/*
	Name: wait_for_teleport_aftereffect
	Namespace: zm_moon_teleporter
	Checksum: 0x28B03046
	Offset: 0x900
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function wait_for_teleport_aftereffect()
{
	while(1)
	{
		level waittill("ae1", clientNum);
		visionSetNaked(clientNum, "flare", 0.4);
	}
}

