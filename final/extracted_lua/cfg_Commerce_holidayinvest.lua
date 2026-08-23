local cfg_Commerce_holidayinvest = {
  {
    id = 1,
    description = "Ho\225\186\161t \196\145\225\187\153ng ng\195\160y 1 c\195\179 th\225\187\131 nh\225\186\173n",
    day = 1
  },
  {
    id = 2,
    description = "Ho\225\186\161t \196\145\225\187\153ng ng\195\160y 2 c\195\179 th\225\187\131 nh\225\186\173n",
    day = 2
  },
  {
    id = 3,
    description = "Ho\225\186\161t \196\145\225\187\153ng ng\195\160y 3 c\195\179 th\225\187\131 nh\225\186\173n",
    day = 3
  },
  {
    id = 4,
    description = "Ho\225\186\161t \196\145\225\187\153ng ng\195\160y 4 c\195\179 th\225\187\131 nh\225\186\173n",
    day = 4
  },
  {
    id = 5,
    description = "Ho\225\186\161t \196\145\225\187\153ng ng\195\160y 5 c\195\179 th\225\187\131 nh\225\186\173n",
    reward = "52206063#18&1000021#200000",
    day = 5
  },
  {
    id = 6,
    description = "Ho\225\186\161t \196\145\225\187\153ng ng\195\160y 1 c\195\179 th\225\187\131 nh\225\186\173n",
    reward = "6000111#30&6004021#200",
    position = 2,
    day = 1
  },
  {
    id = 7,
    description = "Ho\225\186\161t \196\145\225\187\153ng ng\195\160y 2 c\195\179 th\225\187\131 nh\225\186\173n",
    reward = "6000111#30&6004021#200",
    position = 2,
    day = 2
  },
  {
    id = 8,
    description = "Ho\225\186\161t \196\145\225\187\153ng ng\195\160y 3 c\195\179 th\225\187\131 nh\225\186\173n",
    reward = "6000111#30&6004021#200",
    position = 2,
    day = 3
  },
  {
    id = 9,
    description = "Ho\225\186\161t \196\145\225\187\153ng ng\195\160y 4 c\195\179 th\225\187\131 nh\225\186\173n",
    reward = "6000111#30&6004021#200",
    position = 2,
    day = 4
  },
  {
    id = 10,
    description = "Ho\225\186\161t \196\145\225\187\153ng ng\195\160y 5 c\195\179 th\225\187\131 nh\225\186\173n",
    reward = "6000111#60&6004021#400",
    position = 2,
    day = 5
  }
}
local defaults = {
  mission = 503019,
  frequency = 1,
  reward = "52206063#8&1000021#100000",
  commerceId = 37001,
  position = 1
}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Commerce_holidayinvest) do
  setmetatable(v, mt)
end
return cfg_Commerce_holidayinvest
