#namespace delete;

/*
	Name: main
	Namespace: delete
	Checksum: 0xB5AB1AF4
	Offset: 0x70
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function main()
{
	/#
		Assert(isdefined(self));
	#/
	wait(0);
	if(isdefined(self))
	{
		/#
			if(isdefined(self.classname))
			{
				if(self.classname == "Dev Block strings are not supported" || self.classname == "Dev Block strings are not supported" || self.classname == "Dev Block strings are not supported")
				{
					println("Dev Block strings are not supported");
					println("Dev Block strings are not supported" + self GetEntityNumber() + "Dev Block strings are not supported" + self.origin);
					println("Dev Block strings are not supported");
				}
			}
		#/
		self delete();
	}
}

