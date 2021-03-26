local ADDON_NAME, addon = ...
local module = addon:NewModule("Config")
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

local lastSoundHandle

local function GetOptions()
	local options = {
		name = ADDON_NAME,
		type = "group",
		get = function(info) return addon.db.profile[info[#info]] end,
		args = {
			desc = {
				type = "description",
				name = L["Mute some annoying game sounds."].."\n\n",
				fontSize = "medium",
				order = 0,
			},
			mounts = {
				type = "group",
				name = L["Mounts"],
				order = 1,
				args = {},
			},
			emotes = {
				type = "group",
				name = L["Emotes"],
				order = 2,
				args = {},
			},
			abilities = {
				type = "group",
				name = L["Abilities"],
				order = 3,
				args = {},
			},
			voicelines = {
				type = "group",
				name = L["Voice Lines"],
				order = 4,
				args = {},
			},
			interface = {
				type = "group",
				name = L["Interface"],
				order = 5,
				args = {},
			},
		},
	}

	local count = 0
	for group in pairs(addon.soundPresets) do
		for name, tbl in pairs(addon.soundPresets[group]) do
			if not options.args[group].args[name.."preview"] then
				options.args[group].args[name.."preview"] = {
					type = "execute",
					name = L["Sample"],
					width = 0.5,
					func = function()
						module:SoundPreview(name, tbl)
					end,
					order = count,
				}
				count = count + 1
			end
			if not options.args[group].args[name] then
				options.args[group].args[name] = {
					type = "toggle",
					name = L[name],
					arg = tbl,
					width = 1.5,
					set = function(info, value)
						db[info[#info]] = value
						module:ToggleMuteStatus(name, tbl)
					end,
					order = count
				}
				count = count + 1
			end
		end
	end

	return options
end

function module:SoundPreview(name, tbl)
	if lastSoundHandle then StopSound(lastSoundHandle) end
	local fileID = tbl[fastrandom(1, #tbl)]
	UnmuteSoundFile(fileID)
	local _, soundHandle = PlaySoundFile(fileID, "Master")
	lastSoundHandle = soundHandle
	if addon.db.profile[name] then
		MuteSoundFile(fileID)
	end
end

function module:ToggleMuteStatus(name, tbl)
	for i = 1, #tbl do
		local fileID = tbl[i]
		if addon.db.profile[name] then
			MuteSoundFile(fileID)
		else
			UnmuteSoundFile(fileID)
		end
	end
end

function module:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable(ADDON_NAME, GetOptions)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(ADDON_NAME)
end