#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace entityheadicons;

/*
	Name: init_shared
	Namespace: entityheadicons
	Checksum: 0xFC589875
	Offset: 0x160
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	callback::on_start_gametype(&start_gametype);
}

/*
	Name: start_gametype
	Namespace: entityheadicons
	Checksum: 0xD3748ABF
	Offset: 0x190
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function start_gametype()
{
	if(isdefined(level.initedEntityHeadIcons))
	{
		return;
	}
	level.initedEntityHeadIcons = 1;
	/#
		Assert(isdefined(game["Dev Block strings are not supported"]), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(game["Dev Block strings are not supported"]), "Dev Block strings are not supported");
	#/
	if(!level.teambased)
	{
		return;
	}
	if(!isdefined(level.setEntityHeadIcon))
	{
		level.setEntityHeadIcon = &setEntityHeadIcon;
	}
	level.entitiesWithHeadIcons = [];
}

/*
	Name: setEntityHeadIcon
	Namespace: entityheadicons
	Checksum: 0x349B1BC6
	Offset: 0x250
	Size: 0x383
	Parameters: 5
	Flags: None
*/
function setEntityHeadIcon(team, owner, offset, objective, constant_size)
{
	if(!level.teambased && !isdefined(owner))
	{
		return;
	}
	if(!isdefined(constant_size))
	{
		constant_size = 0;
	}
	if(!isdefined(self.entityHeadIconTeam))
	{
		self.entityHeadIconTeam = "none";
		self.entityheadicons = [];
		self.entityHeadObjectives = [];
	}
	if(level.teambased && !isdefined(owner))
	{
		if(team == self.entityHeadIconTeam)
		{
			return;
		}
		self.entityHeadIconTeam = team;
	}
	if(isdefined(offset))
	{
		self.entityHeadIconOffset = offset;
	}
	else
	{
		self.entityHeadIconOffset = (0, 0, 0);
	}
	if(isdefined(self.entityheadicons))
	{
		for(i = 0; i < self.entityheadicons.size; i++)
		{
			if(isdefined(self.entityheadicons[i]))
			{
				self.entityheadicons[i] destroy();
			}
		}
	}
	else if(isdefined(self.entityHeadObjectives))
	{
		for(i = 0; i < self.entityHeadObjectives.size; i++)
		{
			if(isdefined(self.entityHeadObjectives[i]))
			{
				objective_delete(self.entityHeadObjectives[i]);
				self.entityHeadObjectives[i] = undefined;
			}
		}
	}
	self.entityheadicons = [];
	self.entityHeadObjectives = [];
	self notify("kill_entity_headicon_thread");
	if(!isdefined(objective))
	{
		objective = game["entity_headicon_" + team];
	}
	if(isdefined(objective))
	{
		if(isdefined(owner) && !level.teambased)
		{
			if(!isPlayer(owner))
			{
				/#
					Assert(isdefined(owner.owner), "Dev Block strings are not supported");
				#/
				owner = owner.owner;
			}
			if(IsString(objective))
			{
				owner updateEntityHeadClientIcon(self, objective, constant_size);
			}
			else
			{
				owner updateEntityHeadClientObjective(self, objective, constant_size);
			}
		}
		else if(isdefined(owner) && team != "none")
		{
			if(IsString(objective))
			{
				owner updateEntityHeadTeamIcon(self, team, objective, constant_size);
			}
			else
			{
				owner updateEntityHeadTeamObjective(self, team, objective, constant_size);
			}
		}
	}
	self thread destroyHeadIconsOnDeath();
}

/*
	Name: updateEntityHeadTeamIcon
	Namespace: entityheadicons
	Checksum: 0xC517F71F
	Offset: 0x5E0
	Size: 0x1A9
	Parameters: 4
	Flags: None
*/
function updateEntityHeadTeamIcon(entity, team, icon, constant_size)
{
	friendly_blue_color = Array(0.584, 0.839, 0.867);
	headicon = NewTeamHudElem(team);
	headicon.archived = 1;
	headicon.x = entity.entityHeadIconOffset[0];
	headicon.y = entity.entityHeadIconOffset[1];
	headicon.z = entity.entityHeadIconOffset[2];
	headicon.alpha = 0.8;
	headicon.color = (friendly_blue_color[0], friendly_blue_color[1], friendly_blue_color[2]);
	headicon SetShader(icon, 6, 6);
	headicon setWaypoint(constant_size);
	headicon SetTargetEnt(entity);
	entity.entityheadicons[entity.entityheadicons.size] = headicon;
}

/*
	Name: updateEntityHeadClientIcon
	Namespace: entityheadicons
	Checksum: 0x971BF79F
	Offset: 0x798
	Size: 0x149
	Parameters: 3
	Flags: None
*/
function updateEntityHeadClientIcon(entity, icon, constant_size)
{
	headicon = newClientHudElem(self);
	headicon.archived = 1;
	headicon.x = entity.entityHeadIconOffset[0];
	headicon.y = entity.entityHeadIconOffset[1];
	headicon.z = entity.entityHeadIconOffset[2];
	headicon.alpha = 0.8;
	headicon SetShader(icon, 6, 6);
	headicon setWaypoint(constant_size);
	headicon SetTargetEnt(entity);
	entity.entityheadicons[entity.entityheadicons.size] = headicon;
}

/*
	Name: updateEntityHeadTeamObjective
	Namespace: entityheadicons
	Checksum: 0x1AD8570C
	Offset: 0x8F0
	Size: 0xC1
	Parameters: 4
	Flags: None
*/
function updateEntityHeadTeamObjective(entity, team, objective, constant_size)
{
	headIconObjectiveId = gameobjects::get_next_obj_id();
	objective_add(headIconObjectiveId, "active", entity, objective);
	objective_team(headIconObjectiveId, team);
	objective_setcolor(headIconObjectiveId, &"FriendlyBlue");
	entity.entityHeadObjectives[entity.entityHeadObjectives.size] = headIconObjectiveId;
}

/*
	Name: updateEntityHeadClientObjective
	Namespace: entityheadicons
	Checksum: 0xAA858299
	Offset: 0x9C0
	Size: 0xD1
	Parameters: 3
	Flags: None
*/
function updateEntityHeadClientObjective(entity, objective, constant_size)
{
	headIconObjectiveId = gameobjects::get_next_obj_id();
	objective_add(headIconObjectiveId, "active", entity, objective);
	Objective_SetInvisibleToAll(headIconObjectiveId);
	Objective_SetVisibleToPlayer(headIconObjectiveId, self);
	objective_setcolor(headIconObjectiveId, &"FriendlyBlue");
	entity.entityHeadObjectives[entity.entityHeadObjectives.size] = headIconObjectiveId;
}

/*
	Name: destroyHeadIconsOnDeath
	Namespace: entityheadicons
	Checksum: 0xE5451607
	Offset: 0xAA0
	Size: 0x11D
	Parameters: 0
	Flags: None
*/
function destroyHeadIconsOnDeath()
{
	self notify("destroyHeadIconsOnDeath_singleton");
	self endon("destroyHeadIconsOnDeath_singleton");
	self util::waittill_any("death", "hacked");
	for(i = 0; i < self.entityheadicons.size; i++)
	{
		if(isdefined(self.entityheadicons[i]))
		{
			self.entityheadicons[i] destroy();
		}
	}
	for(i = 0; i < self.entityHeadObjectives.size; i++)
	{
		if(isdefined(self.entityHeadObjectives[i]))
		{
			gameobjects::release_obj_id(self.entityHeadObjectives[i]);
			objective_delete(self.entityHeadObjectives[i]);
		}
	}
}

/*
	Name: destroyEntityHeadIcons
	Namespace: entityheadicons
	Checksum: 0x65AFF947
	Offset: 0xBC8
	Size: 0xFF
	Parameters: 0
	Flags: None
*/
function destroyEntityHeadIcons()
{
	if(isdefined(self.entityheadicons))
	{
		for(i = 0; i < self.entityheadicons.size; i++)
		{
			if(isdefined(self.entityheadicons[i]))
			{
				self.entityheadicons[i] destroy();
			}
		}
	}
	else if(isdefined(self.entityHeadObjectives))
	{
		for(i = 0; i < self.entityHeadObjectives.size; i++)
		{
			if(isdefined(self.entityHeadObjectives[i]))
			{
				gameobjects::release_obj_id(self.entityHeadObjectives[i]);
				objective_delete(self.entityHeadObjectives[i]);
			}
		}
	}
	self.entityHeadObjectives = [];
}

/*
	Name: updateEntityHeadIconPos
	Namespace: entityheadicons
	Checksum: 0xE42C2E4F
	Offset: 0xCD0
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function updateEntityHeadIconPos(headicon)
{
	headicon.x = self.origin[0] + self.entityHeadIconOffset[0];
	headicon.y = self.origin[1] + self.entityHeadIconOffset[1];
	headicon.z = self.origin[2] + self.entityHeadIconOffset[2];
}

/*
	Name: setEntityHeadIconsHiddenWhileControlling
	Namespace: entityheadicons
	Checksum: 0xD7BAE5E0
	Offset: 0xD60
	Size: 0x91
	Parameters: 0
	Flags: None
*/
function setEntityHeadIconsHiddenWhileControlling()
{
	if(isdefined(self.entityheadicons))
	{
		foreach(icon in self.entityheadicons)
		{
			icon.hidewhileremotecontrolling = 1;
		}
	}
}

