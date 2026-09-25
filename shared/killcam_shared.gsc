#namespace killcam;

/*
	Name: get_killcam_entity_start_time
	Namespace: killcam
	Checksum: 0xB03FD074
	Offset: 0x78
	Size: 0x79
	Parameters: 1
	Flags: None
*/
function get_killcam_entity_start_time(killcamentity)
{
	killcamentitystarttime = 0;
	if(isdefined(killcamentity))
	{
		if(isdefined(killcamentity.startTime))
		{
			killcamentitystarttime = killcamentity.startTime;
		}
		else
		{
			killcamentitystarttime = killcamentity.birthtime;
		}
		if(!isdefined(killcamentitystarttime))
		{
			killcamentitystarttime = 0;
		}
	}
	return killcamentitystarttime;
}

/*
	Name: store_killcam_entity_on_entity
	Namespace: killcam
	Checksum: 0x9AA781F7
	Offset: 0x100
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function store_killcam_entity_on_entity(killcam_entity)
{
	/#
		Assert(isdefined(killcam_entity));
	#/
	self.killcamentitystarttime = get_killcam_entity_start_time(killcam_entity);
	self.killcamentityindex = killcam_entity GetEntityNumber();
}

