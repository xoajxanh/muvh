local cfg_Activity_lively = {
  [1001] = {
    id = 1001,
    goalId = 8000008,
    times = 1,
    getLively = 20,
    sort = 6,
    showIcon = "ac_hjg",
    showName = "boss Guild",
    showDesc = "Tham gia 1 l\225\186\167n <color=#3CD937>BOSS Guild</color>",
    toFunction = "4010003",
    functionId = 10030003,
    showRequire = "C\225\186\165p \196\145\225\186\161t 100 s\225\186\189 m\225\187\159"
  },
  [1002] = {
    id = 1002,
    goalId = 8000002,
    times = 10,
    sort = 5,
    showIcon = "ac_ywboss",
    showName = "BOSS d\195\163 ngo\225\186\161i",
    showDesc = "Ti\195\170u di\225\187\135t 1 l\225\186\167n <color=#3CD937>BOSS Hoang D\195\163</color>",
    toFunction = "2440101",
    functionId = 2440002,
    showRequire = "C\225\186\165p \196\145\225\186\161t Lv40 s\225\186\189 m\225\187\159 "
  },
  [1003] = {
    id = 1003,
    goalId = 8000003,
    sort = 2,
    showIcon = "ac_grboss",
    showName = "BOSS Ph\195\186c L\225\187\163i",
    showDesc = "Ti\195\170u di\225\187\135t 1 l\225\186\167n <color=#3CD937>BOSS Ph\195\186c L\225\187\163i</color>",
    toFunction = "2440702",
    functionId = 2440007,
    showRequire = "C\225\186\165p \196\145\225\186\161t Lv30 s\225\186\189 m\225\187\159 "
  },
  [1004] = {
    id = 1004,
    goalId = 8000004,
    sort = 3,
    showIcon = "ac_xscb",
    showName = "Huy\225\186\191t L\195\162u",
    showDesc = "Ho\195\160n th\195\160nh 1 l\225\186\167n <color=#3CD937>Huy\225\186\191t L\195\162u</color>",
    toFunction = "-1",
    functionId = 4020301,
    showRequire = "Ho\195\160n th\195\160nh Nhi\225\187\135m V\225\187\165 Nh\195\161nh t\198\176\198\161ng \225\187\169ng"
  },
  [1005] = {
    id = 1005,
    goalId = 8000005,
    sort = 4,
    showIcon = "ac_emgc",
    showName = "Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183",
    showDesc = "Ho\195\160n th\195\160nh 1 l\225\186\167n <color=#3CD937>Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183</color>",
    toFunction = "-1",
    functionId = 4020201,
    showRequire = "C\225\186\165p \196\145\225\186\161t Lv60 s\225\186\189 m\225\187\159 "
  },
  [1006] = {
    id = 1006,
    goalId = 8000006,
    sort = 1,
    showIcon = "ac_ysrw",
    showName = "Nhi\225\187\135m V\225\187\165 D\197\169ng S\196\169",
    showDesc = "Ho\195\160n th\195\160nh 1 l\225\186\167n <color=#3CD937>Nhi\225\187\135m V\225\187\165 D\197\169ng S\196\169</color>",
    toFunction = "2480100",
    functionId = 2480001,
    showRequire = "C\225\186\165p \196\145\225\186\161t Lv110 m\225\187\159"
  },
  [1007] = {
    id = 1007,
    goalId = 8000009,
    times = 1,
    getLively = 20,
    sort = 7,
    showIcon = "ac_hllx",
    showName = "H\225\187\143a Long T\225\186\173p K\195\173ch",
    showDesc = "Tham gia 1 l\225\186\167n <color=#3CD937>H\225\187\143a Long T\225\186\173p K\195\173ch</color>",
    toFunction = "4010003",
    functionId = 4021001,
    showRequire = "C\225\186\165p \196\145\225\186\161t 100 s\225\186\189 m\225\187\159"
  }
}
local defaults = {
  times = 3,
  getLively = 5,
  type = 1
}
local mt = {__index = defaults}
for _, v in pairs(cfg_Activity_lively) do
  setmetatable(v, mt)
end
return cfg_Activity_lively
