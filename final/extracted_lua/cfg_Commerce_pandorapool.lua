local cfg_Commerce_pandorapool = {
  [1015] = {
    id = 1015,
    commerceId = 100001,
    count = 3040010
  },
  [100002] = {
    id = 100002,
    commerceId = 100002,
    count = 3040011
  },
  [100003] = {
    id = 100003,
    commerceId = 100003,
    count = 3040012
  },
  [100004] = {
    id = 100004,
    commerceId = 100004,
    count = 3040013
  },
  [100005] = {
    id = 100005,
    commerceId = 100005,
    count = 3040014
  },
  [100006] = {
    id = 100006,
    commerceId = 100006,
    count = 3040015
  },
  [100007] = {
    id = 100007,
    commerceId = 100007,
    count = 3040016
  },
  [100008] = {
    id = 100008,
    commerceId = 100008,
    count = 3040017
  },
  [100009] = {
    id = 100009,
    commerceId = 100009,
    count = 3040018
  },
  [100010] = {
    id = 100010,
    commerceId = 100010,
    count = 3040019
  },
  [100011] = {
    id = 100011,
    commerceId = 100011,
    count = 3040020
  },
  [100012] = {
    id = 100012,
    commerceId = 100012,
    count = 3040021
  },
  [100013] = {
    id = 100013,
    commerceId = 100013,
    count = 3040022
  },
  [100014] = {
    id = 100014,
    commerceId = 100014,
    count = 3040023
  },
  [100015] = {
    id = 100015,
    commerceId = 100015,
    count = 3040024
  }
}
local defaults = {
  itemId = 10901001,
  cost = {1000050, 100}
}
local mt = {__index = defaults}
for _, v in pairs(cfg_Commerce_pandorapool) do
  setmetatable(v, mt)
end
return cfg_Commerce_pandorapool
