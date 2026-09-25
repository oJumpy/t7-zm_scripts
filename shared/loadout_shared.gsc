#namespace loadout;

/*
	Name: is_warlord_perk
	Namespace: loadout
	Checksum: 0xA8DCE69B
	Offset: 0x78
	Size: 0xD
	Parameters: 1
	Flags: None
*/
function is_warlord_perk(itemIndex)
{
	return 0;
}

/*
	Name: is_item_excluded
	Namespace: loadout
	Checksum: 0x2C4D7A5F
	Offset: 0x90
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function is_item_excluded(itemIndex)
{
	if(!level.onlineGame)
	{
		return 0;
	}
	numExclusions = level.itemExclusions.size;
	for(exclusionIndex = 0; exclusionIndex < numExclusions; exclusionIndex++)
	{
		if(itemIndex == level.itemExclusions[exclusionIndex])
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: getLoadoutItemFromDDLStats
	Namespace: loadout
	Checksum: 0xCF017F4F
	Offset: 0x110
	Size: 0x77
	Parameters: 2
	Flags: None
*/
function getLoadoutItemFromDDLStats(customClassNum, loadoutSlot)
{
	itemIndex = self GetLoadoutItem(customClassNum, loadoutSlot);
	if(is_item_excluded(itemIndex) && !is_warlord_perk(itemIndex))
	{
		return 0;
	}
	return itemIndex;
}

/*
	Name: initWeaponAttachments
	Namespace: loadout
	Checksum: 0x46E5E5EF
	Offset: 0x190
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function initWeaponAttachments(weapon)
{
	self.currentWeaponStartTime = GetTime();
	self.currentWeapon = weapon;
}

