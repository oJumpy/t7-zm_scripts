#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\util_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\audio_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_zm_perks;

#insert scripts\zm\_zm_perk_chugabud.gsh;
#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_utility.gsh;

#precache( "client_fx", "zombie/fx_perk_sleight_of_hand_zmb" );

#namespace zm_perk_chugabud;

REGISTER_SYSTEM( "zm_perk_chugabud", &__init__, undefined )

function __init__()
{
	enable_chugabud_perk_for_level();
}

function enable_chugabud_perk_for_level()
{
	zm_perks::register_perk_clientfields( PERK_WHOSWHO, &chugabud_client_field_func, &chugabud_code_callback_func );
	zm_perks::register_perk_effects( PERK_WHOSWHO, CHUGABUD_MACHINE_LIGHT_FX );
	zm_perks::register_perk_init_thread( PERK_WHOSWHO, &init_chuabud );
}

function init_chuabud()
{
	level._effect[ CHUGABUD_MACHINE_LIGHT_FX ] = "zombie/fx_perk_sleight_of_hand_zmb";
	level thread chugabud_setup_afterlife_filters();
}

function chugabud_client_field_func()
{
	clientfield::register( "clientuimodel", PERK_CLIENTFIELD_WHOSWHO, VERSION_SHIP, 2, "int", undefined, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "actor", "clientfield_whos_who_clone_glow_shader", VERSION_TU5, 1, "int", &chugabud_whos_who_shader, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "toplayer", "clientfield_whos_who_audio", VERSION_TU5, 1, "int", &whoswhoaudio, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "toplayer", "clientfield_whos_who_filter", VERSION_TU5, 1, "int", &whoswhofilter, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	//visionset_mgr::register_visionset_info( "zm_whos_who", VERSION_TU5, 1, "zm_whos_who", "zm_whos_who" );
	clientfield::register("toplayer", "vulture_waypoint_whos", VERSION_SHIP, 2, "int", level.zombies_global_perk_client_callback, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT);
}

function chugabud_code_callback_func()
{
}

function chugabud_whos_who_shader( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
	self MapShaderConstant( localclientnum, 0, "scriptVector3" );
	if( newval == 1 )
	{
		n_value = 1;
	}
	else
	{
		n_value = 0;
	}
	self SetShaderConstant( localclientnum, 0, n_value, 0, 0, 0 );
}

function whoswhoaudio( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
	if( newval == 1 )
	{
		activatewwaudio();
	}
	else
	{
		deactivatewwaudio();
	}
}

function whoswhofilter( localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump )
{
	if( newval == 1 )
	{
		player = GetLocalPlayers()[ localclientnum ];
		//enable_filter_afterlife( player, 5 );
	}
	else
	{
		player = GetLocalPlayers()[ localclientnum ];
		//disable_filter_afterlife( player, 5 );
	}
}

function activatewwaudio()
{
	if( !IsDefined( level.sndwwent ) )
	{
		level.sndwwent = Spawn( 0, ( 0, 0, 0 ), "script_origin" );
	}
	PlaySound( 0, "evt_ww_activate", ( 0, 0, 0 ) );
	level.sndwwent PlayLoopSound( "evt_ww_looper", 3 );
	audio::snd_set_snapshot( "zmb_duck_ww" );
}

function deactivatewwaudio()
{
	if( IsDefined( level.sndwwent ) )
	{
		level.sndwwent Delete();
		level.sndwwent = undefined;
	}
	PlaySound( 0, "evt_ww_deactivate", ( 0, 0, 0 ) );
	audio::snd_set_snapshot( "default" );
}

function chugabud_setup_afterlife_filters()
{
	util::waitforallclients();
	wait 1;
	players = GetLocalPlayers();
	for( i = 0; i < players.size; i ++ )
	{
		init_filter_afterlife( players[i] );
	}
}

function init_filter_afterlife( player )
{
	filter::init_filter_indices();
	filter::map_material_helper( player, "generic_filter_afterlife" );
}

function enable_filter_afterlife( player, filterid )
{
	SetFilterPassMaterial( player.localClientNum, filterid, 0, filter::mapped_material_id( "generic_filter_afterlife" ) );
	SetFilterPassEnabled( player.localClientNum, filterid, 0, true );
}

function disable_filter_afterlife( player, filterid )
{
	SetFilterPassEnabled( player.localClientNum, filterid, 0, false );
}
