#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\gfx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace duplicate_render_bundle;

/*
	Name: __init__sytem__
	Namespace: duplicate_render_bundle
	Checksum: 0xB03B661A
	Offset: 0x230
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("duplicate_render_bundle", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: duplicate_render_bundle
	Checksum: 0x4FB7160B
	Offset: 0x270
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_localplayer_spawned(&localplayer_duplicate_render_bundle_init);
}

/*
	Name: localplayer_duplicate_render_bundle_init
	Namespace: duplicate_render_bundle
	Checksum: 0x5A01651D
	Offset: 0x2A0
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function localplayer_duplicate_render_bundle_init(localClientNum)
{
	init_duplicate_render_bundles();
}

/*
	Name: init_duplicate_render_bundles
	Namespace: duplicate_render_bundle
	Checksum: 0xBCE53F3F
	Offset: 0x2C8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function init_duplicate_render_bundles()
{
	if(isdefined(self.dupRenderBundelsInited))
	{
		return;
	}
	self.dupRenderBundelsInited = 1;
	self.playingdupRenderBundle = "";
	self.forceStopdupRenderBundle = 0;
	self.exitdupRenderBundle = 0;
	/#
		self thread function_4d534504();
	#/
}

/*
	Name: function_4d534504
	Namespace: duplicate_render_bundle
	Checksum: 0xDF8C00CC
	Offset: 0x338
	Size: 0x1BF
	Parameters: 0
	Flags: None
*/
function function_4d534504()
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
				self thread playDupRenderBundle(playBundleName);
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			var_7802baf4 = GetDvarString("Dev Block strings are not supported");
			if(var_7802baf4 != "Dev Block strings are not supported")
			{
				self thread stopdupRenderBundle();
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			var_7802baf4 = GetDvarString("Dev Block strings are not supported");
			if(var_7802baf4 != "Dev Block strings are not supported")
			{
				self thread exitdupRenderBundle();
				SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			}
			wait(0.5);
		}
	#/
}

/*
	Name: playDupRenderBundle
	Namespace: duplicate_render_bundle
	Checksum: 0x2CC9B982
	Offset: 0x500
	Size: 0x553
	Parameters: 1
	Flags: None
*/
function playDupRenderBundle(playBundleName)
{
	self endon("entityshutdown");
	init_duplicate_render_bundles();
	stopPlayingdupRenderBundle();
	bundle = struct::get_script_bundle("duprenderbundle", playBundleName);
	if(!isdefined(bundle))
	{
		/#
			println("Dev Block strings are not supported" + playBundleName + "Dev Block strings are not supported");
		#/
		return;
	}
	totalAccumTime = 0;
	filter::init_filter_indices();
	self.playingdupRenderBundle = playBundleName;
	localClientNum = self.localClientNum;
	looping = 0;
	enterStage = 0;
	exitStage = 0;
	finishLoopOnExit = 0;
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
	for(stageIdx = 0; stageIdx < num_stages && !self.forceStopdupRenderBundle; stageIdx++)
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
			finishPlayingdupRenderBundle(localClientNum, stagePrefix + " length not defined");
			return;
		}
		stageLength = stageLength * 1000;
		AddDupMaterial(localClientNum, bundle, stagePrefix + "fb_", 0);
		AddDupMaterial(localClientNum, bundle, stagePrefix + "dupfb_", 1);
		AddDupMaterial(localClientNum, bundle, stagePrefix + "sonar_", 2);
		loopingStage = looping && (!enterStage && stageIdx == 0 || (enterStage && stageIdx == 1));
		accumTime = 0;
		prevtime = self getClientTime();
		while(loopingStage || accumTime < stageLength && !self.forceStopdupRenderBundle)
		{
			gfx::SetStage(localClientNum, bundle, undefined, stagePrefix, stageLength, accumTime, totalAccumTime, &SetShaderConstants);
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
				if(self.exitdupRenderBundle)
				{
					loopingStage = 0;
					if(!finishLoopOnExit)
					{
						break;
					}
				}
			}
		}
		self disableduplicaterendering();
	}
	finishPlayingdupRenderBundle(localClientNum, "Finished " + playBundleName);
}

/*
	Name: AddDupMaterial
	Namespace: duplicate_render_bundle
	Checksum: 0xF41254A7
	Offset: 0xA60
	Size: 0x1FB
	Parameters: 4
	Flags: None
*/
function AddDupMaterial(localClientNum, bundle, prefix, type)
{
	method = 0;
	methodStr = GetStructField(bundle, prefix + "method");
	if(isdefined(methodStr))
	{
		switch(methodStr)
		{
			case "off":
			{
				method = 0;
				break;
			}
			case "default material":
			{
				method = 1;
				break;
			}
			case "custom material":
			{
				method = 3;
				break;
			}
			case "force custom material":
			{
				method = 3;
				break;
			}
			case "thermal":
			{
				method = 2;
				break;
			}
			case "enemy material":
			{
				method = 4;
				break;
			}
		}
	}
	materialName = GetStructField(bundle, prefix + "mc_material");
	materialId = -1;
	if(isdefined(materialName) && materialName != "")
	{
		materialName = "mc/" + materialName;
		materialId = filter::mapped_material_id(materialName);
		if(!isdefined(materialId))
		{
			filter::map_material_helper_by_localclientnum(localClientNum, materialName);
			materialId = filter::mapped_material_id();
			if(!isdefined(materialId))
			{
				materialId = -1;
			}
		}
	}
	self AddDuplicateRenderOption(type, method, materialId);
}

/*
	Name: SetShaderConstants
	Namespace: duplicate_render_bundle
	Checksum: 0x8A82312D
	Offset: 0xC68
	Size: 0x6B
	Parameters: 4
	Flags: None
*/
function SetShaderConstants(localClientNum, shaderConstantName, filterid, values)
{
	self MapShaderConstant(localClientNum, 0, shaderConstantName, values[0], values[1], values[2], values[3]);
}

/*
	Name: finishPlayingdupRenderBundle
	Namespace: duplicate_render_bundle
	Checksum: 0x48DA07DE
	Offset: 0xCE0
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function finishPlayingdupRenderBundle(localClientNum, msg)
{
	/#
		if(isdefined(msg))
		{
			println(msg);
		}
	#/
	self.forceStopdupRenderBundle = 0;
	self.exitdupRenderBundle = 0;
	self.playingdupRenderBundle = "";
}

/*
	Name: stopPlayingdupRenderBundle
	Namespace: duplicate_render_bundle
	Checksum: 0x9277AC22
	Offset: 0xD50
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function stopPlayingdupRenderBundle()
{
	if(self.playingdupRenderBundle != "")
	{
		stopdupRenderBundle();
	}
}

/*
	Name: stopdupRenderBundle
	Namespace: duplicate_render_bundle
	Checksum: 0x3BD6C971
	Offset: 0xD88
	Size: 0x71
	Parameters: 0
	Flags: None
*/
function stopdupRenderBundle()
{
	if(!isdefined(self.forceStopdupRenderBundle) && self.forceStopdupRenderBundle && isdefined(self.playingdupRenderBundle) && self.playingdupRenderBundle != "")
	{
		self.forceStopdupRenderBundle = 1;
		while(self.playingdupRenderBundle != "")
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
	Name: exitdupRenderBundle
	Namespace: duplicate_render_bundle
	Checksum: 0x20BE7A97
	Offset: 0xE08
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function exitdupRenderBundle()
{
	if(!isdefined(self.exitdupRenderBundle) && self.exitdupRenderBundle && isdefined(self.playingdupRenderBundle) && self.playingdupRenderBundle != "")
	{
		self.exitdupRenderBundle = 1;
	}
}

