local cfg_puzzle_zhuanyi = {
  {
    id = 1,
    level = 0,
    cost = ""
  },
  {id = 2, level = 1},
  {id = 3, level = 2},
  {id = 4, level = 3},
  {id = 5, level = 4},
  {id = 6, level = 5},
  {id = 7, level = 6},
  {id = 8, level = 7},
  {id = 9, level = 8},
  {id = 10, level = 9},
  {id = 11, level = 10},
  {id = 12, level = 11},
  {id = 13, level = 12},
  {id = 14, level = 13},
  {id = 15, level = 14},
  {id = 16, level = 15},
  {id = 17, level = 16},
  {id = 18, level = 17},
  {id = 19, level = 18},
  {id = 20, level = 19},
  {id = 21, level = 20}
}
local defaults = {
  type = 29,
  cost = "1000021#10",
  des = ""
}
local mt = {__index = defaults}
for _, v in ipairs(cfg_puzzle_zhuanyi) do
  setmetatable(v, mt)
end
return cfg_puzzle_zhuanyi
