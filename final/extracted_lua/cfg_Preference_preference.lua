local cfg_Preference_preference = {
  [1] = {
    id = 1,
    panel = 1,
    settingItem = "musicVolume",
    value = 0.5,
    saveType = 1
  },
  [2] = {
    id = 2,
    panel = 1,
    settingItem = "soundVolume",
    value = 0.5,
    saveType = 1
  },
  [3] = {
    id = 3,
    panel = 1,
    settingItem = "speechVolume",
    value = 0.5,
    saveType = 1
  },
  [4] = {
    id = 4,
    panel = 1,
    settingItem = "joyStickMode",
    value = 2
  },
  [5] = {
    id = 5,
    panel = 1,
    settingItem = "quickSlotOn"
  },
  [7] = {
    id = 7,
    settingItem = "hidePlayerModelCamp"
  },
  [9] = {
    id = 9,
    settingItem = "hideSkillEffectCamp"
  },
  [11] = {
    id = 11,
    settingItem = "hidePetModelCamp"
  },
  [13] = {
    id = 13,
    settingItem = "hidePetNameCamp"
  },
  [14] = {
    id = 14,
    settingItem = "hideMonsterModel",
    value = 0
  },
  [15] = {
    id = 15,
    settingItem = "hideMonsterSkillEffect",
    value = 0
  },
  [16] = {
    id = 16,
    settingItem = "perfermanceOption",
    value = 2
  },
  [17] = {
    id = 17,
    panel = 3,
    settingItem = "useHPMedicineThreshold",
    value = 0.7
  },
  [18] = {
    id = 18,
    panel = 3,
    settingItem = "autoHpMedicine",
    value = 0
  },
  [19] = {
    id = 19,
    panel = 3,
    settingItem = "useMPMedicineThreshold",
    value = 0.7
  },
  [20] = {
    id = 20,
    panel = 3,
    settingItem = "autoMpMedicine",
    value = 0
  },
  [21] = {
    id = 21,
    panel = 3,
    settingItem = "autoPickUpSet",
    value = -1
  },
  [22] = {
    id = 22,
    settingItem = "hidePlayerWingCamp"
  },
  [23] = {
    id = 23,
    settingItem = "hidePlayerBootCamp"
  }
}
local defaults = {
  panel = 2,
  value = 1,
  saveType = 2
}
local mt = {__index = defaults}
for _, v in pairs(cfg_Preference_preference) do
  setmetatable(v, mt)
end
return cfg_Preference_preference
