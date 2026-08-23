local cfg_Level_rankReward = {
  [1] = {
    id = 1,
    level = 1,
    showLevel = "Lv.1",
    reward1 = "760001",
    reward2 = "760101"
  },
  [2] = {
    id = 2,
    level = 150,
    showLevel = "Lv.150",
    reward1 = "760002"
  },
  [3] = {
    id = 3,
    level = 200,
    showLevel = "Lv.200",
    reward1 = "760003",
    reward2 = "760102"
  },
  [4] = {
    id = 4,
    level = 300,
    showLevel = "Lv.300",
    reward1 = "760004"
  },
  [5] = {
    id = 5,
    level = 350,
    showLevel = "Lv.350",
    reward1 = "760005",
    reward2 = "760103"
  },
  [6] = {
    id = 6,
    level = 401,
    showLevel = "Lv.401",
    reward1 = "760006"
  },
  [7] = {
    id = 7,
    level = 450,
    showLevel = "Lv.450",
    reward1 = "760007",
    reward2 = "760104"
  },
  [8] = {
    id = 8,
    level = 500,
    showLevel = "Lv.500",
    reward1 = "760008"
  },
  [9] = {
    id = 9,
    level = 550,
    showLevel = "Lv.550",
    reward1 = "760009",
    reward2 = "760105"
  },
  [10] = {
    id = 10,
    level = 600,
    showLevel = "Lv.600",
    reward1 = "760010"
  },
  [11] = {
    id = 11,
    level = 700,
    showLevel = "Lv.700",
    reward1 = "760011",
    reward2 = "760106"
  },
  [12] = {
    id = 12,
    level = 801,
    showLevel = "Lv.801",
    reward1 = "760012"
  },
  [13] = {
    id = 13,
    level = 900,
    showLevel = "Lv.900",
    reward1 = "760013",
    reward2 = "760107"
  },
  [14] = {
    id = 14,
    level = 1000,
    showLevel = "Lv.1000",
    reward1 = "760014"
  },
  [15] = {
    id = 15,
    level = 1100,
    showLevel = "Lv.1100",
    reward1 = "760015",
    reward2 = "760108"
  },
  [16] = {
    id = 16,
    level = 1201,
    showLevel = "Lv.1201",
    reward1 = "760016"
  },
  [17] = {
    id = 17,
    level = 1300,
    showLevel = "Lv.1300",
    reward1 = "760017",
    reward2 = "760109"
  },
  [18] = {
    id = 18,
    level = 1400,
    showLevel = "Lv.1400",
    reward1 = "760018"
  },
  [19] = {
    id = 19,
    level = 1500,
    showLevel = "Lv.1500",
    reward1 = "760019",
    reward2 = "760110"
  },
  [20] = {
    id = 20,
    level = 1601,
    showLevel = "Lv.1601",
    reward1 = "760020"
  },
  [21] = {
    id = 21,
    level = 1700,
    showLevel = "Lv.1700",
    reward1 = "760021",
    reward2 = "760111"
  },
  [22] = {
    id = 22,
    level = 1800,
    showLevel = "Lv.1800",
    reward1 = "760022"
  },
  [23] = {
    id = 23,
    level = 2001,
    showLevel = "Lv.2001",
    reward1 = "760023",
    reward2 = "760112"
  }
}
local defaults = {place = 100, reward2 = ""}
local mt = {__index = defaults}
for _, v in pairs(cfg_Level_rankReward) do
  setmetatable(v, mt)
end
return cfg_Level_rankReward
