local cfg_Commerce_touzi = {
  [1001] = {
    id = 1001,
    condition = {
      {
        {901, 1}
      }
    },
    itemId = 1000030,
    des = "1"
  },
  [1002] = {
    id = 1002,
    condition = {
      {
        {901, 2}
      }
    },
    des = "2"
  },
  [1003] = {
    id = 1003,
    condition = {
      {
        {901, 3}
      }
    },
    des = "3"
  },
  [1004] = {
    id = 1004,
    condition = {
      {
        {901, 4}
      }
    },
    des = "4"
  },
  [1005] = {
    id = 1005,
    condition = {
      {
        {901, 5}
      }
    },
    des = "5"
  },
  [2001] = {
    id = 2001,
    condition = {
      {
        {901, 1}
      }
    },
    itemId = 1000030,
    num = 1650,
    des = "1",
    RechargeId = 1900002
  },
  [2002] = {
    id = 2002,
    condition = {
      {
        {901, 2}
      }
    },
    num = 1650,
    des = "2",
    RechargeId = 1900002
  },
  [2003] = {
    id = 2003,
    condition = {
      {
        {901, 3}
      }
    },
    num = 1650,
    des = "3",
    RechargeId = 1900002
  },
  [2004] = {
    id = 2004,
    condition = {
      {
        {901, 4}
      }
    },
    num = 1650,
    des = "4",
    RechargeId = 1900002
  },
  [2005] = {
    id = 2005,
    condition = {
      {
        {901, 5}
      }
    },
    num = 1650,
    des = "5",
    RechargeId = 1900002
  }
}
local defaults = {
  itemId = 1000050,
  num = 680,
  RechargeId = 1900001
}
local mt = {__index = defaults}
for _, v in pairs(cfg_Commerce_touzi) do
  setmetatable(v, mt)
end
return cfg_Commerce_touzi
