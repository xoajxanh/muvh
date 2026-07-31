local cfg_Item_equip_regenerateSetting = {
  {
    id = {1, 1},
    type = 1,
    condition = {2001, 100}
  },
  {
    id = {1, 2},
    type = 2,
    condition = {2001, 100}
  },
  {
    id = {1, 3},
    type = 3,
    condition = {2001, 100}
  },
  {
    id = {1, 4},
    type = 4,
    condition = {2001, 100}
  },
  {
    id = {1, 5},
    type = 5,
    condition = {2001, 100}
  },
  {
    id = {1, 6},
    type = 6,
    condition = {2001, 100}
  },
  {
    id = {1, 7},
    type = 7,
    condition = {2001, 100}
  },
  {
    id = {1, 8},
    type = 8,
    condition = {2001, 100}
  },
  {
    id = {1, 9},
    type = 9,
    condition = {2001, 100}
  },
  {
    id = {1, 10},
    type = 10,
    condition = {2001, 100}
  },
  {
    id = {1, 11},
    type = 11,
    condition = {2001, 100}
  },
  {
    id = {1, 12},
    type = 12,
    condition = {2001, 100}
  },
  {
    id = {1, 81},
    type = 81,
    condition = {2001, 100}
  },
  {
    id = {1, 24},
    type = 24,
    condition = {2001, 100}
  },
  {
    id = {1, 25},
    type = 25,
    condition = {2001, 100}
  },
  {
    id = {1, 42},
    type = 42,
    condition = {2001, 100}
  },
  {
    id = {1, 56},
    type = 56,
    condition = {2001, 100}
  },
  {
    id = {1, 57},
    type = 57,
    condition = {2001, 100}
  },
  {
    id = {3, 13},
    type = 13,
    condition = {2001, 100}
  },
  {
    id = {4, 14},
    type = 14,
    condition = {2001, 100}
  },
  {
    id = {5, 15},
    type = 15,
    condition = {2001, 100}
  },
  {
    id = {6, 16},
    type = 16,
    condition = {2001, 100}
  },
  {
    id = {7, 17},
    type = 17,
    condition = {2001, 100}
  },
  {
    id = {8, 43},
    type = 43,
    condition = {2001, 100}
  }
}
local defaults = {cost = "6000151#1", lockcost = "6000151#3"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Item_equip_regenerateSetting) do
  setmetatable(v, mt)
end
return cfg_Item_equip_regenerateSetting
