#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#namespace cpoweronswitch;

/*
	Name: init_poweronswitch
	Namespace: cpoweronswitch
	Checksum: 0x7FD9638B
	Offset: 0x238
	Size: 0x1E3
	Parameters: 6
	Flags: None
*/
function init_poweronswitch(str_areaname, script_int, linkto_target, func, arg1, n_iter)
{
	if(!isdefined(n_iter))
	{
		n_iter = 0;
	}
	a_mdl_switch = GetEntArray("stair_control", "targetname");
	a_mdl_switch = Array::filter(a_mdl_switch, 0, &filter_areaname, str_areaname);
	self.m_mdl_switch = a_mdl_switch[n_iter];
	a_t_switch = GetEntArray("stair_control_usetrigger", "targetname");
	a_t_switch = Array::filter(a_t_switch, 0, &filter_areaname, str_areaname);
	self.m_t_switch = a_t_switch[n_iter];
	self.m_t_switch setHintString(&"ZM_ZOD_POWERSWITCH_UNPOWERED");
	self.m_n_power_index = script_int;
	self.m_func = func;
	self.m_arg1 = arg1;
	self.m_t_switch EnableLinkTo();
	self.m_t_switch LinkTo(self.m_mdl_switch);
	if(isdefined(linkto_target))
	{
		self.m_mdl_switch LinkTo(linkto_target);
	}
	self thread poweronswitch_think();
}

/*
	Name: filter_areaname
	Namespace: cpoweronswitch
	Checksum: 0xECC657E
	Offset: 0x428
	Size: 0x47
	Parameters: 2
	Flags: None
*/
function filter_areaname(e_entity, str_areaname)
{
	if(!isdefined(e_entity.script_string) || e_entity.script_string != str_areaname)
	{
		return 0;
	}
	return 1;
}

/*
	Name: poweronswitch_think
	Namespace: cpoweronswitch
	Checksum: 0x2E261650
	Offset: 0x478
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function poweronswitch_think()
{
	level flag::wait_till("power_on" + self.m_n_power_index);
	local_power_on();
}

/*
	Name: show_activated_state
	Namespace: cpoweronswitch
	Checksum: 0xCA7F8CCA
	Offset: 0x4C0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function show_activated_state()
{
	self.m_t_switch SetInvisibleToAll();
}

/*
	Name: can_player_use
	Namespace: cpoweronswitch
	Checksum: 0x7076DE93
	Offset: 0x4E8
	Size: 0x45
	Parameters: 1
	Flags: None
*/
function can_player_use(player)
{
	if(player zm_utility::in_revive_trigger())
	{
		return 0;
	}
	if(player.IS_DRINKING > 0)
	{
		return 0;
	}
	return 1;
}

/*
	Name: local_power_on
	Namespace: cpoweronswitch
	Checksum: 0xE984FEA1
	Offset: 0x538
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function local_power_on()
{
	self.m_t_switch setHintString(&"ZM_ZOD_POWERSWITCH_POWERED");
	do
	{
		self.m_t_switch waittill("trigger", player);
	}
	while(!!can_player_use(player));
	self.m_t_switch SetInvisibleToAll();
	[[self.m_func]](self.m_arg1);
}

/*
	Name: __constructor
	Namespace: cpoweronswitch
	Checksum: 0x99EC1590
	Offset: 0x5D8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __constructor()
{
}

/*
	Name: __destructor
	Namespace: cpoweronswitch
	Checksum: 0x99EC1590
	Offset: 0x5E8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __destructor()
{
}

#namespace namespace_f7e00735;

/*
	Name: cpoweronswitch
	Namespace: namespace_f7e00735
	Checksum: 0x9F3040A8
	Offset: 0x5F8
	Size: 0x1A5
	Parameters: 0
	Flags: 6
*/
function private autoexec cpoweronswitch()
{
	classes.cpoweronswitch[0] = spawnstruct();
	classes.cpoweronswitch[0].__vtable[1606033458] = &cpoweronswitch::__destructor;
	classes.cpoweronswitch[0].__vtable[-1690805083] = &cpoweronswitch::__constructor;
	classes.cpoweronswitch[0].__vtable[1961570100] = &cpoweronswitch::local_power_on;
	classes.cpoweronswitch[0].__vtable[1746087567] = &cpoweronswitch::can_player_use;
	classes.cpoweronswitch[0].__vtable[1032634776] = &cpoweronswitch::show_activated_state;
	classes.cpoweronswitch[0].__vtable[1587517110] = &cpoweronswitch::poweronswitch_think;
	classes.cpoweronswitch[0].__vtable[469498444] = &cpoweronswitch::filter_areaname;
	classes.cpoweronswitch[0].__vtable[2034542082] = &cpoweronswitch::init_poweronswitch;
}

