#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace namespace_13425205;

/*
	Name: init
	Namespace: namespace_13425205
	Checksum: 0xC0F65DD8
	Offset: 0x250
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function init()
{
	var_8b462b02 = GetMinBitCountForNum(2);
	var_fbab08c0 = GetMinBitCountForNum(3);
	clientfield::register("scriptmover", "spider_queen_mouth_weakspot", 9000, var_8b462b02, "int", &function_4bd58cb8, 0, 0);
	clientfield::register("scriptmover", "spider_queen_bleed", 9000, 1, "counter", &function_dfc06604, 0, 0);
	clientfield::register("scriptmover", "spider_queen_stage_bleed", 9000, var_fbab08c0, "int", &function_e658f597, 0, 0);
	clientfield::register("scriptmover", "spider_queen_emissive_material", 9000, 1, "int", &function_5945974f, 0, 0);
}

/*
	Name: function_4bd58cb8
	Namespace: namespace_13425205
	Checksum: 0x7974707B
	Offset: 0x3C0
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_4bd58cb8(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.var_8dd4267f))
	{
		stopfx(localClientNum, self.var_8dd4267f);
		self.var_8dd4267f = undefined;
	}
	if(newVal == 1)
	{
		self.var_8dd4267f = PlayFXOnTag(localClientNum, level._effect["spider_queen_weakspot"], self, "tag_turret");
	}
	else if(newVal == 2)
	{
		self.var_8dd4267f = PlayFXOnTag(localClientNum, level._effect["spider_queen_mouth_glow"], self, "tag_turret");
	}
}

/*
	Name: function_dfc06604
	Namespace: namespace_13425205
	Checksum: 0xA74FC48E
	Offset: 0x4C8
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_dfc06604(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayFXOnTag(localClientNum, level._effect["spider_queen_bleed_sm"], self, "tag_turret");
}

/*
	Name: function_e658f597
	Namespace: namespace_13425205
	Checksum: 0xAAF8E76E
	Offset: 0x540
	Size: 0x14D
	Parameters: 7
	Flags: None
*/
function function_e658f597(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.var_770499e7 = PlayFXOnTag(localClientNum, level._effect["spider_queen_bleed_lg"], self, "tag_turret");
	}
	if(newVal == 2)
	{
		self.var_770499e7 = PlayFXOnTag(localClientNum, level._effect["spider_queen_bleed_md"], self, "tag_turret");
	}
	if(newVal == 3)
	{
		self.var_770499e7 = PlayFXOnTag(localClientNum, level._effect["spider_queen_bleed_md"], self, "tag_turret");
	}
	wait(2.5);
	if(isdefined(self.var_770499e7))
	{
		stopfx(localClientNum, self.var_770499e7);
		self.var_770499e7 = undefined;
	}
}

/*
	Name: function_5945974f
	Namespace: namespace_13425205
	Checksum: 0x18DF7CF9
	Offset: 0x698
	Size: 0xAB
	Parameters: 7
	Flags: None
*/
function function_5945974f(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 1, 1, 1, 0);
	}
	else
	{
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, 0, 0, 0);
	}
}

