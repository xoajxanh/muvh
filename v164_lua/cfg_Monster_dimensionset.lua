local cfg_Monster_dimensionset = {
  {id = "71"},
  {id = "72"},
  {id = "73"},
  {id = "81"},
  {id = "82"},
  {id = "83"},
  {id = "91"},
  {id = "92"},
  {id = "93"},
  {id = "101"},
  {id = "102"},
  {id = "103"},
  {id = "111"},
  {id = "112"},
  {id = "113"},
  {id = "121"},
  {id = "122"},
  {id = "123"},
  {id = "131"},
  {id = "132"},
  {id = "133"},
  {id = "141"},
  {id = "142"},
  {id = "143"},
  {id = "151"},
  {id = "152"},
  {id = "153"},
  {id = "161"},
  {id = "162"},
  {id = "163"}
}
local defaults = {count = 2240000, countOther = 2240001}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Monster_dimensionset) do
  setmetatable(v, mt)
end
return cfg_Monster_dimensionset
