local cfg_DemonHunt_rankReward = {
  {
    id = 1,
    itemReward = "1000050#300&35000009#10",
    buffReward = "330001"
  },
  {
    id = 2,
    itemReward = "1000050#250&35000009#9",
    buffReward = "330002"
  },
  {
    id = 3,
    itemReward = "1000050#200&35000009#8",
    buffReward = "330003"
  },
  {
    id = 4,
    itemReward = "1000050#190&35000009#7",
    buffReward = "330004"
  },
  {
    id = 5,
    itemReward = "1000050#180&35000009#6",
    buffReward = "330005"
  },
  {
    id = 6,
    itemReward = "1000050#170&35000009#5",
    buffReward = "330006"
  },
  {
    id = 7,
    itemReward = "1000050#160&35000009#5",
    buffReward = "330007"
  },
  {
    id = 8,
    itemReward = "1000050#150&35000009#5",
    buffReward = "330008"
  },
  {
    id = 9,
    itemReward = "1000050#140&35000009#5",
    buffReward = "330009"
  },
  {
    id = 10,
    itemReward = "1000050#130&35000009#5",
    buffReward = "330010"
  },
  {
    id = 11,
    itemReward = "1000050#120&35000009#4",
    buffReward = "330011"
  },
  {
    id = 12,
    itemReward = "1000050#110&35000009#4",
    buffReward = "330011"
  },
  {
    id = 13,
    itemReward = "1000050#100&35000009#4",
    buffReward = "330011"
  },
  {
    id = 14,
    itemReward = "1000050#90&35000009#4",
    buffReward = "330011"
  },
  {
    id = 15,
    itemReward = "1000050#80&35000009#4",
    buffReward = "330011"
  },
  {
    id = 16,
    itemReward = "1000050#80&35000009#3",
    buffReward = "330012"
  },
  {
    id = 17,
    itemReward = "1000050#80&35000009#3",
    buffReward = "330012"
  },
  {
    id = 18,
    itemReward = "1000050#80&35000009#3",
    buffReward = "330012"
  },
  {
    id = 19,
    itemReward = "1000050#70&35000009#3",
    buffReward = "330012"
  },
  {
    id = 20,
    itemReward = "1000050#70&35000009#3",
    buffReward = "330012"
  },
  {
    id = 21,
    itemReward = "1000050#70&35000009#2"
  },
  {
    id = 22,
    itemReward = "1000050#60&35000009#2"
  },
  {
    id = 23,
    itemReward = "1000050#60&35000009#2"
  },
  {
    id = 24,
    itemReward = "1000050#60&35000009#2"
  },
  {
    id = 25,
    itemReward = "1000050#50&35000009#2"
  },
  {
    id = 26,
    itemReward = "1000050#50&35000009#1"
  },
  {
    id = 27,
    itemReward = "1000050#50&35000009#1"
  },
  {
    id = 28,
    itemReward = "1000050#40&35000009#1"
  },
  {
    id = 29,
    itemReward = "1000050#40&35000009#1"
  },
  {
    id = 30,
    itemReward = "1000050#40&35000009#1"
  }
}
local defaults = {buffReward = "330013"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_DemonHunt_rankReward) do
  setmetatable(v, mt)
end
return cfg_DemonHunt_rankReward
