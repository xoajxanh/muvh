local cfg_Stronger = {
  [1] = {
    id = 1,
    condition = "2401#4010109#0",
    parameter = "4012000",
    order = 1
  },
  [2] = {
    id = 2,
    condition = "2401#4010110#0&2402#4010109#1",
    parameter = "4012002",
    order = 1
  },
  [3] = {
    id = 3,
    condition = "2401#4010111#0&2402#4010110#1",
    parameter = "4012001",
    order = 1
  },
  [4] = {
    id = 4,
    picture = "stronger_2",
    text = "T\196\131ng Gi\225\186\163m DMG",
    condition = "2402#4010111#1",
    parameter = "2540003",
    order = 3
  },
  [5] = {
    id = 5,
    picture = "stronger_3",
    text = "T\196\131ng DMG",
    condition = "2402#4010111#1",
    parameter = "2540002",
    order = 4
  },
  [6] = {
    id = 6,
    condition = "2402#4010111#1",
    parameter = "2540001",
    order = 2
  }
}
local defaults = {
  picture = "stronger_1",
  text = "T\196\131ng Ph\195\178ng Th\225\187\167",
  event = "1"
}
local mt = {__index = defaults}
for _, v in pairs(cfg_Stronger) do
  setmetatable(v, mt)
end
return cfg_Stronger
