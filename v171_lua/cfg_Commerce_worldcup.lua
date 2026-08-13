local cfg_Commerce_worldcup = {
  [1] = {
    id = 1,
    time = "Ng\195\160y 2 th\195\161ng 12 03:00",
    cutoffTime = 1669910400,
    redCountry = "Costa Rica",
    redCountryFlag = "country_1",
    blueCountry = "\196\144\225\187\169c",
    blueCountryFlag = "country_5",
    winReward = "241910001#1"
  },
  [2] = {
    id = 2,
    time = "Ng\195\160y 2 th\195\161ng 12 03:00",
    cutoffTime = 1669910400,
    redCountry = "Nh\225\186\173t B\225\186\163n",
    redCountryFlag = "country_2",
    blueCountry = "T\195\162y Ban Nha",
    blueCountryFlag = "country_6",
    winReward = "241910002#1"
  },
  [3] = {
    id = 3,
    time = "Ng\195\160y 3 th\195\161ng 12 03:00",
    cutoffTime = 1669996800,
    redCountry = "Serbia",
    redCountryFlag = "country_3",
    blueCountry = "Th\225\187\165y S\196\169",
    blueCountryFlag = "country_7",
    winReward = "241910003#1"
  },
  [4] = {
    id = 4,
    time = "Ng\195\160y 3 th\195\161ng 12 03:00",
    cutoffTime = 1669996800,
    redCountry = "Cameroon",
    redCountryFlag = "country_4",
    blueCountry = "Brazil",
    blueCountryFlag = "country_8",
    winReward = "241910004#1"
  }
}
local defaults = {
  loseRewardPrice = "1000030#158",
  group = 45001
}
local mt = {__index = defaults}
for _, v in pairs(cfg_Commerce_worldcup) do
  setmetatable(v, mt)
end
return cfg_Commerce_worldcup
