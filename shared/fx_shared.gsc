#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace FX;

/*
	Name: __init__sytem__
	Namespace: FX
	Checksum: 0xE214437B
	Offset: 0x150
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("fx", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: FX
	Checksum: 0x99EC1590
	Offset: 0x190
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

/*
	Name: set_forward_and_up_vectors
	Namespace: FX
	Checksum: 0x2C0A4AB
	Offset: 0x1A0
	Size: 0x75
	Parameters: 0
	Flags: None
*/
function set_forward_and_up_vectors()
{
	self.V["up"] = anglesToUp(self.V["angles"]);
	self.V["forward"] = AnglesToForward(self.V["angles"]);
}

/*
	Name: get
	Namespace: FX
	Checksum: 0x3C47BE68
	Offset: 0x220
	Size: 0x4F
	Parameters: 1
	Flags: None
*/
function get(FX)
{
	/#
		Assert(isdefined(level._effect[FX]), "Dev Block strings are not supported" + FX + "Dev Block strings are not supported");
	#/
	return level._effect[FX];
}

/*
	Name: create_effect
	Namespace: FX
	Checksum: 0xB1486A1F
	Offset: 0x278
	Size: 0x143
	Parameters: 2
	Flags: None
*/
function create_effect(type, fxid)
{
	ent = undefined;
	if(!isdefined(level.createFXent))
	{
		level.createFXent = [];
	}
	if(type == "exploder")
	{
		ent = spawnstruct();
	}
	else if(!isdefined(level._fake_createfx_struct))
	{
		level._fake_createfx_struct = spawnstruct();
	}
	ent = level._fake_createfx_struct;
	level.createFXent[level.createFXent.size] = ent;
	ent.V = [];
	ent.V["type"] = type;
	ent.V["fxid"] = fxid;
	ent.V["angles"] = (0, 0, 0);
	ent.V["origin"] = (0, 0, 0);
	ent.drawn = 1;
	return ent;
}

/*
	Name: create_loop_effect
	Namespace: FX
	Checksum: 0xFA974DE
	Offset: 0x3C8
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function create_loop_effect(fxid)
{
	ent = create_effect("loopfx", fxid);
	ent.V["delay"] = 0.5;
	return ent;
}

/*
	Name: create_oneshot_effect
	Namespace: FX
	Checksum: 0xFE0A3F2F
	Offset: 0x430
	Size: 0x55
	Parameters: 1
	Flags: None
*/
function create_oneshot_effect(fxid)
{
	ent = create_effect("oneshotfx", fxid);
	ent.V["delay"] = -15;
	return ent;
}

/*
	Name: Play
	Namespace: FX
	Checksum: 0xC94B3312
	Offset: 0x490
	Size: 0x293
	Parameters: 8
	Flags: None
*/
function Play(str_fx, v_origin, v_angles, time_to_delete_or_notify, b_link_to_self, str_tag, b_no_cull, var_b7d510ac)
{
	if(!isdefined(v_origin))
	{
		v_origin = (0, 0, 0);
	}
	if(!isdefined(v_angles))
	{
		v_angles = (0, 0, 0);
	}
	if(!isdefined(b_link_to_self))
	{
		b_link_to_self = 0;
	}
	self notify(str_fx);
	if(!isdefined(time_to_delete_or_notify) || (!IsString(time_to_delete_or_notify) && time_to_delete_or_notify == -1) && (isdefined(b_link_to_self) && b_link_to_self) && isdefined(str_tag))
	{
		PlayFXOnTag(get(str_fx), self, str_tag, var_b7d510ac);
		return self;
	}
	else if(isdefined(time_to_delete_or_notify))
	{
		m_fx = util::spawn_model("tag_origin", v_origin, v_angles);
		if(isdefined(b_link_to_self) && b_link_to_self)
		{
			if(isdefined(str_tag))
			{
				m_fx LinkTo(self, str_tag, (0, 0, 0), (0, 0, 0));
			}
			else
			{
				m_fx LinkTo(self);
			}
		}
		if(isdefined(b_no_cull) && b_no_cull)
		{
			m_fx SetForceNoCull();
		}
		PlayFXOnTag(get(str_fx), m_fx, "tag_origin", var_b7d510ac);
		m_fx thread _play_fx_delete(self, time_to_delete_or_notify);
		return m_fx;
	}
	else
	{
		playFX(get(str_fx), v_origin, AnglesToForward(v_angles), anglesToUp(v_angles), var_b7d510ac);
	}
}

/*
	Name: _play_fx_delete
	Namespace: FX
	Checksum: 0x37468010
	Offset: 0x730
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function _play_fx_delete(ent, time_to_delete_or_notify)
{
	if(!isdefined(time_to_delete_or_notify))
	{
		time_to_delete_or_notify = -1;
	}
	if(IsString(time_to_delete_or_notify))
	{
		ent util::waittill_either("death", time_to_delete_or_notify);
	}
	else if(time_to_delete_or_notify > 0)
	{
		ent util::waittill_any_timeout(time_to_delete_or_notify, "death");
	}
	else
	{
		ent waittill("death");
	}
	if(isdefined(self))
	{
		self delete();
	}
}

