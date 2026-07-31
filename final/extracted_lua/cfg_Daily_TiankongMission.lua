local cfg_Daily_TiankongMission = {
  {
    id = 101,
    type = 1,
    mission = 101401,
    description = "Di\225\187\135t 10 Kh\195\180 L\195\162u Binh"
  },
  {
    id = 102,
    type = 1,
    mission = 101402,
    description = "Di\225\187\135t 10 Qu\195\161i Tr\195\162u D\225\187\175"
  },
  {
    id = 103,
    type = 1,
    mission = 101403,
    description = "Di\225\187\135t 10 Ng\198\176\225\187\157i \196\144\195\161 Kh\225\187\149ng L\225\187\147"
  },
  {
    id = 104,
    type = 1,
    mission = 101406,
    description = "Di\225\187\135t 10 Ng\198\176\225\187\157i Tuy\225\186\191t"
  },
  {
    id = 105,
    type = 1,
    mission = 101407,
    description = "Di\225\187\135t 10 Vua Ng\198\176\225\187\157i Tuy\225\186\191t"
  },
  {
    id = 106,
    type = 1,
    mission = 101408,
    description = "Di\225\187\135t 10 Qu\195\161i Ch\195\179 S\196\131n \196\144\225\187\139a Ng\225\187\165c"
  },
  {
    id = 107,
    type = 1,
    mission = 101409,
    description = "Di\225\187\135t 10 Nh\225\187\135n \196\144\225\187\139a Ng\225\187\165c"
  },
  {
    id = 108,
    type = 1,
    mission = 101410,
    description = "Di\225\187\135t 10 Chi\225\186\191n S\196\169 Kh\195\180 L\195\162u"
  },
  {
    id = 109,
    type = 1,
    mission = 101411,
    description = "Di\225\187\135t 10 Vu S\198\176 T\225\187\173 Linh"
  },
  {
    id = 110,
    type = 1,
    mission = 101412,
    description = "Di\225\187\135t 10 K\225\187\181 S\196\169 B\195\179ng T\225\187\145i"
  },
  {
    id = 121,
    mission = 101405,
    description = "Di\225\187\135t 10 con Nh\225\187\135n"
  },
  {
    id = 112,
    mission = 101414,
    description = "Di\225\187\135t 10 Qu\225\187\183 M\225\187\139 K\225\187\139ch \196\144\225\187\153c",
    reward = 700004
  },
  {
    id = 113,
    mission = 101415,
    description = "Di\225\187\135t 10 Vu S\198\176 Nguy\225\187\129n R\225\187\167a",
    reward = 700004
  },
  {
    id = 114,
    mission = 101416,
    description = "Di\225\187\135t 10 S\195\162u Bi\225\187\131n",
    reward = 700004
  },
  {
    id = 115,
    mission = 101417,
    description = "Di\225\187\135t 10 Qu\195\161i L\198\176ng S\225\186\175t",
    reward = 700004
  },
  {
    id = 116,
    mission = 101418,
    description = "Di\225\187\135t 10 Chi\225\186\191n S\196\169 B\195\161nh Xe S\225\186\175t",
    reward = 700004
  },
  {
    id = 117,
    mission = 1401401,
    description = "Ho\195\160n th\195\160nh 2 l\225\186\167n Qu\225\186\163ng Tr\198\176\225\187\157ng Qu\225\187\183",
    reward = 700004
  },
  {
    id = 118,
    mission = 1401402,
    description = "Ho\195\160n th\195\160nh 2 l\225\186\167n Huy\225\186\191t L\195\162u",
    reward = 700004
  },
  {
    id = 119,
    mission = 101404,
    description = "Ti\195\170u di\225\187\135t t\195\173ch l\197\169y 100 con Qu\195\161i",
    reward = 700004
  },
  {
    id = 120,
    mission = 102401,
    description = "Ti\195\170u di\225\187\135t 10 con BOSS b\225\186\165t k\225\187\179",
    reward = 700004
  },
  {
    id = 111,
    mission = 101413,
    description = "Ti\195\170u di\225\187\135t 10 con Gordon Ma Qu\225\187\183",
    reward = 700004
  }
}
local defaults = {
  type = 2,
  reward = 700003,
  weight = 1
}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Daily_TiankongMission) do
  setmetatable(v, mt)
end
return cfg_Daily_TiankongMission
