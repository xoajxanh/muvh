local cfg_Map_headSculpture = {
  [0] = {
    id = 0,
    name = "ico_firend",
    size = {14, 24}
  },
  [1] = {id = 1, name = "ico_kltbox"},
  [2] = {id = 2, name = "ico_kltbox"},
  [3] = {
    id = 3,
    name = "ico_boss2",
    size = {28, 47},
    textShow = 0,
    color = ""
  },
  [4] = {
    id = 4,
    name = "ico_kltbox_yin"
  },
  [5] = {
    id = 5,
    name = "ico_kltbox_yin"
  },
  [6] = {
    id = 6,
    name = "ico_shuaguaidian",
    size = {12, 12},
    textShow = 0,
    color = ""
  }
}
local defaults = {
  size = {38, 30},
  textShow = 1,
  distance = 125,
  color = "<color=#2BBDFF>%s</color> ",
  textSize = 16
}
local mt = {__index = defaults}
for _, v in pairs(cfg_Map_headSculpture) do
  setmetatable(v, mt)
end
return cfg_Map_headSculpture
