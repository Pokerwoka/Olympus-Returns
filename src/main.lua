--TODO More Requirements, since theres more crit boons
--TODO configs for Practical_Gods
--TODO maybe relook at Sprint Boon, or make a new boon for dashes
--TODO Code Maintainence

---@diagnostic disable: undefined-global
---@meta _
local mods = rom.mods
---@module 'LuaENVY-ENVY-auto'
mods["LuaENVY-ENVY"].auto()
rom = rom
_PLUGIN = _PLUGIN
game = rom.game

modutil = mods["SGG_Modding-ModUtil"]
chalk = mods["SGG_Modding-Chalk"]
reload = mods["SGG_Modding-ReLoad"]
sjson = mods["SGG_Modding-SJSON"]
gods = mods["zannc-GodsAPI"].auto()

droppable = mods["zannc-Droppable_Gods"]
if droppable then
	droppableConfig = droppable.config
end

import_as_fallback(rom.game)

local function on_ready()
	mod = modutil.mod.Mod.Register(_PLUGIN.guid)

	function mod.getSplitConfig(god, position)
		if droppableConfig[god].enabled and droppableConfig[god].splitTraits then
			return { customGUID = "zannc-Droppable_Gods", boonPostion = position }
		end
		return nil
	end

	local names = {
		NPC_Artemis_Field_01 = {
			enabled = false,
			boons = {
				{ name = _PLUGIN.guid .. "-ArtemisWeaponBoon", position = 1 },
				{ name = _PLUGIN.guid .. "-ArtemisSpecialBoon", position = 2 },
				{ name = _PLUGIN.guid .. "-ArtemisSprintBoon", position = 3 },
				{ name = _PLUGIN.guid .. "-ArtemisArmourBoon", position = nil },
				{ name = _PLUGIN.guid .. "-ArtemisCriticalBoon", position = nil },
			},
		},
		NPC_Athena_01 = {
			enabled = false,
			boons = {},
		},
		NPC_Dionysus_01 = {
			enabled = false,
			boons = {},
		},
	}

	if droppableConfig.Artemis.enabled then
		names.NPC_Artemis_Field_01.enabled = true
		import("boons/artemisBoons.lua")
	end
	if droppableConfig.Athena.enabled then
		names.NPC_Athena_01.enabled = true
		import("boons/athenaBoons.lua")
	end
	if droppableConfig.Dionysus.enabled then
		names.NPC_Dionysus_01.enabled = true
		import("boons/dioBoons.lua")
	end

	-- import("boons/hermesBoons.lua")

	local package = rom.path.combine(_PLUGIN.plugins_data_mod_folder_path, _PLUGIN.guid)
	modutil.mod.Path.Wrap("SetupMap", function(base) -- doing traitsortorder late, works with codex and pony menu, and hopefully doesnt actually append to eligble loot.
		for godName, godData in pairs(names) do
			if godData.enabled then
				local traitSortOrder = game.ScreenData.BoonInfo.TraitSortOrder[godName]

				if traitSortOrder then
					for _, boonInfo in ipairs(godData.boons) do
						if boonInfo.position and boonInfo.position > 0 and boonInfo.position <= #traitSortOrder then
							table.insert(traitSortOrder, boonInfo.position, boonInfo.name)
						else
							table.insert(traitSortOrder, boonInfo.name)
						end
					end
				end
			end
		end

		LoadPackages({ Name = package })
		base()
	end)
end

local function on_reload() end

local loader = reload.auto_single()

modutil.once_loaded.game(function()
	mod = modutil.mod.Mod.Register(_PLUGIN.guid)
	loader.load(on_ready, on_reload)
end)
