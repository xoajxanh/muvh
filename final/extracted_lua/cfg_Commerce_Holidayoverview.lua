local cfg_Commerce_Holidayoverview = {
  [323] = {
    activityId = 323,
    HolidayActivityName = "D\225\187\177 \196\144o\195\161n C\195\186p Th\225\186\191 Gi\225\187\155i",
    commerceId = 45001,
    order = 1,
    redpointid = 96
  },
  [328] = {
    activityId = 328,
    HolidayActivityName = "Qu\195\160 T\225\186\183ng 7 Ng\195\160y",
    commerceId = 30020,
    order = 2,
    redpointid = 97
  },
  [325] = {
    activityId = 325,
    HolidayActivityName = "\196\144\196\131ng Nh\225\186\173p Nh\225\186\173n Qu\195\160",
    commerceId = 30017,
    order = 3,
    redpointid = 98
  },
  [326] = {
    activityId = 326,
    HolidayActivityName = "T\225\186\167m B\225\186\163o Ph\195\161o ",
    commerceId = 30018,
    order = 4,
    redpointid = 99
  },
  [327] = {
    activityId = 327,
    HolidayActivityName = "Th\225\187\143 Ng\225\187\141c T\225\186\165n C\195\180ng",
    commerceId = 30019,
    order = 5,
    redpointid = 100
  },
  [332] = {
    activityId = 332,
    HolidayActivityName = "Ho\195\160n Tr\225\186\163 May M\225\186\175n",
    commerceId = 30031,
    order = 6,
    redpointid = 124
  },
  [335] = {
    activityId = 335,
    HolidayActivityName = "Quay Tr\225\187\169ng KC",
    commerceId = 36001,
    order = 7,
    redpointid = 121
  },
  [334] = {
    activityId = 334,
    HolidayActivityName = "\196\144\225\186\167u T\198\176 Ng\195\160y L\225\187\133",
    commerceId = 37001,
    order = 8,
    redpointid = 122
  },
  [333] = {
    activityId = 333,
    HolidayActivityName = "Qu\195\160 T\225\186\183ng K\225\186\191t N\225\187\145i",
    commerceId = 35001,
    order = 9,
    redpointid = 123
  },
  [337] = {
    activityId = 337,
    HolidayActivityName = "Gi\225\187\143 H\195\160ng \196\144i\195\170n Cu\225\187\147ng",
    commerceId = 39001,
    order = 10,
    redpointid = 0
  }
}
local defaults = {
  hide = 1,
  countdownText = "<color=#1add1f>Th\225\187\157i gian c\195\178n: %s</color>"
}
local mt = {__index = defaults}
for _, v in pairs(cfg_Commerce_Holidayoverview) do
  setmetatable(v, mt)
end
return cfg_Commerce_Holidayoverview
