local cfg_Monster_randomBorn = {
  {
    id = 109181,
    name = "BOSS Lv300 1"
  },
  {
    id = 109182,
    name = "BOSS Lv300 2"
  },
  {
    id = 109183,
    name = "BOSS Lv350 1"
  },
  {
    id = 109184,
    name = "BOSS Lv350 2"
  }
}
local defaults = {
  mapId = 1091,
  position = "84#114&32#29&56#58&82#24&96#72&130#34&122#9&132#72&166#52&230#122&166#114&247#169&182#154&230#211&194#182&180#237&158#180&129#223&124#184&80#219&86#185&33#214&10#193&61#165&37#117&7#142&16#92&200#31&225#58&233#82"
}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Monster_randomBorn) do
  setmetatable(v, mt)
end
return cfg_Monster_randomBorn
