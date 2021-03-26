local ADDON_NAME, addon = ...
Noiseless = LibStub("AceAddon-3.0"):NewAddon(addon, ADDON_NAME)


local defaults = {
	profile = {
		['*'] = true
	},
}

function addon:IterateSounds()
	for group in pairs(addon.soundPresets) do
		for name, tbl in pairs(addon.soundPresets[group]) do
			if addon.db.profile[name] then
				for i = 1, #tbl do
					local fileID = tbl[i]
					MuteSoundFile(fileID)
				end
			end
		end
	end
end

function addon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("NoiselessDB", defaults, true)
end

function addon:OnEnable()
	self:IterateSounds()
end