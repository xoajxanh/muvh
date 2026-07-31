local cfg_Activity_findBack = {
  [11001] = {
    id = 11001,
    livelyId = 1001,
    showName = "Di\225\187\135t <color=#3CD937>Nh\225\187\135n</color>",
    showDesc = "Di\225\187\135t <color=#3CD937>Nh\225\187\135n</color>"
  },
  [11002] = {
    id = 11002,
    livelyId = 1002,
    showName = "Di\225\187\135t <color=#3CD937>R\225\187\147ngCon</color>",
    showDesc = "Di\225\187\135t <color=#3CD937>R\225\187\147ngCon</color>"
  },
  [11003] = {
    id = 11003,
    livelyId = 1003,
    showName = "Di\225\187\135t <color=#3CD937>Qu\195\161iTr\195\162u</color>",
    showDesc = "Di\225\187\135t <color=#3CD937>Qu\195\161iTr\195\162u</color>"
  },
  [11004] = {
    id = 11004,
    livelyId = 1004,
    showName = "Di\225\187\135t <color=#3CD937>Qu\195\161i Ch\195\179 S\196\131n</color>",
    showDesc = "Di\225\187\135t <color=#3CD937>Qu\195\161i Ch\195\179 S\196\131n</color>"
  },
  [11005] = {
    id = 11005,
    livelyId = 1005,
    showName = "Di\225\187\135t <color=#3CD937>Qu\195\161iTr\195\162uD\225\187\175</color>",
    showDesc = "Di\225\187\135t <color=#3CD937>Qu\195\161iTr\195\162uD\225\187\175</color>"
  }
}
local defaults = {
  condition = "101#1",
  cost = "1000010#100&1000050#50",
  reward = {491001, 1},
  showIcon = ""
}
local mt = {__index = defaults}
for _, v in pairs(cfg_Activity_findBack) do
  setmetatable(v, mt)
end
return cfg_Activity_findBack
