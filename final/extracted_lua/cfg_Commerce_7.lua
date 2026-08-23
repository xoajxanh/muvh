local cfg_Commerce_7 = {
  [3006001] = {
    id = 3006001,
    itemId = "300001#1&300002#1",
    reward = "6000091#30",
    countkey = 3006044,
    showCondition = {
      {
        {901, 9999},
        {903, 9999}
      }
    }
  },
  [3006002] = {
    id = 3006002,
    itemId = "300005#1&300006#1",
    reward = "6000101#30",
    countkey = 3006045,
    showCondition = {
      {
        {901, 9999},
        {903, 9999}
      }
    }
  },
  [3006003] = {
    id = 3006003,
    itemId = "300001#1&300002#1&300003#1&300004#1",
    reward = "6000379#2",
    countkey = 3006046,
    showCondition = {
      {
        {901, 9999},
        {903, 9999}
      }
    }
  },
  [3006004] = {
    id = 3006004,
    itemId = "300001#1&300002#1&300005#1&300006#1",
    reward = "6000111#2",
    countkey = 3006047,
    showCondition = {
      {
        {901, 9999},
        {903, 9999}
      }
    }
  },
  [3006005] = {
    id = 3006005,
    itemId = "300001#1&300002#1&300003#1&300004#1&300005#1&300006#1",
    reward = "1000050#200",
    countkey = 3006048,
    showCondition = {
      {
        {901, 9999},
        {903, 9999}
      }
    }
  },
  [3006006] = {
    id = 3006006,
    itemId = "300024#1&300025#1",
    reward = "6000091#30",
    countkey = 3006054,
    showCondition = {
      {
        {901, 1},
        {903, 999}
      }
    }
  },
  [3006007] = {
    id = 3006007,
    itemId = "300021#1&300023#1",
    reward = "6000101#30",
    countkey = 3006055,
    showCondition = {
      {
        {901, 1},
        {903, 999}
      }
    }
  },
  [3006008] = {
    id = 3006008,
    itemId = "300020#1&300022#1&300024#1",
    reward = "6000379#2",
    countkey = 3006056,
    showCondition = {
      {
        {901, 1},
        {903, 999}
      }
    }
  },
  [3006009] = {
    id = 3006009,
    itemId = "300020#1&300024#1&300025#1",
    reward = "6000111#2",
    countkey = 3006057,
    showCondition = {
      {
        {901, 1},
        {903, 999}
      }
    }
  },
  [3006010] = {
    id = 3006010,
    itemId = "300020#1&300021#1&300022#1&300023#1&300024#1&300025#1",
    reward = "1000050#200",
    countkey = 3006058,
    showCondition = {
      {
        {901, 1},
        {903, 999}
      }
    }
  }
}
local defaults = {commerceId = 30006}
local mt = {__index = defaults}
for _, v in pairs(cfg_Commerce_7) do
  setmetatable(v, mt)
end
return cfg_Commerce_7
