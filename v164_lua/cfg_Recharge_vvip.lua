local cfg_Recharge_vvip = {
  {
    id = 2290001,
    level = 0,
    desc = "VvipMapOpen_1",
    vvipGift = 0,
    bugMethod = 0,
    shopId = 0,
    subType = 1
  },
  {
    id = 2290010,
    level = 1,
    desc = "VvipExperienceRate#experienceRate&VvipgemstoneRate_1&MonthCardPrivilege_2#sellGoldUpRatio&VvipMapOpen_1&VvipAuctionSaleMaxUp#auctionSaleMaxUp",
    vvipGift = 605001,
    shopId = 100002
  },
  {
    id = 2290011,
    level = 2,
    desc = "VvipExperienceRate#experienceRate&VvipgemstoneRate_2&MonthCardPrivilege_2#sellGoldUpRatio&VvipShop&VvipMapOpen_2&VvipAuctionSaleMaxUp#auctionSaleMaxUp",
    vvipGift = 605002,
    shopId = 100003
  },
  {
    id = 2290012,
    level = 3,
    desc = "VvipExperienceRate#experienceRate&VvipgemstoneRate_3&MonthCardPrivilege_2#sellGoldUpRatio&VvipShop&VvipAutoSell&VvipMapOpen_3&VvipAuctionSaleMaxUp#auctionSaleMaxUp",
    vvipGift = 605003,
    shopId = 100004
  },
  {
    id = 2290013,
    level = 4,
    desc = "VvipExperienceRate#experienceRate&VvipgemstoneRate_4&MonthCardPrivilege_2#sellGoldUpRatio&VvipShop&VvipAutoSell&VvipWarehouse&VvipMapOpen_4&VvipAuctionSaleMaxUp#auctionSaleMaxUp",
    vvipGift = 605004,
    shopId = 100005
  },
  {
    id = 2290014,
    level = 5,
    desc = "VvipExperienceRate#experienceRate&VvipgemstoneRate_5&MonthCardPrivilege_2#sellGoldUpRatio&VvipShop&VvipAutoSell&VvipWarehouse&VvipAutoBugDrugs&VvipMapOpen_5&VvipAuctionSaleMaxUp#auctionSaleMaxUp",
    vvipGift = 605005,
    shopId = 100006
  },
  {
    id = 2290015,
    level = 6,
    desc = "VvipExperienceRate#experienceRate&VvipgemstoneRate_6&MonthCardPrivilege_2#sellGoldUpRatio&VvipShop&VvipAutoSell&VvipWarehouse&VvipAutoBugDrugs&VvipMapOpen_6&VvipAuctionSaleMaxUp#auctionSaleMaxUp",
    vvipGift = 605006,
    shopId = 100007
  },
  {
    id = 2290016,
    level = 7,
    desc = "VvipExperienceRate#experienceRate&VvipgemstoneRate_7&MonthCardPrivilege_2#sellGoldUpRatio&VvipShop&VvipAutoSell&VvipWarehouse&VvipAutoBugDrugs&VvipMapOpen_7&VvipAuctionSaleMaxUp#auctionSaleMaxUp",
    vvipGift = 605007,
    shopId = 100008
  }
}
local defaults = {bugMethod = 1, subType = 2}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Recharge_vvip) do
  setmetatable(v, mt)
end
return cfg_Recharge_vvip
