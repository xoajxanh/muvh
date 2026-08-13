local cfg_Team3v3_Show = {
  {
    id = 1,
    itemId = "55110011#55120011#55130011#55140011#55160011"
  },
  {
    id = 2,
    itemId = "55110011#55120121#55130121#55140011#55160121",
    show = "11#0&12#1&13#1&14#0&16#1"
  },
  {
    id = 3,
    itemId = "55110211#55120211#55130211#55140211#55160211"
  },
  {
    id = 4,
    itemId = "55110411#55120411#55130411#55140411#55160411"
  },
  {
    id = 5,
    itemId = "55110511#55120511#55130511#55140511#55160511"
  },
  {
    id = 6,
    itemId = "55110611#55120611#55130611#55140611#55160611"
  },
  {
    id = 7,
    itemId = "55110311#55120311#55130311#55140311#55160311"
  },
  {
    id = 8,
    type = 2,
    itemId = "2220919#1",
    show = "",
    suitType = 0,
    showRate = "15",
    rewardName = "Tinh Uy\195\170n Th\198\176\198\161ng Long"
  }
}
local defaults = {
  type = 1,
  show = "11#1&12#1&13#1&14#1&16#1",
  suitType = 1,
  showRate = "0.8",
  rewardName = "Tinh Uy\195\170n B\195\173ch L\197\169y"
}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Team3v3_Show) do
  setmetatable(v, mt)
end
return cfg_Team3v3_Show
