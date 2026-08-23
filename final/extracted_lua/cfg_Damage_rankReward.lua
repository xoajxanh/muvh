local cfg_Damage_rankReward = {
  {
    id = 1,
    monster = 20201004,
    reward = "10801001#3"
  },
  {
    id = 2,
    monster = 20201004,
    rank = "2#2",
    reward = "10801001#2"
  },
  {
    id = 3,
    monster = 20201004,
    rank = "3#3",
    reward = "10801001#1"
  },
  {
    id = 4,
    monster = 20201005,
    reward = "10801002#3"
  },
  {
    id = 5,
    monster = 20201005,
    rank = "2#2",
    reward = "10801002#2"
  },
  {
    id = 6,
    monster = 20201005,
    rank = "3#3",
    reward = "10801002#1"
  },
  {
    id = 7,
    monster = 20201006,
    reward = "10801003#3"
  },
  {
    id = 8,
    monster = 20201006,
    rank = "2#2",
    reward = "10801003#2"
  },
  {
    id = 9,
    monster = 20201006,
    rank = "3#3",
    reward = "10801003#1"
  },
  {
    id = 10,
    monster = 20201007,
    reward = "10801004#3"
  },
  {
    id = 11,
    monster = 20201007,
    rank = "2#2",
    reward = "10801004#2"
  },
  {
    id = 12,
    monster = 20201007,
    rank = "3#3",
    reward = "10801004#1"
  },
  {
    id = 13,
    monster = 20201008,
    reward = "10801005#3"
  },
  {
    id = 14,
    monster = 20201008,
    rank = "2#2",
    reward = "10801005#2"
  },
  {
    id = 15,
    monster = 20201008,
    rank = "3#3",
    reward = "10801005#1"
  },
  {
    id = 16,
    monster = 20201009,
    reward = "10801006#3"
  },
  {
    id = 17,
    monster = 20201009,
    rank = "2#2",
    reward = "10801006#2"
  },
  {
    id = 18,
    monster = 20201009,
    rank = "3#3",
    reward = "10801006#1"
  },
  {
    id = 19,
    monster = 20201010,
    reward = "10801006#3"
  },
  {
    id = 20,
    monster = 20201010,
    rank = "2#2",
    reward = "10801006#2"
  },
  {
    id = 21,
    monster = 20201010,
    rank = "3#3",
    reward = "10801006#1"
  },
  {
    id = 22,
    monster = 20201011,
    reward = "10801006#3"
  },
  {
    id = 23,
    monster = 20201011,
    rank = "2#2",
    reward = "10801006#2"
  },
  {
    id = 24,
    monster = 20201011,
    rank = "3#3",
    reward = "10801006#1"
  },
  {
    id = 25,
    monster = 20201012,
    reward = "10801007#3"
  },
  {
    id = 26,
    monster = 20201012,
    rank = "2#2",
    reward = "10801007#2"
  },
  {
    id = 27,
    monster = 20201012,
    rank = "3#3",
    reward = "10801007#1"
  },
  {
    id = 28,
    monster = 20201013,
    reward = "10801008#3"
  },
  {
    id = 29,
    monster = 20201013,
    rank = "2#2",
    reward = "10801008#2"
  },
  {
    id = 30,
    monster = 20201013,
    rank = "3#3",
    reward = "10801008#1"
  },
  {
    id = 31,
    monster = 20201014,
    reward = "10801009#3"
  },
  {
    id = 32,
    monster = 20201014,
    rank = "2#2",
    reward = "10801009#2"
  },
  {
    id = 33,
    monster = 20201014,
    rank = "3#3",
    reward = "10801009#1"
  },
  {
    id = 34,
    monster = 20201015,
    reward = "10801010#3"
  },
  {
    id = 35,
    monster = 20201015,
    rank = "2#2",
    reward = "10801010#2"
  },
  {
    id = 36,
    monster = 20201015,
    rank = "3#3",
    reward = "10801010#1"
  }
}
local defaults = {
  activityId = 2020,
  rank = "1#1",
  condition = "1",
  title = "Th\198\176\225\187\159ng X\225\186\191p H\225\186\161ng S\195\161t Th\198\176\198\161ng BOSS Th\195\161nh C\225\187\145t",
  content = "B\225\186\161n x\225\186\191p h\225\186\161ng <color=#1add1f>%d</color> trong BXH S\195\161t Th\198\176\198\161ng ti\195\170u di\225\187\135t BOSS Th\195\161nh C\225\187\145t\227\128\130 d\198\176\225\187\155i \196\145\195\162y l\195\160 ph\225\186\167n th\198\176\225\187\159ng c\225\187\167a b\225\186\161n:"
}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Damage_rankReward) do
  setmetatable(v, mt)
end
return cfg_Damage_rankReward
