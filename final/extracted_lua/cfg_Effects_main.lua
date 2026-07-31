local cfg_Effects_main = {
  {
    id = 1,
    name = "tilianzhitaBossrunBg"
  },
  {
    id = 2,
    name = "kalunte30Bg"
  },
  {
    id = 3,
    name = "kalunte10Bg"
  },
  {
    id = 4,
    name = "kaluntereadyBg"
  },
  {
    id = 107,
    name = "Eff_duquanbianjie_yan",
    effectTime = 0,
    blankScreen = 0
  }
}
local defaults = {
  effectTime = 3000,
  blankScreen = 1,
  rotation = "",
  scale = ""
}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Effects_main) do
  setmetatable(v, mt)
end
return cfg_Effects_main
