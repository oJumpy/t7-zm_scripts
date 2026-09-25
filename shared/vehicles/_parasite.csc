#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace parasite;

/*
	Name: main
	Namespace: parasite
	Checksum: 0x8EE26695
	Offset: 0x270
	Size: 0x103
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("vehicle", "parasite_tell_fx", 1, 1, "int", &parasiteTellFxHandler, 0, 0);
	clientfield::register("toplayer", "parasite_damage", 1, 1, "counter", &parasite_damage, 0, 0);
	clientfield::register("vehicle", "parasite_secondary_deathfx", 1, 1, "int", &parasiteSecondaryDeathFxHandler, 0, 0);
	vehicle::add_vehicletype_callback("parasite", &_setup_);
}

/*
	Name: parasiteTellFxHandler
	Namespace: parasite
	Checksum: 0xBD1ACD9C
	Offset: 0x380
	Size: 0x12B
	Parameters: 7
	Flags: Private
*/
function private parasiteTellFxHandler(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(isdefined(self.tellFxHandle))
	{
		stopfx(localClientNum, self.tellFxHandle);
		self.tellFxHandle = undefined;
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0.1);
	}
	settings = struct::get_script_bundle("vehiclecustomsettings", "parasitesettings");
	if(isdefined(settings))
	{
		if(newValue)
		{
			self.tellFxHandle = PlayFXOnTag(localClientNum, settings.weakspotfx, self, "tag_flash");
			self MapShaderConstant(localClientNum, 0, "scriptVector2", 1);
		}
	}
}

/*
	Name: parasite_damage
	Namespace: parasite
	Checksum: 0x4AFF30DA
	Offset: 0x4B8
	Size: 0x63
	Parameters: 7
	Flags: Private
*/
function private parasite_damage(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue)
	{
		self postfx::playPostfxBundle("pstfx_parasite_dmg");
	}
}

/*
	Name: parasiteSecondaryDeathFxHandler
	Namespace: parasite
	Checksum: 0xCF923992
	Offset: 0x528
	Size: 0xE3
	Parameters: 7
	Flags: Private
*/
function private parasiteSecondaryDeathFxHandler(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	settings = struct::get_script_bundle("vehiclecustomsettings", "parasitesettings");
	if(isdefined(settings))
	{
		if(newValue)
		{
			handle = playFX(localClientNum, settings.secondary_death_fx_1, self GetTagOrigin(settings.secondary_death_tag_1));
			SetFXIgnorePause(localClientNum, handle, 1);
		}
	}
}

/*
	Name: _setup_
	Namespace: parasite
	Checksum: 0x9BEA6617
	Offset: 0x618
	Size: 0x83
	Parameters: 1
	Flags: Private
*/
function private _setup_(localClientNum)
{
	self MapShaderConstant(localClientNum, 0, "scriptVector2", 0.1);
	if(isdefined(level.debug_keyline_zombies) && level.debug_keyline_zombies)
	{
		self duplicate_render::set_dr_flag("keyline_active", 1);
		self duplicate_render::update_dr_filters(localClientNum);
	}
}

