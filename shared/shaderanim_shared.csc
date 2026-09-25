#namespace shaderanim;

/*
	Name: animate_crack
	Namespace: shaderanim
	Checksum: 0x959B0108
	Offset: 0x88
	Size: 0x1DB
	Parameters: 6
	Flags: None
*/
function animate_crack(localClientNum, vectorName, delay, duration, start, end)
{
	self endon("entityshutdown");
	delaySeconds = delay / 60;
	wait(delaySeconds);
	direction = 1;
	if(start > end)
	{
		direction = -1;
	}
	durationSeconds = duration / 60;
	valStep = 0;
	if(durationSeconds > 0)
	{
		valStep = end - start / durationSeconds / 0.01;
	}
	timeStep = 0.01 * direction;
	value = start;
	self MapShaderConstant(localClientNum, 0, vectorName, value, 0, 0, 0);
	for(i = 0; i < durationSeconds;  = 0)
	{
		value = value + valStep;
		wait(0.01);
		self MapShaderConstant(localClientNum, 0, vectorName, value, 0, 0, 0);
	}
	self MapShaderConstant(localClientNum, 0, vectorName, end, 0, 0, 0);
}

/*
	Name: shaderanim_update_opacity
	Namespace: shaderanim
	Checksum: 0xA3BC333
	Offset: 0x270
	Size: 0x4B
	Parameters: 3
	Flags: None
*/
function shaderanim_update_opacity(entity, localClientNum, opacity)
{
	entity MapShaderConstant(localClientNum, 0, "scriptVector0", opacity, 0, 0, 0);
}

