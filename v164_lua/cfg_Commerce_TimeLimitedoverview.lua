local cfg_Commerce_TimeLimitedoverview = {
  {
    activityId = 302,
    combineActivityName = "<color=#1add1f>Qu\195\160 \198\175u \196\144\195\163i</color> <color=#FF2323>(Ch\225\187\137 1 ng\195\160y)</color>",
    commerceId = 60001,
    order = 1,
    redpointid = 0
  },
  {
    activityId = 304,
    combineActivityName = "<color=#1add1f>BOSS Tr\195\185ng Sinh</color> <color=#FF2323>(Ch\225\187\137 1 ng\195\160y)</color>",
    commerceId = 60002,
    order = 2,
    redpointid = 0
  },
  {
    activityId = 306,
    combineActivityName = "<color=#1add1f>Gh\195\169p Ch\225\187\175 Nh\225\186\173n Qu\195\160</color> <color=#FF2323>(Ch\225\187\137 1 ng\195\160y)</color>",
    commerceId = 60003,
    order = 3,
    redpointid = 110
  },
  {
    activityId = 330,
    combineActivityName = "<color=#1add1f>Qu\195\160 \198\175u \196\144\195\163i 2</color> <color=#FF2323>(Ch\225\187\137 1 ng\195\160y)</color>",
    commerceId = 60004,
    order = 4,
    redpointid = 0
  },
  {
    activityId = 331,
    combineActivityName = "\196\144\225\186\167u T\198\176 M\225\187\159 SV",
    commerceId = 60005,
    order = 5,
    redpointid = 111,
    rechargeId = {1900001, 1900002}
  },
  {
    activityId = 320,
    combineActivityName = "Chi\225\186\191n L\225\187\135nh K\225\187\179 T\195\173ch",
    commerceId = {
      60006,
      60016,
      60026,
      60036,
      60046,
      60056,
      60066,
      60076,
      60086,
      60096,
      60106,
      60116,
      60126,
      60136,
      60146,
      60156,
      60166,
      60176,
      60186,
      60196,
      60206,
      60216,
      60226,
      60236,
      60246,
      60256,
      60266,
      60276,
      60286,
      60296,
      60306,
      60316,
      65006,
      65016,
      65026,
      65036,
      65046,
      65056,
      65066,
      65076,
      65086,
      65096,
      65106,
      65116,
      65126,
      65136,
      65146,
      65156,
      65166,
      65176,
      65186,
      65196,
      65206,
      65216,
      65226,
      65236,
      65246,
      65256,
      65266,
      65276,
      65286,
      65296,
      65306
    },
    order = 6,
    redpointid = 112
  }
}
local defaults = {
  hide = 1,
  countdownText = "<color=#1add1f>Th\225\187\157i gian c\195\178n: %s</color>",
  rechargeId = 0,
  Text = ""
}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Commerce_TimeLimitedoverview) do
  setmetatable(v, mt)
end
return cfg_Commerce_TimeLimitedoverview
