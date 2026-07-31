local cfg_Commerce_Rebate = {
  {
    id = 10001,
    goalId = 1606001,
    range = "10#20",
    turntable = "2",
    describe = "\196\144\196\131ng nh\225\186\173p\nCao nh\225\186\165t t\225\186\183ng 20 KC"
  },
  {
    id = 10002,
    goalId = 1606002,
    range = "36#72",
    turntable = "2",
    describe = "T\195\173ch n\225\186\161p 25000 VN\196\144\nCao nh\225\186\165t t\225\186\183ng 72 KC"
  },
  {
    id = 10003,
    goalId = 1606003,
    range = "372#744",
    turntable = "3",
    describe = "T\195\173ch n\225\186\161p 68 VN\196\144\nCao nh\225\186\165t t\225\186\183ng 744 KC"
  },
  {
    id = 10004,
    goalId = 1606004,
    range = "1560#3120",
    describe = "T\195\173ch n\225\186\161p 328 VN\196\144\nCao nh\225\186\165t t\225\186\183ng 3120 KC"
  },
  {
    id = 10005,
    goalId = 1606005,
    range = "1280#3840",
    describe = "T\195\173ch n\225\186\161p 648 VN\196\144\nCao nh\225\186\165t t\225\186\183ng 3840 KC"
  },
  {
    id = 10006,
    goalId = 1606006,
    range = "1400#4200",
    describe = "T\195\173ch n\225\186\161p 998 VN\196\144\nCao nh\225\186\165t t\225\186\183ng 4200 KC"
  },
  {
    id = 10007,
    goalId = 1606007,
    range = "1560#4680",
    describe = "T\195\173ch n\225\186\161p 1388 VN\196\144\nCao nh\225\186\165t t\225\186\183ng 4680 KC"
  },
  {
    id = 10008,
    goalId = 1606008,
    range = "2000#6000",
    describe = "T\195\173ch n\225\186\161p 1888 VN\196\144\nCao nh\225\186\165t t\225\186\183ng 6000 KC"
  },
  {
    id = 10009,
    goalId = 1606009,
    range = "2000#6000",
    describe = "T\195\173ch n\225\186\161p 2388 VN\196\144\nCao nh\225\186\165t t\225\186\183ng 6000 KC"
  },
  {
    id = 10010,
    goalId = 1606010,
    range = "2000#6000",
    describe = "T\195\173ch n\225\186\161p 2888 VN\196\144\nCao nh\225\186\165t t\225\186\183ng 6000 KC"
  },
  {
    id = 10011,
    goalId = 1606011,
    describe = "T\195\173ch n\225\186\161p 3388 VN\196\144\nCao nh\225\186\165t t\225\186\183ng 6000 KC"
  },
  {
    id = 10012,
    goalId = 1606012,
    describe = "T\195\173ch n\225\186\161p 3888 VN\196\144\nCao nh\225\186\165t t\225\186\183ng 6000 KC"
  },
  {
    id = 10013,
    goalId = 1606013,
    describe = "T\195\173ch n\225\186\161p 4388 VN\196\144\nCao nh\225\186\165t t\225\186\183ng 6000 KC"
  },
  {
    id = 10014,
    goalId = 1606014,
    describe = "T\195\173ch n\225\186\161p 4888 VN\196\144\nCao nh\225\186\165t t\225\186\183ng 6000 KC"
  }
}
local defaults = {
  overviewId = 30031,
  giftId = 1000050,
  range = "3000#6000",
  turntable = "4"
}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Commerce_Rebate) do
  setmetatable(v, mt)
end
return cfg_Commerce_Rebate
