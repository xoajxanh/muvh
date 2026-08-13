local cfg_Item_decompose_runes = {
  [19010010] = {
    id = 19010010,
    itemId = 1901001,
    rewardBoxId = 100019001,
    clientRewardNum = "1000"
  },
  [19010020] = {
    id = 19010020,
    itemId = 1901002,
    rewardBoxId = 100019002,
    clientRewardNum = "3000"
  },
  [19010030] = {
    id = 19010030,
    itemId = 1901003,
    rewardBoxId = 100019003,
    clientRewardNum = "9000"
  },
  [19010040] = {
    id = 19010040,
    itemId = 1901004,
    rewardBoxId = 100019004,
    clientRewardNum = "27000"
  },
  [19010050] = {
    id = 19010050,
    itemId = 1901005,
    rewardBoxId = 100019005,
    clientRewardNum = "54000"
  },
  [19010060] = {
    id = 19010060,
    itemId = 1901006,
    rewardBoxId = 100019006,
    clientRewardNum = "105000"
  },
  [19010070] = {
    id = 19010070,
    itemId = 1901007,
    rewardBoxId = 100019007,
    clientRewardNum = "189000"
  },
  [19010080] = {
    id = 19010080,
    itemId = 1901008,
    rewardBoxId = 100019008,
    clientRewardNum = "340000"
  },
  [19010090] = {
    id = 19010090,
    itemId = 1901009,
    rewardBoxId = 100019009,
    clientRewardNum = "600000"
  },
  [19020010] = {
    id = 19020010,
    itemId = 1902001,
    rewardBoxId = 100019101,
    clientReward = "1000191",
    clientRewardNum = "1000"
  },
  [19020020] = {
    id = 19020020,
    itemId = 1902002,
    rewardBoxId = 100019102,
    clientReward = "1000191",
    clientRewardNum = "3000"
  },
  [19020030] = {
    id = 19020030,
    itemId = 1902003,
    rewardBoxId = 100019103,
    clientReward = "1000191",
    clientRewardNum = "9000"
  },
  [19020040] = {
    id = 19020040,
    itemId = 1902004,
    rewardBoxId = 100019104,
    clientReward = "1000191",
    clientRewardNum = "27000"
  },
  [19020050] = {
    id = 19020050,
    itemId = 1902005,
    rewardBoxId = 100019105,
    clientReward = "1000191",
    clientRewardNum = "54000"
  },
  [19020060] = {
    id = 19020060,
    itemId = 1902006,
    rewardBoxId = 100019106,
    clientReward = "1000191",
    clientRewardNum = "105000"
  },
  [19020070] = {
    id = 19020070,
    itemId = 1902007,
    rewardBoxId = 100019107,
    clientReward = "1000191",
    clientRewardNum = "189000"
  },
  [19020080] = {
    id = 19020080,
    itemId = 1902008,
    rewardBoxId = 100019108,
    clientReward = "1000191",
    clientRewardNum = "340000"
  },
  [19020090] = {
    id = 19020090,
    itemId = 1902009,
    rewardBoxId = 100019109,
    clientReward = "1000191",
    clientRewardNum = "600000"
  },
  [19030010] = {
    id = 19030010,
    itemId = 1903001,
    rewardBoxId = 100019201,
    clientReward = "1000192",
    clientRewardNum = "1000"
  },
  [19030020] = {
    id = 19030020,
    itemId = 1903002,
    rewardBoxId = 100019202,
    clientReward = "1000192",
    clientRewardNum = "3000"
  },
  [19030030] = {
    id = 19030030,
    itemId = 1903003,
    rewardBoxId = 100019203,
    clientReward = "1000192",
    clientRewardNum = "9000"
  },
  [19030040] = {
    id = 19030040,
    itemId = 1903004,
    rewardBoxId = 100019204,
    clientReward = "1000192",
    clientRewardNum = "27000"
  },
  [19030050] = {
    id = 19030050,
    itemId = 1903005,
    rewardBoxId = 100019205,
    clientReward = "1000192",
    clientRewardNum = "54000"
  },
  [19030060] = {
    id = 19030060,
    itemId = 1903006,
    rewardBoxId = 100019206,
    clientReward = "1000192",
    clientRewardNum = "105000"
  },
  [19030070] = {
    id = 19030070,
    itemId = 1903007,
    rewardBoxId = 100019207,
    clientReward = "1000192",
    clientRewardNum = "189000"
  },
  [19030080] = {
    id = 19030080,
    itemId = 1903008,
    rewardBoxId = 100019208,
    clientReward = "1000192",
    clientRewardNum = "340000"
  },
  [19030090] = {
    id = 19030090,
    itemId = 1903009,
    rewardBoxId = 100019209,
    clientReward = "1000192",
    clientRewardNum = "600000"
  }
}
local defaults = {
  runesLevel = 0,
  moneyCost = "1000021#100",
  clientReward = "1000190"
}
local mt = {__index = defaults}
for _, v in pairs(cfg_Item_decompose_runes) do
  setmetatable(v, mt)
end
return cfg_Item_decompose_runes
