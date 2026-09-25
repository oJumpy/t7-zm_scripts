#namespace scripted;

/*
	Name: main
	Namespace: scripted
	Checksum: 0x31C6455E
	Offset: 0x98
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function main()
{
	self endon("death");
	self notify("killanimscript");
	self notify("clearSuppressionAttack");
	self.codeScripted["root"] = %body;
	self endon("end_sequence");
	self.a.script = "scripted";
	self waittill("killanimscript");
}

/*
	Name: init
	Namespace: scripted
	Checksum: 0xA67B02C3
	Offset: 0x118
	Size: 0x4B
	Parameters: 9
	Flags: None
*/
function init(notifyname, origin, angles, theanim, animMode, root, rate, goalTime, lerpTime)
{
}

/*
	Name: end_script
	Namespace: scripted
	Checksum: 0xEA90FC5A
	Offset: 0x170
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function end_script()
{
	if(isdefined(self.___ArchetypeOnBehaveCallback))
	{
		[[self.___ArchetypeOnBehaveCallback]](self);
	}
}

