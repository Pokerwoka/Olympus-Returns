-- TODO - Cleanup, adhere to GodsAPI.
mod.TraitTextFile = rom.path.combine(rom.paths.Content, "Game/Text/en/TraitText.en.sjson")
mod.GUIScreensVFXFile = rom.path.combine(rom.paths.Content, "Game/Animations/GUI_Screens_VFX.sjson")

mod.Order = { "Id", "InheritFrom", "DisplayName", "Description" }
mod.IconOrder = { "Name", "InheritFrom", "FilePath" }

-- Insert for Icons
sjson.hook(mod.GUIScreensVFXFile, function(data)
	-- Hermes Boons
	table.insert(data.Animations, mod.Boon_Hermes_SpeedDamageBoon)
	table.insert(data.Animations, mod.Boon_Hermes_MoveSpeedBoon)
	table.insert(data.Animations, mod.Boon_Hermes_RushRallyBoon)
	table.insert(data.Animations, mod.Boon_Hermes_BonusDashBoon)
end)

-- Insert for BoonText
sjson.hook(mod.TraitTextFile, function(data)
	-- Hermes Boons
	table.insert(data.Texts, mod.SpeedDamageBoon)
	table.insert(data.Texts, mod.SpeedDamageBoon_Text)
	table.insert(data.Texts, mod.MoveSpeedBoon)
	table.insert(data.Texts, mod.MoveSpeedBoon_Text)
	table.insert(data.Texts, mod.RushRallyBoon)
	table.insert(data.Texts, mod.RushRallyBoon_Text)
	table.insert(data.Texts, mod.BonusDashBoon)
	table.insert(data.Texts, mod.BonusDashBoon_Text)
end)

-- Bonus Dash
gods.CreateBoon({
	InheritFrom = { "BaseTrat", "LegacyTrait", "AirBoon" },
	internalBoonName = "BonusDashBoon",
	characterName = "Hermes",
	--? Optional
	addToExistingGod = true,
	BlockStacking = true,

	displayName = "Greatest Reflex",
	description = "You can {$Keywords.Dash} more times in a row.",
	boonIconPath = "GUI\\Screens\\BoonIcons\\Hermes\\Hermes_02",
	RarityLevels = {
		Common = 1.00,
		Rare = 2.00,
		Epic = 3.00,
		Heroic = 4.00,
	},

	ExtraFields = {
		PropertyChanges = {
			{
				WeaponNames = WeaponSets.HeroBlinkWeapons,
				WeaponProperty = "ClipSize",
				BaseValue = 1,
				ChangeType = "Add",
				ReportValues = { ReportedBonusSprint = "ChangeValue" },
			},
		},
	},

	StatLines = { "BonusDashStatDisplay1" },
	ExtractValues = {
		{
			Key = "ReportedBonusSprint",
			ExtractAs = "TooltipSprintBonus",
		},
	},

	customStatLine = {
		ID = "BonusDashStatDisplay1",
		displayName = "{!Icons.Bullet}{#PropertyFormat}Bonus {$Keywords.Dash} Charges:",
		description = "{#UpgradeFormat}+{$TooltipData.ExtractData.TooltipSprintBonus}",
	},
})

-- Move Speed
gods.CreateBoon({
	InheritFrom = { "BaseTrat", "AirBoon" },
	internalBoonName = "MoveSpeedBoon",
	characterName = "Hermes",
	--? Optional
	addToExistingGod = true,
	BlockStacking = true,

	displayName = "Greater Haste",
	description = "You move faster.",
	boonIconPath = "GUI\\Screens\\BoonIcons\\Hermes\\Hermes_01",
	RarityLevels = {
		Common = 1.0,
		Rare = 1.08,
		Epic = 1.17,
		Heroic = 1.25,
	},

	ExtraFields = {
		PropertyChanges = { {
			UnitProperty = "Speed",
			ChangeType = "Multiply",
			BaseValue = 1.2,
			SourceIsMultiplier = true,
			ReportValues = {
				ReportedSpeed = "ChangeValue",
			},
		} },
	},

	StatLines = { "BonusSpeedStatDisplay1" },
	ExtractValues = { {
		Key = "ReportedSpeed",
		ExtractAs = "TooltipSpeed",
		Format = "PercentDelta",
	} },

	customStatLine = {
		ID = "BonusSpeedStatDisplay1",
		displayName = "{!Icons.Bullet}{#PropertyFormat}Move Speed:",
		description = "{#UpgradeFormat}{$TooltipData.ExtractData.TooltipSpeed:F}",
	},
})

-- Bonus dmg w/ move speed
gods.CreateBoon({
	InheritFrom = { "BaseTrat", "FireBoon" },
	internalBoonName = "SpeedDamageBoon",
	characterName = "Hermes",
	requirements = { OneOf = { "MoveSpeedBoon" } },
	--? Optional
	addToExistingGod = true,
	BlockStacking = true,

	displayName = "Rush Delivery",
	description = "You deal bonus damage based on any bonus move speed.",
	boonIconPath = "GUI\\Screens\\BoonIcons\\Hermes\\Hermes_05",
	RarityLevels = {
		Common = 1.0,
		Rare = 1.5,
		Epic = 2.0,
		Heroic = 2.5,
	},

	ExtraFields = {
		AddOutgoingDamageModifiers = {
			SpeedDamageMultiplier = {
				BaseValue = 0.5,
				SourceIsMultiplier = true,
			},
			ReportValues = {
				ReportedSpeedDamageMultiplier = "SpeedDamageMultiplier",
			},
		},
	},

	StatLines = { "SpeedDamageStatDisplay1" },
	ExtractValues = { {
		Key = "ReportedSpeedDamageMultiplier",
		ExtractAs = "TooltipBonus",
		Format = "PercentDelta",
	} },

	customStatLine = {
		ID = "BonusSpeedStatDisplay1",
		displayName = "{!Icons.Bullet}{#PropertyFormat}Move Speed:",
		description = "{#UpgradeFormat}{$TooltipData.ExtractData.TooltipSpeed:F}",
	},
})

-- Dash Healing
gods.CreateBoon({
	InheritFrom = { "BaseTrat", "FireBoon" },
	internalBoonName = "RushRallyBoon",
	characterName = "Hermes",
	--? Optional
	addToExistingGod = true,
	BlockStacking = true,

	displayName = "Quick Recovery",
	description = "After taking damage, quickly {$Keywords.Dash} to recover some {!Icons.Health} you just lost.",
	boonIconPath = "GUI\\Screens\\BoonIcons\\Hermes\\Hermes_04",
	RarityLevels = {
		Common = 0.3,
		Rare = 0.4,
		Epic = 0.5,
		Heroic = 0.6,
	},

	ExtraFields = {
		PropertyChanges = {
			{
				LuaTable = "RallyHealth",
				LuaProperty = "RallyActive",
				ChangeValue = true,
				ChangeType = "Absolute",
			},
			{
				LuaTable = "RallyHealth",
				LuaProperty = "RallyHealOnDash",
				ChangeValue = true,
				ChangeType = "Absolute",
			},
			{
				LuaTable = "RallyHealth",
				LuaProperty = "HitsDrainRallyHealthMultiplier",
				ChangeValue = 0,
				ChangeType = "Absolute",
			},
			{
				LuaTable = "RallyHealth",
				LuaProperty = "ConversionPercent",
				BaseValue = 1.0,
				-- SourceIsMultiplier = true,
				ChangeType = "Absolute",
				ReportValues = {
					ReportedHeal = "ChangeValue",
				},
			},
			{
				LuaTable = "RallyHealth",
				LuaProperty = "RallyDecayRateSeconds",
				ChangeValue = 0.3,
				ChangeType = "Absolute",
			},
		},
	},

	StatLines = { "HealingDamageStatDisplay1" },
	ExtractValues = {
		{
			Key = "ReportedHeal",
			ExtractAs = "TooltipHeal",
			Format = "Percent",
		},
	},

	customStatLine = {
		ID = "HealingDamageStatDisplay1",
		displayName = "{!Icons.Bullet}{#PropertyFormat}Life Recovered:",
		description = "{#UpgradeFormat}{$TooltipData.ExtractData.TooltipHeal:F} {#Prev}{#ItalicFormat}of damage taken.",
	},
})

-- game.ScreenData.BoonInfo.TraitDictionary.HermesUpgrade[_PLUGIN.guid .. "-BonusDashBoon"] = true
-- game.ScreenData.BoonInfo.TraitDictionary.HermesUpgrade[_PLUGIN.guid .. "-MoveSpeedBoon"] = true
-- game.ScreenData.BoonInfo.TraitDictionary.HermesUpgrade[_PLUGIN.guid .. "-SpeedDamageBoon"] = true
-- game.ScreenData.BoonInfo.TraitDictionary.HermesUpgrade[_PLUGIN.guid .. "-RushRallyBoon"] = true

--#region Dash Healing
-- The bullshit starts here
-- Adding Rally Table to Melinoe/Hero
game.HeroData.RallyHealth = {
	RallyActive = false,
	RallyHealOnDash = false,

	-- copy paste from h1
	HitsDrainRallyHealthMultiplier = 0.5, -- Whether getting hit changes the amount of rally health already stored. 0 = completely zero it out, 1 = keep all rally health.
	ConversionPercent = 1.0, -- Percent of taken damage that can be rallied back from
	RallyDecayHold = 0.04, -- Seconds rally health does not decay after a hit
	RallyDecayRateSeconds = 1.3, -- How long after a hit rally health lasts
	Store = 0, -- Data variable
	State = "Idle", -- Data variable
}

-- Does this work?
modutil.mod.Path.Wrap("DoPatches", function(base, args)
	if game.CurrentRun ~= nil then
		if game.CurrentRun.Hero ~= nil then
			if game.CurrentRun.Hero.RallyHealth == nil then
				game.CurrentRun.Hero.RallyHealth = ShallowCopyTable(game.HeroData.RallyHealth)
			else
				if game.CurrentRun.Hero.RallyHealth.RallyDecayRateSeconds == nil then
					game.CurrentRun.Hero.RallyHealth.RallyDecayRateSeconds = game.HeroData.RallyHealth.RallyDecayRateSeconds
				end
				if game.CurrentRun.Hero.RallyHealth.RallyDecayHold == nil then
					game.CurrentRun.Hero.RallyHealth.RallyDecayHold = game.HeroData.RallyHealth.RallyDecayHold
				end
				if game.CurrentRun.Hero.RallyHealth.State == nil then
					game.CurrentRun.Hero.RallyHealth.State = game.HeroData.RallyHealth.State
				end
				if game.CurrentRun.Hero.RallyHealth.MaxRallyHealthPerHit == nil then
					game.CurrentRun.Hero.RallyHealth.MaxRallyHealthPerHit = game.HeroData.RallyHealth.MaxRallyHealthPerHit
				end
			end
		end
	end
	base(args)
end)

modutil.mod.Path.Wrap("DamageHero", function(base, victim, triggerArgs)
	local sourceEffectData = nil
	if triggerArgs.EffectName then
		sourceEffectData = EffectData[triggerArgs.EffectName]
	end

	if triggerArgs.DamageAmount ~= nil and triggerArgs.DamageAmount > 0 and not triggerArgs.Silent then
		local adjustedDamageAmount = triggerArgs.DamageAmount

		if game.CurrentRun.Hero.RallyHealth.RallyActive and (sourceEffectData == nil or not sourceEffectData.NoRallyStore) and not triggerArgs.PureDamage then
			if game.CurrentRun.Hero.RallyHealth.HitsDrainRallyHealthMultiplier then
				game.CurrentRun.Hero.RallyHealth.Store = game.CurrentRun.Hero.RallyHealth.Store * game.CurrentRun.Hero.RallyHealth.HitsDrainRallyHealthMultiplier
			end
			game.CurrentRun.Hero.RallyHealth.Store = game.CurrentRun.Hero.RallyHealth.Store + adjustedDamageAmount * game.CurrentRun.Hero.RallyHealth.ConversionPercent
			thread(UpdateRallyHealthUI)
			thread(DrainRallyHealth)
		end
	end

	base(victim, triggerArgs)
end)

function DrainRallyHealth()
	if game.CurrentRun.Hero.RallyHealth.RallyDecayRateSeconds <= 0 then
		game.CurrentRun.Hero.RallyHealth.Store = 0
		return
	end

	local initialEnterState = game.CurrentRun.Hero.RallyHealth.State
	game.CurrentRun.Hero.RallyHealth.State = "Wait"

	if initialEnterState ~= nil and initialEnterState ~= "Idle" then
		return
	end

	local tickRate = 0.03
	local drainRate = 0

	while game.CurrentRun.Hero.RallyHealth.Store >= 0 do
		if game.CurrentRun.Hero.RallyHealth.State == nil or game.CurrentRun.Hero.RallyHealth.State == "Wait" then
			wait(game.CurrentRun.Hero.RallyHealth.RallyDecayHold)
			game.CurrentRun.Hero.RallyHealth.State = "Draining"
			drainRate = tickRate * game.CurrentRun.Hero.RallyHealth.Store / game.CurrentRun.Hero.RallyHealth.RallyDecayRateSeconds
		elseif game.CurrentRun.Hero.RallyHealth.State == "Draining" then
			game.CurrentRun.Hero.RallyHealth.Store = game.CurrentRun.Hero.RallyHealth.Store - drainRate
			thread(UpdateRallyHealthUI)
		end
		wait(tickRate, RoomThreadName)
	end

	RemoveRallyHealth()
end

function RemoveRallyHealth()
	game.CurrentRun.Hero.RallyHealth.Store = 0
	game.CurrentRun.Hero.RallyHealth.State = "Idle"
end

function UpdateRallyHealthUI()
	local unit = game.CurrentRun.Hero
	local rallyHealth = game.CurrentRun.Hero.RallyHealth.Store
	local currentHealth = unit.Health
	local maxHealth = unit.MaxHealth
	if game.CurrentRun.Hero.RallyHealth.Cache ~= nil then
		currentHealth = game.CurrentRun.Hero.RallyHealth.Cache.CurrentHealth
		maxHealth = game.CurrentRun.Hero.RallyHealth.Cache.MaxHealth
	end

	SetAnimationFrameTarget({
		Name = "HealthBarFillWhite",
		Fraction = 1 - (currentHealth + rallyHealth) / maxHealth,
		DestinationId = ScreenAnchors.HealthRally,
	})
end

-- Does this work?
modutil.mod.Path.Wrap("DashManeuver", function(base, duration)
	if CurrentRun.Hero.RallyHealth.RallyActive and CurrentRun.Hero.RallyHealth.RallyHealOnDash and not CurrentRun.Hero.IsDead then
		if CurrentRun.Hero.RallyHealth.Store > 0 then
			rallyHeal = round(CurrentRun.Hero.RallyHealth.Store)
			CurrentRun.Hero.RallyHealth.Store = CurrentRun.Hero.RallyHealth.Store - rallyHeal
			Heal(CurrentRun.Hero, {
				HealAmount = rallyHeal,
				SourceName = "RallyHeal",
				Silent = false,
			})
			RallyHealPresentation()
			thread(UpdateHealthUI)
		end
	end

	base(duration)
end)

-- already in game, its the wings
function RallyHealPresentation()
	CreateAnimation({
		Name = "HermesRallyHeal",
		DestinationId = CurrentRun.Hero.ObjectId,
	})
end
--#endregion
