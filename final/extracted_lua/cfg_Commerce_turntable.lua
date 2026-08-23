local cfg_Commerce_turntable = {
  [1] = {
    id = 1,
    itemId = 5002001,
    name = "Ph\195\178ng C\225\187\165 May M\225\186\175n-\196\144\225\186\167u",
    condition = {
      {
        {101, 1}
      }
    }
  },
  [2] = {
    id = 2,
    itemId = 5002002,
    name = "Ph\195\178ng C\225\187\165 May M\225\186\175n-Tay",
    condition = {
      {
        {101, 1}
      }
    }
  },
  [3] = {
    id = 3,
    itemId = 5002003,
    name = "V\197\169 Kh\195\173 Ch\195\173nh May M\225\186\175n",
    condition = {
      {
        {101, 1}
      }
    },
    getShow = 1
  },
  [4] = {
    id = 4,
    itemId = 5002004,
    name = "Kim C\198\176\198\161ng Kh\195\179a",
    condition = {
      {
        {101, 1}
      }
    }
  },
  [5] = {
    id = 5,
    itemId = 5002005,
    name = "Ph\195\178ng C\225\187\165 May M\225\186\175n-Ch\195\162n",
    condition = {
      {
        {101, 1}
      }
    }
  },
  [6] = {
    id = 6,
    itemId = 5002006,
    name = "V\197\169 Kh\195\173 Ph\225\187\165 May M\225\186\175n",
    condition = {
      {
        {101, 1}
      }
    },
    getShow = 1
  },
  [7] = {
    id = 7,
    itemId = 5002007,
    name = "Ph\195\178ng C\225\187\165 May M\225\186\175n-Gi\195\161p",
    condition = {
      {
        {101, 1}
      }
    }
  },
  [8] = {
    id = 8,
    itemId = 5002008,
    name = "Ph\195\178ng C\225\187\165 May M\225\186\175n-Gi\195\160y",
    condition = {
      {
        {101, 1}
      }
    }
  }
}
local defaults = {
  count = 1,
  group = 32001,
  getShow = 0
}
local mt = {__index = defaults}
for _, v in pairs(cfg_Commerce_turntable) do
  setmetatable(v, mt)
end
return cfg_Commerce_turntable
