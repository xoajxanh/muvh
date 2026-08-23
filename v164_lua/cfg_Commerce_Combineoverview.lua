local cfg_Commerce_Combineoverview = {
  {
    activityId = 320,
    combineActivityName = "Chi\225\186\191n L\225\187\135nh K\225\187\179 T\195\173ch",
    commerceId = 40001,
    order = 1,
    redpointid = 95
  },
  {
    activityId = 100,
    combineActivityName = "G\195\179i G\225\187\153p Server ",
    commerceId = 41001,
    order = 2,
    redpointid = 0
  },
  {
    activityId = 321,
    combineActivityName = "X\225\186\191p H\225\186\161ng T\195\173ch Ti\195\170u",
    commerceId = 42001,
    order = 3,
    redpointid = 0
  },
  {
    activityId = 307,
    combineActivityName = "Qu\195\160 N\225\186\161p Li\195\170n T\225\187\165c",
    commerceId = {
      43001,
      43002,
      43003,
      43004,
      43005,
      43006,
      43007,
      43008,
      43009
    },
    order = 4,
    redpointid = 94
  },
  {
    activityId = 322,
    combineActivityName = "Tr\225\187\163 L\225\187\177c G\225\187\153p SV",
    commerceId = 44001,
    order = 5,
    redpointid = 119
  },
  {
    activityId = 330,
    combineActivityName = "C\195\160y Ra K\225\187\179 T\195\173ch",
    commerceId = 44002,
    order = 6,
    redpointid = 120
  }
}
local defaults = {
  hide = 1,
  countdownText = "<color=#1add1f>Th\225\187\157i gian c\195\178n: %s</color>"
}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Commerce_Combineoverview) do
  setmetatable(v, mt)
end
return cfg_Commerce_Combineoverview
