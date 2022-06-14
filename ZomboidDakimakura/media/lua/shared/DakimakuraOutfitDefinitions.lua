require "NPCs/ZombiesZoneDefinition"
require "Definitions/AttachedWeaponDefinitions"
require "Definitions/HairOutfitDefinitions"

-- My ZombiesZoneDefinitions
ZombiesZoneDefinition = ZombiesZoneDefinition or {Default = {}}; -- if for whatever reason it doesn't exist after requiring the original file
table.insert(ZombiesZoneDefinition.Default,{name = "Neckbeard", chance=0.2, gender="male"});

-- My AttachedWeaponDefinitions
AttachedWeaponDefinitions = AttachedWeaponDefinitions or {}; -- if for whatever reason it doesn't exist after requiring the original file
AttachedWeaponDefinitions.DakimakuraInBack = { -- not meeleInBack but our own custom one, thanks for not overwriting
	chance = 100,
	outfit = {"Neckbeard"},
	weaponLocation =  {"Shovel Back"},
	bloodLocations = nil,
	addHoles = false,
	daySurvived = 0,
	weapons = {
		"Base.Dakimakura1",
		"Base.Dakimakura2",
		"Base.Dakimakura3",
		"Base.Dakimakura4",
		"Base.Dakimakura5",
		"Base.Dakimakura6",
		"Base.Dakimakura7",
		"Base.Dakimakura8",
		"Base.Dakimakura9",
		"Base.Dakimakura10",
		"Base.Dakimakura11",
		"Base.Dakimakura12",
		"Base.Dakimakura13",
		"Base.Dakimakura14",
		"Base.Dakimakura15",
		"Base.Dakimakura16",
		"Base.Dakimakura17",
		"Base.Dakimakura18",
		"Base.Dakimakura19",
		"Base.Dakimakura20",
		"Base.Dakimakura21",
	},
}

AttachedWeaponDefinitions.attachedWeaponCustomOutfit = {};
AttachedWeaponDefinitions.attachedWeaponCustomOutfit.Neckbeard = {
	chance = 100;
	weapons = {
		AttachedWeaponDefinitions.DakimakuraInBack,
	},
}

-- My Custon HairOutfitDefinitions
HairOutfitDefinitions = HairOutfitDefinitions or {haircutOutfitDefinition = {}}; -- if for whatever reason it doesn't exist after requiring the original file
local cat = {};
cat.outfit = "Neckbeard";
cat.haircut = "Recede:50;PonyTail:50";
cat.beard = "BeardOnly:100";
table.insert(HairOutfitDefinitions.haircutOutfitDefinition, cat);
