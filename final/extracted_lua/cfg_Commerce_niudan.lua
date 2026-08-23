local cfg_Commerce_niudan = {
  [1] = {
    id = 1,
    name = "10 KC",
    count = 10,
    basemap = "img_holidayDiamondGashapon_icon_1#img_holidayDiamondGashapon_rewardBtn_1",
    effect = "Eff_ui_qiji2_niudan_dan01"
  },
  [2] = {
    id = 2,
    name = "33 KC",
    count = 33,
    basemap = "img_holidayDiamondGashapon_icon_1#img_holidayDiamondGashapon_rewardBtn_1",
    effect = "Eff_ui_qiji2_niudan_dan01"
  },
  [3] = {
    id = 3,
    name = "50 KC",
    count = 50,
    basemap = "img_holidayDiamondGashapon_icon_1#img_holidayDiamondGashapon_rewardBtn_1",
    effect = "Eff_ui_qiji2_niudan_dan01"
  },
  [4] = {
    id = 4,
    name = "88 KC",
    count = 88,
    basemap = "img_holidayDiamondGashapon_icon_2#img_holidayDiamondGashapon_rewardBtn_2",
    effect = "Eff_ui_qiji2_niudan_dan02"
  },
  [5] = {
    id = 5,
    name = "188 KC",
    count = 188,
    basemap = "img_holidayDiamondGashapon_icon_2#img_holidayDiamondGashapon_rewardBtn_2",
    effect = "Eff_ui_qiji2_niudan_dan02"
  },
  [6] = {
    id = 6,
    name = "288 KC",
    count = 288,
    basemap = "img_holidayDiamondGashapon_icon_2#img_holidayDiamondGashapon_rewardBtn_2",
    effect = "Eff_ui_qiji2_niudan_dan02"
  },
  [7] = {
    id = 7,
    name = "666 KC",
    count = 666,
    basemap = "img_holidayDiamondGashapon_icon_3#img_holidayDiamondGashapon_rewardBtn_3",
    effect = "Eff_ui_qiji2_niudan_dan03"
  },
  [8] = {
    id = 8,
    name = "999 KC",
    count = 999,
    basemap = "img_holidayDiamondGashapon_icon_3#img_holidayDiamondGashapon_rewardBtn_3",
    effect = "Eff_ui_qiji2_niudan_dan03"
  }
}
local defaults = {itemId = 1000050, group = 36001}
local mt = {__index = defaults}
for _, v in pairs(cfg_Commerce_niudan) do
  setmetatable(v, mt)
end
return cfg_Commerce_niudan
