local cfg_SeaChest_cost = {
  [1001] = {
    id = 1001,
    type = 1,
    costStone = {729001100, 1}
  },
  [2001] = {
    id = 2001,
    type = 2,
    costStone = {729001101, 1}
  },
  [3001] = {
    id = 3001,
    type = 3,
    costStone = {729001102, 1}
  },
  [4001] = {
    id = 4001,
    type = 4,
    costStone = {729001103, 1}
  },
  [5001] = {
    id = 5001,
    type = 5,
    costStone = {729001104, 1}
  },
  [6001] = {
    id = 6001,
    type = 6,
    costStone = {729001105, 1}
  }
}
local defaults = {
  count = 1,
  cost = {1000050, 400}
}
local mt = {__index = defaults}
for _, v in pairs(cfg_SeaChest_cost) do
  setmetatable(v, mt)
end
return cfg_SeaChest_cost
