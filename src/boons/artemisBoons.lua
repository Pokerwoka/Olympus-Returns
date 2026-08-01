gods.CreateBoon({
	InheritFrom = { "BaseTrait", "EarthBoon" },
	internalBoonName = "ArtemisWeaponBoon",
	characterName = "Artemis",
	addToExistingGod = mod.getSplitConfig("Artemis", 1),
	--? Optional
	Slot = "Melee",
	BlockStacking = false,

	displayName = "Deadly Strike",
	description = "Your {$Keywords.Attack} is stronger, with {#AltUpgradeFormat}{$TooltipData.ExtractData.TooltipCritChance:P} {#Prev} chance to deal {$Keywords.Crit} damage.",
	boonIconPath = "GUI\\Screens\\BoonIcons\\Artemis\\Artemis_07",
	RarityLevels = {
		Common = 1.00,
		Rare = 1.50,
		Epic = 2.00,
		Heroic = 2.50,
		Perfect = 3.50,
	},

	StatLines = { "AttackDamageStatDisplay1" },
	ExtractValues = {
		{
			Key = "ReportedValidWeaponMultiplier",
			ExtractAs = "TooltipDamageBonus",
			Format = "PercentDelta",
		},
		{
			Key = "ExtractCritChance",
			ExtractAs = "TooltipCritChance",
			Format = "Percent",
			SkipAutoExtract = true,
		},
	},

	ExtraFields = {
		AddOutgoingDamageModifiers = {
			ValidWeaponMultiplier = {
				BaseValue = 1.2,
				SourceIsMultiplier = true,
				AbsoluteStackValues = {
					[1] = 1.20,
					[2] = 1.15,
					[3] = 1.10,
				},
			},

			ValidWeapons = WeaponSets.HeroPrimaryWeapons,

			ReportValues = {
				ReportedValidWeaponMultiplier = "ValidWeaponMultiplier",
			},
		},
		AddOutgoingCritModifiers = {
			ValidWeapons = WeaponSets.HeroPrimaryWeapons,
			Chance = {
				BaseValue = 0.15,
				CustomRarityMultiplier = {
					Common = { Multiplier = 1.0 },
					Rare = { Multiplier = 1.0 },
					Epic = { Multiplier = 1.0 },
					Heroic = { Multiplier = 1.0 },
				},
				AbsoluteStackValues = {
					[1] = 0,
				},
			},
			ReportValues = {
				ExtractCritChance = "Chance",
			},
		},
	},
})

gods.CreateBoon({
	InheritFrom = { "BaseTrait", "EarthBoon" },
	internalBoonName = "ArtemisSpecialBoon",
	characterName = "Artemis",
	addToExistingGod = mod.getSplitConfig("Artemis", 2),
	--? Optional
	Slot = "Secondary",
	BlockStacking = false,
	-- reuseBaseIcons = true,

	displayName = "Deadly Flourish",
	description = "Your {$Keywords.Special} is stronger, with {#AltUpgradeFormat}{$TooltipData.ExtractData.TooltipCritChance:P} {#Prev} chance to deal {$Keywords.Crit} damage.",
	boonIconPath = "GUI\\Screens\\BoonIcons\\Artemis\\Artemis_06",
	RarityLevels = {
		Common = 1.00,
		Rare = 1.50,
		Epic = 2.00,
		Heroic = 2.50,
		Perfect = 3.50,
	},

	StatLines = { "SpecialDamageStatDisplay1" },
	ExtractValues = {
		{
			Key = "ReportedValidWeaponMultiplier",
			ExtractAs = "TooltipDamageBonus",
			Format = "PercentDelta",
		},
		{
			Key = "ExtractCritChance",
			ExtractAs = "TooltipCritChance",
			Format = "Percent",
			SkipAutoExtract = true,
		},
	},

	ExtraFields = {
		AddOutgoingDamageModifiers = {
			ValidWeaponMultiplier = {
				BaseValue = 1.4,
				SourceIsMultiplier = true,
				-- Scaling thing with poms
				AbsoluteStackValues = {
					[1] = 1.20,
					[2] = 1.15,
					[3] = 1.10,
				},
			},
			ValidWeapons = WeaponSets.HeroSecondaryWeapons,

			ReportValues = {
				ReportedValidWeaponMultiplier = "ValidWeaponMultiplier",
			},
		},

		AddOutgoingCritModifiers = {
			ValidWeapons = WeaponSets.HeroSecondaryWeapons,
			Chance = {
				BaseValue = 0.20,
				CustomRarityMultiplier = {
					Common = { Multiplier = 1.0 },
					Rare = { Multiplier = 1.0 },
					Epic = { Multiplier = 1.0 },
					Heroic = { Multiplier = 1.0 },
				},
				AbsoluteStackValues = {
					[1] = 0,
				},
			},
			ReportValues = {
				ExtractCritChance = "Chance",
			},
		},
	},
})

gods.CreateBoon({
	InheritFrom = { "BaseTrait", "EarthBoon" },
	internalBoonName = "ArtemisSprintBoon",
	characterName = "Artemis",
	addToExistingGod = mod.getSplitConfig("Artemis", 3),
	--? Optional
	Slot = "Rush",
	BlockStacking = false,

	displayName = "Hunter Dash",
	description = "Your {$Keywords.Sprint} fires seeking arrows every {#BoldFormatGraft}0.1 sec.{#Prev}, with each using {#ManaFormat}{$TooltipData.ExtractData.ManaCost}{#Prev}{!Icons.Mana}.",
	boonIconPath = "GUI\\Screens\\BoonIcons\\Artemis\\Artemis_10",
	RarityLevels = {
		Common = 1.00,
		Rare = 1.50,
		Epic = 2.00,
		Heroic = 2.50,
		Perfect = 3.50,
	},

	StatLines = { "SupportFireDamageDisplay2" },
	ExtractValues = {
		{
			Key = "ReportedMultiplier",
			ExtractAs = "Damage",
			Format = "MultiplyByBase",
			BaseType = "Projectile",
			BaseName = "ArtemisSupportingFireSprint",
			BaseProperty = "Damage",
		},
		{
			SkipAutoExtract = true,
			Key = "ReportedCost",
			ExtractAs = "ManaCost",
		},
		{
			ExtractAs = "Cooldown",
			Key = "ReportedCooldown",
			SkipAutoExtract = true,
			DecimalPlaces = 2,
		},
	},

	ExtraFields = {
		OnWeaponFiredFunctions = {
			ValidWeapons = { "WeaponSprint", "WeaponBlink" },
			-- we need to do this string building or the save gets bricked as soon as you leave the room
			FunctionName = "rom.mods." .. _PLUGIN.guid .. ".not.ArtemisSprintFire",
			FunctionArgs = {
				ProjectileName = "ArtemisSupportingFireSprint",
				Cooldown = 0.1,
				Scatter = 180,
				Radius = 1000,
				CostPerStrike = 3,
				DamageMultiplier = { BaseValue = 1 },
				ReportValues = {
					ReportedMultiplier = "DamageMultiplier",
					ReportedCost = "CostPerStrike",
					ReportedCooldown = "Cooldown",
				},
			},
		},
	},
})

gods.CreateBoon({
	InheritFrom = { "BaseTrait", "AirBoon" },
	internalBoonName = "ArtemisArmourBoon",
	characterName = "Artemis",
	addToExistingGod = mod.getSplitConfig("Artemis"),
	--? Optional
	BlockStacking = false,
	requirements = { OneOf = { "ArtemisWeaponBoon", "ArtemisSpecialBoon", "CritBonusBoon" } },

	displayName = "Hide Breaker",
	description = "Your {$Keywords.Crit} effects deal even more damage to {$Keywords.Armor}.",
	boonIconPath = "GUI\\Screens\\BoonIcons\\Artemis\\Artemis_09",
	RarityLevels = {
		Common = 1.00,
		Rare = 1.50,
		Epic = 2.00,
		Heroic = 2.50,
		Perfect = 3.50,
	},

	StatLines = { "ArmourDamageStatDisplay1" },
	ExtractValues = { {
		Key = "CriticalHealthBufferMultiplier",
		ExtractAs = "TooltipDamageBonus",
		Format = "PercentDelta",
	} },

	customStatLine = {
		ID = "ArmourDamageStatDisplay1",
		displayName = "{!Icons.Bullet}{#PropertyFormat}Bonus vs Armour:",
		description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
	},

	ExtraFields = {
		CriticalHealthBufferMultiplier = {
			BaseValue = 3, -- Have to set to 3? or else the display is wrong, but values are correct with 3 anyway?
			SourceIsMultiplier = true,
			IdenticalMultiplier = {
				Value = -0.60,
			},
			ReportValues = {
				ReportedArmourDamage = "BaseValue",
			},
		},
	},
})

gods.CreateBoon({
	InheritFrom = { "BaseTrait", "AirBoon" },
	internalBoonName = "ArtemisCriticalBoon",
	characterName = "Artemis",
	addToExistingGod = mod.getSplitConfig("Artemis"),
	--? Optional
	BlockStacking = false,
	requirements = { OneOf = { "ArtemisWeaponBoon", "ArtemisSpecialBoon", "CritBonusBoon" } },

	displayName = "Clean Kill",
	description = "Your {$Keywords.Crit} effects deal even more damage.",
	boonIconPath = "GUI\\Screens\\BoonIcons\\Artemis\\Artemis_05",
	RarityLevels = {
		Common = 1.00,
		Rare = 1.38,
		Epic = 1.76,
		Heroic = 2.14,
		Perfect = 2.90,
	},

	StatLines = { "CriticalDamageBonusStatDisplay1" },
	ExtractValues = { {
		Key = "ReportedCriticalDamageBonus",
		ExtractAs = "ReportedCriticalDamageBonus",
		Format = "PercentDelta",
	} },

	customStatLine = {
		ID = "CriticalDamageBonusStatDisplay1",
		displayName = "{!Icons.Bullet}{#PropertyFormat}Critical Damage:",
		description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
	},

	ExtraFields = {
		AddOutgoingDamageModifiers = {
			CritDamageBonus = {
				BaseValue = 1.20,
				SourceIsMultiplier = true,
				IdenticalMultiplier = {
					Value = -0.34,
				},
			},
			ReportValues = {
				ReportedCriticalDamageBonus = "CritDamageBonus",
			},
		},
	},
})

if not droppableConfig.Artemis.splitTraits then
	table.insert(game.EnemyData.NPC_Artemis_Field_01.WeaponUpgrades, 1, _PLUGIN.guid .. "-ArtemisWeaponBoon")
	table.insert(game.EnemyData.NPC_Artemis_Field_01.WeaponUpgrades, 2, _PLUGIN.guid .. "-ArtemisSpecialBoon")
	table.insert(game.EnemyData.NPC_Artemis_Field_01.WeaponUpgrades, 3, _PLUGIN.guid .. "-ArtemisSprintBoon")

	table.insert(game.EnemyData.NPC_Artemis_Field_01.Traits, _PLUGIN.guid .. "-ArtemisArmourBoon")
	table.insert(game.EnemyData.NPC_Artemis_Field_01.Traits, _PLUGIN.guid .. "-ArtemisCriticalBoon")
end

--#region alt stuff, sjson etc
-- this janky stuff is because the function needs to be public, but we don't really want it to appear as a public function
local not_public = {}
public["not"] = not_public

function not_public.ArtemisSprintFire(weaponData, functionArgs, triggerArgs)
	-- Initially to get rid of anything not sprint or dash, aka torches
	if weaponData.Name ~= "WeaponSprint" then
		return
	end

	if weaponData.Name == "WeaponSprint" then
		local manaCost = 0
		if functionArgs.CostPerStrike and functionArgs.CostPerStrike > 0 then
			manaCost = GetManaCost(weaponData, true, { ManaCostOverride = functionArgs.CostPerStrike })
		end

		-- get closest enemy
		local enemyId = game.GetClosest({
			Id = game.CurrentRun.Hero.ObjectId,
			DestinationName = "EnemyTeam",
			IgnoreInvulnerable = true,
			IgnoreHomingIneligible = true,
			Distance = functionArgs.Radius,
		})

		-- if it's a valid enemy...
		if not (enemyId and game.ActiveEnemies[enemyId] and not game.ActiveEnemies[enemyId].IsDead) then
			return
		end

		local victim = game.ActiveEnemies[enemyId]

		if CheckCooldown("ArtemisSprintFire", functionArgs.Cooldown, true) then
			if game.CurrentRun.Hero.Mana >= manaCost then
				local angle = randomint(0, 360)
				if angle and functionArgs.Scatter then
					angle = angle + RandomFloat(-functionArgs.Scatter, functionArgs.Scatter)
				end

				CreateProjectileFromUnit({
					Name = functionArgs.ProjectileName,
					Id = CurrentRun.Hero.ObjectId,
					DestinationId = victim.ObjectId,
					Angle = angle,
					DamageMultiplier = functionArgs.DamageMultiplier,
					ProjectileCap = 6,
					Count = randomint(1, 4),
				})
				ManaDelta(-manaCost)
			end
		end
	end
end

local ProjectileDataFile = rom.path.combine(rom.paths.Content, "Game/Projectiles/PlayerProjectiles.sjson")
local ProjectileSupportFireOrder = {
	"Name",
	"InheritFrom",
	"Type",
	"HomingAllegiance",
	"AdjustRateAcceleration",
	"MaxAdjustRate",
	"Speed",
	"Acceleration",
	"Range",
	"Damage",
	"CheckObstacleImpact",
	"CheckUnitImpact",
	"UnlimitedUnitPenetration",
	"DetonateAtVictimLocation",
	"UseVulnerability",
	"IgnoreCoverageAngles",
	"Thing",
}

local ArtemisSupportingFireSprint = sjson.to_object({
	Name = "ArtemisSupportingFireSprint",
	InheritFrom = "1_BaseNonPhysicalProjectile",
	Type = "HOMING",
	HomingAllegiance = "ENEMIES",
	AdjustRateAcceleration = 1400, -- Speed increase / 900
	MaxAdjustRate = 4600, -- Speed increase / 3600
	Speed = 1800, -- Speed increase / 1200
	Acceleration = 500, -- Acceleration increase / 300
	Range = 1000.0,
	Damage = 10,
	CheckObstacleImpact = false,
	CheckUnitImpact = true,
	UnlimitedUnitPenetration = false,
	DetonateAtVictimLocation = true,
	UseVulnerability = true,
	IgnoreCoverageAngles = true,
	Thing = {
		Graphic = "ArtemisRangedArrowheadLegendary",
		OffsetZ = 112,
		AttachedAnim = "null",
		Grip = 999999,
		RotateGeometry = true,
		Points = {
			{
				X = 76,
				Y = 16,
			},
			{
				X = 76,
				Y = -16,
			},
			{
				X = -32,
				Y = -16,
			},
			{
				X = -32,
				Y = 16,
			},
		},
	},
}, ProjectileSupportFireOrder)

sjson.hook(ProjectileDataFile, function(data)
	table.insert(data.Projectiles, ArtemisSupportingFireSprint)
end)

game.ProjectileData.ArtemisSupportingFireSprint = {
	Name = "ArtemisSupportingFireSprint",

	DamageTextStartColor = Color.ArtemisDamageLight,
	DamageTextColor = Color.ArtemisDamage,
	Sounds = {
		ImpactSounds = {
			Invulnerable = "/SFX/Player Sounds/ZagreusShieldRicochet",
			Armored = "/SFX/Player Sounds/ZagreusShieldRicochet",
			Bone = "/SFX/ArrowMetalBoneSmash",
			Brick = "/SFX/ArrowMetalStoneClang",
			Stone = "/SFX/ArrowMetalStoneClang",
			Organic = "/SFX/GunBulletOrganicImpact",
			StoneObstacle = "/SFX/ArrowWallHitClankSmall",
			BrickObstacle = "/SFX/ArrowWallHitClankSmall",
			MetalObstacle = "/SFX/ArrowWallHitClankSmall",
			BushObstacle = "/Leftovers/World Sounds/LeavesRustle",
		},
	},
}

--? dunno if ill need
-- sjson.hook(mod.ArtemisFxFile, function(data)
-- 	for _, v in ipairs(data.Animations) do
-- 		if v.Name == "ArtemisRangedArrowhead1" then
-- 			v.FilePath = rom.path.combine(_PLUGIN.guid, "Fx\\ArtemisRangedArrow\\ArtemisRangedArrowhead0001")
-- 		end
-- 	end

-- 	-- Don't need this, from my quick testing, but maybe my save got unfucked, keep it anyway
-- 	for _, v in ipairs(data.Animations) do
-- 		if v.Name == "ArtemisRangedArrowheadLegendary" then
-- 			v.FilePath = rom.path.combine(_PLUGIN.guid, "Fx\\ArtemisRangedArrow\\ArtemisRangedArrowhead0001")
-- 		end
-- 	end
-- end)
--#endregion
