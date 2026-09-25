#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\duplicaterenderbundle;
#using scripts\shared\filter_shared;
#using scripts\shared\gfx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace postfx;

/*
	Name: __init__sytem__
	Namespace: postfx
	Checksum: 0x228DCDFC
	Offset: 0x248
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("postfx_bundle", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: postfx
	Checksum: 0xB149BFC0
	Offset: 0x288
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_localplayer_spawned(&localplayer_postfx_bundle_init);
}

/*
	Name: localplayer_postfx_bundle_init
	Namespace: postfx
	Checksum: 0xDC4EFC84
	Offset: 0x2B8
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function localplayer_postfx_bundle_init(localClientNum)
{
	init_postfx_bundles();
}

/*
	Name: init_postfx_bundles
	Namespace: postfx
	Checksum: 0x6938A182
	Offset: 0x2E0
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function init_postfx_bundles()
{
	if(isdefined(self.postfxBundelsInited))
	{
		return;
	}
	self.postfxBundelsInited = 1;
	self.playingPostfxBundle = "";
	self.forceStopPostfxBundle = 0;
	self.exitPostfxBundle = 0;
	/#
		self thread function_6743421b();
	#/
}

/*
	Name: function_6743421b
	Namespace: postfx
	Checksum: 0x8D0A5480
	Offset: 0x350
	Size: 0x1BF
	Parameters: 0
	Flags: None
*/
function function_6743421b()
{
	/#
		self endon("entityshutdown");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		while(1)
		{
			playBundleName = GetDvarString("Dev Block strings are not supported");
			if(playBundleName != "Dev Block strings are not supported")
			{
				self thread playPostfxBundle(playBundleName);
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			var_7802baf4 = GetDvarString("Dev Block strings are not supported");
			if(var_7802baf4 != "Dev Block strings are not supported")
			{
				self thread StopPostfxBundle();
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			var_7802baf4 = GetDvarString("Dev Block strings are not supported");
			if(var_7802baf4 != "Dev Block strings are not supported")
			{
				self thread exitPostfxBundle();
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			wait(0.5);
		}
	#/
}

/*
	Name: playPostfxBundle
	Namespace: postfx
	Checksum: 0x50299743
	Offset: 0x518
	Size: 0x8B3
	Parameters: 1
	Flags: None
*/
function playPostfxBundle(playBundleName)
{
	self endon("entityshutdown");
	self endon("death");
	init_postfx_bundles();
	stopPlayingPostfxBundle();
	bundle = struct::get_script_bundle("postfxbundle", playBundleName);
	if(!isdefined(bundle))
	{
		/#
			println("Dev Block strings are not supported" + playBundleName + "Dev Block strings are not supported");
		#/
		return;
	}
	filterid = 0;
	totalAccumTime = 0;
	filter::init_filter_indices();
	self.playingPostfxBundle = playBundleName;
	localClientNum = self.localClientNum;
	looping = 0;
	enterStage = 0;
	exitStage = 0;
	finishLoopOnExit = 0;
	firstPersonOnly = 0;
	if(isdefined(bundle.looping))
	{
		looping = bundle.looping;
	}
	if(isdefined(bundle.enterStage))
	{
		enterStage = bundle.enterStage;
	}
	if(isdefined(bundle.exitStage))
	{
		exitStage = bundle.exitStage;
	}
	if(isdefined(bundle.finishLoopOnExit))
	{
		finishLoopOnExit = bundle.finishLoopOnExit;
	}
	if(isdefined(bundle.firstPersonOnly))
	{
		firstPersonOnly = bundle.firstPersonOnly;
	}
	if(looping)
	{
		num_stages = 1;
		if(enterStage)
		{
			num_stages++;
		}
		if(exitStage)
		{
			num_stages++;
		}
	}
	else
	{
		num_stages = bundle.num_stages;
	}
	self.captureImageName = undefined;
	if(isdefined(bundle.screenCapture) && bundle.screenCapture)
	{
		self.captureImageName = playBundleName;
		CreateSceneCodeImage(localClientNum, self.captureImageName);
		CaptureFrame(localClientNum, self.captureImageName);
		setFilterPassCodeTexture(localClientNum, filterid, 0, 0, self.captureImageName);
	}
	self thread watchEntityShutdown(localClientNum, filterid);
	for(stageIdx = 0; stageIdx < num_stages && !self.forceStopPostfxBundle; stageIdx++)
	{
		stagePrefix = "s";
		if(stageIdx < 10)
		{
			stagePrefix = stagePrefix + "0";
		}
		stagePrefix = stagePrefix + stageIdx + "_";
		stageLength = GetStructField(bundle, stagePrefix + "length");
		if(!isdefined(stageLength))
		{
			finishPlayingPostfxBundle(localClientNum, stagePrefix + "length not defined", filterid);
			return;
		}
		stageLength = stageLength * 1000;
		stageMaterial = GetStructField(bundle, stagePrefix + "material");
		if(!isdefined(stageMaterial))
		{
			finishPlayingPostfxBundle(localClientNum, stagePrefix + "material not defined", filterid);
			return;
		}
		filter::map_material_helper(self, stageMaterial);
		setfilterpassmaterial(localClientNum, filterid, 0, filter::mapped_material_id(stageMaterial));
		setfilterpassenabled(localClientNum, filterid, 0, 1, 0, firstPersonOnly);
		stageCapture = GetStructField(bundle, stagePrefix + "screenCapture");
		if(isdefined(stageCapture) && stageCapture)
		{
			if(isdefined(self.captureImageName))
			{
				FreeCodeImage(localClientNum, self.captureImageName);
				self.captureImageName = undefined;
				setFilterPassCodeTexture(localClientNum, filterid, 0, 0, "");
			}
			self.captureImageName = stagePrefix + playBundleName;
			CreateSceneCodeImage(localClientNum, self.captureImageName);
			CaptureFrame(localClientNum, self.captureImageName);
			setFilterPassCodeTexture(localClientNum, filterid, 0, 0, self.captureImageName);
		}
		stageSprite = GetStructField(bundle, stagePrefix + "spriteFilter");
		if(isdefined(stageSprite) && stageSprite)
		{
			setfilterpassquads(localClientNum, filterid, 0, 2048);
		}
		else
		{
			setfilterpassquads(localClientNum, filterid, 0, 0);
		}
		thermal = GetStructField(bundle, stagePrefix + "thermal");
		EnableThermalDraw(localClientNum, isdefined(thermal) && thermal);
		loopingStage = looping && (!enterStage && stageIdx == 0 || (enterStage && stageIdx == 1));
		accumTime = 0;
		prevtime = self getClientTime();
		while(loopingStage || accumTime < stageLength && !self.forceStopPostfxBundle)
		{
			gfx::SetStage(localClientNum, bundle, filterid, stagePrefix, stageLength, accumTime, totalAccumTime, &SetFilterConstants);
			wait(0.016);
			currTime = self getClientTime();
			deltaTime = currTime - prevtime;
			accumTime = accumTime + deltaTime;
			totalAccumTime = totalAccumTime + deltaTime;
			prevtime = currTime;
			if(loopingStage)
			{
				while(accumTime >= stageLength)
				{
					accumTime = accumTime - stageLength;
				}
				if(self.exitPostfxBundle)
				{
					loopingStage = 0;
					if(!finishLoopOnExit)
					{
						break;
					}
				}
			}
		}
		setfilterpassenabled(localClientNum, filterid, 0, 0);
	}
	finishPlayingPostfxBundle(localClientNum, "Finished " + playBundleName, filterid);
}

/*
	Name: watchEntityShutdown
	Namespace: postfx
	Checksum: 0xEECF8868
	Offset: 0xDD8
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function watchEntityShutdown(localClientNum, filterid)
{
	self util::waittill_any("entityshutdown", "death", "finished_playing_postfx_bundle");
	finishPlayingPostfxBundle(localClientNum, "Entity Shutdown", filterid);
}

/*
	Name: SetFilterConstants
	Namespace: postfx
	Checksum: 0xC9879422
	Offset: 0xE48
	Size: 0x103
	Parameters: 4
	Flags: None
*/
function SetFilterConstants(localClientNum, shaderConstantName, filterid, values)
{
	baseShaderConstIndex = gfx::getShaderConstantIndex(shaderConstantName);
	setfilterpassconstant(localClientNum, filterid, 0, baseShaderConstIndex + 0, values[0]);
	setfilterpassconstant(localClientNum, filterid, 0, baseShaderConstIndex + 1, values[1]);
	setfilterpassconstant(localClientNum, filterid, 0, baseShaderConstIndex + 2, values[2]);
	setfilterpassconstant(localClientNum, filterid, 0, baseShaderConstIndex + 3, values[3]);
}

/*
	Name: finishPlayingPostfxBundle
	Namespace: postfx
	Checksum: 0x4D9B9B49
	Offset: 0xF58
	Size: 0x12D
	Parameters: 3
	Flags: None
*/
function finishPlayingPostfxBundle(localClientNum, msg, filterid)
{
	/#
		if(isdefined(msg))
		{
			println(msg);
		}
	#/
	if(isdefined(self))
	{
		self notify("finished_playing_postfx_bundle");
		self.forceStopPostfxBundle = 0;
		self.exitPostfxBundle = 0;
		self.playingPostfxBundle = "";
	}
	setfilterpassquads(localClientNum, filterid, 0, 0);
	setfilterpassenabled(localClientNum, filterid, 0, 0);
	EnableThermalDraw(localClientNum, 0);
	if(isdefined(self.captureImageName))
	{
		setFilterPassCodeTexture(localClientNum, filterid, 0, 0, "");
		FreeCodeImage(localClientNum, self.captureImageName);
		self.captureImageName = undefined;
	}
}

/*
	Name: stopPlayingPostfxBundle
	Namespace: postfx
	Checksum: 0x83107AC0
	Offset: 0x1090
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function stopPlayingPostfxBundle()
{
	if(self.playingPostfxBundle != "")
	{
		StopPostfxBundle();
	}
}

/*
	Name: StopPostfxBundle
	Namespace: postfx
	Checksum: 0xA81D07EE
	Offset: 0x10C8
	Size: 0x75
	Parameters: 0
	Flags: None
*/
function StopPostfxBundle()
{
	self notify("stopPostfxBundle_singleton");
	self endon("stopPostfxBundle_singleton");
	if(isdefined(self.playingPostfxBundle) && self.playingPostfxBundle != "")
	{
		self.forceStopPostfxBundle = 1;
		while(self.playingPostfxBundle != "")
		{
			wait(0.016);
			if(!isdefined(self))
			{
				return;
			}
		}
	}
}

/*
	Name: exitPostfxBundle
	Namespace: postfx
	Checksum: 0xC55314BB
	Offset: 0x1148
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function exitPostfxBundle()
{
	if(!isdefined(self.exitPostfxBundle) && self.exitPostfxBundle && isdefined(self.playingPostfxBundle) && self.playingPostfxBundle != "")
	{
		self.exitPostfxBundle = 1;
	}
}

/*
	Name: setFrontendStreamingOverlay
	Namespace: postfx
	Checksum: 0x910F2A31
	Offset: 0x1198
	Size: 0x123
	Parameters: 3
	Flags: None
*/
function setFrontendStreamingOverlay(localClientNum, system, enabled)
{
	if(!isdefined(self.overlayClients))
	{
		self.overlayClients = [];
	}
	if(!isdefined(self.overlayClients[localClientNum]))
	{
		self.overlayClients[localClientNum] = [];
	}
	self.overlayClients[localClientNum][system] = enabled;
	foreach(en in self.overlayClients[localClientNum])
	{
		if(en)
		{
			EnableFrontendStreamingOverlay(localClientNum, 1);
			return;
		}
	}
	EnableFrontendStreamingOverlay(localClientNum, 0);
}

