#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\flag_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_util;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_pers_upgrades_system;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_clone;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm;
#using scripts\zm\_zm_perk_electric_cherry;

#insert scripts\zm\_zm_perk_chugabud.gsh;
#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_utility.gsh;

/***************************** WARDOGSK93: Start *****************************/
#using scripts\wardog\wardog_addon;

#insert scripts\wardog\wardog_addon.gsh;
/***************************** WARDOGSK93: End *****************************/

#precache( "material", CHUGABUD_SHADER );
#precache( "material", "sanchez_waypoint_revive" );
#precache( "string", "ZOMBIE_PERK_CHUGABUD" );
#precache( "fx", "zombie/fx_perk_sleight_of_hand_zmb" );
#precache( "fx", "weapon/quantum_bomb/fx_player_position_effect" );

#namespace zm_perk_chugabud;

REGISTER_SYSTEM( "zm_perk_chugabud", &__init__, undefined )

function __init__()
{
	enable_chugabud_perk_for_level();
}

function enable_chugabud_perk_for_level()
{
	zm_perks::register_perk_basic_info( PERK_WHOSWHO, "whoswho", CHUGABUD_PERK_COST, &"ZOMBIE_PERK_CHUGABUD", GetWeapon( CHUGABUD_PERK_BOTTLE_WEAPON ) );
	zm_perks::register_perk_precache_func( PERK_WHOSWHO, &chugabud_precache );
	zm_perks::register_perk_clientfields( PERK_WHOSWHO, &chugabud_register_clientfield, &chugabud_set_clientfield );
	zm_perks::register_perk_machine( PERK_WHOSWHO, &chugabud_perk_machine_setup, &init_chugabud );
	zm_perks::register_perk_host_migration_params( PERK_WHOSWHO, CHUGABUD_RADIANT_MACHINE_NAME, CHUGABUD_MACHINE_LIGHT_FX );
	/***************************** WARDOGSK93: Start *****************************/
	// Original: // zm_perks::register_perk_threads( PERK_WHOSWHO, &chugabud_perk_activate );
	zm_perks::register_perk_threads( PERK_WHOSWHO, &chugabud_perk_activate, &take_perk );
	/***************************** WARDOGSK93: End *****************************/
}

function chugabud_precache()
{
	level._effect[ CHUGABUD_MACHINE_LIGHT_FX ] = "zombie/fx_perk_sleight_of_hand_zmb";
	level.machine_assets[ PERK_WHOSWHO ] = SpawnStruct();
	level.machine_assets[ PERK_WHOSWHO ].weapon = GetWeapon( CHUGABUD_PERK_BOTTLE_WEAPON );
	level.machine_assets[ PERK_WHOSWHO ].off_model = CHUGABUD_MACHINE_DISABLED_MODEL;
	level.machine_assets[ PERK_WHOSWHO ].on_model = CHUGABUD_MACHINE_ACTIVE_MODEL;

	addon_message = "hud|";
	addon_message += PERK_WHOSWHO + "|";
	addon_message += "shader|";
	addon_message += CHUGABUD_SHADER;

	wardog_addon::send_addon_message("Unknown", ADDON_NAME_PERK_HUD, addon_message);
}

function chugabud_register_clientfield()
{
	clientfield::register( "clientuimodel", PERK_CLIENTFIELD_WHOSWHO, VERSION_SHIP, 2, "int" );
	clientfield::register( "actor", "clientfield_whos_who_clone_glow_shader", VERSION_TU5, 1, "int" );
	clientfield::register( "toplayer", "clientfield_whos_who_audio", VERSION_TU5, 1, "int" );
	clientfield::register( "toplayer", "clientfield_whos_who_filter", VERSION_TU5, 1, "int" );
	clientfield::register("toplayer", "vulture_waypoint_whos", VERSION_SHIP, 2, "int");
	level.whos_who_client_setup = true;
}

function chugabud_set_clientfield( state )
{
	if(!wardog_addon::is_addon_enabled(ADDON_NAME_PERK_HUD))
		self clientfield::set_player_uimodel( PERK_CLIENTFIELD_WHOSWHO, state );
	self clientfield::set_to_player("vulture_waypoint_whos", state);
}

function chugabud_perk_machine_setup( use_trigger, perk_machine, bump_trigger, collision )
{
	use_trigger.script_sound = "mus_perks_whoswho_jingle";
	use_trigger.script_string = "chugabud_perk";
	use_trigger.script_label = "mus_perks_whoswho_sting";
	use_trigger.target = CHUGABUD_RADIANT_MACHINE_NAME;
	perk_machine.script_string = "chugabud_perk";
	perk_machine.targetname = CHUGABUD_RADIANT_MACHINE_NAME;
	if( IsDefined( bump_trigger ) )
	{
		bump_trigger.script_string = "chugabud_perk";
	}
}

function init_chugabud()
{
	level.whoswho_laststand_func = &chugabud_laststand;
	level._effect[ "chugabud_revive_fx" ] = "weapon/quantum_bomb/fx_player_position_effect";
	level._effect[ "chugabud_bleedout_fx" ] = "weapon/quantum_bomb/fx_player_position_effect";
	zm_weapons::add_custom_limited_weapon_check( &is_weapon_available_in_chugabud_corpse );
	if( IsDefined( level.vsmgr_prio_visionset_zm_whos_who ) )
	{
		visionset_mgr::register_info( "visionset", "zm_whos_who", VERSION_TU5, level.vsmgr_prio_visionset_zm_whos_who, 1, true );
	}
}

function chugabud_perk_activate()
{
	self.lives = 1;
	self notify( "perk_chugabud_activated" );

	/***************************** WARDOGSK93: Start *****************************/
	addon_message = "hud|";
	addon_message += PERK_WHOSWHO + "|";
	addon_message += "give";

	wardog_addon::send_addon_message("Unknown", ADDON_NAME_PERK_HUD, addon_message, self);
	/***************************** WARDOGSK93: End *****************************/
}

/***************************** WARDOGSK93: Start *****************************/
function take_perk(b_pause, str_perk, str_result)
{
	addon_message = "hud|";
	addon_message += PERK_WHOSWHO + "|";
	addon_message += "take";

	wardog_addon::send_addon_message("Unknown", ADDON_NAME_PERK_HUD, addon_message, self);
}
/***************************** WARDOGSK93: End *****************************/

function chugabud_laststand()
{
	self endon( "player_suicide" );
	self endon( "disconnect" );
	self endon( "chugabud_bleedout" );
	self zm_laststand::increment_downed_stat();
	self.ignore_insta_kill = true;
	self.health = self.maxhealth;
	b_has_electric_cherry = false;
	if( self HasPerk( PERK_ELECTRIC_CHERRY ) )
	{
		b_has_electric_cherry = true;
	}
	self chugabud_save_loadout();
	self chugabud_fake_death();
	wait 3;
	if( IsDefined( b_has_electric_cherry ) && b_has_electric_cherry )
	{
		self zm_perk_electric_cherry::electric_cherry_laststand();
		wait 2;
	}
	if( ( IsDefined( self.insta_killed ) && self.insta_killed ) || IsDefined( self.disable_chugabud_corpse ) )
	{
		create_corpse = false;
	}
	else
	{
		create_corpse = true;
	}
	if( create_corpse )
	{
		if( IsDefined( level._chugabug_reject_corpse_override_func ) )
		{
			reject_corpse = self [[ level._chugabug_reject_corpse_override_func ]]( self.origin );
			if( reject_corpse )
			{
				create_corpse = false;
			}
		}
	}
	if( create_corpse )
	{
		self thread activate_chugabud_effects_and_audio();
		corpse = self chugabud_spawn_corpse();
		corpse thread chugabud_corpse_revive_icon( self );
		self.e_chugabud_corpse = corpse;
		corpse thread chugabud_corpse_cleanup_on_spectator( self );
		if( IsDefined( level.whos_who_client_setup ) )
		{
			corpse clientfield::set( "clientfield_whos_who_clone_glow_shader", 1 );
		}
	}
	self chugabud_fake_revive();
	wait 0.1;
	self.ignore_insta_kill = undefined;
	self.disable_chugabud_corpse = undefined;
	if( !create_corpse )
	{
		self notify( "chugabud_effects_cleanup" );
		return;
	}
	bleedout_time = GetDvarfloat( "player_lastStandBleedoutTime" );
	self thread chugabud_bleed_timeout( bleedout_time, corpse );
	self thread chugabud_handle_multiple_instances( corpse );
	corpse waittill( "player_revived", e_reviver );
	if( IsDefined( e_reviver ) && e_reviver == self )
	{
		self notify( "whos_who_self_revive" );
	}
	self zm_perks::perk_abort_drinking( 0.1 );
	self zm_perks::perk_set_max_health_if_jugg( "health_reboot", true, false );
	self SetOrigin( corpse.origin );
	self SetPlayerAngles( corpse.angles );
	if( self laststand::player_is_in_laststand() )
	{
		self thread chugabud_laststand_cleanup( corpse, "player_revived" );
		self EnableWeaponCycling();
		self EnableOffhandWeapons();
		self zm_laststand::auto_revive( self, true );
		return;
	}
	self chugabud_laststand_cleanup( corpse, undefined );
}

function chugabud_laststand_cleanup( corpse, str_notify )
{
	if( IsDefined( str_notify ) )
	{
		self waittill( str_notify );
	}
	self chugabud_give_loadout();
	self chugabud_corpse_cleanup( corpse, true );
}

function chugabud_bleed_timeout( delay, corpse )
{
	self endon( "player_suicide" );
	self endon( "disconnect" );
	corpse endon( "death" );
	wait delay;
	if( IsDefined( corpse.revivetrigger ) )
	{
		while( corpse.revivetrigger.beingrevived )
		{
			WAIT_SERVER_FRAME;
		}
	}
	if( IsDefined( self.loadout.perks ) && level flag::get( "solo_game" ) )
	{
		for( i = 0; i < self.loadout.perks.size; i ++ )
		{
			perk = self.loadout.perks[i];
			if( perk == PERK_QUICK_REVIVE )
			{
				ArrayRemoveValue( self.loadout.perks, self.loadout.perks[i] );
				corpse notify( "player_revived", self );
				return;
			}
		}
	}
	self chugabud_corpse_cleanup( corpse, false );
}

function chugabud_corpse_cleanup( corpse, was_revived )
{
	self notify( "chugabud_effects_cleanup" );
	if( was_revived )
	{
		PlaySoundAtPosition( "evt_ww_appear", corpse.origin );
		PlayFX( level._effect[ "chugabud_revive_fx" ], corpse.origin );
	}
	else
	{
		PlaySoundAtPosition( "evt_ww_disappear", corpse.origin );
		PlayFX( level._effect[ "chugabud_bleedout_fx" ], corpse.origin );
		self notify( "chugabud_bleedout" );
	}
	if( IsDefined( corpse.revivetrigger ) )
	{
		corpse notify( "disconnect" );
		corpse.revivetrigger Delete();
		corpse.revivetrigger = undefined;
	}
	if( IsDefined( corpse.revive_hud_elem ) )
	{
		corpse.revive_hud_elem Destroy();
		corpse.revive_hud_elem = undefined;
	}
	self.loadout = undefined;
	wait 0.1;
	corpse Delete();
	self.e_chugabud_corpse = undefined;
}

function chugabud_handle_multiple_instances( corpse )
{
	corpse endon( "death" );
	self waittill( "perk_chugabud_activated" );
	self chugabud_corpse_cleanup( corpse, false );
}

#using_animtree( "all_player" );
function chugabud_spawn_corpse()
{
	trace_start = self.origin;
	trace_end = self.origin - ( 0, 0, 500 );
	corpse_trace = PlayerPhysicsTrace( trace_start, trace_end );
	corpse = zm_clone::spawn_player_clone( self, corpse_trace, level.weaponNone, self.whos_who_shader );
	corpse.angles = self.angles;
	corpse zm_clone::clone_give_weapon( GetWeapon( "m1911" ) );
	corpse UseAnimTree( #animtree );
	corpse AnimScripted( "clone_anim", corpse.origin, corpse.angles, "pb_laststand_idle" );
	corpse.revive_hud = self.revive_hud;
	corpse thread zm_laststand::revive_trigger_spawn();
	return corpse;
}

function chugabud_save_loadout()
{
	primaries = self GetWeaponsListPrimaries();
	currentweapon = self GetCurrentWeapon();
	self.loadout = SpawnStruct();
	self.loadout.player = self;
	self.loadout.weapons = [];
	self.loadout.score = self.score;
	self.loadout.current_weapon = -1;
	for( i = 0; i < primaries.size; i ++ )
	{
		weapon = primaries[i];
		self.loadout.weapons[i] = zm_weapons::get_player_weapondata( self, weapon );
		if( weapon == currentweapon || weapon.altWeapon == currentweapon )
		{
			self.loadout.current_weapon = i;
		}
	}
	self.loadout.equipment = self zm_equipment::get_player_equipment();
	if( IsDefined( self.loadout.equipment ) )
	{
		self zm_equipment::take( self.loadout.equipment );
	}
	self.loadout save_weapons_for_chugabud( self );
	if( self HasWeapon( level.placeable_mines[ "bouncingbetty" ] ) )
	{
		self.loadout.hasbouncingbetty = true;
		self.loadout.bouncingbettyclip = self GetWeaponAmmoClip( level.placeable_mines[ "bouncingbetty" ] );
	}
	self.loadout.perks = chugabud_save_perks( self );
	self chugabud_save_grenades();
	if( _zm_weap_cymbal_monkey::cymbal_monkey_exists( level.weaponZMCymbalMonkey ) )
	{
		self.loadout.zombie_cymbal_monkey_count = self GetWeaponAmmoClip( level.weaponZMCymbalMonkey );
	}
}

function chugabud_save_grenades()
{
	if( self HasWeapon( level.w_octobomb ) )
	{
		self.loadout.hasoctobomb = true;
		self.loadout.octobombclip = self GetWeaponAmmoClip( level.w_octobomb );
	}
	lethal_grenade = self zm_utility::get_player_lethal_grenade();
	if( self HasWeapon( lethal_grenade ) )
	{
		self.loadout.lethal_grenade = lethal_grenade;
		self.loadout.lethal_grenade_count = self GetWeaponAmmoClip( lethal_grenade );
	}
	else
	{
		self.loadout.lethal_grenade = undefined;
	}
}

function chugabud_give_loadout()
{
	self TakeAllWeapons();
	loadout = self.loadout;
	primaries = self GetWeaponsListPrimaries();
	if( loadout.weapons.size > 1 && primaries.size > 1 )
	{
		for( i = 0; i < primaries.size; i ++ )
		{
			weapon = primaries[i];
			self TakeWeapon( weapon );
		}
	}
	for( i = 0; i < loadout.weapons.size; i ++ )
	{
		if( !IsDefined( loadout.weapons[i] ) )
		{
			continue;
		}
		else if( loadout.weapons[i][ "weapon" ] == level.weaponNone )
		{
			continue;
		}
		else
		{
			self zm_weapons::weapondata_give( loadout.weapons[i] );
		}
	}
	if( loadout.current_weapon >= 0 && IsDefined( loadout.weapons[ loadout.current_weapon ][ "weapon" ] ) )
	{
		self SwitchToWeapon( loadout.weapons[ loadout.current_weapon ][ "weapon" ] );
	}
	self GiveWeapon( level.weaponBaseMelee );
	self zm_equipment::give( self.loadout.equipment );
	loadout restore_weapons_for_chugabud( self );
	self chugabud_restore_bouncingbetty();
	self.score = loadout.score;
	self.pers[ "score" ] = loadout.score;
	perk_array = zm_perks::get_perk_array();
	for( i = 0; i < perk_array.size; i ++ )
	{
		perk = perk_array[i];
		perk_str = perk + "_stop";
		self notify( perk_str );
		if( level flag::get( "solo_game" ) && perk == PERK_QUICK_REVIVE )
		{
			self.lives --;
		}
	}
	if( IsDefined( loadout.perks ) && loadout.perks.size > 0 )
	{
		for( i = 0; i < loadout.perks.size; i ++ )
		{
			if( self HasPerk( loadout.perks[i] ) )
			{
				continue;
			}
			else if( loadout.perks[i] == PERK_QUICK_REVIVE && level flag::get( "solo_game" ) )
			{
				level.solo_game_free_player_quickrevive = true;
			}
			if( loadout.perks[i] == PERK_WHOSWHO )
			{
				continue;
			}
			else
			{
				self zm_perks::give_perk( loadout.perks[i] );
			}
		}
	}
	self chugabud_restore_grenades();
	if( _zm_weap_cymbal_monkey::cymbal_monkey_exists( level.weaponZMCymbalMonkey ) )
	{
		if( loadout.zombie_cymbal_monkey_count )
		{
			self _zm_weap_cymbal_monkey::player_give_cymbal_monkey();
			self SetWeaponAmmoClip( level.weaponZMCymbalMonkey, loadout.zombie_cymbal_monkey_count );
		}
	}
}

function chugabud_restore_grenades()
{
	if( IsDefined( self.loadout.hasoctobomb ) && self.loadout.hasoctobomb )
	{
		self GiveWeapon( level.w_octobomb );
		self SetWeaponAmmoClip( level.w_octobomb, self.loadout.octobombclip );
	}
	if( IsDefined( self.loadout.lethal_grenade ) )
	{
		self GiveWeapon( self.loadout.lethal_grenade );
		self SetWeaponAmmoClip( self.loadout.lethal_grenade, self.loadout.lethal_grenade_count );
	}
}

function chugabud_restore_bouncingbetty()
{
	if( IsDefined( self.loadout.hasbouncingbetty ) && self.loadout.hasbouncingbetty && !self HasWeapon( level.placeable_mines[ "bouncingbetty" ] ) )
	{
		self GiveWeapon( level.placeable_mines[ "bouncingbetty" ] );
		self zm_utility::set_player_placeable_mine( level.placeable_mines[ "bouncingbetty" ] );
		self SetActionSlot( 4, "weapon", level.placeable_mines[ "bouncingbetty" ] );
		self SetWeaponAmmoClip( level.placeable_mines[ "bouncingbetty" ], self.loadout.bouncingbettyclip );
	}
}

function chugabud_fake_death()
{
	level notify( "fake_death" );
	self notify( "fake_death" );
	self TakeAllWeapons();
	self AllowStand( false );
	self AllowCrouch( false );
	self AllowProne( true );
	self zm_utility::increment_ignoreme();
	self EnableInvulnerability();
	wait 0.1;
	self FreezeControls( true );
	wait 0.9;
}

function chugabud_fake_revive()
{
	level notify( "fake_revive" );
	self notify( "fake_revive" );
	PlaySoundAtPosition( "evt_ww_disappear", self.origin );
	PlayFX( level._effect[ "chugabud_revive_fx" ], self.origin );
	spawnpoint = chugabud_get_spawnpoint();
	if( IsDefined( level._chugabud_post_respawn_override_func ) )
	{
		self [[ level._chugabud_post_respawn_override_func ]]( spawnpoint.origin );
	}
	if( IsDefined( level.chugabud_force_corpse_position ) )
	{
		if( IsDefined( self.e_chugabud_corpse ) )
		{
			self.e_chugabud_corpse.origin = level.chugabud_force_corpse_position;
		}
		level.chugabud_force_corpse_position = undefined;
	}
	if( IsDefined( level.chugabud_force_player_position ) )
	{
		spawnpoint.origin = level.chugabud_force_player_position;
		level.chugabud_force_player_position = undefined;
	}
	self SetOrigin( spawnpoint.origin );
	self SetPlayerAngles( spawnpoint.angles );
	PlaySoundAtPosition( "evt_ww_appear", spawnpoint.origin );
	PlayFX( level._effect[ "chugabud_revive_fx" ], spawnpoint.origin );
	self AllowStand( true );
	self AllowCrouch( true );
	self AllowProne( true );
	self zm_utility::decrement_ignoreme();
	self SetStance( "stand" );
	self FreezeControls( false );
	self GiveWeapon( level.weaponBaseMelee );
	self zm_utility::give_start_weapon( true );
	self.score = self.loadout.score;
	self.pers[ "score" ] = self.loadout.score;
	self GiveWeapon( level.zombie_lethal_grenade_player_init );
	self SetWeaponAmmoClip( level.zombie_lethal_grenade_player_init, 2 );
	self chugabud_restore_bouncingbetty();
	wait 1;
	self DisableInvulnerability();
}

function chugabud_get_spawnpoint()
{
	spawnpoint = undefined;
	if( get_chugabug_spawn_point_from_nodes( self.origin, 500, 700, 64, true ) )
	{
		spawnpoint = level.chugabud_spawn_struct;
	}
	if( !IsDefined( spawnpoint ) )
	{
		if( get_chugabug_spawn_point_from_nodes( self.origin, 100, 400, 64, true ) )
		{
			spawnpoint = level.chugabud_spawn_struct;
		}
	}
	if( !IsDefined( spawnpoint ) )
	{
		if( get_chugabug_spawn_point_from_nodes( self.origin, 50, 400, 256, false ) )
		{
			spawnpoint = level.chugabud_spawn_struct;
		}
	}
	if( !IsDefined( spawnpoint ) )
	{
		spawnpoint = zm::check_for_valid_spawn_near_team( self, true );
	}
	if( !IsDefined( spawnpoint ) )
	{
		location = level.scr_zm_map_start_location;
		if( ( location == "default" || location == "" ) && IsDefined( level.default_start_location ) )
		{
			location = level.default_start_location;
		}
		match_string = level.scr_zm_ui_gametype + "_" + location;
		spawnpoints = [];
		structs = struct::get_array( "initial_spawn", "script_noteworthy" );
		if( IsDefined( structs ) )
		{
			for( i = 0; i < structs.size; i ++ )
			{
				struct = structs[i];
				if( IsDefined( struct.script_string ) )
				{
					tokens = StrTok( struct.script_string, " " );
					for( t = 0; t < tokens.size; t ++ )
					{
						token = tokens[t];
						if( token == match_string )
						{
							spawnpoints[ spawnpoints.size ] = struct;
						}
					}
				}
			}
		}
		if( !IsDefined( spawnpoints ) || spawnpoints.size == 0 )
		{
			spawnpoints = struct::get_array( "initial_spawn_points", "targetname" );
		}
		spawnpoint = zm::getFreeSpawnpoint( spawnpoints, self );
	}
	return spawnpoint;
}

function get_chugabug_spawn_point_from_nodes( v_origin, min_radius, max_radius, max_height, ignore_targetted_nodes )
{
	if( !IsDefined( level.chugabud_spawn_struct ) )
	{
		level.chugabud_spawn_struct = SpawnStruct();
	}
	found_node = undefined;
	a_nodes = GetNodesInRadiusSorted( v_origin, max_radius, min_radius, max_height, "pathnodes" );
	if( IsDefined( a_nodes ) && a_nodes.size > 0 )
	{
		a_player_volumes = GetEntArray( "player_volume", "script_noteworthy" );
		index = a_nodes.size - 1;
		for( i = index; i >= 0; i -- )
		{
			n_node = a_nodes[i];
			if( ignore_targetted_nodes )
			{
				if( IsDefined( n_node.target ) )
				{
					continue;
				}
			}
			if( !PositionWouldTelefrag( n_node.origin ) )
			{
				if( zm_utility::check_point_in_enabled_zone( n_node.origin, true, a_player_volumes ) )
				{
					v_start = ( n_node.origin[0], n_node.origin[1], n_node.origin[2] + 30 );
					v_end = ( n_node.origin[0], n_node.origin[1], n_node.origin[2] - 30 );
					trace = BulletTrace( v_start, v_end, false, undefined );
					if( trace[ "fraction" ] < 1 )
					{
						override_abort = false;
						if( IsDefined( level._chugabud_reject_node_override_func ) )
						{
							override_abort = [[ level._chugabud_reject_node_override_func ]]( v_origin, n_node );
						}
						if( !override_abort )
						{
							found_node = n_node;
							break;
						}
					}
				}
			}
		}
	}
	if( IsDefined( found_node ) )
	{
		level.chugabud_spawn_struct.origin = found_node.origin;
		v_dir = VectorNormalize( v_origin - level.chugabud_spawn_struct.origin );
		level.chugabud_spawn_struct.angles = VectortoAngles( v_dir );
		return true;
	}
	return false;
}

function force_corpse_respawn_position( forced_corpse_position )
{
	level.chugabud_force_corpse_position = forced_corpse_position;
}

function force_player_respawn_position( forced_player_position )
{
	level.chugabud_force_player_position = forced_player_position;
}

function save_weapons_for_chugabud( player )
{
	self.chugabud_melee_weapons = [];
	for( i = 0; i < level._melee_weapons.size; i ++ )
	{
		self save_weapon_for_chugabud( player, level._melee_weapons[i].weapon );
	}
}

function save_weapon_for_chugabud( player, weapon )
{
	if( player HasWeapon( weapon ) )
	{
		self.chugabud_melee_weapons[ weapon ] = true;
	}
}

function restore_weapons_for_chugabud( player )
{
	for( i = 0; i < level._melee_weapons.size; i ++ )
	{
		self restore_weapon_for_chugabud( player, level._melee_weapons[i].weapon );
	}
	self.chugabud_melee_weapons = undefined;
}

function restore_weapon_for_chugabud( player, weapon )
{
	if( !IsDefined( weapon ) || !IsDefined( self.chugabud_melee_weapons ) || !IsDefined( self.chugabud_melee_weapons[ weapon ] ) )
	{
		return;
	}
	if( IsDefined( self.chugabud_melee_weapons[ weapon ] ) && self.chugabud_melee_weapons[ weapon ] )
	{
		player zm_weapons::give_build_kit_weapon( weapon );
		player zm_utility::set_player_melee_weapon( weapon );
		self.chugabud_melee_weapons[ weapon ] = false;
	}
}

function chugabud_save_perks( ent )
{
	perk_array = ent zm_perks::get_perk_array();
	for( i = 0; i < perk_array.size; i ++ )
	{
		perk = perk_array[i];
		ent UnSetPerk( perk );
	}
	return perk_array;
}

function player_has_chugabud_corpse()
{
	if( IsDefined( self.e_chugabud_corpse ) )
	{
		return true;
	}
	return false;
}

function is_weapon_available_in_chugabud_corpse( weapon, player_to_check )
{
	count = 0;
	upgradedweapon = weapon;
	if( IsDefined( level.zombie_weapons[ weapon ] ) && IsDefined( level.zombie_weapons[ weapon ].upgrade ) )
	{
		upgradedweapon = level.zombie_weapons[ weapon ].upgrade;
	}
	players = GetPlayers();
	if( IsDefined( players ) )
	{
		for( player_index = 0; player_index < players.size; player_index ++ )
		{
			player = players[ player_index ];
			if( IsDefined( player_to_check ) && player != player_to_check )
			{
				continue;
			}
			else
			{
				if( player player_has_chugabud_corpse() )
				{
					if( IsDefined( player.loadout ) && IsDefined( player.loadout.weapons ) )
					{
						for( i = 0; i < player.loadout.weapons.size; i ++ )
						{
							chugabud_weapon = player.loadout.weapons[i];
							if( IsDefined( chugabud_weapon ) && ( chugabud_weapon[ "weapon" ] == weapon || chugabud_weapon[ "weapon" ] == upgradedweapon ) )
							{
								count ++;
							}
						}
					}
				}
			}
		}
	}
	return count;
}

function chugabud_corpse_cleanup_on_spectator( player )
{
	self endon( "death" );
	player endon( "disconnect" );
	while( true )
	{
		if( player.sessionstate == "spectator" )
		{
			break;
		}
		else
		{
			WAIT_SERVER_FRAME;
		}
	}
	player chugabud_corpse_cleanup( self, false );
}

function chugabud_corpse_revive_icon( player )
{
	self endon( "death" );
	height_offset = 30;
	hud_elem = NewHudElem();
	self.revive_hud_elem = hud_elem;
	hud_elem.x = self.origin[0];
	hud_elem.y = self.origin[1];
	hud_elem.z = self.origin[2] + height_offset;
	hud_elem.alpha = 1;
	hud_elem.archived = true;
	hud_elem SetShader( "sanchez_waypoint_revive", 5, 5 );
	hud_elem SetWayPoint( true );
	hud_elem.hidewheninmenu = true;
	hud_elem.immunetodemogamehudsettings = true;
	while( true )
	{
		if( !IsDefined( self.revive_hud_elem ) )
		{
			return;
		}
		else
		{
			hud_elem.x = self.origin[0];
			hud_elem.y = self.origin[1];
			hud_elem.z = self.origin[2] + height_offset;
			WAIT_SERVER_FRAME;
		}
	}
}

function activate_chugabud_effects_and_audio()
{
	if( IsDefined( level.whos_who_client_setup ) )
	{
		if( !IsDefined( self.whos_who_effects_active ) )
		{
			if( IsDefined( level.chugabud_shellshock ) )
			{
				self ShellShock( "whoswho", 60 );
			}
			if( IsDefined( level.vsmgr_prio_visionset_zm_whos_who ) )
			{
				visionset_mgr::activate( "visionset", "zm_whos_who", self );
			}
			self clientfield::set_to_player( "clientfield_whos_who_audio", 1 );
			self clientfield::set_to_player( "clientfield_whos_who_filter", 1 );
			self.whos_who_effects_active = true;
			self thread deactivate_chugabud_effects_and_audio();
		}
	}
}

function deactivate_chugabud_effects_and_audio()
{
	self util::waittill_any( "death", "chugabud_effects_cleanup" );
	if( IsDefined( level.whos_who_client_setup ) )
	{
		if( IsDefined( self.whos_who_effects_active ) && self.whos_who_effects_active )
		{
			if( IsDefined( level.chugabud_shellshock ) )
			{
				self StopShellShock();
			}
			if( IsDefined( level.vsmgr_prio_visionset_zm_whos_who ) )
			{
				visionset_mgr::deactivate( "visionset", "zm_whos_who", self );
			}
			self clientfield::set_to_player( "clientfield_whos_who_audio", 0 );
			self clientfield::set_to_player( "clientfield_whos_who_filter", 0 );
		}
		self.whos_who_effects_active = undefined;
	}
}
