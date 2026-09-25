#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_human_blackboard;
#using scripts\shared\ai\archetype_human_cover;
#using scripts\shared\ai\archetype_human_exposed;
#using scripts\shared\ai\archetype_human_interface;
#using scripts\shared\ai\archetype_human_locomotion;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_notetracks;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

#namespace ARCHETYPE_HUMAN;

/*
	Name: init
	Namespace: ARCHETYPE_HUMAN
	Checksum: 0xE4A9E2C8
	Offset: 0x6C8
	Size: 0xBB
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	spawner::add_archetype_spawn_function("human", &ArchetypeHumanBlackboardInit);
	spawner::add_archetype_spawn_function("human", &ArchetypeHumanInit);
	HumanInterface::RegisterHumanInterfaceAttributes();
	clientfield::register("actor", "facial_dial", 1, 1, "int");
	/#
		level.__ai_forceGibs = GetDvarInt("Dev Block strings are not supported");
	#/
}

/*
	Name: ArchetypeHumanInit
	Namespace: ARCHETYPE_HUMAN
	Checksum: 0x80472732
	Offset: 0x790
	Size: 0x123
	Parameters: 0
	Flags: Private
*/
function private ArchetypeHumanInit()
{
	entity = self;
	AiUtility::AddAIOverrideDamageCallback(entity, &DamageOverride);
	AiUtility::AddAIOverrideKilledCallback(entity, &humanGibKilledOverride);
	locomotionTypes = Array("alt1", "alt2", "alt3", "alt4");
	altIndex = entity GetEntityNumber() % locomotionTypes.size;
	blackboard::SetBlackBoardAttribute(entity, "_human_locomotion_variation", locomotionTypes[altIndex]);
	if(isdefined(entity.hero) && entity.hero)
	{
		blackboard::SetBlackBoardAttribute(entity, "_human_locomotion_variation", "alt1");
	}
}

/*
	Name: ArchetypeHumanBlackboardInit
	Namespace: ARCHETYPE_HUMAN
	Checksum: 0xB6638B53
	Offset: 0x8C0
	Size: 0x12B
	Parameters: 0
	Flags: Private
*/
function private ArchetypeHumanBlackboardInit()
{
	blackboard::CreateBlackBoardForEntity(self);
	ai::CreateInterfaceForEntity(self);
	self AiUtility::RegisterUtilityBlackboardAttributes();
	self blackboard::RegisterActorBlackBoardAttributes();
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeHumanOnAnimscriptedCallback;
	self.___ArchetypeOnBehaveCallback = &ArchetypeHumanOnBehaveCallback;
	/#
		self function_89398c57();
	#/
	self thread gameskill::accuracy_buildup_before_fire(self);
	if(self.accurateFire)
	{
		self thread AiUtility::preShootLaserAndGlintOn(self);
		self thread AiUtility::postShootLaserAndGlintOff(self);
	}
	DestructServerUtils::ToggleSpawnGibs(self, 1);
	GibServerUtils::ToggleSpawnGibs(self, 1);
}

/*
	Name: ArchetypeHumanOnBehaveCallback
	Namespace: ARCHETYPE_HUMAN
	Checksum: 0x48A413F9
	Offset: 0x9F8
	Size: 0xDB
	Parameters: 1
	Flags: Private
*/
function private ArchetypeHumanOnBehaveCallback(entity)
{
	if(AiUtility::isAtCoverCondition(entity))
	{
		blackboard::SetBlackBoardAttribute(entity, "_previous_cover_mode", "cover_alert");
		blackboard::SetBlackBoardAttribute(entity, "_cover_mode", "cover_mode_none");
	}
	grenadeThrowInfo = spawnstruct();
	grenadeThrowInfo.grenadeThrower = entity;
	blackboard::AddBlackboardEvent("human_grenade_throw", grenadeThrowInfo, randomIntRange(3000, 4000));
}

/*
	Name: ArchetypeHumanOnAnimscriptedCallback
	Namespace: ARCHETYPE_HUMAN
	Checksum: 0x7C317ABD
	Offset: 0xAE0
	Size: 0x83
	Parameters: 1
	Flags: Private
*/
function private ArchetypeHumanOnAnimscriptedCallback(entity)
{
	entity.__blackboard = undefined;
	entity ArchetypeHumanBlackboardInit();
	vignetteMode = ai::GetAiAttribute(entity, "vignette_mode");
	HumanSoldierServerUtils::VignetteModeCallback(entity, "vignette_mode", vignetteMode, vignetteMode);
}

/*
	Name: humanGibKilledOverride
	Namespace: ARCHETYPE_HUMAN
	Checksum: 0xCB3B9B1B
	Offset: 0xB70
	Size: 0x30F
	Parameters: 8
	Flags: Private
*/
function private humanGibKilledOverride(inflictor, attacker, damage, meansOfDeath, weapon, dir, hitLoc, offsetTime)
{
	entity = self;
	if(math::cointoss())
	{
		return damage;
	}
	attackerDistance = 0;
	if(isdefined(attacker))
	{
		attackerDistance = DistanceSquared(attacker.origin, entity.origin);
	}
	isExplosive = IsInArray(Array("MOD_CRUSH", "MOD_GRENADE", "MOD_GRENADE_SPLASH", "MOD_PROJECTILE", "MOD_PROJECTILE_SPLASH", "MOD_EXPLOSIVE"), meansOfDeath);
	forceGibbing = 0;
	if(isdefined(weapon.weapClass) && weapon.weapClass == "turret")
	{
		forceGibbing = 1;
		if(isdefined(inflictor))
		{
			isDirectExplosive = IsInArray(Array("MOD_GRENADE", "MOD_GRENADE_SPLASH", "MOD_PROJECTILE", "MOD_PROJECTILE_SPLASH", "MOD_EXPLOSIVE"), meansOfDeath);
			isCloseExplosive = DistanceSquared(inflictor.origin, entity.origin) <= 60 * 60;
			if(isDirectExplosive && isCloseExplosive)
			{
				GibServerUtils::Annihilate(entity);
			}
		}
	}
	if(forceGibbing || isExplosive || (isdefined(level.__ai_forceGibs) && level.__ai_forceGibs) || (weapon.dogibbing && attackerDistance <= weapon.maxGibDistance * weapon.maxGibDistance))
	{
		GibServerUtils::ToggleSpawnGibs(entity, 1);
		DestructServerUtils::ToggleSpawnGibs(entity, 1);
		TryGibbingLimb(entity, damage, hitLoc, isExplosive || forceGibbing);
		TryGibbingLegs(entity, damage, hitLoc, isExplosive);
	}
	return damage;
}

/*
	Name: TryGibbingHead
	Namespace: ARCHETYPE_HUMAN
	Checksum: 0x8BBF3326
	Offset: 0xE88
	Size: 0x9B
	Parameters: 4
	Flags: Private
*/
function private TryGibbingHead(entity, damage, hitLoc, isExplosive)
{
	if(isExplosive)
	{
		GibServerUtils::GibHead(entity);
	}
	else if(IsInArray(Array("head", "neck", "helmet"), hitLoc))
	{
		GibServerUtils::GibHead(entity);
	}
}

/*
	Name: TryGibbingLimb
	Namespace: ARCHETYPE_HUMAN
	Checksum: 0x47A97BBE
	Offset: 0xF30
	Size: 0x1CB
	Parameters: 4
	Flags: Private
*/
function private TryGibbingLimb(entity, damage, hitLoc, isExplosive)
{
	if(isExplosive)
	{
		randomChance = RandomFloatRange(0, 1);
		if(randomChance < 0.5)
		{
			GibServerUtils::GibRightArm(entity);
		}
		else
		{
			GibServerUtils::GibLeftArm(entity);
		}
	}
	else if(IsInArray(Array("left_hand", "left_arm_lower", "left_arm_upper"), hitLoc))
	{
		GibServerUtils::GibLeftArm(entity);
	}
	else if(IsInArray(Array("right_hand", "right_arm_lower", "right_arm_upper"), hitLoc))
	{
		GibServerUtils::GibRightArm(entity);
	}
	else if(IsInArray(Array("torso_upper"), hitLoc) && math::cointoss())
	{
		if(math::cointoss())
		{
			GibServerUtils::GibLeftArm(entity);
		}
		else
		{
			GibServerUtils::GibRightArm(entity);
		}
	}
}

/*
	Name: TryGibbingLegs
	Namespace: ARCHETYPE_HUMAN
	Checksum: 0x6553B96B
	Offset: 0x1108
	Size: 0x1FB
	Parameters: 5
	Flags: Private
*/
function private TryGibbingLegs(entity, damage, hitLoc, isExplosive, attacker)
{
	if(isExplosive)
	{
		randomChance = RandomFloatRange(0, 1);
		if(randomChance < 0.33)
		{
			GibServerUtils::GibRightLeg(entity);
		}
		else if(randomChance < 0.66)
		{
			GibServerUtils::GibLeftLeg(entity);
		}
		else
		{
			GibServerUtils::GibLegs(entity);
		}
	}
	else if(IsInArray(Array("left_leg_upper", "left_leg_lower", "left_foot"), hitLoc))
	{
		GibServerUtils::GibLeftLeg(entity);
	}
	else if(IsInArray(Array("right_leg_upper", "right_leg_lower", "right_foot"), hitLoc))
	{
		GibServerUtils::GibRightLeg(entity);
	}
	else if(IsInArray(Array("torso_lower"), hitLoc) && math::cointoss())
	{
		if(math::cointoss())
		{
			GibServerUtils::GibLeftLeg(entity);
		}
		else
		{
			GibServerUtils::GibRightLeg(entity);
		}
	}
}

/*
	Name: DamageOverride
	Namespace: ARCHETYPE_HUMAN
	Checksum: 0xF06BD2C0
	Offset: 0x1310
	Size: 0x1BB
	Parameters: 12
	Flags: None
*/
function DamageOverride(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, modelIndex)
{
	entity = self;
	entity DestructServerUtils::handleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, modelIndex);
	if(isdefined(eAttacker) && !isPlayer(eAttacker) && !isVehicle(eAttacker))
	{
		dist = DistanceSquared(entity.origin, eAttacker.origin);
		if(dist < 65536)
		{
			iDamage = Int(iDamage * 10);
		}
		else
		{
			iDamage = Int(iDamage * 1.5);
		}
	}
	if(sWeapon.name == "incendiary_grenade")
	{
		iDamage = entity.health;
	}
	return iDamage;
}

#namespace HumanSoldierServerUtils;

/*
	Name: cqbAttributeCallback
	Namespace: HumanSoldierServerUtils
	Checksum: 0x1D67B7A6
	Offset: 0x14D8
	Size: 0xA3
	Parameters: 4
	Flags: None
*/
function cqbAttributeCallback(entity, attribute, oldValue, value)
{
	if(value)
	{
		entity AsmChangeAnimMappingTable(2);
	}
	else if(entity ai::get_behavior_attribute("useAnimationOverride"))
	{
		entity AsmChangeAnimMappingTable(1);
	}
	else
	{
		entity AsmChangeAnimMappingTable(0);
	}
}

/*
	Name: forceTacticalWalkCallback
	Namespace: HumanSoldierServerUtils
	Checksum: 0x811187B7
	Offset: 0x1588
	Size: 0x37
	Parameters: 4
	Flags: None
*/
function forceTacticalWalkCallback(entity, attribute, oldValue, value)
{
	entity.ignorerunAndgundist = value;
}

/*
	Name: moveModeAttributeCallback
	Namespace: HumanSoldierServerUtils
	Checksum: 0xCFF08835
	Offset: 0x15C8
	Size: 0x6D
	Parameters: 4
	Flags: None
*/
function moveModeAttributeCallback(entity, attribute, oldValue, value)
{
	entity.ignorepathenemyfightdist = 0;
	switch(value)
	{
		case "normal":
		{
			break;
		}
		case "rambo":
		{
			entity.ignorepathenemyfightdist = 1;
			break;
		}
	}
}

/*
	Name: UseAnimationOverrideCallback
	Namespace: HumanSoldierServerUtils
	Checksum: 0x95A7339E
	Offset: 0x1640
	Size: 0x63
	Parameters: 4
	Flags: None
*/
function UseAnimationOverrideCallback(entity, attribute, oldValue, value)
{
	if(value)
	{
		entity AsmChangeAnimMappingTable(1);
	}
	else
	{
		entity AsmChangeAnimMappingTable(0);
	}
}

/*
	Name: VignetteModeCallback
	Namespace: HumanSoldierServerUtils
	Checksum: 0x8306D905
	Offset: 0x16B0
	Size: 0x1F1
	Parameters: 4
	Flags: None
*/
function VignetteModeCallback(entity, attribute, oldValue, value)
{
	switch(value)
	{
		case "off":
		{
			entity.pushable = 1;
			entity PushActors(0);
			entity PushPlayer(0);
			entity SetAvoidanceMask("avoid all");
			entity SetSteeringMode("normal steering");
			break;
		}
		case "slow":
		{
			entity.pushable = 0;
			entity PushActors(0);
			entity PushPlayer(1);
			entity SetAvoidanceMask("avoid ai");
			entity SetSteeringMode("vignette steering");
			break;
		}
		case "fast":
		{
			entity.pushable = 0;
			entity PushActors(1);
			entity PushPlayer(1);
			entity SetAvoidanceMask("avoid none");
			entity SetSteeringMode("vignette steering");
			break;
		}
		case default:
		{
			break;
		}
	}
}

