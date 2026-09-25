#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\postfx_shared;

#namespace namespace_fad8bcc0;

/*
	Name: main
	Namespace: namespace_fad8bcc0
	Checksum: 0x26529667
	Offset: 0x210
	Size: 0x4B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("actor", "thrasher_mouth_cf", 9000, 8, "int", &ThrasherClientUtils::function_dc24e0f3, 0, 0);
}

#namespace ThrasherClientUtils;

/*
	Name: function_43bf0af5
	Namespace: ThrasherClientUtils
	Checksum: 0x2D446B35
	Offset: 0x268
	Size: 0x73
	Parameters: 3
	Flags: None
*/
function function_43bf0af5(entity, player, State)
{
	entityNumber = player GetEntityNumber();
	var_a2619f0 = 3 << entityNumber * 2;
	return State & var_a2619f0 >> entityNumber * 2;
}

/*
	Name: function_dc24e0f3
	Namespace: ThrasherClientUtils
	Checksum: 0x8D88A21E
	Offset: 0x2E8
	Size: 0x28D
	Parameters: 7
	Flags: Private
*/
function private function_dc24e0f3(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	localPlayer = GetLocalPlayer(localClientNum);
	var_a1af5dd8 = localPlayer getlocalclientnumber();
	oldState = function_43bf0af5(entity, localPlayer, oldValue);
	State = function_43bf0af5(entity, localPlayer, newValue);
	if(oldState == State && localClientNum === var_a1af5dd8)
	{
		return;
	}
	if(localClientNum !== var_a1af5dd8)
	{
		entity thread function_93c1c40c(localClientNum, entity, localPlayer);
		return;
	}
	if(isdefined(entity.var_9ed023df) && entity.var_9ed023df)
	{
		return;
	}
	if(!isdefined(entity.var_18fd72ff) && State != 0)
	{
		entity thread function_4cf5760d(localClientNum, entity, localPlayer);
		entity thread function_785afcbe(localClientNum, entity, localPlayer);
	}
	switch(State)
	{
		case 0:
		{
			entity thread function_93c1c40c(localClientNum, entity, localPlayer);
			break;
		}
		case 1:
		{
			entity thread function_51fb721f(localClientNum, entity, localPlayer);
			break;
		}
		case 2:
		{
			entity thread function_98817801(localClientNum, entity, localPlayer);
			break;
		}
		case 3:
		{
			entity thread function_48032157(localClientNum, entity, localPlayer);
			break;
		}
	}
}

/*
	Name: function_51fb721f
	Namespace: ThrasherClientUtils
	Checksum: 0xB3DB556E
	Offset: 0x580
	Size: 0xBB
	Parameters: 3
	Flags: Private
*/
function private function_51fb721f(localClientNum, thrasher, player)
{
	if(isdefined(thrasher) && isdefined(thrasher.var_18fd72ff))
	{
		thrasher.var_18fd72ff ClearAnim("p7_fxanim_zm_island_thrasher_stomach_close_anim", 0.2);
		thrasher.var_18fd72ff ClearAnim("p7_fxanim_zm_island_thrasher_stomach_open_anim", 0.2);
		thrasher.var_18fd72ff SetAnimRestart("p7_fxanim_zm_island_thrasher_stomach_idle_anim");
	}
}

/*
	Name: function_48032157
	Namespace: ThrasherClientUtils
	Checksum: 0xEC0791A0
	Offset: 0x648
	Size: 0x103
	Parameters: 3
	Flags: Private
*/
function private function_48032157(localClientNum, thrasher, player)
{
	if(isdefined(thrasher) && isdefined(thrasher.var_18fd72ff))
	{
		thrasher.var_18fd72ff ClearAnim("p7_fxanim_zm_island_thrasher_stomach_idle_anim", 0.2);
		thrasher.var_18fd72ff ClearAnim("p7_fxanim_zm_island_thrasher_stomach_open_anim", 0.2);
		thrasher.var_18fd72ff SetAnimRestart("p7_fxanim_zm_island_thrasher_stomach_close_anim");
		player thread LUI::screen_fade(1.5, 0.3, 0);
		player thread postfx::playPostfxBundle("pstfx_thrasher_stomach");
	}
}

/*
	Name: function_98817801
	Namespace: ThrasherClientUtils
	Checksum: 0x1E38FBD1
	Offset: 0x758
	Size: 0x13B
	Parameters: 3
	Flags: Private
*/
function private function_98817801(localClientNum, thrasher, player)
{
	if(isdefined(thrasher) && isdefined(thrasher.var_18fd72ff))
	{
		thrasher.var_18fd72ff ClearAnim("p7_fxanim_zm_island_thrasher_stomach_idle_anim", 0.2);
		thrasher.var_18fd72ff ClearAnim("p7_fxanim_zm_island_thrasher_stomach_close_anim", 0.2);
		thrasher.var_18fd72ff SetAnimRestart("p7_fxanim_zm_island_thrasher_stomach_open_anim");
		player thread LUI::screen_fade_in(2);
		player thread postfx::playPostfxBundle("pstfx_thrasher_stomach");
		animtime = getanimlength("p7_fxanim_zm_island_thrasher_stomach_open_anim");
		wait(animtime);
		function_51fb721f(localClientNum, thrasher, player);
	}
}

/*
	Name: function_4cf5760d
	Namespace: ThrasherClientUtils
	Checksum: 0x13642A57
	Offset: 0x8A0
	Size: 0x41B
	Parameters: 3
	Flags: Private
*/
function private function_4cf5760d(localClientNum, thrasher, player)
{
	thrasher endon("entityshutdown");
	player endon("entityshutdown");
	player endon("hash_d53b1d6d");
	thrasher endon("hash_d53b1d6d");
	eyePosition = player GetTagOrigin("tag_eye");
	eyeOffset = (0, 0, Abs(Abs(eyePosition[2] - player.origin[2]) - 40) - 10);
	thrasher.var_18fd72ff = spawn(localClientNum, thrasher.origin, "script_model");
	thrasher.var_18fd72ff SetModel("p7_fxanim_zm_island_thrasher_stomach_mod");
	thrasher.var_18fd72ff useanimtree(-1);
	var_8cfe2065 = 5;
	forwardOffset = AnglesToForward(thrasher.var_18fd72ff.angles) * var_8cfe2065;
	thrasher.var_18fd72ff.origin = GetCamPosByLocalClientNum(player.localClientNum) - forwardOffset;
	lastPosition = thrasher.var_18fd72ff.origin;
	var_2f57a8ba = (0, 0, 0);
	interpolate = 0.01;
	var_7b5d5a9 = 2;
	var_11a41486 = 0.1;
	var_3c524399 = var_7b5d5a9 * var_7b5d5a9;
	var_dadc8424 = var_11a41486 * var_11a41486;
	while(1)
	{
		forwardOffset = AnglesToForward(thrasher.var_18fd72ff.angles) * var_8cfe2065;
		desiredPosition = thrasher GetTagOrigin("tag_camera_thrasher") + eyeOffset - forwardOffset;
		var_bef3bf12 = GetCamPosByLocalClientNum(player.localClientNum) - forwardOffset;
		var_622b2c1a = desiredPosition - var_bef3bf12;
		if(LengthSquared(var_622b2c1a) > var_3c524399)
		{
			var_622b2c1a = VectorNormalize(var_622b2c1a) * var_7b5d5a9;
		}
		desiredPosition = var_bef3bf12 + var_622b2c1a;
		var_e8cd6d4 = var_622b2c1a - var_2f57a8ba;
		if(LengthSquared(var_e8cd6d4) > var_dadc8424)
		{
			var_622b2c1a = var_2f57a8ba + VectorNormalize(var_e8cd6d4) * var_11a41486;
		}
		thrasher.var_18fd72ff.origin = var_bef3bf12 + var_622b2c1a;
		var_2f57a8ba = var_622b2c1a;
		wait(interpolate);
	}
}

/*
	Name: function_785afcbe
	Namespace: ThrasherClientUtils
	Checksum: 0x58804144
	Offset: 0xCC8
	Size: 0x25D
	Parameters: 3
	Flags: Private
*/
function private function_785afcbe(localClientNum, thrasher, player)
{
	thrasher endon("entityshutdown");
	player endon("entityshutdown");
	player endon("hash_d53b1d6d");
	thrasher endon("hash_d53b1d6d");
	interpolate = 0.016;
	var_e494fe3c = AngleClamp180(GetCamAnglesByLocalClientNum(player.localClientNum)[1]);
	thrasher.var_18fd72ff.angles = (0, var_e494fe3c, 0);
	maxYawDelta = 0.01;
	var_c0756dfb = 2;
	lastTime = player getClientTime() / 1000;
	wait(interpolate);
	while(isdefined(thrasher.var_18fd72ff))
	{
		currentTime = player getClientTime() / 1000;
		var_4a945648 = currentTime - lastTime;
		var_50a8bb46 = thrasher.var_18fd72ff.angles[1];
		newYaw = GetCamAnglesByLocalClientNum(player.localClientNum)[1];
		while(var_4a945648 > interpolate)
		{
			var_50a8bb46 = AngleClamp180(AngleLerp(var_50a8bb46, newYaw, 0.15));
			var_4a945648 = var_4a945648 - interpolate;
		}
		thrasher.var_18fd72ff.angles = (0, var_50a8bb46, 0);
		lastTime = currentTime - var_4a945648;
		wait(interpolate);
	}
}

/*
	Name: function_93c1c40c
	Namespace: ThrasherClientUtils
	Checksum: 0x277F2777
	Offset: 0xF30
	Size: 0xC9
	Parameters: 3
	Flags: Private
*/
function private function_93c1c40c(localClientNum, thrasher, player)
{
	if(isdefined(thrasher))
	{
		thrasher notify("hash_d53b1d6d");
		thrasher.var_9ed023df = 1;
	}
	if(isdefined(player))
	{
		player notify("hash_d53b1d6d");
	}
	if(isdefined(player))
	{
		player thread LUI::screen_fade_in(2);
	}
	if(isdefined(thrasher) && isdefined(thrasher.var_18fd72ff))
	{
		thrasher.var_18fd72ff delete();
		thrasher.var_18fd72ff = undefined;
	}
}

