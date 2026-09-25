#namespace behave;

/*
	Name: main
	Namespace: behave
	Checksum: 0x99EC1590
	Offset: 0x78
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function main()
{
}

/*
	Name: end_script
	Namespace: behave
	Checksum: 0x7FB5B0D5
	Offset: 0x88
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function end_script()
{
	if(isdefined(self.___ArchetypeOnAnimscriptedCallback))
	{
		[[self.___ArchetypeOnAnimscriptedCallback]](self);
	}
}

