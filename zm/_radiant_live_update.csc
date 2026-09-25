#using scripts\codescripts\struct;
#using scripts\shared\system_shared;

#namespace radiant_live_udpate;

/*
	Name: __init__sytem__
	Namespace: radiant_live_udpate
	Checksum: 0x95B1FF47
	Offset: 0xB8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	/#
		system::register("Dev Block strings are not supported", &__init__, undefined, undefined);
	#/
}

/*
	Name: __init__
	Namespace: radiant_live_udpate
	Checksum: 0x689E53D2
	Offset: 0xF8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	/#
		thread scriptstruct_debug_render();
	#/
}

/*
	Name: scriptstruct_debug_render
	Namespace: radiant_live_udpate
	Checksum: 0x536EA647
	Offset: 0x120
	Size: 0x61
	Parameters: 0
	Flags: None
*/
function scriptstruct_debug_render()
{
	/#
		while(1)
		{
			level waittill("liveupdate", selected_struct);
			if(isdefined(selected_struct))
			{
				level thread render_struct(selected_struct);
			}
			else
			{
				level notify("stop_struct_render");
			}
		}
	#/
}

/*
	Name: render_struct
	Namespace: radiant_live_udpate
	Checksum: 0x595B7E89
	Offset: 0x190
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function render_struct(selected_struct)
{
	/#
		self endon("stop_struct_render");
		while(isdefined(selected_struct))
		{
			box(selected_struct.origin, VectorScale((-1, -1, -1), 16), VectorScale((1, 1, 1), 16), 0, (1, 0.4, 0.4));
			wait(0.01);
		}
	#/
}

